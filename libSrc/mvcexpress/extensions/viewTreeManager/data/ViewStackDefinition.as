package mvcexpress.extensions.viewTreeManager.data {
import mvcexpress.extensions.viewTreeManager.namespace.viewTreeNs;

use namespace viewTreeNs;

/**
 * Stack of views that are stacked on each other at same level in order they are added.
 * (Views are not ordered on screen in order they are defined.)
 */
public class ViewStackDefinition {

	viewTreeNs var viewStack:Array;

	public function ViewStackDefinition(...viewStack:Array) {
		this.viewStack = viewStack;
	}

	public function addDefinition(viewDefinition:ViewDefinition):void {
		if (viewStack == null) {
			viewStack = [];
		}
		viewStack.push(viewDefinition);
	}

}
}
