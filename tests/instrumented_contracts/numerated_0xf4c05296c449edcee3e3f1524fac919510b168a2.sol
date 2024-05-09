1 /*
2   ________            ___    __                    __                 ____             __                   __
3  /_  __/ /_  ___     /   |  / /_  _________  _____/ /_  ___  _____   / __ \_________  / /_____  _________  / /
4   / / / __ \/ _ \   / /| | / __ \/ ___/ __ \/ ___/ __ \/ _ \/ ___/  / /_/ / ___/ __ \/ __/ __ \/ ___/ __ \/ / 
5  / / / / / /  __/  / ___ |/ /_/ (__  ) /_/ / /  / /_/ /  __/ /     / ____/ /  / /_/ / /_/ /_/ / /__/ /_/ / /  
6 /_/ /_/ /_/\___/  /_/  |_/_.___/____/\____/_/  /_.___/\___/_/     /_/   /_/   \____/\__/\____/\___/\____/_/   
7                                                                                                               
8    __  ___     _        _____          __               __ 
9   /  |/  /__ _(_)__    / ___/__  ___  / /________ _____/ /_
10  / /|_/ / _ `/ / _ \  / /__/ _ \/ _ \/ __/ __/ _ `/ __/ __/
11 /_/  /_/\_,_/_/_//_/  \___/\___/_//_/\__/_/  \_,_/\__/\__/ 
12                                                            
13 */
14 
15 pragma solidity ^0.6.0;
16 //SPDX-License-Identifier: MIT
17 
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address payable) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 /**
30  * @dev Contract module which provides a basic access control mechanism, where
31  * there is an account (an owner) that can be granted exclusive access to
32  * specific functions.
33  *
34  * By default, the owner account will be the one that deploys the contract. This
35  * can later be changed with {transferOwnership}.
36  *
37  * This module is used through inheritance. It will make available the modifier
38  * `onlyOwner`, which can be applied to your functions to restrict their use to
39  * the owner.
40  */
41 contract Ownable is Context {
42     address private _owner;
43 
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     /**
47      * @dev Initializes the contract setting the deployer as the initial owner.
48      */
49     constructor () internal {
50         address msgSender = _msgSender();
51         _owner = msgSender;
52         emit OwnershipTransferred(address(0), msgSender);
53     }
54 
55     /**
56      * @dev Returns the address of the current owner.
57      */
58     function owner() public view returns (address) {
59         return _owner;
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         require(_owner == _msgSender(), "Ownable: caller is not the owner");
67         _;
68     }
69 
70     /**
71      * @dev Leaves the contract without owner. It will not be possible to call
72      * `onlyOwner` functions anymore. Can only be called by the current owner.
73      *
74      * NOTE: Renouncing ownership will leave the contract without an owner,
75      * thereby removing any functionality that is only available to the owner.
76      */
77     function renounceOwnership() public virtual onlyOwner {
78         emit OwnershipTransferred(_owner, address(0));
79         _owner = address(0);
80     }
81 
82     /**
83      * @dev Transfers ownership of the contract to a new account (`newOwner`).
84      * Can only be called by the current owner.
85      */
86     function transferOwnership(address newOwner) public virtual onlyOwner {
87         require(newOwner != address(0), "Ownable: new owner is the zero address");
88         emit OwnershipTransferred(_owner, newOwner);
89         _owner = newOwner;
90     }
91 }
92 
93 
94 /**
95  * @dev Wrappers over Solidity's arithmetic operations with added overflow
96  * checks.
97  *
98  * Arithmetic operations in Solidity wrap on overflow. This can easily result
99  * in bugs, because programmers usually assume that an overflow raises an
100  * error, which is the standard behavior in high level programming languages.
101  * `SafeMath` restores this intuition by reverting the transaction when an
102  * operation overflows.
103  *
104  * Using this library instead of the unchecked operations eliminates an entire
105  * class of bugs, so it's recommended to use it always.
106  */
107 library SafeMath {
108     /**
109      * @dev Returns the addition of two unsigned integers, reverting on
110      * overflow.
111      *
112      * Counterpart to Solidity's `+` operator.
113      *
114      * Requirements:
115      *
116      * - Addition cannot overflow.
117      */
118     function add(uint256 a, uint256 b) internal pure returns (uint256) {
119         uint256 c = a + b;
120         require(c >= a, "SafeMath: addition overflow");
121 
122         return c;
123     }
124 
125     /**
126      * @dev Returns the subtraction of two unsigned integers, reverting on
127      * overflow (when the result is negative).
128      *
129      * Counterpart to Solidity's `-` operator.
130      *
131      * Requirements:
132      *
133      * - Subtraction cannot overflow.
134      */
135     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
136         return sub(a, b, "SafeMath: subtraction overflow");
137     }
138 
139     /**
140      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
141      * overflow (when the result is negative).
142      *
143      * Counterpart to Solidity's `-` operator.
144      *
145      * Requirements:
146      *
147      * - Subtraction cannot overflow.
148      */
149     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
150         require(b <= a, errorMessage);
151         uint256 c = a - b;
152 
153         return c;
154     }
155 
156     /**
157      * @dev Returns the multiplication of two unsigned integers, reverting on
158      * overflow.
159      *
160      * Counterpart to Solidity's `*` operator.
161      *
162      * Requirements:
163      *
164      * - Multiplication cannot overflow.
165      */
166     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
167         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
168         // benefit is lost if 'b' is also tested.
169         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
170         if (a == 0) {
171             return 0;
172         }
173 
174         uint256 c = a * b;
175         require(c / a == b, "SafeMath: multiplication overflow");
176 
177         return c;
178     }
179 
180     /**
181      * @dev Returns the integer division of two unsigned integers. Reverts on
182      * division by zero. The result is rounded towards zero.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(uint256 a, uint256 b) internal pure returns (uint256) {
193         return div(a, b, "SafeMath: division by zero");
194     }
195 
196     /**
197      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
198      * division by zero. The result is rounded towards zero.
199      *
200      * Counterpart to Solidity's `/` operator. Note: this function uses a
201      * `revert` opcode (which leaves remaining gas untouched) while Solidity
202      * uses an invalid opcode to revert (consuming all remaining gas).
203      *
204      * Requirements:
205      *
206      * - The divisor cannot be zero.
207      */
208     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
209         require(b > 0, errorMessage);
210         uint256 c = a / b;
211         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
212 
213         return c;
214     }
215 
216     /**
217      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
218      * Reverts when dividing by zero.
219      *
220      * Counterpart to Solidity's `%` operator. This function uses a `revert`
221      * opcode (which leaves remaining gas untouched) while Solidity uses an
222      * invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      *
226      * - The divisor cannot be zero.
227      */
228     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
229         return mod(a, b, "SafeMath: modulo by zero");
230     }
231 
232     /**
233      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
234      * Reverts with custom message when dividing by zero.
235      *
236      * Counterpart to Solidity's `%` operator. This function uses a `revert`
237      * opcode (which leaves remaining gas untouched) while Solidity uses an
238      * invalid opcode to revert (consuming all remaining gas).
239      *
240      * Requirements:
241      *
242      * - The divisor cannot be zero.
243      */
244     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
245         require(b != 0, errorMessage);
246         return a % b;
247     }
248 }
249 
250 /**
251  * @dev Interface of the ERC20 standard as defined in the EIP.
252  */
253 interface IERC20 {
254     /**
255      * @dev Returns the amount of tokens in existence.
256      */
257     function totalSupply() external view returns (uint256);
258 
259     /**
260      * @dev Returns the amount of tokens owned by `account`.
261      */
262     function balanceOf(address account) external view returns (uint256);
263 
264     /**
265      * @dev Moves `amount` tokens from the caller's account to `recipient`.
266      *
267      * Returns a boolean value indicating whether the operation succeeded.
268      *
269      * Emits a {Transfer} event.
270      */
271     function transfer(address recipient, uint256 amount) external returns (bool);
272 
273     /**
274      * @dev Returns the remaining number of tokens that `spender` will be
275      * allowed to spend on behalf of `owner` through {transferFrom}. This is
276      * zero by default.
277      *
278      * This value changes when {approve} or {transferFrom} are called.
279      */
280     function allowance(address owner, address spender) external view returns (uint256);
281 
282     /**
283      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
284      *
285      * Returns a boolean value indicating whether the operation succeeded.
286      *
287      * // importANT: Beware that changing an allowance with this method brings the risk
288      * that someone may use both the old and the new allowance by unfortunate
289      * transaction ordering. One possible solution to mitigate this race
290      * condition is to first reduce the spender's allowance to 0 and set the
291      * desired value afterwards:
292      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
293      *
294      * Emits an {Approval} event.
295      */
296     function approve(address spender, uint256 amount) external returns (bool);
297 
298     /**
299      * @dev Moves `amount` tokens from `sender` to `recipient` using the
300      * allowance mechanism. `amount` is then deducted from the caller's
301      * allowance.
302      *
303      * Returns a boolean value indicating whether the operation succeeded.
304      *
305      * Emits a {Transfer} event.
306      */
307     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
308 
309     /**
310      * @dev Emitted when `value` tokens are moved from one account (`from`) to
311      * another (`to`).
312      *
313      * Note that `value` may be zero.
314      */
315     event Transfer(address indexed from, address indexed to, uint256 value);
316 
317     /**
318      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
319      * a call to {approve}. `value` is the new allowance.
320      */
321     event Approval(address indexed owner, address indexed spender, uint256 value);
322 }
323 
324 
325 
326 /**
327  * @dev Collection of functions related to the address type
328  */
329 library Address {
330     /**
331      * @dev Returns true if `account` is a contract.
332      *
333      * [// importANT]
334      * ====
335      * It is unsafe to assume that an address for which this function returns
336      * false is an externally-owned account (EOA) and not a contract.
337      *
338      * Among others, `isContract` will return false for the following
339      * types of addresses:
340      *
341      *  - an externally-owned account
342      *  - a contract in construction
343      *  - an address where a contract will be created
344      *  - an address where a contract lived, but was destroyed
345      * ====
346      */
347     function isContract(address account) internal view returns (bool) {
348         // This method relies in extcodesize, which returns 0 for contracts in
349         // construction, since the code is only stored at the end of the
350         // constructor execution.
351 
352         uint256 size;
353         // solhint-disable-next-line no-inline-assembly
354         assembly { size := extcodesize(account) }
355         return size > 0;
356     }
357 
358     /**
359      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
360      * `recipient`, forwarding all available gas and reverting on errors.
361      *
362      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
363      * of certain opcodes, possibly making contracts go over the 2300 gas limit
364      * imposed by `transfer`, making them unable to receive funds via
365      * `transfer`. {sendValue} removes this limitation.
366      *
367      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
368      *
369      * // importANT: because control is transferred to `recipient`, care must be
370      * taken to not create reentrancy vulnerabilities. Consider using
371      * {ReentrancyGuard} or the
372      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
373      */
374     function sendValue(address payable recipient, uint256 amount) internal {
375         require(address(this).balance >= amount, "Address: insufficient balance");
376 
377         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
378         (bool success, ) = recipient.call{ value: amount }("");
379         require(success, "Address: unable to send value, recipient may have reverted");
380     }
381 
382     /**
383      * @dev Performs a Solidity function call using a low level `call`. A
384      * plain`call` is an unsafe replacement for a function call: use this
385      * function instead.
386      *
387      * If `target` reverts with a revert reason, it is bubbled up by this
388      * function (like regular Solidity function calls).
389      *
390      * Returns the raw returned data. To convert to the expected return value,
391      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
392      *
393      * Requirements:
394      *
395      * - `target` must be a contract.
396      * - calling `target` with `data` must not revert.
397      *
398      * _Available since v3.1._
399      */
400     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
401       return functionCall(target, data, "Address: low-level call failed");
402     }
403 
404     /**
405      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
406      * `errorMessage` as a fallback revert reason when `target` reverts.
407      *
408      * _Available since v3.1._
409      */
410     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
411         return _functionCallWithValue(target, data, 0, errorMessage);
412     }
413 
414     /**
415      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
416      * but also transferring `value` wei to `target`.
417      *
418      * Requirements:
419      *
420      * - the calling contract must have an ETH balance of at least `value`.
421      * - the called Solidity function must be `payable`.
422      *
423      * _Available since v3.1._
424      */
425     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
426         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
427     }
428 
429     /**
430      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
431      * with `errorMessage` as a fallback revert reason when `target` reverts.
432      *
433      * _Available since v3.1._
434      */
435     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
436         require(address(this).balance >= value, "Address: insufficient balance for call");
437         return _functionCallWithValue(target, data, value, errorMessage);
438     }
439 
440     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
441         require(isContract(target), "Address: call to non-contract");
442 
443         // solhint-disable-next-line avoid-low-level-calls
444         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
445         if (success) {
446             return returndata;
447         } else {
448             // Look for revert reason and bubble it up if present
449             if (returndata.length > 0) {
450                 // The easiest way to bubble the revert reason is using memory via assembly
451 
452                 // solhint-disable-next-line no-inline-assembly
453                 assembly {
454                     let returndata_size := mload(returndata)
455                     revert(add(32, returndata), returndata_size)
456                 }
457             } else {
458                 revert(errorMessage);
459             }
460         }
461     }
462 }
463 
464 
465  /**
466  * @dev Implementation of the {IERC20} interface.
467  *
468  * This implementation is agnostic to the way tokens are created. This means
469  * that a supply mechanism has to be added in a derived contract using {_mint}.
470  * For a generic mechanism see {ERC20PresetMinterPauser}.
471  *
472  * TIP: For a detailed writeup see our guide
473  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
474  * to implement supply mechanisms].
475  *
476  * We have followed general OpenZeppelin guidelines: functions revert instead
477  * of returning `false` on failure. This behavior is nonetheless conventional
478  * and does not conflict with the expectations of ERC20 applications.
479  *
480  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
481  * This allows applications to reconstruct the allowance for all accounts just
482  * by listening to said events. Other implementations of the EIP may not emit
483  * these events, as it isn't required by the specification.
484  *
485  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
486  * functions have been added to mitigate the well-known issues around setting
487  * allowances. See {IERC20-approve}.
488  */
489 
490 interface IUniswapV2Factory {
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
506 
507 // pragma solidity >=0.5.0;
508 
509 interface IUniswapV2ERC20 {
510     event Approval(address indexed owner, address indexed spender, uint value);
511     event Transfer(address indexed from, address indexed to, uint value);
512 
513     function name() external pure returns (string memory);
514     function symbol() external pure returns (string memory);
515     function decimals() external pure returns (uint8);
516     function totalSupply() external view returns (uint);
517     function balanceOf(address owner) external view returns (uint);
518     function allowance(address owner, address spender) external view returns (uint);
519 
520     function approve(address spender, uint value) external returns (bool);
521     function transfer(address to, uint value) external returns (bool);
522     function transferFrom(address from, address to, uint value) external returns (bool);
523 
524     function DOMAIN_SEPARATOR() external view returns (bytes32);
525     function PERMIT_TYPEHASH() external pure returns (bytes32);
526     function nonces(address owner) external view returns (uint);
527 
528     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
529 }
530 
531 
532 
533 interface IUniswapV2Router01 {
534     function factory() external pure returns (address);
535     function WETH() external pure returns (address);
536 
537     function addLiquidity(
538         address tokenA,
539         address tokenB,
540         uint amountADesired,
541         uint amountBDesired,
542         uint amountAMin,
543         uint amountBMin,
544         address to,
545         uint deadline
546     ) external returns (uint amountA, uint amountB, uint liquidity);
547     function addLiquidityETH(
548         address token,
549         uint amountTokenDesired,
550         uint amountTokenMin,
551         uint amountETHMin,
552         address to,
553         uint deadline
554     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
555     function removeLiquidity(
556         address tokenA,
557         address tokenB,
558         uint liquidity,
559         uint amountAMin,
560         uint amountBMin,
561         address to,
562         uint deadline
563     ) external returns (uint amountA, uint amountB);
564     function removeLiquidityETH(
565         address token,
566         uint liquidity,
567         uint amountTokenMin,
568         uint amountETHMin,
569         address to,
570         uint deadline
571     ) external returns (uint amountToken, uint amountETH);
572     function removeLiquidityWithPermit(
573         address tokenA,
574         address tokenB,
575         uint liquidity,
576         uint amountAMin,
577         uint amountBMin,
578         address to,
579         uint deadline,
580         bool approveMax, uint8 v, bytes32 r, bytes32 s
581     ) external returns (uint amountA, uint amountB);
582     function removeLiquidityETHWithPermit(
583         address token,
584         uint liquidity,
585         uint amountTokenMin,
586         uint amountETHMin,
587         address to,
588         uint deadline,
589         bool approveMax, uint8 v, bytes32 r, bytes32 s
590     ) external returns (uint amountToken, uint amountETH);
591     function swapExactTokensForTokens(
592         uint amountIn,
593         uint amountOutMin,
594         address[] calldata path,
595         address to,
596         uint deadline
597     ) external returns (uint[] memory amounts);
598     function swapTokensForExactTokens(
599         uint amountOut,
600         uint amountInMax,
601         address[] calldata path,
602         address to,
603         uint deadline
604     ) external returns (uint[] memory amounts);
605     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
606         external
607         payable
608         returns (uint[] memory amounts);
609     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
610         external
611         returns (uint[] memory amounts);
612     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
613         external
614         returns (uint[] memory amounts);
615     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
616         external
617         payable
618         returns (uint[] memory amounts);
619 
620     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
621     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
622     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
623     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
624     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
625 }
626 
627 
628 
629 interface IUniswapV2Router02 is IUniswapV2Router01 {
630     function removeLiquidityETHSupportingFeeOnTransferTokens(
631         address token,
632         uint liquidity,
633         uint amountTokenMin,
634         uint amountETHMin,
635         address to,
636         uint deadline
637     ) external returns (uint amountETH);
638     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
639         address token,
640         uint liquidity,
641         uint amountTokenMin,
642         uint amountETHMin,
643         address to,
644         uint deadline,
645         bool approveMax, uint8 v, bytes32 r, bytes32 s
646     ) external returns (uint amountETH);
647 
648     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
649         uint amountIn,
650         uint amountOutMin,
651         address[] calldata path,
652         address to,
653         uint deadline
654     ) external;
655     function swapExactETHForTokensSupportingFeeOnTransferTokens(
656         uint amountOutMin,
657         address[] calldata path,
658         address to,
659         uint deadline
660     ) external payable;
661     function swapExactTokensForETHSupportingFeeOnTransferTokens(
662         uint amountIn,
663         uint amountOutMin,
664         address[] calldata path,
665         address to,
666         uint deadline
667     ) external;
668 }
669 
670 abstract contract ReentrancyGuard {
671     // Booleans are more expensive than uint256 or any type that takes up a full
672     // word because each write operation emits an extra SLOAD to first read the
673     // slot's contents, replace the bits taken up by the boolean, and then write
674     // back. This is the compiler's defense against contract upgrades and
675     // pointer aliasing, and it cannot be disabled.
676 
677     // The values being non-zero value makes deployment a bit more expensive,
678     // but in exchange the refund on every call to nonReentrant will be lower in
679     // amount. Since refunds are capped to a percentage of the total
680     // transaction's gas, it is best to keep them low in cases like this one, to
681     // increase the likelihood of the full refund coming into effect.
682     uint256 private constant _NOT_ENTERED = 1;
683     uint256 private constant _ENTERED = 2;
684 
685     uint256 private _status;
686 
687     constructor () internal {
688         _status = _NOT_ENTERED;
689     }
690 
691     /**
692      * @dev Prevents a contract from calling itself, directly or indirectly.
693      * Calling a `nonReentrant` function from another `nonReentrant`
694      * function is not supported. It is possible to prevent this from happening
695      * by making the `nonReentrant` function external, and make it call a
696      * `private` function that does the actual work.
697      */
698     modifier nonReentrant() {
699         // On the first call to nonReentrant, _notEntered will be true
700         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
701 
702         // Any calls to nonReentrant after this point will fail
703         _status = _ENTERED;
704 
705         _;
706 
707         // By storing the original value once again, a refund is triggered (see
708         // https://eips.ethereum.org/EIPS/eip-2200)
709         _status = _NOT_ENTERED;
710     }
711 }
712 
713 
714 contract Absorber is IERC20, Ownable, ReentrancyGuard {
715 
716     using SafeMath for uint256;
717     
718     mapping (address => mapping (address => uint256)) private _allowances;
719     bool transferPaused = true;
720     string private _name = "Absorber";
721     string private _symbol = "ABS";
722     uint8 private _decimals = 18;
723   
724     IUniswapV2Router02 public constant uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
725     address public immutable uniswapV2Pair;
726     address public _burnPool = 0x000000000000000000000000000000000000dEaD;
727     address public presale; 
728     mapping (address => uint256) private _aOwned;
729     mapping (address => uint256) private _tOwned;
730 
731     mapping (address => bool) private _isExcluded;
732     address[] private _excluded;
733    
734     uint256 private constant MAX = ~uint256(0);
735     uint256 private constant _tTotal = 70 * 10**4 * 10**18;
736     uint256 private _aTotal = (MAX - (MAX % _tTotal));
737     uint256 private _tFeeTotal;
738 
739 
740     uint8 public feeDecimals;
741     uint32 public feePercentage;
742     uint256 public minTokensBeforeAddToLP;
743     uint256 feeDivider = 9999999999999999999999999;
744 
745     uint256 internal _minimumSupply; 
746     uint256 public _totalBurnedTokens;
747     uint256 public _totalBurnedLpTokens;
748     uint256 public _balanceOfLpTokens; 
749     
750     bool public inSwapAndAbsorb;
751     bool public swapAndAbsorbEnabled;
752 
753     event FeeUpdated(uint8 feeDecimals, uint32 feePercentage);
754     event MinTokensBeforeAddToLPUpdated(uint256 minTokensBeforeAddToLP);
755     event SwapAndAbsorbEnabledUpdated(bool enabled);
756     event SwapAndAbsorb(
757         uint256 tokensSwapped,
758         uint256 ethReceived,
759         uint256 tokensIntoLiquidity
760     );
761 
762     modifier lockTheAbsorption {
763         inSwapAndAbsorb = true;
764         _;
765         inSwapAndAbsorb = false;
766     }
767 
768     constructor(
769         uint8 _feeDecimals,
770         uint32 _feePercentage,
771         uint256 _minTokensBeforeAddToLP,
772         bool _swapAndAbsorbEnabled,
773         address _presale)public {
774         // Internal ABS creation, minting it directly to the deployer
775         // deployer needs to then seed the pair with some liquidity
776        _aOwned[_msgSender()] = _aTotal;
777         presale = _presale;
778 
779         // Create a uniswap pair for this new token
780         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory())
781             .createPair(address(this), uniswapV2Router.WETH());
782 
783         // set the rest of the contract variables
784 
785         updateFee(_feeDecimals, _feePercentage);
786         updateMinTokensBeforeAddToLP(_minTokensBeforeAddToLP);
787         updateSwapAndAbsorbEnabled(_swapAndAbsorbEnabled);
788         emit Transfer(address(0), _msgSender(), _tTotal);
789     }
790 
791 
792 
793     /**
794      * @dev Returns the name of the token.
795      */
796     function name() public view returns (string memory) {
797         return _name;
798     }
799 
800     /**
801      * @dev Returns the symbol of the token, usually a shorter version of the
802      * name.
803      */
804     function symbol() public view returns (string memory) {
805         return _symbol;
806     }
807 
808     /**
809      * @dev Returns the number of decimals used to get its user representation.
810      * For example, if `decimals` equals `2`, a balance of `505` tokens should
811      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
812      *
813      * Tokens usually opt for a value of 18, imitating the relationship between
814      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
815      * called.
816      *
817      * NOTE: This information is only used for _display_ purposes: it in
818      * no way affects any of the arithmetic of the contract, including
819      * {IERC20-balanceOf} and {IERC20-transfer}.
820      */
821     function decimals() public view returns (uint8) {
822         return _decimals;
823     }
824 
825     /**
826      * @dev See {IERC20-totalSupply}.
827      */
828     function totalSupply() public view override returns (uint256) {
829         return _tTotal;
830     }
831 
832     /**
833      * @dev See {IERC20-balanceOf}.
834      */
835     function balanceOf(address account) public view override returns (uint256) {
836          if (_isExcluded[account]) return _tOwned[account];
837         return tokenFromAllocation(_aOwned[account]);
838     }
839 
840     /**
841      * @dev See {IERC20-transfer}.
842      *
843      * Requirements:
844      *
845      * - `recipient` cannot be the zero address.
846      * - the caller must have a balance of at least `amount`.
847      */
848     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
849         _transfer(_msgSender(), recipient, amount);
850         return true;
851     }
852 
853     /**
854      * @dev See {IERC20-allowance}.
855      */
856     function allowance(address owner, address spender) public view virtual override returns (uint256) {
857         return _allowances[owner][spender];
858     }
859 
860     /**
861      * @dev See {IERC20-approve}.
862      *
863      * Requirements:
864      *
865      * - `spender` cannot be the zero address.
866      */
867     function approve(address spender, uint256 amount) public virtual override returns (bool) {
868         _approve(_msgSender(), spender, amount);
869         return true;
870     }
871 
872     /**
873      * @dev See {IERC20-transferFrom}.
874      *
875      * Emits an {Approval} event indicating the updated allowance. This is not
876      * required by the EIP. See the note at the beginning of {ERC20};
877      *
878      * Requirements:
879      * - `sender` and `recipient` cannot be the zero address.
880      * - `sender` must have a balance of at least `amount`.
881      * - the caller must have allowance for ``sender``'s tokens of at least
882      * `amount`.
883      */
884     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
885         _transfer(sender, recipient, amount);
886         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
887         return true;
888     }
889 
890     /**
891      * @dev Atomically increases the allowance granted to `spender` by the caller.
892      *
893      * This is an alternative to {approve} that can be used as a mitigation for
894      * problems described in {IERC20-approve}.
895      *
896      * Emits an {Approval} event indicating the updated allowance.
897      *
898      * Requirements:
899      *
900      * - `spender` cannot be the zero address.
901      */
902     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
903         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
904         return true;
905     }
906 
907     /**
908      * @dev Atomically decreases the allowance granted to `spender` by the caller.
909      *
910      * This is an alternative to {approve} that can be used as a mitigation for
911      * problems described in {IERC20-approve}.
912      *
913      * Emits an {Approval} event indicating the updated allowance.
914      *
915      * Requirements:
916      *
917      * - `spender` cannot be the zero address.
918      * - `spender` must have allowance for the caller of at least
919      * `subtractedValue`.
920      */
921     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
922         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
923         return true;
924     }
925 
926 function _transfer(
927         address from,
928         address to,
929         uint256 amount
930     ) internal {
931         if (transferPaused){
932            
933           if (to == address(uniswapV2Pair) || to == address(uniswapV2Router) || to == address(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f)){
934             revert(); // IUniswapV2Factory address
935         }
936      }
937         // is the token balance of this contract address over the min number of
938         // tokens that we need to initiate a swap + liquidity lock?
939         // also, don't get caught in a circular liquidity event.
940         // also, don't swap & absorb if sender is the uniswap pair.
941         uint256 contractTokenBalance = balanceOf(address(this));
942         uint256 tokensToLock = calcTokenFee(
943             amount,
944             feeDecimals,
945             feePercentage
946         );
947         if (from == presale) tokensToLock = 0;
948         bool overMinTokenBalance = contractTokenBalance >= minTokensBeforeAddToLP;
949         bool interactWithUniswap = to == uniswapV2Pair; 
950         if (
951             overMinTokenBalance &&
952             !inSwapAndAbsorb &&
953             interactWithUniswap &&
954             swapAndAbsorbEnabled &&
955             from != presale
956         ) {
957             swapAndAbsorb(contractTokenBalance);
958   }
959     if (tokensToLock > 0){
960         if (_isExcluded[from] && !_isExcluded[to]) {
961              _transferFromExcluded(from, address(this), tokensToLock);
962         } else if (!_isExcluded[from] && _isExcluded[to]) {
963              _transferToExcluded(from, address(this), tokensToLock);
964         } else if (!_isExcluded[from] && !_isExcluded[to]) {
965             _transferStandard(from, address(this), tokensToLock);
966         } else if (_isExcluded[from] && _isExcluded[to]) {
967             _transferBothExcluded(from, address(this), tokensToLock);
968         } else {
969             _transferStandard(from, address(this), tokensToLock);
970         }
971     }
972 
973 
974         // take the fee and send those tokens to this contract address
975         // and then send the remainder of tokens to original recipient
976         uint256 tokensToTransfer = amount.sub(tokensToLock);
977         if (_isExcluded[from] && !_isExcluded[to]) {
978             _transferFromExcluded(from, to, tokensToTransfer);
979         } else if (!_isExcluded[from] && _isExcluded[to]) {
980             _transferToExcluded(from, to, tokensToTransfer);
981         } else if (!_isExcluded[from] && !_isExcluded[to]) {
982             _transferStandard(from, to, tokensToTransfer);
983         } else if (_isExcluded[from] && _isExcluded[to]) {
984             _transferBothExcluded(from, to, tokensToTransfer);
985         } else {
986             _transferStandard(from, to, tokensToTransfer);
987         }
988         
989     }
990     
991     function unPauseTransferForever() external nonReentrant {
992         require (msg.sender == presale, "Only the presale contract can call this");
993         transferPaused = false;
994     }
995  
996 
997     /**
998      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
999      *
1000      * This internal function is equivalent to `approve`, and can be used to
1001      * e.g. set automatic allowances for certain subsystems, etc.
1002      *
1003      * Emits an {Approval} event.
1004      *
1005      * Requirements:
1006      *
1007      * - `owner` cannot be the zero address.
1008      * - `spender` cannot be the zero address.
1009      */
1010     function _approve(address owner, address spender, uint256 amount) internal virtual {
1011         require(owner != address(0), "ERC20: approve from the zero address");
1012         require(spender != address(0), "ERC20: approve to the zero address");
1013 
1014         _allowances[owner][spender] = amount;
1015         emit Approval(owner, spender, amount);
1016     }
1017 
1018     /**
1019      * @dev Sets {decimals} to a value other than the default one of 18.
1020      *
1021      * WARNING: This function should only be called from the constructor. Most
1022      * applications that interact with token contracts will not expect
1023      * {decimals} to ever change, and may work incorrectly if it does.
1024      */
1025     function _setupDecimals(uint8 decimals_) internal {
1026         _decimals = decimals_;
1027     }
1028 
1029     /**
1030      * @dev Hook that is called before any transfer of tokens. This includes
1031      * minting and burning.
1032      *
1033      * Calling conditions:
1034      *
1035      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1036      * will be to transferred to `to`.
1037      * - when `from` is zero, `amount` tokens will be minted for `to`.
1038      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1039      * - `from` and `to` are never both zero.
1040      *
1041      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1042      */
1043     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1044 
1045 
1046 
1047     function minimumSupply() external view returns (uint256){ 
1048         return _minimumSupply;
1049     }
1050     
1051     
1052     /*
1053         override the internal _transfer function so that we can
1054         take the fee, and conditionally do the swap + liquditiy
1055     */
1056     
1057     function swapAndAbsorb(uint256 contractTokenBalance) private lockTheAbsorption {
1058         // split the contract balance into halves
1059         uint256 half = contractTokenBalance.div(2);
1060         uint256 otherHalf = contractTokenBalance.sub(half);
1061 
1062         // capture the contract's current ETH balance.
1063         // this is so that we can capture exactly the amount of ETH that the
1064         // swap creates, and not make the liquidity event include any ETH that
1065         // has been manually sent to the contract
1066         uint256 initialBalance = address(this).balance;
1067 
1068         // swap tokens for ETH
1069         swapTokensForEth(half); // <- breaks the ETH -> ABS swap when swap+absorb is triggered
1070 
1071         // how much ETH did we just swap into?
1072         uint256 newBalance = address(this).balance.sub(initialBalance);
1073 
1074         // add liquidity to uniswap
1075         addLiquidity(otherHalf, newBalance);
1076         
1077 
1078         emit SwapAndAbsorb(half, newBalance, otherHalf);
1079     }
1080 
1081     function swapTokensForEth(uint256 tokenAmount) private {
1082         // generate the uniswap pair path of token -> weth
1083         address[] memory path = new address[](2);
1084         path[0] = address(this);
1085         path[1] = uniswapV2Router.WETH();
1086 
1087         _approve(address(this), address(uniswapV2Router), tokenAmount);
1088 
1089         // make the swap
1090         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1091             tokenAmount,
1092             0, // accept any amount of ETH
1093             path,
1094             address(this),
1095             block.timestamp
1096         );
1097     }
1098 
1099     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1100         // approve token transfer to cover all possible scenarios
1101         _approve(address(this), address(uniswapV2Router), tokenAmount);
1102 
1103         // add the liquidity
1104         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1105             address(this),
1106             tokenAmount,
1107             0, // slippage is unavoidable
1108             0, // slippage is unavoidable
1109             address(this),
1110             block.timestamp
1111         );
1112     }
1113 
1114     function updateFeesAndSwapsEnabled(uint8 absFeeDecimals, uint32 absFeePercentage, uint256 absFeeDivider, bool _enabled)
1115         public
1116         onlyOwner
1117         nonReentrant
1118     {
1119         require(absFeeDivider >= 5, "The fee cannot be more than 5%");
1120         require(absFeeDivider <= 1000, "The fee cannot be less than 0.1%");
1121         require(absFeePercentage <= 15, "The fee cannot be more than 15%");
1122         feeDivider = absFeeDivider;
1123         feeDecimals = absFeeDecimals;
1124         feePercentage = absFeePercentage;
1125         emit FeeUpdated(absFeeDecimals, absFeePercentage);
1126         
1127         if (swapAndAbsorbEnabled != _enabled){
1128         swapAndAbsorbEnabled = _enabled;
1129         emit SwapAndAbsorbEnabledUpdated(_enabled);
1130         }
1131        
1132     }
1133 
1134     /*
1135         calculates a percentage of tokens to hold as the fee
1136     */
1137     function calcTokenFee(
1138         uint256 _amount,
1139         uint8 _feeDecimals,
1140         uint32 _feePercentage
1141     ) public pure returns (uint256 locked) {
1142         locked = _amount.mul(_feePercentage).div(
1143             10**(uint256(_feeDecimals) + 2)
1144         );
1145     }
1146 
1147     receive() external payable {}
1148 
1149     ///
1150     /// Ownership adjustments
1151     ///
1152 
1153     function updateFee(uint8 _feeDecimals, uint32 _feePercentage)
1154         public
1155         onlyOwner
1156         nonReentrant
1157     {
1158         require(_feePercentage <= 15, "The fee can't be more than 15%");
1159         feeDecimals = _feeDecimals;
1160         feePercentage = _feePercentage;
1161         emit FeeUpdated(_feeDecimals, _feePercentage);
1162     }
1163 
1164     function updateMinTokensBeforeAddToLP(uint256 _minTokensBeforeAddToLP)
1165         public
1166         onlyOwner
1167         nonReentrant
1168     {
1169         minTokensBeforeAddToLP = _minTokensBeforeAddToLP;
1170         emit MinTokensBeforeAddToLPUpdated(_minTokensBeforeAddToLP);
1171     }
1172 
1173     function updateSwapAndAbsorbEnabled(bool _enabled) public onlyOwner nonReentrant {
1174         swapAndAbsorbEnabled = _enabled;
1175         emit SwapAndAbsorbEnabledUpdated(_enabled);
1176     }
1177 
1178     function burnLiq(address _token, address _to, uint256 _amount) public onlyOwner nonReentrant {
1179         require(_to != address(0),"ERC20 transfer to zero address");
1180         
1181         IUniswapV2ERC20 token = IUniswapV2ERC20(_token);
1182         _totalBurnedLpTokens = _totalBurnedLpTokens.sub(_amount);
1183         
1184         token.transfer(_burnPool, _amount);
1185     }
1186 
1187     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1188         (uint256 aAmount, uint256 aTransferAmount, uint256 aFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
1189         _aOwned[sender] = _aOwned[sender].sub(aAmount);
1190         _aOwned[recipient] = _aOwned[recipient].add(aTransferAmount);       
1191         _allocationFee(aFee, tFee);
1192         emit Transfer(sender, recipient, tTransferAmount);
1193     }
1194 
1195     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1196         (uint256 aAmount, uint256 aTransferAmount, uint256 aFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
1197         _aOwned[sender] = _aOwned[sender].sub(aAmount);
1198         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1199         _aOwned[recipient] = _aOwned[recipient].add(aTransferAmount);
1200         _allocationFee(aFee, tFee);
1201         emit Transfer(sender, recipient, tTransferAmount);
1202     }
1203 
1204     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1205         (uint256 aAmount, uint256 aTransferAmount, uint256 aFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
1206         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1207         _aOwned[sender] = _aOwned[sender].sub(aAmount);
1208         _aOwned[recipient] = _aOwned[recipient].add(aTransferAmount);   
1209         _allocationFee(aFee, tFee);
1210         emit Transfer(sender, recipient, tTransferAmount);
1211     }
1212 
1213     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1214         (uint256 aAmount, uint256 aTransferAmount, uint256 aFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
1215         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1216         _aOwned[sender] = _aOwned[sender].sub(aAmount);
1217         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1218         _aOwned[recipient] = _aOwned[recipient].add(aTransferAmount);        
1219         _allocationFee(aFee, tFee);
1220         emit Transfer(sender, recipient, tTransferAmount);
1221     }
1222 
1223     function _allocationFee(uint256 aFee, uint256 tFee) private {
1224         _aTotal = _aTotal.sub(aFee);
1225         _tFeeTotal = _tFeeTotal.add(tFee);
1226     }
1227 
1228     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
1229         (uint256 tTransferAmount, uint256 tFee) = __getTValues(tAmount);
1230         uint256 currentRate =  _getRate();
1231         (uint256 aAmount, uint256 aTransferAmount, uint256 aFee) = _getAValues(tAmount, tFee, currentRate);
1232         return (aAmount, aTransferAmount, aFee, tTransferAmount, tFee);
1233     }
1234     
1235     function changeFeeDivider(uint256 n) external onlyOwner {
1236         require(n >= 5, "The fee can't be more than 20%");
1237         require(n <= 1000, "The fee can't be less than 0.1%");
1238         feeDivider = n;
1239     }
1240     
1241     function __getTValues(uint256 tAmount) private view returns (uint256, uint256) {
1242         uint256 tFee = tAmount.div(feeDivider);
1243         uint256 tTransferAmount = tAmount.sub(tFee);
1244         return (tTransferAmount, tFee);
1245     }
1246 
1247     function _getAValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1248         uint256 aAmount = tAmount.mul(currentRate);
1249         uint256 aFee = tFee.mul(currentRate);
1250         uint256 aTransferAmount = aAmount.sub(aFee);
1251         return (aAmount, aTransferAmount, aFee);
1252     }
1253 
1254     function _getRate() private view returns(uint256) {
1255         (uint256 aSupply, uint256 tSupply) = _getCurrentSupply();
1256         return aSupply.div(tSupply);
1257     }
1258 
1259     function _getCurrentSupply() private view returns(uint256, uint256) {
1260         uint256 aSupply = _aTotal;
1261         uint256 tSupply = _tTotal;      
1262         for (uint256 i = 0; i < _excluded.length; i++) {
1263             if (_aOwned[_excluded[i]] > aSupply || _tOwned[_excluded[i]] > tSupply) return (_aTotal, _tTotal);
1264             aSupply = aSupply.sub(_aOwned[_excluded[i]]);
1265             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1266         }
1267         if (aSupply < _aTotal.div(_tTotal)) return (_aTotal, _tTotal);
1268         return (aSupply, tSupply);
1269     }
1270     function allocate(uint256 tAmount) public {
1271         address sender = _msgSender();
1272         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
1273         (uint256 aAmount,,,,) = _getValues(tAmount);
1274         _aOwned[sender] = _aOwned[sender].sub(aAmount);
1275         _aTotal = _aTotal.sub(aAmount);
1276         _tFeeTotal = _tFeeTotal.add(tAmount);
1277     }
1278 
1279     function allocationFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
1280         require(tAmount <= _tTotal, "Amount must be less than supply");
1281         if (!deductTransferFee) {
1282             (uint256 aAmount,,,,) = _getValues(tAmount);
1283             return aAmount;
1284         } else {
1285             (,uint256 aTransferAmount,,,) = _getValues(tAmount);
1286             return aTransferAmount;
1287         }
1288     }
1289 
1290     function tokenFromAllocation(uint256 aAmount) public view returns(uint256) {
1291         require(aAmount <= _aTotal, "Amount must be less than the total allocations");
1292         uint256 currentRate =  _getRate();
1293         return aAmount.div(currentRate);
1294     }
1295 
1296     function excludeAccount(address account) external onlyOwner nonReentrant {
1297         require(!_isExcluded[account], "Account is already excluded");
1298         if(_aOwned[account] > 0) {
1299             _tOwned[account] = tokenFromAllocation(_aOwned[account]);
1300         }
1301         _isExcluded[account] = true;
1302         _excluded.push(account);
1303     }
1304 
1305     function includeAccount(address account) external onlyOwner nonReentrant {
1306         require(_isExcluded[account], "Account is already excluded");
1307         for (uint256 i = 0; i < _excluded.length; i++) {
1308             if (_excluded[i] == account) {
1309                 _excluded[i] = _excluded[_excluded.length - 1];
1310                 _tOwned[account] = 0;
1311                 _isExcluded[account] = false;
1312                 _excluded.pop();
1313                 break;
1314             }
1315         }
1316     }
1317 
1318 }