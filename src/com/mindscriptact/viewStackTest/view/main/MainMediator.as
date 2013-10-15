package com.mindscriptact.viewStackTest.view.main {
import com.mindscriptact.viewStackTest.Main;

import mvcexpress.mvc.Mediator;

/**
 * TODO:CLASS COMMENT
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class MainMediator extends Mediator {

    [Inject]
    public var view:Main;

    override protected function onRegister():void {
        trace("MainMediator.onRegister");
    }

    override protected function onRemove():void {

    }
}
}