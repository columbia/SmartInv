1 /*
2 
3 Introducing "ETHERKNIGHT" 3.1 our first HDX20 POWERED GAME running on the Ethereum Blockchain got a 2nd upgrade 
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
31 .from 1 eth played 40%(50% before) will charge the treasure, 40% (30% before) will buy shares, 5% will buy HDX20 for the player and 15% will appreciate the share price.
32 .adjusted the item price increase function. 
33 
34 This product is copyrighted. Any unauthorized copy, modification, or use without express written consent from HyperDevbox is prohibited.
35 
36 Copyright 2018 HyperDevbox
37 
38 */
39 
40 
41 pragma solidity ^0.4.25;
42 
43 
44 interface HDX20Interface
45 {
46     function() payable external;
47     
48     
49     function buyTokenFromGame( address _customerAddress , address _referrer_address ) payable external returns(uint256);
50   
51     function payWithToken( uint256 _eth , address _player_address ) external returns(uint256);
52   
53     function appreciateTokenPrice() payable external;
54    
55     function totalSupply() external view returns(uint256); 
56     
57     function ethBalanceOf(address _customerAddress) external view returns(uint256);
58   
59     function balanceOf(address _playerAddress) external view returns(uint256);
60     
61     function sellingPrice( bool includeFees) external view returns(uint256);
62   
63 }
64 
65 contract EtherKnightGame
66 {
67      HDX20Interface private HDXcontract = HDX20Interface(0x8942a5995bd168f347f7ec58f25a54a9a064f882);
68      
69      using SafeMath for uint256;
70       using SafeMath128 for uint128;
71      
72      /*==============================
73     =            EVENTS            =
74     ==============================*/
75     event OwnershipTransferred(
76         
77          address previousOwner,
78          address nextOwner,
79           uint256 timeStamp
80          );
81          
82     event HDXcontractChanged(
83         
84          address previous,
85          address next,
86          uint256 timeStamp
87          );
88  
89    
90     
91      event onWithdrawGains(
92         address customerAddress,
93         uint256 ethereumWithdrawn,
94         uint256 timeStamp
95     );
96     
97     event onNewRound(
98         uint256       gRND,
99         uint32        turnRound,
100         uint32        eventType,
101         uint32        eventTarget,
102         uint32[4]     persoEnergy,
103         uint32[4]     persoDistance,
104         uint32[4]     powerUpSpeed,
105         uint32[4]     powerUpShield,
106         uint256       blockNumberTimeout,
107         uint256       treasureAmountFind,
108         address       customerAddress
109         
110        
111        
112     );
113     
114     
115     event onNewRace(
116         
117         uint256 gRND,
118         uint8[4] persoType,
119         uint256  blockNumber
120         
121         );
122         
123     event onBuyShare(
124         address     customerAddress,
125         uint256     gRND,
126         uint32      perso,
127         uint256     nbToken,
128         uint32      actionType,
129         uint32      actionValue
130         );    
131         
132         
133      event onMaintenance(
134         bool        mode,
135         uint256     timeStamp
136 
137         );    
138         
139     event onRefund(
140         address     indexed customerAddress,
141         uint256     eth,
142         uint256     timeStamp
143          
144         );   
145         
146     event onCloseEntry(
147         
148          uint256 gRND
149          
150         );    
151         
152     event onChangeBlockTimeAverage(
153         
154          uint256 blocktimeavg
155          
156         );    
157         
158     /*==============================
159     =            MODIFIERS         =
160     ==============================*/
161     modifier onlyOwner
162     {
163         require (msg.sender == owner );
164         _;
165     }
166     
167     modifier onlyFromHDXToken
168     {
169         require (msg.sender == address( HDXcontract ));
170         _;
171     }
172    
173      modifier onlyDirectTransaction
174     {
175         require (msg.sender == tx.origin);
176         _;
177     }
178    
179    
180      modifier isPlayer
181     {
182         require (PlayerData[ msg.sender].gRND !=0);
183         _;
184     }
185     
186     modifier isMaintenance
187     {
188         require (maintenanceMode==true);
189         _;
190     }
191     
192      modifier isNotMaintenance
193     {
194         require (maintenanceMode==false);
195         _;
196     }
197    
198     // Changing ownership of the contract safely
199     address public owner;
200   
201     
202    
203     
204      /// Contract governance.
205 
206     constructor () public
207     {
208         owner = msg.sender;
209        
210         
211         if ( address(this).balance > 0)
212         {
213             owner.transfer( address(this).balance );
214         }
215     }
216     
217     function changeOwner(address _nextOwner) public
218     onlyOwner
219     {
220         require (_nextOwner != owner);
221         require(_nextOwner != address(0));
222          
223         emit OwnershipTransferred(owner, _nextOwner , now);
224          
225         owner = _nextOwner;
226     }
227     
228     function changeHDXcontract(address _next) public
229     onlyOwner
230     {
231         require (_next != address( HDXcontract ));
232         require( _next != address(0));
233          
234         emit HDXcontractChanged(address(HDXcontract), _next , now);
235          
236         HDXcontract  = HDX20Interface( _next);
237     }
238   
239   
240     
241     function changeBlockTimeAverage( uint256 blocktimeavg) public
242     onlyOwner
243     {
244         require ( blocktimeavg>0 );
245         
246        
247         blockTimeAverage = blocktimeavg;
248         
249         emit onChangeBlockTimeAverage( blockTimeAverage );
250          
251     }
252     
253     function enableMaintenance() public
254     onlyOwner
255     {
256         maintenanceMode = true;
257         
258         emit onMaintenance( maintenanceMode , now);
259         
260     }
261 
262     function disableMaintenance() public
263     onlyOwner
264     {
265         uint8[4] memory perso =[0,1,2,3];
266         
267         maintenanceMode = false;
268         
269         emit onMaintenance( maintenanceMode , now);
270         
271         //reset with a new race
272         initRace( perso );
273     }
274     
275   
276     
277     
278    
279     function refundMe() public
280     isMaintenance
281     {
282         address _playerAddress = msg.sender;
283          
284         
285       
286         require( this_gRND>0 && GameRoundData[ this_gRND].extraData[0]>0 && GameRoundData[ this_gRND].extraData[0]<(1<<30) && PlayerData[ _playerAddress ].gRND==this_gRND);
287         
288         uint256 _eth = 0;
289 
290         for( uint i=0;i<4;i++)
291         {
292             _eth = _eth.add( PlayerGameRound[ _playerAddress][this_gRND].shares[i] * GameRoundData[ this_gRND].sharePrice);
293             
294             PlayerGameRound[ _playerAddress][this_gRND].shares[i] = 0;
295         }
296         
297         if (_eth>0)
298         {
299                _playerAddress.transfer( _eth );  
300                
301                emit onRefund( _playerAddress , _eth , now );
302         }
303         
304     }
305     
306      /*================================
307     =       GAMES VARIABLES         =
308     ================================*/
309     
310     struct PlayerData_s
311     {
312    
313         uint256 chest;  
314         uint256 payoutsTo;
315         uint256 gRND;  
316        
317     }
318     
319     struct PlayerGameRound_s
320     {
321         uint256[4]      shares;
322         uint128         treasure_payoutsTo;    
323         uint128         token;
324       
325        
326     }
327     
328     struct GameRoundData_s
329     {
330        uint256              blockNumber;
331        uint256              blockNumberTimeout;
332        uint256              sharePrice;
333        uint256[4]           sharePots;
334        uint256              shareEthBalance;
335        uint256              shareSupply;
336        uint256              treasureSupply;
337       
338      
339        //this time we want to stream the HDX20 apprecition and dev fees on the way
340        uint256              allFeeSupply;       //to separate the fees from the actual treasure
341        uint256              hdx20AppreciationPayout;
342        uint256              devAppreciationPayout;
343        //
344        
345        uint256              totalTreasureFound;
346        uint256[6]           actionBlockNumber;
347       
348        uint128[4]           treasurePerShare; 
349        uint32[8]            persoData; //energy[4] distance[4]
350        uint32[8]            powerUpData; //Speed[4] Shield[4]
351        
352        uint32[6]            actionValue;
353        
354        uint32[6]            extraData;//[0]==this_TurnRound , [1]==winner , [2-5] totalPlayers
355   
356     }
357     
358   
359    
360     
361  
362     
363    
364     mapping (address => PlayerData_s)   private PlayerData;
365     
366    
367     mapping (address => mapping (uint256 => PlayerGameRound_s)) private PlayerGameRound;
368     
369    
370     mapping (uint256 => GameRoundData_s)   private GameRoundData;
371     
372    
373     bool        private maintenanceMode=false;     
374    
375     uint256     private this_gRND =0;
376   
377  
378   
379   
380     //85 , missing 15% for shares appreciation eg:share price increase
381     uint8 constant private HDX20BuyFees = 5;
382     uint8 constant private TREASUREBuyFees = 40;
383     uint8 constant private BUYPercentage = 40;
384     
385     
386     //the part to keep from the treasure for next round treasure + hdx20 appreciation + dev 
387     uint8 constant private DevFees = 5;
388     uint8 constant private TreasureFees = 10;
389     uint8 constant private AppreciationFees = 25;
390     uint8 constant private AddedFees = DevFees+TreasureFees+AppreciationFees;
391   
392    
393     uint256 constant internal magnitude = 1e18;
394   
395     uint256 private genTreasure = 0;
396    
397     uint256 constant private minimumSharePrice = 0.001 ether;
398     
399     uint256 private blockTimeAverage = 15;  //seconds per block                          
400     
401  
402     uint8[4]    private this_Perso_Type;
403     
404    
405       
406     /*================================
407     =       PUBLIC FUNCTIONS         =
408     ================================*/
409     
410     //fallback will be called only from the HDX token contract to fund the game from customers's HDX20
411     
412      function()
413      payable
414      public
415      onlyFromHDXToken 
416     {
417        
418       
419       
420           
421     }
422     
423     
424     function ChargeTreasure() public payable
425     {
426         genTreasure = SafeMath.add( genTreasure , msg.value);     
427     }
428     
429     
430     function buyTreasureShares(GameRoundData_s storage  _GameRoundData , uint256 _eth ) private
431     returns( uint256)
432     {
433         uint256 _nbshares = (_eth.mul( magnitude)) / _GameRoundData.sharePrice;
434         uint256 _nbsharesForTreasure = (_nbshares.mul( 100-DevFees-TreasureFees-AppreciationFees)) / 100;
435        
436         //now we do separate for streamline payment
437         _GameRoundData.treasureSupply = _GameRoundData.treasureSupply.add( _nbsharesForTreasure );
438         //the difference is for the allFeeSupply
439         _GameRoundData.allFeeSupply = _GameRoundData.allFeeSupply.add( _nbshares - _nbsharesForTreasure);
440         
441         
442         _GameRoundData.shareSupply =   _GameRoundData.shareSupply.add( _nbshares );
443         
444         return( _nbshares);
445     }
446    
447     
448     function initRace( uint8[4] p ) public
449     onlyOwner
450     isNotMaintenance
451     {
452  
453         
454         this_gRND++;
455         
456         GameRoundData_s storage _GameRoundData = GameRoundData[ this_gRND ];
457        
458         for( uint i=0;i<4;i++)
459         {
460            this_Perso_Type[i] = p[i];
461        
462             _GameRoundData.persoData[i] = 100;
463             _GameRoundData.persoData[4+i] = 25;
464             
465         }
466        
467         _GameRoundData.blockNumber = block.number;
468         
469         _GameRoundData.blockNumberTimeout = block.number + (360*10*24*3600); 
470         
471         uint256 _sharePrice = 0.001 ether; // minimumSharePrice;
472         
473         _GameRoundData.sharePrice = _sharePrice;
474         
475         uint256 _nbshares = buyTreasureShares(_GameRoundData, genTreasure );
476      
477         //convert into ETH
478         _nbshares = _nbshares.mul( _sharePrice ) / magnitude;
479         
480         //start balance   
481         _GameRoundData.shareEthBalance = _nbshares;
482         
483         genTreasure = genTreasure.sub( _nbshares);
484      
485        
486         emit onNewRace( this_gRND , p , block.number);
487         
488     }
489     
490     
491    
492     function get_TotalPayout(  GameRoundData_s storage  _GameRoundData ) private view
493     returns( uint256)
494     {
495       
496        uint256 _payout = 0;
497         
498        uint256 _sharePrice = _GameRoundData.sharePrice;
499      
500        for(uint i=0;i<4;i++)
501        {
502            uint256 _bet = _GameRoundData.sharePots[i];
503            
504            _payout = _payout.add( _bet.mul (_sharePrice) / magnitude );
505        }           
506          
507        //from the whole treasure now since new version         
508        uint256 _potValue = (_GameRoundData.treasureSupply.mul( _sharePrice )) / magnitude;
509        
510        
511        _payout = _payout.add( _potValue ).add(_GameRoundData.totalTreasureFound );
512        
513    
514        return( _payout );
515         
516     }
517     
518     
519   
520     function get_PendingGains( address _player_address , uint256 _gRND) private view
521     returns( uint256)
522     {
523        
524        //did not play 
525        if (PlayerData[ _player_address].gRND != _gRND || _gRND==0) return( 0 );
526        
527        GameRoundData_s storage  _GameRoundData = GameRoundData[ _gRND ];
528        
529      
530        uint32 _winner = _GameRoundData.extraData[1];
531        
532        uint256 _gains = 0;
533        uint256 _treasure = 0;
534        uint256 _sharePrice = _GameRoundData.sharePrice;
535        uint256 _shares;
536        
537        PlayerGameRound_s storage  _PlayerGameRound = PlayerGameRound[ _player_address][_gRND];
538        
539        for(uint i=0;i<4;i++)
540        {
541            _shares = _PlayerGameRound.shares[ i ];
542             
543            _gains = _gains.add( _shares.mul( _sharePrice) / magnitude );
544         
545            
546            _treasure = _treasure.add(_shares.mul( _GameRoundData.treasurePerShare[ i ] ) / magnitude);
547            
548        }
549        
550         if (_treasure >=  _PlayerGameRound.treasure_payoutsTo) _treasure = _treasure.sub(_PlayerGameRound.treasure_payoutsTo );
551        else _treasure = 0;
552            
553        _gains = _gains.add(_treasure );
554        
555        //if the race payment is made (race is over) then we add also the winner prize
556        if (_winner>0 && _GameRoundData.extraData[0] >= (1<<30))
557        {
558            _shares = _PlayerGameRound.shares[ _winner-1 ];
559            
560            if (_shares>0)
561            {
562                //from the whole treasure now since new version   
563                _treasure = (_GameRoundData.treasureSupply.mul( _sharePrice )) / magnitude;
564        
565                
566                _gains = _gains.add(  _treasure.mul( _shares ) / _GameRoundData.sharePots[ _winner-1]  );
567                
568            }
569            
570        }
571     
572        
573         return( _gains );
574         
575     }
576     
577     
578     //only for the Result Data Screen on the game not used for the payout
579     
580     function get_PendingGainsAll( address _player_address , uint256 _gRND) private view
581     returns( uint256)
582     {
583        
584        //did not play 
585        if (PlayerData[ _player_address].gRND != _gRND || _gRND==0) return( 0 );
586        
587        GameRoundData_s storage  _GameRoundData = GameRoundData[ _gRND ];
588        
589      
590        uint32 _winner = _GameRoundData.extraData[1];
591        
592        uint256 _gains = 0;
593        uint256 _treasure = 0;
594        uint256 _sharePrice = _GameRoundData.sharePrice;
595        uint256 _shares;
596        
597        PlayerGameRound_s storage  _PlayerGameRound = PlayerGameRound[ _player_address][_gRND];
598        
599        for(uint i=0;i<4;i++)
600        {
601            _shares = _PlayerGameRound.shares[ i ];
602             
603            _gains = _gains.add( _shares.mul( _sharePrice) / magnitude );
604         
605            
606            _treasure = _treasure.add(_shares.mul( _GameRoundData.treasurePerShare[ i ] ) / magnitude);
607            
608        }
609        
610         if (_treasure >=  _PlayerGameRound.treasure_payoutsTo) _treasure = _treasure.sub(_PlayerGameRound.treasure_payoutsTo );
611        else _treasure = 0;
612            
613        _gains = _gains.add(_treasure );
614        
615      
616        if (_winner>0)
617        {
618            _shares = _PlayerGameRound.shares[ _winner-1 ];
619            
620            if (_shares>0)
621            {
622                //from the whole treasure now since new version 
623                _treasure = (_GameRoundData.treasureSupply.mul( _sharePrice )) / magnitude;
624        
625                
626                _gains = _gains.add(  _treasure.mul( _shares ) / _GameRoundData.sharePots[ _winner-1]  );
627                
628            }
629            
630        }
631     
632        
633         return( _gains );
634         
635     }
636     
637        //process streaming HDX20 appreciation and dev fees appreciation
638     function process_sub_Taxes(  GameRoundData_s storage _GameRoundData , uint256 minimum) private
639     {
640         uint256 _sharePrice = _GameRoundData.sharePrice;
641              
642         uint256 _potValue = _GameRoundData.allFeeSupply.mul( _sharePrice ) / magnitude;
643             
644         uint256 _appreciation = SafeMath.mul( _potValue , AppreciationFees) / AddedFees; 
645           
646         uint256 _dev = SafeMath.mul( _potValue , DevFees) / AddedFees;   
647         
648         if (_dev > _GameRoundData.devAppreciationPayout)
649         {
650             _dev -= _GameRoundData.devAppreciationPayout;
651             
652             if (_dev>minimum)
653             {
654               _GameRoundData.devAppreciationPayout = _GameRoundData.devAppreciationPayout.add( _dev );
655               
656                HDXcontract.buyTokenFromGame.value( _dev )( owner , address(0));
657               
658             }
659         }
660         
661         if (_appreciation> _GameRoundData.hdx20AppreciationPayout)
662         {
663             _appreciation -= _GameRoundData.hdx20AppreciationPayout;
664             
665             if (_appreciation>minimum)
666             {
667                 _GameRoundData.hdx20AppreciationPayout = _GameRoundData.hdx20AppreciationPayout.add( _appreciation );
668                 
669                  HDXcontract.appreciateTokenPrice.value( _appreciation )();
670                 
671             }
672         }
673         
674     }
675     
676     //process the fees, hdx20 appreciation, calcul results at the end of the race
677     function process_Taxes(  GameRoundData_s storage _GameRoundData ) private
678     {
679         uint32 turnround = _GameRoundData.extraData[0];
680         
681         if (turnround>0 && turnround<(1<<30))
682         {  
683             _GameRoundData.extraData[0] = turnround | (1<<30);
684             
685             uint256 _sharePrice = _GameRoundData.sharePrice;
686              
687             uint256 _potValue = _GameRoundData.allFeeSupply.mul( _sharePrice ) / magnitude;
688      
689            
690             uint256 _treasure = SafeMath.mul( _potValue , TreasureFees) / AddedFees; 
691          
692            
693             genTreasure = genTreasure.add( _treasure );
694             
695             //take care of any left over
696             process_sub_Taxes( _GameRoundData , 0);
697             
698             
699         }
700      
701     }
702     
703     
704     
705     function BuyShareWithDividends( uint32 perso , uint256 eth , uint32 action, address _referrer_address ) public
706     onlyDirectTransaction
707     {
708   
709         require( maintenanceMode==false  && this_gRND>0 && (eth>=minimumSharePrice) && (eth <=100 ether) &&  perso<=3 && action <=5 && block.number <GameRoundData[ this_gRND ].blockNumberTimeout );
710   
711         address _customer_address = msg.sender;
712         
713         eth = HDXcontract.payWithToken( eth , _customer_address );
714        
715         require( eth>0 );
716          
717         CoreBuyShare( _customer_address , perso , eth , action , _referrer_address );
718         
719        
720     }
721     
722     function BuyShare(   uint32 perso , uint32 action , address _referrer_address ) public payable
723     onlyDirectTransaction
724     {
725      
726          
727         address _customer_address = msg.sender;
728         uint256 eth = msg.value;
729         
730         require( maintenanceMode==false  && this_gRND>0 && (eth>=minimumSharePrice) &&(eth <=100 ether) && perso<=3 && action <=5 && block.number <GameRoundData[ this_gRND ].blockNumberTimeout);
731    
732          
733         CoreBuyShare( _customer_address , perso , eth , action , _referrer_address);
734      
735     }
736     
737     /*================================
738     =       CORE BUY FUNCTIONS       =
739     ================================*/
740     
741     function CoreBuyShare( address _player_address , uint32 perso , uint256 eth , uint32 action ,  address _referrer_address ) private
742     {
743     
744         PlayerGameRound_s storage  _PlayerGameRound = PlayerGameRound[ _player_address][ this_gRND];
745         
746         GameRoundData_s storage  _GameRoundData = GameRoundData[ this_gRND ];
747         
748       
749         if (PlayerData[ _player_address].gRND != this_gRND)
750         {
751            
752             if (PlayerData[_player_address].gRND !=0)
753             {
754                 uint256 _gains = get_PendingGains( _player_address , PlayerData[ _player_address].gRND  );
755             
756                  PlayerData[ _player_address].chest = PlayerData[ _player_address].chest.add( _gains);
757             }
758           
759           
760             PlayerData[ _player_address ].gRND = this_gRND;
761            
762    
763         }
764         
765         //HDX20BuyFees
766         uint256 _tempo = (eth.mul(HDX20BuyFees)) / 100;
767         
768         _GameRoundData.shareEthBalance =  _GameRoundData.shareEthBalance.add( eth-_tempo );  //minus the hdx20 fees
769         
770         uint256 _nb_token =   HDXcontract.buyTokenFromGame.value( _tempo )( _player_address , _referrer_address);
771         
772          //keep track for result UI screen how many token bought in this game round
773         _PlayerGameRound.token += uint128(_nb_token);
774         
775         //increase the treasure shares
776         buyTreasureShares(_GameRoundData , (eth.mul(TREASUREBuyFees)) / 100 );
777    
778         //what is left for the player
779         eth = eth.mul( BUYPercentage) / 100;
780         
781         uint256 _nbshare =  (eth.mul( magnitude)) / _GameRoundData.sharePrice;
782         
783         _GameRoundData.shareSupply =  _GameRoundData.shareSupply.add( _nbshare );
784         _GameRoundData.sharePots[ perso ] =  _GameRoundData.sharePots[ perso ].add( _nbshare);
785         
786         _tempo =  _PlayerGameRound.shares[ perso ];
787         
788         if (_tempo==0)
789         {
790             _GameRoundData.extraData[ 2+perso ]++; 
791         }
792         
793         _PlayerGameRound.shares[ perso ] =  _tempo.add( _nbshare);
794    
795         //this will always raise the price after 1 share
796         if (_GameRoundData.shareSupply>magnitude)
797         {
798             _GameRoundData.sharePrice = (_GameRoundData.shareEthBalance.mul( magnitude)) / _GameRoundData.shareSupply;
799         }
800        
801        
802         _PlayerGameRound.treasure_payoutsTo = _PlayerGameRound.treasure_payoutsTo.add( uint128(_nbshare.mul(   _GameRoundData.treasurePerShare[ perso ]  ) / magnitude) );
803      
804         //HDX20 streaming appreciation
805         process_sub_Taxes( _GameRoundData , 0.2 ether);
806         
807         uint32 actionValue = ApplyAction( perso , action , _nbshare , _player_address);
808         
809         _GameRoundData.actionValue[ action] = actionValue;
810         
811         emit onBuyShare( _player_address , this_gRND , perso , _nb_token , action, actionValue  );
812                          
813         
814     }
815     
816      struct GameVar_s
817     {
818         uint32[4]   perso_energy;
819         uint32[4]   perso_distance;
820         uint32[4]   powerUpShield;
821         uint32[4]   powerUpSpeed;
822         
823         uint32      event_type;
824         uint32      event_target;
825      
826         uint32      winner;
827         
828         uint256     this_gRND;
829         
830         uint256     treasureAmountFind;
831         
832         bytes32     seed;
833         
834         uint256     blockNumberTimeout;
835         
836         uint32      turnround;
837       
838     }
839     
840     function actionPowerUpShield( uint32 perso , GameVar_s gamevar) pure private
841     {
842         
843         gamevar.powerUpShield[ perso ] = 100;
844         
845     }
846     
847     function actionPowerUpSpeed( uint32 perso , GameVar_s gamevar) pure private
848     {
849         
850         gamevar.powerUpSpeed[ perso ] = 100;
851         
852     }
853     
854    
855     
856     function actionApple( uint32 perso , GameVar_s gamevar) pure private
857     {
858         
859         gamevar.event_type = 6;     //apple / banana etc...
860         
861         gamevar.event_target = 1<<(perso*3);
862         
863         gamevar.perso_energy[ perso ] += 20; 
864         
865         if (gamevar.perso_energy[ perso] > 150) gamevar.perso_energy[ perso ] = 150;
866         
867     }
868     
869     function actionBanana(  GameVar_s gamevar ) pure private
870     {
871         
872         gamevar.event_type = 6;     //apple / banana etc...
873         
874         uint32 result = 2;
875         
876         uint32 target = get_modulo_value(gamevar.seed,18, 4);
877         
878         if (gamevar.winner>0) target = gamevar.winner-1;
879     
880         
881         uint32 shield = uint32(gamevar.powerUpShield[ target ]);
882         
883         if (shield>20) result = 5; //jumping banana
884         else
885         {
886                     uint32 dd = 4 * (101 - shield);
887                                    
888                   
889                     
890                     if (gamevar.perso_distance[ target ]>=dd)  gamevar.perso_distance[ target ] -= dd;
891                     else  gamevar.perso_distance[ target ] = 0;
892                     
893         }
894         
895         gamevar.event_target = result<<(target*3);
896         
897        
898         
899     }
900     
901     function getTreasureProbabilityType( bytes32 seed ) private pure
902     returns( uint32 )
903     {
904            uint8[22] memory this_TreasureProbability =[
905     
906         1,1,1,1,1,1,1,1,1,1,1,1,    //12 chances to have 10%
907         2,2,2,2,2,2,                //6 chances to have 15%
908         3,3,3,                      //3 chances to have 20%
909         4                           //1 chance to have 25%
910        
911         ];       
912         
913         return( this_TreasureProbability[ get_modulo_value(seed,24, 22) ] );
914     }
915     
916    
917     
918     function distribute_treasure( uint32 type2 , uint32 target , GameVar_s gamevar) private
919     {
920         uint8[5] memory this_TreasureValue =[
921         
922         1,
923         10,
924         15,
925         20,
926         25
927       
928         ];  
929         
930         //from the whole treasure now since new version 
931         uint256 _treasureSupply = GameRoundData[ gamevar.this_gRND].treasureSupply;
932       
933         
934         uint256 _sharePrice = GameRoundData[ gamevar.this_gRND].sharePrice;
935         uint256 _shareSupply = GameRoundData[ gamevar.this_gRND].shareSupply;
936        
937         //how many shares to sell
938         uint256  _amount = _treasureSupply.mul(this_TreasureValue[ type2 ] )  / 100;
939        
940         GameRoundData[ gamevar.this_gRND].treasureSupply = _treasureSupply.sub( _amount );
941         GameRoundData[ gamevar.this_gRND].shareSupply =  _shareSupply.sub( _amount );
942         
943         //in eth
944         _amount = _amount.mul( _sharePrice ) / magnitude;
945         
946         //price of shares should not change
947         GameRoundData[ gamevar.this_gRND].shareEthBalance =  GameRoundData[ gamevar.this_gRND].shareEthBalance.sub( _amount );
948         
949         gamevar.treasureAmountFind = _amount;
950        
951         GameRoundData[ gamevar.this_gRND].totalTreasureFound =   GameRoundData[ gamevar.this_gRND].totalTreasureFound.add( _amount );
952        
953         uint256 _shares = GameRoundData[ gamevar.this_gRND].sharePots[ target ];
954     
955         if (_shares>0)
956         {
957            
958             GameRoundData[ gamevar.this_gRND].treasurePerShare[ target ] =  GameRoundData[ gamevar.this_gRND].treasurePerShare[ target ].add( uint128(((_amount.mul(magnitude)) / _shares)));
959         }
960         
961     }
962     
963     function actionTreasure( uint32 perso, GameVar_s gamevar ) private
964     {
965         gamevar.event_target =  get_modulo_value(gamevar.seed,18,  14);
966         gamevar.event_type = getTreasureProbabilityType( gamevar.seed );
967                                                     
968         if (gamevar.event_target==perso)
969         {
970 
971                 distribute_treasure( gamevar.event_type , gamevar.event_target, gamevar);
972         }
973         
974        
975     }
976     
977     function apply_attack( uint32 perso, uint32 target , GameVar_s gamevar) pure private
978     {
979         for(uint i=0;i<4;i++)
980         {
981             uint32 damage = (1+(target % 3)) * 10;
982             
983             uint32 shield = uint32(  gamevar.powerUpShield[i] );
984             
985             if (damage<= shield || i==perso) damage = 0;
986             else damage -=  shield;
987             
988             if (damage<gamevar.perso_energy[i]) gamevar.perso_energy[i] -= damage;
989             else gamevar.perso_energy[i] = 1;   //minimum
990             
991             target >>= 2;
992             
993         }
994         
995     }
996     
997     
998     function actionAttack( uint32 perso , GameVar_s gamevar ) pure private
999     {
1000             gamevar.event_type =  5; 
1001             gamevar.event_target = get_modulo_value(gamevar.seed,24,256);     //8 bits 4x2
1002             
1003             apply_attack( perso , gamevar.event_target , gamevar);    
1004     }
1005     
1006     function ApplyAction( uint32 perso ,  uint32 action , uint256 nbshare , address _player_address) private
1007     returns( uint32)
1008     {
1009         uint32 actionValue = GameRoundData[ this_gRND].actionValue[ action ];
1010         
1011         //only the last one is activating within the same block
1012         if (block.number<= GameRoundData[ this_gRND].actionBlockNumber[ action]) return( actionValue);
1013         
1014         GameVar_s memory gamevar;
1015           
1016         gamevar.turnround = GameRoundData[ this_gRND ].extraData[0];
1017         
1018         //now we introduce a new price increase for the items
1019         nbshare = nbshare.mul(100*100);
1020         nbshare /= (100+(gamevar.turnround/6));
1021         
1022         nbshare /= magnitude;
1023       
1024         nbshare += 10;
1025         
1026         if (nbshare>5000) nbshare = 5000;
1027         
1028         actionValue += uint32( nbshare );
1029         
1030     
1031          uint16[6] memory actionPrice =[
1032         
1033         1000,   //apple
1034         4000,   //powerup shield
1035         5000,   //powerup speed 
1036         2000,   //chest
1037         1000,   //banana action
1038         3000   //attack
1039       
1040         ];  
1041         
1042         if (actionValue<actionPrice[action] && gamevar.turnround>0)
1043         {
1044            
1045             return( actionValue );
1046         }
1047         
1048         if (actionValue>=actionPrice[action])
1049         {
1050             GameRoundData[ this_gRND].actionBlockNumber[ action] = block.number;
1051              
1052             actionValue = 0;
1053         }
1054         else action = 100; //this is the first action
1055         
1056         gamevar.turnround++;
1057      
1058         
1059       
1060         
1061         gamevar.this_gRND = this_gRND;
1062         gamevar.winner = GameRoundData[ gamevar.this_gRND].extraData[1];
1063       
1064         
1065         uint i;
1066             
1067         for( i=0;i<4;i++)
1068         {
1069                 gamevar.perso_energy[i] = GameRoundData[ gamevar.this_gRND].persoData[i];
1070                 gamevar.perso_distance[i] = GameRoundData[ gamevar.this_gRND].persoData[4+i];
1071                 gamevar.powerUpSpeed[i] = GameRoundData[ gamevar.this_gRND].powerUpData[i] / 2;
1072                 gamevar.powerUpShield[i] = GameRoundData[ gamevar.this_gRND].powerUpData[4+i] / 2;
1073     
1074         }
1075         
1076         
1077         
1078         //a little boost for the fist action maker 
1079         if (gamevar.turnround==1) gamevar.perso_energy[ perso ] += 5;
1080         
1081         getSeed( gamevar);
1082     
1083       
1084         if (action==0) actionApple( perso , gamevar );
1085         if (action==1) actionPowerUpShield( perso , gamevar);
1086         if (action==2) actionPowerUpSpeed( perso , gamevar );
1087         if (action==3) actionTreasure( perso, gamevar);
1088         if (action==4) actionBanana(  gamevar);
1089         if (action==5) actionAttack( perso , gamevar);
1090         
1091         gamevar.event_type |= (perso<<16);
1092 
1093         uint32 CurrentWinnerXpos = 0; //gamevar.perso_distance[0]; //this.Racers[n].perso_distance;
1094        
1095         for( i=0; i<4;i++)
1096         {
1097       
1098                 //tiredness
1099                 gamevar.perso_energy[ i ] *= 95;
1100                 gamevar.perso_energy[ i ] /= 100;
1101                 
1102                                            
1103                 uint32 spd1 =  (gamevar.perso_energy[ i ]*10) + (gamevar.powerUpSpeed[ i ]*10); 
1104                                        
1105                 gamevar.perso_distance[ i ] = (  (gamevar.perso_distance[ i ]*95) + (spd1*100)  )/100; 
1106                          
1107                if (gamevar.perso_distance[i] > CurrentWinnerXpos)
1108                {
1109                    CurrentWinnerXpos = gamevar.perso_distance[i];
1110                    gamevar.winner = uint8(i);
1111                }
1112                
1113                 GameRoundData[ gamevar.this_gRND].persoData[i] = gamevar.perso_energy[i];
1114                 GameRoundData[ gamevar.this_gRND].persoData[4+i] = gamevar.perso_distance[i];
1115                 GameRoundData[ gamevar.this_gRND].powerUpData[i] = gamevar.powerUpSpeed[i];
1116                 GameRoundData[ gamevar.this_gRND].powerUpData[4+i] = gamevar.powerUpShield[i];
1117         
1118         }
1119          
1120         GameRoundData[ gamevar.this_gRND ].extraData[0] = gamevar.turnround;
1121         
1122         GameRoundData[ gamevar.this_gRND].extraData[1] = 1+gamevar.winner;
1123         
1124         gamevar.blockNumberTimeout = block.number + ((24*3600) / blockTimeAverage);
1125         
1126         GameRoundData[ gamevar.this_gRND].blockNumberTimeout = gamevar.blockNumberTimeout;
1127         
1128     
1129         
1130         emitRound( gamevar , _player_address);
1131         
1132         return( actionValue );
1133     }
1134   
1135     function emitRound(GameVar_s gamevar , address _player_address) private
1136     {
1137            emit onNewRound(
1138             gamevar.this_gRND,   
1139             gamevar.turnround,
1140             gamevar.event_type,
1141             gamevar.event_target,
1142             gamevar.perso_energy,
1143             gamevar.perso_distance,
1144             gamevar.powerUpSpeed,
1145             gamevar.powerUpShield,
1146             gamevar.blockNumberTimeout,
1147             gamevar.treasureAmountFind,
1148             _player_address
1149            
1150         );
1151         
1152     }
1153    
1154     
1155     function get_Gains(address _player_address) private view
1156     returns( uint256)
1157     {
1158        
1159         uint256 _gains = PlayerData[ _player_address ].chest.add( get_PendingGains( _player_address , PlayerData[ _player_address].gRND ) );
1160         
1161         if (_gains > PlayerData[ _player_address].payoutsTo)
1162         {
1163             _gains -= PlayerData[ _player_address].payoutsTo;
1164         }
1165         else _gains = 0;
1166      
1167     
1168         return( _gains );
1169         
1170     }
1171     
1172     
1173     function WithdrawGains() public 
1174     isPlayer
1175     {
1176         address _customer_address = msg.sender;
1177         
1178         uint256 _gains = get_Gains( _customer_address );
1179         
1180         require( _gains>0);
1181         
1182         PlayerData[ _customer_address ].payoutsTo = PlayerData[ _customer_address ].payoutsTo.add( _gains );
1183         
1184       
1185         emit onWithdrawGains( _customer_address , _gains , now);
1186         
1187         _customer_address.transfer( _gains );
1188         
1189         
1190     }
1191     
1192     function getSeed(GameVar_s gamevar) private view
1193    
1194     {
1195             uint256 _seed =  uint256( blockhash( block.number-1) );
1196             _seed ^= uint256( blockhash( block.number-2) );
1197             _seed ^= uint256(block.coinbase) / now;
1198             _seed += gamevar.perso_distance[0];
1199             _seed += gamevar.perso_distance[1];
1200             _seed += gamevar.perso_distance[2];
1201             _seed += gamevar.perso_distance[3];
1202             
1203             _seed += gasleft();
1204             
1205             gamevar.seed = keccak256(abi.encodePacked( _seed));
1206         
1207             
1208     }
1209     
1210     function CloseEntry() public
1211     onlyOwner
1212     isNotMaintenance
1213     {
1214     
1215         GameRoundData_s storage  _GameRoundData = GameRoundData[ this_gRND ];
1216          
1217         process_Taxes( _GameRoundData);
1218           
1219         emit onCloseEntry( this_gRND );
1220       
1221     }
1222     
1223    
1224     
1225     
1226     function get_probability( bytes32 seed ,  uint32 bytepos , uint32 percentage) pure private
1227     returns( bool )
1228     {
1229        uint32 v = uint32(seed[bytepos]);
1230        
1231        if (v<= ((255*percentage)/100)) return( true );
1232        else return( false );
1233      
1234     }
1235     
1236     function get_modulo_value( bytes32 seed , uint32 bytepos, uint32 mod) pure private
1237     returns( uint32 )
1238     {
1239       
1240         return( ((uint32(seed[ bytepos])*256)+(uint32(seed[ bytepos+1]))) % mod);
1241     }
1242     
1243   
1244     
1245   
1246   
1247     
1248      /*================================
1249     =  VIEW AND HELPERS FUNCTIONS    =
1250     ================================*/
1251   
1252     
1253     function view_get_Treasure() public
1254     view
1255     returns(uint256)
1256     {
1257       
1258       return( genTreasure);  
1259     }
1260     
1261     function view_get_allFees() public
1262     view
1263     returns(uint256)
1264     {
1265       
1266       return( (GameRoundData[ this_gRND].allFeeSupply * GameRoundData[ this_gRND].sharePrice) / magnitude);  
1267     }
1268  
1269     function view_get_gameData() public
1270     view
1271     returns( uint256 sharePrice, uint256[4] sharePots, uint256 shareSupply , uint256 shareEthBalance, uint128[4] treasurePerShare, uint32[4] totalPlayers , uint32[6] actionValue , uint256[4] shares , uint256 treasure_payoutsTo ,uint256 treasureSupply  )
1272     {
1273         address _player_address = msg.sender;
1274          
1275         sharePrice = GameRoundData[ this_gRND].sharePrice;
1276         sharePots = GameRoundData[ this_gRND].sharePots;
1277         shareSupply = GameRoundData[ this_gRND].shareSupply;
1278         shareEthBalance = GameRoundData[ this_gRND].shareEthBalance;
1279         treasurePerShare = GameRoundData[ this_gRND].treasurePerShare;
1280         
1281         treasureSupply = GameRoundData[ this_gRND].treasureSupply;
1282         
1283         uint32[4] memory totalPlayersm;
1284        
1285         totalPlayersm[0] = GameRoundData[ this_gRND].extraData[2];
1286         totalPlayersm[1] = GameRoundData[ this_gRND].extraData[3];
1287         totalPlayersm[2] = GameRoundData[ this_gRND].extraData[4];
1288         totalPlayersm[3] = GameRoundData[ this_gRND].extraData[5];
1289         
1290        
1291         totalPlayers = totalPlayersm;
1292         actionValue = GameRoundData[ this_gRND].actionValue;
1293         
1294         shares = PlayerGameRound[_player_address][this_gRND].shares;
1295         
1296         treasure_payoutsTo = PlayerGameRound[_player_address][this_gRND].treasure_payoutsTo;
1297     }
1298   
1299     
1300     function view_get_Gains()
1301     public
1302     view
1303     returns( uint256 gains)
1304     {
1305         
1306         address _player_address = msg.sender;
1307    
1308       
1309         uint256 _gains = PlayerData[ _player_address ].chest.add( get_PendingGains( _player_address , PlayerData[ _player_address].gRND) );
1310         
1311         if (_gains > PlayerData[ _player_address].payoutsTo)
1312         {
1313             _gains -= PlayerData[ _player_address].payoutsTo;
1314         }
1315         else _gains = 0;
1316      
1317     
1318         return( _gains );
1319         
1320     }
1321   
1322   
1323     
1324     function view_get_gameStates() public 
1325     view
1326     returns(uint8[4] types, uint256 grnd, uint32 turnround, uint256 minimumshare , uint256 blockNumber , uint256 blockNumberTimeout, uint32[6] actionValue , uint32[8] persoData , uint32[8] powerUpData , uint256 blockNumberCurrent , uint256 blockTimeAvg)
1327     {
1328         return( this_Perso_Type, this_gRND , GameRoundData[ this_gRND].extraData[0] , minimumSharePrice , GameRoundData[ this_gRND].blockNumber,GameRoundData[ this_gRND].blockNumberTimeout, GameRoundData[ this_gRND].actionValue , GameRoundData[ this_gRND].persoData , GameRoundData[ this_gRND].powerUpData, block.number , blockTimeAverage /*, view_get_MyRacer()*/);
1329     }
1330     
1331     function view_get_ResultData() public
1332     view
1333     returns(uint32 TotalPlayer, uint256 TotalPayout ,uint256 MyTokenValue, uint256 MyToken, uint256 MyGains , uint256 MyTreasureFound )
1334     {
1335         address _player_address = msg.sender;
1336         
1337         GameRoundData_s storage  _GameRoundData = GameRoundData[ this_gRND ];
1338         
1339         TotalPlayer = _GameRoundData.extraData[2]+_GameRoundData.extraData[3]+_GameRoundData.extraData[4]+_GameRoundData.extraData[5];
1340      
1341         TotalPayout = get_TotalPayout( _GameRoundData );
1342       
1343         MyToken =  PlayerGameRound[ _player_address][ this_gRND].token;
1344           
1345         MyTokenValue = MyToken * HDXcontract.sellingPrice( true );
1346         MyTokenValue /= magnitude;
1347       
1348         MyGains = 0;
1349         MyTreasureFound = 0;
1350         
1351         if (PlayerData[ _player_address].gRND == this_gRND)
1352         {
1353        
1354            MyGains =  get_PendingGainsAll( _player_address , this_gRND ); //just here for the view function so not used for any payout
1355         
1356            
1357            for(uint i=0;i<4;i++)
1358            {
1359              MyTreasureFound += PlayerGameRound[_player_address][ this_gRND].shares[ i ].mul( _GameRoundData.treasurePerShare[ i ] ) / magnitude;
1360            }
1361        
1362        
1363             if (MyTreasureFound >=  PlayerGameRound[_player_address][this_gRND].treasure_payoutsTo) MyTreasureFound = MyTreasureFound.sub(  PlayerGameRound[_player_address][this_gRND].treasure_payoutsTo );
1364             else MyTreasureFound = 0;
1365               
1366            
1367             
1368         }
1369         
1370         
1371     }    
1372  
1373  
1374     function totalEthereumBalance()
1375     public
1376     view
1377     returns(uint256)
1378     {
1379         return address(this).balance;
1380     }
1381     
1382     function view_get_maintenanceMode()
1383     public
1384     view
1385     returns(bool)
1386     {
1387         return( maintenanceMode);
1388     }
1389     
1390     function view_get_blockNumbers()
1391     public
1392     view
1393     returns( uint256 b1 , uint256 b2 )
1394     {
1395         return( block.number , GameRoundData[ this_gRND ].blockNumberTimeout);
1396         
1397     }
1398     
1399    
1400 }
1401 
1402 
1403 library SafeMath {
1404     
1405    
1406     function mul(uint256 a, uint256 b) 
1407         internal 
1408         pure 
1409         returns (uint256 c) 
1410     {
1411         if (a == 0) {
1412             return 0;
1413         }
1414         c = a * b;
1415         require(c / a == b);
1416         return c;
1417     }
1418 
1419    
1420     function sub(uint256 a, uint256 b)
1421         internal
1422         pure
1423         returns (uint256) 
1424     {
1425         require(b <= a);
1426         return a - b;
1427     }
1428 
1429    
1430     function add(uint256 a, uint256 b)
1431         internal
1432         pure
1433         returns (uint256 c) 
1434     {
1435         c = a + b;
1436         require(c >= a);
1437         return c;
1438     }
1439     
1440    
1441     
1442   
1443     
1444    
1445 }
1446 
1447 
1448 library SafeMath128 {
1449     
1450    
1451     function mul(uint128 a, uint128 b) 
1452         internal 
1453         pure 
1454         returns (uint128 c) 
1455     {
1456         if (a == 0) {
1457             return 0;
1458         }
1459         c = a * b;
1460         require(c / a == b);
1461         return c;
1462     }
1463 
1464    
1465     function sub(uint128 a, uint128 b)
1466         internal
1467         pure
1468         returns (uint128) 
1469     {
1470         require(b <= a);
1471         return a - b;
1472     }
1473 
1474    
1475     function add(uint128 a, uint128 b)
1476         internal
1477         pure
1478         returns (uint128 c) 
1479     {
1480         c = a + b;
1481         require(c >= a);
1482         return c;
1483     }
1484     
1485    
1486     
1487   
1488     
1489    
1490 }