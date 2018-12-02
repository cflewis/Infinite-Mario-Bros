package com.mojang.mario;

import java.awt.*;
import javax.swing.*;

public class FrameLauncher
{
    public static void main(String[] args)
    {
		Dimension screenSize = Toolkit.getDefaultToolkit().getScreenSize();
        MarioComponent mario = new MarioComponent(screenSize.width, screenSize.height);
        JFrame frame = new JFrame("Infinite Mario Bros.");
        GraphicsEnvironment env = GraphicsEnvironment.getLocalGraphicsEnvironment(); 
        GraphicsDevice device = env.getDefaultScreenDevice();
        device.setFullScreenWindow(frame);  
       // frame.setExtendedState(JFrame.MAXIMIZED_BOTH);
       // frame.setUndecorated(true);
        frame.setContentPane(mario);
        frame.pack();
        //frame.setResizable(true);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        
        
        frame.setLocation((screenSize.width-frame.getWidth())/2, (screenSize.height-frame.getHeight())/2);
        
        frame.setVisible(true);
        
        mario.start();
//        frame.addKeyListener(mario);
//        frame.addFocusListener(mario);
    }
}
