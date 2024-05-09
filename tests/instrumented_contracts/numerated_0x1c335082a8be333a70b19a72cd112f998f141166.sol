1 /*
2 
3 Introducing "TORPEDO LAUNCH" Version 2, with a major update on payout system
4 "TORPEDO LAUNCH" is playable @ https://torpedolaunch.io (Ethereum Edition) and https://trx.torpedolaunch.io (TRON Edition)
5 
6 About the game :
7 
8 You are in command on a WW2 Class Submarine, YOUR MISSION : Seek and Destroy enemy ships.
9 
10 How to play TORPEDO LAUNCH:
11 
12 Buy a batch of 15 torpedoes and try to score as much as possible by sinking ships and submarines.
13 Your Break-even point is at the moving average score of all players, if your score is over the moving average, you are receiving your credits back
14 plus a part of the current treasure proportionally to your score, if your score is lower than the moving average, you are receiving
15 a part of your credits also proportionally to your score. At every play, the best score is registered also for the HIGHSCORE JACKPOT PAYOUT which is
16 paid every 100 play. In addition, every time you buy new torpedoes, 5% of the price will buy you HDX20 Token you can resell anytime, earning
17 you Ethereum or Tron(TRX) from the volume of any HDX20 POWERED GAMES as long as you hold them (visit hdx20.io or trx.hdx20.io for details).
18 
19 Play for the JACKPOT, Play for the TREASURE, Play for staking HDX20 TOKEN or Play for all at once...Your Choice!
20 
21 We wish you Good Luck!
22 
23 PAYOUTS DISTRIBUTION:
24 100% of TREASURE and JACKPOT are paid to Players
25 
26 at every Play:
27 
28  5% credited to player as HDX20 token
29 64% of losing credits to the running TREASURE
30 16% of losing credits to the running JACKPOT
31 15% of losing credits to the community of HDX20 gamers/holders distributed as price appreciation.
32  5% of losing credits to developer for running, developing and expanding the platform.
33 
34 
35 UPDATE:
36 
37 Version 2 is a MAJOR UPDATE with a total new payout system, no more campaign, no more 24H countdown, only instant play and rewards.
38 
39 
40 This product is copyrighted. Any unauthorized copy, modification, or use without express written consent from HyperDevbox is prohibited.
41 
42 Copyright 2018 HyperDevbox
43 
44 */
45 
46 
47 
48 
49 pragma solidity ^0.4.25;
50 
51 
52 interface HDX20Interface
53 {
54     function() payable external;
55     
56     
57     function buyTokenFromGame( address _customerAddress , address _referrer_address ) payable external returns(uint256);
58   
59     function payWithToken( uint256 _eth , address _player_address ) external returns(uint256);
60   
61     function appreciateTokenPrice() payable external;
62    
63     function totalSupply() external view returns(uint256); 
64     
65     function ethBalanceOf(address _customerAddress) external view returns(uint256);
66   
67     function balanceOf(address _playerAddress) external view returns(uint256);
68     
69     function sellingPrice( bool includeFees) external view returns(uint256);
70   
71 }
72 
73 
74 contract TorpedoLaunchGame
75 {
76      HDX20Interface private HDXcontract = HDX20Interface(0x8942a5995bd168f347f7ec58f25a54a9a064f882);
77      
78      using SafeMath for uint256;
79      using SafeMath128 for uint128;
80      
81      /*==============================
82     =            EVENTS            =
83     ==============================*/
84     event OwnershipTransferred(
85         
86          address previousOwner,
87          address nextOwner,
88           uint256 timeStamp
89          );
90          
91     event HDXcontractChanged(
92         
93          address previous,
94          address next,
95          uint256 timeStamp
96          );
97  
98     event onJackpotWin(
99         address customerAddress,
100         uint256 val
101        
102     );
103     
104     event onChangeAverageScore(
105         uint32 score
106        
107     );
108     
109     event onChangeJackpotCycle(
110         uint32 cycle
111        
112     );
113     
114     
115      event onChangeMaximumScore(
116         uint32 score
117        
118     );
119     
120      event onChangeTimeout(
121         uint32 timeout
122        
123     );
124 	    
125      event onWithdrawGains(
126         address customerAddress,
127         uint256 ethereumWithdrawn,
128         uint256 timeStamp
129     );
130     
131     event onNewScore(
132 		uint256       score,
133         address       customerAddress,
134         bool          newHighScore,
135         uint256		  val,				//winning
136         uint32        torpedoBatchMultiplier  //x1, x10, x100
137         
138     );
139              
140     event onBuyTorpedo(
141         address     customerAddress,
142         uint256     torpedoBatchID,
143         uint256     torpedoBatchBlockTimeout,  
144         uint256     nbToken,
145         uint32      torpedoBatchMultiplier  //x1, x10, x100
146         );    
147         
148         
149      event onMaintenance(
150         bool        mode,
151         uint256     timeStamp
152 
153         );    
154       
155         
156     event onChangeBlockTimeAverage(
157         
158          uint256 blocktimeavg
159          
160         );    
161         
162     event onChangeMinimumPrice(
163         
164          uint256 minimum,
165          uint256 timeStamp
166          );
167          
168     event onNewName(
169         
170          address     customerAddress,
171          bytes32     name,
172          uint256     timeStamp
173          );
174         
175     /*==============================
176     =            MODIFIERS         =
177     ==============================*/
178     modifier onlyOwner
179     {
180         require (msg.sender == owner );
181         _;
182     }
183     
184     modifier onlyFromHDXToken
185     {
186         require (msg.sender == address( HDXcontract ));
187         _;
188     }
189    
190      modifier onlyDirectTransaction
191     {
192         require (msg.sender == tx.origin);
193         _;
194     }
195    
196    
197   
198     
199     modifier isMaintenance
200     {
201         require (maintenanceMode==true);
202         _;
203     }
204     
205      modifier isNotMaintenance
206     {
207         require (maintenanceMode==false);
208         _;
209     }
210    
211   
212     address public owner;
213   
214    
215     address public signerAuthority = 0xf77444cE64f3F46ba6b63F6b9411dF9c589E3319;
216    
217     
218     
219 
220     constructor () public
221     {
222         owner = msg.sender;
223        
224 		//set the average point to the maximum / 5 extended score
225 		
226 		uint32 maximumScore = (1350+70)*15;
227 	   	   
228 		GameRoundData.extraData[2] = maximumScore/5;
229 		GameRoundData.extraData[3] = 100; //default jackpot cycle
230         GameRoundData.extraData[4] = maximumScore;
231         GameRoundData.extraData[5] = 60*60; //1 hour by default
232         
233         if ( address(this).balance > 0)
234         {
235             owner.transfer( address(this).balance );
236         }
237     }
238     
239     function changeOwner(address _nextOwner) public
240     onlyOwner
241     {
242         require (_nextOwner != owner);
243         require(_nextOwner != address(0));
244          
245         emit OwnershipTransferred(owner, _nextOwner , now);
246          
247         owner = _nextOwner;
248     }
249     
250     function changeSigner(address _nextSigner) public
251     onlyOwner
252     {
253         require (_nextSigner != signerAuthority);
254         require(_nextSigner != address(0));
255       
256         signerAuthority = _nextSigner;
257     }
258     
259     function changeHDXcontract(address _next) public
260     onlyOwner
261     {
262         require (_next != address( HDXcontract ));
263         require( _next != address(0));
264          
265         emit HDXcontractChanged(address(HDXcontract), _next , now);
266          
267         HDXcontract  = HDX20Interface( _next);
268     }
269   
270   
271     
272     function changeBlockTimeAverage( uint256 blocktimeavg) public
273     onlyOwner
274     {
275         require ( blocktimeavg>0 );
276         
277        
278         blockTimeAverage = blocktimeavg;
279         
280         emit onChangeBlockTimeAverage( blockTimeAverage );
281          
282     }
283     
284     
285     //in case we need to reset the game difficulty 
286     function changeAverageScore( uint32 score) public
287     onlyOwner
288     {
289        
290         GameRoundData.extraData[2] = score;
291         
292         emit onChangeAverageScore( score );
293          
294     }
295     
296     //in case we need to adjust if players prefer a fast jackpot over quantity or opposite 
297     function changeJackpotCycle( uint32 cycle) public
298     onlyOwner
299     {
300         //let's stay reasonnable
301         require( cycle>0 && cycle<=1000);
302         
303        
304         GameRoundData.extraData[3] = cycle;
305         
306         emit onChangeJackpotCycle( cycle );
307          
308     }
309     
310     //in case we want to add new ships, new bonus item to the game, etc....we need to adjust the maximum score
311     function changeMaximumScore( uint32 score) public
312     onlyOwner
313     {
314         //let's stay reasonnable
315         require( score > 4000);
316         
317         GameRoundData.extraData[4] = score;
318        
319        //adjust the average score also
320         changeAverageScore( score / 5 );
321         
322         
323         emit onChangeMaximumScore( score );
324          
325     }
326     
327      //in case we need to change the timeout because of slower or faster network (in seconds) 
328     function changeTimeOut( uint32 timeout) public
329     onlyOwner
330     {
331        
332         GameRoundData.extraData[5] = timeout;
333         
334         emit onChangeTimeout( timeout );
335          
336     }
337     
338     function enableMaintenance() public
339     onlyOwner
340     {
341         maintenanceMode = true;
342         
343         emit onMaintenance( maintenanceMode , now);
344         
345     }
346 
347     function disableMaintenance() public
348     onlyOwner
349     {
350       
351         maintenanceMode = false;
352         
353         emit onMaintenance( maintenanceMode , now);
354         
355        
356       
357     }
358     
359   
360     function changeMinimumPrice( uint256 newmini) public
361     onlyOwner
362     {
363       
364       if (newmini>0)
365       {
366           minimumSharePrice = newmini;
367       }
368        
369       emit onChangeMinimumPrice( newmini , now ); 
370     }
371     
372     
373      /*================================
374     =       GAMES VARIABLES         =
375     ================================*/
376     
377     struct PlayerData_s
378     {
379    
380         uint256 chest;  
381         uint256 payoutsTo;
382        
383 		//credit locked until we validate the score
384 		uint256 lockedCredit;	
385 		
386         uint256         torpedoBatchID;         
387         uint256         torpedoBatchBlockTimeout;   
388 
389 		uint32[1]		packedData;		//[0] = torpedomultiplier;
390 						
391     }
392     
393     
394     struct GameRoundData_s
395     {
396 	   
397 	   uint256				jackpotAmount;
398 	   uint256				treasureAmount;
399 	   address				currentJackpotWinner;
400 	          
401        uint256              hdx20AppreciationPayout;
402        uint256              devAppreciationPayout;
403 	   
404        //********************************************************************************************
405 	   
406 	   uint32[6]			extraData;		//[0] = jackpot current highscore
407 											//[1] = jackpot turn (start at 0 to jackpot cycle )
408 											//[2] = scoreAverage to beat
409 			                                //[3] = jackpot cycle (default 100)								
410 	                                        //[4] = maximum score possible in the game
411 	                                        //[5] = timeout/torpedo score in seconds
412   
413     }
414       
415    
416     mapping (address => PlayerData_s)   private PlayerData;
417        
418     GameRoundData_s   private GameRoundData;
419     
420     mapping( address => bytes32) private registeredNames;
421        
422     bool        private maintenanceMode=false;     
423     
424     uint8 constant private HDX20BuyFees = 5;
425      
426     uint8 constant private DevFees = 5;
427 	uint8 constant private AppreciationFees = 15;		
428 	uint8 constant private JackpotAppreciation = 16;
429 	uint8 constant private TreasureAppreciation = 64;
430    
431     uint256 constant internal magnitude = 1e18;
432      
433     uint256 private minimumSharePrice = 0.01 ether;
434     
435     uint256 private blockTimeAverage = 15;                
436 
437 
438     uint256 constant thresholdForAppreciation = 0.05 ether;
439       
440     /*================================
441     =       PUBLIC FUNCTIONS         =
442     ================================*/
443     
444     //fallback will be called only from the HDX token contract to fund the game from customers's HDX20
445     
446      function()
447      payable
448      public
449      onlyFromHDXToken 
450     {
451        
452       
453       
454           
455     }
456     
457     
458     function ChargeTreasure() public payable
459     {
460 		uint256 _val = msg.value;
461 		
462 		GameRoundData.jackpotAmount = GameRoundData.jackpotAmount.add( _val.mul( 20 ) / 100 );
463 		
464 		GameRoundData.treasureAmount = GameRoundData.treasureAmount.add( _val.mul( 80 ) / 100 );
465 				   
466     }
467 	
468 	function AddJackpotTreasure( uint256 _val ) private
469 	{
470 		//add to jackpot and treasure
471 		GameRoundData.jackpotAmount = GameRoundData.jackpotAmount.add( _val.mul( JackpotAppreciation ) / 100 );
472 		
473 		GameRoundData.treasureAmount = GameRoundData.treasureAmount.add( _val.mul( TreasureAppreciation ) / 100 );
474 		
475 		//now HDX20 appreciation and dev account
476 		
477 		uint256 _appreciation = SafeMath.mul( _val , AppreciationFees) / 100; 
478           
479         uint256 _dev = SafeMath.mul( _val , DevFees) / 100;  
480 		
481 		_dev = _dev.add( GameRoundData.devAppreciationPayout );
482 		
483 		if (_dev>= thresholdForAppreciation )
484 		{
485 			GameRoundData.devAppreciationPayout = 0;
486 			
487 			HDXcontract.buyTokenFromGame.value( _dev )( owner , address(0));	
488 		}
489 		else
490 		{
491 			 GameRoundData.devAppreciationPayout = _dev;
492 		}
493 	
494 		_appreciation = _appreciation.add( GameRoundData.hdx20AppreciationPayout );
495 		
496 		if (_appreciation>= thresholdForAppreciation)
497 		{
498 			GameRoundData.hdx20AppreciationPayout = 0;
499 			
500 			HDXcontract.appreciateTokenPrice.value( _appreciation )();
501 		}
502 		else
503 		{
504 			GameRoundData.hdx20AppreciationPayout = _appreciation;
505 		}
506 		
507 	}
508 	
509     
510     
511     
512     function ValidTorpedoScore( int256 score, uint256 torpedoBatchID , bytes32 r , bytes32 s , uint8 v) public
513     onlyDirectTransaction
514     {
515         address _customer_address = msg.sender;
516          
517         require( maintenanceMode==false);
518   
519         GameVar_s memory gamevar;
520         gamevar.score = score;
521         gamevar.torpedoBatchID = torpedoBatchID;
522         gamevar.r = r;
523         gamevar.s = s;
524         gamevar.v = v;
525    
526         coreValidTorpedoScore( _customer_address , gamevar  );
527     }
528     
529     
530     struct GameVar_s
531     {
532      
533         bool madehigh;
534               
535                
536         uint256  torpedoBatchID;
537        
538  	    int256   score;
539 		uint256  scoreMultiplied;
540 		
541 		uint32   multiplier;
542 		
543         bytes32  r;
544         bytes32  s;
545         uint8    v;
546     }
547     
548 	function payJackpot() private
549 	{
550 		address _winner = GameRoundData.currentJackpotWinner;
551 		uint256 _j = GameRoundData.jackpotAmount;
552 		
553 		
554 		if (_winner != address(0))
555 		{
556 			PlayerData[ _winner ].chest = PlayerData[ _winner ].chest.add( _j ); 
557 		
558 		
559     		GameRoundData.currentJackpotWinner = address(0);
560     		GameRoundData.jackpotAmount = 0;
561     		//turn to 0
562     		GameRoundData.extraData[1] = 0;
563     		//highscore to 0
564     		GameRoundData.extraData[0] = 0;
565     		
566     		emit onJackpotWin( _winner , _j  );
567 		}
568 		
569 	}
570   
571     
572     function coreValidTorpedoScore( address _player_address , GameVar_s gamevar) private
573     {
574     
575         PlayerData_s storage  _PlayerData = PlayerData[ _player_address];
576                 
577         require((gamevar.torpedoBatchID != 0) && (gamevar.torpedoBatchID == _PlayerData.torpedoBatchID) && ( _PlayerData.lockedCredit>0 ));
578                 
579         gamevar.madehigh = false;
580 
581 	
582         if (block.number>=_PlayerData.torpedoBatchBlockTimeout || (ecrecover(keccak256(abi.encodePacked( gamevar.score,gamevar.torpedoBatchID )) , gamevar.v, gamevar.r, gamevar.s) != signerAuthority))
583         {
584             gamevar.score = 0;
585         }
586 		
587 		if (gamevar.score<0) gamevar.score = 0;
588 				            
589         gamevar.scoreMultiplied = uint256(gamevar.score) * uint256(_PlayerData.packedData[0]);
590         
591         if (gamevar.score>0xffffffff) gamevar.score = 0xffffffff;
592         if (gamevar.scoreMultiplied>0xffffffff) gamevar.scoreMultiplied = 0xffffffff;
593    		
594 		//new jackpot highscore
595 		if (gamevar.scoreMultiplied > uint256( GameRoundData.extraData[0] ))
596 		{
597 			GameRoundData.extraData[0] = uint32( gamevar.scoreMultiplied );
598 			
599 			GameRoundData.currentJackpotWinner = _player_address;
600 			
601  			gamevar.madehigh = true;
602 			 
603 		}
604 		
605 		//jackpot turn++
606 		 GameRoundData.extraData[1]++;
607 		
608 		//time to pay jackpot cycle ?	
609 		if (GameRoundData.extraData[1]>=GameRoundData.extraData[3])
610 		{
611 			payJackpot();
612 		}
613 		
614 	
615 		//we need to deal with scores not multiplied here	
616 		
617 		uint256 _winning =0;
618 		uint256 _average = uint256( GameRoundData.extraData[2]);
619 		uint256 _top = _average *2;
620 		
621 		uint256 _score = uint256(gamevar.score);
622 		
623 		if (_score >=_average )
624 		{
625 			//more or equal than average score 
626 			
627 			_winning = _PlayerData.lockedCredit;
628 			
629 			//how much from the treasure
630 					
631 			if (_score > _top) _score = _top;
632 		
633 			_score -= _average;
634 						
635 			uint256 _gains = GameRoundData.treasureAmount.mul( _score * uint256( _PlayerData.packedData[0] )) / 100;
636 			
637 			_gains /= (1+(_top - _average));
638 			
639 			
640 			//adjust treasure
641 			GameRoundData.treasureAmount = GameRoundData.treasureAmount.sub( _gains );
642 									
643 			_winning = _winning.add( _gains );
644 		}
645 		else
646 		{
647 			//less than average score
648 		
649 			if (_average>0)
650 			{
651 				_winning = _PlayerData.lockedCredit.mul( _score ) / _average;
652 			}
653 		}
654 		
655 		//credit the player for what is won
656 		_PlayerData.chest = _PlayerData.chest.add( _winning );
657 		
658 		
659 		//loosing some ?
660 		
661 		if (_PlayerData.lockedCredit> _winning)
662 		{
663 			
664 			AddJackpotTreasure( _PlayerData.lockedCredit - _winning );
665 		}
666 		
667 		//update average, we shall not overflow :)
668 				
669 		_score = uint256(gamevar.score);
670 		
671 		uint32 maximumScore = GameRoundData.extraData[4];
672 		
673 		
674 		//this has to be significatf and not just someone trying to cheat the system 
675 		if (_score>_average/3)
676 		{
677 			_score = _score.add( _average * 99 );
678 			_score /= 100;
679 			
680 			if (_score< maximumScore/8 ) _score = maximumScore/8;
681 			if (_score > maximumScore/2) _score = maximumScore/2;
682 			
683 			GameRoundData.extraData[2] = uint32( _score );
684 		}
685 
686 		//		
687    
688         //ok reset it so we can get a new one
689         _PlayerData.torpedoBatchID = 0;
690         _PlayerData.lockedCredit = 0;
691 		
692         emit onNewScore( gamevar.scoreMultiplied , _player_address , gamevar.madehigh , _winning , _PlayerData.packedData[0] );
693 
694 
695     }
696     
697     
698     function BuyTorpedoWithDividends( uint256 eth , int256 score, uint256 torpedoBatchID,  address _referrer_address , bytes32 r , bytes32 s , uint8 v) public
699     onlyDirectTransaction
700     {
701         
702         require( maintenanceMode==false  && (eth==minimumSharePrice || eth==minimumSharePrice*10 || eth==minimumSharePrice*100) );
703   
704         address _customer_address = msg.sender;
705         
706         GameVar_s memory gamevar;
707         gamevar.score = score;
708         gamevar.torpedoBatchID = torpedoBatchID;
709         gamevar.r = r;
710         gamevar.s = s;
711         gamevar.v = v;
712         
713       
714         gamevar.multiplier =uint32( eth / minimumSharePrice);
715         
716         eth = HDXcontract.payWithToken( eth , _customer_address );
717        
718         require( eth>0 );
719         
720          
721         CoreBuyTorpedo( _customer_address , eth , _referrer_address , gamevar );
722         
723        
724     }
725     
726     function BuyName( bytes32 name ) public payable
727     {
728         address _customer_address = msg.sender;
729         uint256 eth = msg.value; 
730         
731         require( maintenanceMode==false  && (eth==minimumSharePrice*10));
732         
733         //50% for the community
734         //50% for the developer account
735         
736         eth /= 2;
737         
738         HDXcontract.buyTokenFromGame.value( eth )( owner , address(0));
739        
740         HDXcontract.appreciateTokenPrice.value( eth )();
741         
742         registeredNames[ _customer_address ] = name;
743         
744         emit onNewName( _customer_address , name , now );
745     }
746     
747     function BuyTorpedo( int256 score, uint256 torpedoBatchID, address _referrer_address , bytes32 r , bytes32 s , uint8 v ) public payable
748     onlyDirectTransaction
749     {
750      
751         address _customer_address = msg.sender;
752         uint256 eth = msg.value;
753         
754         require( maintenanceMode==false  && (eth==minimumSharePrice || eth==minimumSharePrice*10 || eth==minimumSharePrice*100));
755    
756         GameVar_s memory gamevar;
757         gamevar.score = score;
758         gamevar.torpedoBatchID = torpedoBatchID;
759         gamevar.r = r;
760         gamevar.s = s;
761         gamevar.v = v;
762         
763        
764         gamevar.multiplier =uint32( eth / minimumSharePrice);
765    
766         CoreBuyTorpedo( _customer_address , eth , _referrer_address, gamevar);
767      
768     }
769     
770     /*================================
771     =       CORE BUY FUNCTIONS       =
772     ================================*/
773     
774     function CoreBuyTorpedo( address _player_address , uint256 eth ,  address _referrer_address , GameVar_s gamevar) private
775     {
776     
777         PlayerData_s storage  _PlayerData = PlayerData[ _player_address];
778             
779         
780         //we need to validate the score before buying a torpedo batch
781         if (gamevar.torpedoBatchID !=0 || _PlayerData.torpedoBatchID !=0)
782         {
783              coreValidTorpedoScore( _player_address , gamevar);
784         }
785         
786         
787         //if we can continue then everything is fine let's create the new torpedo batch
788         
789         _PlayerData.packedData[0] = gamevar.multiplier;
790         _PlayerData.torpedoBatchBlockTimeout = block.number + (uint256(GameRoundData.extraData[5]) / blockTimeAverage);
791         _PlayerData.torpedoBatchID = uint256((keccak256(abi.encodePacked( block.number, _player_address , address(this)))));
792         
793         
794         //HDX20BuyFees
795         uint256 _tempo = (eth.mul(HDX20BuyFees)) / 100;
796 		
797 		_PlayerData.lockedCredit =  eth - _tempo;	//total - hdx20
798 		        
799         uint256 _nb_token =   HDXcontract.buyTokenFromGame.value( _tempo )( _player_address , _referrer_address);
800         
801         
802         emit onBuyTorpedo( _player_address, _PlayerData.torpedoBatchID , _PlayerData.torpedoBatchBlockTimeout, _nb_token,  _PlayerData.packedData[0]);
803             
804         
805     }
806     
807    
808     
809     function get_Gains(address _player_address) private view
810     returns( uint256)
811     {
812        
813         uint256 _gains = PlayerData[ _player_address ].chest;
814         
815         if (_gains > PlayerData[ _player_address].payoutsTo)
816         {
817             _gains -= PlayerData[ _player_address].payoutsTo;
818         }
819         else _gains = 0;
820      
821     
822         return( _gains );
823         
824     }
825     
826     
827     function WithdrawGains() public 
828    
829     {
830         address _customer_address = msg.sender;
831         
832         uint256 _gains = get_Gains( _customer_address );
833         
834         require( _gains>0);
835         
836         PlayerData[ _customer_address ].payoutsTo = PlayerData[ _customer_address ].payoutsTo.add( _gains );
837         
838       
839         emit onWithdrawGains( _customer_address , _gains , now);
840         
841         _customer_address.transfer( _gains );
842         
843         
844     }
845     
846    
847     
848    
849    
850   
851   
852     
853      /*================================
854     =  VIEW AND HELPERS FUNCTIONS    =
855     ================================*/
856   
857     
858     function view_get_Treasure() public
859     view
860     returns(uint256)
861     {
862       
863       return( GameRoundData.treasureAmount );  
864     }
865 	
866 	function view_get_Jackpot() public
867     view
868     returns(uint256)
869     {
870       
871       return( GameRoundData.jackpotAmount );  
872     }
873  
874     function view_get_gameData() public
875     view
876     returns( uint256 treasure,
877 			 uint256 jackpot,
878 			 uint32  highscore ,
879 			 address highscore_address ,
880 			 bytes32 highscore_name,
881 			 uint32  highscore_turn,
882 			 uint32  score_average,
883 			 uint256 torpedoBatchID ,
884 			 uint32 torpedoBatchMultiplier ,
885 			 uint256 torpedoBatchBlockTimeout   )
886     {
887         address _player_address = msg.sender;
888 		
889 		treasure = GameRoundData.treasureAmount;
890 		jackpot = GameRoundData.jackpotAmount;
891 		highscore = GameRoundData.extraData[0];
892 		highscore_address = GameRoundData.currentJackpotWinner;
893 		highscore_name = view_get_registeredNames( GameRoundData.currentJackpotWinner  );
894 		highscore_turn = GameRoundData.extraData[1];
895 		score_average = GameRoundData.extraData[2];
896 		      
897         torpedoBatchID = PlayerData[_player_address].torpedoBatchID;
898         torpedoBatchMultiplier = PlayerData[_player_address].packedData[0];
899         torpedoBatchBlockTimeout = PlayerData[_player_address].torpedoBatchBlockTimeout;
900        
901     }
902   
903        
904   
905     
906     function view_get_Gains()
907     public
908     view
909     returns( uint256 gains)
910     {
911         
912         address _player_address = msg.sender;
913    
914       
915         uint256 _gains = PlayerData[ _player_address ].chest;
916         
917         if (_gains > PlayerData[ _player_address].payoutsTo)
918         {
919             _gains -= PlayerData[ _player_address].payoutsTo;
920         }
921         else _gains = 0;
922      
923     
924         return( _gains );
925         
926     }
927   
928   
929     
930     function view_get_gameStates() public 
931     view
932     returns( uint256 minimumshare ,
933 		     uint256 blockNumberCurrent ,
934 			 uint256 blockTimeAvg ,
935 			 uint32  highscore ,
936 			 address highscore_address ,
937 			 bytes32 highscore_name,
938 			 uint32  highscore_turn,
939 			 uint256 jackpot,
940 			 bytes32 myname,
941 			 uint32  jackpotCycle)
942     {
943        
944         
945         return( minimumSharePrice ,  block.number , blockTimeAverage , GameRoundData.extraData[0] , GameRoundData.currentJackpotWinner , view_get_registeredNames( GameRoundData.currentJackpotWinner  ) , GameRoundData.extraData[1] , GameRoundData.jackpotAmount,  view_get_registeredNames(msg.sender) , GameRoundData.extraData[3]);
946     }
947     
948     function view_get_pendingHDX20Appreciation()
949     public
950     view
951     returns(uint256)
952     {
953         return GameRoundData.hdx20AppreciationPayout;
954     }
955     
956     function view_get_pendingDevAppreciation()
957     public
958     view
959     returns(uint256)
960     {
961         return GameRoundData.devAppreciationPayout;
962     }
963   
964  
965  
966     function totalEthereumBalance()
967     public
968     view
969     returns(uint256)
970     {
971         return address(this).balance;
972     }
973     
974     function view_get_maintenanceMode()
975     public
976     view
977     returns(bool)
978     {
979         return( maintenanceMode);
980     }
981     
982     function view_get_blockNumbers()
983     public
984     view
985     returns( uint256 b1 )
986     {
987         return( block.number);
988         
989     }
990     
991     function view_get_registeredNames(address _player)
992     public
993     view
994     returns( bytes32)
995     {
996         
997         return( registeredNames[ _player ]);
998     }
999     
1000    
1001 }
1002 
1003 
1004 library SafeMath {
1005     
1006    
1007     function mul(uint256 a, uint256 b) 
1008         internal 
1009         pure 
1010         returns (uint256 c) 
1011     {
1012         if (a == 0) {
1013             return 0;
1014         }
1015         c = a * b;
1016         require(c / a == b);
1017         return c;
1018     }
1019 
1020    
1021     function sub(uint256 a, uint256 b)
1022         internal
1023         pure
1024         returns (uint256) 
1025     {
1026         require(b <= a);
1027         return a - b;
1028     }
1029 
1030    
1031     function add(uint256 a, uint256 b)
1032         internal
1033         pure
1034         returns (uint256 c) 
1035     {
1036         c = a + b;
1037         require(c >= a);
1038         return c;
1039     }
1040     
1041    
1042     
1043   
1044     
1045    
1046 }
1047 
1048 
1049 library SafeMath128 {
1050     
1051    
1052     function mul(uint128 a, uint128 b) 
1053         internal 
1054         pure 
1055         returns (uint128 c) 
1056     {
1057         if (a == 0) {
1058             return 0;
1059         }
1060         c = a * b;
1061         require(c / a == b);
1062         return c;
1063     }
1064 
1065    
1066     function sub(uint128 a, uint128 b)
1067         internal
1068         pure
1069         returns (uint128) 
1070     {
1071         require(b <= a);
1072         return a - b;
1073     }
1074 
1075    
1076     function add(uint128 a, uint128 b)
1077         internal
1078         pure
1079         returns (uint128 c) 
1080     {
1081         c = a + b;
1082         require(c >= a);
1083         return c;
1084     }
1085     
1086    
1087     
1088   
1089     
1090    
1091 }