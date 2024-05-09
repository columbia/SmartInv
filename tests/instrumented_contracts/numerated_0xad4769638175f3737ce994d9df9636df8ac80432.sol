1 /**+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
2                             abcLotto: a Block Chain Lottery
3 
4                             Don't trust anyone but the CODE!
5  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
6  /*
7  * This product is protected under license.  Any unauthorized copy, modification, or use without 
8  * express written consent from the creators is prohibited.
9  */
10 
11 /**+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
12                             - this is a 5/16 lotto, choose 5 numbers in 1-16.
13                             - per ticket has two chance to win the jackpot, daily and weekly.
14                             - daily jackpot need choose 5 right numbers.
15                             - weekly jackpot need choose 5 rights numbers with right sequence.
16                             - you must have an inviter then to buy.
17                             - act as inviter will get bonus.
18  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
19  pragma solidity ^0.4.20;
20 /**
21 * @title abc address resolver interface. 
22  */ 
23 contract abcResolverI{
24     function getWalletAddress() public view returns (address);
25     function getBookAddress() public view returns (address);
26     function getControllerAddress() public view returns (address);
27 }
28 
29 /**
30 * @title inviter book interface. 
31  */ 
32 contract inviterBookI{
33     function isRoot(address addr) public view returns(bool);
34     function hasInviter(address addr) public view returns(bool);
35     function setInviter(address addr, string inviter) public;
36     function pay(address addr) public payable;
37 }
38 
39 /**
40 * @title abcLotto : data structure, buy and reward functions.
41 * @dev a decentralized lottery application. 
42  */ 
43  contract abcLotto{
44      using SafeMath for *;
45      
46      //global varibles
47      abcResolverI public resolver;
48      address public controller;
49      inviterBookI public book;
50      address public wallet;
51 
52      uint32 public currentRound;   //current round, plus 1 every day;
53      uint8 public currentState; //1 - bet period, 2 - freeze period, 3 - draw period.
54      uint32[] public amounts;	//buy amount per round.
55      uint32[] public addrs; //buy addresses per round.
56      bool[] public drawed;    //lottery draw finished mark.
57      
58      uint public rollover = 0;
59      uint[] public poolUsed;
60      
61      //constant
62      uint constant ABC_GAS_CONSUME = 50; //this abc Dapp cost, default 50/1000.
63      uint constant INVITER_FEE = 100; // inviter fee, default 100/1000;
64      uint constant SINGLE_BET_PRICE = 50000000000000000;    // single bet price is 0.05 ether.
65      uint constant THISDAPP_DIV = 1000;
66      uint constant POOL_ALLOCATION_WEEK = 500;
67      uint constant POOL_ALLOCATION_JACKPOT = 618;
68      uint constant MAX_BET_AMOUNT = 100;   //per address can bet amount must be less than 100 per round.
69      uint8 constant MAX_BET_NUM = 16;
70      uint8 constant MIN_BET_NUM = 1;
71 
72      //data structures
73      struct UnitBet{
74          uint8[5] _nums;
75 		 bool _payed1;  //daily
76          bool _payed2;  //weekly
77      }
78      struct AddrBets{
79          UnitBet[] _unitBets;
80      }    
81      struct RoundBets{
82          mapping (address=>AddrBets) _roundBets;
83      }
84      RoundBets[] allBets;
85      
86      struct BetKeyEntity{
87          mapping (bytes5=>uint32) _entity;
88      }     
89      BetKeyEntity[] betDaily;
90      BetKeyEntity[] betWeekly;
91 
92      struct Jackpot{
93 	     uint8[5] _results;
94      }
95      Jackpot[] dailyJackpot;
96      Jackpot[] weeklyJackpot;
97      
98      //events
99      event OnBuy(address user, uint32 round, uint32 index, uint8[5] nums);
100      event OnRewardDaily(address user, uint32 round, uint32 index, uint reward);
101      event OnRewardWeekly(address user, uint32 round, uint32 index,uint reward);
102      event OnRewardDailyFailed(address user, uint32 round, uint32 index);
103      event OnRewardWeeklyFailed(address user, uint32 round, uint32 index);
104      event OnNewRound(uint32 round);
105      event OnFreeze(uint32 round);
106      event OnUnFreeze(uint32 round);
107      event OnDrawStart(uint32 round);
108      event OnDrawFinished(uint32 round, uint8[5] jackpot);
109      event BalanceNotEnough();
110      
111       //modifier
112      modifier onlyController {
113          require(msg.sender == controller);
114          _;
115      }     
116      
117      modifier onlyBetPeriod {
118          require(currentState == 1);
119          _;
120      }
121      
122      modifier onlyHuman {
123          require(msg.sender == tx.origin);
124          _;
125      }
126      
127      //check contract interface, are they upgrated?
128      modifier abcInterface {
129         if((address(resolver)==0)||(getCodeSize(address(resolver))==0)){
130             if(abc_initNetwork()){
131                 wallet = resolver.getWalletAddress();
132                 book = inviterBookI(resolver.getBookAddress());
133                 controller = resolver.getControllerAddress();
134             }
135         }
136         else{
137             if(wallet != resolver.getWalletAddress())
138                 wallet = resolver.getWalletAddress();
139 
140             if(address(book) != resolver.getBookAddress())
141                 book = inviterBookI(resolver.getBookAddress());
142                 
143             if(controller != resolver.getControllerAddress())
144                 controller = resolver.getControllerAddress();
145         }    
146 
147         _;        
148      }
149 
150      /**
151      * @dev fallback funtion, this contract don't accept ether directly.
152      */
153      function() public payable { 
154          revert();
155      }
156 
157      /**
158      * @dev init address resolver.
159      */ 
160      function abc_initNetwork() internal returns(bool) { 
161          //mainnet
162          if (getCodeSize(0xde4413799c73a356d83ace2dc9055957c0a5c335)>0){     
163             resolver = abcResolverI(0xde4413799c73a356d83ace2dc9055957c0a5c335);
164             return true;
165          }               
166    
167          //others ...
168 
169          return false;
170      }     
171     /**
172     * @dev get code size of appointed address.
173      */
174      function getCodeSize(address _addr) internal view returns(uint _size) {
175          assembly {
176              _size := extcodesize(_addr)
177          }
178      }
179     //+++++++++++++++++++++++++                  public operation functions               +++++++++++++++++++++++++++++++++++++
180     /**
181     * @dev buy: buy a new ticket.
182      */
183     function buy(uint8[5] nums, string inviter) 
184         public
185         payable
186         onlyBetPeriod
187         onlyHuman
188         abcInterface
189         returns (uint)
190      {
191          //check number range 1-16, no repeat number.
192          if(!isValidNum(nums)) revert();
193          //doesn't offer enough value.
194          if(msg.value < SINGLE_BET_PRICE) revert();
195          
196          //check daily amount is less than MAX_BET_AMOUNT
197          uint _am = allBets[currentRound-1]._roundBets[msg.sender]._unitBets.length.add(1);      
198          if( _am > MAX_BET_AMOUNT) revert();
199          
200          //update storage varibles.
201          amounts[currentRound-1]++;
202          if(allBets[currentRound-1]._roundBets[msg.sender]._unitBets.length <= 0)
203             addrs[currentRound-1]++;
204             
205          //insert bet record.
206          UnitBet memory _bet;
207          _bet._nums = nums;
208          _bet._payed1 = false;
209          _bet._payed2 = false;
210          allBets[currentRound-1]._roundBets[msg.sender]._unitBets.push(_bet);
211          
212          //increase key-value records.
213          bytes5 _key;
214          _key = generateCombinationKey(nums);
215          betDaily[currentRound-1]._entity[_key]++;
216          _key = generatePermutationKey(nums);
217          uint32 week = (currentRound-1) / 7;
218          betWeekly[week]._entity[_key]++;
219          
220          //refund extra value.
221          if(msg.value > SINGLE_BET_PRICE){
222              msg.sender.transfer(msg.value.sub(SINGLE_BET_PRICE));
223          }
224 
225          //has inviter?
226          if(book.hasInviter(msg.sender) || book.isRoot(msg.sender)){
227             book.pay.value(SINGLE_BET_PRICE.mul(INVITER_FEE).div(THISDAPP_DIV))(msg.sender);
228          }
229          else{
230             book.setInviter(msg.sender, inviter);
231             book.pay.value(SINGLE_BET_PRICE.mul(INVITER_FEE).div(THISDAPP_DIV))(msg.sender);
232          }
233          
234         //emit event
235         emit OnBuy(msg.sender, currentRound, uint32(allBets[currentRound-1]._roundBets[msg.sender]._unitBets.length), nums);
236         return allBets[currentRound-1]._roundBets[msg.sender]._unitBets.length;
237          
238      }
239      /**
240      * @dev rewardDaily: apply for daily reward.
241      */     
242      function rewardDaily(uint32 round, uint32 index)
243         public 
244         onlyBetPeriod 
245         onlyHuman  
246         returns(uint) 
247      {
248          require(round>0 && round<=currentRound);
249          require(drawed[round-1]);
250          require(index>0 && index<=allBets[round-1]._roundBets[msg.sender]._unitBets.length);
251          require(!allBets[round-1]._roundBets[msg.sender]._unitBets[index-1]._payed1);
252 
253          uint8[5] memory nums = allBets[round-1]._roundBets[msg.sender]._unitBets[index-1]._nums;
254          
255          bytes5 key = generateCombinationKey(nums);
256          bytes5 jackpot = generateCombinationKey(dailyJackpot[round-1]._results);
257          if(key != jackpot) return;
258          
259          uint win_amount = betDaily[round-1]._entity[key];
260          if(win_amount <= 0) return;
261 
262          uint amount = amounts[round-1];
263          uint total = SINGLE_BET_PRICE.mul(amount).mul(THISDAPP_DIV-INVITER_FEE).div(THISDAPP_DIV).mul(THISDAPP_DIV - POOL_ALLOCATION_WEEK).div(THISDAPP_DIV);
264          uint pay = total.mul(THISDAPP_DIV - ABC_GAS_CONSUME).div(THISDAPP_DIV).div(win_amount);
265 
266          //pay action
267          if(pay > address(this).balance){
268             emit BalanceNotEnough();
269             revert();             
270          }
271          allBets[round-1]._roundBets[msg.sender]._unitBets[index-1]._payed1 = true;
272          if(!msg.sender.send(pay)){
273             emit OnRewardDailyFailed(msg.sender, round, index);
274             revert();
275          }
276          
277          emit OnRewardDaily(msg.sender, round, index, pay);
278          return pay;
279      }      
280      
281      /**
282      * @dev rewardWeekly: apply for weekly reward.
283       */
284      function rewardWeekly(uint32 round, uint32 index) 
285         public 
286         onlyBetPeriod 
287         onlyHuman
288         returns(uint) 
289      {
290          require(round>0 && round<=currentRound);
291          require(drawed[round-1]);
292          require(index>0 && index<=allBets[round-1]._roundBets[msg.sender]._unitBets.length);
293          require(!allBets[round-1]._roundBets[msg.sender]._unitBets[index-1]._payed2);
294 
295          uint32 week = (round-1)/7 + 1;
296          uint8[5] memory nums = allBets[round-1]._roundBets[msg.sender]._unitBets[index-1]._nums;
297          
298          bytes5 key = generatePermutationKey(nums);
299          bytes5 jackpot = generatePermutationKey(weeklyJackpot[week-1]._results);
300          if(key != jackpot) return;
301          
302          uint32 win_amount = betWeekly[week-1]._entity[key];
303          if(win_amount <= 0) return;     
304 
305          uint pay = poolUsed[week-1].div(win_amount);
306          
307          //pay action
308          if(pay > address(this).balance){
309             emit BalanceNotEnough();
310             return;             
311          }
312          allBets[round-1]._roundBets[msg.sender]._unitBets[index-1]._payed2 = true;
313          if(!msg.sender.send(pay)){
314             emit OnRewardWeeklyFailed(msg.sender, round, index);
315             revert();
316          }
317          
318         emit OnRewardWeekly(msg.sender, round, index, pay);
319         return pay;
320      }
321      //+++++++++++++++++++++++++                  pure or view functions               +++++++++++++++++++++++++++++++++++++
322      /**
323      * @dev getSingleBet: get self's bet record.
324       */
325     function getSingleBet(uint32 round, uint32 index) 
326         public 
327         view 
328         returns(uint8[5] nums, bool payed1, bool payed2)
329      {
330          if(round == 0 || round > currentRound) return;
331 
332          uint32 iLen = uint32(allBets[round-1]._roundBets[msg.sender]._unitBets.length);
333          if(iLen <= 0) return;
334          if(index == 0 || index > iLen) return;
335          
336          nums = allBets[round-1]._roundBets[msg.sender]._unitBets[index-1]._nums;
337          payed1 = allBets[round-1]._roundBets[msg.sender]._unitBets[index-1]._payed1;
338          payed2 = allBets[round-1]._roundBets[msg.sender]._unitBets[index-1]._payed2;
339      }
340      /**
341      * @dev getAmountDailybyNum: get the daily bet amount of a set of numbers.
342       */
343      function getAmountDailybyNum(uint32 round, uint8[5] nums) 
344         public 
345         view 
346         returns(uint32)
347     {
348          if(round == 0 || round > currentRound) return 0;       
349          bytes5 _key = generateCombinationKey(nums);
350          
351          return betDaily[round-1]._entity[_key];
352      }
353 
354      /**
355      * @dev getAmountWeeklybyNum: get the weekly bet amount of a set of numbers.
356       */     
357      function getAmountWeeklybyNum(uint32 week, uint8[5] nums) 
358         public 
359         view 
360         returns(uint32)
361     {
362          if(week == 0 || currentRound < (week-1)*7) return 0;
363          
364          bytes5 _key = generatePermutationKey(nums);
365          return betWeekly[week-1]._entity[_key];
366      }
367      
368      /**
369      * @dev getDailyJackpot: some day's Jackpot.
370       */
371      function getDailyJackpot(uint32 round) 
372         public 
373         view 
374         returns(uint8[5] jackpot, uint32 amount)
375     {
376          if(round == 0 || round > currentRound) return;
377          jackpot = dailyJackpot[round-1]._results;
378          amount = getAmountDailybyNum(round, jackpot);
379      }
380 
381      /**
382      * @dev getWeeklyJackpot: some week's Jackpot.
383       */
384      function getWeeklyJackpot(uint32 week) 
385         public 
386         view 
387         returns(uint8[5] jackpot, uint32 amount)
388     {
389          if(week == 0 || week > currentRound/7) return;
390          jackpot = weeklyJackpot[week - 1]._results;
391          amount = getAmountWeeklybyNum(week, jackpot);
392      }
393 
394      //+++++++++++++++++++++++++                  controller functions               +++++++++++++++++++++++++++++++++++++
395      /**
396       * @dev start new round.
397      */ 
398     function nextRound() 
399         abcInterface
400         public 
401         onlyController
402     {
403          //current round must be drawed.
404          if(currentRound > 0)
405             require(drawed[currentRound-1]);
406          
407          currentRound++;
408          currentState = 1;
409          
410          amounts.length++;
411          addrs.length++;
412          drawed.length++;
413          
414          RoundBets memory _rb;
415          allBets.push(_rb);
416          
417          BetKeyEntity memory _en1;
418          betDaily.push(_en1);
419          
420          Jackpot memory _b1;
421          dailyJackpot.push(_b1);
422          //if is a weekend or beginning.
423          if((currentRound-1) % 7 == 0){
424              BetKeyEntity memory _en2;
425              betWeekly.push(_en2);
426              Jackpot memory _b2;
427              weeklyJackpot.push(_b2);
428              poolUsed.length++;
429          }
430          emit OnNewRound(currentRound);
431      }
432 
433     /**
434     * @dev freeze: enter freeze period.
435      */
436     function freeze() 
437         abcInterface
438         public
439         onlyController 
440     {
441         currentState = 2;
442         emit OnFreeze(currentRound);
443     }
444 
445     /**
446     * @dev freeze: enter freeze period.
447      */
448     function unfreeze()
449         abcInterface
450         public 
451         onlyController 
452     {
453         require(currentState == 2);
454         currentState = 1;
455         emit OnUnFreeze(currentRound);
456     }
457     
458     /**
459     * @dev draw: enter freeze period.
460      */
461     function draw() 
462         abcInterface 
463         public 
464         onlyController
465     {
466         require(!drawed[currentRound-1]);
467         currentState = 3;
468         emit OnDrawStart(currentRound);
469     }
470 
471     /**
472     * @dev controller have generated and set Jackpot.
473      */
474     function setJackpot(uint8[5] jackpot) 
475         abcInterface
476         public
477         onlyController
478     {
479         require(currentState==3 && !drawed[currentRound-1]);
480         //check jackpot range 1-16, no repeat number.
481         if(!isValidNum(jackpot)) return;
482   
483         uint _fee = 0;
484 
485         //mark daily entity's prize.-----------------------------------------------------------------------------------
486         uint8[5] memory _jackpot1 = sort(jackpot);
487         dailyJackpot[currentRound-1]._results = _jackpot1;
488         bytes5 _key = generateCombinationKey(_jackpot1);
489         uint total = SINGLE_BET_PRICE.mul(amounts[currentRound-1]).mul(THISDAPP_DIV-INVITER_FEE).div(THISDAPP_DIV).mul(THISDAPP_DIV - POOL_ALLOCATION_WEEK).div(THISDAPP_DIV);
490         uint win_amount = uint(betDaily[currentRound-1]._entity[_key]);
491         uint _bonus_sum;
492 
493         if( win_amount <= 0){
494             rollover = rollover.add(total);
495         }
496         else{
497             _bonus_sum = total.mul(THISDAPP_DIV - ABC_GAS_CONSUME).div(THISDAPP_DIV).div(win_amount).mul(win_amount);
498             _fee = _fee.add(total.sub(_bonus_sum));
499         }
500          //end mark.-----------------------------------------------------------------------------------
501 
502         //mark weekly entity's prize.---------------------------------------------------------------------------------------
503         if((currentRound > 0) && (currentRound % 7 == 0)){
504             uint32 _week = currentRound/7;
505             weeklyJackpot[_week-1]._results = jackpot;
506            _key = generatePermutationKey(jackpot);
507             uint32 _amounts = getAmountWeekly(_week);
508             total = SINGLE_BET_PRICE.mul(_amounts).mul(THISDAPP_DIV-INVITER_FEE).div(THISDAPP_DIV).mul(POOL_ALLOCATION_WEEK).div(THISDAPP_DIV);
509             win_amount = uint(betWeekly[_week-1]._entity[_key]);
510 
511             if(win_amount > 0){
512                 total = total.add(rollover);
513                 _bonus_sum = total.mul(POOL_ALLOCATION_JACKPOT).div(THISDAPP_DIV);
514                 rollover = total.sub(_bonus_sum);
515 
516                 poolUsed[_week-1] = _bonus_sum.mul(THISDAPP_DIV - ABC_GAS_CONSUME).div(THISDAPP_DIV).div(win_amount).mul(win_amount);
517                 _fee = _fee.add(_bonus_sum.sub(poolUsed[_week-1]));
518             }
519             else{
520                 rollover = rollover.add(total);
521             }
522         }
523         //end mark.-----------------------------------------------------------------------------------
524         drawed[currentRound-1] = true;
525         wallet.transfer(_fee);
526         emit OnDrawFinished(currentRound, jackpot);
527     }
528 
529      //+++++++++++++++++++++++++                  internal functions               +++++++++++++++++++++++++++++++++++++
530      /**
531      * @dev getAmountWeekly: the bet amount of a week.
532       */
533      function getAmountWeekly(uint32 week) internal view returns(uint32){
534          if(week == 0 || currentRound < (week-1)*7) return 0;
535 
536          uint32 _ret;
537          uint8 i;
538          if(currentRound > week*7){
539              for(i=0; i<7; i++){
540                  _ret += amounts[(week-1)*7+i];
541              }
542          }
543          else{
544              uint8 j = uint8((currentRound-1) % 7);
545              for(i=0;i<=j;i++){
546                  _ret += amounts[(week-1)*7+i];
547              }
548          }
549          return _ret;
550      }
551      /**
552      * @dev check if is a valid set of number.
553      * @param nums : chosen number.
554      */
555      function isValidNum(uint8[5] nums) internal pure returns(bool){
556          for(uint i = 0; i<5; i++){
557              if(nums[i] < MIN_BET_NUM || nums[i] > MAX_BET_NUM) 
558                 return false;
559          }
560          if(hasRepeat(nums)) return false;
561          
562          return true;
563     }
564     
565      /**
566      * @dev sort 5 numbers.
567      *      don't want to change input numbers sequence, so copy it at first.
568      * @param nums : input numbers.
569      */
570     function sort(uint8[5] nums) internal pure returns(uint8[5]){
571         uint8[5] memory _nums;
572         uint8 i;
573         for(i=0;i<5;i++)
574             _nums[i] = nums[i];
575             
576         uint8 j;
577         uint8 temp;
578         for(i =0; i<5-1; i++){
579             for(j=0; j<5-i-1;j++){
580                 if(_nums[j]>_nums[j+1]){
581                     temp = _nums[j];
582                     _nums[j] = _nums[j+1];
583                     _nums[j+1] = temp;
584                 }
585             }
586         }
587         return _nums;
588     }
589     
590     /**
591      * @dev does has repeat number?
592      * @param nums : input numbers.
593      */
594     function hasRepeat(uint8[5] nums) internal pure returns(bool){
595          uint8 i;
596          uint8 j;
597          for(i =0; i<5-1; i++){
598              for(j=i; j<5-1;j++){
599                  if(nums[i]==nums[j+1]) return true;
600              }
601          }
602         return false;       
603     }
604     
605     /**
606      * @dev generate Combination key, need sort at first.
607      */ 
608     function generateCombinationKey(uint8[5] nums) internal pure returns(bytes5){
609         uint8[5] memory temp = sort(nums);
610         bytes5 ret;
611         ret = (ret | byte(temp[4])) >> 8;
612         ret = (ret | byte(temp[3])) >> 8;
613         ret = (ret | byte(temp[2])) >> 8;
614         ret = (ret | byte(temp[1])) >> 8;
615         ret = ret | byte(temp[0]);
616         
617         return ret; 
618     }
619     
620     /**
621      * @dev generate Permutation key.
622      */ 
623     function generatePermutationKey(uint8[5] nums) internal pure returns(bytes5){
624         bytes5 ret;
625         ret = (ret | byte(nums[4])) >> 8;
626         ret = (ret | byte(nums[3])) >> 8;
627         ret = (ret | byte(nums[2])) >> 8;
628         ret = (ret | byte(nums[1])) >> 8;
629         ret = ret | byte(nums[0]);
630         
631         return ret;         
632     }
633 }
634 
635 /**
636  * @title SafeMath : it's from openzeppelin.
637  * @dev Math operations with safety checks that throw on error
638  */
639 library SafeMath {
640   /**
641   * @dev Multiplies two numbers, throws on overflow.
642   */
643   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
644     if (a == 0) {
645       return 0;
646     }
647     c = a * b;
648     assert(c / a == b);
649     return c;
650   }
651 
652   /**
653   * @dev Integer division of two numbers, truncating the quotient.
654   */
655   function div(uint256 a, uint256 b) internal pure returns (uint256) {
656     // assert(b > 0); // Solidity automatically throws when dividing by 0
657     // uint256 c = a / b;
658     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
659     return a / b;
660   }
661 
662   /**
663   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
664   */
665   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
666     assert(b <= a);
667     return a - b;
668   }
669 
670   /**
671   * @dev Subtracts two 32 bit numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
672   */
673   function sub_32(uint32 a, uint32 b) internal pure returns (uint32) {
674     assert(b <= a);
675     return a - b;
676   }
677 
678   /**
679   * @dev Adds two numbers, throws on overflow.
680   */
681   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
682     c = a + b;
683     assert(c >= a);
684     return c;
685   }
686 
687   /**
688   * @dev Adds two 32 bit numbers, throws on overflow.
689   */
690   function add_32(uint32 a, uint32 b) internal pure returns (uint32 c) {
691     c = a + b;
692     assert(c >= a);
693     return c;
694   }
695 }