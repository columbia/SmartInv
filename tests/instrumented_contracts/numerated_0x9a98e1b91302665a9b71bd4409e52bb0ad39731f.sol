1 /*
2 
3 Introducing "TORPEDO LAUNCH" Version 2.1, with a minor update on payout system
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
37 Version 2.1 is a UPDATE on the payout system to distribute a percentage of the treasure for a better distribution among all players  
38 (previous version was distributing the full treasure at average_score *2)
39 
40 
41 This product is copyrighted. Any unauthorized copy, modification, or use without express written consent from HyperDevbox is prohibited.
42 
43 Copyright 2018 HyperDevbox
44 
45 */
46 
47 
48 
49 
50 pragma solidity ^0.4.25;
51 
52 
53 interface HDX20Interface
54 {
55     function() payable external;
56     
57     
58     function buyTokenFromGame( address _customerAddress , address _referrer_address ) payable external returns(uint256);
59   
60     function payWithToken( uint256 _eth , address _player_address ) external returns(uint256);
61   
62     function appreciateTokenPrice() payable external;
63    
64     function totalSupply() external view returns(uint256); 
65     
66     function ethBalanceOf(address _customerAddress) external view returns(uint256);
67   
68     function balanceOf(address _playerAddress) external view returns(uint256);
69     
70     function sellingPrice( bool includeFees) external view returns(uint256);
71   
72 }
73 
74 
75 contract TorpedoLaunchGame
76 {
77      HDX20Interface private HDXcontract = HDX20Interface(0x8942a5995bd168f347f7ec58f25a54a9a064f882);
78      
79      using SafeMath for uint256;
80      using SafeMath128 for uint128;
81      
82      /*==============================
83     =            EVENTS            =
84     ==============================*/
85     event OwnershipTransferred(
86         
87          address previousOwner,
88          address nextOwner,
89           uint256 timeStamp
90          );
91          
92     event HDXcontractChanged(
93         
94          address previous,
95          address next,
96          uint256 timeStamp
97          );
98  
99     event onJackpotWin(
100         address customerAddress,
101         uint256 val
102        
103     );
104     
105     event onChangeAverageScore(
106         uint32 score
107        
108     );
109     
110     event onChangeJackpotCycle(
111         uint32 cycle
112        
113     );
114     
115     
116      event onChangeMaximumScore(
117         uint32 score
118        
119     );
120     
121      event onChangeTimeout(
122         uint32 timeout
123        
124     );
125     
126       event onChangePercentageTreasure(
127         uint32 percentage
128        
129     );
130 	    
131      event onWithdrawGains(
132         address customerAddress,
133         uint256 ethereumWithdrawn,
134         uint256 timeStamp
135     );
136     
137     event onNewScore(
138 		uint256       score,
139         address       customerAddress,
140         bool          newHighScore,
141         uint256		  val,				//winning
142         uint32        torpedoBatchMultiplier  //x1, x10, x100
143         
144     );
145              
146     event onBuyTorpedo(
147         address     customerAddress,
148         uint256     torpedoBatchID,
149         uint256     torpedoBatchBlockTimeout,  
150         uint256     nbToken,
151         uint32      torpedoBatchMultiplier  //x1, x10, x100
152         );    
153         
154         
155      event onMaintenance(
156         bool        mode,
157         uint256     timeStamp
158 
159         );    
160       
161         
162     event onChangeBlockTimeAverage(
163         
164          uint256 blocktimeavg
165          
166         );    
167         
168     event onChangeMinimumPrice(
169         
170          uint256 minimum,
171          uint256 timeStamp
172          );
173          
174     event onNewName(
175         
176          address     customerAddress,
177          bytes32     name,
178          uint256     timeStamp
179          );
180         
181     /*==============================
182     =            MODIFIERS         =
183     ==============================*/
184     modifier onlyOwner
185     {
186         require (msg.sender == owner );
187         _;
188     }
189     
190     modifier onlyFromHDXToken
191     {
192         require (msg.sender == address( HDXcontract ));
193         _;
194     }
195    
196      modifier onlyDirectTransaction
197     {
198         require (msg.sender == tx.origin);
199         _;
200     }
201    
202    
203   
204     
205     modifier isMaintenance
206     {
207         require (maintenanceMode==true);
208         _;
209     }
210     
211      modifier isNotMaintenance
212     {
213         require (maintenanceMode==false);
214         _;
215     }
216    
217   
218     address public owner;
219   
220    
221     address public signerAuthority = 0xf77444cE64f3F46ba6b63F6b9411dF9c589E3319;
222    
223     
224     
225 
226     constructor () public
227     {
228         owner = msg.sender;
229        
230 		//set the average point to the maximum / 5 extended score
231 		
232 		uint32 maximumScore = (1350+70)*15;
233 	   	   
234 		GameRoundData.extraData[2] = maximumScore/5;
235 		GameRoundData.extraData[3] = 100; //default jackpot cycle
236         GameRoundData.extraData[4] = maximumScore;
237         GameRoundData.extraData[5] = 60*60; //1 hour by default
238         GameRoundData.extraData[6] = 10; //10 percents default
239         
240         if ( address(this).balance > 0)
241         {
242             owner.transfer( address(this).balance );
243         }
244     }
245     
246     function changeOwner(address _nextOwner) public
247     onlyOwner
248     {
249         require (_nextOwner != owner);
250         require(_nextOwner != address(0));
251          
252         emit OwnershipTransferred(owner, _nextOwner , now);
253          
254         owner = _nextOwner;
255     }
256     
257     function changeSigner(address _nextSigner) public
258     onlyOwner
259     {
260         require (_nextSigner != signerAuthority);
261         require(_nextSigner != address(0));
262       
263         signerAuthority = _nextSigner;
264     }
265     
266     function changeHDXcontract(address _next) public
267     onlyOwner
268     {
269         require (_next != address( HDXcontract ));
270         require( _next != address(0));
271          
272         emit HDXcontractChanged(address(HDXcontract), _next , now);
273          
274         HDXcontract  = HDX20Interface( _next);
275     }
276   
277   
278     
279     function changeBlockTimeAverage( uint256 blocktimeavg) public
280     onlyOwner
281     {
282         require ( blocktimeavg>0 );
283         
284        
285         blockTimeAverage = blocktimeavg;
286         
287         emit onChangeBlockTimeAverage( blockTimeAverage );
288          
289     }
290     
291     
292     //in case we need to reset the game difficulty 
293     function changeAverageScore( uint32 score) public
294     onlyOwner
295     {
296        
297         GameRoundData.extraData[2] = score;
298         
299         emit onChangeAverageScore( score );
300          
301     }
302     
303     //in case we need to adjust if players prefer a fast jackpot over quantity or opposite 
304     function changeJackpotCycle( uint32 cycle) public
305     onlyOwner
306     {
307         //let's stay reasonnable
308         require( cycle>0 && cycle<=1000);
309         
310        
311         GameRoundData.extraData[3] = cycle;
312         
313         emit onChangeJackpotCycle( cycle );
314          
315     }
316     
317     //in case we want to add new ships, new bonus item to the game, etc....we need to adjust the maximum score
318     function changeMaximumScore( uint32 score) public
319     onlyOwner
320     {
321         //let's stay reasonnable
322         require( score > 4000);
323         
324         GameRoundData.extraData[4] = score;
325        
326       
327         emit onChangeMaximumScore( score );
328          
329     }
330     
331      //in case we need to change the timeout because of slower or faster network (in seconds) 
332     function changeTimeOut( uint32 timeout) public
333     onlyOwner
334     {
335        
336         GameRoundData.extraData[5] = timeout;
337         
338         emit onChangeTimeout( timeout );
339          
340     }
341     
342     //we want to be able to tune the game and select a different percentage of the treasure to be giving per play at maximum
343     //also we can use this to make contest and special event etc....
344     function changePercentageTreasure( uint32 percentage) public
345     onlyOwner
346     {
347         require( percentage > 0 && percentage<=100);
348         
349         GameRoundData.extraData[6] = percentage;
350         
351         emit onChangePercentageTreasure( percentage );
352          
353     }
354     
355     function enableMaintenance() public
356     onlyOwner
357     {
358         maintenanceMode = true;
359         
360         emit onMaintenance( maintenanceMode , now);
361         
362     }
363 
364     function disableMaintenance() public
365     onlyOwner
366     {
367       
368         maintenanceMode = false;
369         
370         emit onMaintenance( maintenanceMode , now);
371         
372        
373       
374     }
375     
376   
377     function changeMinimumPrice( uint256 newmini) public
378     onlyOwner
379     {
380       
381       if (newmini>0)
382       {
383           minimumSharePrice = newmini;
384       }
385        
386       emit onChangeMinimumPrice( newmini , now ); 
387     }
388     
389     
390      /*================================
391     =       GAMES VARIABLES         =
392     ================================*/
393     
394     struct PlayerData_s
395     {
396    
397         uint256 chest;  
398         uint256 payoutsTo;
399        
400 		//credit locked until we validate the score
401 		uint256 lockedCredit;	
402 		
403         uint256         torpedoBatchID;         
404         uint256         torpedoBatchBlockTimeout;   
405 
406 		uint32[1]		packedData;		//[0] = torpedomultiplier;
407 						
408     }
409     
410     
411     struct GameRoundData_s
412     {
413 	   
414 	   uint256				jackpotAmount;
415 	   uint256				treasureAmount;
416 	   address				currentJackpotWinner;
417 	          
418        uint256              hdx20AppreciationPayout;
419        uint256              devAppreciationPayout;
420 	   
421        //********************************************************************************************
422 	   
423 	   uint32[7]			extraData;		//[0] = jackpot current highscore
424 											//[1] = jackpot turn (start at 0 to jackpot cycle )
425 											//[2] = scoreAverage to beat
426 			                                //[3] = jackpot cycle (default 100)								
427 	                                        //[4] = maximum score possible in the game
428 	                                        //[5] = timeout/torpedo score in seconds
429 	                                        //[6] = percentage treasure per play
430   
431     }
432       
433    
434     mapping (address => PlayerData_s)   private PlayerData;
435        
436     GameRoundData_s   private GameRoundData;
437     
438     mapping( address => bytes32) private registeredNames;
439        
440     bool        private maintenanceMode=false;     
441     
442     uint8 constant private HDX20BuyFees = 5;
443      
444     uint8 constant private DevFees = 5;
445 	uint8 constant private AppreciationFees = 15;		
446 	uint8 constant private JackpotAppreciation = 16;
447 	uint8 constant private TreasureAppreciation = 64;
448    
449     uint256 constant internal magnitude = 1e18;
450      
451     uint256 private minimumSharePrice = 0.01 ether;
452     
453     uint256 private blockTimeAverage = 15;                
454 
455 
456     uint256 constant thresholdForAppreciation = 0.05 ether;
457       
458     /*================================
459     =       PUBLIC FUNCTIONS         =
460     ================================*/
461     
462     //fallback will be called only from the HDX token contract to fund the game from customers's HDX20
463     
464      function()
465      payable
466      public
467      onlyFromHDXToken 
468     {
469        
470       
471       
472           
473     }
474     
475      function ChargeJackpot() public payable
476     {
477 		uint256 _val = msg.value;
478 		
479 		GameRoundData.jackpotAmount = GameRoundData.jackpotAmount.add( _val );
480 	
481     }
482     
483     function ChargeTreasure() public payable
484     {
485 		uint256 _val = msg.value;
486 	
487 		
488 		GameRoundData.treasureAmount = GameRoundData.treasureAmount.add( _val );
489 				   
490     }
491 	
492 	function AddJackpotTreasure( uint256 _val ) private
493 	{
494 		//add to jackpot and treasure
495 		GameRoundData.jackpotAmount = GameRoundData.jackpotAmount.add( _val.mul( JackpotAppreciation ) / 100 );
496 		
497 		GameRoundData.treasureAmount = GameRoundData.treasureAmount.add( _val.mul( TreasureAppreciation ) / 100 );
498 		
499 		//now HDX20 appreciation and dev account
500 		
501 		uint256 _appreciation = SafeMath.mul( _val , AppreciationFees) / 100; 
502           
503         uint256 _dev = SafeMath.mul( _val , DevFees) / 100;  
504 		
505 		_dev = _dev.add( GameRoundData.devAppreciationPayout );
506 		
507 		if (_dev>= thresholdForAppreciation )
508 		{
509 			GameRoundData.devAppreciationPayout = 0;
510 			
511 			HDXcontract.buyTokenFromGame.value( _dev )( owner , address(0));	
512 		}
513 		else
514 		{
515 			 GameRoundData.devAppreciationPayout = _dev;
516 		}
517 	
518 		_appreciation = _appreciation.add( GameRoundData.hdx20AppreciationPayout );
519 		
520 		if (_appreciation>= thresholdForAppreciation)
521 		{
522 			GameRoundData.hdx20AppreciationPayout = 0;
523 			
524 			HDXcontract.appreciateTokenPrice.value( _appreciation )();
525 		}
526 		else
527 		{
528 			GameRoundData.hdx20AppreciationPayout = _appreciation;
529 		}
530 		
531 	}
532 	
533     
534     
535     
536     function ValidTorpedoScore( int256 score, uint256 torpedoBatchID , bytes32 r , bytes32 s , uint8 v) public
537     onlyDirectTransaction
538     {
539         address _customer_address = msg.sender;
540          
541         require( maintenanceMode==false);
542   
543         GameVar_s memory gamevar;
544         gamevar.score = score;
545         gamevar.torpedoBatchID = torpedoBatchID;
546         gamevar.r = r;
547         gamevar.s = s;
548         gamevar.v = v;
549    
550         coreValidTorpedoScore( _customer_address , gamevar  );
551     }
552     
553     
554     struct GameVar_s
555     {
556      
557         bool madehigh;
558               
559                
560         uint256  torpedoBatchID;
561        
562  	    int256   score;
563 		uint256  scoreMultiplied;
564 		
565 		uint32   multiplier;
566 		
567         bytes32  r;
568         bytes32  s;
569         uint8    v;
570     }
571     
572 	function payJackpot() private
573 	{
574 		address _winner = GameRoundData.currentJackpotWinner;
575 		uint256 _j = GameRoundData.jackpotAmount;
576 		
577 		
578 		if (_winner != address(0))
579 		{
580 			PlayerData[ _winner ].chest = PlayerData[ _winner ].chest.add( _j ); 
581 		
582 		
583     		GameRoundData.currentJackpotWinner = address(0);
584     		GameRoundData.jackpotAmount = 0;
585     		//turn to 0
586     		GameRoundData.extraData[1] = 0;
587     		//highscore to 0
588     		GameRoundData.extraData[0] = 0;
589     		
590     		emit onJackpotWin( _winner , _j  );
591 		}
592 		
593 	}
594   
595     
596     function coreValidTorpedoScore( address _player_address , GameVar_s gamevar) private
597     {
598     
599         PlayerData_s storage  _PlayerData = PlayerData[ _player_address];
600                 
601         require((gamevar.torpedoBatchID != 0) && (gamevar.torpedoBatchID == _PlayerData.torpedoBatchID) && ( _PlayerData.lockedCredit>0 ));
602                 
603         gamevar.madehigh = false;
604 
605 	
606         if (block.number>=_PlayerData.torpedoBatchBlockTimeout || (ecrecover(keccak256(abi.encodePacked( gamevar.score,gamevar.torpedoBatchID )) , gamevar.v, gamevar.r, gamevar.s) != signerAuthority))
607         {
608             gamevar.score = 0;
609         }
610 		
611 		if (gamevar.score<0) gamevar.score = 0;
612 				            
613         gamevar.scoreMultiplied = uint256(gamevar.score) * uint256(_PlayerData.packedData[0]);
614         
615         if (gamevar.score>0xffffffff) gamevar.score = 0xffffffff;
616         if (gamevar.scoreMultiplied>0xffffffff) gamevar.scoreMultiplied = 0xffffffff;
617    		
618 		//new jackpot highscore
619 		if (gamevar.scoreMultiplied > uint256( GameRoundData.extraData[0] ))
620 		{
621 			GameRoundData.extraData[0] = uint32( gamevar.scoreMultiplied );
622 			
623 			GameRoundData.currentJackpotWinner = _player_address;
624 			
625  			gamevar.madehigh = true;
626 			 
627 		}
628 		
629 		//jackpot turn++
630 		 GameRoundData.extraData[1]++;
631 		
632 		//time to pay jackpot cycle ?	
633 		if (GameRoundData.extraData[1]>=GameRoundData.extraData[3])
634 		{
635 			payJackpot();
636 		}
637 		
638 	
639 		//we need to deal with scores not multiplied here	
640 		
641 		uint256 _winning =0;
642 		uint256 _average = uint256( GameRoundData.extraData[2]);
643 		uint256 _top = _average*3;
644 		
645 		uint256 _score = uint256(gamevar.score);
646 		
647 		if (_score >=_average )
648 		{
649 			//more or equal than average score 
650 			
651 			_winning = _PlayerData.lockedCredit;
652 			
653 			//how much from the treasure
654 					
655 			if (_score > _top) _score = _top;
656 		
657 			_score -= _average;
658 			_top -= _average;
659 		
660 			
661 			//apply the credit multiplier			
662 			uint256 _gains = GameRoundData.treasureAmount.mul( _score * uint256( _PlayerData.packedData[0] )) / 100;
663 			
664 			
665 			//apply the percentage now per play NEW
666 			_gains = _gains.mul( GameRoundData.extraData[6] );
667 			_gains /= 100;
668 			
669 			//finally scale it to the score 
670 			_gains /= (1+_top);
671 			
672 			//adjust treasure
673 			GameRoundData.treasureAmount = GameRoundData.treasureAmount.sub( _gains );
674 									
675 			_winning = _winning.add( _gains );
676 		}
677 		else
678 		{
679 			//less than average score
680 		
681 			if (_average>0)
682 			{
683 				_winning = _PlayerData.lockedCredit.mul( _score ) / _average;
684 			}
685 		}
686 		
687 		//credit the player for what is won
688 		_PlayerData.chest = _PlayerData.chest.add( _winning );
689 		
690 		
691 		//loosing some ?
692 		
693 		if (_PlayerData.lockedCredit> _winning)
694 		{
695 			
696 			AddJackpotTreasure( _PlayerData.lockedCredit - _winning );
697 		}
698 		
699 		//update average, we shall not overflow :)
700 				
701 		_score = uint256(gamevar.score);
702 		
703 		uint32 maximumScore = GameRoundData.extraData[4];
704 		
705 		
706 		//this has to be significatf and not just someone trying to cheat the system 
707 		//
708 		if (_score>_average/2)
709 		{
710 			_score = _score.add( _average * 99 );
711 			_score /= 100;
712 			
713 			if (_score< maximumScore/6 ) _score = maximumScore/6;
714 			if (_score > maximumScore/3) _score = maximumScore/3;
715 			
716 			GameRoundData.extraData[2] = uint32( _score );
717 		}
718 
719 		//		
720    
721         //ok reset it so we can get a new one
722         _PlayerData.torpedoBatchID = 0;
723         _PlayerData.lockedCredit = 0;
724 		
725         emit onNewScore( gamevar.scoreMultiplied , _player_address , gamevar.madehigh , _winning , _PlayerData.packedData[0] );
726 
727 
728     }
729     
730     
731     function BuyTorpedoWithDividends( uint256 eth , int256 score, uint256 torpedoBatchID,  address _referrer_address , bytes32 r , bytes32 s , uint8 v) public
732     onlyDirectTransaction
733     {
734         
735         require( maintenanceMode==false  && (eth==minimumSharePrice || eth==minimumSharePrice*10 || eth==minimumSharePrice*100) );
736   
737         address _customer_address = msg.sender;
738         
739         GameVar_s memory gamevar;
740         gamevar.score = score;
741         gamevar.torpedoBatchID = torpedoBatchID;
742         gamevar.r = r;
743         gamevar.s = s;
744         gamevar.v = v;
745         
746       
747         gamevar.multiplier =uint32( eth / minimumSharePrice);
748         
749         eth = HDXcontract.payWithToken( eth , _customer_address );
750        
751         require( eth>0 );
752         
753          
754         CoreBuyTorpedo( _customer_address , eth , _referrer_address , gamevar );
755         
756        
757     }
758     
759     function BuyName( bytes32 name ) public payable
760     {
761         address _customer_address = msg.sender;
762         uint256 eth = msg.value; 
763         
764         require( maintenanceMode==false  && (eth==minimumSharePrice*10));
765         
766         //50% for the community
767         //50% for the developer account
768         
769         eth /= 2;
770         
771         HDXcontract.buyTokenFromGame.value( eth )( owner , address(0));
772        
773         HDXcontract.appreciateTokenPrice.value( eth )();
774         
775         registeredNames[ _customer_address ] = name;
776         
777         emit onNewName( _customer_address , name , now );
778     }
779     
780     function BuyTorpedo( int256 score, uint256 torpedoBatchID, address _referrer_address , bytes32 r , bytes32 s , uint8 v ) public payable
781     onlyDirectTransaction
782     {
783      
784         address _customer_address = msg.sender;
785         uint256 eth = msg.value;
786         
787         require( maintenanceMode==false  && (eth==minimumSharePrice || eth==minimumSharePrice*10 || eth==minimumSharePrice*100));
788    
789         GameVar_s memory gamevar;
790         gamevar.score = score;
791         gamevar.torpedoBatchID = torpedoBatchID;
792         gamevar.r = r;
793         gamevar.s = s;
794         gamevar.v = v;
795         
796        
797         gamevar.multiplier =uint32( eth / minimumSharePrice);
798    
799         CoreBuyTorpedo( _customer_address , eth , _referrer_address, gamevar);
800      
801     }
802     
803     /*================================
804     =       CORE BUY FUNCTIONS       =
805     ================================*/
806     
807     function CoreBuyTorpedo( address _player_address , uint256 eth ,  address _referrer_address , GameVar_s gamevar) private
808     {
809     
810         PlayerData_s storage  _PlayerData = PlayerData[ _player_address];
811             
812         
813         //we need to validate the score before buying a torpedo batch
814         if (gamevar.torpedoBatchID !=0 || _PlayerData.torpedoBatchID !=0)
815         {
816              coreValidTorpedoScore( _player_address , gamevar);
817         }
818         
819         
820         //if we can continue then everything is fine let's create the new torpedo batch
821         
822         _PlayerData.packedData[0] = gamevar.multiplier;
823         _PlayerData.torpedoBatchBlockTimeout = block.number + (uint256(GameRoundData.extraData[5]) / blockTimeAverage);
824         _PlayerData.torpedoBatchID = uint256((keccak256(abi.encodePacked( block.number, _player_address , address(this)))));
825         
826         
827         //HDX20BuyFees
828         uint256 _tempo = (eth.mul(HDX20BuyFees)) / 100;
829 		
830 		_PlayerData.lockedCredit =  eth - _tempo;	//total - hdx20
831 		        
832         uint256 _nb_token =   HDXcontract.buyTokenFromGame.value( _tempo )( _player_address , _referrer_address);
833         
834         
835         emit onBuyTorpedo( _player_address, _PlayerData.torpedoBatchID , _PlayerData.torpedoBatchBlockTimeout, _nb_token,  _PlayerData.packedData[0]);
836             
837         
838     }
839     
840    
841     
842     function get_Gains(address _player_address) private view
843     returns( uint256)
844     {
845        
846         uint256 _gains = PlayerData[ _player_address ].chest;
847         
848         if (_gains > PlayerData[ _player_address].payoutsTo)
849         {
850             _gains -= PlayerData[ _player_address].payoutsTo;
851         }
852         else _gains = 0;
853      
854     
855         return( _gains );
856         
857     }
858     
859     
860     function WithdrawGains() public 
861    
862     {
863         address _customer_address = msg.sender;
864         
865         uint256 _gains = get_Gains( _customer_address );
866         
867         require( _gains>0);
868         
869         PlayerData[ _customer_address ].payoutsTo = PlayerData[ _customer_address ].payoutsTo.add( _gains );
870         
871       
872         emit onWithdrawGains( _customer_address , _gains , now);
873         
874         _customer_address.transfer( _gains );
875         
876         
877     }
878     
879    
880     
881    
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
899 	function view_get_Jackpot() public
900     view
901     returns(uint256)
902     {
903       
904       return( GameRoundData.jackpotAmount );  
905     }
906  
907     function view_get_gameData() public
908     view
909     returns( uint256 treasure,
910 			 uint256 jackpot,
911 			 uint32  highscore ,
912 			 address highscore_address ,
913 			 bytes32 highscore_name,
914 			 uint32  highscore_turn,
915 			 uint32  score_average,
916 		
917 			 uint256 torpedoBatchID ,
918 			 uint32 torpedoBatchMultiplier ,
919 			 uint256 torpedoBatchBlockTimeout,
920 			 uint32  score_maximum,
921 			 uint32  percentage)
922     {
923         address _player_address = msg.sender;
924 		
925 		treasure = GameRoundData.treasureAmount;
926 		jackpot = GameRoundData.jackpotAmount;
927 		highscore = GameRoundData.extraData[0];
928 		highscore_address = GameRoundData.currentJackpotWinner;
929 		highscore_name = view_get_registeredNames( GameRoundData.currentJackpotWinner  );
930 		highscore_turn = GameRoundData.extraData[1];
931 		score_average = GameRoundData.extraData[2];
932 		score_maximum =  GameRoundData.extraData[4];
933 		
934 		percentage = GameRoundData.extraData[6];
935 		      
936         torpedoBatchID = PlayerData[_player_address].torpedoBatchID;
937         torpedoBatchMultiplier = PlayerData[_player_address].packedData[0];
938         torpedoBatchBlockTimeout = PlayerData[_player_address].torpedoBatchBlockTimeout;
939        
940     }
941   
942        
943   
944     
945     function view_get_Gains()
946     public
947     view
948     returns( uint256 gains)
949     {
950         
951         address _player_address = msg.sender;
952    
953       
954         uint256 _gains = PlayerData[ _player_address ].chest;
955         
956         if (_gains > PlayerData[ _player_address].payoutsTo)
957         {
958             _gains -= PlayerData[ _player_address].payoutsTo;
959         }
960         else _gains = 0;
961      
962     
963         return( _gains );
964         
965     }
966   
967   
968     
969     function view_get_gameStates() public 
970     view
971     returns( uint256 minimumshare ,
972 		     uint256 blockNumberCurrent ,
973 			 uint256 blockTimeAvg ,
974 			 uint32  highscore ,
975 			 address highscore_address ,
976 			 bytes32 highscore_name,
977 			 uint32  highscore_turn,
978 			 uint256 jackpot,
979 			 bytes32 myname,
980 			 uint32  jackpotCycle)
981     {
982        
983         
984         return( minimumSharePrice ,  block.number , blockTimeAverage , GameRoundData.extraData[0] , GameRoundData.currentJackpotWinner , view_get_registeredNames( GameRoundData.currentJackpotWinner  ) , GameRoundData.extraData[1] , GameRoundData.jackpotAmount,  view_get_registeredNames(msg.sender) , GameRoundData.extraData[3]);
985     }
986     
987     function view_get_pendingHDX20Appreciation()
988     public
989     view
990     returns(uint256)
991     {
992         return GameRoundData.hdx20AppreciationPayout;
993     }
994     
995     function view_get_pendingDevAppreciation()
996     public
997     view
998     returns(uint256)
999     {
1000         return GameRoundData.devAppreciationPayout;
1001     }
1002   
1003  
1004  
1005     function totalEthereumBalance()
1006     public
1007     view
1008     returns(uint256)
1009     {
1010         return address(this).balance;
1011     }
1012     
1013     function view_get_maintenanceMode()
1014     public
1015     view
1016     returns(bool)
1017     {
1018         return( maintenanceMode);
1019     }
1020     
1021     function view_get_blockNumbers()
1022     public
1023     view
1024     returns( uint256 b1 )
1025     {
1026         return( block.number);
1027         
1028     }
1029     
1030     function view_get_registeredNames(address _player)
1031     public
1032     view
1033     returns( bytes32)
1034     {
1035         
1036         return( registeredNames[ _player ]);
1037     }
1038     
1039    
1040 }
1041 
1042 
1043 library SafeMath {
1044     
1045    
1046     function mul(uint256 a, uint256 b) 
1047         internal 
1048         pure 
1049         returns (uint256 c) 
1050     {
1051         if (a == 0) {
1052             return 0;
1053         }
1054         c = a * b;
1055         require(c / a == b);
1056         return c;
1057     }
1058 
1059    
1060     function sub(uint256 a, uint256 b)
1061         internal
1062         pure
1063         returns (uint256) 
1064     {
1065         require(b <= a);
1066         return a - b;
1067     }
1068 
1069    
1070     function add(uint256 a, uint256 b)
1071         internal
1072         pure
1073         returns (uint256 c) 
1074     {
1075         c = a + b;
1076         require(c >= a);
1077         return c;
1078     }
1079     
1080    
1081     
1082   
1083     
1084    
1085 }
1086 
1087 
1088 library SafeMath128 {
1089     
1090    
1091     function mul(uint128 a, uint128 b) 
1092         internal 
1093         pure 
1094         returns (uint128 c) 
1095     {
1096         if (a == 0) {
1097             return 0;
1098         }
1099         c = a * b;
1100         require(c / a == b);
1101         return c;
1102     }
1103 
1104    
1105     function sub(uint128 a, uint128 b)
1106         internal
1107         pure
1108         returns (uint128) 
1109     {
1110         require(b <= a);
1111         return a - b;
1112     }
1113 
1114    
1115     function add(uint128 a, uint128 b)
1116         internal
1117         pure
1118         returns (uint128 c) 
1119     {
1120         c = a + b;
1121         require(c >= a);
1122         return c;
1123     }
1124     
1125    
1126     
1127   
1128     
1129    
1130 }