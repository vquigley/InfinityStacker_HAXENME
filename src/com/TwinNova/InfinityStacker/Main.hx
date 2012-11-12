package com.twinnova.infinitystacker;
import nme.Lib;
import nme.events.Event;
import nme.display.Sprite;
/**
 * ...
 * @author Vincent Quigley
 */

class Main  extends Sprite 
{
	private static var stacker:Stacker;
	private static var endGameScreen:EndGame;
	
	public static function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = nme.display.StageScaleMode.NO_SCALE;
		stage.align = nme.display.StageAlign.TOP_LEFT;
		
		startGame();
	}
	
	private static function removeEvents()
	{
		Lib.current.removeEventListener(Event.ENTER_FRAME, gameFrame);
		Lib.current.removeEventListener(Event.ENTER_FRAME, endGameFrame);
	}
	
	static function startGame():Void
	{
		removeEvents();
		Lib.current.addEventListener(Event.ENTER_FRAME, gameFrame);
		
		stacker = new Stacker();
		Lib.current.addChild(stacker);
		stacker.start();
	}
	
	public static function restartGame():Void
	{
		Lib.current.removeChild(stacker);
		startGame();
	}
	
	private static function gameFrame(event:Event):Void {
		if (stacker.isEndGame() != false)
		{
			showEndScreen();
		}
	}
	
	private static function endGameFrame(event:Event):Void {
		if (endGameScreen.doRestartGame() != false)
		{
			Lib.current.removeChild(endGameScreen);
			restartGame();
		}
		else if (endGameScreen.resumeGame() != false)
		{
			Lib.current.removeChild(endGameScreen);
			stacker.resumeGame();
		}
	}
	
	private static function showEndScreen()
	{
		removeEvents();
		Lib.current.addEventListener(Event.ENTER_FRAME, endGameFrame);
		
		endGameScreen = new EndGame(stacker.getCurrentRow());
		endGameScreen.showScreen();
		Lib.current.addChild(endGameScreen);
	}
	
}