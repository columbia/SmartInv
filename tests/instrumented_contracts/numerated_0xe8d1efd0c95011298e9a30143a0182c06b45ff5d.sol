1 // SPDX-License-Identifier: MIT
2 /*
3 
4 
5 
6 */
7 
8 pragma solidity ^0.6.12;
9 
10 interface IERC20 {
11 
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 pragma solidity >=0.6.2;
80 
81 interface IUniswapV2Factory {
82     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
83 
84     function feeTo() external view returns (address);
85     function feeToSetter() external view returns (address);
86 
87     function getPair(address tokenA, address tokenB) external view returns (address pair);
88     function allPairs(uint) external view returns (address pair);
89     function allPairsLength() external view returns (uint);
90 
91     function createPair(address tokenA, address tokenB) external returns (address pair);
92 
93     function setFeeTo(address) external;
94     function setFeeToSetter(address) external;
95 }
96 
97 pragma solidity >=0.6.2;
98 
99 interface IUniswapV2Router01 {
100     function factory() external pure returns (address);
101     function WETH() external pure returns (address);
102 
103     function addLiquidity(
104         address tokenA,
105         address tokenB,
106         uint amountADesired,
107         uint amountBDesired,
108         uint amountAMin,
109         uint amountBMin,
110         address to,
111         uint deadline
112     ) external returns (uint amountA, uint amountB, uint liquidity);
113     function addLiquidityETH(
114         address token,
115         uint amountTokenDesired,
116         uint amountTokenMin,
117         uint amountETHMin,
118         address to,
119         uint deadline
120     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
121     function removeLiquidity(
122         address tokenA,
123         address tokenB,
124         uint liquidity,
125         uint amountAMin,
126         uint amountBMin,
127         address to,
128         uint deadline
129     ) external returns (uint amountA, uint amountB);
130     function removeLiquidityETH(
131         address token,
132         uint liquidity,
133         uint amountTokenMin,
134         uint amountETHMin,
135         address to,
136         uint deadline
137     ) external returns (uint amountToken, uint amountETH);
138     function removeLiquidityWithPermit(
139         address tokenA,
140         address tokenB,
141         uint liquidity,
142         uint amountAMin,
143         uint amountBMin,
144         address to,
145         uint deadline,
146         bool approveMax, uint8 v, bytes32 r, bytes32 s
147     ) external returns (uint amountA, uint amountB);
148     function removeLiquidityETHWithPermit(
149         address token,
150         uint liquidity,
151         uint amountTokenMin,
152         uint amountETHMin,
153         address to,
154         uint deadline,
155         bool approveMax, uint8 v, bytes32 r, bytes32 s
156     ) external returns (uint amountToken, uint amountETH);
157     function swapExactTokensForTokens(
158         uint amountIn,
159         uint amountOutMin,
160         address[] calldata path,
161         address to,
162         uint deadline
163     ) external returns (uint[] memory amounts);
164     function swapTokensForExactTokens(
165         uint amountOut,
166         uint amountInMax,
167         address[] calldata path,
168         address to,
169         uint deadline
170     ) external returns (uint[] memory amounts);
171     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
172     external
173     payable
174     returns (uint[] memory amounts);
175     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
176     external
177     returns (uint[] memory amounts);
178     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
179     external
180     returns (uint[] memory amounts);
181     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
182     external
183     payable
184     returns (uint[] memory amounts);
185 
186     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
187     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
188     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
189     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
190     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
191 }
192 
193 pragma solidity >=0.6.2;
194 
195 
196 
197 interface IUniswapV2Router02 is IUniswapV2Router01 {
198     function removeLiquidityETHSupportingFeeOnTransferTokens(
199         address token,
200         uint liquidity,
201         uint amountTokenMin,
202         uint amountETHMin,
203         address to,
204         uint deadline
205     ) external returns (uint amountETH);
206     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
207         address token,
208         uint liquidity,
209         uint amountTokenMin,
210         uint amountETHMin,
211         address to,
212         uint deadline,
213         bool approveMax, uint8 v, bytes32 r, bytes32 s
214     ) external returns (uint amountETH);
215 
216     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
217         uint amountIn,
218         uint amountOutMin,
219         address[] calldata path,
220         address to,
221         uint deadline
222     ) external;
223     function swapExactETHForTokensSupportingFeeOnTransferTokens(
224         uint amountOutMin,
225         address[] calldata path,
226         address to,
227         uint deadline
228     ) external payable;
229     function swapExactTokensForETHSupportingFeeOnTransferTokens(
230         uint amountIn,
231         uint amountOutMin,
232         address[] calldata path,
233         address to,
234         uint deadline
235     ) external;
236 }
237 
238 
239 pragma solidity >=0.4.0;
240 
241 /*
242  * @dev Provides information about the current execution context, including the
243  * sender of the transaction and its data. While these are generally available
244  * via msg.sender and msg.data, they should not be accessed in such a direct
245  * manner, since when dealing with GSN meta-transactions the account sending and
246  * paying for execution may not be the actual sender (as far as an application
247  * is concerned).
248  *
249  * This contract is only required for intermediate, library-like contracts.
250  */
251 contract Context {
252     // Empty internal constructor, to prevent people from mistakenly deploying
253     // an instance of this contract, which should be used via inheritance.
254     constructor() internal {}
255 
256     function _msgSender() internal view returns (address payable) {
257         return msg.sender;
258     }
259 
260     function _msgData() internal view returns (bytes memory) {
261         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
262         return msg.data;
263     }
264 }
265 
266 
267 pragma solidity >=0.4.0;
268 
269 
270 
271 /**
272  * @dev Contract module which provides a basic access control mechanism, where
273  * there is an account (an owner) that can be granted exclusive access to
274  * specific functions.
275  *
276  * By default, the owner account will be the one that deploys the contract. This
277  * can later be changed with {transferOwnership}.
278  *
279  * This module is used through inheritance. It will make available the modifier
280  * `onlyOwner`, which can be applied to your functions to restrict their use to
281  * the owner.
282  */
283 contract Ownable is Context {
284     address private _owner;
285 
286     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
287 
288     /**
289      * @dev Initializes the contract setting the deployer as the initial owner.
290      */
291     constructor() internal {
292         address msgSender = _msgSender();
293         _owner = msgSender;
294         emit OwnershipTransferred(address(0), msgSender);
295     }
296 
297     /**
298      * @dev Returns the address of the current owner.
299      */
300     function owner() public view returns (address) {
301         return _owner;
302     }
303 
304     /**
305      * @dev Throws if called by any account other than the owner.
306      */
307     modifier onlyOwner() {
308         require(_owner == _msgSender(), 'Ownable: caller is not the owner');
309         _;
310     }
311 
312     /**
313      * @dev Leaves the contract without owner. It will not be possible to call
314      * `onlyOwner` functions anymore. Can only be called by the current owner.
315      *
316      * NOTE: Renouncing ownership will leave the contract without an owner,
317      * thereby removing any functionality that is only available to the owner.
318      */
319     function renounceOwnership() public onlyOwner {
320         emit OwnershipTransferred(_owner, address(0));
321         _owner = address(0);
322     }
323 
324     /**
325      * @dev Transfers ownership of the contract to a new account (`newOwner`).
326      * Can only be called by the current owner.
327      */
328     function transferOwnership(address newOwner) public onlyOwner {
329         _transferOwnership(newOwner);
330     }
331 
332     /**
333      * @dev Transfers ownership of the contract to a new account (`newOwner`).
334      */
335     function _transferOwnership(address newOwner) internal {
336         require(newOwner != address(0), 'Ownable: new owner is the zero address');
337         emit OwnershipTransferred(_owner, newOwner);
338         _owner = newOwner;
339     }
340 }
341 
342 
343 
344 pragma solidity >=0.4.0;
345 
346 /**
347  * @dev Wrappers over Solidity's arithmetic operations with added overflow
348  * checks.
349  *
350  * Arithmetic operations in Solidity wrap on overflow. This can easily result
351  * in bugs, because programmers usually assume that an overflow raises an
352  * error, which is the standard behavior in high level programming languages.
353  * `SafeMath` restores this intuition by reverting the transaction when an
354  * operation overflows.
355  *
356  * Using this library instead of the unchecked operations eliminates an entire
357  * class of bugs, so it's recommended to use it always.
358  */
359 library SafeMath {
360     /**
361      * @dev Returns the addition of two unsigned integers, reverting on
362      * overflow.
363      *
364      * Counterpart to Solidity's `+` operator.
365      *
366      * Requirements:
367      *
368      * - Addition cannot overflow.
369      */
370     function add(uint256 a, uint256 b) internal pure returns (uint256) {
371         uint256 c = a + b;
372         require(c >= a, 'SafeMath: addition overflow');
373 
374         return c;
375     }
376 
377     /**
378      * @dev Returns the subtraction of two unsigned integers, reverting on
379      * overflow (when the result is negative).
380      *
381      * Counterpart to Solidity's `-` operator.
382      *
383      * Requirements:
384      *
385      * - Subtraction cannot overflow.
386      */
387     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
388         return sub(a, b, 'SafeMath: subtraction overflow');
389     }
390 
391     /**
392      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
393      * overflow (when the result is negative).
394      *
395      * Counterpart to Solidity's `-` operator.
396      *
397      * Requirements:
398      *
399      * - Subtraction cannot overflow.
400      */
401     function sub(
402         uint256 a,
403         uint256 b,
404         string memory errorMessage
405     ) internal pure returns (uint256) {
406         require(b <= a, errorMessage);
407         uint256 c = a - b;
408 
409         return c;
410     }
411 
412     /**
413      * @dev Returns the multiplication of two unsigned integers, reverting on
414      * overflow.
415      *
416      * Counterpart to Solidity's `*` operator.
417      *
418      * Requirements:
419      *
420      * - Multiplication cannot overflow.
421      */
422     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
423         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
424         // benefit is lost if 'b' is also tested.
425         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
426         if (a == 0) {
427             return 0;
428         }
429 
430         uint256 c = a * b;
431         require(c / a == b, 'SafeMath: multiplication overflow');
432 
433         return c;
434     }
435 
436     /**
437      * @dev Returns the integer division of two unsigned integers. Reverts on
438      * division by zero. The result is rounded towards zero.
439      *
440      * Counterpart to Solidity's `/` operator. Note: this function uses a
441      * `revert` opcode (which leaves remaining gas untouched) while Solidity
442      * uses an invalid opcode to revert (consuming all remaining gas).
443      *
444      * Requirements:
445      *
446      * - The divisor cannot be zero.
447      */
448     function div(uint256 a, uint256 b) internal pure returns (uint256) {
449         return div(a, b, 'SafeMath: division by zero');
450     }
451 
452     /**
453      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
454      * division by zero. The result is rounded towards zero.
455      *
456      * Counterpart to Solidity's `/` operator. Note: this function uses a
457      * `revert` opcode (which leaves remaining gas untouched) while Solidity
458      * uses an invalid opcode to revert (consuming all remaining gas).
459      *
460      * Requirements:
461      *
462      * - The divisor cannot be zero.
463      */
464     function div(
465         uint256 a,
466         uint256 b,
467         string memory errorMessage
468     ) internal pure returns (uint256) {
469         require(b > 0, errorMessage);
470         uint256 c = a / b;
471         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
472 
473         return c;
474     }
475 
476     /**
477      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
478      * Reverts when dividing by zero.
479      *
480      * Counterpart to Solidity's `%` operator. This function uses a `revert`
481      * opcode (which leaves remaining gas untouched) while Solidity uses an
482      * invalid opcode to revert (consuming all remaining gas).
483      *
484      * Requirements:
485      *
486      * - The divisor cannot be zero.
487      */
488     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
489         return mod(a, b, 'SafeMath: modulo by zero');
490     }
491 
492     /**
493      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
494      * Reverts with custom message when dividing by zero.
495      *
496      * Counterpart to Solidity's `%` operator. This function uses a `revert`
497      * opcode (which leaves remaining gas untouched) while Solidity uses an
498      * invalid opcode to revert (consuming all remaining gas).
499      *
500      * Requirements:
501      *
502      * - The divisor cannot be zero.
503      */
504     function mod(
505         uint256 a,
506         uint256 b,
507         string memory errorMessage
508     ) internal pure returns (uint256) {
509         require(b != 0, errorMessage);
510         return a % b;
511     }
512 
513     function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
514         z = x < y ? x : y;
515     }
516 
517     // babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
518     function sqrt(uint256 y) internal pure returns (uint256 z) {
519         if (y > 3) {
520             z = y;
521             uint256 x = y / 2 + 1;
522             while (x < z) {
523                 z = x;
524                 x = (y / x + x) / 2;
525             }
526         } else if (y != 0) {
527             z = 1;
528         }
529     }
530 }
531 
532 
533 
534 pragma solidity ^0.6.2;
535 
536 /**
537  * @dev Collection of functions related to the address type
538  */
539 library Address {
540     /**
541      * @dev Returns true if `account` is a contract.
542      *
543      * [IMPORTANT]
544      * ====
545      * It is unsafe to assume that an address for which this function returns
546      * false is an externally-owned account (EOA) and not a contract.
547      *
548      * Among others, `isContract` will return false for the following
549      * types of addresses:
550      *
551      *  - an externally-owned account
552      *  - a contract in construction
553      *  - an address where a contract will be created
554      *  - an address where a contract lived, but was destroyed
555      * ====
556      */
557     function isContract(address account) internal view returns (bool) {
558         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
559         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
560         // for accounts without code, i.e. `keccak256('')`
561         bytes32 codehash;
562         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
563         // solhint-disable-next-line no-inline-assembly
564         assembly {
565             codehash := extcodehash(account)
566         }
567         return (codehash != accountHash && codehash != 0x0);
568     }
569 
570     /**
571      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
572      * `recipient`, forwarding all available gas and reverting on errors.
573      *
574      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
575      * of certain opcodes, possibly making contracts go over the 2300 gas limit
576      * imposed by `transfer`, making them unable to receive funds via
577      * `transfer`. {sendValue} removes this limitation.
578      *
579      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
580      *
581      * IMPORTANT: because control is transferred to `recipient`, care must be
582      * taken to not create reentrancy vulnerabilities. Consider using
583      * {ReentrancyGuard} or the
584      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
585      */
586     function sendValue(address payable recipient, uint256 amount) internal {
587         require(address(this).balance >= amount, 'Address: insufficient balance');
588 
589         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
590         (bool success, ) = recipient.call{value: amount}('');
591         require(success, 'Address: unable to send value, recipient may have reverted');
592     }
593 
594     /**
595      * @dev Performs a Solidity function call using a low level `call`. A
596      * plain`call` is an unsafe replacement for a function call: use this
597      * function instead.
598      *
599      * If `target` reverts with a revert reason, it is bubbled up by this
600      * function (like regular Solidity function calls).
601      *
602      * Returns the raw returned data. To convert to the expected return value,
603      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
604      *
605      * Requirements:
606      *
607      * - `target` must be a contract.
608      * - calling `target` with `data` must not revert.
609      *
610      * _Available since v3.1._
611      */
612     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
613         return functionCall(target, data, 'Address: low-level call failed');
614     }
615 
616     /**
617      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
618      * `errorMessage` as a fallback revert reason when `target` reverts.
619      *
620      * _Available since v3.1._
621      */
622     function functionCall(
623         address target,
624         bytes memory data,
625         string memory errorMessage
626     ) internal returns (bytes memory) {
627         return _functionCallWithValue(target, data, 0, errorMessage);
628     }
629 
630     /**
631      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
632      * but also transferring `value` wei to `target`.
633      *
634      * Requirements:
635      *
636      * - the calling contract must have an ETH balance of at least `value`.
637      * - the called Solidity function must be `payable`.
638      *
639      * _Available since v3.1._
640      */
641     function functionCallWithValue(
642         address target,
643         bytes memory data,
644         uint256 value
645     ) internal returns (bytes memory) {
646         return functionCallWithValue(target, data, value, 'Address: low-level call with value failed');
647     }
648 
649     /**
650      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
651      * with `errorMessage` as a fallback revert reason when `target` reverts.
652      *
653      * _Available since v3.1._
654      */
655     function functionCallWithValue(
656         address target,
657         bytes memory data,
658         uint256 value,
659         string memory errorMessage
660     ) internal returns (bytes memory) {
661         require(address(this).balance >= value, 'Address: insufficient balance for call');
662         return _functionCallWithValue(target, data, value, errorMessage);
663     }
664 
665     function _functionCallWithValue(
666         address target,
667         bytes memory data,
668         uint256 weiValue,
669         string memory errorMessage
670     ) private returns (bytes memory) {
671         require(isContract(target), 'Address: call to non-contract');
672 
673         // solhint-disable-next-line avoid-low-level-calls
674         (bool success, bytes memory returndata) = target.call{value: weiValue}(data);
675         if (success) {
676             return returndata;
677         } else {
678             // Look for revert reason and bubble it up if present
679             if (returndata.length > 0) {
680                 // The easiest way to bubble the revert reason is using memory via assembly
681 
682                 // solhint-disable-next-line no-inline-assembly
683                 assembly {
684                     let returndata_size := mload(returndata)
685                     revert(add(32, returndata), returndata_size)
686                 }
687             } else {
688                 revert(errorMessage);
689             }
690         }
691     }
692 }
693 
694 
695 pragma solidity ^0.6.12;
696 
697 
698 contract SIONTOKEN is Context, IERC20, Ownable {
699     using SafeMath for uint256;
700     using Address for address;
701 
702     mapping (address => uint256) private _rOwned;
703     mapping (address => uint256) private _tOwned;
704     mapping (address => mapping (address => uint256)) private _allowances;
705 
706     mapping (address => bool) private _isExcludedFromFee;
707 
708     mapping (address => bool) private _isExcluded;
709     address[] private _excluded;
710 
711     uint256 private constant MAX = ~uint256(0);
712     uint256 private _tTotal = 1000000 * 10**6 * 10**9;
713     uint256 private _rTotal = (MAX - (MAX % _tTotal));
714     uint256 private _tFeeTotal;
715     uint256 private _tBurnTotal;
716     uint256 private _tCharitypoolTotal;
717 
718     string private _name = "Sion";
719     string private _symbol = "SION";
720     uint8 private _decimals = 9;
721 
722     uint256 public _taxFee = 3;
723     uint256 private _previousTaxFee = _taxFee;
724 
725     uint256 public _burnFee = 0;
726     uint256 private _previousBurnFee = _burnFee;
727 
728     uint256 public _charitypoolFee = 3;
729     uint256 private _previousCharitypoolFee = _charitypoolFee;
730 
731     uint256 public _maxTxAmount = 1000000 * 10**6 * 10**9;
732     uint256 private minimumTokensBeforeSwap = 100 * 10**6 * 10**9;
733 
734     address payable public charitypoolAddress = 0xE1bA8A57f306Aa3b7046F8d376BC091ec2B74591; // Charity Wallet
735    
736 
737     IUniswapV2Router02 public immutable uniswapV2Router;
738     address public immutable uniswapV2Pair;
739 
740     bool inSwapAndLiquify;
741     bool public swapAndLiquifyEnabled = true;
742 
743     event RewardLiquidityProviders(uint256 tokenAmount);
744     event SwapAndLiquifyEnabledUpdated(bool enabled);
745     event SwapAndLiquify(
746         uint256 tokensSwapped,
747         uint256 ethReceived,
748         uint256 tokensIntoLiqudity
749     );
750 
751     modifier lockTheSwap {
752         inSwapAndLiquify = true;
753         _;
754         inSwapAndLiquify = false;
755     }
756 
757     constructor () public {
758         _rOwned[_msgSender()] = _rTotal;
759 
760         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
761         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
762         .createPair(address(this), _uniswapV2Router.WETH());
763 
764         uniswapV2Router = _uniswapV2Router;
765 
766         _isExcludedFromFee[owner()] = true;
767         _isExcludedFromFee[address(this)] = true;
768 
769         emit Transfer(address(0), _msgSender(), _tTotal);
770     }
771 
772     function name() public view returns (string memory) {
773         return _name;
774     }
775 
776     function symbol() public view returns (string memory) {
777         return _symbol;
778     }
779 
780     function decimals() public view returns (uint8) {
781         return _decimals;
782     }
783 
784     function totalSupply() public view override returns (uint256) {
785         return _tTotal;
786     }
787 
788     function balanceOf(address account) public view override returns (uint256) {
789         if (_isExcluded[account]) return _tOwned[account];
790         return tokenFromReflection(_rOwned[account]);
791     }
792 
793     function transfer(address recipient, uint256 amount) public override returns (bool) {
794         _transfer(_msgSender(), recipient, amount);
795         return true;
796     }
797 
798     function allowance(address owner, address spender) public view override returns (uint256) {
799         return _allowances[owner][spender];
800     }
801 
802     function approve(address spender, uint256 amount) public override returns (bool) {
803         _approve(_msgSender(), spender, amount);
804         return true;
805     }
806 
807     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
808         _transfer(sender, recipient, amount);
809         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
810         return true;
811     }
812 
813     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
814         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
815         return true;
816     }
817 
818     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
819         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
820         return true;
821     }
822 
823     function isExcludedFromReward(address account) public view returns (bool) {
824         return _isExcluded[account];
825     }
826 
827     function totalFees() public view returns (uint256) {
828         return _tFeeTotal;
829     }
830 
831     function totalBurn() public view returns (uint256) {
832         return _tBurnTotal;
833     }
834 
835     function totalCharitypoolETH() public view returns (uint256) {
836         // ETH has  18 decimals!
837         return _tCharitypoolTotal;
838     }
839 
840     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
841         return minimumTokensBeforeSwap;
842     }
843 
844     function deliver(uint256 tAmount) public {
845         address sender = _msgSender();
846         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
847         (uint256 rAmount,,,,,,) = _getValues(tAmount);
848         _rOwned[sender] = _rOwned[sender].sub(rAmount);
849         _rTotal = _rTotal.sub(rAmount);
850         _tFeeTotal = _tFeeTotal.add(tAmount);
851     }
852 
853 
854     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
855         require(tAmount <= _tTotal, "Amount must be less than supply");
856         if (!deductTransferFee) {
857             (uint256 rAmount,,,,,,) = _getValues(tAmount);
858             return rAmount;
859         } else {
860             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
861             return rTransferAmount;
862         }
863     }
864 
865     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
866         require(rAmount <= _rTotal, "Amount must be less than total reflections");
867         uint256 currentRate =  _getRate();
868         return rAmount.div(currentRate);
869     }
870 
871     function excludeFromReward(address account) public onlyOwner() {
872         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
873         require(!_isExcluded[account], "Account is already excluded");
874         if(_rOwned[account] > 0) {
875             _tOwned[account] = tokenFromReflection(_rOwned[account]);
876         }
877         _isExcluded[account] = true;
878         _excluded.push(account);
879     }
880 
881     function includeInReward(address account) external onlyOwner() {
882         require(_isExcluded[account], "Account is already excluded");
883         for (uint256 i = 0; i < _excluded.length; i++) {
884             if (_excluded[i] == account) {
885                 _excluded[i] = _excluded[_excluded.length - 1];
886                 _tOwned[account] = 0;
887                 _isExcluded[account] = false;
888                 _excluded.pop();
889                 break;
890             }
891         }
892     }
893 
894     function _approve(address owner, address spender, uint256 amount) private {
895         require(owner != address(0), "ERC20: approve from the zero address");
896         require(spender != address(0), "ERC20: approve to the zero address");
897 
898         _allowances[owner][spender] = amount;
899         emit Approval(owner, spender, amount);
900     }
901 
902     function _transfer(
903         address from,
904         address to,
905         uint256 amount
906     ) private {
907         require(from != address(0), "ERC20: transfer from the zero address");
908         require(to != address(0), "ERC20: transfer to the zero address");
909         require(amount > 0, "Transfer amount must be greater than zero");
910         if(from != owner() && to != owner())
911             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
912 
913 
914         uint256 contractTokenBalance = balanceOf(address(this));
915         bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
916         if (
917             overMinimumTokenBalance &&
918             !inSwapAndLiquify &&
919             from != uniswapV2Pair &&
920             swapAndLiquifyEnabled
921         ) {
922             contractTokenBalance = minimumTokensBeforeSwap;
923             swapAndLiquify(contractTokenBalance);
924         }
925 
926 
927         bool takeFee = true;
928 
929         //if any account belongs to _isExcludedFromFee account then remove the fee
930         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
931             takeFee = false;
932         }
933 
934         _tokenTransfer(from,to,amount,takeFee);
935     }
936 
937     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
938         swapTokensForEth(contractTokenBalance);
939         _tCharitypoolTotal = _tCharitypoolTotal.add(address(this).balance);
940         TransferCharitypoolETH(charitypoolAddress, address(this).balance);
941     }
942 
943     function swapTokensForEth(uint256 tokenAmount) private {
944         // generate the uniswap pair path of token -> weth
945         address[] memory path = new address[](2);
946         path[0] = address(this);
947         path[1] = uniswapV2Router.WETH();
948 
949         _approve(address(this), address(uniswapV2Router), tokenAmount);
950 
951         // make the swap
952         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
953             tokenAmount,
954             0, // accept any amount of ETH
955             path,
956             address(this), // The contract
957             block.timestamp
958         );
959     }
960 
961 
962     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
963         if(!takeFee)
964             removeAllFee();
965 
966         if (_isExcluded[sender] && !_isExcluded[recipient]) {
967             _transferFromExcluded(sender, recipient, amount);
968         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
969             _transferToExcluded(sender, recipient, amount);
970         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
971             _transferStandard(sender, recipient, amount);
972         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
973             _transferBothExcluded(sender, recipient, amount);
974         } else {
975             _transferStandard(sender, recipient, amount);
976         }
977 
978         if(!takeFee)
979             restoreAllFee();
980     }
981 
982     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
983         uint256 currentRate =  _getRate();
984         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity) = _getValues(tAmount);
985         uint256 rBurn =  tBurn.mul(currentRate);
986         _rOwned[sender] = _rOwned[sender].sub(rAmount);
987         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
988         _takeLiquidity(tLiquidity);
989         _reflectFee(rFee, rBurn, tFee, tBurn);
990         emit Transfer(sender, recipient, tTransferAmount);
991     }
992 
993     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
994         uint256 currentRate =  _getRate();
995         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity) = _getValues(tAmount);
996         uint256 rBurn =  tBurn.mul(currentRate);
997         _rOwned[sender] = _rOwned[sender].sub(rAmount);
998         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
999         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1000         _takeLiquidity(tLiquidity);
1001         _reflectFee(rFee, rBurn, tFee, tBurn);
1002         emit Transfer(sender, recipient, tTransferAmount);
1003     }
1004 
1005     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1006         uint256 currentRate =  _getRate();
1007         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity) = _getValues(tAmount);
1008         uint256 rBurn =  tBurn.mul(currentRate);
1009         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1010         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1011         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1012         _takeLiquidity(tLiquidity);
1013         _reflectFee(rFee, rBurn, tFee, tBurn);
1014         emit Transfer(sender, recipient, tTransferAmount);
1015     }
1016 
1017     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1018         uint256 currentRate =  _getRate();
1019         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity) = _getValues(tAmount);
1020         uint256 rBurn =  tBurn.mul(currentRate);
1021         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1022         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1023         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1024         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1025         _takeLiquidity(tLiquidity);
1026         _reflectFee(rFee, rBurn, tFee, tBurn);
1027         emit Transfer(sender, recipient, tTransferAmount);
1028     }
1029 
1030     function _reflectFee(uint256 rFee, uint256 rBurn, uint256 tFee, uint256 tBurn) private {
1031         _rTotal = _rTotal.sub(rFee).sub(rBurn);
1032         _tFeeTotal = _tFeeTotal.add(tFee);
1033         _tBurnTotal = _tBurnTotal.add(tBurn);
1034         _tTotal = _tTotal.sub(tBurn);
1035     }
1036 
1037     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
1038         (uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity) = _getTValues(tAmount);
1039         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tBurn, tLiquidity, _getRate());
1040         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tBurn, tLiquidity);
1041     }
1042 
1043     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
1044         uint256 tFee = calculateTaxFee(tAmount);
1045         uint256 tBurn = calculateBurnFee(tAmount);
1046         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1047         uint256 tTransferAmount = tAmount.sub(tFee).sub(tBurn).sub(tLiquidity);
1048         return (tTransferAmount, tFee, tBurn, tLiquidity);
1049     }
1050 
1051     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1052         uint256 rAmount = tAmount.mul(currentRate);
1053         uint256 rFee = tFee.mul(currentRate);
1054         uint256 rBurn = tBurn.mul(currentRate);
1055         uint256 rLiquidity = tLiquidity.mul(currentRate);
1056         uint256 rTransferAmount = rAmount.sub(rFee).sub(rBurn).sub(rLiquidity);
1057         return (rAmount, rTransferAmount, rFee);
1058     }
1059 
1060     function _getRate() private view returns(uint256) {
1061         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1062         return rSupply.div(tSupply);
1063     }
1064 
1065     function _getCurrentSupply() private view returns(uint256, uint256) {
1066         uint256 rSupply = _rTotal;
1067         uint256 tSupply = _tTotal;
1068         for (uint256 i = 0; i < _excluded.length; i++) {
1069             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1070             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1071             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1072         }
1073         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1074         return (rSupply, tSupply);
1075     }
1076 
1077     function _takeLiquidity(uint256 tLiquidity) private {
1078         uint256 currentRate =  _getRate();
1079         uint256 rLiquidity = tLiquidity.mul(currentRate);
1080         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1081         if(_isExcluded[address(this)])
1082             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1083     }
1084 
1085     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1086         return _amount.mul(_taxFee).div(
1087             10**2
1088         );
1089     }
1090 
1091     function calculateBurnFee(uint256 _amount) private view returns (uint256) {
1092         return _amount.mul(_burnFee).div(
1093             10**2
1094         );
1095     }
1096 
1097     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1098         return _amount.mul(_charitypoolFee).div(
1099             10**2
1100         );
1101     }
1102 
1103     function removeAllFee() private {
1104         if(_taxFee == 0 && _burnFee == 0 && _charitypoolFee == 0) return;
1105 
1106         _previousTaxFee = _taxFee;
1107         _previousBurnFee = _burnFee;
1108         _previousCharitypoolFee = _charitypoolFee;
1109 
1110         _taxFee = 0;
1111         _burnFee = 0;
1112         _charitypoolFee = 0;
1113     }
1114 
1115     function restoreAllFee() private {
1116         _taxFee = _previousTaxFee;
1117         _burnFee = _previousBurnFee;
1118         _charitypoolFee = _previousCharitypoolFee;
1119     }
1120 
1121     function isExcludedFromFee(address account) public view returns(bool) {
1122         return _isExcludedFromFee[account];
1123     }
1124 
1125     function excludeFromFee(address account) public onlyOwner {
1126         _isExcludedFromFee[account] = true;
1127     }
1128 
1129     function includeInFee(address account) public onlyOwner {
1130         _isExcludedFromFee[account] = false;
1131     }
1132 
1133     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
1134         _taxFee = taxFee;
1135     }
1136 
1137     function setBurnFeePercent(uint256 burnFee) external onlyOwner() {
1138         _burnFee = burnFee;
1139     }
1140 
1141     function setCharitypoolFeePercent(uint256 CharitypoolFee) external onlyOwner() {
1142         _charitypoolFee = CharitypoolFee;
1143     }
1144 
1145     function setMaxTxPercent(uint256 maxTxPercent, uint256 maxTxDecimals) external onlyOwner() {
1146         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
1147             10**(uint256(maxTxDecimals) + 2)
1148         );
1149     }
1150 
1151     function setNumTokensSellToAddToLiquidity(uint256 _minimumTokensBeforeSwap) external onlyOwner() {
1152         minimumTokensBeforeSwap = _minimumTokensBeforeSwap;
1153     }
1154 
1155     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1156         swapAndLiquifyEnabled = _enabled;
1157         emit SwapAndLiquifyEnabledUpdated(_enabled);
1158     }
1159 
1160 
1161     function TransferCharitypoolETH(address payable recipient, uint256 amount) private {
1162         recipient.transfer(amount);
1163     }
1164 
1165 
1166     //to recieve ETH from uniswapV2Router when swaping
1167     receive() external payable {}
1168 }