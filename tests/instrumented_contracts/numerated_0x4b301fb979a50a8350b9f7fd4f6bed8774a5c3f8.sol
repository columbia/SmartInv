1 // File: finixio-deployments/contracts/upgrades/StringsUpgradeable.sol
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library StringsUpgradeable {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: finixio-deployments/contracts/upgrades/ECDSAUpgradeable.sol
72 
73 
74 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
80  *
81  * These functions can be used to verify that a message was signed by the holder
82  * of the private keys of a given address.
83  */
84 library ECDSAUpgradeable {
85     enum RecoverError {
86         NoError,
87         InvalidSignature,
88         InvalidSignatureLength,
89         InvalidSignatureS,
90         InvalidSignatureV
91     }
92 
93     function _throwError(RecoverError error) private pure {
94         if (error == RecoverError.NoError) {
95             return; // no error: do nothing
96         } else if (error == RecoverError.InvalidSignature) {
97             revert("ECDSA: invalid signature");
98         } else if (error == RecoverError.InvalidSignatureLength) {
99             revert("ECDSA: invalid signature length");
100         } else if (error == RecoverError.InvalidSignatureS) {
101             revert("ECDSA: invalid signature 's' value");
102         } else if (error == RecoverError.InvalidSignatureV) {
103             revert("ECDSA: invalid signature 'v' value");
104         }
105     }
106 
107     /**
108      * @dev Returns the address that signed a hashed message (`hash`) with
109      * `signature` or error string. This address can then be used for verification purposes.
110      *
111      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
112      * this function rejects them by requiring the `s` value to be in the lower
113      * half order, and the `v` value to be either 27 or 28.
114      *
115      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
116      * verification to be secure: it is possible to craft signatures that
117      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
118      * this is by receiving a hash of the original message (which may otherwise
119      * be too long), and then calling {toEthSignedMessageHash} on it.
120      *
121      * Documentation for signature generation:
122      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
123      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
124      *
125      * _Available since v4.3._
126      */
127     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
128         // Check the signature length
129         // - case 65: r,s,v signature (standard)
130         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
131         if (signature.length == 65) {
132             bytes32 r;
133             bytes32 s;
134             uint8 v;
135             // ecrecover takes the signature parameters, and the only way to get them
136             // currently is to use assembly.
137             assembly {
138                 r := mload(add(signature, 0x20))
139                 s := mload(add(signature, 0x40))
140                 v := byte(0, mload(add(signature, 0x60)))
141             }
142             return tryRecover(hash, v, r, s);
143         } else if (signature.length == 64) {
144             bytes32 r;
145             bytes32 vs;
146             // ecrecover takes the signature parameters, and the only way to get them
147             // currently is to use assembly.
148             assembly {
149                 r := mload(add(signature, 0x20))
150                 vs := mload(add(signature, 0x40))
151             }
152             return tryRecover(hash, r, vs);
153         } else {
154             return (address(0), RecoverError.InvalidSignatureLength);
155         }
156     }
157 
158     /**
159      * @dev Returns the address that signed a hashed message (`hash`) with
160      * `signature`. This address can then be used for verification purposes.
161      *
162      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
163      * this function rejects them by requiring the `s` value to be in the lower
164      * half order, and the `v` value to be either 27 or 28.
165      *
166      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
167      * verification to be secure: it is possible to craft signatures that
168      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
169      * this is by receiving a hash of the original message (which may otherwise
170      * be too long), and then calling {toEthSignedMessageHash} on it.
171      */
172     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
173         (address recovered, RecoverError error) = tryRecover(hash, signature);
174         _throwError(error);
175         return recovered;
176     }
177 
178     /**
179      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
180      *
181      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
182      *
183      * _Available since v4.3._
184      */
185     function tryRecover(
186         bytes32 hash,
187         bytes32 r,
188         bytes32 vs
189     ) internal pure returns (address, RecoverError) {
190         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
191         uint8 v = uint8((uint256(vs) >> 255) + 27);
192         return tryRecover(hash, v, r, s);
193     }
194 
195     /**
196      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
197      *
198      * _Available since v4.2._
199      */
200     function recover(
201         bytes32 hash,
202         bytes32 r,
203         bytes32 vs
204     ) internal pure returns (address) {
205         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
206         _throwError(error);
207         return recovered;
208     }
209 
210     /**
211      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
212      * `r` and `s` signature fields separately.
213      *
214      * _Available since v4.3._
215      */
216     function tryRecover(
217         bytes32 hash,
218         uint8 v,
219         bytes32 r,
220         bytes32 s
221     ) internal pure returns (address, RecoverError) {
222         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
223         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
224         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
225         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
226         //
227         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
228         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
229         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
230         // these malleable signatures as well.
231         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
232             return (address(0), RecoverError.InvalidSignatureS);
233         }
234         if (v != 27 && v != 28) {
235             return (address(0), RecoverError.InvalidSignatureV);
236         }
237 
238         // If the signature is valid (and not malleable), return the signer address
239         address signer = ecrecover(hash, v, r, s);
240         if (signer == address(0)) {
241             return (address(0), RecoverError.InvalidSignature);
242         }
243 
244         return (signer, RecoverError.NoError);
245     }
246 
247     /**
248      * @dev Overload of {ECDSA-recover} that receives the `v`,
249      * `r` and `s` signature fields separately.
250      */
251     function recover(
252         bytes32 hash,
253         uint8 v,
254         bytes32 r,
255         bytes32 s
256     ) internal pure returns (address) {
257         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
258         _throwError(error);
259         return recovered;
260     }
261 
262     /**
263      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
264      * produces hash corresponding to the one signed with the
265      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
266      * JSON-RPC method as part of EIP-191.
267      *
268      * See {recover}.
269      */
270     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
271         // 32 is the length in bytes of hash,
272         // enforced by the type signature above
273         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
274     }
275 
276     /**
277      * @dev Returns an Ethereum Signed Message, created from `s`. This
278      * produces hash corresponding to the one signed with the
279      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
280      * JSON-RPC method as part of EIP-191.
281      *
282      * See {recover}.
283      */
284     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
285         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", StringsUpgradeable.toString(s.length), s));
286     }
287 
288     /**
289      * @dev Returns an Ethereum Signed Typed Data, created from a
290      * `domainSeparator` and a `structHash`. This produces hash corresponding
291      * to the one signed with the
292      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
293      * JSON-RPC method as part of EIP-712.
294      *
295      * See {recover}.
296      */
297     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
298         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
299     }
300 }
301 
302 // File: finixio-deployments/contracts/upgrades/AddressUpgradeable.sol
303 
304 
305 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
306 
307 pragma solidity ^0.8.1;
308 
309 /**
310  * @dev Collection of functions related to the address type
311  */
312 library AddressUpgradeable {
313     /**
314      * @dev Returns true if `account` is a contract.
315      *
316      * [IMPORTANT]
317      * ====
318      * It is unsafe to assume that an address for which this function returns
319      * false is an externally-owned account (EOA) and not a contract.
320      *
321      * Among others, `isContract` will return false for the following
322      * types of addresses:
323      *
324      *  - an externally-owned account
325      *  - a contract in construction
326      *  - an address where a contract will be created
327      *  - an address where a contract lived, but was destroyed
328      * ====
329      *
330      * [IMPORTANT]
331      * ====
332      * You shouldn't rely on `isContract` to protect against flash loan attacks!
333      *
334      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
335      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
336      * constructor.
337      * ====
338      */
339     function isContract(address account) internal view returns (bool) {
340         // This method relies on extcodesize/address.code.length, which returns 0
341         // for contracts in construction, since the code is only stored at the end
342         // of the constructor execution.
343 
344         return account.code.length > 0;
345     }
346 
347     /**
348      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
349      * `recipient`, forwarding all available gas and reverting on errors.
350      *
351      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
352      * of certain opcodes, possibly making contracts go over the 2300 gas limit
353      * imposed by `transfer`, making them unable to receive funds via
354      * `transfer`. {sendValue} removes this limitation.
355      *
356      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
357      *
358      * IMPORTANT: because control is transferred to `recipient`, care must be
359      * taken to not create reentrancy vulnerabilities. Consider using
360      * {ReentrancyGuard} or the
361      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
362      */
363     function sendValue(address payable recipient, uint256 amount) internal {
364         require(address(this).balance >= amount, "Address: insufficient balance");
365 
366         (bool success, ) = recipient.call{value: amount}("");
367         require(success, "Address: unable to send value, recipient may have reverted");
368     }
369 
370     /**
371      * @dev Performs a Solidity function call using a low level `call`. A
372      * plain `call` is an unsafe replacement for a function call: use this
373      * function instead.
374      *
375      * If `target` reverts with a revert reason, it is bubbled up by this
376      * function (like regular Solidity function calls).
377      *
378      * Returns the raw returned data. To convert to the expected return value,
379      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
380      *
381      * Requirements:
382      *
383      * - `target` must be a contract.
384      * - calling `target` with `data` must not revert.
385      *
386      * _Available since v3.1._
387      */
388     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
389         return functionCall(target, data, "Address: low-level call failed");
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
394      * `errorMessage` as a fallback revert reason when `target` reverts.
395      *
396      * _Available since v3.1._
397      */
398     function functionCall(
399         address target,
400         bytes memory data,
401         string memory errorMessage
402     ) internal returns (bytes memory) {
403         return functionCallWithValue(target, data, 0, errorMessage);
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
408      * but also transferring `value` wei to `target`.
409      *
410      * Requirements:
411      *
412      * - the calling contract must have an ETH balance of at least `value`.
413      * - the called Solidity function must be `payable`.
414      *
415      * _Available since v3.1._
416      */
417     function functionCallWithValue(
418         address target,
419         bytes memory data,
420         uint256 value
421     ) internal returns (bytes memory) {
422         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
427      * with `errorMessage` as a fallback revert reason when `target` reverts.
428      *
429      * _Available since v3.1._
430      */
431     function functionCallWithValue(
432         address target,
433         bytes memory data,
434         uint256 value,
435         string memory errorMessage
436     ) internal returns (bytes memory) {
437         require(address(this).balance >= value, "Address: insufficient balance for call");
438         require(isContract(target), "Address: call to non-contract");
439 
440         (bool success, bytes memory returndata) = target.call{value: value}(data);
441         return verifyCallResult(success, returndata, errorMessage);
442     }
443 
444     /**
445      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
446      * but performing a static call.
447      *
448      * _Available since v3.3._
449      */
450     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
451         return functionStaticCall(target, data, "Address: low-level static call failed");
452     }
453 
454     /**
455      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
456      * but performing a static call.
457      *
458      * _Available since v3.3._
459      */
460     function functionStaticCall(
461         address target,
462         bytes memory data,
463         string memory errorMessage
464     ) internal view returns (bytes memory) {
465         require(isContract(target), "Address: static call to non-contract");
466 
467         (bool success, bytes memory returndata) = target.staticcall(data);
468         return verifyCallResult(success, returndata, errorMessage);
469     }
470 
471     /**
472      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
473      * revert reason using the provided one.
474      *
475      * _Available since v4.3._
476      */
477     function verifyCallResult(
478         bool success,
479         bytes memory returndata,
480         string memory errorMessage
481     ) internal pure returns (bytes memory) {
482         if (success) {
483             return returndata;
484         } else {
485             // Look for revert reason and bubble it up if present
486             if (returndata.length > 0) {
487                 // The easiest way to bubble the revert reason is using memory via assembly
488 
489                 assembly {
490                     let returndata_size := mload(returndata)
491                     revert(add(32, returndata), returndata_size)
492                 }
493             } else {
494                 revert(errorMessage);
495             }
496         }
497     }
498 }
499 
500 // File: finixio-deployments/contracts/upgrades/Initializable.sol
501 
502 
503 pragma solidity ^0.8.2;
504 
505 /**
506  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
507  * behind a proxy. Since proxied contracts do not make use of a constructor, it's common to move constructor logic to an
508  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
509  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
510  *
511  * The initialization functions use a version number. Once a version number is used, it is consumed and cannot be
512  * reused. This mechanism prevents re-execution of each "step" but allows the creation of new initialization steps in
513  * case an upgrade adds a module that needs to be initialized.
514  *
515  * For example:
516  *
517  * [.hljs-theme-light.nopadding]
518  * ```
519  * contract MyToken is ERC20Upgradeable {
520  *     function initialize() initializer public {
521  *         __ERC20_init("MyToken", "MTK");
522  *     }
523  * }
524  * contract MyTokenV2 is MyToken, ERC20PermitUpgradeable {
525  *     function initializeV2() reinitializer(2) public {
526  *         __ERC20Permit_init("MyToken");
527  *     }
528  * }
529  * ```
530  *
531  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
532  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
533  *
534  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
535  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
536  *
537  * [CAUTION]
538  * ====
539  * Avoid leaving a contract uninitialized.
540  *
541  * An uninitialized contract can be taken over by an attacker. This applies to both a proxy and its implementation
542  * contract, which may impact the proxy. To prevent the implementation contract from being used, you should invoke
543  * the {_disableInitializers} function in the constructor to automatically lock it when it is deployed:
544  *
545  * [.hljs-theme-light.nopadding]
546  * ```
547  * /// @custom:oz-upgrades-unsafe-allow constructor
548  * constructor() {
549  *     _disableInitializers();
550  * }
551  * ```
552  * ====
553  */
554 abstract contract Initializable {
555     /**
556      * @dev Indicates that the contract has been initialized.
557      * @custom:oz-retyped-from bool
558      */
559     uint8 private _initialized;
560 
561     /**
562      * @dev Indicates that the contract is in the process of being initialized.
563      */
564     bool private _initializing;
565 
566     /**
567      * @dev Triggered when the contract has been initialized or reinitialized.
568      */
569     event Initialized(uint8 version);
570 
571     /**
572      * @dev A modifier that defines a protected initializer function that can be invoked at most once. In its scope,
573      * `onlyInitializing` functions can be used to initialize parent contracts. Equivalent to `reinitializer(1)`.
574      */
575     modifier initializer() {
576         bool isTopLevelCall = _setInitializedVersion(1);
577         if (isTopLevelCall) {
578             _initializing = true;
579         }
580         _;
581         if (isTopLevelCall) {
582             _initializing = false;
583             emit Initialized(1);
584         }
585     }
586 
587     /**
588      * @dev A modifier that defines a protected reinitializer function that can be invoked at most once, and only if the
589      * contract hasn't been initialized to a greater version before. In its scope, `onlyInitializing` functions can be
590      * used to initialize parent contracts.
591      *
592      * `initializer` is equivalent to `reinitializer(1)`, so a reinitializer may be used after the original
593      * initialization step. This is essential to configure modules that are added through upgrades and that require
594      * initialization.
595      *
596      * Note that versions can jump in increments greater than 1; this implies that if multiple reinitializers coexist in
597      * a contract, executing them in the right order is up to the developer or operator.
598      */
599     modifier reinitializer(uint8 version) {
600         bool isTopLevelCall = _setInitializedVersion(version);
601         if (isTopLevelCall) {
602             _initializing = true;
603         }
604         _;
605         if (isTopLevelCall) {
606             _initializing = false;
607             emit Initialized(version);
608         }
609     }
610 
611     /**
612      * @dev Modifier to protect an initialization function so that it can only be invoked by functions with the
613      * {initializer} and {reinitializer} modifiers, directly or indirectly.
614      */
615     modifier onlyInitializing() {
616         require(_initializing, "Initializable: contract is not initializing");
617         _;
618     }
619 
620     /**
621      * @dev Locks the contract, preventing any future reinitialization. This cannot be part of an initializer call.
622      * Calling this in the constructor of a contract will prevent that contract from being initialized or reinitialized
623      * to any version. It is recommended to use this to lock implementation contracts that are designed to be called
624      * through proxies.
625      */
626     function _disableInitializers() internal virtual {
627         _setInitializedVersion(type(uint8).max);
628     }
629 
630     function _setInitializedVersion(uint8 version) private returns (bool) {
631         // If the contract is initializing we ignore whether _initialized is set in order to support multiple
632         // inheritance patterns, but we only do this in the context of a constructor, and for the lowest level
633         // of initializers, because in other contexts the contract may have been reentered.
634         if (_initializing) {
635             require(
636                 version == 1 && !AddressUpgradeable.isContract(address(this)),
637                 "Initializable: contract is already initialized"
638             );
639             return false;
640         } else {
641             require(_initialized < version, "Initializable: contract is already initialized");
642             _initialized = version;
643             return true;
644         }
645     }
646 }
647 
648 // File: finixio-deployments/contracts/upgrades/ContextUpgradeable.sol
649 
650 
651 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
652 
653 pragma solidity ^0.8.0;
654 
655 /**
656  * @dev Provides information about the current execution context, including the
657  * sender of the transaction and its data. While these are generally available
658  * via msg.sender and msg.data, they should not be accessed in such a direct
659  * manner, since when dealing with meta-transactions the account sending and
660  * paying for execution may not be the actual sender (as far as an application
661  * is concerned).
662  *
663  * This contract is only required for intermediate, library-like contracts.
664  */
665 abstract contract ContextUpgradeable is Initializable {
666     function __Context_init() internal onlyInitializing {
667     }
668 
669     function __Context_init_unchained() internal onlyInitializing {
670     }
671     function _msgSender() internal view virtual returns (address) {
672         return msg.sender;
673     }
674 
675     function _msgData() internal view virtual returns (bytes calldata) {
676         return msg.data;
677     }
678 
679     /**
680      * @dev This empty reserved space is put in place to allow future versions to add new
681      * variables without shifting down storage in the inheritance chain.
682      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
683      */
684     uint256[50] private __gap;
685 }
686 
687 // File: finixio-deployments/contracts/upgrades/PausableUpgradeable.sol
688 
689 
690 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
691 
692 pragma solidity ^0.8.0;
693 
694 
695 /**
696  * @dev Contract module which allows children to implement an emergency stop
697  * mechanism that can be triggered by an authorized account.
698  *
699  * This module is used through inheritance. It will make available the
700  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
701  * the functions of your contract. Note that they will not be pausable by
702  * simply including this module, only once the modifiers are put in place.
703  */
704 abstract contract PausableUpgradeable is Initializable, ContextUpgradeable {
705     /**
706      * @dev Emitted when the pause is triggered by `account`.
707      */
708     event Paused(address account);
709 
710     /**
711      * @dev Emitted when the pause is lifted by `account`.
712      */
713     event Unpaused(address account);
714 
715     bool private _paused;
716 
717     /**
718      * @dev Initializes the contract in unpaused state.
719      */
720     function __Pausable_init() internal onlyInitializing {
721         __Pausable_init_unchained();
722     }
723 
724     function __Pausable_init_unchained() internal onlyInitializing {
725         _paused = false;
726     }
727 
728     /**
729      * @dev Returns true if the contract is paused, and false otherwise.
730      */
731     function paused() public view virtual returns (bool) {
732         return _paused;
733     }
734 
735     /**
736      * @dev Modifier to make a function callable only when the contract is not paused.
737      *
738      * Requirements:
739      *
740      * - The contract must not be paused.
741      */
742     modifier whenNotPaused() {
743         require(!paused(), "Pausable: paused");
744         _;
745     }
746 
747     /**
748      * @dev Modifier to make a function callable only when the contract is paused.
749      *
750      * Requirements:
751      *
752      * - The contract must be paused.
753      */
754     modifier whenPaused() {
755         require(paused(), "Pausable: not paused");
756         _;
757     }
758 
759     /**
760      * @dev Triggers stopped state.
761      *
762      * Requirements:
763      *
764      * - The contract must not be paused.
765      */
766     function _pause() internal virtual whenNotPaused {
767         _paused = true;
768         emit Paused(_msgSender());
769     }
770 
771     /**
772      * @dev Returns to normal state.
773      *
774      * Requirements:
775      *
776      * - The contract must be paused.
777      */
778     function _unpause() internal virtual whenPaused {
779         _paused = false;
780         emit Unpaused(_msgSender());
781     }
782 
783     /**
784      * @dev This empty reserved space is put in place to allow future versions to add new
785      * variables without shifting down storage in the inheritance chain.
786      * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
787      */
788     uint256[49] private __gap;
789 }
790 
791 // File: finixio-deployments/contracts/interfaces/erc20/IERC20Upgradeable.sol
792 
793 
794 
795 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
796 
797 pragma solidity ^0.8.9;
798 
799 /**
800  * @dev Interface of the ERC20 standard as defined in the EIP.
801  */
802 interface IERC20Upgradeable {
803     /**
804      * @dev Returns the amount of tokens in existence.
805      */
806     function totalSupply() external view returns (uint256);
807 
808     /**
809      * @dev Returns the amount of tokens owned by `account`.
810      */
811     function balanceOf(address account) external view returns (uint256);
812 
813     /**
814      * @dev Moves `amount` tokens from the caller's account to `to`.
815      *
816      * Returns a boolean value indicating whether the operation succeeded.
817      *
818      * Emits a {Transfer} event.
819      */
820     function transfer(address to, uint256 amount) external returns (bool);
821 
822     /**
823      * @dev Returns the remaining number of tokens that `spender` will be
824      * allowed to spend on behalf of `owner` through {transferFrom}. This is
825      * zero by default.
826      *
827      * This value changes when {approve} or {transferFrom} are called.
828      */
829     function allowance(address owner, address spender)
830         external
831         view
832         returns (uint256);
833 
834     /**
835      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
836      *
837      * Returns a boolean value indicating whether the operation succeeded.
838      *
839      * IMPORTANT: Beware that changing an allowance with this method brings the risk
840      * that someone may use both the old and the new allowance by unfortunate
841      * transaction ordering. One possible solution to mitigate this race
842      * condition is to first reduce the spender's allowance to 0 and set the
843      * desired value afterwards:
844      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
845      *
846      * Emits an {Approval} event.
847      */
848     function approve(address spender, uint256 amount) external returns (bool);
849 
850     /**
851      * @dev Moves `amount` tokens from `from` to `to` using the
852      * allowance mechanism. `amount` is then deducted from the caller's
853      * allowance.
854      *
855      * Returns a boolean value indicating whether the operation succeeded.
856      *
857      * Emits a {Transfer} event.
858      */
859     function transferFrom(
860         address from,
861         address to,
862         uint256 amount
863     ) external returns (bool);
864 
865     function mint(address user, uint256 amount) external returns (bool);
866 
867     function burn(address user, uint256 amount) external returns (bool);
868 
869     /**
870      * @dev Emitted when `value` tokens are moved from one account (`from`) to
871      * another (`to`).
872      *
873      * Note that `value` may be zero.
874      */
875     event Transfer(address indexed from, address indexed to, uint256 value);
876 
877     /**
878      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
879      * a call to {approve}. `value` is the new allowance.
880      */
881     event Approval(
882         address indexed owner,
883         address indexed spender,
884         uint256 value
885     );
886 }
887 
888 // File: finixio-deployments/contracts/upgrades/SafeERC20Upgradeable.sol
889 
890 
891 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
892 
893 pragma solidity ^0.8.0;
894 
895 
896 /**
897  * @title SafeERC20
898  * @dev Wrappers around ERC20 operations that throw on failure (when the token
899  * contract returns false). Tokens that return no value (and instead revert or
900  * throw on failure) are also supported, non-reverting calls are assumed to be
901  * successful.
902  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
903  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
904  */
905 library SafeERC20Upgradeable {
906     using AddressUpgradeable for address;
907 
908     function safeTransfer(
909         IERC20Upgradeable token,
910         address to,
911         uint256 value
912     ) internal {
913         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
914     }
915 
916     function safeTransferFrom(
917         IERC20Upgradeable token,
918         address from,
919         address to,
920         uint256 value
921     ) internal {
922         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
923     }
924 
925     /**
926      * @dev Deprecated. This function has issues similar to the ones found in
927      * {IERC20-approve}, and its usage is discouraged.
928      *
929      * Whenever possible, use {safeIncreaseAllowance} and
930      * {safeDecreaseAllowance} instead.
931      */
932     function safeApprove(
933         IERC20Upgradeable token,
934         address spender,
935         uint256 value
936     ) internal {
937         // safeApprove should only be called when setting an initial allowance,
938         // or when resetting it to zero. To increase and decrease it, use
939         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
940         require(
941             (value == 0) || (token.allowance(address(this), spender) == 0),
942             "SafeERC20: approve from non-zero to non-zero allowance"
943         );
944         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
945     }
946 
947     function safeIncreaseAllowance(
948         IERC20Upgradeable token,
949         address spender,
950         uint256 value
951     ) internal {
952         uint256 newAllowance = token.allowance(address(this), spender) + value;
953         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
954     }
955 
956     function safeDecreaseAllowance(
957         IERC20Upgradeable token,
958         address spender,
959         uint256 value
960     ) internal {
961         unchecked {
962             uint256 oldAllowance = token.allowance(address(this), spender);
963             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
964             uint256 newAllowance = oldAllowance - value;
965             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
966         }
967     }
968 
969     /**
970      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
971      * on the return value: the return value is optional (but if data is returned, it must not be false).
972      * @param token The token targeted by the call.
973      * @param data The call data (encoded using abi.encode or one of its variants).
974      */
975     function _callOptionalReturn(IERC20Upgradeable token, bytes memory data) private {
976         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
977         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
978         // the target address contains contract code and also asserts for success in the low-level call.
979 
980         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
981         if (returndata.length > 0) {
982             // Return data is optional
983             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
984         }
985     }
986 }
987 
988 // File: finixio-deployments/contracts/interfaces/bridge/IBridge.sol
989 
990 
991 
992 pragma solidity 0.8.9;
993 
994 /// @title IBridge Interface
995 /// @author hoowsit
996 /// @notice This interface contains all enums/functions/events required by the BridgeContract
997 /// @dev Work in Progress
998 interface IBridge {
999     /*==========================================================Enums definition start==========================================================*/
1000     /*==========================================================Modifier definition start==========================================================*/
1001     /*==========================================================Events definition start==========================================================*/
1002 
1003     /// @notice Event emmited when a user locks their tokens
1004     /// @dev Assumptions were made regarding what each param is for
1005     /// @param user The address of the user
1006     /// @param amount The amount of tokens locked
1007     /// @param timestamp The time the event was emmited
1008     /// @param user The id associated with the user locked tokens
1009     event Lock(
1010         address indexed user,
1011         uint256 amount,
1012         uint256 timestamp,
1013         bytes32 indexed Id
1014     );
1015     /// @notice Event emmited when a user unlocks their tokens
1016     /// @dev Assumptions were made regarding what each param is for
1017     /// @param user The address of the user
1018     /// @param amount The amount of tokens locked
1019     /// @param timestamp The time the event was emmited
1020     /// @param user The id associated with the user unlocked tokens
1021     event Unlock(
1022         address indexed user,
1023         uint256 amount,
1024         uint256 timestamp,
1025         bytes32 indexed Id
1026     );
1027     /// @notice Event emmited when a new admin as appointed
1028     /// @dev Assumptions were made regarding what each param is for
1029     /// @param previousOwner The address of the old owner
1030     /// @param newOwner The new owners address
1031     /// @param timestamp The time the event was emmited
1032     event OwnerChanged(
1033         address indexed previousOwner,
1034         address indexed newOwner,
1035         uint256 indexed timestamp
1036     );
1037     /// @notice Event emmited when a new signer is added
1038     /// @dev Assumptions were made regarding what each param is for
1039     /// @param signer The address of the new signer
1040     /// @param timestamp The time the event was emmited
1041     event SignerAdded(address indexed signer, uint256 indexed timestamp);
1042     /// @notice Event emmited when a signers status changes
1043     /// @dev Assumptions were made regarding what each param is for
1044     /// @param signer The address of the new signer
1045     /// @param value The new status of the signer
1046     /// @param timestamp The time the event was emmited
1047     event SignerStatusChanged(
1048         address indexed signer,
1049         bool indexed value,
1050         uint256 indexed timestamp
1051     );
1052     /// @notice Event emmited when the minimum number of signers required changes
1053     /// @dev Assumptions were made regarding what each param is for
1054     /// @param oldValue The old number of required signers
1055     /// @param newValue The new number of required signers
1056     /// @param timestamp The time the event was emmited
1057     event MinimumSignsChanged(
1058         uint256 indexed oldValue,
1059         uint256 indexed newValue,
1060         uint256 indexed timestamp
1061     );
1062     /// @notice Event emmited when the tax status changes
1063     /// @dev Assumptions were made regarding what each param is for
1064     /// @param value The new tax status
1065     /// @param timestamp The time the event was emmited
1066     event TaxStatusChanged(bool indexed value, uint256 indexed timestamp);
1067     /// @notice Event emmited when the tax percentage changes
1068     /// @dev Assumptions were made regarding what each param is for
1069     /// @param value The new tax amount
1070     /// @param timestamp The time the event was emmited
1071     event TaxPercentChanged(uint256 indexed value, uint256 indexed timestamp);
1072     /// @notice Event emmited when a new admin is added
1073     /// @dev Assumptions were made regarding what each param is for
1074     /// @param prevValue The old admin
1075     /// @param timestamp The new admin
1076     event AdminChanged(
1077         address indexed prevValue,
1078         address indexed newValue,
1079         uint256 indexed timestamp
1080     );
1081     /// @notice Event emmited when the minimum number tokens required to be bridged i updated
1082     /// @param amount The old admin
1083     event MinimumTokensChanged(uint256 indexed amount);
1084 
1085     /*==========================================================Functions definition start==========================================================*/
1086     /// @notice Function is called before any of the other functions are called prefferably after the contract is deployed
1087     /// @dev I definetly think this function needs to be reworked
1088     /// @param _token The token address to be used to lock user funds
1089     function initialize(
1090         address _token,
1091         address _owner,
1092         address[] memory _signers,
1093         uint256 _minSignRequired,
1094         address _admin,
1095         bool _taxEnabled,
1096         uint256 _taxPercent,
1097         uint256 _minTokens
1098     ) external;
1099 
1100     function changeOwner(address newOwner) external;
1101 
1102     function changeSignerStatus(address _signer, bool status) external;
1103 
1104     function addSigner(address _signer) external;
1105 
1106     function changeMinSignsRequired(uint256 _minSignRequired) external;
1107 
1108     function changeUserTaxStatus(address user, bool value) external;
1109 
1110     function changeTaxStatus(bool value) external;
1111 
1112     function changeTaxPercent(uint256 value) external;
1113 
1114     function lock(uint256 amount) external returns (bool);
1115 
1116     function unlock(
1117         address user,
1118         uint256 amount,
1119         bytes32 _id,
1120         bytes[] memory signatures
1121     ) external returns (bool);
1122 
1123     function claimTokens() external returns (bool);
1124 
1125     function signaturesValid(bytes[] memory signatures, bytes32 _id)
1126         external
1127         view
1128         returns (bool);
1129 
1130     function changeAdmin(address newAdmin) external;
1131    /// @notice Function only called by admin when the min amount to tokens to be bridged needs to be changed
1132    /// @param amount The number of tokens
1133     function changeMinimumTokenToBridge(uint256 amount) external;
1134 }
1135 
1136 // File: finixio-deployments/contracts/BridgeEth.sol
1137 
1138 
1139 
1140 pragma solidity 0.8.9;
1141 
1142 
1143 
1144 
1145 
1146 
1147 
1148 
1149 
1150 // File: contracts\Bridge.sol
1151 
1152 contract BridgeEth is Initializable, PausableUpgradeable, IBridge {
1153     using SafeERC20Upgradeable for IERC20Upgradeable;
1154 
1155     address public admin;
1156     address public owner;
1157     address[] public signers;
1158 
1159     IERC20Upgradeable public ERC20Interface;
1160     bool public taxEnabled;
1161     uint256 public minSignsRequired;
1162     uint256 public feeDenom;
1163     uint256 public totalLocked;
1164     uint256 public taxPercent;
1165     uint256 public minimumTokens;
1166     mapping(address => bool) public signerKey;
1167     mapping(address => uint256) public position;
1168     mapping(address => uint256) public userNonce;
1169     mapping(address => uint256) public userClaimable;
1170     mapping(address => bool) public isTaxless;
1171 
1172     /**
1173      * @dev External function to initialize the contract.
1174      */
1175     function initialize(
1176         address _token,
1177         address _owner,
1178         address[] memory _signers,
1179         uint256 _minSignRequired,
1180         address _admin,
1181         bool _taxEnabled,
1182         uint256 _taxPercent,
1183         uint256 minTokens
1184     ) external override initializer {
1185         require(_token != address(0), "Zero token address");
1186         require(_admin != address(0), "Zero admin address");
1187         require(_owner != address(0), "Zero owner address");
1188         require(_signers.length >= 1, "Zero signers");
1189         require(minTokens > 0, "Min tokens must be greater than 0");
1190         require(
1191             _minSignRequired > 0 && _minSignRequired <= _signers.length,
1192             "Invalid min signs required"
1193         );
1194         __Pausable_init_unchained();
1195         ERC20Interface = IERC20Upgradeable(_token);
1196         owner = _owner;
1197         admin = _admin;
1198         for (uint256 i; i < _signers.length; i++) {
1199             addSigner(_signers[i]);
1200         }
1201         minSignsRequired = _minSignRequired;
1202         feeDenom = 10000;
1203         taxEnabled = _taxEnabled;
1204         taxPercent = _taxPercent;
1205         minimumTokens = minTokens;
1206     }
1207 
1208     modifier onlyAdmin() {
1209         require(msg.sender == admin, "Not the admin");
1210         _;
1211     }
1212 
1213     /**
1214      * @dev External function to change the admin of the contract by admin.
1215      */
1216     function changeAdmin(address newAdmin) external override onlyAdmin {
1217         require(newAdmin != address(0), "Zero address");
1218         address prevAdmin = admin;
1219         admin = newAdmin;
1220         emit AdminChanged(prevAdmin, newAdmin, block.timestamp);
1221     }
1222 
1223     /**
1224      * @dev External function to change the owner of the contract by admin.
1225      */
1226     function changeOwner(address newOwner) external override onlyAdmin {
1227         require(newOwner != address(0), "Zero address");
1228         address prevOwner = owner;
1229         owner = newOwner;
1230         emit OwnerChanged(prevOwner, owner, block.timestamp);
1231     }
1232 
1233     /**
1234      * @dev External function to change the signing status of a particular signer by admin.
1235      */
1236     function changeSignerStatus(address _signer, bool status)
1237         external
1238         override
1239         onlyAdmin
1240     {
1241         require(position[_signer] > 0, "Signer not found");
1242         signerKey[_signer] = status;
1243         emit SignerStatusChanged(_signer, status, block.timestamp);
1244     }
1245 
1246     /**
1247      * @dev External function to pause the contract by admin.
1248      */
1249     function pause() external onlyAdmin {
1250         _pause();
1251     }
1252 
1253     /**
1254      * @dev External function to unpause the contract by admin.
1255      */
1256     function unPause() external onlyAdmin {
1257         _unpause();
1258     }
1259 
1260     /**
1261      * @dev External function to add new signer to the contract by admin.
1262      */
1263     function addSigner(address _signer) public override onlyAdmin {
1264         require(_signer != address(0), "Zero signer address");
1265         require(position[_signer] == 0, "Already added");
1266         signers.push(_signer);
1267         position[_signer] = signers.length;
1268         signerKey[_signer] = true;
1269         emit SignerAdded(_signer, block.timestamp);
1270     }
1271 
1272     /**
1273      * @dev External function to change no of min signs required to unlock, by admin.
1274      */
1275     function changeMinSignsRequired(uint256 _minSignRequired)
1276         external
1277         override
1278         onlyAdmin
1279     {
1280         require(
1281             _minSignRequired > 0 && _minSignRequired <= signers.length,
1282             "Invalid min signs required"
1283         );
1284         uint256 prevValue = minSignsRequired;
1285         minSignsRequired = _minSignRequired;
1286         emit MinimumSignsChanged(prevValue, _minSignRequired, block.timestamp);
1287     }
1288 
1289     /**
1290      * @dev External function to enable/disable tax on a particular address by admin.
1291      */
1292     function changeUserTaxStatus(address user, bool value)
1293         external
1294         override
1295         onlyAdmin
1296     {
1297         isTaxless[user] = value;
1298     }
1299 
1300     /**
1301      * @dev External function to enable/disable tax on the `lock` call.
1302      */
1303     function changeTaxStatus(bool value) external override onlyAdmin {
1304         taxEnabled = value;
1305         emit TaxStatusChanged(value, block.timestamp);
1306     }
1307 
1308     /**
1309      * @dev External function to change tax percent on `lock` call.
1310      */
1311     function changeTaxPercent(uint256 value) external override onlyAdmin {
1312         require(value <= feeDenom, "Tax too high");
1313         taxPercent = value;
1314         emit TaxPercentChanged(value, block.timestamp);
1315     }
1316 
1317     /**
1318      * @dev External function to lock the tokens on bridge(when the contract is not paused).
1319      */
1320     function lock(uint256 amount)
1321         external
1322         override
1323         whenNotPaused
1324         returns (bool)
1325     {
1326         require(
1327             amount >= minimumTokens,
1328             "Amount must be greater than minimum tokens"
1329         );
1330         if (taxEnabled && !isTaxless[msg.sender]) {
1331             uint256 finalAmount = (amount * (feeDenom - taxPercent)) / feeDenom;
1332             uint256 taxAmount = amount - finalAmount;
1333             if (taxAmount > 0)
1334                 ERC20Interface.safeTransferFrom(msg.sender, admin, taxAmount);
1335             amount = finalAmount;
1336         }
1337 
1338         totalLocked += amount;
1339         userNonce[msg.sender]++;
1340         ERC20Interface.safeTransferFrom(msg.sender, address(this), amount);
1341         emit Lock(
1342             msg.sender,
1343             amount,
1344             block.timestamp,
1345             keccak256(
1346                 abi.encodePacked(
1347                     msg.sender,
1348                     amount,
1349                     block.timestamp,
1350                     userNonce[msg.sender]
1351                 )
1352             )
1353         );
1354         return true;
1355     }
1356 
1357     /**
1358      * @dev External function to unlock the tokens on bridge(when the contract is not paused).
1359      */
1360     function unlock(
1361         address user,
1362         uint256 amount,
1363         bytes32 _id,
1364         bytes[] memory signatures
1365     ) external whenNotPaused returns (bool) {
1366         require(msg.sender == owner, "Not the owner");
1367         require(
1368             signaturesValid(signatures, _id),
1369             "Signature Verification Failed"
1370         );
1371 
1372         if (amount <= totalLocked) {
1373             userClaimable[user] += amount;
1374             totalLocked -= amount;
1375         } else {
1376             ERC20Interface.mint(address(this), amount - totalLocked);
1377             userClaimable[user] += amount;
1378             totalLocked = 0;
1379         }
1380         emit Unlock(user, amount, block.timestamp, _id);
1381         return true;
1382     }
1383 
1384     /**
1385      * @dev External function to claim the user tokens.
1386      */
1387     function claimTokens() external override returns (bool) {
1388         require(
1389             userClaimable[msg.sender] > 0,
1390             "No tokens available for claiming"
1391         );
1392         require(
1393             userClaimable[msg.sender] <=
1394                 ERC20Interface.balanceOf(address(this)),
1395             "Not enough tokens in the contract"
1396         );
1397         uint256 amount = userClaimable[msg.sender];
1398         delete userClaimable[msg.sender];
1399         ERC20Interface.safeTransfer(msg.sender,amount);
1400         return true;
1401     }
1402 
1403     /**
1404      * @dev Public function to check if the min signs from the signers are present during `unlock`.
1405      */
1406     function signaturesValid(bytes[] memory signatures, bytes32 _id)
1407         public
1408         view
1409         override
1410         returns (bool)
1411     {
1412         require(signatures.length > 0, "Zero signatures length");
1413         uint256 minSignsChecked;
1414         for (uint256 i; i < signatures.length; i++) {
1415             if (minSignsChecked == minSignsRequired) {
1416                 break;
1417             } else {
1418                 (address signer, ) = ECDSAUpgradeable.tryRecover(
1419                     (ECDSAUpgradeable.toEthSignedMessageHash(_id)),
1420                     signatures[i]
1421                 );
1422                 if (signerKey[signer]) minSignsChecked++;
1423             }
1424         }
1425         return (minSignsChecked == minSignsRequired) ? true : false;
1426     }
1427 
1428     //@dev see interface for more context
1429     function changeMinimumTokenToBridge(uint256 amount) external onlyAdmin {
1430         require(amount > 10, "amount must be greater than 10");
1431         minimumTokens = amount;
1432         emit MinimumTokensChanged(amount);
1433     }
1434 }