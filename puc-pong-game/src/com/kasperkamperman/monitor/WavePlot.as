package com.kasperkamperman.monitor
		
		private var _t:String; 				// name of graph
		private var _txt:TextField;
		private var _txtFormat:TextFormat;
			_t = t;
			
			// don't plot more then 128 values, otherwise scale			
			_txtFormat = new TextFormat();
			_txtFormat.color = 0x000000;
			
			_txt.width = 256;
			_txt.setTextFormat(_txtFormat);
		  //_txt.text = _t + " - value : " + v;
		  _txt.setTextFormat(_txtFormat);			
	}