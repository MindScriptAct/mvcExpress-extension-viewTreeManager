// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.extensions.viewTreeManager.core {
import flash.utils.Dictionary;

import mvcexpress.core.CommandMap;
import mvcexpress.core.MediatorMap;
import mvcexpress.extensions.viewTreeManager.data.ViewDefinition;
import mvcexpress.extensions.viewTreeManager.namespace.viewTreeNs;

/**
 * View tree manager to define view tree.
 *
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class ViewTreeManager {

	private static var viewTreeRegistryRoot:Dictionary = new Dictionary();

	private static var viewNodes:Vector.<ViewNode> = new Vector.<ViewNode>();

	/**
	 * Initialize root definition. (should be called from module)
	 * @param mediatorMap
	 * @param commandMap
	 * @param rootView
	 * @param rootMediatorClass
	 * @return
	 */
	public static function initRootDefinition(mediatorMap:MediatorMap, commandMap:CommandMap, rootView:Object, rootMediatorClass:Class):ViewDefinition {
		if (!viewTreeRegistryRoot[rootView]) {
			use namespace viewTreeNs;

			// TODO: check mediatorMap, commandMap... root?
			var viewNode:ViewNode = new ViewNode(mediatorMap, commandMap);
			viewTreeRegistryRoot[rootView] = viewNode;
			viewNodes.push(viewNode);

			return viewNode.initNewDefinition(rootView, rootMediatorClass);
		} else {
			throw Error("Object:" + rootView + " already used for view tree.");
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

	viewTreeNs static function triggerMessage(messageType:String):void {
		use namespace viewTreeNs;

		var viewTreeCount:int = viewNodes.length;
		for (var i:int = 0; i < viewTreeCount; i++) {
			var viewNode:ViewNode = viewNodes[i];
			viewNode.triggerMessage(messageType);
		}
	}


}
}