/**
 * Created with IntelliJ IDEA.
 * User: rbanevicius
 * Date: 4/11/13
 * Time: 5:56 PM
 * To change this template use File | Settings | File Templates.
 */
package org.mvcexpress.extensions.viewTree {
import flash.utils.Dictionary;

import org.mvcexpress.core.CommandMap;
import org.mvcexpress.core.MediatorMap;
import org.mvcexpress.extensions.viewTree.commands.ViewTreeAddCommand;
import org.mvcexpress.extensions.viewTree.commands.ViewTreeRemoveCommand;
import org.mvcexpress.extensions.viewTree.data.ViewDefinition;
import org.mvcexpress.extensions.viewTree.namespace.viewTreeNs;

public class ViewTreeExpress {

	private static var viewTreeRegistryroot:Dictionary = new Dictionary();
	private static var viewTrees:Vector.<ViewTreeExpress> = new Vector.<ViewTreeExpress>();

	public static function init(mediatorMap:MediatorMap, commandMap:CommandMap, root:Object, rootMediatorClass:Class):ViewDefinition {

		if (!viewTreeRegistryroot[root]) {
			var viewTreeManager:ViewTreeExpress = new ViewTreeExpress(mediatorMap, commandMap);

			viewTreeRegistryroot[root] = viewTreeManager;

			viewTrees.push(viewTreeManager);

			use namespace viewTreeNs;

			return viewTreeManager.initRootDefinition(root, rootMediatorClass);

		} else {
			throw  Error("Object:" + root + " already used for view tree.");
		}
	}

	public static function getRootDefinition(root:Object):ViewDefinition {
		var retVal:ViewDefinition;
		var viewTreeManager:ViewTreeExpress = viewTreeRegistryroot[root];

		if (viewTreeManager) {
			retVal = viewTreeManager.getRootDefinition();
		}
		return retVal;
	}


	viewTreeNs static function trigerAddMessage(messageType:String):void {
		use namespace viewTreeNs;

		var viewTreeCount:int = viewTrees.length;
		for (var i:int = 0; i < viewTreeCount; i++) {
			var viewTree:ViewTreeExpress = viewTrees[i];
			viewTree.trigerAddMessage(messageType);
		}
	}

	viewTreeNs static function trigerRemoveMessage(messageType:String):void {
		use namespace viewTreeNs;

		var viewTreeCount:int = viewTrees.length;
		for (var i:int = 0; i < viewTreeCount; i++) {
			var viewTree:ViewTreeExpress = viewTrees[i];
			viewTree.trigerRemoveMessage(messageType);
		}
	}

	//////////////
	//
	/////////////

	private var mediatorMap:MediatorMap;
	private var viewRegistry:Dictionary = new Dictionary();
	private var addMessageRegistry:Dictionary = new Dictionary();
	private var removeMessageRegistry:Dictionary = new Dictionary();
	private var commandMap:CommandMap;
	private var rootDefinition:ViewDefinition;

	public function ViewTreeExpress(mediatorMap:MediatorMap, commandMap:CommandMap) {
		this.mediatorMap = mediatorMap;
		this.commandMap = commandMap;
	}

	viewTreeNs function initRootDefinition(root:Object, rootMediatorClass:Class):ViewDefinition {
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
							if (onAddFunc) {
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
						if (onRemoveFunc) {
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
				commandMap.map(message, ViewTreeAddCommand)
			}
			addMessageRegistry[message].push(viewDefinition);
		}
	}

	viewTreeNs function initRemoveMesages(viewDefinition:ViewDefinition, removeMessages:Array):void {
		for (var i:int = 0; i < removeMessages.length; i++) {
			var message:String = removeMessages[i];
			if (removeMessageRegistry[message] == null) {
				removeMessageRegistry[message] = new Vector.<ViewDefinition>();
				commandMap.map(message, ViewTreeRemoveCommand)
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
