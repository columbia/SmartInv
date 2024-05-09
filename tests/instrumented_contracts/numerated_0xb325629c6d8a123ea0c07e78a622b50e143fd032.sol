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
111 
112 
113 
114 contract LibMath {
115     using SafeMath for uint256;
116 
117     function getPartialAmount(
118         uint256 numerator,
119         uint256 denominator,
120         uint256 target
121     )
122         internal
123         pure
124         returns (uint256 partialAmount)
125     {
126         partialAmount = numerator.mul(target).div(denominator);
127     }
128 
129     function getFeeAmount(
130         uint256 numerator,
131         uint256 target
132     )
133         internal
134         pure
135         returns (uint256 feeAmount)
136     {
137         feeAmount = numerator.mul(target).div(1 ether); // todo: constants
138     }
139 }
140 
141 
142 
143 
144 
145 contract LibOrder {
146 
147     struct Order {
148         uint256 makerSellAmount;
149         uint256 makerBuyAmount;
150         uint256 takerSellAmount;
151         uint256 salt;
152         uint256 expiration;
153         address taker;
154         address maker;
155         address makerSellToken;
156         address makerBuyToken;
157     }
158 
159     struct OrderInfo {
160         uint256 filledAmount;
161         bytes32 hash;
162         uint8 status;
163     }
164 
165     struct OrderFill {
166         uint256 makerFillAmount;
167         uint256 takerFillAmount;
168         uint256 takerFeePaid;
169         uint256 exchangeFeeReceived;
170         uint256 referralFeeReceived;
171         uint256 makerFeeReceived;
172     }
173 
174     enum OrderStatus {
175         INVALID_SIGNER,
176         INVALID_TAKER_AMOUNT,
177         INVALID_MAKER_AMOUNT,
178         FILLABLE,
179         EXPIRED,
180         FULLY_FILLED,
181         CANCELLED
182     }
183 
184     function getHash(Order memory order)
185         public
186         pure
187         returns (bytes32)
188     {
189         return keccak256(
190             abi.encodePacked(
191                 order.maker,
192                 order.makerSellToken,
193                 order.makerSellAmount,
194                 order.makerBuyToken,
195                 order.makerBuyAmount,
196                 order.salt,
197                 order.expiration
198             )
199         );
200     }
201 
202     function getPrefixedHash(Order memory order)
203         public
204         pure
205         returns (bytes32)
206     {
207         bytes32 orderHash = getHash(order);
208         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", orderHash));
209     }
210 }
211 
212 
213 
214 
215 
216 contract LibSignatureValidator   {
217 
218     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
219         bytes32 r;
220         bytes32 s;
221         uint8 v;
222 
223         // Check the signature length
224         if (signature.length != 65) {
225             return (address(0));
226         }
227 
228         // Divide the signature in r, s and v variables
229         // ecrecover takes the signature parameters, and the only way to get them
230         // currently is to use assembly.
231         // solium-disable-next-line security/no-inline-assembly
232         assembly {
233             r := mload(add(signature, 0x20))
234             s := mload(add(signature, 0x40))
235             v := byte(0, mload(add(signature, 0x60)))
236         }
237 
238         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
239         if (v < 27) {
240             v += 27;
241         }
242 
243         // If the version is correct return the signer address
244         if (v != 27 && v != 28) {
245             return (address(0));
246         } else {
247             // solium-disable-next-line arg-overflow
248             return ecrecover(hash, v, r, s);
249         }
250     }
251 }
252 
253 
254 
255 
256 
257 contract IKyberNetworkProxy {
258     function getExpectedRate(address src, address dest, uint srcQty) public view
259         returns (uint expectedRate, uint slippageRate);
260 
261     function trade(
262         address src,
263         uint srcAmount,
264         address dest,
265         address destAddress,
266         uint maxDestAmount,
267         uint minConversionRate,
268         address walletId
269     ) public payable returns(uint256);
270 }
271 
272 
273 
274 
275 
276 contract LibKyberData {
277 
278     struct KyberData {
279         uint256 expectedReceiveAmount;
280         uint256 rate;
281         uint256 value;
282         address givenToken;
283         address receivedToken;
284     }
285 }
286 
287 
288 
289 
290 
291 /**
292  * @dev Contract module which provides a basic access control mechanism, where
293  * there is an account (an owner) that can be granted exclusive access to
294  * specific functions.
295  *
296  * This module is used through inheritance. It will make available the modifier
297  * `onlyOwner`, which can be aplied to your functions to restrict their use to
298  * the owner.
299  */
300 contract Ownable {
301     address private _owner;
302 
303     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
304 
305     /**
306      * @dev Initializes the contract setting the deployer as the initial owner.
307      */
308     constructor () internal {
309         _owner = msg.sender;
310         emit OwnershipTransferred(address(0), _owner);
311     }
312 
313     /**
314      * @dev Returns the address of the current owner.
315      */
316     function owner() public view returns (address) {
317         return _owner;
318     }
319 
320     /**
321      * @dev Throws if called by any account other than the owner.
322      */
323     modifier onlyOwner() {
324         require(isOwner(), "Ownable: caller is not the owner");
325         _;
326     }
327 
328     /**
329      * @dev Returns true if the caller is the current owner.
330      */
331     function isOwner() public view returns (bool) {
332         return msg.sender == _owner;
333     }
334 
335     /**
336      * @dev Leaves the contract without owner. It will not be possible to call
337      * `onlyOwner` functions anymore. Can only be called by the current owner.
338      *
339      * > Note: Renouncing ownership will leave the contract without an owner,
340      * thereby removing any functionality that is only available to the owner.
341      */
342     function renounceOwnership() public onlyOwner {
343         emit OwnershipTransferred(_owner, address(0));
344         _owner = address(0);
345     }
346 
347     /**
348      * @dev Transfers ownership of the contract to a new account (`newOwner`).
349      * Can only be called by the current owner.
350      */
351     function transferOwnership(address newOwner) public onlyOwner {
352         _transferOwnership(newOwner);
353     }
354 
355     /**
356      * @dev Transfers ownership of the contract to a new account (`newOwner`).
357      */
358     function _transferOwnership(address newOwner) internal {
359         require(newOwner != address(0), "Ownable: new owner is the zero address");
360         emit OwnershipTransferred(_owner, newOwner);
361         _owner = newOwner;
362     }
363 }
364 
365 
366 
367 
368 
369 contract IExchangeUpgradability {
370 
371     uint8 public VERSION;
372 
373     event FundsMigrated(address indexed user, address indexed newExchange);
374     
375     function allowOrRestrictMigrations() external;
376 
377     function migrateFunds(address[] calldata tokens) external;
378 
379     function migrateEthers() private;
380 
381     function migrateTokens(address[] memory tokens) private;
382 
383     function importEthers(address user) external payable;
384 
385     function importTokens(address tokenAddress, uint256 tokenAmount, address user) external;
386 
387 }
388 
389 
390 
391 
392 
393 contract LibCrowdsale {
394 
395     using SafeMath for uint256;
396 
397     struct Crowdsale {
398         uint256 startBlock;
399         uint256 endBlock;
400         uint256 hardCap;
401         uint256 leftAmount;
402         uint256 tokenRatio;
403         uint256 minContribution;
404         uint256 maxContribution;
405         uint256 weiRaised;
406         address wallet;
407     }
408 
409     enum ContributionStatus {
410         CROWDSALE_NOT_OPEN,
411         MIN_CONTRIBUTION,
412         MAX_CONTRIBUTION,
413         HARDCAP_REACHED,
414         VALID
415     }
416 
417     enum CrowdsaleStatus {
418         INVALID_START_BLOCK,
419         INVALID_END_BLOCK,
420         INVALID_TOKEN_RATIO,
421         INVALID_LEFT_AMOUNT,
422         VALID
423     }
424 
425     function getCrowdsaleStatus(Crowdsale memory crowdsale)
426         public
427         view
428         returns (CrowdsaleStatus)
429     {
430 
431         if(crowdsale.startBlock < block.number) {
432             return CrowdsaleStatus.INVALID_START_BLOCK;
433         }
434 
435         if(crowdsale.endBlock < crowdsale.startBlock) {
436             return CrowdsaleStatus.INVALID_END_BLOCK;
437         }
438 
439         if(crowdsale.tokenRatio == 0) {
440             return CrowdsaleStatus.INVALID_TOKEN_RATIO;
441         }
442 
443         uint256 tokenForSale = crowdsale.hardCap.mul(crowdsale.tokenRatio);
444 
445         if(tokenForSale != crowdsale.leftAmount) {
446             return CrowdsaleStatus.INVALID_LEFT_AMOUNT;
447         }
448 
449         return CrowdsaleStatus.VALID;
450     }
451 
452     function isOpened(uint256 startBlock, uint256 endBlock)
453         internal
454         view
455         returns (bool)
456     {
457         return (block.number >= startBlock && block.number <= endBlock);
458     }
459 
460 
461     function isFinished(uint256 endBlock)
462         internal
463         view
464         returns (bool)
465     {
466         return block.number > endBlock;
467     }
468 }
469 
470 
471 
472 
473 
474 /**
475  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
476  * the optional functions; to access them see `ERC20Detailed`.
477  */
478 interface IERC20 {
479     /**
480      * @dev Returns the amount of tokens in existence.
481      */
482     function totalSupply() external view returns (uint256);
483 
484     /**
485      * @dev Returns the amount of tokens owned by `account`.
486      */
487     function balanceOf(address account) external view returns (uint256);
488 
489     /**
490      * @dev Moves `amount` tokens from the caller's account to `recipient`.
491      *
492      * Returns a boolean value indicating whether the operation succeeded.
493      *
494      * Emits a `Transfer` event.
495      */
496     function transfer(address recipient, uint256 amount) external returns (bool);
497 
498     /**
499      * @dev Returns the remaining number of tokens that `spender` will be
500      * allowed to spend on behalf of `owner` through `transferFrom`. This is
501      * zero by default.
502      *
503      * This value changes when `approve` or `transferFrom` are called.
504      */
505     function allowance(address owner, address spender) external view returns (uint256);
506 
507     function decimals() external view returns (uint8);
508     /**
509      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
510      *
511      * Returns a boolean value indicating whether the operation succeeded.
512      *
513      * > Beware that changing an allowance with this method brings the risk
514      * that someone may use both the old and the new allowance by unfortunate
515      * transaction ordering. One possible solution to mitigate this race
516      * condition is to first reduce the spender's allowance to 0 and set the
517      * desired value afterwards:
518      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
519      *
520      * Emits an `Approval` event.
521      */
522     function approve(address spender, uint256 amount) external returns (bool);
523 
524     /**
525      * @dev Moves `amount` tokens from `sender` to `recipient` using the
526      * allowance mechanism. `amount` is then deducted from the caller's
527      * allowance.
528      *
529      * Returns a boolean value indicating whether the operation succeeded.
530      *
531      * Emits a `Transfer` event.
532      */
533     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
534 
535     /**
536      * @dev Emitted when `value` tokens are moved from one account (`from`) to
537      * another (`to`).
538      *
539      * Note that `value` may be zero.
540      */
541     event Transfer(address indexed from, address indexed to, uint256 value);
542 
543     /**
544      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
545      * a call to `approve`. `value` is the new allowance.
546      */
547     event Approval(address indexed owner, address indexed spender, uint256 value);
548 }
549 
550 
551 
552 
553 
554 /**
555  * @dev Collection of functions related to the address type,
556  */
557 library Address {
558     /**
559      * @dev Returns true if `account` is a contract.
560      *
561      * This test is non-exhaustive, and there may be false-negatives: during the
562      * execution of a contract's constructor, its address will be reported as
563      * not containing a contract.
564      *
565      * > It is unsafe to assume that an address for which this function returns
566      * false is an externally-owned account (EOA) and not a contract.
567      */
568     function isContract(address account) internal view returns (bool) {
569         // This method relies in extcodesize, which returns 0 for contracts in
570         // construction, since the code is only stored at the end of the
571         // constructor execution.
572 
573         uint256 size;
574         // solhint-disable-next-line no-inline-assembly
575         assembly { size := extcodesize(account) }
576         return size > 0;
577     }
578 }
579 
580 
581 
582 
583 
584 contract ExchangeStorage is Ownable {
585 
586     /**
587       * @dev The minimum fee rate that the maker will receive
588       * Note: 20% = 20 * 10^16
589       */
590     uint256 constant internal minMakerFeeRate = 200000000000000000;
591 
592     /**
593       * @dev The maximum fee rate that the maker will receive
594       * Note: 90% = 90 * 10^16
595       */
596     uint256 constant internal maxMakerFeeRate = 900000000000000000;
597 
598     /**
599       * @dev The minimum fee rate that the taker will pay
600       * Note: 0.1% = 0.1 * 10^16
601       */
602     uint256 constant internal minTakerFeeRate = 1000000000000000;
603 
604     /**
605       * @dev The maximum fee rate that the taker will pay
606       * Note: 1% = 1 * 10^16
607       */
608     uint256 constant internal maxTakerFeeRate = 10000000000000000;
609 
610     /**
611       * @dev The referrer will receive 10% from each taker fee.
612       * Note: 10% = 10 * 10^16
613       */
614     uint256 constant internal referralFeeRate = 100000000000000000;
615 
616     /**
617       * @dev The amount of percentage the maker will receive from each taker fee.
618       * Note: Initially: 50% = 50 * 10^16
619       */
620     uint256 public makerFeeRate;
621 
622     /**
623       * @dev The amount of percentage the will pay for taking an order.
624       * Note: Initially: 0.2% = 0.2 * 10^16
625       */
626     uint256 public takerFeeRate;
627 
628     /**
629       * @dev 2-level map: tokenAddress -> userAddress -> balance
630       */
631     mapping(address => mapping(address => uint256)) internal balances;
632 
633     /**
634       * @dev map: orderHash -> filled amount
635       */
636     mapping(bytes32 => uint256) internal filled;
637 
638     /**
639       * @dev map: orderHash -> isCancelled
640       */
641     mapping(bytes32 => bool) internal cancelled;
642 
643     /**
644       * @dev map: user -> userReferrer
645       */
646     mapping(address => address) internal referrals;
647 
648     /**
649       * @dev The address where all exchange fees (0,08%) are kept.
650       * Node: multisig wallet
651       */
652     address public feeAccount;
653 
654     /**
655       * @return return the balance of `token` for certain `user`
656       */
657     function getBalance(
658         address user,
659         address token
660     )
661         public
662         view
663         returns (uint256)
664     {
665         return balances[token][user];
666     }
667 
668     /**
669       * @return return the balance of multiple tokens for certain `user`
670       */
671     function getBalances(
672         address user,
673         address[] memory token
674     )
675         public
676         view
677         returns(uint256[] memory balanceArray)
678     {
679         balanceArray = new uint256[](token.length);
680 
681         for(uint256 index = 0; index < token.length; index++) {
682             balanceArray[index] = balances[token[index]][user];
683         }
684     }
685 
686     /**
687       * @return return the filled amount of order specified by `orderHash`
688       */
689     function getFill(
690         bytes32 orderHash
691     )
692         public
693         view
694         returns (uint256)
695     {
696         return filled[orderHash];
697     }
698 
699     /**
700       * @return return the filled amount of multple orders specified by `orderHash` array
701       */
702     function getFills(
703         bytes32[] memory orderHash
704     )
705         public
706         view
707         returns (uint256[] memory filledArray)
708     {
709         filledArray = new uint256[](orderHash.length);
710 
711         for(uint256 index = 0; index < orderHash.length; index++) {
712             filledArray[index] = filled[orderHash[index]];
713         }
714     }
715 
716     /**
717       * @return return true(false) if order specified by `orderHash` is(not) cancelled
718       */
719     function getCancel(
720         bytes32 orderHash
721     )
722         public
723         view
724         returns (bool)
725     {
726         return cancelled[orderHash];
727     }
728 
729     /**
730       * @return return array of true(false) if orders specified by `orderHash` array are(not) cancelled
731       */
732     function getCancels(
733         bytes32[] memory orderHash
734     )
735         public
736         view
737         returns (bool[]memory cancelledArray)
738     {
739         cancelledArray = new bool[](orderHash.length);
740 
741         for(uint256 index = 0; index < orderHash.length; index++) {
742             cancelledArray[index] = cancelled[orderHash[index]];
743         }
744     }
745 
746     /**
747       * @return return the referrer address of `user`
748       */
749     function getReferral(
750         address user
751     )
752         public
753         view
754         returns (address)
755     {
756         return referrals[user];
757     }
758 
759     /**
760       * @return set new rate for the maker fee received
761       */
762     function setMakerFeeRate(
763         uint256 newMakerFeeRate
764     )
765         external
766         onlyOwner
767     {
768         require(
769             newMakerFeeRate >= minMakerFeeRate &&
770             newMakerFeeRate <= maxMakerFeeRate,
771             "INVALID_MAKER_FEE_RATE"
772         );
773         makerFeeRate = newMakerFeeRate;
774     }
775 
776     /**
777       * @return set new rate for the taker fee paid
778       */
779     function setTakerFeeRate(
780         uint256 newTakerFeeRate
781     )
782         external
783         onlyOwner
784     {
785         require(
786             newTakerFeeRate >= minTakerFeeRate &&
787             newTakerFeeRate <= maxTakerFeeRate,
788             "INVALID_TAKER_FEE_RATE"
789         );
790 
791         takerFeeRate = newTakerFeeRate;
792     }
793 
794     /**
795       * @return set new fee account
796       */
797     function setFeeAccount(
798         address newFeeAccount
799     )
800         external
801         onlyOwner
802     {
803         feeAccount = newFeeAccount;
804     }
805 }
806 
807 
808 
809 
810 
811 /**
812  * @title SafeERC20
813  * @dev Wrappers around ERC20 operations that throw on failure (when the token
814  * contract returns false). Tokens that return no value (and instead revert or
815  * throw on failure) are also supported, non-reverting calls are assumed to be
816  * successful.
817  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
818  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
819  */
820 library SafeERC20 {
821     using SafeMath for uint256;
822     using Address for address;
823 
824     function safeTransfer(IERC20 token, address to, uint256 value) internal {
825         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
826     }
827 
828     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
829         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
830     }
831 
832     function safeApprove(IERC20 token, address spender, uint256 value) internal {
833         // safeApprove should only be called when setting an initial allowance,
834         // or when resetting it to zero. To increase and decrease it, use
835         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
836         // solhint-disable-next-line max-line-length
837         require((value == 0) || (token.allowance(address(this), spender) == 0),
838             "SafeERC20: approve from non-zero to non-zero allowance"
839         );
840         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
841     }
842 
843     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
844         uint256 newAllowance = token.allowance(address(this), spender).add(value);
845         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
846     }
847 
848     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
849         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
850         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
851     }
852 
853     /**
854      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
855      * on the return value: the return value is optional (but if data is returned, it must not be false).
856      * @param token The token targeted by the call.
857      * @param data The call data (encoded using abi.encode or one of its variants).
858      */
859     function callOptionalReturn(IERC20 token, bytes memory data) private {
860         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
861         // we're implementing it ourselves.
862 
863         // A Solidity high level call has three parts:
864         //  1. The target address is checked to verify it contains contract code
865         //  2. The call itself is made, and success asserted
866         //  3. The return value is decoded, which in turn checks the size of the returned data.
867         // solhint-disable-next-line max-line-length
868         require(address(token).isContract(), "SafeERC20: call to non-contract");
869 
870         // solhint-disable-next-line avoid-low-level-calls
871         (bool success, bytes memory returndata) = address(token).call(data);
872         require(success, "SafeERC20: low-level call failed");
873 
874         if (returndata.length > 0) { // Return data is optional
875             // solhint-disable-next-line max-line-length
876             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
877         }
878     }
879 }
880 
881 
882 
883 
884 
885 contract Exchange is LibMath, LibOrder, LibSignatureValidator, ExchangeStorage {
886 
887     using SafeMath for uint256;
888 
889     /**
890       * @dev emitted when a trade is executed
891       */
892     event Trade(
893         address indexed makerAddress,        // Address that created the order
894         address indexed takerAddress,        // Address that filled the order
895         bytes32 indexed orderHash,           // Hash of the order
896         address makerFilledAsset,            // Address of assets filled for maker
897         address takerFilledAsset,            // Address of assets filled for taker
898         uint256 makerFilledAmount,           // Amount of assets filled for maker
899         uint256 takerFilledAmount,           // Amount of assets filled for taker
900         uint256 takerFeePaid,                // Amount of fee paid by the taker
901         uint256 makerFeeReceived,            // Amount of fee received by the maker
902         uint256 referralFeeReceived          // Amount of fee received by the referrer
903     );
904 
905     /**
906       * @dev emitted when a cancel order is executed
907       */
908     event Cancel(
909         address indexed makerBuyToken,        // Address of asset being bought.
910         address makerSellToken,               // Address of asset being sold.
911         address indexed maker,                // Address that created the order
912         bytes32 indexed orderHash             // Hash of the order
913     );
914 
915     /**
916       * @dev Compute the status of an order.
917       * Should be called before a contract execution is performet in order to not waste gas.
918       * @return OrderStatus.FILLABLE if the order is valid for taking.
919       * Note: See LibOrder.sol to see all statuses
920       */
921     function getOrderInfo(
922         uint256 partialAmount,
923         Order memory order
924     )
925         public
926         view
927         returns (OrderInfo memory orderInfo)
928     {
929         // Compute the order hash
930         orderInfo.hash = getPrefixedHash(order);
931 
932         // Fetch filled amount
933         orderInfo.filledAmount = filled[orderInfo.hash];
934 
935         // Check taker balance
936         if(balances[order.makerBuyToken][order.taker] < order.takerSellAmount) {
937             orderInfo.status = uint8(OrderStatus.INVALID_TAKER_AMOUNT);
938             return orderInfo;
939         }
940 
941         // Check maker balance
942         if(balances[order.makerSellToken][order.maker] < partialAmount) {
943             orderInfo.status = uint8(OrderStatus.INVALID_MAKER_AMOUNT);
944             return orderInfo;
945         }
946 
947         // Check if order is filled
948         if (orderInfo.filledAmount.add(order.takerSellAmount) > order.makerBuyAmount) {
949             orderInfo.status = uint8(OrderStatus.FULLY_FILLED);
950             return orderInfo;
951         }
952 
953         // Check for expiration
954         if (block.number >= order.expiration) {
955             orderInfo.status = uint8(OrderStatus.EXPIRED);
956             return orderInfo;
957         }
958 
959         // Check if order has been cancelled
960         if (cancelled[orderInfo.hash]) {
961             orderInfo.status = uint8(OrderStatus.CANCELLED);
962             return orderInfo;
963         }
964 
965         orderInfo.status = uint8(OrderStatus.FILLABLE);
966         return orderInfo;
967     }
968 
969     /**
970       * @dev Execute a trade based on the input order and signature.
971       * Reverts if order is not valid
972       */
973     function trade(
974         Order memory order,
975         bytes memory signature
976     )
977         public
978     {
979         bool result = _trade(order, signature);
980         require(result, "INVALID_TRADE");
981     }
982 
983     /**
984       * @dev Execute a trade based on the input order and signature.
985       * If the order is valid returns true.
986       */
987     function _trade(
988         Order memory order,
989         bytes memory signature
990     )
991         internal
992         returns(bool)
993     {
994         order.taker = msg.sender;
995 
996         uint256 takerReceivedAmount = getPartialAmount(
997             order.makerSellAmount,
998             order.makerBuyAmount,
999             order.takerSellAmount
1000         );
1001 
1002         OrderInfo memory orderInfo = getOrderInfo(takerReceivedAmount, order);
1003 
1004         uint8 status = assertTakeOrder(orderInfo.hash, orderInfo.status, order.maker, signature);
1005 
1006         if(status != uint8(OrderStatus.FILLABLE)) {
1007             return false;
1008         }
1009 
1010         OrderFill memory orderFill = getOrderFillResult(takerReceivedAmount, order);
1011 
1012         executeTrade(order, orderFill);
1013 
1014         filled[orderInfo.hash] = filled[orderInfo.hash].add(order.takerSellAmount);
1015 
1016         emit Trade(
1017             order.maker,
1018             order.taker,
1019             orderInfo.hash,
1020             order.makerBuyToken,
1021             order.makerSellToken,
1022             orderFill.makerFillAmount,
1023             orderFill.takerFillAmount,
1024             orderFill.takerFeePaid,
1025             orderFill.makerFeeReceived,
1026             orderFill.referralFeeReceived
1027         );
1028 
1029         return true;
1030     }
1031 
1032     /**
1033       * @dev Cancel an order if msg.sender is the order signer.
1034       */
1035     function cancelSingleOrder(
1036         Order memory order,
1037         bytes memory signature
1038     )
1039         public
1040     {
1041         bytes32 orderHash = getPrefixedHash(order);
1042 
1043         require(
1044             recover(orderHash, signature) == msg.sender,
1045             "INVALID_SIGNER"
1046         );
1047 
1048         require(
1049             cancelled[orderHash] == false,
1050             "ALREADY_CANCELLED"
1051         );
1052 
1053         cancelled[orderHash] = true;
1054 
1055         emit Cancel(
1056             order.makerBuyToken,
1057             order.makerSellToken,
1058             msg.sender,
1059             orderHash
1060         );
1061     }
1062 
1063     /**
1064       * @dev Computation of the following properties based on the order input:
1065       * takerFillAmount -> amount of assets received by the taker
1066       * makerFillAmount -> amount of assets received by the maker
1067       * takerFeePaid -> amount of fee paid by the taker (0.2% of takerFillAmount)
1068       * makerFeeReceived -> amount of fee received by the maker (50% of takerFeePaid)
1069       * referralFeeReceived -> amount of fee received by the taker referrer (10% of takerFeePaid)
1070       * exchangeFeeReceived -> amount of fee received by the exchange (40% of takerFeePaid)
1071       */
1072     function getOrderFillResult(
1073         uint256 takerReceivedAmount,
1074         Order memory order
1075     )
1076         internal
1077         view
1078         returns (OrderFill memory orderFill)
1079     {
1080         orderFill.takerFillAmount = takerReceivedAmount;
1081 
1082         orderFill.makerFillAmount = order.takerSellAmount;
1083 
1084         // 0.2% == 0.2*10^16
1085         orderFill.takerFeePaid = getFeeAmount(
1086             takerReceivedAmount,
1087             takerFeeRate
1088         );
1089 
1090         // 50% of taker fee == 50*10^16
1091         orderFill.makerFeeReceived = getFeeAmount(
1092             orderFill.takerFeePaid,
1093             makerFeeRate
1094         );
1095 
1096         // 10% of taker fee == 10*10^16
1097         orderFill.referralFeeReceived = getFeeAmount(
1098             orderFill.takerFeePaid,
1099             referralFeeRate
1100         );
1101 
1102         // exchangeFee = (takerFeePaid - makerFeeReceived - referralFeeReceived)
1103         orderFill.exchangeFeeReceived = orderFill.takerFeePaid.sub(
1104             orderFill.makerFeeReceived).sub(
1105                 orderFill.referralFeeReceived);
1106 
1107     }
1108 
1109     /**
1110       * @dev Throws when the order status is invalid or the signer is not valid.
1111       */
1112     function assertTakeOrder(
1113         bytes32 orderHash,
1114         uint8 status,
1115         address signer,
1116         bytes memory signature
1117     )
1118         internal
1119         pure
1120         returns(uint8)
1121     {
1122         uint8 result = uint8(OrderStatus.FILLABLE);
1123 
1124         if(recover(orderHash, signature) != signer) {
1125             result = uint8(OrderStatus.INVALID_SIGNER);
1126         }
1127 
1128         if(status != uint8(OrderStatus.FILLABLE)) {
1129             result = status;
1130         }
1131 
1132         return status;
1133     }
1134 
1135     /**
1136       * @dev Updates the contract state i.e. user balances
1137       */
1138     function executeTrade(
1139         Order memory order,
1140         OrderFill memory orderFill
1141     )
1142         private
1143     {
1144         uint256 makerGiveAmount = orderFill.takerFillAmount.sub(orderFill.makerFeeReceived);
1145         uint256 takerFillAmount = orderFill.takerFillAmount.sub(orderFill.takerFeePaid);
1146 
1147         address referrer = referrals[order.taker];
1148         address feeAddress = feeAccount;
1149 
1150         balances[order.makerSellToken][referrer] = balances[order.makerSellToken][referrer].add(orderFill.referralFeeReceived);
1151         balances[order.makerSellToken][feeAddress] = balances[order.makerSellToken][feeAddress].add(orderFill.exchangeFeeReceived);
1152 
1153         balances[order.makerBuyToken][order.taker] = balances[order.makerBuyToken][order.taker].sub(orderFill.makerFillAmount);
1154         balances[order.makerBuyToken][order.maker] = balances[order.makerBuyToken][order.maker].add(orderFill.makerFillAmount);
1155 
1156         balances[order.makerSellToken][order.taker] = balances[order.makerSellToken][order.taker].add(takerFillAmount);
1157         balances[order.makerSellToken][order.maker] = balances[order.makerSellToken][order.maker].sub(makerGiveAmount);
1158     }
1159 }
1160 
1161 
1162 
1163 
1164 
1165 contract ExchangeKyberProxy is Exchange, LibKyberData {
1166     using SafeERC20 for IERC20;
1167 
1168     /**
1169       * @dev The precision used for calculating the amounts - 10*18
1170       */
1171     uint256 constant internal PRECISION = 1000000000000000000;
1172 
1173     /**
1174       * @dev Max decimals allowed when calculating amounts.
1175       */
1176     uint256 constant internal MAX_DECIMALS = 18;
1177 
1178     /**
1179       * @dev Decimals of Ether.
1180       */
1181     uint256 constant internal ETH_DECIMALS = 18;
1182 
1183     /**
1184       * @dev The address that represents ETH in Kyber Network Contracts.
1185       */
1186     address constant internal KYBER_ETH_TOKEN_ADDRESS =
1187         address(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
1188 
1189     /**
1190       * @dev KyberNetworkProxy contract address
1191       */
1192     IKyberNetworkProxy constant internal kyberNetworkContract =
1193         IKyberNetworkProxy(0x818E6FECD516Ecc3849DAf6845e3EC868087B755);
1194 
1195     /**
1196       * @dev Swaps ETH/TOKEN, TOKEN/ETH or TOKEN/TOKEN using KyberNetwork reserves.
1197       */
1198     function kyberSwap(
1199         uint256 givenAmount,
1200         address givenToken,
1201         address receivedToken,
1202         bytes32 hash
1203     )
1204         public
1205         payable
1206     {
1207         address taker = msg.sender;
1208 
1209         KyberData memory kyberData = getSwapInfo(
1210             givenAmount,
1211             givenToken,
1212             receivedToken,
1213             taker
1214         );
1215 
1216         uint256 convertedAmount = kyberNetworkContract.trade.value(kyberData.value)(
1217             kyberData.givenToken,
1218             givenAmount,
1219             kyberData.receivedToken,
1220             taker,
1221             kyberData.expectedReceiveAmount,
1222             kyberData.rate,
1223             feeAccount
1224         );
1225 
1226         emit Trade(
1227             address(kyberNetworkContract),
1228             taker,
1229             hash,
1230             givenToken,
1231             receivedToken,
1232             givenAmount,
1233             convertedAmount,
1234             0,
1235             0,
1236             0
1237         );
1238     }
1239 
1240     /**
1241       * @dev Exchange ETH/TOKEN, TOKEN/ETH or TOKEN/TOKEN using the internal
1242       * balance mapping that keeps track of user's balances. It requires user to first invoke deposit function.
1243       * The function relies on KyberNetworkProxy contract.
1244       */
1245     function kyberTrade(
1246         uint256 givenAmount,
1247         address givenToken,
1248         address receivedToken,
1249         bytes32 hash
1250     )
1251         public
1252     {
1253         address taker = msg.sender;
1254 
1255         KyberData memory kyberData = getTradeInfo(
1256             givenAmount,
1257             givenToken,
1258             receivedToken
1259         );
1260 
1261         balances[givenToken][taker] = balances[givenToken][taker].sub(givenAmount);
1262 
1263         uint256 convertedAmount = kyberNetworkContract.trade.value(kyberData.value)(
1264             kyberData.givenToken,
1265             givenAmount,
1266             kyberData.receivedToken,
1267             address(this),
1268             kyberData.expectedReceiveAmount,
1269             kyberData.rate,
1270             feeAccount
1271         );
1272 
1273         balances[receivedToken][taker] = balances[receivedToken][taker].add(convertedAmount);
1274 
1275         emit Trade(
1276             address(kyberNetworkContract),
1277             taker,
1278             hash,
1279             givenToken,
1280             receivedToken,
1281             givenAmount,
1282             convertedAmount,
1283             0,
1284             0,
1285             0
1286         );
1287     }
1288 
1289     /**
1290       * @dev Helper function to determine what is being swapped.
1291       */
1292     function getSwapInfo(
1293         uint256 givenAmount,
1294         address givenToken,
1295         address receivedToken,
1296         address taker
1297     )
1298         private
1299         returns(KyberData memory)
1300     {
1301         KyberData memory kyberData;
1302         uint256 givenTokenDecimals;
1303         uint256 receivedTokenDecimals;
1304 
1305         if(givenToken == address(0x0)) {
1306             require(msg.value == givenAmount, "INVALID_ETH_VALUE");
1307 
1308             kyberData.givenToken = KYBER_ETH_TOKEN_ADDRESS;
1309             kyberData.receivedToken = receivedToken;
1310             kyberData.value = givenAmount;
1311 
1312             givenTokenDecimals = ETH_DECIMALS;
1313             receivedTokenDecimals = IERC20(receivedToken).decimals();
1314         } else if(receivedToken == address(0x0)) {
1315             kyberData.givenToken = givenToken;
1316             kyberData.receivedToken = KYBER_ETH_TOKEN_ADDRESS;
1317             kyberData.value = 0;
1318 
1319             givenTokenDecimals = IERC20(givenToken).decimals();
1320             receivedTokenDecimals = ETH_DECIMALS;
1321 
1322             IERC20(givenToken).safeTransferFrom(taker, address(this), givenAmount);
1323             IERC20(givenToken).safeApprove(address(kyberNetworkContract), givenAmount);
1324         } else {
1325             kyberData.givenToken = givenToken;
1326             kyberData.receivedToken = receivedToken;
1327             kyberData.value = 0;
1328 
1329             givenTokenDecimals = IERC20(givenToken).decimals();
1330             receivedTokenDecimals = IERC20(receivedToken).decimals();
1331 
1332             IERC20(givenToken).safeTransferFrom(taker, address(this), givenAmount);
1333             IERC20(givenToken).safeApprove(address(kyberNetworkContract), givenAmount);
1334         }
1335 
1336         (kyberData.rate, ) = kyberNetworkContract.getExpectedRate(
1337             kyberData.givenToken,
1338             kyberData.receivedToken,
1339             givenAmount
1340         );
1341 
1342         kyberData.expectedReceiveAmount = calculateExpectedAmount(
1343             givenAmount,
1344             givenTokenDecimals,
1345             receivedTokenDecimals,
1346             kyberData.rate
1347         );
1348 
1349         return kyberData;
1350     }
1351 
1352     /**
1353       * @dev Helper function to determines what is being
1354         swapped using the internal balance mapping.
1355       */
1356     function getTradeInfo(
1357         uint256 givenAmount,
1358         address givenToken,
1359         address receivedToken
1360     )
1361         private
1362         returns(KyberData memory)
1363     {
1364         KyberData memory kyberData;
1365         uint256 givenTokenDecimals;
1366         uint256 receivedTokenDecimals;
1367 
1368         if(givenToken == address(0x0)) {
1369             kyberData.givenToken = KYBER_ETH_TOKEN_ADDRESS;
1370             kyberData.receivedToken = receivedToken;
1371             kyberData.value = givenAmount;
1372 
1373             givenTokenDecimals = ETH_DECIMALS;
1374             receivedTokenDecimals = IERC20(receivedToken).decimals();
1375         } else if(receivedToken == address(0x0)) {
1376             kyberData.givenToken = givenToken;
1377             kyberData.receivedToken = KYBER_ETH_TOKEN_ADDRESS;
1378             kyberData.value = 0;
1379 
1380             givenTokenDecimals = IERC20(givenToken).decimals();
1381             receivedTokenDecimals = ETH_DECIMALS;
1382             IERC20(givenToken).safeApprove(address(kyberNetworkContract), givenAmount);
1383         } else {
1384             kyberData.givenToken = givenToken;
1385             kyberData.receivedToken = receivedToken;
1386             kyberData.value = 0;
1387 
1388             givenTokenDecimals = IERC20(givenToken).decimals();
1389             receivedTokenDecimals = IERC20(receivedToken).decimals();
1390             IERC20(givenToken).safeApprove(address(kyberNetworkContract), givenAmount);
1391         }
1392 
1393         (kyberData.rate, ) = kyberNetworkContract.getExpectedRate(
1394             kyberData.givenToken,
1395             kyberData.receivedToken,
1396             givenAmount
1397         );
1398 
1399         kyberData.expectedReceiveAmount = calculateExpectedAmount(
1400             givenAmount,
1401             givenTokenDecimals,
1402             receivedTokenDecimals,
1403             kyberData.rate
1404         );
1405 
1406         return kyberData;
1407     }
1408 
1409     function getExpectedRateBatch(
1410         address[] memory givenTokens,
1411         address[] memory receivedTokens,
1412         uint256[] memory givenAmounts
1413     )
1414         public
1415         view
1416         returns(uint256[] memory, uint256[] memory)
1417     {
1418         uint256 size = givenTokens.length;
1419         uint256[] memory expectedRates = new uint256[](size);
1420         uint256[] memory slippageRates = new uint256[](size);
1421 
1422         for(uint256 index = 0; index < size; index++) {
1423             (expectedRates[index], slippageRates[index]) = kyberNetworkContract.getExpectedRate(
1424                 givenTokens[index],
1425                 receivedTokens[index],
1426                 givenAmounts[index]
1427             );
1428         }
1429 
1430        return (expectedRates, slippageRates);
1431     }
1432 
1433     /**
1434       * @dev Helper function to get the expected amount based on
1435       * the given token and the rate from the KyberNetworkProxy
1436       */
1437     function calculateExpectedAmount(
1438         uint256 givenAmount,
1439         uint256 givenDecimals,
1440         uint256 receivedDecimals,
1441         uint256 rate
1442     )
1443         internal
1444         pure
1445         returns(uint)
1446     {
1447         if (receivedDecimals >= givenDecimals) {
1448             require(
1449                 (receivedDecimals - givenDecimals) <= MAX_DECIMALS,
1450                 "MAX_DECIMALS_EXCEEDED"
1451             );
1452 
1453             return (givenAmount * rate * (10 ** (receivedDecimals - givenDecimals)) ) / PRECISION;
1454         } else {
1455             require(
1456                 (givenDecimals - receivedDecimals) <= MAX_DECIMALS,
1457                 "MAX_DECIMALS_EXCEEDED"
1458             );
1459 
1460             return (givenAmount * rate) / (PRECISION * (10**(givenDecimals - receivedDecimals)));
1461         }
1462     }
1463 }
1464 
1465 
1466 
1467 
1468 
1469 contract ExchangeBatchTrade is Exchange {
1470 
1471     /**
1472       * @dev Cancel an array of orders if msg.sender is the order signer.
1473       */
1474     function cancelMultipleOrders(
1475         Order[] memory orders,
1476         bytes[] memory signatures
1477     )
1478         public
1479     {
1480         for (uint256 index = 0; index < orders.length; index++) {
1481             cancelSingleOrder(
1482                 orders[index],
1483                 signatures[index]
1484             );
1485         }
1486     }
1487 
1488     /**
1489       * @dev Execute multiple trades based on the input orders and signatures.
1490       * Note: reverts of one or more trades fail.
1491       */
1492     function takeAllOrRevert(
1493         Order[] memory orders,
1494         bytes[] memory signatures
1495     )
1496         public
1497     {
1498         for (uint256 index = 0; index < orders.length; index++) {
1499             bool result = _trade(orders[index], signatures[index]);
1500             require(result, "INVALID_TAKEALL");
1501         }
1502     }
1503 
1504     /**
1505       * @dev Execute multiple trades based on the input orders and signatures.
1506       * Note: does not revert if one or more trades fail.
1507       */
1508     function takeAllPossible(
1509         Order[] memory orders,
1510         bytes[] memory signatures
1511     )
1512         public
1513     {
1514         for (uint256 index = 0; index < orders.length; index++) {
1515             _trade(orders[index], signatures[index]);
1516         }
1517     }
1518 }
1519 
1520 
1521 
1522 
1523 
1524 contract ExchangeMovements is ExchangeStorage {
1525 
1526     using SafeERC20 for IERC20;
1527     using SafeMath for uint256;
1528 
1529     /**
1530       * @dev emitted when a deposit is received
1531       */
1532     event Deposit(
1533         address indexed token,
1534         address indexed user,
1535         address indexed referral,
1536         address beneficiary,
1537         uint256 amount,
1538         uint256 balance
1539     );
1540 
1541     /**
1542       * @dev emitted when a withdraw is received
1543       */
1544     event Withdraw(
1545         address indexed token,
1546         address indexed user,
1547         uint256 amount,
1548         uint256 balance
1549     );
1550 
1551     /**
1552       * @dev emitted when a transfer is received
1553       */
1554     event Transfer(
1555         address indexed token,
1556         address indexed user,
1557         address indexed beneficiary,
1558         uint256 amount,
1559         uint256 userBalance,
1560         uint256 beneficiaryBalance
1561     );
1562 
1563     /**
1564       * @dev Updates the level 2 map `balances` based on the input
1565       *      Note: token address is (0x0) when the deposit is for ETH
1566       */
1567     function deposit(
1568         address token,
1569         uint256 amount,
1570         address beneficiary,
1571         address referral
1572     )
1573         public
1574         payable
1575     {
1576         uint256 value = amount;
1577         address user = msg.sender;
1578 
1579         if(token == address(0x0)) {
1580             value = msg.value;
1581         } else {
1582             IERC20(token).safeTransferFrom(user, address(this), value);
1583         }
1584 
1585         balances[token][beneficiary] = balances[token][beneficiary].add(value);
1586 
1587         if(referrals[user] == address(0x0)) {
1588             referrals[user] = referral;
1589         }
1590 
1591         emit Deposit(
1592             token,
1593             user,
1594             referrals[user],
1595             beneficiary,
1596             value,
1597             balances[token][beneficiary]
1598         );
1599     }
1600 
1601     /**
1602       * @dev Updates the level 2 map `balances` based on the input
1603       *      Note: token address is (0x0) when the deposit is for ETH
1604       */
1605     function withdraw(
1606         address token,
1607         uint amount
1608     )
1609         public
1610     {
1611         address payable user = msg.sender;
1612 
1613         require(
1614             balances[token][user] >= amount,
1615             "INVALID_WITHDRAW"
1616         );
1617 
1618         balances[token][user] = balances[token][user].sub(amount);
1619 
1620         if (token == address(0x0)) {
1621             user.transfer(amount);
1622         } else {
1623             IERC20(token).safeTransfer(user, amount);
1624         }
1625 
1626         emit Withdraw(
1627             token,
1628             user,
1629             amount,
1630             balances[token][user]
1631         );
1632     }
1633 
1634     /**
1635       * @dev Transfer assets between two users inside the exchange. Updates the level 2 map `balances`
1636       */
1637     function transfer(
1638         address token,
1639         address to,
1640         uint256 amount
1641     )
1642         external
1643         payable
1644     {
1645         address user = msg.sender;
1646 
1647         require(
1648             balances[token][user] >= amount,
1649             "INVALID_TRANSFER"
1650         );
1651 
1652         balances[token][user] = balances[token][user].sub(amount);
1653 
1654         balances[token][to] = balances[token][to].add(amount);
1655 
1656         emit Transfer(
1657             token,
1658             user,
1659             to,
1660             amount,
1661             balances[token][user],
1662             balances[token][to]
1663         );
1664     }
1665 }
1666 
1667 
1668 
1669 
1670 
1671 contract ExchangeUpgradability is Ownable, ExchangeStorage {
1672 
1673     using SafeERC20 for IERC20;
1674     using SafeMath for uint256;
1675 
1676     /**
1677       * @dev version of the exchange
1678       */
1679     uint8 constant public VERSION = 1;
1680 
1681     /**
1682       * @dev the address of the upgraded exchange contract
1683       */
1684     address public newExchange;
1685 
1686     /**
1687       * @dev flag to allow migrating to an upgraded contract
1688       */
1689     bool public migrationAllowed;
1690 
1691     /**
1692       * @dev emitted when funds are migrated
1693       */
1694     event FundsMigrated(address indexed user, address indexed newExchange);
1695 
1696     /**
1697     * @dev Owner can set the address of the new version of the exchange contract.
1698     */
1699     function setNewExchangeAddress(address exchange)
1700         external
1701         onlyOwner
1702     {
1703         newExchange = exchange;
1704     }
1705 
1706     /**
1707     * @dev Enables/Disables the migrations. Can be called only by the owner.
1708     */
1709     function allowOrRestrictMigrations()
1710         external
1711         onlyOwner
1712     {
1713         migrationAllowed = !migrationAllowed;
1714     }
1715 
1716     /**
1717     * @dev Migrating assets of the caller to the new exchange contract
1718     */
1719     function migrateFunds(address[] calldata tokens) external {
1720 
1721         require(
1722             false != migrationAllowed,
1723             "MIGRATIONS_DISALLOWED"
1724         );
1725 
1726         require(
1727             IExchangeUpgradability(newExchange).VERSION() > VERSION,
1728             "INVALID_VERSION"
1729         );
1730 
1731         migrateEthers();
1732 
1733         migrateTokens(tokens);
1734 
1735         emit FundsMigrated(msg.sender, newExchange);
1736     }
1737 
1738     /**
1739     * @dev Helper function to migrate user's Ethers. Should be called in migrateFunds() function.
1740     */
1741     function migrateEthers() private {
1742         address user = msg.sender;
1743         uint256 etherAmount = balances[address(0x0)][user];
1744         if (etherAmount > 0) {
1745             balances[address(0x0)][user] = 0;
1746             IExchangeUpgradability(newExchange).importEthers.value(etherAmount)(user);
1747         }
1748     }
1749 
1750     /**
1751     * @dev Helper function to migrate user's tokens. Should be called in migrateFunds() function.
1752     */
1753     function migrateTokens(address[] memory tokens) private {
1754         address user = msg.sender;
1755         address exchange = newExchange;
1756         for (uint256 index = 0; index < tokens.length; index++) {
1757 
1758             address tokenAddress = tokens[index];
1759 
1760             uint256 tokenAmount = balances[tokenAddress][user];
1761 
1762             if (0 == tokenAmount) {
1763                 continue;
1764             }
1765 
1766             IERC20(tokenAddress).safeApprove(exchange, tokenAmount);
1767 
1768             balances[tokenAddress][user] = 0;
1769 
1770             IExchangeUpgradability(exchange).importTokens(tokenAddress, tokenAmount, user);
1771         }
1772     }
1773 
1774     /**
1775     * @dev Helper function to migrate user's Ethers. Should be called only from the new exchange contract.
1776     */
1777     function importEthers(address user)
1778         external
1779         payable
1780     {
1781         require(
1782             false != migrationAllowed,
1783             "MIGRATION_DISALLOWED"
1784         );
1785 
1786         require(
1787             user != address(0x0),
1788             "INVALID_USER"
1789         );
1790 
1791         require(
1792             msg.value > 0,
1793             "INVALID_AMOUNT"
1794         );
1795 
1796         require(
1797             IExchangeUpgradability(msg.sender).VERSION() < VERSION,
1798             "INVALID_VERSION"
1799         );
1800 
1801         balances[address(0x0)][user] = balances[address(0x0)][user].add(msg.value); // todo: constants
1802     }
1803     
1804     /**
1805     * @dev Helper function to migrate user's Tokens. Should be called only from the new exchange contract.
1806     */
1807     function importTokens(
1808         address token,
1809         uint256 amount,
1810         address user
1811     )
1812         external
1813     {
1814         require(
1815             false != migrationAllowed,
1816             "MIGRATION_DISALLOWED"
1817         );
1818 
1819         require(
1820             token != address(0x0),
1821             "INVALID_TOKEN"
1822         );
1823 
1824         require(
1825             user != address(0x0),
1826             "INVALID_USER"
1827         );
1828 
1829         require(
1830             amount > 0,
1831             "INVALID_AMOUNT"
1832         );
1833 
1834         require(
1835             IExchangeUpgradability(msg.sender).VERSION() < VERSION,
1836             "INVALID_VERSION"
1837         );
1838 
1839         IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
1840 
1841         balances[token][user] = balances[token][user].add(amount);
1842     }
1843 }
1844 
1845 
1846 
1847 
1848 
1849 contract ExchangeOffering is ExchangeStorage, LibCrowdsale {
1850 
1851     address constant internal BURN_ADDRESS = address(0x000000000000000000000000000000000000dEaD);
1852     address constant internal ETH_ADDRESS = address(0x0);
1853 
1854     using SafeERC20 for IERC20;
1855 
1856     using SafeMath for uint256;
1857 
1858     mapping(address => Crowdsale) public crowdsales;
1859 
1860     mapping(address => mapping(address => uint256)) public contributions;
1861 
1862     event TokenPurchase(
1863         address indexed token,
1864         address indexed user,
1865         uint256 tokenAmount,
1866         uint256 weiAmount
1867     );
1868 
1869     event TokenBurned(
1870         address indexed token,
1871         uint256 tokenAmount
1872     );
1873 
1874     function registerCrowdsale(
1875         Crowdsale memory crowdsale,
1876         address token
1877     )
1878         public
1879         onlyOwner
1880     {
1881         require(
1882             CrowdsaleStatus.VALID == getCrowdsaleStatus(crowdsale),
1883             "INVALID_CROWDSALE"
1884         );
1885 
1886         require(
1887             crowdsales[token].wallet == address(0),
1888             "CROWDSALE_ALREADY_EXISTS"
1889         );
1890 
1891         uint256 tokenForSale = crowdsale.hardCap.mul(crowdsale.tokenRatio);
1892 
1893         IERC20(token).safeTransferFrom(crowdsale.wallet, address(this), tokenForSale);
1894 
1895         crowdsales[token] = crowdsale;
1896     }
1897 
1898     function buyTokens(address token)
1899        public
1900        payable
1901     {
1902         require(msg.value != 0, "INVALID_MSG_VALUE");
1903 
1904         uint256 weiAmount = msg.value;
1905 
1906         address user = msg.sender;
1907 
1908         Crowdsale memory crowdsale = crowdsales[token];
1909 
1910         require(
1911             ContributionStatus.VALID == validContribution(weiAmount, crowdsale, user, token),
1912             "INVALID_CONTRIBUTION"
1913         );
1914 
1915         uint256 purchasedTokens = weiAmount.mul(crowdsale.tokenRatio);
1916 
1917         crowdsale.leftAmount = crowdsale.leftAmount.sub(purchasedTokens);
1918 
1919         crowdsale.weiRaised = crowdsale.weiRaised.add(weiAmount);
1920 
1921         balances[ETH_ADDRESS][crowdsale.wallet] = balances[ETH_ADDRESS][crowdsale.wallet].add(weiAmount);
1922 
1923         balances[token][user] = balances[token][user].add(purchasedTokens);
1924 
1925         contributions[token][user] = contributions[token][user].add(weiAmount);
1926 
1927         crowdsales[token] = crowdsale;
1928 
1929         emit TokenPurchase(token, user, purchasedTokens, weiAmount);
1930     }
1931 
1932     function burnTokensWhenFinished(address token) public
1933     {
1934         require(
1935             isFinished(crowdsales[token].endBlock),
1936             "CROWDSALE_NOT_FINISHED_YET"
1937         );
1938 
1939         uint256 leftAmount = crowdsales[token].leftAmount;
1940 
1941         crowdsales[token].leftAmount = 0;
1942 
1943         IERC20(token).safeTransfer(BURN_ADDRESS, leftAmount);
1944 
1945         emit TokenBurned(token, leftAmount);
1946     }
1947 
1948     function validContribution(
1949         uint256 weiAmount,
1950         Crowdsale memory crowdsale,
1951         address user,
1952         address token
1953     )
1954         public
1955         view
1956         returns(ContributionStatus)
1957     {
1958         if (!isOpened(crowdsale.startBlock, crowdsale.endBlock)) {
1959             return ContributionStatus.CROWDSALE_NOT_OPEN;
1960         }
1961 
1962         if(weiAmount < crowdsale.minContribution) {
1963             return ContributionStatus.MIN_CONTRIBUTION;
1964         }
1965 
1966         if (contributions[token][user].add(weiAmount) > crowdsale.maxContribution) {
1967             return ContributionStatus.MAX_CONTRIBUTION;
1968         }
1969 
1970         if (crowdsale.hardCap < crowdsale.weiRaised.add(weiAmount)) {
1971             return ContributionStatus.HARDCAP_REACHED;
1972         }
1973 
1974         return ContributionStatus.VALID;
1975     }
1976 }
1977 
1978 
1979 
1980 
1981 
1982 contract ExchangeSwap is Exchange, ExchangeMovements  {
1983 
1984     /**
1985       * @dev Swaps ETH/TOKEN, TOKEN/ETH or TOKEN/TOKEN using off-chain signed messages.
1986       * The flow of the function is Deposit -> Trade -> Withdraw to allow users to directly
1987       * take liquidity without the need of deposit and withdraw.
1988       */
1989     function swapFill(
1990         Order[] memory orders,
1991         bytes[] memory signatures,
1992         uint256 givenAmount,
1993         address givenToken,
1994         address receivedToken,
1995         address referral
1996     )
1997         public
1998         payable
1999     {
2000         address taker = msg.sender;
2001 
2002         uint256 balanceGivenBefore = balances[givenToken][taker];
2003         uint256 balanceReceivedBefore = balances[receivedToken][taker];
2004 
2005         deposit(givenToken, givenAmount, taker, referral);
2006 
2007         for (uint256 index = 0; index < orders.length; index++) {
2008             require(orders[index].makerBuyToken == givenToken, "GIVEN_TOKEN");
2009             require(orders[index].makerSellToken == receivedToken, "RECEIVED_TOKEN");
2010 
2011             _trade(orders[index], signatures[index]);
2012         }
2013 
2014         uint256 balanceGivenAfter = balances[givenToken][taker];
2015         uint256 balanceReceivedAfter = balances[receivedToken][taker];
2016 
2017         uint256 balanceGivenDelta = balanceGivenAfter.sub(balanceGivenBefore);
2018         uint256 balanceReceivedDelta = balanceReceivedAfter.sub(balanceReceivedBefore);
2019 
2020         if(balanceGivenDelta > 0) {
2021             withdraw(givenToken, balanceGivenDelta);
2022         }
2023 
2024         if(balanceReceivedDelta > 0) {
2025             withdraw(receivedToken, balanceReceivedDelta);
2026         }
2027     }
2028 }
2029 
2030 
2031 
2032 
2033 
2034 contract WeiDex is
2035     Exchange,
2036     ExchangeKyberProxy,
2037     ExchangeBatchTrade,
2038     ExchangeMovements,
2039     ExchangeUpgradability,
2040     ExchangeOffering,
2041     ExchangeSwap
2042 {
2043     function () external payable { }
2044 }