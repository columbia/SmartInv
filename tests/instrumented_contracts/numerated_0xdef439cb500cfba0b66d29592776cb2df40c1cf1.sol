1 /*
2 
3 Introducing "TORPEDO LAUNCH" our second HDX20 POWERED GAME running on the Ethereum Blockchain 
4 "TORPEDO LAUNCH" is playable @ https://torpedolaunch.io
5 
6 About the game :
7 
8 TORPEDO LAUNCH is a Submarine Arcade action game where the player is launching torpedoes to sink enemies boats 
9 
10 
11 How to play TORPEDO LAUNCH:
12 
13 The Campaign will start after at least 1 player has played and submitted a score to the worldwide leaderboard then,
14 for every new highscore registered, a 24H countdown will reset.
15 At the end of the countdown, the 8 best players ranked on the leaderboard will share the Treasure proportionally to their scores
16 and everybody will receive their payout.
17 Every time you buy new torpedoes, 5% of the price will buy you HDX20 Token earning you Ethereum from the volume
18 of any HDX20 POWERED GAMES (visit https://hdx20.io for details) while 20% of the price will buy you new shares of the game.
19 Please remember, at every new buy, the price of the share is increasing a little and so will be your payout even if you are not
20 a winner therefore buying shares at the beginning of the campaign is highly advised.
21 You can withdraw any owned amount at all time during the game.
22 
23 Play for the big WIN, Play for the TREASURE, Play for staking HDX20 TOKEN or Play for all at once...Your Choice!
24 
25 We wish you Good Luck!
26 
27 PAYOUTS DISTRIBUTION:
28 .60% to the winners of the race distributed proportionally to their score if ranked from 1st to 8th.
29 .25% to the community of HDX20 gamers/holders distributed as price appreciation.
30 .5% to developer for running, developing and expanding the platform.
31 .10% for provisioning the TREASURE for the next Campaign.
32 
33 
34 
35 
36 This product is copyrighted. Any unauthorized copy, modification, or use without express written consent from HyperDevbox is prohibited.
37 
38 Copyright 2018 HyperDevbox
39 
40 */
41 
42 pragma solidity ^0.4.25;
43 
44 
45 interface HDX20Interface
46 {
47     function() payable external;
48     
49     
50     function buyTokenFromGame( address _customerAddress , address _referrer_address ) payable external returns(uint256);
51   
52     function payWithToken( uint256 _eth , address _player_address ) external returns(uint256);
53   
54     function appreciateTokenPrice() payable external;
55    
56     function totalSupply() external view returns(uint256); 
57     
58     function ethBalanceOf(address _customerAddress) external view returns(uint256);
59   
60     function balanceOf(address _playerAddress) external view returns(uint256);
61     
62     function sellingPrice( bool includeFees) external view returns(uint256);
63   
64 }
65 
66 
67 contract TorpedoLaunchGame
68 {
69      HDX20Interface private HDXcontract = HDX20Interface(0x8942a5995bd168f347f7ec58f25a54a9a064f882);
70      
71      using SafeMath for uint256;
72      using SafeMath128 for uint128;
73      
74      /*==============================
75     =            EVENTS            =
76     ==============================*/
77     event OwnershipTransferred(
78         
79          address previousOwner,
80          address nextOwner,
81           uint256 timeStamp
82          );
83          
84     event HDXcontractChanged(
85         
86          address previous,
87          address next,
88          uint256 timeStamp
89          );
90  
91    
92     
93      event onWithdrawGains(
94         address customerAddress,
95         uint256 ethereumWithdrawn,
96         uint256 timeStamp
97     );
98     
99     event onNewScore(
100         uint256       gRND,
101         uint256       blockNumberTimeout,
102         uint256       score,
103         address       customerAddress,
104         bool          newHighScore,
105         bool          highscoreChanged    
106         
107     );
108     
109     
110     event onNewCampaign(
111         
112         uint256 gRND,
113         uint256  blockNumber
114         
115         );
116         
117     event onBuyTorpedo(
118         address     customerAddress,
119         uint256     gRND,
120         uint256     torpedoBatchID,
121         uint256     torpedoBatchBlockTimeout,  
122         uint256     nbToken,
123         uint32      torpedoBatchMultiplier  //x1, x10, x100
124         );    
125         
126         
127      event onMaintenance(
128         bool        mode,
129         uint256     timeStamp
130 
131         );    
132         
133  
134         
135     event onCloseEntry(
136         
137          uint256 gRND
138          
139         );    
140         
141     event onChangeBlockTimeAverage(
142         
143          uint256 blocktimeavg
144          
145         );    
146         
147     event onChangeMinimumPrice(
148         
149          uint256 minimum,
150          uint256 timeStamp
151          );
152          
153     event onNewName(
154         
155          address     customerAddress,
156          bytes32     name,
157          uint256     timeStamp
158          );
159         
160     /*==============================
161     =            MODIFIERS         =
162     ==============================*/
163     modifier onlyOwner
164     {
165         require (msg.sender == owner );
166         _;
167     }
168     
169     modifier onlyFromHDXToken
170     {
171         require (msg.sender == address( HDXcontract ));
172         _;
173     }
174    
175      modifier onlyDirectTransaction
176     {
177         require (msg.sender == tx.origin);
178         _;
179     }
180    
181    
182      modifier isPlayer
183     {
184         require (PlayerData[ msg.sender].gRND !=0);
185         _;
186     }
187     
188     modifier isMaintenance
189     {
190         require (maintenanceMode==true);
191         _;
192     }
193     
194      modifier isNotMaintenance
195     {
196         require (maintenanceMode==false);
197         _;
198     }
199    
200   
201     address public owner;
202   
203   
204     address public signerAuthority = 0xf77444cE64f3F46ba6b63F6b9411dF9c589E3319;
205    
206     
207     
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
231     function changeSigner(address _nextSigner) public
232     onlyOwner
233     {
234         require (_nextSigner != signerAuthority);
235         require(_nextSigner != address(0));
236       
237         signerAuthority = _nextSigner;
238     }
239     
240     function changeHDXcontract(address _next) public
241     onlyOwner
242     {
243         require (_next != address( HDXcontract ));
244         require( _next != address(0));
245          
246         emit HDXcontractChanged(address(HDXcontract), _next , now);
247          
248         HDXcontract  = HDX20Interface( _next);
249     }
250   
251   
252     
253     function changeBlockTimeAverage( uint256 blocktimeavg) public
254     onlyOwner
255     {
256         require ( blocktimeavg>0 );
257         
258        
259         blockTimeAverage = blocktimeavg;
260         
261         emit onChangeBlockTimeAverage( blockTimeAverage );
262          
263     }
264     
265     function enableMaintenance() public
266     onlyOwner
267     {
268         maintenanceMode = true;
269         
270         emit onMaintenance( maintenanceMode , now);
271         
272     }
273 
274     function disableMaintenance() public
275     onlyOwner
276     {
277       
278         maintenanceMode = false;
279         
280         emit onMaintenance( maintenanceMode , now);
281         
282       
283         initCampaign();
284     }
285     
286   
287     function changeMinimumPrice( uint256 newmini) public
288     onlyOwner
289     {
290       
291       if (newmini>0)
292       {
293           minimumSharePrice = newmini;
294       }
295        
296       emit onChangeMinimumPrice( newmini , now ); 
297     }
298     
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
311        
312     }
313     
314     struct PlayerGameRound_s
315     {
316         uint256         shares;
317        
318         uint256         torpedoBatchID;         //0==no torpedo, otherwise 
319         uint256         torpedoBatchBlockTimeout;    
320         
321         bytes           data;
322         
323         uint128         token;
324         uint32[3]       packedData;         //[0] = torpedomultiplier
325                                             //[1] = playerID
326                                             //[2]=score
327     }
328     
329     struct GameRoundData_s
330     {
331        uint256              blockNumber;
332        uint256              blockNumberTimeout;
333        uint256              sharePrice;
334        uint256              sharePots;
335        uint256              shareEthBalance;
336        uint256              shareSupply;
337        uint256              treasureSupply;
338        
339        mapping (uint32 => address)   IDtoAddress;
340      
341       
342      
343        uint256              hdx20AppreciationPayout;
344        uint256              devAppreciationPayout;
345        //********************************************************************************************
346        uint32[16]           highscorePool;     //[0-7]  == uint32 score
347                                                //[8-15] == uint32 playerID    
348     
349        uint32[2]            extraData;//[0]==this_TurnRound , [1]== totalPlayers
350   
351     }
352     
353   
354    
355     mapping (address => PlayerData_s)   private PlayerData;
356     
357    
358     mapping (address => mapping (uint256 => PlayerGameRound_s)) private PlayerGameRound;
359     
360    
361     mapping (uint256 => GameRoundData_s)   private GameRoundData;
362     
363     mapping( address => bytes32) private registeredNames;
364     
365     
366    
367     bool        private maintenanceMode=false;     
368    
369     uint256     private this_gRND =0;
370  
371   
372     //85 , missing 15% for shares appreciation eg:share price increase
373     uint8 constant private HDX20BuyFees = 5;
374     uint8 constant private TREASUREBuyFees = 60;
375     uint8 constant private BUYPercentage = 20;
376     
377    
378     uint8 constant private DevFees = 5;
379     uint8 constant private TreasureFees = 10;
380     uint8 constant private AppreciationFees = 25;
381   
382    
383     uint256 constant internal magnitude = 1e18;
384   
385     uint256 private genTreasure = 0;
386    
387     uint256 private minimumSharePrice = 0.01 ether;
388     
389     uint256 private blockTimeAverage = 15;  //seconds per block                          
390     
391  
392       
393     /*================================
394     =       PUBLIC FUNCTIONS         =
395     ================================*/
396     
397     //fallback will be called only from the HDX token contract to fund the game from customers's HDX20
398     
399      function()
400      payable
401      public
402      onlyFromHDXToken 
403     {
404        
405       
406       
407           
408     }
409     
410     
411     function ChargeTreasure() public payable
412     {
413         genTreasure = SafeMath.add( genTreasure , msg.value);     
414     }
415     
416     
417     function buyTreasureShares(GameRoundData_s storage  _GameRoundData , uint256 _eth ) private
418     returns( uint256)
419     {
420         uint256 _nbshares = (_eth.mul( magnitude)) / _GameRoundData.sharePrice;
421        
422         _GameRoundData.treasureSupply = _GameRoundData.treasureSupply.add( _nbshares );
423         
424         _GameRoundData.shareSupply =   _GameRoundData.shareSupply.add( _nbshares );
425         
426         return( _nbshares);
427     }
428    
429     
430     function initCampaign() public
431     onlyOwner
432     isNotMaintenance
433     {
434  
435         
436         this_gRND++;
437         
438         GameRoundData_s storage _GameRoundData = GameRoundData[ this_gRND ];
439       
440        
441         _GameRoundData.blockNumber = block.number;
442         
443         _GameRoundData.blockNumberTimeout = block.number + (360*10*24*3600); 
444         
445         uint256 _sharePrice = minimumSharePrice;
446         
447         _GameRoundData.sharePrice = _sharePrice;
448         
449         uint256 _nbshares = buyTreasureShares(_GameRoundData, genTreasure );
450      
451         //convert into ETH
452         _nbshares = _nbshares.mul( _sharePrice ) / magnitude;
453         
454         //start balance   
455         _GameRoundData.shareEthBalance = _nbshares;
456         
457         genTreasure = genTreasure.sub( _nbshares);
458      
459        
460         emit onNewCampaign( this_gRND , block.number);
461         
462     }
463     
464     
465    
466     function get_TotalPayout(  GameRoundData_s storage  _GameRoundData ) private view
467     returns( uint256)
468     {
469       
470        uint256 _payout = 0;
471         
472        uint256 _sharePrice = _GameRoundData.sharePrice;
473      
474        uint256 _bet = _GameRoundData.sharePots;
475            
476        _payout = _payout.add( _bet.mul (_sharePrice) / magnitude );
477                   
478          
479        uint256 _potValue = ((_GameRoundData.treasureSupply.mul( _sharePrice ) / magnitude).mul(100-DevFees-TreasureFees-AppreciationFees)) / 100;
480        
481        _payout = _payout.add( _potValue );
482        
483    
484        return( _payout );
485         
486     }
487     
488     
489   
490     function get_PendingGains( address _player_address , uint256 _gRND) private view
491     returns( uint256)
492     {
493        
494         //did not play 
495         if (PlayerData[ _player_address].gRND != _gRND || _gRND==0) return( 0 );
496        
497         GameRoundData_s storage  _GameRoundData = GameRoundData[ _gRND ];
498        
499        // uint32 _winner = _GameRoundData.extraData[1];
500        
501         uint256 _gains = 0;
502        
503         uint256 _sharePrice = _GameRoundData.sharePrice;
504         uint256 _shares;
505        
506         PlayerGameRound_s storage  _PlayerGameRound = PlayerGameRound[ _player_address][_gRND];
507        
508         _shares = _PlayerGameRound.shares;
509             
510         _gains = _gains.add( _shares.mul( _sharePrice) / magnitude );
511         
512         
513         //if the race payment is made (race is over) then we add also the winner prize
514         if (_GameRoundData.extraData[0] >= (1<<30))
515         {
516             uint256 _score = 0;
517             uint256 _totalscore = 0;       
518             
519             uint256  _treasure = ((_GameRoundData.treasureSupply.mul( _sharePrice ) / magnitude).mul(100-DevFees-TreasureFees-AppreciationFees)) / 100;
520        
521             for( uint i=0;i<8;i++)
522             {
523                 _totalscore = _totalscore.add( uint256(_GameRoundData.highscorePool[i]));
524                 
525                 if (_GameRoundData.highscorePool[8+i]==_PlayerGameRound.packedData[1])
526                 {
527                     _score =  uint256(_GameRoundData.highscorePool[i]);
528                 }
529                 
530             }
531           
532             if (_totalscore>0) _gains = _gains.add( _treasure.mul( _score) / _totalscore );
533            
534         }
535        
536      
537        
538         return( _gains );
539         
540     }
541     
542     
543     //only for the Result Data Screen on the game not used for the payout
544     
545     function get_PendingGainsAll( address _player_address , uint256 _gRND) private view
546     returns( uint256)
547     {
548        
549         //did not play 
550         if (PlayerData[ _player_address].gRND != _gRND || _gRND==0) return( 0 );
551        
552         GameRoundData_s storage  _GameRoundData = GameRoundData[ _gRND ];
553        
554      
555         // uint32 _winner = _GameRoundData.extraData[1];
556        
557         uint256 _gains = 0;
558      
559         uint256 _sharePrice = _GameRoundData.sharePrice;
560         uint256 _shares;
561        
562         PlayerGameRound_s storage  _PlayerGameRound = PlayerGameRound[ _player_address][_gRND];
563        
564         _shares = _PlayerGameRound.shares;
565             
566         _gains = _gains.add( _shares.mul( _sharePrice) / magnitude );
567         
568        
569         {
570             uint256 _score = 0;
571             uint256 _totalscore = 0;       
572             
573             uint256  _treasure = ((_GameRoundData.treasureSupply.mul( _sharePrice ) / magnitude).mul(100-DevFees-TreasureFees-AppreciationFees)) / 100;
574        
575             for( uint i=0;i<8;i++)
576             {
577                 _totalscore = _totalscore.add( uint256(_GameRoundData.highscorePool[i]));
578                 
579                 if (_GameRoundData.highscorePool[8+i]==_PlayerGameRound.packedData[1])
580                 {
581                     _score =  uint256(_GameRoundData.highscorePool[i]);
582                 }
583                 
584             }
585           
586             if (_totalscore>0)    _gains = _gains.add( _treasure.mul( _score) / _totalscore );
587            
588         }
589         
590         return( _gains );
591         
592     }
593     
594     //process streaming HDX20 appreciation and dev fees appreciation
595     function process_sub_Taxes(  GameRoundData_s storage _GameRoundData , uint256 minimum) private
596     {
597         uint256 _sharePrice = _GameRoundData.sharePrice;
598              
599         uint256 _potValue = _GameRoundData.treasureSupply.mul( _sharePrice ) / magnitude;
600             
601         uint256 _appreciation = SafeMath.mul( _potValue , AppreciationFees) / 100; 
602           
603         uint256 _dev = SafeMath.mul( _potValue , DevFees) / 100;   
604         
605         if (_dev > _GameRoundData.devAppreciationPayout)
606         {
607             _dev -= _GameRoundData.devAppreciationPayout;
608             
609             if (_dev>minimum)
610             {
611               _GameRoundData.devAppreciationPayout = _GameRoundData.devAppreciationPayout.add( _dev );
612               
613                HDXcontract.buyTokenFromGame.value( _dev )( owner , address(0));
614               
615             }
616         }
617         
618         if (_appreciation> _GameRoundData.hdx20AppreciationPayout)
619         {
620             _appreciation -= _GameRoundData.hdx20AppreciationPayout;
621             
622             if (_appreciation>minimum)
623             {
624                 _GameRoundData.hdx20AppreciationPayout = _GameRoundData.hdx20AppreciationPayout.add( _appreciation );
625                 
626                  HDXcontract.appreciateTokenPrice.value( _appreciation )();
627                 
628             }
629         }
630         
631     }
632     
633     //process the fees, hdx20 appreciation, calcul results at the end of the race
634     function process_Taxes(  GameRoundData_s storage _GameRoundData ) private
635     {
636         uint32 turnround = _GameRoundData.extraData[0];
637         
638         if (turnround>0 && turnround<(1<<30))
639         {  
640             _GameRoundData.extraData[0] = turnround | (1<<30);
641             
642             uint256 _sharePrice = _GameRoundData.sharePrice;
643              
644             uint256 _potValue = _GameRoundData.treasureSupply.mul( _sharePrice ) / magnitude;
645      
646            
647             uint256 _treasure = SafeMath.mul( _potValue , TreasureFees) / 100; 
648          
649            
650             genTreasure = genTreasure.add( _treasure );
651             
652             //take care of any left over
653             process_sub_Taxes( _GameRoundData , 0);
654             
655           
656             
657         }
658      
659     }
660     
661     function ValidTorpedoScore( int256 score, uint256 torpedoBatchID , bytes32 r , bytes32 s , uint8 v) public
662     onlyDirectTransaction
663     {
664         address _customer_address = msg.sender;
665          
666         require( maintenanceMode==false  && this_gRND>0 && (block.number <GameRoundData[ this_gRND ].blockNumberTimeout) && (PlayerData[ _customer_address].gRND == this_gRND));
667   
668         GameVar_s memory gamevar;
669         gamevar.score = score;
670         gamevar.torpedoBatchID = torpedoBatchID;
671         gamevar.r = r;
672         gamevar.s = s;
673         gamevar.v = v;
674    
675         coreValidTorpedoScore( _customer_address , gamevar  );
676     }
677     
678     
679     struct GameVar_s
680     {
681      
682         bool madehigh;
683         bool highscoreChanged;
684       
685         uint    max_score;
686         uint    min_score;
687         uint    min_score_index;
688         uint    max_score_index;
689         uint    our_score_index;
690         uint32  max_score_pid;
691         uint32  multiplier;
692         
693         uint256  torpedoBatchID;
694         int256   score;
695         bytes32  r;
696         bytes32  s;
697         uint8    v;
698     }
699     
700   
701     
702     function coreValidTorpedoScore( address _player_address , GameVar_s gamevar) private
703     {
704     
705         PlayerGameRound_s storage  _PlayerGameRound = PlayerGameRound[ _player_address][ this_gRND];
706         
707         GameRoundData_s storage  _GameRoundData = GameRoundData[ this_gRND ];
708         
709         require((gamevar.torpedoBatchID != 0) && (gamevar.torpedoBatchID== _PlayerGameRound.torpedoBatchID));
710        
711          
712         gamevar.madehigh = false;
713         gamevar.highscoreChanged = false;
714        
715       //  gamevar.max_score = 0;
716         gamevar.min_score = 0xffffffff;
717     //    gamevar.min_score_index = 0;
718      //   gamevar.max_score_index = 0;
719       //  gamevar.our_score_index = 0;
720       
721         
722        
723         if (block.number>=_PlayerGameRound.torpedoBatchBlockTimeout || (ecrecover(keccak256(abi.encodePacked( gamevar.score,gamevar.torpedoBatchID )) , gamevar.v, gamevar.r, gamevar.s) != signerAuthority))
724         {
725             gamevar.score = 0;
726         }
727         
728         
729        
730         
731         int256 tempo = int256(_PlayerGameRound.packedData[2]) + (gamevar.score * int256(_PlayerGameRound.packedData[0]));
732         if (tempo<0) tempo = 0;
733         if (tempo>0xffffffff) tempo = 0xffffffff;
734         
735         uint256 p_score = uint256( tempo );
736         
737         //store the player score
738         _PlayerGameRound.packedData[2] = uint32(p_score);
739         
740        
741         for(uint i=0;i<8;i++)
742         {
743             uint ss = _GameRoundData.highscorePool[i];
744             if (ss>gamevar.max_score)
745             {
746                 gamevar.max_score = ss;
747                 gamevar.max_score_index =i; 
748             }
749             if (ss<gamevar.min_score)
750             {
751                 gamevar.min_score = ss;
752                 gamevar.min_score_index = i;
753             }
754             
755             //are we in the pool already
756             if (_GameRoundData.highscorePool[8+i]==_PlayerGameRound.packedData[1]) gamevar.our_score_index=1+i;
757         }
758         
759         
760         //grab current player id highscore before we potentially overwrite it
761         gamevar.max_score_pid = _GameRoundData.highscorePool[ 8+gamevar.max_score_index];
762         
763         //at first if we are in the pool simply update our score
764         
765         if (gamevar.our_score_index>0)
766         {
767            _GameRoundData.highscorePool[ gamevar.our_score_index -1] = uint32(p_score); 
768            
769            gamevar.highscoreChanged = true;
770           
771         }
772         else
773         {
774             //we were not in the pool, are we more than the minimum score
775             
776             if (p_score > gamevar.min_score)
777             {
778                 //yes the minimum should go away and we should replace it in the pool
779                 _GameRoundData.highscorePool[ gamevar.min_score_index ] =uint32(p_score);
780                 _GameRoundData.highscorePool[ 8+gamevar.min_score_index] = _PlayerGameRound.packedData[1]; //put our playerID
781                 
782                 gamevar.highscoreChanged = true;
783    
784             }
785             
786         }
787         
788         //new highscore ?
789         if (p_score>gamevar.max_score)
790         {
791             //yes
792            
793             //same person 
794             
795              if (  gamevar.max_score_pid != _PlayerGameRound.packedData[1] )
796              {
797                  //no so reset the counter
798                   _GameRoundData.blockNumberTimeout = block.number + ((24*60*60) / blockTimeAverage);
799                   _GameRoundData.extraData[0]++; // new turn
800                    gamevar.madehigh = true;
801              }
802             
803         }
804    
805         //ok reset it so we can get a new one
806         _PlayerGameRound.torpedoBatchID = 0;
807         
808         emit onNewScore( this_gRND , _GameRoundData.blockNumberTimeout , p_score , _player_address , gamevar.madehigh , gamevar.highscoreChanged );
809 
810 
811     }
812     
813     
814     function BuyTorpedoWithDividends( uint256 eth , int256 score, uint256 torpedoBatchID,  address _referrer_address , bytes32 r , bytes32 s , uint8 v) public
815     onlyDirectTransaction
816     {
817         
818         require( maintenanceMode==false  && this_gRND>0 && (eth==minimumSharePrice || eth==minimumSharePrice*10 || eth==minimumSharePrice*100) && (block.number <GameRoundData[ this_gRND ].blockNumberTimeout) );
819   
820         address _customer_address = msg.sender;
821         
822         GameVar_s memory gamevar;
823         gamevar.score = score;
824         gamevar.torpedoBatchID = torpedoBatchID;
825         gamevar.r = r;
826         gamevar.s = s;
827         gamevar.v = v;
828         
829        
830         gamevar.multiplier =uint32( eth / minimumSharePrice);
831         
832         eth = HDXcontract.payWithToken( eth , _customer_address );
833        
834         require( eth>0 );
835         
836          
837         CoreBuyTorpedo( _customer_address , eth , _referrer_address , gamevar );
838         
839        
840     }
841     
842     function BuyName( bytes32 name ) public payable
843     {
844         address _customer_address = msg.sender;
845         uint256 eth = msg.value; 
846         
847         require( maintenanceMode==false  && (eth==minimumSharePrice*10));
848         
849         //50% for the community
850         //50% for the developer account
851         
852         eth /= 2;
853         
854         HDXcontract.buyTokenFromGame.value( eth )( owner , address(0));
855        
856         HDXcontract.appreciateTokenPrice.value( eth )();
857         
858         registeredNames[ _customer_address ] = name;
859         
860         emit onNewName( _customer_address , name , now );
861     }
862     
863     function BuyTorpedo( int256 score, uint256 torpedoBatchID, address _referrer_address , bytes32 r , bytes32 s , uint8 v ) public payable
864     onlyDirectTransaction
865     {
866      
867         address _customer_address = msg.sender;
868         uint256 eth = msg.value;
869         
870         require( maintenanceMode==false  && this_gRND>0 && (eth==minimumSharePrice || eth==minimumSharePrice*10 || eth==minimumSharePrice*100) && (block.number <GameRoundData[ this_gRND ].blockNumberTimeout));
871    
872         GameVar_s memory gamevar;
873         gamevar.score = score;
874         gamevar.torpedoBatchID = torpedoBatchID;
875         gamevar.r = r;
876         gamevar.s = s;
877         gamevar.v = v;
878         
879        
880         gamevar.multiplier =uint32( eth / minimumSharePrice);
881    
882         CoreBuyTorpedo( _customer_address , eth , _referrer_address, gamevar);
883      
884     }
885     
886     /*================================
887     =       CORE BUY FUNCTIONS       =
888     ================================*/
889     
890     function CoreBuyTorpedo( address _player_address , uint256 eth ,  address _referrer_address , GameVar_s gamevar) private
891     {
892     
893         PlayerGameRound_s storage  _PlayerGameRound = PlayerGameRound[ _player_address][ this_gRND];
894         
895         GameRoundData_s storage  _GameRoundData = GameRoundData[ this_gRND ];
896         
897       
898         if (PlayerData[ _player_address].gRND != this_gRND)
899         {
900            
901             if (PlayerData[_player_address].gRND !=0)
902             {
903                 uint256 _gains = get_PendingGains( _player_address , PlayerData[ _player_address].gRND  );
904             
905                  PlayerData[ _player_address].chest = PlayerData[ _player_address].chest.add( _gains);
906             }
907           
908           
909             PlayerData[ _player_address ].gRND = this_gRND;
910            
911              //player++
912              _GameRoundData.extraData[ 1 ]++; 
913              
914              //a crude playerID
915              _PlayerGameRound.packedData[1] = _GameRoundData.extraData[ 1 ];
916              
917              //only to display the highscore table on the client
918              _GameRoundData.IDtoAddress[  _GameRoundData.extraData[1] ] = _player_address;
919         }
920         
921         //we need to validate the score before buying a torpedo batch
922         if (gamevar.torpedoBatchID !=0 || _PlayerGameRound.torpedoBatchID !=0)
923         {
924              coreValidTorpedoScore( _player_address , gamevar);
925         }
926         
927         
928        
929         
930         _PlayerGameRound.packedData[0] = gamevar.multiplier;
931         _PlayerGameRound.torpedoBatchBlockTimeout = block.number + ((4*3600) / blockTimeAverage);
932         _PlayerGameRound.torpedoBatchID = uint256((keccak256(abi.encodePacked( block.number, _player_address , address(this)))));
933         
934         
935         //HDX20BuyFees
936         uint256 _tempo = (eth.mul(HDX20BuyFees)) / 100;
937         
938         _GameRoundData.shareEthBalance =  _GameRoundData.shareEthBalance.add( eth-_tempo );  //minus the hdx20 fees
939         
940         uint256 _nb_token =   HDXcontract.buyTokenFromGame.value( _tempo )( _player_address , _referrer_address);
941         
942       
943         _PlayerGameRound.token += uint128(_nb_token);
944         
945        
946         buyTreasureShares(_GameRoundData , (eth.mul(TREASUREBuyFees)) / 100 );
947    
948         
949         eth = eth.mul( BUYPercentage) / 100;
950         
951         uint256 _nbshare =  (eth.mul( magnitude)) / _GameRoundData.sharePrice;
952         
953         _GameRoundData.shareSupply =  _GameRoundData.shareSupply.add( _nbshare );
954         _GameRoundData.sharePots   =  _GameRoundData.sharePots.add( _nbshare);
955       
956         _PlayerGameRound.shares =  _PlayerGameRound.shares.add( _nbshare);
957    
958       
959         if (_GameRoundData.shareSupply>magnitude)
960         {
961             _GameRoundData.sharePrice = (_GameRoundData.shareEthBalance.mul( magnitude)) / _GameRoundData.shareSupply;
962         }
963        
964         //HDX20 streaming appreciation
965         process_sub_Taxes( _GameRoundData , 0.1 ether);
966         
967         emit onBuyTorpedo( _player_address, this_gRND, _PlayerGameRound.torpedoBatchID , _PlayerGameRound.torpedoBatchBlockTimeout, _nb_token,  _PlayerGameRound.packedData[0]);
968       
969       
970         
971     }
972     
973    
974     
975     function get_Gains(address _player_address) private view
976     returns( uint256)
977     {
978        
979         uint256 _gains = PlayerData[ _player_address ].chest.add( get_PendingGains( _player_address , PlayerData[ _player_address].gRND ) );
980         
981         if (_gains > PlayerData[ _player_address].payoutsTo)
982         {
983             _gains -= PlayerData[ _player_address].payoutsTo;
984         }
985         else _gains = 0;
986      
987     
988         return( _gains );
989         
990     }
991     
992     
993     function WithdrawGains() public 
994     isPlayer
995     {
996         address _customer_address = msg.sender;
997         
998         uint256 _gains = get_Gains( _customer_address );
999         
1000         require( _gains>0);
1001         
1002         PlayerData[ _customer_address ].payoutsTo = PlayerData[ _customer_address ].payoutsTo.add( _gains );
1003         
1004       
1005         emit onWithdrawGains( _customer_address , _gains , now);
1006         
1007         _customer_address.transfer( _gains );
1008         
1009         
1010     }
1011     
1012    
1013     
1014     function CloseEntry() public
1015     onlyOwner
1016     isNotMaintenance
1017     {
1018     
1019         GameRoundData_s storage  _GameRoundData = GameRoundData[ this_gRND ];
1020          
1021         process_Taxes( _GameRoundData);
1022           
1023         emit onCloseEntry( this_gRND );
1024       
1025     }
1026     
1027    
1028   
1029   
1030     
1031      /*================================
1032     =  VIEW AND HELPERS FUNCTIONS    =
1033     ================================*/
1034   
1035     
1036     function view_get_Treasure() public
1037     view
1038     returns(uint256)
1039     {
1040       
1041       return( genTreasure);  
1042     }
1043  
1044     function view_get_gameData() public
1045     view
1046     returns( uint256 sharePrice, uint256 sharePots, uint256 shareSupply , uint256 shareEthBalance, uint32 totalPlayers , uint256 shares ,uint256 treasureSupply , uint256 torpedoBatchID , uint32 torpedoBatchMultiplier , uint256 torpedoBatchBlockTimeout , uint256 score   )
1047     {
1048         address _player_address = msg.sender;
1049          
1050         sharePrice = GameRoundData[ this_gRND].sharePrice;
1051         sharePots = GameRoundData[ this_gRND].sharePots;
1052         shareSupply = GameRoundData[ this_gRND].shareSupply;
1053         shareEthBalance = GameRoundData[ this_gRND].shareEthBalance;
1054         treasureSupply = GameRoundData[ this_gRND].treasureSupply;
1055       
1056         totalPlayers =  GameRoundData[ this_gRND].extraData[1];
1057       
1058         shares = PlayerGameRound[_player_address][this_gRND].shares;
1059       
1060         torpedoBatchID = PlayerGameRound[_player_address][this_gRND].torpedoBatchID;
1061         torpedoBatchMultiplier = PlayerGameRound[_player_address][this_gRND].packedData[0];
1062         torpedoBatchBlockTimeout = PlayerGameRound[_player_address][this_gRND].torpedoBatchBlockTimeout;
1063         score = PlayerGameRound[_player_address][this_gRND].packedData[2];
1064     }
1065   
1066     function view_get_gameTorpedoData() public
1067     view
1068     returns( uint256 torpedoBatchID , uint32 torpedoBatchMultiplier , uint256 torpedoBatchBlockTimeout  , uint256 score )
1069     {
1070         address _player_address = msg.sender;
1071          
1072      
1073       
1074         torpedoBatchID = PlayerGameRound[_player_address][this_gRND].torpedoBatchID;
1075         torpedoBatchMultiplier = PlayerGameRound[_player_address][this_gRND].packedData[0];
1076         torpedoBatchBlockTimeout = PlayerGameRound[_player_address][this_gRND].torpedoBatchBlockTimeout;
1077         
1078         score = PlayerGameRound[_player_address][this_gRND].packedData[2];
1079     }
1080     
1081     function view_get_gameHighScores() public
1082     view
1083     returns( uint32[8] highscores , address[8] addresses , bytes32[8] names )
1084     {
1085         address _player_address = msg.sender;
1086          
1087         uint32[8] memory highscoresm;
1088         address[8] memory addressesm;
1089         bytes32[8] memory namesm;
1090         
1091         for(uint i =0;i<8;i++)
1092         {
1093             highscoresm[i] = GameRoundData[ this_gRND].highscorePool[i];
1094             
1095             uint32 id = GameRoundData[ this_gRND].highscorePool[8+i];
1096             
1097             addressesm[i] = GameRoundData[ this_gRND ].IDtoAddress[ id ];
1098             
1099             namesm[i] = view_get_registeredNames( addressesm[i ]);
1100         }
1101      
1102      
1103      highscores = highscoresm;
1104      addresses = addressesm;
1105      names = namesm;
1106       
1107      
1108     }
1109     
1110     function view_get_Gains()
1111     public
1112     view
1113     returns( uint256 gains)
1114     {
1115         
1116         address _player_address = msg.sender;
1117    
1118       
1119         uint256 _gains = PlayerData[ _player_address ].chest.add( get_PendingGains( _player_address , PlayerData[ _player_address].gRND) );
1120         
1121         if (_gains > PlayerData[ _player_address].payoutsTo)
1122         {
1123             _gains -= PlayerData[ _player_address].payoutsTo;
1124         }
1125         else _gains = 0;
1126      
1127     
1128         return( _gains );
1129         
1130     }
1131   
1132   
1133     
1134     function view_get_gameStates() public 
1135     view
1136     returns(uint256 grnd, uint32 turnround, uint256 minimumshare , uint256 blockNumber , uint256 blockNumberTimeout, uint256 blockNumberCurrent , uint256 blockTimeAvg , uint32[8] highscores , address[8] addresses , bytes32[8] names , bytes32 myname)
1137     {
1138         uint32[8] memory highscoresm;
1139         address[8] memory addressesm;
1140         bytes32[8] memory namesm;
1141         
1142         for(uint i =0;i<8;i++)
1143         {
1144             highscoresm[i] = GameRoundData[ this_gRND].highscorePool[i];
1145             
1146             uint32 id = GameRoundData[ this_gRND].highscorePool[8+i];
1147             
1148             addressesm[i] = GameRoundData[ this_gRND ].IDtoAddress[ id ];
1149             
1150             namesm[i] = view_get_registeredNames( addressesm[i ]);
1151         }
1152         
1153         return( this_gRND , GameRoundData[ this_gRND].extraData[0] , minimumSharePrice , GameRoundData[ this_gRND].blockNumber,GameRoundData[ this_gRND].blockNumberTimeout, block.number , blockTimeAverage , highscoresm , addressesm , namesm , view_get_registeredNames(msg.sender));
1154     }
1155     
1156     function view_get_ResultData() public
1157     view
1158     returns(uint32 TotalPlayer, uint256 TotalPayout ,uint256 MyTokenValue, uint256 MyToken, uint256 MyGains , uint256 MyScore)
1159     {
1160         address _player_address = msg.sender;
1161         
1162         GameRoundData_s storage  _GameRoundData = GameRoundData[ this_gRND ];
1163         
1164         TotalPlayer = _GameRoundData.extraData[1];
1165      
1166         TotalPayout = get_TotalPayout( _GameRoundData );
1167       
1168         MyToken =  PlayerGameRound[ _player_address][ this_gRND].token;
1169           
1170         MyTokenValue = MyToken * HDXcontract.sellingPrice( true );
1171         MyTokenValue /= magnitude;
1172       
1173         MyGains = 0;
1174      
1175         
1176         if (PlayerData[ _player_address].gRND == this_gRND)
1177         {
1178        
1179            MyGains =  get_PendingGainsAll( _player_address , this_gRND ); //just here for the view function so not used for any payout
1180         }
1181         
1182         MyScore = PlayerGameRound[_player_address][this_gRND].packedData[2];
1183     }    
1184  
1185  
1186     function totalEthereumBalance()
1187     public
1188     view
1189     returns(uint256)
1190     {
1191         return address(this).balance;
1192     }
1193     
1194     function view_get_maintenanceMode()
1195     public
1196     view
1197     returns(bool)
1198     {
1199         return( maintenanceMode);
1200     }
1201     
1202     function view_get_blockNumbers()
1203     public
1204     view
1205     returns( uint256 b1 , uint256 b2 )
1206     {
1207         return( block.number , GameRoundData[ this_gRND ].blockNumberTimeout);
1208         
1209     }
1210     
1211     function view_get_registeredNames(address _player)
1212     public
1213     view
1214     returns( bytes32)
1215     {
1216         
1217         return( registeredNames[ _player ]);
1218     }
1219     
1220    
1221 }
1222 
1223 
1224 library SafeMath {
1225     
1226    
1227     function mul(uint256 a, uint256 b) 
1228         internal 
1229         pure 
1230         returns (uint256 c) 
1231     {
1232         if (a == 0) {
1233             return 0;
1234         }
1235         c = a * b;
1236         require(c / a == b);
1237         return c;
1238     }
1239 
1240    
1241     function sub(uint256 a, uint256 b)
1242         internal
1243         pure
1244         returns (uint256) 
1245     {
1246         require(b <= a);
1247         return a - b;
1248     }
1249 
1250    
1251     function add(uint256 a, uint256 b)
1252         internal
1253         pure
1254         returns (uint256 c) 
1255     {
1256         c = a + b;
1257         require(c >= a);
1258         return c;
1259     }
1260     
1261    
1262     
1263   
1264     
1265    
1266 }
1267 
1268 
1269 library SafeMath128 {
1270     
1271    
1272     function mul(uint128 a, uint128 b) 
1273         internal 
1274         pure 
1275         returns (uint128 c) 
1276     {
1277         if (a == 0) {
1278             return 0;
1279         }
1280         c = a * b;
1281         require(c / a == b);
1282         return c;
1283     }
1284 
1285    
1286     function sub(uint128 a, uint128 b)
1287         internal
1288         pure
1289         returns (uint128) 
1290     {
1291         require(b <= a);
1292         return a - b;
1293     }
1294 
1295    
1296     function add(uint128 a, uint128 b)
1297         internal
1298         pure
1299         returns (uint128 c) 
1300     {
1301         c = a + b;
1302         require(c >= a);
1303         return c;
1304     }
1305     
1306    
1307     
1308   
1309     
1310    
1311 }