1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.19;
3 
4 interface IUniswapV2Router01 {
5     function factory() external pure returns (address);
6 
7     function WETH() external pure returns (address);
8 
9     function addLiquidity(
10         address tokenA,
11         address tokenB,
12         uint amountADesired,
13         uint amountBDesired,
14         uint amountAMin,
15         uint amountBMin,
16         address to,
17         uint deadline
18     ) external returns (uint amountA, uint amountB, uint liquidity);
19 
20     function addLiquidityETH(
21         address token,
22         uint amountTokenDesired,
23         uint amountTokenMin,
24         uint amountETHMin,
25         address to,
26         uint deadline
27     )
28         external
29         payable
30         returns (uint amountToken, uint amountETH, uint liquidity);
31 
32     function removeLiquidity(
33         address tokenA,
34         address tokenB,
35         uint liquidity,
36         uint amountAMin,
37         uint amountBMin,
38         address to,
39         uint deadline
40     ) external returns (uint amountA, uint amountB);
41 
42     function removeLiquidityETH(
43         address token,
44         uint liquidity,
45         uint amountTokenMin,
46         uint amountETHMin,
47         address to,
48         uint deadline
49     ) external returns (uint amountToken, uint amountETH);
50 
51     function removeLiquidityWithPermit(
52         address tokenA,
53         address tokenB,
54         uint liquidity,
55         uint amountAMin,
56         uint amountBMin,
57         address to,
58         uint deadline,
59         bool approveMax,
60         uint8 v,
61         bytes32 r,
62         bytes32 s
63     ) external returns (uint amountA, uint amountB);
64 
65     function removeLiquidityETHWithPermit(
66         address token,
67         uint liquidity,
68         uint amountTokenMin,
69         uint amountETHMin,
70         address to,
71         uint deadline,
72         bool approveMax,
73         uint8 v,
74         bytes32 r,
75         bytes32 s
76     ) external returns (uint amountToken, uint amountETH);
77 
78     function swapExactTokensForTokens(
79         uint amountIn,
80         uint amountOutMin,
81         address[] calldata path,
82         address to,
83         uint deadline
84     ) external returns (uint[] memory amounts);
85 
86     function swapTokensForExactTokens(
87         uint amountOut,
88         uint amountInMax,
89         address[] calldata path,
90         address to,
91         uint deadline
92     ) external returns (uint[] memory amounts);
93 
94     function swapExactETHForTokens(
95         uint amountOutMin,
96         address[] calldata path,
97         address to,
98         uint deadline
99     ) external payable returns (uint[] memory amounts);
100 
101     function swapTokensForExactETH(
102         uint amountOut,
103         uint amountInMax,
104         address[] calldata path,
105         address to,
106         uint deadline
107     ) external returns (uint[] memory amounts);
108 
109     function swapExactTokensForETH(
110         uint amountIn,
111         uint amountOutMin,
112         address[] calldata path,
113         address to,
114         uint deadline
115     ) external returns (uint[] memory amounts);
116 
117     function swapETHForExactTokens(
118         uint amountOut,
119         address[] calldata path,
120         address to,
121         uint deadline
122     ) external payable returns (uint[] memory amounts);
123 
124     function quote(
125         uint amountA,
126         uint reserveA,
127         uint reserveB
128     ) external pure returns (uint amountB);
129 
130     function getAmountOut(
131         uint amountIn,
132         uint reserveIn,
133         uint reserveOut
134     ) external pure returns (uint amountOut);
135 
136     function getAmountIn(
137         uint amountOut,
138         uint reserveIn,
139         uint reserveOut
140     ) external pure returns (uint amountIn);
141 
142     function getAmountsOut(
143         uint amountIn,
144         address[] calldata path
145     ) external view returns (uint[] memory amounts);
146 
147     function getAmountsIn(
148         uint amountOut,
149         address[] calldata path
150     ) external view returns (uint[] memory amounts);
151 }
152 
153 interface IUniswapV2Router02 is IUniswapV2Router01 {
154     function removeLiquidityETHSupportingFeeOnTransferTokens(
155         address token,
156         uint liquidity,
157         uint amountTokenMin,
158         uint amountETHMin,
159         address to,
160         uint deadline
161     ) external returns (uint amountETH);
162 
163     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
164         address token,
165         uint liquidity,
166         uint amountTokenMin,
167         uint amountETHMin,
168         address to,
169         uint deadline,
170         bool approveMax,
171         uint8 v,
172         bytes32 r,
173         bytes32 s
174     ) external returns (uint amountETH);
175 
176     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
177         uint amountIn,
178         uint amountOutMin,
179         address[] calldata path,
180         address to,
181         uint deadline
182     ) external;
183 
184     function swapExactETHForTokensSupportingFeeOnTransferTokens(
185         uint amountOutMin,
186         address[] calldata path,
187         address to,
188         uint deadline
189     ) external payable;
190 
191     function swapExactTokensForETHSupportingFeeOnTransferTokens(
192         uint amountIn,
193         uint amountOutMin,
194         address[] calldata path,
195         address to,
196         uint deadline
197     ) external;
198 }
199 
200 interface IUniswapV2Factory {
201     event PairCreated(
202         address indexed token0,
203         address indexed token1,
204         address pair,
205         uint
206     );
207 
208     function feeTo() external view returns (address);
209 
210     function feeToSetter() external view returns (address);
211 
212     function getPair(
213         address tokenA,
214         address tokenB
215     ) external view returns (address pair);
216 
217     function allPairs(uint) external view returns (address pair);
218 
219     function allPairsLength() external view returns (uint);
220 
221     function createPair(
222         address tokenA,
223         address tokenB
224     ) external returns (address pair);
225 
226     function setFeeTo(address) external;
227 
228     function setFeeToSetter(address) external;
229 }
230 
231 library Address {
232     /**
233      * @dev Returns true if `account` is a contract.
234      *
235      * [IMPORTANT]
236      * ====
237      * It is unsafe to assume that an address for which this function returns
238      * false is an externally-owned account (EOA) and not a contract.
239      *
240      * Among others, `isContract` will return false for the following
241      * types of addresses:
242      *
243      *  - an externally-owned account
244      *  - a contract in construction
245      *  - an address where a contract will be created
246      *  - an address where a contract lived, but was destroyed
247      * ====
248      *
249      * [IMPORTANT]
250      * ====
251      * You shouldn't rely on `isContract` to protect against flash loan attacks!
252      *
253      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
254      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
255      * constructor.
256      * ====
257      */
258     function isContract(address account) internal view returns (bool) {
259         // This method relies on extcodesize/address.code.length, which returns 0
260         // for contracts in construction, since the code is only stored at the end
261         // of the constructor execution.
262 
263         return account.code.length > 0;
264     }
265 
266     /**
267      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
268      * `recipient`, forwarding all available gas and reverting on errors.
269      *
270      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
271      * of certain opcodes, possibly making contracts go over the 2300 gas limit
272      * imposed by `transfer`, making them unable to receive funds via
273      * `transfer`. {sendValue} removes this limitation.
274      *
275      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
276      *
277      * IMPORTANT: because control is transferred to `recipient`, care must be
278      * taken to not create reentrancy vulnerabilities. Consider using
279      * {ReentrancyGuard} or the
280      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
281      */
282     function sendValue(address payable recipient, uint256 amount) internal {
283         require(
284             address(this).balance >= amount,
285             "Address: insufficient balance"
286         );
287 
288         (bool success, ) = recipient.call{value: amount}("");
289         require(
290             success,
291             "Address: unable to send value, recipient may have reverted"
292         );
293     }
294 
295     /**
296      * @dev Performs a Solidity function call using a low level `call`. A
297      * plain `call` is an unsafe replacement for a function call: use this
298      * function instead.
299      *
300      * If `target` reverts with a revert reason, it is bubbled up by this
301      * function (like regular Solidity function calls).
302      *
303      * Returns the raw returned data. To convert to the expected return value,
304      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
305      *
306      * Requirements:
307      *
308      * - `target` must be a contract.
309      * - calling `target` with `data` must not revert.
310      *
311      * _Available since v3.1._
312      */
313     function functionCall(
314         address target,
315         bytes memory data
316     ) internal returns (bytes memory) {
317         return
318             functionCallWithValue(
319                 target,
320                 data,
321                 0,
322                 "Address: low-level call failed"
323             );
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
328      * `errorMessage` as a fallback revert reason when `target` reverts.
329      *
330      * _Available since v3.1._
331      */
332     function functionCall(
333         address target,
334         bytes memory data,
335         string memory errorMessage
336     ) internal returns (bytes memory) {
337         return functionCallWithValue(target, data, 0, errorMessage);
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
342      * but also transferring `value` wei to `target`.
343      *
344      * Requirements:
345      *
346      * - the calling contract must have an ETH balance of at least `value`.
347      * - the called Solidity function must be `payable`.
348      *
349      * _Available since v3.1._
350      */
351     function functionCallWithValue(
352         address target,
353         bytes memory data,
354         uint256 value
355     ) internal returns (bytes memory) {
356         return
357             functionCallWithValue(
358                 target,
359                 data,
360                 value,
361                 "Address: low-level call with value failed"
362             );
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
367      * with `errorMessage` as a fallback revert reason when `target` reverts.
368      *
369      * _Available since v3.1._
370      */
371     function functionCallWithValue(
372         address target,
373         bytes memory data,
374         uint256 value,
375         string memory errorMessage
376     ) internal returns (bytes memory) {
377         require(
378             address(this).balance >= value,
379             "Address: insufficient balance for call"
380         );
381         (bool success, bytes memory returndata) = target.call{value: value}(
382             data
383         );
384         return
385             verifyCallResultFromTarget(
386                 target,
387                 success,
388                 returndata,
389                 errorMessage
390             );
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
395      * but performing a static call.
396      *
397      * _Available since v3.3._
398      */
399     function functionStaticCall(
400         address target,
401         bytes memory data
402     ) internal view returns (bytes memory) {
403         return
404             functionStaticCall(
405                 target,
406                 data,
407                 "Address: low-level static call failed"
408             );
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
413      * but performing a static call.
414      *
415      * _Available since v3.3._
416      */
417     function functionStaticCall(
418         address target,
419         bytes memory data,
420         string memory errorMessage
421     ) internal view returns (bytes memory) {
422         (bool success, bytes memory returndata) = target.staticcall(data);
423         return
424             verifyCallResultFromTarget(
425                 target,
426                 success,
427                 returndata,
428                 errorMessage
429             );
430     }
431 
432     /**
433      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
434      * but performing a delegate call.
435      *
436      * _Available since v3.4._
437      */
438     function functionDelegateCall(
439         address target,
440         bytes memory data
441     ) internal returns (bytes memory) {
442         return
443             functionDelegateCall(
444                 target,
445                 data,
446                 "Address: low-level delegate call failed"
447             );
448     }
449 
450     /**
451      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
452      * but performing a delegate call.
453      *
454      * _Available since v3.4._
455      */
456     function functionDelegateCall(
457         address target,
458         bytes memory data,
459         string memory errorMessage
460     ) internal returns (bytes memory) {
461         (bool success, bytes memory returndata) = target.delegatecall(data);
462         return
463             verifyCallResultFromTarget(
464                 target,
465                 success,
466                 returndata,
467                 errorMessage
468             );
469     }
470 
471     /**
472      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
473      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
474      *
475      * _Available since v4.8._
476      */
477     function verifyCallResultFromTarget(
478         address target,
479         bool success,
480         bytes memory returndata,
481         string memory errorMessage
482     ) internal view returns (bytes memory) {
483         if (success) {
484             if (returndata.length == 0) {
485                 // only check isContract if the call was successful and the return data is empty
486                 // otherwise we already know that it was a contract
487                 require(isContract(target), "Address: call to non-contract");
488             }
489             return returndata;
490         } else {
491             _revert(returndata, errorMessage);
492         }
493     }
494 
495     /**
496      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
497      * revert reason or using the provided one.
498      *
499      * _Available since v4.3._
500      */
501     function verifyCallResult(
502         bool success,
503         bytes memory returndata,
504         string memory errorMessage
505     ) internal pure returns (bytes memory) {
506         if (success) {
507             return returndata;
508         } else {
509             _revert(returndata, errorMessage);
510         }
511     }
512 
513     function _revert(
514         bytes memory returndata,
515         string memory errorMessage
516     ) private pure {
517         // Look for revert reason and bubble it up if present
518         if (returndata.length > 0) {
519             // The easiest way to bubble the revert reason is using memory via assembly
520             /// @solidity memory-safe-assembly
521             assembly {
522                 let returndata_size := mload(returndata)
523                 revert(add(32, returndata), returndata_size)
524             }
525         } else {
526             revert(errorMessage);
527         }
528     }
529 }
530 
531 interface IERC20Permit {
532     /**
533      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
534      * given ``owner``'s signed approval.
535      *
536      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
537      * ordering also apply here.
538      *
539      * Emits an {Approval} event.
540      *
541      * Requirements:
542      *
543      * - `spender` cannot be the zero address.
544      * - `deadline` must be a timestamp in the future.
545      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
546      * over the EIP712-formatted function arguments.
547      * - the signature must use ``owner``'s current nonce (see {nonces}).
548      *
549      * For more information on the signature format, see the
550      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
551      * section].
552      */
553     function permit(
554         address owner,
555         address spender,
556         uint256 value,
557         uint256 deadline,
558         uint8 v,
559         bytes32 r,
560         bytes32 s
561     ) external;
562 
563     /**
564      * @dev Returns the current nonce for `owner`. This value must be
565      * included whenever a signature is generated for {permit}.
566      *
567      * Every successful call to {permit} increases ``owner``'s nonce by one. This
568      * prevents a signature from being used multiple times.
569      */
570     function nonces(address owner) external view returns (uint256);
571 
572     /**
573      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
574      */
575     // solhint-disable-next-line func-name-mixedcase
576     function DOMAIN_SEPARATOR() external view returns (bytes32);
577 }
578 
579 abstract contract ReentrancyGuard {
580     // Booleans are more expensive than uint256 or any type that takes up a full
581     // word because each write operation emits an extra SLOAD to first read the
582     // slot's contents, replace the bits taken up by the boolean, and then write
583     // back. This is the compiler's defense against contract upgrades and
584     // pointer aliasing, and it cannot be disabled.
585 
586     // The values being non-zero value makes deployment a bit more expensive,
587     // but in exchange the refund on every call to nonReentrant will be lower in
588     // amount. Since refunds are capped to a percentage of the total
589     // transaction's gas, it is best to keep them low in cases like this one, to
590     // increase the likelihood of the full refund coming into effect.
591     uint256 private constant _NOT_ENTERED = 1;
592     uint256 private constant _ENTERED = 2;
593 
594     uint256 private _status;
595 
596     constructor() {
597         _status = _NOT_ENTERED;
598     }
599 
600     /**
601      * @dev Prevents a contract from calling itself, directly or indirectly.
602      * Calling a `nonReentrant` function from another `nonReentrant`
603      * function is not supported. It is possible to prevent this from happening
604      * by making the `nonReentrant` function external, and making it call a
605      * `private` function that does the actual work.
606      */
607     modifier nonReentrant() {
608         _nonReentrantBefore();
609         _;
610         _nonReentrantAfter();
611     }
612 
613     function _nonReentrantBefore() private {
614         // On the first call to nonReentrant, _status will be _NOT_ENTERED
615         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
616 
617         // Any calls to nonReentrant after this point will fail
618         _status = _ENTERED;
619     }
620 
621     function _nonReentrantAfter() private {
622         // By storing the original value once again, a refund is triggered (see
623         // https://eips.ethereum.org/EIPS/eip-2200)
624         _status = _NOT_ENTERED;
625     }
626 }
627 
628 abstract contract Context {
629     function _msgSender() internal view virtual returns (address) {
630         return msg.sender;
631     }
632 
633     function _msgData() internal view virtual returns (bytes calldata) {
634         return msg.data;
635     }
636 }
637 
638 abstract contract Ownable is Context {
639     address private _owner;
640 
641     event OwnershipTransferred(
642         address indexed previousOwner,
643         address indexed newOwner
644     );
645 
646     /**
647      * @dev Initializes the contract setting the deployer as the initial owner.
648      */
649     constructor() {
650         _transferOwnership(_msgSender());
651     }
652 
653     /**
654      * @dev Throws if called by any account other than the owner.
655      */
656     modifier onlyOwner() {
657         _checkOwner();
658         _;
659     }
660 
661     /**
662      * @dev Returns the address of the current owner.
663      */
664     function owner() public view virtual returns (address) {
665         return _owner;
666     }
667 
668     /**
669      * @dev Throws if the sender is not the owner.
670      */
671     function _checkOwner() internal view virtual {
672         require(owner() == _msgSender(), "Ownable: caller is not the owner");
673     }
674 
675     /**
676      * @dev Leaves the contract without owner. It will not be possible to call
677      * `onlyOwner` functions anymore. Can only be called by the current owner.
678      *
679      * NOTE: Renouncing ownership will leave the contract without an owner,
680      * thereby removing any functionality that is only available to the owner.
681      */
682     function renounceOwnership() public virtual onlyOwner {
683         _transferOwnership(address(0));
684     }
685 
686     /**
687      * @dev Transfers ownership of the contract to a new account (`newOwner`).
688      * Can only be called by the current owner.
689      */
690     function transferOwnership(address newOwner) public virtual onlyOwner {
691         require(
692             newOwner != address(0),
693             "Ownable: new owner is the zero address"
694         );
695         _transferOwnership(newOwner);
696     }
697 
698     /**
699      * @dev Transfers ownership of the contract to a new account (`newOwner`).
700      * Internal function without access restriction.
701      */
702     function _transferOwnership(address newOwner) internal virtual {
703         address oldOwner = _owner;
704         _owner = newOwner;
705         emit OwnershipTransferred(oldOwner, newOwner);
706     }
707 }
708 
709 interface IERC20 {
710     /**
711      * @dev Emitted when `value` tokens are moved from one account (`from`) to
712      * another (`to`).
713      *
714      * Note that `value` may be zero.
715      */
716     event Transfer(address indexed from, address indexed to, uint256 value);
717 
718     /**
719      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
720      * a call to {approve}. `value` is the new allowance.
721      */
722     event Approval(
723         address indexed owner,
724         address indexed spender,
725         uint256 value
726     );
727 
728     /**
729      * @dev Returns the amount of tokens in existence.
730      */
731     function totalSupply() external view returns (uint256);
732 
733     /**
734      * @dev Returns the amount of tokens owned by `account`.
735      */
736     function balanceOf(address account) external view returns (uint256);
737 
738     /**
739      * @dev Moves `amount` tokens from the caller's account to `to`.
740      *
741      * Returns a boolean value indicating whether the operation succeeded.
742      *
743      * Emits a {Transfer} event.
744      */
745     function transfer(address to, uint256 amount) external returns (bool);
746 
747     /**
748      * @dev Returns the remaining number of tokens that `spender` will be
749      * allowed to spend on behalf of `owner` through {transferFrom}. This is
750      * zero by default.
751      *
752      * This value changes when {approve} or {transferFrom} are called.
753      */
754     function allowance(
755         address owner,
756         address spender
757     ) external view returns (uint256);
758 
759     /**
760      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
761      *
762      * Returns a boolean value indicating whether the operation succeeded.
763      *
764      * IMPORTANT: Beware that changing an allowance with this method brings the risk
765      * that someone may use both the old and the new allowance by unfortunate
766      * transaction ordering. One possible solution to mitigate this race
767      * condition is to first reduce the spender's allowance to 0 and set the
768      * desired value afterwards:
769      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
770      *
771      * Emits an {Approval} event.
772      */
773     function approve(address spender, uint256 amount) external returns (bool);
774 
775     /**
776      * @dev Moves `amount` tokens from `from` to `to` using the
777      * allowance mechanism. `amount` is then deducted from the caller's
778      * allowance.
779      *
780      * Returns a boolean value indicating whether the operation succeeded.
781      *
782      * Emits a {Transfer} event.
783      */
784     function transferFrom(
785         address from,
786         address to,
787         uint256 amount
788     ) external returns (bool);
789 }
790 
791 library SafeERC20 {
792     using Address for address;
793 
794     function safeTransfer(IERC20 token, address to, uint256 value) internal {
795         _callOptionalReturn(
796             token,
797             abi.encodeWithSelector(token.transfer.selector, to, value)
798         );
799     }
800 
801     function safeTransferFrom(
802         IERC20 token,
803         address from,
804         address to,
805         uint256 value
806     ) internal {
807         _callOptionalReturn(
808             token,
809             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
810         );
811     }
812 
813     /**
814      * @dev Deprecated. This function has issues similar to the ones found in
815      * {IERC20-approve}, and its usage is discouraged.
816      *
817      * Whenever possible, use {safeIncreaseAllowance} and
818      * {safeDecreaseAllowance} instead.
819      */
820     function safeApprove(
821         IERC20 token,
822         address spender,
823         uint256 value
824     ) internal {
825         // safeApprove should only be called when setting an initial allowance,
826         // or when resetting it to zero. To increase and decrease it, use
827         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
828         require(
829             (value == 0) || (token.allowance(address(this), spender) == 0),
830             "SafeERC20: approve from non-zero to non-zero allowance"
831         );
832         _callOptionalReturn(
833             token,
834             abi.encodeWithSelector(token.approve.selector, spender, value)
835         );
836     }
837 
838     function safeIncreaseAllowance(
839         IERC20 token,
840         address spender,
841         uint256 value
842     ) internal {
843         uint256 newAllowance = token.allowance(address(this), spender) + value;
844         _callOptionalReturn(
845             token,
846             abi.encodeWithSelector(
847                 token.approve.selector,
848                 spender,
849                 newAllowance
850             )
851         );
852     }
853 
854     function safeDecreaseAllowance(
855         IERC20 token,
856         address spender,
857         uint256 value
858     ) internal {
859         unchecked {
860             uint256 oldAllowance = token.allowance(address(this), spender);
861             require(
862                 oldAllowance >= value,
863                 "SafeERC20: decreased allowance below zero"
864             );
865             uint256 newAllowance = oldAllowance - value;
866             _callOptionalReturn(
867                 token,
868                 abi.encodeWithSelector(
869                     token.approve.selector,
870                     spender,
871                     newAllowance
872                 )
873             );
874         }
875     }
876 
877     function safePermit(
878         IERC20Permit token,
879         address owner,
880         address spender,
881         uint256 value,
882         uint256 deadline,
883         uint8 v,
884         bytes32 r,
885         bytes32 s
886     ) internal {
887         uint256 nonceBefore = token.nonces(owner);
888         token.permit(owner, spender, value, deadline, v, r, s);
889         uint256 nonceAfter = token.nonces(owner);
890         require(
891             nonceAfter == nonceBefore + 1,
892             "SafeERC20: permit did not succeed"
893         );
894     }
895 
896     /**
897      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
898      * on the return value: the return value is optional (but if data is returned, it must not be false).
899      * @param token The token targeted by the call.
900      * @param data The call data (encoded using abi.encode or one of its variants).
901      */
902     function _callOptionalReturn(IERC20 token, bytes memory data) private {
903         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
904         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
905         // the target address contains contract code and also asserts for success in the low-level call.
906 
907         bytes memory returndata = address(token).functionCall(
908             data,
909             "SafeERC20: low-level call failed"
910         );
911         if (returndata.length > 0) {
912             // Return data is optional
913             require(
914                 abi.decode(returndata, (bool)),
915                 "SafeERC20: ERC20 operation did not succeed"
916             );
917         }
918     }
919 }
920 
921 interface IERC20Metadata is IERC20 {
922     /**
923      * @dev Returns the name of the token.
924      */
925     function name() external view returns (string memory);
926 
927     /**
928      * @dev Returns the symbol of the token.
929      */
930     function symbol() external view returns (string memory);
931 
932     /**
933      * @dev Returns the decimals places of the token.
934      */
935     function decimals() external view returns (uint8);
936 }
937 
938 contract ERC20 is Context, IERC20, IERC20Metadata {
939     mapping(address => uint256) private _balances;
940 
941     mapping(address => mapping(address => uint256)) private _allowances;
942 
943     uint256 private _totalSupply;
944 
945     string private _name;
946     string private _symbol;
947 
948     /**
949      * @dev Sets the values for {name} and {symbol}.
950      *
951      * The default value of {decimals} is 18. To select a different value for
952      * {decimals} you should overload it.
953      *
954      * All two of these values are immutable: they can only be set once during
955      * construction.
956      */
957     constructor(string memory name_, string memory symbol_) {
958         _name = name_;
959         _symbol = symbol_;
960     }
961 
962     /**
963      * @dev Returns the name of the token.
964      */
965     function name() public view virtual override returns (string memory) {
966         return _name;
967     }
968 
969     /**
970      * @dev Returns the symbol of the token, usually a shorter version of the
971      * name.
972      */
973     function symbol() public view virtual override returns (string memory) {
974         return _symbol;
975     }
976 
977     /**
978      * @dev Returns the number of decimals used to get its user representation.
979      * For example, if `decimals` equals `2`, a balance of `505` tokens should
980      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
981      *
982      * Tokens usually opt for a value of 18, imitating the relationship between
983      * Ether and Wei. This is the value {ERC20} uses, unless this function is
984      * overridden;
985      *
986      * NOTE: This information is only used for _display_ purposes: it in
987      * no way affects any of the arithmetic of the contract, including
988      * {IERC20-balanceOf} and {IERC20-transfer}.
989      */
990     function decimals() public view virtual override returns (uint8) {
991         return 18;
992     }
993 
994     /**
995      * @dev See {IERC20-totalSupply}.
996      */
997     function totalSupply() public view virtual override returns (uint256) {
998         return _totalSupply;
999     }
1000 
1001     /**
1002      * @dev See {IERC20-balanceOf}.
1003      */
1004     function balanceOf(
1005         address account
1006     ) public view virtual override returns (uint256) {
1007         return _balances[account];
1008     }
1009 
1010     /**
1011      * @dev See {IERC20-transfer}.
1012      *
1013      * Requirements:
1014      *
1015      * - `to` cannot be the zero address.
1016      * - the caller must have a balance of at least `amount`.
1017      */
1018     function transfer(
1019         address to,
1020         uint256 amount
1021     ) public virtual override returns (bool) {
1022         address owner = _msgSender();
1023         _transfer(owner, to, amount);
1024         return true;
1025     }
1026 
1027     /**
1028      * @dev See {IERC20-allowance}.
1029      */
1030     function allowance(
1031         address owner,
1032         address spender
1033     ) public view virtual override returns (uint256) {
1034         return _allowances[owner][spender];
1035     }
1036 
1037     /**
1038      * @dev See {IERC20-approve}.
1039      *
1040      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1041      * `transferFrom`. This is semantically equivalent to an infinite approval.
1042      *
1043      * Requirements:
1044      *
1045      * - `spender` cannot be the zero address.
1046      */
1047     function approve(
1048         address spender,
1049         uint256 amount
1050     ) public virtual override returns (bool) {
1051         address owner = _msgSender();
1052         _approve(owner, spender, amount);
1053         return true;
1054     }
1055 
1056     /**
1057      * @dev See {IERC20-transferFrom}.
1058      *
1059      * Emits an {Approval} event indicating the updated allowance. This is not
1060      * required by the EIP. See the note at the beginning of {ERC20}.
1061      *
1062      * NOTE: Does not update the allowance if the current allowance
1063      * is the maximum `uint256`.
1064      *
1065      * Requirements:
1066      *
1067      * - `from` and `to` cannot be the zero address.
1068      * - `from` must have a balance of at least `amount`.
1069      * - the caller must have allowance for ``from``'s tokens of at least
1070      * `amount`.
1071      */
1072     function transferFrom(
1073         address from,
1074         address to,
1075         uint256 amount
1076     ) public virtual override returns (bool) {
1077         address spender = _msgSender();
1078         _spendAllowance(from, spender, amount);
1079         _transfer(from, to, amount);
1080         return true;
1081     }
1082 
1083     /**
1084      * @dev Atomically increases the allowance granted to `spender` by the caller.
1085      *
1086      * This is an alternative to {approve} that can be used as a mitigation for
1087      * problems described in {IERC20-approve}.
1088      *
1089      * Emits an {Approval} event indicating the updated allowance.
1090      *
1091      * Requirements:
1092      *
1093      * - `spender` cannot be the zero address.
1094      */
1095     function increaseAllowance(
1096         address spender,
1097         uint256 addedValue
1098     ) public virtual returns (bool) {
1099         address owner = _msgSender();
1100         _approve(owner, spender, allowance(owner, spender) + addedValue);
1101         return true;
1102     }
1103 
1104     /**
1105      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1106      *
1107      * This is an alternative to {approve} that can be used as a mitigation for
1108      * problems described in {IERC20-approve}.
1109      *
1110      * Emits an {Approval} event indicating the updated allowance.
1111      *
1112      * Requirements:
1113      *
1114      * - `spender` cannot be the zero address.
1115      * - `spender` must have allowance for the caller of at least
1116      * `subtractedValue`.
1117      */
1118     function decreaseAllowance(
1119         address spender,
1120         uint256 subtractedValue
1121     ) public virtual returns (bool) {
1122         address owner = _msgSender();
1123         uint256 currentAllowance = allowance(owner, spender);
1124         require(
1125             currentAllowance >= subtractedValue,
1126             "ERC20: decreased allowance below zero"
1127         );
1128         unchecked {
1129             _approve(owner, spender, currentAllowance - subtractedValue);
1130         }
1131 
1132         return true;
1133     }
1134 
1135     /**
1136      * @dev Moves `amount` of tokens from `from` to `to`.
1137      *
1138      * This internal function is equivalent to {transfer}, and can be used to
1139      * e.g. implement automatic token fees, slashing mechanisms, etc.
1140      *
1141      * Emits a {Transfer} event.
1142      *
1143      * Requirements:
1144      *
1145      * - `from` cannot be the zero address.
1146      * - `to` cannot be the zero address.
1147      * - `from` must have a balance of at least `amount`.
1148      */
1149     function _transfer(
1150         address from,
1151         address to,
1152         uint256 amount
1153     ) internal virtual {
1154         require(from != address(0), "ERC20: transfer from the zero address");
1155         require(to != address(0), "ERC20: transfer to the zero address");
1156 
1157         _beforeTokenTransfer(from, to, amount);
1158 
1159         uint256 fromBalance = _balances[from];
1160         require(
1161             fromBalance >= amount,
1162             "ERC20: transfer amount exceeds balance"
1163         );
1164         unchecked {
1165             _balances[from] = fromBalance - amount;
1166             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
1167             // decrementing then incrementing.
1168             _balances[to] += amount;
1169         }
1170 
1171         emit Transfer(from, to, amount);
1172 
1173         _afterTokenTransfer(from, to, amount);
1174     }
1175 
1176     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1177      * the total supply.
1178      *
1179      * Emits a {Transfer} event with `from` set to the zero address.
1180      *
1181      * Requirements:
1182      *
1183      * - `account` cannot be the zero address.
1184      */
1185     function _mint(address account, uint256 amount) internal virtual {
1186         require(account != address(0), "ERC20: mint to the zero address");
1187 
1188         _beforeTokenTransfer(address(0), account, amount);
1189 
1190         _totalSupply += amount;
1191         unchecked {
1192             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
1193             _balances[account] += amount;
1194         }
1195         emit Transfer(address(0), account, amount);
1196 
1197         _afterTokenTransfer(address(0), account, amount);
1198     }
1199 
1200     /**
1201      * @dev Destroys `amount` tokens from `account`, reducing the
1202      * total supply.
1203      *
1204      * Emits a {Transfer} event with `to` set to the zero address.
1205      *
1206      * Requirements:
1207      *
1208      * - `account` cannot be the zero address.
1209      * - `account` must have at least `amount` tokens.
1210      */
1211     function _burn(address account, uint256 amount) internal virtual {
1212         require(account != address(0), "ERC20: burn from the zero address");
1213 
1214         _beforeTokenTransfer(account, address(0), amount);
1215 
1216         uint256 accountBalance = _balances[account];
1217         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1218         unchecked {
1219             _balances[account] = accountBalance - amount;
1220             // Overflow not possible: amount <= accountBalance <= totalSupply.
1221             _totalSupply -= amount;
1222         }
1223 
1224         emit Transfer(account, address(0), amount);
1225 
1226         _afterTokenTransfer(account, address(0), amount);
1227     }
1228 
1229     /**
1230      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1231      *
1232      * This internal function is equivalent to `approve`, and can be used to
1233      * e.g. set automatic allowances for certain subsystems, etc.
1234      *
1235      * Emits an {Approval} event.
1236      *
1237      * Requirements:
1238      *
1239      * - `owner` cannot be the zero address.
1240      * - `spender` cannot be the zero address.
1241      */
1242     function _approve(
1243         address owner,
1244         address spender,
1245         uint256 amount
1246     ) internal virtual {
1247         require(owner != address(0), "ERC20: approve from the zero address");
1248         require(spender != address(0), "ERC20: approve to the zero address");
1249 
1250         _allowances[owner][spender] = amount;
1251         emit Approval(owner, spender, amount);
1252     }
1253 
1254     /**
1255      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1256      *
1257      * Does not update the allowance amount in case of infinite allowance.
1258      * Revert if not enough allowance is available.
1259      *
1260      * Might emit an {Approval} event.
1261      */
1262     function _spendAllowance(
1263         address owner,
1264         address spender,
1265         uint256 amount
1266     ) internal virtual {
1267         uint256 currentAllowance = allowance(owner, spender);
1268         if (currentAllowance != type(uint256).max) {
1269             require(
1270                 currentAllowance >= amount,
1271                 "ERC20: insufficient allowance"
1272             );
1273             unchecked {
1274                 _approve(owner, spender, currentAllowance - amount);
1275             }
1276         }
1277     }
1278 
1279     /**
1280      * @dev Hook that is called before any transfer of tokens. This includes
1281      * minting and burning.
1282      *
1283      * Calling conditions:
1284      *
1285      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1286      * will be transferred to `to`.
1287      * - when `from` is zero, `amount` tokens will be minted for `to`.
1288      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1289      * - `from` and `to` are never both zero.
1290      *
1291      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1292      */
1293     function _beforeTokenTransfer(
1294         address from,
1295         address to,
1296         uint256 amount
1297     ) internal virtual {}
1298 
1299     /**
1300      * @dev Hook that is called after any transfer of tokens. This includes
1301      * minting and burning.
1302      *
1303      * Calling conditions:
1304      *
1305      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1306      * has been transferred to `to`.
1307      * - when `from` is zero, `amount` tokens have been minted for `to`.
1308      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1309      * - `from` and `to` are never both zero.
1310      *
1311      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1312      */
1313     function _afterTokenTransfer(
1314         address from,
1315         address to,
1316         uint256 amount
1317     ) internal virtual {}
1318 }
1319 
1320 contract ShibaSaga is ERC20, Ownable, ReentrancyGuard {
1321     using SafeERC20 for IERC20;
1322 
1323     uint256 public buyTax;
1324     uint256 public sellTax;
1325     uint256 public immutable denominator;
1326 
1327     address public marketingWallet;
1328 
1329     bool private swapping;
1330     uint256 public swapTokensAtAmount;
1331     bool public isSwapBackEnabled;
1332 
1333     IUniswapV2Router02 public immutable uniswapV2Router;
1334     address public immutable uniswapV2Pair;
1335 
1336     mapping(address => bool) private _isExcludedFromFees;
1337     mapping(address => bool) private _isAutomatedMarketMakerPair;
1338 
1339     modifier inSwap() {
1340         swapping = true;
1341         _;
1342         swapping = false;
1343     }
1344 
1345     event UpdateMarketingWallet(address indexed marketingWallet);
1346     event UpdateSwapTokensAtAmount(uint256 swapTokensAtAmount);
1347     event UpdateSwapBackStatus(bool status);
1348     event UpdateExcludeFromFees(address indexed account, bool isExcluded);
1349     event UpdateAutomatedMarketMakerPair(address indexed pair, bool status);
1350     event UpdateBuyTax(uint256 buyTax);
1351     event UpdateSellTax(uint256 sellTax);
1352     event TriggeredBurn(uint256 amount);
1353 
1354     constructor() ERC20("ShibaSaga", "SHIA") {
1355         _mint(owner(), 10_000_000_000 * (10 ** 18)); // 10,000,000,000 Token
1356 
1357         buyTax = 100; // 1%
1358         sellTax = 200; // 2%
1359         denominator = 10_000;
1360 
1361         marketingWallet = 0x927af13656aAB84c794b6F59262de4cBff15170A;
1362 
1363         swapTokensAtAmount = (totalSupply() * 1) / 10_000; // 0.01% of totalSupply
1364         isSwapBackEnabled = true;
1365 
1366         address router = getRouterAddress();
1367         uniswapV2Router = IUniswapV2Router02(router);
1368         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
1369             address(this),
1370             uniswapV2Router.WETH()
1371         );
1372 
1373         _approve(address(this), address(uniswapV2Router), type(uint256).max);
1374 
1375         _isExcludedFromFees[owner()] = true;
1376         _isExcludedFromFees[address(this)] = true;
1377         _isExcludedFromFees[address(uniswapV2Router)] = true;
1378 
1379         _isAutomatedMarketMakerPair[address(uniswapV2Pair)] = true;
1380     }
1381 
1382     receive() external payable {}
1383 
1384     fallback() external payable {}
1385 
1386     function getRouterAddress() public view returns (address) {
1387         if (block.chainid == 56) {
1388             return 0x10ED43C718714eb63d5aA57B78B54704E256024E;
1389         } else if (block.chainid == 97) {
1390             return 0xD99D1c33F9fC3444f8101754aBC46c52416550D1;
1391         } else if (block.chainid == 1 || block.chainid == 5) {
1392             return 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
1393         } else {
1394             revert("Cannot found router on this network");
1395         }
1396     }
1397 
1398     function claimStuckTokens(address token) external onlyOwner {
1399         require(token != address(this), "Owner cannot claim native tokens");
1400 
1401         if (token == address(0x0)) {
1402             payable(msg.sender).transfer(address(this).balance);
1403             return;
1404         }
1405         IERC20 ERC20token = IERC20(token);
1406         uint256 balance = ERC20token.balanceOf(address(this));
1407         ERC20token.safeTransfer(msg.sender, balance);
1408     }
1409 
1410     function setMarketingWallet(address _marketingWallet) external onlyOwner {
1411         require(
1412             _marketingWallet != marketingWallet,
1413             "Marketing wallet is already that address"
1414         );
1415         require(
1416             _marketingWallet != address(0),
1417             "Marketing wallet cannot be the zero address"
1418         );
1419 
1420         marketingWallet = _marketingWallet;
1421         emit UpdateMarketingWallet(_marketingWallet);
1422     }
1423 
1424     function setSwapTokensAtAmount(uint256 amount) external onlyOwner {
1425         require(
1426             swapTokensAtAmount != amount,
1427             "SwapTokensAtAmount already on that amount"
1428         );
1429         require(amount >= 1, "Amount must be equal or greater than 1 Wei");
1430 
1431         swapTokensAtAmount = amount;
1432 
1433         emit UpdateSwapTokensAtAmount(amount);
1434     }
1435 
1436     function toggleSwapBack(bool status) external onlyOwner {
1437         require(isSwapBackEnabled != status, "SwapBack already on status");
1438 
1439         isSwapBackEnabled = status;
1440         emit UpdateSwapBackStatus(status);
1441     }
1442 
1443     function setExcludeFromFees(
1444         address account,
1445         bool excluded
1446     ) external onlyOwner {
1447         require(
1448             _isExcludedFromFees[account] != excluded,
1449             "Account is already the value of 'excluded'"
1450         );
1451         _isExcludedFromFees[account] = excluded;
1452 
1453         emit UpdateExcludeFromFees(account, excluded);
1454     }
1455 
1456     function isExcludedFromFees(address account) external view returns (bool) {
1457         return _isExcludedFromFees[account];
1458     }
1459 
1460     function setAutomatedMarketMakerPair(
1461         address pair,
1462         bool status
1463     ) external onlyOwner {
1464         require(
1465             _isAutomatedMarketMakerPair[pair] != status,
1466             "Pair address is already the value of 'status'"
1467         );
1468         _isAutomatedMarketMakerPair[pair] = status;
1469 
1470         emit UpdateAutomatedMarketMakerPair(pair, status);
1471     }
1472 
1473     function isAutomatedMarketMakerPair(
1474         address pair
1475     ) external view returns (bool) {
1476         return _isAutomatedMarketMakerPair[pair];
1477     }
1478 
1479     function setBuyTax(uint256 amount) external onlyOwner {
1480         require(buyTax != amount, "BuyTax already on that amount");
1481         require(
1482             amount + sellTax <= 2_500,
1483             "BuyTax and SellTax cannot be more than 25%"
1484         );
1485 
1486         buyTax = amount;
1487 
1488         emit UpdateBuyTax(amount);
1489     }
1490 
1491     function setSellTax(uint256 amount) external onlyOwner {
1492         require(sellTax != amount, "SellTax already on that amount");
1493         require(
1494             amount + buyTax <= 2_500,
1495             "BuyTax and SellTax cannot be more than 25%"
1496         );
1497 
1498         sellTax = amount;
1499 
1500         emit UpdateSellTax(amount);
1501     }
1502 
1503     function burnToken(uint256 amount) external onlyOwner {
1504         require(balanceOf(msg.sender) >= amount, "Balance not enough to burn");
1505 
1506         super._transfer(msg.sender, address(0xdead), amount);
1507 
1508         emit TriggeredBurn(amount);
1509     }
1510 
1511     function _transfer(
1512         address from,
1513         address to,
1514         uint256 amount
1515     ) internal override {
1516         require(from != address(0), "ERC20: transfer from the zero address");
1517         require(to != address(0), "ERC20: transfer to the zero address");
1518 
1519         if (amount == 0) {
1520             super._transfer(from, to, 0);
1521             return;
1522         }
1523 
1524         uint256 contractTokenBalance = balanceOf(address(this));
1525 
1526         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1527 
1528         if (
1529             canSwap &&
1530             !swapping &&
1531             _isAutomatedMarketMakerPair[to] &&
1532             isSwapBackEnabled
1533         ) {
1534             swapBack();
1535         }
1536 
1537         bool takeFee = true;
1538 
1539         if (_isExcludedFromFees[from] || _isExcludedFromFees[to] || swapping) {
1540             takeFee = false;
1541         }
1542 
1543         if (takeFee) {
1544             uint256 fees = 0;
1545 
1546             if (_isAutomatedMarketMakerPair[from]) {
1547                 fees = (amount * buyTax) / denominator;
1548             } else if (_isAutomatedMarketMakerPair[to]) {
1549                 fees = (amount * sellTax) / denominator;
1550             }
1551 
1552             if (fees > 0) {
1553                 amount -= fees;
1554                 super._transfer(from, address(this), fees);
1555             }
1556         }
1557 
1558         super._transfer(from, to, amount);
1559     }
1560 
1561     function swapBack() internal inSwap {
1562         address[] memory path = new address[](2);
1563         path[0] = address(this);
1564         path[1] = uniswapV2Router.WETH();
1565 
1566         uint256 contractTokenBalance = balanceOf(address(this));
1567         uint256 contractWETHBalance = address(this).balance;
1568 
1569         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1570             contractTokenBalance,
1571             0,
1572             path,
1573             address(this),
1574             block.timestamp
1575         );
1576 
1577         uint256 newBalance = address(this).balance - contractWETHBalance;
1578 
1579         if (newBalance > 0) {
1580             sendBNB(marketingWallet, newBalance);
1581         }
1582     }
1583 
1584     function sendBNB(address _to, uint256 amount) internal nonReentrant {
1585         require(
1586             address(this).balance >= amount,
1587             "Insufficient balance to send"
1588         );
1589 
1590         (bool success, ) = payable(_to).call{value: amount}("");
1591 
1592         require(success, "unable to send value, recipient may have reverted");
1593     }
1594 
1595     function manualSwapBack() external {
1596         uint256 contractTokenBalance = balanceOf(address(this));
1597 
1598         require(contractTokenBalance > 0, "Cant Swap Back 0 Token!");
1599 
1600         swapBack();
1601     }
1602 }