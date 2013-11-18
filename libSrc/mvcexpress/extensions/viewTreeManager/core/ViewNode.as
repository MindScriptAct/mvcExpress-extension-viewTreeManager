// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.extensions.viewTreeManager.core {
import flash.utils.Dictionary;

import mvcexpress.core.CommandMap;
import mvcexpress.core.MediatorMap;
import mvcexpress.extensions.viewTreeManager.commands.ViewTreeCommand;
import mvcexpress.extensions.viewTreeManager.data.BaseDefinition;
import mvcexpress.extensions.viewTreeManager.data.ViewConstants;
import mvcexpress.extensions.viewTreeManager.data.ViewDefinition;
import mvcexpress.extensions.viewTreeManager.namespace.viewTreeNs;

/**
 * Class for view node management and data holding.
 *
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class ViewNode {

	private var moduleMediatorMap:MediatorMap;
	private var moduleCommandMap:CommandMap;

	private var toggleMessageRegistry:Dictionary = new Dictionary();
	private var addMessageRegistry:Dictionary = new Dictionary();
	private var removeMessageRegistry:Dictionary = new Dictionary();

	private var rootDefinition:ViewDefinition;

	private var childDefinitions:Dictionary = new Dictionary(); // view views by definition
	private var childViews:Dictionary = new Dictionary(); // view definitions by views

	public function ViewNode(mediatorMap:MediatorMap, commandMap:CommandMap) {
		this.moduleMediatorMap = mediatorMap;
		this.moduleCommandMap = commandMap;
	}

	public function getRootDefinition():ViewDefinition {
		return rootDefinition;
	}

	public function getViewDefinition(view:Object):ViewDefinition {
		return childViews[view];
	}


	//----------------------------------
	//		view definition
	//----------------------------------

	viewTreeNs function initDefinition(view:Object, viewMediatorClass:Class):ViewDefinition {
		use namespace viewTreeNs;

		if (!rootDefinition) {
			rootDefinition = new ViewDefinition(view.constructor, viewMediatorClass);
			rootDefinition.viewNode = this;

			rootDefinition.view = view;
			rootDefinition.viewClass = view.constructor;
			rootDefinition.mediatorClass = viewMediatorClass;

			childDefinitions[rootDefinition] = view;
			childViews[view] = rootDefinition;

			rootDefinition.isMapped = true;
			rootDefinition.parent = null; // root parent.
			moduleMediatorMap.mediateWith(view, viewMediatorClass);
		} else {
			throw Error("Root is already defined with " + rootDefinition.view);
		}
		return rootDefinition;
	}

	//----------------------------------
	//		views
	//----------------------------------

	viewTreeNs function addView(viewDefinition:BaseDefinition):void {
		use namespace viewTreeNs;

		// check if mediator is mapped.
		if (viewDefinition is ViewDefinition) {
			var mediatedViewDefinition:ViewDefinition = viewDefinition as ViewDefinition;
			if (!mediatedViewDefinition.isMapped) {
				mediatedViewDefinition.isMapped = true;
				if (!moduleMediatorMap.isMapped(viewDefinition.viewClass, mediatedViewDefinition.mediatorClass)) {
					moduleMediatorMap.map(viewDefinition.viewClass, mediatedViewDefinition.mediatorClass);
				}
			}
		}
		// check if parent is created.
		var parent:BaseDefinition = viewDefinition.parent;
		if (parent) { // check if parent is not root.
			var parentView:Object = childDefinitions[parent];
			if (parentView) { // check if parent view is added.
				if (!viewDefinition.view) { // check if object already created..
					var constructParams:Array = viewDefinition.constructParams;
					var view:Object;
					if (constructParams != null) {
						switch (constructParams.length) {
							case 0:
								view = new viewDefinition.viewClass();
								break;
							case 1:
								view = new viewDefinition.viewClass(constructParams[0]);
								break;
							case 2:
								view = new viewDefinition.viewClass(constructParams[0], constructParams[1]);
								break;
							case 3:
								view = new viewDefinition.viewClass(constructParams[0], constructParams[1], constructParams[2]);
								break;
							case 4:
								view = new viewDefinition.viewClass(constructParams[0], constructParams[1], constructParams[2], constructParams[3]);
								break;
							case 5:
								view = new viewDefinition.viewClass(constructParams[0], constructParams[1], constructParams[2], constructParams[3], constructParams[4]);
								break;
							case 6:
								view = new viewDefinition.viewClass(constructParams[0], constructParams[1], constructParams[2], constructParams[3], constructParams[4], constructParams[5]);
								break;
							case 7:
								view = new viewDefinition.viewClass(constructParams[0], constructParams[1], constructParams[2], constructParams[3], constructParams[4], constructParams[5], constructParams[6]);
								break;
							case 8:
								view = new viewDefinition.viewClass(constructParams[0], constructParams[1], constructParams[2], constructParams[3], constructParams[4], constructParams[5], constructParams[6], constructParams[7]);
								break;
							case 9:
								view = new viewDefinition.viewClass(constructParams[0], constructParams[1], constructParams[2], constructParams[3], constructParams[4], constructParams[5], constructParams[6], constructParams[7], constructParams[8]);
								break;
							case 10:
								view = new viewDefinition.viewClass(constructParams[0], constructParams[1], constructParams[2], constructParams[3], constructParams[4], constructParams[5], constructParams[6], constructParams[7], constructParams[8], constructParams[9]);
								break;
							default:
								throw Error("Too many view parameters, only 10 are suported.");
								break;
						}
					} else {
						view = new viewDefinition.viewClass();
					}

					// set custom params.
					var viewParams:Object = viewDefinition.viewParams;
					if (viewParams) {
						for (var key:String in viewParams) {
							try {
								view[key] = viewParams[key];
							} catch (error:Error) {
								trace("ERROR: failed to set view (" + view + ") parameter(" + key + "), with value :" + viewParams[key] + " - " + error);
							}
						}
					}

					viewDefinition.view = view;

					// sizing
					if (viewDefinition.trueWidthSizingType == ViewConstants.STATIC) {
						view.width = viewDefinition._trueSizeWidth;
					} else if (viewDefinition.trueWidthSizingType == ViewConstants.PERCENTAGE) {
						view.width = viewDefinition.parent.sizeWidth * (viewDefinition._trueSizeWidth / 100);
					}
					if (viewDefinition.trueWidthSizingType == ViewConstants.STATIC) {
						view.height = viewDefinition._trueSizeHeight;
					} else if (viewDefinition.trueWidthSizingType == ViewConstants.PERCENTAGE) {
						view.height = viewDefinition.parent.sizeHeight * (viewDefinition._trueSizeHeight / 100);
					}

					/// positioning
					if (viewDefinition.xPositionType > 0) {
						switch (viewDefinition.xPositionType) {
							case ViewConstants.STATIC:
								view.x = viewDefinition.posX;
								break;
							case ViewConstants.PERCENTAGE:
								view.x = viewDefinition.parent.sizeWidth * (viewDefinition.posX / 100) - viewDefinition.sizeWidth / 2;
								break;
							case ViewConstants.CENTERED:
								view.x = viewDefinition.parent.sizeWidth / 2 - viewDefinition.sizeWidth / 2 + viewDefinition.posX;
								break;
							case ViewConstants.START:
								view.x = viewDefinition.posX;
								break;
							case ViewConstants.END:
								view.x = viewDefinition.parent.sizeWidth - viewDefinition.posX - viewDefinition.sizeWidth;
								break;
						}
					}
					if (viewDefinition.yPositionType > 0) {
						switch (viewDefinition.yPositionType) {
							case ViewConstants.STATIC:
								view.y = viewDefinition.posY;
								break;
							case ViewConstants.PERCENTAGE:
								view.y = viewDefinition.parent.sizeHeight * (viewDefinition.posY / 100) - viewDefinition.sizeHeight / 2;
								break;
							case ViewConstants.CENTERED:
								view.y = viewDefinition.parent.sizeHeight / 2 - viewDefinition.sizeHeight / 2 + viewDefinition.posY;
								break;
							case ViewConstants.START:
								view.y = viewDefinition.posY;
								break;
							case ViewConstants.END:
								view.y = viewDefinition.parent.sizeHeight - viewDefinition.posY - viewDefinition.sizeHeight;
								break;
						}
					}

					// add
					if (viewDefinition.useIndexing) {
						// todo : find layer...
						var addIndex:int = -1;
						var nextDefinition:BaseDefinition = viewDefinition.nextSibling;
						while (nextDefinition) {
							if (nextDefinition.ignoreOrder) {
								nextDefinition = nextDefinition.nextSibling;
							} else {
								var nextView:Object = childDefinitions[nextDefinition];
								nextDefinition = nextDefinition.nextSibling;
								if (nextView != null) {
									addIndex = parentView[viewDefinition.getIndexFunction](nextView);
									nextDefinition = null;
								}
							}
						}
						if (addIndex > -1) {
							parentView[viewDefinition.addIndexedFunction](view, addIndex);
						} else {
							parentView[viewDefinition.addFunction](view);
						}

					} else {
						parentView[viewDefinition.addFunction](view);
					}

					//
					if (viewDefinition is ViewDefinition) {
						moduleMediatorMap.mediate(view);
					}

					//
					childDefinitions[viewDefinition] = view;
					childViews[view] = viewDefinition;

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

	viewTreeNs function removeView(viewDefinition:BaseDefinition):void {
		var retVal:Boolean = false;

		use namespace viewTreeNs;

		// check if parent is created.
		var parent:BaseDefinition = viewDefinition.parent;
		if (parent) { // check if parent is not root.
			var parentView:Object = childDefinitions[parent];
			//
			var view:Object = viewDefinition.view;
			if (view) {
				//
				parentView[viewDefinition.removeFunction](view);
				//
				delete childViews[childDefinitions[viewDefinition]];
				delete childDefinitions[viewDefinition];
				//
				if (viewDefinition is ViewDefinition) {
					moduleMediatorMap.unmediate(view);
				}
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

	viewTreeNs function initAddMessages(viewDefinition:BaseDefinition, addMessages:Array):void {
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

	viewTreeNs function initRemoveMessages(viewDefinition:BaseDefinition, removeMessages:Array):void {
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

	viewTreeNs function initToggleMessages(viewDefinition:BaseDefinition, toggleMessages:Array):void {
		for (var i:int = 0; i < toggleMessages.length; i++) {
			var message:String = toggleMessages[i];
			if (toggleMessageRegistry[message] == null) {
				toggleMessageRegistry[message] = new Vector.<ViewDefinition>();
				if (!moduleCommandMap.isMapped(message, ViewTreeCommand)) {
					moduleCommandMap.map(message, ViewTreeCommand)
				}
			}
			toggleMessageRegistry[message].push(viewDefinition);
		}
	}

	viewTreeNs function triggerMessage(messageType:String):void {
		use namespace viewTreeNs;

		///debug:viewTree**/trace("ViewNode.triggerMessage() ", messageType);

		var viewDefinitions:Vector.<ViewDefinition>;
		var viewDefinitionCount:int;
		var viewDefinition:ViewDefinition;
		var i:int;

		// toggle check
		viewDefinitions = toggleMessageRegistry[messageType];
		if (viewDefinitions) {
			viewDefinitionCount = viewDefinitions.length;
			for (i = 0; i < viewDefinitionCount; i++) {
				viewDefinition = viewDefinitions[i];
				if (!viewDefinition.view) {
					addView(viewDefinition);
				} else {
					removeView(viewDefinition);
				}
			}
		}

		// remove check
		viewDefinitions = removeMessageRegistry[messageType];
		if (viewDefinitions) {
			viewDefinitionCount = viewDefinitions.length;
			for (i = 0; i < viewDefinitionCount; i++) {
				viewDefinition = viewDefinitions[i];
				if (viewDefinition.view) {
					removeView(viewDefinition);
				}
			}
		}

		// add check
		viewDefinitions = addMessageRegistry[messageType];
		if (viewDefinitions) {
			viewDefinitionCount = viewDefinitions.length;
			for (i = 0; i < viewDefinitionCount; i++) {
				viewDefinition = viewDefinitions[i];
				if (!viewDefinition.view) {
					addView(viewDefinition);
				}
			}
		}
	}

}
}
