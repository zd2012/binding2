package binding2 {
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.Proxy;
	import org.as3commons.lang.IllegalArgumentError;
	/**
	 * ...
	 * @author michal.przybys at gmail.com
	 */
	internal class TypeCache {
		
		private static const cache:Dictionary = new Dictionary(false);
		
		internal static function describeType(value:*):XML {
			if (value == null) throw new IllegalArgumentError("you cannot describe null");
			
			if (!(value is Class)) {
				
				if (value is Proxy) {
					value = getDefinitionByName(getQualifiedClassName(value));
				} else {
					value = value.constructor;
				}
				
			}
			
			return cache[value] ||= flash.utils.describeType(value);
		}
		
	}

}