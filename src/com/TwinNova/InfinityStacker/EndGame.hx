package com.twinnova.infinitystacker;
import flash.display.Sprite;
import flash.text.TextFormat;
import nme.Lib;
import nme.Assets;
import nme.text.NMEFont;
import nme.text.TextField;
import flash.events.MouseEvent;
/**
 * ...
 * @author Vincent Quigley
 */

class EndGame extends Sprite
{
	var screenBackground:Sprite;
	var format:TextFormat;
	var score:Int;
	var restartGame:Bool = false;
	
	public function new(ascore:Int) 
	{
		super();
		score = ascore;
		var font = Assets.getFont ("font/Galliard Bold.ttf");
		format = new TextFormat (font.fontName, 30, 0xFFFF00);
		loadScreen();
	}
	
	public static function scale(length:Float):Float
	{
		return Global.Instance().scale(length);
	}
	
	public function loadScreen()
	{
		screenBackground = new Sprite();
		screenBackground.graphics.lineStyle(1, 0xff0000, 1);
		screenBackground.graphics.beginFill(0x677777, 1);
		screenBackground.graphics.drawRect(	 0, 
											 0, 
											 Global.Instance().width() * 0.8, 
											 Global.Instance().height()  * 0.8);
		
		screenBackground.x = (Lib.current.stage.stageWidth - (Global.Instance().width() * 0.8)) / 2;
		screenBackground.y = (Lib.current.stage.stageHeight - (Global.Instance().height() * 0.8)) / 2;
		
		addChild(screenBackground);
		
		format.size = 22;
		format.color = 0xFFFF00;
		screenBackground.addChild(textField("GAME OVER", 50, 50, 300, 100));
		
		format.size = 22;
		format.color = 0x0000FF;
		screenBackground.addChild(textField("You got to level", 50, 150, 300, 100));
		
		format.size = 32;
		format.color = 0xFFFFFF;
		var scoreText:TextField = textField(Std.string(score), 50, 250, 300, 100);
		screenBackground.addChild(scoreText);
		
		screenBackground.addChild(restartButton());
	}
	
	public function restartButton():Button
	{
		var but = new Button(100, 100);
	    but.addEventListener(MouseEvent.MOUSE_DOWN, setRestartGame, false, 100);
		
		but.x = scale(100);
		but.y = scale(350);
		

		return but;
	}
	
	function setRestartGame(e:MouseEvent):Void
	{
		restartGame = true;
	}
	
	public function textField(text:String, x, y, w, h)
	{
		var textField = new  TextField();
		textField.defaultTextFormat = format;
		textField.selectable = false;
		textField.embedFonts = true;
		
		textField.width = scale(w);
		textField.height = scale(h);
		textField.x = scale(x);
		textField.y = scale(y);
		 
		textField.text = text;
		return textField;
	}
	
	public function doRestartGame():Bool
	{
		return restartGame;
	}
	
	public function resumeGame():Bool
	{
		return false;
	}
}