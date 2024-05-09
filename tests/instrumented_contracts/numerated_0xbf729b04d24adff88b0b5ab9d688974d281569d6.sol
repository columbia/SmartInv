1 // File: contracts/IWagyu.sol
2 
3 
4 pragma solidity ^0.8.4;
5 
6 interface IWagyu {
7     function mint(address user, uint256 amount) external;
8     function burn(address user, uint256 amount) external;
9     function setController(address controller, bool authorized) external;
10     function setAuthorizedAddress(address authorizedAddress, bool authorized) external;
11 }
12 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
13 
14 
15 
16 pragma solidity ^0.8.0;
17 
18 /**
19  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
20  *
21  * These functions can be used to verify that a message was signed by the holder
22  * of the private keys of a given address.
23  */
24 library ECDSA {
25     enum RecoverError {
26         NoError,
27         InvalidSignature,
28         InvalidSignatureLength,
29         InvalidSignatureS,
30         InvalidSignatureV
31     }
32 
33     function _throwError(RecoverError error) private pure {
34         if (error == RecoverError.NoError) {
35             return; // no error: do nothing
36         } else if (error == RecoverError.InvalidSignature) {
37             revert("ECDSA: invalid signature");
38         } else if (error == RecoverError.InvalidSignatureLength) {
39             revert("ECDSA: invalid signature length");
40         } else if (error == RecoverError.InvalidSignatureS) {
41             revert("ECDSA: invalid signature 's' value");
42         } else if (error == RecoverError.InvalidSignatureV) {
43             revert("ECDSA: invalid signature 'v' value");
44         }
45     }
46 
47     /**
48      * @dev Returns the address that signed a hashed message (`hash`) with
49      * `signature` or error string. This address can then be used for verification purposes.
50      *
51      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
52      * this function rejects them by requiring the `s` value to be in the lower
53      * half order, and the `v` value to be either 27 or 28.
54      *
55      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
56      * verification to be secure: it is possible to craft signatures that
57      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
58      * this is by receiving a hash of the original message (which may otherwise
59      * be too long), and then calling {toEthSignedMessageHash} on it.
60      *
61      * Documentation for signature generation:
62      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
63      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
64      *
65      * _Available since v4.3._
66      */
67     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
68         // Check the signature length
69         // - case 65: r,s,v signature (standard)
70         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
71         if (signature.length == 65) {
72             bytes32 r;
73             bytes32 s;
74             uint8 v;
75             // ecrecover takes the signature parameters, and the only way to get them
76             // currently is to use assembly.
77             assembly {
78                 r := mload(add(signature, 0x20))
79                 s := mload(add(signature, 0x40))
80                 v := byte(0, mload(add(signature, 0x60)))
81             }
82             return tryRecover(hash, v, r, s);
83         } else if (signature.length == 64) {
84             bytes32 r;
85             bytes32 vs;
86             // ecrecover takes the signature parameters, and the only way to get them
87             // currently is to use assembly.
88             assembly {
89                 r := mload(add(signature, 0x20))
90                 vs := mload(add(signature, 0x40))
91             }
92             return tryRecover(hash, r, vs);
93         } else {
94             return (address(0), RecoverError.InvalidSignatureLength);
95         }
96     }
97 
98     /**
99      * @dev Returns the address that signed a hashed message (`hash`) with
100      * `signature`. This address can then be used for verification purposes.
101      *
102      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
103      * this function rejects them by requiring the `s` value to be in the lower
104      * half order, and the `v` value to be either 27 or 28.
105      *
106      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
107      * verification to be secure: it is possible to craft signatures that
108      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
109      * this is by receiving a hash of the original message (which may otherwise
110      * be too long), and then calling {toEthSignedMessageHash} on it.
111      */
112     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
113         (address recovered, RecoverError error) = tryRecover(hash, signature);
114         _throwError(error);
115         return recovered;
116     }
117 
118     /**
119      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
120      *
121      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
122      *
123      * _Available since v4.3._
124      */
125     function tryRecover(
126         bytes32 hash,
127         bytes32 r,
128         bytes32 vs
129     ) internal pure returns (address, RecoverError) {
130         bytes32 s;
131         uint8 v;
132         assembly {
133             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
134             v := add(shr(255, vs), 27)
135         }
136         return tryRecover(hash, v, r, s);
137     }
138 
139     /**
140      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
141      *
142      * _Available since v4.2._
143      */
144     function recover(
145         bytes32 hash,
146         bytes32 r,
147         bytes32 vs
148     ) internal pure returns (address) {
149         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
150         _throwError(error);
151         return recovered;
152     }
153 
154     /**
155      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
156      * `r` and `s` signature fields separately.
157      *
158      * _Available since v4.3._
159      */
160     function tryRecover(
161         bytes32 hash,
162         uint8 v,
163         bytes32 r,
164         bytes32 s
165     ) internal pure returns (address, RecoverError) {
166         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
167         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
168         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
169         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
170         //
171         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
172         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
173         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
174         // these malleable signatures as well.
175         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
176             return (address(0), RecoverError.InvalidSignatureS);
177         }
178         if (v != 27 && v != 28) {
179             return (address(0), RecoverError.InvalidSignatureV);
180         }
181 
182         // If the signature is valid (and not malleable), return the signer address
183         address signer = ecrecover(hash, v, r, s);
184         if (signer == address(0)) {
185             return (address(0), RecoverError.InvalidSignature);
186         }
187 
188         return (signer, RecoverError.NoError);
189     }
190 
191     /**
192      * @dev Overload of {ECDSA-recover} that receives the `v`,
193      * `r` and `s` signature fields separately.
194      */
195     function recover(
196         bytes32 hash,
197         uint8 v,
198         bytes32 r,
199         bytes32 s
200     ) internal pure returns (address) {
201         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
202         _throwError(error);
203         return recovered;
204     }
205 
206     /**
207      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
208      * produces hash corresponding to the one signed with the
209      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
210      * JSON-RPC method as part of EIP-191.
211      *
212      * See {recover}.
213      */
214     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
215         // 32 is the length in bytes of hash,
216         // enforced by the type signature above
217         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
218     }
219 
220     /**
221      * @dev Returns an Ethereum Signed Typed Data, created from a
222      * `domainSeparator` and a `structHash`. This produces hash corresponding
223      * to the one signed with the
224      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
225      * JSON-RPC method as part of EIP-712.
226      *
227      * See {recover}.
228      */
229     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
230         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
231     }
232 }
233 
234 // File: @openzeppelin/contracts/utils/Strings.sol
235 
236 
237 
238 pragma solidity ^0.8.0;
239 
240 /**
241  * @dev String operations.
242  */
243 library Strings {
244     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
245 
246     /**
247      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
248      */
249     function toString(uint256 value) internal pure returns (string memory) {
250         // Inspired by OraclizeAPI's implementation - MIT licence
251         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
252 
253         if (value == 0) {
254             return "0";
255         }
256         uint256 temp = value;
257         uint256 digits;
258         while (temp != 0) {
259             digits++;
260             temp /= 10;
261         }
262         bytes memory buffer = new bytes(digits);
263         while (value != 0) {
264             digits -= 1;
265             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
266             value /= 10;
267         }
268         return string(buffer);
269     }
270 
271     /**
272      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
273      */
274     function toHexString(uint256 value) internal pure returns (string memory) {
275         if (value == 0) {
276             return "0x00";
277         }
278         uint256 temp = value;
279         uint256 length = 0;
280         while (temp != 0) {
281             length++;
282             temp >>= 8;
283         }
284         return toHexString(value, length);
285     }
286 
287     /**
288      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
289      */
290     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
291         bytes memory buffer = new bytes(2 * length + 2);
292         buffer[0] = "0";
293         buffer[1] = "x";
294         for (uint256 i = 2 * length + 1; i > 1; --i) {
295             buffer[i] = _HEX_SYMBOLS[value & 0xf];
296             value >>= 4;
297         }
298         require(value == 0, "Strings: hex length insufficient");
299         return string(buffer);
300     }
301 }
302 
303 // File: @openzeppelin/contracts/utils/Context.sol
304 
305 
306 
307 pragma solidity ^0.8.0;
308 
309 /**
310  * @dev Provides information about the current execution context, including the
311  * sender of the transaction and its data. While these are generally available
312  * via msg.sender and msg.data, they should not be accessed in such a direct
313  * manner, since when dealing with meta-transactions the account sending and
314  * paying for execution may not be the actual sender (as far as an application
315  * is concerned).
316  *
317  * This contract is only required for intermediate, library-like contracts.
318  */
319 abstract contract Context {
320     function _msgSender() internal view virtual returns (address) {
321         return msg.sender;
322     }
323 
324     function _msgData() internal view virtual returns (bytes calldata) {
325         return msg.data;
326     }
327 }
328 
329 // File: @openzeppelin/contracts/access/Ownable.sol
330 
331 
332 
333 pragma solidity ^0.8.0;
334 
335 
336 /**
337  * @dev Contract module which provides a basic access control mechanism, where
338  * there is an account (an owner) that can be granted exclusive access to
339  * specific functions.
340  *
341  * By default, the owner account will be the one that deploys the contract. This
342  * can later be changed with {transferOwnership}.
343  *
344  * This module is used through inheritance. It will make available the modifier
345  * `onlyOwner`, which can be applied to your functions to restrict their use to
346  * the owner.
347  */
348 abstract contract Ownable is Context {
349     address private _owner;
350 
351     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
352 
353     /**
354      * @dev Initializes the contract setting the deployer as the initial owner.
355      */
356     constructor() {
357         _setOwner(_msgSender());
358     }
359 
360     /**
361      * @dev Returns the address of the current owner.
362      */
363     function owner() public view virtual returns (address) {
364         return _owner;
365     }
366 
367     /**
368      * @dev Throws if called by any account other than the owner.
369      */
370     modifier onlyOwner() {
371         require(owner() == _msgSender(), "Ownable: caller is not the owner");
372         _;
373     }
374 
375     /**
376      * @dev Leaves the contract without owner. It will not be possible to call
377      * `onlyOwner` functions anymore. Can only be called by the current owner.
378      *
379      * NOTE: Renouncing ownership will leave the contract without an owner,
380      * thereby removing any functionality that is only available to the owner.
381      */
382     function renounceOwnership() public virtual onlyOwner {
383         _setOwner(address(0));
384     }
385 
386     /**
387      * @dev Transfers ownership of the contract to a new account (`newOwner`).
388      * Can only be called by the current owner.
389      */
390     function transferOwnership(address newOwner) public virtual onlyOwner {
391         require(newOwner != address(0), "Ownable: new owner is the zero address");
392         _setOwner(newOwner);
393     }
394 
395     function _setOwner(address newOwner) private {
396         address oldOwner = _owner;
397         _owner = newOwner;
398         emit OwnershipTransferred(oldOwner, newOwner);
399     }
400 }
401 
402 // File: @openzeppelin/contracts/utils/Address.sol
403 
404 
405 
406 pragma solidity ^0.8.0;
407 
408 /**
409  * @dev Collection of functions related to the address type
410  */
411 library Address {
412     /**
413      * @dev Returns true if `account` is a contract.
414      *
415      * [IMPORTANT]
416      * ====
417      * It is unsafe to assume that an address for which this function returns
418      * false is an externally-owned account (EOA) and not a contract.
419      *
420      * Among others, `isContract` will return false for the following
421      * types of addresses:
422      *
423      *  - an externally-owned account
424      *  - a contract in construction
425      *  - an address where a contract will be created
426      *  - an address where a contract lived, but was destroyed
427      * ====
428      */
429     function isContract(address account) internal view returns (bool) {
430         // This method relies on extcodesize, which returns 0 for contracts in
431         // construction, since the code is only stored at the end of the
432         // constructor execution.
433 
434         uint256 size;
435         assembly {
436             size := extcodesize(account)
437         }
438         return size > 0;
439     }
440 
441     /**
442      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
443      * `recipient`, forwarding all available gas and reverting on errors.
444      *
445      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
446      * of certain opcodes, possibly making contracts go over the 2300 gas limit
447      * imposed by `transfer`, making them unable to receive funds via
448      * `transfer`. {sendValue} removes this limitation.
449      *
450      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
451      *
452      * IMPORTANT: because control is transferred to `recipient`, care must be
453      * taken to not create reentrancy vulnerabilities. Consider using
454      * {ReentrancyGuard} or the
455      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
456      */
457     function sendValue(address payable recipient, uint256 amount) internal {
458         require(address(this).balance >= amount, "Address: insufficient balance");
459 
460         (bool success, ) = recipient.call{value: amount}("");
461         require(success, "Address: unable to send value, recipient may have reverted");
462     }
463 
464     /**
465      * @dev Performs a Solidity function call using a low level `call`. A
466      * plain `call` is an unsafe replacement for a function call: use this
467      * function instead.
468      *
469      * If `target` reverts with a revert reason, it is bubbled up by this
470      * function (like regular Solidity function calls).
471      *
472      * Returns the raw returned data. To convert to the expected return value,
473      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
474      *
475      * Requirements:
476      *
477      * - `target` must be a contract.
478      * - calling `target` with `data` must not revert.
479      *
480      * _Available since v3.1._
481      */
482     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
483         return functionCall(target, data, "Address: low-level call failed");
484     }
485 
486     /**
487      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
488      * `errorMessage` as a fallback revert reason when `target` reverts.
489      *
490      * _Available since v3.1._
491      */
492     function functionCall(
493         address target,
494         bytes memory data,
495         string memory errorMessage
496     ) internal returns (bytes memory) {
497         return functionCallWithValue(target, data, 0, errorMessage);
498     }
499 
500     /**
501      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
502      * but also transferring `value` wei to `target`.
503      *
504      * Requirements:
505      *
506      * - the calling contract must have an ETH balance of at least `value`.
507      * - the called Solidity function must be `payable`.
508      *
509      * _Available since v3.1._
510      */
511     function functionCallWithValue(
512         address target,
513         bytes memory data,
514         uint256 value
515     ) internal returns (bytes memory) {
516         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
517     }
518 
519     /**
520      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
521      * with `errorMessage` as a fallback revert reason when `target` reverts.
522      *
523      * _Available since v3.1._
524      */
525     function functionCallWithValue(
526         address target,
527         bytes memory data,
528         uint256 value,
529         string memory errorMessage
530     ) internal returns (bytes memory) {
531         require(address(this).balance >= value, "Address: insufficient balance for call");
532         require(isContract(target), "Address: call to non-contract");
533 
534         (bool success, bytes memory returndata) = target.call{value: value}(data);
535         return verifyCallResult(success, returndata, errorMessage);
536     }
537 
538     /**
539      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
540      * but performing a static call.
541      *
542      * _Available since v3.3._
543      */
544     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
545         return functionStaticCall(target, data, "Address: low-level static call failed");
546     }
547 
548     /**
549      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
550      * but performing a static call.
551      *
552      * _Available since v3.3._
553      */
554     function functionStaticCall(
555         address target,
556         bytes memory data,
557         string memory errorMessage
558     ) internal view returns (bytes memory) {
559         require(isContract(target), "Address: static call to non-contract");
560 
561         (bool success, bytes memory returndata) = target.staticcall(data);
562         return verifyCallResult(success, returndata, errorMessage);
563     }
564 
565     /**
566      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
567      * but performing a delegate call.
568      *
569      * _Available since v3.4._
570      */
571     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
572         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
573     }
574 
575     /**
576      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
577      * but performing a delegate call.
578      *
579      * _Available since v3.4._
580      */
581     function functionDelegateCall(
582         address target,
583         bytes memory data,
584         string memory errorMessage
585     ) internal returns (bytes memory) {
586         require(isContract(target), "Address: delegate call to non-contract");
587 
588         (bool success, bytes memory returndata) = target.delegatecall(data);
589         return verifyCallResult(success, returndata, errorMessage);
590     }
591 
592     /**
593      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
594      * revert reason using the provided one.
595      *
596      * _Available since v4.3._
597      */
598     function verifyCallResult(
599         bool success,
600         bytes memory returndata,
601         string memory errorMessage
602     ) internal pure returns (bytes memory) {
603         if (success) {
604             return returndata;
605         } else {
606             // Look for revert reason and bubble it up if present
607             if (returndata.length > 0) {
608                 // The easiest way to bubble the revert reason is using memory via assembly
609 
610                 assembly {
611                     let returndata_size := mload(returndata)
612                     revert(add(32, returndata), returndata_size)
613                 }
614             } else {
615                 revert(errorMessage);
616             }
617         }
618     }
619 }
620 
621 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
622 
623 
624 
625 pragma solidity ^0.8.0;
626 
627 /**
628  * @title ERC721 token receiver interface
629  * @dev Interface for any contract that wants to support safeTransfers
630  * from ERC721 asset contracts.
631  */
632 interface IERC721Receiver {
633     /**
634      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
635      * by `operator` from `from`, this function is called.
636      *
637      * It must return its Solidity selector to confirm the token transfer.
638      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
639      *
640      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
641      */
642     function onERC721Received(
643         address operator,
644         address from,
645         uint256 tokenId,
646         bytes calldata data
647     ) external returns (bytes4);
648 }
649 
650 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
651 
652 
653 
654 pragma solidity ^0.8.0;
655 
656 /**
657  * @dev Interface of the ERC165 standard, as defined in the
658  * https://eips.ethereum.org/EIPS/eip-165[EIP].
659  *
660  * Implementers can declare support of contract interfaces, which can then be
661  * queried by others ({ERC165Checker}).
662  *
663  * For an implementation, see {ERC165}.
664  */
665 interface IERC165 {
666     /**
667      * @dev Returns true if this contract implements the interface defined by
668      * `interfaceId`. See the corresponding
669      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
670      * to learn more about how these ids are created.
671      *
672      * This function call must use less than 30 000 gas.
673      */
674     function supportsInterface(bytes4 interfaceId) external view returns (bool);
675 }
676 
677 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
678 
679 
680 
681 pragma solidity ^0.8.0;
682 
683 
684 /**
685  * @dev Implementation of the {IERC165} interface.
686  *
687  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
688  * for the additional interface id that will be supported. For example:
689  *
690  * ```solidity
691  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
692  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
693  * }
694  * ```
695  *
696  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
697  */
698 abstract contract ERC165 is IERC165 {
699     /**
700      * @dev See {IERC165-supportsInterface}.
701      */
702     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
703         return interfaceId == type(IERC165).interfaceId;
704     }
705 }
706 
707 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
708 
709 
710 
711 pragma solidity ^0.8.0;
712 
713 
714 /**
715  * @dev Required interface of an ERC721 compliant contract.
716  */
717 interface IERC721 is IERC165 {
718     /**
719      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
720      */
721     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
722 
723     /**
724      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
725      */
726     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
727 
728     /**
729      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
730      */
731     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
732 
733     /**
734      * @dev Returns the number of tokens in ``owner``'s account.
735      */
736     function balanceOf(address owner) external view returns (uint256 balance);
737 
738     /**
739      * @dev Returns the owner of the `tokenId` token.
740      *
741      * Requirements:
742      *
743      * - `tokenId` must exist.
744      */
745     function ownerOf(uint256 tokenId) external view returns (address owner);
746 
747     /**
748      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
749      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
750      *
751      * Requirements:
752      *
753      * - `from` cannot be the zero address.
754      * - `to` cannot be the zero address.
755      * - `tokenId` token must exist and be owned by `from`.
756      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
757      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
758      *
759      * Emits a {Transfer} event.
760      */
761     function safeTransferFrom(
762         address from,
763         address to,
764         uint256 tokenId
765     ) external;
766 
767     /**
768      * @dev Transfers `tokenId` token from `from` to `to`.
769      *
770      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
771      *
772      * Requirements:
773      *
774      * - `from` cannot be the zero address.
775      * - `to` cannot be the zero address.
776      * - `tokenId` token must be owned by `from`.
777      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
778      *
779      * Emits a {Transfer} event.
780      */
781     function transferFrom(
782         address from,
783         address to,
784         uint256 tokenId
785     ) external;
786 
787     /**
788      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
789      * The approval is cleared when the token is transferred.
790      *
791      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
792      *
793      * Requirements:
794      *
795      * - The caller must own the token or be an approved operator.
796      * - `tokenId` must exist.
797      *
798      * Emits an {Approval} event.
799      */
800     function approve(address to, uint256 tokenId) external;
801 
802     /**
803      * @dev Returns the account approved for `tokenId` token.
804      *
805      * Requirements:
806      *
807      * - `tokenId` must exist.
808      */
809     function getApproved(uint256 tokenId) external view returns (address operator);
810 
811     /**
812      * @dev Approve or remove `operator` as an operator for the caller.
813      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
814      *
815      * Requirements:
816      *
817      * - The `operator` cannot be the caller.
818      *
819      * Emits an {ApprovalForAll} event.
820      */
821     function setApprovalForAll(address operator, bool _approved) external;
822 
823     /**
824      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
825      *
826      * See {setApprovalForAll}
827      */
828     function isApprovedForAll(address owner, address operator) external view returns (bool);
829 
830     /**
831      * @dev Safely transfers `tokenId` token from `from` to `to`.
832      *
833      * Requirements:
834      *
835      * - `from` cannot be the zero address.
836      * - `to` cannot be the zero address.
837      * - `tokenId` token must exist and be owned by `from`.
838      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
839      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
840      *
841      * Emits a {Transfer} event.
842      */
843     function safeTransferFrom(
844         address from,
845         address to,
846         uint256 tokenId,
847         bytes calldata data
848     ) external;
849 }
850 
851 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
852 
853 
854 
855 pragma solidity ^0.8.0;
856 
857 
858 /**
859  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
860  * @dev See https://eips.ethereum.org/EIPS/eip-721
861  */
862 interface IERC721Metadata is IERC721 {
863     /**
864      * @dev Returns the token collection name.
865      */
866     function name() external view returns (string memory);
867 
868     /**
869      * @dev Returns the token collection symbol.
870      */
871     function symbol() external view returns (string memory);
872 
873     /**
874      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
875      */
876     function tokenURI(uint256 tokenId) external view returns (string memory);
877 }
878 
879 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
880 
881 
882 
883 pragma solidity ^0.8.0;
884 
885 
886 
887 
888 
889 
890 
891 
892 /**
893  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
894  * the Metadata extension, but not including the Enumerable extension, which is available separately as
895  * {ERC721Enumerable}.
896  */
897 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
898     using Address for address;
899     using Strings for uint256;
900 
901     // Token name
902     string private _name;
903 
904     // Token symbol
905     string private _symbol;
906 
907     // Mapping from token ID to owner address
908     mapping(uint256 => address) private _owners;
909 
910     // Mapping owner address to token count
911     mapping(address => uint256) private _balances;
912 
913     // Mapping from token ID to approved address
914     mapping(uint256 => address) private _tokenApprovals;
915 
916     // Mapping from owner to operator approvals
917     mapping(address => mapping(address => bool)) private _operatorApprovals;
918 
919     /**
920      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
921      */
922     constructor(string memory name_, string memory symbol_) {
923         _name = name_;
924         _symbol = symbol_;
925     }
926 
927     /**
928      * @dev See {IERC165-supportsInterface}.
929      */
930     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
931         return
932             interfaceId == type(IERC721).interfaceId ||
933             interfaceId == type(IERC721Metadata).interfaceId ||
934             super.supportsInterface(interfaceId);
935     }
936 
937     /**
938      * @dev See {IERC721-balanceOf}.
939      */
940     function balanceOf(address owner) public view virtual override returns (uint256) {
941         require(owner != address(0), "ERC721: balance query for the zero address");
942         return _balances[owner];
943     }
944 
945     /**
946      * @dev See {IERC721-ownerOf}.
947      */
948     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
949         address owner = _owners[tokenId];
950         require(owner != address(0), "ERC721: owner query for nonexistent token");
951         return owner;
952     }
953 
954     /**
955      * @dev See {IERC721Metadata-name}.
956      */
957     function name() public view virtual override returns (string memory) {
958         return _name;
959     }
960 
961     /**
962      * @dev See {IERC721Metadata-symbol}.
963      */
964     function symbol() public view virtual override returns (string memory) {
965         return _symbol;
966     }
967 
968     /**
969      * @dev See {IERC721Metadata-tokenURI}.
970      */
971     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
972         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
973 
974         string memory baseURI = _baseURI();
975         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
976     }
977 
978     /**
979      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
980      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
981      * by default, can be overriden in child contracts.
982      */
983     function _baseURI() internal view virtual returns (string memory) {
984         return "";
985     }
986 
987     /**
988      * @dev See {IERC721-approve}.
989      */
990     function approve(address to, uint256 tokenId) public virtual override {
991         address owner = ERC721.ownerOf(tokenId);
992         require(to != owner, "ERC721: approval to current owner");
993 
994         require(
995             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
996             "ERC721: approve caller is not owner nor approved for all"
997         );
998 
999         _approve(to, tokenId);
1000     }
1001 
1002     /**
1003      * @dev See {IERC721-getApproved}.
1004      */
1005     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1006         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1007 
1008         return _tokenApprovals[tokenId];
1009     }
1010 
1011     /**
1012      * @dev See {IERC721-setApprovalForAll}.
1013      */
1014     function setApprovalForAll(address operator, bool approved) public virtual override {
1015         require(operator != _msgSender(), "ERC721: approve to caller");
1016 
1017         _operatorApprovals[_msgSender()][operator] = approved;
1018         emit ApprovalForAll(_msgSender(), operator, approved);
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
1239      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1240      * The call is not executed if the target address is not a contract.
1241      *
1242      * @param from address representing the previous owner of the given token ID
1243      * @param to target address that will receive the tokens
1244      * @param tokenId uint256 ID of the token to be transferred
1245      * @param _data bytes optional data to send along with the call
1246      * @return bool whether the call correctly returned the expected magic value
1247      */
1248     function _checkOnERC721Received(
1249         address from,
1250         address to,
1251         uint256 tokenId,
1252         bytes memory _data
1253     ) private returns (bool) {
1254         if (to.isContract()) {
1255             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1256                 return retval == IERC721Receiver.onERC721Received.selector;
1257             } catch (bytes memory reason) {
1258                 if (reason.length == 0) {
1259                     revert("ERC721: transfer to non ERC721Receiver implementer");
1260                 } else {
1261                     assembly {
1262                         revert(add(32, reason), mload(reason))
1263                     }
1264                 }
1265             }
1266         } else {
1267             return true;
1268         }
1269     }
1270 
1271     /**
1272      * @dev Hook that is called before any token transfer. This includes minting
1273      * and burning.
1274      *
1275      * Calling conditions:
1276      *
1277      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1278      * transferred to `to`.
1279      * - When `from` is zero, `tokenId` will be minted for `to`.
1280      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1281      * - `from` and `to` are never both zero.
1282      *
1283      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1284      */
1285     function _beforeTokenTransfer(
1286         address from,
1287         address to,
1288         uint256 tokenId
1289     ) internal virtual {}
1290 }
1291 
1292 // File: contracts/gg.sol
1293 
1294 
1295 pragma solidity ^0.8.4;
1296 
1297 
1298 
1299 
1300 
1301 
1302 contract GhidorahGodz is ERC721, Ownable {
1303     using Strings for uint256;
1304 
1305     uint256 public constant SALE_MAX = 5944;
1306     uint256 public constant GIFT_MAX = 55;
1307     uint256 public constant EGG_MAX = 4000;
1308     uint256 public constant GG_PB_PRICE = 0.045 ether;
1309     uint256 public constant GG_PS_PRICE = 0.035 ether;
1310     uint256 public constant PER_MINT = 6;
1311     uint256 public constant PER_PRESALE = 2;
1312     address public constant PAYOUT_ADDRESS = 0x4E02BBBd1c318101FFA76645FF6B074aC68cf8be;
1313     address public constant DEV_ADDRESS = 0x411f92E47FB4Af1834D3ac651daa47D5f2B2417f;
1314 
1315     mapping(address => uint256) public presalerPurchases;
1316     mapping(string => bool) private _nonces;
1317     mapping(uint256 => uint256) private lastClaimedAt;
1318     
1319     string private _tokenBaseURI = "https://ghidorahgodz.com/api/metadata/";
1320     address private _signerAddress = 0xf11DD62Abe61bBE59fafe29bbaA9A6A085EAeda2;
1321     IWagyu private _wagyuToken;
1322     uint256[24] genesisTokenData;
1323 
1324     uint256 public wagyuPerDay = 10 ether;
1325     uint256 public wagyuStartTime = 1643641200;
1326     uint256 public totalSupply;
1327     uint256 public publicCounter;
1328     uint256 public privateCounter;
1329     uint256 public giftCounter;
1330     uint256 public eggCounter;
1331     bool public saleLive;
1332     bool public presaleLive;
1333     bool public wagyuLive;
1334     mapping(uint256 => bool) public revealed;
1335     
1336     constructor() ERC721("Ghidorah Godz", "GG") {}
1337     
1338     function verifyTransaction(address sender, uint256 amount, string calldata nonce, bytes calldata signature, bool presale) private view returns(bool) {
1339         bytes32 hash = keccak256(abi.encodePacked(sender, amount, nonce, presale));
1340         return _signerAddress == ECDSA.recover(hash, signature);
1341     }
1342 
1343     function purchase(uint256 amount, string calldata nonce, bytes calldata signature) external payable {
1344         require(saleLive && !presaleLive, "GG: Sale Closed");
1345         require(amount <= PER_MINT, "GG: Amount Exceeds Max Per TX");
1346         require(publicCounter + privateCounter + amount <= SALE_MAX, "GG: Max Minted");
1347         require(!_nonces[nonce], "GG: Signature Used");
1348         require(verifyTransaction(msg.sender, amount, nonce, signature, false), "GG: Contract Mint Disallowed");
1349         require(GG_PB_PRICE * amount <= msg.value, "GG: Insufficient ETH");
1350         
1351         _nonces[nonce] = true;
1352         publicCounter += amount;
1353 
1354         for (uint256 i = 1; i <= amount; i++) {
1355             _mint(msg.sender, totalSupply + i);
1356         }
1357 
1358         totalSupply += amount;
1359     }
1360 
1361     function purchasePresale(uint256 amount, string calldata nonce, bytes calldata signature) external payable {
1362         require(!saleLive && presaleLive, "GG: Presale Closed");
1363         require(publicCounter + privateCounter + amount <= SALE_MAX, "GG: Private Sale Max");
1364         require(presalerPurchases[msg.sender] + amount <= PER_PRESALE, "GG: Max Minted");
1365         require(!_nonces[nonce], "GG: Signature Used");
1366         require(verifyTransaction(msg.sender, amount, nonce, signature, true), "GG: Contract Mint Disallowed");
1367         require(GG_PS_PRICE * amount <= msg.value, "GG: Insufficient ETH");
1368 
1369         _nonces[nonce] = true;
1370         privateCounter += amount;
1371         presalerPurchases[msg.sender] += amount;
1372 
1373         for (uint256 i = 1; i <= amount; i++) {
1374             _mint(msg.sender, totalSupply + i);
1375         }
1376 
1377         totalSupply += amount;
1378     }
1379     
1380     function purchaseEggs(uint256 amount) external {
1381         require(wagyuLive, "GG: Wagyu Minting Not Live");
1382         eggCounter += amount;
1383         require(eggCounter <= EGG_MAX, "GG: Max Supply Minted");
1384 
1385         _wagyuToken.burn(msg.sender, amount * 600 ether);
1386 
1387         for (uint256 i = 1; i <= amount; i++) {
1388             _mint(msg.sender, totalSupply + i);
1389         }
1390 
1391         totalSupply += amount;
1392     }
1393 
1394     function breed(uint256 genesisOne, uint256 genesisTwo, uint256 nest) external {
1395         require(wagyuLive, "GG: Wagyu Minting Not Live");
1396         require(ownerOf(genesisOne) == msg.sender && ownerOf(genesisTwo) == msg.sender && ownerOf(nest) == msg.sender, "GG: Not owner of tokens");
1397         require(isGenesis(genesisOne) && isGenesis(genesisTwo) && nest > 5999 && nest < 10000, "GG: Invalid Token IDs");
1398         require(!revealed[nest], "GG: Unrevealed Nest Only");
1399 
1400         revealed[nest] = true;
1401     }
1402 
1403     function pendingWagyu(uint256[] calldata tokens) external view returns(uint256) {
1404         require(block.timestamp > wagyuStartTime, "GG: Wagyu not live");
1405         uint256 pending;
1406 
1407         for (uint256 i = 0; i < tokens.length; i++) {
1408             uint256 token = tokens[i];
1409             if (isGenesis(token) && ownerOf(token) == msg.sender) {
1410                 uint256 _lastClaimedAt = lastClaimedAt[token];
1411                 pending += (block.timestamp - (_lastClaimedAt == 0 ? wagyuStartTime : _lastClaimedAt)) * wagyuPerDay / 86400;
1412             }
1413         }
1414 
1415         return pending;
1416     }
1417 
1418     function claimWagyu(uint256[] calldata tokens) external {
1419         require(block.timestamp > wagyuStartTime, "GG: Wagyu not live");
1420         uint256 pending;
1421 
1422         for (uint256 i = 0; i < tokens.length; i++) {
1423             uint256 token = tokens[i];
1424             if (isGenesis(token) && ownerOf(token) == msg.sender) {
1425                 uint256 _lastClaimedAt = lastClaimedAt[token];
1426                 pending += (block.timestamp - (_lastClaimedAt == 0 ? wagyuStartTime : _lastClaimedAt)) * wagyuPerDay / 86400;
1427                 lastClaimedAt[token] = block.timestamp;
1428             }
1429         }
1430 
1431         _wagyuToken.mint(msg.sender, pending);
1432     }
1433 
1434     function gift(address[] calldata _receivers) external onlyOwner {
1435         giftCounter += _receivers.length;
1436         require(giftCounter <= GIFT_MAX, "GG: Receivers can't exceed gift max");
1437 
1438         for (uint256 i = 1; i <= _receivers.length; i++) {
1439             _mint(_receivers[i - 1], totalSupply + i);
1440         }
1441 
1442         totalSupply += _receivers.length;
1443     }
1444     
1445     function withdraw() external onlyOwner {
1446         payable(DEV_ADDRESS).transfer(address(this).balance / 10);
1447         payable(PAYOUT_ADDRESS).transfer(address(this).balance);
1448     }
1449     
1450     function toggleSale() external onlyOwner {
1451         saleLive = !saleLive;
1452     }
1453     
1454     function togglePresale() external onlyOwner {
1455         presaleLive = !presaleLive;
1456     }
1457 
1458     function toggleWagyu() external onlyOwner {
1459         wagyuLive = !wagyuLive;
1460     }
1461     
1462     function setSignerAddress(address addr) external onlyOwner {
1463         _signerAddress = addr;
1464     }
1465 
1466     function setWagyuAddress(address addr) external onlyOwner {
1467         _wagyuToken = IWagyu(addr);
1468     }
1469 
1470     function setWagyuRate(uint256 rate) external onlyOwner {
1471        wagyuPerDay = rate;
1472     }
1473 
1474     function setWagyuStartTime(uint256 startTime) external onlyOwner {
1475        wagyuPerDay = startTime;
1476     }
1477 
1478     function setBaseURI(string calldata uri) external onlyOwner {
1479         _tokenBaseURI = uri;
1480     }
1481 
1482     function setGenesisTokens(uint256[24] calldata data) external onlyOwner {
1483         genesisTokenData = data;
1484     }
1485 
1486     function isGenesis(uint256 tokenId) public view returns (bool) {
1487         require(tokenId < 6000, "Invalid token");
1488         return genesisTokenData[tokenId / 256] >> (tokenId % 256) & 1 == 1;
1489     }
1490     
1491     function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) {
1492         require(_exists(tokenId), "Cannot query non-existent token");
1493         
1494         return string(abi.encodePacked(_tokenBaseURI, tokenId.toString()));
1495     }
1496 }