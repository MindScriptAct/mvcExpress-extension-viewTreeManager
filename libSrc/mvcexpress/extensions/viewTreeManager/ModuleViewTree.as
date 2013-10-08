// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.extensions.viewTreeManager {
import flash.utils.Dictionary;

import mvcexpress.core.CommandMap;
import mvcexpress.core.ExtensionManager;
import mvcexpress.core.MediatorMap;
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.extensions.viewTreeManager.commands.ViewTreeCommand;
import mvcexpress.extensions.viewTreeManager.data.ViewDefinition;
import mvcexpress.extensions.viewTreeManager.namespace.viewTreeNs;
import mvcexpress.modules.ModuleCore;

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
public class ModuleViewTree extends ModuleCore {


	public function ModuleViewTree(moduleName:String = null, mediatorMapClass:Class = null, proxyMapClass:Class = null, commandMapClass:Class = null, messengerClass:Class = null) {

		CONFIG::debug {
			use namespace pureLegsCore;

			enableExtension(EXTENSION_VIEWTREE_ID);
		}

		super(moduleName, mediatorMapClass, proxyMapClass, commandMapClass, messengerClass);

	}


	//----------------------------------
	//     ...
	//----------------------------------

	protected function initRootDefinition(mainObject:Object, mainMediatorClass:Class):ViewDefinition {
		use namespace viewTreeNs;
		return ModuleViewTree.init(this, mediatorMap, commandMap, mainObject, mainMediatorClass);
	}

	//----------------------------------
	//    Extension checking: INTERNAL, DEBUG ONLY.
	//----------------------------------

	CONFIG::debug
	static pureLegsCore const EXTENSION_VIEWTREE_ID:int = ExtensionManager.getExtensionIdByName(pureLegsCore::EXTENSION_VIEWTREE_NAME);

	CONFIG::debug
	static pureLegsCore const EXTENSION_VIEWTREE_NAME:String = "viewTree";


	//----------------------------------
	//		STATIC viewTree internals
	//----------------------------------

	private static var viewTreeRegistryroot:Dictionary = new Dictionary();
	private static var viewTrees:Vector.<ModuleViewTree> = new Vector.<ModuleViewTree>();

	viewTreeNs static function init(module:ModuleViewTree, mediatorMap:MediatorMap, commandMap:CommandMap, root:Object, rootMediatorClass:Class):ViewDefinition {

		if (!viewTreeRegistryroot[root]) {

			viewTreeRegistryroot[root] = module;

			viewTrees.push(module);

			use namespace viewTreeNs;

			return module.initNewDefinition(root, rootMediatorClass);

		} else {
			throw  Error("Object:" + root + " already used for view tree.");
		}
	}

	viewTreeNs static function getRootDefinition(root:Object):ViewDefinition {
		var retVal:ViewDefinition;
		var viewTreeManager:ModuleViewTree = viewTreeRegistryroot[root];

		if (viewTreeManager) {
			retVal = viewTreeManager.getRootDefinition();
		}
		return retVal;
	}


	viewTreeNs static function trigerMessage(messageType:String):void {
		use namespace viewTreeNs;

		var viewTreeCount:int = viewTrees.length;

		for (var i:int = 0; i < viewTreeCount; i++) {
			var viewTree:ModuleViewTree = viewTrees[i];
			viewTree.trigerRemoveMessage(messageType);
			viewTree.trigerAddMessage(messageType);
		}
	}

	//----------------------------------
	//		viewTree internals
	//----------------------------------

	private var viewRegistry:Dictionary = new Dictionary();
	private var addMessageRegistry:Dictionary = new Dictionary();
	private var removeMessageRegistry:Dictionary = new Dictionary();
	private var rootDefinition:ViewDefinition;

	viewTreeNs function initNewDefinition(root:Object, rootMediatorClass:Class):ViewDefinition {
		use namespace viewTreeNs;

		if (!rootDefinition) {
			rootDefinition = new ViewDefinition(root.constructor, rootMediatorClass);
			rootDefinition.viewTreeManager = this;

			viewRegistry[rootDefinition] = root;
			rootDefinition.view = root;

			mediatorMap.map(root.constructor, rootMediatorClass);
			rootDefinition.isMapped = true;
			rootDefinition.parent = null; // root parent.
			mediatorMap.mediate(root);
		} else {
			throw Error("Root is already defined with " + rootDefinition.view);
		}
		return rootDefinition;
	}

	viewTreeNs function addView(viewDefinition:ViewDefinition):void {
		use namespace viewTreeNs;

		// check if mediator is mapped.
		if (!viewDefinition.isMapped) {
			viewDefinition.isMapped = true;
			mediatorMap.map(viewDefinition.viewClass, viewDefinition.mediatorClass);
		}
		// check if parent is created.
		var parent:ViewDefinition = viewDefinition.parent;
		if (parent) { // check if parent is not root.
			var parentView:Object = viewRegistry[parent];
			if (parentView) { // check if parent view is added.
				if (!viewDefinition.view) { // check if object already created..
					// TODO : view params...
					var view:Object = new viewDefinition.viewClass();
					viewDefinition.view = view;
					//
					parentView[viewDefinition.addFunction](view);
					//
					mediatorMap.mediate(view);
					viewRegistry[viewDefinition] = view;
					// inject view to parent
					if (viewDefinition.injectIntoParentVarName) {
						try {
							parentView[viewDefinition.injectIntoParentVarName] = view;
						} catch (error:Error) {
							trace("ERROR: failed to inject view(" + view + ") into parent(" + parentView + "), under variable name :" + viewDefinition.injectIntoParentVarName + " - " + error);
						}
					}
					// execute parent function
					if (viewDefinition.onAddParentFunctionName) {
						try {
							var onAddFunc:Function = parentView[viewDefinition.onAddParentFunctionName] as Function;
							if (onAddFunc != null) {
								if (viewDefinition.onAddParentFunctionParams) {
									onAddFunc.apply(null, viewDefinition.onAddParentFunctionParams);
								} else {
									onAddFunc();
								}
							}
						} catch (error:Error) {
							trace("ERROR: failed to execute view(" + view + ") on add function in parent(" + parentView + ") with name :" + viewDefinition.onAddParentFunctionName + " - " + error);
						}
					}
				}
			}
		}
	}

	viewTreeNs function removeView(viewDefinition:ViewDefinition):void {
		use namespace viewTreeNs;

		// check if parent is created.
		var parent:ViewDefinition = viewDefinition.parent;
		if (parent) { // check if parent is not root.
			var parentView:Object = viewRegistry[parent];
			//
			var view:Object = viewDefinition.view;
			if (view) {
				//
				parentView[viewDefinition.removeFunction](view);
				mediatorMap.unmediate(view);
				//
				viewDefinition.view = null;
				// execute parent function
				if (viewDefinition.onRemoveParentFunctionName) {
					try {
						var onRemoveFunc:Function = parentView[viewDefinition.onRemoveParentFunctionName] as Function;
						if (onRemoveFunc != null) {
							if (viewDefinition.onRemoveParentFunctionParams) {
								onRemoveFunc.apply(null, viewDefinition.onRemoveParentFunctionParams);
							} else {
								onRemoveFunc();
							}
						}
					} catch (error:Error) {
						trace("ERROR: failed to execute view(" + view + ") on remove function in parent(" + parentView + ") with name :" + viewDefinition.onRemoveParentFunctionName + " - " + error);
					}
				}
			}
		}
	}


	viewTreeNs function initAddMesages(viewDefinition:ViewDefinition, addMessages:Array):void {
		for (var i:int = 0; i < addMessages.length; i++) {
			var message:String = addMessages[i];
			if (addMessageRegistry[message] == null) {
				addMessageRegistry[message] = new Vector.<ViewDefinition>();
				if (!commandMap.isMapped(message, ViewTreeCommand)) {
					commandMap.map(message, ViewTreeCommand)
				}
			}
			addMessageRegistry[message].push(viewDefinition);
		}
	}

	viewTreeNs function initRemoveMesages(viewDefinition:ViewDefinition, removeMessages:Array):void {
		for (var i:int = 0; i < removeMessages.length; i++) {
			var message:String = removeMessages[i];
			if (removeMessageRegistry[message] == null) {
				removeMessageRegistry[message] = new Vector.<ViewDefinition>();
				if (!commandMap.isMapped(message, ViewTreeCommand)) {
					commandMap.map(message, ViewTreeCommand)
				}
			}
			removeMessageRegistry[message].push(viewDefinition);
		}
	}


	viewTreeNs function trigerAddMessage(messageType:String):void {
		use namespace viewTreeNs;

		// check add
		var viewDefinitions:Vector.<ViewDefinition> = addMessageRegistry[messageType];
		var viewDefinitionCount:int = viewDefinitions.length;
		for (var i:int = 0; i < viewDefinitionCount; i++) {
			var viewDefinition:ViewDefinition = viewDefinitions[i];
			if (!viewDefinition.view) {
				addView(viewDefinition);
			}
		}
	}

	viewTreeNs function trigerRemoveMessage(messageType:String):void {
		use namespace viewTreeNs;

		// check remove
		var viewDefinitions:Vector.<ViewDefinition> = removeMessageRegistry[messageType];
		var viewDefinitionCount:int = viewDefinitions.length;
		for (var i:int = 0; i < viewDefinitionCount; i++) {
			var viewDefinition:ViewDefinition = viewDefinitions[i];
			if (viewDefinition.view) {
				removeView(viewDefinition);
			}
		}
	}

	public function getRootDefinition():ViewDefinition {
		return rootDefinition;
	}


}
}