package  {
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.text.TextField;
	import flash.net.FileReference;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import JsonParser;
	import Morph.Effects;
	import UploadFont;
	import LinkTF;
	import Morph.ColorPicker;
	import JsonEditor_MoreParams;
	import EditFeatures;
	
	
	public class JsonEditor extends MovieClip{
		
		private var texte_moreparams:JsonEditor_MoreParams; 
		private var param:MovieClip = new more_params();
		private var photo_moreparams:JsonEditor_MoreParams;
		private var paramP:MovieClip = new more_params();
		
		private var tmpNames:Array = new Array();
		private var tmpphotoName:Array = new Array();
		private var savedDatas:Array = new Array();
		private var textCounter:int = 0;
		private var photoCounter:int = 0;
		private var addPicOn = false;
		private var addTextOn = false;
		private var Fname:String = "";
		private var Fposx:String = "";
		private var Fposy:String = "";
		private var Fwidth:String = "";
		private var Fheight:String = "";
		private var Ffontsize:String = "";
		private var Fpolice:String = "";	
		private var Fcolor:String = "";
		private var Feffect:String = "";
		private var FappType:String = "";
		private var FappDuration:String = "";
		private var FappDelay:String = "";
		private var FappDebut:String = "";
		private var FappFin:String = "";
		private var FdisType:String = "";
		private var FdisDuration:String = "";
		private var FdisDelay:String = "";
		private var FdisDebut:String = "";
		private var FdisFin:String = "";
		private var Fdefaultvalue:String = "";
		private var Fcroptype:String = "";
		private var json:FileReference = new FileReference();
		private var finalData:String;
		private var finalTextsData:String = "";
		private var finalPhotosData:String = "";
		private var focused:int = 0;
		private var text_inputs:Array = new Array();
		private var photo_inputs:Array = new Array();
		private var selectAppValue:String;
		private var selectDispValue:String;
		private var tmpSelectInput:TextField;
		private var photo_type:MovieClip = new picturefield();
		private var text_type:MovieClip = new textfield();
		private var nbBlocs:int = 0;
		private var editMode:Boolean = false;
		private var checkName:String;
		private var ctrl:Boolean = false;
		private var jsonDataLoaded:String;
		private var loadedInfos:Array;
		private var nbTextsLoaded:int;
		private var nbPhotosLoaded:int;
		private var nbBalises:int = 0;
		private var indexBalises:Array = new Array();
		private var balisesTextSaved:Array = new Array();
		private var balisesPhotosSaved:Array = new Array();
		private var positionsBlocs:Array = new Array();
		private var blocs:Array = new Array();
		private var filename:String = 'jsons.txt';
		private var javafonts:JavaFonts = new JavaFonts();
		private var fontsVisible:Boolean = false;
		private var up_font:UploadFont;
		private var selectedFont:String;
		private var menuMouse:fontsMenuMouse = new fontsMenuMouse();
		private var colorpicker:ColorPicker;
		private var bg_menu_effets_texts:MovieClip = new fond_menu_effets();
		private var bg_menu_effets_photos:MovieClip = new fond_menu_effets();
		private var effect:Effects;
		private var separation:String = "---------------------------------------------------------------------------------------------------------------------------------------"
		//private var menu_params:EditFeatures = new EditFeatures(
		//private var colorFont:ColorPicker
		//private var jsonObject:JSON = new JSON();
		
		public function JsonEditor() {
			// constructor code
			if (stage)
			{
				init();
			}
			else {
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		/**
		 * Permet d'ajouter à la liste d'affichage un movieclip
		 * @author Morphelin
		 * @param	mc : MovieClip le clip à afficher
		 */
		private function show(mc:MovieClip):void
		{
			//resetAll();
			if (!stage.contains(mc)) stage.addChild(mc);
		}
		
		/**
		 * Permet de retirer de la liste d'affichage un movieclip
		 * @author Morphelin
		 * @param	mc : MovieClip le clip à ne plus afficher
		 */
		private function hide(mc:MovieClip):void
		{
			if (stage.contains(mc)) stage.removeChild(mc);
		}
		
		/**
		 * Calcul d'une valeur en FULL HD
		 * @author Morphelin
		 * @param	evt : MouseEvent en fonction d'un évènement souris
		 */
		private function convertNumbers(evt:MouseEvent):void
		{
			var result:String;
			try {
				result = String(Number(calc_entry.text) * 1.5);
			}catch (calcError:Error)
			{
				result = '0';
			}
			
			calc_entry.text = result;
		}
		
		/**
		 * Ajout du color picker
		 * @author Morphelin
		 */
		private function makeColorPicker():void
		{
			var format:TextFormat = new TextFormat();
			var police1:Police1 = new Police1();
			format.font = police1.fontName;
			format.size = 10;
			format.color = 0x000000;

			var spectrum:MovieClip = new spectrum_mc();
			colorpicker = new ColorPicker(format, spectrum, text_type.cp, text_type.ti_color, text_type.cp.actualColor);
			colorpicker.colorPicker.y = 19;
			colorpicker.colorPicker.x = -2;
			colorpicker.colorPicker.visible = false;
			text_type.cp.addEventListener(MouseEvent.ROLL_OUT, colorPickerHandler);
			text_type.cp.addEventListener(MouseEvent.CLICK, colorPickerHandler);
		}
		
		/**
		 * Gestion des évènements liés au ColorPicker
		 * @param evt : MouseEvent -> événements liés uniquement à la souris
		 * @author Morphelin
		 */
		private function colorPickerHandler(evt:MouseEvent):void
		{
			switch (evt.type)
			{
				case MouseEvent.ROLL_OUT:
					colorpicker.colorPicker.visible = false;
					break;
				case MouseEvent.CLICK:
					colorpicker.colorPicker.visible = true;
					break;
			}
		}
		
		/**
		 * Gestion du focus de la calculatrice
		 * @param evt : FocusEvent -> événements liés au Focus d'un text Input
		 * @author Morphelin
		 */
		private function calcFocusHandler(evt:FocusEvent):void
		{
			evt.target.addEventListener(KeyboardEvent.KEY_UP, calculate);
		}
		
		/**
		 * Calcul de la valeur en FULL HD
		 * si l'utilisateur appuie sur la touche entree après avoir renseigné un nombre / chiffre dans le champ input de la calc
		 * @param evt : KeyBoardEvent -> événements liés au clavier
		 * @author Morphelin
		 */
		private function calculate(evt:KeyboardEvent):void
		{
			if (evt.keyCode == 13) // si on appuie sur entrée
			{
				//evt.target.removeEventListener(KeyboardEvent.KEY_UP, calculate);
				//stage.focus = stage;
				var result:String;
				calc_entry.text = calc_entry.text.split('\n').join('');
				calc_entry.text = calc_entry.text.split('\r').join('');
				try {
					result = String(Number(calc_entry.text) * 1.5);
				}catch (calcError:Error)
				{
					result = '0';
				}
				
				calc_entry.text = result;
			}
		}
		
		/**
		 * Gestion d'évenement finish de l'objet javaFonts (on attend bien que la classe javaFonts aie fini tout son traitement)
		 * @param evt : Event -> ici on ecoute l'evenement 'FONTS_READY' distribué par la classe javaFonts
		 * @author Morphelin
		 */
		private function activateList(evt:Event):void
		{
			evt.target.removeEventListener('FONTS_READY', activateList);
			trace ('READY');
			selectFont.addEventListener(MouseEvent.CLICK, fontList);
		}
		
		/**
		 * Actualisation de la liste des polices disponibles
		 * @param evt : MouseEvent=null -> événements liés à la souris / facultatif
		 * @author Morphelin
		 */
		private function refreshFonts(evt:MouseEvent = null):void
		{
			javafonts.addEventListener('FONTS_READY', updateList)
			javafonts.refresh();
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
				selectedFont = s;
				if (!this.contains(menuMouse))
				if (!this.contains(menuMouse))
				{
					addChild(menuMouse);
					menuMouse.x = mouseX;
					menuMouse.y = mouseY;
				}
				else
				{
					removeChild(menuMouse);
					addChild(menuMouse);
					menuMouse.x = mouseX;
					menuMouse.y = mouseY;
				}
				
				menuMouse.del.addEventListener(MouseEvent.CLICK, mouseMenuHandler);				
				menuMouse.ajout.addEventListener(MouseEvent.CLICK, mouseMenuHandler);
				stage.addEventListener(MouseEvent.CLICK, mouseMenuHandler);
		}
		
		/**
		 * Affichage de la liste des polices actualisée
		 * @param evt : Event -> événements
		 * @author Morphelin
		 */
		private function updateList(evt:Event):void
		{
			
			evt.target.removeEventListener('FONTS_READY', updateList);
			//evt.target.stop();	
			if (selectFont.currentFrame == 2)
			{
					selectFont.tf.htmlText = javafonts.fonts;				
					//LinkTF.clickInAndWriteIn(selectFont.tf, selectedFont);
					selectFont.tf.addEventListener(TextEvent.LINK, linkHandler);
					trace ('refreshing font list, current selectFont : ' + selectFont.currentFrame);
			}
		}
		
		/**
		 * Gestion des évènements souris de la liste des polices
		 * @param evt : MouseEvent-> événements liés à la souris
		 * @author Morphelin
		 */
		private function fontList(evt:MouseEvent):void
		{
			trace (evt.target.name + ' clicked')
			if ( !fontsVisible)
			{
				if (evt.target.name != 'tf')
				{
					selectFont.gotoAndStop(2);
					selectFont.tf.htmlText = javafonts.fonts;
					selectFont.tf.addEventListener(TextEvent.LINK, linkHandler);
					fontsVisible = true;
				}
			}
			else
			{
				if (evt.target.name != 'tf')
				{
					selectFont.gotoAndStop(1);
					fontsVisible = false;
				}
			
			}
			//selectFont.tf.mouseEnabled = false;
			trace ('fonts : \n' + javafonts.fonts); 
		}
		
		/**
		 * Action éffacer une police de la liste des polices disponibles
		 * Page php appelée : https://clients.crown.fr/TVCrown/content/jsonEditor_fontsUpdate.php
		 * @param evt : MouseEvent=null -> événements liés à la souris / facultatif
		 * @author Morphelin
		 */
		private function eraseNewFont(evt:MouseEvent = null):void
		{ 
			var value:String = font_input.text;
			value = value.split('\n').join('');
			value = value.split('\r').join('');
			trace ('addNewFont : [' + value + ']');
			var chargeur:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest('https://clients.crown.fr/TVCrown/content/json_editor/jsonEditor_fontsUpdate.php');
			var vars:URLVariables = new URLVariables("font=" + value + "&mode=erase");
			request.method = 'post';
			request.data = vars;
			chargeur.addEventListener(Event.COMPLETE, sendFontRequest);
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
		private function addNewFont(evt:MouseEvent):void
		{ 
			var value:String = font_input.text;
			value = value.split('\n').join('');
			value = value.split('\r').join('');
			trace ('addNewFont : [' + value + ']');
			var chargeur:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest('https://clients.crown.fr/TVCrown/content/json_editor/jsonEditor_fontsUpdate.php');
			var vars:URLVariables = new URLVariables("font=" + value + "&mode=add");
			request.method = 'get';
			request.data = vars;
			chargeur.addEventListener(Event.COMPLETE, sendFontRequest);
			if (value != "")
			{
				chargeur.load(request);
			}
		}
		
		/**
		 * Ecouteur d'evenement COMPLETE de la requete php pour la mise à jour des styles
		 * @param evt : Event -> événements
		 * @author Morphelin
		 */
		private function sendStyleRequest(evt:Event):void
		{
			 trace(evt.target);
			trace(evt.target.data);
			//evt.target.removeEventListener(Event.COMPLETE, sendFontRequest);
			trace ('request complete');
		}
		
		/**
		 * Ecouteur d'evenement COMPLETE de la requete php pour la mise à jour des polices
		 * @param evt : Event -> événements
		 * @author Morphelin
		 */
		private function sendFontRequest(evt:Event):void
		{
			 trace(evt.target);
			trace(evt.target.data);
			//evt.target.removeEventListener(Event.COMPLETE, sendFontRequest);
			trace ('request complete');
			refreshFonts();
		}
		
		/**
		 * permet de changer l'index du caret du champs text input et de le positionner à la fin
		 * @param evt : * -> événements de tous type
		 * @author Morphelin
		 */
		private function selectionHandler(evt:*):void
		{
			font_input.setSelection(font_input.selectionEndIndex, 	font_input.selectionEndIndex );
			font_input.text = clean(font_input.text);
		}
		
		/**
		 * Purge un champ text de tous les sauts de ligne
		 * @param evt : * -> événements de tous type
		 * @author Morphelin
		 */
		private function removeMultilines(evt:Event):void
		{
			var tf:TextField = new TextField();
			tf = evt.target as TextField;
			tf.text = clean(tf.text);
		}

		/**
		 * Nettoie une chaine de texte de tous les sauts de ligne
		 * @param s : String -> la chaine de texte à nettoyer
		 * @return s : String
		 * @author Morphelin
		 */
		private function clean(s:String):String
		{
			s = s.split('\n').join('');
			s = s.split('\r').join('');
			return s;
		}
		
		/**
		 * Gestion des actions du menu souris sur les polices disponibles ( Effacer / rajouter)
		 * @param evt : Event -> événements 
		 * @author Morphelin
		 */
		private function mouseMenuHandler(evt:Event):void
		{
			trace ('yippie' + menuMouse.name);
			trace ('selectedFont = ' + selectedFont);
			if (evt.type == MouseEvent.CLICK)
			{
				evt.currentTarget.removeEventListener(MouseEvent.CLICK, mouseMenuHandler);
				switch (evt.currentTarget.name) {
						case "del":
							font_input.text = selectedFont;
							eraseMouseMenu();
							eraseNewFont();
							break;
						case "ajout":
							text_type.ti_font.text = selectedFont;
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
			stage.removeEventListener(MouseEvent.CLICK, mouseMenuHandler);
			if (this.contains(menuMouse)) this.removeChild(menuMouse);
		}
		
		/**
		 * Gestion d'évènements liés à la liste des styles disponibles pour lae champ effects
		 * @param evt : MouseEvent 
		 * @author Morphelin
		 */
		private function textsEffectsHandler(evt:MouseEvent):void
		{
			if (evt.target.contains(bg_menu_effets_texts))
			{
				evt.target.removeChild(bg_menu_effets_texts);
			}
			switch (evt.type) {
			case MouseEvent.ROLL_OVER:
				createStylesMenu(bg_menu_effets_texts, text_type.ti_effect);
				evt.target.addChild(bg_menu_effets_texts);
				evt.target.gotoAndStop(2);
				break;
			case MouseEvent.ROLL_OUT:
				evt.target.gotoAndStop(1);
				effect.clean();
				if (evt.target.contains(bg_menu_effets_texts))
				{
				
					evt.target.removeChild(bg_menu_effets_texts);
				}
				break;
			}
		}
		
		/**
		 * Création de la bibliothèque d'effets / styles
		 * @param mc : MovieClip -> conteneur de la bibliotheque
		 * @param tf: TextField -> champ texte qui affichera le css en fonction du bouton cliqué dans la bibliotheque
		 * @author Morphelin
		 */
		private function createStylesMenu(mc:MovieClip, tf:TextField):void
		{
			effect = new Effects(mc, tf, Police1);
		}
			
		/**
		 * Action éffacer un effet de la bibliothèque d'effets
		 * page php appelée : https://clients.crown.fr/TVCrown/content/jsonEditor_stylesUpdate.php
		 * @param evt : Mouseevent = null -> événement liés à la souris / facultatif
		 * @author Morphelin
		 */
		private function eraseStyles(evt:MouseEvent = null):void
		{ 
			var value:String = clean(css_input.text);
			var name:String = clean(cssName_input.text);
			trace ('erase Style : [' + name + ']');
			var chargeur:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest('https://clients.crown.fr/TVCrown/content/json_editor/jsonEditor_stylesUpdate.php');
			var vars:URLVariables = new URLVariables("styleName=" + name + '&styleValue=' + value + "&mode=erase");
			request.method = 'get';
			request.data = vars;
			chargeur.addEventListener(Event.COMPLETE, sendStyleRequest);
			if (name != "" && name!="Name")
			{
				chargeur.load(request);
			}
		}
		
		/**
		 * Action ajouter un effet à la bibliothèque d'effets
		 * page php appelée : https://clients.crown.fr/TVCrown/content/jsonEditor_stylesUpdate.php
		 * @param evt : Mouseevent -> événement liés à la souris 
		 * @author Morphelin
		 */
		private function refreshStyles(evt:MouseEvent):void
		{ 
			
			var value:String = clean(css_input.text);
			var name:String = clean(cssName_input.text);
			trace ('addNewStyle : [' + name + '][' + value + ']');
			var chargeur:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest('https://clients.crown.fr/TVCrown/content/json_editor/jsonEditor_stylesUpdate.php');
			var vars:URLVariables = new URLVariables("styleName=" + name + '&styleValue=' + value + "&mode=add");
			request.method = 'get';
			request.data = vars;
			chargeur.addEventListener(Event.COMPLETE, sendStyleRequest);
			if (name != "" && name!="Name" && value != "" && value!="css: [value]")
			{
				chargeur.load(request);
			}
		}
		
		/**
		 * lien aide au css - envoie sur la page W3Schools
		 * page html appelée : http://www.w3schools.com/cssref/
		 * @param evt : Mouseevent -> événement liés à la souris 
		 * @author Morphelin
		 */
		private function cssHelp(evt:MouseEvent):void
		{
			navigateToURL(new URLRequest('http://www.w3schools.com/cssref/'), "_blank");
		}
		
		/**
		 * Initialisation des données
		 * @param evt : Event = null -> événement / facultatif 
		 * @author Morphelin
		 */
		private function init(evt:Event = null):void {
			
			var menuP:MovieClip = new fontsMenuMouse
			
			texte_moreparams = new JsonEditor_MoreParams( this, Police1, param, 'textes');
			texte_moreparams.erase();
			photo_moreparams = new JsonEditor_MoreParams( this, Police1, paramP, 'photos');
			photo_moreparams.erase();
			
			var menuParams:EditFeatures = new EditFeatures(this, param_input, selectParam, param_add_bt, param_erase_bt, bt_refresh_param, menuP, "param", true, texte_moreparams,photo_moreparams);
			
			w3c.addEventListener(MouseEvent.CLICK, cssHelp);
			//LinkTF.addEventListener('fontclicked', mouseMenuHandler); infos_styles
			cssName_input.addEventListener(FocusEvent.FOCUS_IN, focusHandler);
			css_input.addEventListener(FocusEvent.FOCUS_IN, focusHandler);
			cssName_input.addEventListener(FocusEvent.FOCUS_OUT, focusHandler);
			css_input.addEventListener(FocusEvent.FOCUS_OUT, focusHandler);
			css_add_bt.addEventListener(MouseEvent.CLICK, refreshStyles);
			css_erase_bt.addEventListener(MouseEvent.CLICK, eraseStyles);
			makeColorPicker();
			menuMouse.name = 'menu_fonts';
			font_input.addEventListener(FocusEvent.FOCUS_IN, selectionHandler);
			font_input.addEventListener(Event.CHANGE, selectionHandler);
			//font_add_bt.addEventListener(MouseEvent.CLICK, addNewFont);uploadFile.php
			up_font = new UploadFont(font_add_bt, font_input, 'https://clients.crown.fr/TVCrown/content/json_editor/jsonEditor_fontsUpdate.php', selectFont.tf);
			
			
			
			
			font_erase_bt.addEventListener(MouseEvent.CLICK, eraseNewFont);
			bt_refresh.addEventListener(MouseEvent.CLICK, refreshFonts);
			javafonts.addEventListener('FONTS_READY', activateList);
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			open.addEventListener(MouseEvent.CLICK, openData);
			text_type.x = 16;
			text_type.y = 46;
			//text_type.infos_styles.bg.alpha = 0;
			text_type.infos_styles.addEventListener(MouseEvent.ROLL_OVER, textsEffectsHandler);
			text_type.infos_styles.addEventListener(MouseEvent.ROLL_OUT, textsEffectsHandler);
			calc_entry.addEventListener(FocusEvent.FOCUS_IN, calcFocusHandler);
			calc_entry.selectable = true;
			limitToNumChars(calc_entry);
			calc.addEventListener(MouseEvent.CLICK, convertNumbers);
			photo_type.x = 16;
			photo_type.y = 46;
			for (var mc:int = 0; mc < text_type.numChildren; mc ++)
			{
				//trace ('*** mc : ' + mc + ', mc_name: ' + text_type.getChildAt(mc).name);
				if (text_type.getChildAt(mc).name.substr(0, 2) == 'ti')
				{
					//trace ("----------------------" + text_type.getChildAt(mc) as TextField);
					var tf:TextField = text_type.getChildAt(mc) as TextField;
					text_inputs.push(text_type.getChildAt(mc));
					//tf.alwaysShowSelection = true;
					tf.addEventListener(FocusEvent.FOCUS_IN, startFocus);
					tf.addEventListener(FocusEvent.FOCUS_OUT, capture);
					tf.background = true;
					tf.backgroundColor = 0x77BBFF;
					
					if (tf.name == 'ti_posx' || tf.name == 'ti_posy' || tf.name == 'ti_width' || tf.name == 'ti_height' || tf.name == 'ti_fontsize' || tf.name == 'ti_height')
					{
						limitToNumChars(tf);
					}
					
					if (tf.name.substr(0, 6) == 'ti_app' || tf.name.substr(0, 6) == 'ti_dis')
					{
						trace (tf.name.substr(0, 6));
						trace (tf.name.substr(tf.name.length - 4, 4));
						if (tf.name.substr(tf.name.length - 4, 4) != 'type')
						{
							tf.restrict = "0-9\.\|\\-";
						}
					}
					
					if (tf.name == 'ti_color')
					{
						tf.restrict = "A-F\0-9\#";
					}
					//text_type.getChildAt(mc).tabEnabled = true;
				}
				
				if (text_type.getChildAt(mc).name.substr(0, 6) == "select")
				{
					var clip:MovieClip = text_type.getChildAt(mc) as MovieClip;
					clip.addEventListener(MouseEvent.CLICK, menuDeroulant);
				}
				
				if (text_type.getChildAt(mc).name.substr(0, 5) == "zoom_")
				{
					var zoom:MovieClip = text_type.getChildAt(mc) as MovieClip;
					zoom.addEventListener(MouseEvent.ROLL_OVER, zoomHandler);
					zoom.addEventListener(MouseEvent.ROLL_OUT, zoomHandler);
				}
				
			}
			
			for (var pic:int = 0; pic < photo_type.numChildren; pic ++)
			{
				//trace ('*** mc : ' + mc + ', mc_name: ' + text_type.getChildAt(mc).name);
				if (photo_type.getChildAt(pic).name.substr(0, 2) == 'ti')
				{
					var tfphoto:TextField = photo_type.getChildAt(pic) as TextField;
					photo_inputs.push(photo_type.getChildAt(pic));
					tfphoto.text = "";
					tfphoto.background = true;
					tfphoto.backgroundColor = 0x77BBFF;
					tfphoto.addEventListener(FocusEvent.FOCUS_OUT, capture);
					tfphoto.addEventListener(FocusEvent.FOCUS_IN, startFocus);
					//text_type.getChildAt(mc).tabEnabled = true;
				}
				
				
				if (photo_type.getChildAt(pic).name.substr(0, 6) == "select")
				{
					var deroul:MovieClip = photo_type.getChildAt(pic) as MovieClip;
					deroul.addEventListener(MouseEvent.CLICK, menuDeroulant);
				}
				
				if (photo_type.getChildAt(pic).name.substr(0, 5) == "zoom_")
				{
					var zoompic:MovieClip = photo_type.getChildAt(pic) as MovieClip;
					zoompic.addEventListener(MouseEvent.ROLL_OVER, zoomHandler);
					zoompic.addEventListener(MouseEvent.ROLL_OUT, zoomHandler);
				}
				
			}
			photo_type.reg.addEventListener(MouseEvent.CLICK, storePhoto);
			text_type.reg.addEventListener(MouseEvent.CLICK, storeText);
			sv.addEventListener(MouseEvent.CLICK, saveFile);
			addText.addEventListener(MouseEvent.CLICK, windowHandler);
			addPic.addEventListener(MouseEvent.CLICK, windowHandler);
			//age.addEventListener(Event.ENTER_FRAME, focusHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, tabFocus);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, shortCuts);
		
		}
		
		/**
		 * Detection de la touche Ctrl enfoncée
		 * @param evt : KeyboardEvent -> événements liés au clavier
		 * @author Morphelin
		 */
		private function shortCuts(evt:KeyboardEvent):void
		{
			if (evt.keyCode == 17)
			{
				ctrl = true;
			}
			
		}
		
		/**
		 * Ouverture de fichier : création du filereference eto uverture de l'explorateur
		 * @param evt : Mouseevent = null -> événement liés à la souris / faculatif
		 * @author Morphelin
		 */
		private function openData(evt:MouseEvent = null):void
		{
			json = new FileReference();
			json.addEventListener(Event.SELECT, onFileSelected);	
			json.browse();
		}
		
		/**
		 * Ouverture de fichier : fichier selectionné, Chargement du fichier, on stocke le nom du fichier et on l'affiche
		 * @param evt : Event -> événements
		 * @author Morphelin
		 */
		private function onFileSelected(evt:Event):void
		{
			evt.target.removeEventListener(Event.SELECT, onFileSelected);	
			//trace ('---------------------------' + evt.target.name + ' loaded');
			filename = evt.target.name;
			fileOpened.htmlText = '<p> <font color="#666666">File : </font>' + '<font color="#0066CC">' + filename + '</font>' + '</p>';
			json.addEventListener(Event.COMPLETE, onFileLoaded);
			json.load();
		}
		
		/**
		 * Ouverture de fichier : Fichier chargé on traite les données
		 * @param evt : Event -> événements
		 * @author Morphelin
		 */
		private function onFileLoaded(evt:Event):void
		{
			evt.target.removeEventListener(Event.COMPLETE, onFileSelected);	
			jsonDataLoaded = evt.target.data;
			//trace ('jsonDataLoaded : ' + jsonDataLoaded);
			traitement(jsonDataLoaded);
		}
		
		/**
		 * Ouverture de fichier : Traitement des donnés par la classe JsonParser méthode parseJ
		 * @param data:String -> données recues ( filereference.data )
		 * @author Morphelin
		 */
		private function traitement(data:String):void
		{
			
			//private var loadedInfos:Array;
			//private var nbTextsLoaded:int;
			//private var nbPhotosLoaded:int;
			loadedInfos = JsonParser.parseJ(data,16+photo_moreparams.menu.length, 20+ texte_moreparams.menu.length,separation);
			trace ('infos parsées nombre de balises textes : ' + loadedInfos['textes'].length);
			
			nbTextsLoaded = loadedInfos['textes'].length;
			nbPhotosLoaded =  loadedInfos['photos'].length;
			savedDatas = new Array();
			tmpNames = new Array();
			tmpphotoName = new Array();
			balisesPhotosSaved = new Array();
			balisesTextSaved = new Array();
			positionsBlocs = new Array();
			blocs = new Array();
			nbBlocs = 0;
			
			while ( liste.numChildren > 0)
			{
				liste.removeChildAt(0);
			}
			trace ('nbTextsLoaded : ' + nbTextsLoaded + '\nnbPhotosLoaded :' +nbPhotosLoaded);
			for (var txt:int = 0; txt < nbTextsLoaded; txt ++)
			{
				trace ('txt : ' + txt );
				trace("loadedInfos['textes'] " +loadedInfos['textes'].length);
				trace("loadedInfos['textes'][0]['posx'] " +loadedInfos['textes'][0]['posx']);
				var tmp_name:String = loadedInfos['textes'][txt]['name'].split('java_').join('');
				tmp_name = tmp_name.split('_settings').join('');
				Fname = tmp_name;
				savedDatas[tmp_name] = new Array();
				
				savedDatas[tmp_name] ['ti_name'] = tmp_name;
				savedDatas[tmp_name] ['ti_posx'] = loadedInfos['textes'][txt]['posx'];
				savedDatas[tmp_name] ['ti_posy'] = loadedInfos['textes'][txt]['posy'];
				savedDatas[tmp_name] ['ti_width'] = loadedInfos['textes'][txt]['width'];
				savedDatas[tmp_name] ['ti_height'] = loadedInfos['textes'][txt]['height'];
				savedDatas[tmp_name] ['ti_fontsize'] = loadedInfos['textes'][txt]['fontsize'];
				savedDatas[tmp_name] ['ti_font'] = loadedInfos['textes'][txt]['police'];
				savedDatas[tmp_name] ['ti_color'] = loadedInfos['textes'][txt]['color'];
				savedDatas[tmp_name] ['ti_effect'] = loadedInfos['textes'][txt]['effect'];
				savedDatas[tmp_name] ['ti_app_type'] = loadedInfos['textes'][txt]['animation_apparition_type'];
				savedDatas[tmp_name] ['ti_app_duration'] = loadedInfos['textes'][txt]['animation_apparition_duration'];
				savedDatas[tmp_name] ['ti_app_delay'] = loadedInfos['textes'][txt]['animation_apparition_startDelay'];
				savedDatas[tmp_name] ['ti_app_debut'] = loadedInfos['textes'][txt]['animation_apparition_debut'];
				savedDatas[tmp_name] ['ti_app_fin'] = loadedInfos['textes'][txt]['animation_apparition_fin'];
				savedDatas[tmp_name] ['ti_disp_type'] = loadedInfos['textes'][txt]['animation_disparition_type'];
				savedDatas[tmp_name] ['ti_disp_duration'] = loadedInfos['textes'][txt]['animation_disparition_duration'];
				savedDatas[tmp_name] ['ti_disp_delay'] = loadedInfos['textes'][txt]['animation_disparition_startDelay'];
				savedDatas[tmp_name] ['ti_disp_debut'] = loadedInfos['textes'][txt]['animation_disparition_debut'];
				savedDatas[tmp_name] ['ti_disp_fin'] = loadedInfos['textes'][txt]['animation_disparition_fin'];
				savedDatas[tmp_name] ['ti_default_value'] = loadedInfos['textes'][txt]['valeur_par_defaut'];
				
				if (texte_moreparams.menu.length > 0)
				{
					for (var nb_txt_params:int = 0; nb_txt_params <= texte_moreparams.menu.length -1; nb_txt_params++)
					{
						savedDatas[tmp_name][texte_moreparams.menu[nb_txt_params]['name']] = loadedInfos['textes'][txt][texte_moreparams.menu[nb_txt_params]['name'].split('ti_').join('')];
					}
				}
				
				savedDatas[tmp_name]['type'] = 'text';
				constructText(tmp_name);
				textCounter++;
				//addBloc(tmp_name); 2297 2300 2633
			}
			
			for (var pic:int = 0; pic < nbPhotosLoaded; pic ++)
			{
				
				var tmp_name_p:String = loadedInfos['photos'][pic]['name'].split('java_').join('');
				tmp_name_p = tmp_name_p.split('_settings').join('');
				Fname = tmp_name_p;
				
				savedDatas[tmp_name_p] = new Array();
				
				savedDatas[tmp_name_p] ['ti_name'] = tmp_name_p;
				savedDatas[tmp_name_p] ['ti_posx'] = loadedInfos['photos'][pic]['posx'];
				savedDatas[tmp_name_p] ['ti_posy'] = loadedInfos['photos'][pic]['posy'];
				savedDatas[tmp_name_p] ['ti_width'] = loadedInfos['photos'][pic]['width'];
				savedDatas[tmp_name_p] ['ti_height'] = loadedInfos['photos'][pic]['height'];
				savedDatas[tmp_name_p] ['ti_fontsize'] = loadedInfos['photos'][pic]['fontsize'];
				savedDatas[tmp_name_p] ['ti_font'] = loadedInfos['photos'][pic]['police'];
				savedDatas[tmp_name_p] ['ti_color'] = loadedInfos['photos'][pic]['color'];
				savedDatas[tmp_name_p] ['ti_effect'] = loadedInfos['photos'][pic]['effect'];
				savedDatas[tmp_name_p] ['ti_app_type'] = loadedInfos['photos'][pic]['animation_apparition_type'];
				savedDatas[tmp_name_p] ['ti_app_duration'] = loadedInfos['photos'][pic]['animation_apparition_duration'];
				savedDatas[tmp_name_p] ['ti_app_delay'] = loadedInfos['photos'][pic]['animation_apparition_startDelay'];
				savedDatas[tmp_name_p] ['ti_app_debut'] = loadedInfos['photos'][pic]['animation_apparition_debut'];
				savedDatas[tmp_name_p] ['ti_app_fin'] = loadedInfos['photos'][pic]['animation_apparition_fin'];
				savedDatas[tmp_name_p] ['ti_disp_type'] = loadedInfos['photos'][pic]['animation_disparition_type'];
				savedDatas[tmp_name_p] ['ti_disp_duration'] = loadedInfos['photos'][pic]['animation_disparition_duration'];
				savedDatas[tmp_name_p] ['ti_disp_delay'] = loadedInfos['photos'][pic]['animation_disparition_startDelay'];
				savedDatas[tmp_name_p] ['ti_disp_debut'] = loadedInfos['photos'][pic]['animation_disparition_debut'];
				savedDatas[tmp_name_p] ['ti_disp_fin'] = loadedInfos['photos'][pic]['animation_disparition_fin'];
				savedDatas[tmp_name_p] ['ti_image_crop_type'] = loadedInfos['photos'][pic]['image_crop_type'];
				
				if (photo_moreparams.menu.length > 0)
				{
					for (var nb_pho_params:int = 0; nb_pho_params <= photo_moreparams.menu.length -1; nb_pho_params++)
					{
						savedDatas[tmp_name_p][photo_moreparams.menu[nb_pho_params]['name']] = loadedInfos['photos'][pic][photo_moreparams.menu[nb_pho_params]['name'].split('ti_').join('')];
					}
				}
				
				savedDatas[tmp_name_p]['type'] = 'photo';
				constructPhoto(tmp_name_p);
				photoCounter++;
				//addBloc(tmp_name_p);
			}
			
			
			
			//jsonObject = new JSON();
			//var tmp_json:Array = data.split(
			//jsonObject.parse(data);
		}
		
		/**
		 * Sauvegarde : On stocke dans les tableaux de données de textes et photos
		 * @param s:String -> données à sauvegarder
		 * @param type:String -> type de données à sauvegarder 'text' ou 'photo'
		 * @param name:String -> Nom de champ texte ou photo qui sert de comparatif ( si il est déjà présent dans un des tableaux de données on ne rajoute pas une nouvelle cellule de données mais on la met à jour
		 * @author Morphelin
		 */
		private function saveStrings(s:String, type:String,name:String):void
		{
			indexBalises.push(nbBalises);
			nbBalises++;
			trace ('[saveStrings] : ' + s + '/ ' + type + '/ ' + name);
			var pic_allowed:Boolean = true;
			var allowed:Boolean = true;
			
			if (type == 'text')
			{
				//trace ('constr text name : ' + name + 'tmpNames: ' + tmpNames);
				var field:String = '';
				if (tmpNames.length > 0)
				{
					for (var nameCheck:int = 0; nameCheck < tmpNames.length; nameCheck++)
					{
						if (tmpNames[nameCheck] == name)
						{
							//tmpNames.push(name);
							allowed = false;
							balisesTextSaved[nameCheck] = s;
							//addBloc();
						}
					}
				} else
				{	
					allowed = true;
				
				}
				//trace ('construc text tmpNames : ' + tmpNames + ', longueur : ' + tmpNames.length);
				
				if (allowed)
				{
					tmpNames.push(name);
					/*if (tmpNames.length > 1)
					{
						s = ',\n' + s;
					}*/
					balisesTextSaved.push(s);
					addBloc(name);
				}
			}
			
			if (type == 'photo')
			{
				trace ('[saveStrings] : MEMORISING PHOTO DATAS');
				if (tmpphotoName.length > 0)
				{
					for (var nameToCheck:int = 0; nameToCheck < tmpphotoName.length; nameToCheck++)
					{
						if (tmpphotoName[nameToCheck] == name)
						{
							pic_allowed = false;
							balisesPhotosSaved[nameToCheck] = s;
						}
					}
				} else
				{
					pic_allowed = true;
				}
				//trace ('construc text tmpNames : ' + tmpphotoName + ', longueur : ' + tmpphotoName.length);
				
				if (pic_allowed)
				{
					
					tmpphotoName.push(name);
					/*if (tmpphotoName.length > 1)
					{
						s = ',\n' + s;
					}*/
					balisesPhotosSaved.push(s);
					addBloc(name);
				}
				
				trace ('[saveStrings] : PICALLOWED : ' + pic_allowed);
			
			}
			
			//trace ('String saved : ' + balisesTextSaved + '\n\n' + balisesPhotosSaved);
		}
		
		/**
		 * Choix de type d'animation : Gestion des événements souris des boutons du Menu déroulant
		 * @param evt : MouseEvent -> événements liés à la souris
		 * @author Morphelin
		 */
		private function fillType(evt:MouseEvent):void
		{
			//evt.target.removeEventListener(MouseEvent.CLICK, fillType);
			trace ('fillType target name : ' + evt.target.name);
			var ti_value:String = tmpSelectInput.text;
			ti_value = ti_value.split('\n').join('');
			ti_value = ti_value.split('\r').join('');
			ti_value = ti_value.split('\t').join('');
			
			if (evt.target.name.substr(0, 2) == "e_")
			{
				var value:String = evt.target.name.substr(2, evt.target.name.length);
			//trace ('VALUE : ' + value);
			//trace ('tmpSelectInput : ' + tmpSelectInput.name);
				tmpSelectInput.text = value;
			}
			else
			{
				trace (tmpSelectInput.name + ' value ->' + tmpSelectInput.text + '<-' );
				if (ti_value != '')
				{
					tmpSelectInput.text = ti_value + evt.target.name.split('plus_').join('|');
				}
			}
			stage.focus = tmpSelectInput;
		}
		
		/**
		 * Choix de type d'animation : permet d'afficher la totalité des types d'animation choisis- plus de clarté
		 * @param evt : MouseEvent -> événements liés à la souris
		 * @author Morphelin
		 */
		private function zoomHandler(evt:MouseEvent):void
		{
			
			if (evt.type == MouseEvent.ROLL_OVER)
			{
				stage.focus = stage;
				if (evt.target.name == 'zoom_ti_app_type')
				{
					if (addTextOn)
					{
						tmpSelectInput = text_type.ti_app_type;
						focused = 9;
					}
					else if (addPicOn){
						tmpSelectInput = photo_type.ti_app_type;
						focused = 5;
					}
				}
				
				else if (evt.target.name == 'zoom_ti_disp_type')
				{
					if (addTextOn)
					{
						tmpSelectInput = text_type.ti_disp_type;
						focused = 14;
					}
					else if (addPicOn){
						tmpSelectInput = photo_type.ti_disp_type;
						focused = 10;
					}
				}
				
				
			var ti_value:String = tmpSelectInput.text;
			ti_value = ti_value.split('\n').join('');
			ti_value = ti_value.split('\r').join('');
			ti_value = ti_value.split('\t').join('');
				
				if (ti_value != '')
				{
					evt.target.gotoAndStop(2);
					var tf:TextField = evt.target.tf as TextField;
					tf.text = ti_value.split('|').join('|\n');
					tf.autoSize = 'left';
					//tf.wordWrap = true;
					evt.target.bg.height = tf.textHeight*2;
				}
				
				
			}
			else
			{
				evt.target.gotoAndStop(1);
			}
		}
		
		/**
		 * Choix de type d'animation : Affiche le menu déroulant et gère les événements souris du Menu déroulant
		 * @param evt : MouseEvent -> événements liés à la souris
		 * @author Morphelin
		 */
		private function menuDeroulant(evt:MouseEvent):void
		{
			evt.target.gotoAndStop(2);
			if (evt.target.name == 'selectApp')
			{
				if (addTextOn)
				{
					tmpSelectInput = text_type.ti_app_type;
					focused = 9;
				}
				else if (addPicOn){
					tmpSelectInput = photo_type.ti_app_type;
					focused = 5;
				}
			}
			
			else if (evt.target.name == 'selectDisp')
			{
				if (addTextOn)
				{
					tmpSelectInput = text_type.ti_disp_type;
					focused = 14;
				}
				else if (addPicOn){
					tmpSelectInput = photo_type.ti_disp_type;
					focused = 10;
				}
			}
			for (var bt:int = 0; bt < evt.target.numChildren; bt ++ )
			{
				if (evt.target.getChildAt(bt).name.substr(0, 2) == "e_")
				{
					//trace ('----+++BT : '  + evt.target.getChildAt(bt).name);
					var mc:MovieClip = evt.target.getChildAt(bt) as MovieClip;
					//tmpSelect = mc.name;
					mc.addEventListener(MouseEvent.CLICK, fillType);						
					
				}
				
				if (evt.target.getChildAt(bt).name.substr(0, 5) == "plus_")
				{
					//trace ('----+++BT : '  + evt.target.getChildAt(bt).name);
					var plus:MovieClip = evt.target.getChildAt(bt) as MovieClip;
					//tmpSelect = mc.name;
					plus.addEventListener(MouseEvent.CLICK, fillType);						
					
				}
			}
			evt.target.addEventListener(MouseEvent.ROLL_OUT, exitSelect);
		}
		
		/**
		 * Choix de type d'animation : Masque le menu déroulant
		 * @param evt : MouseEvent -> événements liés à la souris
		 * @author Morphelin
		 */
		private function exitSelect(evt:MouseEvent):void
		{
			evt.target.removeEventListener(MouseEvent.ROLL_OUT, exitSelect);
			for (var bt:int = 0; bt < evt.target.numChildren; bt ++ )
			{
				if (evt.target.getChildAt(bt).name.substr(0, 2) == "e_")
				{
					//trace ('----+++BT : '  + evt.target.getChildAt(bt).name);
					var mc:MovieClip = evt.target.getChildAt(bt) as MovieClip;
					//tmpSelect = mc.name;
					mc.removeEventListener(MouseEvent.CLICK, fillType);						
					
				}
			}
			evt.target.gotoAndStop(1);
		}
		
		/**
		 * Edition de styles/effets : Gestion des événements sur les champs text input du menu d'edition de styles
		 * @param evt : Event -> événements
		 * @author Morphelin
		 */
		private function focusHandler(evt:Event):void
		{
			if (evt.type == 'focusIn' )
			{
				trace (evt.target.text);
				if (clean(evt.target.text) == "Name" || clean(evt.target.text) == "css: [value]") {
				evt.target.text = "";
				}
			}
			else
			{
				if (evt.target.text == "")
				{
					if (evt.target.name == "cssName_input")
					{
						evt.target.text = "Name";
					}
					else
					{
						evt.target.text = "css: [value]";
					}
				}
			}
		}
		
		/**
		 * Gestion de tous les raccourcis clavier
		 * @param key:KeyboardEvent -> énénements liés au clavier
		 * @author Morphelin
		 */
		private function tabFocus(key:KeyboardEvent):void
		{
			trace (key.keyCode + ' pressed ' );
			var padding:int = 9;
			
			if (key.keyCode == 79) // open ctrl + o
			{
				if (ctrl)
				{
					openData();
				}
			}
			
			if (key.keyCode == 17)
			{
				ctrl = false;
			}
			
			if (key.keyCode == 13)
			{
				if (ctrl)
				{
					if (addTextOn) {
						storeText();
						ctrl = false;
					}
					else if (addPicOn)
					{
						storePhoto();
						ctrl = false;
					}
				}
			}
			
			if (key.keyCode == 83)
			{
				if (ctrl)
				{
					saveFile();
					
					
				}
			}
			
			if (key.keyCode ==  40 && ctrl)
			{
				if (focused < text_inputs.length)
				{
					focused ++;
				}
				else
				{
					focused = 0;
				}
				//trace ('tab pressed');
				
				stage.focus = (addTextOn) ? text_inputs[focused - 1]:photo_inputs[focused - 1];
				
			}
			
			if (key.keyCode ==  38 && ctrl)
			{
				if (focused > 1)
				{
					focused --;
				}
				else
				{
					focused = text_inputs.length;
				}
				//trace ('tab pressed');
				stage.focus = (addTextOn) ? text_inputs[focused - 1]:photo_inputs[focused - 1];
				
			}
			
			if (addTextOn) {
				padding = 9;
			}
			else {
				padding = 5;
			}
			
			if (key.keyCode ==  39 && ctrl)
			{
				if (focused < text_inputs.length-padding)
				{
					focused += padding;
				}
				else
				{
					focused -=padding;
				}
				//trace ('tab pressed');
				stage.focus = (addTextOn) ? text_inputs[focused - 1]:photo_inputs[focused - 1];
					
			}
			
			if (key.keyCode ==  37 && ctrl)
			{
				if (focused > padding)
				{
					focused -=padding;
				}
				else
				{
					focused +=padding;
				}
				//trace ('tab pressed');
				stage.focus = (addTextOn) ? text_inputs[focused - 1]:photo_inputs[focused - 1];
				
			}
		}
		
		/**
		 * Navigation avec ctrl + fleche : récupere les index des champs qui ont le focus
		 * @param evt:FocusEvent -> événement liés au focus de text input
		 * @author Morphelin
		 */
		private function startFocus(evt:FocusEvent):void
		{
			/*if (focused < text_inputs.length - 1)
			{
				focused++;
			}
			else
			{
				focused = 0;
			}*/
			//evt.target.drawFocus = true;
			
			evt.target.background = false;
			//trace (evt.target.name + 'focused');
			switch (evt.target.name) {
			
				case "ti_name" :
					focused = 1 ;
				break;
				case "ti_posx" :
					focused = 2 ;
				break;
				case "ti_posy" :
					focused = 3 ;
				break;
				case "ti_width" :
					focused = 4 ;
				break;
				case "ti_height" :
					focused = 5 ;
				break;
				case "ti_fontsize" :
					focused = (addTextOn)? 6:5;
				break;
				case "ti_font" :
					focused = (addTextOn)? 7:5;
				break;
				case "ti_color" :
					focused = (addTextOn)? 8:5;
				break;
				case "ti_effect" :
					focused = (addTextOn)? 9:5;
				break;
				case "ti_app_type" :
					focused = (addTextOn)? 10:6;
				break;
				case "ti_app_duration" :
					focused = (addTextOn)? 12:8;
				break;
				case "ti_app_delay" :
					focused = (addTextOn)? 11:7;
				break;
				case "ti_app_debut" :
					focused = (addTextOn)? 13:9;
				break;
				case "ti_app_fin" :
					focused = (addTextOn)? 14:10;
				break;
				case "ti_disp_type" :
					focused = (addTextOn)? 15:12;
				break;
				case "ti_disp_duration" :
					focused = (addTextOn)? 17:14;
				break;
				case "ti_disp_delay" :
					focused = (addTextOn)? 16:13;
				break;
				case "ti_disp_debut" :
					focused = (addTextOn)? 18:15;
				break;
				case "ti_disp_fin" :
					focused = (addTextOn)? 19:16;
				break;	
				case "ti_default_value" :
					focused = (addTextOn)? 20:17;
				break;	
				case "ti_image_crop_type":
					focused = 11;
				break;
				
			}
		}
		
		/**
		 * Fonction en cours inutilisée prévue pour effacer les données saisies et / ou chargées
		 * @author Morphelin
		 */
		function resetAll():void
		{
			//text_inputs = new Array();
			
			for (var mc:int = 0; mc < text_type.numChildren; mc ++)
			{
				//trace ('*** mc : ' + mc + ', mc_name: ' + text_type.getChildAt(mc).name);
				if (text_type.getChildAt(mc).name.substr(0, 2) == 'ti')
				{
					var tf:TextField = text_type.getChildAt(mc) as TextField;
					tf.text = "";
					tf.background = true;
					tf.backgroundColor = 0x77BBFF;
					//text_type.getChildAt(mc).tabEnabled = true;
				}
				
			}
			
			for (var pic:int = 0; pic < photo_type.numChildren; pic ++)
			{
				//trace ('*** mc : ' + mc + ', mc_name: ' + text_type.getChildAt(mc).name);
				if (photo_type.getChildAt(pic).name.substr(0, 2) == 'ti')
				{
					var tfphoto:TextField = photo_type.getChildAt(pic) as TextField;
					tfphoto.text = "";
					tfphoto.background = true;
					tfphoto.backgroundColor =  0x77BBFF;
					//text_type.getChildAt(mc).tabEnabled = true;
				}
				
			}
		}
		
		/**
		 * Architecture : fonction qui supprime de l'architecture une balise json ( texte1, titre , photo1, etc ... )
		 * @param evt:MouseEvent -> énénements liés à la souris
		 * @author Morphelin
		 */
		private function removeCell(evt:MouseEvent):void
		{
			var target:String = evt.target.name.split('close_').join('');
			
			trace ('REMOVING ' + target + ' DATAS');
			
			//liste.removeChild(evt.target);
			for (var clip:int = 0; clip < liste.numChildren; clip ++)
			{
			if (liste.getChildAt(clip).name == target)
				{
					liste.getChildAt(clip).removeEventListener(MouseEvent.CLICK, loadDatas);
					liste.removeChild(liste.getChildAt(clip));
				} 
			}	
			
			for (var bloc:int = 0; bloc < liste.numChildren; bloc ++)
			{
				
				if (liste.getChildAt(bloc).name == evt.target.name)
				{
					liste.getChildAt(bloc).removeEventListener(MouseEvent.CLICK, removeCell);
					liste.removeChild(liste.getChildAt(bloc));
				}
			}
			removeData(target);
			//nbBlocs --;
		}
		
		/**
		 * Architecture : fonction qui replace les balises json ( texte1, titre , photo1, etc ... ) après une suppression
		 * @author Morphelin
		 */
		private function moveBlocs():void
		{
			//!nbBlocs --;
			for (var bloc:int = 0; bloc < blocs.length; bloc ++)
			{
				blocs[bloc][0].y = positionsBlocs[bloc][1];
				blocs[bloc][1].y = positionsBlocs[bloc][3]; 
			}
		}
		
		/**
		 * Architecture : fonction qui efface les données stockées d'une balise json préalablement supprimée et replace les balises
		 * @param name:String-> Nom de la balise qui sert d'identifiant de cellule à supprimer dans le tableau qui contient les données à effacer
		 * @author Morphelin
		 */
		private function removeData(name:String):void
		{
			var type:String = savedDatas[name]['type'];
			var indexText:int;
			var indexPhoto:int;
			
			trace ('1. blocs length : ' + blocs.length);
			for (var h:int = 0; h < blocs.length; h++)
			{
				trace ('bloc name : ' + blocs[h][0].name);
				
				if (blocs[h][0].name == name)
				{
					blocs = deleteArrayCell(blocs, h);
				}
			}
			
			trace ('2. blocs length : ' + blocs.length);
			
			if (type == 'text')
			{
				for (var i:int = 0; i < tmpNames.length; i++ )
				{
					if (tmpNames[i] == name)
					{
						tmpNames = deleteArrayCell(tmpNames, i);
						balisesTextSaved = deleteArrayCell(balisesTextSaved, i);
					
					}
				}
			}
			
			if (type == 'photo')
			{
				for (var j:int = 0; j < tmpphotoName.length; j++ )
				{
					if (tmpphotoName[j] == name)
					{
						tmpphotoName = deleteArrayCell(tmpphotoName, j);
						balisesPhotosSaved = deleteArrayCell(balisesPhotosSaved, j);
					}
				}
			}
			trace ('tmpNames : ' + tmpNames);
			moveBlocs();
		}
		
		/**
		 * Publique : permet de retirer une cellule d'un tableau à partir de l'index de la cellue
		 * @param a:Array -> tableau concerné
		 * @param index:int -> index de la cellule à supprimer
		 * @return Array -> renvoie le tableau a sans la cellule
		 * @author Morphelin
		 */
		public function deleteArrayCell(a:Array, index:int):Array
		{
			var b:Array = new Array();
			//trace ('DElete cell : ' + index + 'from array' + a );
			for (var k:int = 0; k < a.length; k++)
			{
				if ( k != index)
				{
					b.push(a[k]);
				}
			}
			//trace ('cell removed : ' + b);
			return b;
			
		}
		
		/**
		 * Architecture : fonction qui ajoute une balise json ( texte1, titre , photo1, etc ... ) à droite du formulaire dans l'espace réservé à l'architecture du fichier json
		 * @param _name:String = "" -> nom de la balise
		 * @return Sprite -> un objet d'affichage (displayObject ) de type sprite
		 * @author Morphelin
		 */
		private function addBloc(_name:String = ""):Sprite
		{
			
			nbBlocs = blocs.length;
			var blocAllowed:Boolean = true;
			var fermer:MovieClip = new MovieClip();
			var rond:Shape = new Shape();
			rond.graphics.beginFill(0xFF0C00);
			rond.graphics.drawCircle(0, 0, 6);
			rond.graphics.endFill();
			fermer.addChild(rond);			
			var moins:Shape = new Shape();
			moins.graphics.lineStyle(2, 0xFFFFFF);
			moins.graphics.moveTo(-2, 0);
			moins.graphics.lineTo(2, 0);
			fermer.addChild(moins);
			
			var format:TextFormat = new TextFormat();
			var police:Police1 = new Police1();
			format.font = police.fontName;
			format.color = 0x413D50;
			format.align = "center";
			format.size = 10;
			var bloc:Sprite = new Sprite();
			var shape:Shape = new Shape();
			shape.graphics.beginFill(0xFFFFFF, 1);
			shape.graphics.lineStyle(1, 0x666666);
			shape.graphics.drawRoundRect(0, 0, 60, 10, 4, 4);
			shape.graphics.endFill();
			var tf:TextField = new TextField();
			tf.selectable = false;
			tf.mouseEnabled = false;
			tf.width = shape.width;
			tf.y = -3;
			tf.height = 20;
			tf.defaultTextFormat = format;
			
				tf.text = Fname;

			bloc.addChild(shape);
			bloc.addChild(tf);
			//bloc.addChild(fermer)
			liste.addChild(bloc);
			liste.addChild(fermer);
			trace ('BLOCS : ' + blocs.length + '/ nbBloc : ' + nbBlocs);
			bloc.x = 2;
			bloc.y = 5 + bloc.height * nbBlocs*.6;
			fermer.x = bloc.x + bloc.width -3;
			fermer.y = bloc.y+fermer.width-7;
			bloc.name = tf.text;
			fermer.name = 'close_' + Fname;
			bloc.addEventListener(MouseEvent.CLICK, loadDatas);
			fermer.addEventListener(MouseEvent.CLICK, removeCell);
			if (positionsBlocs.length > 0)
			{
				for (var check:int = 0; check < positionsBlocs.length; check ++)
				{
					trace ('checking bloc posy : ' + positionsBlocs[check][1] + '==' + bloc.y);
					if (positionsBlocs[check][1] == bloc.y)
					{
						trace ('no bloc allowed');
						blocAllowed = false;
						//positionsBlocs = deleteArrayCell(positionsBlocs,check);
					}
				}
			}
			else
			{
				blocAllowed = true;
			}
			
		
			
			if (blocAllowed)
			{
				positionsBlocs.push(new Array(bloc.x, bloc.y, fermer.x, fermer.y));
			}			
			blocs.push(new Array(bloc, fermer));
			//nbBlocs ++;
			return(bloc);
			
		}
		
		/**
		 * Architecture : chargement des données quand on clique sur une balise json de l'architecture
		 * @param evt:MouseEvent -> événements liés à la souris
		 * @author Morphelin
		 */
		private function loadDatas(evt:MouseEvent):void
		{
			//trace ('loading datas for bloc : ' + evt.target.name);
			
			/*trace ('name : ' + savedDatas[evt.target.name]['ti_name']);
			trace ('police : ' + savedDatas[evt.target.name]['ti_font']);
			trace ('type : ' + savedDatas[evt.target.name]['type']);*/
			editMode = true;
			var cible:String = evt.target.name;
			if (savedDatas[cible]['type'] == 'photo')
			{
				if (!stage.contains(photo_type)) {
					if ( stage.contains(text_type) )
					{
						stage.removeChild(text_type);
					}
					stage.addChild(photo_type);
					addPicOn = true;
					addTextOn = false;
				}
				
				for (var pInt:int = 0; pInt < photo_type.numChildren; pInt ++) //->ICI------------------------
				{
					if (photo_type.getChildAt(pInt).name.substr(0, 2) == 'ti')
					{
						var tmpTF:TextField = photo_type.getChildAt(pInt) as TextField;
						tmpTF.text = blankMe(savedDatas[cible][tmpTF.name]);
					}
				}
				photo_moreparams.show();
				texte_moreparams.erase();
			}
			else
			{
				if (!stage.contains(text_type)) {
					//trace ('mode text : stage doest not contains text_type');
					if ( stage.contains(photo_type) )
					{
						//trace ('mode text : stage contains photo_type');
						stage.removeChild(photo_type);
					}
					stage.addChild(text_type);
					addPicOn = false;
					addTextOn = true;
				}
				
				for (var tInt:int = 0; tInt < text_type.numChildren; tInt ++)
				{
					
					if (text_type.getChildAt(tInt).name.substr(0, 2) == 'ti')
					{
						var tmpTf:TextField = text_type.getChildAt(tInt) as TextField;
						//trace (tmpTf.name + '<----------------------')
						tmpTf.text = blankMe(String(savedDatas[cible][tmpTf.name]));
					}
				}
				
				// on charge aussi les données stockées dans les parametres dynamiques
				if (texte_moreparams.menu.length >0){
					for ( var tPar:int = 0; tPar <= texte_moreparams.menu.length -1; tPar ++) {
						var tmpTfPar:TextField = texte_moreparams.menu[tPar]['input'] as TextField;
						
						tmpTfPar.text = blankMe(String(savedDatas[cible][texte_moreparams.menu[tPar]['name']]));
					}
				}
				texte_moreparams.show();
				photo_moreparams.erase();
				// on charge aussi les données stockées dans les parametres dynamiques
				if (photo_moreparams.menu.length >0){
					for ( var tpicar:int = 0; tpicar <= photo_moreparams.menu.length -1; tpicar ++) {
						var tmpTfphoPar:TextField = photo_moreparams.menu[tpicar]['input'] as TextField;
						
						tmpTfphoPar.text = blankMe(String(savedDatas[cible][photo_moreparams.menu[tpicar]['name']]));
					}
				}
			}
			
		}
		
		
		/**
		 * Nettoie une chaine des sauts de ligne indésirables et renvoie une chaine vide si la chaine passée en parametre n'existe pas ( donc du type undefined )
		 * @param s:String -> chaine de caracteres
		 * @return s:String -> chaine purgée
		 * @author Morphelin
		 */
		private function blankMe(s:String):String
		{
			s = s.split('\n').join('');
			s = s.split('\r').join('');	
			
			if (s == "undefined")
			{
				s = "";
			}
			
			return s;
		}
		
		/**
		 * Navigation : Gestion de l'affichage du menu d'edition de textes ou photos
		 * @param evt:Mouseevent -> événements liés à la souris
		 * @author Morphelin
		 */
		private function windowHandler(evt:MouseEvent):void
		{
			//trace (evt.target.name + 'cliqued' + ' textCounter : ' + textCounter);
			switch (evt.target.name)
			{
				case 'addText':
					addTextOn = true;
					texte_moreparams.show();
					photo_moreparams.erase();
					//resetText();
					hide(photo_type);	
					addText.alpha = 1;
					addPic.alpha = 0.3;
					//trace ('- addTextOn : ' + addTextOn);
					if (addPicOn) addPicOn = false;
					show(text_type);
					
					//setChildIndex(text_type, this.numChildren - 1);
					
					
						text_type.reg.alpha = 1;
					
					break;
				case 'addPic':
					photo_moreparams.show();
					texte_moreparams.erase();
					addText.alpha = 0.3;
					addPic.alpha = 1;
					if (addTextOn) addTextOn =false;
					addPicOn = true;
					//resetPhoto();
					hide(text_type);	
					show(photo_type);
					//setChildIndex(photo_type, this.numChildren - 1);
					photo_type.reg.alpha = 1;
					//photo_type.reg.addEventListener(MouseEvent.CLICK, storePhoto);
					
					break;
			}
			//trace ('addTextOn : ' + addTextOn);
			//trace ('addPicOn : ' + addPicOn);
		}
		
		/**
		 * Sauvegarde : fonction qui crée une balise json texte en fonction de son nom
		 * @param name:String -> nom de la balise json à créer
		 * @author Morphelin
		 */
		private function constructText(name:String):void
		{			
			var field:String = '';
			trace ('constr : posx, ' + savedDatas[name]['ti_posx'] + 'name : ' + name + '/' + savedDatas[name]['ti_name']);
			field += '{\n\t"name" : "java_' + savedDatas[name]['ti_name'] + '_settings",';
			field += '\n\t"posx" : "' + savedDatas[name]['ti_posx'] + '",';
			field += '\n\t"posy" : "' + savedDatas[name]['ti_posy'] + '",';
			field += '\n\t"width" : "' + savedDatas[name]['ti_width'] + '",';
			field += '\n\t"height" : "' + savedDatas[name]['ti_height'] + '",';
			field += '\n\t"fontsize" : "' + savedDatas[name]['ti_fontsize'] + '",';
			field += '\n\t"police" : "' + savedDatas[name]['ti_font'] + '",';
			field += '\n\t"color" : "' + savedDatas[name]['ti_color'] + '",';
			field += '\n\t"effect" : "' + savedDatas[name]['ti_effect'] + '",';
			field += '\n\t"animation_apparition_type" : "' + savedDatas[name]['ti_app_type'] + '",';
			field += '\n\t"animation_apparition_duration" : "' + savedDatas[name]['ti_app_duration'] + '",';
			field += '\n\t"animation_apparition_startDelay" : "' + savedDatas[name]['ti_app_delay'] + '",';
			field += '\n\t"animation_apparition_debut" : "' + savedDatas[name]['ti_app_debut'] + '",';
			field += '\n\t"animation_apparition_fin" : "' + savedDatas[name]['ti_app_fin'] + '",';
			field += '\n\t"animation_disparition_type" : "' + savedDatas[name]['ti_disp_type'] + '",';
			field += '\n\t"animation_disparition_duration" : "' + savedDatas[name]['ti_disp_duration'] + '",';
			field += '\n\t"animation_disparition_startDelay" : "' + savedDatas[name]['ti_disp_delay'] + '",';
			field += '\n\t"animation_disparition_debut" : "' + savedDatas[name]['ti_disp_debut'] + '",';
			field += '\n\t"animation_disparition_fin" : "' + savedDatas[name]['ti_disp_fin'] + '",';
			field += '\n\t"valeur_par_defaut" : "' + savedDatas[name]['ti_default_value'];
			if (texte_moreparams.menu.length > 0)
			{
					for (var nb_txt_params:int = 0; nb_txt_params <= texte_moreparams.menu.length -1; nb_txt_params++)
					{
						field += '",';
						field += '\n\t"' + texte_moreparams.menu[nb_txt_params]['name'].split('ti_').join('') + '" : "' + savedDatas[name][texte_moreparams.menu[nb_txt_params]['name']];
						if (nb_txt_params == texte_moreparams.menu.length -1)
						{
							field += '"\n}';
						}
					}
			} else
			{
				field += '"\n}';
			}
			trace (field);
			saveStrings(field, 'text',name);
		}
				
		
		/**
		 * Sauvegarde : fonction qui crée une balise json photo en fonction de son nom
		 * @param name:String -> nom de la balise json à créer
		 * @author Morphelin
		 */
		private function constructPhoto(name:String):void
		{
			var field:String = '';
			field += '{\n\t"name" : "java_' + savedDatas[name]['ti_name'] + '_settings",';
			field += '\n\t"posx" : "' + savedDatas[name]['ti_posx'] + '",';
			field += '\n\t"posy" : "' + savedDatas[name]['ti_posy'] + '",';
			field += '\n\t"width" : "' + savedDatas[name]['ti_width'] + '",';
			field += '\n\t"height" : "' + savedDatas[name]['ti_height'] + '",';
			field += '\n\t"animation_apparition_type" : "' + savedDatas[name]['ti_app_type'] + '",';
			field += '\n\t"animation_apparition_duration" : "' + savedDatas[name]['ti_app_duration'] + '",';
			field += '\n\t"animation_apparition_startDelay" : "' + savedDatas[name]['ti_app_delay'] + '",';
			field += '\n\t"animation_apparition_debut" : "' + savedDatas[name]['ti_app_debut'] + '",';
			field += '\n\t"animation_apparition_fin" : "' + savedDatas[name]['ti_app_fin'] + '",';
			field += '\n\t"animation_disparition_type" : "' + savedDatas[name]['ti_disp_type'] + '",';
			field += '\n\t"animation_disparition_duration" : "' + savedDatas[name]['ti_disp_duration'] + '",';
			field += '\n\t"animation_disparition_startDelay" : "' + savedDatas[name]['ti_disp_delay'] + '",';
			field += '\n\t"animation_disparition_debut" : "' + savedDatas[name]['ti_disp_debut'] + '",';
			field += '\n\t"animation_disparition_fin" : "' + savedDatas[name]['ti_disp_fin'] + '",';
			field += '\n\t"image_crop_type" : "' + savedDatas[name]['ti_image_crop_type'];
			if (photo_moreparams.menu.length > 0)
			{
					for (var nb_pho_params:int = 0; nb_pho_params <= photo_moreparams.menu.length -1; nb_pho_params++)
					{
						field += '",';
						field += '\n\t"' + photo_moreparams.menu[nb_pho_params]['name'].split('ti_').join('') + '" : "' + savedDatas[name][photo_moreparams.menu[nb_pho_params]['name']];
						if (nb_pho_params == photo_moreparams.menu.length -1)
						{
							field += '"\n}';
						}
					}
			} else
			{
				field += '"\n}';
			}
			trace (field);		
			saveStrings(field, 'photo', name);
		}
		
		
		
		/**
		 * Sauvegarde et architecture: fonction qui sauvegarde une balise jsonde type texte
		 * @param evt:Mouseevent = null -> événement souris facultatif
		 * @author Morphelin
		 */
		private function storeText(evt:MouseEvent = null):void
		{		
			stage.focus = stage;
			Fname = blankMe(text_type.ti_name.text);
			trace ('FNAME : ' + Fname);
			if (blankMe(Fname) != "")
			{
				
				savedDatas[blankMe(text_type.ti_name.text)] = new Array();
				
				savedDatas[blankMe(text_type.ti_name.text)] ['ti_name'] = blankMe(text_type.ti_name.text);
				savedDatas[blankMe(text_type.ti_name.text)] ['ti_posx'] = blankMe(text_type.ti_posx.text);
				Fposx = blankMe(text_type.ti_posx.text);
				savedDatas[blankMe(text_type.ti_name.text)] ['ti_posy'] = blankMe(text_type.ti_posy.text);
				Fposy = blankMe(text_type.ti_posy.text);
				savedDatas[blankMe(text_type.ti_name.text)] ['ti_width'] = blankMe(text_type.ti_width.text);
				Fwidth = blankMe(text_type.ti_width.text);
				savedDatas[blankMe(text_type.ti_name.text)] ['ti_height'] = blankMe(text_type.ti_height.text);
				Fheight = blankMe(text_type.ti_height.text);
				savedDatas[blankMe(text_type.ti_name.text)] ['ti_fontsize'] = blankMe(text_type.ti_fontsize.text);
				Ffontsize = blankMe(text_type.ti_fontsize.text);
				savedDatas[blankMe(text_type.ti_name.text)] ['ti_font'] = blankMe(text_type.ti_font.text);
				Fpolice = blankMe(text_type.ti_font.text);
				savedDatas[blankMe(text_type.ti_name.text)] ['ti_color'] = blankMe(text_type.ti_color.text);
				Fcolor = blankMe(text_type.ti_color.text);
				savedDatas[blankMe(text_type.ti_name.text)] ['ti_effect'] = blankMe(text_type.ti_effect.text);
				Feffect = blankMe(text_type.ti_effect.text);
				savedDatas[blankMe(text_type.ti_name.text)] ['ti_app_type'] = blankMe(text_type.ti_app_type.text);
				FappType = blankMe(text_type.ti_app_type.text);
				savedDatas[blankMe(text_type.ti_name.text)] ['ti_app_duration'] = blankMe(text_type.ti_app_duration.text);
				FappDuration = blankMe(text_type.ti_app_duration.text);
				savedDatas[blankMe(text_type.ti_name.text)] ['ti_app_delay'] = blankMe(text_type.ti_app_delay.text);
				FappDelay = blankMe(text_type.ti_app_delay.text);
				savedDatas[blankMe(text_type.ti_name.text)] ['ti_app_debut'] = blankMe(text_type.ti_app_debut.text);
				FappDebut = blankMe(text_type.ti_app_debut.text);
				savedDatas[blankMe(text_type.ti_name.text)] ['ti_app_fin'] = blankMe(text_type.ti_app_fin.text);
				FappFin = blankMe(text_type.ti_app_fin.text);
				savedDatas[blankMe(text_type.ti_name.text)] ['ti_disp_type'] = blankMe(text_type.ti_disp_type.text);
				FdisType = blankMe(text_type.ti_disp_type.text);
				savedDatas[blankMe(text_type.ti_name.text)] ['ti_disp_duration'] = blankMe(text_type.ti_disp_duration.text);
				FdisDuration = blankMe(text_type.ti_disp_duration.text);
				savedDatas[blankMe(text_type.ti_name.text)] ['ti_disp_delay'] = blankMe(text_type.ti_disp_delay.text);
				FdisDelay = blankMe(text_type.ti_disp_delay.text);
				savedDatas[blankMe(text_type.ti_name.text)] ['ti_disp_debut'] = blankMe(text_type.ti_disp_debut.text);
				FdisDebut = blankMe(text_type.ti_disp_debut.text);
				savedDatas[blankMe(text_type.ti_name.text)] ['ti_disp_fin'] = blankMe(text_type.ti_disp_fin.text);
				FdisFin = blankMe(text_type.ti_disp_fin.text);
				savedDatas[blankMe(text_type.ti_name.text)] ['ti_default_value'] = blankMe(text_type.ti_default_value.text);
				Fdefaultvalue = blankMe(text_type.ti_default_value.text); //icihere
				for (var nbparams:int = 0; nbparams <= texte_moreparams.menu.length - 1; nbparams ++) {
					trace ('STORING DATA : ');
					trace ('texte moreparam@ nparams[name] = ' + texte_moreparams.menu[nbparams]['name']);
					trace ('texte moreparam@ nparams[input].text = ' + texte_moreparams.menu[nbparams]['input'].text);
					savedDatas[blankMe(text_type.ti_name.text)] [blankMe(texte_moreparams.menu[nbparams]['name'])] = blankMe(texte_moreparams.menu[nbparams]['input'].text);
					trace ("savedDatas[blankMe(texte_moreparams.menu[nbparams]['name'])] : " + savedDatas[blankMe(texte_moreparams.menu[nbparams]['name'])]);
				}
				savedDatas[Fname]['type'] = 'text';	
			
				
				constructText(Fname);
				textCounter++;
				
				errors.text = '';
			}
			
			else
			{
				errors.text = 'Warning u must fill the field "name"';
			}
		}
		
		/**
		 * Sauvegarde et architecture : fonction qui sauvegarde une balise jsonde type photo
		* @param evt:Mouseevent = null -> événement souris facultatif
		 * @author Morphelin
		 */
		private function storePhoto(evt:MouseEvent = null):void
		{
			
			stage.focus = stage;
			Fname = blankMe(photo_type.ti_name.text);
			if (blankMe(Fname) != "")
			{
				savedDatas[blankMe(photo_type.ti_name.text)] = new Array();
				
				savedDatas[blankMe(photo_type.ti_name.text)] ['ti_name'] = blankMe(photo_type.ti_name.text);
				savedDatas[blankMe(photo_type.ti_name.text)] ['ti_posx'] = blankMe(photo_type.ti_posx.text);
				Fposx = blankMe(photo_type.ti_posx.text);
				savedDatas[blankMe(photo_type.ti_name.text)] ['ti_posy'] = blankMe(photo_type.ti_posy.text);
				Fposy = blankMe(photo_type.ti_posy.text);
				savedDatas[blankMe(photo_type.ti_name.text)] ['ti_width'] = blankMe(photo_type.ti_width.text);
				Fwidth = blankMe(photo_type.ti_width.text);
				savedDatas[blankMe(photo_type.ti_name.text)] ['ti_height'] = blankMe(photo_type.ti_height.text);
				Fheight = blankMe(photo_type.ti_height.text);
				savedDatas[blankMe(photo_type.ti_name.text)] ['ti_app_type'] = blankMe(photo_type.ti_app_type.text);
				FappType = blankMe(photo_type.ti_app_type.text);
				savedDatas[blankMe(photo_type.ti_name.text)] ['ti_app_duration'] = blankMe(photo_type.ti_app_duration.text);
				FappDuration = blankMe(photo_type.ti_app_duration.text);
				savedDatas[blankMe(photo_type.ti_name.text)] ['ti_app_delay'] = blankMe(photo_type.ti_app_delay.text);
				FappDelay = blankMe(photo_type.ti_app_delay.text);
				savedDatas[blankMe(photo_type.ti_name.text)] ['ti_app_debut'] = blankMe(photo_type.ti_app_debut.text);
				FappDebut = blankMe(photo_type.ti_app_debut.text);
				savedDatas[blankMe(photo_type.ti_name.text)] ['ti_app_fin'] = blankMe(photo_type.ti_app_fin.text);
				FappFin = blankMe(photo_type.ti_app_fin.text);
				savedDatas[blankMe(photo_type.ti_name.text)] ['ti_disp_type'] = blankMe(photo_type.ti_disp_type.text);
				FdisType = blankMe(photo_type.ti_disp_type.text);
				savedDatas[blankMe(photo_type.ti_name.text)] ['ti_disp_duration'] = blankMe(photo_type.ti_disp_duration.text);
				FdisDuration = blankMe(photo_type.ti_disp_duration.text);
				savedDatas[blankMe(photo_type.ti_name.text)] ['ti_disp_delay'] = blankMe(photo_type.ti_disp_delay.text);
				FdisDelay = blankMe(photo_type.ti_disp_delay.text);
				savedDatas[blankMe(photo_type.ti_name.text)] ['ti_disp_debut'] = blankMe(photo_type.ti_disp_debut.text);
				FdisDebut = blankMe(photo_type.ti_disp_debut.text);
				savedDatas[blankMe(photo_type.ti_name.text)] ['ti_disp_fin'] = blankMe(photo_type.ti_disp_fin.text);
				FdisFin = blankMe(photo_type.ti_disp_fin.text);
				savedDatas[blankMe(photo_type.ti_name.text)] ['ti_image_crop_type'] = blankMe(photo_type.ti_image_crop_type.text);
				Fcroptype = blankMe(photo_type.ti_image_crop_type.text);
				for (var nbparams:int = 0; nbparams <= photo_moreparams.menu.length - 1; nbparams ++) {
					trace ('STORING DATA : ');
					trace ('texte moreparam@ nparams[name] = ' + photo_moreparams.menu[nbparams]['name']);
					trace ('texte moreparam@ nparams[input].text = ' + photo_moreparams.menu[nbparams]['input'].text);
					savedDatas[blankMe(photo_type.ti_name.text)] [blankMe(photo_moreparams.menu[nbparams]['name'])] = blankMe(photo_moreparams.menu[nbparams]['input'].text);
					trace ("savedDatas[blankMe(photo_moreparams.menu[nbparams]['name'])] : " + savedDatas[blankMe(photo_moreparams.menu[nbparams]['name'])]);
				}
				savedDatas[Fname]['type'] = 'photo';
							
				constructPhoto(Fname);
				photoCounter++;
				//addBloc();
				errors.text = '';
			} 
			else
			{
				errors.text = 'Warning u must fill the field "name"';
			}
		}
		
		/**
		 * Edition : fonction qui sauvegarde une balise jsonde type photo
		 * @param evt:Mouseevent = null -> événement souris facultatif
		 * @author Morphelin
		 */
		private function limitToNumChars(tf:TextField):void
		{
			tf.restrict = "0-9\.\-";
		}
		
		private function saveFile(evt:MouseEvent = null):void {
			finalData = "";
			finalPhotosData = "";
			finalTextsData = "";
			
			trace ('SAVE TEXT: ' + balisesTextSaved);
			trace ('SAVE PHOTO: ' + balisesPhotosSaved);
			
			/*	if (finalPhotosData.substr(0, 2) == ',\n')
					{
						trace (', /n trouve');
						finalPhotosData = finalPhotosData.substr(2, finalPhotosData.length);
					}*/
			
			if (balisesPhotosSaved.length > 0 )
			{
				
				for (var num1:int = 0; num1 < balisesPhotosSaved.length; num1++)
				{
					if (num1 > 0)
					{
						finalPhotosData += ',\n';
					}
					finalPhotosData += balisesPhotosSaved[num1];
				}
				
				if (balisesPhotosSaved.length == 1)
				{
					trace ('SAVING ONLY ONE PHOTO');
					//finalPhotosData = balisesPhotosSaved[0].split(',\n').join('');
					if (finalPhotosData.substr(0, 2) == ',\n')
					{
						trace (', /n trouve');
						finalPhotosData = finalPhotosData.substr(2, finalPhotosData.length);
					}
				}
				
			}
			
			if (balisesTextSaved.length > 0)
			{
				for (var num2:int = 0; num2 < balisesTextSaved.length; num2++)
				{
					trace (balisesTextSaved[num2]);
					if (num2 > 0)
					{
						finalTextsData += ',\n';
					}
					finalTextsData += balisesTextSaved[num2];
				}
				
				if (balisesTextSaved.length == 1)
				{
					trace ('SAVING ONLY ONE TEXT' + finalTextsData.substr(0,2) +'----');
					if (finalTextsData.substr(0, 2) == ',\n')
					{
						trace (', /n trouve');
						finalTextsData = finalTextsData.substr(2, finalTextsData.length);
					}
				}
			}
			trace ('nb_blocs : ' + nbBlocs);
			
				if (balisesTextSaved.length > 0 && balisesPhotosSaved.length <= 0)
				{
					finalData = '[\n' + finalTextsData + '\n]';
				}
				else if (balisesPhotosSaved.length > 0 && balisesTextSaved.length <= 0)
				{
					finalData = '\n\n[\n' + finalPhotosData + '\n]';
				}
				else if ((balisesTextSaved.length > 0) && (balisesPhotosSaved.length > 0))
				{
					finalData = '[\n' + finalTextsData + '\n]' + '\n'+ separation +'\n[\n' + finalPhotosData + '\n]';
				}
				trace ('finalData : \n ' + finalData);
				json = new FileReference();
				/*json.browse();
				json.load();*/
				json.save(finalData, filename);
			/*}
			else
			{
				errors.text = 'No valid data';
			}*/
		}
		
		
		private function submit(_value:String):void
		{
			/*var requestVars:URLVariables = new URLVariables();
			requestVars.data = _value;
			//logXML(_value);
			var request:URLRequest = new URLRequest();
			request.url = "http://127.0.0.1/json.php";
			request.method ="get";
			request.data = requestVars;
			
			//
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = "text";
			try {
				//log('sending request...');
				loader.load(request);
			}
			catch (Requesterror:Error)			
			{
				//log('request failed');
			}*/
			
		}
		
		private function changeFocus(keyEvent:KeyboardEvent):void
		{
			
		}
		
		private function capture(evt:FocusEvent):void
		{			
			evt.target.background = true;
			evt.target.backgroundColor = 0x77BBFF;
			trace(evt.target.name);
			evt.target.text = evt.target.text.split('\n').join('');
			evt.target.text = evt.target.text.split('\r').join('');
			
		}
		
		private function register():void
		{
			
		}
	}
	
}
