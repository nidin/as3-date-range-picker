package nid.events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Nidin Vinayak
	 */
	public class CalendarEvent extends Event 
	{
		public static const DATE_CHANGE:String = "dateChange";
		public static const DATE_RANGE_CHANGE:String = "dateRangeChange";
		static public const APPLY:String = "apply";
		
		private var data:Object;
		
		public function get selectedDateRange():Array { return data as Array;}
		public function get selectedDate():Date { return data as Date;}
		
		public function CalendarEvent(type:String, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{ 
			super(type, bubbles, cancelable);
			this.data = data;
		}
	}
	
}