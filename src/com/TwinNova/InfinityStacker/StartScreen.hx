package com.twinnova.infinitystacker;
import flash.display.Sprite;
import flash.events.MouseEvent;

import nme.Lib;
import nme.display.Bitmap;
import nme.Assets;

/**
 * ...
 * @author Vincent Quigley
 */

class StartScreen extends Sprite
{
	var startGame:Bool = false;
	
	public function new() 
	{
		super();
		
		x = (Lib.current.stage.stageWidth - Global.Instance().width()) / 2;
		y = (Lib.current.stage.stageHeight - Global.Instance().height()) / 2;
		
		
		var startImg = new Bitmap (Assets.getBitmapData ("img/startScreen.png"));
		startImg.width = Global.Instance().scale(startImg.width);
		startImg.height = Global.Instance().scale(startImg.height);
		startImg.x = 0;
		startImg.y = 0;
		addChild (startImg);
		
		var startButton = new Button(null, 155, 80);
		
		startButton.x = Global.Instance().scale(20);
		startButton.y = Global.Instance().scale(155);
		startButton.addEventListener(MouseEvent.MOUSE_DOWN, setStartGame, false, 100);
		
		addChild(startButton);
	}
	
	function setStartGame(e:MouseEvent):Void
	{
		startGame = true;
	}
	
	public function doStartGame():Bool
	{
		return startGame;
	}
}