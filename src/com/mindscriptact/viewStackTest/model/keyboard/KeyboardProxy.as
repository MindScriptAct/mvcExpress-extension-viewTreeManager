package com.mindscriptact.viewStackTest.model.keyboard {
import flash.display.Stage;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.utils.Dictionary;

import mvcexpress.mvc.Proxy;

/**
 * TODO:CLASS COMMENT
 * @author Raimundas Banevicius (http://mvcexpress.org)
 */
public class KeyboardProxy extends Proxy {
	private var stage:Stage;

	public var keyRegistry:Dictionary = new Dictionary();

	private var messageKeysRegistry:Dictionary = new Dictionary();
	private var messageParamsKeysRegistry:Dictionary = new Dictionary();

	public function KeyboardProxy(stage:Stage) {
		this.stage = stage;

		this.stage.focus = this.stage;

		this.stage.addEventListener(FocusEvent.FOCUS_OUT, handleFocusChange);
	}

	private function handleFocusChange(event:FocusEvent):void {
		this.stage.focus = this.stage;
	}

	override protected function onRegister():void {
		stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyPressedDown);
		stage.addEventListener(KeyboardEvent.KEY_UP, handleKeyPressedUp);

		//provide(keyRegistry, "keyBoardRegistry");
	}

	override protected function onRemove():void {
		stage.removeEventListener(KeyboardEvent.KEY_DOWN, handleKeyPressedDown);
		stage.removeEventListener(KeyboardEvent.KEY_UP, handleKeyPressedUp);
	}

	private function handleKeyPressedUp(event:KeyboardEvent):void {
		keyRegistry[event.keyCode] = false;
		//
		if (messageKeysRegistry[event.keyCode] != null) {
			if (messageParamsKeysRegistry[event.keyCode]) {
				sendMessage(messageKeysRegistry[event.keyCode], messageParamsKeysRegistry[event.keyCode]);
			} else {
				sendMessage(messageKeysRegistry[event.keyCode], event.keyCode);
			}
		}
	}

	private function handleKeyPressedDown(event:KeyboardEvent):void {
		keyRegistry[event.keyCode] = true;
	}

	public function isKeyPressed(keyCode:int):Boolean {
		return (keyRegistry[keyCode] == true);
	}

	public function registerMessageSendOnPress(keyCode:int, message:String, params:Object = null):void {
		messageKeysRegistry[keyCode] = message;
		messageParamsKeysRegistry[keyCode] = params;
	}

	public function removeMessageSendOnPress(keyCode:int):void {
		delete messageKeysRegistry[keyCode];
		delete messageParamsKeysRegistry[keyCode];
	}

}
}