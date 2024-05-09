1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         // On the first call to nonReentrant, _notEntered will be true
54         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
55 
56         // Any calls to nonReentrant after this point will fail
57         _status = _ENTERED;
58 
59         _;
60 
61         // By storing the original value once again, a refund is triggered (see
62         // https://eips.ethereum.org/EIPS/eip-2200)
63         _status = _NOT_ENTERED;
64     }
65 }
66 
67 // File: @openzeppelin/contracts/utils/Strings.sol
68 
69 
70 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev String operations.
76  */
77 library Strings {
78     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
79 
80     /**
81      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
82      */
83     function toString(uint256 value) internal pure returns (string memory) {
84         // Inspired by OraclizeAPI's implementation - MIT licence
85         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
86 
87         if (value == 0) {
88             return "0";
89         }
90         uint256 temp = value;
91         uint256 digits;
92         while (temp != 0) {
93             digits++;
94             temp /= 10;
95         }
96         bytes memory buffer = new bytes(digits);
97         while (value != 0) {
98             digits -= 1;
99             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
100             value /= 10;
101         }
102         return string(buffer);
103     }
104 
105     /**
106      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
107      */
108     function toHexString(uint256 value) internal pure returns (string memory) {
109         if (value == 0) {
110             return "0x00";
111         }
112         uint256 temp = value;
113         uint256 length = 0;
114         while (temp != 0) {
115             length++;
116             temp >>= 8;
117         }
118         return toHexString(value, length);
119     }
120 
121     /**
122      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
123      */
124     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
125         bytes memory buffer = new bytes(2 * length + 2);
126         buffer[0] = "0";
127         buffer[1] = "x";
128         for (uint256 i = 2 * length + 1; i > 1; --i) {
129             buffer[i] = _HEX_SYMBOLS[value & 0xf];
130             value >>= 4;
131         }
132         require(value == 0, "Strings: hex length insufficient");
133         return string(buffer);
134     }
135 }
136 
137 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
138 
139 
140 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
141 
142 pragma solidity ^0.8.0;
143 
144 
145 /**
146  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
147  *
148  * These functions can be used to verify that a message was signed by the holder
149  * of the private keys of a given address.
150  */
151 library ECDSA {
152     enum RecoverError {
153         NoError,
154         InvalidSignature,
155         InvalidSignatureLength,
156         InvalidSignatureS,
157         InvalidSignatureV
158     }
159 
160     function _throwError(RecoverError error) private pure {
161         if (error == RecoverError.NoError) {
162             return; // no error: do nothing
163         } else if (error == RecoverError.InvalidSignature) {
164             revert("ECDSA: invalid signature");
165         } else if (error == RecoverError.InvalidSignatureLength) {
166             revert("ECDSA: invalid signature length");
167         } else if (error == RecoverError.InvalidSignatureS) {
168             revert("ECDSA: invalid signature 's' value");
169         } else if (error == RecoverError.InvalidSignatureV) {
170             revert("ECDSA: invalid signature 'v' value");
171         }
172     }
173 
174     /**
175      * @dev Returns the address that signed a hashed message (`hash`) with
176      * `signature` or error string. This address can then be used for verification purposes.
177      *
178      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
179      * this function rejects them by requiring the `s` value to be in the lower
180      * half order, and the `v` value to be either 27 or 28.
181      *
182      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
183      * verification to be secure: it is possible to craft signatures that
184      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
185      * this is by receiving a hash of the original message (which may otherwise
186      * be too long), and then calling {toEthSignedMessageHash} on it.
187      *
188      * Documentation for signature generation:
189      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
190      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
191      *
192      * _Available since v4.3._
193      */
194     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
195         // Check the signature length
196         // - case 65: r,s,v signature (standard)
197         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
198         if (signature.length == 65) {
199             bytes32 r;
200             bytes32 s;
201             uint8 v;
202             // ecrecover takes the signature parameters, and the only way to get them
203             // currently is to use assembly.
204             assembly {
205                 r := mload(add(signature, 0x20))
206                 s := mload(add(signature, 0x40))
207                 v := byte(0, mload(add(signature, 0x60)))
208             }
209             return tryRecover(hash, v, r, s);
210         } else if (signature.length == 64) {
211             bytes32 r;
212             bytes32 vs;
213             // ecrecover takes the signature parameters, and the only way to get them
214             // currently is to use assembly.
215             assembly {
216                 r := mload(add(signature, 0x20))
217                 vs := mload(add(signature, 0x40))
218             }
219             return tryRecover(hash, r, vs);
220         } else {
221             return (address(0), RecoverError.InvalidSignatureLength);
222         }
223     }
224 
225     /**
226      * @dev Returns the address that signed a hashed message (`hash`) with
227      * `signature`. This address can then be used for verification purposes.
228      *
229      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
230      * this function rejects them by requiring the `s` value to be in the lower
231      * half order, and the `v` value to be either 27 or 28.
232      *
233      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
234      * verification to be secure: it is possible to craft signatures that
235      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
236      * this is by receiving a hash of the original message (which may otherwise
237      * be too long), and then calling {toEthSignedMessageHash} on it.
238      */
239     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
240         (address recovered, RecoverError error) = tryRecover(hash, signature);
241         _throwError(error);
242         return recovered;
243     }
244 
245     /**
246      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
247      *
248      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
249      *
250      * _Available since v4.3._
251      */
252     function tryRecover(
253         bytes32 hash,
254         bytes32 r,
255         bytes32 vs
256     ) internal pure returns (address, RecoverError) {
257         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
258         uint8 v = uint8((uint256(vs) >> 255) + 27);
259         return tryRecover(hash, v, r, s);
260     }
261 
262     /**
263      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
264      *
265      * _Available since v4.2._
266      */
267     function recover(
268         bytes32 hash,
269         bytes32 r,
270         bytes32 vs
271     ) internal pure returns (address) {
272         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
273         _throwError(error);
274         return recovered;
275     }
276 
277     /**
278      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
279      * `r` and `s` signature fields separately.
280      *
281      * _Available since v4.3._
282      */
283     function tryRecover(
284         bytes32 hash,
285         uint8 v,
286         bytes32 r,
287         bytes32 s
288     ) internal pure returns (address, RecoverError) {
289         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
290         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
291         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
292         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
293         //
294         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
295         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
296         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
297         // these malleable signatures as well.
298         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
299             return (address(0), RecoverError.InvalidSignatureS);
300         }
301         if (v != 27 && v != 28) {
302             return (address(0), RecoverError.InvalidSignatureV);
303         }
304 
305         // If the signature is valid (and not malleable), return the signer address
306         address signer = ecrecover(hash, v, r, s);
307         if (signer == address(0)) {
308             return (address(0), RecoverError.InvalidSignature);
309         }
310 
311         return (signer, RecoverError.NoError);
312     }
313 
314     /**
315      * @dev Overload of {ECDSA-recover} that receives the `v`,
316      * `r` and `s` signature fields separately.
317      */
318     function recover(
319         bytes32 hash,
320         uint8 v,
321         bytes32 r,
322         bytes32 s
323     ) internal pure returns (address) {
324         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
325         _throwError(error);
326         return recovered;
327     }
328 
329     /**
330      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
331      * produces hash corresponding to the one signed with the
332      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
333      * JSON-RPC method as part of EIP-191.
334      *
335      * See {recover}.
336      */
337     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
338         // 32 is the length in bytes of hash,
339         // enforced by the type signature above
340         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
341     }
342 
343     /**
344      * @dev Returns an Ethereum Signed Message, created from `s`. This
345      * produces hash corresponding to the one signed with the
346      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
347      * JSON-RPC method as part of EIP-191.
348      *
349      * See {recover}.
350      */
351     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
352         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
353     }
354 
355     /**
356      * @dev Returns an Ethereum Signed Typed Data, created from a
357      * `domainSeparator` and a `structHash`. This produces hash corresponding
358      * to the one signed with the
359      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
360      * JSON-RPC method as part of EIP-712.
361      *
362      * See {recover}.
363      */
364     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
365         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
366     }
367 }
368 
369 // File: @openzeppelin/contracts/utils/cryptography/draft-EIP712.sol
370 
371 
372 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/draft-EIP712.sol)
373 
374 pragma solidity ^0.8.0;
375 
376 
377 /**
378  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
379  *
380  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
381  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
382  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
383  *
384  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
385  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
386  * ({_hashTypedDataV4}).
387  *
388  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
389  * the chain id to protect against replay attacks on an eventual fork of the chain.
390  *
391  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
392  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
393  *
394  * _Available since v3.4._
395  */
396 abstract contract EIP712 {
397     /* solhint-disable var-name-mixedcase */
398     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
399     // invalidate the cached domain separator if the chain id changes.
400     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
401     uint256 private immutable _CACHED_CHAIN_ID;
402     address private immutable _CACHED_THIS;
403 
404     bytes32 private immutable _HASHED_NAME;
405     bytes32 private immutable _HASHED_VERSION;
406     bytes32 private immutable _TYPE_HASH;
407 
408     /* solhint-enable var-name-mixedcase */
409 
410     /**
411      * @dev Initializes the domain separator and parameter caches.
412      *
413      * The meaning of `name` and `version` is specified in
414      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
415      *
416      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
417      * - `version`: the current major version of the signing domain.
418      *
419      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
420      * contract upgrade].
421      */
422     constructor(string memory name, string memory version) {
423         bytes32 hashedName = keccak256(bytes(name));
424         bytes32 hashedVersion = keccak256(bytes(version));
425         bytes32 typeHash = keccak256(
426             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
427         );
428         _HASHED_NAME = hashedName;
429         _HASHED_VERSION = hashedVersion;
430         _CACHED_CHAIN_ID = block.chainid;
431         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
432         _CACHED_THIS = address(this);
433         _TYPE_HASH = typeHash;
434     }
435 
436     /**
437      * @dev Returns the domain separator for the current chain.
438      */
439     function _domainSeparatorV4() internal view returns (bytes32) {
440         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
441             return _CACHED_DOMAIN_SEPARATOR;
442         } else {
443             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
444         }
445     }
446 
447     function _buildDomainSeparator(
448         bytes32 typeHash,
449         bytes32 nameHash,
450         bytes32 versionHash
451     ) private view returns (bytes32) {
452         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
453     }
454 
455     /**
456      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
457      * function returns the hash of the fully encoded EIP712 message for this domain.
458      *
459      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
460      *
461      * ```solidity
462      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
463      *     keccak256("Mail(address to,string contents)"),
464      *     mailTo,
465      *     keccak256(bytes(mailContents))
466      * )));
467      * address signer = ECDSA.recover(digest, signature);
468      * ```
469      */
470     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
471         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
472     }
473 }
474 
475 // File: Whitelist.sol
476 
477 pragma solidity ^0.8.0;
478 
479 
480 contract whitelistChecker is EIP712{
481 
482     string private constant SIGNING_DOMAIN = "88 Dynasty";
483     string private constant SIGNATURE_VERSION = "1";
484 
485     struct whitelisted{
486         address addr;
487 
488 	    // 1 -> free list
489 	    // 2 -> lucky list
490 	    // 3 -> dynasty list
491         uint listType;
492 	    
493         bytes signature;
494     }
495 
496     constructor() EIP712(SIGNING_DOMAIN, SIGNATURE_VERSION){}
497   
498   
499     function getSigner(whitelisted memory list) public view returns(address){
500         return _verify(list);
501     }
502 
503     
504     /// @notice Returns a hash of the given rarity, prepared using EIP712 typed data hashing rules.
505   
506     function _hash(whitelisted memory list) internal view returns (bytes32) {
507         return _hashTypedDataV4(
508             keccak256(
509                 abi.encode(
510                     keccak256("whitelisted(address addr,uint listType)"),
511                     list.addr,
512                     list.listType
513                 )
514             )
515         );
516     }
517 
518     function _verify(whitelisted memory list) internal view returns (address) {
519         bytes32 digest = _hash(list);
520         return ECDSA.recover(digest, list.signature);
521     }
522 
523     function getChainID() external view returns (uint256) {
524         uint256 id;
525         assembly {
526             id := chainid()
527         }
528         return id;
529     }
530 }
531 
532 // File: @openzeppelin/contracts/utils/Address.sol
533 
534 
535 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
536 
537 pragma solidity ^0.8.1;
538 
539 /**
540  * @dev Collection of functions related to the address type
541  */
542 library Address {
543     /**
544      * @dev Returns true if `account` is a contract.
545      *
546      * [IMPORTANT]
547      * ====
548      * It is unsafe to assume that an address for which this function returns
549      * false is an externally-owned account (EOA) and not a contract.
550      *
551      * Among others, `isContract` will return false for the following
552      * types of addresses:
553      *
554      *  - an externally-owned account
555      *  - a contract in construction
556      *  - an address where a contract will be created
557      *  - an address where a contract lived, but was destroyed
558      * ====
559      *
560      * [IMPORTANT]
561      * ====
562      * You shouldn't rely on `isContract` to protect against flash loan attacks!
563      *
564      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
565      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
566      * constructor.
567      * ====
568      */
569     function isContract(address account) internal view returns (bool) {
570         // This method relies on extcodesize/address.code.length, which returns 0
571         // for contracts in construction, since the code is only stored at the end
572         // of the constructor execution.
573 
574         return account.code.length > 0;
575     }
576 
577     /**
578      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
579      * `recipient`, forwarding all available gas and reverting on errors.
580      *
581      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
582      * of certain opcodes, possibly making contracts go over the 2300 gas limit
583      * imposed by `transfer`, making them unable to receive funds via
584      * `transfer`. {sendValue} removes this limitation.
585      *
586      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
587      *
588      * IMPORTANT: because control is transferred to `recipient`, care must be
589      * taken to not create reentrancy vulnerabilities. Consider using
590      * {ReentrancyGuard} or the
591      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
592      */
593     function sendValue(address payable recipient, uint256 amount) internal {
594         require(address(this).balance >= amount, "Address: insufficient balance");
595 
596         (bool success, ) = recipient.call{value: amount}("");
597         require(success, "Address: unable to send value, recipient may have reverted");
598     }
599 
600     /**
601      * @dev Performs a Solidity function call using a low level `call`. A
602      * plain `call` is an unsafe replacement for a function call: use this
603      * function instead.
604      *
605      * If `target` reverts with a revert reason, it is bubbled up by this
606      * function (like regular Solidity function calls).
607      *
608      * Returns the raw returned data. To convert to the expected return value,
609      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
610      *
611      * Requirements:
612      *
613      * - `target` must be a contract.
614      * - calling `target` with `data` must not revert.
615      *
616      * _Available since v3.1._
617      */
618     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
619         return functionCall(target, data, "Address: low-level call failed");
620     }
621 
622     /**
623      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
624      * `errorMessage` as a fallback revert reason when `target` reverts.
625      *
626      * _Available since v3.1._
627      */
628     function functionCall(
629         address target,
630         bytes memory data,
631         string memory errorMessage
632     ) internal returns (bytes memory) {
633         return functionCallWithValue(target, data, 0, errorMessage);
634     }
635 
636     /**
637      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
638      * but also transferring `value` wei to `target`.
639      *
640      * Requirements:
641      *
642      * - the calling contract must have an ETH balance of at least `value`.
643      * - the called Solidity function must be `payable`.
644      *
645      * _Available since v3.1._
646      */
647     function functionCallWithValue(
648         address target,
649         bytes memory data,
650         uint256 value
651     ) internal returns (bytes memory) {
652         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
653     }
654 
655     /**
656      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
657      * with `errorMessage` as a fallback revert reason when `target` reverts.
658      *
659      * _Available since v3.1._
660      */
661     function functionCallWithValue(
662         address target,
663         bytes memory data,
664         uint256 value,
665         string memory errorMessage
666     ) internal returns (bytes memory) {
667         require(address(this).balance >= value, "Address: insufficient balance for call");
668         require(isContract(target), "Address: call to non-contract");
669 
670         (bool success, bytes memory returndata) = target.call{value: value}(data);
671         return verifyCallResult(success, returndata, errorMessage);
672     }
673 
674     /**
675      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
676      * but performing a static call.
677      *
678      * _Available since v3.3._
679      */
680     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
681         return functionStaticCall(target, data, "Address: low-level static call failed");
682     }
683 
684     /**
685      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
686      * but performing a static call.
687      *
688      * _Available since v3.3._
689      */
690     function functionStaticCall(
691         address target,
692         bytes memory data,
693         string memory errorMessage
694     ) internal view returns (bytes memory) {
695         require(isContract(target), "Address: static call to non-contract");
696 
697         (bool success, bytes memory returndata) = target.staticcall(data);
698         return verifyCallResult(success, returndata, errorMessage);
699     }
700 
701     /**
702      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
703      * but performing a delegate call.
704      *
705      * _Available since v3.4._
706      */
707     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
708         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
709     }
710 
711     /**
712      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
713      * but performing a delegate call.
714      *
715      * _Available since v3.4._
716      */
717     function functionDelegateCall(
718         address target,
719         bytes memory data,
720         string memory errorMessage
721     ) internal returns (bytes memory) {
722         require(isContract(target), "Address: delegate call to non-contract");
723 
724         (bool success, bytes memory returndata) = target.delegatecall(data);
725         return verifyCallResult(success, returndata, errorMessage);
726     }
727 
728     /**
729      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
730      * revert reason using the provided one.
731      *
732      * _Available since v4.3._
733      */
734     function verifyCallResult(
735         bool success,
736         bytes memory returndata,
737         string memory errorMessage
738     ) internal pure returns (bytes memory) {
739         if (success) {
740             return returndata;
741         } else {
742             // Look for revert reason and bubble it up if present
743             if (returndata.length > 0) {
744                 // The easiest way to bubble the revert reason is using memory via assembly
745 
746                 assembly {
747                     let returndata_size := mload(returndata)
748                     revert(add(32, returndata), returndata_size)
749                 }
750             } else {
751                 revert(errorMessage);
752             }
753         }
754     }
755 }
756 
757 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
758 
759 
760 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
761 
762 pragma solidity ^0.8.0;
763 
764 /**
765  * @title ERC721 token receiver interface
766  * @dev Interface for any contract that wants to support safeTransfers
767  * from ERC721 asset contracts.
768  */
769 interface IERC721Receiver {
770     /**
771      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
772      * by `operator` from `from`, this function is called.
773      *
774      * It must return its Solidity selector to confirm the token transfer.
775      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
776      *
777      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
778      */
779     function onERC721Received(
780         address operator,
781         address from,
782         uint256 tokenId,
783         bytes calldata data
784     ) external returns (bytes4);
785 }
786 
787 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
788 
789 
790 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
791 
792 pragma solidity ^0.8.0;
793 
794 /**
795  * @dev Interface of the ERC165 standard, as defined in the
796  * https://eips.ethereum.org/EIPS/eip-165[EIP].
797  *
798  * Implementers can declare support of contract interfaces, which can then be
799  * queried by others ({ERC165Checker}).
800  *
801  * For an implementation, see {ERC165}.
802  */
803 interface IERC165 {
804     /**
805      * @dev Returns true if this contract implements the interface defined by
806      * `interfaceId`. See the corresponding
807      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
808      * to learn more about how these ids are created.
809      *
810      * This function call must use less than 30 000 gas.
811      */
812     function supportsInterface(bytes4 interfaceId) external view returns (bool);
813 }
814 
815 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
816 
817 
818 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
819 
820 pragma solidity ^0.8.0;
821 
822 
823 /**
824  * @dev Implementation of the {IERC165} interface.
825  *
826  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
827  * for the additional interface id that will be supported. For example:
828  *
829  * ```solidity
830  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
831  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
832  * }
833  * ```
834  *
835  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
836  */
837 abstract contract ERC165 is IERC165 {
838     /**
839      * @dev See {IERC165-supportsInterface}.
840      */
841     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
842         return interfaceId == type(IERC165).interfaceId;
843     }
844 }
845 
846 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
847 
848 
849 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
850 
851 pragma solidity ^0.8.0;
852 
853 
854 /**
855  * @dev Required interface of an ERC721 compliant contract.
856  */
857 interface IERC721 is IERC165 {
858     /**
859      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
860      */
861     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
862 
863     /**
864      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
865      */
866     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
867 
868     /**
869      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
870      */
871     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
872 
873     /**
874      * @dev Returns the number of tokens in ``owner``'s account.
875      */
876     function balanceOf(address owner) external view returns (uint256 balance);
877 
878     /**
879      * @dev Returns the owner of the `tokenId` token.
880      *
881      * Requirements:
882      *
883      * - `tokenId` must exist.
884      */
885     function ownerOf(uint256 tokenId) external view returns (address owner);
886 
887     /**
888      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
889      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
890      *
891      * Requirements:
892      *
893      * - `from` cannot be the zero address.
894      * - `to` cannot be the zero address.
895      * - `tokenId` token must exist and be owned by `from`.
896      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
897      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
898      *
899      * Emits a {Transfer} event.
900      */
901     function safeTransferFrom(
902         address from,
903         address to,
904         uint256 tokenId
905     ) external;
906 
907     /**
908      * @dev Transfers `tokenId` token from `from` to `to`.
909      *
910      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
911      *
912      * Requirements:
913      *
914      * - `from` cannot be the zero address.
915      * - `to` cannot be the zero address.
916      * - `tokenId` token must be owned by `from`.
917      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
918      *
919      * Emits a {Transfer} event.
920      */
921     function transferFrom(
922         address from,
923         address to,
924         uint256 tokenId
925     ) external;
926 
927     /**
928      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
929      * The approval is cleared when the token is transferred.
930      *
931      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
932      *
933      * Requirements:
934      *
935      * - The caller must own the token or be an approved operator.
936      * - `tokenId` must exist.
937      *
938      * Emits an {Approval} event.
939      */
940     function approve(address to, uint256 tokenId) external;
941 
942     /**
943      * @dev Returns the account approved for `tokenId` token.
944      *
945      * Requirements:
946      *
947      * - `tokenId` must exist.
948      */
949     function getApproved(uint256 tokenId) external view returns (address operator);
950 
951     /**
952      * @dev Approve or remove `operator` as an operator for the caller.
953      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
954      *
955      * Requirements:
956      *
957      * - The `operator` cannot be the caller.
958      *
959      * Emits an {ApprovalForAll} event.
960      */
961     function setApprovalForAll(address operator, bool _approved) external;
962 
963     /**
964      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
965      *
966      * See {setApprovalForAll}
967      */
968     function isApprovedForAll(address owner, address operator) external view returns (bool);
969 
970     /**
971      * @dev Safely transfers `tokenId` token from `from` to `to`.
972      *
973      * Requirements:
974      *
975      * - `from` cannot be the zero address.
976      * - `to` cannot be the zero address.
977      * - `tokenId` token must exist and be owned by `from`.
978      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
979      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
980      *
981      * Emits a {Transfer} event.
982      */
983     function safeTransferFrom(
984         address from,
985         address to,
986         uint256 tokenId,
987         bytes calldata data
988     ) external;
989 }
990 
991 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
992 
993 
994 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
995 
996 pragma solidity ^0.8.0;
997 
998 
999 /**
1000  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1001  * @dev See https://eips.ethereum.org/EIPS/eip-721
1002  */
1003 interface IERC721Metadata is IERC721 {
1004     /**
1005      * @dev Returns the token collection name.
1006      */
1007     function name() external view returns (string memory);
1008 
1009     /**
1010      * @dev Returns the token collection symbol.
1011      */
1012     function symbol() external view returns (string memory);
1013 
1014     /**
1015      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1016      */
1017     function tokenURI(uint256 tokenId) external view returns (string memory);
1018 }
1019 
1020 // File: @openzeppelin/contracts/utils/Context.sol
1021 
1022 
1023 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1024 
1025 pragma solidity ^0.8.0;
1026 
1027 /**
1028  * @dev Provides information about the current execution context, including the
1029  * sender of the transaction and its data. While these are generally available
1030  * via msg.sender and msg.data, they should not be accessed in such a direct
1031  * manner, since when dealing with meta-transactions the account sending and
1032  * paying for execution may not be the actual sender (as far as an application
1033  * is concerned).
1034  *
1035  * This contract is only required for intermediate, library-like contracts.
1036  */
1037 abstract contract Context {
1038     function _msgSender() internal view virtual returns (address) {
1039         return msg.sender;
1040     }
1041 
1042     function _msgData() internal view virtual returns (bytes calldata) {
1043         return msg.data;
1044     }
1045 }
1046 
1047 // File: erc721a/contracts/ERC721A.sol
1048 
1049 
1050 // Creator: Chiru Labs
1051 
1052 pragma solidity ^0.8.4;
1053 
1054 
1055 
1056 
1057 
1058 
1059 
1060 
1061 error ApprovalCallerNotOwnerNorApproved();
1062 error ApprovalQueryForNonexistentToken();
1063 error ApproveToCaller();
1064 error ApprovalToCurrentOwner();
1065 error BalanceQueryForZeroAddress();
1066 error MintToZeroAddress();
1067 error MintZeroQuantity();
1068 error OwnerQueryForNonexistentToken();
1069 error TransferCallerNotOwnerNorApproved();
1070 error TransferFromIncorrectOwner();
1071 error TransferToNonERC721ReceiverImplementer();
1072 error TransferToZeroAddress();
1073 error URIQueryForNonexistentToken();
1074 
1075 /**
1076  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1077  * the Metadata extension. Built to optimize for lower gas during batch mints.
1078  *
1079  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1080  *
1081  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1082  *
1083  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1084  */
1085 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1086     using Address for address;
1087     using Strings for uint256;
1088 
1089     // Compiler will pack this into a single 256bit word.
1090     struct TokenOwnership {
1091         // The address of the owner.
1092         address addr;
1093         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1094         uint64 startTimestamp;
1095         // Whether the token has been burned.
1096         bool burned;
1097     }
1098 
1099     // Compiler will pack this into a single 256bit word.
1100     struct AddressData {
1101         // Realistically, 2**64-1 is more than enough.
1102         uint64 balance;
1103         // Keeps track of mint count with minimal overhead for tokenomics.
1104         uint64 numberMinted;
1105         // Keeps track of burn count with minimal overhead for tokenomics.
1106         uint64 numberBurned;
1107         // For miscellaneous variable(s) pertaining to the address
1108         // (e.g. number of whitelist mint slots used).
1109         // If there are multiple variables, please pack them into a uint64.
1110         uint64 aux;
1111     }
1112 
1113     // The tokenId of the next token to be minted.
1114     uint256 internal _currentIndex;
1115 
1116     // The number of tokens burned.
1117     uint256 internal _burnCounter;
1118 
1119     // Token name
1120     string private _name;
1121 
1122     // Token symbol
1123     string private _symbol;
1124 
1125     // Mapping from token ID to ownership details
1126     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1127     mapping(uint256 => TokenOwnership) internal _ownerships;
1128 
1129     // Mapping owner address to address data
1130     mapping(address => AddressData) private _addressData;
1131 
1132     // Mapping from token ID to approved address
1133     mapping(uint256 => address) private _tokenApprovals;
1134 
1135     // Mapping from owner to operator approvals
1136     mapping(address => mapping(address => bool)) private _operatorApprovals;
1137 
1138     constructor(string memory name_, string memory symbol_) {
1139         _name = name_;
1140         _symbol = symbol_;
1141         _currentIndex = _startTokenId();
1142     }
1143 
1144     /**
1145      * To change the starting tokenId, please override this function.
1146      */
1147     function _startTokenId() internal view virtual returns (uint256) {
1148         return 0;
1149     }
1150 
1151     /**
1152      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1153      */
1154     function totalSupply() public view returns (uint256) {
1155         // Counter underflow is impossible as _burnCounter cannot be incremented
1156         // more than _currentIndex - _startTokenId() times
1157         unchecked {
1158             return _currentIndex - _burnCounter - _startTokenId();
1159         }
1160     }
1161 
1162     /**
1163      * Returns the total amount of tokens minted in the contract.
1164      */
1165     function _totalMinted() internal view returns (uint256) {
1166         // Counter underflow is impossible as _currentIndex does not decrement,
1167         // and it is initialized to _startTokenId()
1168         unchecked {
1169             return _currentIndex - _startTokenId();
1170         }
1171     }
1172 
1173     /**
1174      * @dev See {IERC165-supportsInterface}.
1175      */
1176     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1177         return
1178             interfaceId == type(IERC721).interfaceId ||
1179             interfaceId == type(IERC721Metadata).interfaceId ||
1180             super.supportsInterface(interfaceId);
1181     }
1182 
1183     /**
1184      * @dev See {IERC721-balanceOf}.
1185      */
1186     function balanceOf(address owner) public view override returns (uint256) {
1187         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1188         return uint256(_addressData[owner].balance);
1189     }
1190 
1191     /**
1192      * Returns the number of tokens minted by `owner`.
1193      */
1194     function _numberMinted(address owner) internal view returns (uint256) {
1195         return uint256(_addressData[owner].numberMinted);
1196     }
1197 
1198     /**
1199      * Returns the number of tokens burned by or on behalf of `owner`.
1200      */
1201     function _numberBurned(address owner) internal view returns (uint256) {
1202         return uint256(_addressData[owner].numberBurned);
1203     }
1204 
1205     /**
1206      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1207      */
1208     function _getAux(address owner) internal view returns (uint64) {
1209         return _addressData[owner].aux;
1210     }
1211 
1212     /**
1213      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1214      * If there are multiple variables, please pack them into a uint64.
1215      */
1216     function _setAux(address owner, uint64 aux) internal {
1217         _addressData[owner].aux = aux;
1218     }
1219 
1220     /**
1221      * Gas spent here starts off proportional to the maximum mint batch size.
1222      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1223      */
1224     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1225         uint256 curr = tokenId;
1226 
1227         unchecked {
1228             if (_startTokenId() <= curr && curr < _currentIndex) {
1229                 TokenOwnership memory ownership = _ownerships[curr];
1230                 if (!ownership.burned) {
1231                     if (ownership.addr != address(0)) {
1232                         return ownership;
1233                     }
1234                     // Invariant:
1235                     // There will always be an ownership that has an address and is not burned
1236                     // before an ownership that does not have an address and is not burned.
1237                     // Hence, curr will not underflow.
1238                     while (true) {
1239                         curr--;
1240                         ownership = _ownerships[curr];
1241                         if (ownership.addr != address(0)) {
1242                             return ownership;
1243                         }
1244                     }
1245                 }
1246             }
1247         }
1248         revert OwnerQueryForNonexistentToken();
1249     }
1250 
1251     /**
1252      * @dev See {IERC721-ownerOf}.
1253      */
1254     function ownerOf(uint256 tokenId) public view override returns (address) {
1255         return _ownershipOf(tokenId).addr;
1256     }
1257 
1258     /**
1259      * @dev See {IERC721Metadata-name}.
1260      */
1261     function name() public view virtual override returns (string memory) {
1262         return _name;
1263     }
1264 
1265     /**
1266      * @dev See {IERC721Metadata-symbol}.
1267      */
1268     function symbol() public view virtual override returns (string memory) {
1269         return _symbol;
1270     }
1271 
1272     /**
1273      * @dev See {IERC721Metadata-tokenURI}.
1274      */
1275     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1276         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1277 
1278         string memory baseURI = _baseURI();
1279         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1280     }
1281 
1282     /**
1283      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1284      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1285      * by default, can be overriden in child contracts.
1286      */
1287     function _baseURI() internal view virtual returns (string memory) {
1288         return '';
1289     }
1290 
1291     /**
1292      * @dev See {IERC721-approve}.
1293      */
1294     function approve(address to, uint256 tokenId) public override {
1295         address owner = ERC721A.ownerOf(tokenId);
1296         if (to == owner) revert ApprovalToCurrentOwner();
1297 
1298         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1299             revert ApprovalCallerNotOwnerNorApproved();
1300         }
1301 
1302         _approve(to, tokenId, owner);
1303     }
1304 
1305     /**
1306      * @dev See {IERC721-getApproved}.
1307      */
1308     function getApproved(uint256 tokenId) public view override returns (address) {
1309         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1310 
1311         return _tokenApprovals[tokenId];
1312     }
1313 
1314     /**
1315      * @dev See {IERC721-setApprovalForAll}.
1316      */
1317     function setApprovalForAll(address operator, bool approved) public virtual override {
1318         if (operator == _msgSender()) revert ApproveToCaller();
1319 
1320         _operatorApprovals[_msgSender()][operator] = approved;
1321         emit ApprovalForAll(_msgSender(), operator, approved);
1322     }
1323 
1324     /**
1325      * @dev See {IERC721-isApprovedForAll}.
1326      */
1327     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1328         return _operatorApprovals[owner][operator];
1329     }
1330 
1331     /**
1332      * @dev See {IERC721-transferFrom}.
1333      */
1334     function transferFrom(
1335         address from,
1336         address to,
1337         uint256 tokenId
1338     ) public virtual override {
1339         _transfer(from, to, tokenId);
1340     }
1341 
1342     /**
1343      * @dev See {IERC721-safeTransferFrom}.
1344      */
1345     function safeTransferFrom(
1346         address from,
1347         address to,
1348         uint256 tokenId
1349     ) public virtual override {
1350         safeTransferFrom(from, to, tokenId, '');
1351     }
1352 
1353     /**
1354      * @dev See {IERC721-safeTransferFrom}.
1355      */
1356     function safeTransferFrom(
1357         address from,
1358         address to,
1359         uint256 tokenId,
1360         bytes memory _data
1361     ) public virtual override {
1362         _transfer(from, to, tokenId);
1363         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1364             revert TransferToNonERC721ReceiverImplementer();
1365         }
1366     }
1367 
1368     /**
1369      * @dev Returns whether `tokenId` exists.
1370      *
1371      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1372      *
1373      * Tokens start existing when they are minted (`_mint`),
1374      */
1375     function _exists(uint256 tokenId) internal view returns (bool) {
1376         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1377     }
1378 
1379     function _safeMint(address to, uint256 quantity) internal {
1380         _safeMint(to, quantity, '');
1381     }
1382 
1383     /**
1384      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1385      *
1386      * Requirements:
1387      *
1388      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1389      * - `quantity` must be greater than 0.
1390      *
1391      * Emits a {Transfer} event.
1392      */
1393     function _safeMint(
1394         address to,
1395         uint256 quantity,
1396         bytes memory _data
1397     ) internal {
1398         _mint(to, quantity, _data, true);
1399     }
1400 
1401     /**
1402      * @dev Mints `quantity` tokens and transfers them to `to`.
1403      *
1404      * Requirements:
1405      *
1406      * - `to` cannot be the zero address.
1407      * - `quantity` must be greater than 0.
1408      *
1409      * Emits a {Transfer} event.
1410      */
1411     function _mint(
1412         address to,
1413         uint256 quantity,
1414         bytes memory _data,
1415         bool safe
1416     ) internal {
1417         uint256 startTokenId = _currentIndex;
1418         if (to == address(0)) revert MintToZeroAddress();
1419         if (quantity == 0) revert MintZeroQuantity();
1420 
1421         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1422 
1423         // Overflows are incredibly unrealistic.
1424         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1425         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1426         unchecked {
1427             _addressData[to].balance += uint64(quantity);
1428             _addressData[to].numberMinted += uint64(quantity);
1429 
1430             _ownerships[startTokenId].addr = to;
1431             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1432 
1433             uint256 updatedIndex = startTokenId;
1434             uint256 end = updatedIndex + quantity;
1435 
1436             if (safe && to.isContract()) {
1437                 do {
1438                     emit Transfer(address(0), to, updatedIndex);
1439                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1440                         revert TransferToNonERC721ReceiverImplementer();
1441                     }
1442                 } while (updatedIndex != end);
1443                 // Reentrancy protection
1444                 if (_currentIndex != startTokenId) revert();
1445             } else {
1446                 do {
1447                     emit Transfer(address(0), to, updatedIndex++);
1448                 } while (updatedIndex != end);
1449             }
1450             _currentIndex = updatedIndex;
1451         }
1452         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1453     }
1454 
1455     /**
1456      * @dev Transfers `tokenId` from `from` to `to`.
1457      *
1458      * Requirements:
1459      *
1460      * - `to` cannot be the zero address.
1461      * - `tokenId` token must be owned by `from`.
1462      *
1463      * Emits a {Transfer} event.
1464      */
1465     function _transfer(
1466         address from,
1467         address to,
1468         uint256 tokenId
1469     ) private {
1470         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1471 
1472         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1473 
1474         bool isApprovedOrOwner = (_msgSender() == from ||
1475             isApprovedForAll(from, _msgSender()) ||
1476             getApproved(tokenId) == _msgSender());
1477 
1478         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1479         if (to == address(0)) revert TransferToZeroAddress();
1480 
1481         _beforeTokenTransfers(from, to, tokenId, 1);
1482 
1483         // Clear approvals from the previous owner
1484         _approve(address(0), tokenId, from);
1485 
1486         // Underflow of the sender's balance is impossible because we check for
1487         // ownership above and the recipient's balance can't realistically overflow.
1488         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1489         unchecked {
1490             _addressData[from].balance -= 1;
1491             _addressData[to].balance += 1;
1492 
1493             TokenOwnership storage currSlot = _ownerships[tokenId];
1494             currSlot.addr = to;
1495             currSlot.startTimestamp = uint64(block.timestamp);
1496 
1497             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1498             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1499             uint256 nextTokenId = tokenId + 1;
1500             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1501             if (nextSlot.addr == address(0)) {
1502                 // This will suffice for checking _exists(nextTokenId),
1503                 // as a burned slot cannot contain the zero address.
1504                 if (nextTokenId != _currentIndex) {
1505                     nextSlot.addr = from;
1506                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1507                 }
1508             }
1509         }
1510 
1511         emit Transfer(from, to, tokenId);
1512         _afterTokenTransfers(from, to, tokenId, 1);
1513     }
1514 
1515     /**
1516      * @dev This is equivalent to _burn(tokenId, false)
1517      */
1518     function _burn(uint256 tokenId) internal virtual {
1519         _burn(tokenId, false);
1520     }
1521 
1522     /**
1523      * @dev Destroys `tokenId`.
1524      * The approval is cleared when the token is burned.
1525      *
1526      * Requirements:
1527      *
1528      * - `tokenId` must exist.
1529      *
1530      * Emits a {Transfer} event.
1531      */
1532     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1533         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1534 
1535         address from = prevOwnership.addr;
1536 
1537         if (approvalCheck) {
1538             bool isApprovedOrOwner = (_msgSender() == from ||
1539                 isApprovedForAll(from, _msgSender()) ||
1540                 getApproved(tokenId) == _msgSender());
1541 
1542             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1543         }
1544 
1545         _beforeTokenTransfers(from, address(0), tokenId, 1);
1546 
1547         // Clear approvals from the previous owner
1548         _approve(address(0), tokenId, from);
1549 
1550         // Underflow of the sender's balance is impossible because we check for
1551         // ownership above and the recipient's balance can't realistically overflow.
1552         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1553         unchecked {
1554             AddressData storage addressData = _addressData[from];
1555             addressData.balance -= 1;
1556             addressData.numberBurned += 1;
1557 
1558             // Keep track of who burned the token, and the timestamp of burning.
1559             TokenOwnership storage currSlot = _ownerships[tokenId];
1560             currSlot.addr = from;
1561             currSlot.startTimestamp = uint64(block.timestamp);
1562             currSlot.burned = true;
1563 
1564             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1565             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1566             uint256 nextTokenId = tokenId + 1;
1567             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1568             if (nextSlot.addr == address(0)) {
1569                 // This will suffice for checking _exists(nextTokenId),
1570                 // as a burned slot cannot contain the zero address.
1571                 if (nextTokenId != _currentIndex) {
1572                     nextSlot.addr = from;
1573                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1574                 }
1575             }
1576         }
1577 
1578         emit Transfer(from, address(0), tokenId);
1579         _afterTokenTransfers(from, address(0), tokenId, 1);
1580 
1581         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1582         unchecked {
1583             _burnCounter++;
1584         }
1585     }
1586 
1587     /**
1588      * @dev Approve `to` to operate on `tokenId`
1589      *
1590      * Emits a {Approval} event.
1591      */
1592     function _approve(
1593         address to,
1594         uint256 tokenId,
1595         address owner
1596     ) private {
1597         _tokenApprovals[tokenId] = to;
1598         emit Approval(owner, to, tokenId);
1599     }
1600 
1601     /**
1602      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1603      *
1604      * @param from address representing the previous owner of the given token ID
1605      * @param to target address that will receive the tokens
1606      * @param tokenId uint256 ID of the token to be transferred
1607      * @param _data bytes optional data to send along with the call
1608      * @return bool whether the call correctly returned the expected magic value
1609      */
1610     function _checkContractOnERC721Received(
1611         address from,
1612         address to,
1613         uint256 tokenId,
1614         bytes memory _data
1615     ) private returns (bool) {
1616         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1617             return retval == IERC721Receiver(to).onERC721Received.selector;
1618         } catch (bytes memory reason) {
1619             if (reason.length == 0) {
1620                 revert TransferToNonERC721ReceiverImplementer();
1621             } else {
1622                 assembly {
1623                     revert(add(32, reason), mload(reason))
1624                 }
1625             }
1626         }
1627     }
1628 
1629     /**
1630      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1631      * And also called before burning one token.
1632      *
1633      * startTokenId - the first token id to be transferred
1634      * quantity - the amount to be transferred
1635      *
1636      * Calling conditions:
1637      *
1638      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1639      * transferred to `to`.
1640      * - When `from` is zero, `tokenId` will be minted for `to`.
1641      * - When `to` is zero, `tokenId` will be burned by `from`.
1642      * - `from` and `to` are never both zero.
1643      */
1644     function _beforeTokenTransfers(
1645         address from,
1646         address to,
1647         uint256 startTokenId,
1648         uint256 quantity
1649     ) internal virtual {}
1650 
1651     /**
1652      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1653      * minting.
1654      * And also called after one token has been burned.
1655      *
1656      * startTokenId - the first token id to be transferred
1657      * quantity - the amount to be transferred
1658      *
1659      * Calling conditions:
1660      *
1661      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1662      * transferred to `to`.
1663      * - When `from` is zero, `tokenId` has been minted for `to`.
1664      * - When `to` is zero, `tokenId` has been burned by `from`.
1665      * - `from` and `to` are never both zero.
1666      */
1667     function _afterTokenTransfers(
1668         address from,
1669         address to,
1670         uint256 startTokenId,
1671         uint256 quantity
1672     ) internal virtual {}
1673 }
1674 
1675 // File: @openzeppelin/contracts/access/Ownable.sol
1676 
1677 
1678 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1679 
1680 pragma solidity ^0.8.0;
1681 
1682 
1683 /**
1684  * @dev Contract module which provides a basic access control mechanism, where
1685  * there is an account (an owner) that can be granted exclusive access to
1686  * specific functions.
1687  *
1688  * By default, the owner account will be the one that deploys the contract. This
1689  * can later be changed with {transferOwnership}.
1690  *
1691  * This module is used through inheritance. It will make available the modifier
1692  * `onlyOwner`, which can be applied to your functions to restrict their use to
1693  * the owner.
1694  */
1695 abstract contract Ownable is Context {
1696     address private _owner;
1697 
1698     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1699 
1700     /**
1701      * @dev Initializes the contract setting the deployer as the initial owner.
1702      */
1703     constructor() {
1704         _transferOwnership(_msgSender());
1705     }
1706 
1707     /**
1708      * @dev Returns the address of the current owner.
1709      */
1710     function owner() public view virtual returns (address) {
1711         return _owner;
1712     }
1713 
1714     /**
1715      * @dev Throws if called by any account other than the owner.
1716      */
1717     modifier onlyOwner() {
1718         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1719         _;
1720     }
1721 
1722     /**
1723      * @dev Leaves the contract without owner. It will not be possible to call
1724      * `onlyOwner` functions anymore. Can only be called by the current owner.
1725      *
1726      * NOTE: Renouncing ownership will leave the contract without an owner,
1727      * thereby removing any functionality that is only available to the owner.
1728      */
1729     function renounceOwnership() public virtual onlyOwner {
1730         _transferOwnership(address(0));
1731     }
1732 
1733     /**
1734      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1735      * Can only be called by the current owner.
1736      */
1737     function transferOwnership(address newOwner) public virtual onlyOwner {
1738         require(newOwner != address(0), "Ownable: new owner is the zero address");
1739         _transferOwnership(newOwner);
1740     }
1741 
1742     /**
1743      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1744      * Internal function without access restriction.
1745      */
1746     function _transferOwnership(address newOwner) internal virtual {
1747         address oldOwner = _owner;
1748         _owner = newOwner;
1749         emit OwnershipTransferred(oldOwner, newOwner);
1750     }
1751 }
1752 
1753 // File: NFT88Dynasty.sol
1754 
1755 //SPDX-License-Identifier: MIT
1756 
1757 pragma solidity ^0.8.0;
1758 
1759 
1760 
1761 
1762 
1763 contract NFT88Dynasty is ERC721A, Ownable, whitelistChecker, ReentrancyGuard {
1764 
1765     uint public CAP = 6888;
1766     uint public VAULT_CAP = 50;
1767     uint public PRESALE_CAP = 5500;
1768     
1769     uint public WHITELIST_PRICE = 0.0888 ether;
1770     uint public PUBLIC_PRICE = 0.1 ether;
1771     
1772     // Fri, 15 Apr 2022, 9AM PST
1773     uint public WHITELIST_START_TIME = 1649993400; 
1774     
1775     address payable public TREASURY;
1776 
1777     address public designatedSigner;
1778     string public baseTokenURI;
1779     
1780     uint internal _ownerMinted;
1781     uint internal _presaleMinted;
1782    
1783     mapping(address => uint) public presaleHasBought;
1784     mapping(address => uint) public publicSaleHasBought;
1785     
1786     constructor(
1787         string memory _name,
1788         string memory _symbol,
1789         address payable _treasury
1790     ) ERC721A(_name, _symbol) {
1791         TREASURY = _treasury;
1792         
1793         // tokenIds will start from 1
1794         _currentIndex++;
1795     }
1796     
1797     function ownerMint(
1798         uint _amount
1799     ) external onlyOwner {
1800         require(_amount != 0, "invalid amount");
1801         require(_ownerMinted + _amount <= VAULT_CAP);
1802         
1803         _ownerMinted += _amount;
1804         _safeMint(msg.sender, _amount);
1805     }
1806 
1807 
1808     function freeMint(
1809         whitelisted memory whitelist
1810     ) external nonReentrant {
1811         require(WHITELIST_START_TIME <= block.timestamp && block.timestamp <= WHITELIST_START_TIME + 14400, "free list: outside time window");
1812         require(getSigner(whitelist) == designatedSigner, "free list: invalid signature");
1813         require(whitelist.listType == 1, "free list: invalid type"); 
1814         require(msg.sender == whitelist.addr, "free list: not in the list");
1815         require(presaleHasBought[msg.sender] == 0, "free list: already bought");
1816         require(_presaleMinted < PRESALE_CAP, "free list: exceeding presale cap");
1817         
1818         _presaleMinted += 1;
1819         presaleHasBought[msg.sender] += 1;
1820         _safeMint(msg.sender, 1); 
1821 
1822     }
1823 
1824     function whitelistMint(
1825         whitelisted memory whitelist, 
1826         uint amount
1827     ) external payable nonReentrant {
1828         require(WHITELIST_START_TIME <= block.timestamp && block.timestamp <= WHITELIST_START_TIME + 14400, "whitelist: outside time window");
1829         require(getSigner(whitelist) == designatedSigner, "whitelist: invalid signature");
1830         require(whitelist.listType == 2 || whitelist.listType == 3, "whitelist: invalid type"); 
1831         require(msg.sender == whitelist.addr, "whitelist: not in the list");
1832         
1833         // type == 2: Lucky list
1834         if (whitelist.listType == 2) {
1835             require(presaleHasBought[msg.sender] == 0, "lucky list: already bought");
1836             require(_presaleMinted < PRESALE_CAP, "lucky list: exceeding presale cap");
1837             require(msg.value >= WHITELIST_PRICE, "lucky list: pay more");            
1838 
1839             _presaleMinted += 1;
1840             presaleHasBought[msg.sender] += 1;
1841             _safeMint(msg.sender, 1);
1842         }
1843 
1844         // type == 3: Dynasty list
1845         else {
1846             require(presaleHasBought[msg.sender] + amount <= 2, "dynasty list: cannot mint more than 2");
1847             require(amount != 0, "dynasty list: invalid amount");
1848             require(_presaleMinted + amount <= PRESALE_CAP, "dynasty list: exceeding presale cap");
1849             require(msg.value >= WHITELIST_PRICE * amount, "dynasty list: pay more");
1850 
1851             _presaleMinted += amount;
1852             presaleHasBought[msg.sender] += amount;
1853             _safeMint(msg.sender, amount);
1854         }	
1855     }
1856 
1857 
1858     function publicMint(
1859         uint amount
1860     ) external payable nonReentrant {
1861 	require(WHITELIST_START_TIME + 14400 < block.timestamp, "public mint: not started yet");       
1862 	require(publicSaleHasBought[msg.sender] + amount <= 2, "public mint: exceeding permitted limit");
1863         require(amount != 0, "public mint: invalid amount");
1864         require(_currentIndex + amount <= CAP - VAULT_CAP, "public mint: sold out");
1865         require(msg.value >= PUBLIC_PRICE * amount, "public mint: pay more");
1866 
1867 	publicSaleHasBought[msg.sender] += amount;
1868         _safeMint(msg.sender, amount); 
1869     }
1870 
1871 
1872     function withdraw(
1873     ) public onlyOwner {
1874         TREASURY.transfer(address(this).balance);
1875     }
1876 
1877     
1878     function modifyDesignatedSigner(
1879         address _signer
1880     ) external onlyOwner {
1881         designatedSigner = _signer;
1882     }
1883 
1884 
1885     function currentIndex(
1886     ) public view returns (uint) {
1887         return _currentIndex;
1888     }
1889 
1890 
1891     function modifyStartTime(
1892         uint256 startTime
1893     ) external onlyOwner {
1894         WHITELIST_START_TIME = startTime;
1895     }
1896 
1897 
1898     function _baseURI(
1899     ) internal view virtual override returns (string memory) {
1900         return baseTokenURI;
1901     }
1902 
1903 
1904     function setBaseURI(
1905         string memory baseURI_
1906     ) public onlyOwner {
1907         //require(bytes(_baseURI).length > 0, "88Dynasty.setBaseURI: base URI invalid");
1908         baseTokenURI = baseURI_;
1909     }
1910 
1911 }