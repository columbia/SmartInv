1 // SPDX-License-Identifier: AGPL-3.0-or-later
2 
3 // File: interfaces/IOlympusAuthority.sol
4 
5 
6 pragma solidity =0.7.5;
7 
8 interface IOlympusAuthority {
9     /* ========== EVENTS ========== */
10     
11     event GovernorPushed(address indexed from, address indexed to, bool _effectiveImmediately);
12     event GuardianPushed(address indexed from, address indexed to, bool _effectiveImmediately);    
13     event PolicyPushed(address indexed from, address indexed to, bool _effectiveImmediately);    
14     event VaultPushed(address indexed from, address indexed to, bool _effectiveImmediately);    
15 
16     event GovernorPulled(address indexed from, address indexed to);
17     event GuardianPulled(address indexed from, address indexed to);
18     event PolicyPulled(address indexed from, address indexed to);
19     event VaultPulled(address indexed from, address indexed to);
20 
21     /* ========== VIEW ========== */
22     
23     function governor() external view returns (address);
24     function guardian() external view returns (address);
25     function policy() external view returns (address);
26     function vault() external view returns (address);
27 }
28 // File: types/OlympusAccessControlled.sol
29 
30 
31 pragma solidity >=0.7.5;
32 
33 
34 abstract contract OlympusAccessControlled {
35 
36     /* ========== EVENTS ========== */
37 
38     event AuthorityUpdated(IOlympusAuthority indexed authority);
39 
40     string UNAUTHORIZED = "UNAUTHORIZED"; // save gas
41 
42     /* ========== STATE VARIABLES ========== */
43 
44     IOlympusAuthority public authority;
45 
46 
47     /* ========== Constructor ========== */
48 
49     constructor(IOlympusAuthority _authority) {
50         authority = _authority;
51         emit AuthorityUpdated(_authority);
52     }
53     
54 
55     /* ========== MODIFIERS ========== */
56     
57     modifier onlyGovernor() {
58         require(msg.sender == authority.governor(), UNAUTHORIZED);
59         _;
60     }
61     
62     modifier onlyGuardian() {
63         require(msg.sender == authority.guardian(), UNAUTHORIZED);
64         _;
65     }
66     
67     modifier onlyPolicy() {
68         require(msg.sender == authority.policy(), UNAUTHORIZED);
69         _;
70     }
71 
72     modifier onlyVault() {
73         require(msg.sender == authority.vault(), UNAUTHORIZED);
74         _;
75     }
76     
77     /* ========== GOV ONLY ========== */
78     
79     function setAuthority(IOlympusAuthority _newAuthority) external onlyGovernor {
80         authority = _newAuthority;
81         emit AuthorityUpdated(_newAuthority);
82     }
83 }
84 
85 // File: cryptography/ECDSA.sol
86 
87 
88 
89 pragma solidity ^0.7.5;
90 
91 /**
92  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
93  *
94  * These functions can be used to verify that a message was signed by the holder
95  * of the private keys of a given address.
96  */
97 library ECDSA {
98     enum RecoverError {
99         NoError,
100         InvalidSignature,
101         InvalidSignatureLength,
102         InvalidSignatureS,
103         InvalidSignatureV
104     }
105 
106     function _throwError(RecoverError error) private pure {
107         if (error == RecoverError.NoError) {
108             return; // no error: do nothing
109         } else if (error == RecoverError.InvalidSignature) {
110             revert("ECDSA: invalid signature");
111         } else if (error == RecoverError.InvalidSignatureLength) {
112             revert("ECDSA: invalid signature length");
113         } else if (error == RecoverError.InvalidSignatureS) {
114             revert("ECDSA: invalid signature 's' value");
115         } else if (error == RecoverError.InvalidSignatureV) {
116             revert("ECDSA: invalid signature 'v' value");
117         }
118     }
119 
120     /**
121      * @dev Returns the address that signed a hashed message (`hash`) with
122      * `signature` or error string. This address can then be used for verification purposes.
123      *
124      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
125      * this function rejects them by requiring the `s` value to be in the lower
126      * half order, and the `v` value to be either 27 or 28.
127      *
128      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
129      * verification to be secure: it is possible to craft signatures that
130      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
131      * this is by receiving a hash of the original message (which may otherwise
132      * be too long), and then calling {toEthSignedMessageHash} on it.
133      *
134      * Documentation for signature generation:
135      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
136      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
137      *
138      * _Available since v4.3._
139      */
140     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
141         // Check the signature length
142         // - case 65: r,s,v signature (standard)
143         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
144         if (signature.length == 65) {
145             bytes32 r;
146             bytes32 s;
147             uint8 v;
148             // ecrecover takes the signature parameters, and the only way to get them
149             // currently is to use assembly.
150             assembly {
151                 r := mload(add(signature, 0x20))
152                 s := mload(add(signature, 0x40))
153                 v := byte(0, mload(add(signature, 0x60)))
154             }
155             return tryRecover(hash, v, r, s);
156         } else if (signature.length == 64) {
157             bytes32 r;
158             bytes32 vs;
159             // ecrecover takes the signature parameters, and the only way to get them
160             // currently is to use assembly.
161             assembly {
162                 r := mload(add(signature, 0x20))
163                 vs := mload(add(signature, 0x40))
164             }
165             return tryRecover(hash, r, vs);
166         } else {
167             return (address(0), RecoverError.InvalidSignatureLength);
168         }
169     }
170 
171     /**
172      * @dev Returns the address that signed a hashed message (`hash`) with
173      * `signature`. This address can then be used for verification purposes.
174      *
175      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
176      * this function rejects them by requiring the `s` value to be in the lower
177      * half order, and the `v` value to be either 27 or 28.
178      *
179      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
180      * verification to be secure: it is possible to craft signatures that
181      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
182      * this is by receiving a hash of the original message (which may otherwise
183      * be too long), and then calling {toEthSignedMessageHash} on it.
184      */
185     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
186         (address recovered, RecoverError error) = tryRecover(hash, signature);
187         _throwError(error);
188         return recovered;
189     }
190 
191     /**
192      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
193      *
194      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
195      *
196      * _Available since v4.3._
197      */
198     function tryRecover(
199         bytes32 hash,
200         bytes32 r,
201         bytes32 vs
202     ) internal pure returns (address, RecoverError) {
203         bytes32 s;
204         uint8 v;
205         assembly {
206             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
207             v := add(shr(255, vs), 27)
208         }
209         return tryRecover(hash, v, r, s);
210     }
211 
212     /**
213      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
214      *
215      * _Available since v4.2._
216      */
217     function recover(
218         bytes32 hash,
219         bytes32 r,
220         bytes32 vs
221     ) internal pure returns (address) {
222         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
223         _throwError(error);
224         return recovered;
225     }
226 
227     /**
228      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
229      * `r` and `s` signature fields separately.
230      *
231      * _Available since v4.3._
232      */
233     function tryRecover(
234         bytes32 hash,
235         uint8 v,
236         bytes32 r,
237         bytes32 s
238     ) internal pure returns (address, RecoverError) {
239         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
240         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
241         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
242         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
243         //
244         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
245         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
246         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
247         // these malleable signatures as well.
248         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
249             return (address(0), RecoverError.InvalidSignatureS);
250         }
251         if (v != 27 && v != 28) {
252             return (address(0), RecoverError.InvalidSignatureV);
253         }
254 
255         // If the signature is valid (and not malleable), return the signer address
256         address signer = ecrecover(hash, v, r, s);
257         if (signer == address(0)) {
258             return (address(0), RecoverError.InvalidSignature);
259         }
260 
261         return (signer, RecoverError.NoError);
262     }
263 
264     /**
265      * @dev Overload of {ECDSA-recover} that receives the `v`,
266      * `r` and `s` signature fields separately.
267      */
268     function recover(
269         bytes32 hash,
270         uint8 v,
271         bytes32 r,
272         bytes32 s
273     ) internal pure returns (address) {
274         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
275         _throwError(error);
276         return recovered;
277     }
278 
279     /**
280      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
281      * produces hash corresponding to the one signed with the
282      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
283      * JSON-RPC method as part of EIP-191.
284      *
285      * See {recover}.
286      */
287     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
288         // 32 is the length in bytes of hash,
289         // enforced by the type signature above
290         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
291     }
292 
293     /**
294      * @dev Returns an Ethereum Signed Typed Data, created from a
295      * `domainSeparator` and a `structHash`. This produces hash corresponding
296      * to the one signed with the
297      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
298      * JSON-RPC method as part of EIP-712.
299      *
300      * See {recover}.
301      */
302     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
303         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
304     }
305 }
306 // File: cryptography/EIP712.sol
307 
308 
309 
310 pragma solidity ^0.7.5;
311 
312 
313 /**
314  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
315  *
316  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
317  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
318  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
319  *
320  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
321  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
322  * ({_hashTypedDataV4}).
323  *
324  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
325  * the chain id to protect against replay attacks on an eventual fork of the chain.
326  *
327  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
328  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
329  *
330  * _Available since v3.4._
331  */
332 abstract contract EIP712 {
333     /* solhint-disable var-name-mixedcase */
334     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
335     // invalidate the cached domain separator if the chain id changes.
336     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
337     uint256 private immutable _CACHED_CHAIN_ID;
338 
339     bytes32 private immutable _HASHED_NAME;
340     bytes32 private immutable _HASHED_VERSION;
341     bytes32 private immutable _TYPE_HASH;
342 
343     /* solhint-enable var-name-mixedcase */
344 
345     /**
346      * @dev Initializes the domain separator and parameter caches.
347      *
348      * The meaning of `name` and `version` is specified in
349      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
350      *
351      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
352      * - `version`: the current major version of the signing domain.
353      *
354      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
355      * contract upgrade].
356      */
357     constructor(string memory name, string memory version) {
358 
359         uint256 chainID;
360         assembly {
361             chainID := chainid()
362         }
363 
364         bytes32 hashedName = keccak256(bytes(name));
365         bytes32 hashedVersion = keccak256(bytes(version));
366         bytes32 typeHash = keccak256(
367             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
368         );
369         _HASHED_NAME = hashedName;
370         _HASHED_VERSION = hashedVersion;
371         _CACHED_CHAIN_ID = chainID;
372         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
373         _TYPE_HASH = typeHash;
374     }
375 
376     /**
377      * @dev Returns the domain separator for the current chain.
378      */
379     function _domainSeparatorV4() internal view returns (bytes32) {
380 
381         uint256 chainID;
382         assembly {
383             chainID := chainid()
384         }
385 
386         if (chainID == _CACHED_CHAIN_ID) {
387             return _CACHED_DOMAIN_SEPARATOR;
388         } else {
389             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
390         }
391     }
392 
393     function _buildDomainSeparator(
394         bytes32 typeHash,
395         bytes32 nameHash,
396         bytes32 versionHash
397     ) private view returns (bytes32) {
398         uint256 chainID;
399         assembly {
400             chainID := chainid()
401         }
402 
403         return keccak256(abi.encode(typeHash, nameHash, versionHash, chainID, address(this)));
404     }
405 
406     /**
407      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
408      * function returns the hash of the fully encoded EIP712 message for this domain.
409      *
410      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
411      *
412      * ```solidity
413      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
414      *     keccak256("Mail(address to,string contents)"),
415      *     mailTo,
416      *     keccak256(bytes(mailContents))
417      * )));
418      * address signer = ECDSA.recover(digest, signature);
419      * ```
420      */
421     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
422         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
423     }
424 }
425 // File: interfaces/IERC20Permit.sol
426 
427 
428 pragma solidity >=0.7.5;
429 
430 /**
431  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
432  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
433  *
434  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
435  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
436  * need to send a transaction, and thus is not required to hold Ether at all.
437  */
438 interface IERC20Permit {
439     /**
440      * @dev Sets `value` as th xe allowance of `spender` over ``owner``'s tokens,
441      * given ``owner``'s signed approval.
442      *
443      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
444      * ordering also apply here.
445      *
446      * Emits an {Approval} event.
447      *
448      * Requirements:
449      *
450      * - `spender` cannot be the zero address.
451      * - `deadline` must be a timestamp in the future.
452      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
453      * over the EIP712-formatted function arguments.
454      * - the signature must use ``owner``'s current nonce (see {nonces}).
455      *
456      * For more information on the signature format, see the
457      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
458      * section].
459      */
460     function permit(
461         address owner,
462         address spender,
463         uint256 value,
464         uint256 deadline,
465         uint8 v,
466         bytes32 r,
467         bytes32 s
468     ) external;
469 
470     /**
471      * @dev Returns the current nonce for `owner`. This value must be
472      * included whenever a signature is generated for {permit}.
473      *
474      * Every successful call to {permit} increases ``owner``'s nonce by one. This
475      * prevents a signature from being used multiple times.
476      */
477     function nonces(address owner) external view returns (uint256);
478 
479     /**
480      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
481      */
482     // solhint-disable-next-line func-name-mixedcase
483     function DOMAIN_SEPARATOR() external view returns (bytes32);
484 }
485 
486 // File: interfaces/IERC20.sol
487 
488 
489 pragma solidity >=0.7.5;
490 
491 interface IERC20 {
492   /**
493    * @dev Returns the amount of tokens in existence.
494    */
495   function totalSupply() external view returns (uint256);
496 
497   /**
498    * @dev Returns the amount of tokens owned by `account`.
499    */
500   function balanceOf(address account) external view returns (uint256);
501 
502   /**
503    * @dev Moves `amount` tokens from the caller's account to `recipient`.
504    *
505    * Returns a boolean value indicating whether the operation succeeded.
506    *
507    * Emits a {Transfer} event.
508    */
509   function transfer(address recipient, uint256 amount) external returns (bool);
510 
511   /**
512    * @dev Returns the remaining number of tokens that `spender` will be
513    * allowed to spend on behalf of `owner` through {transferFrom}. This is
514    * zero by default.
515    *
516    * This value changes when {approve} or {transferFrom} are called.
517    */
518   function allowance(address owner, address spender) external view returns (uint256);
519 
520   /**
521    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
522    *
523    * Returns a boolean value indicating whether the operation succeeded.
524    *
525    * IMPORTANT: Beware that changing an allowance with this method brings the risk
526    * that someone may use both the old and the new allowance by unfortunate
527    * transaction ordering. One possible solution to mitigate this race
528    * condition is to first reduce the spender's allowance to 0 and set the
529    * desired value afterwards:
530    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
531    *
532    * Emits an {Approval} event.
533    */
534   function approve(address spender, uint256 amount) external returns (bool);
535 
536   /**
537    * @dev Moves `amount` tokens from `sender` to `recipient` using the
538    * allowance mechanism. `amount` is then deducted from the caller's
539    * allowance.
540    *
541    * Returns a boolean value indicating whether the operation succeeded.
542    *
543    * Emits a {Transfer} event.
544    */
545   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
546 
547   /**
548    * @dev Emitted when `value` tokens are moved from one account (`from`) to
549    * another (`to`).
550    *
551    * Note that `value` may be zero.
552    */
553   event Transfer(address indexed from, address indexed to, uint256 value);
554 
555   /**
556    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
557    * a call to {approve}. `value` is the new allowance.
558    */
559   event Approval(address indexed owner, address indexed spender, uint256 value);
560 }
561 
562 // File: interfaces/IOHM.sol
563 
564 
565 pragma solidity >=0.7.5;
566 
567 
568 interface IOHM is IERC20 {
569   function mint(address account_, uint256 amount_) external;
570 
571   function burn(uint256 amount) external;
572 
573   function burnFrom(address account_, uint256 amount_) external;
574 }
575 
576 // File: libraries/SafeMath.sol
577 
578 
579 pragma solidity ^0.7.5;
580 
581 
582 // TODO(zx): Replace all instances of SafeMath with OZ implementation
583 library SafeMath {
584 
585     function add(uint256 a, uint256 b) internal pure returns (uint256) {
586         uint256 c = a + b;
587         require(c >= a, "SafeMath: addition overflow");
588 
589         return c;
590     }
591 
592     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
593         return sub(a, b, "SafeMath: subtraction overflow");
594     }
595 
596     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
597         require(b <= a, errorMessage);
598         uint256 c = a - b;
599 
600         return c;
601     }
602 
603     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
604         if (a == 0) {
605             return 0;
606         }
607 
608         uint256 c = a * b;
609         require(c / a == b, "SafeMath: multiplication overflow");
610 
611         return c;
612     }
613 
614     function div(uint256 a, uint256 b) internal pure returns (uint256) {
615         return div(a, b, "SafeMath: division by zero");
616     }
617 
618     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
619         require(b > 0, errorMessage);
620         uint256 c = a / b;
621         assert(a == b * c + a % b); // There is no case in which this doesn't hold
622 
623         return c;
624     }
625 
626     // Only used in the  BondingCalculator.sol
627     function sqrrt(uint256 a) internal pure returns (uint c) {
628         if (a > 3) {
629             c = a;
630             uint b = add( div( a, 2), 1 );
631             while (b < c) {
632                 c = b;
633                 b = div( add( div( a, b ), b), 2 );
634             }
635         } else if (a != 0) {
636             c = 1;
637         }
638     }
639 
640 }
641 // File: libraries/Counters.sol
642 
643 
644 pragma solidity ^0.7.5;
645 
646 
647 library Counters {
648     using SafeMath for uint256;
649 
650     struct Counter {
651         // This variable should never be directly accessed by users of the library: interactions must be restricted to
652         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
653         // this feature: see https://github.com/ethereum/solidity/issues/4637
654         uint256 _value; // default: 0
655     }
656 
657     function current(Counter storage counter) internal view returns (uint256) {
658         return counter._value;
659     }
660 
661     function increment(Counter storage counter) internal {
662         // The {SafeMath} overflow check can be skipped here, see the comment at the top
663         counter._value += 1;
664     }
665 
666     function decrement(Counter storage counter) internal {
667         counter._value = counter._value.sub(1);
668     }
669 }
670 // File: types/ERC20.sol
671 
672 
673 pragma solidity >=0.7.5;
674 
675 
676 
677 
678 abstract contract ERC20 is IERC20 {
679 
680     using SafeMath for uint256;
681 
682     // TODO comment actual hash value.
683     bytes32 constant private ERC20TOKEN_ERC1820_INTERFACE_ID = keccak256( "ERC20Token" );
684     
685     mapping (address => uint256) internal _balances;
686 
687     mapping (address => mapping (address => uint256)) internal _allowances;
688 
689     uint256 internal _totalSupply;
690 
691     string internal _name;
692     
693     string internal _symbol;
694     
695     uint8 internal immutable _decimals;
696 
697     constructor (string memory name_, string memory symbol_, uint8 decimals_) {
698         _name = name_;
699         _symbol = symbol_;
700         _decimals = decimals_;
701     }
702 
703     function name() public view returns (string memory) {
704         return _name;
705     }
706 
707     function symbol() public view returns (string memory) {
708         return _symbol;
709     }
710 
711     function decimals() public view virtual returns (uint8) {
712         return _decimals;
713     }
714 
715     function totalSupply() public view override returns (uint256) {
716         return _totalSupply;
717     }
718 
719     function balanceOf(address account) public view virtual override returns (uint256) {
720         return _balances[account];
721     }
722 
723     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
724         _transfer(msg.sender, recipient, amount);
725         return true;
726     }
727 
728     function allowance(address owner, address spender) public view virtual override returns (uint256) {
729         return _allowances[owner][spender];
730     }
731 
732     function approve(address spender, uint256 amount) public virtual override returns (bool) {
733         _approve(msg.sender, spender, amount);
734         return true;
735     }
736 
737     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
738         _transfer(sender, recipient, amount);
739         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
740         return true;
741     }
742 
743     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
744         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
745         return true;
746     }
747 
748     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
749         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
750         return true;
751     }
752 
753     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
754         require(sender != address(0), "ERC20: transfer from the zero address");
755         require(recipient != address(0), "ERC20: transfer to the zero address");
756 
757         _beforeTokenTransfer(sender, recipient, amount);
758 
759         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
760         _balances[recipient] = _balances[recipient].add(amount);
761         emit Transfer(sender, recipient, amount);
762     }
763 
764     function _mint(address account, uint256 amount) internal virtual {
765         require(account != address(0), "ERC20: mint to the zero address");
766         _beforeTokenTransfer(address(0), account, amount);
767         _totalSupply = _totalSupply.add(amount);
768         _balances[account] = _balances[account].add(amount);
769         emit Transfer(address(0), account, amount);
770     }
771 
772     function _burn(address account, uint256 amount) internal virtual {
773         require(account != address(0), "ERC20: burn from the zero address");
774 
775         _beforeTokenTransfer(account, address(0), amount);
776 
777         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
778         _totalSupply = _totalSupply.sub(amount);
779         emit Transfer(account, address(0), amount);
780     }
781 
782     function _approve(address owner, address spender, uint256 amount) internal virtual {
783         require(owner != address(0), "ERC20: approve from the zero address");
784         require(spender != address(0), "ERC20: approve to the zero address");
785 
786         _allowances[owner][spender] = amount;
787         emit Approval(owner, spender, amount);
788     }
789 
790   function _beforeTokenTransfer( address from_, address to_, uint256 amount_ ) internal virtual { }
791 }
792 
793 // File: types/ERC20Permit.sol
794 
795 
796 pragma solidity >=0.7.5;
797 
798 
799 
800 
801 
802 
803 /**
804  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
805  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
806  *
807  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
808  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
809  * need to send a transaction, and thus is not required to hold Ether at all.
810  *
811  * _Available since v3.4._
812  */
813 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
814     using Counters for Counters.Counter;
815 
816     mapping(address => Counters.Counter) private _nonces;
817 
818     // solhint-disable-next-line var-name-mixedcase
819     bytes32 private immutable _PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
820 
821     /**
822      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
823      *
824      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
825      */
826     constructor(string memory name) EIP712(name, "1") {}
827 
828     /**
829      * @dev See {IERC20Permit-permit}.
830      */
831     function permit(
832         address owner,
833         address spender,
834         uint256 value,
835         uint256 deadline,
836         uint8 v,
837         bytes32 r,
838         bytes32 s
839     ) public virtual override {
840         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
841 
842         bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
843 
844         bytes32 hash = _hashTypedDataV4(structHash);
845 
846         address signer = ECDSA.recover(hash, v, r, s);
847         require(signer == owner, "ERC20Permit: invalid signature");
848 
849         _approve(owner, spender, value);
850     }
851 
852     /**
853      * @dev See {IERC20Permit-nonces}.
854      */
855     function nonces(address owner) public view virtual override returns (uint256) {
856         return _nonces[owner].current();
857     }
858 
859     /**
860      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
861      */
862     // solhint-disable-next-line func-name-mixedcase
863     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
864         return _domainSeparatorV4();
865     }
866 
867     /**
868      * @dev "Consume a nonce": return the current value and increment.
869      *
870      * _Available since v4.1._
871      */
872     function _useNonce(address owner) internal virtual returns (uint256 current) {
873         Counters.Counter storage nonce = _nonces[owner];
874         current = nonce.current();
875         nonce.increment();
876     }
877 }
878 
879 // File: OlympusERC20.sol
880 
881 
882 pragma solidity ^0.7.5;
883 
884 
885 
886 
887 
888 
889 
890 contract OlympusERC20Token is ERC20Permit, IOHM, OlympusAccessControlled {
891     using SafeMath for uint256;
892 
893     constructor(address _authority) 
894     ERC20("Olympus", "OHM", 9) 
895     ERC20Permit("Olympus") 
896     OlympusAccessControlled(IOlympusAuthority(_authority)) {}
897 
898     function mint(address account_, uint256 amount_) external override onlyVault {
899         _mint(account_, amount_);
900     }
901 
902     function burn(uint256 amount) external override {
903         _burn(msg.sender, amount);
904     }
905 
906     function burnFrom(address account_, uint256 amount_) external override {
907         _burnFrom(account_, amount_);
908     }
909 
910     function _burnFrom(address account_, uint256 amount_) internal {
911         uint256 decreasedAllowance_ = allowance(account_, msg.sender).sub(amount_, "ERC20: burn amount exceeds allowance");
912 
913         _approve(account_, msg.sender, decreasedAllowance_);
914         _burn(account_, amount_);
915     }
916 }