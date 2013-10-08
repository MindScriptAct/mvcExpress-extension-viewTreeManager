/**
 * Created with IntelliJ IDEA.
 * User: rbanevicius
 * Date: 4/11/13
 * Time: 5:58 PM
 * To change this template use File | Settings | File Templates.
 */
package mvcexpress.extensions.viewTreeManager.data {
import mvcexpress.extensions.viewTreeManager.ViewTreeExpress;
import mvcexpress.extensions.viewTreeManager.namespace.viewTreeNs;

use namespace viewTreeNs;

public class ViewDefinition {

	public var viewClass:Class;
	public var mediatorClass:Class;

	private var isAutoAdded:Boolean = false;

	// TODO : internal...
	viewTreeNs var childViews:Vector.<ViewDefinition> = new Vector.<ViewDefinition>();

	viewTreeNs var viewTreeManager:ViewTreeExpress;
	viewTreeNs var isMapped:Boolean = false;
	viewTreeNs var parent:ViewDefinition;
	//
	viewTreeNs var view:Object;
	//
	viewTreeNs var addFunction:String = "addChild";
	viewTreeNs var removeFunction:String = "removeChild";
	//
	viewTreeNs var addMessages:Array;
	viewTreeNs var removeMessages:Array;
	//
	viewTreeNs var injectIntoParentVarName:String;
	viewTreeNs var onAddParentFunctionName:String;
	viewTreeNs var onAddParentFunctionParams:Array;
	viewTreeNs var onRemoveParentFunctionName:String;
	viewTreeNs var onRemoveParentFunctionParams:Array;

	public function ViewDefinition(viewClass:Class, mediatorClass:Class) {
		this.viewClass = viewClass;
		this.mediatorClass = mediatorClass;
	}

	public function addViews(...views:Array):void {
		for (var i:int = 0; i < views.length; i++) {
			// TODO : check for ViewDefinition ?
			var viewDefinition:ViewDefinition = views[i] as ViewDefinition;
			if (viewDefinition) {
				viewDefinition.viewTreeManager = viewTreeManager;
				viewDefinition.parent = this;
				this.childViews.push(viewDefinition);
				if (viewDefinition.addMessages) {
					viewTreeManager.initAddMesages(viewDefinition, viewDefinition.addMessages);
				}
				if (viewDefinition.removeMessages) {
					viewTreeManager.initRemoveMesages(viewDefinition, viewDefinition.removeMessages);
				}
				if (viewDefinition.isAutoAdded) {
					viewTreeManager.addView(viewDefinition);
				}
			} else {
				throw  Error("You can add only ViewDefinition objects.");
			}
		}

	}

	public function autoAdd():ViewDefinition {
		isAutoAdded = true;
		return this;
	}

	public function addOn(...addMessages:Array):ViewDefinition {
		this.addMessages = addMessages;
		return this;
	}

	public function removeOn(...removeMessages:Array):ViewDefinition {
		this.removeMessages = removeMessages;
		return this;
	}

	public function injectIntoParentAs(varName:String):ViewDefinition {
		this.injectIntoParentVarName = varName;
		return this;
	}

	public function executeParentFunctionOnAdd(functionName:String, functionParams:Array):ViewDefinition {
		this.onAddParentFunctionName = functionName;
		this.onAddParentFunctionParams = functionParams;
		return this;
	}

	public function executeParentFunctionOnRemove(functionName:String, functionParams:Array):ViewDefinition {
		this.onRemoveParentFunctionName = functionName;
		this.onRemoveParentFunctionParams = functionParams;
		return this;
	}

	public function positionAt(x:Object, y:Object, z:Object = null):ViewDefinition {
		// TODO : implement
		return this;
	}

	public function sizeAs(width:Object, heighth:Object, depth:Object = null):ViewDefinition {
		// TODO : implement
		return this;
	}

}
}
