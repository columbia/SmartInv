1 //      *******                                  ******                  **
2 //     /**////**                                /*////**                /**
3 //     /**    /**  ******  ***     ** *******   /*   /**   ******       /**
4 //     /**    /** **////**//**  * /**//**///**  /******     ////**   ******
5 //     /**    /**/**   /** /** ***/** /**  /**  /*//// **  *******  **///**
6 //     /**    ** /**   /** /****/**** /**  /**  /*    /** **////** /**  /**
7 //     /*******  //******  ***/ ///** ***  /**  /******* //********//******
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @dev String operations.
15  */
16 library Strings {
17     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
18 
19     /**
20      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
21      */
22     function toString(uint256 value) internal pure returns (string memory) {
23         // Inspired by OraclizeAPI's implementation - MIT licence
24         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
25 
26         if (value == 0) {
27             return "0";
28         }
29         uint256 temp = value;
30         uint256 digits;
31         while (temp != 0) {
32             digits++;
33             temp /= 10;
34         }
35         bytes memory buffer = new bytes(digits);
36         while (value != 0) {
37             digits -= 1;
38             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
39             value /= 10;
40         }
41         return string(buffer);
42     }
43 
44     /**
45      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
46      */
47     function toHexString(uint256 value) internal pure returns (string memory) {
48         if (value == 0) {
49             return "0x00";
50         }
51         uint256 temp = value;
52         uint256 length = 0;
53         while (temp != 0) {
54             length++;
55             temp >>= 8;
56         }
57         return toHexString(value, length);
58     }
59 
60     /**
61      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
62      */
63     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
64         bytes memory buffer = new bytes(2 * length + 2);
65         buffer[0] = "0";
66         buffer[1] = "x";
67         for (uint256 i = 2 * length + 1; i > 1; --i) {
68             buffer[i] = _HEX_SYMBOLS[value & 0xf];
69             value >>= 4;
70         }
71         require(value == 0, "Strings: hex length insufficient");
72         return string(buffer);
73     }
74 }
75 // File: ECDSA.sol
76 
77 
78 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
79 
80 pragma solidity ^0.8.0;
81 
82 
83 /**
84  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
85  *
86  * These functions can be used to verify that a message was signed by the holder
87  * of the private keys of a given address.
88  */
89 library ECDSA {
90     enum RecoverError {
91         NoError,
92         InvalidSignature,
93         InvalidSignatureLength,
94         InvalidSignatureS,
95         InvalidSignatureV
96     }
97 
98     function _throwError(RecoverError error) private pure {
99         if (error == RecoverError.NoError) {
100             return; // no error: do nothing
101         } else if (error == RecoverError.InvalidSignature) {
102             revert("ECDSA: invalid signature");
103         } else if (error == RecoverError.InvalidSignatureLength) {
104             revert("ECDSA: invalid signature length");
105         } else if (error == RecoverError.InvalidSignatureS) {
106             revert("ECDSA: invalid signature 's' value");
107         } else if (error == RecoverError.InvalidSignatureV) {
108             revert("ECDSA: invalid signature 'v' value");
109         }
110     }
111 
112     /**
113      * @dev Returns the address that signed a hashed message (`hash`) with
114      * `signature` or error string. This address can then be used for verification purposes.
115      *
116      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
117      * this function rejects them by requiring the `s` value to be in the lower
118      * half order, and the `v` value to be either 27 or 28.
119      *
120      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
121      * verification to be secure: it is possible to craft signatures that
122      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
123      * this is by receiving a hash of the original message (which may otherwise
124      * be too long), and then calling {toEthSignedMessageHash} on it.
125      *
126      * Documentation for signature generation:
127      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
128      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
129      *
130      * _Available since v4.3._
131      */
132     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
133         // Check the signature length
134         // - case 65: r,s,v signature (standard)
135         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
136         if (signature.length == 65) {
137             bytes32 r;
138             bytes32 s;
139             uint8 v;
140             // ecrecover takes the signature parameters, and the only way to get them
141             // currently is to use assembly.
142             assembly {
143                 r := mload(add(signature, 0x20))
144                 s := mload(add(signature, 0x40))
145                 v := byte(0, mload(add(signature, 0x60)))
146             }
147             return tryRecover(hash, v, r, s);
148         } else if (signature.length == 64) {
149             bytes32 r;
150             bytes32 vs;
151             // ecrecover takes the signature parameters, and the only way to get them
152             // currently is to use assembly.
153             assembly {
154                 r := mload(add(signature, 0x20))
155                 vs := mload(add(signature, 0x40))
156             }
157             return tryRecover(hash, r, vs);
158         } else {
159             return (address(0), RecoverError.InvalidSignatureLength);
160         }
161     }
162 
163     /**
164      * @dev Returns the address that signed a hashed message (`hash`) with
165      * `signature`. This address can then be used for verification purposes.
166      *
167      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
168      * this function rejects them by requiring the `s` value to be in the lower
169      * half order, and the `v` value to be either 27 or 28.
170      *
171      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
172      * verification to be secure: it is possible to craft signatures that
173      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
174      * this is by receiving a hash of the original message (which may otherwise
175      * be too long), and then calling {toEthSignedMessageHash} on it.
176      */
177     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
178         (address recovered, RecoverError error) = tryRecover(hash, signature);
179         _throwError(error);
180         return recovered;
181     }
182 
183     /**
184      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
185      *
186      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
187      *
188      * _Available since v4.3._
189      */
190     function tryRecover(
191         bytes32 hash,
192         bytes32 r,
193         bytes32 vs
194     ) internal pure returns (address, RecoverError) {
195         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
196         uint8 v = uint8((uint256(vs) >> 255) + 27);
197         return tryRecover(hash, v, r, s);
198     }
199 
200     /**
201      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
202      *
203      * _Available since v4.2._
204      */
205     function recover(
206         bytes32 hash,
207         bytes32 r,
208         bytes32 vs
209     ) internal pure returns (address) {
210         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
211         _throwError(error);
212         return recovered;
213     }
214 
215     /**
216      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
217      * `r` and `s` signature fields separately.
218      *
219      * _Available since v4.3._
220      */
221     function tryRecover(
222         bytes32 hash,
223         uint8 v,
224         bytes32 r,
225         bytes32 s
226     ) internal pure returns (address, RecoverError) {
227         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
228         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
229         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
230         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
231         //
232         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
233         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
234         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
235         // these malleable signatures as well.
236         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
237             return (address(0), RecoverError.InvalidSignatureS);
238         }
239         if (v != 27 && v != 28) {
240             return (address(0), RecoverError.InvalidSignatureV);
241         }
242 
243         // If the signature is valid (and not malleable), return the signer address
244         address signer = ecrecover(hash, v, r, s);
245         if (signer == address(0)) {
246             return (address(0), RecoverError.InvalidSignature);
247         }
248 
249         return (signer, RecoverError.NoError);
250     }
251 
252     /**
253      * @dev Overload of {ECDSA-recover} that receives the `v`,
254      * `r` and `s` signature fields separately.
255      */
256     function recover(
257         bytes32 hash,
258         uint8 v,
259         bytes32 r,
260         bytes32 s
261     ) internal pure returns (address) {
262         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
263         _throwError(error);
264         return recovered;
265     }
266 
267     /**
268      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
269      * produces hash corresponding to the one signed with the
270      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
271      * JSON-RPC method as part of EIP-191.
272      *
273      * See {recover}.
274      */
275     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
276         // 32 is the length in bytes of hash,
277         // enforced by the type signature above
278         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
279     }
280 
281     /**
282      * @dev Returns an Ethereum Signed Message, created from `s`. This
283      * produces hash corresponding to the one signed with the
284      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
285      * JSON-RPC method as part of EIP-191.
286      *
287      * See {recover}.
288      */
289     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
290         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
291     }
292 
293     /**
294      * @dev Returns an Ethereum Signed Typed Data, created from a
295      * `domainSeparator` and a `structHash`. This produces hash corresponding
296      * to the one signed with the
297      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
298      * JSON-RPC method as part of EIP-712.
299      *
300      * See {recover}.
301      */
302     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
303         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
304     }
305 }
306 // File: Context.sol
307 
308 
309 
310 pragma solidity ^0.8.0;
311 
312 /**
313  * @dev Provides information about the current execution context, including the
314  * sender of the transaction and its data. While these are generally available
315  * via msg.sender and msg.data, they should not be accessed in such a direct
316  * manner, since when dealing with meta-transactions the account sending and
317  * paying for execution may not be the actual sender (as far as an application
318  * is concerned).
319  *
320  * This contract is only required for intermediate, library-like contracts.
321  */
322 abstract contract Context {
323     function _msgSender() internal view virtual returns (address) {
324         return msg.sender;
325     }
326 
327     function _msgData() internal view virtual returns (bytes calldata) {
328         return msg.data;
329     }
330 }
331 // File: Ownable.sol
332 
333 
334 
335 pragma solidity ^0.8.0;
336 
337 
338 /**
339  * @dev Contract module which provides a basic access control mechanism, where
340  * there is an account (an owner) that can be granted exclusive access to
341  * specific functions.
342  *
343  * By default, the owner account will be the one that deploys the contract. This
344  * can later be changed with {transferOwnership}.
345  *
346  * This module is used through inheritance. It will make available the modifier
347  * `onlyOwner`, which can be applied to your functions to restrict their use to
348  * the owner.
349  */
350 abstract contract Ownable is Context {
351     address private _owner;
352 
353     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
354 
355     /**
356      * @dev Initializes the contract setting the deployer as the initial owner.
357      */
358     constructor() {
359         _setOwner(_msgSender());
360     }
361 
362     /**
363      * @dev Returns the address of the current owner.
364      */
365     function owner() public view virtual returns (address) {
366         return _owner;
367     }
368 
369     /**
370      * @dev Throws if called by any account other than the owner.
371      */
372     modifier onlyOwner() {
373         require(owner() == _msgSender(), "Ownable: caller is not the owner");
374         _;
375     }
376 
377     /**
378      * @dev Leaves the contract without owner. It will not be possible to call
379      * `onlyOwner` functions anymore. Can only be called by the current owner.
380      *
381      * NOTE: Renouncing ownership will leave the contract without an owner,
382      * thereby removing any functionality that is only available to the owner.
383      */
384     function renounceOwnership() public virtual onlyOwner {
385         _setOwner(address(0));
386     }
387 
388     /**
389      * @dev Transfers ownership of the contract to a new account (`newOwner`).
390      * Can only be called by the current owner.
391      */
392     function transferOwnership(address newOwner) public virtual onlyOwner {
393         require(newOwner != address(0), "Ownable: new owner is the zero address");
394         _setOwner(newOwner);
395     }
396 
397     function _setOwner(address newOwner) private {
398         address oldOwner = _owner;
399         _owner = newOwner;
400         emit OwnershipTransferred(oldOwner, newOwner);
401     }
402 }
403 // File: Address.sol
404 
405 
406 
407 pragma solidity ^0.8.0;
408 
409 /**
410  * @dev Collection of functions related to the address type
411  */
412 library Address {
413     /**
414      * @dev Returns true if `account` is a contract.
415      *
416      * [IMPORTANT]
417      * ====
418      * It is unsafe to assume that an address for which this function returns
419      * false is an externally-owned account (EOA) and not a contract.
420      *
421      * Among others, `isContract` will return false for the following
422      * types of addresses:
423      *
424      *  - an externally-owned account
425      *  - a contract in construction
426      *  - an address where a contract will be created
427      *  - an address where a contract lived, but was destroyed
428      * ====
429      */
430     function isContract(address account) internal view returns (bool) {
431         // This method relies on extcodesize, which returns 0 for contracts in
432         // construction, since the code is only stored at the end of the
433         // constructor execution.
434 
435         uint256 size;
436         assembly {
437             size := extcodesize(account)
438         }
439         return size > 0;
440     }
441 
442     /**
443      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
444      * `recipient`, forwarding all available gas and reverting on errors.
445      *
446      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
447      * of certain opcodes, possibly making contracts go over the 2300 gas limit
448      * imposed by `transfer`, making them unable to receive funds via
449      * `transfer`. {sendValue} removes this limitation.
450      *
451      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
452      *
453      * IMPORTANT: because control is transferred to `recipient`, care must be
454      * taken to not create reentrancy vulnerabilities. Consider using
455      * {ReentrancyGuard} or the
456      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
457      */
458     function sendValue(address payable recipient, uint256 amount) internal {
459         require(address(this).balance >= amount, "Address: insufficient balance");
460 
461         (bool success, ) = recipient.call{value: amount}("");
462         require(success, "Address: unable to send value, recipient may have reverted");
463     }
464 
465     /**
466      * @dev Performs a Solidity function call using a low level `call`. A
467      * plain `call` is an unsafe replacement for a function call: use this
468      * function instead.
469      *
470      * If `target` reverts with a revert reason, it is bubbled up by this
471      * function (like regular Solidity function calls).
472      *
473      * Returns the raw returned data. To convert to the expected return value,
474      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
475      *
476      * Requirements:
477      *
478      * - `target` must be a contract.
479      * - calling `target` with `data` must not revert.
480      *
481      * _Available since v3.1._
482      */
483     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
484         return functionCall(target, data, "Address: low-level call failed");
485     }
486 
487     /**
488      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
489      * `errorMessage` as a fallback revert reason when `target` reverts.
490      *
491      * _Available since v3.1._
492      */
493     function functionCall(
494         address target,
495         bytes memory data,
496         string memory errorMessage
497     ) internal returns (bytes memory) {
498         return functionCallWithValue(target, data, 0, errorMessage);
499     }
500 
501     /**
502      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
503      * but also transferring `value` wei to `target`.
504      *
505      * Requirements:
506      *
507      * - the calling contract must have an ETH balance of at least `value`.
508      * - the called Solidity function must be `payable`.
509      *
510      * _Available since v3.1._
511      */
512     function functionCallWithValue(
513         address target,
514         bytes memory data,
515         uint256 value
516     ) internal returns (bytes memory) {
517         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
518     }
519 
520     /**
521      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
522      * with `errorMessage` as a fallback revert reason when `target` reverts.
523      *
524      * _Available since v3.1._
525      */
526     function functionCallWithValue(
527         address target,
528         bytes memory data,
529         uint256 value,
530         string memory errorMessage
531     ) internal returns (bytes memory) {
532         require(address(this).balance >= value, "Address: insufficient balance for call");
533         require(isContract(target), "Address: call to non-contract");
534 
535         (bool success, bytes memory returndata) = target.call{value: value}(data);
536         return _verifyCallResult(success, returndata, errorMessage);
537     }
538 
539     /**
540      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
541      * but performing a static call.
542      *
543      * _Available since v3.3._
544      */
545     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
546         return functionStaticCall(target, data, "Address: low-level static call failed");
547     }
548 
549     /**
550      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
551      * but performing a static call.
552      *
553      * _Available since v3.3._
554      */
555     function functionStaticCall(
556         address target,
557         bytes memory data,
558         string memory errorMessage
559     ) internal view returns (bytes memory) {
560         require(isContract(target), "Address: static call to non-contract");
561 
562         (bool success, bytes memory returndata) = target.staticcall(data);
563         return _verifyCallResult(success, returndata, errorMessage);
564     }
565 
566     /**
567      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
568      * but performing a delegate call.
569      *
570      * _Available since v3.4._
571      */
572     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
573         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
574     }
575 
576     /**
577      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
578      * but performing a delegate call.
579      *
580      * _Available since v3.4._
581      */
582     function functionDelegateCall(
583         address target,
584         bytes memory data,
585         string memory errorMessage
586     ) internal returns (bytes memory) {
587         require(isContract(target), "Address: delegate call to non-contract");
588 
589         (bool success, bytes memory returndata) = target.delegatecall(data);
590         return _verifyCallResult(success, returndata, errorMessage);
591     }
592 
593     function _verifyCallResult(
594         bool success,
595         bytes memory returndata,
596         string memory errorMessage
597     ) private pure returns (bytes memory) {
598         if (success) {
599             return returndata;
600         } else {
601             // Look for revert reason and bubble it up if present
602             if (returndata.length > 0) {
603                 // The easiest way to bubble the revert reason is using memory via assembly
604 
605                 assembly {
606                     let returndata_size := mload(returndata)
607                     revert(add(32, returndata), returndata_size)
608                 }
609             } else {
610                 revert(errorMessage);
611             }
612         }
613     }
614 }
615 // File: Payment.sol
616 
617 
618 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
619 
620 pragma solidity ^0.8.0;
621 
622 
623 
624 /**
625  * @title PaymentSplitter
626  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
627  * that the Ether will be split in this way, since it is handled transparently by the contract.
628  *
629  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
630  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
631  * an amount proportional to the percentage of total shares they were assigned.
632  *
633  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
634  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
635  * function.
636  *
637  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
638  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
639  * to run tests before sending real value to this contract.
640  */
641 contract Payment is Context {
642     event PayeeAdded(address account, uint256 shares);
643     event PaymentReleased(address to, uint256 amount);
644     event PaymentReceived(address from, uint256 amount);
645 
646     uint256 private _totalShares;
647     uint256 private _totalReleased;
648 
649     mapping(address => uint256) private _shares;
650     mapping(address => uint256) private _released;
651     address[] private _payees;
652 
653     /**
654      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
655      * the matching position in the `shares` array.
656      *
657      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
658      * duplicates in `payees`.
659      */
660     constructor(address[] memory payees, uint256[] memory shares_) payable {
661         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
662         require(payees.length > 0, "PaymentSplitter: no payees");
663 
664         for (uint256 i = 0; i < payees.length; i++) {
665             _addPayee(payees[i], shares_[i]);
666         }
667     }
668 
669     /**
670      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
671      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
672      * reliability of the events, and not the actual splitting of Ether.
673      *
674      * To learn more about this see the Solidity documentation for
675      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
676      * functions].
677      */
678     receive() external payable virtual {
679         emit PaymentReceived(_msgSender(), msg.value);
680     }
681 
682     /**
683      * @dev Getter for the total shares held by payees.
684      */
685     function totalShares() public view returns (uint256) {
686         return _totalShares;
687     }
688 
689     /**
690      * @dev Getter for the total amount of Ether already released.
691      */
692     function totalReleased() public view returns (uint256) {
693         return _totalReleased;
694     }
695 
696 
697     /**
698      * @dev Getter for the amount of shares held by an account.
699      */
700     function shares(address account) public view returns (uint256) {
701         return _shares[account];
702     }
703 
704     /**
705      * @dev Getter for the amount of Ether already released to a payee.
706      */
707     function released(address account) public view returns (uint256) {
708         return _released[account];
709     }
710 
711 
712     /**
713      * @dev Getter for the address of the payee number `index`.
714      */
715     function payee(uint256 index) public view returns (address) {
716         return _payees[index];
717     }
718 
719     /**
720      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
721      * total shares and their previous withdrawals.
722      */
723     function release(address payable account) public virtual {
724         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
725 
726         uint256 totalReceived = address(this).balance + totalReleased();
727         uint256 payment = _pendingPayment(account, totalReceived, released(account));
728 
729         require(payment != 0, "PaymentSplitter: account is not due payment");
730 
731         _released[account] += payment;
732         _totalReleased += payment;
733 
734         Address.sendValue(account, payment);
735         emit PaymentReleased(account, payment);
736     }
737 
738 
739     /**
740      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
741      * already released amounts.
742      */
743     function _pendingPayment(
744         address account,
745         uint256 totalReceived,
746         uint256 alreadyReleased
747     ) private view returns (uint256) {
748         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
749     }
750 
751     /**
752      * @dev Add a new payee to the contract.
753      * @param account The address of the payee to add.
754      * @param shares_ The number of shares owned by the payee.
755      */
756     function _addPayee(address account, uint256 shares_) private {
757         require(account != address(0), "PaymentSplitter: account is the zero address");
758         require(shares_ > 0, "PaymentSplitter: shares are 0");
759         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
760 
761         _payees.push(account);
762         _shares[account] = shares_;
763         _totalShares = _totalShares + shares_;
764         emit PayeeAdded(account, shares_);
765     }
766 }
767 // File: IERC721Receiver.sol
768 
769 
770 
771 pragma solidity ^0.8.0;
772 
773 /**
774  * @title ERC721 token receiver interface
775  * @dev Interface for any contract that wants to support safeTransfers
776  * from ERC721 asset contracts.
777  */
778 interface IERC721Receiver {
779     /**
780      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
781      * by `operator` from `from`, this function is called.
782      *
783      * It must return its Solidity selector to confirm the token transfer.
784      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
785      *
786      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
787      */
788     function onERC721Received(
789         address operator,
790         address from,
791         uint256 tokenId,
792         bytes calldata data
793     ) external returns (bytes4);
794 }
795 // File: IERC165.sol
796 
797 
798 
799 pragma solidity ^0.8.0;
800 
801 /**
802  * @dev Interface of the ERC165 standard, as defined in the
803  * https://eips.ethereum.org/EIPS/eip-165[EIP].
804  *
805  * Implementers can declare support of contract interfaces, which can then be
806  * queried by others ({ERC165Checker}).
807  *
808  * For an implementation, see {ERC165}.
809  */
810 interface IERC165 {
811     /**
812      * @dev Returns true if this contract implements the interface defined by
813      * `interfaceId`. See the corresponding
814      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
815      * to learn more about how these ids are created.
816      *
817      * This function call must use less than 30 000 gas.
818      */
819     function supportsInterface(bytes4 interfaceId) external view returns (bool);
820 }
821 // File: ERC165.sol
822 
823 
824 
825 pragma solidity ^0.8.0;
826 
827 
828 /**
829  * @dev Implementation of the {IERC165} interface.
830  *
831  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
832  * for the additional interface id that will be supported. For example:
833  *
834  * ```solidity
835  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
836  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
837  * }
838  * ```
839  *
840  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
841  */
842 abstract contract ERC165 is IERC165 {
843     /**
844      * @dev See {IERC165-supportsInterface}.
845      */
846     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
847         return interfaceId == type(IERC165).interfaceId;
848     }
849 }
850 // File: IERC721.sol
851 
852 
853 
854 pragma solidity ^0.8.0;
855 
856 
857 /**
858  * @dev Required interface of an ERC721 compliant contract.
859  */
860 interface IERC721 is IERC165 {
861     /**
862      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
863      */
864     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
865 
866     /**
867      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
868      */
869     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
870 
871     /**
872      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
873      */
874     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
875 
876     /**
877      * @dev Returns the number of tokens in ``owner``'s account.
878      */
879     function balanceOf(address owner) external view returns (uint256 balance);
880 
881     /**
882      * @dev Returns the owner of the `tokenId` token.
883      *
884      * Requirements:
885      *
886      * - `tokenId` must exist.
887      */
888     function ownerOf(uint256 tokenId) external view returns (address owner);
889 
890     /**
891      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
892      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
893      *
894      * Requirements:
895      *
896      * - `from` cannot be the zero address.
897      * - `to` cannot be the zero address.
898      * - `tokenId` token must exist and be owned by `from`.
899      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
900      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
901      *
902      * Emits a {Transfer} event.
903      */
904     function safeTransferFrom(
905         address from,
906         address to,
907         uint256 tokenId
908     ) external;
909 
910     /**
911      * @dev Transfers `tokenId` token from `from` to `to`.
912      *
913      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
914      *
915      * Requirements:
916      *
917      * - `from` cannot be the zero address.
918      * - `to` cannot be the zero address.
919      * - `tokenId` token must be owned by `from`.
920      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
921      *
922      * Emits a {Transfer} event.
923      */
924     function transferFrom(
925         address from,
926         address to,
927         uint256 tokenId
928     ) external;
929 
930     /**
931      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
932      * The approval is cleared when the token is transferred.
933      *
934      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
935      *
936      * Requirements:
937      *
938      * - The caller must own the token or be an approved operator.
939      * - `tokenId` must exist.
940      *
941      * Emits an {Approval} event.
942      */
943     function approve(address to, uint256 tokenId) external;
944 
945     /**
946      * @dev Returns the account approved for `tokenId` token.
947      *
948      * Requirements:
949      *
950      * - `tokenId` must exist.
951      */
952     function getApproved(uint256 tokenId) external view returns (address operator);
953 
954     /**
955      * @dev Approve or remove `operator` as an operator for the caller.
956      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
957      *
958      * Requirements:
959      *
960      * - The `operator` cannot be the caller.
961      *
962      * Emits an {ApprovalForAll} event.
963      */
964     function setApprovalForAll(address operator, bool _approved) external;
965 
966     /**
967      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
968      *
969      * See {setApprovalForAll}
970      */
971     function isApprovedForAll(address owner, address operator) external view returns (bool);
972 
973     /**
974      * @dev Safely transfers `tokenId` token from `from` to `to`.
975      *
976      * Requirements:
977      *
978      * - `from` cannot be the zero address.
979      * - `to` cannot be the zero address.
980      * - `tokenId` token must exist and be owned by `from`.
981      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
982      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
983      *
984      * Emits a {Transfer} event.
985      */
986     function safeTransferFrom(
987         address from,
988         address to,
989         uint256 tokenId,
990         bytes calldata data
991     ) external;
992 }
993 // File: IERC721Enumerable.sol
994 
995 
996 
997 pragma solidity ^0.8.0;
998 
999 
1000 /**
1001  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1002  * @dev See https://eips.ethereum.org/EIPS/eip-721
1003  */
1004 interface IERC721Enumerable is IERC721 {
1005     /**
1006      * @dev Returns the total amount of tokens stored by the contract.
1007      */
1008     function totalSupply() external view returns (uint256);
1009 
1010     /**
1011      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1012      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1013      */
1014     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1015 
1016     /**
1017      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1018      * Use along with {totalSupply} to enumerate all tokens.
1019      */
1020     function tokenByIndex(uint256 index) external view returns (uint256);
1021 }
1022 // File: IERC721Metadata.sol
1023 
1024 
1025 
1026 pragma solidity ^0.8.0;
1027 
1028 
1029 /**
1030  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1031  * @dev See https://eips.ethereum.org/EIPS/eip-721
1032  */
1033 interface IERC721Metadata is IERC721 {
1034     /**
1035      * @dev Returns the token collection name.
1036      */
1037     function name() external view returns (string memory);
1038 
1039     /**
1040      * @dev Returns the token collection symbol.
1041      */
1042     function symbol() external view returns (string memory);
1043 
1044     /**
1045      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1046      */
1047     function tokenURI(uint256 tokenId) external view returns (string memory);
1048 }
1049 // File: ERC721A.sol
1050 
1051 
1052 pragma solidity ^0.8.0;
1053 
1054 
1055 
1056 
1057 
1058 
1059 
1060 
1061 
1062 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1063     using Address for address;
1064     using Strings for uint256;
1065 
1066     struct TokenOwnership {
1067         address addr;
1068         uint64 startTimestamp;
1069     }
1070 
1071     struct AddressData {
1072         uint128 balance;
1073         uint128 numberMinted;
1074     }
1075 
1076     uint256 internal currentIndex;
1077 
1078     // Token name
1079     string private _name;
1080 
1081     // Token symbol
1082     string private _symbol;
1083 
1084     // Mapping from token ID to ownership details
1085     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1086     mapping(uint256 => TokenOwnership) internal _ownerships;
1087 
1088     // Mapping owner address to address data
1089     mapping(address => AddressData) private _addressData;
1090 
1091     // Mapping from token ID to approved address
1092     mapping(uint256 => address) private _tokenApprovals;
1093 
1094     // Mapping from owner to operator approvals
1095     mapping(address => mapping(address => bool)) private _operatorApprovals;
1096 
1097     constructor(string memory name_, string memory symbol_) {
1098         _name = name_;
1099         _symbol = symbol_;
1100     }
1101 
1102     /**
1103      * @dev See {IERC721Enumerable-totalSupply}.
1104      */
1105     function totalSupply() public view override returns (uint256) {
1106         return currentIndex;
1107     }
1108 
1109     /**
1110      * @dev See {IERC721Enumerable-tokenByIndex}.
1111      */
1112     function tokenByIndex(uint256 index) public view override returns (uint256) {
1113         require(index < totalSupply(), 'ERC721A: global index out of bounds');
1114         return index;
1115     }
1116 
1117     /**
1118      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1119      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1120      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1121      */
1122     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1123         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
1124         uint256 numMintedSoFar = totalSupply();
1125         uint256 tokenIdsIdx;
1126         address currOwnershipAddr;
1127 
1128         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1129         unchecked {
1130             for (uint256 i; i < numMintedSoFar; i++) {
1131                 TokenOwnership memory ownership = _ownerships[i];
1132                 if (ownership.addr != address(0)) {
1133                     currOwnershipAddr = ownership.addr;
1134                 }
1135                 if (currOwnershipAddr == owner) {
1136                     if (tokenIdsIdx == index) {
1137                         return i;
1138                     }
1139                     tokenIdsIdx++;
1140                 }
1141             }
1142         }
1143 
1144         revert('ERC721A: unable to get token of owner by index');
1145     }
1146 
1147     /**
1148      * @dev See {IERC165-supportsInterface}.
1149      */
1150     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1151         return
1152             interfaceId == type(IERC721).interfaceId ||
1153             interfaceId == type(IERC721Metadata).interfaceId ||
1154             interfaceId == type(IERC721Enumerable).interfaceId ||
1155             super.supportsInterface(interfaceId);
1156     }
1157 
1158     /**
1159      * @dev See {IERC721-balanceOf}.
1160      */
1161     function balanceOf(address owner) public view override returns (uint256) {
1162         require(owner != address(0), 'ERC721A: balance query for the zero address');
1163         return uint256(_addressData[owner].balance);
1164     }
1165 
1166     function _numberMinted(address owner) internal view returns (uint256) {
1167         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1168         return uint256(_addressData[owner].numberMinted);
1169     }
1170 
1171     /**
1172      * Gas spent here starts off proportional to the maximum mint batch size.
1173      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1174      */
1175     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1176         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1177 
1178         unchecked {
1179             for (uint256 curr = tokenId; curr >= 0; curr--) {
1180                 TokenOwnership memory ownership = _ownerships[curr];
1181                 if (ownership.addr != address(0)) {
1182                     return ownership;
1183                 }
1184             }
1185         }
1186 
1187         revert('ERC721A: unable to determine the owner of token');
1188     }
1189 
1190     /**
1191      * @dev See {IERC721-ownerOf}.
1192      */
1193     function ownerOf(uint256 tokenId) public view override returns (address) {
1194         return ownershipOf(tokenId).addr;
1195     }
1196 
1197     /**
1198      * @dev See {IERC721Metadata-name}.
1199      */
1200     function name() public view virtual override returns (string memory) {
1201         return _name;
1202     }
1203 
1204     /**
1205      * @dev See {IERC721Metadata-symbol}.
1206      */
1207     function symbol() public view virtual override returns (string memory) {
1208         return _symbol;
1209     }
1210 
1211     /**
1212      * @dev See {IERC721Metadata-tokenURI}.
1213      */
1214     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1215         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1216 
1217         string memory baseURI = _baseURI();
1218         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1219     }
1220 
1221     /**
1222      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1223      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1224      * by default, can be overriden in child contracts.
1225      */
1226     function _baseURI() internal view virtual returns (string memory) {
1227         return '';
1228     }
1229 
1230     /**
1231      * @dev See {IERC721-approve}.
1232      */
1233     function approve(address to, uint256 tokenId) public override {
1234         address owner = ERC721A.ownerOf(tokenId);
1235         require(to != owner, 'ERC721A: approval to current owner');
1236 
1237         require(
1238             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1239             'ERC721A: approve caller is not owner nor approved for all'
1240         );
1241 
1242         _approve(to, tokenId, owner);
1243     }
1244 
1245     /**
1246      * @dev See {IERC721-getApproved}.
1247      */
1248     function getApproved(uint256 tokenId) public view override returns (address) {
1249         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1250 
1251         return _tokenApprovals[tokenId];
1252     }
1253 
1254     /**
1255      * @dev See {IERC721-setApprovalForAll}.
1256      */
1257     function setApprovalForAll(address operator, bool approved) public override {
1258         require(operator != _msgSender(), 'ERC721A: approve to caller');
1259 
1260         _operatorApprovals[_msgSender()][operator] = approved;
1261         emit ApprovalForAll(_msgSender(), operator, approved);
1262     }
1263 
1264     /**
1265      * @dev See {IERC721-isApprovedForAll}.
1266      */
1267     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1268         return _operatorApprovals[owner][operator];
1269     }
1270 
1271     /**
1272      * @dev See {IERC721-transferFrom}.
1273      */
1274     function transferFrom(
1275         address from,
1276         address to,
1277         uint256 tokenId
1278     ) public override {
1279         _transfer(from, to, tokenId);
1280     }
1281 
1282     /**
1283      * @dev See {IERC721-safeTransferFrom}.
1284      */
1285     function safeTransferFrom(
1286         address from,
1287         address to,
1288         uint256 tokenId
1289     ) public override {
1290         safeTransferFrom(from, to, tokenId, '');
1291     }
1292 
1293     /**
1294      * @dev See {IERC721-safeTransferFrom}.
1295      */
1296     function safeTransferFrom(
1297         address from,
1298         address to,
1299         uint256 tokenId,
1300         bytes memory _data
1301     ) public override {
1302         _transfer(from, to, tokenId);
1303         require(
1304             _checkOnERC721Received(from, to, tokenId, _data),
1305             'ERC721A: transfer to non ERC721Receiver implementer'
1306         );
1307     }
1308 
1309     /**
1310      * @dev Returns whether `tokenId` exists.
1311      *
1312      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1313      *
1314      * Tokens start existing when they are minted (`_mint`),
1315      */
1316     function _exists(uint256 tokenId) internal view returns (bool) {
1317         return tokenId < currentIndex;
1318     }
1319 
1320     function _safeMint(address to, uint256 quantity) internal {
1321         _safeMint(to, quantity, '');
1322     }
1323 
1324     /**
1325      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1326      *
1327      * Requirements:
1328      *
1329      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1330      * - `quantity` must be greater than 0.
1331      *
1332      * Emits a {Transfer} event.
1333      */
1334     function _safeMint(
1335         address to,
1336         uint256 quantity,
1337         bytes memory _data
1338     ) internal {
1339         _mint(to, quantity, _data, true);
1340     }
1341 
1342     /**
1343      * @dev Mints `quantity` tokens and transfers them to `to`.
1344      *
1345      * Requirements:
1346      *
1347      * - `to` cannot be the zero address.
1348      * - `quantity` must be greater than 0.
1349      *
1350      * Emits a {Transfer} event.
1351      */
1352     function _mint(
1353         address to,
1354         uint256 quantity,
1355         bytes memory _data,
1356         bool safe
1357     ) internal {
1358         uint256 startTokenId = currentIndex;
1359         require(to != address(0), 'ERC721A: mint to the zero address');
1360         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1361 
1362         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1363 
1364         // Overflows are incredibly unrealistic.
1365         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1366         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1367         unchecked {
1368             _addressData[to].balance += uint128(quantity);
1369             _addressData[to].numberMinted += uint128(quantity);
1370 
1371             _ownerships[startTokenId].addr = to;
1372             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1373 
1374             uint256 updatedIndex = startTokenId;
1375 
1376             for (uint256 i; i < quantity; i++) {
1377                 emit Transfer(address(0), to, updatedIndex);
1378                 if (safe) {
1379                     require(
1380                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1381                         'ERC721A: transfer to non ERC721Receiver implementer'
1382                     );
1383                 }
1384 
1385                 updatedIndex++;
1386             }
1387 
1388             currentIndex = updatedIndex;
1389         }
1390 
1391         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1392     }
1393 
1394     /**
1395      * @dev Transfers `tokenId` from `from` to `to`.
1396      *
1397      * Requirements:
1398      *
1399      * - `to` cannot be the zero address.
1400      * - `tokenId` token must be owned by `from`.
1401      *
1402      * Emits a {Transfer} event.
1403      */
1404     function _transfer(
1405         address from,
1406         address to,
1407         uint256 tokenId
1408     ) private {
1409         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1410 
1411         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1412             getApproved(tokenId) == _msgSender() ||
1413             isApprovedForAll(prevOwnership.addr, _msgSender()));
1414 
1415         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1416 
1417         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1418         require(to != address(0), 'ERC721A: transfer to the zero address');
1419 
1420         _beforeTokenTransfers(from, to, tokenId, 1);
1421 
1422         // Clear approvals from the previous owner
1423         _approve(address(0), tokenId, prevOwnership.addr);
1424 
1425         // Underflow of the sender's balance is impossible because we check for
1426         // ownership above and the recipient's balance can't realistically overflow.
1427         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1428         unchecked {
1429             _addressData[from].balance -= 1;
1430             _addressData[to].balance += 1;
1431 
1432             _ownerships[tokenId].addr = to;
1433             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1434 
1435             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1436             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1437             uint256 nextTokenId = tokenId + 1;
1438             if (_ownerships[nextTokenId].addr == address(0)) {
1439                 if (_exists(nextTokenId)) {
1440                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1441                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1442                 }
1443             }
1444         }
1445 
1446         emit Transfer(from, to, tokenId);
1447         _afterTokenTransfers(from, to, tokenId, 1);
1448     }
1449 
1450     /**
1451      * @dev Approve `to` to operate on `tokenId`
1452      *
1453      * Emits a {Approval} event.
1454      */
1455     function _approve(
1456         address to,
1457         uint256 tokenId,
1458         address owner
1459     ) private {
1460         _tokenApprovals[tokenId] = to;
1461         emit Approval(owner, to, tokenId);
1462     }
1463 
1464     /**
1465      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1466      * The call is not executed if the target address is not a contract.
1467      *
1468      * @param from address representing the previous owner of the given token ID
1469      * @param to target address that will receive the tokens
1470      * @param tokenId uint256 ID of the token to be transferred
1471      * @param _data bytes optional data to send along with the call
1472      * @return bool whether the call correctly returned the expected magic value
1473      */
1474     function _checkOnERC721Received(
1475         address from,
1476         address to,
1477         uint256 tokenId,
1478         bytes memory _data
1479     ) private returns (bool) {
1480         if (to.isContract()) {
1481             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1482                 return retval == IERC721Receiver(to).onERC721Received.selector;
1483             } catch (bytes memory reason) {
1484                 if (reason.length == 0) {
1485                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1486                 } else {
1487                     assembly {
1488                         revert(add(32, reason), mload(reason))
1489                     }
1490                 }
1491             }
1492         } else {
1493             return true;
1494         }
1495     }
1496 
1497     /**
1498      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1499      *
1500      * startTokenId - the first token id to be transferred
1501      * quantity - the amount to be transferred
1502      *
1503      * Calling conditions:
1504      *
1505      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1506      * transferred to `to`.
1507      * - When `from` is zero, `tokenId` will be minted for `to`.
1508      */
1509     function _beforeTokenTransfers(
1510         address from,
1511         address to,
1512         uint256 startTokenId,
1513         uint256 quantity
1514     ) internal virtual {}
1515 
1516     /**
1517      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1518      * minting.
1519      *
1520      * startTokenId - the first token id to be transferred
1521      * quantity - the amount to be transferred
1522      *
1523      * Calling conditions:
1524      *
1525      * - when `from` and `to` are both non-zero.
1526      * - `from` and `to` are never both zero.
1527      */
1528     function _afterTokenTransfers(
1529         address from,
1530         address to,
1531         uint256 startTokenId,
1532         uint256 quantity
1533     ) internal virtual {}
1534 }
1535 
1536 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1537 
1538 pragma solidity ^0.8.0;
1539 
1540 /**
1541  * @dev Contract module that helps prevent reentrant calls to a function.
1542  *
1543  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1544  * available, which can be applied to functions to make sure there are no nested
1545  * (reentrant) calls to them.
1546  *
1547  * Note that because there is a single `nonReentrant` guard, functions marked as
1548  * `nonReentrant` may not call one another. This can be worked around by making
1549  * those functions `private`, and then adding `external` `nonReentrant` entry
1550  * points to them.
1551  *
1552  * TIP: If you would like to learn more about reentrancy and alternative ways
1553  * to protect against it, check out our blog post
1554  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1555  */
1556 abstract contract ReentrancyGuard {
1557     // Booleans are more expensive than uint256 or any type that takes up a full
1558     // word because each write operation emits an extra SLOAD to first read the
1559     // slot's contents, replace the bits taken up by the boolean, and then write
1560     // back. This is the compiler's defense against contract upgrades and
1561     // pointer aliasing, and it cannot be disabled.
1562 
1563     // The values being non-zero value makes deployment a bit more expensive,
1564     // but in exchange the refund on every call to nonReentrant will be lower in
1565     // amount. Since refunds are capped to a percentage of the total
1566     // transaction's gas, it is best to keep them low in cases like this one, to
1567     // increase the likelihood of the full refund coming into effect.
1568     uint256 private constant _NOT_ENTERED = 1;
1569     uint256 private constant _ENTERED = 2;
1570 
1571     uint256 private _status;
1572 
1573     constructor() {
1574         _status = _NOT_ENTERED;
1575     }
1576 
1577     /**
1578      * @dev Prevents a contract from calling itself, directly or indirectly.
1579      * Calling a `nonReentrant` function from another `nonReentrant`
1580      * function is not supported. It is possible to prevent this from happening
1581      * by making the `nonReentrant` function external, and making it call a
1582      * `private` function that does the actual work.
1583      */
1584     modifier nonReentrant() {
1585         // On the first call to nonReentrant, _notEntered will be true
1586         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1587 
1588         // Any calls to nonReentrant after this point will fail
1589         _status = _ENTERED;
1590 
1591         _;
1592 
1593         // By storing the original value once again, a refund is triggered (see
1594         // https://eips.ethereum.org/EIPS/eip-2200)
1595         _status = _NOT_ENTERED;
1596     }
1597 }
1598 
1599 pragma solidity ^0.8.13;
1600 
1601 contract downBad is ERC721A, Ownable, ReentrancyGuard {  
1602     using Strings for uint256;
1603     string public _partslink = 'ipfs://QmfYz34egUKKq7WXDav1UGr3QEBKTKMnShFvNXxP5ZapDg/';
1604     bool public mintLive = false;
1605     uint256 public constant supply = 4445;
1606     uint256 public constant mintAllowed = 1; 
1607     uint256 constant paying = 0.0000006942 ether;
1608     mapping(address => uint256) public howManyMints;
1609    
1610 	constructor() ERC721A("DownBad", "DOWNB") {}
1611 
1612     function _baseURI() internal view virtual override returns (string memory) {
1613         return _partslink;
1614     }
1615 
1616  	function freeMint() external nonReentrant {
1617   	    uint256 totalminted = totalSupply();
1618         uint256 balance = address(this).balance;
1619         require(msg.sender == tx.origin);
1620         require(mintLive);
1621         require(totalminted + mintAllowed < supply);
1622         require(balance > paying, "Insufficient funds!");
1623     	require(howManyMints[msg.sender] < mintAllowed );
1624         _mint(msg.sender, 1, "", false);
1625         _withdraw(payable(msg.sender), paying);
1626         howManyMints[msg.sender] += 1;
1627     }
1628 
1629     function _withdraw(address _address, uint256 _amount) private {
1630         (bool success, ) = _address.call{value: _amount}("");
1631         require(success, "Transfer failed.");
1632     }
1633 
1634  	function reserve(address sersAddy, uint256 _number) public onlyOwner {
1635   	    uint256 totalminted = totalSupply();
1636 	    require(totalminted + _number < supply);
1637         _mint(sersAddy, _number, "", false);
1638     }
1639 
1640     function setMetadataAnon(string memory parts) external onlyOwner {
1641         _partslink = parts;
1642     }
1643 
1644     function MintStat(bool _change) external payable onlyOwner {
1645         mintLive = _change;
1646     }
1647 
1648     function sumETHforAnon() public payable onlyOwner {
1649 	(bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1650 		require(success);
1651 	}
1652 }