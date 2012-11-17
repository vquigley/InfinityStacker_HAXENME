package com.twinnova.infinitystacker;
import com.twinnova.infinitystacker.GameState;
import nme.Lib;

import nme.display.Sprite;
/**
 * ...
 * @author Vincent Quigley
 */

class Main  extends Sprite 
{
	
	
	public static function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = nme.display.StageScaleMode.NO_SCALE;
		stage.align = nme.display.StageAlign.TOP_LEFT;
		
		Global.Instance();
		
		var gameState = new GameState();
	}	
}