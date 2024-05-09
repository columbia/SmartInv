1 // File: @openzeppelin/contracts/utils/Counters.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @title Counters
10  * @author Matt Condon (@shrugs)
11  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
12  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
13  *
14  * Include with `using Counters for Counters.Counter;`
15  */
16 library Counters {
17     struct Counter {
18         // This variable should never be directly accessed by users of the library: interactions must be restricted to
19         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
20         // this feature: see https://github.com/ethereum/solidity/issues/4637
21         uint256 _value; // default: 0
22     }
23 
24     function current(Counter storage counter) internal view returns (uint256) {
25         return counter._value;
26     }
27 
28     function increment(Counter storage counter) internal {
29         unchecked {
30             counter._value += 1;
31         }
32     }
33 
34     function decrement(Counter storage counter) internal {
35         uint256 value = counter._value;
36         require(value > 0, "Counter: decrement overflow");
37         unchecked {
38             counter._value = value - 1;
39         }
40     }
41 
42     function reset(Counter storage counter) internal {
43         counter._value = 0;
44     }
45 }
46 
47 // File: @openzeppelin/contracts/utils/Strings.sol
48 
49 
50 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
51 
52 pragma solidity ^0.8.0;
53 
54 /**
55  * @dev String operations.
56  */
57 library Strings {
58     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
59 
60     /**
61      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
62      */
63     function toString(uint256 value) internal pure returns (string memory) {
64         // Inspired by OraclizeAPI's implementation - MIT licence
65         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
66 
67         if (value == 0) {
68             return "0";
69         }
70         uint256 temp = value;
71         uint256 digits;
72         while (temp != 0) {
73             digits++;
74             temp /= 10;
75         }
76         bytes memory buffer = new bytes(digits);
77         while (value != 0) {
78             digits -= 1;
79             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
80             value /= 10;
81         }
82         return string(buffer);
83     }
84 
85     /**
86      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
87      */
88     function toHexString(uint256 value) internal pure returns (string memory) {
89         if (value == 0) {
90             return "0x00";
91         }
92         uint256 temp = value;
93         uint256 length = 0;
94         while (temp != 0) {
95             length++;
96             temp >>= 8;
97         }
98         return toHexString(value, length);
99     }
100 
101     /**
102      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
103      */
104     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
105         bytes memory buffer = new bytes(2 * length + 2);
106         buffer[0] = "0";
107         buffer[1] = "x";
108         for (uint256 i = 2 * length + 1; i > 1; --i) {
109             buffer[i] = _HEX_SYMBOLS[value & 0xf];
110             value >>= 4;
111         }
112         require(value == 0, "Strings: hex length insufficient");
113         return string(buffer);
114     }
115 }
116 
117 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
118 
119 
120 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
121 
122 pragma solidity ^0.8.0;
123 
124 
125 /**
126  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
127  *
128  * These functions can be used to verify that a message was signed by the holder
129  * of the private keys of a given address.
130  */
131 library ECDSA {
132     enum RecoverError {
133         NoError,
134         InvalidSignature,
135         InvalidSignatureLength,
136         InvalidSignatureS,
137         InvalidSignatureV
138     }
139 
140     function _throwError(RecoverError error) private pure {
141         if (error == RecoverError.NoError) {
142             return; // no error: do nothing
143         } else if (error == RecoverError.InvalidSignature) {
144             revert("ECDSA: invalid signature");
145         } else if (error == RecoverError.InvalidSignatureLength) {
146             revert("ECDSA: invalid signature length");
147         } else if (error == RecoverError.InvalidSignatureS) {
148             revert("ECDSA: invalid signature 's' value");
149         } else if (error == RecoverError.InvalidSignatureV) {
150             revert("ECDSA: invalid signature 'v' value");
151         }
152     }
153 
154     /**
155      * @dev Returns the address that signed a hashed message (`hash`) with
156      * `signature` or error string. This address can then be used for verification purposes.
157      *
158      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
159      * this function rejects them by requiring the `s` value to be in the lower
160      * half order, and the `v` value to be either 27 or 28.
161      *
162      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
163      * verification to be secure: it is possible to craft signatures that
164      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
165      * this is by receiving a hash of the original message (which may otherwise
166      * be too long), and then calling {toEthSignedMessageHash} on it.
167      *
168      * Documentation for signature generation:
169      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
170      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
171      *
172      * _Available since v4.3._
173      */
174     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
175         // Check the signature length
176         // - case 65: r,s,v signature (standard)
177         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
178         if (signature.length == 65) {
179             bytes32 r;
180             bytes32 s;
181             uint8 v;
182             // ecrecover takes the signature parameters, and the only way to get them
183             // currently is to use assembly.
184             assembly {
185                 r := mload(add(signature, 0x20))
186                 s := mload(add(signature, 0x40))
187                 v := byte(0, mload(add(signature, 0x60)))
188             }
189             return tryRecover(hash, v, r, s);
190         } else if (signature.length == 64) {
191             bytes32 r;
192             bytes32 vs;
193             // ecrecover takes the signature parameters, and the only way to get them
194             // currently is to use assembly.
195             assembly {
196                 r := mload(add(signature, 0x20))
197                 vs := mload(add(signature, 0x40))
198             }
199             return tryRecover(hash, r, vs);
200         } else {
201             return (address(0), RecoverError.InvalidSignatureLength);
202         }
203     }
204 
205     /**
206      * @dev Returns the address that signed a hashed message (`hash`) with
207      * `signature`. This address can then be used for verification purposes.
208      *
209      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
210      * this function rejects them by requiring the `s` value to be in the lower
211      * half order, and the `v` value to be either 27 or 28.
212      *
213      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
214      * verification to be secure: it is possible to craft signatures that
215      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
216      * this is by receiving a hash of the original message (which may otherwise
217      * be too long), and then calling {toEthSignedMessageHash} on it.
218      */
219     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
220         (address recovered, RecoverError error) = tryRecover(hash, signature);
221         _throwError(error);
222         return recovered;
223     }
224 
225     /**
226      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
227      *
228      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
229      *
230      * _Available since v4.3._
231      */
232     function tryRecover(
233         bytes32 hash,
234         bytes32 r,
235         bytes32 vs
236     ) internal pure returns (address, RecoverError) {
237         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
238         uint8 v = uint8((uint256(vs) >> 255) + 27);
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
349 // File: @openzeppelin/contracts/utils/Context.sol
350 
351 
352 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
353 
354 pragma solidity ^0.8.0;
355 
356 /**
357  * @dev Provides information about the current execution context, including the
358  * sender of the transaction and its data. While these are generally available
359  * via msg.sender and msg.data, they should not be accessed in such a direct
360  * manner, since when dealing with meta-transactions the account sending and
361  * paying for execution may not be the actual sender (as far as an application
362  * is concerned).
363  *
364  * This contract is only required for intermediate, library-like contracts.
365  */
366 abstract contract Context {
367     function _msgSender() internal view virtual returns (address) {
368         return msg.sender;
369     }
370 
371     function _msgData() internal view virtual returns (bytes calldata) {
372         return msg.data;
373     }
374 }
375 
376 // File: @openzeppelin/contracts/access/Ownable.sol
377 
378 
379 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
380 
381 pragma solidity ^0.8.0;
382 
383 
384 /**
385  * @dev Contract module which provides a basic access control mechanism, where
386  * there is an account (an owner) that can be granted exclusive access to
387  * specific functions.
388  *
389  * By default, the owner account will be the one that deploys the contract. This
390  * can later be changed with {transferOwnership}.
391  *
392  * This module is used through inheritance. It will make available the modifier
393  * `onlyOwner`, which can be applied to your functions to restrict their use to
394  * the owner.
395  */
396 abstract contract Ownable is Context {
397     address private _owner;
398 
399     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
400 
401     /**
402      * @dev Initializes the contract setting the deployer as the initial owner.
403      */
404     constructor() {
405         _transferOwnership(_msgSender());
406     }
407 
408     /**
409      * @dev Returns the address of the current owner.
410      */
411     function owner() public view virtual returns (address) {
412         return _owner;
413     }
414 
415     /**
416      * @dev Throws if called by any account other than the owner.
417      */
418     modifier onlyOwner() {
419         require(owner() == _msgSender(), "Ownable: caller is not the owner");
420         _;
421     }
422 
423     /**
424      * @dev Leaves the contract without owner. It will not be possible to call
425      * `onlyOwner` functions anymore. Can only be called by the current owner.
426      *
427      * NOTE: Renouncing ownership will leave the contract without an owner,
428      * thereby removing any functionality that is only available to the owner.
429      */
430     function renounceOwnership() public virtual onlyOwner {
431         _transferOwnership(address(0));
432     }
433 
434     /**
435      * @dev Transfers ownership of the contract to a new account (`newOwner`).
436      * Can only be called by the current owner.
437      */
438     function transferOwnership(address newOwner) public virtual onlyOwner {
439         require(newOwner != address(0), "Ownable: new owner is the zero address");
440         _transferOwnership(newOwner);
441     }
442 
443     /**
444      * @dev Transfers ownership of the contract to a new account (`newOwner`).
445      * Internal function without access restriction.
446      */
447     function _transferOwnership(address newOwner) internal virtual {
448         address oldOwner = _owner;
449         _owner = newOwner;
450         emit OwnershipTransferred(oldOwner, newOwner);
451     }
452 }
453 
454 // File: @openzeppelin/contracts/utils/Address.sol
455 
456 
457 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
458 
459 pragma solidity ^0.8.1;
460 
461 /**
462  * @dev Collection of functions related to the address type
463  */
464 library Address {
465     /**
466      * @dev Returns true if `account` is a contract.
467      *
468      * [IMPORTANT]
469      * ====
470      * It is unsafe to assume that an address for which this function returns
471      * false is an externally-owned account (EOA) and not a contract.
472      *
473      * Among others, `isContract` will return false for the following
474      * types of addresses:
475      *
476      *  - an externally-owned account
477      *  - a contract in construction
478      *  - an address where a contract will be created
479      *  - an address where a contract lived, but was destroyed
480      * ====
481      *
482      * [IMPORTANT]
483      * ====
484      * You shouldn't rely on `isContract` to protect against flash loan attacks!
485      *
486      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
487      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
488      * constructor.
489      * ====
490      */
491     function isContract(address account) internal view returns (bool) {
492         // This method relies on extcodesize/address.code.length, which returns 0
493         // for contracts in construction, since the code is only stored at the end
494         // of the constructor execution.
495 
496         return account.code.length > 0;
497     }
498 
499     /**
500      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
501      * `recipient`, forwarding all available gas and reverting on errors.
502      *
503      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
504      * of certain opcodes, possibly making contracts go over the 2300 gas limit
505      * imposed by `transfer`, making them unable to receive funds via
506      * `transfer`. {sendValue} removes this limitation.
507      *
508      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
509      *
510      * IMPORTANT: because control is transferred to `recipient`, care must be
511      * taken to not create reentrancy vulnerabilities. Consider using
512      * {ReentrancyGuard} or the
513      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
514      */
515     function sendValue(address payable recipient, uint256 amount) internal {
516         require(address(this).balance >= amount, "Address: insufficient balance");
517 
518         (bool success, ) = recipient.call{value: amount}("");
519         require(success, "Address: unable to send value, recipient may have reverted");
520     }
521 
522     /**
523      * @dev Performs a Solidity function call using a low level `call`. A
524      * plain `call` is an unsafe replacement for a function call: use this
525      * function instead.
526      *
527      * If `target` reverts with a revert reason, it is bubbled up by this
528      * function (like regular Solidity function calls).
529      *
530      * Returns the raw returned data. To convert to the expected return value,
531      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
532      *
533      * Requirements:
534      *
535      * - `target` must be a contract.
536      * - calling `target` with `data` must not revert.
537      *
538      * _Available since v3.1._
539      */
540     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
541         return functionCall(target, data, "Address: low-level call failed");
542     }
543 
544     /**
545      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
546      * `errorMessage` as a fallback revert reason when `target` reverts.
547      *
548      * _Available since v3.1._
549      */
550     function functionCall(
551         address target,
552         bytes memory data,
553         string memory errorMessage
554     ) internal returns (bytes memory) {
555         return functionCallWithValue(target, data, 0, errorMessage);
556     }
557 
558     /**
559      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
560      * but also transferring `value` wei to `target`.
561      *
562      * Requirements:
563      *
564      * - the calling contract must have an ETH balance of at least `value`.
565      * - the called Solidity function must be `payable`.
566      *
567      * _Available since v3.1._
568      */
569     function functionCallWithValue(
570         address target,
571         bytes memory data,
572         uint256 value
573     ) internal returns (bytes memory) {
574         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
575     }
576 
577     /**
578      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
579      * with `errorMessage` as a fallback revert reason when `target` reverts.
580      *
581      * _Available since v3.1._
582      */
583     function functionCallWithValue(
584         address target,
585         bytes memory data,
586         uint256 value,
587         string memory errorMessage
588     ) internal returns (bytes memory) {
589         require(address(this).balance >= value, "Address: insufficient balance for call");
590         require(isContract(target), "Address: call to non-contract");
591 
592         (bool success, bytes memory returndata) = target.call{value: value}(data);
593         return verifyCallResult(success, returndata, errorMessage);
594     }
595 
596     /**
597      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
598      * but performing a static call.
599      *
600      * _Available since v3.3._
601      */
602     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
603         return functionStaticCall(target, data, "Address: low-level static call failed");
604     }
605 
606     /**
607      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
608      * but performing a static call.
609      *
610      * _Available since v3.3._
611      */
612     function functionStaticCall(
613         address target,
614         bytes memory data,
615         string memory errorMessage
616     ) internal view returns (bytes memory) {
617         require(isContract(target), "Address: static call to non-contract");
618 
619         (bool success, bytes memory returndata) = target.staticcall(data);
620         return verifyCallResult(success, returndata, errorMessage);
621     }
622 
623     /**
624      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
625      * but performing a delegate call.
626      *
627      * _Available since v3.4._
628      */
629     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
630         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
631     }
632 
633     /**
634      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
635      * but performing a delegate call.
636      *
637      * _Available since v3.4._
638      */
639     function functionDelegateCall(
640         address target,
641         bytes memory data,
642         string memory errorMessage
643     ) internal returns (bytes memory) {
644         require(isContract(target), "Address: delegate call to non-contract");
645 
646         (bool success, bytes memory returndata) = target.delegatecall(data);
647         return verifyCallResult(success, returndata, errorMessage);
648     }
649 
650     /**
651      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
652      * revert reason using the provided one.
653      *
654      * _Available since v4.3._
655      */
656     function verifyCallResult(
657         bool success,
658         bytes memory returndata,
659         string memory errorMessage
660     ) internal pure returns (bytes memory) {
661         if (success) {
662             return returndata;
663         } else {
664             // Look for revert reason and bubble it up if present
665             if (returndata.length > 0) {
666                 // The easiest way to bubble the revert reason is using memory via assembly
667 
668                 assembly {
669                     let returndata_size := mload(returndata)
670                     revert(add(32, returndata), returndata_size)
671                 }
672             } else {
673                 revert(errorMessage);
674             }
675         }
676     }
677 }
678 
679 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
680 
681 
682 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
683 
684 pragma solidity ^0.8.0;
685 
686 /**
687  * @title ERC721 token receiver interface
688  * @dev Interface for any contract that wants to support safeTransfers
689  * from ERC721 asset contracts.
690  */
691 interface IERC721Receiver {
692     /**
693      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
694      * by `operator` from `from`, this function is called.
695      *
696      * It must return its Solidity selector to confirm the token transfer.
697      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
698      *
699      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
700      */
701     function onERC721Received(
702         address operator,
703         address from,
704         uint256 tokenId,
705         bytes calldata data
706     ) external returns (bytes4);
707 }
708 
709 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
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
737 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
738 
739 
740 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
741 
742 pragma solidity ^0.8.0;
743 
744 
745 /**
746  * @dev Implementation of the {IERC165} interface.
747  *
748  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
749  * for the additional interface id that will be supported. For example:
750  *
751  * ```solidity
752  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
753  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
754  * }
755  * ```
756  *
757  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
758  */
759 abstract contract ERC165 is IERC165 {
760     /**
761      * @dev See {IERC165-supportsInterface}.
762      */
763     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
764         return interfaceId == type(IERC165).interfaceId;
765     }
766 }
767 
768 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
769 
770 
771 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
772 
773 pragma solidity ^0.8.0;
774 
775 
776 /**
777  * @dev Required interface of an ERC721 compliant contract.
778  */
779 interface IERC721 is IERC165 {
780     /**
781      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
782      */
783     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
784 
785     /**
786      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
787      */
788     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
789 
790     /**
791      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
792      */
793     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
794 
795     /**
796      * @dev Returns the number of tokens in ``owner``'s account.
797      */
798     function balanceOf(address owner) external view returns (uint256 balance);
799 
800     /**
801      * @dev Returns the owner of the `tokenId` token.
802      *
803      * Requirements:
804      *
805      * - `tokenId` must exist.
806      */
807     function ownerOf(uint256 tokenId) external view returns (address owner);
808 
809     /**
810      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
811      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
812      *
813      * Requirements:
814      *
815      * - `from` cannot be the zero address.
816      * - `to` cannot be the zero address.
817      * - `tokenId` token must exist and be owned by `from`.
818      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
819      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
820      *
821      * Emits a {Transfer} event.
822      */
823     function safeTransferFrom(
824         address from,
825         address to,
826         uint256 tokenId
827     ) external;
828 
829     /**
830      * @dev Transfers `tokenId` token from `from` to `to`.
831      *
832      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
833      *
834      * Requirements:
835      *
836      * - `from` cannot be the zero address.
837      * - `to` cannot be the zero address.
838      * - `tokenId` token must be owned by `from`.
839      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
840      *
841      * Emits a {Transfer} event.
842      */
843     function transferFrom(
844         address from,
845         address to,
846         uint256 tokenId
847     ) external;
848 
849     /**
850      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
851      * The approval is cleared when the token is transferred.
852      *
853      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
854      *
855      * Requirements:
856      *
857      * - The caller must own the token or be an approved operator.
858      * - `tokenId` must exist.
859      *
860      * Emits an {Approval} event.
861      */
862     function approve(address to, uint256 tokenId) external;
863 
864     /**
865      * @dev Returns the account approved for `tokenId` token.
866      *
867      * Requirements:
868      *
869      * - `tokenId` must exist.
870      */
871     function getApproved(uint256 tokenId) external view returns (address operator);
872 
873     /**
874      * @dev Approve or remove `operator` as an operator for the caller.
875      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
876      *
877      * Requirements:
878      *
879      * - The `operator` cannot be the caller.
880      *
881      * Emits an {ApprovalForAll} event.
882      */
883     function setApprovalForAll(address operator, bool _approved) external;
884 
885     /**
886      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
887      *
888      * See {setApprovalForAll}
889      */
890     function isApprovedForAll(address owner, address operator) external view returns (bool);
891 
892     /**
893      * @dev Safely transfers `tokenId` token from `from` to `to`.
894      *
895      * Requirements:
896      *
897      * - `from` cannot be the zero address.
898      * - `to` cannot be the zero address.
899      * - `tokenId` token must exist and be owned by `from`.
900      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
901      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
902      *
903      * Emits a {Transfer} event.
904      */
905     function safeTransferFrom(
906         address from,
907         address to,
908         uint256 tokenId,
909         bytes calldata data
910     ) external;
911 }
912 
913 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
914 
915 
916 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
917 
918 pragma solidity ^0.8.0;
919 
920 
921 /**
922  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
923  * @dev See https://eips.ethereum.org/EIPS/eip-721
924  */
925 interface IERC721Metadata is IERC721 {
926     /**
927      * @dev Returns the token collection name.
928      */
929     function name() external view returns (string memory);
930 
931     /**
932      * @dev Returns the token collection symbol.
933      */
934     function symbol() external view returns (string memory);
935 
936     /**
937      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
938      */
939     function tokenURI(uint256 tokenId) external view returns (string memory);
940 }
941 
942 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
943 
944 
945 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
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
1079         _setApprovalForAll(_msgSender(), operator, approved);
1080     }
1081 
1082     /**
1083      * @dev See {IERC721-isApprovedForAll}.
1084      */
1085     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1086         return _operatorApprovals[owner][operator];
1087     }
1088 
1089     /**
1090      * @dev See {IERC721-transferFrom}.
1091      */
1092     function transferFrom(
1093         address from,
1094         address to,
1095         uint256 tokenId
1096     ) public virtual override {
1097         //solhint-disable-next-line max-line-length
1098         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1099 
1100         _transfer(from, to, tokenId);
1101     }
1102 
1103     /**
1104      * @dev See {IERC721-safeTransferFrom}.
1105      */
1106     function safeTransferFrom(
1107         address from,
1108         address to,
1109         uint256 tokenId
1110     ) public virtual override {
1111         safeTransferFrom(from, to, tokenId, "");
1112     }
1113 
1114     /**
1115      * @dev See {IERC721-safeTransferFrom}.
1116      */
1117     function safeTransferFrom(
1118         address from,
1119         address to,
1120         uint256 tokenId,
1121         bytes memory _data
1122     ) public virtual override {
1123         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1124         _safeTransfer(from, to, tokenId, _data);
1125     }
1126 
1127     /**
1128      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1129      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1130      *
1131      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1132      *
1133      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1134      * implement alternative mechanisms to perform token transfer, such as signature-based.
1135      *
1136      * Requirements:
1137      *
1138      * - `from` cannot be the zero address.
1139      * - `to` cannot be the zero address.
1140      * - `tokenId` token must exist and be owned by `from`.
1141      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1142      *
1143      * Emits a {Transfer} event.
1144      */
1145     function _safeTransfer(
1146         address from,
1147         address to,
1148         uint256 tokenId,
1149         bytes memory _data
1150     ) internal virtual {
1151         _transfer(from, to, tokenId);
1152         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1153     }
1154 
1155     /**
1156      * @dev Returns whether `tokenId` exists.
1157      *
1158      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1159      *
1160      * Tokens start existing when they are minted (`_mint`),
1161      * and stop existing when they are burned (`_burn`).
1162      */
1163     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1164         return _owners[tokenId] != address(0);
1165     }
1166 
1167     /**
1168      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1169      *
1170      * Requirements:
1171      *
1172      * - `tokenId` must exist.
1173      */
1174     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1175         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1176         address owner = ERC721.ownerOf(tokenId);
1177         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1178     }
1179 
1180     /**
1181      * @dev Safely mints `tokenId` and transfers it to `to`.
1182      *
1183      * Requirements:
1184      *
1185      * - `tokenId` must not exist.
1186      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1187      *
1188      * Emits a {Transfer} event.
1189      */
1190     function _safeMint(address to, uint256 tokenId) internal virtual {
1191         _safeMint(to, tokenId, "");
1192     }
1193 
1194     /**
1195      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1196      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1197      */
1198     function _safeMint(
1199         address to,
1200         uint256 tokenId,
1201         bytes memory _data
1202     ) internal virtual {
1203         _mint(to, tokenId);
1204         require(
1205             _checkOnERC721Received(address(0), to, tokenId, _data),
1206             "ERC721: transfer to non ERC721Receiver implementer"
1207         );
1208     }
1209 
1210     /**
1211      * @dev Mints `tokenId` and transfers it to `to`.
1212      *
1213      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1214      *
1215      * Requirements:
1216      *
1217      * - `tokenId` must not exist.
1218      * - `to` cannot be the zero address.
1219      *
1220      * Emits a {Transfer} event.
1221      */
1222     function _mint(address to, uint256 tokenId) internal virtual {
1223         require(to != address(0), "ERC721: mint to the zero address");
1224         require(!_exists(tokenId), "ERC721: token already minted");
1225 
1226         _beforeTokenTransfer(address(0), to, tokenId);
1227 
1228         _balances[to] += 1;
1229         _owners[tokenId] = to;
1230 
1231         emit Transfer(address(0), to, tokenId);
1232 
1233         _afterTokenTransfer(address(0), to, tokenId);
1234     }
1235 
1236     /**
1237      * @dev Destroys `tokenId`.
1238      * The approval is cleared when the token is burned.
1239      *
1240      * Requirements:
1241      *
1242      * - `tokenId` must exist.
1243      *
1244      * Emits a {Transfer} event.
1245      */
1246     function _burn(uint256 tokenId) internal virtual {
1247         address owner = ERC721.ownerOf(tokenId);
1248 
1249         _beforeTokenTransfer(owner, address(0), tokenId);
1250 
1251         // Clear approvals
1252         _approve(address(0), tokenId);
1253 
1254         _balances[owner] -= 1;
1255         delete _owners[tokenId];
1256 
1257         emit Transfer(owner, address(0), tokenId);
1258 
1259         _afterTokenTransfer(owner, address(0), tokenId);
1260     }
1261 
1262     /**
1263      * @dev Transfers `tokenId` from `from` to `to`.
1264      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1265      *
1266      * Requirements:
1267      *
1268      * - `to` cannot be the zero address.
1269      * - `tokenId` token must be owned by `from`.
1270      *
1271      * Emits a {Transfer} event.
1272      */
1273     function _transfer(
1274         address from,
1275         address to,
1276         uint256 tokenId
1277     ) internal virtual {
1278         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1279         require(to != address(0), "ERC721: transfer to the zero address");
1280 
1281         _beforeTokenTransfer(from, to, tokenId);
1282 
1283         // Clear approvals from the previous owner
1284         _approve(address(0), tokenId);
1285 
1286         _balances[from] -= 1;
1287         _balances[to] += 1;
1288         _owners[tokenId] = to;
1289 
1290         emit Transfer(from, to, tokenId);
1291 
1292         _afterTokenTransfer(from, to, tokenId);
1293     }
1294 
1295     /**
1296      * @dev Approve `to` to operate on `tokenId`
1297      *
1298      * Emits a {Approval} event.
1299      */
1300     function _approve(address to, uint256 tokenId) internal virtual {
1301         _tokenApprovals[tokenId] = to;
1302         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1303     }
1304 
1305     /**
1306      * @dev Approve `operator` to operate on all of `owner` tokens
1307      *
1308      * Emits a {ApprovalForAll} event.
1309      */
1310     function _setApprovalForAll(
1311         address owner,
1312         address operator,
1313         bool approved
1314     ) internal virtual {
1315         require(owner != operator, "ERC721: approve to caller");
1316         _operatorApprovals[owner][operator] = approved;
1317         emit ApprovalForAll(owner, operator, approved);
1318     }
1319 
1320     /**
1321      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1322      * The call is not executed if the target address is not a contract.
1323      *
1324      * @param from address representing the previous owner of the given token ID
1325      * @param to target address that will receive the tokens
1326      * @param tokenId uint256 ID of the token to be transferred
1327      * @param _data bytes optional data to send along with the call
1328      * @return bool whether the call correctly returned the expected magic value
1329      */
1330     function _checkOnERC721Received(
1331         address from,
1332         address to,
1333         uint256 tokenId,
1334         bytes memory _data
1335     ) private returns (bool) {
1336         if (to.isContract()) {
1337             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1338                 return retval == IERC721Receiver.onERC721Received.selector;
1339             } catch (bytes memory reason) {
1340                 if (reason.length == 0) {
1341                     revert("ERC721: transfer to non ERC721Receiver implementer");
1342                 } else {
1343                     assembly {
1344                         revert(add(32, reason), mload(reason))
1345                     }
1346                 }
1347             }
1348         } else {
1349             return true;
1350         }
1351     }
1352 
1353     /**
1354      * @dev Hook that is called before any token transfer. This includes minting
1355      * and burning.
1356      *
1357      * Calling conditions:
1358      *
1359      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1360      * transferred to `to`.
1361      * - When `from` is zero, `tokenId` will be minted for `to`.
1362      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1363      * - `from` and `to` are never both zero.
1364      *
1365      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1366      */
1367     function _beforeTokenTransfer(
1368         address from,
1369         address to,
1370         uint256 tokenId
1371     ) internal virtual {}
1372 
1373     /**
1374      * @dev Hook that is called after any transfer of tokens. This includes
1375      * minting and burning.
1376      *
1377      * Calling conditions:
1378      *
1379      * - when `from` and `to` are both non-zero.
1380      * - `from` and `to` are never both zero.
1381      *
1382      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1383      */
1384     function _afterTokenTransfer(
1385         address from,
1386         address to,
1387         uint256 tokenId
1388     ) internal virtual {}
1389 }
1390 
1391 // File: contracts/NA/NaftyAngels.sol
1392 
1393 //SPDX-License-Identifier: UNLICENSED
1394 pragma solidity ^0.8.0;
1395 
1396 
1397 
1398 
1399 
1400 contract NaftyAngels is ERC721, Ownable {
1401     using Strings for uint256;
1402     using ECDSA for bytes32;
1403 
1404     uint256 public MAX_EXCLUSIVE = 696;
1405     uint256 public MAX_PRESALE = 1500;
1406     
1407     uint256 public maxSupply = 6969;
1408     uint256 public currentSupply = 0;
1409 
1410     uint256 public salePrice = 0.02 ether;
1411     uint256 public presalePrice = 0.015 ether;
1412     uint256 public exclusivePrice = 0.01 ether;
1413 
1414     uint256 public presaleCount;
1415     uint256 public exclusiveCount;
1416 
1417     uint256 private freeMinted;
1418 
1419     //Placeholders
1420     address private presaleAddress = address(0x4b296B40eED802E41447E79DD207ECa7844EA146);
1421     address private exclusiveAddress = address(0x06ebcDBEc10EcB8731F46185Af236bAaD620dAfB);
1422     address private wallet = address(0x9C86fC37EB0054f38D29C44Ba374E6e712e40F9f);
1423 
1424     string private baseURI;
1425     string private notRevealedUri = "ipfs://QmPLmJsniAS8BqJoqqy4eUU7cy8KyoqdGys19nfQy3nkdU";
1426 
1427     bool public revealed = false;
1428     bool public baseLocked = false;
1429 
1430     enum WorkflowStatus {
1431         Before,
1432         Exclusive,
1433         Presale,
1434         Sale,
1435         Paused,
1436         Reveal
1437     }
1438 
1439     WorkflowStatus public workflow;
1440 
1441     mapping(address => uint256) public freeMintAccess;
1442     mapping(address => uint256) public freeMintLog;
1443 
1444     constructor()
1445         ERC721("Nafty Angels", "NAFTY")
1446     {
1447         transferOwnership(msg.sender);
1448         workflow = WorkflowStatus.Before;
1449     }
1450 
1451     function withdraw() public onlyOwner {
1452         uint256 _balance = address( this ).balance;
1453         
1454         payable( wallet ).transfer( _balance );
1455     }
1456 
1457     //GETTERS
1458     function getSaleStatus() public view returns (WorkflowStatus) {
1459         return workflow;
1460     }
1461 
1462     function totalSupply() public view returns (uint256) {
1463         return currentSupply;
1464     }
1465 
1466     function getFreeMintAmount( address _acc ) public view returns (uint256) {
1467         return freeMintAccess[ _acc ];
1468     }
1469 
1470     function getFreeMintLog( address _acc ) public view returns (uint256) {
1471         return freeMintLog[ _acc ];
1472     }
1473 
1474     function validateSignature( address _addr, bytes memory _s ) internal view returns (bool){
1475         bytes32 messageHash = keccak256(
1476             abi.encodePacked( address(this), msg.sender)
1477         );
1478 
1479         address signer = messageHash.toEthSignedMessageHash().recover(_s);
1480 
1481         if( _addr == signer ) {
1482             return true;
1483         } else {
1484             return false;
1485         }
1486     }
1487 
1488     //Batch minting
1489     function mintBatch(
1490         address to,
1491         uint256 baseId,
1492         uint256 number
1493     ) internal {
1494 
1495         for (uint256 i = 0; i < number; i++) {
1496             _safeMint(to, baseId + i);
1497         }
1498 
1499     }
1500 
1501     /**
1502         Claims tokens for free paying only gas fees
1503      */
1504     function freeMint(uint256 _amount) external {
1505         uint256 supply = currentSupply;
1506 
1507         require( 
1508           freeMintAccess[ msg.sender ] >= _amount, 
1509           "You dont have permision to free mint that amount." 
1510         );
1511 
1512         require(
1513             supply + _amount <= maxSupply,
1514             "NaftyAngels: Mint too large, exceeding the maxSupply"
1515         );
1516 
1517         freeMintAccess[ msg.sender ] -= _amount;
1518         freeMintLog[ msg.sender ] += _amount;
1519 
1520         freeMinted += _amount;
1521         currentSupply += _amount;
1522 
1523         mintBatch(msg.sender, supply, _amount);
1524     }
1525 
1526     //Exclusive presale minting
1527     function exclusiveMint(
1528         uint256 amount,
1529         bytes calldata signature
1530     ) external payable {
1531         
1532         require(amount > 0, "You must mint at least one token");
1533 
1534         require(
1535             workflow == WorkflowStatus.Exclusive,
1536             "NaftyAngels: Exclusive presale has not been started yet!"
1537         );
1538 
1539         require(
1540             validateSignature(
1541                 exclusiveAddress,
1542                 signature
1543             ),
1544             "SIGNATURE_VALIDATION_FAILED"
1545         );
1546         
1547         require(
1548             exclusiveCount + amount <= MAX_EXCLUSIVE,
1549             "NaftyAngels: Selected amount exceeds the max exclusive presale supply."
1550         );
1551 
1552         require(
1553             msg.value >= exclusivePrice * amount,
1554             "NaftyAngels: Insuficient ETH amount sent."
1555         );
1556 
1557         exclusiveCount += amount;
1558         currentSupply  += amount;
1559  
1560         mintBatch(msg.sender, currentSupply - amount, amount);
1561     }
1562 
1563     function presaleMint(
1564         uint256 amount,
1565         bytes calldata signature
1566     ) external payable {
1567         
1568         require(amount > 0, "You must mint at least one token");
1569 
1570         require(
1571             validateSignature(
1572                 presaleAddress,
1573                 signature
1574             ),
1575             "SIGNATURE_VALIDATION_FAILED"
1576         );
1577         
1578         require(
1579             workflow == WorkflowStatus.Presale,
1580             "NaftyAngels: Presale has not started yet!"
1581         );
1582         
1583         require(
1584             presaleCount + amount <= MAX_PRESALE,
1585             "NaftyAngels: Selected amount exceeds the max presale supply"
1586         );
1587 
1588         require(
1589             msg.value >= presalePrice * amount,
1590             "NaftyAngels: Insuficient ETH amount sent."
1591         );
1592 
1593         presaleCount += amount;
1594         currentSupply += amount;
1595 
1596         mintBatch(msg.sender, currentSupply - amount, amount);
1597     }
1598 
1599     function publicSaleMint(uint256 amount) external payable {
1600         require( amount > 0, "You must mint at least one NFT.");
1601         
1602         uint256 supply = currentSupply;
1603 
1604         require( supply < maxSupply, "NaftyAngels: Sold out!" );
1605         require( supply + amount <= maxSupply, "NaftyAngels: Selected amount exceeds the max supply.");
1606 
1607         require(
1608             workflow == WorkflowStatus.Sale,
1609             "NaftyAngels: Public sale has not started yet."
1610         );
1611 
1612         require(
1613             msg.value >= salePrice * amount,
1614             "NaftyAngels: Insuficient ETH amount sent."
1615         );
1616 
1617         currentSupply += amount;
1618 
1619         mintBatch(msg.sender, supply, amount);
1620     }
1621 
1622     function forceMint(uint256 number, address receiver) external onlyOwner {
1623         uint256 supply = currentSupply;
1624 
1625         require(
1626             supply + number <= maxSupply,
1627             "NaftyAngels: You can't mint more than max supply"
1628         );
1629 
1630         currentSupply += number;
1631 
1632         mintBatch( receiver, supply, number);
1633     }
1634 
1635     function ownerMint(uint256 number) external onlyOwner {
1636         uint256 supply = currentSupply;
1637 
1638         require(
1639             supply + number <= maxSupply,
1640             "NaftyAngels: You can't mint more than max supply"
1641         );
1642 
1643         currentSupply += number;
1644 
1645         mintBatch(msg.sender, supply, number);
1646     }
1647 
1648     function airdrop(address[] calldata addresses) external onlyOwner {
1649         uint256 supply = currentSupply;
1650         require(
1651             supply + addresses.length <= maxSupply,
1652             "NaftyAngels: You can't mint more than max supply"
1653         );
1654 
1655         currentSupply += addresses.length;
1656 
1657         for (uint256 i = 0; i < addresses.length; i++) {
1658             _safeMint(addresses[i], supply + i);
1659         }
1660     }
1661 
1662     // END MINT FUNCTIONS
1663     function getFreeMinted() public view onlyOwner returns (uint256){
1664         return freeMinted;
1665     }
1666 
1667     function setUpBefore() external onlyOwner {
1668         workflow = WorkflowStatus.Before;
1669     }
1670 
1671     function setUpExclusive() external onlyOwner {
1672         workflow = WorkflowStatus.Exclusive;
1673     }
1674 
1675     function setUpPresale() external onlyOwner {
1676         workflow = WorkflowStatus.Presale;
1677     }
1678 
1679     function setUpSale() external onlyOwner {
1680         workflow = WorkflowStatus.Sale;
1681     }
1682 
1683     function pauseSale() external onlyOwner {
1684         workflow = WorkflowStatus.Paused;
1685     }
1686 
1687     function setMaxExclusive( uint256 _amount ) external onlyOwner {
1688         MAX_EXCLUSIVE = _amount;
1689     }
1690 
1691     function setMaxPresale( uint256 _amount ) external onlyOwner {
1692         MAX_PRESALE = _amount;
1693     }
1694 
1695     function reveal() public onlyOwner {
1696         revealed = true;
1697     }
1698 
1699     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1700         notRevealedUri = _notRevealedURI;
1701     }
1702 
1703     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1704         require( baseLocked == false, "Base URI change has been disabled permanently");
1705 
1706         baseURI = _newBaseURI;
1707     }
1708 
1709     function setPresaleAddress(address _newAddress) public onlyOwner {
1710         require(_newAddress != address(0), "CAN'T PUT 0 ADDRESS");
1711         presaleAddress = _newAddress;
1712     }
1713 
1714     function setExclusiveAddress(address _newAddress) public onlyOwner {
1715         require(_newAddress != address(0), "CAN'T PUT 0 ADDRESS");
1716         exclusiveAddress = _newAddress;
1717     }
1718 
1719     function setWallet(address _newWallet) public onlyOwner {
1720         wallet = _newWallet;
1721     }
1722 
1723     function setSalePrice(uint256 _newPrice) public onlyOwner {
1724         salePrice = _newPrice;
1725     }
1726 
1727     function setPresalePrice(uint256 _newPrice) public onlyOwner {
1728         presalePrice = _newPrice;
1729     }
1730 
1731     function setFreeMintAccess(address _acc, uint256 _am ) public onlyOwner {
1732         freeMintAccess[ _acc ] = _am;
1733     }
1734 
1735     function setExclusivePrice(uint256 _newPrice) public onlyOwner {
1736         exclusivePrice = _newPrice;
1737     }
1738 
1739     function lockBase() public onlyOwner {
1740         baseLocked = true;
1741     }
1742 
1743     // FACTORY
1744     function tokenURI(uint256 tokenId)
1745         public
1746         view
1747         override(ERC721)
1748         returns (string memory)
1749     {
1750         if (revealed == false) {
1751             return notRevealedUri;
1752         }
1753 
1754         string memory currentBaseURI = baseURI;
1755         return
1756             bytes(currentBaseURI).length > 0
1757                 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(),'.json'))
1758                 : "";
1759     }
1760 }