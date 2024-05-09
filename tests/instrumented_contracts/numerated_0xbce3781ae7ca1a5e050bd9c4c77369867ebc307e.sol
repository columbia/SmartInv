1 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
2 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
3 //@@@@@@@@@@@@@@@@@@##@@@@@@@@@@@@@@@@@@@ @@@@@@@@@@@@@@ @@@@@@@@@@@@@@@@@@@@@@*  %@@@  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
4 //@@@@@@@@@@@@@@  @@@@    *@@@@@@@@@@@@@@  @@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@@@@@@   .@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
5 //@@@@@@@@@@@# %@@@@@@@@@   @@ /@@@@@@@@@@  @@@@@@@@@@@@  @@@@@@@@@@@@@ /@  /@@  @@@@@ @@@@@   @@@@@@@@ @@@@@@@@@@@@@@@@@@@@./@*         .@@@@@@@@@@@@@@
6 //@@@@@@@@@@* @@@@@@@@@@@@  @@ @@@@@@@@@@@@ (@%   &@@@@@@  @@@,@@@@@@@ #@@@@%   @@@@@@ #@@@@         @@  @@@@@@@@@@@@@@@@. @/ @@@@@@@@@@@@  @@@@@@@@@@@@
7 //@@@@@@@@@@ /@@@@@@@@@@@@@      @  @@@    # @@@@@@@@@. @@ (@@@ @@@@@  @@@@@@@  @@@@@@  @@ &@@@@@@@@@  @ @@@@@@@  @@@@@@@/ @  @@@@@@@@@@@@@  @@@@@@@@@@@
8 //@@@@@@@@@@  @@@@@@@@@@@@    @@@@@@@@@@@@@   @@@@@@@@@@ @/ @@@& @@@/ @@@@@@@@  @@@@@@@   .@@@@@@@@@@@@ & @@@@@@  (@@@@@@  @  &@@@@@@@@@@@@@( @@@@@@@@@@
9 //@@@@@@@@@@@  .@@@@@.  ,@@@   @@@@@@@@@@@@   @@@@@@@@@  @@ .@@@  @@@ @@@@@@@@  @@@@@@@@ # @@@@@@@@@@@@@   @@@@@   @@@@@  @@@  @@@@@@@@@@@@@@  @@@@@@@@@
10 //@@@@@@@@@@@@@@@@@@@@@@@@@@%  @@@@@@@@@@@@@  %    ,@@  @@@  @@@@ @@@@ &@@@@@  (@@@@@@@@/   @@@@@@@@@@@* @  @@@* @ @@@@. @@@@# @@@@@@@@@@@@@@@  @@@@@@@@
11 //@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@  @ ,@@@@@@@@@@@@ *@@@@@ @@@@@@@@@@@@@@@@@@@@@@  @ %@@@@@@@  @@@@, @@ @@  @@  @@@@@@ @@@@@@@@@@@@@@@  @@@@@@@@
12 //@@@@@@@@@@ %@@@@@@@@@@@@@@ *@  @@@@@@@  &@@( @@@@@@@@@@@@ %@@@@@@@@@@@@@@@@@@@@@@@@@@@@* @@@@   @@@@@@@@@@@@@@@@# @  @@@@@@@ @@@@@@@@@@@@@@@  @@@@@@@@
13 //@@@@@@@@@@@@      .@@@@@@  @@@@       @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@@   @@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@
14 //@@@@@@@@@@@@@@@@@@@@@*   %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
15 //@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
16 
17 // SPDX-License-Identifier: MIT
18 
19 pragma solidity ^0.8.0;
20 
21 /**
22  * @dev String operations.
23  */
24 library Strings {
25     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
26 
27     /**
28      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
29      */
30     function toString(uint256 value) internal pure returns (string memory) {
31         // Inspired by OraclizeAPI's implementation - MIT licence
32         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
33 
34         if (value == 0) {
35             return "0";
36         }
37         uint256 temp = value;
38         uint256 digits;
39         while (temp != 0) {
40             digits++;
41             temp /= 10;
42         }
43         bytes memory buffer = new bytes(digits);
44         while (value != 0) {
45             digits -= 1;
46             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
47             value /= 10;
48         }
49         return string(buffer);
50     }
51 
52     /**
53      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
54      */
55     function toHexString(uint256 value) internal pure returns (string memory) {
56         if (value == 0) {
57             return "0x00";
58         }
59         uint256 temp = value;
60         uint256 length = 0;
61         while (temp != 0) {
62             length++;
63             temp >>= 8;
64         }
65         return toHexString(value, length);
66     }
67 
68     /**
69      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
70      */
71     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
72         bytes memory buffer = new bytes(2 * length + 2);
73         buffer[0] = "0";
74         buffer[1] = "x";
75         for (uint256 i = 2 * length + 1; i > 1; --i) {
76             buffer[i] = _HEX_SYMBOLS[value & 0xf];
77             value >>= 4;
78         }
79         require(value == 0, "Strings: hex length insufficient");
80         return string(buffer);
81     }
82 }
83 // File: ECDSA.sol
84 
85 
86 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
87 
88 pragma solidity ^0.8.0;
89 
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
203         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
204         uint8 v = uint8((uint256(vs) >> 255) + 27);
205         return tryRecover(hash, v, r, s);
206     }
207 
208     /**
209      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
210      *
211      * _Available since v4.2._
212      */
213     function recover(
214         bytes32 hash,
215         bytes32 r,
216         bytes32 vs
217     ) internal pure returns (address) {
218         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
219         _throwError(error);
220         return recovered;
221     }
222 
223     /**
224      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
225      * `r` and `s` signature fields separately.
226      *
227      * _Available since v4.3._
228      */
229     function tryRecover(
230         bytes32 hash,
231         uint8 v,
232         bytes32 r,
233         bytes32 s
234     ) internal pure returns (address, RecoverError) {
235         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
236         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
237         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
238         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
239         //
240         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
241         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
242         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
243         // these malleable signatures as well.
244         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
245             return (address(0), RecoverError.InvalidSignatureS);
246         }
247         if (v != 27 && v != 28) {
248             return (address(0), RecoverError.InvalidSignatureV);
249         }
250 
251         // If the signature is valid (and not malleable), return the signer address
252         address signer = ecrecover(hash, v, r, s);
253         if (signer == address(0)) {
254             return (address(0), RecoverError.InvalidSignature);
255         }
256 
257         return (signer, RecoverError.NoError);
258     }
259 
260     /**
261      * @dev Overload of {ECDSA-recover} that receives the `v`,
262      * `r` and `s` signature fields separately.
263      */
264     function recover(
265         bytes32 hash,
266         uint8 v,
267         bytes32 r,
268         bytes32 s
269     ) internal pure returns (address) {
270         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
271         _throwError(error);
272         return recovered;
273     }
274 
275     /**
276      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
277      * produces hash corresponding to the one signed with the
278      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
279      * JSON-RPC method as part of EIP-191.
280      *
281      * See {recover}.
282      */
283     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
284         // 32 is the length in bytes of hash,
285         // enforced by the type signature above
286         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
287     }
288 
289     /**
290      * @dev Returns an Ethereum Signed Message, created from `s`. This
291      * produces hash corresponding to the one signed with the
292      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
293      * JSON-RPC method as part of EIP-191.
294      *
295      * See {recover}.
296      */
297     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
298         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
299     }
300 
301     /**
302      * @dev Returns an Ethereum Signed Typed Data, created from a
303      * `domainSeparator` and a `structHash`. This produces hash corresponding
304      * to the one signed with the
305      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
306      * JSON-RPC method as part of EIP-712.
307      *
308      * See {recover}.
309      */
310     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
311         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
312     }
313 }
314 // File: Context.sol
315 
316 
317 
318 pragma solidity ^0.8.0;
319 
320 /**
321  * @dev Provides information about the current execution context, including the
322  * sender of the transaction and its data. While these are generally available
323  * via msg.sender and msg.data, they should not be accessed in such a direct
324  * manner, since when dealing with meta-transactions the account sending and
325  * paying for execution may not be the actual sender (as far as an application
326  * is concerned).
327  *
328  * This contract is only required for intermediate, library-like contracts.
329  */
330 abstract contract Context {
331     function _msgSender() internal view virtual returns (address) {
332         return msg.sender;
333     }
334 
335     function _msgData() internal view virtual returns (bytes calldata) {
336         return msg.data;
337     }
338 }
339 // File: Ownable.sol
340 
341 
342 
343 pragma solidity ^0.8.0;
344 
345 
346 /**
347  * @dev Contract module which provides a basic access control mechanism, where
348  * there is an account (an owner) that can be granted exclusive access to
349  * specific functions.
350  *
351  * By default, the owner account will be the one that deploys the contract. This
352  * can later be changed with {transferOwnership}.
353  *
354  * This module is used through inheritance. It will make available the modifier
355  * `onlyOwner`, which can be applied to your functions to restrict their use to
356  * the owner.
357  */
358 abstract contract Ownable is Context {
359     address private _owner;
360 
361     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
362 
363     /**
364      * @dev Initializes the contract setting the deployer as the initial owner.
365      */
366     constructor() {
367         _setOwner(_msgSender());
368     }
369 
370     /**
371      * @dev Returns the address of the current owner.
372      */
373     function owner() public view virtual returns (address) {
374         return _owner;
375     }
376 
377     /**
378      * @dev Throws if called by any account other than the owner.
379      */
380     modifier onlyOwner() {
381         require(owner() == _msgSender(), "Ownable: caller is not the owner");
382         _;
383     }
384 
385     /**
386      * @dev Leaves the contract without owner. It will not be possible to call
387      * `onlyOwner` functions anymore. Can only be called by the current owner.
388      *
389      * NOTE: Renouncing ownership will leave the contract without an owner,
390      * thereby removing any functionality that is only available to the owner.
391      */
392     function renounceOwnership() public virtual onlyOwner {
393         _setOwner(address(0));
394     }
395 
396     /**
397      * @dev Transfers ownership of the contract to a new account (`newOwner`).
398      * Can only be called by the current owner.
399      */
400     function transferOwnership(address newOwner) public virtual onlyOwner {
401         require(newOwner != address(0), "Ownable: new owner is the zero address");
402         _setOwner(newOwner);
403     }
404 
405     function _setOwner(address newOwner) private {
406         address oldOwner = _owner;
407         _owner = newOwner;
408         emit OwnershipTransferred(oldOwner, newOwner);
409     }
410 }
411 // File: Address.sol
412 
413 
414 
415 pragma solidity ^0.8.0;
416 
417 /**
418  * @dev Collection of functions related to the address type
419  */
420 library Address {
421     /**
422      * @dev Returns true if `account` is a contract.
423      *
424      * [IMPORTANT]
425      * ====
426      * It is unsafe to assume that an address for which this function returns
427      * false is an externally-owned account (EOA) and not a contract.
428      *
429      * Among others, `isContract` will return false for the following
430      * types of addresses:
431      *
432      *  - an externally-owned account
433      *  - a contract in construction
434      *  - an address where a contract will be created
435      *  - an address where a contract lived, but was destroyed
436      * ====
437      */
438     function isContract(address account) internal view returns (bool) {
439         // This method relies on extcodesize, which returns 0 for contracts in
440         // construction, since the code is only stored at the end of the
441         // constructor execution.
442 
443         uint256 size;
444         assembly {
445             size := extcodesize(account)
446         }
447         return size > 0;
448     }
449 
450     /**
451      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
452      * `recipient`, forwarding all available gas and reverting on errors.
453      *
454      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
455      * of certain opcodes, possibly making contracts go over the 2300 gas limit
456      * imposed by `transfer`, making them unable to receive funds via
457      * `transfer`. {sendValue} removes this limitation.
458      *
459      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
460      *
461      * IMPORTANT: because control is transferred to `recipient`, care must be
462      * taken to not create reentrancy vulnerabilities. Consider using
463      * {ReentrancyGuard} or the
464      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
465      */
466     function sendValue(address payable recipient, uint256 amount) internal {
467         require(address(this).balance >= amount, "Address: insufficient balance");
468 
469         (bool success, ) = recipient.call{value: amount}("");
470         require(success, "Address: unable to send value, recipient may have reverted");
471     }
472 
473     /**
474      * @dev Performs a Solidity function call using a low level `call`. A
475      * plain `call` is an unsafe replacement for a function call: use this
476      * function instead.
477      *
478      * If `target` reverts with a revert reason, it is bubbled up by this
479      * function (like regular Solidity function calls).
480      *
481      * Returns the raw returned data. To convert to the expected return value,
482      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
483      *
484      * Requirements:
485      *
486      * - `target` must be a contract.
487      * - calling `target` with `data` must not revert.
488      *
489      * _Available since v3.1._
490      */
491     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
492         return functionCall(target, data, "Address: low-level call failed");
493     }
494 
495     /**
496      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
497      * `errorMessage` as a fallback revert reason when `target` reverts.
498      *
499      * _Available since v3.1._
500      */
501     function functionCall(
502         address target,
503         bytes memory data,
504         string memory errorMessage
505     ) internal returns (bytes memory) {
506         return functionCallWithValue(target, data, 0, errorMessage);
507     }
508 
509     /**
510      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
511      * but also transferring `value` wei to `target`.
512      *
513      * Requirements:
514      *
515      * - the calling contract must have an ETH balance of at least `value`.
516      * - the called Solidity function must be `payable`.
517      *
518      * _Available since v3.1._
519      */
520     function functionCallWithValue(
521         address target,
522         bytes memory data,
523         uint256 value
524     ) internal returns (bytes memory) {
525         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
526     }
527 
528     /**
529      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
530      * with `errorMessage` as a fallback revert reason when `target` reverts.
531      *
532      * _Available since v3.1._
533      */
534     function functionCallWithValue(
535         address target,
536         bytes memory data,
537         uint256 value,
538         string memory errorMessage
539     ) internal returns (bytes memory) {
540         require(address(this).balance >= value, "Address: insufficient balance for call");
541         require(isContract(target), "Address: call to non-contract");
542 
543         (bool success, bytes memory returndata) = target.call{value: value}(data);
544         return _verifyCallResult(success, returndata, errorMessage);
545     }
546 
547     /**
548      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
549      * but performing a static call.
550      *
551      * _Available since v3.3._
552      */
553     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
554         return functionStaticCall(target, data, "Address: low-level static call failed");
555     }
556 
557     /**
558      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
559      * but performing a static call.
560      *
561      * _Available since v3.3._
562      */
563     function functionStaticCall(
564         address target,
565         bytes memory data,
566         string memory errorMessage
567     ) internal view returns (bytes memory) {
568         require(isContract(target), "Address: static call to non-contract");
569 
570         (bool success, bytes memory returndata) = target.staticcall(data);
571         return _verifyCallResult(success, returndata, errorMessage);
572     }
573 
574     /**
575      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
576      * but performing a delegate call.
577      *
578      * _Available since v3.4._
579      */
580     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
581         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
582     }
583 
584     /**
585      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
586      * but performing a delegate call.
587      *
588      * _Available since v3.4._
589      */
590     function functionDelegateCall(
591         address target,
592         bytes memory data,
593         string memory errorMessage
594     ) internal returns (bytes memory) {
595         require(isContract(target), "Address: delegate call to non-contract");
596 
597         (bool success, bytes memory returndata) = target.delegatecall(data);
598         return _verifyCallResult(success, returndata, errorMessage);
599     }
600 
601     function _verifyCallResult(
602         bool success,
603         bytes memory returndata,
604         string memory errorMessage
605     ) private pure returns (bytes memory) {
606         if (success) {
607             return returndata;
608         } else {
609             // Look for revert reason and bubble it up if present
610             if (returndata.length > 0) {
611                 // The easiest way to bubble the revert reason is using memory via assembly
612 
613                 assembly {
614                     let returndata_size := mload(returndata)
615                     revert(add(32, returndata), returndata_size)
616                 }
617             } else {
618                 revert(errorMessage);
619             }
620         }
621     }
622 }
623 // File: Payment.sol
624 
625 
626 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
627 
628 pragma solidity ^0.8.0;
629 
630 
631 
632 /**
633  * @title PaymentSplitter
634  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
635  * that the Ether will be split in this way, since it is handled transparently by the contract.
636  *
637  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
638  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
639  * an amount proportional to the percentage of total shares they were assigned.
640  *
641  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
642  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
643  * function.
644  *
645  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
646  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
647  * to run tests before sending real value to this contract.
648  */
649 contract Payment is Context {
650     event PayeeAdded(address account, uint256 shares);
651     event PaymentReleased(address to, uint256 amount);
652     event PaymentReceived(address from, uint256 amount);
653 
654     uint256 private _totalShares;
655     uint256 private _totalReleased;
656 
657     mapping(address => uint256) private _shares;
658     mapping(address => uint256) private _released;
659     address[] private _payees;
660 
661     /**
662      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
663      * the matching position in the `shares` array.
664      *
665      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
666      * duplicates in `payees`.
667      */
668     constructor(address[] memory payees, uint256[] memory shares_) payable {
669         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
670         require(payees.length > 0, "PaymentSplitter: no payees");
671 
672         for (uint256 i = 0; i < payees.length; i++) {
673             _addPayee(payees[i], shares_[i]);
674         }
675     }
676 
677     /**
678      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
679      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
680      * reliability of the events, and not the actual splitting of Ether.
681      *
682      * To learn more about this see the Solidity documentation for
683      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
684      * functions].
685      */
686     receive() external payable virtual {
687         emit PaymentReceived(_msgSender(), msg.value);
688     }
689 
690     /**
691      * @dev Getter for the total shares held by payees.
692      */
693     function totalShares() public view returns (uint256) {
694         return _totalShares;
695     }
696 
697     /**
698      * @dev Getter for the total amount of Ether already released.
699      */
700     function totalReleased() public view returns (uint256) {
701         return _totalReleased;
702     }
703 
704 
705     /**
706      * @dev Getter for the amount of shares held by an account.
707      */
708     function shares(address account) public view returns (uint256) {
709         return _shares[account];
710     }
711 
712     /**
713      * @dev Getter for the amount of Ether already released to a payee.
714      */
715     function released(address account) public view returns (uint256) {
716         return _released[account];
717     }
718 
719 
720     /**
721      * @dev Getter for the address of the payee number `index`.
722      */
723     function payee(uint256 index) public view returns (address) {
724         return _payees[index];
725     }
726 
727     /**
728      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
729      * total shares and their previous withdrawals.
730      */
731     function release(address payable account) public virtual {
732         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
733 
734         uint256 totalReceived = address(this).balance + totalReleased();
735         uint256 payment = _pendingPayment(account, totalReceived, released(account));
736 
737         require(payment != 0, "PaymentSplitter: account is not due payment");
738 
739         _released[account] += payment;
740         _totalReleased += payment;
741 
742         Address.sendValue(account, payment);
743         emit PaymentReleased(account, payment);
744     }
745 
746 
747     /**
748      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
749      * already released amounts.
750      */
751     function _pendingPayment(
752         address account,
753         uint256 totalReceived,
754         uint256 alreadyReleased
755     ) private view returns (uint256) {
756         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
757     }
758 
759     /**
760      * @dev Add a new payee to the contract.
761      * @param account The address of the payee to add.
762      * @param shares_ The number of shares owned by the payee.
763      */
764     function _addPayee(address account, uint256 shares_) private {
765         require(account != address(0), "PaymentSplitter: account is the zero address");
766         require(shares_ > 0, "PaymentSplitter: shares are 0");
767         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
768 
769         _payees.push(account);
770         _shares[account] = shares_;
771         _totalShares = _totalShares + shares_;
772         emit PayeeAdded(account, shares_);
773     }
774 }
775 // File: IERC721Receiver.sol
776 
777 
778 
779 pragma solidity ^0.8.0;
780 
781 /**
782  * @title ERC721 token receiver interface
783  * @dev Interface for any contract that wants to support safeTransfers
784  * from ERC721 asset contracts.
785  */
786 interface IERC721Receiver {
787     /**
788      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
789      * by `operator` from `from`, this function is called.
790      *
791      * It must return its Solidity selector to confirm the token transfer.
792      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
793      *
794      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
795      */
796     function onERC721Received(
797         address operator,
798         address from,
799         uint256 tokenId,
800         bytes calldata data
801     ) external returns (bytes4);
802 }
803 // File: IERC165.sol
804 
805 
806 
807 pragma solidity ^0.8.0;
808 
809 /**
810  * @dev Interface of the ERC165 standard, as defined in the
811  * https://eips.ethereum.org/EIPS/eip-165[EIP].
812  *
813  * Implementers can declare support of contract interfaces, which can then be
814  * queried by others ({ERC165Checker}).
815  *
816  * For an implementation, see {ERC165}.
817  */
818 interface IERC165 {
819     /**
820      * @dev Returns true if this contract implements the interface defined by
821      * `interfaceId`. See the corresponding
822      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
823      * to learn more about how these ids are created.
824      *
825      * This function call must use less than 30 000 gas.
826      */
827     function supportsInterface(bytes4 interfaceId) external view returns (bool);
828 }
829 // File: ERC165.sol
830 
831 
832 
833 pragma solidity ^0.8.0;
834 
835 
836 /**
837  * @dev Implementation of the {IERC165} interface.
838  *
839  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
840  * for the additional interface id that will be supported. For example:
841  *
842  * ```solidity
843  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
844  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
845  * }
846  * ```
847  *
848  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
849  */
850 abstract contract ERC165 is IERC165 {
851     /**
852      * @dev See {IERC165-supportsInterface}.
853      */
854     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
855         return interfaceId == type(IERC165).interfaceId;
856     }
857 }
858 // File: IERC721.sol
859 
860 
861 
862 pragma solidity ^0.8.0;
863 
864 
865 /**
866  * @dev Required interface of an ERC721 compliant contract.
867  */
868 interface IERC721 is IERC165 {
869     /**
870      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
871      */
872     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
873 
874     /**
875      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
876      */
877     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
878 
879     /**
880      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
881      */
882     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
883 
884     /**
885      * @dev Returns the number of tokens in ``owner``'s account.
886      */
887     function balanceOf(address owner) external view returns (uint256 balance);
888 
889     /**
890      * @dev Returns the owner of the `tokenId` token.
891      *
892      * Requirements:
893      *
894      * - `tokenId` must exist.
895      */
896     function ownerOf(uint256 tokenId) external view returns (address owner);
897 
898     /**
899      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
900      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
901      *
902      * Requirements:
903      *
904      * - `from` cannot be the zero address.
905      * - `to` cannot be the zero address.
906      * - `tokenId` token must exist and be owned by `from`.
907      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
908      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
909      *
910      * Emits a {Transfer} event.
911      */
912     function safeTransferFrom(
913         address from,
914         address to,
915         uint256 tokenId
916     ) external;
917 
918     /**
919      * @dev Transfers `tokenId` token from `from` to `to`.
920      *
921      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
922      *
923      * Requirements:
924      *
925      * - `from` cannot be the zero address.
926      * - `to` cannot be the zero address.
927      * - `tokenId` token must be owned by `from`.
928      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
929      *
930      * Emits a {Transfer} event.
931      */
932     function transferFrom(
933         address from,
934         address to,
935         uint256 tokenId
936     ) external;
937 
938     /**
939      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
940      * The approval is cleared when the token is transferred.
941      *
942      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
943      *
944      * Requirements:
945      *
946      * - The caller must own the token or be an approved operator.
947      * - `tokenId` must exist.
948      *
949      * Emits an {Approval} event.
950      */
951     function approve(address to, uint256 tokenId) external;
952 
953     /**
954      * @dev Returns the account approved for `tokenId` token.
955      *
956      * Requirements:
957      *
958      * - `tokenId` must exist.
959      */
960     function getApproved(uint256 tokenId) external view returns (address operator);
961 
962     /**
963      * @dev Approve or remove `operator` as an operator for the caller.
964      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
965      *
966      * Requirements:
967      *
968      * - The `operator` cannot be the caller.
969      *
970      * Emits an {ApprovalForAll} event.
971      */
972     function setApprovalForAll(address operator, bool _approved) external;
973 
974     /**
975      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
976      *
977      * See {setApprovalForAll}
978      */
979     function isApprovedForAll(address owner, address operator) external view returns (bool);
980 
981     /**
982      * @dev Safely transfers `tokenId` token from `from` to `to`.
983      *
984      * Requirements:
985      *
986      * - `from` cannot be the zero address.
987      * - `to` cannot be the zero address.
988      * - `tokenId` token must exist and be owned by `from`.
989      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
990      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
991      *
992      * Emits a {Transfer} event.
993      */
994     function safeTransferFrom(
995         address from,
996         address to,
997         uint256 tokenId,
998         bytes calldata data
999     ) external;
1000 }
1001 // File: IERC721Enumerable.sol
1002 
1003 
1004 
1005 pragma solidity ^0.8.0;
1006 
1007 
1008 /**
1009  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1010  * @dev See https://eips.ethereum.org/EIPS/eip-721
1011  */
1012 interface IERC721Enumerable is IERC721 {
1013     /**
1014      * @dev Returns the total amount of tokens stored by the contract.
1015      */
1016     function totalSupply() external view returns (uint256);
1017 
1018     /**
1019      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1020      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1021      */
1022     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1023 
1024     /**
1025      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1026      * Use along with {totalSupply} to enumerate all tokens.
1027      */
1028     function tokenByIndex(uint256 index) external view returns (uint256);
1029 }
1030 // File: IERC721Metadata.sol
1031 
1032 
1033 
1034 pragma solidity ^0.8.0;
1035 
1036 
1037 /**
1038  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1039  * @dev See https://eips.ethereum.org/EIPS/eip-721
1040  */
1041 interface IERC721Metadata is IERC721 {
1042     /**
1043      * @dev Returns the token collection name.
1044      */
1045     function name() external view returns (string memory);
1046 
1047     /**
1048      * @dev Returns the token collection symbol.
1049      */
1050     function symbol() external view returns (string memory);
1051 
1052     /**
1053      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1054      */
1055     function tokenURI(uint256 tokenId) external view returns (string memory);
1056 }
1057 // File: ERC721A.sol
1058 
1059 
1060 pragma solidity ^0.8.0;
1061 
1062 
1063 
1064 
1065 
1066 
1067 
1068 
1069 
1070 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1071     using Address for address;
1072     using Strings for uint256;
1073 
1074     struct TokenOwnership {
1075         address addr;
1076         uint64 startTimestamp;
1077     }
1078 
1079     struct AddressData {
1080         uint128 balance;
1081         uint128 numberMinted;
1082     }
1083 
1084     uint256 internal currentIndex;
1085 
1086     // Token name
1087     string private _name;
1088 
1089     // Token symbol
1090     string private _symbol;
1091 
1092     // Mapping from token ID to ownership details
1093     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1094     mapping(uint256 => TokenOwnership) internal _ownerships;
1095 
1096     // Mapping owner address to address data
1097     mapping(address => AddressData) private _addressData;
1098 
1099     // Mapping from token ID to approved address
1100     mapping(uint256 => address) private _tokenApprovals;
1101 
1102     // Mapping from owner to operator approvals
1103     mapping(address => mapping(address => bool)) private _operatorApprovals;
1104 
1105     constructor(string memory name_, string memory symbol_) {
1106         _name = name_;
1107         _symbol = symbol_;
1108     }
1109 
1110     /**
1111      * @dev See {IERC721Enumerable-totalSupply}.
1112      */
1113     function totalSupply() public view override returns (uint256) {
1114         return currentIndex;
1115     }
1116 
1117     /**
1118      * @dev See {IERC721Enumerable-tokenByIndex}.
1119      */
1120     function tokenByIndex(uint256 index) public view override returns (uint256) {
1121         require(index < totalSupply(), 'ERC721A: global index out of bounds');
1122         return index;
1123     }
1124 
1125     /**
1126      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1127      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1128      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1129      */
1130     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1131         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
1132         uint256 numMintedSoFar = totalSupply();
1133         uint256 tokenIdsIdx;
1134         address currOwnershipAddr;
1135 
1136         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1137         unchecked {
1138             for (uint256 i; i < numMintedSoFar; i++) {
1139                 TokenOwnership memory ownership = _ownerships[i];
1140                 if (ownership.addr != address(0)) {
1141                     currOwnershipAddr = ownership.addr;
1142                 }
1143                 if (currOwnershipAddr == owner) {
1144                     if (tokenIdsIdx == index) {
1145                         return i;
1146                     }
1147                     tokenIdsIdx++;
1148                 }
1149             }
1150         }
1151 
1152         revert('ERC721A: unable to get token of owner by index');
1153     }
1154 
1155     /**
1156      * @dev See {IERC165-supportsInterface}.
1157      */
1158     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1159         return
1160             interfaceId == type(IERC721).interfaceId ||
1161             interfaceId == type(IERC721Metadata).interfaceId ||
1162             interfaceId == type(IERC721Enumerable).interfaceId ||
1163             super.supportsInterface(interfaceId);
1164     }
1165 
1166     /**
1167      * @dev See {IERC721-balanceOf}.
1168      */
1169     function balanceOf(address owner) public view override returns (uint256) {
1170         require(owner != address(0), 'ERC721A: balance query for the zero address');
1171         return uint256(_addressData[owner].balance);
1172     }
1173 
1174     function _numberMinted(address owner) internal view returns (uint256) {
1175         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1176         return uint256(_addressData[owner].numberMinted);
1177     }
1178 
1179     /**
1180      * Gas spent here starts off proportional to the maximum mint batch size.
1181      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1182      */
1183     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1184         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1185 
1186         unchecked {
1187             for (uint256 curr = tokenId; curr >= 0; curr--) {
1188                 TokenOwnership memory ownership = _ownerships[curr];
1189                 if (ownership.addr != address(0)) {
1190                     return ownership;
1191                 }
1192             }
1193         }
1194 
1195         revert('ERC721A: unable to determine the owner of token');
1196     }
1197 
1198     /**
1199      * @dev See {IERC721-ownerOf}.
1200      */
1201     function ownerOf(uint256 tokenId) public view override returns (address) {
1202         return ownershipOf(tokenId).addr;
1203     }
1204 
1205     /**
1206      * @dev See {IERC721Metadata-name}.
1207      */
1208     function name() public view virtual override returns (string memory) {
1209         return _name;
1210     }
1211 
1212     /**
1213      * @dev See {IERC721Metadata-symbol}.
1214      */
1215     function symbol() public view virtual override returns (string memory) {
1216         return _symbol;
1217     }
1218 
1219     /**
1220      * @dev See {IERC721Metadata-tokenURI}.
1221      */
1222     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1223         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1224 
1225         string memory baseURI = _baseURI();
1226         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1227     }
1228 
1229     /**
1230      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1231      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1232      * by default, can be overriden in child contracts.
1233      */
1234     function _baseURI() internal view virtual returns (string memory) {
1235         return '';
1236     }
1237 
1238     /**
1239      * @dev See {IERC721-approve}.
1240      */
1241     function approve(address to, uint256 tokenId) public override {
1242         address owner = ERC721A.ownerOf(tokenId);
1243         require(to != owner, 'ERC721A: approval to current owner');
1244 
1245         require(
1246             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1247             'ERC721A: approve caller is not owner nor approved for all'
1248         );
1249 
1250         _approve(to, tokenId, owner);
1251     }
1252 
1253     /**
1254      * @dev See {IERC721-getApproved}.
1255      */
1256     function getApproved(uint256 tokenId) public view override returns (address) {
1257         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1258 
1259         return _tokenApprovals[tokenId];
1260     }
1261 
1262     /**
1263      * @dev See {IERC721-setApprovalForAll}.
1264      */
1265     function setApprovalForAll(address operator, bool approved) public override {
1266         require(operator != _msgSender(), 'ERC721A: approve to caller');
1267 
1268         _operatorApprovals[_msgSender()][operator] = approved;
1269         emit ApprovalForAll(_msgSender(), operator, approved);
1270     }
1271 
1272     /**
1273      * @dev See {IERC721-isApprovedForAll}.
1274      */
1275     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1276         return _operatorApprovals[owner][operator];
1277     }
1278 
1279     /**
1280      * @dev See {IERC721-transferFrom}.
1281      */
1282     function transferFrom(
1283         address from,
1284         address to,
1285         uint256 tokenId
1286     ) public override {
1287         _transfer(from, to, tokenId);
1288     }
1289 
1290     /**
1291      * @dev See {IERC721-safeTransferFrom}.
1292      */
1293     function safeTransferFrom(
1294         address from,
1295         address to,
1296         uint256 tokenId
1297     ) public override {
1298         safeTransferFrom(from, to, tokenId, '');
1299     }
1300 
1301     /**
1302      * @dev See {IERC721-safeTransferFrom}.
1303      */
1304     function safeTransferFrom(
1305         address from,
1306         address to,
1307         uint256 tokenId,
1308         bytes memory _data
1309     ) public override {
1310         _transfer(from, to, tokenId);
1311         require(
1312             _checkOnERC721Received(from, to, tokenId, _data),
1313             'ERC721A: transfer to non ERC721Receiver implementer'
1314         );
1315     }
1316 
1317     /**
1318      * @dev Returns whether `tokenId` exists.
1319      *
1320      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1321      *
1322      * Tokens start existing when they are minted (`_mint`),
1323      */
1324     function _exists(uint256 tokenId) internal view returns (bool) {
1325         return tokenId < currentIndex;
1326     }
1327 
1328     function _safeMint(address to, uint256 quantity) internal {
1329         _safeMint(to, quantity, '');
1330     }
1331 
1332     /**
1333      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1334      *
1335      * Requirements:
1336      *
1337      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1338      * - `quantity` must be greater than 0.
1339      *
1340      * Emits a {Transfer} event.
1341      */
1342     function _safeMint(
1343         address to,
1344         uint256 quantity,
1345         bytes memory _data
1346     ) internal {
1347         _mint(to, quantity, _data, true);
1348     }
1349 
1350     /**
1351      * @dev Mints `quantity` tokens and transfers them to `to`.
1352      *
1353      * Requirements:
1354      *
1355      * - `to` cannot be the zero address.
1356      * - `quantity` must be greater than 0.
1357      *
1358      * Emits a {Transfer} event.
1359      */
1360     function _mint(
1361         address to,
1362         uint256 quantity,
1363         bytes memory _data,
1364         bool safe
1365     ) internal {
1366         uint256 startTokenId = currentIndex;
1367         require(to != address(0), 'ERC721A: mint to the zero address');
1368         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1369 
1370         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1371 
1372         // Overflows are incredibly unrealistic.
1373         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1374         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1375         unchecked {
1376             _addressData[to].balance += uint128(quantity);
1377             _addressData[to].numberMinted += uint128(quantity);
1378 
1379             _ownerships[startTokenId].addr = to;
1380             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1381 
1382             uint256 updatedIndex = startTokenId;
1383 
1384             for (uint256 i; i < quantity; i++) {
1385                 emit Transfer(address(0), to, updatedIndex);
1386                 if (safe) {
1387                     require(
1388                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1389                         'ERC721A: transfer to non ERC721Receiver implementer'
1390                     );
1391                 }
1392 
1393                 updatedIndex++;
1394             }
1395 
1396             currentIndex = updatedIndex;
1397         }
1398 
1399         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1400     }
1401 
1402     /**
1403      * @dev Transfers `tokenId` from `from` to `to`.
1404      *
1405      * Requirements:
1406      *
1407      * - `to` cannot be the zero address.
1408      * - `tokenId` token must be owned by `from`.
1409      *
1410      * Emits a {Transfer} event.
1411      */
1412     function _transfer(
1413         address from,
1414         address to,
1415         uint256 tokenId
1416     ) private {
1417         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1418 
1419         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1420             getApproved(tokenId) == _msgSender() ||
1421             isApprovedForAll(prevOwnership.addr, _msgSender()));
1422 
1423         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1424 
1425         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1426         require(to != address(0), 'ERC721A: transfer to the zero address');
1427 
1428         _beforeTokenTransfers(from, to, tokenId, 1);
1429 
1430         // Clear approvals from the previous owner
1431         _approve(address(0), tokenId, prevOwnership.addr);
1432 
1433         // Underflow of the sender's balance is impossible because we check for
1434         // ownership above and the recipient's balance can't realistically overflow.
1435         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1436         unchecked {
1437             _addressData[from].balance -= 1;
1438             _addressData[to].balance += 1;
1439 
1440             _ownerships[tokenId].addr = to;
1441             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1442 
1443             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1444             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1445             uint256 nextTokenId = tokenId + 1;
1446             if (_ownerships[nextTokenId].addr == address(0)) {
1447                 if (_exists(nextTokenId)) {
1448                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1449                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1450                 }
1451             }
1452         }
1453 
1454         emit Transfer(from, to, tokenId);
1455         _afterTokenTransfers(from, to, tokenId, 1);
1456     }
1457 
1458     /**
1459      * @dev Approve `to` to operate on `tokenId`
1460      *
1461      * Emits a {Approval} event.
1462      */
1463     function _approve(
1464         address to,
1465         uint256 tokenId,
1466         address owner
1467     ) private {
1468         _tokenApprovals[tokenId] = to;
1469         emit Approval(owner, to, tokenId);
1470     }
1471 
1472     /**
1473      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1474      * The call is not executed if the target address is not a contract.
1475      *
1476      * @param from address representing the previous owner of the given token ID
1477      * @param to target address that will receive the tokens
1478      * @param tokenId uint256 ID of the token to be transferred
1479      * @param _data bytes optional data to send along with the call
1480      * @return bool whether the call correctly returned the expected magic value
1481      */
1482     function _checkOnERC721Received(
1483         address from,
1484         address to,
1485         uint256 tokenId,
1486         bytes memory _data
1487     ) private returns (bool) {
1488         if (to.isContract()) {
1489             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1490                 return retval == IERC721Receiver(to).onERC721Received.selector;
1491             } catch (bytes memory reason) {
1492                 if (reason.length == 0) {
1493                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1494                 } else {
1495                     assembly {
1496                         revert(add(32, reason), mload(reason))
1497                     }
1498                 }
1499             }
1500         } else {
1501             return true;
1502         }
1503     }
1504 
1505     /**
1506      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1507      *
1508      * startTokenId - the first token id to be transferred
1509      * quantity - the amount to be transferred
1510      *
1511      * Calling conditions:
1512      *
1513      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1514      * transferred to `to`.
1515      * - When `from` is zero, `tokenId` will be minted for `to`.
1516      */
1517     function _beforeTokenTransfers(
1518         address from,
1519         address to,
1520         uint256 startTokenId,
1521         uint256 quantity
1522     ) internal virtual {}
1523 
1524     /**
1525      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1526      * minting.
1527      *
1528      * startTokenId - the first token id to be transferred
1529      * quantity - the amount to be transferred
1530      *
1531      * Calling conditions:
1532      *
1533      * - when `from` and `to` are both non-zero.
1534      * - `from` and `to` are never both zero.
1535      */
1536     function _afterTokenTransfers(
1537         address from,
1538         address to,
1539         uint256 startTokenId,
1540         uint256 quantity
1541     ) internal virtual {}
1542 }
1543 
1544 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1545 
1546 pragma solidity ^0.8.0;
1547 
1548 /**
1549  * @dev Contract module that helps prevent reentrant calls to a function.
1550  *
1551  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1552  * available, which can be applied to functions to make sure there are no nested
1553  * (reentrant) calls to them.
1554  *
1555  * Note that because there is a single `nonReentrant` guard, functions marked as
1556  * `nonReentrant` may not call one another. This can be worked around by making
1557  * those functions `private`, and then adding `external` `nonReentrant` entry
1558  * points to them.
1559  *
1560  * TIP: If you would like to learn more about reentrancy and alternative ways
1561  * to protect against it, check out our blog post
1562  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1563  */
1564 abstract contract ReentrancyGuard {
1565     // Booleans are more expensive than uint256 or any type that takes up a full
1566     // word because each write operation emits an extra SLOAD to first read the
1567     // slot's contents, replace the bits taken up by the boolean, and then write
1568     // back. This is the compiler's defense against contract upgrades and
1569     // pointer aliasing, and it cannot be disabled.
1570 
1571     // The values being non-zero value makes deployment a bit more expensive,
1572     // but in exchange the refund on every call to nonReentrant will be lower in
1573     // amount. Since refunds are capped to a percentage of the total
1574     // transaction's gas, it is best to keep them low in cases like this one, to
1575     // increase the likelihood of the full refund coming into effect.
1576     uint256 private constant _NOT_ENTERED = 1;
1577     uint256 private constant _ENTERED = 2;
1578 
1579     uint256 private _status;
1580 
1581     constructor() {
1582         _status = _NOT_ENTERED;
1583     }
1584 
1585     /**
1586      * @dev Prevents a contract from calling itself, directly or indirectly.
1587      * Calling a `nonReentrant` function from another `nonReentrant`
1588      * function is not supported. It is possible to prevent this from happening
1589      * by making the `nonReentrant` function external, and making it call a
1590      * `private` function that does the actual work.
1591      */
1592     modifier nonReentrant() {
1593         // On the first call to nonReentrant, _notEntered will be true
1594         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1595 
1596         // Any calls to nonReentrant after this point will fail
1597         _status = _ENTERED;
1598 
1599         _;
1600 
1601         // By storing the original value once again, a refund is triggered (see
1602         // https://eips.ethereum.org/EIPS/eip-2200)
1603         _status = _NOT_ENTERED;
1604     }
1605 }
1606 
1607 pragma solidity ^0.8.2;
1608 
1609 contract goblintownNFT is ERC721A, Ownable, ReentrancyGuard {  
1610     using Strings for uint256;
1611     string public _partslink;
1612     bool public byebye = false;
1613     uint256 public goblins = 9999;
1614     uint256 public goblinbyebye = 1; 
1615     mapping(address => uint256) public howmanygobblins;
1616    
1617 	constructor() ERC721A("goblintown", "GOBLIN") {}
1618 
1619     function _baseURI() internal view virtual override returns (string memory) {
1620         return _partslink;
1621     }
1622 
1623  	function makingobblin() external nonReentrant {
1624   	    uint256 totalgobnlinsss = totalSupply();
1625         require(byebye);
1626         require(totalgobnlinsss + goblinbyebye <= goblins);
1627         require(msg.sender == tx.origin);
1628     	require(howmanygobblins[msg.sender] < goblinbyebye);
1629         _safeMint(msg.sender, goblinbyebye);
1630         howmanygobblins[msg.sender] += goblinbyebye;
1631     }
1632 
1633  	function makegoblinnnfly(address lords, uint256 _goblins) public onlyOwner {
1634   	    uint256 totalgobnlinsss = totalSupply();
1635 	    require(totalgobnlinsss + _goblins <= goblins);
1636         _safeMint(lords, _goblins);
1637     }
1638 
1639     function makegoblngobyebye(bool _bye) external onlyOwner {
1640         byebye = _bye;
1641     }
1642 
1643     function spredgobblins(uint256 _byebye) external onlyOwner {
1644         goblinbyebye = _byebye;
1645     }
1646 
1647     function makegobblinhaveparts(string memory parts) external onlyOwner {
1648         _partslink = parts;
1649     }
1650 
1651     function sumthinboutfunds() public payable onlyOwner {
1652 	(bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1653 		require(success);
1654 	}
1655 }