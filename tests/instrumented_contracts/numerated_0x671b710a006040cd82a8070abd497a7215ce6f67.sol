1 // File: @openzeppelin/contracts@4.3.2/utils/cryptography/ECDSA.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
9  *
10  * These functions can be used to verify that a message was signed by the holder
11  * of the private keys of a given address.
12  */
13 library ECDSA {
14     enum RecoverError {
15         NoError,
16         InvalidSignature,
17         InvalidSignatureLength,
18         InvalidSignatureS,
19         InvalidSignatureV
20     }
21 
22     function _throwError(RecoverError error) private pure {
23         if (error == RecoverError.NoError) {
24             return; // no error: do nothing
25         } else if (error == RecoverError.InvalidSignature) {
26             revert("ECDSA: invalid signature");
27         } else if (error == RecoverError.InvalidSignatureLength) {
28             revert("ECDSA: invalid signature length");
29         } else if (error == RecoverError.InvalidSignatureS) {
30             revert("ECDSA: invalid signature 's' value");
31         } else if (error == RecoverError.InvalidSignatureV) {
32             revert("ECDSA: invalid signature 'v' value");
33         }
34     }
35 
36     /**
37      * @dev Returns the address that signed a hashed message (`hash`) with
38      * `signature` or error string. This address can then be used for verification purposes.
39      *
40      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
41      * this function rejects them by requiring the `s` value to be in the lower
42      * half order, and the `v` value to be either 27 or 28.
43      *
44      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
45      * verification to be secure: it is possible to craft signatures that
46      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
47      * this is by receiving a hash of the original message (which may otherwise
48      * be too long), and then calling {toEthSignedMessageHash} on it.
49      *
50      * Documentation for signature generation:
51      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
52      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
53      *
54      * _Available since v4.3._
55      */
56     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
57         // Check the signature length
58         // - case 65: r,s,v signature (standard)
59         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
60         if (signature.length == 65) {
61             bytes32 r;
62             bytes32 s;
63             uint8 v;
64             // ecrecover takes the signature parameters, and the only way to get them
65             // currently is to use assembly.
66             assembly {
67                 r := mload(add(signature, 0x20))
68                 s := mload(add(signature, 0x40))
69                 v := byte(0, mload(add(signature, 0x60)))
70             }
71             return tryRecover(hash, v, r, s);
72         } else if (signature.length == 64) {
73             bytes32 r;
74             bytes32 vs;
75             // ecrecover takes the signature parameters, and the only way to get them
76             // currently is to use assembly.
77             assembly {
78                 r := mload(add(signature, 0x20))
79                 vs := mload(add(signature, 0x40))
80             }
81             return tryRecover(hash, r, vs);
82         } else {
83             return (address(0), RecoverError.InvalidSignatureLength);
84         }
85     }
86 
87     /**
88      * @dev Returns the address that signed a hashed message (`hash`) with
89      * `signature`. This address can then be used for verification purposes.
90      *
91      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
92      * this function rejects them by requiring the `s` value to be in the lower
93      * half order, and the `v` value to be either 27 or 28.
94      *
95      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
96      * verification to be secure: it is possible to craft signatures that
97      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
98      * this is by receiving a hash of the original message (which may otherwise
99      * be too long), and then calling {toEthSignedMessageHash} on it.
100      */
101     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
102         (address recovered, RecoverError error) = tryRecover(hash, signature);
103         _throwError(error);
104         return recovered;
105     }
106 
107     /**
108      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
109      *
110      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
111      *
112      * _Available since v4.3._
113      */
114     function tryRecover(
115         bytes32 hash,
116         bytes32 r,
117         bytes32 vs
118     ) internal pure returns (address, RecoverError) {
119         bytes32 s;
120         uint8 v;
121         assembly {
122             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
123             v := add(shr(255, vs), 27)
124         }
125         return tryRecover(hash, v, r, s);
126     }
127 
128     /**
129      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
130      *
131      * _Available since v4.2._
132      */
133     function recover(
134         bytes32 hash,
135         bytes32 r,
136         bytes32 vs
137     ) internal pure returns (address) {
138         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
139         _throwError(error);
140         return recovered;
141     }
142 
143     /**
144      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
145      * `r` and `s` signature fields separately.
146      *
147      * _Available since v4.3._
148      */
149     function tryRecover(
150         bytes32 hash,
151         uint8 v,
152         bytes32 r,
153         bytes32 s
154     ) internal pure returns (address, RecoverError) {
155         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
156         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
157         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
158         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
159         //
160         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
161         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
162         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
163         // these malleable signatures as well.
164         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
165             return (address(0), RecoverError.InvalidSignatureS);
166         }
167         if (v != 27 && v != 28) {
168             return (address(0), RecoverError.InvalidSignatureV);
169         }
170 
171         // If the signature is valid (and not malleable), return the signer address
172         address signer = ecrecover(hash, v, r, s);
173         if (signer == address(0)) {
174             return (address(0), RecoverError.InvalidSignature);
175         }
176 
177         return (signer, RecoverError.NoError);
178     }
179 
180     /**
181      * @dev Overload of {ECDSA-recover} that receives the `v`,
182      * `r` and `s` signature fields separately.
183      */
184     function recover(
185         bytes32 hash,
186         uint8 v,
187         bytes32 r,
188         bytes32 s
189     ) internal pure returns (address) {
190         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
191         _throwError(error);
192         return recovered;
193     }
194 
195     /**
196      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
197      * produces hash corresponding to the one signed with the
198      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
199      * JSON-RPC method as part of EIP-191.
200      *
201      * See {recover}.
202      */
203     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
204         // 32 is the length in bytes of hash,
205         // enforced by the type signature above
206         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
207     }
208 
209     /**
210      * @dev Returns an Ethereum Signed Typed Data, created from a
211      * `domainSeparator` and a `structHash`. This produces hash corresponding
212      * to the one signed with the
213      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
214      * JSON-RPC method as part of EIP-712.
215      *
216      * See {recover}.
217      */
218     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
219         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
220     }
221 }
222 
223 // File: @openzeppelin/contracts@4.3.2/utils/cryptography/draft-EIP712.sol
224 
225 
226 
227 pragma solidity ^0.8.0;
228 
229 
230 /**
231  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
232  *
233  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
234  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
235  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
236  *
237  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
238  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
239  * ({_hashTypedDataV4}).
240  *
241  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
242  * the chain id to protect against replay attacks on an eventual fork of the chain.
243  *
244  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
245  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
246  *
247  * _Available since v3.4._
248  */
249 abstract contract EIP712 {
250     /* solhint-disable var-name-mixedcase */
251     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
252     // invalidate the cached domain separator if the chain id changes.
253     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
254     uint256 private immutable _CACHED_CHAIN_ID;
255 
256     bytes32 private immutable _HASHED_NAME;
257     bytes32 private immutable _HASHED_VERSION;
258     bytes32 private immutable _TYPE_HASH;
259 
260     /* solhint-enable var-name-mixedcase */
261 
262     /**
263      * @dev Initializes the domain separator and parameter caches.
264      *
265      * The meaning of `name` and `version` is specified in
266      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
267      *
268      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
269      * - `version`: the current major version of the signing domain.
270      *
271      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
272      * contract upgrade].
273      */
274     constructor(string memory name, string memory version) {
275         bytes32 hashedName = keccak256(bytes(name));
276         bytes32 hashedVersion = keccak256(bytes(version));
277         bytes32 typeHash = keccak256(
278             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
279         );
280         _HASHED_NAME = hashedName;
281         _HASHED_VERSION = hashedVersion;
282         _CACHED_CHAIN_ID = block.chainid;
283         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
284         _TYPE_HASH = typeHash;
285     }
286 
287     /**
288      * @dev Returns the domain separator for the current chain.
289      */
290     function _domainSeparatorV4() internal view returns (bytes32) {
291         if (block.chainid == _CACHED_CHAIN_ID) {
292             return _CACHED_DOMAIN_SEPARATOR;
293         } else {
294             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
295         }
296     }
297 
298     function _buildDomainSeparator(
299         bytes32 typeHash,
300         bytes32 nameHash,
301         bytes32 versionHash
302     ) private view returns (bytes32) {
303         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
304     }
305 
306     /**
307      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
308      * function returns the hash of the fully encoded EIP712 message for this domain.
309      *
310      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
311      *
312      * ```solidity
313      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
314      *     keccak256("Mail(address to,string contents)"),
315      *     mailTo,
316      *     keccak256(bytes(mailContents))
317      * )));
318      * address signer = ECDSA.recover(digest, signature);
319      * ```
320      */
321     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
322         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
323     }
324 }
325 
326 // File: @openzeppelin/contracts@4.3.2/token/ERC20/extensions/draft-IERC20Permit.sol
327 
328 
329 
330 pragma solidity ^0.8.0;
331 
332 /**
333  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
334  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
335  *
336  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
337  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
338  * need to send a transaction, and thus is not required to hold Ether at all.
339  */
340 interface IERC20Permit {
341     /**
342      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
343      * given ``owner``'s signed approval.
344      *
345      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
346      * ordering also apply here.
347      *
348      * Emits an {Approval} event.
349      *
350      * Requirements:
351      *
352      * - `spender` cannot be the zero address.
353      * - `deadline` must be a timestamp in the future.
354      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
355      * over the EIP712-formatted function arguments.
356      * - the signature must use ``owner``'s current nonce (see {nonces}).
357      *
358      * For more information on the signature format, see the
359      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
360      * section].
361      */
362     function permit(
363         address owner,
364         address spender,
365         uint256 value,
366         uint256 deadline,
367         uint8 v,
368         bytes32 r,
369         bytes32 s
370     ) external;
371 
372     /**
373      * @dev Returns the current nonce for `owner`. This value must be
374      * included whenever a signature is generated for {permit}.
375      *
376      * Every successful call to {permit} increases ``owner``'s nonce by one. This
377      * prevents a signature from being used multiple times.
378      */
379     function nonces(address owner) external view returns (uint256);
380 
381     /**
382      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
383      */
384     // solhint-disable-next-line func-name-mixedcase
385     function DOMAIN_SEPARATOR() external view returns (bytes32);
386 }
387 
388 // File: @openzeppelin/contracts@4.3.2/utils/Counters.sol
389 
390 
391 
392 pragma solidity ^0.8.0;
393 
394 /**
395  * @title Counters
396  * @author Matt Condon (@shrugs)
397  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
398  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
399  *
400  * Include with `using Counters for Counters.Counter;`
401  */
402 library Counters {
403     struct Counter {
404         // This variable should never be directly accessed by users of the library: interactions must be restricted to
405         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
406         // this feature: see https://github.com/ethereum/solidity/issues/4637
407         uint256 _value; // default: 0
408     }
409 
410     function current(Counter storage counter) internal view returns (uint256) {
411         return counter._value;
412     }
413 
414     function increment(Counter storage counter) internal {
415         unchecked {
416             counter._value += 1;
417         }
418     }
419 
420     function decrement(Counter storage counter) internal {
421         uint256 value = counter._value;
422         require(value > 0, "Counter: decrement overflow");
423         unchecked {
424             counter._value = value - 1;
425         }
426     }
427 
428     function reset(Counter storage counter) internal {
429         counter._value = 0;
430     }
431 }
432 
433 // File: @openzeppelin/contracts@4.3.2/utils/math/Math.sol
434 
435 
436 
437 pragma solidity ^0.8.0;
438 
439 /**
440  * @dev Standard math utilities missing in the Solidity language.
441  */
442 library Math {
443     /**
444      * @dev Returns the largest of two numbers.
445      */
446     function max(uint256 a, uint256 b) internal pure returns (uint256) {
447         return a >= b ? a : b;
448     }
449 
450     /**
451      * @dev Returns the smallest of two numbers.
452      */
453     function min(uint256 a, uint256 b) internal pure returns (uint256) {
454         return a < b ? a : b;
455     }
456 
457     /**
458      * @dev Returns the average of two numbers. The result is rounded towards
459      * zero.
460      */
461     function average(uint256 a, uint256 b) internal pure returns (uint256) {
462         // (a + b) / 2 can overflow.
463         return (a & b) + (a ^ b) / 2;
464     }
465 
466     /**
467      * @dev Returns the ceiling of the division of two numbers.
468      *
469      * This differs from standard division with `/` in that it rounds up instead
470      * of rounding down.
471      */
472     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
473         // (a + b - 1) / b can overflow on addition, so we distribute.
474         return a / b + (a % b == 0 ? 0 : 1);
475     }
476 }
477 
478 // File: @openzeppelin/contracts@4.3.2/utils/Arrays.sol
479 
480 
481 
482 pragma solidity ^0.8.0;
483 
484 
485 /**
486  * @dev Collection of functions related to array types.
487  */
488 library Arrays {
489     /**
490      * @dev Searches a sorted `array` and returns the first index that contains
491      * a value greater or equal to `element`. If no such index exists (i.e. all
492      * values in the array are strictly less than `element`), the array length is
493      * returned. Time complexity O(log n).
494      *
495      * `array` is expected to be sorted in ascending order, and to contain no
496      * repeated elements.
497      */
498     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
499         if (array.length == 0) {
500             return 0;
501         }
502 
503         uint256 low = 0;
504         uint256 high = array.length;
505 
506         while (low < high) {
507             uint256 mid = Math.average(low, high);
508 
509             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
510             // because Math.average rounds down (it does integer division with truncation).
511             if (array[mid] > element) {
512                 high = mid;
513             } else {
514                 low = mid + 1;
515             }
516         }
517 
518         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
519         if (low > 0 && array[low - 1] == element) {
520             return low - 1;
521         } else {
522             return low;
523         }
524     }
525 }
526 
527 // File: @openzeppelin/contracts@4.3.2/utils/Context.sol
528 
529 
530 
531 pragma solidity ^0.8.0;
532 
533 /**
534  * @dev Provides information about the current execution context, including the
535  * sender of the transaction and its data. While these are generally available
536  * via msg.sender and msg.data, they should not be accessed in such a direct
537  * manner, since when dealing with meta-transactions the account sending and
538  * paying for execution may not be the actual sender (as far as an application
539  * is concerned).
540  *
541  * This contract is only required for intermediate, library-like contracts.
542  */
543 abstract contract Context {
544     function _msgSender() internal view virtual returns (address) {
545         return msg.sender;
546     }
547 
548     function _msgData() internal view virtual returns (bytes calldata) {
549         return msg.data;
550     }
551 }
552 
553 // File: @openzeppelin/contracts@4.3.2/security/Pausable.sol
554 
555 
556 
557 pragma solidity ^0.8.0;
558 
559 
560 /**
561  * @dev Contract module which allows children to implement an emergency stop
562  * mechanism that can be triggered by an authorized account.
563  *
564  * This module is used through inheritance. It will make available the
565  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
566  * the functions of your contract. Note that they will not be pausable by
567  * simply including this module, only once the modifiers are put in place.
568  */
569 abstract contract Pausable is Context {
570     /**
571      * @dev Emitted when the pause is triggered by `account`.
572      */
573     event Paused(address account);
574 
575     /**
576      * @dev Emitted when the pause is lifted by `account`.
577      */
578     event Unpaused(address account);
579 
580     bool private _paused;
581 
582     /**
583      * @dev Initializes the contract in unpaused state.
584      */
585     constructor() {
586         _paused = false;
587     }
588 
589     /**
590      * @dev Returns true if the contract is paused, and false otherwise.
591      */
592     function paused() public view virtual returns (bool) {
593         return _paused;
594     }
595 
596     /**
597      * @dev Modifier to make a function callable only when the contract is not paused.
598      *
599      * Requirements:
600      *
601      * - The contract must not be paused.
602      */
603     modifier whenNotPaused() {
604         require(!paused(), "Pausable: paused");
605         _;
606     }
607 
608     /**
609      * @dev Modifier to make a function callable only when the contract is paused.
610      *
611      * Requirements:
612      *
613      * - The contract must be paused.
614      */
615     modifier whenPaused() {
616         require(paused(), "Pausable: not paused");
617         _;
618     }
619 
620     /**
621      * @dev Triggers stopped state.
622      *
623      * Requirements:
624      *
625      * - The contract must not be paused.
626      */
627     function _pause() internal virtual whenNotPaused {
628         _paused = true;
629         emit Paused(_msgSender());
630     }
631 
632     /**
633      * @dev Returns to normal state.
634      *
635      * Requirements:
636      *
637      * - The contract must be paused.
638      */
639     function _unpause() internal virtual whenPaused {
640         _paused = false;
641         emit Unpaused(_msgSender());
642     }
643 }
644 
645 // File: @openzeppelin/contracts@4.3.2/access/Ownable.sol
646 
647 
648 
649 pragma solidity ^0.8.0;
650 
651 
652 /**
653  * @dev Contract module which provides a basic access control mechanism, where
654  * there is an account (an owner) that can be granted exclusive access to
655  * specific functions.
656  *
657  * By default, the owner account will be the one that deploys the contract. This
658  * can later be changed with {transferOwnership}.
659  *
660  * This module is used through inheritance. It will make available the modifier
661  * `onlyOwner`, which can be applied to your functions to restrict their use to
662  * the owner.
663  */
664 abstract contract Ownable is Context {
665     address private _owner;
666 
667     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
668 
669     /**
670      * @dev Initializes the contract setting the deployer as the initial owner.
671      */
672     constructor() {
673         _setOwner(_msgSender());
674     }
675 
676     /**
677      * @dev Returns the address of the current owner.
678      */
679     function owner() public view virtual returns (address) {
680         return _owner;
681     }
682 
683     /**
684      * @dev Throws if called by any account other than the owner.
685      */
686     modifier onlyOwner() {
687         require(owner() == _msgSender(), "Ownable: caller is not the owner");
688         _;
689     }
690 
691     /**
692      * @dev Leaves the contract without owner. It will not be possible to call
693      * `onlyOwner` functions anymore. Can only be called by the current owner.
694      *
695      * NOTE: Renouncing ownership will leave the contract without an owner,
696      * thereby removing any functionality that is only available to the owner.
697      */
698     function renounceOwnership() public virtual onlyOwner {
699         _setOwner(address(0));
700     }
701 
702     /**
703      * @dev Transfers ownership of the contract to a new account (`newOwner`).
704      * Can only be called by the current owner.
705      */
706     function transferOwnership(address newOwner) public virtual onlyOwner {
707         require(newOwner != address(0), "Ownable: new owner is the zero address");
708         _setOwner(newOwner);
709     }
710 
711     function _setOwner(address newOwner) private {
712         address oldOwner = _owner;
713         _owner = newOwner;
714         emit OwnershipTransferred(oldOwner, newOwner);
715     }
716 }
717 
718 // File: @openzeppelin/contracts@4.3.2/token/ERC20/IERC20.sol
719 
720 
721 
722 pragma solidity ^0.8.0;
723 
724 /**
725  * @dev Interface of the ERC20 standard as defined in the EIP.
726  */
727 interface IERC20 {
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
739      * @dev Moves `amount` tokens from the caller's account to `recipient`.
740      *
741      * Returns a boolean value indicating whether the operation succeeded.
742      *
743      * Emits a {Transfer} event.
744      */
745     function transfer(address recipient, uint256 amount) external returns (bool);
746 
747     /**
748      * @dev Returns the remaining number of tokens that `spender` will be
749      * allowed to spend on behalf of `owner` through {transferFrom}. This is
750      * zero by default.
751      *
752      * This value changes when {approve} or {transferFrom} are called.
753      */
754     function allowance(address owner, address spender) external view returns (uint256);
755 
756     /**
757      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
758      *
759      * Returns a boolean value indicating whether the operation succeeded.
760      *
761      * IMPORTANT: Beware that changing an allowance with this method brings the risk
762      * that someone may use both the old and the new allowance by unfortunate
763      * transaction ordering. One possible solution to mitigate this race
764      * condition is to first reduce the spender's allowance to 0 and set the
765      * desired value afterwards:
766      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
767      *
768      * Emits an {Approval} event.
769      */
770     function approve(address spender, uint256 amount) external returns (bool);
771 
772     /**
773      * @dev Moves `amount` tokens from `sender` to `recipient` using the
774      * allowance mechanism. `amount` is then deducted from the caller's
775      * allowance.
776      *
777      * Returns a boolean value indicating whether the operation succeeded.
778      *
779      * Emits a {Transfer} event.
780      */
781     function transferFrom(
782         address sender,
783         address recipient,
784         uint256 amount
785     ) external returns (bool);
786 
787     /**
788      * @dev Emitted when `value` tokens are moved from one account (`from`) to
789      * another (`to`).
790      *
791      * Note that `value` may be zero.
792      */
793     event Transfer(address indexed from, address indexed to, uint256 value);
794 
795     /**
796      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
797      * a call to {approve}. `value` is the new allowance.
798      */
799     event Approval(address indexed owner, address indexed spender, uint256 value);
800 }
801 
802 // File: @openzeppelin/contracts@4.3.2/token/ERC20/extensions/IERC20Metadata.sol
803 
804 
805 
806 pragma solidity ^0.8.0;
807 
808 
809 /**
810  * @dev Interface for the optional metadata functions from the ERC20 standard.
811  *
812  * _Available since v4.1._
813  */
814 interface IERC20Metadata is IERC20 {
815     /**
816      * @dev Returns the name of the token.
817      */
818     function name() external view returns (string memory);
819 
820     /**
821      * @dev Returns the symbol of the token.
822      */
823     function symbol() external view returns (string memory);
824 
825     /**
826      * @dev Returns the decimals places of the token.
827      */
828     function decimals() external view returns (uint8);
829 }
830 
831 // File: @openzeppelin/contracts@4.3.2/token/ERC20/ERC20.sol
832 
833 
834 
835 pragma solidity ^0.8.0;
836 
837 
838 
839 
840 /**
841  * @dev Implementation of the {IERC20} interface.
842  *
843  * This implementation is agnostic to the way tokens are created. This means
844  * that a supply mechanism has to be added in a derived contract using {_mint}.
845  * For a generic mechanism see {ERC20PresetMinterPauser}.
846  *
847  * TIP: For a detailed writeup see our guide
848  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
849  * to implement supply mechanisms].
850  *
851  * We have followed general OpenZeppelin Contracts guidelines: functions revert
852  * instead returning `false` on failure. This behavior is nonetheless
853  * conventional and does not conflict with the expectations of ERC20
854  * applications.
855  *
856  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
857  * This allows applications to reconstruct the allowance for all accounts just
858  * by listening to said events. Other implementations of the EIP may not emit
859  * these events, as it isn't required by the specification.
860  *
861  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
862  * functions have been added to mitigate the well-known issues around setting
863  * allowances. See {IERC20-approve}.
864  */
865 contract ERC20 is Context, IERC20, IERC20Metadata {
866     mapping(address => uint256) private _balances;
867 
868     mapping(address => mapping(address => uint256)) private _allowances;
869 
870     uint256 private _totalSupply;
871 
872     string private _name;
873     string private _symbol;
874 
875     /**
876      * @dev Sets the values for {name} and {symbol}.
877      *
878      * The default value of {decimals} is 18. To select a different value for
879      * {decimals} you should overload it.
880      *
881      * All two of these values are immutable: they can only be set once during
882      * construction.
883      */
884     constructor(string memory name_, string memory symbol_) {
885         _name = name_;
886         _symbol = symbol_;
887     }
888 
889     /**
890      * @dev Returns the name of the token.
891      */
892     function name() public view virtual override returns (string memory) {
893         return _name;
894     }
895 
896     /**
897      * @dev Returns the symbol of the token, usually a shorter version of the
898      * name.
899      */
900     function symbol() public view virtual override returns (string memory) {
901         return _symbol;
902     }
903 
904     /**
905      * @dev Returns the number of decimals used to get its user representation.
906      * For example, if `decimals` equals `2`, a balance of `505` tokens should
907      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
908      *
909      * Tokens usually opt for a value of 18, imitating the relationship between
910      * Ether and Wei. This is the value {ERC20} uses, unless this function is
911      * overridden;
912      *
913      * NOTE: This information is only used for _display_ purposes: it in
914      * no way affects any of the arithmetic of the contract, including
915      * {IERC20-balanceOf} and {IERC20-transfer}.
916      */
917     function decimals() public view virtual override returns (uint8) {
918         return 18;
919     }
920 
921     /**
922      * @dev See {IERC20-totalSupply}.
923      */
924     function totalSupply() public view virtual override returns (uint256) {
925         return _totalSupply;
926     }
927 
928     /**
929      * @dev See {IERC20-balanceOf}.
930      */
931     function balanceOf(address account) public view virtual override returns (uint256) {
932         return _balances[account];
933     }
934 
935     /**
936      * @dev See {IERC20-transfer}.
937      *
938      * Requirements:
939      *
940      * - `recipient` cannot be the zero address.
941      * - the caller must have a balance of at least `amount`.
942      */
943     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
944         _transfer(_msgSender(), recipient, amount);
945         return true;
946     }
947 
948     /**
949      * @dev See {IERC20-allowance}.
950      */
951     function allowance(address owner, address spender) public view virtual override returns (uint256) {
952         return _allowances[owner][spender];
953     }
954 
955     /**
956      * @dev See {IERC20-approve}.
957      *
958      * Requirements:
959      *
960      * - `spender` cannot be the zero address.
961      */
962     function approve(address spender, uint256 amount) public virtual override returns (bool) {
963         _approve(_msgSender(), spender, amount);
964         return true;
965     }
966 
967     /**
968      * @dev See {IERC20-transferFrom}.
969      *
970      * Emits an {Approval} event indicating the updated allowance. This is not
971      * required by the EIP. See the note at the beginning of {ERC20}.
972      *
973      * Requirements:
974      *
975      * - `sender` and `recipient` cannot be the zero address.
976      * - `sender` must have a balance of at least `amount`.
977      * - the caller must have allowance for ``sender``'s tokens of at least
978      * `amount`.
979      */
980     function transferFrom(
981         address sender,
982         address recipient,
983         uint256 amount
984     ) public virtual override returns (bool) {
985         _transfer(sender, recipient, amount);
986 
987         uint256 currentAllowance = _allowances[sender][_msgSender()];
988         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
989         unchecked {
990             _approve(sender, _msgSender(), currentAllowance - amount);
991         }
992 
993         return true;
994     }
995 
996     /**
997      * @dev Atomically increases the allowance granted to `spender` by the caller.
998      *
999      * This is an alternative to {approve} that can be used as a mitigation for
1000      * problems described in {IERC20-approve}.
1001      *
1002      * Emits an {Approval} event indicating the updated allowance.
1003      *
1004      * Requirements:
1005      *
1006      * - `spender` cannot be the zero address.
1007      */
1008     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1009         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
1010         return true;
1011     }
1012 
1013     /**
1014      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1015      *
1016      * This is an alternative to {approve} that can be used as a mitigation for
1017      * problems described in {IERC20-approve}.
1018      *
1019      * Emits an {Approval} event indicating the updated allowance.
1020      *
1021      * Requirements:
1022      *
1023      * - `spender` cannot be the zero address.
1024      * - `spender` must have allowance for the caller of at least
1025      * `subtractedValue`.
1026      */
1027     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1028         uint256 currentAllowance = _allowances[_msgSender()][spender];
1029         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1030         unchecked {
1031             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
1032         }
1033 
1034         return true;
1035     }
1036 
1037     /**
1038      * @dev Moves `amount` of tokens from `sender` to `recipient`.
1039      *
1040      * This internal function is equivalent to {transfer}, and can be used to
1041      * e.g. implement automatic token fees, slashing mechanisms, etc.
1042      *
1043      * Emits a {Transfer} event.
1044      *
1045      * Requirements:
1046      *
1047      * - `sender` cannot be the zero address.
1048      * - `recipient` cannot be the zero address.
1049      * - `sender` must have a balance of at least `amount`.
1050      */
1051     function _transfer(
1052         address sender,
1053         address recipient,
1054         uint256 amount
1055     ) internal virtual {
1056         require(sender != address(0), "ERC20: transfer from the zero address");
1057         require(recipient != address(0), "ERC20: transfer to the zero address");
1058 
1059         _beforeTokenTransfer(sender, recipient, amount);
1060 
1061         uint256 senderBalance = _balances[sender];
1062         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
1063         unchecked {
1064             _balances[sender] = senderBalance - amount;
1065         }
1066         _balances[recipient] += amount;
1067 
1068         emit Transfer(sender, recipient, amount);
1069 
1070         _afterTokenTransfer(sender, recipient, amount);
1071     }
1072 
1073     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1074      * the total supply.
1075      *
1076      * Emits a {Transfer} event with `from` set to the zero address.
1077      *
1078      * Requirements:
1079      *
1080      * - `account` cannot be the zero address.
1081      */
1082     function _mint(address account, uint256 amount) internal virtual {
1083         require(account != address(0), "ERC20: mint to the zero address");
1084 
1085         _beforeTokenTransfer(address(0), account, amount);
1086 
1087         _totalSupply += amount;
1088         _balances[account] += amount;
1089         emit Transfer(address(0), account, amount);
1090 
1091         _afterTokenTransfer(address(0), account, amount);
1092     }
1093 
1094     /**
1095      * @dev Destroys `amount` tokens from `account`, reducing the
1096      * total supply.
1097      *
1098      * Emits a {Transfer} event with `to` set to the zero address.
1099      *
1100      * Requirements:
1101      *
1102      * - `account` cannot be the zero address.
1103      * - `account` must have at least `amount` tokens.
1104      */
1105     function _burn(address account, uint256 amount) internal virtual {
1106         require(account != address(0), "ERC20: burn from the zero address");
1107 
1108         _beforeTokenTransfer(account, address(0), amount);
1109 
1110         uint256 accountBalance = _balances[account];
1111         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1112         unchecked {
1113             _balances[account] = accountBalance - amount;
1114         }
1115         _totalSupply -= amount;
1116 
1117         emit Transfer(account, address(0), amount);
1118 
1119         _afterTokenTransfer(account, address(0), amount);
1120     }
1121 
1122     /**
1123      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1124      *
1125      * This internal function is equivalent to `approve`, and can be used to
1126      * e.g. set automatic allowances for certain subsystems, etc.
1127      *
1128      * Emits an {Approval} event.
1129      *
1130      * Requirements:
1131      *
1132      * - `owner` cannot be the zero address.
1133      * - `spender` cannot be the zero address.
1134      */
1135     function _approve(
1136         address owner,
1137         address spender,
1138         uint256 amount
1139     ) internal virtual {
1140         require(owner != address(0), "ERC20: approve from the zero address");
1141         require(spender != address(0), "ERC20: approve to the zero address");
1142 
1143         _allowances[owner][spender] = amount;
1144         emit Approval(owner, spender, amount);
1145     }
1146 
1147     /**
1148      * @dev Hook that is called before any transfer of tokens. This includes
1149      * minting and burning.
1150      *
1151      * Calling conditions:
1152      *
1153      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1154      * will be transferred to `to`.
1155      * - when `from` is zero, `amount` tokens will be minted for `to`.
1156      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1157      * - `from` and `to` are never both zero.
1158      *
1159      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1160      */
1161     function _beforeTokenTransfer(
1162         address from,
1163         address to,
1164         uint256 amount
1165     ) internal virtual {}
1166 
1167     /**
1168      * @dev Hook that is called after any transfer of tokens. This includes
1169      * minting and burning.
1170      *
1171      * Calling conditions:
1172      *
1173      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1174      * has been transferred to `to`.
1175      * - when `from` is zero, `amount` tokens have been minted for `to`.
1176      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1177      * - `from` and `to` are never both zero.
1178      *
1179      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1180      */
1181     function _afterTokenTransfer(
1182         address from,
1183         address to,
1184         uint256 amount
1185     ) internal virtual {}
1186 }
1187 
1188 // File: @openzeppelin/contracts@4.3.2/token/ERC20/extensions/draft-ERC20Permit.sol
1189 
1190 
1191 
1192 pragma solidity ^0.8.0;
1193 
1194 
1195 
1196 
1197 
1198 
1199 /**
1200  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1201  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1202  *
1203  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1204  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1205  * need to send a transaction, and thus is not required to hold Ether at all.
1206  *
1207  * _Available since v3.4._
1208  */
1209 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
1210     using Counters for Counters.Counter;
1211 
1212     mapping(address => Counters.Counter) private _nonces;
1213 
1214     // solhint-disable-next-line var-name-mixedcase
1215     bytes32 private immutable _PERMIT_TYPEHASH =
1216         keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1217 
1218     /**
1219      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
1220      *
1221      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
1222      */
1223     constructor(string memory name) EIP712(name, "1") {}
1224 
1225     /**
1226      * @dev See {IERC20Permit-permit}.
1227      */
1228     function permit(
1229         address owner,
1230         address spender,
1231         uint256 value,
1232         uint256 deadline,
1233         uint8 v,
1234         bytes32 r,
1235         bytes32 s
1236     ) public virtual override {
1237         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
1238 
1239         bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
1240 
1241         bytes32 hash = _hashTypedDataV4(structHash);
1242 
1243         address signer = ECDSA.recover(hash, v, r, s);
1244         require(signer == owner, "ERC20Permit: invalid signature");
1245 
1246         _approve(owner, spender, value);
1247     }
1248 
1249     /**
1250      * @dev See {IERC20Permit-nonces}.
1251      */
1252     function nonces(address owner) public view virtual override returns (uint256) {
1253         return _nonces[owner].current();
1254     }
1255 
1256     /**
1257      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
1258      */
1259     // solhint-disable-next-line func-name-mixedcase
1260     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
1261         return _domainSeparatorV4();
1262     }
1263 
1264     /**
1265      * @dev "Consume a nonce": return the current value and increment.
1266      *
1267      * _Available since v4.1._
1268      */
1269     function _useNonce(address owner) internal virtual returns (uint256 current) {
1270         Counters.Counter storage nonce = _nonces[owner];
1271         current = nonce.current();
1272         nonce.increment();
1273     }
1274 }
1275 
1276 // File: @openzeppelin/contracts@4.3.2/token/ERC20/extensions/ERC20Snapshot.sol
1277 
1278 
1279 
1280 pragma solidity ^0.8.0;
1281 
1282 
1283 
1284 
1285 /**
1286  * @dev This contract extends an ERC20 token with a snapshot mechanism. When a snapshot is created, the balances and
1287  * total supply at the time are recorded for later access.
1288  *
1289  * This can be used to safely create mechanisms based on token balances such as trustless dividends or weighted voting.
1290  * In naive implementations it's possible to perform a "double spend" attack by reusing the same balance from different
1291  * accounts. By using snapshots to calculate dividends or voting power, those attacks no longer apply. It can also be
1292  * used to create an efficient ERC20 forking mechanism.
1293  *
1294  * Snapshots are created by the internal {_snapshot} function, which will emit the {Snapshot} event and return a
1295  * snapshot id. To get the total supply at the time of a snapshot, call the function {totalSupplyAt} with the snapshot
1296  * id. To get the balance of an account at the time of a snapshot, call the {balanceOfAt} function with the snapshot id
1297  * and the account address.
1298  *
1299  * NOTE: Snapshot policy can be customized by overriding the {_getCurrentSnapshotId} method. For example, having it
1300  * return `block.number` will trigger the creation of snapshot at the begining of each new block. When overridding this
1301  * function, be careful about the monotonicity of its result. Non-monotonic snapshot ids will break the contract.
1302  *
1303  * Implementing snapshots for every block using this method will incur significant gas costs. For a gas-efficient
1304  * alternative consider {ERC20Votes}.
1305  *
1306  * ==== Gas Costs
1307  *
1308  * Snapshots are efficient. Snapshot creation is _O(1)_. Retrieval of balances or total supply from a snapshot is _O(log
1309  * n)_ in the number of snapshots that have been created, although _n_ for a specific account will generally be much
1310  * smaller since identical balances in subsequent snapshots are stored as a single entry.
1311  *
1312  * There is a constant overhead for normal ERC20 transfers due to the additional snapshot bookkeeping. This overhead is
1313  * only significant for the first transfer that immediately follows a snapshot for a particular account. Subsequent
1314  * transfers will have normal cost until the next snapshot, and so on.
1315  */
1316 
1317 abstract contract ERC20Snapshot is ERC20 {
1318     // Inspired by Jordi Baylina's MiniMeToken to record historical balances:
1319     // https://github.com/Giveth/minimd/blob/ea04d950eea153a04c51fa510b068b9dded390cb/contracts/MiniMeToken.sol
1320 
1321     using Arrays for uint256[];
1322     using Counters for Counters.Counter;
1323 
1324     // Snapshotted values have arrays of ids and the value corresponding to that id. These could be an array of a
1325     // Snapshot struct, but that would impede usage of functions that work on an array.
1326     struct Snapshots {
1327         uint256[] ids;
1328         uint256[] values;
1329     }
1330 
1331     mapping(address => Snapshots) private _accountBalanceSnapshots;
1332     Snapshots private _totalSupplySnapshots;
1333 
1334     // Snapshot ids increase monotonically, with the first value being 1. An id of 0 is invalid.
1335     Counters.Counter private _currentSnapshotId;
1336 
1337     /**
1338      * @dev Emitted by {_snapshot} when a snapshot identified by `id` is created.
1339      */
1340     event Snapshot(uint256 id);
1341 
1342     /**
1343      * @dev Creates a new snapshot and returns its snapshot id.
1344      *
1345      * Emits a {Snapshot} event that contains the same id.
1346      *
1347      * {_snapshot} is `internal` and you have to decide how to expose it externally. Its usage may be restricted to a
1348      * set of accounts, for example using {AccessControl}, or it may be open to the public.
1349      *
1350      * [WARNING]
1351      * ====
1352      * While an open way of calling {_snapshot} is required for certain trust minimization mechanisms such as forking,
1353      * you must consider that it can potentially be used by attackers in two ways.
1354      *
1355      * First, it can be used to increase the cost of retrieval of values from snapshots, although it will grow
1356      * logarithmically thus rendering this attack ineffective in the long term. Second, it can be used to target
1357      * specific accounts and increase the cost of ERC20 transfers for them, in the ways specified in the Gas Costs
1358      * section above.
1359      *
1360      * We haven't measured the actual numbers; if this is something you're interested in please reach out to us.
1361      * ====
1362      */
1363     function _snapshot() internal virtual returns (uint256) {
1364         _currentSnapshotId.increment();
1365 
1366         uint256 currentId = _getCurrentSnapshotId();
1367         emit Snapshot(currentId);
1368         return currentId;
1369     }
1370 
1371     /**
1372      * @dev Get the current snapshotId
1373      */
1374     function _getCurrentSnapshotId() internal view virtual returns (uint256) {
1375         return _currentSnapshotId.current();
1376     }
1377 
1378     /**
1379      * @dev Retrieves the balance of `account` at the time `snapshotId` was created.
1380      */
1381     function balanceOfAt(address account, uint256 snapshotId) public view virtual returns (uint256) {
1382         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);
1383 
1384         return snapshotted ? value : balanceOf(account);
1385     }
1386 
1387     /**
1388      * @dev Retrieves the total supply at the time `snapshotId` was created.
1389      */
1390     function totalSupplyAt(uint256 snapshotId) public view virtual returns (uint256) {
1391         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnapshots);
1392 
1393         return snapshotted ? value : totalSupply();
1394     }
1395 
1396     // Update balance and/or total supply snapshots before the values are modified. This is implemented
1397     // in the _beforeTokenTransfer hook, which is executed for _mint, _burn, and _transfer operations.
1398     function _beforeTokenTransfer(
1399         address from,
1400         address to,
1401         uint256 amount
1402     ) internal virtual override {
1403         super._beforeTokenTransfer(from, to, amount);
1404 
1405         if (from == address(0)) {
1406             // mint
1407             _updateAccountSnapshot(to);
1408             _updateTotalSupplySnapshot();
1409         } else if (to == address(0)) {
1410             // burn
1411             _updateAccountSnapshot(from);
1412             _updateTotalSupplySnapshot();
1413         } else {
1414             // transfer
1415             _updateAccountSnapshot(from);
1416             _updateAccountSnapshot(to);
1417         }
1418     }
1419 
1420     function _valueAt(uint256 snapshotId, Snapshots storage snapshots) private view returns (bool, uint256) {
1421         require(snapshotId > 0, "ERC20Snapshot: id is 0");
1422         require(snapshotId <= _getCurrentSnapshotId(), "ERC20Snapshot: nonexistent id");
1423 
1424         // When a valid snapshot is queried, there are three possibilities:
1425         //  a) The queried value was not modified after the snapshot was taken. Therefore, a snapshot entry was never
1426         //  created for this id, and all stored snapshot ids are smaller than the requested one. The value that corresponds
1427         //  to this id is the current one.
1428         //  b) The queried value was modified after the snapshot was taken. Therefore, there will be an entry with the
1429         //  requested id, and its value is the one to return.
1430         //  c) More snapshots were created after the requested one, and the queried value was later modified. There will be
1431         //  no entry for the requested id: the value that corresponds to it is that of the smallest snapshot id that is
1432         //  larger than the requested one.
1433         //
1434         // In summary, we need to find an element in an array, returning the index of the smallest value that is larger if
1435         // it is not found, unless said value doesn't exist (e.g. when all values are smaller). Arrays.findUpperBound does
1436         // exactly this.
1437 
1438         uint256 index = snapshots.ids.findUpperBound(snapshotId);
1439 
1440         if (index == snapshots.ids.length) {
1441             return (false, 0);
1442         } else {
1443             return (true, snapshots.values[index]);
1444         }
1445     }
1446 
1447     function _updateAccountSnapshot(address account) private {
1448         _updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));
1449     }
1450 
1451     function _updateTotalSupplySnapshot() private {
1452         _updateSnapshot(_totalSupplySnapshots, totalSupply());
1453     }
1454 
1455     function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {
1456         uint256 currentId = _getCurrentSnapshotId();
1457         if (_lastSnapshotId(snapshots.ids) < currentId) {
1458             snapshots.ids.push(currentId);
1459             snapshots.values.push(currentValue);
1460         }
1461     }
1462 
1463     function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {
1464         if (ids.length == 0) {
1465             return 0;
1466         } else {
1467             return ids[ids.length - 1];
1468         }
1469     }
1470 }
1471 
1472 // File: @openzeppelin/contracts@4.3.2/token/ERC20/extensions/ERC20Burnable.sol
1473 
1474 
1475 
1476 pragma solidity ^0.8.0;
1477 
1478 
1479 
1480 /**
1481  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1482  * tokens and those that they have an allowance for, in a way that can be
1483  * recognized off-chain (via event analysis).
1484  */
1485 abstract contract ERC20Burnable is Context, ERC20 {
1486     /**
1487      * @dev Destroys `amount` tokens from the caller.
1488      *
1489      * See {ERC20-_burn}.
1490      */
1491     function burn(uint256 amount) public virtual {
1492         _burn(_msgSender(), amount);
1493     }
1494 
1495     /**
1496      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1497      * allowance.
1498      *
1499      * See {ERC20-_burn} and {ERC20-allowance}.
1500      *
1501      * Requirements:
1502      *
1503      * - the caller must have allowance for ``accounts``'s tokens of at least
1504      * `amount`.
1505      */
1506     function burnFrom(address account, uint256 amount) public virtual {
1507         uint256 currentAllowance = allowance(account, _msgSender());
1508         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
1509         unchecked {
1510             _approve(account, _msgSender(), currentAllowance - amount);
1511         }
1512         _burn(account, amount);
1513     }
1514 }
1515 
1516 // File: NTH.sol
1517 
1518 
1519 pragma solidity ^0.8.0;
1520 
1521 
1522 
1523 
1524 
1525 
1526 
1527 contract NTH is ERC20, ERC20Burnable, ERC20Snapshot, Ownable, Pausable, ERC20Permit {
1528     constructor() ERC20("NTH", "NTH") ERC20Permit("NTH") {
1529         _mint(msg.sender, 1000000000 * 10 ** decimals());
1530     }
1531 
1532     function snapshot() public onlyOwner {
1533         _snapshot();
1534     }
1535 
1536     function pause() public onlyOwner {
1537         _pause();
1538     }
1539 
1540     function unpause() public onlyOwner {
1541         _unpause();
1542     }
1543 
1544     function mint(address to, uint256 amount) public onlyOwner {
1545         _mint(to, amount);
1546     }
1547 
1548     function _beforeTokenTransfer(address from, address to, uint256 amount)
1549         internal
1550         whenNotPaused
1551         override(ERC20, ERC20Snapshot)
1552     {
1553         super._beforeTokenTransfer(from, to, amount);
1554     }
1555 }