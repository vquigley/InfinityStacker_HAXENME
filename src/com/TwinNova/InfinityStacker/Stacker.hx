package com.twinnova.infinitystacker;

import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.actuators.GenericActuator;
import com.eclecticdesignstudio.motion.easing.Elastic;
import com.eclecticdesignstudio.motion.easing.Bounce;
import com.twinnova.infinitystacker.GameMenu;
import flash.display.DisplayObject;
import nme.geom.Matrix;
import nme.media.Sound;

import nme.Lib;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageQuality;
import flash.display.StageScaleMode;
import nme.geom.ColorTransform;
import flash.display.BlendMode;
import nme.events.MouseEvent;
import nme.events.EventPhase;
import nme.display.Bitmap;

/**
 * ...
 * @author Vincent Quigley
 */

class Row extends Sprite
{	
	public function new() 
	{
		super ();
	}
}

class Stacker extends Sprite 
{
	static var STOP_AT_ROW:Int = 7;
	static var SQUARE_WIDTH:Int = 50;
	static var NUM_ROWS:Int = 13;
	static var NUM_COLUMNS:Int = 8;
	static var START_MOVE_LENGTH:Float = 0.2;	
	static var ALPHA_ON_STATE:Int = 200;
	static var ALPHA_OFF_STATE:Int = 0;
	static var SPACE_BETWEEN_SQUARES = 5;
	static var MAX_NUM_OF_BLOCKS = 4;	
	static var NO_NEW_BLOCKS:Int = 0;
	
	var squareOnMatrix:Array<Row>;	
	var squareOffMatrix:Array<Row>;	
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
	var gameMenu:GameMenu;
	var quitGame:Bool = false;
	var stopEvent:Bool = false;
	var newBlockPosition:Int;
	var currentBracket:Sprite;
	var isBracketLeft:Bool;
	
	static var pipSound : Sound = null;
    static var lostBlockSound : Sound = null;
	
	public function new() 
	{
		super ();
		
		initialize ();
		construct ();
	}
	
	public function start()
	{
		moveBlocks();
		Lib.current.stage.addEventListener (MouseEvent.MOUSE_DOWN, blocks_onClick);
	}
	
	public function isEndGame():Bool
	{
		return endGame;
	}
	
	private function initialize ():Void {		
		CurrentMoveLength = START_MOVE_LENGTH;
		
		squareOffMatrix = new Array<Row>();
		squareOnMatrix = new Array<Row>();
				
		firstShift = false;	
		currentRow = 1;
		currentColumns = 0x3c;
		previousColumns = 0;
		GoRight = false;
		newBlockPosition = NO_NEW_BLOCKS;
		pipSound = ApplicationMain.getAsset("sound/pip.wav");
		lostBlockSound = ApplicationMain.getAsset("sound/124996__phmiller42__aww.wav");
	}
	
	private function construct ():Void {
		stack = new Sprite();
		stack.x = (Lib.current.stage.stageWidth - stackWidth()) / 2;
		stack.y = (Lib.current.stage.stageHeight - Global.Instance().height()) / 2;
		stack.graphics.drawRect(0, 
								 0, 
								 stackWidth(), 
								 Global.Instance().height() + scale(SQUARE_WIDTH + SPACE_BETWEEN_SQUARES));
		
		stackMask = new Sprite();
		stackMask.x = (Lib.current.stage.stageWidth - Global.Instance().width()) / 2;
		stackMask.y = (Lib.current.stage.stageHeight - Global.Instance().height()) / 2;
		stackMask.graphics.beginFill(0x677777, 1);
		stackMask.graphics.drawRect(0, 
									 0, 
									 Global.Instance().width(), 
									 Global.Instance().height());

		stack.mask = stackMask;
		
		gameMenu = new GameMenu(this);
		gameMenu.x = 0;
		gameMenu.y = stackMask.y + stackMask.height - gameMenu.height;
		
		fillGrid();			
		
		addChild(stack);
		addChild(stackMask); 		
		addChild(gameMenu);
	}
	
	public function doEndGame()
	{
		Lib.current.stage.removeEventListener(MouseEvent.MOUSE_DOWN, blocks_onClick);
		endGame = true;
	}
	
	public function resumeGame()
	{
		currentColumns = 0x0f;
		endGame = false;
		Lib.current.stage.addEventListener (MouseEvent.MOUSE_DOWN, blocks_onClick);
	}
	
	public function getCurrentRow():Int
	{
		return currentRow;
	}
	
	public function resetTimer()
	{
		CurrentMoveLength = START_MOVE_LENGTH;
	}
	
	public function increaseBlocks()
	{
		if ((getNumberOfOnBlocks() < MAX_NUM_OF_BLOCKS) &&
			(newBlockPosition == NO_NEW_BLOCKS))
		{
			newBlockPosition = currentColumns;
			
			if (isOn(0, currentColumns) == false)
			{
				//  Blocks are at the right hand side of the tower.
				newBlockPosition >>= 1;
				isBracketLeft = false;
			}
			else
			{
				newBlockPosition <<= 1;
				isBracketLeft = true;
			}
			
			newBlockPosition |= currentColumns;
			newBlockPosition ^= currentColumns;
			currentColumns |= newBlockPosition;
			
			currentBracket = createNewBracket();
		}
	}
	
	private function createNewBracket()
	{
		var fixture:Bitmap = Global.Instance().getBitmap("img/fixture.png");
		fixture.width = fixture.width * 0.32;
		fixture.height = fixture.height * 0.32;		
		
		var sprite:Sprite = new Sprite();
		sprite.addChild(fixture);
		return sprite;
	}
	
	public function getNumberOfOnBlocks():Int
	{
		var count = 0;
		
		for (shift in 0...(NUM_COLUMNS - 1))
		{
			if (((currentColumns >> shift) & 1) != 0)
			{
				++count;
			}
		}
		
		return count;
	}
	
	public function quit()
	{
		quitGame = true;
	}
	
	public function doQuitGame():Bool
	{
		return quitGame;
	}
		
	private static function stackWidth()
	{
		return NUM_COLUMNS * scale(SQUARE_WIDTH + SPACE_BETWEEN_SQUARES);
	}
	
	private function blocks_onClick(e:Dynamic):Void
	{
		if (stopEvent == false)
		{
			beginSetBlocks();
			CurrentMoveLength /= 1.05;
			
			checkBlocks();
		}
		else
		{
			stopEvent = false;
		}
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
	
	public function doStopEvent()
	{
		stopEvent = true;
	}
	
	private function checkBlocks():Void
	{	
		var nowOff:Bool = false;
		
		if (currentRow != 1)
		{	
			var stillOn:Int = ((currentColumns | newBlockPosition) & previousColumns);
			
			for (column in 0...NUM_COLUMNS)
			{
				//  Is this a column of interest, i.e. was it on when the move was made?
				if (isOn(column, currentColumns) == false)
				{
					//  Do not care for a column was not on.
					continue;
				}
				
				//  Is the column still on?
				if (isOn(column, stillOn))
				{
					//  Do not care for a column that is still on.
					continue;
				}
				
				//  Column will be lost unless a new block can save it.
				
				// Is this a new block?
				if (((1 << column) & newBlockPosition) != 0)
				{
					//  Is it beside a block that is still on?
					if (isOn(column + 1, stillOn) || isOn(column - 1, stillOn))
					{
						continue;
					}	
					
					//  We've lost the new square.
					
				}
				
				//  Is this beside a new block that is still on?
				if (isOn(column + 1, newBlockPosition) || isOn(column - 1, newBlockPosition))
				{
					//  We are beside a new block, is it still on?
					if ((newBlockPosition & previousColumns) != 0)
					{
						continue;
					}
					
					flick(currentBracket);
				}
				
				nowOff = true;
				lostSquare(column);
				currentColumns ^= (1 << column);
			}
		}
		
		newBlockPosition = NO_NEW_BLOCKS;
		
		previousColumns = currentColumns;
		
		if (nowOff != false)
		{
			if (GameState.playSound)
			{
				lostBlockSound.play(0, 0);
			}
			
			if (currentColumns != 0)
			{
				Actuate.timer(1.2).onComplete(nextLevel);
			}
			else
			{
				Actuate.timer(1.2).onComplete(doEndGame);
			}
		}
		else
		{
			nextLevel();
		}
	}
	
	function lostSquare(columnNumber)
	{
		flick(squareOnMatrix[getActionRow()].getChildAt(columnNumber));
	}
	
	function flick(sprite:DisplayObject, turnOn:Bool = false, iteration:Int = 0):Void
	{
		if (iteration < 11)
		{
			sprite.visible = turnOn;
			Actuate.timer(0.1).onComplete(flick, [sprite, ((turnOn != false) ? false :true), iteration + 1]);
		}
	}
	
	function getActionRow()
	{
		return ((currentRow >= STOP_AT_ROW) ? STOP_AT_ROW : currentRow ) - 1;
	}
	
	private function nextLevel()
	{
		if (currentRow++ >= STOP_AT_ROW)
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
			Actuate.timer(0.5).onComplete(endSetBlocks);
		}
	}
	
	private function shiftDown()
	{		
		addRow();
				
		for (row in squareOnMatrix)
		{
			Actuate.tween (row, 1, { y: row.y + scale(SQUARE_WIDTH + SPACE_BETWEEN_SQUARES)} )
						.ease (Elastic.easeIn);		
		}
		
		for (row in squareOffMatrix)
		{
			Actuate.tween (row, 1, { y: row.y + scale(SQUARE_WIDTH + SPACE_BETWEEN_SQUARES)} )
						.ease (Elastic.easeIn);		
		}
		
		Actuate.timer(1).onComplete(removeBottomRow);
	}
	
	
	private function removeBottomRow():Void
	{
		removeRow(squareOnMatrix[0]);
		removeRow(squareOffMatrix[0]);
		
		squareOnMatrix.remove(squareOnMatrix[0]);
		squareOffMatrix.remove(squareOffMatrix[0]);
				
		endSetBlocks();
	}
	
	private function removeRow(row:Row):Void
	{
		stack.removeChild(row);
	}
	
	private function removeSquare(square:Sprite)
	{		
		stack.removeChild(square);
	}
	
	private function moveBlocks():Void {
		if (isOn(7, currentColumns) != false)
		{
			GoRight = true;
			playPip();
		}
		else if (isOn(0, currentColumns) != false)
		{
			GoRight = false;
			playPip();
		}
		
		if (GoRight == false)
		{
			currentColumns <<= 1;
			
			if (newBlockPosition != NO_NEW_BLOCKS)
			{
				newBlockPosition <<= 1;
			}
		}
		else
		{
			currentColumns >>= 1;
			
			if (newBlockPosition != NO_NEW_BLOCKS)
			{
				newBlockPosition >>= 1;
			}
		}
		
		for (column in 0...NUM_COLUMNS)
		{
			var _isOn:Bool = isOn(column, currentColumns);
			
			turn(getActionRow(), column, _isOn);
			
			// Set the bracket on the new block.
			var isNewBlock:Bool = isOn(column, newBlockPosition);
			
			if (isNewBlock)
			{
				currentBracket.x = squareOnMatrix[getActionRow()].getChildAt(column).x - scale(9);
				
				if (isBracketLeft != false)
				{
					currentBracket.x -= scale(SQUARE_WIDTH + SPACE_BETWEEN_SQUARES);
				}
				
				currentBracket.y = squareOnMatrix[getActionRow()].getChildAt(column).y + scale(3);
				squareOnMatrix[getActionRow()].addChild(currentBracket);
			}			
		}
		
		sweepBlocks = Actuate.timer (CurrentMoveLength).onComplete(moveBlocks);
	}
	
	function playPip()
	{
		if (GameState.playSound)
		{
			pipSound.play(0, 0);
		}
	}
	
	function isOn(columnNum, columnByte):Bool
	{
		return ((columnByte & (1 << columnNum)) != 0);
	}
	
	private function turn(row, column, isOn)
	{
		squareOnMatrix[row].getChildAt(column).visible = isOn;
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
		squareOnMatrix.push(new Row());
		squareOffMatrix.push(new Row());
		
		for (columnNumber in 0...NUM_COLUMNS)
		{
			addSquare(squareOffMatrix.length - 1, columnNumber, squareOffMatrix, false);
			addSquare(squareOnMatrix.length - 1, columnNumber, squareOnMatrix, true).visible = false;
		}
		
		stack.addChild(squareOffMatrix[squareOffMatrix.length - 1]);
		stack.addChild(squareOnMatrix[squareOnMatrix.length - 1]);
	}
	
	//  This could be done better, why not create the on and off state from the start.
	//  Also look at bitmap caching, we should only have two objects being displayed multiple times.
	private function addSquare(rowNumber:Int, columnNumber:Int, matrix:Array<Row>, isOn:Bool):Sprite
	{
		var xPos:Float = scale(columnNumber * SQUARE_WIDTH + (columnNumber * SPACE_BETWEEN_SQUARES));
		var yPos:Float = scale(Global.SCREEN_HEIGHT - ((rowNumber) * SQUARE_WIDTH + ((rowNumber) * SPACE_BETWEEN_SQUARES)) - SQUARE_WIDTH - SPACE_BETWEEN_SQUARES)  - gameMenu.height;
			
		var square:Sprite = new Sprite();
		square.x = xPos;
		square.y = yPos;
		square.graphics.beginFill(0xE0D873, ((isOn == false) ? 0.2 : 0.8));
		square.graphics.lineStyle(1, 0x00ff00, 1);
		square.graphics.drawRect(0, 
								 0, 
								 scale(SQUARE_WIDTH), 
								 scale(SQUARE_WIDTH));

		matrix[rowNumber].addChild(square);
		
		return square;
	}
	
	public static function scale(length:Float):Float
	{
		return Global.Instance().scale(length);
	}
}
