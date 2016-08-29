package 
{
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import JavaValues;
	import JsonEditor_MoreParams;
	/**
	 * ...
	 * @author M0rphel1
	 */
	public class EditFeatures extends MovieClip 
	{
		private var ti:TextField;
		private var list, addbt, erasebt, refreshbt, menuMouse:MovieClip;
		private var selectedValue, valueType, additional_params_type:String;
		private var target:*;
		private var valuesVisible:Boolean;
		private var valueName:String;
		private var javaValues:JavaValues; 
		private var additional_params:Boolean;
		private var texte_moreparams:JsonEditor_MoreParams;
		private var photo_moreparams:JsonEditor_MoreParams;
		
		public function EditFeatures(_target:*,_input:TextField, _list:MovieClip, _addbt:MovieClip, _erasebt:MovieClip,_refreshbt:MovieClip,_menuMouse:MovieClip,_valueName:String, _additional_params:Boolean = false,_txtmoreparams:JsonEditor_MoreParams = null, _photomoreparams:JsonEditor_MoreParams = null):void
		{
			target = _target;
			ti = _input;
			list = _list;
			addbt = _addbt;
			erasebt = _erasebt;
			refreshbt = _refreshbt;
			menuMouse = _menuMouse;
			valueName = _valueName;
			additional_params = _additional_params;
			texte_moreparams = _txtmoreparams;
			photo_moreparams = _photomoreparams;
			
			additional_params_type = 'texte';
			
			javaValues = new JavaValues('hosting_rep_url/json_' + additional_params_type + 's_more_params.xml', "param_name");
			
			if (additional_params)
			{
				list.bt_type.addEventListener(MouseEvent.CLICK, switchModeHandler);
				list.bt_type.addEventListener(Event.ENTER_FRAME, checkMode);
			}
			list.deroul.addEventListener(MouseEvent.CLICK, valueList);
			addbt.addEventListener(MouseEvent.CLICK, addNewValue);
			erasebt.addEventListener(MouseEvent.CLICK, eraseNewValue);
			refreshbt.addEventListener(MouseEvent.CLICK, refreshValues);
		}
		
		private function checkMode(evt:Event):void
		{
			switch(evt.target.currentFrame)
			{
				case 1:
					additional_params_type = "texte";
					
					break;
				case 2:
					additional_params_type = "photo";
					break;
			}
		}
		
		private function switchModeHandler(evt:MouseEvent):void
		{
			evt.target.play();
			javaValues = null;
			javaValues = new JavaValues('hosting_rep_url/json_' + additional_params_type + 's_more_params.xml', "param_name");
		}
		
		/**
		 * Gestion d'évenement finish de l'objet javaFonts (on attend bien que la classe javaFonts aie fini tout son traitement)
		 * @param evt : Event -> ici on ecoute l'evenement 'FONTS_READY' distribué par la classe javaFonts
		 * @author Morphelin
		 */
		private function activateList(evt:Event):void
		{
			evt.target.removeEventListener('VALUES_READY', activateList);
			trace ('READY');
			list.addEventListener(MouseEvent.CLICK, valueList);
		}
		
		/**
		 * Actualisation de la liste des polices disponibles
		 * @param evt : MouseEvent=null -> événements liés à la souris / facultatif
		 * @author Morphelin
		 */
		private function refreshValues(evt:MouseEvent = null):void
		{
			javaValues = null;
			javaValues = new JavaValues('hosting_rep_url/json_' + additional_params_type + 's_more_params.xml', "param_name");
			javaValues.addEventListener('VALUES_READY', updateList)
			//tf_actualise = (additional_params_type == "texte") ? texte_moreparams.menu['input']:photo_moreparams.menu['input'];
			if (additional_params_type == "texte")
			{
				texte_moreparams.refresh();
			}
			else
			{
				photo_moreparams.refresh();
			}
			javaValues.refresh();
			/*var timerAffichage:Timer = new Timer(500, 1);
			timerAffichage.addEventListener('timer', updateList);
			timerAffichage.start();*/
			trace ('refresh en cours...');
		
		}
		
		
		/**
		 * Ecouteur d'évènements sur le champ texte qui affiche la liste des polices
		 * permet l'affichage du menu d'edition de la liste des polices en fonction de la police choisie
		 * @param evt :TextEvent -> événements spécifiques aux champs textes
		 * @author Morphelin
		 */
		private function linkHandler(linkEvent:TextEvent):void {
				trace ('[clickInAndWriteIn] linkEvent : ' + linkEvent);
				var s:String = "";
				s = linkEvent.text	
				
				/*trace ('[clickInAndWriteIn] : S from HtmlText : ' + s );	
				var removeHtmlRegExp:RegExp = new RegExp("<[^<]+?>", "gi");
				s = s.replace(removeHtmlRegExp, "");*/
				
				trace ('[clickInAndWriteIn] : S CLEANED : ' + s );
				selectedValue = s;
				if (!this.contains(menuMouse))
				{
					this.addChild(menuMouse);
					menuMouse.x = mouseX;
					menuMouse.y = mouseY;
				}
				else
				{
					this.removeChild(menuMouse);
					this.addChild(menuMouse);
					menuMouse.x = mouseX;
					menuMouse.y = mouseY;
				}
				
				menuMouse.del.addEventListener(MouseEvent.CLICK, mouseMenuHandler);				
				menuMouse.ajout.addEventListener(MouseEvent.CLICK, mouseMenuHandler);
				target.addEventListener(MouseEvent.CLICK, mouseMenuHandler);
		}
		
		private function mouseMenuHandler(evt:Event):void
		{
			trace ('yippie' + menuMouse.name);
			trace ('selectedValue = ' + selectedValue);
			if (evt.type == MouseEvent.CLICK)
			{
				evt.currentTarget.removeEventListener(MouseEvent.CLICK, mouseMenuHandler);
				switch (evt.currentTarget.name) {
						case "del":
							ti.text = selectedValue;
							eraseMouseMenu();
							eraseNewValue();
							break;
						case "ajout":
							ti.text = selectedValue;
							eraseMouseMenu();
							break;	
						default:
							eraseMouseMenu();
							break;
				}
			}
			else
			{
				
			eraseMouseMenu();
			}
		}
		
		/**
		 * Masque le menu souris
		 * @author Morphelin
		 */
		private function eraseMouseMenu():void
		{
			
			menuMouse.del.removeEventListener(MouseEvent.CLICK, mouseMenuHandler);				
			menuMouse.ajout.removeEventListener(MouseEvent.CLICK, mouseMenuHandler);			
			target.removeEventListener(MouseEvent.CLICK, mouseMenuHandler);
			if (this.contains(menuMouse)) this.removeChild(menuMouse);
		}
		
		/**
		 * Affichage de la liste des polices actualisée
		 * @param evt : Event -> événements
		 * @author Morphelin
		 */
		private function updateList(evt:Event):void
		{
			
			evt.target.removeEventListener('VALUES_READY', updateList);
			//evt.target.stop();	
			if (list.currentFrame == 2)
			{
					list.tf.htmlText = javaValues.values;				
					//LinkTF.clickInAndWriteIn(list.tf, selectedFont);
					list.tf.addEventListener(TextEvent.LINK, linkHandler);
					trace ('refreshing values list, current selectValue frame: ' + list.currentFrame);
			}
		}
		
		/**
		 * Gestion des évènements souris de la liste des polices
		 * @param evt : MouseEvent-> événements liés à la souris
		 * @author Morphelin
		 */
		private function valueList(evt:MouseEvent):void
		{
			trace ('VALUE LIST');
			trace (evt.target.name + ' clicked')
			if ( !valuesVisible)
			{
				if (evt.target.name != 'tf')
				{
					trace ('javaValues.values : ' + javaValues.values);
					list.gotoAndStop(2);
					list.tf.htmlText = javaValues.values;
					list.tf.addEventListener(TextEvent.LINK, linkHandler);
					valuesVisible = true;
				}
			}
			else
			{
				if (evt.target.name != 'tf')
				{
					list.gotoAndStop(1);
					valuesVisible = false;
				}
			
			}
			//list.tf.mouseEnabled = false;
			trace ('fonts : \n' + javaValues.values); 
		}
		
		/**
		 * Action éffacer une police de la liste des polices disponibles
		 * Page php appelée : https://clients.crown.fr/TVCrown/content/jsonEditor_fontsUpdate.php
		 * @param evt : MouseEvent=null -> événements liés à la souris / facultatif
		 * @author Morphelin
		 */
		private function eraseNewValue(evt:MouseEvent = null):void
		{ 
			var params:String = "";
			var value:String = ti.text;
			value = value.split('\n').join('');
			value = value.split('\r').join('');
			trace ('addNewValue : [' + value + ']');
			var chargeur:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest('hosting_rep_url/jsonEditor_' + valueName+'sUpdate.php');
			if (additional_params) params = "&type=" + additional_params_type;
			var vars:URLVariables = new URLVariables(valueName + "_name=" + value + "&mode=erase" + params);
			request.method = 'get';
			request.data = vars;
			chargeur.addEventListener(Event.COMPLETE, sendValueRequest);
			if (value != "")
			{
				chargeur.load(request);
			}
		}
		
		/**
		 * Action ajouter une police à la liste des polices disponibles
		 * page php appelé : https://clients.crown.fr/TVCrown/content/jsonEditor_fontsUpdate.php
		 * @param evt : MouseEvent=null -> événements liés à la souris / facultatif
		 * @author Morphelin
		 */
		private function addNewValue(evt:MouseEvent):void
		{ 
			var params:String = "";
			var value:String = ti.text;
			value = value.split('\n').join('');
			value = value.split('\r').join('');
			trace ('addNewValue : [' + value + ']');
			var chargeur:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest('hosting_rep_url/jsonEditor_' + valueName+'sUpdate.php');
			trace ('request add : ' + request.url);
			if (additional_params) params = "&type=" + additional_params_type;
			var vars:URLVariables = new URLVariables(valueName + "_name=" + value + "&mode=add" + params);
			request.method = 'get';
			request.data = vars;
			chargeur.addEventListener(Event.COMPLETE, sendValueRequest);
			if (value != "")
			{
				chargeur.load(request);
			}
		}
		
		private function sendValueRequest(evt:Event):void
		{
			 trace(evt.target);
			trace(evt.target.data);
			//evt.target.removeEventListener(Event.COMPLETE, sendFontRequest);
			trace ('request complete');
			refreshValues();
		}
	}
	
}
