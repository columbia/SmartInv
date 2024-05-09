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
54 
55 
56     uint8[5] public HouseCards;
57     
58     mapping(address => uint8[2]) public PlayerCards;
59     mapping(address => uint256) public PlayerRound;
60     
61     uint256 public RoundNumber;
62     
63     uint8[6] public WinningHand; // tracks winning hand. ID 1 defines winning level (9=straight flush, 8=4 of a kind, etc) and other numbers 
64     address  public PokerWinner;
65     
66     uint8[2] public WinningCards;
67     // define the other cards which might play in defining the winner. 
68 
69     function GetCardNumber(uint8 rank, uint8 suit) public pure returns (uint8){
70         if (rank==0){
71             return 0;
72         }
73         
74         return ((rank-1)*4+1)+suit;
75     }
76     
77     function GetPlayerRound(address who) public view returns (uint256){
78         return PlayerRound[who];
79     }
80     
81     
82     
83     function GetCardInfo(uint8 n) public pure returns (uint8 rank, uint8 suit){
84         if (n==0){
85             return (0,0);
86         }
87         suit = (n-1)%4;
88         rank = (n-1)/4+1;
89     }
90     
91    // event pushifo(uint8, uint8, uint8,uint8,uint8);
92     // resets game 
93     function DrawHouse() internal {
94         // Draw table cards 
95         uint8 i;
96         uint8 rank;
97         uint8 suit;
98         uint8 n;
99         for (i=0; i<5; i++){
100             rank = uint8(GiveRNG(13)+1);
101             suit = uint8(GiveRNG(4));
102             n = GetCardNumber(rank,suit);
103             HouseCards[i]=n;
104         }
105 
106         uint8[2] storage target = PlayerCards[address(this)];
107         for (i=0; i<2; i++){
108             rank = uint8(GiveRNG(13)+1);
109             suit = uint8(GiveRNG(4));
110             n = GetCardNumber(rank,suit);
111 
112             target[i]=n;
113 
114         }
115         
116         WinningHand = RankScore(address(this));
117         WinningCards=[target[0],target[1]];
118         PokerWinner= address(this);
119     }
120     
121     event DrawnCards(address player, uint8 card1, uint8 card2);
122     function DrawAddr() internal {
123         uint8 tcard1;
124         uint8 tcard2;
125         for (uint8 i=0; i<2; i++){
126             uint8 rank = uint8(GiveRNG(13)+1);
127             uint8 suit = uint8(GiveRNG(4));
128             uint8 n = GetCardNumber(rank,suit);
129             
130             if (i==0){
131                 tcard1=n;
132             }
133             else{
134                 tcard2=n;
135             }
136 
137             PlayerCards[msg.sender][i]=n;
138 
139         }
140         
141         if (PlayerRound[msg.sender] != RoundNumber){
142             PlayerRound[msg.sender] = RoundNumber;
143         }
144         emit DrawnCards(msg.sender,tcard1, tcard2);
145     }
146     
147     function GetPlayerCards(address who) public view NoContract returns (uint8, uint8){
148         uint8[2] memory target = PlayerCards[who];
149         
150         return (target[0], target[1]);
151     }
152 
153     function GetWinCards() public view returns (uint8, uint8){
154         return (WinningCards[0], WinningCards[1]);
155     }
156     
157     
158     
159     // welp this is handy 
160     struct Card{
161         uint8 rank;
162         uint8 suit;
163     }
164     
165     // web 
166   //  function HandWinsView(address checkhand) view returns (uint8){
167     //    return HandWins(checkhand);
168     //}
169     
170     
171     function HandWins(address checkhand) internal returns (uint8){
172         uint8 result = HandWinsView(checkhand);
173         
174         uint8[6] memory CurrScore = RankScore(checkhand);
175             
176         uint8[2] memory target = PlayerCards[checkhand];
177         
178         if (result == 1){
179             WinningHand = CurrScore;
180             WinningCards= [target[0],target[1]];
181             PokerWinner=msg.sender;
182             // clear cards 
183             //PlayerCards[checkhand][0]=0;
184             //PlayerCards[checkhand][1]=0;
185         }
186         return result;
187     }
188     
189     // returns 0 if lose, 1 if win, 2 if equal 
190     // if winner found immediately sets winner values 
191     function HandWinsView(address checkhand) public view returns (uint8){ 
192         if (PlayerRound[checkhand] != RoundNumber){
193             return 0; // empty cards in new round. 
194         }
195         uint8[6] memory CurrentWinHand = WinningHand;
196         
197         uint8[6] memory CurrScore = RankScore(checkhand);
198         
199         
200         uint8 ret = 2;
201         if (CurrScore[0] > CurrentWinHand[0]){
202  
203             return 1;
204         }
205         else if (CurrScore[0] == CurrentWinHand[0]){
206             for (uint i=1; i<=5; i++){
207                 if (CurrScore[i] >= CurrentWinHand[i]){
208                     if (CurrScore[i] > CurrentWinHand[i]){
209 
210                         return 1;
211                     }
212                 }
213                 else{
214                     ret=0;
215                     break;
216                 }
217             }
218         }
219         else{
220             ret=0;
221         }
222         // 2 is same hand. commented out in pay mode 
223         // only winner gets pot. 
224         return ret;
225     }
226     
227     
228 
229     function RankScore(address checkhand) internal view returns (uint8[6] output){
230       
231         uint8[4] memory FlushTracker;
232         uint8[14] memory CardTracker;
233         
234         uint8 rank;
235         uint8 suit;
236         
237         Card[7] memory Cards;
238         
239         for (uint8 i=0; i<7; i++){
240             if (i>=5){
241                 (rank,suit) = GetCardInfo(PlayerCards[checkhand][i-5]);
242                 FlushTracker[suit]++;
243                 CardTracker[rank]++;
244                 Cards[i] = Card(rank,suit);
245             }
246             else{
247                 (rank,suit) = GetCardInfo(HouseCards[i]);
248                 FlushTracker[suit]++;
249                 CardTracker[rank]++;
250                 Cards[i] = Card(rank,suit);
251             }
252         }
253         
254         uint8 straight = 0;
255         // skip all zero's
256         uint8[3] memory straight_startcard;
257         for (uint8 startcard=13; i>=5; i--){
258             if (CardTracker[startcard] >= 1){
259                 for (uint8 currcard=startcard-1; currcard>=(startcard-4); currcard--){
260                     if (CardTracker[currcard] >= 1){
261                         if (currcard == (startcard-4)){
262                             // at end, straight 
263                             straight_startcard[straight] = startcard;
264                             straight++;
265                         }
266                     }
267                     else{
268                         break;
269                     }
270                 }
271             }
272         }
273         
274         uint8 flush=0;
275 
276         for (i=0;i<=3;i++){
277             if (FlushTracker[i]>=5){
278                 flush=i;
279                 break;
280             }
281         }
282         
283         // done init. 
284         
285         // straight flush? 
286         
287         
288         
289         if (flush>0 && straight>0){
290             // someone has straight flush? 
291             // level score 9 
292             output[0] = 9;
293             currcard=0;
294             for (i=0; i<3; i++){
295                 startcard=straight_startcard[i];
296                 currcard=5; // track flush, num 5 is standard.    
297                 for (rank=0; i<7; i++){
298                     if (Cards[i].suit == flush && Cards[i].rank <= startcard && Cards[i].rank>=(startcard-4)){
299                         currcard--;
300                         if (currcard==0){
301                             break;
302                         }
303                     }
304                 }
305                 if (currcard==0){
306                     // found straight flush high. 
307                     output[1] = straight_startcard[i]; // save the high card 
308                     break;
309                 }
310             }
311             
312             return output; 
313         }
314         
315         // high card 
316         
317         //reuse the rank variable to sum cards; 
318         rank=0;
319         for (i=13;i>=1;i--){
320             rank = rank + CardTracker[i];
321             if (CardTracker[i] >= 4){
322                 output[0] = 8; // high card 
323                 output[1] = i; // the type of card 
324                 return output;
325             }
326             if (rank >=4){
327                 break;
328             }
329         }
330         
331         // full house 
332         
333         rank=0; // track 3-kind 
334         suit=0; // track 2-kind 
335         startcard=0;
336         currcard=0;
337         
338         for (i=13;i>=1;i--){
339             if (rank == 0 && CardTracker[i] >= 3){
340                 rank = i;
341             }
342             else if(CardTracker[i] >= 2){
343                 if (suit == 0){
344                     suit = i;
345                 }
346                 else{
347                     // double nice 
348                     if (startcard==0){
349                         startcard=i;
350                     }
351                 }
352             }
353         }
354         
355         if (rank != 0 && suit != 0){
356             output[0] = 7;
357             output[1] = rank; // full house tripple high 
358             output[2] = suit; // full house tripple low 
359             return output;
360         }
361         
362         if (flush>0){
363             // flush 
364             output[0] = 6;
365             output[1] = flush;
366             return output;
367             
368         }
369         
370         if (straight>0){
371             //straight 
372             output[0] = 5;
373             output[1] = straight_startcard[0];
374             return output;
375         }
376         
377         if (rank>0){
378             // tripple 
379             output[0]=4;
380             output[1]=rank;
381             currcard=2; // track index; 
382             // get 2 highest cards 
383             for (i=13;i>=1;i--){
384                 if (i != rank){
385                     if (CardTracker[i] > 0){
386                         // note at three of a kind we have no other doubles; all other ranks are different so no check > 1 
387                         output[currcard] = i;
388                         currcard++;
389                         if(currcard==4){
390                             return output;
391                         }
392                     }
393                 }
394             }
395         }
396         
397         if (suit > 0 && startcard > 0){
398             // double pair 
399             output[0] = 3;
400             output[1] = suit;
401             output[2] = startcard;
402             // get highest card 
403             for (i=13;i>=1;i--){
404                 if (i!=suit && i!=startcard && CardTracker[i]>0){
405                     output[3]=i;
406                     return output;
407                 }
408             }
409         }
410         
411         if (suit > 0){
412             // pair 
413             output[0]=2;
414             output[1]=suit;
415             currcard=2;
416             // fill 3 other positions with high cards. 
417             for (i=13;i>=1;i--){
418                 if (i!=suit && CardTracker[i]>0){
419                     output[currcard]=i;
420                     currcard++;
421                     if(currcard==5){
422                         return output;
423                     }
424                 }   
425             }
426         }
427         
428         // welp you are here now, only have high card?
429         // boring 
430         output[0]=1;
431         currcard=1;
432         for (i=13;i>=1;i--){
433             if (CardTracker[i]>0){
434                 output[currcard]=i;
435                 currcard++;
436                 if (currcard==6){
437                     return output;
438                 }
439             }
440         }
441     }
442     
443 }
444 
445 contract Vegas is Poker{
446     address owner;
447     address public feesend;
448     
449     
450     uint256 public Timer;
451     
452     uint8 constant MAXPRICEPOWER = 40; // < 255
453     
454     address public JackpotWinner;
455     
456     uint16 public JackpotPayout = 8000; 
457     uint16 public PokerPayout = 2000;
458     uint16 public PreviousPayout = 6500;
459     uint16 public Increase = 9700;
460     uint16 public Tax = 500;
461     uint16 public PotPayout = 8000;
462     
463     uint256 public BasePrice = (0.005 ether);
464     
465     uint256 public TotalPot;
466     uint256 public PokerPayoutValue;
467     
468     // mainnet 
469     uint256[9] TimeArray = [uint256(6 hours), uint256(3 hours), uint256(2 hours), uint256(1 hours), uint256(50 minutes), uint256(40 minutes), uint256(30 minutes), uint256(20 minutes), uint256(15 minutes)];
470     // testnet 
471     //uint256[3] TimeArray = [uint256(3 minutes), uint256(3 minutes), uint256(2 minutes)];
472     
473     struct Item{
474         address Holder;
475         uint8 PriceID;
476     }
477     
478     Item[16] public Market;
479     
480     uint8 public MaxItems = 12; // max ID, is NOT index but actual max items to buy. 0 means really nothing, not 1 item 
481     
482     event ItemBought(uint256 Round, uint8 ID,  uint256 Price, address BoughtFrom, address NewOwner, uint256 NewTimer, uint256 NewJP, string Quote, string Name);
483     // quotes here ? 
484     event PokerPaid(uint256 Round, uint256 AmountWon, address Who, string Quote, string Name, uint8[6] WinHand);
485     event JackpotPaid(uint256 Round, uint256 Amount,  address Who, string Quote, string Name);
486     event NewRound();
487     
488     bool public EditMode;
489     bool public SetEditMode;
490     // dev functions 
491     
492     modifier OnlyOwner(){
493         require(msg.sender == owner);
494         _;
495     }
496     
497     modifier GameClosed(){
498         require (block.timestamp > Timer);
499         _;
500     }
501     
502 
503     
504     function Vegas() public{
505         owner=msg.sender;
506         feesend=0x09470436BD5b44c7EbDb75eEe2478eC172eAaBF6;
507         // withdraw also setups new game. 
508         // pays out 0 eth of course to owner, no eth in contract. 
509         Timer = 1; // makes sure withdrawal runs
510         Withdraw("Game init", "Admin");
511     }
512     
513     // all contract calls are banned from buying 
514     function Buy(uint8 ID, string Quote, string Name) public payable NoContract {
515         require(ID < MaxItems);
516         require(!EditMode);
517         // get price 
518         //uint8 pid = Market[ID].PriceID;
519         uint256 price = GetPrice(Market[ID].PriceID);
520         require(msg.value >= price);
521         
522         if (block.timestamp > Timer){
523             if (Timer != 0){ // timer 0 means withdraw is gone; withdraw will throw on 0
524                 Withdraw("GameInit", "Admin");
525                 return;
526             }
527         }
528         
529         // return excess 
530         if (msg.value > price){
531             msg.sender.transfer(msg.value-price);
532         }
533         
534         uint256 PayTax = (price * Tax)/10000;
535         feesend.transfer(PayTax);
536         uint256 Left = (price-PayTax);
537         
538         
539         if (Market[ID].PriceID!=0){
540             // unzero, move to previous owner
541             uint256 pay = (Left*PreviousPayout)/10000;
542             TotalPot = TotalPot + (Left-pay);
543            // Left=Left-pay;
544             Market[ID].Holder.transfer(pay);
545         }
546         else{
547             TotalPot = TotalPot + Left;
548         }
549         
550         // reset timer; 
551         Timer = block.timestamp + GetTime(Market[ID].PriceID);
552         //set jackpot winner 
553         JackpotWinner = msg.sender;
554 
555 
556         // give user new card; 
557         
558         emit ItemBought(RoundNumber,ID,  price,  Market[ID].Holder, msg.sender, Timer,  TotalPot,  Quote, Name);
559         
560         DrawAddr(); // give player cards
561         
562         // update price 
563         Market[ID].PriceID++;
564         //set holder 
565         Market[ID].Holder=msg.sender;
566     }
567     
568     function GetPrice(uint8 id) public view returns (uint256){
569         uint256 p = BasePrice;
570         if (id > 0){
571             // max price baseprice * increase^20 is reasonable
572             for (uint i=1; i<=id; i++){
573                 if (i==MAXPRICEPOWER){
574                     break; // prevent overflow (not sure why someone would buy at increase^255)
575                 }
576                 p = (p * (10000 + Increase))/10000;
577             }
578         }
579         
580         return p;
581     }
582     
583     function PayPoker(string Quote, string Name) public NoContract{
584         uint8 wins = HandWins(msg.sender);
585         if (wins>0){
586             uint256 available_balance = (TotalPot*PotPayout)/10000;
587             uint256 payment = sub ((available_balance * PokerPayout)/10000 , PokerPayoutValue);
588             
589             
590             
591             PokerPayoutValue = PokerPayoutValue + payment;
592             if (wins==1){
593                 msg.sender.transfer(payment);
594                 emit PokerPaid(RoundNumber, payment, msg.sender,  Quote,  Name, WinningHand);
595             }
596             /*
597             else if (wins==2){
598                 uint256 pval = payment/2;
599                 msg.sender.transfer(pval);
600                 PokerWinner.transfer(payment-pval);// saves 1 wei error 
601                 emit PokerPaid(RoundNumber, pval, msg.sender,  Quote,  Name, WinningHand);
602                 emit PokerPaid(RoundNumber, pval, msg.sender, "", "", WinningHand);
603             }*/
604         }
605         else{
606             // nice bluff mate 
607             revert();
608         }
609     }
610     
611     function GetTime(uint8 id) public view returns (uint256){
612         if (id >= TimeArray.length){
613             return TimeArray[TimeArray.length-1];
614         }
615         else{
616             return TimeArray[id];
617         }
618     }
619     
620     //function Call() public {
621    //     DrawHouse();
622    // }
623     
624     
625     // pays winner. 
626     // also sets up new game 
627     // winner receives lots of eth compared to gas so a small payment to gas is reasonable.
628     
629     function Withdraw(string Quote, string Name) public NoContract {
630         _withdraw(Quote,Name,false);
631     }
632     
633     // in case there is a revert bug in the poker contract 
634     // allows winner to get paid without calling poker. should never be called 
635     // follows all normal rules of game .
636     function WithdrawEmergency() public OnlyOwner{
637         _withdraw("Emergency withdraw call","Admin",true);
638     }
639     function _withdraw(string Quote, string Name, bool Emergency) NoContract internal {
640         // Setup cards for new game. 
641         
642         require(block.timestamp > Timer && Timer != 0);
643         Timer=0; // prevent re-entrancy immediately. 
644         
645         // send from this.balance 
646         uint256 available_balance = (TotalPot*PotPayout)/10000;
647         uint256 bal = (available_balance * JackpotPayout)/10000;
648         
649                     
650         JackpotWinner.transfer(bal);
651         emit JackpotPaid(RoundNumber, bal,  JackpotWinner, Quote, Name);
652         
653         // pay the last poker winner remaining poker pot.
654         bal = sub(sub(available_balance, bal),PokerPayoutValue);
655         if (bal > 0 && PokerWinner != address(this)){
656             // this only happens at start game,  some wei error 
657             if (bal > address(this).balance){
658                 PokerWinner.transfer(address(this).balance);
659             }
660             else{
661                 PokerWinner.transfer(bal);     
662             }
663            
664             emit PokerPaid(RoundNumber, bal, PokerWinner,  "Paid out left poker pot", "Dealer", WinningHand);
665         }
666         TotalPot = address(this).balance;
667     
668         // next poker pot starts at zero. 
669         PokerPayoutValue= (TotalPot * PotPayout * PokerPayout)/(10000*10000);
670 
671         // reset price 
672 
673         for (uint i=0; i<MaxItems; i++){
674             Market[i].PriceID=0;
675         }
676         
677         if (!Emergency){
678             DrawHouse();
679         }
680         RoundNumber++;
681         // enable edit mode if set by dev.
682         EditMode=SetEditMode;
683         
684         emit NewRound();
685     }
686     
687     // dev edit functions below 
688     
689     
690     function setEditModeBool(bool editmode) public OnlyOwner {
691         // start edit mode closes the whole game. 
692         SetEditMode=editmode;
693         if (!editmode){
694             // enable game round.
695             EditMode=false;
696         }
697     }
698     
699     function emergencyDropEth() public payable{
700         // any weird error might be solved by dropping eth (and no this is not even a scam, if contract needs a wei more, we send a wei, get funds out and fix contract)
701     }
702         
703     function editTimer(uint8 ID, uint256 Time) public OnlyOwner GameClosed{
704         TimeArray[ID] = Time;
705     }
706     
707     function editBasePrice(uint256 NewBasePrice) public OnlyOwner GameClosed{
708         BasePrice = NewBasePrice;  
709     }
710     
711     function editMaxItems(uint8 NewMax) public OnlyOwner GameClosed{
712         MaxItems = NewMax;
713     }
714     
715     function editPayoutSetting(uint8 setting, uint16 newv) public OnlyOwner GameClosed{
716         require(setting > 0);
717         if (setting == 1){
718             require(newv <= 10000);
719             JackpotPayout = newv;
720             PokerPayout = 10000-newv;
721         }
722         else if (setting == 2){
723             require(newv <= 10000);
724             PokerPayout = newv;
725             JackpotPayout = 10000-newv;
726         }
727         else if (setting == 3){
728             require (newv <= 10000);
729             PreviousPayout = newv;
730         }
731         else if (setting == 4){
732             require(newv <= 30000);
733             Increase = newv;
734         }
735         else if (setting == 5){
736             require(newv <=10000);
737             PotPayout = newv;
738         }
739         else if (setting == 6){
740             require(newv < 700);
741             Tax = newv;
742         }
743         else{
744             revert();
745         }
746     }
747     
748   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
749     if (a == 0) {
750       return 0;
751     }
752     uint256 c = a * b;
753     assert(c / a == b);
754     return c;
755   }
756 
757   /**
758   * @dev Integer division of two numbers, truncating the quotient.
759   */
760   function div(uint256 a, uint256 b) internal pure returns (uint256) {
761     // assert(b > 0); // Solidity automatically throws when dividing by 0
762     uint256 c = a / b;
763     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
764     return c;
765   }
766 
767   /**
768   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
769   */
770   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
771     assert(b <= a);
772     return a - b;
773   }
774 
775   /**
776   * @dev Adds two numbers, throws on overflow.
777   */
778   function add(uint256 a, uint256 b) internal pure returns (uint256) {
779     uint256 c = a + b;
780     assert(c >= a);
781     return c;
782   }
783 }