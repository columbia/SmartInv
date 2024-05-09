1 // SPDX-License-Identifier: MIT
2 // @dev Telegram: defi_guru
3 pragma solidity ^0.6.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal virtual view returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal virtual view returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 /**
27  * @dev Interface of the ERC20 standard as defined in the EIP.
28  */
29 interface IERC20 {
30     /**
31      * @dev Returns the amount of tokens in existence.
32      */
33     function totalSupply() external view returns (uint256);
34 
35     /**
36      * @dev Returns the amount of tokens owned by `account`.
37      */
38     function balanceOf(address account) external view returns (uint256);
39 
40     /**
41      * @dev Moves `amount` tokens from the caller's account to `recipient`.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * Emits a {Transfer} event.
46      */
47     function transfer(address recipient, uint256 amount)
48         external
49         returns (bool);
50 
51     /**
52      * @dev Returns the remaining number of tokens that `spender` will be
53      * allowed to spend on behalf of `owner` through {transferFrom}. This is
54      * zero by default.
55      *
56      * This value changes when {approve} or {transferFrom} are called.
57      */
58     function allowance(address owner, address spender)
59         external
60         view
61         returns (uint256);
62 
63     /**
64      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * IMPORTANT: Beware that changing an allowance with this method brings the risk
69      * that someone may use both the old and the new allowance by unfortunate
70      * transaction ordering. One possible solution to mitigate this race
71      * condition is to first reduce the spender's allowance to 0 and set the
72      * desired value afterwards:
73      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
74      *
75      * Emits an {Approval} event.
76      */
77     function approve(address spender, uint256 amount) external returns (bool);
78 
79     /**
80      * @dev Moves `amount` tokens from `sender` to `recipient` using the
81      * allowance mechanism. `amount` is then deducted from the caller's
82      * allowance.
83      *
84      * Returns a boolean value indicating whether the operation succeeded.
85      *
86      * Emits a {Transfer} event.
87      */
88     function transferFrom(
89         address sender,
90         address recipient,
91         uint256 amount
92     ) external returns (bool);
93 
94     /**
95      * @dev Emitted when `value` tokens are moved from one account (`from`) to
96      * another (`to`).
97      *
98      * Note that `value` may be zero.
99      */
100     event Transfer(address indexed from, address indexed to, uint256 value);
101 
102     /**
103      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
104      * a call to {approve}. `value` is the new allowance.
105      */
106     event Approval(
107         address indexed owner,
108         address indexed spender,
109         uint256 value
110     );
111 }
112 
113 /**
114  * @dev Wrappers over Solidity's arithmetic operations with added overflow
115  * checks.
116  *
117  * Arithmetic operations in Solidity wrap on overflow. This can easily result
118  * in bugs, because programmers usually assume that an overflow raises an
119  * error, which is the standard behavior in high level programming languages.
120  * `SafeMath` restores this intuition by reverting the transaction when an
121  * operation overflows.
122  *
123  * Using this library instead of the unchecked operations eliminates an entire
124  * class of bugs, so it's recommended to use it always.
125  */
126 library SafeMath {
127     /**
128      * @dev Returns the addition of two unsigned integers, reverting on
129      * overflow.
130      *
131      * Counterpart to Solidity's `+` operator.
132      *
133      * Requirements:
134      *
135      * - Addition cannot overflow.
136      */
137     function add(uint256 a, uint256 b) internal pure returns (uint256) {
138         uint256 c = a + b;
139         require(c >= a, "SafeMath: addition overflow");
140 
141         return c;
142     }
143 
144     /**
145      * @dev Returns the subtraction of two unsigned integers, reverting on
146      * overflow (when the result is negative).
147      *
148      * Counterpart to Solidity's `-` operator.
149      *
150      * Requirements:
151      *
152      * - Subtraction cannot overflow.
153      */
154     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
155         return sub(a, b, "SafeMath: subtraction overflow");
156     }
157 
158     /**
159      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
160      * overflow (when the result is negative).
161      *
162      * Counterpart to Solidity's `-` operator.
163      *
164      * Requirements:
165      *
166      * - Subtraction cannot overflow.
167      */
168     function sub(
169         uint256 a,
170         uint256 b,
171         string memory errorMessage
172     ) internal pure returns (uint256) {
173         require(b <= a, errorMessage);
174         uint256 c = a - b;
175 
176         return c;
177     }
178 
179     /**
180      * @dev Returns the multiplication of two unsigned integers, reverting on
181      * overflow.
182      *
183      * Counterpart to Solidity's `*` operator.
184      *
185      * Requirements:
186      *
187      * - Multiplication cannot overflow.
188      */
189     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
190         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
191         // benefit is lost if 'b' is also tested.
192         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
193         if (a == 0) {
194             return 0;
195         }
196 
197         uint256 c = a * b;
198         require(c / a == b, "SafeMath: multiplication overflow");
199 
200         return c;
201     }
202 
203     /**
204      * @dev Returns the integer division of two unsigned integers. Reverts on
205      * division by zero. The result is rounded towards zero.
206      *
207      * Counterpart to Solidity's `/` operator. Note: this function uses a
208      * `revert` opcode (which leaves remaining gas untouched) while Solidity
209      * uses an invalid opcode to revert (consuming all remaining gas).
210      *
211      * Requirements:
212      *
213      * - The divisor cannot be zero.
214      */
215     function div(uint256 a, uint256 b) internal pure returns (uint256) {
216         return div(a, b, "SafeMath: division by zero");
217     }
218 
219     /**
220      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
221      * division by zero. The result is rounded towards zero.
222      *
223      * Counterpart to Solidity's `/` operator. Note: this function uses a
224      * `revert` opcode (which leaves remaining gas untouched) while Solidity
225      * uses an invalid opcode to revert (consuming all remaining gas).
226      *
227      * Requirements:
228      *
229      * - The divisor cannot be zero.
230      */
231     function div(
232         uint256 a,
233         uint256 b,
234         string memory errorMessage
235     ) internal pure returns (uint256) {
236         require(b > 0, errorMessage);
237         uint256 c = a / b;
238         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
239 
240         return c;
241     }
242 
243     /**
244      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
245      * Reverts when dividing by zero.
246      *
247      * Counterpart to Solidity's `%` operator. This function uses a `revert`
248      * opcode (which leaves remaining gas untouched) while Solidity uses an
249      * invalid opcode to revert (consuming all remaining gas).
250      *
251      * Requirements:
252      *
253      * - The divisor cannot be zero.
254      */
255     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
256         return mod(a, b, "SafeMath: modulo by zero");
257     }
258 
259     /**
260      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
261      * Reverts with custom message when dividing by zero.
262      *
263      * Counterpart to Solidity's `%` operator. This function uses a `revert`
264      * opcode (which leaves remaining gas untouched) while Solidity uses an
265      * invalid opcode to revert (consuming all remaining gas).
266      *
267      * Requirements:
268      *
269      * - The divisor cannot be zero.
270      */
271     function mod(
272         uint256 a,
273         uint256 b,
274         string memory errorMessage
275     ) internal pure returns (uint256) {
276         require(b != 0, errorMessage);
277         return a % b;
278     }
279 }
280 
281 /**
282  * @dev Collection of functions related to the address type
283  */
284 library Address {
285     /**
286      * @dev Returns true if `account` is a contract.
287      *
288      * [IMPORTANT]
289      * ====
290      * It is unsafe to assume that an address for which this function returns
291      * false is an externally-owned account (EOA) and not a contract.
292      *
293      * Among others, `isContract` will return false for the following
294      * types of addresses:
295      *
296      *  - an externally-owned account
297      *  - a contract in construction
298      *  - an address where a contract will be created
299      *  - an address where a contract lived, but was destroyed
300      * ====
301      */
302     function isContract(address account) internal view returns (bool) {
303         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
304         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
305         // for accounts without code, i.e. `keccak256('')`
306         bytes32 codehash;
307 
308 
309             bytes32 accountHash
310          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
311         // solhint-disable-next-line no-inline-assembly
312         assembly {
313             codehash := extcodehash(account)
314         }
315         return (codehash != accountHash && codehash != 0x0);
316     }
317 
318     /**
319      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
320      * `recipient`, forwarding all available gas and reverting on errors.
321      *
322      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
323      * of certain opcodes, possibly making contracts go over the 2300 gas limit
324      * imposed by `transfer`, making them unable to receive funds via
325      * `transfer`. {sendValue} removes this limitation.
326      *
327      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
328      *
329      * IMPORTANT: because control is transferred to `recipient`, care must be
330      * taken to not create reentrancy vulnerabilities. Consider using
331      * {ReentrancyGuard} or the
332      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
333      */
334     function sendValue(address payable recipient, uint256 amount) internal {
335         require(
336             address(this).balance >= amount,
337             "Address: insufficient balance"
338         );
339 
340         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
341         (bool success, ) = recipient.call{value: amount}("");
342         require(
343             success,
344             "Address: unable to send value, recipient may have reverted"
345         );
346     }
347 
348     /**
349      * @dev Performs a Solidity function call using a low level `call`. A
350      * plain`call` is an unsafe replacement for a function call: use this
351      * function instead.
352      *
353      * If `target` reverts with a revert reason, it is bubbled up by this
354      * function (like regular Solidity function calls).
355      *
356      * Returns the raw returned data. To convert to the expected return value,
357      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
358      *
359      * Requirements:
360      *
361      * - `target` must be a contract.
362      * - calling `target` with `data` must not revert.
363      *
364      * _Available since v3.1._
365      */
366     function functionCall(address target, bytes memory data)
367         internal
368         returns (bytes memory)
369     {
370         return functionCall(target, data, "Address: low-level call failed");
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
375      * `errorMessage` as a fallback revert reason when `target` reverts.
376      *
377      * _Available since v3.1._
378      */
379     function functionCall(
380         address target,
381         bytes memory data,
382         string memory errorMessage
383     ) internal returns (bytes memory) {
384         return _functionCallWithValue(target, data, 0, errorMessage);
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
389      * but also transferring `value` wei to `target`.
390      *
391      * Requirements:
392      *
393      * - the calling contract must have an ETH balance of at least `value`.
394      * - the called Solidity function must be `payable`.
395      *
396      * _Available since v3.1._
397      */
398     function functionCallWithValue(
399         address target,
400         bytes memory data,
401         uint256 value
402     ) internal returns (bytes memory) {
403         return
404             functionCallWithValue(
405                 target,
406                 data,
407                 value,
408                 "Address: low-level call with value failed"
409             );
410     }
411 
412     /**
413      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
414      * with `errorMessage` as a fallback revert reason when `target` reverts.
415      *
416      * _Available since v3.1._
417      */
418     function functionCallWithValue(
419         address target,
420         bytes memory data,
421         uint256 value,
422         string memory errorMessage
423     ) internal returns (bytes memory) {
424         require(
425             address(this).balance >= value,
426             "Address: insufficient balance for call"
427         );
428         return _functionCallWithValue(target, data, value, errorMessage);
429     }
430 
431     function _functionCallWithValue(
432         address target,
433         bytes memory data,
434         uint256 weiValue,
435         string memory errorMessage
436     ) private returns (bytes memory) {
437         require(isContract(target), "Address: call to non-contract");
438 
439         // solhint-disable-next-line avoid-low-level-calls
440         (bool success, bytes memory returndata) = target.call{value: weiValue}(
441             data
442         );
443         if (success) {
444             return returndata;
445         } else {
446             // Look for revert reason and bubble it up if present
447             if (returndata.length > 0) {
448                 // The easiest way to bubble the revert reason is using memory via assembly
449 
450                 // solhint-disable-next-line no-inline-assembly
451                 assembly {
452                     let returndata_size := mload(returndata)
453                     revert(add(32, returndata), returndata_size)
454                 }
455             } else {
456                 revert(errorMessage);
457             }
458         }
459     }
460 }
461 
462 /**
463  * @dev Contract module which provides a basic access control mechanism, where
464  * there is an account (an owner) that can be granted exclusive access to
465  * specific functions.
466  *
467  * By default, the owner account will be the one that deploys the contract. This
468  * can later be changed with {transferOwnership}.
469  *
470  * This module is used through inheritance. It will make available the modifier
471  * `onlyOwner`, which can be applied to your functions to restrict their use to
472  * the owner.
473  */
474 contract Ownable is Context {
475     address private _owner;
476 
477     event OwnershipTransferred(
478         address indexed previousOwner,
479         address indexed newOwner
480     );
481 
482     /**
483      * @dev Initializes the contract setting the deployer as the initial owner.
484      */
485     constructor() internal {
486         address msgSender = _msgSender();
487         _owner = msgSender;
488         emit OwnershipTransferred(address(0), msgSender);
489     }
490 
491     /**
492      * @dev Returns the address of the current owner.
493      */
494     function owner() public view returns (address) {
495         return _owner;
496     }
497 
498     /**
499      * @dev Throws if called by any account other than the owner.
500      */
501     modifier onlyOwner() {
502         require(_owner == _msgSender(), "Ownable: caller is not the owner");
503         _;
504     }
505 
506     /**
507      * @dev Leaves the contract without owner. It will not be possible to call
508      * `onlyOwner` functions anymore. Can only be called by the current owner.
509      *
510      * NOTE: Renouncing ownership will leave the contract without an owner,
511      * thereby removing any functionality that is only available to the owner.
512      */
513     function renounceOwnership() public virtual onlyOwner {
514         emit OwnershipTransferred(_owner, address(0));
515         _owner = address(0);
516     }
517 
518     /**
519      * @dev Transfers ownership of the contract to a new account (`newOwner`).
520      * Can only be called by the current owner.
521      */
522     function transferOwnership(address newOwner) public virtual onlyOwner {
523         require(
524             newOwner != address(0),
525             "Ownable: new owner is the zero address"
526         );
527         emit OwnershipTransferred(_owner, newOwner);
528         _owner = newOwner;
529     }
530 }
531 
532 
533 interface IUniswapV2Factory {
534     function createPair(address tokenA, address tokenB) external returns (address pair);
535 }
536 
537 interface IUniswapV2Pair {
538     function sync() external;
539 }
540 
541 interface IUniswapV2Router01 {
542     function factory() external pure returns (address);
543     function WETH() external pure returns (address);
544     function addLiquidity(
545         address tokenA,
546         address tokenB,
547         uint amountADesired,
548         uint amountBDesired,
549         uint amountAMin,
550         uint amountBMin,
551         address to,
552         uint deadline
553     ) external returns (uint amountA, uint amountB, uint liquidity);
554     function addLiquidityETH(
555         address token,
556         uint amountTokenDesired,
557         uint amountTokenMin,
558         uint amountETHMin,
559         address to,
560         uint deadline
561     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
562 }
563 
564 interface IUniswapV2Router02 is IUniswapV2Router01 {
565     function removeLiquidityETHSupportingFeeOnTransferTokens(
566       address token,
567       uint liquidity,
568       uint amountTokenMin,
569       uint amountETHMin,
570       address to,
571       uint deadline
572     ) external returns (uint amountETH);
573     function swapExactTokensForETHSupportingFeeOnTransferTokens(
574         uint amountIn,
575         uint amountOutMin,
576         address[] calldata path,
577         address to,
578         uint deadline
579     ) external;
580     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
581         uint amountIn,
582         uint amountOutMin,
583         address[] calldata path,
584         address to,
585         uint deadline
586     ) external;
587     function swapExactETHForTokensSupportingFeeOnTransferTokens(
588         uint amountOutMin,
589         address[] calldata path,
590         address to,
591         uint deadline
592     ) external payable;
593 }
594 
595 library SafeCast {
596 
597     function toUint128(uint256 value) internal pure returns (uint128) {
598         require(value < 2**128, "SafeCast: value doesn\'t fit in 128 bits");
599         return uint128(value);
600     }
601 
602     function toUint64(uint256 value) internal pure returns (uint64) {
603         require(value < 2**64, "SafeCast: value doesn\'t fit in 64 bits");
604         return uint64(value);
605     }
606 
607     function toUint32(uint256 value) internal pure returns (uint32) {
608         require(value < 2**32, "SafeCast: value doesn\'t fit in 32 bits");
609         return uint32(value);
610     }
611 
612     function toUint16(uint256 value) internal pure returns (uint16) {
613         require(value < 2**16, "SafeCast: value doesn\'t fit in 16 bits");
614         return uint16(value);
615     }
616 
617     function toUint8(uint256 value) internal pure returns (uint8) {
618         require(value < 2**8, "SafeCast: value doesn\'t fit in 8 bits");
619         return uint8(value);
620     }
621     
622     function toUint256(int256 value) internal pure returns (uint256) {
623         require(value >= 0, "SafeCast: value must be positive");
624         return uint256(value);
625     }
626 
627     function toInt256(uint256 value) internal pure returns (int256) {
628         require(value < 2**255, "SafeCast: value doesn't fit in an int256");
629         return int256(value);
630     }
631 }
632 
633 contract BitSafe is Context, IERC20, Ownable {
634     using SafeMath for uint256;
635     using Address for address;
636     using SafeCast for int256;
637     
638     string private _name = "BitSafe";
639     string private _symbol = "SAFE";
640     uint8 private _decimals = 5;
641 
642     mapping(address => uint256) internal _reflectionBalance;
643     mapping(address => uint256) internal _tokenBalance;
644     mapping(address => mapping(address => uint256)) internal _allowances;
645 
646     uint256 private constant MAX = ~uint256(0);
647     uint256 internal _tokenTotal = 10_000_000_000e5;
648     uint256 internal _reflectionTotal = (MAX - (MAX % _tokenTotal));
649 
650     mapping(address => bool) isTaxless;
651     mapping(address => bool) internal _isExcluded;
652     address[] internal _excluded;
653     
654     uint256 private constant RATE_PRECISION = 10 ** 5;
655     
656     //all fees
657     uint256 public _feeDecimal = 2;
658     uint256 public _taxFee = 400;
659     uint256 public _liquidityFee = 500;
660    
661     uint256 public _taxFeeTotal;
662     uint256 public _burnFeeTotal;
663     uint256 public _liquidityFeeTotal;
664 
665     bool private inSwapAndLiquify;
666     bool public swapAndLiquifyEnabled = true;
667     bool public isFeeActive = false; // should be true
668     
669     uint256 public maxTxAmount = _tokenTotal;// no limit
670     uint256 public minTokensBeforeSwap = 100_000e5;
671 
672     IUniswapV2Router02 public  uniswapV2Router;
673     address public  uniswapV2Pair;
674     
675     event SwapAndLiquifyEnabledUpdated(bool enabled);
676     event SwapAndLiquify(uint256 tokensSwapped,uint256 ethReceived, uint256 tokensIntoLiqudity);
677 
678     modifier lockTheSwap {
679         inSwapAndLiquify = true;
680         _;
681         inSwapAndLiquify = false;
682     }
683 
684     constructor() public {
685         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // Uniswap Router For Ethereum
686         // IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F); // Pancake Router V1 for BSC
687         // IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E); // Pancake Router V2 for BSC
688         
689         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
690             .createPair(address(this), _uniswapV2Router.WETH());
691             
692         uniswapV2Router = _uniswapV2Router;
693         
694         address _owner = 0xe6d8Ee28600AD59999028009Fc2055789152d882;
695         
696         isTaxless[_owner] = true;
697         isTaxless[address(this)] = true;
698 
699         _reflectionBalance[_owner] = _reflectionTotal;
700         emit Transfer(address(0), _owner, _tokenTotal);
701     }
702     
703     
704     function distribute(int256 supplyDelta)
705         onlyOwner
706         external
707     {
708         if (supplyDelta == 0) {
709             return;
710         }
711         
712         uint256 uSupplyDelta = (supplyDelta < 0 ? -supplyDelta : supplyDelta).toUint256();
713         uint256 rate = uSupplyDelta.mul(RATE_PRECISION).div(_tokenTotal);
714         uint256 multiplier;
715         
716         if (supplyDelta < 0) {
717             multiplier = RATE_PRECISION.sub(rate);
718         } else {
719             multiplier = RATE_PRECISION.add(rate);
720         }
721         
722         if (supplyDelta < 0) {
723             _tokenTotal = _tokenTotal.sub(uSupplyDelta);
724         } else {
725             _tokenTotal = _tokenTotal.add(uSupplyDelta);
726         }
727         
728         if (_tokenTotal > MAX) {
729             _tokenTotal = MAX;
730         }
731         
732         for (uint256 i = 0; i < _excluded.length; i++) {
733             if(_tokenBalance[_excluded[i]] > 0) {
734                 _tokenBalance[_excluded[i]] = _tokenBalance[_excluded[i]].mul(multiplier).div(RATE_PRECISION);
735             }
736         }
737        
738         IUniswapV2Pair(uniswapV2Pair).sync();
739        
740         return;
741     }
742     
743     
744     function name() public view returns (string memory) {
745         return _name;
746     }
747 
748     function symbol() public view returns (string memory) {
749         return _symbol;
750     }
751 
752     function decimals() public view returns (uint8) {
753         return _decimals;
754     }
755 
756     function totalSupply() public override view returns (uint256) {
757         return _tokenTotal;
758     }
759 
760     function balanceOf(address account) public override view returns (uint256) {
761         if (_isExcluded[account]) return _tokenBalance[account];
762         return tokenFromReflection(_reflectionBalance[account]);
763     }
764 
765     function transfer(address recipient, uint256 amount)
766         public
767         override
768         virtual
769         returns (bool)
770     {
771        _transfer(_msgSender(),recipient,amount);
772         return true;
773     }
774 
775     function allowance(address owner, address spender)
776         public
777         override
778         view
779         returns (uint256)
780     {
781         return _allowances[owner][spender];
782     }
783 
784     function approve(address spender, uint256 amount)
785         public
786         override
787         returns (bool)
788     {
789         _approve(_msgSender(), spender, amount);
790         return true;
791     }
792 
793     function transferFrom(
794         address sender,
795         address recipient,
796         uint256 amount
797     ) public override virtual returns (bool) {
798         _transfer(sender,recipient,amount);
799                
800         _approve(sender,_msgSender(),_allowances[sender][_msgSender()].sub( amount,"ERC20: transfer amount exceeds allowance"));
801         return true;
802     }
803 
804     function increaseAllowance(address spender, uint256 addedValue)
805         public
806         virtual
807         returns (bool)
808     {
809         _approve(
810             _msgSender(),
811             spender,
812             _allowances[_msgSender()][spender].add(addedValue)
813         );
814         return true;
815     }
816 
817     function decreaseAllowance(address spender, uint256 subtractedValue)
818         public
819         virtual
820         returns (bool)
821     {
822         _approve(
823             _msgSender(),
824             spender,
825             _allowances[_msgSender()][spender].sub(
826                 subtractedValue,
827                 "ERC20: decreased allowance below zero"
828             )
829         );
830         return true;
831     }
832 
833     function isExcluded(address account) public view returns (bool) {
834         return _isExcluded[account];
835     }
836 
837     function reflectionFromToken(uint256 tokenAmount, bool deductTransferFee)
838         public
839         view
840         returns (uint256)
841     {
842         require(tokenAmount <= _tokenTotal, "Amount must be less than supply");
843         if (!deductTransferFee) {
844             return tokenAmount.mul(_getReflectionRate());
845         } else {
846             return
847                 tokenAmount.sub(tokenAmount.mul(_taxFee).div(10** _feeDecimal + 2)).mul(
848                     _getReflectionRate()
849                 );
850         }
851     }
852 
853     function tokenFromReflection(uint256 reflectionAmount)
854         public
855         view
856         returns (uint256)
857     {
858         require(
859             reflectionAmount <= _reflectionTotal,
860             "Amount must be less than total reflections"
861         );
862         uint256 currentRate = _getReflectionRate();
863         return reflectionAmount.div(currentRate);
864     }
865 
866     function excludeAccount(address account) external onlyOwner() {
867         require(
868             account != address(uniswapV2Router),
869             "TOKEN: We can not exclude Uniswap router."
870         );
871         
872         require(!_isExcluded[account], "TOKEN: Account is already excluded");
873         if (_reflectionBalance[account] > 0) {
874             _tokenBalance[account] = tokenFromReflection(
875                 _reflectionBalance[account]
876             );
877         }
878         _isExcluded[account] = true;
879         _excluded.push(account);
880     }
881 
882     function includeAccount(address account) external onlyOwner() {
883         require(_isExcluded[account], "TOKEN: Account is already included");
884         for (uint256 i = 0; i < _excluded.length; i++) {
885             if (_excluded[i] == account) {
886                 _excluded[i] = _excluded[_excluded.length - 1];
887                 _tokenBalance[account] = 0;
888                 _isExcluded[account] = false;
889                 _excluded.pop();
890                 break;
891             }
892         }
893     }
894 
895     function _approve(
896         address owner,
897         address spender,
898         uint256 amount
899     ) private {
900         require(owner != address(0), "ERC20: approve from the zero address");
901         require(spender != address(0), "ERC20: approve to the zero address");
902 
903         _allowances[owner][spender] = amount;
904         emit Approval(owner, spender, amount);
905     }
906 
907     function _transfer(
908         address sender,
909         address recipient,
910         uint256 amount
911     ) private {
912         require(sender != address(0), "ERC20: transfer from the zero address");
913         require(recipient != address(0), "ERC20: transfer to the zero address");
914         require(amount > 0, "Transfer amount must be greater than zero");
915         
916         require(maxTxAmount >= amount, "Max Transfer Limit Exceeds!");
917         
918         //swapAndLiquify
919         uint256 contractTokenBalance = balanceOf(address(this));
920         bool overMinTokenBalance = contractTokenBalance >= minTokensBeforeSwap;
921         if (!inSwapAndLiquify && overMinTokenBalance && sender != uniswapV2Pair && swapAndLiquifyEnabled) {
922             swapAndLiquify(contractTokenBalance);
923         }
924             
925         uint256 transferAmount = amount;
926         uint256 rate = _getReflectionRate();
927 
928         if(isFeeActive && !isTaxless[_msgSender()] && !isTaxless[recipient] && !inSwapAndLiquify){
929             transferAmount = collectFee(sender,amount,rate);
930         }
931 
932         //transfer reflection
933         _reflectionBalance[sender] = _reflectionBalance[sender].sub(amount.mul(rate));
934         _reflectionBalance[recipient] = _reflectionBalance[recipient].add(transferAmount.mul(rate));
935 
936         //if any account belongs to the excludedAccount transfer token
937         if (_isExcluded[sender]) {
938             _tokenBalance[sender] = _tokenBalance[sender].sub(amount);
939         }
940         if (_isExcluded[recipient]) {
941             _tokenBalance[recipient] = _tokenBalance[recipient].add(transferAmount);
942         }
943 
944         emit Transfer(sender, recipient, transferAmount);
945     }
946     
947     function collectFee(address account, uint256 amount, uint256 rate) private returns (uint256) {
948         uint256 transferAmount = amount;
949         
950         //tax fee
951         if(_taxFee != 0){
952             uint256 taxFee = amount.mul(_taxFee).div(10**(_feeDecimal + 2));
953             transferAmount = transferAmount.sub(taxFee);
954             _reflectionTotal = _reflectionTotal.sub(taxFee.mul(rate));
955             _taxFeeTotal = _taxFeeTotal.add(taxFee);
956         }
957       
958         //take liquidity fee
959         if(_liquidityFee != 0){
960             uint256 liquidityFee = amount.mul(_liquidityFee).div(10**(_feeDecimal + 2));
961             transferAmount = transferAmount.sub(liquidityFee);
962             _reflectionBalance[address(this)] = _reflectionBalance[address(this)].add(liquidityFee.mul(rate));
963             if (_isExcluded[address(this)]) {
964                 _tokenBalance[address(this)] = _tokenBalance[address(this)].add(liquidityFee);
965             }
966             _liquidityFeeTotal = _liquidityFeeTotal.add(liquidityFee);
967             emit Transfer(account,address(this),liquidityFee);
968         }
969 
970         return transferAmount;
971     }
972 
973     function _getReflectionRate() private view returns (uint256) {
974         uint256 reflectionSupply = _reflectionTotal;
975         uint256 tokenSupply = _tokenTotal;
976         for (uint256 i = 0; i < _excluded.length; i++) {
977             if (
978                 _reflectionBalance[_excluded[i]] > reflectionSupply ||
979                 _tokenBalance[_excluded[i]] > tokenSupply
980             ) return _reflectionTotal.div(_tokenTotal);
981             reflectionSupply = reflectionSupply.sub(
982                 _reflectionBalance[_excluded[i]]
983             );
984             tokenSupply = tokenSupply.sub(_tokenBalance[_excluded[i]]);
985         }
986         if (reflectionSupply < _reflectionTotal.div(_tokenTotal))
987             return _reflectionTotal.div(_tokenTotal);
988         return reflectionSupply.div(tokenSupply);
989     }
990     
991      function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
992          if(contractTokenBalance > maxTxAmount)
993             contractTokenBalance = maxTxAmount;
994             
995         // split the contract balance into halves
996         uint256 half = contractTokenBalance.div(2);
997         uint256 otherHalf = contractTokenBalance.sub(half);
998 
999         // capture the contract's current ETH balance.
1000         // this is so that we can capture exactly the amount of ETH that the
1001         // swap creates, and not make the liquidity event include any ETH that
1002         // has been manually sent to the contract
1003         uint256 initialBalance = address(this).balance;
1004 
1005         // swap tokens for ETH
1006         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1007 
1008         // how much ETH did we just swap into?
1009         uint256 newBalance = address(this).balance.sub(initialBalance);
1010 
1011         // add liquidity to uniswap
1012         addLiquidity(otherHalf, newBalance);
1013         
1014         emit SwapAndLiquify(half, newBalance, otherHalf);
1015     }
1016 
1017     function swapTokensForEth(uint256 tokenAmount) private {
1018         // generate the uniswap pair path of token -> weth
1019         address[] memory path = new address[](2);
1020         path[0] = address(this);
1021         path[1] = uniswapV2Router.WETH();
1022 
1023         _approve(address(this), address(uniswapV2Router), tokenAmount);
1024 
1025         // make the swap
1026         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1027             tokenAmount,
1028             0, // accept any amount of ETH
1029             path,
1030             address(this),
1031             block.timestamp
1032         );
1033     }
1034    
1035     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1036         // approve token transfer to cover all possible scenarios
1037         _approve(address(this), address(uniswapV2Router), tokenAmount);
1038 
1039         // add the liquidity
1040         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1041             address(this),
1042             tokenAmount,
1043             0, // slippage is unavoidable
1044             0, // slippage is unavoidable
1045             owner(),
1046             block.timestamp
1047         );
1048     }
1049 
1050     function setTaxless(address account, bool value) external onlyOwner {
1051         isTaxless[account] = value;
1052     }
1053     
1054     function setSwapAndLiquifyEnabled(bool enabled) external onlyOwner {
1055         swapAndLiquifyEnabled = enabled;
1056         SwapAndLiquifyEnabledUpdated(enabled);
1057     }
1058     
1059     function setFeeActive(bool value) external onlyOwner {
1060         isFeeActive = value;
1061     }
1062     
1063     function setTaxFee(uint256 fee) external onlyOwner {
1064         _taxFee = fee;
1065     }
1066     
1067     function setLiquidityFee(uint256 fee) external onlyOwner {
1068         _liquidityFee = fee;
1069     }
1070     
1071     function setMaxTxAmount(uint256 amount) external onlyOwner {
1072         maxTxAmount = amount;
1073     }
1074     
1075     function setMinTokensBeforeSwap(uint256 amount) external onlyOwner {
1076         minTokensBeforeSwap = amount;
1077     }
1078    
1079     receive() external payable {}
1080 }