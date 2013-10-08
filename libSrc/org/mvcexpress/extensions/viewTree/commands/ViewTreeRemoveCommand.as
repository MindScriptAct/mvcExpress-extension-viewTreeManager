package org.mvcexpress.extensions.viewTree.commands {
import org.mvcexpress.extensions.viewTree.ViewTreeExpress;
import org.mvcexpress.extensions.viewTree.namespace.viewTreeNs;
import org.mvcexpress.mvc.PooledCommand;

use namespace viewTreeNs;

/**
 * TODO:CLASS COMMENT
 * @author rbanevicius
 */
public class ViewTreeRemoveCommand extends PooledCommand {

	public function execute(blank:Object):void {
		use namespace viewTreeNs;

		ViewTreeExpress.trigerRemoveMessage(messageType);
	}

}
}
