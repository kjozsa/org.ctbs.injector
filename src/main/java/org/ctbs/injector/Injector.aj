/**
 * 
 */
package org.ctbs.injector;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import java.lang.reflect.Field;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.aspectj.ajdt.internal.compiler.ast.Proceed;
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
		// return local field cache if any
		Object result = proceed();
		if (result != null) {
			return result;
		}
		
		// get cached value for field type
		FieldSignature fieldSignature = (FieldSignature) thisJoinPoint.getSignature();
		Class<?> clazz = fieldSignature.getFieldType();
		result = instances.get(clazz);

		// create cached value
		if (result == null) {
			result = register(clazz);
		}

		// write target object field value for local caching
		if (fieldSignature.getField().isAccessible()) {
			writeField(fieldSignature.getField(), thisJoinPoint.getTarget(), result);
		}
		return result;
	}

	/**
	 * @param field to set
	 * @param target can be null for static fields
	 * @param value to set
	 */
	private void writeField(Field field, Object target, Object value) {
		try {
			field.set(target, value);	
		} catch (Exception e) {
			throw new RuntimeException("failed to set field value", e);
		}
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
