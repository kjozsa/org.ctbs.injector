/**
 * 
 */
package org.ctbs.injector;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * @author kjozsa
 */
public aspect HasMemberTest {
	@Target(ElementType.FIELD)
	@Retention(RetentionPolicy.RUNTIME)
	public static @interface Injected {
	}
	
	@Target(ElementType.TYPE)
	@Retention(RetentionPolicy.RUNTIME)
	public static @interface Managed {
	}
	
	public static class Sample {
		@Injected
		private SampleManaged match1;
		
		@Injected
		private String match2;
	}

	@Managed
	public static class SampleManaged {
		public SampleManaged(int foo) {}
	}
	
	declare error: hasfield(@Injected * *): "hit match1";	// try to simply match 'match1'
	declare error: hasfield(@Injected (!(@Managed *) *): "hit match2";	// try to match 'match2' as injection of a not @Managed type 
	declare error: within(@Managed *) && !hasmethod(new()) : "no default constructor";	// try to match SampleManaged non-default constructor
}
