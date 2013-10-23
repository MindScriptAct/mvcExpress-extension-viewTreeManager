// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.extensions.viewTreeManager.core {
import flash.utils.Dictionary;

import mvcexpress.core.CommandMap;
import mvcexpress.core.MediatorMap;
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.extensions.viewTreeManager.data.ViewDefinition;
import mvcexpress.extensions.viewTreeManager.namespace.viewTreeNs;
import mvcexpress.modules.ModuleCore;
import mvcexpress.mvc.Mediator;
import mvcexpress.utils.checkClassSuperclass;

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
	public static function initRootDefinition(module:ModuleCore, rootView:Object, rootMediatorClass:Class = null):ViewDefinition {

		use namespace pureLegsCore;


		var mediatorMap:MediatorMap = module.getMediatorMap();
		var commandMap:CommandMap = module.getCommandMap();

		if (mediatorMap == null || commandMap == null) {
			throw Error("Can't init view tree manager with module:" + module + ", it looks like module is not ready yet. (mediatorMap and/or commandMap should not be null.)");
		}

		if (rootMediatorClass == null) {
			rootMediatorClass = Mediator;
		}
		CONFIG::debug {
			if (!checkClassSuperclass(rootMediatorClass, "mvcexpress.mvc::Mediator", true)) {
				throw Error("rootMediatorClass:" + rootMediatorClass + " you are trying to use is not extended from 'mvcexpress.mvc::Mediator' class.");
			}
		}

		if (!viewTreeRegistryRoot[rootView]) {
			use namespace viewTreeNs;

			var viewNode:ViewNode = new ViewNode(mediatorMap, commandMap);
			viewTreeRegistryRoot[rootView] = viewNode;
			viewNodes.push(viewNode);

			return viewNode.initDefinition(rootView, rootMediatorClass);
		} else {
			throw Error("Object:" + rootView + " already used for view tree.");
		}
	}

	public static function getRootDefinition(viewObject:Object):ViewDefinition {
		var retVal:ViewDefinition;
		var viewNode:ViewNode = viewTreeRegistryRoot[viewObject];
		if (viewNode) {
			retVal = viewNode.getRootDefinition();
		}
		return retVal;
	}

	public static function getChildViewDefinition(viewObject:Object):ViewDefinition {
		use namespace viewTreeNs;

		var retVal:ViewDefinition;
		for (var i:int = 0; i < viewNodes.length; i++) {
			retVal = viewNodes[i].getViewDefinition(viewObject);
		}
		return retVal;
	}

	//----------------------------------
	//		internals
	//----------------------------------

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