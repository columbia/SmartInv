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
1040 
1041 
1042 // ERC721A Contracts v4.0.0
1043 // Creator: Chiru Labs
1044 
1045 pragma solidity ^0.8.4;
1046 
1047 /**
1048  * @dev Interface of an ERC721A compliant contract.
1049  */
1050 interface IERC721A {
1051     /**
1052      * The caller must own the token or be an approved operator.
1053      */
1054     error ApprovalCallerNotOwnerNorApproved();
1055 
1056     /**
1057      * The token does not exist.
1058      */
1059     error ApprovalQueryForNonexistentToken();
1060 
1061     /**
1062      * The caller cannot approve to their own address.
1063      */
1064     error ApproveToCaller();
1065 
1066     /**
1067      * The caller cannot approve to the current owner.
1068      */
1069     error ApprovalToCurrentOwner();
1070 
1071     /**
1072      * Cannot query the balance for the zero address.
1073      */
1074     error BalanceQueryForZeroAddress();
1075 
1076     /**
1077      * Cannot mint to the zero address.
1078      */
1079     error MintToZeroAddress();
1080 
1081     /**
1082      * The quantity of tokens minted must be more than zero.
1083      */
1084     error MintZeroQuantity();
1085 
1086     /**
1087      * The token does not exist.
1088      */
1089     error OwnerQueryForNonexistentToken();
1090 
1091     /**
1092      * The caller must own the token or be an approved operator.
1093      */
1094     error TransferCallerNotOwnerNorApproved();
1095 
1096     /**
1097      * The token must be owned by `from`.
1098      */
1099     error TransferFromIncorrectOwner();
1100 
1101     /**
1102      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
1103      */
1104     error TransferToNonERC721ReceiverImplementer();
1105 
1106     /**
1107      * Cannot transfer to the zero address.
1108      */
1109     error TransferToZeroAddress();
1110 
1111     /**
1112      * The token does not exist.
1113      */
1114     error URIQueryForNonexistentToken();
1115 
1116     struct TokenOwnership {
1117         // The address of the owner.
1118         address addr;
1119         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1120         uint64 startTimestamp;
1121         // Whether the token has been burned.
1122         bool burned;
1123     }
1124 
1125     /**
1126      * @dev Returns the total amount of tokens stored by the contract.
1127      *
1128      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
1129      */
1130     function totalSupply() external view returns (uint256);
1131 
1132     // ==============================
1133     //            IERC165
1134     // ==============================
1135 
1136     /**
1137      * @dev Returns true if this contract implements the interface defined by
1138      * `interfaceId`. See the corresponding
1139      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1140      * to learn more about how these ids are created.
1141      *
1142      * This function call must use less than 30 000 gas.
1143      */
1144     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1145 
1146     // ==============================
1147     //            IERC721
1148     // ==============================
1149 
1150     /**
1151      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1152      */
1153     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1154 
1155     /**
1156      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1157      */
1158     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1159 
1160     /**
1161      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1162      */
1163     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1164 
1165     /**
1166      * @dev Returns the number of tokens in ``owner``'s account.
1167      */
1168     function balanceOf(address owner) external view returns (uint256 balance);
1169 
1170     /**
1171      * @dev Returns the owner of the `tokenId` token.
1172      *
1173      * Requirements:
1174      *
1175      * - `tokenId` must exist.
1176      */
1177     function ownerOf(uint256 tokenId) external view returns (address owner);
1178 
1179     
1180 
1181     /**
1182      * @dev Safely transfers `tokenId` token from `from` to `to`.
1183      *
1184      * Requirements:
1185      *
1186      * - `from` cannot be the zero address.
1187      * - `to` cannot be the zero address.
1188      * - `tokenId` token must exist and be owned by `from`.
1189      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1190      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1191      *
1192      * Emits a {Transfer} event.
1193      */
1194     function safeTransferFrom(
1195         address from,
1196         address to,
1197         uint256 tokenId,
1198         bytes calldata data
1199     ) external;
1200 
1201     /**
1202      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1203      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1204      *
1205      * Requirements:
1206      *
1207      * - `from` cannot be the zero address.
1208      * - `to` cannot be the zero address.
1209      * - `tokenId` token must exist and be owned by `from`.
1210      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1211      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1212      *
1213      * Emits a {Transfer} event.
1214      */
1215     function safeTransferFrom(
1216         address from,
1217         address to,
1218         uint256 tokenId
1219     ) external;
1220 
1221     /**
1222      * @dev Transfers `tokenId` token from `from` to `to`.
1223      *
1224      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1225      *
1226      * Requirements:
1227      *
1228      * - `from` cannot be the zero address.
1229      * - `to` cannot be the zero address.
1230      * - `tokenId` token must be owned by `from`.
1231      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1232      *
1233      * Emits a {Transfer} event.
1234      */
1235     function transferFrom(
1236         address from,
1237         address to,
1238         uint256 tokenId
1239     ) external;
1240 
1241     /**
1242      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1243      * The approval is cleared when the token is transferred.
1244      *
1245      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1246      *
1247      * Requirements:
1248      *
1249      * - The caller must own the token or be an approved operator.
1250      * - `tokenId` must exist.
1251      *
1252      * Emits an {Approval} event.
1253      */
1254     function approve(address to, uint256 tokenId) external;
1255 
1256     /**
1257      * @dev Approve or remove `operator` as an operator for the caller.
1258      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1259      *
1260      * Requirements:
1261      *
1262      * - The `operator` cannot be the caller.
1263      *
1264      * Emits an {ApprovalForAll} event.
1265      */
1266     function setApprovalForAll(address operator, bool _approved) external;
1267 
1268     /**
1269      * @dev Returns the account approved for `tokenId` token.
1270      *
1271      * Requirements:
1272      *
1273      * - `tokenId` must exist.
1274      */
1275     function getApproved(uint256 tokenId) external view returns (address operator);
1276 
1277     /**
1278      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1279      *
1280      * See {setApprovalForAll}
1281      */
1282     function isApprovedForAll(address owner, address operator) external view returns (bool);
1283 
1284     // ==============================
1285     //        IERC721Metadata
1286     // ==============================
1287 
1288     /**
1289      * @dev Returns the token collection name.
1290      */
1291     function name() external view returns (string memory);
1292 
1293     /**
1294      * @dev Returns the token collection symbol.
1295      */
1296     function symbol() external view returns (string memory);
1297 
1298     /**
1299      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1300      */
1301     function tokenURI(uint256 tokenId) external view returns (string memory);
1302 }
1303 
1304 
1305 // ERC721A Contracts v4.0.0
1306 // Creator: Chiru Labs
1307 
1308 pragma solidity ^0.8.4;
1309 
1310 
1311 /**
1312  * @dev ERC721 token receiver interface.
1313  */
1314 interface ERC721A__IERC721Receiver {
1315     function onERC721Received(
1316         address operator,
1317         address from,
1318         uint256 tokenId,
1319         bytes calldata data
1320     ) external returns (bytes4);
1321 }
1322 
1323 contract ERC721A is IERC721A {
1324     // Mask of an entry in packed address data.
1325     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1326 
1327     // The bit position of `numberMinted` in packed address data.
1328     uint256 private constant BITPOS_NUMBER_MINTED = 64;
1329 
1330     // The bit position of `numberBurned` in packed address data.
1331     uint256 private constant BITPOS_NUMBER_BURNED = 128;
1332 
1333     // The bit position of `aux` in packed address data.
1334     uint256 private constant BITPOS_AUX = 192;
1335 
1336     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1337     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1338 
1339     // The bit position of `startTimestamp` in packed ownership.
1340     uint256 private constant BITPOS_START_TIMESTAMP = 160;
1341 
1342     // The bit mask of the `burned` bit in packed ownership.
1343     uint256 private constant BITMASK_BURNED = 1 << 224;
1344 
1345     // The bit position of the `nextInitialized` bit in packed ownership.
1346     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
1347 
1348     // The bit mask of the `nextInitialized` bit in packed ownership.
1349     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
1350 
1351     // The tokenId of the next token to be minted.
1352     uint256 private _currentIndex;
1353 
1354     // The number of tokens burned.
1355     uint256 private _burnCounter;
1356 
1357     // Token name
1358     string private _name;
1359 
1360     // Token symbol
1361     string private _symbol;
1362 
1363     // Mapping from token ID to ownership details
1364     // An empty struct value does not necessarily mean the token is unowned.
1365     // See `_packedOwnershipOf` implementation for details.
1366     //
1367     // Bits Layout:
1368     // - [0..159]   `addr`
1369     // - [160..223] `startTimestamp`
1370     // - [224]      `burned`
1371     // - [225]      `nextInitialized`
1372     mapping(uint256 => uint256) private _packedOwnerships;
1373 
1374     // Mapping owner address to address data.
1375     //
1376     // Bits Layout:
1377     // - [0..63]    `balance`
1378     // - [64..127]  `numberMinted`
1379     // - [128..191] `numberBurned`
1380     // - [192..255] `aux`
1381     mapping(address => uint256) private _packedAddressData;
1382 
1383     // Mapping from token ID to approved address.
1384     mapping(uint256 => address) private _tokenApprovals;
1385 
1386     // Mapping from owner to operator approvals
1387     mapping(address => mapping(address => bool)) private _operatorApprovals;
1388 
1389     constructor(string memory name_, string memory symbol_) {
1390         _name = name_;
1391         _symbol = symbol_;
1392         _currentIndex = _startTokenId();
1393     }
1394 
1395     /**
1396      * @dev Returns the starting token ID.
1397      * To change the starting token ID, please override this function.
1398      */
1399     function _startTokenId() internal view virtual returns (uint256) {
1400         return 0;
1401     }
1402 
1403     /**
1404      * @dev Returns the next token ID to be minted.
1405      */
1406     function _nextTokenId() internal view returns (uint256) {
1407         return _currentIndex;
1408     }
1409 
1410     /**
1411      * @dev Returns the total number of tokens in existence.
1412      * Burned tokens will reduce the count.
1413      * To get the total number of tokens minted, please see `_totalMinted`.
1414      */
1415     function totalSupply() public view override returns (uint256) {
1416         // Counter underflow is impossible as _burnCounter cannot be incremented
1417         // more than `_currentIndex - _startTokenId()` times.
1418         unchecked {
1419             return _currentIndex - _burnCounter - _startTokenId();
1420         }
1421     }
1422 
1423     /**
1424      * @dev Returns the total amount of tokens minted in the contract.
1425      */
1426     function _totalMinted() internal view returns (uint256) {
1427         // Counter underflow is impossible as _currentIndex does not decrement,
1428         // and it is initialized to `_startTokenId()`
1429         unchecked {
1430             return _currentIndex - _startTokenId();
1431         }
1432     }
1433 
1434     /**
1435      * @dev Returns the total number of tokens burned.
1436      */
1437     function _totalBurned() internal view returns (uint256) {
1438         return _burnCounter;
1439     }
1440 
1441     /**
1442      * @dev See {IERC165-supportsInterface}.
1443      */
1444     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1445         // The interface IDs are constants representing the first 4 bytes of the XOR of
1446         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
1447         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
1448         return
1449             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1450             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1451             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1452     }
1453 
1454     /**
1455      * @dev See {IERC721-balanceOf}.
1456      */
1457     function balanceOf(address owner) public view override returns (uint256) {
1458         if (_addressToUint256(owner) == 0) revert BalanceQueryForZeroAddress();
1459         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
1460     }
1461 
1462     /**
1463      * Returns the number of tokens minted by `owner`.
1464      */
1465     function _numberMinted(address owner) internal view returns (uint256) {
1466         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
1467     }
1468 
1469     /**
1470      * Returns the number of tokens burned by or on behalf of `owner`.
1471      */
1472     function _numberBurned(address owner) internal view returns (uint256) {
1473         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
1474     }
1475 
1476     /**
1477      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1478      */
1479     function _getAux(address owner) internal view returns (uint64) {
1480         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
1481     }
1482 
1483     /**
1484      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1485      * If there are multiple variables, please pack them into a uint64.
1486      */
1487     function _setAux(address owner, uint64 aux) internal {
1488         uint256 packed = _packedAddressData[owner];
1489         uint256 auxCasted;
1490         assembly { // Cast aux without masking.
1491             auxCasted := aux
1492         }
1493         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
1494         _packedAddressData[owner] = packed;
1495     }
1496 
1497     /**
1498      * Returns the packed ownership data of `tokenId`.
1499      */
1500     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1501         uint256 curr = tokenId;
1502 
1503         unchecked {
1504             if (_startTokenId() <= curr)
1505                 if (curr < _currentIndex) {
1506                     uint256 packed = _packedOwnerships[curr];
1507                     // If not burned.
1508                     if (packed & BITMASK_BURNED == 0) {
1509                         // Invariant:
1510                         // There will always be an ownership that has an address and is not burned
1511                         // before an ownership that does not have an address and is not burned.
1512                         // Hence, curr will not underflow.
1513                         //
1514                         // We can directly compare the packed value.
1515                         // If the address is zero, packed is zero.
1516                         while (packed == 0) {
1517                             packed = _packedOwnerships[--curr];
1518                         }
1519                         return packed;
1520                     }
1521                 }
1522         }
1523         revert OwnerQueryForNonexistentToken();
1524     }
1525 
1526     /**
1527      * Returns the unpacked `TokenOwnership` struct from `packed`.
1528      */
1529     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1530         ownership.addr = address(uint160(packed));
1531         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
1532         ownership.burned = packed & BITMASK_BURNED != 0;
1533     }
1534 
1535     /**
1536      * Returns the unpacked `TokenOwnership` struct at `index`.
1537      */
1538     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
1539         return _unpackedOwnership(_packedOwnerships[index]);
1540     }
1541 
1542     /**
1543      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1544      */
1545     function _initializeOwnershipAt(uint256 index) internal {
1546         if (_packedOwnerships[index] == 0) {
1547             _packedOwnerships[index] = _packedOwnershipOf(index);
1548         }
1549     }
1550 
1551     /**
1552      * Gas spent here starts off proportional to the maximum mint batch size.
1553      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1554      */
1555     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1556         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1557     }
1558 
1559     /**
1560      * @dev See {IERC721-ownerOf}.
1561      */
1562     function ownerOf(uint256 tokenId) public view override returns (address) {
1563         return address(uint160(_packedOwnershipOf(tokenId)));
1564     }
1565 
1566     /**
1567      * @dev See {IERC721Metadata-name}.
1568      */
1569     function name() public view virtual override returns (string memory) {
1570         return _name;
1571     }
1572 
1573     /**
1574      * @dev See {IERC721Metadata-symbol}.
1575      */
1576     function symbol() public view virtual override returns (string memory) {
1577         return _symbol;
1578     }
1579 
1580     /**
1581      * @dev See {IERC721Metadata-tokenURI}.
1582      */
1583     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1584         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1585 
1586         string memory baseURI = _baseURI();
1587         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1588     }
1589 
1590     /**
1591      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1592      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1593      * by default, can be overriden in child contracts.
1594      */
1595     function _baseURI() internal view virtual returns (string memory) {
1596         return '';
1597     }
1598 
1599     /**
1600      * @dev Casts the address to uint256 without masking.
1601      */
1602     function _addressToUint256(address value) private pure returns (uint256 result) {
1603         assembly {
1604             result := value
1605         }
1606     }
1607 
1608     /**
1609      * @dev Casts the boolean to uint256 without branching.
1610      */
1611     function _boolToUint256(bool value) private pure returns (uint256 result) {
1612         assembly {
1613             result := value
1614         }
1615     }
1616 
1617     /**
1618      * @dev See {IERC721-approve}.
1619      */
1620     function approve(address to, uint256 tokenId) public override {
1621         address owner = address(uint160(_packedOwnershipOf(tokenId)));
1622         if (to == owner) revert ApprovalToCurrentOwner();
1623 
1624         if (_msgSenderERC721A() != owner)
1625             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1626                 revert ApprovalCallerNotOwnerNorApproved();
1627             }
1628 
1629         _tokenApprovals[tokenId] = to;
1630         emit Approval(owner, to, tokenId);
1631     }
1632 
1633     /**
1634      * @dev See {IERC721-getApproved}.
1635      */
1636     function getApproved(uint256 tokenId) public view override returns (address) {
1637         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1638 
1639         return _tokenApprovals[tokenId];
1640     }
1641 
1642     /**
1643      * @dev See {IERC721-setApprovalForAll}.
1644      */
1645     function setApprovalForAll(address operator, bool approved) public virtual override {
1646         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1647 
1648         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1649         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1650     }
1651 
1652     /**
1653      * @dev See {IERC721-isApprovedForAll}.
1654      */
1655     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1656         return _operatorApprovals[owner][operator];
1657     }
1658 
1659     /**
1660      * @dev See {IERC721-transferFrom}.
1661      */
1662     function transferFrom(
1663         address from,
1664         address to,
1665         uint256 tokenId
1666     ) public virtual override {
1667         _transfer(from, to, tokenId);
1668     }
1669 
1670     /**
1671      * @dev See {IERC721-safeTransferFrom}.
1672      */
1673     function safeTransferFrom(
1674         address from,
1675         address to,
1676         uint256 tokenId
1677     ) public virtual override {
1678         safeTransferFrom(from, to, tokenId, '');
1679     }
1680 
1681     /**
1682      * @dev See {IERC721-safeTransferFrom}.
1683      */
1684     function safeTransferFrom(
1685         address from,
1686         address to,
1687         uint256 tokenId,
1688         bytes memory _data
1689     ) public virtual override {
1690         _transfer(from, to, tokenId);
1691         if (to.code.length != 0)
1692             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1693                 revert TransferToNonERC721ReceiverImplementer();
1694             }
1695     }
1696 
1697     /**
1698      * @dev Returns whether `tokenId` exists.
1699      *
1700      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1701      *
1702      * Tokens start existing when they are minted (`_mint`),
1703      */
1704     function _exists(uint256 tokenId) internal view returns (bool) {
1705         return
1706             _startTokenId() <= tokenId &&
1707             tokenId < _currentIndex && // If within bounds,
1708             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1709     }
1710 
1711     /**
1712      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1713      */
1714     function _safeMint(address to, uint256 quantity) internal {
1715         _safeMint(to, quantity, '');
1716     }
1717 
1718     /**
1719      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1720      *
1721      * Requirements:
1722      *
1723      * - If `to` refers to a smart contract, it must implement
1724      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1725      * - `quantity` must be greater than 0.
1726      *
1727      * Emits a {Transfer} event.
1728      */
1729     function _safeMint(
1730         address to,
1731         uint256 quantity,
1732         bytes memory _data
1733     ) internal {
1734         uint256 startTokenId = _currentIndex;
1735         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
1736         if (quantity == 0) revert MintZeroQuantity();
1737 
1738         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1739 
1740         // Overflows are incredibly unrealistic.
1741         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1742         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1743         unchecked {
1744             // Updates:
1745             // - `balance += quantity`.
1746             // - `numberMinted += quantity`.
1747             //
1748             // We can directly add to the balance and number minted.
1749             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1750 
1751             // Updates:
1752             // - `address` to the owner.
1753             // - `startTimestamp` to the timestamp of minting.
1754             // - `burned` to `false`.
1755             // - `nextInitialized` to `quantity == 1`.
1756             _packedOwnerships[startTokenId] =
1757                 _addressToUint256(to) |
1758                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1759                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1760 
1761             uint256 updatedIndex = startTokenId;
1762             uint256 end = updatedIndex + quantity;
1763 
1764             if (to.code.length != 0) {
1765                 do {
1766                     emit Transfer(address(0), to, updatedIndex);
1767                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1768                         revert TransferToNonERC721ReceiverImplementer();
1769                     }
1770                 } while (updatedIndex < end);
1771                 // Reentrancy protection
1772                 if (_currentIndex != startTokenId) revert();
1773             } else {
1774                 do {
1775                     emit Transfer(address(0), to, updatedIndex++);
1776                 } while (updatedIndex < end);
1777             }
1778             _currentIndex = updatedIndex;
1779         }
1780         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1781     }
1782 
1783     /**
1784      * @dev Mints `quantity` tokens and transfers them to `to`.
1785      *
1786      * Requirements:
1787      *
1788      * - `to` cannot be the zero address.
1789      * - `quantity` must be greater than 0.
1790      *
1791      * Emits a {Transfer} event.
1792      */
1793     function _mint(address to, uint256 quantity) internal {
1794         uint256 startTokenId = _currentIndex;
1795         if (_addressToUint256(to) == 0) revert MintToZeroAddress();
1796         if (quantity == 0) revert MintZeroQuantity();
1797 
1798         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1799 
1800         // Overflows are incredibly unrealistic.
1801         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1802         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1803         unchecked {
1804             // Updates:
1805             // - `balance += quantity`.
1806             // - `numberMinted += quantity`.
1807             //
1808             // We can directly add to the balance and number minted.
1809             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1810 
1811             // Updates:
1812             // - `address` to the owner.
1813             // - `startTimestamp` to the timestamp of minting.
1814             // - `burned` to `false`.
1815             // - `nextInitialized` to `quantity == 1`.
1816             _packedOwnerships[startTokenId] =
1817                 _addressToUint256(to) |
1818                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1819                 (_boolToUint256(quantity == 1) << BITPOS_NEXT_INITIALIZED);
1820 
1821             uint256 updatedIndex = startTokenId;
1822             uint256 end = updatedIndex + quantity;
1823 
1824             do {
1825                 emit Transfer(address(0), to, updatedIndex++);
1826             } while (updatedIndex < end);
1827 
1828             _currentIndex = updatedIndex;
1829         }
1830         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1831     }
1832 
1833     /**
1834      * @dev Transfers `tokenId` from `from` to `to`.
1835      *
1836      * Requirements:
1837      *
1838      * - `to` cannot be the zero address.
1839      * - `tokenId` token must be owned by `from`.
1840      *
1841      * Emits a {Transfer} event.
1842      */
1843     function _transfer(
1844         address from,
1845         address to,
1846         uint256 tokenId
1847     ) private {
1848         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1849 
1850         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1851 
1852         address approvedAddress = _tokenApprovals[tokenId];
1853 
1854         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1855             isApprovedForAll(from, _msgSenderERC721A()) ||
1856             approvedAddress == _msgSenderERC721A());
1857 
1858         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1859         if (_addressToUint256(to) == 0) revert TransferToZeroAddress();
1860 
1861         _beforeTokenTransfers(from, to, tokenId, 1);
1862 
1863         // Clear approvals from the previous owner.
1864         if (_addressToUint256(approvedAddress) != 0) {
1865             delete _tokenApprovals[tokenId];
1866         }
1867 
1868         // Underflow of the sender's balance is impossible because we check for
1869         // ownership above and the recipient's balance can't realistically overflow.
1870         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1871         unchecked {
1872             // We can directly increment and decrement the balances.
1873             --_packedAddressData[from]; // Updates: `balance -= 1`.
1874             ++_packedAddressData[to]; // Updates: `balance += 1`.
1875 
1876             // Updates:
1877             // - `address` to the next owner.
1878             // - `startTimestamp` to the timestamp of transfering.
1879             // - `burned` to `false`.
1880             // - `nextInitialized` to `true`.
1881             _packedOwnerships[tokenId] =
1882                 _addressToUint256(to) |
1883                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1884                 BITMASK_NEXT_INITIALIZED;
1885 
1886             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1887             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1888                 uint256 nextTokenId = tokenId + 1;
1889                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1890                 if (_packedOwnerships[nextTokenId] == 0) {
1891                     // If the next slot is within bounds.
1892                     if (nextTokenId != _currentIndex) {
1893                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1894                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1895                     }
1896                 }
1897             }
1898         }
1899 
1900         emit Transfer(from, to, tokenId);
1901         _afterTokenTransfers(from, to, tokenId, 1);
1902     }
1903 
1904     /**
1905      * @dev Equivalent to `_burn(tokenId, false)`.
1906      */
1907     function _burn(uint256 tokenId) internal virtual {
1908         _burn(tokenId, false);
1909     }
1910 
1911     /**
1912      * @dev Destroys `tokenId`.
1913      * The approval is cleared when the token is burned.
1914      *
1915      * Requirements:
1916      *
1917      * - `tokenId` must exist.
1918      *
1919      * Emits a {Transfer} event.
1920      */
1921     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1922         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1923 
1924         address from = address(uint160(prevOwnershipPacked));
1925         address approvedAddress = _tokenApprovals[tokenId];
1926 
1927         if (approvalCheck) {
1928             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1929                 isApprovedForAll(from, _msgSenderERC721A()) ||
1930                 approvedAddress == _msgSenderERC721A());
1931 
1932             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1933         }
1934 
1935         _beforeTokenTransfers(from, address(0), tokenId, 1);
1936 
1937         // Clear approvals from the previous owner.
1938         if (_addressToUint256(approvedAddress) != 0) {
1939             delete _tokenApprovals[tokenId];
1940         }
1941 
1942         // Underflow of the sender's balance is impossible because we check for
1943         // ownership above and the recipient's balance can't realistically overflow.
1944         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1945         unchecked {
1946             // Updates:
1947             // - `balance -= 1`.
1948             // - `numberBurned += 1`.
1949             //
1950             // We can directly decrement the balance, and increment the number burned.
1951             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1952             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1953 
1954             // Updates:
1955             // - `address` to the last owner.
1956             // - `startTimestamp` to the timestamp of burning.
1957             // - `burned` to `true`.
1958             // - `nextInitialized` to `true`.
1959             _packedOwnerships[tokenId] =
1960                 _addressToUint256(from) |
1961                 (block.timestamp << BITPOS_START_TIMESTAMP) |
1962                 BITMASK_BURNED |
1963                 BITMASK_NEXT_INITIALIZED;
1964 
1965             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1966             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1967                 uint256 nextTokenId = tokenId + 1;
1968                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1969                 if (_packedOwnerships[nextTokenId] == 0) {
1970                     // If the next slot is within bounds.
1971                     if (nextTokenId != _currentIndex) {
1972                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1973                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1974                     }
1975                 }
1976             }
1977         }
1978 
1979         emit Transfer(from, address(0), tokenId);
1980         _afterTokenTransfers(from, address(0), tokenId, 1);
1981 
1982         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1983         unchecked {
1984             _burnCounter++;
1985         }
1986     }
1987 
1988     /**
1989      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1990      *
1991      * @param from address representing the previous owner of the given token ID
1992      * @param to target address that will receive the tokens
1993      * @param tokenId uint256 ID of the token to be transferred
1994      * @param _data bytes optional data to send along with the call
1995      * @return bool whether the call correctly returned the expected magic value
1996      */
1997     function _checkContractOnERC721Received(
1998         address from,
1999         address to,
2000         uint256 tokenId,
2001         bytes memory _data
2002     ) private returns (bool) {
2003         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
2004             bytes4 retval
2005         ) {
2006             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2007         } catch (bytes memory reason) {
2008             if (reason.length == 0) {
2009                 revert TransferToNonERC721ReceiverImplementer();
2010             } else {
2011                 assembly {
2012                     revert(add(32, reason), mload(reason))
2013                 }
2014             }
2015         }
2016     }
2017 
2018     /**
2019      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
2020      * And also called before burning one token.
2021      *
2022      * startTokenId - the first token id to be transferred
2023      * quantity - the amount to be transferred
2024      *
2025      * Calling conditions:
2026      *
2027      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2028      * transferred to `to`.
2029      * - When `from` is zero, `tokenId` will be minted for `to`.
2030      * - When `to` is zero, `tokenId` will be burned by `from`.
2031      * - `from` and `to` are never both zero.
2032      */
2033     function _beforeTokenTransfers(
2034         address from,
2035         address to,
2036         uint256 startTokenId,
2037         uint256 quantity
2038     ) internal virtual {}
2039 
2040     /**
2041      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
2042      * minting.
2043      * And also called after one token has been burned.
2044      *
2045      * startTokenId - the first token id to be transferred
2046      * quantity - the amount to be transferred
2047      *
2048      * Calling conditions:
2049      *
2050      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2051      * transferred to `to`.
2052      * - When `from` is zero, `tokenId` has been minted for `to`.
2053      * - When `to` is zero, `tokenId` has been burned by `from`.
2054      * - `from` and `to` are never both zero.
2055      */
2056     function _afterTokenTransfers(
2057         address from,
2058         address to,
2059         uint256 startTokenId,
2060         uint256 quantity
2061     ) internal virtual {}
2062 
2063     /**
2064      * @dev Returns the message sender (defaults to `msg.sender`).
2065      *
2066      * If you are writing GSN compatible contracts, you need to override this function.
2067      */
2068     function _msgSenderERC721A() internal view virtual returns (address) {
2069         return msg.sender;
2070     }
2071 
2072     /**
2073      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
2074      */
2075     function _toString(uint256 value) internal pure returns (string memory ptr) {
2076         assembly {
2077             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
2078             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
2079             // We will need 1 32-byte word to store the length,
2080             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
2081             ptr := add(mload(0x40), 128)
2082             // Update the free memory pointer to allocate.
2083             mstore(0x40, ptr)
2084 
2085             // Cache the end of the memory to calculate the length later.
2086             let end := ptr
2087 
2088             // We write the string from the rightmost digit to the leftmost digit.
2089             // The following is essentially a do-while loop that also handles the zero case.
2090             // Costs a bit more than early returning for the zero case,
2091             // but cheaper in terms of deployment and overall runtime costs.
2092             for {
2093                 // Initialize and perform the first pass without check.
2094                 let temp := value
2095                 // Move the pointer 1 byte leftwards to point to an empty character slot.
2096                 ptr := sub(ptr, 1)
2097                 // Write the character to the pointer. 48 is the ASCII index of '0'.
2098                 mstore8(ptr, add(48, mod(temp, 10)))
2099                 temp := div(temp, 10)
2100             } temp {
2101                 // Keep dividing `temp` until zero.
2102                 temp := div(temp, 10)
2103             } { // Body of the for loop.
2104                 ptr := sub(ptr, 1)
2105                 mstore8(ptr, add(48, mod(temp, 10)))
2106             }
2107 
2108             let length := sub(end, ptr)
2109             // Move the pointer 32 bytes leftwards to make room for the length.
2110             ptr := sub(ptr, 32)
2111             // Store the length.
2112             mstore(ptr, length)
2113         }
2114     }
2115 }
2116 
2117 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
2118 
2119 pragma solidity ^0.8.0;
2120 
2121 /**
2122  * @dev Contract module that helps prevent reentrant calls to a function.
2123  *
2124  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
2125  * available, which can be applied to functions to make sure there are no nested
2126  * (reentrant) calls to them.
2127  *
2128  * Note that because there is a single `nonReentrant` guard, functions marked as
2129  * `nonReentrant` may not call one another. This can be worked around by making
2130  * those functions `private`, and then adding `external` `nonReentrant` entry
2131  * points to them.
2132  *
2133  * TIP: If you would like to learn more about reentrancy and alternative ways
2134  * to protect against it, check out our blog post
2135  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
2136  */
2137 abstract contract ReentrancyGuard {
2138     // Booleans are more expensive than uint256 or any type that takes up a full
2139     // word because each write operation emits an extra SLOAD to first read the
2140     // slot's contents, replace the bits taken up by the boolean, and then write
2141     // back. This is the compiler's defense against contract upgrades and
2142     // pointer aliasing, and it cannot be disabled.
2143 
2144     // The values being non-zero value makes deployment a bit more expensive,
2145     // but in exchange the refund on every call to nonReentrant will be lower in
2146     // amount. Since refunds are capped to a percentage of the total
2147     // transaction's gas, it is best to keep them low in cases like this one, to
2148     // increase the likelihood of the full refund coming into effect.
2149     uint256 private constant _NOT_ENTERED = 1;
2150     uint256 private constant _ENTERED = 2;
2151 
2152     uint256 private _status;
2153 
2154     constructor() {
2155         _status = _NOT_ENTERED;
2156     }
2157 
2158     /**
2159      * @dev Prevents a contract from calling itself, directly or indirectly.
2160      * Calling a `nonReentrant` function from another `nonReentrant`
2161      * function is not supported. It is possible to prevent this from happening
2162      * by making the `nonReentrant` function external, and making it call a
2163      * `private` function that does the actual work.
2164      */
2165     modifier nonReentrant() {
2166         // On the first call to nonReentrant, _notEntered will be true
2167         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
2168 
2169         // Any calls to nonReentrant after this point will fail
2170         _status = _ENTERED;
2171 
2172         _;
2173 
2174         // By storing the original value once again, a refund is triggered (see
2175         // https://eips.ethereum.org/EIPS/eip-2200)
2176         _status = _NOT_ENTERED;
2177     }
2178 }
2179 
2180 pragma solidity ^ 0.8.2;
2181 contract ATARI50 is ERC721A, Ownable, Payment, ReentrancyGuard {
2182 
2183     /// Powered By NiftyDrops by NiftyLabs LLC
2184 
2185     /// @notice status booleans for phases 
2186     bool public isAllowlistActive = false;
2187     bool public isPublicActive = false;
2188 
2189     /// @notice settings for future burn utility
2190     address public burnContract;
2191     bool public isBurnActive = false;
2192     bool public burnDependent = false;
2193 
2194     /// @notice signer for allowlist
2195     address private signer = 0xD48D5F6450D7e1cB5F7E73E678cCc3f5B9b3E01C;
2196 
2197     /// @notice collection settings
2198     uint256 public MAX_SUPPLY = 2600;
2199     uint256 public PRICE_PER_TOKEN = 0.1972 ether;
2200 
2201     /// @notice set to 1 for allowlist, set to 6 for public
2202     uint256 private maxMintPerWallet = 1;
2203 
2204     /// @notice collection payouts
2205     address[] private addressList = [0xeC823C71085Ae6a7953D80F1204C2D04B33Bd4e7];
2206 
2207     uint[] private shareList = [100];
2208 
2209     /// @notice mnetadata path
2210     string public _metadata;
2211 
2212     /// @notice tracks number minted per person
2213     mapping(address => uint256) public numMintedPerPerson;
2214 
2215     constructor() ERC721A("ATARI50", "1972") Payment(addressList, shareList) {}
2216 
2217     /// @notice mint allowlist
2218     function mintAllowlist(address _address, bytes calldata _voucher, uint256 _tokenAmount) external payable nonReentrant {
2219         uint256 ts = totalSupply();
2220         require(isAllowlistActive);
2221         require(_tokenAmount <= maxMintPerWallet, "Purchase would exceed max tokens per tx in this phase");
2222         require(ts + _tokenAmount <= MAX_SUPPLY, "Purchase would exceed max tokens in the  allowlist");
2223         require(msg.value >= PRICE_PER_TOKEN * _tokenAmount, "Ether value sent is not correct");
2224         require(msg.sender == _address, "Not your voucher");
2225         require(msg.sender == tx.origin);
2226         require(numMintedPerPerson[_address] + _tokenAmount <= maxMintPerWallet, "Purchase would exceed max tokens per Wallet");
2227 
2228         bytes32 hash = keccak256(
2229             abi.encodePacked(_address)
2230         );
2231         require(_verifySignature(signer, hash, _voucher), "Invalid voucher");
2232 
2233         _safeMint(_address, _tokenAmount);
2234         numMintedPerPerson[_address] += _tokenAmount;
2235     }
2236 
2237     /// @notice mint public
2238     function mintPublic(uint256 _tokenAmount) external payable nonReentrant {
2239         uint256 ts = totalSupply();
2240         require(isPublicActive);
2241         require(_tokenAmount <= maxMintPerWallet, "Purchase would exceed max tokens per tx in this wave");
2242         require(ts + _tokenAmount <= MAX_SUPPLY, "Purchase would exceed max tokens");
2243         require(msg.value >= PRICE_PER_TOKEN * _tokenAmount, "Ether value sent is not correct");
2244         require(msg.sender == tx.origin);
2245         require(numMintedPerPerson[msg.sender] + _tokenAmount <= maxMintPerWallet, "Purchase would exceed max tokens per Wallet");
2246         _safeMint(msg.sender, _tokenAmount);
2247         numMintedPerPerson[msg.sender] += _tokenAmount;
2248     }
2249 
2250     /// @notice reserve to wallets, only owner
2251     function reserve(address addr, uint256 _tokenAmount) public onlyOwner {
2252         uint256 ts = totalSupply();
2253         require(ts + _tokenAmount <= MAX_SUPPLY);
2254         _safeMint(addr, _tokenAmount);
2255     }
2256 
2257     /// @notice burn token, future utility
2258     function burnToken(uint256 token) external {
2259         require(isBurnActive);
2260         if (burnDependent) {
2261             require(tx.origin == burnContract || msg.sender == burnContract);
2262             _burn(token);
2263         } else {
2264             require(ownerOf(token) == msg.sender);
2265             _burn(token);
2266         }
2267     }
2268 
2269     /// @notice verify voucher
2270     function _verifySignature(address _signer, bytes32 _hash, bytes memory _signature) private pure returns(bool) {
2271         return _signer == ECDSA.recover(ECDSA.toEthSignedMessageHash(_hash), _signature);
2272     }
2273 
2274     /// @notice set signer for signature
2275     function setSigner(address _signer) external onlyOwner {
2276         signer = _signer;
2277     }
2278 
2279     /// @notice set price
2280     function setPrice(uint256 _newPrice) external onlyOwner {
2281         PRICE_PER_TOKEN = _newPrice;
2282     }
2283 
2284     /// @notice set allowlist active
2285     function setAllowlist(bool _status) external onlyOwner {
2286         isAllowlistActive = _status;
2287     }
2288     
2289     /// @notice set public active
2290     function setPublic(bool _status) external onlyOwner {
2291         isPublicActive = _status;
2292     }
2293 
2294     /// @notice set burn active
2295     function setBurn(bool _status) external onlyOwner {
2296         isBurnActive = _status;
2297     }
2298 
2299     /// @notice set future burn utility contract
2300     function setBurnContract(address _contract) external onlyOwner {
2301         burnContract = _contract;
2302     }
2303 
2304     /// @notice set burn dependent on a external contract
2305     function setBurnDependent(bool _status) external onlyOwner {
2306         burnDependent = _status;
2307     }
2308 
2309     /// @notice set max mint per wallet/tx
2310     function setMaxMintPerWallet(uint256 _amount) external onlyOwner {
2311         maxMintPerWallet = _amount;
2312     }
2313 
2314     /// @notice set metadata path
2315     function setMetadata(string memory metadata_) external onlyOwner {
2316         _metadata = metadata_;
2317     }
2318 
2319     /// @notice read metadata
2320     function _baseURI() internal view virtual override returns(string memory) {
2321         return _metadata;
2322     }
2323 
2324     /// @notice withdraw funds to deployer wallet
2325     function withdraw() public payable onlyOwner {
2326         (bool success, ) = payable(msg.sender).call {
2327             value: address(this).balance
2328         }("");
2329         require(success);
2330     }
2331 }