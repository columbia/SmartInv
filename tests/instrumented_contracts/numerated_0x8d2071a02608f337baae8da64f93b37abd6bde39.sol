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
885 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
886 
887 
888 
889 pragma solidity ^0.8.0;
890 
891 
892 /**
893  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
894  * @dev See https://eips.ethereum.org/EIPS/eip-721
895  */
896 interface IERC721Metadata is IERC721 {
897     /**
898      * @dev Returns the token collection name.
899      */
900     function name() external view returns (string memory);
901 
902     /**
903      * @dev Returns the token collection symbol.
904      */
905     function symbol() external view returns (string memory);
906 
907     /**
908      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
909      */
910     function tokenURI(uint256 tokenId) external view returns (string memory);
911 }
912 
913 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
914 
915 
916 
917 pragma solidity ^0.8.0;
918 
919 
920 
921 
922 
923 
924 
925 
926 /**
927  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
928  * the Metadata extension, but not including the Enumerable extension, which is available separately as
929  * {ERC721Enumerable}.
930  */
931 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
932     using Address for address;
933     using Strings for uint256;
934 
935     // Token name
936     string private _name;
937 
938     // Token symbol
939     string private _symbol;
940 
941     // Mapping from token ID to owner address
942     mapping(uint256 => address) private _owners;
943 
944     // Mapping owner address to token count
945     mapping(address => uint256) private _balances;
946 
947     // Mapping from token ID to approved address
948     mapping(uint256 => address) private _tokenApprovals;
949 
950     // Mapping from owner to operator approvals
951     mapping(address => mapping(address => bool)) private _operatorApprovals;
952 
953     /**
954      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
955      */
956     constructor(string memory name_, string memory symbol_) {
957         _name = name_;
958         _symbol = symbol_;
959     }
960 
961     /**
962      * @dev See {IERC165-supportsInterface}.
963      */
964     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
965         return
966             interfaceId == type(IERC721).interfaceId ||
967             interfaceId == type(IERC721Metadata).interfaceId ||
968             super.supportsInterface(interfaceId);
969     }
970 
971     /**
972      * @dev See {IERC721-balanceOf}.
973      */
974     function balanceOf(address owner) public view virtual override returns (uint256) {
975         require(owner != address(0), "ERC721: balance query for the zero address");
976         return _balances[owner];
977     }
978 
979     /**
980      * @dev See {IERC721-ownerOf}.
981      */
982     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
983         address owner = _owners[tokenId];
984         require(owner != address(0), "ERC721: owner query for nonexistent token");
985         return owner;
986     }
987 
988     /**
989      * @dev See {IERC721Metadata-name}.
990      */
991     function name() public view virtual override returns (string memory) {
992         return _name;
993     }
994 
995     /**
996      * @dev See {IERC721Metadata-symbol}.
997      */
998     function symbol() public view virtual override returns (string memory) {
999         return _symbol;
1000     }
1001 
1002     /**
1003      * @dev See {IERC721Metadata-tokenURI}.
1004      */
1005     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1006         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1007 
1008         string memory baseURI = _baseURI();
1009         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1010     }
1011 
1012     /**
1013      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1014      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1015      * by default, can be overriden in child contracts.
1016      */
1017     function _baseURI() internal view virtual returns (string memory) {
1018         return "";
1019     }
1020 
1021     /**
1022      * @dev See {IERC721-approve}.
1023      */
1024     function approve(address to, uint256 tokenId) public virtual override {
1025         address owner = ERC721.ownerOf(tokenId);
1026         require(to != owner, "ERC721: approval to current owner");
1027 
1028         require(
1029             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1030             "ERC721: approve caller is not owner nor approved for all"
1031         );
1032 
1033         _approve(to, tokenId);
1034     }
1035 
1036     /**
1037      * @dev See {IERC721-getApproved}.
1038      */
1039     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1040         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1041 
1042         return _tokenApprovals[tokenId];
1043     }
1044 
1045     /**
1046      * @dev See {IERC721-setApprovalForAll}.
1047      */
1048     function setApprovalForAll(address operator, bool approved) public virtual override {
1049         require(operator != _msgSender(), "ERC721: approve to caller");
1050 
1051         _operatorApprovals[_msgSender()][operator] = approved;
1052         emit ApprovalForAll(_msgSender(), operator, approved);
1053     }
1054 
1055     /**
1056      * @dev See {IERC721-isApprovedForAll}.
1057      */
1058     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1059         return _operatorApprovals[owner][operator];
1060     }
1061 
1062     /**
1063      * @dev See {IERC721-transferFrom}.
1064      */
1065     function transferFrom(
1066         address from,
1067         address to,
1068         uint256 tokenId
1069     ) public virtual override {
1070         //solhint-disable-next-line max-line-length
1071         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1072 
1073         _transfer(from, to, tokenId);
1074     }
1075 
1076     /**
1077      * @dev See {IERC721-safeTransferFrom}.
1078      */
1079     function safeTransferFrom(
1080         address from,
1081         address to,
1082         uint256 tokenId
1083     ) public virtual override {
1084         safeTransferFrom(from, to, tokenId, "");
1085     }
1086 
1087     /**
1088      * @dev See {IERC721-safeTransferFrom}.
1089      */
1090     function safeTransferFrom(
1091         address from,
1092         address to,
1093         uint256 tokenId,
1094         bytes memory _data
1095     ) public virtual override {
1096         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1097         _safeTransfer(from, to, tokenId, _data);
1098     }
1099 
1100     /**
1101      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1102      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1103      *
1104      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1105      *
1106      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1107      * implement alternative mechanisms to perform token transfer, such as signature-based.
1108      *
1109      * Requirements:
1110      *
1111      * - `from` cannot be the zero address.
1112      * - `to` cannot be the zero address.
1113      * - `tokenId` token must exist and be owned by `from`.
1114      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1115      *
1116      * Emits a {Transfer} event.
1117      */
1118     function _safeTransfer(
1119         address from,
1120         address to,
1121         uint256 tokenId,
1122         bytes memory _data
1123     ) internal virtual {
1124         _transfer(from, to, tokenId);
1125         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1126     }
1127 
1128     /**
1129      * @dev Returns whether `tokenId` exists.
1130      *
1131      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1132      *
1133      * Tokens start existing when they are minted (`_mint`),
1134      * and stop existing when they are burned (`_burn`).
1135      */
1136     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1137         return _owners[tokenId] != address(0);
1138     }
1139 
1140     /**
1141      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1142      *
1143      * Requirements:
1144      *
1145      * - `tokenId` must exist.
1146      */
1147     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1148         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1149         address owner = ERC721.ownerOf(tokenId);
1150         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1151     }
1152 
1153     /**
1154      * @dev Safely mints `tokenId` and transfers it to `to`.
1155      *
1156      * Requirements:
1157      *
1158      * - `tokenId` must not exist.
1159      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1160      *
1161      * Emits a {Transfer} event.
1162      */
1163     function _safeMint(address to, uint256 tokenId) internal virtual {
1164         _safeMint(to, tokenId, "");
1165     }
1166 
1167     /**
1168      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1169      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1170      */
1171     function _safeMint(
1172         address to,
1173         uint256 tokenId,
1174         bytes memory _data
1175     ) internal virtual {
1176         _mint(to, tokenId);
1177         require(
1178             _checkOnERC721Received(address(0), to, tokenId, _data),
1179             "ERC721: transfer to non ERC721Receiver implementer"
1180         );
1181     }
1182 
1183     /**
1184      * @dev Mints `tokenId` and transfers it to `to`.
1185      *
1186      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1187      *
1188      * Requirements:
1189      *
1190      * - `tokenId` must not exist.
1191      * - `to` cannot be the zero address.
1192      *
1193      * Emits a {Transfer} event.
1194      */
1195     function _mint(address to, uint256 tokenId) internal virtual {
1196         require(to != address(0), "ERC721: mint to the zero address");
1197         require(!_exists(tokenId), "ERC721: token already minted");
1198 
1199         _beforeTokenTransfer(address(0), to, tokenId);
1200 
1201         _balances[to] += 1;
1202         _owners[tokenId] = to;
1203 
1204         emit Transfer(address(0), to, tokenId);
1205     }
1206 
1207     /**
1208      * @dev Destroys `tokenId`.
1209      * The approval is cleared when the token is burned.
1210      *
1211      * Requirements:
1212      *
1213      * - `tokenId` must exist.
1214      *
1215      * Emits a {Transfer} event.
1216      */
1217     function _burn(uint256 tokenId) internal virtual {
1218         address owner = ERC721.ownerOf(tokenId);
1219 
1220         _beforeTokenTransfer(owner, address(0), tokenId);
1221 
1222         // Clear approvals
1223         _approve(address(0), tokenId);
1224 
1225         _balances[owner] -= 1;
1226         delete _owners[tokenId];
1227 
1228         emit Transfer(owner, address(0), tokenId);
1229     }
1230 
1231     /**
1232      * @dev Transfers `tokenId` from `from` to `to`.
1233      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1234      *
1235      * Requirements:
1236      *
1237      * - `to` cannot be the zero address.
1238      * - `tokenId` token must be owned by `from`.
1239      *
1240      * Emits a {Transfer} event.
1241      */
1242     function _transfer(
1243         address from,
1244         address to,
1245         uint256 tokenId
1246     ) internal virtual {
1247         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1248         require(to != address(0), "ERC721: transfer to the zero address");
1249 
1250         _beforeTokenTransfer(from, to, tokenId);
1251 
1252         // Clear approvals from the previous owner
1253         _approve(address(0), tokenId);
1254 
1255         _balances[from] -= 1;
1256         _balances[to] += 1;
1257         _owners[tokenId] = to;
1258 
1259         emit Transfer(from, to, tokenId);
1260     }
1261 
1262     /**
1263      * @dev Approve `to` to operate on `tokenId`
1264      *
1265      * Emits a {Approval} event.
1266      */
1267     function _approve(address to, uint256 tokenId) internal virtual {
1268         _tokenApprovals[tokenId] = to;
1269         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1270     }
1271 
1272     /**
1273      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1274      * The call is not executed if the target address is not a contract.
1275      *
1276      * @param from address representing the previous owner of the given token ID
1277      * @param to target address that will receive the tokens
1278      * @param tokenId uint256 ID of the token to be transferred
1279      * @param _data bytes optional data to send along with the call
1280      * @return bool whether the call correctly returned the expected magic value
1281      */
1282     function _checkOnERC721Received(
1283         address from,
1284         address to,
1285         uint256 tokenId,
1286         bytes memory _data
1287     ) private returns (bool) {
1288         if (to.isContract()) {
1289             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1290                 return retval == IERC721Receiver.onERC721Received.selector;
1291             } catch (bytes memory reason) {
1292                 if (reason.length == 0) {
1293                     revert("ERC721: transfer to non ERC721Receiver implementer");
1294                 } else {
1295                     assembly {
1296                         revert(add(32, reason), mload(reason))
1297                     }
1298                 }
1299             }
1300         } else {
1301             return true;
1302         }
1303     }
1304 
1305     /**
1306      * @dev Hook that is called before any token transfer. This includes minting
1307      * and burning.
1308      *
1309      * Calling conditions:
1310      *
1311      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1312      * transferred to `to`.
1313      * - When `from` is zero, `tokenId` will be minted for `to`.
1314      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1315      * - `from` and `to` are never both zero.
1316      *
1317      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1318      */
1319     function _beforeTokenTransfer(
1320         address from,
1321         address to,
1322         uint256 tokenId
1323     ) internal virtual {}
1324 }
1325 
1326 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol
1327 
1328 
1329 
1330 pragma solidity ^0.8.0;
1331 
1332 
1333 
1334 /**
1335  * @title ERC721 Burnable Token
1336  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1337  */
1338 abstract contract ERC721Burnable is Context, ERC721 {
1339     /**
1340      * @dev Burns `tokenId`. See {ERC721-_burn}.
1341      *
1342      * Requirements:
1343      *
1344      * - The caller must own `tokenId` or be an approved operator.
1345      */
1346     function burn(uint256 tokenId) public virtual {
1347         //solhint-disable-next-line max-line-length
1348         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1349         _burn(tokenId);
1350     }
1351 }
1352 
1353 // File: contracts/Howl.sol
1354 
1355 
1356 pragma solidity ^0.8.2;
1357 
1358 
1359 
1360 
1361 
1362 interface ISoul {
1363     function mint(address _address, uint256 _amount) external;
1364 
1365     function collectAndBurn(address _address, uint256 _amount) external;
1366 }
1367 
1368 contract Howl is ERC721Burnable, Ownable {
1369     using ECDSA for bytes32;
1370     using Counters for Counters.Counter;
1371 
1372     constructor() ERC721("House of Warlords", "HOWL") Ownable() {
1373         genesisTokenIdCounter._value = 888; // accounting for giveaways and reserve
1374         genesisReserveTokenIdCounter._value = 8; // accounting for legendaries
1375     }
1376 
1377     struct Warlord {
1378         uint16 face; // 0
1379         uint16 headGear; // 1
1380         uint16 clothes; // 2
1381         uint16 shoulderGuard; // 3
1382         uint16 armGuards; // 4
1383         uint16 sideWeapon; // 5
1384         uint16 backWeapon; // 6
1385         uint16 background; // 7
1386         uint16 killCount; // 8
1387     }
1388 
1389     event Seppuku(
1390         address indexed _address,
1391         uint256 indexed _generation,
1392         uint256 _tokenId1,
1393         uint256 _tokenId2
1394     );
1395 
1396     event Resurrection(
1397         uint256 indexed _tokenId,
1398         address indexed _address,
1399         uint256 indexed _generation
1400     );
1401 
1402     event VoucherUsed(
1403         address indexed _address,
1404         uint256 indexed _nonce,
1405         uint256 _claimQty
1406     );
1407 
1408     event StartConquest(uint256 indexed _tokenId, uint256 _startDate);
1409     event EndConquest(uint256 indexed _tokenId, uint256 _reward);
1410     event NameChange(uint256 indexed _tokenId, string _name);
1411 
1412     Counters.Counter public generationCounter;
1413     Counters.Counter public genesisTokenIdCounter;
1414     Counters.Counter public genesisReserveTokenIdCounter;
1415 
1416     uint256 public constant GENESIS_MAX_SUPPLY = 8888;
1417     uint256 public constant RESERVE_QTY = 888;
1418     uint256 public SALE_MINT_PRICE = 0.069 ether;
1419     bool public IS_SALE_ON;
1420     bool public IS_SEPPUKU_ON;
1421     bool public IS_STAKING_ON;
1422 
1423     uint256[3] private _stakingRewards = [250, 600, 1000];
1424     uint256[3] private _stakingPeriods = [30, 60, 90];
1425 
1426     uint256 public seppukuBaseFee = 1000;
1427     uint256 public seppukuMultiplierFee = 500;
1428 
1429     bool public canSummonLegendaries = true;
1430 
1431     string public preRevealUrl;
1432     string public apiUrl;
1433     address public signer;
1434     address public soulContractAddress;
1435 
1436     // When warlords are minted for the first time this contract generates a random looking DNA mapped to a tokenID.
1437     // The actual uint16 properties of the warlord are later derived by decoding it with the
1438     // information that's inside of the generationRanges and generationRarities mappings.
1439     // Each generation of warlords will have its own set of rarities and property ranges
1440     // with a provenance hash uploaded ahead of time.
1441     // It gurantees that the actual property distribution is hidden during the pre-reveal phase since decoding depends on
1442     // the unknown information.
1443     // Property ranges are stored inside of a uint16[4] array per each property.
1444     // These 4 numbers are interpreted as buckets of traits. Traits are just sequential numbers.
1445     // For example [1, 100, 200, 300] value inside of generationRanges for the face property will be interpreted as:
1446     // - Common: 1-99
1447     // - Uncommon: 100-199
1448     // - Rare: 200 - 299
1449     //
1450     // The last two pieces of data are located inside of generationRarities mapping which holds uint16[2] arrays of rarities.
1451     // For example, if our rarities were defined as [80, 15], combined with buckets from above they will result in:
1452     // - Common: 1-99 [80% chance]
1453     // - Uncommon: 100-199 [15% chance]
1454     // - Rare: 200 - 299 [5% chance]
1455     //
1456     // This framework helps us to keep our trait generation random and hidden while still allowing for
1457     // clearly defined rarity categories.
1458     mapping(uint256 => mapping(uint256 => uint16[4])) public generationRanges;
1459     mapping(uint256 => uint16[2]) public generationRarities;
1460     mapping(uint256 => uint256) public generationProvenance;
1461     mapping(uint256 => bool) public isGenerationRevealed;
1462     mapping(uint256 => uint256) public generationSeed;
1463     mapping(uint256 => uint256) public generationResurrectionChance;
1464     mapping(address => mapping(uint256 => uint256)) public resurrectionTickets;
1465     mapping(uint256 => uint256) private _tokenIdToWarlord;
1466     mapping(uint256 => uint256) public conquests;
1467     mapping(uint256 => uint256) private _voucherToMinted;
1468     mapping(uint256 => string) public tokenIdToWarlordName;
1469     mapping(string => bool) public namesTaken;
1470 
1471     // This mapping is going to be used to connect our howl store implementation and potential future
1472     // mechanics that will enhance this collection.
1473     mapping(address => bool) public authorizedToEquip;
1474     // Kill switch for the mapping above, if community decides that it's too dangerous to have this
1475     // list extendable we can prevent it from being modified.
1476     bool public isAuthorizedToEquipLocked;
1477 
1478     mapping(address => bool) public admins;
1479 
1480     function _isTokenOwner(uint256 _tokenId) private view {
1481         require(
1482             ownerOf(_tokenId) == msg.sender,
1483             "HOWL: you don't own this token"
1484         );
1485     }
1486 
1487     function _isOwnerOrAdmin() private view {
1488         require(
1489             owner() == msg.sender || admins[msg.sender],
1490             "HOWL: unauthorized"
1491         );
1492     }
1493 
1494     modifier onlyOwnerOrAdmin() {
1495         _isOwnerOrAdmin();
1496         _;
1497     }
1498 
1499     modifier onlyTokenOwner(uint256 _tokenId) {
1500         _isTokenOwner(_tokenId);
1501         _;
1502     }
1503 
1504     modifier onlyAuthorizedToEquip() {
1505         require(authorizedToEquip[msg.sender], "HOWL: unauthorized");
1506         _;
1507     }
1508 
1509     function withdraw() external onlyOwner {
1510         payable(owner()).transfer(address(this).balance);
1511     }
1512 
1513     function setAuthorizedToEquip(address _address, bool _isAuthorized)
1514         external
1515         onlyOwner
1516     {
1517         require(!isAuthorizedToEquipLocked);
1518         authorizedToEquip[_address] = _isAuthorized;
1519     }
1520 
1521     function lockAuthorizedToEquip() external onlyOwner {
1522         isAuthorizedToEquipLocked = true;
1523     }
1524 
1525     function setAdmin(address _address, bool _hasAccess) external onlyOwner {
1526         admins[_address] = _hasAccess;
1527     }
1528 
1529     function setSaleMintPrice(uint256 _mintPrice) external onlyOwner {
1530         SALE_MINT_PRICE = _mintPrice;
1531     }
1532 
1533     function setSigner(address _signer) external onlyOwner {
1534         signer = _signer;
1535     }
1536 
1537     function setApiUrl(string calldata _apiUrl) external onlyOwner {
1538         apiUrl = _apiUrl;
1539     }
1540 
1541     function setPreRevealUrl(string calldata _preRevealUrl) external onlyOwner {
1542         preRevealUrl = _preRevealUrl;
1543     }
1544 
1545     function setSoulContractAddress(address _address) external onlyOwner {
1546         soulContractAddress = _address;
1547     }
1548 
1549     function setIsSaleOn(bool _isSaleOn) external onlyOwnerOrAdmin {
1550         IS_SALE_ON = _isSaleOn;
1551     }
1552 
1553     function setIsSeppukuOn(bool _isSeppukuOn) external onlyOwnerOrAdmin {
1554         IS_SEPPUKU_ON = _isSeppukuOn;
1555     }
1556 
1557     function setSeppukuBaseAndMultiplierFee(
1558         uint256 _baseFee,
1559         uint256 _multiplierFee
1560     ) external onlyOwnerOrAdmin {
1561         seppukuBaseFee = _baseFee;
1562         seppukuMultiplierFee = _multiplierFee;
1563     }
1564 
1565     function setStakingRewardsAndPeriods(
1566         uint256[3] calldata _rewards,
1567         uint256[3] calldata _periods
1568     ) external onlyOwnerOrAdmin {
1569         _stakingRewards = _rewards;
1570         _stakingPeriods = _periods;
1571     }
1572 
1573     function getStakingRewardsAndPeriods()
1574         external
1575         view
1576         returns (uint256[3][2] memory)
1577     {
1578         return [
1579             [_stakingRewards[0], _stakingRewards[1], _stakingRewards[2]],
1580             [_stakingPeriods[0], _stakingPeriods[1], _stakingPeriods[2]]
1581         ];
1582     }
1583 
1584     function setIsStakingOn(bool _isStakingOn) external onlyOwnerOrAdmin {
1585         IS_STAKING_ON = _isStakingOn;
1586     }
1587 
1588     function setIsGenerationRevealed(uint256 _gen, bool _isGenerationRevealed)
1589         external
1590         onlyOwnerOrAdmin
1591     {
1592         require(!isGenerationRevealed[_gen]);
1593         isGenerationRevealed[_gen] = _isGenerationRevealed;
1594     }
1595 
1596     function setGenerationRanges(
1597         uint256 _gen,
1598         uint16[4] calldata _face,
1599         uint16[4] calldata _headGear,
1600         uint16[4] calldata _clothes,
1601         uint16[4] calldata _shoulderGuard,
1602         uint16[4] calldata _armGuards,
1603         uint16[4] calldata _sideWeapon,
1604         uint16[4] calldata _backWeapon,
1605         uint16[4] calldata _background
1606     ) external onlyOwnerOrAdmin {
1607         require(!isGenerationRevealed[_gen]);
1608 
1609         generationRanges[_gen][0] = _face;
1610         generationRanges[_gen][1] = _headGear;
1611         generationRanges[_gen][2] = _clothes;
1612         generationRanges[_gen][3] = _shoulderGuard;
1613         generationRanges[_gen][4] = _armGuards;
1614         generationRanges[_gen][5] = _sideWeapon;
1615         generationRanges[_gen][6] = _backWeapon;
1616         generationRanges[_gen][7] = _background;
1617     }
1618 
1619     function setGenerationRarities(
1620         uint256 _gen,
1621         uint16 _common,
1622         uint16 _uncommon
1623     ) external onlyOwnerOrAdmin {
1624         require(!isGenerationRevealed[_gen]);
1625         // rare is derived by 100% - common + uncommon
1626         // so in the case of [80,15] - rare will be 5%
1627         require(_common > _uncommon);
1628         generationRarities[_gen] = [_common, _uncommon];
1629     }
1630 
1631     function setGenerationProvenance(uint256 _provenance, uint256 _gen)
1632         external
1633         onlyOwnerOrAdmin
1634     {
1635         require(generationProvenance[_gen] == 0);
1636         generationProvenance[_gen] = _provenance;
1637     }
1638 
1639     function startNextGenerationResurrection(uint256 _resurrectionChance)
1640         external
1641         onlyOwnerOrAdmin
1642     {
1643         require(!IS_SEPPUKU_ON);
1644         generationCounter.increment();
1645         uint256 gen = generationCounter.current();
1646         generationSeed[gen] = _getSeed();
1647         generationResurrectionChance[gen] = _resurrectionChance;
1648     }
1649 
1650     function mintReserve(address _address, uint256 _claimQty)
1651         external
1652         onlyOwner
1653     {
1654         require(
1655             genesisReserveTokenIdCounter.current() + _claimQty <= RESERVE_QTY
1656         );
1657 
1658         for (uint256 i = 0; i < _claimQty; i++) {
1659             genesisReserveTokenIdCounter.increment();
1660             _mintWarlord(_address, genesisReserveTokenIdCounter.current(), 0);
1661         }
1662     }
1663 
1664     function summonLegendaries(address _address) external onlyOwner {
1665         require(canSummonLegendaries);
1666         // make sure that this action cannot be performed again
1667         // in theory all 10 legendaries can be burned
1668         canSummonLegendaries = false;
1669 
1670         uint256 traitBase = 10000;
1671         for (uint256 i = 1; i < 9; i++) {
1672             // first 4 are zen, second 4 are aku
1673             _tokenIdToWarlord[i] = _generateDecodedDna(
1674                 Warlord(
1675                     uint16(traitBase + i), // produces traits that look like 10001 - 10002 - ...etc.
1676                     uint16(traitBase + i),
1677                     uint16(traitBase + i),
1678                     uint16(traitBase + i),
1679                     uint16(traitBase + i),
1680                     uint16(traitBase + i),
1681                     uint16(traitBase + i),
1682                     (i <= 4) ? uint16(traitBase + 1) : uint16(traitBase + 2), // background is 10001 for zen and 10002 for aku
1683                     0 // 0 kills
1684                 )
1685             );
1686 
1687             _safeMint(_address, i);
1688         }
1689     }
1690 
1691     function redeemVoucher(
1692         address _address,
1693         uint256 _approvedQty,
1694         uint256 _price,
1695         uint256 _nonce,
1696         bool _isLastItemFree,
1697         bool _isTeamReserve,
1698         uint256 _claimQty,
1699         bytes calldata _voucher
1700     ) external payable {
1701         bytes32 hash = keccak256(
1702             abi.encodePacked(
1703                 _address,
1704                 _approvedQty,
1705                 _price,
1706                 _nonce,
1707                 _isLastItemFree,
1708                 _isTeamReserve
1709             )
1710         );
1711 
1712         require(
1713             _verifySignature(signer, hash, _voucher),
1714             "HOWL: invalid signature"
1715         );
1716 
1717         uint256 totalWithClaimed = _voucherToMinted[uint256(hash)] + _claimQty;
1718         require(totalWithClaimed <= _approvedQty, "HOWL: exceeds approved qty");
1719 
1720         _voucherToMinted[uint256(hash)] += _claimQty;
1721 
1722         // Make last item free if voucher allows
1723         string memory err = "HOWL: not enough funds sent";
1724         if (totalWithClaimed == _approvedQty && _isLastItemFree) {
1725             require(msg.value >= _price * (_claimQty - 1), err);
1726         } else {
1727             require(msg.value >= _price * _claimQty, err);
1728         }
1729 
1730         if (_isTeamReserve) {
1731             // Minting from 9-888 range if authorized to mint from the reserve
1732             require(
1733                 genesisReserveTokenIdCounter.current() + _claimQty <=
1734                     RESERVE_QTY,
1735                 "HOWL: exceeds reserve supply"
1736             );
1737             for (uint256 i = 0; i < _claimQty; i++) {
1738                 genesisReserveTokenIdCounter.increment();
1739                 _mintWarlord(
1740                     _address,
1741                     genesisReserveTokenIdCounter.current(),
1742                     0
1743                 );
1744             }
1745         } else {
1746             // minting from 889 to 8888
1747             require(
1748                 genesisTokenIdCounter.current() + _claimQty <=
1749                     GENESIS_MAX_SUPPLY,
1750                 "HOWL: exceeds max genesis supply"
1751             );
1752 
1753             for (uint256 i = 0; i < _claimQty; i++) {
1754                 genesisTokenIdCounter.increment();
1755                 _mintWarlord(_address, genesisTokenIdCounter.current(), 0);
1756             }
1757         }
1758 
1759         emit VoucherUsed(_address, _nonce, _claimQty);
1760     }
1761 
1762     function mintSale(uint256 _claimQty) external payable {
1763         require(IS_SALE_ON, "HOWL: sale is not active");
1764         require(
1765             _claimQty <= 10,
1766             "HOWL: can't claim more than 10 in one transaction"
1767         );
1768         require(
1769             msg.value >= SALE_MINT_PRICE * _claimQty,
1770             "HOWL: not enough funds sent"
1771         );
1772         require(
1773             genesisTokenIdCounter.current() + _claimQty <= GENESIS_MAX_SUPPLY,
1774             "HOWL: exceeds max genesis supply"
1775         );
1776 
1777         for (uint256 i = 0; i < _claimQty; i++) {
1778             genesisTokenIdCounter.increment();
1779             _mintWarlord(msg.sender, genesisTokenIdCounter.current(), 0);
1780         }
1781     }
1782 
1783     function _mintWarlord(
1784         address _address,
1785         uint256 _tokenId,
1786         uint256 _gen
1787     ) private {
1788         uint256 dna = uint256(
1789             keccak256(abi.encodePacked(_address, _tokenId, _getSeed()))
1790         );
1791 
1792         // When warlords are generated for the first time
1793         // the last 9 bits of their DNA will be used to store the generation number (8 bit)
1794         // and a flag that indicates whether the dna is in its encoded
1795         // or decoded state (1 bit).
1796 
1797         // Generation number will help to properly decode properties based on
1798         // property ranges that are unknown during minting.
1799 
1800         // ((dna >> 9) << 9) clears the last 9 bits.
1801         // _gen * 2 moves generation information one bit to the left and sets the last bit to 0.
1802         dna = ((dna >> 9) << 9) | (uint8(_gen) * 2);
1803         _tokenIdToWarlord[_tokenId] = dna;
1804         _safeMint(_address, _tokenId);
1805     }
1806 
1807     function canResurrectWarlord(address _address, uint256 _tokenId)
1808         public
1809         view
1810         returns (bool)
1811     {
1812         // Check if resurrection ticket was submitted
1813         uint256 currentGen = generationCounter.current();
1814         uint256 resurrectionGen = resurrectionTickets[_address][_tokenId];
1815         if (resurrectionGen == 0 || resurrectionGen != currentGen) {
1816             return false;
1817         }
1818 
1819         // Check if current generation was seeded
1820         uint256 seed = generationSeed[currentGen];
1821         if (seed == 0) {
1822             return false;
1823         }
1824 
1825         // Check if this token is lucky to be reborn
1826         if (
1827             (uint256(keccak256(abi.encodePacked(_tokenId, seed))) % 100) >
1828             generationResurrectionChance[currentGen]
1829         ) {
1830             return false;
1831         }
1832 
1833         return true;
1834     }
1835 
1836     function resurrectWarlord(uint256 _tokenId) external {
1837         require(
1838             canResurrectWarlord(msg.sender, _tokenId),
1839             "HOWL: warlord cannot be resurrected"
1840         );
1841 
1842         delete resurrectionTickets[msg.sender][_tokenId];
1843 
1844         uint256 gen = generationCounter.current();
1845         _mintWarlord(msg.sender, _tokenId, gen);
1846         emit Resurrection(_tokenId, msg.sender, gen);
1847     }
1848 
1849     function seppuku(
1850         uint256 _tokenId1,
1851         uint256 _tokenId2,
1852         uint16[8] calldata _w
1853     ) external onlyTokenOwner(_tokenId1) onlyTokenOwner(_tokenId2) {
1854         require(
1855             soulContractAddress != address(0) && IS_SEPPUKU_ON,
1856             "HOWL: seppuku is not active"
1857         );
1858 
1859         Warlord memory w1 = getWarlord(_tokenId1);
1860         Warlord memory w2 = getWarlord(_tokenId2);
1861 
1862         require(
1863             (_w[0] == w1.face || _w[0] == w2.face) &&
1864                 (_w[1] == w1.headGear || _w[1] == w2.headGear) &&
1865                 (_w[2] == w1.clothes || _w[2] == w2.clothes) &&
1866                 (_w[3] == w1.shoulderGuard || _w[3] == w2.shoulderGuard) &&
1867                 (_w[4] == w1.armGuards || _w[4] == w2.armGuards) &&
1868                 (_w[5] == w1.sideWeapon || _w[5] == w2.sideWeapon) &&
1869                 (_w[6] == w1.backWeapon || _w[6] == w2.backWeapon) &&
1870                 (_w[7] == w1.background || _w[7] == w2.background),
1871             "HOWL: invalid property transfer"
1872         );
1873 
1874         _burn(_tokenId2);
1875 
1876         ISoul(soulContractAddress).mint(
1877             msg.sender,
1878             seppukuBaseFee +
1879                 ((w1.killCount + w2.killCount) * seppukuMultiplierFee)
1880         );
1881 
1882         // Once any composability mechanic is used warlord traits become fully decoded
1883         // for the ease of future trait transfers between generations.
1884         _tokenIdToWarlord[_tokenId1] = _generateDecodedDna(
1885             Warlord(
1886                 _w[0],
1887                 _w[1],
1888                 _w[2],
1889                 _w[3],
1890                 _w[4],
1891                 _w[5],
1892                 _w[6],
1893                 _w[7],
1894                 w1.killCount + w2.killCount + 1
1895             )
1896         );
1897 
1898         uint256 gen = generationCounter.current();
1899 
1900         // Burned token has a chance of resurrection during the next generation.
1901         resurrectionTickets[msg.sender][_tokenId2] = gen + 1;
1902         emit Seppuku(msg.sender, gen, _tokenId1, _tokenId2);
1903     }
1904 
1905     function equipProperties(
1906         address _originalCaller,
1907         uint256 _tokenId,
1908         uint16[8] calldata _w
1909     ) external onlyAuthorizedToEquip {
1910         require(
1911             ownerOf(_tokenId) == _originalCaller,
1912             "HOWL: you don't own this token"
1913         );
1914 
1915         Warlord memory w = getWarlord(_tokenId);
1916 
1917         w.face = _w[0] == 0 ? w.face : _w[0];
1918         w.headGear = _w[1] == 0 ? w.headGear : _w[1];
1919         w.clothes = _w[2] == 0 ? w.clothes : _w[2];
1920         w.shoulderGuard = _w[3] == 0 ? w.shoulderGuard : _w[3];
1921         w.armGuards = _w[4] == 0 ? w.armGuards : _w[4];
1922         w.sideWeapon = _w[5] == 0 ? w.sideWeapon : _w[5];
1923         w.backWeapon = _w[6] == 0 ? w.backWeapon : _w[6];
1924         w.background = _w[7] == 0 ? w.background : _w[7];
1925 
1926         _tokenIdToWarlord[_tokenId] = _generateDecodedDna(w);
1927     }
1928 
1929     function startConquest(uint256 _tokenId) external onlyTokenOwner(_tokenId) {
1930         require(IS_STAKING_ON, "HOWL: conquests are disabled");
1931         require(
1932             conquests[_tokenId] == 0,
1933             "HOWL: current conquest hasn't ended yet"
1934         );
1935         conquests[_tokenId] = block.timestamp;
1936         emit StartConquest(_tokenId, block.timestamp);
1937     }
1938 
1939     function getCurrentConquestReward(uint256 _tokenId)
1940         public
1941         view
1942         returns (uint256)
1943     {
1944         uint256 conquestStart = conquests[_tokenId];
1945         require(conquestStart != 0, "HOWL: warlord is not on a conquest");
1946 
1947         // Calculate for how long the token has been staked
1948         uint256 stakedDays = (block.timestamp - conquestStart) / 24 / 60 / 60;
1949         uint256[3] memory periods = _stakingPeriods;
1950         uint256[3] memory rewards = _stakingRewards;
1951 
1952         if (stakedDays >= periods[2]) {
1953             return rewards[2];
1954         } else if (stakedDays >= periods[1]) {
1955             return rewards[1];
1956         } else if (stakedDays >= periods[0]) {
1957             return rewards[0];
1958         }
1959 
1960         return 0;
1961     }
1962 
1963     function endConquest(uint256 _tokenId) external onlyTokenOwner(_tokenId) {
1964         uint256 reward = getCurrentConquestReward(_tokenId);
1965         delete conquests[_tokenId];
1966 
1967         if (reward != 0) {
1968             ISoul(soulContractAddress).mint(msg.sender, reward);
1969         }
1970 
1971         emit EndConquest(_tokenId, reward);
1972     }
1973 
1974     // Tokens can't be transferred when on a conquest
1975     function _beforeTokenTransfer(
1976         address from,
1977         address to,
1978         uint256 tokenId
1979     ) internal view override {
1980         require(
1981             conquests[tokenId] == 0,
1982             "HOWL: can't transfer or burn warlord while on a conquest"
1983         );
1984     }
1985 
1986     function nameWarlord(uint256 _tokenId, string calldata _name)
1987         external
1988         onlyTokenOwner(_tokenId)
1989     {
1990         require(!namesTaken[_name], "HOWL: this name has been taken");
1991         ISoul(soulContractAddress).collectAndBurn(msg.sender, 250);
1992 
1993         // if warlords was renamed - unreserve the previous name
1994         string memory previousName = tokenIdToWarlordName[_tokenId];
1995         if (bytes(previousName).length > 0) {
1996             namesTaken[previousName] = false;
1997         }
1998 
1999         tokenIdToWarlordName[_tokenId] = _name;
2000 
2001         if (bytes(_name).length > 0) {
2002             namesTaken[_name] = true;
2003         }
2004 
2005         emit NameChange(_tokenId, _name);
2006     }
2007 
2008     function tokenURI(uint256 _tokenId)
2009         public
2010         view
2011         override
2012         returns (string memory)
2013     {
2014         require(_exists(_tokenId), "HOWL: warlord doesn't exist");
2015 
2016         if (
2017             bytes(apiUrl).length == 0 ||
2018             !_isDnaRevealed(_tokenIdToWarlord[_tokenId])
2019         ) {
2020             return preRevealUrl;
2021         }
2022 
2023         Warlord memory w = getWarlord(_tokenId);
2024         string memory separator = "-";
2025         return
2026             string(
2027                 abi.encodePacked(
2028                     apiUrl,
2029                     abi.encodePacked(
2030                         _toString(_tokenId),
2031                         separator,
2032                         _toString(w.face),
2033                         separator,
2034                         _toString(w.headGear),
2035                         separator,
2036                         _toString(w.clothes)
2037                     ),
2038                     abi.encodePacked(
2039                         separator,
2040                         _toString(w.shoulderGuard),
2041                         separator,
2042                         _toString(w.armGuards),
2043                         separator,
2044                         _toString(w.sideWeapon)
2045                     ),
2046                     abi.encodePacked(
2047                         separator,
2048                         _toString(w.backWeapon),
2049                         separator,
2050                         _toString(w.background),
2051                         separator,
2052                         _toString(w.killCount)
2053                     )
2054                 )
2055             );
2056     }
2057 
2058     function _verifySignature(
2059         address _signer,
2060         bytes32 _hash,
2061         bytes memory _signature
2062     ) private pure returns (bool) {
2063         return
2064             _signer ==
2065             ECDSA.recover(ECDSA.toEthSignedMessageHash(_hash), _signature);
2066     }
2067 
2068     function _getSeed() private view returns (uint256) {
2069         return uint256(blockhash(block.number - 1));
2070     }
2071 
2072     function _generateDecodedDna(Warlord memory _w)
2073         private
2074         pure
2075         returns (uint256)
2076     {
2077         uint256 dna = _w.killCount; // 8
2078         dna = (dna << 16) | _w.background; // 7
2079         dna = (dna << 16) | _w.backWeapon; // 6
2080         dna = (dna << 16) | _w.sideWeapon; // 5
2081         dna = (dna << 16) | _w.armGuards; // 4
2082         dna = (dna << 16) | _w.shoulderGuard; // 3
2083         dna = (dna << 16) | _w.clothes; // 2
2084         dna = (dna << 16) | _w.headGear; // 1
2085         dna = (dna << 16) | _w.face; // 0
2086         dna = (dna << 1) | 1; // flag indicating whether this dna was decoded
2087         // Decoded DNA won't have a generation number anymore.
2088         // These traits will permanently look decoded and no further manipulation will be needed
2089         // apart from just extracting it with a bitshift.
2090 
2091         return dna;
2092     }
2093 
2094     function _isDnaRevealed(uint256 _dna) private view returns (bool) {
2095         // Check the last bit to see if dna is decoded.
2096         if (_dna & 1 == 1) {
2097             return true;
2098         }
2099 
2100         // If dna wasn't decoded we wanna look up whether the generation it belongs to was revealed.
2101         return isGenerationRevealed[(_dna >> 1) & 0xFF];
2102     }
2103 
2104     function getWarlord(uint256 _tokenId) public view returns (Warlord memory) {
2105         uint256 dna = _tokenIdToWarlord[_tokenId];
2106         require(_isDnaRevealed(dna), "HOWL: warlord is not revealed yet");
2107 
2108         Warlord memory w;
2109         w.face = _getWarlordProperty(dna, 0);
2110         w.headGear = _getWarlordProperty(dna, 1);
2111         w.clothes = _getWarlordProperty(dna, 2);
2112         w.shoulderGuard = _getWarlordProperty(dna, 3);
2113         w.armGuards = _getWarlordProperty(dna, 4);
2114         w.sideWeapon = _getWarlordProperty(dna, 5);
2115         w.backWeapon = _getWarlordProperty(dna, 6);
2116         w.background = _getWarlordProperty(dna, 7);
2117         w.killCount = _getWarlordProperty(dna, 8);
2118 
2119         return w;
2120     }
2121 
2122     function _getWarlordProperty(uint256 _dna, uint256 _propertyId)
2123         private
2124         view
2125         returns (uint16)
2126     {
2127         // Property right offset in bits.
2128         uint256 bitShift = _propertyId * 16;
2129 
2130         // Last bit shows whether the dna was already decoded.
2131         // If it was we can safely return the stored value after bitshifting and applying a mask.
2132         // Decoded values don't have a generation number, so only need to shift by one bit to account for the flag.
2133         if (_dna & 1 == 1) {
2134             return uint16(((_dna >> 1) >> bitShift) & 0xFFFF);
2135         }
2136 
2137         // Every time warlords commit seppuku their DNA will be decoded.
2138         // If we got here it means that it wasn't decoded and we can safely assume that their kill counter is 0.
2139         if (_propertyId == 8) {
2140             return 0;
2141         }
2142 
2143         // Minted generation number is stored inside of 8 bits after the encoded/decoded flag.
2144         uint256 gen = (_dna >> 1) & 0xFF;
2145 
2146         // Rarity and range values to decode the property (specific to generation)
2147         uint16[2] storage _rarity = generationRarities[gen];
2148         uint16[4] storage _range = generationRanges[gen][_propertyId];
2149 
2150         // Extracting the encoded (raw) property (also shifting by 9bits first to account for generation metadata and a flag).
2151         // This property is just a raw value, it will get decoded with _rarity and _range information from above.
2152         uint256 encodedProp = (((_dna >> 9) >> bitShift) & 0xFFFF);
2153 
2154         if (
2155             (_propertyId == 3 || _propertyId == 4 || _propertyId == 5) &&
2156             // 60% chance that sideWeapon/armGuards/shoulderGuard will appear
2157             uint256(keccak256(abi.encodePacked(encodedProp, _range))) % 100 > 60
2158         ) {
2159             // Unlucky
2160             return 0;
2161         }
2162 
2163         // A value that will dictate from which pool of properties we should pull (common, uncommon, rare)
2164         uint256 rarityDecider = (uint256(
2165             keccak256(abi.encodePacked(_propertyId, _dna, _range))
2166         ) % 100) + 1;
2167 
2168         uint256 rangeStart;
2169         uint256 rangeEnd;
2170 
2171         // There is an opportunity to optimize for SLOAD operations here by byte packing all
2172         // rarity/range information and loading it in getWarlord before this function
2173         // is called to minimize state access.
2174         if (rarityDecider <= _rarity[0]) {
2175             // common
2176             rangeStart = _range[0];
2177             rangeEnd = _range[1];
2178         } else if (rarityDecider <= _rarity[1] + _rarity[0]) {
2179             // uncommon
2180             rangeStart = _range[1];
2181             rangeEnd = _range[2];
2182         } else {
2183             // rare
2184             rangeStart = _range[2];
2185             rangeEnd = _range[3];
2186         }
2187 
2188         // Returns a decoded property that will fall within one of the rarity buckets.
2189         return uint16((encodedProp % (rangeEnd - rangeStart)) + rangeStart);
2190     }
2191 
2192     function _toString(uint256 value) internal pure returns (string memory) {
2193         // Inspired by OraclizeAPI's implementation - MIT license
2194         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
2195 
2196         if (value == 0) {
2197             return "0";
2198         }
2199         uint256 temp = value;
2200         uint256 digits;
2201         while (temp != 0) {
2202             digits++;
2203             temp /= 10;
2204         }
2205         bytes memory buffer = new bytes(digits);
2206         while (value != 0) {
2207             digits -= 1;
2208             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
2209             value /= 10;
2210         }
2211         return string(buffer);
2212     }
2213 }