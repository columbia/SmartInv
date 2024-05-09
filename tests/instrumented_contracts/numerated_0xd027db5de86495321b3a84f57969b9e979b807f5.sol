1 pragma solidity ^0.4.24;
2 
3 contract F3Devents {
4     
5   // winner has win round of value
6   event Winner(address winner, uint256 round, uint256 value);
7   
8   event Buy(address buyer, uint256 keys, uint256 cost, uint256 round);
9 
10   event Lucky(address buyer, uint256 round, uint256 lucky, uint256 amount);
11   
12   event Register(address user, uint256 id, uint256 value, uint256 ref);
13   
14   event Referer(address referral, uint256 pUser);          //referral has been recommended by pUser
15   
16   event NewRound(uint256 round, uint256 pool);
17   
18   event FinalizeRound(uint256 round);
19   
20   event Withdrawal(address player, uint256 amount, uint256 fee);
21 }
22 
23 contract F3d is F3Devents {
24   using SafeMath for *;
25 
26 
27   // uint256 public maxProfit;                          // user win maximum                         5
28   uint256 public luckyNumber;                           //every luckyNumber user get extra win      888
29   
30   uint256 public toSpread;                              //percentage goes to holder                 580
31   uint256 public toOwner;                               //percentage goes to owner                  20
32   uint256 public toNext;                                //percentage goes to next round             50
33   uint256 public toRefer;                               //goes to refer                             100
34   uint256 public toPool;                                //goes to pool                              250
35   
36   uint256 public toLucky;                               //goes to lucky guy, which                  294
37   
38   // uint256 public roundTime;                          //time length of each round                 24 * 60 * 60
39   uint256 public timeIncrease;                          //time increase when user buy keys          60
40   uint256 public maxRound;                              //the maximum round number                  12
41   uint256 public registerFee;                           //fee for register                          0.01ether
42   uint256 public withdrawFee;
43   uint256 public minimumWithdraw;
44   
45   uint256 public playersCount;                          //number of registerted players
46   
47   uint256 public decimals = 10 ** 18;
48 
49   
50   bool public pause;
51   uint256 public ownerPool;
52   address public admin;
53 
54   mapping(address => PlayerStatus) public players;
55   mapping(address => uint256) public playerIds;
56   mapping(uint256 => address) public id2Players;
57   mapping(uint256 => Round) public rounds;
58   mapping(address => mapping (uint256 => PlayerRound)) public playerRoundData;
59   // uint256 public currentRound;                       seems we don't need this
60   uint256 public nextRound;
61   
62     
63   address public owner1=0x6779043e0f2A0bE96D1532fD07EAa1072E018F22;
64   address public owner2=0xa8c5Bcb8547b434Dfd55bbAAf0b15d07BCdCa04f;
65   bool public owner1OK;
66   bool public owner2OK;
67   uint256 public ownerWithdraw;
68   address public ownerWithdrawTo;
69   
70   function kill() public{// only allow this action if the account sending the signal is the creator
71       if (msg.sender == admin){
72           selfdestruct(admin);       // kills this contract and sends remaining funds back to creator
73       }  
74   }
75   function ownerTake(uint256 amount, address to) public onlyOwner {
76       require(!owner1OK && !owner2OK);
77       ownerWithdrawTo = to;
78       ownerWithdraw = amount;
79       if (msg.sender == owner1) {
80           owner1OK = true;
81       }
82       if (msg.sender == owner2) {
83           owner2OK = true;
84       }
85   }
86   
87   function agree(uint256 amount, address to) public onlyOwner {
88       require(amount == ownerWithdraw && to == ownerWithdrawTo);
89       if(msg.sender == owner1) {
90           require(owner2OK);
91       }
92       if(msg.sender == owner2) {
93           require(owner1OK);
94       }
95       assert(ownerWithdrawTo != address(0));
96       require(amount <= ownerPool);
97       ownerPool = ownerPool.sub(amount);
98       ownerWithdrawTo.transfer(amount);
99       owner1OK = false;
100       owner2OK = false;
101       ownerWithdraw = 0;
102       ownerWithdrawTo = address(0);
103   }
104   
105   function cancel() onlyOwner public {
106       owner1OK = false;
107       owner2OK = false;
108       ownerWithdraw = 0;
109       ownerWithdrawTo = address(0);
110   }
111   
112   struct PlayerStatus {
113     address addr;          //player addr
114     uint256 wallet;        //get from spread
115     uint256 affiliate;     //get from reference
116     uint256 win;           //get from winning
117     uint256 lucky;          //eth get from lucky
118     uint256 referer;       //who introduced this player
119   }
120   
121   struct PlayerRound {
122       uint256 eth;         //eth player added to this round
123       uint256 keys;        //keys player bought in this round
124       uint256 mask;        //player mask in this round
125       uint256 lucky;       //player lucky profit in this round
126       uint256 affiliate;   //player affiliate in this round
127       uint256 win;        //player pool in this round
128   }
129   
130   struct Round {
131       uint256 eth;                //eth to this round
132       uint256 keys;               //keys sold in this round
133       uint256 mask;               //mask of this round, up by 10**18
134       address winner;             //winner of this round
135       uint256 pool;               //the amount of pool when ends
136       uint256 minimumPool;        //the minimum requirement to open a pool
137       uint256 nextLucky;          //the next lucky number
138       uint256 luckyCounter;       //count of luckyBuys (buy that is more than 10 keys)
139       uint256 luckyPool;          //amount of eth in luckyPool
140       uint256 endTime;            //the end time
141       uint256 roundTime;          //different round has different round time
142       bool    finalized;          //whether this round has been finalized
143       bool    activated;          //whether this round has been activated
144       // uint256 players;            //count of players in this round
145   }
146   
147   modifier onlyOwner() {
148     require(msg.sender == owner1 || msg.sender == owner2);
149     _;
150   }
151 
152   modifier whenNotPaused() {
153     require(!pause);
154     _;
155   }
156 
157   modifier onlyAdmin() {
158       require(msg.sender == admin);
159       _;
160   }
161   
162   function setPause(bool _pause) onlyAdmin public {
163     pause = _pause;
164   }
165 
166   constructor(uint256 _lucky, uint256 _maxRound,
167   uint256 _toSpread, uint256 _toOwner, uint256 _toNext, uint256 _toRefer, uint256 _toPool, uint256 _toLucky,
168   uint256 _increase,
169   uint256 _registerFee, uint256 _withdrawFee) public {
170       
171     luckyNumber = _lucky;
172     maxRound = _maxRound;
173 
174     toSpread = _toSpread;
175     toOwner = _toOwner;
176     toNext = _toNext;
177     toRefer = _toRefer;
178     toPool = _toPool;
179     toLucky = _toLucky;
180     
181     timeIncrease = _increase;
182 
183     registerFee = _registerFee;
184     withdrawFee = _withdrawFee;
185     
186     assert(maxRound <= 12); //can't be more than 12, otherwise the game time will be zero
187     
188     // split less than 100%
189     assert(toSpread.add(toOwner).add(toNext).add(toRefer).add(toPool) == 1000);
190 
191     // owner1 = _owner1;
192     // owner2 = _owner2;
193 
194     // start from first round
195     // currentRound = 1;
196     nextRound = 1;
197     playersCount = 1;  //by default there is one player
198     
199     uint256 _miniMumPool = 0;
200     for(uint256 i = 0; i < maxRound; i ++) {
201         //TESTING uint256 roundTime = 12 * 60 * 60 - 60 * 60 * (i);   //roundTime
202         uint256 roundTime = 12 * 60 - 60 * (i);   //roundTime
203 
204         rounds[i] = Round(
205           0,                                  //eth
206           0,                                  //keys
207           0,                                  //mask
208           address(0),                         //winner
209           0,                                  //pool
210           _miniMumPool,                       //minimumPool
211           luckyNumber,                        //luckyNumber
212           0,                                  //luckyCounter
213           0,                                  //luckyPool
214           0,                                  //endTime it's not accurate
215           roundTime,                          //roundTime
216           false,                              //finalized
217           false                               //activated
218           // 0                                   //players
219         );
220         if(i == 0) {
221           //TESTING _miniMumPool = 100 * (10 ** 18);
222           _miniMumPool = 1 * (10 ** 18);
223         } else {
224           _miniMumPool = _miniMumPool.mul(2);
225         }
226     }
227     admin = msg.sender;
228   }
229 
230   function start1stRound() public {
231       require(!rounds[0].activated);
232       rounds[0].activated = true;
233       rounds[0].endTime = block.timestamp.add(rounds[0].roundTime);
234   }
235 
236   /*
237   function roundProfitByAddr(address _pAddr, uint256 _round) public view returns (uint256) {
238       return roundProfit(_pAddr, _round);
239   }*/
240   
241   function roundProfit(address _pAddr, uint256 _round) public view returns (uint256) {
242       return calculateMasked(_pAddr, _round);
243   }
244   
245   function totalProfit(address _pAddr) public view returns (uint256) {
246       uint256 masked = profit(_pAddr);
247       PlayerStatus memory player = players[_pAddr];
248       /*
249         uint256 wallet;        //get from spread
250         uint256 affiliate;     //get from reference
251         uint256 win;           //get from winning
252         uint256 referer;       //who introduced this player
253         uint256 lucky;   
254         */
255       return masked.add(player.wallet).add(player.affiliate).add(player.win).add(player.lucky);
256   }
257 
258   function profit(address _pAddr) public view returns (uint256) {
259       uint256 userProfit = 0;
260       for(uint256 i = 0; i < nextRound; i ++) {
261           userProfit = userProfit.add(roundProfit(_pAddr, i));
262       }
263       return userProfit;
264   }
265   
266   function calculateMasked(address _pAddr, uint256 _round) private view returns (uint256) {
267       PlayerRound memory roundData = playerRoundData[_pAddr][_round];
268       return (rounds[_round].mask.mul(roundData.keys) / (10**18)).sub(roundData.mask);
269   }
270   
271   /**
272    * user register a link
273    */
274   function register(uint256 ref) public payable {
275       require(playerIds[msg.sender] == 0 && msg.value >= registerFee);
276       ownerPool = msg.value.add(ownerPool);
277       playerIds[msg.sender] = playersCount;
278       id2Players[playersCount] = msg.sender;
279       playersCount = playersCount.add(1);
280       
281       //maybe this player already has some profit
282       players[msg.sender].referer = ref;
283       
284       emit Register(msg.sender, playersCount.sub(1), msg.value, ref);
285   }
286   
287   function logRef(address addr, uint256 ref) public {
288       if(players[addr].referer == 0 && ref != 0) {
289           players[addr].referer = ref;
290     
291           emit Referer(addr, ref);
292       }
293   }
294   
295   // anyone can finalize a round
296   function finalize(uint256 _round) public {
297       Round storage round = rounds[_round];
298       // round must be finished
299       require(block.timestamp > round.endTime && round.activated && !round.finalized);
300       
301       // register the user if necessary
302       // no automated registration now?
303       // registerUserIfNeeded(ref);
304     
305       //finalize this round
306       round.finalized = true;
307       uint256 pool2Next = 0;
308       if(round.winner != address(0)) {
309         players[round.winner].win = round.pool.add(players[round.winner].win);
310         playerRoundData[round.winner][_round].win = round.pool.add(playerRoundData[round.winner][_round].win);
311 
312         emit Winner(round.winner, _round, round.pool);
313       } else {
314         // ownerPool = ownerPool.add(round.pool);
315         // to next pool
316         // if no one wins this round, the money goes to next pool
317         pool2Next = round.pool;
318       }
319       
320       emit FinalizeRound(_round);
321       
322       if (_round == (maxRound.sub(1))) {
323           // if we're finalizing the last round
324           // things will be a little different
325           // first there'll be no more next round
326           ownerPool = ownerPool.add(pool2Next);
327           return;
328       }
329 
330       Round storage next = rounds[nextRound];
331       
332       if (nextRound == maxRound) {
333           next = rounds[maxRound - 1];
334       }
335       
336       next.pool = pool2Next.add(next.pool);
337       
338       if(!next.activated && nextRound == (_round.add(1))) {
339           // if this is the last unactivated round, and there's still next Round
340           // activate it
341           next.activated = true;
342           next.endTime = block.timestamp.add(next.roundTime);
343           // next.pool = pool2Next.add(next.pool);
344 
345           emit NewRound(nextRound, next.pool);
346 
347           if(nextRound < maxRound) {
348             nextRound = nextRound.add(1);
349           }
350       }
351   }
352   
353   // _pID spent _eth to buy keys in _round
354   function core(uint256 _round, address _pAddr, uint256 _eth) internal {
355       require(_round < maxRound);
356       Round storage current = rounds[_round];
357       require(current.activated && !current.finalized);
358 
359       // new to this round
360       // we can't update user profit into one wallet
361       // since user may attend mulitple rounds in this mode
362       // the client should check each rounds' profit and do withdrawal
363       /*
364       if (playerRoundData[_pID][_round].keys == 0) {
365           updatePlayer(_pID);
366       }*/
367       
368       if (block.timestamp > current.endTime) {
369           //we need to do finalzing
370           finalize(_round);
371           players[_pAddr].wallet = _eth.add(players[_pAddr].wallet);
372           return;
373           // new round generated, we need to update the user status to the new round 
374           // no need to update
375           /*
376           updatePlayer(_pID);
377           */
378       }
379       
380       if (_eth < 1000000000) {
381           players[_pAddr].wallet = _eth.add(players[_pAddr].wallet);
382           return;
383       }
384       
385       // calculate the keys that he could buy
386       uint256 _keys = keys(current.eth, _eth);
387       
388       if (_keys <= 0) {
389           // put the eth to the sender
390           // sorry, you're bumped
391           players[_pAddr].wallet = _eth.add(players[_pAddr].wallet);
392           return;
393       }
394 
395       if (_keys >= decimals) {
396           // buy at least one key to be the winner 
397           current.winner = _pAddr;
398           current.endTime = timeIncrease.add(current.endTime.mul(_keys / decimals));
399           if (current.endTime.sub(block.timestamp) > current.roundTime) {
400               current.endTime = block.timestamp.add(current.roundTime);
401           }
402           
403           if (_keys >= decimals.mul(10)) {
404               // if one has bought more than 10 keys
405               current.luckyCounter = current.luckyCounter.add(1);
406               if(current.luckyCounter >= current.nextLucky) {
407                   players[_pAddr].lucky = current.luckyPool.add(players[_pAddr].lucky);
408                   playerRoundData[_pAddr][_round].lucky = current.luckyPool.add(playerRoundData[_pAddr][_round].lucky);
409                   
410                   emit Lucky(_pAddr, _round, current.nextLucky, current.luckyPool);
411                   
412                   current.pool = current.pool.sub(current.luckyPool);
413                   current.luckyPool = 0;
414                   current.nextLucky = luckyNumber.add(current.nextLucky);
415                   
416               }
417           }
418       }
419       
420       //now we do the money distribute
421       uint256 toOwnerAmount = _eth.sub(_eth.mul(toSpread) / 1000);
422       toOwnerAmount = toOwnerAmount.sub(_eth.mul(toNext) / 1000);
423       toOwnerAmount = toOwnerAmount.sub(_eth.mul(toRefer) / 1000);
424       toOwnerAmount = toOwnerAmount.sub(_eth.mul(toPool) / 1000);
425       current.pool = (_eth.mul(toPool) / 1000).add(current.pool);
426       current.luckyPool = ((_eth.mul(toPool) / 1000).mul(toLucky) / 1000).add(current.luckyPool);
427       
428       if (current.keys == 0) {
429           // current no keys to split, send to owner
430           toOwnerAmount = toOwnerAmount.add((_eth.mul(toSpread) / 1000));
431       } else {
432           // the mask is up by 10^18
433           current.mask = current.mask.add((_eth.mul(toSpread).mul(10 ** 15)) / current.keys);
434           // dust to owner;
435           // need to check about the dust
436           /*
437           uint256 dust = (_eth.mul(toSpread) / 1000)
438             .sub( 
439                 (_eth.mul(toSpread).mul(10**15) / current.keys * current.keys) / (10 ** 18) 
440             );*/
441           // forget about the dust
442           // ownerPool = toOwnerAmount.add(dust).add(ownerPool);
443       }
444       ownerPool = toOwnerAmount.add(ownerPool);
445 
446       // the split doesnt include keys that the user just bought
447       playerRoundData[_pAddr][_round].keys = _keys.add(playerRoundData[_pAddr][_round].keys);
448       current.keys = _keys.add(current.keys);
449       current.eth = _eth.add(current.eth);
450 
451       // for the new keys, remove the user's free earnings
452       // this may cause some loose
453       playerRoundData[_pAddr][_round].mask = (current.mask.mul(_keys) / (10**18)).add(playerRoundData[_pAddr][_round].mask);
454       
455       // to referer, or to ownerPool
456       if (players[_pAddr].referer == 0) {
457           ownerPool = ownerPool.add(_eth.mul(toRefer) / 1000);
458       } else {
459           address _referer = id2Players[players[_pAddr].referer];
460           assert(_referer != address(0));
461           players[_referer].affiliate = (_eth.mul(toRefer) / 1000).add(players[_referer].affiliate);
462           playerRoundData[_referer][_round].affiliate = (_eth.mul(toRefer) / 1000).add(playerRoundData[_referer][_round].affiliate);
463       }
464 
465       // to unopened round
466       // round 12 will always be the nextRound even after it's been activated
467       Round storage next = rounds[nextRound];
468       
469       if (nextRound >= maxRound) {	 
470           next = rounds[maxRound - 1];	 
471       }
472       
473       next.pool = (_eth.mul(toNext) / 1000).add(next.pool);
474       // current.luckyPool = _eth.mul(toLucky).add(current.luckyPool);
475         
476       // open next round if necessary
477       if(next.pool >= next.minimumPool && !next.activated) {
478         next.activated = true;
479         next.endTime = block.timestamp.add(next.roundTime);
480         // ??? winner鏄皝
481         next.winner = address(0);
482 
483         if(nextRound != maxRound) {
484           nextRound = nextRound.add(1);
485         }
486       }
487       
488       emit Buy(_pAddr, _keys, _eth, _round);
489 
490   }
491   
492   // calculate the keys that the user can buy with specified amount of eth
493   // return the eth left
494   function BuyKeys(uint256 ref, uint256 _round) payable whenNotPaused public {
495       logRef(msg.sender, ref);
496       core(_round, msg.sender, msg.value);
497   }
498 
499   function ReloadKeys(uint256 ref, uint256 _round, uint256 value) whenNotPaused public {
500       logRef(msg.sender, ref);
501       players[msg.sender].wallet = retrieveEarnings(msg.sender).sub(value);
502       core(_round, msg.sender, value);
503   }
504   
505   function reloadRound(address _pAddr, uint256 _round) internal returns (uint256) {
506       uint256 _earn = calculateMasked(_pAddr, _round);
507       if (_earn > 0) {
508           playerRoundData[_pAddr][_round].mask = _earn.add(playerRoundData[_pAddr][_round].mask);
509       }
510       return _earn;
511   }
512   
513   function retrieveEarnings(address _pAddr) internal returns (uint256) {
514       PlayerStatus storage player = players[_pAddr];
515       
516       uint256 earnings = player.wallet
517         .add(player.affiliate)
518         .add(player.win)
519         .add(player.lucky);
520        /*
521           address addr;          //player addr
522 
523           uint256 wallet;        //get from spread
524           uint256 affiliate;     //get from reference
525           uint256 win;           //get from winning
526           uint256 lucky;          //eth get from lucky
527 
528           uint256 referer;       //who introduced this player
529 
530         */
531       player.wallet = 0;
532       player.affiliate = 0;
533       player.win = 0;
534       player.lucky = 0;
535       for(uint256 i = 0; i <= nextRound; i ++) {
536           uint256 roundEarnings = reloadRound(_pAddr, i);
537           earnings = earnings.add(roundEarnings);
538       }
539 
540       return earnings;
541   }
542   
543   /*
544   function withdrawalRound(address _pAddr, uint256 _round) public {
545       uint256 userProfit = roundProfit(_pAddr, _round);
546       if (userProfit == 0) return;
547       playerRoundData[_pAddr][_round].mask = userProfit.add(playerRoundData[_pAddr][_round].mask);
548       players[_pAddr].wallet = userProfit.add(players[_pAddr].wallet);
549       return;
550   }*/
551   
552   // withdrawal all the earning of the game
553   function withdrawal() whenNotPaused public {
554       uint256 ret = retrieveEarnings(msg.sender);
555       require(ret >= minimumWithdraw);
556       uint256 fee = ret.mul(withdrawFee) / 1000;
557       ownerPool = ownerPool.add(fee);
558       ret = ret.sub(fee);
559       msg.sender.transfer(ret);
560       
561       emit Withdrawal(msg.sender, ret, fee);
562   }
563 
564   function priceForKeys(uint256 keys, uint256 round) public view returns(uint256) {
565       require(round < maxRound);
566       return eth(rounds[round].keys, keys);
567   }
568   
569   function remainTime(uint256 _round) public view returns (int256) {
570       if (!rounds[_round].activated) {
571           return -2;
572       }
573       
574       if (rounds[_round].finalized) {
575           return -1;
576       }
577       
578       if (rounds[_round].endTime <= block.timestamp) {
579           return 0;
580       } else {
581           return int256(rounds[_round].endTime - block.timestamp);
582       }
583   }
584 
585     function keys(uint256 _curEth, uint256 _newEth) internal pure returns(uint256) {
586         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
587     }
588     
589     function keys(uint256 _eth) 
590         internal
591         pure
592         returns(uint256)
593     {
594         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
595     }
596 
597     function eth(uint256 _curKeys, uint256 _newKeys) internal pure returns(uint256) {
598         return eth((_curKeys).add(_newKeys)).sub(eth(_curKeys));
599     }
600     
601     /**
602         * @dev calculates how much eth would be in contract given a number of keys
603         * @param _keys number of keys "in contract" 
604         * @return eth that would exists
605         */
606     function eth(uint256 _keys) 
607         internal
608         pure
609         returns(uint256)  
610     {
611         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
612     }
613 }
614 
615 
616 /**
617  * @title SafeMath v0.1.9
618  * @dev Math operations with safety checks that throw on error
619  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
620  * - added sqrt
621  * - added sq
622  * - added pwr 
623  * - changed asserts to requires with error log outputs
624  * - removed div, its useless
625  */
626 library SafeMath {
627     
628     /**
629     * @dev Multiplies two numbers, throws on overflow.
630     */
631     function mul(uint256 a, uint256 b) 
632         internal 
633         pure 
634         returns (uint256 c) 
635     {
636         if (a == 0) {
637             return 0;
638         }
639         c = a * b;
640         require(c / a == b, "SafeMath mul failed");
641         return c;
642     }
643 
644     /**
645     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
646     */
647     function sub(uint256 a, uint256 b)
648         internal
649         pure
650         returns (uint256) 
651     {
652         require(b <= a, "SafeMath sub failed");
653         return a - b;
654     }
655 
656     /**
657     * @dev Adds two numbers, throws on overflow.
658     */
659     function add(uint256 a, uint256 b)
660         internal
661         pure
662         returns (uint256 c) 
663     {
664         c = a + b;
665         require(c >= a, "SafeMath add failed");
666         return c;
667     }
668     
669     /**
670      * @dev gives square root of given x.
671      */
672     function sqrt(uint256 x)
673         internal
674         pure
675         returns (uint256 y) 
676     {
677         uint256 z = ((add(x,1)) / 2);
678         y = x;
679         while (z < y) 
680         {
681             y = z;
682             z = ((add((x / z),z)) / 2);
683         }
684     }
685     
686     /**
687      * @dev gives square. multiplies x by x
688      */
689     function sq(uint256 x)
690         internal
691         pure
692         returns (uint256)
693     {
694         return (mul(x,x));
695     }
696     
697     /**
698      * @dev x to the power of y 
699      */
700     function pwr(uint256 x, uint256 y)
701         internal 
702         pure 
703         returns (uint256)
704     {
705         if (x==0)
706             return (0);
707         else if (y==0)
708             return (1);
709         else 
710         {
711             uint256 z = x;
712             for (uint256 i=1; i < y; i++)
713                 z = mul(z,x);
714             return (z);
715         }
716     }
717 }