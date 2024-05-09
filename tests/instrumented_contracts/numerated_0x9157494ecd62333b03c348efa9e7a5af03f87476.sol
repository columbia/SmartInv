1 /*
2 
3 Introducing "ETHERKNIGHT" our first HDX20 POWERED GAME running on the Ethereum Blockchain 
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
24 .10% to the community of HDX20 gamers/holders distributed as price appreciation.
25 .5% to developer for running, developing and expanding the platform.
26 .25% for provisioning the TREASURE for the next Race.
27 
28 This product is copyrighted. Any unauthorized copy, modification, or use without express written consent from HyperDevbox is prohibited.
29 
30 Copyright 2018 HyperDevbox
31 
32 */
33 
34 
35 pragma solidity ^0.4.25;
36 
37 
38 interface HDX20Interface
39 {
40     function() payable external;
41     
42     
43     function buyTokenFromGame( address _customerAddress , address _referrer_address ) payable external returns(uint256);
44   
45     function payWithToken( uint256 _eth , address _player_address ) external returns(uint256);
46   
47     function appreciateTokenPrice() payable external;
48    
49     function totalSupply() external view returns(uint256); 
50     
51     function ethBalanceOf(address _customerAddress) external view returns(uint256);
52   
53     function balanceOf(address _playerAddress) external view returns(uint256);
54     
55     function sellingPrice( bool includeFees) external view returns(uint256);
56   
57 }
58 
59 contract EtherKnightGame
60 {
61      HDX20Interface private HDXcontract = HDX20Interface(0x8942a5995bd168f347f7ec58f25a54a9a064f882);
62      
63      using SafeMath for uint256;
64       using SafeMath128 for uint128;
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
85      event onWithdrawGains(
86         address customerAddress,
87         uint256 ethereumWithdrawn,
88         uint256 timeStamp
89     );
90     
91     event onNewRound(
92         uint256       gRND,
93         uint32        turnRound,
94         uint32        eventType,
95         uint32        eventTarget,
96         uint32[4]     persoEnergy,
97         uint32[4]     persoDistance,
98         uint32[4]     powerUpSpeed,
99         uint32[4]     powerUpShield,
100         uint256       blockNumberTimeout,
101         uint256       treasureAmountFind,
102         address       customerAddress
103         
104        
105        
106     );
107     
108     
109     event onNewRace(
110         
111         uint256 gRND,
112         uint8[4] persoType,
113         uint256  blockNumber
114         
115         );
116         
117     event onBuyShare(
118         address     customerAddress,
119         uint256     gRND,
120         uint32      perso,
121         uint256     nbToken,
122         uint32      actionType,
123         uint32      actionValue
124         );    
125         
126         
127      event onMaintenance(
128         bool        mode,
129         uint256     timeStamp
130 
131         );    
132         
133     event onRefund(
134         address     indexed customerAddress,
135         uint256     eth,
136         uint256     timeStamp
137          
138         );   
139         
140     event onCloseEntry(
141         
142          uint256 gRND
143          
144         );    
145         
146     event onChangeBlockTimeAverage(
147         
148          uint256 blocktimeavg
149          
150         );    
151         
152     /*==============================
153     =            MODIFIERS         =
154     ==============================*/
155     modifier onlyOwner
156     {
157         require (msg.sender == owner );
158         _;
159     }
160     
161     modifier onlyFromHDXToken
162     {
163         require (msg.sender == address( HDXcontract ));
164         _;
165     }
166    
167      modifier onlyDirectTransaction
168     {
169         require (msg.sender == tx.origin);
170         _;
171     }
172    
173    
174      modifier isPlayer
175     {
176         require (PlayerData[ msg.sender].gRND !=0);
177         _;
178     }
179     
180     modifier isMaintenance
181     {
182         require (maintenanceMode==true);
183         _;
184     }
185     
186      modifier isNotMaintenance
187     {
188         require (maintenanceMode==false);
189         _;
190     }
191    
192     // Changing ownership of the contract safely
193     address public owner;
194   
195     
196    
197     
198      /// Contract governance.
199 
200     constructor () public
201     {
202         owner = msg.sender;
203        
204         
205         if ( address(this).balance > 0)
206         {
207             owner.transfer( address(this).balance );
208         }
209     }
210     
211     function changeOwner(address _nextOwner) public
212     onlyOwner
213     {
214         require (_nextOwner != owner);
215         require(_nextOwner != address(0));
216          
217         emit OwnershipTransferred(owner, _nextOwner , now);
218          
219         owner = _nextOwner;
220     }
221     
222     function changeHDXcontract(address _next) public
223     onlyOwner
224     {
225         require (_next != address( HDXcontract ));
226         require( _next != address(0));
227          
228         emit HDXcontractChanged(address(HDXcontract), _next , now);
229          
230         HDXcontract  = HDX20Interface( _next);
231     }
232   
233   
234     
235     function changeBlockTimeAverage( uint256 blocktimeavg) public
236     onlyOwner
237     {
238         require ( blocktimeavg>0 );
239         
240        
241         blockTimeAverage = blocktimeavg;
242         
243         emit onChangeBlockTimeAverage( blockTimeAverage );
244          
245     }
246     
247     function enableMaintenance() public
248     onlyOwner
249     {
250         maintenanceMode = true;
251         
252         emit onMaintenance( maintenanceMode , now);
253         
254     }
255 
256     function disableMaintenance() public
257     onlyOwner
258     {
259         uint8[4] memory perso =[0,1,2,3];
260         
261         maintenanceMode = false;
262         
263         emit onMaintenance( maintenanceMode , now);
264         
265         //reset with a new race
266         initRace( perso );
267     }
268     
269   
270     
271     
272    
273     function refundMe() public
274     isMaintenance
275     {
276         address _playerAddress = msg.sender;
277          
278         
279       
280         require( this_gRND>0 && GameRoundData[ this_gRND].extraData[0]>0 && GameRoundData[ this_gRND].extraData[0]<(1<<30) && PlayerData[ _playerAddress ].gRND==this_gRND);
281         
282         uint256 _eth = 0;
283 
284         for( uint i=0;i<4;i++)
285         {
286             _eth = _eth.add( PlayerGameRound[ _playerAddress][this_gRND].shares[i] * GameRoundData[ this_gRND].sharePrice);
287             
288             PlayerGameRound[ _playerAddress][this_gRND].shares[i] = 0;
289         }
290         
291         if (_eth>0)
292         {
293                _playerAddress.transfer( _eth );  
294                
295                emit onRefund( _playerAddress , _eth , now );
296         }
297         
298     }
299     
300      /*================================
301     =       GAMES VARIABLES         =
302     ================================*/
303     
304     struct PlayerData_s
305     {
306    
307         uint256 chest;  
308         uint256 payoutsTo;
309         uint256 gRND;  
310        
311     }
312     
313     struct PlayerGameRound_s
314     {
315         uint256[4]      shares;
316         uint128         treasure_payoutsTo;    
317         uint128         token;
318       
319        
320     }
321     
322     struct GameRoundData_s
323     {
324        uint256              blockNumber;
325        uint256              blockNumberTimeout;
326        uint256              sharePrice;
327        uint256[4]           sharePots;
328        uint256              shareEthBalance;
329        uint256              shareSupply;
330        uint256              treasureSupply;
331        uint256              totalTreasureFound;
332        uint256[6]           actionBlockNumber;
333       
334        uint128[4]           treasurePerShare; 
335        uint32[8]            persoData; //energy[4] distance[4]
336        uint32[8]            powerUpData; //Speed[4] Shield[4]
337        
338        uint32[6]            actionValue;
339        
340        uint32[6]            extraData;//[0]==this_TurnRound , [1]==winner , [2-5] totalPlayers
341   
342     }
343     
344   
345    
346     
347  
348     
349    
350     mapping (address => PlayerData_s)   private PlayerData;
351     
352    
353     mapping (address => mapping (uint256 => PlayerGameRound_s)) private PlayerGameRound;
354     
355    
356     mapping (uint256 => GameRoundData_s)   private GameRoundData;
357     
358    
359     bool        private maintenanceMode=false;     
360    
361     uint256     private this_gRND =0;
362   
363  
364   
365   
366     //85 , missing 15% for shares appreciation
367     uint8 constant private HDX20BuyFees = 5;
368     uint8 constant private TREASUREBuyFees = 40;
369     uint8 constant private BUYPercentage = 40;
370     
371     
372    
373     uint8 constant private DevFees = 5;
374     uint8 constant private TreasureFees = 25;
375     uint8 constant private AppreciationFees = 10;
376   
377    
378     uint256 constant internal magnitude = 1e18;
379   
380     uint256 private genTreasure = 0;
381    
382     uint256 constant private minimumSharePrice = 0.001 ether;
383     
384     uint256 private blockTimeAverage = 15;  //seconds per block                          
385     
386  
387     uint8[4]    private this_Perso_Type;
388     
389    
390       
391     /*================================
392     =       PUBLIC FUNCTIONS         =
393     ================================*/
394     
395     //fallback will be called only from the HDX token contract to fund the game from customers's HDX20
396     
397      function()
398      payable
399      public
400      onlyFromHDXToken 
401     {
402        
403       
404       
405           
406     }
407     
408     
409     function ChargeTreasure() public payable
410     {
411         genTreasure = SafeMath.add( genTreasure , msg.value);     
412     }
413     
414     
415     function buyTreasureShares(GameRoundData_s storage  _GameRoundData , uint256 _eth ) private
416     returns( uint256)
417     {
418         uint256 _nbshares = (_eth.mul( magnitude)) / _GameRoundData.sharePrice;
419        
420         _GameRoundData.treasureSupply = _GameRoundData.treasureSupply.add( _nbshares );
421         
422         _GameRoundData.shareSupply =   _GameRoundData.shareSupply.add( _nbshares );
423         
424         return( _nbshares);
425     }
426    
427     
428     function initRace( uint8[4] p ) public
429     onlyOwner
430     isNotMaintenance
431     {
432  
433         
434         this_gRND++;
435         
436         GameRoundData_s storage _GameRoundData = GameRoundData[ this_gRND ];
437        
438         for( uint i=0;i<4;i++)
439         {
440            this_Perso_Type[i] = p[i];
441        
442             _GameRoundData.persoData[i] = 100;
443             _GameRoundData.persoData[4+i] = 25;
444             
445         }
446        
447         _GameRoundData.blockNumber = block.number;
448         
449         _GameRoundData.blockNumberTimeout = block.number + (360*10*24*3600); 
450         
451         uint256 _sharePrice = 0.001 ether; // minimumSharePrice;
452         
453         _GameRoundData.sharePrice = _sharePrice;
454         
455         uint256 _nbshares = buyTreasureShares(_GameRoundData, genTreasure );
456      
457         //convert into ETH
458         _nbshares = _nbshares.mul( _sharePrice ) / magnitude;
459         
460         //start balance   
461         _GameRoundData.shareEthBalance = _nbshares;
462         
463         genTreasure = genTreasure.sub( _nbshares);
464      
465        
466         emit onNewRace( this_gRND , p , block.number);
467         
468     }
469     
470     
471    
472     function get_TotalPayout(  GameRoundData_s storage  _GameRoundData ) private view
473     returns( uint256)
474     {
475       
476        uint256 _payout = 0;
477         
478        uint256 _sharePrice = _GameRoundData.sharePrice;
479      
480        for(uint i=0;i<4;i++)
481        {
482            uint256 _bet = _GameRoundData.sharePots[i];
483            
484            _payout = _payout.add( _bet.mul (_sharePrice) / magnitude );
485        }           
486          
487        uint256 _potValue = ((_GameRoundData.treasureSupply.mul( _sharePrice ) / magnitude).mul(100-DevFees-TreasureFees-AppreciationFees)) / 100;
488        
489        
490        _payout = _payout.add( _potValue ).add(_GameRoundData.totalTreasureFound );
491        
492    
493        return( _payout );
494         
495     }
496     
497     
498   
499     function get_PendingGains( address _player_address , uint256 _gRND, bool realmode) private view
500     returns( uint256)
501     {
502        
503        //did not play 
504        if (PlayerData[ _player_address].gRND != _gRND || _gRND==0) return( 0 );
505        
506        GameRoundData_s storage  _GameRoundData = GameRoundData[ _gRND ];
507        
508        if (realmode && _GameRoundData.extraData[0] < (1<<30)) return( 0 ); 
509        
510        uint32 _winner = _GameRoundData.extraData[1];
511        
512        uint256 _gains = 0;
513        uint256 _treasure = 0;
514        uint256 _sharePrice = _GameRoundData.sharePrice;
515        uint256 _shares;
516        
517        PlayerGameRound_s storage  _PlayerGameRound = PlayerGameRound[ _player_address][_gRND];
518        
519        for(uint i=0;i<4;i++)
520        {
521            _shares = _PlayerGameRound.shares[ i ];
522             
523            _gains = _gains.add( _shares.mul( _sharePrice) / magnitude );
524         
525            
526            _treasure = _treasure.add(_shares.mul( _GameRoundData.treasurePerShare[ i ] ) / magnitude);
527            
528        }
529        
530         if (_treasure >=  _PlayerGameRound.treasure_payoutsTo) _treasure = _treasure.sub(_PlayerGameRound.treasure_payoutsTo );
531        else _treasure = 0;
532            
533        _gains = _gains.add(_treasure );
534        
535        if (_winner>0)
536        {
537            _shares = _PlayerGameRound.shares[ _winner-1 ];
538            
539            if (_shares>0)
540            {
541               
542                _treasure = ((_GameRoundData.treasureSupply.mul( _sharePrice ) / magnitude).mul(100-DevFees-TreasureFees-AppreciationFees)) / 100;
543        
544                
545                _gains = _gains.add(  _treasure.mul( _shares ) / _GameRoundData.sharePots[ _winner-1]  );
546                
547            }
548            
549        }
550     
551        
552         return( _gains );
553         
554     }
555     
556     
557     
558     //process the fees, hdx20 appreciation, calcul results at the end of the race
559     function process_Taxes(  GameRoundData_s storage _GameRoundData ) private
560     {
561         uint32 turnround = _GameRoundData.extraData[0];
562         
563         if (turnround>0 && turnround<(1<<30))
564         {  
565             _GameRoundData.extraData[0] = turnround | (1<<30);
566             
567             uint256 _sharePrice = _GameRoundData.sharePrice;
568              
569             uint256 _potValue = _GameRoundData.treasureSupply.mul( _sharePrice ) / magnitude;
570      
571            
572             uint256 _treasure = SafeMath.mul( _potValue , TreasureFees) / 100; 
573             
574             uint256 _appreciation = SafeMath.mul( _potValue , AppreciationFees) / 100; 
575           
576             uint256 _dev = SafeMath.mul( _potValue , DevFees) / 100;
577            
578             genTreasure = genTreasure.add( _treasure );
579             
580             //distribute devfees in hdx20 token
581             if (_dev>0)
582             {
583                 HDXcontract.buyTokenFromGame.value( _dev )( owner , address(0));
584             }
585             
586             //distribute the profit to the token holders pure profit
587             if (_appreciation>0 )
588             {
589                
590                 HDXcontract.appreciateTokenPrice.value( _appreciation )();
591                 
592             }
593             
594           
595             
596             
597         }
598      
599     }
600     
601     
602     
603     function BuyShareWithDividends( uint32 perso , uint256 eth , uint32 action, address _referrer_address ) public
604     onlyDirectTransaction
605     {
606   
607         require( maintenanceMode==false  && this_gRND>0 && (eth>=minimumSharePrice) && (eth <=100 ether) &&  perso<=3 && action <=5 && block.number <GameRoundData[ this_gRND ].blockNumberTimeout );
608   
609         address _customer_address = msg.sender;
610         
611         eth = HDXcontract.payWithToken( eth , _customer_address );
612        
613         require( eth>0 );
614          
615         CoreBuyShare( _customer_address , perso , eth , action , _referrer_address );
616         
617        
618     }
619     
620     function BuyShare(   uint32 perso , uint32 action , address _referrer_address ) public payable
621     onlyDirectTransaction
622     {
623      
624          
625         address _customer_address = msg.sender;
626         uint256 eth = msg.value;
627         
628         require( maintenanceMode==false  && this_gRND>0 && (eth>=minimumSharePrice) &&(eth <=100 ether) && perso<=3 && action <=5 && block.number <GameRoundData[ this_gRND ].blockNumberTimeout);
629    
630          
631         CoreBuyShare( _customer_address , perso , eth , action , _referrer_address);
632      
633     }
634     
635     /*================================
636     =       CORE BUY FUNCTIONS       =
637     ================================*/
638     
639     function CoreBuyShare( address _player_address , uint32 perso , uint256 eth , uint32 action ,  address _referrer_address ) private
640     {
641     
642         PlayerGameRound_s storage  _PlayerGameRound = PlayerGameRound[ _player_address][ this_gRND];
643         
644         GameRoundData_s storage  _GameRoundData = GameRoundData[ this_gRND ];
645         
646       
647         if (PlayerData[ _player_address].gRND != this_gRND)
648         {
649            
650             if (PlayerData[_player_address].gRND !=0)
651             {
652                 uint256 _gains = get_PendingGains( _player_address , PlayerData[ _player_address].gRND , true );
653             
654                  PlayerData[ _player_address].chest = PlayerData[ _player_address].chest.add( _gains);
655             }
656           
657           
658             PlayerData[ _player_address ].gRND = this_gRND;
659            
660    
661         }
662         
663         //HDX20BuyFees
664         uint256 _tempo = (eth.mul(HDX20BuyFees)) / 100;
665         
666         _GameRoundData.shareEthBalance =  _GameRoundData.shareEthBalance.add( eth-_tempo );  //minus the hdx20 fees
667         
668         uint256 _nb_token =   HDXcontract.buyTokenFromGame.value( _tempo )( _player_address , _referrer_address);
669         
670          //keep track for result UI screen how many token bought in this game round
671         _PlayerGameRound.token += uint128(_nb_token);
672         
673         //increase the treasure shares
674         buyTreasureShares(_GameRoundData , (eth.mul(TREASUREBuyFees)) / 100 );
675    
676         //what is left for the player
677         eth = eth.mul( BUYPercentage) / 100;
678         
679         uint256 _nbshare =  (eth.mul( magnitude)) / _GameRoundData.sharePrice;
680         
681         _GameRoundData.shareSupply =  _GameRoundData.shareSupply.add( _nbshare );
682         _GameRoundData.sharePots[ perso ] =  _GameRoundData.sharePots[ perso ].add( _nbshare);
683         
684         _tempo =  _PlayerGameRound.shares[ perso ];
685         
686         if (_tempo==0)
687         {
688             _GameRoundData.extraData[ 2+perso ]++; 
689         }
690         
691         _PlayerGameRound.shares[ perso ] =  _tempo.add( _nbshare);
692    
693         //this will always raise the price after 1 share
694         if (_GameRoundData.shareSupply>magnitude)
695         {
696             _GameRoundData.sharePrice = (_GameRoundData.shareEthBalance.mul( magnitude)) / _GameRoundData.shareSupply;
697         }
698        
699        
700         _PlayerGameRound.treasure_payoutsTo = _PlayerGameRound.treasure_payoutsTo.add( uint128(_nbshare.mul(   _GameRoundData.treasurePerShare[ perso ]  ) / magnitude) );
701      
702         
703         uint32 actionValue = ApplyAction( perso , action , _nbshare , _player_address);
704         
705         _GameRoundData.actionValue[ action] = actionValue;
706         
707         emit onBuyShare( _player_address , this_gRND , perso , _nb_token , action, actionValue  );
708                          
709         
710     }
711     
712      struct GameVar_s
713     {
714         uint32[4]   perso_energy;
715         uint32[4]   perso_distance;
716         uint32[4]   powerUpShield;
717         uint32[4]   powerUpSpeed;
718         
719         uint32      event_type;
720         uint32      event_target;
721      
722         uint32      winner;
723         
724         uint256     this_gRND;
725         
726         uint256     treasureAmountFind;
727         
728         bytes32     seed;
729         
730         uint256     blockNumberTimeout;
731         
732         uint32      turnround;
733       
734     }
735     
736     function actionPowerUpShield( uint32 perso , GameVar_s gamevar) pure private
737     {
738         
739         gamevar.powerUpShield[ perso ] = 100;
740         
741     }
742     
743     function actionPowerUpSpeed( uint32 perso , GameVar_s gamevar) pure private
744     {
745         
746         gamevar.powerUpSpeed[ perso ] = 100;
747         
748     }
749     
750    
751     
752     function actionApple( uint32 perso , GameVar_s gamevar) pure private
753     {
754         
755         gamevar.event_type = 6;     //apple / banana etc...
756         
757         gamevar.event_target = 1<<(perso*3);
758         
759         gamevar.perso_energy[ perso ] += 20; 
760         
761         if (gamevar.perso_energy[ perso] > 150) gamevar.perso_energy[ perso ] = 150;
762         
763     }
764     
765     function actionBanana(  GameVar_s gamevar ) pure private
766     {
767         
768         gamevar.event_type = 6;     //apple / banana etc...
769         
770         uint32 result = 2;
771         
772         uint32 target = get_modulo_value(gamevar.seed,18, 4);
773         
774         if (gamevar.winner>0) target = gamevar.winner-1;
775     
776         
777         uint32 shield = uint32(gamevar.powerUpShield[ target ]);
778         
779         if (shield>20) result = 5; //jumping banana
780         else
781         {
782                     uint32 dd = 4 * (101 - shield);
783                                    
784                   
785                     
786                     if (gamevar.perso_distance[ target ]>=dd)  gamevar.perso_distance[ target ] -= dd;
787                     else  gamevar.perso_distance[ target ] = 0;
788                     
789         }
790         
791         gamevar.event_target = result<<(target*3);
792         
793        
794         
795     }
796     
797     function getTreasureProbabilityType( bytes32 seed ) private pure
798     returns( uint32 )
799     {
800            uint8[22] memory this_TreasureProbability =[
801     
802         1,1,1,1,1,1,1,1,1,1,1,1,    //12 chances to have 10%
803         2,2,2,2,2,2,                //6 chances to have 15%
804         3,3,3,                      //3 chances to have 20%
805         4                           //1 chance to have 25%
806        
807         ];       
808         
809         return( this_TreasureProbability[ get_modulo_value(seed,24, 22) ] );
810     }
811     
812    
813     
814     function distribute_treasure( uint32 type2 , uint32 target , GameVar_s gamevar) private
815     {
816         uint8[5] memory this_TreasureValue =[
817         
818         1,
819         10,
820         15,
821         20,
822         25
823       
824         ];  
825         
826        
827         uint256 _treasureSupply = GameRoundData[ gamevar.this_gRND].treasureSupply;
828         uint256 _sharePrice = GameRoundData[ gamevar.this_gRND].sharePrice;
829         uint256 _shareSupply = GameRoundData[ gamevar.this_gRND].shareSupply;
830        
831         //how many shares to sell
832         uint256  _amount = _treasureSupply.mul(this_TreasureValue[ type2 ] )  / 100;
833        
834         GameRoundData[ gamevar.this_gRND].treasureSupply = _treasureSupply.sub( _amount );
835         GameRoundData[ gamevar.this_gRND].shareSupply =  _shareSupply.sub( _amount );
836         
837         //in eth
838         _amount = _amount.mul( _sharePrice ) / magnitude;
839         
840         //price of shares should not change
841         GameRoundData[ gamevar.this_gRND].shareEthBalance =  GameRoundData[ gamevar.this_gRND].shareEthBalance.sub( _amount );
842         
843         gamevar.treasureAmountFind = _amount;
844        
845         GameRoundData[ gamevar.this_gRND].totalTreasureFound =   GameRoundData[ gamevar.this_gRND].totalTreasureFound.add( _amount );
846        
847         uint256 _shares = GameRoundData[ gamevar.this_gRND].sharePots[ target ];
848     
849         if (_shares>0)
850         {
851            
852             GameRoundData[ gamevar.this_gRND].treasurePerShare[ target ] =  GameRoundData[ gamevar.this_gRND].treasurePerShare[ target ].add( uint128(((_amount.mul(magnitude)) / _shares)));
853         }
854         
855     }
856     
857     function actionTreasure( uint32 perso, GameVar_s gamevar ) private
858     {
859         gamevar.event_target =  get_modulo_value(gamevar.seed,18,  14);
860         gamevar.event_type = getTreasureProbabilityType( gamevar.seed );
861                                                     
862         if (gamevar.event_target==perso)
863         {
864 
865                 distribute_treasure( gamevar.event_type , gamevar.event_target, gamevar);
866         }
867         
868        
869     }
870     
871     function apply_attack( uint32 perso, uint32 target , GameVar_s gamevar) pure private
872     {
873         for(uint i=0;i<4;i++)
874         {
875             uint32 damage = (1+(target % 3)) * 10;
876             
877             uint32 shield = uint32(  gamevar.powerUpShield[i] );
878             
879             if (damage<= shield || i==perso) damage = 0;
880             else damage -=  shield;
881             
882             if (damage<gamevar.perso_energy[i]) gamevar.perso_energy[i] -= damage;
883             else gamevar.perso_energy[i] = 1;   //minimum
884             
885             target >>= 2;
886             
887         }
888         
889     }
890     
891     
892     function actionAttack( uint32 perso , GameVar_s gamevar ) pure private
893     {
894             gamevar.event_type =  5; 
895             gamevar.event_target = get_modulo_value(gamevar.seed,24,256);     //8 bits 4x2
896             
897             apply_attack( perso , gamevar.event_target , gamevar);    
898     }
899     
900     function ApplyAction( uint32 perso ,  uint32 action , uint256 nbshare , address _player_address) private
901     returns( uint32)
902     {
903         uint32 actionValue = GameRoundData[ this_gRND].actionValue[ action ];
904         
905         //only the last one is activating within the same block
906         if (block.number<= GameRoundData[ this_gRND].actionBlockNumber[ action]) return( actionValue);
907         
908         GameVar_s memory gamevar;
909           
910         gamevar.turnround = GameRoundData[ this_gRND ].extraData[0];
911         
912         nbshare = nbshare.mul(100);
913         nbshare /= magnitude;
914       
915         nbshare += 10;
916         
917         if (nbshare>5000) nbshare = 5000;
918         
919         actionValue += uint32( nbshare );
920         
921     
922          uint16[6] memory actionPrice =[
923         
924         1000,   //apple
925         4000,   //powerup shield
926         5000,   //powerup speed 
927         2000,   //chest
928         1000,   //banana action
929         3000   //attack
930       
931         ];  
932         
933         if (actionValue<actionPrice[action] && gamevar.turnround>0)
934         {
935            
936             return( actionValue );
937         }
938         
939         if (actionValue>=actionPrice[action])
940         {
941             GameRoundData[ this_gRND].actionBlockNumber[ action] = block.number;
942              
943             actionValue = 0;
944         }
945         else action = 100; //this is the first action
946         
947         gamevar.turnround++;
948      
949         
950       
951         
952         gamevar.this_gRND = this_gRND;
953         gamevar.winner = GameRoundData[ gamevar.this_gRND].extraData[1];
954       
955         
956         uint i;
957             
958         for( i=0;i<4;i++)
959         {
960                 gamevar.perso_energy[i] = GameRoundData[ gamevar.this_gRND].persoData[i];
961                 gamevar.perso_distance[i] = GameRoundData[ gamevar.this_gRND].persoData[4+i];
962                 gamevar.powerUpSpeed[i] = GameRoundData[ gamevar.this_gRND].powerUpData[i] / 2;
963                 gamevar.powerUpShield[i] = GameRoundData[ gamevar.this_gRND].powerUpData[4+i] / 2;
964     
965         }
966         
967         
968         
969         //a little boost for the fist action maker 
970         if (gamevar.turnround==1) gamevar.perso_energy[ perso ] += 5;
971         
972         getSeed( gamevar);
973     
974       
975         if (action==0) actionApple( perso , gamevar );
976         if (action==1) actionPowerUpShield( perso , gamevar);
977         if (action==2) actionPowerUpSpeed( perso , gamevar );
978         if (action==3) actionTreasure( perso, gamevar);
979         if (action==4) actionBanana(  gamevar);
980         if (action==5) actionAttack( perso , gamevar);
981         
982         gamevar.event_type |= (perso<<16);
983 
984         uint32 CurrentWinnerXpos = 0; //gamevar.perso_distance[0]; //this.Racers[n].perso_distance;
985        
986         for( i=0; i<4;i++)
987         {
988       
989                 //tiredness
990                 gamevar.perso_energy[ i ] *= 95;
991                 gamevar.perso_energy[ i ] /= 100;
992                 
993                                            
994                 uint32 spd1 =  (gamevar.perso_energy[ i ]*10) + (gamevar.powerUpSpeed[ i ]*10); 
995                                        
996                 gamevar.perso_distance[ i ] = (  (gamevar.perso_distance[ i ]*95) + (spd1*100)  )/100; 
997                          
998                if (gamevar.perso_distance[i] > CurrentWinnerXpos)
999                {
1000                    CurrentWinnerXpos = gamevar.perso_distance[i];
1001                    gamevar.winner = uint8(i);
1002                }
1003                
1004                 GameRoundData[ gamevar.this_gRND].persoData[i] = gamevar.perso_energy[i];
1005                 GameRoundData[ gamevar.this_gRND].persoData[4+i] = gamevar.perso_distance[i];
1006                 GameRoundData[ gamevar.this_gRND].powerUpData[i] = gamevar.powerUpSpeed[i];
1007                 GameRoundData[ gamevar.this_gRND].powerUpData[4+i] = gamevar.powerUpShield[i];
1008         
1009         }
1010          
1011         GameRoundData[ gamevar.this_gRND ].extraData[0] = gamevar.turnround;
1012         
1013         GameRoundData[ gamevar.this_gRND].extraData[1] = 1+gamevar.winner;
1014         
1015         gamevar.blockNumberTimeout = block.number + ((24*60*60) / blockTimeAverage);
1016         
1017         GameRoundData[ gamevar.this_gRND].blockNumberTimeout = gamevar.blockNumberTimeout;
1018         
1019     
1020         
1021         emitRound( gamevar , _player_address);
1022         
1023         return( actionValue );
1024     }
1025   
1026     function emitRound(GameVar_s gamevar , address _player_address) private
1027     {
1028            emit onNewRound(
1029             gamevar.this_gRND,   
1030             gamevar.turnround,
1031             gamevar.event_type,
1032             gamevar.event_target,
1033             gamevar.perso_energy,
1034             gamevar.perso_distance,
1035             gamevar.powerUpSpeed,
1036             gamevar.powerUpShield,
1037             gamevar.blockNumberTimeout,
1038             gamevar.treasureAmountFind,
1039             _player_address
1040            
1041         );
1042         
1043     }
1044    
1045     
1046     function get_Gains(address _player_address) private view
1047     returns( uint256)
1048     {
1049        
1050         uint256 _gains = PlayerData[ _player_address ].chest.add( get_PendingGains( _player_address , PlayerData[ _player_address].gRND , true) );
1051         
1052         if (_gains > PlayerData[ _player_address].payoutsTo)
1053         {
1054             _gains -= PlayerData[ _player_address].payoutsTo;
1055         }
1056         else _gains = 0;
1057      
1058     
1059         return( _gains );
1060         
1061     }
1062     
1063     
1064     function WithdrawGains() public 
1065     isPlayer
1066     {
1067         address _customer_address = msg.sender;
1068         
1069         uint256 _gains = get_Gains( _customer_address );
1070         
1071         require( _gains>0);
1072         
1073         PlayerData[ _customer_address ].payoutsTo = PlayerData[ _customer_address ].payoutsTo.add( _gains );
1074         
1075       
1076         emit onWithdrawGains( _customer_address , _gains , now);
1077         
1078         _customer_address.transfer( _gains );
1079         
1080         
1081     }
1082     
1083     function getSeed(GameVar_s gamevar) private view
1084    
1085     {
1086             uint256 _seed =  uint256( blockhash( block.number-1) );
1087             _seed ^= uint256( blockhash( block.number-2) );
1088             _seed ^= uint256(block.coinbase) / now;
1089             _seed += gamevar.perso_distance[0];
1090             _seed += gamevar.perso_distance[1];
1091             _seed += gamevar.perso_distance[2];
1092             _seed += gamevar.perso_distance[3];
1093             
1094             _seed += gasleft();
1095             
1096             gamevar.seed = keccak256(abi.encodePacked( _seed));
1097         
1098             
1099     }
1100     
1101     function CloseEntry() public
1102     onlyOwner
1103     isNotMaintenance
1104     {
1105     
1106         GameRoundData_s storage  _GameRoundData = GameRoundData[ this_gRND ];
1107          
1108         process_Taxes( _GameRoundData);
1109           
1110         emit onCloseEntry( this_gRND );
1111       
1112     }
1113     
1114    
1115     
1116     
1117     function get_probability( bytes32 seed ,  uint32 bytepos , uint32 percentage) pure private
1118     returns( bool )
1119     {
1120        uint32 v = uint32(seed[bytepos]);
1121        
1122        if (v<= ((255*percentage)/100)) return( true );
1123        else return( false );
1124      
1125     }
1126     
1127     function get_modulo_value( bytes32 seed , uint32 bytepos, uint32 mod) pure private
1128     returns( uint32 )
1129     {
1130       
1131         return( ((uint32(seed[ bytepos])*256)+(uint32(seed[ bytepos+1]))) % mod);
1132     }
1133     
1134   
1135     
1136   
1137   
1138     
1139      /*================================
1140     =  VIEW AND HELPERS FUNCTIONS    =
1141     ================================*/
1142   
1143     
1144     function view_get_Treasure() public
1145     view
1146     returns(uint256)
1147     {
1148       
1149       return( genTreasure);  
1150     }
1151  
1152     function view_get_gameData() public
1153     view
1154     returns( uint256 sharePrice, uint256[4] sharePots, uint256 shareSupply , uint256 shareEthBalance, uint128[4] treasurePerShare, uint32[4] totalPlayers , uint32[6] actionValue , uint256[4] shares , uint256 treasure_payoutsTo ,uint256 treasureSupply  )
1155     {
1156         address _player_address = msg.sender;
1157          
1158         sharePrice = GameRoundData[ this_gRND].sharePrice;
1159         sharePots = GameRoundData[ this_gRND].sharePots;
1160         shareSupply = GameRoundData[ this_gRND].shareSupply;
1161         shareEthBalance = GameRoundData[ this_gRND].shareEthBalance;
1162         treasurePerShare = GameRoundData[ this_gRND].treasurePerShare;
1163         
1164         treasureSupply = GameRoundData[ this_gRND].treasureSupply;
1165         
1166         uint32[4] memory totalPlayersm;
1167        
1168         totalPlayersm[0] = GameRoundData[ this_gRND].extraData[2];
1169         totalPlayersm[1] = GameRoundData[ this_gRND].extraData[3];
1170         totalPlayersm[2] = GameRoundData[ this_gRND].extraData[4];
1171         totalPlayersm[3] = GameRoundData[ this_gRND].extraData[5];
1172         
1173        
1174         totalPlayers = totalPlayersm;
1175         actionValue = GameRoundData[ this_gRND].actionValue;
1176         
1177         shares = PlayerGameRound[_player_address][this_gRND].shares;
1178         
1179         treasure_payoutsTo = PlayerGameRound[_player_address][this_gRND].treasure_payoutsTo;
1180     }
1181   
1182     
1183     function view_get_Gains()
1184     public
1185     view
1186     returns( uint256 gains)
1187     {
1188         
1189         address _player_address = msg.sender;
1190    
1191       
1192         uint256 _gains = PlayerData[ _player_address ].chest.add( get_PendingGains( _player_address , PlayerData[ _player_address].gRND, true) );
1193         
1194         if (_gains > PlayerData[ _player_address].payoutsTo)
1195         {
1196             _gains -= PlayerData[ _player_address].payoutsTo;
1197         }
1198         else _gains = 0;
1199      
1200     
1201         return( _gains );
1202         
1203     }
1204   
1205   
1206     
1207     function view_get_gameStates() public 
1208     view
1209     returns(uint8[4] types, uint256 grnd, uint32 turnround, uint256 minimumshare , uint256 blockNumber , uint256 blockNumberTimeout, uint32[6] actionValue , uint32[8] persoData , uint32[8] powerUpData , uint256 blockNumberCurrent , uint256 blockTimeAvg)
1210     {
1211         return( this_Perso_Type, this_gRND , GameRoundData[ this_gRND].extraData[0] , minimumSharePrice , GameRoundData[ this_gRND].blockNumber,GameRoundData[ this_gRND].blockNumberTimeout, GameRoundData[ this_gRND].actionValue , GameRoundData[ this_gRND].persoData , GameRoundData[ this_gRND].powerUpData, block.number , blockTimeAverage /*, view_get_MyRacer()*/);
1212     }
1213     
1214     function view_get_ResultData() public
1215     view
1216     returns(uint32 TotalPlayer, uint256 TotalPayout ,uint256 MyTokenValue, uint256 MyToken, uint256 MyGains , uint256 MyTreasureFound )
1217     {
1218         address _player_address = msg.sender;
1219         
1220         GameRoundData_s storage  _GameRoundData = GameRoundData[ this_gRND ];
1221         
1222         TotalPlayer = _GameRoundData.extraData[2]+_GameRoundData.extraData[3]+_GameRoundData.extraData[4]+_GameRoundData.extraData[5];
1223      
1224         TotalPayout = get_TotalPayout( _GameRoundData );
1225       
1226         MyToken =  PlayerGameRound[ _player_address][ this_gRND].token;
1227           
1228         MyTokenValue = MyToken * HDXcontract.sellingPrice( true );
1229         MyTokenValue /= magnitude;
1230       
1231         MyGains = 0;
1232         MyTreasureFound = 0;
1233         
1234         if (PlayerData[ _player_address].gRND == this_gRND)
1235         {
1236        
1237            MyGains =  get_PendingGains( _player_address , this_gRND,false); //we need false because the race is not yet closed at that moment
1238         
1239            
1240            for(uint i=0;i<4;i++)
1241            {
1242              MyTreasureFound += PlayerGameRound[_player_address][ this_gRND].shares[ i ].mul( _GameRoundData.treasurePerShare[ i ] ) / magnitude;
1243            }
1244        
1245        
1246             if (MyTreasureFound >=  PlayerGameRound[_player_address][this_gRND].treasure_payoutsTo) MyTreasureFound = MyTreasureFound.sub(  PlayerGameRound[_player_address][this_gRND].treasure_payoutsTo );
1247             else MyTreasureFound = 0;
1248               
1249            
1250             
1251         }
1252         
1253         
1254     }    
1255  
1256  
1257     function totalEthereumBalance()
1258     public
1259     view
1260     returns(uint256)
1261     {
1262         return address(this).balance;
1263     }
1264     
1265     function view_get_maintenanceMode()
1266     public
1267     view
1268     returns(bool)
1269     {
1270         return( maintenanceMode);
1271     }
1272     
1273     function view_get_blockNumbers()
1274     public
1275     view
1276     returns( uint256 b1 , uint256 b2 )
1277     {
1278         return( block.number , GameRoundData[ this_gRND ].blockNumberTimeout);
1279         
1280     }
1281     
1282    
1283 }
1284 
1285 
1286 library SafeMath {
1287     
1288    
1289     function mul(uint256 a, uint256 b) 
1290         internal 
1291         pure 
1292         returns (uint256 c) 
1293     {
1294         if (a == 0) {
1295             return 0;
1296         }
1297         c = a * b;
1298         require(c / a == b);
1299         return c;
1300     }
1301 
1302    
1303     function sub(uint256 a, uint256 b)
1304         internal
1305         pure
1306         returns (uint256) 
1307     {
1308         require(b <= a);
1309         return a - b;
1310     }
1311 
1312    
1313     function add(uint256 a, uint256 b)
1314         internal
1315         pure
1316         returns (uint256 c) 
1317     {
1318         c = a + b;
1319         require(c >= a);
1320         return c;
1321     }
1322     
1323    
1324     
1325   
1326     
1327    
1328 }
1329 
1330 
1331 library SafeMath128 {
1332     
1333    
1334     function mul(uint128 a, uint128 b) 
1335         internal 
1336         pure 
1337         returns (uint128 c) 
1338     {
1339         if (a == 0) {
1340             return 0;
1341         }
1342         c = a * b;
1343         require(c / a == b);
1344         return c;
1345     }
1346 
1347    
1348     function sub(uint128 a, uint128 b)
1349         internal
1350         pure
1351         returns (uint128) 
1352     {
1353         require(b <= a);
1354         return a - b;
1355     }
1356 
1357    
1358     function add(uint128 a, uint128 b)
1359         internal
1360         pure
1361         returns (uint128 c) 
1362     {
1363         c = a + b;
1364         require(c >= a);
1365         return c;
1366     }
1367     
1368    
1369     
1370   
1371     
1372    
1373 }