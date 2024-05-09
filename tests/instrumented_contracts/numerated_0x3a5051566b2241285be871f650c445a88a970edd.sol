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
223 // File: @openzeppelin/contracts/utils/Counters.sol
224 
225 
226 
227 pragma solidity ^0.8.0;
228 
229 /**
230  * @title Counters
231  * @author Matt Condon (@shrugs)
232  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
233  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
234  *
235  * Include with `using Counters for Counters.Counter;`
236  */
237 library Counters {
238     struct Counter {
239         // This variable should never be directly accessed by users of the library: interactions must be restricted to
240         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
241         // this feature: see https://github.com/ethereum/solidity/issues/4637
242         uint256 _value; // default: 0
243     }
244 
245     function current(Counter storage counter) internal view returns (uint256) {
246         return counter._value;
247     }
248 
249     function increment(Counter storage counter) internal {
250         unchecked {
251             counter._value += 1;
252         }
253     }
254 
255     function decrement(Counter storage counter) internal {
256         uint256 value = counter._value;
257         require(value > 0, "Counter: decrement overflow");
258         unchecked {
259             counter._value = value - 1;
260         }
261     }
262 
263     function reset(Counter storage counter) internal {
264         counter._value = 0;
265     }
266 }
267 
268 
269 
270 
271 // File: @openzeppelin/contracts/utils/Strings.sol
272 
273 
274 
275 pragma solidity ^0.8.0;
276 
277 /**
278  * @dev String operations.
279  */
280 library Strings {
281     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
282 
283     /**
284      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
285      */
286     function toString(uint256 value) internal pure returns (string memory) {
287         // Inspired by OraclizeAPI's implementation - MIT licence
288         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
289 
290         if (value == 0) {
291             return "0";
292         }
293         uint256 temp = value;
294         uint256 digits;
295         while (temp != 0) {
296             digits++;
297             temp /= 10;
298         }
299         bytes memory buffer = new bytes(digits);
300         while (value != 0) {
301             digits -= 1;
302             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
303             value /= 10;
304         }
305         return string(buffer);
306     }
307 
308     /**
309      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
310      */
311     function toHexString(uint256 value) internal pure returns (string memory) {
312         if (value == 0) {
313             return "0x00";
314         }
315         uint256 temp = value;
316         uint256 length = 0;
317         while (temp != 0) {
318             length++;
319             temp >>= 8;
320         }
321         return toHexString(value, length);
322     }
323 
324     /**
325      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
326      */
327     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
328         bytes memory buffer = new bytes(2 * length + 2);
329         buffer[0] = "0";
330         buffer[1] = "x";
331         for (uint256 i = 2 * length + 1; i > 1; --i) {
332             buffer[i] = _HEX_SYMBOLS[value & 0xf];
333             value >>= 4;
334         }
335         require(value == 0, "Strings: hex length insufficient");
336         return string(buffer);
337     }
338 }
339 
340 // File: @openzeppelin/contracts/utils/Context.sol
341 
342 
343 
344 pragma solidity ^0.8.0;
345 
346 /**
347  * @dev Provides information about the current execution context, including the
348  * sender of the transaction and its data. While these are generally available
349  * via msg.sender and msg.data, they should not be accessed in such a direct
350  * manner, since when dealing with meta-transactions the account sending and
351  * paying for execution may not be the actual sender (as far as an application
352  * is concerned).
353  *
354  * This contract is only required for intermediate, library-like contracts.
355  */
356 abstract contract Context {
357     function _msgSender() internal view virtual returns (address) {
358         return msg.sender;
359     }
360 
361     function _msgData() internal view virtual returns (bytes calldata) {
362         return msg.data;
363     }
364 }
365 
366 // File: @openzeppelin/contracts/access/Ownable.sol
367 
368 
369 
370 pragma solidity ^0.8.0;
371 
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
394         _setOwner(_msgSender());
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
420         _setOwner(address(0));
421     }
422 
423     /**
424      * @dev Transfers ownership of the contract to a new account (`newOwner`).
425      * Can only be called by the current owner.
426      */
427     function transferOwnership(address newOwner) public virtual onlyOwner {
428         require(newOwner != address(0), "Ownable: new owner is the zero address");
429         _setOwner(newOwner);
430     }
431 
432     function _setOwner(address newOwner) private {
433         address oldOwner = _owner;
434         _owner = newOwner;
435         emit OwnershipTransferred(oldOwner, newOwner);
436     }
437 }
438 
439 // File: @openzeppelin/contracts/utils/Address.sol
440 
441 
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
658 
659 
660 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
661 
662 
663 
664 pragma solidity ^0.8.0;
665 
666 /**
667  * @title ERC721 token receiver interface
668  * @dev Interface for any contract that wants to support safeTransfers
669  * from ERC721 asset contracts.
670  */
671 interface IERC721Receiver {
672     /**
673      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
674      * by `operator` from `from`, this function is called.
675      *
676      * It must return its Solidity selector to confirm the token transfer.
677      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
678      *
679      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
680      */
681     function onERC721Received(
682         address operator,
683         address from,
684         uint256 tokenId,
685         bytes calldata data
686     ) external returns (bytes4);
687 }
688 
689 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
690 
691 
692 
693 pragma solidity ^0.8.0;
694 
695 /**
696  * @dev Interface of the ERC165 standard, as defined in the
697  * https://eips.ethereum.org/EIPS/eip-165[EIP].
698  *
699  * Implementers can declare support of contract interfaces, which can then be
700  * queried by others ({ERC165Checker}).
701  *
702  * For an implementation, see {ERC165}.
703  */
704 interface IERC165 {
705     /**
706      * @dev Returns true if this contract implements the interface defined by
707      * `interfaceId`. See the corresponding
708      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
709      * to learn more about how these ids are created.
710      *
711      * This function call must use less than 30 000 gas.
712      */
713     function supportsInterface(bytes4 interfaceId) external view returns (bool);
714 }
715 
716 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
717 
718 
719 
720 pragma solidity ^0.8.0;
721 
722 
723 /**
724  * @dev Implementation of the {IERC165} interface.
725  *
726  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
727  * for the additional interface id that will be supported. For example:
728  *
729  * ```solidity
730  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
731  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
732  * }
733  * ```
734  *
735  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
736  */
737 abstract contract ERC165 is IERC165 {
738     /**
739      * @dev See {IERC165-supportsInterface}.
740      */
741     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
742         return interfaceId == type(IERC165).interfaceId;
743     }
744 }
745 
746 
747 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
748 
749 
750 
751 pragma solidity ^0.8.0;
752 
753 
754 /**
755  * @dev Required interface of an ERC721 compliant contract.
756  */
757 interface IERC721 is IERC165 {
758     /**
759      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
760      */
761     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
762 
763     /**
764      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
765      */
766     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
767 
768     /**
769      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
770      */
771     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
772 
773     /**
774      * @dev Returns the number of tokens in ``owner``'s account.
775      */
776     function balanceOf(address owner) external view returns (uint256 balance);
777 
778     /**
779      * @dev Returns the owner of the `tokenId` token.
780      *
781      * Requirements:
782      *
783      * - `tokenId` must exist.
784      */
785     function ownerOf(uint256 tokenId) external view returns (address owner);
786 
787     /**
788      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
789      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
790      *
791      * Requirements:
792      *
793      * - `from` cannot be the zero address.
794      * - `to` cannot be the zero address.
795      * - `tokenId` token must exist and be owned by `from`.
796      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
797      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
798      *
799      * Emits a {Transfer} event.
800      */
801     function safeTransferFrom(
802         address from,
803         address to,
804         uint256 tokenId
805     ) external;
806 
807     /**
808      * @dev Transfers `tokenId` token from `from` to `to`.
809      *
810      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
811      *
812      * Requirements:
813      *
814      * - `from` cannot be the zero address.
815      * - `to` cannot be the zero address.
816      * - `tokenId` token must be owned by `from`.
817      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
818      *
819      * Emits a {Transfer} event.
820      */
821     function transferFrom(
822         address from,
823         address to,
824         uint256 tokenId
825     ) external;
826 
827     /**
828      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
829      * The approval is cleared when the token is transferred.
830      *
831      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
832      *
833      * Requirements:
834      *
835      * - The caller must own the token or be an approved operator.
836      * - `tokenId` must exist.
837      *
838      * Emits an {Approval} event.
839      */
840     function approve(address to, uint256 tokenId) external;
841 
842     /**
843      * @dev Returns the account approved for `tokenId` token.
844      *
845      * Requirements:
846      *
847      * - `tokenId` must exist.
848      */
849     function getApproved(uint256 tokenId) external view returns (address operator);
850 
851     /**
852      * @dev Approve or remove `operator` as an operator for the caller.
853      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
854      *
855      * Requirements:
856      *
857      * - The `operator` cannot be the caller.
858      *
859      * Emits an {ApprovalForAll} event.
860      */
861     function setApprovalForAll(address operator, bool _approved) external;
862 
863     /**
864      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
865      *
866      * See {setApprovalForAll}
867      */
868     function isApprovedForAll(address owner, address operator) external view returns (bool);
869 
870     /**
871      * @dev Safely transfers `tokenId` token from `from` to `to`.
872      *
873      * Requirements:
874      *
875      * - `from` cannot be the zero address.
876      * - `to` cannot be the zero address.
877      * - `tokenId` token must exist and be owned by `from`.
878      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
879      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
880      *
881      * Emits a {Transfer} event.
882      */
883     function safeTransferFrom(
884         address from,
885         address to,
886         uint256 tokenId,
887         bytes calldata data
888     ) external;
889 }
890 
891 
892 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
893 
894 
895 
896 pragma solidity ^0.8.0;
897 
898 
899 /**
900  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
901  * @dev See https://eips.ethereum.org/EIPS/eip-721
902  */
903 interface IERC721Metadata is IERC721 {
904     /**
905      * @dev Returns the token collection name.
906      */
907     function name() external view returns (string memory);
908 
909     /**
910      * @dev Returns the token collection symbol.
911      */
912     function symbol() external view returns (string memory);
913 
914     /**
915      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
916      */
917     function tokenURI(uint256 tokenId) external view returns (string memory);
918 }
919 
920 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
921 
922 
923 
924 pragma solidity ^0.8.0;
925 
926 
927 
928 /**
929  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
930  * the Metadata extension, but not including the Enumerable extension, which is available separately as
931  * {ERC721Enumerable}.
932  */
933 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
934     using Address for address;
935     using Strings for uint256;
936 
937     // Token name
938     string private _name;
939 
940     // Token symbol
941     string private _symbol;
942 
943     // Mapping from token ID to owner address
944     mapping(uint256 => address) private _owners;
945 
946     // Mapping owner address to token count
947     mapping(address => uint256) private _balances;
948 
949     // Mapping from token ID to approved address
950     mapping(uint256 => address) private _tokenApprovals;
951 
952     // Mapping from owner to operator approvals
953     mapping(address => mapping(address => bool)) private _operatorApprovals;
954 
955     /**
956      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
957      */
958     constructor(string memory name_, string memory symbol_) {
959         _name = name_;
960         _symbol = symbol_;
961     }
962 
963     /**
964      * @dev See {IERC165-supportsInterface}.
965      */
966     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
967         return
968             interfaceId == type(IERC721).interfaceId ||
969             interfaceId == type(IERC721Metadata).interfaceId ||
970             super.supportsInterface(interfaceId);
971     }
972 
973     /**
974      * @dev See {IERC721-balanceOf}.
975      */
976     function balanceOf(address owner) public view virtual override returns (uint256) {
977         require(owner != address(0), "ERC721: balance query for the zero address");
978         return _balances[owner];
979     }
980 
981     /**
982      * @dev See {IERC721-ownerOf}.
983      */
984     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
985         address owner = _owners[tokenId];
986         require(owner != address(0), "ERC721: owner query for nonexistent token");
987         return owner;
988     }
989 
990     /**
991      * @dev See {IERC721Metadata-name}.
992      */
993     function name() public view virtual override returns (string memory) {
994         return _name;
995     }
996 
997     /**
998      * @dev See {IERC721Metadata-symbol}.
999      */
1000     function symbol() public view virtual override returns (string memory) {
1001         return _symbol;
1002     }
1003 
1004     /**
1005      * @dev See {IERC721Metadata-tokenURI}.
1006      */
1007     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1008         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1009 
1010         string memory baseURI = _baseURI();
1011         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1012     }
1013 
1014     /**
1015      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1016      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1017      * by default, can be overriden in child contracts.
1018      */
1019     function _baseURI() internal view virtual returns (string memory) {
1020         return "";
1021     }
1022 
1023     /**
1024      * @dev See {IERC721-approve}.
1025      */
1026     function approve(address to, uint256 tokenId) public virtual override {
1027         address owner = ERC721.ownerOf(tokenId);
1028         require(to != owner, "ERC721: approval to current owner");
1029 
1030         require(
1031             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1032             "ERC721: approve caller is not owner nor approved for all"
1033         );
1034 
1035         _approve(to, tokenId);
1036     }
1037 
1038     /**
1039      * @dev See {IERC721-getApproved}.
1040      */
1041     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1042         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1043 
1044         return _tokenApprovals[tokenId];
1045     }
1046 
1047     /**
1048      * @dev See {IERC721-setApprovalForAll}.
1049      */
1050     function setApprovalForAll(address operator, bool approved) public virtual override {
1051         require(operator != _msgSender(), "ERC721: approve to caller");
1052 
1053         _operatorApprovals[_msgSender()][operator] = approved;
1054         emit ApprovalForAll(_msgSender(), operator, approved);
1055     }
1056 
1057     /**
1058      * @dev See {IERC721-isApprovedForAll}.
1059      */
1060     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1061         return _operatorApprovals[owner][operator];
1062     }
1063 
1064     /**
1065      * @dev See {IERC721-transferFrom}.
1066      */
1067     function transferFrom(
1068         address from,
1069         address to,
1070         uint256 tokenId
1071     ) public virtual override {
1072         //solhint-disable-next-line max-line-length
1073         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1074 
1075         _transfer(from, to, tokenId);
1076     }
1077 
1078     /**
1079      * @dev See {IERC721-safeTransferFrom}.
1080      */
1081     function safeTransferFrom(
1082         address from,
1083         address to,
1084         uint256 tokenId
1085     ) public virtual override {
1086         safeTransferFrom(from, to, tokenId, "");
1087     }
1088 
1089     /**
1090      * @dev See {IERC721-safeTransferFrom}.
1091      */
1092     function safeTransferFrom(
1093         address from,
1094         address to,
1095         uint256 tokenId,
1096         bytes memory _data
1097     ) public virtual override {
1098         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1099         _safeTransfer(from, to, tokenId, _data);
1100     }
1101 
1102     /**
1103      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1104      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1105      *
1106      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1107      *
1108      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1109      * implement alternative mechanisms to perform token transfer, such as signature-based.
1110      *
1111      * Requirements:
1112      *
1113      * - `from` cannot be the zero address.
1114      * - `to` cannot be the zero address.
1115      * - `tokenId` token must exist and be owned by `from`.
1116      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1117      *
1118      * Emits a {Transfer} event.
1119      */
1120     function _safeTransfer(
1121         address from,
1122         address to,
1123         uint256 tokenId,
1124         bytes memory _data
1125     ) internal virtual {
1126         _transfer(from, to, tokenId);
1127         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1128     }
1129 
1130     /**
1131      * @dev Returns whether `tokenId` exists.
1132      *
1133      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1134      *
1135      * Tokens start existing when they are minted (`_mint`),
1136      * and stop existing when they are burned (`_burn`).
1137      */
1138     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1139         return _owners[tokenId] != address(0);
1140     }
1141 
1142     /**
1143      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1144      *
1145      * Requirements:
1146      *
1147      * - `tokenId` must exist.
1148      */
1149     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1150         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1151         address owner = ERC721.ownerOf(tokenId);
1152         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1153     }
1154 
1155     /**
1156      * @dev Safely mints `tokenId` and transfers it to `to`.
1157      *
1158      * Requirements:
1159      *
1160      * - `tokenId` must not exist.
1161      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1162      *
1163      * Emits a {Transfer} event.
1164      */
1165     function _safeMint(address to, uint256 tokenId) internal virtual {
1166         _safeMint(to, tokenId, "");
1167     }
1168 
1169     /**
1170      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1171      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1172      */
1173     function _safeMint(
1174         address to,
1175         uint256 tokenId,
1176         bytes memory _data
1177     ) internal virtual {
1178         _mint(to, tokenId);
1179         require(
1180             _checkOnERC721Received(address(0), to, tokenId, _data),
1181             "ERC721: transfer to non ERC721Receiver implementer"
1182         );
1183     }
1184 
1185     /**
1186      * @dev Mints `tokenId` and transfers it to `to`.
1187      *
1188      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1189      *
1190      * Requirements:
1191      *
1192      * - `tokenId` must not exist.
1193      * - `to` cannot be the zero address.
1194      *
1195      * Emits a {Transfer} event.
1196      */
1197     function _mint(address to, uint256 tokenId) internal virtual {
1198         require(to != address(0), "ERC721: mint to the zero address");
1199         require(!_exists(tokenId), "ERC721: token already minted");
1200 
1201         _beforeTokenTransfer(address(0), to, tokenId);
1202 
1203         _balances[to] += 1;
1204         _owners[tokenId] = to;
1205 
1206         emit Transfer(address(0), to, tokenId);
1207     }
1208 
1209     /**
1210      * @dev Destroys `tokenId`.
1211      * The approval is cleared when the token is burned.
1212      *
1213      * Requirements:
1214      *
1215      * - `tokenId` must exist.
1216      *
1217      * Emits a {Transfer} event.
1218      */
1219     function _burn(uint256 tokenId) internal virtual {
1220         address owner = ERC721.ownerOf(tokenId);
1221 
1222         _beforeTokenTransfer(owner, address(0), tokenId);
1223 
1224         // Clear approvals
1225         _approve(address(0), tokenId);
1226 
1227         _balances[owner] -= 1;
1228         delete _owners[tokenId];
1229 
1230         emit Transfer(owner, address(0), tokenId);
1231     }
1232 
1233     /**
1234      * @dev Transfers `tokenId` from `from` to `to`.
1235      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1236      *
1237      * Requirements:
1238      *
1239      * - `to` cannot be the zero address.
1240      * - `tokenId` token must be owned by `from`.
1241      *
1242      * Emits a {Transfer} event.
1243      */
1244     function _transfer(
1245         address from,
1246         address to,
1247         uint256 tokenId
1248     ) internal virtual {
1249         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1250         require(to != address(0), "ERC721: transfer to the zero address");
1251 
1252         _beforeTokenTransfer(from, to, tokenId);
1253 
1254         // Clear approvals from the previous owner
1255         _approve(address(0), tokenId);
1256 
1257         _balances[from] -= 1;
1258         _balances[to] += 1;
1259         _owners[tokenId] = to;
1260 
1261         emit Transfer(from, to, tokenId);
1262     }
1263 
1264     /**
1265      * @dev Approve `to` to operate on `tokenId`
1266      *
1267      * Emits a {Approval} event.
1268      */
1269     function _approve(address to, uint256 tokenId) internal virtual {
1270         _tokenApprovals[tokenId] = to;
1271         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1272     }
1273 
1274     /**
1275      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1276      * The call is not executed if the target address is not a contract.
1277      *
1278      * @param from address representing the previous owner of the given token ID
1279      * @param to target address that will receive the tokens
1280      * @param tokenId uint256 ID of the token to be transferred
1281      * @param _data bytes optional data to send along with the call
1282      * @return bool whether the call correctly returned the expected magic value
1283      */
1284     function _checkOnERC721Received(
1285         address from,
1286         address to,
1287         uint256 tokenId,
1288         bytes memory _data
1289     ) private returns (bool) {
1290         if (to.isContract()) {
1291             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1292                 return retval == IERC721Receiver.onERC721Received.selector;
1293             } catch (bytes memory reason) {
1294                 if (reason.length == 0) {
1295                     revert("ERC721: transfer to non ERC721Receiver implementer");
1296                 } else {
1297                     assembly {
1298                         revert(add(32, reason), mload(reason))
1299                     }
1300                 }
1301             }
1302         } else {
1303             return true;
1304         }
1305     }
1306 
1307     /**
1308      * @dev Hook that is called before any token transfer. This includes minting
1309      * and burning.
1310      *
1311      * Calling conditions:
1312      *
1313      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1314      * transferred to `to`.
1315      * - When `from` is zero, `tokenId` will be minted for `to`.
1316      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1317      * - `from` and `to` are never both zero.
1318      *
1319      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1320      */
1321     function _beforeTokenTransfer(
1322         address from,
1323         address to,
1324         uint256 tokenId
1325     ) internal virtual {}
1326 }
1327 
1328 
1329 
1330 // File: contracts/thehumanoids.sol
1331 
1332 
1333 pragma solidity 0.8.0;
1334 
1335 
1336 
1337 
1338 
1339 
1340 contract TheHumanoids is ERC721, Ownable {
1341     using Address for address;
1342     using Counters for Counters.Counter;
1343 
1344     Counters.Counter private _tokenCount; 
1345 
1346     string public baseURI;
1347     uint256 public constant price = 80000000000000000; // 0.08 ETH
1348     uint256 public constant maxTokens = 10000;
1349     uint256 public maxWallet = 10;
1350     bool public saleIsActive = false;
1351     bool public presaleIsActive = false;
1352     bool public hasReserved = false;
1353 
1354     mapping(address => uint256) public minted; // To check how many tokens an address has minted
1355     address private _signerAddress = 0xe6317C8292182bd4edd882946D54D51E970d10fb; 
1356 
1357     constructor() ERC721("The Humanoids ", "HMNDS") {
1358     }
1359 
1360     // reserve (60 tokens)
1361     function reserve() external onlyOwner {
1362         require(!hasReserved, "Tokens have already been reserved.");
1363 
1364         for (uint i; i < 60; i++) {
1365             _tokenCount.increment();
1366             _safeMint(msg.sender, _tokenCount.current());
1367         }
1368         hasReserved = true;
1369     }
1370 
1371     function mint(uint256 _amount) external payable {
1372         require(saleIsActive, "Sale must be active");
1373         require(!Address.isContract(msg.sender), "Contracts are not allowed to mint");
1374         require(minted[msg.sender] + _amount <= maxWallet, "Purchase would exceed max tokens per wallet");
1375         require(_tokenCount.current() + _amount <= maxTokens, "Purchase would exceed max supply of tokens");
1376         require(msg.value >= price * _amount, "Ether value sent is not correct");
1377 
1378 
1379         for(uint i; i < _amount; i++) {
1380             _tokenCount.increment();
1381             _safeMint(msg.sender, _tokenCount.current());
1382         }
1383 
1384         minted[msg.sender] += _amount;
1385     }
1386 
1387     function mintPresale(uint256 _amount, uint256 _maxTotal, uint8 _signatureV, bytes32 _signatureR, bytes32 _signatureS) external payable {
1388         require(presaleIsActive,"Presale must be active");
1389         require(_tokenCount.current() + _amount <= maxTokens, "Purchase would exceed max supply of Tokens");
1390         require(msg.value >= price * _amount, "Ether value sent is not correct");
1391         require(minted[msg.sender] + _amount <= _maxTotal, "Purchase would exceed max tokens for presale");
1392 
1393         bytes32 hash = keccak256(abi.encode(msg.sender, _maxTotal));
1394         address signer = ECDSA.recover(hash, _signatureV,  _signatureR,  _signatureS);
1395         require(signer == _signerAddress, "Invalid signature");
1396         
1397         for(uint i; i < _amount; i++){
1398             _tokenCount.increment();
1399             _safeMint(msg.sender, _tokenCount.current());
1400         }
1401 
1402         minted[msg.sender] += _amount;
1403     }
1404 
1405     function totalSupply() public view returns (uint256) { 
1406         return _tokenCount.current(); 
1407     }
1408 
1409     function setBaseURI(string memory __baseURI) external onlyOwner {
1410         baseURI = __baseURI;
1411     }
1412     
1413     function _baseURI() internal view override returns (string memory) {
1414         return baseURI;
1415     }
1416 
1417     function flipSaleState() public onlyOwner {
1418         saleIsActive = !saleIsActive;
1419     }
1420 
1421     function flipPresaleState() public onlyOwner {
1422         presaleIsActive = !presaleIsActive;
1423     }
1424 
1425     function setMaxWallet(uint _newMaxWallet) external onlyOwner {
1426         maxWallet = _newMaxWallet;
1427     }
1428 
1429     function withdrawAll() external onlyOwner {
1430         uint balance = address(this).balance;
1431         payable(msg.sender).transfer(balance);
1432     }
1433 
1434 }