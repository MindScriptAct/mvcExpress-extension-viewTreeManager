package com.mindscriptact.viewStackTest {
import com.mindscriptact.viewStackTest.messages.Message;
import com.mindscriptact.viewStackTest.view.main.MainMediator;
import com.mindscriptact.viewStackTest.view.menu.MenuView;
import com.mindscriptact.viewStackTest.view.menu.MenuViewMediator;
import com.mindscriptact.viewStackTest.view.test1.Test1;
import com.mindscriptact.viewStackTest.view.test1.Test1Mediator;
import com.mindscriptact.viewStackTest.view.test2.Test2;
import com.mindscriptact.viewStackTest.view.test2.Test2Mediator;
import com.mindscriptact.viewStackTest.view.test3.Test3;
import com.mindscriptact.viewStackTest.view.test3.Test3Mediator;

import mvcexpress.extensions.viewTreeManager.ModuleViewTree;
import mvcexpress.extensions.viewTreeManager.data.ViewDefinition;
import mvcexpress.extensions.viewTreeManager.data.ViewStackDefinition;

/**
 * TODO:CLASS COMMENT
 * @author rbanevicius
 */
public class MainModule extends ModuleViewTree {

	public function MainModule() {
		super("MainModule");
	}

	override protected function onInit():void {

	}

	public function start(main:Main):void {

		//
		var rootDefinition:ViewDefinition = initRootDefinition(main, MainMediator);
		rootDefinition.positionAt(10, 10)
		//*
		//
		rootDefinition.addViews(
				new ViewDefinition(MenuView, MenuViewMediator)
						.autoAdd()
				, new ViewDefinition(Test1, Test1Mediator)
						.addOn(Message.ADD_TEST1)
						.removeOn(Message.ADD_TEST2, Message.ADD_TEST3)
						.injectIntoParentAs("testView")
						.executeParentFunctionOnAdd("handleTestView1Added", ["params...", 1])
						.executeParentFunctionOnRemove("HadleTestView1Removed", ["More params..."])
						.positionAt(10, 10)
						.sizeAs(100, 200)
						.autoAdd()
				, new ViewDefinition(Test2, Test2Mediator)
						.addOn(Message.ADD_TEST2)
						.removeOn(Message.ADD_TEST1, Message.ADD_TEST3)
						.positionAt("^20", "20^")
						.sizeAs("30%", "50%")
				, new ViewDefinition(Test3, Test3Mediator)
						.addOn(Message.ADD_TEST3)
						.removeOn(Message.ADD_TEST1, Message.ADD_TEST2)
						.positionAt("|50", "40|")
						.sizeAs("100", "200")
		);
		//*/


		/*
		rootDefinition.addViews( //
				new ViewDefinition(MenuView, MenuViewMediator).autoAdd(), //
				new ViewStackDefinition(
						new ViewDefinition(Test1, Test1Mediator).addOn(Message.ADD_TEST1), //
						new ViewDefinition(Test2, Test2Mediator).addOn(Message.ADD_TEST2), //
						new ViewDefinition(Test3, Test3Mediator).addOn(Message.ADD_TEST3) //
				)
		);
		//*/


	}

	override protected function onDispose():void {

	}
}
}