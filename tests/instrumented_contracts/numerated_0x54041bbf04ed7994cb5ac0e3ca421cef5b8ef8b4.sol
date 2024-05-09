1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13     uint8 private constant _ADDRESS_LENGTH = 20;
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 
71     /**
72      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
73      */
74     function toHexString(address addr) internal pure returns (string memory) {
75         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
76     }
77 }
78 
79 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
80 
81 
82 // OpenZeppelin Contracts (last updated v4.7.3) (utils/cryptography/ECDSA.sol)
83 
84 pragma solidity ^0.8.0;
85 
86 
87 /**
88  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
89  *
90  * These functions can be used to verify that a message was signed by the holder
91  * of the private keys of a given address.
92  */
93 library ECDSA {
94     enum RecoverError {
95         NoError,
96         InvalidSignature,
97         InvalidSignatureLength,
98         InvalidSignatureS,
99         InvalidSignatureV
100     }
101 
102     function _throwError(RecoverError error) private pure {
103         if (error == RecoverError.NoError) {
104             return; // no error: do nothing
105         } else if (error == RecoverError.InvalidSignature) {
106             revert("ECDSA: invalid signature");
107         } else if (error == RecoverError.InvalidSignatureLength) {
108             revert("ECDSA: invalid signature length");
109         } else if (error == RecoverError.InvalidSignatureS) {
110             revert("ECDSA: invalid signature 's' value");
111         } else if (error == RecoverError.InvalidSignatureV) {
112             revert("ECDSA: invalid signature 'v' value");
113         }
114     }
115 
116     /**
117      * @dev Returns the address that signed a hashed message (`hash`) with
118      * `signature` or error string. This address can then be used for verification purposes.
119      *
120      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
121      * this function rejects them by requiring the `s` value to be in the lower
122      * half order, and the `v` value to be either 27 or 28.
123      *
124      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
125      * verification to be secure: it is possible to craft signatures that
126      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
127      * this is by receiving a hash of the original message (which may otherwise
128      * be too long), and then calling {toEthSignedMessageHash} on it.
129      *
130      * Documentation for signature generation:
131      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
132      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
133      *
134      * _Available since v4.3._
135      */
136     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
137         if (signature.length == 65) {
138             bytes32 r;
139             bytes32 s;
140             uint8 v;
141             // ecrecover takes the signature parameters, and the only way to get them
142             // currently is to use assembly.
143             /// @solidity memory-safe-assembly
144             assembly {
145                 r := mload(add(signature, 0x20))
146                 s := mload(add(signature, 0x40))
147                 v := byte(0, mload(add(signature, 0x60)))
148             }
149             return tryRecover(hash, v, r, s);
150         } else {
151             return (address(0), RecoverError.InvalidSignatureLength);
152         }
153     }
154 
155     /**
156      * @dev Returns the address that signed a hashed message (`hash`) with
157      * `signature`. This address can then be used for verification purposes.
158      *
159      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
160      * this function rejects them by requiring the `s` value to be in the lower
161      * half order, and the `v` value to be either 27 or 28.
162      *
163      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
164      * verification to be secure: it is possible to craft signatures that
165      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
166      * this is by receiving a hash of the original message (which may otherwise
167      * be too long), and then calling {toEthSignedMessageHash} on it.
168      */
169     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
170         (address recovered, RecoverError error) = tryRecover(hash, signature);
171         _throwError(error);
172         return recovered;
173     }
174 
175     /**
176      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
177      *
178      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
179      *
180      * _Available since v4.3._
181      */
182     function tryRecover(
183         bytes32 hash,
184         bytes32 r,
185         bytes32 vs
186     ) internal pure returns (address, RecoverError) {
187         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
188         uint8 v = uint8((uint256(vs) >> 255) + 27);
189         return tryRecover(hash, v, r, s);
190     }
191 
192     /**
193      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
194      *
195      * _Available since v4.2._
196      */
197     function recover(
198         bytes32 hash,
199         bytes32 r,
200         bytes32 vs
201     ) internal pure returns (address) {
202         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
203         _throwError(error);
204         return recovered;
205     }
206 
207     /**
208      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
209      * `r` and `s` signature fields separately.
210      *
211      * _Available since v4.3._
212      */
213     function tryRecover(
214         bytes32 hash,
215         uint8 v,
216         bytes32 r,
217         bytes32 s
218     ) internal pure returns (address, RecoverError) {
219         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
220         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
221         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
222         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
223         //
224         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
225         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
226         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
227         // these malleable signatures as well.
228         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
229             return (address(0), RecoverError.InvalidSignatureS);
230         }
231         if (v != 27 && v != 28) {
232             return (address(0), RecoverError.InvalidSignatureV);
233         }
234 
235         // If the signature is valid (and not malleable), return the signer address
236         address signer = ecrecover(hash, v, r, s);
237         if (signer == address(0)) {
238             return (address(0), RecoverError.InvalidSignature);
239         }
240 
241         return (signer, RecoverError.NoError);
242     }
243 
244     /**
245      * @dev Overload of {ECDSA-recover} that receives the `v`,
246      * `r` and `s` signature fields separately.
247      */
248     function recover(
249         bytes32 hash,
250         uint8 v,
251         bytes32 r,
252         bytes32 s
253     ) internal pure returns (address) {
254         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
255         _throwError(error);
256         return recovered;
257     }
258 
259     /**
260      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
261      * produces hash corresponding to the one signed with the
262      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
263      * JSON-RPC method as part of EIP-191.
264      *
265      * See {recover}.
266      */
267     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
268         // 32 is the length in bytes of hash,
269         // enforced by the type signature above
270         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
271     }
272 
273     /**
274      * @dev Returns an Ethereum Signed Message, created from `s`. This
275      * produces hash corresponding to the one signed with the
276      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
277      * JSON-RPC method as part of EIP-191.
278      *
279      * See {recover}.
280      */
281     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
282         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
283     }
284 
285     /**
286      * @dev Returns an Ethereum Signed Typed Data, created from a
287      * `domainSeparator` and a `structHash`. This produces hash corresponding
288      * to the one signed with the
289      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
290      * JSON-RPC method as part of EIP-712.
291      *
292      * See {recover}.
293      */
294     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
295         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
296     }
297 }
298 
299 // File: @openzeppelin/contracts/utils/cryptography/draft-EIP712.sol
300 
301 
302 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/draft-EIP712.sol)
303 
304 pragma solidity ^0.8.0;
305 
306 
307 /**
308  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
309  *
310  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
311  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
312  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
313  *
314  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
315  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
316  * ({_hashTypedDataV4}).
317  *
318  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
319  * the chain id to protect against replay attacks on an eventual fork of the chain.
320  *
321  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
322  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
323  *
324  * _Available since v3.4._
325  */
326 abstract contract EIP712 {
327     /* solhint-disable var-name-mixedcase */
328     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
329     // invalidate the cached domain separator if the chain id changes.
330     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
331     uint256 private immutable _CACHED_CHAIN_ID;
332     address private immutable _CACHED_THIS;
333 
334     bytes32 private immutable _HASHED_NAME;
335     bytes32 private immutable _HASHED_VERSION;
336     bytes32 private immutable _TYPE_HASH;
337 
338     /* solhint-enable var-name-mixedcase */
339 
340     /**
341      * @dev Initializes the domain separator and parameter caches.
342      *
343      * The meaning of `name` and `version` is specified in
344      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
345      *
346      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
347      * - `version`: the current major version of the signing domain.
348      *
349      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
350      * contract upgrade].
351      */
352     constructor(string memory name, string memory version) {
353         bytes32 hashedName = keccak256(bytes(name));
354         bytes32 hashedVersion = keccak256(bytes(version));
355         bytes32 typeHash = keccak256(
356             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
357         );
358         _HASHED_NAME = hashedName;
359         _HASHED_VERSION = hashedVersion;
360         _CACHED_CHAIN_ID = block.chainid;
361         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
362         _CACHED_THIS = address(this);
363         _TYPE_HASH = typeHash;
364     }
365 
366     /**
367      * @dev Returns the domain separator for the current chain.
368      */
369     function _domainSeparatorV4() internal view returns (bytes32) {
370         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
371             return _CACHED_DOMAIN_SEPARATOR;
372         } else {
373             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
374         }
375     }
376 
377     function _buildDomainSeparator(
378         bytes32 typeHash,
379         bytes32 nameHash,
380         bytes32 versionHash
381     ) private view returns (bytes32) {
382         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
383     }
384 
385     /**
386      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
387      * function returns the hash of the fully encoded EIP712 message for this domain.
388      *
389      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
390      *
391      * ```solidity
392      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
393      *     keccak256("Mail(address to,string contents)"),
394      *     mailTo,
395      *     keccak256(bytes(mailContents))
396      * )));
397      * address signer = ECDSA.recover(digest, signature);
398      * ```
399      */
400     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
401         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
402     }
403 }
404 
405 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
406 
407 
408 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
409 
410 pragma solidity ^0.8.0;
411 
412 /**
413  * @dev Interface of the ERC20 standard as defined in the EIP.
414  */
415 interface IERC20 {
416     /**
417      * @dev Emitted when `value` tokens are moved from one account (`from`) to
418      * another (`to`).
419      *
420      * Note that `value` may be zero.
421      */
422     event Transfer(address indexed from, address indexed to, uint256 value);
423 
424     /**
425      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
426      * a call to {approve}. `value` is the new allowance.
427      */
428     event Approval(address indexed owner, address indexed spender, uint256 value);
429 
430     /**
431      * @dev Returns the amount of tokens in existence.
432      */
433     function totalSupply() external view returns (uint256);
434 
435     /**
436      * @dev Returns the amount of tokens owned by `account`.
437      */
438     function balanceOf(address account) external view returns (uint256);
439 
440     /**
441      * @dev Moves `amount` tokens from the caller's account to `to`.
442      *
443      * Returns a boolean value indicating whether the operation succeeded.
444      *
445      * Emits a {Transfer} event.
446      */
447     function transfer(address to, uint256 amount) external returns (bool);
448 
449     /**
450      * @dev Returns the remaining number of tokens that `spender` will be
451      * allowed to spend on behalf of `owner` through {transferFrom}. This is
452      * zero by default.
453      *
454      * This value changes when {approve} or {transferFrom} are called.
455      */
456     function allowance(address owner, address spender) external view returns (uint256);
457 
458     /**
459      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
460      *
461      * Returns a boolean value indicating whether the operation succeeded.
462      *
463      * IMPORTANT: Beware that changing an allowance with this method brings the risk
464      * that someone may use both the old and the new allowance by unfortunate
465      * transaction ordering. One possible solution to mitigate this race
466      * condition is to first reduce the spender's allowance to 0 and set the
467      * desired value afterwards:
468      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
469      *
470      * Emits an {Approval} event.
471      */
472     function approve(address spender, uint256 amount) external returns (bool);
473 
474     /**
475      * @dev Moves `amount` tokens from `from` to `to` using the
476      * allowance mechanism. `amount` is then deducted from the caller's
477      * allowance.
478      *
479      * Returns a boolean value indicating whether the operation succeeded.
480      *
481      * Emits a {Transfer} event.
482      */
483     function transferFrom(
484         address from,
485         address to,
486         uint256 amount
487     ) external returns (bool);
488 }
489 
490 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
491 
492 
493 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
494 
495 pragma solidity ^0.8.0;
496 
497 
498 /**
499  * @dev Interface for the optional metadata functions from the ERC20 standard.
500  *
501  * _Available since v4.1._
502  */
503 interface IERC20Metadata is IERC20 {
504     /**
505      * @dev Returns the name of the token.
506      */
507     function name() external view returns (string memory);
508 
509     /**
510      * @dev Returns the symbol of the token.
511      */
512     function symbol() external view returns (string memory);
513 
514     /**
515      * @dev Returns the decimals places of the token.
516      */
517     function decimals() external view returns (uint8);
518 }
519 
520 // File: @openzeppelin/contracts/utils/Context.sol
521 
522 
523 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
524 
525 pragma solidity ^0.8.0;
526 
527 /**
528  * @dev Provides information about the current execution context, including the
529  * sender of the transaction and its data. While these are generally available
530  * via msg.sender and msg.data, they should not be accessed in such a direct
531  * manner, since when dealing with meta-transactions the account sending and
532  * paying for execution may not be the actual sender (as far as an application
533  * is concerned).
534  *
535  * This contract is only required for intermediate, library-like contracts.
536  */
537 abstract contract Context {
538     function _msgSender() internal view virtual returns (address) {
539         return msg.sender;
540     }
541 
542     function _msgData() internal view virtual returns (bytes calldata) {
543         return msg.data;
544     }
545 }
546 
547 // File: @openzeppelin/contracts/access/Ownable.sol
548 
549 
550 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
551 
552 pragma solidity ^0.8.0;
553 
554 
555 /**
556  * @dev Contract module which provides a basic access control mechanism, where
557  * there is an account (an owner) that can be granted exclusive access to
558  * specific functions.
559  *
560  * By default, the owner account will be the one that deploys the contract. This
561  * can later be changed with {transferOwnership}.
562  *
563  * This module is used through inheritance. It will make available the modifier
564  * `onlyOwner`, which can be applied to your functions to restrict their use to
565  * the owner.
566  */
567 abstract contract Ownable is Context {
568     address private _owner;
569 
570     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
571 
572     /**
573      * @dev Initializes the contract setting the deployer as the initial owner.
574      */
575     constructor() {
576         _transferOwnership(_msgSender());
577     }
578 
579     /**
580      * @dev Throws if called by any account other than the owner.
581      */
582     modifier onlyOwner() {
583         _checkOwner();
584         _;
585     }
586 
587     /**
588      * @dev Returns the address of the current owner.
589      */
590     function owner() public view virtual returns (address) {
591         return _owner;
592     }
593 
594     /**
595      * @dev Throws if the sender is not the owner.
596      */
597     function _checkOwner() internal view virtual {
598         require(owner() == _msgSender(), "Ownable: caller is not the owner");
599     }
600 
601     /**
602      * @dev Leaves the contract without owner. It will not be possible to call
603      * `onlyOwner` functions anymore. Can only be called by the current owner.
604      *
605      * NOTE: Renouncing ownership will leave the contract without an owner,
606      * thereby removing any functionality that is only available to the owner.
607      */
608     function renounceOwnership() public virtual onlyOwner {
609         _transferOwnership(address(0));
610     }
611 
612     /**
613      * @dev Transfers ownership of the contract to a new account (`newOwner`).
614      * Can only be called by the current owner.
615      */
616     function transferOwnership(address newOwner) public virtual onlyOwner {
617         require(newOwner != address(0), "Ownable: new owner is the zero address");
618         _transferOwnership(newOwner);
619     }
620 
621     /**
622      * @dev Transfers ownership of the contract to a new account (`newOwner`).
623      * Internal function without access restriction.
624      */
625     function _transferOwnership(address newOwner) internal virtual {
626         address oldOwner = _owner;
627         _owner = newOwner;
628         emit OwnershipTransferred(oldOwner, newOwner);
629     }
630 }
631 
632 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
633 
634 
635 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
636 
637 pragma solidity ^0.8.0;
638 
639 
640 
641 
642 /**
643  * @dev Implementation of the {IERC20} interface.
644  *
645  * This implementation is agnostic to the way tokens are created. This means
646  * that a supply mechanism has to be added in a derived contract using {_mint}.
647  * For a generic mechanism see {ERC20PresetMinterPauser}.
648  *
649  * TIP: For a detailed writeup see our guide
650  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
651  * to implement supply mechanisms].
652  *
653  * We have followed general OpenZeppelin Contracts guidelines: functions revert
654  * instead returning `false` on failure. This behavior is nonetheless
655  * conventional and does not conflict with the expectations of ERC20
656  * applications.
657  *
658  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
659  * This allows applications to reconstruct the allowance for all accounts just
660  * by listening to said events. Other implementations of the EIP may not emit
661  * these events, as it isn't required by the specification.
662  *
663  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
664  * functions have been added to mitigate the well-known issues around setting
665  * allowances. See {IERC20-approve}.
666  */
667 contract ERC20 is Context, IERC20, IERC20Metadata {
668     mapping(address => uint256) private _balances;
669 
670     mapping(address => mapping(address => uint256)) private _allowances;
671 
672     uint256 private _totalSupply;
673 
674     string private _name;
675     string private _symbol;
676 
677     /**
678      * @dev Sets the values for {name} and {symbol}.
679      *
680      * The default value of {decimals} is 18. To select a different value for
681      * {decimals} you should overload it.
682      *
683      * All two of these values are immutable: they can only be set once during
684      * construction.
685      */
686     constructor(string memory name_, string memory symbol_) {
687         _name = name_;
688         _symbol = symbol_;
689     }
690 
691     /**
692      * @dev Returns the name of the token.
693      */
694     function name() public view virtual override returns (string memory) {
695         return _name;
696     }
697 
698     /**
699      * @dev Returns the symbol of the token, usually a shorter version of the
700      * name.
701      */
702     function symbol() public view virtual override returns (string memory) {
703         return _symbol;
704     }
705 
706     /**
707      * @dev Returns the number of decimals used to get its user representation.
708      * For example, if `decimals` equals `2`, a balance of `505` tokens should
709      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
710      *
711      * Tokens usually opt for a value of 18, imitating the relationship between
712      * Ether and Wei. This is the value {ERC20} uses, unless this function is
713      * overridden;
714      *
715      * NOTE: This information is only used for _display_ purposes: it in
716      * no way affects any of the arithmetic of the contract, including
717      * {IERC20-balanceOf} and {IERC20-transfer}.
718      */
719     function decimals() public view virtual override returns (uint8) {
720         return 18;
721     }
722 
723     /**
724      * @dev See {IERC20-totalSupply}.
725      */
726     function totalSupply() public view virtual override returns (uint256) {
727         return _totalSupply;
728     }
729 
730     /**
731      * @dev See {IERC20-balanceOf}.
732      */
733     function balanceOf(address account) public view virtual override returns (uint256) {
734         return _balances[account];
735     }
736 
737     /**
738      * @dev See {IERC20-transfer}.
739      *
740      * Requirements:
741      *
742      * - `to` cannot be the zero address.
743      * - the caller must have a balance of at least `amount`.
744      */
745     function transfer(address to, uint256 amount) public virtual override returns (bool) {
746         address owner = _msgSender();
747         _transfer(owner, to, amount);
748         return true;
749     }
750 
751     /**
752      * @dev See {IERC20-allowance}.
753      */
754     function allowance(address owner, address spender) public view virtual override returns (uint256) {
755         return _allowances[owner][spender];
756     }
757 
758     /**
759      * @dev See {IERC20-approve}.
760      *
761      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
762      * `transferFrom`. This is semantically equivalent to an infinite approval.
763      *
764      * Requirements:
765      *
766      * - `spender` cannot be the zero address.
767      */
768     function approve(address spender, uint256 amount) public virtual override returns (bool) {
769         address owner = _msgSender();
770         _approve(owner, spender, amount);
771         return true;
772     }
773 
774     /**
775      * @dev See {IERC20-transferFrom}.
776      *
777      * Emits an {Approval} event indicating the updated allowance. This is not
778      * required by the EIP. See the note at the beginning of {ERC20}.
779      *
780      * NOTE: Does not update the allowance if the current allowance
781      * is the maximum `uint256`.
782      *
783      * Requirements:
784      *
785      * - `from` and `to` cannot be the zero address.
786      * - `from` must have a balance of at least `amount`.
787      * - the caller must have allowance for ``from``'s tokens of at least
788      * `amount`.
789      */
790     function transferFrom(
791         address from,
792         address to,
793         uint256 amount
794     ) public virtual override returns (bool) {
795         address spender = _msgSender();
796         _spendAllowance(from, spender, amount);
797         _transfer(from, to, amount);
798         return true;
799     }
800 
801     /**
802      * @dev Atomically increases the allowance granted to `spender` by the caller.
803      *
804      * This is an alternative to {approve} that can be used as a mitigation for
805      * problems described in {IERC20-approve}.
806      *
807      * Emits an {Approval} event indicating the updated allowance.
808      *
809      * Requirements:
810      *
811      * - `spender` cannot be the zero address.
812      */
813     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
814         address owner = _msgSender();
815         _approve(owner, spender, allowance(owner, spender) + addedValue);
816         return true;
817     }
818 
819     /**
820      * @dev Atomically decreases the allowance granted to `spender` by the caller.
821      *
822      * This is an alternative to {approve} that can be used as a mitigation for
823      * problems described in {IERC20-approve}.
824      *
825      * Emits an {Approval} event indicating the updated allowance.
826      *
827      * Requirements:
828      *
829      * - `spender` cannot be the zero address.
830      * - `spender` must have allowance for the caller of at least
831      * `subtractedValue`.
832      */
833     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
834         address owner = _msgSender();
835         uint256 currentAllowance = allowance(owner, spender);
836         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
837         unchecked {
838             _approve(owner, spender, currentAllowance - subtractedValue);
839         }
840 
841         return true;
842     }
843 
844     /**
845      * @dev Moves `amount` of tokens from `from` to `to`.
846      *
847      * This internal function is equivalent to {transfer}, and can be used to
848      * e.g. implement automatic token fees, slashing mechanisms, etc.
849      *
850      * Emits a {Transfer} event.
851      *
852      * Requirements:
853      *
854      * - `from` cannot be the zero address.
855      * - `to` cannot be the zero address.
856      * - `from` must have a balance of at least `amount`.
857      */
858     function _transfer(
859         address from,
860         address to,
861         uint256 amount
862     ) internal virtual {
863         require(from != address(0), "ERC20: transfer from the zero address");
864         require(to != address(0), "ERC20: transfer to the zero address");
865 
866         _beforeTokenTransfer(from, to, amount);
867 
868         uint256 fromBalance = _balances[from];
869         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
870         unchecked {
871             _balances[from] = fromBalance - amount;
872         }
873         _balances[to] += amount;
874 
875         emit Transfer(from, to, amount);
876 
877         _afterTokenTransfer(from, to, amount);
878     }
879 
880     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
881      * the total supply.
882      *
883      * Emits a {Transfer} event with `from` set to the zero address.
884      *
885      * Requirements:
886      *
887      * - `account` cannot be the zero address.
888      */
889     function _mint(address account, uint256 amount) internal virtual {
890         require(account != address(0), "ERC20: mint to the zero address");
891 
892         _beforeTokenTransfer(address(0), account, amount);
893 
894         _totalSupply += amount;
895         _balances[account] += amount;
896         emit Transfer(address(0), account, amount);
897 
898         _afterTokenTransfer(address(0), account, amount);
899     }
900 
901     /**
902      * @dev Destroys `amount` tokens from `account`, reducing the
903      * total supply.
904      *
905      * Emits a {Transfer} event with `to` set to the zero address.
906      *
907      * Requirements:
908      *
909      * - `account` cannot be the zero address.
910      * - `account` must have at least `amount` tokens.
911      */
912     function _burn(address account, uint256 amount) internal virtual {
913         require(account != address(0), "ERC20: burn from the zero address");
914 
915         _beforeTokenTransfer(account, address(0), amount);
916 
917         uint256 accountBalance = _balances[account];
918         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
919         unchecked {
920             _balances[account] = accountBalance - amount;
921         }
922         _totalSupply -= amount;
923 
924         emit Transfer(account, address(0), amount);
925 
926         _afterTokenTransfer(account, address(0), amount);
927     }
928 
929     /**
930      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
931      *
932      * This internal function is equivalent to `approve`, and can be used to
933      * e.g. set automatic allowances for certain subsystems, etc.
934      *
935      * Emits an {Approval} event.
936      *
937      * Requirements:
938      *
939      * - `owner` cannot be the zero address.
940      * - `spender` cannot be the zero address.
941      */
942     function _approve(
943         address owner,
944         address spender,
945         uint256 amount
946     ) internal virtual {
947         require(owner != address(0), "ERC20: approve from the zero address");
948         require(spender != address(0), "ERC20: approve to the zero address");
949 
950         _allowances[owner][spender] = amount;
951         emit Approval(owner, spender, amount);
952     }
953 
954     /**
955      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
956      *
957      * Does not update the allowance amount in case of infinite allowance.
958      * Revert if not enough allowance is available.
959      *
960      * Might emit an {Approval} event.
961      */
962     function _spendAllowance(
963         address owner,
964         address spender,
965         uint256 amount
966     ) internal virtual {
967         uint256 currentAllowance = allowance(owner, spender);
968         if (currentAllowance != type(uint256).max) {
969             require(currentAllowance >= amount, "ERC20: insufficient allowance");
970             unchecked {
971                 _approve(owner, spender, currentAllowance - amount);
972             }
973         }
974     }
975 
976     /**
977      * @dev Hook that is called before any transfer of tokens. This includes
978      * minting and burning.
979      *
980      * Calling conditions:
981      *
982      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
983      * will be transferred to `to`.
984      * - when `from` is zero, `amount` tokens will be minted for `to`.
985      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
986      * - `from` and `to` are never both zero.
987      *
988      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
989      */
990     function _beforeTokenTransfer(
991         address from,
992         address to,
993         uint256 amount
994     ) internal virtual {}
995 
996     /**
997      * @dev Hook that is called after any transfer of tokens. This includes
998      * minting and burning.
999      *
1000      * Calling conditions:
1001      *
1002      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1003      * has been transferred to `to`.
1004      * - when `from` is zero, `amount` tokens have been minted for `to`.
1005      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1006      * - `from` and `to` are never both zero.
1007      *
1008      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1009      */
1010     function _afterTokenTransfer(
1011         address from,
1012         address to,
1013         uint256 amount
1014     ) internal virtual {}
1015 }
1016 
1017 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
1018 
1019 
1020 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
1021 
1022 pragma solidity ^0.8.0;
1023 
1024 
1025 
1026 /**
1027  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1028  * tokens and those that they have an allowance for, in a way that can be
1029  * recognized off-chain (via event analysis).
1030  */
1031 abstract contract ERC20Burnable is Context, ERC20 {
1032     /**
1033      * @dev Destroys `amount` tokens from the caller.
1034      *
1035      * See {ERC20-_burn}.
1036      */
1037     function burn(uint256 amount) public virtual {
1038         _burn(_msgSender(), amount);
1039     }
1040 
1041     /**
1042      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1043      * allowance.
1044      *
1045      * See {ERC20-_burn} and {ERC20-allowance}.
1046      *
1047      * Requirements:
1048      *
1049      * - the caller must have allowance for ``accounts``'s tokens of at least
1050      * `amount`.
1051      */
1052     function burnFrom(address account, uint256 amount) public virtual {
1053         _spendAllowance(account, _msgSender(), amount);
1054         _burn(account, amount);
1055     }
1056 }
1057 
1058 // File: @openzeppelin/contracts/utils/Address.sol
1059 
1060 
1061 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
1062 
1063 pragma solidity ^0.8.1;
1064 
1065 /**
1066  * @dev Collection of functions related to the address type
1067  */
1068 library Address {
1069     /**
1070      * @dev Returns true if `account` is a contract.
1071      *
1072      * [IMPORTANT]
1073      * ====
1074      * It is unsafe to assume that an address for which this function returns
1075      * false is an externally-owned account (EOA) and not a contract.
1076      *
1077      * Among others, `isContract` will return false for the following
1078      * types of addresses:
1079      *
1080      *  - an externally-owned account
1081      *  - a contract in construction
1082      *  - an address where a contract will be created
1083      *  - an address where a contract lived, but was destroyed
1084      * ====
1085      *
1086      * [IMPORTANT]
1087      * ====
1088      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1089      *
1090      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1091      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1092      * constructor.
1093      * ====
1094      */
1095     function isContract(address account) internal view returns (bool) {
1096         // This method relies on extcodesize/address.code.length, which returns 0
1097         // for contracts in construction, since the code is only stored at the end
1098         // of the constructor execution.
1099 
1100         return account.code.length > 0;
1101     }
1102 
1103     /**
1104      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1105      * `recipient`, forwarding all available gas and reverting on errors.
1106      *
1107      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1108      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1109      * imposed by `transfer`, making them unable to receive funds via
1110      * `transfer`. {sendValue} removes this limitation.
1111      *
1112      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1113      *
1114      * IMPORTANT: because control is transferred to `recipient`, care must be
1115      * taken to not create reentrancy vulnerabilities. Consider using
1116      * {ReentrancyGuard} or the
1117      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1118      */
1119     function sendValue(address payable recipient, uint256 amount) internal {
1120         require(address(this).balance >= amount, "Address: insufficient balance");
1121 
1122         (bool success, ) = recipient.call{value: amount}("");
1123         require(success, "Address: unable to send value, recipient may have reverted");
1124     }
1125 
1126     /**
1127      * @dev Performs a Solidity function call using a low level `call`. A
1128      * plain `call` is an unsafe replacement for a function call: use this
1129      * function instead.
1130      *
1131      * If `target` reverts with a revert reason, it is bubbled up by this
1132      * function (like regular Solidity function calls).
1133      *
1134      * Returns the raw returned data. To convert to the expected return value,
1135      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1136      *
1137      * Requirements:
1138      *
1139      * - `target` must be a contract.
1140      * - calling `target` with `data` must not revert.
1141      *
1142      * _Available since v3.1._
1143      */
1144     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1145         return functionCall(target, data, "Address: low-level call failed");
1146     }
1147 
1148     /**
1149      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1150      * `errorMessage` as a fallback revert reason when `target` reverts.
1151      *
1152      * _Available since v3.1._
1153      */
1154     function functionCall(
1155         address target,
1156         bytes memory data,
1157         string memory errorMessage
1158     ) internal returns (bytes memory) {
1159         return functionCallWithValue(target, data, 0, errorMessage);
1160     }
1161 
1162     /**
1163      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1164      * but also transferring `value` wei to `target`.
1165      *
1166      * Requirements:
1167      *
1168      * - the calling contract must have an ETH balance of at least `value`.
1169      * - the called Solidity function must be `payable`.
1170      *
1171      * _Available since v3.1._
1172      */
1173     function functionCallWithValue(
1174         address target,
1175         bytes memory data,
1176         uint256 value
1177     ) internal returns (bytes memory) {
1178         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1179     }
1180 
1181     /**
1182      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1183      * with `errorMessage` as a fallback revert reason when `target` reverts.
1184      *
1185      * _Available since v3.1._
1186      */
1187     function functionCallWithValue(
1188         address target,
1189         bytes memory data,
1190         uint256 value,
1191         string memory errorMessage
1192     ) internal returns (bytes memory) {
1193         require(address(this).balance >= value, "Address: insufficient balance for call");
1194         require(isContract(target), "Address: call to non-contract");
1195 
1196         (bool success, bytes memory returndata) = target.call{value: value}(data);
1197         return verifyCallResult(success, returndata, errorMessage);
1198     }
1199 
1200     /**
1201      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1202      * but performing a static call.
1203      *
1204      * _Available since v3.3._
1205      */
1206     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1207         return functionStaticCall(target, data, "Address: low-level static call failed");
1208     }
1209 
1210     /**
1211      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1212      * but performing a static call.
1213      *
1214      * _Available since v3.3._
1215      */
1216     function functionStaticCall(
1217         address target,
1218         bytes memory data,
1219         string memory errorMessage
1220     ) internal view returns (bytes memory) {
1221         require(isContract(target), "Address: static call to non-contract");
1222 
1223         (bool success, bytes memory returndata) = target.staticcall(data);
1224         return verifyCallResult(success, returndata, errorMessage);
1225     }
1226 
1227     /**
1228      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1229      * but performing a delegate call.
1230      *
1231      * _Available since v3.4._
1232      */
1233     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1234         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1235     }
1236 
1237     /**
1238      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1239      * but performing a delegate call.
1240      *
1241      * _Available since v3.4._
1242      */
1243     function functionDelegateCall(
1244         address target,
1245         bytes memory data,
1246         string memory errorMessage
1247     ) internal returns (bytes memory) {
1248         require(isContract(target), "Address: delegate call to non-contract");
1249 
1250         (bool success, bytes memory returndata) = target.delegatecall(data);
1251         return verifyCallResult(success, returndata, errorMessage);
1252     }
1253 
1254     /**
1255      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1256      * revert reason using the provided one.
1257      *
1258      * _Available since v4.3._
1259      */
1260     function verifyCallResult(
1261         bool success,
1262         bytes memory returndata,
1263         string memory errorMessage
1264     ) internal pure returns (bytes memory) {
1265         if (success) {
1266             return returndata;
1267         } else {
1268             // Look for revert reason and bubble it up if present
1269             if (returndata.length > 0) {
1270                 // The easiest way to bubble the revert reason is using memory via assembly
1271                 /// @solidity memory-safe-assembly
1272                 assembly {
1273                     let returndata_size := mload(returndata)
1274                     revert(add(32, returndata), returndata_size)
1275                 }
1276             } else {
1277                 revert(errorMessage);
1278             }
1279         }
1280     }
1281 }
1282 
1283 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1284 
1285 
1286 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1287 
1288 pragma solidity ^0.8.0;
1289 
1290 /**
1291  * @dev Interface of the ERC165 standard, as defined in the
1292  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1293  *
1294  * Implementers can declare support of contract interfaces, which can then be
1295  * queried by others ({ERC165Checker}).
1296  *
1297  * For an implementation, see {ERC165}.
1298  */
1299 interface IERC165 {
1300     /**
1301      * @dev Returns true if this contract implements the interface defined by
1302      * `interfaceId`. See the corresponding
1303      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1304      * to learn more about how these ids are created.
1305      *
1306      * This function call must use less than 30 000 gas.
1307      */
1308     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1309 }
1310 
1311 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1312 
1313 
1314 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1315 
1316 pragma solidity ^0.8.0;
1317 
1318 
1319 /**
1320  * @dev Implementation of the {IERC165} interface.
1321  *
1322  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1323  * for the additional interface id that will be supported. For example:
1324  *
1325  * ```solidity
1326  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1327  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1328  * }
1329  * ```
1330  *
1331  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1332  */
1333 abstract contract ERC165 is IERC165 {
1334     /**
1335      * @dev See {IERC165-supportsInterface}.
1336      */
1337     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1338         return interfaceId == type(IERC165).interfaceId;
1339     }
1340 }
1341 
1342 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
1343 
1344 
1345 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
1346 
1347 pragma solidity ^0.8.0;
1348 
1349 
1350 /**
1351  * @dev _Available since v3.1._
1352  */
1353 interface IERC1155Receiver is IERC165 {
1354     /**
1355      * @dev Handles the receipt of a single ERC1155 token type. This function is
1356      * called at the end of a `safeTransferFrom` after the balance has been updated.
1357      *
1358      * NOTE: To accept the transfer, this must return
1359      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
1360      * (i.e. 0xf23a6e61, or its own function selector).
1361      *
1362      * @param operator The address which initiated the transfer (i.e. msg.sender)
1363      * @param from The address which previously owned the token
1364      * @param id The ID of the token being transferred
1365      * @param value The amount of tokens being transferred
1366      * @param data Additional data with no specified format
1367      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
1368      */
1369     function onERC1155Received(
1370         address operator,
1371         address from,
1372         uint256 id,
1373         uint256 value,
1374         bytes calldata data
1375     ) external returns (bytes4);
1376 
1377     /**
1378      * @dev Handles the receipt of a multiple ERC1155 token types. This function
1379      * is called at the end of a `safeBatchTransferFrom` after the balances have
1380      * been updated.
1381      *
1382      * NOTE: To accept the transfer(s), this must return
1383      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
1384      * (i.e. 0xbc197c81, or its own function selector).
1385      *
1386      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
1387      * @param from The address which previously owned the token
1388      * @param ids An array containing ids of each token being transferred (order and length must match values array)
1389      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
1390      * @param data Additional data with no specified format
1391      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
1392      */
1393     function onERC1155BatchReceived(
1394         address operator,
1395         address from,
1396         uint256[] calldata ids,
1397         uint256[] calldata values,
1398         bytes calldata data
1399     ) external returns (bytes4);
1400 }
1401 
1402 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
1403 
1404 
1405 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
1406 
1407 pragma solidity ^0.8.0;
1408 
1409 
1410 /**
1411  * @dev Required interface of an ERC1155 compliant contract, as defined in the
1412  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
1413  *
1414  * _Available since v3.1._
1415  */
1416 interface IERC1155 is IERC165 {
1417     /**
1418      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
1419      */
1420     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
1421 
1422     /**
1423      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
1424      * transfers.
1425      */
1426     event TransferBatch(
1427         address indexed operator,
1428         address indexed from,
1429         address indexed to,
1430         uint256[] ids,
1431         uint256[] values
1432     );
1433 
1434     /**
1435      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
1436      * `approved`.
1437      */
1438     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
1439 
1440     /**
1441      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
1442      *
1443      * If an {URI} event was emitted for `id`, the standard
1444      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
1445      * returned by {IERC1155MetadataURI-uri}.
1446      */
1447     event URI(string value, uint256 indexed id);
1448 
1449     /**
1450      * @dev Returns the amount of tokens of token type `id` owned by `account`.
1451      *
1452      * Requirements:
1453      *
1454      * - `account` cannot be the zero address.
1455      */
1456     function balanceOf(address account, uint256 id) external view returns (uint256);
1457 
1458     /**
1459      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
1460      *
1461      * Requirements:
1462      *
1463      * - `accounts` and `ids` must have the same length.
1464      */
1465     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
1466         external
1467         view
1468         returns (uint256[] memory);
1469 
1470     /**
1471      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
1472      *
1473      * Emits an {ApprovalForAll} event.
1474      *
1475      * Requirements:
1476      *
1477      * - `operator` cannot be the caller.
1478      */
1479     function setApprovalForAll(address operator, bool approved) external;
1480 
1481     /**
1482      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
1483      *
1484      * See {setApprovalForAll}.
1485      */
1486     function isApprovedForAll(address account, address operator) external view returns (bool);
1487 
1488     /**
1489      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1490      *
1491      * Emits a {TransferSingle} event.
1492      *
1493      * Requirements:
1494      *
1495      * - `to` cannot be the zero address.
1496      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
1497      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1498      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1499      * acceptance magic value.
1500      */
1501     function safeTransferFrom(
1502         address from,
1503         address to,
1504         uint256 id,
1505         uint256 amount,
1506         bytes calldata data
1507     ) external;
1508 
1509     /**
1510      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
1511      *
1512      * Emits a {TransferBatch} event.
1513      *
1514      * Requirements:
1515      *
1516      * - `ids` and `amounts` must have the same length.
1517      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1518      * acceptance magic value.
1519      */
1520     function safeBatchTransferFrom(
1521         address from,
1522         address to,
1523         uint256[] calldata ids,
1524         uint256[] calldata amounts,
1525         bytes calldata data
1526     ) external;
1527 }
1528 
1529 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
1530 
1531 
1532 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
1533 
1534 pragma solidity ^0.8.0;
1535 
1536 
1537 /**
1538  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
1539  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
1540  *
1541  * _Available since v3.1._
1542  */
1543 interface IERC1155MetadataURI is IERC1155 {
1544     /**
1545      * @dev Returns the URI for token type `id`.
1546      *
1547      * If the `\{id\}` substring is present in the URI, it must be replaced by
1548      * clients with the actual token type ID.
1549      */
1550     function uri(uint256 id) external view returns (string memory);
1551 }
1552 
1553 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
1554 
1555 
1556 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/ERC1155.sol)
1557 
1558 pragma solidity ^0.8.0;
1559 
1560 
1561 
1562 
1563 
1564 
1565 
1566 /**
1567  * @dev Implementation of the basic standard multi-token.
1568  * See https://eips.ethereum.org/EIPS/eip-1155
1569  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
1570  *
1571  * _Available since v3.1._
1572  */
1573 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
1574     using Address for address;
1575 
1576     // Mapping from token ID to account balances
1577     mapping(uint256 => mapping(address => uint256)) private _balances;
1578 
1579     // Mapping from account to operator approvals
1580     mapping(address => mapping(address => bool)) private _operatorApprovals;
1581 
1582     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
1583     string private _uri;
1584 
1585     /**
1586      * @dev See {_setURI}.
1587      */
1588     constructor(string memory uri_) {
1589         _setURI(uri_);
1590     }
1591 
1592     /**
1593      * @dev See {IERC165-supportsInterface}.
1594      */
1595     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1596         return
1597             interfaceId == type(IERC1155).interfaceId ||
1598             interfaceId == type(IERC1155MetadataURI).interfaceId ||
1599             super.supportsInterface(interfaceId);
1600     }
1601 
1602     /**
1603      * @dev See {IERC1155MetadataURI-uri}.
1604      *
1605      * This implementation returns the same URI for *all* token types. It relies
1606      * on the token type ID substitution mechanism
1607      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1608      *
1609      * Clients calling this function must replace the `\{id\}` substring with the
1610      * actual token type ID.
1611      */
1612     function uri(uint256) public view virtual override returns (string memory) {
1613         return _uri;
1614     }
1615 
1616     /**
1617      * @dev See {IERC1155-balanceOf}.
1618      *
1619      * Requirements:
1620      *
1621      * - `account` cannot be the zero address.
1622      */
1623     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
1624         require(account != address(0), "ERC1155: address zero is not a valid owner");
1625         return _balances[id][account];
1626     }
1627 
1628     /**
1629      * @dev See {IERC1155-balanceOfBatch}.
1630      *
1631      * Requirements:
1632      *
1633      * - `accounts` and `ids` must have the same length.
1634      */
1635     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
1636         public
1637         view
1638         virtual
1639         override
1640         returns (uint256[] memory)
1641     {
1642         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
1643 
1644         uint256[] memory batchBalances = new uint256[](accounts.length);
1645 
1646         for (uint256 i = 0; i < accounts.length; ++i) {
1647             batchBalances[i] = balanceOf(accounts[i], ids[i]);
1648         }
1649 
1650         return batchBalances;
1651     }
1652 
1653     /**
1654      * @dev See {IERC1155-setApprovalForAll}.
1655      */
1656     function setApprovalForAll(address operator, bool approved) public virtual override {
1657         _setApprovalForAll(_msgSender(), operator, approved);
1658     }
1659 
1660     /**
1661      * @dev See {IERC1155-isApprovedForAll}.
1662      */
1663     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
1664         return _operatorApprovals[account][operator];
1665     }
1666 
1667     /**
1668      * @dev See {IERC1155-safeTransferFrom}.
1669      */
1670     function safeTransferFrom(
1671         address from,
1672         address to,
1673         uint256 id,
1674         uint256 amount,
1675         bytes memory data
1676     ) public virtual override {
1677         require(
1678             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1679             "ERC1155: caller is not token owner nor approved"
1680         );
1681         _safeTransferFrom(from, to, id, amount, data);
1682     }
1683 
1684     /**
1685      * @dev See {IERC1155-safeBatchTransferFrom}.
1686      */
1687     function safeBatchTransferFrom(
1688         address from,
1689         address to,
1690         uint256[] memory ids,
1691         uint256[] memory amounts,
1692         bytes memory data
1693     ) public virtual override {
1694         require(
1695             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1696             "ERC1155: caller is not token owner nor approved"
1697         );
1698         _safeBatchTransferFrom(from, to, ids, amounts, data);
1699     }
1700 
1701     /**
1702      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1703      *
1704      * Emits a {TransferSingle} event.
1705      *
1706      * Requirements:
1707      *
1708      * - `to` cannot be the zero address.
1709      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1710      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1711      * acceptance magic value.
1712      */
1713     function _safeTransferFrom(
1714         address from,
1715         address to,
1716         uint256 id,
1717         uint256 amount,
1718         bytes memory data
1719     ) internal virtual {
1720         require(to != address(0), "ERC1155: transfer to the zero address");
1721 
1722         address operator = _msgSender();
1723         uint256[] memory ids = _asSingletonArray(id);
1724         uint256[] memory amounts = _asSingletonArray(amount);
1725 
1726         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1727 
1728         uint256 fromBalance = _balances[id][from];
1729         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1730         unchecked {
1731             _balances[id][from] = fromBalance - amount;
1732         }
1733         _balances[id][to] += amount;
1734 
1735         emit TransferSingle(operator, from, to, id, amount);
1736 
1737         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1738 
1739         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1740     }
1741 
1742     /**
1743      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1744      *
1745      * Emits a {TransferBatch} event.
1746      *
1747      * Requirements:
1748      *
1749      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1750      * acceptance magic value.
1751      */
1752     function _safeBatchTransferFrom(
1753         address from,
1754         address to,
1755         uint256[] memory ids,
1756         uint256[] memory amounts,
1757         bytes memory data
1758     ) internal virtual {
1759         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1760         require(to != address(0), "ERC1155: transfer to the zero address");
1761 
1762         address operator = _msgSender();
1763 
1764         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1765 
1766         for (uint256 i = 0; i < ids.length; ++i) {
1767             uint256 id = ids[i];
1768             uint256 amount = amounts[i];
1769 
1770             uint256 fromBalance = _balances[id][from];
1771             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1772             unchecked {
1773                 _balances[id][from] = fromBalance - amount;
1774             }
1775             _balances[id][to] += amount;
1776         }
1777 
1778         emit TransferBatch(operator, from, to, ids, amounts);
1779 
1780         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1781 
1782         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1783     }
1784 
1785     /**
1786      * @dev Sets a new URI for all token types, by relying on the token type ID
1787      * substitution mechanism
1788      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1789      *
1790      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1791      * URI or any of the amounts in the JSON file at said URI will be replaced by
1792      * clients with the token type ID.
1793      *
1794      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1795      * interpreted by clients as
1796      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1797      * for token type ID 0x4cce0.
1798      *
1799      * See {uri}.
1800      *
1801      * Because these URIs cannot be meaningfully represented by the {URI} event,
1802      * this function emits no events.
1803      */
1804     function _setURI(string memory newuri) internal virtual {
1805         _uri = newuri;
1806     }
1807 
1808     /**
1809      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
1810      *
1811      * Emits a {TransferSingle} event.
1812      *
1813      * Requirements:
1814      *
1815      * - `to` cannot be the zero address.
1816      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1817      * acceptance magic value.
1818      */
1819     function _mint(
1820         address to,
1821         uint256 id,
1822         uint256 amount,
1823         bytes memory data
1824     ) internal virtual {
1825         require(to != address(0), "ERC1155: mint to the zero address");
1826 
1827         address operator = _msgSender();
1828         uint256[] memory ids = _asSingletonArray(id);
1829         uint256[] memory amounts = _asSingletonArray(amount);
1830 
1831         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1832 
1833         _balances[id][to] += amount;
1834         emit TransferSingle(operator, address(0), to, id, amount);
1835 
1836         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1837 
1838         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
1839     }
1840 
1841     /**
1842      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1843      *
1844      * Emits a {TransferBatch} event.
1845      *
1846      * Requirements:
1847      *
1848      * - `ids` and `amounts` must have the same length.
1849      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1850      * acceptance magic value.
1851      */
1852     function _mintBatch(
1853         address to,
1854         uint256[] memory ids,
1855         uint256[] memory amounts,
1856         bytes memory data
1857     ) internal virtual {
1858         require(to != address(0), "ERC1155: mint to the zero address");
1859         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1860 
1861         address operator = _msgSender();
1862 
1863         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1864 
1865         for (uint256 i = 0; i < ids.length; i++) {
1866             _balances[ids[i]][to] += amounts[i];
1867         }
1868 
1869         emit TransferBatch(operator, address(0), to, ids, amounts);
1870 
1871         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1872 
1873         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1874     }
1875 
1876     /**
1877      * @dev Destroys `amount` tokens of token type `id` from `from`
1878      *
1879      * Emits a {TransferSingle} event.
1880      *
1881      * Requirements:
1882      *
1883      * - `from` cannot be the zero address.
1884      * - `from` must have at least `amount` tokens of token type `id`.
1885      */
1886     function _burn(
1887         address from,
1888         uint256 id,
1889         uint256 amount
1890     ) internal virtual {
1891         require(from != address(0), "ERC1155: burn from the zero address");
1892 
1893         address operator = _msgSender();
1894         uint256[] memory ids = _asSingletonArray(id);
1895         uint256[] memory amounts = _asSingletonArray(amount);
1896 
1897         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1898 
1899         uint256 fromBalance = _balances[id][from];
1900         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1901         unchecked {
1902             _balances[id][from] = fromBalance - amount;
1903         }
1904 
1905         emit TransferSingle(operator, from, address(0), id, amount);
1906 
1907         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1908     }
1909 
1910     /**
1911      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1912      *
1913      * Emits a {TransferBatch} event.
1914      *
1915      * Requirements:
1916      *
1917      * - `ids` and `amounts` must have the same length.
1918      */
1919     function _burnBatch(
1920         address from,
1921         uint256[] memory ids,
1922         uint256[] memory amounts
1923     ) internal virtual {
1924         require(from != address(0), "ERC1155: burn from the zero address");
1925         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1926 
1927         address operator = _msgSender();
1928 
1929         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1930 
1931         for (uint256 i = 0; i < ids.length; i++) {
1932             uint256 id = ids[i];
1933             uint256 amount = amounts[i];
1934 
1935             uint256 fromBalance = _balances[id][from];
1936             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1937             unchecked {
1938                 _balances[id][from] = fromBalance - amount;
1939             }
1940         }
1941 
1942         emit TransferBatch(operator, from, address(0), ids, amounts);
1943 
1944         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1945     }
1946 
1947     /**
1948      * @dev Approve `operator` to operate on all of `owner` tokens
1949      *
1950      * Emits an {ApprovalForAll} event.
1951      */
1952     function _setApprovalForAll(
1953         address owner,
1954         address operator,
1955         bool approved
1956     ) internal virtual {
1957         require(owner != operator, "ERC1155: setting approval status for self");
1958         _operatorApprovals[owner][operator] = approved;
1959         emit ApprovalForAll(owner, operator, approved);
1960     }
1961 
1962     /**
1963      * @dev Hook that is called before any token transfer. This includes minting
1964      * and burning, as well as batched variants.
1965      *
1966      * The same hook is called on both single and batched variants. For single
1967      * transfers, the length of the `ids` and `amounts` arrays will be 1.
1968      *
1969      * Calling conditions (for each `id` and `amount` pair):
1970      *
1971      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1972      * of token type `id` will be  transferred to `to`.
1973      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1974      * for `to`.
1975      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1976      * will be burned.
1977      * - `from` and `to` are never both zero.
1978      * - `ids` and `amounts` have the same, non-zero length.
1979      *
1980      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1981      */
1982     function _beforeTokenTransfer(
1983         address operator,
1984         address from,
1985         address to,
1986         uint256[] memory ids,
1987         uint256[] memory amounts,
1988         bytes memory data
1989     ) internal virtual {}
1990 
1991     /**
1992      * @dev Hook that is called after any token transfer. This includes minting
1993      * and burning, as well as batched variants.
1994      *
1995      * The same hook is called on both single and batched variants. For single
1996      * transfers, the length of the `id` and `amount` arrays will be 1.
1997      *
1998      * Calling conditions (for each `id` and `amount` pair):
1999      *
2000      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2001      * of token type `id` will be  transferred to `to`.
2002      * - When `from` is zero, `amount` tokens of token type `id` will be minted
2003      * for `to`.
2004      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
2005      * will be burned.
2006      * - `from` and `to` are never both zero.
2007      * - `ids` and `amounts` have the same, non-zero length.
2008      *
2009      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2010      */
2011     function _afterTokenTransfer(
2012         address operator,
2013         address from,
2014         address to,
2015         uint256[] memory ids,
2016         uint256[] memory amounts,
2017         bytes memory data
2018     ) internal virtual {}
2019 
2020     function _doSafeTransferAcceptanceCheck(
2021         address operator,
2022         address from,
2023         address to,
2024         uint256 id,
2025         uint256 amount,
2026         bytes memory data
2027     ) private {
2028         if (to.isContract()) {
2029             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
2030                 if (response != IERC1155Receiver.onERC1155Received.selector) {
2031                     revert("ERC1155: ERC1155Receiver rejected tokens");
2032                 }
2033             } catch Error(string memory reason) {
2034                 revert(reason);
2035             } catch {
2036                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
2037             }
2038         }
2039     }
2040 
2041     function _doSafeBatchTransferAcceptanceCheck(
2042         address operator,
2043         address from,
2044         address to,
2045         uint256[] memory ids,
2046         uint256[] memory amounts,
2047         bytes memory data
2048     ) private {
2049         if (to.isContract()) {
2050             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
2051                 bytes4 response
2052             ) {
2053                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
2054                     revert("ERC1155: ERC1155Receiver rejected tokens");
2055                 }
2056             } catch Error(string memory reason) {
2057                 revert(reason);
2058             } catch {
2059                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
2060             }
2061         }
2062     }
2063 
2064     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
2065         uint256[] memory array = new uint256[](1);
2066         array[0] = element;
2067 
2068         return array;
2069     }
2070 }
2071 
2072 // File: GreenRoomV2.sol
2073 
2074 
2075 
2076 pragma solidity ^0.8.7;
2077 
2078 
2079 
2080 
2081 
2082 
2083 contract GreenRoomV2 is ERC1155, Ownable, EIP712 {
2084     address public immutable showTokenAddr;
2085 
2086     string baseUri;
2087     string contractUri;
2088 
2089     address signerAddress;
2090 
2091     mapping(uint256 => Item) public items;
2092     mapping(uint256 => uint256) public totalSupply;
2093     ERC20Burnable burner;
2094 
2095     enum ItemPurchaseType {
2096         ETH,
2097         SHOW
2098     }
2099     struct Item {
2100         uint256 maxSupply;
2101         uint256 mintLimit;
2102         uint256 price;
2103         ItemPurchaseType purchaseType;
2104         bool active;
2105     }
2106 
2107     constructor() ERC1155("") EIP712("GreenRoomV2", "1.0.0") {
2108         address showAddress = 0x136209a516D1C2660F045e70634c9d95D64325F9;
2109         signerAddress = 0xa2bcd5Cc70E1e568Dd31C475FcB19E8c367B2202;
2110         showTokenAddr = showAddress;
2111         baseUri = "https://greenroom-api.herokuapp.com/items/metadata/";
2112         contractUri = "https://deadheads.mypinata.cloud/ipfs/QmQN2SVL4abr9ZhV75GEBSYQft3ftYE5QdxbxJYa6XNQJA";
2113         burner = ERC20Burnable(showAddress);
2114     }
2115 
2116     function __mint(uint256 itemId, ItemPurchaseType purchaseType, uint256 price, uint256 quantity) internal {
2117         uint256 total = price * quantity;
2118         if (purchaseType == ItemPurchaseType.ETH) {
2119             require(total == msg.value, "Wrong price amount");
2120         } else {
2121             burner.burnFrom(msg.sender, total);
2122         }
2123         totalSupply[itemId] += quantity;
2124         _mint(msg.sender, itemId, quantity, "");
2125     }
2126 
2127     function mint(
2128         uint256 _itemId,
2129         uint256 _quantity
2130     ) public payable {
2131         Item memory item = items[_itemId];
2132         require(item.maxSupply > 0, "item does not exists");
2133         require(item.active, "item is not active");
2134         require(totalSupply[_itemId] < item.maxSupply, "item sold out");
2135         require(
2136             totalSupply[_itemId] + _quantity <= item.maxSupply,
2137             "Quantity exceeds the remaining supply"
2138         );
2139         uint256 balance = balanceOf(msg.sender, _itemId);
2140         require(balance < item.mintLimit, "reached the max max limit for this item.");
2141         require(balance + _quantity <= item.mintLimit, "Quantity exceeds max mint. Try minting less.");
2142         
2143         __mint(_itemId, item.purchaseType, item.price, _quantity);
2144     }
2145 
2146     function createItem(
2147         uint256 _maxSupply,
2148         uint256 _mintLimit,
2149         uint256 _quantity,
2150         uint256 _price,
2151         ItemPurchaseType _purchaseType,
2152         uint256 _itemId,
2153         bytes calldata _signature
2154     ) public payable {
2155         require(
2156             signerAddress ==
2157                 recoverAddress(
2158                     _maxSupply,
2159                     _mintLimit,
2160                     _price,
2161                     _purchaseType,
2162                     _itemId,
2163                     msg.sender,
2164                     _signature
2165                 ),
2166             "Invalid create parameters."
2167         );
2168         if (items[_itemId].maxSupply > 0) {
2169             mint(_itemId, _quantity);
2170         } else {
2171             require(_quantity <= _maxSupply, "Quantity exceeds the supply");
2172             require(_quantity <= _mintLimit, "Quantity exceeds the limit");
2173 
2174             items[_itemId] = Item(_maxSupply, _mintLimit, _price, _purchaseType, true);
2175 
2176             __mint(_itemId, _purchaseType, _price, _quantity);
2177         }
2178     }
2179 
2180     function updateItem(
2181         uint256 _maxSupply,
2182         uint256 _mintLimit,
2183         uint256 _price,
2184         ItemPurchaseType _purchaseType,
2185         bool _active,
2186         uint256 _itemId
2187     ) public onlyOwner {
2188         require(items[_itemId].maxSupply > 0, "item does not exist");
2189         require(_maxSupply > 0, "Max supply must be greater than 0");
2190 
2191         items[_itemId].price = _price;
2192         items[_itemId].purchaseType = _purchaseType;
2193         items[_itemId].maxSupply = _maxSupply;
2194         items[_itemId].mintLimit = _mintLimit;
2195         items[_itemId].active = _active;
2196     }
2197 
2198     function updateItemActive(uint256 _itemId, bool _active) public onlyOwner {
2199         require(items[_itemId].maxSupply > 0, "item does not exist");
2200 
2201         items[_itemId].active = _active;
2202     }
2203 
2204     function setURI(string memory _newURI) external onlyOwner {
2205         super._setURI(_newURI);
2206     }
2207 
2208     function _hash(
2209         uint256 _maxSupply,
2210         uint256 _mintLimit,
2211         uint256 _price,
2212         ItemPurchaseType _purchaseType,
2213         uint256 _id,
2214         address _caller
2215     ) internal view returns (bytes32) {
2216         return
2217             _hashTypedDataV4(
2218                 keccak256(
2219                     abi.encode(
2220                         keccak256(
2221                             "CREATE(uint256 maxSupply,uint256 mintLimit,uint256 price,uint256 purchaseType,uint256 id,address caller)"
2222                         ),
2223                         _maxSupply,
2224                         _mintLimit,
2225                         _price,
2226                         _purchaseType,
2227                         _id,
2228                         _caller
2229                     )
2230                 )
2231             );
2232     }
2233 
2234     function recoverAddress(
2235         uint256 _maxSupply,
2236         uint256 _mintLimit,
2237         uint256 _price,
2238         ItemPurchaseType _purchaseType,
2239         uint256 _id,
2240         address _account,
2241         bytes calldata signature
2242     ) public view returns (address) {
2243         return
2244             ECDSA.recover(
2245                 _hash(_maxSupply, _mintLimit, _price, _purchaseType, _id, _account),
2246                 signature
2247             );
2248     }
2249 
2250     function uri(uint256 _tokenId)
2251         public
2252         view
2253         override
2254         returns (string memory)
2255     {
2256         require(
2257             items[_tokenId].maxSupply > 0,
2258             "ERC1155Metadata: URI query for nonexistent token"
2259         );
2260         return
2261             string(abi.encodePacked(baseUri, Strings.toString(_tokenId), ""));
2262     }
2263 
2264     function setContractURI(string memory _newContractURI) external onlyOwner {
2265         contractUri = _newContractURI;
2266     }
2267 
2268     function contractURI() public view returns (string memory) {
2269         return contractUri;
2270     }
2271 
2272     function setBaseURI(string memory _newBaseURI) external onlyOwner {
2273         baseUri = _newBaseURI;
2274     }
2275 
2276     function setSignerAddress(address _signerAddress) external onlyOwner {
2277         signerAddress = _signerAddress;
2278     }
2279 
2280     function withdrawAll() external onlyOwner {
2281         require(payable(msg.sender).send(address(this).balance));
2282     }
2283 }