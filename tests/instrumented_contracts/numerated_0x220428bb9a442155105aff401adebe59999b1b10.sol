1 /*
2 Track you memecoins portfolio at your fingertips !
3 Twitter  : https://twitter.com/madaraapp
4 Telegram : https://t.me/madaraapp
5 Medium   : https://medium.com/@MadaraApp
6 Website  : https://www.madara.app/
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity ^0.8.7;
12 pragma experimental ABIEncoderV2;
13 
14 
15 /**
16  * @dev Interface of the ERC20 standard as defined in the EIP.
17  */
18 interface IERC20 {
19     /**
20      * @dev Returns the amount of tokens in existence.
21      */
22     function totalSupply() external view returns (uint256);
23 
24     /**
25      * @dev Returns the amount of tokens owned by `account`.
26      */
27     function balanceOf(address account) external view returns (uint256);
28 
29     /**
30      * @dev Moves `amount` tokens from the caller's account to `to`.
31      *
32      * Returns a boolean value indicating whether the operation succeeded.
33      *
34      * Emits a {Transfer} event.
35      */
36     function transfer(address to, uint256 amount) external returns (bool);
37 
38     /**
39      * @dev Returns the remaining number of tokens that `spender` will be
40      * allowed to spend on behalf of `owner` through {transferFrom}. This is
41      * zero by default.
42      *
43      * This value changes when {approve} or {transferFrom} are called.
44      */
45     function allowance(address owner, address spender) external view returns (uint256);
46 
47     /**
48      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
49      *
50      * Returns a boolean value indicating whether the operation succeeded.
51      *
52      * IMPORTANT: Beware that changing an allowance with this method brings the risk
53      * that someone may use both the old and the new allowance by unfortunate
54      * transaction ordering. One possible solution to mitigate this race
55      * condition is to first reduce the spender's allowance to 0 and set the
56      * desired value afterwards:
57      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
58      *
59      * Emits an {Approval} event.
60      */
61     function approve(address spender, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Moves `amount` tokens from `from` to `to` using the
65      * allowance mechanism. `amount` is then deducted from the caller's
66      * allowance.
67      *
68      * Returns a boolean value indicating whether the operation succeeded.
69      *
70      * Emits a {Transfer} event.
71      */
72     function transferFrom(
73         address from,
74         address to,
75         uint256 amount
76     ) external returns (bool);
77 
78     /**
79      * @dev Emitted when `value` tokens are moved from one account (`from`) to
80      * another (`to`).
81      *
82      * Note that `value` may be zero.
83      */
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 
86     /**
87      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
88      * a call to {approve}. `value` is the new allowance.
89      */
90     event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 
93 // CAUTION
94 // This version of SafeMath should only be used with Solidity 0.8 or later,
95 // because it relies on the compiler's built in overflow checks.
96 
97 /**
98  * @dev Wrappers over Solidity's arithmetic operations.
99  *
100  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
101  * now has built in overflow checking.
102  */
103 library SafeMath {
104     /**
105      * @dev Returns the addition of two unsigned integers, with an overflow flag.
106      *
107      * _Available since v3.4._
108      */
109     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
110         unchecked {
111             uint256 c = a + b;
112             if (c < a) return (false, 0);
113             return (true, c);
114         }
115     }
116 
117     /**
118      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
119      *
120      * _Available since v3.4._
121      */
122     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
123         unchecked {
124             if (b > a) return (false, 0);
125             return (true, a - b);
126         }
127     }
128 
129     /**
130      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
131      *
132      * _Available since v3.4._
133      */
134     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
135         unchecked {
136             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
137             // benefit is lost if 'b' is also tested.
138             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
139             if (a == 0) return (true, 0);
140             uint256 c = a * b;
141             if (c / a != b) return (false, 0);
142             return (true, c);
143         }
144     }
145 
146     /**
147      * @dev Returns the division of two unsigned integers, with a division by zero flag.
148      *
149      * _Available since v3.4._
150      */
151     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
152         unchecked {
153             if (b == 0) return (false, 0);
154             return (true, a / b);
155         }
156     }
157 
158     /**
159      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
160      *
161      * _Available since v3.4._
162      */
163     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
164         unchecked {
165             if (b == 0) return (false, 0);
166             return (true, a % b);
167         }
168     }
169 
170     /**
171      * @dev Returns the addition of two unsigned integers, reverting on
172      * overflow.
173      *
174      * Counterpart to Solidity's `+` operator.
175      *
176      * Requirements:
177      *
178      * - Addition cannot overflow.
179      */
180     function add(uint256 a, uint256 b) internal pure returns (uint256) {
181         return a + b;
182     }
183 
184     /**
185      * @dev Returns the subtraction of two unsigned integers, reverting on
186      * overflow (when the result is negative).
187      *
188      * Counterpart to Solidity's `-` operator.
189      *
190      * Requirements:
191      *
192      * - Subtraction cannot overflow.
193      */
194     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
195         return a - b;
196     }
197 
198     /**
199      * @dev Returns the multiplication of two unsigned integers, reverting on
200      * overflow.
201      *
202      * Counterpart to Solidity's `*` operator.
203      *
204      * Requirements:
205      *
206      * - Multiplication cannot overflow.
207      */
208     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
209         return a * b;
210     }
211 
212     /**
213      * @dev Returns the integer division of two unsigned integers, reverting on
214      * division by zero. The result is rounded towards zero.
215      *
216      * Counterpart to Solidity's `/` operator.
217      *
218      * Requirements:
219      *
220      * - The divisor cannot be zero.
221      */
222     function div(uint256 a, uint256 b) internal pure returns (uint256) {
223         return a / b;
224     }
225 
226     /**
227      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
228      * reverting when dividing by zero.
229      *
230      * Counterpart to Solidity's `%` operator. This function uses a `revert`
231      * opcode (which leaves remaining gas untouched) while Solidity uses an
232      * invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      *
236      * - The divisor cannot be zero.
237      */
238     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
239         return a % b;
240     }
241 
242     /**
243      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
244      * overflow (when the result is negative).
245      *
246      * CAUTION: This function is deprecated because it requires allocating memory for the error
247      * message unnecessarily. For custom revert reasons use {trySub}.
248      *
249      * Counterpart to Solidity's `-` operator.
250      *
251      * Requirements:
252      *
253      * - Subtraction cannot overflow.
254      */
255     function sub(
256         uint256 a,
257         uint256 b,
258         string memory errorMessage
259     ) internal pure returns (uint256) {
260         unchecked {
261             require(b <= a, errorMessage);
262             return a - b;
263         }
264     }
265 
266     /**
267      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
268      * division by zero. The result is rounded towards zero.
269      *
270      * Counterpart to Solidity's `/` operator. Note: this function uses a
271      * `revert` opcode (which leaves remaining gas untouched) while Solidity
272      * uses an invalid opcode to revert (consuming all remaining gas).
273      *
274      * Requirements:
275      *
276      * - The divisor cannot be zero.
277      */
278     function div(
279         uint256 a,
280         uint256 b,
281         string memory errorMessage
282     ) internal pure returns (uint256) {
283         unchecked {
284             require(b > 0, errorMessage);
285             return a / b;
286         }
287     }
288 
289     /**
290      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
291      * reverting with custom message when dividing by zero.
292      *
293      * CAUTION: This function is deprecated because it requires allocating memory for the error
294      * message unnecessarily. For custom revert reasons use {tryMod}.
295      *
296      * Counterpart to Solidity's `%` operator. This function uses a `revert`
297      * opcode (which leaves remaining gas untouched) while Solidity uses an
298      * invalid opcode to revert (consuming all remaining gas).
299      *
300      * Requirements:
301      *
302      * - The divisor cannot be zero.
303      */
304     function mod(
305         uint256 a,
306         uint256 b,
307         string memory errorMessage
308     ) internal pure returns (uint256) {
309         unchecked {
310             require(b > 0, errorMessage);
311             return a % b;
312         }
313     }
314 }
315 
316 /**
317  * @dev Provides information about the current execution context, including the
318  * sender of the transaction and its data. While these are generally available
319  * via msg.sender and msg.data, they should not be accessed in such a direct
320  * manner, since when dealing with meta-transactions the account sending and
321  * paying for execution may not be the actual sender (as far as an application
322  * is concerned).
323  *
324  * This contract is only required for intermediate, library-like contracts.
325  */
326 abstract contract Context {
327     function _msgSender() internal view virtual returns (address) {
328         return msg.sender;
329     }
330 
331     function _msgData() internal view virtual returns (bytes calldata) {
332         return msg.data;
333     }
334 }
335 
336 
337 /**
338  * @dev Collection of functions related to the address type
339  */
340 library Address {
341     /**
342      * @dev Returns true if `account` is a contract.
343      *
344      * [IMPORTANT]
345      * ====
346      * It is unsafe to assume that an address for which this function returns
347      * false is an externally-owned account (EOA) and not a contract.
348      *
349      * Among others, `isContract` will return false for the following
350      * types of addresses:
351      *
352      *  - an externally-owned account
353      *  - a contract in construction
354      *  - an address where a contract will be created
355      *  - an address where a contract lived, but was destroyed
356      * ====
357      *
358      * [IMPORTANT]
359      * ====
360      * You shouldn't rely on `isContract` to protect against flash loan attacks!
361      *
362      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
363      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
364      * constructor.
365      * ====
366      */
367     function isContract(address account) internal view returns (bool) {
368         // This method relies on extcodesize/address.code.length, which returns 0
369         // for contracts in construction, since the code is only stored at the end
370         // of the constructor execution.
371 
372         return account.code.length > 0;
373     }
374 
375     /**
376      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
377      * `recipient`, forwarding all available gas and reverting on errors.
378      *
379      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
380      * of certain opcodes, possibly making contracts go over the 2300 gas limit
381      * imposed by `transfer`, making them unable to receive funds via
382      * `transfer`. {sendValue} removes this limitation.
383      *
384      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
385      *
386      * IMPORTANT: because control is transferred to `recipient`, care must be
387      * taken to not create reentrancy vulnerabilities. Consider using
388      * {ReentrancyGuard} or the
389      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
390      */
391     function sendValue(address payable recipient, uint256 amount) internal {
392         require(address(this).balance >= amount, "Address: insufficient balance");
393 
394         (bool success, ) = recipient.call{value: amount}("");
395         require(success, "Address: unable to send value, recipient may have reverted");
396     }
397 
398     /**
399      * @dev Performs a Solidity function call using a low level `call`. A
400      * plain `call` is an unsafe replacement for a function call: use this
401      * function instead.
402      *
403      * If `target` reverts with a revert reason, it is bubbled up by this
404      * function (like regular Solidity function calls).
405      *
406      * Returns the raw returned data. To convert to the expected return value,
407      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
408      *
409      * Requirements:
410      *
411      * - `target` must be a contract.
412      * - calling `target` with `data` must not revert.
413      *
414      * _Available since v3.1._
415      */
416     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
417         return functionCall(target, data, "Address: low-level call failed");
418     }
419 
420     /**
421      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
422      * `errorMessage` as a fallback revert reason when `target` reverts.
423      *
424      * _Available since v3.1._
425      */
426     function functionCall(
427         address target,
428         bytes memory data,
429         string memory errorMessage
430     ) internal returns (bytes memory) {
431         return functionCallWithValue(target, data, 0, errorMessage);
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
436      * but also transferring `value` wei to `target`.
437      *
438      * Requirements:
439      *
440      * - the calling contract must have an ETH balance of at least `value`.
441      * - the called Solidity function must be `payable`.
442      *
443      * _Available since v3.1._
444      */
445     function functionCallWithValue(
446         address target,
447         bytes memory data,
448         uint256 value
449     ) internal returns (bytes memory) {
450         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
451     }
452 
453     /**
454      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
455      * with `errorMessage` as a fallback revert reason when `target` reverts.
456      *
457      * _Available since v3.1._
458      */
459     function functionCallWithValue(
460         address target,
461         bytes memory data,
462         uint256 value,
463         string memory errorMessage
464     ) internal returns (bytes memory) {
465         require(address(this).balance >= value, "Address: insufficient balance for call");
466         require(isContract(target), "Address: call to non-contract");
467 
468         (bool success, bytes memory returndata) = target.call{value: value}(data);
469         return verifyCallResult(success, returndata, errorMessage);
470     }
471 
472     /**
473      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
474      * but performing a static call.
475      *
476      * _Available since v3.3._
477      */
478     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
479         return functionStaticCall(target, data, "Address: low-level static call failed");
480     }
481 
482     /**
483      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
484      * but performing a static call.
485      *
486      * _Available since v3.3._
487      */
488     function functionStaticCall(
489         address target,
490         bytes memory data,
491         string memory errorMessage
492     ) internal view returns (bytes memory) {
493         require(isContract(target), "Address: static call to non-contract");
494 
495         (bool success, bytes memory returndata) = target.staticcall(data);
496         return verifyCallResult(success, returndata, errorMessage);
497     }
498 
499     /**
500      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
501      * but performing a delegate call.
502      *
503      * _Available since v3.4._
504      */
505     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
506         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
507     }
508 
509     /**
510      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
511      * but performing a delegate call.
512      *
513      * _Available since v3.4._
514      */
515     function functionDelegateCall(
516         address target,
517         bytes memory data,
518         string memory errorMessage
519     ) internal returns (bytes memory) {
520         require(isContract(target), "Address: delegate call to non-contract");
521 
522         (bool success, bytes memory returndata) = target.delegatecall(data);
523         return verifyCallResult(success, returndata, errorMessage);
524     }
525 
526     /**
527      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
528      * revert reason using the provided one.
529      *
530      * _Available since v4.3._
531      */
532     function verifyCallResult(
533         bool success,
534         bytes memory returndata,
535         string memory errorMessage
536     ) internal pure returns (bytes memory) {
537         if (success) {
538             return returndata;
539         } else {
540             // Look for revert reason and bubble it up if present
541             if (returndata.length > 0) {
542                 // The easiest way to bubble the revert reason is using memory via assembly
543 
544                 assembly {
545                     let returndata_size := mload(returndata)
546                     revert(add(32, returndata), returndata_size)
547                 }
548             } else {
549                 revert(errorMessage);
550             }
551         }
552     }
553 }
554 
555 /**
556  * @dev Contract module which provides a basic access control mechanism, where
557  * there is an account (an owner) that can be granted exclusive access to
558  * specific functions.
559  *
560  * By default, the owner account will be the one that deploys the contract. This
561  * can later be changed with {transferOwnership}.
562  *
563  * This module is used through inheritance. It will make available the modifier
564  * `onlyOwner`, which can be applied to your functions to restrict their use to
565  * the owner.
566  */
567 abstract contract Ownable is Context {
568     address private _owner;
569 
570     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
571 
572     /**
573      * @dev Initializes the contract setting the deployer as the initial owner.
574      */
575     constructor() {
576         _transferOwnership(_msgSender());
577     }
578 
579     /**
580      * @dev Returns the address of the current owner.
581      */
582     function owner() public view virtual returns (address) {
583         return _owner;
584     }
585 
586     /**
587      * @dev Throws if called by any account other than the owner.
588      */
589     modifier onlyOwner() {
590         require(owner() == _msgSender(), "Ownable: caller is not the owner");
591         _;
592     }
593 
594     /**
595      * @dev Leaves the contract without owner. It will not be possible to call
596      * `onlyOwner` functions anymore. Can only be called by the current owner.
597      *
598      * NOTE: Renouncing ownership will leave the contract without an owner,
599      * thereby removing any functionality that is only available to the owner.
600      */
601     function renounceOwnership() public virtual onlyOwner {
602         _transferOwnership(address(0));
603     }
604 
605     /**
606      * @dev Transfers ownership of the contract to a new account (`newOwner`).
607      * Can only be called by the current owner.
608      */
609     function transferOwnership(address newOwner) public virtual onlyOwner {
610         require(newOwner != address(0), "Ownable: new owner is the zero address");
611         _transferOwnership(newOwner);
612     }
613 
614     /**
615      * @dev Transfers ownership of the contract to a new account (`newOwner`).
616      * Internal function without access restriction.
617      */
618     function _transferOwnership(address newOwner) internal virtual {
619         address oldOwner = _owner;
620         _owner = newOwner;
621         emit OwnershipTransferred(oldOwner, newOwner);
622     }
623 }
624 
625 
626 interface UniSwapFactory {
627     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
628 
629     function feeTo() external view returns (address);
630 
631     function feeToSetter() external view returns (address);
632 
633     function getPair(address tokenA, address tokenB) external view returns (address pair);
634 
635     function allPairs(uint) external view returns (address pair);
636 
637     function allPairsLength() external view returns (uint);
638 
639     function createPair(address tokenA, address tokenB) external returns (address pair);
640 
641     function setFeeTo(address) external;
642 
643     function setFeeToSetter(address) external;
644 }
645 
646 
647 interface IIUniSwapPair {
648     event Approval(address indexed owner, address indexed spender, uint value);
649     event Transfer(address indexed from, address indexed to, uint value);
650 
651     function name() external pure returns (string memory);
652 
653     function symbol() external pure returns (string memory);
654 
655     function decimals() external pure returns (uint8);
656 
657     function totalSupply() external view returns (uint);
658 
659     function balanceOf(address owner) external view returns (uint);
660 
661     function allowance(address owner, address spender) external view returns (uint);
662 
663     function approve(address spender, uint value) external returns (bool);
664 
665     function transfer(address to, uint value) external returns (bool);
666 
667     function transferFrom(address from, address to, uint value) external returns (bool);
668 
669     function DOMAIN_SEPARATOR() external view returns (bytes32);
670 
671     function PERMIT_TYPEHASH() external pure returns (bytes32);
672 
673     function nonces(address owner) external view returns (uint);
674 
675     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
676 
677     event Mint(address indexed sender, uint amount0, uint amount1);
678     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
679     event Swap(
680         address indexed sender,
681         uint amount0In,
682         uint amount1In,
683         uint amount0Out,
684         uint amount1Out,
685         address indexed to
686     );
687     event Sync(uint112 reserve0, uint112 reserve1);
688 
689     function MINIMUM_LIQUIDITY() external pure returns (uint);
690 
691     function factory() external view returns (address);
692 
693     function token0() external view returns (address);
694 
695     function token1() external view returns (address);
696 
697     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
698 
699     function price0CumulativeLast() external view returns (uint);
700 
701     function price1CumulativeLast() external view returns (uint);
702 
703     function kLast() external view returns (uint);
704 
705     function mint(address to) external returns (uint liquidity);
706 
707     function burn(address to) external returns (uint amount0, uint amount1);
708 
709     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
710 
711     function skim(address to) external;
712 
713     function sync() external;
714 
715     function initialize(address, address) external;
716 }
717 
718 
719 interface IUniswapV2Router01 {
720     function factory() external pure returns (address);
721 
722     function WETH() external pure returns (address);
723 
724     function WBNB() external pure returns (address);
725 
726     function WAVAX() external pure returns (address);
727 
728     function WHT() external pure returns (address);
729 
730     function addLiquidity(
731         address tokenA,
732         address tokenB,
733         uint amountADesired,
734         uint amountBDesired,
735         uint amountAMin,
736         uint amountBMin,
737         address to,
738         uint deadline
739     ) external returns (uint amountA, uint amountB, uint liquidity);
740 
741     function addLiquidityETH(
742         address token,
743         uint amountTokenDesired,
744         uint amountTokenMin,
745         uint amountETHMin,
746         address to,
747         uint deadline
748     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
749 
750     function addLiquidityBNB(
751         address token,
752         uint amountTokenDesired,
753         uint amountTokenMin,
754         uint amountETHMin,
755         address to,
756         uint deadline
757     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
758 
759     function addLiquidityAVAX(
760         address token,
761         uint amountTokenDesired,
762         uint amountTokenMin,
763         uint amountETHMin,
764         address to,
765         uint deadline
766     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
767 
768     function addLiquidityHT(
769         address token,
770         uint amountTokenDesired,
771         uint amountTokenMin,
772         uint amountETHMin,
773         address to,
774         uint deadline
775     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
776 
777     function removeLiquidity(
778         address tokenA,
779         address tokenB,
780         uint liquidity,
781         uint amountAMin,
782         uint amountBMin,
783         address to,
784         uint deadline
785     ) external returns (uint amountA, uint amountB);
786 
787     function removeLiquidityETH(
788         address token,
789         uint liquidity,
790         uint amountTokenMin,
791         uint amountETHMin,
792         address to,
793         uint deadline
794     ) external returns (uint amountToken, uint amountETH);
795 
796     function removeLiquidityWithPermit(
797         address tokenA,
798         address tokenB,
799         uint liquidity,
800         uint amountAMin,
801         uint amountBMin,
802         address to,
803         uint deadline,
804         bool approveMax, uint8 v, bytes32 r, bytes32 s
805     ) external returns (uint amountA, uint amountB);
806 
807     function removeLiquidityETHWithPermit(
808         address token,
809         uint liquidity,
810         uint amountTokenMin,
811         uint amountETHMin,
812         address to,
813         uint deadline,
814         bool approveMax, uint8 v, bytes32 r, bytes32 s
815     ) external returns (uint amountToken, uint amountETH);
816 
817     function swapExactTokensForTokens(
818         uint amountIn,
819         uint amountOutMin,
820         address[] calldata path,
821         address to,
822         uint deadline
823     ) external returns (uint[] memory amounts);
824 
825     function swapTokensForExactTokens(
826         uint amountOut,
827         uint amountInMax,
828         address[] calldata path,
829         address to,
830         uint deadline
831     ) external returns (uint[] memory amounts);
832 
833     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
834     external
835     payable
836     returns (uint[] memory amounts);
837 
838     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
839     external
840     returns (uint[] memory amounts);
841 
842     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
843     external
844     returns (uint[] memory amounts);
845 
846     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
847     external
848     payable
849     returns (uint[] memory amounts);
850 
851     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
852 
853     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
854 
855     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
856 
857     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
858 
859     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
860 }
861 
862 
863 interface IUniswapV2Router02 is IUniswapV2Router01 {
864     function removeLiquidityETHSupportingFeeOnTransferTokens(
865         address token,
866         uint liquidity,
867         uint amountTokenMin,
868         uint amountETHMin,
869         address to,
870         uint deadline
871     ) external returns (uint amountETH);
872 
873     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
874         address token,
875         uint liquidity,
876         uint amountTokenMin,
877         uint amountETHMin,
878         address to,
879         uint deadline,
880         bool approveMax, uint8 v, bytes32 r, bytes32 s
881     ) external returns (uint amountETH);
882 
883     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
884         uint amountIn,
885         uint amountOutMin,
886         address[] calldata path,
887         address to,
888         uint deadline
889     ) external;
890 
891     function swapExactETHForTokensSupportingFeeOnTransferTokens(
892         uint amountOutMin,
893         address[] calldata path,
894         address to,
895         uint deadline
896     ) external payable;
897 
898     function swapExactTokensForETHSupportingFeeOnTransferTokens(
899         uint amountIn,
900         uint amountOutMin,
901         address[] calldata path,
902         address to,
903         uint deadline
904     ) external;
905 
906     function swapExactTokensForBNBSupportingFeeOnTransferTokens(
907         uint amountIn,
908         uint amountOutMin,
909         address[] calldata path,
910         address to,
911         uint deadline
912     ) external;
913 
914     function swapExactTokensForAVAXSupportingFeeOnTransferTokens(
915         uint amountIn,
916         uint amountOutMin,
917         address[] calldata path,
918         address to,
919         uint deadline
920     ) external;
921 
922     function swapExactTokensForHTSupportingFeeOnTransferTokens(
923         uint amountIn,
924         uint amountOutMin,
925         address[] calldata path,
926         address to,
927         uint deadline
928     ) external;
929 
930 }
931 
932 contract MADARA is Context, IERC20, Ownable {
933     using SafeMath for uint256;
934     using Address for address;
935     address private dead = 0x000000000000000000000000000000000000dEaD;
936     uint256 public maxLiqFee = 10;
937     uint256 public maxTaxFee = 10; 
938     uint256 public maxDevFee = 10;
939     uint256 public minMxTxPercentage = 50;
940     uint256 public maxSellTaxFee = 20;
941     uint256 public prevLiqFee;
942     uint256 public prevTaxFee;
943     uint256 public prevDevFee;
944     uint256 public prevSellFee;
945     
946     mapping (address => uint256) private _rOwned;
947     mapping (address => uint256) private _tOwned;
948     mapping (address => mapping (address => uint256)) private _allowances;
949     mapping (address => bool) private _isExcludedFromFee;
950     mapping (address => bool) private _isExcluded;
951     mapping (address => bool) private _isdevWallet;
952     
953     address[] private _excluded;
954     address public _devWalletAddress;     // team wallet here
955     address public router;
956     address public basePair;
957     uint256 private constant MAX = ~uint256(0);
958     uint256 private _tTotal;
959     uint256 private _rTotal;
960     uint256 private _tFeeTotal;
961     bool public mintedByDxsale = true;
962     string private _name;
963     string private _symbol;
964     uint8 private _decimals;
965     
966     uint256 public _taxFee;
967     uint256 private _previousTaxFee;
968     
969     uint256 public _liquidityFee;
970     uint256 private _previousLiquidityFee;
971     
972     uint256 public _devFee;
973     uint256 private _previousDevFee = _devFee;
974 
975     uint256 public _sellTaxFee;
976     uint256 private _previousSellFee;
977 
978     IUniswapV2Router02 public immutable uniswapV2Router;
979     address public immutable uniswapV2Pair;
980     
981     bool public inSwapAndLiquify;
982     bool public swapAndLiquifyEnabled;
983     
984     uint256 public _maxTxAmount;
985     uint256 public numTokensSellToAddToLiquidity;
986     
987     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
988     event SwapAndLiquifyEnabledUpdated(bool enabled);
989     event SwapAndLiquify(
990         uint256 tokensSwapped,
991         uint256 ethReceived,
992         uint256 tokensIntoLiqudity
993     );
994     
995     modifier lockTheSwap {
996         inSwapAndLiquify = true;
997         _;
998         inSwapAndLiquify = false;
999     }
1000     
1001     constructor () {
1002         _name = "MADARA";
1003         _symbol = "MAD";
1004         _decimals = 18;
1005         _tTotal = 1000000000000000000000000000;
1006         _rTotal = (MAX - (MAX % _tTotal));
1007         router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
1008         basePair = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;    
1009         _rOwned[_msgSender()] = _rTotal;
1010         
1011         maxTaxFee = 10;        
1012         maxLiqFee = 10;
1013         maxDevFee = 10;
1014         minMxTxPercentage = 50;
1015         maxSellTaxFee = 20; 
1016         _taxFee = 0;
1017         _previousTaxFee = _taxFee;     
1018         _liquidityFee = 0;
1019         _previousLiquidityFee = _liquidityFee;
1020         _devFee = 4;
1021         _previousDevFee = _devFee;
1022         _sellTaxFee = 0;  
1023         _previousSellFee = _sellTaxFee;      
1024         _devWalletAddress = 0x34A91e6fD78ABf93f10c370c184E1be4970933d3;
1025 
1026         _maxTxAmount = _tTotal;
1027         numTokensSellToAddToLiquidity = _tTotal.mul(1).div(1000);
1028 
1029         
1030         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
1031          // Create a uniswap pair for this new token
1032         uniswapV2Pair = UniSwapFactory(_uniswapV2Router.factory())
1033             .createPair(address(this), basePair);
1034 
1035         // set the rest of the contract variables
1036         uniswapV2Router = _uniswapV2Router;
1037         
1038         //exclude owner and this contract from fee
1039         _isExcludedFromFee[owner()] = true;
1040         _isExcludedFromFee[address(this)] = true;
1041         _isExcludedFromFee[_devWalletAddress] = true;
1042     
1043         //set wallet provided to true
1044         _isdevWallet[_devWalletAddress] = true;
1045         
1046         emit Transfer(address(0), _msgSender(), _tTotal);
1047     }
1048 
1049     function getWrapAddr() public view returns (address){
1050 
1051         return basePair;
1052 
1053     }
1054 
1055     function name() public view returns (string memory) {
1056         return _name;
1057     }
1058 
1059     function symbol() public view returns (string memory) {
1060         return _symbol;
1061     }
1062 
1063     function decimals() public view returns (uint8) {
1064         return _decimals;
1065     }
1066 
1067     function totalSupply() public view override returns (uint256) {
1068         return _tTotal;
1069     }
1070 
1071     function balanceOf(address account) public view override returns (uint256) {
1072         if (_isExcluded[account]) return _tOwned[account];
1073         return tokenFromReflection(_rOwned[account]);
1074     }
1075 
1076     function transfer(address recipient, uint256 amount) public override returns (bool) {
1077         _transfer(_msgSender(), recipient, amount);
1078         return true;
1079     }
1080 
1081     function allowance(address owner, address spender) public view override returns (uint256) {
1082         return _allowances[owner][spender];
1083     }
1084 
1085     function approve(address spender, uint256 amount) public override returns (bool) {
1086         _approve(_msgSender(), spender, amount);
1087         return true;
1088     }
1089 
1090     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
1091         _transfer(sender, recipient, amount);
1092         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
1093         return true;
1094     }
1095 
1096     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1097         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
1098         return true;
1099     }
1100 
1101     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1102         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
1103         return true;
1104     }
1105 
1106     function isExcludedFromReward(address account) public view returns (bool) {
1107         return _isExcluded[account];
1108     }
1109 
1110     function totalFees() public view returns (uint256) {
1111         return _tFeeTotal;
1112     }
1113 
1114     function deliver(uint256 tAmount) public {
1115         address sender = _msgSender();
1116         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
1117         (uint256 rAmount,,,,,,) = _getValues(tAmount);
1118         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1119         _rTotal = _rTotal.sub(rAmount);
1120         _tFeeTotal = _tFeeTotal.add(tAmount);
1121     }
1122 
1123     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
1124         require(tAmount <= _tTotal, "Amount must be less than supply");
1125         if (!deductTransferFee) {
1126             (uint256 rAmount,,,,,,) = _getValues(tAmount);
1127             return rAmount;
1128         } else {
1129             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
1130             return rTransferAmount;
1131         }
1132     }
1133 
1134     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
1135         require(rAmount <= _rTotal, "Amount must be less than total reflections");
1136         uint256 currentRate =  _getRate();
1137         return rAmount.div(currentRate);
1138     }
1139     
1140     function excludeFromFee(address account) public onlyOwner {
1141         require(!_isExcludedFromFee[account], "Account is already excluded");
1142         _isExcludedFromFee[account] = true;
1143     }
1144     
1145     function includeInFee(address account) public onlyOwner {
1146         require(_isExcludedFromFee[account], "Account is already included");
1147         _isExcludedFromFee[account] = false;
1148     }
1149     
1150     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
1151          require(taxFee >= 0 && taxFee <=maxTaxFee,"taxFee out of range");
1152         _taxFee = taxFee;
1153     }
1154     
1155     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
1156          require(liquidityFee >= 0 && liquidityFee <=maxLiqFee,"liquidityFee out of range");
1157         _liquidityFee = liquidityFee;
1158     }
1159     
1160     function setDevFeePercent(uint256 devFee) external onlyOwner() {
1161         require(devFee >= 0 && devFee <=maxDevFee,"teamFee out of range");
1162         _devFee = devFee;
1163     }      
1164 
1165     function setSellTaxFeePercent(uint256 sellTaxFee) external onlyOwner() {
1166          require(sellTaxFee >= 0 && sellTaxFee <=maxSellTaxFee,"taxFee out of range");
1167         _sellTaxFee = sellTaxFee;
1168     }
1169    
1170     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
1171         require(maxTxPercent >= minMxTxPercentage && maxTxPercent <=100,"maxTxPercent out of range");
1172         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
1173             10**2
1174         );
1175     }
1176         
1177     function setDevWalletAddress(address _addr) public onlyOwner {
1178         require(!_isdevWallet[_addr], "Wallet address already set");
1179         if (!_isExcludedFromFee[_addr]) {
1180             excludeFromFee(_addr);
1181         }
1182         _isdevWallet[_addr] = true;
1183         _devWalletAddress = _addr;
1184     }
1185 
1186     function replaceDevWalletAddress(address _addr, address _newAddr) public onlyOwner {
1187         require(_isdevWallet[_addr], "Wallet address not set previously");
1188         if (_isExcludedFromFee[_addr]) {
1189             includeInFee(_addr);
1190         }
1191         _isdevWallet[_addr] = false;
1192         if (_devWalletAddress == _addr){
1193             setDevWalletAddress(_newAddr);
1194         }
1195     }
1196 
1197     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1198         swapAndLiquifyEnabled = _enabled;
1199         emit SwapAndLiquifyEnabledUpdated(_enabled);
1200     }
1201     
1202      //to recieve ETH from uniswapV2Router when swaping
1203     receive() external payable {}
1204 
1205     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
1206         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tDev) = _getTValues(tAmount);
1207         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, tDev, _getRate());
1208         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity, tDev);
1209     }
1210 
1211     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
1212         uint256 tFee = calculateTaxFee(tAmount);
1213         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1214         uint256 tDev = calculateDevFee(tAmount);
1215         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity).sub(tDev);
1216         return (tTransferAmount, tFee, tLiquidity, tDev);
1217     }
1218 
1219     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 tDev, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1220         uint256 rAmount = tAmount.mul(currentRate);
1221         uint256 rFee = tFee.mul(currentRate);
1222         uint256 rLiquidity = tLiquidity.mul(currentRate);
1223         uint256 rDev = tDev.mul(currentRate);
1224         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity).sub(rDev);
1225         return (rAmount, rTransferAmount, rFee);
1226     }
1227 
1228     function _getRate() private view returns(uint256) {
1229         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1230         return rSupply.div(tSupply);
1231     }
1232 
1233     function _getCurrentSupply() private view returns(uint256, uint256) {
1234         uint256 rSupply = _rTotal;
1235         uint256 tSupply = _tTotal;      
1236         for (uint256 i = 0; i < _excluded.length; i++) {
1237             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1238             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1239             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1240         }
1241         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1242         return (rSupply, tSupply);
1243     }
1244     
1245     function _takeLiquidity(uint256 tLiquidity) private {
1246         uint256 currentRate =  _getRate();
1247         uint256 rLiquidity = tLiquidity.mul(currentRate);
1248         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1249         if(_isExcluded[address(this)])
1250             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1251     }
1252     
1253     function _takeDev(uint256 tDev) private {
1254         uint256 currentRate = _getRate();
1255         uint256 rDev = tDev.mul(currentRate);
1256         _rOwned[_devWalletAddress] = _rOwned[_devWalletAddress].add(rDev);
1257         if(_isExcluded[_devWalletAddress])
1258             _tOwned[_devWalletAddress] = _tOwned[_devWalletAddress].add(tDev);
1259     }    
1260     
1261     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1262             return _amount.mul(_taxFee).div(
1263                 10**2
1264             );
1265     }
1266 
1267     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1268         return _amount.mul(_liquidityFee).div(
1269             10**2
1270         );
1271     }
1272     
1273     function calculateDevFee(uint256 _amount) private view returns (uint256) {
1274         return _amount.mul(_devFee).div(
1275             10**2
1276         );
1277     }    
1278     
1279     function removeAllFee() private {
1280         if(_taxFee == 0 && _liquidityFee == 0 && _devFee == 0) return;
1281         
1282         _previousTaxFee = _taxFee;
1283         _previousLiquidityFee = _liquidityFee;
1284         _previousDevFee = _devFee;
1285         _previousSellFee = _sellTaxFee;
1286         
1287         _taxFee = 0;
1288         _liquidityFee = 0;
1289         _devFee = 0;
1290         _sellTaxFee = 0;
1291     }
1292     
1293     function restoreAllFee() private {
1294         _taxFee = _previousTaxFee;
1295         _liquidityFee = _previousLiquidityFee;
1296         _devFee = _previousDevFee;
1297         _sellTaxFee = _previousSellFee;
1298     }
1299     
1300     function isExcludedFromFee(address account) public view returns(bool) {
1301         return _isExcludedFromFee[account];
1302     }
1303 
1304     function _approve(address owner, address spender, uint256 amount) private {
1305         require(owner != address(0), "ERC20: approve from the zero address");
1306         require(spender != address(0), "ERC20: approve to the zero address");
1307 
1308         _allowances[owner][spender] = amount;
1309         emit Approval(owner, spender, amount);
1310     }
1311 
1312     function _transfer(
1313         address from,
1314         address to,
1315         uint256 amount
1316     ) private {
1317         require(from != address(0), "ERC20: transfer from the zero address");
1318         require(to != address(0), "ERC20: transfer to the zero address");
1319         require(amount > 0, "Transfer amount must be greater than zero");
1320 
1321         //Special case when sell is uniswapV2Pair
1322         if (to == address(uniswapV2Pair)){
1323             _taxFee = _sellTaxFee;
1324         }
1325 
1326         if(from != owner() && to != owner())
1327             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1328 
1329         // is the token balance of this contract address over the min number of
1330         // tokens that we need to initiate a swap + liquidity lock?
1331         // also, don't get caught in a circular liquidity event.
1332         // also, don't swap & liquify if sender is uniswap pair.
1333         uint256 contractTokenBalance = balanceOf(address(this));
1334         
1335         if(contractTokenBalance >= _maxTxAmount)
1336         {
1337             contractTokenBalance = _maxTxAmount;
1338         }
1339         
1340         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1341         if (
1342             overMinTokenBalance &&
1343             !inSwapAndLiquify &&
1344             from != uniswapV2Pair &&
1345             swapAndLiquifyEnabled
1346         ) {
1347             contractTokenBalance = numTokensSellToAddToLiquidity;
1348             //add liquidity
1349             swapAndLiquify(contractTokenBalance);
1350         }
1351         
1352         //indicates if fee should be deducted from transfer
1353         bool takeFee = true;
1354         
1355         //if any account belongs to _isExcludedFromFee account then remove the fee
1356         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1357             takeFee = false;
1358         }
1359         
1360         //transfer amount, it will take tax, burn, liquidity fee
1361         _tokenTransfer(from,to,amount,takeFee);
1362 
1363         //reset tax fees
1364         restoreAllFee();
1365     }
1366 
1367     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1368         // split the contract balance into halves
1369         uint256 half = contractTokenBalance.div(2);
1370         uint256 otherHalf = contractTokenBalance.sub(half);
1371 
1372         // capture the contract's current ETH balance.
1373         // this is so that we can capture exactly the amount of ETH that the
1374         // swap creates, and not make the liquidity event include any ETH that
1375         // has been manually sent to the contract
1376         uint256 initialBalance = address(this).balance;
1377 
1378         // swap tokens for ETH
1379         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1380 
1381         // how much ETH did we just swap into?
1382         uint256 newBalance = address(this).balance.sub(initialBalance);
1383 
1384         // add liquidity to uniswap
1385         addLiquidity(otherHalf, newBalance);
1386         
1387         emit SwapAndLiquify(half, newBalance, otherHalf);
1388     }
1389 
1390     function swapTokensForEth(uint256 tokenAmount) private {
1391         // generate the uniswap pair path of token -> WHT
1392         address[] memory path = new address[](2);
1393         path[0] = address(this);
1394         path[1] = getWrapAddr();
1395 
1396         _approve(address(this), address(uniswapV2Router), tokenAmount);
1397 
1398         // make the swap
1399         try uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1400             tokenAmount,
1401             0, // accept any amount of ETH
1402             path,
1403             address(this),
1404             block.timestamp
1405         ) {}
1406 
1407         catch(bytes memory) {
1408 
1409             try uniswapV2Router.swapExactTokensForBNBSupportingFeeOnTransferTokens(
1410                 tokenAmount,
1411                 0, // accept any amount of ETH
1412                 path,
1413                 address(this),
1414                 block.timestamp
1415             ) {}
1416             catch(bytes memory) {
1417                 try uniswapV2Router.swapExactTokensForAVAXSupportingFeeOnTransferTokens(
1418                     tokenAmount,
1419                     0, // accept any amount of ETH
1420                     path,
1421                     address(this),
1422                     block.timestamp
1423                 ){}
1424 
1425                 catch(bytes memory) {
1426                     try uniswapV2Router.swapExactTokensForHTSupportingFeeOnTransferTokens(
1427                         tokenAmount,
1428                         0, // accept any amount of ETH
1429                         path,
1430                         address(this),
1431                         block.timestamp
1432                     ){}
1433                     catch(bytes memory) {
1434 
1435                         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1436                             tokenAmount,
1437                             0, // accept any amount of ETH
1438                             path,
1439                             address(this),
1440                             block.timestamp
1441                         );
1442 
1443 
1444                     }
1445 
1446 
1447                 }
1448 
1449             }
1450 
1451         }
1452     }
1453 
1454     function addLiquidity(uint256 tokenAmount, uint256 ETHAmount) private {
1455         // approve token transfer to cover all possible scenarios
1456         _approve(address(this), address(uniswapV2Router), tokenAmount);
1457 
1458         // add the liquidity
1459 
1460         try uniswapV2Router.addLiquidityETH{value : ETHAmount}(
1461             address(this),
1462             tokenAmount,
1463             0, // slippage is unavoidable
1464             0, // slippage is unavoidable
1465             dead,
1466             block.timestamp
1467         ) {
1468 
1469         }
1470 
1471         catch (bytes memory) {
1472             try uniswapV2Router.addLiquidityBNB{value : ETHAmount}(
1473                 address(this),
1474                 tokenAmount,
1475                 0, // slippage is unavoidable
1476                 0, // slippage is unavoidable
1477                 dead,
1478                 block.timestamp
1479             ) {
1480 
1481             }
1482             catch (bytes memory) {
1483                 try uniswapV2Router.addLiquidityAVAX{value : ETHAmount}(
1484                     address(this),
1485                     tokenAmount,
1486                     0, // slippage is unavoidable
1487                     0, // slippage is unavoidable
1488                     dead,
1489                     block.timestamp
1490                 ) {
1491 
1492                 }
1493                 catch (bytes memory) {
1494                     try uniswapV2Router.addLiquidityHT{value : ETHAmount}(
1495                         address(this),
1496                         tokenAmount,
1497                         0, // slippage is unavoidable
1498                         0, // slippage is unavoidable
1499                         dead,
1500                         block.timestamp
1501                     ) {
1502 
1503                     }
1504                     catch (bytes memory) {
1505 
1506                         uniswapV2Router.addLiquidityETH{value : ETHAmount}(
1507                             address(this),
1508                             tokenAmount,
1509                             0, // slippage is unavoidable
1510                             0, // slippage is unavoidable
1511                             dead,
1512                             block.timestamp
1513                         );
1514                     }
1515 
1516                 }
1517 
1518             }
1519         }
1520 
1521     }
1522 
1523     //this method is responsible for taking all fee, if takeFee is true
1524     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1525         if(!takeFee)
1526             removeAllFee();
1527         
1528         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1529             _transferFromExcluded(sender, recipient, amount);
1530         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1531             _transferToExcluded(sender, recipient, amount);
1532         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1533             _transferStandard(sender, recipient, amount);
1534         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1535             _transferBothExcluded(sender, recipient, amount);
1536         } else {
1537             _transferStandard(sender, recipient, amount);
1538         } 
1539         
1540         //if(!takeFee)
1541         //    restoreAllFee();
1542     }
1543 
1544     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1545         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tDev) = _getValues(tAmount);
1546         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1547         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1548         _takeLiquidity(tLiquidity);
1549         _takeDev(tDev);
1550         _reflectFee(rFee, tFee);
1551         emit Transfer(sender, recipient, tTransferAmount);
1552     }
1553 
1554     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1555         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tDev) = _getValues(tAmount);
1556         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1557         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1558         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1559         _takeLiquidity(tLiquidity);
1560         _takeDev(tDev);
1561         _reflectFee(rFee, tFee);
1562         emit Transfer(sender, recipient, tTransferAmount);
1563     }
1564 
1565     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1566         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tDev) = _getValues(tAmount);
1567         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1568         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1569         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1570         _takeLiquidity(tLiquidity);
1571         _takeDev(tDev);
1572         _reflectFee(rFee, tFee);
1573         emit Transfer(sender, recipient, tTransferAmount);
1574     }
1575 
1576     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1577         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tDev) = _getValues(tAmount);
1578         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1579         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1580         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1581         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
1582         _takeLiquidity(tLiquidity);
1583         _takeDev(tDev);        
1584         _reflectFee(rFee, tFee);
1585         emit Transfer(sender, recipient, tTransferAmount);
1586     }
1587 
1588     function _reflectFee(uint256 rFee, uint256 tFee) private {
1589         _rTotal = _rTotal.sub(rFee);
1590         _tFeeTotal = _tFeeTotal.add(tFee);
1591     }
1592 
1593     function disableFees() public onlyOwner {
1594         prevLiqFee = _liquidityFee;
1595         prevTaxFee = _taxFee;
1596         prevDevFee = _devFee;
1597         prevSellFee = _sellTaxFee;
1598         _maxTxAmount = _tTotal;
1599         _liquidityFee = 0;
1600         _taxFee = 0;
1601         _devFee = 0;
1602         _sellTaxFee = 0;
1603         swapAndLiquifyEnabled = false;
1604         
1605     }
1606     
1607     function enableFees() public onlyOwner {
1608         
1609         _maxTxAmount = _tTotal;
1610         _liquidityFee = prevLiqFee;
1611         _taxFee = prevTaxFee;
1612         _devFee = prevDevFee;
1613         _sellTaxFee = prevSellFee;
1614         swapAndLiquifyEnabled = true;
1615         
1616     }
1617 
1618 }