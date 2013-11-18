package mvcexpress.extensions.viewTreeManager.data {
import mvcexpress.extensions.viewTreeManager.core.ViewNode;
import mvcexpress.extensions.viewTreeManager.namespace.viewTreeNs;

use namespace viewTreeNs;

public class BaseDefinition {


	viewTreeNs var viewClass:Class;
	viewTreeNs var constructParams:Array;
	viewTreeNs var viewParams:Object;

	viewTreeNs var childViews:Vector.<BaseDefinition> = new Vector.<BaseDefinition>();

	viewTreeNs var viewNode:ViewNode;

	viewTreeNs var parent:BaseDefinition;

	//
	viewTreeNs var headChild:BaseDefinition;
	//
	viewTreeNs var nextSibling:BaseDefinition;
	//
	viewTreeNs var view:Object;
	//

	viewTreeNs var useIndexing:Boolean = true;
	viewTreeNs var addIndexedFunction:String = "addChildAt";
	viewTreeNs var getIndexFunction:String = "getChildIndex";
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

	//
	viewTreeNs var xPositionType:int = 0;
	viewTreeNs var posX:Number;
	viewTreeNs var yPositionType:int = 0;
	viewTreeNs var posY:Number;
	//viewTreeNs var posZ:Number;

	viewTreeNs var trueWidthSizingType:int = 0;
	viewTreeNs var trueHeightSizingType:int = 0;
	viewTreeNs var _trueSizeWidth:Number;
	viewTreeNs var _trueSizeHeight:Number;
	///viewTreeNs var _trueSizeDepth:Number;

	viewTreeNs var virtualWidthSizingType:int = 0;
	viewTreeNs var virtualHeightSizingType:int = 0;
	viewTreeNs var _virtualSizeWidth:Number;
	viewTreeNs var _virtualSizeHeight:Number;
	///viewTreeNs var _virtualSizeDepth:Number;

	viewTreeNs var ignoreOrder:Boolean;

	viewTreeNs var isAutoAdded:Boolean = false;


	public function BaseDefinition(viewClass:Class, constructParams:Array, viewParams:Object) {
		this.viewClass = viewClass;
		this.constructParams = constructParams;
		this.viewParams = viewParams;
	}

	/**
	 * View will be added/mediated automatically with parent.
	 * @return self
	 */
	public function autoAdd():BaseDefinition {
		isAutoAdded = true;
		return this;
	}

	/**
	 * View will be added/mediated then one of those message are sent.
	 * @param addMessages
	 * @return
	 */
	public function addOn(...addMessages:Array):BaseDefinition {
		for (var i:int = 0; i < addMessages.length; i++) {
			var newMessage:String = addMessages[i];
			if (this.addMessages) {
				var messageIndex:int = this.addMessages.indexOf(newMessage);
				if (messageIndex > -1) {
					addMessages.splice(messageIndex, 1);
					i--;
				}
			}
			if (this.toggleMessages) {
				messageIndex = this.toggleMessages.indexOf(newMessage);
				if (messageIndex > -1) {
					addMessages.splice(messageIndex, 1);
					i--;
				}
			}
			if (this.removeMessages) {
				messageIndex = this.removeMessages.indexOf(newMessage);
				if (messageIndex > -1) {
					toggleOn(newMessage);
					addMessages.splice(messageIndex, 1);
					i--;
				}
			}
		}
		if (this.addMessages == null) {
			this.addMessages = addMessages;
		} else {
			this.addMessages = this.addMessages.concat(addMessages);
		}

		return this;
	}

	/**
	 * View will be removed/unmediated then one of those message are sent.
	 * @param removeMessages
	 * @return
	 */
	public function removeOn(...removeMessages:Array):BaseDefinition {
		for (var i:int = 0; i < removeMessages.length; i++) {
			var newMessage:String = removeMessages[i];
			if (this.removeMessages) {
				var messageIndex:int = this.removeMessages.indexOf(newMessage);
				if (messageIndex > -1) {
					removeMessages.splice(messageIndex, 1);
					i--;
				}
			}
			if (this.toggleMessages) {
				messageIndex = this.toggleMessages.indexOf(newMessage);
				if (messageIndex > -1) {
					removeMessages.splice(messageIndex, 1);
					i--;
				}
			}
			if (this.addMessages) {
				messageIndex = this.addMessages.indexOf(newMessage);
				if (messageIndex > -1) {
					toggleOn(newMessage);
					removeMessages.splice(messageIndex, 1);
					i--;
				}
			}
		}
		if (this.removeMessages == null) {
			this.removeMessages = removeMessages;
		} else {
			this.removeMessages = this.removeMessages.concat(removeMessages);
		}

		return this;
	}

	/**
	 * View will be added or removed then one of those message are sent.
	 * @param toggleMessages
	 * @return
	 */
	public function toggleOn(...toggleMessages:Array):BaseDefinition {
		for (var i:int = 0; i < toggleMessages.length; i++) {
			var newMessage:String = toggleMessages[i];
			if (this.addMessages) {
				var messageIndex:int = this.addMessages.indexOf(newMessage)
				if (messageIndex > -1) {
					this.addMessages.splice(messageIndex, 1);
				}
			}
			if (this.removeMessages) {
				messageIndex = this.removeMessages.indexOf(newMessage)
				if (messageIndex > -1) {
					this.removeMessages.splice(messageIndex, 1);
				}
			}
			if (this.toggleMessages) {
				var needToAdd:Boolean = true;
				for (var j:int = 0; j < this.toggleMessages.length; j++) {
					if (this.toggleMessages[j] == newMessage) {
						needToAdd = false;
						break;
					}
				}
				if (needToAdd) {
					this.toggleMessages.push(newMessage);
				}
			}
		}
		if (this.toggleMessages == null) {
			this.toggleMessages = toggleMessages;
		} else {
			this.toggleMessages = this.toggleMessages.concat(toggleMessages);
		}

		return this;
	}

	/**
	 * View object will be inject into parent view into this variable name.
	 * @param varName
	 * @return
	 */
	public function injectIntoParentAs(varName:String):BaseDefinition {
		this.injectIntoParentVarName = varName;
		return this;
	}

	/**
	 * This function will be executed on parent view then view is added.
	 * @param functionName
	 * @param functionParams
	 * @return
	 */
	public function executeParentFunctionOnAdd(functionName:String, functionParams:Array):BaseDefinition {
		this.onAddParentFunctionName = functionName;
		this.onAddParentFunctionParams = functionParams;
		return this;
	}

	/**
	 * This function will be executed on parent view then view is removed.
	 * @param functionName
	 * @param functionParams
	 * @return
	 */
	public function executeParentFunctionOnRemove(functionName:String, functionParams:Array):BaseDefinition {
		this.onRemoveParentFunctionName = functionName;
		this.onRemoveParentFunctionParams = functionParams;
		return this;
	}

	/**
	 * Positions view after creation. Parameters can be numbers or Strings. Suported formants:                                        <br>
	 * STATIC, fixed position: positionAt(10, 20);  positionAt("10", "20");                                                            <br>
	 * PERCENTAGE, percentage of parents size : positionAt("10%", "20%");                                                            <br>
	 * TOP/BOTTOM/LEFT/RIGHT, offset from parent object borders : positionAt("^10", "^20"); positionAt("10^", "20^");                <br>
	 * CENTER/MIDDLE, offset from center : positionAt("|10", "|20"); positionAt("10|", "20|");                                    <br>
	 *
	 * @param x
	 * @param y
	 * @return
	 */
	public function positionTo(x:Object, y:Object, z:Object = null):BaseDefinition {
		var firstChar:String;
		var lastChar:String;

		if (x is Number) {
			xPositionType = ViewConstants.STATIC;
			posX = Number(x);
		} else if (x is String) {
			var strLength:int = x.length;
			if (strLength > 0) {
				firstChar = x.charAt(0);
				lastChar = x.charAt(strLength - 1);
				if (lastChar == "%") {
					xPositionType = ViewConstants.PERCENTAGE;
					posX = Number(x.substr(0, strLength - 1));
				} else if (firstChar == "^") {
					xPositionType = ViewConstants.START;
					posX = Number(x.substr(1, strLength));
				} else if (lastChar == "^") {
					xPositionType = ViewConstants.END;
					posX = Number(x.substr(0, strLength - 1));
				} else if (firstChar == "|") {
					xPositionType = ViewConstants.CENTERED;
					posX = Number(x.substr(1, strLength));
				} else if (lastChar == "|") {
					xPositionType = ViewConstants.CENTERED;
					posX = Number(x.substr(0, strLength - 1)) * -1;
				} else {
					xPositionType = ViewConstants.STATIC;
					posX = Number(x);
				}
			}
		}
		if (y is Number) {
			yPositionType = ViewConstants.STATIC;
			posY = Number(y);
		} else if (y is String) {
			strLength = y.length;
			if (strLength > 0) {
				firstChar = y.charAt(0);
				lastChar = y.charAt(strLength - 1);
				if (lastChar == "%") {
					yPositionType = ViewConstants.PERCENTAGE;
					posY = Number(y.substr(0, strLength - 1));
				} else if (firstChar == "^") {
					yPositionType = ViewConstants.START;
					posY = Number(y.substr(1, strLength));
				} else if (lastChar == "^") {
					yPositionType = ViewConstants.END;
					posY = Number(y.substr(0, strLength - 1));
				} else if (firstChar == "|") {
					yPositionType = ViewConstants.CENTERED;
					posY = Number(y.substr(1, strLength));
				} else if (lastChar == "|") {
					yPositionType = ViewConstants.CENTERED;
					posY = Number(y.substr(0, strLength - 1)) * -1;
				} else {
					yPositionType = ViewConstants.STATIC;
					posY = Number(y);
				}
			}
		}
		//posZ = z;
		return this;
	}

	/**
	 * Change size of the view. Supported formats:                                                                                <br>
	 * STATIC, fixed size: positionAt(100, 200);  sizeAs("100", "200");                                                            <br>
	 * PERCENTAGE, percentage of parents size : sizeAs("30%", "50%");                                                            <br>
	 *
	 * @param width
	 * @param height
	 * @param depth
	 * @return
	 */
	public function sizeTo(width:Object, height:Object, depth:Object = 0):BaseDefinition {
		var strLength:int;
		var lastChar:String;

		trueWidthSizingType = ViewConstants.STATIC;
		if (width is Number) {
			_trueSizeWidth = Number(width);
		} else if (width is String) {
			strLength = width.length;
			if (strLength > 0) {
				lastChar = width.charAt(strLength - 1);
				if (lastChar == "%") {
					trueWidthSizingType = ViewConstants.PERCENTAGE;
					_trueSizeWidth = Number(width.substr(0, strLength - 1))
				} else {
					_trueSizeWidth = Number(width);
				}
			} else {
				_trueSizeWidth = view.width;
			}
		} else {
			trueWidthSizingType = ViewConstants.NONE;
		}
		trueHeightSizingType = ViewConstants.STATIC;
		if (height is Number) {
			_trueSizeHeight = Number(height);
		} else if (height is String) {
			strLength = height.length;
			if (strLength > 0) {
				lastChar = height.charAt(strLength - 1);
				if (lastChar == "%") {
					trueHeightSizingType = ViewConstants.PERCENTAGE;
					_trueSizeHeight = Number(height.substr(0, strLength - 1));
				} else {
					_trueSizeHeight = Number(height);
				}
			} else {
				_trueSizeHeight = view.height;
			}
		} else {
			trueHeightSizingType = ViewConstants.NONE;
		}

		//sizeDepth = depth;
		return this;
	}

	/**
	 * Change size of the view for aligments, does not change actual size. Supported formats:                                                                                <br>
	 * STATIC, fixed size: positionAt(100, 200);  sizeAs("100", "200");                                                            <br>
	 * PERCENTAGE, percentage of parents size : sizeAs("30%", "50%");                                                            <br>
	 *
	 * @param width
	 * @param height
	 * @param depth
	 * @return
	 */
	public function sizeAs(width:Object, height:Object, depth:Object = 0):BaseDefinition {
		var strLength:int;
		var lastChar:String;

		virtualWidthSizingType = ViewConstants.STATIC;
		if (width is Number) {
			_virtualSizeWidth = Number(width);
		} else if (width is String) {
			strLength = width.length;
			if (strLength > 0) {
				lastChar = width.charAt(strLength - 1);
				if (lastChar == "%") {
					virtualWidthSizingType = ViewConstants.PERCENTAGE;
					_virtualSizeWidth = Number(width.substr(0, strLength - 1))
				} else {
					_virtualSizeWidth = Number(width);
				}
			} else {
				_virtualSizeWidth = view.width;
			}
		} else {
			virtualWidthSizingType = ViewConstants.NONE;
		}
		virtualHeightSizingType = ViewConstants.STATIC;
		if (height is Number) {
			_virtualSizeHeight = Number(height);
		} else if (height is String) {
			strLength = height.length;
			if (strLength > 0) {
				lastChar = height.charAt(strLength - 1);
				if (lastChar == "%") {
					virtualHeightSizingType = ViewConstants.PERCENTAGE;
					_virtualSizeHeight = Number(height.substr(0, strLength - 1));
				} else {
					_virtualSizeHeight = Number(height);
				}
			} else {
				_virtualSizeHeight = view.height;
			}
		} else {
			virtualHeightSizingType = ViewConstants.NONE;
		}

		//sizeDepth = depth;
		return this;
	}


	//-------------------------------
	// Internal
	//-------------------------------

	viewTreeNs function get sizeWidth():Number {
		if (virtualWidthSizingType == ViewConstants.STATIC) {
			return _virtualSizeWidth;
		} else if (virtualWidthSizingType == ViewConstants.PERCENTAGE && view.parent) {
			return parent.sizeWidth * (_virtualSizeWidth / 100);
		} else if (trueWidthSizingType == ViewConstants.STATIC) {
			return _trueSizeWidth;
		} else if (trueWidthSizingType == ViewConstants.PERCENTAGE && view.parent) {
			return parent._trueSizeWidth * (_trueSizeWidth / 100);
		} else {
			return view.width;
		}
	}

	viewTreeNs function get sizeHeight():Number {
		if (virtualHeightSizingType == ViewConstants.STATIC) {
			return _virtualSizeHeight;
		} else if (virtualHeightSizingType == ViewConstants.PERCENTAGE && view.parent) {
			return parent.sizeHeight * (_virtualSizeHeight / 100);
		} else if (trueHeightSizingType == ViewConstants.STATIC) {
			return _trueSizeHeight;
		} else if (trueHeightSizingType == ViewConstants.PERCENTAGE && view.parent) {
			return parent._trueSizeHeight * (_trueSizeHeight / 100);
		} else {
			return view.height;
		}
	}


	public function removeAllViews():void {
		var nextDefinition:BaseDefinition = popView();
		while (nextDefinition) {
			// recursion remove all.
			nextDefinition.removeAllViews();
			// remove view is exists.
			if (nextDefinition.view) {
				viewNode.removeView(nextDefinition);
			}
			var oldDefinition:BaseDefinition = nextDefinition;
			nextDefinition = nextDefinition.nextSibling;
			oldDefinition.dispose()
		}
	}

	private function popView():BaseDefinition {
		var retVal:BaseDefinition;

		if (headChild) {
			retVal = headChild;
			headChild = headChild.nextSibling;
		}
		return retVal;
	}

	public function dispose():void {
		use namespace viewTreeNs;

		viewClass = null;
		constructParams = null;
		viewParams = null;
		childViews = null;
		viewNode = null;
		parent = null;
		headChild = null;
		nextSibling = null;
		view = null;
		addMessages = null;
		removeMessages = null;
		toggleMessages = null;
		onAddParentFunctionParams = null;
		onRemoveParentFunctionParams = null;
	}


}
}
