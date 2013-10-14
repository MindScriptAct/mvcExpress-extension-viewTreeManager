package com.mindscriptact.viewStackTest.view.testView {
import flash.display.CapsStyle;
import flash.display.JointStyle;
import flash.display.LineScaleMode;
import flash.display.Shape;
import flash.display.Sprite;
import flash.events.Event;
import flash.text.AntiAliasType;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;

public class TestView extends Sprite {

	private var CORNER:int = 10;

	private var CORNER_SIZE:int = 2;
	private var CORNER_HALF:int = CORNER_SIZE / 2;

	private var VIEW_SIZE:int = 100;

	private var GRID_GAPS:int = 10;

	private var nameTf:TextField = new TextField();
	private var testName:String;

	private var debugRect:Shape;

	public function TestView(testName:String) {

		this.addEventListener(Event.ADDED_TO_STAGE, renderText, false, 0, true);
		this.addEventListener(Event.ADDED, renderText, false, 0, true);
		this.addEventListener(Event.CHANGE, renderText, false, 0, true);
		this.addEventListener(Event.COMPLETE, renderText, false, 0, true);
		this.addEventListener(Event.RESIZE, renderText, false, 0, true);

		this.testName = testName;

		debugRect = new Shape();
		this.addChild(debugRect);

		// border

		debugRect.graphics.lineStyle(0.01, 0x0, 0.8, false, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.MITER);
		debugRect.graphics.moveTo(0, 0);
		debugRect.graphics.lineTo(VIEW_SIZE, 0);
		debugRect.graphics.lineTo(VIEW_SIZE, VIEW_SIZE);
		debugRect.graphics.lineTo(0, VIEW_SIZE);


		// corner

		debugRect.graphics.lineStyle(CORNER_SIZE, 0xFF0000, 0.8, true, LineScaleMode.NORMAL, CapsStyle.SQUARE, JointStyle.MITER);
		debugRect.graphics.moveTo(CORNER_HALF, CORNER + CORNER_HALF);
		debugRect.graphics.lineTo(CORNER_HALF, CORNER_HALF);
		debugRect.graphics.lineTo(CORNER + CORNER_HALF, CORNER_HALF);

		debugRect.graphics.moveTo(VIEW_SIZE - CORNER_HALF, CORNER + CORNER_HALF);
		debugRect.graphics.lineTo(VIEW_SIZE - CORNER_HALF, CORNER_HALF);
		debugRect.graphics.lineTo(VIEW_SIZE - CORNER - CORNER_HALF, CORNER_HALF);

		debugRect.graphics.moveTo(CORNER_HALF, VIEW_SIZE - CORNER - CORNER_HALF);
		debugRect.graphics.lineTo(CORNER_HALF, VIEW_SIZE - CORNER_HALF);
		debugRect.graphics.lineTo(CORNER + CORNER_HALF, VIEW_SIZE - CORNER_HALF);

		debugRect.graphics.moveTo(VIEW_SIZE - CORNER_HALF, VIEW_SIZE - CORNER - CORNER_HALF);
		debugRect.graphics.lineTo(VIEW_SIZE - CORNER_HALF, VIEW_SIZE - CORNER_HALF);
		debugRect.graphics.lineTo(VIEW_SIZE - CORNER - CORNER_HALF, VIEW_SIZE - CORNER_HALF);


		// grid

		debugRect.graphics.lineStyle(0.01, 0x0, 0.2, false, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.MITER);

		var linePos:int = GRID_GAPS;

		while (linePos < VIEW_SIZE) {

			debugRect.graphics.moveTo(linePos, 0);
			debugRect.graphics.lineTo(linePos, VIEW_SIZE);

			debugRect.graphics.moveTo(0, linePos);
			debugRect.graphics.lineTo(VIEW_SIZE, linePos);

			linePos += GRID_GAPS;
		}

		// center cross

		debugRect.graphics.lineStyle(0.01, 0xFF0000, 0.5, false, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.MITER);

		var center:int = VIEW_SIZE / 2;

		debugRect.graphics.moveTo(center - CORNER, center);
		debugRect.graphics.lineTo(center + CORNER, center);

		debugRect.graphics.moveTo(center, center - CORNER);
		debugRect.graphics.lineTo(center, center + CORNER);

		// quarter cross

		debugRect.graphics.lineStyle(0.01, 0xFF0000, 0.3, false, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.MITER);

		var quarter:int = VIEW_SIZE / 4;
		var cornerHalf:int = CORNER / 2;

		debugRect.graphics.moveTo(quarter - cornerHalf, quarter);
		debugRect.graphics.lineTo(quarter + cornerHalf, quarter);
		debugRect.graphics.moveTo(quarter, quarter - cornerHalf);
		debugRect.graphics.lineTo(quarter, quarter + cornerHalf);

		debugRect.graphics.moveTo(center + quarter - cornerHalf, quarter);
		debugRect.graphics.lineTo(center + quarter + cornerHalf, quarter);
		debugRect.graphics.moveTo(center + quarter, quarter - cornerHalf);
		debugRect.graphics.lineTo(center + quarter, quarter + cornerHalf);

		debugRect.graphics.moveTo(quarter - cornerHalf, center + quarter);
		debugRect.graphics.lineTo(quarter + cornerHalf, center + quarter);
		debugRect.graphics.moveTo(quarter, center + quarter - cornerHalf);
		debugRect.graphics.lineTo(quarter, center + quarter + cornerHalf);

		debugRect.graphics.moveTo(center + quarter - cornerHalf, center + quarter);
		debugRect.graphics.lineTo(center + quarter + cornerHalf, center + quarter);
		debugRect.graphics.moveTo(center + quarter, center + quarter - cornerHalf);
		debugRect.graphics.lineTo(center + quarter, center + quarter + cornerHalf);


		nameTf.selectable = false;
		nameTf.mouseEnabled = false;
		nameTf.alpha = 0.5;
		this.addChild(nameTf);

		renderText();

	}

	private function renderText(event:Object = null):void {
		nameTf.text = testName
				+ "\n" + debugRect.width + "x" + debugRect.height;
		//+ "\n" + Math.round(debugRect.scaleX * 1000) / 10 + "-" + Math.round(debugRect.scaleY * 1000) / 10;
		if (this.parent) {
			nameTf.appendText("\n" + this.parent);
			if (this.parent.contains(this)) {
				nameTf.appendText(" {" + this.parent.getChildIndex(this) + "}");
			}
		}


		nameTf.autoSize = TextFieldAutoSize.LEFT;
		nameTf.antiAliasType = AntiAliasType.ADVANCED;
	}


	override public function set scaleX(value:Number):void {
		debugRect.scaleX = value;
		nameTf.scaleX = value;
		renderText();
	}

	override public function set scaleY(value:Number):void {
		debugRect.scaleY = value;
		nameTf.scaleY = value;
		renderText();
	}

	override public function set width(value:Number):void {
		debugRect.width = value;
		nameTf.scaleX = debugRect.scaleX;
		renderText();
	}

	override public function set height(value:Number):void {
		debugRect.height = value;
		nameTf.scaleY = debugRect.scaleY;
		renderText();
	}


	override public function get scaleX():Number {
		return debugRect.scaleX;
	}

	override public function get scaleY():Number {
		return debugRect.scaleY;
	}

	override public function get width():Number {
		return debugRect.width;
	}

	override public function get height():Number {
		return debugRect.height;
	}
}
}
