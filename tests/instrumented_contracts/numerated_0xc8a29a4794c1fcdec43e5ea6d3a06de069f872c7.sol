1 //              _,_
2 //    .--.  .-"     "-.  .--.
3 //   / .. \/  .-. .-.  \/ .. \
4 //  | |  '|  /   Y   \  |'  | |
5 //  | \   \  \ 0 | 0 /  /   / |
6 //   \ '- ,\.-"`` ``"-./, -' /
7 //    `'-' /_   ^ ^   _\ '-'`
8 //        |  \._   _./  |
9 //        \   \ `~` /   /
10 //         '._ '-=-' _.'
11 //             '---'
12 // WEBSITE: safuape.finance
13 // TELEGRAM: https://t.me/SafuApeETH
14 // SPDX-License-Identifier: Unlicensed
15 pragma solidity ^0.8.4;
16 
17 /**
18  * @dev Interface of the ERC20 standard as defined in the EIP.
19  */
20 interface IERC20 {
21     /**
22      * @dev Returns the amount of tokens in existence.
23      */
24     function totalSupply() external view returns (uint256);
25 
26     /**
27      * @dev Returns the amount of tokens owned by `account`.
28      */
29     function balanceOf(address account) external view returns (uint256);
30 
31     /**
32      * @dev Moves `amount` tokens from the caller's account to `recipient`.
33      *
34      * Returns a boolean value indicating whether the operation succeeded.
35      *
36      * Emits a {Transfer} event.
37      */
38     function transfer(address recipient, uint256 amount) external returns (bool);
39 
40     /**
41      * @dev Returns the remaining number of tokens that `spender` will be
42      * allowed to spend on behalf of `owner` through {transferFrom}. This is
43      * zero by default.
44      *
45      * This value changes when {approve} or {transferFrom} are called.
46      */
47     function allowance(address owner, address spender) external view returns (uint256);
48 
49     /**
50      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * IMPORTANT: Beware that changing an allowance with this method brings the risk
55      * that someone may use both the old and the new allowance by unfortunate
56      * transaction ordering. One possible solution to mitigate this race
57      * condition is to first reduce the spender's allowance to 0 and set the
58      * desired value afterwards:
59      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
60      *
61      * Emits an {Approval} event.
62      */
63     function approve(address spender, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Moves `amount` tokens from `sender` to `recipient` using the
67      * allowance mechanism. `amount` is then deducted from the caller's
68      * allowance.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * Emits a {Transfer} event.
73      */
74     function transferFrom(
75         address sender,
76         address recipient,
77         uint256 amount
78     ) external returns (bool);
79 
80     /**
81      * @dev Emitted when `value` tokens are moved from one account (`from`) to
82      * another (`to`).
83      *
84      * Note that `value` may be zero.
85      */
86     event Transfer(address indexed from, address indexed to, uint256 value);
87 
88     /**
89      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
90      * a call to {approve}. `value` is the new allowance.
91      */
92     event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 // CAUTION
96 // This version of SafeMath should only be used with Solidity 0.8 or later,
97 // because it relies on the compiler's built in overflow checks.
98 
99 /**
100  * @dev Wrappers over Solidity's arithmetic operations.
101  *
102  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
103  * now has built in overflow checking.
104  */
105 library SafeMath {
106     /**
107      * @dev Returns the addition of two unsigned integers, with an overflow flag.
108      *
109      * _Available since v3.4._
110      */
111     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
112         unchecked {
113             uint256 c = a + b;
114             if (c < a) return (false, 0);
115             return (true, c);
116         }
117     }
118 
119     /**
120      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
121      *
122      * _Available since v3.4._
123      */
124     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
125         unchecked {
126             if (b > a) return (false, 0);
127             return (true, a - b);
128         }
129     }
130 
131     /**
132      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
133      *
134      * _Available since v3.4._
135      */
136     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
137         unchecked {
138             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
139             // benefit is lost if 'b' is also tested.
140             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
141             if (a == 0) return (true, 0);
142             uint256 c = a * b;
143             if (c / a != b) return (false, 0);
144             return (true, c);
145         }
146     }
147 
148     /**
149      * @dev Returns the division of two unsigned integers, with a division by zero flag.
150      *
151      * _Available since v3.4._
152      */
153     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
154         unchecked {
155             if (b == 0) return (false, 0);
156             return (true, a / b);
157         }
158     }
159 
160     /**
161      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
162      *
163      * _Available since v3.4._
164      */
165     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
166         unchecked {
167             if (b == 0) return (false, 0);
168             return (true, a % b);
169         }
170     }
171 
172     /**
173      * @dev Returns the addition of two unsigned integers, reverting on
174      * overflow.
175      *
176      * Counterpart to Solidity's `+` operator.
177      *
178      * Requirements:
179      *
180      * - Addition cannot overflow.
181      */
182     function add(uint256 a, uint256 b) internal pure returns (uint256) {
183         return a + b;
184     }
185 
186     /**
187      * @dev Returns the subtraction of two unsigned integers, reverting on
188      * overflow (when the result is negative).
189      *
190      * Counterpart to Solidity's `-` operator.
191      *
192      * Requirements:
193      *
194      * - Subtraction cannot overflow.
195      */
196     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
197         return a - b;
198     }
199 
200     /**
201      * @dev Returns the multiplication of two unsigned integers, reverting on
202      * overflow.
203      *
204      * Counterpart to Solidity's `*` operator.
205      *
206      * Requirements:
207      *
208      * - Multiplication cannot overflow.
209      */
210     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
211         return a * b;
212     }
213 
214     /**
215      * @dev Returns the integer division of two unsigned integers, reverting on
216      * division by zero. The result is rounded towards zero.
217      *
218      * Counterpart to Solidity's `/` operator.
219      *
220      * Requirements:
221      *
222      * - The divisor cannot be zero.
223      */
224     function div(uint256 a, uint256 b) internal pure returns (uint256) {
225         return a / b;
226     }
227 
228     /**
229      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
230      * reverting when dividing by zero.
231      *
232      * Counterpart to Solidity's `%` operator. This function uses a `revert`
233      * opcode (which leaves remaining gas untouched) while Solidity uses an
234      * invalid opcode to revert (consuming all remaining gas).
235      *
236      * Requirements:
237      *
238      * - The divisor cannot be zero.
239      */
240     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
241         return a % b;
242     }
243 
244     /**
245      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
246      * overflow (when the result is negative).
247      *
248      * CAUTION: This function is deprecated because it requires allocating memory for the error
249      * message unnecessarily. For custom revert reasons use {trySub}.
250      *
251      * Counterpart to Solidity's `-` operator.
252      *
253      * Requirements:
254      *
255      * - Subtraction cannot overflow.
256      */
257     function sub(
258         uint256 a,
259         uint256 b,
260         string memory errorMessage
261     ) internal pure returns (uint256) {
262         unchecked {
263             require(b <= a, errorMessage);
264             return a - b;
265         }
266     }
267 
268     /**
269      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
270      * division by zero. The result is rounded towards zero.
271      *
272      * Counterpart to Solidity's `/` operator. Note: this function uses a
273      * `revert` opcode (which leaves remaining gas untouched) while Solidity
274      * uses an invalid opcode to revert (consuming all remaining gas).
275      *
276      * Requirements:
277      *
278      * - The divisor cannot be zero.
279      */
280     function div(
281         uint256 a,
282         uint256 b,
283         string memory errorMessage
284     ) internal pure returns (uint256) {
285         unchecked {
286             require(b > 0, errorMessage);
287             return a / b;
288         }
289     }
290 
291     /**
292      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
293      * reverting with custom message when dividing by zero.
294      *
295      * CAUTION: This function is deprecated because it requires allocating memory for the error
296      * message unnecessarily. For custom revert reasons use {tryMod}.
297      *
298      * Counterpart to Solidity's `%` operator. This function uses a `revert`
299      * opcode (which leaves remaining gas untouched) while Solidity uses an
300      * invalid opcode to revert (consuming all remaining gas).
301      *
302      * Requirements:
303      *
304      * - The divisor cannot be zero.
305      */
306     function mod(
307         uint256 a,
308         uint256 b,
309         string memory errorMessage
310     ) internal pure returns (uint256) {
311         unchecked {
312             require(b > 0, errorMessage);
313             return a % b;
314         }
315     }
316 }
317 
318 /**
319  * @dev Provides information about the current execution context, including the
320  * sender of the transaction and its data. While these are generally available
321  * via msg.sender and msg.data, they should not be accessed in such a direct
322  * manner, since when dealing with meta-transactions the account sending and
323  * paying for execution may not be the actual sender (as far as an application
324  * is concerned).
325  *
326  * This contract is only required for intermediate, library-like contracts.
327  */
328 abstract contract Context {
329     function _msgSender() internal view virtual returns (address) {
330         return msg.sender;
331     }
332 
333     function _msgData() internal view virtual returns (bytes calldata) {
334         return msg.data;
335     }
336 }
337 
338 /**
339  * @dev Contract module which provides a basic access control mechanism, where
340  * there is an account (an owner) that can be granted exclusive access to
341  * specific functions.
342  *
343  * By default, the owner account will be the one that deploys the contract. This
344  * can later be changed with {transferOwnership}.
345  *
346  * This module is used through inheritance. It will make available the modifier
347  * `onlyOwner`, which can be applied to your functions to restrict their use to
348  * the owner.
349  */
350 abstract contract Ownable is Context {
351     address private _owner;
352 
353     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
354 
355     /**
356      * @dev Initializes the contract setting the deployer as the initial owner.
357      */
358     constructor() {
359         _setOwner(_msgSender());
360     }
361 
362     /**
363      * @dev Returns the address of the current owner.
364      */
365     function owner() public view virtual returns (address) {
366         return _owner;
367     }
368 
369     /**
370      * @dev Throws if called by any account other than the owner.
371      */
372     modifier onlyOwner() {
373         require(owner() == _msgSender(), "Ownable: caller is not the owner");
374         _;
375     }
376 
377     /**
378      * @dev Leaves the contract without owner. It will not be possible to call
379      * `onlyOwner` functions anymore. Can only be called by the current owner.
380      *
381      * NOTE: Renouncing ownership will leave the contract without an owner,
382      * thereby removing any functionality that is only available to the owner.
383      */
384     function renounceOwnership() public virtual onlyOwner {
385         _setOwner(address(0));
386     }
387 
388     /**
389      * @dev Transfers ownership of the contract to a new account (`newOwner`).
390      * Can only be called by the current owner.
391      */
392     function transferOwnership(address newOwner) public virtual onlyOwner {
393         require(newOwner != address(0), "Ownable: new owner is the zero address");
394         _setOwner(newOwner);
395     }
396 
397     function _setOwner(address newOwner) private {
398         address oldOwner = _owner;
399         _owner = newOwner;
400         emit OwnershipTransferred(oldOwner, newOwner);
401     }
402 }
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
531         return verifyCallResult(success, returndata, errorMessage);
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
558         return verifyCallResult(success, returndata, errorMessage);
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
585         return verifyCallResult(success, returndata, errorMessage);
586     }
587 
588     /**
589      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
590      * revert reason using the provided one.
591      *
592      * _Available since v4.3._
593      */
594     function verifyCallResult(
595         bool success,
596         bytes memory returndata,
597         string memory errorMessage
598     ) internal pure returns (bytes memory) {
599         if (success) {
600             return returndata;
601         } else {
602             // Look for revert reason and bubble it up if present
603             if (returndata.length > 0) {
604                 // The easiest way to bubble the revert reason is using memory via assembly
605 
606                 assembly {
607                     let returndata_size := mload(returndata)
608                     revert(add(32, returndata), returndata_size)
609                 }
610             } else {
611                 revert(errorMessage);
612             }
613         }
614     }
615 }
616 
617 interface IUniswapV2Pair {
618     event Approval(address indexed owner, address indexed spender, uint value);
619     event Transfer(address indexed from, address indexed to, uint value);
620 
621     function name() external pure returns (string memory);
622     function symbol() external pure returns (string memory);
623     function decimals() external pure returns (uint8);
624     function totalSupply() external view returns (uint);
625     function balanceOf(address owner) external view returns (uint);
626     function allowance(address owner, address spender) external view returns (uint);
627 
628     function approve(address spender, uint value) external returns (bool);
629     function transfer(address to, uint value) external returns (bool);
630     function transferFrom(address from, address to, uint value) external returns (bool);
631 
632     function DOMAIN_SEPARATOR() external view returns (bytes32);
633     function PERMIT_TYPEHASH() external pure returns (bytes32);
634     function nonces(address owner) external view returns (uint);
635 
636     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
637 
638     event Mint(address indexed sender, uint amount0, uint amount1);
639     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
640     event Swap(
641         address indexed sender,
642         uint amount0In,
643         uint amount1In,
644         uint amount0Out,
645         uint amount1Out,
646         address indexed to
647     );
648     event Sync(uint112 reserve0, uint112 reserve1);
649 
650     function MINIMUM_LIQUIDITY() external pure returns (uint);
651     function factory() external view returns (address);
652     function token0() external view returns (address);
653     function token1() external view returns (address);
654     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
655     function price0CumulativeLast() external view returns (uint);
656     function price1CumulativeLast() external view returns (uint);
657     function kLast() external view returns (uint);
658 
659     function mint(address to) external returns (uint liquidity);
660     function burn(address to) external returns (uint amount0, uint amount1);
661     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
662     function skim(address to) external;
663     function sync() external;
664 
665     function initialize(address, address) external;
666 }
667 
668 interface IUniswapV2Factory {
669     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
670 
671     function feeTo() external view returns (address);
672     function feeToSetter() external view returns (address);
673 
674     function getPair(address tokenA, address tokenB) external view returns (address pair);
675     function allPairs(uint) external view returns (address pair);
676     function allPairsLength() external view returns (uint);
677 
678     function createPair(address tokenA, address tokenB) external returns (address pair);
679 
680     function setFeeTo(address) external;
681     function setFeeToSetter(address) external;
682 }
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
819 /**
820  * @dev Interface for the Buy Back Reward contract that can be used to build
821  * custom logic to elevate user rewards
822  */
823 interface IConditional {
824   /**
825    * @dev Returns whether a wallet passes the test.
826    */
827   function passesTest(address wallet) external view returns (bool);
828 }
829 
830 contract BSAPE is Context, IERC20, Ownable {
831   using SafeMath for uint256;
832   using Address for address;
833 
834   address payable public treasuryWallet =
835     payable(0xB6cE6712871B8FCcAF2a593C56680866442F29b3);
836   address public constant deadAddress =
837     0x000000000000000000000000000000000000dEaD;
838 
839   mapping(address => uint256) private _rOwned;
840   mapping(address => uint256) private _tOwned;
841   mapping(address => mapping(address => uint256)) private _allowances;
842   mapping(address => bool) private _isSniper;
843   address[] private _confirmedSnipers;
844 
845   uint256 public rewardsClaimTimeSeconds = 60 * 60 * 6; // 6 hours
846 
847   mapping(address => uint256) private _rewardsLastClaim;
848 
849   mapping(address => bool) private _isExcludedFee;
850   mapping(address => bool) private _isExcludedReward;
851   address[] private _excluded;
852 
853   string private constant _name = 'BABYSAFUAPE';
854   string private constant _symbol = 'BSAPE';
855   uint8 private constant _decimals = 9;
856 
857   uint256 private constant MAX = ~uint256(0);
858   uint256 private constant _tTotal = 1e12 * 10**_decimals;
859   uint256 private _rTotal = (MAX - (MAX % _tTotal));
860   uint256 private _tFeeTotal;
861 
862   uint256 public reflectionFee = 0;
863   uint256 private _previousReflectFee = reflectionFee;
864 
865   uint256 public treasuryFee = 6;
866   uint256 private _previousTreasuryFee = treasuryFee;
867 
868   uint256 public ethRewardsFee = 1;
869   uint256 private _previousETHRewardsFee = ethRewardsFee;
870   uint256 public ethRewardsBalance;
871 
872   uint256 public buybackFee = 1;
873   uint256 private _previousBuybackFee = buybackFee;
874   address public buybackTokenAddress = 0x23464fb65ff1a8e7a9a1318Dfa56185a4950cF8B;
875   address public buybackReceiver = address(this);
876 
877   uint256 public feeSellMultiplier = 2;
878   uint256 public feeRate = 10;
879   uint256 public launchTime;
880 
881   uint256 public boostRewardsPercent = 50;
882 
883   address public boostRewardsContract;
884   address public feeExclusionContract;
885 
886   IUniswapV2Router02 public uniswapV2Router;
887   address public uniswapV2Pair;
888   mapping(address => bool) private _isUniswapPair;
889 
890   // PancakeSwap: 0x10ED43C718714eb63d5aA57B78B54704E256024E
891   // Uniswap V2: 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
892   address private constant _uniswapRouterAddress =
893     0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
894 
895   bool private _inSwapAndLiquify;
896   bool private _isSelling;
897   bool private _tradingOpen = false;
898   bool private _isMaxBuyActivated = true;
899 
900   uint256 public _maxTxAmount = _tTotal.mul(5).div(1000); // 0.5%
901   uint256 public _maxWalletSize = _tTotal.mul(2).div(100); // 2.0%
902   uint256 public _maximumBuyAmount = _tTotal.mul(3).div(1000); // 0.3%
903 
904   event MaxTxAmountUpdated(uint256 _maxTxAmount);
905   event MaxWalletSizeUpdated(uint256 _maxWalletSize);
906   event SendETHRewards(address to, uint256 amountETH);
907   event SendTokenRewards(address to, address token, uint256 amount);
908   event SwapETHForTokens(address whereTo, uint256 amountIn, address[] path);
909   event SwapTokensForETH(uint256 amountIn, address[] path);
910   event SwapAndLiquify(
911     uint256 tokensSwappedForEth,
912     uint256 ethAddedForLp,
913     uint256 tokensAddedForLp
914   );
915 
916   modifier lockTheSwap() {
917     _inSwapAndLiquify = true;
918     _;
919     _inSwapAndLiquify = false;
920   }
921 
922   constructor() {
923     _rOwned[_msgSender()] = _rTotal;
924     emit Transfer(address(0), _msgSender(), _tTotal);
925   }
926 
927   function initContract() external onlyOwner {
928     IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
929       _uniswapRouterAddress
930     );
931     uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(
932       address(this),
933       _uniswapV2Router.WETH()
934     );
935 
936     uniswapV2Router = _uniswapV2Router;
937 
938     _isExcludedFee[owner()] = true;
939     _isExcludedFee[address(this)] = true;
940     _isExcludedFee[treasuryWallet] = true;
941   }
942 
943   function openTrading() external onlyOwner {
944     treasuryFee = _previousTreasuryFee;
945     ethRewardsFee = _previousETHRewardsFee;
946     reflectionFee = _previousReflectFee;
947     buybackFee = _previousBuybackFee;
948     _tradingOpen = true;
949     launchTime = block.timestamp;
950   }
951 
952   function name() external pure returns (string memory) {
953     return _name;
954   }
955 
956   function symbol() external pure returns (string memory) {
957     return _symbol;
958   }
959 
960   function decimals() external pure returns (uint8) {
961     return _decimals;
962   }
963 
964   function totalSupply() external pure override returns (uint256) {
965     return _tTotal;
966   }
967 
968   function MaxTXAmount() external view returns (uint256) {
969     return _maxTxAmount;
970   }
971 
972   function MaxWalletSize() external view returns (uint256) {
973     return _maxWalletSize;
974   }
975 
976   function balanceOf(address account) public view override returns (uint256) {
977     if (_isExcludedReward[account]) return _tOwned[account];
978     return tokenFromReflection(_rOwned[account]);
979   }
980 
981   function transfer(address recipient, uint256 amount)
982     external
983     override
984     returns (bool)
985   {
986     _transfer(_msgSender(), recipient, amount);
987     return true;
988   }
989 
990   function allowance(address owner, address spender)
991     external
992     view
993     override
994     returns (uint256)
995   {
996     return _allowances[owner][spender];
997   }
998 
999   function approve(address spender, uint256 amount)
1000     external
1001     override
1002     returns (bool)
1003   {
1004     _approve(_msgSender(), spender, amount);
1005     return true;
1006   }
1007 
1008   function transferFrom(
1009     address sender,
1010     address recipient,
1011     uint256 amount
1012   ) external override returns (bool) {
1013     _transfer(sender, recipient, amount);
1014     _approve(
1015       sender,
1016       _msgSender(),
1017       _allowances[sender][_msgSender()].sub(
1018         amount,
1019         'ERC20: transfer amount exceeds allowance'
1020       )
1021     );
1022     return true;
1023   }
1024 
1025   function increaseAllowance(address spender, uint256 addedValue)
1026     external
1027     virtual
1028     returns (bool)
1029   {
1030     _approve(
1031       _msgSender(),
1032       spender,
1033       _allowances[_msgSender()][spender].add(addedValue)
1034     );
1035     return true;
1036   }
1037 
1038   function decreaseAllowance(address spender, uint256 subtractedValue)
1039     external
1040     virtual
1041     returns (bool)
1042   {
1043     _approve(
1044       _msgSender(),
1045       spender,
1046       _allowances[_msgSender()][spender].sub(
1047         subtractedValue,
1048         'ERC20: decreased allowance below zero'
1049       )
1050     );
1051     return true;
1052   }
1053 
1054   function setMaxTxnAmount(uint256 maxTxAmountPercetange) external onlyOwner{
1055     require(maxTxAmountPercetange < 1000, "Maximum amount per transaction must be lower than 100%");
1056     require(maxTxAmountPercetange > 1, "Maximum amount per transaction must be higher than 0.1%");
1057     _maxTxAmount = _tTotal.mul(maxTxAmountPercetange).div(1000);
1058     emit MaxTxAmountUpdated(_maxTxAmount);
1059   }
1060 
1061   function setMaxWalletSize(uint256 maxWalletSizePercentage) external onlyOwner{
1062     require(maxWalletSizePercentage < 1000, "Maximum wallet size must be lower than 100%");
1063     require(maxWalletSizePercentage > 20, "Maximum wallet size must be higher than 2%");
1064     _maxWalletSize = _tTotal.mul(maxWalletSizePercentage).div(1000);
1065     emit MaxWalletSizeUpdated(_maxWalletSize);
1066   }
1067 
1068   function getLastETHRewardsClaim(address wallet)
1069     external
1070     view
1071     returns (uint256)
1072   {
1073     return _rewardsLastClaim[wallet];
1074   }
1075 
1076   function totalFees() external view returns (uint256) {
1077     return _tFeeTotal;
1078   }
1079 
1080   function deliver(uint256 tAmount) external {
1081     address sender = _msgSender();
1082     require(
1083       !_isExcludedReward[sender],
1084       'Excluded addresses cannot call this function'
1085     );
1086     (uint256 rAmount, , , , , ) = _getValues(sender, tAmount);
1087     _rOwned[sender] = _rOwned[sender].sub(rAmount);
1088     _rTotal = _rTotal.sub(rAmount);
1089     _tFeeTotal = _tFeeTotal.add(tAmount);
1090   }
1091 
1092   function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
1093     external
1094     view
1095     returns (uint256)
1096   {
1097     require(tAmount <= _tTotal, 'Amount must be less than supply');
1098     if (!deductTransferFee) {
1099       (uint256 rAmount, , , , , ) = _getValues(address(0), tAmount);
1100       return rAmount;
1101     } else {
1102       (, uint256 rTransferAmount, , , , ) = _getValues(address(0), tAmount);
1103       return rTransferAmount;
1104     }
1105   }
1106 
1107   function tokenFromReflection(uint256 rAmount) public view returns (uint256) {
1108     require(rAmount <= _rTotal, 'Amount must be less than total reflections');
1109     uint256 currentRate = _getRate();
1110     return rAmount.div(currentRate);
1111   }
1112 
1113   function excludeFromReward(address account) external onlyOwner {
1114     require(!_isExcludedReward[account], 'Account is already excluded');
1115     if (_rOwned[account] > 0) {
1116       _tOwned[account] = tokenFromReflection(_rOwned[account]);
1117     }
1118     _isExcludedReward[account] = true;
1119     _excluded.push(account);
1120   }
1121 
1122   function includeInReward(address account) external onlyOwner {
1123     require(_isExcludedReward[account], 'Account is already included');
1124     for (uint256 i = 0; i < _excluded.length; i++) {
1125       if (_excluded[i] == account) {
1126         _excluded[i] = _excluded[_excluded.length - 1];
1127         _tOwned[account] = 0;
1128         _isExcludedReward[account] = false;
1129         _excluded.pop();
1130         break;
1131       }
1132     }
1133   }
1134 
1135   function _approve(
1136     address owner,
1137     address spender,
1138     uint256 amount
1139   ) private {
1140     require(owner != address(0), 'ERC20: approve from the zero address');
1141     require(spender != address(0), 'ERC20: approve to the zero address');
1142 
1143     _allowances[owner][spender] = amount;
1144     emit Approval(owner, spender, amount);
1145   }
1146 
1147   function _transfer(
1148     address from,
1149     address to,
1150     uint256 amount
1151   ) private {
1152     require(from != address(0), 'ERC20: transfer from the zero address');
1153     require(to != address(0), 'ERC20: transfer to the zero address');
1154     require(amount > 0, 'Transfer amount must be greater than zero');
1155     require(!_isSniper[to], 'Stop sniping!');
1156     require(!_isSniper[from], 'Stop sniping!');
1157     require(!_isSniper[_msgSender()], 'Stop sniping!');
1158 
1159     //check transaction amount only when selling
1160     if (
1161       (to == uniswapV2Pair || _isUniswapPair[to]) && 
1162       from != address(uniswapV2Router) &&
1163       !isExcludedFromFee(to) &&
1164       !isExcludedFromFee(from)
1165     ) {
1166         require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
1167     }
1168 
1169     if (
1170       to != uniswapV2Pair &&
1171       !_isUniswapPair[to] &&
1172       !isExcludedFromFee(to) && 
1173       !isExcludedFromFee(from)
1174       ) {
1175       require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
1176       if (_isMaxBuyActivated) {
1177         if (block.timestamp <= launchTime + 30 minutes) {
1178           require(amount <= _maximumBuyAmount, "Amount too much");
1179         }
1180       }
1181     }
1182 
1183     // reset receiver's timer to prevent users buying and
1184     // immmediately transferring to buypass timer
1185     _rewardsLastClaim[to] = block.timestamp;
1186 
1187     bool excludedFromFee = false;
1188 
1189     // buy
1190     if (
1191       (from == uniswapV2Pair || _isUniswapPair[from]) &&
1192       to != address(uniswapV2Router)
1193     ) {
1194       // normal buy, check for snipers
1195       if (!isExcludedFromFee(to)) {
1196         require(_tradingOpen, 'Trading not yet enabled.');
1197 
1198         // antibot
1199         if (block.timestamp == launchTime) {
1200           _isSniper[to] = true;
1201           _confirmedSnipers.push(to);
1202         }
1203         _rewardsLastClaim[from] = block.timestamp;
1204       } else {
1205         // set excluded flag for takeFee below since buyer is excluded
1206         excludedFromFee = true;
1207       }
1208     }
1209 
1210     // sell
1211     if (
1212       !_inSwapAndLiquify &&
1213       _tradingOpen &&
1214       (to == uniswapV2Pair || _isUniswapPair[to])
1215     ) {
1216       uint256 _contractTokenBalance = balanceOf(address(this));
1217       if (_contractTokenBalance > 0) {
1218         if (
1219           _contractTokenBalance > balanceOf(uniswapV2Pair).mul(feeRate).div(100)
1220         ) {
1221           _contractTokenBalance = balanceOf(uniswapV2Pair).mul(feeRate).div(
1222             100
1223           );
1224         }
1225         _swapTokens(_contractTokenBalance);
1226       }
1227       _rewardsLastClaim[from] = block.timestamp;
1228       _isSelling = true;
1229       excludedFromFee = isExcludedFromFee(from);
1230     }
1231 
1232     bool takeFee = false;
1233 
1234     // take fee only on swaps
1235     if (
1236       (from == uniswapV2Pair ||
1237         to == uniswapV2Pair ||
1238         _isUniswapPair[to] ||
1239         _isUniswapPair[from]) && !excludedFromFee
1240     ) {
1241       takeFee = true;
1242     }
1243 
1244     _tokenTransfer(from, to, amount, takeFee);
1245     _isSelling = false;
1246   }
1247 
1248   function _swapTokens(uint256 _contractTokenBalance) private lockTheSwap {
1249     uint256 ethBalanceBefore = address(this).balance;
1250     _swapTokensForEth(_contractTokenBalance);
1251     uint256 ethBalanceAfter = address(this).balance;
1252     uint256 ethBalanceUpdate = ethBalanceAfter.sub(ethBalanceBefore);
1253     uint256 _liquidityFeeTotal = _liquidityFeeAggregate(address(0));
1254 
1255     ethRewardsBalance += ethBalanceUpdate.mul(ethRewardsFee).div(
1256       _liquidityFeeTotal
1257     );
1258 
1259     // send ETH to treasury address
1260     uint256 treasuryETHBalance = ethBalanceUpdate.mul(treasuryFee).div(
1261       _liquidityFeeTotal
1262     );
1263     if (treasuryETHBalance > 0) {
1264       _sendETHToTreasury(treasuryETHBalance);
1265     }
1266 
1267     // buy back
1268     uint256 buybackETHBalance = ethBalanceUpdate.mul(buybackFee).div(
1269       _liquidityFeeTotal
1270     );
1271     if (buybackETHBalance > 0) {
1272       _buyBackTokens(buybackETHBalance);
1273     }
1274   }
1275 
1276   function _sendETHToTreasury(uint256 amount) private {
1277     treasuryWallet.call{ value: amount }('');
1278   }
1279 
1280   function _buyBackTokens(uint256 amount) private {
1281     // generate the uniswap pair path of token -> weth
1282     address[] memory path = new address[](2);
1283     path[0] = uniswapV2Router.WETH();
1284     path[1] = buybackTokenAddress;
1285 
1286     // make the swap
1287     uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{
1288       value: amount
1289     }(
1290       0, // accept any amount of tokens
1291       path,
1292       buybackReceiver,
1293       block.timestamp
1294     );
1295 
1296     emit SwapETHForTokens(buybackReceiver, amount, path);
1297   }
1298 
1299   function _swapTokensForEth(uint256 tokenAmount) private {
1300     // generate the uniswap pair path of token -> weth
1301     address[] memory path = new address[](2);
1302     path[0] = address(this);
1303     path[1] = uniswapV2Router.WETH();
1304 
1305     _approve(address(this), address(uniswapV2Router), tokenAmount);
1306 
1307     // make the swap
1308     uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1309       tokenAmount,
1310       0, // accept any amount of ETH
1311       path,
1312       address(this), // the contract
1313       block.timestamp
1314     );
1315 
1316     emit SwapTokensForETH(tokenAmount, path);
1317   }
1318 
1319   function _tokenTransfer(
1320     address sender,
1321     address recipient,
1322     uint256 amount,
1323     bool takeFee
1324   ) private {
1325     if (!takeFee) _removeAllFee();
1326 
1327     if (_isExcludedReward[sender] && !_isExcludedReward[recipient]) {
1328       _transferFromExcluded(sender, recipient, amount);
1329     } else if (!_isExcludedReward[sender] && _isExcludedReward[recipient]) {
1330       _transferToExcluded(sender, recipient, amount);
1331     } else if (_isExcludedReward[sender] && _isExcludedReward[recipient]) {
1332       _transferBothExcluded(sender, recipient, amount);
1333     } else {
1334       _transferStandard(sender, recipient, amount);
1335     }
1336 
1337     if (!takeFee) _restoreAllFee();
1338   }
1339 
1340   function _transferStandard(
1341     address sender,
1342     address recipient,
1343     uint256 tAmount
1344   ) private {
1345     (
1346       uint256 rAmount,
1347       uint256 rTransferAmount,
1348       uint256 rFee,
1349       uint256 tTransferAmount,
1350       uint256 tFee,
1351       uint256 tLiquidity
1352     ) = _getValues(sender, tAmount);
1353     _rOwned[sender] = _rOwned[sender].sub(rAmount);
1354     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1355     _takeLiquidity(tLiquidity);
1356     _reflectFee(rFee, tFee);
1357     emit Transfer(sender, recipient, tTransferAmount);
1358   }
1359 
1360   function _transferToExcluded(
1361     address sender,
1362     address recipient,
1363     uint256 tAmount
1364   ) private {
1365     (
1366       uint256 rAmount,
1367       uint256 rTransferAmount,
1368       uint256 rFee,
1369       uint256 tTransferAmount,
1370       uint256 tFee,
1371       uint256 tLiquidity
1372     ) = _getValues(sender, tAmount);
1373     _rOwned[sender] = _rOwned[sender].sub(rAmount);
1374     _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1375     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1376     _takeLiquidity(tLiquidity);
1377     _reflectFee(rFee, tFee);
1378     emit Transfer(sender, recipient, tTransferAmount);
1379   }
1380 
1381   function _transferFromExcluded(
1382     address sender,
1383     address recipient,
1384     uint256 tAmount
1385   ) private {
1386     (
1387       uint256 rAmount,
1388       uint256 rTransferAmount,
1389       uint256 rFee,
1390       uint256 tTransferAmount,
1391       uint256 tFee,
1392       uint256 tLiquidity
1393     ) = _getValues(sender, tAmount);
1394     _tOwned[sender] = _tOwned[sender].sub(tAmount);
1395     _rOwned[sender] = _rOwned[sender].sub(rAmount);
1396     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1397     _takeLiquidity(tLiquidity);
1398     _reflectFee(rFee, tFee);
1399     emit Transfer(sender, recipient, tTransferAmount);
1400   }
1401 
1402   function _transferBothExcluded(
1403     address sender,
1404     address recipient,
1405     uint256 tAmount
1406   ) private {
1407     (
1408       uint256 rAmount,
1409       uint256 rTransferAmount,
1410       uint256 rFee,
1411       uint256 tTransferAmount,
1412       uint256 tFee,
1413       uint256 tLiquidity
1414     ) = _getValues(sender, tAmount);
1415     _tOwned[sender] = _tOwned[sender].sub(tAmount);
1416     _rOwned[sender] = _rOwned[sender].sub(rAmount);
1417     _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1418     _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1419     _takeLiquidity(tLiquidity);
1420     _reflectFee(rFee, tFee);
1421     emit Transfer(sender, recipient, tTransferAmount);
1422   }
1423 
1424   function _reflectFee(uint256 rFee, uint256 tFee) private {
1425     _rTotal = _rTotal.sub(rFee);
1426     _tFeeTotal = _tFeeTotal.add(tFee);
1427   }
1428 
1429   function _getValues(address seller, uint256 tAmount)
1430     private
1431     view
1432     returns (
1433       uint256,
1434       uint256,
1435       uint256,
1436       uint256,
1437       uint256,
1438       uint256
1439     )
1440   {
1441     (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(
1442       seller,
1443       tAmount
1444     );
1445     (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
1446       tAmount,
1447       tFee,
1448       tLiquidity,
1449       _getRate()
1450     );
1451     return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
1452   }
1453 
1454   function _getTValues(address seller, uint256 tAmount)
1455     private
1456     view
1457     returns (
1458       uint256,
1459       uint256,
1460       uint256
1461     )
1462   {
1463     uint256 tFee = _calculateReflectFee(tAmount);
1464     uint256 tLiquidity = _calculateLiquidityFee(seller, tAmount);
1465     uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1466     return (tTransferAmount, tFee, tLiquidity);
1467   }
1468 
1469   function _getRValues(
1470     uint256 tAmount,
1471     uint256 tFee,
1472     uint256 tLiquidity,
1473     uint256 currentRate
1474   )
1475     private
1476     pure
1477     returns (
1478       uint256,
1479       uint256,
1480       uint256
1481     )
1482   {
1483     uint256 rAmount = tAmount.mul(currentRate);
1484     uint256 rFee = tFee.mul(currentRate);
1485     uint256 rLiquidity = tLiquidity.mul(currentRate);
1486     uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1487     return (rAmount, rTransferAmount, rFee);
1488   }
1489 
1490   function _getRate() private view returns (uint256) {
1491     (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1492     return rSupply.div(tSupply);
1493   }
1494 
1495   function _getCurrentSupply() private view returns (uint256, uint256) {
1496     uint256 rSupply = _rTotal;
1497     uint256 tSupply = _tTotal;
1498     for (uint256 i = 0; i < _excluded.length; i++) {
1499       if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply)
1500         return (_rTotal, _tTotal);
1501       rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1502       tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1503     }
1504     if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1505     return (rSupply, tSupply);
1506   }
1507 
1508   function _takeLiquidity(uint256 tLiquidity) private {
1509     uint256 currentRate = _getRate();
1510     uint256 rLiquidity = tLiquidity.mul(currentRate);
1511     _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1512     if (_isExcludedReward[address(this)])
1513       _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1514   }
1515 
1516   function _calculateReflectFee(uint256 _amount)
1517     private
1518     view
1519     returns (uint256)
1520   {
1521     return _amount.mul(reflectionFee).div(10**2);
1522   }
1523 
1524   function _liquidityFeeAggregate(address seller)
1525     private
1526     view
1527     returns (uint256)
1528   {
1529     uint256 feeMultiplier = _isSelling && !canClaimRewards(seller)
1530       ? feeSellMultiplier
1531       : 1;
1532     return (treasuryFee.add(ethRewardsFee).add(buybackFee)).mul(feeMultiplier);
1533   }
1534 
1535   function _calculateLiquidityFee(address seller, uint256 _amount)
1536     private
1537     view
1538     returns (uint256)
1539   {
1540     return _amount.mul(_liquidityFeeAggregate(seller)).div(10**2);
1541   }
1542 
1543   function _removeAllFee() private {
1544     if (
1545       reflectionFee == 0 &&
1546       treasuryFee == 0 &&
1547       ethRewardsFee == 0 &&
1548       buybackFee == 0
1549     ) return;
1550 
1551     _previousReflectFee = reflectionFee;
1552     _previousTreasuryFee = treasuryFee;
1553     _previousETHRewardsFee = ethRewardsFee;
1554     _previousBuybackFee = buybackFee;
1555 
1556     reflectionFee = 0;
1557     treasuryFee = 0;
1558     ethRewardsFee = 0;
1559     buybackFee = 0;
1560   }
1561 
1562   function _restoreAllFee() private {
1563     reflectionFee = _previousReflectFee;
1564     treasuryFee = _previousTreasuryFee;
1565     ethRewardsFee = _previousETHRewardsFee;
1566     buybackFee = _previousBuybackFee;
1567   }
1568 
1569   function getSellSlippage(address seller) external view returns (uint256) {
1570     uint256 feeAgg = treasuryFee.add(ethRewardsFee).add(buybackFee);
1571     return
1572       isExcludedFromFee(seller) ? 0 : !canClaimRewards(seller)
1573         ? feeAgg.mul(feeSellMultiplier)
1574         : feeAgg;
1575   }
1576 
1577   function isUniswapPair(address _pair) external view returns (bool) {
1578     if (_pair == uniswapV2Pair) return true;
1579     return _isUniswapPair[_pair];
1580   }
1581 
1582   function eligibleForRewardBooster(address wallet) public view returns (bool) {
1583     return
1584       boostRewardsContract != address(0) &&
1585       IConditional(boostRewardsContract).passesTest(wallet);
1586   }
1587 
1588   function isExcludedFromFee(address account) public view returns (bool) {
1589     return
1590       _isExcludedFee[account] ||
1591       (feeExclusionContract != address(0) &&
1592         IConditional(feeExclusionContract).passesTest(account));
1593   }
1594 
1595   function isExcludedFromReward(address account) external view returns (bool) {
1596     return _isExcludedReward[account];
1597   }
1598 
1599   function excludeFromFee(address account) external onlyOwner {
1600     _isExcludedFee[account] = true;
1601   }
1602 
1603   function includeInFee(address account) external onlyOwner {
1604     _isExcludedFee[account] = false;
1605   }
1606 
1607   function setRewardsClaimTimeSeconds(uint256 _seconds) external onlyOwner {
1608     require(_seconds >= 0 &&_seconds <= 60 * 60 * 24 * 7, 'claim time delay must be greater or equal to 0 seconds and less than or equal to 7 days');
1609     rewardsClaimTimeSeconds = _seconds;
1610   }
1611   
1612   // tax can be raised to maximum 10% - buy and 20% - sell
1613   function setNewFeesPercentages(uint256 _reflectionNewFee, uint256 _treasuryNewFee, uint256 _ethRewardsNewFee, uint256 _buybackRewardsNewFee) external onlyOwner {
1614     require(_reflectionNewFee + _treasuryNewFee + _ethRewardsNewFee + _buybackRewardsNewFee <= 10, 'Tax cannot be higher than 10%');
1615     reflectionFee = _reflectionNewFee;
1616     treasuryFee = _treasuryNewFee;
1617     ethRewardsFee = _ethRewardsNewFee;
1618     buybackFee = _buybackRewardsNewFee;
1619   }
1620 
1621   function setFeeSellMultiplier(uint256 multiplier) external onlyOwner {
1622     require(multiplier <= 2, 'must be less than or equal to 2');
1623     feeSellMultiplier = multiplier;
1624   }
1625 
1626   function setTreasuryAddress(address _treasuryWallet) external onlyOwner {
1627     treasuryWallet = payable(_treasuryWallet);
1628     _isExcludedFee[treasuryWallet] = true;
1629   }
1630 
1631   function setIsMaxBuyActivated(bool _value) public onlyOwner {
1632     _isMaxBuyActivated = _value;
1633   }
1634 
1635   function setBuybackTokenAddress(address _tokenAddress) external onlyOwner {
1636     buybackTokenAddress = _tokenAddress;
1637   }
1638 
1639   function setBuybackReceiver(address _receiver) external onlyOwner {
1640     buybackReceiver = _receiver;
1641   }
1642 
1643   function addUniswapPair(address _pair) external onlyOwner {
1644     _isUniswapPair[_pair] = true;
1645   }
1646 
1647   function removeUniswapPair(address _pair) external onlyOwner {
1648     _isUniswapPair[_pair] = false;
1649   }
1650 
1651   function setBoostRewardsPercent(uint256 perc) external onlyOwner {
1652     boostRewardsPercent = perc;
1653   }
1654 
1655   function setBoostRewardsContract(address _contract) external onlyOwner {
1656     if (_contract != address(0)) {
1657       IConditional _contCheck = IConditional(_contract);
1658       // allow setting to zero address to effectively turn off check logic
1659       require(
1660         _contCheck.passesTest(address(0)) == true ||
1661           _contCheck.passesTest(address(0)) == false,
1662         'contract does not implement interface'
1663       );
1664     }
1665     boostRewardsContract = _contract;
1666   }
1667 
1668   function setFeeExclusionContract(address _contract) external onlyOwner {
1669     if (_contract != address(0)) {
1670       IConditional _contCheck = IConditional(_contract);
1671       // allow setting to zero address to effectively turn off check logic
1672       require(
1673         _contCheck.passesTest(address(0)) == true ||
1674           _contCheck.passesTest(address(0)) == false,
1675         'contract does not implement interface'
1676       );
1677     }
1678     feeExclusionContract = _contract;
1679   }
1680 
1681   function isRemovedSniper(address account) external view returns (bool) {
1682     return _isSniper[account];
1683   }
1684 
1685   function removeSniper(address account) external onlyOwner {
1686     require(account != _uniswapRouterAddress, 'We can not blacklist Uniswap');
1687     require(!_isSniper[account], 'Account is already blacklisted');
1688     _isSniper[account] = true;
1689     _confirmedSnipers.push(account);
1690   }
1691 
1692   function amnestySniper(address account) external onlyOwner {
1693     require(_isSniper[account], 'Account is not blacklisted');
1694     for (uint256 i = 0; i < _confirmedSnipers.length; i++) {
1695       if (_confirmedSnipers[i] == account) {
1696         _confirmedSnipers[i] = _confirmedSnipers[_confirmedSnipers.length - 1];
1697         _isSniper[account] = false;
1698         _confirmedSnipers.pop();
1699         break;
1700       }
1701     }
1702   }
1703 
1704   function calculateETHRewards(address wallet) public view returns (uint256) {
1705     uint256 baseRewards = ethRewardsBalance.mul(balanceOf(wallet)).div(
1706       _tTotal.sub(balanceOf(deadAddress)) // circulating supply
1707     );
1708     uint256 rewardsWithBooster = eligibleForRewardBooster(wallet)
1709       ? baseRewards.add(baseRewards.mul(boostRewardsPercent).div(10**2))
1710       : baseRewards;
1711     return
1712       rewardsWithBooster > ethRewardsBalance ? baseRewards : rewardsWithBooster;
1713   }
1714 
1715   function calculateTokenRewards(address wallet, address tokenAddress)
1716     public
1717     view
1718     returns (uint256)
1719   {
1720     IERC20 token = IERC20(tokenAddress);
1721     uint256 contractTokenBalance = token.balanceOf(address(this));
1722     uint256 baseRewards = contractTokenBalance.mul(balanceOf(wallet)).div(
1723       _tTotal.sub(balanceOf(deadAddress)) // circulating supply
1724     );
1725     uint256 rewardsWithBooster = eligibleForRewardBooster(wallet)
1726       ? baseRewards.add(baseRewards.mul(boostRewardsPercent).div(10**2))
1727       : baseRewards;
1728     return
1729       rewardsWithBooster > contractTokenBalance
1730         ? baseRewards
1731         : rewardsWithBooster;
1732   }
1733 
1734   function claimETHRewards() external {
1735     require(
1736       balanceOf(_msgSender()) > 0,
1737       'You must have a balance to claim ETH rewards'
1738     );
1739     require(
1740       canClaimRewards(_msgSender()),
1741       'Must wait claim period before claiming rewards'
1742     );
1743     _rewardsLastClaim[_msgSender()] = block.timestamp;
1744 
1745     uint256 rewardsSent = calculateETHRewards(_msgSender());
1746     ethRewardsBalance -= rewardsSent;
1747     _msgSender().call{ value: rewardsSent }('');
1748     emit SendETHRewards(_msgSender(), rewardsSent);
1749   }
1750 
1751   function canClaimRewards(address user) public view returns (bool) {
1752     if (_rewardsLastClaim[user] == 0) {
1753       return
1754         block.timestamp > launchTime.add(rewardsClaimTimeSeconds);
1755     }
1756     else {
1757       return
1758         block.timestamp > _rewardsLastClaim[user].add(rewardsClaimTimeSeconds);
1759     }
1760   }
1761 
1762   function claimTokenRewards(address token) external {
1763     require(
1764       balanceOf(_msgSender()) > 0,
1765       'You must have a balance to claim rewards'
1766     );
1767     require(
1768       IERC20(token).balanceOf(address(this)) > 0,
1769       'We must have a token balance to claim rewards'
1770     );
1771     require(
1772       canClaimRewards(_msgSender()),
1773       'Must wait claim period before claiming rewards'
1774     );
1775     _rewardsLastClaim[_msgSender()] = block.timestamp;
1776 
1777     uint256 rewardsSent = calculateTokenRewards(_msgSender(), token);
1778     IERC20(token).transfer(_msgSender(), rewardsSent);
1779     emit SendTokenRewards(_msgSender(), token, rewardsSent);
1780   }
1781 
1782   function setFeeRate(uint256 _rate) external onlyOwner {
1783     feeRate = _rate;
1784   }
1785 
1786   function manualswap(uint256 amount) external onlyOwner {
1787     require(amount <= balanceOf(address(this)) && amount > 0, "Wrong amount");
1788     _swapTokens(amount);
1789   }
1790 
1791   function emergencyWithdraw() external onlyOwner {
1792     payable(owner()).send(address(this).balance);
1793   }
1794 
1795   // to recieve ETH from uniswapV2Router when swaping
1796   receive() external payable {}
1797 }