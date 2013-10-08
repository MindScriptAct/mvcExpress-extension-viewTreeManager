package com.mindscriptact.viewStackTest.view.menu {
import com.mindscriptact.viewStackTest.messages.Message;

import flash.events.MouseEvent;

import org.mvcexpress.mvc.Mediator;

/**
 * TODO:CLASS COMMENT
 * @author rbanevicius
 */
public class MenuViewMediator extends Mediator {

    [Inject]
    public var view:MenuView;

    override public function onRegister():void {
        view.test1.addEventListener(MouseEvent.CLICK, handleTest1)
        view.test2.addEventListener(MouseEvent.CLICK, handleTest2)
        view.test3.addEventListener(MouseEvent.CLICK, handleTest3)
    }

    private function handleTest1(event:MouseEvent):void {
        sendMessage(Message.ADD_TEST1)
    }

    private function handleTest2(event:MouseEvent):void {
        sendMessage(Message.ADD_TEST2)
    }

    private function handleTest3(event:MouseEvent):void {
        sendMessage(Message.ADD_TEST3)
    }

    override public function onRemove():void {

    }
}
}