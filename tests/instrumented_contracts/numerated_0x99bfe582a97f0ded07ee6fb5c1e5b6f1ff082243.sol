1 // Vari-Stable Capital: $VSC
2 // Deflationary DeFi-as-a-Service (DaaS) Token, with 60% supply burned to 0x0dEaD
3 // You buy on Ethereum, we execute algorithmic stablecoin strategies on various chains and return the profits to $VSC holders.
4 
5 //Initial Supply: 1,000,000,000,000 $VSC 
6 //60% of $VSC burned to 0x0dEaD
7 //10% of each buy goes to existing holders.
8 //10% of each sell goes into various-chain algorithmic stablecoin investing to add to the treasury and buy back $VSC tokens.
9 
10 // Twitter: https://twitter.com/VariStableCap
11 // Website: https://varistablecapital.link/
12 // Medium: https://varistablecapital.medium.com/
13 // Telegram: https://t.me/varistablecapital
14 
15 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
16 
17 
18 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
19 
20 pragma solidity ^0.8.0;
21 
22 // CAUTION
23 // This version of SafeMath should only be used with Solidity 0.8 or later,
24 // because it relies on the compiler's built in overflow checks.
25 
26 /**
27  * @dev Wrappers over Solidity's arithmetic operations.
28  *
29  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
30  * now has built in overflow checking.
31  */
32 library SafeMath {
33     /**
34      * @dev Returns the addition of two unsigned integers, with an overflow flag.
35      *
36      * _Available since v3.4._
37      */
38     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
39         unchecked {
40             uint256 c = a + b;
41             if (c < a) return (false, 0);
42             return (true, c);
43         }
44     }
45 
46     /**
47      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
48      *
49      * _Available since v3.4._
50      */
51     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
52         unchecked {
53             if (b > a) return (false, 0);
54             return (true, a - b);
55         }
56     }
57 
58     /**
59      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
60      *
61      * _Available since v3.4._
62      */
63     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
64         unchecked {
65             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
66             // benefit is lost if 'b' is also tested.
67             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
68             if (a == 0) return (true, 0);
69             uint256 c = a * b;
70             if (c / a != b) return (false, 0);
71             return (true, c);
72         }
73     }
74 
75     /**
76      * @dev Returns the division of two unsigned integers, with a division by zero flag.
77      *
78      * _Available since v3.4._
79      */
80     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
81         unchecked {
82             if (b == 0) return (false, 0);
83             return (true, a / b);
84         }
85     }
86 
87     /**
88      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
89      *
90      * _Available since v3.4._
91      */
92     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
93         unchecked {
94             if (b == 0) return (false, 0);
95             return (true, a % b);
96         }
97     }
98 
99     /**
100      * @dev Returns the addition of two unsigned integers, reverting on
101      * overflow.
102      *
103      * Counterpart to Solidity's `+` operator.
104      *
105      * Requirements:
106      *
107      * - Addition cannot overflow.
108      */
109     function add(uint256 a, uint256 b) internal pure returns (uint256) {
110         return a + b;
111     }
112 
113     /**
114      * @dev Returns the subtraction of two unsigned integers, reverting on
115      * overflow (when the result is negative).
116      *
117      * Counterpart to Solidity's `-` operator.
118      *
119      * Requirements:
120      *
121      * - Subtraction cannot overflow.
122      */
123     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124         return a - b;
125     }
126 
127     /**
128      * @dev Returns the multiplication of two unsigned integers, reverting on
129      * overflow.
130      *
131      * Counterpart to Solidity's `*` operator.
132      *
133      * Requirements:
134      *
135      * - Multiplication cannot overflow.
136      */
137     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
138         return a * b;
139     }
140 
141     /**
142      * @dev Returns the integer division of two unsigned integers, reverting on
143      * division by zero. The result is rounded towards zero.
144      *
145      * Counterpart to Solidity's `/` operator.
146      *
147      * Requirements:
148      *
149      * - The divisor cannot be zero.
150      */
151     function div(uint256 a, uint256 b) internal pure returns (uint256) {
152         return a / b;
153     }
154 
155     /**
156      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
157      * reverting when dividing by zero.
158      *
159      * Counterpart to Solidity's `%` operator. This function uses a `revert`
160      * opcode (which leaves remaining gas untouched) while Solidity uses an
161      * invalid opcode to revert (consuming all remaining gas).
162      *
163      * Requirements:
164      *
165      * - The divisor cannot be zero.
166      */
167     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
168         return a % b;
169     }
170 
171     /**
172      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
173      * overflow (when the result is negative).
174      *
175      * CAUTION: This function is deprecated because it requires allocating memory for the error
176      * message unnecessarily. For custom revert reasons use {trySub}.
177      *
178      * Counterpart to Solidity's `-` operator.
179      *
180      * Requirements:
181      *
182      * - Subtraction cannot overflow.
183      */
184     function sub(
185         uint256 a,
186         uint256 b,
187         string memory errorMessage
188     ) internal pure returns (uint256) {
189         unchecked {
190             require(b <= a, errorMessage);
191             return a - b;
192         }
193     }
194 
195     /**
196      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
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
207     function div(
208         uint256 a,
209         uint256 b,
210         string memory errorMessage
211     ) internal pure returns (uint256) {
212         unchecked {
213             require(b > 0, errorMessage);
214             return a / b;
215         }
216     }
217 
218     /**
219      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
220      * reverting with custom message when dividing by zero.
221      *
222      * CAUTION: This function is deprecated because it requires allocating memory for the error
223      * message unnecessarily. For custom revert reasons use {tryMod}.
224      *
225      * Counterpart to Solidity's `%` operator. This function uses a `revert`
226      * opcode (which leaves remaining gas untouched) while Solidity uses an
227      * invalid opcode to revert (consuming all remaining gas).
228      *
229      * Requirements:
230      *
231      * - The divisor cannot be zero.
232      */
233     function mod(
234         uint256 a,
235         uint256 b,
236         string memory errorMessage
237     ) internal pure returns (uint256) {
238         unchecked {
239             require(b > 0, errorMessage);
240             return a % b;
241         }
242     }
243 }
244 
245 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
246 
247 
248 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
249 
250 pragma solidity ^0.8.0;
251 
252 /**
253  * @dev Interface of the ERC20 standard as defined in the EIP.
254  */
255 interface IERC20 {
256     /**
257      * @dev Returns the amount of tokens in existence.
258      */
259     function totalSupply() external view returns (uint256);
260 
261     /**
262      * @dev Returns the amount of tokens owned by `account`.
263      */
264     function balanceOf(address account) external view returns (uint256);
265 
266     /**
267      * @dev Moves `amount` tokens from the caller's account to `recipient`.
268      *
269      * Returns a boolean value indicating whether the operation succeeded.
270      *
271      * Emits a {Transfer} event.
272      */
273     function transfer(address recipient, uint256 amount) external returns (bool);
274 
275     /**
276      * @dev Returns the remaining number of tokens that `spender` will be
277      * allowed to spend on behalf of `owner` through {transferFrom}. This is
278      * zero by default.
279      *
280      * This value changes when {approve} or {transferFrom} are called.
281      */
282     function allowance(address owner, address spender) external view returns (uint256);
283 
284     /**
285      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
286      *
287      * Returns a boolean value indicating whether the operation succeeded.
288      *
289      * IMPORTANT: Beware that changing an allowance with this method brings the risk
290      * that someone may use both the old and the new allowance by unfortunate
291      * transaction ordering. One possible solution to mitigate this race
292      * condition is to first reduce the spender's allowance to 0 and set the
293      * desired value afterwards:
294      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
295      *
296      * Emits an {Approval} event.
297      */
298     function approve(address spender, uint256 amount) external returns (bool);
299 
300     /**
301      * @dev Moves `amount` tokens from `sender` to `recipient` using the
302      * allowance mechanism. `amount` is then deducted from the caller's
303      * allowance.
304      *
305      * Returns a boolean value indicating whether the operation succeeded.
306      *
307      * Emits a {Transfer} event.
308      */
309     function transferFrom(
310         address sender,
311         address recipient,
312         uint256 amount
313     ) external returns (bool);
314 
315     /**
316      * @dev Emitted when `value` tokens are moved from one account (`from`) to
317      * another (`to`).
318      *
319      * Note that `value` may be zero.
320      */
321     event Transfer(address indexed from, address indexed to, uint256 value);
322 
323     /**
324      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
325      * a call to {approve}. `value` is the new allowance.
326      */
327     event Approval(address indexed owner, address indexed spender, uint256 value);
328 }
329 
330 // File: @openzeppelin/contracts/utils/Context.sol
331 
332 
333 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
334 
335 pragma solidity ^0.8.0;
336 
337 /**
338  * @dev Provides information about the current execution context, including the
339  * sender of the transaction and its data. While these are generally available
340  * via msg.sender and msg.data, they should not be accessed in such a direct
341  * manner, since when dealing with meta-transactions the account sending and
342  * paying for execution may not be the actual sender (as far as an application
343  * is concerned).
344  *
345  * This contract is only required for intermediate, library-like contracts.
346  */
347 abstract contract Context {
348     function _msgSender() internal view virtual returns (address) {
349         return msg.sender;
350     }
351 
352     function _msgData() internal view virtual returns (bytes calldata) {
353         return msg.data;
354     }
355 }
356 
357 // File: @openzeppelin/contracts/access/Ownable.sol
358 
359 
360 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
361 
362 pragma solidity ^0.8.0;
363 
364 
365 /**
366  * @dev Contract module which provides a basic access control mechanism, where
367  * there is an account (an owner) that can be granted exclusive access to
368  * specific functions.
369  *
370  * By default, the owner account will be the one that deploys the contract. This
371  * can later be changed with {transferOwnership}.
372  *
373  * This module is used through inheritance. It will make available the modifier
374  * `onlyOwner`, which can be applied to your functions to restrict their use to
375  * the owner.
376  */
377 abstract contract Ownable is Context {
378     address private _owner;
379 
380     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
381 
382     /**
383      * @dev Initializes the contract setting the deployer as the initial owner.
384      */
385     constructor() {
386         _transferOwnership(_msgSender());
387     }
388 
389     /**
390      * @dev Returns the address of the current owner.
391      */
392     function owner() public view virtual returns (address) {
393         return _owner;
394     }
395 
396     /**
397      * @dev Throws if called by any account other than the owner.
398      */
399     modifier onlyOwner() {
400         require(owner() == _msgSender(), "Ownable: caller is not the owner");
401         _;
402     }
403 
404     /**
405      * @dev Leaves the contract without owner. It will not be possible to call
406      * `onlyOwner` functions anymore. Can only be called by the current owner.
407      *
408      * NOTE: Renouncing ownership will leave the contract without an owner,
409      * thereby removing any functionality that is only available to the owner.
410      */
411     function renounceOwnership() public virtual onlyOwner {
412         _transferOwnership(address(0));
413     }
414 
415     /**
416      * @dev Transfers ownership of the contract to a new account (`newOwner`).
417      * Can only be called by the current owner.
418      */
419     function transferOwnership(address newOwner) public virtual onlyOwner {
420         require(newOwner != address(0), "Ownable: new owner is the zero address");
421         _transferOwnership(newOwner);
422     }
423 
424     /**
425      * @dev Transfers ownership of the contract to a new account (`newOwner`).
426      * Internal function without access restriction.
427      */
428     function _transferOwnership(address newOwner) internal virtual {
429         address oldOwner = _owner;
430         _owner = newOwner;
431         emit OwnershipTransferred(oldOwner, newOwner);
432     }
433 }
434 
435 // File: @openzeppelin/contracts/utils/Address.sol
436 
437 
438 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
439 
440 pragma solidity ^0.8.0;
441 
442 /**
443  * @dev Collection of functions related to the address type
444  */
445 library Address {
446     /**
447      * @dev Returns true if `account` is a contract.
448      *
449      * [IMPORTANT]
450      * ====
451      * It is unsafe to assume that an address for which this function returns
452      * false is an externally-owned account (EOA) and not a contract.
453      *
454      * Among others, `isContract` will return false for the following
455      * types of addresses:
456      *
457      *  - an externally-owned account
458      *  - a contract in construction
459      *  - an address where a contract will be created
460      *  - an address where a contract lived, but was destroyed
461      * ====
462      */
463     function isContract(address account) internal view returns (bool) {
464         // This method relies on extcodesize, which returns 0 for contracts in
465         // construction, since the code is only stored at the end of the
466         // constructor execution.
467 
468         uint256 size;
469         assembly {
470             size := extcodesize(account)
471         }
472         return size > 0;
473     }
474 
475     /**
476      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
477      * `recipient`, forwarding all available gas and reverting on errors.
478      *
479      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
480      * of certain opcodes, possibly making contracts go over the 2300 gas limit
481      * imposed by `transfer`, making them unable to receive funds via
482      * `transfer`. {sendValue} removes this limitation.
483      *
484      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
485      *
486      * IMPORTANT: because control is transferred to `recipient`, care must be
487      * taken to not create reentrancy vulnerabilities. Consider using
488      * {ReentrancyGuard} or the
489      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
490      */
491     function sendValue(address payable recipient, uint256 amount) internal {
492         require(address(this).balance >= amount, "Address: insufficient balance");
493 
494         (bool success, ) = recipient.call{value: amount}("");
495         require(success, "Address: unable to send value, recipient may have reverted");
496     }
497 
498     /**
499      * @dev Performs a Solidity function call using a low level `call`. A
500      * plain `call` is an unsafe replacement for a function call: use this
501      * function instead.
502      *
503      * If `target` reverts with a revert reason, it is bubbled up by this
504      * function (like regular Solidity function calls).
505      *
506      * Returns the raw returned data. To convert to the expected return value,
507      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
508      *
509      * Requirements:
510      *
511      * - `target` must be a contract.
512      * - calling `target` with `data` must not revert.
513      *
514      * _Available since v3.1._
515      */
516     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
517         return functionCall(target, data, "Address: low-level call failed");
518     }
519 
520     /**
521      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
522      * `errorMessage` as a fallback revert reason when `target` reverts.
523      *
524      * _Available since v3.1._
525      */
526     function functionCall(
527         address target,
528         bytes memory data,
529         string memory errorMessage
530     ) internal returns (bytes memory) {
531         return functionCallWithValue(target, data, 0, errorMessage);
532     }
533 
534     /**
535      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
536      * but also transferring `value` wei to `target`.
537      *
538      * Requirements:
539      *
540      * - the calling contract must have an ETH balance of at least `value`.
541      * - the called Solidity function must be `payable`.
542      *
543      * _Available since v3.1._
544      */
545     function functionCallWithValue(
546         address target,
547         bytes memory data,
548         uint256 value
549     ) internal returns (bytes memory) {
550         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
551     }
552 
553     /**
554      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
555      * with `errorMessage` as a fallback revert reason when `target` reverts.
556      *
557      * _Available since v3.1._
558      */
559     function functionCallWithValue(
560         address target,
561         bytes memory data,
562         uint256 value,
563         string memory errorMessage
564     ) internal returns (bytes memory) {
565         require(address(this).balance >= value, "Address: insufficient balance for call");
566         require(isContract(target), "Address: call to non-contract");
567 
568         (bool success, bytes memory returndata) = target.call{value: value}(data);
569         return verifyCallResult(success, returndata, errorMessage);
570     }
571 
572     /**
573      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
574      * but performing a static call.
575      *
576      * _Available since v3.3._
577      */
578     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
579         return functionStaticCall(target, data, "Address: low-level static call failed");
580     }
581 
582     /**
583      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
584      * but performing a static call.
585      *
586      * _Available since v3.3._
587      */
588     function functionStaticCall(
589         address target,
590         bytes memory data,
591         string memory errorMessage
592     ) internal view returns (bytes memory) {
593         require(isContract(target), "Address: static call to non-contract");
594 
595         (bool success, bytes memory returndata) = target.staticcall(data);
596         return verifyCallResult(success, returndata, errorMessage);
597     }
598 
599     /**
600      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
601      * but performing a delegate call.
602      *
603      * _Available since v3.4._
604      */
605     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
606         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
607     }
608 
609     /**
610      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
611      * but performing a delegate call.
612      *
613      * _Available since v3.4._
614      */
615     function functionDelegateCall(
616         address target,
617         bytes memory data,
618         string memory errorMessage
619     ) internal returns (bytes memory) {
620         require(isContract(target), "Address: delegate call to non-contract");
621 
622         (bool success, bytes memory returndata) = target.delegatecall(data);
623         return verifyCallResult(success, returndata, errorMessage);
624     }
625 
626     /**
627      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
628      * revert reason using the provided one.
629      *
630      * _Available since v4.3._
631      */
632     function verifyCallResult(
633         bool success,
634         bytes memory returndata,
635         string memory errorMessage
636     ) internal pure returns (bytes memory) {
637         if (success) {
638             return returndata;
639         } else {
640             // Look for revert reason and bubble it up if present
641             if (returndata.length > 0) {
642                 // The easiest way to bubble the revert reason is using memory via assembly
643 
644                 assembly {
645                     let returndata_size := mload(returndata)
646                     revert(add(32, returndata), returndata_size)
647                 }
648             } else {
649                 revert(errorMessage);
650             }
651         }
652     }
653 }
654 
655 // File: contracts/varistablecapital.sol
656 
657 // Vari-Stable Capital: $VSC
658 // Deflationary DeFi-as-a-Service (DaaS) Token, with 60% supply burned to 0x0dEaD
659 // You buy on Ethereum, we execute algorithmic stablecoin strategies on various chains and return the profits to $VSC holders.
660 
661 //Initial Supply: 1,000,000,000,000 $VSC 
662 //60% of $VSC burned to 0x0dEaD
663 //10% of each buy goes to existing holders.
664 //10% of each sell goes into various-chain algorithmic stablecoin investing to add to the treasury and buy back $VSC tokens.
665 
666 // Twitter: https://twitter.com/VariStableCap
667 // Website: https://varistablecapital.link/
668 // Medium: https://varistablecapital.medium.com/
669 // Telegram: https://t.me/varistablecapital
670 
671     interface IUniswapV2Factory {
672         event PairCreated(address indexed token0, address indexed token1, address pair, uint);
673 
674         function feeTo() external view returns (address);
675         function feeToSetter() external view returns (address);
676 
677         function getPair(address tokenA, address tokenB) external view returns (address pair);
678         function allPairs(uint) external view returns (address pair);
679         function allPairsLength() external view returns (uint);
680 
681         function createPair(address tokenA, address tokenB) external returns (address pair);
682 
683         function setFeeTo(address) external;
684         function setFeeToSetter(address) external;
685     }
686 
687     interface IUniswapV2Pair {
688         event Approval(address indexed owner, address indexed spender, uint value);
689         event Transfer(address indexed from, address indexed to, uint value);
690 
691         function name() external pure returns (string memory);
692         function symbol() external pure returns (string memory);
693         function decimals() external pure returns (uint8);
694         function totalSupply() external view returns (uint);
695         function balanceOf(address owner) external view returns (uint);
696         function allowance(address owner, address spender) external view returns (uint);
697 
698         function approve(address spender, uint value) external returns (bool);
699         function transfer(address to, uint value) external returns (bool);
700         function transferFrom(address from, address to, uint value) external returns (bool);
701 
702         function DOMAIN_SEPARATOR() external view returns (bytes32);
703         function PERMIT_TYPEHASH() external pure returns (bytes32);
704         function nonces(address owner) external view returns (uint);
705 
706         function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
707 
708         event Mint(address indexed sender, uint amount0, uint amount1);
709         event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
710         event Swap(
711             address indexed sender,
712             uint amount0In,
713             uint amount1In,
714             uint amount0Out,
715             uint amount1Out,
716             address indexed to
717         );
718         event Sync(uint112 reserve0, uint112 reserve1);
719 
720         function MINIMUM_LIQUIDITY() external pure returns (uint);
721         function factory() external view returns (address);
722         function token0() external view returns (address);
723         function token1() external view returns (address);
724         function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
725         function price0CumulativeLast() external view returns (uint);
726         function price1CumulativeLast() external view returns (uint);
727         function kLast() external view returns (uint);
728 
729         function mint(address to) external returns (uint liquidity);
730         function burn(address to) external returns (uint amount0, uint amount1);
731         function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
732         function skim(address to) external;
733         function sync() external;
734 
735         function initialize(address, address) external;
736     }
737 
738 interface IUniswapV2Router01 {
739         function factory() external pure returns (address);
740         function WETH() external pure returns (address);
741 
742         function addLiquidity(
743             address tokenA,
744             address tokenB,
745             uint amountADesired,
746             uint amountBDesired,
747             uint amountAMin,
748             uint amountBMin,
749             address to,
750             uint deadline
751         ) external returns (uint amountA, uint amountB, uint liquidity);
752         function addLiquidityETH(
753             address token,
754             uint amountTokenDesired,
755             uint amountTokenMin,
756             uint amountETHMin,
757             address to,
758             uint deadline
759         ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
760         function removeLiquidity(
761             address tokenA,
762             address tokenB,
763             uint liquidity,
764             uint amountAMin,
765             uint amountBMin,
766             address to,
767             uint deadline
768         ) external returns (uint amountA, uint amountB);
769         function removeLiquidityETH(
770             address token,
771             uint liquidity,
772             uint amountTokenMin,
773             uint amountETHMin,
774             address to,
775             uint deadline
776         ) external returns (uint amountToken, uint amountETH);
777         function removeLiquidityWithPermit(
778             address tokenA,
779             address tokenB,
780             uint liquidity,
781             uint amountAMin,
782             uint amountBMin,
783             address to,
784             uint deadline,
785             bool approveMax, uint8 v, bytes32 r, bytes32 s
786         ) external returns (uint amountA, uint amountB);
787         function removeLiquidityETHWithPermit(
788             address token,
789             uint liquidity,
790             uint amountTokenMin,
791             uint amountETHMin,
792             address to,
793             uint deadline,
794             bool approveMax, uint8 v, bytes32 r, bytes32 s
795         ) external returns (uint amountToken, uint amountETH);
796         function swapExactTokensForTokens(
797             uint amountIn,
798             uint amountOutMin,
799             address[] calldata path,
800             address to,
801             uint deadline
802         ) external returns (uint[] memory amounts);
803         function swapTokensForExactTokens(
804             uint amountOut,
805             uint amountInMax,
806             address[] calldata path,
807             address to,
808             uint deadline
809         ) external returns (uint[] memory amounts);
810         function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
811             external
812             payable
813             returns (uint[] memory amounts);
814         function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
815             external
816             returns (uint[] memory amounts);
817         function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
818             external
819             returns (uint[] memory amounts);
820         function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
821             external
822             payable
823             returns (uint[] memory amounts);
824 
825         function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
826         function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
827         function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
828         function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
829         function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
830     }
831 
832 
833    interface IUniswapV2Router02 is IUniswapV2Router01 {
834         function removeLiquidityETHSupportingFeeOnTransferTokens(
835             address token,
836             uint liquidity,
837             uint amountTokenMin,
838             uint amountETHMin,
839             address to,
840             uint deadline
841         ) external returns (uint amountETH);
842         function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
843             address token,
844             uint liquidity,
845             uint amountTokenMin,
846             uint amountETHMin,
847             address to,
848             uint deadline,
849             bool approveMax, uint8 v, bytes32 r, bytes32 s
850         ) external returns (uint amountETH);
851 
852         function swapExactTokensForTokensSupportingFeeOnTransferTokens(
853             uint amountIn,
854             uint amountOutMin,
855             address[] calldata path,
856             address to,
857             uint deadline
858         ) external;
859         function swapExactETHForTokensSupportingFeeOnTransferTokens(
860             uint amountOutMin,
861             address[] calldata path,
862             address to,
863             uint deadline
864         ) external payable;
865         function swapExactTokensForETHSupportingFeeOnTransferTokens(
866             uint amountIn,
867             uint amountOutMin,
868             address[] calldata path,
869             address to,
870             uint deadline
871         ) external;
872     }
873 
874 pragma solidity ^0.8.0;
875 //SPDX-License-Identifier: MIT
876 
877 
878 
879 
880 
881 
882     contract VariStableCapital is Context, IERC20, Ownable {
883         using SafeMath for uint256;
884         using Address for address;
885 
886         mapping (address => uint256) private _rOwned;
887         mapping (address => uint256) private _tOwned;
888         mapping (address => mapping (address => uint256)) private _allowances;
889 
890         mapping (address => bool) private _isExcludedFromFee;
891 
892         mapping (address => bool) private _isExcluded;
893         address[] private _excluded;
894 
895         uint256 private constant MAX = ~uint256(0);
896         uint256 private _tTotal = 1000000000000 * 10**9;
897         uint256 private _rTotal = (MAX - (MAX % _tTotal));
898         uint256 private _tFeeTotal;
899 
900         string private _name = 'VariStableCapital';
901         string private _symbol = 'VSC';
902         uint8 private _decimals = 9;
903 
904         uint256 private _taxFee = 10;
905         uint256 private _teamFee = 10;
906         uint256 private _previousTaxFee = _taxFee;
907         uint256 private _previousTeamFee = _teamFee;
908 
909         address payable public _VSCWalletAddress;
910         address payable public _marketingWalletAddress;
911 
912         IUniswapV2Router02 public immutable uniswapV2Router;
913         address public immutable uniswapV2Pair;
914 
915         bool inSwap = false;
916         bool public swapEnabled = true;
917 
918         uint256 private _maxTxAmount = 100000000000000e9;
919         // We will set a minimum amount of tokens to be swaped => 5M
920         uint256 private _numOfTokensToExchangeForTeam = 5 * 10**3 * 10**9;
921 
922         event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
923         event SwapEnabledUpdated(bool enabled);
924 
925         modifier lockTheSwap {
926             inSwap = true;
927             _;
928             inSwap = false;
929         }
930 
931         constructor (address payable VSCWalletAddress, address payable marketingWalletAddress) {
932             _VSCWalletAddress = VSCWalletAddress;
933             _marketingWalletAddress = marketingWalletAddress;
934             _rOwned[_msgSender()] = _rTotal;
935 
936             IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UniswapV2 for Ethereum network
937             // Create a uniswap pair for this new token
938             uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
939                 .createPair(address(this), _uniswapV2Router.WETH());
940 
941             // set the rest of the contract variables
942             uniswapV2Router = _uniswapV2Router;
943 
944             // Exclude owner and this contract from fee
945             _isExcludedFromFee[owner()] = true;
946             _isExcludedFromFee[address(this)] = true;
947 
948             emit Transfer(address(0), _msgSender(), _tTotal);
949         }
950 
951         function name() public view returns (string memory) {
952             return _name;
953         }
954 
955         function symbol() public view returns (string memory) {
956             return _symbol;
957         }
958 
959         function decimals() public view returns (uint8) {
960             return _decimals;
961         }
962 
963         function totalSupply() public view override returns (uint256) {
964             return _tTotal;
965         }
966 
967         function balanceOf(address account) public view override returns (uint256) {
968             if (_isExcluded[account]) return _tOwned[account];
969             return tokenFromReflection(_rOwned[account]);
970         }
971 
972         function transfer(address recipient, uint256 amount) public override returns (bool) {
973             _transfer(_msgSender(), recipient, amount);
974             return true;
975         }
976 
977         function allowance(address owner, address spender) public view override returns (uint256) {
978             return _allowances[owner][spender];
979         }
980 
981         function approve(address spender, uint256 amount) public override returns (bool) {
982             _approve(_msgSender(), spender, amount);
983             return true;
984         }
985 
986         function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
987             _transfer(sender, recipient, amount);
988             _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
989             return true;
990         }
991 
992         function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
993             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
994             return true;
995         }
996 
997         function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
998             _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
999             return true;
1000         }
1001 
1002         function isExcluded(address account) public view returns (bool) {
1003             return _isExcluded[account];
1004         }
1005 
1006         function setExcludeFromFee(address account, bool excluded) external onlyOwner() {
1007             _isExcludedFromFee[account] = excluded;
1008         }
1009 
1010         function totalFees() public view returns (uint256) {
1011             return _tFeeTotal;
1012         }
1013 
1014         function deliver(uint256 tAmount) public {
1015             address sender = _msgSender();
1016             require(!_isExcluded[sender], "Excluded addresses cannot call this function");
1017             (uint256 rAmount,,,,,) = _getValues(tAmount);
1018             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1019             _rTotal = _rTotal.sub(rAmount);
1020             _tFeeTotal = _tFeeTotal.add(tAmount);
1021         }
1022 
1023         function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
1024             require(tAmount <= _tTotal, "Amount must be less than supply");
1025             if (!deductTransferFee) {
1026                 (uint256 rAmount,,,,,) = _getValues(tAmount);
1027                 return rAmount;
1028             } else {
1029                 (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
1030                 return rTransferAmount;
1031             }
1032         }
1033 
1034         function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
1035             require(rAmount <= _rTotal, "Amount must be less than total reflections");
1036             uint256 currentRate =  _getRate();
1037             return rAmount.div(currentRate);
1038         }
1039 
1040         function excludeAccount(address account) external onlyOwner() {
1041             require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
1042             require(!_isExcluded[account], "Account is already excluded");
1043             if(_rOwned[account] > 0) {
1044                 _tOwned[account] = tokenFromReflection(_rOwned[account]);
1045             }
1046             _isExcluded[account] = true;
1047             _excluded.push(account);
1048         }
1049 
1050         function includeAccount(address account) external onlyOwner() {
1051             require(_isExcluded[account], "Account is already excluded");
1052             for (uint256 i = 0; i < _excluded.length; i++) {
1053                 if (_excluded[i] == account) {
1054                     _excluded[i] = _excluded[_excluded.length - 1];
1055                     _tOwned[account] = 0;
1056                     _isExcluded[account] = false;
1057                     _excluded.pop();
1058                     break;
1059                 }
1060             }
1061         }
1062 
1063         function removeAllFee() private {
1064             if(_taxFee == 0 && _teamFee == 0) return;
1065 
1066             _previousTaxFee = _taxFee;
1067             _previousTeamFee = _teamFee;
1068 
1069             _taxFee = 0;
1070             _teamFee = 0;
1071         }
1072 
1073         function restoreAllFee() private {
1074             _taxFee = _previousTaxFee;
1075             _teamFee = _previousTeamFee;
1076         }
1077 
1078         function isExcludedFromFee(address account) public view returns(bool) {
1079             return _isExcludedFromFee[account];
1080         }
1081 
1082         function _approve(address owner, address spender, uint256 amount) private {
1083             require(owner != address(0), "ERC20: approve from the zero address");
1084             require(spender != address(0), "ERC20: approve to the zero address");
1085 
1086             _allowances[owner][spender] = amount;
1087             emit Approval(owner, spender, amount);
1088         }
1089 
1090         function _transfer(address sender, address recipient, uint256 amount) private {
1091             require(sender != address(0), "ERC20: transfer from the zero address");
1092             require(recipient != address(0), "ERC20: transfer to the zero address");
1093             require(amount > 0, "Transfer amount must be greater than zero");
1094 
1095             if(sender != owner() && recipient != owner())
1096                 require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1097 
1098             // is the token balance of this contract address over the min number of
1099             // tokens that we need to initiate a swap?
1100             // also, don't get caught in a circular team event.
1101             // also, don't swap if sender is uniswap pair.
1102             uint256 contractTokenBalance = balanceOf(address(this));
1103 
1104             if(contractTokenBalance >= _maxTxAmount)
1105             {
1106                 contractTokenBalance = _maxTxAmount;
1107             }
1108 
1109             bool overMinTokenBalance = contractTokenBalance >= _numOfTokensToExchangeForTeam;
1110             if (!inSwap && swapEnabled && overMinTokenBalance && sender != uniswapV2Pair) {
1111                 // We need to swap the current tokens to ETH and send to the team wallet
1112                 swapTokensForEth(contractTokenBalance);
1113 
1114                 uint256 contractETHBalance = address(this).balance;
1115                 if(contractETHBalance > 0) {
1116                     sendETHToTeam(address(this).balance);
1117                 }
1118             }
1119 
1120             //indicates if fee should be deducted from transfer
1121             bool takeFee = true;
1122 
1123             //if any account belongs to _isExcludedFromFee account then remove the fee
1124             if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
1125                 takeFee = false;
1126             }
1127 
1128             //transfer amount, it will take tax and team fee
1129             _tokenTransfer(sender,recipient,amount,takeFee);
1130         }
1131 
1132         function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
1133             // generate the uniswap pair path of token -> weth
1134             address[] memory path = new address[](2);
1135             path[0] = address(this);
1136             path[1] = uniswapV2Router.WETH();
1137 
1138             _approve(address(this), address(uniswapV2Router), tokenAmount);
1139 
1140             // make the swap
1141             uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1142                 tokenAmount,
1143                 0, // accept any amount of ETH
1144                 path,
1145                 address(this),
1146                 block.timestamp
1147             );
1148         }
1149 
1150         function sendETHToTeam(uint256 amount) private {
1151             _VSCWalletAddress.transfer(amount.div(2));
1152             _marketingWalletAddress.transfer(amount.div(2));
1153         }
1154 
1155         // We are exposing these functions to be able to manual swap and send
1156         // in case the token is highly valued and 5M becomes too much
1157         function manualSwap() external onlyOwner() {
1158             uint256 contractBalance = balanceOf(address(this));
1159             swapTokensForEth(contractBalance);
1160         }
1161 
1162         function manualSend() external onlyOwner() {
1163             uint256 contractETHBalance = address(this).balance;
1164             sendETHToTeam(contractETHBalance);
1165         }
1166 
1167         function setSwapEnabled(bool enabled) external onlyOwner(){
1168             swapEnabled = enabled;
1169         }
1170 
1171         function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
1172             if(!takeFee)
1173                 removeAllFee();
1174 
1175             if (_isExcluded[sender] && !_isExcluded[recipient]) {
1176                 _transferFromExcluded(sender, recipient, amount);
1177             } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1178                 _transferToExcluded(sender, recipient, amount);
1179             } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1180                 _transferStandard(sender, recipient, amount);
1181             } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1182                 _transferBothExcluded(sender, recipient, amount);
1183             } else {
1184                 _transferStandard(sender, recipient, amount);
1185             }
1186 
1187             if(!takeFee)
1188                 restoreAllFee();
1189         }
1190 
1191         function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1192             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
1193             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1194             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1195             _takeTeam(tTeam);
1196             _reflectFee(rFee, tFee);
1197             emit Transfer(sender, recipient, tTransferAmount);
1198         }
1199 
1200         function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1201             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
1202             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1203             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1204             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1205             _takeTeam(tTeam);
1206             _reflectFee(rFee, tFee);
1207             emit Transfer(sender, recipient, tTransferAmount);
1208         }
1209 
1210         function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1211             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
1212             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1213             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1214             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1215             _takeTeam(tTeam);
1216             _reflectFee(rFee, tFee);
1217             emit Transfer(sender, recipient, tTransferAmount);
1218         }
1219 
1220         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1221             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
1222             _tOwned[sender] = _tOwned[sender].sub(tAmount);
1223             _rOwned[sender] = _rOwned[sender].sub(rAmount);
1224             _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1225             _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1226             _takeTeam(tTeam);
1227             _reflectFee(rFee, tFee);
1228             emit Transfer(sender, recipient, tTransferAmount);
1229         }
1230 
1231         function _takeTeam(uint256 tTeam) private {
1232             uint256 currentRate =  _getRate();
1233             uint256 rTeam = tTeam.mul(currentRate);
1234             _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
1235             if(_isExcluded[address(this)])
1236                 _tOwned[address(this)] = _tOwned[address(this)].add(tTeam);
1237         }
1238 
1239         function _reflectFee(uint256 rFee, uint256 tFee) private {
1240             _rTotal = _rTotal.sub(rFee);
1241             _tFeeTotal = _tFeeTotal.add(tFee);
1242         }
1243 
1244          //to recieve ETH from uniswapV2Router when swaping
1245         receive() external payable {}
1246 
1247         function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1248             (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
1249             uint256 currentRate =  _getRate();
1250             (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1251             return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
1252         }
1253 
1254         function _getTValues(uint256 tAmount, uint256 taxFee, uint256 teamFee) private pure returns (uint256, uint256, uint256) {
1255             uint256 tFee = tAmount.mul(taxFee).div(100);
1256             uint256 tTeam = tAmount.mul(teamFee).div(100);
1257             uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
1258             return (tTransferAmount, tFee, tTeam);
1259         }
1260 
1261         function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1262             uint256 rAmount = tAmount.mul(currentRate);
1263             uint256 rFee = tFee.mul(currentRate);
1264             uint256 rTransferAmount = rAmount.sub(rFee);
1265             return (rAmount, rTransferAmount, rFee);
1266         }
1267 
1268         function _getRate() private view returns(uint256) {
1269             (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1270             return rSupply.div(tSupply);
1271         }
1272 
1273         function _getCurrentSupply() private view returns(uint256, uint256) {
1274             uint256 rSupply = _rTotal;
1275             uint256 tSupply = _tTotal;
1276             for (uint256 i = 0; i < _excluded.length; i++) {
1277                 if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1278                 rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1279                 tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1280             }
1281             if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1282             return (rSupply, tSupply);
1283         }
1284 
1285         function _getTaxFee() private view returns(uint256) {
1286             return _taxFee;
1287         }
1288 
1289         function _getMaxTxAmount() private view returns(uint256) {
1290             return _maxTxAmount;
1291         }
1292 
1293         function _getETHBalance() public view returns(uint256 balance) {
1294             return address(this).balance;
1295         }
1296 
1297         function _setTaxFee(uint256 taxFee) external onlyOwner() {
1298             require(taxFee >= 1 && taxFee <= 25, 'taxFee should be in 1 - 25');
1299             _taxFee = taxFee;
1300         }
1301 
1302         function _setTeamFee(uint256 teamFee) external onlyOwner() {
1303             require(teamFee >= 1 && teamFee <= 25, 'teamFee should be in 1 - 25');
1304             _teamFee = teamFee;
1305         }
1306 
1307         function _setVSCWallet(address payable VSCWalletAddress) external onlyOwner() {
1308             _VSCWalletAddress = VSCWalletAddress;
1309         }
1310 
1311         function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1312             require(maxTxAmount >= 100000000000000e9 , 'maxTxAmount should be greater than 100000000000000e9');
1313             _maxTxAmount = maxTxAmount;
1314         }
1315     }