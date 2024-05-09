1 pragma solidity 0.5.6;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error.
6  * Code yanked from https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
7  */
8 library SafeMath {
9     /**
10      * @dev Multiplies two unsigned integers, reverts on overflow.
11      */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         uint256 c = a * b;
21         require(c / a == b);
22 
23         return c;
24     }
25 
26     /**
27      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
28      */
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         // Solidity only automatically asserts when dividing by 0
31         require(b > 0);
32         uint256 c = a / b;
33         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34 
35         return c;
36     }
37 
38     /**
39      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
40      */
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         require(b <= a);
43         uint256 c = a - b;
44 
45         return c;
46     }
47 
48     /**
49      * @dev Adds two unsigned integers, reverts on overflow.
50      */
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         require(c >= a);
54 
55         return c;
56     }
57 
58     /**
59      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
60      * reverts when dividing by zero.
61      */
62     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b != 0);
64         return a % b;
65     }
66 }
67 
68 contract ERC20Interface {
69     function totalSupply() public view returns (uint);
70     function balanceOf(address tokenOwner) public view returns (uint balance);
71     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
72     function transfer(address to, uint tokens) public returns (bool success);
73     function approve(address spender, uint tokens) public returns (bool success);
74     function transferFrom(address from, address to, uint tokens) public returns (bool success);
75 
76     uint8 public decimals;
77 
78     event Transfer(address indexed from, address indexed to, uint tokens);
79     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
80 }
81 
82 contract DAIHardFactory {
83     event NewTrade(uint id, address tradeAddress, bool indexed initiatorIsPayer);
84 
85     ERC20Interface public daiContract;
86     address payable public devFeeAddress;
87 
88     constructor(ERC20Interface _daiContract, address payable _devFeeAddress)
89     public {
90         daiContract = _daiContract;
91         devFeeAddress = _devFeeAddress;
92     }
93 
94     struct CreationInfo {
95         address address_;
96         uint blocknum;
97     }
98 
99     CreationInfo[] public createdTrades;
100 
101     function getBuyerDeposit(uint tradeAmount)
102     public
103     pure
104     returns (uint buyerDeposit) {
105         return tradeAmount / 3;
106     }
107 
108     function getDevFee(uint tradeAmount)
109     public
110     pure
111     returns (uint devFee) {
112         return tradeAmount / 100;
113     }
114 
115     function getExtraFees(uint tradeAmount)
116     public
117     pure
118     returns (uint buyerDeposit, uint devFee) {
119         return (getBuyerDeposit(tradeAmount), getDevFee(tradeAmount));
120     }
121 
122     /*
123     The Solidity compiler can't handle much stack depth,
124     so we have to pack some args together in annoying ways...
125     Hence the 'uintArgs'. Here is its layout:
126     0 - daiAmount
127     1 - pokeReward
128     2 - autorecallInterval
129     3 - autoabortInterval
130     4 - autoreleaseInterval
131     */
132 
133     function openDAIHardTrade(address payable _initiator, bool initiatorIsBuyer, uint[5] calldata uintArgs, string calldata _totalPrice, string calldata _fiatTransferMethods, string calldata _commPubkey)
134     external
135     returns (DAIHardTrade) {
136         uint transferAmount;
137         uint[6] memory newUintArgs; // Note that this structure is not the same as the above comment describes. See below in DAIHardTrade.open.
138 
139         if (initiatorIsBuyer) {
140             //transferAmount = getBuyerDeposit(uintArgs[0]) + uintArgs[1] + getDevFee(uintArgs[0]); (kept for legibility; SafeMath must be used)
141             transferAmount = SafeMath.add(SafeMath.add(getBuyerDeposit(uintArgs[0]), uintArgs[1]), getDevFee(uintArgs[0]));
142 
143             newUintArgs = [uintArgs[0], uintArgs[1], getDevFee(uintArgs[0]), uintArgs[2], uintArgs[3], uintArgs[4]];
144         }
145         else {
146             //transferAmount = uintArgs[0] + uintArgs[1] + getDevFee(uintArgs[0]);  (kept for legibility; SafeMath must be used)
147             transferAmount = SafeMath.add(SafeMath.add(uintArgs[0], uintArgs[1]), getDevFee(uintArgs[0]));
148 
149             newUintArgs = [getBuyerDeposit(uintArgs[0]), uintArgs[1], getDevFee(uintArgs[0]), uintArgs[2], uintArgs[3], uintArgs[4]];
150         }
151 
152         //create the new trade and add its creationInfo to createdTrades
153         DAIHardTrade newTrade = new DAIHardTrade(daiContract, devFeeAddress);
154         createdTrades.push(CreationInfo(address(newTrade), block.number));
155         emit NewTrade(createdTrades.length - 1, address(newTrade), initiatorIsBuyer);
156 
157         //transfer DAI to the trade and open it
158         require(daiContract.transferFrom(msg.sender, address(newTrade), transferAmount), "Token transfer failed. Did you call approve() on the DAI contract?");
159         newTrade.open(_initiator, initiatorIsBuyer, newUintArgs, _totalPrice, _fiatTransferMethods, _commPubkey);
160 
161         return newTrade;
162     }
163 
164     function getNumTrades()
165     external
166     view
167     returns (uint num) {
168         return createdTrades.length;
169     }
170 }
171 
172 contract DAIHardTrade {
173     enum Phase {Created, Open, Committed, Claimed, Closed}
174     Phase public phase;
175 
176     modifier inPhase(Phase p) {
177         require(phase == p, "inPhase check failed.");
178         _;
179     }
180 
181     enum ClosedReason {NotClosed, Recalled, Aborted, Released, Burned}
182     ClosedReason public closedReason;
183 
184     uint[5] public phaseStartTimestamps;
185     uint[5] public phaseStartBlocknums;
186 
187     function changePhase(Phase p)
188     internal {
189         phase = p;
190         phaseStartTimestamps[uint(p)] = block.timestamp;
191         phaseStartBlocknums[uint(p)] = block.number;
192     }
193 
194 
195     address payable public initiator;
196     address payable public responder;
197 
198     //The contract only has two parties, but depending on how it's opened,
199     //the initiator for example might be either the buyer OR the seller.
200 
201     bool public initiatorIsBuyer;
202     address payable public buyer;
203     address payable public seller;
204 
205     modifier onlyInitiator() {
206         require(msg.sender == initiator, "msg.sender is not Initiator.");
207         _;
208     }
209     modifier onlyResponder() {
210         require(msg.sender == responder, "msg.sender is not Responder.");
211         _;
212     }
213     modifier onlyBuyer() {
214         require (msg.sender == buyer, "msg.sender is not Buyer.");
215         _;
216     }
217     modifier onlySeller() {
218         require (msg.sender == seller, "msg.sender is not Seller.");
219         _;
220     }
221     modifier onlyContractParty() { // Must be one of the two parties involved in the contract
222         require(msg.sender == initiator || msg.sender == responder, "msg.sender is not a party in this contract.");
223         _;
224     }
225 
226     ERC20Interface daiContract;
227     address payable devFeeAddress;
228 
229     constructor(ERC20Interface _daiContract, address payable _devFeeAddress)
230     public {
231         changePhase(Phase.Created);
232         closedReason = ClosedReason.NotClosed;
233 
234         daiContract = _daiContract;
235         devFeeAddress = _devFeeAddress;
236 
237         pokeRewardSent = false;
238     }
239 
240     uint public daiAmount;
241     string public price;
242     uint public buyerDeposit;
243 
244     uint public responderDeposit; // This will be equal to either daiAmount or buyerDeposit, depending on initiatorIsBuyer
245 
246     uint public autorecallInterval;
247     uint public autoabortInterval;
248     uint public autoreleaseInterval;
249 
250     uint public pokeReward;
251     uint public devFee;
252 
253     bool public pokeRewardSent;
254 
255     /* ---------------------- CREATED PHASE -----------------------
256 
257     The only reason for this phase is so the Factory can have
258     somewhere to send the DAI before the Trade is initiated with
259     all the settings, and moved to the Open phase.
260 
261     The Factory creates the DAIHardTrade and moves it past this state
262     in a single call, so any DAIHardTrade made by the factory should
263     never be "seen" in this state.
264 
265     ------------------------------------------------------------ */
266 
267     event Opened(string fiatTransferMethods, string commPubkey);
268 
269     /*
270     uintArgs:
271     0 - responderDeposit
272     1 - pokeReward
273     2 - devFee
274     3 - autorecallInterval
275     4 - autoabortInterval
276     5 - autoreleaseInterval
277     */
278 
279     function open(address payable _initiator, bool _initiatorIsBuyer, uint[6] memory uintArgs, string memory _price, string memory fiatTransferMethods, string memory commPubkey)
280     public
281     inPhase(Phase.Created) {
282         require(getBalance() > 0, "You can't open a trade without first depositing DAI.");
283 
284         responderDeposit = uintArgs[0];
285         pokeReward = uintArgs[1];
286         devFee = uintArgs[2];
287 
288         autorecallInterval = uintArgs[3];
289         autoabortInterval = uintArgs[4];
290         autoreleaseInterval = uintArgs[5];
291 
292         initiator = _initiator;
293         initiatorIsBuyer = _initiatorIsBuyer;
294         if (initiatorIsBuyer) {
295             buyer = initiator;
296             daiAmount = responderDeposit;
297             buyerDeposit = SafeMath.sub(getBalance(), SafeMath.add(pokeReward, devFee));
298         }
299         else {
300             seller = initiator;
301             daiAmount = SafeMath.sub(getBalance(), SafeMath.add(pokeReward, devFee));
302             buyerDeposit = responderDeposit;
303         }
304 
305         price = _price;
306 
307         changePhase(Phase.Open);
308         emit Opened(fiatTransferMethods, commPubkey);
309     }
310 
311     /* ---------------------- OPEN PHASE --------------------------
312 
313     In the Open phase, the Initiator waits for a Responder.
314     We move to the Commited phase once someone becomes the Responder
315     by executing commit() and including msg.value = responderDeposit.
316 
317     At any time, the Initiator can cancel the whole thing by calling recall().
318 
319     After autorecallInterval has passed, the only state change allowed is to recall(),
320     which can be triggered by anyone via poke().
321 
322     ------------------------------------------------------------ */
323 
324     event Recalled();
325     event Committed(address responder, string commPubkey);
326 
327 
328     function recall()
329     external
330     inPhase(Phase.Open)
331     onlyInitiator() {
332        internalRecall();
333     }
334 
335     function internalRecall()
336     internal {
337         require(daiContract.transfer(initiator, getBalance()), "Recall of DAI to initiator failed!");
338 
339         changePhase(Phase.Closed);
340         closedReason = ClosedReason.Recalled;
341 
342         emit Recalled();
343     }
344 
345     function autorecallAvailable()
346     public
347     view
348     inPhase(Phase.Open)
349     returns(bool available) {
350         return (block.timestamp >= SafeMath.add(phaseStartTimestamps[uint(Phase.Open)], autorecallInterval));
351     }
352 
353     function commit(string calldata commPubkey)
354     external
355     inPhase(Phase.Open) {
356         require(daiContract.transferFrom(msg.sender, address(this), responderDeposit), "Can't transfer the required deposit from the DAI contract. Did you call approve first?");
357         require(!autorecallAvailable(), "autorecallInterval has passed; this offer has expired.");
358 
359         responder = msg.sender;
360 
361         if (initiatorIsBuyer) {
362             seller = responder;
363         }
364         else {
365             buyer = responder;
366         }
367 
368         changePhase(Phase.Committed);
369         emit Committed(responder, commPubkey);
370     }
371 
372     /* ---------------------- COMMITTED PHASE ---------------------
373 
374     In the Committed phase, the Buyer is expected to deposit fiat for the DAI,
375     then call claim().
376 
377     Otherwise, the Buyer can call abort(), which cancels the contract,
378     incurs a small penalty on both parties, and returns the remainder to each party.
379 
380     After autoabortInterval has passed, the only state change allowed is to abort(),
381     which can be triggered by anyone via poke().
382 
383     ------------------------------------------------------------ */
384 
385     event Claimed();
386     event Aborted();
387 
388     function abort()
389     external
390     inPhase(Phase.Committed)
391     onlyBuyer() {
392         internalAbort();
393     }
394 
395     function internalAbort()
396     internal {
397         //Punishment amount is 1/4 the buyerDeposit for now,
398         //but in a future version this might be set by the Initiator.
399         //At that point, this code should be checked for overflow concerns in the following require statement.
400         uint burnAmount = buyerDeposit / 4;
401 
402         //Punish both parties equally by burning burnAmount.
403         //Instead of burning burnAmount twice, just burn it all in one call (saves gas).
404         require(daiContract.transfer(address(0x0), burnAmount*2), "Token burn failed!");
405 
406         //Send back deposits minus burned amounts.
407         require(daiContract.transfer(buyer, SafeMath.sub(buyerDeposit, burnAmount)), "Token transfer to Buyer failed!");
408         require(daiContract.transfer(seller, SafeMath.sub(daiAmount, burnAmount)), "Token transfer to Seller failed!");
409 
410         uint sendBackToInitiator = devFee;
411         //If there was a pokeReward left, it should be sent back to the initiator
412         if (!pokeRewardSent) {
413             sendBackToInitiator = SafeMath.add(sendBackToInitiator, pokeReward);
414         }
415         
416         require(daiContract.transfer(initiator, sendBackToInitiator), "Token refund of devFee+pokeReward to Initiator failed!");
417         
418         //There may be a wei or two left over in the contract due to integer division. Not a big deal.
419 
420         changePhase(Phase.Closed);
421         closedReason = ClosedReason.Aborted;
422 
423         emit Aborted();
424     }
425 
426     function autoabortAvailable()
427     public
428     view
429     inPhase(Phase.Committed)
430     returns(bool passed) {
431         return (block.timestamp >= SafeMath.add(phaseStartTimestamps[uint(Phase.Committed)], autoabortInterval));
432     }
433 
434     function claim()
435     external
436     inPhase(Phase.Committed)
437     onlyBuyer() {
438         require(!autoabortAvailable(), "The deposit deadline has passed!");
439 
440         changePhase(Phase.Claimed);
441         emit Claimed();
442     }
443 
444     /* ---------------------- CLAIMED PHASE -----------------------
445 
446     In the Claimed phase, the Seller can call release() or burn(),
447     and is expected to call burn() only if the Buyer did not transfer
448     the amount of money described in totalPrice.
449 
450     After autoreleaseInterval has passed, the only state change allowed is to release,
451     which can be triggered by anyone via poke().
452 
453     ------------------------------------------------------------ */
454 
455     event Released();
456     event Burned();
457 
458     function release()
459     external
460     inPhase(Phase.Claimed)
461     onlySeller() {
462         internalRelease();
463     }
464 
465     function internalRelease()
466     internal {
467         //If the pokeReward has not been sent, refund it to the initiator
468         if (!pokeRewardSent) {
469             require(daiContract.transfer(initiator, pokeReward), "Refund of pokeReward to Initiator failed!");
470         }
471 
472         //Upon successful resolution of trade, the devFee is sent to the developers of DAIHard.
473         require(daiContract.transfer(devFeeAddress, devFee), "Token transfer to devFeeAddress failed!");
474 
475         //Release the remaining balance to the buyer.
476         require(daiContract.transfer(buyer, getBalance()), "Final release transfer to buyer failed!");
477 
478         changePhase(Phase.Closed);
479         closedReason = ClosedReason.Released;
480 
481         emit Released();
482     }
483 
484     function autoreleaseAvailable()
485     public
486     view
487     inPhase(Phase.Claimed)
488     returns(bool available) {
489         return (block.timestamp >= SafeMath.add(phaseStartTimestamps[uint(Phase.Claimed)], autoreleaseInterval));
490     }
491 
492     function burn()
493     external
494     inPhase(Phase.Claimed)
495     onlySeller() {
496         require(!autoreleaseAvailable());
497 
498         internalBurn();
499     }
500 
501     function internalBurn()
502     internal {
503         require(daiContract.transfer(address(0x0), getBalance()), "Final DAI burn failed!");
504 
505         changePhase(Phase.Closed);
506         closedReason = ClosedReason.Burned;
507 
508         emit Burned();
509     }
510 
511     /* ---------------------- OTHER METHODS ----------------------- */
512 
513     function getState()
514     external
515     view
516     returns(uint balance, Phase phase, uint phaseStartTimestamp, address responder, ClosedReason closedReason) {
517         return (getBalance(), this.phase(), phaseStartTimestamps[uint(this.phase())], this.responder(), this.closedReason());
518     }
519 
520     function getBalance()
521     public
522     view
523     returns(uint) {
524         return daiContract.balanceOf(address(this));
525     }
526 
527     function getParameters()
528     external
529     view
530     returns (address initiator, bool initiatorIsBuyer, uint daiAmount, string memory totalPrice, uint buyerDeposit, uint autorecallInterval, uint autoabortInterval, uint autoreleaseInterval, uint pokeReward)
531     {
532         return (this.initiator(), this.initiatorIsBuyer(), this.daiAmount(), this.price(), this.buyerDeposit(), this.autorecallInterval(), this.autoabortInterval(), this.autoreleaseInterval(), this.pokeReward());
533     }
534 
535     function getPhaseStartInfo()
536     external
537     view
538     returns (uint, uint, uint, uint, uint, uint, uint, uint, uint, uint)
539     {
540         return (phaseStartBlocknums[0], phaseStartBlocknums[1], phaseStartBlocknums[2], phaseStartBlocknums[3], phaseStartBlocknums[4], phaseStartTimestamps[0], phaseStartTimestamps[1], phaseStartTimestamps[2], phaseStartTimestamps[3], phaseStartTimestamps[4]);
541     }
542 
543     // Poke function lets anyone move the contract along,
544     // if it's due for some state transition.
545 
546     event Poke();
547 
548     function pokeNeeded()
549     public
550     view
551     returns (bool needed) {
552         return (  (phase == Phase.Open      && autorecallAvailable() )
553                || (phase == Phase.Committed && autoabortAvailable()  )
554                || (phase == Phase.Claimed   && autoreleaseAvailable())
555                );
556     }
557 
558     function poke()
559     external 
560     returns (bool moved) {
561         if (pokeNeeded()) {
562             daiContract.transfer(msg.sender, pokeReward);
563             pokeRewardSent = true;
564             emit Poke();
565         }
566         else return false;
567 
568         if (phase == Phase.Open) {
569             if (autorecallAvailable()) {
570                 internalRecall();
571                 return true;
572             }
573         }
574         else if (phase == Phase.Committed) {
575             if (autoabortAvailable()) {
576                 internalAbort();
577                 return true;
578             }
579         }
580         else if (phase == Phase.Claimed) {
581             if (autoreleaseAvailable()) {
582                 internalRelease();
583                 return true;
584             }
585         }
586     }
587 
588     // StatementLogs allow a starting point for any necessary communication,
589     // and can be used anytime by either party after a Responder commits (even in the Closed phase).
590 
591 
592     event InitiatorStatementLog(string encryptedForInitiator, string encryptedForResponder);
593     event ResponderStatementLog(string encryptedForInitiator, string encryptedForResponder);
594 
595     function initiatorStatement(string memory encryptedForInitiator, string memory encryptedForResponder)
596     public
597     onlyInitiator() {
598         require(phase >= Phase.Committed);
599         emit InitiatorStatementLog(encryptedForInitiator, encryptedForResponder);
600     }
601 
602     function responderStatement(string memory encryptedForInitiator, string memory encryptedForResponder)
603     public
604     onlyResponder() {
605         require(phase >= Phase.Committed);
606         emit ResponderStatementLog(encryptedForInitiator, encryptedForResponder);
607     }
608 }