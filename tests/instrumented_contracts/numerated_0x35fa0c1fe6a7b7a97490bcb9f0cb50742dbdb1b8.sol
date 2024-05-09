1 /**
2 Gamers Yield: $GY
3 - You buy on Ethereum, we farm on game yield and return the profits to $GY holders.
4 
5 Tokenomics:
6 5% of each buy/sell goes to existing holders.
7 5% of each buy/sell goes into multi-chain farming to add to the treasury and buy back GY tokens.
8 /**
9 
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 pragma solidity ^0.8.4;
13 
14 interface IERC20 {
15     /**
16      * @dev Returns the amount of tokens in existence.
17      */
18     function totalSupply() external view returns (uint256);
19 
20     /**
21      * @dev Returns the amount of tokens owned by `account`.
22      */
23     function balanceOf(address account) external view returns (uint256);
24 
25     /**
26      * @dev Moves `amount` tokens from the caller's account to `recipient`.
27      *
28      * Returns a boolean value indicating whether the operation succeeded.
29      *
30      * Emits a {Transfer} event.
31      */
32     function transfer(address recipient, uint256 amount) external returns (bool);
33 
34     /**
35      * @dev Returns the remaining number of tokens that `spender` will be
36      * allowed to spend on behalf of `owner` through {transferFrom}. This is
37      * zero by default.
38      *
39      * This value changes when {approve} or {transferFrom} are called.
40      */
41     function allowance(address owner, address spender) external view returns (uint256);
42 
43     /**
44      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * IMPORTANT: Beware that changing an allowance with this method brings the risk
49      * that someone may use both the old and the new allowance by unfortunate
50      * transaction ordering. One possible solution to mitigate this race
51      * condition is to first reduce the spender's allowance to 0 and set the
52      * desired value afterwards:
53      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
54      *
55      * Emits an {Approval} event.
56      */
57     function approve(address spender, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Moves `amount` tokens from `sender` to `recipient` using the
61      * allowance mechanism. `amount` is then deducted from the caller's
62      * allowance.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * Emits a {Transfer} event.
67      */
68     function transferFrom(
69         address sender,
70         address recipient,
71         uint256 amount
72     ) external returns (bool);
73 
74     /**
75      * @dev Emitted when `value` tokens are moved from one account (`from`) to
76      * another (`to`).
77      *
78      * Note that `value` may be zero.
79      */
80     event Transfer(address indexed from, address indexed to, uint256 value);
81 
82     /**
83      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
84      * a call to {approve}. `value` is the new allowance.
85      */
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 
90 pragma solidity ^0.8.0;
91 
92 // CAUTION
93 // This version of SafeMath should only be used with Solidity 0.8 or later,
94 // because it relies on the compiler's built in overflow checks.
95 
96 /**
97  * @dev Wrappers over Solidity's arithmetic operations.
98  *
99  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
100  * now has built in overflow checking.
101  */
102 library SafeMath {
103     /**
104      * @dev Returns the addition of two unsigned integers, with an overflow flag.
105      *
106      * _Available since v3.4._
107      */
108     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
109         unchecked {
110             uint256 c = a + b;
111             if (c < a) return (false, 0);
112             return (true, c);
113         }
114     }
115 
116     /**
117      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
118      *
119      * _Available since v3.4._
120      */
121     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
122         unchecked {
123             if (b > a) return (false, 0);
124             return (true, a - b);
125         }
126     }
127 
128     /**
129      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
130      *
131      * _Available since v3.4._
132      */
133     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
134         unchecked {
135             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
136             // benefit is lost if 'b' is also tested.
137             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
138             if (a == 0) return (true, 0);
139             uint256 c = a * b;
140             if (c / a != b) return (false, 0);
141             return (true, c);
142         }
143     }
144 
145     /**
146      * @dev Returns the division of two unsigned integers, with a division by zero flag.
147      *
148      * _Available since v3.4._
149      */
150     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
151         unchecked {
152             if (b == 0) return (false, 0);
153             return (true, a / b);
154         }
155     }
156 
157     /**
158      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
159      *
160      * _Available since v3.4._
161      */
162     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
163         unchecked {
164             if (b == 0) return (false, 0);
165             return (true, a % b);
166         }
167     }
168 
169     /**
170      * @dev Returns the addition of two unsigned integers, reverting on
171      * overflow.
172      *
173      * Counterpart to Solidity's `+` operator.
174      *
175      * Requirements:
176      *
177      * - Addition cannot overflow.
178      */
179     function add(uint256 a, uint256 b) internal pure returns (uint256) {
180         return a + b;
181     }
182 
183     /**
184      * @dev Returns the subtraction of two unsigned integers, reverting on
185      * overflow (when the result is negative).
186      *
187      * Counterpart to Solidity's `-` operator.
188      *
189      * Requirements:
190      *
191      * - Subtraction cannot overflow.
192      */
193     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
194         return a - b;
195     }
196 
197     /**
198      * @dev Returns the multiplication of two unsigned integers, reverting on
199      * overflow.
200      *
201      * Counterpart to Solidity's `*` operator.
202      *
203      * Requirements:
204      *
205      * - Multiplication cannot overflow.
206      */
207     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
208         return a * b;
209     }
210 
211     /**
212      * @dev Returns the integer division of two unsigned integers, reverting on
213      * division by zero. The result is rounded towards zero.
214      *
215      * Counterpart to Solidity's `/` operator.
216      *
217      * Requirements:
218      *
219      * - The divisor cannot be zero.
220      */
221     function div(uint256 a, uint256 b) internal pure returns (uint256) {
222         return a / b;
223     }
224 
225     /**
226      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227      * reverting when dividing by zero.
228      *
229      * Counterpart to Solidity's `%` operator. This function uses a `revert`
230      * opcode (which leaves remaining gas untouched) while Solidity uses an
231      * invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
238         return a % b;
239     }
240 
241     /**
242      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
243      * overflow (when the result is negative).
244      *
245      * CAUTION: This function is deprecated because it requires allocating memory for the error
246      * message unnecessarily. For custom revert reasons use {trySub}.
247      *
248      * Counterpart to Solidity's `-` operator.
249      *
250      * Requirements:
251      *
252      * - Subtraction cannot overflow.
253      */
254     function sub(
255         uint256 a,
256         uint256 b,
257         string memory errorMessage
258     ) internal pure returns (uint256) {
259         unchecked {
260             require(b <= a, errorMessage);
261             return a - b;
262         }
263     }
264 
265     /**
266      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
267      * division by zero. The result is rounded towards zero.
268      *
269      * Counterpart to Solidity's `/` operator. Note: this function uses a
270      * `revert` opcode (which leaves remaining gas untouched) while Solidity
271      * uses an invalid opcode to revert (consuming all remaining gas).
272      *
273      * Requirements:
274      *
275      * - The divisor cannot be zero.
276      */
277     function div(
278         uint256 a,
279         uint256 b,
280         string memory errorMessage
281     ) internal pure returns (uint256) {
282         unchecked {
283             require(b > 0, errorMessage);
284             return a / b;
285         }
286     }
287 
288     /**
289      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
290      * reverting with custom message when dividing by zero.
291      *
292      * CAUTION: This function is deprecated because it requires allocating memory for the error
293      * message unnecessarily. For custom revert reasons use {tryMod}.
294      *
295      * Counterpart to Solidity's `%` operator. This function uses a `revert`
296      * opcode (which leaves remaining gas untouched) while Solidity uses an
297      * invalid opcode to revert (consuming all remaining gas).
298      *
299      * Requirements:
300      *
301      * - The divisor cannot be zero.
302      */
303     function mod(
304         uint256 a,
305         uint256 b,
306         string memory errorMessage
307     ) internal pure returns (uint256) {
308         unchecked {
309             require(b > 0, errorMessage);
310             return a % b;
311         }
312     }
313 }
314 
315 /*
316  * @dev Provides information about the current execution context, including the
317  * sender of the transaction and its data. While these are generally available
318  * via msg.sender and msg.data, they should not be accessed in such a direct
319  * manner, since when dealing with meta-transactions the account sending and
320  * paying for execution may not be the actual sender (as far as an application
321  * is concerned).
322  *
323  * This contract is only required for intermediate, library-like contracts.
324  */
325 abstract contract Context {
326     function _msgSender() internal view virtual returns (address) {
327         return msg.sender;
328     }
329 
330     function _msgData() internal view virtual returns (bytes calldata) {
331         return msg.data;
332     }
333 }
334 
335 /**
336  * @dev Contract module which provides a basic access control mechanism, where
337  * there is an account (an owner) that can be granted exclusive access to
338  * specific functions.
339  *
340  * By default, the owner account will be the one that deploys the contract. This
341  * can later be changed with {transferOwnership}.
342  *
343  * This module is used through inheritance. It will make available the modifier
344  * `onlyOwner`, which can be applied to your functions to restrict their use to
345  * the owner.
346  */
347 abstract contract Ownable is Context {
348     address private _owner;
349 
350     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
351 
352     /**
353      * @dev Initializes the contract setting the deployer as the initial owner.
354      */
355     constructor() {
356         _setOwner(_msgSender());
357     }
358 
359     /**
360      * @dev Returns the address of the current owner.
361      */
362     function owner() public view virtual returns (address) {
363         return _owner;
364     }
365 
366     /**
367      * @dev Throws if called by any account other than the owner.
368      */
369     modifier onlyOwner() {
370         require(owner() == _msgSender(), "Ownable: caller is not the owner");
371         _;
372     }
373 
374     /**
375      * @dev Leaves the contract without owner. It will not be possible to call
376      * `onlyOwner` functions anymore. Can only be called by the current owner.
377      *
378      * NOTE: Renouncing ownership will leave the contract without an owner,
379      * thereby removing any functionality that is only available to the owner.
380      */
381     function renounceOwnership() public virtual onlyOwner {
382         _setOwner(address(0));
383     }
384 
385     /**
386      * @dev Transfers ownership of the contract to a new account (`newOwner`).
387      * Can only be called by the current owner.
388      */
389     function transferOwnership(address newOwner) public virtual onlyOwner {
390         require(newOwner != address(0), "Ownable: new owner is the zero address");
391         _setOwner(newOwner);
392     }
393 
394     function _setOwner(address newOwner) private {
395         address oldOwner = _owner;
396         _owner = newOwner;
397         emit OwnershipTransferred(oldOwner, newOwner);
398     }
399 }
400 
401 
402 pragma solidity ^0.8.0;
403 
404 /**
405  * @dev Collection of functions related to the address type
406  */
407 library Address {
408     /**
409      * @dev Returns true if `account` is a contract.
410      *
411      * [IMPORTANT]
412      * ====
413      * It is unsafe to assume that an address for which this function returns
414      * false is an externally-owned account (EOA) and not a contract.
415      *
416      * Among others, `isContract` will return false for the following
417      * types of addresses:
418      *
419      *  - an externally-owned account
420      *  - a contract in construction
421      *  - an address where a contract will be created
422      *  - an address where a contract lived, but was destroyed
423      * ====
424      */
425     function isContract(address account) internal view returns (bool) {
426         // This method relies on extcodesize, which returns 0 for contracts in
427         // construction, since the code is only stored at the end of the
428         // constructor execution.
429 
430         uint256 size;
431         assembly {
432             size := extcodesize(account)
433         }
434         return size > 0;
435     }
436 
437     /**
438      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
439      * `recipient`, forwarding all available gas and reverting on errors.
440      *
441      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
442      * of certain opcodes, possibly making contracts go over the 2300 gas limit
443      * imposed by `transfer`, making them unable to receive funds via
444      * `transfer`. {sendValue} removes this limitation.
445      *
446      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
447      *
448      * IMPORTANT: because control is transferred to `recipient`, care must be
449      * taken to not create reentrancy vulnerabilities. Consider using
450      * {ReentrancyGuard} or the
451      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
452      */
453     function sendValue(address payable recipient, uint256 amount) internal {
454         require(address(this).balance >= amount, "Address: insufficient balance");
455 
456         (bool success, ) = recipient.call{value: amount}("");
457         require(success, "Address: unable to send value, recipient may have reverted");
458     }
459 
460     /**
461      * @dev Performs a Solidity function call using a low level `call`. A
462      * plain `call` is an unsafe replacement for a function call: use this
463      * function instead.
464      *
465      * If `target` reverts with a revert reason, it is bubbled up by this
466      * function (like regular Solidity function calls).
467      *
468      * Returns the raw returned data. To convert to the expected return value,
469      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
470      *
471      * Requirements:
472      *
473      * - `target` must be a contract.
474      * - calling `target` with `data` must not revert.
475      *
476      * _Available since v3.1._
477      */
478     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
479         return functionCall(target, data, "Address: low-level call failed");
480     }
481 
482     /**
483      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
484      * `errorMessage` as a fallback revert reason when `target` reverts.
485      *
486      * _Available since v3.1._
487      */
488     function functionCall(
489         address target,
490         bytes memory data,
491         string memory errorMessage
492     ) internal returns (bytes memory) {
493         return functionCallWithValue(target, data, 0, errorMessage);
494     }
495 
496     /**
497      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
498      * but also transferring `value` wei to `target`.
499      *
500      * Requirements:
501      *
502      * - the calling contract must have an ETH balance of at least `value`.
503      * - the called Solidity function must be `payable`.
504      *
505      * _Available since v3.1._
506      */
507     function functionCallWithValue(
508         address target,
509         bytes memory data,
510         uint256 value
511     ) internal returns (bytes memory) {
512         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
513     }
514 
515     /**
516      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
517      * with `errorMessage` as a fallback revert reason when `target` reverts.
518      *
519      * _Available since v3.1._
520      */
521     function functionCallWithValue(
522         address target,
523         bytes memory data,
524         uint256 value,
525         string memory errorMessage
526     ) internal returns (bytes memory) {
527         require(address(this).balance >= value, "Address: insufficient balance for call");
528         require(isContract(target), "Address: call to non-contract");
529 
530         (bool success, bytes memory returndata) = target.call{value: value}(data);
531         return _verifyCallResult(success, returndata, errorMessage);
532     }
533 
534     /**
535      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
536      * but performing a static call.
537      *
538      * _Available since v3.3._
539      */
540     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
541         return functionStaticCall(target, data, "Address: low-level static call failed");
542     }
543 
544     /**
545      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
546      * but performing a static call.
547      *
548      * _Available since v3.3._
549      */
550     function functionStaticCall(
551         address target,
552         bytes memory data,
553         string memory errorMessage
554     ) internal view returns (bytes memory) {
555         require(isContract(target), "Address: static call to non-contract");
556 
557         (bool success, bytes memory returndata) = target.staticcall(data);
558         return _verifyCallResult(success, returndata, errorMessage);
559     }
560 
561     /**
562      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
563      * but performing a delegate call.
564      *
565      * _Available since v3.4._
566      */
567     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
568         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
569     }
570 
571     /**
572      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
573      * but performing a delegate call.
574      *
575      * _Available since v3.4._
576      */
577     function functionDelegateCall(
578         address target,
579         bytes memory data,
580         string memory errorMessage
581     ) internal returns (bytes memory) {
582         require(isContract(target), "Address: delegate call to non-contract");
583 
584         (bool success, bytes memory returndata) = target.delegatecall(data);
585         return _verifyCallResult(success, returndata, errorMessage);
586     }
587 
588     function _verifyCallResult(
589         bool success,
590         bytes memory returndata,
591         string memory errorMessage
592     ) private pure returns (bytes memory) {
593         if (success) {
594             return returndata;
595         } else {
596             // Look for revert reason and bubble it up if present
597             if (returndata.length > 0) {
598                 // The easiest way to bubble the revert reason is using memory via assembly
599 
600                 assembly {
601                     let returndata_size := mload(returndata)
602                     revert(add(32, returndata), returndata_size)
603                 }
604             } else {
605                 revert(errorMessage);
606             }
607         }
608     }
609 }
610 
611 pragma solidity >=0.5.0;
612 
613 interface IUniswapV2Factory {
614     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
615 
616     function feeTo() external view returns (address);
617     function feeToSetter() external view returns (address);
618 
619     function getPair(address tokenA, address tokenB) external view returns (address pair);
620     function allPairs(uint) external view returns (address pair);
621     function allPairsLength() external view returns (uint);
622 
623     function createPair(address tokenA, address tokenB) external returns (address pair);
624 
625     function setFeeTo(address) external;
626     function setFeeToSetter(address) external;
627 }
628 
629 pragma solidity >=0.5.0;
630 
631 interface IUniswapV2Pair {
632     event Approval(address indexed owner, address indexed spender, uint value);
633     event Transfer(address indexed from, address indexed to, uint value);
634 
635     function name() external pure returns (string memory);
636     function symbol() external pure returns (string memory);
637     function decimals() external pure returns (uint8);
638     function totalSupply() external view returns (uint);
639     function balanceOf(address owner) external view returns (uint);
640     function allowance(address owner, address spender) external view returns (uint);
641 
642     function approve(address spender, uint value) external returns (bool);
643     function transfer(address to, uint value) external returns (bool);
644     function transferFrom(address from, address to, uint value) external returns (bool);
645 
646     function DOMAIN_SEPARATOR() external view returns (bytes32);
647     function PERMIT_TYPEHASH() external pure returns (bytes32);
648     function nonces(address owner) external view returns (uint);
649 
650     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
651 
652     event Mint(address indexed sender, uint amount0, uint amount1);
653     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
654     event Swap(
655         address indexed sender,
656         uint amount0In,
657         uint amount1In,
658         uint amount0Out,
659         uint amount1Out,
660         address indexed to
661     );
662     event Sync(uint112 reserve0, uint112 reserve1);
663 
664     function MINIMUM_LIQUIDITY() external pure returns (uint);
665     function factory() external view returns (address);
666     function token0() external view returns (address);
667     function token1() external view returns (address);
668     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
669     function price0CumulativeLast() external view returns (uint);
670     function price1CumulativeLast() external view returns (uint);
671     function kLast() external view returns (uint);
672 
673     function mint(address to) external returns (uint liquidity);
674     function burn(address to) external returns (uint amount0, uint amount1);
675     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
676     function skim(address to) external;
677     function sync() external;
678 
679     function initialize(address, address) external;
680 }
681 
682 pragma solidity >=0.6.2;
683 
684 interface IUniswapV2Router01 {
685     function factory() external pure returns (address);
686     function WETH() external pure returns (address);
687 
688     function addLiquidity(
689         address tokenA,
690         address tokenB,
691         uint amountADesired,
692         uint amountBDesired,
693         uint amountAMin,
694         uint amountBMin,
695         address to,
696         uint deadline
697     ) external returns (uint amountA, uint amountB, uint liquidity);
698     function addLiquidityETH(
699         address token,
700         uint amountTokenDesired,
701         uint amountTokenMin,
702         uint amountETHMin,
703         address to,
704         uint deadline
705     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
706     function removeLiquidity(
707         address tokenA,
708         address tokenB,
709         uint liquidity,
710         uint amountAMin,
711         uint amountBMin,
712         address to,
713         uint deadline
714     ) external returns (uint amountA, uint amountB);
715     function removeLiquidityETH(
716         address token,
717         uint liquidity,
718         uint amountTokenMin,
719         uint amountETHMin,
720         address to,
721         uint deadline
722     ) external returns (uint amountToken, uint amountETH);
723     function removeLiquidityWithPermit(
724         address tokenA,
725         address tokenB,
726         uint liquidity,
727         uint amountAMin,
728         uint amountBMin,
729         address to,
730         uint deadline,
731         bool approveMax, uint8 v, bytes32 r, bytes32 s
732     ) external returns (uint amountA, uint amountB);
733     function removeLiquidityETHWithPermit(
734         address token,
735         uint liquidity,
736         uint amountTokenMin,
737         uint amountETHMin,
738         address to,
739         uint deadline,
740         bool approveMax, uint8 v, bytes32 r, bytes32 s
741     ) external returns (uint amountToken, uint amountETH);
742     function swapExactTokensForTokens(
743         uint amountIn,
744         uint amountOutMin,
745         address[] calldata path,
746         address to,
747         uint deadline
748     ) external returns (uint[] memory amounts);
749     function swapTokensForExactTokens(
750         uint amountOut,
751         uint amountInMax,
752         address[] calldata path,
753         address to,
754         uint deadline
755     ) external returns (uint[] memory amounts);
756     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
757         external
758         payable
759         returns (uint[] memory amounts);
760     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
761         external
762         returns (uint[] memory amounts);
763     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
764         external
765         returns (uint[] memory amounts);
766     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
767         external
768         payable
769         returns (uint[] memory amounts);
770 
771     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
772     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
773     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
774     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
775     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
776 }
777 
778 interface IUniswapV2Router02 is IUniswapV2Router01 {
779     function removeLiquidityETHSupportingFeeOnTransferTokens(
780         address token,
781         uint liquidity,
782         uint amountTokenMin,
783         uint amountETHMin,
784         address to,
785         uint deadline
786     ) external returns (uint amountETH);
787     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
788         address token,
789         uint liquidity,
790         uint amountTokenMin,
791         uint amountETHMin,
792         address to,
793         uint deadline,
794         bool approveMax, uint8 v, bytes32 r, bytes32 s
795     ) external returns (uint amountETH);
796 
797     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
798         uint amountIn,
799         uint amountOutMin,
800         address[] calldata path,
801         address to,
802         uint deadline
803     ) external;
804     function swapExactETHForTokensSupportingFeeOnTransferTokens(
805         uint amountOutMin,
806         address[] calldata path,
807         address to,
808         uint deadline
809     ) external payable;
810     function swapExactTokensForETHSupportingFeeOnTransferTokens(
811         uint amountIn,
812         uint amountOutMin,
813         address[] calldata path,
814         address to,
815         uint deadline
816     ) external;
817 }
818 
819 // Contract implementation
820 contract GamersYield is Context, IERC20, Ownable {
821   using SafeMath for uint256;
822   using Address for address;
823 
824   mapping(address => uint256) private _rOwned;
825   mapping(address => uint256) private _tOwned;
826   mapping(address => mapping(address => uint256)) private _allowances;
827 
828   mapping(address => bool) private _isExcludedFromFee;
829 
830   mapping(address => bool) private _isExcluded;
831   address[] private _excluded;
832 
833   uint256 private constant MAX = ~uint256(0);
834   uint256 private _tTotal =  1000000*10**7;
835   uint256 private _rTotal = (MAX - (MAX % _tTotal));
836   uint256 private _tFeeTotal;
837 
838   string private _name = 'GamersYield';
839   string private _symbol = 'GY';
840   uint8 private _decimals = 6;
841 
842   uint256 private _taxFee = 5;
843   uint256 private _teamFee = 5;
844   uint256 private _previousTaxFee = _taxFee;
845   uint256 private _previousTeamFee = _teamFee;
846 
847   address payable public _GYWalletAddress;
848   address payable public _marketingWalletAddress;
849 
850   IUniswapV2Router02 public immutable uniswapV2Router;
851   address public immutable uniswapV2Pair;
852   mapping(address => bool) private _isUniswapPair;
853 
854   bool inSwap = false;
855   bool public swapEnabled = true;
856 
857   uint8 _sellTaxMultiplier = 1;
858 
859   uint256 private _maxTxAmount = 300000000000000e9;
860   uint256 private _numOfTokensToExchangeForTeam = 1;
861 
862   struct AirdropReceiver {
863     address addy;
864     uint256 amount;
865   }
866 
867   event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
868   event SwapEnabledUpdated(bool enabled);
869 
870   modifier lockTheSwap() {
871     inSwap = true;
872     _;
873     inSwap = false;
874   }
875 
876   constructor( )
877    {
878     _GYWalletAddress = payable(0xf087c044a75953f41B300A9130E771B0F56A8195);
879     _marketingWalletAddress = payable(0x6366c165a0D2620D0EF1dd0a072F80137DFDA780);
880     _rOwned[_msgSender()] = _rTotal;
881 
882     IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
883       0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
884     ); // UniswapV2 for Ethereum network
885     // Create a uniswap pair for this new token
886     uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(
887       address(this),
888       _uniswapV2Router.WETH()
889     );
890 
891     // set the rest of the contract variables
892     uniswapV2Router = _uniswapV2Router;
893 
894     // Exclude owner and this contract from fee
895     _isExcludedFromFee[owner()] = true;
896     _isExcludedFromFee[address(this)] = true;
897 
898     emit Transfer(address(0), _msgSender(), _tTotal);
899   }
900 
901   function name() public view returns (string memory) {
902     return _name;
903   }
904 
905   function symbol() public view returns (string memory) {
906     return _symbol;
907   }
908 
909   function decimals() public view returns (uint8) {
910     return _decimals;
911   }
912 
913   function totalSupply() public view override returns (uint256) {
914     return _tTotal;
915   }
916 
917   function balanceOf(address account) public view override returns (uint256) {
918     if (_isExcluded[account]) return _tOwned[account];
919     return tokenFromReflection(_rOwned[account]);
920   }
921 
922   function transfer(address recipient, uint256 amount)
923     public
924     override
925     returns (bool)
926   {
927     _transfer(_msgSender(), recipient, amount);
928     return true;
929   }
930 
931   function allowance(address owner, address spender)
932     public
933     view
934     override
935     returns (uint256)
936   {
937     return _allowances[owner][spender];
938   }
939 
940   function approve(address spender, uint256 amount)
941     public
942     override
943     returns (bool)
944   {
945     _approve(_msgSender(), spender, amount);
946     return true;
947   }
948 
949   function transferFrom(
950     address sender,
951     address recipient,
952     uint256 amount
953   ) public override returns (bool) {
954     _transfer(sender, recipient, amount);
955     _approve(
956       sender,
957       _msgSender(),
958       _allowances[sender][_msgSender()].sub(
959         amount,
960         'ERC20: transfer amount exceeds allowance'
961       )
962     );
963     return true;
964   }
965 
966   function increaseAllowance(address spender, uint256 addedValue)
967     public
968     virtual
969     returns (bool)
970   {
971     _approve(
972       _msgSender(),
973       spender,
974       _allowances[_msgSender()][spender].add(addedValue)
975     );
976     return true;
977   }
978 
979   function decreaseAllowance(address spender, uint256 subtractedValue)
980     public
981     virtual
982     returns (bool)
983   {
984     _approve(
985       _msgSender(),
986       spender,
987       _allowances[_msgSender()][spender].sub(
988         subtractedValue,
989         'ERC20: decreased allowance below zero'
990       )
991     );
992     return true;
993   }
994 
995   function isExcluded(address account) public view returns (bool) {
996     return _isExcluded[account];
997   }
998 
999   function setExcludeFromFee(address account, bool excluded)
1000     external
1001     onlyOwner
1002   {
1003     _isExcludedFromFee[account] = excluded;
1004   }
1005 
1006   function totalFees() public view returns (uint256) {
1007     return _tFeeTotal;
1008   }
1009 
1010   function deliver(uint256 tAmount) public {
1011     address sender = _msgSender();
1012     require(
1013       !_isExcluded[sender],
1014       'Excluded addresses cannot call this function'
1015     );
1016     (uint256 rAmount, , , , , ) = _getValues(tAmount, false);
1017     _rOwned[sender] = _rOwned[sender].sub(rAmount);
1018     _rTotal = _rTotal.sub(rAmount);
1019     _tFeeTotal = _tFeeTotal.add(tAmount);
1020   }
1021 
1022   function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
1023     public
1024     view
1025     returns (uint256)
1026   {
1027     require(tAmount <= _tTotal, 'Amount must be less than supply');
1028     if (!deductTransferFee) {
1029       (uint256 rAmount, , , , , ) = _getValues(tAmount, false);
1030       return rAmount;
1031     } else {
1032       (, uint256 rTransferAmount, , , , ) = _getValues(tAmount, false);
1033       return rTransferAmount;
1034     }
1035   }
1036 
1037   function tokenFromReflection(uint256 rAmount) public view returns (uint256) {
1038     require(rAmount <= _rTotal, 'Amount must be less than total reflections');
1039     uint256 currentRate = _getRate();
1040     return rAmount.div(currentRate);
1041   }
1042 
1043   function excludeAccount(address account) external onlyOwner {
1044     require(
1045       account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D,
1046       'We can not exclude Uniswap router.'
1047     );
1048     require(!_isExcluded[account], 'Account is already excluded');
1049     if (_rOwned[account] > 0) {
1050       _tOwned[account] = tokenFromReflection(_rOwned[account]);
1051     }
1052     _isExcluded[account] = true;
1053     _excluded.push(account);
1054   }
1055 
1056   function includeAccount(address account) external onlyOwner {
1057     require(_isExcluded[account], 'Account is already excluded');
1058     for (uint256 i = 0; i < _excluded.length; i++) {
1059       if (_excluded[i] == account) {
1060         _excluded[i] = _excluded[_excluded.length - 1];
1061         _tOwned[account] = 0;
1062         _isExcluded[account] = false;
1063         _excluded.pop();
1064         break;
1065       }
1066     }
1067   }
1068 
1069   function removeAllFee() private {
1070     if (_taxFee == 0 && _teamFee == 0) return;
1071 
1072     _previousTaxFee = _taxFee;
1073     _previousTeamFee = _teamFee;
1074 
1075     _taxFee = 0;
1076     _teamFee = 0;
1077   }
1078 
1079   function restoreAllFee() private {
1080     _taxFee = _previousTaxFee;
1081     _teamFee = _previousTeamFee;
1082   }
1083 
1084   function isExcludedFromFee(address account) public view returns (bool) {
1085     return _isExcludedFromFee[account];
1086   }
1087 
1088   function _approve(
1089     address owner,
1090     address spender,
1091     uint256 amount
1092   ) private {
1093     require(owner != address(0), 'ERC20: approve from the zero address');
1094     require(spender != address(0), 'ERC20: approve to the zero address');
1095 
1096     _allowances[owner][spender] = amount;
1097     emit Approval(owner, spender, amount);
1098   }
1099 
1100   function _transfer(
1101     address sender,
1102     address recipient,
1103     uint256 amount
1104   ) private {
1105     require(sender != address(0), 'ERC20: transfer from the zero address');
1106     require(recipient != address(0), 'ERC20: transfer to the zero address');
1107     require(amount > 0, 'Transfer amount must be greater than zero');
1108 
1109     if (sender != owner() && recipient != owner())
1110       require(
1111         amount <= _maxTxAmount,
1112         'Transfer amount exceeds the maxTxAmount.'
1113       );
1114 
1115     // is the token balance of this contract address over the min number of
1116     // tokens that we need to initiate a swap?
1117     // also, don't get caught in a circular team event.
1118     // also, don't swap if sender is uniswap pair.
1119     uint256 contractTokenBalance = balanceOf(address(this));
1120 
1121     if (contractTokenBalance >= _maxTxAmount) {
1122       contractTokenBalance = _maxTxAmount;
1123     }
1124 
1125     bool overMinTokenBalance = contractTokenBalance >=
1126       _numOfTokensToExchangeForTeam;
1127     if (
1128       !inSwap &&
1129       swapEnabled &&
1130       overMinTokenBalance &&
1131       (recipient == uniswapV2Pair || _isUniswapPair[recipient])
1132     ) {
1133       // We need to swap the current tokens to ETH and send to the team wallet
1134       swapTokensForEth(contractTokenBalance);
1135 
1136       uint256 contractETHBalance = address(this).balance;
1137       if (contractETHBalance > 0) {
1138         sendETHToTeam(address(this).balance);
1139       }
1140     }
1141 
1142     // indicates if fee should be deducted from transfer
1143     bool takeFee = false;
1144 
1145     // take fee only on swaps
1146     if (
1147       (sender == uniswapV2Pair ||
1148         recipient == uniswapV2Pair ||
1149         _isUniswapPair[recipient] ||
1150         _isUniswapPair[sender]) &&
1151       !(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient])
1152     ) {
1153       takeFee = true;
1154     }
1155 
1156     //transfer amount, it will take tax and team fee
1157     _tokenTransfer(sender, recipient, amount, takeFee);
1158   }
1159 
1160   function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
1161     // generate the uniswap pair path of token -> weth
1162     address[] memory path = new address[](2);
1163     path[0] = address(this);
1164     path[1] = uniswapV2Router.WETH();
1165 
1166     _approve(address(this), address(uniswapV2Router), tokenAmount);
1167 
1168     // make the swap
1169     uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1170       tokenAmount,
1171       0, // accept any amount of ETH
1172       path,
1173       address(this),
1174       block.timestamp
1175     );
1176   }
1177 
1178   function sendETHToTeam(uint256 amount) private {
1179     _GYWalletAddress.call{ value: amount.div(2) }('');
1180     _marketingWalletAddress.call{ value: amount.div(2) }('');
1181   }
1182 
1183   // We are exposing these functions to be able to manual swap and send
1184   // in case the token is highly valued and 5M becomes too much
1185   function manualSwap() external onlyOwner {
1186     uint256 contractBalance = balanceOf(address(this));
1187     swapTokensForEth(contractBalance);
1188   }
1189 
1190   function manualSend() external onlyOwner {
1191     uint256 contractETHBalance = address(this).balance;
1192     sendETHToTeam(contractETHBalance);
1193   }
1194 
1195   function setSwapEnabled(bool enabled) external onlyOwner {
1196     swapEnabled = enabled;
1197   }
1198 
1199   function _tokenTransfer(
1200     address sender,
1201     address recipient,
1202     uint256 amount,
1203     bool takeFee
1204   ) private {
1205     if (!takeFee) removeAllFee();
1206 
1207     if (_isExcluded[sender] && !_isExcluded[recipient]) {
1208       _transferFromExcluded(sender, recipient, amount);
1209     } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1210       _transferToExcluded(sender, recipient, amount);
1211     } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1212       _transferBothExcluded(sender, recipient, amount);
1213     } else {
1214       _transferStandard(sender, recipient, amount);
1215     }
1216 
1217     if (!takeFee) restoreAllFee();
1218   }
1219 
1220   function _transferStandard(
1221     address sender,
1222     address recipient,
1223     uint256 tAmount
1224   ) private {
1225     (
1226       uint256 rAmount,
1227       uint256 rTransferAmount,
1228       uint256 rFee,
1229       uint256 tTransferAmount,
1230       uint256 tFee,
1231       uint256 tTeam
1232     ) = _getValues(tAmount, _isSelling(recipient));
1233     _rOwned[sender] = _rOwned[sender].sub(rAmount);
1234     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1235     _takeTeam(tTeam);
1236     _reflectFee(rFee, tFee);
1237     emit Transfer(sender, recipient, tTransferAmount);
1238   }
1239 
1240   function _transferToExcluded(
1241     address sender,
1242     address recipient,
1243     uint256 tAmount
1244   ) private {
1245     (
1246       uint256 rAmount,
1247       uint256 rTransferAmount,
1248       uint256 rFee,
1249       uint256 tTransferAmount,
1250       uint256 tFee,
1251       uint256 tTeam
1252     ) = _getValues(tAmount, _isSelling(recipient));
1253     _rOwned[sender] = _rOwned[sender].sub(rAmount);
1254     _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1255     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1256     _takeTeam(tTeam);
1257     _reflectFee(rFee, tFee);
1258     emit Transfer(sender, recipient, tTransferAmount);
1259   }
1260 
1261   function _transferFromExcluded(
1262     address sender,
1263     address recipient,
1264     uint256 tAmount
1265   ) private {
1266     (
1267       uint256 rAmount,
1268       uint256 rTransferAmount,
1269       uint256 rFee,
1270       uint256 tTransferAmount,
1271       uint256 tFee,
1272       uint256 tTeam
1273     ) = _getValues(tAmount, _isSelling(recipient));
1274     _tOwned[sender] = _tOwned[sender].sub(tAmount);
1275     _rOwned[sender] = _rOwned[sender].sub(rAmount);
1276     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1277     _takeTeam(tTeam);
1278     _reflectFee(rFee, tFee);
1279     emit Transfer(sender, recipient, tTransferAmount);
1280   }
1281 
1282   function _transferBothExcluded(
1283     address sender,
1284     address recipient,
1285     uint256 tAmount
1286   ) private {
1287     (
1288       uint256 rAmount,
1289       uint256 rTransferAmount,
1290       uint256 rFee,
1291       uint256 tTransferAmount,
1292       uint256 tFee,
1293       uint256 tTeam
1294     ) = _getValues(tAmount, _isSelling(recipient));
1295     _tOwned[sender] = _tOwned[sender].sub(tAmount);
1296     _rOwned[sender] = _rOwned[sender].sub(rAmount);
1297     _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1298     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1299     _takeTeam(tTeam);
1300     _reflectFee(rFee, tFee);
1301     emit Transfer(sender, recipient, tTransferAmount);
1302   }
1303 
1304   function _takeTeam(uint256 tTeam) private {
1305     uint256 currentRate = _getRate();
1306     uint256 rTeam = tTeam.mul(currentRate);
1307     _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
1308     if (_isExcluded[address(this)])
1309       _tOwned[address(this)] = _tOwned[address(this)].add(tTeam);
1310   }
1311 
1312   function _reflectFee(uint256 rFee, uint256 tFee) private {
1313     _rTotal = _rTotal.sub(rFee);
1314     _tFeeTotal = _tFeeTotal.add(tFee);
1315   }
1316 
1317   //to recieve ETH from uniswapV2Router when swaping
1318   receive() external payable {}
1319 
1320   function _getValues(uint256 tAmount, bool isSelling)
1321     private
1322     view
1323     returns (
1324       uint256,
1325       uint256,
1326       uint256,
1327       uint256,
1328       uint256,
1329       uint256
1330     )
1331   {
1332     (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(
1333       tAmount,
1334       _taxFee,
1335       _teamFee,
1336       isSelling
1337     );
1338     uint256 currentRate = _getRate();
1339     (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1340       tAmount,
1341       tFee,
1342       tTeam,
1343       currentRate
1344     );
1345     return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
1346   }
1347 
1348   function _getTValues(
1349     uint256 tAmount,
1350     uint256 taxFee,
1351     uint256 teamFee,
1352     bool isSelling
1353   )
1354     private
1355     view
1356     returns (
1357       uint256,
1358       uint256,
1359       uint256
1360     )
1361   {
1362     uint256 finalTax = isSelling ? taxFee.mul(_sellTaxMultiplier) : taxFee;
1363     uint256 finalTeam = isSelling ? teamFee.mul(_sellTaxMultiplier) : teamFee;
1364 
1365     uint256 tFee = tAmount.mul(finalTax).div(100);
1366     uint256 tTeam = tAmount.mul(finalTeam).div(100);
1367     uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
1368     return (tTransferAmount, tFee, tTeam);
1369   }
1370 
1371   function _getRValues(
1372     uint256 tAmount,
1373     uint256 tFee,
1374     uint256 tTeam,
1375     uint256 currentRate
1376   )
1377     private
1378     pure
1379     returns (
1380       uint256,
1381       uint256,
1382       uint256
1383     )
1384   {
1385     uint256 rAmount = tAmount.mul(currentRate);
1386     uint256 rFee = tFee.mul(currentRate);
1387     uint256 rTeam = tTeam.mul(currentRate);
1388     uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
1389     return (rAmount, rTransferAmount, rFee);
1390   }
1391 
1392   function _getRate() private view returns (uint256) {
1393     (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1394     return rSupply.div(tSupply);
1395   }
1396 
1397   function _getCurrentSupply() private view returns (uint256, uint256) {
1398     uint256 rSupply = _rTotal;
1399     uint256 tSupply = _tTotal;
1400     for (uint256 i = 0; i < _excluded.length; i++) {
1401       if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply)
1402         return (_rTotal, _tTotal);
1403       rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1404       tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1405     }
1406     if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1407     return (rSupply, tSupply);
1408   }
1409 
1410   function _getTaxFee() private view returns (uint256) {
1411     return _taxFee;
1412   }
1413 
1414   function _getMaxTxAmount() private view returns (uint256) {
1415     return _maxTxAmount;
1416   }
1417 
1418   function _isSelling(address recipient) private view returns (bool) {
1419     return recipient == uniswapV2Pair || _isUniswapPair[recipient];
1420   }
1421 
1422   function _getETHBalance() public view returns (uint256 balance) {
1423     return address(this).balance;
1424   }
1425 
1426   function _setTaxFee(uint256 taxFee) external onlyOwner {
1427     require(taxFee <= 5, 'taxFee should be in 0 - 5');
1428     _taxFee = taxFee;
1429   }
1430 
1431   function _setTeamFee(uint256 teamFee) external onlyOwner {
1432     require(teamFee <= 5, 'teamFee should be in 0 - 5');
1433     _teamFee = teamFee;
1434   }
1435 
1436   function _setSellTaxMultiplier(uint8 mult) external onlyOwner {
1437     require(mult >= 1 && mult <= 3, 'multiplier should be in 1 - 3');
1438     _sellTaxMultiplier = mult;
1439   }
1440 
1441   function _setGYWallet(address payable GYWalletAddress) external onlyOwner {
1442     _GYWalletAddress = GYWalletAddress;
1443   }
1444 
1445   function _setMarketingWallet(address payable marketingWalletAddress)
1446     external
1447     onlyOwner
1448   {
1449     _marketingWalletAddress = marketingWalletAddress;
1450   }
1451 
1452   function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner {
1453     require(
1454       maxTxAmount >= 100000000000000e9,
1455       'maxTxAmount should be greater than 100000000000000e9'
1456     );
1457     _maxTxAmount = maxTxAmount;
1458   }
1459 
1460   function isUniswapPair(address _pair) external view returns (bool) {
1461     if (_pair == uniswapV2Pair) return true;
1462     return _isUniswapPair[_pair];
1463   }
1464 
1465   function addUniswapPair(address _pair) external onlyOwner {
1466     _isUniswapPair[_pair] = true;
1467   }
1468 
1469   function removeUniswapPair(address _pair) external onlyOwner {
1470     _isUniswapPair[_pair] = false;
1471   }
1472 
1473   function Airdrop(AirdropReceiver[] memory recipients) external onlyOwner {
1474     for (uint256 _i = 0; _i < recipients.length; _i++) {
1475       AirdropReceiver memory _user = recipients[_i];
1476       transferFrom(msg.sender, _user.addy, _user.amount);
1477     }
1478   }
1479 }