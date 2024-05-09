1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev String operations.
7  */
8 library Strings {
9     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
10 
11     /**
12      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
13      */
14     function toString(uint256 value) internal pure returns (string memory) {
15         // Inspired by OraclizeAPI's implementation - MIT licence
16         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
17 
18         if (value == 0) {
19             return "0";
20         }
21         uint256 temp = value;
22         uint256 digits;
23         while (temp != 0) {
24             digits++;
25             temp /= 10;
26         }
27         bytes memory buffer = new bytes(digits);
28         while (value != 0) {
29             digits -= 1;
30             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
31             value /= 10;
32         }
33         return string(buffer);
34     }
35 
36     /**
37      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
38      */
39     function toHexString(uint256 value) internal pure returns (string memory) {
40         if (value == 0) {
41             return "0x00";
42         }
43         uint256 temp = value;
44         uint256 length = 0;
45         while (temp != 0) {
46             length++;
47             temp >>= 8;
48         }
49         return toHexString(value, length);
50     }
51 
52     /**
53      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
54      */
55     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
56         bytes memory buffer = new bytes(2 * length + 2);
57         buffer[0] = "0";
58         buffer[1] = "x";
59         for (uint256 i = 2 * length + 1; i > 1; --i) {
60             buffer[i] = _HEX_SYMBOLS[value & 0xf];
61             value >>= 4;
62         }
63         require(value == 0, "Strings: hex length insufficient");
64         return string(buffer);
65     }
66 }
67 // File: ECDSA.sol
68 
69 
70 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 
75 /**
76  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
77  *
78  * These functions can be used to verify that a message was signed by the holder
79  * of the private keys of a given address.
80  */
81 library ECDSA {
82     enum RecoverError {
83         NoError,
84         InvalidSignature,
85         InvalidSignatureLength,
86         InvalidSignatureS,
87         InvalidSignatureV
88     }
89 
90     function _throwError(RecoverError error) private pure {
91         if (error == RecoverError.NoError) {
92             return; // no error: do nothing
93         } else if (error == RecoverError.InvalidSignature) {
94             revert("ECDSA: invalid signature");
95         } else if (error == RecoverError.InvalidSignatureLength) {
96             revert("ECDSA: invalid signature length");
97         } else if (error == RecoverError.InvalidSignatureS) {
98             revert("ECDSA: invalid signature 's' value");
99         } else if (error == RecoverError.InvalidSignatureV) {
100             revert("ECDSA: invalid signature 'v' value");
101         }
102     }
103 
104     /**
105      * @dev Returns the address that signed a hashed message (`hash`) with
106      * `signature` or error string. This address can then be used for verification purposes.
107      *
108      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
109      * this function rejects them by requiring the `s` value to be in the lower
110      * half order, and the `v` value to be either 27 or 28.
111      *
112      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
113      * verification to be secure: it is possible to craft signatures that
114      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
115      * this is by receiving a hash of the original message (which may otherwise
116      * be too long), and then calling {toEthSignedMessageHash} on it.
117      *
118      * Documentation for signature generation:
119      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
120      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
121      *
122      * _Available since v4.3._
123      */
124     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
125         // Check the signature length
126         // - case 65: r,s,v signature (standard)
127         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
128         if (signature.length == 65) {
129             bytes32 r;
130             bytes32 s;
131             uint8 v;
132             // ecrecover takes the signature parameters, and the only way to get them
133             // currently is to use assembly.
134             assembly {
135                 r := mload(add(signature, 0x20))
136                 s := mload(add(signature, 0x40))
137                 v := byte(0, mload(add(signature, 0x60)))
138             }
139             return tryRecover(hash, v, r, s);
140         } else if (signature.length == 64) {
141             bytes32 r;
142             bytes32 vs;
143             // ecrecover takes the signature parameters, and the only way to get them
144             // currently is to use assembly.
145             assembly {
146                 r := mload(add(signature, 0x20))
147                 vs := mload(add(signature, 0x40))
148             }
149             return tryRecover(hash, r, vs);
150         } else {
151             return (address(0), RecoverError.InvalidSignatureLength);
152         }
153     }
154 
155     /**
156      * @dev Returns the address that signed a hashed message (`hash`) with
157      * `signature`. This address can then be used for verification purposes.
158      *
159      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
160      * this function rejects them by requiring the `s` value to be in the lower
161      * half order, and the `v` value to be either 27 or 28.
162      *
163      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
164      * verification to be secure: it is possible to craft signatures that
165      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
166      * this is by receiving a hash of the original message (which may otherwise
167      * be too long), and then calling {toEthSignedMessageHash} on it.
168      */
169     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
170         (address recovered, RecoverError error) = tryRecover(hash, signature);
171         _throwError(error);
172         return recovered;
173     }
174 
175     /**
176      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
177      *
178      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
179      *
180      * _Available since v4.3._
181      */
182     function tryRecover(
183         bytes32 hash,
184         bytes32 r,
185         bytes32 vs
186     ) internal pure returns (address, RecoverError) {
187         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
188         uint8 v = uint8((uint256(vs) >> 255) + 27);
189         return tryRecover(hash, v, r, s);
190     }
191 
192     /**
193      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
194      *
195      * _Available since v4.2._
196      */
197     function recover(
198         bytes32 hash,
199         bytes32 r,
200         bytes32 vs
201     ) internal pure returns (address) {
202         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
203         _throwError(error);
204         return recovered;
205     }
206 
207     /**
208      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
209      * `r` and `s` signature fields separately.
210      *
211      * _Available since v4.3._
212      */
213     function tryRecover(
214         bytes32 hash,
215         uint8 v,
216         bytes32 r,
217         bytes32 s
218     ) internal pure returns (address, RecoverError) {
219         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
220         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
221         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
222         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
223         //
224         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
225         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
226         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
227         // these malleable signatures as well.
228         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
229             return (address(0), RecoverError.InvalidSignatureS);
230         }
231         if (v != 27 && v != 28) {
232             return (address(0), RecoverError.InvalidSignatureV);
233         }
234 
235         // If the signature is valid (and not malleable), return the signer address
236         address signer = ecrecover(hash, v, r, s);
237         if (signer == address(0)) {
238             return (address(0), RecoverError.InvalidSignature);
239         }
240 
241         return (signer, RecoverError.NoError);
242     }
243 
244     /**
245      * @dev Overload of {ECDSA-recover} that receives the `v`,
246      * `r` and `s` signature fields separately.
247      */
248     function recover(
249         bytes32 hash,
250         uint8 v,
251         bytes32 r,
252         bytes32 s
253     ) internal pure returns (address) {
254         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
255         _throwError(error);
256         return recovered;
257     }
258 
259     /**
260      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
261      * produces hash corresponding to the one signed with the
262      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
263      * JSON-RPC method as part of EIP-191.
264      *
265      * See {recover}.
266      */
267     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
268         // 32 is the length in bytes of hash,
269         // enforced by the type signature above
270         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
271     }
272 
273     /**
274      * @dev Returns an Ethereum Signed Message, created from `s`. This
275      * produces hash corresponding to the one signed with the
276      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
277      * JSON-RPC method as part of EIP-191.
278      *
279      * See {recover}.
280      */
281     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
282         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
283     }
284 
285     /**
286      * @dev Returns an Ethereum Signed Typed Data, created from a
287      * `domainSeparator` and a `structHash`. This produces hash corresponding
288      * to the one signed with the
289      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
290      * JSON-RPC method as part of EIP-712.
291      *
292      * See {recover}.
293      */
294     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
295         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
296     }
297 }
298 // File: Context.sol
299 
300 
301 
302 pragma solidity ^0.8.0;
303 
304 /**
305  * @dev Provides information about the current execution context, including the
306  * sender of the transaction and its data. While these are generally available
307  * via msg.sender and msg.data, they should not be accessed in such a direct
308  * manner, since when dealing with meta-transactions the account sending and
309  * paying for execution may not be the actual sender (as far as an application
310  * is concerned).
311  *
312  * This contract is only required for intermediate, library-like contracts.
313  */
314 abstract contract Context {
315     function _msgSender() internal view virtual returns (address) {
316         return msg.sender;
317     }
318 
319     function _msgData() internal view virtual returns (bytes calldata) {
320         return msg.data;
321     }
322 }
323 // File: Ownable.sol
324 
325 
326 
327 pragma solidity ^0.8.0;
328 
329 
330 /**
331  * @dev Contract module which provides a basic access control mechanism, where
332  * there is an account (an owner) that can be granted exclusive access to
333  * specific functions.
334  *
335  * By default, the owner account will be the one that deploys the contract. This
336  * can later be changed with {transferOwnership}.
337  *
338  * This module is used through inheritance. It will make available the modifier
339  * `onlyOwner`, which can be applied to your functions to restrict their use to
340  * the owner.
341  */
342 abstract contract Ownable is Context {
343     address private _owner;
344 
345     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
346 
347     /**
348      * @dev Initializes the contract setting the deployer as the initial owner.
349      */
350     constructor() {
351         _setOwner(_msgSender());
352     }
353 
354     /**
355      * @dev Returns the address of the current owner.
356      */
357     function owner() public view virtual returns (address) {
358         return _owner;
359     }
360 
361     /**
362      * @dev Throws if called by any account other than the owner.
363      */
364     modifier onlyOwner() {
365         require(owner() == _msgSender(), "Ownable: caller is not the owner");
366         _;
367     }
368 
369     /**
370      * @dev Leaves the contract without owner. It will not be possible to call
371      * `onlyOwner` functions anymore. Can only be called by the current owner.
372      *
373      * NOTE: Renouncing ownership will leave the contract without an owner,
374      * thereby removing any functionality that is only available to the owner.
375      */
376     function renounceOwnership() public virtual onlyOwner {
377         _setOwner(address(0));
378     }
379 
380     /**
381      * @dev Transfers ownership of the contract to a new account (`newOwner`).
382      * Can only be called by the current owner.
383      */
384     function transferOwnership(address newOwner) public virtual onlyOwner {
385         require(newOwner != address(0), "Ownable: new owner is the zero address");
386         _setOwner(newOwner);
387     }
388 
389     function _setOwner(address newOwner) private {
390         address oldOwner = _owner;
391         _owner = newOwner;
392         emit OwnershipTransferred(oldOwner, newOwner);
393     }
394 }
395 // File: Address.sol
396 
397 
398 
399 pragma solidity ^0.8.0;
400 
401 /**
402  * @dev Collection of functions related to the address type
403  */
404 library Address {
405     /**
406      * @dev Returns true if `account` is a contract.
407      *
408      * [IMPORTANT]
409      * ====
410      * It is unsafe to assume that an address for which this function returns
411      * false is an externally-owned account (EOA) and not a contract.
412      *
413      * Among others, `isContract` will return false for the following
414      * types of addresses:
415      *
416      *  - an externally-owned account
417      *  - a contract in construction
418      *  - an address where a contract will be created
419      *  - an address where a contract lived, but was destroyed
420      * ====
421      */
422     function isContract(address account) internal view returns (bool) {
423         // This method relies on extcodesize, which returns 0 for contracts in
424         // construction, since the code is only stored at the end of the
425         // constructor execution.
426 
427         uint256 size;
428         assembly {
429             size := extcodesize(account)
430         }
431         return size > 0;
432     }
433 
434     /**
435      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
436      * `recipient`, forwarding all available gas and reverting on errors.
437      *
438      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
439      * of certain opcodes, possibly making contracts go over the 2300 gas limit
440      * imposed by `transfer`, making them unable to receive funds via
441      * `transfer`. {sendValue} removes this limitation.
442      *
443      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
444      *
445      * IMPORTANT: because control is transferred to `recipient`, care must be
446      * taken to not create reentrancy vulnerabilities. Consider using
447      * {ReentrancyGuard} or the
448      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
449      */
450     function sendValue(address payable recipient, uint256 amount) internal {
451         require(address(this).balance >= amount, "Address: insufficient balance");
452 
453         (bool success, ) = recipient.call{value: amount}("");
454         require(success, "Address: unable to send value, recipient may have reverted");
455     }
456 
457     /**
458      * @dev Performs a Solidity function call using a low level `call`. A
459      * plain `call` is an unsafe replacement for a function call: use this
460      * function instead.
461      *
462      * If `target` reverts with a revert reason, it is bubbled up by this
463      * function (like regular Solidity function calls).
464      *
465      * Returns the raw returned data. To convert to the expected return value,
466      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
467      *
468      * Requirements:
469      *
470      * - `target` must be a contract.
471      * - calling `target` with `data` must not revert.
472      *
473      * _Available since v3.1._
474      */
475     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
476         return functionCall(target, data, "Address: low-level call failed");
477     }
478 
479     /**
480      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
481      * `errorMessage` as a fallback revert reason when `target` reverts.
482      *
483      * _Available since v3.1._
484      */
485     function functionCall(
486         address target,
487         bytes memory data,
488         string memory errorMessage
489     ) internal returns (bytes memory) {
490         return functionCallWithValue(target, data, 0, errorMessage);
491     }
492 
493     /**
494      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
495      * but also transferring `value` wei to `target`.
496      *
497      * Requirements:
498      *
499      * - the calling contract must have an ETH balance of at least `value`.
500      * - the called Solidity function must be `payable`.
501      *
502      * _Available since v3.1._
503      */
504     function functionCallWithValue(
505         address target,
506         bytes memory data,
507         uint256 value
508     ) internal returns (bytes memory) {
509         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
510     }
511 
512     /**
513      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
514      * with `errorMessage` as a fallback revert reason when `target` reverts.
515      *
516      * _Available since v3.1._
517      */
518     function functionCallWithValue(
519         address target,
520         bytes memory data,
521         uint256 value,
522         string memory errorMessage
523     ) internal returns (bytes memory) {
524         require(address(this).balance >= value, "Address: insufficient balance for call");
525         require(isContract(target), "Address: call to non-contract");
526 
527         (bool success, bytes memory returndata) = target.call{value: value}(data);
528         return _verifyCallResult(success, returndata, errorMessage);
529     }
530 
531     /**
532      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
533      * but performing a static call.
534      *
535      * _Available since v3.3._
536      */
537     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
538         return functionStaticCall(target, data, "Address: low-level static call failed");
539     }
540 
541     /**
542      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
543      * but performing a static call.
544      *
545      * _Available since v3.3._
546      */
547     function functionStaticCall(
548         address target,
549         bytes memory data,
550         string memory errorMessage
551     ) internal view returns (bytes memory) {
552         require(isContract(target), "Address: static call to non-contract");
553 
554         (bool success, bytes memory returndata) = target.staticcall(data);
555         return _verifyCallResult(success, returndata, errorMessage);
556     }
557 
558     /**
559      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
560      * but performing a delegate call.
561      *
562      * _Available since v3.4._
563      */
564     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
565         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
566     }
567 
568     /**
569      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
570      * but performing a delegate call.
571      *
572      * _Available since v3.4._
573      */
574     function functionDelegateCall(
575         address target,
576         bytes memory data,
577         string memory errorMessage
578     ) internal returns (bytes memory) {
579         require(isContract(target), "Address: delegate call to non-contract");
580 
581         (bool success, bytes memory returndata) = target.delegatecall(data);
582         return _verifyCallResult(success, returndata, errorMessage);
583     }
584 
585     function _verifyCallResult(
586         bool success,
587         bytes memory returndata,
588         string memory errorMessage
589     ) private pure returns (bytes memory) {
590         if (success) {
591             return returndata;
592         } else {
593             // Look for revert reason and bubble it up if present
594             if (returndata.length > 0) {
595                 // The easiest way to bubble the revert reason is using memory via assembly
596 
597                 assembly {
598                     let returndata_size := mload(returndata)
599                     revert(add(32, returndata), returndata_size)
600                 }
601             } else {
602                 revert(errorMessage);
603             }
604         }
605     }
606 }
607 // File: Payment.sol
608 
609 
610 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
611 
612 pragma solidity ^0.8.0;
613 
614 
615 
616 /**
617  * @title PaymentSplitter
618  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
619  * that the Ether will be split in this way, since it is handled transparently by the contract.
620  *
621  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
622  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
623  * an amount proportional to the percentage of total shares they were assigned.
624  *
625  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
626  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
627  * function.
628  *
629  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
630  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
631  * to run tests before sending real value to this contract.
632  */
633 contract Payment is Context {
634     event PayeeAdded(address account, uint256 shares);
635     event PaymentReleased(address to, uint256 amount);
636     event PaymentReceived(address from, uint256 amount);
637 
638     uint256 private _totalShares;
639     uint256 private _totalReleased;
640 
641     mapping(address => uint256) private _shares;
642     mapping(address => uint256) private _released;
643     address[] private _payees;
644 
645     /**
646      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
647      * the matching position in the `shares` array.
648      *
649      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
650      * duplicates in `payees`.
651      */
652     constructor(address[] memory payees, uint256[] memory shares_) payable {
653         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
654         require(payees.length > 0, "PaymentSplitter: no payees");
655 
656         for (uint256 i = 0; i < payees.length; i++) {
657             _addPayee(payees[i], shares_[i]);
658         }
659     }
660 
661     /**
662      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
663      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
664      * reliability of the events, and not the actual splitting of Ether.
665      *
666      * To learn more about this see the Solidity documentation for
667      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
668      * functions].
669      */
670     receive() external payable virtual {
671         emit PaymentReceived(_msgSender(), msg.value);
672     }
673 
674     /**
675      * @dev Getter for the total shares held by payees.
676      */
677     function totalShares() public view returns (uint256) {
678         return _totalShares;
679     }
680 
681     /**
682      * @dev Getter for the total amount of Ether already released.
683      */
684     function totalReleased() public view returns (uint256) {
685         return _totalReleased;
686     }
687 
688 
689     /**
690      * @dev Getter for the amount of shares held by an account.
691      */
692     function shares(address account) public view returns (uint256) {
693         return _shares[account];
694     }
695 
696     /**
697      * @dev Getter for the amount of Ether already released to a payee.
698      */
699     function released(address account) public view returns (uint256) {
700         return _released[account];
701     }
702 
703 
704     /**
705      * @dev Getter for the address of the payee number `index`.
706      */
707     function payee(uint256 index) public view returns (address) {
708         return _payees[index];
709     }
710 
711     /**
712      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
713      * total shares and their previous withdrawals.
714      */
715     function release(address payable account) public virtual {
716         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
717 
718         uint256 totalReceived = address(this).balance + totalReleased();
719         uint256 payment = _pendingPayment(account, totalReceived, released(account));
720 
721         require(payment != 0, "PaymentSplitter: account is not due payment");
722 
723         _released[account] += payment;
724         _totalReleased += payment;
725 
726         Address.sendValue(account, payment);
727         emit PaymentReleased(account, payment);
728     }
729 
730 
731     /**
732      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
733      * already released amounts.
734      */
735     function _pendingPayment(
736         address account,
737         uint256 totalReceived,
738         uint256 alreadyReleased
739     ) private view returns (uint256) {
740         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
741     }
742 
743     /**
744      * @dev Add a new payee to the contract.
745      * @param account The address of the payee to add.
746      * @param shares_ The number of shares owned by the payee.
747      */
748     function _addPayee(address account, uint256 shares_) private {
749         require(account != address(0), "PaymentSplitter: account is the zero address");
750         require(shares_ > 0, "PaymentSplitter: shares are 0");
751         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
752 
753         _payees.push(account);
754         _shares[account] = shares_;
755         _totalShares = _totalShares + shares_;
756         emit PayeeAdded(account, shares_);
757     }
758 }
759 // File: IERC721Receiver.sol
760 
761 
762 
763 pragma solidity ^0.8.0;
764 
765 /**
766  * @title ERC721 token receiver interface
767  * @dev Interface for any contract that wants to support safeTransfers
768  * from ERC721 asset contracts.
769  */
770 interface IERC721Receiver {
771     /**
772      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
773      * by `operator` from `from`, this function is called.
774      *
775      * It must return its Solidity selector to confirm the token transfer.
776      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
777      *
778      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
779      */
780     function onERC721Received(
781         address operator,
782         address from,
783         uint256 tokenId,
784         bytes calldata data
785     ) external returns (bytes4);
786 }
787 // File: IERC165.sol
788 
789 
790 
791 pragma solidity ^0.8.0;
792 
793 /**
794  * @dev Interface of the ERC165 standard, as defined in the
795  * https://eips.ethereum.org/EIPS/eip-165[EIP].
796  *
797  * Implementers can declare support of contract interfaces, which can then be
798  * queried by others ({ERC165Checker}).
799  *
800  * For an implementation, see {ERC165}.
801  */
802 interface IERC165 {
803     /**
804      * @dev Returns true if this contract implements the interface defined by
805      * `interfaceId`. See the corresponding
806      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
807      * to learn more about how these ids are created.
808      *
809      * This function call must use less than 30 000 gas.
810      */
811     function supportsInterface(bytes4 interfaceId) external view returns (bool);
812 }
813 // File: ERC165.sol
814 
815 
816 
817 pragma solidity ^0.8.0;
818 
819 
820 /**
821  * @dev Implementation of the {IERC165} interface.
822  *
823  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
824  * for the additional interface id that will be supported. For example:
825  *
826  * ```solidity
827  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
828  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
829  * }
830  * ```
831  *
832  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
833  */
834 abstract contract ERC165 is IERC165 {
835     /**
836      * @dev See {IERC165-supportsInterface}.
837      */
838     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
839         return interfaceId == type(IERC165).interfaceId;
840     }
841 }
842 // File: IERC721.sol
843 
844 
845 
846 pragma solidity ^0.8.0;
847 
848 
849 /**
850  * @dev Required interface of an ERC721 compliant contract.
851  */
852 interface IERC721 is IERC165 {
853     /**
854      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
855      */
856     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
857 
858     /**
859      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
860      */
861     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
862 
863     /**
864      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
865      */
866     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
867 
868     /**
869      * @dev Returns the number of tokens in ``owner``'s account.
870      */
871     function balanceOf(address owner) external view returns (uint256 balance);
872 
873     /**
874      * @dev Returns the owner of the `tokenId` token.
875      *
876      * Requirements:
877      *
878      * - `tokenId` must exist.
879      */
880     function ownerOf(uint256 tokenId) external view returns (address owner);
881 
882     /**
883      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
884      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
885      *
886      * Requirements:
887      *
888      * - `from` cannot be the zero address.
889      * - `to` cannot be the zero address.
890      * - `tokenId` token must exist and be owned by `from`.
891      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
892      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
893      *
894      * Emits a {Transfer} event.
895      */
896     function safeTransferFrom(
897         address from,
898         address to,
899         uint256 tokenId
900     ) external;
901 
902     /**
903      * @dev Transfers `tokenId` token from `from` to `to`.
904      *
905      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
906      *
907      * Requirements:
908      *
909      * - `from` cannot be the zero address.
910      * - `to` cannot be the zero address.
911      * - `tokenId` token must be owned by `from`.
912      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
913      *
914      * Emits a {Transfer} event.
915      */
916     function transferFrom(
917         address from,
918         address to,
919         uint256 tokenId
920     ) external;
921 
922     /**
923      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
924      * The approval is cleared when the token is transferred.
925      *
926      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
927      *
928      * Requirements:
929      *
930      * - The caller must own the token or be an approved operator.
931      * - `tokenId` must exist.
932      *
933      * Emits an {Approval} event.
934      */
935     function approve(address to, uint256 tokenId) external;
936 
937     /**
938      * @dev Returns the account approved for `tokenId` token.
939      *
940      * Requirements:
941      *
942      * - `tokenId` must exist.
943      */
944     function getApproved(uint256 tokenId) external view returns (address operator);
945 
946     /**
947      * @dev Approve or remove `operator` as an operator for the caller.
948      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
949      *
950      * Requirements:
951      *
952      * - The `operator` cannot be the caller.
953      *
954      * Emits an {ApprovalForAll} event.
955      */
956     function setApprovalForAll(address operator, bool _approved) external;
957 
958     /**
959      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
960      *
961      * See {setApprovalForAll}
962      */
963     function isApprovedForAll(address owner, address operator) external view returns (bool);
964 
965     /**
966      * @dev Safely transfers `tokenId` token from `from` to `to`.
967      *
968      * Requirements:
969      *
970      * - `from` cannot be the zero address.
971      * - `to` cannot be the zero address.
972      * - `tokenId` token must exist and be owned by `from`.
973      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
974      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
975      *
976      * Emits a {Transfer} event.
977      */
978     function safeTransferFrom(
979         address from,
980         address to,
981         uint256 tokenId,
982         bytes calldata data
983     ) external;
984 }
985 // File: IERC721Enumerable.sol
986 
987 
988 
989 pragma solidity ^0.8.0;
990 
991 
992 /**
993  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
994  * @dev See https://eips.ethereum.org/EIPS/eip-721
995  */
996 interface IERC721Enumerable is IERC721 {
997     /**
998      * @dev Returns the total amount of tokens stored by the contract.
999      */
1000     function totalSupply() external view returns (uint256);
1001 
1002     /**
1003      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1004      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1005      */
1006     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1007 
1008     /**
1009      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1010      * Use along with {totalSupply} to enumerate all tokens.
1011      */
1012     function tokenByIndex(uint256 index) external view returns (uint256);
1013 }
1014 // File: IERC721Metadata.sol
1015 
1016 
1017 
1018 pragma solidity ^0.8.0;
1019 
1020 
1021 /**
1022  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1023  * @dev See https://eips.ethereum.org/EIPS/eip-721
1024  */
1025 interface IERC721Metadata is IERC721 {
1026     /**
1027      * @dev Returns the token collection name.
1028      */
1029     function name() external view returns (string memory);
1030 
1031     /**
1032      * @dev Returns the token collection symbol.
1033      */
1034     function symbol() external view returns (string memory);
1035 
1036     /**
1037      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1038      */
1039     function tokenURI(uint256 tokenId) external view returns (string memory);
1040 }
1041 // File: ERC721A.sol
1042 
1043 
1044 pragma solidity ^0.8.0;
1045 
1046 
1047 
1048 
1049 
1050 
1051 
1052 
1053 
1054 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1055     using Address for address;
1056     using Strings for uint256;
1057 
1058     struct TokenOwnership {
1059         address addr;
1060         uint64 startTimestamp;
1061     }
1062 
1063     struct AddressData {
1064         uint128 balance;
1065         uint128 numberMinted;
1066     }
1067 
1068     uint256 internal currentIndex;
1069 
1070     // Token name
1071     string private _name;
1072 
1073     // Token symbol
1074     string private _symbol;
1075 
1076     // Mapping from token ID to ownership details
1077     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1078     mapping(uint256 => TokenOwnership) internal _ownerships;
1079 
1080     // Mapping owner address to address data
1081     mapping(address => AddressData) private _addressData;
1082 
1083     // Mapping from token ID to approved address
1084     mapping(uint256 => address) private _tokenApprovals;
1085 
1086     // Mapping from owner to operator approvals
1087     mapping(address => mapping(address => bool)) private _operatorApprovals;
1088 
1089     constructor(string memory name_, string memory symbol_) {
1090         _name = name_;
1091         _symbol = symbol_;
1092     }
1093 
1094     /**
1095      * @dev See {IERC721Enumerable-totalSupply}.
1096      */
1097     function totalSupply() public view override returns (uint256) {
1098         return currentIndex;
1099     }
1100 
1101     /**
1102      * @dev See {IERC721Enumerable-tokenByIndex}.
1103      */
1104     function tokenByIndex(uint256 index) public view override returns (uint256) {
1105         require(index < totalSupply(), 'ERC721A: global index out of bounds');
1106         return index;
1107     }
1108 
1109     /**
1110      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1111      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1112      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1113      */
1114     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1115         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
1116         uint256 numMintedSoFar = totalSupply();
1117         uint256 tokenIdsIdx;
1118         address currOwnershipAddr;
1119 
1120         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1121         unchecked {
1122             for (uint256 i; i < numMintedSoFar; i++) {
1123                 TokenOwnership memory ownership = _ownerships[i];
1124                 if (ownership.addr != address(0)) {
1125                     currOwnershipAddr = ownership.addr;
1126                 }
1127                 if (currOwnershipAddr == owner) {
1128                     if (tokenIdsIdx == index) {
1129                         return i;
1130                     }
1131                     tokenIdsIdx++;
1132                 }
1133             }
1134         }
1135 
1136         revert('ERC721A: unable to get token of owner by index');
1137     }
1138 
1139     /**
1140      * @dev See {IERC165-supportsInterface}.
1141      */
1142     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1143         return
1144             interfaceId == type(IERC721).interfaceId ||
1145             interfaceId == type(IERC721Metadata).interfaceId ||
1146             interfaceId == type(IERC721Enumerable).interfaceId ||
1147             super.supportsInterface(interfaceId);
1148     }
1149 
1150     /**
1151      * @dev See {IERC721-balanceOf}.
1152      */
1153     function balanceOf(address owner) public view override returns (uint256) {
1154         require(owner != address(0), 'ERC721A: balance query for the zero address');
1155         return uint256(_addressData[owner].balance);
1156     }
1157 
1158     function _numberMinted(address owner) internal view returns (uint256) {
1159         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1160         return uint256(_addressData[owner].numberMinted);
1161     }
1162 
1163     /**
1164      * Gas spent here starts off proportional to the maximum mint batch size.
1165      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1166      */
1167     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1168         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1169 
1170         unchecked {
1171             for (uint256 curr = tokenId; curr >= 0; curr--) {
1172                 TokenOwnership memory ownership = _ownerships[curr];
1173                 if (ownership.addr != address(0)) {
1174                     return ownership;
1175                 }
1176             }
1177         }
1178 
1179         revert('ERC721A: unable to determine the owner of token');
1180     }
1181 
1182     /**
1183      * @dev See {IERC721-ownerOf}.
1184      */
1185     function ownerOf(uint256 tokenId) public view override returns (address) {
1186         return ownershipOf(tokenId).addr;
1187     }
1188 
1189     /**
1190      * @dev See {IERC721Metadata-name}.
1191      */
1192     function name() public view virtual override returns (string memory) {
1193         return _name;
1194     }
1195 
1196     /**
1197      * @dev See {IERC721Metadata-symbol}.
1198      */
1199     function symbol() public view virtual override returns (string memory) {
1200         return _symbol;
1201     }
1202 
1203     /**
1204      * @dev See {IERC721Metadata-tokenURI}.
1205      */
1206     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1207         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1208 
1209         string memory baseURI = _baseURI();
1210         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : '';
1211     }
1212 
1213     /**
1214      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1215      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1216      * by default, can be overriden in child contracts.
1217      */
1218     function _baseURI() internal view virtual returns (string memory) {
1219         return '';
1220     }
1221 
1222     /**
1223      * @dev See {IERC721-approve}.
1224      */
1225     function approve(address to, uint256 tokenId) public override {
1226         address owner = ERC721A.ownerOf(tokenId);
1227         require(to != owner, 'ERC721A: approval to current owner');
1228 
1229         require(
1230             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1231             'ERC721A: approve caller is not owner nor approved for all'
1232         );
1233 
1234         _approve(to, tokenId, owner);
1235     }
1236 
1237     /**
1238      * @dev See {IERC721-getApproved}.
1239      */
1240     function getApproved(uint256 tokenId) public view override returns (address) {
1241         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1242 
1243         return _tokenApprovals[tokenId];
1244     }
1245 
1246     /**
1247      * @dev See {IERC721-setApprovalForAll}.
1248      */
1249     function setApprovalForAll(address operator, bool approved) public override {
1250         require(operator != _msgSender(), 'ERC721A: approve to caller');
1251 
1252         _operatorApprovals[_msgSender()][operator] = approved;
1253         emit ApprovalForAll(_msgSender(), operator, approved);
1254     }
1255 
1256     /**
1257      * @dev See {IERC721-isApprovedForAll}.
1258      */
1259     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1260         return _operatorApprovals[owner][operator];
1261     }
1262 
1263     /**
1264      * @dev See {IERC721-transferFrom}.
1265      */
1266     function transferFrom(
1267         address from,
1268         address to,
1269         uint256 tokenId
1270     ) public override {
1271         _transfer(from, to, tokenId);
1272     }
1273 
1274     /**
1275      * @dev See {IERC721-safeTransferFrom}.
1276      */
1277     function safeTransferFrom(
1278         address from,
1279         address to,
1280         uint256 tokenId
1281     ) public override {
1282         safeTransferFrom(from, to, tokenId, '');
1283     }
1284 
1285     /**
1286      * @dev See {IERC721-safeTransferFrom}.
1287      */
1288     function safeTransferFrom(
1289         address from,
1290         address to,
1291         uint256 tokenId,
1292         bytes memory _data
1293     ) public override {
1294         _transfer(from, to, tokenId);
1295         require(
1296             _checkOnERC721Received(from, to, tokenId, _data),
1297             'ERC721A: transfer to non ERC721Receiver implementer'
1298         );
1299     }
1300 
1301     /**
1302      * @dev Returns whether `tokenId` exists.
1303      *
1304      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1305      *
1306      * Tokens start existing when they are minted (`_mint`),
1307      */
1308     function _exists(uint256 tokenId) internal view returns (bool) {
1309         return tokenId < currentIndex;
1310     }
1311 
1312     function _safeMint(address to, uint256 quantity) internal {
1313         _safeMint(to, quantity, '');
1314     }
1315 
1316     /**
1317      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1318      *
1319      * Requirements:
1320      *
1321      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1322      * - `quantity` must be greater than 0.
1323      *
1324      * Emits a {Transfer} event.
1325      */
1326     function _safeMint(
1327         address to,
1328         uint256 quantity,
1329         bytes memory _data
1330     ) internal {
1331         _mint(to, quantity, _data, true);
1332     }
1333 
1334     /**
1335      * @dev Mints `quantity` tokens and transfers them to `to`.
1336      *
1337      * Requirements:
1338      *
1339      * - `to` cannot be the zero address.
1340      * - `quantity` must be greater than 0.
1341      *
1342      * Emits a {Transfer} event.
1343      */
1344     function _mint(
1345         address to,
1346         uint256 quantity,
1347         bytes memory _data,
1348         bool safe
1349     ) internal {
1350         uint256 startTokenId = currentIndex;
1351         require(to != address(0), 'ERC721A: mint to the zero address');
1352         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1353 
1354         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1355 
1356         // Overflows are incredibly unrealistic.
1357         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1358         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1359         unchecked {
1360             _addressData[to].balance += uint128(quantity);
1361             _addressData[to].numberMinted += uint128(quantity);
1362 
1363             _ownerships[startTokenId].addr = to;
1364             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1365 
1366             uint256 updatedIndex = startTokenId;
1367 
1368             for (uint256 i; i < quantity; i++) {
1369                 emit Transfer(address(0), to, updatedIndex);
1370                 if (safe) {
1371                     require(
1372                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1373                         'ERC721A: transfer to non ERC721Receiver implementer'
1374                     );
1375                 }
1376 
1377                 updatedIndex++;
1378             }
1379 
1380             currentIndex = updatedIndex;
1381         }
1382 
1383         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1384     }
1385 
1386     /**
1387      * @dev Transfers `tokenId` from `from` to `to`.
1388      *
1389      * Requirements:
1390      *
1391      * - `to` cannot be the zero address.
1392      * - `tokenId` token must be owned by `from`.
1393      *
1394      * Emits a {Transfer} event.
1395      */
1396     function _transfer(
1397         address from,
1398         address to,
1399         uint256 tokenId
1400     ) private {
1401         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1402 
1403         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1404             getApproved(tokenId) == _msgSender() ||
1405             isApprovedForAll(prevOwnership.addr, _msgSender()));
1406 
1407         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1408 
1409         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1410         require(to != address(0), 'ERC721A: transfer to the zero address');
1411 
1412         _beforeTokenTransfers(from, to, tokenId, 1);
1413 
1414         // Clear approvals from the previous owner
1415         _approve(address(0), tokenId, prevOwnership.addr);
1416 
1417         // Underflow of the sender's balance is impossible because we check for
1418         // ownership above and the recipient's balance can't realistically overflow.
1419         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1420         unchecked {
1421             _addressData[from].balance -= 1;
1422             _addressData[to].balance += 1;
1423 
1424             _ownerships[tokenId].addr = to;
1425             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1426 
1427             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1428             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1429             uint256 nextTokenId = tokenId + 1;
1430             if (_ownerships[nextTokenId].addr == address(0)) {
1431                 if (_exists(nextTokenId)) {
1432                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1433                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1434                 }
1435             }
1436         }
1437 
1438         emit Transfer(from, to, tokenId);
1439         _afterTokenTransfers(from, to, tokenId, 1);
1440     }
1441 
1442     /**
1443      * @dev Approve `to` to operate on `tokenId`
1444      *
1445      * Emits a {Approval} event.
1446      */
1447     function _approve(
1448         address to,
1449         uint256 tokenId,
1450         address owner
1451     ) private {
1452         _tokenApprovals[tokenId] = to;
1453         emit Approval(owner, to, tokenId);
1454     }
1455 
1456     /**
1457      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1458      * The call is not executed if the target address is not a contract.
1459      *
1460      * @param from address representing the previous owner of the given token ID
1461      * @param to target address that will receive the tokens
1462      * @param tokenId uint256 ID of the token to be transferred
1463      * @param _data bytes optional data to send along with the call
1464      * @return bool whether the call correctly returned the expected magic value
1465      */
1466     function _checkOnERC721Received(
1467         address from,
1468         address to,
1469         uint256 tokenId,
1470         bytes memory _data
1471     ) private returns (bool) {
1472         if (to.isContract()) {
1473             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1474                 return retval == IERC721Receiver(to).onERC721Received.selector;
1475             } catch (bytes memory reason) {
1476                 if (reason.length == 0) {
1477                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1478                 } else {
1479                     assembly {
1480                         revert(add(32, reason), mload(reason))
1481                     }
1482                 }
1483             }
1484         } else {
1485             return true;
1486         }
1487     }
1488 
1489     /**
1490      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1491      *
1492      * startTokenId - the first token id to be transferred
1493      * quantity - the amount to be transferred
1494      *
1495      * Calling conditions:
1496      *
1497      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1498      * transferred to `to`.
1499      * - When `from` is zero, `tokenId` will be minted for `to`.
1500      */
1501     function _beforeTokenTransfers(
1502         address from,
1503         address to,
1504         uint256 startTokenId,
1505         uint256 quantity
1506     ) internal virtual {}
1507 
1508     /**
1509      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1510      * minting.
1511      *
1512      * startTokenId - the first token id to be transferred
1513      * quantity - the amount to be transferred
1514      *
1515      * Calling conditions:
1516      *
1517      * - when `from` and `to` are both non-zero.
1518      * - `from` and `to` are never both zero.
1519      */
1520     function _afterTokenTransfers(
1521         address from,
1522         address to,
1523         uint256 startTokenId,
1524         uint256 quantity
1525     ) internal virtual {}
1526 }
1527 
1528 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1529 
1530 pragma solidity ^0.8.0;
1531 
1532 /**
1533  * @dev Contract module that helps prevent reentrant calls to a function.
1534  *
1535  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1536  * available, which can be applied to functions to make sure there are no nested
1537  * (reentrant) calls to them.
1538  *
1539  * Note that because there is a single `nonReentrant` guard, functions marked as
1540  * `nonReentrant` may not call one another. This can be worked around by making
1541  * those functions `private`, and then adding `external` `nonReentrant` entry
1542  * points to them.
1543  *
1544  * TIP: If you would like to learn more about reentrancy and alternative ways
1545  * to protect against it, check out our blog post
1546  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1547  */
1548 abstract contract ReentrancyGuard {
1549     // Booleans are more expensive than uint256 or any type that takes up a full
1550     // word because each write operation emits an extra SLOAD to first read the
1551     // slot's contents, replace the bits taken up by the boolean, and then write
1552     // back. This is the compiler's defense against contract upgrades and
1553     // pointer aliasing, and it cannot be disabled.
1554 
1555     // The values being non-zero value makes deployment a bit more expensive,
1556     // but in exchange the refund on every call to nonReentrant will be lower in
1557     // amount. Since refunds are capped to a percentage of the total
1558     // transaction's gas, it is best to keep them low in cases like this one, to
1559     // increase the likelihood of the full refund coming into effect.
1560     uint256 private constant _NOT_ENTERED = 1;
1561     uint256 private constant _ENTERED = 2;
1562 
1563     uint256 private _status;
1564 
1565     constructor() {
1566         _status = _NOT_ENTERED;
1567     }
1568 
1569     /**
1570      * @dev Prevents a contract from calling itself, directly or indirectly.
1571      * Calling a `nonReentrant` function from another `nonReentrant`
1572      * function is not supported. It is possible to prevent this from happening
1573      * by making the `nonReentrant` function external, and making it call a
1574      * `private` function that does the actual work.
1575      */
1576     modifier nonReentrant() {
1577         // On the first call to nonReentrant, _notEntered will be true
1578         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1579 
1580         // Any calls to nonReentrant after this point will fail
1581         _status = _ENTERED;
1582 
1583         _;
1584 
1585         // By storing the original value once again, a refund is triggered (see
1586         // https://eips.ethereum.org/EIPS/eip-2200)
1587         _status = _NOT_ENTERED;
1588     }
1589 }
1590 
1591 pragma solidity ^0.8.2;
1592 
1593 contract AIOO is ERC721A, Ownable, ReentrancyGuard {  
1594     using Strings for uint256;
1595     string public _basuri = "ipfs://Qmcqig4ftA4XMWfE18FoijwNEkQ6XPv3miK77LaBxBTzW4/";
1596     bool public pause = false;
1597     uint256 public Citizens = 3000;
1598     uint256 public maxmint = 3; 
1599     mapping(address => uint256) public howmanyowned;
1600    
1601 	constructor() ERC721A("All In One Out", "AIOO") {}
1602 
1603     function _baseURI() internal view virtual override returns (string memory) {
1604         return _basuri;
1605     }
1606 
1607 
1608  	function mintCitizen() external nonReentrant {
1609   	    uint256 Totalsupply = totalSupply();
1610         require(pause);
1611         require(Totalsupply + maxmint <= Citizens);
1612         require(msg.sender == tx.origin);
1613     	require(howmanyowned[msg.sender] < maxmint);
1614         _safeMint(msg.sender, maxmint);
1615         howmanyowned[msg.sender] += maxmint;
1616     }
1617 
1618 
1619     function pausemint(bool _stop) external onlyOwner {
1620         pause = _stop;
1621     }
1622 
1623     function changebasur(string memory _basur) external onlyOwner {
1624         _basuri = _basur;
1625     }
1626 
1627 
1628 }