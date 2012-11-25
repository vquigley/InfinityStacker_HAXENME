package com.twinnova.infinitystacker;
import flash.display.DisplayObject;
import flash.display.Shape;
import flash.display.SimpleButton;
import flash.display.Sprite;

import nme.display.Bitmap;

/**
 * ...
 * @author Vincent Quigley
 */

class ButtonDisplayState extends Shape {
    private var w:Float;
    private var h:Float;

    public function new(w:Float, h:Float) {
        super();
        this.w    = Global.Instance().scale(w);
		this.h    = Global.Instance().scale(h);
        draw();
    }

    private function draw():Void {
        graphics.beginFill(0xffffff, 0.01);
        graphics.drawRect(0, 0, w, h);
        graphics.endFill();
    }
}

class Button extends SimpleButton {

    public function new(img:Bitmap, ?w:Float, ?h:Float) {
        super();
		if (img == null)
		{
			// Going to phase this out, I don't like it. A button should always have a bitmap.
			downState      = new ButtonDisplayState(w, h);
			overState      = new ButtonDisplayState(w, h);
			upState        = new ButtonDisplayState(w, h);
			hitTestState   = new ButtonDisplayState(w, h);
		}
		else
		{
			downState      = img;
			overState      = img;
			upState        = img;
			hitTestState   = img;
		}
        
        useHandCursor  = true;
    }
}