1 // SPDX-License-Identifier: AGPL-3.0-or-later
2 
3 //Developed by @crypt0xa
4 pragma solidity >=0.7.5;
5 
6 
7 /**
8  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
9  *
10  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
11  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
12  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
13  *
14  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
15  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
16  * ({_hashTypedDataV4}).
17  *
18  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
19  * the chain id to protect against replay attacks on an eventual fork of the chain.
20  *
21  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
22  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
23  *
24  * _Available since v3.4._
25  */
26 abstract contract EIP712 {
27     /* solhint-disable var-name-mixedcase */
28     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
29     // invalidate the cached domain separator if the chain id changes.
30     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
31     uint256 private immutable _CACHED_CHAIN_ID;
32 
33     bytes32 private immutable _HASHED_NAME;
34     bytes32 private immutable _HASHED_VERSION;
35     bytes32 private immutable _TYPE_HASH;
36 
37     /* solhint-enable var-name-mixedcase */
38 
39     /**
40      * @dev Initializes the domain separator and parameter caches.
41      *
42      * The meaning of `name` and `version` is specified in
43      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
44      *
45      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
46      * - `version`: the current major version of the signing domain.
47      *
48      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
49      * contract upgrade].
50      */
51     constructor(string memory name, string memory version) {
52 
53         uint256 chainID;
54         assembly {
55             chainID := chainid()
56         }
57 
58         bytes32 hashedName = keccak256(bytes(name));
59         bytes32 hashedVersion = keccak256(bytes(version));
60         bytes32 typeHash = keccak256(
61             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
62         );
63         _HASHED_NAME = hashedName;
64         _HASHED_VERSION = hashedVersion;
65         _CACHED_CHAIN_ID = chainID;
66         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
67         _TYPE_HASH = typeHash;
68     }
69 
70     /**
71      * @dev Returns the domain separator for the current chain.
72      */
73     function _domainSeparatorV4() internal view returns (bytes32) {
74 
75         uint256 chainID;
76         assembly {
77             chainID := chainid()
78         }
79 
80         if (chainID == _CACHED_CHAIN_ID) {
81             return _CACHED_DOMAIN_SEPARATOR;
82         } else {
83             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
84         }
85     }
86 
87     function _buildDomainSeparator(
88         bytes32 typeHash,
89         bytes32 nameHash,
90         bytes32 versionHash
91     ) private view returns (bytes32) {
92         uint256 chainID;
93         assembly {
94             chainID := chainid()
95         }
96 
97         return keccak256(abi.encode(typeHash, nameHash, versionHash, chainID, address(this)));
98     }
99 
100     /**
101      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
102      * function returns the hash of the fully encoded EIP712 message for this domain.
103      *
104      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
105      *
106      * ```solidity
107      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
108      *     keccak256("Mail(address to,string contents)"),
109      *     mailTo,
110      *     keccak256(bytes(mailContents))
111      * )));
112      * address signer = ECDSA.recover(digest, signature);
113      * ```
114      */
115     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
116         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
117     }
118 }
119 // File: interfaces/IERC20Permit.sol
120 
121 
122 pragma solidity >=0.7.5;
123 
124 /**
125  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
126  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
127  *
128  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
129  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
130  * need to send a transaction, and thus is not required to hold Ether at all.
131  */
132 interface IERC20Permit {
133     /**
134      * @dev Sets `value` as th xe allowance of `spender` over ``owner``'s tokens,
135      * given ``owner``'s signed approval.
136      *
137      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
138      * ordering also apply here.
139      *
140      * Emits an {Approval} event.
141      *
142      * Requirements:
143      *
144      * - `spender` cannot be the zero address.
145      * - `deadline` must be a timestamp in the future.
146      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
147      * over the EIP712-formatted function arguments.
148      * - the signature must use ``owner``'s current nonce (see {nonces}).
149      *
150      * For more information on the signature format, see the
151      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
152      * section].
153      */
154     function permit(
155         address owner,
156         address spender,
157         uint256 value,
158         uint256 deadline,
159         uint8 v,
160         bytes32 r,
161         bytes32 s
162     ) external;
163 
164     /**
165      * @dev Returns the current nonce for `owner`. This value must be
166      * included whenever a signature is generated for {permit}.
167      *
168      * Every successful call to {permit} increases ``owner``'s nonce by one. This
169      * prevents a signature from being used multiple times.
170      */
171     function nonces(address owner) external view returns (uint256);
172 
173     /**
174      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
175      */
176     // solhint-disable-next-line func-name-mixedcase
177     function DOMAIN_SEPARATOR() external view returns (bytes32);
178 }
179 
180 // File: interfaces/IERC20.sol
181 
182 
183 pragma solidity >=0.7.5;
184 
185 interface IERC20 {
186   /**
187    * @dev Returns the amount of tokens in existence.
188    */
189   function totalSupply() external view returns (uint256);
190 
191   /**
192    * @dev Returns the amount of tokens owned by `account`.
193    */
194   function balanceOf(address account) external view returns (uint256);
195 
196   /**
197    * @dev Moves `amount` tokens from the caller's account to `recipient`.
198    *
199    * Returns a boolean value indicating whether the operation succeeded.
200    *
201    * Emits a {Transfer} event.
202    */
203   function transfer(address recipient, uint256 amount) external returns (bool);
204 
205   /**
206    * @dev Returns the remaining number of tokens that `spender` will be
207    * allowed to spend on behalf of `owner` through {transferFrom}. This is
208    * zero by default.
209    *
210    * This value changes when {approve} or {transferFrom} are called.
211    */
212   function allowance(address owner, address spender) external view returns (uint256);
213 
214   /**
215    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
216    *
217    * Returns a boolean value indicating whether the operation succeeded.
218    *
219    * IMPORTANT: Beware that changing an allowance with this method brings the risk
220    * that someone may use both the old and the new allowance by unfortunate
221    * transaction ordering. One possible solution to mitigate this race
222    * condition is to first reduce the spender's allowance to 0 and set the
223    * desired value afterwards:
224    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
225    *
226    * Emits an {Approval} event.
227    */
228   function approve(address spender, uint256 amount) external returns (bool);
229 
230   /**
231    * @dev Moves `amount` tokens from `sender` to `recipient` using the
232    * allowance mechanism. `amount` is then deducted from the caller's
233    * allowance.
234    *
235    * Returns a boolean value indicating whether the operation succeeded.
236    *
237    * Emits a {Transfer} event.
238    */
239   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
240 
241   /**
242    * @dev Emitted when `value` tokens are moved from one account (`from`) to
243    * another (`to`).
244    *
245    * Note that `value` may be zero.
246    */
247   event Transfer(address indexed from, address indexed to, uint256 value);
248 
249   /**
250    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
251    * a call to {approve}. `value` is the new allowance.
252    */
253   event Approval(address indexed owner, address indexed spender, uint256 value);
254 }
255 
256 // File: interfaces/ISIN.sol
257 
258 
259 pragma solidity >=0.7.5;
260 
261 
262 pragma solidity >=0.7.5;
263 
264 /**
265  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
266  *
267  * These functions can be used to verify that a message was signed by the holder
268  * of the private keys of a given address.
269  */
270 library ECDSA {
271     enum RecoverError {
272         NoError,
273         InvalidSignature,
274         InvalidSignatureLength,
275         InvalidSignatureS,
276         InvalidSignatureV
277     }
278 
279     function _throwError(RecoverError error) private pure {
280         if (error == RecoverError.NoError) {
281             return; // no error: do nothing
282         } else if (error == RecoverError.InvalidSignature) {
283             revert("ECDSA: invalid signature");
284         } else if (error == RecoverError.InvalidSignatureLength) {
285             revert("ECDSA: invalid signature length");
286         } else if (error == RecoverError.InvalidSignatureS) {
287             revert("ECDSA: invalid signature 's' value");
288         } else if (error == RecoverError.InvalidSignatureV) {
289             revert("ECDSA: invalid signature 'v' value");
290         }
291     }
292 
293     /**
294      * @dev Returns the address that signed a hashed message (`hash`) with
295      * `signature` or error string. This address can then be used for verification purposes.
296      *
297      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
298      * this function rejects them by requiring the `s` value to be in the lower
299      * half order, and the `v` value to be either 27 or 28.
300      *
301      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
302      * verification to be secure: it is possible to craft signatures that
303      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
304      * this is by receiving a hash of the original message (which may otherwise
305      * be too long), and then calling {toEthSignedMessageHash} on it.
306      *
307      * Documentation for signature generation:
308      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
309      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
310      *
311      * _Available since v4.3._
312      */
313     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
314         // Check the signature length
315         // - case 65: r,s,v signature (standard)
316         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
317         if (signature.length == 65) {
318             bytes32 r;
319             bytes32 s;
320             uint8 v;
321             // ecrecover takes the signature parameters, and the only way to get them
322             // currently is to use assembly.
323             assembly {
324                 r := mload(add(signature, 0x20))
325                 s := mload(add(signature, 0x40))
326                 v := byte(0, mload(add(signature, 0x60)))
327             }
328             return tryRecover(hash, v, r, s);
329         } else if (signature.length == 64) {
330             bytes32 r;
331             bytes32 vs;
332             // ecrecover takes the signature parameters, and the only way to get them
333             // currently is to use assembly.
334             assembly {
335                 r := mload(add(signature, 0x20))
336                 vs := mload(add(signature, 0x40))
337             }
338             return tryRecover(hash, r, vs);
339         } else {
340             return (address(0), RecoverError.InvalidSignatureLength);
341         }
342     }
343 
344     /**
345      * @dev Returns the address that signed a hashed message (`hash`) with
346      * `signature`. This address can then be used for verification purposes.
347      *
348      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
349      * this function rejects them by requiring the `s` value to be in the lower
350      * half order, and the `v` value to be either 27 or 28.
351      *
352      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
353      * verification to be secure: it is possible to craft signatures that
354      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
355      * this is by receiving a hash of the original message (which may otherwise
356      * be too long), and then calling {toEthSignedMessageHash} on it.
357      */
358     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
359         (address recovered, RecoverError error) = tryRecover(hash, signature);
360         _throwError(error);
361         return recovered;
362     }
363 
364     /**
365      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
366      *
367      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
368      *
369      * _Available since v4.3._
370      */
371     function tryRecover(
372         bytes32 hash,
373         bytes32 r,
374         bytes32 vs
375     ) internal pure returns (address, RecoverError) {
376         bytes32 s;
377         uint8 v;
378         assembly {
379             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
380             v := add(shr(255, vs), 27)
381         }
382         return tryRecover(hash, v, r, s);
383     }
384 
385     /**
386      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
387      *
388      * _Available since v4.2._
389      */
390     function recover(
391         bytes32 hash,
392         bytes32 r,
393         bytes32 vs
394     ) internal pure returns (address) {
395         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
396         _throwError(error);
397         return recovered;
398     }
399 
400     /**
401      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
402      * `r` and `s` signature fields separately.
403      *
404      * _Available since v4.3._
405      */
406     function tryRecover(
407         bytes32 hash,
408         uint8 v,
409         bytes32 r,
410         bytes32 s
411     ) internal pure returns (address, RecoverError) {
412         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
413         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
414         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
415         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
416         //
417         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
418         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
419         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
420         // these malleable signatures as well.
421         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
422             return (address(0), RecoverError.InvalidSignatureS);
423         }
424         if (v != 27 && v != 28) {
425             return (address(0), RecoverError.InvalidSignatureV);
426         }
427 
428         // If the signature is valid (and not malleable), return the signer address
429         address signer = ecrecover(hash, v, r, s);
430         if (signer == address(0)) {
431             return (address(0), RecoverError.InvalidSignature);
432         }
433 
434         return (signer, RecoverError.NoError);
435     }
436 
437     /**
438      * @dev Overload of {ECDSA-recover} that receives the `v`,
439      * `r` and `s` signature fields separately.
440      */
441     function recover(
442         bytes32 hash,
443         uint8 v,
444         bytes32 r,
445         bytes32 s
446     ) internal pure returns (address) {
447         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
448         _throwError(error);
449         return recovered;
450     }
451 
452     /**
453      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
454      * produces hash corresponding to the one signed with the
455      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
456      * JSON-RPC method as part of EIP-191.
457      *
458      * See {recover}.
459      */
460     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
461         // 32 is the length in bytes of hash,
462         // enforced by the type signature above
463         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
464     }
465 
466     /**
467      * @dev Returns an Ethereum Signed Typed Data, created from a
468      * `domainSeparator` and a `structHash`. This produces hash corresponding
469      * to the one signed with the
470      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
471      * JSON-RPC method as part of EIP-712.
472      *
473      * See {recover}.
474      */
475     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
476         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
477     }
478 }
479 
480 // File: libraries/SafeMath.sol
481 
482 pragma solidity >=0.7.5;
483 
484 
485 // TODO(zx): Replace all instances of SafeMath with OZ implementation
486 library SafeMath {
487 
488     function add(uint256 a, uint256 b) internal pure returns (uint256) {
489         uint256 c = a + b;
490         require(c >= a, "SafeMath: addition overflow");
491 
492         return c;
493     }
494 
495     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
496         return sub(a, b, "SafeMath: subtraction overflow");
497     }
498 
499     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
500         require(b <= a, errorMessage);
501         uint256 c = a - b;
502 
503         return c;
504     }
505 
506     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
507         if (a == 0) {
508             return 0;
509         }
510 
511         uint256 c = a * b;
512         require(c / a == b, "SafeMath: multiplication overflow");
513 
514         return c;
515     }
516 
517     function div(uint256 a, uint256 b) internal pure returns (uint256) {
518         return div(a, b, "SafeMath: division by zero");
519     }
520 
521     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
522         require(b > 0, errorMessage);
523         uint256 c = a / b;
524         assert(a == b * c + a % b); // There is no case in which this doesn't hold
525 
526         return c;
527     }
528 
529     // Only used in the  BondingCalculator.sol
530     function sqrrt(uint256 a) internal pure returns (uint c) {
531         if (a > 3) {
532             c = a;
533             uint b = add( div( a, 2), 1 );
534             while (b < c) {
535                 c = b;
536                 b = div( add( div( a, b ), b), 2 );
537             }
538         } else if (a != 0) {
539             c = 1;
540         }
541     }
542 
543 }
544 // File: libraries/Counters.sol
545 
546 library SafeMathInt {
547     int256 private constant MIN_INT256 = int256(1) << 255;
548     int256 private constant MAX_INT256 = ~(int256(1) << 255);
549 
550     /**
551      * @dev Multiplies two int256 variables and fails on overflow.
552      */
553     function mul(int256 a, int256 b) internal pure returns (int256) {
554         int256 c = a * b;
555 
556         // Detect overflow when multiplying MIN_INT256 with -1
557         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
558         require((b == 0) || (c / b == a));
559         return c;
560     }
561 
562     /**
563      * @dev Division of two int256 variables and fails on overflow.
564      */
565     function div(int256 a, int256 b) internal pure returns (int256) {
566         // Prevent overflow when dividing MIN_INT256 by -1
567         require(b != -1 || a != MIN_INT256);
568 
569         // Solidity already throws when dividing by 0.
570         return a / b;
571     }
572 
573     /**
574      * @dev Subtracts two int256 variables and fails on overflow.
575      */
576     function sub(int256 a, int256 b) internal pure returns (int256) {
577         int256 c = a - b;
578         require((b >= 0 && c <= a) || (b < 0 && c > a));
579         return c;
580     }
581 
582     /**
583      * @dev Adds two int256 variables and fails on overflow.
584      */
585     function add(int256 a, int256 b) internal pure returns (int256) {
586         int256 c = a + b;
587         require((b >= 0 && c >= a) || (b < 0 && c < a));
588         return c;
589     }
590 
591     /**
592      * @dev Converts to absolute value, and fails on overflow.
593      */
594     function abs(int256 a) internal pure returns (int256) {
595         require(a != MIN_INT256);
596         return a < 0 ? -a : a;
597     }
598 
599 
600     function toUint256Safe(int256 a) internal pure returns (uint256) {
601         require(a >= 0);
602         return uint256(a);
603     }
604 }
605 
606 library SafeMathUint {
607   function toInt256Safe(uint256 a) internal pure returns (int256) {
608     int256 b = int256(a);
609     require(b >= 0);
610     return b;
611   }
612 }
613 
614 
615 interface IUniswapV2Router01 {
616     function factory() external pure returns (address);
617     function WETH() external pure returns (address);
618 
619     function addLiquidity(
620         address tokenA,
621         address tokenB,
622         uint amountADesired,
623         uint amountBDesired,
624         uint amountAMin,
625         uint amountBMin,
626         address to,
627         uint deadline
628     ) external returns (uint amountA, uint amountB, uint liquidity);
629     function addLiquidityETH(
630         address token,
631         uint amountTokenDesired,
632         uint amountTokenMin,
633         uint amountETHMin,
634         address to,
635         uint deadline
636     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
637     function removeLiquidity(
638         address tokenA,
639         address tokenB,
640         uint liquidity,
641         uint amountAMin,
642         uint amountBMin,
643         address to,
644         uint deadline
645     ) external returns (uint amountA, uint amountB);
646     function removeLiquidityETH(
647         address token,
648         uint liquidity,
649         uint amountTokenMin,
650         uint amountETHMin,
651         address to,
652         uint deadline
653     ) external returns (uint amountToken, uint amountETH);
654     function removeLiquidityWithPermit(
655         address tokenA,
656         address tokenB,
657         uint liquidity,
658         uint amountAMin,
659         uint amountBMin,
660         address to,
661         uint deadline,
662         bool approveMax, uint8 v, bytes32 r, bytes32 s
663     ) external returns (uint amountA, uint amountB);
664     function removeLiquidityETHWithPermit(
665         address token,
666         uint liquidity,
667         uint amountTokenMin,
668         uint amountETHMin,
669         address to,
670         uint deadline,
671         bool approveMax, uint8 v, bytes32 r, bytes32 s
672     ) external returns (uint amountToken, uint amountETH);
673     function swapExactTokensForTokens(
674         uint amountIn,
675         uint amountOutMin,
676         address[] calldata path,
677         address to,
678         uint deadline
679     ) external returns (uint[] memory amounts);
680     function swapTokensForExactTokens(
681         uint amountOut,
682         uint amountInMax,
683         address[] calldata path,
684         address to,
685         uint deadline
686     ) external returns (uint[] memory amounts);
687     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
688         external
689         payable
690         returns (uint[] memory amounts);
691     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
692         external
693         returns (uint[] memory amounts);
694     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
695         external
696         returns (uint[] memory amounts);
697     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
698         external
699         payable
700         returns (uint[] memory amounts);
701 
702     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
703     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
704     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
705     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
706     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
707 }
708 
709 interface IUniswapV2Router02 is IUniswapV2Router01 {
710     function removeLiquidityETHSupportingFeeOnTransferTokens(
711         address token,
712         uint liquidity,
713         uint amountTokenMin,
714         uint amountETHMin,
715         address to,
716         uint deadline
717     ) external returns (uint amountETH);
718     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
719         address token,
720         uint liquidity,
721         uint amountTokenMin,
722         uint amountETHMin,
723         address to,
724         uint deadline,
725         bool approveMax, uint8 v, bytes32 r, bytes32 s
726     ) external returns (uint amountETH);
727 
728     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
729         uint amountIn,
730         uint amountOutMin,
731         address[] calldata path,
732         address to,
733         uint deadline
734     ) external;
735     function swapExactETHForTokensSupportingFeeOnTransferTokens(
736         uint amountOutMin,
737         address[] calldata path,
738         address to,
739         uint deadline
740     ) external payable;
741     function swapExactTokensForETHSupportingFeeOnTransferTokens(
742         uint amountIn,
743         uint amountOutMin,
744         address[] calldata path,
745         address to,
746         uint deadline
747     ) external;
748 }
749 
750 pragma solidity >=0.7.5;
751 
752 
753 library Counters {
754     using SafeMath for uint256;
755 
756     struct Counter {
757         // This variable should never be directly accessed by users of the library: interactions must be restricted to
758         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
759         // this feature: see https://github.com/ethereum/solidity/issues/4637
760         uint256 _value; // default: 0
761     }
762 
763     function current(Counter storage counter) internal view returns (uint256) {
764         return counter._value;
765     }
766 
767     function increment(Counter storage counter) internal {
768         // The {SafeMath} overflow check can be skipped here, see the comment at the top
769         counter._value += 1;
770     }
771 
772     function decrement(Counter storage counter) internal {
773         counter._value = counter._value.sub(1);
774     }
775 }
776 // File: types/ERC20.sol
777 
778 
779 pragma solidity >=0.7.5;
780 
781 
782 abstract contract Context {
783     function _msgSender() internal view virtual returns (address) {
784         return msg.sender;
785     }
786 
787     function _msgData() internal view virtual returns (bytes calldata) {
788         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
789         return msg.data;
790     }
791 }
792 
793 
794 pragma solidity >=0.7.5;
795 
796 contract Ownable is Context {
797     address private _owner;
798 
799     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
800     
801     /**
802      * @dev Initializes the contract setting the deployer as the initial owner.
803      */
804     constructor () {
805         address msgSender = _msgSender();
806         _owner = msgSender;
807         emit OwnershipTransferred(address(0), msgSender);
808     }
809 
810     /**
811      * @dev Returns the address of the current owner.
812      */
813     function owner() public view returns (address) {
814         return _owner;
815     }
816 
817     /**
818      * @dev Throws if called by any account other than the owner.
819      */
820     modifier onlyOwner() {
821         require(_owner == _msgSender(), "Ownable: caller is not the owner");
822         _;
823     }
824 
825     /**
826      * @dev Leaves the contract without owner. It will not be possible to call
827      * `onlyOwner` functions anymore. Can only be called by the current owner.
828      *
829      * NOTE: Renouncing ownership will leave the contract without an owner,
830      * thereby removing any functionality that is only available to the owner.
831      */
832     function renounceOwnership() public virtual onlyOwner {
833         emit OwnershipTransferred(_owner, address(0));
834         _owner = address(0);
835     }
836 
837     /**
838      * @dev Transfers ownership of the contract to a new account (`newOwner`).
839      * Can only be called by the current owner.
840      */
841     function transferOwnership(address newOwner) public virtual onlyOwner {
842         require(newOwner != address(0), "Ownable: new owner is the zero address");
843         emit OwnershipTransferred(_owner, newOwner);
844         _owner = newOwner;
845     }
846 }
847 
848 
849 abstract contract ERC20 is Context, IERC20{
850 
851     using SafeMath for uint256;
852 
853     // TODO comment actual hash value.
854     bytes32 constant private ERC20TOKEN_ERC1820_INTERFACE_ID = keccak256( "ERC20Token" );
855     
856     mapping (address => uint256) internal _balances;
857 
858     mapping (address => mapping (address => uint256)) internal _allowances;
859 
860     uint256 internal _totalSupply;
861 
862     string internal _name;
863     
864     string internal _symbol;
865     
866     uint8 internal immutable _decimals;
867 
868     constructor (string memory name_, string memory symbol_, uint8 decimals_) {
869         _name = name_;
870         _symbol = symbol_;
871         _decimals = decimals_;
872     }
873 
874     function name() public view returns (string memory) {
875         return _name;
876     }
877 
878     function symbol() public view returns (string memory) {
879         return _symbol;
880     }
881 
882     function decimals() public view virtual returns (uint8) {
883         return _decimals;
884     }
885 
886     function totalSupply() public view override returns (uint256) {
887         return _totalSupply;
888     }
889 
890     function balanceOf(address account) public view virtual override returns (uint256) {
891         return _balances[account];
892     }
893 
894     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
895         _transfer(msg.sender, recipient, amount);
896         return true;
897     }
898 
899     function allowance(address owner, address spender) public view virtual override returns (uint256) {
900         return _allowances[owner][spender];
901     }
902 
903     function approve(address spender, uint256 amount) public virtual override returns (bool) {
904         _approve(msg.sender, spender, amount);
905         return true;
906     }
907 
908     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
909         _transfer(sender, recipient, amount);
910         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
911         return true;
912     }
913 
914     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
915         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
916         return true;
917     }
918 
919     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
920         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
921         return true;
922     }
923 
924     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
925         require(sender != address(0), "ERC20: transfer from the zero address");
926         require(recipient != address(0), "ERC20: transfer to the zero address");
927 
928         _beforeTokenTransfer(sender, recipient, amount);
929 
930         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
931         _balances[recipient] = _balances[recipient].add(amount);
932         emit Transfer(sender, recipient, amount);
933     }
934 
935     function _mint(address account, uint256 amount) internal virtual {
936         require(account != address(0), "ERC20: mint to the zero address");
937         _beforeTokenTransfer(address(0), account, amount);
938         _totalSupply = _totalSupply.add(amount);
939         _balances[account] = _balances[account].add(amount);
940         emit Transfer(address(0), account, amount);
941     }
942 
943     function _burn(address account, uint256 amount) internal virtual {
944         require(account != address(0), "ERC20: burn from the zero address");
945 
946         _beforeTokenTransfer(account, address(0), amount);
947 
948         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
949         _totalSupply = _totalSupply.sub(amount);
950         emit Transfer(account, address(0), amount);
951     }
952 
953     function _approve(address owner, address spender, uint256 amount) internal virtual {
954         require(owner != address(0), "ERC20: approve from the zero address");
955         require(spender != address(0), "ERC20: approve to the zero address");
956 
957         _allowances[owner][spender] = amount;
958         emit Approval(owner, spender, amount);
959     }
960 
961   function _beforeTokenTransfer( address from_, address to_, uint256 amount_ ) internal virtual { }
962 }
963 
964 // File: types/ERC20Permit.sol
965 
966 
967 pragma solidity >=0.7.5;
968 
969 
970 
971 
972 
973 
974 /**
975  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
976  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
977  *
978  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
979  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
980  * need to send a transaction, and thus is not required to hold Ether at all.
981  *
982  * _Available since v3.4._
983  */
984 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
985     using Counters for Counters.Counter;
986 
987     mapping(address => Counters.Counter) private _nonces;
988 
989     // solhint-disable-next-line var-name-mixedcase
990     bytes32 private immutable _PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
991 
992     /**
993      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
994      *
995      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
996      */
997     constructor(string memory name) EIP712(name, "1") {}
998 
999     /**
1000      * @dev See {IERC20Permit-permit}.
1001      */
1002     function permit(
1003         address owner,
1004         address spender,
1005         uint256 value,
1006         uint256 deadline,
1007         uint8 v,
1008         bytes32 r,
1009         bytes32 s
1010     ) public virtual override {
1011         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
1012 
1013         bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
1014 
1015         bytes32 hash = _hashTypedDataV4(structHash);
1016 
1017         address signer = ECDSA.recover(hash, v, r, s);
1018         require(signer == owner, "ERC20Permit: invalid signature");
1019 
1020         _approve(owner, spender, value);
1021     }
1022 
1023     /**
1024      * @dev See {IERC20Permit-nonces}.
1025      */
1026     function nonces(address owner) public view virtual override returns (uint256) {
1027         return _nonces[owner].current();
1028     }
1029 
1030     /**
1031      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
1032      */
1033     // solhint-disable-next-line func-name-mixedcase
1034     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
1035         return _domainSeparatorV4();
1036     }
1037 
1038     /**
1039      * @dev "Consume a nonce": return the current value and increment.
1040      *
1041      * _Available since v4.1._
1042      */
1043     function _useNonce(address owner) internal virtual returns (uint256 current) {
1044         Counters.Counter storage nonce = _nonces[owner];
1045         current = nonce.current();
1046         nonce.increment();
1047     }
1048 }
1049 
1050 // File: SinsERC20.sol
1051 
1052 
1053 pragma solidity >=0.7.5;
1054 
1055 
1056 
1057 interface IUniswapV2Pair {
1058     event Approval(address indexed owner, address indexed spender, uint value);
1059     event Transfer(address indexed from, address indexed to, uint value);
1060 
1061     function name() external pure returns (string memory);
1062     function symbol() external pure returns (string memory);
1063     function decimals() external pure returns (uint8);
1064     function totalSupply() external view returns (uint);
1065     function balanceOf(address owner) external view returns (uint);
1066     function allowance(address owner, address spender) external view returns (uint);
1067 
1068     function approve(address spender, uint value) external returns (bool);
1069     function transfer(address to, uint value) external returns (bool);
1070     function transferFrom(address from, address to, uint value) external returns (bool);
1071 
1072     function DOMAIN_SEPARATOR() external view returns (bytes32);
1073     function PERMIT_TYPEHASH() external pure returns (bytes32);
1074     function nonces(address owner) external view returns (uint);
1075 
1076     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
1077 
1078     event Mint(address indexed sender, uint amount0, uint amount1);
1079     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
1080     event Swap(
1081         address indexed sender,
1082         uint amount0In,
1083         uint amount1In,
1084         uint amount0Out,
1085         uint amount1Out,
1086         address indexed to
1087     );
1088     event Sync(uint112 reserve0, uint112 reserve1);
1089 
1090     function MINIMUM_LIQUIDITY() external pure returns (uint);
1091     function factory() external view returns (address);
1092     function token0() external view returns (address);
1093     function token1() external view returns (address);
1094     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
1095     function price0CumulativeLast() external view returns (uint);
1096     function price1CumulativeLast() external view returns (uint);
1097     function kLast() external view returns (uint);
1098 
1099     function mint(address to) external returns (uint liquidity);
1100     function burn(address to) external returns (uint amount0, uint amount1);
1101     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
1102     function skim(address to) external;
1103     function sync() external;
1104 
1105     function initialize(address, address) external;
1106 }
1107 
1108 interface IUniswapV2Factory {
1109     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
1110 
1111     function feeTo() external view returns (address);
1112     function feeToSetter() external view returns (address);
1113 
1114     function getPair(address tokenA, address tokenB) external view returns (address pair);
1115     function allPairs(uint) external view returns (address pair);
1116     function allPairsLength() external view returns (uint);
1117 
1118     function createPair(address tokenA, address tokenB) external returns (address pair);
1119 
1120     function setFeeTo(address) external;
1121     function setFeeToSetter(address) external;
1122 }
1123 
1124 
1125 
1126 
1127 contract SinsERC20Token is ERC20Permit, Ownable {
1128     using SafeMath for uint256;
1129 
1130     IUniswapV2Router02 public uniswapV2Router;
1131     address public uniswapV2Pair;
1132     address public constant deadAddress = address(0xdead);
1133 
1134     address public marketingWallet;
1135     address public treasuryWallet;
1136 
1137     bool public tradingActive = false;
1138     bool public swapEnabled = false;
1139     bool private swapping;
1140     uint256 public enableBlock = 0;
1141 
1142     uint256 public buyTotalFees;
1143     uint256 public buyMarketingFee;
1144     uint256 public buyLiquidityFee;
1145     uint256 public buyBurnFee;
1146     uint256 public buyTreasuryFee;
1147     
1148     uint256 public sellTotalFees;
1149     uint256 public sellMarketingFee;
1150     uint256 public sellLiquidityFee;
1151     uint256 public sellBurnFee;
1152     uint256 public sellTreasuryFee;
1153 
1154     uint256 public tokensForMarketing;
1155     uint256 public tokensForLiquidity;
1156     uint256 public tokensForBurn;
1157     uint256 public tokensForTreasury;
1158 
1159     bool public limitsInEffect = true;
1160     // Anti-bot and anti-whale mappings and variables
1161     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1162     bool public transferDelayEnabled = true;
1163 
1164      // exlcude from fees and max transaction amount
1165     mapping (address => bool) private _isExcludedFromFees;
1166     mapping (address => bool) public _isExcludedMaxTransactionAmount;
1167     uint256 public maxTransactionAmount;
1168     uint256 public maxWallet;
1169     uint256 public initialSupply;
1170     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1171     // could be subject to a maximum transfer amount
1172     mapping (address => bool) public automatedMarketMakerPairs;
1173     mapping (address => bool) public launchMarketMaker;
1174 
1175     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
1176 
1177     event ExcludeFromFees(address indexed account, bool isExcluded);
1178 
1179     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
1180     event treasuryWalletUpdated(address indexed newWallet, address indexed oldWallet);
1181     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1182     
1183     event SwapAndLiquify(
1184         uint256 tokensSwapped,
1185         uint256 ethReceived,
1186         uint256 tokensIntoLiquidity
1187     );
1188 
1189     constructor(address _marketingWallet, address _treasuryWallet) 
1190     ERC20("Sins", "SIN", 9) 
1191     ERC20Permit("Sins") 
1192     {
1193 
1194         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1195         uniswapV2Router = _uniswapV2Router;
1196         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
1197         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1198 
1199         initialSupply = 1000000*1e9;
1200         maxTransactionAmount = initialSupply * 5 / 1000; // 0.5% maxTransactionAmountTxn
1201         maxWallet = initialSupply * 10 / 1000; // 1% maxWallet
1202         _mint(owner(), initialSupply);
1203         
1204         uint256 _buyMarketingFee = 2;
1205         uint256 _buyLiquidityFee = 2;
1206         uint256 _buyBurnFee = 0;
1207         uint256 _buyTreasuryFee = 2;
1208 
1209         uint256 _sellMarketingFee = 4;
1210         uint256 _sellLiquidityFee = 2;
1211         uint256 _sellBurnFee = 0;
1212         uint256 _sellTreasuryFee = 2;
1213         
1214     
1215         buyMarketingFee = _buyMarketingFee;
1216         buyLiquidityFee = _buyLiquidityFee;
1217         buyBurnFee = _buyBurnFee;
1218         buyTreasuryFee = _buyTreasuryFee;
1219         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBurnFee + buyTreasuryFee;
1220 
1221         sellMarketingFee = _sellMarketingFee;
1222         sellLiquidityFee = _sellLiquidityFee;
1223         sellBurnFee = _sellBurnFee;
1224         sellTreasuryFee = _sellTreasuryFee;
1225         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBurnFee + sellTreasuryFee;
1226         
1227         marketingWallet = address(_marketingWallet);
1228         treasuryWallet = address(_treasuryWallet);
1229 
1230         // exclude from paying fees or having max transaction amount
1231         excludeFromFees(owner(), true);
1232         excludeFromFees(address(this), true);
1233         excludeFromFees(address(0xdead), true);
1234         
1235     }
1236 
1237     receive() external payable {
1238 
1239   	}
1240 
1241     // remove limits after token is stable
1242     function removeLimits() external onlyOwner returns (bool){
1243         limitsInEffect = false;
1244         return true;
1245     }
1246 
1247 
1248     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1249         require(newNum >= (totalSupply() * 1 / 1000)/1e9, "Cannot set maxTransactionAmount lower than 0.1%");
1250         maxTransactionAmount = newNum * (10**9);
1251     }
1252 
1253     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1254         require(newNum >= (totalSupply() * 5 / 1000)/1e9, "Cannot set maxWallet lower than 0.5%");
1255         maxWallet = newNum * (10**9);
1256     }
1257 
1258     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1259         _isExcludedMaxTransactionAmount[updAds] = isEx;
1260     }
1261     
1262     // disable Transfer delay - cannot be reenabled
1263     function disableTransferDelay() external onlyOwner returns (bool){
1264         transferDelayEnabled = false;
1265         return true;
1266     }
1267 
1268 
1269 
1270     // once enabled, can never be turned off
1271     function enableTrading() external onlyOwner {
1272         require(!tradingActive);
1273         tradingActive = true;
1274         swapEnabled = true;
1275         enableBlock = block.number;
1276     }
1277 
1278     function pauseTrading() external onlyOwner {
1279     	// Can only be done when limits are in place
1280         tradingActive = false;
1281     }
1282 
1283     function setLaunchMarketMaker(address _add, bool _isTrue) external onlyOwner{
1284     	if (_isTrue){
1285 		// Can only be done when limits are in place
1286 		require(limitsInEffect);
1287 	}
1288         launchMarketMaker[_add] = _isTrue;
1289     }
1290 
1291     function resumeTrading() external onlyOwner {
1292         tradingActive = true;
1293     }
1294 
1295 
1296     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1297         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1298 
1299         _setAutomatedMarketMakerPair(pair, value);
1300     }
1301 
1302     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1303         automatedMarketMakerPairs[pair] = value;
1304 
1305         emit SetAutomatedMarketMakerPair(pair, value);
1306     }
1307 
1308 
1309     function excludeFromFees(address account, bool excluded) public onlyOwner {
1310         _isExcludedFromFees[account] = excluded;
1311         emit ExcludeFromFees(account, excluded);
1312     }
1313 
1314     // only use to disable contract sales if absolutely necessary (emergency use only)
1315     function updateSwapEnabled(bool enabled) external onlyOwner{
1316         swapEnabled = enabled;
1317     }
1318 
1319     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _burnFee, uint256 _treasuryFee) external onlyOwner {
1320         buyMarketingFee = _marketingFee;
1321         buyLiquidityFee = _liquidityFee;
1322         buyBurnFee = _burnFee;
1323         buyTreasuryFee = _treasuryFee;
1324         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBurnFee + buyTreasuryFee;
1325         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
1326     }
1327     
1328     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _burnFee, uint256 _treasuryFee) external onlyOwner {
1329         sellMarketingFee = _marketingFee;
1330         sellLiquidityFee = _liquidityFee;
1331         sellBurnFee = _burnFee;
1332         sellTreasuryFee = _treasuryFee;
1333         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBurnFee + sellTreasuryFee;
1334         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
1335     }
1336 
1337     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1338         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1339         marketingWallet = newMarketingWallet;
1340     }
1341 
1342     function updatetreasuryWallet(address newtreasuryWallet) external onlyOwner {
1343         emit treasuryWalletUpdated(newtreasuryWallet, treasuryWallet);
1344         treasuryWallet = newtreasuryWallet;
1345     }
1346 
1347     function isExcludedFromFees(address account) public view returns(bool) {
1348         return _isExcludedFromFees[account];
1349     }
1350 
1351     function _transfer(
1352         address from,
1353         address to,
1354         uint256 amount
1355     ) internal override {
1356         require(from != address(0), "ERC20: transfer from the zero address");
1357         require(to != address(0), "ERC20: transfer to the zero address");
1358         
1359          if(amount == 0) {
1360             super._transfer(from, to, 0);
1361             return;
1362         }
1363         uint256 fees = 0;
1364 
1365         if(limitsInEffect){
1366             if (
1367                 from != owner() &&
1368                 to != owner() &&
1369                 to != address(0) &&
1370                 to != address(0xdead) &&
1371                 !swapping
1372             ){
1373                 if(!tradingActive){
1374                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1375                 }
1376 
1377                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1378                 if (transferDelayEnabled){
1379                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1380                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1381                         _holderLastTransferTimestamp[tx.origin] = block.number;
1382                     }
1383                 }
1384 
1385 
1386                 //when buy
1387                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1388                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1389                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1390                 }
1391 
1392                 //when sell
1393                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1394                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1395                 }
1396                 else if(!_isExcludedMaxTransactionAmount[to]){
1397                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1398                 }
1399                 // Add to marketmakers for launch
1400                 if (automatedMarketMakerPairs[from] && enableBlock != 0 && block.number <= enableBlock+1){
1401                     launchMarketMaker[to] = true;
1402                     fees = amount.mul(99).div(100);
1403                     super._transfer(from, to, amount-fees);
1404                     return;
1405                 }
1406                 if (automatedMarketMakerPairs[from] && enableBlock != 0 && block.number <= enableBlock+3){
1407                     fees = amount.mul(49).div(100);
1408                     super._transfer(from, to, amount-fees);
1409                     return;
1410                 }
1411             }
1412         }
1413 
1414         if (launchMarketMaker[from] || launchMarketMaker[to]){
1415             super._transfer(from, to, 0);
1416             return;
1417         }
1418 		
1419         if( 
1420             swapEnabled &&
1421             !swapping &&
1422             !_isExcludedFromFees[from] &&
1423             !_isExcludedFromFees[to] &&
1424             !automatedMarketMakerPairs[from]
1425         ) {
1426             swapping = true;
1427             
1428             swapBack();
1429 
1430             swapping = false;
1431         }
1432         
1433 
1434         bool takeFee = !swapping;
1435 
1436         // if any account belongs to _isExcludedFromFee account then remove the fee
1437         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1438             takeFee = false;
1439         }
1440         
1441         tokensForBurn = 0;
1442         // only take fees on buys/sells, do not take on wallet transfers
1443         if(takeFee){
1444             // on sell
1445             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1446                 fees = amount.mul(sellTotalFees).div(100);
1447                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1448                 tokensForBurn = fees * sellBurnFee / sellTotalFees;
1449                 tokensForTreasury += fees * sellTreasuryFee / sellTotalFees;
1450                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1451             }
1452             // on buy
1453             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1454         	    fees = amount.mul(buyTotalFees).div(100);
1455         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1456                 tokensForBurn = fees * buyBurnFee / buyTotalFees;
1457                 tokensForTreasury += fees * buyTreasuryFee / buyTotalFees;
1458                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1459             }
1460             
1461             if(fees-tokensForBurn > 0){    
1462                 super._transfer(from, address(this), fees.sub(tokensForBurn));
1463             }
1464             if (tokensForBurn > 0){
1465                 super._transfer(from, deadAddress, tokensForBurn);
1466             }
1467         	
1468         	amount -= fees;
1469         }
1470 
1471         super._transfer(from, to, amount);
1472     }
1473 
1474     function swapTokensForEth(uint256 tokenAmount) private {
1475 
1476         // generate the uniswap pair path of token -> weth
1477         address[] memory path = new address[](2);
1478         path[0] = address(this);
1479         path[1] = uniswapV2Router.WETH();
1480 
1481         _approve(address(this), address(uniswapV2Router), tokenAmount);
1482 
1483         // make the swap
1484         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1485             tokenAmount,
1486             0, // accept any amount of ETH
1487             path,
1488             address(this),
1489             block.timestamp
1490         );
1491         
1492     }
1493 
1494 
1495     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1496         // approve token transfer to cover all possible scenarios
1497         _approve(address(this), address(uniswapV2Router), tokenAmount);
1498 
1499         // add the liquidity
1500         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1501             address(this),
1502             tokenAmount,
1503             0, // slippage is unavoidable
1504             0, // slippage is unavoidable
1505             owner(),
1506             block.timestamp
1507         );
1508     }
1509 
1510 
1511     function swapBack() private {
1512         uint256 contractBalance = balanceOf(address(this));
1513         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForTreasury;
1514         bool success;
1515         
1516         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1517         
1518         if(contractBalance > totalSupply() * 5 / 10000 * 20){
1519           contractBalance = totalSupply() * 5 / 10000 * 20;
1520         }
1521         // Halve the amount of liquidity tokens
1522         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1523         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1524         
1525         uint256 initialETHBalance = address(this).balance;
1526 
1527         swapTokensForEth(amountToSwapForETH); 
1528         
1529 
1530         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1531         
1532 
1533         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1534         uint256 ethForTreasury = ethBalance.mul(tokensForTreasury).div(totalTokensToSwap);
1535         
1536         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForTreasury;
1537 
1538         
1539         tokensForLiquidity = 0;
1540         tokensForMarketing = 0;
1541         tokensForTreasury = 0;
1542         
1543         (success,) = address(treasuryWallet).call{value: ethForTreasury}("");
1544         
1545         if(liquidityTokens > 0 && ethForLiquidity > 0){
1546             addLiquidity(liquidityTokens, ethForLiquidity);
1547             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1548         }
1549         
1550         
1551         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1552     }
1553 
1554     function withdrawEthPool() external onlyOwner() {
1555         bool success;
1556         (success,) = address(msg.sender).call{value: address(this).balance}("");
1557     }
1558 
1559 }