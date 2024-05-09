1 // SPDX-License-Identifier: GPL-3.0-or-later
2 // Sources flattened with hardhat v2.6.1 https://hardhat.org
3 
4 // File @openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol@v4.5.1
5 
6 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
7 
8 pragma solidity ^0.8.1;
9 
10 /**
11  * @dev Collection of functions related to the address type
12  */
13 library AddressUpgradeable {
14     /**
15      * @dev Returns true if `account` is a contract.
16      *
17      * [IMPORTANT]
18      * ====
19      * It is unsafe to assume that an address for which this function returns
20      * false is an externally-owned account (EOA) and not a contract.
21      *
22      * Among others, `isContract` will return false for the following
23      * types of addresses:
24      *
25      *  - an externally-owned account
26      *  - a contract in construction
27      *  - an address where a contract will be created
28      *  - an address where a contract lived, but was destroyed
29      * ====
30      *
31      * [IMPORTANT]
32      * ====
33      * You shouldn't rely on `isContract` to protect against flash loan attacks!
34      *
35      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
36      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
37      * constructor.
38      * ====
39      */
40     function isContract(address account) internal view returns (bool) {
41         // This method relies on extcodesize/address.code.length, which returns 0
42         // for contracts in construction, since the code is only stored at the end
43         // of the constructor execution.
44 
45         return account.code.length > 0;
46     }
47 
48     /**
49      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
50      * `recipient`, forwarding all available gas and reverting on errors.
51      *
52      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
53      * of certain opcodes, possibly making contracts go over the 2300 gas limit
54      * imposed by `transfer`, making them unable to receive funds via
55      * `transfer`. {sendValue} removes this limitation.
56      *
57      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
58      *
59      * IMPORTANT: because control is transferred to `recipient`, care must be
60      * taken to not create reentrancy vulnerabilities. Consider using
61      * {ReentrancyGuard} or the
62      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
63      */
64     function sendValue(address payable recipient, uint256 amount) internal {
65         require(address(this).balance >= amount, "Address: insufficient balance");
66 
67         (bool success, ) = recipient.call{value: amount}("");
68         require(success, "Address: unable to send value, recipient may have reverted");
69     }
70 
71     /**
72      * @dev Performs a Solidity function call using a low level `call`. A
73      * plain `call` is an unsafe replacement for a function call: use this
74      * function instead.
75      *
76      * If `target` reverts with a revert reason, it is bubbled up by this
77      * function (like regular Solidity function calls).
78      *
79      * Returns the raw returned data. To convert to the expected return value,
80      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
81      *
82      * Requirements:
83      *
84      * - `target` must be a contract.
85      * - calling `target` with `data` must not revert.
86      *
87      * _Available since v3.1._
88      */
89     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
90         return functionCall(target, data, "Address: low-level call failed");
91     }
92 
93     /**
94      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
95      * `errorMessage` as a fallback revert reason when `target` reverts.
96      *
97      * _Available since v3.1._
98      */
99     function functionCall(
100         address target,
101         bytes memory data,
102         string memory errorMessage
103     ) internal returns (bytes memory) {
104         return functionCallWithValue(target, data, 0, errorMessage);
105     }
106 
107     /**
108      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
109      * but also transferring `value` wei to `target`.
110      *
111      * Requirements:
112      *
113      * - the calling contract must have an ETH balance of at least `value`.
114      * - the called Solidity function must be `payable`.
115      *
116      * _Available since v3.1._
117      */
118     function functionCallWithValue(
119         address target,
120         bytes memory data,
121         uint256 value
122     ) internal returns (bytes memory) {
123         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
124     }
125 
126     /**
127      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
128      * with `errorMessage` as a fallback revert reason when `target` reverts.
129      *
130      * _Available since v3.1._
131      */
132     function functionCallWithValue(
133         address target,
134         bytes memory data,
135         uint256 value,
136         string memory errorMessage
137     ) internal returns (bytes memory) {
138         require(address(this).balance >= value, "Address: insufficient balance for call");
139         require(isContract(target), "Address: call to non-contract");
140 
141         (bool success, bytes memory returndata) = target.call{value: value}(data);
142         return verifyCallResult(success, returndata, errorMessage);
143     }
144 
145     /**
146      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
147      * but performing a static call.
148      *
149      * _Available since v3.3._
150      */
151     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
152         return functionStaticCall(target, data, "Address: low-level static call failed");
153     }
154 
155     /**
156      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
157      * but performing a static call.
158      *
159      * _Available since v3.3._
160      */
161     function functionStaticCall(
162         address target,
163         bytes memory data,
164         string memory errorMessage
165     ) internal view returns (bytes memory) {
166         require(isContract(target), "Address: static call to non-contract");
167 
168         (bool success, bytes memory returndata) = target.staticcall(data);
169         return verifyCallResult(success, returndata, errorMessage);
170     }
171 
172     /**
173      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
174      * revert reason using the provided one.
175      *
176      * _Available since v4.3._
177      */
178     function verifyCallResult(
179         bool success,
180         bytes memory returndata,
181         string memory errorMessage
182     ) internal pure returns (bytes memory) {
183         if (success) {
184             return returndata;
185         } else {
186             // Look for revert reason and bubble it up if present
187             if (returndata.length > 0) {
188                 // The easiest way to bubble the revert reason is using memory via assembly
189 
190                 assembly {
191                     let returndata_size := mload(returndata)
192                     revert(add(32, returndata), returndata_size)
193                 }
194             } else {
195                 revert(errorMessage);
196             }
197         }
198     }
199 }
200 
201 
202 // File @openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol@v4.5.1
203 
204 // OpenZeppelin Contracts (last updated v4.5.0) (proxy/utils/Initializable.sol)
205 
206 pragma solidity ^0.8.0;
207 
208 /**
209  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
210  * behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
211  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
212  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
213  *
214  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
215  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
216  *
217  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
218  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
219  *
220  * [CAUTION]
221  * ====
222  * Avoid leaving a contract uninitialized.
223  *
224  * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
225  * contract, which may impact the proxy. To initialize the implementation contract, you can either invoke the
226  * initializer manually, or you can include a constructor to automatically mark it as initialized when it is deployed:
227  *
228  * [.hljs-theme-light.nopadding]
229  * ```
230  * /// @custom:oz-upgrades-unsafe-allow constructor
231  * constructor() initializer {}
232  * ```
233  * ====
234  */
235 abstract contract Initializable {
236     /**
237      * @dev Indicates that the contract has been initialized.
238      */
239     bool private _initialized;
240 
241     /**
242      * @dev Indicates that the contract is in the process of being initialized.
243      */
244     bool private _initializing;
245 
246     /**
247      * @dev Modifier to protect an initializer function from being invoked twice.
248      */
249     modifier initializer() {
250         // If the contract is initializing we ignore whether _initialized is set in order to support multiple
251         // inheritance patterns, but we only do this in the context of a constructor, because in other contexts the
252         // contract may have been reentered.
253         require(_initializing ? _isConstructor() : !_initialized, "Initializable: contract is already initialized");
254 
255         bool isTopLevelCall = !_initializing;
256         if (isTopLevelCall) {
257             _initializing = true;
258             _initialized = true;
259         }
260 
261         _;
262 
263         if (isTopLevelCall) {
264             _initializing = false;
265         }
266     }
267 
268     /**
269      * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
270      * {initializer} modifier, directly or indirectly.
271      */
272     modifier onlyInitializing() {
273         require(_initializing, "Initializable: contract is not initializing");
274         _;
275     }
276 
277     function _isConstructor() private view returns (bool) {
278         return !AddressUpgradeable.isContract(address(this));
279     }
280 }
281 
282 
283 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.5.0
284 
285 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
286 
287 pragma solidity ^0.8.0;
288 
289 /**
290  * @dev Interface of the ERC20 standard as defined in the EIP.
291  */
292 interface IERC20 {
293     /**
294      * @dev Returns the amount of tokens in existence.
295      */
296     function totalSupply() external view returns (uint256);
297 
298     /**
299      * @dev Returns the amount of tokens owned by `account`.
300      */
301     function balanceOf(address account) external view returns (uint256);
302 
303     /**
304      * @dev Moves `amount` tokens from the caller's account to `to`.
305      *
306      * Returns a boolean value indicating whether the operation succeeded.
307      *
308      * Emits a {Transfer} event.
309      */
310     function transfer(address to, uint256 amount) external returns (bool);
311 
312     /**
313      * @dev Returns the remaining number of tokens that `spender` will be
314      * allowed to spend on behalf of `owner` through {transferFrom}. This is
315      * zero by default.
316      *
317      * This value changes when {approve} or {transferFrom} are called.
318      */
319     function allowance(address owner, address spender) external view returns (uint256);
320 
321     /**
322      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
323      *
324      * Returns a boolean value indicating whether the operation succeeded.
325      *
326      * IMPORTANT: Beware that changing an allowance with this method brings the risk
327      * that someone may use both the old and the new allowance by unfortunate
328      * transaction ordering. One possible solution to mitigate this race
329      * condition is to first reduce the spender's allowance to 0 and set the
330      * desired value afterwards:
331      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
332      *
333      * Emits an {Approval} event.
334      */
335     function approve(address spender, uint256 amount) external returns (bool);
336 
337     /**
338      * @dev Moves `amount` tokens from `from` to `to` using the
339      * allowance mechanism. `amount` is then deducted from the caller's
340      * allowance.
341      *
342      * Returns a boolean value indicating whether the operation succeeded.
343      *
344      * Emits a {Transfer} event.
345      */
346     function transferFrom(
347         address from,
348         address to,
349         uint256 amount
350     ) external returns (bool);
351 
352     /**
353      * @dev Emitted when `value` tokens are moved from one account (`from`) to
354      * another (`to`).
355      *
356      * Note that `value` may be zero.
357      */
358     event Transfer(address indexed from, address indexed to, uint256 value);
359 
360     /**
361      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
362      * a call to {approve}. `value` is the new allowance.
363      */
364     event Approval(address indexed owner, address indexed spender, uint256 value);
365 }
366 
367 
368 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
369 
370 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
371 
372 pragma solidity ^0.8.1;
373 
374 /**
375  * @dev Collection of functions related to the address type
376  */
377 library Address {
378     /**
379      * @dev Returns true if `account` is a contract.
380      *
381      * [IMPORTANT]
382      * ====
383      * It is unsafe to assume that an address for which this function returns
384      * false is an externally-owned account (EOA) and not a contract.
385      *
386      * Among others, `isContract` will return false for the following
387      * types of addresses:
388      *
389      *  - an externally-owned account
390      *  - a contract in construction
391      *  - an address where a contract will be created
392      *  - an address where a contract lived, but was destroyed
393      * ====
394      *
395      * [IMPORTANT]
396      * ====
397      * You shouldn't rely on `isContract` to protect against flash loan attacks!
398      *
399      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
400      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
401      * constructor.
402      * ====
403      */
404     function isContract(address account) internal view returns (bool) {
405         // This method relies on extcodesize/address.code.length, which returns 0
406         // for contracts in construction, since the code is only stored at the end
407         // of the constructor execution.
408 
409         return account.code.length > 0;
410     }
411 
412     /**
413      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
414      * `recipient`, forwarding all available gas and reverting on errors.
415      *
416      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
417      * of certain opcodes, possibly making contracts go over the 2300 gas limit
418      * imposed by `transfer`, making them unable to receive funds via
419      * `transfer`. {sendValue} removes this limitation.
420      *
421      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
422      *
423      * IMPORTANT: because control is transferred to `recipient`, care must be
424      * taken to not create reentrancy vulnerabilities. Consider using
425      * {ReentrancyGuard} or the
426      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
427      */
428     function sendValue(address payable recipient, uint256 amount) internal {
429         require(address(this).balance >= amount, "Address: insufficient balance");
430 
431         (bool success, ) = recipient.call{value: amount}("");
432         require(success, "Address: unable to send value, recipient may have reverted");
433     }
434 
435     /**
436      * @dev Performs a Solidity function call using a low level `call`. A
437      * plain `call` is an unsafe replacement for a function call: use this
438      * function instead.
439      *
440      * If `target` reverts with a revert reason, it is bubbled up by this
441      * function (like regular Solidity function calls).
442      *
443      * Returns the raw returned data. To convert to the expected return value,
444      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
445      *
446      * Requirements:
447      *
448      * - `target` must be a contract.
449      * - calling `target` with `data` must not revert.
450      *
451      * _Available since v3.1._
452      */
453     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
454         return functionCall(target, data, "Address: low-level call failed");
455     }
456 
457     /**
458      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
459      * `errorMessage` as a fallback revert reason when `target` reverts.
460      *
461      * _Available since v3.1._
462      */
463     function functionCall(
464         address target,
465         bytes memory data,
466         string memory errorMessage
467     ) internal returns (bytes memory) {
468         return functionCallWithValue(target, data, 0, errorMessage);
469     }
470 
471     /**
472      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
473      * but also transferring `value` wei to `target`.
474      *
475      * Requirements:
476      *
477      * - the calling contract must have an ETH balance of at least `value`.
478      * - the called Solidity function must be `payable`.
479      *
480      * _Available since v3.1._
481      */
482     function functionCallWithValue(
483         address target,
484         bytes memory data,
485         uint256 value
486     ) internal returns (bytes memory) {
487         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
488     }
489 
490     /**
491      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
492      * with `errorMessage` as a fallback revert reason when `target` reverts.
493      *
494      * _Available since v3.1._
495      */
496     function functionCallWithValue(
497         address target,
498         bytes memory data,
499         uint256 value,
500         string memory errorMessage
501     ) internal returns (bytes memory) {
502         require(address(this).balance >= value, "Address: insufficient balance for call");
503         require(isContract(target), "Address: call to non-contract");
504 
505         (bool success, bytes memory returndata) = target.call{value: value}(data);
506         return verifyCallResult(success, returndata, errorMessage);
507     }
508 
509     /**
510      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
511      * but performing a static call.
512      *
513      * _Available since v3.3._
514      */
515     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
516         return functionStaticCall(target, data, "Address: low-level static call failed");
517     }
518 
519     /**
520      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
521      * but performing a static call.
522      *
523      * _Available since v3.3._
524      */
525     function functionStaticCall(
526         address target,
527         bytes memory data,
528         string memory errorMessage
529     ) internal view returns (bytes memory) {
530         require(isContract(target), "Address: static call to non-contract");
531 
532         (bool success, bytes memory returndata) = target.staticcall(data);
533         return verifyCallResult(success, returndata, errorMessage);
534     }
535 
536     /**
537      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
538      * but performing a delegate call.
539      *
540      * _Available since v3.4._
541      */
542     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
543         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
544     }
545 
546     /**
547      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
548      * but performing a delegate call.
549      *
550      * _Available since v3.4._
551      */
552     function functionDelegateCall(
553         address target,
554         bytes memory data,
555         string memory errorMessage
556     ) internal returns (bytes memory) {
557         require(isContract(target), "Address: delegate call to non-contract");
558 
559         (bool success, bytes memory returndata) = target.delegatecall(data);
560         return verifyCallResult(success, returndata, errorMessage);
561     }
562 
563     /**
564      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
565      * revert reason using the provided one.
566      *
567      * _Available since v4.3._
568      */
569     function verifyCallResult(
570         bool success,
571         bytes memory returndata,
572         string memory errorMessage
573     ) internal pure returns (bytes memory) {
574         if (success) {
575             return returndata;
576         } else {
577             // Look for revert reason and bubble it up if present
578             if (returndata.length > 0) {
579                 // The easiest way to bubble the revert reason is using memory via assembly
580 
581                 assembly {
582                     let returndata_size := mload(returndata)
583                     revert(add(32, returndata), returndata_size)
584                 }
585             } else {
586                 revert(errorMessage);
587             }
588         }
589     }
590 }
591 
592 
593 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.5.0
594 
595 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
596 
597 pragma solidity ^0.8.0;
598 
599 
600 /**
601  * @title SafeERC20
602  * @dev Wrappers around ERC20 operations that throw on failure (when the token
603  * contract returns false). Tokens that return no value (and instead revert or
604  * throw on failure) are also supported, non-reverting calls are assumed to be
605  * successful.
606  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
607  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
608  */
609 library SafeERC20 {
610     using Address for address;
611 
612     function safeTransfer(
613         IERC20 token,
614         address to,
615         uint256 value
616     ) internal {
617         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
618     }
619 
620     function safeTransferFrom(
621         IERC20 token,
622         address from,
623         address to,
624         uint256 value
625     ) internal {
626         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
627     }
628 
629     /**
630      * @dev Deprecated. This function has issues similar to the ones found in
631      * {IERC20-approve}, and its usage is discouraged.
632      *
633      * Whenever possible, use {safeIncreaseAllowance} and
634      * {safeDecreaseAllowance} instead.
635      */
636     function safeApprove(
637         IERC20 token,
638         address spender,
639         uint256 value
640     ) internal {
641         // safeApprove should only be called when setting an initial allowance,
642         // or when resetting it to zero. To increase and decrease it, use
643         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
644         require(
645             (value == 0) || (token.allowance(address(this), spender) == 0),
646             "SafeERC20: approve from non-zero to non-zero allowance"
647         );
648         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
649     }
650 
651     function safeIncreaseAllowance(
652         IERC20 token,
653         address spender,
654         uint256 value
655     ) internal {
656         uint256 newAllowance = token.allowance(address(this), spender) + value;
657         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
658     }
659 
660     function safeDecreaseAllowance(
661         IERC20 token,
662         address spender,
663         uint256 value
664     ) internal {
665         unchecked {
666             uint256 oldAllowance = token.allowance(address(this), spender);
667             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
668             uint256 newAllowance = oldAllowance - value;
669             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
670         }
671     }
672 
673     /**
674      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
675      * on the return value: the return value is optional (but if data is returned, it must not be false).
676      * @param token The token targeted by the call.
677      * @param data The call data (encoded using abi.encode or one of its variants).
678      */
679     function _callOptionalReturn(IERC20 token, bytes memory data) private {
680         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
681         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
682         // the target address contains contract code and also asserts for success in the low-level call.
683 
684         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
685         if (returndata.length > 0) {
686             // Return data is optional
687             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
688         }
689     }
690 }
691 
692 
693 // File @openzeppelin/contracts/utils/math/SafeCast.sol@v4.5.0
694 
695 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeCast.sol)
696 
697 pragma solidity ^0.8.0;
698 
699 /**
700  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
701  * checks.
702  *
703  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
704  * easily result in undesired exploitation or bugs, since developers usually
705  * assume that overflows raise errors. `SafeCast` restores this intuition by
706  * reverting the transaction when such an operation overflows.
707  *
708  * Using this library instead of the unchecked operations eliminates an entire
709  * class of bugs, so it's recommended to use it always.
710  *
711  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
712  * all math on `uint256` and `int256` and then downcasting.
713  */
714 library SafeCast {
715     /**
716      * @dev Returns the downcasted uint224 from uint256, reverting on
717      * overflow (when the input is greater than largest uint224).
718      *
719      * Counterpart to Solidity's `uint224` operator.
720      *
721      * Requirements:
722      *
723      * - input must fit into 224 bits
724      */
725     function toUint224(uint256 value) internal pure returns (uint224) {
726         require(value <= type(uint224).max, "SafeCast: value doesn't fit in 224 bits");
727         return uint224(value);
728     }
729 
730     /**
731      * @dev Returns the downcasted uint128 from uint256, reverting on
732      * overflow (when the input is greater than largest uint128).
733      *
734      * Counterpart to Solidity's `uint128` operator.
735      *
736      * Requirements:
737      *
738      * - input must fit into 128 bits
739      */
740     function toUint128(uint256 value) internal pure returns (uint128) {
741         require(value <= type(uint128).max, "SafeCast: value doesn't fit in 128 bits");
742         return uint128(value);
743     }
744 
745     /**
746      * @dev Returns the downcasted uint96 from uint256, reverting on
747      * overflow (when the input is greater than largest uint96).
748      *
749      * Counterpart to Solidity's `uint96` operator.
750      *
751      * Requirements:
752      *
753      * - input must fit into 96 bits
754      */
755     function toUint96(uint256 value) internal pure returns (uint96) {
756         require(value <= type(uint96).max, "SafeCast: value doesn't fit in 96 bits");
757         return uint96(value);
758     }
759 
760     /**
761      * @dev Returns the downcasted uint64 from uint256, reverting on
762      * overflow (when the input is greater than largest uint64).
763      *
764      * Counterpart to Solidity's `uint64` operator.
765      *
766      * Requirements:
767      *
768      * - input must fit into 64 bits
769      */
770     function toUint64(uint256 value) internal pure returns (uint64) {
771         require(value <= type(uint64).max, "SafeCast: value doesn't fit in 64 bits");
772         return uint64(value);
773     }
774 
775     /**
776      * @dev Returns the downcasted uint32 from uint256, reverting on
777      * overflow (when the input is greater than largest uint32).
778      *
779      * Counterpart to Solidity's `uint32` operator.
780      *
781      * Requirements:
782      *
783      * - input must fit into 32 bits
784      */
785     function toUint32(uint256 value) internal pure returns (uint32) {
786         require(value <= type(uint32).max, "SafeCast: value doesn't fit in 32 bits");
787         return uint32(value);
788     }
789 
790     /**
791      * @dev Returns the downcasted uint16 from uint256, reverting on
792      * overflow (when the input is greater than largest uint16).
793      *
794      * Counterpart to Solidity's `uint16` operator.
795      *
796      * Requirements:
797      *
798      * - input must fit into 16 bits
799      */
800     function toUint16(uint256 value) internal pure returns (uint16) {
801         require(value <= type(uint16).max, "SafeCast: value doesn't fit in 16 bits");
802         return uint16(value);
803     }
804 
805     /**
806      * @dev Returns the downcasted uint8 from uint256, reverting on
807      * overflow (when the input is greater than largest uint8).
808      *
809      * Counterpart to Solidity's `uint8` operator.
810      *
811      * Requirements:
812      *
813      * - input must fit into 8 bits.
814      */
815     function toUint8(uint256 value) internal pure returns (uint8) {
816         require(value <= type(uint8).max, "SafeCast: value doesn't fit in 8 bits");
817         return uint8(value);
818     }
819 
820     /**
821      * @dev Converts a signed int256 into an unsigned uint256.
822      *
823      * Requirements:
824      *
825      * - input must be greater than or equal to 0.
826      */
827     function toUint256(int256 value) internal pure returns (uint256) {
828         require(value >= 0, "SafeCast: value must be positive");
829         return uint256(value);
830     }
831 
832     /**
833      * @dev Returns the downcasted int128 from int256, reverting on
834      * overflow (when the input is less than smallest int128 or
835      * greater than largest int128).
836      *
837      * Counterpart to Solidity's `int128` operator.
838      *
839      * Requirements:
840      *
841      * - input must fit into 128 bits
842      *
843      * _Available since v3.1._
844      */
845     function toInt128(int256 value) internal pure returns (int128) {
846         require(value >= type(int128).min && value <= type(int128).max, "SafeCast: value doesn't fit in 128 bits");
847         return int128(value);
848     }
849 
850     /**
851      * @dev Returns the downcasted int64 from int256, reverting on
852      * overflow (when the input is less than smallest int64 or
853      * greater than largest int64).
854      *
855      * Counterpart to Solidity's `int64` operator.
856      *
857      * Requirements:
858      *
859      * - input must fit into 64 bits
860      *
861      * _Available since v3.1._
862      */
863     function toInt64(int256 value) internal pure returns (int64) {
864         require(value >= type(int64).min && value <= type(int64).max, "SafeCast: value doesn't fit in 64 bits");
865         return int64(value);
866     }
867 
868     /**
869      * @dev Returns the downcasted int32 from int256, reverting on
870      * overflow (when the input is less than smallest int32 or
871      * greater than largest int32).
872      *
873      * Counterpart to Solidity's `int32` operator.
874      *
875      * Requirements:
876      *
877      * - input must fit into 32 bits
878      *
879      * _Available since v3.1._
880      */
881     function toInt32(int256 value) internal pure returns (int32) {
882         require(value >= type(int32).min && value <= type(int32).max, "SafeCast: value doesn't fit in 32 bits");
883         return int32(value);
884     }
885 
886     /**
887      * @dev Returns the downcasted int16 from int256, reverting on
888      * overflow (when the input is less than smallest int16 or
889      * greater than largest int16).
890      *
891      * Counterpart to Solidity's `int16` operator.
892      *
893      * Requirements:
894      *
895      * - input must fit into 16 bits
896      *
897      * _Available since v3.1._
898      */
899     function toInt16(int256 value) internal pure returns (int16) {
900         require(value >= type(int16).min && value <= type(int16).max, "SafeCast: value doesn't fit in 16 bits");
901         return int16(value);
902     }
903 
904     /**
905      * @dev Returns the downcasted int8 from int256, reverting on
906      * overflow (when the input is less than smallest int8 or
907      * greater than largest int8).
908      *
909      * Counterpart to Solidity's `int8` operator.
910      *
911      * Requirements:
912      *
913      * - input must fit into 8 bits.
914      *
915      * _Available since v3.1._
916      */
917     function toInt8(int256 value) internal pure returns (int8) {
918         require(value >= type(int8).min && value <= type(int8).max, "SafeCast: value doesn't fit in 8 bits");
919         return int8(value);
920     }
921 
922     /**
923      * @dev Converts an unsigned uint256 into a signed int256.
924      *
925      * Requirements:
926      *
927      * - input must be less than or equal to maxInt256.
928      */
929     function toInt256(uint256 value) internal pure returns (int256) {
930         // Note: Unsafe cast below is okay because `type(int256).max` is guaranteed to be positive
931         require(value <= uint256(type(int256).max), "SafeCast: value doesn't fit in an int256");
932         return int256(value);
933     }
934 }
935 
936 
937 // File interfaces/strategies/IStrategy.sol
938 
939 pragma solidity 0.8.10;
940 
941 interface IStrategy {
942     function deposit() external payable returns (bool);
943 
944     function withdraw(uint256 amount) external returns (bool);
945 
946     function withdrawAll() external returns (uint256);
947 
948     function harvest() external returns (uint256);
949 
950     function shutdown() external;
951 
952     function setCommunityReserve(address _communityReserve) external;
953 
954     function setStrategist(address strategist_) external;
955 
956     function name() external view returns (string memory);
957 
958     function balance() external view returns (uint256);
959 
960     function harvestable() external view returns (uint256);
961 
962     function strategist() external view returns (address);
963 
964     function hasPendingFunds() external view returns (bool);
965 }
966 
967 
968 // File interfaces/IVault.sol
969 
970 pragma solidity 0.8.10;
971 
972 /**
973  * @title Interface for a Vault
974  */
975 
976 interface IVault {
977     event StrategyActivated(address indexed strategy);
978 
979     event StrategyDeactivated(address indexed strategy);
980 
981     /**
982      * @dev 'netProfit' is the profit after all fees have been deducted
983      */
984     event Harvest(uint256 indexed netProfit, uint256 indexed loss);
985 
986     function initialize(
987         address _pool,
988         uint256 _debtLimit,
989         uint256 _targetAllocation,
990         uint256 _bound
991     ) external;
992 
993     function withdrawFromStrategyWaitingForRemoval(address strategy) external returns (uint256);
994 
995     function deposit() external payable;
996 
997     function withdraw(uint256 amount) external returns (bool);
998 
999     function withdrawAvailableToPool() external;
1000 
1001     function initializeStrategy(address strategy_) external;
1002 
1003     function shutdownStrategy() external;
1004 
1005     function withdrawFromReserve(uint256 amount) external;
1006 
1007     function updateStrategy(address newStrategy) external;
1008 
1009     function activateStrategy() external returns (bool);
1010 
1011     function deactivateStrategy() external returns (bool);
1012 
1013     function updatePerformanceFee(uint256 newPerformanceFee) external;
1014 
1015     function updateStrategistFee(uint256 newStrategistFee) external;
1016 
1017     function updateDebtLimit(uint256 newDebtLimit) external;
1018 
1019     function updateTargetAllocation(uint256 newTargetAllocation) external;
1020 
1021     function updateReserveFee(uint256 newReserveFee) external;
1022 
1023     function updateBound(uint256 newBound) external;
1024 
1025     function withdrawFromStrategy(uint256 amount) external returns (bool);
1026 
1027     function withdrawAllFromStrategy() external returns (bool);
1028 
1029     function harvest() external returns (bool);
1030 
1031     function getStrategiesWaitingForRemoval() external view returns (address[] memory);
1032 
1033     function getAllocatedToStrategyWaitingForRemoval(address strategy)
1034         external
1035         view
1036         returns (uint256);
1037 
1038     function getTotalUnderlying() external view returns (uint256);
1039 
1040     function getUnderlying() external view returns (address);
1041 
1042     function strategy() external view returns (IStrategy);
1043 }
1044 
1045 
1046 // File interfaces/IStakerVault.sol
1047 
1048 pragma solidity 0.8.10;
1049 
1050 interface IStakerVault {
1051     event Staked(address indexed account, uint256 amount);
1052     event Unstaked(address indexed account, uint256 amount);
1053     event Transfer(address indexed from, address indexed to, uint256 value);
1054     event Approval(address indexed owner, address indexed spender, uint256 value);
1055 
1056     function initialize(address _token) external;
1057 
1058     function initializeLpGauge(address _lpGauge) external;
1059 
1060     function stake(uint256 amount) external;
1061 
1062     function stakeFor(address account, uint256 amount) external;
1063 
1064     function unstake(uint256 amount) external;
1065 
1066     function unstakeFor(
1067         address src,
1068         address dst,
1069         uint256 amount
1070     ) external;
1071 
1072     function approve(address spender, uint256 amount) external;
1073 
1074     function transfer(address account, uint256 amount) external;
1075 
1076     function transferFrom(
1077         address src,
1078         address dst,
1079         uint256 amount
1080     ) external;
1081 
1082     function increaseActionLockedBalance(address account, uint256 amount) external;
1083 
1084     function decreaseActionLockedBalance(address account, uint256 amount) external;
1085 
1086     function updateLpGauge(address _lpGauge) external;
1087 
1088     function poolCheckpoint() external returns (bool);
1089 
1090     function poolCheckpoint(uint256 updateEndTime) external returns (bool);
1091 
1092     function allowance(address owner, address spender) external view returns (uint256);
1093 
1094     function getToken() external view returns (address);
1095 
1096     function balanceOf(address account) external view returns (uint256);
1097 
1098     function stakedAndActionLockedBalanceOf(address account) external view returns (uint256);
1099 
1100     function actionLockedBalanceOf(address account) external view returns (uint256);
1101 
1102     function getStakedByActions() external view returns (uint256);
1103 
1104     function getPoolTotalStaked() external view returns (uint256);
1105 
1106     function decimals() external view returns (uint8);
1107 
1108     function lpGauge() external view returns (address);
1109 }
1110 
1111 
1112 // File interfaces/pool/ILiquidityPool.sol
1113 
1114 pragma solidity 0.8.10;
1115 
1116 
1117 interface ILiquidityPool {
1118     event Deposit(address indexed minter, uint256 depositAmount, uint256 mintedLpTokens);
1119 
1120     event DepositFor(
1121         address indexed minter,
1122         address indexed mintee,
1123         uint256 depositAmount,
1124         uint256 mintedLpTokens
1125     );
1126 
1127     event Redeem(address indexed redeemer, uint256 redeemAmount, uint256 redeemTokens);
1128 
1129     event LpTokenSet(address indexed lpToken);
1130 
1131     event StakerVaultSet(address indexed stakerVault);
1132 
1133     event Shutdown();
1134 
1135     function redeem(uint256 redeemTokens) external returns (uint256);
1136 
1137     function redeem(uint256 redeemTokens, uint256 minRedeemAmount) external returns (uint256);
1138 
1139     function calcRedeem(address account, uint256 underlyingAmount) external returns (uint256);
1140 
1141     function deposit(uint256 mintAmount) external payable returns (uint256);
1142 
1143     function deposit(uint256 mintAmount, uint256 minTokenAmount) external payable returns (uint256);
1144 
1145     function depositAndStake(uint256 depositAmount, uint256 minTokenAmount)
1146         external
1147         payable
1148         returns (uint256);
1149 
1150     function depositFor(address account, uint256 depositAmount) external payable returns (uint256);
1151 
1152     function depositFor(
1153         address account,
1154         uint256 depositAmount,
1155         uint256 minTokenAmount
1156     ) external payable returns (uint256);
1157 
1158     function unstakeAndRedeem(uint256 redeemLpTokens, uint256 minRedeemAmount)
1159         external
1160         returns (uint256);
1161 
1162     function handleLpTokenTransfer(
1163         address from,
1164         address to,
1165         uint256 amount
1166     ) external;
1167 
1168     function updateVault(address _vault) external;
1169 
1170     function setLpToken(address _lpToken) external;
1171 
1172     function setStaker() external;
1173 
1174     function shutdownPool(bool shutdownStrategy) external;
1175 
1176     function shutdownStrategy() external;
1177 
1178     function updateRequiredReserves(uint256 _newRatio) external;
1179 
1180     function updateReserveDeviation(uint256 newRatio) external;
1181 
1182     function updateMinWithdrawalFee(uint256 newFee) external;
1183 
1184     function updateMaxWithdrawalFee(uint256 newFee) external;
1185 
1186     function updateWithdrawalFeeDecreasePeriod(uint256 newPeriod) external;
1187 
1188     function rebalanceVault() external;
1189 
1190     function getNewCurrentFees(
1191         uint256 timeToWait,
1192         uint256 lastActionTimestamp,
1193         uint256 feeRatio
1194     ) external view returns (uint256);
1195 
1196     function vault() external view returns (IVault);
1197 
1198     function staker() external view returns (IStakerVault);
1199 
1200     function getUnderlying() external view returns (address);
1201 
1202     function getLpToken() external view returns (address);
1203 
1204     function getWithdrawalFee(address account, uint256 amount) external view returns (uint256);
1205 
1206     function exchangeRate() external view returns (uint256);
1207 
1208     function totalUnderlying() external view returns (uint256);
1209 
1210     function name() external view returns (string memory);
1211 
1212     function isShutdown() external view returns (bool);
1213 }
1214 
1215 
1216 // File interfaces/IGasBank.sol
1217 
1218 pragma solidity 0.8.10;
1219 
1220 interface IGasBank {
1221     event Deposit(address indexed account, uint256 value);
1222     event Withdraw(address indexed account, address indexed receiver, uint256 value);
1223 
1224     function depositFor(address account) external payable;
1225 
1226     function withdrawUnused(address account) external;
1227 
1228     function withdrawFrom(address account, uint256 amount) external;
1229 
1230     function withdrawFrom(
1231         address account,
1232         address payable to,
1233         uint256 amount
1234     ) external;
1235 
1236     function balanceOf(address account) external view returns (uint256);
1237 }
1238 
1239 
1240 // File interfaces/oracles/IOracleProvider.sol
1241 
1242 pragma solidity 0.8.10;
1243 
1244 interface IOracleProvider {
1245     /// @notice Checks whether the asset is supported
1246     /// @param baseAsset the asset of which the price is to be quoted
1247     /// @return true if the asset is supported
1248     function isAssetSupported(address baseAsset) external view returns (bool);
1249 
1250     /// @notice Quotes the USD price of `baseAsset`
1251     /// @param baseAsset the asset of which the price is to be quoted
1252     /// @return the USD price of the asset
1253     function getPriceUSD(address baseAsset) external view returns (uint256);
1254 
1255     /// @notice Quotes the ETH price of `baseAsset`
1256     /// @param baseAsset the asset of which the price is to be quoted
1257     /// @return the ETH price of the asset
1258     function getPriceETH(address baseAsset) external view returns (uint256);
1259 }
1260 
1261 
1262 // File libraries/AddressProviderMeta.sol
1263 
1264 pragma solidity 0.8.10;
1265 
1266 library AddressProviderMeta {
1267     struct Meta {
1268         bool freezable;
1269         bool frozen;
1270     }
1271 
1272     function fromUInt(uint256 value) internal pure returns (Meta memory) {
1273         Meta memory meta;
1274         meta.freezable = (value & 1) == 1;
1275         meta.frozen = ((value >> 1) & 1) == 1;
1276         return meta;
1277     }
1278 
1279     function toUInt(Meta memory meta) internal pure returns (uint256) {
1280         uint256 value;
1281         value |= meta.freezable ? 1 : 0;
1282         value |= meta.frozen ? 1 << 1 : 0;
1283         return value;
1284     }
1285 }
1286 
1287 
1288 // File interfaces/IAddressProvider.sol
1289 
1290 pragma solidity 0.8.10;
1291 
1292 
1293 
1294 
1295 // solhint-disable ordering
1296 
1297 interface IAddressProvider {
1298     event KnownAddressKeyAdded(bytes32 indexed key);
1299     event StakerVaultListed(address indexed stakerVault);
1300     event StakerVaultDelisted(address indexed stakerVault);
1301     event ActionListed(address indexed action);
1302     event ActionShutdown(address indexed action);
1303     event PoolListed(address indexed pool);
1304     event VaultUpdated(address indexed previousVault, address indexed newVault);
1305     event FeeHandlerAdded(address feeHandler);
1306     event FeeHandlerRemoved(address feeHandler);
1307 
1308     /** Key functions */
1309     function getKnownAddressKeys() external view returns (bytes32[] memory);
1310 
1311     function freezeAddress(bytes32 key) external;
1312 
1313     /** Pool functions */
1314 
1315     function allPools() external view returns (address[] memory);
1316 
1317     function addPool(address pool) external;
1318 
1319     function poolsCount() external view returns (uint256);
1320 
1321     function getPoolAtIndex(uint256 index) external view returns (address);
1322 
1323     function isPool(address pool) external view returns (bool);
1324 
1325     function getPoolForToken(address token) external view returns (ILiquidityPool);
1326 
1327     function safeGetPoolForToken(address token) external view returns (address);
1328 
1329     /** Vault functions  */
1330 
1331     function updateVault(address previousVault, address newVault) external;
1332 
1333     function allVaults() external view returns (address[] memory);
1334 
1335     function vaultsCount() external view returns (uint256);
1336 
1337     function getVaultAtIndex(uint256 index) external view returns (address);
1338 
1339     function isVault(address vault) external view returns (bool);
1340 
1341     /** Action functions */
1342 
1343     function allActions() external view returns (address[] memory);
1344 
1345     function actionsCount() external view returns (uint256);
1346 
1347     function getActionAtIndex(uint256 index) external view returns (address);
1348 
1349     function allActiveActions() external view returns (address[] memory);
1350 
1351     function addAction(address action) external returns (bool);
1352 
1353     function shutdownAction(address action) external;
1354 
1355     function isAction(address action) external view returns (bool);
1356 
1357     function isActiveAction(address action) external view returns (bool);
1358 
1359     /** Address functions */
1360 
1361     function initialize(address roleManager_, address treasury_) external;
1362 
1363     function initializeAddress(bytes32 key, address initialAddress) external;
1364 
1365     function initializeAddress(
1366         bytes32 key,
1367         address initialAddress,
1368         bool frezable
1369     ) external;
1370 
1371     function initializeAndFreezeAddress(bytes32 key, address initialAddress) external;
1372 
1373     function getAddress(bytes32 key) external view returns (address);
1374 
1375     function getAddress(bytes32 key, bool checkExists) external view returns (address);
1376 
1377     function getAddressMeta(bytes32 key) external view returns (AddressProviderMeta.Meta memory);
1378 
1379     function updateAddress(bytes32 key, address newAddress) external;
1380 
1381     function initializeInflationManager(address initialAddress) external;
1382 
1383     /** Staker vault functions */
1384     function allStakerVaults() external view returns (address[] memory);
1385 
1386     function tryGetStakerVault(address token) external view returns (bool, address);
1387 
1388     function getStakerVault(address token) external view returns (address);
1389 
1390     function addStakerVault(address stakerVault) external;
1391 
1392     function isStakerVault(address stakerVault, address token) external view returns (bool);
1393 
1394     function isStakerVaultRegistered(address stakerVault) external view returns (bool);
1395 
1396     function isWhiteListedFeeHandler(address feeHandler) external view returns (bool);
1397 
1398     /** Fee Handler function */
1399     function addFeeHandler(address feeHandler) external;
1400 
1401     function removeFeeHandler(address feeHandler) external;
1402 }
1403 
1404 
1405 // File interfaces/actions/IAction.sol
1406 
1407 pragma solidity 0.8.10;
1408 
1409 interface IAction {
1410     event UsableTokenAdded(address token);
1411     event UsableTokenRemoved(address token);
1412     event Paused();
1413     event Unpaused();
1414     event Shutdown();
1415 
1416     function addUsableToken(address token) external;
1417 
1418     function removeUsableToken(address token) external;
1419 
1420     function updateActionFee(uint256 actionFee) external;
1421 
1422     function updateFeeHandler(address feeHandler) external;
1423 
1424     function shutdownAction() external;
1425 
1426     function pause() external;
1427 
1428     function unpause() external;
1429 
1430     function getEthRequiredForGas(address payer) external view returns (uint256);
1431 
1432     function getUsableTokens() external view returns (address[] memory);
1433 
1434     function isUsable(address token) external view returns (bool);
1435 
1436     function feeHandler() external view returns (address);
1437 
1438     function isShutdown() external view returns (bool);
1439 
1440     function isPaused() external view returns (bool);
1441 }
1442 
1443 
1444 // File interfaces/tokenomics/IInflationManager.sol
1445 
1446 pragma solidity 0.8.10;
1447 
1448 interface IInflationManager {
1449     event KeeperGaugeListed(address indexed pool, address indexed keeperGauge);
1450     event AmmGaugeListed(address indexed token, address indexed ammGauge);
1451     event KeeperGaugeDelisted(address indexed pool, address indexed keeperGauge);
1452     event AmmGaugeDelisted(address indexed token, address indexed ammGauge);
1453 
1454     /** Pool functions */
1455 
1456     function setKeeperGauge(address pool, address _keeperGauge) external returns (bool);
1457 
1458     function setAmmGauge(address token, address _ammGauge) external returns (bool);
1459 
1460     function setMinter(address _minter) external;
1461 
1462     function advanceKeeperGaugeEpoch(address pool) external;
1463 
1464     function whitelistGauge(address gauge) external;
1465 
1466     function removeStakerVaultFromInflation(address lpToken) external;
1467 
1468     function removeAmmGauge(address token) external returns (bool);
1469 
1470     function addGaugeForVault(address lpToken) external;
1471 
1472     function checkpointAllGauges(uint256 updateEndTime) external;
1473 
1474     function mintRewards(address beneficiary, uint256 amount) external;
1475 
1476     function checkPointInflation() external;
1477 
1478     function removeKeeperGauge(address pool) external;
1479 
1480     function getAllAmmGauges() external view returns (address[] memory);
1481 
1482     function getLpRateForStakerVault(address stakerVault) external view returns (uint256);
1483 
1484     function getKeeperRateForPool(address pool) external view returns (uint256);
1485 
1486     function getAmmRateForToken(address token) external view returns (uint256);
1487 
1488     function getLpPoolWeight(address pool) external view returns (uint256);
1489 
1490     function getKeeperGaugeForPool(address pool) external view returns (address);
1491 
1492     function getAmmGaugeForToken(address token) external view returns (address);
1493 
1494     function gauges(address lpToken) external view returns (bool);
1495 
1496     function ammWeights(address gauge) external view returns (uint256);
1497 
1498     function lpPoolWeights(address gauge) external view returns (uint256);
1499 
1500     function keeperPoolWeights(address gauge) external view returns (uint256);
1501 
1502     function minter() external view returns (address);
1503 
1504     function weightBasedKeeperDistributionDeactivated() external view returns (bool);
1505 
1506     function totalKeeperPoolWeight() external view returns (uint256);
1507 
1508     function totalLpPoolWeight() external view returns (uint256);
1509 
1510     function totalAmmTokenWeight() external view returns (uint256);
1511 
1512     /** Weight setter functions **/
1513 
1514     function updateLpPoolWeight(address lpToken, uint256 newPoolWeight) external;
1515 
1516     function updateAmmTokenWeight(address token, uint256 newTokenWeight) external;
1517 
1518     function updateKeeperPoolWeight(address pool, uint256 newPoolWeight) external;
1519 
1520     function batchUpdateLpPoolWeights(address[] calldata lpTokens, uint256[] calldata weights)
1521         external;
1522 
1523     function batchUpdateAmmTokenWeights(address[] calldata tokens, uint256[] calldata weights)
1524         external;
1525 
1526     function batchUpdateKeeperPoolWeights(address[] calldata pools, uint256[] calldata weights)
1527         external;
1528 
1529     function deactivateWeightBasedKeeperDistribution() external;
1530 }
1531 
1532 
1533 // File interfaces/IController.sol
1534 
1535 pragma solidity 0.8.10;
1536 
1537 
1538 
1539 
1540 
1541 // solhint-disable ordering
1542 
1543 interface IController {
1544     function addressProvider() external view returns (IAddressProvider);
1545 
1546     function addStakerVault(address stakerVault) external;
1547 
1548     function shutdownPool(ILiquidityPool pool, bool shutdownStrategy) external returns (bool);
1549 
1550     function shutdownAction(IAction action) external;
1551 
1552     /** Keeper functions */
1553     function updateKeeperRequiredStakedMERO(uint256 amount) external;
1554 
1555     function canKeeperExecuteAction(address keeper) external view returns (bool);
1556 
1557     function keeperRequireStakedMero() external view returns (uint256);
1558 
1559     /** Miscellaneous functions */
1560 
1561     function getTotalEthRequiredForGas(address payer) external view returns (uint256);
1562 }
1563 
1564 
1565 // File @openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol@v4.5.1
1566 
1567 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
1568 
1569 pragma solidity ^0.8.0;
1570 
1571 /**
1572  * @dev Interface of the ERC20 standard as defined in the EIP.
1573  */
1574 interface IERC20Upgradeable {
1575     /**
1576      * @dev Returns the amount of tokens in existence.
1577      */
1578     function totalSupply() external view returns (uint256);
1579 
1580     /**
1581      * @dev Returns the amount of tokens owned by `account`.
1582      */
1583     function balanceOf(address account) external view returns (uint256);
1584 
1585     /**
1586      * @dev Moves `amount` tokens from the caller's account to `to`.
1587      *
1588      * Returns a boolean value indicating whether the operation succeeded.
1589      *
1590      * Emits a {Transfer} event.
1591      */
1592     function transfer(address to, uint256 amount) external returns (bool);
1593 
1594     /**
1595      * @dev Returns the remaining number of tokens that `spender` will be
1596      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1597      * zero by default.
1598      *
1599      * This value changes when {approve} or {transferFrom} are called.
1600      */
1601     function allowance(address owner, address spender) external view returns (uint256);
1602 
1603     /**
1604      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1605      *
1606      * Returns a boolean value indicating whether the operation succeeded.
1607      *
1608      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1609      * that someone may use both the old and the new allowance by unfortunate
1610      * transaction ordering. One possible solution to mitigate this race
1611      * condition is to first reduce the spender's allowance to 0 and set the
1612      * desired value afterwards:
1613      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1614      *
1615      * Emits an {Approval} event.
1616      */
1617     function approve(address spender, uint256 amount) external returns (bool);
1618 
1619     /**
1620      * @dev Moves `amount` tokens from `from` to `to` using the
1621      * allowance mechanism. `amount` is then deducted from the caller's
1622      * allowance.
1623      *
1624      * Returns a boolean value indicating whether the operation succeeded.
1625      *
1626      * Emits a {Transfer} event.
1627      */
1628     function transferFrom(
1629         address from,
1630         address to,
1631         uint256 amount
1632     ) external returns (bool);
1633 
1634     /**
1635      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1636      * another (`to`).
1637      *
1638      * Note that `value` may be zero.
1639      */
1640     event Transfer(address indexed from, address indexed to, uint256 value);
1641 
1642     /**
1643      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1644      * a call to {approve}. `value` is the new allowance.
1645      */
1646     event Approval(address indexed owner, address indexed spender, uint256 value);
1647 }
1648 
1649 
1650 // File interfaces/ILpToken.sol
1651 
1652 pragma solidity 0.8.10;
1653 
1654 interface ILpToken is IERC20Upgradeable {
1655     function mint(address account, uint256 lpTokens) external;
1656 
1657     function burn(address account, uint256 burnAmount) external returns (uint256);
1658 
1659     function burn(uint256 burnAmount) external;
1660 
1661     function minter() external view returns (address);
1662 
1663     function initialize(
1664         string memory name_,
1665         string memory symbol_,
1666         uint8 _decimals,
1667         address _minter
1668     ) external returns (bool);
1669 }
1670 
1671 
1672 // File interfaces/IVaultReserve.sol
1673 
1674 pragma solidity 0.8.10;
1675 
1676 interface IVaultReserve {
1677     event Deposit(address indexed vault, address indexed token, uint256 amount);
1678     event Withdraw(address indexed vault, address indexed token, uint256 amount);
1679     event VaultListed(address indexed vault);
1680 
1681     function deposit(address token, uint256 amount) external payable;
1682 
1683     function withdraw(address token, uint256 amount) external;
1684 
1685     function getBalance(address vault, address token) external view returns (uint256);
1686 
1687     function canWithdraw(address vault) external view returns (bool);
1688 }
1689 
1690 
1691 // File interfaces/IRoleManager.sol
1692 
1693 pragma solidity 0.8.10;
1694 
1695 interface IRoleManager {
1696     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1697 
1698     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1699 
1700     function initialize() external;
1701 
1702     function grantRole(bytes32 role, address account) external;
1703 
1704     function addGovernor(address newGovernor) external;
1705 
1706     function renounceGovernance() external;
1707 
1708     function addGaugeZap(address zap) external;
1709 
1710     function removeGaugeZap(address zap) external;
1711 
1712     function revokeRole(bytes32 role, address account) external;
1713 
1714     function hasRole(bytes32 role, address account) external view returns (bool);
1715 
1716     function hasAnyRole(bytes32[] memory roles, address account) external view returns (bool);
1717 
1718     function hasAnyRole(
1719         bytes32 role1,
1720         bytes32 role2,
1721         address account
1722     ) external view returns (bool);
1723 
1724     function hasAnyRole(
1725         bytes32 role1,
1726         bytes32 role2,
1727         bytes32 role3,
1728         address account
1729     ) external view returns (bool);
1730 
1731     function getRoleMemberCount(bytes32 role) external view returns (uint256);
1732 
1733     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
1734 }
1735 
1736 
1737 // File interfaces/IFeeBurner.sol
1738 
1739 pragma solidity 0.8.10;
1740 
1741 interface IFeeBurner {
1742     function burnToTarget(address[] memory tokens, address targetLpToken)
1743         external
1744         payable
1745         returns (uint256);
1746 }
1747 
1748 
1749 // File interfaces/tokenomics/IMeroToken.sol
1750 
1751 pragma solidity 0.8.10;
1752 
1753 interface IMeroToken is IERC20 {
1754     function mint(address account, uint256 amount) external;
1755 
1756     function cap() external view returns (uint256);
1757 }
1758 
1759 
1760 // File interfaces/ISwapperRouter.sol
1761 
1762 pragma solidity 0.8.10;
1763 
1764 interface ISwapperRouter {
1765     function swapAll(address fromToken, address toToken) external payable returns (uint256);
1766 
1767     function setSlippageTolerance(uint256 slippageTolerance_) external;
1768 
1769     function setCurvePool(address token_, address curvePool_) external;
1770 
1771     function swap(
1772         address fromToken,
1773         address toToken,
1774         uint256 amountIn
1775     ) external payable returns (uint256);
1776 
1777     function getAmountOut(
1778         address fromToken,
1779         address toToken,
1780         uint256 amountIn
1781     ) external view returns (uint256 amountOut);
1782 }
1783 
1784 
1785 // File libraries/AddressProviderKeys.sol
1786 
1787 pragma solidity 0.8.10;
1788 
1789 library AddressProviderKeys {
1790     bytes32 internal constant _TREASURY_KEY = "treasury";
1791     bytes32 internal constant _REWARD_HANDLER_KEY = "rewardHandler";
1792     bytes32 internal constant _GAS_BANK_KEY = "gasBank";
1793     bytes32 internal constant _VAULT_RESERVE_KEY = "vaultReserve";
1794     bytes32 internal constant _ORACLE_PROVIDER_KEY = "oracleProvider";
1795     bytes32 internal constant _POOL_FACTORY_KEY = "poolFactory";
1796     bytes32 internal constant _CONTROLLER_KEY = "controller";
1797     bytes32 internal constant _MERO_LOCKER_KEY = "meroLocker";
1798     bytes32 internal constant _INFLATION_MANAGER_KEY = "inflationManager";
1799     bytes32 internal constant _FEE_BURNER_KEY = "feeBurner";
1800     bytes32 internal constant _ROLE_MANAGER_KEY = "roleManager";
1801     bytes32 internal constant _SWAPPER_ROUTER_KEY = "swapperRouter";
1802 }
1803 
1804 
1805 // File libraries/AddressProviderHelpers.sol
1806 
1807 pragma solidity 0.8.10;
1808 
1809 
1810 
1811 
1812 
1813 
1814 
1815 
1816 
1817 library AddressProviderHelpers {
1818     /**
1819      * @return The address of the treasury.
1820      */
1821     function getTreasury(IAddressProvider provider) internal view returns (address) {
1822         return provider.getAddress(AddressProviderKeys._TREASURY_KEY);
1823     }
1824 
1825     /**
1826      * @return The address of the reward handler.
1827      */
1828     function getRewardHandler(IAddressProvider provider) internal view returns (address) {
1829         return provider.getAddress(AddressProviderKeys._REWARD_HANDLER_KEY);
1830     }
1831 
1832     /**
1833      * @dev Returns zero address if no reward handler is set.
1834      * @return The address of the reward handler.
1835      */
1836     function getSafeRewardHandler(IAddressProvider provider) internal view returns (address) {
1837         return provider.getAddress(AddressProviderKeys._REWARD_HANDLER_KEY, false);
1838     }
1839 
1840     /**
1841      * @return The address of the fee burner.
1842      */
1843     function getFeeBurner(IAddressProvider provider) internal view returns (IFeeBurner) {
1844         return IFeeBurner(provider.getAddress(AddressProviderKeys._FEE_BURNER_KEY));
1845     }
1846 
1847     /**
1848      * @return The gas bank.
1849      */
1850     function getGasBank(IAddressProvider provider) internal view returns (IGasBank) {
1851         return IGasBank(provider.getAddress(AddressProviderKeys._GAS_BANK_KEY));
1852     }
1853 
1854     /**
1855      * @return The address of the vault reserve.
1856      */
1857     function getVaultReserve(IAddressProvider provider) internal view returns (IVaultReserve) {
1858         return IVaultReserve(provider.getAddress(AddressProviderKeys._VAULT_RESERVE_KEY));
1859     }
1860 
1861     /**
1862      * @return The oracleProvider.
1863      */
1864     function getOracleProvider(IAddressProvider provider) internal view returns (IOracleProvider) {
1865         return IOracleProvider(provider.getAddress(AddressProviderKeys._ORACLE_PROVIDER_KEY));
1866     }
1867 
1868     /**
1869      * @return the address of the MERO locker
1870      */
1871     function getMEROLocker(IAddressProvider provider) internal view returns (address) {
1872         return provider.getAddress(AddressProviderKeys._MERO_LOCKER_KEY);
1873     }
1874 
1875     /**
1876      * @return the address of the MERO locker
1877      */
1878     function getRoleManager(IAddressProvider provider) internal view returns (IRoleManager) {
1879         return IRoleManager(provider.getAddress(AddressProviderKeys._ROLE_MANAGER_KEY));
1880     }
1881 
1882     /**
1883      * @return the controller
1884      */
1885     function getController(IAddressProvider provider) internal view returns (IController) {
1886         return IController(provider.getAddress(AddressProviderKeys._CONTROLLER_KEY));
1887     }
1888 
1889     /**
1890      * @return the inflation manager
1891      */
1892     function getInflationManager(IAddressProvider provider)
1893         internal
1894         view
1895         returns (IInflationManager)
1896     {
1897         return IInflationManager(provider.getAddress(AddressProviderKeys._INFLATION_MANAGER_KEY));
1898     }
1899 
1900     /**
1901      * @return the inflation manager or `address(0)` if it does not exist
1902      */
1903     function safeGetInflationManager(IAddressProvider provider)
1904         internal
1905         view
1906         returns (IInflationManager)
1907     {
1908         return
1909             IInflationManager(
1910                 provider.getAddress(AddressProviderKeys._INFLATION_MANAGER_KEY, false)
1911             );
1912     }
1913 
1914     /**
1915      * @return the swapper router
1916      */
1917     function getSwapperRouter(IAddressProvider provider) internal view returns (ISwapperRouter) {
1918         return ISwapperRouter(provider.getAddress(AddressProviderKeys._SWAPPER_ROUTER_KEY));
1919     }
1920 }
1921 
1922 
1923 // File libraries/Errors.sol
1924 
1925 pragma solidity 0.8.10;
1926 
1927 // solhint-disable private-vars-leading-underscore
1928 
1929 library Error {
1930     string internal constant ADDRESS_WHITELISTED = "address already whitelisted";
1931     string internal constant ADMIN_ALREADY_SET = "admin has already been set once";
1932     string internal constant ADDRESS_NOT_WHITELISTED = "address not whitelisted";
1933     string internal constant ADDRESS_NOT_FOUND = "address not found";
1934     string internal constant CONTRACT_INITIALIZED = "contract can only be initialized once";
1935     string internal constant CONTRACT_PAUSED = "contract is paused";
1936     string internal constant UNAUTHORIZED_PAUSE = "not authorized to pause";
1937     string internal constant INVALID_AMOUNT = "invalid amount";
1938     string internal constant INVALID_INDEX = "invalid index";
1939     string internal constant INVALID_VALUE = "invalid msg.value";
1940     string internal constant INVALID_SENDER = "invalid msg.sender";
1941     string internal constant INVALID_TOKEN = "token address does not match pool's LP token address";
1942     string internal constant INVALID_DECIMALS = "incorrect number of decimals";
1943     string internal constant INVALID_ARGUMENT = "invalid argument";
1944     string internal constant INVALID_PARAMETER_VALUE = "invalid parameter value attempted";
1945     string internal constant INVALID_IMPLEMENTATION = "invalid pool implementation for given coin";
1946     string internal constant INVALID_POOL_IMPLEMENTATION =
1947         "invalid pool implementation for given coin";
1948     string internal constant INVALID_LP_TOKEN_IMPLEMENTATION =
1949         "invalid LP Token implementation for given coin";
1950     string internal constant INVALID_VAULT_IMPLEMENTATION =
1951         "invalid vault implementation for given coin";
1952     string internal constant INVALID_STAKER_VAULT_IMPLEMENTATION =
1953         "invalid stakerVault implementation for given coin";
1954     string internal constant INSUFFICIENT_ALLOWANCE = "insufficient allowance";
1955     string internal constant INSUFFICIENT_BALANCE = "insufficient balance";
1956     string internal constant INSUFFICIENT_AMOUNT_OUT = "Amount received less than min amount";
1957     string internal constant PROXY_CALL_FAILED = "proxy call failed";
1958     string internal constant INSUFFICIENT_AMOUNT_IN = "Amount spent more than max amount";
1959     string internal constant ADDRESS_ALREADY_SET = "Address is already set";
1960     string internal constant INSUFFICIENT_STRATEGY_BALANCE = "insufficient strategy balance";
1961     string internal constant INSUFFICIENT_FUNDS_RECEIVED = "insufficient funds received";
1962     string internal constant ADDRESS_DOES_NOT_EXIST = "address does not exist";
1963     string internal constant ADDRESS_FROZEN = "address is frozen";
1964     string internal constant ROLE_EXISTS = "role already exists";
1965     string internal constant CANNOT_REVOKE_ROLE = "cannot revoke role";
1966     string internal constant UNAUTHORIZED_ACCESS = "unauthorized access";
1967     string internal constant SAME_ADDRESS_NOT_ALLOWED = "same address not allowed";
1968     string internal constant SELF_TRANSFER_NOT_ALLOWED = "self-transfer not allowed";
1969     string internal constant ZERO_ADDRESS_NOT_ALLOWED = "zero address not allowed";
1970     string internal constant ZERO_TRANSFER_NOT_ALLOWED = "zero transfer not allowed";
1971     string internal constant THRESHOLD_TOO_HIGH = "threshold is too high, must be under 10";
1972     string internal constant INSUFFICIENT_THRESHOLD = "insufficient threshold";
1973     string internal constant NO_POSITION_EXISTS = "no position exists";
1974     string internal constant POSITION_ALREADY_EXISTS = "position already exists";
1975     string internal constant CANNOT_EXECUTE_IN_SAME_BLOCK = "cannot execute action in same block";
1976     string internal constant PROTOCOL_NOT_FOUND = "protocol not found";
1977     string internal constant TOP_UP_FAILED = "top up failed";
1978     string internal constant SWAP_PATH_NOT_FOUND = "swap path not found";
1979     string internal constant UNDERLYING_NOT_SUPPORTED = "underlying token not supported";
1980     string internal constant NOT_ENOUGH_FUNDS_WITHDRAWN =
1981         "not enough funds were withdrawn from the pool";
1982     string internal constant FAILED_TRANSFER = "transfer failed";
1983     string internal constant FAILED_MINT = "mint failed";
1984     string internal constant FAILED_REPAY_BORROW = "repay borrow failed";
1985     string internal constant FAILED_METHOD_CALL = "method call failed";
1986     string internal constant NOTHING_TO_CLAIM = "there is no claimable balance";
1987     string internal constant ERC20_BALANCE_EXCEEDED = "ERC20: transfer amount exceeds balance";
1988     string internal constant INVALID_MINTER =
1989         "the minter address of the LP token and the pool address do not match";
1990     string internal constant STAKER_VAULT_EXISTS = "a staker vault already exists for the token";
1991     string internal constant DEADLINE_NOT_ZERO = "deadline must be 0";
1992     string internal constant NOTHING_PENDING = "no pending change to reset";
1993     string internal constant DEADLINE_NOT_SET = "deadline is 0";
1994     string internal constant DEADLINE_NOT_REACHED = "deadline has not been reached yet";
1995     string internal constant DELAY_TOO_SHORT = "delay must be at least 3 days";
1996     string internal constant INSUFFICIENT_UPDATE_BALANCE =
1997         "insufficient funds for updating the position";
1998     string internal constant SAME_AS_CURRENT = "value must be different to existing value";
1999     string internal constant NOT_CAPPED = "the pool is not currently capped";
2000     string internal constant ALREADY_CAPPED = "the pool is already capped";
2001     string internal constant ALREADY_SHUTDOWN = "already shutdown";
2002     string internal constant EXCEEDS_DEPOSIT_CAP = "deposit exceeds deposit cap";
2003     string internal constant VALUE_TOO_LOW_FOR_GAS = "value too low to cover gas";
2004     string internal constant NOT_ENOUGH_FUNDS = "not enough funds to withdraw";
2005     string internal constant ESTIMATED_GAS_TOO_HIGH = "too much ETH will be used for gas";
2006     string internal constant GAUGE_KILLED = "gauge killed";
2007     string internal constant INVALID_TARGET = "Invalid Target";
2008     string internal constant DEPOSIT_FAILED = "deposit failed";
2009     string internal constant GAS_TOO_HIGH = "too much ETH used for gas";
2010     string internal constant GAS_BANK_BALANCE_TOO_LOW = "not enough ETH in gas bank to cover gas";
2011     string internal constant INVALID_TOKEN_TO_ADD = "Invalid token to add";
2012     string internal constant INVALID_TOKEN_TO_REMOVE = "token can not be removed";
2013     string internal constant TIME_DELAY_NOT_EXPIRED = "time delay not expired yet";
2014     string internal constant UNDERLYING_NOT_WITHDRAWABLE =
2015         "pool does not support additional underlying coins to be withdrawn";
2016     string internal constant STRATEGY_SHUTDOWN = "Strategy is shutdown";
2017     string internal constant POOL_SHUTDOWN = "Pool is shutdown";
2018     string internal constant ACTION_SHUTDOWN = "Action is shutdown";
2019     string internal constant ACTION_PAUSED = "Action is paused";
2020     string internal constant STRATEGY_DOES_NOT_EXIST = "Strategy does not exist";
2021     string internal constant GAUGE_STILL_ACTIVE = "Gauge still active";
2022     string internal constant UNSUPPORTED_UNDERLYING = "Underlying not supported";
2023     string internal constant NO_DEX_SET = "no dex has been set for token";
2024     string internal constant INVALID_TOKEN_PAIR = "invalid token pair";
2025     string internal constant TOKEN_NOT_USABLE = "token not usable for the specific action";
2026     string internal constant ADDRESS_NOT_ACTION = "address is not registered action";
2027     string internal constant ACTION_NOT_ACTIVE = "address is not active action";
2028     string internal constant INVALID_SLIPPAGE_TOLERANCE = "Invalid slippage tolerance";
2029     string internal constant INVALID_MAX_FEE = "invalid max fee";
2030     string internal constant POOL_NOT_PAUSED = "Pool must be paused to withdraw from reserve";
2031     string internal constant INTERACTION_LIMIT = "Max of one deposit and withdraw per block";
2032     string internal constant GAUGE_EXISTS = "Gauge already exists";
2033     string internal constant GAUGE_DOES_NOT_EXIST = "Gauge does not exist";
2034     string internal constant EXCEEDS_MAX_BOOST = "Not allowed to exceed maximum boost on Convex";
2035     string internal constant PREPARED_WITHDRAWAL =
2036         "Cannot relock funds when withdrawal is being prepared";
2037     string internal constant ASSET_NOT_SUPPORTED = "Asset not supported";
2038     string internal constant STALE_PRICE = "Price is stale";
2039     string internal constant NEGATIVE_PRICE = "Price is negative";
2040     string internal constant ROUND_NOT_COMPLETE = "Round not complete";
2041     string internal constant NOT_ENOUGH_MERO_STAKED = "Not enough MERO tokens staked";
2042     string internal constant RESERVE_ACCESS_EXCEEDED = "Reserve access exceeded";
2043 }
2044 
2045 
2046 // File libraries/ScaledMath.sol
2047 
2048 pragma solidity 0.8.10;
2049 
2050 /*
2051  * @dev To use functions of this contract, at least one of the numbers must
2052  * be scaled to `DECIMAL_SCALE`. The result will scaled to `DECIMAL_SCALE`
2053  * if both numbers are scaled to `DECIMAL_SCALE`, otherwise to the scale
2054  * of the number not scaled by `DECIMAL_SCALE`
2055  */
2056 library ScaledMath {
2057     // solhint-disable-next-line private-vars-leading-underscore
2058     uint256 internal constant DECIMAL_SCALE = 1e18;
2059     // solhint-disable-next-line private-vars-leading-underscore
2060     uint256 internal constant ONE = 1e18;
2061 
2062     /**
2063      * @notice Performs a multiplication between two scaled numbers
2064      */
2065     function scaledMul(uint256 a, uint256 b) internal pure returns (uint256) {
2066         return (a * b) / DECIMAL_SCALE;
2067     }
2068 
2069     /**
2070      * @notice Performs a division between two scaled numbers
2071      */
2072     function scaledDiv(uint256 a, uint256 b) internal pure returns (uint256) {
2073         return (a * DECIMAL_SCALE) / b;
2074     }
2075 
2076     /**
2077      * @notice Performs a division between two numbers, rounding up the result
2078      */
2079     function scaledDivRoundUp(uint256 a, uint256 b) internal pure returns (uint256) {
2080         return (a * DECIMAL_SCALE + b - 1) / b;
2081     }
2082 
2083     /**
2084      * @notice Performs a division between two numbers, ignoring any scaling and rounding up the result
2085      */
2086     function divRoundUp(uint256 a, uint256 b) internal pure returns (uint256) {
2087         return (a + b - 1) / b;
2088     }
2089 }
2090 
2091 
2092 // File libraries/Roles.sol
2093 
2094 pragma solidity 0.8.10;
2095 
2096 // solhint-disable private-vars-leading-underscore
2097 
2098 library Roles {
2099     bytes32 internal constant GOVERNANCE = "governance";
2100     bytes32 internal constant ADDRESS_PROVIDER = "address_provider";
2101     bytes32 internal constant POOL_FACTORY = "pool_factory";
2102     bytes32 internal constant CONTROLLER = "controller";
2103     bytes32 internal constant GAUGE_ZAP = "gauge_zap";
2104     bytes32 internal constant MAINTENANCE = "maintenance";
2105     bytes32 internal constant INFLATION_ADMIN = "inflation_admin";
2106     bytes32 internal constant INFLATION_MANAGER = "inflation_manager";
2107     bytes32 internal constant POOL = "pool";
2108     bytes32 internal constant VAULT = "vault";
2109     bytes32 internal constant ACTION = "action";
2110 }
2111 
2112 
2113 // File contracts/access/AuthorizationBase.sol
2114 
2115 pragma solidity 0.8.10;
2116 
2117 
2118 /**
2119  * @notice Provides modifiers for authorization
2120  */
2121 abstract contract AuthorizationBase {
2122     /**
2123      * @notice Only allows a sender with `role` to perform the given action
2124      */
2125     modifier onlyRole(bytes32 role) {
2126         require(_roleManager().hasRole(role, msg.sender), Error.UNAUTHORIZED_ACCESS);
2127         _;
2128     }
2129 
2130     /**
2131      * @notice Only allows a sender with GOVERNANCE role to perform the given action
2132      */
2133     modifier onlyGovernance() {
2134         require(_roleManager().hasRole(Roles.GOVERNANCE, msg.sender), Error.UNAUTHORIZED_ACCESS);
2135         _;
2136     }
2137 
2138     /**
2139      * @notice Only allows a sender with any of `roles` to perform the given action
2140      */
2141     modifier onlyRoles2(bytes32 role1, bytes32 role2) {
2142         require(_roleManager().hasAnyRole(role1, role2, msg.sender), Error.UNAUTHORIZED_ACCESS);
2143         _;
2144     }
2145 
2146     /**
2147      * @notice Only allows a sender with any of `roles` to perform the given action
2148      */
2149     modifier onlyRoles3(
2150         bytes32 role1,
2151         bytes32 role2,
2152         bytes32 role3
2153     ) {
2154         require(
2155             _roleManager().hasAnyRole(role1, role2, role3, msg.sender),
2156             Error.UNAUTHORIZED_ACCESS
2157         );
2158         _;
2159     }
2160 
2161     function roleManager() external view virtual returns (IRoleManager) {
2162         return _roleManager();
2163     }
2164 
2165     function _roleManager() internal view virtual returns (IRoleManager);
2166 }
2167 
2168 
2169 // File contracts/access/Authorization.sol
2170 
2171 pragma solidity 0.8.10;
2172 
2173 contract Authorization is AuthorizationBase {
2174     IRoleManager internal immutable __roleManager;
2175 
2176     constructor(IRoleManager roleManager) {
2177         __roleManager = roleManager;
2178     }
2179 
2180     function _roleManager() internal view override returns (IRoleManager) {
2181         return __roleManager;
2182     }
2183 }
2184 
2185 
2186 // File contracts/utils/Pausable.sol
2187 
2188 pragma solidity 0.8.10;
2189 
2190 abstract contract Pausable {
2191     bool public isPaused;
2192 
2193     modifier notPaused() {
2194         require(!isPaused, Error.CONTRACT_PAUSED);
2195         _;
2196     }
2197 
2198     modifier onlyAuthorizedToPause() {
2199         require(_isAuthorizedToPause(msg.sender), Error.UNAUTHORIZED_PAUSE);
2200         _;
2201     }
2202 
2203     /**
2204      * @notice Pause the contract.
2205      */
2206     function pause() external onlyAuthorizedToPause {
2207         isPaused = true;
2208     }
2209 
2210     /**
2211      * @notice Unpause the contract.
2212      */
2213     function unpause() external onlyAuthorizedToPause {
2214         isPaused = false;
2215     }
2216 
2217     /**
2218      * @notice Returns true if `account` is authorized to pause the contract
2219      * @dev This should be implemented in contracts inheriting `Pausable`
2220      * to provide proper access control
2221      */
2222     function _isAuthorizedToPause(address account) internal view virtual returns (bool);
2223 }
2224 
2225 
2226 // File contracts/pool/LiquidityPool.sol
2227 
2228 pragma solidity 0.8.10;
2229 
2230 
2231 
2232 
2233 
2234 
2235 
2236 
2237 
2238 
2239 /**
2240  * @dev Pausing/unpausing the pool will disable/re-enable deposits.
2241  */
2242 abstract contract LiquidityPool is ILiquidityPool, Authorization, Pausable, Initializable {
2243     using AddressProviderHelpers for IAddressProvider;
2244     using ScaledMath for uint256;
2245     using SafeERC20 for IERC20;
2246     using SafeCast for uint256;
2247 
2248     struct WithdrawalFeeMeta {
2249         uint64 timeToWait;
2250         uint64 feeRatio;
2251         uint64 lastActionTimestamp;
2252     }
2253 
2254     IVault public vault;
2255     uint256 public reserveDeviation = 0.005e18;
2256     uint256 public requiredReserves = ScaledMath.ONE;
2257     uint256 public maxWithdrawalFee;
2258     uint256 public minWithdrawalFee;
2259     uint256 public withdrawalFeeDecreasePeriod = 1 weeks;
2260 
2261     /**
2262      * @notice even through admin votes and later governance, the withdrawal
2263      * fee will never be able to go above this value
2264      */
2265     uint256 internal constant _MAX_WITHDRAWAL_FEE = 0.05e18;
2266 
2267     /**
2268      * @notice Keeps track of the withdrawal fees on a per-address basis
2269      */
2270     mapping(address => WithdrawalFeeMeta) public withdrawalFeeMetas;
2271 
2272     IController public immutable controller;
2273     IAddressProvider public immutable addressProvider;
2274 
2275     IStakerVault public staker;
2276     ILpToken public lpToken;
2277     string public name;
2278 
2279     bool internal _shutdown;
2280 
2281     event RequiredReservesUpdated(uint256 requireReserves);
2282     event ReserveDeviationUpdated(uint256 reserveDeviation);
2283     event MinWithdrawalFeeUpdated(uint256 minWithdrawalFee);
2284     event MaxWithdrawalFeeUpdated(uint256 maxWithdrawalFee);
2285     event WithdrawalFeeDecreasePeriodUpdated(uint256 withdrawalFeeDecreasePeriod);
2286     event VaultUpdated(address vault);
2287 
2288     modifier notShutdown() {
2289         require(!_shutdown, Error.POOL_SHUTDOWN);
2290         _;
2291     }
2292 
2293     constructor(IController _controller)
2294         Authorization(_controller.addressProvider().getRoleManager())
2295     {
2296         controller = IController(_controller);
2297         addressProvider = IController(_controller).addressProvider();
2298     }
2299 
2300     /**
2301      * @notice Deposit funds into liquidity pool and mint LP tokens in exchange.
2302      * @param depositAmount Amount of the underlying asset to supply.
2303      * @return The actual amount minted.
2304      */
2305     function deposit(uint256 depositAmount) external payable override returns (uint256) {
2306         return depositFor(msg.sender, depositAmount, 0);
2307     }
2308 
2309     /**
2310      * @notice Deposit funds into liquidity pool and mint LP tokens in exchange.
2311      * @param depositAmount Amount of the underlying asset to supply.
2312      * @param minTokenAmount Minimum amount of LP tokens that should be minted.
2313      * @return The actual amount minted.
2314      */
2315     function deposit(uint256 depositAmount, uint256 minTokenAmount)
2316         external
2317         payable
2318         override
2319         returns (uint256)
2320     {
2321         return depositFor(msg.sender, depositAmount, minTokenAmount);
2322     }
2323 
2324     /**
2325      * @notice Deposit funds into liquidity pool and stake LP Tokens in Staker Vault.
2326      * @param depositAmount Amount of the underlying asset to supply.
2327      * @param minTokenAmount Minimum amount of LP tokens that should be minted.
2328      * @return The actual amount minted and staked.
2329      */
2330     function depositAndStake(uint256 depositAmount, uint256 minTokenAmount)
2331         external
2332         payable
2333         override
2334         returns (uint256)
2335     {
2336         uint256 amountMinted_ = depositFor(address(this), depositAmount, minTokenAmount);
2337         staker.stakeFor(msg.sender, amountMinted_);
2338         return amountMinted_;
2339     }
2340 
2341     /**
2342      * @notice Withdraws all funds from vault.
2343      * @dev Should be called in case of emergencies.
2344      */
2345     function shutdownStrategy() external override onlyGovernance {
2346         vault.shutdownStrategy();
2347     }
2348 
2349     /**
2350      * @notice permanently shuts down the pool
2351      * @param _shutdownStrategy if true, will also shut down the strategy
2352      * and withdraw all the funds back to the pool
2353      */
2354     function shutdownPool(bool _shutdownStrategy) external onlyRole(Roles.CONTROLLER) {
2355         require(!_shutdown, Error.ALREADY_SHUTDOWN);
2356 
2357         _shutdown = true;
2358         maxWithdrawalFee = 0;
2359         minWithdrawalFee = 0;
2360 
2361         if (_shutdownStrategy) {
2362             vault.shutdownStrategy();
2363         } else {
2364             vault.withdrawAvailableToPool();
2365         }
2366 
2367         emit Shutdown();
2368     }
2369 
2370     function setLpToken(address _lpToken)
2371         external
2372         override
2373         onlyRoles2(Roles.GOVERNANCE, Roles.POOL_FACTORY)
2374     {
2375         require(address(lpToken) == address(0), Error.ADDRESS_ALREADY_SET);
2376         require(ILpToken(_lpToken).minter() == address(this), Error.INVALID_MINTER);
2377         lpToken = ILpToken(_lpToken);
2378         _approveStakerVaultSpendingLpTokens();
2379         emit LpTokenSet(_lpToken);
2380     }
2381 
2382     /**
2383      * @notice Checkpoint function to update a user's withdrawal fees on deposit and redeem
2384      * @param from Address sending from
2385      * @param to Address sending to
2386      * @param amount Amount to redeem or deposit
2387      */
2388     function handleLpTokenTransfer(
2389         address from,
2390         address to,
2391         uint256 amount
2392     ) external override {
2393         require(
2394             msg.sender == address(lpToken) || msg.sender == address(staker),
2395             Error.UNAUTHORIZED_ACCESS
2396         );
2397         if (
2398             addressProvider.isStakerVault(to, address(lpToken)) ||
2399             addressProvider.isStakerVault(from, address(lpToken)) ||
2400             addressProvider.isAction(to) ||
2401             addressProvider.isAction(from) ||
2402             addressProvider.isWhiteListedFeeHandler(to) ||
2403             addressProvider.isWhiteListedFeeHandler(from)
2404         ) {
2405             return;
2406         }
2407 
2408         if (to != address(0)) {
2409             _updateUserFeesOnDeposit(to, from, amount);
2410         }
2411     }
2412 
2413     /**
2414      * @notice Update required reserve ratio.
2415      * @param requireReserves_ New required reserve ratio.
2416      */
2417     function updateRequiredReserves(uint256 requireReserves_) external override onlyGovernance {
2418         require(requireReserves_ <= ScaledMath.ONE, Error.INVALID_AMOUNT);
2419         requiredReserves = requireReserves_;
2420         _rebalanceVault();
2421         emit RequiredReservesUpdated(requireReserves_);
2422     }
2423 
2424     /**
2425      * @notice Update reserve deviation ratio.
2426      * @param reserveDeviation_ New reserve deviation ratio.
2427      */
2428     function updateReserveDeviation(uint256 reserveDeviation_) external override onlyGovernance {
2429         require(reserveDeviation_ <= (ScaledMath.DECIMAL_SCALE * 50) / 100, Error.INVALID_AMOUNT);
2430         reserveDeviation = reserveDeviation_;
2431         _rebalanceVault();
2432         emit ReserveDeviationUpdated(reserveDeviation_);
2433     }
2434 
2435     /**
2436      * @notice Update min withdrawal fee.
2437      * @param minWithdrawalFee_ New min withdrawal fee.
2438      */
2439     function updateMinWithdrawalFee(uint256 minWithdrawalFee_) external override onlyGovernance {
2440         _checkFeeInvariants(minWithdrawalFee_, maxWithdrawalFee);
2441         minWithdrawalFee = minWithdrawalFee_;
2442         emit MinWithdrawalFeeUpdated(minWithdrawalFee_);
2443     }
2444 
2445     /**
2446      * @notice Update max withdrawal fee.
2447      * @param maxWithdrawalFee_ New max withdrawal fee.
2448      */
2449     function updateMaxWithdrawalFee(uint256 maxWithdrawalFee_) external override onlyGovernance {
2450         _checkFeeInvariants(minWithdrawalFee, maxWithdrawalFee_);
2451         maxWithdrawalFee = maxWithdrawalFee_;
2452         emit MaxWithdrawalFeeUpdated(maxWithdrawalFee_);
2453     }
2454 
2455     /**
2456      * @notice Update withdrawal fee decrease period.
2457      * @param withdrawalFeeDecreasePeriod_ New withdrawal fee decrease period.
2458      */
2459     function updateWithdrawalFeeDecreasePeriod(uint256 withdrawalFeeDecreasePeriod_)
2460         external
2461         override
2462         onlyGovernance
2463     {
2464         withdrawalFeeDecreasePeriod = withdrawalFeeDecreasePeriod_;
2465         emit WithdrawalFeeDecreasePeriodUpdated(withdrawalFeeDecreasePeriod_);
2466     }
2467 
2468     /**
2469      * @notice Set the staker vault for this pool's LP token
2470      * @dev Staker vault and LP token pairs are immutable and the staker vault can only be set once for a pool.
2471      *      Only one vault exists per LP token. This information will be retrieved from the controller of the pool.
2472      */
2473     function setStaker() external override onlyRoles2(Roles.GOVERNANCE, Roles.POOL_FACTORY) {
2474         require(address(staker) == address(0), Error.ADDRESS_ALREADY_SET);
2475         address stakerVault = addressProvider.getStakerVault(address(lpToken));
2476         require(stakerVault != address(0), Error.ZERO_ADDRESS_NOT_ALLOWED);
2477         staker = IStakerVault(stakerVault);
2478         _approveStakerVaultSpendingLpTokens();
2479         emit StakerVaultSet(stakerVault);
2480     }
2481 
2482     /**
2483      * @notice Update vault.
2484      * @param vault_ Address of new Vault contract.
2485      */
2486     function updateVault(address vault_) external override onlyGovernance {
2487         IVault oldVault = IVault(vault);
2488         if (address(oldVault) != address(0)) oldVault.shutdownStrategy();
2489         vault = IVault(vault_);
2490         addressProvider.updateVault(address(oldVault), vault_);
2491         emit VaultUpdated(vault_);
2492     }
2493 
2494     /**
2495      * @notice Redeems the underlying asset by burning LP tokens.
2496      * @param redeemLpTokens Number of tokens to burn for redeeming the underlying.
2497      * @return Actual amount of the underlying redeemed.
2498      */
2499     function redeem(uint256 redeemLpTokens) external override returns (uint256) {
2500         return redeem(redeemLpTokens, 0);
2501     }
2502 
2503     /**
2504      * @notice Rebalance vault according to required underlying backing reserves.
2505      */
2506     function rebalanceVault() external override onlyGovernance {
2507         _rebalanceVault();
2508     }
2509 
2510     /**
2511      * @notice Deposit funds for an address into liquidity pool and mint LP tokens in exchange.
2512      * @param account Account to deposit for.
2513      * @param depositAmount Amount of the underlying asset to supply.
2514      * @return Actual amount minted.
2515      */
2516     function depositFor(address account, uint256 depositAmount)
2517         external
2518         payable
2519         override
2520         returns (uint256)
2521     {
2522         return depositFor(account, depositAmount, 0);
2523     }
2524 
2525     /**
2526      * @notice Redeems the underlying asset by burning LP tokens, unstaking any LP tokens needed.
2527      * @param redeemLpTokens Number of tokens to unstake and/or burn for redeeming the underlying.
2528      * @param minRedeemAmount Minimum amount of underlying that should be received.
2529      * @return Actual amount of the underlying redeemed.
2530      */
2531     function unstakeAndRedeem(uint256 redeemLpTokens, uint256 minRedeemAmount)
2532         external
2533         override
2534         returns (uint256)
2535     {
2536         uint256 lpBalance_ = lpToken.balanceOf(msg.sender);
2537         require(
2538             lpBalance_ + staker.balanceOf(msg.sender) >= redeemLpTokens,
2539             Error.INSUFFICIENT_BALANCE
2540         );
2541         if (lpBalance_ < redeemLpTokens) {
2542             staker.unstakeFor(msg.sender, msg.sender, redeemLpTokens - lpBalance_);
2543         }
2544         return redeem(redeemLpTokens, minRedeemAmount);
2545     }
2546 
2547     /**
2548      * @notice Returns the address of the LP token of this pool
2549      * @return The address of the LP token
2550      */
2551     function getLpToken() external view override returns (address) {
2552         return address(lpToken);
2553     }
2554 
2555     /**
2556      * @return whether the pool is shut down or not
2557      */
2558     function isShutdown() external view override returns (bool) {
2559         return _shutdown;
2560     }
2561 
2562     /**
2563      * @notice Calculates the amount of LP tokens that need to be redeemed to get a certain amount of underlying (includes fees and exchange rate)
2564      * @param account Address of the account redeeming.
2565      * @param underlyingAmount The amount of underlying desired.
2566      * @return Amount of LP tokens that need to be redeemed.
2567      */
2568     function calcRedeem(address account, uint256 underlyingAmount)
2569         external
2570         view
2571         override
2572         returns (uint256)
2573     {
2574         require(underlyingAmount > 0, Error.INVALID_AMOUNT);
2575         ILpToken lpToken_ = lpToken;
2576         require(lpToken_.balanceOf(account) > 0, Error.INSUFFICIENT_BALANCE);
2577 
2578         uint256 currentExchangeRate = exchangeRate();
2579         uint256 withoutFeesLpAmount = underlyingAmount.scaledDiv(currentExchangeRate);
2580         if (withoutFeesLpAmount == lpToken_.totalSupply()) {
2581             return withoutFeesLpAmount;
2582         }
2583 
2584         WithdrawalFeeMeta memory meta = withdrawalFeeMetas[account];
2585 
2586         uint256 currentFeeRatio;
2587         if (!addressProvider.isAction(account)) {
2588             currentFeeRatio = getNewCurrentFees(
2589                 meta.timeToWait,
2590                 meta.lastActionTimestamp,
2591                 meta.feeRatio
2592             );
2593         }
2594         uint256 scalingFactor = currentExchangeRate.scaledMul((ScaledMath.ONE - currentFeeRatio));
2595         uint256 neededLpTokens = underlyingAmount.scaledDivRoundUp(scalingFactor);
2596 
2597         return neededLpTokens;
2598     }
2599 
2600     function getUnderlying() external view virtual override returns (address);
2601 
2602     /**
2603      * @notice Deposit funds for an address into liquidity pool and mint LP tokens in exchange.
2604      * @param account Account to deposit for.
2605      * @param depositAmount Amount of the underlying asset to supply.
2606      * @param minTokenAmount Minimum amount of LP tokens that should be minted.
2607      * @return Actual amount minted.
2608      */
2609     function depositFor(
2610         address account,
2611         uint256 depositAmount,
2612         uint256 minTokenAmount
2613     ) public payable override notPaused notShutdown returns (uint256) {
2614         if (depositAmount == 0) return 0;
2615         uint256 rate = exchangeRate();
2616 
2617         _doTransferInFromSender(depositAmount);
2618         uint256 mintedLp = depositAmount.scaledDiv(rate);
2619         require(mintedLp >= minTokenAmount && mintedLp > 0, Error.INVALID_AMOUNT);
2620 
2621         lpToken.mint(account, mintedLp);
2622 
2623         _rebalanceVault();
2624 
2625         if (msg.sender == account || address(this) == account) {
2626             emit Deposit(msg.sender, depositAmount, mintedLp);
2627         } else {
2628             emit DepositFor(msg.sender, account, depositAmount, mintedLp);
2629         }
2630         return mintedLp;
2631     }
2632 
2633     /**
2634      * @notice Redeems the underlying asset by burning LP tokens.
2635      * @param redeemLpTokens Number of tokens to burn for redeeming the underlying.
2636      * @param minRedeemAmount Minimum amount of underlying that should be received.
2637      * @return Actual amount of the underlying redeemed.
2638      */
2639     function redeem(uint256 redeemLpTokens, uint256 minRedeemAmount)
2640         public
2641         override
2642         returns (uint256)
2643     {
2644         require(redeemLpTokens > 0, Error.INVALID_AMOUNT);
2645         ILpToken lpToken_ = lpToken;
2646         require(lpToken_.balanceOf(msg.sender) >= redeemLpTokens, Error.INSUFFICIENT_BALANCE);
2647 
2648         uint256 withdrawalFee = addressProvider.isAction(msg.sender)
2649             ? 0
2650             : getWithdrawalFee(msg.sender, redeemLpTokens);
2651         uint256 redeemMinusFees = redeemLpTokens - withdrawalFee;
2652         // Pay no fees on the last withdrawal (avoid locking funds in the pool)
2653         if (redeemLpTokens == lpToken_.totalSupply()) {
2654             redeemMinusFees = redeemLpTokens;
2655         }
2656         uint256 redeemUnderlying = redeemMinusFees.scaledMul(exchangeRate());
2657         require(redeemUnderlying >= minRedeemAmount, Error.NOT_ENOUGH_FUNDS_WITHDRAWN);
2658 
2659         if (!_shutdown) {
2660             _rebalanceVault(redeemUnderlying);
2661         }
2662 
2663         lpToken_.burn(msg.sender, redeemLpTokens);
2664         _doTransferOut(payable(msg.sender), redeemUnderlying);
2665         emit Redeem(msg.sender, redeemUnderlying, redeemLpTokens);
2666         return redeemUnderlying;
2667     }
2668 
2669     /**
2670      * @notice Compute current exchange rate of LP tokens to underlying scaled to 1e18.
2671      * @dev Exchange rate means: underlying = LP token * exchangeRate
2672      * @return Current exchange rate.
2673      */
2674     function exchangeRate() public view override returns (uint256) {
2675         uint256 totalUnderlying_ = totalUnderlying();
2676         uint256 totalSupply = lpToken.totalSupply();
2677         if (totalSupply == 0 || totalUnderlying_ == 0) {
2678             return ScaledMath.ONE;
2679         }
2680 
2681         return totalUnderlying_.scaledDiv(totalSupply);
2682     }
2683 
2684     /**
2685      * @notice Compute total amount of underlying tokens for this pool.
2686      * @return Total amount of underlying in pool.
2687      */
2688     function totalUnderlying() public view override returns (uint256) {
2689         IVault vault_ = vault;
2690         if (address(vault_) == address(0)) {
2691             return _getBalanceUnderlying();
2692         }
2693         uint256 investedUnderlying = vault_.getTotalUnderlying();
2694         return investedUnderlying + _getBalanceUnderlying();
2695     }
2696 
2697     /**
2698      * @notice Returns the withdrawal fee for `account`
2699      * @param account Address to get the withdrawal fee for
2700      * @param amount Amount to calculate the withdrawal fee for
2701      * @return Withdrawal fee in LP tokens
2702      */
2703     function getWithdrawalFee(address account, uint256 amount)
2704         public
2705         view
2706         override
2707         returns (uint256)
2708     {
2709         WithdrawalFeeMeta memory meta = withdrawalFeeMetas[account];
2710 
2711         if (lpToken.balanceOf(account) == 0) {
2712             return 0;
2713         }
2714         uint256 currentFee = getNewCurrentFees(
2715             meta.timeToWait,
2716             meta.lastActionTimestamp,
2717             meta.feeRatio
2718         );
2719         return amount.scaledMul(currentFee);
2720     }
2721 
2722     /**
2723      * @notice Calculates the withdrawal fee a user would currently need to pay on currentBalance.
2724      * @param timeToWait The total time to wait until the withdrawal fee reached the min. fee
2725      * @param lastActionTimestamp Timestamp of the last fee update
2726      * @param feeRatio Fees that would currently be paid on the user's entire balance
2727      * @return Updated fee amount on the currentBalance
2728      */
2729     function getNewCurrentFees(
2730         uint256 timeToWait,
2731         uint256 lastActionTimestamp,
2732         uint256 feeRatio
2733     ) public view override returns (uint256) {
2734         uint256 timeElapsed = _getTime() - lastActionTimestamp;
2735         uint256 minFeePercentage = minWithdrawalFee;
2736         if (timeElapsed >= timeToWait || minFeePercentage > feeRatio) {
2737             return minFeePercentage;
2738         }
2739         uint256 elapsedShare = timeElapsed.scaledDiv(timeToWait);
2740         return feeRatio - (feeRatio - minFeePercentage).scaledMul(elapsedShare);
2741     }
2742 
2743     function _rebalanceVault() internal {
2744         _rebalanceVault(0);
2745     }
2746 
2747     function _initialize(
2748         string calldata name_,
2749         address vault_,
2750         uint256 maxWithdrawalFee_,
2751         uint256 minWithdrawalFee_
2752     ) internal initializer {
2753         name = name_;
2754         vault = IVault(vault_);
2755         maxWithdrawalFee = maxWithdrawalFee_;
2756         minWithdrawalFee = minWithdrawalFee_;
2757     }
2758 
2759     function _approveStakerVaultSpendingLpTokens() internal {
2760         address staker_ = address(staker);
2761         address lpToken_ = address(lpToken);
2762         if (staker_ == address(0) || lpToken_ == address(0)) return;
2763         if (IERC20(lpToken_).allowance(address(this), staker_) > 0) return;
2764         IERC20(lpToken_).safeApprove(staker_, type(uint256).max);
2765     }
2766 
2767     function _doTransferInFromSender(uint256 amount) internal virtual;
2768 
2769     function _doTransferOut(address payable to, uint256 amount) internal virtual;
2770 
2771     /**
2772      * @dev Rebalances the pool's allocations to the vault
2773      * @param underlyingToWithdraw Amount of underlying to withdraw such that after the withdrawal the pool and vault allocations are correctly balanced.
2774      */
2775     function _rebalanceVault(uint256 underlyingToWithdraw) internal {
2776         IVault vault_ = vault;
2777 
2778         if (address(vault_) == address(0)) return;
2779         uint256 lockedLp = staker.getStakedByActions();
2780         uint256 totalUnderlyingStaked = lockedLp.scaledMul(exchangeRate());
2781 
2782         uint256 underlyingBalance = _getBalanceUnderlying(true);
2783         uint256 maximumDeviation = totalUnderlyingStaked.scaledMul(reserveDeviation);
2784 
2785         uint256 nextTargetBalance = totalUnderlyingStaked.scaledMul(requiredReserves);
2786 
2787         if (
2788             underlyingToWithdraw > underlyingBalance ||
2789             (underlyingBalance - underlyingToWithdraw) + maximumDeviation < nextTargetBalance
2790         ) {
2791             uint256 requiredDeposits = nextTargetBalance + underlyingToWithdraw - underlyingBalance;
2792             vault_.withdraw(requiredDeposits);
2793         } else {
2794             uint256 nextBalance = underlyingBalance - underlyingToWithdraw;
2795             if (nextBalance > nextTargetBalance + maximumDeviation) {
2796                 uint256 excessDeposits = nextBalance - nextTargetBalance;
2797                 _doTransferOut(payable(address(vault_)), excessDeposits);
2798                 vault_.deposit();
2799             }
2800         }
2801     }
2802 
2803     function _updateUserFeesOnDeposit(
2804         address account,
2805         address from,
2806         uint256 amountAdded
2807     ) internal {
2808         WithdrawalFeeMeta storage meta = withdrawalFeeMetas[account];
2809         uint256 balance = lpToken.balanceOf(account) +
2810             staker.stakedAndActionLockedBalanceOf(account);
2811         uint256 newCurrentFeeRatio = getNewCurrentFees(
2812             meta.timeToWait,
2813             meta.lastActionTimestamp,
2814             meta.feeRatio
2815         );
2816         uint256 shareAdded = amountAdded.scaledDiv(amountAdded + balance);
2817         uint256 shareExisting = ScaledMath.ONE - shareAdded;
2818         uint256 feeOnDeposit;
2819         if (from == address(0)) {
2820             feeOnDeposit = maxWithdrawalFee;
2821             meta.lastActionTimestamp = _getTime().toUint64();
2822         } else {
2823             WithdrawalFeeMeta memory fromMeta = withdrawalFeeMetas[from];
2824             feeOnDeposit = getNewCurrentFees(
2825                 fromMeta.timeToWait,
2826                 fromMeta.lastActionTimestamp,
2827                 fromMeta.feeRatio
2828             );
2829             uint256 minTime_ = _getTime() - meta.timeToWait;
2830             if (meta.lastActionTimestamp < minTime_) {
2831                 meta.lastActionTimestamp = minTime_.toUint64();
2832             }
2833             meta.lastActionTimestamp = ((shareExisting *
2834                 uint256(meta.lastActionTimestamp) +
2835                 shareAdded *
2836                 _getTime()) / (shareExisting + shareAdded)).toUint64();
2837         }
2838 
2839         uint256 newFeeRatio = shareExisting.scaledMul(newCurrentFeeRatio) +
2840             shareAdded.scaledMul(feeOnDeposit);
2841 
2842         meta.feeRatio = newFeeRatio.toUint64();
2843         meta.timeToWait = withdrawalFeeDecreasePeriod.toUint64();
2844     }
2845 
2846     function _getBalanceUnderlying() internal view virtual returns (uint256);
2847 
2848     function _getBalanceUnderlying(bool transferInDone) internal view virtual returns (uint256);
2849 
2850     function _isAuthorizedToPause(address account) internal view override returns (bool) {
2851         return _roleManager().hasRole(Roles.GOVERNANCE, account);
2852     }
2853 
2854     /**
2855      * @dev Overridden for testing
2856      */
2857     function _getTime() internal view virtual returns (uint256) {
2858         return block.timestamp;
2859     }
2860 
2861     function _checkFeeInvariants(uint256 minFee, uint256 maxFee) internal pure {
2862         require(maxFee >= minFee, Error.INVALID_AMOUNT);
2863         require(maxFee <= _MAX_WITHDRAWAL_FEE, Error.INVALID_AMOUNT);
2864     }
2865 }
2866 
2867 
2868 // File interfaces/pool/IEthPool.sol
2869 
2870 pragma solidity 0.8.10;
2871 
2872 interface IEthPool {
2873     function initialize(
2874         string calldata name_,
2875         address vault_,
2876         uint256 maxWithdrawalFee_,
2877         uint256 minWithdrawalFee_
2878     ) external;
2879 }
2880 
2881 
2882 // File contracts/pool/EthPool.sol
2883 
2884 pragma solidity 0.8.10;
2885 
2886 
2887 contract EthPool is LiquidityPool, IEthPool {
2888     constructor(IController _controller) LiquidityPool(_controller) {}
2889 
2890     receive() external payable {}
2891 
2892     function initialize(
2893         string calldata name_,
2894         address vault_,
2895         uint256 maxWithdrawalFee_,
2896         uint256 minWithdrawalFee_
2897     ) external override {
2898         _initialize(name_, vault_, maxWithdrawalFee_, minWithdrawalFee_);
2899     }
2900 
2901     function getUnderlying() public pure override returns (address) {
2902         return address(0);
2903     }
2904 
2905     function _doTransferInFromSender(uint256 amount) internal override {
2906         require(msg.value == amount, Error.INVALID_AMOUNT);
2907     }
2908 
2909     function _doTransferOut(address payable to, uint256 amount) internal override {
2910         // solhint-disable-next-line avoid-low-level-calls
2911         (bool success, ) = to.call{value: amount}("");
2912         require(success, Error.FAILED_TRANSFER);
2913     }
2914 
2915     function _getBalanceUnderlying() internal view override returns (uint256) {
2916         return _getBalanceUnderlying(false);
2917     }
2918 
2919     function _getBalanceUnderlying(bool transferInDone) internal view override returns (uint256) {
2920         uint256 balance = address(this).balance;
2921         if (!transferInDone) {
2922             balance -= msg.value;
2923         }
2924         return balance;
2925     }
2926 }