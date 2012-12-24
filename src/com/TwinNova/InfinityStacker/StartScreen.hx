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
	var muteButton:Button = null;
	var unMuteButton:Button = null;
	
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
		
		
		muteButton = new Button(Global.Instance().getBitmap("img/soundOn.png"));
		
		muteButton.x = Global.Instance().scale(88);
		muteButton.y = Global.Instance().scale(292);
		addChild(muteButton);
		
		unMuteButton = new Button(Global.Instance().getBitmap("img/soundOff.png"));
		
		unMuteButton.x = muteButton.x;
		unMuteButton.y = muteButton.y;
		
		addChild(unMuteButton);
		
		if (GameState.playSound)
		{
			unmuteGame(null);
		}
		else
		{
			muteGame(null);
		}
	}
	
	function muteGame(e:MouseEvent)
	{
		muteButton.visible = false;
		unMuteButton.visible = true;
		GameState.playSound = false;
		muteButton.removeEventListener(MouseEvent.MOUSE_DOWN, muteGame);
		unMuteButton.addEventListener(MouseEvent.MOUSE_DOWN, unmuteGame, false, 100);
	}
	
	function unmuteGame(e:MouseEvent)
	{
		unMuteButton.visible = false;
		muteButton.visible = true;
		GameState.playSound = true;
		unMuteButton.removeEventListener(MouseEvent.MOUSE_DOWN, unmuteGame);
		muteButton.addEventListener(MouseEvent.MOUSE_DOWN, muteGame, false, 100);
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