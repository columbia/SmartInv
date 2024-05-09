1 /**
2  * 
3 
4 ╭━━━┳━━━━╮╭━━━╮╱╱╱╱╱╱╱╱╭╮╱╱╱╱╭━━━━╮╱╱╱╱╭╮╱╭╮
5 ┃╭━╮┃╭╮╭╮┃┃╭━╮┃╱╱╱╱╱╱╱╭╯╰╮╱╱╱┃╭╮╭╮┃╱╱╱╭╯╰┳╯╰╮
6 ┃┃╱╰┻╯┃┃╰╯┃┃╱╰╋━┳╮╱╭┳━┻╮╭╋━━╮╰╯┃┃┣┫╭╮╭╋╮╭┻╮╭╋━━┳━╮
7 ┃┃╱╭╮╱┃┃╱╱┃┃╱╭┫╭┫┃╱┃┃╭╮┃┃┃╭╮┃╱╱┃┃┃╰╯╰╯┣┫┃╱┃┃┃┃━┫╭╯
8 ┃╰━╯┃╱┃┃╱╱┃╰━╯┃┃┃╰━╯┃╰╯┃╰┫╰╯┃╱╱┃┃╰╮╭╮╭┫┃╰╮┃╰┫┃━┫┃
9 ╰━━━╯╱╰╯╱╱╰━━━┻╯╰━╮╭┫╭━┻━┻━━╯╱╱╰╯╱╰╯╰╯╰┻━╯╰━┻━━┻╯
10 ╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╭━╯┃┃┃
11 ╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╱╰━━╯╰╯
12 
13  */
14 
15 
16 //SPDX-License-Identifier: MIT
17 pragma solidity ^0.6.12;
18 
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 
31 /**
32  * @dev Interface of the ERC20 standard as defined in the EIP.
33  */
34 interface IERC20 {
35     /**
36      * @dev Returns the amount of tokens in existence.
37      */
38     function totalSupply() external view returns (uint256);
39 
40     /**
41      * @dev Returns the amount of tokens owned by `account`.
42      */
43     function balanceOf(address account) external view returns (uint256);
44 
45     /**
46      * @dev Moves `amount` tokens from the caller's account to `recipient`.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * Emits a {Transfer} event.
51      */
52     function transfer(address recipient, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Returns the remaining number of tokens that `spender` will be
56      * allowed to spend on behalf of `owner` through {transferFrom}. This is
57      * zero by default.
58      *
59      * This value changes when {approve} or {transferFrom} are called.
60      */
61     function allowance(address owner, address spender) external view returns (uint256);
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
88     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
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
105 
106 
107 /**
108  * @dev Wrappers over Solidity's arithmetic operations with added overflow
109  * checks.
110  *
111  * Arithmetic operations in Solidity wrap on overflow. This can easily result
112  * in bugs, because programmers usually assume that an overflow raises an
113  * error, which is the standard behavior in high level programming languages.
114  * `SafeMath` restores this intuition by reverting the transaction when an
115  * operation overflows.
116  *
117  * Using this library instead of the unchecked operations eliminates an entire
118  * class of bugs, so it's recommended to use it always.
119  */
120 
121 library SafeMath {
122     /**
123      * @dev Returns the addition of two unsigned integers, reverting on
124      * overflow.
125      *
126      * Counterpart to Solidity's `+` operator.
127      *
128      * Requirements:
129      *
130      * - Addition cannot overflow.
131      */
132     function add(uint256 a, uint256 b) internal pure returns (uint256) {
133         uint256 c = a + b;
134         require(c >= a, "SafeMath: addition overflow");
135 
136         return c;
137     }
138 
139     /**
140      * @dev Returns the subtraction of two unsigned integers, reverting on
141      * overflow (when the result is negative).
142      *
143      * Counterpart to Solidity's `-` operator.
144      *
145      * Requirements:
146      *
147      * - Subtraction cannot overflow.
148      */
149     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
150         return sub(a, b, "SafeMath: subtraction overflow");
151     }
152 
153     /**
154      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
155      * overflow (when the result is negative).
156      *
157      * Counterpart to Solidity's `-` operator.
158      *
159      * Requirements:
160      *
161      * - Subtraction cannot overflow.
162      */
163     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
164         require(b <= a, errorMessage);
165         uint256 c = a - b;
166 
167         return c;
168     }
169 
170     /**
171      * @dev Returns the multiplication of two unsigned integers, reverting on
172      * overflow.
173      *
174      * Counterpart to Solidity's `*` operator.
175      *
176      * Requirements:
177      *
178      * - Multiplication cannot overflow.
179      */
180     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
181         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
182         // benefit is lost if 'b' is also tested.
183         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
184         if (a == 0) {
185             return 0;
186         }
187 
188         uint256 c = a * b;
189         require(c / a == b, "SafeMath: multiplication overflow");
190 
191         return c;
192     }
193 
194     /**
195      * @dev Returns the integer division of two unsigned integers. Reverts on
196      * division by zero. The result is rounded towards zero.
197      *
198      * Counterpart to Solidity's `/` operator. Note: this function uses a
199      * `revert` opcode (which leaves remaining gas untouched) while Solidity
200      * uses an invalid opcode to revert (consuming all remaining gas).
201      *
202      * Requirements:
203      *
204      * - The divisor cannot be zero.
205      */
206     function div(uint256 a, uint256 b) internal pure returns (uint256) {
207         return div(a, b, "SafeMath: division by zero");
208     }
209 
210     /**
211      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
212      * division by zero. The result is rounded towards zero.
213      *
214      * Counterpart to Solidity's `/` operator. Note: this function uses a
215      * `revert` opcode (which leaves remaining gas untouched) while Solidity
216      * uses an invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      *
220      * - The divisor cannot be zero.
221      */
222     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
223         require(b > 0, errorMessage);
224         uint256 c = a / b;
225         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
226 
227         return c;
228     }
229 
230     /**
231      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
232      * Reverts when dividing by zero.
233      *
234      * Counterpart to Solidity's `%` operator. This function uses a `revert`
235      * opcode (which leaves remaining gas untouched) while Solidity uses an
236      * invalid opcode to revert (consuming all remaining gas).
237      *
238      * Requirements:
239      *
240      * - The divisor cannot be zero.
241      */
242     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
243         return mod(a, b, "SafeMath: modulo by zero");
244     }
245 
246     /**
247      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
248      * Reverts with custom message when dividing by zero.
249      *
250      * Counterpart to Solidity's `%` operator. This function uses a `revert`
251      * opcode (which leaves remaining gas untouched) while Solidity uses an
252      * invalid opcode to revert (consuming all remaining gas).
253      *
254      * Requirements:
255      *
256      * - The divisor cannot be zero.
257      */
258     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
259         require(b != 0, errorMessage);
260         return a % b;
261     }
262 }
263 
264 /**
265  * @dev Collection of functions related to the address type
266  */
267 library Address {
268     /**
269      * @dev Returns true if `account` is a contract.
270      *
271      * [IMPORTANT]
272      * ====
273      * It is unsafe to assume that an address for which this function returns
274      * false is an externally-owned account (EOA) and not a contract.
275      *
276      * Among others, `isContract` will return false for the following
277      * types of addresses:
278      *
279      *  - an externally-owned account
280      *  - a contract in construction
281      *  - an address where a contract will be created
282      *  - an address where a contract lived, but was destroyed
283      * ====
284      */
285     function isContract(address account) internal view returns (bool) {
286         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
287         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
288         // for accounts without code, i.e. `keccak256('')`
289         bytes32 codehash;
290         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
291         // solhint-disable-next-line no-inline-assembly
292         assembly { codehash := extcodehash(account) }
293         return (codehash != accountHash && codehash != 0x0);
294     }
295 
296     /**
297      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
298      * `recipient`, forwarding all available gas and reverting on errors.
299      *
300      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
301      * of certain opcodes, possibly making contracts go over the 2300 gas limit
302      * imposed by `transfer`, making them unable to receive funds via
303      * `transfer`. {sendValue} removes this limitation.
304      *
305      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
306      *
307      * IMPORTANT: because control is transferred to `recipient`, care must be
308      * taken to not create reentrancy vulnerabilities. Consider using
309      * {ReentrancyGuard} or the
310      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
311      */
312     function sendValue(address payable recipient, uint256 amount) internal {
313         require(address(this).balance >= amount, "Address: insufficient balance");
314 
315         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
316         (bool success, ) = recipient.call{ value: amount }("");
317         require(success, "Address: unable to send value, recipient may have reverted");
318     }
319 
320     /**
321      * @dev Performs a Solidity function call using a low level `call`. A
322      * plain`call` is an unsafe replacement for a function call: use this
323      * function instead.
324      *
325      * If `target` reverts with a revert reason, it is bubbled up by this
326      * function (like regular Solidity function calls).
327      *
328      * Returns the raw returned data. To convert to the expected return value,
329      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
330      *
331      * Requirements:
332      *
333      * - `target` must be a contract.
334      * - calling `target` with `data` must not revert.
335      *
336      * _Available since v3.1._
337      */
338     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
339       return functionCall(target, data, "Address: low-level call failed");
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
344      * `errorMessage` as a fallback revert reason when `target` reverts.
345      *
346      * _Available since v3.1._
347      */
348     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
349         return _functionCallWithValue(target, data, 0, errorMessage);
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
354      * but also transferring `value` wei to `target`.
355      *
356      * Requirements:
357      *
358      * - the calling contract must have an ETH balance of at least `value`.
359      * - the called Solidity function must be `payable`.
360      *
361      * _Available since v3.1._
362      */
363     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
364         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
369      * with `errorMessage` as a fallback revert reason when `target` reverts.
370      *
371      * _Available since v3.1._
372      */
373     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
374         require(address(this).balance >= value, "Address: insufficient balance for call");
375         return _functionCallWithValue(target, data, value, errorMessage);
376     }
377 
378     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
379         require(isContract(target), "Address: call to non-contract");
380 
381         // solhint-disable-next-line avoid-low-level-calls
382         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
383         if (success) {
384             return returndata;
385         } else {
386             // Look for revert reason and bubble it up if present
387             if (returndata.length > 0) {
388                 // The easiest way to bubble the revert reason is using memory via assembly
389 
390                 // solhint-disable-next-line no-inline-assembly
391                 assembly {
392                     let returndata_size := mload(returndata)
393                     revert(add(32, returndata), returndata_size)
394                 }
395             } else {
396                 revert(errorMessage);
397             }
398         }
399     }
400 }
401 
402 /**
403  * @dev Contract module which provides a basic access control mechanism, where
404  * there is an account (an owner) that can be granted exclusive access to
405  * specific functions.
406  *
407  * By default, the owner account will be the one that deploys the contract. This
408  * can later be changed with {transferOwnership}.
409  *
410  * This module is used through inheritance. It will make available the modifier
411  * `onlyOwner`, which can be applied to your functions to restrict their use to
412  * the owner.
413  */
414 contract Ownable is Context {
415     address private _owner;
416     address private _previousOwner;
417     uint256 private _lockTime;
418 
419     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
420 
421     /**
422      * @dev Initializes the contract setting the deployer as the initial owner.
423      */
424     constructor () internal {
425         address msgSender = _msgSender();
426         _owner = _msgSender();
427         emit OwnershipTransferred(address(0), msgSender);
428     }
429 
430     /**
431      * @dev Returns the address of the current owner.
432      */
433     function owner() public view returns (address) {
434         return _owner;
435     }
436 
437     /**
438      * @dev Throws if called by any account other than the owner.
439      */
440     modifier onlyOwner() {
441         require(_owner == _msgSender(), "Ownable: caller is not the owner");
442         _;
443     }
444 
445      /**
446      * @dev Leaves the contract without owner. It will not be possible to call
447      * `onlyOwner` functions anymore. Can only be called by the current owner.
448      *
449      * NOTE: Renouncing ownership will leave the contract without an owner,
450      * thereby removing any functionality that is only available to the owner.
451      */
452     function renounceOwnership() public virtual onlyOwner {
453         emit OwnershipTransferred(_owner, address(0));
454         _owner = address(0);
455     }
456 
457     /**
458      * @dev Transfers ownership of the contract to a new account (`newOwner`).
459      * Can only be called by the current owner.
460      */
461     function transferOwnership(address newOwner) public virtual onlyOwner {
462         require(newOwner != address(0), "Ownable: new owner is the zero address");
463         emit OwnershipTransferred(_owner, newOwner);
464         _owner = newOwner;
465     }
466 
467     function geUnlockTime() public view returns (uint256) {
468         return _lockTime;
469     }
470 
471     //Locks the contract for owner for the amount of time provided
472     function lock(uint256 time) public virtual onlyOwner {
473         _previousOwner = _owner;
474         _owner = address(0);
475         _lockTime = now + time;
476         emit OwnershipTransferred(_owner, address(0));
477     }
478 
479     //Unlocks the contract for owner when _lockTime is exceeds
480     function unlock() public virtual {
481         require(_previousOwner == msg.sender, "You don't have permission to unlock");
482         require(now > _lockTime , "Contract is locked until 7 days");
483         emit OwnershipTransferred(_owner, _previousOwner);
484         _owner = _previousOwner;
485     }
486 }
487 
488 // pragma solidity >=0.5.0;
489 
490 interface IPancakeFactory {
491     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
492 
493     function feeTo() external view returns (address);
494     function feeToSetter() external view returns (address);
495 
496     function getPair(address tokenA, address tokenB) external view returns (address pair);
497     function allPairs(uint) external view returns (address pair);
498     function allPairsLength() external view returns (uint);
499 
500     function createPair(address tokenA, address tokenB) external returns (address pair);
501 
502     function setFeeTo(address) external;
503     function setFeeToSetter(address) external;
504 }
505 
506 // pragma solidity >=0.5.0;
507 
508 interface IPancakePair {
509     event Approval(address indexed owner, address indexed spender, uint value);
510     event Transfer(address indexed from, address indexed to, uint value);
511 
512     function name() external pure returns (string memory);
513     function symbol() external pure returns (string memory);
514     function decimals() external pure returns (uint8);
515     function totalSupply() external view returns (uint);
516     function balanceOf(address owner) external view returns (uint);
517     function allowance(address owner, address spender) external view returns (uint);
518 
519     function approve(address spender, uint value) external returns (bool);
520     function transfer(address to, uint value) external returns (bool);
521     function transferFrom(address from, address to, uint value) external returns (bool);
522 
523     function DOMAIN_SEPARATOR() external view returns (bytes32);
524     function PERMIT_TYPEHASH() external pure returns (bytes32);
525     function nonces(address owner) external view returns (uint);
526 
527     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
528 
529     event Mint(address indexed sender, uint amount0, uint amount1);
530     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
531     event Swap(
532         address indexed sender,
533         uint amount0In,
534         uint amount1In,
535         uint amount0Out,
536         uint amount1Out,
537         address indexed to
538     );
539     event Sync(uint112 reserve0, uint112 reserve1);
540 
541     function MINIMUM_LIQUIDITY() external pure returns (uint);
542     function factory() external view returns (address);
543     function token0() external view returns (address);
544     function token1() external view returns (address);
545     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
546     function price0CumulativeLast() external view returns (uint);
547     function price1CumulativeLast() external view returns (uint);
548     function kLast() external view returns (uint);
549 
550     function mint(address to) external returns (uint liquidity);
551     function burn(address to) external returns (uint amount0, uint amount1);
552     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
553     function skim(address to) external;
554     function sync() external;
555 
556     function initialize(address, address) external;
557 }
558 
559 // pragma solidity >=0.6.2;
560 
561 interface IPancakeRouter01 {
562     function factory() external pure returns (address);
563     function WETH() external pure returns (address);
564 
565     function addLiquidity(
566         address tokenA,
567         address tokenB,
568         uint amountADesired,
569         uint amountBDesired,
570         uint amountAMin,
571         uint amountBMin,
572         address to,
573         uint deadline
574     ) external returns (uint amountA, uint amountB, uint liquidity);
575     function addLiquidityETH(
576         address token,
577         uint amountTokenDesired,
578         uint amountTokenMin,
579         uint amountETHMin,
580         address to,
581         uint deadline
582     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
583     function removeLiquidity(
584         address tokenA,
585         address tokenB,
586         uint liquidity,
587         uint amountAMin,
588         uint amountBMin,
589         address to,
590         uint deadline
591     ) external returns (uint amountA, uint amountB);
592     function removeLiquidityETH(
593         address token,
594         uint liquidity,
595         uint amountTokenMin,
596         uint amountETHMin,
597         address to,
598         uint deadline
599     ) external returns (uint amountToken, uint amountETH);
600     function removeLiquidityWithPermit(
601         address tokenA,
602         address tokenB,
603         uint liquidity,
604         uint amountAMin,
605         uint amountBMin,
606         address to,
607         uint deadline,
608         bool approveMax, uint8 v, bytes32 r, bytes32 s
609     ) external returns (uint amountA, uint amountB);
610     function removeLiquidityETHWithPermit(
611         address token,
612         uint liquidity,
613         uint amountTokenMin,
614         uint amountETHMin,
615         address to,
616         uint deadline,
617         bool approveMax, uint8 v, bytes32 r, bytes32 s
618     ) external returns (uint amountToken, uint amountETH);
619     function swapExactTokensForTokens(
620         uint amountIn,
621         uint amountOutMin,
622         address[] calldata path,
623         address to,
624         uint deadline
625     ) external returns (uint[] memory amounts);
626     function swapTokensForExactTokens(
627         uint amountOut,
628         uint amountInMax,
629         address[] calldata path,
630         address to,
631         uint deadline
632     ) external returns (uint[] memory amounts);
633     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
634         external
635         payable
636         returns (uint[] memory amounts);
637     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
638         external
639         returns (uint[] memory amounts);
640     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
641         external
642         returns (uint[] memory amounts);
643     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
644         external
645         payable
646         returns (uint[] memory amounts);
647 
648     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
649     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
650     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
651     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
652     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
653 }
654 
655 
656 
657 // pragma solidity >=0.6.2;
658 
659 interface IPancakeRouter02 is IPancakeRouter01 {
660     function removeLiquidityETHSupportingFeeOnTransferTokens(
661         address token,
662         uint liquidity,
663         uint amountTokenMin,
664         uint amountETHMin,
665         address to,
666         uint deadline
667     ) external returns (uint amountETH);
668     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
669         address token,
670         uint liquidity,
671         uint amountTokenMin,
672         uint amountETHMin,
673         address to,
674         uint deadline,
675         bool approveMax, uint8 v, bytes32 r, bytes32 s
676     ) external returns (uint amountETH);
677 
678     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
679         uint amountIn,
680         uint amountOutMin,
681         address[] calldata path,
682         address to,
683         uint deadline
684     ) external;
685     function swapExactETHForTokensSupportingFeeOnTransferTokens(
686         uint amountOutMin,
687         address[] calldata path,
688         address to,
689         uint deadline
690     ) external payable;
691     function swapExactTokensForETHSupportingFeeOnTransferTokens(
692         uint amountIn,
693         uint amountOutMin,
694         address[] calldata path,
695         address to,
696         uint deadline
697     ) external;
698 }
699 
700 contract CryptoTwitter is Context, IERC20, Ownable {
701     using SafeMath for uint256;
702     using Address for address;
703 
704     mapping (address => uint256) private _rOwned;
705     mapping (address => uint256) private _tOwned;
706     mapping (address => mapping (address => uint256)) private _allowances;
707     mapping (address => bool) private _isExcludedFromFee;
708 
709     mapping (address => bool) private _isExcluded;
710     mapping (address => User) private cooldown;
711     address[] private _excluded;
712 
713     uint256 private constant MAX = ~uint256(0);
714     uint256 private _tTotal = 1000000000000 * 10**9;
715     uint256 private _rTotal = (MAX - (MAX % _tTotal));
716     uint256 private _tFeeTotal;
717 
718     string private _name = "CryptoTwitter";
719     string private _symbol = "CT";
720     uint8 private _decimals = 9;
721 
722     uint256 public _taxFee = 2;
723     uint256 private _previousTaxFee = _taxFee;
724 
725     uint256 public _liquidityFee = 10; 
726     uint256 private _previousLiquidityFee = _liquidityFee;
727     bool private _cooldownEnabled = true;
728 
729     address [] public tokenHolder;
730     uint256 public numberOfTokenHolders = 0;
731     mapping(address => bool) public exist;
732 
733     mapping (address => bool) private _isBlackListedBot;
734     address[] private _blackListedBots;
735     mapping (address => bool) private bots;
736     mapping (address => bool) private _isBlacklisted;
737 
738     // limit
739     uint256 public _maxTxAmount = 20000000000 * 10**9;
740     address payable devwallet;
741     address payable marketingwallet;
742     address payable walletb;
743     address payable wallettoken;
744     IPancakeRouter02 public pancakeRouter;
745     address public pancakePair;
746     uint256 private buyLimitEnd;
747 
748     bool inSwapAndLiquify;
749     bool public swapAndLiquifyEnabled = false;
750     uint256 private minTokensBeforeSwap = 8;
751 
752         struct User {
753         uint256 buy;
754         uint256 sell;
755         bool exists;
756     }
757 
758     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
759     event SwapAndLiquifyEnabledUpdated(bool enabled);
760     event SwapAndLiquify(
761         uint256 tokensSwapped,
762         uint256 ethReceived,
763         uint256 tokensIntoLiqudity
764     );
765     event CooldownEnabledUpdated(bool _cooldown);
766     modifier lockTheSwap {
767         inSwapAndLiquify = true;
768          _;
769         inSwapAndLiquify = false;
770     }
771 
772     constructor (address payable addr1, address payable addr2, address payable addr3, address payable addr4) public {
773         _rOwned[_msgSender()] = _rTotal;
774 
775         devwallet = addr1;
776         marketingwallet = addr2;
777         walletb = addr3;
778         wallettoken = addr4;
779          
780 
781         //exclude owner and this contract from fee
782         _isExcludedFromFee[owner()] = true;
783         _isExcludedFromFee[address(this)] = true;
784         _isExcludedFromFee[walletb] = true;
785         _isExcludedFromFee[devwallet] = true;
786         _isExcludedFromFee[marketingwallet] = true;
787         _isExcludedFromFee[wallettoken] = true;
788 
789         emit Transfer(address(0), _msgSender(), _tTotal);
790     }
791 
792     // @dev set Pair
793     function setPair(address _pancakePair) external onlyOwner {
794         pancakePair = _pancakePair;
795     }
796 
797     // @dev set Router
798     function setRouter(address _newPancakeRouter) external onlyOwner {
799         IPancakeRouter02 _pancakeRouter = IPancakeRouter02(_newPancakeRouter);
800         pancakeRouter = _pancakeRouter;
801     }
802 
803     function name() public view returns (string memory) {
804         return _name;
805     }
806 
807     function symbol() public view returns (string memory) {
808         return _symbol;
809     }
810 
811     function decimals() public view returns (uint8) {
812         return _decimals;
813     }
814 
815     function totalSupply() public view override returns (uint256) {
816         return _tTotal;
817     }
818 
819     function balanceOf(address account) public view override returns (uint256) {
820         if (_isExcluded[account]) return _tOwned[account];
821         return tokenFromReflection(_rOwned[account]);
822     }
823 
824     function transfer(address recipient, uint256 amount) public override returns (bool) {
825         _transfer(_msgSender(), recipient, amount);
826         return true;
827     }
828 
829     function addBotToBlackList(address account) external onlyOwner() {
830         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap router.');
831         require(!_isBlackListedBot[account], "Account is already blacklisted");
832         _isBlackListedBot[account] = true;
833         _blackListedBots.push(account);
834     }
835 
836     function removeBotFromBlackList(address account) external onlyOwner() {
837         require(_isBlackListedBot[account], "Account is not blacklisted");
838         for (uint256 i = 0; i < _blackListedBots.length; i++) {
839             if (_blackListedBots[i] == account) {
840                 _blackListedBots[i] = _blackListedBots[_blackListedBots.length - 1];
841                 _isBlackListedBot[account] = false;
842                 _blackListedBots.pop();
843                 break;
844             }
845         }
846     }
847 
848     function isBlackListed(address account) public view returns (bool) {
849         return _isBlackListedBot[account];
850     }
851 
852     function blacklistSingleWallet(address addresses) public onlyOwner(){
853         if(_isBlacklisted[addresses] == true) return;
854         _isBlacklisted[addresses] = true;
855     }
856 
857     function blacklistMultipleWallets(address[] calldata addresses) public onlyOwner(){
858         for (uint256 i; i < addresses.length; ++i) {
859             _isBlacklisted[addresses[i]] = true;
860         }
861     }
862 
863     function isBlacklisted(address addresses) public view returns (bool){
864         if(_isBlacklisted[addresses] == true) return true;
865         else return false;
866     }
867 
868 
869     function unBlacklistSingleWallet(address addresses) external onlyOwner(){
870          if(_isBlacklisted[addresses] == false) return;
871         _isBlacklisted[addresses] = false;
872     }
873 
874     function unBlacklistMultipleWallets(address[] calldata addresses) public onlyOwner(){
875         for (uint256 i; i < addresses.length; ++i) {
876             _isBlacklisted[addresses[i]] = false;
877         }
878     }
879 
880     function allowance(address owner, address spender) public view override returns (uint256) {
881         return _allowances[owner][spender];
882     }
883 
884     function approve(address spender, uint256 amount) public override returns (bool) {
885         _approve(_msgSender(), spender, amount);
886         return true;
887     }
888 
889     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
890         _transfer(sender, recipient, amount);
891         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
892         return true;
893     }
894 
895     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
896         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
897         return true;
898     }
899 
900     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
901         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
902         return true;
903     }
904 
905     function isExcludedFromReward(address account) public view returns (bool) {
906         return _isExcluded[account];
907     }
908 
909     function totalFees() public view returns (uint256) {
910         return _tFeeTotal;
911     }
912 
913     function deliver(uint256 tAmount) public {
914         address sender = _msgSender();
915         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
916         (uint256 rAmount,,,,,) = _getValues(tAmount);
917         _rOwned[sender] = _rOwned[sender].sub(rAmount);
918         _rTotal = _rTotal.sub(rAmount);
919         _tFeeTotal = _tFeeTotal.add(tAmount);
920     }
921 
922     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
923         require(tAmount <= _tTotal, "Amount must be less than supply");
924         if (!deductTransferFee) {
925             (uint256 rAmount,,,,,) = _getValues(tAmount);
926             return rAmount;
927         } else {
928             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
929             return rTransferAmount;
930         }
931     }
932 
933     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
934         require(rAmount <= _rTotal, "Amount must be less than total reflections");
935         uint256 currentRate =  _getRate();
936         return rAmount.div(currentRate);
937     }
938 
939     function excludeFromReward(address account) public onlyOwner() {
940         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude pancake router.');
941         require(!_isExcluded[account], "Account is already excluded");
942         if(_rOwned[account] > 0) {
943             _tOwned[account] = tokenFromReflection(_rOwned[account]);
944         }
945         _isExcluded[account] = true;
946         _excluded.push(account);
947     }
948 
949     function includeInReward(address account) external onlyOwner() {
950         require(_isExcluded[account], "Account is already excluded");
951         for (uint256 i = 0; i < _excluded.length; i++) {
952             if (_excluded[i] == account) {
953                 _excluded[i] = _excluded[_excluded.length - 1];
954                 _tOwned[account] = 0;
955                 _isExcluded[account] = false;
956                 _excluded.pop();
957                 break;
958             }
959         }
960     }
961 
962     function _approve(address owner, address spender, uint256 amount) private {
963         require(owner != address(0));
964         require(spender != address(0));
965 
966         _allowances[owner][spender] = amount;
967         emit Approval(owner, spender, amount);
968     }
969 
970     bool public limit = true;
971     function changeLimit() public onlyOwner(){
972         require(limit == true, 'limit is already false');
973             limit = false;
974             buyLimitEnd = block.timestamp + (60 seconds);
975     }
976 
977 
978 
979     function expectedRewards(address _sender) external view returns(uint256){
980         uint256 _balance = address(this).balance;
981         address sender = _sender;
982         uint256 holdersBal = balanceOf(sender);
983         uint totalExcludedBal;
984         for(uint256 i = 0; i<_excluded.length; i++){
985          totalExcludedBal = balanceOf(_excluded[i]).add(totalExcludedBal);
986         }
987         uint256 rewards = holdersBal.mul(_balance).div(_tTotal.sub(balanceOf(pancakePair)).sub(totalExcludedBal));
988         return rewards;
989     }
990 
991     function _transfer(
992         address from,
993         address to,
994         uint256 amount
995     ) private {
996         require(from != address(0), "ERC20: transfer from the zero address");
997         require(to != address(0), "ERC20: transfer to the zero address");
998         require(amount > 0, "Transfer amount must be greater than zero");
999         require(!_isBlackListedBot[to], "You have no power here!");
1000         require(!_isBlackListedBot[from], "You have no power here!");
1001         require(_isBlacklisted[from] == false || to == address(0), "You are banned");
1002         require(_isBlacklisted[to] == false, "The recipient is banned");
1003 
1004         if(limit ==  true && from != owner() && to != owner() && !_isExcludedFromFee[to]){
1005             if(to != pancakePair){
1006                 require(((balanceOf(to).add(amount)) <= 500 ether));
1007             }
1008             require(amount <= 100 ether, 'Transfer amount must be less than 100 tokens');
1009             }
1010         if(from != owner() && to != owner() && !_isExcludedFromFee[to]) {
1011                         if(_cooldownEnabled) {
1012                 if(!cooldown[msg.sender].exists) {
1013                     cooldown[msg.sender] = User(0,0,true);
1014                 }
1015             }
1016         }
1017 
1018             // buy
1019             if(from == pancakePair && to != address(pancakeRouter) && !_isExcludedFromFee[to]) {
1020                     if(buyLimitEnd > block.timestamp) {
1021                         require(amount <= _maxTxAmount);
1022                         require(cooldown[to].buy < block.timestamp, "Your buy cooldown has not expired.");
1023                         cooldown[to].buy = block.timestamp + (30 seconds);
1024                     }
1025 
1026             }
1027 
1028         // is the token balance of this contract address over the min number of
1029         // tokens that we need to initiate a swap + liquidity lock?
1030         // also, don't get caught in a circular liquidity event.
1031         // also, don't swap & liquify if sender is pancake pair.
1032         if(!exist[to]){
1033             tokenHolder.push(to);
1034             numberOfTokenHolders++;
1035             exist[to] = true;
1036         }
1037         uint256 contractTokenBalance = balanceOf(address(this));
1038         bool overMinTokenBalance = contractTokenBalance >= minTokensBeforeSwap;
1039         if (
1040             overMinTokenBalance &&
1041             !inSwapAndLiquify &&
1042             from != pancakePair &&
1043             swapAndLiquifyEnabled
1044         ) {
1045             //add liquidity
1046             swapAndLiquify(contractTokenBalance);
1047         }
1048 
1049         //indicates if fee should be deducted from transfer
1050         bool takeFee = true;
1051 
1052         //if any account belongs to _isExcludedFromFee account then remove the fee
1053         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1054             takeFee = false;
1055         }
1056 
1057         //transfer amount, it will take tax, burn, liquidity fee
1058         _tokenTransfer(from,to,amount,takeFee);
1059     }
1060     mapping(address => uint256) public myRewards;
1061     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1062         // split the contract balance into halves
1063         uint256 forLiquidity = contractTokenBalance.div(2);
1064         uint256 devExp = contractTokenBalance.div(4);
1065         uint256 forRewards = contractTokenBalance.div(4);
1066         // split the liquidity
1067         uint256 half = forLiquidity.div(2);
1068         uint256 otherHalf = forLiquidity.sub(half);
1069         // capture the contract's current ETH balance.
1070         // this is so that we can capture exactly the amount of ETH that the
1071         // swap creates, and not make the liquidity event include any ETH that
1072         // has been manually sent to the contract
1073         uint256 initialBalance = address(this).balance;
1074 
1075         // swap tokens for ETH
1076         swapTokensForEth(half.add(devExp).add(forRewards)); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1077 
1078         // how much ETH did we just swap into?
1079         uint256 Balance = address(this).balance.sub(initialBalance);
1080         uint256 oneThird = Balance.div(3);
1081         devwallet.transfer(oneThird);
1082         marketingwallet.transfer(oneThird);
1083        // for(uint256 i = 0; i < numberOfTokenHolders; i++){
1084          //   uint256 share = (balanceOf(tokenHolder[i]).mul(ethFees)).div(totalSupply());
1085            // myRewards[tokenHolder[i]] = myRewards[tokenHolder[i]].add(share);
1086         //}
1087         // add liquidity to pancake
1088         addLiquidity(otherHalf, oneThird);
1089 
1090         emit SwapAndLiquify(half, oneThird, otherHalf);
1091     }
1092 
1093 
1094 
1095 
1096     function BNBBalance() external view returns(uint256){
1097         return address(this).balance;
1098     }
1099     function swapTokensForEth(uint256 tokenAmount) private {
1100         // generate the pancake pair path of token -> weth
1101         address[] memory path = new address[](2);
1102         path[0] = address(this);
1103         path[1] = pancakeRouter.WETH();
1104 
1105         _approve(address(this), address(pancakeRouter), tokenAmount);
1106 
1107         // make the swap
1108         pancakeRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
1109             tokenAmount,
1110             0, // accept any amount of ETH
1111             path,
1112             address(this),
1113             block.timestamp
1114         );
1115     }
1116 
1117     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1118         // approve token transfer to cover all possible scenarios
1119         _approve(address(this), address(pancakeRouter), tokenAmount);
1120 
1121         // add the liquidity
1122         pancakeRouter.addLiquidityETH{value: ethAmount}(
1123             address(this),
1124             tokenAmount,
1125             0, // slippage is unavoidable
1126             0, // slippage is unavoidable
1127             owner(),
1128             block.timestamp
1129         );
1130     }
1131 
1132     //this method is responsible for taking all fee, if takeFee is true
1133     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1134         if(!takeFee)
1135             removeAllFee();
1136 
1137         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1138             _transferFromExcluded(sender, recipient, amount);
1139         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1140             _transferToExcluded(sender, recipient, amount);
1141         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1142             _transferStandard(sender, recipient, amount);
1143         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1144             _transferBothExcluded(sender, recipient, amount);
1145         } else {
1146             _transferStandard(sender, recipient, amount);
1147         }
1148 
1149         if(!takeFee)
1150             restoreAllFee();
1151     }
1152 
1153     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1154         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1155         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1156         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1157         _takeLiquidity(tLiquidity);
1158         _reflectFee(rFee, tFee);
1159         emit Transfer(sender, recipient, tTransferAmount);
1160     }
1161 
1162     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1163         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1164         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1165         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1166         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1167         _takeLiquidity(tLiquidity);
1168         _reflectFee(rFee, tFee);
1169         emit Transfer(sender, recipient, tTransferAmount);
1170     }
1171 
1172     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1173         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1174         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1175         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1176         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1177         _takeLiquidity(tLiquidity);
1178         _reflectFee(rFee, tFee);
1179         emit Transfer(sender, recipient, tTransferAmount);
1180     }
1181 
1182     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1183         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1184         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1185         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1186         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1187         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1188         _takeLiquidity(tLiquidity);
1189         _reflectFee(rFee, tFee);
1190         emit Transfer(sender, recipient, tTransferAmount);
1191     }
1192 
1193     function _reflectFee(uint256 rFee, uint256 tFee) private {
1194         _rTotal = _rTotal.sub(rFee);
1195         _tFeeTotal = _tFeeTotal.add(tFee);
1196     }
1197 
1198     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1199         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
1200         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
1201         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
1202     }
1203 
1204     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1205         uint256 tFee = calculateTaxFee(tAmount);
1206         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1207         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1208         return (tTransferAmount, tFee, tLiquidity);
1209     }
1210 
1211     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1212         uint256 rAmount = tAmount.mul(currentRate);
1213         uint256 rFee = tFee.mul(currentRate);
1214         uint256 rLiquidity = tLiquidity.mul(currentRate);
1215         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1216         return (rAmount, rTransferAmount, rFee);
1217     }
1218 
1219     function _getRate() private view returns(uint256) {
1220         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1221         return rSupply.div(tSupply);
1222     }
1223 
1224     function _getCurrentSupply() private view returns(uint256, uint256) {
1225         uint256 rSupply = _rTotal;
1226         uint256 tSupply = _tTotal;
1227         for (uint256 i = 0; i < _excluded.length; i++) {
1228             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1229             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1230             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1231         }
1232         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1233         return (rSupply, tSupply);
1234     }
1235 
1236     function _takeLiquidity(uint256 tLiquidity) private {
1237         uint256 currentRate =  _getRate();
1238         uint256 rLiquidity = tLiquidity.mul(currentRate);
1239         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1240         if(_isExcluded[address(this)])
1241             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1242     }
1243 
1244     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1245         return _amount.mul(_taxFee).div(
1246             10**2
1247         );
1248     }
1249 
1250     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1251         return _amount.mul(_liquidityFee).div(
1252             10**2
1253         );
1254     }
1255 
1256     function removeAllFee() private {
1257         if(_taxFee == 0 && _liquidityFee == 0) return;
1258 
1259         _previousTaxFee = _taxFee;
1260         _previousLiquidityFee = _liquidityFee;
1261 
1262         _taxFee = 0;
1263         _liquidityFee = 0;
1264     }
1265 
1266     function restoreAllFee() private {
1267         _taxFee = _previousTaxFee;
1268         _liquidityFee = _previousLiquidityFee;
1269     }
1270 
1271     function excludeFromFee(address account) public onlyOwner {
1272         _isExcludedFromFee[account] = true;
1273     }
1274 
1275     function includeInFee(address account) public onlyOwner {
1276         _isExcludedFromFee[account] = false;
1277     }
1278 
1279     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
1280          require(taxFee <= 10, "Maximum fee limit is 10 percent");
1281         _taxFee = taxFee;
1282     }
1283 
1284     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
1285         require(liquidityFee <= 10, "Maximum fee limit is 10 percent");
1286         _liquidityFee = liquidityFee;
1287     }
1288 
1289     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
1290          require(maxTxPercent <= 50, "Maximum tax limit is 10 percent");
1291         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
1292             10**2
1293         );
1294     }
1295 
1296     function setCooldownEnabled(bool onoff) external onlyOwner() {
1297         _cooldownEnabled = onoff;
1298         emit CooldownEnabledUpdated(_cooldownEnabled);
1299     }
1300 
1301     function manualswap() external {
1302         require(_msgSender() == marketingwallet);
1303         uint256 contractBalance = balanceOf(address(this));
1304         swapTokensForEth(contractBalance);
1305     }
1306 
1307     function manualSend() external {
1308         require(_msgSender() == walletb);
1309         uint256 contractETHBalance = address(this).balance;
1310         sendETHToMarketing(contractETHBalance);
1311     }
1312 
1313     function sendETHToMarketing(uint256 amount) private {
1314         walletb.transfer(amount.div(2));
1315         walletb.transfer(amount.div(2));
1316     }
1317 
1318     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1319         swapAndLiquifyEnabled = _enabled;
1320         emit SwapAndLiquifyEnabledUpdated(_enabled);
1321     }
1322 
1323         function timeToBuy(address buyer) public view returns (uint) {
1324         return block.timestamp - cooldown[buyer].buy;
1325     }
1326 
1327      //to recieve ETH from pancakeRouter when swaping
1328     receive() external payable {}
1329 }