
package 
{
	import com.greensock.*;
	import com.greensock.loading.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.display.*;
	import flash.events.*;
	/**
	 * ...
	 * @author M0rphel1
	 */
	public class JavaValues extends EventDispatcher 
	{
		private var liste:String = "";		
		private var listeXML:XML = new XML();
		private var url:String = "https://clients.crown.fr/TVCrown/content/tmp/jsonEditor_fonts/java_fonts.xml";
		private var loader:XMLLoader;
		private var valueName:String;
		
		public function JavaValues(_url:String, _valueName:String)
		{
			trace ('JavaValues init' + _url);
			valueName = _valueName;
			url = _url;
			init();
		}
		
		private function init():void
		{
			loader = new XMLLoader(url, { onError:errorHandler, onComplete:completeHandler } );
			loader.load();
			trace ('values loading ... ');
			
		}
		
		private function errorHandler(evt:LoaderEvent):void
		{
			trace ('javavalues error');
			evt.target.removeEventListener(LoaderEvent.ERROR, errorHandler);
			evt.target.removeEventListener(LoaderEvent.COMPLETE, completeHandler);
			liste = "Error no value list found...";
			trace ('liste : ' + liste);
			dispatchEvent(new Event('VALUES_READY'));
		}
		
		
		private function completeHandler(evt:LoaderEvent):void
		{
			trace ('javavalues complete');
			evt.target.removeEventListener(LoaderEvent.ERROR, errorHandler);
			evt.target.removeEventListener(LoaderEvent.COMPLETE, completeHandler);
			listeXML = evt.target.content;
			//trace ('complete xml : ' + evt.target.content);
			liste = traitementData(listeXML);
			
			dispatchEvent(new Event('VALUES_READY'));
		}
		
		private function traitementData(xml:XML):String
		{
			trace ('values loaded... please wait');
			loader.unload();
			var list:String = "";
			var pair:int;
			
			for each (var values:XML in xml..child(valueName))
			{
				trace ('javaValues' + values);
				pair ++;
				if (pair % 2 == 0)
				{
					list += '<p><a href=\"event:' + values + '\"><font color="#3896CC">' + values + '</font></a></p>';
				}
				else
				{
					list += '<p><a href=\"event:' + values + '\"><font color="#000000">' + values + '</font></a></p>';
				}
			}
			
			
			return list;
		}
		
		public function refresh():void
		{
			init();
		}
		
		public function get values():String
		{
			return liste;
		}
	}
	
}