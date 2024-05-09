1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title Owned contract with safe ownership pass.
5  *
6  * Note: all the non constant functions return false instead of throwing in case if state change
7  * didn't happen yet.
8  */
9 contract Owned {
10     /**
11      * Contract owner address
12      */
13     address public contractOwner;
14 
15     /**
16      * Contract owner address
17      */
18     address public pendingContractOwner;
19 
20     function Owned() {
21         contractOwner = msg.sender;
22     }
23 
24     /**
25     * @dev Owner check modifier
26     */
27     modifier onlyContractOwner() {
28         if (contractOwner == msg.sender) {
29             _;
30         }
31     }
32 
33     /**
34      * @dev Destroy contract and scrub a data
35      * @notice Only owner can call it
36      */
37     function destroy() onlyContractOwner {
38         suicide(msg.sender);
39     }
40 
41     /**
42      * Prepares ownership pass.
43      *
44      * Can only be called by current owner.
45      *
46      * @param _to address of the next owner. 0x0 is not allowed.
47      *
48      * @return success.
49      */
50     function changeContractOwnership(address _to) onlyContractOwner() returns(bool) {
51         if (_to  == 0x0) {
52             return false;
53         }
54 
55         pendingContractOwner = _to;
56         return true;
57     }
58 
59     /**
60      * Finalize ownership pass.
61      *
62      * Can only be called by pending owner.
63      *
64      * @return success.
65      */
66     function claimContractOwnership() returns(bool) {
67         if (pendingContractOwner != msg.sender) {
68             return false;
69         }
70 
71         contractOwner = pendingContractOwner;
72         delete pendingContractOwner;
73 
74         return true;
75     }
76 }
77 
78 
79 contract ERC20Interface {
80     event Transfer(address indexed from, address indexed to, uint256 value);
81     event Approval(address indexed from, address indexed spender, uint256 value);
82     string public symbol;
83 
84     function totalSupply() constant returns (uint256 supply);
85     function balanceOf(address _owner) constant returns (uint256 balance);
86     function transfer(address _to, uint256 _value) returns (bool success);
87     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
88     function approve(address _spender, uint256 _value) returns (bool success);
89     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
90 }
91 
92 /**
93  * @title Generic owned destroyable contract
94  */
95 contract Object is Owned {
96     /**
97     *  Common result code. Means everything is fine.
98     */
99     uint constant OK = 1;
100     uint constant OWNED_ACCESS_DENIED_ONLY_CONTRACT_OWNER = 8;
101 
102     function withdrawnTokens(address[] tokens, address _to) onlyContractOwner returns(uint) {
103         for(uint i=0;i<tokens.length;i++) {
104             address token = tokens[i];
105             uint balance = ERC20Interface(token).balanceOf(this);
106             if(balance != 0)
107                 ERC20Interface(token).transfer(_to,balance);
108         }
109         return OK;
110     }
111 
112     function checkOnlyContractOwner() internal constant returns(uint) {
113         if (contractOwner == msg.sender) {
114             return OK;
115         }
116 
117         return OWNED_ACCESS_DENIED_ONLY_CONTRACT_OWNER;
118     }
119 }
120 
121 
122 /**
123  * @title General MultiEventsHistory user.
124  *
125  */
126 contract MultiEventsHistoryAdapter {
127 
128     /**
129     *   @dev It is address of MultiEventsHistory caller assuming we are inside of delegate call.
130     */
131     function _self() constant internal returns (address) {
132         return msg.sender;
133     }
134 }
135 
136 contract DelayedPaymentsEmitter is MultiEventsHistoryAdapter {
137     event Error(bytes32 message);
138 
139     function emitError(bytes32 _message) {
140         Error(_message);
141     }
142 }
143 
144 contract DelayedPayments is Object {
145    
146     uint constant DELAYED_PAYMENTS_SCOPE = 52000;
147     uint constant DELAYED_PAYMENTS_INVALID_INVOCATION = DELAYED_PAYMENTS_SCOPE + 17;
148 
149     /// @dev `Payment` is a public structure that describes the details of
150     ///  each payment making it easy to track the movement of funds
151     ///  transparently
152     struct Payment {
153         address spender;        // Who is sending the funds
154         uint earliestPayTime;   // The earliest a payment can be made (Unix Time)
155         bool canceled;         // If True then the payment has been canceled
156         bool paid;              // If True then the payment has been paid
157         address recipient;      // Who is receiving the funds
158         uint amount;            // The amount of wei sent in the payment
159         uint securityGuardDelay;// The seconds `securityGuard` can delay payment
160     }
161 
162     Payment[] public authorizedPayments;
163 
164     address public securityGuard;
165     uint public absoluteMinTimeLock;
166     uint public timeLock;
167     uint public maxSecurityGuardDelay;
168 
169     // Should use interface of the emitter, but address of events history.
170     address public eventsHistory;
171 
172     /// @dev The white list of approved addresses allowed to set up && receive
173     ///  payments from this vault
174     mapping (address => bool) public allowedSpenders;
175 
176     /// @dev The address assigned the role of `securityGuard` is the only
177     ///  addresses that can call a function with this modifier
178     modifier onlySecurityGuard { if (msg.sender != securityGuard) throw; _; }
179 
180     // @dev Events to make the payment movements easy to find on the blockchain
181     event PaymentAuthorized(uint indexed idPayment, address indexed recipient, uint amount);
182     event PaymentExecuted(uint indexed idPayment, address indexed recipient, uint amount);
183     event PaymentCanceled(uint indexed idPayment);
184     event EtherReceived(address indexed from, uint amount);
185     event SpenderAuthorization(address indexed spender, bool authorized);
186 
187 /////////
188 // Constructor
189 /////////
190 
191     /// @notice The Constructor creates the Vault on the blockchain
192     /// @param _absoluteMinTimeLock The minimum number of seconds `timelock` can
193     ///  be set to, if set to 0 the `owner` can remove the `timeLock` completely
194     /// @param _timeLock Initial number of seconds that payments are delayed
195     ///  after they are authorized (a security precaution)
196     /// @param _maxSecurityGuardDelay The maximum number of seconds in total
197     ///   that `securityGuard` can delay a payment so that the owner can cancel
198     ///   the payment if needed
199     function DelayedPayments(
200         uint _absoluteMinTimeLock,
201         uint _timeLock,
202         uint _maxSecurityGuardDelay) 
203     {
204         absoluteMinTimeLock = _absoluteMinTimeLock;
205         timeLock = _timeLock;
206         securityGuard = msg.sender;
207         maxSecurityGuardDelay = _maxSecurityGuardDelay;
208     }
209 
210     /**
211      * Emits Error event with specified error message.
212      *
213      * Should only be used if no state changes happened.
214      *
215      * @param _errorCode code of an error
216      * @param _message error message.
217      */
218     function _error(uint _errorCode, bytes32 _message) internal returns(uint) {
219         DelayedPaymentsEmitter(eventsHistory).emitError(_message);
220         return _errorCode;
221     }
222 
223     /**
224      * Sets EventsHstory contract address.
225      *
226      * Can be set only once, and only by contract owner.
227      *
228      * @param _eventsHistory MultiEventsHistory contract address.
229      *
230      * @return success.
231      */
232     function setupEventsHistory(address _eventsHistory) returns(uint errorCode) {
233         errorCode = checkOnlyContractOwner();
234         if (errorCode != OK) {
235             return errorCode;
236         }
237         if (eventsHistory != 0x0 && eventsHistory != _eventsHistory) {
238             return DELAYED_PAYMENTS_INVALID_INVOCATION;
239         }
240         eventsHistory = _eventsHistory;
241         return OK;
242     }
243 
244 /////////
245 // Helper functions
246 /////////
247 
248     /// @notice States the total number of authorized payments in this contract
249     /// @return The number of payments ever authorized even if they were canceled
250     function numberOfAuthorizedPayments() constant returns (uint) {
251         return authorizedPayments.length;
252     }
253 
254 //////
255 // Receive Ether
256 //////
257 
258     /// @notice Called anytime ether is sent to the contract && creates an event
259     /// to more easily track the incoming transactions
260     function receiveEther() payable {
261         EtherReceived(msg.sender, msg.value);
262     }
263 
264     /// @notice The fall back function is called whenever ether is sent to this
265     ///  contract
266     function () payable {
267         receiveEther();
268     }
269 
270 ////////
271 // Spender Interface
272 ////////
273 
274     /// @notice only `allowedSpenders[]` Creates a new `Payment`
275     /// @param _recipient Destination of the payment
276     /// @param _amount Amount to be paid in wei
277     /// @param _paymentDelay Number of seconds the payment is to be delayed, if
278     ///  this value is below `timeLock` then the `timeLock` determines the delay
279     /// @return The Payment ID number for the new authorized payment
280     function authorizePayment(
281         address _recipient,
282         uint _amount,
283         uint _paymentDelay
284     ) returns(uint) {
285 
286         // Fail if you arent on the `allowedSpenders` white list
287         if (!allowedSpenders[msg.sender]) throw;
288         uint idPayment = authorizedPayments.length;       // Unique Payment ID
289         authorizedPayments.length++;
290 
291         // The following lines fill out the payment struct
292         Payment p = authorizedPayments[idPayment];
293         p.spender = msg.sender;
294 
295         // Overflow protection
296         if (_paymentDelay > 10**18) throw;
297 
298         // Determines the earliest the recipient can receive payment (Unix time)
299         p.earliestPayTime = _paymentDelay >= timeLock ?
300                                 now + _paymentDelay :
301                                 now + timeLock;
302         p.recipient = _recipient;
303         p.amount = _amount;
304         PaymentAuthorized(idPayment, p.recipient, p.amount);
305         return idPayment;
306     }
307 
308     /// @notice only `allowedSpenders[]` The recipient of a payment calls this
309     ///  function to send themselves the ether after the `earliestPayTime` has
310     ///  expired
311     /// @param _idPayment The payment ID to be executed
312     function collectAuthorizedPayment(uint _idPayment) {
313 
314         // Check that the `_idPayment` has been added to the payments struct
315         if (_idPayment >= authorizedPayments.length) return;
316 
317         Payment p = authorizedPayments[_idPayment];
318 
319         // Checking for reasons not to execute the payment
320         if (msg.sender != p.recipient) return;
321         if (now < p.earliestPayTime) return;
322         if (p.canceled) return;
323         if (p.paid) return;
324         if (this.balance < p.amount) return;
325 
326         p.paid = true; // Set the payment to being paid
327         if (!p.recipient.send(p.amount)) {  // Make the payment
328             return;
329         }
330         PaymentExecuted(_idPayment, p.recipient, p.amount);
331      }
332 
333 /////////
334 // SecurityGuard Interface
335 /////////
336 
337     /// @notice `onlySecurityGuard` Delays a payment for a set number of seconds
338     /// @param _idPayment ID of the payment to be delayed
339     /// @param _delay The number of seconds to delay the payment
340     function delayPayment(uint _idPayment, uint _delay) onlySecurityGuard {
341         if (_idPayment >= authorizedPayments.length) throw;
342 
343         // Overflow test
344         if (_delay > 10**18) throw;
345 
346         Payment p = authorizedPayments[_idPayment];
347 
348         if ((p.securityGuardDelay + _delay > maxSecurityGuardDelay) ||
349             (p.paid) ||
350             (p.canceled))
351             throw;
352 
353         p.securityGuardDelay += _delay;
354         p.earliestPayTime += _delay;
355     }
356 
357 ////////
358 // Owner Interface
359 ///////
360 
361     /// @notice `onlyOwner` Cancel a payment all together
362     /// @param _idPayment ID of the payment to be canceled.
363     function cancelPayment(uint _idPayment) onlyContractOwner {
364         if (_idPayment >= authorizedPayments.length) throw;
365 
366         Payment p = authorizedPayments[_idPayment];
367 
368 
369         if (p.canceled) throw;
370         if (p.paid) throw;
371 
372         p.canceled = true;
373         PaymentCanceled(_idPayment);
374     }
375 
376     /// @notice `onlyOwner` Adds a spender to the `allowedSpenders[]` white list
377     /// @param _spender The address of the contract being authorized/unauthorized
378     /// @param _authorize `true` if authorizing and `false` if unauthorizing
379     function authorizeSpender(address _spender, bool _authorize) onlyContractOwner {
380         allowedSpenders[_spender] = _authorize;
381         SpenderAuthorization(_spender, _authorize);
382     }
383 
384     /// @notice `onlyOwner` Sets the address of `securityGuard`
385     /// @param _newSecurityGuard Address of the new security guard
386     function setSecurityGuard(address _newSecurityGuard) onlyContractOwner {
387         securityGuard = _newSecurityGuard;
388     }
389 
390     /// @notice `onlyOwner` Changes `timeLock`; the new `timeLock` cannot be
391     ///  lower than `absoluteMinTimeLock`
392     /// @param _newTimeLock Sets the new minimum default `timeLock` in seconds;
393     ///  pending payments maintain their `earliestPayTime`
394     function setTimelock(uint _newTimeLock) onlyContractOwner {
395         if (_newTimeLock < absoluteMinTimeLock) throw;
396         timeLock = _newTimeLock;
397     }
398 
399     /// @notice `onlyOwner` Changes the maximum number of seconds
400     /// `securityGuard` can delay a payment
401     /// @param _maxSecurityGuardDelay The new maximum delay in seconds that
402     ///  `securityGuard` can delay the payment's execution in total
403     function setMaxSecurityGuardDelay(uint _maxSecurityGuardDelay) onlyContractOwner {
404         maxSecurityGuardDelay = _maxSecurityGuardDelay;
405     }
406 }
407 
408 
409 contract Asset {
410     event Transfer(address indexed from, address indexed to, uint256 value);
411     event Approval(address indexed from, address indexed spender, uint256 value);
412     string public symbol;
413 
414     function totalSupply() constant returns (uint256 supply);
415     function balanceOf(address _owner) constant returns (uint256 balance);
416     function transfer(address _to, uint256 _value) returns (bool success);
417     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
418     function approve(address _spender, uint256 _value) returns (bool success);
419     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
420 }
421 
422 contract BuyBackEmitter {
423     function emitError(uint errorCode);
424     function emitPricesUpdated(uint buyPrice, uint sellPrice);
425     function emitActiveChanged(bool isActive);
426 }
427 
428 
429 contract BuyBack is Object {
430 
431     uint constant ERROR_EXCHANGE_INVALID_PARAMETER = 6000;
432     uint constant ERROR_EXCHANGE_INVALID_INVOCATION = 6001;
433     uint constant ERROR_EXCHANGE_INVALID_FEE_PERCENT = 6002;
434     uint constant ERROR_EXCHANGE_INVALID_PRICE = 6003;
435     uint constant ERROR_EXCHANGE_MAINTENANCE_MODE = 6004;
436     uint constant ERROR_EXCHANGE_TOO_HIGH_PRICE = 6005;
437     uint constant ERROR_EXCHANGE_TOO_LOW_PRICE = 6006;
438     uint constant ERROR_EXCHANGE_INSUFFICIENT_BALANCE = 6007;
439     uint constant ERROR_EXCHANGE_INSUFFICIENT_ETHER_SUPPLY = 6008;
440     uint constant ERROR_EXCHANGE_PAYMENT_FAILED = 6009;
441     uint constant ERROR_EXCHANGE_TRANSFER_FAILED = 6010;
442     uint constant ERROR_EXCHANGE_FEE_TRANSFER_FAILED = 6011;
443     uint constant ERROR_EXCHANGE_DELAYEDPAYMENTS_ACCESS = 6012;
444 
445     // Assigned ERC20 token.
446     Asset public asset;
447     DelayedPayments public delayedPayments;
448     //Switch for turn on and off the exchange operations
449     bool public isActive;
450     // Price in wei at which exchange buys tokens.
451     uint public buyPrice = 1;
452     // Price in wei at which exchange sells tokens.
453     uint public sellPrice = 2570735391000000; // 80% from ETH/USD=311.1950
454     uint public minAmount;
455     uint public maxAmount;
456     // User sold tokens and received wei.
457     event Sell(address indexed who, uint token, uint eth);
458     // User bought tokens and payed wei.
459     event Buy(address indexed who, uint token, uint eth);
460     event WithdrawTokens(address indexed recipient, uint amount);
461     event WithdrawEth(address indexed recipient, uint amount);
462     event PricesUpdated(address indexed self, uint buyPrice, uint sellPrice);
463     event ActiveChanged(address indexed self, bool isActive);
464     event Error(uint errorCode);
465 
466     /**
467      * @dev On received ethers
468      * @param sender Ether sender
469      * @param amount Ether value
470      */
471     event ReceivedEther(address indexed sender, uint256 indexed amount);
472 
473     // Should use interface of the emitter, but address of events history.
474     BuyBackEmitter public eventsHistory;
475 
476     /**
477      * Emits Error event with specified error message.
478      *
479      * Should only be used if no state changes happened.
480      *
481      * @param error error from Errors library.
482      */
483     function _error(uint error) internal returns (uint) {
484         getEventsHistory().emitError(error);
485         return error;
486     }
487 
488     function _emitPricesUpdated(uint buyPrice, uint sellPrice) internal {
489         getEventsHistory().emitPricesUpdated(buyPrice, sellPrice);
490     }
491 
492     function _emitActiveChanged(bool isActive) internal {
493         getEventsHistory().emitActiveChanged(isActive);
494     }
495 
496     /**
497      * Sets EventsHstory contract address.
498      *
499      * Can be set only once, and only by contract owner.
500      *
501      * @param _eventsHistory MultiEventsHistory contract address.
502      *
503      * @return success.
504      */
505     function setupEventsHistory(address _eventsHistory) onlyContractOwner returns (uint) {
506         if (address(eventsHistory) != 0x0) {
507             return _error(ERROR_EXCHANGE_INVALID_INVOCATION);
508         }
509 
510         eventsHistory = BuyBackEmitter(_eventsHistory);
511         return OK;
512     }
513 
514     /**
515      * Assigns ERC20 token for exchange.
516      *
517      * Can be set only once, and only by contract owner.
518      *
519      * @param _asset ERC20 token address.
520      *
521      * @return success.
522      */
523     function init(Asset _asset, DelayedPayments _delayedPayments) onlyContractOwner returns (uint errorCode) {
524         if (address(asset) != 0x0 || address(delayedPayments) != 0x0) {
525             return _error(ERROR_EXCHANGE_INVALID_INVOCATION);
526         }
527 
528         asset = _asset;
529         delayedPayments = _delayedPayments;
530         isActive = true;
531         return OK;
532     }
533 
534     function setActive(bool _active) onlyContractOwner returns (uint) {
535         if (isActive != _active) {
536             _emitActiveChanged(_active);
537         }
538 
539         isActive = _active;
540         return OK;
541     }
542 
543     /**
544      * Set exchange operation prices.
545      * Sell price cannot be less than buy price.
546      *
547      * Can be set only by contract owner.
548      *
549      * @param _buyPrice price in wei at which exchange buys tokens.
550      * @param _sellPrice price in wei at which exchange sells tokens.
551      *
552      * @return success.
553      */
554     function setPrices(uint _buyPrice, uint _sellPrice) onlyContractOwner returns (uint) {
555         if (_sellPrice < _buyPrice) {
556             return _error(ERROR_EXCHANGE_INVALID_PRICE);
557         }
558 
559         buyPrice = _buyPrice;
560         sellPrice = _sellPrice;
561         _emitPricesUpdated(_buyPrice, _sellPrice);
562 
563         return OK;
564     }
565 
566     /**
567      * Returns assigned token address balance.
568      *
569      * @param _address address to get balance.
570      *
571      * @return token balance.
572      */
573     function _balanceOf(address _address) constant internal returns (uint) {
574         return asset.balanceOf(_address);
575     }
576 
577     /**
578      * Sell tokens for ether at specified price. Tokens are taken from caller
579      * though an allowance logic.
580      * Amount should be less than or equal to current allowance value.
581      * Price should be less than or equal to current exchange buyPrice.
582      *
583      * @param _amount amount of tokens to sell.
584      * @param _price price in wei at which sell will happen.
585      *
586      * @return success.
587      */
588     function sell(uint _amount, uint _price) returns (uint) {
589         if (!isActive) {
590             return _error(ERROR_EXCHANGE_MAINTENANCE_MODE);
591         }
592 
593         if (_price > buyPrice) {
594             return _error(ERROR_EXCHANGE_TOO_HIGH_PRICE);
595         }
596 
597         if (_balanceOf(msg.sender) < _amount) {
598             return _error(ERROR_EXCHANGE_INSUFFICIENT_BALANCE);
599         }
600 
601         uint total = _mul(_amount, _price);
602         if (this.balance < total) {
603             return _error(ERROR_EXCHANGE_INSUFFICIENT_ETHER_SUPPLY);
604         }
605 
606         if (!asset.transferFrom(msg.sender, this, _amount)) {
607             return _error(ERROR_EXCHANGE_PAYMENT_FAILED);
608         }
609 
610         if (!delayedPayments.send(total)) {
611             throw;
612         }
613         if (!delayedPayments.allowedSpenders(this)) {
614             throw;
615         }
616         delayedPayments.authorizePayment(msg.sender,total,1 hours); 
617         Sell(msg.sender, _amount, total);
618 
619         return OK;
620     }
621 
622     /**
623      * Transfer specified amount of tokens from exchange to specified address.
624      *
625      * Can be called only by contract owner.
626      *
627      * @param _recipient address to transfer tokens to.
628      * @param _amount amount of tokens to transfer.
629      *
630      * @return success.
631      */
632     function withdrawTokens(address _recipient, uint _amount) onlyContractOwner returns (uint) {
633         if (_balanceOf(this) < _amount) {
634             return _error(ERROR_EXCHANGE_INSUFFICIENT_BALANCE);
635         }
636 
637         if (!asset.transfer(_recipient, _amount)) {
638             return _error(ERROR_EXCHANGE_TRANSFER_FAILED);
639         }
640 
641         WithdrawTokens(_recipient, _amount);
642 
643         return OK;
644     }
645 
646     /**
647      * Transfer all tokens from exchange to specified address.
648      *
649      * Can be called only by contract owner.
650      *
651      * @param _recipient address to transfer tokens to.
652      *
653      * @return success.
654      */
655     function withdrawAllTokens(address _recipient) onlyContractOwner returns (uint) {
656         return withdrawTokens(_recipient, _balanceOf(this));
657     }
658 
659     /**
660      * Transfer specified amount of wei from exchange to specified address.
661      *
662      * Can be called only by contract owner.
663      *
664      * @param _recipient address to transfer wei to.
665      * @param _amount amount of wei to transfer.
666      *
667      * @return success.
668      */
669     function withdrawEth(address _recipient, uint _amount) onlyContractOwner returns (uint) {
670         if (this.balance < _amount) {
671             return _error(ERROR_EXCHANGE_INSUFFICIENT_ETHER_SUPPLY);
672         }
673 
674         if (!_recipient.send(_amount)) {
675             return _error(ERROR_EXCHANGE_TRANSFER_FAILED);
676         }
677 
678         WithdrawEth(_recipient, _amount);
679 
680         return OK;
681     }
682 
683     /**
684      * Transfer all wei from exchange to specified address.
685      *
686      * Can be called only by contract owner.
687      *
688      * @param _recipient address to transfer wei to.
689      *
690      * @return success.
691      */
692     function withdrawAllEth(address _recipient) onlyContractOwner() returns (uint) {
693         return withdrawEth(_recipient, this.balance);
694     }
695 
696     /**
697      * Transfer all tokens and wei from exchange to specified address.
698      *
699      * Can be called only by contract owner.
700      *
701      * @param _recipient address to transfer tokens and wei to.
702      *
703      * @return success.
704      */
705     function withdrawAll(address _recipient) onlyContractOwner returns (uint) {
706         uint withdrawAllTokensResult = withdrawAllTokens(_recipient);
707         if (withdrawAllTokensResult != OK) {
708             return withdrawAllTokensResult;
709         }
710 
711         uint withdrawAllEthResult = withdrawAllEth(_recipient);
712         if (withdrawAllEthResult != OK) {
713             return withdrawAllEthResult;
714         }
715 
716         return OK;
717     }
718 
719     function emitError(uint errorCode) {
720         Error(errorCode);
721     }
722 
723     function emitPricesUpdated(uint buyPrice, uint sellPrice) {
724         PricesUpdated(msg.sender, buyPrice, sellPrice);
725     }
726 
727     function emitActiveChanged(bool isActive) {
728         ActiveChanged(msg.sender, isActive);
729     }
730 
731     function getEventsHistory() constant returns (BuyBackEmitter) {
732         return address(eventsHistory) != 0x0 ? eventsHistory : BuyBackEmitter(this);
733     }
734     /**
735      * Overflow-safe multiplication.
736      *
737      * Throws in case of value overflow.
738      *
739      * @param _a first operand.
740      * @param _b second operand.
741      *
742      * @return multiplication result.
743      */
744     function _mul(uint _a, uint _b) internal constant returns (uint) {
745         uint result = _a * _b;
746         if (_a != 0 && result / _a != _b) {
747             throw;
748         }
749         return result;
750     }
751 
752     /**
753      * Accept all ether to maintain exchange supply.
754      */
755     function() payable {
756         if (msg.value != 0) {
757             ReceivedEther(msg.sender, msg.value);
758         } else {
759             throw;
760         }
761     }
762 }