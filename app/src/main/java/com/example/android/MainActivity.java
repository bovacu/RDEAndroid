package com.example.android;

import android.content.pm.ActivityInfo;
import android.os.Bundle;
import android.view.WindowManager;

import com.google.android.gms.ads.MobileAds;
import org.libsdl.app.SDLActivity;

public class MainActivity extends SDLActivity {
    @Override
    protected String[] getLibraries() {
        return new String[]{
                "SDL2",
                "SDL2_mixer",
                "SDL2_net",
                "SDL2_image",
                "EGL",
                "GLESv3",
                "android"
        };
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        System.out.println("Hello world!!");
        setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
        initFireBaseAdds();
    }

    @Override
    protected void finalize() throws Throwable {
        super.finalize();
        destroy();
    }

    public native void initFireBaseAdds();
    public native void destroy();
}