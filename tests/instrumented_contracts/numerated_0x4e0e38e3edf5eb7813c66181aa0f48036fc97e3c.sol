1 // SPDX-License-Identifier: MIT
2 //------------------------------------------------------------------------------
3 /*
4 
5 ░██████╗░██╗░░░██╗░█████╗░██╗░░░░░██╗███████╗██╗███████╗██████╗░  ██████╗░███████╗██╗░░░██╗░██████╗
6 ██╔═══██╗██║░░░██║██╔══██╗██║░░░░░██║██╔════╝██║██╔════╝██╔══██╗  ██╔══██╗██╔════╝██║░░░██║██╔════╝
7 ██║██╗██║██║░░░██║███████║██║░░░░░██║█████╗░░██║█████╗░░██║░░██║  ██║░░██║█████╗░░╚██╗░██╔╝╚█████╗░
8 ╚██████╔╝██║░░░██║██╔══██║██║░░░░░██║██╔══╝░░██║██╔══╝░░██║░░██║  ██║░░██║██╔══╝░░░╚████╔╝░░╚═══██╗
9 ░╚═██╔═╝░╚██████╔╝██║░░██║███████╗██║██║░░░░░██║███████╗██████╔╝  ██████╔╝███████╗░░╚██╔╝░░██████╔╝
10 ░░░╚═╝░░░░╚═════╝░╚═╝░░╚═╝╚══════╝╚═╝╚═╝░░░░░╚═╝╚══════╝╚═════╝░  ╚═════╝░╚══════╝░░░╚═╝░░░╚═════╝░
11 */
12 //------------------------------------------------------------------------------
13 // Author: orion (@OrionDevStar)
14 //------------------------------------------------------------------------------
15 
16 // File: @openzeppelin/contracts/utils/Counters.sol
17 
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
62 // File: @openzeppelin/contracts/utils/Strings.sol
63 
64 
65 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
66 
67 pragma solidity ^0.8.0;
68 
69 /**
70  * @dev String operations.
71  */
72 library Strings {
73     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
74 
75     /**
76      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
77      */
78     function toString(uint256 value) internal pure returns (string memory) {
79         // Inspired by OraclizeAPI's implementation - MIT licence
80         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
81 
82         if (value == 0) {
83             return "0";
84         }
85         uint256 temp = value;
86         uint256 digits;
87         while (temp != 0) {
88             digits++;
89             temp /= 10;
90         }
91         bytes memory buffer = new bytes(digits);
92         while (value != 0) {
93             digits -= 1;
94             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
95             value /= 10;
96         }
97         return string(buffer);
98     }
99 
100     /**
101      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
102      */
103     function toHexString(uint256 value) internal pure returns (string memory) {
104         if (value == 0) {
105             return "0x00";
106         }
107         uint256 temp = value;
108         uint256 length = 0;
109         while (temp != 0) {
110             length++;
111             temp >>= 8;
112         }
113         return toHexString(value, length);
114     }
115 
116     /**
117      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
118      */
119     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
120         bytes memory buffer = new bytes(2 * length + 2);
121         buffer[0] = "0";
122         buffer[1] = "x";
123         for (uint256 i = 2 * length + 1; i > 1; --i) {
124             buffer[i] = _HEX_SYMBOLS[value & 0xf];
125             value >>= 4;
126         }
127         require(value == 0, "Strings: hex length insufficient");
128         return string(buffer);
129     }
130 }
131 
132 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
133 
134 
135 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
136 
137 pragma solidity ^0.8.0;
138 
139 
140 /**
141  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
142  *
143  * These functions can be used to verify that a message was signed by the holder
144  * of the private keys of a given address.
145  */
146 library ECDSA {
147     enum RecoverError {
148         NoError,
149         InvalidSignature,
150         InvalidSignatureLength,
151         InvalidSignatureS,
152         InvalidSignatureV
153     }
154 
155     function _throwError(RecoverError error) private pure {
156         if (error == RecoverError.NoError) {
157             return; // no error: do nothing
158         } else if (error == RecoverError.InvalidSignature) {
159             revert("ECDSA: invalid signature");
160         } else if (error == RecoverError.InvalidSignatureLength) {
161             revert("ECDSA: invalid signature length");
162         } else if (error == RecoverError.InvalidSignatureS) {
163             revert("ECDSA: invalid signature 's' value");
164         } else if (error == RecoverError.InvalidSignatureV) {
165             revert("ECDSA: invalid signature 'v' value");
166         }
167     }
168 
169     /**
170      * @dev Returns the address that signed a hashed message (`hash`) with
171      * `signature` or error string. This address can then be used for verification purposes.
172      *
173      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
174      * this function rejects them by requiring the `s` value to be in the lower
175      * half order, and the `v` value to be either 27 or 28.
176      *
177      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
178      * verification to be secure: it is possible to craft signatures that
179      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
180      * this is by receiving a hash of the original message (which may otherwise
181      * be too long), and then calling {toEthSignedMessageHash} on it.
182      *
183      * Documentation for signature generation:
184      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
185      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
186      *
187      * _Available since v4.3._
188      */
189     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
190         // Check the signature length
191         // - case 65: r,s,v signature (standard)
192         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
193         if (signature.length == 65) {
194             bytes32 r;
195             bytes32 s;
196             uint8 v;
197             // ecrecover takes the signature parameters, and the only way to get them
198             // currently is to use assembly.
199             assembly {
200                 r := mload(add(signature, 0x20))
201                 s := mload(add(signature, 0x40))
202                 v := byte(0, mload(add(signature, 0x60)))
203             }
204             return tryRecover(hash, v, r, s);
205         } else if (signature.length == 64) {
206             bytes32 r;
207             bytes32 vs;
208             // ecrecover takes the signature parameters, and the only way to get them
209             // currently is to use assembly.
210             assembly {
211                 r := mload(add(signature, 0x20))
212                 vs := mload(add(signature, 0x40))
213             }
214             return tryRecover(hash, r, vs);
215         } else {
216             return (address(0), RecoverError.InvalidSignatureLength);
217         }
218     }
219 
220     /**
221      * @dev Returns the address that signed a hashed message (`hash`) with
222      * `signature`. This address can then be used for verification purposes.
223      *
224      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
225      * this function rejects them by requiring the `s` value to be in the lower
226      * half order, and the `v` value to be either 27 or 28.
227      *
228      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
229      * verification to be secure: it is possible to craft signatures that
230      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
231      * this is by receiving a hash of the original message (which may otherwise
232      * be too long), and then calling {toEthSignedMessageHash} on it.
233      */
234     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
235         (address recovered, RecoverError error) = tryRecover(hash, signature);
236         _throwError(error);
237         return recovered;
238     }
239 
240     /**
241      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
242      *
243      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
244      *
245      * _Available since v4.3._
246      */
247     function tryRecover(
248         bytes32 hash,
249         bytes32 r,
250         bytes32 vs
251     ) internal pure returns (address, RecoverError) {
252         bytes32 s;
253         uint8 v;
254         assembly {
255             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
256             v := add(shr(255, vs), 27)
257         }
258         return tryRecover(hash, v, r, s);
259     }
260 
261     /**
262      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
263      *
264      * _Available since v4.2._
265      */
266     function recover(
267         bytes32 hash,
268         bytes32 r,
269         bytes32 vs
270     ) internal pure returns (address) {
271         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
272         _throwError(error);
273         return recovered;
274     }
275 
276     /**
277      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
278      * `r` and `s` signature fields separately.
279      *
280      * _Available since v4.3._
281      */
282     function tryRecover(
283         bytes32 hash,
284         uint8 v,
285         bytes32 r,
286         bytes32 s
287     ) internal pure returns (address, RecoverError) {
288         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
289         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
290         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
291         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
292         //
293         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
294         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
295         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
296         // these malleable signatures as well.
297         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
298             return (address(0), RecoverError.InvalidSignatureS);
299         }
300         if (v != 27 && v != 28) {
301             return (address(0), RecoverError.InvalidSignatureV);
302         }
303 
304         // If the signature is valid (and not malleable), return the signer address
305         address signer = ecrecover(hash, v, r, s);
306         if (signer == address(0)) {
307             return (address(0), RecoverError.InvalidSignature);
308         }
309 
310         return (signer, RecoverError.NoError);
311     }
312 
313     /**
314      * @dev Overload of {ECDSA-recover} that receives the `v`,
315      * `r` and `s` signature fields separately.
316      */
317     function recover(
318         bytes32 hash,
319         uint8 v,
320         bytes32 r,
321         bytes32 s
322     ) internal pure returns (address) {
323         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
324         _throwError(error);
325         return recovered;
326     }
327 
328     /**
329      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
330      * produces hash corresponding to the one signed with the
331      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
332      * JSON-RPC method as part of EIP-191.
333      *
334      * See {recover}.
335      */
336     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
337         // 32 is the length in bytes of hash,
338         // enforced by the type signature above
339         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
340     }
341 
342     /**
343      * @dev Returns an Ethereum Signed Message, created from `s`. This
344      * produces hash corresponding to the one signed with the
345      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
346      * JSON-RPC method as part of EIP-191.
347      *
348      * See {recover}.
349      */
350     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
351         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
352     }
353 
354     /**
355      * @dev Returns an Ethereum Signed Typed Data, created from a
356      * `domainSeparator` and a `structHash`. This produces hash corresponding
357      * to the one signed with the
358      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
359      * JSON-RPC method as part of EIP-712.
360      *
361      * See {recover}.
362      */
363     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
364         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
365     }
366 }
367 
368 // File: @openzeppelin/contracts/utils/Context.sol
369 
370 
371 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
372 
373 pragma solidity ^0.8.0;
374 
375 /**
376  * @dev Provides information about the current execution context, including the
377  * sender of the transaction and its data. While these are generally available
378  * via msg.sender and msg.data, they should not be accessed in such a direct
379  * manner, since when dealing with meta-transactions the account sending and
380  * paying for execution may not be the actual sender (as far as an application
381  * is concerned).
382  *
383  * This contract is only required for intermediate, library-like contracts.
384  */
385 abstract contract Context {
386     function _msgSender() internal view virtual returns (address) {
387         return msg.sender;
388     }
389 
390     function _msgData() internal view virtual returns (bytes calldata) {
391         return msg.data;
392     }
393 }
394 
395 // File: @openzeppelin/contracts/access/Ownable.sol
396 
397 
398 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
399 
400 pragma solidity ^0.8.0;
401 
402 
403 /**
404  * @dev Contract module which provides a basic access control mechanism, where
405  * there is an account (an owner) that can be granted exclusive access to
406  * specific functions.
407  *
408  * By default, the owner account will be the one that deploys the contract. This
409  * can later be changed with {transferOwnership}.
410  *
411  * This module is used through inheritance. It will make available the modifier
412  * `onlyOwner`, which can be applied to your functions to restrict their use to
413  * the owner.
414  */
415 abstract contract Ownable is Context {
416     address private _owner;
417 
418     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
419 
420     /**
421      * @dev Initializes the contract setting the deployer as the initial owner.
422      */
423     constructor() {
424         _transferOwnership(_msgSender());
425     }
426 
427     /**
428      * @dev Returns the address of the current owner.
429      */
430     function owner() public view virtual returns (address) {
431         return _owner;
432     }
433 
434     /**
435      * @dev Throws if called by any account other than the owner.
436      */
437     modifier onlyOwner() {
438         require(owner() == _msgSender(), "Ownable: caller is not the owner");
439         _;
440     }
441 
442     /**
443      * @dev Leaves the contract without owner. It will not be possible to call
444      * `onlyOwner` functions anymore. Can only be called by the current owner.
445      *
446      * NOTE: Renouncing ownership will leave the contract without an owner,
447      * thereby removing any functionality that is only available to the owner.
448      */
449     function renounceOwnership() public virtual onlyOwner {
450         _transferOwnership(address(0));
451     }
452 
453     /**
454      * @dev Transfers ownership of the contract to a new account (`newOwner`).
455      * Can only be called by the current owner.
456      */
457     function transferOwnership(address newOwner) public virtual onlyOwner {
458         require(newOwner != address(0), "Ownable: new owner is the zero address");
459         _transferOwnership(newOwner);
460     }
461 
462     /**
463      * @dev Transfers ownership of the contract to a new account (`newOwner`).
464      * Internal function without access restriction.
465      */
466     function _transferOwnership(address newOwner) internal virtual {
467         address oldOwner = _owner;
468         _owner = newOwner;
469         emit OwnershipTransferred(oldOwner, newOwner);
470     }
471 }
472 
473 // File: @openzeppelin/contracts/utils/Address.sol
474 
475 
476 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
477 
478 pragma solidity ^0.8.0;
479 
480 /**
481  * @dev Collection of functions related to the address type
482  */
483 library Address {
484     /**
485      * @dev Returns true if `account` is a contract.
486      *
487      * [IMPORTANT]
488      * ====
489      * It is unsafe to assume that an address for which this function returns
490      * false is an externally-owned account (EOA) and not a contract.
491      *
492      * Among others, `isContract` will return false for the following
493      * types of addresses:
494      *
495      *  - an externally-owned account
496      *  - a contract in construction
497      *  - an address where a contract will be created
498      *  - an address where a contract lived, but was destroyed
499      * ====
500      */
501     function isContract(address account) internal view returns (bool) {
502         // This method relies on extcodesize, which returns 0 for contracts in
503         // construction, since the code is only stored at the end of the
504         // constructor execution.
505 
506         uint256 size;
507         assembly {
508             size := extcodesize(account)
509         }
510         return size > 0;
511     }
512 
513     /**
514      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
515      * `recipient`, forwarding all available gas and reverting on errors.
516      *
517      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
518      * of certain opcodes, possibly making contracts go over the 2300 gas limit
519      * imposed by `transfer`, making them unable to receive funds via
520      * `transfer`. {sendValue} removes this limitation.
521      *
522      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
523      *
524      * IMPORTANT: because control is transferred to `recipient`, care must be
525      * taken to not create reentrancy vulnerabilities. Consider using
526      * {ReentrancyGuard} or the
527      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
528      */
529     function sendValue(address payable recipient, uint256 amount) internal {
530         require(address(this).balance >= amount, "Address: insufficient balance");
531 
532         (bool success, ) = recipient.call{value: amount}("");
533         require(success, "Address: unable to send value, recipient may have reverted");
534     }
535 
536     /**
537      * @dev Performs a Solidity function call using a low level `call`. A
538      * plain `call` is an unsafe replacement for a function call: use this
539      * function instead.
540      *
541      * If `target` reverts with a revert reason, it is bubbled up by this
542      * function (like regular Solidity function calls).
543      *
544      * Returns the raw returned data. To convert to the expected return value,
545      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
546      *
547      * Requirements:
548      *
549      * - `target` must be a contract.
550      * - calling `target` with `data` must not revert.
551      *
552      * _Available since v3.1._
553      */
554     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
555         return functionCall(target, data, "Address: low-level call failed");
556     }
557 
558     /**
559      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
560      * `errorMessage` as a fallback revert reason when `target` reverts.
561      *
562      * _Available since v3.1._
563      */
564     function functionCall(
565         address target,
566         bytes memory data,
567         string memory errorMessage
568     ) internal returns (bytes memory) {
569         return functionCallWithValue(target, data, 0, errorMessage);
570     }
571 
572     /**
573      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
574      * but also transferring `value` wei to `target`.
575      *
576      * Requirements:
577      *
578      * - the calling contract must have an ETH balance of at least `value`.
579      * - the called Solidity function must be `payable`.
580      *
581      * _Available since v3.1._
582      */
583     function functionCallWithValue(
584         address target,
585         bytes memory data,
586         uint256 value
587     ) internal returns (bytes memory) {
588         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
589     }
590 
591     /**
592      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
593      * with `errorMessage` as a fallback revert reason when `target` reverts.
594      *
595      * _Available since v3.1._
596      */
597     function functionCallWithValue(
598         address target,
599         bytes memory data,
600         uint256 value,
601         string memory errorMessage
602     ) internal returns (bytes memory) {
603         require(address(this).balance >= value, "Address: insufficient balance for call");
604         require(isContract(target), "Address: call to non-contract");
605 
606         (bool success, bytes memory returndata) = target.call{value: value}(data);
607         return verifyCallResult(success, returndata, errorMessage);
608     }
609 
610     /**
611      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
612      * but performing a static call.
613      *
614      * _Available since v3.3._
615      */
616     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
617         return functionStaticCall(target, data, "Address: low-level static call failed");
618     }
619 
620     /**
621      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
622      * but performing a static call.
623      *
624      * _Available since v3.3._
625      */
626     function functionStaticCall(
627         address target,
628         bytes memory data,
629         string memory errorMessage
630     ) internal view returns (bytes memory) {
631         require(isContract(target), "Address: static call to non-contract");
632 
633         (bool success, bytes memory returndata) = target.staticcall(data);
634         return verifyCallResult(success, returndata, errorMessage);
635     }
636 
637     /**
638      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
639      * but performing a delegate call.
640      *
641      * _Available since v3.4._
642      */
643     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
644         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
645     }
646 
647     /**
648      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
649      * but performing a delegate call.
650      *
651      * _Available since v3.4._
652      */
653     function functionDelegateCall(
654         address target,
655         bytes memory data,
656         string memory errorMessage
657     ) internal returns (bytes memory) {
658         require(isContract(target), "Address: delegate call to non-contract");
659 
660         (bool success, bytes memory returndata) = target.delegatecall(data);
661         return verifyCallResult(success, returndata, errorMessage);
662     }
663 
664     /**
665      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
666      * revert reason using the provided one.
667      *
668      * _Available since v4.3._
669      */
670     function verifyCallResult(
671         bool success,
672         bytes memory returndata,
673         string memory errorMessage
674     ) internal pure returns (bytes memory) {
675         if (success) {
676             return returndata;
677         } else {
678             // Look for revert reason and bubble it up if present
679             if (returndata.length > 0) {
680                 // The easiest way to bubble the revert reason is using memory via assembly
681 
682                 assembly {
683                     let returndata_size := mload(returndata)
684                     revert(add(32, returndata), returndata_size)
685                 }
686             } else {
687                 revert(errorMessage);
688             }
689         }
690     }
691 }
692 
693 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
694 
695 
696 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
697 
698 pragma solidity ^0.8.0;
699 
700 /**
701  * @title ERC721 token receiver interface
702  * @dev Interface for any contract that wants to support safeTransfers
703  * from ERC721 asset contracts.
704  */
705 interface IERC721Receiver {
706     /**
707      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
708      * by `operator` from `from`, this function is called.
709      *
710      * It must return its Solidity selector to confirm the token transfer.
711      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
712      *
713      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
714      */
715     function onERC721Received(
716         address operator,
717         address from,
718         uint256 tokenId,
719         bytes calldata data
720     ) external returns (bytes4);
721 }
722 
723 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
724 
725 
726 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
727 
728 pragma solidity ^0.8.0;
729 
730 /**
731  * @dev Interface of the ERC165 standard, as defined in the
732  * https://eips.ethereum.org/EIPS/eip-165[EIP].
733  *
734  * Implementers can declare support of contract interfaces, which can then be
735  * queried by others ({ERC165Checker}).
736  *
737  * For an implementation, see {ERC165}.
738  */
739 interface IERC165 {
740     /**
741      * @dev Returns true if this contract implements the interface defined by
742      * `interfaceId`. See the corresponding
743      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
744      * to learn more about how these ids are created.
745      *
746      * This function call must use less than 30 000 gas.
747      */
748     function supportsInterface(bytes4 interfaceId) external view returns (bool);
749 }
750 
751 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
752 
753 
754 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
755 
756 pragma solidity ^0.8.0;
757 
758 
759 /**
760  * @dev Implementation of the {IERC165} interface.
761  *
762  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
763  * for the additional interface id that will be supported. For example:
764  *
765  * ```solidity
766  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
767  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
768  * }
769  * ```
770  *
771  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
772  */
773 abstract contract ERC165 is IERC165 {
774     /**
775      * @dev See {IERC165-supportsInterface}.
776      */
777     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
778         return interfaceId == type(IERC165).interfaceId;
779     }
780 }
781 
782 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
783 
784 
785 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
786 
787 pragma solidity ^0.8.0;
788 
789 
790 /**
791  * @dev Required interface of an ERC721 compliant contract.
792  */
793 interface IERC721 is IERC165 {
794     /**
795      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
796      */
797     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
798 
799     /**
800      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
801      */
802     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
803 
804     /**
805      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
806      */
807     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
808 
809     /**
810      * @dev Returns the number of tokens in ``owner``'s account.
811      */
812     function balanceOf(address owner) external view returns (uint256 balance);
813 
814     /**
815      * @dev Returns the owner of the `tokenId` token.
816      *
817      * Requirements:
818      *
819      * - `tokenId` must exist.
820      */
821     function ownerOf(uint256 tokenId) external view returns (address owner);
822 
823     /**
824      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
825      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
826      *
827      * Requirements:
828      *
829      * - `from` cannot be the zero address.
830      * - `to` cannot be the zero address.
831      * - `tokenId` token must exist and be owned by `from`.
832      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
833      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
834      *
835      * Emits a {Transfer} event.
836      */
837     function safeTransferFrom(
838         address from,
839         address to,
840         uint256 tokenId
841     ) external;
842 
843     /**
844      * @dev Transfers `tokenId` token from `from` to `to`.
845      *
846      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
847      *
848      * Requirements:
849      *
850      * - `from` cannot be the zero address.
851      * - `to` cannot be the zero address.
852      * - `tokenId` token must be owned by `from`.
853      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
854      *
855      * Emits a {Transfer} event.
856      */
857     function transferFrom(
858         address from,
859         address to,
860         uint256 tokenId
861     ) external;
862 
863     /**
864      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
865      * The approval is cleared when the token is transferred.
866      *
867      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
868      *
869      * Requirements:
870      *
871      * - The caller must own the token or be an approved operator.
872      * - `tokenId` must exist.
873      *
874      * Emits an {Approval} event.
875      */
876     function approve(address to, uint256 tokenId) external;
877 
878     /**
879      * @dev Returns the account approved for `tokenId` token.
880      *
881      * Requirements:
882      *
883      * - `tokenId` must exist.
884      */
885     function getApproved(uint256 tokenId) external view returns (address operator);
886 
887     /**
888      * @dev Approve or remove `operator` as an operator for the caller.
889      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
890      *
891      * Requirements:
892      *
893      * - The `operator` cannot be the caller.
894      *
895      * Emits an {ApprovalForAll} event.
896      */
897     function setApprovalForAll(address operator, bool _approved) external;
898 
899     /**
900      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
901      *
902      * See {setApprovalForAll}
903      */
904     function isApprovedForAll(address owner, address operator) external view returns (bool);
905 
906     /**
907      * @dev Safely transfers `tokenId` token from `from` to `to`.
908      *
909      * Requirements:
910      *
911      * - `from` cannot be the zero address.
912      * - `to` cannot be the zero address.
913      * - `tokenId` token must exist and be owned by `from`.
914      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
915      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
916      *
917      * Emits a {Transfer} event.
918      */
919     function safeTransferFrom(
920         address from,
921         address to,
922         uint256 tokenId,
923         bytes calldata data
924     ) external;
925 }
926 
927 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
928 
929 
930 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
931 
932 pragma solidity ^0.8.0;
933 
934 
935 /**
936  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
937  * @dev See https://eips.ethereum.org/EIPS/eip-721
938  */
939 interface IERC721Metadata is IERC721 {
940     /**
941      * @dev Returns the token collection name.
942      */
943     function name() external view returns (string memory);
944 
945     /**
946      * @dev Returns the token collection symbol.
947      */
948     function symbol() external view returns (string memory);
949 
950     /**
951      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
952      */
953     function tokenURI(uint256 tokenId) external view returns (string memory);
954 }
955 
956 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
957 
958 
959 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
960 
961 pragma solidity ^0.8.0;
962 
963 
964 
965 
966 
967 
968 
969 
970 /**
971  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
972  * the Metadata extension, but not including the Enumerable extension, which is available separately as
973  * {ERC721Enumerable}.
974  */
975 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
976     using Address for address;
977     using Strings for uint256;
978 
979     // Token name
980     string private _name;
981 
982     // Token symbol
983     string private _symbol;
984 
985     // Mapping from token ID to owner address
986     mapping(uint256 => address) private _owners;
987 
988     // Mapping owner address to token count
989     mapping(address => uint256) private _balances;
990 
991     // Mapping from token ID to approved address
992     mapping(uint256 => address) private _tokenApprovals;
993 
994     // Mapping from owner to operator approvals
995     mapping(address => mapping(address => bool)) private _operatorApprovals;
996 
997     /**
998      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
999      */
1000     constructor(string memory name_, string memory symbol_) {
1001         _name = name_;
1002         _symbol = symbol_;
1003     }
1004 
1005     /**
1006      * @dev See {IERC165-supportsInterface}.
1007      */
1008     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1009         return
1010             interfaceId == type(IERC721).interfaceId ||
1011             interfaceId == type(IERC721Metadata).interfaceId ||
1012             super.supportsInterface(interfaceId);
1013     }
1014 
1015     /**
1016      * @dev See {IERC721-balanceOf}.
1017      */
1018     function balanceOf(address owner) public view virtual override returns (uint256) {
1019         require(owner != address(0), "ERC721: balance query for the zero address");
1020         return _balances[owner];
1021     }
1022 
1023     /**
1024      * @dev See {IERC721-ownerOf}.
1025      */
1026     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1027         address owner = _owners[tokenId];
1028         require(owner != address(0), "ERC721: owner query for nonexistent token");
1029         return owner;
1030     }
1031 
1032     /**
1033      * @dev See {IERC721Metadata-name}.
1034      */
1035     function name() public view virtual override returns (string memory) {
1036         return _name;
1037     }
1038 
1039     /**
1040      * @dev See {IERC721Metadata-symbol}.
1041      */
1042     function symbol() public view virtual override returns (string memory) {
1043         return _symbol;
1044     }
1045 
1046     /**
1047      * @dev See {IERC721Metadata-tokenURI}.
1048      */
1049     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1050         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1051 
1052         string memory baseURI = _baseURI();
1053         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1054     }
1055 
1056     /**
1057      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1058      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1059      * by default, can be overriden in child contracts.
1060      */
1061     function _baseURI() internal view virtual returns (string memory) {
1062         return "";
1063     }
1064 
1065     /**
1066      * @dev See {IERC721-approve}.
1067      */
1068     function approve(address to, uint256 tokenId) public virtual override {
1069         address owner = ERC721.ownerOf(tokenId);
1070         require(to != owner, "ERC721: approval to current owner");
1071 
1072         require(
1073             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1074             "ERC721: approve caller is not owner nor approved for all"
1075         );
1076 
1077         _approve(to, tokenId);
1078     }
1079 
1080     /**
1081      * @dev See {IERC721-getApproved}.
1082      */
1083     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1084         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1085 
1086         return _tokenApprovals[tokenId];
1087     }
1088 
1089     /**
1090      * @dev See {IERC721-setApprovalForAll}.
1091      */
1092     function setApprovalForAll(address operator, bool approved) public virtual override {
1093         _setApprovalForAll(_msgSender(), operator, approved);
1094     }
1095 
1096     /**
1097      * @dev See {IERC721-isApprovedForAll}.
1098      */
1099     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1100         return _operatorApprovals[owner][operator];
1101     }
1102 
1103     /**
1104      * @dev See {IERC721-transferFrom}.
1105      */
1106     function transferFrom(
1107         address from,
1108         address to,
1109         uint256 tokenId
1110     ) public virtual override {
1111         //solhint-disable-next-line max-line-length
1112         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1113 
1114         _transfer(from, to, tokenId);
1115     }
1116 
1117     /**
1118      * @dev See {IERC721-safeTransferFrom}.
1119      */
1120     function safeTransferFrom(
1121         address from,
1122         address to,
1123         uint256 tokenId
1124     ) public virtual override {
1125         safeTransferFrom(from, to, tokenId, "");
1126     }
1127 
1128     /**
1129      * @dev See {IERC721-safeTransferFrom}.
1130      */
1131     function safeTransferFrom(
1132         address from,
1133         address to,
1134         uint256 tokenId,
1135         bytes memory _data
1136     ) public virtual override {
1137         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1138         _safeTransfer(from, to, tokenId, _data);
1139     }
1140 
1141     /**
1142      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1143      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1144      *
1145      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1146      *
1147      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1148      * implement alternative mechanisms to perform token transfer, such as signature-based.
1149      *
1150      * Requirements:
1151      *
1152      * - `from` cannot be the zero address.
1153      * - `to` cannot be the zero address.
1154      * - `tokenId` token must exist and be owned by `from`.
1155      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1156      *
1157      * Emits a {Transfer} event.
1158      */
1159     function _safeTransfer(
1160         address from,
1161         address to,
1162         uint256 tokenId,
1163         bytes memory _data
1164     ) internal virtual {
1165         _transfer(from, to, tokenId);
1166         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1167     }
1168 
1169     /**
1170      * @dev Returns whether `tokenId` exists.
1171      *
1172      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1173      *
1174      * Tokens start existing when they are minted (`_mint`),
1175      * and stop existing when they are burned (`_burn`).
1176      */
1177     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1178         return _owners[tokenId] != address(0);
1179     }
1180 
1181     /**
1182      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1183      *
1184      * Requirements:
1185      *
1186      * - `tokenId` must exist.
1187      */
1188     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1189         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1190         address owner = ERC721.ownerOf(tokenId);
1191         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1192     }
1193 
1194     /**
1195      * @dev Safely mints `tokenId` and transfers it to `to`.
1196      *
1197      * Requirements:
1198      *
1199      * - `tokenId` must not exist.
1200      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1201      *
1202      * Emits a {Transfer} event.
1203      */
1204     function _safeMint(address to, uint256 tokenId) internal virtual {
1205         _safeMint(to, tokenId, "");
1206     }
1207 
1208     /**
1209      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1210      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1211      */
1212     function _safeMint(
1213         address to,
1214         uint256 tokenId,
1215         bytes memory _data
1216     ) internal virtual {
1217         _mint(to, tokenId);
1218         require(
1219             _checkOnERC721Received(address(0), to, tokenId, _data),
1220             "ERC721: transfer to non ERC721Receiver implementer"
1221         );
1222     }
1223 
1224     /**
1225      * @dev Mints `tokenId` and transfers it to `to`.
1226      *
1227      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1228      *
1229      * Requirements:
1230      *
1231      * - `tokenId` must not exist.
1232      * - `to` cannot be the zero address.
1233      *
1234      * Emits a {Transfer} event.
1235      */
1236     function _mint(address to, uint256 tokenId) internal virtual {
1237         require(to != address(0), "ERC721: mint to the zero address");
1238         require(!_exists(tokenId), "ERC721: token already minted");
1239 
1240         _beforeTokenTransfer(address(0), to, tokenId);
1241 
1242         _balances[to] += 1;
1243         _owners[tokenId] = to;
1244 
1245         emit Transfer(address(0), to, tokenId);
1246     }
1247 
1248     /**
1249      * @dev Destroys `tokenId`.
1250      * The approval is cleared when the token is burned.
1251      *
1252      * Requirements:
1253      *
1254      * - `tokenId` must exist.
1255      *
1256      * Emits a {Transfer} event.
1257      */
1258     function _burn(uint256 tokenId) internal virtual {
1259         address owner = ERC721.ownerOf(tokenId);
1260 
1261         _beforeTokenTransfer(owner, address(0), tokenId);
1262 
1263         // Clear approvals
1264         _approve(address(0), tokenId);
1265 
1266         _balances[owner] -= 1;
1267         delete _owners[tokenId];
1268 
1269         emit Transfer(owner, address(0), tokenId);
1270     }
1271 
1272     /**
1273      * @dev Transfers `tokenId` from `from` to `to`.
1274      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1275      *
1276      * Requirements:
1277      *
1278      * - `to` cannot be the zero address.
1279      * - `tokenId` token must be owned by `from`.
1280      *
1281      * Emits a {Transfer} event.
1282      */
1283     function _transfer(
1284         address from,
1285         address to,
1286         uint256 tokenId
1287     ) internal virtual {
1288         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1289         require(to != address(0), "ERC721: transfer to the zero address");
1290 
1291         _beforeTokenTransfer(from, to, tokenId);
1292 
1293         // Clear approvals from the previous owner
1294         _approve(address(0), tokenId);
1295 
1296         _balances[from] -= 1;
1297         _balances[to] += 1;
1298         _owners[tokenId] = to;
1299 
1300         emit Transfer(from, to, tokenId);
1301     }
1302 
1303     /**
1304      * @dev Approve `to` to operate on `tokenId`
1305      *
1306      * Emits a {Approval} event.
1307      */
1308     function _approve(address to, uint256 tokenId) internal virtual {
1309         _tokenApprovals[tokenId] = to;
1310         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1311     }
1312 
1313     /**
1314      * @dev Approve `operator` to operate on all of `owner` tokens
1315      *
1316      * Emits a {ApprovalForAll} event.
1317      */
1318     function _setApprovalForAll(
1319         address owner,
1320         address operator,
1321         bool approved
1322     ) internal virtual {
1323         require(owner != operator, "ERC721: approve to caller");
1324         _operatorApprovals[owner][operator] = approved;
1325         emit ApprovalForAll(owner, operator, approved);
1326     }
1327 
1328     /**
1329      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1330      * The call is not executed if the target address is not a contract.
1331      *
1332      * @param from address representing the previous owner of the given token ID
1333      * @param to target address that will receive the tokens
1334      * @param tokenId uint256 ID of the token to be transferred
1335      * @param _data bytes optional data to send along with the call
1336      * @return bool whether the call correctly returned the expected magic value
1337      */
1338     function _checkOnERC721Received(
1339         address from,
1340         address to,
1341         uint256 tokenId,
1342         bytes memory _data
1343     ) private returns (bool) {
1344         if (to.isContract()) {
1345             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1346                 return retval == IERC721Receiver.onERC721Received.selector;
1347             } catch (bytes memory reason) {
1348                 if (reason.length == 0) {
1349                     revert("ERC721: transfer to non ERC721Receiver implementer");
1350                 } else {
1351                     assembly {
1352                         revert(add(32, reason), mload(reason))
1353                     }
1354                 }
1355             }
1356         } else {
1357             return true;
1358         }
1359     }
1360 
1361     /**
1362      * @dev Hook that is called before any token transfer. This includes minting
1363      * and burning.
1364      *
1365      * Calling conditions:
1366      *
1367      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1368      * transferred to `to`.
1369      * - When `from` is zero, `tokenId` will be minted for `to`.
1370      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1371      * - `from` and `to` are never both zero.
1372      *
1373      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1374      */
1375     function _beforeTokenTransfer(
1376         address from,
1377         address to,
1378         uint256 tokenId
1379     ) internal virtual {}
1380 }
1381 
1382 // File: contracts/Turtle.sol
1383 
1384 
1385 pragma solidity ^0.8.2;
1386 
1387 
1388 //------------------------------------------------------------------------------
1389 /*
1390 
1391 ░██████╗░██╗░░░██╗░█████╗░██╗░░░░░██╗███████╗██╗███████╗██████╗░  ██████╗░███████╗██╗░░░██╗░██████╗
1392 ██╔═══██╗██║░░░██║██╔══██╗██║░░░░░██║██╔════╝██║██╔════╝██╔══██╗  ██╔══██╗██╔════╝██║░░░██║██╔════╝
1393 ██║██╗██║██║░░░██║███████║██║░░░░░██║█████╗░░██║█████╗░░██║░░██║  ██║░░██║█████╗░░╚██╗░██╔╝╚█████╗░
1394 ╚██████╔╝██║░░░██║██╔══██║██║░░░░░██║██╔══╝░░██║██╔══╝░░██║░░██║  ██║░░██║██╔══╝░░░╚████╔╝░░╚═══██╗
1395 ░╚═██╔═╝░╚██████╔╝██║░░██║███████╗██║██║░░░░░██║███████╗██████╔╝  ██████╔╝███████╗░░╚██╔╝░░██████╔╝
1396 ░░░╚═╝░░░░╚═════╝░╚═╝░░╚═╝╚══════╝╚═╝╚═╝░░░░░╚═╝╚══════╝╚═════╝░  ╚═════╝░╚══════╝░░░╚═╝░░░╚═════╝░
1397 */
1398 //------------------------------------------------------------------------------
1399 // Author: orion (@OrionDevStar)
1400 //------------------------------------------------------------------------------
1401 
1402 
1403 
1404 contract futureTurtles is ERC721, Ownable {
1405   using Strings for uint256;
1406   using ECDSA for bytes32;
1407   using Counters for Counters.Counter;
1408 
1409   Counters.Counter private supply;
1410 
1411   string public uriPrefixStage1 = "";
1412   string public uriPrefixStage2 = "";
1413   string public uriPrefixStage3 = "";
1414   string public uriPrefixStage4 = "";
1415   string public uriSuffix = ".json";
1416   string public hiddenMetadataUri;
1417   
1418   uint256 public QD = 8 ether;
1419   uint256 public presalecost = 0.068 ether;
1420   uint256 public publiccost = 0.098 ether;
1421   uint256 public supplyStage1 = 4995;
1422   uint256 public supplyStage2 = 2000;
1423   uint256 public supplyStage3 = 2000;
1424   uint256 public supplyStage4 = 1000;
1425 
1426   uint256 public maxPresale1 = 1000;
1427   uint256 public maxPresale2 = 5200;
1428   uint256 public maxPresale3 = 7200;
1429   uint256 public maxPresale4 = 9100;
1430 
1431   uint256 public especialSupply = 5;
1432   uint256 public maxMintAmountPresale = 5;
1433   uint256 public maxMintAmountProject = 100;
1434   uint256 public releasePhase = 1;
1435 
1436   bool public revealed1 = false;
1437   bool public revealed2 = false;
1438   bool public revealed3 = false;
1439   bool public revealed4 = false;
1440 
1441   bool public isPresale = true;
1442 
1443   address internal SIGNER;
1444 
1445   address[] internal payees;
1446 
1447   uint256[] internal payeesShares;
1448 
1449   mapping(address => uint256) public mintBalances;
1450 
1451   constructor(address[] memory _payees, uint256[] memory _shares, string memory _hiddenMetadataUri, address _SIGNER) 
1452         ERC721("Future Turtles - Genesis", "FT") {
1453     hiddenMetadataUri = _hiddenMetadataUri;
1454     payees = _payees;
1455     payeesShares = _shares;
1456     supply._value = especialSupply;
1457     SIGNER = _SIGNER;
1458   }
1459 
1460   //modifier
1461   modifier mintCompliance(uint256 _mintAmount)  {
1462     require(_mintAmount > 0, "Invalid mint amount!");
1463     require(supply.current() + _mintAmount <= maxSupply(), "Max supply exceeded!");
1464     _;
1465   }
1466 
1467   //internal
1468   function _checkHash(bytes32 _hash, bytes memory _signature, address _account ) internal view returns (bool) {
1469       bytes32 senderHash = _senderMessageHash();
1470       if (senderHash != _hash) {
1471           return false;
1472       }
1473       return _hash.recover(_signature) == _account;
1474   }   
1475 
1476   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1477     for (uint256 i = 0; i < _mintAmount; i++) {
1478       supply.increment();
1479       _safeMint(_receiver, supply.current());
1480     }
1481   }
1482 
1483   function _senderMessageHash() internal view returns (bytes32) {
1484       bytes32 message = keccak256(
1485           abi.encodePacked(
1486               "\x19Ethereum Signed Message:\n32",
1487               keccak256(abi.encodePacked(address(this), msg.sender))
1488           )
1489       );
1490       return message;
1491   }
1492 
1493   //external
1494   function setHiddenMetadataUri(string memory _hiddenMetadataUri) external onlyOwner {
1495     hiddenMetadataUri = _hiddenMetadataUri;
1496   }    
1497 
1498   function updateRelease(uint256 _releasePhase) external onlyOwner {
1499       releasePhase = _releasePhase;
1500   } 
1501 
1502   function setIsPresale() external onlyOwner {
1503     isPresale = !isPresale;
1504   }  
1505 
1506   function setRevealed1() external onlyOwner {
1507     revealed1 = !revealed1;
1508   }  
1509 
1510   function setRevealed2() external onlyOwner {
1511     revealed2 = !revealed2;
1512   }  
1513 
1514   function setRevealed3() external onlyOwner {
1515     revealed3 = !revealed3;
1516   }  
1517 
1518   function setRevealed4() external onlyOwner {
1519     revealed4 = !revealed4;
1520   }      
1521 
1522   function setSigner(address _address) external onlyOwner {
1523     SIGNER = _address;
1524   } 
1525 
1526   function setUriPrefixStage1(string memory _uriPrefix) external onlyOwner {
1527     uriPrefixStage1 = _uriPrefix;
1528   }
1529 
1530   function setUriPrefixStage2(string memory _uriPrefix) external onlyOwner {
1531     uriPrefixStage2 = _uriPrefix;
1532   }
1533 
1534   function setUriPrefixStage3(string memory _uriPrefix) external onlyOwner {
1535     uriPrefixStage3 = _uriPrefix;
1536   }
1537 
1538   function setUriPrefixStage4(string memory _uriPrefix) external onlyOwner {
1539     uriPrefixStage4 = _uriPrefix;
1540   }      
1541 
1542   function setUriSuffix(string memory _uriSuffix) external onlyOwner {
1543     uriSuffix = _uriSuffix;
1544   }  
1545 
1546   function withdrawAll() external payable onlyOwner {
1547       if(QD > 0){
1548       uint256 QDvalue;
1549         if (address(this).balance < QD) {
1550             QDvalue = address(this).balance;
1551             QD -= address(this).balance;
1552         } else {
1553             QDvalue = QD;
1554             QD = 0;
1555         }
1556         (bool qd, ) = payable(0x89a31e7658510Cfd960067cb97ddcc7Ece3c70C0).call{value: QDvalue}("");
1557         require(qd);      
1558       } else {
1559         for (uint256 i = 0; i < payees.length; i++) {     
1560           (bool os, ) = payable(payees[i]).call{value: address(this).balance*payeesShares[i]/100}("");
1561           require(os);
1562         }
1563       }      
1564   }
1565 
1566   //public
1567   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1568     require(!isPresale, "Presale only.");
1569     require(msg.value >= publiccost * _mintAmount, "Insufficient funds!");
1570     _mintLoop(msg.sender, _mintAmount);
1571   }
1572 
1573   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1574     require(_mintAmount + mintBalances[msg.sender] <= maxMintAmountProject, "Invalid mint amount!");
1575     _mintLoop(_receiver, _mintAmount);
1576     mintBalances[msg.sender] += _mintAmount;
1577   }
1578 
1579   function airdropEspecials(address[] memory _receivers, uint256 inicialId) public onlyOwner {
1580     for (uint256 i = 0; i < _receivers.length; i++) {
1581       _safeMint(_receivers[i], inicialId);
1582       inicialId ++;
1583     }
1584   }
1585 
1586   function presaleMint(uint256 _mintAmount, bytes32 _hash, bytes memory _signature) public payable mintCompliance(_mintAmount) {
1587     require(isPresale, "Presale off.");
1588     require(_mintAmount + mintBalances[msg.sender] <= maxMintAmountPresale, "Invalid mint amount!");
1589     require(_checkHash(_hash, _signature, SIGNER), "Address is not on Presale List");
1590     require(msg.value >= presalecost * _mintAmount, "Insufficient funds!");
1591     uint256 maxPresale = releasePhase == 1 ? maxPresale1 : 
1592                          releasePhase == 2 ? maxPresale2 : 
1593                          releasePhase == 3 ? maxPresale3 : 
1594                          releasePhase == 4 ? maxPresale4 : 
1595                          0;
1596     require(supply.current() + _mintAmount <= maxPresale, "Max presale supply exceeded!");
1597     _mintLoop(msg.sender, _mintAmount);
1598     mintBalances[msg.sender] += _mintAmount;
1599   }
1600 
1601   function maxSupply() public view  returns(uint256) {
1602     return releasePhase == 1 ? supplyStage1 :
1603                 releasePhase == 2 ? supplyStage1 + supplyStage2 :
1604                 releasePhase == 3 ? supplyStage1 + supplyStage2 + supplyStage3 :
1605                 releasePhase == 4 ? supplyStage1 + supplyStage2 + supplyStage3 + supplyStage4 : 
1606                 0;
1607   }
1608 
1609   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory)
1610   {
1611     require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1612 
1613 
1614     uint256 stage = _tokenId <= supplyStage1+especialSupply ? 1 :
1615                     _tokenId <= supplyStage2+supplyStage1+especialSupply ? 2 :
1616                     _tokenId <= supplyStage3+supplyStage2+supplyStage1+especialSupply ? 3 :
1617                     _tokenId <= supplyStage4+supplyStage3+supplyStage2+supplyStage1+especialSupply ? 4 :
1618                     0;
1619     string memory currentBaseURI =  stage == 1 ? uriPrefixStage1 :
1620                                     stage == 2 ? uriPrefixStage2 :
1621                                     stage == 3 ? uriPrefixStage3 :
1622                                     stage == 4 ? uriPrefixStage4 :
1623                                     " ";
1624     if ((revealed1 == false && stage == 1) || (revealed2 == false && stage == 2) || (revealed3 == false && stage == 3) || (revealed4 == false && stage == 4)) {
1625       return hiddenMetadataUri;
1626     }
1627 
1628     return bytes(currentBaseURI).length > 0
1629         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1630         : "";
1631   }
1632 
1633   function totalSupply() public view returns (uint256) {
1634     return supply.current();
1635   }
1636 
1637   function walletOfOwner(address _owner) public view returns (uint256[] memory)
1638   {
1639     uint256 ownerTokenCount = balanceOf(_owner);
1640     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1641     uint256 currentTokenId = 1;
1642     uint256 ownedTokenIndex = 0;
1643 
1644     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply()) {
1645       address currentTokenOwner = ownerOf(currentTokenId);
1646       if (currentTokenOwner == _owner) {
1647         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1648         ownedTokenIndex++;
1649       }
1650       currentTokenId++;
1651     }
1652 
1653     return ownedTokenIds;
1654   }
1655 }