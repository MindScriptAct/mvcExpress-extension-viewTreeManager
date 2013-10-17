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
import mvcexpress.extensions.viewTreeManager.data.ViewStackDefinition;
import mvcexpress.mvc.Command;

/**
 * TODO:CLASS COMMENT
 * @author rbanevicius
 */
public class F4TestCommand extends Command {

	public function execute(main:Main):void {

		var rootDefinition:ViewDefinition = ViewTreeManager.getRootDefinition(main);

		rootDefinition.pushViews(
				new StaticViewDefinition(TextField, null, {text:"Stack group. Order is ignored.\nItems will be ordered in order they are added..",
					autoSize:TextFieldAutoSize.RIGHT,
					mouseEnabled:false})
						.positionTo("50^", "^40")
						.autoAdd()
				, new ViewDefinition(MenuView, MenuViewMediator)
						.autoAdd()
						.positionTo(10, "20^")
				, new ViewStackDefinition(
						new ViewDefinition(TestView, TestMediator, ["Test 1"])
								.removeOn(Message.ADD_TEST1)
								.toggleOn(Message.ADD_TEST1)
								.positionTo(100, 100)
								.sizeTo(200, 200)
						, new ViewDefinition(TestView, TestMediator, ["Test 2"])
								.addOn(Message.ADD_TEST2)
								.removeOn(Message.ADD_TEST2)
								.positionTo(170, 170)
								.sizeTo(200, 200)
						, new ViewDefinition(TestView, TestMediator, ["Test 3"])
								.addOn(Message.ADD_TEST3)
								.toggleOn(Message.ADD_TEST3)
								.positionTo(240, 240)
								.sizeTo(200, 200)
				)
		);


	}

}
}
