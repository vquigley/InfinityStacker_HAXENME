package com.twinnova.infinitystacker;
import flash.display.DisplayObject;
import flash.display.Shape;
import flash.display.SimpleButton;
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

    public function new(w:Float, h:Float) {
        super();
        downState      = new ButtonDisplayState(w, h);
        overState      = new ButtonDisplayState(w, h);
        upState        = new ButtonDisplayState(w, h);
        hitTestState   = new ButtonDisplayState(w, h);
        
        useHandCursor  = true;
    }
}