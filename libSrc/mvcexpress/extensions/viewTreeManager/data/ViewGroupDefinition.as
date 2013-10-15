package mvcexpress.extensions.viewTreeManager.data {
import mvcexpress.extensions.viewTreeManager.namespace.viewTreeNs;

use namespace viewTreeNs;

/**
 * Group of views, only one will be visible at same depth.
 */
public class ViewGroupDefinition {

	viewTreeNs var groupViews:Array;

	viewTreeNs var addMessages:Array;
	viewTreeNs var removeMessages:Array;
	viewTreeNs var toggleMessages:Array;

	public function ViewGroupDefinition(...groupViews:Array) {
		this.groupViews = groupViews;
		for (var i:int = 0; i < groupViews.length; i++) {
			if (!groupViews is ViewDefinition) {
				throw Error("You can add only ViewDefinition objects to ViewGroupDefinition.");
			}
		}
	}

	public function addDefinition(viewDefinition:ViewDefinition):ViewGroupDefinition {
		if (groupViews == null) {
			groupViews = [];
		}
		groupViews.push(viewDefinition);
		//
		if (addMessages == null) {
			for (var j:int = 0; j < addMessages.length; j++) {
				viewDefinition.addOn(addMessages[j]);
			}
		}
		if (removeMessages == null) {
			for (var k:int = 0; k < removeMessages.length; k++) {
				viewDefinition.removeOn(removeMessages[k]);
			}
		}
		if (toggleMessages == null) {
			for (var m:int = 0; m < toggleMessages.length; m++) {
				viewDefinition.toggleOn(toggleMessages[m]);
			}
		}

		return this;
	}

	public function addOn(...addMessages:Array):ViewGroupDefinition {
		if (groupViews != null) {
			for (var i:int = 0; i < groupViews.length; i++) {
				for (var j:int = 0; j < addMessages.length; j++) {
					(groupViews[i] as ViewDefinition).addOn(addMessages[j]);
				}
			}
		}
		if (this.addMessages) {
			this.addMessages = this.addMessages.concat(addMessages);
		} else {
			this.addMessages = addMessages;
		}

		return this
	}

	public function removeOn(...removeMessages:Array):ViewGroupDefinition {
		if (groupViews != null) {
			for (var i:int = 0; i < groupViews.length; i++) {
				for (var j:int = 0; j < removeMessages.length; j++) {
					(groupViews[i] as ViewDefinition).removeOn(removeMessages[j]);
				}
			}
		}
		if (this.removeMessages) {
			this.removeMessages = this.removeMessages.concat(removeMessages);
		} else {
			this.removeMessages = removeMessages;
		}

		return this;
	}

	public function toggleOn(...toggleMessages:Array):ViewGroupDefinition {
		if (groupViews != null) {
			for (var i:int = 0; i < groupViews.length; i++) {
				for (var j:int = 0; j < toggleMessages.length; j++) {
					(groupViews[i] as ViewDefinition).toggleOn(toggleMessages[j]);
				}
			}
		}
		if (this.toggleMessages) {
			this.toggleMessages = this.toggleMessages.concat(toggleMessages);
		} else {
			this.toggleMessages = toggleMessages;
		}

		return this
	}

}
}
