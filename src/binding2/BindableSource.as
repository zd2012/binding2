package binding2 {
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.getDefinitionByName;
	//import org.as3commons.lang.IEquals;
	/**
	 * ...
	 * @author michal.przybys at gmail.com
	 */
	internal class BindableSource {
		
		internal var _source:IEventDispatcher;
		
		internal var _propertyName:String;
		
		internal var _propertyType:Class;
		
		internal var _eventType:String;
		
		public function BindableSource(source:IEventDispatcher, propertyName:String, eventType:String = Event.CHANGE) {
			_source = source;
			_propertyName = propertyName;
			_eventType = eventType;
		}
		
		internal function initialize():Boolean {
			var typeDescription:XML = TypeCache.describeType(_source),
				hasVariable:Boolean = ( typeDescription.factory..variable.(@name == _propertyName) ).length() == 1,
				variableType:String = hasVariable ? ( typeDescription.factory..variable.(@name == _propertyName) )[0].@type : "",
				hasAccessor:Boolean = ( typeDescription.factory..accessor.(@name == _propertyName) ).length() == 1,
				hasReadableAccessor:Boolean = hasAccessor ? ( typeDescription.factory..accessor.(@name == _propertyName) )[0].@access != "writeonly" : false,
				accessorType:String = hasReadableAccessor ? ( typeDescription.factory..accessor.(@name == _propertyName) )[0].@type : "";
			
			if (hasReadableAccessor) {
				_propertyType = getDefinitionByName(accessorType) as Class;
			} else if (hasVariable) {
				_propertyType = getDefinitionByName(variableType) as Class;
			} else {
				return false;
			}
			
			//test
			//trace(_source, _propertyName, _propertyType, _source[_propertyName] is _propertyType);
			
			_source.addEventListener(_eventType, update, false, 0);
			return true;
		}
		
		protected function update(e:Event):void {
			Binding2.commit(this, _source[_propertyName], _propertyType);
		}
		
		//public function equals(other:Object):Boolean {
			//if (other.constructor == BindableSource) {
				//if (other._source == _source && other._propertyName == _propertyName) {
					//return true;
				//}
			//} 
			//
			//return false;
		//}
		
		internal function dispose():void { trace(this, "dispose");
			if (_source) _source.removeEventListener(_eventType, update);
			
			_source = null;
			_propertyName = null;
			_propertyType = null;
			_eventType = null;
		}
		
	}

}