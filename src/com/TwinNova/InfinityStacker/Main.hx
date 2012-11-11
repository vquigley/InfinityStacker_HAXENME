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
	
	public static function main() 
	{
		stacker= new Stacker();
		Lib.current.addChild(stacker);
		stacker.start();
		
		Lib.current.addEventListener (Event.ENTER_FRAME, this_onEnterFrame);
	}
	
	static function startGame():Void
	{
		stacker= new Stacker();
		Lib.current.addChild(stacker);
		stacker.start();
	}
	
	public static function restartGame():Void
	{
		Lib.current.removeChild(stacker);
		startGame();
	}
	
	private static function this_onEnterFrame (event:Event):Void {
		if (stacker.isEndGame() != false)
		{
			restartGame();
		}
	}
	
}