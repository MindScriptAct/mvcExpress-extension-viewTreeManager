package com.mindscriptact.viewStackTest {
import com.mindscriptact.viewStackTest.messages.Message;
import com.mindscriptact.viewStackTest.view.main.MainMediator;
import com.mindscriptact.viewStackTest.view.menu.MenuView;
import com.mindscriptact.viewStackTest.view.menu.MenuViewMediator;
import com.mindscriptact.viewStackTest.view.testView.TestMediator;
import com.mindscriptact.viewStackTest.view.testView.TestView;

import mvcexpress.extensions.viewTreeManager.core.ViewTreeManager;
import mvcexpress.extensions.viewTreeManager.data.ViewDefinition;
import mvcexpress.modules.ModuleCore;

/**
 * TODO:CLASS COMMENT
 * @author rbanevicius
 */
public class MainModule extends ModuleCore {

	public function MainModule() {
		super("MainModule");
	}

	override protected function onInit():void {

	}

	public function start(main:Main):void {

		var testView:TestView = new TestView("Stage");
		main.addChild(testView);
		testView.width = 1000;
		testView.height = 500;
		testView.alpha = 0.3;

		//
		var rootDefinition:ViewDefinition = ViewTreeManager.initRootDefinition(mediatorMap, commandMap, main, MainMediator);
		rootDefinition.positionAt(10, 10);
		rootDefinition.sizeAs(1000, 500);
		/*
		//
		rootDefinition.addViews(
				new ViewDefinition(MenuView, MenuViewMediator)
						.autoAdd()
						.positionAt(10, 470)
				, new ViewDefinition(TestView, TestMediator, ["Test 1"])
						.addOn(Message.ADD_TEST1)
						.removeOn(Message.ADD_TEST2, Message.ADD_TEST3)
						.injectIntoParentAs("testView")
						.executeParentFunctionOnAdd("handleTestView1Added", ["params...", 1])
						.executeParentFunctionOnRemove("HadleTestView1Removed", ["More params..."])
						.positionAt(50, 50)
						.sizeAs(100, 200)
						.autoAdd()
				, new ViewDefinition(TestView, TestMediator, ["Test 2"])
						.addOn(Message.ADD_TEST2)
						.removeOn(Message.ADD_TEST1, Message.ADD_TEST3)
						.positionAt("|0", "0|")
						.sizeAs("50%", "50%")
				, new ViewDefinition(TestView, TestMediator, ["Test 3"])
						.addOn(Message.ADD_TEST3)
						.removeOn(Message.ADD_TEST1, Message.ADD_TEST2)
						.positionAt("^20", "20^")
						.sizeAs("100", "100")
		);
		//*/


		//*
		//
		rootDefinition.addViews(
				new ViewDefinition(MenuView, MenuViewMediator)
						.autoAdd()
						.positionAt(10, 470)
				, new ViewDefinition(TestView, TestMediator, ["Test 1"])
						.toggleOn(Message.ADD_TEST1)
						.positionAt(100, 100)
						.sizeAs(200, 200)
				, new ViewDefinition(TestView, TestMediator, ["Test 2"])
						.toggleOn(Message.ADD_TEST2)
						.positionAt(170, 170)
						.sizeAs(200, 200)
				, new ViewDefinition(TestView, TestMediator, ["Test 3"])
						.toggleOn(Message.ADD_TEST3)
						.positionAt(240, 240)
						.sizeAs(200, 200)
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