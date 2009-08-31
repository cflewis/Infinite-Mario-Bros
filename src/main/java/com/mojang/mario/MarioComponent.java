package com.mojang.mario;

import java.awt.*;
import java.awt.event.FocusEvent;
import java.awt.event.FocusListener;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.awt.image.*;
import java.util.Random;

import javax.sound.sampled.LineUnavailableException;
import javax.swing.*;

import com.mojang.mario.sprites.*;
import com.mojang.sonar.FakeSoundEngine;
import com.mojang.sonar.SonarSoundEngine;


public class MarioComponent extends JComponent implements Runnable, KeyListener, FocusListener
{
    private static final long serialVersionUID = 739318775993206607L;
    public static final int TICKS_PER_SECOND = 24;

    private boolean running = false;
    private int width, height;
    private GraphicsConfiguration graphicsConfiguration;
    private Scene scene;
    private SonarSoundEngine sound;
    @SuppressWarnings("unused")
	private boolean focused = false;
    private boolean useScale2x = false;
    private MapScene mapScene;
    int delay;

    private Scale2x scale2x = new Scale2x(320, 240);

    public MarioComponent(int width, int height)
    {
        this.setFocusable(true);
        this.setEnabled(true);
        this.width = width;
        this.height = height;

        Dimension size = new Dimension(width, height);
        setPreferredSize(size);
        setMinimumSize(size);
        setMaximumSize(size);

        try
        {
            sound = new SonarSoundEngine(64);
        }
        catch (LineUnavailableException e)
        {
            e.printStackTrace();
            sound = new FakeSoundEngine();
        }

        setFocusable(true);
    }

    private void toggleKey(int keyCode, boolean isPressed)
    {
        if (keyCode == KeyEvent.VK_LEFT)
        {
            scene.toggleKey(Mario.KEY_LEFT, isPressed);
        }
        if (keyCode == KeyEvent.VK_RIGHT)
        {
            scene.toggleKey(Mario.KEY_RIGHT, isPressed);
        }
        if (keyCode == KeyEvent.VK_DOWN)
        {
            scene.toggleKey(Mario.KEY_DOWN, isPressed);
        }
        if (keyCode == KeyEvent.VK_UP)
        {
            scene.toggleKey(Mario.KEY_UP, isPressed);
        }
        if (keyCode == KeyEvent.VK_A)
        {
            scene.toggleKey(Mario.KEY_SPEED, isPressed);
        }
        if (keyCode == KeyEvent.VK_S)
        {
            scene.toggleKey(Mario.KEY_JUMP, isPressed);
        }
        if (isPressed && keyCode == KeyEvent.VK_F1)
        {
            useScale2x = !useScale2x;
        }
    }

    public void paint(Graphics g)
    {
    }

    public void update(Graphics g)
    {
    }

    public void start()
    {
        if (!running)
        {
            running = true;
            new Thread(this, "Game Thread").start();
        }
    }

    public void stop()
    {
        Art.stopMusic();
        running = false;
    }

    public void run()
    {
        graphicsConfiguration = getGraphicsConfiguration();

        //      scene = new LevelScene(graphicsConfiguration);
        mapScene = new MapScene(graphicsConfiguration, this, new Random().nextLong());
        scene = mapScene;
        scene.setSound(sound);

        Art.init(graphicsConfiguration, sound);

        VolatileImage image = createVolatileImage(320, 240);
        Graphics g = getGraphics();
        Graphics og = image.getGraphics();

        int renderedFrames = 0;

        double time = System.nanoTime() / 1000000000.0;
        double now = time;
        long tm = System.currentTimeMillis();
        long lTick = tm;

        addKeyListener(this);
        addFocusListener(this);

        toTitle();
        adjustFPS();

        while (running)
        {
//            double lastTime = time;
//            time = System.nanoTime() / 1000000000.0;
//            double passedTime = time - lastTime;
//
//            if (passedTime < 0) naiveTiming = false; // Stop relying on nanotime if it starts skipping around in time (ie running backwards at least once). This sometimes happens on dual core amds.
//            averagePassedTime = averagePassedTime * 0.9 + passedTime * 0.1;
//
//            if (naiveTiming)
//            {
//                now = time;
//            }
//            else
//            {
//                now += averagePassedTime;
//            }
//
//            int tick = (int) (now * TICKS_PER_SECOND);
//            if (lastTick == -1) lastTick = tick;

                scene.tick();
//                lastTick++;
//
//                if (lastTick % TICKS_PER_SECOND == 0)
//                {
//                    fps = renderedFrames;
//                    renderedFrames = 0;
//                }

            float alpha = (float) (System.currentTimeMillis() - lTick);
            sound.clientTick(alpha);

            @SuppressWarnings("unused")
			int x = (int) (Math.sin(now) * 16 + 160);
            @SuppressWarnings("unused")
			int y = (int) (Math.cos(now) * 16 + 120);

            //og.setColor(Color.WHITE);
            og.fillRect(0, 0, 320, 240);

            alpha = 0;
            scene.render(og, alpha);

            if (!this.hasFocus() && lTick/4%2==0)
            {
                String msg = "CLICK TO PLAY";

                drawString(og, msg, 160 - msg.length() * 4 + 1, 110 + 1, 0);
                drawString(og, msg, 160 - msg.length() * 4, 110, 7);
            }
            og.setColor(Color.BLACK);
            /*          drawString(og, "FPS: " + fps, 5, 5, 0);
             drawString(og, "FPS: " + fps, 4, 4, 7);*/

            if (width != 320 || height != 240)
            {
                if (useScale2x)
                {
                    g.drawImage(scale2x.scale(image), 0, 0, null);
                }
                else
                {
                    g.drawImage(image, 0, 0, 640, 480, null);
                }
            }
            else
            {
                g.drawImage(image, 0, 0, null);
            }
            
            if (delay > 0)
                try {
                    tm += delay;
                    Thread.sleep(Math.max(0, tm - System.currentTimeMillis()));
                } catch (InterruptedException e) {
                    break;
                }

            renderedFrames++;
        }

        Art.stopMusic();
    }

    private void drawString(Graphics g, String text, int x, int y, int c)
    {
        char[] ch = text.toCharArray();
        for (int i = 0; i < ch.length; i++)
        {
            g.drawImage(Art.font[ch[i] - 32][c], x + i * 8, y, null);
        }
    }

    public void keyPressed(KeyEvent arg0)
    {
        toggleKey(arg0.getKeyCode(), true);
    }

    public void keyReleased(KeyEvent arg0)
    {
        toggleKey(arg0.getKeyCode(), false);
    }

    public void startLevel(long seed, int difficulty, int type)
    {
        scene = new LevelScene(graphicsConfiguration, this, seed, difficulty, type);
        scene.setSound(sound);
        scene.init();
    }

    public void levelFailed()
    {
        scene = mapScene;
        mapScene.startMusic();
        Mario.lives--;
        if (Mario.lives == 0)
        {
            lose();
        }
    }

    public void keyTyped(KeyEvent arg0)
    {
    }

    public void focusGained(FocusEvent arg0)
    {
        focused = true;
    }

    public void focusLost(FocusEvent arg0)
    {
        focused = false;
    }

    public void levelWon()
    {
        scene = mapScene;
        mapScene.startMusic();
        mapScene.levelWon();
    }
    
    public void win()
    {
        scene = new WinScene(this);
        scene.setSound(sound);
        scene.init();
    }
    
    public void toTitle()
    {
        Mario.resetStatic();
        scene = new TitleScene(this, graphicsConfiguration);
        scene.setSound(sound);
        scene.init();
    }
    
    public void lose()
    {
        scene = new LoseScene(this);
        scene.setSound(sound);
        scene.init();
    }

    public void startGame()
    {
        scene = mapScene;
        mapScene.startMusic();
        mapScene.init();
   }
    
    public void adjustFPS() {
        int fps = 24;
        delay = (fps > 0) ? (fps >= 100) ? 0 : (1000 / fps) : 100;
//        System.out.println("Delay: " + delay);
    }
}