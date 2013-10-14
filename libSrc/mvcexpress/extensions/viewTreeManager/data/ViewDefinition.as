/**
 * Created with IntelliJ IDEA.
 * User: rbanevicius
 * Date: 4/11/13
 * Time: 5:58 PM
 * To change this template use File | Settings | File Templates.
 */
package mvcexpress.extensions.viewTreeManager.data {
import mvcexpress.extensions.viewTreeManager.core.ViewNode;
import mvcexpress.extensions.viewTreeManager.namespace.viewTreeNs;

use namespace viewTreeNs;

public class ViewDefinition {


	public static var NONE:int = 0;
	public static var STATIC:int = 1;
	public static var PERCENTAGE:int = 2;
	public static var CENTERED:int = 3;
	public static var START:int = 4;
	public static var END:int = 5;

	viewTreeNs var viewClass:Class;
	viewTreeNs var mediatorClass:Class;
	viewTreeNs var viewParams:Array;

	private var isAutoAdded:Boolean = false;

	// TODO : internal...
	viewTreeNs var childViews:Vector.<ViewDefinition> = new Vector.<ViewDefinition>();

	viewTreeNs var viewTreeManager:ViewNode;
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
	viewTreeNs var toggleMessages:Array;
	//
	viewTreeNs var injectIntoParentVarName:String;
	viewTreeNs var onAddParentFunctionName:String;
	viewTreeNs var onAddParentFunctionParams:Array;
	viewTreeNs var onRemoveParentFunctionName:String;
	viewTreeNs var onRemoveParentFunctionParams:Array;


	viewTreeNs var xPositionType:int = 0;
	viewTreeNs var posX:Number;
	viewTreeNs var yPositionType:int = 0;
	viewTreeNs var posY:Number;
	//viewTreeNs var posZ:Number;

	viewTreeNs var widthSizingType:int = 0;
	viewTreeNs var heightSizingType:int = 0;
	viewTreeNs var _sizeWidth:Number;
	viewTreeNs var _sizeHeight:Number;
	///viewTreeNs var sizeDepth:Number;

	public function ViewDefinition(viewClass:Class, mediatorClass:Class, viewParams:Array = null) {
		this.viewClass = viewClass;
		this.mediatorClass = mediatorClass;
		this.viewParams = viewParams;
		CONFIG::debug {

			// TODO : check parameter count for viewClass ? does it match class constructor..

			if (viewParams && viewParams.length > 10) {
				throw Error("Only 10 view parameters supported.");
			}
		}
	}

	public function addViews(...views:Array):void {
		for (var i:int = 0; i < views.length; i++) {
			// TODO : check for ViewDefinition ?
			var viewDefinition:ViewDefinition = views[i] as ViewDefinition;
			if (viewDefinition) {
				viewDefinition.viewTreeManager = viewTreeManager;
				viewDefinition.parent = this;
				this.childViews.push(viewDefinition);
				if (viewDefinition.toggleMessages) {
					viewTreeManager.initToggleMessages(viewDefinition, viewDefinition.toggleMessages);
				}
				if (viewDefinition.addMessages) {
					viewTreeManager.initAddMessages(viewDefinition, viewDefinition.addMessages);
				}
				if (viewDefinition.removeMessages) {
					viewTreeManager.initRemoveMessages(viewDefinition, viewDefinition.removeMessages);
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
		if (this.addMessages == null) {
			this.addMessages = addMessages;
		} else {
			for (var i:int = 0; i < addMessages.length; i++) {
				var newMessage:String = addMessages[i];
				var needToAdd:Boolean = true;
				for (var j:int = 0; j < this.addMessages.length; j++) {
					if (newMessage == this.addMessages[j]) {
						needToAdd = false;
						break;
					}
				}
				if (needToAdd) {
					this.addMessages.push(newMessage);
				}
			}
		}
		return this;
	}

	public function removeOn(...removeMessages:Array):ViewDefinition {
		if (this.removeMessages == null) {
			this.removeMessages = removeMessages;
		} else {
			for (var i:int = 0; i < removeMessages.length; i++) {
				var newMessage:String = removeMessages[i];
				var needToAdd:Boolean = true;
				for (var j:int = 0; j < this.removeMessages.length; j++) {
					if (newMessage == this.removeMessages[j]) {
						needToAdd = false;
						break;
					}
				}
				if (needToAdd) {
					this.removeMessages.push(newMessage);
				}
			}
		}
		return this;
	}

	public function toggleOn(...toggleMessages:Array):ViewDefinition {
		if (this.toggleMessages == null) {
			this.toggleMessages = toggleMessages;
		} else {
			for (var i:int = 0; i < toggleMessages.length; i++) {
				var newMessage:String = toggleMessages[i];
				var needToAdd:Boolean = true;
				for (var j:int = 0; j < this.toggleMessages.length; j++) {
					if (newMessage == this.toggleMessages[j]) {
						needToAdd = false;
						break;
					}
				}
				if (needToAdd) {
					this.toggleMessages.push(newMessage);
				}
			}
		}
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

	public function positionAt(x:Object, y:Object, z:Object = 0):ViewDefinition {
		var firstChar:String;
		var lastChar:String;
		var numberChars:String;

		if (x is Number) {
			xPositionType = STATIC;
			posX = Number(x);
		} else if (x is String) {
			var strLength:int = x.length;
			if (strLength > 0) {
				firstChar = x.charAt(0);
				lastChar = x.charAt(strLength - 1);
				if (lastChar == "%") {
					xPositionType = PERCENTAGE;
					posX = Number(x.substr(0, strLength - 1));
				} else if (firstChar == "^") {
					xPositionType = START;
					posX = Number(x.substr(1, strLength));
				} else if (lastChar == "^") {
					xPositionType = END;
					posX = Number(x.substr(0, strLength - 1));
				} else if (firstChar == "|") {
					xPositionType = CENTERED;
					posX = Number(x.substr(1, strLength));
				} else if (lastChar == "|") {
					xPositionType = CENTERED;
					posX = Number(x.substr(0, strLength - 1)) * -1;
				} else {
					xPositionType = STATIC;
					posX = Number(x);
				}
			}
		}
		if (y is Number) {
			yPositionType = STATIC;
			posY = Number(y);
		} else if (y is String) {
			strLength = y.length;
			if (strLength > 0) {
				firstChar = y.charAt(0);
				lastChar = y.charAt(strLength - 1);
				if (lastChar == "%") {
					yPositionType = PERCENTAGE;
					posY = Number(y.substr(0, strLength - 1));
				} else if (firstChar == "^") {
					yPositionType = START;
					posY = Number(y.substr(1, strLength));
				} else if (lastChar == "^") {
					yPositionType = END;
					posY = Number(y.substr(0, strLength - 1));
				} else if (firstChar == "|") {
					yPositionType = CENTERED;
					posY = Number(y.substr(1, strLength));
				} else if (lastChar == "|") {
					yPositionType = CENTERED;
					posY = Number(y.substr(0, strLength - 1)) * -1;
				} else {
					yPositionType = STATIC;
					posY = Number(y);
				}
			}
		}
		//posZ = z;
		return this;
	}

	public function sizeAs(width:Object, height:Object, depth:Object = 0):ViewDefinition {
		var strLength:int;
		var lastChar:String;

		widthSizingType = STATIC;
		if (width is Number) {
			_sizeWidth = Number(width);
		} else if (width is String) {
			strLength = width.length;
			if (strLength > 0) {
				lastChar = width.charAt(strLength - 1);
				if (lastChar == "%") {
					widthSizingType = PERCENTAGE;
					_sizeWidth = Number(width.substr(0, strLength - 1))
				} else {
					_sizeWidth = Number(width);
				}
			} else {
				_sizeWidth = view.width;
			}
		} else {
			heightSizingType = NONE;
		}
		heightSizingType = STATIC;
		if (height is Number) {
			_sizeHeight = Number(height);
		} else if (height is String) {
			strLength = height.length;
			if (strLength > 0) {
				lastChar = height.charAt(strLength - 1);
				if (lastChar == "%") {
					heightSizingType = PERCENTAGE;
					_sizeHeight = Number(height.substr(0, strLength - 1));
				} else {
					_sizeHeight = Number(height);
				}
			} else {
				_sizeHeight = view.height;
			}
		} else {
			heightSizingType = NONE;
		}

		//sizeDepth = depth;
		return this;
	}

	public function get sizeWidth():Number {
		if (widthSizingType == STATIC) {
			return _sizeWidth;
		} else if (widthSizingType == PERCENTAGE && view.parent) {
			return parent.sizeWidth * (_sizeWidth / 100);
		} else {
			return view.width;
		}
	}

	public function get sizeHeight():Number {
		if (heightSizingType == STATIC) {
			return _sizeHeight;
		} else if (heightSizingType == PERCENTAGE && view.parent) {
			return parent.sizeHeight * (_sizeHeight / 100);
		} else {
			return view.height;
		}
	}


}
}
