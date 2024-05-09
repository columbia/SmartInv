1 /**
2  *Submitted for verification at Etherscan.io on 2022-07-04
3 */
4 
5 ////     _____   _____   __   _   ______      ___   _____    _____   _           ___   _____     ////
6 ////    /  ___| | ____| |  \ | | |___  /     /   | |  _  \  |_   _| | |         /   | |  _  \    ////
7 ////    | |     | |__   |   \| |    / /     / /| | | |_| |    | |   | |        / /| | | |_| |    ////
8 ////    | |  _  |  __|  | |\   |   / /     / / | | |  _  /    | |   | |       / / | | |  _  {    ////
9 ////    | |_| | | |___  | | \  |  / /__   / /  | | | | \ \    | |   | |___   / /  | | | |_| |    ////
10 ////    \_____/ |_____| |_|  \_| /_____| /_/   |_| |_|  \_\   |_|   |_____| /_/   |_| |_____/    ////
11 
12 // SPDX-License-Identifier: MIT
13 
14 pragma solidity ^0.8.0;
15 
16 /**
17  * @dev String operations.
18  */
19 library Strings {
20     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
21 
22     /**
23      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
24      */
25     function toString(uint256 value) internal pure returns (string memory) {
26         // Inspired by OraclizeAPI's implementation - MIT licence
27         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
28 
29         if (value == 0) {
30             return "0";
31         }
32         uint256 temp = value;
33         uint256 digits;
34         while (temp != 0) {
35             digits++;
36             temp /= 10;
37         }
38         bytes memory buffer = new bytes(digits);
39         while (value != 0) {
40             digits -= 1;
41             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
42             value /= 10;
43         }
44         return string(buffer);
45     }
46 
47     /**
48      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
49      */
50     function toHexString(uint256 value) internal pure returns (string memory) {
51         if (value == 0) {
52             return "0x00";
53         }
54         uint256 temp = value;
55         uint256 length = 0;
56         while (temp != 0) {
57             length++;
58             temp >>= 8;
59         }
60         return toHexString(value, length);
61     }
62 
63     /**
64      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
65      */
66     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
67         bytes memory buffer = new bytes(2 * length + 2);
68         buffer[0] = "0";
69         buffer[1] = "x";
70         for (uint256 i = 2 * length + 1; i > 1; --i) {
71             buffer[i] = _HEX_SYMBOLS[value & 0xf];
72             value >>= 4;
73         }
74         require(value == 0, "Strings: hex length insufficient");
75         return string(buffer);
76     }
77 }
78 // File: ECDSA.sol
79 
80 
81 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
82 
83 pragma solidity ^0.8.0;
84 
85 
86 /**
87  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
88  *
89  * These functions can be used to verify that a message was signed by the holder
90  * of the private keys of a given address.
91  */
92 library ECDSA {
93     enum RecoverError {
94         NoError,
95         InvalidSignature,
96         InvalidSignatureLength,
97         InvalidSignatureS,
98         InvalidSignatureV
99     }
100 
101     function _throwError(RecoverError error) private pure {
102         if (error == RecoverError.NoError) {
103             return; // no error: do nothing
104         } else if (error == RecoverError.InvalidSignature) {
105             revert("ECDSA: invalid signature");
106         } else if (error == RecoverError.InvalidSignatureLength) {
107             revert("ECDSA: invalid signature length");
108         } else if (error == RecoverError.InvalidSignatureS) {
109             revert("ECDSA: invalid signature 's' value");
110         } else if (error == RecoverError.InvalidSignatureV) {
111             revert("ECDSA: invalid signature 'v' value");
112         }
113     }
114 
115     /**
116      * @dev Returns the address that signed a hashed message (`hash`) with
117      * `signature` or error string. This address can then be used for verification purposes.
118      *
119      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
120      * this function rejects them by requiring the `s` value to be in the lower
121      * half order, and the `v` value to be either 27 or 28.
122      *
123      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
124      * verification to be secure: it is possible to craft signatures that
125      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
126      * this is by receiving a hash of the original message (which may otherwise
127      * be too long), and then calling {toEthSignedMessageHash} on it.
128      *
129      * Documentation for signature generation:
130      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
131      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
132      *
133      * _Available since v4.3._
134      */
135     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
136         // Check the signature length
137         // - case 65: r,s,v signature (standard)
138         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
139         if (signature.length == 65) {
140             bytes32 r;
141             bytes32 s;
142             uint8 v;
143             // ecrecover takes the signature parameters, and the only way to get them
144             // currently is to use assembly.
145             assembly {
146                 r := mload(add(signature, 0x20))
147                 s := mload(add(signature, 0x40))
148                 v := byte(0, mload(add(signature, 0x60)))
149             }
150             return tryRecover(hash, v, r, s);
151         } else if (signature.length == 64) {
152             bytes32 r;
153             bytes32 vs;
154             // ecrecover takes the signature parameters, and the only way to get them
155             // currently is to use assembly.
156             assembly {
157                 r := mload(add(signature, 0x20))
158                 vs := mload(add(signature, 0x40))
159             }
160             return tryRecover(hash, r, vs);
161         } else {
162             return (address(0), RecoverError.InvalidSignatureLength);
163         }
164     }
165 
166     /**
167      * @dev Returns the address that signed a hashed message (`hash`) with
168      * `signature`. This address can then be used for verification purposes.
169      *
170      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
171      * this function rejects them by requiring the `s` value to be in the lower
172      * half order, and the `v` value to be either 27 or 28.
173      *
174      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
175      * verification to be secure: it is possible to craft signatures that
176      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
177      * this is by receiving a hash of the original message (which may otherwise
178      * be too long), and then calling {toEthSignedMessageHash} on it.
179      */
180     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
181         (address recovered, RecoverError error) = tryRecover(hash, signature);
182         _throwError(error);
183         return recovered;
184     }
185 
186     /**
187      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
188      *
189      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
190      *
191      * _Available since v4.3._
192      */
193     function tryRecover(
194         bytes32 hash,
195         bytes32 r,
196         bytes32 vs
197     ) internal pure returns (address, RecoverError) {
198         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
199         uint8 v = uint8((uint256(vs) >> 255) + 27);
200         return tryRecover(hash, v, r, s);
201     }
202 
203     /**
204      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
205      *
206      * _Available since v4.2._
207      */
208     function recover(
209         bytes32 hash,
210         bytes32 r,
211         bytes32 vs
212     ) internal pure returns (address) {
213         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
214         _throwError(error);
215         return recovered;
216     }
217 
218     /**
219      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
220      * `r` and `s` signature fields separately.
221      *
222      * _Available since v4.3._
223      */
224     function tryRecover(
225         bytes32 hash,
226         uint8 v,
227         bytes32 r,
228         bytes32 s
229     ) internal pure returns (address, RecoverError) {
230         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
231         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
232         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
233         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
234         //
235         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
236         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
237         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
238         // these malleable signatures as well.
239         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
240             return (address(0), RecoverError.InvalidSignatureS);
241         }
242         if (v != 27 && v != 28) {
243             return (address(0), RecoverError.InvalidSignatureV);
244         }
245 
246         // If the signature is valid (and not malleable), return the signer address
247         address signer = ecrecover(hash, v, r, s);
248         if (signer == address(0)) {
249             return (address(0), RecoverError.InvalidSignature);
250         }
251 
252         return (signer, RecoverError.NoError);
253     }
254 
255     /**
256      * @dev Overload of {ECDSA-recover} that receives the `v`,
257      * `r` and `s` signature fields separately.
258      */
259     function recover(
260         bytes32 hash,
261         uint8 v,
262         bytes32 r,
263         bytes32 s
264     ) internal pure returns (address) {
265         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
266         _throwError(error);
267         return recovered;
268     }
269 
270     /**
271      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
272      * produces hash corresponding to the one signed with the
273      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
274      * JSON-RPC method as part of EIP-191.
275      *
276      * See {recover}.
277      */
278     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
279         // 32 is the length in bytes of hash,
280         // enforced by the type signature above
281         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
282     }
283 
284     /**
285      * @dev Returns an Ethereum Signed Message, created from `s`. This
286      * produces hash corresponding to the one signed with the
287      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
288      * JSON-RPC method as part of EIP-191.
289      *
290      * See {recover}.
291      */
292     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
293         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
294     }
295 
296     /**
297      * @dev Returns an Ethereum Signed Typed Data, created from a
298      * `domainSeparator` and a `structHash`. This produces hash corresponding
299      * to the one signed with the
300      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
301      * JSON-RPC method as part of EIP-712.
302      *
303      * See {recover}.
304      */
305     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
306         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
307     }
308 }
309 // File: Context.sol
310 
311 
312 
313 pragma solidity ^0.8.0;
314 
315 /**
316  * @dev Provides information about the current execution context, including the
317  * sender of the transaction and its data. While these are generally available
318  * via msg.sender and msg.data, they should not be accessed in such a direct
319  * manner, since when dealing with meta-transactions the account sending and
320  * paying for execution may not be the actual sender (as far as an application
321  * is concerned).
322  *
323  * This contract is only required for intermediate, library-like contracts.
324  */
325 abstract contract Context {
326     function _msgSender() internal view virtual returns (address) {
327         return msg.sender;
328     }
329 
330     function _msgData() internal view virtual returns (bytes calldata) {
331         return msg.data;
332     }
333 }
334 // File: Ownable.sol
335 
336 
337 
338 pragma solidity ^0.8.0;
339 
340 
341 /**
342  * @dev Contract module which provides a basic access control mechanism, where
343  * there is an account (an owner) that can be granted exclusive access to
344  * specific functions.
345  *
346  * By default, the owner account will be the one that deploys the contract. This
347  * can later be changed with {transferOwnership}.
348  *
349  * This module is used through inheritance. It will make available the modifier
350  * `onlyOwner`, which can be applied to your functions to restrict their use to
351  * the owner.
352  */
353 abstract contract Ownable is Context {
354     address private _owner;
355 
356     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
357 
358     /**
359      * @dev Initializes the contract setting the deployer as the initial owner.
360      */
361     constructor() {
362         _setOwner(_msgSender());
363     }
364 
365     /**
366      * @dev Returns the address of the current owner.
367      */
368     function owner() public view virtual returns (address) {
369         return _owner;
370     }
371 
372     /**
373      * @dev Throws if called by any account other than the owner.
374      */
375     modifier onlyOwner() {
376         require(owner() == _msgSender(), "Ownable: caller is not the owner");
377         _;
378     }
379 
380     /**
381      * @dev Leaves the contract without owner. It will not be possible to call
382      * `onlyOwner` functions anymore. Can only be called by the current owner.
383      *
384      * NOTE: Renouncing ownership will leave the contract without an owner,
385      * thereby removing any functionality that is only available to the owner.
386      */
387     function renounceOwnership() public virtual onlyOwner {
388         _setOwner(address(0));
389     }
390 
391     /**
392      * @dev Transfers ownership of the contract to a new account (`newOwner`).
393      * Can only be called by the current owner.
394      */
395     function transferOwnership(address newOwner) public virtual onlyOwner {
396         require(newOwner != address(0), "Ownable: new owner is the zero address");
397         _setOwner(newOwner);
398     }
399 
400     function _setOwner(address newOwner) private {
401         address oldOwner = _owner;
402         _owner = newOwner;
403         emit OwnershipTransferred(oldOwner, newOwner);
404     }
405 }
406 // File: Address.sol
407 
408 
409 
410 pragma solidity ^0.8.0;
411 
412 /**
413  * @dev Collection of functions related to the address type
414  */
415 library Address {
416     /**
417      * @dev Returns true if `account` is a contract.
418      *
419      * [IMPORTANT]
420      * ====
421      * It is unsafe to assume that an address for which this function returns
422      * false is an externally-owned account (EOA) and not a contract.
423      *
424      * Among others, `isContract` will return false for the following
425      * types of addresses:
426      *
427      *  - an externally-owned account
428      *  - a contract in construction
429      *  - an address where a contract will be created
430      *  - an address where a contract lived, but was destroyed
431      * ====
432      */
433     function isContract(address account) internal view returns (bool) {
434         // This method relies on extcodesize, which returns 0 for contracts in
435         // construction, since the code is only stored at the end of the
436         // constructor execution.
437 
438         uint256 size;
439         assembly {
440             size := extcodesize(account)
441         }
442         return size > 0;
443     }
444 
445     /**
446      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
447      * `recipient`, forwarding all available gas and reverting on errors.
448      *
449      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
450      * of certain opcodes, possibly making contracts go over the 2300 gas limit
451      * imposed by `transfer`, making them unable to receive funds via
452      * `transfer`. {sendValue} removes this limitation.
453      *
454      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
455      *
456      * IMPORTANT: because control is transferred to `recipient`, care must be
457      * taken to not create reentrancy vulnerabilities. Consider using
458      * {ReentrancyGuard} or the
459      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
460      */
461     function sendValue(address payable recipient, uint256 amount) internal {
462         require(address(this).balance >= amount, "Address: insufficient balance");
463 
464         (bool success, ) = recipient.call{value: amount}("");
465         require(success, "Address: unable to send value, recipient may have reverted");
466     }
467 
468     /**
469      * @dev Performs a Solidity function call using a low level `call`. A
470      * plain `call` is an unsafe replacement for a function call: use this
471      * function instead.
472      *
473      * If `target` reverts with a revert reason, it is bubbled up by this
474      * function (like regular Solidity function calls).
475      *
476      * Returns the raw returned data. To convert to the expected return value,
477      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
478      *
479      * Requirements:
480      *
481      * - `target` must be a contract.
482      * - calling `target` with `data` must not revert.
483      *
484      * _Available since v3.1._
485      */
486     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
487         return functionCall(target, data, "Address: low-level call failed");
488     }
489 
490     /**
491      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
492      * `errorMessage` as a fallback revert reason when `target` reverts.
493      *
494      * _Available since v3.1._
495      */
496     function functionCall(
497         address target,
498         bytes memory data,
499         string memory errorMessage
500     ) internal returns (bytes memory) {
501         return functionCallWithValue(target, data, 0, errorMessage);
502     }
503 
504     /**
505      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
506      * but also transferring `value` wei to `target`.
507      *
508      * Requirements:
509      *
510      * - the calling contract must have an ETH balance of at least `value`.
511      * - the called Solidity function must be `payable`.
512      *
513      * _Available since v3.1._
514      */
515     function functionCallWithValue(
516         address target,
517         bytes memory data,
518         uint256 value
519     ) internal returns (bytes memory) {
520         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
521     }
522 
523     /**
524      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
525      * with `errorMessage` as a fallback revert reason when `target` reverts.
526      *
527      * _Available since v3.1._
528      */
529     function functionCallWithValue(
530         address target,
531         bytes memory data,
532         uint256 value,
533         string memory errorMessage
534     ) internal returns (bytes memory) {
535         require(address(this).balance >= value, "Address: insufficient balance for call");
536         require(isContract(target), "Address: call to non-contract");
537 
538         (bool success, bytes memory returndata) = target.call{value: value}(data);
539         return _verifyCallResult(success, returndata, errorMessage);
540     }
541 
542     /**
543      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
544      * but performing a static call.
545      *
546      * _Available since v3.3._
547      */
548     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
549         return functionStaticCall(target, data, "Address: low-level static call failed");
550     }
551 
552     /**
553      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
554      * but performing a static call.
555      *
556      * _Available since v3.3._
557      */
558     function functionStaticCall(
559         address target,
560         bytes memory data,
561         string memory errorMessage
562     ) internal view returns (bytes memory) {
563         require(isContract(target), "Address: static call to non-contract");
564 
565         (bool success, bytes memory returndata) = target.staticcall(data);
566         return _verifyCallResult(success, returndata, errorMessage);
567     }
568 
569     /**
570      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
571      * but performing a delegate call.
572      *
573      * _Available since v3.4._
574      */
575     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
576         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
577     }
578 
579     /**
580      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
581      * but performing a delegate call.
582      *
583      * _Available since v3.4._
584      */
585     function functionDelegateCall(
586         address target,
587         bytes memory data,
588         string memory errorMessage
589     ) internal returns (bytes memory) {
590         require(isContract(target), "Address: delegate call to non-contract");
591 
592         (bool success, bytes memory returndata) = target.delegatecall(data);
593         return _verifyCallResult(success, returndata, errorMessage);
594     }
595 
596     function _verifyCallResult(
597         bool success,
598         bytes memory returndata,
599         string memory errorMessage
600     ) private pure returns (bytes memory) {
601         if (success) {
602             return returndata;
603         } else {
604             // Look for revert reason and bubble it up if present
605             if (returndata.length > 0) {
606                 // The easiest way to bubble the revert reason is using memory via assembly
607 
608                 assembly {
609                     let returndata_size := mload(returndata)
610                     revert(add(32, returndata), returndata_size)
611                 }
612             } else {
613                 revert(errorMessage);
614             }
615         }
616     }
617 }
618 // File: Payment.sol
619 
620 
621 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
622 
623 pragma solidity ^0.8.0;
624 
625 
626 
627 /**
628  * @title PaymentSplitter
629  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
630  * that the Ether will be split in this way, since it is handled transparently by the contract.
631  *
632  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
633  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
634  * an amount proportional to the percentage of total shares they were assigned.
635  *
636  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
637  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
638  * function.
639  *
640  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
641  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
642  * to run tests before sending real value to this contract.
643  */
644 contract Payment is Context {
645     event PayeeAdded(address account, uint256 shares);
646     event PaymentReleased(address to, uint256 amount);
647     event PaymentReceived(address from, uint256 amount);
648 
649     uint256 private _totalShares;
650     uint256 private _totalReleased;
651 
652     mapping(address => uint256) private _shares;
653     mapping(address => uint256) private _released;
654     address[] private _payees;
655 
656     /**
657      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
658      * the matching position in the `shares` array.
659      *
660      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
661      * duplicates in `payees`.
662      */
663     constructor(address[] memory payees, uint256[] memory shares_) payable {
664         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
665         require(payees.length > 0, "PaymentSplitter: no payees");
666 
667         for (uint256 i = 0; i < payees.length; i++) {
668             _addPayee(payees[i], shares_[i]);
669         }
670     }
671 
672     /**
673      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
674      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
675      * reliability of the events, and not the actual splitting of Ether.
676      *
677      * To learn more about this see the Solidity documentation for
678      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
679      * functions].
680      */
681     receive() external payable virtual {
682         emit PaymentReceived(_msgSender(), msg.value);
683     }
684 
685     /**
686      * @dev Getter for the total shares held by payees.
687      */
688     function totalShares() public view returns (uint256) {
689         return _totalShares;
690     }
691 
692     /**
693      * @dev Getter for the total amount of Ether already released.
694      */
695     function totalReleased() public view returns (uint256) {
696         return _totalReleased;
697     }
698 
699 
700     /**
701      * @dev Getter for the amount of shares held by an account.
702      */
703     function shares(address account) public view returns (uint256) {
704         return _shares[account];
705     }
706 
707     /**
708      * @dev Getter for the amount of Ether already released to a payee.
709      */
710     function released(address account) public view returns (uint256) {
711         return _released[account];
712     }
713 
714 
715     /**
716      * @dev Getter for the address of the payee number `index`.
717      */
718     function payee(uint256 index) public view returns (address) {
719         return _payees[index];
720     }
721 
722     /**
723      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
724      * total shares and their previous withdrawals.
725      */
726     function release(address payable account) public virtual {
727         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
728 
729         uint256 totalReceived = address(this).balance + totalReleased();
730         uint256 payment = _pendingPayment(account, totalReceived, released(account));
731 
732         require(payment != 0, "PaymentSplitter: account is not due payment");
733 
734         _released[account] += payment;
735         _totalReleased += payment;
736 
737         Address.sendValue(account, payment);
738         emit PaymentReleased(account, payment);
739     }
740 
741 
742     /**
743      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
744      * already released amounts.
745      */
746     function _pendingPayment(
747         address account,
748         uint256 totalReceived,
749         uint256 alreadyReleased
750     ) private view returns (uint256) {
751         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
752     }
753 
754     /**
755      * @dev Add a new payee to the contract.
756      * @param account The address of the payee to add.
757      * @param shares_ The number of shares owned by the payee.
758      */
759     function _addPayee(address account, uint256 shares_) private {
760         require(account != address(0), "PaymentSplitter: account is the zero address");
761         require(shares_ > 0, "PaymentSplitter: shares are 0");
762         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
763 
764         _payees.push(account);
765         _shares[account] = shares_;
766         _totalShares = _totalShares + shares_;
767         emit PayeeAdded(account, shares_);
768     }
769 }
770 // File: IERC721Receiver.sol
771 
772 
773 
774 pragma solidity ^0.8.0;
775 
776 /**
777  * @title ERC721 token receiver interface
778  * @dev Interface for any contract that wants to support safeTransfers
779  * from ERC721 asset contracts.
780  */
781 interface IERC721Receiver {
782     /**
783      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
784      * by `operator` from `from`, this function is called.
785      *
786      * It must return its Solidity selector to confirm the token transfer.
787      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
788      *
789      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
790      */
791     function onERC721Received(
792         address operator,
793         address from,
794         uint256 tokenId,
795         bytes calldata data
796     ) external returns (bytes4);
797 }
798 // File: IERC165.sol
799 
800 
801 
802 pragma solidity ^0.8.0;
803 
804 /**
805  * @dev Interface of the ERC165 standard, as defined in the
806  * https://eips.ethereum.org/EIPS/eip-165[EIP].
807  *
808  * Implementers can declare support of contract interfaces, which can then be
809  * queried by others ({ERC165Checker}).
810  *
811  * For an implementation, see {ERC165}.
812  */
813 interface IERC165 {
814     /**
815      * @dev Returns true if this contract implements the interface defined by
816      * `interfaceId`. See the corresponding
817      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
818      * to learn more about how these ids are created.
819      *
820      * This function call must use less than 30 000 gas.
821      */
822     function supportsInterface(bytes4 interfaceId) external view returns (bool);
823 }
824 // File: ERC165.sol
825 
826 
827 
828 pragma solidity ^0.8.0;
829 
830 
831 /**
832  * @dev Implementation of the {IERC165} interface.
833  *
834  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
835  * for the additional interface id that will be supported. For example:
836  *
837  * ```solidity
838  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
839  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
840  * }
841  * ```
842  *
843  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
844  */
845 abstract contract ERC165 is IERC165 {
846     /**
847      * @dev See {IERC165-supportsInterface}.
848      */
849     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
850         return interfaceId == type(IERC165).interfaceId;
851     }
852 }
853 // File: IERC721.sol
854 
855 
856 
857 pragma solidity ^0.8.0;
858 
859 
860 /**
861  * @dev Required interface of an ERC721 compliant contract.
862  */
863 interface IERC721 is IERC165 {
864     /**
865      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
866      */
867     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
868 
869     /**
870      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
871      */
872     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
873 
874     /**
875      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
876      */
877     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
878 
879     /**
880      * @dev Returns the number of tokens in ``owner``'s account.
881      */
882     function balanceOf(address owner) external view returns (uint256 balance);
883 
884     /**
885      * @dev Returns the owner of the `tokenId` token.
886      *
887      * Requirements:
888      *
889      * - `tokenId` must exist.
890      */
891     function ownerOf(uint256 tokenId) external view returns (address owner);
892 
893     /**
894      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
895      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
896      *
897      * Requirements:
898      *
899      * - `from` cannot be the zero address.
900      * - `to` cannot be the zero address.
901      * - `tokenId` token must exist and be owned by `from`.
902      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
903      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
904      *
905      * Emits a {Transfer} event.
906      */
907     function safeTransferFrom(
908         address from,
909         address to,
910         uint256 tokenId
911     ) external;
912 
913     /**
914      * @dev Transfers `tokenId` token from `from` to `to`.
915      *
916      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
917      *
918      * Requirements:
919      *
920      * - `from` cannot be the zero address.
921      * - `to` cannot be the zero address.
922      * - `tokenId` token must be owned by `from`.
923      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
924      *
925      * Emits a {Transfer} event.
926      */
927     function transferFrom(
928         address from,
929         address to,
930         uint256 tokenId
931     ) external;
932 
933     /**
934      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
935      * The approval is cleared when the token is transferred.
936      *
937      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
938      *
939      * Requirements:
940      *
941      * - The caller must own the token or be an approved operator.
942      * - `tokenId` must exist.
943      *
944      * Emits an {Approval} event.
945      */
946     function approve(address to, uint256 tokenId) external;
947 
948     /**
949      * @dev Returns the account approved for `tokenId` token.
950      *
951      * Requirements:
952      *
953      * - `tokenId` must exist.
954      */
955     function getApproved(uint256 tokenId) external view returns (address operator);
956 
957     /**
958      * @dev Approve or remove `operator` as an operator for the caller.
959      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
960      *
961      * Requirements:
962      *
963      * - The `operator` cannot be the caller.
964      *
965      * Emits an {ApprovalForAll} event.
966      */
967     function setApprovalForAll(address operator, bool _approved) external;
968 
969     /**
970      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
971      *
972      * See {setApprovalForAll}
973      */
974     function isApprovedForAll(address owner, address operator) external view returns (bool);
975 
976     /**
977      * @dev Safely transfers `tokenId` token from `from` to `to`.
978      *
979      * Requirements:
980      *
981      * - `from` cannot be the zero address.
982      * - `to` cannot be the zero address.
983      * - `tokenId` token must exist and be owned by `from`.
984      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
985      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
986      *
987      * Emits a {Transfer} event.
988      */
989     function safeTransferFrom(
990         address from,
991         address to,
992         uint256 tokenId,
993         bytes calldata data
994     ) external;
995 }
996 // File: IERC721Enumerable.sol
997 
998 
999 
1000 pragma solidity ^0.8.0;
1001 
1002 
1003 /**
1004  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1005  * @dev See https://eips.ethereum.org/EIPS/eip-721
1006  */
1007 interface IERC721Enumerable is IERC721 {
1008     /**
1009      * @dev Returns the total amount of tokens stored by the contract.
1010      */
1011     function totalSupply() external view returns (uint256);
1012 
1013     /**
1014      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1015      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1016      */
1017     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1018 
1019     /**
1020      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1021      * Use along with {totalSupply} to enumerate all tokens.
1022      */
1023     function tokenByIndex(uint256 index) external view returns (uint256);
1024 }
1025 // File: IERC721Metadata.sol
1026 
1027 
1028 
1029 pragma solidity ^0.8.0;
1030 
1031 
1032 /**
1033  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1034  * @dev See https://eips.ethereum.org/EIPS/eip-721
1035  */
1036 interface IERC721Metadata is IERC721 {
1037     /**
1038      * @dev Returns the token collection name.
1039      */
1040     function name() external view returns (string memory);
1041 
1042     /**
1043      * @dev Returns the token collection symbol.
1044      */
1045     function symbol() external view returns (string memory);
1046 
1047     /**
1048      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1049      */
1050     function tokenURI(uint256 tokenId) external view returns (string memory);
1051 }
1052 // File: ERC721A.sol
1053 
1054 
1055 pragma solidity ^0.8.0;
1056 
1057 
1058 
1059 
1060 
1061 
1062 
1063 
1064 
1065 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1066     using Address for address;
1067     using Strings for uint256;
1068 
1069     struct TokenOwnership {
1070         address addr;
1071         uint64 startTimestamp;
1072     }
1073 
1074     struct AddressData {
1075         uint128 balance;
1076         uint128 numberMinted;
1077     }
1078 
1079     uint256 internal currentIndex;
1080 
1081     // Token name
1082     string private _name;
1083 
1084     // Token symbol
1085     string private _symbol;
1086 
1087     // Mapping from token ID to ownership details
1088     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1089     mapping(uint256 => TokenOwnership) internal _ownerships;
1090 
1091     // Mapping owner address to address data
1092     mapping(address => AddressData) private _addressData;
1093 
1094     // Mapping from token ID to approved address
1095     mapping(uint256 => address) private _tokenApprovals;
1096 
1097     // Mapping from owner to operator approvals
1098     mapping(address => mapping(address => bool)) private _operatorApprovals;
1099 
1100     constructor(string memory name_, string memory symbol_) {
1101         _name = name_;
1102         _symbol = symbol_;
1103     }
1104 
1105     /**
1106      * @dev See {IERC721Enumerable-totalSupply}.
1107      */
1108     function totalSupply() public view override returns (uint256) {
1109         return currentIndex;
1110     }
1111 
1112     /**
1113      * @dev See {IERC721Enumerable-tokenByIndex}.
1114      */
1115     function tokenByIndex(uint256 index) public view override returns (uint256) {
1116         require(index < totalSupply(), 'ERC721A: global index out of bounds');
1117         return index;
1118     }
1119 
1120     /**
1121      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1122      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1123      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1124      */
1125     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1126         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
1127         uint256 numMintedSoFar = totalSupply();
1128         uint256 tokenIdsIdx;
1129         address currOwnershipAddr;
1130 
1131         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1132         unchecked {
1133             for (uint256 i; i < numMintedSoFar; i++) {
1134                 TokenOwnership memory ownership = _ownerships[i];
1135                 if (ownership.addr != address(0)) {
1136                     currOwnershipAddr = ownership.addr;
1137                 }
1138                 if (currOwnershipAddr == owner) {
1139                     if (tokenIdsIdx == index) {
1140                         return i;
1141                     }
1142                     tokenIdsIdx++;
1143                 }
1144             }
1145         }
1146 
1147         revert('ERC721A: unable to get token of owner by index');
1148     }
1149 
1150     /**
1151      * @dev See {IERC165-supportsInterface}.
1152      */
1153     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1154         return
1155             interfaceId == type(IERC721).interfaceId ||
1156             interfaceId == type(IERC721Metadata).interfaceId ||
1157             interfaceId == type(IERC721Enumerable).interfaceId ||
1158             super.supportsInterface(interfaceId);
1159     }
1160 
1161     /**
1162      * @dev See {IERC721-balanceOf}.
1163      */
1164     function balanceOf(address owner) public view override returns (uint256) {
1165         require(owner != address(0), 'ERC721A: balance query for the zero address');
1166         return uint256(_addressData[owner].balance);
1167     }
1168 
1169     function _numberMinted(address owner) internal view returns (uint256) {
1170         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1171         return uint256(_addressData[owner].numberMinted);
1172     }
1173 
1174     /**
1175      * Gas spent here starts off proportional to the maximum mint batch size.
1176      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1177      */
1178     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1179         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1180 
1181         unchecked {
1182             for (uint256 curr = tokenId; curr >= 0; curr--) {
1183                 TokenOwnership memory ownership = _ownerships[curr];
1184                 if (ownership.addr != address(0)) {
1185                     return ownership;
1186                 }
1187             }
1188         }
1189 
1190         revert('ERC721A: unable to determine the owner of token');
1191     }
1192 
1193     /**
1194      * @dev See {IERC721-ownerOf}.
1195      */
1196     function ownerOf(uint256 tokenId) public view override returns (address) {
1197         return ownershipOf(tokenId).addr;
1198     }
1199 
1200     /**
1201      * @dev See {IERC721Metadata-name}.
1202      */
1203     function name() public view virtual override returns (string memory) {
1204         return _name;
1205     }
1206 
1207     /**
1208      * @dev See {IERC721Metadata-symbol}.
1209      */
1210     function symbol() public view virtual override returns (string memory) {
1211         return _symbol;
1212     }
1213 
1214     /**
1215      * @dev See {IERC721Metadata-tokenURI}.
1216      */
1217     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1218         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1219 
1220         string memory baseURI = _baseURI();
1221         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1222     }
1223 
1224     /**
1225      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1226      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1227      * by default, can be overriden in child contracts.
1228      */
1229     function _baseURI() internal view virtual returns (string memory) {
1230         return '';
1231     }
1232 
1233     /**
1234      * @dev See {IERC721-approve}.
1235      */
1236     function approve(address to, uint256 tokenId) public override {
1237         address owner = ERC721A.ownerOf(tokenId);
1238         require(to != owner, 'ERC721A: approval to current owner');
1239 
1240         require(
1241             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1242             'ERC721A: approve caller is not owner nor approved for all'
1243         );
1244 
1245         _approve(to, tokenId, owner);
1246     }
1247 
1248     /**
1249      * @dev See {IERC721-getApproved}.
1250      */
1251     function getApproved(uint256 tokenId) public view override returns (address) {
1252         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1253 
1254         return _tokenApprovals[tokenId];
1255     }
1256 
1257     /**
1258      * @dev See {IERC721-setApprovalForAll}.
1259      */
1260     function setApprovalForAll(address operator, bool approved) public override {
1261         require(operator != _msgSender(), 'ERC721A: approve to caller');
1262 
1263         _operatorApprovals[_msgSender()][operator] = approved;
1264         emit ApprovalForAll(_msgSender(), operator, approved);
1265     }
1266 
1267     /**
1268      * @dev See {IERC721-isApprovedForAll}.
1269      */
1270     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1271         return _operatorApprovals[owner][operator];
1272     }
1273 
1274     /**
1275      * @dev See {IERC721-transferFrom}.
1276      */
1277     function transferFrom(
1278         address from,
1279         address to,
1280         uint256 tokenId
1281     ) public override {
1282         _transfer(from, to, tokenId);
1283     }
1284 
1285     /**
1286      * @dev See {IERC721-safeTransferFrom}.
1287      */
1288     function safeTransferFrom(
1289         address from,
1290         address to,
1291         uint256 tokenId
1292     ) public override {
1293         safeTransferFrom(from, to, tokenId, '');
1294     }
1295 
1296     /**
1297      * @dev See {IERC721-safeTransferFrom}.
1298      */
1299     function safeTransferFrom(
1300         address from,
1301         address to,
1302         uint256 tokenId,
1303         bytes memory _data
1304     ) public override {
1305         _transfer(from, to, tokenId);
1306         require(
1307             _checkOnERC721Received(from, to, tokenId, _data),
1308             'ERC721A: transfer to non ERC721Receiver implementer'
1309         );
1310     }
1311 
1312     /**
1313      * @dev Returns whether `tokenId` exists.
1314      *
1315      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1316      *
1317      * Tokens start existing when they are minted (`_mint`),
1318      */
1319     function _exists(uint256 tokenId) internal view returns (bool) {
1320         return tokenId < currentIndex;
1321     }
1322 
1323     function _safeMint(address to, uint256 quantity) internal {
1324         _safeMint(to, quantity, '');
1325     }
1326 
1327     /**
1328      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1329      *
1330      * Requirements:
1331      *
1332      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1333      * - `quantity` must be greater than 0.
1334      *
1335      * Emits a {Transfer} event.
1336      */
1337     function _safeMint(
1338         address to,
1339         uint256 quantity,
1340         bytes memory _data
1341     ) internal {
1342         _mint(to, quantity, _data, true);
1343     }
1344 
1345     /**
1346      * @dev Mints `quantity` tokens and transfers them to `to`.
1347      *
1348      * Requirements:
1349      *
1350      * - `to` cannot be the zero address.
1351      * - `quantity` must be greater than 0.
1352      *
1353      * Emits a {Transfer} event.
1354      */
1355     function _mint(
1356         address to,
1357         uint256 quantity,
1358         bytes memory _data,
1359         bool safe
1360     ) internal {
1361         uint256 startTokenId = currentIndex;
1362         require(to != address(0), 'ERC721A: mint to the zero address');
1363         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1364 
1365         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1366 
1367         // Overflows are incredibly unrealistic.
1368         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1369         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1370         unchecked {
1371             _addressData[to].balance += uint128(quantity);
1372             _addressData[to].numberMinted += uint128(quantity);
1373 
1374             _ownerships[startTokenId].addr = to;
1375             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1376 
1377             uint256 updatedIndex = startTokenId;
1378 
1379             for (uint256 i; i < quantity; i++) {
1380                 emit Transfer(address(0), to, updatedIndex);
1381                 if (safe) {
1382                     require(
1383                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1384                         'ERC721A: transfer to non ERC721Receiver implementer'
1385                     );
1386                 }
1387 
1388                 updatedIndex++;
1389             }
1390 
1391             currentIndex = updatedIndex;
1392         }
1393 
1394         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1395     }
1396 
1397     /**
1398      * @dev Transfers `tokenId` from `from` to `to`.
1399      *
1400      * Requirements:
1401      *
1402      * - `to` cannot be the zero address.
1403      * - `tokenId` token must be owned by `from`.
1404      *
1405      * Emits a {Transfer} event.
1406      */
1407     function _transfer(
1408         address from,
1409         address to,
1410         uint256 tokenId
1411     ) private {
1412         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1413 
1414         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1415             getApproved(tokenId) == _msgSender() ||
1416             isApprovedForAll(prevOwnership.addr, _msgSender()));
1417 
1418         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1419 
1420         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1421         require(to != address(0), 'ERC721A: transfer to the zero address');
1422 
1423         _beforeTokenTransfers(from, to, tokenId, 1);
1424 
1425         // Clear approvals from the previous owner
1426         _approve(address(0), tokenId, prevOwnership.addr);
1427 
1428         // Underflow of the sender's balance is impossible because we check for
1429         // ownership above and the recipient's balance can't realistically overflow.
1430         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1431         unchecked {
1432             _addressData[from].balance -= 1;
1433             _addressData[to].balance += 1;
1434 
1435             _ownerships[tokenId].addr = to;
1436             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1437 
1438             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1439             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1440             uint256 nextTokenId = tokenId + 1;
1441             if (_ownerships[nextTokenId].addr == address(0)) {
1442                 if (_exists(nextTokenId)) {
1443                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1444                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1445                 }
1446             }
1447         }
1448 
1449         emit Transfer(from, to, tokenId);
1450         _afterTokenTransfers(from, to, tokenId, 1);
1451     }
1452 
1453     /**
1454      * @dev Approve `to` to operate on `tokenId`
1455      *
1456      * Emits a {Approval} event.
1457      */
1458     function _approve(
1459         address to,
1460         uint256 tokenId,
1461         address owner
1462     ) private {
1463         _tokenApprovals[tokenId] = to;
1464         emit Approval(owner, to, tokenId);
1465     }
1466 
1467     /**
1468      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1469      * The call is not executed if the target address is not a contract.
1470      *
1471      * @param from address representing the previous owner of the given token ID
1472      * @param to target address that will receive the tokens
1473      * @param tokenId uint256 ID of the token to be transferred
1474      * @param _data bytes optional data to send along with the call
1475      * @return bool whether the call correctly returned the expected magic value
1476      */
1477     function _checkOnERC721Received(
1478         address from,
1479         address to,
1480         uint256 tokenId,
1481         bytes memory _data
1482     ) private returns (bool) {
1483         if (to.isContract()) {
1484             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1485                 return retval == IERC721Receiver(to).onERC721Received.selector;
1486             } catch (bytes memory reason) {
1487                 if (reason.length == 0) {
1488                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1489                 } else {
1490                     assembly {
1491                         revert(add(32, reason), mload(reason))
1492                     }
1493                 }
1494             }
1495         } else {
1496             return true;
1497         }
1498     }
1499 
1500     /**
1501      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1502      *
1503      * startTokenId - the first token id to be transferred
1504      * quantity - the amount to be transferred
1505      *
1506      * Calling conditions:
1507      *
1508      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1509      * transferred to `to`.
1510      * - When `from` is zero, `tokenId` will be minted for `to`.
1511      */
1512     function _beforeTokenTransfers(
1513         address from,
1514         address to,
1515         uint256 startTokenId,
1516         uint256 quantity
1517     ) internal virtual {}
1518 
1519     /**
1520      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1521      * minting.
1522      *
1523      * startTokenId - the first token id to be transferred
1524      * quantity - the amount to be transferred
1525      *
1526      * Calling conditions:
1527      *
1528      * - when `from` and `to` are both non-zero.
1529      * - `from` and `to` are never both zero.
1530      */
1531     function _afterTokenTransfers(
1532         address from,
1533         address to,
1534         uint256 startTokenId,
1535         uint256 quantity
1536     ) internal virtual {}
1537 }
1538 
1539 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1540 
1541 pragma solidity ^0.8.0;
1542 
1543 /**
1544  * @dev Contract module that helps prevent reentrant calls to a function.
1545  *
1546  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1547  * available, which can be applied to functions to make sure there are no nested
1548  * (reentrant) calls to them.
1549  *
1550  * Note that because there is a single `nonReentrant` guard, functions marked as
1551  * `nonReentrant` may not call one another. This can be worked around by making
1552  * those functions `private`, and then adding `external` `nonReentrant` entry
1553  * points to them.
1554  *
1555  * TIP: If you would like to learn more about reentrancy and alternative ways
1556  * to protect against it, check out our blog post
1557  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1558  */
1559 abstract contract ReentrancyGuard {
1560     // Booleans are more expensive than uint256 or any type that takes up a full
1561     // word because each write operation emits an extra SLOAD to first read the
1562     // slot's contents, replace the bits taken up by the boolean, and then write
1563     // back. This is the compiler's defense against contract upgrades and
1564     // pointer aliasing, and it cannot be disabled.
1565 
1566     // The values being non-zero value makes deployment a bit more expensive,
1567     // but in exchange the refund on every call to nonReentrant will be lower in
1568     // amount. Since refunds are capped to a percentage of the total
1569     // transaction's gas, it is best to keep them low in cases like this one, to
1570     // increase the likelihood of the full refund coming into effect.
1571     uint256 private constant _NOT_ENTERED = 1;
1572     uint256 private constant _ENTERED = 2;
1573 
1574     uint256 private _status;
1575 
1576     constructor() {
1577         _status = _NOT_ENTERED;
1578     }
1579 
1580     /**
1581      * @dev Prevents a contract from calling itself, directly or indirectly.
1582      * Calling a `nonReentrant` function from another `nonReentrant`
1583      * function is not supported. It is possible to prevent this from happening
1584      * by making the `nonReentrant` function external, and making it call a
1585      * `private` function that does the actual work.
1586      */
1587     modifier nonReentrant() {
1588         // On the first call to nonReentrant, _notEntered will be true
1589         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1590 
1591         // Any calls to nonReentrant after this point will fail
1592         _status = _ENTERED;
1593 
1594         _;
1595 
1596         // By storing the original value once again, a refund is triggered (see
1597         // https://eips.ethereum.org/EIPS/eip-2200)
1598         _status = _NOT_ENTERED;
1599     }
1600 }
1601 
1602 pragma solidity ^0.8.2;
1603 
1604 contract GENZArtLabNFT is ERC721A, Ownable, ReentrancyGuard {  
1605     using Strings for uint256;
1606     string public _partslink;
1607     bool public byebye = false;
1608     uint256 public GZALs = 3000;
1609     uint256 public GZALfreeMint = 1200;
1610     uint256 public GZALbyebye = 2; 
1611     uint256 public constant MINT_PRICE = 0.008 ether;
1612 
1613     mapping(address => uint256) public howmanyGZALs;
1614    
1615 	constructor() ERC721A("GENZArtLab", "GZAL") {}
1616 
1617     function _baseURI() internal view virtual override returns (string memory) {
1618         return _partslink;
1619     }
1620 
1621  	function makingGZAL(uint quantity) external payable nonReentrant {
1622   	    uint256 totalGZALsss = totalSupply();
1623         require(byebye);
1624         require(quantity <= 5, "mint quantity need smaller");
1625         require(totalGZALsss + quantity <= GZALs);
1626         require(msg.sender == tx.origin);
1627     	require(howmanyGZALs[msg.sender] < GZALbyebye);
1628         if(totalGZALsss + quantity >= GZALfreeMint){
1629            require(msg.value == MINT_PRICE*quantity, "wrong payment");
1630         }
1631         _safeMint(msg.sender, quantity);
1632         howmanyGZALs[msg.sender] += quantity;
1633     }
1634 
1635  	function makeGZALnnfly(address lords, uint256 _GZALs) public onlyOwner {
1636   	    uint256 totalGZALsss = totalSupply();
1637 	    require(totalGZALsss + _GZALs <= GZALs);
1638         _safeMint(lords, _GZALs);
1639     }
1640 
1641     function makeGZALgobyebye(bool _bye) external onlyOwner {
1642         byebye = _bye;
1643     }
1644 
1645     function spredGZALs(uint256 _byebye) external onlyOwner {
1646         GZALbyebye = _byebye;
1647     }
1648 
1649     function makeGZALhaveparts(string memory parts) external onlyOwner {
1650         _partslink = parts;
1651     }
1652 
1653     function sumthinboutfunds() public payable onlyOwner {
1654 	(bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1655 		require(success);
1656 	}
1657 }