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
		stacker.doStopEvent();
	}
}