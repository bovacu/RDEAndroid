package com.rde.app;

import android.content.pm.ActivityInfo;
import android.os.Bundle;
import android.view.WindowManager;

//import com.google.android.gms.ads.MobileAds;
import org.libsdl.app.SDLActivity;

public class MainActivity extends SDLActivity {
    @Override
    protected String[] getLibraries() {
        return new String[]{
                "SDL3",
                "EGL",
                "cglm",
                "GLESv3",
                "RDEAndroidApp"
        };
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
	    System.out.println("Entering on MainActivity onCreate");
        super.onCreate(savedInstanceState);
        setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
//FIREBASE_INIT
    }

//FIREBASE_DEFINE
}