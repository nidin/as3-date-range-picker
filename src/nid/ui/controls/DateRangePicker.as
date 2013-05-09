package nid.ui.controls 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import nid.events.CalendarEvent;
	import nid.ui.controls.datePicker.Calendar;
	import nid.ui.controls.datePicker.DateField;
	
	/**
	 * ...
	 * @author Nidin Vinayak
	 */
	public class DateRangePicker extends Sprite 
	{
		public var dateFormat:String = "D/M/Y";
		private var calendar1:Calendar;
		private var calendar2:Calendar;
		private var c_holder:Sprite;
		private var startField:DateField;
		private var endField:DateField;
		/** 
		 * Styles
		 */
		static private const CALENDAR_BG_COLOR:Number = 0xDBE5F3;
		static private const CALENDAR_BOARDER_COLOR:Number = 0x8295AA;
		
		public function DateRangePicker() 
		{
			startField = new DateField();
			endField = new DateField();
			
			endField.x = startField.width + 10
			
			addChild(startField);
			addChild(endField);
			
			c_holder = new Sprite();
			calendar1 = new Calendar(true);
			calendar2 = new Calendar();
			calendar1.x = 7
			calendar2.x = Math.round(calendar1.x + calendar1.width);
			calendar1.y = 7
			calendar2.y = 7
			c_holder.addChild(calendar1);
			c_holder.addChild(calendar2);
			c_holder.name  = "holder";
			c_holder.graphics.lineStyle(1, CALENDAR_BOARDER_COLOR);
			c_holder.graphics.beginFill(CALENDAR_BG_COLOR);
			c_holder.graphics.drawRect(0, 0, 318, 215);
			c_holder.graphics.endFill();
			
			var close_btn:TextButton = new TextButton("Close");
			close_btn.x = 180
			close_btn.y = 184;
			c_holder.addChild(close_btn);
			
			var apply_btn:Button = new Button("Apply");
			apply_btn.x = close_btn.x + close_btn.width + 17;
			apply_btn.y = 184;
			c_holder.addChild(apply_btn);
			
			c_holder.filters = [new DropShadowFilter(3, 45, 0, 0.3, 8, 8)];
			c_holder.x = 0
			c_holder.y = startField.height + 5;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
			
			close_btn.addEventListener(MouseEvent.CLICK, close);
			apply_btn.addEventListener(MouseEvent.CLICK, apply);
		}
		
		private function apply(e:MouseEvent):void 
		{
			calendar1.apply();
			calendar2.apply();
			if (stage.contains(c_holder)) stage.removeChild(c_holder);
			dispatchEvent(new CalendarEvent(CalendarEvent.APPLY, [calendar1.selectedDate, calendar2.selectedDate]));
		}
		
		private function close(e:MouseEvent=null):void 
		{
			startDate = calendar1.backbupDate;
			endDate = calendar2.backbupDate;
			if (stage.contains(c_holder)) stage.removeChild(c_holder);
			dispatchEvent(new Event(Event.CLOSE));
		}
		public function get startDate():Date { return calendar1.selectedDate; }
		public function set startDate(value:Date):void {
			if (value == null) return;
			calendar1.selectedDate = value;
			calendar2.startDate = value;
			setDateField(startField, calendar1.selectedDate);
			calendar1.apply();
		}
		public function get endDate():Date { return calendar2.selectedDate; }
		public function set endDate(value:Date):void {
			if (value == null) return;
			calendar2.selectedDate = value;
			calendar1.endDate = value;
			setDateField(endField, calendar2.selectedDate);
			calendar2.apply();
		}
		private function handleChange(e:Event):void 
		{
			if (e.currentTarget == calendar1) {
				setDateField(startField, calendar1.selectedDate);
				if (calendar1.selectedDate.time > calendar2.selectedDate.time) {
					calendar2.selectedDate = calendar1.selectedDate;
					calendar1.endDate = calendar1.selectedDate;
					setDateField(endField, calendar1.selectedDate);
				}
				calendar2.startDate = calendar1.selectedDate;
			}else if (e.currentTarget == calendar2) {
				calendar1.endDate = calendar2.selectedDate;
				setDateField(endField, calendar2.selectedDate);
			}
			dispatchEvent(new CalendarEvent(CalendarEvent.DATE_RANGE_CHANGE, [calendar1.selectedDate, calendar2.selectedDate]));
		}
		private function setDateField(f:DateField,sd:Date):void
		{
			f.text	= "";
			var format:Array = dateFormat.split("/");
			for (var i:int = 0 ; i < format.length; i++ )
			{
				switch(format[i])
				{
					case "D":format[i] = sd.getDate(); break;
					case "M":format[i] = (sd.getMonth() + 1); break;
					case "Y":format[i] = sd.getFullYear(); break;
				}
			}
			for (i = 0 ; i < format.length; i++ )
			{
				f.appendText(format[i] + (i < format.length - 1?"/":""));
			}
		}
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			startField.icon.addEventListener(MouseEvent.CLICK, toggleCalendar);
			endField.icon.addEventListener(MouseEvent.CLICK, toggleCalendar);
			calendar1.addEventListener(Event.CHANGE, handleChange);
			calendar2.addEventListener(Event.CHANGE, handleChange);
			
			stage.addEventListener(MouseEvent.MOUSE_UP, _onMouseUp);
		}
		
		private function _onMouseUp(e:MouseEvent):void 
		{
			if (e.target.name != null	||
			e.target.name == "header" ||
			e.target.name == "cell" ||
			e.target.name == "next" ||
			e.target.name == "prev"
			) {
				return;
			}
			close();
		}
		
		private function toggleCalendar(e:MouseEvent):void 
		{
			if (stage.contains(c_holder)) {
				stage.removeChild(c_holder);
			}else{
				var pt:Point  = this.localToGlobal(new Point(0, startField.height + 5));
				c_holder.x = pt.x;
				c_holder.y = pt.y;
				stage.addChild(c_holder);
			}
		}
		
	}
}
import flash.display.Shape;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
class TextButton extends Sprite {
	protected var t:TextField;
	public function TextButton(label:String="button") {
		this.buttonMode = true;
		this.mouseChildren = false;
		var format:TextFormat = new TextFormat("Tahoma", 11, 0x1F5699,true);
			t = new TextField();
			t.defaultTextFormat = format;
			t.autoSize = TextFieldAutoSize.LEFT
			t.text = label;
			addChild(t);
	}
}
class Button extends TextButton {
	
	public function Button(label:String="button") {
		this.buttonMode = true;
		this.mouseChildren = false;
		var bg:Shape = new Shape();
		bg.graphics.lineStyle(1,0x9FA3A5);
		bg.graphics.beginFill(0xF3F3F3);
		bg.graphics.drawRect(0, 0, 80, 23);
		bg.graphics.endFill();
		addChild(bg);
		super(label);
		t.x = (bg.width - t.width) / 2;
		t.y = 1;
	}
	
}