1 pragma solidity ^0.4.21;
2 
3 // EtherVegas V3 
4 // Updates: time is now a hard reset and is based on the price you buy with minimum 
5 // Name feature introduced plus quotes [added to UI soon]
6 // Poker feature added, pays about ~4/25 of entire collected pot currently 
7 // can be claimed multiple times (by other users). Last poker winner gets 
8 // remaining pot when complete jackpot is paid out 
9 
10 // HOST: ethlasvegas.surge.sh 
11 // Made by EtherGuy 
12 // Questions or suggestions? etherguy@mail.com 
13 
14 contract RNG{
15      uint256 secret = 0;
16      
17     // Thanks to TechnicalRise
18     // Ban contracts
19     modifier NoContract(){
20         uint size;
21         address addr = msg.sender;
22         assembly { size := extcodesize(addr) }
23         require(size == 0);
24         _;
25     }
26     
27     function RNG() public NoContract{
28         secret = uint256(keccak256(block.coinbase));
29     }
30     
31     function _giveRNG(uint256 modulo, uint256 secr) private view returns (uint256, uint256){
32         uint256 seed1 = uint256(block.coinbase);
33         uint256 seed3 = secr; 
34         uint256 newsecr = (uint256(keccak256(seed1,seed3)));
35         return (newsecr % modulo, newsecr);
36     }
37     
38 
39     function GiveRNG(uint256 max) internal NoContract returns (uint256){
40         uint256 num;
41         uint256 newsecret = secret;
42 
43         (num,newsecret) = _giveRNG(max, newsecret);
44         secret=newsecret;
45         return num; 
46     }
47     
48 
49 }
50 
51 contract Poker is RNG{
52     // warning; number 0 is a non-existing card; means empty;
53 
54     uint8[5] public HouseCards;
55     
56     mapping(address => uint8[2]) public PlayerCards;
57     mapping(address => uint256) public PlayerRound;
58     
59     uint256 public RoundNumber;
60     
61     uint8[6] public WinningHand; // tracks winning hand. ID 1 defines winning level (9=straight flush, 8=4 of a kind, etc) and other numbers 
62     address  public PokerWinner;
63     
64     uint8[2] public WinningCards;
65     // define the other cards which might play in defining the winner. 
66 
67     function GetCardNumber(uint8 rank, uint8 suit) public pure returns (uint8){
68         if (rank==0){
69             return 0;
70         }
71         
72         return ((rank-1)*4+1)+suit;
73     }
74     
75     function GetPlayerRound(address who) public view returns (uint256){
76         return PlayerRound[who];
77     }
78     
79     
80     
81     function GetCardInfo(uint8 n) public pure returns (uint8 rank, uint8 suit){
82         if (n==0){
83             return (0,0);
84         }
85         suit = (n-1)%4;
86         rank = (n-1)/4+1;
87     }
88     
89    // event pushifo(uint8, uint8, uint8,uint8,uint8);
90     // resets game 
91     function DrawHouse() internal{
92         // Draw table cards 
93         uint8 i;
94         uint8 rank;
95         uint8 suit;
96         uint8 n;
97         for (i=0; i<5; i++){
98             rank = uint8(GiveRNG(13)+1);
99             suit = uint8(GiveRNG(4));
100             n = GetCardNumber(rank,suit);
101             HouseCards[i]=n;
102         }
103 
104         uint8[2] storage target = PlayerCards[address(this)];
105         for (i=0; i<2; i++){
106             rank = uint8(GiveRNG(13)+1);
107             suit = uint8(GiveRNG(4));
108             n = GetCardNumber(rank,suit);
109 
110             target[i]=n;
111 
112         }
113         
114         WinningHand = RankScore(address(this));
115         WinningCards=[target[0],target[1]];
116         PokerWinner= address(this);
117     }
118     
119     event DrawnCards(address player, uint8 card1, uint8 card2);
120     function DrawAddr() internal {
121         uint8 tcard1;
122         uint8 tcard2;
123         for (uint8 i=0; i<2; i++){
124             uint8 rank = uint8(GiveRNG(13)+1);
125             uint8 suit = uint8(GiveRNG(4));
126             uint8 n = GetCardNumber(rank,suit);
127             
128             if (i==0){
129                 tcard1=n;
130             }
131             else{
132                 tcard2=n;
133             }
134 
135             PlayerCards[msg.sender][i]=n;
136 
137         }
138         
139         if (PlayerRound[msg.sender] != RoundNumber){
140             PlayerRound[msg.sender] = RoundNumber;
141         }
142         emit DrawnCards(msg.sender,tcard1, tcard2);
143     }
144     
145     function GetPlayerCards(address who) public view NoContract returns (uint8, uint8){
146         uint8[2] memory target = PlayerCards[who];
147         
148         return (target[0], target[1]);
149     }
150 
151     function GetWinCards() public view returns (uint8, uint8){
152         return (WinningCards[0], WinningCards[1]);
153     }
154     
155     
156     
157     // welp this is handy 
158     struct Card{
159         uint8 rank;
160         uint8 suit;
161     }
162     
163     // web 
164   //  function HandWinsView(address checkhand) view returns (uint8){
165     //    return HandWins(checkhand);
166     //}
167     
168     
169     function HandWins(address checkhand) internal returns (uint8){
170         uint8 result = HandWinsView(checkhand);
171         
172         uint8[6] memory CurrScore = RankScore(checkhand);
173             
174         uint8[2] memory target = PlayerCards[checkhand];
175         
176         if (result == 1){
177             WinningHand = CurrScore;
178             WinningCards= [target[0],target[1]];
179             PokerWinner=msg.sender;
180             // clear cards 
181             //PlayerCards[checkhand][0]=0;
182             //PlayerCards[checkhand][1]=0;
183         }
184         return result;
185     }
186     
187     // returns 0 if lose, 1 if win, 2 if equal 
188     // if winner found immediately sets winner values 
189     function HandWinsView(address checkhand) public view returns (uint8){ 
190         if (PlayerRound[checkhand] != RoundNumber){
191             return 0; // empty cards in new round. 
192         }
193         uint8[6] memory CurrentWinHand = WinningHand;
194         
195         uint8[6] memory CurrScore = RankScore(checkhand);
196         
197         
198         uint8 ret = 2;
199         if (CurrScore[0] > CurrentWinHand[0]){
200  
201             return 1;
202         }
203         else if (CurrScore[0] == CurrentWinHand[0]){
204             for (uint i=1; i<=5; i++){
205                 if (CurrScore[i] >= CurrentWinHand[i]){
206                     if (CurrScore[i] > CurrentWinHand[i]){
207 
208                         return 1;
209                     }
210                 }
211                 else{
212                     ret=0;
213                     break;
214                 }
215             }
216         }
217         else{
218             ret=0;
219         }
220         // 2 is same hand. commented out in pay mode 
221         // only winner gets pot. 
222         return ret;
223     }
224     
225     
226 
227     function RankScore(address checkhand) internal view returns (uint8[6] output){
228       
229         uint8[4] memory FlushTracker;
230         uint8[14] memory CardTracker;
231         
232         uint8 rank;
233         uint8 suit;
234         
235         Card[7] memory Cards;
236         
237         for (uint8 i=0; i<7; i++){
238             if (i>=5){
239                 (rank,suit) = GetCardInfo(PlayerCards[checkhand][i-5]);
240                 FlushTracker[suit]++;
241                 CardTracker[rank]++;
242                 Cards[i] = Card(rank,suit);
243             }
244             else{
245                 (rank,suit) = GetCardInfo(HouseCards[i]);
246                 FlushTracker[suit]++;
247                 CardTracker[rank]++;
248                 Cards[i] = Card(rank,suit);
249             }
250         }
251         
252         uint8 straight = 0;
253         // skip all zero's
254         uint8[3] memory straight_startcard;
255         for (uint8 startcard=13; i>=5; i--){
256             if (CardTracker[startcard] >= 1){
257                 for (uint8 currcard=startcard-1; currcard>=(startcard-4); currcard--){
258                     if (CardTracker[currcard] >= 1){
259                         if (currcard == (startcard-4)){
260                             // at end, straight 
261                             straight_startcard[straight] = startcard;
262                             straight++;
263                         }
264                     }
265                     else{
266                         break;
267                     }
268                 }
269             }
270         }
271         
272         uint8 flush=0;
273 
274         for (i=0;i<=3;i++){
275             if (FlushTracker[i]>=5){
276                 flush=i;
277                 break;
278             }
279         }
280         
281         // done init. 
282         
283         // straight flush? 
284         
285         
286         
287         if (flush>0 && straight>0){
288             // someone has straight flush? 
289             // level score 9 
290             output[0] = 9;
291             currcard=0;
292             for (i=0; i<3; i++){
293                 startcard=straight_startcard[i];
294                 currcard=5; // track flush, num 5 is standard.    
295                 for (rank=0; i<7; i++){
296                     if (Cards[i].suit == flush && Cards[i].rank <= startcard && Cards[i].rank>=(startcard-4)){
297                         currcard--;
298                         if (currcard==0){
299                             break;
300                         }
301                     }
302                 }
303                 if (currcard==0){
304                     // found straight flush high. 
305                     output[1] = straight_startcard[i]; // save the high card 
306                     break;
307                 }
308             }
309             
310             return output; 
311         }
312         
313         // high card 
314         
315         //reuse the rank variable to sum cards; 
316         rank=0;
317         for (i=13;i>=1;i--){
318             rank = rank + CardTracker[i];
319             if (CardTracker[i] >= 4){
320                 output[0] = 8; // high card 
321                 output[1] = i; // the type of card 
322                 return output;
323             }
324             if (rank >=4){
325                 break;
326             }
327         }
328         
329         // full house 
330         
331         rank=0; // track 3-kind 
332         suit=0; // track 2-kind 
333         startcard=0;
334         currcard=0;
335         
336         for (i=13;i>=1;i--){
337             if (rank == 0 && CardTracker[i] >= 3){
338                 rank = i;
339             }
340             else if(CardTracker[i] >= 2){
341                 if (suit == 0){
342                     suit = CardTracker[i];
343                 }
344                 else{
345                     // double nice 
346                     if (startcard==0){
347                         startcard=CardTracker[i];
348                     }
349                 }
350             }
351         }
352         
353         if (rank != 0 && suit != 0){
354             output[0] = 7;
355             output[1] = rank; // full house tripple high 
356             output[2] = suit; // full house tripple low 
357             return output;
358         }
359         
360         if (flush>0){
361             // flush 
362             output[0] = 6;
363             output[1] = flush;
364             return output;
365             
366         }
367         
368         if (straight>0){
369             //straight 
370             output[0] = 5;
371             output[1] = straight_startcard[0];
372             return output;
373         }
374         
375         if (rank>0){
376             // tripple 
377             output[0]=4;
378             output[1]=rank;
379             currcard=2; // track index; 
380             // get 2 highest cards 
381             for (i=13;i>=1;i--){
382                 if (i != rank){
383                     if (CardTracker[i] > 0){
384                         // note at three of a kind we have no other doubles; all other ranks are different so no check > 1 
385                         output[currcard] = i;
386                         currcard++;
387                         if(currcard==4){
388                             return output;
389                         }
390                     }
391                 }
392             }
393         }
394         
395         if (suit > 0 && startcard > 0){
396             // double pair 
397             output[0] = 3;
398             output[1] = suit;
399             output[2] = startcard;
400             // get highest card 
401             for (i=13;i>=1;i--){
402                 if (i!=suit && i!=startcard && CardTracker[i]>0){
403                     output[3]=i;
404                     return output;
405                 }
406             }
407         }
408         
409         if (suit > 0){
410             // pair 
411             output[0]=2;
412             output[1]=suit;
413             currcard=2;
414             // fill 3 other positions with high cards. 
415             for (i=13;i>=1;i--){
416                 if (i!=suit && CardTracker[i]>0){
417                     output[currcard]=i;
418                     currcard++;
419                     if(currcard==5){
420                         return output;
421                     }
422                 }   
423             }
424         }
425         
426         // welp you are here now, only have high card?
427         // boring 
428         output[0]=1;
429         currcard=1;
430         for (i=13;i>=1;i--){
431             if (CardTracker[i]>0){
432                 output[currcard]=i;
433                 currcard++;
434                 if (currcard==6){
435                     return output;
436                 }
437             }
438         }
439     }
440     
441 }
442 
443 contract Vegas is Poker{
444     address owner;
445     address public feesend;
446     
447     
448     uint256 public Timer;
449     
450     uint8 constant MAXPRICEPOWER = 40; // < 255
451     
452     address public JackpotWinner;
453     
454     uint16 public JackpotPayout = 8000; 
455     uint16 public PokerPayout = 2000;
456     uint16 public PreviousPayout = 6500;
457     uint16 public Increase = 9700;
458     uint16 public Tax = 500;
459     uint16 public PotPayout = 8000;
460     
461     uint256 public BasePrice = (0.005 ether);
462     
463     uint256 public TotalPot;
464     uint256 public PokerPayoutValue;
465     
466     // mainnet 
467     uint256[9] TimeArray = [uint256(6 hours), uint256(3 hours), uint256(2 hours), uint256(1 hours), uint256(50 minutes), uint256(40 minutes), uint256(30 minutes), uint256(20 minutes), uint256(15 minutes)];
468     // testnet 
469     //uint256[3] TimeArray = [uint256(3 minutes), uint256(3 minutes), uint256(2 minutes)];
470     
471     struct Item{
472         address Holder;
473         uint8 PriceID;
474     }
475     
476     Item[16] public Market;
477     
478     uint8 public MaxItems = 12; // max ID, is NOT index but actual max items to buy. 0 means really nothing, not 1 item 
479     
480     event ItemBought(uint256 Round, uint8 ID,  uint256 Price, address BoughtFrom, address NewOwner, uint256 NewTimer, uint256 NewJP, string Quote, string Name);
481     // quotes here ? 
482     event PokerPaid(uint256 Round, uint256 AmountWon, address Who, string Quote, string Name, uint8[6] WinHand);
483     event JackpotPaid(uint256 Round, uint256 Amount,  address Who, string Quote, string Name);
484     event NewRound();
485     
486     bool public EditMode;
487     bool public SetEditMode;
488     // dev functions 
489     
490     modifier OnlyOwner(){
491         require(msg.sender == owner);
492         _;
493     }
494     
495     modifier GameClosed(){
496         require (block.timestamp > Timer);
497         _;
498     }
499     
500 
501     
502     function Vegas() public{
503         owner=msg.sender;
504         feesend=0xC1086FA97549CEA7acF7C2a7Fa7820FD06F3e440;
505         // withdraw also setups new game. 
506         // pays out 0 eth of course to owner, no eth in contract. 
507         Timer = 1; // makes sure withdrawal runs
508         //Withdraw("Game init", "Admin");
509     }
510     
511     // all contract calls are banned from buying 
512     function Buy(uint8 ID, string Quote, string Name) public payable NoContract {
513         require(ID < MaxItems);
514         require(!EditMode);
515         // get price 
516         //uint8 pid = Market[ID].PriceID;
517         uint256 price = GetPrice(Market[ID].PriceID);
518         require(msg.value >= price);
519         
520         if (block.timestamp > Timer){
521             if (Timer != 0){ // timer 0 means withdraw is gone; withdraw will throw on 0
522                 Withdraw("GameInit", "Admin");
523                 return;
524             }
525         }
526         
527         // return excess 
528         if (msg.value > price){
529             msg.sender.transfer(msg.value-price);
530         }
531         
532         uint256 PayTax = (price * Tax)/10000;
533         feesend.transfer(PayTax);
534         uint256 Left = (price-PayTax);
535         
536         
537         if (Market[ID].PriceID!=0){
538             // unzero, move to previous owner
539             uint256 pay = (Left*PreviousPayout)/10000;
540             TotalPot = TotalPot + (Left-pay);
541            // Left=Left-pay;
542             Market[ID].Holder.transfer(pay);
543         }
544         else{
545             TotalPot = TotalPot + Left;
546         }
547         
548         // reset timer; 
549         Timer = block.timestamp + GetTime(Market[ID].PriceID);
550         //set jackpot winner 
551         JackpotWinner = msg.sender;
552 
553 
554         // give user new card; 
555         
556         emit ItemBought(RoundNumber,ID,  price,  Market[ID].Holder, msg.sender, Timer,  TotalPot,  Quote, Name);
557         
558         DrawAddr(); // give player cards
559         
560         // update price 
561         Market[ID].PriceID++;
562         //set holder 
563         Market[ID].Holder=msg.sender;
564     }
565     
566     function GetPrice(uint8 id) public view returns (uint256){
567         uint256 p = BasePrice;
568         if (id > 0){
569             // max price baseprice * increase^20 is reasonable
570             for (uint i=1; i<=id; i++){
571                 if (i==MAXPRICEPOWER){
572                     break; // prevent overflow (not sure why someone would buy at increase^255)
573                 }
574                 p = (p * (10000 + Increase))/10000;
575             }
576         }
577         
578         return p;
579     }
580     
581     function PayPoker(string Quote, string Name) public NoContract{
582         uint8 wins = HandWins(msg.sender);
583         if (wins>0){
584             uint256 available_balance = (TotalPot*PotPayout)/10000;
585             uint256 payment = sub ((available_balance * PokerPayout)/10000 , PokerPayoutValue);
586             
587             
588             
589             PokerPayoutValue = PokerPayoutValue + payment;
590             if (wins==1){
591                 msg.sender.transfer(payment);
592                 emit PokerPaid(RoundNumber, payment, msg.sender,  Quote,  Name, WinningHand);
593             }
594             /*
595             else if (wins==2){
596                 uint256 pval = payment/2;
597                 msg.sender.transfer(pval);
598                 PokerWinner.transfer(payment-pval);// saves 1 wei error 
599                 emit PokerPaid(RoundNumber, pval, msg.sender,  Quote,  Name, WinningHand);
600                 emit PokerPaid(RoundNumber, pval, msg.sender, "", "", WinningHand);
601             }*/
602         }
603         else{
604             // nice bluff mate 
605             revert();
606         }
607     }
608     
609     function GetTime(uint8 id) public view returns (uint256){
610         if (id >= TimeArray.length){
611             return TimeArray[TimeArray.length-1];
612         }
613         else{
614             return TimeArray[id];
615         }
616     }
617     
618     //function Call() public {
619    //     DrawHouse();
620    // }
621     
622     
623     // pays winner. 
624     // also sets up new game 
625     // winner receives lots of eth compared to gas so a small payment to gas is reasonable.
626     
627     function Withdraw(string Quote, string Name) public NoContract {
628         _withdraw(Quote,Name,false);
629     }
630     
631     // in case there is a revert bug in the poker contract 
632     // allows winner to get paid without calling poker. should never be called 
633     // follows all normal rules of game .
634     function WithdrawEmergency() public OnlyOwner{
635         _withdraw("Emergency withdraw call","Admin",true);
636     }
637     function _withdraw(string Quote, string Name, bool Emergency) NoContract internal {
638         // Setup cards for new game. 
639         
640         require(block.timestamp > Timer && Timer != 0);
641         Timer=0; // prevent re-entrancy immediately. 
642         
643         // send from this.balance 
644         uint256 available_balance = (TotalPot*PotPayout)/10000;
645         uint256 bal = (available_balance * JackpotPayout)/10000;
646         
647                     
648         JackpotWinner.transfer(bal);
649         emit JackpotPaid(RoundNumber, bal,  JackpotWinner, Quote, Name);
650         
651         // pay the last poker winner remaining poker pot.
652         bal = sub(sub(available_balance, bal),PokerPayoutValue);
653         if (bal > 0 && PokerWinner != address(this)){
654             // this only happens at start game,  some wei error 
655             if (bal > address(this).balance){
656                 PokerWinner.transfer(address(this).balance);
657             }
658             else{
659                 PokerWinner.transfer(bal);     
660             }
661            
662             emit PokerPaid(RoundNumber, bal, PokerWinner,  "Paid out left poker pot", "Dealer", WinningHand);
663         }
664         TotalPot = address(this).balance;
665     
666         // next poker pot starts at zero. 
667         PokerPayoutValue= (TotalPot * PotPayout * PokerPayout)/(10000*10000);
668 
669         // reset price 
670 
671         for (uint i=0; i<MaxItems; i++){
672             Market[i].PriceID=0;
673         }
674         
675         if (!Emergency){
676             DrawHouse();
677         }
678         RoundNumber++;
679         // enable edit mode if set by dev.
680         EditMode=SetEditMode;
681         
682         emit NewRound();
683     }
684     
685     // dev edit functions below 
686     
687     
688     function setEditModeBool(bool editmode) public OnlyOwner {
689         // start edit mode closes the whole game. 
690         SetEditMode=editmode;
691         if (!editmode){
692             // enable game round.
693             EditMode=false;
694         }
695     }
696     
697     function emergencyDropEth() public payable{
698         // any weird error might be solved by dropping eth (and no this is not even a scam, if contract needs a wei more, we send a wei, get funds out and fix contract)
699     }
700         
701     function editTimer(uint8 ID, uint256 Time) public OnlyOwner GameClosed{
702         TimeArray[ID] = Time;
703     }
704     
705     function editBasePrice(uint256 NewBasePrice) public OnlyOwner GameClosed{
706         BasePrice = NewBasePrice;  
707     }
708     
709     function editMaxItems(uint8 NewMax) public OnlyOwner GameClosed{
710         MaxItems = NewMax;
711     }
712     
713     function editPayoutSetting(uint8 setting, uint16 newv) public OnlyOwner GameClosed{
714         require(setting > 0);
715         if (setting == 1){
716             require(newv <= 10000);
717             JackpotPayout = newv;
718             PokerPayout = 10000-newv;
719         }
720         else if (setting == 2){
721             require(newv <= 10000);
722            
723             PokerPayout = newv;
724             JackpotPayout = 10000-newv;
725         }
726         else if (setting == 3){
727             require (newv <= 10000);
728             PreviousPayout = newv;
729         }
730         else if (setting == 4){
731             require(newv <= 30000);
732             Increase = newv;
733         }
734         else if (setting == 5){
735             require(newv <=10000);
736             PotPayout = newv;
737         }
738         else if (setting == 6){
739             require(newv < 700);
740             Tax = newv;
741         }
742         else{
743             revert();
744         }
745     }
746     
747   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
748     if (a == 0) {
749       return 0;
750     }
751     uint256 c = a * b;
752     assert(c / a == b);
753     return c;
754   }
755 
756   /**
757   * @dev Integer division of two numbers, truncating the quotient.
758   */
759   function div(uint256 a, uint256 b) internal pure returns (uint256) {
760     // assert(b > 0); // Solidity automatically throws when dividing by 0
761     uint256 c = a / b;
762     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
763     return c;
764   }
765 
766   /**
767   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
768   */
769   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
770     assert(b <= a);
771     return a - b;
772   }
773 
774   /**
775   * @dev Adds two numbers, throws on overflow.
776   */
777   function add(uint256 a, uint256 b) internal pure returns (uint256) {
778     uint256 c = a + b;
779     assert(c >= a);
780     return c;
781   }
782 }