package mvcexpress.extensions.viewTreeManager.data {
import flash.utils.Dictionary;

import mvcexpress.extensions.viewTreeManager.namespace.viewTreeNs;

use namespace viewTreeNs;

/**
 * Group of views, only one will be visible at same depth.
 */
public class ViewComboDefinition {

	viewTreeNs var comboViews:Array;

	viewTreeNs var removeMessages:Array;

	public function ViewComboDefinition(...comboViews:Array) {
		this.comboViews = comboViews;
		for (var i:int = 0; i < comboViews.length; i++) {
			if (!comboViews is ViewDefinition) {
				throw Error("You can add only ViewDefinition objects to ViewComboDefinition.");
			}
		}
	}

	public function addDefinition(viewDefinition:ViewDefinition):ViewComboDefinition {
		if (comboViews == null) {
			comboViews = [];
		}
		comboViews.push(viewDefinition);
		//
		if (removeMessages == null) {
			for (var j:int = 0; j < removeMessages.length; j++) {
				viewDefinition.removeOn(removeMessages[j]);
			}
		}

		return this;
	}

	public function removeOn(...removeMessages:Array):ViewComboDefinition {
		if (comboViews != null) {
			for (var i:int = 0; i < comboViews.length; i++) {
				for (var j:int = 0; j < removeMessages.length; j++) {
					(comboViews[i] as ViewDefinition).removeOn(removeMessages[j]);
				}
			}
		}
		if (this.removeMessages) {
			this.removeMessages = this.removeMessages.concat(removeMessages);
		} else {
			this.removeMessages = removeMessages;
		}

		return this;
	}


	//-------------------------------
	//
	//-------------------------------

	viewTreeNs function initComboDefinitions():void {

		var messageRegistry:Dictionary = new Dictionary();
		var allMessages:Vector.<String> = new <String>[];
		var message:String;

		// check for duplications.
		for (var i:int = 0; i < comboViews.length; i++) {
			var comboView:ViewDefinition = comboViews[i];
			if (comboView.addMessages) {
				for (var addMessageId:int = 0; addMessageId < comboView.addMessages.length; addMessageId++) {
					message = comboView.addMessages[addMessageId];
					if (messageRegistry[message] == null) {
						messageRegistry[message] = comboView;
						allMessages.push(message);
					} else {
						throw Error("ViewComboDefinition view objects must have unique message names for addOn or toggleOn messages.");
					}
				}
			}
			if (comboView.toggleMessages) {
				for (var toggleMessageId:int = 0; toggleMessageId < comboView.toggleMessages.length; toggleMessageId++) {
					message = comboView.toggleMessages[toggleMessageId];
					if (messageRegistry[message] == null) {
						messageRegistry[message] = comboView;
						allMessages.push(message);
					} else {
						throw Error("ViewComboDefinition view objects must have unique message names for addOn or toggleOn messages.");
					}
				}
			}
		}

		// add remove messages to other viewDefinitions.
		for (i = 0; i < comboViews.length; i++) {
			comboView = comboViews[i];
			for (var j:int = 0; j < allMessages.length; j++) {
				message = allMessages[j];
				if (messageRegistry[message] != comboView) {
					comboView.removeOn(message);
				}
			}
		}
	}
}
}
