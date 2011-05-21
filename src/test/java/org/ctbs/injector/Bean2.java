/**
 * 
 */
package org.ctbs.injector;

import org.ctbs.injector.Injector.Injected;


/**
 * @author kjozsa
 */
public class Bean2 {

	@Injected
	ManagedBean managedBean;

	public void stuff() {
		managedBean.doSomething();
	}
}
