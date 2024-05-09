1 pragma solidity 0.4.19;
2 
3 contract Base {
4   function isContract(address _addr) constant internal returns(bool) {
5     uint size;
6     if (_addr == 0) return false;
7     assembly {
8         size := extcodesize(_addr)
9     }
10     return size > 0;
11   }
12 }
13 
14 //TODO change to interface if that ever gets added to the parser
15 contract RngRequester {
16   function acceptRandom(bytes32 id, bytes result);
17 }
18 
19 //TODO change to interface if that ever gets added to the parser
20 contract CryptoLuckRng {
21   function requestRandom(uint8 numberOfBytes) payable returns(bytes32);
22 
23   function getFee() returns(uint256);
24 }
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32     if (a == 0) {
33       return 0;
34     }
35     uint256 c = a * b;
36     assert(c / a == b);
37     return c;
38   }
39 
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return c;
45   }
46 
47   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48     assert(b <= a);
49     return a - b;
50   }
51 
52   function add(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a + b;
54     assert(c >= a);
55     return c;
56   }
57 }
58 
59 /**
60  * @title Ownable
61  * @dev The Ownable contract has an owner address, and provides basic authorization control
62  * functions, this simplifies the implementation of "user permissions".
63  */
64 contract Ownable {
65   address public owner;
66 
67 
68   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
69 
70 
71   /**
72    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
73    * account.
74    */
75   function Ownable() public {
76     owner = msg.sender;
77   }
78 
79 
80   /**
81    * @dev Throws if called by any account other than the owner.
82    */
83   modifier onlyOwner() {
84     require(msg.sender == owner);
85     _;
86   }
87 
88 
89   /**
90    * @dev Allows the current owner to transfer control of the contract to a newOwner.
91    * @param newOwner The address to transfer ownership to.
92    */
93   function transferOwnership(address newOwner) public onlyOwner {
94     require(newOwner != address(0));
95     OwnershipTransferred(owner, newOwner);
96     owner = newOwner;
97   }
98 
99 }
100 
101 contract StateQuickEth is Ownable {
102   //Certain parameters of the game can only be changed if the game is stopped.
103   //Rules shouldn't be changed while the game is going on :)
104   //
105   //This way, the owner can't e.g. lock up contributed funds or such, 
106   //by updating the game params to bad values, like minimum 1 million participants, etc.
107   modifier gameStopped {
108     require(!gameRunning);
109     
110     _;
111   }
112 
113   uint16 internal constant MANUAL_WITHDRAW_INTERVAL = 1 hours;
114   
115   bool public gameRunning;
116   
117   //Instead of being able to stop the game outright, the owner can only "schedule"
118   //for the game to stop at the end of the current round.
119   //Game stays locked until explicitly restarted.
120   bool public stopGameOnNextRound;
121 
122   //When someone sends ETH to the contract, what's the minimum gas the tx should have,
123   //so that it can execute the draw. 
124   uint32 public minGasForDrawing = 350000;
125   
126   //Ideally, we dont want the execution of a lottery to last too long, 
127   //so require a decent gas price when drawing. 6 GWEI
128   uint256 public minGasPriceForDrawing = 6000000000;
129 
130   //This reward should cover the gas cost for drawing.
131   //At the end of each lottery, the drawer will be refunded this amount 
132   //(0.002 eth to start with) - about 350k gas at 6 gwei price.
133   uint256 public rewardForDrawing = 2 finney;
134 
135   //House takes a 1% fee (10/1000). Can be updated when game is stopped.
136   //Value is divided by 1000 instead of 100, to be able to use fractional percentages e.g., 1.5%
137   uint8 public houseFee = 10;
138 
139   //Min and max contribution of this lottery.   
140   uint256 public minContribution = 20 finney;
141   uint256 public maxContribution = 1 ether;
142   
143   //Max bonus tickets for drawer.
144   uint256 public maxBonusTickets = 5;
145   
146   //Percentage of tickets purchased, awarded as bonus to the drawer.
147   uint8 public bonusTicketsPercentage = 1;
148   
149   //Minimum entries required to allow a draw to happen
150   uint16 public requiredEntries = 5;
151   
152   //Allow at least 60 minutes between draws, to have a minimally decent prize pool.
153   uint256 public requiredTimeBetweenDraws = 60 minutes;
154 
155   address public rngAddress;
156   ////////////////////////////////////////////////////////
157   //Owner methods
158 
159   //Game rules - can only be changed if the game is stopped.
160   function updateHouseFee(uint8 _value) public onlyOwner gameStopped {
161     houseFee = _value;
162   }
163 
164   function updateMinContribution(uint256 _value) public onlyOwner gameStopped {
165     minContribution = _value;
166   }
167 
168   function updateMaxContribution(uint256 _value) public onlyOwner gameStopped {
169     maxContribution = _value;
170   }
171 
172   function updateRequiredEntries(uint16 _value) public onlyOwner gameStopped {
173     requiredEntries = _value;
174   }
175 
176   function updateRequiredTimeBetweenDraws(uint256 _value) public onlyOwner gameStopped {
177     requiredTimeBetweenDraws = _value;
178   }
179   //END of Game rules
180   /////
181 
182   //Logistics
183   function updateMaxBonusTickets(uint256 _value) public onlyOwner {
184     maxBonusTickets = _value;
185   }
186 
187   function updateBonusTicketsPercentage(uint8 _value) public onlyOwner {
188     bonusTicketsPercentage = _value;
189   }
190 
191   function updateStopGameOnNextRound(bool _value) public onlyOwner {
192     stopGameOnNextRound = _value;
193   }
194 
195   function restartGame() public onlyOwner {
196     gameRunning = true;
197   }
198   
199   function updateMinGasForDrawing(uint32 newGasAmount) public onlyOwner {
200     minGasForDrawing = newGasAmount;
201   }
202 
203   function updateMinGasPriceForDrawing(uint32 newGasPrice) public onlyOwner {
204     minGasPriceForDrawing = newGasPrice;
205   }
206 
207   function updateRngAddress(address newAddress) public onlyOwner {
208     require(rngAddress != 0x0);
209     rngAddress = newAddress;
210   }
211 
212   function updateRewardForDrawing(uint256 newRewardForDrawing) public onlyOwner {
213     require(newRewardForDrawing > 0);
214 
215     rewardForDrawing = newRewardForDrawing;
216   }
217   //END Logistics
218 
219   //END owner methods  
220 }
221 
222 //
223 //-----------------------------
224 // <<<<Contract begins here>>>>
225 //-----------------------------
226 //
227 //* CryptoLuck Lottery Game 
228 //* Quick, ETH
229 //* Version: 1
230 //* Website: https://cryptoluck.fun
231 //*
232 contract CryptoLuckQuickEthV1 is RngRequester, StateQuickEth, Base {
233   using SafeMath for uint;
234 
235   modifier onlyRng {
236     require(msg.sender == rngAddress);
237     
238     _;
239   }
240 
241   event LogLotteryResult(
242     uint32 indexed lotteryId, 
243     uint8 status,
244     bytes32 indexed oraclizeId, 
245     bytes oraclizeResult
246   );
247   
248   struct Lottery {
249     uint256 prizePool;
250     uint256 totalContributions;
251     uint256 oraclizeFees;
252     
253     uint256 drawerBonusTickets;
254     
255     mapping (address => uint256) balances;
256     address[] participants;
257       
258     address winner;
259     address drawer;
260 
261     bytes32[] oraclizeIds;
262     bytes oraclizeResult;
263 
264     uint256 winningNumber;
265 
266     //0 => initial state, open
267     //1 => finalized with success
268     //2 => finalized with error (e.g. due to Oraclize not returning proper results etc)
269     uint8 status;
270 
271     bool awaitingOraclizeCallback;
272   }
273   
274   bool public useOraclize;
275   //Keep track of all lotteries. Stats ftw
276   uint32 public currentLotteryId = 0;
277   mapping (uint32 => Lottery) public lotteries;
278   
279   //1 finney == 0.001 ETH. Estimating for a run of ETH to 1000 USD, that's $1 per ticket.
280   uint256 public ticketPrice = 1 finney;
281   
282   //Timestamp to keep track of when the last draw happened
283   uint256 public lastDrawTs;
284   
285   uint256 public houseBalance = 0;
286   
287   function CryptoLuckQuickEthV1(address _rngAddress, bool _useOraclize) {
288     stopGameOnNextRound = false;
289     gameRunning = true;
290     
291     require(_rngAddress != 0x0);
292 
293     rngAddress = _rngAddress;
294     useOraclize = _useOraclize;
295     
296     //Initialize lottery draw to contract deploy time - 
297     //that's when we "start" the lottery.
298     lastDrawTs = block.timestamp;
299   }
300 
301   //Convenience method to return the current lottery
302   function currentLottery() view internal returns (Lottery storage) {
303     return lotteries[currentLotteryId];
304   }
305 
306   /////////////////
307   //Lottery flow:
308   //STEP 1: send ETH to enter lottery 
309   function () public payable {
310     // Disallow contracts - this avoids a whole host of issues, automations etc.
311     require(!isContract(msg.sender));
312     
313     // Disallow deposits if game is not running
314     require(gameRunning);
315     
316     // Require the sender to be able to purchase at least 1 ticket
317     require(msg.value >= ticketPrice);
318     
319     uint256 existingBalance = currentLottery().balances[msg.sender];
320     
321     //Total contribution should be at least the minimum contribution (0.05 ETH to start with)
322     require(msg.value + existingBalance >= minContribution);
323     //But their total contribution must not exceed max contribution
324     require(msg.value + existingBalance <= maxContribution);
325     
326     updatePlayerBalance(currentLotteryId);
327     
328     //If the requirements for a draw are met, and the gas price and gas limit are OK as well,
329     //execute the draw.
330     if (mustDraw() && gasRequirementsOk()) {
331       draw();
332     }
333   }
334 
335   //Ensure there's enough gas left (minGasForDrawing is an estimate)
336   //and that the gas price is enough to ensure it doesnt take an eternity to process the draw tx.
337   function gasRequirementsOk() view private returns(bool) {
338     return (msg.gas >= minGasForDrawing) && (tx.gasprice >= minGasPriceForDrawing);
339   }
340 
341   /////////////////
342   //STEP 2: store balance
343   //
344   //When someone sends Ether to this contract, we keep track of their total contribution.
345   function updatePlayerBalance(uint32 lotteryId) private returns(uint) {
346     Lottery storage lot = lotteries[lotteryId];
347     
348     //if current lottery is locked, since we made the call to Oraclize for the random number,
349     //but we haven't received the response yet, put the player's ether into the next lottery instead.
350     if (lot.awaitingOraclizeCallback) {
351       updatePlayerBalance(lotteryId + 1);
352       return;
353     }
354 
355     address participant = msg.sender;
356     
357     //If we dont have this participant in the balances mapping, 
358     //then it's a new address, so add it to the participants list, to keep track of the address.
359     if (lot.balances[participant] == 0) {
360       lot.participants.push(participant);
361     }
362     
363     //Increase the total contribution of this address (people can buy multiple times from the same address)
364     lot.balances[participant] = lot.balances[participant].add(msg.value);
365     //And the prize pool, of course.
366     lot.prizePool = lot.prizePool.add(msg.value);
367     
368     return lot.balances[participant];
369   }
370   
371   /////////////////
372   //STEP 3: when someone contributes to the lottery, check to see if we've met the requirements for a draw yet.
373   function mustDraw() view private returns (bool) {
374     Lottery memory lot = currentLottery();
375     
376     //At least 60 mins have elapsed since the last draw
377     bool timeDiffOk = now - lastDrawTs >= requiredTimeBetweenDraws;
378     
379     //We have at least 5 participants
380     bool minParticipantsOk = lot.participants.length >= requiredEntries;
381 
382     return minParticipantsOk && timeDiffOk;
383   }
384 
385   /////////////////
386   //STEP 4: If STEP 3 is a-ok, execute the draw, request a random number from our RNG provider.
387   //Flow will be resumed when the RNG provider contract receives the Oraclize callback, and in turn
388   //calls back into the lottery contract.
389   function draw() private {
390     Lottery storage lot = currentLottery();
391     
392     lot.awaitingOraclizeCallback = true;
393     
394     //Record total contributions for posterity and for correct calculation of the result,
395     //since the prize pool is used to pay for the Oraclize fees.
396     lot.totalContributions = lot.prizePool;
397 
398     //Track who was the drawer of the lottery, to be awarded the drawer bonuses: 
399     //extra ticket(s) and some ETH to cover the gas cost
400     lot.drawer = msg.sender;
401 
402     lastDrawTs = now;
403     
404     requestRandom();
405   }
406 
407   /////////////////
408   //STEP 5: Generate a random number between 0 and the sum of purchased tickets, using Oraclize random DS.
409   function requestRandom() private {
410     Lottery storage lot = currentLottery();
411     
412     CryptoLuckRng rngContract = CryptoLuckRng(rngAddress);
413     
414     //RNG provider returns the estimated Oraclize fee
415     uint fee = rngContract.getFee();
416     
417     //Pay oraclize query from the prize pool and keep track of all fees paid 
418     //(usually, only 1 fee, but can be more if the first call fails)
419     lot.prizePool = lot.prizePool.sub(fee);
420     lot.oraclizeFees = lot.oraclizeFees.add(fee);
421     
422     //Store the query ID so we can match it on callback, to ensure we are receiving a legit callback.
423     //Ask for a 7 bytes number. max is 72'057'594'037'927'936, should be ok :)
424     bytes32 oraclizeId = rngContract.requestRandom.value(fee)(7);
425     
426     lot.oraclizeIds.push(oraclizeId);
427   }
428 
429   /////////////////
430   //STEP 6: callback from the RNG provider - find the winner based on the generated random number
431   function acceptRandom(bytes32 reqId, bytes result) public onlyRng {
432     Lottery storage lot = currentLottery();
433     
434     //Verify the current lottery matches its oraclizeID with the supplied one, 
435     //if we use Oraclize on this network (true for non-dev ones)
436     if (useOraclize) {
437       require(currentOraclizeId() == reqId);
438     }
439     
440     //Store the raw result.
441     lot.oraclizeResult = result;
442 
443     //Award bonus tickets to the drawer.
444     uint256 bonusTickets = calculateBonusTickets(lot.totalContributions);
445 
446     lot.drawerBonusTickets = bonusTickets;
447 
448     //Compute total tickets in the draw, including the bonus ones.
449     uint256 totalTickets = bonusTickets + (lot.totalContributions / ticketPrice);
450     
451     //mod with totalTickets to get a number in [0..totalTickets - 1]
452     //add 1 to bring it in the range of [1, totalTickets], since we start our interval slices at 1 (see below)
453     lot.winningNumber = 1 + (uint(keccak256(result)) % totalTickets);
454 
455     findWinner();
456 
457     LogLotteryResult(currentLotteryId, 1, reqId, result);
458   }
459   
460   //STEP 6': Drawer receives bonus tickets, to cover the higher gas consumption and incentivize people to do so.
461   function calculateBonusTickets(uint256 totalContributions) view internal returns(uint256) {
462     
463     //1% of all contributions
464     uint256 bonusTickets = (totalContributions * bonusTicketsPercentage / 100) / ticketPrice;
465     
466     //bonus = between 1 to maxBonusTickets (initially, 5)
467     if (bonusTickets == 0) {
468        bonusTickets = 1;
469     }
470 
471     if (bonusTickets > maxBonusTickets) {
472       bonusTickets = maxBonusTickets;
473     }
474     
475     return bonusTickets;
476   }
477 
478   /////////////////
479   //STEP 7: determine winner by figuring out which address owns the interval 
480   // encompassing the generated random number and pay the winner.
481   function findWinner() private {
482     Lottery storage lot = currentLottery();
483     
484     uint256 currentLocation = 1;
485 
486     for (uint16 i = 0; i < lot.participants.length; i++) {
487       address participant = lot.participants[i];
488       
489       //A1 bought 70 tickets => head = 1 + 70 - 1 => owns [1, 70]; at the end of the loop, location ++
490       //A2 bought 90 tickets => head = 71 + 90 - 1 => owns [71, 160]; increment, etc
491       uint256 finalTickets = lot.balances[participant] / ticketPrice;
492       
493       //The drawer receives some bonus tickets, for the effort of having executed the lottery draw.
494       if (participant == lot.drawer) {
495         finalTickets += lot.drawerBonusTickets;
496       }
497 
498       currentLocation += finalTickets - 1; 
499       
500       if (currentLocation >= lot.winningNumber) {
501           lot.winner = participant;
502           break;
503       }
504       //move to the "start" of the next interval, for the next participant.
505       currentLocation += 1; 
506     }
507     
508     //Prize is all current balance on current lottery, minus the house fee and reward for drawing
509     uint256 prize = lot.prizePool;
510 
511     //Calculate house fee and track it. 
512     //House fee is integer per mille, e,g, 5 = 0.5%, thus, divide by 1000 to get the percentage
513     uint256 houseShare = houseFee * prize / 1000;
514     
515     houseBalance = houseBalance.add(houseShare);
516     
517     //deduct the house share and the reward for drawing from the prize pool.
518     prize = prize.sub(houseShare);
519     prize = prize.sub(rewardForDrawing);
520     
521     lot.status = 1;
522     lot.awaitingOraclizeCallback = false;
523     
524     lot.prizePool = prize;
525 
526     //Transfer the prize to the winner
527     lot.winner.transfer(prize);
528     
529     //Transfer the reward for drawing to the drawer.
530     //(should cover most of the gas paid for executing the draw)
531     lot.drawer.transfer(rewardForDrawing);
532 
533     finalizeLottery();
534   } 
535   
536   //END lottery flow
537   ////////////////////
538   
539   //Function which moves on to the next lottery and stops the next round if indicated
540   function finalizeLottery() private {
541     currentLotteryId += 1;
542 
543     if (stopGameOnNextRound) {
544       gameRunning = false;
545       stopGameOnNextRound = false;
546     }
547   }
548 
549   function currentOraclizeId() view private returns(bytes32) {
550     Lottery memory lot = currentLottery();
551     
552     return lot.oraclizeIds[lot.oraclizeIds.length - 1];
553   }
554 
555   //Allow players to withdraw their money in case the lottery fails.
556   //Can happen if the oraclize call fails 2 times
557   function withdrawFromFailedLottery(uint32 lotteryId) public {
558     address player = msg.sender;
559     
560     Lottery storage lot = lotteries[lotteryId];
561     
562     //can only withdraw from failed lotteries
563     require(lot.status == 2);
564     
565     //can withdraw contributed balance, minus the fees that have been paid to Oraclize, divided/supported among all participants
566     uint256 playerBalance = lot.balances[player].sub(lot.oraclizeFees / lot.participants.length);
567     //require to have something to send back
568     require(playerBalance > 0);
569 
570     //update the local balances
571     lot.balances[player] = 0;
572     lot.prizePool = lot.prizePool.sub(playerBalance);
573 
574     //send to player
575     player.transfer(playerBalance);
576   }
577 
578   /////////////////////////////////////////////////////////////////
579   //Public methods outside lottery flow
580   
581   //In case ETH is needed in the contract for whatever reason.
582   //Generally, the owner of the house will top up the contract, so increase the house balance.
583   //PS: If someone else tops up the house, thanks! :)
584   function houseTopUp() public payable {
585     houseBalance = houseBalance.add(msg.value);
586   }
587   
588   //Allow the owner to withdraw the house fees + house top ups.
589   function houseWithdraw() public onlyOwner {
590     owner.transfer(houseBalance);
591   }
592 
593   //In case the lottery gets stuck, oraclize doesnt call back etc., need a way to retry.
594   function manualDraw() public onlyOwner {
595     Lottery storage lot = currentLottery();
596     //Only for open lotteries
597     require(lot.status == 0);
598     
599     //Allow the owner to draw only when it would normally be allowed
600     require(mustDraw());
601     
602     //Also, ensure there's at least 1 hr since the call to oraclize has been made.
603     //If the result didnt come in 1 hour, then something is wrong with oraclize, so it's ok to try again.
604     require(now - lastDrawTs > MANUAL_WITHDRAW_INTERVAL);
605 
606     //If we try to draw manually but we already have 2 Oraclize requests logged, then we need to fail the lottery.
607     //then something is wrong with Oraclize - maybe down or someone at Oraclize trying to meddle with the results.
608     //As such, fail the lottery, move on to the next and allow people to withdraw their money from this one.
609     if (lot.oraclizeIds.length == 2) {
610       lot.status = 2;
611       lot.awaitingOraclizeCallback = false;
612       
613       LogLotteryResult(currentLotteryId, 2, lot.oraclizeIds[lot.oraclizeIds.length - 1], "");
614 
615       finalizeLottery();
616     } else {
617       draw();
618     }
619   }
620 
621   
622   ///////////
623 
624   //Helper methods.
625   function balanceInLottery(uint32 lotteryId, address player) view public returns(uint) {
626     return lotteries[lotteryId].balances[player];
627   }
628 
629   function participantsOf(uint32 lotteryId) view public returns (address[]) {
630     return lotteries[lotteryId].participants;
631   }
632 
633   function oraclizeIds(uint32 lotteryId) view public returns(bytes32[]) {
634     return lotteries[lotteryId].oraclizeIds;
635   }
636 }