1 pragma solidity 0.5.6;
2 
3 contract ERC20Interface {
4     function totalSupply() public view returns (uint);
5     function balanceOf(address tokenOwner) public view returns (uint balance);
6     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
7     function transfer(address to, uint tokens) public returns (bool success);
8     function approve(address spender, uint tokens) public returns (bool success);
9     function transferFrom(address from, address to, uint tokens) public returns (bool success);
10 
11     uint8 public decimals;
12 
13     event Transfer(address indexed from, address indexed to, uint tokens);
14     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
15 }
16 
17 contract DAIHardFactory {
18     event NewTrade(uint id, address tradeAddress, bool indexed initiatorIsPayer);
19 
20     ERC20Interface public daiContract;
21     address payable public devFeeAddress;
22 
23     constructor(ERC20Interface _daiContract, address payable _devFeeAddress)
24     public {
25         daiContract = _daiContract;
26         devFeeAddress = _devFeeAddress;
27     }
28 
29     struct CreationInfo {
30         address address_;
31         uint blocknum;
32     }
33 
34     CreationInfo[] public createdTrades;
35 
36     function getBuyerDeposit(uint tradeAmount)
37     public
38     pure
39     returns (uint buyerDeposit) {
40         return tradeAmount / 3;
41     }
42 
43     function getDevFee(uint tradeAmount)
44     public
45     pure
46     returns (uint devFee) {
47         return tradeAmount / 100;
48     }
49 
50     function getExtraFees(uint tradeAmount)
51     public
52     pure
53     returns (uint buyerDeposit, uint devFee) {
54         return (getBuyerDeposit(tradeAmount), getDevFee(tradeAmount));
55     }
56 
57     /*
58     The Solidity compiler can't handle much stack depth,
59     so we have to pack some args together in annoying ways...
60     Hence the 'uintArgs'. Here is its layout:
61     0 - daiAmount
62     1 - pokeReward
63     2 - autorecallInterval
64     3 - autoabortInterval
65     4 - autoreleaseInterval
66     */
67 
68     function openDAIHardTrade(address payable _initiator, bool initiatorIsBuyer, uint[5] calldata uintArgs, string calldata _totalPrice, string calldata _fiatTransferMethods, string calldata _commPubkey)
69     external
70     returns (DAIHardTrade) {
71         uint transferAmount;
72         uint[6] memory newUintArgs; // Note that this structure is not the same as the above comment describes. See below in DAIHardTrade.open.
73 
74         if (initiatorIsBuyer) {
75             transferAmount = getBuyerDeposit(uintArgs[0]) + uintArgs[1] + getDevFee(uintArgs[0]);
76             newUintArgs = [uintArgs[0], uintArgs[1], getDevFee(uintArgs[0]), uintArgs[2], uintArgs[3], uintArgs[4]];
77         }
78         else {
79             transferAmount = uintArgs[0] + uintArgs[1] + getDevFee(uintArgs[0]);
80             newUintArgs = [getBuyerDeposit(uintArgs[0]), uintArgs[1], getDevFee(uintArgs[0]), uintArgs[2], uintArgs[3], uintArgs[4]];
81         }
82 
83         //create the new trade and add its creationInfo to createdTrades
84         DAIHardTrade newTrade = new DAIHardTrade(daiContract, devFeeAddress);
85         createdTrades.push(CreationInfo(address(newTrade), block.number));
86         emit NewTrade(createdTrades.length - 1, address(newTrade), initiatorIsBuyer);
87 
88         //transfer DAI to the trade and open it
89         require(daiContract.transferFrom(msg.sender, address(newTrade), transferAmount), "Token transfer failed. Did you call approve() on the DAI contract?");
90         newTrade.open(_initiator, initiatorIsBuyer, newUintArgs, _totalPrice, _fiatTransferMethods, _commPubkey);
91     }
92 
93     function getNumTrades()
94     external
95     view
96     returns (uint num) {
97         return createdTrades.length;
98     }
99 }
100 
101 contract DAIHardTrade {
102     enum Phase {Created, Open, Committed, Claimed, Closed}
103     Phase public phase;
104 
105     modifier inPhase(Phase p) {
106         require(phase == p, "inPhase check failed.");
107         _;
108     }
109 
110     uint[5] public phaseStartTimestamps;
111 
112     function changePhase(Phase p)
113     internal {
114         phase = p;
115         phaseStartTimestamps[uint(p)] = block.timestamp;
116     }
117 
118 
119     address payable public initiator;
120     address payable public responder;
121 
122     //The contract only has two parties, but depending on how it's opened,
123     //the initiator for example might be either the buyer OR the seller.
124 
125     bool public initiatorIsBuyer;
126     address payable public buyer;
127     address payable public seller;
128 
129     modifier onlyInitiator() {
130         require(msg.sender == initiator, "msg.sender is not Initiator.");
131         _;
132     }
133     modifier onlyResponder() {
134         require(msg.sender == responder, "msg.sender is not Responder.");
135         _;
136     }
137     modifier onlyBuyer() {
138         require (msg.sender == buyer, "msg.sender is not Buyer.");
139         _;
140     }
141     modifier onlySeller() {
142         require (msg.sender == seller, "msg.sender is not Seller.");
143         _;
144     }
145     modifier onlyContractParty() { // Must be one of the two parties involved in the contract
146         require(msg.sender == initiator || msg.sender == responder, "msg.sender is not a party in this contract.");
147         _;
148     }
149 
150     ERC20Interface daiContract;
151     address payable devFeeAddress;
152 
153     constructor(ERC20Interface _daiContract, address payable _devFeeAddress)
154     public {
155         changePhase(Phase.Created);
156 
157         daiContract = _daiContract;
158         devFeeAddress = _devFeeAddress;
159 
160         pokeRewardSent = false;
161     }
162 
163     uint public daiAmount;
164     string public price;
165     uint public buyerDeposit;
166 
167     uint public responderDeposit; // This will be equal to either daiAmount or buyerDeposit, depending on initiatorIsBuyer
168 
169     uint public autorecallInterval;
170     uint public autoabortInterval;
171     uint public autoreleaseInterval;
172 
173     uint public pokeReward;
174     uint public devFee;
175 
176     bool public pokeRewardSent;
177 
178     /*
179     uintArgs:
180     0 - responderDeposit
181     1 - pokeReward
182     2 - devFee
183     3 - autorecallInterval
184     4 - autoabortInterval
185     5 - autoreleaseInterval
186     */
187 
188     event Opened(string fiatTransferMethods, string commPubkey);
189 
190     function open(address payable _initiator, bool _initiatorIsBuyer, uint[6] memory uintArgs, string memory _price, string memory fiatTransferMethods, string memory commPubkey)
191     public {
192         require(getBalance() > 0, "You can't open a trade without first depositing DAI.");
193 
194         responderDeposit = uintArgs[0];
195         pokeReward = uintArgs[1];
196         devFee = uintArgs[2];
197 
198         autorecallInterval = uintArgs[3];
199         autoabortInterval = uintArgs[4];
200         autoreleaseInterval = uintArgs[5];
201 
202         initiator = _initiator;
203         initiatorIsBuyer = _initiatorIsBuyer;
204         if (initiatorIsBuyer) {
205             buyer = initiator;
206             daiAmount = responderDeposit;
207             buyerDeposit = getBalance() - (pokeReward + devFee);
208         }
209         else {
210             seller = initiator;
211             daiAmount = getBalance() - (pokeReward + devFee);
212             buyerDeposit = responderDeposit;
213         }
214 
215         price = _price;
216 
217         changePhase(Phase.Open);
218         emit Opened(fiatTransferMethods, commPubkey);
219     }
220 
221     /* ---------------------- OPEN PHASE --------------------------
222 
223     In the Open phase, the Initiator waits for a Responder.
224     We move to the Commited phase once someone becomes the Responder
225     by executing commit() and including msg.value = responderDeposit.
226 
227     At any time, the Initiator can cancel the whole thing by calling recall().
228 
229     After autorecallInterval has passed, the only state change allowed is to recall(),
230     which can be triggered by anyone via poke().
231 
232     ------------------------------------------------------------ */
233 
234     event Recalled();
235     event Committed(address responder, string commPubkey);
236 
237 
238     function recall()
239     external
240     inPhase(Phase.Open)
241     onlyInitiator() {
242        internalRecall();
243     }
244 
245     function internalRecall()
246     internal {
247         require(daiContract.transfer(initiator, getBalance()), "Recall of DAI to initiator failed!");
248 
249         changePhase(Phase.Closed);
250         emit Recalled();
251     }
252 
253     function autorecallAvailable()
254     public
255     view
256     inPhase(Phase.Open)
257     returns(bool available) {
258         return (block.timestamp >= phaseStartTimestamps[uint(Phase.Open)] + autorecallInterval);
259     }
260 
261     function commit(string calldata commPubkey)
262     external
263     inPhase(Phase.Open) {
264         require(daiContract.transferFrom(msg.sender, address(this), responderDeposit), "Can't transfer the required deposit from the DAI contract. Did you call approve first?");
265         require(!autorecallAvailable(), "autorecallInterval has passed; this offer has expired.");
266 
267         responder = msg.sender;
268 
269         if (initiatorIsBuyer) {
270             seller = responder;
271         }
272         else {
273             buyer = responder;
274         }
275 
276         changePhase(Phase.Committed);
277         emit Committed(responder, commPubkey);
278     }
279 
280     /* ---------------------- COMMITTED PHASE ---------------------
281 
282     In the Committed phase, the Buyer is expected to deposit fiat for the DAI,
283     then call claim().
284 
285     Otherwise, the Buyer can call abort(), which cancels the contract,
286     incurs a small penalty on both parties, and returns the remainder to each party.
287 
288     After autoabortInterval has passed, the only state change allowed is to abort(),
289     which can be triggered by anyone via poke().
290 
291     ------------------------------------------------------------ */
292 
293     event Claimed();
294     event Aborted();
295 
296     function abort()
297     external
298     inPhase(Phase.Committed)
299     onlyBuyer() {
300         internalAbort();
301     }
302 
303     function internalAbort()
304     internal {
305         //Punishment amount is 1/4 the buyerDeposit for now,
306         //but in a future version this might be set by the Initiator.
307         uint burnAmount = buyerDeposit / 4;
308 
309         //Punish both parties equally by burning burnAmount.
310         //Instead of burning burnAmount twice, just burn it all in one call (saves gas).
311         require(daiContract.transfer(address(0x0), burnAmount*2), "Token burn failed!");
312 
313         //Send back deposits minus burned amounts.
314         require(daiContract.transfer(buyer, buyerDeposit - burnAmount), "Token transfer to Buyer failed!");
315         require(daiContract.transfer(seller, daiAmount - burnAmount), "Token transfer to Seller failed!");
316 
317         uint sendBackToInitiator = devFee;
318         //If there was a pokeReward left, it should be sent back to the initiator
319         if (!pokeRewardSent) {
320             sendBackToInitiator += pokeReward;
321         }
322         
323         require(daiContract.transfer(initiator, sendBackToInitiator), "Token refund of devFee+pokeReward to Initiator failed!");
324         
325         //There may be a wei or two left over in the contract due to integer division. Not a big deal.
326 
327         changePhase(Phase.Closed);
328         emit Aborted();
329     }
330 
331     function autoabortAvailable()
332     public
333     view
334     inPhase(Phase.Committed)
335     returns(bool passed) {
336         return (block.timestamp >= phaseStartTimestamps[uint(Phase.Committed)] + autoabortInterval);
337     }
338 
339     function claim()
340     external
341     inPhase(Phase.Committed)
342     onlyBuyer() {
343         require(!autoabortAvailable(), "The deposit deadline has passed!");
344 
345         changePhase(Phase.Claimed);
346         emit Claimed();
347     }
348 
349     /* ---------------------- CLAIMED PHASE -----------------------
350 
351     In the Claimed phase, the Seller can call release() or burn(),
352     and is expected to call burn() only if the Buyer did not transfer
353     the amount of money described in totalPrice.
354 
355     After autoreleaseInterval has passed, the only state change allowed is to release,
356     which can be triggered by anyone via poke().
357 
358     ------------------------------------------------------------ */
359 
360     event Released();
361     event Burned();
362 
363     function autoreleaseAvailable()
364     public
365     view
366     inPhase(Phase.Claimed)
367     returns(bool available) {
368         return (block.timestamp >= phaseStartTimestamps[uint(Phase.Claimed)] + autoreleaseInterval);
369     }
370 
371     function release()
372     external
373     inPhase(Phase.Claimed)
374     onlySeller() {
375         internalRelease();
376     }
377 
378     function internalRelease()
379     internal {
380         //If the pokeReward has not been sent, refund it to the initiator
381         if (!pokeRewardSent) {
382             require(daiContract.transfer(initiator, pokeReward), "Refund of pokeReward to Initiator failed!");
383         }
384 
385         //Upon successful resolution of trade, the devFee is sent to the developers of DAIHard.
386         require(daiContract.transfer(devFeeAddress, devFee), "Token transfer to devFeeAddress failed!");
387 
388         //Release the remaining balance to the buyer.
389         require(daiContract.transfer(buyer, getBalance()), "Final release transfer to buyer failed!");
390 
391         changePhase(Phase.Closed);
392         emit Released();
393     }
394 
395     function burn()
396     external
397     inPhase(Phase.Claimed)
398     onlySeller() {
399         require(!autoreleaseAvailable());
400 
401         internalBurn();
402     }
403 
404     function internalBurn()
405     internal {
406         require(daiContract.transfer(address(0x0), getBalance()), "Final DAI burn failed!");
407 
408         changePhase(Phase.Closed);
409         emit Burned();
410     }
411 
412     /* ---------------------- OTHER METHODS ----------------------- */
413 
414     function getState()
415     external
416     view
417     returns(uint balance, Phase phase, uint phaseStartTimestamp, address responder) {
418         return (getBalance(), this.phase(), phaseStartTimestamps[uint(this.phase())], this.responder());
419     }
420 
421     function getBalance()
422     public
423     view
424     returns(uint) {
425         return daiContract.balanceOf(address(this));
426     }
427 
428     function getParameters()
429     external
430     view
431     returns (address initiator, bool initiatorIsBuyer, uint daiAmount, string memory totalPrice, uint buyerDeposit, uint autorecallInterval, uint autoabortInterval, uint autoreleaseInterval, uint pokeReward)
432     {
433         return (this.initiator(), this.initiatorIsBuyer(), this.daiAmount(), this.price(), this.buyerDeposit(), this.autorecallInterval(), this.autoabortInterval(), this.autoreleaseInterval(), this.pokeReward());
434     }
435 
436     // Poke function lets anyone move the contract along,
437     // if it's due for some state transition.
438 
439     event Poke();
440 
441     function pokeNeeded()
442     public
443     view
444     returns (bool needed) {
445         return (  (phase == Phase.Open      && autorecallAvailable() )
446                || (phase == Phase.Committed && autoabortAvailable()  )
447                || (phase == Phase.Claimed   && autoreleaseAvailable())
448                );
449     }
450 
451     function poke()
452     external 
453     returns (bool moved) {
454         if (pokeNeeded()) {
455             daiContract.transfer(msg.sender, pokeReward);
456             pokeRewardSent = true;
457             emit Poke();
458         }
459         else return false;
460 
461         if (phase == Phase.Open) {
462             if (autorecallAvailable()) {
463                 internalRecall();
464                 return true;
465             }
466         }
467         else if (phase == Phase.Committed) {
468             if (autoabortAvailable()) {
469                 internalAbort();
470                 return true;
471             }
472         }
473         else if (phase == Phase.Claimed) {
474             if (autoreleaseAvailable()) {
475                 internalRelease();
476                 return true;
477             }
478         }
479     }
480 
481     // StatementLogs allow a starting point for any necessary communication,
482     // and can be used anytime by either party after a Responder commits (even in the Closed phase).
483 
484 
485     event InitiatorStatementLog(string encryptedForInitiator, string encryptedForResponder);
486     event ResponderStatementLog(string encryptedForInitiator, string encryptedForResponder);
487 
488     function initiatorStatement(string memory encryptedForInitiator, string memory encryptedForResponder)
489     public
490     onlyInitiator() {
491         require(phase >= Phase.Committed);
492         emit InitiatorStatementLog(encryptedForInitiator, encryptedForResponder);
493     }
494 
495     function responderStatement(string memory encryptedForInitiator, string memory encryptedForResponder)
496     public
497     onlyResponder() {
498         require(phase >= Phase.Committed);
499         emit ResponderStatementLog(encryptedForInitiator, encryptedForResponder);
500     }
501 }