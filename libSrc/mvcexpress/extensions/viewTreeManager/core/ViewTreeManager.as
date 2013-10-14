// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.extensions.viewTreeManager.core {
import flash.utils.Dictionary;

import mvcexpress.core.CommandMap;
import mvcexpress.core.MediatorMap;
import mvcexpress.extensions.viewTreeManager.data.ViewDefinition;
import mvcexpress.extensions.viewTreeManager.namespace.viewTreeNs;

/**
 * Core Module class, represents single application unit in mvcExpress framework.
 * <p>
 * It starts framework and lets you set up your application. (or execute Commands for set up.)
 * You can create modular application by having more then one module.
 * </p>
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 *
 * @version scoped.1.0.beta2
 */
public class ViewTreeManager {


	private static var viewTreeRegistryRoot:Dictionary = new Dictionary();

	private static var viewNodes:Vector.<ViewNode> = new Vector.<ViewNode>();


	public static function initRootDefinition(mediatorMap:MediatorMap, commandMap:CommandMap, rootView:Object, rootMediatorClass:Class):ViewDefinition {

		if (!viewTreeRegistryRoot[rootView]) {

			// TODO: check mediatorMap, commandMap... root?

			var viewNode:ViewNode = new ViewNode(mediatorMap, commandMap);
			viewTreeRegistryRoot[rootView] = viewNode;
			viewNodes.push(viewNode);

			use namespace viewTreeNs;

			return viewNode.initNewDefinition(rootView, rootMediatorClass);

		} else {
			throw  Error("Object:" + rootView + " already used for view tree.");
		}
	}

	//----------------------------------
	//		internals
	//----------------------------------

	viewTreeNs static function getRootDefinition(root:Object):ViewDefinition {
		var retVal:ViewDefinition;
		var viewNode:ViewNode = viewTreeRegistryRoot[root];

		if (viewNode) {
			retVal = viewNode.getRootDefinition();
		}
		return retVal;
	}


	viewTreeNs static function trigerMessage(messageType:String):void {
		use namespace viewTreeNs;

		var viewTreeCount:int = viewNodes.length;

		for (var i:int = 0; i < viewTreeCount; i++) {
			var viewNode:ViewNode = viewNodes[i];
			//viewNode.trigerRemoveMessage(messageType);
			//viewNode.trigerAddMessage(messageType);

			viewNode.triggerMessage(messageType);
		}
	}


}
}