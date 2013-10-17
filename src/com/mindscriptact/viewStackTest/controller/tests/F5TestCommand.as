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
import mvcexpress.extensions.viewTreeManager.data.ViewGroupDefinition;
import mvcexpress.mvc.Command;

/**
 * TODO:CLASS COMMENT
 * @author rbanevicius
 */
public class F5TestCommand extends Command {

	public function execute(main:Main):void {

		var rootDefinition:ViewDefinition = ViewTreeManager.getRootDefinition(main);

		rootDefinition.pushViews(
				new StaticViewDefinition(TextField, null, {text:"Grouped views.\nCan be added/removed all at onece. ordered.",
					autoSize:TextFieldAutoSize.RIGHT,
					mouseEnabled:false})
						.positionTo("50^", "^40")
						.autoAdd()
				, new ViewDefinition(MenuView, MenuViewMediator)
						.autoAdd(),
				new ViewGroupDefinition(
						new ViewDefinition(TestView, TestMediator, ["Test 1"])
								.addOn(Message.ADD_TEST2)
								.positionTo(150, 150)
								.sizeTo(200, 200)
						, new ViewDefinition(TestView, TestMediator, ["Test 2"])
								.toggleOn(Message.ADD_TEST2)
								.removeOn(Message.ADD_TEST3)
								.positionTo(200, 200)
								.sizeTo(200, 200)
						, new ViewDefinition(TestView, TestMediator, ["Test 3"])
								.removeOn(Message.ADD_TEST3)
								.positionTo(250, 250)
								.sizeTo(200, 200)
				)
						.addOn(Message.ADD_TEST1)
						.removeOn(Message.ADD_TEST4)
		);


	}

}
}
