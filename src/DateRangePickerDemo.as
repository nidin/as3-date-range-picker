package  
{
	import flash.display.Sprite;
	import nid.events.CalendarEvent;
	import nid.ui.controls.DateRangePicker;
	/**
	 * ...
	 * @author Nidin P Vinayakan
	 */
	public class DateRangePickerDemo extends Sprite
	{
		private var dateRangePicker:DateRangePicker;
		
		public function DateRangePickerDemo() 
		{
			dateRangePicker = new DateRangePicker();
			dateRangePicker.dateFormat = "M/D/Y";
			dateRangePicker.x = 20
			dateRangePicker.y = 20
			dateRangePicker.startDate = new Date(2012, 11, 15);
			dateRangePicker.endDate = new Date();
			dateRangePicker.addEventListener(CalendarEvent.DATE_RANGE_CHANGE, onDateRangeChange);
			dateRangePicker.addEventListener(CalendarEvent.APPLY, onApply);
			addChild(dateRangePicker);
		}
		
		private function onApply(e:CalendarEvent):void 
		{
			//trace(e.selectedDateRange);
			//trace("Start Date:" + dateRangePicker.startDate);
			//trace("End Date:" + dateRangePicker.endDate);
		}
		
		private function onDateRangeChange(e:CalendarEvent):void 
		{
			//trace(e.selectedDateRange);
			//trace("Start Date:" + dateRangePicker.startDate);
			//trace("End Date:" + dateRangePicker.endDate);
		}
		
	}

}