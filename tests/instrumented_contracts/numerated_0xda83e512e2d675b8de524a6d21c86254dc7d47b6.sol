1 // Sources flattened with hardhat v2.6.1 https://hardhat.org
2 
3 // File @openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol@v4.5.1
4 
5 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
6 
7 pragma solidity ^0.8.1;
8 
9 /**
10  * @dev Collection of functions related to the address type
11  */
12 library AddressUpgradeable {
13     /**
14      * @dev Returns true if `account` is a contract.
15      *
16      * [IMPORTANT]
17      * ====
18      * It is unsafe to assume that an address for which this function returns
19      * false is an externally-owned account (EOA) and not a contract.
20      *
21      * Among others, `isContract` will return false for the following
22      * types of addresses:
23      *
24      *  - an externally-owned account
25      *  - a contract in construction
26      *  - an address where a contract will be created
27      *  - an address where a contract lived, but was destroyed
28      * ====
29      *
30      * [IMPORTANT]
31      * ====
32      * You shouldn't rely on `isContract` to protect against flash loan attacks!
33      *
34      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
35      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
36      * constructor.
37      * ====
38      */
39     function isContract(address account) internal view returns (bool) {
40         // This method relies on extcodesize/address.code.length, which returns 0
41         // for contracts in construction, since the code is only stored at the end
42         // of the constructor execution.
43 
44         return account.code.length > 0;
45     }
46 
47     /**
48      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
49      * `recipient`, forwarding all available gas and reverting on errors.
50      *
51      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
52      * of certain opcodes, possibly making contracts go over the 2300 gas limit
53      * imposed by `transfer`, making them unable to receive funds via
54      * `transfer`. {sendValue} removes this limitation.
55      *
56      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
57      *
58      * IMPORTANT: because control is transferred to `recipient`, care must be
59      * taken to not create reentrancy vulnerabilities. Consider using
60      * {ReentrancyGuard} or the
61      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
62      */
63     function sendValue(address payable recipient, uint256 amount) internal {
64         require(address(this).balance >= amount, "Address: insufficient balance");
65 
66         (bool success, ) = recipient.call{value: amount}("");
67         require(success, "Address: unable to send value, recipient may have reverted");
68     }
69 
70     /**
71      * @dev Performs a Solidity function call using a low level `call`. A
72      * plain `call` is an unsafe replacement for a function call: use this
73      * function instead.
74      *
75      * If `target` reverts with a revert reason, it is bubbled up by this
76      * function (like regular Solidity function calls).
77      *
78      * Returns the raw returned data. To convert to the expected return value,
79      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
80      *
81      * Requirements:
82      *
83      * - `target` must be a contract.
84      * - calling `target` with `data` must not revert.
85      *
86      * _Available since v3.1._
87      */
88     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
89         return functionCall(target, data, "Address: low-level call failed");
90     }
91 
92     /**
93      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
94      * `errorMessage` as a fallback revert reason when `target` reverts.
95      *
96      * _Available since v3.1._
97      */
98     function functionCall(
99         address target,
100         bytes memory data,
101         string memory errorMessage
102     ) internal returns (bytes memory) {
103         return functionCallWithValue(target, data, 0, errorMessage);
104     }
105 
106     /**
107      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
108      * but also transferring `value` wei to `target`.
109      *
110      * Requirements:
111      *
112      * - the calling contract must have an ETH balance of at least `value`.
113      * - the called Solidity function must be `payable`.
114      *
115      * _Available since v3.1._
116      */
117     function functionCallWithValue(
118         address target,
119         bytes memory data,
120         uint256 value
121     ) internal returns (bytes memory) {
122         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
123     }
124 
125     /**
126      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
127      * with `errorMessage` as a fallback revert reason when `target` reverts.
128      *
129      * _Available since v3.1._
130      */
131     function functionCallWithValue(
132         address target,
133         bytes memory data,
134         uint256 value,
135         string memory errorMessage
136     ) internal returns (bytes memory) {
137         require(address(this).balance >= value, "Address: insufficient balance for call");
138         require(isContract(target), "Address: call to non-contract");
139 
140         (bool success, bytes memory returndata) = target.call{value: value}(data);
141         return verifyCallResult(success, returndata, errorMessage);
142     }
143 
144     /**
145      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
146      * but performing a static call.
147      *
148      * _Available since v3.3._
149      */
150     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
151         return functionStaticCall(target, data, "Address: low-level static call failed");
152     }
153 
154     /**
155      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
156      * but performing a static call.
157      *
158      * _Available since v3.3._
159      */
160     function functionStaticCall(
161         address target,
162         bytes memory data,
163         string memory errorMessage
164     ) internal view returns (bytes memory) {
165         require(isContract(target), "Address: static call to non-contract");
166 
167         (bool success, bytes memory returndata) = target.staticcall(data);
168         return verifyCallResult(success, returndata, errorMessage);
169     }
170 
171     /**
172      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
173      * revert reason using the provided one.
174      *
175      * _Available since v4.3._
176      */
177     function verifyCallResult(
178         bool success,
179         bytes memory returndata,
180         string memory errorMessage
181     ) internal pure returns (bytes memory) {
182         if (success) {
183             return returndata;
184         } else {
185             // Look for revert reason and bubble it up if present
186             if (returndata.length > 0) {
187                 // The easiest way to bubble the revert reason is using memory via assembly
188 
189                 assembly {
190                     let returndata_size := mload(returndata)
191                     revert(add(32, returndata), returndata_size)
192                 }
193             } else {
194                 revert(errorMessage);
195             }
196         }
197     }
198 }
199 
200 
201 // File @openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol@v4.5.1
202 
203 // OpenZeppelin Contracts (last updated v4.5.0) (proxy/utils/Initializable.sol)
204 
205 pragma solidity ^0.8.0;
206 
207 /**
208  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
209  * behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
210  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
211  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
212  *
213  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
214  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
215  *
216  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
217  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
218  *
219  * [CAUTION]
220  * ====
221  * Avoid leaving a contract uninitialized.
222  *
223  * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
224  * contract, which may impact the proxy. To initialize the implementation contract, you can either invoke the
225  * initializer manually, or you can include a constructor to automatically mark it as initialized when it is deployed:
226  *
227  * [.hljs-theme-light.nopadding]
228  * ```
229  * /// @custom:oz-upgrades-unsafe-allow constructor
230  * constructor() initializer {}
231  * ```
232  * ====
233  */
234 abstract contract Initializable {
235     /**
236      * @dev Indicates that the contract has been initialized.
237      */
238     bool private _initialized;
239 
240     /**
241      * @dev Indicates that the contract is in the process of being initialized.
242      */
243     bool private _initializing;
244 
245     /**
246      * @dev Modifier to protect an initializer function from being invoked twice.
247      */
248     modifier initializer() {
249         // If the contract is initializing we ignore whether _initialized is set in order to support multiple
250         // inheritance patterns, but we only do this in the context of a constructor, because in other contexts the
251         // contract may have been reentered.
252         require(_initializing ? _isConstructor() : !_initialized, "Initializable: contract is already initialized");
253 
254         bool isTopLevelCall = !_initializing;
255         if (isTopLevelCall) {
256             _initializing = true;
257             _initialized = true;
258         }
259 
260         _;
261 
262         if (isTopLevelCall) {
263             _initializing = false;
264         }
265     }
266 
267     /**
268      * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
269      * {initializer} modifier, directly or indirectly.
270      */
271     modifier onlyInitializing() {
272         require(_initializing, "Initializable: contract is not initializing");
273         _;
274     }
275 
276     function _isConstructor() private view returns (bool) {
277         return !AddressUpgradeable.isContract(address(this));
278     }
279 }
280 
281 
282 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.5.0
283 
284 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
285 
286 pragma solidity ^0.8.0;
287 
288 /**
289  * @dev Interface of the ERC20 standard as defined in the EIP.
290  */
291 interface IERC20 {
292     /**
293      * @dev Returns the amount of tokens in existence.
294      */
295     function totalSupply() external view returns (uint256);
296 
297     /**
298      * @dev Returns the amount of tokens owned by `account`.
299      */
300     function balanceOf(address account) external view returns (uint256);
301 
302     /**
303      * @dev Moves `amount` tokens from the caller's account to `to`.
304      *
305      * Returns a boolean value indicating whether the operation succeeded.
306      *
307      * Emits a {Transfer} event.
308      */
309     function transfer(address to, uint256 amount) external returns (bool);
310 
311     /**
312      * @dev Returns the remaining number of tokens that `spender` will be
313      * allowed to spend on behalf of `owner` through {transferFrom}. This is
314      * zero by default.
315      *
316      * This value changes when {approve} or {transferFrom} are called.
317      */
318     function allowance(address owner, address spender) external view returns (uint256);
319 
320     /**
321      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
322      *
323      * Returns a boolean value indicating whether the operation succeeded.
324      *
325      * IMPORTANT: Beware that changing an allowance with this method brings the risk
326      * that someone may use both the old and the new allowance by unfortunate
327      * transaction ordering. One possible solution to mitigate this race
328      * condition is to first reduce the spender's allowance to 0 and set the
329      * desired value afterwards:
330      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
331      *
332      * Emits an {Approval} event.
333      */
334     function approve(address spender, uint256 amount) external returns (bool);
335 
336     /**
337      * @dev Moves `amount` tokens from `from` to `to` using the
338      * allowance mechanism. `amount` is then deducted from the caller's
339      * allowance.
340      *
341      * Returns a boolean value indicating whether the operation succeeded.
342      *
343      * Emits a {Transfer} event.
344      */
345     function transferFrom(
346         address from,
347         address to,
348         uint256 amount
349     ) external returns (bool);
350 
351     /**
352      * @dev Emitted when `value` tokens are moved from one account (`from`) to
353      * another (`to`).
354      *
355      * Note that `value` may be zero.
356      */
357     event Transfer(address indexed from, address indexed to, uint256 value);
358 
359     /**
360      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
361      * a call to {approve}. `value` is the new allowance.
362      */
363     event Approval(address indexed owner, address indexed spender, uint256 value);
364 }
365 
366 
367 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
368 
369 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
370 
371 pragma solidity ^0.8.1;
372 
373 /**
374  * @dev Collection of functions related to the address type
375  */
376 library Address {
377     /**
378      * @dev Returns true if `account` is a contract.
379      *
380      * [IMPORTANT]
381      * ====
382      * It is unsafe to assume that an address for which this function returns
383      * false is an externally-owned account (EOA) and not a contract.
384      *
385      * Among others, `isContract` will return false for the following
386      * types of addresses:
387      *
388      *  - an externally-owned account
389      *  - a contract in construction
390      *  - an address where a contract will be created
391      *  - an address where a contract lived, but was destroyed
392      * ====
393      *
394      * [IMPORTANT]
395      * ====
396      * You shouldn't rely on `isContract` to protect against flash loan attacks!
397      *
398      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
399      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
400      * constructor.
401      * ====
402      */
403     function isContract(address account) internal view returns (bool) {
404         // This method relies on extcodesize/address.code.length, which returns 0
405         // for contracts in construction, since the code is only stored at the end
406         // of the constructor execution.
407 
408         return account.code.length > 0;
409     }
410 
411     /**
412      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
413      * `recipient`, forwarding all available gas and reverting on errors.
414      *
415      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
416      * of certain opcodes, possibly making contracts go over the 2300 gas limit
417      * imposed by `transfer`, making them unable to receive funds via
418      * `transfer`. {sendValue} removes this limitation.
419      *
420      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
421      *
422      * IMPORTANT: because control is transferred to `recipient`, care must be
423      * taken to not create reentrancy vulnerabilities. Consider using
424      * {ReentrancyGuard} or the
425      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
426      */
427     function sendValue(address payable recipient, uint256 amount) internal {
428         require(address(this).balance >= amount, "Address: insufficient balance");
429 
430         (bool success, ) = recipient.call{value: amount}("");
431         require(success, "Address: unable to send value, recipient may have reverted");
432     }
433 
434     /**
435      * @dev Performs a Solidity function call using a low level `call`. A
436      * plain `call` is an unsafe replacement for a function call: use this
437      * function instead.
438      *
439      * If `target` reverts with a revert reason, it is bubbled up by this
440      * function (like regular Solidity function calls).
441      *
442      * Returns the raw returned data. To convert to the expected return value,
443      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
444      *
445      * Requirements:
446      *
447      * - `target` must be a contract.
448      * - calling `target` with `data` must not revert.
449      *
450      * _Available since v3.1._
451      */
452     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
453         return functionCall(target, data, "Address: low-level call failed");
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
458      * `errorMessage` as a fallback revert reason when `target` reverts.
459      *
460      * _Available since v3.1._
461      */
462     function functionCall(
463         address target,
464         bytes memory data,
465         string memory errorMessage
466     ) internal returns (bytes memory) {
467         return functionCallWithValue(target, data, 0, errorMessage);
468     }
469 
470     /**
471      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
472      * but also transferring `value` wei to `target`.
473      *
474      * Requirements:
475      *
476      * - the calling contract must have an ETH balance of at least `value`.
477      * - the called Solidity function must be `payable`.
478      *
479      * _Available since v3.1._
480      */
481     function functionCallWithValue(
482         address target,
483         bytes memory data,
484         uint256 value
485     ) internal returns (bytes memory) {
486         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
487     }
488 
489     /**
490      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
491      * with `errorMessage` as a fallback revert reason when `target` reverts.
492      *
493      * _Available since v3.1._
494      */
495     function functionCallWithValue(
496         address target,
497         bytes memory data,
498         uint256 value,
499         string memory errorMessage
500     ) internal returns (bytes memory) {
501         require(address(this).balance >= value, "Address: insufficient balance for call");
502         require(isContract(target), "Address: call to non-contract");
503 
504         (bool success, bytes memory returndata) = target.call{value: value}(data);
505         return verifyCallResult(success, returndata, errorMessage);
506     }
507 
508     /**
509      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
510      * but performing a static call.
511      *
512      * _Available since v3.3._
513      */
514     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
515         return functionStaticCall(target, data, "Address: low-level static call failed");
516     }
517 
518     /**
519      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
520      * but performing a static call.
521      *
522      * _Available since v3.3._
523      */
524     function functionStaticCall(
525         address target,
526         bytes memory data,
527         string memory errorMessage
528     ) internal view returns (bytes memory) {
529         require(isContract(target), "Address: static call to non-contract");
530 
531         (bool success, bytes memory returndata) = target.staticcall(data);
532         return verifyCallResult(success, returndata, errorMessage);
533     }
534 
535     /**
536      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
537      * but performing a delegate call.
538      *
539      * _Available since v3.4._
540      */
541     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
542         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
543     }
544 
545     /**
546      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
547      * but performing a delegate call.
548      *
549      * _Available since v3.4._
550      */
551     function functionDelegateCall(
552         address target,
553         bytes memory data,
554         string memory errorMessage
555     ) internal returns (bytes memory) {
556         require(isContract(target), "Address: delegate call to non-contract");
557 
558         (bool success, bytes memory returndata) = target.delegatecall(data);
559         return verifyCallResult(success, returndata, errorMessage);
560     }
561 
562     /**
563      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
564      * revert reason using the provided one.
565      *
566      * _Available since v4.3._
567      */
568     function verifyCallResult(
569         bool success,
570         bytes memory returndata,
571         string memory errorMessage
572     ) internal pure returns (bytes memory) {
573         if (success) {
574             return returndata;
575         } else {
576             // Look for revert reason and bubble it up if present
577             if (returndata.length > 0) {
578                 // The easiest way to bubble the revert reason is using memory via assembly
579 
580                 assembly {
581                     let returndata_size := mload(returndata)
582                     revert(add(32, returndata), returndata_size)
583                 }
584             } else {
585                 revert(errorMessage);
586             }
587         }
588     }
589 }
590 
591 
592 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.5.0
593 
594 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
595 
596 pragma solidity ^0.8.0;
597 
598 
599 /**
600  * @title SafeERC20
601  * @dev Wrappers around ERC20 operations that throw on failure (when the token
602  * contract returns false). Tokens that return no value (and instead revert or
603  * throw on failure) are also supported, non-reverting calls are assumed to be
604  * successful.
605  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
606  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
607  */
608 library SafeERC20 {
609     using Address for address;
610 
611     function safeTransfer(
612         IERC20 token,
613         address to,
614         uint256 value
615     ) internal {
616         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
617     }
618 
619     function safeTransferFrom(
620         IERC20 token,
621         address from,
622         address to,
623         uint256 value
624     ) internal {
625         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
626     }
627 
628     /**
629      * @dev Deprecated. This function has issues similar to the ones found in
630      * {IERC20-approve}, and its usage is discouraged.
631      *
632      * Whenever possible, use {safeIncreaseAllowance} and
633      * {safeDecreaseAllowance} instead.
634      */
635     function safeApprove(
636         IERC20 token,
637         address spender,
638         uint256 value
639     ) internal {
640         // safeApprove should only be called when setting an initial allowance,
641         // or when resetting it to zero. To increase and decrease it, use
642         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
643         require(
644             (value == 0) || (token.allowance(address(this), spender) == 0),
645             "SafeERC20: approve from non-zero to non-zero allowance"
646         );
647         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
648     }
649 
650     function safeIncreaseAllowance(
651         IERC20 token,
652         address spender,
653         uint256 value
654     ) internal {
655         uint256 newAllowance = token.allowance(address(this), spender) + value;
656         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
657     }
658 
659     function safeDecreaseAllowance(
660         IERC20 token,
661         address spender,
662         uint256 value
663     ) internal {
664         unchecked {
665             uint256 oldAllowance = token.allowance(address(this), spender);
666             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
667             uint256 newAllowance = oldAllowance - value;
668             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
669         }
670     }
671 
672     /**
673      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
674      * on the return value: the return value is optional (but if data is returned, it must not be false).
675      * @param token The token targeted by the call.
676      * @param data The call data (encoded using abi.encode or one of its variants).
677      */
678     function _callOptionalReturn(IERC20 token, bytes memory data) private {
679         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
680         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
681         // the target address contains contract code and also asserts for success in the low-level call.
682 
683         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
684         if (returndata.length > 0) {
685             // Return data is optional
686             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
687         }
688     }
689 }
690 
691 
692 // File interfaces/IPreparable.sol
693 
694 pragma solidity 0.8.9;
695 
696 interface IPreparable {
697     event ConfigPreparedAddress(bytes32 indexed key, address value, uint256 delay);
698     event ConfigPreparedNumber(bytes32 indexed key, uint256 value, uint256 delay);
699 
700     event ConfigUpdatedAddress(bytes32 indexed key, address oldValue, address newValue);
701     event ConfigUpdatedNumber(bytes32 indexed key, uint256 oldValue, uint256 newValue);
702 
703     event ConfigReset(bytes32 indexed key);
704 }
705 
706 
707 // File interfaces/IStrategy.sol
708 
709 pragma solidity 0.8.9;
710 
711 interface IStrategy {
712     function name() external view returns (string memory);
713 
714     function deposit() external payable returns (bool);
715 
716     function balance() external view returns (uint256);
717 
718     function withdraw(uint256 amount) external returns (bool);
719 
720     function withdrawAll() external returns (uint256);
721 
722     function harvestable() external view returns (uint256);
723 
724     function harvest() external returns (uint256);
725 
726     function strategist() external view returns (address);
727 
728     function shutdown() external returns (bool);
729 
730     function hasPendingFunds() external view returns (bool);
731 }
732 
733 
734 // File interfaces/IVault.sol
735 
736 pragma solidity 0.8.9;
737 
738 
739 /**
740  * @title Interface for a Vault
741  */
742 
743 interface IVault is IPreparable {
744     event StrategyActivated(address indexed strategy);
745 
746     event StrategyDeactivated(address indexed strategy);
747 
748     /**
749      * @dev 'netProfit' is the profit after all fees have been deducted
750      */
751     event Harvest(uint256 indexed netProfit, uint256 indexed loss);
752 
753     function initialize(
754         address _pool,
755         uint256 _debtLimit,
756         uint256 _targetAllocation,
757         uint256 _bound
758     ) external;
759 
760     function withdrawFromStrategyWaitingForRemoval(address strategy) external returns (uint256);
761 
762     function deposit() external payable;
763 
764     function withdraw(uint256 amount) external returns (bool);
765 
766     function initializeStrategy(address strategy_) external returns (bool);
767 
768     function withdrawAll() external;
769 
770     function withdrawFromReserve(uint256 amount) external;
771 
772     function getStrategy() external view returns (IStrategy);
773 
774     function getStrategiesWaitingForRemoval() external view returns (address[] memory);
775 
776     function getAllocatedToStrategyWaitingForRemoval(address strategy)
777         external
778         view
779         returns (uint256);
780 
781     function getTotalUnderlying() external view returns (uint256);
782 
783     function getUnderlying() external view returns (address);
784 }
785 
786 
787 // File interfaces/pool/ILiquidityPool.sol
788 
789 pragma solidity 0.8.9;
790 
791 
792 interface ILiquidityPool is IPreparable {
793     event Deposit(address indexed minter, uint256 depositAmount, uint256 mintedLpTokens);
794 
795     event DepositFor(
796         address indexed minter,
797         address indexed mintee,
798         uint256 depositAmount,
799         uint256 mintedLpTokens
800     );
801 
802     event Redeem(address indexed redeemer, uint256 redeemAmount, uint256 redeemTokens);
803 
804     event LpTokenSet(address indexed lpToken);
805 
806     event StakerVaultSet(address indexed stakerVault);
807 
808     function redeem(uint256 redeemTokens) external returns (uint256);
809 
810     function redeem(uint256 redeemTokens, uint256 minRedeemAmount) external returns (uint256);
811 
812     function calcRedeem(address account, uint256 underlyingAmount) external returns (uint256);
813 
814     function deposit(uint256 mintAmount) external payable returns (uint256);
815 
816     function deposit(uint256 mintAmount, uint256 minTokenAmount) external payable returns (uint256);
817 
818     function depositAndStake(uint256 depositAmount, uint256 minTokenAmount)
819         external
820         payable
821         returns (uint256);
822 
823     function depositFor(address account, uint256 depositAmount) external payable returns (uint256);
824 
825     function depositFor(
826         address account,
827         uint256 depositAmount,
828         uint256 minTokenAmount
829     ) external payable returns (uint256);
830 
831     function unstakeAndRedeem(uint256 redeemLpTokens, uint256 minRedeemAmount)
832         external
833         returns (uint256);
834 
835     function handleLpTokenTransfer(
836         address from,
837         address to,
838         uint256 amount
839     ) external;
840 
841     function executeNewVault() external returns (address);
842 
843     function executeNewMaxWithdrawalFee() external returns (uint256);
844 
845     function executeNewRequiredReserves() external returns (uint256);
846 
847     function executeNewReserveDeviation() external returns (uint256);
848 
849     function setLpToken(address _lpToken) external returns (bool);
850 
851     function setStaker() external returns (bool);
852 
853     function isCapped() external returns (bool);
854 
855     function uncap() external returns (bool);
856 
857     function updateDepositCap(uint256 _depositCap) external returns (bool);
858 
859     function getUnderlying() external view returns (address);
860 
861     function getLpToken() external view returns (address);
862 
863     function getWithdrawalFee(address account, uint256 amount) external view returns (uint256);
864 
865     function getVault() external view returns (IVault);
866 
867     function exchangeRate() external view returns (uint256);
868 }
869 
870 
871 // File interfaces/IGasBank.sol
872 
873 pragma solidity 0.8.9;
874 
875 interface IGasBank {
876     event Deposit(address indexed account, uint256 value);
877     event Withdraw(address indexed account, address indexed receiver, uint256 value);
878 
879     function depositFor(address account) external payable;
880 
881     function withdrawUnused(address account) external;
882 
883     function withdrawFrom(address account, uint256 amount) external;
884 
885     function withdrawFrom(
886         address account,
887         address payable to,
888         uint256 amount
889     ) external;
890 
891     function balanceOf(address account) external view returns (uint256);
892 }
893 
894 
895 // File interfaces/oracles/IOracleProvider.sol
896 
897 pragma solidity 0.8.9;
898 
899 interface IOracleProvider {
900     /// @notice Quotes the USD price of `baseAsset`
901     /// @param baseAsset the asset of which the price is to be quoted
902     /// @return the USD price of the asset
903     function getPriceUSD(address baseAsset) external view returns (uint256);
904 
905     /// @notice Quotes the ETH price of `baseAsset`
906     /// @param baseAsset the asset of which the price is to be quoted
907     /// @return the ETH price of the asset
908     function getPriceETH(address baseAsset) external view returns (uint256);
909 }
910 
911 
912 // File libraries/AddressProviderMeta.sol
913 
914 pragma solidity 0.8.9;
915 
916 library AddressProviderMeta {
917     struct Meta {
918         bool freezable;
919         bool frozen;
920     }
921 
922     function fromUInt(uint256 value) internal pure returns (Meta memory) {
923         Meta memory meta;
924         meta.freezable = (value & 1) == 1;
925         meta.frozen = ((value >> 1) & 1) == 1;
926         return meta;
927     }
928 
929     function toUInt(Meta memory meta) internal pure returns (uint256) {
930         uint256 value;
931         value |= meta.freezable ? 1 : 0;
932         value |= meta.frozen ? 1 << 1 : 0;
933         return value;
934     }
935 }
936 
937 
938 // File interfaces/IAddressProvider.sol
939 
940 pragma solidity 0.8.9;
941 
942 
943 
944 
945 
946 // solhint-disable ordering
947 
948 interface IAddressProvider is IPreparable {
949     event KnownAddressKeyAdded(bytes32 indexed key);
950     event StakerVaultListed(address indexed stakerVault);
951     event StakerVaultDelisted(address indexed stakerVault);
952     event ActionListed(address indexed action);
953     event PoolListed(address indexed pool);
954     event PoolDelisted(address indexed pool);
955     event VaultUpdated(address indexed previousVault, address indexed newVault);
956 
957     /** Key functions */
958     function getKnownAddressKeys() external view returns (bytes32[] memory);
959 
960     function freezeAddress(bytes32 key) external;
961 
962     /** Pool functions */
963 
964     function allPools() external view returns (address[] memory);
965 
966     function addPool(address pool) external;
967 
968     function poolsCount() external view returns (uint256);
969 
970     function getPoolAtIndex(uint256 index) external view returns (address);
971 
972     function isPool(address pool) external view returns (bool);
973 
974     function removePool(address pool) external returns (bool);
975 
976     function getPoolForToken(address token) external view returns (ILiquidityPool);
977 
978     function safeGetPoolForToken(address token) external view returns (address);
979 
980     /** Vault functions  */
981 
982     function updateVault(address previousVault, address newVault) external;
983 
984     function allVaults() external view returns (address[] memory);
985 
986     function vaultsCount() external view returns (uint256);
987 
988     function getVaultAtIndex(uint256 index) external view returns (address);
989 
990     function isVault(address vault) external view returns (bool);
991 
992     /** Action functions */
993 
994     function allActions() external view returns (address[] memory);
995 
996     function addAction(address action) external returns (bool);
997 
998     function isAction(address action) external view returns (bool);
999 
1000     /** Address functions */
1001     function initializeAddress(
1002         bytes32 key,
1003         address initialAddress,
1004         bool frezable
1005     ) external;
1006 
1007     function initializeAndFreezeAddress(bytes32 key, address initialAddress) external;
1008 
1009     function getAddress(bytes32 key) external view returns (address);
1010 
1011     function getAddress(bytes32 key, bool checkExists) external view returns (address);
1012 
1013     function getAddressMeta(bytes32 key) external view returns (AddressProviderMeta.Meta memory);
1014 
1015     function prepareAddress(bytes32 key, address newAddress) external returns (bool);
1016 
1017     function executeAddress(bytes32 key) external returns (address);
1018 
1019     function resetAddress(bytes32 key) external returns (bool);
1020 
1021     /** Staker vault functions */
1022     function allStakerVaults() external view returns (address[] memory);
1023 
1024     function tryGetStakerVault(address token) external view returns (bool, address);
1025 
1026     function getStakerVault(address token) external view returns (address);
1027 
1028     function addStakerVault(address stakerVault) external returns (bool);
1029 
1030     function isStakerVault(address stakerVault, address token) external view returns (bool);
1031 
1032     function isStakerVaultRegistered(address stakerVault) external view returns (bool);
1033 
1034     function isWhiteListedFeeHandler(address feeHandler) external view returns (bool);
1035 }
1036 
1037 
1038 // File interfaces/tokenomics/IInflationManager.sol
1039 
1040 pragma solidity 0.8.9;
1041 
1042 interface IInflationManager {
1043     event KeeperGaugeListed(address indexed pool, address indexed keeperGauge);
1044     event AmmGaugeListed(address indexed token, address indexed ammGauge);
1045     event KeeperGaugeDelisted(address indexed pool, address indexed keeperGauge);
1046     event AmmGaugeDelisted(address indexed token, address indexed ammGauge);
1047 
1048     /** Pool functions */
1049 
1050     function setKeeperGauge(address pool, address _keeperGauge) external returns (bool);
1051 
1052     function setAmmGauge(address token, address _ammGauge) external returns (bool);
1053 
1054     function getAllAmmGauges() external view returns (address[] memory);
1055 
1056     function getLpRateForStakerVault(address stakerVault) external view returns (uint256);
1057 
1058     function getKeeperRateForPool(address pool) external view returns (uint256);
1059 
1060     function getAmmRateForToken(address token) external view returns (uint256);
1061 
1062     function getKeeperWeightForPool(address pool) external view returns (uint256);
1063 
1064     function getAmmWeightForToken(address pool) external view returns (uint256);
1065 
1066     function getLpPoolWeight(address pool) external view returns (uint256);
1067 
1068     function getKeeperGaugeForPool(address pool) external view returns (address);
1069 
1070     function getAmmGaugeForToken(address token) external view returns (address);
1071 
1072     function isInflationWeightManager(address account) external view returns (bool);
1073 
1074     function removeStakerVaultFromInflation(address stakerVault, address lpToken) external;
1075 
1076     function addGaugeForVault(address lpToken) external returns (bool);
1077 
1078     function whitelistGauge(address gauge) external;
1079 
1080     function checkpointAllGauges() external returns (bool);
1081 
1082     function mintRewards(address beneficiary, uint256 amount) external;
1083 
1084     function addStrategyToDepositStakerVault(address depositStakerVault, address strategyPool)
1085         external
1086         returns (bool);
1087 
1088     /** Weight setter functions **/
1089 
1090     function prepareLpPoolWeight(address lpToken, uint256 newPoolWeight) external returns (bool);
1091 
1092     function prepareAmmTokenWeight(address token, uint256 newTokenWeight) external returns (bool);
1093 
1094     function prepareKeeperPoolWeight(address pool, uint256 newPoolWeight) external returns (bool);
1095 
1096     function executeLpPoolWeight(address lpToken) external returns (uint256);
1097 
1098     function executeAmmTokenWeight(address token) external returns (uint256);
1099 
1100     function executeKeeperPoolWeight(address pool) external returns (uint256);
1101 
1102     function batchPrepareLpPoolWeights(address[] calldata lpTokens, uint256[] calldata weights)
1103         external
1104         returns (bool);
1105 
1106     function batchPrepareAmmTokenWeights(address[] calldata tokens, uint256[] calldata weights)
1107         external
1108         returns (bool);
1109 
1110     function batchPrepareKeeperPoolWeights(address[] calldata pools, uint256[] calldata weights)
1111         external
1112         returns (bool);
1113 
1114     function batchExecuteLpPoolWeights(address[] calldata lpTokens) external returns (bool);
1115 
1116     function batchExecuteAmmTokenWeights(address[] calldata tokens) external returns (bool);
1117 
1118     function batchExecuteKeeperPoolWeights(address[] calldata pools) external returns (bool);
1119 }
1120 
1121 
1122 // File interfaces/IController.sol
1123 
1124 pragma solidity 0.8.9;
1125 
1126 
1127 
1128 
1129 
1130 // solhint-disable ordering
1131 
1132 interface IController is IPreparable {
1133     function addressProvider() external view returns (IAddressProvider);
1134 
1135     function inflationManager() external view returns (IInflationManager);
1136 
1137     function addStakerVault(address stakerVault) external returns (bool);
1138 
1139     function removePool(address pool) external returns (bool);
1140 
1141     /** Keeper functions */
1142     function prepareKeeperRequiredStakedBKD(uint256 amount) external;
1143 
1144     function executeKeeperRequiredStakedBKD() external;
1145 
1146     function getKeeperRequiredStakedBKD() external view returns (uint256);
1147 
1148     function canKeeperExecuteAction(address keeper) external view returns (bool);
1149 
1150     /** Miscellaneous functions */
1151 
1152     function getTotalEthRequiredForGas(address payer) external view returns (uint256);
1153 }
1154 
1155 
1156 // File @openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol@v4.5.1
1157 
1158 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
1159 
1160 pragma solidity ^0.8.0;
1161 
1162 /**
1163  * @dev Interface of the ERC20 standard as defined in the EIP.
1164  */
1165 interface IERC20Upgradeable {
1166     /**
1167      * @dev Returns the amount of tokens in existence.
1168      */
1169     function totalSupply() external view returns (uint256);
1170 
1171     /**
1172      * @dev Returns the amount of tokens owned by `account`.
1173      */
1174     function balanceOf(address account) external view returns (uint256);
1175 
1176     /**
1177      * @dev Moves `amount` tokens from the caller's account to `to`.
1178      *
1179      * Returns a boolean value indicating whether the operation succeeded.
1180      *
1181      * Emits a {Transfer} event.
1182      */
1183     function transfer(address to, uint256 amount) external returns (bool);
1184 
1185     /**
1186      * @dev Returns the remaining number of tokens that `spender` will be
1187      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1188      * zero by default.
1189      *
1190      * This value changes when {approve} or {transferFrom} are called.
1191      */
1192     function allowance(address owner, address spender) external view returns (uint256);
1193 
1194     /**
1195      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1196      *
1197      * Returns a boolean value indicating whether the operation succeeded.
1198      *
1199      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1200      * that someone may use both the old and the new allowance by unfortunate
1201      * transaction ordering. One possible solution to mitigate this race
1202      * condition is to first reduce the spender's allowance to 0 and set the
1203      * desired value afterwards:
1204      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1205      *
1206      * Emits an {Approval} event.
1207      */
1208     function approve(address spender, uint256 amount) external returns (bool);
1209 
1210     /**
1211      * @dev Moves `amount` tokens from `from` to `to` using the
1212      * allowance mechanism. `amount` is then deducted from the caller's
1213      * allowance.
1214      *
1215      * Returns a boolean value indicating whether the operation succeeded.
1216      *
1217      * Emits a {Transfer} event.
1218      */
1219     function transferFrom(
1220         address from,
1221         address to,
1222         uint256 amount
1223     ) external returns (bool);
1224 
1225     /**
1226      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1227      * another (`to`).
1228      *
1229      * Note that `value` may be zero.
1230      */
1231     event Transfer(address indexed from, address indexed to, uint256 value);
1232 
1233     /**
1234      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1235      * a call to {approve}. `value` is the new allowance.
1236      */
1237     event Approval(address indexed owner, address indexed spender, uint256 value);
1238 }
1239 
1240 
1241 // File interfaces/ILpToken.sol
1242 
1243 pragma solidity 0.8.9;
1244 
1245 interface ILpToken is IERC20Upgradeable {
1246     function mint(address account, uint256 lpTokens) external;
1247 
1248     function burn(address account, uint256 burnAmount) external returns (uint256);
1249 
1250     function burn(uint256 burnAmount) external;
1251 
1252     function minter() external view returns (address);
1253 
1254     function initialize(
1255         string memory name_,
1256         string memory symbol_,
1257         uint8 _decimals,
1258         address _minter
1259     ) external returns (bool);
1260 }
1261 
1262 
1263 // File interfaces/IStakerVault.sol
1264 
1265 pragma solidity 0.8.9;
1266 
1267 interface IStakerVault {
1268     event Staked(address indexed account, uint256 amount);
1269     event Unstaked(address indexed account, uint256 amount);
1270     event Transfer(address indexed from, address indexed to, uint256 value);
1271     event Approval(address indexed owner, address indexed spender, uint256 value);
1272 
1273     function initialize(address _token) external;
1274 
1275     function initializeLpGauge(address _lpGauge) external returns (bool);
1276 
1277     function stake(uint256 amount) external returns (bool);
1278 
1279     function stakeFor(address account, uint256 amount) external returns (bool);
1280 
1281     function unstake(uint256 amount) external returns (bool);
1282 
1283     function unstakeFor(
1284         address src,
1285         address dst,
1286         uint256 amount
1287     ) external returns (bool);
1288 
1289     function approve(address spender, uint256 amount) external returns (bool);
1290 
1291     function transfer(address account, uint256 amount) external returns (bool);
1292 
1293     function transferFrom(
1294         address src,
1295         address dst,
1296         uint256 amount
1297     ) external returns (bool);
1298 
1299     function allowance(address owner, address spender) external view returns (uint256);
1300 
1301     function getToken() external view returns (address);
1302 
1303     function balanceOf(address account) external view returns (uint256);
1304 
1305     function stakedAndActionLockedBalanceOf(address account) external view returns (uint256);
1306 
1307     function actionLockedBalanceOf(address account) external view returns (uint256);
1308 
1309     function increaseActionLockedBalance(address account, uint256 amount) external returns (bool);
1310 
1311     function decreaseActionLockedBalance(address account, uint256 amount) external returns (bool);
1312 
1313     function getStakedByActions() external view returns (uint256);
1314 
1315     function addStrategy(address strategy) external returns (bool);
1316 
1317     function getPoolTotalStaked() external view returns (uint256);
1318 
1319     function prepareLpGauge(address _lpGauge) external returns (bool);
1320 
1321     function executeLpGauge() external returns (bool);
1322 
1323     function getLpGauge() external view returns (address);
1324 
1325     function poolCheckpoint() external returns (bool);
1326 
1327     function isStrategy(address user) external view returns (bool);
1328 }
1329 
1330 
1331 // File interfaces/IVaultReserve.sol
1332 
1333 pragma solidity 0.8.9;
1334 
1335 interface IVaultReserve {
1336     event Deposit(address indexed vault, address indexed token, uint256 amount);
1337     event Withdraw(address indexed vault, address indexed token, uint256 amount);
1338     event VaultListed(address indexed vault);
1339 
1340     function deposit(address token, uint256 amount) external payable returns (bool);
1341 
1342     function withdraw(address token, uint256 amount) external returns (bool);
1343 
1344     function getBalance(address vault, address token) external view returns (uint256);
1345 
1346     function canWithdraw(address vault) external view returns (bool);
1347 }
1348 
1349 
1350 // File interfaces/IRoleManager.sol
1351 
1352 pragma solidity 0.8.9;
1353 
1354 interface IRoleManager {
1355     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1356 
1357     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1358 
1359     function grantRole(bytes32 role, address account) external;
1360 
1361     function revokeRole(bytes32 role, address account) external;
1362 
1363     function hasRole(bytes32 role, address account) external view returns (bool);
1364 
1365     function hasAnyRole(bytes32[] memory roles, address account) external view returns (bool);
1366 
1367     function hasAnyRole(
1368         bytes32 role1,
1369         bytes32 role2,
1370         address account
1371     ) external view returns (bool);
1372 
1373     function hasAnyRole(
1374         bytes32 role1,
1375         bytes32 role2,
1376         bytes32 role3,
1377         address account
1378     ) external view returns (bool);
1379 
1380     function getRoleMemberCount(bytes32 role) external view returns (uint256);
1381 
1382     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
1383 }
1384 
1385 
1386 // File interfaces/tokenomics/IBkdToken.sol
1387 
1388 pragma solidity 0.8.9;
1389 
1390 interface IBkdToken is IERC20 {
1391     function mint(address account, uint256 amount) external;
1392 }
1393 
1394 
1395 // File libraries/AddressProviderKeys.sol
1396 
1397 pragma solidity 0.8.9;
1398 
1399 library AddressProviderKeys {
1400     bytes32 internal constant _TREASURY_KEY = "treasury";
1401     bytes32 internal constant _GAS_BANK_KEY = "gasBank";
1402     bytes32 internal constant _VAULT_RESERVE_KEY = "vaultReserve";
1403     bytes32 internal constant _SWAPPER_REGISTRY_KEY = "swapperRegistry";
1404     bytes32 internal constant _ORACLE_PROVIDER_KEY = "oracleProvider";
1405     bytes32 internal constant _POOL_FACTORY_KEY = "poolFactory";
1406     bytes32 internal constant _CONTROLLER_KEY = "controller";
1407     bytes32 internal constant _BKD_LOCKER_KEY = "bkdLocker";
1408     bytes32 internal constant _ROLE_MANAGER_KEY = "roleManager";
1409 }
1410 
1411 
1412 // File libraries/AddressProviderHelpers.sol
1413 
1414 pragma solidity 0.8.9;
1415 
1416 
1417 
1418 
1419 
1420 
1421 
1422 library AddressProviderHelpers {
1423     /**
1424      * @return The address of the treasury.
1425      */
1426     function getTreasury(IAddressProvider provider) internal view returns (address) {
1427         return provider.getAddress(AddressProviderKeys._TREASURY_KEY);
1428     }
1429 
1430     /**
1431      * @return The gas bank.
1432      */
1433     function getGasBank(IAddressProvider provider) internal view returns (IGasBank) {
1434         return IGasBank(provider.getAddress(AddressProviderKeys._GAS_BANK_KEY));
1435     }
1436 
1437     /**
1438      * @return The address of the vault reserve.
1439      */
1440     function getVaultReserve(IAddressProvider provider) internal view returns (IVaultReserve) {
1441         return IVaultReserve(provider.getAddress(AddressProviderKeys._VAULT_RESERVE_KEY));
1442     }
1443 
1444     /**
1445      * @return The address of the swapperRegistry.
1446      */
1447     function getSwapperRegistry(IAddressProvider provider) internal view returns (address) {
1448         return provider.getAddress(AddressProviderKeys._SWAPPER_REGISTRY_KEY);
1449     }
1450 
1451     /**
1452      * @return The oracleProvider.
1453      */
1454     function getOracleProvider(IAddressProvider provider) internal view returns (IOracleProvider) {
1455         return IOracleProvider(provider.getAddress(AddressProviderKeys._ORACLE_PROVIDER_KEY));
1456     }
1457 
1458     /**
1459      * @return the address of the BKD locker
1460      */
1461     function getBKDLocker(IAddressProvider provider) internal view returns (address) {
1462         return provider.getAddress(AddressProviderKeys._BKD_LOCKER_KEY);
1463     }
1464 
1465     /**
1466      * @return the address of the BKD locker
1467      */
1468     function getRoleManager(IAddressProvider provider) internal view returns (IRoleManager) {
1469         return IRoleManager(provider.getAddress(AddressProviderKeys._ROLE_MANAGER_KEY));
1470     }
1471 
1472     /**
1473      * @return the controller
1474      */
1475     function getController(IAddressProvider provider) internal view returns (IController) {
1476         return IController(provider.getAddress(AddressProviderKeys._CONTROLLER_KEY));
1477     }
1478 }
1479 
1480 
1481 // File libraries/Errors.sol
1482 
1483 pragma solidity 0.8.9;
1484 
1485 // solhint-disable private-vars-leading-underscore
1486 
1487 library Error {
1488     string internal constant ADDRESS_WHITELISTED = "address already whitelisted";
1489     string internal constant ADMIN_ALREADY_SET = "admin has already been set once";
1490     string internal constant ADDRESS_NOT_WHITELISTED = "address not whitelisted";
1491     string internal constant ADDRESS_NOT_FOUND = "address not found";
1492     string internal constant CONTRACT_INITIALIZED = "contract can only be initialized once";
1493     string internal constant CONTRACT_PAUSED = "contract is paused";
1494     string internal constant INVALID_AMOUNT = "invalid amount";
1495     string internal constant INVALID_INDEX = "invalid index";
1496     string internal constant INVALID_VALUE = "invalid msg.value";
1497     string internal constant INVALID_SENDER = "invalid msg.sender";
1498     string internal constant INVALID_TOKEN = "token address does not match pool's LP token address";
1499     string internal constant INVALID_DECIMALS = "incorrect number of decimals";
1500     string internal constant INVALID_ARGUMENT = "invalid argument";
1501     string internal constant INVALID_PARAMETER_VALUE = "invalid parameter value attempted";
1502     string internal constant INVALID_IMPLEMENTATION = "invalid pool implementation for given coin";
1503     string internal constant INVALID_POOL_IMPLEMENTATION =
1504         "invalid pool implementation for given coin";
1505     string internal constant INVALID_LP_TOKEN_IMPLEMENTATION =
1506         "invalid LP Token implementation for given coin";
1507     string internal constant INVALID_VAULT_IMPLEMENTATION =
1508         "invalid vault implementation for given coin";
1509     string internal constant INVALID_STAKER_VAULT_IMPLEMENTATION =
1510         "invalid stakerVault implementation for given coin";
1511     string internal constant INSUFFICIENT_BALANCE = "insufficient balance";
1512     string internal constant ADDRESS_ALREADY_SET = "Address is already set";
1513     string internal constant INSUFFICIENT_STRATEGY_BALANCE = "insufficient strategy balance";
1514     string internal constant INSUFFICIENT_FUNDS_RECEIVED = "insufficient funds received";
1515     string internal constant ADDRESS_DOES_NOT_EXIST = "address does not exist";
1516     string internal constant ADDRESS_FROZEN = "address is frozen";
1517     string internal constant ROLE_EXISTS = "role already exists";
1518     string internal constant CANNOT_REVOKE_ROLE = "cannot revoke role";
1519     string internal constant UNAUTHORIZED_ACCESS = "unauthorized access";
1520     string internal constant SAME_ADDRESS_NOT_ALLOWED = "same address not allowed";
1521     string internal constant SELF_TRANSFER_NOT_ALLOWED = "self-transfer not allowed";
1522     string internal constant ZERO_ADDRESS_NOT_ALLOWED = "zero address not allowed";
1523     string internal constant ZERO_TRANSFER_NOT_ALLOWED = "zero transfer not allowed";
1524     string internal constant THRESHOLD_TOO_HIGH = "threshold is too high, must be under 10";
1525     string internal constant INSUFFICIENT_THRESHOLD = "insufficient threshold";
1526     string internal constant NO_POSITION_EXISTS = "no position exists";
1527     string internal constant POSITION_ALREADY_EXISTS = "position already exists";
1528     string internal constant PROTOCOL_NOT_FOUND = "protocol not found";
1529     string internal constant TOP_UP_FAILED = "top up failed";
1530     string internal constant SWAP_PATH_NOT_FOUND = "swap path not found";
1531     string internal constant UNDERLYING_NOT_SUPPORTED = "underlying token not supported";
1532     string internal constant NOT_ENOUGH_FUNDS_WITHDRAWN =
1533         "not enough funds were withdrawn from the pool";
1534     string internal constant FAILED_TRANSFER = "transfer failed";
1535     string internal constant FAILED_MINT = "mint failed";
1536     string internal constant FAILED_REPAY_BORROW = "repay borrow failed";
1537     string internal constant FAILED_METHOD_CALL = "method call failed";
1538     string internal constant NOTHING_TO_CLAIM = "there is no claimable balance";
1539     string internal constant ERC20_BALANCE_EXCEEDED = "ERC20: transfer amount exceeds balance";
1540     string internal constant INVALID_MINTER =
1541         "the minter address of the LP token and the pool address do not match";
1542     string internal constant STAKER_VAULT_EXISTS = "a staker vault already exists for the token";
1543     string internal constant DEADLINE_NOT_ZERO = "deadline must be 0";
1544     string internal constant DEADLINE_NOT_SET = "deadline is 0";
1545     string internal constant DEADLINE_NOT_REACHED = "deadline has not been reached yet";
1546     string internal constant DELAY_TOO_SHORT = "delay be at least 3 days";
1547     string internal constant INSUFFICIENT_UPDATE_BALANCE =
1548         "insufficient funds for updating the position";
1549     string internal constant SAME_AS_CURRENT = "value must be different to existing value";
1550     string internal constant NOT_CAPPED = "the pool is not currently capped";
1551     string internal constant ALREADY_CAPPED = "the pool is already capped";
1552     string internal constant EXCEEDS_DEPOSIT_CAP = "deposit exceeds deposit cap";
1553     string internal constant VALUE_TOO_LOW_FOR_GAS = "value too low to cover gas";
1554     string internal constant NOT_ENOUGH_FUNDS = "not enough funds to withdraw";
1555     string internal constant ESTIMATED_GAS_TOO_HIGH = "too much ETH will be used for gas";
1556     string internal constant DEPOSIT_FAILED = "deposit failed";
1557     string internal constant GAS_TOO_HIGH = "too much ETH used for gas";
1558     string internal constant GAS_BANK_BALANCE_TOO_LOW = "not enough ETH in gas bank to cover gas";
1559     string internal constant INVALID_TOKEN_TO_ADD = "Invalid token to add";
1560     string internal constant INVALID_TOKEN_TO_REMOVE = "token can not be removed";
1561     string internal constant TIME_DELAY_NOT_EXPIRED = "time delay not expired yet";
1562     string internal constant UNDERLYING_NOT_WITHDRAWABLE =
1563         "pool does not support additional underlying coins to be withdrawn";
1564     string internal constant STRATEGY_SHUT_DOWN = "Strategy is shut down";
1565     string internal constant STRATEGY_DOES_NOT_EXIST = "Strategy does not exist";
1566     string internal constant UNSUPPORTED_UNDERLYING = "Underlying not supported";
1567     string internal constant NO_DEX_SET = "no dex has been set for token";
1568     string internal constant INVALID_TOKEN_PAIR = "invalid token pair";
1569     string internal constant TOKEN_NOT_USABLE = "token not usable for the specific action";
1570     string internal constant ADDRESS_NOT_ACTION = "address is not registered action";
1571     string internal constant INVALID_SLIPPAGE_TOLERANCE = "Invalid slippage tolerance";
1572     string internal constant POOL_NOT_PAUSED = "Pool must be paused to withdraw from reserve";
1573     string internal constant INTERACTION_LIMIT = "Max of one deposit and withdraw per block";
1574     string internal constant GAUGE_EXISTS = "Gauge already exists";
1575     string internal constant GAUGE_DOES_NOT_EXIST = "Gauge does not exist";
1576     string internal constant EXCEEDS_MAX_BOOST = "Not allowed to exceed maximum boost on Convex";
1577     string internal constant PREPARED_WITHDRAWAL =
1578         "Cannot relock funds when withdrawal is being prepared";
1579     string internal constant ASSET_NOT_SUPPORTED = "Asset not supported";
1580     string internal constant STALE_PRICE = "Price is stale";
1581     string internal constant NEGATIVE_PRICE = "Price is negative";
1582     string internal constant NOT_ENOUGH_BKD_STAKED = "Not enough BKD tokens staked";
1583     string internal constant RESERVE_ACCESS_EXCEEDED = "Reserve access exceeded";
1584 }
1585 
1586 
1587 // File libraries/ScaledMath.sol
1588 
1589 pragma solidity 0.8.9;
1590 
1591 /*
1592  * @dev To use functions of this contract, at least one of the numbers must
1593  * be scaled to `DECIMAL_SCALE`. The result will scaled to `DECIMAL_SCALE`
1594  * if both numbers are scaled to `DECIMAL_SCALE`, otherwise to the scale
1595  * of the number not scaled by `DECIMAL_SCALE`
1596  */
1597 library ScaledMath {
1598     // solhint-disable-next-line private-vars-leading-underscore
1599     uint256 internal constant DECIMAL_SCALE = 1e18;
1600     // solhint-disable-next-line private-vars-leading-underscore
1601     uint256 internal constant ONE = 1e18;
1602 
1603     /**
1604      * @notice Performs a multiplication between two scaled numbers
1605      */
1606     function scaledMul(uint256 a, uint256 b) internal pure returns (uint256) {
1607         return (a * b) / DECIMAL_SCALE;
1608     }
1609 
1610     /**
1611      * @notice Performs a division between two scaled numbers
1612      */
1613     function scaledDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1614         return (a * DECIMAL_SCALE) / b;
1615     }
1616 
1617     /**
1618      * @notice Performs a division between two numbers, rounding up the result
1619      */
1620     function scaledDivRoundUp(uint256 a, uint256 b) internal pure returns (uint256) {
1621         return (a * DECIMAL_SCALE + b - 1) / b;
1622     }
1623 
1624     /**
1625      * @notice Performs a division between two numbers, ignoring any scaling and rounding up the result
1626      */
1627     function divRoundUp(uint256 a, uint256 b) internal pure returns (uint256) {
1628         return (a + b - 1) / b;
1629     }
1630 }
1631 
1632 
1633 // File libraries/Roles.sol
1634 
1635 pragma solidity 0.8.9;
1636 
1637 // solhint-disable private-vars-leading-underscore
1638 
1639 library Roles {
1640     bytes32 internal constant GOVERNANCE = "governance";
1641     bytes32 internal constant ADDRESS_PROVIDER = "address_provider";
1642     bytes32 internal constant POOL_FACTORY = "pool_factory";
1643     bytes32 internal constant CONTROLLER = "controller";
1644     bytes32 internal constant GAUGE_ZAP = "gauge_zap";
1645     bytes32 internal constant MAINTENANCE = "maintenance";
1646     bytes32 internal constant INFLATION_MANAGER = "inflation_manager";
1647     bytes32 internal constant POOL = "pool";
1648     bytes32 internal constant VAULT = "vault";
1649 }
1650 
1651 
1652 // File contracts/access/AuthorizationBase.sol
1653 
1654 pragma solidity 0.8.9;
1655 
1656 
1657 /**
1658  * @notice Provides modifiers for authorization
1659  */
1660 abstract contract AuthorizationBase {
1661     /**
1662      * @notice Only allows a sender with `role` to perform the given action
1663      */
1664     modifier onlyRole(bytes32 role) {
1665         require(_roleManager().hasRole(role, msg.sender), Error.UNAUTHORIZED_ACCESS);
1666         _;
1667     }
1668 
1669     /**
1670      * @notice Only allows a sender with GOVERNANCE role to perform the given action
1671      */
1672     modifier onlyGovernance() {
1673         require(_roleManager().hasRole(Roles.GOVERNANCE, msg.sender), Error.UNAUTHORIZED_ACCESS);
1674         _;
1675     }
1676 
1677     /**
1678      * @notice Only allows a sender with any of `roles` to perform the given action
1679      */
1680     modifier onlyRoles2(bytes32 role1, bytes32 role2) {
1681         require(_roleManager().hasAnyRole(role1, role2, msg.sender), Error.UNAUTHORIZED_ACCESS);
1682         _;
1683     }
1684 
1685     /**
1686      * @notice Only allows a sender with any of `roles` to perform the given action
1687      */
1688     modifier onlyRoles3(
1689         bytes32 role1,
1690         bytes32 role2,
1691         bytes32 role3
1692     ) {
1693         require(
1694             _roleManager().hasAnyRole(role1, role2, role3, msg.sender),
1695             Error.UNAUTHORIZED_ACCESS
1696         );
1697         _;
1698     }
1699 
1700     function roleManager() external view virtual returns (IRoleManager) {
1701         return _roleManager();
1702     }
1703 
1704     function _roleManager() internal view virtual returns (IRoleManager);
1705 }
1706 
1707 
1708 // File contracts/access/Authorization.sol
1709 
1710 pragma solidity 0.8.9;
1711 
1712 contract Authorization is AuthorizationBase {
1713     IRoleManager internal immutable __roleManager;
1714 
1715     constructor(IRoleManager roleManager) {
1716         __roleManager = roleManager;
1717     }
1718 
1719     function _roleManager() internal view override returns (IRoleManager) {
1720         return __roleManager;
1721     }
1722 }
1723 
1724 
1725 // File contracts/utils/Preparable.sol
1726 
1727 pragma solidity 0.8.9;
1728 
1729 
1730 /**
1731  * @notice Implements the base logic for a two-phase commit
1732  * @dev This does not implements any access-control so publicly exposed
1733  * callers should make sure to have the proper checks in palce
1734  */
1735 contract Preparable is IPreparable {
1736     uint256 private constant _MIN_DELAY = 3 days;
1737 
1738     mapping(bytes32 => address) public pendingAddresses;
1739     mapping(bytes32 => uint256) public pendingUInts256;
1740 
1741     mapping(bytes32 => address) public currentAddresses;
1742     mapping(bytes32 => uint256) public currentUInts256;
1743 
1744     /**
1745      * @dev Deadlines shares the same namespace regardless of the type
1746      * of the pending variable so this needs to be enforced in the caller
1747      */
1748     mapping(bytes32 => uint256) public deadlines;
1749 
1750     function _prepareDeadline(bytes32 key, uint256 delay) internal {
1751         require(deadlines[key] == 0, Error.DEADLINE_NOT_ZERO);
1752         require(delay >= _MIN_DELAY, Error.DELAY_TOO_SHORT);
1753         deadlines[key] = block.timestamp + delay;
1754     }
1755 
1756     /**
1757      * @notice Prepares an uint256 that should be commited to the contract
1758      * after `_MIN_DELAY` elapsed
1759      * @param value The value to prepare
1760      * @return `true` if success.
1761      */
1762     function _prepare(
1763         bytes32 key,
1764         uint256 value,
1765         uint256 delay
1766     ) internal returns (bool) {
1767         _prepareDeadline(key, delay);
1768         pendingUInts256[key] = value;
1769         emit ConfigPreparedNumber(key, value, delay);
1770         return true;
1771     }
1772 
1773     /**
1774      * @notice Same as `_prepare(bytes32,uint256,uint256)` but uses a default delay
1775      */
1776     function _prepare(bytes32 key, uint256 value) internal returns (bool) {
1777         return _prepare(key, value, _MIN_DELAY);
1778     }
1779 
1780     /**
1781      * @notice Prepares an address that should be commited to the contract
1782      * after `_MIN_DELAY` elapsed
1783      * @param value The value to prepare
1784      * @return `true` if success.
1785      */
1786     function _prepare(
1787         bytes32 key,
1788         address value,
1789         uint256 delay
1790     ) internal returns (bool) {
1791         _prepareDeadline(key, delay);
1792         pendingAddresses[key] = value;
1793         emit ConfigPreparedAddress(key, value, delay);
1794         return true;
1795     }
1796 
1797     /**
1798      * @notice Same as `_prepare(bytes32,address,uint256)` but uses a default delay
1799      */
1800     function _prepare(bytes32 key, address value) internal returns (bool) {
1801         return _prepare(key, value, _MIN_DELAY);
1802     }
1803 
1804     /**
1805      * @notice Reset a uint256 key
1806      * @return `true` if success.
1807      */
1808     function _resetUInt256Config(bytes32 key) internal returns (bool) {
1809         require(deadlines[key] != 0, Error.DEADLINE_NOT_ZERO);
1810         deadlines[key] = 0;
1811         pendingUInts256[key] = 0;
1812         emit ConfigReset(key);
1813         return true;
1814     }
1815 
1816     /**
1817      * @notice Reset an address key
1818      * @return `true` if success.
1819      */
1820     function _resetAddressConfig(bytes32 key) internal returns (bool) {
1821         require(deadlines[key] != 0, Error.DEADLINE_NOT_ZERO);
1822         deadlines[key] = 0;
1823         pendingAddresses[key] = address(0);
1824         emit ConfigReset(key);
1825         return true;
1826     }
1827 
1828     /**
1829      * @dev Checks the deadline of the key and reset it
1830      */
1831     function _executeDeadline(bytes32 key) internal {
1832         uint256 deadline = deadlines[key];
1833         require(block.timestamp >= deadline, Error.DEADLINE_NOT_REACHED);
1834         require(deadline != 0, Error.DEADLINE_NOT_SET);
1835         deadlines[key] = 0;
1836     }
1837 
1838     /**
1839      * @notice Execute uint256 config update (with time delay enforced).
1840      * @dev Needs to be called after the update was prepared. Fails if called before time delay is met.
1841      * @return New value.
1842      */
1843     function _executeUInt256(bytes32 key) internal returns (uint256) {
1844         _executeDeadline(key);
1845         uint256 newValue = pendingUInts256[key];
1846         _setConfig(key, newValue);
1847         return newValue;
1848     }
1849 
1850     /**
1851      * @notice Execute address config update (with time delay enforced).
1852      * @dev Needs to be called after the update was prepared. Fails if called before time delay is met.
1853      * @return New value.
1854      */
1855     function _executeAddress(bytes32 key) internal returns (address) {
1856         _executeDeadline(key);
1857         address newValue = pendingAddresses[key];
1858         _setConfig(key, newValue);
1859         return newValue;
1860     }
1861 
1862     function _setConfig(bytes32 key, address value) internal returns (address) {
1863         address oldValue = currentAddresses[key];
1864         currentAddresses[key] = value;
1865         pendingAddresses[key] = address(0);
1866         deadlines[key] = 0;
1867         emit ConfigUpdatedAddress(key, oldValue, value);
1868         return value;
1869     }
1870 
1871     function _setConfig(bytes32 key, uint256 value) internal returns (uint256) {
1872         uint256 oldValue = currentUInts256[key];
1873         currentUInts256[key] = value;
1874         pendingUInts256[key] = 0;
1875         deadlines[key] = 0;
1876         emit ConfigUpdatedNumber(key, oldValue, value);
1877         return value;
1878     }
1879 }
1880 
1881 
1882 // File contracts/utils/Pausable.sol
1883 
1884 pragma solidity 0.8.9;
1885 
1886 abstract contract Pausable {
1887     bool public isPaused;
1888 
1889     modifier notPaused() {
1890         require(!isPaused, Error.CONTRACT_PAUSED);
1891         _;
1892     }
1893 
1894     modifier onlyAuthorizedToPause() {
1895         require(_isAuthorizedToPause(msg.sender), Error.CONTRACT_PAUSED);
1896         _;
1897     }
1898 
1899     /**
1900      * @notice Pause the contract.
1901      * @return `true` if success.
1902      */
1903     function pause() external onlyAuthorizedToPause returns (bool) {
1904         isPaused = true;
1905         return true;
1906     }
1907 
1908     /**
1909      * @notice Unpause the contract.
1910      * @return `true` if success.
1911      */
1912     function unpause() external onlyAuthorizedToPause returns (bool) {
1913         isPaused = false;
1914         return true;
1915     }
1916 
1917     /**
1918      * @notice Returns true if `account` is authorized to pause the contract
1919      * @dev This should be implemented in contracts inheriting `Pausable`
1920      * to provide proper access control
1921      */
1922     function _isAuthorizedToPause(address account) internal view virtual returns (bool);
1923 }
1924 
1925 
1926 // File contracts/pool/LiquidityPool.sol
1927 
1928 pragma solidity 0.8.9;
1929 
1930 
1931 
1932 
1933 
1934 
1935 
1936 
1937 
1938 
1939 
1940 /**
1941  * @dev Pausing/unpausing the pool will disable/re-enable deposits.
1942  */
1943 abstract contract LiquidityPool is
1944     ILiquidityPool,
1945     Authorization,
1946     Preparable,
1947     Pausable,
1948     Initializable
1949 {
1950     using AddressProviderHelpers for IAddressProvider;
1951     using ScaledMath for uint256;
1952     using SafeERC20 for IERC20;
1953 
1954     struct WithdrawalFeeMeta {
1955         uint64 timeToWait;
1956         uint64 feeRatio;
1957         uint64 lastActionTimestamp;
1958     }
1959 
1960     bytes32 internal constant _VAULT_KEY = "Vault";
1961     bytes32 internal constant _RESERVE_DEVIATION_KEY = "ReserveDeviation";
1962     bytes32 internal constant _REQUIRED_RESERVES_KEY = "RequiredReserves";
1963 
1964     bytes32 internal constant _MAX_WITHDRAWAL_FEE_KEY = "MaxWithdrawalFee";
1965     bytes32 internal constant _MIN_WITHDRAWAL_FEE_KEY = "MinWithdrawalFee";
1966     bytes32 internal constant _WITHDRAWAL_FEE_DECREASE_PERIOD_KEY = "WithdrawalFeeDecreasePeriod";
1967 
1968     uint256 internal constant _INITIAL_RESERVE_DEVIATION = 0.005e18; // 0.5%
1969     uint256 internal constant _INITIAL_FEE_DECREASE_PERIOD = 1 weeks;
1970     uint256 internal constant _INITIAL_MAX_WITHDRAWAL_FEE = 0.03e18; // 3%
1971 
1972     /**
1973      * @notice even through admin votes and later governance, the withdrawal
1974      * fee will never be able to go above this value
1975      */
1976     uint256 internal constant _MAX_WITHDRAWAL_FEE = 0.05e18;
1977 
1978     /**
1979      * @notice Keeps track of the withdrawal fees on a per-address basis
1980      */
1981     mapping(address => WithdrawalFeeMeta) public withdrawalFeeMetas;
1982 
1983     IController public immutable controller;
1984     IAddressProvider public immutable addressProvider;
1985 
1986     uint256 public depositCap;
1987     IStakerVault public staker;
1988     ILpToken public lpToken;
1989     string public name;
1990 
1991     constructor(IController _controller)
1992         Authorization(_controller.addressProvider().getRoleManager())
1993     {
1994         require(address(_controller) != address(0), Error.ZERO_ADDRESS_NOT_ALLOWED);
1995         controller = IController(_controller);
1996         addressProvider = IController(_controller).addressProvider();
1997     }
1998 
1999     /**
2000      * @notice Deposit funds into liquidity pool and mint LP tokens in exchange.
2001      * @param depositAmount Amount of the underlying asset to supply.
2002      * @return The actual amount minted.
2003      */
2004     function deposit(uint256 depositAmount) external payable override returns (uint256) {
2005         return depositFor(msg.sender, depositAmount, 0);
2006     }
2007 
2008     /**
2009      * @notice Deposit funds into liquidity pool and mint LP tokens in exchange.
2010      * @param depositAmount Amount of the underlying asset to supply.
2011      * @param minTokenAmount Minimum amount of LP tokens that should be minted.
2012      * @return The actual amount minted.
2013      */
2014     function deposit(uint256 depositAmount, uint256 minTokenAmount)
2015         external
2016         payable
2017         override
2018         returns (uint256)
2019     {
2020         return depositFor(msg.sender, depositAmount, minTokenAmount);
2021     }
2022 
2023     /**
2024      * @notice Deposit funds into liquidity pool and stake LP Tokens in Staker Vault.
2025      * @param depositAmount Amount of the underlying asset to supply.
2026      * @param minTokenAmount Minimum amount of LP tokens that should be minted.
2027      * @return The actual amount minted and staked.
2028      */
2029     function depositAndStake(uint256 depositAmount, uint256 minTokenAmount)
2030         external
2031         payable
2032         override
2033         returns (uint256)
2034     {
2035         uint256 amountMinted_ = depositFor(address(this), depositAmount, minTokenAmount);
2036         staker.stakeFor(msg.sender, amountMinted_);
2037         return amountMinted_;
2038     }
2039 
2040     /**
2041      * @notice Withdraws all funds from vault.
2042      * @dev Should be called in case of emergencies.
2043      */
2044     function withdrawAll() external onlyGovernance {
2045         getVault().withdrawAll();
2046     }
2047 
2048     function setLpToken(address _lpToken)
2049         external
2050         override
2051         onlyRoles2(Roles.GOVERNANCE, Roles.POOL_FACTORY)
2052         returns (bool)
2053     {
2054         require(address(lpToken) == address(0), Error.ADDRESS_ALREADY_SET);
2055         require(ILpToken(_lpToken).minter() == address(this), Error.INVALID_MINTER);
2056         lpToken = ILpToken(_lpToken);
2057         _approveStakerVaultSpendingLpTokens();
2058         emit LpTokenSet(_lpToken);
2059         return true;
2060     }
2061 
2062     /**
2063      * @notice Checkpoint function to update a user's withdrawal fees on deposit and redeem
2064      * @param from Address sending from
2065      * @param to Address sending to
2066      * @param amount Amount to redeem or deposit
2067      */
2068     function handleLpTokenTransfer(
2069         address from,
2070         address to,
2071         uint256 amount
2072     ) external override {
2073         require(
2074             msg.sender == address(lpToken) || msg.sender == address(staker),
2075             Error.UNAUTHORIZED_ACCESS
2076         );
2077         if (
2078             addressProvider.isStakerVault(to, address(lpToken)) ||
2079             addressProvider.isStakerVault(from, address(lpToken)) ||
2080             addressProvider.isAction(to) ||
2081             addressProvider.isAction(from)
2082         ) {
2083             return;
2084         }
2085 
2086         if (to != address(0)) {
2087             _updateUserFeesOnDeposit(to, from, amount);
2088         }
2089     }
2090 
2091     /**
2092      * @notice Prepare update of required reserve ratio (with time delay enforced).
2093      * @param _newRatio New required reserve ratio.
2094      * @return `true` if success.
2095      */
2096     function prepareNewRequiredReserves(uint256 _newRatio) external onlyGovernance returns (bool) {
2097         require(_newRatio <= ScaledMath.ONE, Error.INVALID_AMOUNT);
2098         return _prepare(_REQUIRED_RESERVES_KEY, _newRatio);
2099     }
2100 
2101     /**
2102      * @notice Execute required reserve ratio update (with time delay enforced).
2103      * @dev Needs to be called after the update was prepraed. Fails if called before time delay is met.
2104      * @return New required reserve ratio.
2105      */
2106     function executeNewRequiredReserves() external override returns (uint256) {
2107         uint256 requiredReserveRatio = _executeUInt256(_REQUIRED_RESERVES_KEY);
2108         _rebalanceVault();
2109         return requiredReserveRatio;
2110     }
2111 
2112     /**
2113      * @notice Reset the prepared required reserves.
2114      * @return `true` if success.
2115      */
2116     function resetRequiredReserves() external onlyGovernance returns (bool) {
2117         return _resetUInt256Config(_REQUIRED_RESERVES_KEY);
2118     }
2119 
2120     /**
2121      * @notice Prepare update of reserve deviation ratio (with time delay enforced).
2122      * @param newRatio New reserve deviation ratio.
2123      * @return `true` if success.
2124      */
2125     function prepareNewReserveDeviation(uint256 newRatio) external onlyGovernance returns (bool) {
2126         require(newRatio <= (ScaledMath.DECIMAL_SCALE * 50) / 100, Error.INVALID_AMOUNT);
2127         return _prepare(_RESERVE_DEVIATION_KEY, newRatio);
2128     }
2129 
2130     /**
2131      * @notice Execute reserve deviation ratio update (with time delay enforced).
2132      * @dev Needs to be called after the update was prepraed. Fails if called before time delay is met.
2133      * @return New reserve deviation ratio.
2134      */
2135     function executeNewReserveDeviation() external override returns (uint256) {
2136         uint256 reserveDeviation = _executeUInt256(_RESERVE_DEVIATION_KEY);
2137         _rebalanceVault();
2138         return reserveDeviation;
2139     }
2140 
2141     /**
2142      * @notice Reset the prepared reserve deviation.
2143      * @return `true` if success.
2144      */
2145     function resetNewReserveDeviation() external onlyGovernance returns (bool) {
2146         return _resetUInt256Config(_RESERVE_DEVIATION_KEY);
2147     }
2148 
2149     /**
2150      * @notice Prepare update of min withdrawal fee (with time delay enforced).
2151      * @param newFee New min withdrawal fee.
2152      * @return `true` if success.
2153      */
2154     function prepareNewMinWithdrawalFee(uint256 newFee) external onlyGovernance returns (bool) {
2155         _checkFeeInvariants(newFee, getMaxWithdrawalFee());
2156         return _prepare(_MIN_WITHDRAWAL_FEE_KEY, newFee);
2157     }
2158 
2159     /**
2160      * @notice Execute min withdrawal fee update (with time delay enforced).
2161      * @dev Needs to be called after the update was prepraed. Fails if called before time delay is met.
2162      * @return New withdrawal fee.
2163      */
2164     function executeNewMinWithdrawalFee() external returns (uint256) {
2165         uint256 newFee = _executeUInt256(_MIN_WITHDRAWAL_FEE_KEY);
2166         _checkFeeInvariants(newFee, getMaxWithdrawalFee());
2167         return newFee;
2168     }
2169 
2170     /**
2171      * @notice Reset the prepared min withdrawal fee
2172      * @return `true` if success.
2173      */
2174     function resetNewMinWithdrawalFee() external onlyGovernance returns (bool) {
2175         return _resetUInt256Config(_MIN_WITHDRAWAL_FEE_KEY);
2176     }
2177 
2178     /**
2179      * @notice Prepare update of max withdrawal fee (with time delay enforced).
2180      * @param newFee New max withdrawal fee.
2181      * @return `true` if success.
2182      */
2183     function prepareNewMaxWithdrawalFee(uint256 newFee) external onlyGovernance returns (bool) {
2184         _checkFeeInvariants(getMinWithdrawalFee(), newFee);
2185         return _prepare(_MAX_WITHDRAWAL_FEE_KEY, newFee);
2186     }
2187 
2188     /**
2189      * @notice Execute max withdrawal fee update (with time delay enforced).
2190      * @dev Needs to be called after the update was prepraed. Fails if called before time delay is met.
2191      * @return New max withdrawal fee.
2192      */
2193     function executeNewMaxWithdrawalFee() external override returns (uint256) {
2194         uint256 newFee = _executeUInt256(_MAX_WITHDRAWAL_FEE_KEY);
2195         _checkFeeInvariants(getMinWithdrawalFee(), newFee);
2196         return newFee;
2197     }
2198 
2199     /**
2200      * @notice Reset the prepared max fee.
2201      * @return `true` if success.
2202      */
2203     function resetNewMaxWithdrawalFee() external onlyGovernance returns (bool) {
2204         return _resetUInt256Config(_MAX_WITHDRAWAL_FEE_KEY);
2205     }
2206 
2207     /**
2208      * @notice Prepare update of withdrawal decrease fee period (with time delay enforced).
2209      * @param newPeriod New withdrawal fee decrease period.
2210      * @return `true` if success.
2211      */
2212     function prepareNewWithdrawalFeeDecreasePeriod(uint256 newPeriod)
2213         external
2214         onlyGovernance
2215         returns (bool)
2216     {
2217         return _prepare(_WITHDRAWAL_FEE_DECREASE_PERIOD_KEY, newPeriod);
2218     }
2219 
2220     /**
2221      * @notice Execute withdrawal fee decrease period update (with time delay enforced).
2222      * @dev Needs to be called after the update was prepraed. Fails if called before time delay is met.
2223      * @return New withdrawal fee decrease period.
2224      */
2225     function executeNewWithdrawalFeeDecreasePeriod() external returns (uint256) {
2226         return _executeUInt256(_WITHDRAWAL_FEE_DECREASE_PERIOD_KEY);
2227     }
2228 
2229     /**
2230      * @notice Reset the prepared withdrawal fee decrease period update.
2231      * @return `true` if success.
2232      */
2233     function resetNewWithdrawalFeeDecreasePeriod() external onlyGovernance returns (bool) {
2234         return _resetUInt256Config(_WITHDRAWAL_FEE_DECREASE_PERIOD_KEY);
2235     }
2236 
2237     /**
2238      * @notice Set the staker vault for this pool's LP token
2239      * @dev Staker vault and LP token pairs are immutable and the staker vault can only be set once for a pool.
2240      *      Only one vault exists per LP token. This information will be retrieved from the controller of the pool.
2241      * @return Address of the new staker vault for the pool.
2242      */
2243     function setStaker()
2244         external
2245         override
2246         onlyRoles2(Roles.GOVERNANCE, Roles.POOL_FACTORY)
2247         returns (bool)
2248     {
2249         require(address(staker) == address(0), Error.ADDRESS_ALREADY_SET);
2250         address stakerVault = addressProvider.getStakerVault(address(lpToken));
2251         require(stakerVault != address(0), Error.ZERO_ADDRESS_NOT_ALLOWED);
2252         staker = IStakerVault(stakerVault);
2253         _approveStakerVaultSpendingLpTokens();
2254         emit StakerVaultSet(stakerVault);
2255         return true;
2256     }
2257 
2258     /**
2259      * @notice Prepare setting a new Vault (with time delay enforced).
2260      * @param _vault Address of new Vault contract.
2261      * @return `true` if success.
2262      */
2263     function prepareNewVault(address _vault) external onlyGovernance returns (bool) {
2264         _prepare(_VAULT_KEY, _vault);
2265         return true;
2266     }
2267 
2268     /**
2269      * @notice Execute Vault update (with time delay enforced).
2270      * @dev Needs to be called after the update was prepraed. Fails if called before time delay is met.
2271      * @return Address of new Vault contract.
2272      */
2273     function executeNewVault() external override returns (address) {
2274         IVault vault = getVault();
2275         if (address(vault) != address(0)) {
2276             vault.withdrawAll();
2277         }
2278         address newVault = _executeAddress(_VAULT_KEY);
2279         addressProvider.updateVault(address(vault), newVault);
2280         return newVault;
2281     }
2282 
2283     /**
2284      * @notice Reset the vault deadline.
2285      * @return `true` if success.
2286      */
2287     function resetNewVault() external onlyGovernance returns (bool) {
2288         return _resetAddressConfig(_VAULT_KEY);
2289     }
2290 
2291     /**
2292      * @notice Redeems the underlying asset by burning LP tokens.
2293      * @param redeemLpTokens Number of tokens to burn for redeeming the underlying.
2294      * @return Actual amount of the underlying redeemed.
2295      */
2296     function redeem(uint256 redeemLpTokens) external override returns (uint256) {
2297         return redeem(redeemLpTokens, 0);
2298     }
2299 
2300     /**
2301      * @notice Uncap the pool to remove the deposit limit.
2302      * @return `true` if success.
2303      */
2304     function uncap() external override onlyGovernance returns (bool) {
2305         require(isCapped(), Error.NOT_CAPPED);
2306 
2307         depositCap = 0;
2308         return true;
2309     }
2310 
2311     /**
2312      * @notice Update the deposit cap value.
2313      * @param _depositCap The maximum allowed deposits per address in the pool
2314      * @return `true` if success.
2315      */
2316     function updateDepositCap(uint256 _depositCap) external override onlyGovernance returns (bool) {
2317         require(isCapped(), Error.NOT_CAPPED);
2318         require(depositCap != _depositCap, Error.SAME_AS_CURRENT);
2319         require(_depositCap > 0, Error.INVALID_AMOUNT);
2320 
2321         depositCap = _depositCap;
2322         return true;
2323     }
2324 
2325     /**
2326      * @notice Rebalance vault according to required underlying backing reserves.
2327      */
2328     function rebalanceVault() external onlyGovernance {
2329         _rebalanceVault();
2330     }
2331 
2332     /**
2333      * @notice Deposit funds for an address into liquidity pool and mint LP tokens in exchange.
2334      * @param account Account to deposit for.
2335      * @param depositAmount Amount of the underlying asset to supply.
2336      * @return Actual amount minted.
2337      */
2338     function depositFor(address account, uint256 depositAmount)
2339         external
2340         payable
2341         override
2342         returns (uint256)
2343     {
2344         return depositFor(account, depositAmount, 0);
2345     }
2346 
2347     /**
2348      * @notice Redeems the underlying asset by burning LP tokens, unstaking any LP tokens needed.
2349      * @param redeemLpTokens Number of tokens to unstake and/or burn for redeeming the underlying.
2350      * @param minRedeemAmount Minimum amount of underlying that should be received.
2351      * @return Actual amount of the underlying redeemed.
2352      */
2353     function unstakeAndRedeem(uint256 redeemLpTokens, uint256 minRedeemAmount)
2354         external
2355         override
2356         returns (uint256)
2357     {
2358         uint256 lpBalance_ = lpToken.balanceOf(msg.sender);
2359         require(
2360             lpBalance_ + staker.balanceOf(msg.sender) >= redeemLpTokens,
2361             Error.INSUFFICIENT_BALANCE
2362         );
2363         if (lpBalance_ < redeemLpTokens) {
2364             staker.unstakeFor(msg.sender, msg.sender, redeemLpTokens - lpBalance_);
2365         }
2366         return redeem(redeemLpTokens, minRedeemAmount);
2367     }
2368 
2369     /**
2370      * @notice Returns the address of the LP token of this pool
2371      * @return The address of the LP token
2372      */
2373     function getLpToken() external view override returns (address) {
2374         return address(lpToken);
2375     }
2376 
2377     /**
2378      * @notice Calculates the amount of LP tokens that need to be redeemed to get a certain amount of underlying (includes fees and exchange rate)
2379      * @param account Address of the account redeeming.
2380      * @param underlyingAmount The amount of underlying desired.
2381      * @return Amount of LP tokens that need to be redeemed.
2382      */
2383     function calcRedeem(address account, uint256 underlyingAmount)
2384         external
2385         view
2386         override
2387         returns (uint256)
2388     {
2389         require(underlyingAmount > 0, Error.INVALID_AMOUNT);
2390         ILpToken lpToken_ = lpToken;
2391         require(lpToken_.balanceOf(account) > 0, Error.INSUFFICIENT_BALANCE);
2392 
2393         uint256 currentExchangeRate = exchangeRate();
2394         uint256 withoutFeesLpAmount = underlyingAmount.scaledDiv(currentExchangeRate);
2395         if (withoutFeesLpAmount == lpToken_.totalSupply()) {
2396             return withoutFeesLpAmount;
2397         }
2398 
2399         WithdrawalFeeMeta memory meta = withdrawalFeeMetas[account];
2400 
2401         uint256 currentFeeRatio = 0;
2402         if (!addressProvider.isAction(account)) {
2403             currentFeeRatio = getNewCurrentFees(
2404                 meta.timeToWait,
2405                 meta.lastActionTimestamp,
2406                 meta.feeRatio
2407             );
2408         }
2409         uint256 scalingFactor = currentExchangeRate.scaledMul((ScaledMath.ONE - currentFeeRatio));
2410         uint256 neededLpTokens = underlyingAmount.scaledDivRoundUp(scalingFactor);
2411 
2412         return neededLpTokens;
2413     }
2414 
2415     function getUnderlying() external view virtual override returns (address);
2416 
2417     /**
2418      * @notice Deposit funds for an address into liquidity pool and mint LP tokens in exchange.
2419      * @param account Account to deposit for.
2420      * @param depositAmount Amount of the underlying asset to supply.
2421      * @param minTokenAmount Minimum amount of LP tokens that should be minted.
2422      * @return Actual amount minted.
2423      */
2424     function depositFor(
2425         address account,
2426         uint256 depositAmount,
2427         uint256 minTokenAmount
2428     ) public payable override notPaused returns (uint256) {
2429         uint256 rate = exchangeRate();
2430 
2431         if (isCapped()) {
2432             uint256 lpBalance = lpToken.balanceOf(account);
2433             uint256 stakedAndLockedBalance = staker.stakedAndActionLockedBalanceOf(account);
2434             uint256 currentUnderlyingBalance = (lpBalance + stakedAndLockedBalance).scaledMul(rate);
2435             require(
2436                 currentUnderlyingBalance + depositAmount <= depositCap,
2437                 Error.EXCEEDS_DEPOSIT_CAP
2438             );
2439         }
2440 
2441         _doTransferIn(msg.sender, depositAmount);
2442         uint256 mintedLp = depositAmount.scaledDiv(rate);
2443         require(mintedLp >= minTokenAmount, Error.INVALID_AMOUNT);
2444 
2445         lpToken.mint(account, mintedLp);
2446         _rebalanceVault();
2447 
2448         if (msg.sender == account || address(this) == account) {
2449             emit Deposit(msg.sender, depositAmount, mintedLp);
2450         } else {
2451             emit DepositFor(msg.sender, account, depositAmount, mintedLp);
2452         }
2453         return mintedLp;
2454     }
2455 
2456     /**
2457      * @notice Redeems the underlying asset by burning LP tokens.
2458      * @param redeemLpTokens Number of tokens to burn for redeeming the underlying.
2459      * @param minRedeemAmount Minimum amount of underlying that should be received.
2460      * @return Actual amount of the underlying redeemed.
2461      */
2462     function redeem(uint256 redeemLpTokens, uint256 minRedeemAmount)
2463         public
2464         override
2465         returns (uint256)
2466     {
2467         require(redeemLpTokens > 0, Error.INVALID_AMOUNT);
2468         ILpToken lpToken_ = lpToken;
2469         require(lpToken_.balanceOf(msg.sender) >= redeemLpTokens, Error.INSUFFICIENT_BALANCE);
2470 
2471         uint256 withdrawalFee = addressProvider.isAction(msg.sender)
2472             ? 0
2473             : getWithdrawalFee(msg.sender, redeemLpTokens);
2474         uint256 redeemMinusFees = redeemLpTokens - withdrawalFee;
2475         // Pay no fees on the last withdrawal (avoid locking funds in the pool)
2476         if (redeemLpTokens == lpToken_.totalSupply()) {
2477             redeemMinusFees = redeemLpTokens;
2478         }
2479         uint256 redeemUnderlying = redeemMinusFees.scaledMul(exchangeRate());
2480         require(redeemUnderlying >= minRedeemAmount, Error.NOT_ENOUGH_FUNDS_WITHDRAWN);
2481 
2482         _rebalanceVault(redeemUnderlying);
2483 
2484         lpToken_.burn(msg.sender, redeemLpTokens);
2485         _doTransferOut(payable(msg.sender), redeemUnderlying);
2486         emit Redeem(msg.sender, redeemUnderlying, redeemLpTokens);
2487         return redeemUnderlying;
2488     }
2489 
2490     /**
2491      * @return the current required reserves ratio
2492      */
2493     function getRequiredReserveRatio() public view virtual returns (uint256) {
2494         return currentUInts256[_REQUIRED_RESERVES_KEY];
2495     }
2496 
2497     /**
2498      * @return the current maximum reserve deviation ratio
2499      */
2500     function getMaxReserveDeviationRatio() public view virtual returns (uint256) {
2501         return currentUInts256[_RESERVE_DEVIATION_KEY];
2502     }
2503 
2504     /**
2505      * @notice Returns the current minimum withdrawal fee
2506      */
2507     function getMinWithdrawalFee() public view returns (uint256) {
2508         return currentUInts256[_MIN_WITHDRAWAL_FEE_KEY];
2509     }
2510 
2511     /**
2512      * @notice Returns the current maximum withdrawal fee
2513      */
2514     function getMaxWithdrawalFee() public view returns (uint256) {
2515         return currentUInts256[_MAX_WITHDRAWAL_FEE_KEY];
2516     }
2517 
2518     /**
2519      * @notice Returns the current withdrawal fee decrease period
2520      */
2521     function getWithdrawalFeeDecreasePeriod() public view returns (uint256) {
2522         return currentUInts256[_WITHDRAWAL_FEE_DECREASE_PERIOD_KEY];
2523     }
2524 
2525     /**
2526      * @return the current vault of the liquidity pool
2527      */
2528     function getVault() public view virtual override returns (IVault) {
2529         return IVault(currentAddresses[_VAULT_KEY]);
2530     }
2531 
2532     /**
2533      * @notice Compute current exchange rate of LP tokens to underlying scaled to 1e18.
2534      * @dev Exchange rate means: underlying = LP token * exchangeRate
2535      * @return Current exchange rate.
2536      */
2537     function exchangeRate() public view override returns (uint256) {
2538         uint256 totalUnderlying_ = totalUnderlying();
2539         uint256 totalSupply = lpToken.totalSupply();
2540         if (totalSupply == 0 || totalUnderlying_ == 0) {
2541             return ScaledMath.ONE;
2542         }
2543 
2544         return totalUnderlying_.scaledDiv(totalSupply);
2545     }
2546 
2547     /**
2548      * @notice Compute total amount of underlying tokens for this pool.
2549      * @return Total amount of underlying in pool.
2550      */
2551     function totalUnderlying() public view returns (uint256) {
2552         IVault vault = getVault();
2553         uint256 balanceUnderlying = _getBalanceUnderlying();
2554         if (address(vault) == address(0)) {
2555             return balanceUnderlying;
2556         }
2557         uint256 investedUnderlying = vault.getTotalUnderlying();
2558         return investedUnderlying + balanceUnderlying;
2559     }
2560 
2561     /**
2562      * @notice Retuns if the pool has an active deposit limit
2563      * @return `true` if there is currently a deposit limit
2564      */
2565     function isCapped() public view override returns (bool) {
2566         return depositCap != 0;
2567     }
2568 
2569     /**
2570      * @notice Returns the withdrawal fee for `account`
2571      * @param account Address to get the withdrawal fee for
2572      * @param amount Amount to calculate the withdrawal fee for
2573      * @return Withdrawal fee in LP tokens
2574      */
2575     function getWithdrawalFee(address account, uint256 amount)
2576         public
2577         view
2578         override
2579         returns (uint256)
2580     {
2581         WithdrawalFeeMeta memory meta = withdrawalFeeMetas[account];
2582 
2583         if (lpToken.balanceOf(account) == 0) {
2584             return 0;
2585         }
2586         uint256 currentFee = getNewCurrentFees(
2587             meta.timeToWait,
2588             meta.lastActionTimestamp,
2589             meta.feeRatio
2590         );
2591         return amount.scaledMul(currentFee);
2592     }
2593 
2594     /**
2595      * @notice Calculates the withdrawal fee a user would currently need to pay on currentBalance.
2596      * @param timeToWait The total time to wait until the withdrawal fee reached the min. fee
2597      * @param lastActionTimestamp Timestamp of the last fee update
2598      * @param feeRatio Fees that would currently be paid on the user's entire balance
2599      * @return Updated fee amount on the currentBalance
2600      */
2601     function getNewCurrentFees(
2602         uint256 timeToWait,
2603         uint256 lastActionTimestamp,
2604         uint256 feeRatio
2605     ) public view returns (uint256) {
2606         uint256 timeElapsed = _getTime() - lastActionTimestamp;
2607         uint256 minFeePercentage = getMinWithdrawalFee();
2608         if (timeElapsed >= timeToWait) {
2609             return minFeePercentage;
2610         }
2611         uint256 elapsedShare = timeElapsed.scaledDiv(timeToWait);
2612         return feeRatio - (feeRatio - minFeePercentage).scaledMul(elapsedShare);
2613     }
2614 
2615     function _rebalanceVault() internal {
2616         _rebalanceVault(0);
2617     }
2618 
2619     function _initialize(
2620         string memory name_,
2621         uint256 depositCap_,
2622         address vault_
2623     ) internal initializer returns (bool) {
2624         name = name_;
2625         depositCap = depositCap_;
2626 
2627         _setConfig(_WITHDRAWAL_FEE_DECREASE_PERIOD_KEY, _INITIAL_FEE_DECREASE_PERIOD);
2628         _setConfig(_MAX_WITHDRAWAL_FEE_KEY, _INITIAL_MAX_WITHDRAWAL_FEE);
2629         _setConfig(_REQUIRED_RESERVES_KEY, ScaledMath.ONE);
2630         _setConfig(_RESERVE_DEVIATION_KEY, _INITIAL_RESERVE_DEVIATION);
2631         _setConfig(_VAULT_KEY, vault_);
2632         return true;
2633     }
2634 
2635     function _approveStakerVaultSpendingLpTokens() internal {
2636         address staker_ = address(staker);
2637         address lpToken_ = address(lpToken);
2638         if (staker_ == address(0) || lpToken_ == address(0)) return;
2639         IERC20(lpToken_).safeApprove(staker_, type(uint256).max);
2640     }
2641 
2642     function _doTransferIn(address from, uint256 amount) internal virtual;
2643 
2644     function _doTransferOut(address payable to, uint256 amount) internal virtual;
2645 
2646     /**
2647      * @dev Rebalances the pool's allocations to the vault
2648      * @param underlyingToWithdraw Amount of underlying to withdraw such that after the withdrawal the pool and vault allocations are correctly balanced.
2649      */
2650     function _rebalanceVault(uint256 underlyingToWithdraw) internal {
2651         IVault vault = getVault();
2652 
2653         if (address(vault) == address(0)) return;
2654         uint256 lockedLp = staker.getStakedByActions();
2655         uint256 totalUnderlyingStaked = lockedLp.scaledMul(exchangeRate());
2656 
2657         uint256 underlyingBalance = _getBalanceUnderlying(true);
2658         uint256 maximumDeviation = totalUnderlyingStaked.scaledMul(getMaxReserveDeviationRatio());
2659 
2660         uint256 nextTargetBalance = totalUnderlyingStaked.scaledMul(getRequiredReserveRatio());
2661 
2662         if (
2663             underlyingToWithdraw > underlyingBalance ||
2664             (underlyingBalance - underlyingToWithdraw) + maximumDeviation < nextTargetBalance
2665         ) {
2666             uint256 requiredDeposits = nextTargetBalance + underlyingToWithdraw - underlyingBalance;
2667             vault.withdraw(requiredDeposits);
2668         } else {
2669             uint256 nextBalance = underlyingBalance - underlyingToWithdraw;
2670             if (nextBalance > nextTargetBalance + maximumDeviation) {
2671                 uint256 excessDeposits = nextBalance - nextTargetBalance;
2672                 _doTransferOut(payable(address(vault)), excessDeposits);
2673                 vault.deposit();
2674             }
2675         }
2676     }
2677 
2678     function _updateUserFeesOnDeposit(
2679         address account,
2680         address from,
2681         uint256 amountAdded
2682     ) internal {
2683         WithdrawalFeeMeta storage meta = withdrawalFeeMetas[account];
2684         uint256 balance = lpToken.balanceOf(account) +
2685             staker.stakedAndActionLockedBalanceOf(account);
2686         uint256 newCurrentFeeRatio = getNewCurrentFees(
2687             meta.timeToWait,
2688             meta.lastActionTimestamp,
2689             meta.feeRatio
2690         );
2691         uint256 shareAdded = amountAdded.scaledDiv(amountAdded + balance);
2692         uint256 shareExisting = ScaledMath.ONE - shareAdded;
2693         uint256 feeOnDeposit;
2694         if (from == address(0)) {
2695             feeOnDeposit = getMaxWithdrawalFee();
2696         } else {
2697             WithdrawalFeeMeta storage fromMeta = withdrawalFeeMetas[from];
2698             feeOnDeposit = getNewCurrentFees(
2699                 fromMeta.timeToWait,
2700                 fromMeta.lastActionTimestamp,
2701                 fromMeta.feeRatio
2702             );
2703         }
2704 
2705         uint256 newFeeRatio = shareExisting.scaledMul(newCurrentFeeRatio) +
2706             shareAdded.scaledMul(feeOnDeposit);
2707 
2708         meta.feeRatio = uint64(newFeeRatio);
2709         meta.timeToWait = uint64(getWithdrawalFeeDecreasePeriod());
2710         meta.lastActionTimestamp = uint64(_getTime());
2711     }
2712 
2713     function _getBalanceUnderlying() internal view virtual returns (uint256);
2714 
2715     function _getBalanceUnderlying(bool transferInDone) internal view virtual returns (uint256);
2716 
2717     function _isAuthorizedToPause(address account) internal view override returns (bool) {
2718         return _roleManager().hasRole(Roles.GOVERNANCE, account);
2719     }
2720 
2721     /**
2722      * @dev Overriden for testing
2723      */
2724     function _getTime() internal view virtual returns (uint256) {
2725         return block.timestamp;
2726     }
2727 
2728     function _checkFeeInvariants(uint256 minFee, uint256 maxFee) internal pure {
2729         require(maxFee >= minFee, Error.INVALID_AMOUNT);
2730         require(maxFee <= _MAX_WITHDRAWAL_FEE, Error.INVALID_AMOUNT);
2731     }
2732 }
2733 
2734 
2735 // File interfaces/pool/IErc20Pool.sol
2736 
2737 pragma solidity 0.8.9;
2738 
2739 interface IErc20Pool {
2740     function initialize(
2741         string memory name_,
2742         address underlying_,
2743         uint256 depositCap_,
2744         address vault_
2745     ) external returns (bool);
2746 }
2747 
2748 // SPDX-License-Identifier: GPL-3.0-or-later
2749 
2750 // File contracts/pool/Erc20Pool.sol
2751 
2752 pragma solidity 0.8.9;
2753 
2754 
2755 contract Erc20Pool is LiquidityPool, IErc20Pool {
2756     using SafeERC20 for IERC20;
2757 
2758     address private _underlying;
2759 
2760     constructor(IController _controller) LiquidityPool(_controller) {}
2761 
2762     function initialize(
2763         string memory name_,
2764         address underlying_,
2765         uint256 depositCap_,
2766         address vault_
2767     ) public override returns (bool) {
2768         require(underlying_ != address(0), Error.ZERO_ADDRESS_NOT_ALLOWED);
2769         _underlying = underlying_;
2770         return _initialize(name_, depositCap_, vault_);
2771     }
2772 
2773     function getUnderlying() public view override returns (address) {
2774         return _underlying;
2775     }
2776 
2777     function _doTransferIn(address from, uint256 amount) internal override {
2778         require(msg.value == 0, Error.INVALID_VALUE);
2779         IERC20(_underlying).safeTransferFrom(from, address(this), amount);
2780     }
2781 
2782     function _doTransferOut(address payable to, uint256 amount) internal override {
2783         IERC20(_underlying).safeTransfer(to, amount);
2784     }
2785 
2786     function _getBalanceUnderlying() internal view override returns (uint256) {
2787         return IERC20(_underlying).balanceOf(address(this));
2788     }
2789 
2790     function _getBalanceUnderlying(bool) internal view override returns (uint256) {
2791         return _getBalanceUnderlying();
2792     }
2793 }