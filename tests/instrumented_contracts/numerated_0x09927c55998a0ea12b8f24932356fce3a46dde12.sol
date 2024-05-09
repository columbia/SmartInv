1 /*
2 
3 Introducing "ETHERKNIGHT" 3.0 our first HDX20 POWERED GAME running on the Ethereum Blockchain got an upgrade 
4 "ETHERKNIGHT" is playable @ http://etherknightgame.io
5 
6 About the game :
7 4 Knight Characters racing against each other to be the first to reach the goal and win the pot of gold.
8 
9 How to play ETHERKNIGHT:
10 The Race will start after at least 1 player has bought shares of any Knight Racer then for every new item activated
11 a 24H countdown will reset. At the end of the countdown, the players on the first Racer will share the Treasure and
12 everybody else will receive their payout (no one is leaving the table without values).
13 In addition, when you buy shares of your favorite Racer 5% of the price will buy you HDX20 Token earning you Ethereum
14 from the volume of any HDX20 POWERED GAMES (visit https://hdx20.io/ for details).
15 Please remember, at every new buy, the price of the share is increasing a little and so will be your payout even
16 if you are not the winner, buying shares at the beginning of the race is highly advised.
17 
18 Play for the big WIN, Play for the TREASURE, Play for staking HDX20 TOKEN or Play for all at once...Your Choice!
19 
20 We wish you Good Luck!
21 
22 PAYOUTS DISTRIBUTION:
23 .60% to the winners of the race distributed proportionally to their shares.
24 .25% to the community of HDX20 gamers/holders distributed as price appreciation.
25 .5% to developer for running, developing and expanding the platform.
26 .10% for provisioning the TREASURE for the next Race.
27 
28 UPDATE:
29 
30 we updated:
31 .the player can withdraw during the race any OWNED amount.
32 .streamlined payment to HDX20 token holders.
33 .from 1 eth played 50%(40% before) will charge the treasure, 30% (40% before) will buy shares, 5% will buy HDX20 for the player and 15% will appreciate the share price.
34 .from the treasure =>60% for winners prizes, 5% for development fees, %25 (10% before) for HDX20 price appreciation, 10% (25% before) for provisioning the next round treasure.
35 .adjusted the item price increase function. 
36 
37 This product is copyrighted. Any unauthorized copy, modification, or use without express written consent from HyperDevbox is prohibited.
38 
39 Copyright 2018 HyperDevbox
40 
41 */
42 
43 
44 pragma solidity ^0.4.25;
45 
46 
47 interface HDX20Interface
48 {
49     function() payable external;
50     
51     
52     function buyTokenFromGame( address _customerAddress , address _referrer_address ) payable external returns(uint256);
53   
54     function payWithToken( uint256 _eth , address _player_address ) external returns(uint256);
55   
56     function appreciateTokenPrice() payable external;
57    
58     function totalSupply() external view returns(uint256); 
59     
60     function ethBalanceOf(address _customerAddress) external view returns(uint256);
61   
62     function balanceOf(address _playerAddress) external view returns(uint256);
63     
64     function sellingPrice( bool includeFees) external view returns(uint256);
65   
66 }
67 
68 contract EtherKnightGame
69 {
70      HDX20Interface private HDXcontract = HDX20Interface(0x8942a5995bd168f347f7ec58f25a54a9a064f882);
71      
72      using SafeMath for uint256;
73       using SafeMath128 for uint128;
74      
75      /*==============================
76     =            EVENTS            =
77     ==============================*/
78     event OwnershipTransferred(
79         
80          address previousOwner,
81          address nextOwner,
82           uint256 timeStamp
83          );
84          
85     event HDXcontractChanged(
86         
87          address previous,
88          address next,
89          uint256 timeStamp
90          );
91  
92    
93     
94      event onWithdrawGains(
95         address customerAddress,
96         uint256 ethereumWithdrawn,
97         uint256 timeStamp
98     );
99     
100     event onNewRound(
101         uint256       gRND,
102         uint32        turnRound,
103         uint32        eventType,
104         uint32        eventTarget,
105         uint32[4]     persoEnergy,
106         uint32[4]     persoDistance,
107         uint32[4]     powerUpSpeed,
108         uint32[4]     powerUpShield,
109         uint256       blockNumberTimeout,
110         uint256       treasureAmountFind,
111         address       customerAddress
112         
113        
114        
115     );
116     
117     
118     event onNewRace(
119         
120         uint256 gRND,
121         uint8[4] persoType,
122         uint256  blockNumber
123         
124         );
125         
126     event onBuyShare(
127         address     customerAddress,
128         uint256     gRND,
129         uint32      perso,
130         uint256     nbToken,
131         uint32      actionType,
132         uint32      actionValue
133         );    
134         
135         
136      event onMaintenance(
137         bool        mode,
138         uint256     timeStamp
139 
140         );    
141         
142     event onRefund(
143         address     indexed customerAddress,
144         uint256     eth,
145         uint256     timeStamp
146          
147         );   
148         
149     event onCloseEntry(
150         
151          uint256 gRND
152          
153         );    
154         
155     event onChangeBlockTimeAverage(
156         
157          uint256 blocktimeavg
158          
159         );    
160         
161     /*==============================
162     =            MODIFIERS         =
163     ==============================*/
164     modifier onlyOwner
165     {
166         require (msg.sender == owner );
167         _;
168     }
169     
170     modifier onlyFromHDXToken
171     {
172         require (msg.sender == address( HDXcontract ));
173         _;
174     }
175    
176      modifier onlyDirectTransaction
177     {
178         require (msg.sender == tx.origin);
179         _;
180     }
181    
182    
183      modifier isPlayer
184     {
185         require (PlayerData[ msg.sender].gRND !=0);
186         _;
187     }
188     
189     modifier isMaintenance
190     {
191         require (maintenanceMode==true);
192         _;
193     }
194     
195      modifier isNotMaintenance
196     {
197         require (maintenanceMode==false);
198         _;
199     }
200    
201     // Changing ownership of the contract safely
202     address public owner;
203   
204     
205    
206     
207      /// Contract governance.
208 
209     constructor () public
210     {
211         owner = msg.sender;
212        
213         
214         if ( address(this).balance > 0)
215         {
216             owner.transfer( address(this).balance );
217         }
218     }
219     
220     function changeOwner(address _nextOwner) public
221     onlyOwner
222     {
223         require (_nextOwner != owner);
224         require(_nextOwner != address(0));
225          
226         emit OwnershipTransferred(owner, _nextOwner , now);
227          
228         owner = _nextOwner;
229     }
230     
231     function changeHDXcontract(address _next) public
232     onlyOwner
233     {
234         require (_next != address( HDXcontract ));
235         require( _next != address(0));
236          
237         emit HDXcontractChanged(address(HDXcontract), _next , now);
238          
239         HDXcontract  = HDX20Interface( _next);
240     }
241   
242   
243     
244     function changeBlockTimeAverage( uint256 blocktimeavg) public
245     onlyOwner
246     {
247         require ( blocktimeavg>0 );
248         
249        
250         blockTimeAverage = blocktimeavg;
251         
252         emit onChangeBlockTimeAverage( blockTimeAverage );
253          
254     }
255     
256     function enableMaintenance() public
257     onlyOwner
258     {
259         maintenanceMode = true;
260         
261         emit onMaintenance( maintenanceMode , now);
262         
263     }
264 
265     function disableMaintenance() public
266     onlyOwner
267     {
268         uint8[4] memory perso =[0,1,2,3];
269         
270         maintenanceMode = false;
271         
272         emit onMaintenance( maintenanceMode , now);
273         
274         //reset with a new race
275         initRace( perso );
276     }
277     
278   
279     
280     
281    
282     function refundMe() public
283     isMaintenance
284     {
285         address _playerAddress = msg.sender;
286          
287         
288       
289         require( this_gRND>0 && GameRoundData[ this_gRND].extraData[0]>0 && GameRoundData[ this_gRND].extraData[0]<(1<<30) && PlayerData[ _playerAddress ].gRND==this_gRND);
290         
291         uint256 _eth = 0;
292 
293         for( uint i=0;i<4;i++)
294         {
295             _eth = _eth.add( PlayerGameRound[ _playerAddress][this_gRND].shares[i] * GameRoundData[ this_gRND].sharePrice);
296             
297             PlayerGameRound[ _playerAddress][this_gRND].shares[i] = 0;
298         }
299         
300         if (_eth>0)
301         {
302                _playerAddress.transfer( _eth );  
303                
304                emit onRefund( _playerAddress , _eth , now );
305         }
306         
307     }
308     
309      /*================================
310     =       GAMES VARIABLES         =
311     ================================*/
312     
313     struct PlayerData_s
314     {
315    
316         uint256 chest;  
317         uint256 payoutsTo;
318         uint256 gRND;  
319        
320     }
321     
322     struct PlayerGameRound_s
323     {
324         uint256[4]      shares;
325         uint128         treasure_payoutsTo;    
326         uint128         token;
327       
328        
329     }
330     
331     struct GameRoundData_s
332     {
333        uint256              blockNumber;
334        uint256              blockNumberTimeout;
335        uint256              sharePrice;
336        uint256[4]           sharePots;
337        uint256              shareEthBalance;
338        uint256              shareSupply;
339        uint256              treasureSupply;
340       
341      
342        //this time we want to stream the HDX20 apprecition and dev fees on the way
343        uint256              allFeeSupply;       //to separate the fees from the actual treasure
344        uint256              hdx20AppreciationPayout;
345        uint256              devAppreciationPayout;
346        //
347        
348        uint256              totalTreasureFound;
349        uint256[6]           actionBlockNumber;
350       
351        uint128[4]           treasurePerShare; 
352        uint32[8]            persoData; //energy[4] distance[4]
353        uint32[8]            powerUpData; //Speed[4] Shield[4]
354        
355        uint32[6]            actionValue;
356        
357        uint32[6]            extraData;//[0]==this_TurnRound , [1]==winner , [2-5] totalPlayers
358   
359     }
360     
361   
362    
363     
364  
365     
366    
367     mapping (address => PlayerData_s)   private PlayerData;
368     
369    
370     mapping (address => mapping (uint256 => PlayerGameRound_s)) private PlayerGameRound;
371     
372    
373     mapping (uint256 => GameRoundData_s)   private GameRoundData;
374     
375    
376     bool        private maintenanceMode=false;     
377    
378     uint256     private this_gRND =0;
379   
380  
381   
382   
383     //85 , missing 15% for shares appreciation eg:share price increase
384     uint8 constant private HDX20BuyFees = 5;
385     uint8 constant private TREASUREBuyFees = 50;
386     uint8 constant private BUYPercentage = 30;
387     
388     
389     //the part to keep from the treasure for next round treasure + hdx20 appreciation + dev 
390     uint8 constant private DevFees = 5;
391     uint8 constant private TreasureFees = 10;
392     uint8 constant private AppreciationFees = 25;
393     uint8 constant private AddedFees = DevFees+TreasureFees+AppreciationFees;
394   
395    
396     uint256 constant internal magnitude = 1e18;
397   
398     uint256 private genTreasure = 0;
399    
400     uint256 constant private minimumSharePrice = 0.001 ether;
401     
402     uint256 private blockTimeAverage = 15;  //seconds per block                          
403     
404  
405     uint8[4]    private this_Perso_Type;
406     
407    
408       
409     /*================================
410     =       PUBLIC FUNCTIONS         =
411     ================================*/
412     
413     //fallback will be called only from the HDX token contract to fund the game from customers's HDX20
414     
415      function()
416      payable
417      public
418      onlyFromHDXToken 
419     {
420        
421       
422       
423           
424     }
425     
426     
427     function ChargeTreasure() public payable
428     {
429         genTreasure = SafeMath.add( genTreasure , msg.value);     
430     }
431     
432     
433     function buyTreasureShares(GameRoundData_s storage  _GameRoundData , uint256 _eth ) private
434     returns( uint256)
435     {
436         uint256 _nbshares = (_eth.mul( magnitude)) / _GameRoundData.sharePrice;
437         uint256 _nbsharesForTreasure = (_nbshares.mul( 100-DevFees-TreasureFees-AppreciationFees)) / 100;
438        
439         //now we do separate for streamline payment
440         _GameRoundData.treasureSupply = _GameRoundData.treasureSupply.add( _nbsharesForTreasure );
441         //the difference is for the allFeeSupply
442         _GameRoundData.allFeeSupply = _GameRoundData.allFeeSupply.add( _nbshares - _nbsharesForTreasure);
443         
444         
445         _GameRoundData.shareSupply =   _GameRoundData.shareSupply.add( _nbshares );
446         
447         return( _nbshares);
448     }
449    
450     
451     function initRace( uint8[4] p ) public
452     onlyOwner
453     isNotMaintenance
454     {
455  
456         
457         this_gRND++;
458         
459         GameRoundData_s storage _GameRoundData = GameRoundData[ this_gRND ];
460        
461         for( uint i=0;i<4;i++)
462         {
463            this_Perso_Type[i] = p[i];
464        
465             _GameRoundData.persoData[i] = 100;
466             _GameRoundData.persoData[4+i] = 25;
467             
468         }
469        
470         _GameRoundData.blockNumber = block.number;
471         
472         _GameRoundData.blockNumberTimeout = block.number + (360*10*24*3600); 
473         
474         uint256 _sharePrice = 0.001 ether; // minimumSharePrice;
475         
476         _GameRoundData.sharePrice = _sharePrice;
477         
478         uint256 _nbshares = buyTreasureShares(_GameRoundData, genTreasure );
479      
480         //convert into ETH
481         _nbshares = _nbshares.mul( _sharePrice ) / magnitude;
482         
483         //start balance   
484         _GameRoundData.shareEthBalance = _nbshares;
485         
486         genTreasure = genTreasure.sub( _nbshares);
487      
488        
489         emit onNewRace( this_gRND , p , block.number);
490         
491     }
492     
493     
494    
495     function get_TotalPayout(  GameRoundData_s storage  _GameRoundData ) private view
496     returns( uint256)
497     {
498       
499        uint256 _payout = 0;
500         
501        uint256 _sharePrice = _GameRoundData.sharePrice;
502      
503        for(uint i=0;i<4;i++)
504        {
505            uint256 _bet = _GameRoundData.sharePots[i];
506            
507            _payout = _payout.add( _bet.mul (_sharePrice) / magnitude );
508        }           
509          
510        //from the whole treasure now since new version         
511        uint256 _potValue = (_GameRoundData.treasureSupply.mul( _sharePrice )) / magnitude;
512        
513        
514        _payout = _payout.add( _potValue ).add(_GameRoundData.totalTreasureFound );
515        
516    
517        return( _payout );
518         
519     }
520     
521     
522   
523     function get_PendingGains( address _player_address , uint256 _gRND) private view
524     returns( uint256)
525     {
526        
527        //did not play 
528        if (PlayerData[ _player_address].gRND != _gRND || _gRND==0) return( 0 );
529        
530        GameRoundData_s storage  _GameRoundData = GameRoundData[ _gRND ];
531        
532      
533        uint32 _winner = _GameRoundData.extraData[1];
534        
535        uint256 _gains = 0;
536        uint256 _treasure = 0;
537        uint256 _sharePrice = _GameRoundData.sharePrice;
538        uint256 _shares;
539        
540        PlayerGameRound_s storage  _PlayerGameRound = PlayerGameRound[ _player_address][_gRND];
541        
542        for(uint i=0;i<4;i++)
543        {
544            _shares = _PlayerGameRound.shares[ i ];
545             
546            _gains = _gains.add( _shares.mul( _sharePrice) / magnitude );
547         
548            
549            _treasure = _treasure.add(_shares.mul( _GameRoundData.treasurePerShare[ i ] ) / magnitude);
550            
551        }
552        
553         if (_treasure >=  _PlayerGameRound.treasure_payoutsTo) _treasure = _treasure.sub(_PlayerGameRound.treasure_payoutsTo );
554        else _treasure = 0;
555            
556        _gains = _gains.add(_treasure );
557        
558        //if the race payment is made (race is over) then we add also the winner prize
559        if (_winner>0 && _GameRoundData.extraData[0] >= (1<<30))
560        {
561            _shares = _PlayerGameRound.shares[ _winner-1 ];
562            
563            if (_shares>0)
564            {
565                //from the whole treasure now since new version   
566                _treasure = (_GameRoundData.treasureSupply.mul( _sharePrice )) / magnitude;
567        
568                
569                _gains = _gains.add(  _treasure.mul( _shares ) / _GameRoundData.sharePots[ _winner-1]  );
570                
571            }
572            
573        }
574     
575        
576         return( _gains );
577         
578     }
579     
580     
581     //only for the Result Data Screen on the game not used for the payout
582     
583     function get_PendingGainsAll( address _player_address , uint256 _gRND) private view
584     returns( uint256)
585     {
586        
587        //did not play 
588        if (PlayerData[ _player_address].gRND != _gRND || _gRND==0) return( 0 );
589        
590        GameRoundData_s storage  _GameRoundData = GameRoundData[ _gRND ];
591        
592      
593        uint32 _winner = _GameRoundData.extraData[1];
594        
595        uint256 _gains = 0;
596        uint256 _treasure = 0;
597        uint256 _sharePrice = _GameRoundData.sharePrice;
598        uint256 _shares;
599        
600        PlayerGameRound_s storage  _PlayerGameRound = PlayerGameRound[ _player_address][_gRND];
601        
602        for(uint i=0;i<4;i++)
603        {
604            _shares = _PlayerGameRound.shares[ i ];
605             
606            _gains = _gains.add( _shares.mul( _sharePrice) / magnitude );
607         
608            
609            _treasure = _treasure.add(_shares.mul( _GameRoundData.treasurePerShare[ i ] ) / magnitude);
610            
611        }
612        
613         if (_treasure >=  _PlayerGameRound.treasure_payoutsTo) _treasure = _treasure.sub(_PlayerGameRound.treasure_payoutsTo );
614        else _treasure = 0;
615            
616        _gains = _gains.add(_treasure );
617        
618      
619        if (_winner>0)
620        {
621            _shares = _PlayerGameRound.shares[ _winner-1 ];
622            
623            if (_shares>0)
624            {
625                //from the whole treasure now since new version 
626                _treasure = (_GameRoundData.treasureSupply.mul( _sharePrice )) / magnitude;
627        
628                
629                _gains = _gains.add(  _treasure.mul( _shares ) / _GameRoundData.sharePots[ _winner-1]  );
630                
631            }
632            
633        }
634     
635        
636         return( _gains );
637         
638     }
639     
640        //process streaming HDX20 appreciation and dev fees appreciation
641     function process_sub_Taxes(  GameRoundData_s storage _GameRoundData , uint256 minimum) private
642     {
643         uint256 _sharePrice = _GameRoundData.sharePrice;
644              
645         uint256 _potValue = _GameRoundData.allFeeSupply.mul( _sharePrice ) / magnitude;
646             
647         uint256 _appreciation = SafeMath.mul( _potValue , AppreciationFees) / AddedFees; 
648           
649         uint256 _dev = SafeMath.mul( _potValue , DevFees) / AddedFees;   
650         
651         if (_dev > _GameRoundData.devAppreciationPayout)
652         {
653             _dev -= _GameRoundData.devAppreciationPayout;
654             
655             if (_dev>minimum)
656             {
657               _GameRoundData.devAppreciationPayout = _GameRoundData.devAppreciationPayout.add( _dev );
658               
659                HDXcontract.buyTokenFromGame.value( _dev )( owner , address(0));
660               
661             }
662         }
663         
664         if (_appreciation> _GameRoundData.hdx20AppreciationPayout)
665         {
666             _appreciation -= _GameRoundData.hdx20AppreciationPayout;
667             
668             if (_appreciation>minimum)
669             {
670                 _GameRoundData.hdx20AppreciationPayout = _GameRoundData.hdx20AppreciationPayout.add( _appreciation );
671                 
672                  HDXcontract.appreciateTokenPrice.value( _appreciation )();
673                 
674             }
675         }
676         
677     }
678     
679     //process the fees, hdx20 appreciation, calcul results at the end of the race
680     function process_Taxes(  GameRoundData_s storage _GameRoundData ) private
681     {
682         uint32 turnround = _GameRoundData.extraData[0];
683         
684         if (turnround>0 && turnround<(1<<30))
685         {  
686             _GameRoundData.extraData[0] = turnround | (1<<30);
687             
688             uint256 _sharePrice = _GameRoundData.sharePrice;
689              
690             uint256 _potValue = _GameRoundData.allFeeSupply.mul( _sharePrice ) / magnitude;
691      
692            
693             uint256 _treasure = SafeMath.mul( _potValue , TreasureFees) / AddedFees; 
694          
695            
696             genTreasure = genTreasure.add( _treasure );
697             
698             //take care of any left over
699             process_sub_Taxes( _GameRoundData , 0);
700             
701             
702         }
703      
704     }
705     
706     
707     
708     function BuyShareWithDividends( uint32 perso , uint256 eth , uint32 action, address _referrer_address ) public
709     onlyDirectTransaction
710     {
711   
712         require( maintenanceMode==false  && this_gRND>0 && (eth>=minimumSharePrice) && (eth <=100 ether) &&  perso<=3 && action <=5 && block.number <GameRoundData[ this_gRND ].blockNumberTimeout );
713   
714         address _customer_address = msg.sender;
715         
716         eth = HDXcontract.payWithToken( eth , _customer_address );
717        
718         require( eth>0 );
719          
720         CoreBuyShare( _customer_address , perso , eth , action , _referrer_address );
721         
722        
723     }
724     
725     function BuyShare(   uint32 perso , uint32 action , address _referrer_address ) public payable
726     onlyDirectTransaction
727     {
728      
729          
730         address _customer_address = msg.sender;
731         uint256 eth = msg.value;
732         
733         require( maintenanceMode==false  && this_gRND>0 && (eth>=minimumSharePrice) &&(eth <=100 ether) && perso<=3 && action <=5 && block.number <GameRoundData[ this_gRND ].blockNumberTimeout);
734    
735          
736         CoreBuyShare( _customer_address , perso , eth , action , _referrer_address);
737      
738     }
739     
740     /*================================
741     =       CORE BUY FUNCTIONS       =
742     ================================*/
743     
744     function CoreBuyShare( address _player_address , uint32 perso , uint256 eth , uint32 action ,  address _referrer_address ) private
745     {
746     
747         PlayerGameRound_s storage  _PlayerGameRound = PlayerGameRound[ _player_address][ this_gRND];
748         
749         GameRoundData_s storage  _GameRoundData = GameRoundData[ this_gRND ];
750         
751       
752         if (PlayerData[ _player_address].gRND != this_gRND)
753         {
754            
755             if (PlayerData[_player_address].gRND !=0)
756             {
757                 uint256 _gains = get_PendingGains( _player_address , PlayerData[ _player_address].gRND  );
758             
759                  PlayerData[ _player_address].chest = PlayerData[ _player_address].chest.add( _gains);
760             }
761           
762           
763             PlayerData[ _player_address ].gRND = this_gRND;
764            
765    
766         }
767         
768         //HDX20BuyFees
769         uint256 _tempo = (eth.mul(HDX20BuyFees)) / 100;
770         
771         _GameRoundData.shareEthBalance =  _GameRoundData.shareEthBalance.add( eth-_tempo );  //minus the hdx20 fees
772         
773         uint256 _nb_token =   HDXcontract.buyTokenFromGame.value( _tempo )( _player_address , _referrer_address);
774         
775          //keep track for result UI screen how many token bought in this game round
776         _PlayerGameRound.token += uint128(_nb_token);
777         
778         //increase the treasure shares
779         buyTreasureShares(_GameRoundData , (eth.mul(TREASUREBuyFees)) / 100 );
780    
781         //what is left for the player
782         eth = eth.mul( BUYPercentage) / 100;
783         
784         uint256 _nbshare =  (eth.mul( magnitude)) / _GameRoundData.sharePrice;
785         
786         _GameRoundData.shareSupply =  _GameRoundData.shareSupply.add( _nbshare );
787         _GameRoundData.sharePots[ perso ] =  _GameRoundData.sharePots[ perso ].add( _nbshare);
788         
789         _tempo =  _PlayerGameRound.shares[ perso ];
790         
791         if (_tempo==0)
792         {
793             _GameRoundData.extraData[ 2+perso ]++; 
794         }
795         
796         _PlayerGameRound.shares[ perso ] =  _tempo.add( _nbshare);
797    
798         //this will always raise the price after 1 share
799         if (_GameRoundData.shareSupply>magnitude)
800         {
801             _GameRoundData.sharePrice = (_GameRoundData.shareEthBalance.mul( magnitude)) / _GameRoundData.shareSupply;
802         }
803        
804        
805         _PlayerGameRound.treasure_payoutsTo = _PlayerGameRound.treasure_payoutsTo.add( uint128(_nbshare.mul(   _GameRoundData.treasurePerShare[ perso ]  ) / magnitude) );
806      
807         //HDX20 streaming appreciation
808         process_sub_Taxes( _GameRoundData , 0.2 ether);
809         
810         uint32 actionValue = ApplyAction( perso , action , _nbshare , _player_address);
811         
812         _GameRoundData.actionValue[ action] = actionValue;
813         
814         emit onBuyShare( _player_address , this_gRND , perso , _nb_token , action, actionValue  );
815                          
816         
817     }
818     
819      struct GameVar_s
820     {
821         uint32[4]   perso_energy;
822         uint32[4]   perso_distance;
823         uint32[4]   powerUpShield;
824         uint32[4]   powerUpSpeed;
825         
826         uint32      event_type;
827         uint32      event_target;
828      
829         uint32      winner;
830         
831         uint256     this_gRND;
832         
833         uint256     treasureAmountFind;
834         
835         bytes32     seed;
836         
837         uint256     blockNumberTimeout;
838         
839         uint32      turnround;
840       
841     }
842     
843     function actionPowerUpShield( uint32 perso , GameVar_s gamevar) pure private
844     {
845         
846         gamevar.powerUpShield[ perso ] = 100;
847         
848     }
849     
850     function actionPowerUpSpeed( uint32 perso , GameVar_s gamevar) pure private
851     {
852         
853         gamevar.powerUpSpeed[ perso ] = 100;
854         
855     }
856     
857    
858     
859     function actionApple( uint32 perso , GameVar_s gamevar) pure private
860     {
861         
862         gamevar.event_type = 6;     //apple / banana etc...
863         
864         gamevar.event_target = 1<<(perso*3);
865         
866         gamevar.perso_energy[ perso ] += 20; 
867         
868         if (gamevar.perso_energy[ perso] > 150) gamevar.perso_energy[ perso ] = 150;
869         
870     }
871     
872     function actionBanana(  GameVar_s gamevar ) pure private
873     {
874         
875         gamevar.event_type = 6;     //apple / banana etc...
876         
877         uint32 result = 2;
878         
879         uint32 target = get_modulo_value(gamevar.seed,18, 4);
880         
881         if (gamevar.winner>0) target = gamevar.winner-1;
882     
883         
884         uint32 shield = uint32(gamevar.powerUpShield[ target ]);
885         
886         if (shield>20) result = 5; //jumping banana
887         else
888         {
889                     uint32 dd = 4 * (101 - shield);
890                                    
891                   
892                     
893                     if (gamevar.perso_distance[ target ]>=dd)  gamevar.perso_distance[ target ] -= dd;
894                     else  gamevar.perso_distance[ target ] = 0;
895                     
896         }
897         
898         gamevar.event_target = result<<(target*3);
899         
900        
901         
902     }
903     
904     function getTreasureProbabilityType( bytes32 seed ) private pure
905     returns( uint32 )
906     {
907            uint8[22] memory this_TreasureProbability =[
908     
909         1,1,1,1,1,1,1,1,1,1,1,1,    //12 chances to have 10%
910         2,2,2,2,2,2,                //6 chances to have 15%
911         3,3,3,                      //3 chances to have 20%
912         4                           //1 chance to have 25%
913        
914         ];       
915         
916         return( this_TreasureProbability[ get_modulo_value(seed,24, 22) ] );
917     }
918     
919    
920     
921     function distribute_treasure( uint32 type2 , uint32 target , GameVar_s gamevar) private
922     {
923         uint8[5] memory this_TreasureValue =[
924         
925         1,
926         10,
927         15,
928         20,
929         25
930       
931         ];  
932         
933         //from the whole treasure now since new version 
934         uint256 _treasureSupply = GameRoundData[ gamevar.this_gRND].treasureSupply;
935       
936         
937         uint256 _sharePrice = GameRoundData[ gamevar.this_gRND].sharePrice;
938         uint256 _shareSupply = GameRoundData[ gamevar.this_gRND].shareSupply;
939        
940         //how many shares to sell
941         uint256  _amount = _treasureSupply.mul(this_TreasureValue[ type2 ] )  / 100;
942        
943         GameRoundData[ gamevar.this_gRND].treasureSupply = _treasureSupply.sub( _amount );
944         GameRoundData[ gamevar.this_gRND].shareSupply =  _shareSupply.sub( _amount );
945         
946         //in eth
947         _amount = _amount.mul( _sharePrice ) / magnitude;
948         
949         //price of shares should not change
950         GameRoundData[ gamevar.this_gRND].shareEthBalance =  GameRoundData[ gamevar.this_gRND].shareEthBalance.sub( _amount );
951         
952         gamevar.treasureAmountFind = _amount;
953        
954         GameRoundData[ gamevar.this_gRND].totalTreasureFound =   GameRoundData[ gamevar.this_gRND].totalTreasureFound.add( _amount );
955        
956         uint256 _shares = GameRoundData[ gamevar.this_gRND].sharePots[ target ];
957     
958         if (_shares>0)
959         {
960            
961             GameRoundData[ gamevar.this_gRND].treasurePerShare[ target ] =  GameRoundData[ gamevar.this_gRND].treasurePerShare[ target ].add( uint128(((_amount.mul(magnitude)) / _shares)));
962         }
963         
964     }
965     
966     function actionTreasure( uint32 perso, GameVar_s gamevar ) private
967     {
968         gamevar.event_target =  get_modulo_value(gamevar.seed,18,  14);
969         gamevar.event_type = getTreasureProbabilityType( gamevar.seed );
970                                                     
971         if (gamevar.event_target==perso)
972         {
973 
974                 distribute_treasure( gamevar.event_type , gamevar.event_target, gamevar);
975         }
976         
977        
978     }
979     
980     function apply_attack( uint32 perso, uint32 target , GameVar_s gamevar) pure private
981     {
982         for(uint i=0;i<4;i++)
983         {
984             uint32 damage = (1+(target % 3)) * 10;
985             
986             uint32 shield = uint32(  gamevar.powerUpShield[i] );
987             
988             if (damage<= shield || i==perso) damage = 0;
989             else damage -=  shield;
990             
991             if (damage<gamevar.perso_energy[i]) gamevar.perso_energy[i] -= damage;
992             else gamevar.perso_energy[i] = 1;   //minimum
993             
994             target >>= 2;
995             
996         }
997         
998     }
999     
1000     
1001     function actionAttack( uint32 perso , GameVar_s gamevar ) pure private
1002     {
1003             gamevar.event_type =  5; 
1004             gamevar.event_target = get_modulo_value(gamevar.seed,24,256);     //8 bits 4x2
1005             
1006             apply_attack( perso , gamevar.event_target , gamevar);    
1007     }
1008     
1009     function ApplyAction( uint32 perso ,  uint32 action , uint256 nbshare , address _player_address) private
1010     returns( uint32)
1011     {
1012         uint32 actionValue = GameRoundData[ this_gRND].actionValue[ action ];
1013         
1014         //only the last one is activating within the same block
1015         if (block.number<= GameRoundData[ this_gRND].actionBlockNumber[ action]) return( actionValue);
1016         
1017         GameVar_s memory gamevar;
1018           
1019         gamevar.turnround = GameRoundData[ this_gRND ].extraData[0];
1020         
1021         //now we introduce a new price increase for the items
1022         nbshare = nbshare.mul(100*100);
1023         nbshare /= (100+(gamevar.turnround/3));
1024         
1025         nbshare /= magnitude;
1026       
1027         nbshare += 10;
1028         
1029         if (nbshare>5000) nbshare = 5000;
1030         
1031         actionValue += uint32( nbshare );
1032         
1033     
1034          uint16[6] memory actionPrice =[
1035         
1036         1000,   //apple
1037         4000,   //powerup shield
1038         5000,   //powerup speed 
1039         2000,   //chest
1040         1000,   //banana action
1041         3000   //attack
1042       
1043         ];  
1044         
1045         if (actionValue<actionPrice[action] && gamevar.turnround>0)
1046         {
1047            
1048             return( actionValue );
1049         }
1050         
1051         if (actionValue>=actionPrice[action])
1052         {
1053             GameRoundData[ this_gRND].actionBlockNumber[ action] = block.number;
1054              
1055             actionValue = 0;
1056         }
1057         else action = 100; //this is the first action
1058         
1059         gamevar.turnround++;
1060      
1061         
1062       
1063         
1064         gamevar.this_gRND = this_gRND;
1065         gamevar.winner = GameRoundData[ gamevar.this_gRND].extraData[1];
1066       
1067         
1068         uint i;
1069             
1070         for( i=0;i<4;i++)
1071         {
1072                 gamevar.perso_energy[i] = GameRoundData[ gamevar.this_gRND].persoData[i];
1073                 gamevar.perso_distance[i] = GameRoundData[ gamevar.this_gRND].persoData[4+i];
1074                 gamevar.powerUpSpeed[i] = GameRoundData[ gamevar.this_gRND].powerUpData[i] / 2;
1075                 gamevar.powerUpShield[i] = GameRoundData[ gamevar.this_gRND].powerUpData[4+i] / 2;
1076     
1077         }
1078         
1079         
1080         
1081         //a little boost for the fist action maker 
1082         if (gamevar.turnround==1) gamevar.perso_energy[ perso ] += 5;
1083         
1084         getSeed( gamevar);
1085     
1086       
1087         if (action==0) actionApple( perso , gamevar );
1088         if (action==1) actionPowerUpShield( perso , gamevar);
1089         if (action==2) actionPowerUpSpeed( perso , gamevar );
1090         if (action==3) actionTreasure( perso, gamevar);
1091         if (action==4) actionBanana(  gamevar);
1092         if (action==5) actionAttack( perso , gamevar);
1093         
1094         gamevar.event_type |= (perso<<16);
1095 
1096         uint32 CurrentWinnerXpos = 0; //gamevar.perso_distance[0]; //this.Racers[n].perso_distance;
1097        
1098         for( i=0; i<4;i++)
1099         {
1100       
1101                 //tiredness
1102                 gamevar.perso_energy[ i ] *= 95;
1103                 gamevar.perso_energy[ i ] /= 100;
1104                 
1105                                            
1106                 uint32 spd1 =  (gamevar.perso_energy[ i ]*10) + (gamevar.powerUpSpeed[ i ]*10); 
1107                                        
1108                 gamevar.perso_distance[ i ] = (  (gamevar.perso_distance[ i ]*95) + (spd1*100)  )/100; 
1109                          
1110                if (gamevar.perso_distance[i] > CurrentWinnerXpos)
1111                {
1112                    CurrentWinnerXpos = gamevar.perso_distance[i];
1113                    gamevar.winner = uint8(i);
1114                }
1115                
1116                 GameRoundData[ gamevar.this_gRND].persoData[i] = gamevar.perso_energy[i];
1117                 GameRoundData[ gamevar.this_gRND].persoData[4+i] = gamevar.perso_distance[i];
1118                 GameRoundData[ gamevar.this_gRND].powerUpData[i] = gamevar.powerUpSpeed[i];
1119                 GameRoundData[ gamevar.this_gRND].powerUpData[4+i] = gamevar.powerUpShield[i];
1120         
1121         }
1122          
1123         GameRoundData[ gamevar.this_gRND ].extraData[0] = gamevar.turnround;
1124         
1125         GameRoundData[ gamevar.this_gRND].extraData[1] = 1+gamevar.winner;
1126         
1127         gamevar.blockNumberTimeout = block.number + ((24*3600) / blockTimeAverage);
1128         
1129         GameRoundData[ gamevar.this_gRND].blockNumberTimeout = gamevar.blockNumberTimeout;
1130         
1131     
1132         
1133         emitRound( gamevar , _player_address);
1134         
1135         return( actionValue );
1136     }
1137   
1138     function emitRound(GameVar_s gamevar , address _player_address) private
1139     {
1140            emit onNewRound(
1141             gamevar.this_gRND,   
1142             gamevar.turnround,
1143             gamevar.event_type,
1144             gamevar.event_target,
1145             gamevar.perso_energy,
1146             gamevar.perso_distance,
1147             gamevar.powerUpSpeed,
1148             gamevar.powerUpShield,
1149             gamevar.blockNumberTimeout,
1150             gamevar.treasureAmountFind,
1151             _player_address
1152            
1153         );
1154         
1155     }
1156    
1157     
1158     function get_Gains(address _player_address) private view
1159     returns( uint256)
1160     {
1161        
1162         uint256 _gains = PlayerData[ _player_address ].chest.add( get_PendingGains( _player_address , PlayerData[ _player_address].gRND ) );
1163         
1164         if (_gains > PlayerData[ _player_address].payoutsTo)
1165         {
1166             _gains -= PlayerData[ _player_address].payoutsTo;
1167         }
1168         else _gains = 0;
1169      
1170     
1171         return( _gains );
1172         
1173     }
1174     
1175     
1176     function WithdrawGains() public 
1177     isPlayer
1178     {
1179         address _customer_address = msg.sender;
1180         
1181         uint256 _gains = get_Gains( _customer_address );
1182         
1183         require( _gains>0);
1184         
1185         PlayerData[ _customer_address ].payoutsTo = PlayerData[ _customer_address ].payoutsTo.add( _gains );
1186         
1187       
1188         emit onWithdrawGains( _customer_address , _gains , now);
1189         
1190         _customer_address.transfer( _gains );
1191         
1192         
1193     }
1194     
1195     function getSeed(GameVar_s gamevar) private view
1196    
1197     {
1198             uint256 _seed =  uint256( blockhash( block.number-1) );
1199             _seed ^= uint256( blockhash( block.number-2) );
1200             _seed ^= uint256(block.coinbase) / now;
1201             _seed += gamevar.perso_distance[0];
1202             _seed += gamevar.perso_distance[1];
1203             _seed += gamevar.perso_distance[2];
1204             _seed += gamevar.perso_distance[3];
1205             
1206             _seed += gasleft();
1207             
1208             gamevar.seed = keccak256(abi.encodePacked( _seed));
1209         
1210             
1211     }
1212     
1213     function CloseEntry() public
1214     onlyOwner
1215     isNotMaintenance
1216     {
1217     
1218         GameRoundData_s storage  _GameRoundData = GameRoundData[ this_gRND ];
1219          
1220         process_Taxes( _GameRoundData);
1221           
1222         emit onCloseEntry( this_gRND );
1223       
1224     }
1225     
1226    
1227     
1228     
1229     function get_probability( bytes32 seed ,  uint32 bytepos , uint32 percentage) pure private
1230     returns( bool )
1231     {
1232        uint32 v = uint32(seed[bytepos]);
1233        
1234        if (v<= ((255*percentage)/100)) return( true );
1235        else return( false );
1236      
1237     }
1238     
1239     function get_modulo_value( bytes32 seed , uint32 bytepos, uint32 mod) pure private
1240     returns( uint32 )
1241     {
1242       
1243         return( ((uint32(seed[ bytepos])*256)+(uint32(seed[ bytepos+1]))) % mod);
1244     }
1245     
1246   
1247     
1248   
1249   
1250     
1251      /*================================
1252     =  VIEW AND HELPERS FUNCTIONS    =
1253     ================================*/
1254   
1255     
1256     function view_get_Treasure() public
1257     view
1258     returns(uint256)
1259     {
1260       
1261       return( genTreasure);  
1262     }
1263     
1264     function view_get_allFees() public
1265     view
1266     returns(uint256)
1267     {
1268       
1269       return( (GameRoundData[ this_gRND].allFeeSupply * GameRoundData[ this_gRND].sharePrice) / magnitude);  
1270     }
1271  
1272     function view_get_gameData() public
1273     view
1274     returns( uint256 sharePrice, uint256[4] sharePots, uint256 shareSupply , uint256 shareEthBalance, uint128[4] treasurePerShare, uint32[4] totalPlayers , uint32[6] actionValue , uint256[4] shares , uint256 treasure_payoutsTo ,uint256 treasureSupply  )
1275     {
1276         address _player_address = msg.sender;
1277          
1278         sharePrice = GameRoundData[ this_gRND].sharePrice;
1279         sharePots = GameRoundData[ this_gRND].sharePots;
1280         shareSupply = GameRoundData[ this_gRND].shareSupply;
1281         shareEthBalance = GameRoundData[ this_gRND].shareEthBalance;
1282         treasurePerShare = GameRoundData[ this_gRND].treasurePerShare;
1283         
1284         treasureSupply = GameRoundData[ this_gRND].treasureSupply;
1285         
1286         uint32[4] memory totalPlayersm;
1287        
1288         totalPlayersm[0] = GameRoundData[ this_gRND].extraData[2];
1289         totalPlayersm[1] = GameRoundData[ this_gRND].extraData[3];
1290         totalPlayersm[2] = GameRoundData[ this_gRND].extraData[4];
1291         totalPlayersm[3] = GameRoundData[ this_gRND].extraData[5];
1292         
1293        
1294         totalPlayers = totalPlayersm;
1295         actionValue = GameRoundData[ this_gRND].actionValue;
1296         
1297         shares = PlayerGameRound[_player_address][this_gRND].shares;
1298         
1299         treasure_payoutsTo = PlayerGameRound[_player_address][this_gRND].treasure_payoutsTo;
1300     }
1301   
1302     
1303     function view_get_Gains()
1304     public
1305     view
1306     returns( uint256 gains)
1307     {
1308         
1309         address _player_address = msg.sender;
1310    
1311       
1312         uint256 _gains = PlayerData[ _player_address ].chest.add( get_PendingGains( _player_address , PlayerData[ _player_address].gRND) );
1313         
1314         if (_gains > PlayerData[ _player_address].payoutsTo)
1315         {
1316             _gains -= PlayerData[ _player_address].payoutsTo;
1317         }
1318         else _gains = 0;
1319      
1320     
1321         return( _gains );
1322         
1323     }
1324   
1325   
1326     
1327     function view_get_gameStates() public 
1328     view
1329     returns(uint8[4] types, uint256 grnd, uint32 turnround, uint256 minimumshare , uint256 blockNumber , uint256 blockNumberTimeout, uint32[6] actionValue , uint32[8] persoData , uint32[8] powerUpData , uint256 blockNumberCurrent , uint256 blockTimeAvg)
1330     {
1331         return( this_Perso_Type, this_gRND , GameRoundData[ this_gRND].extraData[0] , minimumSharePrice , GameRoundData[ this_gRND].blockNumber,GameRoundData[ this_gRND].blockNumberTimeout, GameRoundData[ this_gRND].actionValue , GameRoundData[ this_gRND].persoData , GameRoundData[ this_gRND].powerUpData, block.number , blockTimeAverage /*, view_get_MyRacer()*/);
1332     }
1333     
1334     function view_get_ResultData() public
1335     view
1336     returns(uint32 TotalPlayer, uint256 TotalPayout ,uint256 MyTokenValue, uint256 MyToken, uint256 MyGains , uint256 MyTreasureFound )
1337     {
1338         address _player_address = msg.sender;
1339         
1340         GameRoundData_s storage  _GameRoundData = GameRoundData[ this_gRND ];
1341         
1342         TotalPlayer = _GameRoundData.extraData[2]+_GameRoundData.extraData[3]+_GameRoundData.extraData[4]+_GameRoundData.extraData[5];
1343      
1344         TotalPayout = get_TotalPayout( _GameRoundData );
1345       
1346         MyToken =  PlayerGameRound[ _player_address][ this_gRND].token;
1347           
1348         MyTokenValue = MyToken * HDXcontract.sellingPrice( true );
1349         MyTokenValue /= magnitude;
1350       
1351         MyGains = 0;
1352         MyTreasureFound = 0;
1353         
1354         if (PlayerData[ _player_address].gRND == this_gRND)
1355         {
1356        
1357            MyGains =  get_PendingGainsAll( _player_address , this_gRND ); //just here for the view function so not used for any payout
1358         
1359            
1360            for(uint i=0;i<4;i++)
1361            {
1362              MyTreasureFound += PlayerGameRound[_player_address][ this_gRND].shares[ i ].mul( _GameRoundData.treasurePerShare[ i ] ) / magnitude;
1363            }
1364        
1365        
1366             if (MyTreasureFound >=  PlayerGameRound[_player_address][this_gRND].treasure_payoutsTo) MyTreasureFound = MyTreasureFound.sub(  PlayerGameRound[_player_address][this_gRND].treasure_payoutsTo );
1367             else MyTreasureFound = 0;
1368               
1369            
1370             
1371         }
1372         
1373         
1374     }    
1375  
1376  
1377     function totalEthereumBalance()
1378     public
1379     view
1380     returns(uint256)
1381     {
1382         return address(this).balance;
1383     }
1384     
1385     function view_get_maintenanceMode()
1386     public
1387     view
1388     returns(bool)
1389     {
1390         return( maintenanceMode);
1391     }
1392     
1393     function view_get_blockNumbers()
1394     public
1395     view
1396     returns( uint256 b1 , uint256 b2 )
1397     {
1398         return( block.number , GameRoundData[ this_gRND ].blockNumberTimeout);
1399         
1400     }
1401     
1402    
1403 }
1404 
1405 
1406 library SafeMath {
1407     
1408    
1409     function mul(uint256 a, uint256 b) 
1410         internal 
1411         pure 
1412         returns (uint256 c) 
1413     {
1414         if (a == 0) {
1415             return 0;
1416         }
1417         c = a * b;
1418         require(c / a == b);
1419         return c;
1420     }
1421 
1422    
1423     function sub(uint256 a, uint256 b)
1424         internal
1425         pure
1426         returns (uint256) 
1427     {
1428         require(b <= a);
1429         return a - b;
1430     }
1431 
1432    
1433     function add(uint256 a, uint256 b)
1434         internal
1435         pure
1436         returns (uint256 c) 
1437     {
1438         c = a + b;
1439         require(c >= a);
1440         return c;
1441     }
1442     
1443    
1444     
1445   
1446     
1447    
1448 }
1449 
1450 
1451 library SafeMath128 {
1452     
1453    
1454     function mul(uint128 a, uint128 b) 
1455         internal 
1456         pure 
1457         returns (uint128 c) 
1458     {
1459         if (a == 0) {
1460             return 0;
1461         }
1462         c = a * b;
1463         require(c / a == b);
1464         return c;
1465     }
1466 
1467    
1468     function sub(uint128 a, uint128 b)
1469         internal
1470         pure
1471         returns (uint128) 
1472     {
1473         require(b <= a);
1474         return a - b;
1475     }
1476 
1477    
1478     function add(uint128 a, uint128 b)
1479         internal
1480         pure
1481         returns (uint128 c) 
1482     {
1483         c = a + b;
1484         require(c >= a);
1485         return c;
1486     }
1487     
1488    
1489     
1490   
1491     
1492    
1493 }