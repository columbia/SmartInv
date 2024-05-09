1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Returns the amount of tokens in existence.
14      */
15     function totalSupply() external view returns (uint256);
16 
17     /**
18      * @dev Returns the amount of tokens owned by `account`.
19      */
20     function balanceOf(address account) external view returns (uint256);
21 
22     /**
23      * @dev Moves `amount` tokens from the caller's account to `recipient`.
24      *
25      * Returns a boolean value indicating whether the operation succeeded.
26      *
27      * Emits a {Transfer} event.
28      */
29     function transfer(address recipient, uint256 amount) external returns (bool);
30 
31     /**
32      * @dev Returns the remaining number of tokens that `spender` will be
33      * allowed to spend on behalf of `owner` through {transferFrom}. This is
34      * zero by default.
35      *
36      * This value changes when {approve} or {transferFrom} are called.
37      */
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     /**
41      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * IMPORTANT: Beware that changing an allowance with this method brings the risk
46      * that someone may use both the old and the new allowance by unfortunate
47      * transaction ordering. One possible solution to mitigate this race
48      * condition is to first reduce the spender's allowance to 0 and set the
49      * desired value afterwards:
50      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51      *
52      * Emits an {Approval} event.
53      */
54     function approve(address spender, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Moves `amount` tokens from `sender` to `recipient` using the
58      * allowance mechanism. `amount` is then deducted from the caller's
59      * allowance.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transferFrom(
66         address sender,
67         address recipient,
68         uint256 amount
69     ) external returns (bool);
70 
71     /**
72      * @dev Emitted when `value` tokens are moved from one account (`from`) to
73      * another (`to`).
74      *
75      * Note that `value` may be zero.
76      */
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     /**
80      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
81      * a call to {approve}. `value` is the new allowance.
82      */
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 // File: @openzeppelin/contracts/utils/Strings.sol
87 
88 
89 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
90 
91 pragma solidity ^0.8.0;
92 
93 /**
94  * @dev String operations.
95  */
96 library Strings {
97     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
98 
99     /**
100      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
101      */
102     function toString(uint256 value) internal pure returns (string memory) {
103         // Inspired by OraclizeAPI's implementation - MIT licence
104         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
105 
106         if (value == 0) {
107             return "0";
108         }
109         uint256 temp = value;
110         uint256 digits;
111         while (temp != 0) {
112             digits++;
113             temp /= 10;
114         }
115         bytes memory buffer = new bytes(digits);
116         while (value != 0) {
117             digits -= 1;
118             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
119             value /= 10;
120         }
121         return string(buffer);
122     }
123 
124     /**
125      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
126      */
127     function toHexString(uint256 value) internal pure returns (string memory) {
128         if (value == 0) {
129             return "0x00";
130         }
131         uint256 temp = value;
132         uint256 length = 0;
133         while (temp != 0) {
134             length++;
135             temp >>= 8;
136         }
137         return toHexString(value, length);
138     }
139 
140     /**
141      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
142      */
143     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
144         bytes memory buffer = new bytes(2 * length + 2);
145         buffer[0] = "0";
146         buffer[1] = "x";
147         for (uint256 i = 2 * length + 1; i > 1; --i) {
148             buffer[i] = _HEX_SYMBOLS[value & 0xf];
149             value >>= 4;
150         }
151         require(value == 0, "Strings: hex length insufficient");
152         return string(buffer);
153     }
154 }
155 
156 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
157 
158 
159 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
160 
161 pragma solidity ^0.8.0;
162 
163 
164 /**
165  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
166  *
167  * These functions can be used to verify that a message was signed by the holder
168  * of the private keys of a given address.
169  */
170 library ECDSA {
171     enum RecoverError {
172         NoError,
173         InvalidSignature,
174         InvalidSignatureLength,
175         InvalidSignatureS,
176         InvalidSignatureV
177     }
178 
179     function _throwError(RecoverError error) private pure {
180         if (error == RecoverError.NoError) {
181             return; // no error: do nothing
182         } else if (error == RecoverError.InvalidSignature) {
183             revert("ECDSA: invalid signature");
184         } else if (error == RecoverError.InvalidSignatureLength) {
185             revert("ECDSA: invalid signature length");
186         } else if (error == RecoverError.InvalidSignatureS) {
187             revert("ECDSA: invalid signature 's' value");
188         } else if (error == RecoverError.InvalidSignatureV) {
189             revert("ECDSA: invalid signature 'v' value");
190         }
191     }
192 
193     /**
194      * @dev Returns the address that signed a hashed message (`hash`) with
195      * `signature` or error string. This address can then be used for verification purposes.
196      *
197      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
198      * this function rejects them by requiring the `s` value to be in the lower
199      * half order, and the `v` value to be either 27 or 28.
200      *
201      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
202      * verification to be secure: it is possible to craft signatures that
203      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
204      * this is by receiving a hash of the original message (which may otherwise
205      * be too long), and then calling {toEthSignedMessageHash} on it.
206      *
207      * Documentation for signature generation:
208      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
209      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
210      *
211      * _Available since v4.3._
212      */
213     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
214         // Check the signature length
215         // - case 65: r,s,v signature (standard)
216         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
217         if (signature.length == 65) {
218             bytes32 r;
219             bytes32 s;
220             uint8 v;
221             // ecrecover takes the signature parameters, and the only way to get them
222             // currently is to use assembly.
223             assembly {
224                 r := mload(add(signature, 0x20))
225                 s := mload(add(signature, 0x40))
226                 v := byte(0, mload(add(signature, 0x60)))
227             }
228             return tryRecover(hash, v, r, s);
229         } else if (signature.length == 64) {
230             bytes32 r;
231             bytes32 vs;
232             // ecrecover takes the signature parameters, and the only way to get them
233             // currently is to use assembly.
234             assembly {
235                 r := mload(add(signature, 0x20))
236                 vs := mload(add(signature, 0x40))
237             }
238             return tryRecover(hash, r, vs);
239         } else {
240             return (address(0), RecoverError.InvalidSignatureLength);
241         }
242     }
243 
244     /**
245      * @dev Returns the address that signed a hashed message (`hash`) with
246      * `signature`. This address can then be used for verification purposes.
247      *
248      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
249      * this function rejects them by requiring the `s` value to be in the lower
250      * half order, and the `v` value to be either 27 or 28.
251      *
252      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
253      * verification to be secure: it is possible to craft signatures that
254      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
255      * this is by receiving a hash of the original message (which may otherwise
256      * be too long), and then calling {toEthSignedMessageHash} on it.
257      */
258     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
259         (address recovered, RecoverError error) = tryRecover(hash, signature);
260         _throwError(error);
261         return recovered;
262     }
263 
264     /**
265      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
266      *
267      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
268      *
269      * _Available since v4.3._
270      */
271     function tryRecover(
272         bytes32 hash,
273         bytes32 r,
274         bytes32 vs
275     ) internal pure returns (address, RecoverError) {
276         bytes32 s;
277         uint8 v;
278         assembly {
279             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
280             v := add(shr(255, vs), 27)
281         }
282         return tryRecover(hash, v, r, s);
283     }
284 
285     /**
286      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
287      *
288      * _Available since v4.2._
289      */
290     function recover(
291         bytes32 hash,
292         bytes32 r,
293         bytes32 vs
294     ) internal pure returns (address) {
295         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
296         _throwError(error);
297         return recovered;
298     }
299 
300     /**
301      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
302      * `r` and `s` signature fields separately.
303      *
304      * _Available since v4.3._
305      */
306     function tryRecover(
307         bytes32 hash,
308         uint8 v,
309         bytes32 r,
310         bytes32 s
311     ) internal pure returns (address, RecoverError) {
312         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
313         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
314         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
315         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
316         //
317         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
318         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
319         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
320         // these malleable signatures as well.
321         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
322             return (address(0), RecoverError.InvalidSignatureS);
323         }
324         if (v != 27 && v != 28) {
325             return (address(0), RecoverError.InvalidSignatureV);
326         }
327 
328         // If the signature is valid (and not malleable), return the signer address
329         address signer = ecrecover(hash, v, r, s);
330         if (signer == address(0)) {
331             return (address(0), RecoverError.InvalidSignature);
332         }
333 
334         return (signer, RecoverError.NoError);
335     }
336 
337     /**
338      * @dev Overload of {ECDSA-recover} that receives the `v`,
339      * `r` and `s` signature fields separately.
340      */
341     function recover(
342         bytes32 hash,
343         uint8 v,
344         bytes32 r,
345         bytes32 s
346     ) internal pure returns (address) {
347         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
348         _throwError(error);
349         return recovered;
350     }
351 
352     /**
353      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
354      * produces hash corresponding to the one signed with the
355      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
356      * JSON-RPC method as part of EIP-191.
357      *
358      * See {recover}.
359      */
360     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
361         // 32 is the length in bytes of hash,
362         // enforced by the type signature above
363         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
364     }
365 
366     /**
367      * @dev Returns an Ethereum Signed Message, created from `s`. This
368      * produces hash corresponding to the one signed with the
369      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
370      * JSON-RPC method as part of EIP-191.
371      *
372      * See {recover}.
373      */
374     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
375         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
376     }
377 
378     /**
379      * @dev Returns an Ethereum Signed Typed Data, created from a
380      * `domainSeparator` and a `structHash`. This produces hash corresponding
381      * to the one signed with the
382      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
383      * JSON-RPC method as part of EIP-712.
384      *
385      * See {recover}.
386      */
387     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
388         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
389     }
390 }
391 
392 // File: @openzeppelin/contracts/utils/cryptography/draft-EIP712.sol
393 
394 
395 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/draft-EIP712.sol)
396 
397 pragma solidity ^0.8.0;
398 
399 
400 /**
401  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
402  *
403  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
404  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
405  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
406  *
407  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
408  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
409  * ({_hashTypedDataV4}).
410  *
411  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
412  * the chain id to protect against replay attacks on an eventual fork of the chain.
413  *
414  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
415  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
416  *
417  * _Available since v3.4._
418  */
419 abstract contract EIP712 {
420     /* solhint-disable var-name-mixedcase */
421     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
422     // invalidate the cached domain separator if the chain id changes.
423     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
424     uint256 private immutable _CACHED_CHAIN_ID;
425     address private immutable _CACHED_THIS;
426 
427     bytes32 private immutable _HASHED_NAME;
428     bytes32 private immutable _HASHED_VERSION;
429     bytes32 private immutable _TYPE_HASH;
430 
431     /* solhint-enable var-name-mixedcase */
432 
433     /**
434      * @dev Initializes the domain separator and parameter caches.
435      *
436      * The meaning of `name` and `version` is specified in
437      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
438      *
439      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
440      * - `version`: the current major version of the signing domain.
441      *
442      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
443      * contract upgrade].
444      */
445     constructor(string memory name, string memory version) {
446         bytes32 hashedName = keccak256(bytes(name));
447         bytes32 hashedVersion = keccak256(bytes(version));
448         bytes32 typeHash = keccak256(
449             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
450         );
451         _HASHED_NAME = hashedName;
452         _HASHED_VERSION = hashedVersion;
453         _CACHED_CHAIN_ID = block.chainid;
454         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
455         _CACHED_THIS = address(this);
456         _TYPE_HASH = typeHash;
457     }
458 
459     /**
460      * @dev Returns the domain separator for the current chain.
461      */
462     function _domainSeparatorV4() internal view returns (bytes32) {
463         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
464             return _CACHED_DOMAIN_SEPARATOR;
465         } else {
466             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
467         }
468     }
469 
470     function _buildDomainSeparator(
471         bytes32 typeHash,
472         bytes32 nameHash,
473         bytes32 versionHash
474     ) private view returns (bytes32) {
475         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
476     }
477 
478     /**
479      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
480      * function returns the hash of the fully encoded EIP712 message for this domain.
481      *
482      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
483      *
484      * ```solidity
485      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
486      *     keccak256("Mail(address to,string contents)"),
487      *     mailTo,
488      *     keccak256(bytes(mailContents))
489      * )));
490      * address signer = ECDSA.recover(digest, signature);
491      * ```
492      */
493     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
494         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
495     }
496 }
497 
498 // File: @openzeppelin/contracts/utils/Context.sol
499 
500 
501 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
502 
503 pragma solidity ^0.8.0;
504 
505 /**
506  * @dev Provides information about the current execution context, including the
507  * sender of the transaction and its data. While these are generally available
508  * via msg.sender and msg.data, they should not be accessed in such a direct
509  * manner, since when dealing with meta-transactions the account sending and
510  * paying for execution may not be the actual sender (as far as an application
511  * is concerned).
512  *
513  * This contract is only required for intermediate, library-like contracts.
514  */
515 abstract contract Context {
516     function _msgSender() internal view virtual returns (address) {
517         return msg.sender;
518     }
519 
520     function _msgData() internal view virtual returns (bytes calldata) {
521         return msg.data;
522     }
523 }
524 
525 // File: @openzeppelin/contracts/access/Ownable.sol
526 
527 
528 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
529 
530 pragma solidity ^0.8.0;
531 
532 
533 /**
534  * @dev Contract module which provides a basic access control mechanism, where
535  * there is an account (an owner) that can be granted exclusive access to
536  * specific functions.
537  *
538  * By default, the owner account will be the one that deploys the contract. This
539  * can later be changed with {transferOwnership}.
540  *
541  * This module is used through inheritance. It will make available the modifier
542  * `onlyOwner`, which can be applied to your functions to restrict their use to
543  * the owner.
544  */
545 abstract contract Ownable is Context {
546     address private _owner;
547 
548     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
549 
550     /**
551      * @dev Initializes the contract setting the deployer as the initial owner.
552      */
553     constructor() {
554         _transferOwnership(_msgSender());
555     }
556 
557     /**
558      * @dev Returns the address of the current owner.
559      */
560     function owner() public view virtual returns (address) {
561         return _owner;
562     }
563 
564     /**
565      * @dev Throws if called by any account other than the owner.
566      */
567     modifier onlyOwner() {
568         require(owner() == _msgSender(), "Ownable: caller is not the owner");
569         _;
570     }
571 
572     /**
573      * @dev Leaves the contract without owner. It will not be possible to call
574      * `onlyOwner` functions anymore. Can only be called by the current owner.
575      *
576      * NOTE: Renouncing ownership will leave the contract without an owner,
577      * thereby removing any functionality that is only available to the owner.
578      */
579     function renounceOwnership() public virtual onlyOwner {
580         _transferOwnership(address(0));
581     }
582 
583     /**
584      * @dev Transfers ownership of the contract to a new account (`newOwner`).
585      * Can only be called by the current owner.
586      */
587     function transferOwnership(address newOwner) public virtual onlyOwner {
588         require(newOwner != address(0), "Ownable: new owner is the zero address");
589         _transferOwnership(newOwner);
590     }
591 
592     /**
593      * @dev Transfers ownership of the contract to a new account (`newOwner`).
594      * Internal function without access restriction.
595      */
596     function _transferOwnership(address newOwner) internal virtual {
597         address oldOwner = _owner;
598         _owner = newOwner;
599         emit OwnershipTransferred(oldOwner, newOwner);
600     }
601 }
602 
603 // File: @openzeppelin/contracts/utils/Address.sol
604 
605 
606 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
607 
608 pragma solidity ^0.8.0;
609 
610 /**
611  * @dev Collection of functions related to the address type
612  */
613 library Address {
614     /**
615      * @dev Returns true if `account` is a contract.
616      *
617      * [IMPORTANT]
618      * ====
619      * It is unsafe to assume that an address for which this function returns
620      * false is an externally-owned account (EOA) and not a contract.
621      *
622      * Among others, `isContract` will return false for the following
623      * types of addresses:
624      *
625      *  - an externally-owned account
626      *  - a contract in construction
627      *  - an address where a contract will be created
628      *  - an address where a contract lived, but was destroyed
629      * ====
630      */
631     function isContract(address account) internal view returns (bool) {
632         // This method relies on extcodesize, which returns 0 for contracts in
633         // construction, since the code is only stored at the end of the
634         // constructor execution.
635 
636         uint256 size;
637         assembly {
638             size := extcodesize(account)
639         }
640         return size > 0;
641     }
642 
643     /**
644      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
645      * `recipient`, forwarding all available gas and reverting on errors.
646      *
647      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
648      * of certain opcodes, possibly making contracts go over the 2300 gas limit
649      * imposed by `transfer`, making them unable to receive funds via
650      * `transfer`. {sendValue} removes this limitation.
651      *
652      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
653      *
654      * IMPORTANT: because control is transferred to `recipient`, care must be
655      * taken to not create reentrancy vulnerabilities. Consider using
656      * {ReentrancyGuard} or the
657      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
658      */
659     function sendValue(address payable recipient, uint256 amount) internal {
660         require(address(this).balance >= amount, "Address: insufficient balance");
661 
662         (bool success, ) = recipient.call{value: amount}("");
663         require(success, "Address: unable to send value, recipient may have reverted");
664     }
665 
666     /**
667      * @dev Performs a Solidity function call using a low level `call`. A
668      * plain `call` is an unsafe replacement for a function call: use this
669      * function instead.
670      *
671      * If `target` reverts with a revert reason, it is bubbled up by this
672      * function (like regular Solidity function calls).
673      *
674      * Returns the raw returned data. To convert to the expected return value,
675      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
676      *
677      * Requirements:
678      *
679      * - `target` must be a contract.
680      * - calling `target` with `data` must not revert.
681      *
682      * _Available since v3.1._
683      */
684     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
685         return functionCall(target, data, "Address: low-level call failed");
686     }
687 
688     /**
689      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
690      * `errorMessage` as a fallback revert reason when `target` reverts.
691      *
692      * _Available since v3.1._
693      */
694     function functionCall(
695         address target,
696         bytes memory data,
697         string memory errorMessage
698     ) internal returns (bytes memory) {
699         return functionCallWithValue(target, data, 0, errorMessage);
700     }
701 
702     /**
703      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
704      * but also transferring `value` wei to `target`.
705      *
706      * Requirements:
707      *
708      * - the calling contract must have an ETH balance of at least `value`.
709      * - the called Solidity function must be `payable`.
710      *
711      * _Available since v3.1._
712      */
713     function functionCallWithValue(
714         address target,
715         bytes memory data,
716         uint256 value
717     ) internal returns (bytes memory) {
718         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
719     }
720 
721     /**
722      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
723      * with `errorMessage` as a fallback revert reason when `target` reverts.
724      *
725      * _Available since v3.1._
726      */
727     function functionCallWithValue(
728         address target,
729         bytes memory data,
730         uint256 value,
731         string memory errorMessage
732     ) internal returns (bytes memory) {
733         require(address(this).balance >= value, "Address: insufficient balance for call");
734         require(isContract(target), "Address: call to non-contract");
735 
736         (bool success, bytes memory returndata) = target.call{value: value}(data);
737         return verifyCallResult(success, returndata, errorMessage);
738     }
739 
740     /**
741      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
742      * but performing a static call.
743      *
744      * _Available since v3.3._
745      */
746     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
747         return functionStaticCall(target, data, "Address: low-level static call failed");
748     }
749 
750     /**
751      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
752      * but performing a static call.
753      *
754      * _Available since v3.3._
755      */
756     function functionStaticCall(
757         address target,
758         bytes memory data,
759         string memory errorMessage
760     ) internal view returns (bytes memory) {
761         require(isContract(target), "Address: static call to non-contract");
762 
763         (bool success, bytes memory returndata) = target.staticcall(data);
764         return verifyCallResult(success, returndata, errorMessage);
765     }
766 
767     /**
768      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
769      * but performing a delegate call.
770      *
771      * _Available since v3.4._
772      */
773     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
774         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
775     }
776 
777     /**
778      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
779      * but performing a delegate call.
780      *
781      * _Available since v3.4._
782      */
783     function functionDelegateCall(
784         address target,
785         bytes memory data,
786         string memory errorMessage
787     ) internal returns (bytes memory) {
788         require(isContract(target), "Address: delegate call to non-contract");
789 
790         (bool success, bytes memory returndata) = target.delegatecall(data);
791         return verifyCallResult(success, returndata, errorMessage);
792     }
793 
794     /**
795      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
796      * revert reason using the provided one.
797      *
798      * _Available since v4.3._
799      */
800     function verifyCallResult(
801         bool success,
802         bytes memory returndata,
803         string memory errorMessage
804     ) internal pure returns (bytes memory) {
805         if (success) {
806             return returndata;
807         } else {
808             // Look for revert reason and bubble it up if present
809             if (returndata.length > 0) {
810                 // The easiest way to bubble the revert reason is using memory via assembly
811 
812                 assembly {
813                     let returndata_size := mload(returndata)
814                     revert(add(32, returndata), returndata_size)
815                 }
816             } else {
817                 revert(errorMessage);
818             }
819         }
820     }
821 }
822 
823 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
824 
825 
826 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
827 
828 pragma solidity ^0.8.0;
829 
830 
831 
832 /**
833  * @title SafeERC20
834  * @dev Wrappers around ERC20 operations that throw on failure (when the token
835  * contract returns false). Tokens that return no value (and instead revert or
836  * throw on failure) are also supported, non-reverting calls are assumed to be
837  * successful.
838  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
839  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
840  */
841 library SafeERC20 {
842     using Address for address;
843 
844     function safeTransfer(
845         IERC20 token,
846         address to,
847         uint256 value
848     ) internal {
849         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
850     }
851 
852     function safeTransferFrom(
853         IERC20 token,
854         address from,
855         address to,
856         uint256 value
857     ) internal {
858         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
859     }
860 
861     /**
862      * @dev Deprecated. This function has issues similar to the ones found in
863      * {IERC20-approve}, and its usage is discouraged.
864      *
865      * Whenever possible, use {safeIncreaseAllowance} and
866      * {safeDecreaseAllowance} instead.
867      */
868     function safeApprove(
869         IERC20 token,
870         address spender,
871         uint256 value
872     ) internal {
873         // safeApprove should only be called when setting an initial allowance,
874         // or when resetting it to zero. To increase and decrease it, use
875         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
876         require(
877             (value == 0) || (token.allowance(address(this), spender) == 0),
878             "SafeERC20: approve from non-zero to non-zero allowance"
879         );
880         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
881     }
882 
883     function safeIncreaseAllowance(
884         IERC20 token,
885         address spender,
886         uint256 value
887     ) internal {
888         uint256 newAllowance = token.allowance(address(this), spender) + value;
889         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
890     }
891 
892     function safeDecreaseAllowance(
893         IERC20 token,
894         address spender,
895         uint256 value
896     ) internal {
897         unchecked {
898             uint256 oldAllowance = token.allowance(address(this), spender);
899             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
900             uint256 newAllowance = oldAllowance - value;
901             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
902         }
903     }
904 
905     /**
906      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
907      * on the return value: the return value is optional (but if data is returned, it must not be false).
908      * @param token The token targeted by the call.
909      * @param data The call data (encoded using abi.encode or one of its variants).
910      */
911     function _callOptionalReturn(IERC20 token, bytes memory data) private {
912         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
913         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
914         // the target address contains contract code and also asserts for success in the low-level call.
915 
916         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
917         if (returndata.length > 0) {
918             // Return data is optional
919             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
920         }
921     }
922 }
923 
924 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
925 
926 
927 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
928 
929 pragma solidity ^0.8.0;
930 
931 
932 
933 
934 /**
935  * @title PaymentSplitter
936  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
937  * that the Ether will be split in this way, since it is handled transparently by the contract.
938  *
939  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
940  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
941  * an amount proportional to the percentage of total shares they were assigned.
942  *
943  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
944  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
945  * function.
946  *
947  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
948  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
949  * to run tests before sending real value to this contract.
950  */
951 contract PaymentSplitter is Context {
952     event PayeeAdded(address account, uint256 shares);
953     event PaymentReleased(address to, uint256 amount);
954     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
955     event PaymentReceived(address from, uint256 amount);
956 
957     uint256 private _totalShares;
958     uint256 private _totalReleased;
959 
960     mapping(address => uint256) private _shares;
961     mapping(address => uint256) private _released;
962     address[] private _payees;
963 
964     mapping(IERC20 => uint256) private _erc20TotalReleased;
965     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
966 
967     /**
968      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
969      * the matching position in the `shares` array.
970      *
971      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
972      * duplicates in `payees`.
973      */
974     constructor(address[] memory payees, uint256[] memory shares_) payable {
975         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
976         require(payees.length > 0, "PaymentSplitter: no payees");
977 
978         for (uint256 i = 0; i < payees.length; i++) {
979             _addPayee(payees[i], shares_[i]);
980         }
981     }
982 
983     /**
984      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
985      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
986      * reliability of the events, and not the actual splitting of Ether.
987      *
988      * To learn more about this see the Solidity documentation for
989      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
990      * functions].
991      */
992     receive() external payable virtual {
993         emit PaymentReceived(_msgSender(), msg.value);
994     }
995 
996     /**
997      * @dev Getter for the total shares held by payees.
998      */
999     function totalShares() public view returns (uint256) {
1000         return _totalShares;
1001     }
1002 
1003     /**
1004      * @dev Getter for the total amount of Ether already released.
1005      */
1006     function totalReleased() public view returns (uint256) {
1007         return _totalReleased;
1008     }
1009 
1010     /**
1011      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
1012      * contract.
1013      */
1014     function totalReleased(IERC20 token) public view returns (uint256) {
1015         return _erc20TotalReleased[token];
1016     }
1017 
1018     /**
1019      * @dev Getter for the amount of shares held by an account.
1020      */
1021     function shares(address account) public view returns (uint256) {
1022         return _shares[account];
1023     }
1024 
1025     /**
1026      * @dev Getter for the amount of Ether already released to a payee.
1027      */
1028     function released(address account) public view returns (uint256) {
1029         return _released[account];
1030     }
1031 
1032     /**
1033      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
1034      * IERC20 contract.
1035      */
1036     function released(IERC20 token, address account) public view returns (uint256) {
1037         return _erc20Released[token][account];
1038     }
1039 
1040     /**
1041      * @dev Getter for the address of the payee number `index`.
1042      */
1043     function payee(uint256 index) public view returns (address) {
1044         return _payees[index];
1045     }
1046 
1047     /**
1048      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
1049      * total shares and their previous withdrawals.
1050      */
1051     function release(address payable account) public virtual {
1052         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1053 
1054         uint256 totalReceived = address(this).balance + totalReleased();
1055         uint256 payment = _pendingPayment(account, totalReceived, released(account));
1056 
1057         require(payment != 0, "PaymentSplitter: account is not due payment");
1058 
1059         _released[account] += payment;
1060         _totalReleased += payment;
1061 
1062         Address.sendValue(account, payment);
1063         emit PaymentReleased(account, payment);
1064     }
1065 
1066     /**
1067      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
1068      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
1069      * contract.
1070      */
1071     function release(IERC20 token, address account) public virtual {
1072         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1073 
1074         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
1075         uint256 payment = _pendingPayment(account, totalReceived, released(token, account));
1076 
1077         require(payment != 0, "PaymentSplitter: account is not due payment");
1078 
1079         _erc20Released[token][account] += payment;
1080         _erc20TotalReleased[token] += payment;
1081 
1082         SafeERC20.safeTransfer(token, account, payment);
1083         emit ERC20PaymentReleased(token, account, payment);
1084     }
1085 
1086     /**
1087      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
1088      * already released amounts.
1089      */
1090     function _pendingPayment(
1091         address account,
1092         uint256 totalReceived,
1093         uint256 alreadyReleased
1094     ) private view returns (uint256) {
1095         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
1096     }
1097 
1098     /**
1099      * @dev Add a new payee to the contract.
1100      * @param account The address of the payee to add.
1101      * @param shares_ The number of shares owned by the payee.
1102      */
1103     function _addPayee(address account, uint256 shares_) private {
1104         require(account != address(0), "PaymentSplitter: account is the zero address");
1105         require(shares_ > 0, "PaymentSplitter: shares are 0");
1106         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
1107 
1108         _payees.push(account);
1109         _shares[account] = shares_;
1110         _totalShares = _totalShares + shares_;
1111         emit PayeeAdded(account, shares_);
1112     }
1113 }
1114 
1115 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1116 
1117 
1118 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1119 
1120 pragma solidity ^0.8.0;
1121 
1122 /**
1123  * @dev Interface of the ERC165 standard, as defined in the
1124  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1125  *
1126  * Implementers can declare support of contract interfaces, which can then be
1127  * queried by others ({ERC165Checker}).
1128  *
1129  * For an implementation, see {ERC165}.
1130  */
1131 interface IERC165 {
1132     /**
1133      * @dev Returns true if this contract implements the interface defined by
1134      * `interfaceId`. See the corresponding
1135      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1136      * to learn more about how these ids are created.
1137      *
1138      * This function call must use less than 30 000 gas.
1139      */
1140     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1141 }
1142 
1143 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1144 
1145 
1146 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1147 
1148 pragma solidity ^0.8.0;
1149 
1150 
1151 /**
1152  * @dev Implementation of the {IERC165} interface.
1153  *
1154  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1155  * for the additional interface id that will be supported. For example:
1156  *
1157  * ```solidity
1158  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1159  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1160  * }
1161  * ```
1162  *
1163  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1164  */
1165 abstract contract ERC165 is IERC165 {
1166     /**
1167      * @dev See {IERC165-supportsInterface}.
1168      */
1169     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1170         return interfaceId == type(IERC165).interfaceId;
1171     }
1172 }
1173 
1174 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
1175 
1176 
1177 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155Receiver.sol)
1178 
1179 pragma solidity ^0.8.0;
1180 
1181 
1182 /**
1183  * @dev _Available since v3.1._
1184  */
1185 interface IERC1155Receiver is IERC165 {
1186     /**
1187         @dev Handles the receipt of a single ERC1155 token type. This function is
1188         called at the end of a `safeTransferFrom` after the balance has been updated.
1189         To accept the transfer, this must return
1190         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
1191         (i.e. 0xf23a6e61, or its own function selector).
1192         @param operator The address which initiated the transfer (i.e. msg.sender)
1193         @param from The address which previously owned the token
1194         @param id The ID of the token being transferred
1195         @param value The amount of tokens being transferred
1196         @param data Additional data with no specified format
1197         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
1198     */
1199     function onERC1155Received(
1200         address operator,
1201         address from,
1202         uint256 id,
1203         uint256 value,
1204         bytes calldata data
1205     ) external returns (bytes4);
1206 
1207     /**
1208         @dev Handles the receipt of a multiple ERC1155 token types. This function
1209         is called at the end of a `safeBatchTransferFrom` after the balances have
1210         been updated. To accept the transfer(s), this must return
1211         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
1212         (i.e. 0xbc197c81, or its own function selector).
1213         @param operator The address which initiated the batch transfer (i.e. msg.sender)
1214         @param from The address which previously owned the token
1215         @param ids An array containing ids of each token being transferred (order and length must match values array)
1216         @param values An array containing amounts of each token being transferred (order and length must match ids array)
1217         @param data Additional data with no specified format
1218         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
1219     */
1220     function onERC1155BatchReceived(
1221         address operator,
1222         address from,
1223         uint256[] calldata ids,
1224         uint256[] calldata values,
1225         bytes calldata data
1226     ) external returns (bytes4);
1227 }
1228 
1229 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
1230 
1231 
1232 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
1233 
1234 pragma solidity ^0.8.0;
1235 
1236 
1237 /**
1238  * @dev Required interface of an ERC1155 compliant contract, as defined in the
1239  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
1240  *
1241  * _Available since v3.1._
1242  */
1243 interface IERC1155 is IERC165 {
1244     /**
1245      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
1246      */
1247     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
1248 
1249     /**
1250      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
1251      * transfers.
1252      */
1253     event TransferBatch(
1254         address indexed operator,
1255         address indexed from,
1256         address indexed to,
1257         uint256[] ids,
1258         uint256[] values
1259     );
1260 
1261     /**
1262      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
1263      * `approved`.
1264      */
1265     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
1266 
1267     /**
1268      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
1269      *
1270      * If an {URI} event was emitted for `id`, the standard
1271      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
1272      * returned by {IERC1155MetadataURI-uri}.
1273      */
1274     event URI(string value, uint256 indexed id);
1275 
1276     /**
1277      * @dev Returns the amount of tokens of token type `id` owned by `account`.
1278      *
1279      * Requirements:
1280      *
1281      * - `account` cannot be the zero address.
1282      */
1283     function balanceOf(address account, uint256 id) external view returns (uint256);
1284 
1285     /**
1286      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
1287      *
1288      * Requirements:
1289      *
1290      * - `accounts` and `ids` must have the same length.
1291      */
1292     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
1293         external
1294         view
1295         returns (uint256[] memory);
1296 
1297     /**
1298      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
1299      *
1300      * Emits an {ApprovalForAll} event.
1301      *
1302      * Requirements:
1303      *
1304      * - `operator` cannot be the caller.
1305      */
1306     function setApprovalForAll(address operator, bool approved) external;
1307 
1308     /**
1309      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
1310      *
1311      * See {setApprovalForAll}.
1312      */
1313     function isApprovedForAll(address account, address operator) external view returns (bool);
1314 
1315     /**
1316      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1317      *
1318      * Emits a {TransferSingle} event.
1319      *
1320      * Requirements:
1321      *
1322      * - `to` cannot be the zero address.
1323      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
1324      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1325      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1326      * acceptance magic value.
1327      */
1328     function safeTransferFrom(
1329         address from,
1330         address to,
1331         uint256 id,
1332         uint256 amount,
1333         bytes calldata data
1334     ) external;
1335 
1336     /**
1337      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
1338      *
1339      * Emits a {TransferBatch} event.
1340      *
1341      * Requirements:
1342      *
1343      * - `ids` and `amounts` must have the same length.
1344      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1345      * acceptance magic value.
1346      */
1347     function safeBatchTransferFrom(
1348         address from,
1349         address to,
1350         uint256[] calldata ids,
1351         uint256[] calldata amounts,
1352         bytes calldata data
1353     ) external;
1354 }
1355 
1356 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
1357 
1358 
1359 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
1360 
1361 pragma solidity ^0.8.0;
1362 
1363 
1364 /**
1365  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
1366  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
1367  *
1368  * _Available since v3.1._
1369  */
1370 interface IERC1155MetadataURI is IERC1155 {
1371     /**
1372      * @dev Returns the URI for token type `id`.
1373      *
1374      * If the `\{id\}` substring is present in the URI, it must be replaced by
1375      * clients with the actual token type ID.
1376      */
1377     function uri(uint256 id) external view returns (string memory);
1378 }
1379 
1380 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
1381 
1382 
1383 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/ERC1155.sol)
1384 
1385 pragma solidity ^0.8.0;
1386 
1387 
1388 
1389 
1390 
1391 
1392 
1393 /**
1394  * @dev Implementation of the basic standard multi-token.
1395  * See https://eips.ethereum.org/EIPS/eip-1155
1396  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
1397  *
1398  * _Available since v3.1._
1399  */
1400 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
1401     using Address for address;
1402 
1403     // Mapping from token ID to account balances
1404     mapping(uint256 => mapping(address => uint256)) private _balances;
1405 
1406     // Mapping from account to operator approvals
1407     mapping(address => mapping(address => bool)) private _operatorApprovals;
1408 
1409     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
1410     string private _uri;
1411 
1412     /**
1413      * @dev See {_setURI}.
1414      */
1415     constructor(string memory uri_) {
1416         _setURI(uri_);
1417     }
1418 
1419     /**
1420      * @dev See {IERC165-supportsInterface}.
1421      */
1422     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1423         return
1424             interfaceId == type(IERC1155).interfaceId ||
1425             interfaceId == type(IERC1155MetadataURI).interfaceId ||
1426             super.supportsInterface(interfaceId);
1427     }
1428 
1429     /**
1430      * @dev See {IERC1155MetadataURI-uri}.
1431      *
1432      * This implementation returns the same URI for *all* token types. It relies
1433      * on the token type ID substitution mechanism
1434      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1435      *
1436      * Clients calling this function must replace the `\{id\}` substring with the
1437      * actual token type ID.
1438      */
1439     function uri(uint256) public view virtual override returns (string memory) {
1440         return _uri;
1441     }
1442 
1443     /**
1444      * @dev See {IERC1155-balanceOf}.
1445      *
1446      * Requirements:
1447      *
1448      * - `account` cannot be the zero address.
1449      */
1450     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
1451         require(account != address(0), "ERC1155: balance query for the zero address");
1452         return _balances[id][account];
1453     }
1454 
1455     /**
1456      * @dev See {IERC1155-balanceOfBatch}.
1457      *
1458      * Requirements:
1459      *
1460      * - `accounts` and `ids` must have the same length.
1461      */
1462     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
1463         public
1464         view
1465         virtual
1466         override
1467         returns (uint256[] memory)
1468     {
1469         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
1470 
1471         uint256[] memory batchBalances = new uint256[](accounts.length);
1472 
1473         for (uint256 i = 0; i < accounts.length; ++i) {
1474             batchBalances[i] = balanceOf(accounts[i], ids[i]);
1475         }
1476 
1477         return batchBalances;
1478     }
1479 
1480     /**
1481      * @dev See {IERC1155-setApprovalForAll}.
1482      */
1483     function setApprovalForAll(address operator, bool approved) public virtual override {
1484         _setApprovalForAll(_msgSender(), operator, approved);
1485     }
1486 
1487     /**
1488      * @dev See {IERC1155-isApprovedForAll}.
1489      */
1490     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
1491         return _operatorApprovals[account][operator];
1492     }
1493 
1494     /**
1495      * @dev See {IERC1155-safeTransferFrom}.
1496      */
1497     function safeTransferFrom(
1498         address from,
1499         address to,
1500         uint256 id,
1501         uint256 amount,
1502         bytes memory data
1503     ) public virtual override {
1504         require(
1505             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1506             "ERC1155: caller is not owner nor approved"
1507         );
1508         _safeTransferFrom(from, to, id, amount, data);
1509     }
1510 
1511     /**
1512      * @dev See {IERC1155-safeBatchTransferFrom}.
1513      */
1514     function safeBatchTransferFrom(
1515         address from,
1516         address to,
1517         uint256[] memory ids,
1518         uint256[] memory amounts,
1519         bytes memory data
1520     ) public virtual override {
1521         require(
1522             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1523             "ERC1155: transfer caller is not owner nor approved"
1524         );
1525         _safeBatchTransferFrom(from, to, ids, amounts, data);
1526     }
1527 
1528     /**
1529      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1530      *
1531      * Emits a {TransferSingle} event.
1532      *
1533      * Requirements:
1534      *
1535      * - `to` cannot be the zero address.
1536      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1537      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1538      * acceptance magic value.
1539      */
1540     function _safeTransferFrom(
1541         address from,
1542         address to,
1543         uint256 id,
1544         uint256 amount,
1545         bytes memory data
1546     ) internal virtual {
1547         require(to != address(0), "ERC1155: transfer to the zero address");
1548 
1549         address operator = _msgSender();
1550 
1551         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
1552 
1553         uint256 fromBalance = _balances[id][from];
1554         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1555         unchecked {
1556             _balances[id][from] = fromBalance - amount;
1557         }
1558         _balances[id][to] += amount;
1559 
1560         emit TransferSingle(operator, from, to, id, amount);
1561 
1562         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1563     }
1564 
1565     /**
1566      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1567      *
1568      * Emits a {TransferBatch} event.
1569      *
1570      * Requirements:
1571      *
1572      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1573      * acceptance magic value.
1574      */
1575     function _safeBatchTransferFrom(
1576         address from,
1577         address to,
1578         uint256[] memory ids,
1579         uint256[] memory amounts,
1580         bytes memory data
1581     ) internal virtual {
1582         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1583         require(to != address(0), "ERC1155: transfer to the zero address");
1584 
1585         address operator = _msgSender();
1586 
1587         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1588 
1589         for (uint256 i = 0; i < ids.length; ++i) {
1590             uint256 id = ids[i];
1591             uint256 amount = amounts[i];
1592 
1593             uint256 fromBalance = _balances[id][from];
1594             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1595             unchecked {
1596                 _balances[id][from] = fromBalance - amount;
1597             }
1598             _balances[id][to] += amount;
1599         }
1600 
1601         emit TransferBatch(operator, from, to, ids, amounts);
1602 
1603         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1604     }
1605 
1606     /**
1607      * @dev Sets a new URI for all token types, by relying on the token type ID
1608      * substitution mechanism
1609      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1610      *
1611      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1612      * URI or any of the amounts in the JSON file at said URI will be replaced by
1613      * clients with the token type ID.
1614      *
1615      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1616      * interpreted by clients as
1617      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1618      * for token type ID 0x4cce0.
1619      *
1620      * See {uri}.
1621      *
1622      * Because these URIs cannot be meaningfully represented by the {URI} event,
1623      * this function emits no events.
1624      */
1625     function _setURI(string memory newuri) internal virtual {
1626         _uri = newuri;
1627     }
1628 
1629     /**
1630      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
1631      *
1632      * Emits a {TransferSingle} event.
1633      *
1634      * Requirements:
1635      *
1636      * - `to` cannot be the zero address.
1637      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1638      * acceptance magic value.
1639      */
1640     function _mint(
1641         address to,
1642         uint256 id,
1643         uint256 amount,
1644         bytes memory data
1645     ) internal virtual {
1646         require(to != address(0), "ERC1155: mint to the zero address");
1647 
1648         address operator = _msgSender();
1649 
1650         _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);
1651 
1652         _balances[id][to] += amount;
1653         emit TransferSingle(operator, address(0), to, id, amount);
1654 
1655         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
1656     }
1657 
1658     /**
1659      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1660      *
1661      * Requirements:
1662      *
1663      * - `ids` and `amounts` must have the same length.
1664      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1665      * acceptance magic value.
1666      */
1667     function _mintBatch(
1668         address to,
1669         uint256[] memory ids,
1670         uint256[] memory amounts,
1671         bytes memory data
1672     ) internal virtual {
1673         require(to != address(0), "ERC1155: mint to the zero address");
1674         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1675 
1676         address operator = _msgSender();
1677 
1678         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1679 
1680         for (uint256 i = 0; i < ids.length; i++) {
1681             _balances[ids[i]][to] += amounts[i];
1682         }
1683 
1684         emit TransferBatch(operator, address(0), to, ids, amounts);
1685 
1686         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1687     }
1688 
1689     /**
1690      * @dev Destroys `amount` tokens of token type `id` from `from`
1691      *
1692      * Requirements:
1693      *
1694      * - `from` cannot be the zero address.
1695      * - `from` must have at least `amount` tokens of token type `id`.
1696      */
1697     function _burn(
1698         address from,
1699         uint256 id,
1700         uint256 amount
1701     ) internal virtual {
1702         require(from != address(0), "ERC1155: burn from the zero address");
1703 
1704         address operator = _msgSender();
1705 
1706         _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
1707 
1708         uint256 fromBalance = _balances[id][from];
1709         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1710         unchecked {
1711             _balances[id][from] = fromBalance - amount;
1712         }
1713 
1714         emit TransferSingle(operator, from, address(0), id, amount);
1715     }
1716 
1717     /**
1718      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1719      *
1720      * Requirements:
1721      *
1722      * - `ids` and `amounts` must have the same length.
1723      */
1724     function _burnBatch(
1725         address from,
1726         uint256[] memory ids,
1727         uint256[] memory amounts
1728     ) internal virtual {
1729         require(from != address(0), "ERC1155: burn from the zero address");
1730         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1731 
1732         address operator = _msgSender();
1733 
1734         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1735 
1736         for (uint256 i = 0; i < ids.length; i++) {
1737             uint256 id = ids[i];
1738             uint256 amount = amounts[i];
1739 
1740             uint256 fromBalance = _balances[id][from];
1741             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1742             unchecked {
1743                 _balances[id][from] = fromBalance - amount;
1744             }
1745         }
1746 
1747         emit TransferBatch(operator, from, address(0), ids, amounts);
1748     }
1749 
1750     /**
1751      * @dev Approve `operator` to operate on all of `owner` tokens
1752      *
1753      * Emits a {ApprovalForAll} event.
1754      */
1755     function _setApprovalForAll(
1756         address owner,
1757         address operator,
1758         bool approved
1759     ) internal virtual {
1760         require(owner != operator, "ERC1155: setting approval status for self");
1761         _operatorApprovals[owner][operator] = approved;
1762         emit ApprovalForAll(owner, operator, approved);
1763     }
1764 
1765     /**
1766      * @dev Hook that is called before any token transfer. This includes minting
1767      * and burning, as well as batched variants.
1768      *
1769      * The same hook is called on both single and batched variants. For single
1770      * transfers, the length of the `id` and `amount` arrays will be 1.
1771      *
1772      * Calling conditions (for each `id` and `amount` pair):
1773      *
1774      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1775      * of token type `id` will be  transferred to `to`.
1776      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1777      * for `to`.
1778      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1779      * will be burned.
1780      * - `from` and `to` are never both zero.
1781      * - `ids` and `amounts` have the same, non-zero length.
1782      *
1783      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1784      */
1785     function _beforeTokenTransfer(
1786         address operator,
1787         address from,
1788         address to,
1789         uint256[] memory ids,
1790         uint256[] memory amounts,
1791         bytes memory data
1792     ) internal virtual {}
1793 
1794     function _doSafeTransferAcceptanceCheck(
1795         address operator,
1796         address from,
1797         address to,
1798         uint256 id,
1799         uint256 amount,
1800         bytes memory data
1801     ) private {
1802         if (to.isContract()) {
1803             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1804                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1805                     revert("ERC1155: ERC1155Receiver rejected tokens");
1806                 }
1807             } catch Error(string memory reason) {
1808                 revert(reason);
1809             } catch {
1810                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1811             }
1812         }
1813     }
1814 
1815     function _doSafeBatchTransferAcceptanceCheck(
1816         address operator,
1817         address from,
1818         address to,
1819         uint256[] memory ids,
1820         uint256[] memory amounts,
1821         bytes memory data
1822     ) private {
1823         if (to.isContract()) {
1824             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1825                 bytes4 response
1826             ) {
1827                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1828                     revert("ERC1155: ERC1155Receiver rejected tokens");
1829                 }
1830             } catch Error(string memory reason) {
1831                 revert(reason);
1832             } catch {
1833                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1834             }
1835         }
1836     }
1837 
1838     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1839         uint256[] memory array = new uint256[](1);
1840         array[0] = element;
1841 
1842         return array;
1843     }
1844 }
1845 
1846 // File: Collection.sol
1847 
1848 //SPDX-License-Identifier: Unlicense
1849 pragma solidity 0.8.10;
1850 
1851 
1852 
1853 
1854 
1855 
1856 contract Collection is ERC1155, Ownable, PaymentSplitter, EIP712 {
1857     string private constant SIGNING_DOMAIN = "LazyNFT-Voucher";
1858     string private constant SIGNATURE_VERSION = "1";
1859 
1860     string public name;
1861     string public symbol;
1862     uint256 public maxSupply;
1863     uint256 public totalSupply;
1864 
1865     uint256 private startingAt;
1866     uint256 private initialPrice;
1867 
1868     // Mapping from token ID to copies
1869     mapping(uint256 => uint256) private copiesOf;
1870 
1871     // Mapping from token ID to initial price
1872     mapping(uint256 => uint256) private price;
1873 
1874     struct NFTVoucher {
1875         uint256 tokenId;
1876         uint256 maxSupply;
1877         string uri;
1878         bytes signature;
1879     }
1880 
1881     event NFTMinted(address, address, uint256, string);
1882     event NFTTransfered(address, address, uint256);
1883 
1884     constructor(
1885         uint256 _startingAt,
1886         uint256 _maxSupply,
1887         uint256 _initialPrice,
1888         string memory _uri,
1889         string memory _name,
1890         string memory _symbol,
1891         address _artist,
1892         address[] memory _payees,
1893         uint256[] memory _shares
1894     ) payable ERC1155(_uri) PaymentSplitter(_payees, _shares) EIP712(SIGNING_DOMAIN, SIGNATURE_VERSION) {
1895         name = _name;
1896         symbol = _symbol;
1897         maxSupply = _maxSupply;
1898         startingAt = _startingAt;
1899         initialPrice = _initialPrice;
1900 
1901         transferOwnership(_artist);
1902     }
1903 
1904     function mint(address _redeemer, NFTVoucher calldata _voucher) public payable {
1905         require(startingAt < block.timestamp, "Not started");
1906         require(copiesOf[_voucher.tokenId] < 1, "Already minted");
1907 
1908         // make sure signature is valid and get the address of the signer
1909         address signer = _verify(_voucher);
1910 
1911         // make sure that the signer is authorized to mint NFTs
1912         require(signer == owner(), "Signature invalid or unauthorized");
1913 
1914         // make sure that the redeemer is paying enough to cover the buyer's cost
1915         require(msg.value >= initialPrice, "Insufficient funds to mint");
1916 
1917         copiesOf[_voucher.tokenId] = 1;
1918         totalSupply = totalSupply + 1;
1919 
1920         // first assign the token to the signer, to establish provenance on-chain
1921         _mint(signer, _voucher.tokenId, 0, "");
1922 
1923         // transfer the token to the redeemer
1924         _mint(_redeemer, _voucher.tokenId, 1, "");
1925 
1926         emit NFTMinted(signer, _redeemer, _voucher.tokenId, _voucher.uri);
1927     }
1928 
1929     function safeTransferFrom(
1930         address from,
1931         address to,
1932         uint256 id,
1933         uint256 amount,
1934         bytes memory data
1935     ) public override {
1936         _safeTransferFrom(from, to, id, amount, data);
1937 
1938         emit NFTTransfered(from, to, id);
1939     }
1940 
1941     function _verify(NFTVoucher calldata voucher) private view returns (address) {
1942         bytes32 digest = _hash(voucher);
1943         return ECDSA.recover(digest, voucher.signature);
1944     }
1945 
1946     function _hash(NFTVoucher calldata voucher) private view returns (bytes32) {
1947         return
1948             _hashTypedDataV4(
1949                 keccak256(
1950                     abi.encode(
1951                         keccak256("NFTVoucher(uint256 tokenId,uint256 maxSupply,string uri)"),
1952                         voucher.tokenId,
1953                         voucher.maxSupply,
1954                         keccak256(bytes(voucher.uri))
1955                     )
1956                 )
1957             );
1958     }
1959 }