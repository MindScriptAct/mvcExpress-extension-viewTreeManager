package com.mindscriptact.viewStackTest {

import flash.display.Sprite;

public class Main extends Sprite {

	public function Main() {
		var mainModule:MainModule = new MainModule();
		mainModule.start(this);
	}


	public var testView:Object;

	public function handleTestView1Added(p1:Object, p2:Object):void {
		trace("handleTestView1Added " + p1);
	}

	public function hadleTestView1Removed(p1:Object):void {
		trace("hadleTestView1Removed " + p1);
	}
}
}
