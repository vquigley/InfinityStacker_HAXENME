package com.twinnova.infinitystacker;

import com.eclecticdesignstudio.motion.Actuate;

import nme.display.Sprite;
import nme.events.Event;
import nme.Lib;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageQuality;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.Lib;
import nme.geom.ColorTransform;

import nme.events.MouseEvent;
import nme.events.TouchEvent;

/**
 * ...
 * @author Vincent Quigley
 */

class Stacker extends Sprite 
{
	static public function main() 
	{
		Lib.current.addChild (new Stacker());		
	}
	
	static var SQUARE_WIDTH:Int = 50;
	
	static var SCREEN_WIDTH:Int = 480;
	static var SCREEN_HEIGHT:Int = 640;
	
	static var NUM_ROWS:Int = 12;
	static var NUM_COLUMNS:Int = 8;
	
	static var START_MOVE_LENGTH:Float = 0.1;
	var CurrentMoveLength:Float;
	
	static var ALPHA_ON_STATE:Int = 200;
	static var ALPHA_OFF_STATE:Int = 0;
	static var SPACE_BETWEEN_SQUARES = 5;
	
	var squareMatrix:Array<Array<Sprite>>;
	
	var currentRow:Int = 1;
	var currentColumns:Int = 0x3c;
	var previousColumns = 0;
	var GoRight:Bool = false;
	
	var ratio:Float;
	
	public function new() 
	{
		super ();
		
		initialize ();
		construct ();
	}
	
	private function initialize ():Void {
		var stage = Lib.current.stage;
		stage.scaleMode = nme.display.StageScaleMode.NO_SCALE;
		stage.align = nme.display.StageAlign.TOP_LEFT;
		
		CurrentMoveLength = START_MOVE_LENGTH;
		
		squareMatrix = new Array<Array<Sprite>>();
		
		ratio = (Lib.current.stage.stageWidth / SCREEN_WIDTH);
		
		for (x in 0...NUM_ROWS)
		{
			squareMatrix.push(new Array<Sprite>());
		}
	}
	
	private function construct ():Void {
		fillGrid();	
		Lib.current.stage.addEventListener (MouseEvent.MOUSE_DOWN, blocks_onClick);
		Actuate.timer (CurrentMoveLength).onComplete (moveBlocks);
	}
	
	private function blocks_onClick(e:Dynamic):Void
	{
		if (currentRow == 6)
		{
			shiftDown();
		}
		else
		{
			currentRow += 1;
		}
	}
	
	private function shiftDown()
	{
		
	}
	
	private function moveBlocks():Void {
		
		if ((currentColumns & 0xC0) == 0xC0)
		{
			GoRight = true;
		}
		else if ((currentColumns & 1) == 1)
		{
			GoRight = false;
		}
		
		if (GoRight == false)
		{
			currentColumns <<= 1;
		}
		else
		{
			currentColumns >>= 1;
		}
		
		for (column in 0...NUM_COLUMNS)
		{			
			var isOn:Bool = (((currentColumns >> column) & 1) == 1);
			
			trace(column);
			trace(isOn);
			turn(currentRow - 1, column, isOn);
		}
		
		Actuate.timer (CurrentMoveLength).onComplete (moveBlocks);
	}
	
	private function turn(row, column, isON)
	{
		Lib.current.removeChild(squareMatrix[row][column]);
		addSquare(row, column, isON);
	}

	private function init(e) 
	{
		// entry point
	}
	
	private function fillGrid()
	{
		for (rowNumber in 0...NUM_ROWS)
		{
			addRow(rowNumber);
		}
	}
	
	private function addRow(rowNumber:Int)
	{		
		for (columnNumber in 0...NUM_COLUMNS)
		{
			addSquare(rowNumber, columnNumber);
		}
	}
	
	private function addSquare(rowNumber:Int, columnNumber:Int, isON:Bool = false)
	{
		var square:Sprite = new Sprite();
		square.graphics.lineStyle(1, 0x00ff00, 1);
		square.graphics.beginFill(0xE0D873, ((isON == false) ? 0.2 : 0.8));
		square.graphics.drawRect(scale(columnNumber * SQUARE_WIDTH + (columnNumber * SPACE_BETWEEN_SQUARES)), 
								 scale(SCREEN_HEIGHT - (rowNumber * SQUARE_WIDTH + (rowNumber * SPACE_BETWEEN_SQUARES))), 
								 scale(SQUARE_WIDTH), 
								 scale(SQUARE_WIDTH));
		
		if (squareMatrix[rowNumber].length >= columnNumber)
		{
			squareMatrix[rowNumber][columnNumber] = square;
		}
		else
		{
			squareMatrix[rowNumber].push(square);
		}
		
		Lib.current.addChild(square);
	}
	
	public function scale(length:Float):Float
	{

		return ratio * length;
	}
	
	
}
