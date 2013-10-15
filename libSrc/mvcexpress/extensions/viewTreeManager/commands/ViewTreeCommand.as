// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.extensions.viewTreeManager.commands {
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.extensions.viewTreeManager.core.ViewTreeManager;
import mvcexpress.extensions.viewTreeManager.namespace.viewTreeNs;
import mvcexpress.mvc.PooledCommand;

/**
 * If any viewTreeManager related message is send - this command will be executed.
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 */
public class ViewTreeCommand extends PooledCommand {

	public function execute(blank:Object):void {
		use namespace pureLegsCore;
		use namespace viewTreeNs;

		ViewTreeManager.triggerMessage(messageType);
	}

}
}
