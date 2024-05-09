1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.7;
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
67 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
68 
69 
70 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
71 
72 pragma solidity ^0.8.7;
73 
74 /**
75  * @dev Interface of the ERC20 standard as defined in the EIP.
76  */
77 interface IERC20 {
78     /**
79      * @dev Returns the amount of tokens in existence.
80      */
81     function totalSupply() external view returns (uint256);
82 
83     /**
84      * @dev Returns the amount of tokens owned by `account`.
85      */
86     function balanceOf(address account) external view returns (uint256);
87 
88     /**
89      * @dev Moves `amount` tokens from the caller's account to `to`.
90      *
91      * Returns a boolean value indicating whether the operation succeeded.
92      *
93      * Emits a {Transfer} event.
94      */
95     function transfer(address to, uint256 amount) external returns (bool);
96 
97     /**
98      * @dev Returns the remaining number of tokens that `spender` will be
99      * allowed to spend on behalf of `owner` through {transferFrom}. This is
100      * zero by default.
101      *
102      * This value changes when {approve} or {transferFrom} are called.
103      */
104     function allowance(address owner, address spender) external view returns (uint256);
105 
106     /**
107      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
108      *
109      * Returns a boolean value indicating whether the operation succeeded.
110      *
111      * IMPORTANT: Beware that changing an allowance with this method brings the risk
112      * that someone may use both the old and the new allowance by unfortunate
113      * transaction ordering. One possible solution to mitigate this race
114      * condition is to first reduce the spender's allowance to 0 and set the
115      * desired value afterwards:
116      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
117      *
118      * Emits an {Approval} event.
119      */
120     function approve(address spender, uint256 amount) external returns (bool);
121 
122     /**
123      * @dev Moves `amount` tokens from `from` to `to` using the
124      * allowance mechanism. `amount` is then deducted from the caller's
125      * allowance.
126      *
127      * Returns a boolean value indicating whether the operation succeeded.
128      *
129      * Emits a {Transfer} event.
130      */
131     function transferFrom(
132         address from,
133         address to,
134         uint256 amount
135     ) external returns (bool);
136 
137     /**
138      * @dev Emitted when `value` tokens are moved from one account (`from`) to
139      * another (`to`).
140      *
141      * Note that `value` may be zero.
142      */
143     event Transfer(address indexed from, address indexed to, uint256 value);
144 
145     /**
146      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
147      * a call to {approve}. `value` is the new allowance.
148      */
149     event Approval(address indexed owner, address indexed spender, uint256 value);
150 }
151 
152 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
153 
154 
155 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
156 
157 pragma solidity ^0.8.7;
158 
159 
160 /**
161  * @dev Interface for the optional metadata functions from the ERC20 standard.
162  *
163  * _Available since v4.1._
164  */
165 interface IERC20Metadata is IERC20 {
166     /**
167      * @dev Returns the name of the token.
168      */
169     function name() external view returns (string memory);
170 
171     /**
172      * @dev Returns the symbol of the token.
173      */
174     function symbol() external view returns (string memory);
175 
176     /**
177      * @dev Returns the decimals places of the token.
178      */
179     function decimals() external view returns (uint8);
180 }
181 
182 // File: @openzeppelin/contracts/utils/Strings.sol
183 
184 
185 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
186 
187 pragma solidity ^0.8.7;
188 
189 /**
190  * @dev String operations.
191  */
192 library Strings {
193     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
194 
195     /**
196      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
197      */
198     function toString(uint256 value) internal pure returns (string memory) {
199         // Inspired by OraclizeAPI's implementation - MIT licence
200         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
201 
202         if (value == 0) {
203             return "0";
204         }
205         uint256 temp = value;
206         uint256 digits;
207         while (temp != 0) {
208             digits++;
209             temp /= 10;
210         }
211         bytes memory buffer = new bytes(digits);
212         while (value != 0) {
213             digits -= 1;
214             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
215             value /= 10;
216         }
217         return string(buffer);
218     }
219 
220     /**
221      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
222      */
223     function toHexString(uint256 value) internal pure returns (string memory) {
224         if (value == 0) {
225             return "0x00";
226         }
227         uint256 temp = value;
228         uint256 length = 0;
229         while (temp != 0) {
230             length++;
231             temp >>= 8;
232         }
233         return toHexString(value, length);
234     }
235 
236     /**
237      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
238      */
239     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
240         bytes memory buffer = new bytes(2 * length + 2);
241         buffer[0] = "0";
242         buffer[1] = "x";
243         for (uint256 i = 2 * length + 1; i > 1; --i) {
244             buffer[i] = _HEX_SYMBOLS[value & 0xf];
245             value >>= 4;
246         }
247         require(value == 0, "Strings: hex length insufficient");
248         return string(buffer);
249     }
250 }
251 
252 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
253 
254 
255 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
256 
257 pragma solidity ^0.8.7;
258 
259 
260 /**
261  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
262  *
263  * These functions can be used to verify that a message was signed by the holder
264  * of the private keys of a given address.
265  */
266 library ECDSA {
267     enum RecoverError {
268         NoError,
269         InvalidSignature,
270         InvalidSignatureLength,
271         InvalidSignatureS,
272         InvalidSignatureV
273     }
274 
275     function _throwError(RecoverError error) private pure {
276         if (error == RecoverError.NoError) {
277             return; // no error: do nothing
278         } else if (error == RecoverError.InvalidSignature) {
279             revert("ECDSA: invalid signature");
280         } else if (error == RecoverError.InvalidSignatureLength) {
281             revert("ECDSA: invalid signature length");
282         } else if (error == RecoverError.InvalidSignatureS) {
283             revert("ECDSA: invalid signature 's' value");
284         } else if (error == RecoverError.InvalidSignatureV) {
285             revert("ECDSA: invalid signature 'v' value");
286         }
287     }
288 
289     /**
290      * @dev Returns the address that signed a hashed message (`hash`) with
291      * `signature` or error string. This address can then be used for verification purposes.
292      *
293      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
294      * this function rejects them by requiring the `s` value to be in the lower
295      * half order, and the `v` value to be either 27 or 28.
296      *
297      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
298      * verification to be secure: it is possible to craft signatures that
299      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
300      * this is by receiving a hash of the original message (which may otherwise
301      * be too long), and then calling {toEthSignedMessageHash} on it.
302      *
303      * Documentation for signature generation:
304      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
305      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
306      *
307      * _Available since v4.3._
308      */
309     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
310         // Check the signature length
311         // - case 65: r,s,v signature (standard)
312         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
313         if (signature.length == 65) {
314             bytes32 r;
315             bytes32 s;
316             uint8 v;
317             // ecrecover takes the signature parameters, and the only way to get them
318             // currently is to use assembly.
319             assembly {
320                 r := mload(add(signature, 0x20))
321                 s := mload(add(signature, 0x40))
322                 v := byte(0, mload(add(signature, 0x60)))
323             }
324             return tryRecover(hash, v, r, s);
325         } else if (signature.length == 64) {
326             bytes32 r;
327             bytes32 vs;
328             // ecrecover takes the signature parameters, and the only way to get them
329             // currently is to use assembly.
330             assembly {
331                 r := mload(add(signature, 0x20))
332                 vs := mload(add(signature, 0x40))
333             }
334             return tryRecover(hash, r, vs);
335         } else {
336             return (address(0), RecoverError.InvalidSignatureLength);
337         }
338     }
339 
340     /**
341      * @dev Returns the address that signed a hashed message (`hash`) with
342      * `signature`. This address can then be used for verification purposes.
343      *
344      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
345      * this function rejects them by requiring the `s` value to be in the lower
346      * half order, and the `v` value to be either 27 or 28.
347      *
348      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
349      * verification to be secure: it is possible to craft signatures that
350      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
351      * this is by receiving a hash of the original message (which may otherwise
352      * be too long), and then calling {toEthSignedMessageHash} on it.
353      */
354     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
355         (address recovered, RecoverError error) = tryRecover(hash, signature);
356         _throwError(error);
357         return recovered;
358     }
359 
360     /**
361      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
362      *
363      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
364      *
365      * _Available since v4.3._
366      */
367     function tryRecover(
368         bytes32 hash,
369         bytes32 r,
370         bytes32 vs
371     ) internal pure returns (address, RecoverError) {
372         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
373         uint8 v = uint8((uint256(vs) >> 255) + 27);
374         return tryRecover(hash, v, r, s);
375     }
376 
377     /**
378      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
379      *
380      * _Available since v4.2._
381      */
382     function recover(
383         bytes32 hash,
384         bytes32 r,
385         bytes32 vs
386     ) internal pure returns (address) {
387         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
388         _throwError(error);
389         return recovered;
390     }
391 
392     /**
393      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
394      * `r` and `s` signature fields separately.
395      *
396      * _Available since v4.3._
397      */
398     function tryRecover(
399         bytes32 hash,
400         uint8 v,
401         bytes32 r,
402         bytes32 s
403     ) internal pure returns (address, RecoverError) {
404         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
405         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
406         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
407         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
408         //
409         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
410         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
411         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
412         // these malleable signatures as well.
413         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
414             return (address(0), RecoverError.InvalidSignatureS);
415         }
416         if (v != 27 && v != 28) {
417             return (address(0), RecoverError.InvalidSignatureV);
418         }
419 
420         // If the signature is valid (and not malleable), return the signer address
421         address signer = ecrecover(hash, v, r, s);
422         if (signer == address(0)) {
423             return (address(0), RecoverError.InvalidSignature);
424         }
425 
426         return (signer, RecoverError.NoError);
427     }
428 
429     /**
430      * @dev Overload of {ECDSA-recover} that receives the `v`,
431      * `r` and `s` signature fields separately.
432      */
433     function recover(
434         bytes32 hash,
435         uint8 v,
436         bytes32 r,
437         bytes32 s
438     ) internal pure returns (address) {
439         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
440         _throwError(error);
441         return recovered;
442     }
443 
444     /**
445      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
446      * produces hash corresponding to the one signed with the
447      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
448      * JSON-RPC method as part of EIP-191.
449      *
450      * See {recover}.
451      */
452     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
453         // 32 is the length in bytes of hash,
454         // enforced by the type signature above
455         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
456     }
457 
458     /**
459      * @dev Returns an Ethereum Signed Message, created from `s`. This
460      * produces hash corresponding to the one signed with the
461      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
462      * JSON-RPC method as part of EIP-191.
463      *
464      * See {recover}.
465      */
466     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
467         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
468     }
469 
470     /**
471      * @dev Returns an Ethereum Signed Typed Data, created from a
472      * `domainSeparator` and a `structHash`. This produces hash corresponding
473      * to the one signed with the
474      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
475      * JSON-RPC method as part of EIP-712.
476      *
477      * See {recover}.
478      */
479     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
480         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
481     }
482 }
483 
484 // File: @openzeppelin/contracts/utils/Context.sol
485 
486 
487 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
488 
489 pragma solidity ^0.8.7;
490 
491 /**
492  * @dev Provides information about the current execution context, including the
493  * sender of the transaction and its data. While these are generally available
494  * via msg.sender and msg.data, they should not be accessed in such a direct
495  * manner, since when dealing with meta-transactions the account sending and
496  * paying for execution may not be the actual sender (as far as an application
497  * is concerned).
498  *
499  * This contract is only required for intermediate, library-like contracts.
500  */
501 abstract contract Context {
502     function _msgSender() internal view virtual returns (address) {
503         return msg.sender;
504     }
505 
506     function _msgData() internal view virtual returns (bytes calldata) {
507         return msg.data;
508     }
509 }
510 
511 // File: @openzeppelin/contracts/security/Pausable.sol
512 
513 
514 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
515 
516 pragma solidity ^0.8.7;
517 
518 
519 /**
520  * @dev Contract module which allows children to implement an emergency stop
521  * mechanism that can be triggered by an authorized account.
522  *
523  * This module is used through inheritance. It will make available the
524  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
525  * the functions of your contract. Note that they will not be pausable by
526  * simply including this module, only once the modifiers are put in place.
527  */
528 abstract contract Pausable is Context {
529     /**
530      * @dev Emitted when the pause is triggered by `account`.
531      */
532     event Paused(address account);
533 
534     /**
535      * @dev Emitted when the pause is lifted by `account`.
536      */
537     event Unpaused(address account);
538 
539     bool private _paused;
540 
541     /**
542      * @dev Initializes the contract in unpaused state.
543      */
544     constructor() {
545         _paused = false;
546     }
547 
548     /**
549      * @dev Returns true if the contract is paused, and false otherwise.
550      */
551     function paused() public view virtual returns (bool) {
552         return _paused;
553     }
554 
555     /**
556      * @dev Modifier to make a function callable only when the contract is not paused.
557      *
558      * Requirements:
559      *
560      * - The contract must not be paused.
561      */
562     modifier whenNotPaused() {
563         require(!paused(), "Pausable: paused");
564         _;
565     }
566 
567     /**
568      * @dev Modifier to make a function callable only when the contract is paused.
569      *
570      * Requirements:
571      *
572      * - The contract must be paused.
573      */
574     modifier whenPaused() {
575         require(paused(), "Pausable: not paused");
576         _;
577     }
578 
579     /**
580      * @dev Triggers stopped state.
581      *
582      * Requirements:
583      *
584      * - The contract must not be paused.
585      */
586     function _pause() internal virtual whenNotPaused {
587         _paused = true;
588         emit Paused(_msgSender());
589     }
590 
591     /**
592      * @dev Returns to normal state.
593      *
594      * Requirements:
595      *
596      * - The contract must be paused.
597      */
598     function _unpause() internal virtual whenPaused {
599         _paused = false;
600         emit Unpaused(_msgSender());
601     }
602 }
603 
604 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
605 
606 
607 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)
608 
609 pragma solidity ^0.8.7;
610 
611 
612 
613 
614 /**
615  * @dev Implementation of the {IERC20} interface.
616  *
617  * This implementation is agnostic to the way tokens are created. This means
618  * that a supply mechanism has to be added in a derived contract using {_mint}.
619  * For a generic mechanism see {ERC20PresetMinterPauser}.
620  *
621  * TIP: For a detailed writeup see our guide
622  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
623  * to implement supply mechanisms].
624  *
625  * We have followed general OpenZeppelin Contracts guidelines: functions revert
626  * instead returning `false` on failure. This behavior is nonetheless
627  * conventional and does not conflict with the expectations of ERC20
628  * applications.
629  *
630  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
631  * This allows applications to reconstruct the allowance for all accounts just
632  * by listening to said events. Other implementations of the EIP may not emit
633  * these events, as it isn't required by the specification.
634  *
635  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
636  * functions have been added to mitigate the well-known issues around setting
637  * allowances. See {IERC20-approve}.
638  */
639 contract ERC20 is Context, IERC20, IERC20Metadata {
640     mapping(address => uint256) private _balances;
641 
642     mapping(address => mapping(address => uint256)) private _allowances;
643 
644     uint256 private _totalSupply;
645 
646     string private _name;
647     string private _symbol;
648 
649     /**
650      * @dev Sets the values for {name} and {symbol}.
651      *
652      * The default value of {decimals} is 18. To select a different value for
653      * {decimals} you should overload it.
654      *
655      * All two of these values are immutable: they can only be set once during
656      * construction.
657      */
658     constructor(string memory name_, string memory symbol_) {
659         _name = name_;
660         _symbol = symbol_;
661     }
662 
663     /**
664      * @dev Returns the name of the token.
665      */
666     function name() public view virtual override returns (string memory) {
667         return _name;
668     }
669 
670     /**
671      * @dev Returns the symbol of the token, usually a shorter version of the
672      * name.
673      */
674     function symbol() public view virtual override returns (string memory) {
675         return _symbol;
676     }
677 
678     /**
679      * @dev Returns the number of decimals used to get its user representation.
680      * For example, if `decimals` equals `2`, a balance of `505` tokens should
681      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
682      *
683      * Tokens usually opt for a value of 18, imitating the relationship between
684      * Ether and Wei. This is the value {ERC20} uses, unless this function is
685      * overridden;
686      *
687      * NOTE: This information is only used for _display_ purposes: it in
688      * no way affects any of the arithmetic of the contract, including
689      * {IERC20-balanceOf} and {IERC20-transfer}.
690      */
691     function decimals() public view virtual override returns (uint8) {
692         return 18;
693     }
694 
695     /**
696      * @dev See {IERC20-totalSupply}.
697      */
698     function totalSupply() public view virtual override returns (uint256) {
699         return _totalSupply;
700     }
701 
702     /**
703      * @dev See {IERC20-balanceOf}.
704      */
705     function balanceOf(address account) public view virtual override returns (uint256) {
706         return _balances[account];
707     }
708 
709     /**
710      * @dev See {IERC20-transfer}.
711      *
712      * Requirements:
713      *
714      * - `to` cannot be the zero address.
715      * - the caller must have a balance of at least `amount`.
716      */
717     function transfer(address to, uint256 amount) public virtual override returns (bool) {
718         address owner = _msgSender();
719         _transfer(owner, to, amount);
720         return true;
721     }
722 
723     /**
724      * @dev See {IERC20-allowance}.
725      */
726     function allowance(address owner, address spender) public view virtual override returns (uint256) {
727         return _allowances[owner][spender];
728     }
729 
730     /**
731      * @dev See {IERC20-approve}.
732      *
733      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
734      * `transferFrom`. This is semantically equivalent to an infinite approval.
735      *
736      * Requirements:
737      *
738      * - `spender` cannot be the zero address.
739      */
740     function approve(address spender, uint256 amount) public virtual override returns (bool) {
741         address owner = _msgSender();
742         _approve(owner, spender, amount);
743         return true;
744     }
745 
746     /**
747      * @dev See {IERC20-transferFrom}.
748      *
749      * Emits an {Approval} event indicating the updated allowance. This is not
750      * required by the EIP. See the note at the beginning of {ERC20}.
751      *
752      * NOTE: Does not update the allowance if the current allowance
753      * is the maximum `uint256`.
754      *
755      * Requirements:
756      *
757      * - `from` and `to` cannot be the zero address.
758      * - `from` must have a balance of at least `amount`.
759      * - the caller must have allowance for ``from``'s tokens of at least
760      * `amount`.
761      */
762     function transferFrom(
763         address from,
764         address to,
765         uint256 amount
766     ) public virtual override returns (bool) {
767         address spender = _msgSender();
768         _spendAllowance(from, spender, amount);
769         _transfer(from, to, amount);
770         return true;
771     }
772 
773     /**
774      * @dev Atomically increases the allowance granted to `spender` by the caller.
775      *
776      * This is an alternative to {approve} that can be used as a mitigation for
777      * problems described in {IERC20-approve}.
778      *
779      * Emits an {Approval} event indicating the updated allowance.
780      *
781      * Requirements:
782      *
783      * - `spender` cannot be the zero address.
784      */
785     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
786         address owner = _msgSender();
787         _approve(owner, spender, _allowances[owner][spender] + addedValue);
788         return true;
789     }
790 
791     /**
792      * @dev Atomically decreases the allowance granted to `spender` by the caller.
793      *
794      * This is an alternative to {approve} that can be used as a mitigation for
795      * problems described in {IERC20-approve}.
796      *
797      * Emits an {Approval} event indicating the updated allowance.
798      *
799      * Requirements:
800      *
801      * - `spender` cannot be the zero address.
802      * - `spender` must have allowance for the caller of at least
803      * `subtractedValue`.
804      */
805     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
806         address owner = _msgSender();
807         uint256 currentAllowance = _allowances[owner][spender];
808         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
809         unchecked {
810             _approve(owner, spender, currentAllowance - subtractedValue);
811         }
812 
813         return true;
814     }
815 
816     /**
817      * @dev Moves `amount` of tokens from `sender` to `recipient`.
818      *
819      * This internal function is equivalent to {transfer}, and can be used to
820      * e.g. implement automatic token fees, slashing mechanisms, etc.
821      *
822      * Emits a {Transfer} event.
823      *
824      * Requirements:
825      *
826      * - `from` cannot be the zero address.
827      * - `to` cannot be the zero address.
828      * - `from` must have a balance of at least `amount`.
829      */
830     function _transfer(
831         address from,
832         address to,
833         uint256 amount
834     ) internal virtual {
835         require(from != address(0), "ERC20: transfer from the zero address");
836         require(to != address(0), "ERC20: transfer to the zero address");
837 
838         _beforeTokenTransfer(from, to, amount);
839 
840         uint256 fromBalance = _balances[from];
841         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
842         unchecked {
843             _balances[from] = fromBalance - amount;
844         }
845         _balances[to] += amount;
846 
847         emit Transfer(from, to, amount);
848 
849         _afterTokenTransfer(from, to, amount);
850     }
851 
852     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
853      * the total supply.
854      *
855      * Emits a {Transfer} event with `from` set to the zero address.
856      *
857      * Requirements:
858      *
859      * - `account` cannot be the zero address.
860      */
861     function _mint(address account, uint256 amount) internal virtual {
862         require(account != address(0), "ERC20: mint to the zero address");
863 
864         _beforeTokenTransfer(address(0), account, amount);
865 
866         _totalSupply += amount;
867         _balances[account] += amount;
868         emit Transfer(address(0), account, amount);
869 
870         _afterTokenTransfer(address(0), account, amount);
871     }
872 
873     /**
874      * @dev Destroys `amount` tokens from `account`, reducing the
875      * total supply.
876      *
877      * Emits a {Transfer} event with `to` set to the zero address.
878      *
879      * Requirements:
880      *
881      * - `account` cannot be the zero address.
882      * - `account` must have at least `amount` tokens.
883      */
884     function _burn(address account, uint256 amount) internal virtual {
885         require(account != address(0), "ERC20: burn from the zero address");
886 
887         _beforeTokenTransfer(account, address(0), amount);
888 
889         uint256 accountBalance = _balances[account];
890         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
891         unchecked {
892             _balances[account] = accountBalance - amount;
893         }
894         _totalSupply -= amount;
895 
896         emit Transfer(account, address(0), amount);
897 
898         _afterTokenTransfer(account, address(0), amount);
899     }
900 
901     /**
902      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
903      *
904      * This internal function is equivalent to `approve`, and can be used to
905      * e.g. set automatic allowances for certain subsystems, etc.
906      *
907      * Emits an {Approval} event.
908      *
909      * Requirements:
910      *
911      * - `owner` cannot be the zero address.
912      * - `spender` cannot be the zero address.
913      */
914     function _approve(
915         address owner,
916         address spender,
917         uint256 amount
918     ) internal virtual {
919         require(owner != address(0), "ERC20: approve from the zero address");
920         require(spender != address(0), "ERC20: approve to the zero address");
921 
922         _allowances[owner][spender] = amount;
923         emit Approval(owner, spender, amount);
924     }
925 
926     /**
927      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
928      *
929      * Does not update the allowance amount in case of infinite allowance.
930      * Revert if not enough allowance is available.
931      *
932      * Might emit an {Approval} event.
933      */
934     function _spendAllowance(
935         address owner,
936         address spender,
937         uint256 amount
938     ) internal virtual {
939         uint256 currentAllowance = allowance(owner, spender);
940         if (currentAllowance != type(uint256).max) {
941             require(currentAllowance >= amount, "ERC20: insufficient allowance");
942             unchecked {
943                 _approve(owner, spender, currentAllowance - amount);
944             }
945         }
946     }
947 
948     /**
949      * @dev Hook that is called before any transfer of tokens. This includes
950      * minting and burning.
951      *
952      * Calling conditions:
953      *
954      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
955      * will be transferred to `to`.
956      * - when `from` is zero, `amount` tokens will be minted for `to`.
957      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
958      * - `from` and `to` are never both zero.
959      *
960      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
961      */
962     function _beforeTokenTransfer(
963         address from,
964         address to,
965         uint256 amount
966     ) internal virtual {}
967 
968     /**
969      * @dev Hook that is called after any transfer of tokens. This includes
970      * minting and burning.
971      *
972      * Calling conditions:
973      *
974      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
975      * has been transferred to `to`.
976      * - when `from` is zero, `amount` tokens have been minted for `to`.
977      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
978      * - `from` and `to` are never both zero.
979      *
980      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
981      */
982     function _afterTokenTransfer(
983         address from,
984         address to,
985         uint256 amount
986     ) internal virtual {}
987 }
988 
989 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Pausable.sol
990 
991 
992 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/ERC20Pausable.sol)
993 
994 pragma solidity ^0.8.7;
995 
996 
997 
998 /**
999  * @dev ERC20 token with pausable token transfers, minting and burning.
1000  *
1001  * Useful for scenarios such as preventing trades until the end of an evaluation
1002  * period, or having an emergency switch for freezing all token transfers in the
1003  * event of a large bug.
1004  */
1005 abstract contract ERC20Pausable is ERC20, Pausable {
1006     /**
1007      * @dev See {ERC20-_beforeTokenTransfer}.
1008      *
1009      * Requirements:
1010      *
1011      * - the contract must not be paused.
1012      */
1013     function _beforeTokenTransfer(
1014         address from,
1015         address to,
1016         uint256 amount
1017     ) internal virtual override {
1018         super._beforeTokenTransfer(from, to, amount);
1019 
1020         require(!paused(), "ERC20Pausable: token transfer while paused");
1021     }
1022 }
1023 
1024 // File: @openzeppelin/contracts/access/Ownable.sol
1025 
1026 
1027 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1028 
1029 pragma solidity ^0.8.7;
1030 
1031 
1032 /**
1033  * @dev Contract module which provides a basic access control mechanism, where
1034  * there is an account (an owner) that can be granted exclusive access to
1035  * specific functions.
1036  *
1037  * By default, the owner account will be the one that deploys the contract. This
1038  * can later be changed with {transferOwnership}.
1039  *
1040  * This module is used through inheritance. It will make available the modifier
1041  * `onlyOwner`, which can be applied to your functions to restrict their use to
1042  * the owner.
1043  */
1044 abstract contract Ownable is Context {
1045     address private _owner;
1046 
1047     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1048 
1049     /**
1050      * @dev Initializes the contract setting the deployer as the initial owner.
1051      */
1052     constructor() {
1053         _transferOwnership(_msgSender());
1054     }
1055 
1056     /**
1057      * @dev Returns the address of the current owner.
1058      */
1059     function owner() public view virtual returns (address) {
1060         return _owner;
1061     }
1062 
1063     /**
1064      * @dev Throws if called by any account other than the owner.
1065      */
1066     modifier onlyOwner() {
1067         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1068         _;
1069     }
1070 
1071     /**
1072      * @dev Leaves the contract without owner. It will not be possible to call
1073      * `onlyOwner` functions anymore. Can only be called by the current owner.
1074      *
1075      * NOTE: Renouncing ownership will leave the contract without an owner,
1076      * thereby removing any functionality that is only available to the owner.
1077      */
1078     function renounceOwnership() public virtual onlyOwner {
1079         _transferOwnership(address(0));
1080     }
1081 
1082     /**
1083      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1084      * Can only be called by the current owner.
1085      */
1086     function transferOwnership(address newOwner) public virtual onlyOwner {
1087         require(newOwner != address(0), "Ownable: new owner is the zero address");
1088         _transferOwnership(newOwner);
1089     }
1090 
1091     /**
1092      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1093      * Internal function without access restriction.
1094      */
1095     function _transferOwnership(address newOwner) internal virtual {
1096         address oldOwner = _owner;
1097         _owner = newOwner;
1098         emit OwnershipTransferred(oldOwner, newOwner);
1099     }
1100 }
1101 
1102 // File: @openzeppelin/contracts/utils/Address.sol
1103 
1104 
1105 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1106 
1107 pragma solidity ^0.8.7;
1108 
1109 /**
1110  * @dev Collection of functions related to the address type
1111  */
1112 library Address {
1113     /**
1114      * @dev Returns true if `account` is a contract.
1115      *
1116      * [IMPORTANT]
1117      * ====
1118      * It is unsafe to assume that an address for which this function returns
1119      * false is an externally-owned account (EOA) and not a contract.
1120      *
1121      * Among others, `isContract` will return false for the following
1122      * types of addresses:
1123      *
1124      *  - an externally-owned account
1125      *  - a contract in construction
1126      *  - an address where a contract will be created
1127      *  - an address where a contract lived, but was destroyed
1128      * ====
1129      *
1130      * [IMPORTANT]
1131      * ====
1132      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1133      *
1134      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1135      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1136      * constructor.
1137      * ====
1138      */
1139     function isContract(address account) internal view returns (bool) {
1140         // This method relies on extcodesize/address.code.length, which returns 0
1141         // for contracts in construction, since the code is only stored at the end
1142         // of the constructor execution.
1143 
1144         return account.code.length > 0;
1145     }
1146 
1147     /**
1148      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1149      * `recipient`, forwarding all available gas and reverting on errors.
1150      *
1151      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1152      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1153      * imposed by `transfer`, making them unable to receive funds via
1154      * `transfer`. {sendValue} removes this limitation.
1155      *
1156      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1157      *
1158      * IMPORTANT: because control is transferred to `recipient`, care must be
1159      * taken to not create reentrancy vulnerabilities. Consider using
1160      * {ReentrancyGuard} or the
1161      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1162      */
1163     function sendValue(address payable recipient, uint256 amount) internal {
1164         require(address(this).balance >= amount, "Address: insufficient balance");
1165 
1166         (bool success, ) = recipient.call{value: amount}("");
1167         require(success, "Address: unable to send value, recipient may have reverted");
1168     }
1169 
1170     /**
1171      * @dev Performs a Solidity function call using a low level `call`. A
1172      * plain `call` is an unsafe replacement for a function call: use this
1173      * function instead.
1174      *
1175      * If `target` reverts with a revert reason, it is bubbled up by this
1176      * function (like regular Solidity function calls).
1177      *
1178      * Returns the raw returned data. To convert to the expected return value,
1179      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1180      *
1181      * Requirements:
1182      *
1183      * - `target` must be a contract.
1184      * - calling `target` with `data` must not revert.
1185      *
1186      * _Available since v3.1._
1187      */
1188     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1189         return functionCall(target, data, "Address: low-level call failed");
1190     }
1191 
1192     /**
1193      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1194      * `errorMessage` as a fallback revert reason when `target` reverts.
1195      *
1196      * _Available since v3.1._
1197      */
1198     function functionCall(
1199         address target,
1200         bytes memory data,
1201         string memory errorMessage
1202     ) internal returns (bytes memory) {
1203         return functionCallWithValue(target, data, 0, errorMessage);
1204     }
1205 
1206     /**
1207      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1208      * but also transferring `value` wei to `target`.
1209      *
1210      * Requirements:
1211      *
1212      * - the calling contract must have an ETH balance of at least `value`.
1213      * - the called Solidity function must be `payable`.
1214      *
1215      * _Available since v3.1._
1216      */
1217     function functionCallWithValue(
1218         address target,
1219         bytes memory data,
1220         uint256 value
1221     ) internal returns (bytes memory) {
1222         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1223     }
1224 
1225     /**
1226      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1227      * with `errorMessage` as a fallback revert reason when `target` reverts.
1228      *
1229      * _Available since v3.1._
1230      */
1231     function functionCallWithValue(
1232         address target,
1233         bytes memory data,
1234         uint256 value,
1235         string memory errorMessage
1236     ) internal returns (bytes memory) {
1237         require(address(this).balance >= value, "Address: insufficient balance for call");
1238         require(isContract(target), "Address: call to non-contract");
1239 
1240         (bool success, bytes memory returndata) = target.call{value: value}(data);
1241         return verifyCallResult(success, returndata, errorMessage);
1242     }
1243 
1244     /**
1245      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1246      * but performing a static call.
1247      *
1248      * _Available since v3.3._
1249      */
1250     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1251         return functionStaticCall(target, data, "Address: low-level static call failed");
1252     }
1253 
1254     /**
1255      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1256      * but performing a static call.
1257      *
1258      * _Available since v3.3._
1259      */
1260     function functionStaticCall(
1261         address target,
1262         bytes memory data,
1263         string memory errorMessage
1264     ) internal view returns (bytes memory) {
1265         require(isContract(target), "Address: static call to non-contract");
1266 
1267         (bool success, bytes memory returndata) = target.staticcall(data);
1268         return verifyCallResult(success, returndata, errorMessage);
1269     }
1270 
1271     /**
1272      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1273      * but performing a delegate call.
1274      *
1275      * _Available since v3.4._
1276      */
1277     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1278         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1279     }
1280 
1281     /**
1282      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1283      * but performing a delegate call.
1284      *
1285      * _Available since v3.4._
1286      */
1287     function functionDelegateCall(
1288         address target,
1289         bytes memory data,
1290         string memory errorMessage
1291     ) internal returns (bytes memory) {
1292         require(isContract(target), "Address: delegate call to non-contract");
1293 
1294         (bool success, bytes memory returndata) = target.delegatecall(data);
1295         return verifyCallResult(success, returndata, errorMessage);
1296     }
1297 
1298     /**
1299      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1300      * revert reason using the provided one.
1301      *
1302      * _Available since v4.3._
1303      */
1304     function verifyCallResult(
1305         bool success,
1306         bytes memory returndata,
1307         string memory errorMessage
1308     ) internal pure returns (bytes memory) {
1309         if (success) {
1310             return returndata;
1311         } else {
1312             // Look for revert reason and bubble it up if present
1313             if (returndata.length > 0) {
1314                 // The easiest way to bubble the revert reason is using memory via assembly
1315 
1316                 assembly {
1317                     let returndata_size := mload(returndata)
1318                     revert(add(32, returndata), returndata_size)
1319                 }
1320             } else {
1321                 revert(errorMessage);
1322             }
1323         }
1324     }
1325 }
1326 
1327 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1328 
1329 
1330 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
1331 
1332 pragma solidity ^0.8.7;
1333 
1334 /**
1335  * @title ERC721 token receiver interface
1336  * @dev Interface for any contract that wants to support safeTransfers
1337  * from ERC721 asset contracts.
1338  */
1339 interface IERC721Receiver {
1340     /**
1341      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1342      * by `operator` from `from`, this function is called.
1343      *
1344      * It must return its Solidity selector to confirm the token transfer.
1345      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1346      *
1347      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1348      */
1349     function onERC721Received(
1350         address operator,
1351         address from,
1352         uint256 tokenId,
1353         bytes calldata data
1354     ) external returns (bytes4);
1355 }
1356 
1357 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1358 
1359 
1360 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1361 
1362 pragma solidity ^0.8.7;
1363 
1364 /**
1365  * @dev Interface of the ERC165 standard, as defined in the
1366  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1367  *
1368  * Implementers can declare support of contract interfaces, which can then be
1369  * queried by others ({ERC165Checker}).
1370  *
1371  * For an implementation, see {ERC165}.
1372  */
1373 interface IERC165 {
1374     /**
1375      * @dev Returns true if this contract implements the interface defined by
1376      * `interfaceId`. See the corresponding
1377      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1378      * to learn more about how these ids are created.
1379      *
1380      * This function call must use less than 30 000 gas.
1381      */
1382     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1383 }
1384 
1385 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1386 
1387 
1388 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1389 
1390 pragma solidity ^0.8.7;
1391 
1392 
1393 /**
1394  * @dev Implementation of the {IERC165} interface.
1395  *
1396  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1397  * for the additional interface id that will be supported. For example:
1398  *
1399  * ```solidity
1400  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1401  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1402  * }
1403  * ```
1404  *
1405  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1406  */
1407 abstract contract ERC165 is IERC165 {
1408     /**
1409      * @dev See {IERC165-supportsInterface}.
1410      */
1411     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1412         return interfaceId == type(IERC165).interfaceId;
1413     }
1414 }
1415 
1416 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1417 
1418 
1419 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
1420 
1421 pragma solidity ^0.8.7;
1422 
1423 
1424 /**
1425  * @dev Required interface of an ERC721 compliant contract.
1426  */
1427 interface IERC721 is IERC165 {
1428     /**
1429      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1430      */
1431     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1432 
1433     /**
1434      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1435      */
1436     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1437 
1438     /**
1439      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1440      */
1441     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1442 
1443     /**
1444      * @dev Returns the number of tokens in ``owner``'s account.
1445      */
1446     function balanceOf(address owner) external view returns (uint256 balance);
1447 
1448     /**
1449      * @dev Returns the owner of the `tokenId` token.
1450      *
1451      * Requirements:
1452      *
1453      * - `tokenId` must exist.
1454      */
1455     function ownerOf(uint256 tokenId) external view returns (address owner);
1456 
1457     /**
1458      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1459      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1460      *
1461      * Requirements:
1462      *
1463      * - `from` cannot be the zero address.
1464      * - `to` cannot be the zero address.
1465      * - `tokenId` token must exist and be owned by `from`.
1466      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1467      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1468      *
1469      * Emits a {Transfer} event.
1470      */
1471     function safeTransferFrom(
1472         address from,
1473         address to,
1474         uint256 tokenId
1475     ) external;
1476 
1477     /**
1478      * @dev Transfers `tokenId` token from `from` to `to`.
1479      *
1480      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1481      *
1482      * Requirements:
1483      *
1484      * - `from` cannot be the zero address.
1485      * - `to` cannot be the zero address.
1486      * - `tokenId` token must be owned by `from`.
1487      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1488      *
1489      * Emits a {Transfer} event.
1490      */
1491     function transferFrom(
1492         address from,
1493         address to,
1494         uint256 tokenId
1495     ) external;
1496 
1497     /**
1498      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1499      * The approval is cleared when the token is transferred.
1500      *
1501      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1502      *
1503      * Requirements:
1504      *
1505      * - The caller must own the token or be an approved operator.
1506      * - `tokenId` must exist.
1507      *
1508      * Emits an {Approval} event.
1509      */
1510     function approve(address to, uint256 tokenId) external;
1511 
1512     /**
1513      * @dev Returns the account approved for `tokenId` token.
1514      *
1515      * Requirements:
1516      *
1517      * - `tokenId` must exist.
1518      */
1519     function getApproved(uint256 tokenId) external view returns (address operator);
1520 
1521     /**
1522      * @dev Approve or remove `operator` as an operator for the caller.
1523      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1524      *
1525      * Requirements:
1526      *
1527      * - The `operator` cannot be the caller.
1528      *
1529      * Emits an {ApprovalForAll} event.
1530      */
1531     function setApprovalForAll(address operator, bool _approved) external;
1532 
1533     /**
1534      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1535      *
1536      * See {setApprovalForAll}
1537      */
1538     function isApprovedForAll(address owner, address operator) external view returns (bool);
1539 
1540     /**
1541      * @dev Safely transfers `tokenId` token from `from` to `to`.
1542      *
1543      * Requirements:
1544      *
1545      * - `from` cannot be the zero address.
1546      * - `to` cannot be the zero address.
1547      * - `tokenId` token must exist and be owned by `from`.
1548      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1549      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1550      *
1551      * Emits a {Transfer} event.
1552      */
1553     function safeTransferFrom(
1554         address from,
1555         address to,
1556         uint256 tokenId,
1557         bytes calldata data
1558     ) external;
1559 }
1560 
1561 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1562 
1563 
1564 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1565 
1566 pragma solidity ^0.8.7;
1567 
1568 
1569 /**
1570  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1571  * @dev See https://eips.ethereum.org/EIPS/eip-721
1572  */
1573 interface IERC721Enumerable is IERC721 {
1574     /**
1575      * @dev Returns the total amount of tokens stored by the contract.
1576      */
1577     function totalSupply() external view returns (uint256);
1578 
1579     /**
1580      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1581      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1582      */
1583     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1584 
1585     /**
1586      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1587      * Use along with {totalSupply} to enumerate all tokens.
1588      */
1589     function tokenByIndex(uint256 index) external view returns (uint256);
1590 }
1591 
1592 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1593 
1594 
1595 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1596 
1597 pragma solidity ^0.8.7;
1598 
1599 
1600 /**
1601  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1602  * @dev See https://eips.ethereum.org/EIPS/eip-721
1603  */
1604 interface IERC721Metadata is IERC721 {
1605     /**
1606      * @dev Returns the token collection name.
1607      */
1608     function name() external view returns (string memory);
1609 
1610     /**
1611      * @dev Returns the token collection symbol.
1612      */
1613     function symbol() external view returns (string memory);
1614 
1615     /**
1616      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1617      */
1618     function tokenURI(uint256 tokenId) external view returns (string memory);
1619 }
1620 
1621 // File: ERC721A.sol
1622 
1623 
1624 // Creator: Chiru Labs
1625 
1626 pragma solidity ^0.8.7;
1627 
1628 error ApprovalCallerNotOwnerNorApproved();
1629 error ApprovalQueryForNonexistentToken();
1630 error ApproveToCaller();
1631 error ApprovalToCurrentOwner();
1632 error BalanceQueryForZeroAddress();
1633 error MintedQueryForZeroAddress();
1634 error BurnedQueryForZeroAddress();
1635 error AuxQueryForZeroAddress();
1636 error MintToZeroAddress();
1637 error MintZeroQuantity();
1638 error OwnerIndexOutOfBounds();
1639 error OwnerQueryForNonexistentToken();
1640 error TokenIndexOutOfBounds();
1641 error TransferCallerNotOwnerNorApproved();
1642 error TransferFromIncorrectOwner();
1643 error TransferToNonERC721ReceiverImplementer();
1644 error TransferToZeroAddress();
1645 error URIQueryForNonexistentToken();
1646 
1647 /**
1648  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1649  * the Metadata extension. Built to optimize for lower gas during batch mints.
1650  *
1651  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1652  *
1653  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1654  *
1655  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1656  */
1657 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1658     using Address for address;
1659     using Strings for uint256;
1660 
1661     // Compiler will pack this into a single 256bit word.
1662     struct TokenOwnership {
1663         // The address of the owner.
1664         address addr;
1665         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1666         uint64 startTimestamp;
1667         // Whether the token has been burned.
1668         bool burned;
1669     }
1670 
1671     // Compiler will pack this into a single 256bit word.
1672     struct AddressData {
1673         // Realistically, 2**64-1 is more than enough.
1674         uint64 balance;
1675         // Keeps track of mint count with minimal overhead for tokenomics.
1676         uint64 numberMinted;
1677         // Keeps track of burn count with minimal overhead for tokenomics.
1678         uint64 numberBurned;
1679         // For miscellaneous variable(s) pertaining to the address
1680         // (e.g. number of whitelist mint slots used).
1681         // If there are multiple variables, please pack them into a uint64.
1682         uint64 aux;
1683     }
1684 
1685     // The tokenId of the next token to be minted.
1686     uint256 internal _currentIndex;
1687 
1688     // The number of tokens burned.
1689     uint256 internal _burnCounter;
1690 
1691     // Token name
1692     string private _name;
1693 
1694     // Token symbol
1695     string private _symbol;
1696 
1697     // Mapping from token ID to ownership details
1698     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1699     mapping(uint256 => TokenOwnership) internal _ownerships;
1700 
1701     // Mapping owner address to address data
1702     mapping(address => AddressData) private _addressData;
1703 
1704     // Mapping from token ID to approved address
1705     mapping(uint256 => address) private _tokenApprovals;
1706 
1707     // Mapping from owner to operator approvals
1708     mapping(address => mapping(address => bool)) private _operatorApprovals;
1709 
1710     constructor(string memory name_, string memory symbol_) {
1711         _name = name_;
1712         _symbol = symbol_;
1713         _currentIndex = _startTokenId();
1714     }
1715 
1716     /**
1717      * To change the starting tokenId, please override this function.
1718      */
1719     function _startTokenId() internal view virtual returns (uint256) {
1720         return 0;
1721     }
1722 
1723     /**
1724      * @dev See {IERC721Enumerable-totalSupply}.
1725      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1726      */
1727     function totalSupply() public view returns (uint256) {
1728         // Counter underflow is impossible as _burnCounter cannot be incremented
1729         // more than _currentIndex - _startTokenId() times
1730         unchecked {
1731             return _currentIndex - _burnCounter - _startTokenId();
1732         }
1733     }
1734 
1735     /**
1736      * Returns the total amount of tokens minted in the contract.
1737      */
1738     function _totalMinted() internal view returns (uint256) {
1739         // Counter underflow is impossible as _currentIndex does not decrement,
1740         // and it is initialized to _startTokenId()
1741         unchecked {
1742             return _currentIndex - _startTokenId();
1743         }
1744     }
1745 
1746     /**
1747      * @dev See {IERC165-supportsInterface}.
1748      */
1749     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1750         return
1751             interfaceId == type(IERC721).interfaceId ||
1752             interfaceId == type(IERC721Metadata).interfaceId ||
1753             super.supportsInterface(interfaceId);
1754     }
1755 
1756     /**
1757      * @dev See {IERC721-balanceOf}.
1758      */
1759     function balanceOf(address owner) public view override returns (uint256) {
1760         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1761         return uint256(_addressData[owner].balance);
1762     }
1763 
1764     /**
1765      * Returns the number of tokens minted by `owner`.
1766      */
1767     function _numberMinted(address owner) internal view returns (uint256) {
1768         if (owner == address(0)) revert MintedQueryForZeroAddress();
1769         return uint256(_addressData[owner].numberMinted);
1770     }
1771 
1772     /**
1773      * Returns the number of tokens burned by or on behalf of `owner`.
1774      */
1775     function _numberBurned(address owner) internal view returns (uint256) {
1776         if (owner == address(0)) revert BurnedQueryForZeroAddress();
1777         return uint256(_addressData[owner].numberBurned);
1778     }
1779 
1780     /**
1781      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1782      */
1783     function _getAux(address owner) internal view returns (uint64) {
1784         if (owner == address(0)) revert AuxQueryForZeroAddress();
1785         return _addressData[owner].aux;
1786     }
1787 
1788     /**
1789      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1790      * If there are multiple variables, please pack them into a uint64.
1791      */
1792     function _setAux(address owner, uint64 aux) internal {
1793         if (owner == address(0)) revert AuxQueryForZeroAddress();
1794         _addressData[owner].aux = aux;
1795     }
1796 
1797     /**
1798      * Gas spent here starts off proportional to the maximum mint batch size.
1799      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1800      */
1801     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1802         uint256 curr = tokenId;
1803 
1804         unchecked {
1805             if (_startTokenId() <= curr && curr < _currentIndex) {
1806                 TokenOwnership memory ownership = _ownerships[curr];
1807                 if (!ownership.burned) {
1808                     if (ownership.addr != address(0)) {
1809                         return ownership;
1810                     }
1811                     // Invariant:
1812                     // There will always be an ownership that has an address and is not burned
1813                     // before an ownership that does not have an address and is not burned.
1814                     // Hence, curr will not underflow.
1815                     while (true) {
1816                         curr--;
1817                         ownership = _ownerships[curr];
1818                         if (ownership.addr != address(0)) {
1819                             return ownership;
1820                         }
1821                     }
1822                 }
1823             }
1824         }
1825         revert OwnerQueryForNonexistentToken();
1826     }
1827 
1828     /**
1829      * @dev See {IERC721-ownerOf}.
1830      */
1831     function ownerOf(uint256 tokenId) public view override returns (address) {
1832         return ownershipOf(tokenId).addr;
1833     }
1834 
1835     /**
1836      * @dev See {IERC721Metadata-name}.
1837      */
1838     function name() public view virtual override returns (string memory) {
1839         return _name;
1840     }
1841 
1842     /**
1843      * @dev See {IERC721Metadata-symbol}.
1844      */
1845     function symbol() public view virtual override returns (string memory) {
1846         return _symbol;
1847     }
1848 
1849     /**
1850      * @dev See {IERC721Metadata-tokenURI}.
1851      */
1852     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1853         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1854 
1855         string memory baseURI = _baseURI();
1856         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1857     }
1858 
1859     /**
1860      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1861      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1862      * by default, can be overriden in child contracts.
1863      */
1864     function _baseURI() internal view virtual returns (string memory) {
1865         return '';
1866     }
1867 
1868     /**
1869      * @dev See {IERC721-approve}.
1870      */
1871     function approve(address to, uint256 tokenId) public override {
1872         address owner = ERC721A.ownerOf(tokenId);
1873         if (to == owner) revert ApprovalToCurrentOwner();
1874 
1875         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1876             revert ApprovalCallerNotOwnerNorApproved();
1877         }
1878 
1879         _approve(to, tokenId, owner);
1880     }
1881 
1882     /**
1883      * @dev See {IERC721-getApproved}.
1884      */
1885     function getApproved(uint256 tokenId) public view override returns (address) {
1886         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1887 
1888         return _tokenApprovals[tokenId];
1889     }
1890 
1891     /**
1892      * @dev See {IERC721-setApprovalForAll}.
1893      */
1894     function setApprovalForAll(address operator, bool approved) public override {
1895         if (operator == _msgSender()) revert ApproveToCaller();
1896 
1897         _operatorApprovals[_msgSender()][operator] = approved;
1898         emit ApprovalForAll(_msgSender(), operator, approved);
1899     }
1900 
1901     /**
1902      * @dev See {IERC721-isApprovedForAll}.
1903      */
1904     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1905         return _operatorApprovals[owner][operator];
1906     }
1907 
1908     /**
1909      * @dev See {IERC721-transferFrom}.
1910      */
1911     function transferFrom(
1912         address from,
1913         address to,
1914         uint256 tokenId
1915     ) public virtual override {
1916         _transfer(from, to, tokenId);
1917     }
1918 
1919     /**
1920      * @dev See {IERC721-safeTransferFrom}.
1921      */
1922     function safeTransferFrom(
1923         address from,
1924         address to,
1925         uint256 tokenId
1926     ) public virtual override {
1927         safeTransferFrom(from, to, tokenId, '');
1928     }
1929 
1930     /**
1931      * @dev See {IERC721-safeTransferFrom}.
1932      */
1933     function safeTransferFrom(
1934         address from,
1935         address to,
1936         uint256 tokenId,
1937         bytes memory _data
1938     ) public virtual override {
1939         _transfer(from, to, tokenId);
1940         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1941             revert TransferToNonERC721ReceiverImplementer();
1942         }
1943     }
1944 
1945     /**
1946      * @dev Returns whether `tokenId` exists.
1947      *
1948      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1949      *
1950      * Tokens start existing when they are minted (`_mint`),
1951      */
1952     function _exists(uint256 tokenId) internal view returns (bool) {
1953         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1954             !_ownerships[tokenId].burned;
1955     }
1956 
1957     function _safeMint(address to, uint256 quantity) internal {
1958         _safeMint(to, quantity, '');
1959     }
1960 
1961     /**
1962      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1963      *
1964      * Requirements:
1965      *
1966      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1967      * - `quantity` must be greater than 0.
1968      *
1969      * Emits a {Transfer} event.
1970      */
1971     function _safeMint(
1972         address to,
1973         uint256 quantity,
1974         bytes memory _data
1975     ) internal {
1976         _mint(to, quantity, _data, true);
1977     }
1978 
1979     /**
1980      * @dev Mints `quantity` tokens and transfers them to `to`.
1981      *
1982      * Requirements:
1983      *
1984      * - `to` cannot be the zero address.
1985      * - `quantity` must be greater than 0.
1986      *
1987      * Emits a {Transfer} event.
1988      */
1989     function _mint(
1990         address to,
1991         uint256 quantity,
1992         bytes memory _data,
1993         bool safe
1994     ) internal {
1995         uint256 startTokenId = _currentIndex;
1996         if (to == address(0)) revert MintToZeroAddress();
1997         if (quantity == 0) revert MintZeroQuantity();
1998 
1999         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2000 
2001         // Overflows are incredibly unrealistic.
2002         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
2003         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
2004         unchecked {
2005             _addressData[to].balance += uint64(quantity);
2006             _addressData[to].numberMinted += uint64(quantity);
2007 
2008             _ownerships[startTokenId].addr = to;
2009             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
2010 
2011             uint256 updatedIndex = startTokenId;
2012             uint256 end = updatedIndex + quantity;
2013 
2014             if (safe && to.isContract()) {
2015                 do {
2016                     emit Transfer(address(0), to, updatedIndex);
2017                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
2018                         revert TransferToNonERC721ReceiverImplementer();
2019                     }
2020                 } while (updatedIndex != end);
2021                 // Reentrancy protection
2022                 if (_currentIndex != startTokenId) revert();
2023             } else {
2024                 do {
2025                     emit Transfer(address(0), to, updatedIndex++);
2026                 } while (updatedIndex != end);
2027             }
2028             _currentIndex = updatedIndex;
2029         }
2030         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2031     }
2032 
2033     /**
2034      * @dev Transfers `tokenId` from `from` to `to`.
2035      *
2036      * Requirements:
2037      *
2038      * - `to` cannot be the zero address.
2039      * - `tokenId` token must be owned by `from`.
2040      *
2041      * Emits a {Transfer} event.
2042      */
2043     function _transfer(
2044         address from,
2045         address to,
2046         uint256 tokenId
2047     ) private {
2048         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
2049 
2050         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
2051             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
2052             getApproved(tokenId) == _msgSender());
2053 
2054         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
2055         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
2056         if (to == address(0)) revert TransferToZeroAddress();
2057 
2058         _beforeTokenTransfers(from, to, tokenId, 1);
2059 
2060         // Clear approvals from the previous owner
2061         _approve(address(0), tokenId, prevOwnership.addr);
2062 
2063         // Underflow of the sender's balance is impossible because we check for
2064         // ownership above and the recipient's balance can't realistically overflow.
2065         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2066         unchecked {
2067             _addressData[from].balance -= 1;
2068             _addressData[to].balance += 1;
2069 
2070             _ownerships[tokenId].addr = to;
2071             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
2072 
2073             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
2074             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
2075             uint256 nextTokenId = tokenId + 1;
2076             if (_ownerships[nextTokenId].addr == address(0)) {
2077                 // This will suffice for checking _exists(nextTokenId),
2078                 // as a burned slot cannot contain the zero address.
2079                 if (nextTokenId < _currentIndex) {
2080                     _ownerships[nextTokenId].addr = prevOwnership.addr;
2081                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
2082                 }
2083             }
2084         }
2085 
2086         emit Transfer(from, to, tokenId);
2087         _afterTokenTransfers(from, to, tokenId, 1);
2088     }
2089 
2090     /**
2091      * @dev Destroys `tokenId`.
2092      * The approval is cleared when the token is burned.
2093      *
2094      * Requirements:
2095      *
2096      * - `tokenId` must exist.
2097      *
2098      * Emits a {Transfer} event.
2099      */
2100     function _burn(uint256 tokenId) internal virtual {
2101         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
2102 
2103         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
2104 
2105         // Clear approvals from the previous owner
2106         _approve(address(0), tokenId, prevOwnership.addr);
2107 
2108         // Underflow of the sender's balance is impossible because we check for
2109         // ownership above and the recipient's balance can't realistically overflow.
2110         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2111         unchecked {
2112             _addressData[prevOwnership.addr].balance -= 1;
2113             _addressData[prevOwnership.addr].numberBurned += 1;
2114 
2115             // Keep track of who burned the token, and the timestamp of burning.
2116             _ownerships[tokenId].addr = prevOwnership.addr;
2117             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
2118             _ownerships[tokenId].burned = true;
2119 
2120             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
2121             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
2122             uint256 nextTokenId = tokenId + 1;
2123             if (_ownerships[nextTokenId].addr == address(0)) {
2124                 // This will suffice for checking _exists(nextTokenId),
2125                 // as a burned slot cannot contain the zero address.
2126                 if (nextTokenId < _currentIndex) {
2127                     _ownerships[nextTokenId].addr = prevOwnership.addr;
2128                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
2129                 }
2130             }
2131         }
2132 
2133         emit Transfer(prevOwnership.addr, address(0), tokenId);
2134         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
2135 
2136         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2137         unchecked {
2138             _burnCounter++;
2139         }
2140     }
2141 
2142     /**
2143      * @dev Approve `to` to operate on `tokenId`
2144      *
2145      * Emits a {Approval} event.
2146      */
2147     function _approve(
2148         address to,
2149         uint256 tokenId,
2150         address owner
2151     ) private {
2152         _tokenApprovals[tokenId] = to;
2153         emit Approval(owner, to, tokenId);
2154     }
2155 
2156     /**
2157      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2158      *
2159      * @param from address representing the previous owner of the given token ID
2160      * @param to target address that will receive the tokens
2161      * @param tokenId uint256 ID of the token to be transferred
2162      * @param _data bytes optional data to send along with the call
2163      * @return bool whether the call correctly returned the expected magic value
2164      */
2165     function _checkContractOnERC721Received(
2166         address from,
2167         address to,
2168         uint256 tokenId,
2169         bytes memory _data
2170     ) private returns (bool) {
2171         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2172             return retval == IERC721Receiver(to).onERC721Received.selector;
2173         } catch (bytes memory reason) {
2174             if (reason.length == 0) {
2175                 revert TransferToNonERC721ReceiverImplementer();
2176             } else {
2177                 assembly {
2178                     revert(add(32, reason), mload(reason))
2179                 }
2180             }
2181         }
2182     }
2183 
2184     /**
2185      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
2186      * And also called before burning one token.
2187      *
2188      * startTokenId - the first token id to be transferred
2189      * quantity - the amount to be transferred
2190      *
2191      * Calling conditions:
2192      *
2193      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2194      * transferred to `to`.
2195      * - When `from` is zero, `tokenId` will be minted for `to`.
2196      * - When `to` is zero, `tokenId` will be burned by `from`.
2197      * - `from` and `to` are never both zero.
2198      */
2199     function _beforeTokenTransfers(
2200         address from,
2201         address to,
2202         uint256 startTokenId,
2203         uint256 quantity
2204     ) internal virtual {}
2205 
2206     /**
2207      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
2208      * minting.
2209      * And also called after one token has been burned.
2210      *
2211      * startTokenId - the first token id to be transferred
2212      * quantity - the amount to be transferred
2213      *
2214      * Calling conditions:
2215      *
2216      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2217      * transferred to `to`.
2218      * - When `from` is zero, `tokenId` has been minted for `to`.
2219      * - When `to` is zero, `tokenId` has been burned by `from`.
2220      * - `from` and `to` are never both zero.
2221      */
2222     function _afterTokenTransfers(
2223         address from,
2224         address to,
2225         uint256 startTokenId,
2226         uint256 quantity
2227     ) internal virtual {}
2228 }
2229 
2230 // File: zenlicious.sol
2231 pragma solidity ^0.8.7;
2232 
2233 contract Zenlicous is ERC721A, Ownable, ReentrancyGuard {
2234     using ECDSA for bytes32;
2235 
2236     enum Status {
2237         Paused,
2238         WhitelistSale,
2239         PublicSale,
2240         Finished
2241     }
2242 
2243     Status public status;
2244     string public baseURI;
2245     bool public burnLocked = true;
2246     
2247     uint256 public tokensReserved;
2248 
2249     uint256 public RESERVED_AMOUNT = 32;
2250     uint256 public MAX_SUPPLY = 888;
2251     uint256 public PRICE = 0.15 * 10**18; // 0.15 ETH
2252     address public signer = 0xa6d9E1682dca1080463CAEa9470d775ec208B6dC;
2253     address public marketingWallet = 0x55D0790Bc0Fb64d9fE4DC100986B0E7e9Ebce389;
2254 
2255     event Minted(address minter, uint256 amount);
2256     event StatusChanged(Status status);
2257     event SignerChanged(address signer);
2258     event ReservedToken(address minter, address recipient, uint256 amount);
2259     event BaseURIChanged(string newBaseURI);
2260 
2261     // Constructor
2262     // ------------------------------------------------------------------------
2263     constructor()
2264         ERC721A("Zenlicious", "Zenlicious")
2265     {}
2266 
2267     function _hash(uint256 maxAllowed, address _address)
2268         public
2269         view
2270         returns (bytes32)
2271     {
2272         return keccak256(abi.encode(Strings.toString(maxAllowed), address(this), _address));
2273     }
2274 
2275     function _verify(bytes32 hash, bytes memory signature)
2276         internal
2277         view
2278         returns (bool)
2279     {
2280         return (_recover(hash, signature) == signer);
2281     }
2282 
2283     function _recover(bytes32 hash, bytes memory signature)
2284         internal
2285         pure
2286         returns (address)
2287     {
2288         return hash.toEthSignedMessageHash().recover(signature);
2289     }
2290 
2291     function _baseURI() internal view override returns (string memory) {
2292         return baseURI;
2293     }
2294 
2295     function reserve(address recipient, uint256 amount) external onlyOwner {
2296         require(amount > 0, "Amount too low");
2297         require(
2298             totalSupply() + amount <= MAX_SUPPLY,
2299             "Max supply exceeded"
2300         );
2301         require(
2302             tokensReserved + amount <= RESERVED_AMOUNT,
2303             "Max reserve amount exceeded"
2304         );
2305 
2306         _safeMint(recipient, amount);
2307         tokensReserved += amount;
2308         emit ReservedToken(msg.sender, recipient, amount);
2309     }
2310 
2311     function whitelistMint(uint256 amount, uint256 maxAllowed, bytes calldata signature)
2312         external
2313         payable
2314     {
2315         require(status == Status.WhitelistSale, "WhitelistSale is not active.");
2316         require(
2317             _verify(_hash(maxAllowed, msg.sender), signature),
2318             "Invalid signature."
2319         );
2320         require(PRICE * amount == msg.value, "Price incorrect.");
2321         require(
2322             numberMinted(msg.sender) + amount <= maxAllowed,
2323             "Max mint amount per wallet exceeded."
2324         );
2325         require(
2326             totalSupply() + amount + RESERVED_AMOUNT - tokensReserved <=
2327                 MAX_SUPPLY,
2328             "Max supply exceeded."
2329         );
2330         require(tx.origin == msg.sender, "Contract is not allowed to mint.");
2331         
2332         _safeMint(msg.sender, amount);
2333         emit Minted(msg.sender, amount);
2334     }
2335 
2336 
2337     function mint() external payable {
2338         require(status == Status.PublicSale, "Public sale is not active.");
2339         require(tx.origin == msg.sender, "Contract is not allowed to mint.");
2340         require(
2341             totalSupply() + 1 + RESERVED_AMOUNT - tokensReserved <=
2342                 MAX_SUPPLY,
2343             "Max supply exceeded."
2344         );
2345         require(PRICE == msg.value, "Price incorrect.");
2346 
2347         _safeMint(msg.sender, 1);
2348         emit Minted(msg.sender, 1);
2349     }
2350 
2351     function _startTokenId() internal view override virtual returns (uint256) {
2352         return 1;
2353     }
2354 
2355     function withdraw() external nonReentrant onlyOwner {
2356         uint256 balance = address(this).balance;
2357         (bool success1, ) = payable(marketingWallet).call{value: balance}("");
2358         require(success1, "Transfer failed.");
2359     }
2360 
2361     function setPRICE(uint256 newPRICE) external onlyOwner {
2362         PRICE = newPRICE;
2363     }
2364 
2365     function setBaseURI(string calldata newBaseURI) external onlyOwner {
2366         baseURI = newBaseURI;
2367         emit BaseURIChanged(newBaseURI);
2368     }
2369 
2370     function setStatus(Status _status) external onlyOwner {
2371         status = _status;
2372         emit StatusChanged(_status);
2373     }
2374 
2375     function setBurnLocked(bool locked) external onlyOwner {
2376         burnLocked = locked;
2377     }
2378 
2379     function setSigner(address newSigner) external onlyOwner {
2380         signer = newSigner;
2381         emit SignerChanged(signer);
2382     }
2383 
2384     function setMarketingWallet(address newMarketingWallet) external onlyOwner {
2385         marketingWallet = newMarketingWallet;
2386     }
2387 
2388     function numberMinted(address owner) public view returns (uint256) {
2389         return _numberMinted(owner);
2390     }
2391 
2392     function getOwnershipData(uint256 tokenId)
2393         external
2394         view
2395         returns (TokenOwnership memory)
2396     {
2397         return ownershipOf(tokenId);
2398     }
2399 
2400     function burn(uint256 tokenId) public virtual {
2401         require(burnLocked == false, "Burning is not enabled.");
2402         require(ownerOf(tokenId) == _msgSender(), "Not owner.");
2403         _burn(tokenId);
2404     }
2405 }