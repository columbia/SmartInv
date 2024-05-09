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
126 contract MilFold is MilFoldInterface,Milevents {
127     using SafeMath for *;
128 
129 //==============================================================================
130 //     _ _  _  |`. _     _ _ |_ | _  _  .
131 //    (_(_)| |~|~|(_||_|| (_||_)|(/__\  .  (game settings)
132 //=================_|===========================================================
133     uint256     constant private    rndMax_ = 90000;                                        // max length a round timer can be
134     uint256     constant private    claimMax_ = 43200;                                      // max limitation period to claim winned
135     address     constant private    fundAddr_ = 0xB0c7Dc00E8A74c9dEc8688EFb98CcB2e24584E3B; // foundation address
136     uint256     constant private    MIN_ETH_BUYIN = 0.002 ether;                            // min buy amount
137     uint256     constant private    COMMON_REWARD_AMOUNT = 0.01 ether;                      // reward who end round or draw the game
138     uint256     constant private    CLAIM_WINNER_REWARD_AMOUNT = 1 ether;                   // reward who claim an winner
139     uint256     constant private    MAX_WIN_AMOUNT = 5000 ether;                            // max win amount every round;
140 
141     uint256     private             rID_;                                                   // current round;
142     uint256     private             lID_;                                                   // last round;
143     uint256     private             lBlockNumber_;                                          // last round end block number;
144     bool        private             activated_;                                             // mark contract is activated;
145     
146     MillionaireInterface constant private millionaire_ = MillionaireInterface(0x98BDbc858822415C626c13267594fbC205182A1F);
147     MilAuthInterface constant private milAuth_ = MilAuthInterface(0xf856f6a413f7756FfaF423aa2101b37E2B3aFFD9);
148 
149     mapping (address => uint256) private playerTickets_;                                    // (addr => tickets) returns player tickets
150     mapping (uint256 => Mildatasets.Round) private round_;                                  // (rID => data) returns round data
151     mapping (uint256 => mapping(address => uint256[])) private playerTicketNumbers_;        // (rID => address => data) returns round data
152     mapping (address => uint256) private playerWinTotal_;                                   // (addr => eth) returns total winning eth
153 
154 //==============================================================================
155 //     _ _  _  _|. |`. _  _ _  .
156 //    | | |(_)(_||~|~|(/_| _\  .  (these are safety checks)
157 //==============================================================================
158     /**
159      * @dev used to make sure no one can interact with contract until it has
160      * been activated.
161      */
162     modifier isActivated() {
163         require(activated_ == true, "it's not ready yet");
164         _;
165     }
166 
167     /**
168      * @dev prevents contracts from interacting with milfold,except constructor
169      */
170     modifier isHuman() {
171         address _addr = msg.sender;
172         uint256 _codeLength;
173 
174         assembly {_codeLength := extcodesize(_addr)}
175         require(_codeLength == 0, "sorry humans only");
176         _;
177     }
178 
179     /**
180      * @dev sets boundaries for incoming tx
181      */
182     modifier isWithinLimits(uint256 _eth) {
183         require(_eth >= MIN_ETH_BUYIN, "can't be less anymore");
184         _;
185     }
186 
187     /**
188      * @dev check sender must be devs
189      */
190     modifier onlyDevs()
191     {
192         require(milAuth_.isDev(msg.sender) == true, "msg sender is not a dev");
193         _;
194     }
195 
196     /**
197      * @dev used to make sure the paid is sufficient to buy tickets.
198      * @param _eth the eth you want pay for
199      * @param _num the numbers you want to buy
200      */
201     modifier inSufficient(uint256 _eth, uint256[] _num) {
202         uint256 totalTickets = _num.length;
203         require(_eth >= totalTickets.mul(500)/1 ether, "insufficient to buy the very tickets");
204         _;
205     }
206 
207     /**
208      * @dev used to make sure the paid is sufficient to buy tickets.
209      * @param _eth the eth you want pay for
210      * @param _startNums the start numbers you want to buy
211      * @param _endNums the end numbers you want to to buy
212      */
213     modifier inSufficient2(uint256 _eth, uint256[] _startNums, uint256[] _endNums) {
214         uint256 totalTickets = calcSectionTickets(_startNums, _endNums);
215         require(_eth >= totalTickets.mul(500)/1 ether, "insufficient to buy the very tickets");
216         _;
217     }
218 
219     /**
220      * @dev deposit to contract
221      */
222     function() public isActivated() payable {
223         addPot();
224     }
225 
226     /**
227      * @dev buy tickets with pay eth
228      * @param _affID the id of the player who gets the affiliate fee
229      */
230     function buyTickets(uint256 _affID)
231         public
232         isActivated()
233         isHuman()
234         isWithinLimits(msg.value)
235         payable
236     {
237         uint256 compressData = checkRoundAndDraw(msg.sender);
238         buyCore(msg.sender, _affID, msg.value);
239 
240         emit onEndTx(
241             rID_,
242             msg.sender,
243             compressData,
244             msg.value,
245             round_[rID_].pot,
246             playerTickets_[msg.sender],
247             block.timestamp
248         );
249     }
250 
251     /**
252      * @dev direct buy nums with pay eth in express way
253      * @param _affID the id of the player who gets the affiliate fee
254      * @param _nums which nums you buy, less than 10
255      */
256     function expressBuyNums(uint256 _affID, uint256[] _nums)
257         public
258         isActivated()
259         isHuman()
260         isWithinLimits(msg.value)
261         inSufficient(msg.value, _nums)
262         payable
263     {
264         uint256 compressData = checkRoundAndDraw(msg.sender);
265         buyCore(msg.sender, _affID, msg.value);
266         convertCore(msg.sender, _nums.length, TicketCompressor.encode(_nums));
267 
268         emit onEndTx(
269             rID_,
270             msg.sender,
271             compressData,
272             msg.value,
273             round_[rID_].pot,
274             playerTickets_[msg.sender],
275             block.timestamp
276         );
277     }
278 
279     /**
280      * @dev direct buy section nums with pay eth in express way
281      * @param _affID the id of the player who gets the affiliate fee
282      * @param _startNums  section nums,start
283      * @param _endNums section nums,end
284      */
285     function expressBuyNumSec(uint256 _affID, uint256[] _startNums, uint256[] _endNums)
286         public
287         isActivated()
288         isHuman()
289         isWithinLimits(msg.value)
290         inSufficient2(msg.value, _startNums, _endNums)
291         payable
292     {
293         uint256 compressData = checkRoundAndDraw(msg.sender);
294         buyCore(msg.sender, _affID, msg.value);
295         convertCore(
296             msg.sender,
297             calcSectionTickets(_startNums, _endNums),
298             TicketCompressor.encode(_startNums, _endNums)
299         );
300 
301         emit onEndTx(
302             rID_,
303             msg.sender,
304             compressData,
305             msg.value,
306             round_[rID_].pot,
307             playerTickets_[msg.sender],
308             block.timestamp
309         );
310     }
311 
312     /**
313      * @dev buy tickets with use your vaults
314      * @param _affID the id of the player who gets the affiliate fee
315      * @param _eth the vaults you want pay for
316      */
317     function reloadTickets(uint256 _affID, uint256 _eth)
318         public
319         isActivated()
320         isHuman()
321         isWithinLimits(_eth)
322     {
323         uint256 compressData = checkRoundAndDraw(msg.sender);
324         reloadCore(msg.sender, _affID, _eth);
325 
326         emit onEndTx(
327             rID_,
328             msg.sender,
329             compressData,
330             _eth,
331             round_[rID_].pot,
332             playerTickets_[msg.sender],
333             block.timestamp
334         );
335     }
336 
337     /**
338      * @dev direct buy nums with use your vaults in express way
339      * @param _affID the id of the player who gets the affiliate fee
340      * @param _eth the vaults you want pay for
341      * @param _nums which nums you buy, no more than 10
342      */
343     function expressReloadNums(uint256 _affID, uint256 _eth, uint256[] _nums)
344         public
345         isActivated()
346         isHuman()
347         isWithinLimits(_eth)
348         inSufficient(_eth, _nums)
349     {
350         uint256 compressData = checkRoundAndDraw(msg.sender);
351         reloadCore(msg.sender, _affID, _eth);
352         convertCore(msg.sender, _nums.length, TicketCompressor.encode(_nums));
353 
354         emit onEndTx(
355             rID_,
356             msg.sender,
357             compressData,
358             _eth,
359             round_[rID_].pot,
360             playerTickets_[msg.sender],
361             block.timestamp
362         );
363     }
364 
365     /**
366      * @dev direct buy section nums with use your vaults in express way
367      * @param _affID the id of the player who gets the affiliate fee
368      * @param _eth the vaults you want pay for
369      * @param _startNums  section nums, start
370      * @param _endNums section nums, end
371      */
372     function expressReloadNumSec(uint256 _affID, uint256 _eth, uint256[] _startNums, uint256[] _endNums)
373         public
374         isActivated()
375         isHuman()
376         isWithinLimits(_eth)
377         inSufficient2(_eth, _startNums, _endNums)
378     {
379         uint256 compressData = checkRoundAndDraw(msg.sender);
380         reloadCore(msg.sender, _affID, _eth);
381         convertCore(msg.sender, calcSectionTickets(_startNums, _endNums), TicketCompressor.encode(_startNums, _endNums));
382 
383         emit onEndTx(
384             rID_,
385             msg.sender,
386             compressData,
387             _eth,
388             round_[rID_].pot,
389             playerTickets_[msg.sender],
390             block.timestamp
391         );
392     }
393 
394     /**
395      * @dev convert to nums with you consume tickets
396      * @param nums which nums you buy, no more than 10
397      */
398     function convertNums(uint256[] nums) public {
399         uint256 compressData = checkRoundAndDraw(msg.sender);
400         convertCore(msg.sender, nums.length, TicketCompressor.encode(nums));
401 
402         emit onEndTx(
403             rID_,
404             msg.sender,
405             compressData,
406             0,
407             round_[rID_].pot,
408             playerTickets_[msg.sender],
409             block.timestamp
410         );
411     }
412 
413     /**
414      * @dev convert to section nums with you consume tickets
415      * @param startNums  section nums, start
416      * @param endNums section nums, end
417      */
418     function convertNumSec(uint256[] startNums, uint256[] endNums) public {
419         uint256 compressData = checkRoundAndDraw(msg.sender);
420         convertCore(msg.sender, calcSectionTickets(startNums, endNums), TicketCompressor.encode(startNums, endNums));
421 
422         emit onEndTx(
423             rID_,
424             msg.sender,
425             compressData,
426             0,
427             round_[rID_].pot,
428             playerTickets_[msg.sender],
429             block.timestamp
430         );
431     }
432 
433     function buyCore(address _addr, uint256 _affID, uint256 _eth)
434         private
435     {
436         /**
437          * 2% transfer to foundation
438          * 18% transfer to pot
439          * 80% transfer to millionaire, 50% use to convert MFCoin and 30% use to genAndAff
440          */
441         // 1 ticket = 0.002 eth, i.e., tickets = eth * 500
442         playerTickets_[_addr] = playerTickets_[_addr].add(_eth.mul(500)/1 ether);
443 
444         // transfer 2% to foundation
445         uint256 foundFee = _eth.div(50);
446         fundAddr_.transfer(foundFee);
447 
448         // transfer 80%(50% use to convert MFCoin and 30% use to genAndAff) amount to millionaire
449         uint256 milFee = _eth.mul(80).div(100);
450 
451         millionaire_.updateGenVaultAndMask.value(milFee)(_addr, _affID);
452 
453         round_[rID_].pot = round_[rID_].pot.add(_eth.sub(milFee).sub(foundFee));
454     }
455 
456     function reloadCore(address _addr, uint256 _affID, uint256 _eth)
457         private
458     {
459         /**
460          * 2% transfer to foundation
461          * 18% transfer to pot
462          * 80% transfer to millionaire, 50% use to convert MFCoin and 30% use to genAndAff
463          */
464         // transfer 80%(50% use to convert MFCoin and 30% use to genAndAff) amount to millionaire
465         uint256 milFee = _eth.mul(80).div(100);
466         
467         millionaire_.clearGenVaultAndMask(_addr, _affID, _eth, milFee);
468 
469         // 1 ticket = 0.002 eth, i.e., tickets = eth * 500
470         playerTickets_[_addr] = playerTickets_[_addr].add(_eth.mul(500)/1 ether);
471 
472         // transfer 2% to foundation
473         uint256 foundFee = _eth.div(50);
474         fundAddr_.transfer(foundFee);
475         
476         //game pot will add in default function
477         //round_[rID_].pot = round_[rID_].pot.add(_eth.sub(milFee).sub(foundFee));
478     }
479 
480     function convertCore(address _addr, uint256 length, uint256 compressNumber)
481         private
482     {
483         playerTickets_[_addr] = playerTickets_[_addr].sub(length);
484         uint256[] storage plyTicNums = playerTicketNumbers_[rID_][_addr];
485         plyTicNums.push(compressNumber);
486     }
487 
488     // in order to draw the MilFold, we have to do all as following
489     // 1. end current round
490     // 2. calculate the draw-code
491     // 3. claim winned
492     // 4. assign to foundation, winners, and migrate the rest to the next round
493 
494     function checkRoundAndDraw(address _addr)
495         private
496         returns(uint256)
497     {
498         if (lID_ > 0
499             && round_[lID_].state == Mildatasets.RoundState.STOPPED
500             && (block.number.sub(lBlockNumber_) >= 7)) {
501             // calculate the draw-code
502             round_[lID_].drawCode = calcDrawCode();
503             round_[lID_].claimDeadline = now + claimMax_;
504             round_[lID_].state = Mildatasets.RoundState.DRAWN;
505             round_[lID_].blockNumber = block.number;
506             
507             round_[rID_].roundDeadline = now + rndMax_;
508             
509             if (round_[rID_].pot > COMMON_REWARD_AMOUNT) {
510                 round_[rID_].pot = round_[rID_].pot.sub(COMMON_REWARD_AMOUNT);
511                 //reward who Draw Code 0.01 ether
512                 _addr.transfer(COMMON_REWARD_AMOUNT);
513                 
514                 emit onReward(_addr, Mildatasets.RewardType.DRAW, COMMON_REWARD_AMOUNT);
515             }
516             return lID_ << 96 | round_[lID_].claimDeadline << 64 | round_[lID_].drawCode << 32 | uint256(Mildatasets.TxAction.DRAW) << 8 | uint256(Mildatasets.RoundState.DRAWN);
517         } else if (lID_ > 0
518             && round_[lID_].state == Mildatasets.RoundState.DRAWN
519             && now > round_[lID_].claimDeadline) {
520             // assign to foundation, winners, and migrate the rest to the next round
521             if (round_[lID_].totalNum > 0) {
522                 assignCore();
523             }
524             round_[lID_].state = Mildatasets.RoundState.ASSIGNED;
525             
526             if (round_[rID_].pot > COMMON_REWARD_AMOUNT) {
527                 round_[rID_].pot = round_[rID_].pot.sub(COMMON_REWARD_AMOUNT);
528                 //reward who Draw Code 0.01 ether
529                 _addr.transfer(COMMON_REWARD_AMOUNT);
530                 
531                 emit onReward(_addr, Mildatasets.RewardType.ASSIGN, COMMON_REWARD_AMOUNT);
532             }
533             return lID_ << 96 | uint256(Mildatasets.TxAction.ASSIGN) << 8 | uint256(Mildatasets.RoundState.ASSIGNED);
534         } else if ((rID_ == 1 || round_[lID_].state == Mildatasets.RoundState.ASSIGNED)
535             && now >= round_[rID_].roundDeadline) {
536             // end current round
537             lID_ = rID_;
538             lBlockNumber_ = block.number;
539             round_[lID_].state = Mildatasets.RoundState.STOPPED;
540 
541             rID_ = rID_ + 1;
542 
543             // migrate last round pot to this round util last round draw
544             round_[rID_].state = Mildatasets.RoundState.STARTED;
545             if (round_[lID_].pot > COMMON_REWARD_AMOUNT) {
546                 round_[rID_].pot = round_[lID_].pot.sub(COMMON_REWARD_AMOUNT);
547                 
548                 //reward who end round 0.01 ether
549                 _addr.transfer(COMMON_REWARD_AMOUNT);
550                 
551                 emit onReward(_addr, Mildatasets.RewardType.END, COMMON_REWARD_AMOUNT);
552             } else {
553                 round_[rID_].pot = round_[lID_].pot;
554             }
555             
556 
557             return rID_ << 96 | uint256(Mildatasets.TxAction.ENDROUND) << 8 | uint256(Mildatasets.RoundState.STARTED);
558         } 
559         return rID_ << 96 | uint256(Mildatasets.TxAction.BUY) << 8 | uint256(round_[rID_].state);
560     }
561 
562     /**
563      * @dev claim the winner identified by the given player's address
564      * @param _addr player's address
565      */
566     function claimWinner(address _addr)
567         public
568         isActivated()
569         isHuman()
570     {
571         require(lID_ > 0 && round_[lID_].state == Mildatasets.RoundState.DRAWN && now <= round_[lID_].claimDeadline, "it's not time for claiming");
572         require(round_[lID_].winnerNum[_addr] == 0, "the winner have been claimed already");
573 
574         uint winNum = 0;
575         uint256[] storage ptns = playerTicketNumbers_[lID_][_addr];
576         for (uint256 j = 0; j < ptns.length; j ++) {
577             (uint256 tType, uint256 tLength, uint256[] memory playCvtNums) = TicketCompressor.decode(ptns[j]);
578             for (uint256 k = 0; k < tLength; k ++) {
579                 if ((tType == 1 && playCvtNums[k] == round_[lID_].drawCode) ||
580                     (tType == 2 && round_[lID_].drawCode >= playCvtNums[2 * k] && round_[lID_].drawCode <= playCvtNums[2 * k + 1])) {
581                     winNum++;
582                 }
583             }
584         }
585         
586         if (winNum > 0) {
587             if (round_[lID_].winnerNum[_addr] == 0) {
588                 round_[lID_].winners.push(_addr);
589             }
590             round_[lID_].totalNum = round_[lID_].totalNum.add(winNum);
591             round_[lID_].winnerNum[_addr] = winNum;
592             
593             uint256 rewardAmount = CLAIM_WINNER_REWARD_AMOUNT.min(round_[lID_].pot.div(200)); //reward who claim winner ,min 1 ether,no more than 1% reward
594             
595             round_[rID_].pot = round_[rID_].pot.sub(rewardAmount);
596             // reward who claim an winner
597             msg.sender.transfer(rewardAmount);
598             emit onReward(msg.sender, Mildatasets.RewardType.CLIAM, COMMON_REWARD_AMOUNT);
599             
600             emit onClaimWinner(
601                 _addr,
602                 winNum,
603                 round_[lID_].totalNum
604             );
605         }
606     }
607 
608     function assignCore() private {
609         /**
610          * 2% transfer to foundation
611          * 48% transfer to next round
612          * 50% all winner share 50% pot on condition singal share no more than MAX_WIN_AMOUNT
613          */
614         uint256 lPot = round_[lID_].pot;
615         uint256 totalWinNum = round_[lID_].totalNum;
616         uint256 winShareAmount = (MAX_WIN_AMOUNT.mul(totalWinNum)).min(lPot.div(2));
617         uint256 foundFee = lPot.div(50);
618 
619         fundAddr_.transfer(foundFee);
620 
621         uint256 avgShare = winShareAmount / totalWinNum;
622         for (uint256 idx = 0; idx < round_[lID_].winners.length; idx ++) {
623             address addr = round_[lID_].winners[idx];
624             uint256 num = round_[lID_].winnerNum[round_[lID_].winners[idx]];
625             uint256 amount = round_[lID_].winnerNum[round_[lID_].winners[idx]].mul(avgShare);
626 
627             millionaire_.assign.value(amount)(addr);
628             playerWinTotal_[addr] = playerWinTotal_[addr].add(amount);
629 
630             emit onPlayerWin(addr, lID_, amount, num);
631         }
632 
633         round_[rID_].pot = round_[rID_].pot.sub(winShareAmount).sub(foundFee);
634     }
635 
636     function calcSectionTickets(uint256[] startNums, uint256[] endNums)
637         private
638         pure
639         returns(uint256)
640     {
641         require(startNums.length == endNums.length, "tickets length invalid");
642         uint256 totalTickets = 0;
643         uint256 tickets = 0;
644         for (uint256 i = 0; i < startNums.length; i ++) {
645             tickets = endNums[i].sub(startNums[i]).add(1);
646             totalTickets = totalTickets.add(tickets);
647         }
648         return totalTickets;
649     }
650 
651     function calcDrawCode() private view returns(uint256) {
652         return uint256(keccak256(abi.encodePacked(
653 
654             ((uint256(keccak256(abi.encodePacked(blockhash(block.number))))) / (block.timestamp)).add
655             ((uint256(keccak256(abi.encodePacked(blockhash(block.number - 1))))) / (block.timestamp)).add
656             ((uint256(keccak256(abi.encodePacked(blockhash(block.number - 2))))) / (block.timestamp)).add
657             ((uint256(keccak256(abi.encodePacked(blockhash(block.number - 3))))) / (block.timestamp)).add
658             ((uint256(keccak256(abi.encodePacked(blockhash(block.number - 4))))) / (block.timestamp)).add
659             ((uint256(keccak256(abi.encodePacked(blockhash(block.number - 5))))) / (block.timestamp)).add
660             ((uint256(keccak256(abi.encodePacked(blockhash(block.number - 6))))) / (block.timestamp))
661 
662         ))) % 10000000;
663 
664     }
665 
666     function activate() public {
667         // only millionaire can activate
668         require(msg.sender == address(millionaire_), "only contract millionaire can activate");
669 
670         // can only be ran once
671         require(activated_ == false, "MilFold already activated");
672 
673         // activate the contract
674         activated_ = true;
675 
676         // lets start first round
677         rID_ = 1;
678         round_[1].roundDeadline = now + rndMax_;
679         round_[1].state = Mildatasets.RoundState.STARTED;
680         // round_[0].pot refers to initial pot from ico phase
681         round_[1].pot = round_[0].pot;
682     }
683 
684     function addPot()
685         public
686         payable {
687         require(milAuth_.checkGameClosed(address(this)) == false, "game already closed");
688         require(msg.value > 0, "add pot failed");
689         round_[rID_].pot = round_[rID_].pot.add(msg.value);
690     }
691 
692     function close()
693         public
694         isActivated
695         onlyDevs {
696         require(milAuth_.checkGameClosed(address(this)), "game no closed");
697         activated_ = false;
698         millionaire_.splitPot.value(address(this).balance)();
699     }
700 
701     /**
702      * @dev return players's total winning eth
703      * @param _addr player's address
704      * @return player's total tickets
705      * @return player's total winning eth
706      */
707     function getPlayerAccount(address _addr)
708         public
709         view
710         returns(uint256, uint256)
711     {
712         return (playerTickets_[_addr], playerWinTotal_[_addr]);
713     }
714 
715     /**
716      * @dev return numbers in the round
717      * @param _rid round id
718      * @param _addr player's address
719      * @return player's numbers
720      */
721     function getPlayerRoundNums(uint256 _rid, address _addr)
722         public
723         view
724         returns(uint256[])
725     {
726         return playerTicketNumbers_[_rid][_addr];
727     }
728 
729     /**
730      * @dev return player's winning information in the round
731      * @return winning numbers
732      * @param _rid round id
733      * @param _addr player's address
734      */
735     function getPlayerRoundWinningInfo(uint256 _rid, address _addr)
736         public
737         view
738         returns(uint256)
739     {
740         Mildatasets.RoundState state = round_[_rid].state;
741         if (state >= Mildatasets.RoundState.UNKNOWN && state < Mildatasets.RoundState.DRAWN) {
742             return 0;
743         } else if (state == Mildatasets.RoundState.ASSIGNED) {
744             return round_[_rid].winnerNum[_addr];
745         } else {
746             // only drawn but not assigned, we need to query the player's winning numbers
747             uint256[] storage ptns = playerTicketNumbers_[_rid][_addr];
748             uint256 nums = 0;
749             for (uint256 j = 0; j < ptns.length; j ++) {
750                 (uint256 tType, uint256 tLength, uint256[] memory playCvtNums) = TicketCompressor.decode(ptns[j]);
751                 for (uint256 k = 0; k < tLength; k ++) {
752                     if ((tType == 1 && playCvtNums[k] == round_[_rid].drawCode) ||
753                         (tType == 2 && round_[_rid].drawCode >= playCvtNums[2 * k] && round_[lID_].drawCode <= playCvtNums[2 * k + 1])) {
754                         nums ++;
755                     }
756                 }
757             }
758 
759             return nums;
760         }
761     }
762 
763     /**
764      * @dev check player is claim in round
765      * @param _rid round id
766      * @param _addr player address
767      * @return true is claimed else false
768      */
769     function checkPlayerClaimed(uint256 _rid, address _addr)
770         public
771         view
772         returns(bool) {
773         return round_[_rid].winnerNum[_addr] > 0;
774     }
775 
776     /**
777      * @dev return current round information
778      * @return round id
779      * @return last round state
780      *      1. current round started
781      *      2. current round stopped(wait for drawing code)
782      *      3. drawn code(wait for claiming winners)
783      *      4. assigned to foundation, winners, and migrate the rest to the next round)
784      * @return round end time
785      * @return last round claiming time
786      * @return round pot
787      */
788     function getCurrentRoundInfo()
789         public
790         view
791         returns(uint256, uint256, uint256, uint256, uint256)
792     {
793         return (
794             rID_,
795             uint256(round_[lID_].state),
796             round_[rID_].roundDeadline,
797             round_[lID_].claimDeadline,
798             round_[rID_].pot
799         );
800     }
801 
802     /**
803      * @dev return history round information
804      * @param _rid round id
805      * @return items include as following
806      *  round state
807      *      1. current round started
808      *      2. current round stopped(wait for drawing code)
809      *      3. drawn code(wait for claiming winners)
810      *      4. assigned to foundation, winners, and migrate the rest to the next round)
811      *  round end time
812      *  winner claim end time
813      *  draw code
814      *  round pot
815      *  draw block number(last one)
816      * @return winners' address
817      * @return winning number
818      */
819     function getHistoryRoundInfo(uint256 _rid)
820         public
821         view
822         returns(uint256[], address[], uint256[])
823     {
824         uint256 length = round_[_rid].winners.length;
825         uint256[] memory numbers = new uint256[](length);
826         if (round_[_rid].winners.length > 0) {
827             for (uint256 idx = 0; idx < length; idx ++) {
828                 numbers[idx] = round_[_rid].winnerNum[round_[_rid].winners[idx]];
829             }
830         }
831 
832         uint256[] memory items = new uint256[](6);
833         items[0] = uint256(round_[_rid].state);
834         items[1] = round_[_rid].roundDeadline;
835         items[2] = round_[_rid].claimDeadline;
836         items[3] = round_[_rid].drawCode;
837         items[4] = round_[_rid].pot;
838         items[5] = round_[_rid].blockNumber;
839 
840         return (items, round_[_rid].winners, numbers);
841     }
842 
843 }
844 
845 //==============================================================================
846 //   __|_ _    __|_ _  .
847 //  _\ | | |_|(_ | _\  .
848 //==============================================================================
849 library Mildatasets {
850 
851     // between `DRAWN' and `ASSIGNED', someone need to claim winners.
852     enum RoundState {
853         UNKNOWN,        // aim to differ from normal states
854         STARTED,        // start current round
855         STOPPED,        // stop current round
856         DRAWN,          // draw code
857         ASSIGNED        // assign to foundation, winners, and migrate the rest to the next round
858     }
859 
860     // MilFold Transaction Action.
861     enum TxAction {
862         UNKNOWN,        // default
863         BUY,            // buy or reload tickets and so on 
864         DRAW,           // draw code of game 
865         ASSIGN,         // assign to winners
866         ENDROUND        // end game and start new round
867     }
868 
869     // RewardType
870     enum RewardType {
871         UNKNOWN,        // default
872         DRAW,           // draw code
873         ASSIGN,         // assign winner
874         END,            // end game
875         CLIAM           // winner cliam
876     }
877 
878     struct Player {
879         uint256 playerID;       // Player id(use to affiliate other player)
880         uint256 eth;            // player eth balance
881         uint256 mask;           // player mask
882         uint256 genTotal;       // general total vault
883         uint256 affTotal;       // affiliate total vault
884         uint256 laff;           // last affiliate id used
885     }
886 
887     struct Round {
888         uint256                         roundDeadline;      // deadline to end round
889         uint256                         claimDeadline;      // deadline to claim winners
890         uint256                         pot;                // pot
891         uint256                         blockNumber;        // draw block number(last one)
892         RoundState                      state;              // round state
893         uint256                         drawCode;           // draw code
894         uint256                         totalNum;           // total number
895         mapping (address => uint256)    winnerNum;          // winners' number
896         address[]                       winners;            // winners
897     }
898 
899 }
900 
901 /**
902  * @title SafeMath v0.1.9
903  * @dev Math operations with safety checks that throw on error
904  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
905  * - added sqrt
906  * - added sq
907  * - added pwr
908  * - changed asserts to requires with error log outputs
909  * - removed div, its useless
910  */
911 library SafeMath {
912 
913     /**
914     * @dev Multiplies two numbers, throws on overflow.
915     */
916     function mul(uint256 a, uint256 b)
917         internal
918         pure
919         returns (uint256 c)
920     {
921         if (a == 0) {
922             return 0;
923         }
924         c = a * b;
925         require(c / a == b, "SafeMath mul failed");
926         return c;
927     }
928 
929     /**
930     * @dev Integer division of two numbers, truncating the quotient.
931     */
932     function div(uint256 a, uint256 b) internal pure returns (uint256) {
933         // assert(b > 0); // Solidity automatically throws when dividing by 0
934         uint256 c = a / b;
935         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
936         return c;
937     }
938 
939     /**
940     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
941     */
942     function sub(uint256 a, uint256 b)
943         internal
944         pure
945         returns (uint256)
946     {
947         require(b <= a, "SafeMath sub failed");
948         return a - b;
949     }
950 
951     /**
952     * @dev Adds two numbers, throws on overflow.
953     */
954     function add(uint256 a, uint256 b)
955         internal
956         pure
957         returns (uint256 c)
958     {
959         c = a + b;
960         require(c >= a, "SafeMath add failed");
961         return c;
962     }
963 
964     /**
965      * @dev gives square root of given x.
966      */
967     function sqrt(uint256 x)
968         internal
969         pure
970         returns (uint256 y)
971     {
972         uint256 z = ((add(x,1)) / 2);
973         y = x;
974         while (z < y)
975         {
976             y = z;
977             z = ((add((x / z),z)) / 2);
978         }
979     }
980 
981     /**
982      * @dev gives square. multiplies x by x
983      */
984     function sq(uint256 x)
985         internal
986         pure
987         returns (uint256)
988     {
989         return (mul(x,x));
990     }
991 
992     /**
993      * @dev x to the power of y
994      */
995     function pwr(uint256 x, uint256 y)
996         internal
997         pure
998         returns (uint256)
999     {
1000         if (x==0)
1001             return (0);
1002         else if (y==0)
1003             return (1);
1004         else
1005         {
1006             uint256 z = x;
1007             for (uint256 i=1; i < y; i++)
1008                 z = mul(z,x);
1009             return (z);
1010         }
1011     }
1012 
1013     function min(uint x, uint y) internal pure returns (uint z) {
1014         return x <= y ? x : y;
1015     }
1016 
1017     function max(uint x, uint y) internal pure returns (uint z) {
1018         return x >= y ? x : y;
1019     }
1020 }
1021 
1022 library TicketCompressor {
1023 
1024     uint256 constant private mask = 16777215; //2 ** 24 - 1
1025 
1026     function encode(uint256[] tickets)
1027         internal
1028         pure
1029         returns(uint256)
1030     {
1031         require((tickets.length > 0) && (tickets.length <= 10), "tickets must > 0 and <= 10");
1032 
1033         uint256 value = tickets[0];
1034         for (uint256 i = 1 ; i < tickets.length ; i++) {
1035             require(tickets[i] < 10000000, "ticket number must < 10000000");
1036             value = value << 24 | tickets[i];
1037         }
1038         return 1 << 248 | tickets.length << 240 | value;
1039     }
1040 
1041     function encode(uint256[] startTickets, uint256[] endTickets)
1042         internal
1043         pure
1044         returns(uint256)
1045     {
1046         require(startTickets.length > 0 && startTickets.length == endTickets.length && startTickets.length <= 5, "section tickets must > 0 and <= 5");
1047 
1048         uint256 value = startTickets[0] << 24 | endTickets[0];
1049         for (uint256 i = 1 ; i < startTickets.length ; i++) {
1050             require(startTickets[i] <= endTickets[i] && endTickets[i] < 10000000, "tickets number invalid");
1051             value = value << 48 | startTickets[i] << 24 | endTickets[i];
1052         }
1053         return 2 << 248 | startTickets.length << 240 | value;
1054     }
1055 
1056     function decode(uint256 _input)
1057 	    internal
1058 	    pure
1059 	    returns(uint256,uint256,uint256[])
1060     {
1061         uint256 _type = _input >> 248;
1062         uint256 _length = _input >> 240 & 127;
1063         require(_type == 1 || _type == 2, "decode type is incorrect!");
1064 
1065 
1066         if (_type == 1) {
1067             uint256[] memory results = new uint256[](_length);
1068             uint256 tempVal = _input;
1069             for (uint256 i=0 ; i < _length ; i++) {
1070                 results[i] = tempVal & mask;
1071                 tempVal = tempVal >> 24;
1072             }
1073             return (_type,_length,results);
1074         } else {
1075             uint256[] memory result2 = new uint256[](_length * 2);
1076             uint256 tempVal2 = _input;
1077             for (uint256 j=0 ; j < _length ; j++) {
1078                 result2[2 * j + 1] = tempVal2 & mask;
1079                 tempVal2 = tempVal2 >> 24;
1080                 result2[2 * j] = tempVal2 & mask;
1081                 tempVal2 = tempVal2 >> 24;
1082             }
1083             return (_type,_length,result2);
1084         }
1085     }
1086 
1087 }