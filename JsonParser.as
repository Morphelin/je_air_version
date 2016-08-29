package 
{
	
	/**
	 * ...
	 * @author M0rphel1
	 */
	public class JsonParser 
	{
		/*public function JsonParser(_json:String)
		{
			parseJ(_json);
		}*/
		
		public static function getName(s:String):String
		{
			var chain:String = s;
			trace ('original chain :' + chain);
			chain = chain.split('"name" : "java_').join('');
			trace ('1. chain = ' + chain);
			chain = chain.split('_settings"').join('');
			trace ('2. chain = ' + chain);
			
			trace ('chain : ' + chain.substr(0, 5));
			
			return chain.substr(0, 5);
			
		}
		
		public static function parseJ(data:String,photo_params:int,texte_params:int, _separation:String):Array
		{
			data = data.split(_separation).join("");
			trace ('[PARSEJ from JsonParder]: nb_photo_params : ' + photo_params +', nb_texte_params: ' + texte_params);
			var a:Array = new Array();
			var aa:Array = new Array();
			var aFinal:Array = new Array();
			data = data.split('\n').join('');
			data = data.split('\t').join('');
			data = data.split(']').join('');
			a = data.split('[');
			trace ('a.length : ' + a.length);
			trace ('parseJ : ' + a);
			//a.splice(a[0]);
			if (a.length > 2)
			{
				trace ('toasty');
				for (var i:int = 0; i < a.length; i++)
				{
					trace ('a[i] :' + a[i]); 
					if (a[i] != "")
					{
						
						var aaa:Array = new Array();
						var s:String = a[i].split('}').join('');
						s = s.split('{').join('');
						//s = s.split(' ').join('');
						aaa = s.split(',');
						if (i == 1){
							aa['textes'] = aaa;
						}
						else if (i == 2)
						{
							aa['photos'] = aaa;
						}
						trace ('i :' + i + ', aaa : ' + aaa);
					}
				/*	
					if (i >= a.length)
					{
						
						return a;
					}*/
				}
			}else
			{
				if (a.length == 2)
				{
				trace ('toasty');
				for (var i2:int = 0; i2 < a.length; i2++)
				{
					trace ('a[i2] :' + a[i2]); 
					if (a[i2] != "")
					{
						
						aaa = new Array();
						s = a[i2].split('}').join('');
						s = s.split('{').join('');
						//s = s.split(' ').join('');
						aaa = s.split(',');
						trace ('aaa length : ' + aaa.length);
						if (i2 == 1) {
							trace ('aaa	[1] : ' + aaa[1]);
							if (getName(aaa[0]) == "photo") 
							{
								aa["photos"] = aaa;
							}
							else if ( getName(aaa[0]) == "texte" || getName(aaa[0]) == "titre")
							{
								aa["textes"] = aaa;
							}
						}
						/*else if (i == 2)
						{
							aa['photos'] = aaa;
						}*/
						trace ('i2 :' + i2 + ', aaa : ' + aaa);
					}
				/*	
					if (i >= a.length)
					{
						
						return a;
					}*/
				}
				}
			}
			//trace ('\n\n aa : legnth : ' + aa[0].length + '/ ' + aa[0]);
			
			/*if (aa.length > 0)
			{
				for (var k:int = 0; k < aa.length; k++)
				{
					var tmp:Array = new Array();
					tmp = aa[k].split(',');
					aFinal.push(tmp);
				}
			}*/
			aFinal.push(aa['textes']);
			aFinal.push(aa['photos']);
			
			trace ("aFinal.push(aa['photos']);" + aFinal[1]);
			trace ("aFinal.push(aa['photos']);" + aFinal[0]);
			//trace('aFinal : \n - textes :' + aFinal[0].length + '\n - photos :' + aFinal[1].length);
			//trace ('textes length : ' + aFinal[0][0]);
			
			var cptTextes:int; 
			if (String(aFinal[0]) == "undefined")
			{
				cptTextes = 0;
			}
			else {
				cptTextes = aFinal[0].length / texte_params;
			}
			
			var cptPhotos:int;
			if (String(aFinal[1]) == "undefined")
			{
				cptPhotos = 0;
			}
			else {
				cptPhotos= aFinal[1].length / photo_params;
			}
			
			var infosTraitees:Array = new Array();
			infosTraitees['textes'] = new Array();
			infosTraitees['photos'] = new Array();
			if (cptTextes > 0)
			{
				for (var txt:int = 0; txt < cptTextes; txt ++)
				{
					var cell:Array = new Array();
					for (var info:int = txt * texte_params; info < (txt * texte_params + aFinal[0].length/cptTextes); info++)
					{
						trace ('/*/*/*/*/* + ' +  aFinal[0][info] +'*-------------------');
						var atmp:Array = aFinal[0][info].split(' : ');
						var key:String = atmp[0];
						var value:String = atmp[1];
						key = key.split('"').join('');
						key = key.split('\n').join('');
						key = key.split('\r').join('');
						key = key.split('\t').join('');
						value = value.split('"').join('');
						value = value.split('\n').join('');
						value = value.split('\r').join('');
						value = value.split('\t').join('');
						trace ('****************\n' + atmp + '\n key]-' + key + '-\n value' + value + '\n++++++++++++++++');
						cell[key] = value;
					}
					trace ('****TXT = ' + txt + ' *************');
					infosTraitees['textes'].push(cell);
					trace ("infosTraitees['textes'].push(cell); [0]['name'] : "  + infosTraitees['textes'][0]['name']);
				}
			}
			
			if (cptPhotos> 0)
			{
				for (var iPho:int = 0; iPho < cptPhotos; iPho ++)
				{
					var cellPic:Array = new Array();
					trace ((iPho * photo_params + aFinal[1].length / cptPhotos));
					for (var pinfo:int = iPho * photo_params; pinfo < (iPho * photo_params + aFinal[1].length/cptPhotos); pinfo++)
					{
						var ptmp:Array = aFinal[1][pinfo].split(' : ');
						var keyp:String = ptmp[0];
						var valuep:String = ptmp[1];
						keyp = keyp.split('"').join('');
						keyp = keyp.split('\n').join('');
						keyp = keyp.split('\r').join('');
						keyp = keyp.split('\t').join('');
						valuep = valuep.split('"').join('');
						valuep = valuep.split('\n').join('');
						valuep = valuep.split('\r').join('');
						valuep = valuep.split('\t').join('');
						trace ('****************\n' + ptmp + '\n ptmp[0]' + keyp + '\n ptmp[1]' + valuep + '\n++++++++++++++++');
						cellPic[keyp] = valuep;
					}
					infosTraitees['photos'].push(cellPic);
				}
			}
			//trace ('infostraitees : ' + infosTraitees['textes'][1]['name']);
			
			return infosTraitees;
			
		}
	}
	
}