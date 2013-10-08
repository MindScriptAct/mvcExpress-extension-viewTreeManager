// Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
package mvcexpress.extensions.viewTreeManager {
import mvcexpress.core.ExtensionManager;
import mvcexpress.core.namespace.pureLegsCore;
import mvcexpress.modules.ModuleCore;

/**
 * Core Module class, represents single application unit in mvcExpress framework.
 * <p>
 * It starts framework and lets you set up your application. (or execute Commands for set up.)
 * You can create modular application by having more then one module.
 * </p>
 * @author Raimundas Banevicius (http://www.mindscriptact.com/)
 *
 * @version scoped.1.0.beta2
 */
public class ModuleViewTree extends ModuleCore {


	public function ModuleViewTree(moduleName:String = null, mediatorMapClass:Class = null, proxyMapClass:Class = null, commandMapClass:Class = null, messengerClass:Class = null) {

		CONFIG::debug {
			use namespace pureLegsCore;
			enableExtension(EXTENSION_VIEWTREE_ID);
		}

		super(moduleName, mediatorMapClass, proxyMapClass, commandMapClass, messengerClass);

	}


	//----------------------------------
	//     ...
	//----------------------------------


	//----------------------------------
	//    Extension checking: INTERNAL, DEBUG ONLY.
	//----------------------------------

	CONFIG::debug
	static pureLegsCore const EXTENSION_VIEWTREE_ID:int = ExtensionManager.getExtensionIdByName(pureLegsCore::EXTENSION_VIEWTREE_NAME);

	CONFIG::debug
	static pureLegsCore const EXTENSION_VIEWTREE_NAME:String = "viewTree";

}
}