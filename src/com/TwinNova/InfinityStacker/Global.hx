package com.twinnova.infinitystacker;
import nme.Lib;

import nme.display.Bitmap;
import nme.Assets;
/**
 * ...
 * @author Vincent Quigley
 */

class Global 
{
	public static var SCREEN_WIDTH:Float = 480;
	public static var SCREEN_HEIGHT:Float = 640;	
		
	public static function Instance():Global
	{
		if (_self == null)
		{
			_self = new Global();
		}
		
		return _self;
	}
	
	public function new() 
	{
		_ratio = (Lib.current.stage.stageWidth / SCREEN_WIDTH);
		_width = scale(SCREEN_WIDTH);
		_height = scale(SCREEN_HEIGHT);
	}
	
	private var _width:Float;
	private var _height:Float;
	private var _ratio:Float ;
	private static var _self:Global = null;
	
	public function getBitmap(location:String):Bitmap
	{
		var img = new Bitmap (Assets.getBitmapData (location));
		img.width = Global.Instance().scale(img.width);
		img.height = Global.Instance().scale(img.height);
		
		return img;
	}
	
	public function scale(length:Float):Float
	{
		return _ratio * length;
	}
	
	public function width():Float
	{
		return _width;
	}
	
	public function height():Float
	{
		return _height;
	}
}