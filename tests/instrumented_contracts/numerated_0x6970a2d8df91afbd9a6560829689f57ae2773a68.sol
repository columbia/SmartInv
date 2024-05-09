1 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
2 
3 
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
223 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
224 
225 
226 
227 pragma solidity ^0.8.0;
228 
229 /**
230  * @dev Contract module that helps prevent reentrant calls to a function.
231  *
232  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
233  * available, which can be applied to functions to make sure there are no nested
234  * (reentrant) calls to them.
235  *
236  * Note that because there is a single `nonReentrant` guard, functions marked as
237  * `nonReentrant` may not call one another. This can be worked around by making
238  * those functions `private`, and then adding `external` `nonReentrant` entry
239  * points to them.
240  *
241  * TIP: If you would like to learn more about reentrancy and alternative ways
242  * to protect against it, check out our blog post
243  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
244  */
245 abstract contract ReentrancyGuard {
246     // Booleans are more expensive than uint256 or any type that takes up a full
247     // word because each write operation emits an extra SLOAD to first read the
248     // slot's contents, replace the bits taken up by the boolean, and then write
249     // back. This is the compiler's defense against contract upgrades and
250     // pointer aliasing, and it cannot be disabled.
251 
252     // The values being non-zero value makes deployment a bit more expensive,
253     // but in exchange the refund on every call to nonReentrant will be lower in
254     // amount. Since refunds are capped to a percentage of the total
255     // transaction's gas, it is best to keep them low in cases like this one, to
256     // increase the likelihood of the full refund coming into effect.
257     uint256 private constant _NOT_ENTERED = 1;
258     uint256 private constant _ENTERED = 2;
259 
260     uint256 private _status;
261 
262     constructor() {
263         _status = _NOT_ENTERED;
264     }
265 
266     /**
267      * @dev Prevents a contract from calling itself, directly or indirectly.
268      * Calling a `nonReentrant` function from another `nonReentrant`
269      * function is not supported. It is possible to prevent this from happening
270      * by making the `nonReentrant` function external, and make it call a
271      * `private` function that does the actual work.
272      */
273     modifier nonReentrant() {
274         // On the first call to nonReentrant, _notEntered will be true
275         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
276 
277         // Any calls to nonReentrant after this point will fail
278         _status = _ENTERED;
279 
280         _;
281 
282         // By storing the original value once again, a refund is triggered (see
283         // https://eips.ethereum.org/EIPS/eip-2200)
284         _status = _NOT_ENTERED;
285     }
286 }
287 
288 // File: @chainlink/contracts/src/v0.8/VRFRequestIDBase.sol
289 
290 
291 pragma solidity ^0.8.0;
292 
293 contract VRFRequestIDBase {
294 
295   /**
296    * @notice returns the seed which is actually input to the VRF coordinator
297    *
298    * @dev To prevent repetition of VRF output due to repetition of the
299    * @dev user-supplied seed, that seed is combined in a hash with the
300    * @dev user-specific nonce, and the address of the consuming contract. The
301    * @dev risk of repetition is mostly mitigated by inclusion of a blockhash in
302    * @dev the final seed, but the nonce does protect against repetition in
303    * @dev requests which are included in a single block.
304    *
305    * @param _userSeed VRF seed input provided by user
306    * @param _requester Address of the requesting contract
307    * @param _nonce User-specific nonce at the time of the request
308    */
309   function makeVRFInputSeed(
310     bytes32 _keyHash,
311     uint256 _userSeed,
312     address _requester,
313     uint256 _nonce
314   )
315     internal
316     pure
317     returns (
318       uint256
319     )
320   {
321     return uint256(keccak256(abi.encode(_keyHash, _userSeed, _requester, _nonce)));
322   }
323 
324   /**
325    * @notice Returns the id for this request
326    * @param _keyHash The serviceAgreement ID to be used for this request
327    * @param _vRFInputSeed The seed to be passed directly to the VRF
328    * @return The id for this request
329    *
330    * @dev Note that _vRFInputSeed is not the seed passed by the consuming
331    * @dev contract, but the one generated by makeVRFInputSeed
332    */
333   function makeRequestId(
334     bytes32 _keyHash,
335     uint256 _vRFInputSeed
336   )
337     internal
338     pure
339     returns (
340       bytes32
341     )
342   {
343     return keccak256(abi.encodePacked(_keyHash, _vRFInputSeed));
344   }
345 }
346 // File: @chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol
347 
348 
349 pragma solidity ^0.8.0;
350 
351 interface LinkTokenInterface {
352 
353   function allowance(
354     address owner,
355     address spender
356   )
357     external
358     view
359     returns (
360       uint256 remaining
361     );
362 
363   function approve(
364     address spender,
365     uint256 value
366   )
367     external
368     returns (
369       bool success
370     );
371 
372   function balanceOf(
373     address owner
374   )
375     external
376     view
377     returns (
378       uint256 balance
379     );
380 
381   function decimals()
382     external
383     view
384     returns (
385       uint8 decimalPlaces
386     );
387 
388   function decreaseApproval(
389     address spender,
390     uint256 addedValue
391   )
392     external
393     returns (
394       bool success
395     );
396 
397   function increaseApproval(
398     address spender,
399     uint256 subtractedValue
400   ) external;
401 
402   function name()
403     external
404     view
405     returns (
406       string memory tokenName
407     );
408 
409   function symbol()
410     external
411     view
412     returns (
413       string memory tokenSymbol
414     );
415 
416   function totalSupply()
417     external
418     view
419     returns (
420       uint256 totalTokensIssued
421     );
422 
423   function transfer(
424     address to,
425     uint256 value
426   )
427     external
428     returns (
429       bool success
430     );
431 
432   function transferAndCall(
433     address to,
434     uint256 value,
435     bytes calldata data
436   )
437     external
438     returns (
439       bool success
440     );
441 
442   function transferFrom(
443     address from,
444     address to,
445     uint256 value
446   )
447     external
448     returns (
449       bool success
450     );
451 
452 }
453 
454 // File: @chainlink/contracts/src/v0.8/VRFConsumerBase.sol
455 
456 
457 pragma solidity ^0.8.0;
458 
459 
460 
461 /** ****************************************************************************
462  * @notice Interface for contracts using VRF randomness
463  * *****************************************************************************
464  * @dev PURPOSE
465  *
466  * @dev Reggie the Random Oracle (not his real job) wants to provide randomness
467  * @dev to Vera the verifier in such a way that Vera can be sure he's not
468  * @dev making his output up to suit himself. Reggie provides Vera a public key
469  * @dev to which he knows the secret key. Each time Vera provides a seed to
470  * @dev Reggie, he gives back a value which is computed completely
471  * @dev deterministically from the seed and the secret key.
472  *
473  * @dev Reggie provides a proof by which Vera can verify that the output was
474  * @dev correctly computed once Reggie tells it to her, but without that proof,
475  * @dev the output is indistinguishable to her from a uniform random sample
476  * @dev from the output space.
477  *
478  * @dev The purpose of this contract is to make it easy for unrelated contracts
479  * @dev to talk to Vera the verifier about the work Reggie is doing, to provide
480  * @dev simple access to a verifiable source of randomness.
481  * *****************************************************************************
482  * @dev USAGE
483  *
484  * @dev Calling contracts must inherit from VRFConsumerBase, and can
485  * @dev initialize VRFConsumerBase's attributes in their constructor as
486  * @dev shown:
487  *
488  * @dev   contract VRFConsumer {
489  * @dev     constuctor(<other arguments>, address _vrfCoordinator, address _link)
490  * @dev       VRFConsumerBase(_vrfCoordinator, _link) public {
491  * @dev         <initialization with other arguments goes here>
492  * @dev       }
493  * @dev   }
494  *
495  * @dev The oracle will have given you an ID for the VRF keypair they have
496  * @dev committed to (let's call it keyHash), and have told you the minimum LINK
497  * @dev price for VRF service. Make sure your contract has sufficient LINK, and
498  * @dev call requestRandomness(keyHash, fee, seed), where seed is the input you
499  * @dev want to generate randomness from.
500  *
501  * @dev Once the VRFCoordinator has received and validated the oracle's response
502  * @dev to your request, it will call your contract's fulfillRandomness method.
503  *
504  * @dev The randomness argument to fulfillRandomness is the actual random value
505  * @dev generated from your seed.
506  *
507  * @dev The requestId argument is generated from the keyHash and the seed by
508  * @dev makeRequestId(keyHash, seed). If your contract could have concurrent
509  * @dev requests open, you can use the requestId to track which seed is
510  * @dev associated with which randomness. See VRFRequestIDBase.sol for more
511  * @dev details. (See "SECURITY CONSIDERATIONS" for principles to keep in mind,
512  * @dev if your contract could have multiple requests in flight simultaneously.)
513  *
514  * @dev Colliding `requestId`s are cryptographically impossible as long as seeds
515  * @dev differ. (Which is critical to making unpredictable randomness! See the
516  * @dev next section.)
517  *
518  * *****************************************************************************
519  * @dev SECURITY CONSIDERATIONS
520  *
521  * @dev A method with the ability to call your fulfillRandomness method directly
522  * @dev could spoof a VRF response with any random value, so it's critical that
523  * @dev it cannot be directly called by anything other than this base contract
524  * @dev (specifically, by the VRFConsumerBase.rawFulfillRandomness method).
525  *
526  * @dev For your users to trust that your contract's random behavior is free
527  * @dev from malicious interference, it's best if you can write it so that all
528  * @dev behaviors implied by a VRF response are executed *during* your
529  * @dev fulfillRandomness method. If your contract must store the response (or
530  * @dev anything derived from it) and use it later, you must ensure that any
531  * @dev user-significant behavior which depends on that stored value cannot be
532  * @dev manipulated by a subsequent VRF request.
533  *
534  * @dev Similarly, both miners and the VRF oracle itself have some influence
535  * @dev over the order in which VRF responses appear on the blockchain, so if
536  * @dev your contract could have multiple VRF requests in flight simultaneously,
537  * @dev you must ensure that the order in which the VRF responses arrive cannot
538  * @dev be used to manipulate your contract's user-significant behavior.
539  *
540  * @dev Since the ultimate input to the VRF is mixed with the block hash of the
541  * @dev block in which the request is made, user-provided seeds have no impact
542  * @dev on its economic security properties. They are only included for API
543  * @dev compatability with previous versions of this contract.
544  *
545  * @dev Since the block hash of the block which contains the requestRandomness
546  * @dev call is mixed into the input to the VRF *last*, a sufficiently powerful
547  * @dev miner could, in principle, fork the blockchain to evict the block
548  * @dev containing the request, forcing the request to be included in a
549  * @dev different block with a different hash, and therefore a different input
550  * @dev to the VRF. However, such an attack would incur a substantial economic
551  * @dev cost. This cost scales with the number of blocks the VRF oracle waits
552  * @dev until it calls responds to a request.
553  */
554 abstract contract VRFConsumerBase is VRFRequestIDBase {
555 
556   /**
557    * @notice fulfillRandomness handles the VRF response. Your contract must
558    * @notice implement it. See "SECURITY CONSIDERATIONS" above for important
559    * @notice principles to keep in mind when implementing your fulfillRandomness
560    * @notice method.
561    *
562    * @dev VRFConsumerBase expects its subcontracts to have a method with this
563    * @dev signature, and will call it once it has verified the proof
564    * @dev associated with the randomness. (It is triggered via a call to
565    * @dev rawFulfillRandomness, below.)
566    *
567    * @param requestId The Id initially returned by requestRandomness
568    * @param randomness the VRF output
569    */
570   function fulfillRandomness(
571     bytes32 requestId,
572     uint256 randomness
573   )
574     internal
575     virtual;
576 
577   /**
578    * @dev In order to keep backwards compatibility we have kept the user
579    * seed field around. We remove the use of it because given that the blockhash
580    * enters later, it overrides whatever randomness the used seed provides.
581    * Given that it adds no security, and can easily lead to misunderstandings,
582    * we have removed it from usage and can now provide a simpler API.
583    */
584   uint256 constant private USER_SEED_PLACEHOLDER = 0;
585 
586   /**
587    * @notice requestRandomness initiates a request for VRF output given _seed
588    *
589    * @dev The fulfillRandomness method receives the output, once it's provided
590    * @dev by the Oracle, and verified by the vrfCoordinator.
591    *
592    * @dev The _keyHash must already be registered with the VRFCoordinator, and
593    * @dev the _fee must exceed the fee specified during registration of the
594    * @dev _keyHash.
595    *
596    * @dev The _seed parameter is vestigial, and is kept only for API
597    * @dev compatibility with older versions. It can't *hurt* to mix in some of
598    * @dev your own randomness, here, but it's not necessary because the VRF
599    * @dev oracle will mix the hash of the block containing your request into the
600    * @dev VRF seed it ultimately uses.
601    *
602    * @param _keyHash ID of public key against which randomness is generated
603    * @param _fee The amount of LINK to send with the request
604    *
605    * @return requestId unique ID for this request
606    *
607    * @dev The returned requestId can be used to distinguish responses to
608    * @dev concurrent requests. It is passed as the first argument to
609    * @dev fulfillRandomness.
610    */
611   function requestRandomness(
612     bytes32 _keyHash,
613     uint256 _fee
614   )
615     internal
616     returns (
617       bytes32 requestId
618     )
619   {
620     LINK.transferAndCall(vrfCoordinator, _fee, abi.encode(_keyHash, USER_SEED_PLACEHOLDER));
621     // This is the seed passed to VRFCoordinator. The oracle will mix this with
622     // the hash of the block containing this request to obtain the seed/input
623     // which is finally passed to the VRF cryptographic machinery.
624     uint256 vRFSeed  = makeVRFInputSeed(_keyHash, USER_SEED_PLACEHOLDER, address(this), nonces[_keyHash]);
625     // nonces[_keyHash] must stay in sync with
626     // VRFCoordinator.nonces[_keyHash][this], which was incremented by the above
627     // successful LINK.transferAndCall (in VRFCoordinator.randomnessRequest).
628     // This provides protection against the user repeating their input seed,
629     // which would result in a predictable/duplicate output, if multiple such
630     // requests appeared in the same block.
631     nonces[_keyHash] = nonces[_keyHash] + 1;
632     return makeRequestId(_keyHash, vRFSeed);
633   }
634 
635   LinkTokenInterface immutable internal LINK;
636   address immutable private vrfCoordinator;
637 
638   // Nonces for each VRF key from which randomness has been requested.
639   //
640   // Must stay in sync with VRFCoordinator[_keyHash][this]
641   mapping(bytes32 /* keyHash */ => uint256 /* nonce */) private nonces;
642 
643   /**
644    * @param _vrfCoordinator address of VRFCoordinator contract
645    * @param _link address of LINK token contract
646    *
647    * @dev https://docs.chain.link/docs/link-token-contracts
648    */
649   constructor(
650     address _vrfCoordinator,
651     address _link
652   ) {
653     vrfCoordinator = _vrfCoordinator;
654     LINK = LinkTokenInterface(_link);
655   }
656 
657   // rawFulfillRandomness is called by VRFCoordinator when it receives a valid VRF
658   // proof. rawFulfillRandomness then calls fulfillRandomness, after validating
659   // the origin of the call
660   function rawFulfillRandomness(
661     bytes32 requestId,
662     uint256 randomness
663   )
664     external
665   {
666     require(msg.sender == vrfCoordinator, "Only VRFCoordinator can fulfill");
667     fulfillRandomness(requestId, randomness);
668   }
669 }
670 
671 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
672 
673 
674 
675 pragma solidity ^0.8.0;
676 
677 // CAUTION
678 // This version of SafeMath should only be used with Solidity 0.8 or later,
679 // because it relies on the compiler's built in overflow checks.
680 
681 /**
682  * @dev Wrappers over Solidity's arithmetic operations.
683  *
684  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
685  * now has built in overflow checking.
686  */
687 library SafeMath {
688     /**
689      * @dev Returns the addition of two unsigned integers, with an overflow flag.
690      *
691      * _Available since v3.4._
692      */
693     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
694         unchecked {
695             uint256 c = a + b;
696             if (c < a) return (false, 0);
697             return (true, c);
698         }
699     }
700 
701     /**
702      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
703      *
704      * _Available since v3.4._
705      */
706     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
707         unchecked {
708             if (b > a) return (false, 0);
709             return (true, a - b);
710         }
711     }
712 
713     /**
714      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
715      *
716      * _Available since v3.4._
717      */
718     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
719         unchecked {
720             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
721             // benefit is lost if 'b' is also tested.
722             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
723             if (a == 0) return (true, 0);
724             uint256 c = a * b;
725             if (c / a != b) return (false, 0);
726             return (true, c);
727         }
728     }
729 
730     /**
731      * @dev Returns the division of two unsigned integers, with a division by zero flag.
732      *
733      * _Available since v3.4._
734      */
735     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
736         unchecked {
737             if (b == 0) return (false, 0);
738             return (true, a / b);
739         }
740     }
741 
742     /**
743      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
744      *
745      * _Available since v3.4._
746      */
747     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
748         unchecked {
749             if (b == 0) return (false, 0);
750             return (true, a % b);
751         }
752     }
753 
754     /**
755      * @dev Returns the addition of two unsigned integers, reverting on
756      * overflow.
757      *
758      * Counterpart to Solidity's `+` operator.
759      *
760      * Requirements:
761      *
762      * - Addition cannot overflow.
763      */
764     function add(uint256 a, uint256 b) internal pure returns (uint256) {
765         return a + b;
766     }
767 
768     /**
769      * @dev Returns the subtraction of two unsigned integers, reverting on
770      * overflow (when the result is negative).
771      *
772      * Counterpart to Solidity's `-` operator.
773      *
774      * Requirements:
775      *
776      * - Subtraction cannot overflow.
777      */
778     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
779         return a - b;
780     }
781 
782     /**
783      * @dev Returns the multiplication of two unsigned integers, reverting on
784      * overflow.
785      *
786      * Counterpart to Solidity's `*` operator.
787      *
788      * Requirements:
789      *
790      * - Multiplication cannot overflow.
791      */
792     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
793         return a * b;
794     }
795 
796     /**
797      * @dev Returns the integer division of two unsigned integers, reverting on
798      * division by zero. The result is rounded towards zero.
799      *
800      * Counterpart to Solidity's `/` operator.
801      *
802      * Requirements:
803      *
804      * - The divisor cannot be zero.
805      */
806     function div(uint256 a, uint256 b) internal pure returns (uint256) {
807         return a / b;
808     }
809 
810     /**
811      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
812      * reverting when dividing by zero.
813      *
814      * Counterpart to Solidity's `%` operator. This function uses a `revert`
815      * opcode (which leaves remaining gas untouched) while Solidity uses an
816      * invalid opcode to revert (consuming all remaining gas).
817      *
818      * Requirements:
819      *
820      * - The divisor cannot be zero.
821      */
822     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
823         return a % b;
824     }
825 
826     /**
827      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
828      * overflow (when the result is negative).
829      *
830      * CAUTION: This function is deprecated because it requires allocating memory for the error
831      * message unnecessarily. For custom revert reasons use {trySub}.
832      *
833      * Counterpart to Solidity's `-` operator.
834      *
835      * Requirements:
836      *
837      * - Subtraction cannot overflow.
838      */
839     function sub(
840         uint256 a,
841         uint256 b,
842         string memory errorMessage
843     ) internal pure returns (uint256) {
844         unchecked {
845             require(b <= a, errorMessage);
846             return a - b;
847         }
848     }
849 
850     /**
851      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
852      * division by zero. The result is rounded towards zero.
853      *
854      * Counterpart to Solidity's `/` operator. Note: this function uses a
855      * `revert` opcode (which leaves remaining gas untouched) while Solidity
856      * uses an invalid opcode to revert (consuming all remaining gas).
857      *
858      * Requirements:
859      *
860      * - The divisor cannot be zero.
861      */
862     function div(
863         uint256 a,
864         uint256 b,
865         string memory errorMessage
866     ) internal pure returns (uint256) {
867         unchecked {
868             require(b > 0, errorMessage);
869             return a / b;
870         }
871     }
872 
873     /**
874      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
875      * reverting with custom message when dividing by zero.
876      *
877      * CAUTION: This function is deprecated because it requires allocating memory for the error
878      * message unnecessarily. For custom revert reasons use {tryMod}.
879      *
880      * Counterpart to Solidity's `%` operator. This function uses a `revert`
881      * opcode (which leaves remaining gas untouched) while Solidity uses an
882      * invalid opcode to revert (consuming all remaining gas).
883      *
884      * Requirements:
885      *
886      * - The divisor cannot be zero.
887      */
888     function mod(
889         uint256 a,
890         uint256 b,
891         string memory errorMessage
892     ) internal pure returns (uint256) {
893         unchecked {
894             require(b > 0, errorMessage);
895             return a % b;
896         }
897     }
898 }
899 
900 // File: @openzeppelin/contracts/utils/Strings.sol
901 
902 
903 
904 pragma solidity ^0.8.0;
905 
906 /**
907  * @dev String operations.
908  */
909 library Strings {
910     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
911 
912     /**
913      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
914      */
915     function toString(uint256 value) internal pure returns (string memory) {
916         // Inspired by OraclizeAPI's implementation - MIT licence
917         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
918 
919         if (value == 0) {
920             return "0";
921         }
922         uint256 temp = value;
923         uint256 digits;
924         while (temp != 0) {
925             digits++;
926             temp /= 10;
927         }
928         bytes memory buffer = new bytes(digits);
929         while (value != 0) {
930             digits -= 1;
931             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
932             value /= 10;
933         }
934         return string(buffer);
935     }
936 
937     /**
938      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
939      */
940     function toHexString(uint256 value) internal pure returns (string memory) {
941         if (value == 0) {
942             return "0x00";
943         }
944         uint256 temp = value;
945         uint256 length = 0;
946         while (temp != 0) {
947             length++;
948             temp >>= 8;
949         }
950         return toHexString(value, length);
951     }
952 
953     /**
954      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
955      */
956     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
957         bytes memory buffer = new bytes(2 * length + 2);
958         buffer[0] = "0";
959         buffer[1] = "x";
960         for (uint256 i = 2 * length + 1; i > 1; --i) {
961             buffer[i] = _HEX_SYMBOLS[value & 0xf];
962             value >>= 4;
963         }
964         require(value == 0, "Strings: hex length insufficient");
965         return string(buffer);
966     }
967 }
968 
969 // File: @openzeppelin/contracts/utils/Context.sol
970 
971 
972 
973 pragma solidity ^0.8.0;
974 
975 /**
976  * @dev Provides information about the current execution context, including the
977  * sender of the transaction and its data. While these are generally available
978  * via msg.sender and msg.data, they should not be accessed in such a direct
979  * manner, since when dealing with meta-transactions the account sending and
980  * paying for execution may not be the actual sender (as far as an application
981  * is concerned).
982  *
983  * This contract is only required for intermediate, library-like contracts.
984  */
985 abstract contract Context {
986     function _msgSender() internal view virtual returns (address) {
987         return msg.sender;
988     }
989 
990     function _msgData() internal view virtual returns (bytes calldata) {
991         return msg.data;
992     }
993 }
994 
995 // File: @openzeppelin/contracts/access/Ownable.sol
996 
997 
998 
999 pragma solidity ^0.8.0;
1000 
1001 
1002 /**
1003  * @dev Contract module which provides a basic access control mechanism, where
1004  * there is an account (an owner) that can be granted exclusive access to
1005  * specific functions.
1006  *
1007  * By default, the owner account will be the one that deploys the contract. This
1008  * can later be changed with {transferOwnership}.
1009  *
1010  * This module is used through inheritance. It will make available the modifier
1011  * `onlyOwner`, which can be applied to your functions to restrict their use to
1012  * the owner.
1013  */
1014 abstract contract Ownable is Context {
1015     address private _owner;
1016 
1017     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1018 
1019     /**
1020      * @dev Initializes the contract setting the deployer as the initial owner.
1021      */
1022     constructor() {
1023         _setOwner(_msgSender());
1024     }
1025 
1026     /**
1027      * @dev Returns the address of the current owner.
1028      */
1029     function owner() public view virtual returns (address) {
1030         return _owner;
1031     }
1032 
1033     /**
1034      * @dev Throws if called by any account other than the owner.
1035      */
1036     modifier onlyOwner() {
1037         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1038         _;
1039     }
1040 
1041     /**
1042      * @dev Leaves the contract without owner. It will not be possible to call
1043      * `onlyOwner` functions anymore. Can only be called by the current owner.
1044      *
1045      * NOTE: Renouncing ownership will leave the contract without an owner,
1046      * thereby removing any functionality that is only available to the owner.
1047      */
1048     function renounceOwnership() public virtual onlyOwner {
1049         _setOwner(address(0));
1050     }
1051 
1052     /**
1053      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1054      * Can only be called by the current owner.
1055      */
1056     function transferOwnership(address newOwner) public virtual onlyOwner {
1057         require(newOwner != address(0), "Ownable: new owner is the zero address");
1058         _setOwner(newOwner);
1059     }
1060 
1061     function _setOwner(address newOwner) private {
1062         address oldOwner = _owner;
1063         _owner = newOwner;
1064         emit OwnershipTransferred(oldOwner, newOwner);
1065     }
1066 }
1067 
1068 // File: @openzeppelin/contracts/utils/Address.sol
1069 
1070 
1071 
1072 pragma solidity ^0.8.0;
1073 
1074 /**
1075  * @dev Collection of functions related to the address type
1076  */
1077 library Address {
1078     /**
1079      * @dev Returns true if `account` is a contract.
1080      *
1081      * [IMPORTANT]
1082      * ====
1083      * It is unsafe to assume that an address for which this function returns
1084      * false is an externally-owned account (EOA) and not a contract.
1085      *
1086      * Among others, `isContract` will return false for the following
1087      * types of addresses:
1088      *
1089      *  - an externally-owned account
1090      *  - a contract in construction
1091      *  - an address where a contract will be created
1092      *  - an address where a contract lived, but was destroyed
1093      * ====
1094      */
1095     function isContract(address account) internal view returns (bool) {
1096         // This method relies on extcodesize, which returns 0 for contracts in
1097         // construction, since the code is only stored at the end of the
1098         // constructor execution.
1099 
1100         uint256 size;
1101         assembly {
1102             size := extcodesize(account)
1103         }
1104         return size > 0;
1105     }
1106 
1107     /**
1108      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1109      * `recipient`, forwarding all available gas and reverting on errors.
1110      *
1111      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1112      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1113      * imposed by `transfer`, making them unable to receive funds via
1114      * `transfer`. {sendValue} removes this limitation.
1115      *
1116      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1117      *
1118      * IMPORTANT: because control is transferred to `recipient`, care must be
1119      * taken to not create reentrancy vulnerabilities. Consider using
1120      * {ReentrancyGuard} or the
1121      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1122      */
1123     function sendValue(address payable recipient, uint256 amount) internal {
1124         require(address(this).balance >= amount, "Address: insufficient balance");
1125 
1126         (bool success, ) = recipient.call{value: amount}("");
1127         require(success, "Address: unable to send value, recipient may have reverted");
1128     }
1129 
1130     /**
1131      * @dev Performs a Solidity function call using a low level `call`. A
1132      * plain `call` is an unsafe replacement for a function call: use this
1133      * function instead.
1134      *
1135      * If `target` reverts with a revert reason, it is bubbled up by this
1136      * function (like regular Solidity function calls).
1137      *
1138      * Returns the raw returned data. To convert to the expected return value,
1139      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1140      *
1141      * Requirements:
1142      *
1143      * - `target` must be a contract.
1144      * - calling `target` with `data` must not revert.
1145      *
1146      * _Available since v3.1._
1147      */
1148     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1149         return functionCall(target, data, "Address: low-level call failed");
1150     }
1151 
1152     /**
1153      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1154      * `errorMessage` as a fallback revert reason when `target` reverts.
1155      *
1156      * _Available since v3.1._
1157      */
1158     function functionCall(
1159         address target,
1160         bytes memory data,
1161         string memory errorMessage
1162     ) internal returns (bytes memory) {
1163         return functionCallWithValue(target, data, 0, errorMessage);
1164     }
1165 
1166     /**
1167      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1168      * but also transferring `value` wei to `target`.
1169      *
1170      * Requirements:
1171      *
1172      * - the calling contract must have an ETH balance of at least `value`.
1173      * - the called Solidity function must be `payable`.
1174      *
1175      * _Available since v3.1._
1176      */
1177     function functionCallWithValue(
1178         address target,
1179         bytes memory data,
1180         uint256 value
1181     ) internal returns (bytes memory) {
1182         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1183     }
1184 
1185     /**
1186      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1187      * with `errorMessage` as a fallback revert reason when `target` reverts.
1188      *
1189      * _Available since v3.1._
1190      */
1191     function functionCallWithValue(
1192         address target,
1193         bytes memory data,
1194         uint256 value,
1195         string memory errorMessage
1196     ) internal returns (bytes memory) {
1197         require(address(this).balance >= value, "Address: insufficient balance for call");
1198         require(isContract(target), "Address: call to non-contract");
1199 
1200         (bool success, bytes memory returndata) = target.call{value: value}(data);
1201         return verifyCallResult(success, returndata, errorMessage);
1202     }
1203 
1204     /**
1205      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1206      * but performing a static call.
1207      *
1208      * _Available since v3.3._
1209      */
1210     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1211         return functionStaticCall(target, data, "Address: low-level static call failed");
1212     }
1213 
1214     /**
1215      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1216      * but performing a static call.
1217      *
1218      * _Available since v3.3._
1219      */
1220     function functionStaticCall(
1221         address target,
1222         bytes memory data,
1223         string memory errorMessage
1224     ) internal view returns (bytes memory) {
1225         require(isContract(target), "Address: static call to non-contract");
1226 
1227         (bool success, bytes memory returndata) = target.staticcall(data);
1228         return verifyCallResult(success, returndata, errorMessage);
1229     }
1230 
1231     /**
1232      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1233      * but performing a delegate call.
1234      *
1235      * _Available since v3.4._
1236      */
1237     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1238         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1239     }
1240 
1241     /**
1242      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1243      * but performing a delegate call.
1244      *
1245      * _Available since v3.4._
1246      */
1247     function functionDelegateCall(
1248         address target,
1249         bytes memory data,
1250         string memory errorMessage
1251     ) internal returns (bytes memory) {
1252         require(isContract(target), "Address: delegate call to non-contract");
1253 
1254         (bool success, bytes memory returndata) = target.delegatecall(data);
1255         return verifyCallResult(success, returndata, errorMessage);
1256     }
1257 
1258     /**
1259      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1260      * revert reason using the provided one.
1261      *
1262      * _Available since v4.3._
1263      */
1264     function verifyCallResult(
1265         bool success,
1266         bytes memory returndata,
1267         string memory errorMessage
1268     ) internal pure returns (bytes memory) {
1269         if (success) {
1270             return returndata;
1271         } else {
1272             // Look for revert reason and bubble it up if present
1273             if (returndata.length > 0) {
1274                 // The easiest way to bubble the revert reason is using memory via assembly
1275 
1276                 assembly {
1277                     let returndata_size := mload(returndata)
1278                     revert(add(32, returndata), returndata_size)
1279                 }
1280             } else {
1281                 revert(errorMessage);
1282             }
1283         }
1284     }
1285 }
1286 
1287 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1288 
1289 
1290 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
1291 
1292 pragma solidity ^0.8.0;
1293 
1294 /**
1295  * @title ERC721 token receiver interface
1296  * @dev Interface for any contract that wants to support safeTransfers
1297  * from ERC721 asset contracts.
1298  */
1299 interface IERC721Receiver {
1300     /**
1301      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1302      * by `operator` from `from`, this function is called.
1303      *
1304      * It must return its Solidity selector to confirm the token transfer.
1305      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1306      *
1307      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1308      */
1309     function onERC721Received(
1310         address operator,
1311         address from,
1312         uint256 tokenId,
1313         bytes calldata data
1314     ) external returns (bytes4);
1315 }
1316 
1317 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1318 
1319 
1320 
1321 pragma solidity ^0.8.0;
1322 
1323 /**
1324  * @dev Interface of the ERC165 standard, as defined in the
1325  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1326  *
1327  * Implementers can declare support of contract interfaces, which can then be
1328  * queried by others ({ERC165Checker}).
1329  *
1330  * For an implementation, see {ERC165}.
1331  */
1332 interface IERC165 {
1333     /**
1334      * @dev Returns true if this contract implements the interface defined by
1335      * `interfaceId`. See the corresponding
1336      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1337      * to learn more about how these ids are created.
1338      *
1339      * This function call must use less than 30 000 gas.
1340      */
1341     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1342 }
1343 
1344 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1345 
1346 
1347 
1348 pragma solidity ^0.8.0;
1349 
1350 
1351 /**
1352  * @dev Implementation of the {IERC165} interface.
1353  *
1354  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1355  * for the additional interface id that will be supported. For example:
1356  *
1357  * ```solidity
1358  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1359  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1360  * }
1361  * ```
1362  *
1363  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1364  */
1365 abstract contract ERC165 is IERC165 {
1366     /**
1367      * @dev See {IERC165-supportsInterface}.
1368      */
1369     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1370         return interfaceId == type(IERC165).interfaceId;
1371     }
1372 }
1373 
1374 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1375 
1376 
1377 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
1378 
1379 pragma solidity ^0.8.0;
1380 
1381 
1382 /**
1383  * @dev Required interface of an ERC721 compliant contract.
1384  */
1385 interface IERC721 is IERC165 {
1386     /**
1387      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1388      */
1389     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1390 
1391     /**
1392      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1393      */
1394     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1395 
1396     /**
1397      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1398      */
1399     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1400 
1401     /**
1402      * @dev Returns the number of tokens in ``owner``'s account.
1403      */
1404     function balanceOf(address owner) external view returns (uint256 balance);
1405 
1406     /**
1407      * @dev Returns the owner of the `tokenId` token.
1408      *
1409      * Requirements:
1410      *
1411      * - `tokenId` must exist.
1412      */
1413     function ownerOf(uint256 tokenId) external view returns (address owner);
1414 
1415     /**
1416      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1417      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1418      *
1419      * Requirements:
1420      *
1421      * - `from` cannot be the zero address.
1422      * - `to` cannot be the zero address.
1423      * - `tokenId` token must exist and be owned by `from`.
1424      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1425      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1426      *
1427      * Emits a {Transfer} event.
1428      */
1429     function safeTransferFrom(
1430         address from,
1431         address to,
1432         uint256 tokenId
1433     ) external;
1434 
1435     /**
1436      * @dev Transfers `tokenId` token from `from` to `to`.
1437      *
1438      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1439      *
1440      * Requirements:
1441      *
1442      * - `from` cannot be the zero address.
1443      * - `to` cannot be the zero address.
1444      * - `tokenId` token must be owned by `from`.
1445      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1446      *
1447      * Emits a {Transfer} event.
1448      */
1449     function transferFrom(
1450         address from,
1451         address to,
1452         uint256 tokenId
1453     ) external;
1454 
1455     /**
1456      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1457      * The approval is cleared when the token is transferred.
1458      *
1459      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1460      *
1461      * Requirements:
1462      *
1463      * - The caller must own the token or be an approved operator.
1464      * - `tokenId` must exist.
1465      *
1466      * Emits an {Approval} event.
1467      */
1468     function approve(address to, uint256 tokenId) external;
1469 
1470     /**
1471      * @dev Returns the account approved for `tokenId` token.
1472      *
1473      * Requirements:
1474      *
1475      * - `tokenId` must exist.
1476      */
1477     function getApproved(uint256 tokenId) external view returns (address operator);
1478 
1479     /**
1480      * @dev Approve or remove `operator` as an operator for the caller.
1481      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1482      *
1483      * Requirements:
1484      *
1485      * - The `operator` cannot be the caller.
1486      *
1487      * Emits an {ApprovalForAll} event.
1488      */
1489     function setApprovalForAll(address operator, bool _approved) external;
1490 
1491     /**
1492      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1493      *
1494      * See {setApprovalForAll}
1495      */
1496     function isApprovedForAll(address owner, address operator) external view returns (bool);
1497 
1498     /**
1499      * @dev Safely transfers `tokenId` token from `from` to `to`.
1500      *
1501      * Requirements:
1502      *
1503      * - `from` cannot be the zero address.
1504      * - `to` cannot be the zero address.
1505      * - `tokenId` token must exist and be owned by `from`.
1506      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1507      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1508      *
1509      * Emits a {Transfer} event.
1510      */
1511     function safeTransferFrom(
1512         address from,
1513         address to,
1514         uint256 tokenId,
1515         bytes calldata data
1516     ) external;
1517 }
1518 
1519 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1520 
1521 
1522 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
1523 
1524 pragma solidity ^0.8.0;
1525 
1526 
1527 /**
1528  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1529  * @dev See https://eips.ethereum.org/EIPS/eip-721
1530  */
1531 interface IERC721Metadata is IERC721 {
1532     /**
1533      * @dev Returns the token collection name.
1534      */
1535     function name() external view returns (string memory);
1536 
1537     /**
1538      * @dev Returns the token collection symbol.
1539      */
1540     function symbol() external view returns (string memory);
1541 
1542     /**
1543      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1544      */
1545     function tokenURI(uint256 tokenId) external view returns (string memory);
1546 }
1547 
1548 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1549 
1550 
1551 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
1552 
1553 pragma solidity ^0.8.0;
1554 
1555 
1556 
1557 
1558 
1559 
1560 
1561 
1562 /**
1563  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1564  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1565  * {ERC721Enumerable}.
1566  */
1567 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1568     using Address for address;
1569     using Strings for uint256;
1570 
1571     // Token name
1572     string private _name;
1573 
1574     // Token symbol
1575     string private _symbol;
1576 
1577     // Mapping from token ID to owner address
1578     mapping(uint256 => address) private _owners;
1579 
1580     // Mapping owner address to token count
1581     mapping(address => uint256) private _balances;
1582 
1583     // Mapping from token ID to approved address
1584     mapping(uint256 => address) private _tokenApprovals;
1585 
1586     // Mapping from owner to operator approvals
1587     mapping(address => mapping(address => bool)) private _operatorApprovals;
1588 
1589     /**
1590      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1591      */
1592     constructor(string memory name_, string memory symbol_) {
1593         _name = name_;
1594         _symbol = symbol_;
1595     }
1596 
1597     /**
1598      * @dev See {IERC165-supportsInterface}.
1599      */
1600     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1601         return
1602             interfaceId == type(IERC721).interfaceId ||
1603             interfaceId == type(IERC721Metadata).interfaceId ||
1604             super.supportsInterface(interfaceId);
1605     }
1606 
1607     /**
1608      * @dev See {IERC721-balanceOf}.
1609      */
1610     function balanceOf(address owner) public view virtual override returns (uint256) {
1611         require(owner != address(0), "ERC721: balance query for the zero address");
1612         return _balances[owner];
1613     }
1614 
1615     /**
1616      * @dev See {IERC721-ownerOf}.
1617      */
1618     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1619         address owner = _owners[tokenId];
1620         require(owner != address(0), "ERC721: owner query for nonexistent token");
1621         return owner;
1622     }
1623 
1624     /**
1625      * @dev See {IERC721Metadata-name}.
1626      */
1627     function name() public view virtual override returns (string memory) {
1628         return _name;
1629     }
1630 
1631     /**
1632      * @dev See {IERC721Metadata-symbol}.
1633      */
1634     function symbol() public view virtual override returns (string memory) {
1635         return _symbol;
1636     }
1637 
1638     /**
1639      * @dev See {IERC721Metadata-tokenURI}.
1640      */
1641     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1642         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1643 
1644         string memory baseURI = _baseURI();
1645         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1646     }
1647 
1648     /**
1649      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1650      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1651      * by default, can be overriden in child contracts.
1652      */
1653     function _baseURI() internal view virtual returns (string memory) {
1654         return "";
1655     }
1656 
1657     /**
1658      * @dev See {IERC721-approve}.
1659      */
1660     function approve(address to, uint256 tokenId) public virtual override {
1661         address owner = ERC721.ownerOf(tokenId);
1662         require(to != owner, "ERC721: approval to current owner");
1663 
1664         require(
1665             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1666             "ERC721: approve caller is not owner nor approved for all"
1667         );
1668 
1669         _approve(to, tokenId);
1670     }
1671 
1672     /**
1673      * @dev See {IERC721-getApproved}.
1674      */
1675     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1676         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1677 
1678         return _tokenApprovals[tokenId];
1679     }
1680 
1681     /**
1682      * @dev See {IERC721-setApprovalForAll}.
1683      */
1684     function setApprovalForAll(address operator, bool approved) public virtual override {
1685         _setApprovalForAll(_msgSender(), operator, approved);
1686     }
1687 
1688     /**
1689      * @dev See {IERC721-isApprovedForAll}.
1690      */
1691     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1692         return _operatorApprovals[owner][operator];
1693     }
1694 
1695     /**
1696      * @dev See {IERC721-transferFrom}.
1697      */
1698     function transferFrom(
1699         address from,
1700         address to,
1701         uint256 tokenId
1702     ) public virtual override {
1703         //solhint-disable-next-line max-line-length
1704         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1705 
1706         _transfer(from, to, tokenId);
1707     }
1708 
1709     /**
1710      * @dev See {IERC721-safeTransferFrom}.
1711      */
1712     function safeTransferFrom(
1713         address from,
1714         address to,
1715         uint256 tokenId
1716     ) public virtual override {
1717         safeTransferFrom(from, to, tokenId, "");
1718     }
1719 
1720     /**
1721      * @dev See {IERC721-safeTransferFrom}.
1722      */
1723     function safeTransferFrom(
1724         address from,
1725         address to,
1726         uint256 tokenId,
1727         bytes memory _data
1728     ) public virtual override {
1729         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1730         _safeTransfer(from, to, tokenId, _data);
1731     }
1732 
1733     /**
1734      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1735      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1736      *
1737      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1738      *
1739      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1740      * implement alternative mechanisms to perform token transfer, such as signature-based.
1741      *
1742      * Requirements:
1743      *
1744      * - `from` cannot be the zero address.
1745      * - `to` cannot be the zero address.
1746      * - `tokenId` token must exist and be owned by `from`.
1747      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1748      *
1749      * Emits a {Transfer} event.
1750      */
1751     function _safeTransfer(
1752         address from,
1753         address to,
1754         uint256 tokenId,
1755         bytes memory _data
1756     ) internal virtual {
1757         _transfer(from, to, tokenId);
1758         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1759     }
1760 
1761     /**
1762      * @dev Returns whether `tokenId` exists.
1763      *
1764      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1765      *
1766      * Tokens start existing when they are minted (`_mint`),
1767      * and stop existing when they are burned (`_burn`).
1768      */
1769     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1770         return _owners[tokenId] != address(0);
1771     }
1772 
1773     /**
1774      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1775      *
1776      * Requirements:
1777      *
1778      * - `tokenId` must exist.
1779      */
1780     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1781         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1782         address owner = ERC721.ownerOf(tokenId);
1783         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1784     }
1785 
1786     /**
1787      * @dev Safely mints `tokenId` and transfers it to `to`.
1788      *
1789      * Requirements:
1790      *
1791      * - `tokenId` must not exist.
1792      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1793      *
1794      * Emits a {Transfer} event.
1795      */
1796     function _safeMint(address to, uint256 tokenId) internal virtual {
1797         _safeMint(to, tokenId, "");
1798     }
1799 
1800     /**
1801      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1802      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1803      */
1804     function _safeMint(
1805         address to,
1806         uint256 tokenId,
1807         bytes memory _data
1808     ) internal virtual {
1809         _mint(to, tokenId);
1810         require(
1811             _checkOnERC721Received(address(0), to, tokenId, _data),
1812             "ERC721: transfer to non ERC721Receiver implementer"
1813         );
1814     }
1815 
1816     /**
1817      * @dev Mints `tokenId` and transfers it to `to`.
1818      *
1819      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1820      *
1821      * Requirements:
1822      *
1823      * - `tokenId` must not exist.
1824      * - `to` cannot be the zero address.
1825      *
1826      * Emits a {Transfer} event.
1827      */
1828     function _mint(address to, uint256 tokenId) internal virtual {
1829         require(to != address(0), "ERC721: mint to the zero address");
1830         require(!_exists(tokenId), "ERC721: token already minted");
1831 
1832         _beforeTokenTransfer(address(0), to, tokenId);
1833 
1834         _balances[to] += 1;
1835         _owners[tokenId] = to;
1836 
1837         emit Transfer(address(0), to, tokenId);
1838     }
1839 
1840     /**
1841      * @dev Destroys `tokenId`.
1842      * The approval is cleared when the token is burned.
1843      *
1844      * Requirements:
1845      *
1846      * - `tokenId` must exist.
1847      *
1848      * Emits a {Transfer} event.
1849      */
1850     function _burn(uint256 tokenId) internal virtual {
1851         address owner = ERC721.ownerOf(tokenId);
1852 
1853         _beforeTokenTransfer(owner, address(0), tokenId);
1854 
1855         // Clear approvals
1856         _approve(address(0), tokenId);
1857 
1858         _balances[owner] -= 1;
1859         delete _owners[tokenId];
1860 
1861         emit Transfer(owner, address(0), tokenId);
1862     }
1863 
1864     /**
1865      * @dev Transfers `tokenId` from `from` to `to`.
1866      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1867      *
1868      * Requirements:
1869      *
1870      * - `to` cannot be the zero address.
1871      * - `tokenId` token must be owned by `from`.
1872      *
1873      * Emits a {Transfer} event.
1874      */
1875     function _transfer(
1876         address from,
1877         address to,
1878         uint256 tokenId
1879     ) internal virtual {
1880         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1881         require(to != address(0), "ERC721: transfer to the zero address");
1882 
1883         _beforeTokenTransfer(from, to, tokenId);
1884 
1885         // Clear approvals from the previous owner
1886         _approve(address(0), tokenId);
1887 
1888         _balances[from] -= 1;
1889         _balances[to] += 1;
1890         _owners[tokenId] = to;
1891 
1892         emit Transfer(from, to, tokenId);
1893     }
1894 
1895     /**
1896      * @dev Approve `to` to operate on `tokenId`
1897      *
1898      * Emits a {Approval} event.
1899      */
1900     function _approve(address to, uint256 tokenId) internal virtual {
1901         _tokenApprovals[tokenId] = to;
1902         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1903     }
1904 
1905     /**
1906      * @dev Approve `operator` to operate on all of `owner` tokens
1907      *
1908      * Emits a {ApprovalForAll} event.
1909      */
1910     function _setApprovalForAll(
1911         address owner,
1912         address operator,
1913         bool approved
1914     ) internal virtual {
1915         require(owner != operator, "ERC721: approve to caller");
1916         _operatorApprovals[owner][operator] = approved;
1917         emit ApprovalForAll(owner, operator, approved);
1918     }
1919 
1920     /**
1921      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1922      * The call is not executed if the target address is not a contract.
1923      *
1924      * @param from address representing the previous owner of the given token ID
1925      * @param to target address that will receive the tokens
1926      * @param tokenId uint256 ID of the token to be transferred
1927      * @param _data bytes optional data to send along with the call
1928      * @return bool whether the call correctly returned the expected magic value
1929      */
1930     function _checkOnERC721Received(
1931         address from,
1932         address to,
1933         uint256 tokenId,
1934         bytes memory _data
1935     ) private returns (bool) {
1936         if (to.isContract()) {
1937             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1938                 return retval == IERC721Receiver.onERC721Received.selector;
1939             } catch (bytes memory reason) {
1940                 if (reason.length == 0) {
1941                     revert("ERC721: transfer to non ERC721Receiver implementer");
1942                 } else {
1943                     assembly {
1944                         revert(add(32, reason), mload(reason))
1945                     }
1946                 }
1947             }
1948         } else {
1949             return true;
1950         }
1951     }
1952 
1953     /**
1954      * @dev Hook that is called before any token transfer. This includes minting
1955      * and burning.
1956      *
1957      * Calling conditions:
1958      *
1959      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1960      * transferred to `to`.
1961      * - When `from` is zero, `tokenId` will be minted for `to`.
1962      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1963      * - `from` and `to` are never both zero.
1964      *
1965      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1966      */
1967     function _beforeTokenTransfer(
1968         address from,
1969         address to,
1970         uint256 tokenId
1971     ) internal virtual {}
1972 }
1973 
1974 // File: contracts/4_RealAssetNFT.sol
1975 
1976 
1977 pragma solidity ^0.8.1;
1978 
1979 
1980 
1981 
1982 
1983 
1984 
1985 
1986 contract RealAssetNFT is
1987     VRFConsumerBase,
1988     ERC721,
1989     Ownable,
1990     ReentrancyGuard
1991 {
1992     using Strings for uint256;
1993     using SafeMath for uint256;
1994     using ECDSA for bytes32;
1995 
1996     bool public ended = false;
1997     bool public revealed = false;
1998     bool private isrequestfulfilled;
1999 
2000     uint256 public immutable MaxSupply; 
2001     uint256 public immutable saleStartTime;
2002     uint256 public immutable preSaleStartTime;
2003     uint256 public immutable preSaleEndTime;
2004     uint256 public immutable preSaleDuration;
2005     uint256 public constant publicSaleBufferDuration=30;
2006     uint256 public constant maxTokenPerMint = 5; 
2007     uint256 public immutable mintCost;
2008     uint256 private currentTokenId = 0;    
2009     uint256 public totalMint = 0;
2010     uint256 public constant BigPrimeNumber = 9973;
2011 
2012     uint256 private constant fee  = 2 * 10 ** 18;
2013     uint256 private randomNumber;
2014     bytes32 internal keyHash;
2015     bytes32 public vrfRequestId;
2016     
2017     string public baseTokenURI;
2018     mapping(address => uint256) public presalerListPurchases;
2019     address private immutable signerAddress;
2020 
2021     modifier preSaleEnded {
2022         require(block.timestamp > preSaleEndTime, "Sorry, the pre-sale is not yet ended");
2023         _;
2024     }
2025 
2026     modifier saleNotEnded {
2027         require(!ended, "Sorry, the sale is ended");
2028         _;
2029     }
2030 
2031     modifier saleEnded {
2032         require(ended, "Sorry, the sale not yet ended");
2033         _;
2034     }
2035 
2036     modifier saleStarted {
2037         require(block.timestamp >= saleStartTime, "Sorry, the sale is not yet started");
2038         _;
2039     }
2040 
2041     event URI(string uri);
2042     event RandomNumberRequested( address indexed sender,bytes32 indexed vrfRequestId);
2043     event RandomNumberCompleted(bytes32 indexed requestId, uint256 randomNumber);
2044     event SaleEnded(address account);
2045     event TokensRevealed(uint256 time);
2046 
2047     constructor(address _vrfCoordinator, address _link , bytes32 _keyHash , string memory _metadataBaseUri , uint256 _mintCost , uint256 _maxSuppply,uint256 _preSaleStartTime ,uint256 _preSaleDuration,address _signerAddress)
2048         VRFConsumerBase(_vrfCoordinator, _link) ERC721('BLUPRINT', 'BPRINT')
2049     { 
2050         require(block.timestamp <= _preSaleStartTime,"Presale start time must be greater then current time");
2051         require(_maxSuppply > 0,"Maximum token supply must be greator then zero");
2052         require(_preSaleDuration > 0,"Presale duration must be greater then zero");
2053         require(_mintCost > 0,"Token cost must be greater then zero wei");
2054 
2055         mintCost = _mintCost;
2056         keyHash = _keyHash;
2057         baseTokenURI = _metadataBaseUri;
2058         MaxSupply = _maxSuppply;
2059         signerAddress = _signerAddress;
2060         preSaleStartTime = _preSaleStartTime;
2061         preSaleDuration = _preSaleDuration;
2062         preSaleEndTime = _preSaleDuration + _preSaleStartTime;
2063         saleStartTime = _preSaleDuration + _preSaleStartTime + publicSaleBufferDuration;
2064     }
2065 
2066     function hashMessage(address sender,uint256 chainId,uint256 tokenQuantity) private pure returns(bytes32) {
2067         bytes32 hash = keccak256(abi.encodePacked(
2068         "\x19Ethereum Signed Message:\n32",
2069         keccak256(abi.encodePacked(sender,chainId,tokenQuantity)))
2070         );
2071         return hash;
2072     }
2073 
2074     function matchAddressSigner(bytes32 hash, bytes memory signature) private view returns(bool) {
2075         return signerAddress == hash.recover(signature);
2076     }
2077     
2078     function preSalebuy(uint256 tokenSignQuantity,uint256 tokenQuantity,bytes memory signature)   external nonReentrant() payable   {
2079         bytes32 hash = hashMessage(msg.sender,block.chainid,tokenSignQuantity);
2080         require(tokenQuantity > 0 && tokenSignQuantity > 0,"Token quantity to mint must be greter then zero");
2081         require(block.timestamp >= preSaleStartTime, "Sorry, the pre-sale is not yet started");
2082         require(block.timestamp <= preSaleEndTime, "Sorry, the pre-sale is ended");
2083         require(matchAddressSigner(hash, signature), "Sorry, you are not a whitelisted user");
2084         require((totalMint + tokenQuantity) <= MaxSupply,"Sorry, can't be purchased as exceed max supply.");
2085         require((mintCost * tokenQuantity) <= msg.value,"you need to pay the minimum token price.");
2086         require(msg.sender != address(0),"ERC1155: mint to the zero address");
2087         require(presalerListPurchases[msg.sender] + tokenQuantity  <= tokenSignQuantity, "Sorry,can't be purchased as exceed maxm allowed limit");
2088 
2089         for(uint256 i = 0; i < tokenQuantity; i++) {
2090             _incrementTokenId();
2091             _mint(msg.sender, currentTokenId);
2092             presalerListPurchases[msg.sender]++;
2093             totalMint += uint256(1);
2094         }
2095     }
2096 
2097     function presalePurchasedCount(address addr) external view returns (uint256) {
2098         return presalerListPurchases[addr];
2099     }
2100 
2101     function isPreSaleLive() external view  returns(bool) {
2102         return (block.timestamp >= preSaleStartTime && block.timestamp <= preSaleEndTime);
2103     }
2104 
2105     function isPublicSaleLive() external view  returns(bool) {
2106         return (block.timestamp >= saleStartTime && !ended);
2107     }
2108 
2109     function mint(uint256 tokenQuantity) external nonReentrant() payable saleNotEnded saleStarted preSaleEnded {
2110         require(tokenQuantity > 0,"Token quantity to mint must be greter then zero");
2111         require(tokenQuantity <= maxTokenPerMint, "Limit exceed to purchase in single mint");
2112         require((totalMint + tokenQuantity) <= MaxSupply,"Sorry, can't be purchased as exceed max supply.");
2113         require((mintCost * tokenQuantity) <= msg.value, "you need to pay the minimum token price.");
2114         require(msg.sender != address(0),"ERC1155: mint to the zero address");
2115 
2116         for(uint256 i = 0; i < tokenQuantity; i++) {
2117             _incrementTokenId();
2118             _mint(msg.sender, currentTokenId);
2119             totalMint += uint256(1);
2120         }        
2121     }
2122 
2123     function endSale() external onlyOwner saleStarted saleNotEnded {
2124         ended = true;
2125         emit SaleEnded(msg.sender);
2126     }
2127     
2128     function requestRandomNumber() external onlyOwner saleStarted saleEnded returns (bytes32, uint32) {
2129         require( !isrequestfulfilled , "Already obtained the random no");
2130         require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK tokens available");
2131 
2132         uint32 lockBlock = uint32(block.number);
2133         vrfRequestId = requestRandomness(keyHash, fee);
2134         emit RandomNumberRequested( msg.sender ,vrfRequestId);
2135         return (vrfRequestId, lockBlock);
2136     }
2137 
2138     function revealTokens(string memory _uri) external onlyOwner saleStarted saleEnded {
2139         require(isrequestfulfilled, "Random entropy has not been assigned");
2140         require(!revealed, "Already revealed");
2141 
2142         revealed = true;
2143         baseTokenURI = _uri;
2144         emit TokensRevealed(block.timestamp);
2145         emit URI(_uri);
2146     }
2147     
2148     function fulfillRandomness(bytes32 _requestId, uint256 _randomness) internal override {
2149         randomNumber = _randomness;
2150         isrequestfulfilled = true; 
2151         emit RandomNumberCompleted(_requestId, _randomness);
2152     }
2153 
2154     function getAssetId(uint256 _tokenID) external view saleStarted returns(uint256){
2155         require(_tokenID > 0 && _tokenID <= MaxSupply, "Invalid token Id");
2156         require( isrequestfulfilled , "Please wait for random number to be assigned");
2157 
2158         uint256 assetID = BigPrimeNumber * _tokenID + ( randomNumber % BigPrimeNumber);
2159         assetID = assetID%MaxSupply;
2160         if(assetID == 0) assetID = MaxSupply;
2161         return assetID;
2162     }
2163 
2164     function getRandomNumber() external view  saleStarted returns(uint256) {
2165         require(isrequestfulfilled , "Please wait for random number to be assigned");
2166 
2167         return randomNumber;
2168     }
2169 
2170     function _incrementTokenId() private {
2171         require(currentTokenId < MaxSupply, "token Id limit reached");
2172 
2173         currentTokenId++;
2174     }
2175 
2176     function setURI(string memory _uri) external onlyOwner {
2177         baseTokenURI = _uri;
2178         emit URI(_uri);
2179     }
2180 
2181     function _baseURI() internal view override returns (string memory) {
2182         return baseTokenURI;
2183     }
2184 
2185     function getBalanceEther() external view onlyOwner returns(uint256) {
2186         return address(this).balance;
2187     }
2188 
2189     function getBalanceLink() external view onlyOwner returns(uint256) {
2190         return LINK.balanceOf(address(this));
2191     }
2192 
2193     function withdrawEth(uint256 _amount) external onlyOwner nonReentrant(){
2194         require(_amount > 0, "Amount should be greater then zero");
2195         require(address(this).balance >= _amount , "Not enough eth balance to withdraw");
2196 
2197         payable(msg.sender).transfer(_amount);
2198     }
2199     
2200     function getLinkAddress() external view returns (address) {
2201         return address(LINK);
2202     }
2203 
2204     function withdrawLink(uint256 _amount) external onlyOwner nonReentrant() {
2205         require(_amount > 0, "Amount should be greater then zero");
2206         require(LINK.balanceOf(address(this)) >= _amount, "Not enough LINK tokens available");
2207         
2208         LINK.transfer(msg.sender , _amount);
2209     }
2210     
2211 }