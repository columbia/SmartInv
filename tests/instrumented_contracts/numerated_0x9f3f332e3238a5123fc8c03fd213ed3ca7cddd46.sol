1 /**
2  *Submitted for verification at Etherscan.io on 2021-06-02
3 */
4 
5 /**
6 
7 ██╗  ██╗ ██████╗ ██╗███╗   ██╗██╗   ██╗    ██╗███╗   ██╗██╗   ██╗
8 ██║ ██╔╝██╔═══██╗██║████╗  ██║██║   ██║    ██║████╗  ██║██║   ██║
9 █████╔╝ ██║   ██║██║██╔██╗ ██║██║   ██║    ██║██╔██╗ ██║██║   ██║
10 ██╔═██╗ ██║   ██║██║██║╚██╗██║██║   ██║    ██║██║╚██╗██║██║   ██║
11 ██║  ██╗╚██████╔╝██║██║ ╚████║╚██████╔╝    ██║██║ ╚████║╚██████╔╝
12 ╚═╝  ╚═╝ ╚═════╝ ╚═╝╚═╝  ╚═══╝ ╚═════╝     ╚═╝╚═╝  ╚═══╝ ╚═════╝ 
13                                                              
14 */
15 
16 // SPDX-License-Identifier: MIT
17 
18 /**
19 
20    #Koinu Inu
21     Name: Koinu Inu
22     Symbol: Koinu
23     Decimals: 18
24     Total Supply: 1,000,000,000,000
25     3% auto redistribution to holders & 3% Auto liquidity
26 
27     3% fee auto add to the liquidity pool to locked forever when selling
28     3% fee auto distribute to all holders
29    
30  */
31 
32 pragma solidity ^0.8.3;
33 
34 /**
35  * @dev Interface of the ERC20 standard as defined in the EIP.
36  */
37 interface IERC20 {
38     /**
39      * @dev Returns the amount of tokens in existence.
40      */
41     function totalSupply() external view returns (uint256);
42 
43     /**
44      * @dev Returns the amount of tokens owned by `account`.
45      */
46     function balanceOf(address account) external view returns (uint256);
47 
48     /**
49      * @dev Moves `amount` tokens from the caller's account to `recipient`.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * Emits a {Transfer} event.
54      */
55     function transfer(address recipient, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Returns the remaining number of tokens that `spender` will be
59      * allowed to spend on behalf of `owner` through {transferFrom}. This is
60      * zero by default.
61      *
62      * This value changes when {approve} or {transferFrom} are called.
63      */
64     function allowance(address owner, address spender) external view returns (uint256);
65 
66     /**
67      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * IMPORTANT: Beware that changing an allowance with this method brings the risk
72      * that someone may use both the old and the new allowance by unfortunate
73      * transaction ordering. One possible solution to mitigate this race
74      * condition is to first reduce the spender's allowance to 0 and set the
75      * desired value afterwards:
76      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
77      *
78      * Emits an {Approval} event.
79      */
80     function approve(address spender, uint256 amount) external returns (bool);
81 
82     /**
83      * @dev Moves `amount` tokens from `sender` to `recipient` using the
84      * allowance mechanism. `amount` is then deducted from the caller's
85      * allowance.
86      *
87      * Returns a boolean value indicating whether the operation succeeded.
88      *
89      * Emits a {Transfer} event.
90      */
91     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
92 
93     /**
94      * @dev Emitted when `value` tokens are moved from one account (`from`) to
95      * another (`to`).
96      *
97      * Note that `value` may be zero.
98      */
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 
101     /**
102      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
103      * a call to {approve}. `value` is the new allowance.
104      */
105     event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 // CAUTION
109 // This version of SafeMath should only be used with Solidity 0.8 or later,
110 // because it relies on the compiler's built in overflow checks.
111 
112 /**
113  * @dev Wrappers over Solidity's arithmetic operations.
114  *
115  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
116  * now has built in overflow checking.
117  */
118 library SafeMath {
119     /**
120      * @dev Returns the addition of two unsigned integers, with an overflow flag.
121      *
122      * _Available since v3.4._
123      */
124     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
125         unchecked {
126             uint256 c = a + b;
127             if (c < a) return (false, 0);
128             return (true, c);
129         }
130     }
131 
132     /**
133      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
134      *
135      * _Available since v3.4._
136      */
137     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
138         unchecked {
139             if (b > a) return (false, 0);
140             return (true, a - b);
141         }
142     }
143 
144     /**
145      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
146      *
147      * _Available since v3.4._
148      */
149     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
150         unchecked {
151             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
152             // benefit is lost if 'b' is also tested.
153             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
154             if (a == 0) return (true, 0);
155             uint256 c = a * b;
156             if (c / a != b) return (false, 0);
157             return (true, c);
158         }
159     }
160 
161     /**
162      * @dev Returns the division of two unsigned integers, with a division by zero flag.
163      *
164      * _Available since v3.4._
165      */
166     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
167         unchecked {
168             if (b == 0) return (false, 0);
169             return (true, a / b);
170         }
171     }
172 
173     /**
174      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
175      *
176      * _Available since v3.4._
177      */
178     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
179         unchecked {
180             if (b == 0) return (false, 0);
181             return (true, a % b);
182         }
183     }
184 
185     /**
186      * @dev Returns the addition of two unsigned integers, reverting on
187      * overflow.
188      *
189      * Counterpart to Solidity's `+` operator.
190      *
191      * Requirements:
192      *
193      * - Addition cannot overflow.
194      */
195     function add(uint256 a, uint256 b) internal pure returns (uint256) {
196         return a + b;
197     }
198 
199     /**
200      * @dev Returns the subtraction of two unsigned integers, reverting on
201      * overflow (when the result is negative).
202      *
203      * Counterpart to Solidity's `-` operator.
204      *
205      * Requirements:
206      *
207      * - Subtraction cannot overflow.
208      */
209     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
210         return a - b;
211     }
212 
213     /**
214      * @dev Returns the multiplication of two unsigned integers, reverting on
215      * overflow.
216      *
217      * Counterpart to Solidity's `*` operator.
218      *
219      * Requirements:
220      *
221      * - Multiplication cannot overflow.
222      */
223     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
224         return a * b;
225     }
226 
227     /**
228      * @dev Returns the integer division of two unsigned integers, reverting on
229      * division by zero. The result is rounded towards zero.
230      *
231      * Counterpart to Solidity's `/` operator.
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function div(uint256 a, uint256 b) internal pure returns (uint256) {
238         return a / b;
239     }
240 
241     /**
242      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
243      * reverting when dividing by zero.
244      *
245      * Counterpart to Solidity's `%` operator. This function uses a `revert`
246      * opcode (which leaves remaining gas untouched) while Solidity uses an
247      * invalid opcode to revert (consuming all remaining gas).
248      *
249      * Requirements:
250      *
251      * - The divisor cannot be zero.
252      */
253     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
254         return a % b;
255     }
256 
257     /**
258      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
259      * overflow (when the result is negative).
260      *
261      * CAUTION: This function is deprecated because it requires allocating memory for the error
262      * message unnecessarily. For custom revert reasons use {trySub}.
263      *
264      * Counterpart to Solidity's `-` operator.
265      *
266      * Requirements:
267      *
268      * - Subtraction cannot overflow.
269      */
270     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
271         unchecked {
272             require(b <= a, errorMessage);
273             return a - b;
274         }
275     }
276 
277     /**
278      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
279      * division by zero. The result is rounded towards zero.
280      *
281      * Counterpart to Solidity's `%` operator. This function uses a `revert`
282      * opcode (which leaves remaining gas untouched) while Solidity uses an
283      * invalid opcode to revert (consuming all remaining gas).
284      *
285      * Counterpart to Solidity's `/` operator. Note: this function uses a
286      * `revert` opcode (which leaves remaining gas untouched) while Solidity
287      * uses an invalid opcode to revert (consuming all remaining gas).
288      *
289      * Requirements:
290      *
291      * - The divisor cannot be zero.
292      */
293     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
294         unchecked {
295             require(b > 0, errorMessage);
296             return a / b;
297         }
298     }
299 
300     /**
301      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
302      * reverting with custom message when dividing by zero.
303      *
304      * CAUTION: This function is deprecated because it requires allocating memory for the error
305      * message unnecessarily. For custom revert reasons use {tryMod}.
306      *
307      * Counterpart to Solidity's `%` operator. This function uses a `revert`
308      * opcode (which leaves remaining gas untouched) while Solidity uses an
309      * invalid opcode to revert (consuming all remaining gas).
310      *
311      * Requirements:
312      *
313      * - The divisor cannot be zero.
314      */
315     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
316         unchecked {
317             require(b > 0, errorMessage);
318             return a % b;
319         }
320     }
321 }
322 
323 /*
324  * @dev Provides information about the current execution context, including the
325  * sender of the transaction and its data. While these are generally available
326  * via msg.sender and msg.data, they should not be accessed in such a direct
327  * manner, since when dealing with meta-transactions the account sending and
328  * paying for execution may not be the actual sender (as far as an application
329  * is concerned).
330  *
331  * This contract is only required for intermediate, library-like contracts.
332  */
333 abstract contract Context {
334     function _msgSender() internal view virtual returns (address) {
335         return msg.sender;
336     }
337 
338     function _msgData() internal view virtual returns (bytes calldata) {
339         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
340         return msg.data;
341     }
342 }
343 
344 /**
345  * @dev Collection of functions related to the address type
346  */
347 library Address {
348     /**
349      * @dev Returns true if `account` is a contract.
350      *
351      * [IMPORTANT]
352      * ====
353      * It is unsafe to assume that an address for which this function returns
354      * false is an externally-owned account (EOA) and not a contract.
355      *
356      * Among others, `isContract` will return false for the following
357      * types of addresses:
358      *
359      *  - an externally-owned account
360      *  - a contract in construction
361      *  - an address where a contract will be created
362      *  - an address where a contract lived, but was destroyed
363      * ====
364      */
365     function isContract(address account) internal view returns (bool) {
366         // This method relies on extcodesize, which returns 0 for contracts in
367         // construction, since the code is only stored at the end of the
368         // constructor execution.
369 
370         uint256 size;
371         // solhint-disable-next-line no-inline-assembly
372         assembly { size := extcodesize(account) }
373         return size > 0;
374     }
375 
376     /**
377      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
378      * `recipient`, forwarding all available gas and reverting on errors.
379      *
380      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
381      * of certain opcodes, possibly making contracts go over the 2300 gas limit
382      * imposed by `transfer`, making them unable to receive funds via
383      * `transfer`. {sendValue} removes this limitation.
384      *
385      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
386      *
387      * IMPORTANT: because control is transferred to `recipient`, care must be
388      * taken to not create reentrancy vulnerabilities. Consider using
389      * {ReentrancyGuard} or the
390      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
391      */
392     function sendValue(address payable recipient, uint256 amount) internal {
393         require(address(this).balance >= amount, "Address: insufficient balance");
394 
395         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
396         (bool success, ) = recipient.call{ value: amount }("");
397         require(success, "Address: unable to send value, recipient may have reverted");
398     }
399 
400     /**
401      * @dev Performs a Solidity function call using a low level `call`. A
402      * plain`call` is an unsafe replacement for a function call: use this
403      * function instead.
404      *
405      * If `target` reverts with a revert reason, it is bubbled up by this
406      * function (like regular Solidity function calls).
407      *
408      * Returns the raw returned data. To convert to the expected return value,
409      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
410      *
411      * Requirements:
412      *
413      * - `target` must be a contract.
414      * - calling `target` with `data` must not revert.
415      *
416      * _Available since v3.1._
417      */
418     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
419       return functionCall(target, data, "Address: low-level call failed");
420     }
421 
422     /**
423      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
424      * `errorMessage` as a fallback revert reason when `target` reverts.
425      *
426      * _Available since v3.1._
427      */
428     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
429         return functionCallWithValue(target, data, 0, errorMessage);
430     }
431 
432     /**
433      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
434      * but also transferring `value` wei to `target`.
435      *
436      * Requirements:
437      *
438      * - the calling contract must have an ETH balance of at least `value`.
439      * - the called Solidity function must be `payable`.
440      *
441      * _Available since v3.1._
442      */
443     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
444         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
449      * with `errorMessage` as a fallback revert reason when `target` reverts.
450      *
451      * _Available since v3.1._
452      */
453     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
454         require(address(this).balance >= value, "Address: insufficient balance for call");
455         require(isContract(target), "Address: call to non-contract");
456 
457         // solhint-disable-next-line avoid-low-level-calls
458         (bool success, bytes memory returndata) = target.call{ value: value }(data);
459         return _verifyCallResult(success, returndata, errorMessage);
460     }
461 
462     /**
463      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
464      * but performing a static call.
465      *
466      * _Available since v3.3._
467      */
468     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
469         return functionStaticCall(target, data, "Address: low-level static call failed");
470     }
471 
472     /**
473      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
474      * but performing a static call.
475      *
476      * _Available since v3.3._
477      */
478     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
479         require(isContract(target), "Address: static call to non-contract");
480 
481         // solhint-disable-next-line avoid-low-level-calls
482         (bool success, bytes memory returndata) = target.staticcall(data);
483         return _verifyCallResult(success, returndata, errorMessage);
484     }
485 
486     /**
487      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
488      * but performing a delegate call.
489      *
490      * _Available since v3.4._
491      */
492     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
493         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
494     }
495 
496     /**
497      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
498      * but performing a delegate call.
499      *
500      * _Available since v3.4._
501      */
502     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
503         require(isContract(target), "Address: delegate call to non-contract");
504 
505         // solhint-disable-next-line avoid-low-level-calls
506         (bool success, bytes memory returndata) = target.delegatecall(data);
507         return _verifyCallResult(success, returndata, errorMessage);
508     }
509 
510     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
511         if (success) {
512             return returndata;
513         } else {
514             // Look for revert reason and bubble it up if present
515             if (returndata.length > 0) {
516                 // The easiest way to bubble the revert reason is using memory via assembly
517 
518                 // solhint-disable-next-line no-inline-assembly
519                 assembly {
520                     let returndata_size := mload(returndata)
521                     revert(add(32, returndata), returndata_size)
522                 }
523             } else {
524                 revert(errorMessage);
525             }
526         }
527     }
528 }
529 
530 /**
531  * @dev Contract module which provides a basic access control mechanism, where
532  * there is an account (an owner) that can be granted exclusive access to
533  * specific functions.
534  *
535  * By default, the owner account will be the one that deploys the contract. This
536  * can later be changed with {transferOwnership}.
537  *
538  * This module is used through inheritance. It will make available the modifier
539  * `onlyOwner`, which can be applied to your functions to restrict their use to
540  * the owner.
541  */
542 abstract contract Ownable is Context {
543     address private _owner;
544 
545     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
546 
547     /**
548      * @dev Initializes the contract setting the deployer as the initial owner.
549      */
550     constructor () {
551         _owner = _msgSender();
552         emit OwnershipTransferred(address(0), _owner);
553     }
554 
555     /**
556      * @dev Returns the address of the current owner.
557      */
558     function owner() public view virtual returns (address) {
559         return _owner;
560     }
561 
562     /**
563      * @dev Throws if called by any account other than the owner.
564      */
565     modifier onlyOwner() {
566         require(owner() == _msgSender(), "Ownable: caller is not the owner");
567         _;
568     }
569 
570     /**
571      * @dev Leaves the contract without owner. It will not be possible to call
572      * `onlyOwner` functions anymore. Can only be called by the current owner.
573      *
574      * NOTE: Renouncing ownership will leave the contract without an owner,
575      * thereby removing any functionality that is only available to the owner.
576      */
577     function renounceOwnership() public virtual onlyOwner {
578         emit OwnershipTransferred(_owner, address(0));
579         _owner = address(0);
580     }
581 
582     /**
583      * @dev Transfers ownership of the contract to a new account (`newOwner`).
584      * Can only be called by the current owner.
585      */
586     function transferOwnership(address newOwner) public virtual onlyOwner {
587         require(newOwner != address(0), "Ownable: new owner is the zero address");
588         emit OwnershipTransferred(_owner, newOwner);
589         _owner = newOwner;
590     }
591 }
592 
593 interface IUniswapV2Factory {
594     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
595 
596     function feeTo() external view returns (address);
597     function feeToSetter() external view returns (address);
598 
599     function getPair(address tokenA, address tokenB) external view returns (address pair);
600     function allPairs(uint) external view returns (address pair);
601     function allPairsLength() external view returns (uint);
602 
603     function createPair(address tokenA, address tokenB) external returns (address pair);
604 
605     function setFeeTo(address) external;
606     function setFeeToSetter(address) external;
607 }
608 
609 interface IUniswapV2Pair {
610     event Approval(address indexed owner, address indexed spender, uint value);
611     event Transfer(address indexed from, address indexed to, uint value);
612 
613     function name() external pure returns (string memory);
614     function symbol() external pure returns (string memory);
615     function decimals() external pure returns (uint8);
616     function totalSupply() external view returns (uint);
617     function balanceOf(address owner) external view returns (uint);
618     function allowance(address owner, address spender) external view returns (uint);
619 
620     function approve(address spender, uint value) external returns (bool);
621     function transfer(address to, uint value) external returns (bool);
622     function transferFrom(address from, address to, uint value) external returns (bool);
623 
624     function DOMAIN_SEPARATOR() external view returns (bytes32);
625     function PERMIT_TYPEHASH() external pure returns (bytes32);
626     function nonces(address owner) external view returns (uint);
627 
628     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
629 
630     event Mint(address indexed sender, uint amount0, uint amount1);
631     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
632     event Swap(
633         address indexed sender,
634         uint amount0In,
635         uint amount1In,
636         uint amount0Out,
637         uint amount1Out,
638         address indexed to
639     );
640     event Sync(uint112 reserve0, uint112 reserve1);
641 
642     function MINIMUM_LIQUIDITY() external pure returns (uint);
643     function factory() external view returns (address);
644     function token0() external view returns (address);
645     function token1() external view returns (address);
646     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
647     function price0CumulativeLast() external view returns (uint);
648     function price1CumulativeLast() external view returns (uint);
649     function kLast() external view returns (uint);
650 
651     function mint(address to) external returns (uint liquidity);
652     function burn(address to) external returns (uint amount0, uint amount1);
653     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
654     function skim(address to) external;
655     function sync() external;
656 
657     function initialize(address, address) external;
658 }
659 
660 interface IUniswapV2Router01 {
661     function factory() external pure returns (address);
662     function WETH() external pure returns (address);
663 
664     function addLiquidity(
665         address tokenA,
666         address tokenB,
667         uint amountADesired,
668         uint amountBDesired,
669         uint amountAMin,
670         uint amountBMin,
671         address to,
672         uint deadline
673     ) external returns (uint amountA, uint amountB, uint liquidity);
674     function addLiquidityETH(
675         address token,
676         uint amountTokenDesired,
677         uint amountTokenMin,
678         uint amountETHMin,
679         address to,
680         uint deadline
681     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
682     function removeLiquidity(
683         address tokenA,
684         address tokenB,
685         uint liquidity,
686         uint amountAMin,
687         uint amountBMin,
688         address to,
689         uint deadline
690     ) external returns (uint amountA, uint amountB);
691     function removeLiquidityETH(
692         address token,
693         uint liquidity,
694         uint amountTokenMin,
695         uint amountETHMin,
696         address to,
697         uint deadline
698     ) external returns (uint amountToken, uint amountETH);
699     function removeLiquidityWithPermit(
700         address tokenA,
701         address tokenB,
702         uint liquidity,
703         uint amountAMin,
704         uint amountBMin,
705         address to,
706         uint deadline,
707         bool approveMax, uint8 v, bytes32 r, bytes32 s
708     ) external returns (uint amountA, uint amountB);
709     function removeLiquidityETHWithPermit(
710         address token,
711         uint liquidity,
712         uint amountTokenMin,
713         uint amountETHMin,
714         address to,
715         uint deadline,
716         bool approveMax, uint8 v, bytes32 r, bytes32 s
717     ) external returns (uint amountToken, uint amountETH);
718     function swapExactTokensForTokens(
719         uint amountIn,
720         uint amountOutMin,
721         address[] calldata path,
722         address to,
723         uint deadline
724     ) external returns (uint[] memory amounts);
725     function swapTokensForExactTokens(
726         uint amountOut,
727         uint amountInMax,
728         address[] calldata path,
729         address to,
730         uint deadline
731     ) external returns (uint[] memory amounts);
732     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
733         external
734         payable
735         returns (uint[] memory amounts);
736     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
737         external
738         returns (uint[] memory amounts);
739     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
740         external
741         returns (uint[] memory amounts);
742     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
743         external
744         payable
745         returns (uint[] memory amounts);
746 
747     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
748     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
749     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
750     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
751     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
752 }
753 
754 interface IUniswapV2Router02 is IUniswapV2Router01 {
755     function removeLiquidityETHSupportingFeeOnTransferTokens(
756         address token,
757         uint liquidity,
758         uint amountTokenMin,
759         uint amountETHMin,
760         address to,
761         uint deadline
762     ) external returns (uint amountETH);
763     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
764         address token,
765         uint liquidity,
766         uint amountTokenMin,
767         uint amountETHMin,
768         address to,
769         uint deadline,
770         bool approveMax, uint8 v, bytes32 r, bytes32 s
771     ) external returns (uint amountETH);
772 
773     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
774         uint amountIn,
775         uint amountOutMin,
776         address[] calldata path,
777         address to,
778         uint deadline
779     ) external;
780     function swapExactETHForTokensSupportingFeeOnTransferTokens(
781         uint amountOutMin,
782         address[] calldata path,
783         address to,
784         uint deadline
785     ) external payable;
786     function swapExactTokensForETHSupportingFeeOnTransferTokens(
787         uint amountIn,
788         uint amountOutMin,
789         address[] calldata path,
790         address to,
791         uint deadline
792     ) external;
793 }
794 
795 contract Koinu is Context, IERC20, Ownable {
796     using SafeMath for uint256;
797     using Address for address;
798 
799     mapping (address => uint256) private _rOwned;
800     mapping (address => uint256) private _tOwned;
801     mapping (address => mapping (address => uint256)) private _allowances;
802 
803     mapping (address => bool) private _isExcludedFromFee;
804 
805     mapping (address => bool) private _isExcluded;
806     address[] private _excluded;
807 
808    // address private _charityWalletAddress = 0x0000000000000000000000000000000000000000; // Charity address
809     address private _charityWalletAddress = 0x0000000000000000000000000000000000000000; // Burn Address
810     
811     
812    
813     uint256 private constant MAX = ~uint256(0);
814     uint256 private _tTotal = 1000000000000 * 10**18;
815     uint256 private _rTotal = (MAX - (MAX % _tTotal));
816     uint256 private _tFeeTotal;
817 
818     string private _name = "Koinu Inu";
819     string private _symbol = "Koinu";
820     uint8 private _decimals = 18;
821     
822     uint256 public _taxFee = 3;
823     uint256 private _previousTaxFee = _taxFee;
824     
825     uint256 public _charityFee = 0;
826     uint256 private _previousCharityFee = _charityFee;
827     uint256 public _liquidityFee = 3;
828     uint256 private _previousLiquidityFee = _liquidityFee;
829 
830     IUniswapV2Router02 public immutable uniswapV2Router;
831     address public immutable uniswapV2Pair;
832     
833     bool inSwapAndLiquify;
834     bool public swapAndLiquifyEnabled = true;
835     
836     uint256 public _maxTxAmount = 5000000 *  10**18;
837     uint256 private numTokensSellToAddToLiquidity = 500000 *  10**18;
838     
839     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
840     event SwapAndLiquifyEnabledUpdated(bool enabled);
841     event SwapAndLiquify(
842         uint256 tokensSwapped,
843         uint256 ethReceived,
844         uint256 tokensIntoLiqudity
845     );
846     
847     modifier lockTheSwap {
848         inSwapAndLiquify = true;
849         _;
850         inSwapAndLiquify = false;
851     }
852     
853     constructor () {
854         _rOwned[owner()] = _rTotal;
855         
856         //IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x05fF2B0DB69458A0750badebc4f9e13aDd608C7F);// BSC mainnet
857         //IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0xD99D1c33F9fC3444f8101754aBC46c52416550D1);// BSC testnet        
858         
859          //IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E);// BSC mainnet
860         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);// Ethereum mainnet for uniswap
861          // Create a uniswap pair for this new token
862         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
863             .createPair(address(this), _uniswapV2Router.WETH());
864 
865         // set the rest of the contract variables
866         uniswapV2Router = _uniswapV2Router;
867         
868         //exclude owner and this contract from fee
869         _isExcludedFromFee[owner()] = true;
870         _isExcludedFromFee[address(this)] = true;
871         
872         emit Transfer(address(0), owner(), _tTotal);
873     }
874 
875     function name() public view returns (string memory) {
876         return _name;
877     }
878 
879     function symbol() public view returns (string memory) {
880         return _symbol;
881     }
882 
883     function decimals() public view returns (uint8) {
884         return _decimals;
885     }
886 
887     function totalSupply() public view override returns (uint256) {
888         return _tTotal;
889     }
890 
891     function balanceOf(address account) public view override returns (uint256) {
892         if (_isExcluded[account]) return _tOwned[account];
893         return tokenFromReflection(_rOwned[account]);
894     }
895 
896     function transfer(address recipient, uint256 amount) public override returns (bool) {
897         _transfer(_msgSender(), recipient, amount);
898         return true;
899     }
900 
901     function allowance(address owner, address spender) public view override returns (uint256) {
902         return _allowances[owner][spender];
903     }
904 
905     function approve(address spender, uint256 amount) public override returns (bool) {
906         _approve(_msgSender(), spender, amount);
907         return true;
908     }
909 
910     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
911         _transfer(sender, recipient, amount);
912         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
913         return true;
914     }
915 
916     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
917         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
918         return true;
919     }
920 
921     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
922         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
923         return true;
924     }
925 
926     function isExcludedFromReward(address account) public view returns (bool) {
927         return _isExcluded[account];
928     }
929 
930     function totalFees() public view returns (uint256) {
931         return _tFeeTotal;
932     }
933 
934     function deliver(uint256 tAmount) public {
935         address sender = _msgSender();
936         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
937         (uint256 rAmount,,,,,,) = _getValues(tAmount);
938         _rOwned[sender] = _rOwned[sender].sub(rAmount);
939         _rTotal = _rTotal.sub(rAmount);
940         _tFeeTotal = _tFeeTotal.add(tAmount);
941     }
942 
943     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
944         require(tAmount <= _tTotal, "Amount must be less than supply");
945         if (!deductTransferFee) {
946             (uint256 rAmount,,,,,,) = _getValues(tAmount);
947             return rAmount;
948         } else {
949             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
950             return rTransferAmount;
951         }
952     }
953 
954     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
955         require(rAmount <= _rTotal, "Amount must be less than total reflections");
956         uint256 currentRate =  _getRate();
957         return rAmount.div(currentRate);
958     }
959 
960     function excludeFromReward(address account) public onlyOwner() {
961         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
962         require(!_isExcluded[account], "Account is already excluded");
963         if(_rOwned[account] > 0) {
964             _tOwned[account] = tokenFromReflection(_rOwned[account]);
965         }
966         _isExcluded[account] = true;
967         _excluded.push(account);
968     }
969 
970     function includeInReward(address account) external onlyOwner() {
971         require(_isExcluded[account], "Account is already included");
972         for (uint256 i = 0; i < _excluded.length; i++) {
973             if (_excluded[i] == account) {
974                 _excluded[i] = _excluded[_excluded.length - 1];
975                 _tOwned[account] = 0;
976                 _isExcluded[account] = false;
977                 _excluded.pop();
978                 break;
979             }
980         }
981     }
982         function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
983         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tCharity) = _getValues(tAmount);
984         _tOwned[sender] = _tOwned[sender].sub(tAmount);
985         _rOwned[sender] = _rOwned[sender].sub(rAmount);
986         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
987         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
988         _takeLiquidity(tLiquidity);
989         _takeCharity(tCharity);
990         _reflectFee(rFee, tFee);
991         emit Transfer(sender, recipient, tTransferAmount);
992     }
993     
994         function excludeFromFee(address account) public onlyOwner {
995         _isExcludedFromFee[account] = true;
996     }
997     
998     function includeInFee(address account) public onlyOwner {
999         _isExcludedFromFee[account] = false;
1000     }
1001     
1002     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
1003         _taxFee = taxFee;
1004     }
1005 
1006     function setCharityFeePercent(uint256 charityFee) external onlyOwner() {
1007         _charityFee = charityFee;
1008     }
1009     
1010     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
1011         _liquidityFee = liquidityFee;
1012     }
1013    
1014     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
1015         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
1016             10**2
1017         );
1018     }
1019 
1020     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1021         swapAndLiquifyEnabled = _enabled;
1022         emit SwapAndLiquifyEnabledUpdated(_enabled);
1023     }
1024     
1025      //to recieve ETH from uniswapV2Router when swaping
1026     receive() external payable {}
1027 
1028     function _reflectFee(uint256 rFee, uint256 tFee) private {
1029         _rTotal = _rTotal.sub(rFee);
1030         _tFeeTotal = _tFeeTotal.add(tFee);
1031     }
1032 
1033     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
1034         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tCharity) = _getTValues(tAmount);
1035         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, tCharity, _getRate());
1036         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity, tCharity);
1037     }
1038 
1039     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
1040         uint256 tFee = calculateTaxFee(tAmount);
1041         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1042         uint256 tCharity = calculateCharityFee(tAmount);
1043         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity).sub(tCharity);
1044         return (tTransferAmount, tFee, tLiquidity, tCharity);
1045     }
1046 
1047     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 tCharity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1048         uint256 rAmount = tAmount.mul(currentRate);
1049         uint256 rFee = tFee.mul(currentRate);
1050         uint256 rLiquidity = tLiquidity.mul(currentRate);
1051         uint256 rCharity = tCharity.mul(currentRate);
1052         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity).sub(rCharity);
1053         return (rAmount, rTransferAmount, rFee);
1054     }
1055 
1056     function _getRate() private view returns(uint256) {
1057         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1058         return rSupply.div(tSupply);
1059     }
1060 
1061     function _getCurrentSupply() private view returns(uint256, uint256) {
1062         uint256 rSupply = _rTotal;
1063         uint256 tSupply = _tTotal;      
1064         for (uint256 i = 0; i < _excluded.length; i++) {
1065             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1066             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1067             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1068         }
1069         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1070         return (rSupply, tSupply);
1071     }
1072     
1073     function _takeLiquidity(uint256 tLiquidity) private {
1074         uint256 currentRate =  _getRate();
1075         uint256 rLiquidity = tLiquidity.mul(currentRate);
1076         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1077         if(_isExcluded[address(this)])
1078             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1079     }
1080     
1081     function _takeCharity(uint256 tCharity) private {
1082         uint256 currentRate =  _getRate();
1083         uint256 rCharity = tCharity.mul(currentRate);
1084         _rOwned[_charityWalletAddress] = _rOwned[_charityWalletAddress].add(rCharity);
1085         if(_isExcluded[_charityWalletAddress])
1086             _tOwned[_charityWalletAddress] = _tOwned[_charityWalletAddress].add(tCharity);
1087     }
1088     
1089     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1090         return _amount.mul(_taxFee).div(
1091             10**2
1092         );
1093     }
1094 
1095     function calculateCharityFee(uint256 _amount) private view returns (uint256) {
1096         return _amount.mul(_charityFee).div(
1097             10**2
1098         );
1099     }
1100 
1101     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1102         return _amount.mul(_liquidityFee).div(
1103             10**2
1104         );
1105     }
1106     
1107     function removeAllFee() private {
1108         if(_taxFee == 0 && _liquidityFee == 0) return;
1109         
1110         _previousTaxFee = _taxFee;
1111         _previousCharityFee = _charityFee;
1112         _previousLiquidityFee = _liquidityFee;
1113         
1114         _taxFee = 0;
1115         _charityFee = 0;
1116         _liquidityFee = 0;
1117     }
1118     
1119     function restoreAllFee() private {
1120         _taxFee = _previousTaxFee;
1121         _charityFee = _previousCharityFee;
1122         _liquidityFee = _previousLiquidityFee;
1123     }
1124     
1125     function isExcludedFromFee(address account) public view returns(bool) {
1126         return _isExcludedFromFee[account];
1127     }
1128 
1129     function _approve(address owner, address spender, uint256 amount) private {
1130         require(owner != address(0), "ERC20: approve from the zero address");
1131         require(spender != address(0), "ERC20: approve to the zero address");
1132 
1133         _allowances[owner][spender] = amount;
1134         emit Approval(owner, spender, amount);
1135     }
1136 
1137     function _transfer(
1138         address from,
1139         address to,
1140         uint256 amount
1141     ) private {
1142         require(from != address(0), "ERC20: transfer from the zero address");
1143         require(to != address(0), "ERC20: transfer to the zero address");
1144         require(amount > 0, "Transfer amount must be greater than zero");
1145         if(from != owner() && to != owner())
1146             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1147 
1148         // is the token balance of this contract address over the min number of
1149         // tokens that we need to initiate a swap + liquidity lock?
1150         // also, don't get caught in a circular liquidity event.
1151         // also, don't swap & liquify if sender is uniswap pair.
1152         uint256 contractTokenBalance = balanceOf(address(this));
1153         
1154         if(contractTokenBalance >= _maxTxAmount)
1155         {
1156             contractTokenBalance = _maxTxAmount;
1157         }
1158         
1159         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1160         if (
1161             overMinTokenBalance &&
1162             !inSwapAndLiquify &&
1163             from != uniswapV2Pair &&
1164             swapAndLiquifyEnabled
1165         ) {
1166             contractTokenBalance = numTokensSellToAddToLiquidity;
1167             //add liquidity
1168             swapAndLiquify(contractTokenBalance);
1169         }
1170         
1171         //indicates if fee should be deducted from transfer
1172         bool takeFee = true;
1173         
1174         //if any account belongs to _isExcludedFromFee account then remove the fee
1175         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1176             takeFee = false;
1177         }
1178         
1179         //transfer amount, it will take tax, burn, liquidity fee
1180         _tokenTransfer(from,to,amount,takeFee);
1181     }
1182 
1183     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1184         // split the contract balance into halves
1185         uint256 half = contractTokenBalance.div(2);
1186         uint256 otherHalf = contractTokenBalance.sub(half);
1187 
1188         // capture the contract's current ETH balance.
1189         // this is so that we can capture exactly the amount of ETH that the
1190         // swap creates, and not make the liquidity event include any ETH that
1191         // has been manually sent to the contract
1192         uint256 initialBalance = address(this).balance;
1193 
1194         // swap tokens for ETH
1195         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1196 
1197         // how much ETH did we just swap into?
1198         uint256 newBalance = address(this).balance.sub(initialBalance);
1199 
1200         // add liquidity to uniswap
1201         addLiquidity(otherHalf, newBalance);
1202         
1203         emit SwapAndLiquify(half, newBalance, otherHalf);
1204     }
1205 
1206     function swapTokensForEth(uint256 tokenAmount) private {
1207         // generate the uniswap pair path of token -> weth
1208         address[] memory path = new address[](2);
1209         path[0] = address(this);
1210         path[1] = uniswapV2Router.WETH();
1211 
1212         _approve(address(this), address(uniswapV2Router), tokenAmount);
1213 
1214         // make the swap
1215         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1216             tokenAmount,
1217             0, // accept any amount of ETH
1218             path,
1219             address(this),
1220             block.timestamp
1221         );
1222     }
1223 
1224     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1225         // approve token transfer to cover all possible scenarios
1226         _approve(address(this), address(uniswapV2Router), tokenAmount);
1227 
1228         // add the liquidity
1229         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1230             address(this),
1231             tokenAmount,
1232             0, // slippage is unavoidable
1233             0, // slippage is unavoidable
1234             owner(),
1235             block.timestamp
1236         );
1237     }
1238 
1239     //this method is responsible for taking all fee, if takeFee is true
1240     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1241         if(!takeFee)
1242             removeAllFee();
1243         
1244         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1245             _transferFromExcluded(sender, recipient, amount);
1246         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1247             _transferToExcluded(sender, recipient, amount);
1248         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1249             _transferStandard(sender, recipient, amount);
1250         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1251             _transferBothExcluded(sender, recipient, amount);
1252         } else {
1253             _transferStandard(sender, recipient, amount);
1254         }
1255         
1256         if(!takeFee)
1257             restoreAllFee();
1258     }
1259 
1260     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1261         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tCharity) = _getValues(tAmount);
1262         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1263         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1264         _takeLiquidity(tLiquidity);
1265         _takeCharity(tCharity);
1266         _reflectFee(rFee, tFee);
1267         emit Transfer(sender, recipient, tTransferAmount);
1268     }
1269 
1270     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1271         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tCharity) = _getValues(tAmount);
1272         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1273         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1274         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1275         _takeLiquidity(tLiquidity);
1276         _takeCharity(tCharity);
1277         _reflectFee(rFee, tFee);
1278         emit Transfer(sender, recipient, tTransferAmount);
1279     }
1280 
1281     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1282         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity, uint256 tCharity) = _getValues(tAmount);
1283         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1284         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1285         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1286         _takeLiquidity(tLiquidity);
1287         _takeCharity(tCharity);
1288         _reflectFee(rFee, tFee);
1289         emit Transfer(sender, recipient, tTransferAmount);
1290     }
1291 
1292 }