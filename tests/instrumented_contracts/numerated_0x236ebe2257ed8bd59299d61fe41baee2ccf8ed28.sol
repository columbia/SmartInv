1 // SPDX-License-Identifier: MIT
2 /*
3   _____                     _           _   __  __       _              _       
4  |_   _|                   | |         | | |  \/  |     | |            | |      
5    | |  _ ____   _____ _ __| |_ ___  __| | | \  / |_   _| |_ __ _ _ __ | |_ ___ 
6    | | | '_ \ \ / / _ \ '__| __/ _ \/ _` | | |\/| | | | | __/ _` | '_ \| __/ __|
7   _| |_| | | \ V /  __/ |  | ||  __/ (_| | | |  | | |_| | || (_| | | | | |_\__ \
8  |_____|_| |_|\_/ \___|_|   \__\___|\__,_| |_|  |_|\__,_|\__\__,_|_| |_|\__|___/
9                                                                                 
10                              By Devko.dev#7286                              
11  */
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @title Counters
16  * @author Matt Condon (@shrugs)
17  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
18  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
19  *
20  * Include with `using Counters for Counters.Counter;`
21  */
22 library Counters {
23     struct Counter {
24         // This variable should never be directly accessed by users of the library: interactions must be restricted to
25         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
26         // this feature: see https://github.com/ethereum/solidity/issues/4637
27         uint256 _value; // default: 0
28     }
29 
30     function current(Counter storage counter) internal view returns (uint256) {
31         return counter._value;
32     }
33 
34     function increment(Counter storage counter) internal {
35         unchecked {
36             counter._value += 1;
37         }
38     }
39 
40     function decrement(Counter storage counter) internal {
41         uint256 value = counter._value;
42         require(value > 0, "Counter: decrement overflow");
43         unchecked {
44             counter._value = value - 1;
45         }
46     }
47 
48     function reset(Counter storage counter) internal {
49         counter._value = 0;
50     }
51 }
52 
53 pragma solidity ^0.8.0;
54 
55 /**
56  * @dev String operations.
57  */
58 library Strings {
59     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
60 
61     /**
62      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
63      */
64     function toString(uint256 value) internal pure returns (string memory) {
65         // Inspired by OraclizeAPI's implementation - MIT licence
66         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
67 
68         if (value == 0) {
69             return "0";
70         }
71         uint256 temp = value;
72         uint256 digits;
73         while (temp != 0) {
74             digits++;
75             temp /= 10;
76         }
77         bytes memory buffer = new bytes(digits);
78         while (value != 0) {
79             digits -= 1;
80             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
81             value /= 10;
82         }
83         return string(buffer);
84     }
85 
86     /**
87      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
88      */
89     function toHexString(uint256 value) internal pure returns (string memory) {
90         if (value == 0) {
91             return "0x00";
92         }
93         uint256 temp = value;
94         uint256 length = 0;
95         while (temp != 0) {
96             length++;
97             temp >>= 8;
98         }
99         return toHexString(value, length);
100     }
101 
102     /**
103      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
104      */
105     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
106         bytes memory buffer = new bytes(2 * length + 2);
107         buffer[0] = "0";
108         buffer[1] = "x";
109         for (uint256 i = 2 * length + 1; i > 1; --i) {
110             buffer[i] = _HEX_SYMBOLS[value & 0xf];
111             value >>= 4;
112         }
113         require(value == 0, "Strings: hex length insufficient");
114         return string(buffer);
115     }
116 }
117 
118 pragma solidity ^0.8.0;
119 
120 
121 /**
122  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
123  *
124  * These functions can be used to verify that a message was signed by the holder
125  * of the private keys of a given address.
126  */
127 library ECDSA {
128     enum RecoverError {
129         NoError,
130         InvalidSignature,
131         InvalidSignatureLength,
132         InvalidSignatureS,
133         InvalidSignatureV
134     }
135 
136     function _throwError(RecoverError error) private pure {
137         if (error == RecoverError.NoError) {
138             return; // no error: do nothing
139         } else if (error == RecoverError.InvalidSignature) {
140             revert("ECDSA: invalid signature");
141         } else if (error == RecoverError.InvalidSignatureLength) {
142             revert("ECDSA: invalid signature length");
143         } else if (error == RecoverError.InvalidSignatureS) {
144             revert("ECDSA: invalid signature 's' value");
145         } else if (error == RecoverError.InvalidSignatureV) {
146             revert("ECDSA: invalid signature 'v' value");
147         }
148     }
149 
150     /**
151      * @dev Returns the address that signed a hashed message (`hash`) with
152      * `signature` or error string. This address can then be used for verification purposes.
153      *
154      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
155      * this function rejects them by requiring the `s` value to be in the lower
156      * half order, and the `v` value to be either 27 or 28.
157      *
158      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
159      * verification to be secure: it is possible to craft signatures that
160      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
161      * this is by receiving a hash of the original message (which may otherwise
162      * be too long), and then calling {toEthSignedMessageHash} on it.
163      *
164      * Documentation for signature generation:
165      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
166      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
167      *
168      * _Available since v4.3._
169      */
170     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
171         // Check the signature length
172         // - case 65: r,s,v signature (standard)
173         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
174         if (signature.length == 65) {
175             bytes32 r;
176             bytes32 s;
177             uint8 v;
178             // ecrecover takes the signature parameters, and the only way to get them
179             // currently is to use assembly.
180             assembly {
181                 r := mload(add(signature, 0x20))
182                 s := mload(add(signature, 0x40))
183                 v := byte(0, mload(add(signature, 0x60)))
184             }
185             return tryRecover(hash, v, r, s);
186         } else if (signature.length == 64) {
187             bytes32 r;
188             bytes32 vs;
189             // ecrecover takes the signature parameters, and the only way to get them
190             // currently is to use assembly.
191             assembly {
192                 r := mload(add(signature, 0x20))
193                 vs := mload(add(signature, 0x40))
194             }
195             return tryRecover(hash, r, vs);
196         } else {
197             return (address(0), RecoverError.InvalidSignatureLength);
198         }
199     }
200 
201     /**
202      * @dev Returns the address that signed a hashed message (`hash`) with
203      * `signature`. This address can then be used for verification purposes.
204      *
205      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
206      * this function rejects them by requiring the `s` value to be in the lower
207      * half order, and the `v` value to be either 27 or 28.
208      *
209      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
210      * verification to be secure: it is possible to craft signatures that
211      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
212      * this is by receiving a hash of the original message (which may otherwise
213      * be too long), and then calling {toEthSignedMessageHash} on it.
214      */
215     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
216         (address recovered, RecoverError error) = tryRecover(hash, signature);
217         _throwError(error);
218         return recovered;
219     }
220 
221     /**
222      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
223      *
224      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
225      *
226      * _Available since v4.3._
227      */
228     function tryRecover(
229         bytes32 hash,
230         bytes32 r,
231         bytes32 vs
232     ) internal pure returns (address, RecoverError) {
233         bytes32 s;
234         uint8 v;
235         assembly {
236             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
237             v := add(shr(255, vs), 27)
238         }
239         return tryRecover(hash, v, r, s);
240     }
241 
242     /**
243      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
244      *
245      * _Available since v4.2._
246      */
247     function recover(
248         bytes32 hash,
249         bytes32 r,
250         bytes32 vs
251     ) internal pure returns (address) {
252         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
253         _throwError(error);
254         return recovered;
255     }
256 
257     /**
258      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
259      * `r` and `s` signature fields separately.
260      *
261      * _Available since v4.3._
262      */
263     function tryRecover(
264         bytes32 hash,
265         uint8 v,
266         bytes32 r,
267         bytes32 s
268     ) internal pure returns (address, RecoverError) {
269         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
270         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
271         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
272         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
273         //
274         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
275         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
276         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
277         // these malleable signatures as well.
278         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
279             return (address(0), RecoverError.InvalidSignatureS);
280         }
281         if (v != 27 && v != 28) {
282             return (address(0), RecoverError.InvalidSignatureV);
283         }
284 
285         // If the signature is valid (and not malleable), return the signer address
286         address signer = ecrecover(hash, v, r, s);
287         if (signer == address(0)) {
288             return (address(0), RecoverError.InvalidSignature);
289         }
290 
291         return (signer, RecoverError.NoError);
292     }
293 
294     /**
295      * @dev Overload of {ECDSA-recover} that receives the `v`,
296      * `r` and `s` signature fields separately.
297      */
298     function recover(
299         bytes32 hash,
300         uint8 v,
301         bytes32 r,
302         bytes32 s
303     ) internal pure returns (address) {
304         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
305         _throwError(error);
306         return recovered;
307     }
308 
309     /**
310      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
311      * produces hash corresponding to the one signed with the
312      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
313      * JSON-RPC method as part of EIP-191.
314      *
315      * See {recover}.
316      */
317     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
318         // 32 is the length in bytes of hash,
319         // enforced by the type signature above
320         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
321     }
322 
323     /**
324      * @dev Returns an Ethereum Signed Message, created from `s`. This
325      * produces hash corresponding to the one signed with the
326      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
327      * JSON-RPC method as part of EIP-191.
328      *
329      * See {recover}.
330      */
331     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
332         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
333     }
334 
335     /**
336      * @dev Returns an Ethereum Signed Typed Data, created from a
337      * `domainSeparator` and a `structHash`. This produces hash corresponding
338      * to the one signed with the
339      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
340      * JSON-RPC method as part of EIP-712.
341      *
342      * See {recover}.
343      */
344     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
345         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
346     }
347 }
348 
349 pragma solidity ^0.8.0;
350 
351 /**
352  * @dev Provides information about the current execution context, including the
353  * sender of the transaction and its data. While these are generally available
354  * via msg.sender and msg.data, they should not be accessed in such a direct
355  * manner, since when dealing with meta-transactions the account sending and
356  * paying for execution may not be the actual sender (as far as an application
357  * is concerned).
358  *
359  * This contract is only required for intermediate, library-like contracts.
360  */
361 abstract contract Context {
362     function _msgSender() internal view virtual returns (address) {
363         return msg.sender;
364     }
365 
366     function _msgData() internal view virtual returns (bytes calldata) {
367         return msg.data;
368     }
369 }
370 
371 pragma solidity ^0.8.0;
372 
373 /**
374  * @dev Contract module which provides a basic access control mechanism, where
375  * there is an account (an owner) that can be granted exclusive access to
376  * specific functions.
377  *
378  * By default, the owner account will be the one that deploys the contract. This
379  * can later be changed with {transferOwnership}.
380  *
381  * This module is used through inheritance. It will make available the modifier
382  * `onlyOwner`, which can be applied to your functions to restrict their use to
383  * the owner.
384  */
385 abstract contract Ownable is Context {
386     address private _owner;
387 
388     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
389 
390     /**
391      * @dev Initializes the contract setting the deployer as the initial owner.
392      */
393     constructor() {
394         _transferOwnership(_msgSender());
395     }
396 
397     /**
398      * @dev Returns the address of the current owner.
399      */
400     function owner() public view virtual returns (address) {
401         return _owner;
402     }
403 
404     /**
405      * @dev Throws if called by any account other than the owner.
406      */
407     modifier onlyOwner() {
408         require(owner() == _msgSender(), "Ownable: caller is not the owner");
409         _;
410     }
411 
412     /**
413      * @dev Leaves the contract without owner. It will not be possible to call
414      * `onlyOwner` functions anymore. Can only be called by the current owner.
415      *
416      * NOTE: Renouncing ownership will leave the contract without an owner,
417      * thereby removing any functionality that is only available to the owner.
418      */
419     function renounceOwnership() public virtual onlyOwner {
420         _transferOwnership(address(0));
421     }
422 
423     /**
424      * @dev Transfers ownership of the contract to a new account (`newOwner`).
425      * Can only be called by the current owner.
426      */
427     function transferOwnership(address newOwner) public virtual onlyOwner {
428         require(newOwner != address(0), "Ownable: new owner is the zero address");
429         _transferOwnership(newOwner);
430     }
431 
432     /**
433      * @dev Transfers ownership of the contract to a new account (`newOwner`).
434      * Internal function without access restriction.
435      */
436     function _transferOwnership(address newOwner) internal virtual {
437         address oldOwner = _owner;
438         _owner = newOwner;
439         emit OwnershipTransferred(oldOwner, newOwner);
440     }
441 }
442 
443 pragma solidity ^0.8.0;
444 
445 /**
446  * @dev Collection of functions related to the address type
447  */
448 library Address {
449     /**
450      * @dev Returns true if `account` is a contract.
451      *
452      * [IMPORTANT]
453      * ====
454      * It is unsafe to assume that an address for which this function returns
455      * false is an externally-owned account (EOA) and not a contract.
456      *
457      * Among others, `isContract` will return false for the following
458      * types of addresses:
459      *
460      *  - an externally-owned account
461      *  - a contract in construction
462      *  - an address where a contract will be created
463      *  - an address where a contract lived, but was destroyed
464      * ====
465      */
466     function isContract(address account) internal view returns (bool) {
467         // This method relies on extcodesize, which returns 0 for contracts in
468         // construction, since the code is only stored at the end of the
469         // constructor execution.
470 
471         uint256 size;
472         assembly {
473             size := extcodesize(account)
474         }
475         return size > 0;
476     }
477 
478     /**
479      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
480      * `recipient`, forwarding all available gas and reverting on errors.
481      *
482      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
483      * of certain opcodes, possibly making contracts go over the 2300 gas limit
484      * imposed by `transfer`, making them unable to receive funds via
485      * `transfer`. {sendValue} removes this limitation.
486      *
487      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
488      *
489      * IMPORTANT: because control is transferred to `recipient`, care must be
490      * taken to not create reentrancy vulnerabilities. Consider using
491      * {ReentrancyGuard} or the
492      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
493      */
494     function sendValue(address payable recipient, uint256 amount) internal {
495         require(address(this).balance >= amount, "Address: insufficient balance");
496 
497         (bool success, ) = recipient.call{value: amount}("");
498         require(success, "Address: unable to send value, recipient may have reverted");
499     }
500 
501     /**
502      * @dev Performs a Solidity function call using a low level `call`. A
503      * plain `call` is an unsafe replacement for a function call: use this
504      * function instead.
505      *
506      * If `target` reverts with a revert reason, it is bubbled up by this
507      * function (like regular Solidity function calls).
508      *
509      * Returns the raw returned data. To convert to the expected return value,
510      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
511      *
512      * Requirements:
513      *
514      * - `target` must be a contract.
515      * - calling `target` with `data` must not revert.
516      *
517      * _Available since v3.1._
518      */
519     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
520         return functionCall(target, data, "Address: low-level call failed");
521     }
522 
523     /**
524      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
525      * `errorMessage` as a fallback revert reason when `target` reverts.
526      *
527      * _Available since v3.1._
528      */
529     function functionCall(
530         address target,
531         bytes memory data,
532         string memory errorMessage
533     ) internal returns (bytes memory) {
534         return functionCallWithValue(target, data, 0, errorMessage);
535     }
536 
537     /**
538      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
539      * but also transferring `value` wei to `target`.
540      *
541      * Requirements:
542      *
543      * - the calling contract must have an ETH balance of at least `value`.
544      * - the called Solidity function must be `payable`.
545      *
546      * _Available since v3.1._
547      */
548     function functionCallWithValue(
549         address target,
550         bytes memory data,
551         uint256 value
552     ) internal returns (bytes memory) {
553         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
554     }
555 
556     /**
557      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
558      * with `errorMessage` as a fallback revert reason when `target` reverts.
559      *
560      * _Available since v3.1._
561      */
562     function functionCallWithValue(
563         address target,
564         bytes memory data,
565         uint256 value,
566         string memory errorMessage
567     ) internal returns (bytes memory) {
568         require(address(this).balance >= value, "Address: insufficient balance for call");
569         require(isContract(target), "Address: call to non-contract");
570 
571         (bool success, bytes memory returndata) = target.call{value: value}(data);
572         return verifyCallResult(success, returndata, errorMessage);
573     }
574 
575     /**
576      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
577      * but performing a static call.
578      *
579      * _Available since v3.3._
580      */
581     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
582         return functionStaticCall(target, data, "Address: low-level static call failed");
583     }
584 
585     /**
586      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
587      * but performing a static call.
588      *
589      * _Available since v3.3._
590      */
591     function functionStaticCall(
592         address target,
593         bytes memory data,
594         string memory errorMessage
595     ) internal view returns (bytes memory) {
596         require(isContract(target), "Address: static call to non-contract");
597 
598         (bool success, bytes memory returndata) = target.staticcall(data);
599         return verifyCallResult(success, returndata, errorMessage);
600     }
601 
602     /**
603      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
604      * but performing a delegate call.
605      *
606      * _Available since v3.4._
607      */
608     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
609         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
610     }
611 
612     /**
613      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
614      * but performing a delegate call.
615      *
616      * _Available since v3.4._
617      */
618     function functionDelegateCall(
619         address target,
620         bytes memory data,
621         string memory errorMessage
622     ) internal returns (bytes memory) {
623         require(isContract(target), "Address: delegate call to non-contract");
624 
625         (bool success, bytes memory returndata) = target.delegatecall(data);
626         return verifyCallResult(success, returndata, errorMessage);
627     }
628 
629     /**
630      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
631      * revert reason using the provided one.
632      *
633      * _Available since v4.3._
634      */
635     function verifyCallResult(
636         bool success,
637         bytes memory returndata,
638         string memory errorMessage
639     ) internal pure returns (bytes memory) {
640         if (success) {
641             return returndata;
642         } else {
643             // Look for revert reason and bubble it up if present
644             if (returndata.length > 0) {
645                 // The easiest way to bubble the revert reason is using memory via assembly
646 
647                 assembly {
648                     let returndata_size := mload(returndata)
649                     revert(add(32, returndata), returndata_size)
650                 }
651             } else {
652                 revert(errorMessage);
653             }
654         }
655     }
656 }
657 
658 pragma solidity ^0.8.0;
659 
660 /**
661  * @title ERC721 token receiver interface
662  * @dev Interface for any contract that wants to support safeTransfers
663  * from ERC721 asset contracts.
664  */
665 interface IERC721Receiver {
666     /**
667      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
668      * by `operator` from `from`, this function is called.
669      *
670      * It must return its Solidity selector to confirm the token transfer.
671      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
672      *
673      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
674      */
675     function onERC721Received(
676         address operator,
677         address from,
678         uint256 tokenId,
679         bytes calldata data
680     ) external returns (bytes4);
681 }
682 
683 pragma solidity ^0.8.0;
684 
685 /**
686  * @dev Interface of the ERC165 standard, as defined in the
687  * https://eips.ethereum.org/EIPS/eip-165[EIP].
688  *
689  * Implementers can declare support of contract interfaces, which can then be
690  * queried by others ({ERC165Checker}).
691  *
692  * For an implementation, see {ERC165}.
693  */
694 interface IERC165 {
695     /**
696      * @dev Returns true if this contract implements the interface defined by
697      * `interfaceId`. See the corresponding
698      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
699      * to learn more about how these ids are created.
700      *
701      * This function call must use less than 30 000 gas.
702      */
703     function supportsInterface(bytes4 interfaceId) external view returns (bool);
704 }
705 
706 pragma solidity ^0.8.0;
707 
708 /**
709  * @dev Implementation of the {IERC165} interface.
710  *
711  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
712  * for the additional interface id that will be supported. For example:
713  *
714  * ```solidity
715  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
716  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
717  * }
718  * ```
719  *
720  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
721  */
722 abstract contract ERC165 is IERC165 {
723     /**
724      * @dev See {IERC165-supportsInterface}.
725      */
726     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
727         return interfaceId == type(IERC165).interfaceId;
728     }
729 }
730 
731 pragma solidity ^0.8.0;
732 
733 /**
734  * @dev Required interface of an ERC721 compliant contract.
735  */
736 interface IERC721 is IERC165 {
737     /**
738      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
739      */
740     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
741 
742     /**
743      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
744      */
745     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
746 
747     /**
748      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
749      */
750     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
751 
752     /**
753      * @dev Returns the number of tokens in ``owner``'s account.
754      */
755     function balanceOf(address owner) external view returns (uint256 balance);
756 
757     /**
758      * @dev Returns the owner of the `tokenId` token.
759      *
760      * Requirements:
761      *
762      * - `tokenId` must exist.
763      */
764     function ownerOf(uint256 tokenId) external view returns (address owner);
765 
766     /**
767      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
768      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
769      *
770      * Requirements:
771      *
772      * - `from` cannot be the zero address.
773      * - `to` cannot be the zero address.
774      * - `tokenId` token must exist and be owned by `from`.
775      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
776      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
777      *
778      * Emits a {Transfer} event.
779      */
780     function safeTransferFrom(
781         address from,
782         address to,
783         uint256 tokenId
784     ) external;
785 
786     /**
787      * @dev Transfers `tokenId` token from `from` to `to`.
788      *
789      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
790      *
791      * Requirements:
792      *
793      * - `from` cannot be the zero address.
794      * - `to` cannot be the zero address.
795      * - `tokenId` token must be owned by `from`.
796      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
797      *
798      * Emits a {Transfer} event.
799      */
800     function transferFrom(
801         address from,
802         address to,
803         uint256 tokenId
804     ) external;
805 
806     /**
807      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
808      * The approval is cleared when the token is transferred.
809      *
810      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
811      *
812      * Requirements:
813      *
814      * - The caller must own the token or be an approved operator.
815      * - `tokenId` must exist.
816      *
817      * Emits an {Approval} event.
818      */
819     function approve(address to, uint256 tokenId) external;
820 
821     /**
822      * @dev Returns the account approved for `tokenId` token.
823      *
824      * Requirements:
825      *
826      * - `tokenId` must exist.
827      */
828     function getApproved(uint256 tokenId) external view returns (address operator);
829 
830     /**
831      * @dev Approve or remove `operator` as an operator for the caller.
832      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
833      *
834      * Requirements:
835      *
836      * - The `operator` cannot be the caller.
837      *
838      * Emits an {ApprovalForAll} event.
839      */
840     function setApprovalForAll(address operator, bool _approved) external;
841 
842     /**
843      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
844      *
845      * See {setApprovalForAll}
846      */
847     function isApprovedForAll(address owner, address operator) external view returns (bool);
848 
849     /**
850      * @dev Safely transfers `tokenId` token from `from` to `to`.
851      *
852      * Requirements:
853      *
854      * - `from` cannot be the zero address.
855      * - `to` cannot be the zero address.
856      * - `tokenId` token must exist and be owned by `from`.
857      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
858      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
859      *
860      * Emits a {Transfer} event.
861      */
862     function safeTransferFrom(
863         address from,
864         address to,
865         uint256 tokenId,
866         bytes calldata data
867     ) external;
868 }
869 
870 pragma solidity ^0.8.0;
871 
872 /**
873  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
874  * @dev See https://eips.ethereum.org/EIPS/eip-721
875  */
876 interface IERC721Metadata is IERC721 {
877     /**
878      * @dev Returns the token collection name.
879      */
880     function name() external view returns (string memory);
881 
882     /**
883      * @dev Returns the token collection symbol.
884      */
885     function symbol() external view returns (string memory);
886 
887     /**
888      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
889      */
890     function tokenURI(uint256 tokenId) external view returns (string memory);
891 }
892 
893 pragma solidity ^0.8.0;
894 
895 /**
896  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
897  * the Metadata extension, but not including the Enumerable extension, which is available separately as
898  * {ERC721Enumerable}.
899  */
900 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
901     using Address for address;
902     using Strings for uint256;
903 
904     // Token name
905     string private _name;
906 
907     // Token symbol
908     string private _symbol;
909 
910     // Mapping from token ID to owner address
911     mapping(uint256 => address) private _owners;
912 
913     // Mapping owner address to token count
914     mapping(address => uint256) private _balances;
915 
916     // Mapping from token ID to approved address
917     mapping(uint256 => address) private _tokenApprovals;
918 
919     // Mapping from owner to operator approvals
920     mapping(address => mapping(address => bool)) private _operatorApprovals;
921 
922     /**
923      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
924      */
925     constructor(string memory name_, string memory symbol_) {
926         _name = name_;
927         _symbol = symbol_;
928     }
929 
930     /**
931      * @dev See {IERC165-supportsInterface}.
932      */
933     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
934         return
935             interfaceId == type(IERC721).interfaceId ||
936             interfaceId == type(IERC721Metadata).interfaceId ||
937             super.supportsInterface(interfaceId);
938     }
939 
940     /**
941      * @dev See {IERC721-balanceOf}.
942      */
943     function balanceOf(address owner) public view virtual override returns (uint256) {
944         require(owner != address(0), "ERC721: balance query for the zero address");
945         return _balances[owner];
946     }
947 
948     /**
949      * @dev See {IERC721-ownerOf}.
950      */
951     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
952         address owner = _owners[tokenId];
953         require(owner != address(0), "ERC721: owner query for nonexistent token");
954         return owner;
955     }
956 
957     /**
958      * @dev See {IERC721Metadata-name}.
959      */
960     function name() public view virtual override returns (string memory) {
961         return _name;
962     }
963 
964     /**
965      * @dev See {IERC721Metadata-symbol}.
966      */
967     function symbol() public view virtual override returns (string memory) {
968         return _symbol;
969     }
970 
971     /**
972      * @dev See {IERC721Metadata-tokenURI}.
973      */
974     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
975         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
976 
977         string memory baseURI = _baseURI();
978         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
979     }
980 
981     /**
982      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
983      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
984      * by default, can be overriden in child contracts.
985      */
986     function _baseURI() internal view virtual returns (string memory) {
987         return "";
988     }
989 
990     /**
991      * @dev See {IERC721-approve}.
992      */
993     function approve(address to, uint256 tokenId) public virtual override {
994         address owner = ERC721.ownerOf(tokenId);
995         require(to != owner, "ERC721: approval to current owner");
996 
997         require(
998             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
999             "ERC721: approve caller is not owner nor approved for all"
1000         );
1001 
1002         _approve(to, tokenId);
1003     }
1004 
1005     /**
1006      * @dev See {IERC721-getApproved}.
1007      */
1008     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1009         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1010 
1011         return _tokenApprovals[tokenId];
1012     }
1013 
1014     /**
1015      * @dev See {IERC721-setApprovalForAll}.
1016      */
1017     function setApprovalForAll(address operator, bool approved) public virtual override {
1018         _setApprovalForAll(_msgSender(), operator, approved);
1019     }
1020 
1021     /**
1022      * @dev See {IERC721-isApprovedForAll}.
1023      */
1024     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1025         return _operatorApprovals[owner][operator];
1026     }
1027 
1028     /**
1029      * @dev See {IERC721-transferFrom}.
1030      */
1031     function transferFrom(
1032         address from,
1033         address to,
1034         uint256 tokenId
1035     ) public virtual override {
1036         //solhint-disable-next-line max-line-length
1037         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1038 
1039         _transfer(from, to, tokenId);
1040     }
1041 
1042     /**
1043      * @dev See {IERC721-safeTransferFrom}.
1044      */
1045     function safeTransferFrom(
1046         address from,
1047         address to,
1048         uint256 tokenId
1049     ) public virtual override {
1050         safeTransferFrom(from, to, tokenId, "");
1051     }
1052 
1053     /**
1054      * @dev See {IERC721-safeTransferFrom}.
1055      */
1056     function safeTransferFrom(
1057         address from,
1058         address to,
1059         uint256 tokenId,
1060         bytes memory _data
1061     ) public virtual override {
1062         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1063         _safeTransfer(from, to, tokenId, _data);
1064     }
1065 
1066     /**
1067      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1068      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1069      *
1070      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1071      *
1072      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1073      * implement alternative mechanisms to perform token transfer, such as signature-based.
1074      *
1075      * Requirements:
1076      *
1077      * - `from` cannot be the zero address.
1078      * - `to` cannot be the zero address.
1079      * - `tokenId` token must exist and be owned by `from`.
1080      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1081      *
1082      * Emits a {Transfer} event.
1083      */
1084     function _safeTransfer(
1085         address from,
1086         address to,
1087         uint256 tokenId,
1088         bytes memory _data
1089     ) internal virtual {
1090         _transfer(from, to, tokenId);
1091         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1092     }
1093 
1094     /**
1095      * @dev Returns whether `tokenId` exists.
1096      *
1097      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1098      *
1099      * Tokens start existing when they are minted (`_mint`),
1100      * and stop existing when they are burned (`_burn`).
1101      */
1102     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1103         return _owners[tokenId] != address(0);
1104     }
1105 
1106     /**
1107      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1108      *
1109      * Requirements:
1110      *
1111      * - `tokenId` must exist.
1112      */
1113     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1114         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1115         address owner = ERC721.ownerOf(tokenId);
1116         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1117     }
1118 
1119     /**
1120      * @dev Safely mints `tokenId` and transfers it to `to`.
1121      *
1122      * Requirements:
1123      *
1124      * - `tokenId` must not exist.
1125      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1126      *
1127      * Emits a {Transfer} event.
1128      */
1129     function _safeMint(address to, uint256 tokenId) internal virtual {
1130         _safeMint(to, tokenId, "");
1131     }
1132 
1133     /**
1134      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1135      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1136      */
1137     function _safeMint(
1138         address to,
1139         uint256 tokenId,
1140         bytes memory _data
1141     ) internal virtual {
1142         _mint(to, tokenId);
1143         require(
1144             _checkOnERC721Received(address(0), to, tokenId, _data),
1145             "ERC721: transfer to non ERC721Receiver implementer"
1146         );
1147     }
1148 
1149     /**
1150      * @dev Mints `tokenId` and transfers it to `to`.
1151      *
1152      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1153      *
1154      * Requirements:
1155      *
1156      * - `tokenId` must not exist.
1157      * - `to` cannot be the zero address.
1158      *
1159      * Emits a {Transfer} event.
1160      */
1161     function _mint(address to, uint256 tokenId) internal virtual {
1162         require(to != address(0), "ERC721: mint to the zero address");
1163         require(!_exists(tokenId), "ERC721: token already minted");
1164 
1165         _beforeTokenTransfer(address(0), to, tokenId);
1166 
1167         _balances[to] += 1;
1168         _owners[tokenId] = to;
1169 
1170         emit Transfer(address(0), to, tokenId);
1171     }
1172 
1173     /**
1174      * @dev Destroys `tokenId`.
1175      * The approval is cleared when the token is burned.
1176      *
1177      * Requirements:
1178      *
1179      * - `tokenId` must exist.
1180      *
1181      * Emits a {Transfer} event.
1182      */
1183     function _burn(uint256 tokenId) internal virtual {
1184         address owner = ERC721.ownerOf(tokenId);
1185 
1186         _beforeTokenTransfer(owner, address(0), tokenId);
1187 
1188         // Clear approvals
1189         _approve(address(0), tokenId);
1190 
1191         _balances[owner] -= 1;
1192         delete _owners[tokenId];
1193 
1194         emit Transfer(owner, address(0), tokenId);
1195     }
1196 
1197     /**
1198      * @dev Transfers `tokenId` from `from` to `to`.
1199      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1200      *
1201      * Requirements:
1202      *
1203      * - `to` cannot be the zero address.
1204      * - `tokenId` token must be owned by `from`.
1205      *
1206      * Emits a {Transfer} event.
1207      */
1208     function _transfer(
1209         address from,
1210         address to,
1211         uint256 tokenId
1212     ) internal virtual {
1213         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1214         require(to != address(0), "ERC721: transfer to the zero address");
1215 
1216         _beforeTokenTransfer(from, to, tokenId);
1217 
1218         // Clear approvals from the previous owner
1219         _approve(address(0), tokenId);
1220 
1221         _balances[from] -= 1;
1222         _balances[to] += 1;
1223         _owners[tokenId] = to;
1224 
1225         emit Transfer(from, to, tokenId);
1226     }
1227 
1228     /**
1229      * @dev Approve `to` to operate on `tokenId`
1230      *
1231      * Emits a {Approval} event.
1232      */
1233     function _approve(address to, uint256 tokenId) internal virtual {
1234         _tokenApprovals[tokenId] = to;
1235         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1236     }
1237 
1238     /**
1239      * @dev Approve `operator` to operate on all of `owner` tokens
1240      *
1241      * Emits a {ApprovalForAll} event.
1242      */
1243     function _setApprovalForAll(
1244         address owner,
1245         address operator,
1246         bool approved
1247     ) internal virtual {
1248         require(owner != operator, "ERC721: approve to caller");
1249         _operatorApprovals[owner][operator] = approved;
1250         emit ApprovalForAll(owner, operator, approved);
1251     }
1252 
1253     /**
1254      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1255      * The call is not executed if the target address is not a contract.
1256      *
1257      * @param from address representing the previous owner of the given token ID
1258      * @param to target address that will receive the tokens
1259      * @param tokenId uint256 ID of the token to be transferred
1260      * @param _data bytes optional data to send along with the call
1261      * @return bool whether the call correctly returned the expected magic value
1262      */
1263     function _checkOnERC721Received(
1264         address from,
1265         address to,
1266         uint256 tokenId,
1267         bytes memory _data
1268     ) private returns (bool) {
1269         if (to.isContract()) {
1270             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1271                 return retval == IERC721Receiver.onERC721Received.selector;
1272             } catch (bytes memory reason) {
1273                 if (reason.length == 0) {
1274                     revert("ERC721: transfer to non ERC721Receiver implementer");
1275                 } else {
1276                     assembly {
1277                         revert(add(32, reason), mload(reason))
1278                     }
1279                 }
1280             }
1281         } else {
1282             return true;
1283         }
1284     }
1285 
1286     /**
1287      * @dev Hook that is called before any token transfer. This includes minting
1288      * and burning.
1289      *
1290      * Calling conditions:
1291      *
1292      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1293      * transferred to `to`.
1294      * - When `from` is zero, `tokenId` will be minted for `to`.
1295      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1296      * - `from` and `to` are never both zero.
1297      *
1298      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1299      */
1300     function _beforeTokenTransfer(
1301         address from,
1302         address to,
1303         uint256 tokenId
1304     ) internal virtual {}
1305 }
1306 
1307 pragma solidity ^0.8.7;
1308 
1309 contract InvertedMutants is ERC721, Ownable {
1310     using Strings for uint256;
1311     using Counters for Counters.Counter;
1312     using ECDSA for bytes32;
1313     string private _tokenBaseURI = "https://gateway.pinata.cloud/ipfs/QmXPyNhvo9ZLLhq1SSaN2iGtmoxde5kdFy8dxvUWmSyyWX/";
1314     uint256 public IM_MAX = 4344;
1315     uint256 public IM_PRICE = 0.04444 ether;
1316     uint256 public IM_PER_MINT = 8;
1317     mapping(address => uint256) public CLAIMERS_LIST;
1318     address private PRIVATE_SIGNER = 0x83d32F9D97B3189CBC9Bd7b8270924153e8f53F9;
1319     string private constant SIG_WORD = "IM_CONTRACT";
1320     bool public mintLive;
1321     bool public founderMintCalled = false;
1322     Counters.Counter public _tokensMinted;
1323 
1324     constructor() ERC721("Inverted Mutants", "IM") {}
1325     
1326     function founderMint() external onlyOwner {
1327         require(!founderMintCalled, "Called");
1328         for(uint256 i = 0; i < 100; i++) {
1329             _tokensMinted.increment();
1330             _safeMint(msg.sender, _tokensMinted.current());
1331         }
1332         founderMintCalled = true;
1333     }
1334 
1335     function matchAddresSigner(bytes memory signature, uint256 allowedQuantity) private view returns(bool) {
1336          bytes32 hash = keccak256(abi.encodePacked(
1337             "\x19Ethereum Signed Message:\n32",
1338             keccak256(abi.encodePacked(msg.sender, SIG_WORD, allowedQuantity)))
1339           );
1340         return PRIVATE_SIGNER == hash.recover(signature);
1341     }   
1342 
1343     function mintFP(uint256 paidTokensQuantity, bytes memory signature, uint256 freeTokensQuantity, uint256 allowedFreeQuantity) external payable {
1344         require(mintLive, "MINT_CLOSED");
1345         require(matchAddresSigner(signature, allowedFreeQuantity), "DIRECT_MINT_DISALLOWED");
1346         require(_tokensMinted.current() + paidTokensQuantity + freeTokensQuantity <= IM_MAX, "EXCEED_MAX");
1347         require(CLAIMERS_LIST[msg.sender] + freeTokensQuantity <= allowedFreeQuantity, "EXCEED_PER_WALLET");
1348         require(paidTokensQuantity + freeTokensQuantity <= IM_PER_MINT, "EXCEED_PER_MINT");
1349         require(IM_PRICE * paidTokensQuantity <= msg.value, "INSUFFICIENT_ETH");
1350         for (uint256 i = 0; i < freeTokensQuantity; i++) {
1351             CLAIMERS_LIST[msg.sender]++;
1352             _tokensMinted.increment();
1353             _safeMint(msg.sender, _tokensMinted.current());
1354         }
1355         for (uint256 i = 0; i < paidTokensQuantity; i++) {
1356             _tokensMinted.increment();
1357             _safeMint(msg.sender, _tokensMinted.current());
1358         }
1359     }
1360 
1361     function freeMint(bytes memory signature, uint256 freeTokensQuantity, uint256 allowedFreeQuantity) external {
1362         require(mintLive, "MINT_CLOSED");
1363         require(matchAddresSigner(signature, allowedFreeQuantity), "DIRECT_MINT_DISALLOWED");
1364         require(_tokensMinted.current() + freeTokensQuantity <= IM_MAX, "EXCEED_MAX");
1365         require(CLAIMERS_LIST[msg.sender] + freeTokensQuantity <= allowedFreeQuantity, "EXCEED_PER_WALLET");
1366         require(freeTokensQuantity <= IM_PER_MINT, "EXCEED_PER_MINT");
1367         for (uint256 i = 0; i < freeTokensQuantity; i++) {
1368             CLAIMERS_LIST[msg.sender]++;
1369             _tokensMinted.increment();
1370             _safeMint(msg.sender, _tokensMinted.current());
1371         }
1372     }
1373 
1374     function mint(uint256 tokenQuantity) external payable {
1375         require(mintLive, "MINT_CLOSED");
1376         require(_tokensMinted.current() + tokenQuantity <= IM_MAX, "EXCEED_MAX");
1377         require(tokenQuantity <= IM_PER_MINT, "EXCEED_PER_MINT");
1378         require(IM_PRICE * tokenQuantity <= msg.value, "INSUFFICIENT_ETH");
1379         for (uint256 i = 0; i < tokenQuantity; i++) {
1380             _tokensMinted.increment();
1381             _safeMint(msg.sender, _tokensMinted.current());
1382         }
1383     }
1384 
1385     function withdraw() external onlyOwner {
1386         uint256 currentBalance = address(this).balance;
1387         payable(0x11111F01570EeAA3e5a2Fd51f4A2f127661B9834).transfer(currentBalance * 20 / 100);
1388         payable(0xF9ddAaE4cB4EeA050810D9F695B84978277cAD2e).transfer(address(this).balance);
1389     }
1390 
1391     function togglePublicMintStatus() external onlyOwner {
1392         mintLive = !mintLive;
1393     }
1394 
1395     function setPrice(uint256 newPrice) external onlyOwner {
1396         IM_PRICE = newPrice;
1397     }
1398     
1399     function setMax(uint256 newCount) external onlyOwner {
1400         IM_MAX = newCount;
1401     }
1402     
1403     function setBaseURI(string calldata URI) external onlyOwner {
1404         _tokenBaseURI = URI;
1405     }
1406     
1407     function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) {
1408         require(_exists(tokenId), "Cannot query non-existent token");
1409         return string(abi.encodePacked(_tokenBaseURI, tokenId.toString()));
1410     }
1411 
1412     function totalSupply() public view returns (uint256) {
1413         return _tokensMinted.current();
1414     }
1415 
1416     receive() external payable {}
1417 }