1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev String operations.
6  */
7 library Strings {
8     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
9 
10     /**
11      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
12      */
13     function toString(uint256 value) internal pure returns (string memory) {
14         // Inspired by OraclizeAPI's implementation - MIT licence
15         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
16 
17         if (value == 0) {
18             return "0";
19         }
20         uint256 temp = value;
21         uint256 digits;
22         while (temp != 0) {
23             digits++;
24             temp /= 10;
25         }
26         bytes memory buffer = new bytes(digits);
27         while (value != 0) {
28             digits -= 1;
29             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
30             value /= 10;
31         }
32         return string(buffer);
33     }
34 
35     /**
36      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
37      */
38     function toHexString(uint256 value) internal pure returns (string memory) {
39         if (value == 0) {
40             return "0x00";
41         }
42         uint256 temp = value;
43         uint256 length = 0;
44         while (temp != 0) {
45             length++;
46             temp >>= 8;
47         }
48         return toHexString(value, length);
49     }
50 
51     /**
52      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
53      */
54     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
55         bytes memory buffer = new bytes(2 * length + 2);
56         buffer[0] = "0";
57         buffer[1] = "x";
58         for (uint256 i = 2 * length + 1; i > 1; --i) {
59             buffer[i] = _HEX_SYMBOLS[value & 0xf];
60             value >>= 4;
61         }
62         require(value == 0, "Strings: hex length insufficient");
63         return string(buffer);
64     }
65 }
66 // File: ECDSA.sol
67 
68 
69 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
70 
71 pragma solidity ^0.8.0;
72 
73 
74 /**
75  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
76  *
77  * These functions can be used to verify that a message was signed by the holder
78  * of the private keys of a given address.
79  */
80 library ECDSA {
81     enum RecoverError {
82         NoError,
83         InvalidSignature,
84         InvalidSignatureLength,
85         InvalidSignatureS,
86         InvalidSignatureV
87     }
88 
89     function _throwError(RecoverError error) private pure {
90         if (error == RecoverError.NoError) {
91             return; // no error: do nothing
92         } else if (error == RecoverError.InvalidSignature) {
93             revert("ECDSA: invalid signature");
94         } else if (error == RecoverError.InvalidSignatureLength) {
95             revert("ECDSA: invalid signature length");
96         } else if (error == RecoverError.InvalidSignatureS) {
97             revert("ECDSA: invalid signature 's' value");
98         } else if (error == RecoverError.InvalidSignatureV) {
99             revert("ECDSA: invalid signature 'v' value");
100         }
101     }
102 
103     /**
104      * @dev Returns the address that signed a hashed message (`hash`) with
105      * `signature` or error string. This address can then be used for verification purposes.
106      *
107      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
108      * this function rejects them by requiring the `s` value to be in the lower
109      * half order, and the `v` value to be either 27 or 28.
110      *
111      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
112      * verification to be secure: it is possible to craft signatures that
113      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
114      * this is by receiving a hash of the original message (which may otherwise
115      * be too long), and then calling {toEthSignedMessageHash} on it.
116      *
117      * Documentation for signature generation:
118      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
119      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
120      *
121      * _Available since v4.3._
122      */
123     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
124         // Check the signature length
125         // - case 65: r,s,v signature (standard)
126         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
127         if (signature.length == 65) {
128             bytes32 r;
129             bytes32 s;
130             uint8 v;
131             // ecrecover takes the signature parameters, and the only way to get them
132             // currently is to use assembly.
133             assembly {
134                 r := mload(add(signature, 0x20))
135                 s := mload(add(signature, 0x40))
136                 v := byte(0, mload(add(signature, 0x60)))
137             }
138             return tryRecover(hash, v, r, s);
139         } else if (signature.length == 64) {
140             bytes32 r;
141             bytes32 vs;
142             // ecrecover takes the signature parameters, and the only way to get them
143             // currently is to use assembly.
144             assembly {
145                 r := mload(add(signature, 0x20))
146                 vs := mload(add(signature, 0x40))
147             }
148             return tryRecover(hash, r, vs);
149         } else {
150             return (address(0), RecoverError.InvalidSignatureLength);
151         }
152     }
153 
154     /**
155      * @dev Returns the address that signed a hashed message (`hash`) with
156      * `signature`. This address can then be used for verification purposes.
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
167      */
168     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
169         (address recovered, RecoverError error) = tryRecover(hash, signature);
170         _throwError(error);
171         return recovered;
172     }
173 
174     /**
175      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
176      *
177      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
178      *
179      * _Available since v4.3._
180      */
181     function tryRecover(
182         bytes32 hash,
183         bytes32 r,
184         bytes32 vs
185     ) internal pure returns (address, RecoverError) {
186         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
187         uint8 v = uint8((uint256(vs) >> 255) + 27);
188         return tryRecover(hash, v, r, s);
189     }
190 
191     /**
192      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
193      *
194      * _Available since v4.2._
195      */
196     function recover(
197         bytes32 hash,
198         bytes32 r,
199         bytes32 vs
200     ) internal pure returns (address) {
201         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
202         _throwError(error);
203         return recovered;
204     }
205 
206     /**
207      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
208      * `r` and `s` signature fields separately.
209      *
210      * _Available since v4.3._
211      */
212     function tryRecover(
213         bytes32 hash,
214         uint8 v,
215         bytes32 r,
216         bytes32 s
217     ) internal pure returns (address, RecoverError) {
218         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
219         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
220         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
221         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
222         //
223         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
224         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
225         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
226         // these malleable signatures as well.
227         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
228             return (address(0), RecoverError.InvalidSignatureS);
229         }
230         if (v != 27 && v != 28) {
231             return (address(0), RecoverError.InvalidSignatureV);
232         }
233 
234         // If the signature is valid (and not malleable), return the signer address
235         address signer = ecrecover(hash, v, r, s);
236         if (signer == address(0)) {
237             return (address(0), RecoverError.InvalidSignature);
238         }
239 
240         return (signer, RecoverError.NoError);
241     }
242 
243     /**
244      * @dev Overload of {ECDSA-recover} that receives the `v`,
245      * `r` and `s` signature fields separately.
246      */
247     function recover(
248         bytes32 hash,
249         uint8 v,
250         bytes32 r,
251         bytes32 s
252     ) internal pure returns (address) {
253         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
254         _throwError(error);
255         return recovered;
256     }
257 
258     /**
259      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
260      * produces hash corresponding to the one signed with the
261      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
262      * JSON-RPC method as part of EIP-191.
263      *
264      * See {recover}.
265      */
266     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
267         // 32 is the length in bytes of hash,
268         // enforced by the type signature above
269         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
270     }
271 
272     /**
273      * @dev Returns an Ethereum Signed Message, created from `s`. This
274      * produces hash corresponding to the one signed with the
275      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
276      * JSON-RPC method as part of EIP-191.
277      *
278      * See {recover}.
279      */
280     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
281         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
282     }
283 
284     /**
285      * @dev Returns an Ethereum Signed Typed Data, created from a
286      * `domainSeparator` and a `structHash`. This produces hash corresponding
287      * to the one signed with the
288      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
289      * JSON-RPC method as part of EIP-712.
290      *
291      * See {recover}.
292      */
293     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
294         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
295     }
296 }
297 // File: Context.sol
298 
299 
300 
301 pragma solidity ^0.8.0;
302 
303 /**
304  * @dev Provides information about the current execution context, including the
305  * sender of the transaction and its data. While these are generally available
306  * via msg.sender and msg.data, they should not be accessed in such a direct
307  * manner, since when dealing with meta-transactions the account sending and
308  * paying for execution may not be the actual sender (as far as an application
309  * is concerned).
310  *
311  * This contract is only required for intermediate, library-like contracts.
312  */
313 abstract contract Context {
314     function _msgSender() internal view virtual returns (address) {
315         return msg.sender;
316     }
317 
318     function _msgData() internal view virtual returns (bytes calldata) {
319         return msg.data;
320     }
321 }
322 // File: Ownable.sol
323 
324 
325 
326 pragma solidity ^0.8.0;
327 
328 
329 /**
330  * @dev Contract module which provides a basic access control mechanism, where
331  * there is an account (an owner) that can be granted exclusive access to
332  * specific functions.
333  *
334  * By default, the owner account will be the one that deploys the contract. This
335  * can later be changed with {transferOwnership}.
336  *
337  * This module is used through inheritance. It will make available the modifier
338  * `onlyOwner`, which can be applied to your functions to restrict their use to
339  * the owner.
340  */
341 abstract contract Ownable is Context {
342     address private _owner;
343 
344     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
345 
346     /**
347      * @dev Initializes the contract setting the deployer as the initial owner.
348      */
349     constructor() {
350         _setOwner(_msgSender());
351     }
352 
353     /**
354      * @dev Returns the address of the current owner.
355      */
356     function owner() public view virtual returns (address) {
357         return _owner;
358     }
359 
360     /**
361      * @dev Throws if called by any account other than the owner.
362      */
363     modifier onlyOwner() {
364         require(owner() == _msgSender(), "Ownable: caller is not the owner");
365         _;
366     }
367 
368     /**
369      * @dev Leaves the contract without owner. It will not be possible to call
370      * `onlyOwner` functions anymore. Can only be called by the current owner.
371      *
372      * NOTE: Renouncing ownership will leave the contract without an owner,
373      * thereby removing any functionality that is only available to the owner.
374      */
375     function renounceOwnership() public virtual onlyOwner {
376         _setOwner(address(0));
377     }
378 
379     /**
380      * @dev Transfers ownership of the contract to a new account (`newOwner`).
381      * Can only be called by the current owner.
382      */
383     function transferOwnership(address newOwner) public virtual onlyOwner {
384         require(newOwner != address(0), "Ownable: new owner is the zero address");
385         _setOwner(newOwner);
386     }
387 
388     function _setOwner(address newOwner) private {
389         address oldOwner = _owner;
390         _owner = newOwner;
391         emit OwnershipTransferred(oldOwner, newOwner);
392     }
393 }
394 // File: Address.sol
395 
396 
397 
398 pragma solidity ^0.8.0;
399 
400 /**
401  * @dev Collection of functions related to the address type
402  */
403 library Address {
404     /**
405      * @dev Returns true if `account` is a contract.
406      *
407      * [IMPORTANT]
408      * ====
409      * It is unsafe to assume that an address for which this function returns
410      * false is an externally-owned account (EOA) and not a contract.
411      *
412      * Among others, `isContract` will return false for the following
413      * types of addresses:
414      *
415      *  - an externally-owned account
416      *  - a contract in construction
417      *  - an address where a contract will be created
418      *  - an address where a contract lived, but was destroyed
419      * ====
420      */
421     function isContract(address account) internal view returns (bool) {
422         // This method relies on extcodesize, which returns 0 for contracts in
423         // construction, since the code is only stored at the end of the
424         // constructor execution.
425 
426         uint256 size;
427         assembly {
428             size := extcodesize(account)
429         }
430         return size > 0;
431     }
432 
433     /**
434      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
435      * `recipient`, forwarding all available gas and reverting on errors.
436      *
437      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
438      * of certain opcodes, possibly making contracts go over the 2300 gas limit
439      * imposed by `transfer`, making them unable to receive funds via
440      * `transfer`. {sendValue} removes this limitation.
441      *
442      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
443      *
444      * IMPORTANT: because control is transferred to `recipient`, care must be
445      * taken to not create reentrancy vulnerabilities. Consider using
446      * {ReentrancyGuard} or the
447      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
448      */
449     function sendValue(address payable recipient, uint256 amount) internal {
450         require(address(this).balance >= amount, "Address: insufficient balance");
451 
452         (bool success, ) = recipient.call{value: amount}("");
453         require(success, "Address: unable to send value, recipient may have reverted");
454     }
455 
456     /**
457      * @dev Performs a Solidity function call using a low level `call`. A
458      * plain `call` is an unsafe replacement for a function call: use this
459      * function instead.
460      *
461      * If `target` reverts with a revert reason, it is bubbled up by this
462      * function (like regular Solidity function calls).
463      *
464      * Returns the raw returned data. To convert to the expected return value,
465      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
466      *
467      * Requirements:
468      *
469      * - `target` must be a contract.
470      * - calling `target` with `data` must not revert.
471      *
472      * _Available since v3.1._
473      */
474     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
475         return functionCall(target, data, "Address: low-level call failed");
476     }
477 
478     /**
479      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
480      * `errorMessage` as a fallback revert reason when `target` reverts.
481      *
482      * _Available since v3.1._
483      */
484     function functionCall(
485         address target,
486         bytes memory data,
487         string memory errorMessage
488     ) internal returns (bytes memory) {
489         return functionCallWithValue(target, data, 0, errorMessage);
490     }
491 
492     /**
493      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
494      * but also transferring `value` wei to `target`.
495      *
496      * Requirements:
497      *
498      * - the calling contract must have an ETH balance of at least `value`.
499      * - the called Solidity function must be `payable`.
500      *
501      * _Available since v3.1._
502      */
503     function functionCallWithValue(
504         address target,
505         bytes memory data,
506         uint256 value
507     ) internal returns (bytes memory) {
508         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
509     }
510 
511     /**
512      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
513      * with `errorMessage` as a fallback revert reason when `target` reverts.
514      *
515      * _Available since v3.1._
516      */
517     function functionCallWithValue(
518         address target,
519         bytes memory data,
520         uint256 value,
521         string memory errorMessage
522     ) internal returns (bytes memory) {
523         require(address(this).balance >= value, "Address: insufficient balance for call");
524         require(isContract(target), "Address: call to non-contract");
525 
526         (bool success, bytes memory returndata) = target.call{value: value}(data);
527         return _verifyCallResult(success, returndata, errorMessage);
528     }
529 
530     /**
531      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
532      * but performing a static call.
533      *
534      * _Available since v3.3._
535      */
536     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
537         return functionStaticCall(target, data, "Address: low-level static call failed");
538     }
539 
540     /**
541      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
542      * but performing a static call.
543      *
544      * _Available since v3.3._
545      */
546     function functionStaticCall(
547         address target,
548         bytes memory data,
549         string memory errorMessage
550     ) internal view returns (bytes memory) {
551         require(isContract(target), "Address: static call to non-contract");
552 
553         (bool success, bytes memory returndata) = target.staticcall(data);
554         return _verifyCallResult(success, returndata, errorMessage);
555     }
556 
557     /**
558      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
559      * but performing a delegate call.
560      *
561      * _Available since v3.4._
562      */
563     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
564         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
565     }
566 
567     /**
568      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
569      * but performing a delegate call.
570      *
571      * _Available since v3.4._
572      */
573     function functionDelegateCall(
574         address target,
575         bytes memory data,
576         string memory errorMessage
577     ) internal returns (bytes memory) {
578         require(isContract(target), "Address: delegate call to non-contract");
579 
580         (bool success, bytes memory returndata) = target.delegatecall(data);
581         return _verifyCallResult(success, returndata, errorMessage);
582     }
583 
584     function _verifyCallResult(
585         bool success,
586         bytes memory returndata,
587         string memory errorMessage
588     ) private pure returns (bytes memory) {
589         if (success) {
590             return returndata;
591         } else {
592             // Look for revert reason and bubble it up if present
593             if (returndata.length > 0) {
594                 // The easiest way to bubble the revert reason is using memory via assembly
595 
596                 assembly {
597                     let returndata_size := mload(returndata)
598                     revert(add(32, returndata), returndata_size)
599                 }
600             } else {
601                 revert(errorMessage);
602             }
603         }
604     }
605 }
606 // File: Payment.sol
607 
608 
609 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
610 
611 pragma solidity ^0.8.0;
612 
613 
614 
615 /**
616  * @title PaymentSplitter
617  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
618  * that the Ether will be split in this way, since it is handled transparently by the contract.
619  *
620  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
621  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
622  * an amount proportional to the percentage of total shares they were assigned.
623  *
624  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
625  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
626  * function.
627  *
628  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
629  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
630  * to run tests before sending real value to this contract.
631  */
632 contract Payment is Context {
633     event PayeeAdded(address account, uint256 shares);
634     event PaymentReleased(address to, uint256 amount);
635     event PaymentReceived(address from, uint256 amount);
636 
637     uint256 private _totalShares;
638     uint256 private _totalReleased;
639 
640     mapping(address => uint256) private _shares;
641     mapping(address => uint256) private _released;
642     address[] private _payees;
643 
644     /**
645      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
646      * the matching position in the `shares` array.
647      *
648      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
649      * duplicates in `payees`.
650      */
651     constructor(address[] memory payees, uint256[] memory shares_) payable {
652         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
653         require(payees.length > 0, "PaymentSplitter: no payees");
654 
655         for (uint256 i = 0; i < payees.length; i++) {
656             _addPayee(payees[i], shares_[i]);
657         }
658     }
659 
660     /**
661      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
662      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
663      * reliability of the events, and not the actual splitting of Ether.
664      *
665      * To learn more about this see the Solidity documentation for
666      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
667      * functions].
668      */
669     receive() external payable virtual {
670         emit PaymentReceived(_msgSender(), msg.value);
671     }
672 
673     /**
674      * @dev Getter for the total shares held by payees.
675      */
676     function totalShares() public view returns (uint256) {
677         return _totalShares;
678     }
679 
680     /**
681      * @dev Getter for the total amount of Ether already released.
682      */
683     function totalReleased() public view returns (uint256) {
684         return _totalReleased;
685     }
686 
687 
688     /**
689      * @dev Getter for the amount of shares held by an account.
690      */
691     function shares(address account) public view returns (uint256) {
692         return _shares[account];
693     }
694 
695     /**
696      * @dev Getter for the amount of Ether already released to a payee.
697      */
698     function released(address account) public view returns (uint256) {
699         return _released[account];
700     }
701 
702 
703     /**
704      * @dev Getter for the address of the payee number `index`.
705      */
706     function payee(uint256 index) public view returns (address) {
707         return _payees[index];
708     }
709 
710     /**
711      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
712      * total shares and their previous withdrawals.
713      */
714     function release(address payable account) public virtual {
715         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
716 
717         uint256 totalReceived = address(this).balance + totalReleased();
718         uint256 payment = _pendingPayment(account, totalReceived, released(account));
719 
720         require(payment != 0, "PaymentSplitter: account is not due payment");
721 
722         _released[account] += payment;
723         _totalReleased += payment;
724 
725         Address.sendValue(account, payment);
726         emit PaymentReleased(account, payment);
727     }
728 
729 
730     /**
731      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
732      * already released amounts.
733      */
734     function _pendingPayment(
735         address account,
736         uint256 totalReceived,
737         uint256 alreadyReleased
738     ) private view returns (uint256) {
739         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
740     }
741 
742     /**
743      * @dev Add a new payee to the contract.
744      * @param account The address of the payee to add.
745      * @param shares_ The number of shares owned by the payee.
746      */
747     function _addPayee(address account, uint256 shares_) private {
748         require(account != address(0), "PaymentSplitter: account is the zero address");
749         require(shares_ > 0, "PaymentSplitter: shares are 0");
750         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
751 
752         _payees.push(account);
753         _shares[account] = shares_;
754         _totalShares = _totalShares + shares_;
755         emit PayeeAdded(account, shares_);
756     }
757 }
758 // File: IERC721Receiver.sol
759 
760 
761 
762 pragma solidity ^0.8.0;
763 
764 /**
765  * @title ERC721 token receiver interface
766  * @dev Interface for any contract that wants to support safeTransfers
767  * from ERC721 asset contracts.
768  */
769 interface IERC721Receiver {
770     /**
771      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
772      * by `operator` from `from`, this function is called.
773      *
774      * It must return its Solidity selector to confirm the token transfer.
775      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
776      *
777      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
778      */
779     function onERC721Received(
780         address operator,
781         address from,
782         uint256 tokenId,
783         bytes calldata data
784     ) external returns (bytes4);
785 }
786 // File: IERC165.sol
787 
788 
789 
790 pragma solidity ^0.8.0;
791 
792 /**
793  * @dev Interface of the ERC165 standard, as defined in the
794  * https://eips.ethereum.org/EIPS/eip-165[EIP].
795  *
796  * Implementers can declare support of contract interfaces, which can then be
797  * queried by others ({ERC165Checker}).
798  *
799  * For an implementation, see {ERC165}.
800  */
801 interface IERC165 {
802     /**
803      * @dev Returns true if this contract implements the interface defined by
804      * `interfaceId`. See the corresponding
805      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
806      * to learn more about how these ids are created.
807      *
808      * This function call must use less than 30 000 gas.
809      */
810     function supportsInterface(bytes4 interfaceId) external view returns (bool);
811 }
812 // File: ERC165.sol
813 
814 
815 
816 pragma solidity ^0.8.0;
817 
818 
819 /**
820  * @dev Implementation of the {IERC165} interface.
821  *
822  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
823  * for the additional interface id that will be supported. For example:
824  *
825  * ```solidity
826  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
827  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
828  * }
829  * ```
830  *
831  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
832  */
833 abstract contract ERC165 is IERC165 {
834     /**
835      * @dev See {IERC165-supportsInterface}.
836      */
837     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
838         return interfaceId == type(IERC165).interfaceId;
839     }
840 }
841 // File: IERC721.sol
842 
843 
844 
845 pragma solidity ^0.8.0;
846 
847 
848 /**
849  * @dev Required interface of an ERC721 compliant contract.
850  */
851 interface IERC721 is IERC165 {
852     /**
853      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
854      */
855     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
856 
857     /**
858      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
859      */
860     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
861 
862     /**
863      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
864      */
865     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
866 
867     /**
868      * @dev Returns the number of tokens in ``owner``'s account.
869      */
870     function balanceOf(address owner) external view returns (uint256 balance);
871 
872     /**
873      * @dev Returns the owner of the `tokenId` token.
874      *
875      * Requirements:
876      *
877      * - `tokenId` must exist.
878      */
879     function ownerOf(uint256 tokenId) external view returns (address owner);
880 
881     /**
882      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
883      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
884      *
885      * Requirements:
886      *
887      * - `from` cannot be the zero address.
888      * - `to` cannot be the zero address.
889      * - `tokenId` token must exist and be owned by `from`.
890      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
891      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
892      *
893      * Emits a {Transfer} event.
894      */
895     function safeTransferFrom(
896         address from,
897         address to,
898         uint256 tokenId
899     ) external;
900 
901     /**
902      * @dev Transfers `tokenId` token from `from` to `to`.
903      *
904      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
905      *
906      * Requirements:
907      *
908      * - `from` cannot be the zero address.
909      * - `to` cannot be the zero address.
910      * - `tokenId` token must be owned by `from`.
911      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
912      *
913      * Emits a {Transfer} event.
914      */
915     function transferFrom(
916         address from,
917         address to,
918         uint256 tokenId
919     ) external;
920 
921     /**
922      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
923      * The approval is cleared when the token is transferred.
924      *
925      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
926      *
927      * Requirements:
928      *
929      * - The caller must own the token or be an approved operator.
930      * - `tokenId` must exist.
931      *
932      * Emits an {Approval} event.
933      */
934     function approve(address to, uint256 tokenId) external;
935 
936     /**
937      * @dev Returns the account approved for `tokenId` token.
938      *
939      * Requirements:
940      *
941      * - `tokenId` must exist.
942      */
943     function getApproved(uint256 tokenId) external view returns (address operator);
944 
945     /**
946      * @dev Approve or remove `operator` as an operator for the caller.
947      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
948      *
949      * Requirements:
950      *
951      * - The `operator` cannot be the caller.
952      *
953      * Emits an {ApprovalForAll} event.
954      */
955     function setApprovalForAll(address operator, bool _approved) external;
956 
957     /**
958      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
959      *
960      * See {setApprovalForAll}
961      */
962     function isApprovedForAll(address owner, address operator) external view returns (bool);
963 
964     /**
965      * @dev Safely transfers `tokenId` token from `from` to `to`.
966      *
967      * Requirements:
968      *
969      * - `from` cannot be the zero address.
970      * - `to` cannot be the zero address.
971      * - `tokenId` token must exist and be owned by `from`.
972      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
973      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
974      *
975      * Emits a {Transfer} event.
976      */
977     function safeTransferFrom(
978         address from,
979         address to,
980         uint256 tokenId,
981         bytes calldata data
982     ) external;
983 }
984 // File: IERC721Enumerable.sol
985 
986 
987 
988 pragma solidity ^0.8.0;
989 
990 
991 /**
992  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
993  * @dev See https://eips.ethereum.org/EIPS/eip-721
994  */
995 interface IERC721Enumerable is IERC721 {
996     /**
997      * @dev Returns the total amount of tokens stored by the contract.
998      */
999     function totalSupply() external view returns (uint256);
1000 
1001     /**
1002      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1003      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1004      */
1005     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1006 
1007     /**
1008      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1009      * Use along with {totalSupply} to enumerate all tokens.
1010      */
1011     function tokenByIndex(uint256 index) external view returns (uint256);
1012 }
1013 // File: IERC721Metadata.sol
1014 
1015 
1016 
1017 pragma solidity ^0.8.0;
1018 
1019 
1020 /**
1021  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1022  * @dev See https://eips.ethereum.org/EIPS/eip-721
1023  */
1024 interface IERC721Metadata is IERC721 {
1025     /**
1026      * @dev Returns the token collection name.
1027      */
1028     function name() external view returns (string memory);
1029 
1030     /**
1031      * @dev Returns the token collection symbol.
1032      */
1033     function symbol() external view returns (string memory);
1034 
1035     /**
1036      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1037      */
1038     function tokenURI(uint256 tokenId) external view returns (string memory);
1039 }
1040 // File: ERC721A.sol
1041 
1042 
1043 pragma solidity ^0.8.0;
1044 
1045 
1046 
1047 
1048 
1049 
1050 
1051 
1052 
1053 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1054     using Address for address;
1055     using Strings for uint256;
1056 
1057     struct TokenOwnership {
1058         address addr;
1059         uint64 startTimestamp;
1060     }
1061 
1062     struct AddressData {
1063         uint128 balance;
1064         uint128 numberMinted;
1065     }
1066 
1067     uint256 internal currentIndex;
1068 
1069     // Token name
1070     string private _name;
1071 
1072     // Token symbol
1073     string private _symbol;
1074 
1075     // Mapping from token ID to ownership details
1076     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1077     mapping(uint256 => TokenOwnership) internal _ownerships;
1078 
1079     // Mapping owner address to address data
1080     mapping(address => AddressData) private _addressData;
1081 
1082     // Mapping from token ID to approved address
1083     mapping(uint256 => address) private _tokenApprovals;
1084 
1085     // Mapping from owner to operator approvals
1086     mapping(address => mapping(address => bool)) private _operatorApprovals;
1087 
1088     constructor(string memory name_, string memory symbol_) {
1089         _name = name_;
1090         _symbol = symbol_;
1091     }
1092 
1093     /**
1094      * @dev See {IERC721Enumerable-totalSupply}.
1095      */
1096     function totalSupply() public view override returns (uint256) {
1097         return currentIndex;
1098     }
1099 
1100     /**
1101      * @dev See {IERC721Enumerable-tokenByIndex}.
1102      */
1103     function tokenByIndex(uint256 index) public view override returns (uint256) {
1104         require(index < totalSupply(), 'ERC721A: global index out of bounds');
1105         return index;
1106     }
1107 
1108     /**
1109      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1110      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1111      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1112      */
1113     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1114         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
1115         uint256 numMintedSoFar = totalSupply();
1116         uint256 tokenIdsIdx;
1117         address currOwnershipAddr;
1118 
1119         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1120         unchecked {
1121             for (uint256 i; i < numMintedSoFar; i++) {
1122                 TokenOwnership memory ownership = _ownerships[i];
1123                 if (ownership.addr != address(0)) {
1124                     currOwnershipAddr = ownership.addr;
1125                 }
1126                 if (currOwnershipAddr == owner) {
1127                     if (tokenIdsIdx == index) {
1128                         return i;
1129                     }
1130                     tokenIdsIdx++;
1131                 }
1132             }
1133         }
1134 
1135         revert('ERC721A: unable to get token of owner by index');
1136     }
1137 
1138     /**
1139      * @dev See {IERC165-supportsInterface}.
1140      */
1141     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1142         return
1143             interfaceId == type(IERC721).interfaceId ||
1144             interfaceId == type(IERC721Metadata).interfaceId ||
1145             interfaceId == type(IERC721Enumerable).interfaceId ||
1146             super.supportsInterface(interfaceId);
1147     }
1148 
1149     /**
1150      * @dev See {IERC721-balanceOf}.
1151      */
1152     function balanceOf(address owner) public view override returns (uint256) {
1153         require(owner != address(0), 'ERC721A: balance query for the zero address');
1154         return uint256(_addressData[owner].balance);
1155     }
1156 
1157     function _numberMinted(address owner) internal view returns (uint256) {
1158         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1159         return uint256(_addressData[owner].numberMinted);
1160     }
1161 
1162     /**
1163      * Gas spent here starts off proportional to the maximum mint batch size.
1164      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1165      */
1166     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1167         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1168 
1169         unchecked {
1170             for (uint256 curr = tokenId; curr >= 0; curr--) {
1171                 TokenOwnership memory ownership = _ownerships[curr];
1172                 if (ownership.addr != address(0)) {
1173                     return ownership;
1174                 }
1175             }
1176         }
1177 
1178         revert('ERC721A: unable to determine the owner of token');
1179     }
1180 
1181     /**
1182      * @dev See {IERC721-ownerOf}.
1183      */
1184     function ownerOf(uint256 tokenId) public view override returns (address) {
1185         return ownershipOf(tokenId).addr;
1186     }
1187 
1188     /**
1189      * @dev See {IERC721Metadata-name}.
1190      */
1191     function name() public view virtual override returns (string memory) {
1192         return _name;
1193     }
1194 
1195     /**
1196      * @dev See {IERC721Metadata-symbol}.
1197      */
1198     function symbol() public view virtual override returns (string memory) {
1199         return _symbol;
1200     }
1201 
1202     /**
1203      * @dev See {IERC721Metadata-tokenURI}.
1204      */
1205     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1206         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1207 
1208         string memory baseURI = _baseURI();
1209         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1210     }
1211 
1212     /**
1213      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1214      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1215      * by default, can be overriden in child contracts.
1216      */
1217     function _baseURI() internal view virtual returns (string memory) {
1218         return '';
1219     }
1220 
1221     /**
1222      * @dev See {IERC721-approve}.
1223      */
1224     function approve(address to, uint256 tokenId) public override {
1225         address owner = ERC721A.ownerOf(tokenId);
1226         require(to != owner, 'ERC721A: approval to current owner');
1227 
1228         require(
1229             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1230             'ERC721A: approve caller is not owner nor approved for all'
1231         );
1232 
1233         _approve(to, tokenId, owner);
1234     }
1235 
1236     /**
1237      * @dev See {IERC721-getApproved}.
1238      */
1239     function getApproved(uint256 tokenId) public view override returns (address) {
1240         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1241 
1242         return _tokenApprovals[tokenId];
1243     }
1244 
1245     /**
1246      * @dev See {IERC721-setApprovalForAll}.
1247      */
1248     function setApprovalForAll(address operator, bool approved) public override {
1249         require(operator != _msgSender(), 'ERC721A: approve to caller');
1250 
1251         _operatorApprovals[_msgSender()][operator] = approved;
1252         emit ApprovalForAll(_msgSender(), operator, approved);
1253     }
1254 
1255     /**
1256      * @dev See {IERC721-isApprovedForAll}.
1257      */
1258     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1259         return _operatorApprovals[owner][operator];
1260     }
1261 
1262     /**
1263      * @dev See {IERC721-transferFrom}.
1264      */
1265     function transferFrom(
1266         address from,
1267         address to,
1268         uint256 tokenId
1269     ) public override {
1270         _transfer(from, to, tokenId);
1271     }
1272 
1273     /**
1274      * @dev See {IERC721-safeTransferFrom}.
1275      */
1276     function safeTransferFrom(
1277         address from,
1278         address to,
1279         uint256 tokenId
1280     ) public override {
1281         safeTransferFrom(from, to, tokenId, '');
1282     }
1283 
1284     /**
1285      * @dev See {IERC721-safeTransferFrom}.
1286      */
1287     function safeTransferFrom(
1288         address from,
1289         address to,
1290         uint256 tokenId,
1291         bytes memory _data
1292     ) public override {
1293         _transfer(from, to, tokenId);
1294         require(
1295             _checkOnERC721Received(from, to, tokenId, _data),
1296             'ERC721A: transfer to non ERC721Receiver implementer'
1297         );
1298     }
1299 
1300     /**
1301      * @dev Returns whether `tokenId` exists.
1302      *
1303      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1304      *
1305      * Tokens start existing when they are minted (`_mint`),
1306      */
1307     function _exists(uint256 tokenId) internal view returns (bool) {
1308         return tokenId < currentIndex;
1309     }
1310 
1311     function _safeMint(address to, uint256 quantity) internal {
1312         _safeMint(to, quantity, '');
1313     }
1314 
1315     /**
1316      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1317      *
1318      * Requirements:
1319      *
1320      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1321      * - `quantity` must be greater than 0.
1322      *
1323      * Emits a {Transfer} event.
1324      */
1325     function _safeMint(
1326         address to,
1327         uint256 quantity,
1328         bytes memory _data
1329     ) internal {
1330         _mint(to, quantity, _data, true);
1331     }
1332 
1333     /**
1334      * @dev Mints `quantity` tokens and transfers them to `to`.
1335      *
1336      * Requirements:
1337      *
1338      * - `to` cannot be the zero address.
1339      * - `quantity` must be greater than 0.
1340      *
1341      * Emits a {Transfer} event.
1342      */
1343     function _mint(
1344         address to,
1345         uint256 quantity,
1346         bytes memory _data,
1347         bool safe
1348     ) internal {
1349         uint256 startTokenId = currentIndex;
1350         require(to != address(0), 'ERC721A: mint to the zero address');
1351         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1352 
1353         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1354 
1355         // Overflows are incredibly unrealistic.
1356         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1357         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1358         unchecked {
1359             _addressData[to].balance += uint128(quantity);
1360             _addressData[to].numberMinted += uint128(quantity);
1361 
1362             _ownerships[startTokenId].addr = to;
1363             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1364 
1365             uint256 updatedIndex = startTokenId;
1366 
1367             for (uint256 i; i < quantity; i++) {
1368                 emit Transfer(address(0), to, updatedIndex);
1369                 if (safe) {
1370                     require(
1371                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1372                         'ERC721A: transfer to non ERC721Receiver implementer'
1373                     );
1374                 }
1375 
1376                 updatedIndex++;
1377             }
1378 
1379             currentIndex = updatedIndex;
1380         }
1381 
1382         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1383     }
1384 
1385     /**
1386      * @dev Transfers `tokenId` from `from` to `to`.
1387      *
1388      * Requirements:
1389      *
1390      * - `to` cannot be the zero address.
1391      * - `tokenId` token must be owned by `from`.
1392      *
1393      * Emits a {Transfer} event.
1394      */
1395     function _transfer(
1396         address from,
1397         address to,
1398         uint256 tokenId
1399     ) private {
1400         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1401 
1402         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1403             getApproved(tokenId) == _msgSender() ||
1404             isApprovedForAll(prevOwnership.addr, _msgSender()));
1405 
1406         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1407 
1408         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1409         require(to != address(0), 'ERC721A: transfer to the zero address');
1410 
1411         _beforeTokenTransfers(from, to, tokenId, 1);
1412 
1413         // Clear approvals from the previous owner
1414         _approve(address(0), tokenId, prevOwnership.addr);
1415 
1416         // Underflow of the sender's balance is impossible because we check for
1417         // ownership above and the recipient's balance can't realistically overflow.
1418         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1419         unchecked {
1420             _addressData[from].balance -= 1;
1421             _addressData[to].balance += 1;
1422 
1423             _ownerships[tokenId].addr = to;
1424             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1425 
1426             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1427             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1428             uint256 nextTokenId = tokenId + 1;
1429             if (_ownerships[nextTokenId].addr == address(0)) {
1430                 if (_exists(nextTokenId)) {
1431                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1432                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1433                 }
1434             }
1435         }
1436 
1437         emit Transfer(from, to, tokenId);
1438         _afterTokenTransfers(from, to, tokenId, 1);
1439     }
1440 
1441     /**
1442      * @dev Approve `to` to operate on `tokenId`
1443      *
1444      * Emits a {Approval} event.
1445      */
1446     function _approve(
1447         address to,
1448         uint256 tokenId,
1449         address owner
1450     ) private {
1451         _tokenApprovals[tokenId] = to;
1452         emit Approval(owner, to, tokenId);
1453     }
1454 
1455     /**
1456      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1457      * The call is not executed if the target address is not a contract.
1458      *
1459      * @param from address representing the previous owner of the given token ID
1460      * @param to target address that will receive the tokens
1461      * @param tokenId uint256 ID of the token to be transferred
1462      * @param _data bytes optional data to send along with the call
1463      * @return bool whether the call correctly returned the expected magic value
1464      */
1465     function _checkOnERC721Received(
1466         address from,
1467         address to,
1468         uint256 tokenId,
1469         bytes memory _data
1470     ) private returns (bool) {
1471         if (to.isContract()) {
1472             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1473                 return retval == IERC721Receiver(to).onERC721Received.selector;
1474             } catch (bytes memory reason) {
1475                 if (reason.length == 0) {
1476                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1477                 } else {
1478                     assembly {
1479                         revert(add(32, reason), mload(reason))
1480                     }
1481                 }
1482             }
1483         } else {
1484             return true;
1485         }
1486     }
1487 
1488     /**
1489      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1490      *
1491      * startTokenId - the first token id to be transferred
1492      * quantity - the amount to be transferred
1493      *
1494      * Calling conditions:
1495      *
1496      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1497      * transferred to `to`.
1498      * - When `from` is zero, `tokenId` will be minted for `to`.
1499      */
1500     function _beforeTokenTransfers(
1501         address from,
1502         address to,
1503         uint256 startTokenId,
1504         uint256 quantity
1505     ) internal virtual {}
1506 
1507     /**
1508      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1509      * minting.
1510      *
1511      * startTokenId - the first token id to be transferred
1512      * quantity - the amount to be transferred
1513      *
1514      * Calling conditions:
1515      *
1516      * - when `from` and `to` are both non-zero.
1517      * - `from` and `to` are never both zero.
1518      */
1519     function _afterTokenTransfers(
1520         address from,
1521         address to,
1522         uint256 startTokenId,
1523         uint256 quantity
1524     ) internal virtual {}
1525 }
1526 
1527 pragma solidity ^0.8.2;
1528  
1529 contract GahrDecades is ERC721A, Ownable, Payment { 
1530    using Strings for uint256;
1531    string public _baseURIextended;
1532  
1533    // Wave States
1534    bool public isWave1Active = false;
1535    bool public isWave2Active = false;
1536    bool public isWave3Active = false;
1537  
1538    //signatures
1539    address private Wave1Tsigner = 0xE30556880fc248337878AD46A1cEE81381491A92;
1540    address private Wave1Csigner = 0xd42ddAF9450cD7afBA83DDbdE6DCeFf07AD0e153;
1541    address private Wave2signer = 0x573aA43792D89E452417805Da6DCF097D07f58E8;
1542  
1543    //settings
1544    uint256 public MAX_SUPPLY = 4000;
1545    uint256 public PRICE_PER_TOKEN = 0.09 ether;
1546   
1547    //wave1
1548    uint256 private maxMintPerWalletWave1_TRUTH = 3;
1549    uint256 private maxMintPerWalletWave1_COMMUNITY = 1;
1550  
1551    //wave2
1552    uint256 private maxMintPerWalletWave2 = 3;
1553  
1554    //wave3
1555    uint256 private maxMintPerTxWave3 = 10;
1556  
1557    //shares
1558    address[] private addressList = [
1559    0x59A0191C177C9b11730092b80fd35CF9fB78e0fE,
1560    0xb6D9774842A298456596e6344c742D2990875243,
1561    0xA5f81fEE746daaf23448cA59ff0d0895b62865b6,
1562    0x0Aa1F3d61e7c325aE795737266c5FD6839819b86
1563    ];
1564  
1565    uint[] private shareList = [
1566    3350,
1567    1775,
1568    1575,
1569    3300
1570    ];
1571  
1572    //mappings
1573    mapping(address => uint256) public numMintedPerPersonWave1_TRUTH;
1574    mapping(address => uint256) public numMintedPerPersonWave1_COMMUNITY;
1575    mapping(address => uint256) public numMintedPerPersonWave2;
1576   
1577    constructor() ERC721A("GahrDecades", "GAHR") Payment(addressList, shareList) {}
1578  
1579    function mintWave1TRUTH(address _address, bytes calldata _voucher, uint256 _tokenAmount) external payable {
1580        uint256 ts = totalSupply();
1581        require(isWave1Active);
1582        require(_tokenAmount <= maxMintPerWalletWave1_TRUTH, "Purchase would exceed max tokens per tx in this Wave");
1583        require(ts + _tokenAmount <= MAX_SUPPLY, "Purchase would exceed max tokens");
1584        require(msg.value >= PRICE_PER_TOKEN * _tokenAmount, "Ether value sent is not correct");
1585        require(msg.sender == _address, "Not your voucher");
1586        require(msg.sender == tx.origin);
1587        require(numMintedPerPersonWave1_TRUTH[_address] + _tokenAmount <= maxMintPerWalletWave1_TRUTH, "Purchase would exceed max tokens per Wallet");
1588  
1589        bytes32 hash = keccak256(
1590            abi.encodePacked(_address)
1591        );
1592        require(_verifySignature(Wave1Tsigner, hash, _voucher), "Invalid voucher");
1593  
1594        _safeMint(_address, _tokenAmount);
1595        numMintedPerPersonWave1_TRUTH[_address] += _tokenAmount;
1596    }
1597  
1598    function mintWave1COMMUNITY(address _address, bytes calldata _voucher, uint256 _tokenAmount) external payable {
1599        uint256 ts = totalSupply();
1600        require(isWave1Active);
1601        require(_tokenAmount <= maxMintPerWalletWave1_COMMUNITY, "Purchase would exceed max tokens per tx in this wave");
1602        require(ts + _tokenAmount <= MAX_SUPPLY, "Purchase would exceed max tokens");
1603        require(msg.value >= PRICE_PER_TOKEN * _tokenAmount, "Ether value sent is not correct");
1604        require(msg.sender == _address, "Not your voucher");
1605        require(msg.sender == tx.origin);
1606        require(numMintedPerPersonWave1_COMMUNITY[_address] + _tokenAmount <= maxMintPerWalletWave1_COMMUNITY, "Purchase would exceed max tokens per Wallet");
1607  
1608        bytes32 hash = keccak256(
1609            abi.encodePacked(_address)
1610        );
1611        require(_verifySignature(Wave1Csigner, hash, _voucher), "Invalid voucher");
1612  
1613        _safeMint(_address, _tokenAmount);
1614        numMintedPerPersonWave1_COMMUNITY[_address] += _tokenAmount;
1615    }
1616  
1617    function mintWave2(address _address, bytes calldata _voucher, uint256 _tokenAmount) external payable {
1618            uint256 ts = totalSupply();
1619            require(isWave2Active);
1620            require(_tokenAmount <= maxMintPerWalletWave2, "Purchase would exceed max tokens per tx in this wave");
1621            require(ts + _tokenAmount <= MAX_SUPPLY, "Purchase would exceed max tokens");
1622            require(msg.value >= PRICE_PER_TOKEN * _tokenAmount, "Ether value sent is not correct");
1623            require(msg.sender == _address, "Not your voucher");
1624            require(msg.sender == tx.origin);
1625            require(numMintedPerPersonWave2[_address] + _tokenAmount <= maxMintPerWalletWave2, "Purchase would exceed max tokens per Wallet");
1626  
1627            bytes32 hash = keccak256(
1628                abi.encodePacked(_address)
1629            );
1630            require(_verifySignature(Wave2signer, hash, _voucher), "Invalid voucher");
1631  
1632            _safeMint(_address, _tokenAmount);
1633            numMintedPerPersonWave2[_address] += _tokenAmount;
1634        }
1635  
1636    function mintWave3(uint256 _tokenAmount) external payable {
1637            uint256 ts = totalSupply();
1638            require(isWave3Active);
1639            require(_tokenAmount <= maxMintPerTxWave3, "Purchase would exceed max tokens per tx in this wave");
1640            require(ts + _tokenAmount <= MAX_SUPPLY, "Purchase would exceed max tokens");
1641            require(msg.value >= PRICE_PER_TOKEN * _tokenAmount, "Ether value sent is not correct");
1642            require(msg.sender == tx.origin);
1643  
1644            _safeMint(msg.sender, _tokenAmount);
1645        }
1646  
1647    //airdrops
1648    function airdrop(address addr, uint256 _tokenAmount) public onlyOwner {
1649        uint256 ts = totalSupply();
1650        require(ts + _tokenAmount <= MAX_SUPPLY);
1651        _safeMint(addr, _tokenAmount);
1652    }
1653  
1654    //signatures
1655    function _verifySignature(address _signer, bytes32 _hash, bytes memory _signature) private pure returns (bool) {
1656        return _signer == ECDSA.recover(ECDSA.toEthSignedMessageHash(_hash), _signature);
1657    }
1658  
1659    function setWave1TSigner(address _signer) external onlyOwner {
1660        Wave1Tsigner = _signer;
1661    }
1662  
1663    function setWave1CSigner(address _signer) external onlyOwner {
1664        Wave1Csigner = _signer;
1665    }
1666  
1667    function setWave2Signer(address _signer) external onlyOwner {
1668        Wave2signer = _signer;
1669    }
1670  
1671    // Admin
1672    function setPrice(uint256 _newPrice) external onlyOwner {
1673        PRICE_PER_TOKEN = _newPrice;
1674    }
1675  
1676     function setWave1(bool _status) external onlyOwner {
1677        isWave1Active = _status;
1678    }
1679     function setWave2(bool _status) external onlyOwner {
1680        isWave2Active = _status;
1681    }
1682     function setWave3(bool _status) external onlyOwner {
1683        isWave3Active = _status;
1684    }
1685  
1686     // Max Per Wallet
1687    function setMaxMintPerWalletWave1TRUTH(uint256 _amount) external onlyOwner {
1688        maxMintPerWalletWave1_TRUTH = _amount;
1689    }
1690    function setMaxMintPerWalletWave1COMMUNITY(uint256 _amount) external onlyOwner {
1691        maxMintPerWalletWave1_COMMUNITY = _amount;
1692    }
1693    function setMaxMintPerWalletWave2(uint256 _amount) external onlyOwner {
1694        maxMintPerWalletWave2 = _amount;
1695    }
1696    function setMaxMintPerTxWave3(uint256 _amount) external onlyOwner {
1697        maxMintPerTxWave3 = _amount;
1698    }
1699  
1700    //metadata
1701    function setBaseURI(string memory baseURI_) external onlyOwner {
1702        _baseURIextended = baseURI_;
1703    }
1704  
1705    function _baseURI() internal view virtual override returns (string memory) {
1706        return _baseURIextended;
1707    }
1708  
1709    function withdraw() public payable onlyOwner {
1710    (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1711        require(success);
1712    }
1713 }