1 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol
2 
3 pragma solidity >=0.5.0;
4 
5 interface IUniswapV2Pair {
6     event Approval(address indexed owner, address indexed spender, uint value);
7     event Transfer(address indexed from, address indexed to, uint value);
8 
9     function name() external pure returns (string memory);
10     function symbol() external pure returns (string memory);
11     function decimals() external pure returns (uint8);
12     function totalSupply() external view returns (uint);
13     function balanceOf(address owner) external view returns (uint);
14     function allowance(address owner, address spender) external view returns (uint);
15 
16     function approve(address spender, uint value) external returns (bool);
17     function transfer(address to, uint value) external returns (bool);
18     function transferFrom(address from, address to, uint value) external returns (bool);
19 
20     function DOMAIN_SEPARATOR() external view returns (bytes32);
21     function PERMIT_TYPEHASH() external pure returns (bytes32);
22     function nonces(address owner) external view returns (uint);
23 
24     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
25 
26     event Mint(address indexed sender, uint amount0, uint amount1);
27     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
28     event Swap(
29         address indexed sender,
30         uint amount0In,
31         uint amount1In,
32         uint amount0Out,
33         uint amount1Out,
34         address indexed to
35     );
36     event Sync(uint112 reserve0, uint112 reserve1);
37 
38     function MINIMUM_LIQUIDITY() external pure returns (uint);
39     function factory() external view returns (address);
40     function token0() external view returns (address);
41     function token1() external view returns (address);
42     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
43     function price0CumulativeLast() external view returns (uint);
44     function price1CumulativeLast() external view returns (uint);
45     function kLast() external view returns (uint);
46 
47     function mint(address to) external returns (uint liquidity);
48     function burn(address to) external returns (uint amount0, uint amount1);
49     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
50     function skim(address to) external;
51     function sync() external;
52 
53     function initialize(address, address) external;
54 }
55 
56 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol
57 
58 pragma solidity >=0.5.0;
59 
60 interface IUniswapV2Factory {
61     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
62 
63     function feeTo() external view returns (address);
64     function feeToSetter() external view returns (address);
65 
66     function getPair(address tokenA, address tokenB) external view returns (address pair);
67     function allPairs(uint) external view returns (address pair);
68     function allPairsLength() external view returns (uint);
69 
70     function createPair(address tokenA, address tokenB) external returns (address pair);
71 
72     function setFeeTo(address) external;
73     function setFeeToSetter(address) external;
74 }
75 
76 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol
77 
78 pragma solidity >=0.6.2;
79 
80 interface IUniswapV2Router01 {
81     function factory() external pure returns (address);
82     function WETH() external pure returns (address);
83 
84     function addLiquidity(
85         address tokenA,
86         address tokenB,
87         uint amountADesired,
88         uint amountBDesired,
89         uint amountAMin,
90         uint amountBMin,
91         address to,
92         uint deadline
93     ) external returns (uint amountA, uint amountB, uint liquidity);
94     function addLiquidityETH(
95         address token,
96         uint amountTokenDesired,
97         uint amountTokenMin,
98         uint amountETHMin,
99         address to,
100         uint deadline
101     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
102     function removeLiquidity(
103         address tokenA,
104         address tokenB,
105         uint liquidity,
106         uint amountAMin,
107         uint amountBMin,
108         address to,
109         uint deadline
110     ) external returns (uint amountA, uint amountB);
111     function removeLiquidityETH(
112         address token,
113         uint liquidity,
114         uint amountTokenMin,
115         uint amountETHMin,
116         address to,
117         uint deadline
118     ) external returns (uint amountToken, uint amountETH);
119     function removeLiquidityWithPermit(
120         address tokenA,
121         address tokenB,
122         uint liquidity,
123         uint amountAMin,
124         uint amountBMin,
125         address to,
126         uint deadline,
127         bool approveMax, uint8 v, bytes32 r, bytes32 s
128     ) external returns (uint amountA, uint amountB);
129     function removeLiquidityETHWithPermit(
130         address token,
131         uint liquidity,
132         uint amountTokenMin,
133         uint amountETHMin,
134         address to,
135         uint deadline,
136         bool approveMax, uint8 v, bytes32 r, bytes32 s
137     ) external returns (uint amountToken, uint amountETH);
138     function swapExactTokensForTokens(
139         uint amountIn,
140         uint amountOutMin,
141         address[] calldata path,
142         address to,
143         uint deadline
144     ) external returns (uint[] memory amounts);
145     function swapTokensForExactTokens(
146         uint amountOut,
147         uint amountInMax,
148         address[] calldata path,
149         address to,
150         uint deadline
151     ) external returns (uint[] memory amounts);
152     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
153         external
154         payable
155         returns (uint[] memory amounts);
156     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
157         external
158         returns (uint[] memory amounts);
159     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
160         external
161         returns (uint[] memory amounts);
162     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
163         external
164         payable
165         returns (uint[] memory amounts);
166 
167     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
168     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
169     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
170     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
171     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
172 }
173 
174 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol
175 
176 pragma solidity >=0.6.2;
177 
178 
179 interface IUniswapV2Router02 is IUniswapV2Router01 {
180     function removeLiquidityETHSupportingFeeOnTransferTokens(
181         address token,
182         uint liquidity,
183         uint amountTokenMin,
184         uint amountETHMin,
185         address to,
186         uint deadline
187     ) external returns (uint amountETH);
188     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
189         address token,
190         uint liquidity,
191         uint amountTokenMin,
192         uint amountETHMin,
193         address to,
194         uint deadline,
195         bool approveMax, uint8 v, bytes32 r, bytes32 s
196     ) external returns (uint amountETH);
197 
198     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
199         uint amountIn,
200         uint amountOutMin,
201         address[] calldata path,
202         address to,
203         uint deadline
204     ) external;
205     function swapExactETHForTokensSupportingFeeOnTransferTokens(
206         uint amountOutMin,
207         address[] calldata path,
208         address to,
209         uint deadline
210     ) external payable;
211     function swapExactTokensForETHSupportingFeeOnTransferTokens(
212         uint amountIn,
213         uint amountOutMin,
214         address[] calldata path,
215         address to,
216         uint deadline
217     ) external;
218 }
219 
220 // File: @openzeppelin/contracts/utils/Address.sol
221 
222 
223 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
224 
225 pragma solidity ^0.8.1;
226 
227 /**
228  * @dev Collection of functions related to the address type
229  */
230 library Address {
231     /**
232      * @dev Returns true if `account` is a contract.
233      *
234      * [IMPORTANT]
235      * ====
236      * It is unsafe to assume that an address for which this function returns
237      * false is an externally-owned account (EOA) and not a contract.
238      *
239      * Among others, `isContract` will return false for the following
240      * types of addresses:
241      *
242      *  - an externally-owned account
243      *  - a contract in construction
244      *  - an address where a contract will be created
245      *  - an address where a contract lived, but was destroyed
246      * ====
247      *
248      * [IMPORTANT]
249      * ====
250      * You shouldn't rely on `isContract` to protect against flash loan attacks!
251      *
252      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
253      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
254      * constructor.
255      * ====
256      */
257     function isContract(address account) internal view returns (bool) {
258         // This method relies on extcodesize/address.code.length, which returns 0
259         // for contracts in construction, since the code is only stored at the end
260         // of the constructor execution.
261 
262         return account.code.length > 0;
263     }
264 
265     /**
266      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
267      * `recipient`, forwarding all available gas and reverting on errors.
268      *
269      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
270      * of certain opcodes, possibly making contracts go over the 2300 gas limit
271      * imposed by `transfer`, making them unable to receive funds via
272      * `transfer`. {sendValue} removes this limitation.
273      *
274      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
275      *
276      * IMPORTANT: because control is transferred to `recipient`, care must be
277      * taken to not create reentrancy vulnerabilities. Consider using
278      * {ReentrancyGuard} or the
279      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
280      */
281     function sendValue(address payable recipient, uint256 amount) internal {
282         require(address(this).balance >= amount, "Address: insufficient balance");
283 
284         (bool success, ) = recipient.call{value: amount}("");
285         require(success, "Address: unable to send value, recipient may have reverted");
286     }
287 
288     /**
289      * @dev Performs a Solidity function call using a low level `call`. A
290      * plain `call` is an unsafe replacement for a function call: use this
291      * function instead.
292      *
293      * If `target` reverts with a revert reason, it is bubbled up by this
294      * function (like regular Solidity function calls).
295      *
296      * Returns the raw returned data. To convert to the expected return value,
297      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
298      *
299      * Requirements:
300      *
301      * - `target` must be a contract.
302      * - calling `target` with `data` must not revert.
303      *
304      * _Available since v3.1._
305      */
306     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
307         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
308     }
309 
310     /**
311      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
312      * `errorMessage` as a fallback revert reason when `target` reverts.
313      *
314      * _Available since v3.1._
315      */
316     function functionCall(
317         address target,
318         bytes memory data,
319         string memory errorMessage
320     ) internal returns (bytes memory) {
321         return functionCallWithValue(target, data, 0, errorMessage);
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
326      * but also transferring `value` wei to `target`.
327      *
328      * Requirements:
329      *
330      * - the calling contract must have an ETH balance of at least `value`.
331      * - the called Solidity function must be `payable`.
332      *
333      * _Available since v3.1._
334      */
335     function functionCallWithValue(
336         address target,
337         bytes memory data,
338         uint256 value
339     ) internal returns (bytes memory) {
340         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
345      * with `errorMessage` as a fallback revert reason when `target` reverts.
346      *
347      * _Available since v3.1._
348      */
349     function functionCallWithValue(
350         address target,
351         bytes memory data,
352         uint256 value,
353         string memory errorMessage
354     ) internal returns (bytes memory) {
355         require(address(this).balance >= value, "Address: insufficient balance for call");
356         (bool success, bytes memory returndata) = target.call{value: value}(data);
357         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
362      * but performing a static call.
363      *
364      * _Available since v3.3._
365      */
366     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
367         return functionStaticCall(target, data, "Address: low-level static call failed");
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
372      * but performing a static call.
373      *
374      * _Available since v3.3._
375      */
376     function functionStaticCall(
377         address target,
378         bytes memory data,
379         string memory errorMessage
380     ) internal view returns (bytes memory) {
381         (bool success, bytes memory returndata) = target.staticcall(data);
382         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
387      * but performing a delegate call.
388      *
389      * _Available since v3.4._
390      */
391     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
392         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
393     }
394 
395     /**
396      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
397      * but performing a delegate call.
398      *
399      * _Available since v3.4._
400      */
401     function functionDelegateCall(
402         address target,
403         bytes memory data,
404         string memory errorMessage
405     ) internal returns (bytes memory) {
406         (bool success, bytes memory returndata) = target.delegatecall(data);
407         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
408     }
409 
410     /**
411      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
412      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
413      *
414      * _Available since v4.8._
415      */
416     function verifyCallResultFromTarget(
417         address target,
418         bool success,
419         bytes memory returndata,
420         string memory errorMessage
421     ) internal view returns (bytes memory) {
422         if (success) {
423             if (returndata.length == 0) {
424                 // only check isContract if the call was successful and the return data is empty
425                 // otherwise we already know that it was a contract
426                 require(isContract(target), "Address: call to non-contract");
427             }
428             return returndata;
429         } else {
430             _revert(returndata, errorMessage);
431         }
432     }
433 
434     /**
435      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
436      * revert reason or using the provided one.
437      *
438      * _Available since v4.3._
439      */
440     function verifyCallResult(
441         bool success,
442         bytes memory returndata,
443         string memory errorMessage
444     ) internal pure returns (bytes memory) {
445         if (success) {
446             return returndata;
447         } else {
448             _revert(returndata, errorMessage);
449         }
450     }
451 
452     function _revert(bytes memory returndata, string memory errorMessage) private pure {
453         // Look for revert reason and bubble it up if present
454         if (returndata.length > 0) {
455             // The easiest way to bubble the revert reason is using memory via assembly
456             /// @solidity memory-safe-assembly
457             assembly {
458                 let returndata_size := mload(returndata)
459                 revert(add(32, returndata), returndata_size)
460             }
461         } else {
462             revert(errorMessage);
463         }
464     }
465 }
466 
467 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
468 
469 
470 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
471 
472 pragma solidity ^0.8.0;
473 
474 /**
475  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
476  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
477  *
478  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
479  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
480  * need to send a transaction, and thus is not required to hold Ether at all.
481  */
482 interface IERC20Permit {
483     /**
484      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
485      * given ``owner``'s signed approval.
486      *
487      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
488      * ordering also apply here.
489      *
490      * Emits an {Approval} event.
491      *
492      * Requirements:
493      *
494      * - `spender` cannot be the zero address.
495      * - `deadline` must be a timestamp in the future.
496      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
497      * over the EIP712-formatted function arguments.
498      * - the signature must use ``owner``'s current nonce (see {nonces}).
499      *
500      * For more information on the signature format, see the
501      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
502      * section].
503      */
504     function permit(
505         address owner,
506         address spender,
507         uint256 value,
508         uint256 deadline,
509         uint8 v,
510         bytes32 r,
511         bytes32 s
512     ) external;
513 
514     /**
515      * @dev Returns the current nonce for `owner`. This value must be
516      * included whenever a signature is generated for {permit}.
517      *
518      * Every successful call to {permit} increases ``owner``'s nonce by one. This
519      * prevents a signature from being used multiple times.
520      */
521     function nonces(address owner) external view returns (uint256);
522 
523     /**
524      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
525      */
526     // solhint-disable-next-line func-name-mixedcase
527     function DOMAIN_SEPARATOR() external view returns (bytes32);
528 }
529 
530 // File: @openzeppelin/contracts/utils/Context.sol
531 
532 
533 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
534 
535 pragma solidity ^0.8.0;
536 
537 /**
538  * @dev Provides information about the current execution context, including the
539  * sender of the transaction and its data. While these are generally available
540  * via msg.sender and msg.data, they should not be accessed in such a direct
541  * manner, since when dealing with meta-transactions the account sending and
542  * paying for execution may not be the actual sender (as far as an application
543  * is concerned).
544  *
545  * This contract is only required for intermediate, library-like contracts.
546  */
547 abstract contract Context {
548     function _msgSender() internal view virtual returns (address) {
549         return msg.sender;
550     }
551 
552     function _msgData() internal view virtual returns (bytes calldata) {
553         return msg.data;
554     }
555 }
556 
557 // File: @openzeppelin/contracts/access/Ownable.sol
558 
559 
560 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
561 
562 pragma solidity ^0.8.0;
563 
564 
565 /**
566  * @dev Contract module which provides a basic access control mechanism, where
567  * there is an account (an owner) that can be granted exclusive access to
568  * specific functions.
569  *
570  * By default, the owner account will be the one that deploys the contract. This
571  * can later be changed with {transferOwnership}.
572  *
573  * This module is used through inheritance. It will make available the modifier
574  * `onlyOwner`, which can be applied to your functions to restrict their use to
575  * the owner.
576  */
577 abstract contract Ownable is Context {
578     address private _owner;
579 
580     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
581 
582     /**
583      * @dev Initializes the contract setting the deployer as the initial owner.
584      */
585     constructor() {
586         _transferOwnership(_msgSender());
587     }
588 
589     /**
590      * @dev Throws if called by any account other than the owner.
591      */
592     modifier onlyOwner() {
593         _checkOwner();
594         _;
595     }
596 
597     /**
598      * @dev Returns the address of the current owner.
599      */
600     function owner() public view virtual returns (address) {
601         return _owner;
602     }
603 
604     /**
605      * @dev Throws if the sender is not the owner.
606      */
607     function _checkOwner() internal view virtual {
608         require(owner() == _msgSender(), "Ownable: caller is not the owner");
609     }
610 
611     /**
612      * @dev Leaves the contract without owner. It will not be possible to call
613      * `onlyOwner` functions anymore. Can only be called by the current owner.
614      *
615      * NOTE: Renouncing ownership will leave the contract without an owner,
616      * thereby removing any functionality that is only available to the owner.
617      */
618     function renounceOwnership() public virtual onlyOwner {
619         _transferOwnership(address(0));
620     }
621 
622     /**
623      * @dev Transfers ownership of the contract to a new account (`newOwner`).
624      * Can only be called by the current owner.
625      */
626     function transferOwnership(address newOwner) public virtual onlyOwner {
627         require(newOwner != address(0), "Ownable: new owner is the zero address");
628         _transferOwnership(newOwner);
629     }
630 
631     /**
632      * @dev Transfers ownership of the contract to a new account (`newOwner`).
633      * Internal function without access restriction.
634      */
635     function _transferOwnership(address newOwner) internal virtual {
636         address oldOwner = _owner;
637         _owner = newOwner;
638         emit OwnershipTransferred(oldOwner, newOwner);
639     }
640 }
641 
642 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
643 
644 
645 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
646 
647 pragma solidity ^0.8.0;
648 
649 /**
650  * @dev Interface of the ERC20 standard as defined in the EIP.
651  */
652 interface IERC20 {
653     /**
654      * @dev Emitted when `value` tokens are moved from one account (`from`) to
655      * another (`to`).
656      *
657      * Note that `value` may be zero.
658      */
659     event Transfer(address indexed from, address indexed to, uint256 value);
660 
661     /**
662      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
663      * a call to {approve}. `value` is the new allowance.
664      */
665     event Approval(address indexed owner, address indexed spender, uint256 value);
666 
667     /**
668      * @dev Returns the amount of tokens in existence.
669      */
670     function totalSupply() external view returns (uint256);
671 
672     /**
673      * @dev Returns the amount of tokens owned by `account`.
674      */
675     function balanceOf(address account) external view returns (uint256);
676 
677     /**
678      * @dev Moves `amount` tokens from the caller's account to `to`.
679      *
680      * Returns a boolean value indicating whether the operation succeeded.
681      *
682      * Emits a {Transfer} event.
683      */
684     function transfer(address to, uint256 amount) external returns (bool);
685 
686     /**
687      * @dev Returns the remaining number of tokens that `spender` will be
688      * allowed to spend on behalf of `owner` through {transferFrom}. This is
689      * zero by default.
690      *
691      * This value changes when {approve} or {transferFrom} are called.
692      */
693     function allowance(address owner, address spender) external view returns (uint256);
694 
695     /**
696      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
697      *
698      * Returns a boolean value indicating whether the operation succeeded.
699      *
700      * IMPORTANT: Beware that changing an allowance with this method brings the risk
701      * that someone may use both the old and the new allowance by unfortunate
702      * transaction ordering. One possible solution to mitigate this race
703      * condition is to first reduce the spender's allowance to 0 and set the
704      * desired value afterwards:
705      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
706      *
707      * Emits an {Approval} event.
708      */
709     function approve(address spender, uint256 amount) external returns (bool);
710 
711     /**
712      * @dev Moves `amount` tokens from `from` to `to` using the
713      * allowance mechanism. `amount` is then deducted from the caller's
714      * allowance.
715      *
716      * Returns a boolean value indicating whether the operation succeeded.
717      *
718      * Emits a {Transfer} event.
719      */
720     function transferFrom(
721         address from,
722         address to,
723         uint256 amount
724     ) external returns (bool);
725 }
726 
727 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
728 
729 
730 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/utils/SafeERC20.sol)
731 
732 pragma solidity ^0.8.0;
733 
734 
735 
736 
737 /**
738  * @title SafeERC20
739  * @dev Wrappers around ERC20 operations that throw on failure (when the token
740  * contract returns false). Tokens that return no value (and instead revert or
741  * throw on failure) are also supported, non-reverting calls are assumed to be
742  * successful.
743  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
744  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
745  */
746 library SafeERC20 {
747     using Address for address;
748 
749     function safeTransfer(
750         IERC20 token,
751         address to,
752         uint256 value
753     ) internal {
754         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
755     }
756 
757     function safeTransferFrom(
758         IERC20 token,
759         address from,
760         address to,
761         uint256 value
762     ) internal {
763         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
764     }
765 
766     /**
767      * @dev Deprecated. This function has issues similar to the ones found in
768      * {IERC20-approve}, and its usage is discouraged.
769      *
770      * Whenever possible, use {safeIncreaseAllowance} and
771      * {safeDecreaseAllowance} instead.
772      */
773     function safeApprove(
774         IERC20 token,
775         address spender,
776         uint256 value
777     ) internal {
778         // safeApprove should only be called when setting an initial allowance,
779         // or when resetting it to zero. To increase and decrease it, use
780         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
781         require(
782             (value == 0) || (token.allowance(address(this), spender) == 0),
783             "SafeERC20: approve from non-zero to non-zero allowance"
784         );
785         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
786     }
787 
788     function safeIncreaseAllowance(
789         IERC20 token,
790         address spender,
791         uint256 value
792     ) internal {
793         uint256 newAllowance = token.allowance(address(this), spender) + value;
794         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
795     }
796 
797     function safeDecreaseAllowance(
798         IERC20 token,
799         address spender,
800         uint256 value
801     ) internal {
802         unchecked {
803             uint256 oldAllowance = token.allowance(address(this), spender);
804             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
805             uint256 newAllowance = oldAllowance - value;
806             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
807         }
808     }
809 
810     function safePermit(
811         IERC20Permit token,
812         address owner,
813         address spender,
814         uint256 value,
815         uint256 deadline,
816         uint8 v,
817         bytes32 r,
818         bytes32 s
819     ) internal {
820         uint256 nonceBefore = token.nonces(owner);
821         token.permit(owner, spender, value, deadline, v, r, s);
822         uint256 nonceAfter = token.nonces(owner);
823         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
824     }
825 
826     /**
827      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
828      * on the return value: the return value is optional (but if data is returned, it must not be false).
829      * @param token The token targeted by the call.
830      * @param data The call data (encoded using abi.encode or one of its variants).
831      */
832     function _callOptionalReturn(IERC20 token, bytes memory data) private {
833         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
834         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
835         // the target address contains contract code and also asserts for success in the low-level call.
836 
837         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
838         if (returndata.length > 0) {
839             // Return data is optional
840             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
841         }
842     }
843 }
844 
845 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
846 
847 
848 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
849 
850 pragma solidity ^0.8.0;
851 
852 
853 /**
854  * @dev Interface for the optional metadata functions from the ERC20 standard.
855  *
856  * _Available since v4.1._
857  */
858 interface IERC20Metadata is IERC20 {
859     /**
860      * @dev Returns the name of the token.
861      */
862     function name() external view returns (string memory);
863 
864     /**
865      * @dev Returns the symbol of the token.
866      */
867     function symbol() external view returns (string memory);
868 
869     /**
870      * @dev Returns the decimals places of the token.
871      */
872     function decimals() external view returns (uint8);
873 }
874 
875 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
876 
877 
878 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
879 
880 pragma solidity ^0.8.0;
881 
882 
883 
884 
885 /**
886  * @dev Implementation of the {IERC20} interface.
887  *
888  * This implementation is agnostic to the way tokens are created. This means
889  * that a supply mechanism has to be added in a derived contract using {_mint}.
890  * For a generic mechanism see {ERC20PresetMinterPauser}.
891  *
892  * TIP: For a detailed writeup see our guide
893  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
894  * to implement supply mechanisms].
895  *
896  * We have followed general OpenZeppelin Contracts guidelines: functions revert
897  * instead returning `false` on failure. This behavior is nonetheless
898  * conventional and does not conflict with the expectations of ERC20
899  * applications.
900  *
901  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
902  * This allows applications to reconstruct the allowance for all accounts just
903  * by listening to said events. Other implementations of the EIP may not emit
904  * these events, as it isn't required by the specification.
905  *
906  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
907  * functions have been added to mitigate the well-known issues around setting
908  * allowances. See {IERC20-approve}.
909  */
910 contract ERC20 is Context, IERC20, IERC20Metadata {
911     mapping(address => uint256) private _balances;
912 
913     mapping(address => mapping(address => uint256)) private _allowances;
914 
915     uint256 private _totalSupply;
916 
917     string private _name;
918     string private _symbol;
919 
920     /**
921      * @dev Sets the values for {name} and {symbol}.
922      *
923      * The default value of {decimals} is 18. To select a different value for
924      * {decimals} you should overload it.
925      *
926      * All two of these values are immutable: they can only be set once during
927      * construction.
928      */
929     constructor(string memory name_, string memory symbol_) {
930         _name = name_;
931         _symbol = symbol_;
932     }
933 
934     /**
935      * @dev Returns the name of the token.
936      */
937     function name() public view virtual override returns (string memory) {
938         return _name;
939     }
940 
941     /**
942      * @dev Returns the symbol of the token, usually a shorter version of the
943      * name.
944      */
945     function symbol() public view virtual override returns (string memory) {
946         return _symbol;
947     }
948 
949     /**
950      * @dev Returns the number of decimals used to get its user representation.
951      * For example, if `decimals` equals `2`, a balance of `505` tokens should
952      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
953      *
954      * Tokens usually opt for a value of 18, imitating the relationship between
955      * Ether and Wei. This is the value {ERC20} uses, unless this function is
956      * overridden;
957      *
958      * NOTE: This information is only used for _display_ purposes: it in
959      * no way affects any of the arithmetic of the contract, including
960      * {IERC20-balanceOf} and {IERC20-transfer}.
961      */
962     function decimals() public view virtual override returns (uint8) {
963         return 18;
964     }
965 
966     /**
967      * @dev See {IERC20-totalSupply}.
968      */
969     function totalSupply() public view virtual override returns (uint256) {
970         return _totalSupply;
971     }
972 
973     /**
974      * @dev See {IERC20-balanceOf}.
975      */
976     function balanceOf(address account) public view virtual override returns (uint256) {
977         return _balances[account];
978     }
979 
980     /**
981      * @dev See {IERC20-transfer}.
982      *
983      * Requirements:
984      *
985      * - `to` cannot be the zero address.
986      * - the caller must have a balance of at least `amount`.
987      */
988     function transfer(address to, uint256 amount) public virtual override returns (bool) {
989         address owner = _msgSender();
990         _transfer(owner, to, amount);
991         return true;
992     }
993 
994     /**
995      * @dev See {IERC20-allowance}.
996      */
997     function allowance(address owner, address spender) public view virtual override returns (uint256) {
998         return _allowances[owner][spender];
999     }
1000 
1001     /**
1002      * @dev See {IERC20-approve}.
1003      *
1004      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1005      * `transferFrom`. This is semantically equivalent to an infinite approval.
1006      *
1007      * Requirements:
1008      *
1009      * - `spender` cannot be the zero address.
1010      */
1011     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1012         address owner = _msgSender();
1013         _approve(owner, spender, amount);
1014         return true;
1015     }
1016 
1017     /**
1018      * @dev See {IERC20-transferFrom}.
1019      *
1020      * Emits an {Approval} event indicating the updated allowance. This is not
1021      * required by the EIP. See the note at the beginning of {ERC20}.
1022      *
1023      * NOTE: Does not update the allowance if the current allowance
1024      * is the maximum `uint256`.
1025      *
1026      * Requirements:
1027      *
1028      * - `from` and `to` cannot be the zero address.
1029      * - `from` must have a balance of at least `amount`.
1030      * - the caller must have allowance for ``from``'s tokens of at least
1031      * `amount`.
1032      */
1033     function transferFrom(
1034         address from,
1035         address to,
1036         uint256 amount
1037     ) public virtual override returns (bool) {
1038         address spender = _msgSender();
1039         _spendAllowance(from, spender, amount);
1040         _transfer(from, to, amount);
1041         return true;
1042     }
1043 
1044     /**
1045      * @dev Atomically increases the allowance granted to `spender` by the caller.
1046      *
1047      * This is an alternative to {approve} that can be used as a mitigation for
1048      * problems described in {IERC20-approve}.
1049      *
1050      * Emits an {Approval} event indicating the updated allowance.
1051      *
1052      * Requirements:
1053      *
1054      * - `spender` cannot be the zero address.
1055      */
1056     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1057         address owner = _msgSender();
1058         _approve(owner, spender, allowance(owner, spender) + addedValue);
1059         return true;
1060     }
1061 
1062     /**
1063      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1064      *
1065      * This is an alternative to {approve} that can be used as a mitigation for
1066      * problems described in {IERC20-approve}.
1067      *
1068      * Emits an {Approval} event indicating the updated allowance.
1069      *
1070      * Requirements:
1071      *
1072      * - `spender` cannot be the zero address.
1073      * - `spender` must have allowance for the caller of at least
1074      * `subtractedValue`.
1075      */
1076     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1077         address owner = _msgSender();
1078         uint256 currentAllowance = allowance(owner, spender);
1079         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1080         unchecked {
1081             _approve(owner, spender, currentAllowance - subtractedValue);
1082         }
1083 
1084         return true;
1085     }
1086 
1087     /**
1088      * @dev Moves `amount` of tokens from `from` to `to`.
1089      *
1090      * This internal function is equivalent to {transfer}, and can be used to
1091      * e.g. implement automatic token fees, slashing mechanisms, etc.
1092      *
1093      * Emits a {Transfer} event.
1094      *
1095      * Requirements:
1096      *
1097      * - `from` cannot be the zero address.
1098      * - `to` cannot be the zero address.
1099      * - `from` must have a balance of at least `amount`.
1100      */
1101     function _transfer(
1102         address from,
1103         address to,
1104         uint256 amount
1105     ) internal virtual {
1106         require(from != address(0), "ERC20: transfer from the zero address");
1107         require(to != address(0), "ERC20: transfer to the zero address");
1108 
1109         _beforeTokenTransfer(from, to, amount);
1110 
1111         uint256 fromBalance = _balances[from];
1112         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1113         unchecked {
1114             _balances[from] = fromBalance - amount;
1115             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
1116             // decrementing then incrementing.
1117             _balances[to] += amount;
1118         }
1119 
1120         emit Transfer(from, to, amount);
1121 
1122         _afterTokenTransfer(from, to, amount);
1123     }
1124 
1125     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1126      * the total supply.
1127      *
1128      * Emits a {Transfer} event with `from` set to the zero address.
1129      *
1130      * Requirements:
1131      *
1132      * - `account` cannot be the zero address.
1133      */
1134     function _mint(address account, uint256 amount) internal virtual {
1135         require(account != address(0), "ERC20: mint to the zero address");
1136 
1137         _beforeTokenTransfer(address(0), account, amount);
1138 
1139         _totalSupply += amount;
1140         unchecked {
1141             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
1142             _balances[account] += amount;
1143         }
1144         emit Transfer(address(0), account, amount);
1145 
1146         _afterTokenTransfer(address(0), account, amount);
1147     }
1148 
1149     /**
1150      * @dev Destroys `amount` tokens from `account`, reducing the
1151      * total supply.
1152      *
1153      * Emits a {Transfer} event with `to` set to the zero address.
1154      *
1155      * Requirements:
1156      *
1157      * - `account` cannot be the zero address.
1158      * - `account` must have at least `amount` tokens.
1159      */
1160     function _burn(address account, uint256 amount) internal virtual {
1161         require(account != address(0), "ERC20: burn from the zero address");
1162 
1163         _beforeTokenTransfer(account, address(0), amount);
1164 
1165         uint256 accountBalance = _balances[account];
1166         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1167         unchecked {
1168             _balances[account] = accountBalance - amount;
1169             // Overflow not possible: amount <= accountBalance <= totalSupply.
1170             _totalSupply -= amount;
1171         }
1172 
1173         emit Transfer(account, address(0), amount);
1174 
1175         _afterTokenTransfer(account, address(0), amount);
1176     }
1177 
1178     /**
1179      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1180      *
1181      * This internal function is equivalent to `approve`, and can be used to
1182      * e.g. set automatic allowances for certain subsystems, etc.
1183      *
1184      * Emits an {Approval} event.
1185      *
1186      * Requirements:
1187      *
1188      * - `owner` cannot be the zero address.
1189      * - `spender` cannot be the zero address.
1190      */
1191     function _approve(
1192         address owner,
1193         address spender,
1194         uint256 amount
1195     ) internal virtual {
1196         require(owner != address(0), "ERC20: approve from the zero address");
1197         require(spender != address(0), "ERC20: approve to the zero address");
1198 
1199         _allowances[owner][spender] = amount;
1200         emit Approval(owner, spender, amount);
1201     }
1202 
1203     /**
1204      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1205      *
1206      * Does not update the allowance amount in case of infinite allowance.
1207      * Revert if not enough allowance is available.
1208      *
1209      * Might emit an {Approval} event.
1210      */
1211     function _spendAllowance(
1212         address owner,
1213         address spender,
1214         uint256 amount
1215     ) internal virtual {
1216         uint256 currentAllowance = allowance(owner, spender);
1217         if (currentAllowance != type(uint256).max) {
1218             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1219             unchecked {
1220                 _approve(owner, spender, currentAllowance - amount);
1221             }
1222         }
1223     }
1224 
1225     /**
1226      * @dev Hook that is called before any transfer of tokens. This includes
1227      * minting and burning.
1228      *
1229      * Calling conditions:
1230      *
1231      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1232      * will be transferred to `to`.
1233      * - when `from` is zero, `amount` tokens will be minted for `to`.
1234      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1235      * - `from` and `to` are never both zero.
1236      *
1237      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1238      */
1239     function _beforeTokenTransfer(
1240         address from,
1241         address to,
1242         uint256 amount
1243     ) internal virtual {}
1244 
1245     /**
1246      * @dev Hook that is called after any transfer of tokens. This includes
1247      * minting and burning.
1248      *
1249      * Calling conditions:
1250      *
1251      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1252      * has been transferred to `to`.
1253      * - when `from` is zero, `amount` tokens have been minted for `to`.
1254      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1255      * - `from` and `to` are never both zero.
1256      *
1257      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1258      */
1259     function _afterTokenTransfer(
1260         address from,
1261         address to,
1262         uint256 amount
1263     ) internal virtual {}
1264 }
1265 
1266 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
1267 
1268 
1269 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
1270 
1271 pragma solidity ^0.8.0;
1272 
1273 
1274 
1275 /**
1276  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1277  * tokens and those that they have an allowance for, in a way that can be
1278  * recognized off-chain (via event analysis).
1279  */
1280 abstract contract ERC20Burnable is Context, ERC20 {
1281     /**
1282      * @dev Destroys `amount` tokens from the caller.
1283      *
1284      * See {ERC20-_burn}.
1285      */
1286     function burn(uint256 amount) public virtual {
1287         _burn(_msgSender(), amount);
1288     }
1289 
1290     /**
1291      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1292      * allowance.
1293      *
1294      * See {ERC20-_burn} and {ERC20-allowance}.
1295      *
1296      * Requirements:
1297      *
1298      * - the caller must have allowance for ``accounts``'s tokens of at least
1299      * `amount`.
1300      */
1301     function burnFrom(address account, uint256 amount) public virtual {
1302         _spendAllowance(account, _msgSender(), amount);
1303         _burn(account, amount);
1304     }
1305 }
1306 
1307 // File: bblv2.sol
1308 
1309 
1310 
1311 pragma solidity ^0.8.16;
1312 
1313 
1314 
1315 
1316 
1317 
1318 
1319 
1320 contract BlockBlend is ERC20Burnable, Ownable {
1321     using SafeERC20 for IERC20;
1322 
1323     uint256 private TOTAL_SUPPLY = 111_111_111 ether;
1324 
1325     bool public marsMission;
1326 
1327     // Addresses for fees
1328     address public marketingAddr;
1329     address public teamAddr;
1330     address public communityAddr;
1331 
1332     // Dex
1333     IUniswapV2Router02 public router;
1334     mapping(address => bool) public pairs;
1335     address public mainPair;
1336 
1337     // Fees
1338     struct buyFee {
1339         uint256 marketing;
1340         uint256 team;
1341         uint256 community;
1342     }
1343 
1344     buyFee public buyFees;
1345 
1346     struct sellFee {
1347         uint256 marketing;
1348         uint256 team;
1349         uint256 community;
1350     }
1351 
1352     sellFee public sellFees;
1353     uint256 public burnOnSell;
1354 
1355     bool disableBuyFees;
1356     bool disableSellFees;
1357 
1358     mapping (address => bool) public exempts;
1359 
1360     // Automatic swap
1361     struct SwapToken {
1362         uint256 max;
1363         uint256 maxPercent;
1364         uint256 last;
1365         uint256 delay;
1366         uint256 distribute;
1367     }
1368 
1369     SwapToken public swapTokens;
1370 
1371     constructor(IUniswapV2Router02 _router) ERC20("BlockBlend", "BBL") {
1372         _mint(msg.sender, TOTAL_SUPPLY);
1373 
1374         // Set addresses for fees
1375         marketingAddr = msg.sender;
1376         teamAddr = msg.sender;
1377         communityAddr = msg.sender;
1378 
1379         // Set BUY fees
1380         buyFees.marketing = 5; // 0.5%
1381         buyFees.team = 15; // 1.5%
1382         buyFees.community = 5; // 0.5%
1383 
1384         // Set SELL fees & burn
1385         sellFees.marketing = 5; // 5%
1386         sellFees.team = 20; // 2%
1387         sellFees.community = 5; // 5%
1388 
1389         burnOnSell = 1; // 0.1%
1390 
1391         exempts[msg.sender] = true;
1392         exempts[marketingAddr] = true;
1393         exempts[teamAddr] = true;
1394         exempts[communityAddr] = true;
1395         exempts[address(this)] = true;
1396 
1397         // Automatic swap
1398         swapTokens.max = TOTAL_SUPPLY / 400;
1399         swapTokens.maxPercent = 5; // 0.5%
1400         swapTokens.delay = 5 minutes;
1401         swapTokens.distribute = 25 ether / 100;
1402 
1403         // Dex
1404         router = IUniswapV2Router02(_router);
1405         mainPair = IUniswapV2Factory(router.factory()).createPair(address(this), router.WETH());
1406         pairs[mainPair] = true;
1407  
1408         _approve(address(this), address(router), TOTAL_SUPPLY);
1409         approve(address(router), TOTAL_SUPPLY);
1410     }
1411     
1412     /**
1413         Restore original fees
1414     */
1415 
1416     function startMarsMission() external onlyOwner {
1417         marsMission = true;
1418     }
1419 
1420     /**
1421         Swap tokens
1422     */
1423     function setSwapTokens(uint256 _max, uint256 _maxPercent, uint256 _last, uint256 _delay, uint256 _distribute) external onlyOwner {
1424         require(_max < TOTAL_SUPPLY / 100 && _maxPercent <= 50, "Invalid max values!");
1425         swapTokens.max = _max;
1426         swapTokens.last = _last;
1427         swapTokens.delay = _delay;
1428         swapTokens.distribute = _distribute;
1429         swapTokens.maxPercent = _maxPercent;
1430     }
1431 
1432     /**
1433         Add/remove pair
1434     */
1435 
1436     function addTradingPair(address _pair, bool _enable) external onlyOwner {
1437         pairs[_pair] = _enable;
1438     }
1439 
1440     /**
1441         Disable fee
1442     */
1443     function disableFeesForBuy(bool _disableBuyFees) external onlyOwner {
1444         disableBuyFees = _disableBuyFees;
1445     }
1446 
1447     function disableFeesForSell(bool _disableSellFees) external onlyOwner {
1448         disableSellFees = _disableSellFees;
1449     }
1450 
1451     /**
1452         Automatic swap
1453     */
1454 
1455     function swapForETH(uint256 _amount) internal {
1456         address[] memory path = new address[](2);
1457         path[0] = address(this);
1458         path[1] = router.WETH();
1459         _approve(address(this), address(router), _amount);
1460         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1461             _amount,
1462             0,
1463             path,
1464             address(this),
1465             block.timestamp
1466         );
1467     }
1468 
1469     function sendETH(uint256 _amount) private {
1470         payable(marketingAddr).transfer(_amount / 5 * 3);
1471         payable(teamAddr).transfer(_amount / 5);
1472         payable(communityAddr).transfer(_amount / 5);
1473     }
1474 
1475     function triggerSwapForETH(uint256 _amount) external onlyOwner {
1476         swapForETH(_amount);
1477     }
1478 
1479     function triggerDistribution() external onlyOwner {
1480         sendETH(address(this).balance);
1481     }
1482 
1483     /**
1484         Sets the free trading for the specific address
1485     */
1486     function setExempts(address _address, bool _value) external onlyOwner {
1487         require(exempts[_address] != _value, "Already set!");
1488         exempts[_address] = _value;
1489     }
1490 
1491     /**
1492         Claim tokens
1493     */
1494     function claimTokens(IERC20 _token) external onlyOwner {
1495         _token.safeTransfer(msg.sender, _token.balanceOf(address(this)));
1496     }
1497 
1498     /**
1499         Swaps tokens on sell
1500     */
1501     function triggerSwap() internal {
1502         uint256 tokenBalance = balanceOf(address(this));
1503         uint256 pairBalance = balanceOf(mainPair);
1504         uint256 toSwap = swapTokens.max;
1505 
1506         if ((tokenBalance >= swapTokens.max || tokenBalance >= pairBalance * swapTokens.maxPercent / 1000) && block.timestamp > swapTokens.last + swapTokens.delay) {
1507             if(pairBalance * swapTokens.maxPercent / 1000 < swapTokens.max) {
1508                 toSwap = pairBalance * swapTokens.maxPercent / 1000;
1509             }
1510 
1511             swapForETH(toSwap);
1512 
1513             swapTokens.last = block.timestamp;
1514 
1515             if(address(this).balance >= swapTokens.distribute) {
1516                 sendETH(address(this).balance);
1517             }
1518         }
1519     }
1520 
1521     /**
1522         Transfer - with fees
1523     */
1524     function _transfer(address from, address to, uint256 amount) internal override {
1525         require(from != address(0), "ERC20: transfer from the zero address");
1526         require(to != address(0), "ERC20: transfer to the zero address");
1527         
1528         uint256 fees;
1529         uint256 tokensAsFees;
1530         uint256 tokensToBurn;
1531         bool isExempt;
1532 
1533         if(exempts[to] || exempts[from]) {
1534             isExempt = true;
1535         }
1536         
1537         if(!isExempt) {
1538             // SELL
1539             if(pairs[to] == true && !disableSellFees) {
1540                 // Calculate total fees
1541                 fees = sellFees.marketing + sellFees.team + sellFees.community;
1542                 tokensToBurn = amount * burnOnSell / 1000;
1543 
1544                 // Fees are 4.5 times more the until owner calls startMarsMission()
1545                 if(!marsMission) {
1546                     fees = fees * 45 / 10;
1547                 }
1548 
1549                 if(swapTokens.max > 0) {
1550                     triggerSwap();
1551                 }
1552             
1553             // BUY
1554             } else if(pairs[from] == true && !disableBuyFees) {
1555                 // Calculate total fees
1556                 fees = buyFees.marketing + buyFees.team + buyFees.community;
1557             }
1558 
1559             tokensAsFees = amount * fees / 1000; // fees in tokens
1560             
1561             // transfer fees to contract
1562             if(tokensAsFees > 0) {
1563                 super._transfer(from, address(this), tokensAsFees);
1564 
1565                 if(tokensToBurn > 0) {
1566                     burnFrom(from, tokensToBurn);
1567                 }
1568             }
1569         }
1570 
1571         // transfer tokens to user
1572         amount = amount - tokensAsFees - tokensToBurn;
1573         super._transfer(from, to, amount);
1574     }
1575 
1576     fallback() external payable {}
1577     receive() external payable {}
1578 }