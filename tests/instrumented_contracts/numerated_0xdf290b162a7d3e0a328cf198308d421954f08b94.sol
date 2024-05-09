1 //SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 library SafeMath {
5     /**
6      * @dev Returns the addition of two unsigned integers, with an overflow flag.
7      *
8      * _Available since v3.4._
9      */
10     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
11         uint256 c = a + b;
12         if (c < a) return (false, 0);
13         return (true, c);
14     }
15 
16     /**
17      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
18      *
19      * _Available since v3.4._
20      */
21     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
22         if (b > a) return (false, 0);
23         return (true, a - b);
24     }
25 
26     /**
27      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
28      *
29      * _Available since v3.4._
30      */
31     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
32         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
33         // benefit is lost if 'b' is also tested.
34         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
35         if (a == 0) return (true, 0);
36         uint256 c = a * b;
37         if (c / a != b) return (false, 0);
38         return (true, c);
39     }
40 
41     /**
42      * @dev Returns the division of two unsigned integers, with a division by zero flag.
43      *
44      * _Available since v3.4._
45      */
46     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
47         if (b == 0) return (false, 0);
48         return (true, a / b);
49     }
50 
51     /**
52      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
53      *
54      * _Available since v3.4._
55      */
56     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
57         if (b == 0) return (false, 0);
58         return (true, a % b);
59     }
60 
61     /**
62      * @dev Returns the addition of two unsigned integers, reverting on
63      * overflow.
64      *
65      * Counterpart to Solidity's `+` operator.
66      *
67      * Requirements:
68      *
69      * - Addition cannot overflow.
70      */
71     function add(uint256 a, uint256 b) internal pure returns (uint256) {
72         uint256 c = a + b;
73         require(c >= a, "SafeMath: addition overflow");
74         return c;
75     }
76 
77     /**
78      * @dev Returns the subtraction of two unsigned integers, reverting on
79      * overflow (when the result is negative).
80      *
81      * Counterpart to Solidity's `-` operator.
82      *
83      * Requirements:
84      *
85      * - Subtraction cannot overflow.
86      */
87     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
88         require(b <= a, "SafeMath: subtraction overflow");
89         return a - b;
90     }
91 
92     /**
93      * @dev Returns the multiplication of two unsigned integers, reverting on
94      * overflow.
95      *
96      * Counterpart to Solidity's `*` operator.
97      *
98      * Requirements:
99      *
100      * - Multiplication cannot overflow.
101      */
102     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
103         if (a == 0) return 0;
104         uint256 c = a * b;
105         require(c / a == b, "SafeMath: multiplication overflow");
106         return c;
107     }
108 
109     /**
110      * @dev Returns the integer division of two unsigned integers, reverting on
111      * division by zero. The result is rounded towards zero.
112      *
113      * Counterpart to Solidity's `/` operator. Note: this function uses a
114      * `revert` opcode (which leaves remaining gas untouched) while Solidity
115      * uses an invalid opcode to revert (consuming all remaining gas).
116      *
117      * Requirements:
118      *
119      * - The divisor cannot be zero.
120      */
121     function div(uint256 a, uint256 b) internal pure returns (uint256) {
122         require(b > 0, "SafeMath: division by zero");
123         return a / b;
124     }
125 
126     /**
127      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
128      * reverting when dividing by zero.
129      *
130      * Counterpart to Solidity's `%` operator. This function uses a `revert`
131      * opcode (which leaves remaining gas untouched) while Solidity uses an
132      * invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      *
136      * - The divisor cannot be zero.
137      */
138     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
139         require(b > 0, "SafeMath: modulo by zero");
140         return a % b;
141     }
142 
143     /**
144      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
145      * overflow (when the result is negative).
146      *
147      * CAUTION: This function is deprecated because it requires allocating memory for the error
148      * message unnecessarily. For custom revert reasons use {trySub}.
149      *
150      * Counterpart to Solidity's `-` operator.
151      *
152      * Requirements:
153      *
154      * - Subtraction cannot overflow.
155      */
156     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
157         require(b <= a, errorMessage);
158         return a - b;
159     }
160 
161     /**
162      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
163      * division by zero. The result is rounded towards zero.
164      *
165      * CAUTION: This function is deprecated because it requires allocating memory for the error
166      * message unnecessarily. For custom revert reasons use {tryDiv}.
167      *
168      * Counterpart to Solidity's `/` operator. Note: this function uses a
169      * `revert` opcode (which leaves remaining gas untouched) while Solidity
170      * uses an invalid opcode to revert (consuming all remaining gas).
171      *
172      * Requirements:
173      *
174      * - The divisor cannot be zero.
175      */
176     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
177         require(b > 0, errorMessage);
178         return a / b;
179     }
180 
181     /**
182      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
183      * reverting with custom message when dividing by zero.
184      *
185      * CAUTION: This function is deprecated because it requires allocating memory for the error
186      * message unnecessarily. For custom revert reasons use {tryMod}.
187      *
188      * Counterpart to Solidity's `%` operator. This function uses a `revert`
189      * opcode (which leaves remaining gas untouched) while Solidity uses an
190      * invalid opcode to revert (consuming all remaining gas).
191      *
192      * Requirements:
193      *
194      * - The divisor cannot be zero.
195      */
196     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
197         require(b > 0, errorMessage);
198         return a % b;
199     }
200 }
201 
202 abstract contract Context {
203     function _msgSender() internal view virtual returns (address) {
204         return msg.sender;
205     }
206 
207     function _msgData() internal view virtual returns (bytes calldata) {
208         return msg.data;
209     }
210 }
211 
212 abstract contract Ownable is Context {
213     address private _owner;
214 
215     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
216 
217     /**
218      * @dev Initializes the contract setting the deployer as the initial owner.
219      */
220     constructor() {
221         _transferOwnership(_msgSender());
222     }
223 
224     /**
225      * @dev Returns the address of the current owner.
226      */
227     function owner() public view virtual returns (address) {
228         return _owner;
229     }
230 
231     /**
232      * @dev Throws if called by any account other than the owner.
233      */
234     modifier onlyOwner() {
235         require(owner() == _msgSender(), "Ownable: caller is not the owner");
236         _;
237     }
238 
239     /**
240      * @dev Leaves the contract without owner. It will not be possible to call
241      * `onlyOwner` functions anymore. Can only be called by the current owner.
242      *
243      * NOTE: Renouncing ownership will leave the contract without an owner,
244      * thereby removing any functionality that is only available to the owner.
245      */
246     function renounceOwnership() public virtual onlyOwner {
247         _transferOwnership(address(0));
248     }
249 
250     /**
251      * @dev Transfers ownership of the contract to a new account (`newOwner`).
252      * Can only be called by the current owner.
253      */
254     function transferOwnership(address newOwner) public virtual onlyOwner {
255         require(newOwner != address(0), "Ownable: new owner is the zero address");
256         _transferOwnership(newOwner);
257     }
258 
259     /**
260      * @dev Transfers ownership of the contract to a new account (`newOwner`).
261      * Internal function without access restriction.
262      */
263     function _transferOwnership(address newOwner) internal virtual {
264         address oldOwner = _owner;
265         _owner = newOwner;
266         emit OwnershipTransferred(oldOwner, newOwner);
267     }
268 }
269 
270 library Address {
271     /**
272      * @dev Returns true if `account` is a contract.
273      *
274      * [IMPORTANT]
275      * ====
276      * It is unsafe to assume that an address for which this function returns
277      * false is an externally-owned account (EOA) and not a contract.
278      *
279      * Among others, `isContract` will return false for the following
280      * types of addresses:
281      *
282      *  - an externally-owned account
283      *  - a contract in construction
284      *  - an address where a contract will be created
285      *  - an address where a contract lived, but was destroyed
286      * ====
287      */
288     function isContract(address account) internal view returns (bool) {
289         // This method relies on extcodesize, which returns 0 for contracts in
290         // construction, since the code is only stored at the end of the
291         // constructor execution.
292 
293         uint256 size;
294         assembly {
295             size := extcodesize(account)
296         }
297         return size > 0;
298     }
299 
300     /**
301      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
302      * `recipient`, forwarding all available gas and reverting on errors.
303      *
304      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
305      * of certain opcodes, possibly making contracts go over the 2300 gas limit
306      * imposed by `transfer`, making them unable to receive funds via
307      * `transfer`. {sendValue} removes this limitation.
308      *
309      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
310      *
311      * IMPORTANT: because control is transferred to `recipient`, care must be
312      * taken to not create reentrancy vulnerabilities. Consider using
313      * {ReentrancyGuard} or the
314      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
315      */
316     function sendValue(address payable recipient, uint256 amount) internal {
317         require(address(this).balance >= amount, "Address: insufficient balance");
318 
319         (bool success, ) = recipient.call{value: amount}("");
320         require(success, "Address: unable to send value, recipient may have reverted");
321     }
322 
323     /**
324      * @dev Performs a Solidity function call using a low level `call`. A
325      * plain `call` is an unsafe replacement for a function call: use this
326      * function instead.
327      *
328      * If `target` reverts with a revert reason, it is bubbled up by this
329      * function (like regular Solidity function calls).
330      *
331      * Returns the raw returned data. To convert to the expected return value,
332      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
333      *
334      * Requirements:
335      *
336      * - `target` must be a contract.
337      * - calling `target` with `data` must not revert.
338      *
339      * _Available since v3.1._
340      */
341     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
342         return functionCall(target, data, "Address: low-level call failed");
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
347      * `errorMessage` as a fallback revert reason when `target` reverts.
348      *
349      * _Available since v3.1._
350      */
351     function functionCall(
352         address target,
353         bytes memory data,
354         string memory errorMessage
355     ) internal returns (bytes memory) {
356         return functionCallWithValue(target, data, 0, errorMessage);
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
370     function functionCallWithValue(
371         address target,
372         bytes memory data,
373         uint256 value
374     ) internal returns (bytes memory) {
375         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
380      * with `errorMessage` as a fallback revert reason when `target` reverts.
381      *
382      * _Available since v3.1._
383      */
384     function functionCallWithValue(
385         address target,
386         bytes memory data,
387         uint256 value,
388         string memory errorMessage
389     ) internal returns (bytes memory) {
390         require(address(this).balance >= value, "Address: insufficient balance for call");
391         require(isContract(target), "Address: call to non-contract");
392 
393         (bool success, bytes memory returndata) = target.call{value: value}(data);
394         return verifyCallResult(success, returndata, errorMessage);
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
399      * but performing a static call.
400      *
401      * _Available since v3.3._
402      */
403     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
404         return functionStaticCall(target, data, "Address: low-level static call failed");
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
409      * but performing a static call.
410      *
411      * _Available since v3.3._
412      */
413     function functionStaticCall(
414         address target,
415         bytes memory data,
416         string memory errorMessage
417     ) internal view returns (bytes memory) {
418         require(isContract(target), "Address: static call to non-contract");
419 
420         (bool success, bytes memory returndata) = target.staticcall(data);
421         return verifyCallResult(success, returndata, errorMessage);
422     }
423 
424     /**
425      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
426      * but performing a delegate call.
427      *
428      * _Available since v3.4._
429      */
430     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
431         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
436      * but performing a delegate call.
437      *
438      * _Available since v3.4._
439      */
440     function functionDelegateCall(
441         address target,
442         bytes memory data,
443         string memory errorMessage
444     ) internal returns (bytes memory) {
445         require(isContract(target), "Address: delegate call to non-contract");
446 
447         (bool success, bytes memory returndata) = target.delegatecall(data);
448         return verifyCallResult(success, returndata, errorMessage);
449     }
450 
451     /**
452      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
453      * revert reason using the provided one.
454      *
455      * _Available since v4.3._
456      */
457     function verifyCallResult(
458         bool success,
459         bytes memory returndata,
460         string memory errorMessage
461     ) internal pure returns (bytes memory) {
462         if (success) {
463             return returndata;
464         } else {
465             // Look for revert reason and bubble it up if present
466             if (returndata.length > 0) {
467                 // The easiest way to bubble the revert reason is using memory via assembly
468 
469                 assembly {
470                     let returndata_size := mload(returndata)
471                     revert(add(32, returndata), returndata_size)
472                 }
473             } else {
474                 revert(errorMessage);
475             }
476         }
477     }
478 }
479 
480 interface IERC20 {
481     /**
482      * @dev Returns the amount of tokens in existence.
483      */
484     function totalSupply() external view returns (uint256);
485 
486     /**
487      * @dev Returns the amount of tokens owned by `account`.
488      */
489     function balanceOf(address account) external view returns (uint256);
490 
491     /**
492      * @dev Moves `amount` tokens from the caller's account to `recipient`.
493      *
494      * Returns a boolean value indicating whether the operation succeeded.
495      *
496      * Emits a {Transfer} event.
497      */
498     function transfer(address recipient, uint256 amount) external returns (bool);
499 
500     /**
501      * @dev Returns the remaining number of tokens that `spender` will be
502      * allowed to spend on behalf of `owner` through {transferFrom}. This is
503      * zero by default.
504      *
505      * This value changes when {approve} or {transferFrom} are called.
506      */
507     function allowance(address owner, address spender) external view returns (uint256);
508 
509     /**
510      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
511      *
512      * Returns a boolean value indicating whether the operation succeeded.
513      *
514      * IMPORTANT: Beware that changing an allowance with this method brings the risk
515      * that someone may use both the old and the new allowance by unfortunate
516      * transaction ordering. One possible solution to mitigate this race
517      * condition is to first reduce the spender's allowance to 0 and set the
518      * desired value afterwards:
519      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
520      *
521      * Emits an {Approval} event.
522      */
523     function approve(address spender, uint256 amount) external returns (bool);
524 
525     /**
526      * @dev Moves `amount` tokens from `sender` to `recipient` using the
527      * allowance mechanism. `amount` is then deducted from the caller's
528      * allowance.
529      *
530      * Returns a boolean value indicating whether the operation succeeded.
531      *
532      * Emits a {Transfer} event.
533      */
534     function transferFrom(
535         address sender,
536         address recipient,
537         uint256 amount
538     ) external returns (bool);
539 
540     /**
541      * @dev Emitted when `value` tokens are moved from one account (`from`) to
542      * another (`to`).
543      *
544      * Note that `value` may be zero.
545      */
546     event Transfer(address indexed from, address indexed to, uint256 value);
547 
548     /**
549      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
550      * a call to {approve}. `value` is the new allowance.
551      */
552     event Approval(address indexed owner, address indexed spender, uint256 value);
553 }
554 
555 interface IUniswapV2Pair {
556     event Approval(address indexed owner, address indexed spender, uint value);
557     event Transfer(address indexed from, address indexed to, uint value);
558 
559     function name() external pure returns (string memory);
560     function symbol() external pure returns (string memory);
561     function decimals() external pure returns (uint8);
562     function totalSupply() external view returns (uint);
563     function balanceOf(address owner) external view returns (uint);
564     function allowance(address owner, address spender) external view returns (uint);
565 
566     function approve(address spender, uint value) external returns (bool);
567     function transfer(address to, uint value) external returns (bool);
568     function transferFrom(address from, address to, uint value) external returns (bool);
569 
570     function DOMAIN_SEPARATOR() external view returns (bytes32);
571     function PERMIT_TYPEHASH() external pure returns (bytes32);
572     function nonces(address owner) external view returns (uint);
573 
574     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
575 
576     event Mint(address indexed sender, uint amount0, uint amount1);
577     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
578     event Swap(
579         address indexed sender,
580         uint amount0In,
581         uint amount1In,
582         uint amount0Out,
583         uint amount1Out,
584         address indexed to
585     );
586     event Sync(uint112 reserve0, uint112 reserve1);
587 
588     function MINIMUM_LIQUIDITY() external pure returns (uint);
589     function factory() external view returns (address);
590     function token0() external view returns (address);
591     function token1() external view returns (address);
592     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
593     function price0CumulativeLast() external view returns (uint);
594     function price1CumulativeLast() external view returns (uint);
595     function kLast() external view returns (uint);
596 
597     function mint(address to) external returns (uint liquidity);
598     function burn(address to) external returns (uint amount0, uint amount1);
599     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
600     function skim(address to) external;
601     function sync() external;
602 
603     function initialize(address, address) external;
604 }
605 
606 interface IUniswapV2Factory {
607     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
608 
609     function feeTo() external view returns (address);
610     function feeToSetter() external view returns (address);
611     function migrator() external view returns (address);
612 
613     function getPair(address tokenA, address tokenB) external view returns (address pair);
614     function allPairs(uint) external view returns (address pair);
615     function allPairsLength() external view returns (uint);
616 
617     function createPair(address tokenA, address tokenB) external returns (address pair);
618 
619     function setFeeTo(address) external;
620     function setFeeToSetter(address) external;
621     function setMigrator(address) external;
622 }
623 
624 interface IUniswapV2Router01 {
625     function factory() external pure returns (address);
626     function WETH() external pure returns (address);
627 
628     function addLiquidity(
629         address tokenA,
630         address tokenB,
631         uint amountADesired,
632         uint amountBDesired,
633         uint amountAMin,
634         uint amountBMin,
635         address to,
636         uint deadline
637     ) external returns (uint amountA, uint amountB, uint liquidity);
638     function addLiquidityETH(
639         address token,
640         uint amountTokenDesired,
641         uint amountTokenMin,
642         uint amountETHMin,
643         address to,
644         uint deadline
645     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
646     function removeLiquidity(
647         address tokenA,
648         address tokenB,
649         uint liquidity,
650         uint amountAMin,
651         uint amountBMin,
652         address to,
653         uint deadline
654     ) external returns (uint amountA, uint amountB);
655     function removeLiquidityETH(
656         address token,
657         uint liquidity,
658         uint amountTokenMin,
659         uint amountETHMin,
660         address to,
661         uint deadline
662     ) external returns (uint amountToken, uint amountETH);
663     function removeLiquidityWithPermit(
664         address tokenA,
665         address tokenB,
666         uint liquidity,
667         uint amountAMin,
668         uint amountBMin,
669         address to,
670         uint deadline,
671         bool approveMax, uint8 v, bytes32 r, bytes32 s
672     ) external returns (uint amountA, uint amountB);
673     function removeLiquidityETHWithPermit(
674         address token,
675         uint liquidity,
676         uint amountTokenMin,
677         uint amountETHMin,
678         address to,
679         uint deadline,
680         bool approveMax, uint8 v, bytes32 r, bytes32 s
681     ) external returns (uint amountToken, uint amountETH);
682     function swapExactTokensForTokens(
683         uint amountIn,
684         uint amountOutMin,
685         address[] calldata path,
686         address to,
687         uint deadline
688     ) external returns (uint[] memory amounts);
689     function swapTokensForExactTokens(
690         uint amountOut,
691         uint amountInMax,
692         address[] calldata path,
693         address to,
694         uint deadline
695     ) external returns (uint[] memory amounts);
696     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
697         external
698         payable
699         returns (uint[] memory amounts);
700     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
701         external
702         returns (uint[] memory amounts);
703     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
704         external
705         returns (uint[] memory amounts);
706     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
707         external
708         payable
709         returns (uint[] memory amounts);
710 
711     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
712     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
713     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
714     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
715     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
716 }
717 
718 interface IUniswapV2Router02 is IUniswapV2Router01 {
719     function removeLiquidityETHSupportingFeeOnTransferTokens(
720         address token,
721         uint liquidity,
722         uint amountTokenMin,
723         uint amountETHMin,
724         address to,
725         uint deadline
726     ) external returns (uint amountETH);
727     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
728         address token,
729         uint liquidity,
730         uint amountTokenMin,
731         uint amountETHMin,
732         address to,
733         uint deadline,
734         bool approveMax, uint8 v, bytes32 r, bytes32 s
735     ) external returns (uint amountETH);
736 
737     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
738         uint amountIn,
739         uint amountOutMin,
740         address[] calldata path,
741         address to,
742         uint deadline
743     ) external;
744     function swapExactETHForTokensSupportingFeeOnTransferTokens(
745         uint amountOutMin,
746         address[] calldata path,
747         address to,
748         uint deadline
749     ) external payable;
750     function swapExactTokensForETHSupportingFeeOnTransferTokens(
751         uint amountIn,
752         uint amountOutMin,
753         address[] calldata path,
754         address to,
755         uint deadline
756     ) external;
757 }
758  
759 contract ERC20 is Context, IERC20, Ownable {
760     using SafeMath for uint256;
761 
762     mapping (address => uint256) private _balances;
763     mapping (address => mapping (address => uint256)) private _allowances;
764 
765     uint256 private _totalSupply;
766 
767     string private _name;
768     string private _symbol;
769     uint8 private _decimals;
770 
771     mapping (address => bool) private _liquidityHolders;
772     mapping (address => bool) private _isSniper;
773     bool public _hasLiqBeenAdded = false;
774     uint256 private _liqAddBlock = 0;
775     uint256 private snipeBlockAmt;
776     uint256 public snipersCaught = 0;
777     
778     IUniswapV2Router02 public uniswapV2Router;
779     address public  uniswapV2Pair;
780     address public  uniswapV2RouterAddress;
781 
782     event SniperCaught(address sniperAddress);
783 
784     constructor (string memory name_, string memory symbol_, address uniswapRouter, uint256 totalMint, uint256 _snipeBlockAmt) {
785         _name = name_;
786         _symbol = symbol_;
787         _decimals = 18;
788         _mint(msg.sender, totalMint); // only called once in contract intialization
789         uniswapV2RouterAddress = uniswapRouter;
790         
791         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(uniswapV2RouterAddress);
792          // Create a uniswap pair for this new token
793         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
794             .createPair(address(this), _uniswapV2Router.WETH());
795 
796         uniswapV2Router = _uniswapV2Router;
797         uniswapV2Pair = _uniswapV2Pair;
798         snipeBlockAmt = _snipeBlockAmt;
799         
800         addLiquidityHolder(msg.sender);
801     }
802 
803     /**
804      * @dev Returns the name of the token.
805      */
806     function name() public view virtual returns (string memory) {
807         return _name;
808     }
809 
810     /**
811      * @dev Returns the symbol of the token, usually a shorter version of the
812      * name.
813      */
814     function symbol() public view virtual returns (string memory) {
815         return _symbol;
816     }
817 
818     /**
819      * @dev Returns the number of decimals used to get its user representation.
820      * For example, if `decimals` equals `2`, a balance of `505` tokens should
821      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
822      *
823      * Tokens usually opt for a value of 18, imitating the relationship between
824      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
825      * called.
826      *
827      * NOTE: This information is only used for _display_ purposes: it in
828      * no way affects any of the arithmetic of the contract, including
829      * {IERC20-balanceOf} and {IERC20-transfer}.
830      */
831     function decimals() public view virtual returns (uint8) {
832         return _decimals;
833     }
834 
835     /**
836      * @dev See {IERC20-totalSupply}.
837      */
838     function totalSupply() public view virtual override returns (uint256) {
839         return _totalSupply;
840     }
841 
842     /**
843      * @dev See {IERC20-balanceOf}.
844      */
845     function balanceOf(address account) public view virtual override returns (uint256) {
846         return _balances[account];
847     }
848 
849     /**
850      * @dev See {IERC20-transfer}.
851      *
852      * Requirements:
853      *
854      * - `recipient` cannot be the zero address.
855      * - the caller must have a balance of at least `amount`.
856      */
857     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
858         _transfer(_msgSender(), recipient, amount);
859         return true;
860     }
861 
862     /**
863      * @dev See {IERC20-allowance}.
864      */
865     function allowance(address owner, address spender) public view virtual override returns (uint256) {
866         return _allowances[owner][spender];
867     }
868 
869     /**
870      * @dev See {IERC20-approve}.
871      *
872      * Requirements:
873      *
874      * - `spender` cannot be the zero address.
875      */
876     function approve(address spender, uint256 amount) public virtual override returns (bool) {
877         _approve(_msgSender(), spender, amount);
878         return true;
879     }
880 
881     /**
882      * @dev See {IERC20-transferFrom}.
883      *
884      * Emits an {Approval} event indicating the updated allowance. This is not
885      * required by the EIP. See the note at the beginning of {ERC20}.
886      *
887      * Requirements:
888      *
889      * - `sender` and `recipient` cannot be the zero address.
890      * - `sender` must have a balance of at least `amount`.
891      * - the caller must have allowance for ``sender``'s tokens of at least
892      * `amount`.
893      */
894     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
895         _transfer(sender, recipient, amount);
896         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
897         return true;
898     }
899 
900     /**
901      * @dev Atomically increases the allowance granted to `spender` by the caller.
902      *
903      * This is an alternative to {approve} that can be used as a mitigation for
904      * problems described in {IERC20-approve}.
905      *
906      * Emits an {Approval} event indicating the updated allowance.
907      *
908      * Requirements:
909      *
910      * - `spender` cannot be the zero address.
911      */
912     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
913         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
914         return true;
915     }
916 
917     /**
918      * @dev Atomically decreases the allowance granted to `spender` by the caller.
919      *
920      * This is an alternative to {approve} that can be used as a mitigation for
921      * problems described in {IERC20-approve}.
922      *
923      * Emits an {Approval} event indicating the updated allowance.
924      *
925      * Requirements:
926      *
927      * - `spender` cannot be the zero address.
928      * - `spender` must have allowance for the caller of at least
929      * `subtractedValue`.
930      */
931     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
932         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
933         return true;
934     }
935 
936     /**
937      * @dev Moves tokens `amount` from `sender` to `recipient`.
938      *
939      * This is internal function is equivalent to {transfer}, and can be used to
940      * e.g. implement automatic token fees, slashing mechanisms, etc.
941      *
942      * Emits a {Transfer} event.
943      *
944      * Requirements:
945      *
946      * - `sender` cannot be the zero address.
947      * - `recipient` cannot be the zero address.
948      * - `sender` must have a balance of at least `amount`.
949      */
950     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
951         require(sender != address(0), "ERC20: transfer from the zero address");
952         require(recipient != address(0), "ERC20: transfer to the zero address");
953         require(!_isSniper[sender], "ERC20: snipers can not transfer");
954         require(!_isSniper[recipient], "ERC20: snipers can not transfer");
955         require(!_isSniper[msg.sender], "ERC20: snipers can not transfer");
956 
957         _beforeTokenTransfer(sender, recipient, amount);
958         
959         if (!_hasLiqBeenAdded) {
960             _checkLiquidityAdd(sender, recipient);
961         } else {
962             if (_liqAddBlock > 0 
963                 && sender == uniswapV2Pair 
964                 && !_liquidityHolders[sender]
965                 && !_liquidityHolders[recipient]
966             ) {
967                 if (block.number - _liqAddBlock < snipeBlockAmt) {
968                     _isSniper[recipient] = true;
969                     snipersCaught ++;
970                     emit SniperCaught(recipient); //pow
971                 }
972             }
973         }
974 
975         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
976         _balances[recipient] = _balances[recipient].add(amount);
977         emit Transfer(sender, recipient, amount);
978     }
979 
980     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
981      * the total supply.
982      *
983      * Emits a {Transfer} event with `from` set to the zero address.
984      *
985      * Requirements:
986      *
987      * - `to` cannot be the zero address.
988      */
989     function _mint(address account, uint256 amount) internal virtual {
990         require(account != address(0), "ERC20: mint to the zero address");
991 
992         _beforeTokenTransfer(address(0), account, amount);
993 
994         _totalSupply = _totalSupply.add(amount);
995         _balances[account] = _balances[account].add(amount);
996         emit Transfer(address(0), account, amount);
997     }
998 
999     /**
1000      * @dev Destroys `amount` tokens from `account`, reducing the
1001      * total supply.
1002      *
1003      * Emits a {Transfer} event with `to` set to the zero address.
1004      *
1005      * Requirements:
1006      *
1007      * - `account` cannot be the zero address.
1008      * - `account` must have at least `amount` tokens.
1009      */
1010     function _burn(address account, uint256 amount) internal virtual {
1011         require(account != address(0), "ERC20: burn from the zero address");
1012 
1013         _beforeTokenTransfer(account, address(0), amount);
1014 
1015         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1016         _totalSupply = _totalSupply.sub(amount);
1017         emit Transfer(account, address(0), amount);
1018     }
1019 
1020     /**
1021      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1022      *
1023      * This internal function is equivalent to `approve`, and can be used to
1024      * e.g. set automatic allowances for certain subsystems, etc.
1025      *
1026      * Emits an {Approval} event.
1027      *
1028      * Requirements:
1029      *
1030      * - `owner` cannot be the zero address.
1031      * - `spender` cannot be the zero address.
1032      */
1033     function _approve(address owner, address spender, uint256 amount) internal virtual {
1034         require(owner != address(0), "ERC20: approve from the zero address");
1035         require(spender != address(0), "ERC20: approve to the zero address");
1036 
1037         _allowances[owner][spender] = amount;
1038         emit Approval(owner, spender, amount);
1039     }
1040 
1041     /**
1042      * @dev Sets {decimals} to a value other than the default one of 18.
1043      *
1044      * WARNING: This function should only be called from the constructor. Most
1045      * applications that interact with token contracts will not expect
1046      * {decimals} to ever change, and may work incorrectly if it does.
1047      */
1048     function _setupDecimals(uint8 decimals_) internal virtual {
1049         _decimals = decimals_;
1050     }
1051 
1052     /**
1053      * @dev Hook that is called before any transfer of tokens. This includes
1054      * minting and burning.
1055      *
1056      * Calling conditions:
1057      *
1058      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1059      * will be to transferred to `to`.
1060      * - when `from` is zero, `amount` tokens will be minted for `to`.
1061      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1062      * - `from` and `to` are never both zero.
1063      *
1064      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1065      */
1066     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1067     
1068     function _checkLiquidityAdd(address from, address to) private {
1069         require(!_hasLiqBeenAdded, "Liquidity already added and marked.");
1070         if (_liquidityHolders[from] && to == uniswapV2Pair) {
1071             _hasLiqBeenAdded = true;
1072             _liqAddBlock = block.number;
1073         }
1074     }
1075     
1076     function isSniperCheck(address account) public view returns (bool) {
1077         return _isSniper[account];
1078     }
1079     
1080     function isLiquidityHolderCheck(address account) public view returns (bool) {
1081         return _liquidityHolders[account];
1082     }
1083     
1084     function addSniper(address sniperAddress) public onlyOwner() {
1085         require(sniperAddress != uniswapV2Pair, "ERC20: Can not add uniswapV2Pair to sniper list");
1086         require(sniperAddress != uniswapV2RouterAddress, "ERC20: Can not add uniswapV2Router to sniper list");
1087 
1088         _isSniper[sniperAddress] = true;
1089     }
1090     
1091     function removeSniper(address sniperAddress) public onlyOwner() {
1092         require(_isSniper[sniperAddress], "ERC20: Is not sniper");
1093 
1094         _isSniper[sniperAddress] = false;
1095     }
1096     
1097     function addLiquidityHolder(address liquidityHolder) public onlyOwner() {
1098         _liquidityHolders[liquidityHolder] = true;
1099     }
1100     
1101     function removeLiquidityHolder(address liquidityHolder) public onlyOwner() {
1102         _liquidityHolders[liquidityHolder] = false;
1103     }
1104 }