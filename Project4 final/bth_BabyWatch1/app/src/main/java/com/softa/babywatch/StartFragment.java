package com.softa.babywatch;

import android.media.AudioFormat;
import android.media.AudioRecord;
import android.media.MediaRecorder.AudioSource;
import android.os.Bundle;
import android.os.Handler;
import android.support.v4.app.Fragment;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.softa.babywatch.detectors.BabyDetector;

public class StartFragment extends Fragment {

	TextView text1;
	TextView text2;
	TextView actionText;

	final Handler dBHandler = new Handler();
	private Audio audio;

	boolean recording = false;
	private TextView button;
	private BabyWatchActivity parentActivity;

	//recursive averaging sum
	private double recursiveSum = 0;
	private double oldRecursiveSum = 0;
	final double ALPHA = 0.5;

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container,
			Bundle savedInstanceState) {
		if (container != null) {
			RelativeLayout layout = (RelativeLayout) inflater.inflate(R.layout.activity_baby_watch, container, false);

			button = (TextView) layout.findViewById(R.id.startButton);
			text1 = (TextView) layout.findViewById(R.id.textView1);
			text2 = (TextView) layout.findViewById(R.id.textView2);			

			button.setOnClickListener(new OnClickListener() {

					@Override
				public void onClick(View v) {
					buttonClick();
				}
			});

			return layout;
		} else {
			return null;
		}
	}
	
	private void buttonClick() {
		parentActivity = (BabyWatchActivity) getActivity();
		BabyDetector currentlySelectedDetector = parentActivity.currentlySelectedDetector;
		if (!recording) {
			//parentActivity = (BabyWatchActivity) getActivity();
			//BabyDetector
					currentlySelectedDetector = parentActivity.currentlySelectedDetector;
			audio = new Audio(currentlySelectedDetector);
			audio.start();
			button.setText(R.string.stop);
			recording = true;
			currentlySelectedDetector.setInit(false);
		} else {
			currentlySelectedDetector = parentActivity.currentlySelectedDetector;
			currentlySelectedDetector.reset();
			audio.close();
			button.setText(R.string.start);
			recording = false;
		}
	}
	
	private void wakeUp() {
		parentActivity = (BabyWatchActivity) getActivity();
		BabyDetector currentlySelectedDetector = parentActivity.currentlySelectedDetector;
		currentlySelectedDetector.reset();
		button.setText("Start");
		recording = false;
		parentActivity.currentlySelectedAction.babyAwake(parentActivity);
	}

	/*
	 * Thread to manage live recording/playback of voice input from the device's microphone.
	 */
	private class Audio extends Thread
	{ 
		private boolean stopped = false;
		private BabyDetector detector;
		/**
		 * Give the thread high priority so that it's not canceled unexpectedly, and start it
		 */
		private Audio(BabyDetector detector)
		{ 
			android.os.Process.setThreadPriority(android.os.Process.THREAD_PRIORITY_URGENT_AUDIO);
			this.detector = detector;
		}

		@Override
		public void run()
		{ 
			Log.i("Audio", "Running Audio Thread");
			AudioRecord recorder = null;
			//			short[][]   buffers  = new short[256][160];

			/*
			 * Initialize buffer to hold continuously recorded audio data, start recording, and start
			 * playback.
			 */
			try
			{
				int N = AudioRecord.getMinBufferSize(8000,AudioFormat.CHANNEL_IN_MONO,AudioFormat.ENCODING_PCM_16BIT); /*N:640*/
				recorder = new AudioRecord(AudioSource.MIC, 8000, AudioFormat.CHANNEL_IN_MONO, AudioFormat.ENCODING_PCM_16BIT, N*10);

				recorder.getState();
				recorder.startRecording();

				/*
				 * Loops until something outside of this thread stops it.
				 * Reads the data from the recorder and calculates an average to use in the baby detector.
				 */
				while(!stopped)
				{
					//was 160 now 10
					short[] buffer =  new short[10];
					N = recorder.read(buffer,0,buffer.length);
					double sum = 0;
					for (short val : buffer) {
						sum = sum + Math.abs(val);
					}

					/**
					 * To scale it down, dive by buffer length
					 */
					double average = sum / buffer.length;
					recursiveSum = (ALPHA * oldRecursiveSum) + ((1-ALPHA)*average);
					oldRecursiveSum = recursiveSum;


					final BabyState babyState = detector.updateState(recursiveSum);
					String detecting = "";

					if (babyState == BabyState.AWAKE) {
						stopped = true;
						dBHandler.post(new Runnable() {

							@Override
							public void run() {
								wakeUp();
							}
						});
					}else if (babyState == BabyState.NOISE){
						detecting = " detecting ";
					}else if (babyState == BabyState.SLEEPING){
						detecting = "";
					}

					final String currentLevelText = "Current level    = " + detector.getCurrentLevel() + detecting;
					final String backgroundLevelText;

					if (babyState == BabyState.AWAKE) {
						//backgroundLevelText =  detector.getText2Label();
						backgroundLevelText = "Baby Alarm Detector Triggered!";

					} else if (babyState == BabyState.INIT) {
						backgroundLevelText = "Please wait, Initializing...";
					} else {
						backgroundLevelText = detector.getText2Label() + detector.getBackgroundLevel();
					}

					dBHandler.post(new Runnable() {

						@Override
						public void run() {
							text1.setText(currentLevelText);
							text2.setText(backgroundLevelText);

						}
					});

				}
			}
			catch(Throwable x)
			{ 
				Log.w("Audio", "Error reading voice audio", x);
			}
			/*
			 * Frees the thread's resources after the loop completes so that it can be run again
			 */
			finally
			{ 
				recorder.stop();
				recorder.release();
			}
		}

		/**
		 * Called from outside of the thread in order to stop the recording/playback loop
		 */
		private void close()
		{ 
			stopped = true;
		}

	}

}
