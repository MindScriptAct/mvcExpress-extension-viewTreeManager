package org.mvcexpress.extensions.viewTree.commands {
import org.mvcexpress.extensions.viewTree.ViewTreeExpress;
import org.mvcexpress.extensions.viewTree.namespace.viewTreeNs;
import org.mvcexpress.mvc.PooledCommand;

/**
 * TODO:CLASS COMMENT
 * @author rbanevicius
 */
public class ViewTreeAddCommand extends PooledCommand {

	public function execute(blank:Object):void {
		use namespace viewTreeNs;

		ViewTreeExpress.trigerAddMessage(messageType);
	}

}
}
