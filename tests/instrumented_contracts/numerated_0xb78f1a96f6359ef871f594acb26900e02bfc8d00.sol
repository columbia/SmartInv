1 // SPDX-License-Identifier: MIT
2 /*
3 
4  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄ 
5 ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
6 ▐░█▀▀▀▀▀▀▀█░▌ ▀▀▀▀█░█▀▀▀▀ ▐░█▀▀▀▀▀▀▀▀▀ 
7 ▐░▌       ▐░▌     ▐░▌     ▐░▌          
8 ▐░█▄▄▄▄▄▄▄█░▌     ▐░▌     ▐░▌          
9 ▐░░░░░░░░░░░▌     ▐░▌     ▐░▌          
10 ▐░█▀▀▀▀▀▀▀█░▌     ▐░▌     ▐░▌          
11 ▐░▌       ▐░▌     ▐░▌     ▐░▌          
12 ▐░▌       ▐░▌ ▄▄▄▄█░█▄▄▄▄ ▐░█▄▄▄▄▄▄▄▄▄ 
13 ▐░▌       ▐░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌
14  ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀▀▀▀▀ 
15                                        
16            By Devko.dev#7286
17  */
18 
19 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
20 
21 pragma solidity ^0.8.0;
22 
23 /**
24  * @title Counters
25  * @author Matt Condon (@shrugs)
26  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
27  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
28  *
29  * Include with `using Counters for Counters.Counter;`
30  */
31 library Counters {
32     struct Counter {
33         // This variable should never be directly accessed by users of the library: interactions must be restricted to
34         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
35         // this feature: see https://github.com/ethereum/solidity/issues/4637
36         uint256 _value; // default: 0
37     }
38 
39     function current(Counter storage counter) internal view returns (uint256) {
40         return counter._value;
41     }
42 
43     function increment(Counter storage counter) internal {
44         unchecked {
45             counter._value += 1;
46         }
47     }
48 
49     function decrement(Counter storage counter) internal {
50         uint256 value = counter._value;
51         require(value > 0, "Counter: decrement overflow");
52         unchecked {
53             counter._value = value - 1;
54         }
55     }
56 
57     function reset(Counter storage counter) internal {
58         counter._value = 0;
59     }
60 }
61 
62 
63 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
64 
65 pragma solidity ^0.8.0;
66 
67 /**
68  * @dev String operations.
69  */
70 library Strings {
71     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
72 
73     /**
74      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
75      */
76     function toString(uint256 value) internal pure returns (string memory) {
77         // Inspired by OraclizeAPI's implementation - MIT licence
78         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
79 
80         if (value == 0) {
81             return "0";
82         }
83         uint256 temp = value;
84         uint256 digits;
85         while (temp != 0) {
86             digits++;
87             temp /= 10;
88         }
89         bytes memory buffer = new bytes(digits);
90         while (value != 0) {
91             digits -= 1;
92             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
93             value /= 10;
94         }
95         return string(buffer);
96     }
97 
98     /**
99      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
100      */
101     function toHexString(uint256 value) internal pure returns (string memory) {
102         if (value == 0) {
103             return "0x00";
104         }
105         uint256 temp = value;
106         uint256 length = 0;
107         while (temp != 0) {
108             length++;
109             temp >>= 8;
110         }
111         return toHexString(value, length);
112     }
113 
114     /**
115      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
116      */
117     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
118         bytes memory buffer = new bytes(2 * length + 2);
119         buffer[0] = "0";
120         buffer[1] = "x";
121         for (uint256 i = 2 * length + 1; i > 1; --i) {
122             buffer[i] = _HEX_SYMBOLS[value & 0xf];
123             value >>= 4;
124         }
125         require(value == 0, "Strings: hex length insufficient");
126         return string(buffer);
127     }
128 }
129 
130 
131 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
132 
133 pragma solidity ^0.8.0;
134 
135 
136 /**
137  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
138  *
139  * These functions can be used to verify that a message was signed by the holder
140  * of the private keys of a given address.
141  */
142 library ECDSA {
143     enum RecoverError {
144         NoError,
145         InvalidSignature,
146         InvalidSignatureLength,
147         InvalidSignatureS,
148         InvalidSignatureV
149     }
150 
151     function _throwError(RecoverError error) private pure {
152         if (error == RecoverError.NoError) {
153             return; // no error: do nothing
154         } else if (error == RecoverError.InvalidSignature) {
155             revert("ECDSA: invalid signature");
156         } else if (error == RecoverError.InvalidSignatureLength) {
157             revert("ECDSA: invalid signature length");
158         } else if (error == RecoverError.InvalidSignatureS) {
159             revert("ECDSA: invalid signature 's' value");
160         } else if (error == RecoverError.InvalidSignatureV) {
161             revert("ECDSA: invalid signature 'v' value");
162         }
163     }
164 
165     /**
166      * @dev Returns the address that signed a hashed message (`hash`) with
167      * `signature` or error string. This address can then be used for verification purposes.
168      *
169      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
170      * this function rejects them by requiring the `s` value to be in the lower
171      * half order, and the `v` value to be either 27 or 28.
172      *
173      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
174      * verification to be secure: it is possible to craft signatures that
175      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
176      * this is by receiving a hash of the original message (which may otherwise
177      * be too long), and then calling {toEthSignedMessageHash} on it.
178      *
179      * Documentation for signature generation:
180      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
181      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
182      *
183      * _Available since v4.3._
184      */
185     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
186         // Check the signature length
187         // - case 65: r,s,v signature (standard)
188         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
189         if (signature.length == 65) {
190             bytes32 r;
191             bytes32 s;
192             uint8 v;
193             // ecrecover takes the signature parameters, and the only way to get them
194             // currently is to use assembly.
195             assembly {
196                 r := mload(add(signature, 0x20))
197                 s := mload(add(signature, 0x40))
198                 v := byte(0, mload(add(signature, 0x60)))
199             }
200             return tryRecover(hash, v, r, s);
201         } else if (signature.length == 64) {
202             bytes32 r;
203             bytes32 vs;
204             // ecrecover takes the signature parameters, and the only way to get them
205             // currently is to use assembly.
206             assembly {
207                 r := mload(add(signature, 0x20))
208                 vs := mload(add(signature, 0x40))
209             }
210             return tryRecover(hash, r, vs);
211         } else {
212             return (address(0), RecoverError.InvalidSignatureLength);
213         }
214     }
215 
216     /**
217      * @dev Returns the address that signed a hashed message (`hash`) with
218      * `signature`. This address can then be used for verification purposes.
219      *
220      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
221      * this function rejects them by requiring the `s` value to be in the lower
222      * half order, and the `v` value to be either 27 or 28.
223      *
224      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
225      * verification to be secure: it is possible to craft signatures that
226      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
227      * this is by receiving a hash of the original message (which may otherwise
228      * be too long), and then calling {toEthSignedMessageHash} on it.
229      */
230     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
231         (address recovered, RecoverError error) = tryRecover(hash, signature);
232         _throwError(error);
233         return recovered;
234     }
235 
236     /**
237      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
238      *
239      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
240      *
241      * _Available since v4.3._
242      */
243     function tryRecover(
244         bytes32 hash,
245         bytes32 r,
246         bytes32 vs
247     ) internal pure returns (address, RecoverError) {
248         bytes32 s;
249         uint8 v;
250         assembly {
251             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
252             v := add(shr(255, vs), 27)
253         }
254         return tryRecover(hash, v, r, s);
255     }
256 
257     /**
258      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
259      *
260      * _Available since v4.2._
261      */
262     function recover(
263         bytes32 hash,
264         bytes32 r,
265         bytes32 vs
266     ) internal pure returns (address) {
267         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
268         _throwError(error);
269         return recovered;
270     }
271 
272     /**
273      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
274      * `r` and `s` signature fields separately.
275      *
276      * _Available since v4.3._
277      */
278     function tryRecover(
279         bytes32 hash,
280         uint8 v,
281         bytes32 r,
282         bytes32 s
283     ) internal pure returns (address, RecoverError) {
284         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
285         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
286         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
287         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
288         //
289         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
290         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
291         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
292         // these malleable signatures as well.
293         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
294             return (address(0), RecoverError.InvalidSignatureS);
295         }
296         if (v != 27 && v != 28) {
297             return (address(0), RecoverError.InvalidSignatureV);
298         }
299 
300         // If the signature is valid (and not malleable), return the signer address
301         address signer = ecrecover(hash, v, r, s);
302         if (signer == address(0)) {
303             return (address(0), RecoverError.InvalidSignature);
304         }
305 
306         return (signer, RecoverError.NoError);
307     }
308 
309     /**
310      * @dev Overload of {ECDSA-recover} that receives the `v`,
311      * `r` and `s` signature fields separately.
312      */
313     function recover(
314         bytes32 hash,
315         uint8 v,
316         bytes32 r,
317         bytes32 s
318     ) internal pure returns (address) {
319         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
320         _throwError(error);
321         return recovered;
322     }
323 
324     /**
325      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
326      * produces hash corresponding to the one signed with the
327      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
328      * JSON-RPC method as part of EIP-191.
329      *
330      * See {recover}.
331      */
332     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
333         // 32 is the length in bytes of hash,
334         // enforced by the type signature above
335         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
336     }
337 
338     /**
339      * @dev Returns an Ethereum Signed Message, created from `s`. This
340      * produces hash corresponding to the one signed with the
341      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
342      * JSON-RPC method as part of EIP-191.
343      *
344      * See {recover}.
345      */
346     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
347         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
348     }
349 
350     /**
351      * @dev Returns an Ethereum Signed Typed Data, created from a
352      * `domainSeparator` and a `structHash`. This produces hash corresponding
353      * to the one signed with the
354      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
355      * JSON-RPC method as part of EIP-712.
356      *
357      * See {recover}.
358      */
359     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
360         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
361     }
362 }
363 
364 
365 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
366 
367 pragma solidity ^0.8.0;
368 
369 /**
370  * @dev Provides information about the current execution context, including the
371  * sender of the transaction and its data. While these are generally available
372  * via msg.sender and msg.data, they should not be accessed in such a direct
373  * manner, since when dealing with meta-transactions the account sending and
374  * paying for execution may not be the actual sender (as far as an application
375  * is concerned).
376  *
377  * This contract is only required for intermediate, library-like contracts.
378  */
379 abstract contract Context {
380     function _msgSender() internal view virtual returns (address) {
381         return msg.sender;
382     }
383 
384     function _msgData() internal view virtual returns (bytes calldata) {
385         return msg.data;
386     }
387 }
388 
389 
390 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
391 
392 pragma solidity ^0.8.0;
393 
394 
395 /**
396  * @dev Contract module which provides a basic access control mechanism, where
397  * there is an account (an owner) that can be granted exclusive access to
398  * specific functions.
399  *
400  * By default, the owner account will be the one that deploys the contract. This
401  * can later be changed with {transferOwnership}.
402  *
403  * This module is used through inheritance. It will make available the modifier
404  * `onlyOwner`, which can be applied to your functions to restrict their use to
405  * the owner.
406  */
407 abstract contract Ownable is Context {
408     address private _owner;
409 
410     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
411 
412     /**
413      * @dev Initializes the contract setting the deployer as the initial owner.
414      */
415     constructor() {
416         _transferOwnership(_msgSender());
417     }
418 
419     /**
420      * @dev Returns the address of the current owner.
421      */
422     function owner() public view virtual returns (address) {
423         return _owner;
424     }
425 
426     /**
427      * @dev Throws if called by any account other than the owner.
428      */
429     modifier onlyOwner() {
430         require(owner() == _msgSender(), "Ownable: caller is not the owner");
431         _;
432     }
433 
434     /**
435      * @dev Leaves the contract without owner. It will not be possible to call
436      * `onlyOwner` functions anymore. Can only be called by the current owner.
437      *
438      * NOTE: Renouncing ownership will leave the contract without an owner,
439      * thereby removing any functionality that is only available to the owner.
440      */
441     function renounceOwnership() public virtual onlyOwner {
442         _transferOwnership(address(0));
443     }
444 
445     /**
446      * @dev Transfers ownership of the contract to a new account (`newOwner`).
447      * Can only be called by the current owner.
448      */
449     function transferOwnership(address newOwner) public virtual onlyOwner {
450         require(newOwner != address(0), "Ownable: new owner is the zero address");
451         _transferOwnership(newOwner);
452     }
453 
454     /**
455      * @dev Transfers ownership of the contract to a new account (`newOwner`).
456      * Internal function without access restriction.
457      */
458     function _transferOwnership(address newOwner) internal virtual {
459         address oldOwner = _owner;
460         _owner = newOwner;
461         emit OwnershipTransferred(oldOwner, newOwner);
462     }
463 }
464 
465 
466 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
467 
468 pragma solidity ^0.8.0;
469 
470 /**
471  * @dev Collection of functions related to the address type
472  */
473 library Address {
474     /**
475      * @dev Returns true if `account` is a contract.
476      *
477      * [IMPORTANT]
478      * ====
479      * It is unsafe to assume that an address for which this function returns
480      * false is an externally-owned account (EOA) and not a contract.
481      *
482      * Among others, `isContract` will return false for the following
483      * types of addresses:
484      *
485      *  - an externally-owned account
486      *  - a contract in construction
487      *  - an address where a contract will be created
488      *  - an address where a contract lived, but was destroyed
489      * ====
490      */
491     function isContract(address account) internal view returns (bool) {
492         // This method relies on extcodesize, which returns 0 for contracts in
493         // construction, since the code is only stored at the end of the
494         // constructor execution.
495 
496         uint256 size;
497         assembly {
498             size := extcodesize(account)
499         }
500         return size > 0;
501     }
502 
503     /**
504      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
505      * `recipient`, forwarding all available gas and reverting on errors.
506      *
507      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
508      * of certain opcodes, possibly making contracts go over the 2300 gas limit
509      * imposed by `transfer`, making them unable to receive funds via
510      * `transfer`. {sendValue} removes this limitation.
511      *
512      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
513      *
514      * IMPORTANT: because control is transferred to `recipient`, care must be
515      * taken to not create reentrancy vulnerabilities. Consider using
516      * {ReentrancyGuard} or the
517      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
518      */
519     function sendValue(address payable recipient, uint256 amount) internal {
520         require(address(this).balance >= amount, "Address: insufficient balance");
521 
522         (bool success, ) = recipient.call{value: amount}("");
523         require(success, "Address: unable to send value, recipient may have reverted");
524     }
525 
526     /**
527      * @dev Performs a Solidity function call using a low level `call`. A
528      * plain `call` is an unsafe replacement for a function call: use this
529      * function instead.
530      *
531      * If `target` reverts with a revert reason, it is bubbled up by this
532      * function (like regular Solidity function calls).
533      *
534      * Returns the raw returned data. To convert to the expected return value,
535      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
536      *
537      * Requirements:
538      *
539      * - `target` must be a contract.
540      * - calling `target` with `data` must not revert.
541      *
542      * _Available since v3.1._
543      */
544     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
545         return functionCall(target, data, "Address: low-level call failed");
546     }
547 
548     /**
549      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
550      * `errorMessage` as a fallback revert reason when `target` reverts.
551      *
552      * _Available since v3.1._
553      */
554     function functionCall(
555         address target,
556         bytes memory data,
557         string memory errorMessage
558     ) internal returns (bytes memory) {
559         return functionCallWithValue(target, data, 0, errorMessage);
560     }
561 
562     /**
563      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
564      * but also transferring `value` wei to `target`.
565      *
566      * Requirements:
567      *
568      * - the calling contract must have an ETH balance of at least `value`.
569      * - the called Solidity function must be `payable`.
570      *
571      * _Available since v3.1._
572      */
573     function functionCallWithValue(
574         address target,
575         bytes memory data,
576         uint256 value
577     ) internal returns (bytes memory) {
578         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
579     }
580 
581     /**
582      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
583      * with `errorMessage` as a fallback revert reason when `target` reverts.
584      *
585      * _Available since v3.1._
586      */
587     function functionCallWithValue(
588         address target,
589         bytes memory data,
590         uint256 value,
591         string memory errorMessage
592     ) internal returns (bytes memory) {
593         require(address(this).balance >= value, "Address: insufficient balance for call");
594         require(isContract(target), "Address: call to non-contract");
595 
596         (bool success, bytes memory returndata) = target.call{value: value}(data);
597         return verifyCallResult(success, returndata, errorMessage);
598     }
599 
600     /**
601      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
602      * but performing a static call.
603      *
604      * _Available since v3.3._
605      */
606     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
607         return functionStaticCall(target, data, "Address: low-level static call failed");
608     }
609 
610     /**
611      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
612      * but performing a static call.
613      *
614      * _Available since v3.3._
615      */
616     function functionStaticCall(
617         address target,
618         bytes memory data,
619         string memory errorMessage
620     ) internal view returns (bytes memory) {
621         require(isContract(target), "Address: static call to non-contract");
622 
623         (bool success, bytes memory returndata) = target.staticcall(data);
624         return verifyCallResult(success, returndata, errorMessage);
625     }
626 
627     /**
628      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
629      * but performing a delegate call.
630      *
631      * _Available since v3.4._
632      */
633     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
634         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
635     }
636 
637     /**
638      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
639      * but performing a delegate call.
640      *
641      * _Available since v3.4._
642      */
643     function functionDelegateCall(
644         address target,
645         bytes memory data,
646         string memory errorMessage
647     ) internal returns (bytes memory) {
648         require(isContract(target), "Address: delegate call to non-contract");
649 
650         (bool success, bytes memory returndata) = target.delegatecall(data);
651         return verifyCallResult(success, returndata, errorMessage);
652     }
653 
654     /**
655      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
656      * revert reason using the provided one.
657      *
658      * _Available since v4.3._
659      */
660     function verifyCallResult(
661         bool success,
662         bytes memory returndata,
663         string memory errorMessage
664     ) internal pure returns (bytes memory) {
665         if (success) {
666             return returndata;
667         } else {
668             // Look for revert reason and bubble it up if present
669             if (returndata.length > 0) {
670                 // The easiest way to bubble the revert reason is using memory via assembly
671 
672                 assembly {
673                     let returndata_size := mload(returndata)
674                     revert(add(32, returndata), returndata_size)
675                 }
676             } else {
677                 revert(errorMessage);
678             }
679         }
680     }
681 }
682 
683 
684 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
685 
686 pragma solidity ^0.8.0;
687 
688 /**
689  * @title ERC721 token receiver interface
690  * @dev Interface for any contract that wants to support safeTransfers
691  * from ERC721 asset contracts.
692  */
693 interface IERC721Receiver {
694     /**
695      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
696      * by `operator` from `from`, this function is called.
697      *
698      * It must return its Solidity selector to confirm the token transfer.
699      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
700      *
701      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
702      */
703     function onERC721Received(
704         address operator,
705         address from,
706         uint256 tokenId,
707         bytes calldata data
708     ) external returns (bytes4);
709 }
710 
711 
712 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
713 
714 pragma solidity ^0.8.0;
715 
716 /**
717  * @dev Interface of the ERC165 standard, as defined in the
718  * https://eips.ethereum.org/EIPS/eip-165[EIP].
719  *
720  * Implementers can declare support of contract interfaces, which can then be
721  * queried by others ({ERC165Checker}).
722  *
723  * For an implementation, see {ERC165}.
724  */
725 interface IERC165 {
726     /**
727      * @dev Returns true if this contract implements the interface defined by
728      * `interfaceId`. See the corresponding
729      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
730      * to learn more about how these ids are created.
731      *
732      * This function call must use less than 30 000 gas.
733      */
734     function supportsInterface(bytes4 interfaceId) external view returns (bool);
735 }
736 
737 
738 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
739 
740 pragma solidity ^0.8.0;
741 
742 
743 /**
744  * @dev Implementation of the {IERC165} interface.
745  *
746  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
747  * for the additional interface id that will be supported. For example:
748  *
749  * ```solidity
750  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
751  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
752  * }
753  * ```
754  *
755  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
756  */
757 abstract contract ERC165 is IERC165 {
758     /**
759      * @dev See {IERC165-supportsInterface}.
760      */
761     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
762         return interfaceId == type(IERC165).interfaceId;
763     }
764 }
765 
766 
767 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
768 
769 pragma solidity ^0.8.0;
770 
771 
772 /**
773  * @dev Required interface of an ERC721 compliant contract.
774  */
775 interface IERC721 is IERC165 {
776     /**
777      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
778      */
779     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
780 
781     /**
782      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
783      */
784     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
785 
786     /**
787      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
788      */
789     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
790 
791     /**
792      * @dev Returns the number of tokens in ``owner``'s account.
793      */
794     function balanceOf(address owner) external view returns (uint256 balance);
795 
796     /**
797      * @dev Returns the owner of the `tokenId` token.
798      *
799      * Requirements:
800      *
801      * - `tokenId` must exist.
802      */
803     function ownerOf(uint256 tokenId) external view returns (address owner);
804 
805     /**
806      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
807      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
808      *
809      * Requirements:
810      *
811      * - `from` cannot be the zero address.
812      * - `to` cannot be the zero address.
813      * - `tokenId` token must exist and be owned by `from`.
814      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
815      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
816      *
817      * Emits a {Transfer} event.
818      */
819     function safeTransferFrom(
820         address from,
821         address to,
822         uint256 tokenId
823     ) external;
824 
825     /**
826      * @dev Transfers `tokenId` token from `from` to `to`.
827      *
828      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
829      *
830      * Requirements:
831      *
832      * - `from` cannot be the zero address.
833      * - `to` cannot be the zero address.
834      * - `tokenId` token must be owned by `from`.
835      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
836      *
837      * Emits a {Transfer} event.
838      */
839     function transferFrom(
840         address from,
841         address to,
842         uint256 tokenId
843     ) external;
844 
845     /**
846      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
847      * The approval is cleared when the token is transferred.
848      *
849      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
850      *
851      * Requirements:
852      *
853      * - The caller must own the token or be an approved operator.
854      * - `tokenId` must exist.
855      *
856      * Emits an {Approval} event.
857      */
858     function approve(address to, uint256 tokenId) external;
859 
860     /**
861      * @dev Returns the account approved for `tokenId` token.
862      *
863      * Requirements:
864      *
865      * - `tokenId` must exist.
866      */
867     function getApproved(uint256 tokenId) external view returns (address operator);
868 
869     /**
870      * @dev Approve or remove `operator` as an operator for the caller.
871      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
872      *
873      * Requirements:
874      *
875      * - The `operator` cannot be the caller.
876      *
877      * Emits an {ApprovalForAll} event.
878      */
879     function setApprovalForAll(address operator, bool _approved) external;
880 
881     /**
882      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
883      *
884      * See {setApprovalForAll}
885      */
886     function isApprovedForAll(address owner, address operator) external view returns (bool);
887 
888     /**
889      * @dev Safely transfers `tokenId` token from `from` to `to`.
890      *
891      * Requirements:
892      *
893      * - `from` cannot be the zero address.
894      * - `to` cannot be the zero address.
895      * - `tokenId` token must exist and be owned by `from`.
896      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
897      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
898      *
899      * Emits a {Transfer} event.
900      */
901     function safeTransferFrom(
902         address from,
903         address to,
904         uint256 tokenId,
905         bytes calldata data
906     ) external;
907 }
908 
909 
910 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
911 
912 pragma solidity ^0.8.0;
913 
914 
915 /**
916  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
917  * @dev See https://eips.ethereum.org/EIPS/eip-721
918  */
919 interface IERC721Metadata is IERC721 {
920     /**
921      * @dev Returns the token collection name.
922      */
923     function name() external view returns (string memory);
924 
925     /**
926      * @dev Returns the token collection symbol.
927      */
928     function symbol() external view returns (string memory);
929 
930     /**
931      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
932      */
933     function tokenURI(uint256 tokenId) external view returns (string memory);
934 }
935 
936 
937 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
938 
939 pragma solidity ^0.8.0;
940 
941 
942 
943 
944 
945 
946 
947 
948 /**
949  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
950  * the Metadata extension, but not including the Enumerable extension, which is available separately as
951  * {ERC721Enumerable}.
952  */
953 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
954     using Address for address;
955     using Strings for uint256;
956 
957     // Token name
958     string private _name;
959 
960     // Token symbol
961     string private _symbol;
962 
963     // Mapping from token ID to owner address
964     mapping(uint256 => address) private _owners;
965 
966     // Mapping owner address to token count
967     mapping(address => uint256) private _balances;
968 
969     // Mapping from token ID to approved address
970     mapping(uint256 => address) private _tokenApprovals;
971 
972     // Mapping from owner to operator approvals
973     mapping(address => mapping(address => bool)) private _operatorApprovals;
974 
975     /**
976      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
977      */
978     constructor(string memory name_, string memory symbol_) {
979         _name = name_;
980         _symbol = symbol_;
981     }
982 
983     /**
984      * @dev See {IERC165-supportsInterface}.
985      */
986     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
987         return
988             interfaceId == type(IERC721).interfaceId ||
989             interfaceId == type(IERC721Metadata).interfaceId ||
990             super.supportsInterface(interfaceId);
991     }
992 
993     /**
994      * @dev See {IERC721-balanceOf}.
995      */
996     function balanceOf(address owner) public view virtual override returns (uint256) {
997         require(owner != address(0), "ERC721: balance query for the zero address");
998         return _balances[owner];
999     }
1000 
1001     /**
1002      * @dev See {IERC721-ownerOf}.
1003      */
1004     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1005         address owner = _owners[tokenId];
1006         require(owner != address(0), "ERC721: owner query for nonexistent token");
1007         return owner;
1008     }
1009 
1010     /**
1011      * @dev See {IERC721Metadata-name}.
1012      */
1013     function name() public view virtual override returns (string memory) {
1014         return _name;
1015     }
1016 
1017     /**
1018      * @dev See {IERC721Metadata-symbol}.
1019      */
1020     function symbol() public view virtual override returns (string memory) {
1021         return _symbol;
1022     }
1023 
1024     /**
1025      * @dev See {IERC721Metadata-tokenURI}.
1026      */
1027     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1028         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1029 
1030         string memory baseURI = _baseURI();
1031         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1032     }
1033 
1034     /**
1035      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1036      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1037      * by default, can be overriden in child contracts.
1038      */
1039     function _baseURI() internal view virtual returns (string memory) {
1040         return "";
1041     }
1042 
1043     /**
1044      * @dev See {IERC721-approve}.
1045      */
1046     function approve(address to, uint256 tokenId) public virtual override {
1047         address owner = ERC721.ownerOf(tokenId);
1048         require(to != owner, "ERC721: approval to current owner");
1049 
1050         require(
1051             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1052             "ERC721: approve caller is not owner nor approved for all"
1053         );
1054 
1055         _approve(to, tokenId);
1056     }
1057 
1058     /**
1059      * @dev See {IERC721-getApproved}.
1060      */
1061     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1062         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1063 
1064         return _tokenApprovals[tokenId];
1065     }
1066 
1067     /**
1068      * @dev See {IERC721-setApprovalForAll}.
1069      */
1070     function setApprovalForAll(address operator, bool approved) public virtual override {
1071         _setApprovalForAll(_msgSender(), operator, approved);
1072     }
1073 
1074     /**
1075      * @dev See {IERC721-isApprovedForAll}.
1076      */
1077     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1078         return _operatorApprovals[owner][operator];
1079     }
1080 
1081     /**
1082      * @dev See {IERC721-transferFrom}.
1083      */
1084     function transferFrom(
1085         address from,
1086         address to,
1087         uint256 tokenId
1088     ) public virtual override {
1089         //solhint-disable-next-line max-line-length
1090         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1091 
1092         _transfer(from, to, tokenId);
1093     }
1094 
1095     /**
1096      * @dev See {IERC721-safeTransferFrom}.
1097      */
1098     function safeTransferFrom(
1099         address from,
1100         address to,
1101         uint256 tokenId
1102     ) public virtual override {
1103         safeTransferFrom(from, to, tokenId, "");
1104     }
1105 
1106     /**
1107      * @dev See {IERC721-safeTransferFrom}.
1108      */
1109     function safeTransferFrom(
1110         address from,
1111         address to,
1112         uint256 tokenId,
1113         bytes memory _data
1114     ) public virtual override {
1115         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1116         _safeTransfer(from, to, tokenId, _data);
1117     }
1118 
1119     /**
1120      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1121      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1122      *
1123      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1124      *
1125      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1126      * implement alternative mechanisms to perform token transfer, such as signature-based.
1127      *
1128      * Requirements:
1129      *
1130      * - `from` cannot be the zero address.
1131      * - `to` cannot be the zero address.
1132      * - `tokenId` token must exist and be owned by `from`.
1133      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1134      *
1135      * Emits a {Transfer} event.
1136      */
1137     function _safeTransfer(
1138         address from,
1139         address to,
1140         uint256 tokenId,
1141         bytes memory _data
1142     ) internal virtual {
1143         _transfer(from, to, tokenId);
1144         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1145     }
1146 
1147     /**
1148      * @dev Returns whether `tokenId` exists.
1149      *
1150      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1151      *
1152      * Tokens start existing when they are minted (`_mint`),
1153      * and stop existing when they are burned (`_burn`).
1154      */
1155     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1156         return _owners[tokenId] != address(0);
1157     }
1158 
1159     /**
1160      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1161      *
1162      * Requirements:
1163      *
1164      * - `tokenId` must exist.
1165      */
1166     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1167         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1168         address owner = ERC721.ownerOf(tokenId);
1169         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1170     }
1171 
1172     /**
1173      * @dev Safely mints `tokenId` and transfers it to `to`.
1174      *
1175      * Requirements:
1176      *
1177      * - `tokenId` must not exist.
1178      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1179      *
1180      * Emits a {Transfer} event.
1181      */
1182     function _safeMint(address to, uint256 tokenId) internal virtual {
1183         _safeMint(to, tokenId, "");
1184     }
1185 
1186     /**
1187      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1188      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1189      */
1190     function _safeMint(
1191         address to,
1192         uint256 tokenId,
1193         bytes memory _data
1194     ) internal virtual {
1195         _mint(to, tokenId);
1196         require(
1197             _checkOnERC721Received(address(0), to, tokenId, _data),
1198             "ERC721: transfer to non ERC721Receiver implementer"
1199         );
1200     }
1201 
1202     /**
1203      * @dev Mints `tokenId` and transfers it to `to`.
1204      *
1205      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1206      *
1207      * Requirements:
1208      *
1209      * - `tokenId` must not exist.
1210      * - `to` cannot be the zero address.
1211      *
1212      * Emits a {Transfer} event.
1213      */
1214     function _mint(address to, uint256 tokenId) internal virtual {
1215         require(to != address(0), "ERC721: mint to the zero address");
1216         require(!_exists(tokenId), "ERC721: token already minted");
1217 
1218         _beforeTokenTransfer(address(0), to, tokenId);
1219 
1220         _balances[to] += 1;
1221         _owners[tokenId] = to;
1222 
1223         emit Transfer(address(0), to, tokenId);
1224     }
1225 
1226     /**
1227      * @dev Destroys `tokenId`.
1228      * The approval is cleared when the token is burned.
1229      *
1230      * Requirements:
1231      *
1232      * - `tokenId` must exist.
1233      *
1234      * Emits a {Transfer} event.
1235      */
1236     function _burn(uint256 tokenId) internal virtual {
1237         address owner = ERC721.ownerOf(tokenId);
1238 
1239         _beforeTokenTransfer(owner, address(0), tokenId);
1240 
1241         // Clear approvals
1242         _approve(address(0), tokenId);
1243 
1244         _balances[owner] -= 1;
1245         delete _owners[tokenId];
1246 
1247         emit Transfer(owner, address(0), tokenId);
1248     }
1249 
1250     /**
1251      * @dev Transfers `tokenId` from `from` to `to`.
1252      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1253      *
1254      * Requirements:
1255      *
1256      * - `to` cannot be the zero address.
1257      * - `tokenId` token must be owned by `from`.
1258      *
1259      * Emits a {Transfer} event.
1260      */
1261     function _transfer(
1262         address from,
1263         address to,
1264         uint256 tokenId
1265     ) internal virtual {
1266         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1267         require(to != address(0), "ERC721: transfer to the zero address");
1268 
1269         _beforeTokenTransfer(from, to, tokenId);
1270 
1271         // Clear approvals from the previous owner
1272         _approve(address(0), tokenId);
1273 
1274         _balances[from] -= 1;
1275         _balances[to] += 1;
1276         _owners[tokenId] = to;
1277 
1278         emit Transfer(from, to, tokenId);
1279     }
1280 
1281     /**
1282      * @dev Approve `to` to operate on `tokenId`
1283      *
1284      * Emits a {Approval} event.
1285      */
1286     function _approve(address to, uint256 tokenId) internal virtual {
1287         _tokenApprovals[tokenId] = to;
1288         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1289     }
1290 
1291     /**
1292      * @dev Approve `operator` to operate on all of `owner` tokens
1293      *
1294      * Emits a {ApprovalForAll} event.
1295      */
1296     function _setApprovalForAll(
1297         address owner,
1298         address operator,
1299         bool approved
1300     ) internal virtual {
1301         require(owner != operator, "ERC721: approve to caller");
1302         _operatorApprovals[owner][operator] = approved;
1303         emit ApprovalForAll(owner, operator, approved);
1304     }
1305 
1306     /**
1307      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1308      * The call is not executed if the target address is not a contract.
1309      *
1310      * @param from address representing the previous owner of the given token ID
1311      * @param to target address that will receive the tokens
1312      * @param tokenId uint256 ID of the token to be transferred
1313      * @param _data bytes optional data to send along with the call
1314      * @return bool whether the call correctly returned the expected magic value
1315      */
1316     function _checkOnERC721Received(
1317         address from,
1318         address to,
1319         uint256 tokenId,
1320         bytes memory _data
1321     ) private returns (bool) {
1322         if (to.isContract()) {
1323             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1324                 return retval == IERC721Receiver.onERC721Received.selector;
1325             } catch (bytes memory reason) {
1326                 if (reason.length == 0) {
1327                     revert("ERC721: transfer to non ERC721Receiver implementer");
1328                 } else {
1329                     assembly {
1330                         revert(add(32, reason), mload(reason))
1331                     }
1332                 }
1333             }
1334         } else {
1335             return true;
1336         }
1337     }
1338 
1339     /**
1340      * @dev Hook that is called before any token transfer. This includes minting
1341      * and burning.
1342      *
1343      * Calling conditions:
1344      *
1345      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1346      * transferred to `to`.
1347      * - When `from` is zero, `tokenId` will be minted for `to`.
1348      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1349      * - `from` and `to` are never both zero.
1350      *
1351      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1352      */
1353     function _beforeTokenTransfer(
1354         address from,
1355         address to,
1356         uint256 tokenId
1357     ) internal virtual {}
1358 }
1359 
1360 
1361 pragma solidity ^0.8.7;
1362 
1363 
1364 contract AIC is ERC721, Ownable {
1365 
1366     using Strings for uint256;
1367     using Counters for Counters.Counter;
1368     using ECDSA for bytes32;
1369 
1370     string private _tokenBaseURI = "https://gateway.pinata.cloud/ipfs/Qmbo3azCxkdtqfYNcf981itDsL44kb3jTtRLTSPpSJ2ZNJ/";
1371     uint256 public AIC_MAX = 314;
1372     uint256 public AIC_PRICE = 0.25 ether;
1373 
1374     mapping(address => bool) public MINTERS_LIST;
1375     address private SIGNER = 0x7F83ddA23f8001C5c6323C1b205C7f53102AbF32;
1376     string private constant SIG_WORD = "AIC_SALE";
1377     bool public mintLive;
1378 
1379     Counters.Counter private _tokensMinted;
1380 
1381     constructor() ERC721("AIC", "AIC") {
1382         for(uint256 i = 0; i < 4; i++) {
1383             _tokensMinted.increment();
1384             _safeMint(msg.sender, _tokensMinted.current());
1385         }
1386     }
1387     
1388     function gift(address[] calldata receivers) external onlyOwner {
1389         require(_tokensMinted.current() + receivers.length <= AIC_MAX, "EXCEED_MAX");
1390         for (uint256 i = 0; i < receivers.length; i++) {
1391             _tokensMinted.increment();
1392             _safeMint(receivers[i], _tokensMinted.current());
1393         }
1394     }
1395 
1396     function matchAddresSigner(bytes memory signature) private view returns(bool) {
1397          bytes32 hash = keccak256(abi.encodePacked(
1398             "\x19Ethereum Signed Message:\n32",
1399             keccak256(abi.encodePacked(msg.sender, SIG_WORD)))
1400           );
1401         return SIGNER == hash.recover(signature);
1402     }   
1403 
1404     function mint(bytes memory signature) external payable {
1405         require(mintLive, "MINT_CLOSED");
1406         require(matchAddresSigner(signature), "DIRECT_MINT_DISALLOWED");
1407         require(_tokensMinted.current() + 1 <= AIC_MAX, "EXCEED_MAX");
1408         require(!MINTERS_LIST[msg.sender] , "MINTED_ALREADY");
1409         require(AIC_PRICE <= msg.value, "INSUFFICIENT_ETH");
1410 
1411         MINTERS_LIST[msg.sender] = true;
1412         _tokensMinted.increment();
1413         _safeMint(msg.sender, _tokensMinted.current());
1414     }
1415  
1416     function withdraw() external onlyOwner {
1417         uint256 currentBalance = address(this).balance;
1418         payable(0x3FD45f7fc6da24A360E75aFF9DE577ab5fbdcfE7).transfer(currentBalance * 500 / 1000);
1419         payable(0xbF6c44be5AC250B30726E9405d4fD80Bd16A1ae2).transfer(currentBalance * 115 / 1000);
1420         payable(0x773DAaCda9E4d7C7955BCef1fbF807D318501F44).transfer(currentBalance * 115 / 1000);
1421         payable(0xf05eA4Bcee0245020e9aCF59dFDaF4deD01292a5).transfer(currentBalance * 70  / 1000);
1422         payable(0xbbDC03ab8238eE062fC55673379F905ec1174921).transfer(currentBalance * 100 / 1000);
1423         payable(0x11111F01570EeAA3e5a2Fd51f4A2f127661B9834).transfer(address(this).balance);
1424     }
1425     
1426     function toggleMintStatus() external onlyOwner {
1427         mintLive = !mintLive;
1428     }
1429     
1430     function setBaseURI(string calldata URI) external onlyOwner {
1431         _tokenBaseURI = URI;
1432     }
1433     
1434     function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) {
1435         require(_exists(tokenId), "Cannot query non-existent token");
1436         return string(abi.encodePacked(_tokenBaseURI, tokenId.toString()));
1437     }
1438 
1439     function totalSupply() public view returns (uint256) {
1440         return _tokensMinted.current();
1441     }
1442 
1443     receive() external payable {}
1444 }