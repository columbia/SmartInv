1 pragma solidity ^0.8.0;
2 
3 /**
4  * @dev Contract module that helps prevent reentrant calls to a function.
5  *
6  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
7  * available, which can be applied to functions to make sure there are no nested
8  * (reentrant) calls to them.
9  *
10  * Note that because there is a single `nonReentrant` guard, functions marked as
11  * `nonReentrant` may not call one another. This can be worked around by making
12  * those functions `private`, and then adding `external` `nonReentrant` entry
13  * points to them.
14  *
15  * TIP: If you would like to learn more about reentrancy and alternative ways
16  * to protect against it, check out our blog post
17  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
18  */
19 abstract contract ReentrancyGuard {
20     // Booleans are more expensive than uint256 or any type that takes up a full
21     // word because each write operation emits an extra SLOAD to first read the
22     // slot's contents, replace the bits taken up by the boolean, and then write
23     // back. This is the compiler's defense against contract upgrades and
24     // pointer aliasing, and it cannot be disabled.
25 
26     // The values being non-zero value makes deployment a bit more expensive,
27     // but in exchange the refund on every call to nonReentrant will be lower in
28     // amount. Since refunds are capped to a percentage of the total
29     // transaction's gas, it is best to keep them low in cases like this one, to
30     // increase the likelihood of the full refund coming into effect.
31     uint256 private constant _NOT_ENTERED = 1;
32     uint256 private constant _ENTERED = 2;
33 
34     uint256 private _status;
35 
36     constructor() {
37         _status = _NOT_ENTERED;
38     }
39 
40     /**
41      * @dev Prevents a contract from calling itself, directly or indirectly.
42      * Calling a `nonReentrant` function from another `nonReentrant`
43      * function is not supported. It is possible to prevent this from happening
44      * by making the `nonReentrant` function external, and making it call a
45      * `private` function that does the actual work.
46      */
47     modifier nonReentrant() {
48         _nonReentrantBefore();
49         _;
50         _nonReentrantAfter();
51     }
52 
53     function _nonReentrantBefore() private {
54         // On the first call to nonReentrant, _status will be _NOT_ENTERED
55         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
56 
57         // Any calls to nonReentrant after this point will fail
58         _status = _ENTERED;
59     }
60 
61     function _nonReentrantAfter() private {
62         // By storing the original value once again, a refund is triggered (see
63         // https://eips.ethereum.org/EIPS/eip-2200)
64         _status = _NOT_ENTERED;
65     }
66 
67     /**
68      * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
69      * `nonReentrant` function in the call stack.
70      */
71     function _reentrancyGuardEntered() internal view returns (bool) {
72         return _status == _ENTERED;
73     }
74 }
75 
76 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
77 
78 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
79 
80 pragma solidity ^0.8.0;
81 
82 /**
83  * @dev Provides information about the current execution context, including the
84  * sender of the transaction and its data. While these are generally available
85  * via msg.sender and msg.data, they should not be accessed in such a direct
86  * manner, since when dealing with meta-transactions the account sending and
87  * paying for execution may not be the actual sender (as far as an application
88  * is concerned).
89  *
90  * This contract is only required for intermediate, library-like contracts.
91  */
92 abstract contract Context {
93     function _msgSender() internal view virtual returns (address) {
94         return msg.sender;
95     }
96 
97     function _msgData() internal view virtual returns (bytes calldata) {
98         return msg.data;
99     }
100 }
101 
102 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
103 
104 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
105 
106 pragma solidity ^0.8.0;
107 
108 /**
109  * @dev Contract module which provides a basic access control mechanism, where
110  * there is an account (an owner) that can be granted exclusive access to
111  * specific functions.
112  *
113  * By default, the owner account will be the one that deploys the contract. This
114  * can later be changed with {transferOwnership}.
115  *
116  * This module is used through inheritance. It will make available the modifier
117  * `onlyOwner`, which can be applied to your functions to restrict their use to
118  * the owner.
119  */
120 abstract contract Ownable is Context {
121     address private _owner;
122     event OwnershipTransferred(
123         address indexed previousOwner,
124         address indexed newOwner
125     );
126 
127     /**
128      * @dev Initializes the contract setting the deployer as the initial owner.
129      */
130     constructor() {
131         _transferOwnership(_msgSender());
132     }
133 
134     /**
135      * @dev Throws if called by any account other than the owner.
136      */
137     modifier onlyOwner() {
138         _checkOwner();
139         _;
140     }
141 
142     /**
143      * @dev Returns the address of the current owner.
144      */
145     function owner() public view virtual returns (address) {
146         return _owner;
147     }
148 
149     /**
150      * @dev Throws if the sender is not the owner.
151      */
152     function _checkOwner() internal view virtual {
153         require(owner() == _msgSender(), "Ownable: caller is not the owner");
154     }
155 
156     /**
157      * @dev Leaves the contract without owner. It will not be possible to call
158      * `onlyOwner` functions anymore. Can only be called by the current owner.
159      *
160      * NOTE: Renouncing ownership will leave the contract without an owner,
161      * thereby removing any functionality that is only available to the owner.
162      */
163     function renounceOwnership() public virtual onlyOwner {
164         _transferOwnership(address(0));
165     }
166 
167     /**
168      * @dev Transfers ownership of the contract to a new account (`newOwner`).
169      * Can only be called by the current owner.
170      */
171     function transferOwnership(address newOwner) public virtual onlyOwner {
172         require(
173             newOwner != address(0),
174             "Ownable: new owner is the zero address"
175         );
176         _transferOwnership(newOwner);
177     }
178 
179     /**
180      * @dev Transfers ownership of the contract to a new account (`newOwner`).
181      * Internal function without access restriction.
182      */
183     function _transferOwnership(address newOwner) internal virtual {
184         address oldOwner = _owner;
185         _owner = newOwner;
186         emit OwnershipTransferred(oldOwner, newOwner);
187     }
188 }
189 
190 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/Pausable.sol
191 
192 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
193 
194 pragma solidity ^0.8.0;
195 
196 /**
197  * @dev Contract module which allows children to implement an emergency stop
198  * mechanism that can be triggered by an authorized account.
199  *
200  * This module is used through inheritance. It will make available the
201  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
202  * the functions of your contract. Note that they will not be pausable by
203  * simply including this module, only once the modifiers are put in place.
204  */
205 abstract contract Pausable is Context {
206     /**
207      * @dev Emitted when the pause is triggered by `account`.
208      */
209     event Paused(address account);
210 
211     /**
212      * @dev Emitted when the pause is lifted by `account`.
213      */
214     event Unpaused(address account);
215 
216     bool private _paused;
217 
218     /**
219      * @dev Initializes the contract in unpaused state.
220      */
221     constructor() {
222         _paused = false;
223     }
224 
225     /**
226      * @dev Modifier to make a function callable only when the contract is not paused.
227      *
228      * Requirements:
229      *
230      * - The contract must not be paused.
231      */
232     modifier whenNotPaused() {
233         _requireNotPaused();
234         _;
235     }
236 
237     /**
238      * @dev Modifier to make a function callable only when the contract is paused.
239      *
240      * Requirements:
241      *
242      * - The contract must be paused.
243      */
244     modifier whenPaused() {
245         _requirePaused();
246         _;
247     }
248 
249     /**
250      * @dev Returns true if the contract is paused, and false otherwise.
251      */
252     function paused() public view virtual returns (bool) {
253         return _paused;
254     }
255 
256     /**
257      * @dev Throws if the contract is paused.
258      */
259     function _requireNotPaused() internal view virtual {
260         require(!paused(), "Pausable: paused");
261     }
262 
263     /**
264      * @dev Throws if the contract is not paused.
265      */
266     function _requirePaused() internal view virtual {
267         require(paused(), "Pausable: not paused");
268     }
269 
270     /**
271      * @dev Triggers stopped state.
272      *
273      * Requirements:
274      *
275      * - The contract must not be paused.
276      */
277     function _pause() internal virtual whenNotPaused {
278         _paused = true;
279         emit Paused(_msgSender());
280     }
281 
282     /**
283      * @dev Returns to normal state.
284      *
285      * Requirements:
286      *
287      * - The contract must be paused.
288      */
289     function _unpause() internal virtual whenPaused {
290         _paused = false;
291         emit Unpaused(_msgSender());
292     }
293 }
294 
295 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/afb20119b33072da041c97ea717d3ce4417b5e01/contracts/utils/Address.sol
296 
297 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
298 
299 pragma solidity ^0.8.1;
300 
301 /**
302  * @dev Collection of functions related to the address type
303  */
304 library Address {
305     /**
306      * @dev Returns true if `account` is a contract.
307      *
308      * [IMPORTANT]
309      * ====
310      * It is unsafe to assume that an address for which this function returns
311      * false is an externally-owned account (EOA) and not a contract.
312      *
313      * Among others, `isContract` will return false for the following
314      * types of addresses:
315      *
316      *  - an externally-owned account
317      *  - a contract in construction
318      *  - an address where a contract will be created
319      *  - an address where a contract lived, but was destroyed
320      * ====
321      *
322      * [IMPORTANT]
323      * ====
324      * You shouldn't rely on `isContract` to protect against flash loan attacks!
325      *
326      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
327      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
328      * constructor.
329      * ====
330      */
331     function isContract(address account) internal view returns (bool) {
332         // This method relies on extcodesize/address.code.length, which returns 0
333         // for contracts in construction, since the code is only stored at the end
334         // of the constructor execution.
335 
336         return account.code.length > 0;
337     }
338 
339     /**
340      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
341      * `recipient`, forwarding all available gas and reverting on errors.
342      *
343      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
344      * of certain opcodes, possibly making contracts go over the 2300 gas limit
345      * imposed by `transfer`, making them unable to receive funds via
346      * `transfer`. {sendValue} removes this limitation.
347      *
348      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
349      *
350      * IMPORTANT: because control is transferred to `recipient`, care must be
351      * taken to not create reentrancy vulnerabilities. Consider using
352      * {ReentrancyGuard} or the
353      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
354      */
355     function sendValue(address payable recipient, uint256 amount) internal {
356         require(
357             address(this).balance >= amount,
358             "Address: insufficient balance"
359         );
360 
361         (bool success, ) = recipient.call{value: amount}("");
362         require(
363             success,
364             "Address: unable to send value, recipient may have reverted"
365         );
366     }
367 
368     /**
369      * @dev Performs a Solidity function call using a low level `call`. A
370      * plain `call` is an unsafe replacement for a function call: use this
371      * function instead.
372      *
373      * If `target` reverts with a revert reason, it is bubbled up by this
374      * function (like regular Solidity function calls).
375      *
376      * Returns the raw returned data. To convert to the expected return value,
377      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
378      *
379      * Requirements:
380      *
381      * - `target` must be a contract.
382      * - calling `target` with `data` must not revert.
383      *
384      * _Available since v3.1._
385      */
386     function functionCall(address target, bytes memory data)
387         internal
388         returns (bytes memory)
389     {
390         return functionCall(target, data, "Address: low-level call failed");
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
395      * `errorMessage` as a fallback revert reason when `target` reverts.
396      *
397      * _Available since v3.1._
398      */
399     function functionCall(
400         address target,
401         bytes memory data,
402         string memory errorMessage
403     ) internal returns (bytes memory) {
404         return functionCallWithValue(target, data, 0, errorMessage);
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
409      * but also transferring `value` wei to `target`.
410      *
411      * Requirements:
412      *
413      * - the calling contract must have an ETH balance of at least `value`.
414      * - the called Solidity function must be `payable`.
415      *
416      * _Available since v3.1._
417      */
418     function functionCallWithValue(
419         address target,
420         bytes memory data,
421         uint256 value
422     ) internal returns (bytes memory) {
423         return
424             functionCallWithValue(
425                 target,
426                 data,
427                 value,
428                 "Address: low-level call with value failed"
429             );
430     }
431 
432     /**
433      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
434      * with `errorMessage` as a fallback revert reason when `target` reverts.
435      *
436      * _Available since v3.1._
437      */
438     function functionCallWithValue(
439         address target,
440         bytes memory data,
441         uint256 value,
442         string memory errorMessage
443     ) internal returns (bytes memory) {
444         require(
445             address(this).balance >= value,
446             "Address: insufficient balance for call"
447         );
448         require(isContract(target), "Address: call to non-contract");
449 
450         (bool success, bytes memory returndata) = target.call{value: value}(
451             data
452         );
453         return verifyCallResult(success, returndata, errorMessage);
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
458      * but performing a static call.
459      *
460      * _Available since v3.3._
461      */
462     function functionStaticCall(address target, bytes memory data)
463         internal
464         view
465         returns (bytes memory)
466     {
467         return
468             functionStaticCall(
469                 target,
470                 data,
471                 "Address: low-level static call failed"
472             );
473     }
474 
475     /**
476      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
477      * but performing a static call.
478      *
479      * _Available since v3.3._
480      */
481     function functionStaticCall(
482         address target,
483         bytes memory data,
484         string memory errorMessage
485     ) internal view returns (bytes memory) {
486         require(isContract(target), "Address: static call to non-contract");
487 
488         (bool success, bytes memory returndata) = target.staticcall(data);
489         return verifyCallResult(success, returndata, errorMessage);
490     }
491 
492     /**
493      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
494      * but performing a delegate call.
495      *
496      * _Available since v3.4._
497      */
498     function functionDelegateCall(address target, bytes memory data)
499         internal
500         returns (bytes memory)
501     {
502         return
503             functionDelegateCall(
504                 target,
505                 data,
506                 "Address: low-level delegate call failed"
507             );
508     }
509 
510     /**
511      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
512      * but performing a delegate call.
513      *
514      * _Available since v3.4._
515      */
516     function functionDelegateCall(
517         address target,
518         bytes memory data,
519         string memory errorMessage
520     ) internal returns (bytes memory) {
521         require(isContract(target), "Address: delegate call to non-contract");
522 
523         (bool success, bytes memory returndata) = target.delegatecall(data);
524         return verifyCallResult(success, returndata, errorMessage);
525     }
526 
527     /**
528      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
529      * revert reason using the provided one.
530      *
531      * _Available since v4.3._
532      */
533     function verifyCallResult(
534         bool success,
535         bytes memory returndata,
536         string memory errorMessage
537     ) internal pure returns (bytes memory) {
538         if (success) {
539             return returndata;
540         } else {
541             // Look for revert reason and bubble it up if present
542             if (returndata.length > 0) {
543                 // The easiest way to bubble the revert reason is using memory via assembly
544 
545                 assembly {
546                     let returndata_size := mload(returndata)
547                     revert(add(32, returndata), returndata_size)
548                 }
549             } else {
550                 revert(errorMessage);
551             }
552         }
553     }
554 }
555 
556 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
557 
558 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
559 
560 pragma solidity ^0.8.0;
561 
562 /**
563  * @dev Interface of the ERC20 standard as defined in the EIP.
564  */
565 interface IERC20 {
566     /**
567      * @dev Emitted when `value` tokens are moved from one account (`from`) to
568      * another (`to`).
569      *
570      * Note that `value` may be zero.
571      */
572     event Transfer(address indexed from, address indexed to, uint256 value);
573 
574     /**
575      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
576      * a call to {approve}. `value` is the new allowance.
577      */
578     event Approval(
579         address indexed owner,
580         address indexed spender,
581         uint256 value
582     );
583 
584     /**
585      * @dev Returns the amount of tokens in existence.
586      */
587     function totalSupply() external view returns (uint256);
588 
589     /**
590      * @dev Returns the amount of tokens owned by `account`.
591      */
592     function balanceOf(address account) external view returns (uint256);
593 
594     /**
595      * @dev Moves `amount` tokens from the caller's account to `to`.
596      *
597      * Returns a boolean value indicating whether the operation succeeded.
598      *
599      * Emits a {Transfer} event.
600      */
601     function transfer(address to, uint256 amount) external returns (bool);
602 
603     /**
604      * @dev Returns the remaining number of tokens that `spender` will be
605      * allowed to spend on behalf of `owner` through {transferFrom}. This is
606      * zero by default.
607      *
608      * This value changes when {approve} or {transferFrom} are called.
609      */
610     function allowance(address owner, address spender)
611         external
612         view
613         returns (uint256);
614 
615     /**
616      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
617      *
618      * Returns a boolean value indicating whether the operation succeeded.
619      *
620      * IMPORTANT: Beware that changing an allowance with this method brings the risk
621      * that someone may use both the old and the new allowance by unfortunate
622      * transaction ordering. One possible solution to mitigate this race
623      * condition is to first reduce the spender's allowance to 0 and set the
624      * desired value afterwards:
625      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
626      *
627      * Emits an {Approval} event.
628      */
629     function approve(address spender, uint256 amount) external returns (bool);
630 
631     /**
632      * @dev Moves `amount` tokens from `from` to `to` using the
633      * allowance mechanism. `amount` is then deducted from the caller's
634      * allowance.
635      *
636      * Returns a boolean value indicating whether the operation succeeded.
637      *
638      * Emits a {Transfer} event.
639      */
640     function transferFrom(
641         address from,
642         address to,
643         uint256 amount
644     ) external returns (bool);
645 }
646 
647 // File: presale.sol
648 
649 //SPDX-License-Identifier: MIT
650 pragma solidity ^0.8.6;
651 
652 interface IUniswapV2Router01 {
653     function factory() external pure returns (address);
654 
655     function WETH() external pure returns (address);
656 
657     function addLiquidity(
658         address tokenA,
659         address tokenB,
660         uint256 amountADesired,
661         uint256 amountBDesired,
662         uint256 amountAMin,
663         uint256 amountBMin,
664         address to,
665         uint256 deadline
666     )
667         external
668         returns (
669             uint256 amountA,
670             uint256 amountB,
671             uint256 liquidity
672         );
673 
674     function addLiquidityETH(
675         address token,
676         uint256 amountTokenDesired,
677         uint256 amountTokenMin,
678         uint256 amountETHMin,
679         address to,
680         uint256 deadline
681     )
682         external
683         payable
684         returns (
685             uint256 amountToken,
686             uint256 amountETH,
687             uint256 liquidity
688         );
689 
690     function removeLiquidity(
691         address tokenA,
692         address tokenB,
693         uint256 liquidity,
694         uint256 amountAMin,
695         uint256 amountBMin,
696         address to,
697         uint256 deadline
698     ) external returns (uint256 amountA, uint256 amountB);
699 
700     function removeLiquidityETH(
701         address token,
702         uint256 liquidity,
703         uint256 amountTokenMin,
704         uint256 amountETHMin,
705         address to,
706         uint256 deadline
707     ) external returns (uint256 amountToken, uint256 amountETH);
708 
709     function removeLiquidityWithPermit(
710         address tokenA,
711         address tokenB,
712         uint256 liquidity,
713         uint256 amountAMin,
714         uint256 amountBMin,
715         address to,
716         uint256 deadline,
717         bool approveMax,
718         uint8 v,
719         bytes32 r,
720         bytes32 s
721     ) external returns (uint256 amountA, uint256 amountB);
722 
723     function removeLiquidityETHWithPermit(
724         address token,
725         uint256 liquidity,
726         uint256 amountTokenMin,
727         uint256 amountETHMin,
728         address to,
729         uint256 deadline,
730         bool approveMax,
731         uint8 v,
732         bytes32 r,
733         bytes32 s
734     ) external returns (uint256 amountToken, uint256 amountETH);
735 
736     function swapExactTokensForTokens(
737         uint256 amountIn,
738         uint256 amountOutMin,
739         address[] calldata path,
740         address to,
741         uint256 deadline
742     ) external returns (uint256[] memory amounts);
743 
744     function swapTokensForExactTokens(
745         uint256 amountOut,
746         uint256 amountInMax,
747         address[] calldata path,
748         address to,
749         uint256 deadline
750     ) external returns (uint256[] memory amounts);
751 
752     function swapExactETHForTokens(
753         uint256 amountOutMin,
754         address[] calldata path,
755         address to,
756         uint256 deadline
757     ) external payable returns (uint256[] memory amounts);
758 
759     function swapTokensForExactETH(
760         uint256 amountOut,
761         uint256 amountInMax,
762         address[] calldata path,
763         address to,
764         uint256 deadline
765     ) external returns (uint256[] memory amounts);
766 
767     function swapExactTokensForETH(
768         uint256 amountIn,
769         uint256 amountOutMin,
770         address[] calldata path,
771         address to,
772         uint256 deadline
773     ) external returns (uint256[] memory amounts);
774 
775     function swapETHForExactTokens(
776         uint256 amountOut,
777         address[] calldata path,
778         address to,
779         uint256 deadline
780     ) external payable returns (uint256[] memory amounts);
781 
782     function quote(
783         uint256 amountA,
784         uint256 reserveA,
785         uint256 reserveB
786     ) external pure returns (uint256 amountB);
787 
788     function getAmountOut(
789         uint256 amountIn,
790         uint256 reserveIn,
791         uint256 reserveOut
792     ) external pure returns (uint256 amountOut);
793 
794     function getAmountIn(
795         uint256 amountOut,
796         uint256 reserveIn,
797         uint256 reserveOut
798     ) external pure returns (uint256 amountIn);
799 
800     function getAmountsOut(uint256 amountIn, address[] calldata path)
801         external
802         view
803         returns (uint256[] memory amounts);
804 
805     function getAmountsIn(uint256 amountOut, address[] calldata path)
806         external
807         view
808         returns (uint256[] memory amounts);
809 }
810 
811 interface IUniswapV2Factory {
812     event PairCreated(
813         address indexed token0,
814         address indexed token1,
815         address pair,
816         uint256
817     );
818 
819     function feeTo() external view returns (address);
820 
821     function feeToSetter() external view returns (address);
822 
823     function getPair(address tokenA, address tokenB)
824         external
825         view
826         returns (address pair);
827 
828     function allPairs(uint256) external view returns (address pair);
829 
830     function allPairsLength() external view returns (uint256);
831 
832     function createPair(address tokenA, address tokenB)
833         external
834         returns (address pair);
835 
836     function setFeeTo(address) external;
837 
838     function setFeeToSetter(address) external;
839 }
840 
841 interface IUniswapV2Pair {
842     event Approval(
843         address indexed owner,
844         address indexed spender,
845         uint256 value
846     );
847     event Transfer(address indexed from, address indexed to, uint256 value);
848 
849     function name() external pure returns (string memory);
850 
851     function symbol() external pure returns (string memory);
852 
853     function decimals() external pure returns (uint8);
854 
855     function totalSupply() external view returns (uint256);
856 
857     function balanceOf(address owner) external view returns (uint256);
858 
859     function allowance(address owner, address spender)
860         external
861         view
862         returns (uint256);
863 
864     function approve(address spender, uint256 value) external returns (bool);
865 
866     function transfer(address to, uint256 value) external returns (bool);
867 
868     function transferFrom(
869         address from,
870         address to,
871         uint256 value
872     ) external returns (bool);
873 
874     function DOMAIN_SEPARATOR() external view returns (bytes32);
875 
876     function PERMIT_TYPEHASH() external pure returns (bytes32);
877 
878     function nonces(address owner) external view returns (uint256);
879 
880     function permit(
881         address owner,
882         address spender,
883         uint256 value,
884         uint256 deadline,
885         uint8 v,
886         bytes32 r,
887         bytes32 s
888     ) external;
889 
890     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
891     event Burn(
892         address indexed sender,
893         uint256 amount0,
894         uint256 amount1,
895         address indexed to
896     );
897     event Swap(
898         address indexed sender,
899         uint256 amount0In,
900         uint256 amount1In,
901         uint256 amount0Out,
902         uint256 amount1Out,
903         address indexed to
904     );
905     event Sync(uint112 reserve0, uint112 reserve1);
906 
907     function MINIMUM_LIQUIDITY() external pure returns (uint256);
908 
909     function factory() external view returns (address);
910 
911     function token0() external view returns (address);
912 
913     function token1() external view returns (address);
914 
915     function getReserves()
916         external
917         view
918         returns (
919             uint112 reserve0,
920             uint112 reserve1,
921             uint32 blockTimestampLast
922         );
923 
924     function price0CumulativeLast() external view returns (uint256);
925 
926     function price1CumulativeLast() external view returns (uint256);
927 
928     function kLast() external view returns (uint256);
929 
930     function mint(address to) external returns (uint256 liquidity);
931 
932     function burn(address to)
933         external
934         returns (uint256 amount0, uint256 amount1);
935 
936     function swap(
937         uint256 amount0Out,
938         uint256 amount1Out,
939         address to,
940         bytes calldata data
941     ) external;
942 
943     function skim(address to) external;
944 
945     function sync() external;
946 
947     function initialize(address, address) external;
948 }
949 
950 interface IUniswapV2Router02 is IUniswapV2Router01 {
951     function removeLiquidityETHSupportingFeeOnTransferTokens(
952         address token,
953         uint256 liquidity,
954         uint256 amountTokenMin,
955         uint256 amountETHMin,
956         address to,
957         uint256 deadline
958     ) external returns (uint256 amountETH);
959 
960     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
961         address token,
962         uint256 liquidity,
963         uint256 amountTokenMin,
964         uint256 amountETHMin,
965         address to,
966         uint256 deadline,
967         bool approveMax,
968         uint8 v,
969         bytes32 r,
970         bytes32 s
971     ) external returns (uint256 amountETH);
972 
973     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
974         uint256 amountIn,
975         uint256 amountOutMin,
976         address[] calldata path,
977         address to,
978         uint256 deadline
979     ) external;
980 
981     function swapExactETHForTokensSupportingFeeOnTransferTokens(
982         uint256 amountOutMin,
983         address[] calldata path,
984         address to,
985         uint256 deadline
986     ) external payable;
987 
988     function swapExactTokensForETHSupportingFeeOnTransferTokens(
989         uint256 amountIn,
990         uint256 amountOutMin,
991         address[] calldata path,
992         address to,
993         uint256 deadline
994     ) external;
995 }
996 
997 interface Aggregator {
998     function latestRoundData()
999         external
1000         view
1001         returns (
1002             uint80 roundId,
1003             int256 answer,
1004             uint256 startedAt,
1005             uint256 updatedAt,
1006             uint80 answeredInRound
1007         );
1008 }
1009 
1010 
1011 contract DeeLance_PreSale is ReentrancyGuard, Ownable, Pausable {
1012     IUniswapV2Router02 public uniswapV2Router;
1013     uint256 public salePrice;
1014     uint256 public nextPrice;
1015     uint256 public totalTokensForPresale;
1016     uint256 public totalUsdValueForPresale;
1017     uint256 public minimumBuyAmount;
1018     uint256 public inSale;
1019     uint256 public inSaleUSDvalue;
1020     uint256 public hardcapSize;
1021     uint256 public startTime;
1022     uint256 public endTime;
1023     uint256 public claimStart;
1024     uint256 public baseDecimals;
1025     bool public isPresalePaused;
1026     uint256 public hardcapsizeUSD;
1027     // Current Step
1028     uint256 public currentStep;
1029 
1030     address public saleToken;
1031     address dataOracle;
1032     address routerAddress;
1033     address USDTtoken;
1034     address dAddress;
1035 
1036     mapping(address => uint256) public userDeposits;
1037     mapping(address => bool) public hasClaimed;
1038 
1039     event TokensBought(
1040         address indexed user,
1041         uint256 indexed tokensBought,
1042         address indexed purchaseToken,
1043         uint256 amountPaid,
1044         uint256 timestamp
1045     );
1046 
1047     event TokensClaimed(
1048         address indexed user,
1049         uint256 amount,
1050         uint256 timestamp
1051     );
1052 
1053     constructor() {
1054         //require(_startTime > block.timestamp && _endTime > _startTime, "Invalid time");
1055 
1056         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1057 
1058         uniswapV2Router = _uniswapV2Router;
1059 
1060         baseDecimals = (10**18);
1061         salePrice = 25 * (10**15); //0.025 USD
1062         hardcapSize = 217_407_407;
1063         totalTokensForPresale = 217_407_407;
1064         minimumBuyAmount = 0;
1065         inSale = totalTokensForPresale;
1066         startTime = block.timestamp;
1067         endTime = block.timestamp + 90 days;
1068         dataOracle = 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419;
1069         dAddress = 0xc3e9bbe8B1A89E1fF19e2B5c1ee3B78B335a7C96;
1070         routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
1071         USDTtoken = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
1072         startStep(1);
1073     }
1074 
1075     function startStep(uint256 stepIndex) internal {
1076         currentStep = stepIndex;
1077         if (stepIndex == 1) {
1078             salePrice = 25 * (10**15); //0.025 USD
1079             nextPrice = 27 * (10**15); //0.027 USD
1080             hardcapsizeUSD = 1500000;
1081             totalUsdValueForPresale = 1500000;
1082             inSaleUSDvalue = 1500000000000000000000000;
1083         } else if (stepIndex == 2) {
1084             salePrice = 27 * (10**15); //0.027 USD
1085             nextPrice = 30 * (10**15); //0.030 USD
1086             hardcapsizeUSD = 2000000;
1087             totalUsdValueForPresale = 2000000;
1088             inSaleUSDvalue = 2000000000000000000000000;
1089         } else if (stepIndex == 3){
1090             salePrice = 30 * (10**15); //0.030 USD
1091             nextPrice = 30 * (10**15); //0.030 USD
1092             hardcapsizeUSD = 2500000;
1093             totalUsdValueForPresale = 2500000;
1094             inSaleUSDvalue = 2500000000000000000000000;
1095         } else{
1096             revert("Presale it's over, sorry!");
1097         }
1098     }
1099 
1100     function changeManuallyStep(uint256 _value) external onlyOwner {
1101     startStep(_value);
1102     }
1103     
1104     function addTokensInSale(uint256 _value) external onlyOwner {
1105     inSale = inSale + _value;
1106     }
1107 
1108     function removeTokensInSale(uint256 _value) external onlyOwner  {
1109     inSale = inSale - _value;
1110     }
1111 
1112     function addHardcapsizeUSD(uint256 _valuehard, uint256 _valuetotal, uint256 _valueinsale) external onlyOwner  {
1113     hardcapsizeUSD = hardcapsizeUSD + _valuehard;
1114     totalUsdValueForPresale = totalUsdValueForPresale + _valuetotal;
1115     inSaleUSDvalue = inSaleUSDvalue + _valueinsale;
1116     }
1117 
1118     function removeHardcapsizeUSD(uint256 _valuehard, uint256 _valuetotal, uint256 _valueinsale) external onlyOwner {
1119     hardcapsizeUSD = hardcapsizeUSD - _valuehard;
1120     totalUsdValueForPresale = totalUsdValueForPresale - _valuetotal;
1121     inSaleUSDvalue = inSaleUSDvalue - _valueinsale;
1122     }
1123 
1124     function setSalePrice(uint256 _value, uint256 _valuenext) external onlyOwner {
1125         salePrice = _value;
1126         nextPrice = _valuenext;
1127     }
1128 
1129     function settotalTokensForPresale(uint256 _value) external onlyOwner {
1130         uint256 prevTotalTokensForPresale = totalTokensForPresale;
1131         uint256 diffTokensale = prevTotalTokensForPresale -
1132             totalTokensForPresale;
1133         inSale = inSale + diffTokensale;
1134         totalTokensForPresale = _value;
1135     }
1136 
1137     function pause() external onlyOwner {
1138         _pause();
1139         isPresalePaused = true;
1140     }
1141 
1142     function unpause() external onlyOwner  {
1143         _unpause();
1144         isPresalePaused = false;
1145     }
1146 
1147     function calculatePrice(uint256 _amount)
1148         internal
1149         view
1150         returns (uint256 totalValue)
1151     {
1152         uint256 totalSoldUSD = (totalUsdValueForPresale * (10**18)) -
1153             inSaleUSDvalue;
1154         if (msg.sender != dAddress) {
1155             uint256 currentStepAmount = 0;
1156             uint256 restAmount = 0;
1157             if (
1158                 hardcapsizeUSD * (10**18) <
1159                 totalSoldUSD + (_amount * salePrice) &&
1160                 currentStep < 3
1161             ) {
1162                 currentStepAmount =
1163                     (hardcapsizeUSD * (10**18) - totalSoldUSD) /
1164                     salePrice;
1165                 restAmount = _amount - currentStepAmount;
1166                 require(isPresalePaused != true, "presale paused");
1167                 return (currentStepAmount * salePrice + restAmount * nextPrice);
1168             } else if (
1169                 hardcapsizeUSD * (10**18) <
1170                 totalSoldUSD + (_amount * salePrice) &&
1171                 currentStep == 3
1172             ) {
1173                 return (hardcapsizeUSD * (10**18) - totalSoldUSD);
1174             }
1175         }
1176         require(isPresalePaused != true, "presale paused");
1177         return (_amount * salePrice);
1178     }
1179 
1180     function checkSoldUSDvalue() internal view returns (uint256 totalValue) {
1181         uint256 totalSoldUSD = (totalUsdValueForPresale * (10**18)) -
1182             inSaleUSDvalue;
1183         return (totalSoldUSD);
1184     }
1185 
1186     function getETHLatestPrice() public view returns (uint256) {
1187        (, int256 price, , , ) = Aggregator(dataOracle).latestRoundData();
1188         price = (price * (10**10));
1189        return uint256(price);
1190     }
1191 
1192     function sendValue(address payable recipient, uint256 amount) internal {
1193         require(address(this).balance >= amount, "Low balance");
1194         (bool success, ) = recipient.call{value: amount}("");
1195         require(success, "ETH Payment failed");
1196     }
1197 
1198     modifier checkSaleState(uint256 amount) {
1199         if (msg.sender != dAddress) {
1200             require(
1201                 block.timestamp >= startTime && block.timestamp <= endTime,
1202                 "Invalid time for buying"
1203             );
1204             require(amount >= minimumBuyAmount, "Too small amount");
1205             require(amount > 0 && amount <= inSale, "Invalid sale amount");
1206             _;
1207         }
1208     }
1209 
1210     function buyWithETH(uint256 amount)
1211         external
1212         payable
1213         checkSaleState(amount)
1214         whenNotPaused
1215         nonReentrant
1216     {
1217         // uint256 totalSoldUSD = (totalUsdValueForPresale * (10**18)) - inSaleUSDvalue;
1218         uint256 usdPrice = calculatePrice(amount);
1219         require(!(usdPrice == 0 && currentStep == 3),"Presale it's over, sorry!");
1220         uint256 ETHAmount = (usdPrice * (10**18)) / getETHLatestPrice();
1221         require(msg.value >= ETHAmount, "Less payment");
1222         uint256 excess = msg.value - ETHAmount;
1223         if (usdPrice > inSaleUSDvalue) {
1224             uint256 upfrontSaleUSDvalue = usdPrice - inSaleUSDvalue;
1225             startStep(currentStep + 1);
1226             inSale -= amount;
1227             if (upfrontSaleUSDvalue > inSaleUSDvalue)
1228                 require(false, "Please try with small amount.");
1229             inSaleUSDvalue -= upfrontSaleUSDvalue;
1230         } else if (usdPrice == inSaleUSDvalue && currentStep == 3) {
1231             amount = usdPrice / salePrice;
1232             inSale -= amount;
1233             inSaleUSDvalue -= usdPrice;
1234         } else {
1235             inSale -= amount;
1236             inSaleUSDvalue -= usdPrice;
1237         }
1238         userDeposits[_msgSender()] += (amount * (10**18));
1239         sendValue(payable(dAddress), ETHAmount);
1240         if (excess > 0) sendValue(payable(_msgSender()), excess);
1241 
1242         emit TokensBought(
1243             _msgSender(),
1244             amount,
1245             address(0),
1246             ETHAmount,
1247             block.timestamp
1248         );
1249     }
1250 
1251     function buyWithUSD(uint256 amount, uint256 purchaseToken)
1252         external
1253         checkSaleState(amount)
1254         whenNotPaused
1255     {
1256         uint256 usdPrice = calculatePrice(amount);
1257         require(!(usdPrice == 0 && currentStep == 3),"Presale it's over, sorry!");
1258         if (purchaseToken == 0 || purchaseToken == 1) usdPrice = usdPrice; //USDT and USDC have 6 decimals
1259 
1260         if (usdPrice > inSaleUSDvalue) {
1261             uint256 upfrontSaleUSDvalue = usdPrice - inSaleUSDvalue;
1262             startStep(currentStep + 1);
1263             inSale -= amount;
1264             inSaleUSDvalue -= upfrontSaleUSDvalue;
1265         } else if (usdPrice == inSaleUSDvalue && currentStep == 3) {
1266             amount = usdPrice / salePrice;
1267             inSale -= amount;
1268             inSaleUSDvalue -= usdPrice;
1269         } else {
1270             inSale -= amount;
1271             inSaleUSDvalue -= usdPrice;
1272         }
1273         userDeposits[_msgSender()] += (amount * (10**18));
1274         IERC20 tokenInterface;
1275         if (purchaseToken == 0) tokenInterface = IERC20(USDTtoken);
1276 
1277        uint256 ourAllowance = tokenInterface.allowance(
1278             _msgSender(),
1279           address(this)
1280         );
1281         require(usdPrice/(10**12) <= ourAllowance, "Make sure to add enough allowance");
1282 
1283         (bool success, ) = address(tokenInterface).call(
1284             abi.encodeWithSignature(
1285                 "transferFrom(address,address,uint256)",
1286                 _msgSender(),
1287                 dAddress,
1288                 usdPrice/(10**12)
1289                )
1290             );
1291 
1292         require(success, "Token payment failed");
1293 
1294         emit TokensBought(
1295             _msgSender(),
1296             amount,
1297             address(tokenInterface),
1298             usdPrice,
1299             block.timestamp
1300         );
1301     }
1302 
1303     function getETHAmount(uint256 amount)
1304         external
1305         view
1306         returns (uint256 ETHAmount)
1307     {
1308         uint256 usdPrice = calculatePrice(amount);
1309         ETHAmount = (usdPrice * (10**18)) / getETHLatestPrice();
1310     }
1311 
1312     function getTokenAmount(uint256 amount, uint256 purchaseToken)
1313         external
1314         view
1315         returns (uint256 usdPrice)
1316     {
1317         usdPrice = calculatePrice(amount);
1318         if (purchaseToken == 0 || purchaseToken == 1)
1319             usdPrice = usdPrice / (10**12); //USDT and USDC have 6 decimals
1320     }
1321 
1322     function startClaim(
1323         uint256 _claimStart,
1324         uint256 tokensAmount,
1325         address _saleToken
1326     ) external onlyOwner {
1327         require(
1328             _claimStart > endTime && _claimStart > block.timestamp,
1329             "Invalid claim start time"
1330         );
1331         require(_saleToken != address(0), "Zero token address");
1332         require(claimStart == 0, "Claim already set");
1333         claimStart = _claimStart;
1334         saleToken = _saleToken;
1335         IERC20(_saleToken).transferFrom(
1336             _msgSender(),
1337             address(this),
1338             tokensAmount
1339         );
1340     }
1341 
1342     function claim() external whenNotPaused {
1343         require(saleToken != address(0), "Sale token not added");
1344         require(block.timestamp >= claimStart, "Claim has not started yet");
1345         require(!hasClaimed[_msgSender()], "Already claimed");
1346         hasClaimed[_msgSender()] = true;
1347         uint256 amount = userDeposits[_msgSender()];
1348         require(amount > 0, "Nothing to claim");
1349         delete userDeposits[_msgSender()];
1350         IERC20(saleToken).transfer(_msgSender(), amount);
1351         emit TokensClaimed(_msgSender(), amount, block.timestamp);
1352     }
1353 
1354     function changeClaimStart(uint256 _claimStart) external onlyOwner {
1355         require(claimStart > 0, "Initial claim data not set");
1356         require(_claimStart > endTime, "Sale in progress");
1357         require(_claimStart > block.timestamp, "Claim start in past");
1358         claimStart = _claimStart;
1359     }
1360 
1361     function changeSaleTimes(uint256 _startTime, uint256 _endTime)
1362         external
1363         onlyOwner
1364     {
1365         require(_startTime > 0 || _endTime > 0, "Invalid parameters");
1366 
1367         if (_startTime > 0) {
1368             require(block.timestamp < _startTime, "Sale time in past");
1369             startTime = _startTime;
1370         }
1371 
1372         if (_endTime > 0) {
1373             require(_endTime > startTime, "Invalid endTime");
1374             endTime = _endTime;
1375         }
1376     }
1377 
1378     function setDaddress(address _dAddress) external onlyOwner  {
1379         dAddress = _dAddress;
1380     }
1381 
1382     function changehardcapSize(uint256 _hardcapSize) external onlyOwner  {
1383         require(
1384             _hardcapSize > 0 && _hardcapSize != hardcapSize,
1385             "Invalid hardcapSize size"
1386         );
1387         hardcapSize = _hardcapSize;
1388     }
1389 
1390     function changeMinimumBuyAmount(uint256 _amount) external onlyOwner  {
1391         require(_amount > 0 && _amount != minimumBuyAmount, "Invalid amount");
1392         minimumBuyAmount = _amount;
1393     }
1394 
1395     function withdrawTokens(address token, uint256 amount) external onlyOwner   {
1396         IERC20(token).transfer(dAddress, amount);
1397     }
1398 
1399     function withdrawETHs() external onlyOwner  {
1400         (bool success, ) = payable(dAddress).call{value: address(this).balance}("");
1401         require(success, "Failed to withdraw");
1402     }
1403 
1404 
1405 }