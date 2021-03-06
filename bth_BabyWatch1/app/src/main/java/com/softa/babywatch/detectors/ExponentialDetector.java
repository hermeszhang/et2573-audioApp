package com.softa.babywatch.detectors;

import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.SeekBar;
import android.widget.SeekBar.OnSeekBarChangeListener;
import android.widget.TextView;

import com.softa.babywatch.BabyState;
import com.softa.babywatch.R;

public class ExponentialDetector implements BabyDetector {

	double longAvg = 32768;
	double shortAvg = 0;
	long babyStart = 0;
	double screamTime = 3.0;

	double gammaLong = 0.999;
	double gammaShort = 0.99;

	@Override
	public BabyState updateState(double average) {

		int background = getBackgroundLevel();
		// Returnerar (1-0.999(=0.001) * 32768 ~ 32.768
		shortAvg =  (shortAvg * gammaShort + average);
		// Första iterationen
		// shortAvg = 0 * 0.99 + average = average
		if (average < background) {
		// om in-parametern är större än background noise
			longAvg = (longAvg * gammaShort + average);
			//Räkna om longAvg = 32768 * 0.99 + average
		} else {
			longAvg = (longAvg * gammaLong + average);
			//Räkna om longAvg = 32768 * 0.999 + average
		}
		// om 0.01 * average < background * 5
		if (getCurrentLevel() < background * 5) {
			//starta tiden
			babyStart = System.currentTimeMillis();
			return BabyState.SLEEPING;

		// Om sluttiden - startiden > 3.0 * 1000
		} else if (System.currentTimeMillis() - babyStart > (1000 * screamTime)) { 
			longAvg = 32768;
			shortAvg = 0;
			babyStart = 0;
			return  BabyState.AWAKE;
		} else {
			return BabyState.NOISE;
		}
	}

	@Override
	public short getBackgroundLevel() {
		return  (short) ((1 - gammaLong) * longAvg);
	}

	@Override
	public short getCurrentLevel() {
		return  (short) ((1 - gammaShort) * shortAvg);
	}

	@Override
	public View getConfigurationView(LayoutInflater inflater) {

		View configView = inflater.inflate(R.layout.baby_detector_config, null);
		
		final TextView screamValueLabel = (TextView) configView.findViewById(R.id.screamTimeValue);

		SeekBar bar = (SeekBar) configView.findViewById(R.id.screamBar);
		bar.setProgress((int) (10 * screamTime));
		bar.setOnSeekBarChangeListener(new OnSeekBarChangeListener() {

			@Override
			public void onStopTrackingTouch(SeekBar seekBar) {
				// Do nothing 
			}

			@Override
			public void onStartTrackingTouch(SeekBar seekBar) {
				// Do nothing
			}

			@Override
			public void onProgressChanged(SeekBar seekBar, int progress,
					boolean fromUser) {
				screamTime = progress / 10.0;
				screamValueLabel.setText(screamTime + "s");
			}
		});
		screamValueLabel.setText(screamTime + "s");
		return configView;
	}

	@Override
	public String getDescription() {
		return "Simple baby detector using exponential averages.";
	}
	
	@Override
	public String toString() {
		return "Exponential detector";
	}

    @Override
	public String getText2Label() {
		return "Background level = ";
	}

	@Override
	public Boolean getInit() {
		return null;
	}

	@Override
	public void setInit(Boolean value) {

	}

	@Override
	public void reset() {

	}

}
