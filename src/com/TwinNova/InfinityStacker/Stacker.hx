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
	static var STOP_AT_ROW:Int = 7;
	
	static var SQUARE_WIDTH:Int = 50;
	static var SCREEN_WIDTH:Int = 480;
	static var SCREEN_HEIGHT:Int = 640;
	
	static var NUM_ROWS:Int = 13;
	static var NUM_COLUMNS:Int = 8;
	
	static var START_MOVE_LENGTH:Float = 0.2;	
	static var ALPHA_ON_STATE:Int = 200;
	static var ALPHA_OFF_STATE:Int = 0;
	static var SPACE_BETWEEN_SQUARES = 5;
	
	var squareMatrix:Array<Array<Sprite>>;	
	var ratio:Float;	
	var sweepBlocks:IGenericActuator;
	
	var stackMask:Sprite;
	var stack:Sprite;
	var firstShift:Bool;
	var CurrentMoveLength:Float;	
	var currentRow:Int;
	var currentColumns:Int;
	var previousColumns:Int;
	var GoRight:Bool;
	
	var endGame:Bool = false;
	
	public function isEndGame():Bool
	{
		return endGame;
	}
	
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
		
		firstShift = false;	
		currentRow = 1;
		currentColumns = 0x3c;
		previousColumns = 0;
		GoRight = false;
		
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
	
	
	private function blocks_onClick(e:Dynamic):Void
	{
		
		beginSetBlocks();
		CurrentMoveLength /= 1.1;
		
		if (checkBlocks() == false)
		{
			endGame = true;
		}
	}
	
	private function checkBlocks():Bool
	{	
		var waitForAnimationToComplete:Bool = false;
		
		if (currentRow != 1)
		{	
			var temp:Int = (currentColumns ^ previousColumns) & currentColumns;
			for (column in 0...NUM_COLUMNS)
			{
				if (isOn(column, temp))
				{
					lostSquare(column);
					waitForAnimationToComplete = true;
				}
			}
			
			currentColumns &= previousColumns;
		}
		
		previousColumns = currentColumns;
		
		if (waitForAnimationToComplete != false)
		{
			Actuate.timer(1.2).onComplete(nextLevel);
		}
		else
		{
			nextLevel();
		}
		
		return (currentColumns != 0);
	}
	
	function lostSquare(columnNumber)
	{
		flick(actionRow(), columnNumber);
	}
	
	function flick(row:Int, column:Int, turnOn:Bool = false, iteration:Int = 0):Void
	{
		if (iteration < 11)
		{
			turn(row, column, turnOn);
			Actuate.timer(0.1).onComplete(flick, [row, column, ((turnOn != false) ? false :true), iteration + 1]);
		}
	}
	
	function actionRow()
	{
		return ((currentRow >= STOP_AT_ROW) ? STOP_AT_ROW : currentRow ) - 1;
	}
	
	private function nextLevel()
	{
		
		if (currentRow >= STOP_AT_ROW)
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
			Actuate.timer(0.5).onComplete(endSetBlocks);
		}
	}
	
	public function start()
	{
		moveBlocks();
		Lib.current.stage.addEventListener (MouseEvent.MOUSE_DOWN, blocks_onClick);
	}
	
	function beginSetBlocks()
	{
		Actuate.pause(sweepBlocks);
		Lib.current.stage.removeEventListener(MouseEvent.MOUSE_DOWN, blocks_onClick);
		
	}
	
	function endSetBlocks()
	{
		Lib.current.stage.addEventListener (MouseEvent.MOUSE_DOWN, blocks_onClick);
		moveBlocks();
	}
	
	private function shiftDown()
	{		
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
		if (isOn(7, currentColumns) != false)
		{
			GoRight = true;
		}
		else if (isOn(0, currentColumns) != false)
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
			var isOn:Bool = isOn(column, currentColumns);
			
			turn(actionRow(), column, isOn);
		}
		
		sweepBlocks = Actuate.timer (CurrentMoveLength).onComplete(moveBlocks);
	}
	
	function isOn(columnNum, columnByte):Bool
	{
		return ((columnByte & (1 << columnNum)) != 0);
	}
	
	private function turn(row, column, isOn)
	{
		removeSquare(squareMatrix[row][column]);
		addSquare(row, column, isOn);
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
	
	private function addSquare(rowNumber:Int, columnNumber:Int, isOn:Bool = false)
	{
		var xPos:Float = scale(columnNumber * SQUARE_WIDTH + (columnNumber * SPACE_BETWEEN_SQUARES));
		var yPos:Float = scale(SCREEN_HEIGHT - ((rowNumber) * SQUARE_WIDTH + ((rowNumber) * SPACE_BETWEEN_SQUARES)) - SQUARE_WIDTH);
		
		var square:Sprite = new Sprite();
		square.x = xPos;
		square.y = yPos;
		square.graphics.lineStyle(1, 0x00ff00, 1);
		square.graphics.beginFill(0xE0D873, ((isOn == false) ? 0.2 : 0.8));
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
