1 // File: contracts/Dictionary.sol
2 
3 pragma solidity ^0.5.2;
4 
5 // Taken from https://github.com/sagivo/solidity-utils/blob/master/contracts/lib/Dictionary.sol
6 library Dictionary {
7     uint private constant NULL = 0;
8 
9     struct Node {
10         uint prev;
11         uint next;
12         bytes data;
13         bool initialized;
14     }
15 
16     struct Data {
17         mapping(uint => Node) list;
18         uint firstNodeId;
19         uint lastNodeId;
20         uint len;
21     }
22 
23     function insertAfter(
24         Data storage self,
25         uint afterId,
26         uint id,
27         bytes memory data
28     ) internal {
29         if (self.list[id].initialized) {
30             self.list[id].data = data;
31             return;
32         }
33         self.list[id].prev = afterId;
34         if (self.list[afterId].next == NULL) {
35             self.list[id].next = NULL;
36             self.lastNodeId = id;
37         } else {
38             self.list[id].next = self.list[afterId].next;
39             self.list[self.list[afterId].next].prev = id;
40         }
41         self.list[id].data = data;
42         self.list[id].initialized = true;
43         self.list[afterId].next = id;
44         self.len++;
45     }
46 
47     function insertBefore(
48         Data storage self,
49         uint beforeId,
50         uint id,
51         bytes memory data
52     ) internal {
53         if (self.list[id].initialized) {
54             self.list[id].data = data;
55             return;
56         }
57         self.list[id].next = beforeId;
58         if (self.list[beforeId].prev == NULL) {
59             self.list[id].prev = NULL;
60             self.firstNodeId = id;
61         } else {
62             self.list[id].prev = self.list[beforeId].prev;
63             self.list[self.list[beforeId].prev].next = id;
64         }
65         self.list[id].data = data;
66         self.list[id].initialized = true;
67         self.list[beforeId].prev = id;
68         self.len++;
69     }
70 
71     function insertBeginning(Data storage self, uint id, bytes memory data)
72         internal
73     {
74         if (self.list[id].initialized) {
75             self.list[id].data = data;
76             return;
77         }
78         if (self.firstNodeId == NULL) {
79             self.firstNodeId = id;
80             self.lastNodeId = id;
81             self.list[id] = Node({
82                 prev: 0,
83                 next: 0,
84                 data: data,
85                 initialized: true
86             });
87             self.len++;
88         } else insertBefore(self, self.firstNodeId, id, data);
89     }
90 
91     function insertEnd(Data storage self, uint id, bytes memory data) internal {
92         if (self.lastNodeId == NULL) insertBeginning(self, id, data);
93         else insertAfter(self, self.lastNodeId, id, data);
94     }
95 
96     function set(Data storage self, uint id, bytes memory data) internal {
97         insertEnd(self, id, data);
98     }
99 
100     function get(Data storage self, uint id)
101         internal
102         view
103         returns (bytes memory)
104     {
105         return self.list[id].data;
106     }
107 
108     function remove(Data storage self, uint id) internal returns (bool) {
109         uint nextId = self.list[id].next;
110         uint prevId = self.list[id].prev;
111 
112         if (prevId == NULL) self.firstNodeId = nextId; //first node
113         else self.list[prevId].next = nextId;
114 
115         if (nextId == NULL) self.lastNodeId = prevId; //last node
116         else self.list[nextId].prev = prevId;
117 
118         delete self.list[id];
119         self.len--;
120 
121         return true;
122     }
123 
124     function getSize(Data storage self) internal view returns (uint) {
125         return self.len;
126     }
127 
128     function next(Data storage self, uint id) internal view returns (uint) {
129         return self.list[id].next;
130     }
131 
132     function prev(Data storage self, uint id) internal view returns (uint) {
133         return self.list[id].prev;
134     }
135 
136     function keys(Data storage self) internal view returns (uint[] memory) {
137         uint[] memory arr = new uint[](self.len);
138         uint node = self.firstNodeId;
139         for (uint i = 0; i < self.len; i++) {
140             arr[i] = node;
141             node = next(self, node);
142         }
143         return arr;
144     }
145 }
146 
147 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
148 
149 pragma solidity ^0.5.0;
150 
151 /**
152  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
153  * the optional functions; to access them see `ERC20Detailed`.
154  */
155 interface IERC20 {
156     /**
157      * @dev Returns the amount of tokens in existence.
158      */
159     function totalSupply() external view returns (uint256);
160 
161     /**
162      * @dev Returns the amount of tokens owned by `account`.
163      */
164     function balanceOf(address account) external view returns (uint256);
165 
166     /**
167      * @dev Moves `amount` tokens from the caller's account to `recipient`.
168      *
169      * Returns a boolean value indicating whether the operation succeeded.
170      *
171      * Emits a `Transfer` event.
172      */
173     function transfer(address recipient, uint256 amount) external returns (bool);
174 
175     /**
176      * @dev Returns the remaining number of tokens that `spender` will be
177      * allowed to spend on behalf of `owner` through `transferFrom`. This is
178      * zero by default.
179      *
180      * This value changes when `approve` or `transferFrom` are called.
181      */
182     function allowance(address owner, address spender) external view returns (uint256);
183 
184     /**
185      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
186      *
187      * Returns a boolean value indicating whether the operation succeeded.
188      *
189      * > Beware that changing an allowance with this method brings the risk
190      * that someone may use both the old and the new allowance by unfortunate
191      * transaction ordering. One possible solution to mitigate this race
192      * condition is to first reduce the spender's allowance to 0 and set the
193      * desired value afterwards:
194      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
195      *
196      * Emits an `Approval` event.
197      */
198     function approve(address spender, uint256 amount) external returns (bool);
199 
200     /**
201      * @dev Moves `amount` tokens from `sender` to `recipient` using the
202      * allowance mechanism. `amount` is then deducted from the caller's
203      * allowance.
204      *
205      * Returns a boolean value indicating whether the operation succeeded.
206      *
207      * Emits a `Transfer` event.
208      */
209     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
210 
211     /**
212      * @dev Emitted when `value` tokens are moved from one account (`from`) to
213      * another (`to`).
214      *
215      * Note that `value` may be zero.
216      */
217     event Transfer(address indexed from, address indexed to, uint256 value);
218 
219     /**
220      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
221      * a call to `approve`. `value` is the new allowance.
222      */
223     event Approval(address indexed owner, address indexed spender, uint256 value);
224 }
225 
226 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
227 
228 pragma solidity ^0.5.0;
229 
230 /**
231  * @dev Wrappers over Solidity's arithmetic operations with added overflow
232  * checks.
233  *
234  * Arithmetic operations in Solidity wrap on overflow. This can easily result
235  * in bugs, because programmers usually assume that an overflow raises an
236  * error, which is the standard behavior in high level programming languages.
237  * `SafeMath` restores this intuition by reverting the transaction when an
238  * operation overflows.
239  *
240  * Using this library instead of the unchecked operations eliminates an entire
241  * class of bugs, so it's recommended to use it always.
242  */
243 library SafeMath {
244     /**
245      * @dev Returns the addition of two unsigned integers, reverting on
246      * overflow.
247      *
248      * Counterpart to Solidity's `+` operator.
249      *
250      * Requirements:
251      * - Addition cannot overflow.
252      */
253     function add(uint256 a, uint256 b) internal pure returns (uint256) {
254         uint256 c = a + b;
255         require(c >= a, "SafeMath: addition overflow");
256 
257         return c;
258     }
259 
260     /**
261      * @dev Returns the subtraction of two unsigned integers, reverting on
262      * overflow (when the result is negative).
263      *
264      * Counterpart to Solidity's `-` operator.
265      *
266      * Requirements:
267      * - Subtraction cannot overflow.
268      */
269     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
270         require(b <= a, "SafeMath: subtraction overflow");
271         uint256 c = a - b;
272 
273         return c;
274     }
275 
276     /**
277      * @dev Returns the multiplication of two unsigned integers, reverting on
278      * overflow.
279      *
280      * Counterpart to Solidity's `*` operator.
281      *
282      * Requirements:
283      * - Multiplication cannot overflow.
284      */
285     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
286         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
287         // benefit is lost if 'b' is also tested.
288         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
289         if (a == 0) {
290             return 0;
291         }
292 
293         uint256 c = a * b;
294         require(c / a == b, "SafeMath: multiplication overflow");
295 
296         return c;
297     }
298 
299     /**
300      * @dev Returns the integer division of two unsigned integers. Reverts on
301      * division by zero. The result is rounded towards zero.
302      *
303      * Counterpart to Solidity's `/` operator. Note: this function uses a
304      * `revert` opcode (which leaves remaining gas untouched) while Solidity
305      * uses an invalid opcode to revert (consuming all remaining gas).
306      *
307      * Requirements:
308      * - The divisor cannot be zero.
309      */
310     function div(uint256 a, uint256 b) internal pure returns (uint256) {
311         // Solidity only automatically asserts when dividing by 0
312         require(b > 0, "SafeMath: division by zero");
313         uint256 c = a / b;
314         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
315 
316         return c;
317     }
318 
319     /**
320      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
321      * Reverts when dividing by zero.
322      *
323      * Counterpart to Solidity's `%` operator. This function uses a `revert`
324      * opcode (which leaves remaining gas untouched) while Solidity uses an
325      * invalid opcode to revert (consuming all remaining gas).
326      *
327      * Requirements:
328      * - The divisor cannot be zero.
329      */
330     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
331         require(b != 0, "SafeMath: modulo by zero");
332         return a % b;
333     }
334 }
335 
336 // File: contracts/Etherclear.sol
337 
338 pragma solidity ^0.5.2;
339 pragma experimental ABIEncoderV2;
340 
341 
342 
343 
344 /**
345  * @title Etherclear
346  * @dev The Etherclear contract is meant to serve as a transition step for funds between a sender
347  * and a recipient, where the sender can take the funds back if they cancel the payment,
348  * and the recipient can only retrieve the funds in a specified amount of time, using
349  * a passphrase communicated privately by the sender.
350  *
351  * The usage of the contract is as follows:
352  *
353  * 1) The sender generates a passphrase, and passes keccak256(passphrase,recipient_address) to the
354  * contract, along with a hold time. This registers a payment ID (which must be unique), and
355  * marks the start of the holding time window.
356  * 2) The sender communicates this passphrase to the recipient over a secure channel.
357  * 3) Before the holding time has passed, the recipient can send the passphrase to the contract to withdraw the funds.
358  * 4) After the holding time has passed, the recipient is no longer able to withdraw the funds, regardless
359  * of whether they have the passphrase or not.
360  *
361  * At any time, the sender can cancel the payment if they provide the payment ID, which
362  * will initiate a transfer of funds back to the sender.
363  * The sender is expected to cancel the payment if they have made a mistake in specifying
364  * the recipient's address, the recipient does not claim the funds, or if the holding period has expired and the
365  * funds need to be retrieved.
366  *
367  * TODO: Currently, the payment ID is a truncated version of the passphrase hash that is used to ensure knowledge of the
368  * passphrase. They will be left as separate entities for now in case they need to be constructed differently.
369  *
370  * NOTE: the hold time functionality is not very secure for small time periods since it uses now (block.timestamp). It is meant to be an additional security measure, and should not be relied upon in the case of an
371  attack. The current known tolerance is 900 seconds:
372  * https://github.com/ethereum/wiki/blob/c02254611f218f43cbb07517ca8e5d00fd6d6d75/Block-Protocol-2.0.md
373  *
374  * Some parts are modified from https://github.com/forkdelta/smart_contract/blob/master/contracts/ForkDelta.sol
375 */
376 
377 /*
378  * This is used as an interface to provide functionality when setting up the contract with ENS.
379 */
380 contract ReverseRegistrar {
381     function setName(string memory name) public returns (bytes32);
382 }
383 
384 contract Etherclear {
385     /*
386     * The dictionary is used as an iterable mapping implementation.
387     */
388     using Dictionary for Dictionary.Data;
389 
390     // TODO: think about adding a ERC223 fallback method.
391 
392     // NOTE: PaymentClosed has the same signature
393     // because we want to look for payments
394     // from the latest block backwards, and
395     // we want to terminate the search for
396     // past events as soon as possible when doing so.
397     event PaymentOpened(
398         uint txnId,
399         uint holdTime,
400         uint openTime,
401         uint closeTime,
402         address token,
403         uint sendAmount,
404         address indexed sender,
405         address indexed recipient,
406         bytes codeHash
407     );
408     event PaymentClosed(
409         uint txnId,
410         uint holdTime,
411         uint openTime,
412         uint closeTime,
413         address token,
414         uint sendAmount,
415         address indexed sender,
416         address indexed recipient,
417         bytes codeHash,
418         uint state
419     );
420 
421     // A Payment starts in the OPEN state.
422     // Once it is COMPLETED or CANCELLED, it cannot be changed further.
423     enum PaymentState {OPEN, COMPLETED, CANCELLED}
424 
425     // A Payment is created each time a sender wants to
426     // send an amount to a recipient.
427     struct Payment {
428         // timestamps are in epoch seconds
429         uint holdTime;
430         uint paymentOpenTime;
431         uint paymentCloseTime;
432         // Token contract address, 0 is Ether.
433         address token;
434         uint sendAmount;
435         address payable sender;
436         address payable recipient;
437         bytes codeHash;
438         PaymentState state;
439     }
440 
441     ReverseRegistrar reverseRegistrar;
442 
443     // EIP-712 code uses the examples provided at
444     // https://medium.com/metamask/eip712-is-coming-what-to-expect-and-how-to-use-it-bb92fd1a7a26
445     // TODO: the salt and verifyingContract still need to be changed.
446     struct RetrieveFundsRequest {
447         uint txnId;
448         address sender;
449         address recipient;
450         string passphrase;
451     }
452 
453     // Payments where msg.sender is the recipient.
454     mapping(address => Dictionary.Data) recipientPayments;
455     // Payments where msg.sender is the sender.
456     mapping(address => Dictionary.Data) senderPayments;
457     // Payments are looked up with a uint UUID generated within the contract.
458     mapping(uint => Payment) allPayments;
459 
460     // This contract's owner (gives ability to set fees).
461     address payable owner;
462     // The fees are represented with a percentage times 1 ether.
463     // The baseFee is to cover feeless retrieval
464     // The paymentFee is to cover development costs
465     uint baseFee;
466     uint paymentFee;
467     // mapping of token addresses to mapping of account balances (token=0 means Ether)
468     mapping(address => mapping(address => uint)) public tokens;
469 
470     // NOTE: We do not lock the cancel payment functionality, so that users
471     // will still be able to withdraw funds from payments they created.
472     // Failsafe to lock the create payments functionality for both ether and tokens.
473     bool createPaymentEnabled;
474     // Failsafe to lock the retrieval (withdraw) functionality.
475     bool retrieveFundsEnabled;
476 
477     address constant verifyingContract = 0x1C56346CD2A2Bf3202F771f50d3D14a367B48070;
478     bytes32 constant salt = 0xf2d857f4a3edcb9b78b4d503bfe733db1e3f6cdc2b7971ee739626c97e86a558;
479     string private constant RETRIEVE_FUNDS_REQUEST_TYPE = "RetrieveFundsRequest(uint256 txnId,address sender,address recipient,string passphrase)";
480     string private constant EIP712_DOMAIN_TYPE = "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract,bytes32 salt)";
481     bytes32 private constant EIP712_DOMAIN_TYPEHASH = keccak256(
482         abi.encodePacked(EIP712_DOMAIN_TYPE)
483     );
484     bytes32 private constant RETRIEVE_FUNDS_REQUEST_TYPEHASH = keccak256(
485         abi.encodePacked(RETRIEVE_FUNDS_REQUEST_TYPE)
486     );
487     bytes32 private DOMAIN_SEPARATOR;
488     uint256 chainId;
489 
490     function hashRetrieveFundsRequest(RetrieveFundsRequest memory request)
491         private
492         view
493         returns (bytes32 hash)
494     {
495         return keccak256(
496             abi.encodePacked(
497                 "\x19\x01",
498                 DOMAIN_SEPARATOR,
499                 keccak256(
500                     abi.encode(
501                         RETRIEVE_FUNDS_REQUEST_TYPEHASH,
502                         request.txnId,
503                         request.sender,
504                         request.recipient,
505                         keccak256(bytes(request.passphrase))
506                     )
507                 )
508             )
509         );
510     }
511 
512     function verify(
513         address signer,
514         RetrieveFundsRequest memory request,
515         bytes32 sigR,
516         bytes32 sigS,
517         uint8 sigV
518     ) private view returns (address result) {
519         return ecrecover(hashRetrieveFundsRequest(request), sigV, sigR, sigS);
520     }
521 
522     // Used to test the sign and recover functionality.
523     function checkRetrieveSignature(
524         uint256 txnId,
525         address sender,
526         address recipient,
527         string memory passphrase,
528         bytes32 sigR,
529         bytes32 sigS,
530         uint8 sigV
531     ) public view returns (address result) {
532         RetrieveFundsRequest memory request = RetrieveFundsRequest(
533             txnId,
534             sender,
535             recipient,
536             passphrase
537         );
538         address signer = ecrecover(
539             hashRetrieveFundsRequest(request),
540             sigV,
541             sigR,
542             sigS
543         );
544         return verify(recipient, request, sigR, sigS, sigV);
545     }
546 
547     constructor(uint256 _chainId) public {
548         owner = msg.sender;
549         baseFee = 0.001 ether;
550         paymentFee = 0.005 ether;
551         createPaymentEnabled = true;
552         retrieveFundsEnabled = true;
553         chainId = _chainId;
554         DOMAIN_SEPARATOR = keccak256(
555             abi.encode(
556                 EIP712_DOMAIN_TYPEHASH,
557                 keccak256("Etherclear"),
558                 keccak256("1"),
559                 chainId,
560                 verifyingContract,
561                 salt
562             )
563         );
564     }
565 
566     function getChainId() public view returns (uint256 networkID) {
567         return chainId;
568     }
569 
570     modifier onlyOwner {
571         require(
572             msg.sender == owner,
573             "Only the contract owner is allowed to use this function."
574         );
575         _;
576     }
577 
578     /*
579     * SetENS sets the name of the reverse record so that it points to this contract address.
580     */
581     function setENS(address reverseRegistrarAddr, string memory name)
582         public
583         onlyOwner
584     {
585         reverseRegistrar = ReverseRegistrar(reverseRegistrarAddr);
586         reverseRegistrar.setName(name);
587 
588     }
589 
590     function withdrawFees(address token) external onlyOwner {
591         // The "owner" account is considered the fee account.
592         uint total = tokens[token][owner];
593         tokens[token][owner] = 0;
594         if (token == address(0)) {
595             owner.transfer(total);
596         } else {
597             require(
598                 IERC20(token).transfer(owner, total),
599                 "Could not successfully withdraw token"
600             );
601         }
602     }
603 
604     function viewBalance(address token, address user)
605         external
606         view
607         returns (uint balance)
608     {
609         return tokens[token][user];
610     }
611 
612     // TODO: change this so that the fee can only be decreased
613     // (once a suitable starting fee is reached).
614     function changeBaseFee(uint newFee) external onlyOwner {
615         baseFee = newFee;
616     }
617     function changePaymentFee(uint newFee) external onlyOwner {
618         paymentFee = newFee;
619     }
620 
621     function getBaseFee() public view returns (uint feeAmt) {
622         return baseFee;
623     }
624 
625     function getPaymentFee() public view returns (uint feeAmt) {
626         return paymentFee;
627     }
628 
629     function getPaymentsForSender()
630         external
631         view
632         returns (uint[] memory result)
633     {
634         Dictionary.Data storage payments = senderPayments[msg.sender];
635         uint[] memory keys = payments.keys();
636         return keys;
637 
638     }
639 
640     function disableRetrieveFunds(bool disabled) public onlyOwner {
641         retrieveFundsEnabled = !disabled;
642     }
643 
644     function disableCreatePayment(bool disabled) public onlyOwner {
645         createPaymentEnabled = !disabled;
646     }
647 
648     function getPaymentsForRecipient()
649         external
650         view
651         returns (uint[] memory result)
652     {
653         Dictionary.Data storage payments = recipientPayments[msg.sender];
654         uint[] memory keys = payments.keys();
655         return keys;
656     }
657 
658     function getPaymentInfo(uint paymentID)
659         external
660         view
661         returns (
662         uint holdTime,
663         uint paymentOpenTime,
664         uint paymentCloseTime,
665         address token,
666         uint sendAmount,
667         address sender,
668         address recipient,
669         bytes memory codeHash,
670         uint state
671     )
672     {
673         Payment memory txn = allPayments[paymentID];
674         return (txn.holdTime, txn.paymentOpenTime, txn.paymentCloseTime, txn.token, txn.sendAmount, txn.sender, txn.recipient, txn.codeHash, uint(
675             txn.state
676         ));
677     }
678 
679     // TODO: Should the passphrase be needed to cancel the payment?
680     // Cancels the payment and returns the funds to the payment's sender.
681     function cancelPayment(uint txnId) external {
682         // Check txn sender and state.
683         Payment memory txn = allPayments[txnId];
684         require(
685             txn.sender == msg.sender,
686             "Payment sender does not match message sender."
687         );
688         require(
689             txn.state == PaymentState.OPEN,
690             "Payment must be open to cancel."
691         );
692 
693         // Update txn state.
694         txn.paymentCloseTime = now;
695         txn.state = PaymentState.CANCELLED;
696 
697         delete allPayments[txnId];
698         recipientPayments[txn.recipient].remove(txnId);
699         senderPayments[txn.sender].remove(txnId);
700 
701         // Return funds to sender.
702         if (txn.token == address(0)) {
703             tokens[address(0)][txn.sender] = SafeMath.sub(
704                 tokens[address(0)][txn.sender],
705                 txn.sendAmount
706             );
707             txn.sender.transfer(txn.sendAmount);
708         } else {
709             withdrawToken(txn.token, txn.sender, txn.sender, txn.sendAmount);
710         }
711 
712         emit PaymentClosed(
713             txnId,
714             txn.holdTime,
715             txn.paymentOpenTime,
716             txn.paymentCloseTime,
717             txn.token,
718             txn.sendAmount,
719             txn.sender,
720             txn.recipient,
721             txn.codeHash,
722             uint(txn.state)
723         );
724     }
725 
726     /**
727 * This function handles deposits of ERC-20 tokens to the contract.
728 * Does not allow Ether.
729 * If token transfer fails, payment is reverted and remaining gas is refunded.
730 * Additionally, includes a fee which must be accounted for when approving the amount.
731 * Note: Remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
732 * @param token Ethereum contract address of the token or 0 for Ether
733 * @param originalAmount uint of the amount of the token the user wishes to deposit
734 * @param feeAmount uint total amount of the fee charged by the contract
735 */
736     // TODO: this doesn't follow checks-effects-interactions
737     // https://solidity.readthedocs.io/en/develop/security-considerations.html?highlight=check%20effects#use-the-checks-effects-interactions-pattern
738     function transferToken(
739         address token,
740         address user,
741         uint originalAmount,
742         uint feeAmount
743     ) internal {
744         require(token != address(0));
745         // TODO: use depositingTokenFlag in the ERC223 fallback function
746         //depositingTokenFlag = true;
747         require(
748             IERC20(token).transferFrom(
749                 user,
750                 address(this),
751                 SafeMath.add(originalAmount, feeAmount)
752             )
753         );
754         //depositingTokenFlag = false;
755         tokens[token][user] = SafeMath.add(
756             tokens[token][msg.sender],
757             originalAmount
758         );
759         tokens[token][owner] = SafeMath.add(tokens[token][owner], feeAmount);
760     }
761 
762     // TODO: Make sure to check if amounts are available
763     // We don't increment any balances because the funds are sent
764     // outside of the contract.
765     function withdrawToken(
766         address token,
767         address userFrom,
768         address userTo,
769         uint amount
770     ) internal {
771         require(token != address(0));
772         require(IERC20(token).transfer(userTo, amount));
773         tokens[token][userFrom] = SafeMath.sub(tokens[token][userFrom], amount);
774     }
775 
776     /* This takes ether for the fee amount*/
777     // TODO check order of execution.
778     function createPayment(
779         uint amount,
780         address payable recipient,
781         uint holdTime,
782         bytes calldata codeHash
783     ) external payable {
784         return createTokenPayment(
785             address(0),
786             amount,
787             recipient,
788             holdTime,
789             codeHash
790         );
791 
792     }
793 
794     // Meant to be used for the approve() call, since the
795     // amount in the ERC20 contract implementation will be
796     // overwritten with the amount requested in the next approve().
797     // This returns the amount of the token that the
798     // contract still holds.
799     // TODO: ensure this value will be correct.
800     function getBalance(address token) external view returns (uint amt) {
801         return tokens[token][msg.sender];
802     }
803 
804     function getPaymentId(address recipient, bytes memory codeHash)
805         public
806         pure
807         returns (uint result)
808     {
809         bytes memory txnIdBytes = abi.encodePacked(
810             keccak256(abi.encodePacked(codeHash, recipient))
811         );
812         uint txnId = sliceUint(txnIdBytes);
813         return txnId;
814     }
815     // Creates a new payment with the msg.sender as sender.
816     // Expected to take a base fee in ETH.
817     // Also takes a payment fee in either ETH or the token used,
818     // this payment fee is calculated from the original amount.
819     // We assume here that an approve() call has already been made for
820     // the original amount + payment fee.
821     function createTokenPayment(
822         address token,
823         uint amount,
824         address payable recipient,
825         uint holdTime,
826         bytes memory codeHash
827     ) public payable {
828         // Check amount and fee, make sure to truncate fee.
829         require(createPaymentEnabled, "The create payments functionality is currently disabled");
830         uint paymentFeeTotal = uint(
831             SafeMath.mul(paymentFee, amount) / (1 ether)
832         );
833         if (token == address(0)) {
834             require(
835                 msg.value >= (SafeMath.add(
836                     SafeMath.add(amount, baseFee),
837                     paymentFeeTotal
838                 )),
839                 "Message value is not enough to cover amount and fees"
840             );
841         } else {
842             require(
843                 msg.value >= baseFee,
844                 "Message value is not enough to cover base fee"
845             );
846             // We don't check for a minimum when taking the paymentFee here. Since we don't
847             // care what the original sent amount was supposed to be, we just take a percentage and
848             // subtract that from the sent amount.
849         }
850 
851         // Get payments for sender.
852         Dictionary.Data storage sendertxns = senderPayments[msg.sender];
853         // Get payments for recipient
854         // TODO: make sure recipient is valid address? How much of this check is performed for you
855         Dictionary.Data storage recipienttxns = recipientPayments[recipient];
856 
857         // Check payment ID.
858         // TODO: should other components be included in the hash? This isn't secure
859         // if someone uses a bad codeHash. But they could mess up other components anyway,
860         // unless a UUID was generated in the contract, which is expensive.
861         uint txnId = getPaymentId(recipient, codeHash);
862         // If txnId already exists, don't overwrite.
863         require(
864             allPayments[txnId].sender == address(0),
865             "Payment ID must be unique. Use a different passphrase hash."
866         );
867 
868         // Add txnId to sender and recipient payment dicts.
869         bytes memory val = "\x20";
870         sendertxns.set(txnId, val);
871         recipienttxns.set(txnId, val);
872 
873         // Create payments.
874         Payment memory txn = Payment(
875             holdTime,
876             now,
877             0,
878             token,
879             amount,
880             msg.sender,
881             recipient,
882             codeHash,
883             PaymentState.OPEN
884         );
885 
886         allPayments[txnId] = txn;
887 
888         // Take fees; mark ether or token balances.
889         if (token == address(0)) {
890             // Mark sender's ether balance with the sent amount
891             tokens[address(0)][msg.sender] = SafeMath.add(
892                 tokens[address(0)][msg.sender],
893                 amount
894             );
895 
896             // Take baseFee and paymentFee (and any ether sent in the message)
897             tokens[address(0)][owner] = SafeMath.add(
898                 tokens[address(0)][owner],
899                 SafeMath.sub(msg.value, amount)
900             );
901 
902         } else {
903             // Take baseFee (and any ether sent in the message)
904             tokens[address(0)][owner] = SafeMath.add(
905                 tokens[address(0)][owner],
906                 msg.value
907             );
908             // Transfer tokens; mark sender's balance; take paymentFee
909             transferToken(token, msg.sender, amount, paymentFeeTotal);
910         }
911 
912         // TODO: is this the best step to emit events?
913         emit PaymentOpened(
914             txnId,
915             txn.holdTime,
916             txn.paymentOpenTime,
917             txn.paymentCloseTime,
918             txn.token,
919             txn.sendAmount,
920             txn.sender,
921             txn.recipient,
922             txn.codeHash
923         );
924 
925     }
926 
927     // Meant to be called by anyone, on behalf of the recipient.
928     // Will only work if the correct signature is passed in.
929     function retrieveFundsForRecipient(
930         uint256 txnId,
931         address sender,
932         address recipient,
933         string memory passphrase,
934         bytes32 sigR,
935         bytes32 sigS,
936         uint8 sigV
937     ) public {
938         RetrieveFundsRequest memory request = RetrieveFundsRequest(
939             txnId,
940             sender,
941             recipient,
942             passphrase
943         );
944         address signer = ecrecover(
945             hashRetrieveFundsRequest(request),
946             sigV,
947             sigR,
948             sigS
949         );
950 
951         require(
952             recipient == signer,
953             "The message recipient must be the same as the signer of the message"
954         );
955         Payment memory txn = allPayments[txnId];
956         require(
957             txn.recipient == recipient,
958             "The payment's recipient must be the same as signer of the message"
959         );
960         retrieveFunds(txn, txnId, passphrase);
961     }
962 
963     // Meant to be called by the recipient.
964     function retrieveFundsAsRecipient(uint txnId, string memory code) public {
965         Payment memory txn = allPayments[txnId];
966 
967         // Check recipient
968         require(
969             txn.recipient == msg.sender,
970             "Message sender must match payment recipient"
971         );
972         retrieveFunds(txn, txnId, code);
973     }
974 
975     // Sends funds to a payment recipient.
976     // Internal ONLY, because it does not do any checks with msg.sender,
977     // and leaves that for calling functions.
978     // TODO: find a more secure way to implement the recipient check.
979     function retrieveFunds(Payment memory txn, uint txnId, string memory code)
980         private
981     {
982     require(retrieveFundsEnabled, "The retrieve funds functionality is currently disabled.");
983         require(
984             txn.state == PaymentState.OPEN,
985             "Payment must be open to retrieve funds"
986         );
987         // TODO: make sure this is secure.
988         bytes memory actualHash = abi.encodePacked(
989             keccak256(abi.encodePacked(code, txn.recipient))
990         );
991     // Check codeHash
992     require(
993             sliceUint(actualHash) == sliceUint(txn.codeHash),
994             "Passphrase is not correct"
995         );
996 
997         // Check holdTime
998         require(
999             (txn.paymentOpenTime + txn.holdTime) > now,
1000             "Hold time has already expired"
1001         );
1002 
1003         // Update state.
1004         txn.paymentCloseTime = now;
1005         txn.state = PaymentState.COMPLETED;
1006 
1007         delete allPayments[txnId];
1008         recipientPayments[txn.recipient].remove(txnId);
1009         senderPayments[txn.sender].remove(txnId);
1010 
1011         // Transfer either ether or tokens.
1012         if (txn.token == address(0)) {
1013             // Pay out retrieved funds based on payment amount
1014             // TODO: recipient must be valid!
1015             txn.recipient.transfer(txn.sendAmount);
1016             tokens[address(0)][txn.sender] = SafeMath.sub(
1017                 tokens[address(0)][txn.sender],
1018                 txn.sendAmount
1019             );
1020 
1021         } else {
1022             withdrawToken(txn.token, txn.sender, txn.recipient, txn.sendAmount);
1023         }
1024 
1025         emit PaymentClosed(
1026             txnId,
1027             txn.holdTime,
1028             txn.paymentOpenTime,
1029             txn.paymentCloseTime,
1030             txn.token,
1031             txn.sendAmount,
1032             txn.sender,
1033             txn.recipient,
1034             txn.codeHash,
1035             uint(txn.state)
1036         );
1037 
1038     }
1039 
1040     // Utility function to go from bytes -> uint
1041     // This is apparently not reversible.
1042     function sliceUint(bytes memory bs) public pure returns (uint) {
1043         uint start = 0;
1044         if (bs.length < start + 32) {
1045             return 0;
1046         }
1047         uint x;
1048         assembly {
1049             x := mload(add(bs, add(0x20, start)))
1050         }
1051         return x;
1052     }
1053 
1054 }