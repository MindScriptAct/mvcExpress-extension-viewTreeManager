package com.mindscriptact.viewStackTest.view.testView {
import com.mindscriptact.viewStackTest.view.testView.TestView;

import mvcexpress.mvc.Mediator;

/**
 * TODO:CLASS COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class TestMediator extends Mediator {

	[Inject]
	public var view:TestView;

	override protected function onRegister():void {

	}

	override protected function onRemove():void {

	}
}
}