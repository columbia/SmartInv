1 /*
2 
3 Introducing "STAKE THEM ALL" Version 1.0
4 "STAKE THEM ALL" is playable @ https://stakethemall.io (Ethereum Edition) and https://trx.stakethemall.io (TRON Edition)
5 
6 About the game :
7 
8 "STAKE THEM ALL" IS A FUN AND REWARDING PHYSICS GAME RUNNING ON THE BLOCKCHAIN
9 HAVE FUN WHILE PARTICIPATING TO THE HDX20 TOKEN PRICE APPRECIATION @ https://hdx20.io
10 
11 How to play "STAKE THEM ALL":
12 
13 Challenge MODE
14 --------------
15 Set the difficulty of your CHALLENGE by choosing how many cube you want
16 to stack on top of each other and get rewarded on success.
17 
18 Builder MODE
19 ------------
20 Stack 15 cubes in order to reach the maximum height. 
21 The best score, if not beaten within a 24H countdown, wins the whole POT.   
22    
23 
24 This product is copyrighted. Any unauthorized copy, modification, or use without express written consent from HyperDevbox is prohibited.
25 
26 Copyright 2019 HyperDevbox
27 
28 */
29 
30 
31 
32 
33 pragma solidity ^0.4.25;
34 
35 
36 interface HDX20Interface
37 {
38     function() payable external;
39     
40     
41     function buyTokenFromGame( address _customerAddress , address _referrer_address ) payable external returns(uint256);
42   
43     function payWithToken( uint256 _eth , address _player_address ) external returns(uint256);
44   
45     function appreciateTokenPrice() payable external;
46    
47     function totalSupply() external view returns(uint256); 
48     
49     function ethBalanceOf(address _customerAddress) external view returns(uint256);
50   
51     function balanceOf(address _playerAddress) external view returns(uint256);
52     
53     function sellingPrice( bool includeFees) external view returns(uint256);
54   
55 }
56 
57 
58 
59 contract stakethemall
60 {
61      HDX20Interface private HDXcontract = HDX20Interface(0x8942a5995bd168f347f7ec58f25a54a9a064f882);
62      
63      using SafeMath for uint256;
64      using SafeMath128 for uint128;
65      
66      /*==============================
67     =            EVENTS            =
68     ==============================*/
69     event OwnershipTransferred(
70         
71          address previousOwner,
72          address nextOwner,
73           uint256 timeStamp
74          );
75          
76     event HDXcontractChanged(
77         
78          address previous,
79          address next,
80          uint256 timeStamp
81          );
82  
83   
84     
85 	    
86      event onWithdrawGains(
87         address customerAddress,
88         uint256 ethereumWithdrawn,
89         uint256 timeStamp
90     );
91     
92      event onBuyMode1(
93         address     customerAddress,
94         uint256     BatchID,
95         uint256     BatchBlockTimeout,  
96         uint32      Challenge
97         );  
98         
99     event onBuyMode2(
100         address     customerAddress,
101         uint256     BatchID,
102         uint256     BatchBlockTimeout,  
103         uint256     nb_token
104         );   
105         
106     event onNewScoreMode1(
107         uint256 score,
108         address customerAddress,
109         uint256 winning,
110         uint256 nb_token
111     ); 
112     
113     event onNewScoreMode2(
114         uint256 score,
115         address       customerAddress,
116         bool    newHighscore
117       
118     ); 
119         
120   
121         
122     event onChangeMinimumPrice(
123         
124          uint256 minimum,
125          uint256 timeStamp
126          );
127          
128   
129       event onChangeBlockTimeout(
130         
131          uint32 b1,
132          uint32 b2
133          );
134          
135         event onChangeTreasurePercentage(
136         
137          uint32 percentage
138          );
139          
140        
141          
142     /*==============================
143     =            MODIFIERS         =
144     ==============================*/
145     modifier onlyOwner
146     {
147         require (msg.sender == owner );
148         _;
149     }
150     
151     modifier onlyFromHDXToken
152     {
153         require (msg.sender == address( HDXcontract ));
154         _;
155     }
156    
157      modifier onlyDirectTransaction
158     {
159         require (msg.sender == tx.origin);
160         _;
161     }
162 
163   
164     address public owner;
165   
166    
167     address public signerAuthority = 0xf77444cE64f3F46ba6b63F6b9411dF9c589E3319;
168    
169     
170 
171     constructor () public
172     {
173         owner = msg.sender;
174        
175         GameRoundData.extraData[0] = 20; //mode1 20%
176         GameRoundData.extraData[1] = 0; //mode2 current highscore
177 	    GameRoundData.extraData[2] = uint32((3600*1) / 15);     //1 hour
178 	    GameRoundData.extraData[3] = uint32((3600*24) / 15);     //24 hour
179         
180         
181         if ( address(this).balance > 0)
182         {
183             owner.transfer( address(this).balance );
184         }
185     }
186     
187     function changeOwner(address _nextOwner) public
188     onlyOwner
189     {
190         require (_nextOwner != owner);
191         require(_nextOwner != address(0));
192          
193         emit OwnershipTransferred(owner, _nextOwner , now);
194          
195         owner = _nextOwner;
196     }
197     
198     function changeSigner(address _nextSigner) public
199     onlyOwner
200     {
201         require (_nextSigner != signerAuthority);
202         require(_nextSigner != address(0));
203       
204         signerAuthority = _nextSigner;
205     }
206     
207     function changeHDXcontract(address _next) public
208     onlyOwner
209     {
210         require (_next != address( HDXcontract ));
211         require( _next != address(0));
212          
213         emit HDXcontractChanged(address(HDXcontract), _next , now);
214          
215         HDXcontract  = HDX20Interface( _next);
216     }
217   
218   
219     function changeMinimumPrice( uint256 newmini) public
220     onlyOwner
221     {
222       
223       if (newmini>0)
224       {
225           minimumSharePrice = newmini;
226       }
227        
228       emit onChangeMinimumPrice( newmini , now ); 
229     }
230     
231     
232     function changeBlockTimeout( uint32 b1 , uint32 b2) public
233     onlyOwner
234     {
235         require( b1>0 && b2>0 );
236         
237        
238         GameRoundData.extraData[2] = b1;
239         GameRoundData.extraData[3] = b2;
240             
241         emit onChangeBlockTimeout( b1,b2 ); 
242         
243        
244        
245     }
246     
247     function changeTreasurePercentage( uint32 percentage) public
248     onlyOwner
249     {
250         require( percentage>0 && percentage<=100);
251         
252         GameRoundData.extraData[0] = percentage;
253           
254         emit onChangeTreasurePercentage( percentage ); 
255        
256        
257        
258     }
259     
260      /*================================
261     =       GAMES VARIABLES         =
262     ================================*/
263     
264     struct PlayerData_s
265     {
266    
267         uint256 chest;  
268         uint256 payoutsTo;
269        
270 		//credit locked until we validate the score mode1
271 		uint256         mode1LockedCredit;	
272 		uint256         mode1BatchID;         
273         uint256         mode1BlockTimeout;   
274         
275         uint256         mode2BatchID;         
276         uint256         mode2BlockTimeout;   
277 
278 		uint32[2]		packedData;		//[0] = mode1 challenge how ,any cube to stack;
279 		                                //[1] = mode1 multiplier
280 						
281     }
282     
283     
284     struct GameRoundData_s
285     {
286 	   
287 	   //mode1 
288 	   uint256				treasureAmount;
289 	   
290 	   //mode2
291 	   uint256              potAmount;
292 	   address				currentPotWinner;
293 	   uint256              potBlockCountdown;
294 	          
295        uint256              hdx20AppreciationPayout;
296        uint256              devAppreciationPayout;
297 	   
298        //********************************************************************************************
299 	   
300 	   uint32[4]			extraData;		//[0] = mode1 percentage    treasure
301 									        //[1] =	mode2 current       highscore
302                                             //[2] = mode1 and mode2 blocktimeout  how manyblock to submit a valid score
303                                             //[3] = mode2 countdown how many block
304                                            
305                                             
306     }
307       
308    
309     mapping (address => PlayerData_s)   private PlayerData;
310        
311     GameRoundData_s   private GameRoundData;
312    
313     uint8 constant private HDX20BuyFees = 5;
314      
315     uint8 constant private DevFees = 5;
316 	uint8 constant private AppreciationFees = 15;		
317 
318 	uint8 constant private TreasureAppreciation = 80;
319    	uint8 constant private PotAppreciation = 80;
320    	
321    
322     uint256 constant internal magnitude = 1e18;
323      
324     uint256 private minimumSharePrice = 0.1 ether;
325     
326 
327     uint256 constant thresholdForAppreciation = 0.05 ether;
328       
329     /*================================
330     =       PUBLIC FUNCTIONS         =
331     ================================*/
332     
333     //fallback will be called only from the HDX token contract to fund the game from customers's HDX20
334     
335      function()
336      payable
337      public
338      onlyFromHDXToken 
339     {
340        
341       
342       
343           
344     }
345     
346     function ChargePot() public payable
347     {
348 		uint256 _val = msg.value;
349 		
350 		GameRoundData.potAmount = GameRoundData.potAmount.add( _val );
351 	
352     }
353     
354     function ChargeTreasure() public payable
355     {
356 		uint256 _val = msg.value;
357 	
358 		
359 		GameRoundData.treasureAmount = GameRoundData.treasureAmount.add( _val );
360 				   
361     }
362 	
363 	//mode1
364 	function AddTreasure( uint256 _val ) private
365 	{
366 	
367 		GameRoundData.treasureAmount = GameRoundData.treasureAmount.add( _val.mul( TreasureAppreciation ) / 100 );
368 		
369 		//now HDX20 appreciation and dev account
370 		
371 		uint256 _appreciation = SafeMath.mul( _val , AppreciationFees) / 100; 
372           
373         uint256 _dev = SafeMath.mul( _val , DevFees) / 100;  
374 		
375 		_dev = _dev.add( GameRoundData.devAppreciationPayout );
376 		
377 		if (_dev>= thresholdForAppreciation )
378 		{
379 			GameRoundData.devAppreciationPayout = 0;
380 			
381 			HDXcontract.buyTokenFromGame.value( _dev )( owner , address(0));	
382 		}
383 		else
384 		{
385 			 GameRoundData.devAppreciationPayout = _dev;
386 		}
387 	
388 		_appreciation = _appreciation.add( GameRoundData.hdx20AppreciationPayout );
389 		
390 		if (_appreciation>= thresholdForAppreciation)
391 		{
392 			GameRoundData.hdx20AppreciationPayout = 0;
393 			
394 			HDXcontract.appreciateTokenPrice.value( _appreciation )();
395 		}
396 		else
397 		{
398 			GameRoundData.hdx20AppreciationPayout = _appreciation;
399 		}
400 		
401 	}
402 	
403     //mode2
404 	function AddPot( uint256 _val ) private
405 	{
406 	    
407         
408 		GameRoundData.potAmount = GameRoundData.potAmount.add( _val.mul( PotAppreciation ) / 100 );
409 		
410 		//now HDX20 appreciation and dev account
411 		
412 		uint256 _appreciation = SafeMath.mul( _val , AppreciationFees) / 100; 
413           
414         uint256 _dev = SafeMath.mul( _val , DevFees) / 100;  
415 		
416 		_dev = _dev.add( GameRoundData.devAppreciationPayout );
417 		
418 		if (_dev>= thresholdForAppreciation )
419 		{
420 			GameRoundData.devAppreciationPayout = 0;
421 			
422 			HDXcontract.buyTokenFromGame.value( _dev )( owner , address(0));	
423 		}
424 		else
425 		{
426 			 GameRoundData.devAppreciationPayout = _dev;
427 		}
428 	
429 		_appreciation = _appreciation.add( GameRoundData.hdx20AppreciationPayout );
430 		
431 		if (_appreciation>= thresholdForAppreciation)
432 		{
433 			GameRoundData.hdx20AppreciationPayout = 0;
434 			
435 			HDXcontract.appreciateTokenPrice.value( _appreciation )();
436 		}
437 		else
438 		{
439 			GameRoundData.hdx20AppreciationPayout = _appreciation;
440 		}
441 		
442 	}
443     
444     
445     function ValidMode1Score( uint256 score, uint256 mode1BatchID , bytes32 r , bytes32 s , uint8 v) public
446     onlyDirectTransaction
447     {
448         address _customer_address = msg.sender;
449       
450         GameVar_s memory gamevar;
451         gamevar.score = score;
452         gamevar.BatchID = mode1BatchID;
453         gamevar.r = r;
454         gamevar.s = s;
455         gamevar.v = v;
456    
457         checkPayPot();
458    
459         coreValidMode1Score( _customer_address , gamevar  );
460     }
461     
462     function ValidMode2Score( uint256 score, uint256 mode2BatchID , bytes32 r , bytes32 s , uint8 v) public
463     onlyDirectTransaction
464     {
465         address _customer_address = msg.sender;
466       
467         GameVar_s memory gamevar;
468         gamevar.score = score;
469         gamevar.BatchID = mode2BatchID;
470         gamevar.r = r;
471         gamevar.s = s;
472         gamevar.v = v;
473         
474         checkPayPot();
475    
476         coreValidMode2Score( _customer_address , gamevar  );
477     }
478     
479     struct GameVar_s
480     {
481         uint256  BatchID;
482        
483  	    uint256   score;
484 	
485         bytes32  r;
486         bytes32  s;
487         uint8    v;
488         uint32   multiplier;
489     }
490     
491 	function checkPayPot() private
492 	{
493 	    uint256 b1 =  GameRoundData.potBlockCountdown;
494 	    
495 	    if (b1>0)
496 	    {
497 	        if (block.number>=b1)
498 	        {
499     		    address _winner = GameRoundData.currentPotWinner;
500     		    uint256 _j = GameRoundData.potAmount/2;
501     		
502     		   
503     		
504     		    if (_winner != address(0))
505     		    {
506     			    PlayerData[ _winner ].chest = PlayerData[ _winner ].chest.add( _j ); 
507     		    }
508     		    
509         		GameRoundData.currentPotWinner = address(0);
510         		GameRoundData.potAmount = GameRoundData.potAmount.sub( _j );
511         		
512         	    //highscore to 0
513         		GameRoundData.extraData[1] = 0;
514         		//block at 0
515         		GameRoundData.potBlockCountdown = 0;
516         		
517     		}
518 	    }
519 		
520 	}
521   
522     
523     function coreValidMode1Score( address _player_address , GameVar_s gamevar) private
524     {
525     
526         PlayerData_s storage  _PlayerData = PlayerData[ _player_address];
527                 
528         require((gamevar.BatchID != 0) && (gamevar.BatchID == _PlayerData.mode1BatchID) && ( _PlayerData.mode1LockedCredit>0 ));
529         
530         if (block.number>=_PlayerData.mode1BlockTimeout || (ecrecover(keccak256(abi.encodePacked( gamevar.score,gamevar.BatchID )) , gamevar.v, gamevar.r, gamevar.s) != signerAuthority))
531         {
532             gamevar.score = 0;
533         }
534 		
535 	
536 	    if (gamevar.score> _PlayerData.packedData[0]) 	gamevar.score =  _PlayerData.packedData[0];
537 	    
538 	    uint256 _winning =0;
539 	    uint256 _hdx20 = 0;
540 	    uint256 _nb_token = 0;
541 	    uint256 _minimum =  _PlayerData.mode1LockedCredit.mul(5) / 100;
542 	   
543 	    
544 	   
545 	    if (gamevar.score>0)
546 	    {
547 	        uint256 _gain;
548 	    
549 	        //percentage of treasure      
550 	        _gain = GameRoundData.treasureAmount.mul( GameRoundData.extraData[0]) / 100;
551 	        
552 	        //scale the gain based the credit size
553 	        _gain = _gain.mul( _PlayerData.packedData[1]) / 10;
554 	   
555 	        //triple cube curve     
556 	        _gain = _gain.mul( _PlayerData.packedData[0] * _PlayerData.packedData[0] * _PlayerData.packedData[0] );
557 	        _gain /= (10*10*10);
558 	        
559 	          //maximum x2
560 	        if (_gain>_PlayerData.mode1LockedCredit) _gain = _PlayerData.mode1LockedCredit;
561 	        
562 	        //succed challenge ?
563 	        if (gamevar.score==_PlayerData.packedData[0])
564 	        {
565 	            _winning = _PlayerData.mode1LockedCredit.add( _gain);
566 	        }
567 	        else
568 	        {
569 	            _winning = _PlayerData.mode1LockedCredit.sub( _gain );
570 	            _gain = (_gain).mul( gamevar.score-1 );
571 	            _gain /= uint256( _PlayerData.packedData[0] );
572 	            _winning = _winning.add( _gain );
573 	        }
574 	    }
575 	    
576 	    if (_winning<_minimum) _winning = _minimum;
577 	    
578 	   //winning cannot be zero 
579 	   
580 	   //HDX20BuyFees
581         _hdx20 = (_winning.mul(HDX20BuyFees)) / 100;
582 	
583 	    _nb_token =   HDXcontract.buyTokenFromGame.value( _hdx20 )( _player_address , address(0)); 
584 	     
585 		//credit the player for what is won minus the HDX20
586 		_PlayerData.chest = _PlayerData.chest.add( _winning - _hdx20 );
587 		
588 		//loosing some ?
589 		
590 		if (_PlayerData.mode1LockedCredit> _winning)
591 		{
592 			
593 			AddTreasure( _PlayerData.mode1LockedCredit - _winning );
594 		}
595 		
596 		//we need to pay the difference from the treasure
597 		if (_winning>_PlayerData.mode1LockedCredit)
598 		{
599 		    GameRoundData.treasureAmount = GameRoundData.treasureAmount.sub( _winning - _PlayerData.mode1LockedCredit);
600 		}
601 	
602         //ok reset it so we can get a new one
603         _PlayerData.mode1BatchID = 0;
604         _PlayerData.mode1LockedCredit = 0;
605 		
606         emit onNewScoreMode1( gamevar.score , _player_address , _winning , _nb_token );
607 
608     }
609     
610     function coreValidMode2Score( address _player_address , GameVar_s gamevar) private
611     {
612     
613         PlayerData_s storage  _PlayerData = PlayerData[ _player_address];
614         
615                 
616         if ((gamevar.BatchID != 0) && (gamevar.BatchID == _PlayerData.mode2BatchID))
617         {
618                 
619             if (block.number>=_PlayerData.mode2BlockTimeout || (ecrecover(keccak256(abi.encodePacked( gamevar.score,gamevar.BatchID )) , gamevar.v, gamevar.r, gamevar.s) != signerAuthority))
620             {
621                 gamevar.score = 0;
622             }
623     		
624     	
625     	    if (gamevar.score>80*2*15) 	gamevar.score = 80*2*15;
626     	    
627     	    bool _newHighscore = false;
628     	    
629     	    //new highscore
630     	    if (gamevar.score > GameRoundData.extraData[1])
631     	    {
632     	        GameRoundData.extraData[1] = uint32(gamevar.score);
633     	        GameRoundData.currentPotWinner = _player_address;
634     	        GameRoundData.potBlockCountdown = block.number + uint256( GameRoundData.extraData[3] ); //24 hours countdown start
635     	        
636     	        _newHighscore = true;
637     	        
638     	    }
639     	    
640     	    emit onNewScoreMode2( gamevar.score , _player_address , _newHighscore);
641         }
642 	 
643         //ok reset it so we can get a new one
644         _PlayerData.mode2BatchID = 0;
645      
646 		
647 
648     }
649     
650     
651     function BuyMode1WithDividends( uint256 eth , uint32 challenge, uint256 score, uint256 BatchID,  address _referrer_address , bytes32 r , bytes32 s , uint8 v) public
652     onlyDirectTransaction
653     {
654         
655         require( (eth==minimumSharePrice || eth==minimumSharePrice*5 || eth==minimumSharePrice*10) && (challenge>=4 && challenge<=10) );
656   
657         address _customer_address = msg.sender;
658         
659         checkPayPot();
660         
661         GameVar_s memory gamevar;
662         gamevar.score = score;
663         gamevar.BatchID = BatchID;
664         gamevar.r = r;
665         gamevar.s = s;
666         gamevar.v = v;
667         gamevar.multiplier = uint32(eth / minimumSharePrice);
668       
669         
670         eth = HDXcontract.payWithToken( eth , _customer_address );
671        
672         require( eth>0 );
673        
674          
675         CoreBuyMode1( _customer_address , eth , challenge, _referrer_address , gamevar );
676         
677        
678     }
679     
680  
681     
682     function BuyMode1( uint32 challenge, uint256 score, uint256 BatchID, address _referrer_address , bytes32 r , bytes32 s , uint8 v ) public payable
683     onlyDirectTransaction
684     {
685      
686         address _customer_address = msg.sender;
687         uint256 eth = msg.value;
688         
689         require( (eth==minimumSharePrice || eth==minimumSharePrice*5 || eth==minimumSharePrice*10) && (challenge>=4 && challenge<=10));
690         
691         checkPayPot();
692    
693         GameVar_s memory gamevar;
694         gamevar.score = score;
695         gamevar.BatchID = BatchID;
696         gamevar.r = r;
697         gamevar.s = s;
698         gamevar.v = v;
699         gamevar.multiplier = uint32(eth / minimumSharePrice);
700      
701         CoreBuyMode1( _customer_address , eth , challenge, _referrer_address, gamevar);
702      
703     }
704     
705     
706     function BuyMode2WithDividends( uint256 eth , uint256 score, uint256 BatchID,  address _referrer_address , bytes32 r , bytes32 s , uint8 v) public
707     onlyDirectTransaction
708     {
709         
710         require( (eth==minimumSharePrice) );
711   
712         address _customer_address = msg.sender;
713         
714         checkPayPot();
715         
716         GameVar_s memory gamevar;
717         gamevar.score = score;
718         gamevar.BatchID = BatchID;
719         gamevar.r = r;
720         gamevar.s = s;
721         gamevar.v = v;
722       
723         
724         eth = HDXcontract.payWithToken( eth , _customer_address );
725        
726         require( eth>0 );
727        
728          
729         CoreBuyMode2( _customer_address , eth , _referrer_address , gamevar );
730         
731        
732     }
733     
734     
735     function BuyMode2( uint256 score, uint256 BatchID, address _referrer_address , bytes32 r , bytes32 s , uint8 v ) public payable
736     onlyDirectTransaction
737     {
738      
739         address _customer_address = msg.sender;
740         uint256 eth = msg.value;
741         
742         require( (eth==minimumSharePrice));
743         
744         checkPayPot();
745    
746         GameVar_s memory gamevar;
747         gamevar.score = score;
748         gamevar.BatchID = BatchID;
749         gamevar.r = r;
750         gamevar.s = s;
751         gamevar.v = v;
752      
753    
754         CoreBuyMode2( _customer_address , eth , _referrer_address, gamevar);
755      
756     }
757     
758     /*================================
759     =       CORE BUY FUNCTIONS       =
760     ================================*/
761     
762     function CoreBuyMode1( address _player_address , uint256 eth , uint32 challenge,  address _referrer_address , GameVar_s gamevar) private
763     {
764     
765         PlayerData_s storage  _PlayerData = PlayerData[ _player_address];
766          
767         //we need to validate the score before buying a torpedo batch
768         if (gamevar.BatchID !=0 || _PlayerData.mode1BatchID !=0)
769         {
770              coreValidMode1Score( _player_address , gamevar);
771         }
772         
773         //if we can continue then everything is fine let's create the new batch
774         
775         _PlayerData.packedData[0] = challenge;
776         _PlayerData.packedData[1] = gamevar.multiplier;
777         
778         _PlayerData.mode1BlockTimeout = block.number + (uint256(GameRoundData.extraData[2]));
779         _PlayerData.mode1BatchID = uint256((keccak256(abi.encodePacked( block.number,1,challenge, _player_address , address(this)))));
780       
781 		_PlayerData.mode1LockedCredit =  eth;
782 	
783         
784         emit onBuyMode1( _player_address, _PlayerData.mode1BatchID , _PlayerData.mode1BlockTimeout,  _PlayerData.packedData[0]);
785             
786         
787     }
788     
789     
790     function CoreBuyMode2( address _player_address , uint256 eth ,  address _referrer_address , GameVar_s gamevar) private
791     {
792     
793         PlayerData_s storage  _PlayerData = PlayerData[ _player_address];
794          
795         //we need to validate the score before buying a torpedo batch
796         if (gamevar.BatchID !=0 || _PlayerData.mode2BatchID !=0)
797         {
798              coreValidMode2Score( _player_address , gamevar);
799         }
800         
801         //if we can continue then everything is fine let's create the new batch
802         
803        
804         _PlayerData.mode2BlockTimeout = block.number + (uint256(GameRoundData.extraData[2]));
805         _PlayerData.mode2BatchID = uint256((keccak256(abi.encodePacked( block.number,2, _player_address , address(this)))));
806       
807          //HDX20BuyFees
808         uint256 _tempo = (eth.mul(HDX20BuyFees)) / 100;
809 	
810 	    eth = eth.sub( _tempo );	
811 	
812         uint256 _nb_token =   HDXcontract.buyTokenFromGame.value( _tempo )( _player_address , _referrer_address);
813         
814         AddPot( eth );
815         
816         emit onBuyMode2( _player_address, _PlayerData.mode2BatchID , _PlayerData.mode2BlockTimeout, _nb_token );
817             
818         
819     }
820     
821     function getPotGain( address _player_address) private view
822     returns( uint256)
823 	{
824 	    uint256 b1 =  GameRoundData.potBlockCountdown;
825 	    
826 	    if (b1>0)
827 	    {
828 	        if (block.number>=b1 && _player_address==GameRoundData.currentPotWinner)
829 	        {
830 	            return( GameRoundData.potAmount/2);
831 	          
832     		}
833 	    }
834 	    
835 	    return( 0 );
836 		
837 	}
838    
839     
840     function get_Gains(address _player_address) private view
841     returns( uint256)
842     {
843        
844         uint256 _gains = PlayerData[ _player_address ].chest;
845         
846         //we may have to temporary add the current pot gain to reflect the correct position
847         
848         _gains = _gains.add( getPotGain(_player_address ) );
849         
850         if (_gains > PlayerData[ _player_address].payoutsTo)
851         {
852             _gains -= PlayerData[ _player_address].payoutsTo;
853         }
854         else _gains = 0;
855      
856     
857         return( _gains );
858         
859     }
860     
861     
862     function WithdrawGains() public 
863    
864     {
865         address _customer_address = msg.sender;
866         
867         checkPayPot();
868         
869         uint256 _gains = get_Gains( _customer_address );
870         
871         require( _gains>0);
872         
873         PlayerData[ _customer_address ].payoutsTo = PlayerData[ _customer_address ].payoutsTo.add( _gains );
874         
875       
876         emit onWithdrawGains( _customer_address , _gains , now);
877         
878         _customer_address.transfer( _gains );
879         
880         
881     }
882     
883    
884   
885     
886      /*================================
887     =  VIEW AND HELPERS FUNCTIONS    =
888     ================================*/
889   
890     
891     function view_get_Treasure() public
892     view
893     returns(uint256)
894     {
895       
896       return( GameRoundData.treasureAmount );  
897     }
898 	
899 	function view_get_Pot() public
900     view
901     returns(uint256)
902     {
903       
904       return( GameRoundData.potAmount );  
905     }
906  
907     function view_get_gameData() public
908     view
909     returns( 
910              uint256 treasure,
911 			 uint256 pot,
912 			 uint32  highscore ,
913 			 address highscore_address ,
914 		
915 			 uint256 mode1BatchID,
916 		     uint256 mode1BlockTimeout,
917 		     uint32  mode1Challenge,
918 		     uint256 mode1Multiplier,
919 		     
920 			 uint256 mode2BatchID,
921 			 uint256 mode2BlockTimeout,
922 			 
923 			 uint256 potBlockCountdown,
924 			 
925 			 uint32  percentage)
926     {
927         address _player_address = msg.sender;
928 		
929 		treasure = GameRoundData.treasureAmount;
930 		pot = GameRoundData.potAmount;
931 		highscore = GameRoundData.extraData[1];
932 		highscore_address = GameRoundData.currentPotWinner;
933 		percentage = GameRoundData.extraData[0];
934 		      
935         mode1BatchID = PlayerData[_player_address].mode1BatchID;
936         mode1BlockTimeout = PlayerData[_player_address].mode1BlockTimeout;
937         mode1Challenge = PlayerData[_player_address].packedData[0];
938         mode1Multiplier =  PlayerData[_player_address].packedData[1];
939         
940         mode2BatchID =  PlayerData[_player_address].mode2BatchID;
941         mode2BlockTimeout = PlayerData[ _player_address].mode2BlockTimeout;
942         
943         potBlockCountdown = GameRoundData.potBlockCountdown;
944         
945       
946        
947     }
948   
949        
950   
951     
952     function view_get_Gains()
953     public
954     view
955     returns( uint256 gains)
956     {
957         
958         address _player_address = msg.sender;
959    
960         uint256 _gains = PlayerData[ _player_address ].chest;
961         
962         _gains = _gains.add( getPotGain( _player_address ) );
963         
964         if (_gains > PlayerData[ _player_address].payoutsTo)
965         {
966             _gains -= PlayerData[ _player_address].payoutsTo;
967         }
968         else _gains = 0;
969      
970     
971         return( _gains );
972         
973     }
974   
975   
976     
977     function view_get_gameStates() public 
978     view
979     returns( uint256 minimumshare ,
980 		     uint256 blockNumberCurrent,
981 		     uint32  blockScoreTimeout,
982 		     uint32  blockPotTimout
983 		   
984 		    )
985     {
986        
987         
988         return( minimumSharePrice ,  block.number   , GameRoundData.extraData[2] , GameRoundData.extraData[3] );
989     }
990     
991     function view_get_pendingHDX20Appreciation()
992     public
993     view
994     returns(uint256)
995     {
996         return GameRoundData.hdx20AppreciationPayout;
997     }
998     
999     function view_get_pendingDevAppreciation()
1000     public
1001     view
1002     returns(uint256)
1003     {
1004         return GameRoundData.devAppreciationPayout;
1005     }
1006   
1007  
1008  
1009     function totalEthereumBalance()
1010     public
1011     view
1012     returns(uint256)
1013     {
1014         return address(this).balance;
1015     }
1016     
1017   
1018     
1019     function view_get_blockNumbers()
1020     public
1021     view
1022     returns( uint256 b1 )
1023     {
1024         return( block.number);
1025         
1026     }
1027     
1028   
1029     
1030    
1031 }
1032 
1033 
1034 library SafeMath {
1035     
1036    
1037     function mul(uint256 a, uint256 b) 
1038         internal 
1039         pure 
1040         returns (uint256 c) 
1041     {
1042         if (a == 0) {
1043             return 0;
1044         }
1045         c = a * b;
1046         require(c / a == b);
1047         return c;
1048     }
1049 
1050    
1051     function sub(uint256 a, uint256 b)
1052         internal
1053         pure
1054         returns (uint256) 
1055     {
1056         require(b <= a);
1057         return a - b;
1058     }
1059 
1060    
1061     function add(uint256 a, uint256 b)
1062         internal
1063         pure
1064         returns (uint256 c) 
1065     {
1066         c = a + b;
1067         require(c >= a);
1068         return c;
1069     }
1070     
1071    
1072     
1073   
1074     
1075    
1076 }
1077 
1078 
1079 library SafeMath128 {
1080     
1081    
1082     function mul(uint128 a, uint128 b) 
1083         internal 
1084         pure 
1085         returns (uint128 c) 
1086     {
1087         if (a == 0) {
1088             return 0;
1089         }
1090         c = a * b;
1091         require(c / a == b);
1092         return c;
1093     }
1094 
1095    
1096     function sub(uint128 a, uint128 b)
1097         internal
1098         pure
1099         returns (uint128) 
1100     {
1101         require(b <= a);
1102         return a - b;
1103     }
1104 
1105    
1106     function add(uint128 a, uint128 b)
1107         internal
1108         pure
1109         returns (uint128 c) 
1110     {
1111         c = a + b;
1112         require(c >= a);
1113         return c;
1114     }
1115     
1116    
1117     
1118   
1119     
1120    
1121 }