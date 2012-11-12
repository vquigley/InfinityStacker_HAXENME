package com.twinnova.infinitystacker;
import flash.display.DisplayObject;
import flash.display.Shape;
import flash.display.SimpleButton;
/**
 * ...
 * @author Vincent Quigley
 */

class ButtonDisplayState extends Shape {
    private var bgColor:Int;
    private var size:Int;

    public function new(bgColor:Int, size:Int) {
        super();
        this.bgColor = bgColor;
        this.size    = size;
        draw();
    }

    private function draw():Void {
        graphics.beginFill(bgColor);
        graphics.drawRect(0, 0, size, size);
        graphics.endFill();
    }
}

class Button extends SimpleButton {
    private static var upColor:Int   = 0xFFCC00;
    private static var overColor:Int = 0xCCFF00;
    private static var downColor:Int = 0x00CCFF;
    private static var size:Int      = 80;

    public function new() {
        super();
        downState      = new ButtonDisplayState(downColor, size);
        overState      = new ButtonDisplayState(overColor, size);
        upState        = new ButtonDisplayState(upColor, size);
        hitTestState   = new ButtonDisplayState(upColor, size);
        
        useHandCursor  = true;
    }
}