
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
	public class JavaFonts extends EventDispatcher 
	{
		private var liste:String = "";		
		private var listeXML:XML = new XML();
		private var url:String = "hosting_rep_url/java_fonts.xml";
		private var loader:XMLLoader;
		
		public function JavaFonts()
		{
			init();
		}
		
		private function init():void
		{
			loader = new XMLLoader(url, { onError:errorHandler, onComplete:completeHandler } );
			loader.load();
			trace ('loading ... ');
			
		}
		
		private function errorHandler(evt:LoaderEvent):void
		{
			evt.target.removeEventListener(LoaderEvent.ERROR, errorHandler);
			evt.target.removeEventListener(LoaderEvent.COMPLETE, completeHandler);
			liste = "Error no font list found...";
			trace ('liste : ' + liste);
			dispatchEvent(new Event('FONTS_READY'));
		}
		
		
		private function completeHandler(evt:LoaderEvent):void
		{
			evt.target.removeEventListener(LoaderEvent.ERROR, errorHandler);
			evt.target.removeEventListener(LoaderEvent.COMPLETE, completeHandler);
			listeXML = evt.target.content;
			//trace ('complete xml : ' + evt.target.content);
			liste = traitementData(listeXML);
			
			dispatchEvent(new Event('FONTS_READY'));
		}
		
		private function traitementData(xml:XML):String
		{
			trace ('fonts loaded... please wait');
			loader.unload();
			var list:String = "";
			var pair:int;
			
			for each (var fonts:XML in xml..font)
			{
				pair ++;
				if (pair % 2 == 0)
				{
					list += '<p><a href=\"event:' + fonts + '\"><font color="#0066CC">' + fonts + '</font></a></p>';
				}
				else
				{
					list += '<p><a href=\"event:' + fonts + '\"><font color="#333333">' + fonts + '</font></a></p>';
				}
			}
			
			
			return list;
		}
		
		public function refresh():void
		{
			init();
		}
		
		public function get fonts():String
		{
			return liste;
		}
	}
	
}
