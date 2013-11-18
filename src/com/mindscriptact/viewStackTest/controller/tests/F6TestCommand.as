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
import mvcexpress.extensions.viewTreeManager.data.ViewComboDefinition;
import mvcexpress.extensions.viewTreeManager.data.ViewDefinition;
import mvcexpress.mvc.Command;

/**
 * TODO:CLASS COMMENT
 * @author rbanevicius
 */
public class F6TestCommand extends Command {

	public function execute(main:Main):void {


		var rootDefinition:ViewDefinition = ViewTreeManager.getRootDefinition(main);

		rootDefinition.pushViews(
				new StaticViewDefinition(
						TextField
						, null
						, {
							text:"Sizing test.\n 1 - sized as and resized to *2\n 2 - sized as *2, but view not resized\n 3 - view resized to *2, but calculated with original size",
							autoSize:TextFieldAutoSize.RIGHT,
							mouseEnabled:false
						}
				)
						.positionTo("50^", "^40")
						.autoAdd()
				, new ViewDefinition(MenuView, MenuViewMediator)
						.autoAdd(),
				new ViewComboDefinition(
						new ViewDefinition(TestView, TestMediator, ["Test 1"])
								.addOn(Message.ADD_TEST1)
								.positionTo("0|", "0|")
								.sizeTo(200, 200)
						, new ViewDefinition(TestView, TestMediator, ["Test 2"])
								.addOn(Message.ADD_TEST2)
								.positionTo("0|", "0|")
								.sizeAs(200, 200)
						, new ViewDefinition(TestView, TestMediator, ["Test 3"])
								.addOn(Message.ADD_TEST3)
								.positionTo("0|", "0|")
								.sizeAs(100, 100)
								.sizeTo(200, 200)
				)
						.removeOn(Message.ADD_TEST4)
		);


	}

}
}
