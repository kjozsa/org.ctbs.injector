/**
 * 
 */
package org.ctbs.injector;

import org.ctbs.injector.Injector.Managed;


/**
 * @author kjozsa
 */
@Managed
public class ManagedBean {

	public ManagedBean() {
		System.out.println("constructor of managed called from " + Thread.currentThread().getStackTrace()[2]);
	}

	public ManagedBean(String one, int two) {
		System.out.println("alternate constructor");
	}

	public void doSomething() {
		System.out.println("doing something from managed");
	}
}
