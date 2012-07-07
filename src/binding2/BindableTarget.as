package binding2 {
	import flash.utils.getDefinitionByName;
	//import org.as3commons.lang.IEquals;
	/**
	 * ...
	 * @author michal.przybys at gmail.com
	 */
	internal class BindableTarget {
		
		internal var _target:Object;
		
		internal var _propertyName:String;
		
		internal var _propertyType:Class;
		
		internal var _strict:Boolean;
		
		public function BindableTarget(target:Object, propertyName:String, strict:Boolean = false) {
			_target = target;
			_propertyName = propertyName;
			_strict = strict;
		}
		
		internal function initialize():Boolean {
			var typeDescription:XML = TypeCache.describeType(_target),
				hasVariable:Boolean = ( typeDescription.factory..variable.(@name == _propertyName) ).length() == 1,
				variableType:String = hasVariable ? ( typeDescription.factory..variable.(@name == _propertyName) )[0].@type : "",
				hasAccessor:Boolean = ( typeDescription.factory..accessor.(@name == _propertyName) ).length() == 1,
				hasWritableAccessor:Boolean = hasAccessor ? ( typeDescription.factory..accessor.(@name == _propertyName) )[0].@access != "readonly" : false,
				accessorType:String = hasWritableAccessor ? ( typeDescription.factory..accessor.(@name == _propertyName) )[0].@type : "",
				isDynamic:Boolean = typeDescription.@isDynamic.toString() == "true";
				
			if (hasWritableAccessor) {
				_propertyType = getDefinitionByName(accessorType) as Class;
			} else if (hasVariable) {
				_propertyType = getDefinitionByName(variableType) as Class;
			} else if (isDynamic && !_strict) {
				_propertyType = Object;
			} else {
				return false;
			}
			
			//test
			//trace(_target, _propertyName, _propertyType, _target[_propertyName] is _propertyType);
			
			return true;
		}
		
		internal function push(value:*, type:Class = null):void {
			// TODO: some type checking
			if (_target[_propertyName] != value) _target[_propertyName] = value;
		}
		
		//public function equals(other:Object):Boolean {
			//if (other.constructor == BindableTarget) {
				//if (other._target == _target && other._propertyName == _propertyName) {
					//return true;
				//}
			//} 
			//
			//return false;
		//}
		
		internal function dispose():void { trace(this, "dispose");
			_target = null;
			_propertyName = null;
			_propertyType = null;
		}
		
	}

}