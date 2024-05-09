1 // PensionPlan
2 // Warning: For protection of our investors, Pension Plan token should not be purchased before 6/10/2021. Such practice will result in address being excluded from transacting forever and lost of  investment.
3 // Sources flattened with hardhat v2.6.4 https://hardhat.org
4 
5 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.3.2
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev Interface of the ERC20 standard as defined in the EIP.
13  */
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
90 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.3.2
91 
92 /**
93  * @dev Interface for the optional metadata functions from the ERC20 standard.
94  *
95  * _Available since v4.1._
96  */
97 interface IERC20Metadata is IERC20 {
98     /**
99      * @dev Returns the name of the token.
100      */
101     function name() external view returns (string memory);
102 
103     /**
104      * @dev Returns the symbol of the token.
105      */
106     function symbol() external view returns (string memory);
107 
108     /**
109      * @dev Returns the decimals places of the token.
110      */
111     function decimals() external view returns (uint8);
112 }
113 
114 
115 // File @openzeppelin/contracts/utils/Context.sol@v4.3.2
116 
117 /**
118  * @dev Provides information about the current execution context, including the
119  * sender of the transaction and its data. While these are generally available
120  * via msg.sender and msg.data, they should not be accessed in such a direct
121  * manner, since when dealing with meta-transactions the account sending and
122  * paying for execution may not be the actual sender (as far as an application
123  * is concerned).
124  *
125  * This contract is only required for intermediate, library-like contracts.
126  */
127 abstract contract Context {
128     function _msgSender() internal view virtual returns (address) {
129         return msg.sender;
130     }
131 
132     function _msgData() internal view virtual returns (bytes calldata) {
133         return msg.data;
134     }
135 }
136 
137 
138 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.3.2
139 
140 /**
141  * @dev Implementation of the {IERC20} interface.
142  *
143  * This implementation is agnostic to the way tokens are created. This means
144  * that a supply mechanism has to be added in a derived contract using {_mint}.
145  * For a generic mechanism see {ERC20PresetMinterPauser}.
146  *
147  * TIP: For a detailed writeup see our guide
148  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
149  * to implement supply mechanisms].
150  *
151  * We have followed general OpenZeppelin Contracts guidelines: functions revert
152  * instead returning `false` on failure. This behavior is nonetheless
153  * conventional and does not conflict with the expectations of ERC20
154  * applications.
155  *
156  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
157  * This allows applications to reconstruct the allowance for all accounts just
158  * by listening to said events. Other implementations of the EIP may not emit
159  * these events, as it isn't required by the specification.
160  *
161  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
162  * functions have been added to mitigate the well-known issues around setting
163  * allowances. See {IERC20-approve}.
164  */
165 
166 // File @openzeppelin/contracts/utils/math/Math.sol@v4.3.2
167 
168 /**
169  * @dev Standard math utilities missing in the Solidity language.
170  */
171 library Math {
172     /**
173      * @dev Returns the largest of two numbers.
174      */
175     function max(uint256 a, uint256 b) internal pure returns (uint256) {
176         return a >= b ? a : b;
177     }
178 
179     /**
180      * @dev Returns the smallest of two numbers.
181      */
182     function min(uint256 a, uint256 b) internal pure returns (uint256) {
183         return a < b ? a : b;
184     }
185 
186     /**
187      * @dev Returns the average of two numbers. The result is rounded towards
188      * zero.
189      */
190     function average(uint256 a, uint256 b) internal pure returns (uint256) {
191         // (a + b) / 2 can overflow.
192         return (a & b) + (a ^ b) / 2;
193     }
194 
195     /**
196      * @dev Returns the ceiling of the division of two numbers.
197      *
198      * This differs from standard division with `/` in that it rounds up instead
199      * of rounding down.
200      */
201     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
202         // (a + b - 1) / b can overflow on addition, so we distribute.
203         return a / b + (a % b == 0 ? 0 : 1);
204     }
205 }
206 
207 
208 // File @openzeppelin/contracts/utils/Arrays.sol@v4.3.2
209 
210 /**
211  * @dev Collection of functions related to array types.
212  */
213 library Arrays {
214     /**
215      * @dev Searches a sorted `array` and returns the first index that contains
216      * a value greater or equal to `element`. If no such index exists (i.e. all
217      * values in the array are strictly less than `element`), the array length is
218      * returned. Time complexity O(log n).
219      *
220      * `array` is expected to be sorted in ascending order, and to contain no
221      * repeated elements.
222      */
223     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
224         if (array.length == 0) {
225             return 0;
226         }
227 
228         uint256 low = 0;
229         uint256 high = array.length;
230 
231         while (low < high) {
232             uint256 mid = Math.average(low, high);
233 
234             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
235             // because Math.average rounds down (it does integer division with truncation).
236             if (array[mid] > element) {
237                 high = mid;
238             } else {
239                 low = mid + 1;
240             }
241         }
242 
243         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
244         if (low > 0 && array[low - 1] == element) {
245             return low - 1;
246         } else {
247             return low;
248         }
249     }
250 }
251 
252 
253 // File @openzeppelin/contracts/utils/Counters.sol@v4.3.2
254 
255 /**
256  * @title Counters
257  * @author Matt Condon (@shrugs)
258  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
259  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
260  *
261  * Include with `using Counters for Counters.Counter;`
262  */
263 library Counters {
264     struct Counter {
265         // This variable should never be directly accessed by users of the library: interactions must be restricted to
266         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
267         // this feature: see https://github.com/ethereum/solidity/issues/4637
268         uint256 _value; // default: 0
269     }
270 
271     function current(Counter storage counter) internal view returns (uint256) {
272         return counter._value;
273     }
274 
275     function increment(Counter storage counter) internal {
276         unchecked {
277             counter._value += 1;
278         }
279     }
280 
281     function decrement(Counter storage counter) internal {
282         uint256 value = counter._value;
283         require(value > 0, "Counter: decrement overflow");
284         unchecked {
285             counter._value = value - 1;
286         }
287     }
288 
289     function reset(Counter storage counter) internal {
290         counter._value = 0;
291     }
292 }
293 
294 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.2
295 
296 /**
297  * @dev Contract module which provides a basic access control mechanism, where
298  * there is an account (an owner) that can be granted exclusive access to
299  * specific functions.
300  *
301  * By default, the owner account will be the one that deploys the contract. This
302  * can later be changed with {transferOwnership}.
303  *
304  * This module is used through inheritance. It will make available the modifier
305  * `onlyOwner`, which can be applied to your functions to restrict their use to
306  * the owner.
307  */
308 abstract contract Ownable is Context {
309     address private _owner;
310 
311     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
312 
313     /**
314      * @dev Initializes the contract setting the deployer as the initial owner.
315      */
316     constructor() {
317         _setOwner(_msgSender());
318     }
319 
320     /**
321      * @dev Returns the address of the current owner.
322      */
323     function owner() public view virtual returns (address) {
324         return _owner;
325     }
326 
327     /**
328      * @dev Throws if called by any account other than the owner.
329      */
330     modifier onlyOwner() {
331         require(owner() == _msgSender(), "Ownable: caller is not the owner");
332         _;
333     }
334 
335     /**
336      * @dev Leaves the contract without owner. It will not be possible to call
337      * `onlyOwner` functions anymore. Can only be called by the current owner.
338      *
339      * NOTE: Renouncing ownership will leave the contract without an owner,
340      * thereby removing any functionality that is only available to the owner.
341      */
342     function renounceOwnership() public virtual onlyOwner {
343         _setOwner(address(0));
344     }
345 
346     /**
347      * @dev Transfers ownership of the contract to a new account (`newOwner`).
348      * Can only be called by the current owner.
349      */
350     function transferOwnership(address newOwner) public virtual onlyOwner {
351         require(newOwner != address(0), "Ownable: new owner is the zero address");
352         _setOwner(newOwner);
353     }
354 
355     function _setOwner(address newOwner) private {
356         address oldOwner = _owner;
357         _owner = newOwner;
358         emit OwnershipTransferred(oldOwner, newOwner);
359     }
360 }
361 
362 
363 // File @openzeppelin/contracts/utils/Address.sol@v4.3.2
364 
365 /**
366  * @dev Collection of functions related to the address type
367  */
368 library Address {
369     /**
370      * @dev Returns true if `account` is a contract.
371      *
372      * [IMPORTANT]
373      * ====
374      * It is unsafe to assume that an address for which this function returns
375      * false is an externally-owned account (EOA) and not a contract.
376      *
377      * Among others, `isContract` will return false for the following
378      * types of addresses:
379      *
380      *  - an externally-owned account
381      *  - a contract in construction
382      *  - an address where a contract will be created
383      *  - an address where a contract lived, but was destroyed
384      * ====
385      */
386     function isContract(address account) internal view returns (bool) {
387         // This method relies on extcodesize, which returns 0 for contracts in
388         // construction, since the code is only stored at the end of the
389         // constructor execution.
390 
391         uint256 size;
392         assembly {
393             size := extcodesize(account)
394         }
395         return size > 0;
396     }
397 
398     /**
399      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
400      * `recipient`, forwarding all available gas and reverting on errors.
401      *
402      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
403      * of certain opcodes, possibly making contracts go over the 2300 gas limit
404      * imposed by `transfer`, making them unable to receive funds via
405      * `transfer`. {sendValue} removes this limitation.
406      *
407      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
408      *
409      * IMPORTANT: because control is transferred to `recipient`, care must be
410      * taken to not create reentrancy vulnerabilities. Consider using
411      * {ReentrancyGuard} or the
412      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
413      */
414     function sendValue(address payable recipient, uint256 amount) internal {
415         require(address(this).balance >= amount, "Address: insufficient balance");
416 
417         (bool success, ) = recipient.call{value: amount}("");
418         require(success, "Address: unable to send value, recipient may have reverted");
419     }
420 
421     /**
422      * @dev Performs a Solidity function call using a low level `call`. A
423      * plain `call` is an unsafe replacement for a function call: use this
424      * function instead.
425      *
426      * If `target` reverts with a revert reason, it is bubbled up by this
427      * function (like regular Solidity function calls).
428      *
429      * Returns the raw returned data. To convert to the expected return value,
430      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
431      *
432      * Requirements:
433      *
434      * - `target` must be a contract.
435      * - calling `target` with `data` must not revert.
436      *
437      * _Available since v3.1._
438      */
439     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
440         return functionCall(target, data, "Address: low-level call failed");
441     }
442 
443     /**
444      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
445      * `errorMessage` as a fallback revert reason when `target` reverts.
446      *
447      * _Available since v3.1._
448      */
449     function functionCall(
450         address target,
451         bytes memory data,
452         string memory errorMessage
453     ) internal returns (bytes memory) {
454         return functionCallWithValue(target, data, 0, errorMessage);
455     }
456 
457     /**
458      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
459      * but also transferring `value` wei to `target`.
460      *
461      * Requirements:
462      *
463      * - the calling contract must have an ETH balance of at least `value`.
464      * - the called Solidity function must be `payable`.
465      *
466      * _Available since v3.1._
467      */
468     function functionCallWithValue(
469         address target,
470         bytes memory data,
471         uint256 value
472     ) internal returns (bytes memory) {
473         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
474     }
475 
476     /**
477      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
478      * with `errorMessage` as a fallback revert reason when `target` reverts.
479      *
480      * _Available since v3.1._
481      */
482     function functionCallWithValue(
483         address target,
484         bytes memory data,
485         uint256 value,
486         string memory errorMessage
487     ) internal returns (bytes memory) {
488         require(address(this).balance >= value, "Address: insufficient balance for call");
489         require(isContract(target), "Address: call to non-contract");
490 
491         (bool success, bytes memory returndata) = target.call{value: value}(data);
492         return verifyCallResult(success, returndata, errorMessage);
493     }
494 
495     /**
496      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
497      * but performing a static call.
498      *
499      * _Available since v3.3._
500      */
501     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
502         return functionStaticCall(target, data, "Address: low-level static call failed");
503     }
504 
505     /**
506      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
507      * but performing a static call.
508      *
509      * _Available since v3.3._
510      */
511     function functionStaticCall(
512         address target,
513         bytes memory data,
514         string memory errorMessage
515     ) internal view returns (bytes memory) {
516         require(isContract(target), "Address: static call to non-contract");
517 
518         (bool success, bytes memory returndata) = target.staticcall(data);
519         return verifyCallResult(success, returndata, errorMessage);
520     }
521 
522     /**
523      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
524      * but performing a delegate call.
525      *
526      * _Available since v3.4._
527      */
528     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
529         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
530     }
531 
532     /**
533      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
534      * but performing a delegate call.
535      *
536      * _Available since v3.4._
537      */
538     function functionDelegateCall(
539         address target,
540         bytes memory data,
541         string memory errorMessage
542     ) internal returns (bytes memory) {
543         require(isContract(target), "Address: delegate call to non-contract");
544 
545         (bool success, bytes memory returndata) = target.delegatecall(data);
546         return verifyCallResult(success, returndata, errorMessage);
547     }
548 
549     /**
550      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
551      * revert reason using the provided one.
552      *
553      * _Available since v4.3._
554      */
555     function verifyCallResult(
556         bool success,
557         bytes memory returndata,
558         string memory errorMessage
559     ) internal pure returns (bytes memory) {
560         if (success) {
561             return returndata;
562         } else {
563             // Look for revert reason and bubble it up if present
564             if (returndata.length > 0) {
565                 // The easiest way to bubble the revert reason is using memory via assembly
566 
567                 assembly {
568                     let returndata_size := mload(returndata)
569                     revert(add(32, returndata), returndata_size)
570                 }
571             } else {
572                 revert(errorMessage);
573             }
574         }
575     }
576 }
577 
578 
579 // File contracts/uniswap.sol
580 
581 interface IUniswapV2Factory {
582     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
583 
584     function feeTo() external view returns (address);
585     function feeToSetter() external view returns (address);
586 
587     function getPair(address tokenA, address tokenB) external view returns (address pair);
588     function allPairs(uint) external view returns (address pair);
589     function allPairsLength() external view returns (uint);
590 
591     function createPair(address tokenA, address tokenB) external returns (address pair);
592 
593     function setFeeTo(address) external;
594     function setFeeToSetter(address) external;
595 }
596 
597 interface IUniswapV2Pair {
598     event Approval(address indexed owner, address indexed spender, uint value);
599     event Transfer(address indexed from, address indexed to, uint value);
600 
601     function name() external pure returns (string memory);
602     function symbol() external pure returns (string memory);
603     function decimals() external pure returns (uint8);
604     function totalSupply() external view returns (uint);
605     function balanceOf(address owner) external view returns (uint);
606     function allowance(address owner, address spender) external view returns (uint);
607 
608     function approve(address spender, uint value) external returns (bool);
609     function transfer(address to, uint value) external returns (bool);
610     function transferFrom(address from, address to, uint value) external returns (bool);
611 
612     function DOMAIN_SEPARATOR() external view returns (bytes32);
613     function PERMIT_TYPEHASH() external pure returns (bytes32);
614     function nonces(address owner) external view returns (uint);
615 
616     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
617     
618     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
619     event Swap(
620         address indexed sender,
621         uint amount0In,
622         uint amount1In,
623         uint amount0Out,
624         uint amount1Out,
625         address indexed to
626     );
627     event Sync(uint112 reserve0, uint112 reserve1);
628 
629     function MINIMUM_LIQUIDITY() external pure returns (uint);
630     function factory() external view returns (address);
631     function token0() external view returns (address);
632     function token1() external view returns (address);
633     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
634     function price0CumulativeLast() external view returns (uint);
635     function price1CumulativeLast() external view returns (uint);
636     function kLast() external view returns (uint);
637 
638     function burn(address to) external returns (uint amount0, uint amount1);
639     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
640     function skim(address to) external;
641     function sync() external;
642 
643     function initialize(address, address) external;
644 }
645 
646 interface IUniswapV2Router01 {
647     function factory() external pure returns (address);
648     function WETH() external pure returns (address);
649 
650     function addLiquidity(
651         address tokenA,
652         address tokenB,
653         uint amountADesired,
654         uint amountBDesired,
655         uint amountAMin,
656         uint amountBMin,
657         address to,
658         uint deadline
659     ) external returns (uint amountA, uint amountB, uint liquidity);
660     function addLiquidityETH(
661         address token,
662         uint amountTokenDesired,
663         uint amountTokenMin,
664         uint amountETHMin,
665         address to,
666         uint deadline
667     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
668     function removeLiquidity(
669         address tokenA,
670         address tokenB,
671         uint liquidity,
672         uint amountAMin,
673         uint amountBMin,
674         address to,
675         uint deadline
676     ) external returns (uint amountA, uint amountB);
677     function removeLiquidityETH(
678         address token,
679         uint liquidity,
680         uint amountTokenMin,
681         uint amountETHMin,
682         address to,
683         uint deadline
684     ) external returns (uint amountToken, uint amountETH);
685     function removeLiquidityWithPermit(
686         address tokenA,
687         address tokenB,
688         uint liquidity,
689         uint amountAMin,
690         uint amountBMin,
691         address to,
692         uint deadline,
693         bool approveMax, uint8 v, bytes32 r, bytes32 s
694     ) external returns (uint amountA, uint amountB);
695     function removeLiquidityETHWithPermit(
696         address token,
697         uint liquidity,
698         uint amountTokenMin,
699         uint amountETHMin,
700         address to,
701         uint deadline,
702         bool approveMax, uint8 v, bytes32 r, bytes32 s
703     ) external returns (uint amountToken, uint amountETH);
704     function swapExactTokensForTokens(
705         uint amountIn,
706         uint amountOutMin,
707         address[] calldata path,
708         address to,
709         uint deadline
710     ) external returns (uint[] memory amounts);
711     function swapTokensForExactTokens(
712         uint amountOut,
713         uint amountInMax,
714         address[] calldata path,
715         address to,
716         uint deadline
717     ) external returns (uint[] memory amounts);
718     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
719         external
720         payable
721         returns (uint[] memory amounts);
722     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
723         external
724         returns (uint[] memory amounts);
725     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
726         external
727         returns (uint[] memory amounts);
728     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
729         external
730         payable
731         returns (uint[] memory amounts);
732 
733     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
734     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
735     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
736     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
737     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
738 }
739 
740 interface IUniswapV2Router02 is IUniswapV2Router01 {
741     function removeLiquidityETHSupportingFeeOnTransferTokens(
742         address token,
743         uint liquidity,
744         uint amountTokenMin,
745         uint amountETHMin,
746         address to,
747         uint deadline
748     ) external returns (uint amountETH);
749     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
750         address token,
751         uint liquidity,
752         uint amountTokenMin,
753         uint amountETHMin,
754         address to,
755         uint deadline,
756         bool approveMax, uint8 v, bytes32 r, bytes32 s
757     ) external returns (uint amountETH);
758 
759     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
760         uint amountIn,
761         uint amountOutMin,
762         address[] calldata path,
763         address to,
764         uint deadline
765     ) external;
766     function swapExactETHForTokensSupportingFeeOnTransferTokens(
767         uint amountOutMin,
768         address[] calldata path,
769         address to,
770         uint deadline
771     ) external payable;
772     function swapExactTokensForETHSupportingFeeOnTransferTokens(
773         uint amountIn,
774         uint amountOutMin,
775         address[] calldata path,
776         address to,
777         uint deadline
778     ) external;
779 }
780 
781 
782 contract PensionPlan is Context, IERC20, IERC20Metadata, Ownable {
783     using Address for address;
784     mapping(address => uint256) private _balances;
785 
786     mapping(address => mapping(address => uint256)) private _allowances;
787 
788     uint256 private constant _totalSupply = 1000000000000 * 10**8;
789 
790     string private constant _name = "Pension Plan";
791     string private constant _symbol = "PP";
792     
793     address payable public marketingAddress = payable(0x83B6d6dec5b35259f6bAA3371006b9AC397A4Ff7);
794     address payable public developmentAddress = payable(0x2F01336282CEbF5D981e923edE9E6FaC333dA2C6);
795     address payable public foundationAddress = payable(0x72d752776B093575a40B1AC04c57811086cb4B55);
796     address payable public hachikoInuBuybackAddress = payable(0xd6C8385ec4F08dF85B39c301C993A692790288c7);
797     address payable public constant deadAddress = payable(0x000000000000000000000000000000000000dEaD);
798 
799     mapping (address => bool) private _isExcluded;
800     address[] private _excluded;
801     
802     mapping (address => bool) private _isBanned;
803     address[] private _banned;
804    
805     uint256 public constant totalFee = 12;
806 
807     uint256 public minimumTokensBeforeSwap = 200000000 * 10**8; 
808 
809     IUniswapV2Router02 public immutable uniswapV2Router;
810     address public immutable uniswapV2Pair;
811     
812     bool inSwapAndLiquify;
813 
814     uint256 public minimumETHBeforePayout = 1 * 10**18;
815     uint256 public payoutsToProcess = 5;
816     uint256 private _lastProcessedAddressIndex;
817     uint256 public _payoutAmount;
818     bool public processingPayouts;
819     uint256 public _snapshotId;
820     
821     struct Set {
822         address[] values;
823         mapping (address => bool) is_in;
824     }
825     
826     Set private _allAddresses;
827 
828     
829     event SwapTokensForETH(
830         uint256 amountIn,
831         address[] path
832     );
833     
834     event SwapETHForTokens(
835         uint256 amountIn,
836         address[] path
837     );
838     
839     event PayoutStarted(
840         uint256 amount
841     );
842     
843     modifier lockTheSwap {
844         inSwapAndLiquify = true;
845         _;
846         inSwapAndLiquify = false;
847     }
848     
849     constructor() {
850         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
851         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
852             .createPair(address(this), _uniswapV2Router.WETH());
853 
854         uniswapV2Router = _uniswapV2Router;
855         uniswapV2Pair = _uniswapV2Pair;
856         
857         excludeFromReward(owner());
858         excludeFromReward(_uniswapV2Pair);
859         excludeFromReward(marketingAddress);
860         excludeFromReward(developmentAddress);
861         excludeFromReward(foundationAddress);
862         excludeFromReward(hachikoInuBuybackAddress);
863         excludeFromReward(deadAddress);
864         
865         _beforeTokenTransfer(address(0), owner());
866         _balances[owner()] = _totalSupply;
867         emit Transfer(address(0), owner(), _totalSupply);
868     }
869 
870     /**
871      * @dev Returns the name of the token.
872      */
873     function name() public pure override returns (string memory) {
874         return _name;
875     }
876 
877     /**
878      * @dev Returns the symbol of the token, usually a shorter version of the
879      * name.
880      */
881     function symbol() public pure override returns (string memory) {
882         return _symbol;
883     }
884 
885     /**
886      * @dev Returns the number of decimals used to get its user representation.
887      * For example, if `decimals` equals `2`, a balance of `505` tokens should
888      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
889      *
890      * Tokens usually opt for a value of 18, imitating the relationship between
891      * Ether and Wei. This is the value {ERC20} uses, unless this function is
892      * overridden;
893      *
894      * NOTE: This information is only used for _display_ purposes: it in
895      * no way affects any of the arithmetic of the contract, including
896      * {IERC20-balanceOf} and {IERC20-transfer}.
897      */
898     function decimals() public pure override returns (uint8) {
899         return 8;
900     }
901 
902     /**
903      * @dev See {IERC20-totalSupply}.
904      */
905     function totalSupply() public pure override returns (uint256) {
906         return _totalSupply;
907     }
908 
909     /**
910      * @dev See {IERC20-balanceOf}.
911      */
912     function balanceOf(address account) public view override returns (uint256) {
913         return _balances[account];
914     }
915 
916     /**
917      * @dev See {IERC20-transfer}.
918      *
919      * Requirements:
920      *
921      * - `recipient` cannot be the zero address.
922      * - the caller must have a balance of at least `amount`.
923      */
924     function transfer(address recipient, uint256 amount) public override returns (bool) {
925         _transfer(_msgSender(), recipient, amount);
926         return true;
927     }
928 
929     /**
930      * @dev See {IERC20-allowance}.
931      */
932     function allowance(address owner, address spender) public view override returns (uint256) {
933         return _allowances[owner][spender];
934     }
935 
936     /**
937      * @dev See {IERC20-approve}.
938      *
939      * Requirements:
940      *
941      * - `spender` cannot be the zero address.
942      */
943     function approve(address spender, uint256 amount) public override returns (bool) {
944         _approve(_msgSender(), spender, amount);
945         return true;
946     }
947 
948     /**
949      * @dev See {IERC20-transferFrom}.
950      *
951      * Emits an {Approval} event indicating the updated allowance. This is not
952      * required by the EIP. See the note at the beginning of {ERC20}.
953      *
954      * Requirements:
955      *
956      * - `sender` and `recipient` cannot be the zero address.
957      * - `sender` must have a balance of at least `amount`.
958      * - the caller must have allowance for ``sender``'s tokens of at least
959      * `amount`.
960      */
961     function transferFrom(
962         address sender,
963         address recipient,
964         uint256 amount
965     ) public override returns (bool) {
966         _transfer(sender, recipient, amount);
967 
968         uint256 currentAllowance = _allowances[sender][_msgSender()];
969         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
970         unchecked {
971             _approve(sender, _msgSender(), currentAllowance - amount);
972         }
973 
974         return true;
975     }
976 
977     /**
978      * @dev Atomically increases the allowance granted to `spender` by the caller.
979      *
980      * This is an alternative to {approve} that can be used as a mitigation for
981      * problems described in {IERC20-approve}.
982      *
983      * Emits an {Approval} event indicating the updated allowance.
984      *
985      * Requirements:
986      *
987      * - `spender` cannot be the zero address.
988      */
989     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
990         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
991         return true;
992     }
993 
994     /**
995      * @dev Atomically decreases the allowance granted to `spender` by the caller.
996      *
997      * This is an alternative to {approve} that can be used as a mitigation for
998      * problems described in {IERC20-approve}.
999      *
1000      * Emits an {Approval} event indicating the updated allowance.
1001      *
1002      * Requirements:
1003      *
1004      * - `spender` cannot be the zero address.
1005      * - `spender` must have allowance for the caller of at least
1006      * `subtractedValue`.
1007      */
1008     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
1009         uint256 currentAllowance = _allowances[_msgSender()][spender];
1010         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1011         unchecked {
1012             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
1013         }
1014 
1015         return true;
1016     }
1017 
1018     /**
1019      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1020      *
1021      * This internal function is equivalent to `approve`, and can be used to
1022      * e.g. set automatic allowances for certain subsystems, etc.
1023      *
1024      * Emits an {Approval} event.
1025      *
1026      * Requirements:
1027      *
1028      * - `owner` cannot be the zero address.
1029      * - `spender` cannot be the zero address.
1030      */
1031     function _approve(
1032         address owner,
1033         address spender,
1034         uint256 amount
1035     ) internal {
1036         require(owner != address(0), "ERC20: approve from the zero address");
1037         require(spender != address(0), "ERC20: approve to the zero address");
1038 
1039         _allowances[owner][spender] = amount;
1040         emit Approval(owner, spender, amount);
1041     }
1042 
1043     function eligibleSupply() public view returns (uint256) {
1044         uint256 supply =  _totalSupply;
1045         for (uint256 i = 0; i < _excluded.length; i++) {
1046             unchecked {
1047                 supply = supply - _balances[_excluded[i]];
1048             }
1049         }
1050         return supply;
1051         
1052     }
1053 
1054     function eligibleSupplyAt(uint256 snapshotId) public view returns (uint256) {
1055         uint256 supply =  _totalSupply;
1056         for (uint256 i = 0; i < _excluded.length; i++) {
1057             unchecked {
1058                 supply = supply - balanceOfAt(_excluded[i], snapshotId);
1059             }
1060         }
1061         return supply;
1062         
1063     }
1064 
1065     function isExcludedFromReward(address account) public view returns (bool) {
1066         return _isExcluded[account];
1067     }
1068 
1069     function excludeFromReward(address account) public onlyOwner() {
1070         require(!_isExcluded[account], "Account is already excluded");
1071         _isExcluded[account] = true;
1072         _excluded.push(account);
1073     }
1074 
1075     function includeInReward(address account) public onlyOwner() {
1076         require(_isExcluded[account], "Account is already included");
1077         for (uint256 i = 0; i < _excluded.length; i++) {
1078             if (_excluded[i] == account) {
1079                 _excluded[i] = _excluded[_excluded.length - 1];
1080                 _isExcluded[account] = false;
1081                 _excluded.pop();
1082                 break;
1083             }
1084         }
1085     }
1086     
1087     function isBanned(address account) public view returns (bool) {
1088         return _isBanned[account];
1089     }
1090 
1091     function ban(address account) external onlyOwner() {
1092         require(!_isBanned[account], "Account is already banned");
1093         _isBanned[account] = true;
1094         _banned.push(account);
1095         if (!_isExcluded[account]) {
1096             excludeFromReward(account);
1097         }
1098     }
1099 
1100     function unban(address account) external onlyOwner() {
1101         require(_isBanned[account], "Account is already unbanned");
1102         for (uint256 i = 0; i < _banned.length; i++) {
1103             if (_banned[i] == account) {
1104                 _banned[i] = _banned[_banned.length - 1];
1105                 _isBanned[account] = false;
1106                 _banned.pop();
1107                 break;
1108             }
1109         }
1110         if (_isExcluded[account]) {
1111             includeInReward(account);
1112         }
1113     }
1114 
1115     function _processPayouts() private {
1116         if (_lastProcessedAddressIndex == 0) {
1117             _lastProcessedAddressIndex = _allAddresses.values.length;
1118         }
1119         
1120         uint256 i = _lastProcessedAddressIndex;
1121         uint256 loopLimit = 0;
1122         if (_lastProcessedAddressIndex > payoutsToProcess) {
1123             loopLimit = _lastProcessedAddressIndex-payoutsToProcess;
1124         }
1125         
1126         uint256 _availableSupply = eligibleSupplyAt(_snapshotId);
1127         for (; i > loopLimit; i--) {
1128             address to = _allAddresses.values[i-1];
1129             if (_isExcluded[to] || to.isContract()) {
1130                 continue;
1131             }
1132             uint256 payout = balanceOfAt(to, _snapshotId) / (_availableSupply / _payoutAmount);
1133             payable(to).send(payout);
1134         }
1135         _lastProcessedAddressIndex = i;
1136         if (_lastProcessedAddressIndex == 0) {
1137             processingPayouts = false;
1138         }
1139     }
1140     
1141     function _handleSwapAndPayout(address to) private {
1142         if (!inSwapAndLiquify && to == uniswapV2Pair) {
1143             uint256 contractTokenBalance = balanceOf(address(this));
1144             bool overMinimumTokenBalance = contractTokenBalance >= minimumTokensBeforeSwap;
1145             if (overMinimumTokenBalance) {
1146                 swapTokensForEth(contractTokenBalance);    
1147             }
1148             uint256 balance = address(this).balance;
1149             if (!processingPayouts && balance > minimumETHBeforePayout) {
1150                 marketingAddress.transfer(balance / 6);
1151                 developmentAddress.transfer(balance / 12);
1152                 foundationAddress.transfer(balance / 12);
1153                 hachikoInuBuybackAddress.transfer( balance / 24);
1154                 swapETHForTokensAndBurn(balance / 24);
1155                 processingPayouts = true;
1156                 _payoutAmount = address(this).balance;
1157                 _snapshotId = _snapshot();
1158                 emit PayoutStarted(_payoutAmount);
1159             }
1160         }
1161     }
1162     
1163     /**
1164      * @dev Moves `amount` of tokens from `sender` to `recipient`.
1165      *
1166      * This internal function is equivalent to {transfer}, and can be used to
1167      * e.g. implement automatic token fees, slashing mechanisms, etc.
1168      *
1169      * Emits a {Transfer} event.
1170      *
1171      * Requirements:
1172      *
1173      * - `sender` cannot be the zero address.
1174      * - `recipient` cannot be the zero address.
1175      * - `sender` must have a balance of at least `amount`.
1176      */
1177     function _transfer(
1178         address sender,
1179         address recipient,
1180         uint256 amount
1181     ) internal {
1182         require(sender != address(0), "ERC20: transfer from the zero address");
1183         require(recipient != address(0), "ERC20: transfer to the zero address");
1184         require(!_isBanned[sender], "ERC: transfer from banned address");
1185         require(!_isBanned[recipient], "ERC: transfer to banned address");
1186         uint256 senderBalance = _balances[sender];
1187         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
1188 
1189         _beforeTokenTransfer(sender, recipient);
1190         if (!inSwapAndLiquify && processingPayouts) {
1191             _processPayouts();
1192         }
1193         _handleSwapAndPayout(recipient);
1194 
1195         bool takeFee = (recipient == uniswapV2Pair || sender == uniswapV2Pair);
1196         if(recipient == deadAddress || sender == owner()){
1197             takeFee = false;
1198         }
1199         
1200         unchecked {
1201             _balances[sender] = senderBalance - amount;
1202         }
1203         uint256 originalAmount = amount;
1204         if (takeFee) {
1205             uint256 fee = (amount * totalFee) / 100;
1206             _balances[address(this)] += fee;
1207             amount -= fee;
1208         }
1209         _balances[recipient] += amount;
1210 
1211         emit Transfer(sender, recipient, originalAmount);
1212     }
1213 
1214     function _beforeTokenTransfer(
1215         address sender,
1216         address recipient
1217     ) internal {
1218         if (sender == address(0)) {
1219             // mint
1220             _updateAccountSnapshot(recipient);
1221             _updateTotalSupplySnapshot();
1222         } else if (recipient == address(0)) {
1223             // burn
1224             _updateAccountSnapshot(sender);
1225             _updateTotalSupplySnapshot();
1226         } else {
1227             // transfer
1228             _updateAccountSnapshot(sender);
1229             _updateAccountSnapshot(recipient);
1230         }
1231         if (!_allAddresses.is_in[recipient]) {
1232             _allAddresses.values.push(recipient);
1233             _allAddresses.is_in[recipient] = true;
1234         }
1235     }
1236 
1237     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
1238         // generate the uniswap pair path of token -> weth
1239         address[] memory path = new address[](2);
1240         path[0] = address(this);
1241         path[1] = uniswapV2Router.WETH();
1242 
1243         _approve(address(this), address(uniswapV2Router), tokenAmount);
1244 
1245         // make the swap
1246         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1247             tokenAmount,
1248             0, // accept any amount of ETH
1249             path,
1250             address(this), // The contract
1251             block.timestamp
1252         );
1253         
1254         emit SwapTokensForETH(tokenAmount, path);
1255     }
1256     
1257     function swapETHForTokensAndBurn(uint256 amount) private lockTheSwap {
1258         // generate the uniswap pair path of token -> weth
1259         address[] memory path = new address[](2);
1260         path[0] = uniswapV2Router.WETH();
1261         path[1] = address(this);
1262 
1263       // make the swap
1264         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
1265             0, // accept any amount of Tokens
1266             path,
1267             deadAddress, // Burn address
1268             block.timestamp + 300
1269         );
1270         
1271         emit SwapETHForTokens(amount, path);
1272     }
1273 
1274     function setMinimumTokensBeforeSwap(uint256 _minimumTokensBeforeSwap) external onlyOwner() {
1275         minimumTokensBeforeSwap = _minimumTokensBeforeSwap;
1276     }
1277     
1278     function setMarketingAddress(address _marketingAddress) external onlyOwner() {
1279         marketingAddress = payable(_marketingAddress);
1280     }
1281     
1282     function setDevelopmentAddress(address _developmentAddress) external onlyOwner() {
1283         developmentAddress = payable(_developmentAddress);
1284     }
1285     
1286     function setFoundationAddress(address _foundationAddress) external onlyOwner() {
1287         foundationAddress = payable(_foundationAddress);
1288     }
1289     
1290     function setHachikoInuBuybackAddress(address _hachikoInuBuybackAddress) external onlyOwner() {
1291         hachikoInuBuybackAddress = payable(_hachikoInuBuybackAddress);
1292     }
1293     
1294     function setMinimumETHBeforePayout(uint256 _minimumETHBeforePayout) external onlyOwner() {
1295         minimumETHBeforePayout = _minimumETHBeforePayout;
1296     }
1297     
1298     function setPayoutsToProcess(uint256 _payoutsToProcess) external onlyOwner() {
1299         payoutsToProcess = _payoutsToProcess;
1300     }
1301     
1302     function manuallyProcessPayouts() external onlyOwner() returns(bool, uint256) {
1303         if (processingPayouts) {
1304             _processPayouts();
1305         }
1306         else {
1307             uint256 balance = address(this).balance;
1308             marketingAddress.transfer(balance / 6);
1309             developmentAddress.transfer(balance / 12);
1310             foundationAddress.transfer(balance / 12);
1311             hachikoInuBuybackAddress.transfer( balance / 24);
1312             swapETHForTokensAndBurn(balance / 24);
1313             processingPayouts = true;
1314             _payoutAmount = address(this).balance;
1315             _snapshotId = _snapshot();
1316             emit PayoutStarted(_payoutAmount);
1317         }
1318         return (processingPayouts, _lastProcessedAddressIndex);
1319     }
1320     
1321     using Arrays for uint256[];
1322     using Counters for Counters.Counter;
1323 
1324     // Snapshotted values have arrays of ids and the value corresponding to that id. These could be an array of a
1325     // Snapshot struct, but that would impede usage of functions that work on an array.
1326     struct Snapshots {
1327         uint256[] ids;
1328         uint256[] values;
1329     }
1330 
1331     mapping(address => Snapshots) private _accountBalanceSnapshots;
1332     Snapshots private _totalSupplySnapshots;
1333 
1334     // Snapshot ids increase monotonically, with the first value being 1. An id of 0 is invalid.
1335     Counters.Counter private _currentSnapshotId;
1336 
1337     /**
1338      * @dev Emitted by {_snapshot} when a snapshot identified by `id` is created.
1339      */
1340     event Snapshot(uint256 id);
1341 
1342     /**
1343      * @dev Creates a new snapshot and returns its snapshot id.
1344      *
1345      * Emits a {Snapshot} event that contains the same id.
1346      *
1347      * {_snapshot} is `internal` and you have to decide how to expose it externally. Its usage may be restricted to a
1348      * set of accounts, for example using {AccessControl}, or it may be open to the public.
1349      *
1350      * [WARNING]
1351      * ====
1352      * While an open way of calling {_snapshot} is required for certain trust minimization mechanisms such as forking,
1353      * you must consider that it can potentially be used by attackers in two ways.
1354      *
1355      * First, it can be used to increase the cost of retrieval of values from snapshots, although it will grow
1356      * logarithmically thus rendering this attack ineffective in the long term. Second, it can be used to target
1357      * specific accounts and increase the cost of ERC20 transfers for them, in the ways specified in the Gas Costs
1358      * section above.
1359      *
1360      * We haven't measured the actual numbers; if this is something you're interested in please reach out to us.
1361      * ====
1362      */
1363     function _snapshot() internal returns (uint256) {
1364         _currentSnapshotId.increment();
1365 
1366         uint256 currentId = _getCurrentSnapshotId();
1367         emit Snapshot(currentId);
1368         return currentId;
1369     }
1370 
1371     /**
1372      * @dev Get the current snapshotId
1373      */
1374     function _getCurrentSnapshotId() internal view returns (uint256) {
1375         return _currentSnapshotId.current();
1376     }
1377 
1378     /**
1379      * @dev Retrieves the balance of `account` at the time `snapshotId` was created.
1380      */
1381     function balanceOfAt(address account, uint256 snapshotId) public view returns (uint256) {
1382         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);
1383 
1384         return snapshotted ? value : balanceOf(account);
1385     }
1386 
1387     /**
1388      * @dev Retrieves the total supply at the time `snapshotId` was created.
1389      */
1390     function totalSupplyAt(uint256 snapshotId) public view returns (uint256) {
1391         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnapshots);
1392 
1393         return snapshotted ? value : totalSupply();
1394     }
1395 
1396     function _valueAt(uint256 snapshotId, Snapshots storage snapshots) private view returns (bool, uint256) {
1397         require(snapshotId > 0, "ERC20Snapshot: id is 0");
1398         require(snapshotId <= _getCurrentSnapshotId(), "ERC20Snapshot: nonexistent id");
1399 
1400         // When a valid snapshot is queried, there are three possibilities:
1401         //  a) The queried value was not modified after the snapshot was taken. Therefore, a snapshot entry was never
1402         //  created for this id, and all stored snapshot ids are smaller than the requested one. The value that corresponds
1403         //  to this id is the current one.
1404         //  b) The queried value was modified after the snapshot was taken. Therefore, there will be an entry with the
1405         //  requested id, and its value is the one to return.
1406         //  c) More snapshots were created after the requested one, and the queried value was later modified. There will be
1407         //  no entry for the requested id: the value that corresponds to it is that of the smallest snapshot id that is
1408         //  larger than the requested one.
1409         //
1410         // In summary, we need to find an element in an array, returning the index of the smallest value that is larger if
1411         // it is not found, unless said value doesn't exist (e.g. when all values are smaller). Arrays.findUpperBound does
1412         // exactly this.
1413 
1414         uint256 index = snapshots.ids.findUpperBound(snapshotId);
1415 
1416         if (index == snapshots.ids.length) {
1417             return (false, 0);
1418         } else {
1419             return (true, snapshots.values[index]);
1420         }
1421     }
1422 
1423     function _updateAccountSnapshot(address account) private {
1424         _updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));
1425     }
1426 
1427     function _updateTotalSupplySnapshot() private {
1428         _updateSnapshot(_totalSupplySnapshots, totalSupply());
1429     }
1430 
1431     function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {
1432         uint256 currentId = _getCurrentSnapshotId();
1433         if (_lastSnapshotId(snapshots.ids) < currentId) {
1434             snapshots.ids.push(currentId);
1435             snapshots.values.push(currentValue);
1436         }
1437     }
1438 
1439     function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {
1440         if (ids.length == 0) {
1441             return 0;
1442         } else {
1443             return ids[ids.length - 1];
1444         }
1445     }
1446 
1447      //to receive ETH from uniswapV2Router when swaping
1448     receive() external payable {}
1449 }