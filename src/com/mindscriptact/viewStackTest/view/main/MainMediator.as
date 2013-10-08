package com.mindscriptact.viewStackTest.view.main {
import com.mindscriptact.viewStackTest.Main;

import org.mvcexpress.mvc.Mediator;

/**
 * TODO:CLASS COMMENT
 * @author rbanevicius
 */
public class MainMediator extends Mediator {

    [Inject]
    public var view:Main;

    override public function onRegister():void {
        trace("MainMediator.onRegister");
    }

    override public function onRemove():void {

    }
}
}