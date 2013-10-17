package com.mindscriptact.viewStackTest.controller.tests {
import com.mindscriptact.viewStackTest.Main;

import mvcexpress.extensions.viewTreeManager.core.ViewTreeManager;
import mvcexpress.extensions.viewTreeManager.data.ViewDefinition;
import mvcexpress.mvc.Command;

/**
 * TODO:CLASS COMMENT
 * @author rbanevicius
 */
public class F9TestCommand extends Command {

	public function execute(main:Main):void {

		var rootDefinition:ViewDefinition = ViewTreeManager.getRootDefinition(main);

		rootDefinition.removeAllViews();

	}

}
}
