
package 
{
	import flash.display.MovieClip;
	import com.greensock.*;
	import com.greensock.loading.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.display.*;
	import flash.events.*;
	import flash.filters.DropShadowFilter;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import flash.utils.*;
	/**
	 * ...
	 * @author M0rphel1
	 */
	

	public class JsonEditor_MoreParams extends MovieClip 
	{
		//[Embed(source="arial.ttf",embedAsCFF="false",fontWeight='regular',fontName='arial_reg',mimeType='application/x-font-truetype',unicodeRange = 'U+0020-U+007E')]
		private var arialreg:Font;
		private var _target:*;
		private var _datas:XML;
		private var _skin:MovieClip;
		private var a_params:Array = new Array();
		private var pas:int;
		private var loader:XMLLoader;
		private var type:String;		
		private	var yRef:int;
		//private var _url:String;
		
		public function JsonEditor_MoreParams(target:*, _font:Class, skin:MovieClip = null, _type:String = ""):void {
			
			trace ('skin : ' + skin + '/' + skin.name);
			type = _type;
			arialreg = new _font();
			_target = target;
			if (skin != null) {
				trace ('skin not null');
					_skin = skin
			}else {
					_skin = new MovieClip();
			}
			loader = new XMLLoader('https://clients.crown.fr/TVCrown/content/tmp/jsonEditor_fonts/json_' + _type + '_more_params.xml', { onComplete:datasHandler, onError:datasHandler } );
			loader.load();
			_skin.sc.visible = false;
			_skin.ctn.cacheAsBitmap = true;
			_skin.ctn_mask.cacheAsBitmap = true;
			_skin.ctn.mask = _skin.ctn_mask;
			yRef = _skin.ctn.y;
			//createParam('premier essai');
			
			
			
			
			
			
			
			
			
			
			
			
		}
	
		
		/**
		 * permet d'accéder au menu more params
		 * menu.push(datas)
		 * datas['input'] = tf_value;
		 * datas['name'] = name;
		 * @author M0rphel1
		 */
		public function get menu():Array
		{
			return a_params;
		}
		
		/**
		 * hides more params menu
		 * @author M0rphel1
		 */
		public function erase():void
		{
			if (_target.contains(_skin))
			{
				_target.removeChild(_skin);
			}
		}
		
		/**
		 * shows more params menu
		 * @author M0rphel1
		 */
		public function show():void
		{
			if (!_target.contains(_skin))
			{
				_target.addChild(_skin);
			}
		}
		
		public function refresh():void
		{
			while (_skin.ctn.numChildren > 0 )
			{
				_skin.ctn.removeChildAt(0);
			}
			a_params = new Array();
			//_skin.ctn.y = yRef
			loader = new XMLLoader('https://clients.crown.fr/TVCrown/content/tmp/jsonEditor_fonts/json_' + type + '_more_params.xml', { onComplete:datasHandler, onError:datasHandler } );
			loader.load();
			
		}
		
		private function datasHandler(evt:LoaderEvent):void {
				trace ('evt.type : ' + evt.type);
				var compteur:int = 0;
			switch (evt.type) {
				
				case 'error':
					trace ('error while loading datas for more params. Aborting...');
					break;
				case 'complete':
					trace ('more params datas are ready...analysing datas');
					a_params = new Array();
					_datas = evt.target.content;
					trace ('datas : ' + _datas);
					var nb_param:int = _datas.param_name.length();
					for each (var param:XML in _datas.param_name)
					{
						trace ('legnth : ' + nb_param);
						createParam(param, compteur);
						compteur ++
						if (compteur >= nb_param)
						{
							scroll();
						}
					}
				break;
				
			}
		}
		
		private function createParam(name:String, nb:int):void
		{
			//var font:Font = new arialreg();
			var tf_value:TextField = new TextField();
			var tf_param:TextField = new TextField();
			
			//var ft_value:TextFormat = new TextFormat();
			var ft_param:TextFormat = new TextFormat();
			ft_param.color = 0xFFFFFF;
			ft_param.font = arialreg.fontName;
			ft_param.size = 12;
			
			var ft_value:TextFormat = new TextFormat();
			ft_value.color = 0x000000;
			ft_value.font = arialreg.fontName;
			ft_value.size = 12;
			
			tf_param.width = 150;
			
			tf_value.background = true;
			tf_value.border = true;
			tf_value.borderColor = 0x000000;
			tf_value.backgroundColor = 0x7ebcef;
			tf_value.width = 140;
			tf_value.height = 20;
			
			tf_value.defaultTextFormat = ft_value;
			tf_param.defaultTextFormat = ft_param;
			
			tf_value.type = 'input';
			tf_param.text = name+ ' : ';
			
			_skin.ctn.addChild(tf_param);
			_skin.ctn.addChild(tf_value);
			
			var real_pos:int = Math.floor(nb * 0.5);
			tf_param.y = real_pos * (tf_value.height + 2);
			tf_param.x = (nb%2) * (tf_value.width + tf_param.width+5);
			/*if ((tf_param.y + tf_value.height) >= _skin.ctn.y + _skin.ctn.height) {
					tf_param.y = 2;
					tf_param.x = 500;
			}
			*/
			tf_value.name = 'ti_' + name;
			tf_value.x = tf_param.x + tf_param.width;
			tf_value.y = tf_param.y;
			
			tf_param.selectable = false;
			tf_param.filters = [new DropShadowFilter(2, 90, 0x000000, 1, 5, 5, 3, 1, false, false, false)];
			
			var datas:Dictionary = new Dictionary();
			
			datas['input'] = tf_value;
			datas['name'] = name;
			
			a_params.push(datas);
			
		}
		
		private function scroll():void {
			trace ('SCROLL');
			trace (a_params.length * 22);
			trace (_skin.ctn.height + '/' + _skin.cadre.height); 
			var actual_length:int = _skin.ctn.height;
			var limit_length:int = _skin.cadre.height;
			//var yRef:int = _skin.ctn.y;
			if (a_params.length > 8)
			{
				_skin.sc.visible = true;
				pas = actual_length - limit_length;
				trace ('YREF : ' + yRef +', PAS : ' + pas);
				_skin.sc.scroll_up.addEventListener(MouseEvent.MOUSE_DOWN, scrollUP);
				_skin.sc.scroll_up.addEventListener(MouseEvent.MOUSE_UP, scrollUP);
				//_skin.sc.scroll_up.addEventListener(MouseEvent.ROLL_OUT, scrollUP);
				_skin.sc.scroll_down.addEventListener(MouseEvent.MOUSE_DOWN, scrollDOWN);
				_skin.sc.scroll_up.addEventListener(MouseEvent.MOUSE_UP, scrollUP);
			}else {
				_skin.sc.visible = false;
			}
		/*	
			if (actual_length > limit_length) {
				
				//_skin.sc.scroll_down.addEventListener(MouseEvent.ROLL_OUT, scrollDOWN);
			}*/
			
			function scrollUP(evt:MouseEvent):void
			{
				var posY:int = _skin.ctn.y;
				switch (evt.type) {
						case MouseEvent.MOUSE_UP:
							if (posY >= yRef)
							{
								_skin.ctn.y = yRef;
							}
							break;
						case MouseEvent.MOUSE_DOWN:
							if (posY < yRef)
							{
								_skin.ctn.y += 6;
							}
							else
							{
								_skin.ctn.y = yRef;
							}
							/*for (var _posy:int = -pas; _posy < 0; _posy++) {
								moveY(_skin.ctn,posY+_posy);
								//_skin.ctn.y += _posy;
							}*/
							break;
				}
			}
			
			function scrollDOWN(evt:MouseEvent):void
			{
				var posY:int = _skin.ctn.y;
				
				switch (evt.type) {
						case MouseEvent.MOUSE_UP:
							if  ( posY <= yRef -pas )
							{
								_skin.ctn.y = yRef -pas;
							}
							break;
						case MouseEvent.MOUSE_DOWN:
							if (posY >yRef -pas)
							{
								_skin.ctn.y -= 6;
							}
							else
							{
								_skin.ctn.y = yRef+-pas;
							}
							/*for (var _posy:int = pas; _posy > 0; _posy--) {
								//setInterval(moveY(_skin.ctn,posY+_posy), 100);
								//var timer:Timer = new Timer
								//_skin.ctn.y += _posy;
								moveY(_skin.ctn,posY+_posy);
							}*/
							break;
				}
			}
			
		}
		
		private function moveY (mc:MovieClip, pos:int)
		{
			var timer:Timer = new Timer(100, 1);
			timer.addEventListener(TimerEvent.TIMER, ymove);
			timer.start();
			function ymove(evt:TimerEvent):void
			{
				evt.target.removeEventListener(TimerEvent.TIMER, ymove);
				mc.y = pos;
			}
		}
		
		
	}
	
}