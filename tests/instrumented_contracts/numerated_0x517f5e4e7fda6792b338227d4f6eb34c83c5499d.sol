1 pragma solidity ^0.5.0;
2 
3 interface SwapInterface {
4     // Public variables
5     function brokerFees(address _broker) external view returns (uint256);
6     function redeemedAt(bytes32 _swapID) external view returns(uint256);
7 
8     /// @notice Initiates the atomic swap.
9     ///
10     /// @param _swapID The unique atomic swap id.
11     /// @param _spender The address of the withdrawing trader.
12     /// @param _secretLock The hash of the secret (Hash Lock).
13     /// @param _timelock The unix timestamp when the swap expires.
14     /// @param _value The value of the atomic swap.
15     function initiate(
16         bytes32 _swapID,
17         address payable _spender,
18         bytes32 _secretLock,
19         uint256 _timelock,
20         uint256 _value
21     ) external payable;
22 
23     /// @notice Initiates the atomic swap with broker fees.
24     ///
25     /// @param _swapID The unique atomic swap id.
26     /// @param _spender The address of the withdrawing trader.
27     /// @param _broker The address of the broker.
28     /// @param _brokerFee The fee to be paid to the broker on success.
29     /// @param _secretLock The hash of the secret (Hash Lock).
30     /// @param _timelock The unix timestamp when the swap expires.
31     /// @param _value The value of the atomic swap.
32     function initiateWithFees(
33         bytes32 _swapID,
34         address payable _spender,
35         address payable _broker,
36         uint256 _brokerFee,
37         bytes32 _secretLock,
38         uint256 _timelock,
39         uint256 _value
40     ) external payable;
41 
42     /// @notice Redeems an atomic swap.
43     ///
44     /// @param _swapID The unique atomic swap id.
45     /// @param _receiver The receiver's address.
46     /// @param _secretKey The secret of the atomic swap.
47     function redeem(bytes32 _swapID, address payable _receiver, bytes32 _secretKey) external;
48 
49     /// @notice Redeems an atomic swap to the spender. Can be called by anyone.
50     ///
51     /// @param _swapID The unique atomic swap id.
52     /// @param _secretKey The secret of the atomic swap.
53     function redeemToSpender(bytes32 _swapID, bytes32 _secretKey) external;
54 
55     /// @notice Refunds an atomic swap.
56     ///
57     /// @param _swapID The unique atomic swap id.
58     function refund(bytes32 _swapID) external;
59 
60     /// @notice Allows broker fee withdrawals.
61     ///
62     /// @param _amount The withdrawal amount.
63     function withdrawBrokerFees(uint256 _amount) external;
64 
65     /// @notice Audits an atomic swap.
66     ///
67     /// @param _swapID The unique atomic swap id.
68     function audit(
69         bytes32 _swapID
70     ) external view returns (
71         uint256 timelock,
72         uint256 value,
73         address to, uint256 brokerFee,
74         address broker,
75         address from,
76         bytes32 secretLock
77     );
78 
79     /// @notice Audits the secret of an atomic swap.
80     ///
81     /// @param _swapID The unique atomic swap id.
82     function auditSecret(bytes32 _swapID) external view  returns (bytes32 secretKey);
83 
84     /// @notice Checks whether a swap is refundable or not.
85     ///
86     /// @param _swapID The unique atomic swap id.
87     function refundable(bytes32 _swapID) external view returns (bool);
88 
89     /// @notice Checks whether a swap is initiatable or not.
90     ///
91     /// @param _swapID The unique atomic swap id.
92     function initiatable(bytes32 _swapID) external view returns (bool);
93 
94     /// @notice Checks whether a swap is redeemable or not.
95     ///
96     /// @param _swapID The unique atomic swap id.
97     function redeemable(bytes32 _swapID) external view returns (bool);
98 
99     /// @notice Generates a deterministic swap id using initiate swap details.
100     ///
101     /// @param _secretLock The hash of the secret.
102     /// @param _timelock The expiry timestamp.
103     function swapID(bytes32 _secretLock, uint256 _timelock) external pure returns (bytes32);
104 }
105 
106 contract BaseSwap is SwapInterface {
107     string public VERSION; // Passed in as a constructor parameter.
108 
109     struct Swap {
110         uint256 timelock;
111         uint256 value;
112         uint256 brokerFee;
113         bytes32 secretLock;
114         bytes32 secretKey;
115         address payable funder;
116         address payable spender;
117         address payable broker;
118     }
119 
120     enum States {
121         INVALID,
122         OPEN,
123         CLOSED,
124         EXPIRED
125     }
126 
127     // Events
128     event LogOpen(bytes32 _swapID, address _spender, bytes32 _secretLock);
129     event LogExpire(bytes32 _swapID);
130     event LogClose(bytes32 _swapID, bytes32 _secretKey);
131 
132     // Storage
133     mapping (bytes32 => Swap) internal swaps;
134     mapping (bytes32 => States) private _swapStates;
135     mapping (address => uint256) private _brokerFees;
136     mapping (bytes32 => uint256) private _redeemedAt;
137 
138     /// @notice Throws if the swap is not invalid (i.e. has already been opened)
139     modifier onlyInvalidSwaps(bytes32 _swapID) {
140         require(_swapStates[_swapID] == States.INVALID, "swap opened previously");
141         _;
142     }
143 
144     /// @notice Throws if the swap is not open.
145     modifier onlyOpenSwaps(bytes32 _swapID) {
146         require(_swapStates[_swapID] == States.OPEN, "swap not open");
147         _;
148     }
149 
150     /// @notice Throws if the swap is not closed.
151     modifier onlyClosedSwaps(bytes32 _swapID) {
152         require(_swapStates[_swapID] == States.CLOSED, "swap not redeemed");
153         _;
154     }
155 
156     /// @notice Throws if the swap is not expirable.
157     modifier onlyExpirableSwaps(bytes32 _swapID) {
158         /* solium-disable-next-line security/no-block-members */
159         require(now >= swaps[_swapID].timelock, "swap not expirable");
160         _;
161     }
162 
163     /// @notice Throws if the secret key is not valid.
164     modifier onlyWithSecretKey(bytes32 _swapID, bytes32 _secretKey) {
165         require(swaps[_swapID].secretLock == sha256(abi.encodePacked(_secretKey)), "invalid secret");
166         _;
167     }
168 
169     /// @notice Throws if the caller is not the authorized spender.
170     modifier onlySpender(bytes32 _swapID, address _spender) {
171         require(swaps[_swapID].spender == _spender, "unauthorized spender");
172         _;
173     }
174 
175     /// @notice The contract constructor.
176     ///
177     /// @param _VERSION A string defining the contract version.
178     constructor(string memory _VERSION) public {
179         VERSION = _VERSION;
180     }
181 
182     /// @notice Initiates the atomic swap.
183     ///
184     /// @param _swapID The unique atomic swap id.
185     /// @param _spender The address of the withdrawing trader.
186     /// @param _secretLock The hash of the secret (Hash Lock).
187     /// @param _timelock The unix timestamp when the swap expires.
188     /// @param _value The value of the atomic swap.
189     function initiate(
190         bytes32 _swapID,
191         address payable _spender,
192         bytes32 _secretLock,
193         uint256 _timelock,
194         uint256 _value
195     ) public onlyInvalidSwaps(_swapID) payable {
196         // Store the details of the swap.
197         Swap memory swap = Swap({
198             timelock: _timelock,
199             brokerFee: 0,
200             value: _value,
201             funder: msg.sender,
202             spender: _spender,
203             broker: address(0x0),
204             secretLock: _secretLock,
205             secretKey: 0x0
206         });
207         swaps[_swapID] = swap;
208         _swapStates[_swapID] = States.OPEN;
209 
210         // Logs open event
211         emit LogOpen(_swapID, _spender, _secretLock);
212     }
213 
214     /// @notice Initiates the atomic swap with fees.
215     ///
216     /// @param _swapID The unique atomic swap id.
217     /// @param _spender The address of the withdrawing trader.
218     /// @param _broker The address of the broker.
219     /// @param _brokerFee The fee to be paid to the broker on success.
220     /// @param _secretLock The hash of the secret (Hash Lock).
221     /// @param _timelock The unix timestamp when the swap expires.
222     /// @param _value The value of the atomic swap.
223     function initiateWithFees(
224         bytes32 _swapID,
225         address payable _spender,
226         address payable _broker,
227         uint256 _brokerFee,
228         bytes32 _secretLock,
229         uint256 _timelock,
230         uint256 _value
231     ) public onlyInvalidSwaps(_swapID) payable {
232         require(_value >= _brokerFee, "fee must be less than value");
233 
234         // Store the details of the swap.
235         Swap memory swap = Swap({
236             timelock: _timelock,
237             brokerFee: _brokerFee,
238             value: _value - _brokerFee,
239             funder: msg.sender,
240             spender: _spender,
241             broker: _broker,
242             secretLock: _secretLock,
243             secretKey: 0x0
244         });
245         swaps[_swapID] = swap;
246         _swapStates[_swapID] = States.OPEN;
247 
248         // Logs open event
249         emit LogOpen(_swapID, _spender, _secretLock);
250     }
251 
252     /// @notice Redeems an atomic swap.
253     ///
254     /// @param _swapID The unique atomic swap id.
255     /// @param _receiver The receiver's address.
256     /// @param _secretKey The secret of the atomic swap.
257     function redeem(bytes32 _swapID, address payable _receiver, bytes32 _secretKey) public onlyOpenSwaps(_swapID) onlyWithSecretKey(_swapID, _secretKey) onlySpender(_swapID, msg.sender) {
258         require(_receiver != address(0x0), "invalid receiver");
259 
260         // Close the swap.
261         swaps[_swapID].secretKey = _secretKey;
262         _swapStates[_swapID] = States.CLOSED;
263         /* solium-disable-next-line security/no-block-members */
264         _redeemedAt[_swapID] = now;
265 
266         // Update the broker fees to the broker.
267         _brokerFees[swaps[_swapID].broker] += swaps[_swapID].brokerFee;
268 
269         // Logs close event
270         emit LogClose(_swapID, _secretKey);
271     }
272 
273     /// @notice Redeems an atomic swap to the spender. Can be called by anyone.
274     ///
275     /// @param _swapID The unique atomic swap id.
276     /// @param _secretKey The secret of the atomic swap.
277     function redeemToSpender(bytes32 _swapID, bytes32 _secretKey) public onlyOpenSwaps(_swapID) onlyWithSecretKey(_swapID, _secretKey) {
278         // Close the swap.
279         swaps[_swapID].secretKey = _secretKey;
280         _swapStates[_swapID] = States.CLOSED;
281         /* solium-disable-next-line security/no-block-members */
282         _redeemedAt[_swapID] = now;
283 
284         // Update the broker fees to the broker.
285         _brokerFees[swaps[_swapID].broker] += swaps[_swapID].brokerFee;
286 
287         // Logs close event
288         emit LogClose(_swapID, _secretKey);
289     }
290 
291     /// @notice Refunds an atomic swap.
292     ///
293     /// @param _swapID The unique atomic swap id.
294     function refund(bytes32 _swapID) public onlyOpenSwaps(_swapID) onlyExpirableSwaps(_swapID) {
295         // Expire the swap.
296         _swapStates[_swapID] = States.EXPIRED;
297 
298         // Logs expire event
299         emit LogExpire(_swapID);
300     }
301 
302     /// @notice Allows broker fee withdrawals.
303     ///
304     /// @param _amount The withdrawal amount.
305     function withdrawBrokerFees(uint256 _amount) public {
306         require(_amount <= _brokerFees[msg.sender], "insufficient withdrawable fees");
307         _brokerFees[msg.sender] -= _amount;
308     }
309 
310     /// @notice Audits an atomic swap.
311     ///
312     /// @param _swapID The unique atomic swap id.
313     function audit(bytes32 _swapID) external view returns (uint256 timelock, uint256 value, address to, uint256 brokerFee, address broker, address from, bytes32 secretLock) {
314         Swap memory swap = swaps[_swapID];
315         return (
316             swap.timelock,
317             swap.value,
318             swap.spender,
319             swap.brokerFee,
320             swap.broker,
321             swap.funder,
322             swap.secretLock
323         );
324     }
325 
326     /// @notice Audits the secret of an atomic swap.
327     ///
328     /// @param _swapID The unique atomic swap id.
329     function auditSecret(bytes32 _swapID) external view onlyClosedSwaps(_swapID) returns (bytes32 secretKey) {
330         return swaps[_swapID].secretKey;
331     }
332 
333     /// @notice Checks whether a swap is refundable or not.
334     ///
335     /// @param _swapID The unique atomic swap id.
336     function refundable(bytes32 _swapID) external view returns (bool) {
337         /* solium-disable-next-line security/no-block-members */
338         return (now >= swaps[_swapID].timelock && _swapStates[_swapID] == States.OPEN);
339     }
340 
341     /// @notice Checks whether a swap is initiatable or not.
342     ///
343     /// @param _swapID The unique atomic swap id.
344     function initiatable(bytes32 _swapID) external view returns (bool) {
345         return (_swapStates[_swapID] == States.INVALID);
346     }
347 
348     /// @notice Checks whether a swap is redeemable or not.
349     ///
350     /// @param _swapID The unique atomic swap id.
351     function redeemable(bytes32 _swapID) external view returns (bool) {
352         return (_swapStates[_swapID] == States.OPEN);
353     }
354 
355     function redeemedAt(bytes32 _swapID) external view returns (uint256) {
356         return _redeemedAt[_swapID];
357     }
358 
359     function brokerFees(address _broker) external view returns (uint256) {
360         return _brokerFees[_broker];
361     }
362 
363     /// @notice Generates a deterministic swap id using initiate swap details.
364     ///
365     /// @param _secretLock The hash of the secret.
366     /// @param _timelock The expiry timestamp.
367     function swapID(bytes32 _secretLock, uint256 _timelock) external pure returns (bytes32) {
368         return keccak256(abi.encodePacked(_secretLock, _timelock));
369     }
370 }
371 
372 /**
373  * @title SafeMath
374  * @dev Unsigned math operations with safety checks that revert on error
375  */
376 library SafeMath {
377     /**
378     * @dev Multiplies two unsigned integers, reverts on overflow.
379     */
380     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
381         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
382         // benefit is lost if 'b' is also tested.
383         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
384         if (a == 0) {
385             return 0;
386         }
387 
388         uint256 c = a * b;
389         require(c / a == b);
390 
391         return c;
392     }
393 
394     /**
395     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
396     */
397     function div(uint256 a, uint256 b) internal pure returns (uint256) {
398         // Solidity only automatically asserts when dividing by 0
399         require(b > 0);
400         uint256 c = a / b;
401         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
402 
403         return c;
404     }
405 
406     /**
407     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
408     */
409     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
410         require(b <= a);
411         uint256 c = a - b;
412 
413         return c;
414     }
415 
416     /**
417     * @dev Adds two unsigned integers, reverts on overflow.
418     */
419     function add(uint256 a, uint256 b) internal pure returns (uint256) {
420         uint256 c = a + b;
421         require(c >= a);
422 
423         return c;
424     }
425 
426     /**
427     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
428     * reverts when dividing by zero.
429     */
430     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
431         require(b != 0);
432         return a % b;
433     }
434 }
435 
436 /**
437  * @title Math
438  * @dev Assorted math operations
439  */
440 library Math {
441     /**
442     * @dev Returns the largest of two numbers.
443     */
444     function max(uint256 a, uint256 b) internal pure returns (uint256) {
445         return a >= b ? a : b;
446     }
447 
448     /**
449     * @dev Returns the smallest of two numbers.
450     */
451     function min(uint256 a, uint256 b) internal pure returns (uint256) {
452         return a < b ? a : b;
453     }
454 
455     /**
456     * @dev Calculates the average of two numbers. Since these are integers,
457     * averages of an even and odd number cannot be represented, and will be
458     * rounded down.
459     */
460     function average(uint256 a, uint256 b) internal pure returns (uint256) {
461         // (a + b) / 2 can overflow, so we distribute
462         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
463     }
464 }
465 
466 /// @notice Implements safeTransfer, safeTransferFrom and
467 /// safeApprove for CompatibleERC20.
468 ///
469 /// See https://github.com/ethereum/solidity/issues/4116
470 ///
471 /// This library allows interacting with ERC20 tokens that implement any of
472 /// these interfaces:
473 ///
474 /// (1) transfer returns true on success, false on failure
475 /// (2) transfer returns true on success, reverts on failure
476 /// (3) transfer returns nothing on success, reverts on failure
477 ///
478 /// Additionally, safeTransferFromWithFees will return the final token
479 /// value received after accounting for token fees.
480 library CompatibleERC20Functions {
481     using SafeMath for uint256;
482 
483     /// @notice Calls transfer on the token and reverts if the call fails.
484     function safeTransfer(CompatibleERC20 self, address to, uint256 amount) internal {
485         self.transfer(to, amount);
486         require(previousReturnValue(), "transfer failed");
487     }
488 
489     /// @notice Calls transferFrom on the token and reverts if the call fails.
490     function safeTransferFrom(CompatibleERC20 self, address from, address to, uint256 amount) internal {
491         self.transferFrom(from, to, amount);
492         require(previousReturnValue(), "transferFrom failed");
493     }
494 
495     /// @notice Calls approve on the token and reverts if the call fails.
496     function safeApprove(CompatibleERC20 self, address spender, uint256 amount) internal {
497         self.approve(spender, amount);
498         require(previousReturnValue(), "approve failed");
499     }
500 
501     /// @notice Calls transferFrom on the token, reverts if the call fails and
502     /// returns the value transferred after fees.
503     function safeTransferFromWithFees(CompatibleERC20 self, address from, address to, uint256 amount) internal returns (uint256) {
504         uint256 balancesBefore = self.balanceOf(to);
505         self.transferFrom(from, to, amount);
506         require(previousReturnValue(), "transferFrom failed");
507         uint256 balancesAfter = self.balanceOf(to);
508         return Math.min(amount, balancesAfter.sub(balancesBefore));
509     }
510 
511     /// @notice Checks the return value of the previous function. Returns true
512     /// if the previous function returned 32 non-zero bytes or returned zero
513     /// bytes.
514     function previousReturnValue() private pure returns (bool)
515     {
516         uint256 returnData = 0;
517 
518         assembly { /* solium-disable-line security/no-inline-assembly */
519             // Switch on the number of bytes returned by the previous call
520             switch returndatasize
521 
522             // 0 bytes: ERC20 of type (3), did not throw
523             case 0 {
524                 returnData := 1
525             }
526 
527             // 32 bytes: ERC20 of types (1) or (2)
528             case 32 {
529                 // Copy the return data into scratch space
530                 returndatacopy(0, 0, 32)
531 
532                 // Load  the return data into returnData
533                 returnData := mload(0)
534             }
535 
536             // Other return size: return false
537             default { }
538         }
539 
540         return returnData != 0;
541     }
542 }
543 
544 /// @notice ERC20 interface which doesn't specify the return type for transfer,
545 /// transferFrom and approve.
546 interface CompatibleERC20 {
547     // Modified to not return boolean
548     function transfer(address to, uint256 value) external;
549     function transferFrom(address from, address to, uint256 value) external;
550     function approve(address spender, uint256 value) external;
551 
552     // Not modifier
553     function totalSupply() external view returns (uint256);
554     function balanceOf(address who) external view returns (uint256);
555     function allowance(address owner, address spender) external view returns (uint256);
556     event Transfer(address indexed from, address indexed to, uint256 value);
557     event Approval(address indexed owner, address indexed spender, uint256 value);
558 }
559 
560 /// @notice ERC20Swap implements the ERC20Swap interface.
561 contract ERC20Swap is SwapInterface, BaseSwap {
562     using CompatibleERC20Functions for CompatibleERC20;
563 
564     address public TOKEN_ADDRESS; // Address of the ERC20 contract. Passed in as a constructor parameter
565 
566     /// @notice The contract constructor.
567     ///
568     /// @param _VERSION A string defining the contract version.
569     constructor(string memory _VERSION, address _TOKEN_ADDRESS) BaseSwap(_VERSION) public {
570         TOKEN_ADDRESS = _TOKEN_ADDRESS;
571     }
572 
573     /// @notice Initiates the atomic swap.
574     ///
575     /// @param _swapID The unique atomic swap id.
576     /// @param _spender The address of the withdrawing trader.
577     /// @param _secretLock The hash of the secret (Hash Lock).
578     /// @param _timelock The unix timestamp when the swap expires.
579     /// @param _value The value of the atomic swap.
580     function initiate(
581         bytes32 _swapID,
582         address payable _spender,
583         bytes32 _secretLock,
584         uint256 _timelock,
585         uint256 _value
586     ) public payable {
587         // To abide by the interface, the function is payable but throws if
588         // msg.value is non-zero
589         require(msg.value == 0, "eth value must be zero");
590         require(_spender != address(0x0), "spender must not be zero");
591 
592         // Transfer the token to the contract
593         // TODO: Initiator will first need to call
594         // ERC20(TOKEN_ADDRESS).approve(address(this), _value)
595         // before this contract can make transfers on the initiator's behalf.
596         CompatibleERC20(TOKEN_ADDRESS).safeTransferFrom(msg.sender, address(this), _value);
597 
598         BaseSwap.initiate(
599             _swapID,
600             _spender,
601             _secretLock,
602             _timelock,
603             _value
604         );
605     }
606 
607     /// @notice Initiates the atomic swap with broker fees.
608     ///
609     /// @param _swapID The unique atomic swap id.
610     /// @param _spender The address of the withdrawing trader.
611     /// @param _broker The address of the broker.
612     /// @param _brokerFee The fee to be paid to the broker on success.
613     /// @param _secretLock The hash of the secret (Hash Lock).
614     /// @param _timelock The unix timestamp when the swap expires.
615     /// @param _value The value of the atomic swap.
616     function initiateWithFees(
617         bytes32 _swapID,
618         address payable _spender,
619         address payable _broker,
620         uint256 _brokerFee,
621         bytes32 _secretLock,
622         uint256 _timelock,
623         uint256 _value
624     ) public payable {
625         // To abide by the interface, the function is payable but throws if
626         // msg.value is non-zero
627         require(msg.value == 0, "eth value must be zero");
628         require(_spender != address(0x0), "spender must not be zero");
629 
630         // Transfer the token to the contract
631         // TODO: Initiator will first need to call
632         // ERC20(TOKEN_ADDRESS).approve(address(this), _value)
633         // before this contract can make transfers on the initiator's behalf.
634         CompatibleERC20(TOKEN_ADDRESS).safeTransferFrom(msg.sender, address(this), _value);
635 
636         BaseSwap.initiateWithFees(
637             _swapID,
638             _spender,
639             _broker,
640             _brokerFee,
641             _secretLock,
642             _timelock,
643             _value
644         );
645     }
646 
647     /// @notice Redeems an atomic swap.
648     ///
649     /// @param _swapID The unique atomic swap id.
650     /// @param _secretKey The secret of the atomic swap.
651     function redeem(bytes32 _swapID, address payable _receiver, bytes32 _secretKey) public {
652         BaseSwap.redeem(
653             _swapID,
654             _receiver,
655             _secretKey
656         );
657 
658         // Transfer the ERC20 funds from this contract to the withdrawing trader.
659         CompatibleERC20(TOKEN_ADDRESS).safeTransfer(_receiver, swaps[_swapID].value);
660     }
661 
662     /// @notice Redeems an atomic swap to the spender. Can be called by anyone.
663     ///
664     /// @param _swapID The unique atomic swap id.
665     /// @param _secretKey The secret of the atomic swap.
666     function redeemToSpender(bytes32 _swapID, bytes32 _secretKey) public {
667         BaseSwap.redeemToSpender(
668             _swapID,
669             _secretKey
670         );
671 
672         // Transfer the ERC20 funds from this contract to the withdrawing trader.
673         CompatibleERC20(TOKEN_ADDRESS).safeTransfer(swaps[_swapID].spender, swaps[_swapID].value);
674     }
675 
676     /// @notice Refunds an atomic swap.
677     ///
678     /// @param _swapID The unique atomic swap id.
679     function refund(bytes32 _swapID) public {
680         BaseSwap.refund(_swapID);
681 
682         // Transfer the ERC20 value from this contract back to the funding trader.
683         CompatibleERC20(TOKEN_ADDRESS).safeTransfer(swaps[_swapID].funder, swaps[_swapID].value + swaps[_swapID].brokerFee);
684     }
685 
686     /// @notice Allows broker fee withdrawals.
687     ///
688     /// @param _amount The withdrawal amount.
689     function withdrawBrokerFees(uint256 _amount) public {
690         BaseSwap.withdrawBrokerFees(_amount);
691 
692         CompatibleERC20(TOKEN_ADDRESS).safeTransfer(msg.sender, _amount);
693     }
694 }