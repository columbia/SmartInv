1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.7.x;
3 
4 /**
5  * @dev Wrappers over Solidity's arithmetic operations with added overflow
6  * checks.
7  *
8  * Arithmetic operations in Solidity wrap on overflow. This can easily result
9  * in bugs, because programmers usually assume that an overflow raises an
10  * error, which is the standard behavior in high level programming languages.
11  * `SafeMath` restores this intuition by reverting the transaction when an
12  * operation overflows.
13  *
14  * Using this library instead of the unchecked operations eliminates an entire
15  * class of bugs, so it's recommended to use it always.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, reverting on
20      * overflow.
21      *
22      * Counterpart to Solidity's `+` operator.
23      *
24      * Requirements:
25      * - Addition cannot overflow.
26      */
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "SafeMath: addition overflow");
30 
31         return c;
32     }
33 
34     /**
35      * @dev Returns the subtraction of two unsigned integers, reverting on
36      * overflow (when the result is negative).
37      *
38      * Counterpart to Solidity's `-` operator.
39      *
40      * Requirements:
41      * - Subtraction cannot overflow.
42      */
43     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44         return sub(a, b, "SafeMath: subtraction overflow");
45     }
46 
47     /**
48      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
49      * overflow (when the result is negative).
50      *
51      * Counterpart to Solidity's `-` operator.
52      *
53      * Requirements:
54      * - Subtraction cannot overflow.
55      *
56      * _Available since v2.4.0._
57      */
58     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b <= a, errorMessage);
60         uint256 c = a - b;
61 
62         return c;
63     }
64 
65     /**
66      * @dev Returns the multiplication of two unsigned integers, reverting on
67      * overflow.
68      *
69      * Counterpart to Solidity's `*` operator.
70      *
71      * Requirements:
72      * - Multiplication cannot overflow.
73      */
74     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
75         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
76         // benefit is lost if 'b' is also tested.
77         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
78         if (a == 0) {
79             return 0;
80         }
81 
82         uint256 c = a * b;
83         require(c / a == b, "SafeMath: multiplication overflow");
84 
85         return c;
86     }
87 
88     /**
89      * @dev Returns the integer division of two unsigned integers. Reverts on
90      * division by zero. The result is rounded towards zero.
91      *
92      * Counterpart to Solidity's `/` operator. Note: this function uses a
93      * `revert` opcode (which leaves remaining gas untouched) while Solidity
94      * uses an invalid opcode to revert (consuming all remaining gas).
95      *
96      * Requirements:
97      * - The divisor cannot be zero.
98      */
99     function div(uint256 a, uint256 b) internal pure returns (uint256) {
100         return div(a, b, "SafeMath: division by zero");
101     }
102 
103     /**
104      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
105      * division by zero. The result is rounded towards zero.
106      *
107      * Counterpart to Solidity's `/` operator. Note: this function uses a
108      * `revert` opcode (which leaves remaining gas untouched) while Solidity
109      * uses an invalid opcode to revert (consuming all remaining gas).
110      *
111      * Requirements:
112      * - The divisor cannot be zero.
113      *
114      * _Available since v2.4.0._
115      */
116     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
117         // Solidity only automatically asserts when dividing by 0
118         require(b > 0, errorMessage);
119         uint256 c = a / b;
120         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
121 
122         return c;
123     }
124 
125     /**
126      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
127      * Reverts when dividing by zero.
128      *
129      * Counterpart to Solidity's `%` operator. This function uses a `revert`
130      * opcode (which leaves remaining gas untouched) while Solidity uses an
131      * invalid opcode to revert (consuming all remaining gas).
132      *
133      * Requirements:
134      * - The divisor cannot be zero.
135      */
136     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
137         return mod(a, b, "SafeMath: modulo by zero");
138     }
139 
140     /**
141      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
142      * Reverts with custom message when dividing by zero.
143      *
144      * Counterpart to Solidity's `%` operator. This function uses a `revert`
145      * opcode (which leaves remaining gas untouched) while Solidity uses an
146      * invalid opcode to revert (consuming all remaining gas).
147      *
148      * Requirements:
149      * - The divisor cannot be zero.
150      *
151      * _Available since v2.4.0._
152      */
153     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
154         require(b != 0, errorMessage);
155         return a % b;
156     }
157 }
158 
159 
160 /*
161  * @dev Provides information about the current execution context, including the
162  * sender of the transaction and its data. While these are generally available
163  * via msg.sender and msg.data, they should not be accessed in such a direct
164  * manner, since when dealing with GSN meta-transactions the account sending and
165  * paying for execution may not be the actual sender (as far as an application
166  * is concerned).
167  *
168  * This contract is only required for intermediate, library-like contracts.
169  */
170 contract Context {
171     // Empty internal constructor, to prevent people from mistakenly deploying
172     // an instance of this contract, which should be used via inheritance.
173     constructor () {}
174     // solhint-disable-previous-line no-empty-blocks
175 
176     function _msgSender() internal view returns (address payable) {
177         return msg.sender;
178     }
179 
180     function _msgData() internal view returns (bytes memory) {
181         this;
182         // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
183         return msg.data;
184     }
185 }
186 
187 /**
188  * @dev Contract module which provides a basic access control mechanism, where
189  * there is an account (an owner) that can be granted exclusive access to
190  * specific functions.
191  *
192  * This module is used through inheritance. It will make available the modifier
193  * `onlyOwner`, which can be applied to your functions to restrict their use to
194  * the owner.
195  */
196 contract Ownable is Context {
197     address private _owner;
198 
199     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
200 
201     /**
202      * @dev Initializes the contract setting the deployer as the initial owner.
203      */
204     constructor () {
205         address msgSender = _msgSender();
206         _owner = msgSender;
207         emit OwnershipTransferred(address(0), msgSender);
208     }
209 
210     /**
211      * @dev Returns the address of the current owner.
212      */
213     function owner() public view returns (address) {
214         return _owner;
215     }
216 
217     /**
218      * @dev Throws if called by any account other than the owner.
219      */
220     modifier onlyOwner() {
221         require(isOwner(), "Ownable: caller is not the owner");
222         _;
223     }
224 
225     /**
226      * @dev Returns true if the caller is the current owner.
227      */
228     function isOwner() public view returns (bool) {
229         return _msgSender() == _owner;
230     }
231 
232     /**
233      * @dev Leaves the contract without owner. It will not be possible to call
234      * `onlyOwner` functions anymore. Can only be called by the current owner.
235      *
236      * NOTE: Renouncing ownership will leave the contract without an owner,
237      * thereby removing any functionality that is only available to the owner.
238      */
239     function renounceOwnership() public onlyOwner {
240         emit OwnershipTransferred(_owner, address(0));
241         _owner = address(0);
242     }
243 
244     /**
245      * @dev Transfers ownership of the contract to a new account (`newOwner`).
246      * Can only be called by the current owner.
247      */
248     function transferOwnership(address newOwner) public onlyOwner {
249         _transferOwnership(newOwner);
250     }
251 
252     /**
253      * @dev Transfers ownership of the contract to a new account (`newOwner`).
254      */
255     function _transferOwnership(address newOwner) internal {
256         require(newOwner != address(0), "Ownable: new owner is the zero address");
257         emit OwnershipTransferred(_owner, newOwner);
258         _owner = newOwner;
259     }
260 }
261 
262 
263 abstract contract Token_interface {
264     function owner() public view virtual returns (address);
265 
266     function decimals() public view virtual returns (uint8);
267 
268     function balanceOf(address who) public view virtual returns (uint256);
269 
270     function transfer(address _to, uint256 _value) public virtual returns (bool);
271 
272     function allowance(address _owner, address _spender) public virtual returns (uint);
273 
274     function transferFrom(address _from, address _to, uint _value) public virtual returns (bool);
275 }
276 
277 contract MultiSigPermission is Context {
278 
279     uint constant public MAX_OWNER_COUNT = 3;
280 
281     event Confirmation(address indexed sender, uint indexed transactionId);
282     event Revocation(address indexed sender, uint indexed transactionId);
283     event Submission(uint indexed transactionId);
284     event Execution(uint indexed transactionId);
285     event ExecutionFailure(uint indexed transactionId);
286     event Deposit(address indexed sender, uint value);
287     event SignRoleAddition(address indexed signRoleAddress);
288     event SignRoleRemoval(address indexed signRoleAddress);
289     event RequirementChange(uint required);
290 
291     mapping (uint => Transaction) public transactions;
292     mapping (uint => mapping (address => bool)) public confirmations;
293     mapping (address => bool) public isSignRole;
294     address[] public signRoleAddresses;
295     uint public required;
296     uint public transactionCount;
297 
298     struct Transaction {
299         address destination;
300         uint value;
301         bytes data;
302         bool executed;
303     }
304 
305     modifier signRoleAddresseExists(address signRoleAddress) {
306         require(isSignRole[signRoleAddress], "Role doesn't exists");
307         _;
308     }
309 
310     modifier transactionExists(uint transactionId) {
311         require(transactions[transactionId].destination != address(0), "Transaction doesn't exists");
312         _;
313     }
314 
315     modifier confirmed(uint transactionId, address signRoleAddress) {
316         require(confirmations[transactionId][signRoleAddress], "Transaction didn't confirm");
317         _;
318     }
319 
320     modifier notConfirmed(uint transactionId, address signRoleAddress) {
321         require(!confirmations[transactionId][signRoleAddress], "Transaction already confirmed");
322         _;
323     }
324 
325     modifier notExecuted(uint transactionId) {
326         require(!transactions[transactionId].executed, "Transaction already executed");
327         _;
328     }
329 
330     modifier notNull(address _address) {
331         require(_address != address(0), "address is 0");
332         _;
333     }
334 
335     modifier validRequirement(uint signRoleAddresseCount, uint _required) {
336         require(signRoleAddresseCount <= MAX_OWNER_COUNT
337             && _required <= signRoleAddresseCount
338             && _required != 0
339             && signRoleAddresseCount != 0, "Not valid required count");
340         _;
341     }
342 
343     constructor(uint _required)
344     {
345         required = _required;
346     }
347 
348     /// @dev Returns the confirmation status of a transaction.
349     /// @param transactionId Transaction ID.
350     /// @return Confirmation status.
351     function isConfirmed(uint transactionId)
352         public
353         view returns (bool)
354     {
355         uint count = 0;
356         for (uint i=0; i<signRoleAddresses.length; i++) {
357             if (confirmations[transactionId][signRoleAddresses[i]])
358                 count += 1;
359             if (count == required)
360                 return true;
361         }
362         return false;
363     }
364 
365     function checkSignRoleExists(address signRoleAddress)
366         public
367         view returns (bool)
368     {
369         return isSignRole[signRoleAddress];
370     }
371 
372 
373 
374     /// @dev Allows an signRoleAddress to confirm a transaction.
375     /// @param transactionId Transaction ID.
376     function confirmTransaction(uint transactionId)
377         public
378         signRoleAddresseExists(_msgSender())
379         transactionExists(transactionId)
380         notConfirmed(transactionId, _msgSender())
381     {
382         confirmations[transactionId][_msgSender()] = true;
383         Confirmation(_msgSender(), transactionId);
384         executeTransaction(transactionId);
385     }
386 
387     /// @dev Allows anyone to execute a confirmed transaction.
388     /// @param transactionId Transaction ID.
389     function executeTransaction(uint transactionId)
390         private
391         signRoleAddresseExists(_msgSender())
392         notExecuted(transactionId)
393     {
394         if (isConfirmed(transactionId)) {
395             transactions[transactionId].executed = true;
396             (bool success,) = transactions[transactionId].destination.call{value : transactions[transactionId].value}(transactions[transactionId].data);
397             if (success)
398                 Execution(transactionId);
399             else {
400                 ExecutionFailure(transactionId);
401                 transactions[transactionId].executed = false;
402             }
403         }
404     }
405 
406 
407     /*
408      * Internal functions
409      */
410     function addTransaction(address destination, uint value, bytes memory data)
411         internal
412         notNull(destination)
413         returns (uint transactionId)
414     {
415         transactionId = transactionCount;
416         transactions[transactionId] = Transaction({
417             destination: destination,
418             value: value,
419             data: data,
420             executed: false
421         });
422         transactionCount += 1;
423         Submission(transactionId);
424     }
425 
426     function submitTransaction(address destination, uint value, bytes memory data)
427         internal
428         returns (uint transactionId)
429     {
430         transactionId = addTransaction(destination, value, data);
431         confirmTransaction(transactionId);
432     }
433 
434     function addSignRole(address signRoleAddress)
435         internal
436     {
437         require(signRoleAddress != address(0), "Address cannot be null");
438         require(signRoleAddresses.length + 1 <= MAX_OWNER_COUNT, "Address qty cannot be more then max admins value");
439         require(!checkSignRoleExists(signRoleAddress), "Address already exists");
440 
441         isSignRole[signRoleAddress] = true;
442         signRoleAddresses.push(signRoleAddress);
443         SignRoleAddition(signRoleAddress);
444     }
445 
446 }
447 
448 
449 contract AdminRole is Context, MultiSigPermission {
450 
451     uint constant public REQUIRED_CONFIRMATIONS_COUNT = 2;
452     
453     constructor () MultiSigPermission(REQUIRED_CONFIRMATIONS_COUNT) {
454         addSignRole(_msgSender());
455         addSignRole(address(0x42586d48C29651f32FC65b8e1D1d0E6ebAD28206));
456         addSignRole(address(0x160e529055D084add9634fE1c2059109c8CE044e));
457     }
458 
459     modifier onlyOwnerOrAdmin() {
460         require(checkSignRoleExists(_msgSender()), "you don't have permission to perform that action");
461         _;
462     }
463 }
464 
465 
466 library TxDataBuilder {
467     string constant public RTTD_FUNCHASH = '0829d713'; // WizRefund - refundTokensTransferredDirectly
468     string constant public EFWD_FUNCHASH = 'eee48b02'; // WizRefund - clearFinalWithdrawData
469     string constant public FR_FUNCHASH =   '492b2b37'; // WizRefund - forceRegister
470     string constant public RP_FUNCHASH =   '422a042e'; // WizRefund - revertPhase
471     string constant public WETH_FUNCHASH =   '4782f779'; // WizRefund - withdrawETH
472 
473     function uint2bytes32(uint256 x)
474         public
475         pure returns (bytes memory b) {
476             b = new bytes(32);
477             assembly { mstore(add(b, 32), x) }
478     }
479     
480     function uint2bytes8(uint256 x)
481         public
482         pure returns (bytes memory b) {
483             b = new bytes(32);
484             assembly { mstore(add(b, 32), x) }
485     }
486     
487     function concatb(bytes memory self, bytes memory other)
488         public
489         pure returns (bytes memory) {
490              return bytes(abi.encodePacked(self, other));
491         }
492         
493     // Convert an hexadecimal character to their value
494     function fromHexChar(uint8 c) public pure returns (uint8) {
495         if (bytes1(c) >= bytes1('0') && bytes1(c) <= bytes1('9')) {
496             return c - uint8(bytes1('0'));
497         }
498         if (bytes1(c) >= bytes1('a') && bytes1(c) <= bytes1('f')) {
499             return 10 + c - uint8(bytes1('a'));
500         }
501         if (bytes1(c) >= bytes1('A') && bytes1(c) <= bytes1('F')) {
502             return 10 + c - uint8(bytes1('A'));
503         }
504         require(false, "unknown variant");
505     }
506     
507     // Convert an hexadecimal string to raw bytes
508     function fromHex(string memory s) public pure returns (bytes memory) {
509         bytes memory ss = bytes(s);
510         require(ss.length%2 == 0); // length must be even
511         bytes memory r = new bytes(ss.length/2);
512         for (uint i=0; i<ss.length/2; ++i) {
513             r[i] = bytes1(fromHexChar(uint8(ss[2*i])) * 16 +
514                         fromHexChar(uint8(ss[2*i+1])));
515         }
516         return r;
517     }
518 
519     function buildData(string memory function_hash, uint256[] memory argv)
520         public
521         pure returns (bytes memory data){
522             bytes memory f = fromHex(function_hash);
523             data = concatb(data, f);
524             for(uint i=0;i<argv.length;i++){
525                 bytes memory d = uint2bytes32(argv[i]);
526                 data = concatb(data, d);
527             }
528     }
529 }
530 
531 
532 
533 contract WizRefund is Context, Ownable, AdminRole {
534     using SafeMath for uint256;
535     
536     modifier selfCall() {
537         require(_msgSender() == address(this), "You cannot call this method");
538         _;
539     }
540 
541     uint256 constant PHASES_COUNT = 4;
542     uint256 private _token_exchange_rate = 273789679021000; //0.000273789679021 ETH per 1 token
543     uint256 private _totalburnt = 0;
544     uint256 public final_distribution_balance;
545     uint256 public sum_burnt_amount_registered;
546 
547     address payable[] private _participants;
548 
549     mapping(address => uint256) private _burnt_amounts;
550     mapping(address => bool) private _participants_with_request;
551     mapping(address => bool) private _is_final_withdraw;
552 
553     struct PhaseParams {
554         string NAME;
555         bool IS_STARTED;
556         bool IS_FINISHED;
557     }
558     PhaseParams[] public phases;
559 
560     Token_interface public token;
561 
562     event BurningRequiredValues(uint256 allowed_value, uint256 topay_value, address indexed sc_address, uint256 sc_balance);
563     event LogWithdrawETH(address indexed wallet, uint256 amount);
564     event LogRefundValue(address indexed wallet, uint256 amount);
565 
566     constructor () {
567 
568         token = Token_interface(address(0x2F9b6779c37DF5707249eEb3734BbfC94763fBE2));
569 
570         // 0 - first
571         PhaseParams memory phaseInitialize;
572         phaseInitialize.NAME = "Initialize";
573         phaseInitialize.IS_STARTED = true;
574         phases.push(phaseInitialize);
575 
576         // 1 - second
577         // tokens exchanging is active in this phase, tokenholders may burn their tokens using
578         //           method approve(params: this SC address, amount in
579         //           uint256) method in Token SC, then he/she has to call refund()
580         //           method in this SC, all tokens from amount will be exchanged and the
581         //           tokenholder will receive his/her own ETH on his/her own address
582         // if somebody accidentally sent tokens to this SC directly you may use
583         //           refundTokensTransferredDirectly(params: tokenholder ETH address, amount in
584         //           uint256) method with mandatory multisignatures
585         PhaseParams memory phaseFirst;
586         phaseFirst.NAME = "the First Phase";
587         phases.push(phaseFirst);
588 
589         // 2 - third
590         // in this phase tokeholders who exchanged their own tokens in phase 1 may claim a
591         // remaining ETH stake with register() method
592         PhaseParams memory phaseSecond;
593         phaseSecond.NAME = "the Second Phase";
594         phases.push(phaseSecond);
595 
596         // 3 - last
597         // this is a final distribution phase. Everyone who left the request during the
598         // phase 2 with register() method will get remaining ETH amount
599         // in proportion to their exchanged tokens
600         PhaseParams memory phaseFinal;
601         phaseFinal.NAME = "Final";
602         phases.push(phaseFinal);
603         
604     }
605 
606     //
607     // ####################################
608     //
609 
610     //only owner or admins can top up the smart contract with ETH
611     receive() external payable {
612         require(checkSignRoleExists(_msgSender()), "the contract can't obtain ETH from this address");
613     }
614 
615     // owner or admin may withdraw ETH from this SC, multisig is mandatory
616     function withdrawETH(address payable recipient, uint256 value) external selfCall {
617         require(address(this).balance >= value, "Insufficient funds");
618         (bool success,) = recipient.call{value : value}("");
619         require(success, "Transfer failed");
620         emit LogWithdrawETH(msg.sender, value);
621     }
622 
623     function getExchangeRate() external view returns (uint256){
624         return _token_exchange_rate;
625     }
626 
627     function getBurntAmountByAddress(address holder) public view returns (uint256){
628         return _burnt_amounts[holder];
629     }
630 
631     function getBurntAmountTotal() external view returns (uint256) {
632         return _totalburnt;
633     }
634 
635     function getParticipantAddressByIndex(uint256 index) external view returns (address){
636         return _participants[index];
637     }
638 
639     function getNumberOfParticipants() public view returns (uint256){
640         return _participants.length;
641     }
642 
643     function isRegistration(address participant) public view returns (bool){
644         return _participants_with_request[participant];
645     }
646 
647     //
648     // ####################################
649     //
650     // tokenholder has to call approve(params: this SC address, amount in uint256)
651     // method in Token SC, then he/she has to call refund() method in this
652     // SC, all tokens from amount will be exchanged and the tokenholder will receive
653     // his/her own ETH on his/her own address
654     function refund() external {
655         // First phase
656         uint256 i = getCurrentPhaseIndex();
657         require(i == 1 && !phases[i].IS_FINISHED, "Not Allowed phase");
658 
659         address payable sender = _msgSender();
660         uint256 value = token.allowance(sender, address(this));
661 
662         require(value > 0, "Not Allowed value");
663 
664         uint256 topay_value = value.mul(_token_exchange_rate).div(10 ** 18);
665         BurningRequiredValues(value, topay_value, address(this), address(this).balance);
666         require(address(this).balance >= topay_value, "Insufficient funds");
667 
668         require(token.transferFrom(sender, address(0), value), "Insufficient approve() value");
669 
670         if (_burnt_amounts[sender] == 0) {
671             _participants.push(sender);
672         }
673 
674         _burnt_amounts[sender] = _burnt_amounts[sender].add(value);
675         _totalburnt = _totalburnt.add(value);
676 
677         (bool success,) = sender.call{value : topay_value}("");
678         require(success, "Transfer failed");
679         emit LogRefundValue(msg.sender, topay_value);
680     }
681 
682     // if somebody accidentally sends tokens to this SC directly you may use
683     // burnTokensTransferredDirectly(params: tokenholder ETH address, amount in
684     // uint256)
685     function refundTokensTransferredDirectly(address payable participant, uint256 value) external selfCall {
686         uint256 i = getCurrentPhaseIndex();
687         require(i == 1, "Not Allowed phase");
688         // First phase
689 
690         uint256 topay_value = value.mul(_token_exchange_rate).div(10 ** uint256(token.decimals()));
691         require(address(this).balance >= topay_value, "Insufficient funds");
692 
693         require(token.transfer(address(0), value), "Error with transfer");
694 
695         if (_burnt_amounts[participant] == 0) {
696             _participants.push(participant);
697         }
698 
699         _burnt_amounts[participant] = _burnt_amounts[participant].add(value);
700         _totalburnt = _totalburnt.add(value);
701 
702         (bool success,) = participant.call{value : topay_value}("");
703         require(success, "Transfer failed");
704         emit LogRefundValue(participant, topay_value);
705     }
706 
707     // This is a final distribution after phase 2 is fihished, everyone who left the
708     // request with register() method will get remaining ETH amount
709     // in proportion to their exchanged tokens
710     function startFinalDistribution(uint256 start_index, uint256 end_index) external onlyOwnerOrAdmin {
711         require(end_index < getNumberOfParticipants());
712         
713         uint256 j = getCurrentPhaseIndex();
714         require(j == 3 && !phases[j].IS_FINISHED, "Not Allowed phase");
715         // Final Phase
716 
717         uint256 pointfix = 1000000000000000000;
718         // 10^18
719 
720         for (uint i = start_index; i <= end_index; i++) {
721             if(!isRegistration(_participants[i]) || isFinalWithdraw(_participants[i])){
722                 continue;
723             }
724             
725             uint256 piece = getBurntAmountByAddress(_participants[i]).mul(pointfix).div(sum_burnt_amount_registered);
726             uint256 value = final_distribution_balance.mul(piece).div(pointfix);
727             
728             if (value > 0) {
729                 _is_final_withdraw[_participants[i]] = true;
730                 (bool success,) = _participants[i].call{value : value}("");
731                 require(success, "Transfer failed");
732                 emit LogWithdrawETH(_participants[i], value);
733             }
734         }
735 
736     }
737 
738     function isFinalWithdraw(address _wallet) public view returns (bool) {
739         return _is_final_withdraw[_wallet];
740     }
741     
742     function clearFinalWithdrawData(uint256 start_index, uint256 end_index) external selfCall{
743         require(end_index < getNumberOfParticipants());
744         
745         uint256 i = getCurrentPhaseIndex();
746         require(i == 3 && !phases[i].IS_FINISHED, "Not Allowed phase");
747         
748         for (uint j = start_index; j <= end_index; j++) {
749             if(isFinalWithdraw(_participants[j])){
750                 _is_final_withdraw[_participants[j]] = false;
751             }
752         }
753     }
754 
755     // tokeholders who exchanged their own tokens in phase 1 may claim a remaining ETH stake
756     function register() external {
757         _write_register(_msgSender());
758     }
759 
760     // admin can claim register() method instead of tokenholder
761     function forceRegister(address payable participant) external selfCall {
762         _write_register(participant);
763     }
764 
765     function _write_register(address payable participant) private {
766         uint256 i = getCurrentPhaseIndex();
767         require(i == 2 && !phases[i].IS_FINISHED, "Not Allowed phase");
768         // Second phase
769 
770         require(_burnt_amounts[participant] > 0, "This address has not refunded tokens");
771 
772         _participants_with_request[participant] = true;
773         sum_burnt_amount_registered  = sum_burnt_amount_registered.add(getBurntAmountByAddress(participant));
774     }
775 
776     function startNextPhase() external onlyOwnerOrAdmin {
777         uint256 i = getCurrentPhaseIndex();
778         require((i + 1) < PHASES_COUNT);
779         require(phases[i].IS_FINISHED);
780         phases[i + 1].IS_STARTED = true;
781         if (phases[2].IS_STARTED && !phases[2].IS_FINISHED && phases[1].IS_FINISHED) {
782             sum_burnt_amount_registered = 0;
783         }else if (phases[3].IS_STARTED && phases[2].IS_FINISHED) {
784             final_distribution_balance = address(this).balance;
785         }
786     }
787 
788     function finishCurrentPhase() external onlyOwnerOrAdmin {
789         uint256 i = getCurrentPhaseIndex();
790         phases[i].IS_FINISHED = true;
791     }
792 
793     // this method reverts the current phase to the previous one
794     function revertPhase() external selfCall {
795         uint256 i = getCurrentPhaseIndex();
796 
797         require(i > 0, "Initialize phase is already active");
798 
799         phases[i].IS_STARTED = false;
800         phases[i].IS_FINISHED = false;
801 
802         phases[i - 1].IS_STARTED = true;
803         phases[i - 1].IS_FINISHED = false;
804     }
805 
806     function getPhaseName() external view returns (string memory){
807         uint256 i = getCurrentPhaseIndex();
808         return phases[i].NAME;
809     }
810 
811     function getCurrentPhaseIndex() public view returns (uint256){
812         uint256 current_phase = 0;
813         for (uint256 i = 0; i < PHASES_COUNT; i++)
814         {
815             if (phases[i].IS_STARTED) {
816                 current_phase = i;
817             }
818         }
819         return current_phase;
820     }
821     
822     function _base_submitTx(bytes memory data)
823       private 
824       returns (uint256 transactionId){
825         uint256 value = 0;
826         transactionId = submitTransaction(address(this), value, data);
827       }
828       
829     function submitTx_withdrawETH(address payable recipient, uint256 value)
830       public
831       onlyOwnerOrAdmin
832       returns (uint256 transactionId){
833         uint256[] memory f_args = new uint256[](2);
834         f_args[0] = uint256(recipient);
835         f_args[1] = value;
836         bytes memory data = TxDataBuilder.buildData(TxDataBuilder.WETH_FUNCHASH, f_args);
837         transactionId = _base_submitTx(data);
838       }
839     
840     function submitTx_revertPhase()
841       external
842       onlyOwnerOrAdmin
843       returns (uint256 transactionId){
844         uint256[] memory f_args = new uint256[](0);
845         bytes memory data = TxDataBuilder.buildData(TxDataBuilder.RP_FUNCHASH, f_args);
846         transactionId = _base_submitTx(data);
847       }
848     
849     function submitTx_forceRegister(address payable participant)
850       external
851       onlyOwnerOrAdmin
852       returns (uint256 transactionId){
853         uint256[] memory f_args = new uint256[](1);
854         f_args[0] = uint256(participant);
855         bytes memory data = TxDataBuilder.buildData(TxDataBuilder.FR_FUNCHASH, f_args);
856         transactionId = _base_submitTx(data);
857       }
858     
859     function submitTx_clearFinalWithdrawData(uint256 start_index, uint256 end_index)
860       external
861       onlyOwnerOrAdmin
862       returns (uint256 transactionId){
863         uint256[] memory f_args = new uint256[](2);
864         f_args[0] = start_index;
865         f_args[1] = end_index;
866         bytes memory data = TxDataBuilder.buildData(TxDataBuilder.EFWD_FUNCHASH, f_args);
867         transactionId = _base_submitTx(data);
868       }
869       
870     
871     function submitTx_refundTokensTransferredDirectly(address payable participant, uint256 value)
872       external
873       onlyOwnerOrAdmin
874       returns (uint256 transactionId){
875         uint256[] memory f_args = new uint256[](2);
876         f_args[0] = uint256(participant);
877         f_args[1] = value;
878         bytes memory data = TxDataBuilder.buildData(TxDataBuilder.RTTD_FUNCHASH, f_args);
879         transactionId = _base_submitTx(data);
880       }
881 
882 }