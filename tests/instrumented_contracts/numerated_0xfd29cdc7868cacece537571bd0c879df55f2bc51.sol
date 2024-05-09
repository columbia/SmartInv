1 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
10  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
11  *
12  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
13  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
14  * need to send a transaction, and thus is not required to hold Ether at all.
15  */
16 interface IERC20Permit {
17     /**
18      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
19      * given ``owner``'s signed approval.
20      *
21      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
22      * ordering also apply here.
23      *
24      * Emits an {Approval} event.
25      *
26      * Requirements:
27      *
28      * - `spender` cannot be the zero address.
29      * - `deadline` must be a timestamp in the future.
30      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
31      * over the EIP712-formatted function arguments.
32      * - the signature must use ``owner``'s current nonce (see {nonces}).
33      *
34      * For more information on the signature format, see the
35      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
36      * section].
37      */
38     function permit(
39         address owner,
40         address spender,
41         uint256 value,
42         uint256 deadline,
43         uint8 v,
44         bytes32 r,
45         bytes32 s
46     ) external;
47 
48     /**
49      * @dev Returns the current nonce for `owner`. This value must be
50      * included whenever a signature is generated for {permit}.
51      *
52      * Every successful call to {permit} increases ``owner``'s nonce by one. This
53      * prevents a signature from being used multiple times.
54      */
55     function nonces(address owner) external view returns (uint256);
56 
57     /**
58      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
59      */
60     // solhint-disable-next-line func-name-mixedcase
61     function DOMAIN_SEPARATOR() external view returns (bytes32);
62 }
63 
64 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
65 
66 
67 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
68 
69 pragma solidity ^0.8.0;
70 
71 /**
72  * @dev Interface of the ERC20 standard as defined in the EIP.
73  */
74 interface IERC20 {
75     /**
76      * @dev Emitted when `value` tokens are moved from one account (`from`) to
77      * another (`to`).
78      *
79      * Note that `value` may be zero.
80      */
81     event Transfer(address indexed from, address indexed to, uint256 value);
82 
83     /**
84      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
85      * a call to {approve}. `value` is the new allowance.
86      */
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 
89     /**
90      * @dev Returns the amount of tokens in existence.
91      */
92     function totalSupply() external view returns (uint256);
93 
94     /**
95      * @dev Returns the amount of tokens owned by `account`.
96      */
97     function balanceOf(address account) external view returns (uint256);
98 
99     /**
100      * @dev Moves `amount` tokens from the caller's account to `to`.
101      *
102      * Returns a boolean value indicating whether the operation succeeded.
103      *
104      * Emits a {Transfer} event.
105      */
106     function transfer(address to, uint256 amount) external returns (bool);
107 
108     /**
109      * @dev Returns the remaining number of tokens that `spender` will be
110      * allowed to spend on behalf of `owner` through {transferFrom}. This is
111      * zero by default.
112      *
113      * This value changes when {approve} or {transferFrom} are called.
114      */
115     function allowance(address owner, address spender) external view returns (uint256);
116 
117     /**
118      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
119      *
120      * Returns a boolean value indicating whether the operation succeeded.
121      *
122      * IMPORTANT: Beware that changing an allowance with this method brings the risk
123      * that someone may use both the old and the new allowance by unfortunate
124      * transaction ordering. One possible solution to mitigate this race
125      * condition is to first reduce the spender's allowance to 0 and set the
126      * desired value afterwards:
127      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
128      *
129      * Emits an {Approval} event.
130      */
131     function approve(address spender, uint256 amount) external returns (bool);
132 
133     /**
134      * @dev Moves `amount` tokens from `from` to `to` using the
135      * allowance mechanism. `amount` is then deducted from the caller's
136      * allowance.
137      *
138      * Returns a boolean value indicating whether the operation succeeded.
139      *
140      * Emits a {Transfer} event.
141      */
142     function transferFrom(
143         address from,
144         address to,
145         uint256 amount
146     ) external returns (bool);
147 }
148 
149 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
150 
151 
152 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
153 
154 pragma solidity ^0.8.0;
155 
156 /**
157  * @dev Contract module that helps prevent reentrant calls to a function.
158  *
159  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
160  * available, which can be applied to functions to make sure there are no nested
161  * (reentrant) calls to them.
162  *
163  * Note that because there is a single `nonReentrant` guard, functions marked as
164  * `nonReentrant` may not call one another. This can be worked around by making
165  * those functions `private`, and then adding `external` `nonReentrant` entry
166  * points to them.
167  *
168  * TIP: If you would like to learn more about reentrancy and alternative ways
169  * to protect against it, check out our blog post
170  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
171  */
172 abstract contract ReentrancyGuard {
173     // Booleans are more expensive than uint256 or any type that takes up a full
174     // word because each write operation emits an extra SLOAD to first read the
175     // slot's contents, replace the bits taken up by the boolean, and then write
176     // back. This is the compiler's defense against contract upgrades and
177     // pointer aliasing, and it cannot be disabled.
178 
179     // The values being non-zero value makes deployment a bit more expensive,
180     // but in exchange the refund on every call to nonReentrant will be lower in
181     // amount. Since refunds are capped to a percentage of the total
182     // transaction's gas, it is best to keep them low in cases like this one, to
183     // increase the likelihood of the full refund coming into effect.
184     uint256 private constant _NOT_ENTERED = 1;
185     uint256 private constant _ENTERED = 2;
186 
187     uint256 private _status;
188 
189     constructor() {
190         _status = _NOT_ENTERED;
191     }
192 
193     /**
194      * @dev Prevents a contract from calling itself, directly or indirectly.
195      * Calling a `nonReentrant` function from another `nonReentrant`
196      * function is not supported. It is possible to prevent this from happening
197      * by making the `nonReentrant` function external, and making it call a
198      * `private` function that does the actual work.
199      */
200     modifier nonReentrant() {
201         // On the first call to nonReentrant, _notEntered will be true
202         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
203 
204         // Any calls to nonReentrant after this point will fail
205         _status = _ENTERED;
206 
207         _;
208 
209         // By storing the original value once again, a refund is triggered (see
210         // https://eips.ethereum.org/EIPS/eip-2200)
211         _status = _NOT_ENTERED;
212     }
213 }
214 
215 // File: @openzeppelin/contracts/utils/Strings.sol
216 
217 
218 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
219 
220 pragma solidity ^0.8.0;
221 
222 /**
223  * @dev String operations.
224  */
225 library Strings {
226     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
227     uint8 private constant _ADDRESS_LENGTH = 20;
228 
229     /**
230      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
231      */
232     function toString(uint256 value) internal pure returns (string memory) {
233         // Inspired by OraclizeAPI's implementation - MIT licence
234         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
235 
236         if (value == 0) {
237             return "0";
238         }
239         uint256 temp = value;
240         uint256 digits;
241         while (temp != 0) {
242             digits++;
243             temp /= 10;
244         }
245         bytes memory buffer = new bytes(digits);
246         while (value != 0) {
247             digits -= 1;
248             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
249             value /= 10;
250         }
251         return string(buffer);
252     }
253 
254     /**
255      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
256      */
257     function toHexString(uint256 value) internal pure returns (string memory) {
258         if (value == 0) {
259             return "0x00";
260         }
261         uint256 temp = value;
262         uint256 length = 0;
263         while (temp != 0) {
264             length++;
265             temp >>= 8;
266         }
267         return toHexString(value, length);
268     }
269 
270     /**
271      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
272      */
273     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
274         bytes memory buffer = new bytes(2 * length + 2);
275         buffer[0] = "0";
276         buffer[1] = "x";
277         for (uint256 i = 2 * length + 1; i > 1; --i) {
278             buffer[i] = _HEX_SYMBOLS[value & 0xf];
279             value >>= 4;
280         }
281         require(value == 0, "Strings: hex length insufficient");
282         return string(buffer);
283     }
284 
285     /**
286      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
287      */
288     function toHexString(address addr) internal pure returns (string memory) {
289         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
290     }
291 }
292 
293 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
294 
295 
296 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/ECDSA.sol)
297 
298 pragma solidity ^0.8.0;
299 
300 
301 /**
302  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
303  *
304  * These functions can be used to verify that a message was signed by the holder
305  * of the private keys of a given address.
306  */
307 library ECDSA {
308     enum RecoverError {
309         NoError,
310         InvalidSignature,
311         InvalidSignatureLength,
312         InvalidSignatureS,
313         InvalidSignatureV
314     }
315 
316     function _throwError(RecoverError error) private pure {
317         if (error == RecoverError.NoError) {
318             return; // no error: do nothing
319         } else if (error == RecoverError.InvalidSignature) {
320             revert("ECDSA: invalid signature");
321         } else if (error == RecoverError.InvalidSignatureLength) {
322             revert("ECDSA: invalid signature length");
323         } else if (error == RecoverError.InvalidSignatureS) {
324             revert("ECDSA: invalid signature 's' value");
325         } else if (error == RecoverError.InvalidSignatureV) {
326             revert("ECDSA: invalid signature 'v' value");
327         }
328     }
329 
330     /**
331      * @dev Returns the address that signed a hashed message (`hash`) with
332      * `signature` or error string. This address can then be used for verification purposes.
333      *
334      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
335      * this function rejects them by requiring the `s` value to be in the lower
336      * half order, and the `v` value to be either 27 or 28.
337      *
338      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
339      * verification to be secure: it is possible to craft signatures that
340      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
341      * this is by receiving a hash of the original message (which may otherwise
342      * be too long), and then calling {toEthSignedMessageHash} on it.
343      *
344      * Documentation for signature generation:
345      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
346      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
347      *
348      * _Available since v4.3._
349      */
350     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
351         // Check the signature length
352         // - case 65: r,s,v signature (standard)
353         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
354         if (signature.length == 65) {
355             bytes32 r;
356             bytes32 s;
357             uint8 v;
358             // ecrecover takes the signature parameters, and the only way to get them
359             // currently is to use assembly.
360             /// @solidity memory-safe-assembly
361             assembly {
362                 r := mload(add(signature, 0x20))
363                 s := mload(add(signature, 0x40))
364                 v := byte(0, mload(add(signature, 0x60)))
365             }
366             return tryRecover(hash, v, r, s);
367         } else if (signature.length == 64) {
368             bytes32 r;
369             bytes32 vs;
370             // ecrecover takes the signature parameters, and the only way to get them
371             // currently is to use assembly.
372             /// @solidity memory-safe-assembly
373             assembly {
374                 r := mload(add(signature, 0x20))
375                 vs := mload(add(signature, 0x40))
376             }
377             return tryRecover(hash, r, vs);
378         } else {
379             return (address(0), RecoverError.InvalidSignatureLength);
380         }
381     }
382 
383     /**
384      * @dev Returns the address that signed a hashed message (`hash`) with
385      * `signature`. This address can then be used for verification purposes.
386      *
387      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
388      * this function rejects them by requiring the `s` value to be in the lower
389      * half order, and the `v` value to be either 27 or 28.
390      *
391      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
392      * verification to be secure: it is possible to craft signatures that
393      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
394      * this is by receiving a hash of the original message (which may otherwise
395      * be too long), and then calling {toEthSignedMessageHash} on it.
396      */
397     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
398         (address recovered, RecoverError error) = tryRecover(hash, signature);
399         _throwError(error);
400         return recovered;
401     }
402 
403     /**
404      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
405      *
406      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
407      *
408      * _Available since v4.3._
409      */
410     function tryRecover(
411         bytes32 hash,
412         bytes32 r,
413         bytes32 vs
414     ) internal pure returns (address, RecoverError) {
415         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
416         uint8 v = uint8((uint256(vs) >> 255) + 27);
417         return tryRecover(hash, v, r, s);
418     }
419 
420     /**
421      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
422      *
423      * _Available since v4.2._
424      */
425     function recover(
426         bytes32 hash,
427         bytes32 r,
428         bytes32 vs
429     ) internal pure returns (address) {
430         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
431         _throwError(error);
432         return recovered;
433     }
434 
435     /**
436      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
437      * `r` and `s` signature fields separately.
438      *
439      * _Available since v4.3._
440      */
441     function tryRecover(
442         bytes32 hash,
443         uint8 v,
444         bytes32 r,
445         bytes32 s
446     ) internal pure returns (address, RecoverError) {
447         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
448         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
449         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
450         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
451         //
452         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
453         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
454         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
455         // these malleable signatures as well.
456         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
457             return (address(0), RecoverError.InvalidSignatureS);
458         }
459         if (v != 27 && v != 28) {
460             return (address(0), RecoverError.InvalidSignatureV);
461         }
462 
463         // If the signature is valid (and not malleable), return the signer address
464         address signer = ecrecover(hash, v, r, s);
465         if (signer == address(0)) {
466             return (address(0), RecoverError.InvalidSignature);
467         }
468 
469         return (signer, RecoverError.NoError);
470     }
471 
472     /**
473      * @dev Overload of {ECDSA-recover} that receives the `v`,
474      * `r` and `s` signature fields separately.
475      */
476     function recover(
477         bytes32 hash,
478         uint8 v,
479         bytes32 r,
480         bytes32 s
481     ) internal pure returns (address) {
482         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
483         _throwError(error);
484         return recovered;
485     }
486 
487     /**
488      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
489      * produces hash corresponding to the one signed with the
490      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
491      * JSON-RPC method as part of EIP-191.
492      *
493      * See {recover}.
494      */
495     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
496         // 32 is the length in bytes of hash,
497         // enforced by the type signature above
498         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
499     }
500 
501     /**
502      * @dev Returns an Ethereum Signed Message, created from `s`. This
503      * produces hash corresponding to the one signed with the
504      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
505      * JSON-RPC method as part of EIP-191.
506      *
507      * See {recover}.
508      */
509     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
510         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
511     }
512 
513     /**
514      * @dev Returns an Ethereum Signed Typed Data, created from a
515      * `domainSeparator` and a `structHash`. This produces hash corresponding
516      * to the one signed with the
517      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
518      * JSON-RPC method as part of EIP-712.
519      *
520      * See {recover}.
521      */
522     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
523         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
524     }
525 }
526 
527 // File: @openzeppelin/contracts/utils/Context.sol
528 
529 
530 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
531 
532 pragma solidity ^0.8.0;
533 
534 /**
535  * @dev Provides information about the current execution context, including the
536  * sender of the transaction and its data. While these are generally available
537  * via msg.sender and msg.data, they should not be accessed in such a direct
538  * manner, since when dealing with meta-transactions the account sending and
539  * paying for execution may not be the actual sender (as far as an application
540  * is concerned).
541  *
542  * This contract is only required for intermediate, library-like contracts.
543  */
544 abstract contract Context {
545     function _msgSender() internal view virtual returns (address) {
546         return msg.sender;
547     }
548 
549     function _msgData() internal view virtual returns (bytes calldata) {
550         return msg.data;
551     }
552 }
553 
554 // File: @openzeppelin/contracts/access/Ownable.sol
555 
556 
557 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
558 
559 pragma solidity ^0.8.0;
560 
561 
562 /**
563  * @dev Contract module which provides a basic access control mechanism, where
564  * there is an account (an owner) that can be granted exclusive access to
565  * specific functions.
566  *
567  * By default, the owner account will be the one that deploys the contract. This
568  * can later be changed with {transferOwnership}.
569  *
570  * This module is used through inheritance. It will make available the modifier
571  * `onlyOwner`, which can be applied to your functions to restrict their use to
572  * the owner.
573  */
574 abstract contract Ownable is Context {
575     address private _owner;
576 
577     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
578 
579     /**
580      * @dev Initializes the contract setting the deployer as the initial owner.
581      */
582     constructor() {
583         _transferOwnership(_msgSender());
584     }
585 
586     /**
587      * @dev Throws if called by any account other than the owner.
588      */
589     modifier onlyOwner() {
590         _checkOwner();
591         _;
592     }
593 
594     /**
595      * @dev Returns the address of the current owner.
596      */
597     function owner() public view virtual returns (address) {
598         return _owner;
599     }
600 
601     /**
602      * @dev Throws if the sender is not the owner.
603      */
604     function _checkOwner() internal view virtual {
605         require(owner() == _msgSender(), "Ownable: caller is not the owner");
606     }
607 
608     /**
609      * @dev Leaves the contract without owner. It will not be possible to call
610      * `onlyOwner` functions anymore. Can only be called by the current owner.
611      *
612      * NOTE: Renouncing ownership will leave the contract without an owner,
613      * thereby removing any functionality that is only available to the owner.
614      */
615     function renounceOwnership() public virtual onlyOwner {
616         _transferOwnership(address(0));
617     }
618 
619     /**
620      * @dev Transfers ownership of the contract to a new account (`newOwner`).
621      * Can only be called by the current owner.
622      */
623     function transferOwnership(address newOwner) public virtual onlyOwner {
624         require(newOwner != address(0), "Ownable: new owner is the zero address");
625         _transferOwnership(newOwner);
626     }
627 
628     /**
629      * @dev Transfers ownership of the contract to a new account (`newOwner`).
630      * Internal function without access restriction.
631      */
632     function _transferOwnership(address newOwner) internal virtual {
633         address oldOwner = _owner;
634         _owner = newOwner;
635         emit OwnershipTransferred(oldOwner, newOwner);
636     }
637 }
638 
639 // File: @openzeppelin/contracts/utils/Address.sol
640 
641 
642 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
643 
644 pragma solidity ^0.8.1;
645 
646 /**
647  * @dev Collection of functions related to the address type
648  */
649 library Address {
650     /**
651      * @dev Returns true if `account` is a contract.
652      *
653      * [IMPORTANT]
654      * ====
655      * It is unsafe to assume that an address for which this function returns
656      * false is an externally-owned account (EOA) and not a contract.
657      *
658      * Among others, `isContract` will return false for the following
659      * types of addresses:
660      *
661      *  - an externally-owned account
662      *  - a contract in construction
663      *  - an address where a contract will be created
664      *  - an address where a contract lived, but was destroyed
665      * ====
666      *
667      * [IMPORTANT]
668      * ====
669      * You shouldn't rely on `isContract` to protect against flash loan attacks!
670      *
671      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
672      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
673      * constructor.
674      * ====
675      */
676     function isContract(address account) internal view returns (bool) {
677         // This method relies on extcodesize/address.code.length, which returns 0
678         // for contracts in construction, since the code is only stored at the end
679         // of the constructor execution.
680 
681         return account.code.length > 0;
682     }
683 
684     /**
685      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
686      * `recipient`, forwarding all available gas and reverting on errors.
687      *
688      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
689      * of certain opcodes, possibly making contracts go over the 2300 gas limit
690      * imposed by `transfer`, making them unable to receive funds via
691      * `transfer`. {sendValue} removes this limitation.
692      *
693      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
694      *
695      * IMPORTANT: because control is transferred to `recipient`, care must be
696      * taken to not create reentrancy vulnerabilities. Consider using
697      * {ReentrancyGuard} or the
698      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
699      */
700     function sendValue(address payable recipient, uint256 amount) internal {
701         require(address(this).balance >= amount, "Address: insufficient balance");
702 
703         (bool success, ) = recipient.call{value: amount}("");
704         require(success, "Address: unable to send value, recipient may have reverted");
705     }
706 
707     /**
708      * @dev Performs a Solidity function call using a low level `call`. A
709      * plain `call` is an unsafe replacement for a function call: use this
710      * function instead.
711      *
712      * If `target` reverts with a revert reason, it is bubbled up by this
713      * function (like regular Solidity function calls).
714      *
715      * Returns the raw returned data. To convert to the expected return value,
716      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
717      *
718      * Requirements:
719      *
720      * - `target` must be a contract.
721      * - calling `target` with `data` must not revert.
722      *
723      * _Available since v3.1._
724      */
725     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
726         return functionCall(target, data, "Address: low-level call failed");
727     }
728 
729     /**
730      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
731      * `errorMessage` as a fallback revert reason when `target` reverts.
732      *
733      * _Available since v3.1._
734      */
735     function functionCall(
736         address target,
737         bytes memory data,
738         string memory errorMessage
739     ) internal returns (bytes memory) {
740         return functionCallWithValue(target, data, 0, errorMessage);
741     }
742 
743     /**
744      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
745      * but also transferring `value` wei to `target`.
746      *
747      * Requirements:
748      *
749      * - the calling contract must have an ETH balance of at least `value`.
750      * - the called Solidity function must be `payable`.
751      *
752      * _Available since v3.1._
753      */
754     function functionCallWithValue(
755         address target,
756         bytes memory data,
757         uint256 value
758     ) internal returns (bytes memory) {
759         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
760     }
761 
762     /**
763      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
764      * with `errorMessage` as a fallback revert reason when `target` reverts.
765      *
766      * _Available since v3.1._
767      */
768     function functionCallWithValue(
769         address target,
770         bytes memory data,
771         uint256 value,
772         string memory errorMessage
773     ) internal returns (bytes memory) {
774         require(address(this).balance >= value, "Address: insufficient balance for call");
775         require(isContract(target), "Address: call to non-contract");
776 
777         (bool success, bytes memory returndata) = target.call{value: value}(data);
778         return verifyCallResult(success, returndata, errorMessage);
779     }
780 
781     /**
782      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
783      * but performing a static call.
784      *
785      * _Available since v3.3._
786      */
787     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
788         return functionStaticCall(target, data, "Address: low-level static call failed");
789     }
790 
791     /**
792      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
793      * but performing a static call.
794      *
795      * _Available since v3.3._
796      */
797     function functionStaticCall(
798         address target,
799         bytes memory data,
800         string memory errorMessage
801     ) internal view returns (bytes memory) {
802         require(isContract(target), "Address: static call to non-contract");
803 
804         (bool success, bytes memory returndata) = target.staticcall(data);
805         return verifyCallResult(success, returndata, errorMessage);
806     }
807 
808     /**
809      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
810      * but performing a delegate call.
811      *
812      * _Available since v3.4._
813      */
814     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
815         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
816     }
817 
818     /**
819      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
820      * but performing a delegate call.
821      *
822      * _Available since v3.4._
823      */
824     function functionDelegateCall(
825         address target,
826         bytes memory data,
827         string memory errorMessage
828     ) internal returns (bytes memory) {
829         require(isContract(target), "Address: delegate call to non-contract");
830 
831         (bool success, bytes memory returndata) = target.delegatecall(data);
832         return verifyCallResult(success, returndata, errorMessage);
833     }
834 
835     /**
836      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
837      * revert reason using the provided one.
838      *
839      * _Available since v4.3._
840      */
841     function verifyCallResult(
842         bool success,
843         bytes memory returndata,
844         string memory errorMessage
845     ) internal pure returns (bytes memory) {
846         if (success) {
847             return returndata;
848         } else {
849             // Look for revert reason and bubble it up if present
850             if (returndata.length > 0) {
851                 // The easiest way to bubble the revert reason is using memory via assembly
852                 /// @solidity memory-safe-assembly
853                 assembly {
854                     let returndata_size := mload(returndata)
855                     revert(add(32, returndata), returndata_size)
856                 }
857             } else {
858                 revert(errorMessage);
859             }
860         }
861     }
862 }
863 
864 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
865 
866 
867 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/utils/SafeERC20.sol)
868 
869 pragma solidity ^0.8.0;
870 
871 
872 
873 
874 /**
875  * @title SafeERC20
876  * @dev Wrappers around ERC20 operations that throw on failure (when the token
877  * contract returns false). Tokens that return no value (and instead revert or
878  * throw on failure) are also supported, non-reverting calls are assumed to be
879  * successful.
880  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
881  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
882  */
883 library SafeERC20 {
884     using Address for address;
885 
886     function safeTransfer(
887         IERC20 token,
888         address to,
889         uint256 value
890     ) internal {
891         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
892     }
893 
894     function safeTransferFrom(
895         IERC20 token,
896         address from,
897         address to,
898         uint256 value
899     ) internal {
900         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
901     }
902 
903     /**
904      * @dev Deprecated. This function has issues similar to the ones found in
905      * {IERC20-approve}, and its usage is discouraged.
906      *
907      * Whenever possible, use {safeIncreaseAllowance} and
908      * {safeDecreaseAllowance} instead.
909      */
910     function safeApprove(
911         IERC20 token,
912         address spender,
913         uint256 value
914     ) internal {
915         // safeApprove should only be called when setting an initial allowance,
916         // or when resetting it to zero. To increase and decrease it, use
917         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
918         require(
919             (value == 0) || (token.allowance(address(this), spender) == 0),
920             "SafeERC20: approve from non-zero to non-zero allowance"
921         );
922         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
923     }
924 
925     function safeIncreaseAllowance(
926         IERC20 token,
927         address spender,
928         uint256 value
929     ) internal {
930         uint256 newAllowance = token.allowance(address(this), spender) + value;
931         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
932     }
933 
934     function safeDecreaseAllowance(
935         IERC20 token,
936         address spender,
937         uint256 value
938     ) internal {
939         unchecked {
940             uint256 oldAllowance = token.allowance(address(this), spender);
941             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
942             uint256 newAllowance = oldAllowance - value;
943             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
944         }
945     }
946 
947     function safePermit(
948         IERC20Permit token,
949         address owner,
950         address spender,
951         uint256 value,
952         uint256 deadline,
953         uint8 v,
954         bytes32 r,
955         bytes32 s
956     ) internal {
957         uint256 nonceBefore = token.nonces(owner);
958         token.permit(owner, spender, value, deadline, v, r, s);
959         uint256 nonceAfter = token.nonces(owner);
960         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
961     }
962 
963     /**
964      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
965      * on the return value: the return value is optional (but if data is returned, it must not be false).
966      * @param token The token targeted by the call.
967      * @param data The call data (encoded using abi.encode or one of its variants).
968      */
969     function _callOptionalReturn(IERC20 token, bytes memory data) private {
970         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
971         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
972         // the target address contains contract code and also asserts for success in the low-level call.
973 
974         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
975         if (returndata.length > 0) {
976             // Return data is optional
977             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
978         }
979     }
980 }
981 
982 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
983 
984 
985 // OpenZeppelin Contracts (last updated v4.7.0) (finance/PaymentSplitter.sol)
986 
987 pragma solidity ^0.8.0;
988 
989 
990 
991 
992 /**
993  * @title PaymentSplitter
994  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
995  * that the Ether will be split in this way, since it is handled transparently by the contract.
996  *
997  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
998  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
999  * an amount proportional to the percentage of total shares they were assigned. The distribution of shares is set at the
1000  * time of contract deployment and can't be updated thereafter.
1001  *
1002  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
1003  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
1004  * function.
1005  *
1006  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
1007  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
1008  * to run tests before sending real value to this contract.
1009  */
1010 contract PaymentSplitter is Context {
1011     event PayeeAdded(address account, uint256 shares);
1012     event PaymentReleased(address to, uint256 amount);
1013     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
1014     event PaymentReceived(address from, uint256 amount);
1015 
1016     uint256 private _totalShares;
1017     uint256 private _totalReleased;
1018 
1019     mapping(address => uint256) private _shares;
1020     mapping(address => uint256) private _released;
1021     address[] private _payees;
1022 
1023     mapping(IERC20 => uint256) private _erc20TotalReleased;
1024     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
1025 
1026     /**
1027      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
1028      * the matching position in the `shares` array.
1029      *
1030      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
1031      * duplicates in `payees`.
1032      */
1033     constructor(address[] memory payees, uint256[] memory shares_) payable {
1034         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
1035         require(payees.length > 0, "PaymentSplitter: no payees");
1036 
1037         for (uint256 i = 0; i < payees.length; i++) {
1038             _addPayee(payees[i], shares_[i]);
1039         }
1040     }
1041 
1042     /**
1043      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
1044      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
1045      * reliability of the events, and not the actual splitting of Ether.
1046      *
1047      * To learn more about this see the Solidity documentation for
1048      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
1049      * functions].
1050      */
1051     receive() external payable virtual {
1052         emit PaymentReceived(_msgSender(), msg.value);
1053     }
1054 
1055     /**
1056      * @dev Getter for the total shares held by payees.
1057      */
1058     function totalShares() public view returns (uint256) {
1059         return _totalShares;
1060     }
1061 
1062     /**
1063      * @dev Getter for the total amount of Ether already released.
1064      */
1065     function totalReleased() public view returns (uint256) {
1066         return _totalReleased;
1067     }
1068 
1069     /**
1070      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
1071      * contract.
1072      */
1073     function totalReleased(IERC20 token) public view returns (uint256) {
1074         return _erc20TotalReleased[token];
1075     }
1076 
1077     /**
1078      * @dev Getter for the amount of shares held by an account.
1079      */
1080     function shares(address account) public view returns (uint256) {
1081         return _shares[account];
1082     }
1083 
1084     /**
1085      * @dev Getter for the amount of Ether already released to a payee.
1086      */
1087     function released(address account) public view returns (uint256) {
1088         return _released[account];
1089     }
1090 
1091     /**
1092      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
1093      * IERC20 contract.
1094      */
1095     function released(IERC20 token, address account) public view returns (uint256) {
1096         return _erc20Released[token][account];
1097     }
1098 
1099     /**
1100      * @dev Getter for the address of the payee number `index`.
1101      */
1102     function payee(uint256 index) public view returns (address) {
1103         return _payees[index];
1104     }
1105 
1106     /**
1107      * @dev Getter for the amount of payee's releasable Ether.
1108      */
1109     function releasable(address account) public view returns (uint256) {
1110         uint256 totalReceived = address(this).balance + totalReleased();
1111         return _pendingPayment(account, totalReceived, released(account));
1112     }
1113 
1114     /**
1115      * @dev Getter for the amount of payee's releasable `token` tokens. `token` should be the address of an
1116      * IERC20 contract.
1117      */
1118     function releasable(IERC20 token, address account) public view returns (uint256) {
1119         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
1120         return _pendingPayment(account, totalReceived, released(token, account));
1121     }
1122 
1123     /**
1124      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
1125      * total shares and their previous withdrawals.
1126      */
1127     function release(address payable account) public virtual {
1128         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1129 
1130         uint256 payment = releasable(account);
1131 
1132         require(payment != 0, "PaymentSplitter: account is not due payment");
1133 
1134         _released[account] += payment;
1135         _totalReleased += payment;
1136 
1137         Address.sendValue(account, payment);
1138         emit PaymentReleased(account, payment);
1139     }
1140 
1141     /**
1142      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
1143      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
1144      * contract.
1145      */
1146     function release(IERC20 token, address account) public virtual {
1147         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1148 
1149         uint256 payment = releasable(token, account);
1150 
1151         require(payment != 0, "PaymentSplitter: account is not due payment");
1152 
1153         _erc20Released[token][account] += payment;
1154         _erc20TotalReleased[token] += payment;
1155 
1156         SafeERC20.safeTransfer(token, account, payment);
1157         emit ERC20PaymentReleased(token, account, payment);
1158     }
1159 
1160     /**
1161      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
1162      * already released amounts.
1163      */
1164     function _pendingPayment(
1165         address account,
1166         uint256 totalReceived,
1167         uint256 alreadyReleased
1168     ) private view returns (uint256) {
1169         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
1170     }
1171 
1172     /**
1173      * @dev Add a new payee to the contract.
1174      * @param account The address of the payee to add.
1175      * @param shares_ The number of shares owned by the payee.
1176      */
1177     function _addPayee(address account, uint256 shares_) private {
1178         require(account != address(0), "PaymentSplitter: account is the zero address");
1179         require(shares_ > 0, "PaymentSplitter: shares are 0");
1180         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
1181 
1182         _payees.push(account);
1183         _shares[account] = shares_;
1184         _totalShares = _totalShares + shares_;
1185         emit PayeeAdded(account, shares_);
1186     }
1187 }
1188 
1189 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1190 
1191 
1192 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1193 
1194 pragma solidity ^0.8.0;
1195 
1196 /**
1197  * @title ERC721 token receiver interface
1198  * @dev Interface for any contract that wants to support safeTransfers
1199  * from ERC721 asset contracts.
1200  */
1201 interface IERC721Receiver {
1202     /**
1203      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1204      * by `operator` from `from`, this function is called.
1205      *
1206      * It must return its Solidity selector to confirm the token transfer.
1207      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1208      *
1209      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1210      */
1211     function onERC721Received(
1212         address operator,
1213         address from,
1214         uint256 tokenId,
1215         bytes calldata data
1216     ) external returns (bytes4);
1217 }
1218 
1219 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1220 
1221 
1222 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1223 
1224 pragma solidity ^0.8.0;
1225 
1226 /**
1227  * @dev Interface of the ERC165 standard, as defined in the
1228  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1229  *
1230  * Implementers can declare support of contract interfaces, which can then be
1231  * queried by others ({ERC165Checker}).
1232  *
1233  * For an implementation, see {ERC165}.
1234  */
1235 interface IERC165 {
1236     /**
1237      * @dev Returns true if this contract implements the interface defined by
1238      * `interfaceId`. See the corresponding
1239      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1240      * to learn more about how these ids are created.
1241      *
1242      * This function call must use less than 30 000 gas.
1243      */
1244     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1245 }
1246 
1247 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1248 
1249 
1250 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1251 
1252 pragma solidity ^0.8.0;
1253 
1254 
1255 /**
1256  * @dev Implementation of the {IERC165} interface.
1257  *
1258  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1259  * for the additional interface id that will be supported. For example:
1260  *
1261  * ```solidity
1262  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1263  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1264  * }
1265  * ```
1266  *
1267  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1268  */
1269 abstract contract ERC165 is IERC165 {
1270     /**
1271      * @dev See {IERC165-supportsInterface}.
1272      */
1273     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1274         return interfaceId == type(IERC165).interfaceId;
1275     }
1276 }
1277 
1278 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1279 
1280 
1281 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
1282 
1283 pragma solidity ^0.8.0;
1284 
1285 
1286 /**
1287  * @dev Required interface of an ERC721 compliant contract.
1288  */
1289 interface IERC721 is IERC165 {
1290     /**
1291      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1292      */
1293     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1294 
1295     /**
1296      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1297      */
1298     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1299 
1300     /**
1301      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1302      */
1303     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1304 
1305     /**
1306      * @dev Returns the number of tokens in ``owner``'s account.
1307      */
1308     function balanceOf(address owner) external view returns (uint256 balance);
1309 
1310     /**
1311      * @dev Returns the owner of the `tokenId` token.
1312      *
1313      * Requirements:
1314      *
1315      * - `tokenId` must exist.
1316      */
1317     function ownerOf(uint256 tokenId) external view returns (address owner);
1318 
1319     /**
1320      * @dev Safely transfers `tokenId` token from `from` to `to`.
1321      *
1322      * Requirements:
1323      *
1324      * - `from` cannot be the zero address.
1325      * - `to` cannot be the zero address.
1326      * - `tokenId` token must exist and be owned by `from`.
1327      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1328      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1329      *
1330      * Emits a {Transfer} event.
1331      */
1332     function safeTransferFrom(
1333         address from,
1334         address to,
1335         uint256 tokenId,
1336         bytes calldata data
1337     ) external;
1338 
1339     /**
1340      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1341      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1342      *
1343      * Requirements:
1344      *
1345      * - `from` cannot be the zero address.
1346      * - `to` cannot be the zero address.
1347      * - `tokenId` token must exist and be owned by `from`.
1348      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1349      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1350      *
1351      * Emits a {Transfer} event.
1352      */
1353     function safeTransferFrom(
1354         address from,
1355         address to,
1356         uint256 tokenId
1357     ) external;
1358 
1359     /**
1360      * @dev Transfers `tokenId` token from `from` to `to`.
1361      *
1362      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1363      *
1364      * Requirements:
1365      *
1366      * - `from` cannot be the zero address.
1367      * - `to` cannot be the zero address.
1368      * - `tokenId` token must be owned by `from`.
1369      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1370      *
1371      * Emits a {Transfer} event.
1372      */
1373     function transferFrom(
1374         address from,
1375         address to,
1376         uint256 tokenId
1377     ) external;
1378 
1379     /**
1380      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1381      * The approval is cleared when the token is transferred.
1382      *
1383      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1384      *
1385      * Requirements:
1386      *
1387      * - The caller must own the token or be an approved operator.
1388      * - `tokenId` must exist.
1389      *
1390      * Emits an {Approval} event.
1391      */
1392     function approve(address to, uint256 tokenId) external;
1393 
1394     /**
1395      * @dev Approve or remove `operator` as an operator for the caller.
1396      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1397      *
1398      * Requirements:
1399      *
1400      * - The `operator` cannot be the caller.
1401      *
1402      * Emits an {ApprovalForAll} event.
1403      */
1404     function setApprovalForAll(address operator, bool _approved) external;
1405 
1406     /**
1407      * @dev Returns the account approved for `tokenId` token.
1408      *
1409      * Requirements:
1410      *
1411      * - `tokenId` must exist.
1412      */
1413     function getApproved(uint256 tokenId) external view returns (address operator);
1414 
1415     /**
1416      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1417      *
1418      * See {setApprovalForAll}
1419      */
1420     function isApprovedForAll(address owner, address operator) external view returns (bool);
1421 }
1422 
1423 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1424 
1425 
1426 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1427 
1428 pragma solidity ^0.8.0;
1429 
1430 
1431 /**
1432  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1433  * @dev See https://eips.ethereum.org/EIPS/eip-721
1434  */
1435 interface IERC721Metadata is IERC721 {
1436     /**
1437      * @dev Returns the token collection name.
1438      */
1439     function name() external view returns (string memory);
1440 
1441     /**
1442      * @dev Returns the token collection symbol.
1443      */
1444     function symbol() external view returns (string memory);
1445 
1446     /**
1447      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1448      */
1449     function tokenURI(uint256 tokenId) external view returns (string memory);
1450 }
1451 
1452 // File: tinyERC721_ID.sol
1453 
1454 
1455 pragma solidity ^0.8.0;
1456 
1457 
1458 
1459 
1460 
1461 
1462 
1463 
1464 error ApprovalCallerNotOwnerNorApproved();
1465 error ApprovalQueryForNonexistentToken();
1466 error ApproveToCaller();
1467 error ApprovalToCurrentOwner();
1468 error BalanceQueryForZeroAddress();
1469 error MintToZeroAddress();
1470 error MintZeroQuantity();
1471 error TokenDataQueryForNonexistentToken();
1472 error OwnerQueryForNonexistentToken();
1473 error OperatorQueryForNonexistentToken();
1474 error TransferCallerNotOwnerNorApproved();
1475 error TransferFromIncorrectOwner();
1476 error TransferToNonERC721ReceiverImplementer();
1477 error TransferToZeroAddress();
1478 error URIQueryForNonexistentToken();
1479 
1480 contract TinyERC721 is Context, ERC165, IERC721, IERC721Metadata {
1481   using Address for address;
1482   using Strings for uint256;
1483 
1484   struct TokenData {
1485     address owner;
1486     bytes12 aux;
1487   }
1488 
1489   uint256 private immutable _maxBatchSize;
1490 
1491   mapping(uint256 => TokenData) private _tokens;
1492   uint256 private _mintCounter = 151;
1493   uint256 private _claimCounter;
1494 
1495   string private _name;
1496   string private _symbol;
1497 
1498   mapping(uint256 => address) private _tokenApprovals;
1499   mapping(address => mapping(address => bool)) private _operatorApprovals;
1500 
1501   constructor(
1502     string memory name_,
1503     string memory symbol_,
1504     uint256 maxBatchSize_
1505   ) {
1506     _name = name_;
1507     _symbol = symbol_;
1508     _maxBatchSize = maxBatchSize_;
1509   }
1510 
1511   function totalSupply() public view virtual returns (uint256) {
1512     return (_mintCounter - 151 + _claimCounter);
1513   }
1514 
1515   function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1516     return
1517       interfaceId == type(IERC721).interfaceId ||
1518       interfaceId == type(IERC721Metadata).interfaceId ||
1519       super.supportsInterface(interfaceId);
1520   }
1521 
1522   function name() public view virtual override returns (string memory) {
1523     return _name;
1524   }
1525 
1526   function symbol() public view virtual override returns (string memory) {
1527     return _symbol;
1528   }
1529 
1530   function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1531     if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1532 
1533     string memory baseURI = _baseURI();
1534     return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1535   }
1536 
1537   function _baseURI() internal view virtual returns (string memory) {
1538     return '';
1539   }
1540 
1541   function balanceOf(address owner) public view virtual override returns (uint256) {
1542     if (owner == address(0)) revert BalanceQueryForZeroAddress();
1543 
1544     uint256 total = totalSupply() + 150 - _claimCounter;
1545     uint256 count;
1546     address lastOwner;
1547     for (uint256 i; i <= total; ++i) {
1548       if(_exists(i)) {
1549         address tokenOwner = _tokens[i].owner;
1550         if (tokenOwner != address(0)) lastOwner = tokenOwner;
1551         if (lastOwner == owner) ++count;
1552       }
1553     }
1554 
1555     return count;
1556   }
1557 
1558   function _tokenData(uint256 tokenId) internal view returns (TokenData storage) {
1559     if (!_exists(tokenId)) revert TokenDataQueryForNonexistentToken();
1560 
1561     TokenData storage token = _tokens[tokenId];
1562     uint256 currentIndex = tokenId;
1563     while (token.owner == address(0)) {
1564       unchecked {
1565         --currentIndex;
1566       }
1567       token = _tokens[currentIndex];
1568     }
1569 
1570     return token;
1571   }
1572 
1573   function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1574     if (!_exists(tokenId)) revert OwnerQueryForNonexistentToken();
1575     return _tokenData(tokenId).owner;
1576   }
1577 
1578   function approve(address to, uint256 tokenId) public virtual override {
1579     TokenData memory token = _tokenData(tokenId);
1580     address owner = token.owner;
1581     if (to == owner) revert ApprovalToCurrentOwner();
1582 
1583     if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1584       revert ApprovalCallerNotOwnerNorApproved();
1585     }
1586 
1587     _approve(to, tokenId, token);
1588   }
1589 
1590   function getApproved(uint256 tokenId) public view virtual override returns (address) {
1591     if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1592 
1593     return _tokenApprovals[tokenId];
1594   }
1595 
1596   function setApprovalForAll(address operator, bool approved) public virtual override {
1597     if (operator == _msgSender()) revert ApproveToCaller();
1598 
1599     _operatorApprovals[_msgSender()][operator] = approved;
1600     emit ApprovalForAll(_msgSender(), operator, approved);
1601   }
1602 
1603   function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1604     return _operatorApprovals[owner][operator];
1605   }
1606 
1607   function transferFrom(
1608     address from,
1609     address to,
1610     uint256 tokenId
1611   ) public virtual override {
1612     TokenData memory token = _tokenData(tokenId);
1613     if (!_isApprovedOrOwner(_msgSender(), tokenId, token)) revert TransferCallerNotOwnerNorApproved();
1614 
1615     _transfer(from, to, tokenId, token);
1616   }
1617 
1618   function safeTransferFrom(
1619     address from,
1620     address to,
1621     uint256 tokenId
1622   ) public virtual override {
1623     safeTransferFrom(from, to, tokenId, '');
1624   }
1625 
1626   function safeTransferFrom(
1627     address from,
1628     address to,
1629     uint256 tokenId,
1630     bytes memory _data
1631   ) public virtual override {
1632     TokenData memory token = _tokenData(tokenId);
1633     if (!_isApprovedOrOwner(_msgSender(), tokenId, token)) revert TransferCallerNotOwnerNorApproved();
1634 
1635     _safeTransfer(from, to, tokenId, token, _data);
1636   }
1637 
1638   function _safeTransfer(
1639     address from,
1640     address to,
1641     uint256 tokenId,
1642     TokenData memory token,
1643     bytes memory _data
1644   ) internal virtual {
1645     _transfer(from, to, tokenId, token);
1646 
1647     if (to.isContract() && !_checkOnERC721Received(from, to, tokenId, _data))
1648       revert TransferToNonERC721ReceiverImplementer();
1649   }
1650 
1651   function _exists(uint256 tokenId) internal view virtual returns (bool) {
1652     if (tokenId > 150) {
1653       return tokenId < _mintCounter;
1654     } else if (tokenId <= 150) {
1655       return tokenId <= _claimCounter;
1656     } else {
1657       return false;
1658     }
1659   }
1660 
1661   function _isApprovedOrOwner(
1662     address spender,
1663     uint256 tokenId,
1664     TokenData memory token
1665   ) internal view virtual returns (bool) {
1666     address owner = token.owner;
1667     return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1668   }
1669 
1670   function _safeMint(address to, uint256 quantity) internal virtual {
1671     _safeMint(to, quantity, '');
1672   }
1673 
1674   function _safeMintID(address to, uint256 _id, uint256 quantity) internal virtual {
1675     _safeMintID(to, _id, quantity, '');
1676   }
1677 
1678   function _safeMint(
1679     address to,
1680     uint256 quantity,
1681     bytes memory _data
1682   ) internal virtual {
1683     uint256 startTokenId = _mintCounter;
1684     _mint(to, quantity);
1685 
1686     if (to.isContract()) {
1687       unchecked {
1688         for (uint256 i; i < quantity; ++i) {
1689           if (!_checkOnERC721Received(address(0), to, startTokenId + i, _data))
1690             revert TransferToNonERC721ReceiverImplementer();
1691         }
1692       }
1693     }
1694   }
1695 
1696   function _safeMintID(
1697     address to,
1698     uint256 _id,
1699     uint256 quantity,
1700     bytes memory _data
1701   ) internal virtual {
1702     _mintID(to, _id, quantity);
1703     _claimCounter += quantity;
1704     if (to.isContract()) {
1705       unchecked {
1706         if (!_checkOnERC721Received(address(0), to, _id, _data))
1707             revert TransferToNonERC721ReceiverImplementer();
1708       }
1709     }
1710   }
1711 
1712   function _mint(address to, uint256 quantity) internal virtual {
1713     if (to == address(0)) revert MintToZeroAddress();
1714     if (quantity == 0) revert MintZeroQuantity();
1715 
1716     uint256 startTokenId = _mintCounter;
1717     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1718 
1719     unchecked {
1720       for (uint256 i; i < quantity; ++i) {
1721         if (_maxBatchSize == 0 ? i == 0 : i % _maxBatchSize == 0) {
1722           TokenData storage token = _tokens[startTokenId + i];
1723           token.owner = to;
1724           token.aux = _calculateAux(address(0), to, startTokenId + i, 0);
1725         }
1726 
1727         emit Transfer(address(0), to, startTokenId + i);
1728       }
1729       _mintCounter += quantity;
1730     }
1731 
1732     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1733   }
1734 
1735   function _mintID(address to, uint256 _id, uint256 quantity) internal virtual {
1736     if (to == address(0)) revert MintToZeroAddress();
1737     if (quantity == 0) revert MintZeroQuantity();
1738 
1739     uint256 startTokenId = _id;
1740     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1741 
1742     unchecked {
1743       for (uint256 i; i < quantity; ++i) {
1744         if (_maxBatchSize == 0 ? i == 0 : i % _maxBatchSize == 0) {
1745           TokenData storage token = _tokens[startTokenId + i];
1746           token.owner = to;
1747           token.aux = _calculateAux(address(0), to, startTokenId + i, 0);
1748         }
1749 
1750         emit Transfer(address(0), to, startTokenId + i);
1751       }
1752     }
1753 
1754     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1755   }
1756 
1757   function _transfer(
1758     address from,
1759     address to,
1760     uint256 tokenId,
1761     TokenData memory token
1762   ) internal virtual {
1763     if (token.owner != from) revert TransferFromIncorrectOwner();
1764     if (to == address(0)) revert TransferToZeroAddress();
1765 
1766     _beforeTokenTransfers(from, to, tokenId, 1);
1767 
1768     _approve(address(0), tokenId, token);
1769 
1770     unchecked {
1771       uint256 nextTokenId = tokenId + 1;
1772       if (_exists(nextTokenId)) {
1773         TokenData storage nextToken = _tokens[nextTokenId];
1774         if (nextToken.owner == address(0)) {
1775           nextToken.owner = token.owner;
1776           nextToken.aux = token.aux;
1777         }
1778       }
1779     }
1780 
1781     TokenData storage newToken = _tokens[tokenId];
1782     newToken.owner = to;
1783     newToken.aux = _calculateAux(from, to, tokenId, token.aux);
1784 
1785     emit Transfer(from, to, tokenId);
1786 
1787     _afterTokenTransfers(from, to, tokenId, 1);
1788   }
1789 
1790   function _calculateAux(
1791     address from,
1792     address to,
1793     uint256 tokenId,
1794     bytes12 current
1795   ) internal view virtual returns (bytes12) {}
1796 
1797   function _approve(
1798     address to,
1799     uint256 tokenId,
1800     TokenData memory token
1801   ) internal virtual {
1802     _tokenApprovals[tokenId] = to;
1803     emit Approval(token.owner, to, tokenId);
1804   }
1805 
1806   function _checkOnERC721Received(
1807     address from,
1808     address to,
1809     uint256 tokenId,
1810     bytes memory _data
1811   ) private returns (bool) {
1812     try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1813       return retval == IERC721Receiver.onERC721Received.selector;
1814     } catch (bytes memory reason) {
1815       if (reason.length == 0) {
1816         revert TransferToNonERC721ReceiverImplementer();
1817       } else {
1818         assembly {
1819           revert(add(32, reason), mload(reason))
1820         }
1821       }
1822     }
1823   }
1824 
1825   function _beforeTokenTransfers(
1826     address from,
1827     address to,
1828     uint256 startTokenId,
1829     uint256 quantity
1830   ) internal virtual {}
1831 
1832   function _afterTokenTransfers(
1833     address from,
1834     address to,
1835     uint256 startTokenId,
1836     uint256 quantity
1837   ) internal virtual {}
1838 }
1839 // File: dreamers.sol
1840 
1841 /*
1842 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1843 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1844 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1845 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1846 MMMMMMMMMMMMMMMMNOOXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXO0NMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1847 MMMMMMMMMMMMMMMMk,'lKWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMKc.,kWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1848 MMMMMMMMMMMMMMMNo...cKMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMKc...lNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1849 MMMMMMMMMMMMMMMK:....cKMMMMMMMMMMMMMMMMMMMMMMMMMMMMMKc....:0MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1850 MMMMMMMMMMMMMMMk,.....cKMMMMMMMMMMMMMMMMMMMMMMMMMMWKc.....,kWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1851 MMMMMMMMMMMMMMNd.......cKWMMMMMMMMMMMMMMMMMMMMMMMKkc.......oNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1852 MMMMMMMMMMMMMMKc........cKMMMMMMMMMMMMMMMMMMMMMMKc'........cKMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1853 MMMMMMMMMMMMMMO,.........cKMMMMMMMMMMMMMMMMMMMMKc..........,OMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1854 MMMMMMMMMMMMMWd'..........cKWMMMMMMMMMMMMMMMMMKl............dWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1855 MMMMMMMMMMMMMXc...;;.......cKMMMMMMMMMMMMMMMMKc...'co,......cXMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1856 MMMMMMMMMMMMMO;..,x0:.......cKMMMMMMMMMMMMMMKl...cxKKc......;OMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1857 MMMMMMMMMMMMWd'..;0W0:.......cKWMMMMMMMMMMMKc...cKWMNo......'xWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1858 MMMMMMMMMMMMXl...lXMW0:.......c0WMMMMMMMMMKl...cKMMMWx'......lXXkxxddddoddddxxxkO0KXXNWWWMMMMMMMMMMM
1859 MMMMMMMMMMMM0;...dWMMW0:.......c0WMMMMMMMKl...cKMMMMMO;......;0k,.'''',,''.......'',;::cxXMMMMMMMMMM
1860 MMMMMMMMMMMWx'..,kMMMMW0:.......c0WMMMMMKl...cKMMMMWWKc......'xXOO00KKKKK00Okdoc,'......cKMMMMMMMMMM
1861 MMMMMMMMMMMXl...:0MMMMMW0:.......:0WMMMKl...cKMMWKkdxKd.......oNMMMMMMMMMMMMMMMWXOd:'...lXMMMMMMMMMM
1862 MMMMMMMMMMM0:...lXMMMMMMWO:.......:0MMKl...cKMWKo,..;0k,......:KMMMMMMMMMMMMMMMMMMWNOc'.oNMMMMMMMMMM
1863 MMMMMMMMMMWx'..'dWMMMMMMMW0:.......:0Kl...cKMNk;....,k0:......,kMMMMMMMMMMMMMMMMMMMMMXl'oNMMMMMMMMMM
1864 MMMMMMMMMMNl...,OMMMMMMMMMW0:.......;;...cKWXo'......dKl.......oNMMMMMMMMMMMMMMMMMMMMM0:dWMMMMMMMMMM
1865 MMMMMMMMMM0:...:KMMMMMMMMMMW0c..........lKMNo'.......oXd'......cKMMMMMMMMMMMMMMMMMMMMMNKXMMMMMMMMMMM
1866 MMMMMMMMMWk,...lXMMMMMMMMMMMWKc........cKMWx,.......,kWk,......,OMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1867 MMMMMMMMMNo...'dWMMMMMMMMMMMMMKl......lKMMK:........:KMK:.......dNMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1868 MMMMMMMMWO;...'xWMMMMMMMMMMMMMMXl'...lKMMWx'........lXMXl.......;OWMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1869 MMMMNKOOd;.....;dkO0NMMMMMMMMMMMXo''lXMMMNo.........lNW0:........,lxkO0XWMMMMMMMMMMMMMMMMMMMMMMMMMMM
1870 MMMMN0kkkkkkkkkkxxkOXWMMMMMMMMMMMN0ONMMMMNo.........lXWXOkkkkxxxxxxxxxk0WMXOkkkkkkkkkkkkkkkkkOXMMMMM
1871 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNo.........:0MMMMMMMMMMMMMMMMMMMMN0OOxl,........,lxO0NMMMMM
1872 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWx'........'xWMMMMMMMMMMMMMMMMMMMMMMMMNd'......'dNMMMMMMMMM
1873 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM0:.........:KMMMMMMMMMMMMMMMMMMMMMMMMMk,......'xWMMMMMMMMM
1874 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNd'.........oXMMMMMMMMMMMMMMMMMMMMMMMMO,......'kWMMMMMMMMM
1875 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXo.........'oXMMMMMMMMMMMMMMMMMMMMMMMO,......'kMMMMMMMMMM
1876 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMXo'.........c0WMMMMMMMMMMMMMMMMMMMMMO,......'kMMMMMMMMMM
1877 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMNx;.........,dXWMMMMMMMMMMMMMMMMMMMO,......'kMMMMMMMMMM
1878 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWKo;'........;d0NMMMMMMMMMMMMMMMMMO,......'kWMMMMMMMMM
1879 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWKOxc'.......':dOKNWMMMMMMMMMMMWk,......'kWMMMMMMMMM
1880 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMN0xl;'.......,:ldxkO00KK00Od:.......;OMMMMMMMMMM
1881 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWX0kdl:;''.......''''''....',;cox0NMMMMMMMMMM
1882 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMWNXK0OkxxddddddddxxkkO0XNWMMMMMMMMMMMMMM
1883 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1884 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1885 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1886 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1887 MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
1888 */
1889 
1890 // Contract authored by August Rosedale (@augustfr)
1891 // https://miragegallery.ai
1892 
1893 // TinyERC721 used (https://github.com/tajigen/tiny-erc721)
1894 // Modifications were made to the TinyERC721 contract in order to allow for 'Sentient' members to claim from the first 150 tokens at any point in time.
1895 
1896 pragma solidity ^0.8.16;
1897 
1898 
1899 
1900 
1901 
1902 
1903 interface mirageContracts {
1904     function balanceOf(address owner, uint256 _id) external view returns (uint256);
1905 }
1906 
1907 interface mirageProjects {
1908   function balanceOf(address owner) external view returns (uint256);
1909 }
1910 
1911 
1912 contract mirageDreamers is TinyERC721, ReentrancyGuard, Ownable {
1913 
1914   using Strings for uint256;
1915 
1916   mapping(uint256 => uint256) public sentientClaimed;
1917 
1918   uint256 private maxSentientClaim = 3;
1919 
1920   uint256 public publicPrice = 0.06 ether;
1921   uint256 public holderPrice = 0.04 ether;
1922   uint256 public memberPrice = 0.02 ether;
1923 
1924   uint256 private maxMemberMint = 20;
1925   uint256 private maxHolderMint = 5;
1926   uint256 private maxPartnerMint = 5;
1927   address[] private mulIntelHolders;
1928   uint256[] private numIntelHeld;
1929 
1930   uint256 public maxSupply = 8000;
1931 
1932   bool private revealed;
1933   string private unrevealedURI = "ipfs://QmQoBSSf8ZvvPbUfVBnbKBZim9pJvgEvJS5zpfwCkp2HgW";
1934 
1935   uint256 public claimCounter;
1936 
1937   string public baseURI;
1938 
1939   bool private paused;
1940 
1941   bool public metadataFrozen;
1942 
1943   mirageProjects private curated;
1944   mirageProjects private cryptoNative;
1945   mirageProjects private AlejandroAndTaylor;
1946   mirageProjects private earlyWorks;
1947 
1948   salePhase public phase = salePhase.unOpened;
1949 
1950   address private immutable _adminSigner;
1951 
1952    struct Coupon {
1953       bytes32 r;
1954       bytes32 s;
1955       uint8 v;
1956   }
1957 
1958   struct Minted {
1959       uint256 member;
1960       uint256 id;
1961       uint256 holder;
1962       uint256 partner;
1963   }
1964 
1965   struct intelAllotment {
1966     uint256 maxMint;
1967     uint256 numMinted;
1968   }
1969 
1970   enum salePhase {
1971       unOpened,
1972       memberSale,
1973       presale,
1974       openSale,
1975       publicSale,
1976       closed
1977   }
1978 
1979   mirageContracts public membershipContract;
1980 
1981   mapping(address => Minted) numMinted;
1982   mapping(uint256 => Minted) idMinted;
1983   mapping(address => intelAllotment) intelQuantity;
1984 
1985   constructor(string memory name, string memory symbol, address adminSigner, address membershipAddress) TinyERC721(name, symbol, 0) {
1986       membershipContract = mirageContracts(membershipAddress);
1987       _adminSigner = adminSigner;
1988       cryptoNative = mirageProjects(0x89568Fc8d04B3f833209144b77F39b71078e3CB0);
1989       AlejandroAndTaylor = mirageProjects(0x63400da86a6b42dac41075667cF871a5Ef93802F);
1990       earlyWorks = mirageProjects(0x3Cf6e4ff99D616d44Be53E90F74eAE5D150Cb726);
1991       curated = mirageProjects(0xb7eC7bbd2d2193B47027247FC666fB342D23c4B5);
1992 
1993     //   cryptoNative = mirageProjects(0x662508A2767A1A978DF4CFd16f77A3358C613599);
1994     //   AlejandroAndTaylor = mirageProjects(0x662508A2767A1A978DF4CFd16f77A3358C613599);
1995     //   earlyWorks = mirageProjects(0x662508A2767A1A978DF4CFd16f77A3358C613599);
1996     //   curated = mirageProjects(0x662508A2767A1A978DF4CFd16f77A3358C613599);
1997   }
1998 
1999   function updateMintStatus(salePhase phase_) external onlyOwner {
2000       require(uint8(phase_) > uint8(phase), "Increase only");
2001       phase = phase_;
2002   }
2003 
2004   function updateMintLimits(uint256 _maxMember, uint256 _maxHolder, uint256 _maxPartner) public onlyOwner {
2005       maxMemberMint = _maxMember;
2006       maxHolderMint = _maxHolder;
2007       maxPartnerMint = _maxPartner;
2008       for(uint i = 0; i < mulIntelHolders.length; i++) {
2009           intelQuantity[mulIntelHolders[i]].maxMint = numIntelHeld[i] * maxMemberMint;
2010       }
2011   }
2012 
2013   function updateMintPrices(uint256 _public, uint256 _holder, uint256 _member) public onlyOwner {
2014       //input prices in wei
2015       publicPrice = _public;
2016       holderPrice = _holder;
2017       memberPrice = _member;
2018   }
2019 
2020   function togglePause() public onlyOwner {
2021       paused = !paused;
2022   }
2023 
2024   function sentientMint(uint256 numberOfTokens, uint256 _membershipId) public payable nonReentrant {
2025       require(_membershipId < 50, "Not a valid Sentient ID");
2026       require(!paused, "Minting paused");
2027       require(phase >= salePhase.memberSale && phase < salePhase.publicSale, "Not in member sale phase");
2028       require(membershipContract.balanceOf(msg.sender,_membershipId) > 0, "No membership tokens in this wallet");
2029       require(msg.value >= numberOfTokens * memberPrice, "Insufficient Payment: Amount of Ether sent is not correct.");
2030       require(numberOfTokens + totalSupply() <= 7850 + claimCounter, "Minting would exceed max supply");
2031       require(idMinted[_membershipId].id + numberOfTokens <= maxMemberMint, "Would exceed max allotment for this phase");
2032       idMinted[_membershipId].id += numberOfTokens;
2033       _safeMint(msg.sender,numberOfTokens);
2034   }
2035 
2036   function setIntelAllotment(address[] memory _addresses, uint256[] memory numHeld) public onlyOwner {
2037     require(_addresses.length == numHeld.length, "Array lengths don't match");
2038     //input number of intelligent memberships held by a single address
2039     mulIntelHolders = _addresses;
2040     numIntelHeld = numHeld;
2041     for(uint i = 0; i < _addresses.length; i++) {
2042         intelQuantity[mulIntelHolders[i]].maxMint = numIntelHeld[i] * maxMemberMint;
2043     }
2044   }
2045 
2046   function intelligentMint(uint256 numberOfTokens, Coupon memory coupon) public payable nonReentrant{
2047     require(!paused, "Minting paused");
2048     require(msg.value >= numberOfTokens * memberPrice, "Must send minimum value to mint!");
2049     require(phase >= salePhase.memberSale && phase < salePhase.publicSale, "Not in member sale phase");
2050     require(numberOfTokens + totalSupply() <= 7850 + claimCounter, "Minting would exceed max supply");
2051     bytes32 digest = keccak256(abi.encode(msg.sender,"member"));
2052     require(_isVerifiedCoupon(digest, coupon), "Invalid coupon");
2053     uint256 maxMint = intelQuantity[msg.sender].maxMint;
2054     if (maxMint == 0) {
2055         maxMint = maxMemberMint;
2056     }
2057     require(intelQuantity[msg.sender].numMinted + numberOfTokens <= maxMint, "Would exceed allotment");
2058     intelQuantity[msg.sender].numMinted += numberOfTokens;
2059     _safeMint(msg.sender,numberOfTokens);
2060   }
2061 
2062    function holderMint(uint256 numberOfTokens, Coupon memory coupon) public payable nonReentrant {
2063         require(!paused, "Minting paused");
2064         require(phase >= salePhase.presale && phase < salePhase.publicSale, "Not in presale phase");
2065         require(msg.value >= numberOfTokens * holderPrice, "Insufficient Payment: Amount of Ether sent is not correct.");
2066         require(numberOfTokens + totalSupply() <= 7850 + claimCounter, "Minting would exceed max supply");
2067         require(numMinted[msg.sender].holder + numberOfTokens <= maxHolderMint, "Minted max allotment for this sale phase");
2068         bytes32 digest = keccak256(abi.encode(msg.sender,"standard"));
2069         require(_isVerifiedCoupon(digest, coupon), "Invalid coupon");
2070         numMinted[msg.sender].holder += numberOfTokens;
2071         _safeMint(msg.sender,numberOfTokens);
2072   }
2073 
2074   function partnerMint(uint256 numberOfTokens, Coupon memory coupon) public payable nonReentrant {
2075       require(!paused, "Minting paused");
2076       require(phase >= salePhase.presale && phase < salePhase.publicSale, "Not in presale phase");
2077       require(msg.value >= numberOfTokens * publicPrice, "Insufficient Payment: Amount of Ether sent is not correct.");
2078       require(numberOfTokens + totalSupply() <= 7850 + claimCounter, "Minting would exceed max supply");
2079       require(numMinted[msg.sender].partner + numberOfTokens <= maxPartnerMint, "Minted max allotment for this sale phase");
2080       bytes32 digest = keccak256(abi.encode(msg.sender,"secondary"));
2081       require(_isVerifiedCoupon(digest, coupon), "Invalid coupon");
2082       numMinted[msg.sender].partner += numberOfTokens;
2083       _safeMint(msg.sender,numberOfTokens);
2084   }
2085 
2086   function openHolderPresale(uint256 numberOfTokens) public payable nonReentrant {
2087       require(!paused, "Minting paused");
2088       require(numberOfTokens <= 10, "Can't mint more than 10 tokens per transaction");
2089       require(phase >= salePhase.openSale && phase < salePhase.publicSale, "Not in presale phase");
2090       require(msg.value >= numberOfTokens * holderPrice, "Insufficient Payment: Amount of Ether sent is not correct.");
2091       require(numberOfTokens + totalSupply() <= 7850 + claimCounter, "Minting would exceed max supply");
2092       require(cryptoNative.balanceOf(msg.sender) > 0 || AlejandroAndTaylor.balanceOf(msg.sender) > 0 || earlyWorks.balanceOf(msg.sender) > 0 || curated.balanceOf(msg.sender) > 0, "No MG tokens held");
2093       _safeMint(msg.sender,numberOfTokens);
2094   }
2095 
2096   function publicMint(uint256 numberOfTokens) public payable nonReentrant {
2097       require(!paused, "Minting paused");
2098       require(phase == salePhase.publicSale, "Not in public sale phase");
2099       require(numberOfTokens <= 10, "Can't mint more than 10 tokens per transaction");
2100       require(msg.value >= numberOfTokens * publicPrice, "Insufficient Payment: Amount of Ether sent is not correct.");
2101       require(numberOfTokens + totalSupply() <= 7850 + claimCounter, "Minting would exceed max supply");
2102       _safeMint(msg.sender,numberOfTokens);
2103   }
2104 
2105   function _isVerifiedCoupon(bytes32 digest, Coupon memory coupon) internal view returns (bool) {
2106       address signer = ecrecover(digest, coupon.v, coupon.r, coupon.s);
2107       require(signer != address(0), "ECDSA: invalid signature"); // Added check for zero address
2108       return signer == _adminSigner;
2109   }
2110 
2111   function claimSentient(uint256 membershipId, uint256 numberOfTokens) public {
2112       require(phase >= salePhase.memberSale, "Claiming not open");
2113       require(membershipId < 50, "Must be a Sentient Membership ID (0-49)");
2114       require(membershipContract.balanceOf(msg.sender, membershipId) == 1, "Wallet does not own this membership ID");
2115       require(sentientClaimed[membershipId] + numberOfTokens <= maxSentientClaim, "Sentient Memberships can only claim 3 in total");
2116       require(claimCounter + numberOfTokens <= 150, "All have been claimed");
2117       sentientClaimed[membershipId] += numberOfTokens;
2118       _safeMintID(msg.sender,claimCounter + 1, numberOfTokens);
2119       claimCounter += numberOfTokens;
2120   }
2121 
2122   function airdrop(address[] memory addresses, uint256 numberOfTokens) public onlyOwner {
2123       require(totalSupply() + numberOfTokens <= 7850 + claimCounter, "Exceeds maximum token supply.");
2124       for (uint256 i = 0; i < addresses.length; i++) {
2125           _safeMint(addresses[i],numberOfTokens);
2126       }
2127   }
2128 
2129   function freezeMetadata() public onlyOwner {
2130       require(!metadataFrozen, "Already frozen");
2131       metadataFrozen = true;
2132   }
2133 
2134   function reveal(string memory _URI) public onlyOwner {
2135       baseURI = _URI;
2136       revealed = true;
2137   }
2138 
2139   function _baseURI() internal view virtual override returns (string memory) {
2140       return baseURI;
2141   }
2142 
2143   function tokenURI(uint256 tokenID) public override view returns (string memory) {
2144       if (!_exists(tokenID)) revert URIQueryForNonexistentToken();
2145       if (!revealed) {
2146           return unrevealedURI;
2147       } else {
2148           return string.concat(baseURI,Strings.toString(tokenID));
2149       }
2150   }
2151 
2152   function updateURI(string memory _baseTokenURI, string memory _unrevealedURI) external onlyOwner {
2153       require(!metadataFrozen, "Metadata is frozen");
2154       baseURI = _baseTokenURI;
2155       unrevealedURI = _unrevealedURI;
2156   }
2157 
2158   function withdraw(address secondaryPayee) public onlyOwner {
2159       uint mainBalance = address(this).balance * 9 / 10;
2160       uint secondaryBalance = address(this).balance / 10;
2161       payable(msg.sender).transfer(mainBalance);
2162       payable(secondaryPayee).transfer(secondaryBalance);
2163   }
2164 
2165   function withdrawERC20(IERC20 token, address to) external onlyOwner {
2166       token.transfer(to, token.balanceOf(address(this)));
2167   }
2168 }
2169  
2170 /*
2171 .....,:ldxxxkkkkkkxxdl:,'....,coxxkkkkkkxxdo:,'........................'''''''''''''''''.......................;:lloooool:;,'...........................................................................
2172 ......',lxkkxkxxkkkkkxoc;''...':oxkkkkkkkkkxdc;,'........................''''''',,,,,,,,,''....................;cloodoooooll:;,'........................................................................
2173 ........'cdkkxkkkkkkkxxxl;'.....,cdxxxkkkkkkkxo:,'.......................'''',;;;:::::::::;,''.................,:ldddoooolooolc:;;,'....................................................................
2174 ..........,cdkkkkkkkkkkxxo:'.....';lxkkkkkkxkkxdl;'......................'',;:cllllloooollllc:;'''....'.........,:ooooolcccloolllcc:,''''...............................................................
2175 ............;lxkkkkkkkkkkxdl;......,cdxkkkkkkkkkxo:'.....................',;clooddddddooooooooll:,,;:clcc:;'.....'cllccc::;;:cloooolllc:;,''............................................................
2176 .............':oxkkkkkkkkxxxdc'.....';oxxkkkkkkkkkdc,'..................',;:loooddoooooooollllol;.',;::ccllc;'...,cllc::::;;;;;clllloooolc;,,'....................''''''''..............................
2177 ..............',cxkkkkkkkxxxxko:'.....,cdxkkkkkkkkkkdc,................''';clloooolllllllllllllc;.',,,,;;::c::;:::clolcc:::::;;;:::cllolllcc:;,''',,...........',;;;;;,,,,'.............................
2178 ................';okkkkkkkxxkkkko;.....';lxkkkkkkkkkkxo:'.............''',,;:cloolllcclllccllccc;''',,,,,,;::::lol:;;:c::c::::::::::ccccccccclc:::cc,'.',;,...,:ccccc::;;;,'............................
2179 ..................':dkkkkkkkkkkkkdc'.....':oxkkkkkkkkkxdc,..........';ccloolc::ccllllccllcclcccc:,,,,,'''',;:clodd:,',,,;;::::::::::::::ccccllllllol;',,,,;,,,:cllllllc:::;,............................
2180 ....................,cdkkkkkkkxxxkxl,.....';lxkkkkkkkkkkxl:;'.......:ooxOkkkkxol:;:cccllllllllloc;,;;,'..',;:cldxd:,;;,,,,;;::c:ccc::::::ccccccllllc;';ll:;,,;clooooollccc::,...........................
2181 ....................'',ldxxkkkkkkxxxd:'...'',:dkkkkkkkkkkxdl:,'....'ldoxOOOOkkkxdo:;,;;::::::ccl:,,,,'....',:cclllc;,,,,;;;:::cc:cccc:::::c::::cclll:,,ldoc;,;cllooollcccccc;...........................
2182 ......................'';ldxxkkkkkkkkxo;'..'..,cdkkkkkkkkkxxdc;'...;oddxxxxxxxkkkxdol:;,,,,',,,,,,;,,'....,;:::cccc:;,,;ccccccccc:ccc::ccccc::cccccc:;;lddl:;;:ccllllccccccc:'..........................
2183 ........................',:ldkkkkkkkxxxdc'......,lxkkkkkkkkkkxl:,.':loddddddddddxxxxxxdoc:;,,'',,,;;;,'.'';::::cclccc:::cllllloollccc::;:::ccccllllllcloddolc;;ccccccc::c::c:'..........................
2184 ..........................',coxkkkkkkxxxxl,......'cxkkkkkkkkkkxol:,:lddddddddooooddoodk0Okkdlll::cllcccc::::;;:clllccclllloolllloooooll::::c::cccclllodxdooooc;;clc::cccc::c:'..........................
2185 ............................',cdxkkxkkkxkxl;'.....';dkkkkkkkkkkxddl:clxxdddollllllloodk000OOOxl:cddddddoolcclloxxddollllllllllllloodddoolcc::;;:cloolooddollooc:;:llccllcccc:'..........................
2186 ..............................':oxkkkkkkkkkdc,'.....,cxkkkkkkkkkxddollddoolllllodooodxO000OkxoclodxdddooddxxkkOO00OOxdlllllccllllloodddoollcc:clooollloooollllll:;lolllllccc:'..........................
2187 ...............................';oxkxkkkxxkkkd:,......:okkkkkkkkkxdddddolllllloddxxxkO0K00kdoloddxkxddoodk00O00000000Oxoccllcllllllooddddoooooooooollloooollclloo:coddollcc:;'..........................
2188 ................................';coxkkxxkkkkkxl;'.....,lxkkkkkkkxxxddddolldddddddxO0000OOkdc;cdxkkxxdddxkO000000000000Oxdoooooooooodxkkkxxxkkxddddoooollllllllodl:lddolcc::;'..........',,,'...........
2189 ..................................';ldxkkxxkkkkkxl;.....';okkkkkkxxxxxxdddxxxxxxddxO00000Okxl:lkkkkxxxxkkkO0000000000000000OOOOkkkOOO000OOOOOOkkxdddooollccccllokd;:ddllccc:,'.....'',;;:cll:,'''.......
2190 ...................................'';lxxxkkkkkkkkdl,..'..':dkxxxxxxxxkkxdxxddxxddxOKKKKK0OxdoxOOOkkxxkkOOO000K000000000000000K0000000OOOOOOOOOOkxxdddolccccclloxkl:lddolll:,''',,;::ccllloll:;,,'......
2191 ...................................''',:oxkkkkkkkkkko:''...,cdxxddxxddxkkxxxxxxxdddk000K0K00OOO00000OOO000000KK000000000000000KKK0000000O00OO00OOOOkkxdlccllllloddl:cxxxdddl:;;;::cclllcclllc:;;;,,'....
2192 ......................................'',cdxkxkkxxkkxdl:,..,cxkxxdxxdddxkxxxxxxxddxO0KK00000000000KK0K000000KKKK000KKKK000000000KKK00000O00000000000000kdoolllloxko:cdkkkkxdlccccc:::::ccccc:::;;;,'....
2193 ......................................'''',cdkkkkkkkxxxdl:;;lxkkxxdxxdddxxxxxxxkkO0KK00K0000000000KK000000KKKKKKKKKKKKKKKK000000000000OkkO00KK00KKKK0000kdolllodxko:cldxkkkxoc:;,,,,,,;:c::::::;;,'.....
2194 .......................................'''',coxkkkkkkxkkkdoodxkOkxddxxxdddddxkkO0KKKK000000000000000000000000KKK00KKK0KKKK00K000000O0OkddxkO0000KKKK0000Oxooooodxxo;:llodddolc:;;;;:c:;;;:::::;;;,'.....
2195 ........................................''''';cdkkOkkkkkkkkxxkOOkkxddxxdddddddxkOO00000000000000000000000000000000000000000KK000KK000OOkxxxxxxkO0K0K0000Oxdoooodxxdc;ccclloollccc:;;::;,;:::::;;,.......
2196 ..........................................'''',;ldkkkkkxxxkkkkkOOOkdodddxxxdddddxxkO0O0000000000000000000000000000000000KK00000KKK00000OOkkxxddxxO0000000Okkxddxdddoccccloooooolc:;'''',;::::;;;,.......
2197 ............................................'''',:oxkxxxxxxxxxkkOOkxoloddxxxddddoddxkO0000000000000000000000000000000000KK00000K00OOOO000000OkkxddkO00K00K000OOkkxdoolccccccllollc;'...,:c:c:;;;;'......
2198 ...............................................''';ldxxxdxxxxxxkkOOkdcclddxxxddddoodddkO000000000000OO000000000000000000000000000OOOOOOOOO0000Okkxdk00000KKKK0OOkxdlcccc:ccclllllc:,'.';cccc:;,;;'......
2199 ................................................'',:okkxxxxdxxdxxkkkxocclodxxdddddooooodk00000000000O000000000000OOOO00O000000000OOOOOOOOOO00K00Okxxk00KKKKKK00Oxolccccc::ccccccc::,'',clc:::,,,'.......
2200 ...............................................'..',lxkkxdxddxxxxdoldxdollloddddddddoooooxO0O0000000O00000000OOOOOOOOOOOOOOOOOOOOOOOOOOOOOO00KK00OOxxkOKKKKKK00Oxolcccc:::cccc::::;,'':cc::;;'''........
2201 ..............................................''''',cdkOkdoddxxddolcdOkkkdooooodxdddddooooxOOO00OO0OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO00K00OkkkO0KKKKK0Oxocccccc:::cccc:::,'';::;;;;,...........
2202 ..............................................'''',;ck0OkocloddoooodO0OkkkkkxdoooxxxddooooodkOOkkkOOkOOOOOkkkkkkkkkkOOOOOOOOOOOOOOOOOOOOOOOOOkOO0K00OOkkkO00KKK0Okkxxollclllccc::;,,,:::;;,''...........
2203 .............................................''''';ldkOOOkdodddddkO000OOOOkkkOkolodxxdddoooodxxddddddxxkkkkkkkOOkkkkkOOOkkkOOOOOOOOOOOOOOOOOOOOOO00000OkkkO00K0KK00Okkxooodolc:::;,,:::::,'.............
2204 .............................................'..';lddxxkO00K0000000000OOkkkkxkxdllodxxdddooooddddddddddxxxxxxkkkkkkkkkkkkkkkkkkOOkkkkkkkkkkkkkkOOO0000OOkkkOO0KK00Oxxkddddolc:::;,,:c:::;,..............
2205 .............................................'..,:ldollok00000000OOOOOkkkkkkxxdlclodddxdddoooodxkkO00OkkxxxddddxxxkkxxxxxxxxxxxxxkxxxxxxxkkkkkkkkkOOOOOkxkOOk0KK00Oxxdooddoc:::;,,;cc:::;'..............
2206 ............................................','';codlc:coxkkkkOOkkkkkkkkkkkkxdllloxOOkkxxxdddoodxkO000000OkxdddooddxkkxxxxxxxxxxxxxxxxxxxxxxxxxxxkkkkkkxxkkkO00K0Okxdooodocc:::;,;:cc:::;'..............
2207 ...........................................'cl,';clc:::::loodxxkkkkkxxxkkkxdolloxO00000kxxddddoloxkkkxxkkO0OOkxddoooddxxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkxxkxxxOKK0OOkxdoodddlcc::;,;:ccc:::;...............
2208 ...........................................;oc;;:cc::::::ccccoxkkkxxxxxxddolldxO00KK0000OkxddxdoooodddoddxkO00Okkxdooooddddxxxxxxxxxxxxxxxxxxxxxxxxkdldkxxk0K0Okkxdoodddlccc:;,,:cccc::;'...............
2209 .........................................';cl:;:cc:::::c::c::lxxxxxxxdoolodxO0000000000000kkxddddooooodoooodkO000OOOkxdooooddxxxxxxxxxxxxxxxxxxxxxkxllxxxO0000Okkxdodxdlc:c:;;,;:c:::::,'...............
2210 ..........................................;;;:cccccccccccc:ccoolllllllodxOO000000O00000K000Okkxdxxdooodoollldxk00000OOkxddoloodxxxxxxxxxxxxxxxxxxxxocdkxOK00Oxxxdddddolccc::;;,;:cc:::;,'...............
2211 ...........'.............................,;::looolccc::::::cc:::::cldkkO00000000000000KK0000OOkxxxxdddddollloodkO00000O0Okxdlloodxxxxxxxxxxxxxxxxxdodddk0000Oxdddoddolcccc:;,,',:cc:;::;'...............
2212 ........................................,;:loxxxdoc::;;;;:ccc:clodxO0000000000000000K000000000OkxxxxxddxdooooooddkO00000000OkdooodxkkkxxxxxxxxxxxxdddcoO0000Oxddoodol::ccc:;,,',:ll:;:c;'...............
2213 .......................................';:ldxxxddlc:;::cccclldxkO000000000000000O00000K0O000000kxxxxxdooooodxdooodk00000000000OkkkkOOOOkkkkxxxxxxdxdlcxO00OOkddddddolc:ccc:;,,',:llc:::,................
2214 ......................................';codxxxdlllc::cccloxkk00000000000000000O0OOO0OO0OOO0O0K0OkdooooooodkO0OkxdodxO000000KK0000000000Okkkxxxxxxxxoox000Okkkddddddolccccc:;,,,;:cc:::;'.............'''
2215 ......................................,:oxxxxxdllccccccoxkk0000000000000000000O00OO0OOOkkO0O00000OkkkkkkkO00000kxdooodkO00000000000000OOkkkxxxxxxxxdx000OOkkxxxxddoooccclc;,,,,;ccc:::;'...............'
2216 .....................................,;ldxkkkkkxdollccccloodxxkO000OO00000OO00OOOOOOOkkkkOOOOO0000000000KK00000OOxddddkO0000000000000OOOkkxxxxxxxkkkO00000Okkkkxxddoolccllc,,;;:clcc::;'................
2217 ..................................',,,;codO00O00OOkdolc:cc::cclldxkO000000OOkOOOOOOkkxxxxkkkkkO0000000000K00K00000OOOOO00000000000000OOOkkxxxxxkxxkOO0K00K0OOOOkxddoooolooc;,;:ccccc::;,''..............
2218 ..................................;:;,,;:ldkO00000K0OOkxxolcc::::cok00000OOkkkkOOOOOkxdodddxkxxOO0000KKK0000K000000000000000000000O00OOOkkxxxxxxkkkO0000KKK00K0Oxdoodooddoc;;;clllcc::;,'''''...........
2219 .................................,loc:,,',:okkO0000K000000OkkxxdocldO000Okkkkkkkkkkkxddooolloolodk00KKKKKKK000K00000000000000000000OOOOOOkxxxxxxkOOOO000KKKKKKK0kddddooddc:;;cllllc::;;,,''''...........
2220 ..................................,lxkxl;,',cdOOO00000O000000000Oxdxk00OkkkkkkkkkkkkxdolllllllllloxOO00KK00000000000000000000000000OOOOOkkxxxxxxxxxkOO00KKKKKKXKkxxxdooooc;,:lolllc:;;,,,,,''...........
2221 ....................................;okOx:,,,lk00000OxooxO000000000OO000Okkkkkkkxxxxxdoolcc:ccccccloddxkOOOOO0K00000000000000000OOOOOOOOkxxxxxxxxoodkOkO0KKKKXXKOkkkddool:,':oollc::;;;;;,,'''..........
2222 ......................................lOOo;;;ck00OkOxc,':dOOOO00OO000000OkkkkkkkkxxxdoolllccccclcccloooodkOOOO00OOOO0OOOOOOO0000OOOOOOOkkkxxxxxxxdddxkkxk0KKKKXK00Oxdddol:,',::::::;;;;;;,,,''..........
2223 .......................................lko;,,ck00OOkd;'',:c::ldO000000K0OkkkkkkkxkkkxdoooooollcllcccllllodxkOOOOOOOOOOOOOOOOOOOOOOOOkkkOOOkkkkkkkxxkkOOdld0KKKKK0Okxddol:;''',;;;;;;;;;;;,,,''..........
2224 ........................................;c;,,:x0OOOkkl;;;;;''';dO0000000OkkkkkkkkkkOOkxxxxxxkxdooolllcllldxkkkkkkkkkkOOOOOkkkkOOOOkkkkkOOOOOOOkkkkkOO0OxlldkKKXKOkxxddoc:;,'.',;;;;:;;;;,,''''..........
2225 ..........................................,,';d0Okkxdlclddc,'',cdO000KK0OkkkkkkkkkkkkkkkkkOkkkxxxxxdddddxxxxxxxxxkkkkkkkkkkkkkkOOkkkkkkkOOOOOOOOkOOO0Oxc:cokKKXK0kkxxxdoc;,'.',;;;;;;;,,,''''...........
2226 ...........................................,''l00dllllccoolc;,,,:ldk0K0OOkkkkkkkkkkkkkkkkkkkkxxxxxxxxxxxxxxxxxxxxkkxxxxxxxxkkkkkkkkkOOOOOOOOOOOOO0OOOdc::lk0KKKK0Okkkxxdl:;,''',,,,',,''''..............
2227 ............................................''cOOl;;clllc:;:clc:;,,cxK0OOkkkkkkkkkkkkkkkkkkkkxxxxxxxxxxxxxxxxxxxxxxxxxxxkkkkkkkkkkOOO0OkOOkOOOkO000kocldxk0K0000Okxxxddlcc:;,,,;;;,'''..................
2228 .............................................'lkOo;,,;;,,:cldxxdlc:cx0OkkkkkkkkkkkkkkkkkkkkkkkxxxxxxxxxxxxxxxxxxxxxxxxkkkkkkkkkO0OO0O0OOOkOOOkkO0OxoclodkO00OOkxdlllccccccccccccc:'....'................
2229 .............................................,lO0xooc:::lodxxxxxxxxOOkxkkxkkkkkkkkkkkkkkkkkkkkkkxxxxxxxxkkkkkkkxxxxkkkkkkkkOOOO0K00OO00K0OOkkxolc;:loddxkkkxddolc:::;::c::cclllc::'....'................
2230 .............................................'ck00OkkxxxxxxkkxkkkkOOkxkxxxkkkkkkkkkkkkkkkkkkkkkkxxkkkkkkkkkkkkkkkkkkkkkkOOOOOxddxxdddddddol:;,,,;:loollollllccc::::;;;:::cccllc:;;,....'................
2231 .............................................,lk0OOkkkkkxxxxxkkkkkkkkxxxxkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOOOOkxl:;:;;,;;;;::::c:cloodddlcccccccccc::::;;;;;;;;:::;,'.....'.................
2232 ............................................'cdxxxxxxxkkkkkkkkkkxxkkkxxkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOOkkdlcloxollcccllllooodddddxdoccccccccccc::::;;;;;;;::;,...''....'...............
2233 ...........................................'cdxxxxxxxxxxxxxxxxxxxxxkxxxxkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOOkxdoodxkOkxddooooooooddddddddolllcccc:::;;::ccc:::::cllc,'..'....................
2234 ..........................................'cdxxxxxxxxxxxxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOOOOxlclodkkOkxdodddddddddddddddoollccccc:;;;;;;:::::::::ccc;,..'....................
2235 .........................................;ldkkxxxxxxxxxxxxxxxxxxxxxxxxxdxkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkOkOkd::odxkkkkkxddxxdxxxxxxxxxxxxxolccccc::c:;,,;;;;::::::::::,''''..................
2236 ........................................'cxkkkkkkxxxxxxxxxxxxxxxxxxxxxddxkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkxl;,cdxkkkkOOkkkOOOOOOOOOOOOOOkkdlccc:::ccc;,,,,,;;::::::::::;,''..................
2237 ........................................,cdxxkkxxxxxxxxxxxxxxxxxxxxxxddxkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkxxxoc;'.,lxxkkOO0OOOOO000KKKKKKKK0K0Okdlcc::;;::;;,,,,,;:::::::::;;;,'..................
2238 ........................................';ldxxkkxxxxxkkxxxxxxxxxxxxxxxxkkkkkkkxkkkkkkkkkkkkkkkkkkkkkkkkkOOOkkxxdolc:;,';ldkkOOOOOOO000KKKKKKKKK000000Oxoolc:;;;;;;;,,,,;;:::::;;;;;;'...................
2239 ........................................';:ldoodoooodddddxkxxxxxxxxxxxkkkkkkkkkkkkkkkkkkOkkkkkkkkkOOkkxddollllllccccc::ldkOkkxxxkO0000KKKKKKK0OOOOkkkxddolc::;;;;;;;,,,;;::::;;;;;,'....................
2240 .........................................';:lol::ccccc::cldxxxxxxxxxkkkkkkkkkkkkkkkOOOOOOkkkxxxdoolllc:;;:loodxxxxxxxddxkOOkxxxkkO0KKKK0KKK0OOOOkkdddxdooolcc:;,',;;,,;;::::;,,,,,'.....................
2241 ...........................................';cc,.';,,::;;;:odxxxxkkkkkkkkkkkkkkkkkkOOkkkxxdooc:;;;:ccloddxkkkkkkkkOOkkkkkkxxxkkkOO0KK00KK0OkkOOkxxdooooolooolcc;;;;;;;:::::;,'''''......................
2242 ......................................................,,,,;:cdxxkkkkkkkkOOkkkkkkxxddoolc::;:clloddxkkkkkkkkkkkkkkkOkkkkkkxxxkOOOO00000KKKK0Okkxxxxxddolllloooolc:;;;:;;;;:;,''''........................
2243 .........................................................',,;oxxkkkkkkkOkkxddoollcc::::::lodxxkkkkkkkkkkkkkkkkkkkkkkOOkxxddxk00000KK00KK0000Okxxdollollccllooollc:;;;,'',;;;,''.........................
2244 .............................................................,coxxxxdoolcc:::ccloooodddxxxxkkkkkkkkkkkkkkkkkkkkkkOOOOOkxdoodxkO000KK0KKK000kxxxdoccclcccccloooolc::;,,,'',:c:,'.........................
2245 ...............................................................;cc:;:::clooodxxxxxxxxxxxxxxkkkxxkkxxxkkkkkkkkOOOOOkkOOxdoodddxkO00K0000KKOxddxdolclllllcclooooollc:;:;;::cllc:,.........................
2246 ................................................................'';;:codxxxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkkkOO00kxkkkdollooooxO0000000000Okxddolccllclcccloolloollccllllllllllc,........................
2247 ..................................................................''':ldkxxxxxxxxxxxxxxxxxkkkkkkkkkkkkkkkkkOO00OdoxdollllllloxO0000000000Okdolcccclccc::clllccllllllllllcllcccc;'.......................
2248 ....................................................................',:dkkxxxxxdxddxxxxxxkkkkkkkkkkkkkkkkkOO00OkolllccllllllooxO00000000Okdolcccccccccccclllcc:cccllolcccccc:c::,.......................
2249 ....................................................................'''cdxkxxxxxxxxxxxkkkkkkkkkkkkkkkkkkkOOO00Okl:cccccccccllloxk00K00K00kxdxdoolcccccloooollcccccclllcccc::::::;'......................
2250 ......................................................................';cdxxxxxxxxxxxxkkkkkkkkkkkkkkkkkkOO00000Ol;:cccccccccclldk0K000KKK0kxxkxxoloddoxxxxddolcclcc:cccccc::::::,.......................
2251 .......................................................................,:ldxxxxxxxxxxxkkkkkkkkkkkkkkkkkOOO000000x::::::ccccccllldOKK00KKK00OOOOOkkkkOkOOkkkxddoollc:ccccc:::;,,'........................
2252 .......................................................................',:ldxxxxxxxxxxkkkkkkkkkkkkkkkkOOO0000000kl;,,;::ccc:cloooxO0KKKKK00KKKKKKK000OOkkkkxxdddolc:;:ccc:,'''..........................
2253 .......................................................................'',;lxxxxxxxxxxkkkkkkkkkkkkkkkkOOO00000000ko:,,;:::::::coodxOKKKK0OO00OOOOOkkxxxxxddddoooollc:;;::;'.............................
2254 ........................................................................''':dxxxxxxxxxkkkkkkkkkkkkkkOOOO0000000000Okxoooc;;;::ccloxO00K0Oxdddddddooddddddooolllllooodolc;,'.............................
2255 ...........................................................................;ldxxxxxxxdxkkkkkkkkkkkkOOOOOO000K000000OOOO0Ooccc::ccldk000kddooooolllllollclloolllooddxkxoc,...............................
2256 ..........................................................................',:lddxxxxxdxkkkkkkkkkkkkOOOOO0000K000K000OOO00OkkxollccldO0Oxoooollllllccllcclooooooddxxdo:,.................................
2257 ...........................................................................',:odxxxxxxxxkkkkkkkkkkkOOOOOO0000000000000000000Oxoolllldkxdoooolllccccllllloooolc:::::;;,'.................................
2258 .............................................................................,codxxxxxxxxkkkkkkkkkkOOOOOO000000000000000000O0Okxololoddoooooolllllooodddddol:,..........................................
2259 .............................................................................';lodxxxxxxxkkkkkkkkkOOOOOOO00000000000K000000O00OOkdllllddddooooooddxxxkOxxdol;'..........................................
2260 ..............................................................................,:cdxxxxxxxxkkkkkkkkOOOOOOO000000000KKK000000000O00Oxdl:;:looooooodxxxkxdoc;::'...........................................
2261 ...............................................................................';codxxxxxxxkkkkkkkkOOOOOO000000000K0K0000000000000OOxl:,,;;:::cccllccc;',,,'............................................
2262 .................................................................................,:odxxxxxxxkkkkkOOOOOOOOO00000000000000000000000000OOxo:,''',,;;:llldddddxxoc,.........................................
2263 .................................................................................',:oxxxxxxxxkkkkkOOOOOOO00000000K0000000000000000000000Odl:,''''',;:cloddooddo,........................................
2264 ..................................................................................',;cdkxxxxxxkkkkOOOOOOO00000000000000K00K000000000000000OOxollc:;,,,,,,,,,,,:;........................................
2265 ..........................................................................'......',,;;:dxxxxxxkkkOOOOOOOOO0000KKK00KKK0K00000000000000KK000000000Okdol:;,'.''.'.........................................
2266 .....................................................................',,;:ccllllcccc;,:ldxkxxxkkkOOOOOOOOO00000KK000KK00000000K00K0000K0000000000KKK00Oxdl:'......'.....................................
2267 ...............................................................'';:clooddkOOOOO0Oxdlc;,:oxxxxxxkkOOOOOOO00O0000000K000K00000000KKK0000KKK00000000K0KKKKKK0Od:'..........................................
2268 ................................................''.....''.'',;:lodxxxxkxkkkkOOOOOOxdc:;;lxxxkxxkkkOOOOOO00O000000000K0000K00000KKK0000K0K0000000000KK0KKK000ko:'........................................
2269 ..............................................'''''',,'';:looxxxkkkkkkkkkkkkOO000K0Ooc:;coxxxxxkkOOOOOOO00O00000000000K0000000000K00000000KK000KKK0KKKK0000000Oxl;',,,..................................
2270 ..................................................';;::coxxkkkkkkkkkkkkkkkOO0KKK00XX0o::clxkxxxxkkOOOOOO00O0000000KKKKKKK000K0000000000000KK0000KKKKKKKKXK0000OO0Ol:olc;'...............................
2271 */