1 // File: original_contracts/IWhitelisted.sol
2 
3 pragma solidity 0.7.5;
4 
5 
6 interface IWhitelisted {
7 
8     function hasRole(
9         bytes32 role,
10         address account
11     )
12         external
13         view
14         returns (bool);
15 
16     function WHITELISTED_ROLE() external view returns(bytes32);
17 }
18 
19 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
20 
21 
22 
23 pragma solidity >=0.6.0 <0.8.0;
24 
25 /**
26  * @dev Interface of the ERC20 standard as defined in the EIP.
27  */
28 interface IERC20 {
29     /**
30      * @dev Returns the amount of tokens in existence.
31      */
32     function totalSupply() external view returns (uint256);
33 
34     /**
35      * @dev Returns the amount of tokens owned by `account`.
36      */
37     function balanceOf(address account) external view returns (uint256);
38 
39     /**
40      * @dev Moves `amount` tokens from the caller's account to `recipient`.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * Emits a {Transfer} event.
45      */
46     function transfer(address recipient, uint256 amount) external returns (bool);
47 
48     /**
49      * @dev Returns the remaining number of tokens that `spender` will be
50      * allowed to spend on behalf of `owner` through {transferFrom}. This is
51      * zero by default.
52      *
53      * This value changes when {approve} or {transferFrom} are called.
54      */
55     function allowance(address owner, address spender) external view returns (uint256);
56 
57     /**
58      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * IMPORTANT: Beware that changing an allowance with this method brings the risk
63      * that someone may use both the old and the new allowance by unfortunate
64      * transaction ordering. One possible solution to mitigate this race
65      * condition is to first reduce the spender's allowance to 0 and set the
66      * desired value afterwards:
67      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
68      *
69      * Emits an {Approval} event.
70      */
71     function approve(address spender, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Moves `amount` tokens from `sender` to `recipient` using the
75      * allowance mechanism. `amount` is then deducted from the caller's
76      * allowance.
77      *
78      * Returns a boolean value indicating whether the operation succeeded.
79      *
80      * Emits a {Transfer} event.
81      */
82     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Emitted when `value` tokens are moved from one account (`from`) to
86      * another (`to`).
87      *
88      * Note that `value` may be zero.
89      */
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 
92     /**
93      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
94      * a call to {approve}. `value` is the new allowance.
95      */
96     event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 // File: original_contracts/lib/IExchange.sol
100 
101 pragma solidity 0.7.5;
102 
103 
104 
105 /**
106 * @dev This interface should be implemented by all exchanges which needs to integrate with the paraswap protocol
107 */
108 interface IExchange {
109 
110     /**
111    * @dev The function which performs the swap on an exchange.
112    * Exchange needs to implement this method in order to support swapping of tokens through it
113    * @param fromToken Address of the source token
114    * @param toToken Address of the destination token
115    * @param fromAmount Amount of source tokens to be swapped
116    * @param toAmount Minimum destination token amount expected out of this swap
117    * @param exchange Internal exchange or factory contract address for the exchange. For example Registry address for the Uniswap
118    * @param payload Any exchange specific data which is required can be passed in this argument in encoded format which
119    * will be decoded by the exchange. Each exchange will publish it's own decoding/encoding mechanism
120    */
121    //TODO: REMOVE RETURN STATEMENT
122     function swap(
123         IERC20 fromToken,
124         IERC20 toToken,
125         uint256 fromAmount,
126         uint256 toAmount,
127         address exchange,
128         bytes calldata payload) external payable;
129 
130   /**
131    * @dev The function which performs the swap on an exchange.
132    * Exchange needs to implement this method in order to support swapping of tokens through it
133    * @param fromToken Address of the source token
134    * @param toToken Address of the destination token
135    * @param fromAmount Max Amount of source tokens to be swapped
136    * @param toAmount Destination token amount expected out of this swap
137    * @param exchange Internal exchange or factory contract address for the exchange. For example Registry address for the Uniswap
138    * @param payload Any exchange specific data which is required can be passed in this argument in encoded format which
139    * will be decoded by the exchange. Each exchange will publish it's own decoding/encoding mechanism
140    */
141     function buy(
142         IERC20 fromToken,
143         IERC20 toToken,
144         uint256 fromAmount,
145         uint256 toAmount,
146         address exchange,
147         bytes calldata payload) external payable;
148 
149     /**
150    * @dev This function is used to perform onChainSwap. It build all the parameters onchain. Basically the information
151    * encoded in payload param of swap will calculated in this case
152    * Exchange needs to implement this method in order to support swapping of tokens through it
153    * @param fromToken Address of the source token
154    * @param toToken Address of the destination token
155    * @param fromAmount Amount of source tokens to be swapped
156    * @param toAmount Minimum destination token amount expected out of this swap
157    */
158     function onChainSwap(
159         IERC20 fromToken,
160         IERC20 toToken,
161         uint256 fromAmount,
162         uint256 toAmount
163     ) external payable returns (uint256);
164 
165     /**
166     * @dev Certain adapters/exchanges needs to be initialized.
167     * This method will be called from Augustus
168     */
169     function initialize(bytes calldata data) external;
170 
171     /**
172     * @dev Returns unique identifier for the adapter
173     */
174     function getKey() external pure returns(bytes32);
175 }
176 
177 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
178 
179 
180 
181 pragma solidity >=0.6.0 <0.8.0;
182 
183 /**
184  * @dev Wrappers over Solidity's arithmetic operations with added overflow
185  * checks.
186  *
187  * Arithmetic operations in Solidity wrap on overflow. This can easily result
188  * in bugs, because programmers usually assume that an overflow raises an
189  * error, which is the standard behavior in high level programming languages.
190  * `SafeMath` restores this intuition by reverting the transaction when an
191  * operation overflows.
192  *
193  * Using this library instead of the unchecked operations eliminates an entire
194  * class of bugs, so it's recommended to use it always.
195  */
196 library SafeMath {
197     /**
198      * @dev Returns the addition of two unsigned integers, reverting on
199      * overflow.
200      *
201      * Counterpart to Solidity's `+` operator.
202      *
203      * Requirements:
204      *
205      * - Addition cannot overflow.
206      */
207     function add(uint256 a, uint256 b) internal pure returns (uint256) {
208         uint256 c = a + b;
209         require(c >= a, "SafeMath: addition overflow");
210 
211         return c;
212     }
213 
214     /**
215      * @dev Returns the subtraction of two unsigned integers, reverting on
216      * overflow (when the result is negative).
217      *
218      * Counterpart to Solidity's `-` operator.
219      *
220      * Requirements:
221      *
222      * - Subtraction cannot overflow.
223      */
224     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
225         return sub(a, b, "SafeMath: subtraction overflow");
226     }
227 
228     /**
229      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
230      * overflow (when the result is negative).
231      *
232      * Counterpart to Solidity's `-` operator.
233      *
234      * Requirements:
235      *
236      * - Subtraction cannot overflow.
237      */
238     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
239         require(b <= a, errorMessage);
240         uint256 c = a - b;
241 
242         return c;
243     }
244 
245     /**
246      * @dev Returns the multiplication of two unsigned integers, reverting on
247      * overflow.
248      *
249      * Counterpart to Solidity's `*` operator.
250      *
251      * Requirements:
252      *
253      * - Multiplication cannot overflow.
254      */
255     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
256         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
257         // benefit is lost if 'b' is also tested.
258         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
259         if (a == 0) {
260             return 0;
261         }
262 
263         uint256 c = a * b;
264         require(c / a == b, "SafeMath: multiplication overflow");
265 
266         return c;
267     }
268 
269     /**
270      * @dev Returns the integer division of two unsigned integers. Reverts on
271      * division by zero. The result is rounded towards zero.
272      *
273      * Counterpart to Solidity's `/` operator. Note: this function uses a
274      * `revert` opcode (which leaves remaining gas untouched) while Solidity
275      * uses an invalid opcode to revert (consuming all remaining gas).
276      *
277      * Requirements:
278      *
279      * - The divisor cannot be zero.
280      */
281     function div(uint256 a, uint256 b) internal pure returns (uint256) {
282         return div(a, b, "SafeMath: division by zero");
283     }
284 
285     /**
286      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
287      * division by zero. The result is rounded towards zero.
288      *
289      * Counterpart to Solidity's `/` operator. Note: this function uses a
290      * `revert` opcode (which leaves remaining gas untouched) while Solidity
291      * uses an invalid opcode to revert (consuming all remaining gas).
292      *
293      * Requirements:
294      *
295      * - The divisor cannot be zero.
296      */
297     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
298         require(b > 0, errorMessage);
299         uint256 c = a / b;
300         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
301 
302         return c;
303     }
304 
305     /**
306      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
307      * Reverts when dividing by zero.
308      *
309      * Counterpart to Solidity's `%` operator. This function uses a `revert`
310      * opcode (which leaves remaining gas untouched) while Solidity uses an
311      * invalid opcode to revert (consuming all remaining gas).
312      *
313      * Requirements:
314      *
315      * - The divisor cannot be zero.
316      */
317     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
318         return mod(a, b, "SafeMath: modulo by zero");
319     }
320 
321     /**
322      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
323      * Reverts with custom message when dividing by zero.
324      *
325      * Counterpart to Solidity's `%` operator. This function uses a `revert`
326      * opcode (which leaves remaining gas untouched) while Solidity uses an
327      * invalid opcode to revert (consuming all remaining gas).
328      *
329      * Requirements:
330      *
331      * - The divisor cannot be zero.
332      */
333     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
334         require(b != 0, errorMessage);
335         return a % b;
336     }
337 }
338 
339 // File: original_contracts/lib/SafeERC20.sol
340 
341 pragma solidity 0.7.5;
342 
343 
344 
345 
346 library Address {
347 
348     function isContract(address account) internal view returns (bool) {
349         // This method relies on extcodesize, which returns 0 for contracts in
350         // construction, since the code is only stored at the end of the
351         // constructor execution.
352 
353         uint256 size;
354         // solhint-disable-next-line no-inline-assembly
355         assembly { size := extcodesize(account) }
356         return size > 0;
357     }
358 
359     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
360         return functionCallWithValue(target, data, 0, errorMessage);
361     }
362 
363     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
364         require(address(this).balance >= value, "Address: insufficient balance for call");
365         require(isContract(target), "Address: call to non-contract");
366 
367         // solhint-disable-next-line avoid-low-level-calls
368         (bool success, bytes memory returndata) = target.call{ value: value }(data);
369         return _verifyCallResult(success, returndata, errorMessage);
370     }
371 
372     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
373         if (success) {
374             return returndata;
375         } else {
376             // Look for revert reason and bubble it up if present
377             if (returndata.length > 0) {
378                 // The easiest way to bubble the revert reason is using memory via assembly
379 
380                 // solhint-disable-next-line no-inline-assembly
381                 assembly {
382                     let returndata_size := mload(returndata)
383                     revert(add(32, returndata), returndata_size)
384                 }
385             } else {
386                 revert(errorMessage);
387             }
388         }
389     }
390 }
391 
392 
393 library SafeERC20 {
394     using SafeMath for uint256;
395     using Address for address;
396 
397     function safeTransfer(IERC20 token, address to, uint256 value) internal {
398         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
399     }
400 
401     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
402         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
403     }
404 
405     /**
406      * @dev Deprecated. This function has issues similar to the ones found in
407      * {IERC20-approve}, and its usage is discouraged.
408      *
409      * Whenever possible, use {safeIncreaseAllowance} and
410      * {safeDecreaseAllowance} instead.
411      */
412     function safeApprove(IERC20 token, address spender, uint256 value) internal {
413         // safeApprove should only be called when setting an initial allowance,
414         // or when resetting it to zero. To increase and decrease it, use
415         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
416         // solhint-disable-next-line max-line-length
417         require((value == 0) || (token.allowance(address(this), spender) == 0),
418             "SafeERC20: approve from non-zero to non-zero allowance"
419         );
420         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
421     }
422 
423     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
424         uint256 newAllowance = token.allowance(address(this), spender).add(value);
425         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
426     }
427 
428     /**
429      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
430      * on the return value: the return value is optional (but if data is returned, it must not be false).
431      * @param token The token targeted by the call.
432      * @param data The call data (encoded using abi.encode or one of its variants).
433      */
434     function _callOptionalReturn(IERC20 token, bytes memory data) private {
435         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
436         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
437         // the target address contains contract code and also asserts for success in the low-level call.
438 
439         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
440         if (returndata.length > 0) { // Return data is optional
441             // solhint-disable-next-line max-line-length
442             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
443         }
444     }
445 }
446 
447 // File: original_contracts/ITokenTransferProxy.sol
448 
449 pragma solidity 0.7.5;
450 
451 
452 interface ITokenTransferProxy {
453 
454     function transferFrom(
455         address token,
456         address from,
457         address to,
458         uint256 amount
459     )
460         external;
461 
462     function freeReduxTokens(address user, uint256 tokensToFree) external;
463 }
464 
465 // File: original_contracts/lib/Utils.sol
466 
467 pragma solidity 0.7.5;
468 
469 
470 
471 
472 
473 
474 library Utils {
475     using SafeMath for uint256;
476     using SafeERC20 for IERC20;
477 
478     address constant ETH_ADDRESS = address(
479         0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE
480     );
481 
482     address constant WETH_ADDRESS = address(
483         0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2
484     );
485 
486     uint256 constant MAX_UINT = 2 ** 256 - 1;
487 
488     /**
489    * @param fromToken Address of the source token
490    * @param toToken Address of the destination token
491    * @param fromAmount Amount of source tokens to be swapped
492    * @param toAmount Minimum destination token amount expected out of this swap
493    * @param expectedAmount Expected amount of destination tokens without slippage
494    * @param beneficiary Beneficiary address
495    * 0 then 100% will be transferred to beneficiary. Pass 10000 for 100%
496    * @param referrer referral id
497    * @param path Route to be taken for this swap to take place
498 
499    */
500     struct SellData {
501         address fromToken;
502         uint256 fromAmount;
503         uint256 toAmount;
504         uint256 expectedAmount;
505         address payable beneficiary;
506         string referrer;
507         bool useReduxToken;
508         Utils.Path[] path;
509 
510     }
511 
512     struct MegaSwapSellData {
513         address fromToken;
514         uint256 fromAmount;
515         uint256 toAmount;
516         uint256 expectedAmount;
517         address payable beneficiary;
518         string referrer;
519         bool useReduxToken;
520         Utils.MegaSwapPath[] path;
521     }
522 
523     struct BuyData {
524         address fromToken;
525         address toToken;
526         uint256 fromAmount;
527         uint256 toAmount;
528         address payable beneficiary;
529         string referrer;
530         bool useReduxToken;
531         Utils.BuyRoute[] route;
532     }
533 
534     struct Route {
535         address payable exchange;
536         address targetExchange;
537         uint percent;
538         bytes payload;
539         uint256 networkFee;//Network fee is associated with 0xv3 trades
540     }
541 
542     struct MegaSwapPath {
543         uint256 fromAmountPercent;
544         Path[] path;
545     }
546 
547     struct Path {
548         address to;
549         uint256 totalNetworkFee;//Network fee is associated with 0xv3 trades
550         Route[] routes;
551     }
552 
553     struct BuyRoute {
554         address payable exchange;
555         address targetExchange;
556         uint256 fromAmount;
557         uint256 toAmount;
558         bytes payload;
559         uint256 networkFee;//Network fee is associated with 0xv3 trades
560     }
561 
562     function ethAddress() internal pure returns (address) {return ETH_ADDRESS;}
563 
564     function wethAddress() internal pure returns (address) {return WETH_ADDRESS;}
565 
566     function maxUint() internal pure returns (uint256) {return MAX_UINT;}
567 
568     function approve(
569         address addressToApprove,
570         address token,
571         uint256 amount
572     ) internal {
573         if (token != ETH_ADDRESS) {
574             IERC20 _token = IERC20(token);
575 
576             uint allowance = _token.allowance(address(this), addressToApprove);
577 
578             if (allowance < amount) {
579                 _token.safeApprove(addressToApprove, 0);
580                 _token.safeIncreaseAllowance(addressToApprove, MAX_UINT);
581             }
582         }
583     }
584 
585     function transferTokens(
586         address token,
587         address payable destination,
588         uint256 amount
589     )
590     internal
591     {
592         if (amount > 0) {
593             if (token == ETH_ADDRESS) {
594                 (bool result, ) = destination.call{value: amount, gas: 4000}("");
595                 require(result, "Failed to transfer Ether");
596             }
597             else {
598                 IERC20(token).safeTransfer(destination, amount);
599             }
600         }
601 
602     }
603 
604     function tokenBalance(
605         address token,
606         address account
607     )
608     internal
609     view
610     returns (uint256)
611     {
612         if (token == ETH_ADDRESS) {
613             return account.balance;
614         } else {
615             return IERC20(token).balanceOf(account);
616         }
617     }
618 
619     /**
620     * @dev Helper method to refund gas using gas tokens
621     */
622     function refundGas(
623         address account,
624         address tokenTransferProxy,
625         uint256 initialGas
626     )
627         internal
628     {
629         uint256 freeBase = 14154;
630         uint256 freeToken = 6870;
631         uint256 reimburse = 24000;
632 
633         uint256 tokens = initialGas.sub(
634             gasleft()).add(freeBase).div(reimburse.mul(2).sub(freeToken)
635         );
636 
637         freeGasTokens(account, tokenTransferProxy, tokens);
638     }
639 
640     /**
641     * @dev Helper method to free gas tokens
642     */
643     function freeGasTokens(address account, address tokenTransferProxy, uint256 tokens) internal {
644 
645         uint256 tokensToFree = tokens;
646         uint256 safeNumTokens = 0;
647         uint256 gas = gasleft();
648 
649         if (gas >= 27710) {
650             safeNumTokens = gas.sub(27710).div(1148 + 5722 + 150);
651         }
652 
653         if (tokensToFree > safeNumTokens) {
654             tokensToFree = safeNumTokens;
655         }
656         ITokenTransferProxy(tokenTransferProxy).freeReduxTokens(account, tokensToFree);
657     }
658 }
659 
660 // File: openzeppelin-solidity/contracts/GSN/Context.sol
661 
662 
663 
664 pragma solidity >=0.6.0 <0.8.0;
665 
666 /*
667  * @dev Provides information about the current execution context, including the
668  * sender of the transaction and its data. While these are generally available
669  * via msg.sender and msg.data, they should not be accessed in such a direct
670  * manner, since when dealing with GSN meta-transactions the account sending and
671  * paying for execution may not be the actual sender (as far as an application
672  * is concerned).
673  *
674  * This contract is only required for intermediate, library-like contracts.
675  */
676 abstract contract Context {
677     function _msgSender() internal view virtual returns (address payable) {
678         return msg.sender;
679     }
680 
681     function _msgData() internal view virtual returns (bytes memory) {
682         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
683         return msg.data;
684     }
685 }
686 
687 // File: openzeppelin-solidity/contracts/access/Ownable.sol
688 
689 
690 
691 pragma solidity >=0.6.0 <0.8.0;
692 
693 /**
694  * @dev Contract module which provides a basic access control mechanism, where
695  * there is an account (an owner) that can be granted exclusive access to
696  * specific functions.
697  *
698  * By default, the owner account will be the one that deploys the contract. This
699  * can later be changed with {transferOwnership}.
700  *
701  * This module is used through inheritance. It will make available the modifier
702  * `onlyOwner`, which can be applied to your functions to restrict their use to
703  * the owner.
704  */
705 abstract contract Ownable is Context {
706     address private _owner;
707 
708     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
709 
710     /**
711      * @dev Initializes the contract setting the deployer as the initial owner.
712      */
713     constructor () internal {
714         address msgSender = _msgSender();
715         _owner = msgSender;
716         emit OwnershipTransferred(address(0), msgSender);
717     }
718 
719     /**
720      * @dev Returns the address of the current owner.
721      */
722     function owner() public view returns (address) {
723         return _owner;
724     }
725 
726     /**
727      * @dev Throws if called by any account other than the owner.
728      */
729     modifier onlyOwner() {
730         require(_owner == _msgSender(), "Ownable: caller is not the owner");
731         _;
732     }
733 
734     /**
735      * @dev Leaves the contract without owner. It will not be possible to call
736      * `onlyOwner` functions anymore. Can only be called by the current owner.
737      *
738      * NOTE: Renouncing ownership will leave the contract without an owner,
739      * thereby removing any functionality that is only available to the owner.
740      */
741     function renounceOwnership() public virtual onlyOwner {
742         emit OwnershipTransferred(_owner, address(0));
743         _owner = address(0);
744     }
745 
746     /**
747      * @dev Transfers ownership of the contract to a new account (`newOwner`).
748      * Can only be called by the current owner.
749      */
750     function transferOwnership(address newOwner) public virtual onlyOwner {
751         require(newOwner != address(0), "Ownable: new owner is the zero address");
752         emit OwnershipTransferred(_owner, newOwner);
753         _owner = newOwner;
754     }
755 }
756 
757 // File: original_contracts/IReduxToken.sol
758 
759 pragma solidity 0.7.5;
760 
761 interface IReduxToken {
762 
763     function freeUpTo(uint256 value) external returns (uint256 freed);
764 
765     function freeFromUpTo(address from, uint256 value) external returns (uint256 freed);
766 
767     function mint(uint256 value) external;
768 }
769 
770 // File: original_contracts/TokenTransferProxy.sol
771 
772 pragma solidity 0.7.5;
773 
774 
775 
776 
777 
778 
779 
780 /**
781 * @dev Allows owner of the contract to transfer tokens on behalf of user.
782 * User will need to approve this contract to spend tokens on his/her behalf
783 * on Paraswap platform
784 */
785 contract TokenTransferProxy is Ownable, ITokenTransferProxy {
786     using SafeERC20 for IERC20;
787 
788     IReduxToken public reduxToken;
789 
790     constructor(address _reduxToken) public {
791         reduxToken = IReduxToken(_reduxToken);
792     }
793 
794     /**
795     * @dev Allows owner of the contract to transfer tokens on user's behalf
796     * @dev Swapper contract will be the owner of this contract
797     * @param token Address of the token
798     * @param from Address from which tokens will be transferred
799     * @param to Receipent address of the tokens
800     * @param amount Amount of tokens to transfer
801     */
802     function transferFrom(
803         address token,
804         address from,
805         address to,
806         uint256 amount
807     )
808         external
809         override
810         onlyOwner
811     {
812         IERC20(token).safeTransferFrom(from, to, amount);
813     }
814 
815     function freeReduxTokens(address user, uint256 tokensToFree) external override onlyOwner {
816         reduxToken.freeFromUpTo(user, tokensToFree);
817     }
818 
819 }
820 
821 // File: original_contracts/IPartnerRegistry.sol
822 
823 pragma solidity 0.7.5;
824 
825 
826 interface IPartnerRegistry {
827 
828     function getPartnerContract(string calldata referralId) external view returns(address);
829 
830 }
831 
832 // File: original_contracts/IPartner.sol
833 
834 pragma solidity 0.7.5;
835 
836 
837 interface IPartner {
838 
839     function getPartnerInfo() external view returns(
840         address payable feeWallet,
841         uint256 fee,
842         uint256 partnerShare,
843         uint256 paraswapShare,
844         bool positiveSlippageToUser,
845         bool noPositiveSlippage
846     );
847 }
848 
849 // File: original_contracts/lib/TokenFetcherAugustus.sol
850 
851 pragma solidity 0.7.5;
852 
853 
854 
855 contract TokenFetcherAugustus {
856 
857     address internal _owner;
858 
859     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
860 
861     /**
862      * @dev Returns the address of the current owner.
863      */
864     function owner() public view returns (address) {
865         return _owner;
866     }
867 
868     /**
869      * @dev Throws if called by any account other than the owner.
870      */
871     modifier onlyOwner() {
872         require(_owner == msg.sender, "Ownable: caller is not the owner");
873         _;
874     }
875 
876     /**
877      * @dev Leaves the contract without owner. It will not be possible to call
878      * `onlyOwner` functions anymore. Can only be called by the current owner.
879      *
880      * NOTE: Renouncing ownership will leave the contract without an owner,
881      * thereby removing any functionality that is only available to the owner.
882      */
883     function renounceOwnership() public onlyOwner {
884         emit OwnershipTransferred(_owner, address(0));
885         _owner = address(0);
886     }
887 
888     /**
889      * @dev Transfers ownership of the contract to a new account (`newOwner`).
890      * Can only be called by the current owner.
891      */
892     function transferOwnership(address newOwner) public onlyOwner {
893         require(newOwner != address(0), "Ownable: new owner is the zero address");
894         emit OwnershipTransferred(_owner, newOwner);
895         _owner = newOwner;
896     }
897     /**
898     * @dev Allows owner of the contract to transfer any tokens which are assigned to the contract
899     * This method is for safety if by any chance tokens or ETHs are assigned to the contract by mistake
900     * @dev token Address of the token to be transferred
901     * @dev destination Recepient of the token
902     * @dev amount Amount of tokens to be transferred
903     */
904     function transferTokens(
905         address token,
906         address payable destination,
907         uint256 amount
908     )
909         external
910         onlyOwner
911     {
912         Utils.transferTokens(token, destination, amount);
913     }
914 }
915 
916 // File: original_contracts/IWETH.sol
917 
918 pragma solidity 0.7.5;
919 
920 
921 
922 abstract contract IWETH is IERC20 {
923     function deposit() external virtual payable;
924     function withdraw(uint256 amount) external virtual;
925 }
926 
927 // File: original_contracts/IUniswapProxy.sol
928 
929 pragma solidity 0.7.5;
930 
931 
932 interface IUniswapProxy {
933     function swapOnUniswap(
934         uint256 amountIn,
935         uint256 amountOutMin,
936         address[] calldata path
937     )
938         external
939         returns (uint256);
940 
941     function swapOnUniswapFork(
942         address factory,
943         bytes32 initCode,
944         uint256 amountIn,
945         uint256 amountOutMin,
946         address[] calldata path
947     )
948         external
949         returns (uint256);
950 
951     function buyOnUniswap(
952         uint256 amountInMax,
953         uint256 amountOut,
954         address[] calldata path
955     )
956         external
957         returns (uint256 tokensSold);
958 
959     function buyOnUniswapFork(
960         address factory,
961         bytes32 initCode,
962         uint256 amountInMax,
963         uint256 amountOut,
964         address[] calldata path
965     )
966         external
967         returns (uint256 tokensSold);
968 
969    function setupTokenSpender(address tokenSpender) external;
970 
971 }
972 
973 // File: original_contracts/AdapterStorage.sol
974 
975 pragma solidity 0.7.5;
976 
977 
978 
979 contract AdapterStorage {
980 
981     mapping (bytes32 => bool) internal adapterInitialized;
982     mapping (bytes32 => bytes) internal adapterVsData;
983     ITokenTransferProxy internal _tokenTransferProxy;
984 
985     function isInitialized(bytes32 key) public view returns(bool) {
986         return adapterInitialized[key];
987     }
988 
989     function getData(bytes32 key) public view returns(bytes memory) {
990         return adapterVsData[key];
991     }
992 
993     function getTokenTransferProxy() public view returns (address) {
994         return address(_tokenTransferProxy);
995     }
996 }
997 
998 // File: original_contracts/AugustusSwapper.sol
999 
1000 pragma solidity 0.7.5;
1001 pragma experimental ABIEncoderV2;
1002 
1003 
1004 
1005 
1006 
1007 
1008 
1009 
1010 
1011 
1012 
1013 
1014 
1015 contract AugustusSwapper is AdapterStorage, TokenFetcherAugustus {
1016     using SafeMath for uint256;
1017 
1018     IWhitelisted private _whitelisted;
1019 
1020     IPartnerRegistry private _partnerRegistry;
1021 
1022     address payable private _feeWallet;
1023 
1024     address private _uniswapProxy;
1025 
1026     address private _pendingUniswapProxy;
1027 
1028     uint256 private _changeRequestedBlock;
1029 
1030     //Number of blocks after which UniswapProxy change can be confirmed
1031     uint256 private _timelock;
1032 
1033     event Swapped(
1034         address initiator,
1035         address indexed beneficiary,
1036         address indexed srcToken,
1037         address indexed destToken,
1038         uint256 srcAmount,
1039         uint256 receivedAmount,
1040         uint256 expectedAmount,
1041         string referrer
1042     );
1043 
1044     event Bought(
1045         address initiator,
1046         address indexed beneficiary,
1047         address indexed srcToken,
1048         address indexed destToken,
1049         uint256 srcAmount,
1050         uint256 receivedAmount,
1051         string referrer
1052     );
1053 
1054     event FeeTaken(
1055         uint256 fee,
1056         uint256 partnerShare,
1057         uint256 paraswapShare
1058     );
1059 
1060     event AdapterInitialized(address indexed adapter);
1061 
1062     modifier onlySelf() {
1063         require(
1064             msg.sender == address(this),
1065             "AugustusSwapper: Invalid access"
1066         );
1067         _;
1068     }
1069 
1070     receive () payable external {
1071 
1072     }
1073 
1074     function getTimeLock() external view returns(uint256) {
1075       return _timelock;
1076     }
1077 
1078     function initialize(
1079         address whitelist,
1080         address reduxToken,
1081         address partnerRegistry,
1082         address payable feeWallet,
1083         address uniswapProxy,
1084         uint256 timelock
1085     )
1086         external
1087     {
1088         require(address(_tokenTransferProxy) == address(0), "Contract already initialized!!");
1089         _partnerRegistry = IPartnerRegistry(partnerRegistry);
1090         TokenTransferProxy lTokenTransferProxy = new TokenTransferProxy(reduxToken);
1091         _tokenTransferProxy = ITokenTransferProxy(lTokenTransferProxy);
1092         _whitelisted = IWhitelisted(whitelist);
1093         _feeWallet = feeWallet;
1094         _uniswapProxy = uniswapProxy;
1095         _owner = msg.sender;
1096         _timelock = timelock;
1097     }
1098 
1099     function initializeAdapter(address adapter, bytes calldata data) external onlyOwner {
1100 
1101         require(
1102             _whitelisted.hasRole(_whitelisted.WHITELISTED_ROLE(), adapter),
1103             "Exchange not whitelisted"
1104         );
1105         (bool success,) = adapter.delegatecall(abi.encodeWithSelector(IExchange.initialize.selector, data));
1106         require(success, "Failed to initialize adapter");
1107         emit AdapterInitialized(adapter);
1108     }
1109 
1110     function getPendingUniswapProxy() external view returns(address) {
1111       return  _pendingUniswapProxy;
1112     }
1113 
1114     function getChangeRequestedBlock() external view returns(uint256) {
1115       return _changeRequestedBlock;
1116     }
1117 
1118     function getUniswapProxy() external view returns(address) {
1119         return _uniswapProxy;
1120     }
1121 
1122     function getVersion() external view returns(string memory) {
1123         return "4.0.0";
1124     }
1125 
1126     function getPartnerRegistry() external view returns(address) {
1127         return address(_partnerRegistry);
1128     }
1129 
1130     function getWhitelistAddress() external view returns(address) {
1131         return address(_whitelisted);
1132     }
1133 
1134     function getFeeWallet() external view returns(address) {
1135         return _feeWallet;
1136     }
1137 
1138     function changeUniswapProxy(address uniswapProxy) external onlyOwner {
1139         require(uniswapProxy != address(0), "Invalid address");
1140         _changeRequestedBlock = block.number;
1141         _pendingUniswapProxy = uniswapProxy;
1142     }
1143 
1144     function confirmUniswapProxyChange() external onlyOwner {
1145         require(
1146             block.number >= _changeRequestedBlock.add(_timelock),
1147             "Time lock check failed"
1148         );
1149 
1150         require(_pendingUniswapProxy != address(0), "No pending request");
1151 
1152         _changeRequestedBlock = 0;
1153         _uniswapProxy = _pendingUniswapProxy;
1154         _pendingUniswapProxy = address(0);
1155     }
1156 
1157     function setFeeWallet(address payable feeWallet) external onlyOwner {
1158         require(feeWallet != address(0), "Invalid address");
1159         _feeWallet = feeWallet;
1160     }
1161 
1162     function setPartnerRegistry(address partnerRegistry) external onlyOwner {
1163         require(partnerRegistry != address(0), "Invalid address");
1164         _partnerRegistry = IPartnerRegistry(partnerRegistry);
1165     }
1166 
1167     function setWhitelistAddress(address whitelisted) external onlyOwner {
1168         require(whitelisted != address(0), "Invalid whitelist address");
1169         _whitelisted = IWhitelisted(whitelisted);
1170     }
1171 
1172     function swapOnUniswap(
1173         uint256 amountIn,
1174         uint256 amountOutMin,
1175         address[] calldata path,
1176         uint8 referrer
1177     )
1178         external
1179         payable
1180     {
1181         //DELEGATING CALL TO THE ADAPTER
1182         (bool success, bytes memory result) = _uniswapProxy.delegatecall(
1183             abi.encodeWithSelector(
1184                 IUniswapProxy.swapOnUniswap.selector,
1185                 amountIn,
1186                 amountOutMin,
1187                 path
1188             )
1189         );
1190         require(success, "Call to uniswap proxy failed");
1191 
1192     }
1193 
1194     function buyOnUniswap(
1195         uint256 amountInMax,
1196         uint256 amountOut,
1197         address[] calldata path,
1198         uint8 referrer
1199     )
1200         external
1201         payable
1202     {
1203         //DELEGATING CALL TO THE ADAPTER
1204         (bool success, bytes memory result) = _uniswapProxy.delegatecall(
1205             abi.encodeWithSelector(
1206                 IUniswapProxy.buyOnUniswap.selector,
1207                 amountInMax,
1208                 amountOut,
1209                 path
1210             )
1211         );
1212         require(success, "Call to uniswap proxy failed");
1213 
1214     }
1215 
1216     function buyOnUniswapFork(
1217         address factory,
1218         bytes32 initCode,
1219         uint256 amountInMax,
1220         uint256 amountOut,
1221         address[] calldata path,
1222         uint8 referrer
1223     )
1224         external
1225         payable
1226     {
1227         //DELEGATING CALL TO THE ADAPTER
1228         (bool success, bytes memory result) = _uniswapProxy.delegatecall(
1229             abi.encodeWithSelector(
1230                 IUniswapProxy.buyOnUniswapFork.selector,
1231                 factory,
1232                 initCode,
1233                 amountInMax,
1234                 amountOut,
1235                 path
1236             )
1237         );
1238         require(success, "Call to uniswap proxy failed");
1239 
1240     }
1241 
1242     function swapOnUniswapFork(
1243         address factory,
1244         bytes32 initCode,
1245         uint256 amountIn,
1246         uint256 amountOutMin,
1247         address[] calldata path,
1248         uint8 referrer
1249     )
1250         external
1251         payable
1252 
1253     {
1254         //DELEGATING CALL TO THE ADAPTER
1255         (bool success, bytes memory result) = _uniswapProxy.delegatecall(
1256             abi.encodeWithSelector(
1257                 IUniswapProxy.swapOnUniswapFork.selector,
1258                 factory,
1259                 initCode,
1260                 amountIn,
1261                 amountOutMin,
1262                 path
1263             )
1264         );
1265         require(success, "Call to uniswap proxy failed");
1266 
1267     }
1268 
1269     function simplBuy(
1270         address fromToken,
1271         address toToken,
1272         uint256 fromAmount,
1273         uint256 toAmount,
1274         address[] memory callees,
1275         bytes memory exchangeData,
1276         uint256[] memory startIndexes,
1277         uint256[] memory values,
1278         address payable beneficiary,
1279         string memory referrer,
1280         bool useReduxToken
1281     )
1282         external
1283         payable
1284 
1285     {
1286         beneficiary = beneficiary == address(0) ? msg.sender : beneficiary;
1287         uint receivedAmount = performSimpleSwap(
1288             fromToken,
1289             toToken,
1290             fromAmount,
1291             toAmount,
1292             toAmount,//expected amount and to amount are same in case of buy
1293             callees,
1294             exchangeData,
1295             startIndexes,
1296             values,
1297             beneficiary,
1298             referrer,
1299             useReduxToken
1300         );
1301 
1302         uint256 remainingAmount = Utils.tokenBalance(
1303             fromToken,
1304             address(this)
1305         );
1306 
1307         if (remainingAmount > 0) {
1308             Utils.transferTokens(address(fromToken), msg.sender, remainingAmount);
1309         }
1310 
1311         emit Bought(
1312             msg.sender,
1313             beneficiary,
1314             fromToken,
1315             toToken,
1316             fromAmount,
1317             receivedAmount,
1318             referrer
1319         );
1320     }
1321 
1322     function approve(
1323         address token,
1324         address to,
1325         uint256 amount
1326     )
1327         external
1328         onlySelf
1329     {
1330         Utils.approve(to, token, amount);
1331     }
1332 
1333     function simpleSwap(
1334         address fromToken,
1335         address toToken,
1336         uint256 fromAmount,
1337         uint256 toAmount,
1338         uint256 expectedAmount,
1339         address[] memory callees,
1340         bytes memory exchangeData,
1341         uint256[] memory startIndexes,
1342         uint256[] memory values,
1343         address payable beneficiary,
1344         string memory referrer,
1345         bool useReduxToken
1346     )
1347         public
1348         payable
1349         returns (uint256 receivedAmount)
1350     {
1351         beneficiary = beneficiary == address(0) ? msg.sender : beneficiary;
1352         receivedAmount = performSimpleSwap(
1353             fromToken,
1354             toToken,
1355             fromAmount,
1356             toAmount,
1357             expectedAmount,
1358             callees,
1359             exchangeData,
1360             startIndexes,
1361             values,
1362             beneficiary,
1363             referrer,
1364             useReduxToken
1365         );
1366 
1367         emit Swapped(
1368             msg.sender,
1369             beneficiary,
1370             fromToken,
1371             toToken,
1372             fromAmount,
1373             receivedAmount,
1374             expectedAmount,
1375             referrer
1376         );
1377 
1378         return receivedAmount;
1379     }
1380 
1381     function transferTokensFromProxy(
1382         address token,
1383         uint256 amount
1384     )
1385       private
1386     {
1387         if (token != Utils.ethAddress()) {
1388             _tokenTransferProxy.transferFrom(
1389                 token,
1390                 msg.sender,
1391                 address(this),
1392                 amount
1393             );
1394         }
1395     }
1396 
1397     function performSimpleSwap(
1398         address fromToken,
1399         address toToken,
1400         uint256 fromAmount,
1401         uint256 toAmount,
1402         uint256 expectedAmount,
1403         address[] memory callees,
1404         bytes memory exchangeData,
1405         uint256[] memory startIndexes,
1406         uint256[] memory values,
1407         address payable beneficiary,
1408         string memory referrer,
1409         bool useReduxToken
1410     )
1411         private
1412         returns (uint256 receivedAmount)
1413     {
1414         require(toAmount > 0, "toAmount is too low");
1415         require(
1416             callees.length + 1 == startIndexes.length,
1417             "Start indexes must be 1 greater then number of callees"
1418         );
1419 
1420         uint initialGas = gasleft();
1421 
1422         //If source token is not ETH than transfer required amount of tokens
1423         //from sender to this contract
1424         transferTokensFromProxy(fromToken, fromAmount);
1425 
1426         for (uint256 i = 0; i < callees.length; i++) {
1427             require(
1428                 callees[i] != address(_tokenTransferProxy),
1429                 "Can not call TokenTransferProxy Contract"
1430             );
1431 
1432             bool result = externalCall(
1433                 callees[i], //destination
1434                 values[i], //value to send
1435                 startIndexes[i], // start index of call data
1436                 startIndexes[i + 1].sub(startIndexes[i]), // length of calldata
1437                 exchangeData// total calldata
1438             );
1439             require(result, "External call failed");
1440         }
1441 
1442         receivedAmount = Utils.tokenBalance(
1443             toToken,
1444             address(this)
1445         );
1446 
1447         require(
1448             receivedAmount >= toAmount,
1449             "Received amount of tokens are less then expected"
1450         );
1451 
1452         takeFeeAndTransferTokens(
1453             toToken,
1454             expectedAmount,
1455             receivedAmount,
1456             beneficiary,
1457             referrer
1458         );
1459 
1460         if (useReduxToken) {
1461             Utils.refundGas(msg.sender, address(_tokenTransferProxy), initialGas);
1462         }
1463 
1464         return receivedAmount;
1465     }
1466 
1467     /**
1468    * @dev This function sends the WETH returned during the exchange to the user.
1469    * @param token: The WETH Address
1470    */
1471     function withdrawAllWETH(IWETH token) external onlySelf {
1472         uint256 amount = token.balanceOf(address(this));
1473         token.withdraw(amount);
1474     }
1475 
1476     /**
1477    * @dev The function which performs the multi path swap.
1478    * @param data Data required to perform swap.
1479    */
1480     function multiSwap(
1481         Utils.SellData memory data
1482     )
1483         public
1484         payable
1485         returns (uint256)
1486     {
1487         uint initialGas = gasleft();
1488 
1489         address fromToken = data.fromToken;
1490         uint256 fromAmount = data.fromAmount;
1491         uint256 toAmount = data.toAmount;
1492         uint256 expectedAmount = data.expectedAmount;
1493         address payable beneficiary = data.beneficiary == address(0) ? msg.sender : data.beneficiary;
1494         string memory referrer = data.referrer;
1495         Utils.Path[] memory path = data.path;
1496         address toToken = path[path.length - 1].to;
1497         bool useReduxToken = data.useReduxToken;
1498 
1499         //Referral can never be empty
1500         require(bytes(referrer).length > 0, "Invalid referrer");
1501 
1502         require(toAmount > 0, "To amount can not be 0");
1503 
1504         //if fromToken is not ETH then transfer tokens from user to this contract
1505         if (fromToken != Utils.ethAddress()) {
1506             _tokenTransferProxy.transferFrom(
1507                 fromToken,
1508                 msg.sender,
1509                 address(this),
1510                 fromAmount
1511             );
1512         }
1513 
1514         performSwap(
1515             fromToken,
1516             fromAmount,
1517             path
1518         );
1519 
1520 
1521         uint256 receivedAmount = Utils.tokenBalance(
1522             toToken,
1523             address(this)
1524         );
1525 
1526         require(
1527             receivedAmount >= toAmount,
1528             "Received amount of tokens are less then expected"
1529         );
1530 
1531 
1532         takeFeeAndTransferTokens(
1533             toToken,
1534             expectedAmount,
1535             receivedAmount,
1536             beneficiary,
1537             referrer
1538         );
1539 
1540         if (useReduxToken) {
1541             Utils.refundGas(msg.sender, address(_tokenTransferProxy), initialGas);
1542         }
1543 
1544         emit Swapped(
1545             msg.sender,
1546             beneficiary,
1547             fromToken,
1548             toToken,
1549             fromAmount,
1550             receivedAmount,
1551             expectedAmount,
1552             referrer
1553         );
1554 
1555         return receivedAmount;
1556     }
1557 
1558     /**
1559    * @dev The function which performs the mega path swap.
1560    * @param data Data required to perform swap.
1561    */
1562     function megaSwap(
1563         Utils.MegaSwapSellData memory data
1564     )
1565         public
1566         payable
1567         returns (uint256)
1568     {
1569         uint initialGas = gasleft();
1570 
1571         address fromToken = data.fromToken;
1572         uint256 fromAmount = data.fromAmount;
1573         uint256 toAmount = data.toAmount;
1574         uint256 expectedAmount = data.expectedAmount;
1575         address payable beneficiary = data.beneficiary == address(0) ? msg.sender : data.beneficiary;
1576         string memory referrer = data.referrer;
1577         Utils.MegaSwapPath[] memory path = data.path;
1578         address toToken = path[0].path[path[0].path.length - 1].to;
1579         bool useReduxToken = data.useReduxToken;
1580 
1581         //Referral can never be empty
1582         require(bytes(referrer).length > 0, "Invalid referrer");
1583 
1584         require(toAmount > 0, "To amount can not be 0");
1585 
1586         //if fromToken is not ETH then transfer tokens from user to this contract
1587         if (fromToken != Utils.ethAddress()) {
1588             _tokenTransferProxy.transferFrom(
1589                 fromToken,
1590                 msg.sender,
1591                 address(this),
1592                 fromAmount
1593             );
1594         }
1595 
1596         for (uint8 i = 0; i < uint8(path.length); i++) {
1597             uint256 _fromAmount = fromAmount.mul(path[i].fromAmountPercent).div(10000);
1598             if (i == path.length - 1) {
1599                 _fromAmount = Utils.tokenBalance(address(fromToken), address(this));
1600             }
1601             performSwap(
1602                 fromToken,
1603                 _fromAmount,
1604                 path[i].path
1605             );
1606         }
1607 
1608         uint256 receivedAmount = Utils.tokenBalance(
1609             toToken,
1610             address(this)
1611         );
1612 
1613         require(
1614             receivedAmount >= toAmount,
1615             "Received amount of tokens are less then expected"
1616         );
1617 
1618 
1619         takeFeeAndTransferTokens(
1620             toToken,
1621             expectedAmount,
1622             receivedAmount,
1623             beneficiary,
1624             referrer
1625         );
1626 
1627         if (useReduxToken) {
1628             Utils.refundGas(msg.sender, address(_tokenTransferProxy), initialGas);
1629         }
1630 
1631         emit Swapped(
1632             msg.sender,
1633             beneficiary,
1634             fromToken,
1635             toToken,
1636             fromAmount,
1637             receivedAmount,
1638             expectedAmount,
1639             referrer
1640         );
1641 
1642         return receivedAmount;
1643     }
1644 
1645     /**
1646    * @dev The function which performs the single path buy.
1647    * @param data Data required to perform swap.
1648    */
1649     function buy(
1650         Utils.BuyData memory data
1651     )
1652         public
1653         payable
1654         returns (uint256)
1655     {
1656 
1657         address fromToken = data.fromToken;
1658         uint256 fromAmount = data.fromAmount;
1659         uint256 toAmount = data.toAmount;
1660         address payable beneficiary = data.beneficiary == address(0) ? msg.sender : data.beneficiary;
1661         string memory referrer = data.referrer;
1662         Utils.BuyRoute[] memory route = data.route;
1663         address toToken = data.toToken;
1664         bool useReduxToken = data.useReduxToken;
1665 
1666         //Referral id can never be empty
1667         require(bytes(referrer).length > 0, "Invalid referrer");
1668 
1669         require(toAmount > 0, "To amount can not be 0");
1670 
1671         uint256 receivedAmount = performBuy(
1672             fromToken,
1673             toToken,
1674             fromAmount,
1675             toAmount,
1676             route,
1677             useReduxToken
1678         );
1679 
1680         takeFeeAndTransferTokens(
1681             toToken,
1682             toAmount,
1683             receivedAmount,
1684             beneficiary,
1685             referrer
1686         );
1687 
1688         uint256 remainingAmount = Utils.tokenBalance(
1689             fromToken,
1690             address(this)
1691         );
1692 
1693         if (remainingAmount > 0) {
1694             Utils.transferTokens(fromToken, msg.sender, remainingAmount);
1695         }
1696 
1697         emit Bought(
1698             msg.sender,
1699             beneficiary,
1700             fromToken,
1701             toToken,
1702             fromAmount,
1703             receivedAmount,
1704             referrer
1705         );
1706 
1707         return receivedAmount;
1708     }
1709 
1710     //Helper function to transfer final amount to the beneficiaries
1711     function takeFeeAndTransferTokens(
1712         address toToken,
1713         uint256 expectedAmount,
1714         uint256 receivedAmount,
1715         address payable beneficiary,
1716         string memory referrer
1717 
1718     )
1719         private
1720     {
1721         uint256 remainingAmount = receivedAmount;
1722 
1723         address partnerContract = _partnerRegistry.getPartnerContract(referrer);
1724 
1725         //Take partner fee
1726         ( uint256 fee ) = _takeFee(
1727             toToken,
1728             receivedAmount,
1729             expectedAmount,
1730             partnerContract
1731         );
1732         remainingAmount = receivedAmount.sub(fee);
1733 
1734         //If there is a positive slippage after taking partner fee then 50% goes to paraswap and 50% to the user
1735         if ((remainingAmount > expectedAmount) && fee == 0) {
1736             uint256 positiveSlippageShare = remainingAmount.sub(expectedAmount).div(2);
1737             remainingAmount = remainingAmount.sub(positiveSlippageShare);
1738             Utils.transferTokens(toToken, _feeWallet, positiveSlippageShare);
1739         }
1740 
1741         Utils.transferTokens(toToken, beneficiary, remainingAmount);
1742 
1743 
1744     }
1745 
1746     /**
1747     * @dev Source take from GNOSIS MultiSigWallet
1748     * @dev https://github.com/gnosis/MultiSigWallet/blob/master/contracts/MultiSigWallet.sol
1749     */
1750     function externalCall(
1751         address destination,
1752         uint256 value,
1753         uint256 dataOffset,
1754         uint dataLength,
1755         bytes memory data
1756     )
1757     private
1758     returns (bool)
1759     {
1760         bool result = false;
1761 
1762         assembly {
1763             let x := mload(0x40)   // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
1764 
1765             let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
1766             result := call(
1767                 sub(gas(), 34710), // 34710 is the value that solidity is currently emitting
1768                 // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
1769                 // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
1770                 destination,
1771                 value,
1772                 add(d, dataOffset),
1773                 dataLength, // Size of the input (in bytes) - this is what fixes the padding problem
1774                 x,
1775                 0                  // Output is ignored, therefore the output size is zero
1776             )
1777         }
1778         return result;
1779     }
1780 
1781     //Helper function to perform swap
1782     function performSwap(
1783         address fromToken,
1784         uint256 fromAmount,
1785         Utils.Path[] memory path
1786     )
1787         private
1788     {
1789 
1790         require(path.length > 0, "Path not provided for swap");
1791 
1792         //Assuming path will not be too long to reach out of gas exception
1793         for (uint i = 0; i < path.length; i++) {
1794             //_fromToken will be either fromToken or toToken of the previous path
1795             address _fromToken = i > 0 ? path[i - 1].to : fromToken;
1796             address _toToken = path[i].to;
1797 
1798             uint256 _fromAmount = i > 0 ? Utils.tokenBalance(_fromToken, address(this)) : fromAmount;
1799             if (i > 0 && _fromToken == Utils.ethAddress()) {
1800                 _fromAmount = _fromAmount.sub(path[i].totalNetworkFee);
1801             }
1802 
1803             for (uint j = 0; j < path[i].routes.length; j++) {
1804                 Utils.Route memory route = path[i].routes[j];
1805 
1806                 //Check if exchange is supported
1807                 require(
1808                     _whitelisted.hasRole(_whitelisted.WHITELISTED_ROLE(), route.exchange),
1809                     "Exchange not whitelisted"
1810                 );
1811 
1812                 //Calculating tokens to be passed to the relevant exchange
1813                 //percentage should be 200 for 2%
1814                 uint fromAmountSlice = _fromAmount.mul(route.percent).div(10000);
1815                 uint256 value = route.networkFee;
1816 
1817                 if (i > 0 && j == path[i].routes.length.sub(1)) {
1818                     uint256 remBal = Utils.tokenBalance(address(_fromToken), address(this));
1819 
1820                     fromAmountSlice = remBal;
1821 
1822                     if (address(_fromToken) == Utils.ethAddress()) {
1823                         //subtract network fee
1824                         fromAmountSlice = fromAmountSlice.sub(value);
1825                     }
1826                 }
1827 
1828                 //DELEGATING CALL TO THE ADAPTER
1829                 (bool success,) = route.exchange.delegatecall(
1830                     abi.encodeWithSelector(
1831                         IExchange.swap.selector,
1832                         _fromToken,
1833                         _toToken,
1834                         fromAmountSlice,
1835                         1,
1836                         route.targetExchange,
1837                         route.payload
1838                     )
1839                 );
1840 
1841                 require(success, "Call to adapter failed");
1842             }
1843         }
1844     }
1845 
1846     //Helper function to perform swap
1847     function performBuy(
1848         address fromToken,
1849         address toToken,
1850         uint256 fromAmount,
1851         uint256 toAmount,
1852         Utils.BuyRoute[] memory routes,
1853         bool useReduxToken
1854     )
1855         private
1856         returns(uint256)
1857     {
1858         uint initialGas = gasleft();
1859 
1860         //if fromToken is not ETH then transfer tokens from user to this contract
1861         if (fromToken != Utils.ethAddress()) {
1862             _tokenTransferProxy.transferFrom(
1863                 fromToken,
1864                 msg.sender,
1865                 address(this),
1866                 fromAmount
1867             );
1868         }
1869 
1870         for (uint j = 0; j < routes.length; j++) {
1871             Utils.BuyRoute memory route = routes[j];
1872 
1873             //Check if exchange is supported
1874             require(
1875                 _whitelisted.hasRole(_whitelisted.WHITELISTED_ROLE(), route.exchange),
1876                 "Exchange not whitelisted"
1877             );
1878 
1879             //delegate Call to the exchange
1880             (bool success,) = route.exchange.delegatecall(
1881                 abi.encodeWithSelector(
1882                     IExchange.buy.selector,
1883                     fromToken,
1884                     toToken,
1885                     route.fromAmount,
1886                     route.toAmount,
1887                     route.targetExchange,
1888                     route.payload
1889                 )
1890             );
1891             require(success, "Call to adapter failed");
1892         }
1893 
1894         uint256 receivedAmount = Utils.tokenBalance(
1895             toToken,
1896             address(this)
1897         );
1898         require(
1899             receivedAmount >= toAmount,
1900             "Received amount of tokens are less then expected tokens"
1901         );
1902 
1903         if (useReduxToken) {
1904             Utils.refundGas(msg.sender, address(_tokenTransferProxy), initialGas);
1905         }
1906         return receivedAmount;
1907     }
1908 
1909     function _takeFee(
1910         address toToken,
1911         uint256 receivedAmount,
1912         uint256 expectedAmount,
1913         address partnerContract
1914     )
1915         private
1916         returns(uint256 fee)
1917     {
1918         //If there is no partner associated with the referral id then no fee will be taken
1919         if (partnerContract == address(0)) {
1920             return (0);
1921         }
1922 
1923         (
1924             address payable partnerFeeWallet,
1925             uint256 feePercent,
1926             uint256 partnerSharePercent,
1927             ,
1928             bool positiveSlippageToUser,
1929             bool noPositiveSlippage
1930         ) = IPartner(partnerContract).getPartnerInfo();
1931 
1932         uint256 partnerShare = 0;
1933         uint256 paraswapShare = 0;
1934 
1935         if (!noPositiveSlippage && feePercent <= 50 && receivedAmount > expectedAmount) {
1936             uint256 halfPositiveSlippage = receivedAmount.sub(expectedAmount).div(2);
1937             //Calculate total fee to be taken
1938             fee = expectedAmount.mul(feePercent).div(10000);
1939             //Calculate partner's share
1940             partnerShare = fee.mul(partnerSharePercent).div(10000);
1941             //All remaining fee is paraswap's share
1942             paraswapShare = fee.sub(partnerShare);
1943             paraswapShare = paraswapShare.add(halfPositiveSlippage);
1944 
1945             fee = fee.add(halfPositiveSlippage);
1946 
1947             if (!positiveSlippageToUser) {
1948                 partnerShare = partnerShare.add(halfPositiveSlippage);
1949                 fee = fee.add(halfPositiveSlippage);
1950             }
1951         }
1952         else {
1953             //Calculate total fee to be taken
1954             fee = receivedAmount.mul(feePercent).div(10000);
1955             //Calculate partner's share
1956             partnerShare = fee.mul(partnerSharePercent).div(10000);
1957             //All remaining fee is paraswap's share
1958             paraswapShare = fee.sub(partnerShare);
1959         }
1960         Utils.transferTokens(toToken, partnerFeeWallet, partnerShare);
1961         Utils.transferTokens(toToken, _feeWallet, paraswapShare);
1962 
1963         emit FeeTaken(fee, partnerShare, paraswapShare);
1964         return (fee);
1965     }
1966 }