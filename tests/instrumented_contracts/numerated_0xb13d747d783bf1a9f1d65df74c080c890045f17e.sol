1 //███████╗░█████╗░██╗░░░██╗███╗░░██╗██████╗░░█████╗░████████╗██╗░█████╗░███╗░░██╗
2 //██╔════╝██╔══██╗██║░░░██║████╗░██║██╔══██╗██╔══██╗╚══██╔══╝██║██╔══██╗████╗░██║
3 //█████╗░░██║░░██║██║░░░██║██╔██╗██║██║░░██║███████║░░░██║░░░██║██║░░██║██╔██╗██║
4 //██╔══╝░░██║░░██║██║░░░██║██║╚████║██║░░██║██╔══██║░░░██║░░░██║██║░░██║██║╚████║
5 //██║░░░░░╚█████╔╝╚██████╔╝██║░╚███║██████╔╝██║░░██║░░░██║░░░██║╚█████╔╝██║░╚███║
6 //╚═╝░░░░░░╚════╝░░╚═════╝░╚═╝░░╚══╝╚═════╝░╚═╝░░╚═╝░░░╚═╝░░░╚═╝░╚════╝░╚═╝░░╚══╝
7 
8 //████████╗░█████╗░██╗░░██╗███████╗███╗░░██╗
9 //╚══██╔══╝██╔══██╗██║░██╔╝██╔════╝████╗░██║
10 //░░░██║░░░██║░░██║█████═╝░█████╗░░██╔██╗██║
11 //░░░██║░░░██║░░██║██╔═██╗░██╔══╝░░██║╚████║
12 //░░░██║░░░╚█████╔╝██║░╚██╗███████╗██║░╚███║
13 //░░░╚═╝░░░░╚════╝░╚═╝░░╚═╝╚══════╝╚═╝░░╚══╝
14 
15 
16 
17 // https://t.me/Foundation_Token
18 // https://foundationtoken.io/
19 
20 // SPDX-License-Identifier: MIT
21 pragma solidity ^0.8.17;
22 
23 interface IUniswapRouter01 {
24     function factory() external pure returns (address);
25 
26     function WETH() external pure returns (address);
27 
28     function addLiquidity(
29         address tokenA,
30         address tokenB,
31         uint256 amountADesired,
32         uint256 amountBDesired,
33         uint256 amountAMin,
34         uint256 amountBMin,
35         address to,
36         uint256 deadline
37     )
38         external
39         returns (
40             uint256 amountA,
41             uint256 amountB,
42             uint256 liquidity
43         );
44 
45     function addLiquidityETH(
46         address token,
47         uint256 amountTokenDesired,
48         uint256 amountTokenMin,
49         uint256 amountETHMin,
50         address to,
51         uint256 deadline
52     )
53         external
54         payable
55         returns (
56             uint256 amountToken,
57             uint256 amountETH,
58             uint256 liquidity
59         );
60 
61     function removeLiquidity(
62         address tokenA,
63         address tokenB,
64         uint256 liquidity,
65         uint256 amountAMin,
66         uint256 amountBMin,
67         address to,
68         uint256 deadline
69     ) external returns (uint256 amountA, uint256 amountB);
70 
71     function removeLiquidityETH(
72         address token,
73         uint256 liquidity,
74         uint256 amountTokenMin,
75         uint256 amountETHMin,
76         address to,
77         uint256 deadline
78     ) external returns (uint256 amountToken, uint256 amountETH);
79 
80     function removeLiquidityWithPermit(
81         address tokenA,
82         address tokenB,
83         uint256 liquidity,
84         uint256 amountAMin,
85         uint256 amountBMin,
86         address to,
87         uint256 deadline,
88         bool approveMax,
89         uint8 v,
90         bytes32 r,
91         bytes32 s
92     ) external returns (uint256 amountA, uint256 amountB);
93 
94     function removeLiquidityETHWithPermit(
95         address token,
96         uint256 liquidity,
97         uint256 amountTokenMin,
98         uint256 amountETHMin,
99         address to,
100         uint256 deadline,
101         bool approveMax,
102         uint8 v,
103         bytes32 r,
104         bytes32 s
105     ) external returns (uint256 amountToken, uint256 amountETH);
106 
107     function swapExactTokensForTokens(
108         uint256 amountIn,
109         uint256 amountOutMin,
110         address[] calldata path,
111         address to,
112         uint256 deadline
113     ) external returns (uint256[] memory amounts);
114 
115     function swapTokensForExactTokens(
116         uint256 amountOut,
117         uint256 amountInMax,
118         address[] calldata path,
119         address to,
120         uint256 deadline
121     ) external returns (uint256[] memory amounts);
122 
123     function swapExactETHForTokens(
124         uint256 amountOutMin,
125         address[] calldata path,
126         address to,
127         uint256 deadline
128     ) external payable returns (uint256[] memory amounts);
129 
130     function swapTokensForExactETH(
131         uint256 amountOut,
132         uint256 amountInMax,
133         address[] calldata path,
134         address to,
135         uint256 deadline
136     ) external returns (uint256[] memory amounts);
137 
138     function swapExactTokensForETH(
139         uint256 amountIn,
140         uint256 amountOutMin,
141         address[] calldata path,
142         address to,
143         uint256 deadline
144     ) external returns (uint256[] memory amounts);
145 
146     function swapETHForExactTokens(
147         uint256 amountOut,
148         address[] calldata path,
149         address to,
150         uint256 deadline
151     ) external payable returns (uint256[] memory amounts);
152 
153     function quote(
154         uint256 amountA,
155         uint256 reserveA,
156         uint256 reserveB
157     ) external pure returns (uint256 amountB);
158 
159     function getAmountOut(
160         uint256 amountIn,
161         uint256 reserveIn,
162         uint256 reserveOut
163     ) external pure returns (uint256 amountOut);
164 
165     function getAmountIn(
166         uint256 amountOut,
167         uint256 reserveIn,
168         uint256 reserveOut
169     ) external pure returns (uint256 amountIn);
170 
171     function getAmountsOut(uint256 amountIn, address[] calldata path)
172         external
173         view
174         returns (uint256[] memory amounts);
175 
176     function getAmountsIn(uint256 amountOut, address[] calldata path)
177         external
178         view
179         returns (uint256[] memory amounts);
180 }
181 
182 interface IUniswapRouter02 is IUniswapRouter01 {
183     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
184         uint256 amountIn,
185         uint256 amountOutMin,
186         address[] calldata path,
187         address to,
188         uint256 deadline
189     ) external;
190 
191     function swapExactETHForTokensSupportingFeeOnTransferTokens(
192         uint256 amountOutMin,
193         address[] calldata path,
194         address to,
195         uint256 deadline
196     ) external payable;
197 
198     function swapExactTokensForETHSupportingFeeOnTransferTokens(
199         uint256 amountIn,
200         uint256 amountOutMin,
201         address[] calldata path,
202         address to,
203         uint256 deadline
204     ) external;
205 }
206 
207 interface IFactory {
208     event PairCreated(
209         address indexed token0,
210         address indexed token1,
211         address pair,
212         uint256
213     );
214 
215     function feeTo() external view returns (address);
216 
217     function feeToSetter() external view returns (address);
218 
219     function getPair(address tokenA, address tokenB)
220         external
221         view
222         returns (address pair);
223 
224     function allPairs(uint256) external view returns (address pair);
225 
226     function allPairsLength() external view returns (uint256);
227 
228     function createPair(address tokenA, address tokenB)
229         external
230         returns (address pair);
231 
232     function setFeeTo(address) external;
233 
234     function setFeeToSetter(address) external;
235 
236     function INIT_CODE_PAIR_HASH() external view returns (bytes32);
237 }
238 
239 abstract contract Context {
240     //function _msgSender() internal view virtual returns (address payable) {
241     function _msgSender() internal view virtual returns (address) {
242         return msg.sender;
243     }
244 
245     function _msgData() internal view virtual returns (bytes memory) {
246         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
247         return msg.data;
248     }
249 }
250 
251 abstract contract Ownable is Context {
252     address private _owner;
253 
254     event OwnershipTransferred(
255         address indexed previousOwner,
256         address indexed newOwner
257     );
258 
259     /**
260      * @dev Initializes the contract setting the deployer as the initial owner.
261      */
262     constructor() {
263         _transferOwnership(_msgSender());
264     }
265 
266     /**
267      * @dev Returns the address of the current owner.
268      */
269     function owner() public view virtual returns (address) {
270         return _owner;
271     }
272 
273     /**
274      * @dev Throws if called by any account other than the owner.
275      */
276     modifier onlyOwner() {
277         require(owner() == _msgSender(), "Ownable: caller is not the owner");
278         _;
279     }
280 
281     /**
282      * @dev Leaves the contract without owner. It will not be possible to call
283      * `onlyOwner` functions anymore. Can only be called by the current owner.
284      *
285      * NOTE: Renouncing ownership will leave the contract without an owner,
286      * thereby removing any functionality that is only available to the owner.
287      */
288     function renounceOwnership() public virtual onlyOwner {
289         _transferOwnership(address(0));
290     }
291 
292     /**
293      * @dev Transfers ownership of the contract to a new account (`newOwner`).
294      * Can only be called by the current owner.
295      */
296     function transferOwnership(address newOwner) public virtual onlyOwner {
297         require(
298             newOwner != address(0),
299             "Ownable: new owner is the zero address"
300         );
301         _transferOwnership(newOwner);
302     }
303 
304     /**
305      * @dev Transfers ownership of the contract to a new account (`newOwner`).
306      * Internal function without access restriction.
307      */
308     function _transferOwnership(address newOwner) internal virtual {
309         address oldOwner = _owner;
310         _owner = newOwner;
311         emit OwnershipTransferred(oldOwner, newOwner);
312     }
313 }
314 
315 library Address {
316     /**
317      * @dev Returns true if `account` is a contract.
318      *
319      * [IMPORTANT]
320      * ====
321      * It is unsafe to assume that an address for which this function returns
322      * false is an externally-owned account (EOA) and not a contract.
323      *
324      * Among others, `isContract` will return false for the following
325      * types of addresses:
326      *
327      *  - an externally-owned account
328      *  - a contract in construction
329      *  - an address where a contract will be created
330      *  - an address where a contract lived, but was destroyed
331      * ====
332      *
333      * [IMPORTANT]
334      * ====
335      * You shouldn't rely on `isContract` to protect against flash loan attacks!
336      *
337      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
338      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
339      * constructor.
340      * ====
341      */
342     function isContract(address account) internal view returns (bool) {
343         // This method relies on extcodesize/address.code.length, which returns 0
344         // for contracts in construction, since the code is only stored at the end
345         // of the constructor execution.
346 
347         return account.code.length > 0;
348     }
349 
350     /**
351      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
352      * `recipient`, forwarding all available gas and reverting on errors.
353      *
354      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
355      * of certain opcodes, possibly making contracts go over the 2300 gas limit
356      * imposed by `transfer`, making them unable to receive funds via
357      * `transfer`. {sendValue} removes this limitation.
358      *
359      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
360      *
361      * IMPORTANT: because control is transferred to `recipient`, care must be
362      * taken to not create reentrancy vulnerabilities. Consider using
363      * {ReentrancyGuard} or the
364      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
365      */
366     function sendValue(address payable recipient, uint256 amount) internal {
367         require(
368             address(this).balance >= amount,
369             "Address: insufficient balance"
370         );
371 
372         (bool success, ) = recipient.call{value: amount}("");
373         require(
374             success,
375             "Address: unable to send value, recipient may have reverted"
376         );
377     }
378 
379     /**
380      * @dev Performs a Solidity function call using a low level `call`. A
381      * plain `call` is an unsafe replacement for a function call: use this
382      * function instead.
383      *
384      * If `target` reverts with a revert reason, it is bubbled up by this
385      * function (like regular Solidity function calls).
386      *
387      * Returns the raw returned data. To convert to the expected return value,
388      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
389      *
390      * Requirements:
391      *
392      * - `target` must be a contract.
393      * - calling `target` with `data` must not revert.
394      *
395      * _Available since v3.1._
396      */
397     function functionCall(address target, bytes memory data)
398         internal
399         returns (bytes memory)
400     {
401         return functionCall(target, data, "Address: low-level call failed");
402     }
403 
404     /**
405      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
406      * `errorMessage` as a fallback revert reason when `target` reverts.
407      *
408      * _Available since v3.1._
409      */
410     function functionCall(
411         address target,
412         bytes memory data,
413         string memory errorMessage
414     ) internal returns (bytes memory) {
415         return functionCallWithValue(target, data, 0, errorMessage);
416     }
417 
418     /**
419      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
420      * but also transferring `value` wei to `target`.
421      *
422      * Requirements:
423      *
424      * - the calling contract must have an ETH balance of at least `value`.
425      * - the called Solidity function must be `payable`.
426      *
427      * _Available since v3.1._
428      */
429     function functionCallWithValue(
430         address target,
431         bytes memory data,
432         uint256 value
433     ) internal returns (bytes memory) {
434         return
435             functionCallWithValue(
436                 target,
437                 data,
438                 value,
439                 "Address: low-level call with value failed"
440             );
441     }
442 
443     /**
444      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
445      * with `errorMessage` as a fallback revert reason when `target` reverts.
446      *
447      * _Available since v3.1._
448      */
449     function functionCallWithValue(
450         address target,
451         bytes memory data,
452         uint256 value,
453         string memory errorMessage
454     ) internal returns (bytes memory) {
455         require(
456             address(this).balance >= value,
457             "Address: insufficient balance for call"
458         );
459         require(isContract(target), "Address: call to non-contract");
460 
461         (bool success, bytes memory returndata) = target.call{value: value}(
462             data
463         );
464         return verifyCallResult(success, returndata, errorMessage);
465     }
466 
467     /**
468      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
469      * but performing a static call.
470      *
471      * _Available since v3.3._
472      */
473     function functionStaticCall(address target, bytes memory data)
474         internal
475         view
476         returns (bytes memory)
477     {
478         return
479             functionStaticCall(
480                 target,
481                 data,
482                 "Address: low-level static call failed"
483             );
484     }
485 
486     /**
487      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
488      * but performing a static call.
489      *
490      * _Available since v3.3._
491      */
492     function functionStaticCall(
493         address target,
494         bytes memory data,
495         string memory errorMessage
496     ) internal view returns (bytes memory) {
497         require(isContract(target), "Address: static call to non-contract");
498 
499         (bool success, bytes memory returndata) = target.staticcall(data);
500         return verifyCallResult(success, returndata, errorMessage);
501     }
502 
503     /**
504      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
505      * but performing a delegate call.
506      *
507      * _Available since v3.4._
508      */
509     function functionDelegateCall(address target, bytes memory data)
510         internal
511         returns (bytes memory)
512     {
513         return
514             functionDelegateCall(
515                 target,
516                 data,
517                 "Address: low-level delegate call failed"
518             );
519     }
520 
521     /**
522      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
523      * but performing a delegate call.
524      *
525      * _Available since v3.4._
526      */
527     function functionDelegateCall(
528         address target,
529         bytes memory data,
530         string memory errorMessage
531     ) internal returns (bytes memory) {
532         require(isContract(target), "Address: delegate call to non-contract");
533 
534         (bool success, bytes memory returndata) = target.delegatecall(data);
535         return verifyCallResult(success, returndata, errorMessage);
536     }
537 
538     /**
539      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
540      * revert reason using the provided one.
541      *
542      * _Available since v4.3._
543      */
544     function verifyCallResult(
545         bool success,
546         bytes memory returndata,
547         string memory errorMessage
548     ) internal pure returns (bytes memory) {
549         if (success) {
550             return returndata;
551         } else {
552             // Look for revert reason and bubble it up if present
553             if (returndata.length > 0) {
554                 // The easiest way to bubble the revert reason is using memory via assembly
555 
556                 assembly {
557                     let returndata_size := mload(returndata)
558                     revert(add(32, returndata), returndata_size)
559                 }
560             } else {
561                 revert(errorMessage);
562             }
563         }
564     }
565 }
566 
567 library SafeERC20 {
568     using Address for address;
569 
570     function safeTransfer(
571         IERC20 token,
572         address to,
573         uint256 value
574     ) internal {
575         _callOptionalReturn(
576             token,
577             abi.encodeWithSelector(token.transfer.selector, to, value)
578         );
579     }
580 
581     function safeTransferFrom(
582         IERC20 token,
583         address from,
584         address to,
585         uint256 value
586     ) internal {
587         _callOptionalReturn(
588             token,
589             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
590         );
591     }
592 
593     /**
594      * @dev Deprecated. This function has issues similar to the ones found in
595      * {IERC20-approve}, and its usage is discouraged.
596      *
597      * Whenever possible, use {safeIncreaseAllowance} and
598      * {safeDecreaseAllowance} instead.
599      */
600     function safeApprove(
601         IERC20 token,
602         address spender,
603         uint256 value
604     ) internal {
605         // safeApprove should only be called when setting an initial allowance,
606         // or when resetting it to zero. To increase and decrease it, use
607         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
608         require(
609             (value == 0) || (token.allowance(address(this), spender) == 0),
610             "SafeERC20: approve from non-zero to non-zero allowance"
611         );
612         _callOptionalReturn(
613             token,
614             abi.encodeWithSelector(token.approve.selector, spender, value)
615         );
616     }
617 
618     function safeIncreaseAllowance(
619         IERC20 token,
620         address spender,
621         uint256 value
622     ) internal {
623         uint256 newAllowance = token.allowance(address(this), spender) + value;
624         _callOptionalReturn(
625             token,
626             abi.encodeWithSelector(
627                 token.approve.selector,
628                 spender,
629                 newAllowance
630             )
631         );
632     }
633 
634     function safeDecreaseAllowance(
635         IERC20 token,
636         address spender,
637         uint256 value
638     ) internal {
639         unchecked {
640             uint256 oldAllowance = token.allowance(address(this), spender);
641             require(
642                 oldAllowance >= value,
643                 "SafeERC20: decreased allowance below zero"
644             );
645             uint256 newAllowance = oldAllowance - value;
646             _callOptionalReturn(
647                 token,
648                 abi.encodeWithSelector(
649                     token.approve.selector,
650                     spender,
651                     newAllowance
652                 )
653             );
654         }
655     }
656 
657     /**
658      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
659      * on the return value: the return value is optional (but if data is returned, it must not be false).
660      * @param token The token targeted by the call.
661      * @param data The call data (encoded using abi.encode or one of its variants).
662      */
663     function _callOptionalReturn(IERC20 token, bytes memory data) private {
664         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
665         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
666         // the target address contains contract code and also asserts for success in the low-level call.
667 
668         bytes memory returndata = address(token).functionCall(
669             data,
670             "SafeERC20: low-level call failed"
671         );
672         if (returndata.length > 0) {
673             // Return data is optional
674             require(
675                 abi.decode(returndata, (bool)),
676                 "SafeERC20: ERC20 operation did not succeed"
677             );
678         }
679     }
680 }
681 
682 interface IERC20 {
683     /**
684      * @dev Emitted when `value` tokens are moved from one account (`from`) to
685      * another (`to`).
686      *
687      * Note that `value` may be zero.
688      */
689     event Transfer(address indexed from, address indexed to, uint256 value);
690 
691     /**
692      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
693      * a call to {approve}. `value` is the new allowance.
694      */
695     event Approval(
696         address indexed owner,
697         address indexed spender,
698         uint256 value
699     );
700 
701     /**
702      * @dev Returns the amount of tokens in existence.
703      */
704     function totalSupply() external view returns (uint256);
705 
706     /**
707      * @dev Returns the amount of tokens owned by `account`.
708      */
709     function balanceOf(address account) external view returns (uint256);
710 
711     /**
712      * @dev Moves `amount` tokens from the caller's account to `to`.
713      *
714      * Returns a boolean value indicating whether the operation succeeded.
715      *
716      * Emits a {Transfer} event.
717      */
718     function transfer(address to, uint256 amount) external returns (bool);
719 
720     /**
721      * @dev Returns the remaining number of tokens that `spender` will be
722      * allowed to spend on behalf of `owner` through {transferFrom}. This is
723      * zero by default.
724      *
725      * This value changes when {approve} or {transferFrom} are called.
726      */
727     function allowance(address owner, address spender)
728         external
729         view
730         returns (uint256);
731 
732     /**
733      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
734      *
735      * Returns a boolean value indicating whether the operation succeeded.
736      *
737      * IMPORTANT: Beware that changing an allowance with this method brings the risk
738      * that someone may use both the old and the new allowance by unfortunate
739      * transaction ordering. One possible solution to mitigate this race
740      * condition is to first reduce the spender's allowance to 0 and set the
741      * desired value afterwards:
742      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
743      *
744      * Emits an {Approval} event.
745      */
746     function approve(address spender, uint256 amount) external returns (bool);
747 
748     /**
749      * @dev Moves `amount` tokens from `from` to `to` using the
750      * allowance mechanism. `amount` is then deducted from the caller's
751      * allowance.
752      *
753      * Returns a boolean value indicating whether the operation succeeded.
754      *
755      * Emits a {Transfer} event.
756      */
757     function transferFrom(
758         address from,
759         address to,
760         uint256 amount
761     ) external returns (bool);
762 }
763 
764 interface IERC20Metadata is IERC20 {
765     /**
766      * @dev Returns the name of the token.
767      */
768     function name() external view returns (string memory);
769 
770     /**
771      * @dev Returns the symbol of the token.
772      */
773     function symbol() external view returns (string memory);
774 
775     /**
776      * @dev Returns the decimals places of the token.
777      */
778     function decimals() external view returns (uint8);
779 }
780 
781 contract ERC20 is Context, IERC20, IERC20Metadata {
782     mapping(address => uint256) public _balances;
783 
784     mapping(address => mapping(address => uint256)) private _allowances;
785 
786     uint256 private _totalSupply;
787 
788     string private _name;
789     string private _symbol;
790 
791     /**
792      * @dev Sets the values for {name} and {symbol}.
793      *
794      * The default value of {decimals} is 18. To select a different value for
795      * {decimals} you should overload it.
796      *
797      * All two of these values are immutable: they can only be set once during
798      * construction.
799      */
800     constructor(string memory name_, string memory symbol_) {
801         _name = name_;
802         _symbol = symbol_;
803     }
804 
805     /**
806      * @dev Returns the name of the token.
807      */
808     function name() public view virtual override returns (string memory) {
809         return _name;
810     }
811 
812     /**
813      * @dev Returns the symbol of the token, usually a shorter version of the
814      * name.
815      */
816     function symbol() public view virtual override returns (string memory) {
817         return _symbol;
818     }
819 
820     /**
821      * @dev Returns the number of decimals used to get its user representation.
822      * For example, if `decimals` equals `2`, a balance of `505` tokens should
823      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
824      *
825      * Tokens usually opt for a value of 18, imitating the relationship between
826      * Ether and Wei. This is the value {ERC20} uses, unless this function is
827      * overridden;
828      *
829      * NOTE: This information is only used for _display_ purposes: it in
830      * no way affects any of the arithmetic of the contract, including
831      * {IERC20-balanceOf} and {IERC20-transfer}.
832      */
833     function decimals() public view virtual override returns (uint8) {
834         return 18;
835     }
836 
837     /**
838      * @dev See {IERC20-totalSupply}.
839      */
840     function totalSupply() public view virtual override returns (uint256) {
841         return _totalSupply;
842     }
843 
844     /**
845      * @dev See {IERC20-balanceOf}.
846      */
847     function balanceOf(address account)
848         public
849         view
850         virtual
851         override
852         returns (uint256)
853     {
854         return _balances[account];
855     }
856 
857     /**
858      * @dev See {IERC20-transfer}.
859      *
860      * Requirements:
861      *
862      * - `to` cannot be the zero address.
863      * - the caller must have a balance of at least `amount`.
864      */
865     function transfer(address to, uint256 amount)
866         public
867         virtual
868         override
869         returns (bool)
870     {
871         address owner = _msgSender();
872         _transfer(owner, to, amount);
873         return true;
874     }
875 
876     /**
877      * @dev See {IERC20-allowance}.
878      */
879     function allowance(address owner, address spender)
880         public
881         view
882         virtual
883         override
884         returns (uint256)
885     {
886         return _allowances[owner][spender];
887     }
888 
889     /**
890      * @dev See {IERC20-approve}.
891      *
892      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
893      * `transferFrom`. This is semantically equivalent to an infinite approval.
894      *
895      * Requirements:
896      *
897      * - `spender` cannot be the zero address.
898      */
899     function approve(address spender, uint256 amount)
900         public
901         virtual
902         override
903         returns (bool)
904     {
905         address owner = _msgSender();
906         _approve(owner, spender, amount);
907         return true;
908     }
909 
910     /**
911      * @dev See {IERC20-transferFrom}.
912      *
913      * Emits an {Approval} event indicating the updated allowance. This is not
914      * required by the EIP. See the note at the beginning of {ERC20}.
915      *
916      * NOTE: Does not update the allowance if the current allowance
917      * is the maximum `uint256`.
918      *
919      * Requirements:
920      *
921      * - `from` and `to` cannot be the zero address.
922      * - `from` must have a balance of at least `amount`.
923      * - the caller must have allowance for ``from``'s tokens of at least
924      * `amount`.
925      */
926     function transferFrom(
927         address from,
928         address to,
929         uint256 amount
930     ) public virtual override returns (bool) {
931         address spender = _msgSender();
932         _spendAllowance(from, spender, amount);
933         _transfer(from, to, amount);
934         return true;
935     }
936 
937     /**
938      * @dev Atomically increases the allowance granted to `spender` by the caller.
939      *
940      * This is an alternative to {approve} that can be used as a mitigation for
941      * problems described in {IERC20-approve}.
942      *
943      * Emits an {Approval} event indicating the updated allowance.
944      *
945      * Requirements:
946      *
947      * - `spender` cannot be the zero address.
948      */
949     function increaseAllowance(address spender, uint256 addedValue)
950         public
951         virtual
952         returns (bool)
953     {
954         address owner = _msgSender();
955         _approve(owner, spender, allowance(owner, spender) + addedValue);
956         return true;
957     }
958 
959     /**
960      * @dev Atomically decreases the allowance granted to `spender` by the caller.
961      *
962      * This is an alternative to {approve} that can be used as a mitigation for
963      * problems described in {IERC20-approve}.
964      *
965      * Emits an {Approval} event indicating the updated allowance.
966      *
967      * Requirements:
968      *
969      * - `spender` cannot be the zero address.
970      * - `spender` must have allowance for the caller of at least
971      * `subtractedValue`.
972      */
973     function decreaseAllowance(address spender, uint256 subtractedValue)
974         public
975         virtual
976         returns (bool)
977     {
978         address owner = _msgSender();
979         uint256 currentAllowance = allowance(owner, spender);
980         require(
981             currentAllowance >= subtractedValue,
982             "ERC20: decreased allowance below zero"
983         );
984         unchecked {
985             _approve(owner, spender, currentAllowance - subtractedValue);
986         }
987 
988         return true;
989     }
990 
991     /**
992      * @dev Moves `amount` of tokens from `sender` to `recipient`.
993      *
994      * This internal function is equivalent to {transfer}, and can be used to
995      * e.g. implement automatic token fees, slashing mechanisms, etc.
996      *
997      * Emits a {Transfer} event.
998      *
999      * Requirements:
1000      *
1001      * - `from` cannot be the zero address.
1002      * - `to` cannot be the zero address.
1003      * - `from` must have a balance of at least `amount`.
1004      */
1005     function _transfer(
1006         address from,
1007         address to,
1008         uint256 amount
1009     ) internal virtual {
1010         require(from != address(0), "ERC20: transfer from the zero address");
1011         require(to != address(0), "ERC20: transfer to the zero address");
1012 
1013         _beforeTokenTransfer(from, to, amount);
1014 
1015         uint256 fromBalance = _balances[from];
1016         require(
1017             fromBalance >= amount,
1018             "ERC20: transfer amount exceeds balance"
1019         );
1020         unchecked {
1021             _balances[from] = fromBalance - amount;
1022         }
1023         _balances[to] += amount;
1024 
1025         emit Transfer(from, to, amount);
1026 
1027         _afterTokenTransfer(from, to, amount);
1028     }
1029 
1030     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1031      * the total supply.
1032      *
1033      * Emits a {Transfer} event with `from` set to the zero address.
1034      *
1035      * Requirements:
1036      *
1037      * - `account` cannot be the zero address.
1038      */
1039     function _mint(address account, uint256 amount) internal virtual {
1040         require(account != address(0), "ERC20: mint to the zero address");
1041 
1042         _beforeTokenTransfer(address(0), account, amount);
1043 
1044         _totalSupply += amount;
1045         _balances[account] += amount;
1046         emit Transfer(address(0), account, amount);
1047 
1048         _afterTokenTransfer(address(0), account, amount);
1049     }
1050 
1051     /**
1052      * @dev Destroys `amount` tokens from `account`, reducing the
1053      * total supply.
1054      *
1055      * Emits a {Transfer} event with `to` set to the zero address.
1056      *
1057      * Requirements:
1058      *
1059      * - `account` cannot be the zero address.
1060      * - `account` must have at least `amount` tokens.
1061      */
1062     function _burn(address account, uint256 amount) internal virtual {
1063         require(account != address(0), "ERC20: burn from the zero address");
1064 
1065         _beforeTokenTransfer(account, address(0), amount);
1066 
1067         uint256 accountBalance = _balances[account];
1068         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1069         unchecked {
1070             _balances[account] = accountBalance - amount;
1071         }
1072         _totalSupply -= amount;
1073 
1074         emit Transfer(account, address(0), amount);
1075 
1076         _afterTokenTransfer(account, address(0), amount);
1077     }
1078 
1079     /**
1080      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1081      *
1082      * This internal function is equivalent to `approve`, and can be used to
1083      * e.g. set automatic allowances for certain subsystems, etc.
1084      *
1085      * Emits an {Approval} event.
1086      *
1087      * Requirements:
1088      *
1089      * - `owner` cannot be the zero address.
1090      * - `spender` cannot be the zero address.
1091      */
1092     function _approve(
1093         address owner,
1094         address spender,
1095         uint256 amount
1096     ) internal virtual {
1097         require(owner != address(0), "ERC20: approve from the zero address");
1098         require(spender != address(0), "ERC20: approve to the zero address");
1099 
1100         _allowances[owner][spender] = amount;
1101         emit Approval(owner, spender, amount);
1102     }
1103 
1104     /**
1105      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1106      *
1107      * Does not update the allowance amount in case of infinite allowance.
1108      * Revert if not enough allowance is available.
1109      *
1110      * Might emit an {Approval} event.
1111      */
1112     function _spendAllowance(
1113         address owner,
1114         address spender,
1115         uint256 amount
1116     ) internal virtual {
1117         uint256 currentAllowance = allowance(owner, spender);
1118         if (currentAllowance != type(uint256).max) {
1119             require(
1120                 currentAllowance >= amount,
1121                 "ERC20: insufficient allowance"
1122             );
1123             unchecked {
1124                 _approve(owner, spender, currentAllowance - amount);
1125             }
1126         }
1127     }
1128 
1129     /**
1130      * @dev Hook that is called before any transfer of tokens. This includes
1131      * minting and burning.
1132      *
1133      * Calling conditions:
1134      *
1135      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1136      * will be transferred to `to`.
1137      * - when `from` is zero, `amount` tokens will be minted for `to`.
1138      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1139      * - `from` and `to` are never both zero.
1140      *
1141      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1142      */
1143     function _beforeTokenTransfer(
1144         address from,
1145         address to,
1146         uint256 amount
1147     ) internal virtual {}
1148 
1149     /**
1150      * @dev Hook that is called after any transfer of tokens. This includes
1151      * minting and burning.
1152      *
1153      * Calling conditions:
1154      *
1155      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1156      * has been transferred to `to`.
1157      * - when `from` is zero, `amount` tokens have been minted for `to`.
1158      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1159      * - `from` and `to` are never both zero.
1160      *
1161      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1162      */
1163     function _afterTokenTransfer(
1164         address from,
1165         address to,
1166         uint256 amount
1167     ) internal virtual {}
1168 }
1169 
1170 interface uniswapV2Pair {
1171     function getReserves()
1172         external
1173         view
1174         returns (
1175             uint112 reserve0,
1176             uint112 reserve1,
1177             uint32 blockTimestampLast
1178         );
1179 }
1180 
1181 contract Foundation is ERC20, Ownable {
1182     address payable public marketingFeeAddress;
1183     address payable public devFeeAddress;
1184 
1185     address public immutable deadWallet = 0x000000000000000000000000000000000000dEaD;
1186     uint256 public maxWallet;
1187     uint16 constant maxFeeLimit = 300;
1188 
1189     bool public tradingActive;
1190 
1191     mapping(address => bool) public isExcludedFromFee;
1192     mapping(address => bool) public isExcludedFromMaxWallet;
1193 
1194     // these values are pretty much arbitrary since they get overwritten for every txn, but the placeholders make it easier to work with current contract.
1195     uint256 private _devFee;
1196     uint256 private _previousDevFee;
1197 
1198     uint256 private _liquidityFee;
1199     uint256 private _previousLiquidityFee;
1200 
1201     uint256 private _marketingFee;
1202     uint256 private _previousMarketingFee;
1203 
1204     uint256 private _burnFee;
1205     uint256 private _previousBurnFee;
1206 
1207     uint16 public buyDevFee = 5;
1208     uint16 public buyLiquidityFee = 20;
1209     uint16 public buyMarketingFee = 20;
1210     uint16 public buyBurnFee = 5;
1211 
1212     uint16 public sellDevFee = 5;
1213     uint16 public sellLiquidityFee = 20;
1214     uint16 public sellMarketingFee = 20;
1215     uint16 public sellBurnFee = 5;
1216 
1217     uint16 public transferDevFee = 0;
1218     uint16 public transferLiquidityFee = 0;
1219     uint16 public transferMarketingFee = 0;
1220     uint16 public transferBurnFee = 0;
1221 
1222     uint256 private _liquidityTokensToSwap;
1223     uint256 private _marketingFeeTokensToSwap;
1224     uint256 private _devFeeTokens;
1225     uint256 private _burnFeeTokens;
1226 
1227     mapping(address => bool) public automatedMarketMakerPairs;
1228 
1229     uint256 public minimumFeeTokensToTake;
1230 
1231     IUniswapRouter02 public immutable uniswapRouter;
1232     address public immutable uniswapPair;
1233 
1234     bool inSwapAndLiquify;
1235 
1236     address public bridge = address(0x123);
1237 
1238     modifier lockTheSwap() {
1239         inSwapAndLiquify = true;
1240         _;
1241         inSwapAndLiquify = false;
1242     }
1243 
1244     constructor() ERC20("Foundation", "FND") {
1245         _mint(msg.sender, 1e11 * 10**decimals());
1246         
1247         marketingFeeAddress = payable(
1248             0xE91aC95e2631DcE9ee2f52b363eF7F79D2903d5a
1249         );
1250         devFeeAddress = payable(0xcbffC68A35Cf6391B003f11E85D2820a32F2387F);
1251 
1252         minimumFeeTokensToTake = 1e9 * 10**decimals();
1253         address routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
1254         //address routerAddress = 0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3;
1255         uniswapRouter = IUniswapRouter02(payable(routerAddress));
1256 
1257         uniswapPair = IFactory(uniswapRouter.factory()).createPair(
1258             address(this),
1259             uniswapRouter.WETH()
1260         );
1261 
1262         isExcludedFromFee[_msgSender()] = true;
1263         isExcludedFromFee[address(this)] = true;
1264         isExcludedFromFee[marketingFeeAddress] = true;
1265         isExcludedFromFee[devFeeAddress] = true;
1266         maxWallet = totalSupply() * 2 / 100;
1267         _approve(msg.sender, routerAddress, ~uint256(0));
1268         _setAutomatedMarketMakerPair(uniswapPair, true);
1269         bridge = 0x27F63B82e68c21452247Ba65b87c4f0Fb7508f44;
1270         isExcludedFromFee[bridge] = true;
1271         isExcludedFromMaxWallet[bridge] = true;
1272     }
1273 
1274     function setBridge(address _bridge) external onlyOwner {
1275         bridge = _bridge;
1276         isExcludedFromFee[bridge] = true;
1277         isExcludedFromMaxWallet[bridge] = true;
1278     }
1279 
1280     function setMaxWallet(uint256 _maxWallet) external onlyOwner {
1281         maxWallet = _maxWallet * 10**decimals();
1282         require(maxWallet > totalSupply() / 100, "Max wallet must be greater than 1%");
1283     }
1284 
1285     function decimals() public pure override returns (uint8) {
1286         return 7;
1287     }
1288 
1289     function bridgeBalance() public view returns (uint256) {
1290         return _balances[bridge];
1291     }
1292 
1293     function totalSupply() public view override returns (uint256) {
1294         return super.totalSupply() - bridgeBalance();
1295     }
1296 
1297     function balanceOf(address account) public view override returns (uint256) {
1298         if (account == bridge) {
1299             return 0;
1300         }
1301         return super.balanceOf(account);
1302     }
1303 
1304     function setTradeStatus(bool status) external onlyOwner {
1305         tradingActive = status;
1306     }
1307 
1308     function updateMinimumTokensBeforeFeeTaken(uint256 _minimumFeeTokensToTake)
1309         external
1310         onlyOwner
1311     {
1312         minimumFeeTokensToTake = _minimumFeeTokensToTake * (10**decimals());
1313     }
1314 
1315     function setAutomatedMarketMakerPair(address pair, bool value)
1316         external
1317         onlyOwner
1318     {
1319         require(pair != uniswapPair, "The pair cannot be removed");
1320 
1321         _setAutomatedMarketMakerPair(pair, value);
1322     }
1323 
1324     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1325         automatedMarketMakerPairs[pair] = value;
1326     }
1327 
1328     function excludeFromFee(address account) external onlyOwner {
1329         isExcludedFromFee[account] = true;
1330     }
1331 
1332     function includeInFee(address account) external onlyOwner {
1333         isExcludedFromFee[account] = false;
1334     }
1335     
1336     function excludeFromMaxWallet(address account) external onlyOwner {
1337         isExcludedFromMaxWallet[account] = true;
1338     }
1339 
1340     function includeInMaxWallet(address account) external onlyOwner {
1341         isExcludedFromMaxWallet[account] = false;
1342     }
1343 
1344     function updateBuyFee(
1345         uint16 _buyDevFee,
1346         uint16 _buyLiquidityFee,
1347         uint16 _buyMarketingFee,
1348         uint16 _buyBurnFee
1349     ) external onlyOwner {
1350         buyDevFee = _buyDevFee;
1351         buyLiquidityFee = _buyLiquidityFee;
1352         buyMarketingFee = _buyMarketingFee;
1353         buyBurnFee = _buyBurnFee;
1354         require(
1355             _buyDevFee + _buyLiquidityFee + _buyMarketingFee + _buyBurnFee <=
1356                 maxFeeLimit,
1357             "Must keep fees below 30%"
1358         );
1359     }
1360 
1361     function updateSellFee(
1362         uint16 _sellDevFee,
1363         uint16 _sellLiquidityFee,
1364         uint16 _sellMarketingFee,
1365         uint16 _sellBurnFee
1366     ) external onlyOwner {
1367         sellDevFee = _sellDevFee;
1368         sellLiquidityFee = _sellLiquidityFee;
1369         sellMarketingFee = _sellMarketingFee;
1370         sellBurnFee = _sellBurnFee;
1371         require(
1372             _sellDevFee + _sellLiquidityFee + _sellMarketingFee + _sellBurnFee <=
1373                 maxFeeLimit,
1374             "Must keep fees <= 30%"
1375         );
1376     }
1377 
1378     function updateTransferFee(
1379         uint16 _transferDevFee,
1380         uint16 _transferLiquidityFee,
1381         uint16 _transferMarketingFee,
1382         uint16 _transferBurnFee
1383     ) external onlyOwner {
1384         transferDevFee = _transferDevFee;
1385         transferLiquidityFee = _transferLiquidityFee;
1386         transferMarketingFee = _transferMarketingFee;
1387         transferBurnFee = _transferBurnFee;
1388         require(
1389             _transferDevFee +
1390                 _transferLiquidityFee +
1391                 _transferMarketingFee + _transferBurnFee <= maxFeeLimit,
1392             "Must keep fees <= 30%"
1393         );
1394     }
1395 
1396     function updateMarketingFeeAddress(address a) external onlyOwner {
1397         require(a != address(0), "Can't set 0");
1398         marketingFeeAddress = payable(a);
1399     }
1400 
1401     function updateDevAddress(address a) external onlyOwner {
1402         require(a != address(0), "Can't set 0");
1403         devFeeAddress = payable(a);
1404     }
1405 
1406     function _transfer(
1407         address from,
1408         address to,
1409         uint256 amount
1410     ) internal override {
1411         if (!tradingActive) {
1412             require(
1413                 isExcludedFromFee[from] || isExcludedFromFee[to],
1414                 "Trading is not active yet."
1415             );
1416         }
1417 
1418         uint256 contractTokenBalance = balanceOf(address(this));
1419         bool overMinimumTokenBalance = contractTokenBalance >=
1420             minimumFeeTokensToTake;
1421 
1422         // Take Fee
1423         if (
1424             !inSwapAndLiquify &&
1425             overMinimumTokenBalance &&
1426             automatedMarketMakerPairs[to]
1427         ) {
1428             takeFee();
1429         }
1430 
1431         removeAllFee();
1432 
1433         // If any account belongs to isExcludedFromFee account then remove the fee
1434         if (!isExcludedFromFee[from] && !isExcludedFromFee[to]) {
1435             // High tax period
1436 
1437             // Buy
1438             if (automatedMarketMakerPairs[from]) {
1439                 _devFee = (amount * buyDevFee) / 1000;
1440                 _liquidityFee = (amount * buyLiquidityFee) / 1000;
1441                 _marketingFee = (amount * buyMarketingFee) / 1000;
1442                 _burnFee = (amount * buyBurnFee) / 1000;
1443             }
1444             // Sell
1445             else if (automatedMarketMakerPairs[to]) {
1446 
1447                 _devFee = (amount * sellDevFee) / 1000;
1448                 _liquidityFee = (amount * sellLiquidityFee) / 1000;
1449                 _marketingFee = (amount * sellMarketingFee) / 1000;
1450                 _burnFee = (amount * sellBurnFee) / 1000;
1451             } else {
1452                 _devFee = (amount * transferDevFee) / 1000;
1453                 _liquidityFee = (amount * transferLiquidityFee) / 1000;
1454                 _marketingFee = (amount * transferMarketingFee) / 1000;
1455                 _burnFee = (amount * transferBurnFee) / 1000;
1456             }
1457         }
1458 
1459         uint256 _transferAmount = amount -
1460             _devFee -
1461             _liquidityFee -
1462             _marketingFee -
1463             _burnFee;
1464         super._transfer(from, to, _transferAmount);
1465         if (!isExcludedFromFee[from] && !isExcludedFromFee[to] && to != deadWallet && !automatedMarketMakerPairs[to] && !isExcludedFromMaxWallet[to]) {
1466             require(balanceOf(to) <= maxWallet, "Max wallet limit reached");
1467         }
1468 
1469         uint256 _feeTotal = _devFee + _liquidityFee + _marketingFee + _burnFee;
1470         if (_feeTotal > 0) {
1471             super._transfer(from, address(this), _feeTotal);
1472             _liquidityTokensToSwap += _liquidityFee;
1473             _marketingFeeTokensToSwap += _marketingFee;
1474             _devFeeTokens += _devFee;
1475             _burnFeeTokens += _burnFee;
1476         }
1477         restoreAllFee();
1478     }
1479 
1480     function removeAllFee() private {
1481         if (
1482             _devFee == 0 &&
1483             _liquidityFee == 0 &&
1484             _marketingFee == 0 && 
1485             _burnFee == 0
1486         ) return;
1487 
1488         _previousDevFee = _devFee;
1489         _previousLiquidityFee = _liquidityFee;
1490         _previousMarketingFee = _marketingFee;
1491         _previousBurnFee = _burnFee;
1492 
1493         _devFee = 0;
1494         _liquidityFee = 0;
1495         _marketingFee = 0;
1496         _burnFee = 0;
1497     }
1498 
1499     function restoreAllFee() private {
1500         _devFee = _previousDevFee;
1501         _liquidityFee = _previousLiquidityFee;
1502         _marketingFee = _previousMarketingFee;
1503         _burnFee = _previousBurnFee;
1504     }
1505 
1506     function takeFee() private lockTheSwap {
1507         uint256 contractBalance = balanceOf(address(this));
1508         uint256 totalTokensTaken = _liquidityTokensToSwap +
1509             _marketingFeeTokensToSwap +
1510             _devFeeTokens;
1511         if (totalTokensTaken == 0 || contractBalance - _burnFeeTokens < totalTokensTaken) {
1512             return;
1513         }
1514 
1515         uint256 tokensForLiquidity = _liquidityTokensToSwap / 2;
1516         uint256 initialETHBalance = address(this).balance;
1517         uint256 toSwap = tokensForLiquidity +
1518             _marketingFeeTokensToSwap +
1519             _devFeeTokens;
1520         swapTokensForETH(toSwap);
1521         uint256 ethBalance = address(this).balance - initialETHBalance;
1522 
1523         uint256 ethForMarketing = (ethBalance * _marketingFeeTokensToSwap) /
1524             toSwap;
1525         uint256 ethForLiquidity = (ethBalance * tokensForLiquidity) / toSwap;
1526         uint256 ethForDev = (ethBalance * _devFeeTokens) / toSwap;
1527 
1528         if (tokensForLiquidity > 0 && ethForLiquidity > 0) {
1529             addLiquidity(tokensForLiquidity, ethForLiquidity);
1530         }
1531         bool success;
1532 
1533         (success, ) = address(marketingFeeAddress).call{
1534             value: ethForMarketing,
1535             gas:50000
1536         }("");
1537         (success, ) = address(devFeeAddress).call{
1538             value: ethForDev,
1539             gas:50000
1540         }("");
1541 
1542         // send burn tokens to dead wallet
1543         if (_burnFeeTokens > 0) {
1544             super._transfer(address(this), deadWallet, _burnFeeTokens);
1545         }
1546 
1547         _liquidityTokensToSwap = 0;
1548         _marketingFeeTokensToSwap = 0;
1549         _devFeeTokens = 0;
1550         _burnFeeTokens = 0;
1551     }
1552 
1553     function swapTokensForETH(uint256 tokenAmount) private {
1554         address[] memory path = new address[](2);
1555         path[0] = address(this);
1556         path[1] = uniswapRouter.WETH();
1557         _approve(address(this), address(uniswapRouter), tokenAmount);
1558         uniswapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
1559             tokenAmount,
1560             0,
1561             path,
1562             address(this),
1563             block.timestamp
1564         );
1565     }
1566 
1567     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1568         _approve(address(this), address(uniswapRouter), tokenAmount);
1569         uniswapRouter.addLiquidityETH{value: ethAmount}(
1570             address(this),
1571             tokenAmount,
1572             0, // slippage is unavoidable
1573             0, // slippage is unavoidable
1574             owner(),
1575             block.timestamp
1576         );
1577     }
1578 
1579     receive() external payable {}
1580  
1581     function withdrawETH() external onlyOwner {
1582         payable(owner()).transfer(address(this).balance);
1583     }
1584 
1585     function withdrawTokens(IERC20 tokenAddress, address walletAddress)
1586         external
1587         onlyOwner
1588     {
1589         require(
1590             walletAddress != address(0),
1591             "walletAddress can't be 0 address"
1592         );
1593         SafeERC20.safeTransfer(
1594             tokenAddress,
1595             walletAddress,
1596             tokenAddress.balanceOf(address(this))
1597         );
1598     }
1599 }