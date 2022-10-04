package com.example.android;

import android.content.pm.ActivityInfo;
import android.os.Bundle;
import android.view.WindowManager;

//import com.google.android.gms.ads.MobileAds;
import org.libsdl.app.SDLActivity;

public class MainActivity extends SDLActivity {
    @Override
    protected String[] getLibraries() {
        return new String[]{
                "SDL2",
                "SDL2_mixer",
                "SDL2_image",
                "EGL",
                "chipmunk",
                "GLESv3",
                "GDEAndroid"
        };
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
//FIREBASE_INIT
    }

//FIREBASE_DEFINE
}