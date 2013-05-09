package nid.ui.controls.datePicker 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Nidin Vinayak
	 */
	public class Cell extends Sprite 
	{
		static internal const WIDTH:Number = 20;
		static internal const HEIGHT:Number = 20;
		static internal const INACTIVE_COLOR:Number = 0xFFFFFF;
		static internal const INACTIVE_TEXT_COLOR:Number = 0xA3A3AB;
		static internal const ACTIVE_COLOR:Number = 0xFFFFFF;
		static internal const RANGE_COLOR:Number = 0xFDECD1;
		static internal const TODAY_COLOR:Number = 0xFF0000;
		static internal const SELECTED_COLOR:Number = 0xFFA500;
		private var _active:Boolean;
		private var _day:uint;
		private var t:TextField;
		private var format:TextFormat;
		private var _range:Boolean;
		internal var index:int;
		internal var hitted:Boolean;
		internal var _today:Boolean;
		
		public function Cell(active:Boolean,day:uint,index:int) 
		{
			this.name = "cell";
			this.index = index;
			this.mouseChildren = false;
			this.buttonMode = true;
			
			this._active = active;
			this._day = day;
			
			graphics.beginFill(INACTIVE_COLOR);
			graphics.drawRect(0, 0, WIDTH, HEIGHT);
			graphics.endFill();
			
			format = new TextFormat("Tahoma", 11, 0);
			format.align = "center";
			t = new TextField();
			t.defaultTextFormat = format;
			t.width = 20;
			t.height = 20;
			t.text = index.toString();
			addChild(t);
		}
		public function set text(value:String):void {
			t.text = value;
		}
		public function clear():void 
		{
			_range = false;
			active = false;
			today = false;
			color = INACTIVE_COLOR;
			t.text = "";
		}
		
		public function release():void 
		{
			_range = false;
			hitted = false;
			color = ACTIVE_COLOR;
		}
		
		public function get range():Boolean { return _range; } 
		public function set range(value:Boolean):void 
		{
			_range = value;
			if (value) {
				color = RANGE_COLOR;
			}else {
				today = _today
			}
		}
		public function get today():Boolean { return _today; }
		public function set today(value:Boolean):void {
			_today = value;
			if (_range) {
				color = RANGE_COLOR;
			}else {
				color = ACTIVE_COLOR;  
			}
		}
		public function set color(value:uint):void {
			graphics.clear();
			if (_today) graphics.lineStyle(1, TODAY_COLOR);
			graphics.beginFill(value);
			graphics.drawRect(0, 0, WIDTH, HEIGHT);
			graphics.endFill();
		}
		public function get day():uint { return _day; }
		public function set day(value:uint):void {
			_day = value;
			if (_day > 0) {
				_active = true;
				t.text = _day.toString();
			}else {
				_active = false;
				t.text = "";
			}
		}
		public function get active():Boolean { return _active; }
		public function set active(value:Boolean):void { 
			_active = value;
			if (!value) range = false;
			this.mouseEnabled = _active;
			if (_active) {
				format.color = 0;
			}else {
				format.color = INACTIVE_TEXT_COLOR;
			}
			t.defaultTextFormat = format;
			t.text = t.text;
		}
	}

}