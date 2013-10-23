package com.mindscriptact.viewStackTest.controller.tests {
import com.mindscriptact.viewStackTest.Main;
import com.mindscriptact.viewStackTest.messages.Message;
import com.mindscriptact.viewStackTest.view.menu.MenuView;
import com.mindscriptact.viewStackTest.view.menu.MenuViewMediator;
import com.mindscriptact.viewStackTest.view.testView.TestMediator;
import com.mindscriptact.viewStackTest.view.testView.TestView;

import flash.text.TextField;
import flash.text.TextFieldAutoSize;

import mvcexpress.extensions.viewTreeManager.core.ViewTreeManager;
import mvcexpress.extensions.viewTreeManager.data.StaticViewDefinition;
import mvcexpress.extensions.viewTreeManager.data.ViewDefinition;
import mvcexpress.mvc.Command;

/**
 * TODO:CLASS COMMENT
 * @author rbanevicius
 */
public class F1TestCommand extends Command {

	public function execute(main:Main):void {


		var rootDefinition:ViewDefinition = ViewTreeManager.getRootDefinition(main);


		rootDefinition.pushViews(
				new StaticViewDefinition(
						TextField
						, null
						, {
							text:"general testing..",
							autoSize:TextFieldAutoSize.RIGHT,
							mouseEnabled:false
						}
				)
						.positionTo("50^", "^40")
						.autoAdd()
				, new ViewDefinition(MenuView, MenuViewMediator)
						.autoAdd()
						.positionTo(10, "20^")
				, new ViewDefinition(TestView, TestMediator, ["Test 1"])
						.addOn(Message.ADD_TEST1)
						.removeOn(Message.ADD_TEST2, Message.ADD_TEST3)
						.injectIntoParentAs("testView")
						.executeParentFunctionOnAdd("handleTestView1Added", ["params...", 1])
						.executeParentFunctionOnRemove("hadleTestView1Removed", ["More params..."])
						.positionTo(50, 50)
						.sizeTo(100, 200)
						.autoAdd()
				, new ViewDefinition(TestView, TestMediator, ["Test 2"])
						.addOn(Message.ADD_TEST2)
						.removeOn(Message.ADD_TEST1, Message.ADD_TEST3)
						.positionTo("|0", "0|")
						.sizeTo("50%", "50%")
				, new ViewDefinition(TestView, TestMediator, ["Test 3"])
						.addOn(Message.ADD_TEST3)
						.removeOn(Message.ADD_TEST1, Message.ADD_TEST2)
						.positionTo("^20", "20^")
						.sizeTo("100", "100")
		);

	}

}
}
