package com.mindscriptact.viewStackTest {

import flash.display.Sprite;
import flash.text.TextField;

public class Main extends Sprite {

	public function Main() {
		var mainModule:MainModule = new MainModule();
		mainModule.start(this);
	}


	public var testView:Object;

	public function handleTestView1Added(p1:Object, p2:Object):void {
		trace(p1);
	}

	public function HadleTestView1Removed(p1:Object):void {
		trace(p1);
	}
}
}
