package com.twinnova.infinitystacker;


import flash.display.DisplayObject;
import nme.events.Event;
import nme.display.Sprite;
import nme.Lib;

/**
 * ...
 * @author Vincent Quigley
 */

class GameState extends Sprite
{
	
	private static var stacker:Stacker;
	private static var endGameScreen:EndGame;	
	private static var startScreen:StartScreen;	
	
	public function new() 
	{
		super();
		showStartScreen();
		//startGame();
	}
	
	private function showStartScreen():Void
	{
		removeEvents();
		clearStage();

		Lib.current.addEventListener(Event.ENTER_FRAME, startFrame);

		startScreen = new StartScreen();
		addToStage(startScreen);
	}
	
	public function startGame():Void
	{
		removeEvents();
		clearStage();
		
		Lib.current.addEventListener(Event.ENTER_FRAME, gameFrame);
		
		stacker = new Stacker();
		addToStage(stacker);
		stacker.start();
	}	
		
	private function showEndScreen()
	{
		removeEvents();
		Lib.current.addEventListener(Event.ENTER_FRAME, endGameFrame);
		
		endGameScreen = new EndGame(stacker.getCurrentRow());
		addToStage(endGameScreen);
	}
	
	public function addToStage(o:DisplayObject)
	{
		Lib.current.addChild(o);
	}
	
	public function clearStage()
	{
		if ((stacker != null) && (Lib.current.contains(stacker) != false))
		{
			Lib.current.removeChild(stacker);
		}
		
		if ((endGameScreen != null) && (Lib.current.contains(endGameScreen) != false))
		{
			Lib.current.removeChild(endGameScreen);
		}
		
		if ((startScreen != null) && (Lib.current.contains(startScreen) != false))
		{
			Lib.current.removeChild(startScreen);
		}
	}
	
	private function removeEvents()
	{
		Lib.current.removeEventListener(Event.ENTER_FRAME, startFrame);
		Lib.current.removeEventListener(Event.ENTER_FRAME, gameFrame);
		Lib.current.removeEventListener(Event.ENTER_FRAME, endGameFrame);
	}
	
	private function startFrame(event:Event):Void {
		if (startScreen.doStartGame() != false)
		{
			startGame();
		}
	}
	
	private function gameFrame(event:Event):Void {
		if (stacker.isEndGame() != false)
		{
			showEndScreen();
		}
	}
	
	private function endGameFrame(event:Event):Void {
		if (endGameScreen.doRestartGame() != false)
		{
			startGame();
		}
		else if (endGameScreen.doMainMenu() != false)
		{
			showStartScreen();
		}
		else if (endGameScreen.resumeGame() != false)
		{
			Lib.current.removeChild(endGameScreen);
			stacker.resumeGame();
		}
	}	
}