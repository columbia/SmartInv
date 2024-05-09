1 // FALQOM - Shiba Hunter
2 
3 // SPDX-License-Identifier: MIT
4 pragma solidity ^0.6.0;
5 
6 /*
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with GSN meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address payable) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes memory) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 /**
28  * @dev Interface of the ERC20 standard as defined in the EIP.
29  */
30 interface IERC20 {
31     /**
32      * @dev Returns the amount of tokens in existence.
33      */
34     function totalSupply() external view returns (uint256);
35 
36     /**
37      * @dev Returns the amount of tokens owned by `account`.
38      */
39     function balanceOf(address account) external view returns (uint256);
40 
41     /**
42      * @dev Moves `amount` tokens from the caller's account to `recipient`.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * Emits a {Transfer} event.
47      */
48     function transfer(address recipient, uint256 amount) external returns (bool);
49 
50     /**
51      * @dev Returns the remaining number of tokens that `spender` will be
52      * allowed to spend on behalf of `owner` through {transferFrom}. This is
53      * zero by default.
54      *
55      * This value changes when {approve} or {transferFrom} are called.
56      */
57     function allowance(address owner, address spender) external view returns (uint256);
58 
59     /**
60      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * IMPORTANT: Beware that changing an allowance with this method brings the risk
65      * that someone may use both the old and the new allowance by unfortunate
66      * transaction ordering. One possible solution to mitigate this race
67      * condition is to first reduce the spender's allowance to 0 and set the
68      * desired value afterwards:
69      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
70      *
71      * Emits an {Approval} event.
72      */
73     function approve(address spender, uint256 amount) external returns (bool);
74 
75     /**
76      * @dev Moves `amount` tokens from `sender` to `recipient` using the
77      * allowance mechanism. `amount` is then deducted from the caller's
78      * allowance.
79      *
80      * Returns a boolean value indicating whether the operation succeeded.
81      *
82      * Emits a {Transfer} event.
83      */
84     function transferFrom(
85         address sender,
86         address recipient,
87         uint256 amount
88     ) external returns (bool);
89 
90     /**
91      * @dev Emitted when `value` tokens are moved from one account (`from`) to
92      * another (`to`).
93      *
94      * Note that `value` may be zero.
95      */
96     event Transfer(address indexed from, address indexed to, uint256 value);
97 
98     /**
99      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
100      * a call to {approve}. `value` is the new allowance.
101      */
102     event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
105 /**
106  * @dev Wrappers over Solidity's arithmetic operations with added overflow
107  * checks.
108  *
109  * Arithmetic operations in Solidity wrap on overflow. This can easily result
110  * in bugs, because programmers usually assume that an overflow raises an
111  * error, which is the standard behavior in high level programming languages.
112  * `SafeMath` restores this intuition by reverting the transaction when an
113  * operation overflows.
114  *
115  * Using this library instead of the unchecked operations eliminates an entire
116  * class of bugs, so it's recommended to use it always.
117  */
118 library SafeMath {
119     /**
120      * @dev Returns the addition of two unsigned integers, reverting on
121      * overflow.
122      *
123      * Counterpart to Solidity's `+` operator.
124      *
125      * Requirements:
126      *
127      * - Addition cannot overflow.
128      */
129     function add(uint256 a, uint256 b) internal pure returns (uint256) {
130         uint256 c = a + b;
131         require(c >= a, 'SafeMath: addition overflow');
132 
133         return c;
134     }
135 
136     /**
137      * @dev Returns the subtraction of two unsigned integers, reverting on
138      * overflow (when the result is negative).
139      *
140      * Counterpart to Solidity's `-` operator.
141      *
142      * Requirements:
143      *
144      * - Subtraction cannot overflow.
145      */
146     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
147         return sub(a, b, 'SafeMath: subtraction overflow');
148     }
149 
150     /**
151      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
152      * overflow (when the result is negative).
153      *
154      * Counterpart to Solidity's `-` operator.
155      *
156      * Requirements:
157      *
158      * - Subtraction cannot overflow.
159      */
160     function sub(
161         uint256 a,
162         uint256 b,
163         string memory errorMessage
164     ) internal pure returns (uint256) {
165         require(b <= a, errorMessage);
166         uint256 c = a - b;
167 
168         return c;
169     }
170 
171     /**
172      * @dev Returns the multiplication of two unsigned integers, reverting on
173      * overflow.
174      *
175      * Counterpart to Solidity's `*` operator.
176      *
177      * Requirements:
178      *
179      * - Multiplication cannot overflow.
180      */
181     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
182         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
183         // benefit is lost if 'b' is also tested.
184         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
185         if (a == 0) {
186             return 0;
187         }
188 
189         uint256 c = a * b;
190         require(c / a == b, 'SafeMath: multiplication overflow');
191 
192         return c;
193     }
194 
195     /**
196      * @dev Returns the integer division of two unsigned integers. Reverts on
197      * division by zero. The result is rounded towards zero.
198      *
199      * Counterpart to Solidity's `/` operator. Note: this function uses a
200      * `revert` opcode (which leaves remaining gas untouched) while Solidity
201      * uses an invalid opcode to revert (consuming all remaining gas).
202      *
203      * Requirements:
204      *
205      * - The divisor cannot be zero.
206      */
207     function div(uint256 a, uint256 b) internal pure returns (uint256) {
208         return div(a, b, 'SafeMath: division by zero');
209     }
210 
211     /**
212      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
213      * division by zero. The result is rounded towards zero.
214      *
215      * Counterpart to Solidity's `/` operator. Note: this function uses a
216      * `revert` opcode (which leaves remaining gas untouched) while Solidity
217      * uses an invalid opcode to revert (consuming all remaining gas).
218      *
219      * Requirements:
220      *
221      * - The divisor cannot be zero.
222      */
223     function div(
224         uint256 a,
225         uint256 b,
226         string memory errorMessage
227     ) internal pure returns (uint256) {
228         require(b > 0, errorMessage);
229         uint256 c = a / b;
230         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
231 
232         return c;
233     }
234 
235     /**
236      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
237      * Reverts when dividing by zero.
238      *
239      * Counterpart to Solidity's `%` operator. This function uses a `revert`
240      * opcode (which leaves remaining gas untouched) while Solidity uses an
241      * invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      *
245      * - The divisor cannot be zero.
246      */
247     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
248         return mod(a, b, 'SafeMath: modulo by zero');
249     }
250 
251     /**
252      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
253      * Reverts with custom message when dividing by zero.
254      *
255      * Counterpart to Solidity's `%` operator. This function uses a `revert`
256      * opcode (which leaves remaining gas untouched) while Solidity uses an
257      * invalid opcode to revert (consuming all remaining gas).
258      *
259      * Requirements:
260      *
261      * - The divisor cannot be zero.
262      */
263     function mod(
264         uint256 a,
265         uint256 b,
266         string memory errorMessage
267     ) internal pure returns (uint256) {
268         require(b != 0, errorMessage);
269         return a % b;
270     }
271 }
272 
273 /**
274  * @dev Collection of functions related to the address type
275  */
276 library Address {
277     /**
278      * @dev Returns true if `account` is a contract.
279      *
280      * [IMPORTANT]
281      * ====
282      * It is unsafe to assume that an address for which this function returns
283      * false is an externally-owned account (EOA) and not a contract.
284      *
285      * Among others, `isContract` will return false for the following
286      * types of addresses:
287      *
288      *  - an externally-owned account
289      *  - a contract in construction
290      *  - an address where a contract will be created
291      *  - an address where a contract lived, but was destroyed
292      * ====
293      */
294     function isContract(address account) internal view returns (bool) {
295         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
296         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
297         // for accounts without code, i.e. `keccak256('')`
298         bytes32 codehash;
299 
300         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
301         // solhint-disable-next-line no-inline-assembly
302         assembly {
303             codehash := extcodehash(account)
304         }
305         return (codehash != accountHash && codehash != 0x0);
306     }
307 
308     /**
309      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
310      * `recipient`, forwarding all available gas and reverting on errors.
311      *
312      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
313      * of certain opcodes, possibly making contracts go over the 2300 gas limit
314      * imposed by `transfer`, making them unable to receive funds via
315      * `transfer`. {sendValue} removes this limitation.
316      *
317      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
318      *
319      * IMPORTANT: because control is transferred to `recipient`, care must be
320      * taken to not create reentrancy vulnerabilities. Consider using
321      * {ReentrancyGuard} or the
322      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
323      */
324     function sendValue(address payable recipient, uint256 amount) internal {
325         require(address(this).balance >= amount, 'Address: insufficient balance');
326 
327         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
328         (bool success, ) = recipient.call{value: amount}('');
329         require(success, 'Address: unable to send value, recipient may have reverted');
330     }
331 
332     /**
333      * @dev Performs a Solidity function call using a low level `call`. A
334      * plain`call` is an unsafe replacement for a function call: use this
335      * function instead.
336      *
337      * If `target` reverts with a revert reason, it is bubbled up by this
338      * function (like regular Solidity function calls).
339      *
340      * Returns the raw returned data. To convert to the expected return value,
341      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
342      *
343      * Requirements:
344      *
345      * - `target` must be a contract.
346      * - calling `target` with `data` must not revert.
347      *
348      * _Available since v3.1._
349      */
350     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
351         return functionCall(target, data, 'Address: low-level call failed');
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
356      * `errorMessage` as a fallback revert reason when `target` reverts.
357      *
358      * _Available since v3.1._
359      */
360     function functionCall(
361         address target,
362         bytes memory data,
363         string memory errorMessage
364     ) internal returns (bytes memory) {
365         return _functionCallWithValue(target, data, 0, errorMessage);
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
370      * but also transferring `value` wei to `target`.
371      *
372      * Requirements:
373      *
374      * - the calling contract must have an ETH balance of at least `value`.
375      * - the called Solidity function must be `payable`.
376      *
377      * _Available since v3.1._
378      */
379     function functionCallWithValue(
380         address target,
381         bytes memory data,
382         uint256 value
383     ) internal returns (bytes memory) {
384         return functionCallWithValue(target, data, value, 'Address: low-level call with value failed');
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
389      * with `errorMessage` as a fallback revert reason when `target` reverts.
390      *
391      * _Available since v3.1._
392      */
393     function functionCallWithValue(
394         address target,
395         bytes memory data,
396         uint256 value,
397         string memory errorMessage
398     ) internal returns (bytes memory) {
399         require(address(this).balance >= value, 'Address: insufficient balance for call');
400         return _functionCallWithValue(target, data, value, errorMessage);
401     }
402 
403     function _functionCallWithValue(
404         address target,
405         bytes memory data,
406         uint256 weiValue,
407         string memory errorMessage
408     ) private returns (bytes memory) {
409         require(isContract(target), 'Address: call to non-contract');
410 
411         // solhint-disable-next-line avoid-low-level-calls
412         (bool success, bytes memory returndata) = target.call{value: weiValue}(data);
413         if (success) {
414             return returndata;
415         } else {
416             // Look for revert reason and bubble it up if present
417             if (returndata.length > 0) {
418                 // The easiest way to bubble the revert reason is using memory via assembly
419 
420                 // solhint-disable-next-line no-inline-assembly
421                 assembly {
422                     let returndata_size := mload(returndata)
423                     revert(add(32, returndata), returndata_size)
424                 }
425             } else {
426                 revert(errorMessage);
427             }
428         }
429     }
430 }
431 
432 /**
433  * @dev Contract module which provides a basic access control mechanism, where
434  * there is an account (an owner) that can be granted exclusive access to
435  * specific functions.
436  *
437  * By default, the owner account will be the one that deploys the contract. This
438  * can later be changed with {transferOwnership}.
439  *
440  * This module is used through inheritance. It will make available the modifier
441  * `onlyOwner`, which can be applied to your functions to restrict their use to
442  * the owner.
443  */
444 contract Ownable is Context {
445     address private _owner;
446 
447     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
448 
449     /**
450      * @dev Initializes the contract setting the deployer as the initial owner.
451      */
452     constructor() internal {
453         address msgSender = _msgSender();
454         _owner = msgSender;
455         emit OwnershipTransferred(address(0), msgSender);
456     }
457 
458     /**
459      * @dev Returns the address of the current owner.
460      */
461     function owner() public view returns (address) {
462         return _owner;
463     }
464 
465     /**
466      * @dev Throws if called by any account other than the owner.
467      */
468     modifier onlyOwner() {
469         require(_owner == _msgSender(), 'Ownable: caller is not the owner');
470         _;
471     }
472 
473     /**
474      * @dev Leaves the contract without owner. It will not be possible to call
475      * `onlyOwner` functions anymore. Can only be called by the current owner.
476      *
477      * NOTE: Renouncing ownership will leave the contract without an owner,
478      * thereby removing any functionality that is only available to the owner.
479      */
480     function renounceOwnership() public virtual onlyOwner {
481         emit OwnershipTransferred(_owner, address(0));
482         _owner = address(0);
483     }
484 
485     /**
486      * @dev Transfers ownership of the contract to a new account (`newOwner`).
487      * Can only be called by the current owner.
488      */
489     function transferOwnership(address newOwner) public virtual onlyOwner {
490         require(newOwner != address(0), 'Ownable: new owner is the zero address');
491         emit OwnershipTransferred(_owner, newOwner);
492         _owner = newOwner;
493     }
494 }
495 
496 interface IUniswapV2Factory {
497     function createPair(address tokenA, address tokenB) external returns (address pair);
498 }
499 
500 interface IUniswapV2Pair {
501     function sync() external;
502 }
503 
504 interface IUniswapV2Router01 {
505     function factory() external pure returns (address);
506 
507     function WETH() external pure returns (address);
508 
509     function addLiquidity(
510         address tokenA,
511         address tokenB,
512         uint256 amountADesired,
513         uint256 amountBDesired,
514         uint256 amountAMin,
515         uint256 amountBMin,
516         address to,
517         uint256 deadline
518     )
519         external
520         returns (
521             uint256 amountA,
522             uint256 amountB,
523             uint256 liquidity
524         );
525 
526     function addLiquidityETH(
527         address token,
528         uint256 amountTokenDesired,
529         uint256 amountTokenMin,
530         uint256 amountETHMin,
531         address to,
532         uint256 deadline
533     )
534         external
535         payable
536         returns (
537             uint256 amountToken,
538             uint256 amountETH,
539             uint256 liquidity
540         );
541 }
542 
543 interface IUniswapV2Router02 is IUniswapV2Router01 {
544     function removeLiquidityETHSupportingFeeOnTransferTokens(
545         address token,
546         uint256 liquidity,
547         uint256 amountTokenMin,
548         uint256 amountETHMin,
549         address to,
550         uint256 deadline
551     ) external returns (uint256 amountETH);
552 
553     function swapExactTokensForETHSupportingFeeOnTransferTokens(
554         uint256 amountIn,
555         uint256 amountOutMin,
556         address[] calldata path,
557         address to,
558         uint256 deadline
559     ) external;
560 
561     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
562         uint256 amountIn,
563         uint256 amountOutMin,
564         address[] calldata path,
565         address to,
566         uint256 deadline
567     ) external;
568 
569     function swapExactETHForTokensSupportingFeeOnTransferTokens(
570         uint256 amountOutMin,
571         address[] calldata path,
572         address to,
573         uint256 deadline
574     ) external payable;
575 }
576 
577 pragma solidity ^0.6.0;
578 
579 abstract contract ReentrancyGuard {
580     uint256 private constant _NOT_ENTERED = 1;
581     uint256 private constant _ENTERED = 2;
582 
583     uint256 private _status;
584 
585     constructor() public {
586         _status = _NOT_ENTERED;
587     }
588 
589     modifier nonReentrant() {
590         require(_status != _ENTERED, 'ReentrancyGuard: reentrant call');
591         _status = _ENTERED;
592         _;
593         _status = _NOT_ENTERED;
594     }
595 
596     modifier isHuman() {
597         require(tx.origin == msg.sender, 'sorry humans only');
598         _;
599     }
600 }
601 
602 pragma solidity ^0.6.0;
603 
604 library TransferHelper {
605     function safeApprove(
606         address token,
607         address to,
608         uint256 value
609     ) internal {
610         // bytes4(keccak256(bytes('approve(address,uint256)')));
611         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
612         require(
613             success && (data.length == 0 || abi.decode(data, (bool))),
614             'TransferHelper::safeApprove: approve failed'
615         );
616     }
617 
618     function safeTransfer(
619         address token,
620         address to,
621         uint256 value
622     ) internal {
623         // bytes4(keccak256(bytes('transfer(address,uint256)')));
624         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
625         require(
626             success && (data.length == 0 || abi.decode(data, (bool))),
627             'TransferHelper::safeTransfer: transfer failed'
628         );
629     }
630 
631     function safeTransferFrom(
632         address token,
633         address from,
634         address to,
635         uint256 value
636     ) internal {
637         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
638         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
639         require(
640             success && (data.length == 0 || abi.decode(data, (bool))),
641             'TransferHelper::transferFrom: transferFrom failed'
642         );
643     }
644 
645     function safeTransferETH(address to, uint256 value) internal {
646         (bool success, ) = to.call{value: value}(new bytes(0));
647         require(success, 'TransferHelper::safeTransferETH: ETH transfer failed');
648     }
649 }
650 
651 interface IPinkAntiBot {
652   function setTokenOwner(address owner) external;
653 
654   function onPreTransferCheck(
655     address from,
656     address to,
657     uint256 amount
658   ) external;
659 }
660 
661 interface ITopHolderRewardDistributor {
662     function depositReward(uint256 amount) external;
663     function onTransfer(address sender, address recipient, uint256 amount) external;
664 }
665 
666 contract FALQOM is Context, IERC20, Ownable, ReentrancyGuard {
667     using SafeMath for uint256;
668     using Address for address;
669     using TransferHelper for address;
670 
671     string private _name = 'Shiba Hunter';
672     string private _symbol = 'FALQOM';
673     uint8 private _decimals = 9;
674 
675     mapping(address => uint256) internal _reflectionBalance;
676     mapping(address => uint256) internal _tokenBalance;
677     mapping(address => mapping(address => uint256)) internal _allowances;
678 
679     uint256 private constant MAX = ~uint256(0);
680     uint256 internal _tokenTotal = 100_000_000_000e9;
681     uint256 internal _reflectionTotal = (MAX - (MAX % _tokenTotal));
682 
683     mapping(address => bool) public isTaxless;
684     mapping(address => bool) internal _isExcluded;
685     address[] internal _excluded;
686 
687     uint256 public _feeDecimal = 2;
688     // index 0 = buy fee, index 1 = sell fee, index 2 = p2p fee
689     uint256[] public _taxFee;
690     uint256[] public _teamFee;
691     uint256[] public _marketingFee;
692 
693     uint256 internal _feeTotal;
694     uint256 internal _marketingFeeCollected;
695     uint256 internal _teamFeeCollected;
696 
697     bool public isFeeActive = false; // should be true
698     bool private inSwap;
699     bool public swapEnabled = true;
700 
701     uint256 public maxTxAmount = _tokenTotal.mul(5).div(1000); // 0.5%
702     uint256 public minTokensBeforeSwap = 1_000_000e9;
703 
704     address public marketingWallet;
705     address public teamWallet;
706 
707     IUniswapV2Router02 public router;
708     address public pair;
709 
710     event SwapUpdated(bool enabled);
711     event Swap(uint256 swaped, uint256 recieved);
712 
713     modifier lockTheSwap() {
714         inSwap = true;
715         _;
716         inSwap = false;
717     }
718 
719     constructor(address _router,address _owner,address _marketingWallet, address _teamWallet) public {
720         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(_router);
721         pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
722         router = _uniswapV2Router;
723         marketingWallet = _marketingWallet;
724         teamWallet = _teamWallet;
725         
726         isTaxless[_owner] = true;
727         isTaxless[teamWallet] = true;
728         isTaxless[marketingWallet] = true;
729         isTaxless[address(this)] = true;
730 
731         excludeAccount(address(pair));
732         excludeAccount(address(this));
733         excludeAccount(address(marketingWallet));
734         excludeAccount(address(teamWallet));
735         excludeAccount(address(address(0)));
736         excludeAccount(address(address(0x000000000000000000000000000000000000dEaD)));
737 
738         _reflectionBalance[_owner] = _reflectionTotal;
739         emit Transfer(address(0),_owner, _tokenTotal);
740 
741         _taxFee.push(300);
742         _taxFee.push(300);
743         _taxFee.push(300);
744 
745         _teamFee.push(100);
746         _teamFee.push(100);
747         _teamFee.push(100);
748 
749         _marketingFee.push(200);
750         _marketingFee.push(200);
751         _marketingFee.push(200);
752 
753         transferOwnership(_owner);
754     }
755 
756     function name() public view returns (string memory) {
757         return _name;
758     }
759 
760     function symbol() public view returns (string memory) {
761         return _symbol;
762     }
763 
764     function decimals() public view returns (uint8) {
765         return _decimals;
766     }
767 
768     function totalSupply() public view override returns (uint256) {
769         return _tokenTotal;
770     }
771 
772     function balanceOf(address account) public view override returns (uint256) {
773         if (_isExcluded[account]) return _tokenBalance[account];
774         return tokenFromReflection(_reflectionBalance[account]);
775     }
776 
777     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
778         _transfer(_msgSender(), recipient, amount);
779         return true;
780     }
781 
782     function allowance(address owner, address spender) public view override returns (uint256) {
783         return _allowances[owner][spender];
784     }
785 
786     function approve(address spender, uint256 amount) public override returns (bool) {
787         _approve(_msgSender(), spender, amount);
788         return true;
789     }
790 
791     function transferFrom(
792         address sender,
793         address recipient,
794         uint256 amount
795     ) public virtual override returns (bool) {
796         _transfer(sender, recipient, amount);
797 
798         _approve(
799             sender,
800             _msgSender(),
801             _allowances[sender][_msgSender()].sub(amount, 'ERC20: transfer amount exceeds allowance')
802         );
803         return true;
804     }
805 
806     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
807         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
808         return true;
809     }
810 
811     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
812         _approve(
813             _msgSender(),
814             spender,
815             _allowances[_msgSender()][spender].sub(subtractedValue, 'ERC20: decreased allowance below zero')
816         );
817         return true;
818     }
819 
820     function isExcluded(address account) public view returns (bool) {
821         return _isExcluded[account];
822     }
823 
824     function reflectionFromToken(uint256 tokenAmount) public view returns (uint256) {
825         require(tokenAmount <= _tokenTotal, 'Amount must be less than supply');
826         return tokenAmount.mul(_getReflectionRate());
827     }
828 
829     function tokenFromReflection(uint256 reflectionAmount) public view returns (uint256) {
830         require(reflectionAmount <= _reflectionTotal, 'Amount must be less than total reflections');
831         uint256 currentRate = _getReflectionRate();
832         return reflectionAmount.div(currentRate);
833     }
834 
835     function excludeAccount(address account) public onlyOwner {
836         require(account != address(router), 'ERC20: We can not exclude Uniswap router.');
837         require(!_isExcluded[account], 'ERC20: Account is already excluded');
838         if (_reflectionBalance[account] > 0) {
839             _tokenBalance[account] = tokenFromReflection(_reflectionBalance[account]);
840         }
841         _isExcluded[account] = true;
842         _excluded.push(account);
843     }
844 
845     function includeAccount(address account) external onlyOwner {
846         require(_isExcluded[account], 'ERC20: Account is already included');
847         for (uint256 i = 0; i < _excluded.length; i++) {
848             if (_excluded[i] == account) {
849                 _excluded[i] = _excluded[_excluded.length - 1];
850                 _tokenBalance[account] = 0;
851                 _isExcluded[account] = false;
852                 _excluded.pop();
853                 break;
854             }
855         }
856     }
857 
858     function _approve(
859         address owner,
860         address spender,
861         uint256 amount
862     ) private {
863         require(owner != address(0), 'ERC20: approve from the zero address');
864         require(spender != address(0), 'ERC20: approve to the zero address');
865 
866         _allowances[owner][spender] = amount;
867         emit Approval(owner, spender, amount);
868     }
869 
870     function _transfer(
871         address sender,
872         address recipient,
873         uint256 amount
874     ) private {
875         require(sender != address(0), 'ERC20: transfer from the zero address');
876         require(recipient != address(0), 'ERC20: transfer to the zero address');
877         require(amount > 0, 'Transfer amount must be greater than zero');
878 
879         require(isTaxless[sender] || isTaxless[recipient] || amount <= maxTxAmount, 'Max Transfer Limit Exceeds!');
880 
881         if (swapEnabled && !inSwap && sender != pair) {
882             swap();
883         }
884 
885         uint256 transferAmount = amount;
886         uint256 rate = _getReflectionRate();
887 
888         if (isFeeActive && !isTaxless[sender] && !isTaxless[recipient] && !inSwap) {
889             transferAmount = collectFee(sender, amount, rate, recipient == pair, sender != pair && recipient != pair);
890         }
891 
892         //transfer reflection
893         _reflectionBalance[sender] = _reflectionBalance[sender].sub(amount.mul(rate));
894         _reflectionBalance[recipient] = _reflectionBalance[recipient].add(transferAmount.mul(rate));
895 
896         //if any account belongs to the excludedAccount transfer token
897         if (_isExcluded[sender]) {
898             _tokenBalance[sender] = _tokenBalance[sender].sub(amount);
899         }
900         if (_isExcluded[recipient]) {
901             _tokenBalance[recipient] = _tokenBalance[recipient].add(transferAmount);
902         }
903 
904         emit Transfer(sender, recipient, transferAmount);
905     }
906 
907     function calculateFee(uint256 feeIndex, uint256 amount) internal returns(uint256, uint256) {
908         uint256 taxFee = amount.mul(_taxFee[feeIndex]).div(10**(_feeDecimal + 2));
909         uint256 marketingFee = amount.mul(_marketingFee[feeIndex]).div(10**(_feeDecimal + 2));
910         uint256 teamFee = amount.mul(_teamFee[feeIndex]).div(10**(_feeDecimal + 2));
911         
912         _marketingFeeCollected = _marketingFeeCollected.add(marketingFee);
913         _teamFeeCollected = _teamFeeCollected.add(teamFee);
914         return (taxFee, marketingFee.add(teamFee));
915     }
916 
917     function collectFee(
918         address account,
919         uint256 amount,
920         uint256 rate,
921         bool sell,
922         bool p2p
923     ) private returns (uint256) {
924         uint256 transferAmount = amount;
925 
926         (uint256 taxFee, uint256 otherFee) = calculateFee(p2p ? 2 : sell ? 1 : 0, amount);
927         if(otherFee != 0) 
928         {
929             transferAmount = transferAmount.sub(otherFee);
930             _reflectionBalance[address(this)] = _reflectionBalance[address(this)].add(otherFee.mul(rate));
931             if (_isExcluded[address(this)]) {
932                 _tokenBalance[address(this)] = _tokenBalance[address(this)].add(otherFee);
933             }
934             emit Transfer(account, address(this), otherFee);
935         }
936         if(taxFee != 0){
937             _reflectionTotal = _reflectionTotal.sub(taxFee.mul(rate));
938         }
939         _feeTotal = _feeTotal.add(taxFee).add(otherFee);
940         return transferAmount;
941     }
942 
943     function swap() private lockTheSwap {
944         uint256 totalFee = _teamFeeCollected.add(_marketingFeeCollected);
945 
946         if(minTokensBeforeSwap > totalFee) return;
947 
948         address[] memory sellPath = new address[](2);
949         sellPath[0] = address(this);
950         sellPath[1] = router.WETH();       
951 
952         uint256 balanceBefore = address(this).balance;
953 
954         _approve(address(this), address(router), totalFee);
955         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
956             totalFee,
957             0,
958             sellPath,
959             address(this),
960             block.timestamp
961         );
962 
963         uint256 amountFee = address(this).balance.sub(balanceBefore);
964         
965         uint256 amountMarketing = amountFee.mul(_marketingFeeCollected).div(totalFee);
966         if(amountMarketing > 0) payable(marketingWallet).transfer(amountMarketing);
967 
968         uint256 amountTeam = address(this).balance;
969         if(amountTeam > 0) payable(marketingWallet).transfer(address(this).balance);
970         
971         _marketingFeeCollected = 0;
972         _teamFeeCollected = 0;
973 
974         emit Swap(totalFee, amountFee);
975     }
976 
977     function _getReflectionRate() private view returns (uint256) {
978         uint256 reflectionSupply = _reflectionTotal;
979         uint256 tokenSupply = _tokenTotal;
980         for (uint256 i = 0; i < _excluded.length; i++) {
981             if (_reflectionBalance[_excluded[i]] > reflectionSupply || _tokenBalance[_excluded[i]] > tokenSupply)
982                 return _reflectionTotal.div(_tokenTotal);
983             reflectionSupply = reflectionSupply.sub(_reflectionBalance[_excluded[i]]);
984             tokenSupply = tokenSupply.sub(_tokenBalance[_excluded[i]]);
985         }
986         if (reflectionSupply < _reflectionTotal.div(_tokenTotal)) return _reflectionTotal.div(_tokenTotal);
987         return reflectionSupply.div(tokenSupply);
988     }
989 
990     function setPairRouterRewardToken(address _pair, IUniswapV2Router02 _router) external onlyOwner {
991         pair = _pair;
992         router = _router;
993     }
994 
995     function setTaxless(address account, bool value) external onlyOwner {
996         isTaxless[account] = value;
997     }
998 
999     function setSwapEnabled(bool enabled) external onlyOwner {
1000         swapEnabled = enabled;
1001         SwapUpdated(enabled);
1002     }
1003 
1004     function setFeeActive(bool value) external onlyOwner {
1005         isFeeActive = value;
1006     }
1007 
1008     function setTaxFee(uint256 buy, uint256 sell, uint256 p2p) external onlyOwner {
1009         _taxFee[0] = buy;
1010         _taxFee[1] = sell;
1011         _taxFee[2] = p2p;
1012     }
1013 
1014 
1015     function setTeamFee(uint256 buy, uint256 sell, uint256 p2p) external onlyOwner {
1016         _teamFee[0] = buy;
1017         _teamFee[1] = sell;
1018         _teamFee[2] = p2p;
1019     }
1020 
1021     function setMarketingFee(uint256 buy, uint256 sell, uint256 p2p) external onlyOwner {
1022         _marketingFee[0] = buy;
1023         _marketingFee[1] = sell;
1024         _marketingFee[2] = p2p;
1025     }
1026 
1027     function setMarketingWallet(address wallet) external onlyOwner {
1028         marketingWallet = wallet;
1029     }
1030 
1031     function setTeamWallet(address wallet)  external onlyOwner {
1032         teamWallet = wallet;
1033     }
1034 
1035     function setMaxTxAmount(uint256 percentage) external onlyOwner {
1036         maxTxAmount = _tokenTotal.mul(percentage).div(10000);
1037     }
1038 
1039     function setMinTokensBeforeSwap(uint256 amount) external onlyOwner {
1040         minTokensBeforeSwap = amount;
1041     }
1042 
1043     receive() external payable {}
1044 }