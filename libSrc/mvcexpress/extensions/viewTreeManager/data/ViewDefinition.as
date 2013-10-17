// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.extensions.viewTreeManager.data {
import mvcexpress.extensions.viewTreeManager.namespace.viewTreeNs;

use namespace viewTreeNs;

/**
 * Single view object definition.
 *
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class ViewDefinition extends BaseDefinition {

	viewTreeNs var mediatorClass:Class;

	viewTreeNs var isMapped:Boolean = false;

	public function ViewDefinition(viewClass:Class, mediatorClass:Class, constructParams:Array = null, viewParams:Object = null) {
		super(viewClass, constructParams, viewParams);
		this.mediatorClass = mediatorClass;
		CONFIG::debug {
			// TODO : check parameter count for viewClass ? does it match class constructor..
			if (constructParams && constructParams.length > 10) {
				throw Error("Only 10 view parameters supported.");
			}
		}
	}


	/**
	 * Push view definitions as child's. (ViewDefinition, ViewComboDefinition, ViewGroupDefinition, ViewStackDefinition is supported.)
	 * View definitions will be used to manage views automatically. (create, mediate, add as child to parent view, position,  size...)
	 * @param views
	 * @return
	 */
	public function pushViews(...views:Array):ViewDefinition {
		use namespace viewTreeNs;

		for (var i:int = 0; i < views.length; i++) {
			if (views[i] is StaticViewDefinition) {
				pushViewDefinition(views[i]);

			} else if (views[i] is ViewDefinition) {
				pushViewDefinition(views[i]);

			} else if (views[i] is ViewGroupDefinition) {
				var groupViews:Array = (views[i] as ViewGroupDefinition).groupViews;
				for (var j:int = 0; j < groupViews.length; j++) {
					if (groupViews[j] is ViewDefinition) {
						pushViewDefinition(groupViews[j] as ViewDefinition);
					} else {
						throw  Error("You can add only ViewDefinition objects to ViewGroupDefinition.");
					}
				}

			} else if (views[i] is ViewComboDefinition) {
				(views[i] as ViewComboDefinition).initComboDefinitions();
				var comboViews:Array = (views[i] as ViewComboDefinition).comboViews;
				for (j = 0; j < comboViews.length; j++) {
					if (comboViews[j] is ViewDefinition) {
						pushViewDefinition(comboViews[j] as ViewDefinition, true);
					} else {
						throw  Error("You can add only ViewDefinition objects to ViewComboDefinition.");
					}
				}

			} else if (views[i] is ViewStackDefinition) {
				var stackViews:Array = (views[i] as ViewStackDefinition).stackViews;
				for (j = 0; j < stackViews.length; j++) {
					if (stackViews[j] is ViewDefinition) {
						pushViewDefinition(stackViews[j] as ViewDefinition, true);
					} else {
						throw  Error("You can add only ViewDefinition objects to ViewStackDefinition.");
					}
				}

			} else {
				throw  Error(views[i] + " type is not supported." /*"You can add only ViewDefinition objects."*/);
			}
		}
		return this;
	}

	// push one viewDefinition
	private function pushViewDefinition(viewDefinition:BaseDefinition, ignoreOrder:Boolean = false):ViewDefinition {
		viewDefinition.viewNode = viewNode;
		viewDefinition.parent = this;

		//
		if (headChild) {
			viewDefinition.nextSibling = headChild;
		}
		this.headChild = viewDefinition;

		//
		viewDefinition.ignoreOrder = ignoreOrder;

		//
		this.childViews.push(viewDefinition);

		if (viewDefinition.toggleMessages) {
			viewNode.initToggleMessages(viewDefinition, viewDefinition.toggleMessages);
		}
		if (viewDefinition.addMessages) {
			viewNode.initAddMessages(viewDefinition, viewDefinition.addMessages);
		}
		if (viewDefinition.removeMessages) {
			viewNode.initRemoveMessages(viewDefinition, viewDefinition.removeMessages);
		}
		if (viewDefinition.isAutoAdded) {
			viewNode.addView(viewDefinition);
		}

		return this;
	}


	override public function dispose():void {
		use namespace viewTreeNs;

		mediatorClass = null;
		super.dispose();
	}
}
}
