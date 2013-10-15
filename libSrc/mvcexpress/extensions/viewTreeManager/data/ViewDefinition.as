// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.extensions.viewTreeManager.data {
import mvcexpress.extensions.viewTreeManager.core.ViewNode;
import mvcexpress.extensions.viewTreeManager.namespace.viewTreeNs;

use namespace viewTreeNs;

/**
 * Single view object definition.
 *
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
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

	viewTreeNs var childViews:Vector.<ViewDefinition> = new Vector.<ViewDefinition>();

	viewTreeNs var viewTreeManager:ViewNode;
	viewTreeNs var isMapped:Boolean = false;
	viewTreeNs var parent:ViewDefinition;

	//
	viewTreeNs var childHead:ViewDefinition;
	//
	viewTreeNs var nextSibling:ViewDefinition;
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

	viewTreeNs var widthSizingType:int = 0;
	viewTreeNs var heightSizingType:int = 0;
	viewTreeNs var _sizeWidth:Number;
	viewTreeNs var _sizeHeight:Number;
	///viewTreeNs var _sizeDepth:Number;

	viewTreeNs var ignoreOrder:Boolean;

	private var isAutoAdded:Boolean = false;

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

	/**
	 * Push view definitions as child's. (ViewDefinition, ViewComboDefinition, ViewGroupDefinition, ViewStackDefinition is supported.)
	 * View definitions will be used to manage views automatically. (create, mediate, add as child to parent view, position,  size...)
	 * @param views
	 * @return
	 */
	public function pushViews(...views:Array):ViewDefinition {
		use namespace viewTreeNs;

		for (var i:int = 0; i < views.length; i++) {
			if (views[i] is ViewDefinition) {
				pushViewDefinition(views[i] as ViewDefinition);

			} else if (views[i] is ViewGroupDefinition) {
				var groupViews:Array = (views[i] as ViewGroupDefinition).groupViews;
				for (var j:int = 0; j < groupViews.length; j++) {
					if (groupViews[j] is ViewDefinition) {
						pushViewDefinition(groupViews[j] as ViewDefinition);
					} else {
						throw  Error("You can add only ViewDefinition objects to ViewGroupDefinition.");
					}
				}

			} else if (views[i] is ViewComboDefinition) {
				(views[i] as ViewComboDefinition).initComboDefinitions();
				var comboViews:Array = (views[i] as ViewComboDefinition).comboViews;
				for (j = 0; j < comboViews.length; j++) {
					if (comboViews[j] is ViewDefinition) {
						pushViewDefinition(comboViews[j] as ViewDefinition, true);
					} else {
						throw  Error("You can add only ViewDefinition objects to ViewComboDefinition.");
					}
				}

			} else if (views[i] is ViewStackDefinition) {
				var stackViews:Array = (views[i] as ViewStackDefinition).stackViews;
				for (j = 0; j < stackViews.length; j++) {
					if (stackViews[j] is ViewDefinition) {
						pushViewDefinition(stackViews[j] as ViewDefinition, true);
					} else {
						throw  Error("You can add only ViewDefinition objects to ViewStackDefinition.");
					}
				}

			} else {
				throw  Error(views[i] + " type is not supported." /*"You can add only ViewDefinition objects."*/);
			}
		}
		return this;
	}

	// push one viewDefinition
	private function pushViewDefinition(viewDefinition:ViewDefinition, ignoreOrder:Boolean = false):ViewDefinition {
		viewDefinition.viewTreeManager = viewTreeManager;
		viewDefinition.parent = this;

		//
		if (childHead) {
			viewDefinition.nextSibling = childHead;
		}
		this.childHead = viewDefinition;

		//
		viewDefinition.ignoreOrder = ignoreOrder;

		//
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

		return this;
	}

	/**
	 * View will be added/mediated automatically with parent.
	 * @return self
	 */
	public function autoAdd():ViewDefinition {
		isAutoAdded = true;
		return this;
	}

	/**
	 * View will be added/mediated then one of those message are sent.
	 * @param addMessages
	 * @return
	 */
	public function addOn(...addMessages:Array):ViewDefinition {
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
	public function removeOn(...removeMessages:Array):ViewDefinition {
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
	public function toggleOn(...toggleMessages:Array):ViewDefinition {
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
	public function injectIntoParentAs(varName:String):ViewDefinition {
		this.injectIntoParentVarName = varName;
		return this;
	}

	/**
	 * This function will be executed on parent view then view is added.
	 * @param functionName
	 * @param functionParams
	 * @return
	 */
	public function executeParentFunctionOnAdd(functionName:String, functionParams:Array):ViewDefinition {
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
	public function executeParentFunctionOnRemove(functionName:String, functionParams:Array):ViewDefinition {
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
	public function positionAt(x:Object, y:Object, z:Object = null):ViewDefinition {
		var firstChar:String;
		var lastChar:String;

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


	//-------------------------------
	// Internal
	//-------------------------------

	viewTreeNs function get sizeWidth():Number {
		if (widthSizingType == STATIC) {
			return _sizeWidth;
		} else if (widthSizingType == PERCENTAGE && view.parent) {
			return parent.sizeWidth * (_sizeWidth / 100);
		} else {
			return view.width;
		}
	}

	viewTreeNs function get sizeHeight():Number {
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
