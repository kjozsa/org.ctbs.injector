/**
 * 
 */
package org.ctbs.injector;

import org.ctbs.injector.Injector.Injected;


/**
 * @author kjozsa
 */
public class Bean1 {

	@Injected
	String wrongInjection;

	@Injected
	ManagedBean managedBean;

	public void whatever() {
		managedBean.doSomething();
	}
}
