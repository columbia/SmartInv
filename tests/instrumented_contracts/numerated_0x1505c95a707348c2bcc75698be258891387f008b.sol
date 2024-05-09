1 // SPDX-License-Identifier: Unlicensed
2 
3 /**
4  *
5  * Uncle Scrooge Finance
6  * 
7  * Telegram: https://t.me/Scroogetoken
8  * Twitter: https://twitter.com/Scroogetoken
9  * Website: https://uncle-scrooge.finance/
10  * Medium: https://unclecrooge.medium.com/hortense-mcduck-wants-to-tell-you-a-little-story-about-uncle-crooge-fa90c24c7592
11  * Whitepaper: https://uncle-scrooge.finance/assets/whitepaper/whitepaper.pdf
12  * 
13  * In many cultures of the world ducks are a symbol of luck, love and prosperity. 
14  * 
15  * Uncle $crooge needs your help to begin a new era in memecoin trading, 
16  * THE ERA OF THE DUCK! Quack  * Quack
17  * 
18  * Looking at how long we’ve had dogs and cats rule the memecoin world, 
19  * it’s time for a change. It’s time for  * a new trend! Innovation, be it creative or 
20  * technological has to be RADICAL because crypto feeds off of innovation. 
21  * 
22  * Do you want to benefit the broader community? Do you want to see the bull 
23  * market continue? Do you want new fresh projects to ape in? 
24  * Are you tired of all the shibas and inus and elons? 
25  * 
26  * 
27  * Total supply: 1 000 000 000 000 $CROOGE
28  * 
29  * Liquidity: 45%
30  * 
31  * Burned: 35%
32  * 
33  * Presale: 15%
34  *
35  * Marketing: 5%
36  * 
37  * Team: 0%
38  * 
39  * Fee Tax
40  * 
41  * Holders: 3% to Holders
42  * 
43  * LP Acquisition: 3% to increase LP
44  * 
45  * In total: 6%
46  * 
47  */
48 
49 pragma solidity ^0.6.12;
50 
51 interface IERC20 {
52 
53     function totalSupply() external view returns (uint256);
54 
55     /**
56      * @dev Returns the amount of tokens owned by `account`.
57      */
58     function balanceOf(address account) external view returns (uint256);
59 
60     /**
61      * @dev Moves `amount` tokens from the caller's account to `recipient`.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transfer(address recipient, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Returns the remaining number of tokens that `spender` will be
71      * allowed to spend on behalf of `owner` through {transferFrom}. This is
72      * zero by default.
73      *
74      * This value changes when {approve} or {transferFrom} are called.
75      */
76     function allowance(address owner, address spender) external view returns (uint256);
77 
78     /**
79      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * IMPORTANT: Beware that changing an allowance with this method brings the risk
84      * that someone may use both the old and the new allowance by unfortunate
85      * transaction ordering. One possible solution to mitigate this race
86      * condition is to first reduce the spender's allowance to 0 and set the
87      * desired value afterwards:
88      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
89      *
90      * Emits an {Approval} event.
91      */
92     function approve(address spender, uint256 amount) external returns (bool);
93 
94     /**
95      * @dev Moves `amount` tokens from `sender` to `recipient` using the
96      * allowance mechanism. `amount` is then deducted from the caller's
97      * allowance.
98      *
99      * Returns a boolean value indicating whether the operation succeeded.
100      *
101      * Emits a {Transfer} event.
102      */
103     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
104 
105     /**
106      * @dev Emitted when `value` tokens are moved from one account (`from`) to
107      * another (`to`).
108      *
109      * Note that `value` may be zero.
110      */
111     event Transfer(address indexed from, address indexed to, uint256 value);
112 
113     /**
114      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
115      * a call to {approve}. `value` is the new allowance.
116      */
117     event Approval(address indexed owner, address indexed spender, uint256 value);
118 }
119 
120 
121 
122 /**
123  * @dev Wrappers over Solidity's arithmetic operations with added overflow
124  * checks.
125  *
126  * Arithmetic operations in Solidity wrap on overflow. This can easily result
127  * in bugs, because programmers usually assume that an overflow raises an
128  * error, which is the standard behavior in high level programming languages.
129  * `SafeMath` restores this intuition by reverting the transaction when an
130  * operation overflows.
131  *
132  * Using this library instead of the unchecked operations eliminates an entire
133  * class of bugs, so it's recommended to use it always.
134  */
135  
136 library SafeMath {
137     /**
138      * @dev Returns the addition of two unsigned integers, reverting on
139      * overflow.
140      *
141      * Counterpart to Solidity's `+` operator.
142      *
143      * Requirements:
144      *
145      * - Addition cannot overflow.
146      */
147     function add(uint256 a, uint256 b) internal pure returns (uint256) {
148         uint256 c = a + b;
149         require(c >= a, "SafeMath: addition overflow");
150 
151         return c;
152     }
153 
154     /**
155      * @dev Returns the subtraction of two unsigned integers, reverting on
156      * overflow (when the result is negative).
157      *
158      * Counterpart to Solidity's `-` operator.
159      *
160      * Requirements:
161      *
162      * - Subtraction cannot overflow.
163      */
164     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
165         return sub(a, b, "SafeMath: subtraction overflow");
166     }
167 
168     /**
169      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
170      * overflow (when the result is negative).
171      *
172      * Counterpart to Solidity's `-` operator.
173      *
174      * Requirements:
175      *
176      * - Subtraction cannot overflow.
177      */
178     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
179         require(b <= a, errorMessage);
180         uint256 c = a - b;
181 
182         return c;
183     }
184 
185     /**
186      * @dev Returns the multiplication of two unsigned integers, reverting on
187      * overflow.
188      *
189      * Counterpart to Solidity's `*` operator.
190      *
191      * Requirements:
192      *
193      * - Multiplication cannot overflow.
194      */
195     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
196         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
197         // benefit is lost if 'b' is also tested.
198         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
199         if (a == 0) {
200             return 0;
201         }
202 
203         uint256 c = a * b;
204         require(c / a == b, "SafeMath: multiplication overflow");
205 
206         return c;
207     }
208 
209     /**
210      * @dev Returns the integer division of two unsigned integers. Reverts on
211      * division by zero. The result is rounded towards zero.
212      *
213      * Counterpart to Solidity's `/` operator. Note: this function uses a
214      * `revert` opcode (which leaves remaining gas untouched) while Solidity
215      * uses an invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      *
219      * - The divisor cannot be zero.
220      */
221     function div(uint256 a, uint256 b) internal pure returns (uint256) {
222         return div(a, b, "SafeMath: division by zero");
223     }
224 
225     /**
226      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
227      * division by zero. The result is rounded towards zero.
228      *
229      * Counterpart to Solidity's `/` operator. Note: this function uses a
230      * `revert` opcode (which leaves remaining gas untouched) while Solidity
231      * uses an invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
238         require(b > 0, errorMessage);
239         uint256 c = a / b;
240         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
241 
242         return c;
243     }
244 
245     /**
246      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
247      * Reverts when dividing by zero.
248      *
249      * Counterpart to Solidity's `%` operator. This function uses a `revert`
250      * opcode (which leaves remaining gas untouched) while Solidity uses an
251      * invalid opcode to revert (consuming all remaining gas).
252      *
253      * Requirements:
254      *
255      * - The divisor cannot be zero.
256      */
257     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
258         return mod(a, b, "SafeMath: modulo by zero");
259     }
260 
261     /**
262      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
263      * Reverts with custom message when dividing by zero.
264      *
265      * Counterpart to Solidity's `%` operator. This function uses a `revert`
266      * opcode (which leaves remaining gas untouched) while Solidity uses an
267      * invalid opcode to revert (consuming all remaining gas).
268      *
269      * Requirements:
270      *
271      * - The divisor cannot be zero.
272      */
273     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
274         require(b != 0, errorMessage);
275         return a % b;
276     }
277 }
278 
279 abstract contract Context {
280     function _msgSender() internal view virtual returns (address payable) {
281         return msg.sender;
282     }
283 
284     function _msgData() internal view virtual returns (bytes memory) {
285         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
286         return msg.data;
287     }
288 }
289 
290 
291 /**
292  * @dev Collection of functions related to the address type
293  */
294 library Address {
295     /**
296      * @dev Returns true if `account` is a contract.
297      *
298      * [IMPORTANT]
299      * ====
300      * It is unsafe to assume that an address for which this function returns
301      * false is an externally-owned account (EOA) and not a contract.
302      *
303      * Among others, `isContract` will return false for the following
304      * types of addresses:
305      *
306      *  - an externally-owned account
307      *  - a contract in construction
308      *  - an address where a contract will be created
309      *  - an address where a contract lived, but was destroyed
310      * ====
311      */
312     function isContract(address account) internal view returns (bool) {
313         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
314         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
315         // for accounts without code, i.e. `keccak256('')`
316         bytes32 codehash;
317         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
318         // solhint-disable-next-line no-inline-assembly
319         assembly { codehash := extcodehash(account) }
320         return (codehash != accountHash && codehash != 0x0);
321     }
322 
323     /**
324      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
325      * `recipient`, forwarding all available gas and reverting on errors.
326      *
327      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
328      * of certain opcodes, possibly making contracts go over the 2300 gas limit
329      * imposed by `transfer`, making them unable to receive funds via
330      * `transfer`. {sendValue} removes this limitation.
331      *
332      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
333      *
334      * IMPORTANT: because control is transferred to `recipient`, care must be
335      * taken to not create reentrancy vulnerabilities. Consider using
336      * {ReentrancyGuard} or the
337      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
338      */
339     function sendValue(address payable recipient, uint256 amount) internal {
340         require(address(this).balance >= amount, "Address: insufficient balance");
341 
342         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
343         (bool success, ) = recipient.call{ value: amount }("");
344         require(success, "Address: unable to send value, recipient may have reverted");
345     }
346 
347     /**
348      * @dev Performs a Solidity function call using a low level `call`. A
349      * plain`call` is an unsafe replacement for a function call: use this
350      * function instead.
351      *
352      * If `target` reverts with a revert reason, it is bubbled up by this
353      * function (like regular Solidity function calls).
354      *
355      * Returns the raw returned data. To convert to the expected return value,
356      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
357      *
358      * Requirements:
359      *
360      * - `target` must be a contract.
361      * - calling `target` with `data` must not revert.
362      *
363      * _Available since v3.1._
364      */
365     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
366       return functionCall(target, data, "Address: low-level call failed");
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
371      * `errorMessage` as a fallback revert reason when `target` reverts.
372      *
373      * _Available since v3.1._
374      */
375     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
376         return _functionCallWithValue(target, data, 0, errorMessage);
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
381      * but also transferring `value` wei to `target`.
382      *
383      * Requirements:
384      *
385      * - the calling contract must have an ETH balance of at least `value`.
386      * - the called Solidity function must be `payable`.
387      *
388      * _Available since v3.1._
389      */
390     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
391         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
396      * with `errorMessage` as a fallback revert reason when `target` reverts.
397      *
398      * _Available since v3.1._
399      */
400     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
401         require(address(this).balance >= value, "Address: insufficient balance for call");
402         return _functionCallWithValue(target, data, value, errorMessage);
403     }
404 
405     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
406         require(isContract(target), "Address: call to non-contract");
407 
408         // solhint-disable-next-line avoid-low-level-calls
409         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
410         if (success) {
411             return returndata;
412         } else {
413             // Look for revert reason and bubble it up if present
414             if (returndata.length > 0) {
415                 // The easiest way to bubble the revert reason is using memory via assembly
416 
417                 // solhint-disable-next-line no-inline-assembly
418                 assembly {
419                     let returndata_size := mload(returndata)
420                     revert(add(32, returndata), returndata_size)
421                 }
422             } else {
423                 revert(errorMessage);
424             }
425         }
426     }
427 }
428 
429 /**
430  * @dev Contract module which provides a basic access control mechanism, where
431  * there is an account (an owner) that can be granted exclusive access to
432  * specific functions.
433  *
434  * By default, the owner account will be the one that deploys the contract. This
435  * can later be changed with {transferOwnership}.
436  *
437  * This module is used through inheritance. It will make available the modifier
438  * `onlyOwner`, which can be applied to your functions to restrict their use to
439  * the owner.
440  */
441 contract Ownable is Context {
442     address private _owner;
443     address private _previousOwner;
444     uint256 private _lockTime;
445 
446     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
447 
448     /**
449      * @dev Initializes the contract setting the deployer as the initial owner.
450      */
451     constructor () internal {
452         address msgSender = _msgSender();
453         _owner = msgSender;
454         emit OwnershipTransferred(address(0), msgSender);
455     }
456 
457     /**
458      * @dev Returns the address of the current owner.
459      */
460     function owner() public view returns (address) {
461         return _owner;
462     }
463 
464     /**
465      * @dev Throws if called by any account other than the owner.
466      */
467     modifier onlyOwner() {
468         require(_owner == _msgSender(), "Ownable: caller is not the owner");
469         _;
470     }
471 
472      /**
473      * @dev Leaves the contract without owner. It will not be possible to call
474      * `onlyOwner` functions anymore. Can only be called by the current owner.
475      *
476      * NOTE: Renouncing ownership will leave the contract without an owner,
477      * thereby removing any functionality that is only available to the owner.
478      */
479     function renounceOwnership() public virtual onlyOwner {
480         emit OwnershipTransferred(_owner, address(0));
481         _owner = address(0);
482     }
483 
484     /**
485      * @dev Transfers ownership of the contract to a new account (`newOwner`).
486      * Can only be called by the current owner.
487      */
488     function transferOwnership(address newOwner) public virtual onlyOwner {
489         require(newOwner != address(0), "Ownable: new owner is the zero address");
490         emit OwnershipTransferred(_owner, newOwner);
491         _owner = newOwner;
492     }
493 
494     function getUnlockTime() public view returns (uint256) {
495         return _lockTime;
496     }
497 
498     //Locks the contract for owner for the amount of time provided
499     function lock(uint256 time) public virtual onlyOwner {
500         _previousOwner = _owner;
501         _owner = address(0);
502         _lockTime = now + time;
503         emit OwnershipTransferred(_owner, address(0));
504     }
505     
506     //Unlocks the contract for owner when _lockTime is exceeds
507     function unlock() public virtual {
508         require(_previousOwner == msg.sender, "You don't have permission to unlock");
509         require(now > _lockTime , "Contract is locked until 7 days");
510         emit OwnershipTransferred(_owner, _previousOwner);
511         _owner = _previousOwner;
512     }
513 }
514 
515 // pragma solidity >=0.5.0;
516 
517 interface IUniswapV2Factory {
518     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
519 
520     function feeTo() external view returns (address);
521     function feeToSetter() external view returns (address);
522 
523     function getPair(address tokenA, address tokenB) external view returns (address pair);
524     function allPairs(uint) external view returns (address pair);
525     function allPairsLength() external view returns (uint);
526 
527     function createPair(address tokenA, address tokenB) external returns (address pair);
528 
529     function setFeeTo(address) external;
530     function setFeeToSetter(address) external;
531 }
532 
533 
534 // pragma solidity >=0.5.0;
535 
536 interface IUniswapV2Pair {
537     event Approval(address indexed owner, address indexed spender, uint value);
538     event Transfer(address indexed from, address indexed to, uint value);
539 
540     function name() external pure returns (string memory);
541     function symbol() external pure returns (string memory);
542     function decimals() external pure returns (uint8);
543     function totalSupply() external view returns (uint);
544     function balanceOf(address owner) external view returns (uint);
545     function allowance(address owner, address spender) external view returns (uint);
546 
547     function approve(address spender, uint value) external returns (bool);
548     function transfer(address to, uint value) external returns (bool);
549     function transferFrom(address from, address to, uint value) external returns (bool);
550 
551     function DOMAIN_SEPARATOR() external view returns (bytes32);
552     function PERMIT_TYPEHASH() external pure returns (bytes32);
553     function nonces(address owner) external view returns (uint);
554 
555     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
556 
557     event Mint(address indexed sender, uint amount0, uint amount1);
558     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
559     event Swap(
560         address indexed sender,
561         uint amount0In,
562         uint amount1In,
563         uint amount0Out,
564         uint amount1Out,
565         address indexed to
566     );
567     event Sync(uint112 reserve0, uint112 reserve1);
568 
569     function MINIMUM_LIQUIDITY() external pure returns (uint);
570     function factory() external view returns (address);
571     function token0() external view returns (address);
572     function token1() external view returns (address);
573     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
574     function price0CumulativeLast() external view returns (uint);
575     function price1CumulativeLast() external view returns (uint);
576     function kLast() external view returns (uint);
577 
578     function mint(address to) external returns (uint liquidity);
579     function burn(address to) external returns (uint amount0, uint amount1);
580     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
581     function skim(address to) external;
582     function sync() external;
583 
584     function initialize(address, address) external;
585 }
586 
587 // pragma solidity >=0.6.2;
588 
589 interface IUniswapV2Router01 {
590     function factory() external pure returns (address);
591     function WETH() external pure returns (address);
592 
593     function addLiquidity(
594         address tokenA,
595         address tokenB,
596         uint amountADesired,
597         uint amountBDesired,
598         uint amountAMin,
599         uint amountBMin,
600         address to,
601         uint deadline
602     ) external returns (uint amountA, uint amountB, uint liquidity);
603     function addLiquidityETH(
604         address token,
605         uint amountTokenDesired,
606         uint amountTokenMin,
607         uint amountETHMin,
608         address to,
609         uint deadline
610     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
611     function removeLiquidity(
612         address tokenA,
613         address tokenB,
614         uint liquidity,
615         uint amountAMin,
616         uint amountBMin,
617         address to,
618         uint deadline
619     ) external returns (uint amountA, uint amountB);
620     function removeLiquidityETH(
621         address token,
622         uint liquidity,
623         uint amountTokenMin,
624         uint amountETHMin,
625         address to,
626         uint deadline
627     ) external returns (uint amountToken, uint amountETH);
628     function removeLiquidityWithPermit(
629         address tokenA,
630         address tokenB,
631         uint liquidity,
632         uint amountAMin,
633         uint amountBMin,
634         address to,
635         uint deadline,
636         bool approveMax, uint8 v, bytes32 r, bytes32 s
637     ) external returns (uint amountA, uint amountB);
638     function removeLiquidityETHWithPermit(
639         address token,
640         uint liquidity,
641         uint amountTokenMin,
642         uint amountETHMin,
643         address to,
644         uint deadline,
645         bool approveMax, uint8 v, bytes32 r, bytes32 s
646     ) external returns (uint amountToken, uint amountETH);
647     function swapExactTokensForTokens(
648         uint amountIn,
649         uint amountOutMin,
650         address[] calldata path,
651         address to,
652         uint deadline
653     ) external returns (uint[] memory amounts);
654     function swapTokensForExactTokens(
655         uint amountOut,
656         uint amountInMax,
657         address[] calldata path,
658         address to,
659         uint deadline
660     ) external returns (uint[] memory amounts);
661     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
662         external
663         payable
664         returns (uint[] memory amounts);
665     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
666         external
667         returns (uint[] memory amounts);
668     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
669         external
670         returns (uint[] memory amounts);
671     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
672         external
673         payable
674         returns (uint[] memory amounts);
675 
676     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
677     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
678     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
679     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
680     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
681 }
682 
683 
684 // pragma solidity >=0.6.2;
685 
686 interface IUniswapV2Router02 is IUniswapV2Router01 {
687     function removeLiquidityETHSupportingFeeOnTransferTokens(
688         address token,
689         uint liquidity,
690         uint amountTokenMin,
691         uint amountETHMin,
692         address to,
693         uint deadline
694     ) external returns (uint amountETH);
695     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
696         address token,
697         uint liquidity,
698         uint amountTokenMin,
699         uint amountETHMin,
700         address to,
701         uint deadline,
702         bool approveMax, uint8 v, bytes32 r, bytes32 s
703     ) external returns (uint amountETH);
704 
705     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
706         uint amountIn,
707         uint amountOutMin,
708         address[] calldata path,
709         address to,
710         uint deadline
711     ) external;
712     function swapExactETHForTokensSupportingFeeOnTransferTokens(
713         uint amountOutMin,
714         address[] calldata path,
715         address to,
716         uint deadline
717     ) external payable;
718     function swapExactTokensForETHSupportingFeeOnTransferTokens(
719         uint amountIn,
720         uint amountOutMin,
721         address[] calldata path,
722         address to,
723         uint deadline
724     ) external;
725 }
726 
727 
728 contract CROOGEToken is Context, IERC20, Ownable {
729     
730     using SafeMath for uint256;
731     using Address for address;
732 
733     mapping (address => uint256) private _rOwned;
734     mapping (address => uint256) private _tOwned;
735     mapping (address => mapping (address => uint256)) private _allowances;
736 
737     mapping (address => bool) private _isExcludedFromFee;
738     mapping (address => bool) private _isExcluded;
739     address[] private _excluded;
740     
741     string  private _name       = "Uncle Scrooge Finance";
742     string  private _symbol     = "CROOGE";
743     uint8   private _decimals   = 9;
744    
745     uint256 private constant MAX    = ~uint256(0);
746     uint256 private _tTotal         = 1 * 10**12 * 10**9;
747     uint256 private _rTotal         = (MAX - (MAX % _tTotal));
748     
749     uint256 private _tFeeTotal;
750     uint256 private _tBurnTotal;
751     
752     uint256 public _taxFee = 0;
753     uint256 private _previousTaxFee = _taxFee;
754     
755     uint256 public _burnFee = 0;
756     uint256 private _previousBurnFee = _burnFee;
757     
758     uint256 public _liquidityFee = 0;
759     uint256 private _previousLiquidityFee = _liquidityFee;
760 
761     IUniswapV2Router02 public immutable uniswapV2Router;
762     address public immutable uniswapV2Pair;
763     
764     bool inSwapAndLiquify;
765     bool public swapAndLiquifyEnabled = true;
766     
767     uint256 public _maxTxAmount = 3 * 10**9 * 10**9;
768     uint256 private numTokensSellToAddToLiquidity = 3 * 10**9 * 10**9;
769     
770     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
771     event SwapAndLiquifyEnabledUpdated(bool enabled);
772     event SwapAndLiquify(
773         uint256 tokensSwapped,
774         uint256 ethReceived,
775         uint256 tokensIntoLiqudity
776     );
777     
778     modifier lockTheSwap {
779         inSwapAndLiquify = true;
780         _;
781         inSwapAndLiquify = false;
782     }
783     
784     constructor () public {
785         _rOwned[_msgSender()] = _rTotal;
786         
787         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
788          // Create a uniswap pair for this new token
789         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
790             .createPair(address(this), _uniswapV2Router.WETH());
791 
792         // set the rest of the contract variables
793         uniswapV2Router = _uniswapV2Router;
794         
795         //exclude owner and this contract from fee
796         _isExcludedFromFee[owner()] = true;
797         _isExcludedFromFee[address(this)] = true;
798         
799         emit Transfer(address(0), _msgSender(), _tTotal);
800     }
801 
802     function name() public view returns (string memory) {
803         return _name;
804     }
805 
806     function symbol() public view returns (string memory) {
807         return _symbol;
808     }
809 
810     function decimals() public view returns (uint8) {
811         return _decimals;
812     }
813 
814     function totalSupply() public view override returns (uint256) {
815         return _tTotal;
816     }
817 
818     function balanceOf(address account) public view override returns (uint256) {
819         if (_isExcluded[account]) return _tOwned[account];
820         return tokenFromReflection(_rOwned[account]);
821     }
822 
823     function transfer(address recipient, uint256 amount) public override returns (bool) {
824         _transfer(_msgSender(), recipient, amount);
825         return true;
826     }
827 
828     function allowance(address owner, address spender) public view override returns (uint256) {
829         return _allowances[owner][spender];
830     }
831 
832     function approve(address spender, uint256 amount) public override returns (bool) {
833         _approve(_msgSender(), spender, amount);
834         return true;
835     }
836 
837     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
838         _transfer(sender, recipient, amount);
839         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
840         return true;
841     }
842 
843     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
844         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
845         return true;
846     }
847 
848     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
849         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
850         return true;
851     }
852 
853     function isExcludedFromReward(address account) public view returns (bool) {
854         return _isExcluded[account];
855     }
856 
857     function totalFees() public view returns (uint256) {
858         return _tFeeTotal;
859     }
860     
861     function totalBurn() public view returns (uint256) {
862         return _tBurnTotal;
863     }
864 
865     function deliver(uint256 tAmount) public {
866         address sender = _msgSender();
867         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
868         (uint256 rAmount,,,,,,) = _getValues(tAmount);
869         _rOwned[sender] = _rOwned[sender].sub(rAmount);
870         _rTotal = _rTotal.sub(rAmount);
871         _tFeeTotal = _tFeeTotal.add(tAmount);
872     }
873 
874     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
875         require(tAmount <= _tTotal, "Amount must be less than supply");
876         if (!deductTransferFee) {
877             (uint256 rAmount,,,,,,) = _getValues(tAmount);
878             return rAmount;
879         } else {
880             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
881             return rTransferAmount;
882         }
883     }
884 
885     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
886         require(rAmount <= _rTotal, "Amount must be less than total reflections");
887         uint256 currentRate =  _getRate();
888         return rAmount.div(currentRate);
889     }
890 
891     function excludeFromReward(address account) public onlyOwner() {
892         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
893         require(!_isExcluded[account], "Account is already excluded");
894         if(_rOwned[account] > 0) {
895             _tOwned[account] = tokenFromReflection(_rOwned[account]);
896         }
897         _isExcluded[account] = true;
898         _excluded.push(account);
899     }
900 
901     function includeInReward(address account) external onlyOwner() {
902         require(_isExcluded[account], "Account is already excluded");
903         for (uint256 i = 0; i < _excluded.length; i++) {
904             if (_excluded[i] == account) {
905                 _excluded[i] = _excluded[_excluded.length - 1];
906                 _tOwned[account] = 0;
907                 _isExcluded[account] = false;
908                 _excluded.pop();
909                 break;
910             }
911         }
912     }
913     
914     function excludeFromFee(address account) public onlyOwner {
915         _isExcludedFromFee[account] = true;
916     }
917     
918     function includeInFee(address account) public onlyOwner {
919         _isExcludedFromFee[account] = false;
920     }
921     
922     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
923         _taxFee = taxFee;
924     }
925     
926     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
927         _liquidityFee = liquidityFee;
928     }
929     
930     function setBurnFeePercent(uint256 burnFee) external onlyOwner() {
931         _burnFee = burnFee;
932     }
933    
934     function setMaxTxPercent(uint256 maxTxPercentMulTen) external onlyOwner() {
935         _maxTxAmount = _tTotal.mul(maxTxPercentMulTen).div(10**3);
936     }
937 
938     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
939         swapAndLiquifyEnabled = _enabled;
940         emit SwapAndLiquifyEnabledUpdated(_enabled);
941     }
942     
943      //to recieve ETH from uniswapV2Router when swaping
944     receive() external payable {}
945 
946     function _reflectFee(uint256 rFee, uint256 rBurn, uint256 tFee, uint256 tBurn) private {
947         _rTotal = _rTotal.sub(rFee).sub(rBurn);
948         _tFeeTotal = _tFeeTotal.add(tFee);
949         _tBurnTotal = _tBurnTotal.add(tBurn);
950         _tTotal = _tTotal.sub(tBurn);
951     }
952 
953     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
954         (uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity) = _getTValues(tAmount);
955         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tBurn, tLiquidity, _getRate());
956         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tBurn, tLiquidity);
957     }
958 
959     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
960         uint256 tFee = calculateTaxFee(tAmount);
961         uint256 tBurn = calculateBurnFee(tAmount);
962         uint256 tLiquidity = calculateLiquidityFee(tAmount);
963         uint256 tTransferAmount = tAmount.sub(tFee).sub(tBurn).sub(tLiquidity);
964         return (tTransferAmount, tFee, tBurn, tLiquidity);
965     }
966 
967     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
968         uint256 rAmount = tAmount.mul(currentRate);
969         uint256 rFee = tFee.mul(currentRate);
970         uint256 rBurn = tBurn.mul(currentRate);
971         uint256 rLiquidity = tLiquidity.mul(currentRate);
972         uint256 rTransferAmount = rAmount.sub(rFee).sub(rBurn).sub(rLiquidity);
973         return (rAmount, rTransferAmount, rFee);
974     }
975 
976     function _getRate() private view returns(uint256) {
977         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
978         return rSupply.div(tSupply);
979     }
980 
981     function _getCurrentSupply() private view returns(uint256, uint256) {
982         uint256 rSupply = _rTotal;
983         uint256 tSupply = _tTotal;      
984         for (uint256 i = 0; i < _excluded.length; i++) {
985             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
986             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
987             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
988         }
989         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
990         return (rSupply, tSupply);
991     }
992     
993     function _takeLiquidity(uint256 tLiquidity) private {
994         uint256 currentRate =  _getRate();
995         uint256 rLiquidity = tLiquidity.mul(currentRate);
996         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
997         if(_isExcluded[address(this)])
998             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
999     }
1000     
1001     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1002         return _amount.mul(_taxFee).div(10**2);
1003     }
1004 
1005     function calculateBurnFee(uint256 _amount) private view returns (uint256) {
1006         return _amount.mul(_burnFee).div(10**2);
1007     }
1008 
1009     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1010         return _amount.mul(_liquidityFee).div(10**2);
1011     }
1012     
1013     function removeAllFee() private {
1014         if(_taxFee == 0 && _burnFee == 0 && _liquidityFee == 0) return;
1015         
1016         _previousTaxFee = _taxFee;
1017         _previousBurnFee = _burnFee;
1018         _previousLiquidityFee = _liquidityFee;
1019         
1020         _taxFee = 0;
1021         _burnFee = 0;
1022         _liquidityFee = 0;
1023     }
1024     
1025     function restoreAllFee() private {
1026         _taxFee = _previousTaxFee;
1027         _burnFee = _previousBurnFee;
1028         _liquidityFee = _previousLiquidityFee;
1029     }
1030     
1031     function isExcludedFromFee(address account) public view returns(bool) {
1032         return _isExcludedFromFee[account];
1033     }
1034 
1035     function _approve(address owner, address spender, uint256 amount) private {
1036         require(owner != address(0), "ERC20: approve from the zero address");
1037         require(spender != address(0), "ERC20: approve to the zero address");
1038 
1039         _allowances[owner][spender] = amount;
1040         emit Approval(owner, spender, amount);
1041     }
1042 
1043     function _transfer(
1044         address from,
1045         address to,
1046         uint256 amount
1047     ) private {
1048         require(from != address(0), "ERC20: transfer from the zero address");
1049         require(to != address(0), "ERC20: transfer to the zero address");
1050         require(amount > 0, "Transfer amount must be greater than zero");
1051         if(from != owner() && to != owner()) {
1052             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1053             require(!_isExcluded[from], 'Account is excluded');
1054         }
1055 
1056         // is the token balance of this contract address over the min number of
1057         // tokens that we need to initiate a swap + liquidity lock?
1058         // also, don't get caught in a circular liquidity event.
1059         // also, don't swap & liquify if sender is uniswap pair.
1060         uint256 contractTokenBalance = balanceOf(address(this));
1061         
1062         if(contractTokenBalance >= _maxTxAmount)
1063         {
1064             contractTokenBalance = _maxTxAmount;
1065         }
1066         
1067         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1068         if (
1069             overMinTokenBalance &&
1070             !inSwapAndLiquify &&
1071             from != uniswapV2Pair &&
1072             swapAndLiquifyEnabled
1073         ) {
1074             contractTokenBalance = numTokensSellToAddToLiquidity;
1075             //add liquidity
1076             swapAndLiquify(contractTokenBalance);
1077         }
1078         
1079         //indicates if fee should be deducted from transfer
1080         bool takeFee = true;
1081         
1082         //if any account belongs to _isExcludedFromFee account then remove the fee
1083         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1084             takeFee = false;
1085         }
1086         
1087         //transfer amount, it will take tax, burn, liquidity fee
1088         _tokenTransfer(from,to,amount,takeFee);
1089     }
1090 
1091     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1092         // split the contract balance into halves
1093         uint256 half = contractTokenBalance.div(2);
1094         uint256 otherHalf = contractTokenBalance.sub(half);
1095 
1096         // capture the contract's current ETH balance.
1097         // this is so that we can capture exactly the amount of ETH that the
1098         // swap creates, and not make the liquidity event include any ETH that
1099         // has been manually sent to the contract
1100         uint256 initialBalance = address(this).balance;
1101 
1102         // swap tokens for ETH
1103         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1104 
1105         // how much ETH did we just swap into?
1106         uint256 newBalance = address(this).balance.sub(initialBalance);
1107 
1108         // add liquidity to uniswap
1109         addLiquidity(otherHalf, newBalance);
1110         
1111         emit SwapAndLiquify(half, newBalance, otherHalf);
1112     }
1113 
1114     function swapTokensForEth(uint256 tokenAmount) private {
1115         // generate the uniswap pair path of token -> weth
1116         address[] memory path = new address[](2);
1117         path[0] = address(this);
1118         path[1] = uniswapV2Router.WETH();
1119 
1120         _approve(address(this), address(uniswapV2Router), tokenAmount);
1121 
1122         // make the swap
1123         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1124             tokenAmount,
1125             0, // accept any amount of ETH
1126             path,
1127             address(this),
1128             block.timestamp
1129         );
1130     }
1131 
1132     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1133         // approve token transfer to cover all possible scenarios
1134         _approve(address(this), address(uniswapV2Router), tokenAmount);
1135 
1136         // add the liquidity
1137         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1138             address(this),
1139             tokenAmount,
1140             0, // slippage is unavoidable
1141             0, // slippage is unavoidable
1142             owner(),
1143             block.timestamp
1144         );
1145     }
1146 
1147     //this method is responsible for taking all fee, if takeFee is true
1148     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1149         if(!takeFee)
1150             removeAllFee();
1151         
1152         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1153             _transferFromExcluded(sender, recipient, amount);
1154         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1155             _transferToExcluded(sender, recipient, amount);
1156         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1157             _transferStandard(sender, recipient, amount);
1158         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1159             _transferBothExcluded(sender, recipient, amount);
1160         } else {
1161             _transferStandard(sender, recipient, amount);
1162         }
1163         
1164         if(!takeFee)
1165             restoreAllFee();
1166     }
1167 
1168     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1169         uint256 currentRate =  _getRate();
1170         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity) = _getValues(tAmount);
1171          uint256 rBurn =  tBurn.mul(currentRate);
1172         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1173         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1174         _takeLiquidity(tLiquidity);
1175         _reflectFee(rFee, rBurn, tFee, tBurn);
1176         emit Transfer(sender, recipient, tTransferAmount);
1177     }
1178 
1179     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1180         uint256 currentRate =  _getRate();
1181         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity) = _getValues(tAmount);
1182         uint256 rBurn =  tBurn.mul(currentRate);
1183         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1184         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1185         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1186         _takeLiquidity(tLiquidity);
1187         _reflectFee(rFee, rBurn, tFee, tBurn);
1188         emit Transfer(sender, recipient, tTransferAmount);
1189     }
1190 
1191     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1192         uint256 currentRate =  _getRate();
1193         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity) = _getValues(tAmount);
1194         uint256 rBurn =  tBurn.mul(currentRate);
1195         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1196         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1197         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1198         _takeLiquidity(tLiquidity);
1199         _reflectFee(rFee, rBurn, tFee, tBurn);
1200         emit Transfer(sender, recipient, tTransferAmount);
1201     }
1202     
1203     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1204         uint256 currentRate =  _getRate();
1205         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tLiquidity) = _getValues(tAmount);
1206         uint256 rBurn =  tBurn.mul(currentRate);
1207         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1208         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1209         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1210         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
1211         _takeLiquidity(tLiquidity);
1212         _reflectFee(rFee, rBurn, tFee, tBurn);
1213         emit Transfer(sender, recipient, tTransferAmount);
1214     }
1215 
1216 }