1 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.7.0
2 
3 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Emitted when `value` tokens are moved from one account (`from`) to
13      * another (`to`).
14      *
15      * Note that `value` may be zero.
16      */
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     /**
20      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
21      * a call to {approve}. `value` is the new allowance.
22      */
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 
25     /**
26      * @dev Returns the amount of tokens in existence.
27      */
28     function totalSupply() external view returns (uint256);
29 
30     /**
31      * @dev Returns the amount of tokens owned by `account`.
32      */
33     function balanceOf(address account) external view returns (uint256);
34 
35     /**
36      * @dev Moves `amount` tokens from the caller's account to `to`.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * Emits a {Transfer} event.
41      */
42     function transfer(address to, uint256 amount) external returns (bool);
43 
44     /**
45      * @dev Returns the remaining number of tokens that `spender` will be
46      * allowed to spend on behalf of `owner` through {transferFrom}. This is
47      * zero by default.
48      *
49      * This value changes when {approve} or {transferFrom} are called.
50      */
51     function allowance(address owner, address spender) external view returns (uint256);
52 
53     /**
54      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * IMPORTANT: Beware that changing an allowance with this method brings the risk
59      * that someone may use both the old and the new allowance by unfortunate
60      * transaction ordering. One possible solution to mitigate this race
61      * condition is to first reduce the spender's allowance to 0 and set the
62      * desired value afterwards:
63      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
64      *
65      * Emits an {Approval} event.
66      */
67     function approve(address spender, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Moves `amount` tokens from `from` to `to` using the
71      * allowance mechanism. `amount` is then deducted from the caller's
72      * allowance.
73      *
74      * Returns a boolean value indicating whether the operation succeeded.
75      *
76      * Emits a {Transfer} event.
77      */
78     function transferFrom(
79         address from,
80         address to,
81         uint256 amount
82     ) external returns (bool);
83 }
84 
85 // File @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol@v4.7.0
86 
87 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
88 
89 pragma solidity ^0.8.0;
90 
91 /**
92  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
93  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
94  *
95  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
96  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
97  * need to send a transaction, and thus is not required to hold Ether at all.
98  */
99 interface IERC20Permit {
100     /**
101      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
102      * given ``owner``'s signed approval.
103      *
104      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
105      * ordering also apply here.
106      *
107      * Emits an {Approval} event.
108      *
109      * Requirements:
110      *
111      * - `spender` cannot be the zero address.
112      * - `deadline` must be a timestamp in the future.
113      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
114      * over the EIP712-formatted function arguments.
115      * - the signature must use ``owner``'s current nonce (see {nonces}).
116      *
117      * For more information on the signature format, see the
118      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
119      * section].
120      */
121     function permit(
122         address owner,
123         address spender,
124         uint256 value,
125         uint256 deadline,
126         uint8 v,
127         bytes32 r,
128         bytes32 s
129     ) external;
130 
131     /**
132      * @dev Returns the current nonce for `owner`. This value must be
133      * included whenever a signature is generated for {permit}.
134      *
135      * Every successful call to {permit} increases ``owner``'s nonce by one. This
136      * prevents a signature from being used multiple times.
137      */
138     function nonces(address owner) external view returns (uint256);
139 
140     /**
141      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
142      */
143     // solhint-disable-next-line func-name-mixedcase
144     function DOMAIN_SEPARATOR() external view returns (bytes32);
145 }
146 
147 // File @openzeppelin/contracts/utils/Address.sol@v4.7.0
148 
149 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
150 
151 pragma solidity ^0.8.1;
152 
153 /**
154  * @dev Collection of functions related to the address type
155  */
156 library Address {
157     /**
158      * @dev Returns true if `account` is a contract.
159      *
160      * [IMPORTANT]
161      * ====
162      * It is unsafe to assume that an address for which this function returns
163      * false is an externally-owned account (EOA) and not a contract.
164      *
165      * Among others, `isContract` will return false for the following
166      * types of addresses:
167      *
168      *  - an externally-owned account
169      *  - a contract in construction
170      *  - an address where a contract will be created
171      *  - an address where a contract lived, but was destroyed
172      * ====
173      *
174      * [IMPORTANT]
175      * ====
176      * You shouldn't rely on `isContract` to protect against flash loan attacks!
177      *
178      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
179      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
180      * constructor.
181      * ====
182      */
183     function isContract(address account) internal view returns (bool) {
184         // This method relies on extcodesize/address.code.length, which returns 0
185         // for contracts in construction, since the code is only stored at the end
186         // of the constructor execution.
187 
188         return account.code.length > 0;
189     }
190 
191     /**
192      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
193      * `recipient`, forwarding all available gas and reverting on errors.
194      *
195      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
196      * of certain opcodes, possibly making contracts go over the 2300 gas limit
197      * imposed by `transfer`, making them unable to receive funds via
198      * `transfer`. {sendValue} removes this limitation.
199      *
200      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
201      *
202      * IMPORTANT: because control is transferred to `recipient`, care must be
203      * taken to not create reentrancy vulnerabilities. Consider using
204      * {ReentrancyGuard} or the
205      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
206      */
207     function sendValue(address payable recipient, uint256 amount) internal {
208         require(address(this).balance >= amount, "Address: insufficient balance");
209 
210         (bool success, ) = recipient.call{value: amount}("");
211         require(success, "Address: unable to send value, recipient may have reverted");
212     }
213 
214     /**
215      * @dev Performs a Solidity function call using a low level `call`. A
216      * plain `call` is an unsafe replacement for a function call: use this
217      * function instead.
218      *
219      * If `target` reverts with a revert reason, it is bubbled up by this
220      * function (like regular Solidity function calls).
221      *
222      * Returns the raw returned data. To convert to the expected return value,
223      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
224      *
225      * Requirements:
226      *
227      * - `target` must be a contract.
228      * - calling `target` with `data` must not revert.
229      *
230      * _Available since v3.1._
231      */
232     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
233         return functionCall(target, data, "Address: low-level call failed");
234     }
235 
236     /**
237      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
238      * `errorMessage` as a fallback revert reason when `target` reverts.
239      *
240      * _Available since v3.1._
241      */
242     function functionCall(
243         address target,
244         bytes memory data,
245         string memory errorMessage
246     ) internal returns (bytes memory) {
247         return functionCallWithValue(target, data, 0, errorMessage);
248     }
249 
250     /**
251      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
252      * but also transferring `value` wei to `target`.
253      *
254      * Requirements:
255      *
256      * - the calling contract must have an ETH balance of at least `value`.
257      * - the called Solidity function must be `payable`.
258      *
259      * _Available since v3.1._
260      */
261     function functionCallWithValue(
262         address target,
263         bytes memory data,
264         uint256 value
265     ) internal returns (bytes memory) {
266         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
267     }
268 
269     /**
270      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
271      * with `errorMessage` as a fallback revert reason when `target` reverts.
272      *
273      * _Available since v3.1._
274      */
275     function functionCallWithValue(
276         address target,
277         bytes memory data,
278         uint256 value,
279         string memory errorMessage
280     ) internal returns (bytes memory) {
281         require(address(this).balance >= value, "Address: insufficient balance for call");
282         require(isContract(target), "Address: call to non-contract");
283 
284         (bool success, bytes memory returndata) = target.call{value: value}(data);
285         return verifyCallResult(success, returndata, errorMessage);
286     }
287 
288     /**
289      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
290      * but performing a static call.
291      *
292      * _Available since v3.3._
293      */
294     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
295         return functionStaticCall(target, data, "Address: low-level static call failed");
296     }
297 
298     /**
299      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
300      * but performing a static call.
301      *
302      * _Available since v3.3._
303      */
304     function functionStaticCall(
305         address target,
306         bytes memory data,
307         string memory errorMessage
308     ) internal view returns (bytes memory) {
309         require(isContract(target), "Address: static call to non-contract");
310 
311         (bool success, bytes memory returndata) = target.staticcall(data);
312         return verifyCallResult(success, returndata, errorMessage);
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
317      * but performing a delegate call.
318      *
319      * _Available since v3.4._
320      */
321     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
322         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
327      * but performing a delegate call.
328      *
329      * _Available since v3.4._
330      */
331     function functionDelegateCall(
332         address target,
333         bytes memory data,
334         string memory errorMessage
335     ) internal returns (bytes memory) {
336         require(isContract(target), "Address: delegate call to non-contract");
337 
338         (bool success, bytes memory returndata) = target.delegatecall(data);
339         return verifyCallResult(success, returndata, errorMessage);
340     }
341 
342     /**
343      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
344      * revert reason using the provided one.
345      *
346      * _Available since v4.3._
347      */
348     function verifyCallResult(
349         bool success,
350         bytes memory returndata,
351         string memory errorMessage
352     ) internal pure returns (bytes memory) {
353         if (success) {
354             return returndata;
355         } else {
356             // Look for revert reason and bubble it up if present
357             if (returndata.length > 0) {
358                 // The easiest way to bubble the revert reason is using memory via assembly
359                 /// @solidity memory-safe-assembly
360                 assembly {
361                     let returndata_size := mload(returndata)
362                     revert(add(32, returndata), returndata_size)
363                 }
364             } else {
365                 revert(errorMessage);
366             }
367         }
368     }
369 }
370 
371 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.7.0
372 
373 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/utils/SafeERC20.sol)
374 
375 pragma solidity ^0.8.0;
376 
377 /**
378  * @title SafeERC20
379  * @dev Wrappers around ERC20 operations that throw on failure (when the token
380  * contract returns false). Tokens that return no value (and instead revert or
381  * throw on failure) are also supported, non-reverting calls are assumed to be
382  * successful.
383  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
384  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
385  */
386 library SafeERC20 {
387     using Address for address;
388 
389     function safeTransfer(
390         IERC20 token,
391         address to,
392         uint256 value
393     ) internal {
394         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
395     }
396 
397     function safeTransferFrom(
398         IERC20 token,
399         address from,
400         address to,
401         uint256 value
402     ) internal {
403         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
404     }
405 
406     /**
407      * @dev Deprecated. This function has issues similar to the ones found in
408      * {IERC20-approve}, and its usage is discouraged.
409      *
410      * Whenever possible, use {safeIncreaseAllowance} and
411      * {safeDecreaseAllowance} instead.
412      */
413     function safeApprove(
414         IERC20 token,
415         address spender,
416         uint256 value
417     ) internal {
418         // safeApprove should only be called when setting an initial allowance,
419         // or when resetting it to zero. To increase and decrease it, use
420         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
421         require(
422             (value == 0) || (token.allowance(address(this), spender) == 0),
423             "SafeERC20: approve from non-zero to non-zero allowance"
424         );
425         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
426     }
427 
428     function safeIncreaseAllowance(
429         IERC20 token,
430         address spender,
431         uint256 value
432     ) internal {
433         uint256 newAllowance = token.allowance(address(this), spender) + value;
434         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
435     }
436 
437     function safeDecreaseAllowance(
438         IERC20 token,
439         address spender,
440         uint256 value
441     ) internal {
442         unchecked {
443             uint256 oldAllowance = token.allowance(address(this), spender);
444             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
445             uint256 newAllowance = oldAllowance - value;
446             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
447         }
448     }
449 
450     function safePermit(
451         IERC20Permit token,
452         address owner,
453         address spender,
454         uint256 value,
455         uint256 deadline,
456         uint8 v,
457         bytes32 r,
458         bytes32 s
459     ) internal {
460         uint256 nonceBefore = token.nonces(owner);
461         token.permit(owner, spender, value, deadline, v, r, s);
462         uint256 nonceAfter = token.nonces(owner);
463         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
464     }
465 
466     /**
467      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
468      * on the return value: the return value is optional (but if data is returned, it must not be false).
469      * @param token The token targeted by the call.
470      * @param data The call data (encoded using abi.encode or one of its variants).
471      */
472     function _callOptionalReturn(IERC20 token, bytes memory data) private {
473         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
474         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
475         // the target address contains contract code and also asserts for success in the low-level call.
476 
477         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
478         if (returndata.length > 0) {
479             // Return data is optional
480             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
481         }
482     }
483 }
484 
485 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.7.0
486 
487 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
488 
489 pragma solidity ^0.8.0;
490 
491 /**
492  * @title ERC721 token receiver interface
493  * @dev Interface for any contract that wants to support safeTransfers
494  * from ERC721 asset contracts.
495  */
496 interface IERC721Receiver {
497     /**
498      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
499      * by `operator` from `from`, this function is called.
500      *
501      * It must return its Solidity selector to confirm the token transfer.
502      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
503      *
504      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
505      */
506     function onERC721Received(
507         address operator,
508         address from,
509         uint256 tokenId,
510         bytes calldata data
511     ) external returns (bytes4);
512 }
513 
514 // File @openzeppelin/contracts/utils/Strings.sol@v4.7.0
515 
516 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
517 
518 pragma solidity ^0.8.0;
519 
520 /**
521  * @dev String operations.
522  */
523 library Strings {
524     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
525     uint8 private constant _ADDRESS_LENGTH = 20;
526 
527     /**
528      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
529      */
530     function toString(uint256 value) internal pure returns (string memory) {
531         // Inspired by OraclizeAPI's implementation - MIT licence
532         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
533 
534         if (value == 0) {
535             return "0";
536         }
537         uint256 temp = value;
538         uint256 digits;
539         while (temp != 0) {
540             digits++;
541             temp /= 10;
542         }
543         bytes memory buffer = new bytes(digits);
544         while (value != 0) {
545             digits -= 1;
546             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
547             value /= 10;
548         }
549         return string(buffer);
550     }
551 
552     /**
553      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
554      */
555     function toHexString(uint256 value) internal pure returns (string memory) {
556         if (value == 0) {
557             return "0x00";
558         }
559         uint256 temp = value;
560         uint256 length = 0;
561         while (temp != 0) {
562             length++;
563             temp >>= 8;
564         }
565         return toHexString(value, length);
566     }
567 
568     /**
569      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
570      */
571     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
572         bytes memory buffer = new bytes(2 * length + 2);
573         buffer[0] = "0";
574         buffer[1] = "x";
575         for (uint256 i = 2 * length + 1; i > 1; --i) {
576             buffer[i] = _HEX_SYMBOLS[value & 0xf];
577             value >>= 4;
578         }
579         require(value == 0, "Strings: hex length insufficient");
580         return string(buffer);
581     }
582 
583     /**
584      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
585      */
586     function toHexString(address addr) internal pure returns (string memory) {
587         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
588     }
589 }
590 
591 // File @openzeppelin/contracts/proxy/utils/Initializable.sol@v4.7.0
592 
593 // OpenZeppelin Contracts (last updated v4.7.0) (proxy/utils/Initializable.sol)
594 
595 pragma solidity ^0.8.2;
596 
597 /**
598  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
599  * behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
600  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
601  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
602  *
603  * The initialization functions use a version number. Once a version number is used, it is consumed and cannot be
604  * reused. This mechanism prevents re-execution of each "step" but allows the creation of new initialization steps in
605  * case an upgrade adds a module that needs to be initialized.
606  *
607  * For example:
608  *
609  * [.hljs-theme-light.nopadding]
610  * ```
611  * contract MyToken is ERC20Upgradeable {
612  *     function initialize() initializer public {
613  *         __ERC20_init("MyToken", "MTK");
614  *     }
615  * }
616  * contract MyTokenV2 is MyToken, ERC20PermitUpgradeable {
617  *     function initializeV2() reinitializer(2) public {
618  *         __ERC20Permit_init("MyToken");
619  *     }
620  * }
621  * ```
622  *
623  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
624  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
625  *
626  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
627  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
628  *
629  * [CAUTION]
630  * ====
631  * Avoid leaving a contract uninitialized.
632  *
633  * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
634  * contract, which may impact the proxy. To prevent the implementation contract from being used, you should invoke
635  * the {_disableInitializers} function in the constructor to automatically lock it when it is deployed:
636  *
637  * [.hljs-theme-light.nopadding]
638  * ```
639  * /// @custom:oz-upgrades-unsafe-allow constructor
640  * constructor() {
641  *     _disableInitializers();
642  * }
643  * ```
644  * ====
645  */
646 abstract contract Initializable {
647     /**
648      * @dev Indicates that the contract has been initialized.
649      * @custom:oz-retyped-from bool
650      */
651     uint8 private _initialized;
652 
653     /**
654      * @dev Indicates that the contract is in the process of being initialized.
655      */
656     bool private _initializing;
657 
658     /**
659      * @dev Triggered when the contract has been initialized or reinitialized.
660      */
661     event Initialized(uint8 version);
662 
663     /**
664      * @dev A modifier that defines a protected initializer function that can be invoked at most once. In its scope,
665      * `onlyInitializing` functions can be used to initialize parent contracts. Equivalent to `reinitializer(1)`.
666      */
667     modifier initializer() {
668         bool isTopLevelCall = !_initializing;
669         require(
670             (isTopLevelCall && _initialized < 1) || (!Address.isContract(address(this)) && _initialized == 1),
671             "Initializable: contract is already initialized"
672         );
673         _initialized = 1;
674         if (isTopLevelCall) {
675             _initializing = true;
676         }
677         _;
678         if (isTopLevelCall) {
679             _initializing = false;
680             emit Initialized(1);
681         }
682     }
683 
684     /**
685      * @dev A modifier that defines a protected reinitializer function that can be invoked at most once, and only if the
686      * contract hasn't been initialized to a greater version before. In its scope, `onlyInitializing` functions can be
687      * used to initialize parent contracts.
688      *
689      * `initializer` is equivalent to `reinitializer(1)`, so a reinitializer may be used after the original
690      * initialization step. This is essential to configure modules that are added through upgrades and that require
691      * initialization.
692      *
693      * Note that versions can jump in increments greater than 1; this implies that if multiple reinitializers coexist in
694      * a contract, executing them in the right order is up to the developer or operator.
695      */
696     modifier reinitializer(uint8 version) {
697         require(!_initializing && _initialized < version, "Initializable: contract is already initialized");
698         _initialized = version;
699         _initializing = true;
700         _;
701         _initializing = false;
702         emit Initialized(version);
703     }
704 
705     /**
706      * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
707      * {initializer} and {reinitializer} modifiers, directly or indirectly.
708      */
709     modifier onlyInitializing() {
710         require(_initializing, "Initializable: contract is not initializing");
711         _;
712     }
713 
714     /**
715      * @dev Locks the contract, preventing any future reinitialization. This cannot be part of an initializer call.
716      * Calling this in the constructor of a contract will prevent that contract from being initialized or reinitialized
717      * to any version. It is recommended to use this to lock implementation contracts that are designed to be called
718      * through proxies.
719      */
720     function _disableInitializers() internal virtual {
721         require(!_initializing, "Initializable: contract is initializing");
722         if (_initialized < type(uint8).max) {
723             _initialized = type(uint8).max;
724             emit Initialized(type(uint8).max);
725         }
726     }
727 }
728 
729 // File @openzeppelin/contracts/utils/Context.sol@v4.7.0
730 
731 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
732 
733 pragma solidity ^0.8.0;
734 
735 /**
736  * @dev Provides information about the current execution context, including the
737  * sender of the transaction and its data. While these are generally available
738  * via msg.sender and msg.data, they should not be accessed in such a direct
739  * manner, since when dealing with meta-transactions the account sending and
740  * paying for execution may not be the actual sender (as far as an application
741  * is concerned).
742  *
743  * This contract is only required for intermediate, library-like contracts.
744  */
745 abstract contract Context {
746     function _msgSender() internal view virtual returns (address) {
747         return msg.sender;
748     }
749 
750     function _msgData() internal view virtual returns (bytes calldata) {
751         return msg.data;
752     }
753 }
754 
755 // File contracts/interfaces/IGovernable.sol
756 
757 pragma solidity 0.8.15;
758 
759 /**
760  * @notice Governable interface
761  */
762 interface IGovernable {
763     function governor() external view returns (address _governor);
764 
765     function transferGovernorship(address _proposedGovernor) external;
766 }
767 
768 // File contracts/access/Governable.sol
769 
770 pragma solidity 0.8.15;
771 
772 /**
773  * @dev Contract module which provides a basic access control mechanism, where
774  * there is an account (governor) that can be granted exclusive access to
775  * specific functions.
776  *
777  * By default, the governor account will be the one that deploys the contract. This
778  * can later be changed with {transferGovernorship}.
779  *
780  */
781 abstract contract Governable is IGovernable, Context, Initializable {
782     address public governor;
783     address private proposedGovernor;
784 
785     event UpdatedGovernor(address indexed previousGovernor, address indexed proposedGovernor);
786 
787     /**
788      * @dev Initializes the contract setting the deployer as the initial governor.
789      */
790     constructor() {
791         address msgSender = _msgSender();
792         governor = msgSender;
793         emit UpdatedGovernor(address(0), msgSender);
794     }
795 
796     /**
797      * @dev Initializes the contract setting the deployer as the initial governor.
798      */
799     // solhint-disable-next-line func-name-mixedcase
800     function __Governable_init() internal onlyInitializing {
801         address msgSender = _msgSender();
802         governor = msgSender;
803         emit UpdatedGovernor(address(0), msgSender);
804     }
805 
806     /**
807      * @dev Throws if called by any account other than the governor.
808      */
809     modifier onlyGovernor() {
810         require(governor == _msgSender(), "not governor");
811         _;
812     }
813 
814     /**
815      * @dev Transfers governorship of the contract to a new account (`proposedGovernor`).
816      * Can only be called by the current governor.
817      */
818     function transferGovernorship(address _proposedGovernor) external onlyGovernor {
819         require(_proposedGovernor != address(0), "invalid proposed governor");
820         proposedGovernor = _proposedGovernor;
821     }
822 
823     /**
824      * @dev Allows new governor to accept governorship of the contract.
825      */
826     function acceptGovernorship() external {
827         require(proposedGovernor == _msgSender(), "not the proposed governor");
828         emit UpdatedGovernor(governor, proposedGovernor);
829         governor = proposedGovernor;
830         proposedGovernor = address(0);
831     }
832 
833     /**
834      * @dev This empty reserved space is put in place to allow future versions to add new
835      * variables without shifting down storage in the inheritance chain.
836      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
837      */
838     uint256[49] private __gap;
839 }
840 
841 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.7.0
842 
843 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
844 
845 pragma solidity ^0.8.0;
846 
847 /**
848  * @dev Interface of the ERC165 standard, as defined in the
849  * https://eips.ethereum.org/EIPS/eip-165[EIP].
850  *
851  * Implementers can declare support of contract interfaces, which can then be
852  * queried by others ({ERC165Checker}).
853  *
854  * For an implementation, see {ERC165}.
855  */
856 interface IERC165 {
857     /**
858      * @dev Returns true if this contract implements the interface defined by
859      * `interfaceId`. See the corresponding
860      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
861      * to learn more about how these ids are created.
862      *
863      * This function call must use less than 30 000 gas.
864      */
865     function supportsInterface(bytes4 interfaceId) external view returns (bool);
866 }
867 
868 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.7.0
869 
870 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
871 
872 pragma solidity ^0.8.0;
873 
874 /**
875  * @dev Required interface of an ERC721 compliant contract.
876  */
877 interface IERC721 is IERC165 {
878     /**
879      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
880      */
881     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
882 
883     /**
884      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
885      */
886     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
887 
888     /**
889      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
890      */
891     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
892 
893     /**
894      * @dev Returns the number of tokens in ``owner``'s account.
895      */
896     function balanceOf(address owner) external view returns (uint256 balance);
897 
898     /**
899      * @dev Returns the owner of the `tokenId` token.
900      *
901      * Requirements:
902      *
903      * - `tokenId` must exist.
904      */
905     function ownerOf(uint256 tokenId) external view returns (address owner);
906 
907     /**
908      * @dev Safely transfers `tokenId` token from `from` to `to`.
909      *
910      * Requirements:
911      *
912      * - `from` cannot be the zero address.
913      * - `to` cannot be the zero address.
914      * - `tokenId` token must exist and be owned by `from`.
915      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
916      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
917      *
918      * Emits a {Transfer} event.
919      */
920     function safeTransferFrom(
921         address from,
922         address to,
923         uint256 tokenId,
924         bytes calldata data
925     ) external;
926 
927     /**
928      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
929      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
930      *
931      * Requirements:
932      *
933      * - `from` cannot be the zero address.
934      * - `to` cannot be the zero address.
935      * - `tokenId` token must exist and be owned by `from`.
936      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
937      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
938      *
939      * Emits a {Transfer} event.
940      */
941     function safeTransferFrom(
942         address from,
943         address to,
944         uint256 tokenId
945     ) external;
946 
947     /**
948      * @dev Transfers `tokenId` token from `from` to `to`.
949      *
950      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
951      *
952      * Requirements:
953      *
954      * - `from` cannot be the zero address.
955      * - `to` cannot be the zero address.
956      * - `tokenId` token must be owned by `from`.
957      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
958      *
959      * Emits a {Transfer} event.
960      */
961     function transferFrom(
962         address from,
963         address to,
964         uint256 tokenId
965     ) external;
966 
967     /**
968      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
969      * The approval is cleared when the token is transferred.
970      *
971      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
972      *
973      * Requirements:
974      *
975      * - The caller must own the token or be an approved operator.
976      * - `tokenId` must exist.
977      *
978      * Emits an {Approval} event.
979      */
980     function approve(address to, uint256 tokenId) external;
981 
982     /**
983      * @dev Approve or remove `operator` as an operator for the caller.
984      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
985      *
986      * Requirements:
987      *
988      * - The `operator` cannot be the caller.
989      *
990      * Emits an {ApprovalForAll} event.
991      */
992     function setApprovalForAll(address operator, bool _approved) external;
993 
994     /**
995      * @dev Returns the account approved for `tokenId` token.
996      *
997      * Requirements:
998      *
999      * - `tokenId` must exist.
1000      */
1001     function getApproved(uint256 tokenId) external view returns (address operator);
1002 
1003     /**
1004      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1005      *
1006      * See {setApprovalForAll}
1007      */
1008     function isApprovedForAll(address owner, address operator) external view returns (bool);
1009 }
1010 
1011 // File @openzeppelin/contracts/interfaces/IERC2981.sol@v4.7.0
1012 
1013 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
1014 
1015 pragma solidity ^0.8.0;
1016 
1017 /**
1018  * @dev Interface for the NFT Royalty Standard.
1019  *
1020  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1021  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1022  *
1023  * _Available since v4.5._
1024  */
1025 interface IERC2981 is IERC165 {
1026     /**
1027      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1028      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1029      */
1030     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1031         external
1032         view
1033         returns (address receiver, uint256 royaltyAmount);
1034 }
1035 
1036 // File contracts/interfaces/ICapsule.sol
1037 
1038 pragma solidity 0.8.15;
1039 
1040 interface ICapsule is IERC721, IERC2981 {
1041     function mint(address account, string memory _uri) external;
1042 
1043     function burn(address owner, uint256 tokenId) external;
1044 
1045     // Read functions
1046     function baseURI() external view returns (string memory);
1047 
1048     function counter() external view returns (uint256);
1049 
1050     function exists(uint256 tokenId) external view returns (bool);
1051 
1052     function isCollectionMinter(address _account) external view returns (bool);
1053 
1054     function maxId() external view returns (uint256);
1055 
1056     function royaltyRate() external view returns (uint256);
1057 
1058     function royaltyReceiver() external view returns (address);
1059 
1060     function tokenURIOwner() external view returns (address);
1061 
1062     ////////////////////////////////////////////////////////////////////////////
1063     //     Extra functions compare to original ICapsule interface    ///////////
1064     ////////////////////////////////////////////////////////////////////////////
1065     // Read functions
1066     function owner() external view returns (address);
1067 
1068     function tokenURI(uint256 tokenId) external view returns (string memory);
1069 
1070     // Admin functions
1071     function lockCollectionCount(uint256 _nftCount) external;
1072 
1073     function setBaseURI(string calldata baseURI_) external;
1074 
1075     function setTokenURI(uint256 _tokenId, string memory _newTokenURI) external;
1076 
1077     function transferOwnership(address _newOwner) external;
1078 
1079     function updateTokenURIOwner(address _newTokenURIOwner) external;
1080 
1081     function updateRoyaltyConfig(address _royaltyReceiver, uint256 _royaltyRate) external;
1082 }
1083 
1084 // File contracts/interfaces/ICapsuleFactory.sol
1085 
1086 pragma solidity 0.8.15;
1087 
1088 interface ICapsuleFactory is IGovernable {
1089     function capsuleCollectionTax() external view returns (uint256);
1090 
1091     function capsuleMinter() external view returns (address);
1092 
1093     function createCapsuleCollection(
1094         string memory _name,
1095         string memory _symbol,
1096         address _tokenURIOwner,
1097         bool _isCollectionPrivate
1098     ) external payable returns (address);
1099 
1100     function getAllCapsuleCollections() external view returns (address[] memory);
1101 
1102     function getCapsuleCollectionsOf(address _owner) external view returns (address[] memory);
1103 
1104     function getBlacklist() external view returns (address[] memory);
1105 
1106     function getWhitelist() external view returns (address[] memory);
1107 
1108     function isCapsule(address _capsule) external view returns (bool);
1109 
1110     function isBlacklisted(address _user) external view returns (bool);
1111 
1112     function isWhitelisted(address _user) external view returns (bool);
1113 
1114     function taxCollector() external view returns (address);
1115 
1116     //solhint-disable-next-line func-name-mixedcase
1117     function VERSION() external view returns (string memory);
1118 
1119     // Special permission functions
1120     function addToWhitelist(address _user) external;
1121 
1122     function removeFromWhitelist(address _user) external;
1123 
1124     function addToBlacklist(address _user) external;
1125 
1126     function removeFromBlacklist(address _user) external;
1127 
1128     function flushTaxAmount() external;
1129 
1130     function setCapsuleMinter(address _newCapsuleMinter) external;
1131 
1132     function updateCapsuleCollectionOwner(address _previousOwner, address _newOwner) external;
1133 
1134     function updateCapsuleCollectionTax(uint256 _newTax) external;
1135 
1136     function updateTaxCollector(address _newTaxCollector) external;
1137 }
1138 
1139 // File contracts/interfaces/ICapsuleMinter.sol
1140 
1141 pragma solidity 0.8.15;
1142 
1143 interface ICapsuleMinter is IGovernable {
1144     struct SingleERC20Capsule {
1145         address tokenAddress;
1146         uint256 tokenAmount;
1147     }
1148 
1149     struct MultiERC20Capsule {
1150         address[] tokenAddresses;
1151         uint256[] tokenAmounts;
1152     }
1153 
1154     struct SingleERC721Capsule {
1155         address tokenAddress;
1156         uint256 id;
1157     }
1158 
1159     struct MultiERC721Capsule {
1160         address[] tokenAddresses;
1161         uint256[] ids;
1162     }
1163 
1164     function capsuleMintTax() external view returns (uint256);
1165 
1166     function getMintWhitelist() external view returns (address[] memory);
1167 
1168     function getCapsuleOwner(address _capsule, uint256 _id) external view returns (address);
1169 
1170     function isMintWhitelisted(address _user) external view returns (bool);
1171 
1172     function multiERC20Capsule(address _capsule, uint256 _id) external view returns (MultiERC20Capsule memory _data);
1173 
1174     function multiERC721Capsule(address _capsule, uint256 _id) external view returns (MultiERC721Capsule memory _data);
1175 
1176     function singleERC20Capsule(address _capsule, uint256 _id) external view returns (address _token, uint256 _amount);
1177 
1178     function mintSimpleCapsule(
1179         address _capsule,
1180         string memory _uri,
1181         address _receiver
1182     ) external payable;
1183 
1184     function burnSimpleCapsule(address _capsule, uint256 _id) external;
1185 
1186     function mintSingleERC20Capsule(
1187         address _capsule,
1188         address _token,
1189         uint256 _amount,
1190         string memory _uri,
1191         address _receiver
1192     ) external payable;
1193 
1194     function burnSingleERC20Capsule(address _capsule, uint256 _id) external;
1195 
1196     function mintSingleERC721Capsule(
1197         address _capsule,
1198         address _token,
1199         uint256 _id,
1200         string memory _uri,
1201         address _receiver
1202     ) external payable;
1203 
1204     function burnSingleERC721Capsule(address _capsule, uint256 _id) external;
1205 
1206     function mintMultiERC20Capsule(
1207         address _capsule,
1208         address[] memory _tokens,
1209         uint256[] memory _amounts,
1210         string memory _uri,
1211         address _receiver
1212     ) external payable;
1213 
1214     function burnMultiERC20Capsule(address _capsule, uint256 _id) external;
1215 
1216     function mintMultiERC721Capsule(
1217         address _capsule,
1218         address[] memory _tokens,
1219         uint256[] memory _ids,
1220         string memory _uri,
1221         address _receiver
1222     ) external payable;
1223 
1224     function burnMultiERC721Capsule(address _capsule, uint256 _id) external;
1225 
1226     // Special permission functions
1227     function addToWhitelist(address _user) external;
1228 
1229     function removeFromWhitelist(address _user) external;
1230 
1231     function flushTaxAmount() external;
1232 
1233     function updateCapsuleMintTax(uint256 _newTax) external;
1234 }
1235 
1236 // File contracts/DollarStoreKids.sol
1237 
1238 // SPDX-License-Identifier: GPLv3
1239 
1240 pragma solidity 0.8.15;
1241 
1242 /// @title Dollar Store Kids
1243 contract DollarStoreKids is Governable, IERC721Receiver {
1244     using SafeERC20 for IERC20;
1245 
1246     /// @notice Input token for the Dollar Store Kids
1247     address public constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
1248     ICapsuleFactory public constant CAPSULE_FACTORY = ICapsuleFactory(0x4Ced59c19F1f3a9EeBD670f746B737ACf504d1eB);
1249     ICapsuleMinter public constant CAPSULE_MINTER = ICapsuleMinter(0xb8Cf4A28DA322598FDB78a1406a61B72d6F6b396);
1250     /// @notice Allowed Dollar Store Kids mints per address
1251     uint8 public constant MINT_PER_ADDRESS = 1;
1252     /// @notice Max amount of Dollar Store Kids to release
1253     uint16 public constant MAX_DSK = 3333;
1254 
1255     /// @notice Dollar Store Kids collection
1256     ICapsule public immutable capsuleCollection;
1257     /// @notice Flag indicating whether the Dollar Store Kids mint is enabled.
1258     bool public isMintEnabled;
1259     /// @notice Mapping of addresses who have minted.
1260     mapping(address => bool) public alreadyMinted;
1261 
1262     uint256 private constant ONE_DOLLAR = 1e6; // 1 USDC
1263 
1264     event DollarStoreKidsMinted(address indexed user, uint256 indexed id);
1265     event DollarStoreKidsBurnt(address indexed user, uint256 indexed id);
1266     event MintToggled(bool mintStatus);
1267 
1268     constructor(string memory baseURI_) payable {
1269         capsuleCollection = ICapsule(
1270             CAPSULE_FACTORY.createCapsuleCollection{value: msg.value}("Dollar Store Kids", "D$K", address(this), true)
1271         );
1272         updateBaseURI(baseURI_);
1273         capsuleCollection.lockCollectionCount(MAX_DSK);
1274         // Using approve as USDC is ERC20 compliant token
1275         IERC20(USDC).approve(address(CAPSULE_MINTER), MAX_DSK * ONE_DOLLAR);
1276     }
1277 
1278     /// @notice Mint a DSK to caller address
1279     function mint() external payable {
1280         require(isMintEnabled, "mint-is-not-enabled");
1281         address _caller = _msgSender();
1282         require(!alreadyMinted[_caller], "already-minted-dsk");
1283 
1284         uint256 _counter = capsuleCollection.counter();
1285         require(_counter < MAX_DSK, "max-supply-reached");
1286         // Each address is allowed to mint a max of 1 DSK - update state
1287         alreadyMinted[_caller] = true;
1288 
1289         // DSK collection will be using baseURL and do not need URI for individual NFTs.
1290         // Hence passing empty token URI to mint function below.
1291         CAPSULE_MINTER.mintSingleERC20Capsule{value: msg.value}(
1292             address(capsuleCollection),
1293             USDC,
1294             ONE_DOLLAR,
1295             "",
1296             _caller
1297         );
1298         emit DollarStoreKidsMinted(_caller, _counter);
1299     }
1300 
1301     /**
1302      * @notice Burn a DSK and get 1 USDC back
1303      * @param id_ DSK id to burn
1304      */
1305     function burn(uint256 id_) external {
1306         address _caller = _msgSender();
1307         // Transfer DSK here
1308         capsuleCollection.safeTransferFrom(_caller, address(this), id_);
1309         // Burn DSK
1310         CAPSULE_MINTER.burnSingleERC20Capsule(address(capsuleCollection), id_);
1311         // Transfer user Dollar contents (1 USDC)
1312         IERC20(USDC).safeTransfer(_caller, ONE_DOLLAR);
1313         emit DollarStoreKidsBurnt(_caller, id_);
1314     }
1315 
1316     /// @dev This function enables this contract to receive ERC721 tokens
1317     function onERC721Received(
1318         address,
1319         address,
1320         uint256,
1321         bytes calldata
1322     ) external pure returns (bytes4) {
1323         return IERC721Receiver.onERC721Received.selector;
1324     }
1325 
1326     /******************************************************************************
1327      *                            Governor functions                              *
1328      *****************************************************************************/
1329 
1330     /// @notice onlyGovernor:: Sweep given token to governor address
1331     function sweep(address _token) external onlyGovernor {
1332         uint256 _amount = IERC20(_token).balanceOf(address(this));
1333         IERC20(_token).safeTransfer(governor, _amount);
1334     }
1335 
1336     /// @notice onlyGovernor:: Toggle minting status of the Dollar Store Kids
1337     function toggleMint() external onlyGovernor {
1338         isMintEnabled = !isMintEnabled;
1339         emit MintToggled(isMintEnabled);
1340     }
1341 
1342     /**
1343      * @notice onlyGovernor:: Transfer ownership of the Dollar Store Kids Capsule collection
1344      * @param newOwner_ Address of new owner
1345      */
1346     function transferCollectionOwnership(address newOwner_) external onlyGovernor {
1347         capsuleCollection.transferOwnership(newOwner_);
1348     }
1349 
1350     /**
1351      * @notice onlyGovernor:: Transfer metamaster of the Dollar Store Kids Capsule collection
1352      * @param metamaster_ Address of new metamaster
1353      */
1354     function updateMetamaster(address metamaster_) external onlyGovernor {
1355         capsuleCollection.updateTokenURIOwner(metamaster_);
1356     }
1357 
1358     /**
1359      * @notice onlyGovernor:: Set the collection baseURI
1360      * @param baseURI_ New baseURI string
1361      */
1362     function updateBaseURI(string memory baseURI_) public onlyGovernor {
1363         capsuleCollection.setBaseURI(baseURI_);
1364     }
1365 
1366     /**
1367      * @notice onlyGovernor:: Update royalty receiver and rate in Dollar Store Kids collection
1368      * @param royaltyReceiver_ Address of royalty receiver
1369      * @param royaltyRate_ Royalty rate in Basis Points. ie. 100 = 1%, 10_000 = 100%
1370      */
1371     function updateRoyaltyConfig(address royaltyReceiver_, uint256 royaltyRate_) external onlyGovernor {
1372         capsuleCollection.updateRoyaltyConfig(royaltyReceiver_, royaltyRate_);
1373     }
1374 }