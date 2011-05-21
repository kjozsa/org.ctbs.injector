/**
 * 
 */
package org.ctbs.injector;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.aspectj.lang.reflect.FieldSignature;


/**
 * primitive dependency injection mechanism for trivial use cases
 * 
 * @author kjozsa
 */
public aspect Injector {
	private Map<Class<?>, Object> instances = new ConcurrentHashMap<Class<?>, Object>();

	/**
	 * attach this to fields to get a @Managed type injected
	 */
	@Documented
	@Target(ElementType.FIELD)
	@Retention(RetentionPolicy.RUNTIME)
	public static @interface Injected {
	}

	/**
	 * attach this to a class to get it injectable
	 */
	@Documented
	@Target(ElementType.TYPE)
	@Retention(RetentionPolicy.RUNTIME)
	public static @interface Managed {
	}

	declare error : call((@Managed *).new(..)) : "do not instantiate a @Managed bean directly";
	declare error : get(@Injected (!@Managed *) *) : "you can only inject @Managed beans";

	pointcut get_injected() :
		get(@Injected (@Managed *) *);


	Object around() : get_injected() {
		Class<?> clazz = ((FieldSignature) thisJoinPoint.getSignature()).getFieldType();
		Object result = instances.get(clazz);
		return result == null ? register(clazz) : result;
	}

	private Object register(Class<?> clazz) {
		try {
			Object result = clazz.newInstance();
			instances.put(clazz, result);
			return result;
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}
}
