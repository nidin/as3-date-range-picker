package nid.ui.controls.datePicker 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Nidin Vinayak
	 */
	public class Calendar extends Sprite 
	{
		private var cells:Vector.<Cell>;
		static private const GAP:Number = 1;
		private var c_holder:Sprite;
		private var bg:Sprite;
		private var header:Header;
		private var selected_date:Date;
		private var _day:int=-1;
		private var _month:int;
		private var _year:int;
		private var _week:int;
		private var daysinMonth:Array;
		private var today:int;
		private var tomonth:int;
		private var toyear:int;
		private var _months:Array	= 	["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];
		private var prev_cell:Cell;
		private var _startDays:int;
		private var _endDays:int;
		private var loc_date:Date;
		private var offset_days:int;
		private var primary:Boolean;
		private var selectedDays:int;
		public var backbupDate:Date;
		
		public function Calendar(primary:Boolean=false) 
		{
			this.primary = primary;
			loc_date = new Date();
			backbupDate = new Date();
			selected_date = new Date();
			_startDays = Math.round(selected_date.time / (1000 * 60 * 60 * 24));
			_endDays = _startDays;
			loc_date.date = 1;
			
			today = selected_date.date;
			tomonth = selected_date.month;
			toyear = selected_date.fullYear;
			
			daysinMonth	= [31, isLeapYear(_year)?29:28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
			
			cells = new Vector.<Cell>();
			
			
			bg = new Sprite();
			header = new Header();
			c_holder = new Sprite();
			c_holder.x = 2;
			c_holder.y = 40;
			
			addChild(bg);
			addChild(header);
			addChild(c_holder);
			
			for (var i:int = 0; i < 42; i++) {
				var cell:Cell = new Cell(false, 0,i);
				cells.push(cell);
				cell.x = int(i % 7) * (Cell.WIDTH + GAP);
				cell.y = int(Math.floor(i / 7)) * (Cell.HEIGHT + GAP);
				cell.addEventListener(MouseEvent.MOUSE_OVER, handleCellEvent);
				cell.addEventListener(MouseEvent.MOUSE_OUT, handleCellEvent);
				cell.addEventListener(MouseEvent.CLICK, handleCellEvent);
				c_holder.addChild(cell);
			}
			bg.y = Math.round(header.height);
			bg.graphics.lineStyle(1, 0x808080);
			bg.graphics.beginFill(0xffffff);
			bg.graphics.drawRect(0, 0, 149, 129);
			bg.graphics.endFill();
			header.next.addEventListener(MouseEvent.CLICK, handleEvent);
			header.prev.addEventListener(MouseEvent.CLICK, handleEvent);
			
			updateDate();
		}
		public function apply():void 
		{
			backbupDate.time = selected_date.time;
		}
		private function isLeapYear(fullYear:Number):Boolean 
		{
			var yearDev:Number = fullYear / 4;
			var yearDevLength:Number = yearDev.toString().split(".").length;
			return yearDevLength != 1?false:true;
		}
		public function get month():int { return _month }
		public function set month(value:int):void {
			if (_month != value) {
				
			}
			_month = value;
		}
		public function get year():int { return _year; }
		public function set year(value:int):void {
			if(_year != value){
				daysinMonth[1] = isLeapYear(_year)?29:28;
			}
			_year = value;
		}
		public function get selectedDate():Date { return selected_date; }
		public function set selectedDate(value:Date):void {
			_day 	= value.date;
			selectedDays = Math.round(value.time / (1000 * 60 * 60 * 24));
			loc_date.time = value.time;
			selected_date.time = value.time;
			loc_date.date = 1;
			if (prev_cell != null) {
				prev_cell.today = prev_cell.today;
				prev_cell.hitted = false;
			}
			updateDate();
		}
		public function set startDate(value:Date):void {
			_startDays = Math.round(value.time / (1000 * 60 * 60 * 24))
			updateDate();
		}
		public function set endDate(value:Date):void {
			_endDays = Math.round(value.time / (1000 * 60 * 60 * 24))
			updateDate();
		}
		private function updateDate():void {
			_week   = loc_date.getDay()
			month = loc_date.month;
			year = loc_date.fullYear;
			offset_days = Math.round(loc_date.time / (1000 * 60 * 60 * 24));
			
			header.title = _months[_month] +" " + _year;
			
			for (var i:int = 0; i < 42; i++) {
				var cd:int = (i - _week + 1);
				if (_week > i || cd > daysinMonth[_month]) {
					cells[i].clear();
				}else {
					
					cells[i].today = (cd == today && _month == tomonth && _year == toyear);
					
					cells[i].active = isActiveCell(cd);
					cells[i].hitted = isHitted(cd);
					
					if (cells[i].hitted) {
						if (cells[i].active) {
							cells[i].color = Cell.SELECTED_COLOR;
							prev_cell = cells[i];
						}else {
							cells[i].release();
							prev_cell = prev_cell == cells[i]?null:prev_cell;
						}
					}else if (cells[i].active) {
						cells[i].range = isRangeCell(cd);
						prev_cell = prev_cell == cells[i]?null:prev_cell;
					}
					
					cells[i].day = cd;
				}
			}
		}
		
		private function isHitted(value:int):Boolean
		{
			if (selected_date.fullYear == _year && selected_date.month == _month && value == selected_date.date){
				return true;
			}
			return false;
		}
		
		private function isRangeCell(cd:int):Boolean 
		{
			var currentDays:int = offset_days + cd;
			
			if (primary) {
				if (currentDays > selectedDays && currentDays <= _endDays+1) {
					return true;
				}
			}else {
				if (currentDays > _startDays && currentDays <= selectedDays) {
					return true;
				}
			}
			return false;
		}
		
		private function isActiveCell(cd:int):Boolean 
		{
			if (primary) return true;
			var d1:int = offset_days + cd;
			return d1 > _startDays;
		}
		
		private function handleCellEvent(e:MouseEvent):void 
		{
			var cell:Cell = e.currentTarget as Cell;
			if (!cell.active || cell == prev_cell) return;
			
			if (e.type == MouseEvent.MOUSE_OVER) {
				if (!cell.hitted) cell.color = Cell.SELECTED_COLOR;
			}else if (e.type == MouseEvent.MOUSE_OUT) {
				if (!cell.hitted) cell.today = cell.today;
			}else if (e.type == MouseEvent.CLICK) {
				if (prev_cell != null) {
					prev_cell.today = prev_cell.today;
					prev_cell.hitted = false;
				}
				cell.hitted = true;
				prev_cell = cell;
				_day = cell.day;
				_month = selected_date.month = loc_date.month;
				_year = selected_date.fullYear = loc_date.fullYear;
				selected_date.date = cell.day;
				selectedDays = Math.round(selected_date.time / (1000 * 60 * 60 * 24));
				updateDate();
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		private function handleEvent(e:MouseEvent):void 
		{
			switch(e.currentTarget) {
				case header.next:
					loc_date.month++;
					loc_date.date = 1;
					_day = -1;
					updateDate();
					break;
				case header.prev:
					loc_date.month--;
					loc_date.date = 1;
					_day = -1;
					updateDate();
					break;
				default:
					break;
			}
		}
	}

}
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Shape;
import flash.display.Sprite;
import flash.text.TextField;
import flash.text.TextFormat;

class Header extends Sprite {
	
	private var t:TextField;
	private var w:TextField;
	internal var next:Sprite;
	internal var prev:Sprite;
	
	public function set title(value:String):void {
		t.text = value;
	}
	public function set weeks(value:String):void {
		w.text = value;
	}
	
	public function Header() {
		this.name = "header";
		this.cacheAsBitmap = true;
		var format:TextFormat = new TextFormat("Tahoma", 11, 0, true);
		format.align = "center";
		t = new TextField();
		t.defaultTextFormat = format;
		t.mouseEnabled = false;
		t.width = 147;
		t.height = 18;
		t.text = "March 2013";
		addChild(t);
		w = new TextField();
		format.size = 10;
		format.bold = false;
		format.letterSpacing = 14;
		w.defaultTextFormat = format;
		w.mouseEnabled = false;
		w.width = 148;
		w.height = 18;
		w.text = "SMTWTFS";
		w.x = 6
		w.y = 20
		addChild(w);
		var bmpd:BitmapData = makeArrowBitmapData();
		(next = new Sprite()).addChild(new Bitmap(bmpd));
		(prev = new Sprite()).addChild(new Bitmap(flipPixels(bmpd)));
		next.x = w.width - prev.width;
		prev.x = 0;
		addChild(next);
		addChild(prev);
		prev.buttonMode = true;
		next.buttonMode = true;
		next.name = "next";
		prev.name = "prev";
	}
	private function makeArrowBitmapData():BitmapData
	{
		var th:uint = 10;
		var th_2:uint = th / 2;
		var ts:Shape = new Shape();
		var w:uint = 20;
		var h:uint = 20;
		var x1:uint = 5;
		ts.graphics.beginFill(0xDBE5F3);
		ts.graphics.drawRect(0, 0, w, h);
		ts.graphics.beginFill(0);
		ts.graphics.moveTo(x1, x1);
		ts.graphics.lineTo(x1 + th, x1 + th_2);
		ts.graphics.lineTo(x1, x1 + th);
		ts.graphics.lineTo(x1, x1);
		var bmp:BitmapData = new BitmapData(20, 20, false);
		bmp.draw(ts);
		return bmp;
	}
	private function flipPixels(data:BitmapData):BitmapData {
		var bmp:BitmapData = new BitmapData(20, 20, false);
		for (var i:int = 0; i < 20; i++) {
			for (var j:int = 0; j < 20; j++) {
				bmp.setPixel(j, i, data.getPixel(19 - j, i));
			}
		}
		return bmp;
	}
}