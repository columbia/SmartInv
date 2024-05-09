1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity 0.8.7;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address payable) {
7         return payable(msg.sender);
8     }
9 
10     function _msgData() internal view virtual returns (bytes memory) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 /**
17  * @dev Contract module which provides a basic access control mechanism, where
18  * there is an account (an owner) that can be granted exclusive access to
19  * specific functions.
20  *
21  * By default, the owner account will be the one that deploys the contract. This
22  * can later be changed with {transferOwnership}.
23  *
24  * This module is used through inheritance. It will make available the modifier
25  * `onlyOwner`, which can be applied to your functions to restrict their use to
26  * the owner.
27  */
28 contract Ownable is Context {
29     address private _owner;
30     address private _previousOwner;
31     uint256 private _lockTime;
32 
33     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35     /**
36      * @dev Initializes the contract setting the deployer as the initial owner.
37      */
38     constructor () {
39         address msgSender = _msgSender();
40         _owner = msgSender;
41         emit OwnershipTransferred(address(0), msgSender);
42     }
43 
44     /**
45      * @dev Returns the address of the current owner.
46      */
47     function owner() public view returns (address) {
48         return _owner;
49     }
50 
51     /**
52      * @dev Throws if called by any account other than the owner.
53      */
54     modifier onlyOwner() {
55         require(_owner == _msgSender(), "Ownable: caller is not the owner");
56         _;
57     }
58 
59      /**
60      * @dev Leaves the contract without owner. It will not be possible to call
61      * `onlyOwner` functions anymore. Can only be called by the current owner.
62      *
63      * NOTE: Renouncing ownership will leave the contract without an owner,
64      * thereby removing any functionality that is only available to the owner.
65      */
66     function renounceOwnership() public virtual onlyOwner {
67         emit OwnershipTransferred(_owner, address(0));
68         _owner = address(0);
69     }
70 
71     /**
72      * @dev Transfers ownership of the contract to a new account (`newOwner`).
73      * Can only be called by the current owner.
74      */
75     function transferOwnership(address newOwner) public virtual onlyOwner {
76         require(newOwner != address(0), "Ownable: new owner is the zero address");
77         emit OwnershipTransferred(_owner, newOwner);
78         _owner = newOwner;
79     }
80 
81     function geUnlockTime() public view returns (uint256) {
82         return _lockTime;
83     }
84 
85     //Locks the contract for owner for the amount of time provided
86     function lock(uint256 time) public virtual onlyOwner {
87         _previousOwner = _owner;
88         _owner = address(0);
89         _lockTime = block.timestamp + time;
90         emit OwnershipTransferred(_owner, address(0));
91     }
92     
93     //Unlocks the contract for owner when _lockTime is exceeds
94     function unlock() public virtual {
95         require(_previousOwner == msg.sender, "You don't have permission to unlock");
96         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
97         emit OwnershipTransferred(_owner, _previousOwner);
98         _owner = _previousOwner;
99     }
100 }
101 
102 interface IERC20 {
103 
104     function totalSupply() external view returns (uint256);
105 
106     /**
107      * @dev Returns the amount of tokens owned by `account`.
108      */
109     function balanceOf(address account) external view returns (uint256);
110 
111     /**
112      * @dev Moves `amount` tokens from the caller's account to `recipient`.
113      *
114      * Returns a boolean value indicating whether the operation succeeded.
115      *
116      * Emits a {Transfer} event.
117      */
118     function transfer(address recipient, uint256 amount) external returns (bool);
119 
120     /**
121      * @dev Returns the remaining number of tokens that `spender` will be
122      * allowed to spend on behalf of `owner` through {transferFrom}. This is
123      * zero by default.
124      *
125      * This value changes when {approve} or {transferFrom} are called.
126      */
127     function allowance(address owner, address spender) external view returns (uint256);
128 
129     /**
130      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
131      *
132      * Returns a boolean value indicating whether the operation succeeded.
133      *
134      * IMPORTANT: Beware that changing an allowance with this method brings the risk
135      * that someone may use both the old and the new allowance by unfortunate
136      * transaction ordering. One possible solution to mitigate this race
137      * condition is to first reduce the spender's allowance to 0 and set the
138      * desired value afterwards:
139      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
140      *
141      * Emits an {Approval} event.
142      */
143     function approve(address spender, uint256 amount) external returns (bool);
144 
145     /**
146      * @dev Moves `amount` tokens from `sender` to `recipient` using the
147      * allowance mechanism. `amount` is then deducted from the caller's
148      * allowance.
149      *
150      * Returns a boolean value indicating whether the operation succeeded.
151      *
152      * Emits a {Transfer} event.
153      */
154     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
155 
156     /**
157      * @dev Emitted when `value` tokens are moved from one account (`from`) to
158      * another (`to`).
159      *
160      * Note that `value` may be zero.
161      */
162     event Transfer(address indexed from, address indexed to, uint256 value);
163 
164     /**
165      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
166      * a call to {approve}. `value` is the new allowance.
167      */
168     event Approval(address indexed owner, address indexed spender, uint256 value);
169 }
170 
171 
172 
173 /**
174  * @dev Wrappers over Solidity's arithmetic operations with added overflow
175  * checks.
176  *
177  * Arithmetic operations in Solidity wrap on overflow. This can easily result
178  * in bugs, because programmers usually assume that an overflow raises an
179  * error, which is the standard behavior in high level programming languages.
180  * `SafeMath` restores this intuition by reverting the transaction when an
181  * operation overflows.
182  *
183  * Using this library instead of the unchecked operations eliminates an entire
184  * class of bugs, so it's recommended to use it always.
185  */
186  
187 library SafeMath {
188     /**
189      * @dev Returns the addition of two unsigned integers, reverting on
190      * overflow.
191      *
192      * Counterpart to Solidity's `+` operator.
193      *
194      * Requirements:
195      *
196      * - Addition cannot overflow.
197      */
198     function add(uint256 a, uint256 b) internal pure returns (uint256) {
199         uint256 c = a + b;
200         require(c >= a, "SafeMath: addition overflow");
201 
202         return c;
203     }
204 
205     /**
206      * @dev Returns the subtraction of two unsigned integers, reverting on
207      * overflow (when the result is negative).
208      *
209      * Counterpart to Solidity's `-` operator.
210      *
211      * Requirements:
212      *
213      * - Subtraction cannot overflow.
214      */
215     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
216         return sub(a, b, "SafeMath: subtraction overflow");
217     }
218 
219     /**
220      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
221      * overflow (when the result is negative).
222      *
223      * Counterpart to Solidity's `-` operator.
224      *
225      * Requirements:
226      *
227      * - Subtraction cannot overflow.
228      */
229     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
230         require(b <= a, errorMessage);
231         uint256 c = a - b;
232 
233         return c;
234     }
235 
236     /**
237      * @dev Returns the multiplication of two unsigned integers, reverting on
238      * overflow.
239      *
240      * Counterpart to Solidity's `*` operator.
241      *
242      * Requirements:
243      *
244      * - Multiplication cannot overflow.
245      */
246     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
247         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
248         // benefit is lost if 'b' is also tested.
249         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
250         if (a == 0) {
251             return 0;
252         }
253 
254         uint256 c = a * b;
255         require(c / a == b, "SafeMath: multiplication overflow");
256 
257         return c;
258     }
259 
260     /**
261      * @dev Returns the integer division of two unsigned integers. Reverts on
262      * division by zero. The result is rounded towards zero.
263      *
264      * Counterpart to Solidity's `/` operator. Note: this function uses a
265      * `revert` opcode (which leaves remaining gas untouched) while Solidity
266      * uses an invalid opcode to revert (consuming all remaining gas).
267      *
268      * Requirements:
269      *
270      * - The divisor cannot be zero.
271      */
272     function div(uint256 a, uint256 b) internal pure returns (uint256) {
273         return div(a, b, "SafeMath: division by zero");
274     }
275 
276     /**
277      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
278      * division by zero. The result is rounded towards zero.
279      *
280      * Counterpart to Solidity's `/` operator. Note: this function uses a
281      * `revert` opcode (which leaves remaining gas untouched) while Solidity
282      * uses an invalid opcode to revert (consuming all remaining gas).
283      *
284      * Requirements:
285      *
286      * - The divisor cannot be zero.
287      */
288     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
289         require(b > 0, errorMessage);
290         uint256 c = a / b;
291         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
292 
293         return c;
294     }
295 
296     /**
297      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
298      * Reverts when dividing by zero.
299      *
300      * Counterpart to Solidity's `%` operator. This function uses a `revert`
301      * opcode (which leaves remaining gas untouched) while Solidity uses an
302      * invalid opcode to revert (consuming all remaining gas).
303      *
304      * Requirements:
305      *
306      * - The divisor cannot be zero.
307      */
308     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
309         return mod(a, b, "SafeMath: modulo by zero");
310     }
311 
312     /**
313      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
314      * Reverts with custom message when dividing by zero.
315      *
316      * Counterpart to Solidity's `%` operator. This function uses a `revert`
317      * opcode (which leaves remaining gas untouched) while Solidity uses an
318      * invalid opcode to revert (consuming all remaining gas).
319      *
320      * Requirements:
321      *
322      * - The divisor cannot be zero.
323      */
324     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
325         require(b != 0, errorMessage);
326         return a % b;
327     }
328 }
329 
330 /**
331  * @dev Collection of functions related to the address type
332  */
333 library Address {
334     /**
335      * @dev Returns true if `account` is a contract.
336      *
337      * [IMPORTANT]
338      * ====
339      * It is unsafe to assume that an address for which this function returns
340      * false is an externally-owned account (EOA) and not a contract.
341      *
342      * Among others, `isContract` will return false for the following
343      * types of addresses:
344      *
345      *  - an externally-owned account
346      *  - a contract in construction
347      *  - an address where a contract will be created
348      *  - an address where a contract lived, but was destroyed
349      * ====
350      */
351     function isContract(address account) internal view returns (bool) {
352         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
353         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
354         // for accounts without code, i.e. `keccak256('')`
355         bytes32 codehash;
356         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
357         // solhint-disable-next-line no-inline-assembly
358         assembly { codehash := extcodehash(account) }
359         return (codehash != accountHash && codehash != 0x0);
360     }
361 
362     /**
363      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
364      * `recipient`, forwarding all available gas and reverting on errors.
365      *
366      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
367      * of certain opcodes, possibly making contracts go over the 2300 gas limit
368      * imposed by `transfer`, making them unable to receive funds via
369      * `transfer`. {sendValue} removes this limitation.
370      *
371      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
372      *
373      * IMPORTANT: because control is transferred to `recipient`, care must be
374      * taken to not create reentrancy vulnerabilities. Consider using
375      * {ReentrancyGuard} or the
376      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
377      */
378     function sendValue(address payable recipient, uint256 amount) internal {
379         require(address(this).balance >= amount, "Address: insufficient balance");
380 
381         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
382         (bool success, ) = recipient.call{ value: amount }("");
383         require(success, "Address: unable to send value, recipient may have reverted");
384     }
385 
386     /**
387      * @dev Performs a Solidity function call using a low level `call`. A
388      * plain`call` is an unsafe replacement for a function call: use this
389      * function instead.
390      *
391      * If `target` reverts with a revert reason, it is bubbled up by this
392      * function (like regular Solidity function calls).
393      *
394      * Returns the raw returned data. To convert to the expected return value,
395      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
396      *
397      * Requirements:
398      *
399      * - `target` must be a contract.
400      * - calling `target` with `data` must not revert.
401      *
402      * _Available since v3.1._
403      */
404     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
405       return functionCall(target, data, "Address: low-level call failed");
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
410      * `errorMessage` as a fallback revert reason when `target` reverts.
411      *
412      * _Available since v3.1._
413      */
414     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
415         return _functionCallWithValue(target, data, 0, errorMessage);
416     }
417 
418     /**
419      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
420      * but also transferring `value` wei to `target`.
421      *
422      * Requirements:
423      *
424      * - the calling contract must have an ETH balance of at least `value`.
425      * - the called Solidity function must be `payable`.
426      *
427      * _Available since v3.1._
428      */
429     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
430         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
435      * with `errorMessage` as a fallback revert reason when `target` reverts.
436      *
437      * _Available since v3.1._
438      */
439     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
440         require(address(this).balance >= value, "Address: insufficient balance for call");
441         return _functionCallWithValue(target, data, value, errorMessage);
442     }
443 
444     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
445         require(isContract(target), "Address: call to non-contract");
446 
447         // solhint-disable-next-line avoid-low-level-calls
448         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
449         if (success) {
450             return returndata;
451         } else {
452             // Look for revert reason and bubble it up if present
453             if (returndata.length > 0) {
454                 // The easiest way to bubble the revert reason is using memory via assembly
455 
456                 // solhint-disable-next-line no-inline-assembly
457                 assembly {
458                     let returndata_size := mload(returndata)
459                     revert(add(32, returndata), returndata_size)
460                 }
461             } else {
462                 revert(errorMessage);
463             }
464         }
465     }
466 }
467 
468 // pragma solidity >=0.5.0;
469 
470 interface IUniswapV2Factory {
471     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
472 
473     function feeTo() external view returns (address);
474     function feeToSetter() external view returns (address);
475 
476     function getPair(address tokenA, address tokenB) external view returns (address pair);
477     function allPairs(uint) external view returns (address pair);
478     function allPairsLength() external view returns (uint);
479 
480     function createPair(address tokenA, address tokenB) external returns (address pair);
481 
482     function setFeeTo(address) external;
483     function setFeeToSetter(address) external;
484 }
485 
486 
487 // pragma solidity >=0.5.0;
488 
489 interface IUniswapV2Pair {
490     event Approval(address indexed owner, address indexed spender, uint value);
491     event Transfer(address indexed from, address indexed to, uint value);
492 
493     function name() external pure returns (string memory);
494     function symbol() external pure returns (string memory);
495     function decimals() external pure returns (uint8);
496     function totalSupply() external view returns (uint);
497     function balanceOf(address owner) external view returns (uint);
498     function allowance(address owner, address spender) external view returns (uint);
499 
500     function approve(address spender, uint value) external returns (bool);
501     function transfer(address to, uint value) external returns (bool);
502     function transferFrom(address from, address to, uint value) external returns (bool);
503 
504     function DOMAIN_SEPARATOR() external view returns (bytes32);
505     function PERMIT_TYPEHASH() external pure returns (bytes32);
506     function nonces(address owner) external view returns (uint);
507 
508     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
509 
510     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
511     event Swap(
512         address indexed sender,
513         uint amount0In,
514         uint amount1In,
515         uint amount0Out,
516         uint amount1Out,
517         address indexed to
518     );
519     event Sync(uint112 reserve0, uint112 reserve1);
520 
521     function MINIMUM_LIQUIDITY() external pure returns (uint);
522     function factory() external view returns (address);
523     function token0() external view returns (address);
524     function token1() external view returns (address);
525     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
526     function price0CumulativeLast() external view returns (uint);
527     function price1CumulativeLast() external view returns (uint);
528     function kLast() external view returns (uint);
529 
530     function burn(address to) external returns (uint amount0, uint amount1);
531     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
532     function skim(address to) external;
533     function sync() external;
534 
535     function initialize(address, address) external;
536 }
537 
538 // pragma solidity >=0.6.2;
539 
540 interface IUniswapV2Router01 {
541     function factory() external pure returns (address);
542     function WETH() external pure returns (address);
543 
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
562     function removeLiquidity(
563         address tokenA,
564         address tokenB,
565         uint liquidity,
566         uint amountAMin,
567         uint amountBMin,
568         address to,
569         uint deadline
570     ) external returns (uint amountA, uint amountB);
571     function removeLiquidityETH(
572         address token,
573         uint liquidity,
574         uint amountTokenMin,
575         uint amountETHMin,
576         address to,
577         uint deadline
578     ) external returns (uint amountToken, uint amountETH);
579     function removeLiquidityWithPermit(
580         address tokenA,
581         address tokenB,
582         uint liquidity,
583         uint amountAMin,
584         uint amountBMin,
585         address to,
586         uint deadline,
587         bool approveMax, uint8 v, bytes32 r, bytes32 s
588     ) external returns (uint amountA, uint amountB);
589     function removeLiquidityETHWithPermit(
590         address token,
591         uint liquidity,
592         uint amountTokenMin,
593         uint amountETHMin,
594         address to,
595         uint deadline,
596         bool approveMax, uint8 v, bytes32 r, bytes32 s
597     ) external returns (uint amountToken, uint amountETH);
598     function swapExactTokensForTokens(
599         uint amountIn,
600         uint amountOutMin,
601         address[] calldata path,
602         address to,
603         uint deadline
604     ) external returns (uint[] memory amounts);
605     function swapTokensForExactTokens(
606         uint amountOut,
607         uint amountInMax,
608         address[] calldata path,
609         address to,
610         uint deadline
611     ) external returns (uint[] memory amounts);
612     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
613         external
614         payable
615         returns (uint[] memory amounts);
616     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
617         external
618         returns (uint[] memory amounts);
619     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
620         external
621         returns (uint[] memory amounts);
622     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
623         external
624         payable
625         returns (uint[] memory amounts);
626 
627     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
628     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
629     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
630     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
631     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
632 }
633 
634 
635 
636 // pragma solidity >=0.6.2;
637 
638 interface IUniswapV2Router02 is IUniswapV2Router01 {
639     function removeLiquidityETHSupportingFeeOnTransferTokens(
640         address token,
641         uint liquidity,
642         uint amountTokenMin,
643         uint amountETHMin,
644         address to,
645         uint deadline
646     ) external returns (uint amountETH);
647     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
648         address token,
649         uint liquidity,
650         uint amountTokenMin,
651         uint amountETHMin,
652         address to,
653         uint deadline,
654         bool approveMax, uint8 v, bytes32 r, bytes32 s
655     ) external returns (uint amountETH);
656 
657     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
658         uint amountIn,
659         uint amountOutMin,
660         address[] calldata path,
661         address to,
662         uint deadline
663     ) external;
664     function swapExactETHForTokensSupportingFeeOnTransferTokens(
665         uint amountOutMin,
666         address[] calldata path,
667         address to,
668         uint deadline
669     ) external payable;
670     function swapExactTokensForETHSupportingFeeOnTransferTokens(
671         uint amountIn,
672         uint amountOutMin,
673         address[] calldata path,
674         address to,
675         uint deadline
676     ) external;
677 }
678 
679 
680 contract ToshinoriInu is Context, IERC20, Ownable {
681     using SafeMath for uint256;
682     using Address for address;
683 
684     mapping (address => uint256) private _rOwned;
685     mapping (address => uint256) private _tOwned;
686     mapping (address => mapping (address => uint256)) private _allowances;
687 
688     mapping (address => bool) private _isExcludedFromFee;
689     mapping(address => bool) public _isBlacklisted;
690 
691     mapping (address => bool) private _isExcluded;
692     address[] private _excluded;
693   
694     uint256 private constant MAX = ~uint256(0);
695     uint256 private _tTotal = 5000000000 * (10**9);
696     uint256 private _rTotal = (MAX - (MAX % _tTotal));
697     uint256 private _tFeeTotal;
698 
699     string private _name = "Toshinori Inu";
700     string private _symbol = "TOSHINORI";
701     uint8 private _decimals = 9;
702     
703     uint256 public _taxFee = 1;
704     uint256 private _previousTaxFee = _taxFee;
705     
706     uint256 public _buybackFee = 2;
707     uint256 private _previousBuybackFee = _buybackFee;
708     
709     address public immutable deadWallet = 0x000000000000000000000000000000000000dEaD;
710     
711     uint256 public _marketingFee = 6;
712     uint256 private _previousMarketingFee = _marketingFee;
713     address payable public marketingWallet = payable(0x9329a24a4072454082db669eC09e6108298aEa0F);
714 
715     IUniswapV2Router02 public  uniswapV2Router;
716     address public  uniswapV2Pair;
717     
718     bool inSwapAndLiquify;
719     bool public swapAndLiquifyEnabled = true;
720 
721     uint256 public swapTokensAtAmount = 20000000 * 10**9;
722     uint256 public _maxTxAmount = 50000000 * 10**9;
723     uint256 public maxWalletToken = 50000000 * (10**9);
724     
725     uint256 public buyBackDivisor = 20;
726     
727     uint256 private buyBackUpperLimit = 1 * 10**17; // equal to 0.1 Ether
728     bool public buyBackEnabled = true;
729     event BuyBackEnabledUpdated(bool enabled);
730     
731     event SwapETHForTokens(
732         uint256 amountIn,
733         address[] path
734     );
735     
736     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
737     event SwapAndLiquifyEnabledUpdated(bool enabled);
738     event SwapAndLiquify(
739         uint256 tokensSwapped,
740         uint256 ethReceived
741     );
742     
743     modifier lockTheSwap {
744         inSwapAndLiquify = true;
745         _;
746         inSwapAndLiquify = false;
747     }
748     
749     constructor() {
750         _rOwned[owner()] = _rTotal;
751         
752         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
753          // Create a uniswap pair for this new token
754         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
755             .createPair(address(this), _uniswapV2Router.WETH());
756 
757         // set the rest of the contract variables
758         uniswapV2Router = _uniswapV2Router;
759         
760         //exclude owner and this contract from fee
761         _isExcludedFromFee[owner()] = true;
762         _isExcludedFromFee[marketingWallet] = true;
763         _isExcludedFromFee[address(this)] = true;
764         
765         emit Transfer(address(0), owner(), _tTotal);
766     }
767 
768     function name() public view returns (string memory) {
769         return _name;
770     }
771 
772     function symbol() public view returns (string memory) {
773         return _symbol;
774     }
775 
776     function decimals() public view returns (uint8) {
777         return _decimals;
778     }
779 
780     function totalSupply() public view override returns (uint256) {
781         return _tTotal;
782     }
783 
784     function balanceOf(address account) public view override returns (uint256) {
785         if (_isExcluded[account]) return _tOwned[account];
786         return tokenFromReflection(_rOwned[account]);
787     }
788 
789     function transfer(address recipient, uint256 amount) public override returns (bool) {
790         _transfer(_msgSender(), recipient, amount);
791         return true;
792     }
793 
794     function allowance(address owner, address spender) public view override returns (uint256) {
795         return _allowances[owner][spender];
796     }
797 
798     function approve(address spender, uint256 amount) public override returns (bool) {
799         _approve(_msgSender(), spender, amount);
800         return true;
801     }
802 
803     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
804         _transfer(sender, recipient, amount);
805         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
806         return true;
807     }
808 
809     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
810         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
811         return true;
812     }
813 
814     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
815         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
816         return true;
817     }
818 
819     function isExcludedFromReward(address account) public view returns (bool) {
820         return _isExcluded[account];
821     }
822 
823     function totalFees() public view returns (uint256) {
824         return _tFeeTotal;
825     }
826 
827     function deliver(uint256 tAmount) public {
828         address sender = _msgSender();
829         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
830         (uint256 rAmount,,,,,) = _getValues(tAmount);
831         _rOwned[sender] = _rOwned[sender].sub(rAmount);
832         _rTotal = _rTotal.sub(rAmount);
833         _tFeeTotal = _tFeeTotal.add(tAmount);
834     }
835 
836     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
837         require(tAmount <= _tTotal, "Amount must be less than supply");
838         if (!deductTransferFee) {
839             (uint256 rAmount,,,,,) = _getValues(tAmount);
840             return rAmount;
841         } else {
842             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
843             return rTransferAmount;
844         }
845     }
846 
847     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
848         require(rAmount <= _rTotal, "Amount must be less than total reflections");
849         uint256 currentRate =  _getRate();
850         return rAmount.div(currentRate);
851     }
852 
853     function excludeFromReward(address account) public onlyOwner() {
854         require(!_isExcluded[account], "Account is already excluded");
855         if(_rOwned[account] > 0) {
856             _tOwned[account] = tokenFromReflection(_rOwned[account]);
857         }
858         _isExcluded[account] = true;
859         _excluded.push(account);
860     }
861 
862     function includeInReward(address account) external onlyOwner() {
863         require(_isExcluded[account], "Account is already excluded");
864         for (uint256 i = 0; i < _excluded.length; i++) {
865             if (_excluded[i] == account) {
866                 _excluded[i] = _excluded[_excluded.length - 1];
867                 _tOwned[account] = 0;
868                 _isExcluded[account] = false;
869                 _excluded.pop();
870                 break;
871             }
872         }
873     }
874 
875     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
876         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBuyback) = _getValues(tAmount);
877         _tOwned[sender] = _tOwned[sender].sub(tAmount);
878         _rOwned[sender] = _rOwned[sender].sub(rAmount);
879         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
880         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
881         _takeBuyback(tBuyback);
882         _reflectFee(rFee, tFee);
883         emit Transfer(sender, recipient, tTransferAmount);
884     }
885     
886 
887     
888      //to recieve ETH from uniswapV2Router when swaping
889     receive() external payable {}
890 
891     function _reflectFee(uint256 rFee, uint256 tFee) private {
892         _rTotal = _rTotal.sub(rFee);
893         _tFeeTotal = _tFeeTotal.add(tFee);
894     }
895 
896     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
897         (uint256 tTransferAmount, uint256 tFee, uint256 tBuyback) = _getTValues(tAmount);
898         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tBuyback, _getRate());
899         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tBuyback);
900     }
901 
902     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
903         uint256 tFee = calculateTaxFee(tAmount);
904         uint256 tBuyback = calculateBuybackFee(tAmount);
905         uint256 tTransferAmount = tAmount.sub(tFee).sub(tBuyback);
906         return (tTransferAmount, tFee, tBuyback);
907     }
908 
909     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tBuyback, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
910         uint256 rAmount = tAmount.mul(currentRate);
911         uint256 rFee = tFee.mul(currentRate);
912         uint256 rBuyback = tBuyback.mul(currentRate);
913         uint256 rTransferAmount = rAmount.sub(rFee).sub(rBuyback);
914         return (rAmount, rTransferAmount, rFee);
915     }
916 
917     function _getRate() private view returns(uint256) {
918         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
919         return rSupply.div(tSupply);
920     }
921 
922     function _getCurrentSupply() private view returns(uint256, uint256) {
923         uint256 rSupply = _rTotal;
924         uint256 tSupply = _tTotal;      
925         for (uint256 i = 0; i < _excluded.length; i++) {
926             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
927             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
928             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
929         }
930         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
931         return (rSupply, tSupply);
932     }
933     
934     function _takeBuyback(uint256 tBuyback) private {
935         uint256 currentRate =  _getRate();
936         uint256 rBuyback = tBuyback.mul(currentRate);
937         _rOwned[address(this)] = _rOwned[address(this)].add(rBuyback);
938         if(_isExcluded[address(this)])
939             _tOwned[address(this)] = _tOwned[address(this)].add(tBuyback);
940     }
941     
942     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
943         return _amount.mul(_taxFee).div(
944             10**2
945         );
946     }
947 
948     function calculateBuybackFee(uint256 _amount) private view returns (uint256) {
949         return _amount.mul(_buybackFee).div(
950             10**2
951         );
952     }
953     
954     function removeAllFee() private {
955         if(_taxFee == 0 && _buybackFee == 0 && _marketingFee==0) return;
956         
957         _previousTaxFee = _taxFee;
958         _previousBuybackFee = _buybackFee;
959         _previousMarketingFee = _marketingFee;
960         
961         _taxFee = 0;
962         _buybackFee = 0;
963         _marketingFee = 0;
964     }
965     
966     function restoreAllFee() private {
967        _taxFee = _previousTaxFee;
968        _buybackFee = _previousBuybackFee;
969        _marketingFee = _previousMarketingFee;
970     }
971     
972     function isExcludedFromFee(address account) public view returns(bool) {
973         return _isExcludedFromFee[account];
974     }
975 
976     function _approve(address owner, address spender, uint256 amount) private {
977         require(owner != address(0), "ERC20: approve from the zero address");
978         require(spender != address(0), "ERC20: approve to the zero address");
979 
980         _allowances[owner][spender] = amount;
981         emit Approval(owner, spender, amount);
982     }
983 
984     function _transfer(
985         address from,
986         address to,
987         uint256 amount
988     ) private {
989         require(from != address(0), "ERC20: transfer from the zero address");
990         require(amount > 0, "Transfer amount must be greater than zero");
991         require(!_isBlacklisted[from] && !_isBlacklisted[to], 'Blacklisted address');
992         
993         bool excludedAccount = _isExcludedFromFee[from] || _isExcludedFromFee[to];
994         
995         if (uniswapV2Pair==from && !excludedAccount) {
996             uint256 contractBalanceRecepient = balanceOf(to);
997             require(contractBalanceRecepient + amount <= maxWalletToken,
998                 "Exceeds maximum wallet token amount."
999             );
1000         }
1001 
1002         // is the token balance of this contract address over the min number of
1003         // tokens that we need to initiate a swap ?
1004         // also, don't swap & liquify if sender is uniswap pair.
1005         uint256 contractTokenBalance = balanceOf(address(this));        
1006         bool overMinTokenBalance = contractTokenBalance >= swapTokensAtAmount;
1007         if (
1008             !inSwapAndLiquify &&
1009             from != uniswapV2Pair &&
1010             swapAndLiquifyEnabled
1011         ) {
1012             contractTokenBalance = swapTokensAtAmount;
1013             
1014             //swap tokens for buyback and marketing
1015             if(overMinTokenBalance) {
1016                 swapTokens(contractTokenBalance);
1017             }
1018             
1019             uint256 balance = address(this).balance;
1020             if (buyBackEnabled && balance > uint256(buyBackUpperLimit)) {
1021                 
1022                 if (balance > buyBackUpperLimit)
1023                     balance = buyBackUpperLimit;
1024                 
1025                 buyBackTokens(balance.div(buyBackDivisor));
1026             }
1027         }
1028         
1029         //transfer amount, it will take tax, marketing, buyback fee
1030         _tokenTransfer(from,to,amount);
1031     }
1032 
1033     function swapTokens(uint256 contractTokenBalance) private lockTheSwap {
1034         
1035         uint256 initialBalance = address(this).balance;
1036 
1037         // swap tokens for ETH
1038         swapTokensForEth(contractTokenBalance);
1039 
1040         // how much ETH did we just swap into?
1041         uint256 newBalance = address(this).balance.sub(initialBalance);
1042         
1043         uint256 marketingShare = newBalance.mul(_marketingFee).div(_marketingFee.add(_buybackFee));
1044 
1045           //Send to Marketing address
1046         transferToAddressETH(marketingWallet, marketingShare);
1047         
1048         emit SwapAndLiquify(contractTokenBalance, newBalance);
1049     }
1050     
1051     function buyBackTokens(uint256 amount) private lockTheSwap {
1052     	if (amount > 0) {
1053     	    swapETHForTokens(amount);
1054 	    }
1055     }
1056 
1057     function swapTokensForEth(uint256 tokenAmount) private {
1058         // generate the uniswap pair path of token -> weth
1059         address[] memory path = new address[](2);
1060         path[0] = address(this);
1061         path[1] = uniswapV2Router.WETH();
1062 
1063         _approve(address(this), address(uniswapV2Router), tokenAmount);
1064 
1065         // make the swap
1066         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1067             tokenAmount,
1068             0, // accept any amount of ETH
1069             path,
1070             address(this),
1071             block.timestamp
1072         );
1073     }
1074     
1075     function swapETHForTokens(uint256 amount) private {
1076         // generate the uniswap pair path of token -> weth
1077         address[] memory path = new address[](2);
1078         path[0] = uniswapV2Router.WETH();
1079         path[1] = address(this);
1080 
1081       // make the swap
1082         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
1083             0, // accept any amount of Tokens
1084             path,
1085             deadWallet, // Burn address
1086             block.timestamp.add(300)
1087         );
1088         
1089         emit SwapETHForTokens(amount, path);
1090     }
1091 
1092     //this method is responsible for taking all fee, if takeFee is true
1093     function _tokenTransfer(address sender, address recipient, uint256 amount) private 
1094     {
1095         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient])
1096         {   
1097            removeAllFee(); 
1098         }
1099         else  
1100         {
1101             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1102         }
1103 
1104         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1105             _transferFromExcluded(sender, recipient, amount);
1106         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1107             _transferToExcluded(sender, recipient, amount);
1108         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1109             _transferStandard(sender, recipient, amount);
1110         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1111             _transferBothExcluded(sender, recipient, amount);
1112         } else {
1113             _transferStandard(sender, recipient, amount);
1114         }
1115         
1116         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient])
1117         {
1118             restoreAllFee();
1119         }
1120     }
1121 
1122 
1123 
1124     function _transferStandard(address sender, address recipient, uint256 tAmount) private 
1125     {
1126         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBuyback) = _getValues(tAmount);
1127         (tTransferAmount, rTransferAmount) = takeMarketing(sender, tTransferAmount, rTransferAmount, tAmount);
1128         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1129         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1130         _takeBuyback(tBuyback);
1131         _reflectFee(rFee, tFee);
1132         emit Transfer(sender, recipient, tTransferAmount);
1133     }
1134 
1135 
1136     function takeMarketing(address sender, uint256 tTransferAmount, uint256 rTransferAmount, uint256 tAmount) private
1137     returns (uint256, uint256)
1138     {
1139         if(_marketingFee==0) {  return(tTransferAmount, rTransferAmount); }
1140         uint256 tMarketing = tAmount.div(100).mul(_marketingFee);
1141         uint256 rMarketing = tMarketing.mul(_getRate());
1142         rTransferAmount = rTransferAmount.sub(rMarketing);
1143         tTransferAmount = tTransferAmount.sub(tMarketing);
1144         _rOwned[address(this)] = _rOwned[address(this)].add(rMarketing);
1145         emit Transfer(sender, address(this), tMarketing);
1146         return(tTransferAmount, rTransferAmount);
1147     }
1148 
1149     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1150         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBuyback) = _getValues(tAmount);
1151         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1152         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1153         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1154         _takeBuyback(tBuyback);
1155         _reflectFee(rFee, tFee);
1156         emit Transfer(sender, recipient, tTransferAmount);
1157     }
1158 
1159     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1160         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBuyback) = _getValues(tAmount);
1161         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1162         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1163         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1164         _takeBuyback(tBuyback);
1165         _reflectFee(rFee, tFee);
1166         emit Transfer(sender, recipient, tTransferAmount);
1167     }
1168 
1169     function excludeFromFee(address account) public onlyOwner {
1170         _isExcludedFromFee[account] = true;
1171     }
1172     
1173     function includeInFee(address account) public onlyOwner {
1174         _isExcludedFromFee[account] = false;
1175     }
1176     
1177     function blacklistAddress(address account, bool value) external onlyOwner{
1178         _isBlacklisted[account] = value;
1179     }
1180     
1181     function buyBackUpperLimitAmount() public view returns (uint256) {
1182         return buyBackUpperLimit;
1183     }
1184     
1185     function SetBuyBackUpperLimit(uint256 newLimit) external onlyOwner {
1186         buyBackUpperLimit = newLimit;
1187     }
1188     
1189     function setMaxWalletTokend(uint256 _maxToken) external onlyOwner {
1190   	    maxWalletToken = _maxToken * (10**9);
1191   	}
1192   	
1193   	function setBuyBackDivisor(uint256 divisor) external onlyOwner {
1194   	    buyBackDivisor = divisor;
1195   	}
1196     
1197     function setMarketingWallet(address payable newWallet) external onlyOwner() {
1198         marketingWallet = newWallet;
1199     }
1200     
1201     function setFeePercent(uint256 taxFee, uint256 buybackFee, uint256 marketingFee) external onlyOwner() {
1202         require(taxFee > 0 && buybackFee > 0 && marketingFee > 0);
1203         _taxFee = taxFee;
1204         _buybackFee = buybackFee;
1205         _marketingFee = marketingFee;
1206     }
1207     
1208     function setSwapTokensAtAmount(uint256 newAmount) external onlyOwner() {
1209         swapTokensAtAmount = newAmount*10**9;
1210     }
1211     
1212     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1213         require(maxTxAmount > 0, "transaction amount must be greater than zero");
1214         _maxTxAmount = maxTxAmount * 10**9;
1215     }
1216 
1217     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1218         swapAndLiquifyEnabled = _enabled;
1219         emit SwapAndLiquifyEnabledUpdated(_enabled);
1220     }
1221     
1222     function setBuyBackEnabled(bool _enabled) public onlyOwner {
1223         buyBackEnabled = _enabled;
1224         emit BuyBackEnabledUpdated(_enabled);
1225     }
1226     
1227     function prepareForPreSale() external onlyOwner {
1228         setSwapAndLiquifyEnabled(false);
1229         _taxFee = 0;
1230         _buybackFee = 0;
1231         _marketingFee = 0;
1232         _maxTxAmount = 5000000000 * 10**9;
1233         maxWalletToken = 5000000000 * 10**9;
1234     }
1235     
1236     function afterPreSale() external onlyOwner {
1237         setSwapAndLiquifyEnabled(true);
1238         _taxFee = 1;
1239         _buybackFee = 2;
1240         _marketingFee = 6;
1241         _maxTxAmount = 50000000 * 10**9;
1242         maxWalletToken = 50000000 * 10**9;
1243     }
1244     
1245     function transferToAddressETH(address payable recipient, uint256 amount) private {
1246         recipient.transfer(amount);
1247     }
1248     
1249 }