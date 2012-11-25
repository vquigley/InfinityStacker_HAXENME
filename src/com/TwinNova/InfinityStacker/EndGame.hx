package com.twinnova.infinitystacker;
import flash.display.Sprite;
import flash.text.TextFormat;
import nme.Lib;
import nme.Assets;
import nme.text.NMEFont;
import nme.text.TextField;
import flash.events.MouseEvent;
import nme.display.Bitmap;
import nme.Assets;
import nme.text.TextFormatAlign;

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
	var mainMenu:Bool = false;
		
	public function new(ascore:Int) 
	{
		super();
		score = ascore;
		
		x = (Lib.current.stage.stageWidth - Global.Instance().width()) / 2;
		y = (Lib.current.stage.stageHeight - Global.Instance().height()) / 2;
		
		var font = Assets.getFont ("font/Kabel Demi BT.ttf");
		format = new TextFormat (font.fontName, 30, 0xFFFF00);
		loadScreen();
	}
	
	public static function scale(length:Float):Float
	{
		return Global.Instance().scale(length);
	}
	
	public function loadScreen()
	{
		var img = new Bitmap (Assets.getBitmapData ("img/endScreen.png"));
		img.width = Global.Instance().scale(img.width);
		img.height = Global.Instance().scale(img.height);
		img.x = 0;
		img.y = 0;
		
		addChild(img);
		
		format.size = scale(160);
		format.color = 0xFFFFFF;
		format.align = TextFormatAlign.CENTER;
		var scoreText:TextField = textField(Std.string(score), 0, 230, 480, 200);
		addChild(scoreText);
		
		addChild(mainMenuButton());
		addChild(restartButton());
	}
	
	public function mainMenuButton():Button
	{
		var but = new Button(null, 164, 95);
	    but.addEventListener(MouseEvent.MOUSE_DOWN, setMainMenu, false, 100);
		
		but.x = scale(65);
		but.y = scale(438);		

		return but;
	}
	
	public function restartButton():Button
	{
		var but = new Button(null, 164, 95);
	    but.addEventListener(MouseEvent.MOUSE_DOWN, setRestartGame, false, 100);
		
		but.x = scale(242);
		but.y = scale(438);		

		return but;
	}
	
	
	function setRestartGame(e:MouseEvent):Void
	{
		restartGame = true;
	}
	
	function setMainMenu(e:MouseEvent):Void
	{
		mainMenu = true;
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
	
	public function doMainMenu():Bool
	{
		return mainMenu;
	}
	
	public function resumeGame():Bool
	{
		return false;
	}
}