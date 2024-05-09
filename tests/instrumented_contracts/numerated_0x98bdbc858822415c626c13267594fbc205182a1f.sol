1 pragma solidity ^0.4.24;
2 
3 interface MilAuthInterface {
4     function requiredSignatures() external view returns(uint256);
5     function requiredDevSignatures() external view returns(uint256);
6     function adminCount() external view returns(uint256);
7     function devCount() external view returns(uint256);
8     function adminName(address _who) external view returns(bytes32);
9     function isAdmin(address _who) external view returns(bool);
10     function isDev(address _who) external view returns(bool);
11     function checkGameRegiester(address _gameAddr) external view returns(bool);
12     function checkGameClosed(address _gameAddr) external view returns(bool);
13 }
14 interface MillionaireInterface {
15     function invest(address _addr, uint256 _affID, uint256 _mfCoin, uint256 _general) external payable;
16     function updateGenVaultAndMask(address _addr, uint256 _affID) external payable;
17     function clearGenVaultAndMask(address _addr, uint256 _affID, uint256 _eth, uint256 _milFee) external;
18     function assign(address _addr) external payable;
19     function splitPot() external payable;   
20 }
21 interface MilFoldInterface {
22     function addPot() external payable;
23     function activate() external;    
24 }
25 
26 contract Milevents {
27 
28     // fired whenever a player registers
29     event onNewPlayer
30     (
31         address indexed playerAddress,
32         uint256 playerID,
33         uint256 timeStamp
34     );
35 
36     // fired at end of buy or reload
37     event onEndTx
38     (
39         uint256 rid,                    //current round id
40         address indexed buyerAddress,   //buyer address
41         uint256 compressData,           //action << 96 | time << 64 | drawCode << 32 | txAction << 8 | roundState
42         uint256 eth,                    //buy amount
43         uint256 totalPot,               //current total pot
44         uint256 tickets,                //buy tickets
45         uint256 timeStamp               //buy time
46     );
47 
48     // fired at end of buy or reload
49     event onGameClose
50     (
51         address indexed gameAddr,       //game address
52         uint256 amount,                 //split eth amount
53         uint256 timeStamp               //close time
54     );
55 
56     // fired at time who satisfy the reward condition
57     event onReward
58     (
59         address indexed         rewardAddr,     //reward address
60         Mildatasets.RewardType  rewardType,     //rewardType
61         uint256 amount                          //reward amount
62     );
63 
64 	// fired whenever theres a withdraw
65     event onWithdraw
66     (
67         address indexed playerAddress,
68         uint256 ethOut,
69         uint256 timeStamp
70     );
71 
72     event onAffiliatePayout
73     (
74         address indexed affiliateAddress,
75         address indexed buyerAddress,
76         uint256 eth,
77         uint256 timeStamp
78     );
79 
80     // fired at every ico
81     event onICO
82     (
83         address indexed buyerAddress,   //user address who buy ico
84         uint256 buyAmount,              //buy ico amount
85         uint256 buyMf,                  //eth exchange mfcoin amount
86         uint256 totalIco,               //now total ico amount
87         bool    ended                   //is ico ended
88     );
89 
90     // fired whenever an player win the playround
91     event onPlayerWin(
92         address indexed addr,
93         uint256 roundID,
94         uint256 winAmount,
95         uint256 winNums
96     );
97 
98     event onClaimWinner(
99         address indexed addr,
100         uint256 winnerNum,
101         uint256 totalNum
102     );
103 
104     event onBuyMFCoins(
105         address indexed addr,
106         uint256 ethAmount,
107         uint256 mfAmount,
108         uint256 timeStamp
109     );
110 
111     event onSellMFCoins(
112         address indexed addr,
113         uint256 ethAmount,
114         uint256 mfAmount,
115         uint256 timeStamp
116     );
117 
118     event onUpdateGenVault(
119         address indexed addr,
120         uint256 mfAmount,
121         uint256 genAmount,
122         uint256 ethAmount
123     );
124 }
125 
126 contract Millionaire is MillionaireInterface,Milevents {
127     using SafeMath for *;
128     using MFCoinsCalc for uint256;
129 
130 //==============================================================================
131 //     _ _  _  |`. _     _ _ |_ | _  _  .
132 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
133 //=================_|===========================================================
134     string  constant private    name_ = "Millionaire Official";
135     uint256 constant private    icoRndMax_ = 2 weeks;        // ico max period
136     uint256 private             icoEndtime_;                    // ico end time
137     uint256 private             icoAmount_;                     // ico eth amount;
138     uint256 private             sequence_;                      // affiliate id sequence
139     bool    private             activated_;                     // mark contract is activated;
140     bool    private             icoEnd_;                        // is ico ended;
141 
142     MilFoldInterface     public          milFold_;                       // milFold contract
143     MilAuthInterface constant private milAuth_ = MilAuthInterface(0xf856f6a413f7756FfaF423aa2101b37E2B3aFFD9);
144 
145     uint256     public          globalMask_;                    // use to calc player gen
146     uint256     public          mfCoinPool_;                    // MFCoin Pool
147     uint256     public          totalSupply_;                   // MFCoin current supply
148 
149     address constant private fundAddr_ = 0xB0c7Dc00E8A74c9dEc8688EFb98CcB2e24584E3B; // foundation address
150     uint256 constant private REGISTER_FEE = 0.01 ether;         // register affiliate fees
151     uint256 constant private MAX_ICO_AMOUNT = 3000 ether;       // max tickets you can buy one time
152 
153     mapping(address => uint256) private balance_;               // player coin balance
154     mapping(uint256 => address) private plyrAddr_;             // (id => address) returns player id by address
155     mapping(address => Mildatasets.Player) private plyr_;      // (addr => data) player data
156 
157 //==============================================================================
158 //     _ _  _  _|. |`. _  _ _  .
159 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
160 //==============================================================================
161     /**
162      * @dev used to make sure no one can interact with contract until it has
163      * been activated.
164      */
165     modifier isActivated() {
166         require(activated_ == true, "its not ready start");
167         _;
168     }
169 
170     /**
171      * @dev prevents contracts from interacting with Millionare
172      */
173     modifier isHuman() {
174         address _addr = msg.sender;
175         uint256 _codeLength;
176 
177         assembly {_codeLength := extcodesize(_addr)}
178         require(_codeLength == 0, "sorry humans only");
179         _;
180     }
181 
182     /**
183      * @dev sets boundaries for incoming tx
184      */
185     modifier isWithinLimits(uint256 _eth) {
186         require(_eth >= 0.1 ether, "must > 0.1 ether");
187         _;
188     }
189 
190     /**
191      * @dev check sender must be devs
192      */
193     modifier onlyDevs()
194     {
195         require(milAuth_.isDev(msg.sender) == true, "msg sender is not a dev");
196         _;
197     }
198 
199     /**
200      * @dev default buy set to ico
201      */
202     function()
203         public
204         isActivated()
205         isHuman()
206         isWithinLimits(msg.value)
207         payable
208     {
209         icoCore(msg.value);
210     }
211 
212     /**
213      * @dev buy MFCoin use eth in ico phase
214      */
215     function buyICO()
216         public
217         isActivated()
218         isHuman()
219         isWithinLimits(msg.value)
220         payable
221     {
222         icoCore(msg.value);
223     }
224 
225     function icoCore(uint256 _eth) private {
226         if (icoEnd_) {
227             plyr_[msg.sender].eth = plyr_[msg.sender].eth.add(_eth);
228         } else {
229             if (block.timestamp > icoEndtime_ || icoAmount_ >= MAX_ICO_AMOUNT) {
230                 plyr_[msg.sender].eth = plyr_[msg.sender].eth.add(_eth);
231                 icoEnd_ = true;
232 
233                 milFold_.activate();
234                 emit onICO(msg.sender, 0, 0, MAX_ICO_AMOUNT, icoEnd_);
235             } else {
236                 uint256 ethAmount = _eth;
237                 if (ethAmount + icoAmount_ > MAX_ICO_AMOUNT) {
238                     ethAmount = MAX_ICO_AMOUNT.sub(icoAmount_);
239                     plyr_[msg.sender].eth = _eth.sub(ethAmount);
240                 }
241                 icoAmount_ = icoAmount_.add(ethAmount);
242 
243                 uint256 converts = ethAmount.mul(65)/100;
244                 uint256 pot = ethAmount.sub(converts);
245 
246                 //65% of your eth use to convert MFCoin
247                 uint256 buytMf = buyMFCoins(msg.sender, converts);
248 
249                 //35% of your eth use to pot
250                 milFold_.addPot.value(pot)();
251 
252                 if (icoAmount_ >= MAX_ICO_AMOUNT) {
253                     icoEnd_ = true;
254 
255                     milFold_.activate();
256                 }
257                 emit onICO(msg.sender, ethAmount, buytMf, icoAmount_, icoEnd_);
258             }
259         }
260     }
261 
262     /**
263      * @dev withdraw all you earnings to your address
264      */
265     function withdraw()
266         public
267         isActivated()
268         isHuman()
269     {
270         updateGenVault(msg.sender);
271         if (plyr_[msg.sender].eth > 0) {
272             uint256 amount = plyr_[msg.sender].eth;
273             plyr_[msg.sender].eth = 0;
274             msg.sender.transfer(amount);
275             emit onWithdraw(
276                 msg.sender,
277                 amount,
278                 block.timestamp
279             );
280         }
281     }
282 
283     /**
284      * @dev register as a affiliate
285      */
286     function registerAff()
287         public
288         isHuman()
289         payable
290     {
291         require (msg.value >= REGISTER_FEE, "register affiliate fees must >= 0.01 ether");
292         require (plyr_[msg.sender].playerID == 0, "you already register!");
293         plyrAddr_[++sequence_] = msg.sender;
294         plyr_[msg.sender].playerID = sequence_;
295         fundAddr_.transfer(msg.value);
296         emit onNewPlayer(msg.sender,sequence_, block.timestamp);
297     }
298 
299     function setMilFold(address _milFoldAddr)
300         public
301         onlyDevs
302     {
303         require(address(milFold_) == 0, "milFold has been set");
304         require(_milFoldAddr != 0, "milFold is invalid");
305 
306         milFold_ = MilFoldInterface(_milFoldAddr);
307     }
308 
309     function activate()
310         public
311         onlyDevs
312     {
313         require(address(milFold_) != 0, "milFold has not been set");
314         require(activated_ == false, "ICO already activated");
315 
316         // activate the ico
317         activated_ = true;
318         icoEndtime_ = block.timestamp + icoRndMax_;
319     }
320 
321     /**
322      * @dev external contracts interact with Millionare via investing MF Coin
323      * @param _addr player's address
324      * @param _affID affiliate ID
325      * @param _mfCoin eth amount to buy MF Coin
326      * @param _general eth amount assign to general
327      */
328     function invest(address _addr, uint256 _affID, uint256 _mfCoin, uint256 _general)
329         external
330         isActivated()
331         payable
332     {
333         require(milAuth_.checkGameRegiester(msg.sender), "game no register");
334         require(_mfCoin.add(_general) <= msg.value, "account is insufficient");
335 
336         if (msg.value > 0) {
337             uint256 tmpAffID = 0;
338             if (_affID == 0 || plyrAddr_[_affID] == _addr) {
339                 tmpAffID = plyr_[_addr].laff;
340             } else if (plyr_[_addr].laff == 0 && plyrAddr_[_affID] != address(0)) {
341                 plyr_[_addr].laff = _affID;
342                 tmpAffID = _affID;
343             }
344             
345             // if affiliate not exist, assign affiliate to general, i.e. set affiliate to zero
346             uint256 _affiliate = msg.value.sub(_mfCoin).sub(_general);
347             if (tmpAffID > 0 && _affiliate > 0) {
348                 address affAddr = plyrAddr_[tmpAffID];
349                 plyr_[affAddr].affTotal = plyr_[affAddr].affTotal.add(_affiliate);
350                 plyr_[affAddr].eth = plyr_[affAddr].eth.add(_affiliate);
351                 emit onAffiliatePayout(affAddr, _addr, _affiliate, block.timestamp);
352             }
353 
354             if (totalSupply_ > 0) {
355                 uint256 delta = _general.mul(1 ether).div(totalSupply_);
356                 globalMask_ = globalMask_.add(delta);
357             } else {
358                 //if nobody hold MFCoin,so nobody get general,it will give foundation
359                 fundAddr_.transfer(_general);
360             }
361 
362             updateGenVault(_addr);
363             
364             buyMFCoins(_addr, _mfCoin);
365 
366             emit onUpdateGenVault(_addr, balance_[_addr], plyr_[_addr].genTotal, plyr_[_addr].eth);
367         }
368     }
369 
370     /**
371      * @dev calculates unmasked earnings (just calculates, does not update mask)
372      * @return earnings in wei format
373      */
374     function calcUnMaskedEarnings(address _addr)
375         private
376         view
377         returns(uint256)
378     {
379         uint256 diffMask = globalMask_.sub(plyr_[_addr].mask);
380         if (diffMask > 0) {
381             return diffMask.mul(balance_[_addr]).div(1 ether);
382         }
383     }
384 
385     /**
386      * @dev updates masks for round and player when keys are bought
387      */
388     function updateGenVaultAndMask(address _addr, uint256 _affID)
389         external
390         payable
391     {
392         require(msg.sender == address(milFold_), "no authrity");
393 
394         if (msg.value > 0) {
395             /**
396              * 50/80 use to convert MFCoin
397              * 10/80 use to affiliate
398              * 20/80 use to general
399              */
400             uint256 converts = msg.value.mul(50).div(80);
401 
402             uint256 tmpAffID = 0;
403             if (_affID == 0 || plyrAddr_[_affID] == _addr) {
404                 tmpAffID = plyr_[_addr].laff;
405             } else if (plyr_[_addr].laff == 0 && plyrAddr_[_affID] != address(0)) {
406                 plyr_[_addr].laff = _affID;
407                 tmpAffID = _affID;
408             }
409             uint256 affAmount = 0;
410             if (tmpAffID > 0) {
411                 affAmount = msg.value.mul(10).div(80);
412                 address affAddr = plyrAddr_[tmpAffID];
413                 plyr_[affAddr].affTotal = plyr_[affAddr].affTotal.add(affAmount);
414                 plyr_[affAddr].eth = plyr_[affAddr].eth.add(affAmount);
415                 emit onAffiliatePayout(affAddr, _addr, affAmount, block.timestamp);
416             }
417             if (totalSupply_ > 0) {
418                 uint256 delta = msg.value.sub(converts).sub(affAmount).mul(1 ether).div(totalSupply_);
419                 globalMask_ = globalMask_.add(delta);
420             } else {
421                 //if nobody hold MFCoin,so nobody get general,it will give foundation
422                 fundAddr_.transfer(msg.value.sub(converts).sub(affAmount));
423             }
424             
425             updateGenVault(_addr);
426             
427             buyMFCoins(_addr, converts);
428 
429             emit onUpdateGenVault(_addr, balance_[_addr], plyr_[_addr].genTotal, plyr_[_addr].eth);
430         }
431     }
432 
433     /**
434      * @dev game contract has been paid 20% amount for Millionaire and paid back now
435      */
436     function clearGenVaultAndMask(address _addr, uint256 _affID, uint256 _eth, uint256 _milFee)
437         external
438     {
439         require(msg.sender == address(milFold_), "no authrity");
440 
441         //check player eth balance is enough pay for
442         uint256 _earnings = calcUnMaskedEarnings(_addr);
443         require(plyr_[_addr].eth.add(_earnings) >= _eth, "eth balance not enough");
444         
445         /**
446          * 50/80 use to convert MFCoin
447          * 10/80 use to affiliate
448          * 20/80 use to general
449          */
450         uint256 converts = _milFee.mul(50).div(80);
451         
452         uint256 tmpAffID = 0;
453         if (_affID == 0 || plyrAddr_[_affID] == _addr) {
454             tmpAffID = plyr_[_addr].laff;
455         } else if (plyr_[_addr].laff == 0 && plyrAddr_[_affID] != address(0)) {
456             plyr_[_addr].laff = _affID;
457             tmpAffID = _affID;
458         }
459         
460         uint256 affAmount = 0;
461         if (tmpAffID > 0) {
462             affAmount = _milFee.mul(10).div(80);
463             address affAddr = plyrAddr_[tmpAffID];
464             plyr_[affAddr].affTotal = plyr_[affAddr].affTotal.add(affAmount);
465             plyr_[affAddr].eth = plyr_[affAddr].eth.add(affAmount);
466 
467             emit onAffiliatePayout(affAddr, _addr, affAmount, block.timestamp);
468         }
469         if (totalSupply_ > 0) {
470             uint256 delta = _milFee.sub(converts).sub(affAmount).mul(1 ether).div(totalSupply_);
471             globalMask_ = globalMask_.add(delta);
472         } else {
473             //if nobody hold MFCoin,so nobody get general,it will give foundation
474             fundAddr_.transfer(_milFee.sub(converts).sub(affAmount));
475         }
476 
477         updateGenVault(_addr);
478         
479         buyMFCoins(_addr,converts);
480 
481         plyr_[_addr].eth = plyr_[_addr].eth.sub(_eth);
482         milFold_.addPot.value(_eth.sub(_milFee))();
483 
484         emit onUpdateGenVault(_addr, balance_[_addr], plyr_[_addr].genTotal, plyr_[_addr].eth);
485     }
486 
487 
488     /**
489      * @dev moves any unmasked earnings to gen vault.  updates earnings mask
490      */
491     function updateGenVault(address _addr) private
492     {
493         uint256 _earnings = calcUnMaskedEarnings(_addr);
494         if (_earnings > 0) {
495             plyr_[_addr].mask = globalMask_;
496             plyr_[_addr].genTotal = plyr_[_addr].genTotal.add(_earnings);
497             plyr_[_addr].eth = plyr_[_addr].eth.add(_earnings);
498         } else if (globalMask_ > plyr_[_addr].mask) {
499             plyr_[_addr].mask = globalMask_;
500         }
501         
502     }
503     
504     /**
505      * @dev convert eth to coin
506      * @param _addr user address
507      * @return return back coins
508      */
509     function buyMFCoins(address _addr, uint256 _eth) private returns(uint256) {
510         uint256 _coins = calcCoinsReceived(_eth);
511         mfCoinPool_ = mfCoinPool_.add(_eth);
512         totalSupply_ = totalSupply_.add(_coins);
513         balance_[_addr] = balance_[_addr].add(_coins);
514 
515         emit onBuyMFCoins(_addr, _eth, _coins, now);
516         return _coins;
517     }
518 
519     /**
520      * @dev sell coin to eth
521      * @param _coins sell coins
522      * @return return back eth
523      */
524     function sellMFCoins(uint256 _coins) public {
525         require(icoEnd_, "ico phase not end");
526         require(balance_[msg.sender] >= _coins, "coins amount is out of range");
527 
528         updateGenVault(msg.sender);
529         
530         uint256 _eth = totalSupply_.ethRec(_coins);
531         mfCoinPool_ = mfCoinPool_.sub(_eth);
532         totalSupply_ = totalSupply_.sub(_coins);
533         balance_[msg.sender] = balance_[msg.sender].sub(_coins);
534 
535         if (milAuth_.checkGameClosed(address(milFold_))) {
536             plyr_[msg.sender].eth = plyr_[msg.sender].eth.add(_eth);
537         } else {
538             /**
539              * 10/100 transfer to pot
540              * 90/100 transfer to owner
541              */
542             uint256 earnAmount = _eth.mul(90).div(100);
543             plyr_[msg.sender].eth = plyr_[msg.sender].eth.add(earnAmount);
544     
545             milFold_.addPot.value(_eth.sub(earnAmount))();
546         }
547         
548         emit onSellMFCoins(msg.sender, earnAmount, _coins, now);
549     }
550 
551     /**
552      * @dev anyone winner of milfold will call this function
553      * @param _addr winner address
554      */
555     function assign(address _addr)
556         external
557         payable
558     {
559         require(msg.sender == address(milFold_), "no authrity");
560 
561         plyr_[_addr].eth = plyr_[_addr].eth.add(msg.value);
562     }
563 
564     /**
565      * @dev If unfortunate the game has problem or has no winner at long time, we'll end the game and divide the pot equally among all MF users
566      */
567     function splitPot()
568         external
569         payable
570     {
571         require(milAuth_.checkGameClosed(msg.sender), "game has not been closed");
572         
573         uint256 delta = msg.value.mul(1 ether).div(totalSupply_);
574         globalMask_ = globalMask_.add(delta);
575         emit onGameClose(msg.sender, msg.value, now);
576     }
577 
578     /**
579      * @dev returns ico info
580      * @return ico end time
581      * @return already ico summary
582      * @return ico phase is end
583      */
584     function getIcoInfo()
585         public
586         view
587         returns(uint256, uint256, bool) {
588         return (icoAmount_, icoEndtime_, icoEnd_);
589     }
590 
591     /**
592      * @dev returns player info based on address
593      * @param _addr address of the player you want to lookup
594      * @return player ID
595      * @return player eth balance
596      * @return player MFCoin
597      * @return general vault
598      * @return affiliate vault
599      */
600     function getPlayerAccount(address _addr)
601         public
602         isActivated()
603         view
604         returns(uint256, uint256, uint256, uint256, uint256)
605     {
606         uint256 genAmount = calcUnMaskedEarnings(_addr);
607         return (
608             plyr_[_addr].playerID,
609             plyr_[_addr].eth.add(genAmount),
610             balance_[_addr],
611             plyr_[_addr].genTotal.add(genAmount),
612             plyr_[_addr].affTotal
613         );
614     }
615 
616     /**
617      * @dev give _eth can convert how much MFCoin
618      * @param _eth eth i will give
619      * @return MFCoin will return back
620      */
621     function calcCoinsReceived(uint256 _eth)
622         public
623         view
624         returns(uint256)
625     {
626         return mfCoinPool_.keysRec(_eth);
627     }
628 
629     /**
630      * @dev returns current eth price for X coins.
631      * @param _coins number of coins desired (in 18 decimal format)
632      * @return amount of eth needed to send
633      */
634     function calcEthReceived(uint256 _coins)
635         public
636         view
637         returns(uint256)
638     {
639         if (totalSupply_ < _coins) {
640             return 0;
641         }
642         return totalSupply_.ethRec(_coins);
643     }
644 
645     function getMFBalance(address _addr)
646         public
647         view
648         returns(uint256) {
649         return balance_[_addr];
650     }
651 
652 }
653 
654 //==============================================================================
655 //   __|_ _    __|_ _  .
656 //  _\ | | |_|(_ | _\  .
657 //==============================================================================
658 library Mildatasets {
659 
660     // between `DRAWN' and `ASSIGNED', someone need to claim winners.
661     enum RoundState {
662         UNKNOWN,        // aim to differ from normal states
663         STARTED,        // start current round
664         STOPPED,        // stop current round
665         DRAWN,          // draw code
666         ASSIGNED        // assign to foundation, winners, and migrate the rest to the next round
667     }
668 
669     // MilFold Transaction Action.
670     enum TxAction {
671         UNKNOWN,        // default
672         BUY,            // buy or reload tickets and so on 
673         DRAW,           // draw code of game 
674         ASSIGN,         // assign to winners
675         ENDROUND        // end game and start new round
676     }
677 
678     // RewardType
679     enum RewardType {
680         UNKNOWN,        // default
681         DRAW,           // draw code
682         ASSIGN,         // assign winner
683         END,            // end game
684         CLIAM           // winner cliam
685     }
686 
687     struct Player {
688         uint256 playerID;       // Player id(use to affiliate other player)
689         uint256 eth;            // player eth balance
690         uint256 mask;           // player mask
691         uint256 genTotal;       // general total vault
692         uint256 affTotal;       // affiliate total vault
693         uint256 laff;           // last affiliate id used
694     }
695 
696     struct Round {
697         uint256                         roundDeadline;      // deadline to end round
698         uint256                         claimDeadline;      // deadline to claim winners
699         uint256                         pot;                // pot
700         uint256                         blockNumber;        // draw block number(last one)
701         RoundState                      state;              // round state
702         uint256                         drawCode;           // draw code
703         uint256                         totalNum;           // total number
704         mapping (address => uint256)    winnerNum;          // winners' number
705         address[]                       winners;            // winners
706     }
707 
708 }
709 
710 /**
711  * @title SafeMath v0.1.9
712  * @dev Math operations with safety checks that throw on error
713  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
714  * - added sqrt
715  * - added sq
716  * - added pwr
717  * - changed asserts to requires with error log outputs
718  * - removed div, its useless
719  */
720 library SafeMath {
721 
722     /**
723     * @dev Multiplies two numbers, throws on overflow.
724     */
725     function mul(uint256 a, uint256 b)
726         internal
727         pure
728         returns (uint256 c)
729     {
730         if (a == 0) {
731             return 0;
732         }
733         c = a * b;
734         require(c / a == b, "SafeMath mul failed");
735         return c;
736     }
737 
738     /**
739     * @dev Integer division of two numbers, truncating the quotient.
740     */
741     function div(uint256 a, uint256 b) internal pure returns (uint256) {
742         // assert(b > 0); // Solidity automatically throws when dividing by 0
743         uint256 c = a / b;
744         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
745         return c;
746     }
747 
748     /**
749     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
750     */
751     function sub(uint256 a, uint256 b)
752         internal
753         pure
754         returns (uint256)
755     {
756         require(b <= a, "SafeMath sub failed");
757         return a - b;
758     }
759 
760     /**
761     * @dev Adds two numbers, throws on overflow.
762     */
763     function add(uint256 a, uint256 b)
764         internal
765         pure
766         returns (uint256 c)
767     {
768         c = a + b;
769         require(c >= a, "SafeMath add failed");
770         return c;
771     }
772 
773     /**
774      * @dev gives square root of given x.
775      */
776     function sqrt(uint256 x)
777         internal
778         pure
779         returns (uint256 y)
780     {
781         uint256 z = ((add(x,1)) / 2);
782         y = x;
783         while (z < y)
784         {
785             y = z;
786             z = ((add((x / z),z)) / 2);
787         }
788     }
789 
790     /**
791      * @dev gives square. multiplies x by x
792      */
793     function sq(uint256 x)
794         internal
795         pure
796         returns (uint256)
797     {
798         return (mul(x,x));
799     }
800 
801     /**
802      * @dev x to the power of y
803      */
804     function pwr(uint256 x, uint256 y)
805         internal
806         pure
807         returns (uint256)
808     {
809         if (x==0)
810             return (0);
811         else if (y==0)
812             return (1);
813         else
814         {
815             uint256 z = x;
816             for (uint256 i=1; i < y; i++)
817                 z = mul(z,x);
818             return (z);
819         }
820     }
821 
822     function min(uint x, uint y) internal pure returns (uint z) {
823         return x <= y ? x : y;
824     }
825 
826     function max(uint x, uint y) internal pure returns (uint z) {
827         return x >= y ? x : y;
828     }
829 }
830 
831 //==============================================================================
832 //  |  _      _ _ | _  .
833 //  |<(/_\/  (_(_||(_  .
834 //=======/======================================================================
835 library MFCoinsCalc {
836     using SafeMath for *;
837     /**
838      * @dev calculates number of keys received given X eth
839      * @param _curEth current amount of eth in contract
840      * @param _newEth eth being spent
841      * @return amount of ticket purchased
842      */
843     function keysRec(uint256 _curEth, uint256 _newEth)
844         internal
845         pure
846         returns (uint256)
847     {
848         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
849     }
850 
851     /**
852      * @dev calculates amount of eth received if you sold X keys
853      * @param _curKeys current amount of keys that exist
854      * @param _sellKeys amount of keys you wish to sell
855      * @return amount of eth received
856      */
857     function ethRec(uint256 _curKeys, uint256 _sellKeys)
858         internal
859         pure
860         returns (uint256)
861     {
862         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
863     }
864 
865     /**
866      * @dev calculates how many keys would exist with given an amount of eth
867      * @param _eth eth "in contract"
868      * @return number of keys that would exist
869      */
870     function keys(uint256 _eth)
871         internal
872         pure
873         returns(uint256)
874     {
875         return (((((_eth).mul(1000000000000000000).mul(2000000000000000000000000000)).add(39999800000250000000000000000000000000000000000000000000000000000)).sqrt()).sub(199999500000000000000000000000000)) / (1000000000);
876     }
877 
878     /**
879      * @dev calculates how much eth would be in contract given a number of keys
880      * @param _keys number of keys "in contract"
881      * @return eth that would exists
882      */
883     function eth(uint256 _keys)
884         internal
885         pure
886         returns(uint256)
887     {
888         return ((500000000).mul(_keys.sq()).add(((399999000000000).mul(_keys.mul(1000000000000000000))) / (2) )) / ((1000000000000000000).sq());
889     }
890 }