package com.mindscriptact.viewStackTest.view.testView {
import flash.display.CapsStyle;
import flash.display.JointStyle;
import flash.display.LineScaleMode;
import flash.display.Sprite;

public class TestView extends Sprite {

	private var CORNER:int = 10;

	private var CORNER_SIZE:int = 2;
	private var CORNER_HALF:int = CORNER_SIZE / 2;

	private var VIEW_SIZE:int = 100;

	private var GRID_GAPS:int = 10;

	public function TestView(testName:String) {

		// border

		this.graphics.lineStyle(0.01, 0x0, 0.8, false, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.MITER);
		this.graphics.moveTo(0, 0);
		this.graphics.lineTo(VIEW_SIZE, 0);
		this.graphics.lineTo(VIEW_SIZE, VIEW_SIZE);
		this.graphics.lineTo(0, VIEW_SIZE);


		// corner

		this.graphics.lineStyle(CORNER_SIZE, 0xFF0000, 0.8, true, LineScaleMode.NORMAL, CapsStyle.SQUARE, JointStyle.MITER);
		this.graphics.moveTo(CORNER_HALF, CORNER + CORNER_HALF);
		this.graphics.lineTo(CORNER_HALF, CORNER_HALF);
		this.graphics.lineTo(CORNER + CORNER_HALF, CORNER_HALF);

		this.graphics.moveTo(VIEW_SIZE - CORNER_HALF, CORNER + CORNER_HALF);
		this.graphics.lineTo(VIEW_SIZE - CORNER_HALF, CORNER_HALF);
		this.graphics.lineTo(VIEW_SIZE - CORNER - CORNER_HALF, CORNER_HALF);

		this.graphics.moveTo(CORNER_HALF, VIEW_SIZE - CORNER - CORNER_HALF);
		this.graphics.lineTo(CORNER_HALF, VIEW_SIZE - CORNER_HALF);
		this.graphics.lineTo(CORNER + CORNER_HALF, VIEW_SIZE - CORNER_HALF);

		this.graphics.moveTo(VIEW_SIZE - CORNER_HALF, VIEW_SIZE - CORNER - CORNER_HALF);
		this.graphics.lineTo(VIEW_SIZE - CORNER_HALF, VIEW_SIZE - CORNER_HALF);
		this.graphics.lineTo(VIEW_SIZE - CORNER - CORNER_HALF, VIEW_SIZE - CORNER_HALF);


		// grid

		this.graphics.lineStyle(0.01, 0x0, 0.2, false, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.MITER);

		var linePos:int = GRID_GAPS;

		while (linePos < VIEW_SIZE) {

			this.graphics.moveTo(linePos, 0);
			this.graphics.lineTo(linePos, VIEW_SIZE);

			this.graphics.moveTo(0, linePos);
			this.graphics.lineTo(VIEW_SIZE, linePos);

			linePos += GRID_GAPS;
		}

		// center cross

		this.graphics.lineStyle(0.01, 0xFF0000, 0.5, false, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.MITER);

		var center:int = VIEW_SIZE / 2;

		this.graphics.moveTo(center - CORNER, center);
		this.graphics.lineTo(center + CORNER, center);

		this.graphics.moveTo(center, center - CORNER);
		this.graphics.lineTo(center, center + CORNER);

		// quarter cross

		this.graphics.lineStyle(0.01, 0xFF0000, 0.3, false, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.MITER);

		var quarter:int = VIEW_SIZE / 4;
		var cornerHalf:int = CORNER / 2;

		this.graphics.moveTo(quarter - cornerHalf, quarter);
		this.graphics.lineTo(quarter + cornerHalf, quarter);
		this.graphics.moveTo(quarter, quarter - cornerHalf);
		this.graphics.lineTo(quarter, quarter + cornerHalf);

		this.graphics.moveTo(center + quarter - cornerHalf, quarter);
		this.graphics.lineTo(center + quarter + cornerHalf, quarter);
		this.graphics.moveTo(center + quarter, quarter - cornerHalf);
		this.graphics.lineTo(center + quarter, quarter + cornerHalf);

		this.graphics.moveTo(quarter - cornerHalf, center + quarter);
		this.graphics.lineTo(quarter + cornerHalf, center + quarter);
		this.graphics.moveTo(quarter, center + quarter - cornerHalf);
		this.graphics.lineTo(quarter, center + quarter + cornerHalf);

		this.graphics.moveTo(center + quarter - cornerHalf, center + quarter);
		this.graphics.lineTo(center + quarter + cornerHalf, center + quarter);
		this.graphics.moveTo(center + quarter, center + quarter - cornerHalf);
		this.graphics.lineTo(center + quarter, center + quarter + cornerHalf);

	}
}
}
