package mvcexpress.extensions.viewTreeManager.commands {
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.extensions.viewTreeManager.core.ViewTreeManager;
import mvcexpress.extensions.viewTreeManager.namespace.viewTreeNs;
import mvcexpress.mvc.PooledCommand;

/**
 * TODO:CLASS COMMENT
 * @author rbanevicius
 */
public class ViewTreeCommand extends PooledCommand {

	public function execute(blank:Object):void {
		use namespace pureLegsCore;
		use namespace viewTreeNs;

		ViewTreeManager.trigerMessage(messageType);
	}

}
}