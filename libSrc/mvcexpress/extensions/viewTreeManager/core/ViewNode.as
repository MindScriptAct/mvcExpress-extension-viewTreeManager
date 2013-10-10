package mvcexpress.extensions.viewTreeManager.core {
import flash.utils.Dictionary;

import mvcexpress.core.CommandMap;
import mvcexpress.core.MediatorMap;
import mvcexpress.extensions.viewTreeManager.commands.ViewTreeCommand;
import mvcexpress.extensions.viewTreeManager.data.ViewDefinition;
import mvcexpress.extensions.viewTreeManager.namespace.viewTreeNs;

public class ViewNode {

	private var moduleMediatorMap:MediatorMap;
	private var moduleCommandMap:CommandMap;

	private var viewRegistry:Dictionary = new Dictionary();
	private var addMessageRegistry:Dictionary = new Dictionary();
	private var removeMessageRegistry:Dictionary = new Dictionary();

	private var rootDefinition:ViewDefinition;

	public function ViewNode(mediatorMap:MediatorMap, commandMap:CommandMap) {
		this.moduleMediatorMap = mediatorMap;
		this.moduleCommandMap = commandMap;
	}

	public function getRootDefinition():ViewDefinition {
		return rootDefinition;
	}

	//----------------------------------
	//		view definition
	//----------------------------------

	viewTreeNs function initNewDefinition(root:Object, rootMediatorClass:Class):ViewDefinition {
		use namespace viewTreeNs;

		if (!rootDefinition) {
			rootDefinition = new ViewDefinition(root.constructor, rootMediatorClass);
			rootDefinition.viewTreeManager = this;

			viewRegistry[rootDefinition] = root;
			rootDefinition.view = root;

			moduleMediatorMap.map(root.constructor, rootMediatorClass);
			rootDefinition.isMapped = true;
			rootDefinition.parent = null; // root parent.
			moduleMediatorMap.mediate(root);
		} else {
			throw Error("Root is already defined with " + rootDefinition.view);
		}
		return rootDefinition;
	}

	//----------------------------------
	//		views
	//----------------------------------

	viewTreeNs function addView(viewDefinition:ViewDefinition):void {
		use namespace viewTreeNs;

		// check if mediator is mapped.
		if (!viewDefinition.isMapped) {
			viewDefinition.isMapped = true;
			if (!moduleMediatorMap.isMapped(viewDefinition.viewClass, viewDefinition.mediatorClass)) {
				moduleMediatorMap.map(viewDefinition.viewClass, viewDefinition.mediatorClass);
			}
		}
		// check if parent is created.
		var parent:ViewDefinition = viewDefinition.parent;
		if (parent) { // check if parent is not root.
			var parentView:Object = viewRegistry[parent];
			if (parentView) { // check if parent view is added.
				if (!viewDefinition.view) { // check if object already created..
					var viewParams:Array = viewDefinition.viewParams;
					var view:Object;
					if (viewParams != null) {
						switch (viewParams.length) {
							case 0:
								view = new viewDefinition.viewClass();
								break;
							case 1:
								view = new viewDefinition.viewClass(viewParams[0]);
								break;
							case 2:
								view = new viewDefinition.viewClass(viewParams[0], viewParams[1]);
								break;
							case 3:
								view = new viewDefinition.viewClass(viewParams[0], viewParams[1], viewParams[2]);
								break;
							case 4:
								view = new viewDefinition.viewClass(viewParams[0], viewParams[1], viewParams[2], viewParams[3]);
								break;
							case 5:
								view = new viewDefinition.viewClass(viewParams[0], viewParams[1], viewParams[2], viewParams[3], viewParams[4]);
								break;
							case 6:
								view = new viewDefinition.viewClass(viewParams[0], viewParams[1], viewParams[2], viewParams[3], viewParams[4], viewParams[5]);
								break;
							case 7:
								view = new viewDefinition.viewClass(viewParams[0], viewParams[1], viewParams[2], viewParams[3], viewParams[4], viewParams[5], viewParams[6]);
								break;
							case 8:
								view = new viewDefinition.viewClass(viewParams[0], viewParams[1], viewParams[2], viewParams[3], viewParams[4], viewParams[5], viewParams[6], viewParams[7]);
								break;
							case 9:
								view = new viewDefinition.viewClass(viewParams[0], viewParams[1], viewParams[2], viewParams[3], viewParams[4], viewParams[5], viewParams[6], viewParams[7], viewParams[8]);
								break;
							case 10:
								view = new viewDefinition.viewClass(viewParams[0], viewParams[1], viewParams[2], viewParams[3], viewParams[4], viewParams[5], viewParams[6], viewParams[7], viewParams[8], viewParams[9]);
								break;
							default:
								throw Error("Too many view parameters, only 10 are suported.");
								break;
						}
					} else {
						view = new viewDefinition.viewClass();
					}
					viewDefinition.view = view;

					// sizing
					if (viewDefinition.widthSizingType == ViewDefinition.STATIC) {
						view.width = viewDefinition.sizeWidth;
					} else if (viewDefinition.widthSizingType == ViewDefinition.PERCENTAGE) {
						view.width = viewDefinition.parent.sizeWidth * (viewDefinition._sizeWidth / 100);
					}
					if (viewDefinition.widthSizingType == ViewDefinition.STATIC) {
						view.height = viewDefinition.sizeHeight;
					} else if (viewDefinition.widthSizingType == ViewDefinition.PERCENTAGE) {
						view.height = viewDefinition.parent.sizeHeight * (viewDefinition._sizeHeight / 100);
					}

					/// positioning
					if (viewDefinition.xPositionType > 0) {
						switch (viewDefinition.xPositionType) {
							case ViewDefinition.STATIC:
								view.x = viewDefinition.posX;
								break;
							case ViewDefinition.PERCENTAGE:
								view.x = viewDefinition.parent.sizeWidth * (viewDefinition.posX / 100) - viewDefinition.sizeWidth / 2;
								break;
							case ViewDefinition.CENTERED:
								view.x = viewDefinition.parent.sizeWidth / 2 - viewDefinition.sizeWidth / 2 + viewDefinition.posX;
								break;
							case ViewDefinition.START:
								view.x = viewDefinition.posX;
								break;
							case ViewDefinition.END:
								view.x = viewDefinition.parent.sizeWidth - viewDefinition.posX - viewDefinition.sizeWidth;
								break;
						}
					}
					if (viewDefinition.yPositionType > 0) {
						switch (viewDefinition.yPositionType) {
							case ViewDefinition.STATIC:
								view.y = viewDefinition.posY;
								break;
							case ViewDefinition.PERCENTAGE:
								view.y = viewDefinition.parent.sizeHeight * (viewDefinition.posY / 100) - viewDefinition.sizeHeight / 2;
								break;
							case ViewDefinition.CENTERED:
								view.y = viewDefinition.parent.sizeHeight / 2 - viewDefinition.sizeHeight / 2 + viewDefinition.posY;
								break;
							case ViewDefinition.START:
								view.y = viewDefinition.posY;
								break;
							case ViewDefinition.END:
								view.y = viewDefinition.parent.sizeHeight - viewDefinition.posY - viewDefinition.sizeHeight;
								break;
						}
					}

					//
					parentView[viewDefinition.addFunction](view);
					//
					moduleMediatorMap.mediate(view);
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
				moduleMediatorMap.unmediate(view);
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

	//----------------------------------
	//		message handling
	//----------------------------------

	viewTreeNs function initAddMesages(viewDefinition:ViewDefinition, addMessages:Array):void {
		for (var i:int = 0; i < addMessages.length; i++) {
			var message:String = addMessages[i];
			if (addMessageRegistry[message] == null) {
				addMessageRegistry[message] = new Vector.<ViewDefinition>();
				if (!moduleCommandMap.isMapped(message, ViewTreeCommand)) {
					moduleCommandMap.map(message, ViewTreeCommand)
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
				if (!moduleCommandMap.isMapped(message, ViewTreeCommand)) {
					moduleCommandMap.map(message, ViewTreeCommand)
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


}
}
