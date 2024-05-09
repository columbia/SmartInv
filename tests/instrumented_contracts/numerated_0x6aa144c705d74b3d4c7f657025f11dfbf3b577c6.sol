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
160     }
161 
162     function getNumTrades()
163     external
164     view
165     returns (uint num) {
166         return createdTrades.length;
167     }
168 }
169 
170 contract DAIHardTrade {
171     enum Phase {Created, Open, Committed, Claimed, Closed}
172     Phase public phase;
173 
174     modifier inPhase(Phase p) {
175         require(phase == p, "inPhase check failed.");
176         _;
177     }
178 
179     uint[5] public phaseStartTimestamps;
180 
181     function changePhase(Phase p)
182     internal {
183         phase = p;
184         phaseStartTimestamps[uint(p)] = block.timestamp;
185     }
186 
187 
188     address payable public initiator;
189     address payable public responder;
190 
191     //The contract only has two parties, but depending on how it's opened,
192     //the initiator for example might be either the buyer OR the seller.
193 
194     bool public initiatorIsBuyer;
195     address payable public buyer;
196     address payable public seller;
197 
198     modifier onlyInitiator() {
199         require(msg.sender == initiator, "msg.sender is not Initiator.");
200         _;
201     }
202     modifier onlyResponder() {
203         require(msg.sender == responder, "msg.sender is not Responder.");
204         _;
205     }
206     modifier onlyBuyer() {
207         require (msg.sender == buyer, "msg.sender is not Buyer.");
208         _;
209     }
210     modifier onlySeller() {
211         require (msg.sender == seller, "msg.sender is not Seller.");
212         _;
213     }
214     modifier onlyContractParty() { // Must be one of the two parties involved in the contract
215         require(msg.sender == initiator || msg.sender == responder, "msg.sender is not a party in this contract.");
216         _;
217     }
218 
219     ERC20Interface daiContract;
220     address payable devFeeAddress;
221 
222     constructor(ERC20Interface _daiContract, address payable _devFeeAddress)
223     public {
224         changePhase(Phase.Created);
225 
226         daiContract = _daiContract;
227         devFeeAddress = _devFeeAddress;
228 
229         pokeRewardSent = false;
230     }
231 
232     uint public daiAmount;
233     string public price;
234     uint public buyerDeposit;
235 
236     uint public responderDeposit; // This will be equal to either daiAmount or buyerDeposit, depending on initiatorIsBuyer
237 
238     uint public autorecallInterval;
239     uint public autoabortInterval;
240     uint public autoreleaseInterval;
241 
242     uint public pokeReward;
243     uint public devFee;
244 
245     bool public pokeRewardSent;
246 
247     /*
248     uintArgs:
249     0 - responderDeposit
250     1 - pokeReward
251     2 - devFee
252     3 - autorecallInterval
253     4 - autoabortInterval
254     5 - autoreleaseInterval
255     */
256 
257     event Opened(string fiatTransferMethods, string commPubkey);
258 
259     function open(address payable _initiator, bool _initiatorIsBuyer, uint[6] memory uintArgs, string memory _price, string memory fiatTransferMethods, string memory commPubkey)
260     public
261     inPhase(Phase.Created) {
262         require(getBalance() > 0, "You can't open a trade without first depositing DAI.");
263 
264         responderDeposit = uintArgs[0];
265         pokeReward = uintArgs[1];
266         devFee = uintArgs[2];
267 
268         autorecallInterval = uintArgs[3];
269         autoabortInterval = uintArgs[4];
270         autoreleaseInterval = uintArgs[5];
271 
272         initiator = _initiator;
273         initiatorIsBuyer = _initiatorIsBuyer;
274         if (initiatorIsBuyer) {
275             buyer = initiator;
276             daiAmount = responderDeposit;
277             buyerDeposit = SafeMath.sub(getBalance(), SafeMath.add(pokeReward, devFee));
278         }
279         else {
280             seller = initiator;
281             daiAmount = SafeMath.sub(getBalance(), SafeMath.add(pokeReward, devFee));
282             buyerDeposit = responderDeposit;
283         }
284 
285         price = _price;
286 
287         changePhase(Phase.Open);
288         emit Opened(fiatTransferMethods, commPubkey);
289     }
290 
291     /* ---------------------- OPEN PHASE --------------------------
292 
293     In the Open phase, the Initiator waits for a Responder.
294     We move to the Commited phase once someone becomes the Responder
295     by executing commit() and including msg.value = responderDeposit.
296 
297     At any time, the Initiator can cancel the whole thing by calling recall().
298 
299     After autorecallInterval has passed, the only state change allowed is to recall(),
300     which can be triggered by anyone via poke().
301 
302     ------------------------------------------------------------ */
303 
304     event Recalled();
305     event Committed(address responder, string commPubkey);
306 
307 
308     function recall()
309     external
310     inPhase(Phase.Open)
311     onlyInitiator() {
312        internalRecall();
313     }
314 
315     function internalRecall()
316     internal {
317         require(daiContract.transfer(initiator, getBalance()), "Recall of DAI to initiator failed!");
318 
319         changePhase(Phase.Closed);
320         emit Recalled();
321     }
322 
323     function autorecallAvailable()
324     public
325     view
326     inPhase(Phase.Open)
327     returns(bool available) {
328         return (block.timestamp >= SafeMath.add(phaseStartTimestamps[uint(Phase.Open)], autorecallInterval));
329     }
330 
331     function commit(string calldata commPubkey)
332     external
333     inPhase(Phase.Open) {
334         require(daiContract.transferFrom(msg.sender, address(this), responderDeposit), "Can't transfer the required deposit from the DAI contract. Did you call approve first?");
335         require(!autorecallAvailable(), "autorecallInterval has passed; this offer has expired.");
336 
337         responder = msg.sender;
338 
339         if (initiatorIsBuyer) {
340             seller = responder;
341         }
342         else {
343             buyer = responder;
344         }
345 
346         changePhase(Phase.Committed);
347         emit Committed(responder, commPubkey);
348     }
349 
350     /* ---------------------- COMMITTED PHASE ---------------------
351 
352     In the Committed phase, the Buyer is expected to deposit fiat for the DAI,
353     then call claim().
354 
355     Otherwise, the Buyer can call abort(), which cancels the contract,
356     incurs a small penalty on both parties, and returns the remainder to each party.
357 
358     After autoabortInterval has passed, the only state change allowed is to abort(),
359     which can be triggered by anyone via poke().
360 
361     ------------------------------------------------------------ */
362 
363     event Claimed();
364     event Aborted();
365 
366     function abort()
367     external
368     inPhase(Phase.Committed)
369     onlyBuyer() {
370         internalAbort();
371     }
372 
373     function internalAbort()
374     internal {
375         //Punishment amount is 1/4 the buyerDeposit for now,
376         //but in a future version this might be set by the Initiator.
377         uint burnAmount = buyerDeposit / 4;
378 
379         //Punish both parties equally by burning burnAmount.
380         //Instead of burning burnAmount twice, just burn it all in one call (saves gas).
381         require(daiContract.transfer(address(0x0), burnAmount*2), "Token burn failed!");
382 
383         //Send back deposits minus burned amounts.
384         require(daiContract.transfer(buyer, SafeMath.sub(buyerDeposit, burnAmount)), "Token transfer to Buyer failed!");
385         require(daiContract.transfer(seller, SafeMath.sub(daiAmount, burnAmount)), "Token transfer to Seller failed!");
386 
387         uint sendBackToInitiator = devFee;
388         //If there was a pokeReward left, it should be sent back to the initiator
389         if (!pokeRewardSent) {
390             sendBackToInitiator = SafeMath.add(sendBackToInitiator, pokeReward);
391         }
392         
393         require(daiContract.transfer(initiator, sendBackToInitiator), "Token refund of devFee+pokeReward to Initiator failed!");
394         
395         //There may be a wei or two left over in the contract due to integer division. Not a big deal.
396 
397         changePhase(Phase.Closed);
398         emit Aborted();
399     }
400 
401     function autoabortAvailable()
402     public
403     view
404     inPhase(Phase.Committed)
405     returns(bool passed) {
406         return (block.timestamp >= SafeMath.add(phaseStartTimestamps[uint(Phase.Committed)], autoabortInterval));
407     }
408 
409     function claim()
410     external
411     inPhase(Phase.Committed)
412     onlyBuyer() {
413         require(!autoabortAvailable(), "The deposit deadline has passed!");
414 
415         changePhase(Phase.Claimed);
416         emit Claimed();
417     }
418 
419     /* ---------------------- CLAIMED PHASE -----------------------
420 
421     In the Claimed phase, the Seller can call release() or burn(),
422     and is expected to call burn() only if the Buyer did not transfer
423     the amount of money described in totalPrice.
424 
425     After autoreleaseInterval has passed, the only state change allowed is to release,
426     which can be triggered by anyone via poke().
427 
428     ------------------------------------------------------------ */
429 
430     event Released();
431     event Burned();
432 
433     function autoreleaseAvailable()
434     public
435     view
436     inPhase(Phase.Claimed)
437     returns(bool available) {
438         return (block.timestamp >= SafeMath.add(phaseStartTimestamps[uint(Phase.Claimed)], autoreleaseInterval));
439     }
440 
441     function release()
442     external
443     inPhase(Phase.Claimed)
444     onlySeller() {
445         internalRelease();
446     }
447 
448     function internalRelease()
449     internal {
450         //If the pokeReward has not been sent, refund it to the initiator
451         if (!pokeRewardSent) {
452             require(daiContract.transfer(initiator, pokeReward), "Refund of pokeReward to Initiator failed!");
453         }
454 
455         //Upon successful resolution of trade, the devFee is sent to the developers of DAIHard.
456         require(daiContract.transfer(devFeeAddress, devFee), "Token transfer to devFeeAddress failed!");
457 
458         //Release the remaining balance to the buyer.
459         require(daiContract.transfer(buyer, getBalance()), "Final release transfer to buyer failed!");
460 
461         changePhase(Phase.Closed);
462         emit Released();
463     }
464 
465     function burn()
466     external
467     inPhase(Phase.Claimed)
468     onlySeller() {
469         require(!autoreleaseAvailable());
470 
471         internalBurn();
472     }
473 
474     function internalBurn()
475     internal {
476         require(daiContract.transfer(address(0x0), getBalance()), "Final DAI burn failed!");
477 
478         changePhase(Phase.Closed);
479         emit Burned();
480     }
481 
482     /* ---------------------- OTHER METHODS ----------------------- */
483 
484     function getState()
485     external
486     view
487     returns(uint balance, Phase phase, uint phaseStartTimestamp, address responder) {
488         return (getBalance(), this.phase(), phaseStartTimestamps[uint(this.phase())], this.responder());
489     }
490 
491     function getBalance()
492     public
493     view
494     returns(uint) {
495         return daiContract.balanceOf(address(this));
496     }
497 
498     function getParameters()
499     external
500     view
501     returns (address initiator, bool initiatorIsBuyer, uint daiAmount, string memory totalPrice, uint buyerDeposit, uint autorecallInterval, uint autoabortInterval, uint autoreleaseInterval, uint pokeReward)
502     {
503         return (this.initiator(), this.initiatorIsBuyer(), this.daiAmount(), this.price(), this.buyerDeposit(), this.autorecallInterval(), this.autoabortInterval(), this.autoreleaseInterval(), this.pokeReward());
504     }
505 
506     // Poke function lets anyone move the contract along,
507     // if it's due for some state transition.
508 
509     event Poke();
510 
511     function pokeNeeded()
512     public
513     view
514     returns (bool needed) {
515         return (  (phase == Phase.Open      && autorecallAvailable() )
516                || (phase == Phase.Committed && autoabortAvailable()  )
517                || (phase == Phase.Claimed   && autoreleaseAvailable())
518                );
519     }
520 
521     function poke()
522     external 
523     returns (bool moved) {
524         if (pokeNeeded()) {
525             daiContract.transfer(msg.sender, pokeReward);
526             pokeRewardSent = true;
527             emit Poke();
528         }
529         else return false;
530 
531         if (phase == Phase.Open) {
532             if (autorecallAvailable()) {
533                 internalRecall();
534                 return true;
535             }
536         }
537         else if (phase == Phase.Committed) {
538             if (autoabortAvailable()) {
539                 internalAbort();
540                 return true;
541             }
542         }
543         else if (phase == Phase.Claimed) {
544             if (autoreleaseAvailable()) {
545                 internalRelease();
546                 return true;
547             }
548         }
549     }
550 
551     // StatementLogs allow a starting point for any necessary communication,
552     // and can be used anytime by either party after a Responder commits (even in the Closed phase).
553 
554 
555     event InitiatorStatementLog(string encryptedForInitiator, string encryptedForResponder);
556     event ResponderStatementLog(string encryptedForInitiator, string encryptedForResponder);
557 
558     function initiatorStatement(string memory encryptedForInitiator, string memory encryptedForResponder)
559     public
560     onlyInitiator() {
561         require(phase >= Phase.Committed);
562         emit InitiatorStatementLog(encryptedForInitiator, encryptedForResponder);
563     }
564 
565     function responderStatement(string memory encryptedForInitiator, string memory encryptedForResponder)
566     public
567     onlyResponder() {
568         require(phase >= Phase.Committed);
569         emit ResponderStatementLog(encryptedForInitiator, encryptedForResponder);
570     }
571 }