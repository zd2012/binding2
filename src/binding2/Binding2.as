package binding2 {
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import org.as3commons.collections.ArrayList;
	import org.as3commons.collections.framework.IIterator;
	import org.as3commons.collections.framework.IList;
	import org.as3commons.collections.framework.IMap;
	import org.as3commons.collections.Map;
	/**
	 * ...
	 * @author michal.przybys at gmail.com
	 */
	public class Binding2 {
		
		/**
		 * bind
		 * @param	source
		 * @param	sourcePropertyName
		 * @param	target
		 * @param	targetPropertyName
		 * @param	eventType
		 * @return
		 */
		public static function bind(	source:IEventDispatcher, 
										sourcePropertyName:String, 
										target:Object,
										targetPropertyName:String = null, 
										eventType:String = Event.CHANGE		):Boolean {
			var propertyMap:IMap,
				bindableSource:BindableSource,
				targetList:IList,
				targetListIter:IIterator,
				bindableTarget:BindableTarget;
				
			if (targetPropertyName == null) targetPropertyName = sourcePropertyName;
			
			if (!sourceMap.hasKey(source)) sourceMap.add(source, new Map());
			propertyMap = sourceMap.itemFor(source) as IMap;
			
			if (!propertyMap.hasKey(sourcePropertyName)) {
				bindableSource = new BindableSource(source, sourcePropertyName, eventType);
				if (!bindableSource.initialize()) return false;
				propertyMap.add(sourcePropertyName, bindableSource);
			} else {
				bindableSource = propertyMap.itemFor(sourcePropertyName) as BindableSource;
			}
			
			if (!bindingsMap.hasKey(bindableSource)) bindingsMap.add(bindableSource, new ArrayList());
			targetList = bindingsMap.itemFor(bindableSource);
			
			targetListIter = targetList.iterator();
			while (targetListIter.hasNext()) {
				bindableTarget = targetListIter.next() as BindableTarget;
				if (bindableTarget._target == target && bindableTarget._propertyName == targetPropertyName) {
					break;
				} else {
					bindableTarget = null;
				}
			}
			
			if (bindableTarget == null) {
				bindableTarget = new BindableTarget(target, targetPropertyName);
				if (!bindableTarget.initialize()) return false;
				targetList.add(bindableTarget);
				return true;
			} 
			
			return false;
		}
		
		/**
		 * unbind single target
		 */
		public static function unbind(	source:IEventDispatcher, 
										sourcePropertyName:String, 
										target:Object, 
										targetPropertyName:String = null	):Boolean {
			var propertyMap:IMap,
				bindableSource:BindableSource,
				targetList:IList,
				targetListIter:IIterator,
				bindableTarget:BindableTarget;
				
			if (targetPropertyName == null) targetPropertyName = sourcePropertyName;
			
			if (!sourceMap.hasKey(source)) return false;
			propertyMap = sourceMap.itemFor(source) as IMap;
			
			if (!propertyMap.hasKey(sourcePropertyName)) return false;
			bindableSource = propertyMap.itemFor(sourcePropertyName) as BindableSource;
			
			if (!bindingsMap.hasKey(bindableSource)) {
				bindableSource.dispose();
				return false;
			}
			targetList = bindingsMap.itemFor(bindableSource) as IList;
			
			targetListIter = targetList.iterator();
			while (targetListIter.hasNext()) {
				bindableTarget = targetListIter.next() as BindableTarget;
				if (bindableTarget._target == target && bindableTarget._propertyName == targetPropertyName) {
					break;
				} else {
					bindableTarget = null;
				}
			}
			
			if (bindableTarget != null) {
				bindableTarget.dispose();
				
				if (targetList.size == 0) bindableSource.dispose();
				return true;
			}
			
			return false;
		}
		
		/**
		 * unbind all targets for String sourcePropertyName of IEventDispatcher source
		 */
		public static function unbindProperty(source:IEventDispatcher, sp:String):Boolean {
			var propertyMap:IMap,
				bindableSource:BindableSource,
				targetList:IList,
				targetListIter:IIterator,
				bindableTarget:BindableTarget;
			
			if (!sourceMap.hasKey(source)) return false;
			propertyMap = sourceMap.itemFor(source) as IMap;
			
			if (!propertyMap.hasKey(sp)) return false;
			bindableSource = propertyMap.itemFor(sp) as BindableSource;
			
			if (!bindingsMap.hasKey(bindableSource)) {
				bindableSource.dispose();
				return false;
			}
			targetList = bindingsMap.itemFor(bindableSource) as IList;
			
			targetListIter = targetList.iterator();
			while (targetListIter.hasNext()) {
				bindableTarget = targetListIter.next() as BindableTarget;
				bindableTarget.dispose();
			}
			targetList.clear();
			
			bindableSource.dispose();
			return true;			
		}
		
		/**
		 * unbind all targets for all properties of IEventDispatcher source
		 */
		public static function unbindSource(source:IEventDispatcher):Boolean {
			var propertyMap:IMap,
				propertyIter:IIterator,
				bindableSource:BindableSource,
				targetList:IList,
				targetListIter:IIterator,
				bindableTarget:BindableTarget;
			
			if (!sourceMap.hasKey(source)) return false;
			propertyMap = sourceMap.itemFor(source) as IMap;
			
			propertyIter = propertyMap.iterator();
			while (propertyIter.hasNext()) {
				bindableSource = propertyIter.next() as BindableSource;
				
				if (!bindingsMap.hasKey(bindableSource)) {
					bindableSource.dispose();
					return false;
				}
				
				targetList = bindingsMap.itemFor(bindableSource) as IList;
			
				targetListIter = targetList.iterator();
				while (targetListIter.hasNext()) {
					bindableTarget = targetListIter.next() as BindableTarget;
					bindableTarget.dispose();
				}
				targetList.clear();
				
				bindableSource.dispose();
			}
			
			return true;	
		}
		
		/**
		 * push value to all bound targets
		 */
		internal static function commit(bindableSource:BindableSource, value:*, type:Class):void {
			var targetList:IList,
				targetListIter:IIterator,
				bindableTarget:BindableTarget;
			
			targetList = bindingsMap.itemFor(bindableSource) as IList;
			targetListIter = targetList.iterator();
			while (targetListIter.hasNext()) {
				bindableTarget = targetListIter.next() as BindableTarget;
				bindableTarget.push(value, type);
			}			
		}
		
		/**
		 * Map< BindableSource -> List< BindableTarget > >
		 */
		private static const bindingsMap:IMap = new Map();
		
		/**
		 * Map< IEventDispatcher -> Map < String -> BindableSource > >
		 */
		private static const sourceMap:IMap = new Map();
		
	}

}