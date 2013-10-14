package com.mindscriptact.viewStackTest.view.menu {
import com.bit101.components.PushButton;

import flash.display.Sprite;

public class MenuView extends Sprite {
	public var test1:PushButton;
	public var test2:PushButton;
	public var test3:PushButton;
	public var test4:PushButton;

	public function MenuView() {
		test1 = new PushButton(this, 0, 0, "Test1");
		test2 = new PushButton(this, 100, 0, "Test2");
		test3 = new PushButton(this, 200, 0, "Test3");
		test4 = new PushButton(this, 300, 0, "Test4");
	}
}
}
