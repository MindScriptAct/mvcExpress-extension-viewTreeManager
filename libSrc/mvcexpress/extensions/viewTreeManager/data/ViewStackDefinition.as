// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.extensions.viewTreeManager.data {
import mvcexpress.extensions.viewTreeManager.namespace.viewTreeNs;

use namespace viewTreeNs;

/**
 * Stack of views that are stacked on each other at same level in order they are added.
 * (Views are not ordered on screen in order they are defined.)
 *
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class ViewStackDefinition {

	viewTreeNs var stackViews:Array;

	public function ViewStackDefinition(...stackViews:Array) {
		this.stackViews = stackViews;
		for (var i:int = 0; i < stackViews.length; i++) {
			if (!stackViews is ViewDefinition) {
				throw Error("You can add only ViewDefinition objects to ViewStackDefinition.");
			}
		}
	}

	public function addDefinition(viewDefinition:ViewDefinition):void {
		if (stackViews == null) {
			stackViews = [];
		}
		stackViews.push(viewDefinition);
	}

}
}
