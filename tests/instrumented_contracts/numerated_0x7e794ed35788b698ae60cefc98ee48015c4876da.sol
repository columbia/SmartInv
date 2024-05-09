1 /**
2  *Submitted for verification at Etherscan.io on 2022-02-01
3 */
4 
5 /**
6  *
7  *
8  *    _____ _    _ _____ _   _ _______       __  __          
9  *   / ____| |  | |_   _| \ | |__   __|/\   |  \/  |   /\    
10  *  | (___ | |__| | | | |  \| |  | |  /  \  | \  / |  /  \   
11  *   \___ \|  __  | | | | . ` |  | | / /\ \ | |\/| | / /\ \  
12  *   ____) | |  | |_| |_| |\  |  | |/ ____ \| |  | |/ ____ \ 
13  *  |_____/|_|  |_|_____|_| \_|  |_/_/    \_\_|  |_/_/    \_\
14  *                                                        
15  * 
16  *                                                                           
17  *                                                                           
18 */                                                                           
19 
20 // Shintama
21 // Website: https://shintamatoken.com
22 // Twitter: https://twitter.com/SHINTAMAToken
23 // TG: https://t.me/SHINTAMA_Join
24 // Instagram: https://www.instagram.com/shintama_official
25 // Reddit: https://www.reddit.com/r/Shintama/
26 // Shintama Announcements: https://t.me/shintamaannouncements
27 
28 pragma solidity ^0.8.9;
29 // SPDX-License-Identifier: Unlicensed
30 interface IERC20 {
31 
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
99 
100 
101 /**
102  * @dev Wrappers over Solidity's arithmetic operations with added overflow
103  * checks.
104  *
105  * Arithmetic operations in Solidity wrap on overflow. This can easily result
106  * in bugs, because programmers usually assume that an overflow raises an
107  * error, which is the standard behavior in high level programming languages.
108  * `SafeMath` restores this intuition by reverting the transaction when an
109  * operation overflows.
110  *
111  * Using this library instead of the unchecked operations eliminates an entire
112  * class of bugs, so it's recommended to use it always.
113  */
114  
115 library SafeMath {
116     /**
117      * @dev Returns the addition of two unsigned integers, reverting on
118      * overflow.
119      *
120      * Counterpart to Solidity's `+` operator.
121      *
122      * Requirements:
123      *
124      * - Addition cannot overflow.
125      */
126     function add(uint256 a, uint256 b) internal pure returns (uint256) {
127         uint256 c = a + b;
128         require(c >= a, "SafeMath: addition overflow");
129 
130         return c;
131     }
132 
133     /**
134      * @dev Returns the subtraction of two unsigned integers, reverting on
135      * overflow (when the result is negative).
136      *
137      * Counterpart to Solidity's `-` operator.
138      *
139      * Requirements:
140      *
141      * - Subtraction cannot overflow.
142      */
143     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
144         return sub(a, b, "SafeMath: subtraction overflow");
145     }
146 
147     /**
148      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
149      * overflow (when the result is negative).
150      *
151      * Counterpart to Solidity's `-` operator.
152      *
153      * Requirements:
154      *
155      * - Subtraction cannot overflow.
156      */
157     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b <= a, errorMessage);
159         uint256 c = a - b;
160 
161         return c;
162     }
163 
164     /**
165      * @dev Returns the multiplication of two unsigned integers, reverting on
166      * overflow.
167      *
168      * Counterpart to Solidity's `*` operator.
169      *
170      * Requirements:
171      *
172      * - Multiplication cannot overflow.
173      */
174     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
175         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
176         // benefit is lost if 'b' is also tested.
177         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
178         if (a == 0) {
179             return 0;
180         }
181 
182         uint256 c = a * b;
183         require(c / a == b, "SafeMath: multiplication overflow");
184 
185         return c;
186     }
187 
188     /**
189      * @dev Returns the integer division of two unsigned integers. Reverts on
190      * division by zero. The result is rounded towards zero.
191      *
192      * Counterpart to Solidity's `/` operator. Note: this function uses a
193      * `revert` opcode (which leaves remaining gas untouched) while Solidity
194      * uses an invalid opcode to revert (consuming all remaining gas).
195      *
196      * Requirements:
197      *
198      * - The divisor cannot be zero.
199      */
200     function div(uint256 a, uint256 b) internal pure returns (uint256) {
201         return div(a, b, "SafeMath: division by zero");
202     }
203 
204     /**
205      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
206      * division by zero. The result is rounded towards zero.
207      *
208      * Counterpart to Solidity's `/` operator. Note: this function uses a
209      * `revert` opcode (which leaves remaining gas untouched) while Solidity
210      * uses an invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      *
214      * - The divisor cannot be zero.
215      */
216     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
217         require(b > 0, errorMessage);
218         uint256 c = a / b;
219         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
220 
221         return c;
222     }
223 
224     /**
225      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
226      * Reverts when dividing by zero.
227      *
228      * Counterpart to Solidity's `%` operator. This function uses a `revert`
229      * opcode (which leaves remaining gas untouched) while Solidity uses an
230      * invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
237         return mod(a, b, "SafeMath: modulo by zero");
238     }
239 
240     /**
241      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
242      * Reverts with custom message when dividing by zero.
243      *
244      * Counterpart to Solidity's `%` operator. This function uses a `revert`
245      * opcode (which leaves remaining gas untouched) while Solidity uses an
246      * invalid opcode to revert (consuming all remaining gas).
247      *
248      * Requirements:
249      *
250      * - The divisor cannot be zero.
251      */
252     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
253         require(b != 0, errorMessage);
254         return a % b;
255     }
256 }
257 
258 abstract contract Context {
259     //function _msgSender() internal view virtual returns (address payable) {
260     function _msgSender() internal view virtual returns (address) {
261         return msg.sender;
262     }
263 
264     function _msgData() internal view virtual returns (bytes memory) {
265         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
266         return msg.data;
267     }
268 }
269 
270 
271 /**
272  * @dev Collection of functions related to the address type
273  */
274 library Address {
275     /**
276      * @dev Returns true if `account` is a contract.
277      *
278      * [IMPORTANT]
279      * ====
280      * It is unsafe to assume that an address for which this function returns
281      * false is an externally-owned account (EOA) and not a contract.
282      *
283      * Among others, `isContract` will return false for the following
284      * types of addresses:
285      *
286      *  - an externally-owned account
287      *  - a contract in construction
288      *  - an address where a contract will be created
289      *  - an address where a contract lived, but was destroyed
290      * ====
291      */
292     function isContract(address account) internal view returns (bool) {
293         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
294         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
295         // for accounts without code, i.e. `keccak256('')`
296         bytes32 codehash;
297         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
298         // solhint-disable-next-line no-inline-assembly
299         assembly { codehash := extcodehash(account) }
300         return (codehash != accountHash && codehash != 0x0);
301     }
302 
303     /**
304      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
305      * `recipient`, forwarding all available gas and reverting on errors.
306      *
307      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
308      * of certain opcodes, possibly making contracts go over the 2300 gas limit
309      * imposed by `transfer`, making them unable to receive funds via
310      * `transfer`. {sendValue} removes this limitation.
311      *
312      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
313      *
314      * IMPORTANT: because control is transferred to `recipient`, care must be
315      * taken to not create reentrancy vulnerabilities. Consider using
316      * {ReentrancyGuard} or the
317      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
318      */
319     function sendValue(address payable recipient, uint256 amount) internal {
320         require(address(this).balance >= amount, "Address: insufficient balance");
321 
322         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
323         (bool success, ) = recipient.call{ value: amount }("");
324         require(success, "Address: unable to send value, recipient may have reverted");
325     }
326 
327     /**
328      * @dev Performs a Solidity function call using a low level `call`. A
329      * plain`call` is an unsafe replacement for a function call: use this
330      * function instead.
331      *
332      * If `target` reverts with a revert reason, it is bubbled up by this
333      * function (like regular Solidity function calls).
334      *
335      * Returns the raw returned data. To convert to the expected return value,
336      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
337      *
338      * Requirements:
339      *
340      * - `target` must be a contract.
341      * - calling `target` with `data` must not revert.
342      *
343      * _Available since v3.1._
344      */
345     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
346       return functionCall(target, data, "Address: low-level call failed");
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
351      * `errorMessage` as a fallback revert reason when `target` reverts.
352      *
353      * _Available since v3.1._
354      */
355     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
356         return _functionCallWithValue(target, data, 0, errorMessage);
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
361      * but also transferring `value` wei to `target`.
362      *
363      * Requirements:
364      *
365      * - the calling contract must have an ETH balance of at least `value`.
366      * - the called Solidity function must be `payable`.
367      *
368      * _Available since v3.1._
369      */
370     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
371         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
376      * with `errorMessage` as a fallback revert reason when `target` reverts.
377      *
378      * _Available since v3.1._
379      */
380     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
381         require(address(this).balance >= value, "Address: insufficient balance for call");
382         return _functionCallWithValue(target, data, value, errorMessage);
383     }
384 
385     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
386         require(isContract(target), "Address: call to non-contract");
387 
388         // solhint-disable-next-line avoid-low-level-calls
389         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
390         if (success) {
391             return returndata;
392         } else {
393             // Look for revert reason and bubble it up if present
394             if (returndata.length > 0) {
395                 // The easiest way to bubble the revert reason is using memory via assembly
396 
397                 // solhint-disable-next-line no-inline-assembly
398                 assembly {
399                     let returndata_size := mload(returndata)
400                     revert(add(32, returndata), returndata_size)
401                 }
402             } else {
403                 revert(errorMessage);
404             }
405         }
406     }
407 }
408 
409 /**
410  * @dev Contract module which provides a basic access control mechanism, where
411  * there is an account (an owner) that can be granted exclusive access to
412  * specific functions.
413  *
414  * By default, the owner account will be the one that deploys the contract. This
415  * can later be changed with {transferOwnership}.
416  *
417  * This module is used through inheritance. It will make available the modifier
418  * `onlyOwner`, which can be applied to your functions to restrict their use to
419  * the owner.
420  */
421 contract Ownable is Context {
422     address private _owner;
423     address private _previousOwner;
424     uint256 private _lockTime;
425 
426     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
427 
428     /**
429      * @dev Initializes the contract setting the deployer as the initial owner.
430      */
431     constructor () {
432         address msgSender = _msgSender();
433         _owner = msgSender;
434         emit OwnershipTransferred(address(0), msgSender);
435     }
436 
437     /**
438      * @dev Returns the address of the current owner.
439      */
440     function owner() public view returns (address) {
441         return _owner;
442     }
443 
444     /**
445      * @dev Throws if called by any account other than the owner.
446      */
447     modifier onlyOwner() {
448         require(_owner == _msgSender(), "Ownable: caller is not the owner");
449         _;
450     }
451 
452      /**
453      * @dev Leaves the contract without owner. It will not be possible to call
454      * `onlyOwner` functions anymore. Can only be called by the current owner.
455      *
456      * NOTE: Renouncing ownership will leave the contract without an owner,
457      * thereby removing any functionality that is only available to the owner.
458      */
459     function renounceOwnership() public virtual onlyOwner {
460         emit OwnershipTransferred(_owner, address(0));
461         _owner = address(0);
462     }
463 
464     /**
465      * @dev Transfers ownership of the contract to a new account (`newOwner`).
466      * Can only be called by the current owner.
467      */
468     function transferOwnership(address newOwner) public virtual onlyOwner {
469         require(newOwner != address(0), "Ownable: new owner is the zero address");
470         emit OwnershipTransferred(_owner, newOwner);
471         _owner = newOwner;
472     }
473 
474     function geUnlockTime() public view returns (uint256) {
475         return _lockTime;
476     }
477 
478     //Locks the contract for owner for the amount of time provided
479     function lock(uint256 time) public virtual onlyOwner {
480         _previousOwner = _owner;
481         _owner = address(0);
482         _lockTime = block.timestamp + time;
483         emit OwnershipTransferred(_owner, address(0));
484     }
485     
486     //Unlocks the contract for owner when _lockTime is exceeds
487     function unlock() public virtual {
488         require(_previousOwner == msg.sender, "You don't have permission to unlock");
489         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
490         emit OwnershipTransferred(_owner, _previousOwner);
491         _owner = _previousOwner;
492     }
493 }
494 
495 
496 interface IUniswapV2Factory {
497     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
498 
499     function feeTo() external view returns (address);
500     function feeToSetter() external view returns (address);
501 
502     function getPair(address tokenA, address tokenB) external view returns (address pair);
503     function allPairs(uint) external view returns (address pair);
504     function allPairsLength() external view returns (uint);
505 
506     function createPair(address tokenA, address tokenB) external returns (address pair);
507 
508     function setFeeTo(address) external;
509     function setFeeToSetter(address) external;
510 }
511 
512 
513 
514 interface IUniswapV2Pair {
515     event Approval(address indexed owner, address indexed spender, uint value);
516     event Transfer(address indexed from, address indexed to, uint value);
517 
518     function name() external pure returns (string memory);
519     function symbol() external pure returns (string memory);
520     function decimals() external pure returns (uint8);
521     function totalSupply() external view returns (uint);
522     function balanceOf(address owner) external view returns (uint);
523     function allowance(address owner, address spender) external view returns (uint);
524 
525     function approve(address spender, uint value) external returns (bool);
526     function transfer(address to, uint value) external returns (bool);
527     function transferFrom(address from, address to, uint value) external returns (bool);
528 
529     function DOMAIN_SEPARATOR() external view returns (bytes32);
530     function PERMIT_TYPEHASH() external pure returns (bytes32);
531     function nonces(address owner) external view returns (uint);
532 
533     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
534 
535     event Mint(address indexed sender, uint amount0, uint amount1);
536     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
537     event Swap(
538         address indexed sender,
539         uint amount0In,
540         uint amount1In,
541         uint amount0Out,
542         uint amount1Out,
543         address indexed to
544     );
545     event Sync(uint112 reserve0, uint112 reserve1);
546 
547     function MINIMUM_LIQUIDITY() external pure returns (uint);
548     function factory() external view returns (address);
549     function token0() external view returns (address);
550     function token1() external view returns (address);
551     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
552     function price0CumulativeLast() external view returns (uint);
553     function price1CumulativeLast() external view returns (uint);
554     function kLast() external view returns (uint);
555 
556     function mint(address to) external returns (uint liquidity);
557     function burn(address to) external returns (uint amount0, uint amount1);
558     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
559     function skim(address to) external;
560     function sync() external;
561 
562     function initialize(address, address) external;
563 }
564 
565 
566 interface IUniswapV2Router01 {
567     function factory() external pure returns (address);
568     function WETH() external pure returns (address);
569 
570     function addLiquidity(
571         address tokenA,
572         address tokenB,
573         uint amountADesired,
574         uint amountBDesired,
575         uint amountAMin,
576         uint amountBMin,
577         address to,
578         uint deadline
579     ) external returns (uint amountA, uint amountB, uint liquidity);
580     function addLiquidityETH(
581         address token,
582         uint amountTokenDesired,
583         uint amountTokenMin,
584         uint amountETHMin,
585         address to,
586         uint deadline
587     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
588     function removeLiquidity(
589         address tokenA,
590         address tokenB,
591         uint liquidity,
592         uint amountAMin,
593         uint amountBMin,
594         address to,
595         uint deadline
596     ) external returns (uint amountA, uint amountB);
597     function removeLiquidityETH(
598         address token,
599         uint liquidity,
600         uint amountTokenMin,
601         uint amountETHMin,
602         address to,
603         uint deadline
604     ) external returns (uint amountToken, uint amountETH);
605     function removeLiquidityWithPermit(
606         address tokenA,
607         address tokenB,
608         uint liquidity,
609         uint amountAMin,
610         uint amountBMin,
611         address to,
612         uint deadline,
613         bool approveMax, uint8 v, bytes32 r, bytes32 s
614     ) external returns (uint amountA, uint amountB);
615     function removeLiquidityETHWithPermit(
616         address token,
617         uint liquidity,
618         uint amountTokenMin,
619         uint amountETHMin,
620         address to,
621         uint deadline,
622         bool approveMax, uint8 v, bytes32 r, bytes32 s
623     ) external returns (uint amountToken, uint amountETH);
624     function swapExactTokensForTokens(
625         uint amountIn,
626         uint amountOutMin,
627         address[] calldata path,
628         address to,
629         uint deadline
630     ) external returns (uint[] memory amounts);
631     function swapTokensForExactTokens(
632         uint amountOut,
633         uint amountInMax,
634         address[] calldata path,
635         address to,
636         uint deadline
637     ) external returns (uint[] memory amounts);
638     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
639         external
640         payable
641         returns (uint[] memory amounts);
642     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
643         external
644         returns (uint[] memory amounts);
645     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
646         external
647         returns (uint[] memory amounts);
648     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
649         external
650         payable
651         returns (uint[] memory amounts);
652 
653     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
654     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
655     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
656     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
657     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
658 }
659 
660 
661 
662 
663 interface IUniswapV2Router02 is IUniswapV2Router01 {
664     function removeLiquidityETHSupportingFeeOnTransferTokens(
665         address token,
666         uint liquidity,
667         uint amountTokenMin,
668         uint amountETHMin,
669         address to,
670         uint deadline
671     ) external returns (uint amountETH);
672     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
673         address token,
674         uint liquidity,
675         uint amountTokenMin,
676         uint amountETHMin,
677         address to,
678         uint deadline,
679         bool approveMax, uint8 v, bytes32 r, bytes32 s
680     ) external returns (uint amountETH);
681 
682     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
683         uint amountIn,
684         uint amountOutMin,
685         address[] calldata path,
686         address to,
687         uint deadline
688     ) external;
689     function swapExactETHForTokensSupportingFeeOnTransferTokens(
690         uint amountOutMin,
691         address[] calldata path,
692         address to,
693         uint deadline
694     ) external payable;
695     function swapExactTokensForETHSupportingFeeOnTransferTokens(
696         uint amountIn,
697         uint amountOutMin,
698         address[] calldata path,
699         address to,
700         uint deadline
701     ) external;
702 }
703 
704 interface IAirdrop {
705     function airdrop(address recipient, uint256 amount) external;
706 }
707 
708 contract Shintama is Context, IERC20, Ownable {
709     using SafeMath for uint256;
710     using Address for address;
711 
712     mapping (address => uint256) private _rOwned;
713     mapping (address => uint256) private _tOwned;
714     mapping (address => mapping (address => uint256)) private _allowances;
715 
716     mapping (address => bool) private _isExcludedFromFee;
717 
718     mapping (address => bool) private _isExcluded;
719     address[] private _excluded;
720     
721     mapping (address => bool) private botWallets;
722     bool botscantrade = false;
723     
724     bool public canTrade = false;
725    
726     uint256 private constant MAX = ~uint256(0);
727     uint256 private _tTotal = 69000000000000000000000 * 10**9;
728     uint256 private _rTotal = (MAX - (MAX % _tTotal));
729     uint256 private _tFeeTotal;
730     address public marketingWallet;
731 
732     string private _name = "Shintama";
733     string private _symbol = "SHINTAMA";
734     uint8 private _decimals = 9;
735     
736     uint256 public _taxFee = 2;
737     uint256 private _previousTaxFee = _taxFee;
738 
739     uint256 public marketingFeePercent = 75;
740     
741     uint256 public _liquidityFee = 9;
742     uint256 private _previousLiquidityFee = _liquidityFee;
743 
744     IUniswapV2Router02 public immutable uniswapV2Router;
745     address public immutable uniswapV2Pair;
746     
747     bool inSwapAndLiquify;
748     bool public swapAndLiquifyEnabled = true;
749     
750     uint256 public _maxTxAmount = 345000000000000000000 * 10**9;
751     uint256 public numTokensSellToAddToLiquidity = 690000000000000000000 * 10**9;
752     uint256 public _maxWalletSize = 690000000000000000000 * 10**9;
753     
754     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
755     event SwapAndLiquifyEnabledUpdated(bool enabled);
756     event SwapAndLiquify(
757         uint256 tokensSwapped,
758         uint256 ethReceived,
759         uint256 tokensIntoLiqudity
760     );
761     
762     modifier lockTheSwap {
763         inSwapAndLiquify = true;
764         _;
765         inSwapAndLiquify = false;
766     }
767     
768     constructor () {
769         _rOwned[_msgSender()] = _rTotal;
770         
771         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); //Mainnet & Testnet ETH
772          // Create a uniswap pair for this new token
773         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
774             .createPair(address(this), _uniswapV2Router.WETH());
775 
776         // set the rest of the contract variables
777         uniswapV2Router = _uniswapV2Router;
778         
779         //exclude owner and this contract from fee
780         _isExcludedFromFee[owner()] = true;
781         _isExcludedFromFee[address(this)] = true;
782         
783         emit Transfer(address(0), _msgSender(), _tTotal);
784     }
785 
786     function name() public view returns (string memory) {
787         return _name;
788     }
789 
790     function symbol() public view returns (string memory) {
791         return _symbol;
792     }
793 
794     function decimals() public view returns (uint8) {
795         return _decimals;
796     }
797 
798     function totalSupply() public view override returns (uint256) {
799         return _tTotal;
800     }
801 
802     function balanceOf(address account) public view override returns (uint256) {
803         if (_isExcluded[account]) return _tOwned[account];
804         return tokenFromReflection(_rOwned[account]);
805     }
806 
807     function transfer(address recipient, uint256 amount) public override returns (bool) {
808         _transfer(_msgSender(), recipient, amount);
809         return true;
810     }
811 
812     function allowance(address owner, address spender) public view override returns (uint256) {
813         return _allowances[owner][spender];
814     }
815 
816     function approve(address spender, uint256 amount) public override returns (bool) {
817         _approve(_msgSender(), spender, amount);
818         return true;
819     }
820 
821     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
822         _transfer(sender, recipient, amount);
823         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
824         return true;
825     }
826 
827     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
828         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
829         return true;
830     }
831 
832     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
833         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
834         return true;
835     }
836 
837     function isExcludedFromReward(address account) public view returns (bool) {
838         return _isExcluded[account];
839     }
840 
841     function totalFees() public view returns (uint256) {
842         return _tFeeTotal;
843     }
844     
845     function airdrop(address recipient, uint256 amount) external onlyOwner() {
846         removeAllFee();
847         _transfer(_msgSender(), recipient, amount * 10**9);
848         restoreAllFee();
849     }
850     
851     function airdropInternal(address recipient, uint256 amount) internal {
852         removeAllFee();
853         _transfer(_msgSender(), recipient, amount);
854         restoreAllFee();
855     }
856     
857     function airdropArray(address[] calldata newholders, uint256[] calldata amounts) external onlyOwner(){
858         uint256 iterator = 0;
859         require(newholders.length == amounts.length, "must be the same length");
860         while(iterator < newholders.length){
861             airdropInternal(newholders[iterator], amounts[iterator] * 10**9);
862             iterator += 1;
863         }
864     }
865 
866     function deliver(uint256 tAmount) public {
867         address sender = _msgSender();
868         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
869         (uint256 rAmount,,,,,) = _getValues(tAmount);
870         _rOwned[sender] = _rOwned[sender].sub(rAmount);
871         _rTotal = _rTotal.sub(rAmount);
872         _tFeeTotal = _tFeeTotal.add(tAmount);
873     }
874 
875     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
876         require(tAmount <= _tTotal, "Amount must be less than supply");
877         if (!deductTransferFee) {
878             (uint256 rAmount,,,,,) = _getValues(tAmount);
879             return rAmount;
880         } else {
881             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
882             return rTransferAmount;
883         }
884     }
885 
886     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
887         require(rAmount <= _rTotal, "Amount must be less than total reflections");
888         uint256 currentRate =  _getRate();
889         return rAmount.div(currentRate);
890     }
891 
892     function excludeFromReward(address account) public onlyOwner() {
893         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
894         require(!_isExcluded[account], "Account is already excluded");
895         if(_rOwned[account] > 0) {
896             _tOwned[account] = tokenFromReflection(_rOwned[account]);
897         }
898         _isExcluded[account] = true;
899         _excluded.push(account);
900     }
901 
902     function includeInReward(address account) external onlyOwner() {
903         require(_isExcluded[account], "Account is already excluded");
904         for (uint256 i = 0; i < _excluded.length; i++) {
905             if (_excluded[i] == account) {
906                 _excluded[i] = _excluded[_excluded.length - 1];
907                 _tOwned[account] = 0;
908                 _isExcluded[account] = false;
909                 _excluded.pop();
910                 break;
911             }
912         }
913     }
914         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
915         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
916         _tOwned[sender] = _tOwned[sender].sub(tAmount);
917         _rOwned[sender] = _rOwned[sender].sub(rAmount);
918         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
919         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
920         _takeLiquidity(tLiquidity);
921         _reflectFee(rFee, tFee);
922         emit Transfer(sender, recipient, tTransferAmount);
923     }
924     
925     function excludeFromFee(address account) public onlyOwner {
926         _isExcludedFromFee[account] = true;
927     }
928     
929     function includeInFee(address account) public onlyOwner {
930         _isExcludedFromFee[account] = false;
931     }
932     function setMarketingFeePercent(uint256 fee) public onlyOwner {
933         marketingFeePercent = fee;
934     }
935 
936     function setMarketingWallet(address walletAddress) public onlyOwner {
937         marketingWallet = walletAddress;
938     }
939     
940     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
941         require(taxFee < 10, "Tax fee cannot be more than 10%");
942         _taxFee = taxFee;
943     }
944     
945     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
946         _liquidityFee = liquidityFee;
947     }
948 
949     function _setMaxWalletSizePercent(uint256 maxWalletSize)
950         external
951         onlyOwner
952     {
953         _maxWalletSize = _tTotal.mul(maxWalletSize).div(10**3);
954     }
955    
956     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
957         require(maxTxAmount > 69000000, "Max Tx Amount cannot be less than 69 Million");
958         _maxTxAmount = maxTxAmount * 10**9;
959     }
960     
961     function setSwapThresholdAmount(uint256 SwapThresholdAmount) external onlyOwner() {
962         require(SwapThresholdAmount > 69000000, "Swap Threshold Amount cannot be less than 69 Million");
963         numTokensSellToAddToLiquidity = SwapThresholdAmount * 10**9;
964     }
965     
966     function claimTokens () public onlyOwner {
967         // make sure we capture all BNB that may or may not be sent to this contract
968         payable(marketingWallet).transfer(address(this).balance);
969     }
970     
971     function claimOtherTokens(IERC20 tokenAddress, address walletaddress) external onlyOwner() {
972         tokenAddress.transfer(walletaddress, tokenAddress.balanceOf(address(this)));
973     }
974     
975     function clearStuckBalance (address payable walletaddress) external onlyOwner() {
976         walletaddress.transfer(address(this).balance);
977     }
978     
979     function addBotWallet(address botwallet) external onlyOwner() {
980         botWallets[botwallet] = true;
981     }
982     
983     function removeBotWallet(address botwallet) external onlyOwner() {
984         botWallets[botwallet] = false;
985     }
986     
987     function getBotWalletStatus(address botwallet) public view returns (bool) {
988         return botWallets[botwallet];
989     }
990     
991     function allowtrading()external onlyOwner() {
992         canTrade = true;
993     }
994 
995     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
996         swapAndLiquifyEnabled = _enabled;
997         emit SwapAndLiquifyEnabledUpdated(_enabled);
998     }
999     
1000      //to recieve ETH from uniswapV2Router when swaping
1001     receive() external payable {}
1002 
1003     function _reflectFee(uint256 rFee, uint256 tFee) private {
1004         _rTotal = _rTotal.sub(rFee);
1005         _tFeeTotal = _tFeeTotal.add(tFee);
1006     }
1007 
1008     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1009         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
1010         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
1011         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
1012     }
1013 
1014     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1015         uint256 tFee = calculateTaxFee(tAmount);
1016         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1017         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1018         return (tTransferAmount, tFee, tLiquidity);
1019     }
1020 
1021     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1022         uint256 rAmount = tAmount.mul(currentRate);
1023         uint256 rFee = tFee.mul(currentRate);
1024         uint256 rLiquidity = tLiquidity.mul(currentRate);
1025         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1026         return (rAmount, rTransferAmount, rFee);
1027     }
1028 
1029     function _getRate() private view returns(uint256) {
1030         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1031         return rSupply.div(tSupply);
1032     }
1033 
1034     function _getCurrentSupply() private view returns(uint256, uint256) {
1035         uint256 rSupply = _rTotal;
1036         uint256 tSupply = _tTotal;      
1037         for (uint256 i = 0; i < _excluded.length; i++) {
1038             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1039             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1040             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1041         }
1042         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1043         return (rSupply, tSupply);
1044     }
1045     
1046     function _takeLiquidity(uint256 tLiquidity) private {
1047         uint256 currentRate =  _getRate();
1048         uint256 rLiquidity = tLiquidity.mul(currentRate);
1049         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1050         if(_isExcluded[address(this)])
1051             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1052     }
1053     
1054     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1055         return _amount.mul(_taxFee).div(
1056             10**2
1057         );
1058     }
1059 
1060     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1061         return _amount.mul(_liquidityFee).div(
1062             10**2
1063         );
1064     }
1065     
1066     function removeAllFee() private {
1067         if(_taxFee == 0 && _liquidityFee == 0) return;
1068         
1069         _previousTaxFee = _taxFee;
1070         _previousLiquidityFee = _liquidityFee;
1071         
1072         _taxFee = 0;
1073         _liquidityFee = 0;
1074     }
1075     
1076     function restoreAllFee() private {
1077         _taxFee = _previousTaxFee;
1078         _liquidityFee = _previousLiquidityFee;
1079     }
1080     
1081     function isExcludedFromFee(address account) public view returns(bool) {
1082         return _isExcludedFromFee[account];
1083     }
1084 
1085     function _approve(address owner, address spender, uint256 amount) private {
1086         require(owner != address(0), "ERC20: approve from the zero address");
1087         require(spender != address(0), "ERC20: approve to the zero address");
1088 
1089         _allowances[owner][spender] = amount;
1090         emit Approval(owner, spender, amount);
1091     }
1092 
1093     function _transfer(
1094         address from,
1095         address to,
1096         uint256 amount
1097     ) private {
1098         require(from != address(0), "ERC20: transfer from the zero address");
1099         require(to != address(0), "ERC20: transfer to the zero address");
1100         require(amount > 0, "Transfer amount must be greater than zero");
1101         if(from != owner() && to != owner())
1102             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1103 
1104         // is the token balance of this contract address over the min number of
1105         // tokens that we need to initiate a swap + liquidity lock?
1106         // also, don't get caught in a circular liquidity event.
1107         // also, don't swap & liquify if sender is uniswap pair.
1108         uint256 contractTokenBalance = balanceOf(address(this));
1109         
1110         if(contractTokenBalance >= _maxTxAmount)
1111         {
1112             contractTokenBalance = _maxTxAmount;
1113         }
1114         
1115         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1116         if (
1117             overMinTokenBalance &&
1118             !inSwapAndLiquify &&
1119             from != uniswapV2Pair &&
1120             swapAndLiquifyEnabled
1121         ) {
1122             contractTokenBalance = numTokensSellToAddToLiquidity;
1123             //add liquidity
1124             swapAndLiquify(contractTokenBalance);
1125         }
1126         
1127         //indicates if fee should be deducted from transfer
1128         bool takeFee = true;
1129         
1130         //if any account belongs to _isExcludedFromFee account then remove the fee
1131         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1132             takeFee = false;
1133         }
1134 
1135         if (takeFee) {
1136             if (to != uniswapV2Pair) {
1137                 require(
1138                     amount + balanceOf(to) <= _maxWalletSize,
1139                     "Recipient exceeds max wallet size."
1140                 );
1141             }
1142         }
1143         
1144         
1145         //transfer amount, it will take tax, burn, liquidity fee
1146         _tokenTransfer(from,to,amount,takeFee);
1147     }
1148 
1149     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1150         // split the contract balance into halves
1151         // add the marketing wallet
1152         uint256 half = contractTokenBalance.div(2);
1153         uint256 otherHalf = contractTokenBalance.sub(half);
1154 
1155         // capture the contract's current ETH balance.
1156         // this is so that we can capture exactly the amount of ETH that the
1157         // swap creates, and not make the liquidity event include any ETH that
1158         // has been manually sent to the contract
1159         uint256 initialBalance = address(this).balance;
1160 
1161         // swap tokens for ETH
1162         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1163 
1164         // how much ETH did we just swap into?
1165         uint256 newBalance = address(this).balance.sub(initialBalance);
1166         uint256 marketingshare = newBalance.mul(marketingFeePercent).div(100);
1167         payable(marketingWallet).transfer(marketingshare);
1168         newBalance -= marketingshare;
1169         // add liquidity to uniswap
1170         addLiquidity(otherHalf, newBalance);
1171         
1172         emit SwapAndLiquify(half, newBalance, otherHalf);
1173     }
1174 
1175     function swapTokensForEth(uint256 tokenAmount) private {
1176         // generate the uniswap pair path of token -> weth
1177         address[] memory path = new address[](2);
1178         path[0] = address(this);
1179         path[1] = uniswapV2Router.WETH();
1180 
1181         _approve(address(this), address(uniswapV2Router), tokenAmount);
1182 
1183         // make the swap
1184         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1185             tokenAmount,
1186             0, // accept any amount of ETH
1187             path,
1188             address(this),
1189             block.timestamp
1190         );
1191     }
1192 
1193     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1194         // approve token transfer to cover all possible scenarios
1195         _approve(address(this), address(uniswapV2Router), tokenAmount);
1196 
1197         // add the liquidity
1198         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1199             address(this),
1200             tokenAmount,
1201             0, // slippage is unavoidable
1202             0, // slippage is unavoidable
1203             owner(),
1204             block.timestamp
1205         );
1206     }
1207 
1208     //this method is responsible for taking all fee, if takeFee is true
1209     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1210         if(!canTrade){
1211             require(sender == owner()); // only owner allowed to trade or add liquidity
1212         }
1213         
1214         if(botWallets[sender] || botWallets[recipient]){
1215             require(botscantrade, "bots arent allowed to trade");
1216         }
1217         
1218         if(!takeFee)
1219             removeAllFee();
1220         
1221         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1222             _transferFromExcluded(sender, recipient, amount);
1223         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1224             _transferToExcluded(sender, recipient, amount);
1225         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1226             _transferStandard(sender, recipient, amount);
1227         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1228             _transferBothExcluded(sender, recipient, amount);
1229         } else {
1230             _transferStandard(sender, recipient, amount);
1231         }
1232         
1233         if(!takeFee)
1234             restoreAllFee();
1235     }
1236 
1237     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1238         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1239         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1240         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1241         _takeLiquidity(tLiquidity);
1242         _reflectFee(rFee, tFee);
1243         emit Transfer(sender, recipient, tTransferAmount);
1244     }
1245 
1246     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1247         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1248         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1249         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1250         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1251         _takeLiquidity(tLiquidity);
1252         _reflectFee(rFee, tFee);
1253         emit Transfer(sender, recipient, tTransferAmount);
1254     }
1255 
1256     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1257         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1258         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1259         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1260         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1261         _takeLiquidity(tLiquidity);
1262         _reflectFee(rFee, tFee);
1263         emit Transfer(sender, recipient, tTransferAmount);
1264     }
1265 
1266 }