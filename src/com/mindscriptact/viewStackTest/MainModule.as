package com.mindscriptact.viewStackTest {
import com.mindscriptact.viewStackTest.controller.tests.*;
import com.mindscriptact.viewStackTest.messages.Message;
import com.mindscriptact.viewStackTest.model.keyboard.KeyboardProxy;
import com.mindscriptact.viewStackTest.view.main.MainMediator;
import com.mindscriptact.viewStackTest.view.testView.TestView;

import flash.ui.Keyboard;

import mvcexpress.extensions.viewTreeManager.core.ViewTreeManager;
import mvcexpress.extensions.viewTreeManager.data.ViewDefinition;
import mvcexpress.modules.ModuleCore;

/**
 * TODO:CLASS COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class MainModule extends ModuleCore {

	public function MainModule() {
		super("MainModule");
	}

	override protected function onInit():void {

	}

	public function start(main:Main):void {


		var keyboardProxy:KeyboardProxy = new KeyboardProxy(main.stage)
		proxyMap.map(keyboardProxy);

		keyboardProxy.registerMessageSendOnPress(Keyboard.F1, Message.TRIGER_F1_TEST, main);
		keyboardProxy.registerMessageSendOnPress(Keyboard.F2, Message.TRIGER_F2_TEST, main);
		keyboardProxy.registerMessageSendOnPress(Keyboard.F3, Message.TRIGER_F3_TEST, main);
		keyboardProxy.registerMessageSendOnPress(Keyboard.F4, Message.TRIGER_F4_TEST, main);
		keyboardProxy.registerMessageSendOnPress(Keyboard.F5, Message.TRIGER_F5_TEST, main);
		keyboardProxy.registerMessageSendOnPress(Keyboard.F6, Message.TRIGER_F6_TEST, main);
		keyboardProxy.registerMessageSendOnPress(Keyboard.F7, Message.TRIGER_F7_TEST, main);
		keyboardProxy.registerMessageSendOnPress(Keyboard.F8, Message.TRIGER_F8_TEST, main);
		keyboardProxy.registerMessageSendOnPress(Keyboard.F9, Message.TRIGER_F9_TEST, main);


		commandMap.map(Message.TRIGER_F1_TEST, F1TestCommand);
		commandMap.map(Message.TRIGER_F2_TEST, F2TestCommand);
		commandMap.map(Message.TRIGER_F3_TEST, F3TestCommand);
		commandMap.map(Message.TRIGER_F4_TEST, F4TestCommand);
		commandMap.map(Message.TRIGER_F5_TEST, F5TestCommand);
		commandMap.map(Message.TRIGER_F6_TEST, F6TestCommand);
		commandMap.map(Message.TRIGER_F7_TEST, F7TestCommand);
		commandMap.map(Message.TRIGER_F8_TEST, F8TestCommand);
		commandMap.map(Message.TRIGER_F9_TEST, F9TestCommand);


		var testView:TestView = new TestView("Stage");
		main.addChild(testView);
		testView.width = 1000;
		testView.height = 500;
		testView.alpha = 0.3;

		//
		var rootDefinition:ViewDefinition = ViewTreeManager.initRootDefinition(mediatorMap, commandMap, main, MainMediator);
		rootDefinition.positionTo(10, 10);
		rootDefinition.sizeTo(1000, 500);

	}

	override protected function onDispose():void {

	}
}
}