1 /**
2  *Submitted for verification at Etherscan.io on 2022-05-31
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 // File: ECDSA.sol
71 
72 
73 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
74 
75 pragma solidity ^0.8.0;
76 
77 
78 /**
79  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
80  *
81  * These functions can be used to verify that a message was signed by the holder
82  * of the private keys of a given address.
83  */
84 library ECDSA {
85     enum RecoverError {
86         NoError,
87         InvalidSignature,
88         InvalidSignatureLength,
89         InvalidSignatureS,
90         InvalidSignatureV
91     }
92 
93     function _throwError(RecoverError error) private pure {
94         if (error == RecoverError.NoError) {
95             return; // no error: do nothing
96         } else if (error == RecoverError.InvalidSignature) {
97             revert("ECDSA: invalid signature");
98         } else if (error == RecoverError.InvalidSignatureLength) {
99             revert("ECDSA: invalid signature length");
100         } else if (error == RecoverError.InvalidSignatureS) {
101             revert("ECDSA: invalid signature 's' value");
102         } else if (error == RecoverError.InvalidSignatureV) {
103             revert("ECDSA: invalid signature 'v' value");
104         }
105     }
106 
107     /**
108      * @dev Returns the address that signed a hashed message (`hash`) with
109      * `signature` or error string. This address can then be used for verification purposes.
110      *
111      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
112      * this function rejects them by requiring the `s` value to be in the lower
113      * half order, and the `v` value to be either 27 or 28.
114      *
115      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
116      * verification to be secure: it is possible to craft signatures that
117      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
118      * this is by receiving a hash of the original message (which may otherwise
119      * be too long), and then calling {toEthSignedMessageHash} on it.
120      *
121      * Documentation for signature generation:
122      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
123      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
124      *
125      * _Available since v4.3._
126      */
127     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
128         // Check the signature length
129         // - case 65: r,s,v signature (standard)
130         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
131         if (signature.length == 65) {
132             bytes32 r;
133             bytes32 s;
134             uint8 v;
135             // ecrecover takes the signature parameters, and the only way to get them
136             // currently is to use assembly.
137             assembly {
138                 r := mload(add(signature, 0x20))
139                 s := mload(add(signature, 0x40))
140                 v := byte(0, mload(add(signature, 0x60)))
141             }
142             return tryRecover(hash, v, r, s);
143         } else if (signature.length == 64) {
144             bytes32 r;
145             bytes32 vs;
146             // ecrecover takes the signature parameters, and the only way to get them
147             // currently is to use assembly.
148             assembly {
149                 r := mload(add(signature, 0x20))
150                 vs := mload(add(signature, 0x40))
151             }
152             return tryRecover(hash, r, vs);
153         } else {
154             return (address(0), RecoverError.InvalidSignatureLength);
155         }
156     }
157 
158     /**
159      * @dev Returns the address that signed a hashed message (`hash`) with
160      * `signature`. This address can then be used for verification purposes.
161      *
162      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
163      * this function rejects them by requiring the `s` value to be in the lower
164      * half order, and the `v` value to be either 27 or 28.
165      *
166      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
167      * verification to be secure: it is possible to craft signatures that
168      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
169      * this is by receiving a hash of the original message (which may otherwise
170      * be too long), and then calling {toEthSignedMessageHash} on it.
171      */
172     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
173         (address recovered, RecoverError error) = tryRecover(hash, signature);
174         _throwError(error);
175         return recovered;
176     }
177 
178     /**
179      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
180      *
181      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
182      *
183      * _Available since v4.3._
184      */
185     function tryRecover(
186         bytes32 hash,
187         bytes32 r,
188         bytes32 vs
189     ) internal pure returns (address, RecoverError) {
190         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
191         uint8 v = uint8((uint256(vs) >> 255) + 27);
192         return tryRecover(hash, v, r, s);
193     }
194 
195     /**
196      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
197      *
198      * _Available since v4.2._
199      */
200     function recover(
201         bytes32 hash,
202         bytes32 r,
203         bytes32 vs
204     ) internal pure returns (address) {
205         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
206         _throwError(error);
207         return recovered;
208     }
209 
210     /**
211      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
212      * `r` and `s` signature fields separately.
213      *
214      * _Available since v4.3._
215      */
216     function tryRecover(
217         bytes32 hash,
218         uint8 v,
219         bytes32 r,
220         bytes32 s
221     ) internal pure returns (address, RecoverError) {
222         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
223         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
224         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
225         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
226         //
227         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
228         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
229         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
230         // these malleable signatures as well.
231         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
232             return (address(0), RecoverError.InvalidSignatureS);
233         }
234         if (v != 27 && v != 28) {
235             return (address(0), RecoverError.InvalidSignatureV);
236         }
237 
238         // If the signature is valid (and not malleable), return the signer address
239         address signer = ecrecover(hash, v, r, s);
240         if (signer == address(0)) {
241             return (address(0), RecoverError.InvalidSignature);
242         }
243 
244         return (signer, RecoverError.NoError);
245     }
246 
247     /**
248      * @dev Overload of {ECDSA-recover} that receives the `v`,
249      * `r` and `s` signature fields separately.
250      */
251     function recover(
252         bytes32 hash,
253         uint8 v,
254         bytes32 r,
255         bytes32 s
256     ) internal pure returns (address) {
257         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
258         _throwError(error);
259         return recovered;
260     }
261 
262     /**
263      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
264      * produces hash corresponding to the one signed with the
265      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
266      * JSON-RPC method as part of EIP-191.
267      *
268      * See {recover}.
269      */
270     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
271         // 32 is the length in bytes of hash,
272         // enforced by the type signature above
273         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
274     }
275 
276     /**
277      * @dev Returns an Ethereum Signed Message, created from `s`. This
278      * produces hash corresponding to the one signed with the
279      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
280      * JSON-RPC method as part of EIP-191.
281      *
282      * See {recover}.
283      */
284     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
285         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
286     }
287 
288     /**
289      * @dev Returns an Ethereum Signed Typed Data, created from a
290      * `domainSeparator` and a `structHash`. This produces hash corresponding
291      * to the one signed with the
292      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
293      * JSON-RPC method as part of EIP-712.
294      *
295      * See {recover}.
296      */
297     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
298         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
299     }
300 }
301 // File: Context.sol
302 
303 
304 
305 pragma solidity ^0.8.0;
306 
307 /**
308  * @dev Provides information about the current execution context, including the
309  * sender of the transaction and its data. While these are generally available
310  * via msg.sender and msg.data, they should not be accessed in such a direct
311  * manner, since when dealing with meta-transactions the account sending and
312  * paying for execution may not be the actual sender (as far as an application
313  * is concerned).
314  *
315  * This contract is only required for intermediate, library-like contracts.
316  */
317 abstract contract Context {
318     function _msgSender() internal view virtual returns (address) {
319         return msg.sender;
320     }
321 
322     function _msgData() internal view virtual returns (bytes calldata) {
323         return msg.data;
324     }
325 }
326 // File: Ownable.sol
327 
328 
329 
330 pragma solidity ^0.8.0;
331 
332 
333 /**
334  * @dev Contract module which provides a basic access control mechanism, where
335  * there is an account (an owner) that can be granted exclusive access to
336  * specific functions.
337  *
338  * By default, the owner account will be the one that deploys the contract. This
339  * can later be changed with {transferOwnership}.
340  *
341  * This module is used through inheritance. It will make available the modifier
342  * `onlyOwner`, which can be applied to your functions to restrict their use to
343  * the owner.
344  */
345 abstract contract Ownable is Context {
346     address private _owner;
347 
348     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
349 
350     /**
351      * @dev Initializes the contract setting the deployer as the initial owner.
352      */
353     constructor() {
354         _setOwner(_msgSender());
355     }
356 
357     /**
358      * @dev Returns the address of the current owner.
359      */
360     function owner() public view virtual returns (address) {
361         return _owner;
362     }
363 
364     /**
365      * @dev Throws if called by any account other than the owner.
366      */
367     modifier onlyOwner() {
368         require(owner() == _msgSender(), "Ownable: caller is not the owner");
369         _;
370     }
371 
372     /**
373      * @dev Leaves the contract without owner. It will not be possible to call
374      * `onlyOwner` functions anymore. Can only be called by the current owner.
375      *
376      * NOTE: Renouncing ownership will leave the contract without an owner,
377      * thereby removing any functionality that is only available to the owner.
378      */
379     function renounceOwnership() public virtual onlyOwner {
380         _setOwner(address(0));
381     }
382 
383     /**
384      * @dev Transfers ownership of the contract to a new account (`newOwner`).
385      * Can only be called by the current owner.
386      */
387     function transferOwnership(address newOwner) public virtual onlyOwner {
388         require(newOwner != address(0), "Ownable: new owner is the zero address");
389         _setOwner(newOwner);
390     }
391 
392     function _setOwner(address newOwner) private {
393         address oldOwner = _owner;
394         _owner = newOwner;
395         emit OwnershipTransferred(oldOwner, newOwner);
396     }
397 }
398 // File: Address.sol
399 
400 
401 
402 pragma solidity ^0.8.0;
403 
404 /**
405  * @dev Collection of functions related to the address type
406  */
407 library Address {
408     /**
409      * @dev Returns true if `account` is a contract.
410      *
411      * [IMPORTANT]
412      * ====
413      * It is unsafe to assume that an address for which this function returns
414      * false is an externally-owned account (EOA) and not a contract.
415      *
416      * Among others, `isContract` will return false for the following
417      * types of addresses:
418      *
419      *  - an externally-owned account
420      *  - a contract in construction
421      *  - an address where a contract will be created
422      *  - an address where a contract lived, but was destroyed
423      * ====
424      */
425     function isContract(address account) internal view returns (bool) {
426         // This method relies on extcodesize, which returns 0 for contracts in
427         // construction, since the code is only stored at the end of the
428         // constructor execution.
429 
430         uint256 size;
431         assembly {
432             size := extcodesize(account)
433         }
434         return size > 0;
435     }
436 
437     /**
438      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
439      * `recipient`, forwarding all available gas and reverting on errors.
440      *
441      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
442      * of certain opcodes, possibly making contracts go over the 2300 gas limit
443      * imposed by `transfer`, making them unable to receive funds via
444      * `transfer`. {sendValue} removes this limitation.
445      *
446      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
447      *
448      * IMPORTANT: because control is transferred to `recipient`, care must be
449      * taken to not create reentrancy vulnerabilities. Consider using
450      * {ReentrancyGuard} or the
451      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
452      */
453     function sendValue(address payable recipient, uint256 amount) internal {
454         require(address(this).balance >= amount, "Address: insufficient balance");
455 
456         (bool success, ) = recipient.call{value: amount}("");
457         require(success, "Address: unable to send value, recipient may have reverted");
458     }
459 
460     /**
461      * @dev Performs a Solidity function call using a low level `call`. A
462      * plain `call` is an unsafe replacement for a function call: use this
463      * function instead.
464      *
465      * If `target` reverts with a revert reason, it is bubbled up by this
466      * function (like regular Solidity function calls).
467      *
468      * Returns the raw returned data. To convert to the expected return value,
469      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
470      *
471      * Requirements:
472      *
473      * - `target` must be a contract.
474      * - calling `target` with `data` must not revert.
475      *
476      * _Available since v3.1._
477      */
478     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
479         return functionCall(target, data, "Address: low-level call failed");
480     }
481 
482     /**
483      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
484      * `errorMessage` as a fallback revert reason when `target` reverts.
485      *
486      * _Available since v3.1._
487      */
488     function functionCall(
489         address target,
490         bytes memory data,
491         string memory errorMessage
492     ) internal returns (bytes memory) {
493         return functionCallWithValue(target, data, 0, errorMessage);
494     }
495 
496     /**
497      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
498      * but also transferring `value` wei to `target`.
499      *
500      * Requirements:
501      *
502      * - the calling contract must have an ETH balance of at least `value`.
503      * - the called Solidity function must be `payable`.
504      *
505      * _Available since v3.1._
506      */
507     function functionCallWithValue(
508         address target,
509         bytes memory data,
510         uint256 value
511     ) internal returns (bytes memory) {
512         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
513     }
514 
515     /**
516      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
517      * with `errorMessage` as a fallback revert reason when `target` reverts.
518      *
519      * _Available since v3.1._
520      */
521     function functionCallWithValue(
522         address target,
523         bytes memory data,
524         uint256 value,
525         string memory errorMessage
526     ) internal returns (bytes memory) {
527         require(address(this).balance >= value, "Address: insufficient balance for call");
528         require(isContract(target), "Address: call to non-contract");
529 
530         (bool success, bytes memory returndata) = target.call{value: value}(data);
531         return _verifyCallResult(success, returndata, errorMessage);
532     }
533 
534     /**
535      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
536      * but performing a static call.
537      *
538      * _Available since v3.3._
539      */
540     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
541         return functionStaticCall(target, data, "Address: low-level static call failed");
542     }
543 
544     /**
545      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
546      * but performing a static call.
547      *
548      * _Available since v3.3._
549      */
550     function functionStaticCall(
551         address target,
552         bytes memory data,
553         string memory errorMessage
554     ) internal view returns (bytes memory) {
555         require(isContract(target), "Address: static call to non-contract");
556 
557         (bool success, bytes memory returndata) = target.staticcall(data);
558         return _verifyCallResult(success, returndata, errorMessage);
559     }
560 
561     /**
562      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
563      * but performing a delegate call.
564      *
565      * _Available since v3.4._
566      */
567     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
568         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
569     }
570 
571     /**
572      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
573      * but performing a delegate call.
574      *
575      * _Available since v3.4._
576      */
577     function functionDelegateCall(
578         address target,
579         bytes memory data,
580         string memory errorMessage
581     ) internal returns (bytes memory) {
582         require(isContract(target), "Address: delegate call to non-contract");
583 
584         (bool success, bytes memory returndata) = target.delegatecall(data);
585         return _verifyCallResult(success, returndata, errorMessage);
586     }
587 
588     function _verifyCallResult(
589         bool success,
590         bytes memory returndata,
591         string memory errorMessage
592     ) private pure returns (bytes memory) {
593         if (success) {
594             return returndata;
595         } else {
596             // Look for revert reason and bubble it up if present
597             if (returndata.length > 0) {
598                 // The easiest way to bubble the revert reason is using memory via assembly
599 
600                 assembly {
601                     let returndata_size := mload(returndata)
602                     revert(add(32, returndata), returndata_size)
603                 }
604             } else {
605                 revert(errorMessage);
606             }
607         }
608     }
609 }
610 // File: Payment.sol
611 
612 
613 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
614 
615 pragma solidity ^0.8.0;
616 
617 
618 
619 /**
620  * @title PaymentSplitter
621  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
622  * that the Ether will be split in this way, since it is handled transparently by the contract.
623  *
624  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
625  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
626  * an amount proportional to the percentage of total shares they were assigned.
627  *
628  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
629  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
630  * function.
631  *
632  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
633  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
634  * to run tests before sending real value to this contract.
635  */
636 contract Payment is Context {
637     event PayeeAdded(address account, uint256 shares);
638     event PaymentReleased(address to, uint256 amount);
639     event PaymentReceived(address from, uint256 amount);
640 
641     uint256 private _totalShares;
642     uint256 private _totalReleased;
643 
644     mapping(address => uint256) private _shares;
645     mapping(address => uint256) private _released;
646     address[] private _payees;
647 
648     /**
649      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
650      * the matching position in the `shares` array.
651      *
652      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
653      * duplicates in `payees`.
654      */
655     constructor(address[] memory payees, uint256[] memory shares_) payable {
656         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
657         require(payees.length > 0, "PaymentSplitter: no payees");
658 
659         for (uint256 i = 0; i < payees.length; i++) {
660             _addPayee(payees[i], shares_[i]);
661         }
662     }
663 
664     /**
665      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
666      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
667      * reliability of the events, and not the actual splitting of Ether.
668      *
669      * To learn more about this see the Solidity documentation for
670      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
671      * functions].
672      */
673     receive() external payable virtual {
674         emit PaymentReceived(_msgSender(), msg.value);
675     }
676 
677     /**
678      * @dev Getter for the total shares held by payees.
679      */
680     function totalShares() public view returns (uint256) {
681         return _totalShares;
682     }
683 
684     /**
685      * @dev Getter for the total amount of Ether already released.
686      */
687     function totalReleased() public view returns (uint256) {
688         return _totalReleased;
689     }
690 
691 
692     /**
693      * @dev Getter for the amount of shares held by an account.
694      */
695     function shares(address account) public view returns (uint256) {
696         return _shares[account];
697     }
698 
699     /**
700      * @dev Getter for the amount of Ether already released to a payee.
701      */
702     function released(address account) public view returns (uint256) {
703         return _released[account];
704     }
705 
706 
707     /**
708      * @dev Getter for the address of the payee number `index`.
709      */
710     function payee(uint256 index) public view returns (address) {
711         return _payees[index];
712     }
713 
714     /**
715      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
716      * total shares and their previous withdrawals.
717      */
718     function release(address payable account) public virtual {
719         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
720 
721         uint256 totalReceived = address(this).balance + totalReleased();
722         uint256 payment = _pendingPayment(account, totalReceived, released(account));
723 
724         require(payment != 0, "PaymentSplitter: account is not due payment");
725 
726         _released[account] += payment;
727         _totalReleased += payment;
728 
729         Address.sendValue(account, payment);
730         emit PaymentReleased(account, payment);
731     }
732 
733 
734     /**
735      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
736      * already released amounts.
737      */
738     function _pendingPayment(
739         address account,
740         uint256 totalReceived,
741         uint256 alreadyReleased
742     ) private view returns (uint256) {
743         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
744     }
745 
746     /**
747      * @dev Add a new payee to the contract.
748      * @param account The address of the payee to add.
749      * @param shares_ The number of shares owned by the payee.
750      */
751     function _addPayee(address account, uint256 shares_) private {
752         require(account != address(0), "PaymentSplitter: account is the zero address");
753         require(shares_ > 0, "PaymentSplitter: shares are 0");
754         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
755 
756         _payees.push(account);
757         _shares[account] = shares_;
758         _totalShares = _totalShares + shares_;
759         emit PayeeAdded(account, shares_);
760     }
761 }
762 // File: IERC721Receiver.sol
763 
764 
765 
766 pragma solidity ^0.8.0;
767 
768 /**
769  * @title ERC721 token receiver interface
770  * @dev Interface for any contract that wants to support safeTransfers
771  * from ERC721 asset contracts.
772  */
773 interface IERC721Receiver {
774     /**
775      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
776      * by `operator` from `from`, this function is called.
777      *
778      * It must return its Solidity selector to confirm the token transfer.
779      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
780      *
781      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
782      */
783     function onERC721Received(
784         address operator,
785         address from,
786         uint256 tokenId,
787         bytes calldata data
788     ) external returns (bytes4);
789 }
790 // File: IERC165.sol
791 
792 
793 
794 pragma solidity ^0.8.0;
795 
796 /**
797  * @dev Interface of the ERC165 standard, as defined in the
798  * https://eips.ethereum.org/EIPS/eip-165[EIP].
799  *
800  * Implementers can declare support of contract interfaces, which can then be
801  * queried by others ({ERC165Checker}).
802  *
803  * For an implementation, see {ERC165}.
804  */
805 interface IERC165 {
806     /**
807      * @dev Returns true if this contract implements the interface defined by
808      * `interfaceId`. See the corresponding
809      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
810      * to learn more about how these ids are created.
811      *
812      * This function call must use less than 30 000 gas.
813      */
814     function supportsInterface(bytes4 interfaceId) external view returns (bool);
815 }
816 // File: ERC165.sol
817 
818 
819 
820 pragma solidity ^0.8.0;
821 
822 
823 /**
824  * @dev Implementation of the {IERC165} interface.
825  *
826  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
827  * for the additional interface id that will be supported. For example:
828  *
829  * ```solidity
830  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
831  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
832  * }
833  * ```
834  *
835  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
836  */
837 abstract contract ERC165 is IERC165 {
838     /**
839      * @dev See {IERC165-supportsInterface}.
840      */
841     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
842         return interfaceId == type(IERC165).interfaceId;
843     }
844 }
845 // File: IERC721.sol
846 
847 
848 
849 pragma solidity ^0.8.0;
850 
851 
852 /**
853  * @dev Required interface of an ERC721 compliant contract.
854  */
855 interface IERC721 is IERC165 {
856     /**
857      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
858      */
859     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
860 
861     /**
862      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
863      */
864     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
865 
866     /**
867      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
868      */
869     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
870 
871     /**
872      * @dev Returns the number of tokens in ``owner``'s account.
873      */
874     function balanceOf(address owner) external view returns (uint256 balance);
875 
876     /**
877      * @dev Returns the owner of the `tokenId` token.
878      *
879      * Requirements:
880      *
881      * - `tokenId` must exist.
882      */
883     function ownerOf(uint256 tokenId) external view returns (address owner);
884 
885     /**
886      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
887      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
888      *
889      * Requirements:
890      *
891      * - `from` cannot be the zero address.
892      * - `to` cannot be the zero address.
893      * - `tokenId` token must exist and be owned by `from`.
894      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
895      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
896      *
897      * Emits a {Transfer} event.
898      */
899     function safeTransferFrom(
900         address from,
901         address to,
902         uint256 tokenId
903     ) external;
904 
905     /**
906      * @dev Transfers `tokenId` token from `from` to `to`.
907      *
908      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
909      *
910      * Requirements:
911      *
912      * - `from` cannot be the zero address.
913      * - `to` cannot be the zero address.
914      * - `tokenId` token must be owned by `from`.
915      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
916      *
917      * Emits a {Transfer} event.
918      */
919     function transferFrom(
920         address from,
921         address to,
922         uint256 tokenId
923     ) external;
924 
925     /**
926      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
927      * The approval is cleared when the token is transferred.
928      *
929      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
930      *
931      * Requirements:
932      *
933      * - The caller must own the token or be an approved operator.
934      * - `tokenId` must exist.
935      *
936      * Emits an {Approval} event.
937      */
938     function approve(address to, uint256 tokenId) external;
939 
940     /**
941      * @dev Returns the account approved for `tokenId` token.
942      *
943      * Requirements:
944      *
945      * - `tokenId` must exist.
946      */
947     function getApproved(uint256 tokenId) external view returns (address operator);
948 
949     /**
950      * @dev Approve or remove `operator` as an operator for the caller.
951      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
952      *
953      * Requirements:
954      *
955      * - The `operator` cannot be the caller.
956      *
957      * Emits an {ApprovalForAll} event.
958      */
959     function setApprovalForAll(address operator, bool _approved) external;
960 
961     /**
962      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
963      *
964      * See {setApprovalForAll}
965      */
966     function isApprovedForAll(address owner, address operator) external view returns (bool);
967 
968     /**
969      * @dev Safely transfers `tokenId` token from `from` to `to`.
970      *
971      * Requirements:
972      *
973      * - `from` cannot be the zero address.
974      * - `to` cannot be the zero address.
975      * - `tokenId` token must exist and be owned by `from`.
976      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
977      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
978      *
979      * Emits a {Transfer} event.
980      */
981     function safeTransferFrom(
982         address from,
983         address to,
984         uint256 tokenId,
985         bytes calldata data
986     ) external;
987 }
988 // File: IERC721Enumerable.sol
989 
990 
991 
992 pragma solidity ^0.8.0;
993 
994 
995 /**
996  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
997  * @dev See https://eips.ethereum.org/EIPS/eip-721
998  */
999 interface IERC721Enumerable is IERC721 {
1000     /**
1001      * @dev Returns the total amount of tokens stored by the contract.
1002      */
1003     function totalSupply() external view returns (uint256);
1004 
1005     /**
1006      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1007      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1008      */
1009     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1010 
1011     /**
1012      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1013      * Use along with {totalSupply} to enumerate all tokens.
1014      */
1015     function tokenByIndex(uint256 index) external view returns (uint256);
1016 }
1017 // File: IERC721Metadata.sol
1018 
1019 
1020 
1021 pragma solidity ^0.8.0;
1022 
1023 
1024 /**
1025  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1026  * @dev See https://eips.ethereum.org/EIPS/eip-721
1027  */
1028 interface IERC721Metadata is IERC721 {
1029     /**
1030      * @dev Returns the token collection name.
1031      */
1032     function name() external view returns (string memory);
1033 
1034     /**
1035      * @dev Returns the token collection symbol.
1036      */
1037     function symbol() external view returns (string memory);
1038 
1039     /**
1040      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1041      */
1042     function tokenURI(uint256 tokenId) external view returns (string memory);
1043 }
1044 // File: ERC721A.sol
1045 
1046 
1047 pragma solidity ^0.8.0;
1048 
1049 
1050 
1051 
1052 
1053 
1054 
1055 
1056 
1057 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1058     using Address for address;
1059     using Strings for uint256;
1060 
1061     struct TokenOwnership {
1062         address addr;
1063         uint64 startTimestamp;
1064     }
1065 
1066     struct AddressData {
1067         uint128 balance;
1068         uint128 numberMinted;
1069     }
1070 
1071     uint256 internal currentIndex;
1072 
1073     // Token name
1074     string private _name;
1075 
1076     // Token symbol
1077     string private _symbol;
1078 
1079     // Mapping from token ID to ownership details
1080     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1081     mapping(uint256 => TokenOwnership) internal _ownerships;
1082 
1083     // Mapping owner address to address data
1084     mapping(address => AddressData) private _addressData;
1085 
1086     // Mapping from token ID to approved address
1087     mapping(uint256 => address) private _tokenApprovals;
1088 
1089     // Mapping from owner to operator approvals
1090     mapping(address => mapping(address => bool)) private _operatorApprovals;
1091 
1092     constructor(string memory name_, string memory symbol_) {
1093         _name = name_;
1094         _symbol = symbol_;
1095     }
1096 
1097     /**
1098      * @dev See {IERC721Enumerable-totalSupply}.
1099      */
1100     function totalSupply() public view override returns (uint256) {
1101         return currentIndex;
1102     }
1103 
1104     /**
1105      * @dev See {IERC721Enumerable-tokenByIndex}.
1106      */
1107     function tokenByIndex(uint256 index) public view override returns (uint256) {
1108         require(index < totalSupply(), 'ERC721A: global index out of bounds');
1109         return index;
1110     }
1111 
1112     /**
1113      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1114      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1115      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1116      */
1117     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1118         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
1119         uint256 numMintedSoFar = totalSupply();
1120         uint256 tokenIdsIdx;
1121         address currOwnershipAddr;
1122 
1123         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1124         unchecked {
1125             for (uint256 i; i < numMintedSoFar; i++) {
1126                 TokenOwnership memory ownership = _ownerships[i];
1127                 if (ownership.addr != address(0)) {
1128                     currOwnershipAddr = ownership.addr;
1129                 }
1130                 if (currOwnershipAddr == owner) {
1131                     if (tokenIdsIdx == index) {
1132                         return i;
1133                     }
1134                     tokenIdsIdx++;
1135                 }
1136             }
1137         }
1138 
1139         revert('ERC721A: unable to get token of owner by index');
1140     }
1141 
1142     /**
1143      * @dev See {IERC165-supportsInterface}.
1144      */
1145     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1146         return
1147             interfaceId == type(IERC721).interfaceId ||
1148             interfaceId == type(IERC721Metadata).interfaceId ||
1149             interfaceId == type(IERC721Enumerable).interfaceId ||
1150             super.supportsInterface(interfaceId);
1151     }
1152 
1153     /**
1154      * @dev See {IERC721-balanceOf}.
1155      */
1156     function balanceOf(address owner) public view override returns (uint256) {
1157         require(owner != address(0), 'ERC721A: balance query for the zero address');
1158         return uint256(_addressData[owner].balance);
1159     }
1160 
1161     function _numberMinted(address owner) internal view returns (uint256) {
1162         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1163         return uint256(_addressData[owner].numberMinted);
1164     }
1165 
1166     /**
1167      * Gas spent here starts off proportional to the maximum mint batch size.
1168      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1169      */
1170     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1171         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1172 
1173         unchecked {
1174             for (uint256 curr = tokenId; curr >= 0; curr--) {
1175                 TokenOwnership memory ownership = _ownerships[curr];
1176                 if (ownership.addr != address(0)) {
1177                     return ownership;
1178                 }
1179             }
1180         }
1181 
1182         revert('ERC721A: unable to determine the owner of token');
1183     }
1184 
1185     /**
1186      * @dev See {IERC721-ownerOf}.
1187      */
1188     function ownerOf(uint256 tokenId) public view override returns (address) {
1189         return ownershipOf(tokenId).addr;
1190     }
1191 
1192     /**
1193      * @dev See {IERC721Metadata-name}.
1194      */
1195     function name() public view virtual override returns (string memory) {
1196         return _name;
1197     }
1198 
1199     /**
1200      * @dev See {IERC721Metadata-symbol}.
1201      */
1202     function symbol() public view virtual override returns (string memory) {
1203         return _symbol;
1204     }
1205 
1206     /**
1207      * @dev See {IERC721Metadata-tokenURI}.
1208      */
1209     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1210         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1211 
1212         string memory baseURI = _baseURI();
1213         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1214     }
1215 
1216     /**
1217      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1218      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1219      * by default, can be overriden in child contracts.
1220      */
1221     function _baseURI() internal view virtual returns (string memory) {
1222         return '';
1223     }
1224 
1225     /**
1226      * @dev See {IERC721-approve}.
1227      */
1228     function approve(address to, uint256 tokenId) public override {
1229         address owner = ERC721A.ownerOf(tokenId);
1230         require(to != owner, 'ERC721A: approval to current owner');
1231 
1232         require(
1233             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1234             'ERC721A: approve caller is not owner nor approved for all'
1235         );
1236 
1237         _approve(to, tokenId, owner);
1238     }
1239 
1240     /**
1241      * @dev See {IERC721-getApproved}.
1242      */
1243     function getApproved(uint256 tokenId) public view override returns (address) {
1244         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1245 
1246         return _tokenApprovals[tokenId];
1247     }
1248 
1249     /**
1250      * @dev See {IERC721-setApprovalForAll}.
1251      */
1252     function setApprovalForAll(address operator, bool approved) public override {
1253         require(operator != _msgSender(), 'ERC721A: approve to caller');
1254 
1255         _operatorApprovals[_msgSender()][operator] = approved;
1256         emit ApprovalForAll(_msgSender(), operator, approved);
1257     }
1258 
1259     /**
1260      * @dev See {IERC721-isApprovedForAll}.
1261      */
1262     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1263         return _operatorApprovals[owner][operator];
1264     }
1265 
1266     /**
1267      * @dev See {IERC721-transferFrom}.
1268      */
1269     function transferFrom(
1270         address from,
1271         address to,
1272         uint256 tokenId
1273     ) public override {
1274         _transfer(from, to, tokenId);
1275     }
1276 
1277     /**
1278      * @dev See {IERC721-safeTransferFrom}.
1279      */
1280     function safeTransferFrom(
1281         address from,
1282         address to,
1283         uint256 tokenId
1284     ) public override {
1285         safeTransferFrom(from, to, tokenId, '');
1286     }
1287 
1288     /**
1289      * @dev See {IERC721-safeTransferFrom}.
1290      */
1291     function safeTransferFrom(
1292         address from,
1293         address to,
1294         uint256 tokenId,
1295         bytes memory _data
1296     ) public override {
1297         _transfer(from, to, tokenId);
1298         require(
1299             _checkOnERC721Received(from, to, tokenId, _data),
1300             'ERC721A: transfer to non ERC721Receiver implementer'
1301         );
1302     }
1303 
1304     /**
1305      * @dev Returns whether `tokenId` exists.
1306      *
1307      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1308      *
1309      * Tokens start existing when they are minted (`_mint`),
1310      */
1311     function _exists(uint256 tokenId) internal view returns (bool) {
1312         return tokenId < currentIndex;
1313     }
1314 
1315     function _safeMint(address to, uint256 quantity) internal {
1316         _safeMint(to, quantity, '');
1317     }
1318 
1319     /**
1320      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1321      *
1322      * Requirements:
1323      *
1324      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1325      * - `quantity` must be greater than 0.
1326      *
1327      * Emits a {Transfer} event.
1328      */
1329     function _safeMint(
1330         address to,
1331         uint256 quantity,
1332         bytes memory _data
1333     ) internal {
1334         _mint(to, quantity, _data, true);
1335     }
1336 
1337     /**
1338      * @dev Mints `quantity` tokens and transfers them to `to`.
1339      *
1340      * Requirements:
1341      *
1342      * - `to` cannot be the zero address.
1343      * - `quantity` must be greater than 0.
1344      *
1345      * Emits a {Transfer} event.
1346      */
1347     function _mint(
1348         address to,
1349         uint256 quantity,
1350         bytes memory _data,
1351         bool safe
1352     ) internal {
1353         uint256 startTokenId = currentIndex;
1354         require(to != address(0), 'ERC721A: mint to the zero address');
1355         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1356 
1357         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1358 
1359         // Overflows are incredibly unrealistic.
1360         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1361         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1362         unchecked {
1363             _addressData[to].balance += uint128(quantity);
1364             _addressData[to].numberMinted += uint128(quantity);
1365 
1366             _ownerships[startTokenId].addr = to;
1367             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1368 
1369             uint256 updatedIndex = startTokenId;
1370 
1371             for (uint256 i; i < quantity; i++) {
1372                 emit Transfer(address(0), to, updatedIndex);
1373                 if (safe) {
1374                     require(
1375                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1376                         'ERC721A: transfer to non ERC721Receiver implementer'
1377                     );
1378                 }
1379 
1380                 updatedIndex++;
1381             }
1382 
1383             currentIndex = updatedIndex;
1384         }
1385 
1386         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1387     }
1388 
1389     /**
1390      * @dev Transfers `tokenId` from `from` to `to`.
1391      *
1392      * Requirements:
1393      *
1394      * - `to` cannot be the zero address.
1395      * - `tokenId` token must be owned by `from`.
1396      *
1397      * Emits a {Transfer} event.
1398      */
1399     function _transfer(
1400         address from,
1401         address to,
1402         uint256 tokenId
1403     ) private {
1404         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1405 
1406         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1407             getApproved(tokenId) == _msgSender() ||
1408             isApprovedForAll(prevOwnership.addr, _msgSender()));
1409 
1410         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1411 
1412         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1413         require(to != address(0), 'ERC721A: transfer to the zero address');
1414 
1415         _beforeTokenTransfers(from, to, tokenId, 1);
1416 
1417         // Clear approvals from the previous owner
1418         _approve(address(0), tokenId, prevOwnership.addr);
1419 
1420         // Underflow of the sender's balance is impossible because we check for
1421         // ownership above and the recipient's balance can't realistically overflow.
1422         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1423         unchecked {
1424             _addressData[from].balance -= 1;
1425             _addressData[to].balance += 1;
1426 
1427             _ownerships[tokenId].addr = to;
1428             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1429 
1430             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1431             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1432             uint256 nextTokenId = tokenId + 1;
1433             if (_ownerships[nextTokenId].addr == address(0)) {
1434                 if (_exists(nextTokenId)) {
1435                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1436                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1437                 }
1438             }
1439         }
1440 
1441         emit Transfer(from, to, tokenId);
1442         _afterTokenTransfers(from, to, tokenId, 1);
1443     }
1444 
1445     /**
1446      * @dev Approve `to` to operate on `tokenId`
1447      *
1448      * Emits a {Approval} event.
1449      */
1450     function _approve(
1451         address to,
1452         uint256 tokenId,
1453         address owner
1454     ) private {
1455         _tokenApprovals[tokenId] = to;
1456         emit Approval(owner, to, tokenId);
1457     }
1458 
1459     /**
1460      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1461      * The call is not executed if the target address is not a contract.
1462      *
1463      * @param from address representing the previous owner of the given token ID
1464      * @param to target address that will receive the tokens
1465      * @param tokenId uint256 ID of the token to be transferred
1466      * @param _data bytes optional data to send along with the call
1467      * @return bool whether the call correctly returned the expected magic value
1468      */
1469     function _checkOnERC721Received(
1470         address from,
1471         address to,
1472         uint256 tokenId,
1473         bytes memory _data
1474     ) private returns (bool) {
1475         if (to.isContract()) {
1476             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1477                 return retval == IERC721Receiver(to).onERC721Received.selector;
1478             } catch (bytes memory reason) {
1479                 if (reason.length == 0) {
1480                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1481                 } else {
1482                     assembly {
1483                         revert(add(32, reason), mload(reason))
1484                     }
1485                 }
1486             }
1487         } else {
1488             return true;
1489         }
1490     }
1491 
1492     /**
1493      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1494      *
1495      * startTokenId - the first token id to be transferred
1496      * quantity - the amount to be transferred
1497      *
1498      * Calling conditions:
1499      *
1500      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1501      * transferred to `to`.
1502      * - When `from` is zero, `tokenId` will be minted for `to`.
1503      */
1504     function _beforeTokenTransfers(
1505         address from,
1506         address to,
1507         uint256 startTokenId,
1508         uint256 quantity
1509     ) internal virtual {}
1510 
1511     /**
1512      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1513      * minting.
1514      *
1515      * startTokenId - the first token id to be transferred
1516      * quantity - the amount to be transferred
1517      *
1518      * Calling conditions:
1519      *
1520      * - when `from` and `to` are both non-zero.
1521      * - `from` and `to` are never both zero.
1522      */
1523     function _afterTokenTransfers(
1524         address from,
1525         address to,
1526         uint256 startTokenId,
1527         uint256 quantity
1528     ) internal virtual {}
1529 }
1530 
1531 pragma solidity ^0.8.2;
1532 
1533 abstract contract ILLUMINATI {
1534   function ownerOf(uint256 tokenId) public virtual view returns (address);
1535   function tokenOfOwnerByIndex(address owner, uint256 index) public virtual view returns (uint256);
1536   function balanceOf(address owner) external virtual view returns (uint256 balance);
1537 }
1538 
1539 contract SolsticeEris is ERC721A, Ownable {  
1540 	using Strings for uint256;
1541     string public baseURI;
1542 
1543 	mapping(uint256 => bool) public claimTracker;
1544 	mapping(address => bool) public claimTrackerAddress;
1545 
1546 	ILLUMINATI private illuminati;
1547 
1548 	bool public claimLive = false;
1549 
1550     address illuminatiContract = 0x26BAdF693F2b103B021c670c852262b379bBBE8A;
1551 	
1552 	constructor() ERC721A("SolsticeEris", "SLSTC") {
1553         illuminati = ILLUMINATI
1554             (
1555             illuminatiContract
1556             );
1557         }
1558     
1559     // Claim Ticket
1560     function claimTicket(uint256[] calldata illuminatiIDs) external {		
1561 		//initial checks
1562         uint256 illuminatis = illuminatiIDs.length;
1563 
1564 		require(claimLive,"Claim Window is not live");
1565 		require(illuminatis > 0,"You must claim at least 1 token"); // you must claim
1566         require(claimTrackerAddress[msg.sender] == false, "Wallet already claimed");  // check wallet claimed
1567 	
1568 		// checks
1569 		for(uint256 x = 0; x < illuminatis; x++) {
1570 		require(illuminati.ownerOf(illuminatiIDs[x]) == msg.sender,"You do not own these Illuminati"); //check inputted balance
1571 		require(claimTracker[illuminatiIDs[x]] == false,"An inputted token was already claimed"); //check if inputted tokens claimed
1572 		claimTracker[illuminatiIDs[x]] = true; //track claims
1573         }
1574 
1575         claimTrackerAddress[msg.sender] = true; // set wallet claimed
1576         _safeMint(msg.sender, 1); //mint 1 ticket per wallet
1577     }
1578 
1579     function setMetadata(string memory uri) external onlyOwner {
1580         baseURI = uri;
1581     }
1582 
1583     function _baseURI() internal view virtual override returns (string memory) {
1584         return baseURI;
1585     }
1586 
1587 	function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1588         require(_exists(tokenId));
1589         string memory uri = _baseURI();
1590          return bytes(uri).length != 0 ? string(abi.encodePacked(uri, tokenId.toString())) : '';
1591 	}
1592 
1593 	// enables claim
1594 	function setClaimLive(bool _live) external onlyOwner {
1595 		claimLive = _live;
1596 	}
1597 
1598 	//check claim by token
1599 	function checkClaimed(uint256 tokenId) public view returns (bool) {
1600 		return claimTracker[tokenId];
1601 	}
1602 
1603 	//check claim by address
1604 	function checkAddressClaimed(address addr) public view returns (bool) {
1605 		return claimTrackerAddress[addr];
1606 	}
1607 
1608 	//check Illuminati Tokens
1609 	function checkIlluminatiTokens(address owner) public view returns (uint256[] memory){
1610 		uint256 tokenCount = illuminati.balanceOf(owner);
1611 		uint256[] memory tokenIds = new uint256[](tokenCount);
1612         for (uint256 i = 0; i < tokenCount; i++) {
1613             tokenIds[i] = illuminati.tokenOfOwnerByIndex(owner, i);
1614         }
1615 		return tokenIds;
1616 	}
1617 
1618 	//withdraw any funds
1619 	function withdrawToOwner() external onlyOwner {
1620 		payable(msg.sender).transfer(address(this).balance);
1621 	}
1622 
1623 }