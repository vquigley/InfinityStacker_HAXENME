package com.twinnova.infinitystacker;

import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.actuators.GenericActuator;
import com.eclecticdesignstudio.motion.easing.Elastic;
import com.eclecticdesignstudio.motion.easing.Bounce;
import nme.geom.Matrix;

import nme.events.Event;
import nme.Lib;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageQuality;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.Lib;
import nme.geom.ColorTransform;
import flash.display.BlendMode;
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
		var stacker:Stacker = new Stacker();
		Lib.current.addChild (stacker);
		stacker.start();		
	}

	
	static var SQUARE_WIDTH:Int = 50;
	
	static var SCREEN_WIDTH:Int = 480;
	static var SCREEN_HEIGHT:Int = 640;
	
	static var NUM_ROWS:Int = 13;
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
	
	var sweepBlocks:IGenericActuator;
	
	var stackMask:Sprite;
	var stack:Sprite;
	
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
		
	}
	
	private function construct ():Void {
				
		stack = new Sprite();
		stack.x = (Lib.current.stage.stageWidth - stackWidth()) / 2;
		stack.y = (Lib.current.stage.stageHeight - scale(SCREEN_HEIGHT)) / 2;
		stack.graphics.drawRect(0, 
								 0, 
								 stackWidth(), 
								 scale(SCREEN_HEIGHT + SQUARE_WIDTH + SPACE_BETWEEN_SQUARES));
		
		stackMask = new Sprite();
		stackMask.x = (Lib.current.stage.stageWidth - scale(SCREEN_WIDTH)) / 2;
		stackMask.y = (Lib.current.stage.stageHeight - scale(SCREEN_HEIGHT)) / 2;
		stackMask.graphics.lineStyle(1, 0xff0000, 1);
		stackMask.graphics.beginFill(0x677777, 1);
		stackMask.graphics.drawRect(0, 
								 0, 
								 scale(SCREEN_WIDTH) , 
								 scale(SCREEN_HEIGHT));

		fillGrid();	
		
		stack.mask = stackMask;
		addChild(stack);
		addChild(stackMask); 
	}
	
	function stackWidth()
	{
		return NUM_COLUMNS * scale(SQUARE_WIDTH + SPACE_BETWEEN_SQUARES);
	}
	
	var firstShift:Bool = false;
	private function blocks_onClick(e:Dynamic):Void
	{
		if (currentRow == 7)
		{	
			if (firstShift == false)
			{
				Actuate.tween(stack, 1, { y: stack.y + (scale(SQUARE_WIDTH + SPACE_BETWEEN_SQUARES ) /2) } );
				firstShift = true;
			}
			
			shiftDown();
		}
		else
		{
			currentRow += 1;
		}
	}
	
	private function start()
	{
		Lib.current.stage.addEventListener (MouseEvent.MOUSE_DOWN, blocks_onClick);
		sweepBlocks = Actuate.timer (CurrentMoveLength).onComplete (moveBlocks);
	}
	
	function beginSetBlocks()
	{
		Actuate.pause(sweepBlocks);
		Lib.current.stage.removeEventListener(MouseEvent.MOUSE_DOWN, blocks_onClick);
		
	}
	
	function endSetBlocks()
	{
		moveBlocks();
		Lib.current.stage.addEventListener (MouseEvent.MOUSE_DOWN, blocks_onClick);
	}
	
	private function shiftDown()
	{		
		beginSetBlocks();
		
		addRow();
				
		for (row in squareMatrix)
		{
			for (square in row)
			{
				Actuate.tween (square, 1, { y: square.y + scale(SQUARE_WIDTH + SPACE_BETWEEN_SQUARES)} )
							.ease (Elastic.easeIn);		
			}
		}
		
		Actuate.timer(1).onComplete(removeBottomRow);
	}
	
	
	private function removeBottomRow():Void
	{
		var bottomRow:Array<Sprite> = squareMatrix[0];

		for (square in bottomRow)
		{
			var local:Sprite = square;
			removeSquare(square);
		}
		
		squareMatrix.remove(bottomRow);
	
		endSetBlocks();
	}
	
	private function removeSquare(square:Sprite)
	{		
		stack.removeChild(square);
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
			
			turn(currentRow - 1, column, isOn);
		}
		
		sweepBlocks = Actuate.timer (CurrentMoveLength).onComplete(moveBlocks);
	}
	
	private function turn(row, column, isON)
	{
		removeSquare(squareMatrix[row][column]);
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
			addRow();
		}
	}
	
	private function addRow()
	{		
		squareMatrix.push(new Array<Sprite>());
		
		for (columnNumber in 0...NUM_COLUMNS)
		{
			addSquare(squareMatrix.length - 1, columnNumber);
		}
	}
	
	private function addSquare(rowNumber:Int, columnNumber:Int, isON:Bool = false)
	{
		var xPos:Float = scale(columnNumber * SQUARE_WIDTH + (columnNumber * SPACE_BETWEEN_SQUARES));
		var yPos:Float = scale(SCREEN_HEIGHT - ((rowNumber) * SQUARE_WIDTH + ((rowNumber) * SPACE_BETWEEN_SQUARES)) - SQUARE_WIDTH);
		
		var square:Sprite = new Sprite();
		square.x = xPos;
		square.y = yPos;
		square.graphics.lineStyle(1, 0x00ff00, 1);
		square.graphics.beginFill(0xE0D873, ((isON == false) ? 0.2 : 0.8));
		square.graphics.drawRect(0, 
								 0, 
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
		
		stack.addChild(square);
	}
	
	public function scale(length:Float):Float
	{
		return ratio * length;
	}
	
	
}
