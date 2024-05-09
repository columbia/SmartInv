1 pragma solidity >=0.4.22 <0.6.0;
2 pragma experimental ABIEncoderV2;
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
44         require(b <= a, "SafeMath: subtraction overflow");
45         uint256 c = a - b;
46 
47         return c;
48     }
49 
50     /**
51      * @dev Returns the multiplication of two unsigned integers, reverting on
52      * overflow.
53      *
54      * Counterpart to Solidity's `*` operator.
55      *
56      * Requirements:
57      * - Multiplication cannot overflow.
58      */
59     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
60         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
61         // benefit is lost if 'b' is also tested.
62         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
63         if (a == 0) {
64             return 0;
65         }
66 
67         uint256 c = a * b;
68         require(c / a == b, "SafeMath: multiplication overflow");
69 
70         return c;
71     }
72 
73     /**
74      * @dev Returns the integer division of two unsigned integers. Reverts on
75      * division by zero. The result is rounded towards zero.
76      *
77      * Counterpart to Solidity's `/` operator. Note: this function uses a
78      * `revert` opcode (which leaves remaining gas untouched) while Solidity
79      * uses an invalid opcode to revert (consuming all remaining gas).
80      *
81      * Requirements:
82      * - The divisor cannot be zero.
83      */
84     function div(uint256 a, uint256 b) internal pure returns (uint256) {
85         // Solidity only automatically asserts when dividing by 0
86         require(b > 0, "SafeMath: division by zero");
87         uint256 c = a / b;
88         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
95      * Reverts when dividing by zero.
96      *
97      * Counterpart to Solidity's `%` operator. This function uses a `revert`
98      * opcode (which leaves remaining gas untouched) while Solidity uses an
99      * invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      * - The divisor cannot be zero.
103      */
104     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
105         require(b != 0, "SafeMath: modulo by zero");
106         return a % b;
107     }
108 }
109 
110 
111 contract LibMath {
112     using SafeMath for uint256;
113 
114     function getPartialAmount(
115         uint256 numerator,
116         uint256 denominator,
117         uint256 target
118     )
119         internal
120         pure
121         returns (uint256 partialAmount)
122     {
123         partialAmount = numerator.mul(target).div(denominator);
124     }
125 
126     function getFeeAmount(
127         uint256 numerator,
128         uint256 target
129     )
130         internal
131         pure
132         returns (uint256 feeAmount)
133     {
134         feeAmount = numerator.mul(target).div(1 ether); // todo: constants
135     }
136 }
137 
138 
139 
140 
141 contract LibOrder {
142 
143     struct Order {
144         uint256 makerSellAmount;
145         uint256 makerBuyAmount;
146         uint256 takerSellAmount;
147         uint256 salt;
148         uint256 expiration;
149         address taker;
150         address maker;
151         address makerSellToken;
152         address makerBuyToken;
153     }
154 
155     struct OrderInfo {
156         uint256 filledAmount;
157         bytes32 hash;
158         uint8 status;
159     }
160 
161     struct OrderFill {
162         uint256 makerFillAmount;
163         uint256 takerFillAmount;
164         uint256 takerFeePaid;
165         uint256 exchangeFeeReceived;
166         uint256 referralFeeReceived;
167         uint256 makerFeeReceived;
168     }
169 
170     enum OrderStatus {
171         INVALID_SIGNER,
172         INVALID_TAKER_AMOUNT,
173         INVALID_MAKER_AMOUNT,
174         FILLABLE,
175         EXPIRED,
176         FULLY_FILLED,
177         CANCELLED
178     }
179 
180     function getHash(Order memory order)
181         public
182         pure
183         returns (bytes32)
184     {
185         return keccak256(
186             abi.encodePacked(
187                 order.maker,
188                 order.makerSellToken,
189                 order.makerSellAmount,
190                 order.makerBuyToken,
191                 order.makerBuyAmount,
192                 order.salt,
193                 order.expiration
194             )
195         );
196     }
197 
198     function getPrefixedHash(Order memory order)
199         public
200         pure
201         returns (bytes32)
202     {
203         bytes32 orderHash = getHash(order);
204         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", orderHash));
205     }
206 }
207 
208 
209 
210 
211 contract LibSignatureValidator   {
212 
213     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
214         bytes32 r;
215         bytes32 s;
216         uint8 v;
217 
218         // Check the signature length
219         if (signature.length != 65) {
220             return (address(0));
221         }
222 
223         // Divide the signature in r, s and v variables
224         // ecrecover takes the signature parameters, and the only way to get them
225         // currently is to use assembly.
226         // solium-disable-next-line security/no-inline-assembly
227         assembly {
228             r := mload(add(signature, 0x20))
229             s := mload(add(signature, 0x40))
230             v := byte(0, mload(add(signature, 0x60)))
231         }
232 
233         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
234         if (v < 27) {
235             v += 27;
236         }
237 
238         // If the version is correct return the signer address
239         if (v != 27 && v != 28) {
240             return (address(0));
241         } else {
242             // solium-disable-next-line arg-overflow
243             return ecrecover(hash, v, r, s);
244         }
245     }
246 }
247 
248 
249 
250 
251 contract IKyberNetworkProxy {
252     function getExpectedRate(address src, address dest, uint srcQty) public view
253         returns (uint expectedRate, uint slippageRate);
254 
255     function trade(
256         address src,
257         uint srcAmount,
258         address dest,
259         address destAddress,
260         uint maxDestAmount,
261         uint minConversionRate,
262         address walletId
263     ) public payable returns(uint256);
264 }
265 
266 
267 
268 
269 contract LibKyberData {
270 
271     struct KyberData {
272         uint256 rate;
273         uint256 value;
274         address givenToken;
275         address receivedToken;
276     }
277 }
278 
279 
280 
281 
282 /**
283  * @dev Contract module which provides a basic access control mechanism, where
284  * there is an account (an owner) that can be granted exclusive access to
285  * specific functions.
286  *
287  * This module is used through inheritance. It will make available the modifier
288  * `onlyOwner`, which can be aplied to your functions to restrict their use to
289  * the owner.
290  */
291 contract Ownable {
292     address private _owner;
293 
294     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
295 
296     /**
297      * @dev Initializes the contract setting the deployer as the initial owner.
298      */
299     constructor () internal {
300         _owner = msg.sender;
301         emit OwnershipTransferred(address(0), _owner);
302     }
303 
304     /**
305      * @dev Returns the address of the current owner.
306      */
307     function owner() public view returns (address) {
308         return _owner;
309     }
310 
311     /**
312      * @dev Throws if called by any account other than the owner.
313      */
314     modifier onlyOwner() {
315         require(isOwner(), "Ownable: caller is not the owner");
316         _;
317     }
318 
319     /**
320      * @dev Returns true if the caller is the current owner.
321      */
322     function isOwner() public view returns (bool) {
323         return msg.sender == _owner;
324     }
325 
326     /**
327      * @dev Leaves the contract without owner. It will not be possible to call
328      * `onlyOwner` functions anymore. Can only be called by the current owner.
329      *
330      * > Note: Renouncing ownership will leave the contract without an owner,
331      * thereby removing any functionality that is only available to the owner.
332      */
333     function renounceOwnership() public onlyOwner {
334         emit OwnershipTransferred(_owner, address(0));
335         _owner = address(0);
336     }
337 
338     /**
339      * @dev Transfers ownership of the contract to a new account (`newOwner`).
340      * Can only be called by the current owner.
341      */
342     function transferOwnership(address newOwner) public onlyOwner {
343         _transferOwnership(newOwner);
344     }
345 
346     /**
347      * @dev Transfers ownership of the contract to a new account (`newOwner`).
348      */
349     function _transferOwnership(address newOwner) internal {
350         require(newOwner != address(0), "Ownable: new owner is the zero address");
351         emit OwnershipTransferred(_owner, newOwner);
352         _owner = newOwner;
353     }
354 }
355 
356 
357 
358 
359 contract IExchangeUpgradability {
360 
361     uint8 public VERSION;
362 
363     event FundsMigrated(address indexed user, address indexed newExchange);
364     
365     function allowOrRestrictMigrations() external;
366 
367     function migrateFunds(address[] calldata tokens) external;
368 
369     function migrateEthers() private;
370 
371     function migrateTokens(address[] memory tokens) private;
372 
373     function importEthers(address user) external payable;
374 
375     function importTokens(address tokenAddress, uint256 tokenAmount, address user) external;
376 
377 }
378 
379 
380 
381 
382 contract LibCrowdsale {
383 
384     using SafeMath for uint256;
385 
386     struct Crowdsale {
387         uint256 startBlock;
388         uint256 endBlock;
389         uint256 hardCap;
390         uint256 leftAmount;
391         uint256 tokenRatio;
392         uint256 minContribution;
393         uint256 maxContribution;
394         uint256 weiRaised;
395         address wallet;
396     }
397 
398     enum ContributionStatus {
399         CROWDSALE_NOT_OPEN,
400         MIN_CONTRIBUTION,
401         MAX_CONTRIBUTION,
402         HARDCAP_REACHED,
403         VALID
404     }
405 
406     enum CrowdsaleStatus {
407         INVALID_START_BLOCK,
408         INVALID_END_BLOCK,
409         INVALID_TOKEN_RATIO,
410         INVALID_LEFT_AMOUNT,
411         VALID
412     }
413 
414     function getCrowdsaleStatus(Crowdsale memory crowdsale)
415         public
416         view
417         returns (CrowdsaleStatus)
418     {
419 
420         if(crowdsale.startBlock < block.number) {
421             return CrowdsaleStatus.INVALID_START_BLOCK;
422         }
423 
424         if(crowdsale.endBlock < crowdsale.startBlock) {
425             return CrowdsaleStatus.INVALID_END_BLOCK;
426         }
427 
428         if(crowdsale.tokenRatio == 0) {
429             return CrowdsaleStatus.INVALID_TOKEN_RATIO;
430         }
431 
432         uint256 tokenForSale = crowdsale.hardCap.mul(crowdsale.tokenRatio);
433 
434         if(tokenForSale != crowdsale.leftAmount) {
435             return CrowdsaleStatus.INVALID_LEFT_AMOUNT;
436         }
437 
438         return CrowdsaleStatus.VALID;
439     }
440 
441     function isOpened(uint256 startBlock, uint256 endBlock)
442         internal
443         view
444         returns (bool)
445     {
446         return (block.number >= startBlock && block.number <= endBlock);
447     }
448 
449 
450     function isFinished(uint256 endBlock)
451         internal
452         view
453         returns (bool)
454     {
455         return block.number > endBlock;
456     }
457 }
458 
459 
460 
461 
462 /**
463  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
464  * the optional functions; to access them see `ERC20Detailed`.
465  */
466 interface IERC20 {
467     /**
468      * @dev Returns the amount of tokens in existence.
469      */
470     function totalSupply() external view returns (uint256);
471 
472     /**
473      * @dev Returns the amount of tokens owned by `account`.
474      */
475     function balanceOf(address account) external view returns (uint256);
476 
477     /**
478      * @dev Moves `amount` tokens from the caller's account to `recipient`.
479      *
480      * Returns a boolean value indicating whether the operation succeeded.
481      *
482      * Emits a `Transfer` event.
483      */
484     function transfer(address recipient, uint256 amount) external returns (bool);
485 
486     /**
487      * @dev Returns the remaining number of tokens that `spender` will be
488      * allowed to spend on behalf of `owner` through `transferFrom`. This is
489      * zero by default.
490      *
491      * This value changes when `approve` or `transferFrom` are called.
492      */
493     function allowance(address owner, address spender) external view returns (uint256);
494 
495     /**
496      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
497      *
498      * Returns a boolean value indicating whether the operation succeeded.
499      *
500      * > Beware that changing an allowance with this method brings the risk
501      * that someone may use both the old and the new allowance by unfortunate
502      * transaction ordering. One possible solution to mitigate this race
503      * condition is to first reduce the spender's allowance to 0 and set the
504      * desired value afterwards:
505      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
506      *
507      * Emits an `Approval` event.
508      */
509     function approve(address spender, uint256 amount) external returns (bool);
510 
511     /**
512      * @dev Moves `amount` tokens from `sender` to `recipient` using the
513      * allowance mechanism. `amount` is then deducted from the caller's
514      * allowance.
515      *
516      * Returns a boolean value indicating whether the operation succeeded.
517      *
518      * Emits a `Transfer` event.
519      */
520     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
521 
522     function decimals() external view returns (uint8);
523 
524     /**
525      * @dev Emitted when `value` tokens are moved from one account (`from`) to
526      * another (`to`).
527      *
528      * Note that `value` may be zero.
529      */
530     event Transfer(address indexed from, address indexed to, uint256 value);
531 
532     /**
533      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
534      * a call to `approve`. `value` is the new allowance.
535      */
536     event Approval(address indexed owner, address indexed spender, uint256 value);
537 
538 }
539 
540 
541 
542 
543 /**
544  * @dev Collection of functions related to the address type,
545  */
546 library Address {
547     /**
548      * @dev Returns true if `account` is a contract.
549      *
550      * This test is non-exhaustive, and there may be false-negatives: during the
551      * execution of a contract's constructor, its address will be reported as
552      * not containing a contract.
553      *
554      * > It is unsafe to assume that an address for which this function returns
555      * false is an externally-owned account (EOA) and not a contract.
556      */
557     function isContract(address account) internal view returns (bool) {
558         // This method relies in extcodesize, which returns 0 for contracts in
559         // construction, since the code is only stored at the end of the
560         // constructor execution.
561 
562         uint256 size;
563         // solhint-disable-next-line no-inline-assembly
564         assembly { size := extcodesize(account) }
565         return size > 0;
566     }
567 }
568 
569 
570 
571 
572 contract ExchangeStorage is Ownable {
573 
574     /**
575       * @dev The minimum fee rate that the maker will receive
576       * Note: 20% = 20 * 10^16
577       */
578     uint256 constant internal minMakerFeeRate = 200000000000000000;
579 
580     /**
581       * @dev The maximum fee rate that the maker will receive
582       * Note: 90% = 90 * 10^16
583       */
584     uint256 constant internal maxMakerFeeRate = 900000000000000000;
585 
586     /**
587       * @dev The minimum fee rate that the taker will pay
588       * Note: 0.1% = 0.1 * 10^16
589       */
590     uint256 constant internal minTakerFeeRate = 1000000000000000;
591 
592     /**
593       * @dev The maximum fee rate that the taker will pay
594       * Note: 1% = 1 * 10^16
595       */
596     uint256 constant internal maxTakerFeeRate = 10000000000000000;
597 
598     /**
599       * @dev The referrer will receive 10% from each taker fee.
600       * Note: 10% = 10 * 10^16
601       */
602     uint256 constant internal referralFeeRate = 100000000000000000;
603 
604     /**
605       * @dev The amount of percentage the maker will receive from each taker fee.
606       * Note: Initially: 50% = 50 * 10^16
607       */
608     uint256 public makerFeeRate;
609 
610     /**
611       * @dev The amount of percentage the will pay for taking an order.
612       * Note: Initially: 0.2% = 0.2 * 10^16
613       */
614     uint256 public takerFeeRate;
615 
616     /**
617       * @dev 2-level map: tokenAddress -> userAddress -> balance
618       */
619     mapping(address => mapping(address => uint256)) internal balances;
620 
621     /**
622       * @dev map: orderHash -> filled amount
623       */
624     mapping(bytes32 => uint256) internal filled;
625 
626     /**
627       * @dev map: orderHash -> isCancelled
628       */
629     mapping(bytes32 => bool) internal cancelled;
630 
631     /**
632       * @dev map: user -> userReferrer
633       */
634     mapping(address => address) internal referrals;
635 
636     /**
637       * @dev The address where all exchange fees (0,08%) are kept.
638       * Node: multisig wallet
639       */
640     address public feeAccount;
641 
642     /**
643       * @return return the balance of `token` for certain `user`
644       */
645     function getBalance(
646         address user,
647         address token
648     )
649         public
650         view
651         returns (uint256)
652     {
653         return balances[token][user];
654     }
655 
656     /**
657       * @return return the balance of multiple tokens for certain `user`
658       */
659     function getBalances(
660         address user,
661         address[] memory token
662     )
663         public
664         view
665         returns(uint256[] memory balanceArray)
666     {
667         balanceArray = new uint256[](token.length);
668 
669         for(uint256 index = 0; index < token.length; index++) {
670             balanceArray[index] = balances[token[index]][user];
671         }
672     }
673 
674     /**
675       * @return return the filled amount of order specified by `orderHash`
676       */
677     function getFill(
678         bytes32 orderHash
679     )
680         public
681         view
682         returns (uint256)
683     {
684         return filled[orderHash];
685     }
686 
687     /**
688       * @return return the filled amount of multple orders specified by `orderHash` array
689       */
690     function getFills(
691         bytes32[] memory orderHash
692     )
693         public
694         view
695         returns (uint256[] memory filledArray)
696     {
697         filledArray = new uint256[](orderHash.length);
698 
699         for(uint256 index = 0; index < orderHash.length; index++) {
700             filledArray[index] = filled[orderHash[index]];
701         }
702     }
703 
704     /**
705       * @return return true(false) if order specified by `orderHash` is(not) cancelled
706       */
707     function getCancel(
708         bytes32 orderHash
709     )
710         public
711         view
712         returns (bool)
713     {
714         return cancelled[orderHash];
715     }
716 
717     /**
718       * @return return array of true(false) if orders specified by `orderHash` array are(not) cancelled
719       */
720     function getCancels(
721         bytes32[] memory orderHash
722     )
723         public
724         view
725         returns (bool[]memory cancelledArray)
726     {
727         cancelledArray = new bool[](orderHash.length);
728 
729         for(uint256 index = 0; index < orderHash.length; index++) {
730             cancelledArray[index] = cancelled[orderHash[index]];
731         }
732     }
733 
734     /**
735       * @return return the referrer address of `user`
736       */
737     function getReferral(
738         address user
739     )
740         public
741         view
742         returns (address)
743     {
744         return referrals[user];
745     }
746 
747     /**
748       * @return set new rate for the maker fee received
749       */
750     function setMakerFeeRate(
751         uint256 newMakerFeeRate
752     )
753         external
754         onlyOwner
755     {
756         require(
757             newMakerFeeRate >= minMakerFeeRate &&
758             newMakerFeeRate <= maxMakerFeeRate,
759             "INVALID_MAKER_FEE_RATE"
760         );
761         makerFeeRate = newMakerFeeRate;
762     }
763 
764     /**
765       * @return set new rate for the taker fee paid
766       */
767     function setTakerFeeRate(
768         uint256 newTakerFeeRate
769     )
770         external
771         onlyOwner
772     {
773         require(
774             newTakerFeeRate >= minTakerFeeRate &&
775             newTakerFeeRate <= maxTakerFeeRate,
776             "INVALID_TAKER_FEE_RATE"
777         );
778 
779         takerFeeRate = newTakerFeeRate;
780     }
781 
782     /**
783       * @return set new fee account
784       */
785     function setFeeAccount(
786         address newFeeAccount
787     )
788         external
789         onlyOwner
790     {
791         feeAccount = newFeeAccount;
792     }
793 }
794 
795 
796 
797 
798 /**
799  * @title SafeERC20
800  * @dev Wrappers around ERC20 operations that throw on failure (when the token
801  * contract returns false). Tokens that return no value (and instead revert or
802  * throw on failure) are also supported, non-reverting calls are assumed to be
803  * successful.
804  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
805  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
806  */
807 library SafeERC20 {
808     using SafeMath for uint256;
809     using Address for address;
810 
811     function safeTransfer(IERC20 token, address to, uint256 value) internal {
812         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
813     }
814 
815     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
816         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
817     }
818 
819     function safeApprove(IERC20 token, address spender, uint256 value) internal {
820         // safeApprove should only be called when setting an initial allowance,
821         // or when resetting it to zero. To increase and decrease it, use
822         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
823         // solhint-disable-next-line max-line-length
824         require((value == 0) || (token.allowance(address(this), spender) == 0),
825             "SafeERC20: approve from non-zero to non-zero allowance"
826         );
827         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
828     }
829 
830     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
831         uint256 newAllowance = token.allowance(address(this), spender).add(value);
832         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
833     }
834 
835     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
836         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
837         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
838     }
839 
840     /**
841      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
842      * on the return value: the return value is optional (but if data is returned, it must not be false).
843      * @param token The token targeted by the call.
844      * @param data The call data (encoded using abi.encode or one of its variants).
845      */
846     function callOptionalReturn(IERC20 token, bytes memory data) private {
847         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
848         // we're implementing it ourselves.
849 
850         // A Solidity high level call has three parts:
851         //  1. The target address is checked to verify it contains contract code
852         //  2. The call itself is made, and success asserted
853         //  3. The return value is decoded, which in turn checks the size of the returned data.
854         // solhint-disable-next-line max-line-length
855         require(address(token).isContract(), "SafeERC20: call to non-contract");
856 
857         // solhint-disable-next-line avoid-low-level-calls
858         (bool success, bytes memory returndata) = address(token).call(data);
859         require(success, "SafeERC20: low-level call failed");
860 
861         if (returndata.length > 0) { // Return data is optional
862             // solhint-disable-next-line max-line-length
863             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
864         }
865     }
866 }
867 
868 
869 
870 
871 contract Exchange is LibMath, LibOrder, LibSignatureValidator, ExchangeStorage {
872 
873     using SafeMath for uint256;
874 
875     /**
876       * @dev emitted when a trade is executed
877       */
878     event Trade(
879         address indexed makerAddress,        // Address that created the order
880         address indexed takerAddress,        // Address that filled the order
881         bytes32 indexed orderHash,           // Hash of the order
882         address makerFilledAsset,            // Address of assets filled for maker
883         address takerFilledAsset,            // Address of assets filled for taker
884         uint256 makerFilledAmount,           // Amount of assets filled for maker
885         uint256 takerFilledAmount,           // Amount of assets filled for taker
886         uint256 takerFeePaid,                // Amount of fee paid by the taker
887         uint256 makerFeeReceived,            // Amount of fee received by the maker
888         uint256 referralFeeReceived          // Amount of fee received by the referrer
889     );
890 
891     /**
892       * @dev emitted when a cancel order is executed
893       */
894     event Cancel(
895         address indexed makerBuyToken,        // Address of asset being bought.
896         address makerSellToken,               // Address of asset being sold.
897         address indexed maker,                // Address that created the order
898         bytes32 indexed orderHash             // Hash of the order
899     );
900 
901     /**
902       * @dev Compute the status of an order.
903       * Should be called before a contract execution is performet in order to not waste gas.
904       * @return OrderStatus.FILLABLE if the order is valid for taking.
905       * Note: See LibOrder.sol to see all statuses
906       */
907     function getOrderInfo(
908         uint256 partialAmount,
909         Order memory order
910     )
911         public
912         view
913         returns (OrderInfo memory orderInfo)
914     {
915         // Compute the order hash
916         orderInfo.hash = getPrefixedHash(order);
917 
918         // Fetch filled amount
919         orderInfo.filledAmount = filled[orderInfo.hash];
920 
921         // Check taker balance
922         if(balances[order.makerBuyToken][order.taker] < order.takerSellAmount) {
923             orderInfo.status = uint8(OrderStatus.INVALID_TAKER_AMOUNT);
924             return orderInfo;
925         }
926 
927         // Check maker balance
928         if(balances[order.makerSellToken][order.maker] < partialAmount) {
929             orderInfo.status = uint8(OrderStatus.INVALID_MAKER_AMOUNT);
930             return orderInfo;
931         }
932 
933         // Check if order is filled
934         if (orderInfo.filledAmount.add(order.takerSellAmount) > order.makerBuyAmount) {
935             orderInfo.status = uint8(OrderStatus.FULLY_FILLED);
936             return orderInfo;
937         }
938 
939         // Check for expiration
940         if (block.number >= order.expiration) {
941             orderInfo.status = uint8(OrderStatus.EXPIRED);
942             return orderInfo;
943         }
944 
945         // Check if order has been cancelled
946         if (cancelled[orderInfo.hash]) {
947             orderInfo.status = uint8(OrderStatus.CANCELLED);
948             return orderInfo;
949         }
950 
951         orderInfo.status = uint8(OrderStatus.FILLABLE);
952         return orderInfo;
953     }
954 
955     /**
956       * @dev Execute a trade based on the input order and signature.
957       * Reverts if order is not valid
958       */
959     function trade(
960         Order memory order,
961         bytes memory signature
962     )
963         public
964     {
965         bool result = _trade(order, signature);
966         require(result, "INVALID_TRADE");
967     }
968 
969     /**
970       * @dev Execute a trade based on the input order and signature.
971       * If the order is valid returns true.
972       */
973     function _trade(
974         Order memory order,
975         bytes memory signature
976     )
977         internal
978         returns(bool)
979     {
980         order.taker = msg.sender;
981 
982         uint256 takerReceivedAmount = getPartialAmount(
983             order.makerSellAmount,
984             order.makerBuyAmount,
985             order.takerSellAmount
986         );
987 
988         OrderInfo memory orderInfo = getOrderInfo(takerReceivedAmount, order);
989 
990         uint8 status = assertTakeOrder(orderInfo.hash, orderInfo.status, order.maker, signature);
991 
992         if(status != uint8(OrderStatus.FILLABLE)) {
993             return false;
994         }
995 
996         OrderFill memory orderFill = getOrderFillResult(takerReceivedAmount, order);
997 
998         executeTrade(order, orderFill);
999 
1000         filled[orderInfo.hash] = filled[orderInfo.hash].add(order.takerSellAmount);
1001 
1002         emit Trade(
1003             order.maker,
1004             order.taker,
1005             orderInfo.hash,
1006             order.makerBuyToken,
1007             order.makerSellToken,
1008             orderFill.makerFillAmount,
1009             orderFill.takerFillAmount,
1010             orderFill.takerFeePaid,
1011             orderFill.makerFeeReceived,
1012             orderFill.referralFeeReceived
1013         );
1014 
1015         return true;
1016     }
1017 
1018     /**
1019       * @dev Cancel an order if msg.sender is the order signer.
1020       */
1021     function cancelSingleOrder(
1022         Order memory order,
1023         bytes memory signature
1024     )
1025         public
1026     {
1027         bytes32 orderHash = getPrefixedHash(order);
1028 
1029         require(
1030             recover(orderHash, signature) == msg.sender,
1031             "INVALID_SIGNER"
1032         );
1033 
1034         require(
1035             cancelled[orderHash] == false,
1036             "ALREADY_CANCELLED"
1037         );
1038 
1039         cancelled[orderHash] = true;
1040 
1041         emit Cancel(
1042             order.makerBuyToken,
1043             order.makerSellToken,
1044             msg.sender,
1045             orderHash
1046         );
1047     }
1048 
1049     /**
1050       * @dev Computation of the following properties based on the order input:
1051       * takerFillAmount -> amount of assets received by the taker
1052       * makerFillAmount -> amount of assets received by the maker
1053       * takerFeePaid -> amount of fee paid by the taker (0.2% of takerFillAmount)
1054       * makerFeeReceived -> amount of fee received by the maker (50% of takerFeePaid)
1055       * referralFeeReceived -> amount of fee received by the taker referrer (10% of takerFeePaid)
1056       * exchangeFeeReceived -> amount of fee received by the exchange (40% of takerFeePaid)
1057       */
1058     function getOrderFillResult(
1059         uint256 takerReceivedAmount,
1060         Order memory order
1061     )
1062         internal
1063         view
1064         returns (OrderFill memory orderFill)
1065     {
1066         orderFill.takerFillAmount = takerReceivedAmount;
1067 
1068         orderFill.makerFillAmount = order.takerSellAmount;
1069 
1070         // 0.2% == 0.2*10^16
1071         orderFill.takerFeePaid = getFeeAmount(
1072             takerReceivedAmount,
1073             takerFeeRate
1074         );
1075 
1076         // 50% of taker fee == 50*10^16
1077         orderFill.makerFeeReceived = getFeeAmount(
1078             orderFill.takerFeePaid,
1079             makerFeeRate
1080         );
1081 
1082         // 10% of taker fee == 10*10^16
1083         orderFill.referralFeeReceived = getFeeAmount(
1084             orderFill.takerFeePaid,
1085             referralFeeRate
1086         );
1087 
1088         // exchangeFee = (takerFeePaid - makerFeeReceived - referralFeeReceived)
1089         orderFill.exchangeFeeReceived = orderFill.takerFeePaid.sub(
1090             orderFill.makerFeeReceived).sub(
1091                 orderFill.referralFeeReceived);
1092 
1093     }
1094 
1095     /**
1096       * @dev Throws when the order status is invalid or the signer is not valid.
1097       */
1098     function assertTakeOrder(
1099         bytes32 orderHash,
1100         uint8 status,
1101         address signer,
1102         bytes memory signature
1103     )
1104         internal
1105         pure
1106         returns(uint8)
1107     {
1108         uint8 result = uint8(OrderStatus.FILLABLE);
1109 
1110         if(recover(orderHash, signature) != signer) {
1111             result = uint8(OrderStatus.INVALID_SIGNER);
1112         }
1113 
1114         if(status != uint8(OrderStatus.FILLABLE)) {
1115             result = status;
1116         }
1117 
1118         return status;
1119     }
1120 
1121     /**
1122       * @dev Updates the contract state i.e. user balances
1123       */
1124     function executeTrade(
1125         Order memory order,
1126         OrderFill memory orderFill
1127     )
1128         private
1129     {
1130         uint256 makerGiveAmount = orderFill.takerFillAmount.sub(orderFill.makerFeeReceived);
1131         uint256 takerFillAmount = orderFill.takerFillAmount.sub(orderFill.takerFeePaid);
1132 
1133         address referrer = referrals[order.taker];
1134         address feeAddress = feeAccount;
1135 
1136         balances[order.makerSellToken][referrer] = balances[order.makerSellToken][referrer].add(orderFill.referralFeeReceived);
1137         balances[order.makerSellToken][feeAddress] = balances[order.makerSellToken][feeAddress].add(orderFill.exchangeFeeReceived);
1138 
1139         balances[order.makerBuyToken][order.taker] = balances[order.makerBuyToken][order.taker].sub(orderFill.makerFillAmount);
1140         balances[order.makerBuyToken][order.maker] = balances[order.makerBuyToken][order.maker].add(orderFill.makerFillAmount);
1141 
1142         balances[order.makerSellToken][order.taker] = balances[order.makerSellToken][order.taker].add(takerFillAmount);
1143         balances[order.makerSellToken][order.maker] = balances[order.makerSellToken][order.maker].sub(makerGiveAmount);
1144     }
1145 }
1146 
1147 
1148 
1149 
1150 contract ExchangeKyberProxy is Exchange, LibKyberData {
1151     using SafeERC20 for IERC20;
1152 
1153     /**
1154       * @dev The precision used for calculating the amounts - 10*18
1155       */
1156     uint256 constant internal PRECISION = 1000000000000000000;
1157 
1158     /**
1159       * @dev Max decimals allowed when calculating amounts.
1160       */
1161     uint256 constant internal MAX_DECIMALS = 18;
1162 
1163     /**
1164       * @dev Decimals of Ether.
1165       */
1166     uint256 constant internal ETH_DECIMALS = 18;
1167 
1168     /**
1169       * @dev The address that represents ETH in Kyber Network Contracts.
1170       */
1171     address constant internal KYBER_ETH_TOKEN_ADDRESS =
1172         address(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
1173 
1174     uint256 constant internal MAX_DEST_AMOUNT = 2**256 - 1;
1175 
1176     /**
1177       * @dev KyberNetworkProxy contract address
1178       */
1179     IKyberNetworkProxy constant internal kyberNetworkContract =
1180         IKyberNetworkProxy(0x818E6FECD516Ecc3849DAf6845e3EC868087B755);
1181 
1182     /**
1183       * @dev Swaps ETH/TOKEN, TOKEN/ETH or TOKEN/TOKEN using KyberNetwork reserves.
1184       */
1185     function kyberSwap(
1186         uint256 givenAmount,
1187         address givenToken,
1188         address receivedToken,
1189         bytes32 hash
1190     )
1191         public
1192         payable
1193     {
1194         address taker = msg.sender;
1195 
1196         KyberData memory kyberData = getSwapInfo(
1197             givenAmount,
1198             givenToken,
1199             receivedToken,
1200             taker
1201         );
1202 
1203         uint256 convertedAmount = kyberNetworkContract.trade.value(kyberData.value)(
1204             kyberData.givenToken,
1205             givenAmount,
1206             kyberData.receivedToken,
1207             taker,
1208             MAX_DEST_AMOUNT,
1209             kyberData.rate,
1210             feeAccount
1211         );
1212 
1213         emit Trade(
1214             address(kyberNetworkContract),
1215             taker,
1216             hash,
1217             givenToken,
1218             receivedToken,
1219             givenAmount,
1220             convertedAmount,
1221             0,
1222             0,
1223             0
1224         );
1225     }
1226 
1227     /**
1228       * @dev Exchange ETH/TOKEN, TOKEN/ETH or TOKEN/TOKEN using the internal
1229       * balance mapping that keeps track of user's balances. It requires user to first invoke deposit function.
1230       * The function relies on KyberNetworkProxy contract.
1231       */
1232     function kyberTrade(
1233         uint256 givenAmount,
1234         address givenToken,
1235         address receivedToken,
1236         bytes32 hash
1237     )
1238         public
1239     {
1240         address taker = msg.sender;
1241 
1242         KyberData memory kyberData = getTradeInfo(
1243             givenAmount,
1244             givenToken,
1245             receivedToken
1246         );
1247 
1248         balances[givenToken][taker] = balances[givenToken][taker].sub(givenAmount);
1249 
1250         uint256 convertedAmount = kyberNetworkContract.trade.value(kyberData.value)(
1251             kyberData.givenToken,
1252             givenAmount,
1253             kyberData.receivedToken,
1254             address(this),
1255             MAX_DEST_AMOUNT,
1256             kyberData.rate,
1257             feeAccount
1258         );
1259 
1260         balances[receivedToken][taker] = balances[receivedToken][taker].add(convertedAmount);
1261 
1262         emit Trade(
1263             address(kyberNetworkContract),
1264             taker,
1265             hash,
1266             givenToken,
1267             receivedToken,
1268             givenAmount,
1269             convertedAmount,
1270             0,
1271             0,
1272             0
1273         );
1274     }
1275 
1276     /**
1277       * @dev Helper function to determine what is being swapped.
1278       */
1279     function getSwapInfo(
1280         uint256 givenAmount,
1281         address givenToken,
1282         address receivedToken,
1283         address taker
1284     )
1285         private
1286         returns(KyberData memory)
1287     {
1288         KyberData memory kyberData;
1289         uint256 givenTokenDecimals;
1290         uint256 receivedTokenDecimals;
1291 
1292         if(givenToken == address(0x0)) {
1293             require(msg.value == givenAmount, "INVALID_ETH_VALUE");
1294 
1295             kyberData.givenToken = KYBER_ETH_TOKEN_ADDRESS;
1296             kyberData.receivedToken = receivedToken;
1297             kyberData.value = givenAmount;
1298 
1299             givenTokenDecimals = ETH_DECIMALS;
1300             receivedTokenDecimals = IERC20(receivedToken).decimals();
1301         } else if(receivedToken == address(0x0)) {
1302             kyberData.givenToken = givenToken;
1303             kyberData.receivedToken = KYBER_ETH_TOKEN_ADDRESS;
1304             kyberData.value = 0;
1305 
1306             givenTokenDecimals = IERC20(givenToken).decimals();
1307             receivedTokenDecimals = ETH_DECIMALS;
1308 
1309             IERC20(givenToken).safeTransferFrom(taker, address(this), givenAmount);
1310             IERC20(givenToken).safeApprove(address(kyberNetworkContract), givenAmount);
1311         } else {
1312             kyberData.givenToken = givenToken;
1313             kyberData.receivedToken = receivedToken;
1314             kyberData.value = 0;
1315 
1316             givenTokenDecimals = IERC20(givenToken).decimals();
1317             receivedTokenDecimals = IERC20(receivedToken).decimals();
1318 
1319             IERC20(givenToken).safeTransferFrom(taker, address(this), givenAmount);
1320             IERC20(givenToken).safeApprove(address(kyberNetworkContract), givenAmount);
1321         }
1322 
1323         (kyberData.rate, ) = kyberNetworkContract.getExpectedRate(
1324             kyberData.givenToken,
1325             kyberData.receivedToken,
1326             givenAmount
1327         );
1328 
1329         return kyberData;
1330     }
1331 
1332     /**
1333       * @dev Helper function to determines what is being
1334         swapped using the internal balance mapping.
1335       */
1336     function getTradeInfo(
1337         uint256 givenAmount,
1338         address givenToken,
1339         address receivedToken
1340     )
1341         private
1342         returns(KyberData memory)
1343     {
1344         KyberData memory kyberData;
1345         uint256 givenTokenDecimals;
1346         uint256 receivedTokenDecimals;
1347 
1348         if(givenToken == address(0x0)) {
1349             kyberData.givenToken = KYBER_ETH_TOKEN_ADDRESS;
1350             kyberData.receivedToken = receivedToken;
1351             kyberData.value = givenAmount;
1352 
1353             givenTokenDecimals = ETH_DECIMALS;
1354             receivedTokenDecimals = IERC20(receivedToken).decimals();
1355         } else if(receivedToken == address(0x0)) {
1356             kyberData.givenToken = givenToken;
1357             kyberData.receivedToken = KYBER_ETH_TOKEN_ADDRESS;
1358             kyberData.value = 0;
1359 
1360             givenTokenDecimals = IERC20(givenToken).decimals();
1361             receivedTokenDecimals = ETH_DECIMALS;
1362             IERC20(givenToken).safeApprove(address(kyberNetworkContract), givenAmount);
1363         } else {
1364             kyberData.givenToken = givenToken;
1365             kyberData.receivedToken = receivedToken;
1366             kyberData.value = 0;
1367 
1368             givenTokenDecimals = IERC20(givenToken).decimals();
1369             receivedTokenDecimals = IERC20(receivedToken).decimals();
1370             IERC20(givenToken).safeApprove(address(kyberNetworkContract), givenAmount);
1371         }
1372 
1373         (kyberData.rate, ) = kyberNetworkContract.getExpectedRate(
1374             kyberData.givenToken,
1375             kyberData.receivedToken,
1376             givenAmount
1377         );
1378 
1379         return kyberData;
1380     }
1381 
1382     function getExpectedRateBatch(
1383         address[] memory givenTokens,
1384         address[] memory receivedTokens,
1385         uint256[] memory givenAmounts
1386     )
1387         public
1388         view
1389         returns(uint256[] memory, uint256[] memory)
1390     {
1391         uint256 size = givenTokens.length;
1392         uint256[] memory expectedRates = new uint256[](size);
1393         uint256[] memory slippageRates = new uint256[](size);
1394 
1395         for(uint256 index = 0; index < size; index++) {
1396             (expectedRates[index], slippageRates[index]) = kyberNetworkContract.getExpectedRate(
1397                 givenTokens[index],
1398                 receivedTokens[index],
1399                 givenAmounts[index]
1400             );
1401         }
1402 
1403        return (expectedRates, slippageRates);
1404     }
1405 }
1406 
1407 
1408 
1409 
1410 contract ExchangeBatchTrade is Exchange {
1411 
1412     /**
1413       * @dev Cancel an array of orders if msg.sender is the order signer.
1414       */
1415     function cancelMultipleOrders(
1416         Order[] memory orders,
1417         bytes[] memory signatures
1418     )
1419         public
1420     {
1421         for (uint256 index = 0; index < orders.length; index++) {
1422             cancelSingleOrder(
1423                 orders[index],
1424                 signatures[index]
1425             );
1426         }
1427     }
1428 
1429     /**
1430       * @dev Execute multiple trades based on the input orders and signatures.
1431       * Note: reverts of one or more trades fail.
1432       */
1433     function takeAllOrRevert(
1434         Order[] memory orders,
1435         bytes[] memory signatures
1436     )
1437         public
1438     {
1439         for (uint256 index = 0; index < orders.length; index++) {
1440             bool result = _trade(orders[index], signatures[index]);
1441             require(result, "INVALID_TAKEALL");
1442         }
1443     }
1444 
1445     /**
1446       * @dev Execute multiple trades based on the input orders and signatures.
1447       * Note: does not revert if one or more trades fail.
1448       */
1449     function takeAllPossible(
1450         Order[] memory orders,
1451         bytes[] memory signatures
1452     )
1453         public
1454     {
1455         for (uint256 index = 0; index < orders.length; index++) {
1456             _trade(orders[index], signatures[index]);
1457         }
1458     }
1459 }
1460 
1461 
1462 
1463 
1464 contract ExchangeMovements is ExchangeStorage {
1465 
1466     using SafeERC20 for IERC20;
1467     using SafeMath for uint256;
1468 
1469     /**
1470       * @dev emitted when a deposit is received
1471       */
1472     event Deposit(
1473         address indexed token,
1474         address indexed user,
1475         address indexed referral,
1476         address beneficiary,
1477         uint256 amount,
1478         uint256 balance
1479     );
1480 
1481     /**
1482       * @dev emitted when a withdraw is received
1483       */
1484     event Withdraw(
1485         address indexed token,
1486         address indexed user,
1487         uint256 amount,
1488         uint256 balance
1489     );
1490 
1491     /**
1492       * @dev emitted when a transfer is received
1493       */
1494     event Transfer(
1495         address indexed token,
1496         address indexed user,
1497         address indexed beneficiary,
1498         uint256 amount,
1499         uint256 userBalance,
1500         uint256 beneficiaryBalance
1501     );
1502 
1503     /**
1504       * @dev Updates the level 2 map `balances` based on the input
1505       *      Note: token address is (0x0) when the deposit is for ETH
1506       */
1507     function deposit(
1508         address token,
1509         uint256 amount,
1510         address beneficiary,
1511         address referral
1512     )
1513         public
1514         payable
1515     {
1516         uint256 value = amount;
1517         address user = msg.sender;
1518 
1519         if(token == address(0x0)) {
1520             value = msg.value;
1521         } else {
1522             IERC20(token).safeTransferFrom(user, address(this), value);
1523         }
1524 
1525         balances[token][beneficiary] = balances[token][beneficiary].add(value);
1526 
1527         if(referrals[user] == address(0x0)) {
1528             referrals[user] = referral;
1529         }
1530 
1531         emit Deposit(
1532             token,
1533             user,
1534             referrals[user],
1535             beneficiary,
1536             value,
1537             balances[token][beneficiary]
1538         );
1539     }
1540 
1541     /**
1542       * @dev Updates the level 2 map `balances` based on the input
1543       *      Note: token address is (0x0) when the deposit is for ETH
1544       */
1545     function withdraw(
1546         address token,
1547         uint amount
1548     )
1549         public
1550     {
1551         address payable user = msg.sender;
1552 
1553         require(
1554             balances[token][user] >= amount,
1555             "INVALID_WITHDRAW"
1556         );
1557 
1558         balances[token][user] = balances[token][user].sub(amount);
1559 
1560         if (token == address(0x0)) {
1561             user.transfer(amount);
1562         } else {
1563             IERC20(token).safeTransfer(user, amount);
1564         }
1565 
1566         emit Withdraw(
1567             token,
1568             user,
1569             amount,
1570             balances[token][user]
1571         );
1572     }
1573 
1574     /**
1575       * @dev Transfer assets between two users inside the exchange. Updates the level 2 map `balances`
1576       */
1577     function transfer(
1578         address token,
1579         address to,
1580         uint256 amount
1581     )
1582         external
1583         payable
1584     {
1585         address user = msg.sender;
1586 
1587         require(
1588             balances[token][user] >= amount,
1589             "INVALID_TRANSFER"
1590         );
1591 
1592         balances[token][user] = balances[token][user].sub(amount);
1593 
1594         balances[token][to] = balances[token][to].add(amount);
1595 
1596         emit Transfer(
1597             token,
1598             user,
1599             to,
1600             amount,
1601             balances[token][user],
1602             balances[token][to]
1603         );
1604     }
1605 }
1606 
1607 
1608 
1609 
1610 contract ExchangeUpgradability is Ownable, ExchangeStorage {
1611 
1612     using SafeERC20 for IERC20;
1613     using SafeMath for uint256;
1614 
1615     /**
1616       * @dev version of the exchange
1617       */
1618     uint8 constant public VERSION = 1;
1619 
1620     /**
1621       * @dev the address of the upgraded exchange contract
1622       */
1623     address public newExchange;
1624 
1625     /**
1626       * @dev flag to allow migrating to an upgraded contract
1627       */
1628     bool public migrationAllowed;
1629 
1630     /**
1631       * @dev emitted when funds are migrated
1632       */
1633     event FundsMigrated(address indexed user, address indexed newExchange);
1634 
1635     /**
1636     * @dev Owner can set the address of the new version of the exchange contract.
1637     */
1638     function setNewExchangeAddress(address exchange)
1639         external
1640         onlyOwner
1641     {
1642         newExchange = exchange;
1643     }
1644 
1645     /**
1646     * @dev Enables/Disables the migrations. Can be called only by the owner.
1647     */
1648     function allowOrRestrictMigrations()
1649         external
1650         onlyOwner
1651     {
1652         migrationAllowed = !migrationAllowed;
1653     }
1654 
1655     /**
1656     * @dev Migrating assets of the caller to the new exchange contract
1657     */
1658     function migrateFunds(address[] calldata tokens) external {
1659 
1660         require(
1661             false != migrationAllowed,
1662             "MIGRATIONS_DISALLOWED"
1663         );
1664 
1665         require(
1666             IExchangeUpgradability(newExchange).VERSION() > VERSION,
1667             "INVALID_VERSION"
1668         );
1669 
1670         migrateEthers();
1671 
1672         migrateTokens(tokens);
1673 
1674         emit FundsMigrated(msg.sender, newExchange);
1675     }
1676 
1677     /**
1678     * @dev Helper function to migrate user's Ethers. Should be called in migrateFunds() function.
1679     */
1680     function migrateEthers() private {
1681         address user = msg.sender;
1682         uint256 etherAmount = balances[address(0x0)][user];
1683         if (etherAmount > 0) {
1684             balances[address(0x0)][user] = 0;
1685             IExchangeUpgradability(newExchange).importEthers.value(etherAmount)(user);
1686         }
1687     }
1688 
1689     /**
1690     * @dev Helper function to migrate user's tokens. Should be called in migrateFunds() function.
1691     */
1692     function migrateTokens(address[] memory tokens) private {
1693         address user = msg.sender;
1694         address exchange = newExchange;
1695         for (uint256 index = 0; index < tokens.length; index++) {
1696 
1697             address tokenAddress = tokens[index];
1698 
1699             uint256 tokenAmount = balances[tokenAddress][user];
1700 
1701             if (0 == tokenAmount) {
1702                 continue;
1703             }
1704 
1705             IERC20(tokenAddress).safeApprove(exchange, tokenAmount);
1706 
1707             balances[tokenAddress][user] = 0;
1708 
1709             IExchangeUpgradability(exchange).importTokens(tokenAddress, tokenAmount, user);
1710         }
1711     }
1712 
1713     /**
1714     * @dev Helper function to migrate user's Ethers. Should be called only from the new exchange contract.
1715     */
1716     function importEthers(address user)
1717         external
1718         payable
1719     {
1720         require(
1721             false != migrationAllowed,
1722             "MIGRATION_DISALLOWED"
1723         );
1724 
1725         require(
1726             user != address(0x0),
1727             "INVALID_USER"
1728         );
1729 
1730         require(
1731             msg.value > 0,
1732             "INVALID_AMOUNT"
1733         );
1734 
1735         require(
1736             IExchangeUpgradability(msg.sender).VERSION() < VERSION,
1737             "INVALID_VERSION"
1738         );
1739 
1740         balances[address(0x0)][user] = balances[address(0x0)][user].add(msg.value); // todo: constants
1741     }
1742     
1743     /**
1744     * @dev Helper function to migrate user's Tokens. Should be called only from the new exchange contract.
1745     */
1746     function importTokens(
1747         address token,
1748         uint256 amount,
1749         address user
1750     )
1751         external
1752     {
1753         require(
1754             false != migrationAllowed,
1755             "MIGRATION_DISALLOWED"
1756         );
1757 
1758         require(
1759             token != address(0x0),
1760             "INVALID_TOKEN"
1761         );
1762 
1763         require(
1764             user != address(0x0),
1765             "INVALID_USER"
1766         );
1767 
1768         require(
1769             amount > 0,
1770             "INVALID_AMOUNT"
1771         );
1772 
1773         require(
1774             IExchangeUpgradability(msg.sender).VERSION() < VERSION,
1775             "INVALID_VERSION"
1776         );
1777 
1778         IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
1779 
1780         balances[token][user] = balances[token][user].add(amount);
1781     }
1782 }
1783 
1784 
1785 
1786 
1787 contract ExchangeOffering is ExchangeStorage, LibCrowdsale {
1788 
1789     address constant internal BURN_ADDRESS = address(0x000000000000000000000000000000000000dEaD);
1790     address constant internal ETH_ADDRESS = address(0x0);
1791 
1792     using SafeERC20 for IERC20;
1793 
1794     using SafeMath for uint256;
1795 
1796     mapping(address => Crowdsale) public crowdsales;
1797 
1798     mapping(address => mapping(address => uint256)) public contributions;
1799 
1800     event TokenPurchase(
1801         address indexed token,
1802         address indexed user,
1803         uint256 tokenAmount,
1804         uint256 weiAmount
1805     );
1806 
1807     event TokenBurned(
1808         address indexed token,
1809         uint256 tokenAmount
1810     );
1811 
1812     function registerCrowdsale(
1813         Crowdsale memory crowdsale,
1814         address token
1815     )
1816         public
1817         onlyOwner
1818     {
1819         require(
1820             CrowdsaleStatus.VALID == getCrowdsaleStatus(crowdsale),
1821             "INVALID_CROWDSALE"
1822         );
1823 
1824         require(
1825             crowdsales[token].wallet == address(0),
1826             "CROWDSALE_ALREADY_EXISTS"
1827         );
1828 
1829         uint256 tokenForSale = crowdsale.hardCap.mul(crowdsale.tokenRatio);
1830 
1831         IERC20(token).safeTransferFrom(crowdsale.wallet, address(this), tokenForSale);
1832 
1833         crowdsales[token] = crowdsale;
1834     }
1835 
1836     function buyTokens(address token)
1837        public
1838        payable
1839     {
1840         require(msg.value != 0, "INVALID_MSG_VALUE");
1841 
1842         uint256 weiAmount = msg.value;
1843 
1844         address user = msg.sender;
1845 
1846         Crowdsale memory crowdsale = crowdsales[token];
1847 
1848         require(
1849             ContributionStatus.VALID == validContribution(weiAmount, crowdsale, user, token),
1850             "INVALID_CONTRIBUTION"
1851         );
1852 
1853         uint256 purchasedTokens = weiAmount.mul(crowdsale.tokenRatio);
1854 
1855         crowdsale.leftAmount = crowdsale.leftAmount.sub(purchasedTokens);
1856 
1857         crowdsale.weiRaised = crowdsale.weiRaised.add(weiAmount);
1858 
1859         balances[ETH_ADDRESS][crowdsale.wallet] = balances[ETH_ADDRESS][crowdsale.wallet].add(weiAmount);
1860 
1861         balances[token][user] = balances[token][user].add(purchasedTokens);
1862 
1863         contributions[token][user] = contributions[token][user].add(weiAmount);
1864 
1865         crowdsales[token] = crowdsale;
1866 
1867         emit TokenPurchase(token, user, purchasedTokens, weiAmount);
1868     }
1869 
1870     function burnTokensWhenFinished(address token) public
1871     {
1872         require(
1873             isFinished(crowdsales[token].endBlock),
1874             "CROWDSALE_NOT_FINISHED_YET"
1875         );
1876 
1877         uint256 leftAmount = crowdsales[token].leftAmount;
1878 
1879         crowdsales[token].leftAmount = 0;
1880 
1881         IERC20(token).safeTransfer(BURN_ADDRESS, leftAmount);
1882 
1883         emit TokenBurned(token, leftAmount);
1884     }
1885 
1886     function validContribution(
1887         uint256 weiAmount,
1888         Crowdsale memory crowdsale,
1889         address user,
1890         address token
1891     )
1892         public
1893         view
1894         returns(ContributionStatus)
1895     {
1896         if (!isOpened(crowdsale.startBlock, crowdsale.endBlock)) {
1897             return ContributionStatus.CROWDSALE_NOT_OPEN;
1898         }
1899 
1900         if(weiAmount < crowdsale.minContribution) {
1901             return ContributionStatus.MIN_CONTRIBUTION;
1902         }
1903 
1904         if (contributions[token][user].add(weiAmount) > crowdsale.maxContribution) {
1905             return ContributionStatus.MAX_CONTRIBUTION;
1906         }
1907 
1908         if (crowdsale.hardCap < crowdsale.weiRaised.add(weiAmount)) {
1909             return ContributionStatus.HARDCAP_REACHED;
1910         }
1911 
1912         return ContributionStatus.VALID;
1913     }
1914 }
1915 
1916 
1917 
1918 
1919 contract ExchangeSwap is Exchange, ExchangeMovements  {
1920 
1921     /**
1922       * @dev Swaps ETH/TOKEN, TOKEN/ETH or TOKEN/TOKEN using off-chain signed messages.
1923       * The flow of the function is Deposit -> Trade -> Withdraw to allow users to directly
1924       * take liquidity without the need of deposit and withdraw.
1925       */
1926     function swapFill(
1927         Order[] memory orders,
1928         bytes[] memory signatures,
1929         uint256 givenAmount,
1930         address givenToken,
1931         address receivedToken,
1932         address referral
1933     )
1934         public
1935         payable
1936     {
1937         address taker = msg.sender;
1938 
1939         uint256 balanceGivenBefore = balances[givenToken][taker];
1940         uint256 balanceReceivedBefore = balances[receivedToken][taker];
1941 
1942         deposit(givenToken, givenAmount, taker, referral);
1943 
1944         for (uint256 index = 0; index < orders.length; index++) {
1945             require(orders[index].makerBuyToken == givenToken, "GIVEN_TOKEN");
1946             require(orders[index].makerSellToken == receivedToken, "RECEIVED_TOKEN");
1947 
1948             _trade(orders[index], signatures[index]);
1949         }
1950 
1951         uint256 balanceGivenAfter = balances[givenToken][taker];
1952         uint256 balanceReceivedAfter = balances[receivedToken][taker];
1953 
1954         uint256 balanceGivenDelta = balanceGivenAfter.sub(balanceGivenBefore);
1955         uint256 balanceReceivedDelta = balanceReceivedAfter.sub(balanceReceivedBefore);
1956 
1957         if(balanceGivenDelta > 0) {
1958             withdraw(givenToken, balanceGivenDelta);
1959         }
1960 
1961         if(balanceReceivedDelta > 0) {
1962             withdraw(receivedToken, balanceReceivedDelta);
1963         }
1964     }
1965 }
1966 
1967 
1968 
1969 
1970 contract WeiDex is
1971     Exchange,
1972     ExchangeKyberProxy,
1973     ExchangeBatchTrade,
1974     ExchangeMovements,
1975     ExchangeUpgradability,
1976     ExchangeOffering,
1977     ExchangeSwap
1978 {
1979     function () external payable { }
1980 }