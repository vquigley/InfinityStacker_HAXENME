package com.twinnova.infinitystacker;
import nme.Lib;
/**
 * ...
 * @author Vincent Quigley
 */

class Global 
{
	private static var self:Global = null;
	
	public static function Instance():Global
	{
		if (self == null)
		{
			self = new Global();
		}
		
		return self;
	}
	
	public function new() 
	{
		ratio = (Lib.current.stage.stageWidth / SCREEN_WIDTH);
		trace(Lib.current.stage.stageWidth);
		trace(Lib.current.stage.stageHeight);
		trace(ratio);
	}
	
	public static var SCREEN_WIDTH:Float = 480;
	public static var SCREEN_HEIGHT:Float= 640;	
	public var ratio:Float ;
	
	
	public function scale(length:Float):Float
	{
		return ratio * length;
	}
}