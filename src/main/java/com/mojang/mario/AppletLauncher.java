package com.mojang.mario;

import javax.swing.JApplet;


public class AppletLauncher extends JApplet
{
    private static final long serialVersionUID = -2238077255106243788L;

    private MarioComponent mario;
    private boolean started = false;

    public void init()
    {
    	this.setSize(640, 480);
    }

    public void start()
    {
        if (!started)
        {
            started = true;
            mario = new MarioComponent(getWidth(), getHeight());
            setContentPane(mario);
            setFocusable(false);
            mario.setFocusCycleRoot(true);

            mario.start();
//            addKeyListener(mario);
//            addFocusListener(mario);
        }
    }

    public void stop()
    {
        if (started)
        {
            started = false;
            removeKeyListener(mario);
            mario.stop();
            removeFocusListener(mario);
        }
    }
}