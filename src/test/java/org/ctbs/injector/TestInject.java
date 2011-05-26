/**
 * 
 */
package org.ctbs.injector;

import org.ctbs.injector.Injector.Injected;
import org.junit.Assert;
import org.junit.Test;


/**
 * @author kjozsa
 * 
 */
public class TestInject {

	/** you cannot refer to this without a compile error as its not @Managed */
	@Injected
	private String boo;

	/** all of these should give compile errors if uncommented */
	@Test
	public void testPolicyEnforcements() {
		// System.out.println(boo);
		// new ManagedBean(); // gives error too
		// new ManagedBean("one", 2); // and this too
	}

	@Test
	public void test() {
		Bean1 b11 = new Bean1();
		b11.whatever();
		b11.whatever();
		Bean1 b12 = new Bean1();
		b12.whatever();

		Bean2 b2 = new Bean2();
		b2.stuff();

		Assert.assertSame(b11.managedBean, b12.managedBean);
		Assert.assertSame(b11.managedBean, b2.managedBean);
	}
}
