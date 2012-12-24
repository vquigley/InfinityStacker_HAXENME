package com.twinnova.infinitystacker;
import flash.display.Sprite;

import nme.Lib;
import nme.display.Bitmap;
import nme.Assets;
import nme.events.MouseEvent;

/**
 * ...
 * @author Vincent Quigley
 */

class GameMenu extends Sprite
{
	var stacker:Stacker;
	
	
	var muteButton:Button = null;
	var unMuteButton:Button = null;
	
	public function new(stacker:Stacker) 
	{
		super();
		
		this.stacker = stacker;
	
		var img:Bitmap = Global.Instance().getBitmap("img/gameMenu.png");
		img.x = 0;
		img.y = 0;
		addChild (img);
		
		addEventListener (MouseEvent.MOUSE_DOWN, stopEvent);
		
		var timerButton = new Button(Global.Instance().getBitmap("img/timerButton.png"));
		timerButton.x = Global.Instance().scale(388);
		timerButton.y = Global.Instance().scale(20);
		timerButton.addEventListener(MouseEvent.MOUSE_DOWN, resetStackerTime, false, 100);		
		
		var plusButton = new Button(Global.Instance().getBitmap("img/plusButton.png"));
		plusButton.x = Global.Instance().scale(309);
		plusButton.y = timerButton.y;
		plusButton.addEventListener(MouseEvent.MOUSE_DOWN, increaseStackerBlocks, false, 100);		
		
		var menuButton = new Button(Global.Instance().getBitmap("img/menuButton.png"));
		menuButton.x = Global.Instance().scale(25);
		menuButton.y = timerButton.y;
		menuButton.addEventListener(MouseEvent.MOUSE_DOWN, goToMainMenu, false, 100);		
		
		addChild(timerButton);
		addChild(plusButton);
		addChild(menuButton);
		
		var blankButton:Bitmap = Global.Instance().getBitmap("img/buttonBlank.png");
		blankButton.x = Global.Instance().scale(100);
		blankButton.y = timerButton.y;
		addChild (blankButton);
		
		
		muteButton = new Button(Global.Instance().getBitmap("img/soundOn.png"));
		
		muteButton.x = blankButton.x + Global.Instance().scale(3);
		muteButton.y = blankButton.y + Global.Instance().scale(10);
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
	
	private function goToMainMenu(e:Dynamic)
	{
		stacker.quit();
		stopEvent(e);
	}
	
	private function resetStackerTime(e:Dynamic)
	{
		stacker.resetTimer();
		stopEvent(e);
	}
	
	private function increaseStackerBlocks(e:Dynamic)
	{
		stacker.increaseBlocks();
		stopEvent(e);
	}
	
	private function stopEvent(e:Dynamic)
	{
		#if cpp
			Reflect.setField(e, "nmeIsCancelled", true);
		#else
			e.stopPropagation();
		#end
	}
}