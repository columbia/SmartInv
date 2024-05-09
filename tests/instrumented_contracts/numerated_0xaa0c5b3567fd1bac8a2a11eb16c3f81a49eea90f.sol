1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.9;
3 
4 interface IUniswapRouter01 {
5     function factory() external pure returns (address);
6 
7     function WETH() external pure returns (address);
8 
9     function addLiquidity(
10         address tokenA,
11         address tokenB,
12         uint256 amountADesired,
13         uint256 amountBDesired,
14         uint256 amountAMin,
15         uint256 amountBMin,
16         address to,
17         uint256 deadline
18     )
19         external
20         returns (
21             uint256 amountA,
22             uint256 amountB,
23             uint256 liquidity
24         );
25 
26     function addLiquidityETH(
27         address token,
28         uint256 amountTokenDesired,
29         uint256 amountTokenMin,
30         uint256 amountETHMin,
31         address to,
32         uint256 deadline
33     )
34         external
35         payable
36         returns (
37             uint256 amountToken,
38             uint256 amountETH,
39             uint256 liquidity
40         );
41 
42     function removeLiquidity(
43         address tokenA,
44         address tokenB,
45         uint256 liquidity,
46         uint256 amountAMin,
47         uint256 amountBMin,
48         address to,
49         uint256 deadline
50     ) external returns (uint256 amountA, uint256 amountB);
51 
52     function removeLiquidityETH(
53         address token,
54         uint256 liquidity,
55         uint256 amountTokenMin,
56         uint256 amountETHMin,
57         address to,
58         uint256 deadline
59     ) external returns (uint256 amountToken, uint256 amountETH);
60 
61     function removeLiquidityWithPermit(
62         address tokenA,
63         address tokenB,
64         uint256 liquidity,
65         uint256 amountAMin,
66         uint256 amountBMin,
67         address to,
68         uint256 deadline,
69         bool approveMax,
70         uint8 v,
71         bytes32 r,
72         bytes32 s
73     ) external returns (uint256 amountA, uint256 amountB);
74 
75     function removeLiquidityETHWithPermit(
76         address token,
77         uint256 liquidity,
78         uint256 amountTokenMin,
79         uint256 amountETHMin,
80         address to,
81         uint256 deadline,
82         bool approveMax,
83         uint8 v,
84         bytes32 r,
85         bytes32 s
86     ) external returns (uint256 amountToken, uint256 amountETH);
87 
88     function swapExactTokensForTokens(
89         uint256 amountIn,
90         uint256 amountOutMin,
91         address[] calldata path,
92         address to,
93         uint256 deadline
94     ) external returns (uint256[] memory amounts);
95 
96     function swapTokensForExactTokens(
97         uint256 amountOut,
98         uint256 amountInMax,
99         address[] calldata path,
100         address to,
101         uint256 deadline
102     ) external returns (uint256[] memory amounts);
103 
104     function swapExactETHForTokens(
105         uint256 amountOutMin,
106         address[] calldata path,
107         address to,
108         uint256 deadline
109     ) external payable returns (uint256[] memory amounts);
110 
111     function swapTokensForExactETH(
112         uint256 amountOut,
113         uint256 amountInMax,
114         address[] calldata path,
115         address to,
116         uint256 deadline
117     ) external returns (uint256[] memory amounts);
118 
119     function swapExactTokensForETH(
120         uint256 amountIn,
121         uint256 amountOutMin,
122         address[] calldata path,
123         address to,
124         uint256 deadline
125     ) external returns (uint256[] memory amounts);
126 
127     function swapETHForExactTokens(
128         uint256 amountOut,
129         address[] calldata path,
130         address to,
131         uint256 deadline
132     ) external payable returns (uint256[] memory amounts);
133 
134     function quote(
135         uint256 amountA,
136         uint256 reserveA,
137         uint256 reserveB
138     ) external pure returns (uint256 amountB);
139 
140     function getAmountOut(
141         uint256 amountIn,
142         uint256 reserveIn,
143         uint256 reserveOut
144     ) external pure returns (uint256 amountOut);
145 
146     function getAmountIn(
147         uint256 amountOut,
148         uint256 reserveIn,
149         uint256 reserveOut
150     ) external pure returns (uint256 amountIn);
151 
152     function getAmountsOut(uint256 amountIn, address[] calldata path)
153         external
154         view
155         returns (uint256[] memory amounts);
156 
157     function getAmountsIn(uint256 amountOut, address[] calldata path)
158         external
159         view
160         returns (uint256[] memory amounts);
161 }
162 
163 interface IUniswapRouter02 is IUniswapRouter01 {
164     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
165         uint256 amountIn,
166         uint256 amountOutMin,
167         address[] calldata path,
168         address to,
169         uint256 deadline
170     ) external;
171 
172     function swapExactETHForTokensSupportingFeeOnTransferTokens(
173         uint256 amountOutMin,
174         address[] calldata path,
175         address to,
176         uint256 deadline
177     ) external payable;
178 
179     function swapExactTokensForETHSupportingFeeOnTransferTokens(
180         uint256 amountIn,
181         uint256 amountOutMin,
182         address[] calldata path,
183         address to,
184         uint256 deadline
185     ) external;
186 }
187 
188 interface IFactory {
189     event PairCreated(
190         address indexed token0,
191         address indexed token1,
192         address pair,
193         uint256
194     );
195 
196     function feeTo() external view returns (address);
197 
198     function feeToSetter() external view returns (address);
199 
200     function getPair(address tokenA, address tokenB)
201         external
202         view
203         returns (address pair);
204 
205     function allPairs(uint256) external view returns (address pair);
206 
207     function allPairsLength() external view returns (uint256);
208 
209     function createPair(address tokenA, address tokenB)
210         external
211         returns (address pair);
212 
213     function setFeeTo(address) external;
214 
215     function setFeeToSetter(address) external;
216 
217     function INIT_CODE_PAIR_HASH() external view returns (bytes32);
218 }
219 
220 abstract contract Context {
221     //function _msgSender() internal view virtual returns (address payable) {
222     function _msgSender() internal view virtual returns (address) {
223         return msg.sender;
224     }
225 
226     function _msgData() internal view virtual returns (bytes memory) {
227         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
228         return msg.data;
229     }
230 }
231 
232 abstract contract Ownable is Context {
233     address private _owner;
234 
235     event OwnershipTransferred(
236         address indexed previousOwner,
237         address indexed newOwner
238     );
239 
240     /**
241      * @dev Initializes the contract setting the deployer as the initial owner.
242      */
243     constructor() {
244         _transferOwnership(_msgSender());
245     }
246 
247     /**
248      * @dev Returns the address of the current owner.
249      */
250     function owner() public view virtual returns (address) {
251         return _owner;
252     }
253 
254     /**
255      * @dev Throws if called by any account other than the owner.
256      */
257     modifier onlyOwner() {
258         require(owner() == _msgSender(), "Ownable: caller is not the owner");
259         _;
260     }
261 
262     /**
263      * @dev Leaves the contract without owner. It will not be possible to call
264      * `onlyOwner` functions anymore. Can only be called by the current owner.
265      *
266      * NOTE: Renouncing ownership will leave the contract without an owner,
267      * thereby removing any functionality that is only available to the owner.
268      */
269     function renounceOwnership() public virtual onlyOwner {
270         _transferOwnership(address(0));
271     }
272 
273     /**
274      * @dev Transfers ownership of the contract to a new account (`newOwner`).
275      * Can only be called by the current owner.
276      */
277     function transferOwnership(address newOwner) public virtual onlyOwner {
278         require(
279             newOwner != address(0),
280             "Ownable: new owner is the zero address"
281         );
282         _transferOwnership(newOwner);
283     }
284 
285     /**
286      * @dev Transfers ownership of the contract to a new account (`newOwner`).
287      * Internal function without access restriction.
288      */
289     function _transferOwnership(address newOwner) internal virtual {
290         address oldOwner = _owner;
291         _owner = newOwner;
292         emit OwnershipTransferred(oldOwner, newOwner);
293     }
294 }
295 
296 library Address {
297     /**
298      * @dev Returns true if `account` is a contract.
299      *
300      * [IMPORTANT]
301      * ====
302      * It is unsafe to assume that an address for which this function returns
303      * false is an externally-owned account (EOA) and not a contract.
304      *
305      * Among others, `isContract` will return false for the following
306      * types of addresses:
307      *
308      *  - an externally-owned account
309      *  - a contract in construction
310      *  - an address where a contract will be created
311      *  - an address where a contract lived, but was destroyed
312      * ====
313      *
314      * [IMPORTANT]
315      * ====
316      * You shouldn't rely on `isContract` to protect against flash loan attacks!
317      *
318      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
319      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
320      * constructor.
321      * ====
322      */
323     function isContract(address account) internal view returns (bool) {
324         // This method relies on extcodesize/address.code.length, which returns 0
325         // for contracts in construction, since the code is only stored at the end
326         // of the constructor execution.
327 
328         return account.code.length > 0;
329     }
330 
331     /**
332      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
333      * `recipient`, forwarding all available gas and reverting on errors.
334      *
335      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
336      * of certain opcodes, possibly making contracts go over the 2300 gas limit
337      * imposed by `transfer`, making them unable to receive funds via
338      * `transfer`. {sendValue} removes this limitation.
339      *
340      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
341      *
342      * IMPORTANT: because control is transferred to `recipient`, care must be
343      * taken to not create reentrancy vulnerabilities. Consider using
344      * {ReentrancyGuard} or the
345      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
346      */
347     function sendValue(address payable recipient, uint256 amount) internal {
348         require(
349             address(this).balance >= amount,
350             "Address: insufficient balance"
351         );
352 
353         (bool success, ) = recipient.call{value: amount}("");
354         require(
355             success,
356             "Address: unable to send value, recipient may have reverted"
357         );
358     }
359 
360     /**
361      * @dev Performs a Solidity function call using a low level `call`. A
362      * plain `call` is an unsafe replacement for a function call: use this
363      * function instead.
364      *
365      * If `target` reverts with a revert reason, it is bubbled up by this
366      * function (like regular Solidity function calls).
367      *
368      * Returns the raw returned data. To convert to the expected return value,
369      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
370      *
371      * Requirements:
372      *
373      * - `target` must be a contract.
374      * - calling `target` with `data` must not revert.
375      *
376      * _Available since v3.1._
377      */
378     function functionCall(address target, bytes memory data)
379         internal
380         returns (bytes memory)
381     {
382         return functionCall(target, data, "Address: low-level call failed");
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
387      * `errorMessage` as a fallback revert reason when `target` reverts.
388      *
389      * _Available since v3.1._
390      */
391     function functionCall(
392         address target,
393         bytes memory data,
394         string memory errorMessage
395     ) internal returns (bytes memory) {
396         return functionCallWithValue(target, data, 0, errorMessage);
397     }
398 
399     /**
400      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
401      * but also transferring `value` wei to `target`.
402      *
403      * Requirements:
404      *
405      * - the calling contract must have an ETH balance of at least `value`.
406      * - the called Solidity function must be `payable`.
407      *
408      * _Available since v3.1._
409      */
410     function functionCallWithValue(
411         address target,
412         bytes memory data,
413         uint256 value
414     ) internal returns (bytes memory) {
415         return
416             functionCallWithValue(
417                 target,
418                 data,
419                 value,
420                 "Address: low-level call with value failed"
421             );
422     }
423 
424     /**
425      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
426      * with `errorMessage` as a fallback revert reason when `target` reverts.
427      *
428      * _Available since v3.1._
429      */
430     function functionCallWithValue(
431         address target,
432         bytes memory data,
433         uint256 value,
434         string memory errorMessage
435     ) internal returns (bytes memory) {
436         require(
437             address(this).balance >= value,
438             "Address: insufficient balance for call"
439         );
440         require(isContract(target), "Address: call to non-contract");
441 
442         (bool success, bytes memory returndata) = target.call{value: value}(
443             data
444         );
445         return verifyCallResult(success, returndata, errorMessage);
446     }
447 
448     /**
449      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
450      * but performing a static call.
451      *
452      * _Available since v3.3._
453      */
454     function functionStaticCall(address target, bytes memory data)
455         internal
456         view
457         returns (bytes memory)
458     {
459         return
460             functionStaticCall(
461                 target,
462                 data,
463                 "Address: low-level static call failed"
464             );
465     }
466 
467     /**
468      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
469      * but performing a static call.
470      *
471      * _Available since v3.3._
472      */
473     function functionStaticCall(
474         address target,
475         bytes memory data,
476         string memory errorMessage
477     ) internal view returns (bytes memory) {
478         require(isContract(target), "Address: static call to non-contract");
479 
480         (bool success, bytes memory returndata) = target.staticcall(data);
481         return verifyCallResult(success, returndata, errorMessage);
482     }
483 
484     /**
485      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
486      * but performing a delegate call.
487      *
488      * _Available since v3.4._
489      */
490     function functionDelegateCall(address target, bytes memory data)
491         internal
492         returns (bytes memory)
493     {
494         return
495             functionDelegateCall(
496                 target,
497                 data,
498                 "Address: low-level delegate call failed"
499             );
500     }
501 
502     /**
503      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
504      * but performing a delegate call.
505      *
506      * _Available since v3.4._
507      */
508     function functionDelegateCall(
509         address target,
510         bytes memory data,
511         string memory errorMessage
512     ) internal returns (bytes memory) {
513         require(isContract(target), "Address: delegate call to non-contract");
514 
515         (bool success, bytes memory returndata) = target.delegatecall(data);
516         return verifyCallResult(success, returndata, errorMessage);
517     }
518 
519     /**
520      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
521      * revert reason using the provided one.
522      *
523      * _Available since v4.3._
524      */
525     function verifyCallResult(
526         bool success,
527         bytes memory returndata,
528         string memory errorMessage
529     ) internal pure returns (bytes memory) {
530         if (success) {
531             return returndata;
532         } else {
533             // Look for revert reason and bubble it up if present
534             if (returndata.length > 0) {
535                 // The easiest way to bubble the revert reason is using memory via assembly
536 
537                 assembly {
538                     let returndata_size := mload(returndata)
539                     revert(add(32, returndata), returndata_size)
540                 }
541             } else {
542                 revert(errorMessage);
543             }
544         }
545     }
546 }
547 
548 library SafeERC20 {
549     using Address for address;
550 
551     function safeTransfer(
552         IERC20 token,
553         address to,
554         uint256 value
555     ) internal {
556         _callOptionalReturn(
557             token,
558             abi.encodeWithSelector(token.transfer.selector, to, value)
559         );
560     }
561 
562     function safeTransferFrom(
563         IERC20 token,
564         address from,
565         address to,
566         uint256 value
567     ) internal {
568         _callOptionalReturn(
569             token,
570             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
571         );
572     }
573 
574     /**
575      * @dev Deprecated. This function has issues similar to the ones found in
576      * {IERC20-approve}, and its usage is discouraged.
577      *
578      * Whenever possible, use {safeIncreaseAllowance} and
579      * {safeDecreaseAllowance} instead.
580      */
581     function safeApprove(
582         IERC20 token,
583         address spender,
584         uint256 value
585     ) internal {
586         // safeApprove should only be called when setting an initial allowance,
587         // or when resetting it to zero. To increase and decrease it, use
588         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
589         require(
590             (value == 0) || (token.allowance(address(this), spender) == 0),
591             "SafeERC20: approve from non-zero to non-zero allowance"
592         );
593         _callOptionalReturn(
594             token,
595             abi.encodeWithSelector(token.approve.selector, spender, value)
596         );
597     }
598 
599     function safeIncreaseAllowance(
600         IERC20 token,
601         address spender,
602         uint256 value
603     ) internal {
604         uint256 newAllowance = token.allowance(address(this), spender) + value;
605         _callOptionalReturn(
606             token,
607             abi.encodeWithSelector(
608                 token.approve.selector,
609                 spender,
610                 newAllowance
611             )
612         );
613     }
614 
615     function safeDecreaseAllowance(
616         IERC20 token,
617         address spender,
618         uint256 value
619     ) internal {
620         unchecked {
621             uint256 oldAllowance = token.allowance(address(this), spender);
622             require(
623                 oldAllowance >= value,
624                 "SafeERC20: decreased allowance below zero"
625             );
626             uint256 newAllowance = oldAllowance - value;
627             _callOptionalReturn(
628                 token,
629                 abi.encodeWithSelector(
630                     token.approve.selector,
631                     spender,
632                     newAllowance
633                 )
634             );
635         }
636     }
637 
638     /**
639      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
640      * on the return value: the return value is optional (but if data is returned, it must not be false).
641      * @param token The token targeted by the call.
642      * @param data The call data (encoded using abi.encode or one of its variants).
643      */
644     function _callOptionalReturn(IERC20 token, bytes memory data) private {
645         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
646         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
647         // the target address contains contract code and also asserts for success in the low-level call.
648 
649         bytes memory returndata = address(token).functionCall(
650             data,
651             "SafeERC20: low-level call failed"
652         );
653         if (returndata.length > 0) {
654             // Return data is optional
655             require(
656                 abi.decode(returndata, (bool)),
657                 "SafeERC20: ERC20 operation did not succeed"
658             );
659         }
660     }
661 }
662 
663 interface IERC20 {
664     /**
665      * @dev Emitted when `value` tokens are moved from one account (`from`) to
666      * another (`to`).
667      *
668      * Note that `value` may be zero.
669      */
670     event Transfer(address indexed from, address indexed to, uint256 value);
671 
672     /**
673      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
674      * a call to {approve}. `value` is the new allowance.
675      */
676     event Approval(
677         address indexed owner,
678         address indexed spender,
679         uint256 value
680     );
681 
682     /**
683      * @dev Returns the amount of tokens in existence.
684      */
685     function totalSupply() external view returns (uint256);
686 
687     /**
688      * @dev Returns the amount of tokens owned by `account`.
689      */
690     function balanceOf(address account) external view returns (uint256);
691 
692     /**
693      * @dev Moves `amount` tokens from the caller's account to `to`.
694      *
695      * Returns a boolean value indicating whether the operation succeeded.
696      *
697      * Emits a {Transfer} event.
698      */
699     function transfer(address to, uint256 amount) external returns (bool);
700 
701     /**
702      * @dev Returns the remaining number of tokens that `spender` will be
703      * allowed to spend on behalf of `owner` through {transferFrom}. This is
704      * zero by default.
705      *
706      * This value changes when {approve} or {transferFrom} are called.
707      */
708     function allowance(address owner, address spender)
709         external
710         view
711         returns (uint256);
712 
713     /**
714      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
715      *
716      * Returns a boolean value indicating whether the operation succeeded.
717      *
718      * IMPORTANT: Beware that changing an allowance with this method brings the risk
719      * that someone may use both the old and the new allowance by unfortunate
720      * transaction ordering. One possible solution to mitigate this race
721      * condition is to first reduce the spender's allowance to 0 and set the
722      * desired value afterwards:
723      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
724      *
725      * Emits an {Approval} event.
726      */
727     function approve(address spender, uint256 amount) external returns (bool);
728 
729     /**
730      * @dev Moves `amount` tokens from `from` to `to` using the
731      * allowance mechanism. `amount` is then deducted from the caller's
732      * allowance.
733      *
734      * Returns a boolean value indicating whether the operation succeeded.
735      *
736      * Emits a {Transfer} event.
737      */
738     function transferFrom(
739         address from,
740         address to,
741         uint256 amount
742     ) external returns (bool);
743 }
744 
745 interface IERC20Metadata is IERC20 {
746     /**
747      * @dev Returns the name of the token.
748      */
749     function name() external view returns (string memory);
750 
751     /**
752      * @dev Returns the symbol of the token.
753      */
754     function symbol() external view returns (string memory);
755 
756     /**
757      * @dev Returns the decimals places of the token.
758      */
759     function decimals() external view returns (uint8);
760 }
761 
762 contract ERC20 is Context, IERC20, IERC20Metadata {
763     mapping(address => uint256) private _balances;
764 
765     mapping(address => mapping(address => uint256)) private _allowances;
766 
767     uint256 private _totalSupply;
768 
769     string private _name;
770     string private _symbol;
771 
772     /**
773      * @dev Sets the values for {name} and {symbol}.
774      *
775      * The default value of {decimals} is 18. To select a different value for
776      * {decimals} you should overload it.
777      *
778      * All two of these values are immutable: they can only be set once during
779      * construction.
780      */
781     constructor(string memory name_, string memory symbol_) {
782         _name = name_;
783         _symbol = symbol_;
784     }
785 
786     /**
787      * @dev Returns the name of the token.
788      */
789     function name() public view virtual override returns (string memory) {
790         return _name;
791     }
792 
793     /**
794      * @dev Returns the symbol of the token, usually a shorter version of the
795      * name.
796      */
797     function symbol() public view virtual override returns (string memory) {
798         return _symbol;
799     }
800 
801     /**
802      * @dev Returns the number of decimals used to get its user representation.
803      * For example, if `decimals` equals `2`, a balance of `505` tokens should
804      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
805      *
806      * Tokens usually opt for a value of 18, imitating the relationship between
807      * Ether and Wei. This is the value {ERC20} uses, unless this function is
808      * overridden;
809      *
810      * NOTE: This information is only used for _display_ purposes: it in
811      * no way affects any of the arithmetic of the contract, including
812      * {IERC20-balanceOf} and {IERC20-transfer}.
813      */
814     function decimals() public view virtual override returns (uint8) {
815         return 18;
816     }
817 
818     /**
819      * @dev See {IERC20-totalSupply}.
820      */
821     function totalSupply() public view virtual override returns (uint256) {
822         return _totalSupply;
823     }
824 
825     /**
826      * @dev See {IERC20-balanceOf}.
827      */
828     function balanceOf(address account)
829         public
830         view
831         virtual
832         override
833         returns (uint256)
834     {
835         return _balances[account];
836     }
837 
838     /**
839      * @dev See {IERC20-transfer}.
840      *
841      * Requirements:
842      *
843      * - `to` cannot be the zero address.
844      * - the caller must have a balance of at least `amount`.
845      */
846     function transfer(address to, uint256 amount)
847         public
848         virtual
849         override
850         returns (bool)
851     {
852         address owner = _msgSender();
853         _transfer(owner, to, amount);
854         return true;
855     }
856 
857     /**
858      * @dev See {IERC20-allowance}.
859      */
860     function allowance(address owner, address spender)
861         public
862         view
863         virtual
864         override
865         returns (uint256)
866     {
867         return _allowances[owner][spender];
868     }
869 
870     /**
871      * @dev See {IERC20-approve}.
872      *
873      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
874      * `transferFrom`. This is semantically equivalent to an infinite approval.
875      *
876      * Requirements:
877      *
878      * - `spender` cannot be the zero address.
879      */
880     function approve(address spender, uint256 amount)
881         public
882         virtual
883         override
884         returns (bool)
885     {
886         address owner = _msgSender();
887         _approve(owner, spender, amount);
888         return true;
889     }
890 
891     /**
892      * @dev See {IERC20-transferFrom}.
893      *
894      * Emits an {Approval} event indicating the updated allowance. This is not
895      * required by the EIP. See the note at the beginning of {ERC20}.
896      *
897      * NOTE: Does not update the allowance if the current allowance
898      * is the maximum `uint256`.
899      *
900      * Requirements:
901      *
902      * - `from` and `to` cannot be the zero address.
903      * - `from` must have a balance of at least `amount`.
904      * - the caller must have allowance for ``from``'s tokens of at least
905      * `amount`.
906      */
907     function transferFrom(
908         address from,
909         address to,
910         uint256 amount
911     ) public virtual override returns (bool) {
912         address spender = _msgSender();
913         _spendAllowance(from, spender, amount);
914         _transfer(from, to, amount);
915         return true;
916     }
917 
918     /**
919      * @dev Atomically increases the allowance granted to `spender` by the caller.
920      *
921      * This is an alternative to {approve} that can be used as a mitigation for
922      * problems described in {IERC20-approve}.
923      *
924      * Emits an {Approval} event indicating the updated allowance.
925      *
926      * Requirements:
927      *
928      * - `spender` cannot be the zero address.
929      */
930     function increaseAllowance(address spender, uint256 addedValue)
931         public
932         virtual
933         returns (bool)
934     {
935         address owner = _msgSender();
936         _approve(owner, spender, allowance(owner, spender) + addedValue);
937         return true;
938     }
939 
940     /**
941      * @dev Atomically decreases the allowance granted to `spender` by the caller.
942      *
943      * This is an alternative to {approve} that can be used as a mitigation for
944      * problems described in {IERC20-approve}.
945      *
946      * Emits an {Approval} event indicating the updated allowance.
947      *
948      * Requirements:
949      *
950      * - `spender` cannot be the zero address.
951      * - `spender` must have allowance for the caller of at least
952      * `subtractedValue`.
953      */
954     function decreaseAllowance(address spender, uint256 subtractedValue)
955         public
956         virtual
957         returns (bool)
958     {
959         address owner = _msgSender();
960         uint256 currentAllowance = allowance(owner, spender);
961         require(
962             currentAllowance >= subtractedValue,
963             "ERC20: decreased allowance below zero"
964         );
965         unchecked {
966             _approve(owner, spender, currentAllowance - subtractedValue);
967         }
968 
969         return true;
970     }
971 
972     /**
973      * @dev Moves `amount` of tokens from `sender` to `recipient`.
974      *
975      * This internal function is equivalent to {transfer}, and can be used to
976      * e.g. implement automatic token fees, slashing mechanisms, etc.
977      *
978      * Emits a {Transfer} event.
979      *
980      * Requirements:
981      *
982      * - `from` cannot be the zero address.
983      * - `to` cannot be the zero address.
984      * - `from` must have a balance of at least `amount`.
985      */
986     function _transfer(
987         address from,
988         address to,
989         uint256 amount
990     ) internal virtual {
991         require(from != address(0), "ERC20: transfer from the zero address");
992         require(to != address(0), "ERC20: transfer to the zero address");
993 
994         _beforeTokenTransfer(from, to, amount);
995 
996         uint256 fromBalance = _balances[from];
997         require(
998             fromBalance >= amount,
999             "ERC20: transfer amount exceeds balance"
1000         );
1001         unchecked {
1002             _balances[from] = fromBalance - amount;
1003         }
1004         _balances[to] += amount;
1005 
1006         emit Transfer(from, to, amount);
1007 
1008         _afterTokenTransfer(from, to, amount);
1009     }
1010 
1011     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1012      * the total supply.
1013      *
1014      * Emits a {Transfer} event with `from` set to the zero address.
1015      *
1016      * Requirements:
1017      *
1018      * - `account` cannot be the zero address.
1019      */
1020     function _mint(address account, uint256 amount) internal virtual {
1021         require(account != address(0), "ERC20: mint to the zero address");
1022 
1023         _beforeTokenTransfer(address(0), account, amount);
1024 
1025         _totalSupply += amount;
1026         _balances[account] += amount;
1027         emit Transfer(address(0), account, amount);
1028 
1029         _afterTokenTransfer(address(0), account, amount);
1030     }
1031 
1032     /**
1033      * @dev Destroys `amount` tokens from `account`, reducing the
1034      * total supply.
1035      *
1036      * Emits a {Transfer} event with `to` set to the zero address.
1037      *
1038      * Requirements:
1039      *
1040      * - `account` cannot be the zero address.
1041      * - `account` must have at least `amount` tokens.
1042      */
1043     function _burn(address account, uint256 amount) internal virtual {
1044         require(account != address(0), "ERC20: burn from the zero address");
1045 
1046         _beforeTokenTransfer(account, address(0), amount);
1047 
1048         uint256 accountBalance = _balances[account];
1049         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1050         unchecked {
1051             _balances[account] = accountBalance - amount;
1052         }
1053         _totalSupply -= amount;
1054 
1055         emit Transfer(account, address(0), amount);
1056 
1057         _afterTokenTransfer(account, address(0), amount);
1058     }
1059 
1060     /**
1061      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1062      *
1063      * This internal function is equivalent to `approve`, and can be used to
1064      * e.g. set automatic allowances for certain subsystems, etc.
1065      *
1066      * Emits an {Approval} event.
1067      *
1068      * Requirements:
1069      *
1070      * - `owner` cannot be the zero address.
1071      * - `spender` cannot be the zero address.
1072      */
1073     function _approve(
1074         address owner,
1075         address spender,
1076         uint256 amount
1077     ) internal virtual {
1078         require(owner != address(0), "ERC20: approve from the zero address");
1079         require(spender != address(0), "ERC20: approve to the zero address");
1080 
1081         _allowances[owner][spender] = amount;
1082         emit Approval(owner, spender, amount);
1083     }
1084 
1085     /**
1086      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1087      *
1088      * Does not update the allowance amount in case of infinite allowance.
1089      * Revert if not enough allowance is available.
1090      *
1091      * Might emit an {Approval} event.
1092      */
1093     function _spendAllowance(
1094         address owner,
1095         address spender,
1096         uint256 amount
1097     ) internal virtual {
1098         uint256 currentAllowance = allowance(owner, spender);
1099         if (currentAllowance != type(uint256).max) {
1100             require(
1101                 currentAllowance >= amount,
1102                 "ERC20: insufficient allowance"
1103             );
1104             unchecked {
1105                 _approve(owner, spender, currentAllowance - amount);
1106             }
1107         }
1108     }
1109 
1110     /**
1111      * @dev Hook that is called before any transfer of tokens. This includes
1112      * minting and burning.
1113      *
1114      * Calling conditions:
1115      *
1116      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1117      * will be transferred to `to`.
1118      * - when `from` is zero, `amount` tokens will be minted for `to`.
1119      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1120      * - `from` and `to` are never both zero.
1121      *
1122      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1123      */
1124     function _beforeTokenTransfer(
1125         address from,
1126         address to,
1127         uint256 amount
1128     ) internal virtual {}
1129 
1130     /**
1131      * @dev Hook that is called after any transfer of tokens. This includes
1132      * minting and burning.
1133      *
1134      * Calling conditions:
1135      *
1136      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1137      * has been transferred to `to`.
1138      * - when `from` is zero, `amount` tokens have been minted for `to`.
1139      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1140      * - `from` and `to` are never both zero.
1141      *
1142      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1143      */
1144     function _afterTokenTransfer(
1145         address from,
1146         address to,
1147         uint256 amount
1148     ) internal virtual {}
1149 }
1150 
1151 interface uniswapV2Pair {
1152     function getReserves()
1153         external
1154         view
1155         returns (
1156             uint112 reserve0,
1157             uint112 reserve1,
1158             uint32 blockTimestampLast
1159         );
1160 }
1161 
1162 contract MMAI is ERC20, Ownable {
1163     address payable public marketingFeeAddress;
1164     address payable public devFeeAddress;
1165     address payable public aiFeeAddress;
1166     uint16 constant maxFeeLimit = 300;
1167 
1168     bool public tradingActive;
1169 
1170     uint256 highTaxPeriod = 10;
1171     uint256 launchTime;
1172     mapping(address => bool) public isExcludedFromFee;
1173 
1174     mapping(address => uint256) lastSold;
1175 
1176     // these values are pretty much arbitrary since they get overwritten for every txn, but the placeholders make it easier to work with current contract.
1177     uint256 private _devFee;
1178     uint256 private _previousDevFee;
1179 
1180     uint256 private _liquidityFee;
1181     uint256 private _previousLiquidityFee;
1182 
1183     uint256 private _marketingFee;
1184     uint256 private _previousMarketingFee;
1185 
1186     uint256 private _aiFee;
1187     uint256 private _previousAIFee;
1188 
1189     uint16 public buyDevFee = 20;
1190     uint16 public buyLiquidityFee = 30;
1191     uint16 public buyMarketingFee = 10;
1192     uint16 public buyAIFee = 40;
1193 
1194     uint16 public sellDevFee = 20;
1195     uint16 public sellLiquidityFee = 30;
1196     uint16 public sellMarketingFee = 10;
1197     uint16 public sellAIFee = 40;
1198 
1199     uint16 public transferDevFee = 0;
1200     uint16 public transferLiquidityFee = 0;
1201     uint16 public transferMarketingFee = 0;
1202     uint16 public transferAIFee = 0;
1203 
1204     uint256 private _liquidityTokensToSwap;
1205     uint256 private _marketingFeeTokensToSwap;
1206     uint256 private _devFeeTokens;
1207     uint256 private _aiFeeTokens;
1208 
1209     uint256 public extraLPTax = 80;
1210 
1211     uint256 public diamondHandPeriod = 4 weeks;
1212 
1213     mapping(address => bool) public automatedMarketMakerPairs;
1214 
1215     uint256 public minimumFeeTokensToTake;
1216 
1217     IUniswapRouter02 public immutable uniswapRouter;
1218     address public immutable uniswapPair;
1219 
1220     bool inSwapAndLiquify;
1221 
1222     address public bridgeAddress;
1223 
1224     modifier lockTheSwap() {
1225         inSwapAndLiquify = true;
1226         _;
1227         inSwapAndLiquify = false;
1228     }
1229 
1230     function setHighTaxPeriod(uint256 n) external onlyOwner {
1231         highTaxPeriod = n;
1232     }
1233 
1234     constructor() ERC20("MetamonkeyAi", "MMAI") {
1235         _mint(msg.sender, 1e10 * 10**decimals());
1236 
1237         marketingFeeAddress = payable(
1238             0xeCCfBA746348Aa32AFE11A14E8bd36A1b06F1393
1239         );
1240         devFeeAddress = payable(0x1071A02AF39E0eF4D245b0b21550FCC28e8307eC);
1241         aiFeeAddress = payable(0xC1d2a0ab2b29757C9A86A1F0ECC722e356d69Bd5);
1242 
1243         minimumFeeTokensToTake = 1e7 * 10**decimals();
1244         address routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
1245         uniswapRouter = IUniswapRouter02(payable(routerAddress));
1246 
1247         uniswapPair = IFactory(uniswapRouter.factory()).createPair(
1248             address(this),
1249             uniswapRouter.WETH()
1250         );
1251 
1252         isExcludedFromFee[_msgSender()] = true;
1253         isExcludedFromFee[address(this)] = true;
1254         isExcludedFromFee[marketingFeeAddress] = true;
1255         isExcludedFromFee[devFeeAddress] = true;
1256         isExcludedFromFee[aiFeeAddress] = true;
1257 
1258         _limits[msg.sender].isExcluded = true;
1259         _limits[address(this)].isExcluded = true;
1260         _limits[routerAddress].isExcluded = true;
1261 
1262         globalLimit = 10 * 10**18; // 10 ** 18 = 1 ETH limit
1263         globalLimitPeriod = 24 hours;
1264 
1265         _approve(msg.sender, routerAddress, ~uint256(0));
1266         _setAutomatedMarketMakerPair(uniswapPair, true);
1267         bridgeAddress = 0x4c03Cf0301F2ef59CC2687b82f982A2A01C00Ee2;
1268     }
1269 
1270     function migrateBridge(address newAddress) external onlyOwner {
1271         require(newAddress != address(0), "cant be zero address");
1272         bridgeAddress = newAddress;
1273     }
1274 
1275     function decimals() public pure override returns (uint8) {
1276         return 7;
1277     }
1278 
1279     function enableTrading() external onlyOwner {
1280         require(!tradingActive, "already enabled");
1281         tradingActive = true;
1282         launchTime = block.timestamp;
1283     }
1284 
1285     function totalSupply() public view override returns (uint256) {
1286         return super.totalSupply() - bridgeBalance();
1287     }
1288 
1289     function balanceOf(address account) public view override returns (uint256) {
1290         if (account == bridgeAddress) return 0;
1291         return super.balanceOf(account);
1292     }
1293 
1294     function bridgeBalance() public view returns (uint256) {
1295         return super.balanceOf(bridgeAddress);
1296     }
1297 
1298     function setBridgeAddress(address a) external onlyOwner {
1299         require(a != address(0), "Can't set 0");
1300         bridgeAddress = a;
1301     }
1302 
1303     function updateMinimumTokensBeforeFeeTaken(uint256 _minimumFeeTokensToTake)
1304         external
1305         onlyOwner
1306     {
1307         minimumFeeTokensToTake = _minimumFeeTokensToTake * (10**decimals());
1308     }
1309 
1310     function setAutomatedMarketMakerPair(address pair, bool value)
1311         external
1312         onlyOwner
1313     {
1314         require(pair != uniswapPair, "The pair cannot be removed");
1315 
1316         _setAutomatedMarketMakerPair(pair, value);
1317     }
1318 
1319     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1320         automatedMarketMakerPairs[pair] = value;
1321     }
1322 
1323     function excludeFromFee(address account) external onlyOwner {
1324         isExcludedFromFee[account] = true;
1325     }
1326 
1327     function includeInFee(address account) external onlyOwner {
1328         isExcludedFromFee[account] = false;
1329     }
1330 
1331     function updateBuyFee(
1332         uint16 _buyDevFee,
1333         uint16 _buyLiquidityFee,
1334         uint16 _buyMarketingFee,
1335         uint16 _buyAIFee
1336     ) external onlyOwner {
1337         buyDevFee = _buyDevFee;
1338         buyLiquidityFee = _buyLiquidityFee;
1339         buyMarketingFee = _buyMarketingFee;
1340         buyAIFee = _buyAIFee;
1341         require(
1342             _buyDevFee + _buyLiquidityFee + _buyMarketingFee + _buyAIFee <=
1343                 maxFeeLimit,
1344             "Must keep fees below 30%"
1345         );
1346     }
1347 
1348     function updateSellFee(
1349         uint16 _sellDevFee,
1350         uint16 _sellLiquidityFee,
1351         uint16 _sellMarketingFee,
1352         uint16 _sellAIFee
1353     ) external onlyOwner {
1354         sellDevFee = _sellDevFee;
1355         sellLiquidityFee = _sellLiquidityFee;
1356         sellMarketingFee = _sellMarketingFee;
1357         sellAIFee = _sellAIFee;
1358         require(
1359             _sellDevFee + _sellLiquidityFee + _sellMarketingFee + _sellAIFee <=
1360                 maxFeeLimit,
1361             "Must keep fees <= 30%"
1362         );
1363     }
1364 
1365     function updateTransferFee(
1366         uint16 _transferDevFee,
1367         uint16 _transferLiquidityFee,
1368         uint16 _transferMarketingFee,
1369         uint16 _transferAIfee
1370     ) external onlyOwner {
1371         transferDevFee = _transferDevFee;
1372         transferLiquidityFee = _transferLiquidityFee;
1373         transferMarketingFee = _transferMarketingFee;
1374         transferAIFee = _transferAIfee;
1375         require(
1376             _transferDevFee +
1377                 _transferLiquidityFee +
1378                 _transferMarketingFee +
1379                 _transferAIfee <=
1380                 maxFeeLimit,
1381             "Must keep fees <= 30%"
1382         );
1383     }
1384 
1385     function updateMarketingFeeAddress(address a) external onlyOwner {
1386         require(a != address(0), "Can't set 0");
1387         marketingFeeAddress = payable(a);
1388     }
1389 
1390     function updateDevAddress(address a) external onlyOwner {
1391         require(a != address(0), "Can't set 0");
1392         devFeeAddress = payable(a);
1393     }
1394 
1395     function updateAIAddress(address a) external onlyOwner {
1396         require(a != address(0), "Can't set 0");
1397         aiFeeAddress = payable(a);
1398     }
1399 
1400     function setExtraLPTax(uint256 n) external onlyOwner {
1401         require(extraLPTax <= 100, "Too much");
1402         extraLPTax = n;
1403     }
1404 
1405     function _transfer(
1406         address from,
1407         address to,
1408         uint256 amount
1409     ) internal override {
1410         if (!tradingActive) {
1411             require(
1412                 isExcludedFromFee[from] || isExcludedFromFee[to],
1413                 "Trading is not active yet."
1414             );
1415         }
1416         if (lastSold[from] == 0) {
1417             lastSold[from] = block.timestamp;
1418         }
1419         checkLiquidity();
1420 
1421         uint256 contractTokenBalance = balanceOf(address(this));
1422         bool overMinimumTokenBalance = contractTokenBalance >=
1423             minimumFeeTokensToTake;
1424 
1425         // Take Fee
1426         if (
1427             !inSwapAndLiquify &&
1428             overMinimumTokenBalance &&
1429             automatedMarketMakerPairs[to]
1430         ) {
1431             takeFee();
1432         }
1433 
1434         removeAllFee();
1435 
1436         // If any account belongs to isExcludedFromFee account then remove the fee
1437         if (!isExcludedFromFee[from] && !isExcludedFromFee[to]) {
1438             // High tax period
1439             if (launchTime + highTaxPeriod >= block.timestamp) {
1440                 _devFee = (amount * 25) / 1000;
1441                 _liquidityFee = (amount * 24) / 1000;
1442                 _marketingFee = (amount * 25) / 1000;
1443                 _aiFee = (amount * 25) / 1000;
1444             } else {
1445                 // Buy
1446                 if (automatedMarketMakerPairs[from]) {
1447                     _devFee = (amount * buyDevFee) / 1000;
1448                     _liquidityFee = (amount * buyLiquidityFee) / 1000;
1449                     _marketingFee = (amount * buyMarketingFee) / 1000;
1450                     _aiFee = (amount * buyAIFee) / 1000;
1451                 }
1452                 // Sell
1453                 else if (automatedMarketMakerPairs[to]) {
1454                     uint256 plus;
1455                     // People who sell within diamondHandPeriod will have to pay extra taxes, which go to LP.
1456                     if (lastSold[from] + diamondHandPeriod >= block.timestamp) {
1457                         plus += extraLPTax;
1458                     }
1459                     _devFee = (amount * sellDevFee) / 1000;
1460                     _liquidityFee = (amount * (sellLiquidityFee + plus)) / 1000;
1461                     _marketingFee = (amount * sellMarketingFee) / 1000;
1462                     _aiFee = (amount * sellAIFee) / 1000;
1463                     lastSold[from] = block.timestamp; // for the holder extra tax
1464                 } else {
1465                     _devFee = (amount * transferDevFee) / 1000;
1466                     _liquidityFee = (amount * transferLiquidityFee) / 1000;
1467                     _marketingFee = (amount * transferMarketingFee) / 1000;
1468                     _aiFee = (amount * transferAIFee) / 1000;
1469                 }
1470             }
1471 
1472             if (
1473                 hasLiquidity &&
1474                 !inSwapAndLiquify &&
1475                 !automatedMarketMakerPairs[from] &&
1476                 !_limits[to].isExcluded
1477             ) {
1478                 _handleLimited(
1479                     from,
1480                     amount - _devFee - _liquidityFee - _marketingFee - _aiFee
1481                 );
1482             }
1483         }
1484 
1485         uint256 _transferAmount = amount -
1486             _devFee -
1487             _liquidityFee -
1488             _marketingFee -
1489             _aiFee;
1490         super._transfer(from, to, _transferAmount);
1491         uint256 _feeTotal = _devFee + _liquidityFee + _marketingFee + _aiFee;
1492         if (_feeTotal > 0) {
1493             super._transfer(from, address(this), _feeTotal);
1494             _liquidityTokensToSwap += _liquidityFee;
1495             _marketingFeeTokensToSwap += _marketingFee;
1496             _devFeeTokens += _devFee;
1497             _aiFeeTokens += _aiFee;
1498         }
1499         restoreAllFee();
1500     }
1501 
1502     function removeAllFee() private {
1503         if (
1504             _devFee == 0 &&
1505             _liquidityFee == 0 &&
1506             _marketingFee == 0 &&
1507             _aiFee == 0
1508         ) return;
1509 
1510         _previousDevFee = _devFee;
1511         _previousLiquidityFee = _liquidityFee;
1512         _previousMarketingFee = _marketingFee;
1513         _previousAIFee = _aiFee;
1514 
1515         _devFee = 0;
1516         _liquidityFee = 0;
1517         _marketingFee = 0;
1518         _aiFee = 0;
1519     }
1520 
1521     function restoreAllFee() private {
1522         _devFee = _previousDevFee;
1523         _liquidityFee = _previousLiquidityFee;
1524         _marketingFee = _previousMarketingFee;
1525         _aiFee = _previousAIFee;
1526     }
1527 
1528     function setDiamondHandPeriod(uint256 n) external onlyOwner {
1529         diamondHandPeriod = n;
1530     }
1531 
1532     function takeFee() private lockTheSwap {
1533         uint256 contractBalance = balanceOf(address(this));
1534         uint256 totalTokensTaken = _liquidityTokensToSwap +
1535             _marketingFeeTokensToSwap +
1536             _devFeeTokens +
1537             _aiFeeTokens;
1538         if (totalTokensTaken == 0 || contractBalance < totalTokensTaken) {
1539             return;
1540         }
1541 
1542         uint256 tokensForLiquidity = _liquidityTokensToSwap / 2;
1543         uint256 initialETHBalance = address(this).balance;
1544         uint256 toSwap = tokensForLiquidity +
1545             _marketingFeeTokensToSwap +
1546             _devFeeTokens +
1547             _aiFeeTokens;
1548         swapTokensForETH(toSwap);
1549         uint256 ethBalance = address(this).balance - initialETHBalance;
1550 
1551         uint256 ethForMarketing = (ethBalance * _marketingFeeTokensToSwap) /
1552             toSwap;
1553         uint256 ethForLiquidity = (ethBalance * tokensForLiquidity) / toSwap;
1554         uint256 ethForDev = (ethBalance * _devFeeTokens) / toSwap;
1555         uint256 ethForAI = (ethBalance * _aiFeeTokens) / toSwap;
1556 
1557         if (tokensForLiquidity > 0 && ethForLiquidity > 0) {
1558             addLiquidity(tokensForLiquidity, ethForLiquidity);
1559         }
1560         bool success;
1561 
1562         (success, ) = address(marketingFeeAddress).call{
1563             value: ethForMarketing,
1564             gas:50000
1565         }("");
1566         (success, ) = address(devFeeAddress).call{
1567             value: ethForDev,
1568             gas:50000
1569         }("");
1570         (success, ) = address(aiFeeAddress).call{
1571             value: ethForAI,
1572             gas:50000
1573         }("");
1574 
1575         _liquidityTokensToSwap = 0;
1576         _marketingFeeTokensToSwap = 0;
1577         _devFeeTokens = 0;
1578         _aiFeeTokens = 0;
1579     }
1580 
1581     function swapTokensForETH(uint256 tokenAmount) private {
1582         address[] memory path = new address[](2);
1583         path[0] = address(this);
1584         path[1] = uniswapRouter.WETH();
1585         _approve(address(this), address(uniswapRouter), tokenAmount);
1586         uniswapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
1587             tokenAmount,
1588             0,
1589             path,
1590             address(this),
1591             block.timestamp
1592         );
1593     }
1594 
1595     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1596         _approve(address(this), address(uniswapRouter), tokenAmount);
1597         uniswapRouter.addLiquidityETH{value: ethAmount}(
1598             address(this),
1599             tokenAmount,
1600             0, // slippage is unavoidable
1601             0, // slippage is unavoidable
1602             owner(),
1603             block.timestamp
1604         );
1605     }
1606 
1607     receive() external payable {}
1608 
1609     // Limits
1610     mapping(address => LimitedWallet) private _limits;
1611 
1612     uint256 public globalLimit; // limit over timeframe for all
1613     uint256 public globalLimitPeriod; // timeframe for all
1614 
1615     bool public globalLimitsActive;
1616 
1617     bool private hasLiquidity;
1618 
1619     struct LimitedWallet {
1620         uint256[] sellAmounts;
1621         uint256[] sellTimestamps;
1622         uint256 limitPeriod; // ability to set custom values for individual wallets
1623         uint256 limitETH; // ability to set custom values for individual wallets
1624         bool isExcluded;
1625     }
1626 
1627     function setGlobalLimit(uint256 newLimit) external onlyOwner {
1628         require(newLimit >= 1 ether, "Too low");
1629         globalLimit = newLimit;
1630     }
1631 
1632     function setGlobalLimitPeriod(uint256 newPeriod) external onlyOwner {
1633         require(newPeriod <= 1 weeks, "Too long");
1634         globalLimitPeriod = newPeriod;
1635     }
1636 
1637     function setGlobalLimitsActiveStatus(bool status) external onlyOwner {
1638         globalLimitsActive = status;
1639     }
1640 
1641     function getLimits(address _address)
1642         external
1643         view
1644         returns (LimitedWallet memory)
1645     {
1646         return _limits[_address];
1647     }
1648 
1649     function removeLimits(address[] calldata addresses) external onlyOwner {
1650         for (uint256 i; i < addresses.length; i++) {
1651             address account = addresses[i];
1652             _limits[account].limitPeriod = 0;
1653             _limits[account].limitETH = 0;
1654         }
1655     }
1656 
1657     // Set custom limits for an address. Defaults to 0, thus will use the "globalLimitPeriod" and "globalLimitETH" if we don't set them
1658     function setLimits(
1659         address[] calldata addresses,
1660         uint256[] calldata limitPeriods,
1661         uint256[] calldata limitsETH
1662     ) external onlyOwner {
1663         require(
1664             addresses.length == limitPeriods.length &&
1665                 limitPeriods.length == limitsETH.length,
1666             "Array lengths don't match"
1667         );
1668 
1669         for (uint256 i = 0; i < addresses.length; i++) {
1670             if (limitPeriods[i] == 0 && limitsETH[i] == 0) continue;
1671             _limits[addresses[i]].limitPeriod = limitPeriods[i];
1672             _limits[addresses[i]].limitETH = limitsETH[i];
1673         }
1674     }
1675 
1676     function addExcludedFromLimits(address[] calldata addresses)
1677         external
1678         onlyOwner
1679     {
1680         for (uint256 i = 0; i < addresses.length; i++) {
1681             _limits[addresses[i]].isExcluded = true;
1682         }
1683     }
1684 
1685     function removeExcludedFromLimits(address[] calldata addresses)
1686         external
1687         onlyOwner
1688     {
1689         require(addresses.length <= 1000, "Array too long");
1690         for (uint256 i = 0; i < addresses.length; i++) {
1691             _limits[addresses[i]].isExcluded = false;
1692         }
1693     }
1694 
1695     // Can be used to check how much a wallet sold in their timeframe
1696     function getSoldLastPeriod(address _address)
1697         public
1698         view
1699         returns (uint256 sellAmount)
1700     {
1701         uint256 numberOfSells = _limits[_address].sellAmounts.length;
1702 
1703         if (numberOfSells == 0) {
1704             return sellAmount;
1705         }
1706 
1707         uint256 limitPeriod = _limits[_address].limitPeriod == 0
1708             ? globalLimitPeriod
1709             : _limits[_address].limitPeriod;
1710         while (true) {
1711             if (numberOfSells == 0) {
1712                 break;
1713             }
1714             numberOfSells--;
1715             uint256 sellTimestamp = _limits[_address].sellTimestamps[
1716                 numberOfSells
1717             ];
1718             if (block.timestamp - limitPeriod <= sellTimestamp) {
1719                 sellAmount += _limits[_address].sellAmounts[numberOfSells];
1720             } else {
1721                 break;
1722             }
1723         }
1724     }
1725 
1726     function checkLiquidity() internal {
1727         (uint256 r1, uint256 r2, ) = uniswapV2Pair(uniswapPair).getReserves();
1728         hasLiquidity = r1 > 0 && r2 > 0 ? true : false;
1729     }
1730 
1731     function getETHValue(uint256 tokenAmount)
1732         public
1733         view
1734         returns (uint256 ethValue)
1735     {
1736         address[] memory path = new address[](2);
1737         path[0] = address(this);
1738         path[1] = uniswapRouter.WETH();
1739         ethValue = uniswapRouter.getAmountsOut(tokenAmount, path)[1];
1740     }
1741 
1742     // Handle private sale wallets
1743     function _handleLimited(address from, uint256 taxedAmount) private {
1744         if (_limits[from].isExcluded || !globalLimitsActive) {
1745             return;
1746         }
1747         uint256 ethValue = getETHValue(taxedAmount);
1748         _limits[from].sellTimestamps.push(block.timestamp);
1749         _limits[from].sellAmounts.push(ethValue);
1750         uint256 soldAmountLastPeriod = getSoldLastPeriod(from);
1751 
1752         uint256 limit = _limits[from].limitETH == 0
1753             ? globalLimit
1754             : _limits[from].limitETH;
1755         require(
1756             soldAmountLastPeriod <= limit,
1757             "Amount over the limit for time period"
1758         );
1759     }
1760 
1761     function withdrawETH() external onlyOwner {
1762         payable(owner()).transfer(address(this).balance);
1763     }
1764 
1765     function withdrawTokens(IERC20 tokenAddress, address walletAddress)
1766         external
1767         onlyOwner
1768     {
1769         require(
1770             walletAddress != address(0),
1771             "walletAddress can't be 0 address"
1772         );
1773         SafeERC20.safeTransfer(
1774             tokenAddress,
1775             walletAddress,
1776             tokenAddress.balanceOf(address(this))
1777         );
1778     }
1779 }