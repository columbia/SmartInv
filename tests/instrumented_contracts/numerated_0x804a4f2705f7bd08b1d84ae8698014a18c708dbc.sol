1 // SPDX-License-Identifier: AGPL-3.0-or-later
2 
3 // File: interfaces/ISinsAuthority.sol
4 
5 
6 pragma solidity >=0.7.5;
7 
8 interface ISinsAuthority {
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
28 // File: types/SinsAccessControlled.sol
29 
30 
31 pragma solidity >=0.7.5;
32 
33 
34 abstract contract SinsAccessControlled {
35 
36     /* ========== EVENTS ========== */
37 
38     event AuthorityUpdated(ISinsAuthority indexed authority);
39 
40     string UNAUTHORIZED = "UNAUTHORIZED"; // save gas
41 
42     /* ========== STATE VARIABLES ========== */
43 
44     ISinsAuthority public authority;
45 
46 
47     /* ========== Constructor ========== */
48 
49     constructor(ISinsAuthority _authority) {
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
79     function setAuthority(ISinsAuthority _newAuthority) external onlyGovernor {
80         authority = _newAuthority;
81         emit AuthorityUpdated(_newAuthority);
82     }
83 }
84 
85 
86 pragma solidity >=0.7.5;
87 
88 
89 /**
90  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
91  *
92  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
93  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
94  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
95  *
96  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
97  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
98  * ({_hashTypedDataV4}).
99  *
100  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
101  * the chain id to protect against replay attacks on an eventual fork of the chain.
102  *
103  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
104  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
105  *
106  * _Available since v3.4._
107  */
108 abstract contract EIP712 {
109     /* solhint-disable var-name-mixedcase */
110     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
111     // invalidate the cached domain separator if the chain id changes.
112     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
113     uint256 private immutable _CACHED_CHAIN_ID;
114 
115     bytes32 private immutable _HASHED_NAME;
116     bytes32 private immutable _HASHED_VERSION;
117     bytes32 private immutable _TYPE_HASH;
118 
119     /* solhint-enable var-name-mixedcase */
120 
121     /**
122      * @dev Initializes the domain separator and parameter caches.
123      *
124      * The meaning of `name` and `version` is specified in
125      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
126      *
127      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
128      * - `version`: the current major version of the signing domain.
129      *
130      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
131      * contract upgrade].
132      */
133     constructor(string memory name, string memory version) {
134 
135         uint256 chainID;
136         assembly {
137             chainID := chainid()
138         }
139 
140         bytes32 hashedName = keccak256(bytes(name));
141         bytes32 hashedVersion = keccak256(bytes(version));
142         bytes32 typeHash = keccak256(
143             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
144         );
145         _HASHED_NAME = hashedName;
146         _HASHED_VERSION = hashedVersion;
147         _CACHED_CHAIN_ID = chainID;
148         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
149         _TYPE_HASH = typeHash;
150     }
151 
152     /**
153      * @dev Returns the domain separator for the current chain.
154      */
155     function _domainSeparatorV4() internal view returns (bytes32) {
156 
157         uint256 chainID;
158         assembly {
159             chainID := chainid()
160         }
161 
162         if (chainID == _CACHED_CHAIN_ID) {
163             return _CACHED_DOMAIN_SEPARATOR;
164         } else {
165             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
166         }
167     }
168 
169     function _buildDomainSeparator(
170         bytes32 typeHash,
171         bytes32 nameHash,
172         bytes32 versionHash
173     ) private view returns (bytes32) {
174         uint256 chainID;
175         assembly {
176             chainID := chainid()
177         }
178 
179         return keccak256(abi.encode(typeHash, nameHash, versionHash, chainID, address(this)));
180     }
181 
182     /**
183      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
184      * function returns the hash of the fully encoded EIP712 message for this domain.
185      *
186      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
187      *
188      * ```solidity
189      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
190      *     keccak256("Mail(address to,string contents)"),
191      *     mailTo,
192      *     keccak256(bytes(mailContents))
193      * )));
194      * address signer = ECDSA.recover(digest, signature);
195      * ```
196      */
197     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
198         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
199     }
200 }
201 // File: interfaces/IERC20Permit.sol
202 
203 
204 pragma solidity >=0.7.5;
205 
206 /**
207  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
208  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
209  *
210  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
211  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
212  * need to send a transaction, and thus is not required to hold Ether at all.
213  */
214 interface IERC20Permit {
215     /**
216      * @dev Sets `value` as th xe allowance of `spender` over ``owner``'s tokens,
217      * given ``owner``'s signed approval.
218      *
219      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
220      * ordering also apply here.
221      *
222      * Emits an {Approval} event.
223      *
224      * Requirements:
225      *
226      * - `spender` cannot be the zero address.
227      * - `deadline` must be a timestamp in the future.
228      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
229      * over the EIP712-formatted function arguments.
230      * - the signature must use ``owner``'s current nonce (see {nonces}).
231      *
232      * For more information on the signature format, see the
233      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
234      * section].
235      */
236     function permit(
237         address owner,
238         address spender,
239         uint256 value,
240         uint256 deadline,
241         uint8 v,
242         bytes32 r,
243         bytes32 s
244     ) external;
245 
246     /**
247      * @dev Returns the current nonce for `owner`. This value must be
248      * included whenever a signature is generated for {permit}.
249      *
250      * Every successful call to {permit} increases ``owner``'s nonce by one. This
251      * prevents a signature from being used multiple times.
252      */
253     function nonces(address owner) external view returns (uint256);
254 
255     /**
256      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
257      */
258     // solhint-disable-next-line func-name-mixedcase
259     function DOMAIN_SEPARATOR() external view returns (bytes32);
260 }
261 
262 // File: interfaces/IERC20.sol
263 
264 
265 pragma solidity >=0.7.5;
266 
267 interface IERC20 {
268   /**
269    * @dev Returns the amount of tokens in existence.
270    */
271   function totalSupply() external view returns (uint256);
272 
273   /**
274    * @dev Returns the amount of tokens owned by `account`.
275    */
276   function balanceOf(address account) external view returns (uint256);
277 
278   /**
279    * @dev Moves `amount` tokens from the caller's account to `recipient`.
280    *
281    * Returns a boolean value indicating whether the operation succeeded.
282    *
283    * Emits a {Transfer} event.
284    */
285   function transfer(address recipient, uint256 amount) external returns (bool);
286 
287   /**
288    * @dev Returns the remaining number of tokens that `spender` will be
289    * allowed to spend on behalf of `owner` through {transferFrom}. This is
290    * zero by default.
291    *
292    * This value changes when {approve} or {transferFrom} are called.
293    */
294   function allowance(address owner, address spender) external view returns (uint256);
295 
296   /**
297    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
298    *
299    * Returns a boolean value indicating whether the operation succeeded.
300    *
301    * IMPORTANT: Beware that changing an allowance with this method brings the risk
302    * that someone may use both the old and the new allowance by unfortunate
303    * transaction ordering. One possible solution to mitigate this race
304    * condition is to first reduce the spender's allowance to 0 and set the
305    * desired value afterwards:
306    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
307    *
308    * Emits an {Approval} event.
309    */
310   function approve(address spender, uint256 amount) external returns (bool);
311 
312   /**
313    * @dev Moves `amount` tokens from `sender` to `recipient` using the
314    * allowance mechanism. `amount` is then deducted from the caller's
315    * allowance.
316    *
317    * Returns a boolean value indicating whether the operation succeeded.
318    *
319    * Emits a {Transfer} event.
320    */
321   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
322 
323   /**
324    * @dev Emitted when `value` tokens are moved from one account (`from`) to
325    * another (`to`).
326    *
327    * Note that `value` may be zero.
328    */
329   event Transfer(address indexed from, address indexed to, uint256 value);
330 
331   /**
332    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
333    * a call to {approve}. `value` is the new allowance.
334    */
335   event Approval(address indexed owner, address indexed spender, uint256 value);
336 }
337 
338 // File: interfaces/ISIN.sol
339 
340 
341 pragma solidity >=0.7.5;
342 
343 
344 interface ISIN is IERC20 {
345   function mint(address account_, uint256 amount_) external;
346 
347   function burn(uint256 amount) external;
348 
349   function burnFrom(address account_, uint256 amount_) external;
350 }
351 
352 
353 pragma solidity >=0.7.5;
354 
355 /**
356  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
357  *
358  * These functions can be used to verify that a message was signed by the holder
359  * of the private keys of a given address.
360  */
361 library ECDSA {
362     enum RecoverError {
363         NoError,
364         InvalidSignature,
365         InvalidSignatureLength,
366         InvalidSignatureS,
367         InvalidSignatureV
368     }
369 
370     function _throwError(RecoverError error) private pure {
371         if (error == RecoverError.NoError) {
372             return; // no error: do nothing
373         } else if (error == RecoverError.InvalidSignature) {
374             revert("ECDSA: invalid signature");
375         } else if (error == RecoverError.InvalidSignatureLength) {
376             revert("ECDSA: invalid signature length");
377         } else if (error == RecoverError.InvalidSignatureS) {
378             revert("ECDSA: invalid signature 's' value");
379         } else if (error == RecoverError.InvalidSignatureV) {
380             revert("ECDSA: invalid signature 'v' value");
381         }
382     }
383 
384     /**
385      * @dev Returns the address that signed a hashed message (`hash`) with
386      * `signature` or error string. This address can then be used for verification purposes.
387      *
388      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
389      * this function rejects them by requiring the `s` value to be in the lower
390      * half order, and the `v` value to be either 27 or 28.
391      *
392      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
393      * verification to be secure: it is possible to craft signatures that
394      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
395      * this is by receiving a hash of the original message (which may otherwise
396      * be too long), and then calling {toEthSignedMessageHash} on it.
397      *
398      * Documentation for signature generation:
399      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
400      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
401      *
402      * _Available since v4.3._
403      */
404     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
405         // Check the signature length
406         // - case 65: r,s,v signature (standard)
407         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
408         if (signature.length == 65) {
409             bytes32 r;
410             bytes32 s;
411             uint8 v;
412             // ecrecover takes the signature parameters, and the only way to get them
413             // currently is to use assembly.
414             assembly {
415                 r := mload(add(signature, 0x20))
416                 s := mload(add(signature, 0x40))
417                 v := byte(0, mload(add(signature, 0x60)))
418             }
419             return tryRecover(hash, v, r, s);
420         } else if (signature.length == 64) {
421             bytes32 r;
422             bytes32 vs;
423             // ecrecover takes the signature parameters, and the only way to get them
424             // currently is to use assembly.
425             assembly {
426                 r := mload(add(signature, 0x20))
427                 vs := mload(add(signature, 0x40))
428             }
429             return tryRecover(hash, r, vs);
430         } else {
431             return (address(0), RecoverError.InvalidSignatureLength);
432         }
433     }
434 
435     /**
436      * @dev Returns the address that signed a hashed message (`hash`) with
437      * `signature`. This address can then be used for verification purposes.
438      *
439      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
440      * this function rejects them by requiring the `s` value to be in the lower
441      * half order, and the `v` value to be either 27 or 28.
442      *
443      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
444      * verification to be secure: it is possible to craft signatures that
445      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
446      * this is by receiving a hash of the original message (which may otherwise
447      * be too long), and then calling {toEthSignedMessageHash} on it.
448      */
449     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
450         (address recovered, RecoverError error) = tryRecover(hash, signature);
451         _throwError(error);
452         return recovered;
453     }
454 
455     /**
456      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
457      *
458      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
459      *
460      * _Available since v4.3._
461      */
462     function tryRecover(
463         bytes32 hash,
464         bytes32 r,
465         bytes32 vs
466     ) internal pure returns (address, RecoverError) {
467         bytes32 s;
468         uint8 v;
469         assembly {
470             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
471             v := add(shr(255, vs), 27)
472         }
473         return tryRecover(hash, v, r, s);
474     }
475 
476     /**
477      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
478      *
479      * _Available since v4.2._
480      */
481     function recover(
482         bytes32 hash,
483         bytes32 r,
484         bytes32 vs
485     ) internal pure returns (address) {
486         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
487         _throwError(error);
488         return recovered;
489     }
490 
491     /**
492      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
493      * `r` and `s` signature fields separately.
494      *
495      * _Available since v4.3._
496      */
497     function tryRecover(
498         bytes32 hash,
499         uint8 v,
500         bytes32 r,
501         bytes32 s
502     ) internal pure returns (address, RecoverError) {
503         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
504         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
505         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
506         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
507         //
508         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
509         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
510         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
511         // these malleable signatures as well.
512         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
513             return (address(0), RecoverError.InvalidSignatureS);
514         }
515         if (v != 27 && v != 28) {
516             return (address(0), RecoverError.InvalidSignatureV);
517         }
518 
519         // If the signature is valid (and not malleable), return the signer address
520         address signer = ecrecover(hash, v, r, s);
521         if (signer == address(0)) {
522             return (address(0), RecoverError.InvalidSignature);
523         }
524 
525         return (signer, RecoverError.NoError);
526     }
527 
528     /**
529      * @dev Overload of {ECDSA-recover} that receives the `v`,
530      * `r` and `s` signature fields separately.
531      */
532     function recover(
533         bytes32 hash,
534         uint8 v,
535         bytes32 r,
536         bytes32 s
537     ) internal pure returns (address) {
538         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
539         _throwError(error);
540         return recovered;
541     }
542 
543     /**
544      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
545      * produces hash corresponding to the one signed with the
546      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
547      * JSON-RPC method as part of EIP-191.
548      *
549      * See {recover}.
550      */
551     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
552         // 32 is the length in bytes of hash,
553         // enforced by the type signature above
554         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
555     }
556 
557     /**
558      * @dev Returns an Ethereum Signed Typed Data, created from a
559      * `domainSeparator` and a `structHash`. This produces hash corresponding
560      * to the one signed with the
561      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
562      * JSON-RPC method as part of EIP-712.
563      *
564      * See {recover}.
565      */
566     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
567         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
568     }
569 }
570 
571 // File: libraries/SafeMath.sol
572 
573 pragma solidity >=0.7.5;
574 
575 
576 // TODO(zx): Replace all instances of SafeMath with OZ implementation
577 library SafeMath {
578 
579     function add(uint256 a, uint256 b) internal pure returns (uint256) {
580         uint256 c = a + b;
581         require(c >= a, "SafeMath: addition overflow");
582 
583         return c;
584     }
585 
586     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
587         return sub(a, b, "SafeMath: subtraction overflow");
588     }
589 
590     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
591         require(b <= a, errorMessage);
592         uint256 c = a - b;
593 
594         return c;
595     }
596 
597     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
598         if (a == 0) {
599             return 0;
600         }
601 
602         uint256 c = a * b;
603         require(c / a == b, "SafeMath: multiplication overflow");
604 
605         return c;
606     }
607 
608     function div(uint256 a, uint256 b) internal pure returns (uint256) {
609         return div(a, b, "SafeMath: division by zero");
610     }
611 
612     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
613         require(b > 0, errorMessage);
614         uint256 c = a / b;
615         assert(a == b * c + a % b); // There is no case in which this doesn't hold
616 
617         return c;
618     }
619 
620     // Only used in the  BondingCalculator.sol
621     function sqrrt(uint256 a) internal pure returns (uint c) {
622         if (a > 3) {
623             c = a;
624             uint b = add( div( a, 2), 1 );
625             while (b < c) {
626                 c = b;
627                 b = div( add( div( a, b ), b), 2 );
628             }
629         } else if (a != 0) {
630             c = 1;
631         }
632     }
633 
634 }
635 // File: libraries/Counters.sol
636 
637 library SafeMathInt {
638     int256 private constant MIN_INT256 = int256(1) << 255;
639     int256 private constant MAX_INT256 = ~(int256(1) << 255);
640 
641     /**
642      * @dev Multiplies two int256 variables and fails on overflow.
643      */
644     function mul(int256 a, int256 b) internal pure returns (int256) {
645         int256 c = a * b;
646 
647         // Detect overflow when multiplying MIN_INT256 with -1
648         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
649         require((b == 0) || (c / b == a));
650         return c;
651     }
652 
653     /**
654      * @dev Division of two int256 variables and fails on overflow.
655      */
656     function div(int256 a, int256 b) internal pure returns (int256) {
657         // Prevent overflow when dividing MIN_INT256 by -1
658         require(b != -1 || a != MIN_INT256);
659 
660         // Solidity already throws when dividing by 0.
661         return a / b;
662     }
663 
664     /**
665      * @dev Subtracts two int256 variables and fails on overflow.
666      */
667     function sub(int256 a, int256 b) internal pure returns (int256) {
668         int256 c = a - b;
669         require((b >= 0 && c <= a) || (b < 0 && c > a));
670         return c;
671     }
672 
673     /**
674      * @dev Adds two int256 variables and fails on overflow.
675      */
676     function add(int256 a, int256 b) internal pure returns (int256) {
677         int256 c = a + b;
678         require((b >= 0 && c >= a) || (b < 0 && c < a));
679         return c;
680     }
681 
682     /**
683      * @dev Converts to absolute value, and fails on overflow.
684      */
685     function abs(int256 a) internal pure returns (int256) {
686         require(a != MIN_INT256);
687         return a < 0 ? -a : a;
688     }
689 
690 
691     function toUint256Safe(int256 a) internal pure returns (uint256) {
692         require(a >= 0);
693         return uint256(a);
694     }
695 }
696 
697 library SafeMathUint {
698   function toInt256Safe(uint256 a) internal pure returns (int256) {
699     int256 b = int256(a);
700     require(b >= 0);
701     return b;
702   }
703 }
704 
705 
706 interface IUniswapV2Router01 {
707     function factory() external pure returns (address);
708     function WETH() external pure returns (address);
709 
710     function addLiquidity(
711         address tokenA,
712         address tokenB,
713         uint amountADesired,
714         uint amountBDesired,
715         uint amountAMin,
716         uint amountBMin,
717         address to,
718         uint deadline
719     ) external returns (uint amountA, uint amountB, uint liquidity);
720     function addLiquidityETH(
721         address token,
722         uint amountTokenDesired,
723         uint amountTokenMin,
724         uint amountETHMin,
725         address to,
726         uint deadline
727     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
728     function removeLiquidity(
729         address tokenA,
730         address tokenB,
731         uint liquidity,
732         uint amountAMin,
733         uint amountBMin,
734         address to,
735         uint deadline
736     ) external returns (uint amountA, uint amountB);
737     function removeLiquidityETH(
738         address token,
739         uint liquidity,
740         uint amountTokenMin,
741         uint amountETHMin,
742         address to,
743         uint deadline
744     ) external returns (uint amountToken, uint amountETH);
745     function removeLiquidityWithPermit(
746         address tokenA,
747         address tokenB,
748         uint liquidity,
749         uint amountAMin,
750         uint amountBMin,
751         address to,
752         uint deadline,
753         bool approveMax, uint8 v, bytes32 r, bytes32 s
754     ) external returns (uint amountA, uint amountB);
755     function removeLiquidityETHWithPermit(
756         address token,
757         uint liquidity,
758         uint amountTokenMin,
759         uint amountETHMin,
760         address to,
761         uint deadline,
762         bool approveMax, uint8 v, bytes32 r, bytes32 s
763     ) external returns (uint amountToken, uint amountETH);
764     function swapExactTokensForTokens(
765         uint amountIn,
766         uint amountOutMin,
767         address[] calldata path,
768         address to,
769         uint deadline
770     ) external returns (uint[] memory amounts);
771     function swapTokensForExactTokens(
772         uint amountOut,
773         uint amountInMax,
774         address[] calldata path,
775         address to,
776         uint deadline
777     ) external returns (uint[] memory amounts);
778     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
779         external
780         payable
781         returns (uint[] memory amounts);
782     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
783         external
784         returns (uint[] memory amounts);
785     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
786         external
787         returns (uint[] memory amounts);
788     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
789         external
790         payable
791         returns (uint[] memory amounts);
792 
793     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
794     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
795     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
796     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
797     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
798 }
799 
800 interface IUniswapV2Router02 is IUniswapV2Router01 {
801     function removeLiquidityETHSupportingFeeOnTransferTokens(
802         address token,
803         uint liquidity,
804         uint amountTokenMin,
805         uint amountETHMin,
806         address to,
807         uint deadline
808     ) external returns (uint amountETH);
809     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
810         address token,
811         uint liquidity,
812         uint amountTokenMin,
813         uint amountETHMin,
814         address to,
815         uint deadline,
816         bool approveMax, uint8 v, bytes32 r, bytes32 s
817     ) external returns (uint amountETH);
818 
819     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
820         uint amountIn,
821         uint amountOutMin,
822         address[] calldata path,
823         address to,
824         uint deadline
825     ) external;
826     function swapExactETHForTokensSupportingFeeOnTransferTokens(
827         uint amountOutMin,
828         address[] calldata path,
829         address to,
830         uint deadline
831     ) external payable;
832     function swapExactTokensForETHSupportingFeeOnTransferTokens(
833         uint amountIn,
834         uint amountOutMin,
835         address[] calldata path,
836         address to,
837         uint deadline
838     ) external;
839 }
840 
841 
842 interface ITaxDistributor {
843   function distribute(address urv2, address dai, address marketingWallet, uint256 daiForBuyback, address buybackWallet, uint256 liquidityTokens, uint256 daiForLiquidity, address liquidityTo) external;
844 }
845 
846 pragma solidity >=0.7.5;
847 
848 
849 library Counters {
850     using SafeMath for uint256;
851 
852     struct Counter {
853         // This variable should never be directly accessed by users of the library: interactions must be restricted to
854         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
855         // this feature: see https://github.com/ethereum/solidity/issues/4637
856         uint256 _value; // default: 0
857     }
858 
859     function current(Counter storage counter) internal view returns (uint256) {
860         return counter._value;
861     }
862 
863     function increment(Counter storage counter) internal {
864         // The {SafeMath} overflow check can be skipped here, see the comment at the top
865         counter._value += 1;
866     }
867 
868     function decrement(Counter storage counter) internal {
869         counter._value = counter._value.sub(1);
870     }
871 }
872 // File: types/ERC20.sol
873 
874 
875 pragma solidity >=0.7.5;
876 
877 
878 abstract contract Context {
879     function _msgSender() internal view virtual returns (address) {
880         return msg.sender;
881     }
882 
883     function _msgData() internal view virtual returns (bytes calldata) {
884         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
885         return msg.data;
886     }
887 }
888 
889 
890 abstract contract ERC20 is Context, IERC20{
891 
892     using SafeMath for uint256;
893 
894     // TODO comment actual hash value.
895     bytes32 constant private ERC20TOKEN_ERC1820_INTERFACE_ID = keccak256( "ERC20Token" );
896     
897     mapping (address => uint256) internal _balances;
898 
899     mapping (address => mapping (address => uint256)) internal _allowances;
900 
901     uint256 internal _totalSupply;
902 
903     string internal _name;
904     
905     string internal _symbol;
906     
907     uint8 internal immutable _decimals;
908 
909     constructor (string memory name_, string memory symbol_, uint8 decimals_) {
910         _name = name_;
911         _symbol = symbol_;
912         _decimals = decimals_;
913     }
914 
915     function name() public view returns (string memory) {
916         return _name;
917     }
918 
919     function symbol() public view returns (string memory) {
920         return _symbol;
921     }
922 
923     function decimals() public view virtual returns (uint8) {
924         return _decimals;
925     }
926 
927     function totalSupply() public view override returns (uint256) {
928         return _totalSupply;
929     }
930 
931     function balanceOf(address account) public view virtual override returns (uint256) {
932         return _balances[account];
933     }
934 
935     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
936         _transfer(msg.sender, recipient, amount);
937         return true;
938     }
939 
940     function allowance(address owner, address spender) public view virtual override returns (uint256) {
941         return _allowances[owner][spender];
942     }
943 
944     function approve(address spender, uint256 amount) public virtual override returns (bool) {
945         _approve(msg.sender, spender, amount);
946         return true;
947     }
948 
949     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
950         _transfer(sender, recipient, amount);
951         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
952         return true;
953     }
954 
955     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
956         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
957         return true;
958     }
959 
960     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
961         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
962         return true;
963     }
964 
965     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
966         require(sender != address(0), "ERC20: transfer from the zero address");
967         require(recipient != address(0), "ERC20: transfer to the zero address");
968 
969         _beforeTokenTransfer(sender, recipient, amount);
970 
971         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
972         _balances[recipient] = _balances[recipient].add(amount);
973         emit Transfer(sender, recipient, amount);
974     }
975 
976     function _mint(address account, uint256 amount) internal virtual {
977         require(account != address(0), "ERC20: mint to the zero address");
978         _beforeTokenTransfer(address(0), account, amount);
979         _totalSupply = _totalSupply.add(amount);
980         _balances[account] = _balances[account].add(amount);
981         emit Transfer(address(0), account, amount);
982     }
983 
984     function _burn(address account, uint256 amount) internal virtual {
985         require(account != address(0), "ERC20: burn from the zero address");
986 
987         _beforeTokenTransfer(account, address(0), amount);
988 
989         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
990         _totalSupply = _totalSupply.sub(amount);
991         emit Transfer(account, address(0), amount);
992     }
993 
994     function _approve(address owner, address spender, uint256 amount) internal virtual {
995         require(owner != address(0), "ERC20: approve from the zero address");
996         require(spender != address(0), "ERC20: approve to the zero address");
997 
998         _allowances[owner][spender] = amount;
999         emit Approval(owner, spender, amount);
1000     }
1001 
1002   function _beforeTokenTransfer( address from_, address to_, uint256 amount_ ) internal virtual { }
1003 }
1004 
1005 // File: types/ERC20Permit.sol
1006 
1007 
1008 pragma solidity >=0.7.5;
1009 
1010 
1011 
1012 
1013 
1014 
1015 /**
1016  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1017  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1018  *
1019  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1020  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1021  * need to send a transaction, and thus is not required to hold Ether at all.
1022  *
1023  * _Available since v3.4._
1024  */
1025 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
1026     using Counters for Counters.Counter;
1027 
1028     mapping(address => Counters.Counter) private _nonces;
1029 
1030     // solhint-disable-next-line var-name-mixedcase
1031     bytes32 private immutable _PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1032 
1033     /**
1034      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
1035      *
1036      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
1037      */
1038     constructor(string memory name) EIP712(name, "1") {}
1039 
1040     /**
1041      * @dev See {IERC20Permit-permit}.
1042      */
1043     function permit(
1044         address owner,
1045         address spender,
1046         uint256 value,
1047         uint256 deadline,
1048         uint8 v,
1049         bytes32 r,
1050         bytes32 s
1051     ) public virtual override {
1052         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
1053 
1054         bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
1055 
1056         bytes32 hash = _hashTypedDataV4(structHash);
1057 
1058         address signer = ECDSA.recover(hash, v, r, s);
1059         require(signer == owner, "ERC20Permit: invalid signature");
1060 
1061         _approve(owner, spender, value);
1062     }
1063 
1064     /**
1065      * @dev See {IERC20Permit-nonces}.
1066      */
1067     function nonces(address owner) public view virtual override returns (uint256) {
1068         return _nonces[owner].current();
1069     }
1070 
1071     /**
1072      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
1073      */
1074     // solhint-disable-next-line func-name-mixedcase
1075     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
1076         return _domainSeparatorV4();
1077     }
1078 
1079     /**
1080      * @dev "Consume a nonce": return the current value and increment.
1081      *
1082      * _Available since v4.1._
1083      */
1084     function _useNonce(address owner) internal virtual returns (uint256 current) {
1085         Counters.Counter storage nonce = _nonces[owner];
1086         current = nonce.current();
1087         nonce.increment();
1088     }
1089 }
1090 
1091 // File: SinsERC20.sol
1092 
1093 
1094 pragma solidity >=0.7.5;
1095 
1096 
1097 
1098 interface IUniswapV2Pair {
1099     event Approval(address indexed owner, address indexed spender, uint value);
1100     event Transfer(address indexed from, address indexed to, uint value);
1101 
1102     function name() external pure returns (string memory);
1103     function symbol() external pure returns (string memory);
1104     function decimals() external pure returns (uint8);
1105     function totalSupply() external view returns (uint);
1106     function balanceOf(address owner) external view returns (uint);
1107     function allowance(address owner, address spender) external view returns (uint);
1108 
1109     function approve(address spender, uint value) external returns (bool);
1110     function transfer(address to, uint value) external returns (bool);
1111     function transferFrom(address from, address to, uint value) external returns (bool);
1112 
1113     function DOMAIN_SEPARATOR() external view returns (bytes32);
1114     function PERMIT_TYPEHASH() external pure returns (bytes32);
1115     function nonces(address owner) external view returns (uint);
1116 
1117     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
1118 
1119     event Mint(address indexed sender, uint amount0, uint amount1);
1120     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
1121     event Swap(
1122         address indexed sender,
1123         uint amount0In,
1124         uint amount1In,
1125         uint amount0Out,
1126         uint amount1Out,
1127         address indexed to
1128     );
1129     event Sync(uint112 reserve0, uint112 reserve1);
1130 
1131     function MINIMUM_LIQUIDITY() external pure returns (uint);
1132     function factory() external view returns (address);
1133     function token0() external view returns (address);
1134     function token1() external view returns (address);
1135     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
1136     function price0CumulativeLast() external view returns (uint);
1137     function price1CumulativeLast() external view returns (uint);
1138     function kLast() external view returns (uint);
1139 
1140     function mint(address to) external returns (uint liquidity);
1141     function burn(address to) external returns (uint amount0, uint amount1);
1142     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
1143     function skim(address to) external;
1144     function sync() external;
1145 
1146     function initialize(address, address) external;
1147 }
1148 
1149 interface IUniswapV2Factory {
1150     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
1151 
1152     function feeTo() external view returns (address);
1153     function feeToSetter() external view returns (address);
1154 
1155     function getPair(address tokenA, address tokenB) external view returns (address pair);
1156     function allPairs(uint) external view returns (address pair);
1157     function allPairsLength() external view returns (uint);
1158 
1159     function createPair(address tokenA, address tokenB) external returns (address pair);
1160 
1161     function setFeeTo(address) external;
1162     function setFeeToSetter(address) external;
1163 }
1164 
1165 
1166 
1167 
1168 contract SinsERC20Token is ERC20Permit, ISIN, SinsAccessControlled {
1169     using SafeMath for uint256;
1170 
1171     IUniswapV2Router02 public uniswapV2Router;
1172     address public uniswapV2Pair;
1173     address public constant deadAddress = address(0xdead);
1174 
1175     address public marketingWallet;
1176     address public buybackWallet;
1177 
1178     bool public tradingActive = false;
1179     bool public swapEnabled = false;
1180     bool private swapping;
1181 
1182     uint256 public buyTotalFees;
1183     uint256 public buyMarketingFee;
1184     uint256 public buyLiquidityFee;
1185     uint256 public buyBurnFee;
1186     uint256 public buyBuybackFee;
1187     
1188     uint256 public sellTotalFees;
1189     uint256 public sellMarketingFee;
1190     uint256 public sellLiquidityFee;
1191     uint256 public sellBurnFee;
1192     uint256 public sellBuybackFee;
1193     address public taxDistributor;
1194     uint256 public tokensForMarketing;
1195     uint256 public tokensForLiquidity;
1196     uint256 public tokensForBurn;
1197     uint256 public tokensForBuyback;
1198 
1199     bool public limitsInEffect = true;
1200     // Anti-bot and anti-whale mappings and variables
1201     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1202     bool public transferDelayEnabled = true;
1203 
1204      // exlcude from fees and max transaction amount
1205     mapping (address => bool) private _isExcludedFromFees;
1206     mapping (address => bool) public _isExcludedMaxTransactionAmount;
1207     uint256 public maxTransactionAmount;
1208     uint256 public maxWallet;
1209     uint256 public initialSupply;
1210     address public dai;
1211     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1212     // could be subject to a maximum transfer amount
1213     mapping (address => bool) public automatedMarketMakerPairs;
1214 
1215 
1216     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
1217 
1218     event ExcludeFromFees(address indexed account, bool isExcluded);
1219 
1220     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
1221     event buybackWalletUpdated(address indexed newWallet, address indexed oldWallet);
1222     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1223     
1224     event SwapAndLiquify(
1225         uint256 tokensSwapped,
1226         uint256 ethReceived,
1227         uint256 tokensIntoLiquidity
1228     );
1229 
1230     constructor(address _authority, address _marketingWallet, address _buybackWallet, address _dai) 
1231     ERC20("Sins", "SIN", 9) 
1232     ERC20Permit("Sins") 
1233     SinsAccessControlled(ISinsAuthority(_authority)) {
1234 
1235         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1236         uniswapV2Router = _uniswapV2Router;
1237         dai = _dai;
1238         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _dai);
1239         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1240 
1241         initialSupply = 50000*1e9;
1242         maxTransactionAmount = initialSupply * 5 / 1000; // 0.5% maxTransactionAmountTxn
1243         maxWallet = initialSupply * 10 / 1000; // 1% maxWallet
1244         _mint(authority.governor(), initialSupply);
1245         
1246         uint256 _buyMarketingFee = 2;
1247         uint256 _buyLiquidityFee = 3;
1248         uint256 _buyBurnFee = 1;
1249         uint256 _buyBuybackFee = 0;
1250 
1251         uint256 _sellMarketingFee = 9;
1252         uint256 _sellLiquidityFee = 3;
1253         uint256 _sellBurnFee = 1;
1254         uint256 _sellBuybackFee = 2;
1255         
1256     
1257         buyMarketingFee = _buyMarketingFee;
1258         buyLiquidityFee = _buyLiquidityFee;
1259         buyBurnFee = _buyBurnFee;
1260         buyBuybackFee = _buyBuybackFee;
1261         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBurnFee + buyBuybackFee;
1262 
1263         sellMarketingFee = _sellMarketingFee;
1264         sellLiquidityFee = _sellLiquidityFee;
1265         sellBurnFee = _sellBurnFee;
1266         sellBuybackFee = _sellBuybackFee;
1267         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBurnFee + sellBuybackFee;
1268         
1269         marketingWallet = address(_marketingWallet);
1270         buybackWallet = address(_buybackWallet);
1271 
1272         // exclude from paying fees or having max transaction amount
1273         excludeFromFees(authority.governor(), true);
1274         excludeFromFees(address(this), true);
1275         excludeFromFees(address(0xdead), true);
1276         
1277     }
1278 
1279     receive() external payable {
1280 
1281   	}
1282 
1283     // remove limits after token is stable
1284     function removeLimits() external onlyGovernor returns (bool){
1285         limitsInEffect = false;
1286         sellMarketingFee = 4;
1287         sellLiquidityFee = 3;
1288         sellBurnFee = 1;
1289         sellBuybackFee = 0;
1290         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBurnFee + sellBuybackFee;
1291         return true;
1292     }
1293 
1294 
1295     function updateTaxDistributor(address _taxDistributor) external onlyGovernor {
1296         taxDistributor = _taxDistributor;
1297     }
1298 
1299 
1300     function updateMaxTxnAmount(uint256 newNum) external onlyGovernor {
1301         require(newNum >= (totalSupply() * 1 / 1000)/1e9, "Cannot set maxTransactionAmount lower than 0.1%");
1302         maxTransactionAmount = newNum * (10**9);
1303     }
1304 
1305     function updateMaxWalletAmount(uint256 newNum) external onlyGovernor {
1306         require(newNum >= (totalSupply() * 5 / 1000)/1e9, "Cannot set maxWallet lower than 0.5%");
1307         maxWallet = newNum * (10**9);
1308     }
1309 
1310     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyGovernor {
1311         _isExcludedMaxTransactionAmount[updAds] = isEx;
1312     }
1313     
1314     // disable Transfer delay - cannot be reenabled
1315     function disableTransferDelay() external onlyGovernor returns (bool){
1316         transferDelayEnabled = false;
1317         return true;
1318     }
1319 
1320 
1321 
1322     // once enabled, can never be turned off
1323     function enableTrading() external onlyGovernor {
1324         tradingActive = true;
1325         swapEnabled = true;
1326     }
1327 
1328     function setAutomatedMarketMakerPair(address pair, bool value) public onlyGovernor {
1329         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1330 
1331         _setAutomatedMarketMakerPair(pair, value);
1332     }
1333 
1334     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1335         automatedMarketMakerPairs[pair] = value;
1336 
1337         emit SetAutomatedMarketMakerPair(pair, value);
1338     }
1339 
1340 
1341     function excludeFromFees(address account, bool excluded) public onlyGovernor {
1342         _isExcludedFromFees[account] = excluded;
1343         emit ExcludeFromFees(account, excluded);
1344     }
1345 
1346     // only use to disable contract sales if absolutely necessary (emergency use only)
1347     function updateSwapEnabled(bool enabled) external onlyGovernor{
1348         swapEnabled = enabled;
1349     }
1350 
1351     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _burnFee, uint256 _buybackFee) external onlyGovernor {
1352         buyMarketingFee = _marketingFee;
1353         buyLiquidityFee = _liquidityFee;
1354         buyBurnFee = _burnFee;
1355         buyBuybackFee = _buybackFee;
1356         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBurnFee + buyBuybackFee;
1357         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
1358     }
1359     
1360     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _burnFee, uint256 _buybackFee) external onlyGovernor {
1361         sellMarketingFee = _marketingFee;
1362         sellLiquidityFee = _liquidityFee;
1363         sellBurnFee = _burnFee;
1364         sellBuybackFee = _buybackFee;
1365         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBurnFee + sellBuybackFee;
1366         require(sellTotalFees <= 15, "Must keep fees at 15% or less");
1367     }
1368 
1369     function updateMarketingWallet(address newMarketingWallet) external onlyGovernor {
1370         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1371         marketingWallet = newMarketingWallet;
1372     }
1373 
1374     function updateBuybackWallet(address newBuybackWallet) external onlyGovernor {
1375         emit buybackWalletUpdated(newBuybackWallet, buybackWallet);
1376         buybackWallet = newBuybackWallet;
1377     }
1378 
1379     function isExcludedFromFees(address account) public view returns(bool) {
1380         return _isExcludedFromFees[account];
1381     }
1382 
1383     function mint(address account_, uint256 amount_) external override onlyVault {
1384         _mint(account_, amount_);
1385     }
1386 
1387     function burn(uint256 amount) external override {
1388         _burn(msg.sender, amount);
1389     }
1390 
1391     function burnFrom(address account_, uint256 amount_) external override {
1392         _burnFrom(account_, amount_);
1393     }
1394 
1395     function _burnFrom(address account_, uint256 amount_) internal {
1396         uint256 decreasedAllowance_ = allowance(account_, msg.sender).sub(amount_, "ERC20: burn amount exceeds allowance");
1397 
1398         _approve(account_, msg.sender, decreasedAllowance_);
1399         _burn(account_, amount_);
1400     }
1401 
1402     function _transfer(
1403         address from,
1404         address to,
1405         uint256 amount
1406     ) internal override {
1407         require(from != address(0), "ERC20: transfer from the zero address");
1408         require(to != address(0), "ERC20: transfer to the zero address");
1409         
1410          if(amount == 0) {
1411             super._transfer(from, to, 0);
1412             return;
1413         }
1414 
1415         if(limitsInEffect){
1416             if (
1417                 from != authority.governor() &&
1418                 to != authority.governor() &&
1419                 to != address(0) &&
1420                 to != address(0xdead) &&
1421                 !swapping
1422             ){
1423                 if(!tradingActive){
1424                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1425                 }
1426 
1427                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1428                 if (transferDelayEnabled){
1429                     if (to != authority.governor() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1430                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1431                         _holderLastTransferTimestamp[tx.origin] = block.number;
1432                     }
1433                 }
1434 
1435 
1436                 //when buy
1437                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1438                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1439                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1440                 }
1441 
1442                 //when sell
1443                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1444                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1445                 }
1446                 else if(!_isExcludedMaxTransactionAmount[to]){
1447                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1448                 }
1449             }
1450         }
1451 		
1452         if( 
1453             swapEnabled &&
1454             !swapping &&
1455             !_isExcludedFromFees[from] &&
1456             !_isExcludedFromFees[to] &&
1457             !automatedMarketMakerPairs[from]
1458         ) {
1459             swapping = true;
1460             
1461             swapBack();
1462 
1463             swapping = false;
1464         }
1465         
1466 
1467         bool takeFee = !swapping;
1468 
1469         // if any account belongs to _isExcludedFromFee account then remove the fee
1470         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1471             takeFee = false;
1472         }
1473         
1474         uint256 fees = 0;
1475         tokensForBurn = 0;
1476         // only take fees on buys/sells, do not take on wallet transfers
1477         if(takeFee){
1478             // on sell
1479             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1480                 fees = amount.mul(sellTotalFees).div(100);
1481                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1482                 tokensForBurn = fees * sellBurnFee / sellTotalFees;
1483                 tokensForBuyback += fees * sellBuybackFee / sellTotalFees;
1484                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1485             }
1486             // on buy
1487             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1488         	    fees = amount.mul(buyTotalFees).div(100);
1489         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1490                 tokensForBurn = fees * buyBurnFee / buyTotalFees;
1491                 tokensForBuyback += fees * buyBuybackFee / buyTotalFees;
1492                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1493             }
1494             
1495             if(fees-tokensForBurn > 0){    
1496                 super._transfer(from, address(this), fees.sub(tokensForBurn));
1497             }
1498             if (tokensForBurn > 0){
1499                 super._transfer(from, deadAddress, tokensForBurn);
1500             }
1501         	
1502         	amount -= fees;
1503         }
1504 
1505         super._transfer(from, to, amount);
1506     }
1507 
1508 
1509     function swapTokensForDai(uint256 tokenAmount) public {
1510 
1511         // generate the uniswap pair path of token -> weth
1512         address[] memory path = new address[](2);
1513         path[0] = address(this);
1514         path[1] = dai;
1515 
1516         _approve(address(this), address(uniswapV2Router), tokenAmount);
1517 
1518         // make the swap
1519         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1520             tokenAmount,
1521             0, // accept any amount of ETH
1522             path,
1523             taxDistributor,
1524             block.timestamp
1525         );
1526         
1527     }
1528 
1529     function swapBack() public {
1530         uint256 contractBalance = balanceOf(address(this));
1531         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForBuyback;
1532         
1533         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1534         
1535         if(contractBalance > totalSupply() * 5 / 10000 * 20){
1536           contractBalance = totalSupply() * 5 / 10000 * 20;
1537         }
1538         // Halve the amount of liquidity tokens
1539         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1540         uint256 amountToSwapForDai = contractBalance.sub(liquidityTokens);
1541         
1542         uint256 initialDaiBalance = IERC20(dai).balanceOf(taxDistributor);
1543 
1544         swapTokensForDai(amountToSwapForDai); 
1545         
1546         uint256 daiBalance = IERC20(dai).balanceOf(taxDistributor).sub(initialDaiBalance);
1547         
1548 
1549         uint256 daiForMarketing = daiBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1550         uint256 daiForBuyback = daiBalance.mul(tokensForBuyback).div(totalTokensToSwap);
1551         
1552         uint256 daiForLiquidity = daiBalance - daiForMarketing - daiForBuyback;
1553 
1554         super._transfer(address(this), taxDistributor, liquidityTokens);
1555 
1556         ITaxDistributor(taxDistributor).distribute(address(uniswapV2Router), dai, marketingWallet, daiForBuyback, buybackWallet, liquidityTokens, daiForLiquidity, authority.governor());
1557         
1558         tokensForLiquidity = 0;
1559         tokensForMarketing = 0;
1560         tokensForBuyback = 0;
1561 
1562     }
1563 
1564 
1565 }