/**
 * Created with IntelliJ IDEA.
 * User: rbanevicius
 * Date: 4/11/13
 * Time: 6:01 PM
 * To change this template use File | Settings | File Templates.
 */
package com.mindscriptact.viewStackTest.view.menu {
import com.bit101.components.PushButton;

import flash.display.Sprite;

public class MenuView extends Sprite {
	public var test1:PushButton;
	public var test2:PushButton;
	public var test3:PushButton;

	public function MenuView() {
		test1 = new PushButton(this, 50, 50, "Test1");
		test2 = new PushButton(this, 150, 50, "Test2");
		test3 = new PushButton(this, 250, 50, "Test3");
	}
}
}
