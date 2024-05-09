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
268 // File: @openzeppelin/contracts/utils/Strings.sol
269 
270 
271 
272 pragma solidity ^0.8.0;
273 
274 /**
275  * @dev String operations.
276  */
277 library Strings {
278     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
279 
280     /**
281      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
282      */
283     function toString(uint256 value) internal pure returns (string memory) {
284         // Inspired by OraclizeAPI's implementation - MIT licence
285         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
286 
287         if (value == 0) {
288             return "0";
289         }
290         uint256 temp = value;
291         uint256 digits;
292         while (temp != 0) {
293             digits++;
294             temp /= 10;
295         }
296         bytes memory buffer = new bytes(digits);
297         while (value != 0) {
298             digits -= 1;
299             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
300             value /= 10;
301         }
302         return string(buffer);
303     }
304 
305     /**
306      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
307      */
308     function toHexString(uint256 value) internal pure returns (string memory) {
309         if (value == 0) {
310             return "0x00";
311         }
312         uint256 temp = value;
313         uint256 length = 0;
314         while (temp != 0) {
315             length++;
316             temp >>= 8;
317         }
318         return toHexString(value, length);
319     }
320 
321     /**
322      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
323      */
324     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
325         bytes memory buffer = new bytes(2 * length + 2);
326         buffer[0] = "0";
327         buffer[1] = "x";
328         for (uint256 i = 2 * length + 1; i > 1; --i) {
329             buffer[i] = _HEX_SYMBOLS[value & 0xf];
330             value >>= 4;
331         }
332         require(value == 0, "Strings: hex length insufficient");
333         return string(buffer);
334     }
335 }
336 
337 // File: @openzeppelin/contracts/utils/Context.sol
338 
339 
340 
341 pragma solidity ^0.8.0;
342 
343 /**
344  * @dev Provides information about the current execution context, including the
345  * sender of the transaction and its data. While these are generally available
346  * via msg.sender and msg.data, they should not be accessed in such a direct
347  * manner, since when dealing with meta-transactions the account sending and
348  * paying for execution may not be the actual sender (as far as an application
349  * is concerned).
350  *
351  * This contract is only required for intermediate, library-like contracts.
352  */
353 abstract contract Context {
354     function _msgSender() internal view virtual returns (address) {
355         return msg.sender;
356     }
357 
358     function _msgData() internal view virtual returns (bytes calldata) {
359         return msg.data;
360     }
361 }
362 
363 // File: @openzeppelin/contracts/access/Ownable.sol
364 
365 
366 
367 pragma solidity ^0.8.0;
368 
369 
370 /**
371  * @dev Contract module which provides a basic access control mechanism, where
372  * there is an account (an owner) that can be granted exclusive access to
373  * specific functions.
374  *
375  * By default, the owner account will be the one that deploys the contract. This
376  * can later be changed with {transferOwnership}.
377  *
378  * This module is used through inheritance. It will make available the modifier
379  * `onlyOwner`, which can be applied to your functions to restrict their use to
380  * the owner.
381  */
382 abstract contract Ownable is Context {
383     address private _owner;
384 
385     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
386 
387     /**
388      * @dev Initializes the contract setting the deployer as the initial owner.
389      */
390     constructor() {
391         _setOwner(_msgSender());
392     }
393 
394     /**
395      * @dev Returns the address of the current owner.
396      */
397     function owner() public view virtual returns (address) {
398         return _owner;
399     }
400 
401     /**
402      * @dev Throws if called by any account other than the owner.
403      */
404     modifier onlyOwner() {
405         require(owner() == _msgSender(), "Ownable: caller is not the owner");
406         _;
407     }
408 
409     /**
410      * @dev Leaves the contract without owner. It will not be possible to call
411      * `onlyOwner` functions anymore. Can only be called by the current owner.
412      *
413      * NOTE: Renouncing ownership will leave the contract without an owner,
414      * thereby removing any functionality that is only available to the owner.
415      */
416     function renounceOwnership() public virtual onlyOwner {
417         _setOwner(address(0));
418     }
419 
420     /**
421      * @dev Transfers ownership of the contract to a new account (`newOwner`).
422      * Can only be called by the current owner.
423      */
424     function transferOwnership(address newOwner) public virtual onlyOwner {
425         require(newOwner != address(0), "Ownable: new owner is the zero address");
426         _setOwner(newOwner);
427     }
428 
429     function _setOwner(address newOwner) private {
430         address oldOwner = _owner;
431         _owner = newOwner;
432         emit OwnershipTransferred(oldOwner, newOwner);
433     }
434 }
435 
436 // File: @openzeppelin/contracts/utils/Address.sol
437 
438 
439 
440 pragma solidity ^0.8.0;
441 
442 /**
443  * @dev Collection of functions related to the address type
444  */
445 library Address {
446     /**
447      * @dev Returns true if `account` is a contract.
448      *
449      * [IMPORTANT]
450      * ====
451      * It is unsafe to assume that an address for which this function returns
452      * false is an externally-owned account (EOA) and not a contract.
453      *
454      * Among others, `isContract` will return false for the following
455      * types of addresses:
456      *
457      *  - an externally-owned account
458      *  - a contract in construction
459      *  - an address where a contract will be created
460      *  - an address where a contract lived, but was destroyed
461      * ====
462      */
463     function isContract(address account) internal view returns (bool) {
464         // This method relies on extcodesize, which returns 0 for contracts in
465         // construction, since the code is only stored at the end of the
466         // constructor execution.
467 
468         uint256 size;
469         assembly {
470             size := extcodesize(account)
471         }
472         return size > 0;
473     }
474 
475     /**
476      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
477      * `recipient`, forwarding all available gas and reverting on errors.
478      *
479      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
480      * of certain opcodes, possibly making contracts go over the 2300 gas limit
481      * imposed by `transfer`, making them unable to receive funds via
482      * `transfer`. {sendValue} removes this limitation.
483      *
484      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
485      *
486      * IMPORTANT: because control is transferred to `recipient`, care must be
487      * taken to not create reentrancy vulnerabilities. Consider using
488      * {ReentrancyGuard} or the
489      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
490      */
491     function sendValue(address payable recipient, uint256 amount) internal {
492         require(address(this).balance >= amount, "Address: insufficient balance");
493 
494         (bool success, ) = recipient.call{value: amount}("");
495         require(success, "Address: unable to send value, recipient may have reverted");
496     }
497 
498     /**
499      * @dev Performs a Solidity function call using a low level `call`. A
500      * plain `call` is an unsafe replacement for a function call: use this
501      * function instead.
502      *
503      * If `target` reverts with a revert reason, it is bubbled up by this
504      * function (like regular Solidity function calls).
505      *
506      * Returns the raw returned data. To convert to the expected return value,
507      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
508      *
509      * Requirements:
510      *
511      * - `target` must be a contract.
512      * - calling `target` with `data` must not revert.
513      *
514      * _Available since v3.1._
515      */
516     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
517         return functionCall(target, data, "Address: low-level call failed");
518     }
519 
520     /**
521      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
522      * `errorMessage` as a fallback revert reason when `target` reverts.
523      *
524      * _Available since v3.1._
525      */
526     function functionCall(
527         address target,
528         bytes memory data,
529         string memory errorMessage
530     ) internal returns (bytes memory) {
531         return functionCallWithValue(target, data, 0, errorMessage);
532     }
533 
534     /**
535      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
536      * but also transferring `value` wei to `target`.
537      *
538      * Requirements:
539      *
540      * - the calling contract must have an ETH balance of at least `value`.
541      * - the called Solidity function must be `payable`.
542      *
543      * _Available since v3.1._
544      */
545     function functionCallWithValue(
546         address target,
547         bytes memory data,
548         uint256 value
549     ) internal returns (bytes memory) {
550         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
551     }
552 
553     /**
554      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
555      * with `errorMessage` as a fallback revert reason when `target` reverts.
556      *
557      * _Available since v3.1._
558      */
559     function functionCallWithValue(
560         address target,
561         bytes memory data,
562         uint256 value,
563         string memory errorMessage
564     ) internal returns (bytes memory) {
565         require(address(this).balance >= value, "Address: insufficient balance for call");
566         require(isContract(target), "Address: call to non-contract");
567 
568         (bool success, bytes memory returndata) = target.call{value: value}(data);
569         return verifyCallResult(success, returndata, errorMessage);
570     }
571 
572     /**
573      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
574      * but performing a static call.
575      *
576      * _Available since v3.3._
577      */
578     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
579         return functionStaticCall(target, data, "Address: low-level static call failed");
580     }
581 
582     /**
583      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
584      * but performing a static call.
585      *
586      * _Available since v3.3._
587      */
588     function functionStaticCall(
589         address target,
590         bytes memory data,
591         string memory errorMessage
592     ) internal view returns (bytes memory) {
593         require(isContract(target), "Address: static call to non-contract");
594 
595         (bool success, bytes memory returndata) = target.staticcall(data);
596         return verifyCallResult(success, returndata, errorMessage);
597     }
598 
599     /**
600      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
601      * but performing a delegate call.
602      *
603      * _Available since v3.4._
604      */
605     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
606         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
607     }
608 
609     /**
610      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
611      * but performing a delegate call.
612      *
613      * _Available since v3.4._
614      */
615     function functionDelegateCall(
616         address target,
617         bytes memory data,
618         string memory errorMessage
619     ) internal returns (bytes memory) {
620         require(isContract(target), "Address: delegate call to non-contract");
621 
622         (bool success, bytes memory returndata) = target.delegatecall(data);
623         return verifyCallResult(success, returndata, errorMessage);
624     }
625 
626     /**
627      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
628      * revert reason using the provided one.
629      *
630      * _Available since v4.3._
631      */
632     function verifyCallResult(
633         bool success,
634         bytes memory returndata,
635         string memory errorMessage
636     ) internal pure returns (bytes memory) {
637         if (success) {
638             return returndata;
639         } else {
640             // Look for revert reason and bubble it up if present
641             if (returndata.length > 0) {
642                 // The easiest way to bubble the revert reason is using memory via assembly
643 
644                 assembly {
645                     let returndata_size := mload(returndata)
646                     revert(add(32, returndata), returndata_size)
647                 }
648             } else {
649                 revert(errorMessage);
650             }
651         }
652     }
653 }
654 
655 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
656 
657 
658 
659 pragma solidity ^0.8.0;
660 
661 /**
662  * @title ERC721 token receiver interface
663  * @dev Interface for any contract that wants to support safeTransfers
664  * from ERC721 asset contracts.
665  */
666 interface IERC721Receiver {
667     /**
668      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
669      * by `operator` from `from`, this function is called.
670      *
671      * It must return its Solidity selector to confirm the token transfer.
672      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
673      *
674      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
675      */
676     function onERC721Received(
677         address operator,
678         address from,
679         uint256 tokenId,
680         bytes calldata data
681     ) external returns (bytes4);
682 }
683 
684 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
685 
686 
687 
688 pragma solidity ^0.8.0;
689 
690 /**
691  * @dev Interface of the ERC165 standard, as defined in the
692  * https://eips.ethereum.org/EIPS/eip-165[EIP].
693  *
694  * Implementers can declare support of contract interfaces, which can then be
695  * queried by others ({ERC165Checker}).
696  *
697  * For an implementation, see {ERC165}.
698  */
699 interface IERC165 {
700     /**
701      * @dev Returns true if this contract implements the interface defined by
702      * `interfaceId`. See the corresponding
703      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
704      * to learn more about how these ids are created.
705      *
706      * This function call must use less than 30 000 gas.
707      */
708     function supportsInterface(bytes4 interfaceId) external view returns (bool);
709 }
710 
711 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
712 
713 
714 
715 pragma solidity ^0.8.0;
716 
717 
718 /**
719  * @dev Implementation of the {IERC165} interface.
720  *
721  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
722  * for the additional interface id that will be supported. For example:
723  *
724  * ```solidity
725  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
726  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
727  * }
728  * ```
729  *
730  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
731  */
732 abstract contract ERC165 is IERC165 {
733     /**
734      * @dev See {IERC165-supportsInterface}.
735      */
736     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
737         return interfaceId == type(IERC165).interfaceId;
738     }
739 }
740 
741 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
742 
743 
744 
745 pragma solidity ^0.8.0;
746 
747 
748 /**
749  * @dev Required interface of an ERC721 compliant contract.
750  */
751 interface IERC721 is IERC165 {
752     /**
753      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
754      */
755     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
756 
757     /**
758      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
759      */
760     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
761 
762     /**
763      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
764      */
765     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
766 
767     /**
768      * @dev Returns the number of tokens in ``owner``'s account.
769      */
770     function balanceOf(address owner) external view returns (uint256 balance);
771 
772     /**
773      * @dev Returns the owner of the `tokenId` token.
774      *
775      * Requirements:
776      *
777      * - `tokenId` must exist.
778      */
779     function ownerOf(uint256 tokenId) external view returns (address owner);
780 
781     /**
782      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
783      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
784      *
785      * Requirements:
786      *
787      * - `from` cannot be the zero address.
788      * - `to` cannot be the zero address.
789      * - `tokenId` token must exist and be owned by `from`.
790      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
791      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
792      *
793      * Emits a {Transfer} event.
794      */
795     function safeTransferFrom(
796         address from,
797         address to,
798         uint256 tokenId
799     ) external;
800 
801     /**
802      * @dev Transfers `tokenId` token from `from` to `to`.
803      *
804      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
805      *
806      * Requirements:
807      *
808      * - `from` cannot be the zero address.
809      * - `to` cannot be the zero address.
810      * - `tokenId` token must be owned by `from`.
811      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
812      *
813      * Emits a {Transfer} event.
814      */
815     function transferFrom(
816         address from,
817         address to,
818         uint256 tokenId
819     ) external;
820 
821     /**
822      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
823      * The approval is cleared when the token is transferred.
824      *
825      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
826      *
827      * Requirements:
828      *
829      * - The caller must own the token or be an approved operator.
830      * - `tokenId` must exist.
831      *
832      * Emits an {Approval} event.
833      */
834     function approve(address to, uint256 tokenId) external;
835 
836     /**
837      * @dev Returns the account approved for `tokenId` token.
838      *
839      * Requirements:
840      *
841      * - `tokenId` must exist.
842      */
843     function getApproved(uint256 tokenId) external view returns (address operator);
844 
845     /**
846      * @dev Approve or remove `operator` as an operator for the caller.
847      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
848      *
849      * Requirements:
850      *
851      * - The `operator` cannot be the caller.
852      *
853      * Emits an {ApprovalForAll} event.
854      */
855     function setApprovalForAll(address operator, bool _approved) external;
856 
857     /**
858      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
859      *
860      * See {setApprovalForAll}
861      */
862     function isApprovedForAll(address owner, address operator) external view returns (bool);
863 
864     /**
865      * @dev Safely transfers `tokenId` token from `from` to `to`.
866      *
867      * Requirements:
868      *
869      * - `from` cannot be the zero address.
870      * - `to` cannot be the zero address.
871      * - `tokenId` token must exist and be owned by `from`.
872      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
873      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
874      *
875      * Emits a {Transfer} event.
876      */
877     function safeTransferFrom(
878         address from,
879         address to,
880         uint256 tokenId,
881         bytes calldata data
882     ) external;
883 }
884 
885 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
886 
887 
888 
889 pragma solidity ^0.8.0;
890 
891 
892 /**
893  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
894  * @dev See https://eips.ethereum.org/EIPS/eip-721
895  */
896 interface IERC721Enumerable is IERC721 {
897     /**
898      * @dev Returns the total amount of tokens stored by the contract.
899      */
900     function totalSupply() external view returns (uint256);
901 
902     /**
903      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
904      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
905      */
906     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
907 
908     /**
909      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
910      * Use along with {totalSupply} to enumerate all tokens.
911      */
912     function tokenByIndex(uint256 index) external view returns (uint256);
913 }
914 
915 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
916 
917 
918 
919 pragma solidity ^0.8.0;
920 
921 
922 /**
923  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
924  * @dev See https://eips.ethereum.org/EIPS/eip-721
925  */
926 interface IERC721Metadata is IERC721 {
927     /**
928      * @dev Returns the token collection name.
929      */
930     function name() external view returns (string memory);
931 
932     /**
933      * @dev Returns the token collection symbol.
934      */
935     function symbol() external view returns (string memory);
936 
937     /**
938      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
939      */
940     function tokenURI(uint256 tokenId) external view returns (string memory);
941 }
942 
943 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
944 
945 
946 
947 pragma solidity ^0.8.0;
948 
949 
950 
951 
952 
953 
954 
955 
956 /**
957  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
958  * the Metadata extension, but not including the Enumerable extension, which is available separately as
959  * {ERC721Enumerable}.
960  */
961 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
962     using Address for address;
963     using Strings for uint256;
964 
965     // Token name
966     string private _name;
967 
968     // Token symbol
969     string private _symbol;
970 
971     // Mapping from token ID to owner address
972     mapping(uint256 => address) private _owners;
973 
974     // Mapping owner address to token count
975     mapping(address => uint256) private _balances;
976 
977     // Mapping from token ID to approved address
978     mapping(uint256 => address) private _tokenApprovals;
979 
980     // Mapping from owner to operator approvals
981     mapping(address => mapping(address => bool)) private _operatorApprovals;
982 
983     /**
984      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
985      */
986     constructor(string memory name_, string memory symbol_) {
987         _name = name_;
988         _symbol = symbol_;
989     }
990 
991     /**
992      * @dev See {IERC165-supportsInterface}.
993      */
994     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
995         return
996             interfaceId == type(IERC721).interfaceId ||
997             interfaceId == type(IERC721Metadata).interfaceId ||
998             super.supportsInterface(interfaceId);
999     }
1000 
1001     /**
1002      * @dev See {IERC721-balanceOf}.
1003      */
1004     function balanceOf(address owner) public view virtual override returns (uint256) {
1005         require(owner != address(0), "ERC721: balance query for the zero address");
1006         return _balances[owner];
1007     }
1008 
1009     /**
1010      * @dev See {IERC721-ownerOf}.
1011      */
1012     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1013         address owner = _owners[tokenId];
1014         require(owner != address(0), "ERC721: owner query for nonexistent token");
1015         return owner;
1016     }
1017 
1018     /**
1019      * @dev See {IERC721Metadata-name}.
1020      */
1021     function name() public view virtual override returns (string memory) {
1022         return _name;
1023     }
1024 
1025     /**
1026      * @dev See {IERC721Metadata-symbol}.
1027      */
1028     function symbol() public view virtual override returns (string memory) {
1029         return _symbol;
1030     }
1031 
1032     /**
1033      * @dev See {IERC721Metadata-tokenURI}.
1034      */
1035     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1036         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1037 
1038         string memory baseURI = _baseURI();
1039         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1040     }
1041 
1042     /**
1043      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1044      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1045      * by default, can be overriden in child contracts.
1046      */
1047     function _baseURI() internal view virtual returns (string memory) {
1048         return "";
1049     }
1050 
1051     /**
1052      * @dev See {IERC721-approve}.
1053      */
1054     function approve(address to, uint256 tokenId) public virtual override {
1055         address owner = ERC721.ownerOf(tokenId);
1056         require(to != owner, "ERC721: approval to current owner");
1057 
1058         require(
1059             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1060             "ERC721: approve caller is not owner nor approved for all"
1061         );
1062 
1063         _approve(to, tokenId);
1064     }
1065 
1066     /**
1067      * @dev See {IERC721-getApproved}.
1068      */
1069     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1070         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1071 
1072         return _tokenApprovals[tokenId];
1073     }
1074 
1075     /**
1076      * @dev See {IERC721-setApprovalForAll}.
1077      */
1078     function setApprovalForAll(address operator, bool approved) public virtual override {
1079         require(operator != _msgSender(), "ERC721: approve to caller");
1080 
1081         _operatorApprovals[_msgSender()][operator] = approved;
1082         emit ApprovalForAll(_msgSender(), operator, approved);
1083     }
1084 
1085     /**
1086      * @dev See {IERC721-isApprovedForAll}.
1087      */
1088     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1089         return _operatorApprovals[owner][operator];
1090     }
1091 
1092     /**
1093      * @dev See {IERC721-transferFrom}.
1094      */
1095     function transferFrom(
1096         address from,
1097         address to,
1098         uint256 tokenId
1099     ) public virtual override {
1100         //solhint-disable-next-line max-line-length
1101         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1102 
1103         _transfer(from, to, tokenId);
1104     }
1105 
1106     /**
1107      * @dev See {IERC721-safeTransferFrom}.
1108      */
1109     function safeTransferFrom(
1110         address from,
1111         address to,
1112         uint256 tokenId
1113     ) public virtual override {
1114         safeTransferFrom(from, to, tokenId, "");
1115     }
1116 
1117     /**
1118      * @dev See {IERC721-safeTransferFrom}.
1119      */
1120     function safeTransferFrom(
1121         address from,
1122         address to,
1123         uint256 tokenId,
1124         bytes memory _data
1125     ) public virtual override {
1126         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1127         _safeTransfer(from, to, tokenId, _data);
1128     }
1129 
1130     /**
1131      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1132      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1133      *
1134      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1135      *
1136      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1137      * implement alternative mechanisms to perform token transfer, such as signature-based.
1138      *
1139      * Requirements:
1140      *
1141      * - `from` cannot be the zero address.
1142      * - `to` cannot be the zero address.
1143      * - `tokenId` token must exist and be owned by `from`.
1144      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1145      *
1146      * Emits a {Transfer} event.
1147      */
1148     function _safeTransfer(
1149         address from,
1150         address to,
1151         uint256 tokenId,
1152         bytes memory _data
1153     ) internal virtual {
1154         _transfer(from, to, tokenId);
1155         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1156     }
1157 
1158     /**
1159      * @dev Returns whether `tokenId` exists.
1160      *
1161      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1162      *
1163      * Tokens start existing when they are minted (`_mint`),
1164      * and stop existing when they are burned (`_burn`).
1165      */
1166     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1167         return _owners[tokenId] != address(0);
1168     }
1169 
1170     /**
1171      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1172      *
1173      * Requirements:
1174      *
1175      * - `tokenId` must exist.
1176      */
1177     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1178         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1179         address owner = ERC721.ownerOf(tokenId);
1180         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1181     }
1182 
1183     /**
1184      * @dev Safely mints `tokenId` and transfers it to `to`.
1185      *
1186      * Requirements:
1187      *
1188      * - `tokenId` must not exist.
1189      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1190      *
1191      * Emits a {Transfer} event.
1192      */
1193     function _safeMint(address to, uint256 tokenId) internal virtual {
1194         _safeMint(to, tokenId, "");
1195     }
1196 
1197     /**
1198      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1199      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1200      */
1201     function _safeMint(
1202         address to,
1203         uint256 tokenId,
1204         bytes memory _data
1205     ) internal virtual {
1206         _mint(to, tokenId);
1207         require(
1208             _checkOnERC721Received(address(0), to, tokenId, _data),
1209             "ERC721: transfer to non ERC721Receiver implementer"
1210         );
1211     }
1212 
1213     /**
1214      * @dev Mints `tokenId` and transfers it to `to`.
1215      *
1216      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1217      *
1218      * Requirements:
1219      *
1220      * - `tokenId` must not exist.
1221      * - `to` cannot be the zero address.
1222      *
1223      * Emits a {Transfer} event.
1224      */
1225     function _mint(address to, uint256 tokenId) internal virtual {
1226         require(to != address(0), "ERC721: mint to the zero address");
1227         require(!_exists(tokenId), "ERC721: token already minted");
1228 
1229         _beforeTokenTransfer(address(0), to, tokenId);
1230 
1231         _balances[to] += 1;
1232         _owners[tokenId] = to;
1233 
1234         emit Transfer(address(0), to, tokenId);
1235     }
1236 
1237     /**
1238      * @dev Destroys `tokenId`.
1239      * The approval is cleared when the token is burned.
1240      *
1241      * Requirements:
1242      *
1243      * - `tokenId` must exist.
1244      *
1245      * Emits a {Transfer} event.
1246      */
1247     function _burn(uint256 tokenId) internal virtual {
1248         address owner = ERC721.ownerOf(tokenId);
1249 
1250         _beforeTokenTransfer(owner, address(0), tokenId);
1251 
1252         // Clear approvals
1253         _approve(address(0), tokenId);
1254 
1255         _balances[owner] -= 1;
1256         delete _owners[tokenId];
1257 
1258         emit Transfer(owner, address(0), tokenId);
1259     }
1260 
1261     /**
1262      * @dev Transfers `tokenId` from `from` to `to`.
1263      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1264      *
1265      * Requirements:
1266      *
1267      * - `to` cannot be the zero address.
1268      * - `tokenId` token must be owned by `from`.
1269      *
1270      * Emits a {Transfer} event.
1271      */
1272     function _transfer(
1273         address from,
1274         address to,
1275         uint256 tokenId
1276     ) internal virtual {
1277         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1278         require(to != address(0), "ERC721: transfer to the zero address");
1279 
1280         _beforeTokenTransfer(from, to, tokenId);
1281 
1282         // Clear approvals from the previous owner
1283         _approve(address(0), tokenId);
1284 
1285         _balances[from] -= 1;
1286         _balances[to] += 1;
1287         _owners[tokenId] = to;
1288 
1289         emit Transfer(from, to, tokenId);
1290     }
1291 
1292     /**
1293      * @dev Approve `to` to operate on `tokenId`
1294      *
1295      * Emits a {Approval} event.
1296      */
1297     function _approve(address to, uint256 tokenId) internal virtual {
1298         _tokenApprovals[tokenId] = to;
1299         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1300     }
1301 
1302     /**
1303      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1304      * The call is not executed if the target address is not a contract.
1305      *
1306      * @param from address representing the previous owner of the given token ID
1307      * @param to target address that will receive the tokens
1308      * @param tokenId uint256 ID of the token to be transferred
1309      * @param _data bytes optional data to send along with the call
1310      * @return bool whether the call correctly returned the expected magic value
1311      */
1312     function _checkOnERC721Received(
1313         address from,
1314         address to,
1315         uint256 tokenId,
1316         bytes memory _data
1317     ) private returns (bool) {
1318         if (to.isContract()) {
1319             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1320                 return retval == IERC721Receiver.onERC721Received.selector;
1321             } catch (bytes memory reason) {
1322                 if (reason.length == 0) {
1323                     revert("ERC721: transfer to non ERC721Receiver implementer");
1324                 } else {
1325                     assembly {
1326                         revert(add(32, reason), mload(reason))
1327                     }
1328                 }
1329             }
1330         } else {
1331             return true;
1332         }
1333     }
1334 
1335     /**
1336      * @dev Hook that is called before any token transfer. This includes minting
1337      * and burning.
1338      *
1339      * Calling conditions:
1340      *
1341      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1342      * transferred to `to`.
1343      * - When `from` is zero, `tokenId` will be minted for `to`.
1344      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1345      * - `from` and `to` are never both zero.
1346      *
1347      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1348      */
1349     function _beforeTokenTransfer(
1350         address from,
1351         address to,
1352         uint256 tokenId
1353     ) internal virtual {}
1354 }
1355 
1356 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1357 
1358 
1359 
1360 pragma solidity ^0.8.0;
1361 
1362 
1363 
1364 /**
1365  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1366  * enumerability of all the token ids in the contract as well as all token ids owned by each
1367  * account.
1368  */
1369 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1370     // Mapping from owner to list of owned token IDs
1371     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1372 
1373     // Mapping from token ID to index of the owner tokens list
1374     mapping(uint256 => uint256) private _ownedTokensIndex;
1375 
1376     // Array with all token ids, used for enumeration
1377     uint256[] private _allTokens;
1378 
1379     // Mapping from token id to position in the allTokens array
1380     mapping(uint256 => uint256) private _allTokensIndex;
1381 
1382     /**
1383      * @dev See {IERC165-supportsInterface}.
1384      */
1385     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1386         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1387     }
1388 
1389     /**
1390      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1391      */
1392     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1393         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1394         return _ownedTokens[owner][index];
1395     }
1396 
1397     /**
1398      * @dev See {IERC721Enumerable-totalSupply}.
1399      */
1400     function totalSupply() public view virtual override returns (uint256) {
1401         return _allTokens.length;
1402     }
1403 
1404     /**
1405      * @dev See {IERC721Enumerable-tokenByIndex}.
1406      */
1407     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1408         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1409         return _allTokens[index];
1410     }
1411 
1412     /**
1413      * @dev Hook that is called before any token transfer. This includes minting
1414      * and burning.
1415      *
1416      * Calling conditions:
1417      *
1418      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1419      * transferred to `to`.
1420      * - When `from` is zero, `tokenId` will be minted for `to`.
1421      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1422      * - `from` cannot be the zero address.
1423      * - `to` cannot be the zero address.
1424      *
1425      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1426      */
1427     function _beforeTokenTransfer(
1428         address from,
1429         address to,
1430         uint256 tokenId
1431     ) internal virtual override {
1432         super._beforeTokenTransfer(from, to, tokenId);
1433 
1434         if (from == address(0)) {
1435             _addTokenToAllTokensEnumeration(tokenId);
1436         } else if (from != to) {
1437             _removeTokenFromOwnerEnumeration(from, tokenId);
1438         }
1439         if (to == address(0)) {
1440             _removeTokenFromAllTokensEnumeration(tokenId);
1441         } else if (to != from) {
1442             _addTokenToOwnerEnumeration(to, tokenId);
1443         }
1444     }
1445 
1446     /**
1447      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1448      * @param to address representing the new owner of the given token ID
1449      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1450      */
1451     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1452         uint256 length = ERC721.balanceOf(to);
1453         _ownedTokens[to][length] = tokenId;
1454         _ownedTokensIndex[tokenId] = length;
1455     }
1456 
1457     /**
1458      * @dev Private function to add a token to this extension's token tracking data structures.
1459      * @param tokenId uint256 ID of the token to be added to the tokens list
1460      */
1461     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1462         _allTokensIndex[tokenId] = _allTokens.length;
1463         _allTokens.push(tokenId);
1464     }
1465 
1466     /**
1467      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1468      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1469      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1470      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1471      * @param from address representing the previous owner of the given token ID
1472      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1473      */
1474     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1475         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1476         // then delete the last slot (swap and pop).
1477 
1478         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1479         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1480 
1481         // When the token to delete is the last token, the swap operation is unnecessary
1482         if (tokenIndex != lastTokenIndex) {
1483             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1484 
1485             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1486             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1487         }
1488 
1489         // This also deletes the contents at the last position of the array
1490         delete _ownedTokensIndex[tokenId];
1491         delete _ownedTokens[from][lastTokenIndex];
1492     }
1493 
1494     /**
1495      * @dev Private function to remove a token from this extension's token tracking data structures.
1496      * This has O(1) time complexity, but alters the order of the _allTokens array.
1497      * @param tokenId uint256 ID of the token to be removed from the tokens list
1498      */
1499     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1500         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1501         // then delete the last slot (swap and pop).
1502 
1503         uint256 lastTokenIndex = _allTokens.length - 1;
1504         uint256 tokenIndex = _allTokensIndex[tokenId];
1505 
1506         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1507         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1508         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1509         uint256 lastTokenId = _allTokens[lastTokenIndex];
1510 
1511         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1512         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1513 
1514         // This also deletes the contents at the last position of the array
1515         delete _allTokensIndex[tokenId];
1516         _allTokens.pop();
1517     }
1518 }
1519 
1520 // File: contracts/GorillaClub/GorillaClub.sol
1521 
1522 //SPDX-License-Identifier: MIT
1523 pragma solidity ^0.8.0;
1524 
1525 
1526 
1527 
1528 
1529  
1530 /********************************************************************
1531  ________  ________  ________  ___  ___       ___       ________          ________  ___       ___  ___  ________     
1532 |\   ____\|\   __  \|\   __  \|\  \|\  \     |\  \     |\   __  \        |\   ____\|\  \     |\  \|\  \|\   __  \    
1533 \ \  \___|\ \  \|\  \ \  \|\  \ \  \ \  \    \ \  \    \ \  \|\  \       \ \  \___|\ \  \    \ \  \\\  \ \  \|\ /_   
1534  \ \  \  __\ \  \\\  \ \   _  _\ \  \ \  \    \ \  \    \ \   __  \       \ \  \    \ \  \    \ \  \\\  \ \   __  \  
1535   \ \  \|\  \ \  \\\  \ \  \\  \\ \  \ \  \____\ \  \____\ \  \ \  \       \ \  \____\ \  \____\ \  \\\  \ \  \|\  \ 
1536    \ \_______\ \_______\ \__\\ _\\ \__\ \_______\ \_______\ \__\ \__\       \ \_______\ \_______\ \_______\ \_______\
1537     \|_______|\|_______|\|__|\|__|\|__|\|_______|\|_______|\|__|\|__|        \|_______|\|_______|\|_______|\|_______|
1538  
1539 ********************************************************************/
1540  
1541 contract GorillaClub is ERC721, ERC721Enumerable, Ownable {
1542     using Counters for Counters.Counter;
1543  
1544     uint256 public constant MAX_SUPPLY = 10000;
1545     uint256 public constant PRESALE_PRICE = 0.05 ether;
1546     uint256 public constant SALE_PRICE = 0.05 ether;
1547  
1548     address private _verifier = 0x3BBE729e8010b8Df57D20742A2Ac5c7e45ac5250;
1549     address proxyRegistryAddress;
1550  
1551     bool public IS_PRESALE_ACTIVE = false;
1552     bool public IS_SALE_ACTIVE = false;
1553  
1554     Counters.Counter private _tokenIdCounter;
1555  
1556     string private baseTokenURI = 'https://us-central1-nft-project-2.cloudfunctions.net/token/';
1557  
1558     constructor(address _proxyRegistryAddress) ERC721('GorillaClub', 'GC') {
1559         proxyRegistryAddress = _proxyRegistryAddress;
1560     }
1561  
1562     /**
1563      * This is used instead of msg.sender as transactions won't be sent by the original token owner, but by OpenSea.
1564      */
1565     function _msgSender() internal view override returns (address sender) {
1566         if (msg.sender == address(this)) {
1567             bytes memory array = msg.data;
1568             uint256 index = msg.data.length;
1569             assembly {
1570                 // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
1571                 sender := and(
1572                     mload(add(array, index)),
1573                     0xffffffffffffffffffffffffffffffffffffffff
1574                 )
1575             }
1576         } else {
1577             sender = msg.sender;
1578         }
1579         return sender;
1580     }
1581  
1582     function _recoverWallet(
1583         address wallet,
1584         bytes memory signature
1585     ) internal pure returns (address) {
1586         return
1587             ECDSA.recover(
1588                 ECDSA.toEthSignedMessageHash(
1589                     keccak256(abi.encodePacked(wallet))
1590                 ),
1591                 signature
1592             );
1593     }
1594  
1595     function _mintOneToken(address to) internal {
1596         _tokenIdCounter.increment();
1597         _safeMint(to, _tokenIdCounter.current());
1598     }
1599  
1600     function _mintTokens(
1601         uint256 tokensLimit,
1602         uint256 tokensAmount,
1603         uint256 tokenPrice
1604     ) internal {
1605         require(tokensAmount <= tokensLimit, 'Incorrect tokens amount');
1606         require(
1607             (_tokenIdCounter.current() + tokensAmount) <= MAX_SUPPLY,
1608             'Minting would exceed total supply'
1609         );
1610         require(msg.value >= (tokenPrice * tokensAmount), 'Incorrect price');
1611  
1612         address sender = _msgSender();
1613  
1614         require(
1615             (balanceOf(sender) + tokensAmount) <= tokensLimit,
1616             'Limit per wallet'
1617         );
1618  
1619         for (uint256 i = 0; i < tokensAmount; i++) {
1620             _mintOneToken(sender);
1621         }
1622     }
1623  
1624     function mintSale(uint256 tokensAmount) public payable {
1625         require(IS_SALE_ACTIVE, 'Sale is closed');
1626  
1627         _mintTokens(10, tokensAmount, SALE_PRICE);
1628     }
1629  
1630     function mintPresale(uint256 tokensAmount, bytes calldata signature) public payable {
1631         require(IS_PRESALE_ACTIVE, 'PreSale is closed');
1632  
1633         address signer = _recoverWallet(_msgSender(), signature);
1634  
1635         require(signer == _verifier, 'Unverified transaction');
1636  
1637         _mintTokens(5, tokensAmount, PRESALE_PRICE);
1638     }
1639  
1640     /**
1641      * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-less listings.
1642      */
1643     function isApprovedForAll(address _owner, address _operator)
1644         public
1645         view
1646         override
1647         returns (bool)
1648     {
1649         // Whitelist OpenSea proxy contract for easy trading.
1650         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1651         if (address(proxyRegistry.proxies(_owner)) == _operator) {
1652             return true;
1653         }
1654  
1655         return super.isApprovedForAll(_owner, _operator);
1656     }
1657  
1658     function _beforeTokenTransfer(
1659         address from,
1660         address to,
1661         uint256 tokenId
1662     ) internal override(ERC721Enumerable, ERC721) {
1663         super._beforeTokenTransfer(from, to, tokenId);
1664     }
1665  
1666     function supportsInterface(bytes4 interfaceId)
1667         public
1668         view
1669         override(ERC721Enumerable, ERC721)
1670         returns (bool)
1671     {
1672         return super.supportsInterface(interfaceId);
1673     }
1674  
1675     function mintReserved(uint256 tokensAmount) public onlyOwner {
1676         require(
1677             _tokenIdCounter.current() + tokensAmount <= MAX_SUPPLY,
1678             'Minting would exceed total supply'
1679         );
1680  
1681         for (uint256 i = 0; i < tokensAmount; i++) {
1682             _mintOneToken(msg.sender);
1683         }
1684     }
1685  
1686     function _baseURI() internal view virtual override returns (string memory) {
1687         return baseTokenURI;
1688     }
1689  
1690     function setBaseURI(string memory baseURI) public onlyOwner {
1691         baseTokenURI = baseURI;
1692     }
1693  
1694     function setVerifier(address _newVerifier) public onlyOwner {
1695         _verifier = _newVerifier;
1696     }
1697  
1698     function setSaleState(bool _isPresaleActive, bool _isSaleActive)
1699         public
1700         onlyOwner
1701     {
1702         IS_PRESALE_ACTIVE = _isPresaleActive;
1703         IS_SALE_ACTIVE = _isSaleActive;
1704     }
1705  
1706     function withdrawAll() public onlyOwner {
1707         (bool success, ) = _msgSender().call{value: address(this).balance}('');
1708         require(success, 'Withdraw failed');
1709     }
1710 }
1711  
1712 contract OwnableDelegateProxy {}
1713  
1714 contract ProxyRegistry {
1715     mapping(address => OwnableDelegateProxy) public proxies;
1716 }