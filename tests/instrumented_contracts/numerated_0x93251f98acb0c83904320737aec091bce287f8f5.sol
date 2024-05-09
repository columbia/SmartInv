1 /**
2  *Submitted for verification at polygonscan.com on 2022-10-10
3 */
4 
5 // SPDX-License-Identifier: GPL-3.0-or-later
6 // Sources flattened with hardhat v2.11.2 https://hardhat.org
7 
8 // File contracts/access/PausableControl.sol
9 
10 
11 pragma solidity ^0.8.10;
12 
13 abstract contract PausableControl {
14     mapping(bytes32 => bool) private _pausedRoles;
15 
16     bytes32 public constant PAUSE_ALL_ROLE = 0x00;
17 
18     event Paused(bytes32 role);
19     event Unpaused(bytes32 role);
20 
21     modifier whenNotPaused(bytes32 role) {
22         require(
23             !paused(role) && !paused(PAUSE_ALL_ROLE),
24             "PausableControl: paused"
25         );
26         _;
27     }
28 
29     modifier whenPaused(bytes32 role) {
30         require(
31             paused(role) || paused(PAUSE_ALL_ROLE),
32             "PausableControl: not paused"
33         );
34         _;
35     }
36 
37     function paused(bytes32 role) public view virtual returns (bool) {
38         return _pausedRoles[role];
39     }
40 
41     function _pause(bytes32 role) internal virtual whenNotPaused(role) {
42         _pausedRoles[role] = true;
43         emit Paused(role);
44     }
45 
46     function _unpause(bytes32 role) internal virtual whenPaused(role) {
47         _pausedRoles[role] = false;
48         emit Unpaused(role);
49     }
50 }
51 
52 
53 // File contracts/access/MPCManageable.sol
54 
55 
56 pragma solidity ^0.8.10;
57 
58 abstract contract MPCManageable {
59     address public mpc;
60     address public pendingMPC;
61 
62     uint256 public constant delay = 2 days;
63     uint256 public delayMPC;
64 
65     modifier onlyMPC() {
66         require(msg.sender == mpc, "MPC: only mpc");
67         _;
68     }
69 
70     event LogChangeMPC(
71         address indexed oldMPC,
72         address indexed newMPC,
73         uint256 effectiveTime
74     );
75     event LogApplyMPC(
76         address indexed oldMPC,
77         address indexed newMPC,
78         uint256 applyTime
79     );
80 
81     constructor(address _mpc) {
82         require(_mpc != address(0), "MPC: mpc is the zero address");
83         mpc = _mpc;
84         emit LogChangeMPC(address(0), mpc, block.timestamp);
85     }
86 
87     function changeMPC(address _mpc) external onlyMPC {
88         require(_mpc != address(0), "MPC: mpc is the zero address");
89         pendingMPC = _mpc;
90         delayMPC = block.timestamp + delay;
91         emit LogChangeMPC(mpc, pendingMPC, delayMPC);
92     }
93 
94     // only the `pendingMPC` can `apply`
95     // except when `pendingMPC` is a contract, then `mpc` can also `apply`
96     // in case `pendingMPC` has no `apply` wrapper method and cannot `apply`
97     function applyMPC() external {
98         require(
99             msg.sender == pendingMPC ||
100                 (msg.sender == mpc && address(pendingMPC).code.length > 0),
101             "MPC: only pending mpc"
102         );
103         require(
104             delayMPC > 0 && block.timestamp >= delayMPC,
105             "MPC: time before delayMPC"
106         );
107         emit LogApplyMPC(mpc, pendingMPC, block.timestamp);
108         mpc = pendingMPC;
109         pendingMPC = address(0);
110         delayMPC = 0;
111     }
112 }
113 
114 
115 // File contracts/access/MPCAdminControl.sol
116 
117 
118 pragma solidity ^0.8.10;
119 
120 abstract contract MPCAdminControl is MPCManageable {
121     address public admin;
122 
123     event ChangeAdmin(address indexed _old, address indexed _new);
124 
125     constructor(address _admin, address _mpc) MPCManageable(_mpc) {
126         admin = _admin;
127         emit ChangeAdmin(address(0), _admin);
128     }
129 
130     modifier onlyAdmin() {
131         require(msg.sender == admin, "MPCAdminControl: not admin");
132         _;
133     }
134 
135     function changeAdmin(address _admin) external onlyMPC {
136         emit ChangeAdmin(admin, _admin);
137         admin = _admin;
138     }
139 }
140 
141 
142 // File contracts/access/MPCAdminPausableControl.sol
143 
144 
145 pragma solidity ^0.8.10;
146 
147 
148 abstract contract MPCAdminPausableControl is MPCAdminControl, PausableControl {
149     constructor(address _admin, address _mpc) MPCAdminControl(_admin, _mpc) {}
150 
151     function pause(bytes32 role) external onlyAdmin {
152         _pause(role);
153     }
154 
155     function unpause(bytes32 role) external onlyAdmin {
156         _unpause(role);
157     }
158 }
159 
160 
161 // File contracts/router/interfaces/IAnycallExecutor.sol
162 
163 pragma solidity ^0.8.6;
164 
165 /// IAnycallExecutor interface of the anycall executor
166 /// Note: `_receiver` is the `fallback receive address` when exec failed.
167 interface IAnycallExecutor {
168     function execute(
169         address _anycallProxy,
170         address _token,
171         address _receiver,
172         uint256 _amount,
173         bytes calldata _data
174     ) external returns (bool success, bytes memory result);
175 }
176 
177 
178 // File contracts/router/interfaces/SwapInfo.sol
179 
180 pragma solidity ^0.8.6;
181 
182 struct SwapInfo {
183     bytes32 swapoutID;
184     address token;
185     address receiver;
186     uint256 amount;
187     uint256 fromChainID;
188 }
189 
190 
191 // File contracts/router/interfaces/IRouterSecurity.sol
192 
193 pragma solidity ^0.8.10;
194 
195 interface IRouterSecurity {
196     function registerSwapin(string calldata swapID, SwapInfo calldata swapInfo)
197         external;
198 
199     function registerSwapout(
200         address token,
201         address from,
202         string calldata to,
203         uint256 amount,
204         uint256 toChainID,
205         string calldata anycallProxy,
206         bytes calldata data
207     ) external returns (bytes32 swapoutID);
208 
209     function isSwapCompleted(
210         string calldata swapID,
211         bytes32 swapoutID,
212         uint256 fromChainID
213     ) external view returns (bool);
214 }
215 
216 
217 // File contracts/router/interfaces/IRetrySwapinAndExec.sol
218 
219 pragma solidity ^0.8.10;
220 
221 interface IRetrySwapinAndExec {
222     function retrySwapinAndExec(
223         string calldata swapID,
224         SwapInfo calldata swapInfo,
225         address anycallProxy,
226         bytes calldata data,
227         bool dontExec
228     ) external;
229 }
230 
231 
232 // File contracts/router/interfaces/IUnderlying.sol
233 
234 
235 pragma solidity ^0.8.10;
236 
237 interface IUnderlying {
238     function underlying() external view returns (address);
239 
240     function deposit(uint256 amount, address to) external returns (uint256);
241 
242     function withdraw(uint256 amount, address to) external returns (uint256);
243 }
244 
245 
246 // File contracts/router/interfaces/IAnyswapERC20Auth.sol
247 
248 pragma solidity ^0.8.10;
249 
250 interface IAnyswapERC20Auth {
251     function changeVault(address newVault) external returns (bool);
252 }
253 
254 
255 // File contracts/router/interfaces/IwNATIVE.sol
256 
257 pragma solidity ^0.8.10;
258 
259 interface IwNATIVE {
260     function deposit() external payable;
261 
262     function withdraw(uint256) external;
263 }
264 
265 
266 // File contracts/router/interfaces/IRouterMintBurn.sol
267 
268 pragma solidity ^0.8.10;
269 
270 interface IRouterMintBurn {
271     function mint(address to, uint256 amount) external returns (bool);
272 
273     function burn(address from, uint256 amount) external returns (bool);
274 }
275 
276 
277 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.7.3
278 
279 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
280 
281 pragma solidity ^0.8.0;
282 
283 /**
284  * @dev Contract module that helps prevent reentrant calls to a function.
285  *
286  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
287  * available, which can be applied to functions to make sure there are no nested
288  * (reentrant) calls to them.
289  *
290  * Note that because there is a single `nonReentrant` guard, functions marked as
291  * `nonReentrant` may not call one another. This can be worked around by making
292  * those functions `private`, and then adding `external` `nonReentrant` entry
293  * points to them.
294  *
295  * TIP: If you would like to learn more about reentrancy and alternative ways
296  * to protect against it, check out our blog post
297  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
298  */
299 abstract contract ReentrancyGuard {
300     // Booleans are more expensive than uint256 or any type that takes up a full
301     // word because each write operation emits an extra SLOAD to first read the
302     // slot's contents, replace the bits taken up by the boolean, and then write
303     // back. This is the compiler's defense against contract upgrades and
304     // pointer aliasing, and it cannot be disabled.
305 
306     // The values being non-zero value makes deployment a bit more expensive,
307     // but in exchange the refund on every call to nonReentrant will be lower in
308     // amount. Since refunds are capped to a percentage of the total
309     // transaction's gas, it is best to keep them low in cases like this one, to
310     // increase the likelihood of the full refund coming into effect.
311     uint256 private constant _NOT_ENTERED = 1;
312     uint256 private constant _ENTERED = 2;
313 
314     uint256 private _status;
315 
316     constructor() {
317         _status = _NOT_ENTERED;
318     }
319 
320     /**
321      * @dev Prevents a contract from calling itself, directly or indirectly.
322      * Calling a `nonReentrant` function from another `nonReentrant`
323      * function is not supported. It is possible to prevent this from happening
324      * by making the `nonReentrant` function external, and making it call a
325      * `private` function that does the actual work.
326      */
327     modifier nonReentrant() {
328         // On the first call to nonReentrant, _notEntered will be true
329         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
330 
331         // Any calls to nonReentrant after this point will fail
332         _status = _ENTERED;
333 
334         _;
335 
336         // By storing the original value once again, a refund is triggered (see
337         // https://eips.ethereum.org/EIPS/eip-2200)
338         _status = _NOT_ENTERED;
339     }
340 }
341 
342 
343 // File @openzeppelin/contracts/utils/Address.sol@v4.7.3
344 
345 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
346 
347 pragma solidity ^0.8.1;
348 
349 /**
350  * @dev Collection of functions related to the address type
351  */
352 library Address {
353     /**
354      * @dev Returns true if `account` is a contract.
355      *
356      * [IMPORTANT]
357      * ====
358      * It is unsafe to assume that an address for which this function returns
359      * false is an externally-owned account (EOA) and not a contract.
360      *
361      * Among others, `isContract` will return false for the following
362      * types of addresses:
363      *
364      *  - an externally-owned account
365      *  - a contract in construction
366      *  - an address where a contract will be created
367      *  - an address where a contract lived, but was destroyed
368      * ====
369      *
370      * [IMPORTANT]
371      * ====
372      * You shouldn't rely on `isContract` to protect against flash loan attacks!
373      *
374      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
375      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
376      * constructor.
377      * ====
378      */
379     function isContract(address account) internal view returns (bool) {
380         // This method relies on extcodesize/address.code.length, which returns 0
381         // for contracts in construction, since the code is only stored at the end
382         // of the constructor execution.
383 
384         return account.code.length > 0;
385     }
386 
387     /**
388      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
389      * `recipient`, forwarding all available gas and reverting on errors.
390      *
391      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
392      * of certain opcodes, possibly making contracts go over the 2300 gas limit
393      * imposed by `transfer`, making them unable to receive funds via
394      * `transfer`. {sendValue} removes this limitation.
395      *
396      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
397      *
398      * IMPORTANT: because control is transferred to `recipient`, care must be
399      * taken to not create reentrancy vulnerabilities. Consider using
400      * {ReentrancyGuard} or the
401      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
402      */
403     function sendValue(address payable recipient, uint256 amount) internal {
404         require(address(this).balance >= amount, "Address: insufficient balance");
405 
406         (bool success, ) = recipient.call{value: amount}("");
407         require(success, "Address: unable to send value, recipient may have reverted");
408     }
409 
410     /**
411      * @dev Performs a Solidity function call using a low level `call`. A
412      * plain `call` is an unsafe replacement for a function call: use this
413      * function instead.
414      *
415      * If `target` reverts with a revert reason, it is bubbled up by this
416      * function (like regular Solidity function calls).
417      *
418      * Returns the raw returned data. To convert to the expected return value,
419      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
420      *
421      * Requirements:
422      *
423      * - `target` must be a contract.
424      * - calling `target` with `data` must not revert.
425      *
426      * _Available since v3.1._
427      */
428     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
429         return functionCall(target, data, "Address: low-level call failed");
430     }
431 
432     /**
433      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
434      * `errorMessage` as a fallback revert reason when `target` reverts.
435      *
436      * _Available since v3.1._
437      */
438     function functionCall(
439         address target,
440         bytes memory data,
441         string memory errorMessage
442     ) internal returns (bytes memory) {
443         return functionCallWithValue(target, data, 0, errorMessage);
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
448      * but also transferring `value` wei to `target`.
449      *
450      * Requirements:
451      *
452      * - the calling contract must have an ETH balance of at least `value`.
453      * - the called Solidity function must be `payable`.
454      *
455      * _Available since v3.1._
456      */
457     function functionCallWithValue(
458         address target,
459         bytes memory data,
460         uint256 value
461     ) internal returns (bytes memory) {
462         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
463     }
464 
465     /**
466      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
467      * with `errorMessage` as a fallback revert reason when `target` reverts.
468      *
469      * _Available since v3.1._
470      */
471     function functionCallWithValue(
472         address target,
473         bytes memory data,
474         uint256 value,
475         string memory errorMessage
476     ) internal returns (bytes memory) {
477         require(address(this).balance >= value, "Address: insufficient balance for call");
478         require(isContract(target), "Address: call to non-contract");
479 
480         (bool success, bytes memory returndata) = target.call{value: value}(data);
481         return verifyCallResult(success, returndata, errorMessage);
482     }
483 
484     /**
485      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
486      * but performing a static call.
487      *
488      * _Available since v3.3._
489      */
490     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
491         return functionStaticCall(target, data, "Address: low-level static call failed");
492     }
493 
494     /**
495      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
496      * but performing a static call.
497      *
498      * _Available since v3.3._
499      */
500     function functionStaticCall(
501         address target,
502         bytes memory data,
503         string memory errorMessage
504     ) internal view returns (bytes memory) {
505         require(isContract(target), "Address: static call to non-contract");
506 
507         (bool success, bytes memory returndata) = target.staticcall(data);
508         return verifyCallResult(success, returndata, errorMessage);
509     }
510 
511     /**
512      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
513      * but performing a delegate call.
514      *
515      * _Available since v3.4._
516      */
517     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
518         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
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
555                 /// @solidity memory-safe-assembly
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
567 
568 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.7.3
569 
570 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
571 
572 pragma solidity ^0.8.0;
573 
574 /**
575  * @dev Interface of the ERC20 standard as defined in the EIP.
576  */
577 interface IERC20 {
578     /**
579      * @dev Emitted when `value` tokens are moved from one account (`from`) to
580      * another (`to`).
581      *
582      * Note that `value` may be zero.
583      */
584     event Transfer(address indexed from, address indexed to, uint256 value);
585 
586     /**
587      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
588      * a call to {approve}. `value` is the new allowance.
589      */
590     event Approval(address indexed owner, address indexed spender, uint256 value);
591 
592     /**
593      * @dev Returns the amount of tokens in existence.
594      */
595     function totalSupply() external view returns (uint256);
596 
597     /**
598      * @dev Returns the amount of tokens owned by `account`.
599      */
600     function balanceOf(address account) external view returns (uint256);
601 
602     /**
603      * @dev Moves `amount` tokens from the caller's account to `to`.
604      *
605      * Returns a boolean value indicating whether the operation succeeded.
606      *
607      * Emits a {Transfer} event.
608      */
609     function transfer(address to, uint256 amount) external returns (bool);
610 
611     /**
612      * @dev Returns the remaining number of tokens that `spender` will be
613      * allowed to spend on behalf of `owner` through {transferFrom}. This is
614      * zero by default.
615      *
616      * This value changes when {approve} or {transferFrom} are called.
617      */
618     function allowance(address owner, address spender) external view returns (uint256);
619 
620     /**
621      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
622      *
623      * Returns a boolean value indicating whether the operation succeeded.
624      *
625      * IMPORTANT: Beware that changing an allowance with this method brings the risk
626      * that someone may use both the old and the new allowance by unfortunate
627      * transaction ordering. One possible solution to mitigate this race
628      * condition is to first reduce the spender's allowance to 0 and set the
629      * desired value afterwards:
630      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
631      *
632      * Emits an {Approval} event.
633      */
634     function approve(address spender, uint256 amount) external returns (bool);
635 
636     /**
637      * @dev Moves `amount` tokens from `from` to `to` using the
638      * allowance mechanism. `amount` is then deducted from the caller's
639      * allowance.
640      *
641      * Returns a boolean value indicating whether the operation succeeded.
642      *
643      * Emits a {Transfer} event.
644      */
645     function transferFrom(
646         address from,
647         address to,
648         uint256 amount
649     ) external returns (bool);
650 }
651 
652 
653 // File @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol@v4.7.3
654 
655 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
656 
657 pragma solidity ^0.8.0;
658 
659 /**
660  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
661  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
662  *
663  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
664  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
665  * need to send a transaction, and thus is not required to hold Ether at all.
666  */
667 interface IERC20Permit {
668     /**
669      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
670      * given ``owner``'s signed approval.
671      *
672      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
673      * ordering also apply here.
674      *
675      * Emits an {Approval} event.
676      *
677      * Requirements:
678      *
679      * - `spender` cannot be the zero address.
680      * - `deadline` must be a timestamp in the future.
681      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
682      * over the EIP712-formatted function arguments.
683      * - the signature must use ``owner``'s current nonce (see {nonces}).
684      *
685      * For more information on the signature format, see the
686      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
687      * section].
688      */
689     function permit(
690         address owner,
691         address spender,
692         uint256 value,
693         uint256 deadline,
694         uint8 v,
695         bytes32 r,
696         bytes32 s
697     ) external;
698 
699     /**
700      * @dev Returns the current nonce for `owner`. This value must be
701      * included whenever a signature is generated for {permit}.
702      *
703      * Every successful call to {permit} increases ``owner``'s nonce by one. This
704      * prevents a signature from being used multiple times.
705      */
706     function nonces(address owner) external view returns (uint256);
707 
708     /**
709      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
710      */
711     // solhint-disable-next-line func-name-mixedcase
712     function DOMAIN_SEPARATOR() external view returns (bytes32);
713 }
714 
715 
716 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.7.3
717 
718 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/utils/SafeERC20.sol)
719 
720 pragma solidity ^0.8.0;
721 
722 
723 
724 /**
725  * @title SafeERC20
726  * @dev Wrappers around ERC20 operations that throw on failure (when the token
727  * contract returns false). Tokens that return no value (and instead revert or
728  * throw on failure) are also supported, non-reverting calls are assumed to be
729  * successful.
730  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
731  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
732  */
733 library SafeERC20 {
734     using Address for address;
735 
736     function safeTransfer(
737         IERC20 token,
738         address to,
739         uint256 value
740     ) internal {
741         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
742     }
743 
744     function safeTransferFrom(
745         IERC20 token,
746         address from,
747         address to,
748         uint256 value
749     ) internal {
750         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
751     }
752 
753     /**
754      * @dev Deprecated. This function has issues similar to the ones found in
755      * {IERC20-approve}, and its usage is discouraged.
756      *
757      * Whenever possible, use {safeIncreaseAllowance} and
758      * {safeDecreaseAllowance} instead.
759      */
760     function safeApprove(
761         IERC20 token,
762         address spender,
763         uint256 value
764     ) internal {
765         // safeApprove should only be called when setting an initial allowance,
766         // or when resetting it to zero. To increase and decrease it, use
767         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
768         require(
769             (value == 0) || (token.allowance(address(this), spender) == 0),
770             "SafeERC20: approve from non-zero to non-zero allowance"
771         );
772         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
773     }
774 
775     function safeIncreaseAllowance(
776         IERC20 token,
777         address spender,
778         uint256 value
779     ) internal {
780         uint256 newAllowance = token.allowance(address(this), spender) + value;
781         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
782     }
783 
784     function safeDecreaseAllowance(
785         IERC20 token,
786         address spender,
787         uint256 value
788     ) internal {
789         unchecked {
790             uint256 oldAllowance = token.allowance(address(this), spender);
791             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
792             uint256 newAllowance = oldAllowance - value;
793             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
794         }
795     }
796 
797     function safePermit(
798         IERC20Permit token,
799         address owner,
800         address spender,
801         uint256 value,
802         uint256 deadline,
803         uint8 v,
804         bytes32 r,
805         bytes32 s
806     ) internal {
807         uint256 nonceBefore = token.nonces(owner);
808         token.permit(owner, spender, value, deadline, v, r, s);
809         uint256 nonceAfter = token.nonces(owner);
810         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
811     }
812 
813     /**
814      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
815      * on the return value: the return value is optional (but if data is returned, it must not be false).
816      * @param token The token targeted by the call.
817      * @param data The call data (encoded using abi.encode or one of its variants).
818      */
819     function _callOptionalReturn(IERC20 token, bytes memory data) private {
820         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
821         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
822         // the target address contains contract code and also asserts for success in the low-level call.
823 
824         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
825         if (returndata.length > 0) {
826             // Return data is optional
827             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
828         }
829     }
830 }
831 
832 
833 // File contracts/router/MultichainV7Router.sol
834 
835 
836 pragma solidity ^0.8.10;
837 
838 
839 
840 
841 
842 
843 
844 
845 
846 
847 contract MultichainV7Router is
848     MPCAdminPausableControl,
849     ReentrancyGuard,
850     IRetrySwapinAndExec
851 {
852     using Address for address;
853     using SafeERC20 for IERC20;
854 
855     bytes32 public constant Swapin_Paused_ROLE =
856         keccak256("Swapin_Paused_ROLE");
857     bytes32 public constant Swapout_Paused_ROLE =
858         keccak256("Swapout_Paused_ROLE");
859     bytes32 public constant Call_Paused_ROLE = keccak256("Call_Paused_ROLE");
860     bytes32 public constant Exec_Paused_ROLE = keccak256("Exec_Paused_ROLE");
861     bytes32 public constant Retry_Paused_ROLE = keccak256("Retry_Paused_ROLE");
862 
863     address public immutable wNATIVE;
864     address public immutable anycallExecutor;
865 
866     address public routerSecurity;
867 
868     struct ProxyInfo {
869         bool supported;
870         bool acceptAnyToken;
871     }
872 
873     mapping(address => ProxyInfo) public anycallProxyInfo;
874     mapping(bytes32 => bytes32) public retryRecords; // retryHash -> dataHash
875 
876     event LogAnySwapIn(
877         string swapID,
878         bytes32 indexed swapoutID,
879         address indexed token,
880         address indexed receiver,
881         uint256 amount,
882         uint256 fromChainID
883     );
884     event LogAnySwapOut(
885         bytes32 indexed swapoutID,
886         address indexed token,
887         address indexed from,
888         string receiver,
889         uint256 amount,
890         uint256 toChainID
891     );
892 
893     event LogAnySwapInAndExec(
894         string swapID,
895         bytes32 indexed swapoutID,
896         address indexed token,
897         address indexed receiver,
898         uint256 amount,
899         uint256 fromChainID,
900         bool success,
901         bytes result
902     );
903     event LogAnySwapOutAndCall(
904         bytes32 indexed swapoutID,
905         address indexed token,
906         address indexed from,
907         string receiver,
908         uint256 amount,
909         uint256 toChainID,
910         string anycallProxy,
911         bytes data
912     );
913 
914     event LogRetryExecRecord(
915         string swapID,
916         bytes32 swapoutID,
917         address token,
918         address receiver,
919         uint256 amount,
920         uint256 fromChainID,
921         address anycallProxy,
922         bytes data
923     );
924     event LogRetrySwapInAndExec(
925         string swapID,
926         bytes32 swapoutID,
927         address token,
928         address receiver,
929         uint256 amount,
930         uint256 fromChainID,
931         bool dontExec,
932         bool success,
933         bytes result
934     );
935 
936     constructor(
937         address _admin,
938         address _mpc,
939         address _wNATIVE,
940         address _anycallExecutor,
941         address _routerSecurity
942     ) MPCAdminPausableControl(_admin, _mpc) {
943         require(_anycallExecutor != address(0), "zero anycall executor");
944         anycallExecutor = _anycallExecutor;
945         wNATIVE = _wNATIVE;
946         routerSecurity = _routerSecurity;
947     }
948 
949     receive() external payable {
950         assert(msg.sender == wNATIVE); // only accept Native via fallback from the wNative contract
951     }
952 
953     function setRouterSecurity(address _routerSecurity)
954         external
955         nonReentrant
956         onlyMPC
957     {
958         routerSecurity = _routerSecurity;
959     }
960 
961     function changeVault(address token, address newVault)
962         external
963         nonReentrant
964         onlyMPC
965         returns (bool)
966     {
967         return IAnyswapERC20Auth(token).changeVault(newVault);
968     }
969 
970     function addAnycallProxies(
971         address[] calldata proxies,
972         bool[] calldata acceptAnyTokenFlags
973     ) external nonReentrant onlyAdmin {
974         uint256 length = proxies.length;
975         require(length == acceptAnyTokenFlags.length, "length mismatch");
976         for (uint256 i = 0; i < length; i++) {
977             anycallProxyInfo[proxies[i]] = ProxyInfo(
978                 true,
979                 acceptAnyTokenFlags[i]
980             );
981         }
982     }
983 
984     function removeAnycallProxies(address[] calldata proxies)
985         external
986         nonReentrant
987         onlyAdmin
988     {
989         for (uint256 i = 0; i < proxies.length; i++) {
990             delete anycallProxyInfo[proxies[i]];
991         }
992     }
993 
994     // Swaps `amount` `token` from this chain to `toChainID` chain with recipient `to`
995     function anySwapOut(
996         address token,
997         string calldata to,
998         uint256 amount,
999         uint256 toChainID
1000     ) external whenNotPaused(Swapout_Paused_ROLE) nonReentrant {
1001         bytes32 swapoutID = IRouterSecurity(routerSecurity).registerSwapout(
1002             token,
1003             msg.sender,
1004             to,
1005             amount,
1006             toChainID,
1007             "",
1008             ""
1009         );
1010         assert(IRouterMintBurn(token).burn(msg.sender, amount));
1011         emit LogAnySwapOut(swapoutID, token, msg.sender, to, amount, toChainID);
1012     }
1013 
1014     // Swaps `amount` `token` from this chain to `toChainID` chain and call anycall proxy with `data`
1015     // `to` is the fallback receive address when exec failed on the `destination` chain
1016     function anySwapOutAndCall(
1017         address token,
1018         string calldata to,
1019         uint256 amount,
1020         uint256 toChainID,
1021         string calldata anycallProxy,
1022         bytes calldata data
1023     )
1024         external
1025         whenNotPaused(Swapout_Paused_ROLE)
1026         whenNotPaused(Call_Paused_ROLE)
1027         nonReentrant
1028     {
1029         require(data.length > 0, "empty call data");
1030         bytes32 swapoutID = IRouterSecurity(routerSecurity).registerSwapout(
1031             token,
1032             msg.sender,
1033             to,
1034             amount,
1035             toChainID,
1036             anycallProxy,
1037             data
1038         );
1039         assert(IRouterMintBurn(token).burn(msg.sender, amount));
1040         emit LogAnySwapOutAndCall(
1041             swapoutID,
1042             token,
1043             msg.sender,
1044             to,
1045             amount,
1046             toChainID,
1047             anycallProxy,
1048             data
1049         );
1050     }
1051 
1052     function _anySwapOutUnderlying(address token, uint256 amount)
1053         internal
1054         whenNotPaused(Swapout_Paused_ROLE)
1055         returns (uint256)
1056     {
1057         address _underlying = IUnderlying(token).underlying();
1058         require(_underlying != address(0), "MultichainRouter: zero underlying");
1059         uint256 old_balance = IERC20(_underlying).balanceOf(token);
1060         IERC20(_underlying).safeTransferFrom(msg.sender, token, amount);
1061         uint256 new_balance = IERC20(_underlying).balanceOf(token);
1062         require(
1063             new_balance >= old_balance && new_balance <= old_balance + amount
1064         );
1065         return new_balance - old_balance;
1066     }
1067 
1068     // Swaps `amount` `token` from this chain to `toChainID` chain with recipient `to` by minting with `underlying`
1069     function anySwapOutUnderlying(
1070         address token,
1071         string calldata to,
1072         uint256 amount,
1073         uint256 toChainID
1074     ) external nonReentrant {
1075         uint256 recvAmount = _anySwapOutUnderlying(token, amount);
1076         bytes32 swapoutID = IRouterSecurity(routerSecurity).registerSwapout(
1077             token,
1078             msg.sender,
1079             to,
1080             recvAmount,
1081             toChainID,
1082             "",
1083             ""
1084         );
1085         emit LogAnySwapOut(
1086             swapoutID,
1087             token,
1088             msg.sender,
1089             to,
1090             recvAmount,
1091             toChainID
1092         );
1093     }
1094 
1095     // Swaps `amount` `token` from this chain to `toChainID` chain and call anycall proxy with `data`
1096     // `to` is the fallback receive address when exec failed on the `destination` chain
1097     function anySwapOutUnderlyingAndCall(
1098         address token,
1099         string calldata to,
1100         uint256 amount,
1101         uint256 toChainID,
1102         string calldata anycallProxy,
1103         bytes calldata data
1104     ) external whenNotPaused(Call_Paused_ROLE) nonReentrant {
1105         require(data.length > 0, "empty call data");
1106         uint256 recvAmount = _anySwapOutUnderlying(token, amount);
1107         bytes32 swapoutID = IRouterSecurity(routerSecurity).registerSwapout(
1108             token,
1109             msg.sender,
1110             to,
1111             recvAmount,
1112             toChainID,
1113             anycallProxy,
1114             data
1115         );
1116         emit LogAnySwapOutAndCall(
1117             swapoutID,
1118             token,
1119             msg.sender,
1120             to,
1121             recvAmount,
1122             toChainID,
1123             anycallProxy,
1124             data
1125         );
1126     }
1127 
1128     function _anySwapOutNative(address token)
1129         internal
1130         whenNotPaused(Swapout_Paused_ROLE)
1131         returns (uint256)
1132     {
1133         require(wNATIVE != address(0), "MultichainRouter: zero wNATIVE");
1134         require(
1135             IUnderlying(token).underlying() == wNATIVE,
1136             "MultichainRouter: underlying is not wNATIVE"
1137         );
1138         uint256 old_balance = IERC20(wNATIVE).balanceOf(token);
1139         IwNATIVE(wNATIVE).deposit{value: msg.value}();
1140         IERC20(wNATIVE).safeTransfer(token, msg.value);
1141         uint256 new_balance = IERC20(wNATIVE).balanceOf(token);
1142         require(
1143             new_balance >= old_balance && new_balance <= old_balance + msg.value
1144         );
1145         return new_balance - old_balance;
1146     }
1147 
1148     // Swaps `msg.value` `Native` from this chain to `toChainID` chain with recipient `to`
1149     function anySwapOutNative(
1150         address token,
1151         string calldata to,
1152         uint256 toChainID
1153     ) external payable nonReentrant {
1154         uint256 recvAmount = _anySwapOutNative(token);
1155         bytes32 swapoutID = IRouterSecurity(routerSecurity).registerSwapout(
1156             token,
1157             msg.sender,
1158             to,
1159             recvAmount,
1160             toChainID,
1161             "",
1162             ""
1163         );
1164         emit LogAnySwapOut(
1165             swapoutID,
1166             token,
1167             msg.sender,
1168             to,
1169             recvAmount,
1170             toChainID
1171         );
1172     }
1173 
1174     // Swaps `msg.value` `Native` from this chain to `toChainID` chain and call anycall proxy with `data`
1175     // `to` is the fallback receive address when exec failed on the `destination` chain
1176     function anySwapOutNativeAndCall(
1177         address token,
1178         string calldata to,
1179         uint256 toChainID,
1180         string calldata anycallProxy,
1181         bytes calldata data
1182     ) external payable whenNotPaused(Call_Paused_ROLE) nonReentrant {
1183         require(data.length > 0, "empty call data");
1184         uint256 recvAmount = _anySwapOutNative(token);
1185         bytes32 swapoutID = IRouterSecurity(routerSecurity).registerSwapout(
1186             token,
1187             msg.sender,
1188             to,
1189             recvAmount,
1190             toChainID,
1191             anycallProxy,
1192             data
1193         );
1194         emit LogAnySwapOutAndCall(
1195             swapoutID,
1196             token,
1197             msg.sender,
1198             to,
1199             recvAmount,
1200             toChainID,
1201             anycallProxy,
1202             data
1203         );
1204     }
1205 
1206     // Swaps `amount` `token` in `fromChainID` to `to` on this chainID
1207     function anySwapIn(string calldata swapID, SwapInfo calldata swapInfo)
1208         external
1209         whenNotPaused(Swapin_Paused_ROLE)
1210         nonReentrant
1211         onlyMPC
1212     {
1213         IRouterSecurity(routerSecurity).registerSwapin(swapID, swapInfo);
1214         assert(
1215             IRouterMintBurn(swapInfo.token).mint(
1216                 swapInfo.receiver,
1217                 swapInfo.amount
1218             )
1219         );
1220         emit LogAnySwapIn(
1221             swapID,
1222             swapInfo.swapoutID,
1223             swapInfo.token,
1224             swapInfo.receiver,
1225             swapInfo.amount,
1226             swapInfo.fromChainID
1227         );
1228     }
1229 
1230     // Swaps `amount` `token` in `fromChainID` to `to` on this chainID with `to` receiving `underlying`
1231     function anySwapInUnderlying(
1232         string calldata swapID,
1233         SwapInfo calldata swapInfo
1234     ) external whenNotPaused(Swapin_Paused_ROLE) nonReentrant onlyMPC {
1235         require(
1236             IUnderlying(swapInfo.token).underlying() != address(0),
1237             "MultichainRouter: zero underlying"
1238         );
1239         IRouterSecurity(routerSecurity).registerSwapin(swapID, swapInfo);
1240         assert(
1241             IRouterMintBurn(swapInfo.token).mint(address(this), swapInfo.amount)
1242         );
1243         IUnderlying(swapInfo.token).withdraw(
1244             swapInfo.amount,
1245             swapInfo.receiver
1246         );
1247         emit LogAnySwapIn(
1248             swapID,
1249             swapInfo.swapoutID,
1250             swapInfo.token,
1251             swapInfo.receiver,
1252             swapInfo.amount,
1253             swapInfo.fromChainID
1254         );
1255     }
1256 
1257     // Swaps `amount` `token` in `fromChainID` to `to` on this chainID with `to` receiving `Native`
1258     function anySwapInNative(string calldata swapID, SwapInfo calldata swapInfo)
1259         external
1260         whenNotPaused(Swapin_Paused_ROLE)
1261         nonReentrant
1262         onlyMPC
1263     {
1264         require(wNATIVE != address(0), "MultichainRouter: zero wNATIVE");
1265         require(
1266             IUnderlying(swapInfo.token).underlying() == wNATIVE,
1267             "MultichainRouter: underlying is not wNATIVE"
1268         );
1269         IRouterSecurity(routerSecurity).registerSwapin(swapID, swapInfo);
1270         assert(
1271             IRouterMintBurn(swapInfo.token).mint(address(this), swapInfo.amount)
1272         );
1273         IUnderlying(swapInfo.token).withdraw(swapInfo.amount, address(this));
1274         IwNATIVE(wNATIVE).withdraw(swapInfo.amount);
1275         Address.sendValue(payable(swapInfo.receiver), swapInfo.amount);
1276         emit LogAnySwapIn(
1277             swapID,
1278             swapInfo.swapoutID,
1279             swapInfo.token,
1280             swapInfo.receiver,
1281             swapInfo.amount,
1282             swapInfo.fromChainID
1283         );
1284     }
1285 
1286     // Swaps `amount` `token` in `fromChainID` to `to` on this chainID with `to` receiving `underlying` or `Native` if possible
1287     function anySwapInAuto(string calldata swapID, SwapInfo calldata swapInfo)
1288         external
1289         whenNotPaused(Swapin_Paused_ROLE)
1290         nonReentrant
1291         onlyMPC
1292     {
1293         IRouterSecurity(routerSecurity).registerSwapin(swapID, swapInfo);
1294         address _underlying = IUnderlying(swapInfo.token).underlying();
1295         if (
1296             _underlying != address(0) &&
1297             IERC20(_underlying).balanceOf(swapInfo.token) >= swapInfo.amount
1298         ) {
1299             assert(
1300                 IRouterMintBurn(swapInfo.token).mint(
1301                     address(this),
1302                     swapInfo.amount
1303                 )
1304             );
1305             if (_underlying == wNATIVE) {
1306                 IUnderlying(swapInfo.token).withdraw(
1307                     swapInfo.amount,
1308                     address(this)
1309                 );
1310                 IwNATIVE(wNATIVE).withdraw(swapInfo.amount);
1311                 Address.sendValue(payable(swapInfo.receiver), swapInfo.amount);
1312             } else {
1313                 IUnderlying(swapInfo.token).withdraw(
1314                     swapInfo.amount,
1315                     swapInfo.receiver
1316                 );
1317             }
1318         } else {
1319             assert(
1320                 IRouterMintBurn(swapInfo.token).mint(
1321                     swapInfo.receiver,
1322                     swapInfo.amount
1323                 )
1324             );
1325         }
1326         emit LogAnySwapIn(
1327             swapID,
1328             swapInfo.swapoutID,
1329             swapInfo.token,
1330             swapInfo.receiver,
1331             swapInfo.amount,
1332             swapInfo.fromChainID
1333         );
1334     }
1335 
1336     // Swaps `amount` `token` in `fromChainID` to `to` on this chainID
1337     function anySwapInAndExec(
1338         string calldata swapID,
1339         SwapInfo calldata swapInfo,
1340         address anycallProxy,
1341         bytes calldata data
1342     )
1343         external
1344         whenNotPaused(Swapin_Paused_ROLE)
1345         whenNotPaused(Exec_Paused_ROLE)
1346         nonReentrant
1347         onlyMPC
1348     {
1349         require(
1350             anycallProxyInfo[anycallProxy].supported,
1351             "unsupported ancall proxy"
1352         );
1353         IRouterSecurity(routerSecurity).registerSwapin(swapID, swapInfo);
1354 
1355         assert(
1356             IRouterMintBurn(swapInfo.token).mint(anycallProxy, swapInfo.amount)
1357         );
1358 
1359         bool success;
1360         bytes memory result;
1361         try
1362             IAnycallExecutor(anycallExecutor).execute(
1363                 anycallProxy,
1364                 swapInfo.token,
1365                 swapInfo.receiver,
1366                 swapInfo.amount,
1367                 data
1368             )
1369         returns (bool succ, bytes memory res) {
1370             (success, result) = (succ, res);
1371         } catch {}
1372 
1373         emit LogAnySwapInAndExec(
1374             swapID,
1375             swapInfo.swapoutID,
1376             swapInfo.token,
1377             swapInfo.receiver,
1378             swapInfo.amount,
1379             swapInfo.fromChainID,
1380             success,
1381             result
1382         );
1383     }
1384 
1385     // Swaps `amount` `token` in `fromChainID` to `to` on this chainID with `to` receiving `underlying`
1386     function anySwapInUnderlyingAndExec(
1387         string calldata swapID,
1388         SwapInfo calldata swapInfo,
1389         address anycallProxy,
1390         bytes calldata data
1391     )
1392         external
1393         whenNotPaused(Swapin_Paused_ROLE)
1394         whenNotPaused(Exec_Paused_ROLE)
1395         nonReentrant
1396         onlyMPC
1397     {
1398         require(
1399             anycallProxyInfo[anycallProxy].supported,
1400             "unsupported ancall proxy"
1401         );
1402         IRouterSecurity(routerSecurity).registerSwapin(swapID, swapInfo);
1403 
1404         address receiveToken;
1405         // transfer token to the receiver before execution
1406         {
1407             address _underlying = IUnderlying(swapInfo.token).underlying();
1408             require(
1409                 _underlying != address(0),
1410                 "MultichainRouter: zero underlying"
1411             );
1412 
1413             if (
1414                 IERC20(_underlying).balanceOf(swapInfo.token) >= swapInfo.amount
1415             ) {
1416                 receiveToken = _underlying;
1417                 assert(
1418                     IRouterMintBurn(swapInfo.token).mint(
1419                         address(this),
1420                         swapInfo.amount
1421                     )
1422                 );
1423                 IUnderlying(swapInfo.token).withdraw(
1424                     swapInfo.amount,
1425                     anycallProxy
1426                 );
1427             } else if (anycallProxyInfo[anycallProxy].acceptAnyToken) {
1428                 receiveToken = swapInfo.token;
1429                 assert(
1430                     IRouterMintBurn(swapInfo.token).mint(
1431                         anycallProxy,
1432                         swapInfo.amount
1433                     )
1434                 );
1435             } else {
1436                 bytes32 retryHash = keccak256(
1437                     abi.encode(
1438                         swapID,
1439                         swapInfo.swapoutID,
1440                         swapInfo.token,
1441                         swapInfo.receiver,
1442                         swapInfo.amount,
1443                         swapInfo.fromChainID,
1444                         anycallProxy,
1445                         data
1446                     )
1447                 );
1448                 retryRecords[retryHash] = keccak256(abi.encode(swapID, data));
1449                 emit LogRetryExecRecord(
1450                     swapID,
1451                     swapInfo.swapoutID,
1452                     swapInfo.token,
1453                     swapInfo.receiver,
1454                     swapInfo.amount,
1455                     swapInfo.fromChainID,
1456                     anycallProxy,
1457                     data
1458                 );
1459                 return;
1460             }
1461         }
1462 
1463         bool success;
1464         bytes memory result;
1465         try
1466             IAnycallExecutor(anycallExecutor).execute(
1467                 anycallProxy,
1468                 receiveToken,
1469                 swapInfo.receiver,
1470                 swapInfo.amount,
1471                 data
1472             )
1473         returns (bool succ, bytes memory res) {
1474             (success, result) = (succ, res);
1475         } catch {}
1476 
1477         emit LogAnySwapInAndExec(
1478             swapID,
1479             swapInfo.swapoutID,
1480             swapInfo.token,
1481             swapInfo.receiver,
1482             swapInfo.amount,
1483             swapInfo.fromChainID,
1484             success,
1485             result
1486         );
1487     }
1488 
1489     // should be called only by the `receiver` or `admin`
1490     // @param dontExec
1491     // if `true` transfer the underlying token to the `receiver`,
1492     // if `false` retry swapin and execute in normal way.
1493     function retrySwapinAndExec(
1494         string calldata swapID,
1495         SwapInfo calldata swapInfo,
1496         address anycallProxy,
1497         bytes calldata data,
1498         bool dontExec
1499     ) external whenNotPaused(Retry_Paused_ROLE) nonReentrant {
1500         require(
1501             msg.sender == swapInfo.receiver || msg.sender == admin,
1502             "forbid retry swap"
1503         );
1504         require(
1505             IRouterSecurity(routerSecurity).isSwapCompleted(
1506                 swapID,
1507                 swapInfo.swapoutID,
1508                 swapInfo.fromChainID
1509             ),
1510             "swap not completed"
1511         );
1512 
1513         {
1514             bytes32 retryHash = keccak256(
1515                 abi.encode(
1516                     swapID,
1517                     swapInfo.swapoutID,
1518                     swapInfo.token,
1519                     swapInfo.receiver,
1520                     swapInfo.amount,
1521                     swapInfo.fromChainID,
1522                     anycallProxy,
1523                     data
1524                 )
1525             );
1526             require(
1527                 retryRecords[retryHash] == keccak256(abi.encode(swapID, data)),
1528                 "retry record not exist"
1529             );
1530             delete retryRecords[retryHash];
1531         }
1532 
1533         address _underlying = IUnderlying(swapInfo.token).underlying();
1534         require(_underlying != address(0), "MultichainRouter: zero underlying");
1535         require(
1536             IERC20(_underlying).balanceOf(swapInfo.token) >= swapInfo.amount,
1537             "MultichainRouter: retry failed"
1538         );
1539         assert(
1540             IRouterMintBurn(swapInfo.token).mint(address(this), swapInfo.amount)
1541         );
1542 
1543         bool success;
1544         bytes memory result;
1545 
1546         if (dontExec) {
1547             IUnderlying(swapInfo.token).withdraw(
1548                 swapInfo.amount,
1549                 swapInfo.receiver
1550             );
1551         } else {
1552             IUnderlying(swapInfo.token).withdraw(swapInfo.amount, anycallProxy);
1553             try
1554                 IAnycallExecutor(anycallExecutor).execute(
1555                     anycallProxy,
1556                     _underlying,
1557                     swapInfo.receiver,
1558                     swapInfo.amount,
1559                     data
1560                 )
1561             returns (bool succ, bytes memory res) {
1562                 (success, result) = (succ, res);
1563             } catch {}
1564         }
1565 
1566         emit LogRetrySwapInAndExec(
1567             swapID,
1568             swapInfo.swapoutID,
1569             swapInfo.token,
1570             swapInfo.receiver,
1571             swapInfo.amount,
1572             swapInfo.fromChainID,
1573             dontExec,
1574             success,
1575             result
1576         );
1577     }
1578 
1579     // extracts mpc fee from bridge fees
1580     function anySwapFeeTo(address token, uint256 amount)
1581         external
1582         nonReentrant
1583         onlyMPC
1584     {
1585         IRouterMintBurn(token).mint(address(this), amount);
1586         IUnderlying(token).withdraw(amount, msg.sender);
1587     }
1588 }