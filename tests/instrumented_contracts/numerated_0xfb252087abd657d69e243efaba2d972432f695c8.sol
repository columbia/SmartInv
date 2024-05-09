1 pragma solidity ^0.5.9;
2 
3 /**
4  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
5  * the optional functions; to access them see `ERC20Detailed`.
6  */
7 interface IERC20 {
8     /**
9      * @dev Returns the amount of tokens in existence.
10      */
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a `Transfer` event.
24      */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through `transferFrom`. This is
30      * zero by default.
31      *
32      * This value changes when `approve` or `transferFrom` are called.
33      */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * > Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an `Approval` event.
49      */
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Moves `amount` tokens from `sender` to `recipient` using the
54      * allowance mechanism. `amount` is then deducted from the caller's
55      * allowance.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a `Transfer` event.
60      */
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Emitted when `value` tokens are moved from one account (`from`) to
65      * another (`to`).
66      *
67      * Note that `value` may be zero.
68      */
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     /**
72      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
73      * a call to `approve`. `value` is the new allowance.
74      */
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 /**
79  * @dev Wrappers over Solidity's arithmetic operations with added overflow
80  * checks.
81  *
82  * Arithmetic operations in Solidity wrap on overflow. This can easily result
83  * in bugs, because programmers usually assume that an overflow raises an
84  * error, which is the standard behavior in high level programming languages.
85  * `SafeMath` restores this intuition by reverting the transaction when an
86  * operation overflows.
87  *
88  * Using this library instead of the unchecked operations eliminates an entire
89  * class of bugs, so it's recommended to use it always.
90  */
91 library SafeMath {
92     /**
93      * @dev Returns the addition of two unsigned integers, reverting on
94      * overflow.
95      *
96      * Counterpart to Solidity's `+` operator.
97      *
98      * Requirements:
99      * - Addition cannot overflow.
100      */
101     function add(uint256 a, uint256 b) internal pure returns (uint256) {
102         uint256 c = a + b;
103         require(c >= a, "SafeMath: addition overflow");
104 
105         return c;
106     }
107 
108     /**
109      * @dev Returns the subtraction of two unsigned integers, reverting on
110      * overflow (when the result is negative).
111      *
112      * Counterpart to Solidity's `-` operator.
113      *
114      * Requirements:
115      * - Subtraction cannot overflow.
116      */
117     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118         require(b <= a, "SafeMath: subtraction overflow");
119         uint256 c = a - b;
120 
121         return c;
122     }
123 
124     /**
125      * @dev Returns the multiplication of two unsigned integers, reverting on
126      * overflow.
127      *
128      * Counterpart to Solidity's `*` operator.
129      *
130      * Requirements:
131      * - Multiplication cannot overflow.
132      */
133     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
134         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
135         // benefit is lost if 'b' is also tested.
136         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
137         if (a == 0) {
138             return 0;
139         }
140 
141         uint256 c = a * b;
142         require(c / a == b, "SafeMath: multiplication overflow");
143 
144         return c;
145     }
146 
147     /**
148      * @dev Returns the integer division of two unsigned integers. Reverts on
149      * division by zero. The result is rounded towards zero.
150      *
151      * Counterpart to Solidity's `/` operator. Note: this function uses a
152      * `revert` opcode (which leaves remaining gas untouched) while Solidity
153      * uses an invalid opcode to revert (consuming all remaining gas).
154      *
155      * Requirements:
156      * - The divisor cannot be zero.
157      */
158     function div(uint256 a, uint256 b) internal pure returns (uint256) {
159         // Solidity only automatically asserts when dividing by 0
160         require(b > 0, "SafeMath: division by zero");
161         uint256 c = a / b;
162         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
163 
164         return c;
165     }
166 
167     /**
168      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
169      * Reverts when dividing by zero.
170      *
171      * Counterpart to Solidity's `%` operator. This function uses a `revert`
172      * opcode (which leaves remaining gas untouched) while Solidity uses an
173      * invalid opcode to revert (consuming all remaining gas).
174      *
175      * Requirements:
176      * - The divisor cannot be zero.
177      */
178     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
179         require(b != 0, "SafeMath: modulo by zero");
180         return a % b;
181     }
182 }
183 
184 pragma experimental ABIEncoderV2;
185 
186 
187 
188 
189 /**
190  * @title Etherclear
191  * @dev The Etherclear contract is meant to serve as a transition step for funds between a sender
192  * and a recipient, where the sender can take the funds back if they cancel the payment,
193  * and the recipient can only retrieve the funds in a specified amount of time, using
194  * a passphrase communicated privately by the sender.
195  *
196  * The usage of the contract is as follows:
197  *
198  * 1) The sender generates a passphrase, and passes keccak256(passphrase,recipient_address) to the
199  * contract, along with a hold time. This registers a payment ID (which must be unique), and
200  * marks the start of the holding time window.
201  * 2) The sender communicates this passphrase to the recipient over a secure channel.
202  * 3) Before the holding time has passed, the recipient can send the passphrase to the contract to withdraw the funds.
203  * 4) After the holding time has passed, the recipient is no longer able to withdraw the funds, regardless
204  * of whether they have the passphrase or not.
205  *
206  * At any time, the sender can cancel the payment if they provide the payment ID, which
207  * will initiate a transfer of funds back to the sender.
208  * The sender is expected to cancel the payment if they have made a mistake in specifying
209  * the recipient's address, the recipient does not claim the funds, or if the holding period has expired and the
210  * funds need to be retrieved.
211  *
212  * TODO: Currently, the payment ID is a truncated version of the passphrase hash that is used to ensure knowledge of the
213  * passphrase. They will be left as separate entities for now in case they need to be constructed differently.
214  *
215  * NOTE: the hold time functionality is not very secure for small time periods since it uses now (block.timestamp). It is meant to be an additional security measure, and should not be relied upon in the case of an
216  attack. The current known tolerance is 900 seconds:
217  * https://github.com/ethereum/wiki/blob/c02254611f218f43cbb07517ca8e5d00fd6d6d75/Block-Protocol-2.0.md
218  *
219  * Some parts are modified from https://github.com/forkdelta/smart_contract/blob/master/contracts/ForkDelta.sol
220 */
221 
222 /*
223  * This is used as an interface to provide functionality when setting up the contract with ENS.
224 */
225 contract ReverseRegistrar {
226     function setName(string memory name) public returns (bytes32);
227 }
228 
229 contract Etherclear {
230     // TODO: think about adding a ERC223 fallback method.
231 
232     // NOTE: PaymentClosed has the same signature
233     // because we want to look for payments
234     // from the latest block backwards, and
235     // we want to terminate the search for
236     // past events as soon as possible when doing so.
237     event PaymentOpened(
238         uint txnId,
239         uint holdTime,
240         uint openTime,
241         uint closeTime,
242         address token,
243         uint sendAmount,
244         address indexed sender,
245         address indexed recipient,
246         bytes codeHash
247     );
248     event PaymentClosed(
249         uint txnId,
250         uint holdTime,
251         uint openTime,
252         uint closeTime,
253         address token,
254         uint sendAmount,
255         address indexed sender,
256         address indexed recipient,
257         bytes codeHash,
258         uint state
259     );
260 
261     // A Payment starts in the OPEN state.
262     // Once it is COMPLETED or CANCELLED, it cannot be changed further.
263     enum PaymentState {OPEN, COMPLETED, CANCELLED}
264     // Used when receiving signed messages to cancel or complete
265     // a payment.
266     enum CompletePaymentRequestType {CANCEL, RETRIEVE}
267 
268     // A Payment is created each time a sender wants to
269     // send an amount to a recipient.
270     struct Payment {
271         // timestamps are in epoch seconds
272         uint holdTime;
273         uint paymentOpenTime;
274         uint paymentCloseTime;
275         // Token contract address, 0 is Ether.
276         address token;
277         uint sendAmount;
278         address payable sender;
279         address payable recipient;
280         bytes codeHash;
281         PaymentState state;
282     }
283 
284     ReverseRegistrar reverseRegistrar;
285 
286     // EIP-712 code uses the examples provided at
287     // https://medium.com/metamask/eip712-is-coming-what-to-expect-and-how-to-use-it-bb92fd1a7a26
288     // TODO: the salt and verifyingContract still need to be changed.
289     // This struct and the associated typed signature are used for both
290     // cancelling and retrieving payments.
291     struct CompletePaymentRequest {
292         uint txnId;
293         address sender;
294         address recipient;
295         // Passphrase doesn't matter if the request ype is CANCEL.
296         string passphrase;
297         // CompletePaymentRequestType
298         uint requestType;
299     }
300 
301     // Payments are looked up with a uint UUID generated within the contract.
302     mapping(uint => Payment) openPayments;
303 
304     // This contract's owner (gives ability to set fees).
305     address payable public owner;
306     // The fees are represented with a percentage times 1 ether.
307     // The baseFee is to cover feeless retrieval
308     // The paymentFee is to cover development costs
309     uint public baseFee;
310     uint public paymentFee;
311     // mapping of token addresses to mapping of account balances (token=0 means Ether)
312     mapping(address => mapping(address => uint)) public tokens;
313 
314     // NOTE: We do not lock the cancel payment functionality, so that users
315     // will still be able to withdraw funds from payments they created.
316     // Failsafe to lock the create payments functionality for both ether and tokens.
317     bool public createPaymentEnabled;
318     // Failsafe to lock the retrieval (withdraw) functionality.
319     bool public retrieveFundsEnabled;
320 
321     address constant verifyingContract = 0x1C56346CD2A2Bf3202F771f50d3D14a367B48070;
322     bytes32 constant salt = 0xf2d857f4a3edcb9b78b4d503bfe733db1e3f6cdc2b7971ee739626c97e86a558;
323     string private constant COMPLETE_PAYMENT_REQUEST_TYPE = "CompletePaymentRequest(uint256 txnId,address sender,address recipient,string passphrase,uint256 requestType)";
324     string private constant EIP712_DOMAIN_TYPE = "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract,bytes32 salt)";
325     bytes32 private constant EIP712_DOMAIN_TYPEHASH = keccak256(
326         abi.encodePacked(EIP712_DOMAIN_TYPE)
327     );
328     bytes32 private constant COMPLETE_PAYMENT_REQUEST_TYPEHASH = keccak256(
329         abi.encodePacked(COMPLETE_PAYMENT_REQUEST_TYPE)
330     );
331     bytes32 private DOMAIN_SEPARATOR;
332     // The chainId is public because it differs between
333     // contract instances
334     uint256 public chainId;
335 
336     function hashCompletePaymentRequest(CompletePaymentRequest memory request)
337         private
338         view
339         returns (bytes32 hash)
340     {
341         return keccak256(
342             abi.encodePacked(
343                 "\x19\x01",
344                 DOMAIN_SEPARATOR,
345                 keccak256(
346                     abi.encode(
347                         COMPLETE_PAYMENT_REQUEST_TYPEHASH,
348                         request.txnId,
349                         request.sender,
350                         request.recipient,
351                         keccak256(bytes(request.passphrase)),
352                         request.requestType
353                     )
354                 )
355             )
356         );
357     }
358 
359     // Used to test the sign and recover functionality.
360     function getSignerForPaymentCompleteRequest(
361         uint256 txnId,
362         address sender,
363         address recipient,
364         string memory passphrase,
365         uint requestType,
366         bytes32 sigR,
367         bytes32 sigS,
368         uint8 sigV
369     ) public view returns (address result) {
370         CompletePaymentRequest memory request = CompletePaymentRequest(
371             txnId,
372             sender,
373             recipient,
374             passphrase,
375             requestType
376         );
377         address signer = ecrecover(
378             hashCompletePaymentRequest(request),
379             sigV,
380             sigR,
381             sigS
382         );
383         return signer;
384     }
385 
386     constructor(uint256 _chainId) public {
387         owner = msg.sender;
388         baseFee = 0.001 ether;
389         paymentFee = 0.005 ether;
390         createPaymentEnabled = true;
391         retrieveFundsEnabled = true;
392         chainId = _chainId;
393         DOMAIN_SEPARATOR = keccak256(
394             abi.encode(
395                 EIP712_DOMAIN_TYPEHASH,
396                 keccak256("Etherclear"),
397                 keccak256("1"),
398                 chainId,
399                 verifyingContract,
400                 salt
401             )
402         );
403     }
404 
405     modifier onlyOwner {
406         require(
407             msg.sender == owner,
408             "Only the contract owner is allowed to use this function."
409         );
410         _;
411     }
412 
413     /*
414     * SetENS sets the name of the reverse record so that it points to this contract address.
415     */
416     function setENS(address reverseRegistrarAddr, string memory name)
417         public
418         onlyOwner
419     {
420         reverseRegistrar = ReverseRegistrar(reverseRegistrarAddr);
421         reverseRegistrar.setName(name);
422 
423     }
424 
425     function withdrawFees(address token) external onlyOwner {
426         // The "owner" account is considered the fee account.
427         uint total = tokens[token][owner];
428         tokens[token][owner] = 0;
429         if (token == address(0)) {
430             owner.transfer(total);
431         } else {
432             require(
433                 IERC20(token).transfer(owner, total),
434                 "Could not successfully withdraw token"
435             );
436         }
437     }
438 
439     function viewBalance(address token, address user)
440         external
441         view
442         returns (uint balance)
443     {
444         return tokens[token][user];
445     }
446 
447     // TODO: change this so that the fee can only be decreased
448     // (once a suitable starting fee is reached).
449     function changeBaseFee(uint newFee) external onlyOwner {
450         baseFee = newFee;
451     }
452     function changePaymentFee(uint newFee) external onlyOwner {
453         paymentFee = newFee;
454     }
455 
456     function disableRetrieveFunds(bool disabled) public onlyOwner {
457         retrieveFundsEnabled = !disabled;
458     }
459 
460     function disableCreatePayment(bool disabled) public onlyOwner {
461         createPaymentEnabled = !disabled;
462     }
463 
464     function getPaymentInfo(uint paymentID)
465         external
466         view
467         returns (
468             uint holdTime,
469             uint paymentOpenTime,
470             uint paymentCloseTime,
471             address token,
472             uint sendAmount,
473             address sender,
474             address recipient,
475             bytes memory codeHash,
476             uint state
477         )
478     {
479         Payment memory txn = openPayments[paymentID];
480         return (
481             txn.holdTime,
482             txn.paymentOpenTime,
483             txn.paymentCloseTime,
484             txn.token,
485             txn.sendAmount,
486             txn.sender,
487             txn.recipient,
488             txn.codeHash,
489             uint(txn.state)
490         );
491     }
492 
493     function cancelPaymentAsSender(uint txnId) external {
494         // Check txn sender and state.
495         Payment memory txn = openPayments[txnId];
496         require(
497             txn.sender == msg.sender,
498             "Payment sender does not match message sender."
499         );
500         require(
501             txn.state == PaymentState.OPEN,
502             "Payment must be open to cancel."
503         );
504         cancelPayment(txnId);
505     }
506 
507     // Cancels the payment and returns the funds to the payment's sender.
508     // Assumes that checks have already been done on any external calls.
509     function cancelPayment(uint txnId) private {
510         // Check txn sender and state.
511         Payment memory txn = openPayments[txnId];
512 
513         // Update txn state.
514         txn.paymentCloseTime = now;
515         txn.state = PaymentState.CANCELLED;
516 
517         delete openPayments[txnId];
518 
519         // Return funds to sender.
520         if (txn.token == address(0)) {
521             tokens[address(0)][txn.sender] = SafeMath.sub(
522                 tokens[address(0)][txn.sender],
523                 txn.sendAmount
524             );
525             txn.sender.transfer(txn.sendAmount);
526         } else {
527             withdrawToken(txn.token, txn.sender, txn.sender, txn.sendAmount);
528         }
529 
530         emit PaymentClosed(
531             txnId,
532             txn.holdTime,
533             txn.paymentOpenTime,
534             txn.paymentCloseTime,
535             txn.token,
536             txn.sendAmount,
537             txn.sender,
538             txn.recipient,
539             txn.codeHash,
540             uint(txn.state)
541         );
542     }
543 
544     /**
545 * This function handles deposits of ERC-20 tokens to the contract.
546 * Does not allow Ether.
547 * If token transfer fails, payment is reverted and remaining gas is refunded.
548 * Additionally, includes a fee which must be accounted for when approving the amount.
549 * Note: Remember to call Token(address).approve(this, amount) or this contract will not be able to do the transfer on your behalf.
550 * @param token Ethereum contract address of the token or 0 for Ether
551 * @param originalAmount uint of the amount of the token the user wishes to deposit
552 * @param feeAmount uint total amount of the fee charged by the contract
553 */
554     // TODO: this doesn't follow checks-effects-interactions
555     // https://solidity.readthedocs.io/en/develop/security-considerations.html?highlight=check%20effects#use-the-checks-effects-interactions-pattern
556     function transferToken(
557         address token,
558         address user,
559         uint originalAmount,
560         uint feeAmount
561     ) internal {
562         require(token != address(0));
563         // TODO: use depositingTokenFlag in the ERC223 fallback function
564         //depositingTokenFlag = true;
565         require(
566             IERC20(token).transferFrom(
567                 user,
568                 address(this),
569                 SafeMath.add(originalAmount, feeAmount)
570             )
571         );
572         //depositingTokenFlag = false;
573         tokens[token][user] = SafeMath.add(
574             tokens[token][msg.sender],
575             originalAmount
576         );
577         tokens[token][owner] = SafeMath.add(tokens[token][owner], feeAmount);
578     }
579 
580     // TODO: Make sure to check if amounts are available
581     // We don't increment any balances because the funds are sent
582     // outside of the contract.
583     function withdrawToken(
584         address token,
585         address userFrom,
586         address userTo,
587         uint amount
588     ) internal {
589         require(token != address(0));
590         require(IERC20(token).transfer(userTo, amount));
591         tokens[token][userFrom] = SafeMath.sub(tokens[token][userFrom], amount);
592     }
593 
594     /* This takes ether for the fee amount*/
595     // TODO check order of execution.
596     function createPayment(
597         uint amount,
598         address payable recipient,
599         uint holdTime,
600         bytes calldata codeHash
601     ) external payable {
602         return createTokenPayment(
603             address(0),
604             amount,
605             recipient,
606             holdTime,
607             codeHash
608         );
609 
610     }
611 
612     // Meant to be used for the approve() call, since the
613     // amount in the ERC20 contract implementation will be
614     // overwritten with the amount requested in the next approve().
615     // This returns the amount of the token that the
616     // contract still holds.
617     // TODO: ensure this value will be correct.
618     function getBalance(address token) external view returns (uint amt) {
619         return tokens[token][msg.sender];
620     }
621 
622     function getPaymentId(address recipient, bytes memory codeHash)
623         public
624         pure
625         returns (uint result)
626     {
627         bytes memory txnIdBytes = abi.encodePacked(
628             keccak256(abi.encodePacked(codeHash, recipient))
629         );
630         uint txnId = sliceUint(txnIdBytes);
631         return txnId;
632     }
633     // Creates a new payment with the msg.sender as sender.
634     // Expected to take a base fee in ETH.
635     // Also takes a payment fee in either ETH or the token used,
636     // this payment fee is calculated from the original amount.
637     // We assume here that an approve() call has already been made for
638     // the original amount + payment fee.
639     function createTokenPayment(
640         address token,
641         uint amount,
642         address payable recipient,
643         uint holdTime,
644         bytes memory codeHash
645     ) public payable {
646         // Check amount and fee, make sure to truncate fee.
647         require(
648             createPaymentEnabled,
649             "The create payments functionality is currently disabled"
650         );
651         uint paymentFeeTotal = uint(
652             SafeMath.mul(paymentFee, amount) / (1 ether)
653         );
654         if (token == address(0)) {
655             require(
656                 msg.value >= (
657                     SafeMath.add(SafeMath.add(amount, baseFee), paymentFeeTotal)
658                 ),
659                 "Message value is not enough to cover amount and fees"
660             );
661         } else {
662             require(
663                 msg.value >= baseFee,
664                 "Message value is not enough to cover base fee"
665             );
666             // We don't check for a minimum when taking the paymentFee here. Since we don't
667             // care what the original sent amount was supposed to be, we just take a percentage and
668             // subtract that from the sent amount.
669         }
670 
671         // Check payment ID.
672         // TODO: should other components be included in the hash? This isn't secure
673         // if someone uses a bad codeHash. But they could mess up other components anyway,
674         // unless a UUID was generated in the contract, which is expensive.
675         uint txnId = getPaymentId(recipient, codeHash);
676         // If txnId already exists, don't overwrite.
677         require(
678             openPayments[txnId].sender == address(0),
679             "Payment ID must be unique. Use a different passphrase hash."
680         );
681 
682         // Create payments.
683         Payment memory txn = Payment(
684             holdTime,
685             now,
686             0,
687             token,
688             amount,
689             msg.sender,
690             recipient,
691             codeHash,
692             PaymentState.OPEN
693         );
694 
695         openPayments[txnId] = txn;
696 
697         // Take fees; mark ether or token balances.
698         if (token == address(0)) {
699             // Mark sender's ether balance with the sent amount
700             tokens[address(0)][msg.sender] = SafeMath.add(
701                 tokens[address(0)][msg.sender],
702                 amount
703             );
704 
705             // Take baseFee and paymentFee (and any ether sent in the message)
706             tokens[address(0)][owner] = SafeMath.add(
707                 tokens[address(0)][owner],
708                 SafeMath.sub(msg.value, amount)
709             );
710 
711         } else {
712             // Take baseFee (and any ether sent in the message)
713             tokens[address(0)][owner] = SafeMath.add(
714                 tokens[address(0)][owner],
715                 msg.value
716             );
717             // Transfer tokens; mark sender's balance; take paymentFee
718             transferToken(token, msg.sender, amount, paymentFeeTotal);
719         }
720 
721         // TODO: is this the best step to emit events?
722         emit PaymentOpened(
723             txnId,
724             txn.holdTime,
725             txn.paymentOpenTime,
726             txn.paymentCloseTime,
727             txn.token,
728             txn.sendAmount,
729             txn.sender,
730             txn.recipient,
731             txn.codeHash
732         );
733 
734     }
735 
736     // Meant to be called by anyone, on behalf of the recipient
737     // or sender of a payment, in order to retrieve funds or
738     // cancel the payment, respectively.
739     // Will only work if the correct signature is passed in.
740     function completePaymentAsProxy(
741         uint256 txnId,
742         address sender,
743         address recipient,
744         string memory passphrase,
745         uint requestType,
746         bytes32 sigR,
747         bytes32 sigS,
748         uint8 sigV
749     ) public {
750         CompletePaymentRequest memory request = CompletePaymentRequest(
751             txnId,
752             sender,
753             recipient,
754             passphrase,
755             requestType
756         );
757         address signer = ecrecover(
758             hashCompletePaymentRequest(request),
759             sigV,
760             sigR,
761             sigS
762         );
763 
764         require(
765             requestType == uint(
766                 CompletePaymentRequestType.CANCEL
767             ) || requestType == uint(CompletePaymentRequestType.RETRIEVE),
768             "requestType must be 0 (CANCEL) or 1 (RETRIEVE)"
769         );
770 
771         if (requestType == uint(CompletePaymentRequestType.RETRIEVE)) {
772             require(
773                 recipient == signer,
774                 "The message recipient must be the same as the signer of the message"
775             );
776             Payment memory txn = openPayments[txnId];
777             require(
778                 txn.recipient == recipient,
779                 "The payment's recipient must be the same as signer of the message"
780             );
781             retrieveFunds(txn, txnId, passphrase);
782         } else {
783             require(
784                 sender == signer,
785                 "The message sender must be the same as the signer of the message"
786             );
787             Payment memory txn = openPayments[txnId];
788             require(
789                 txn.sender == sender,
790                 "The payment's sender must be the same as signer of the message"
791             );
792             cancelPayment(txnId);
793         }
794     }
795 
796     // Meant to be called by the recipient.
797     function retrieveFundsAsRecipient(uint txnId, string memory code) public {
798         Payment memory txn = openPayments[txnId];
799 
800         // Check recipient
801         require(
802             txn.recipient == msg.sender,
803             "Message sender must match payment recipient"
804         );
805         retrieveFunds(txn, txnId, code);
806     }
807 
808     // Sends funds to a payment recipient.
809     // Internal ONLY, because it does not do any checks with msg.sender,
810     // and leaves that for calling functions.
811     // TODO: find a more secure way to implement the recipient check.
812     function retrieveFunds(Payment memory txn, uint txnId, string memory code)
813         private
814     {
815         require(
816             retrieveFundsEnabled,
817             "The retrieve funds functionality is currently disabled."
818         );
819         require(
820             txn.state == PaymentState.OPEN,
821             "Payment must be open to retrieve funds"
822         );
823         // TODO: make sure this is secure.
824         bytes memory actualHash = abi.encodePacked(
825             keccak256(abi.encodePacked(code, txn.recipient))
826         );
827         // Check codeHash
828         require(
829             sliceUint(actualHash) == sliceUint(txn.codeHash),
830             "Passphrase is not correct"
831         );
832 
833         // Check holdTime
834         require(
835             (txn.paymentOpenTime + txn.holdTime) > now,
836             "Hold time has already expired"
837         );
838 
839         // Update state.
840         txn.paymentCloseTime = now;
841         txn.state = PaymentState.COMPLETED;
842 
843         delete openPayments[txnId];
844 
845         // Transfer either ether or tokens.
846         if (txn.token == address(0)) {
847             // Pay out retrieved funds based on payment amount
848             // TODO: recipient must be valid!
849             txn.recipient.transfer(txn.sendAmount);
850             tokens[address(0)][txn.sender] = SafeMath.sub(
851                 tokens[address(0)][txn.sender],
852                 txn.sendAmount
853             );
854 
855         } else {
856             withdrawToken(txn.token, txn.sender, txn.recipient, txn.sendAmount);
857         }
858 
859         emit PaymentClosed(
860             txnId,
861             txn.holdTime,
862             txn.paymentOpenTime,
863             txn.paymentCloseTime,
864             txn.token,
865             txn.sendAmount,
866             txn.sender,
867             txn.recipient,
868             txn.codeHash,
869             uint(txn.state)
870         );
871 
872     }
873 
874     // Utility function to go from bytes -> uint
875     // This is apparently not reversible.
876     function sliceUint(bytes memory bs) public pure returns (uint) {
877         uint start = 0;
878         if (bs.length < start + 32) {
879             return 0;
880         }
881         uint x;
882         assembly {
883             x := mload(add(bs, add(0x20, start)))
884         }
885         return x;
886     }
887 
888 }