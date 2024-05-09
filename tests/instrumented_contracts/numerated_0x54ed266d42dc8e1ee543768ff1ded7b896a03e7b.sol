1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
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
70 
71 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
72 
73 
74 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 
79 /**
80  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
81  *
82  * These functions can be used to verify that a message was signed by the holder
83  * of the private keys of a given address.
84  */
85 library ECDSA {
86     enum RecoverError {
87         NoError,
88         InvalidSignature,
89         InvalidSignatureLength,
90         InvalidSignatureS,
91         InvalidSignatureV
92     }
93 
94     function _throwError(RecoverError error) private pure {
95         if (error == RecoverError.NoError) {
96             return; // no error: do nothing
97         } else if (error == RecoverError.InvalidSignature) {
98             revert("ECDSA: invalid signature");
99         } else if (error == RecoverError.InvalidSignatureLength) {
100             revert("ECDSA: invalid signature length");
101         } else if (error == RecoverError.InvalidSignatureS) {
102             revert("ECDSA: invalid signature 's' value");
103         } else if (error == RecoverError.InvalidSignatureV) {
104             revert("ECDSA: invalid signature 'v' value");
105         }
106     }
107 
108     /**
109      * @dev Returns the address that signed a hashed message (`hash`) with
110      * `signature` or error string. This address can then be used for verification purposes.
111      *
112      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
113      * this function rejects them by requiring the `s` value to be in the lower
114      * half order, and the `v` value to be either 27 or 28.
115      *
116      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
117      * verification to be secure: it is possible to craft signatures that
118      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
119      * this is by receiving a hash of the original message (which may otherwise
120      * be too long), and then calling {toEthSignedMessageHash} on it.
121      *
122      * Documentation for signature generation:
123      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
124      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
125      *
126      * _Available since v4.3._
127      */
128     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
129         // Check the signature length
130         // - case 65: r,s,v signature (standard)
131         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
132         if (signature.length == 65) {
133             bytes32 r;
134             bytes32 s;
135             uint8 v;
136             // ecrecover takes the signature parameters, and the only way to get them
137             // currently is to use assembly.
138             assembly {
139                 r := mload(add(signature, 0x20))
140                 s := mload(add(signature, 0x40))
141                 v := byte(0, mload(add(signature, 0x60)))
142             }
143             return tryRecover(hash, v, r, s);
144         } else if (signature.length == 64) {
145             bytes32 r;
146             bytes32 vs;
147             // ecrecover takes the signature parameters, and the only way to get them
148             // currently is to use assembly.
149             assembly {
150                 r := mload(add(signature, 0x20))
151                 vs := mload(add(signature, 0x40))
152             }
153             return tryRecover(hash, r, vs);
154         } else {
155             return (address(0), RecoverError.InvalidSignatureLength);
156         }
157     }
158 
159     /**
160      * @dev Returns the address that signed a hashed message (`hash`) with
161      * `signature`. This address can then be used for verification purposes.
162      *
163      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
164      * this function rejects them by requiring the `s` value to be in the lower
165      * half order, and the `v` value to be either 27 or 28.
166      *
167      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
168      * verification to be secure: it is possible to craft signatures that
169      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
170      * this is by receiving a hash of the original message (which may otherwise
171      * be too long), and then calling {toEthSignedMessageHash} on it.
172      */
173     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
174         (address recovered, RecoverError error) = tryRecover(hash, signature);
175         _throwError(error);
176         return recovered;
177     }
178 
179     /**
180      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
181      *
182      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
183      *
184      * _Available since v4.3._
185      */
186     function tryRecover(
187         bytes32 hash,
188         bytes32 r,
189         bytes32 vs
190     ) internal pure returns (address, RecoverError) {
191         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
192         uint8 v = uint8((uint256(vs) >> 255) + 27);
193         return tryRecover(hash, v, r, s);
194     }
195 
196     /**
197      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
198      *
199      * _Available since v4.2._
200      */
201     function recover(
202         bytes32 hash,
203         bytes32 r,
204         bytes32 vs
205     ) internal pure returns (address) {
206         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
207         _throwError(error);
208         return recovered;
209     }
210 
211     /**
212      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
213      * `r` and `s` signature fields separately.
214      *
215      * _Available since v4.3._
216      */
217     function tryRecover(
218         bytes32 hash,
219         uint8 v,
220         bytes32 r,
221         bytes32 s
222     ) internal pure returns (address, RecoverError) {
223         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
224         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
225         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
226         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
227         //
228         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
229         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
230         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
231         // these malleable signatures as well.
232         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
233             return (address(0), RecoverError.InvalidSignatureS);
234         }
235         if (v != 27 && v != 28) {
236             return (address(0), RecoverError.InvalidSignatureV);
237         }
238 
239         // If the signature is valid (and not malleable), return the signer address
240         address signer = ecrecover(hash, v, r, s);
241         if (signer == address(0)) {
242             return (address(0), RecoverError.InvalidSignature);
243         }
244 
245         return (signer, RecoverError.NoError);
246     }
247 
248     /**
249      * @dev Overload of {ECDSA-recover} that receives the `v`,
250      * `r` and `s` signature fields separately.
251      */
252     function recover(
253         bytes32 hash,
254         uint8 v,
255         bytes32 r,
256         bytes32 s
257     ) internal pure returns (address) {
258         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
259         _throwError(error);
260         return recovered;
261     }
262 
263     /**
264      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
265      * produces hash corresponding to the one signed with the
266      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
267      * JSON-RPC method as part of EIP-191.
268      *
269      * See {recover}.
270      */
271     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
272         // 32 is the length in bytes of hash,
273         // enforced by the type signature above
274         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
275     }
276 
277     /**
278      * @dev Returns an Ethereum Signed Message, created from `s`. This
279      * produces hash corresponding to the one signed with the
280      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
281      * JSON-RPC method as part of EIP-191.
282      *
283      * See {recover}.
284      */
285     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
286         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
287     }
288 
289     /**
290      * @dev Returns an Ethereum Signed Typed Data, created from a
291      * `domainSeparator` and a `structHash`. This produces hash corresponding
292      * to the one signed with the
293      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
294      * JSON-RPC method as part of EIP-712.
295      *
296      * See {recover}.
297      */
298     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
299         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
300     }
301 }
302 
303 // File: @openzeppelin/contracts/utils/Context.sol
304 
305 
306 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
307 
308 pragma solidity ^0.8.0;
309 
310 /**
311  * @dev Provides information about the current execution context, including the
312  * sender of the transaction and its data. While these are generally available
313  * via msg.sender and msg.data, they should not be accessed in such a direct
314  * manner, since when dealing with meta-transactions the account sending and
315  * paying for execution may not be the actual sender (as far as an application
316  * is concerned).
317  *
318  * This contract is only required for intermediate, library-like contracts.
319  */
320 abstract contract Context {
321     function _msgSender() internal view virtual returns (address) {
322         return msg.sender;
323     }
324 
325     function _msgData() internal view virtual returns (bytes calldata) {
326         return msg.data;
327     }
328 }
329 
330 // File: @openzeppelin/contracts/security/Pausable.sol
331 
332 
333 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
334 
335 pragma solidity ^0.8.0;
336 
337 
338 /**
339  * @dev Contract module which allows children to implement an emergency stop
340  * mechanism that can be triggered by an authorized account.
341  *
342  * This module is used through inheritance. It will make available the
343  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
344  * the functions of your contract. Note that they will not be pausable by
345  * simply including this module, only once the modifiers are put in place.
346  */
347 abstract contract Pausable is Context {
348     /**
349      * @dev Emitted when the pause is triggered by `account`.
350      */
351     event Paused(address account);
352 
353     /**
354      * @dev Emitted when the pause is lifted by `account`.
355      */
356     event Unpaused(address account);
357 
358     bool private _paused;
359 
360     /**
361      * @dev Initializes the contract in unpaused state.
362      */
363     constructor() {
364         _paused = false;
365     }
366 
367     /**
368      * @dev Returns true if the contract is paused, and false otherwise.
369      */
370     function paused() public view virtual returns (bool) {
371         return _paused;
372     }
373 
374     /**
375      * @dev Modifier to make a function callable only when the contract is not paused.
376      *
377      * Requirements:
378      *
379      * - The contract must not be paused.
380      */
381     modifier whenNotPaused() {
382         require(!paused(), "Pausable: paused");
383         _;
384     }
385 
386     /**
387      * @dev Modifier to make a function callable only when the contract is paused.
388      *
389      * Requirements:
390      *
391      * - The contract must be paused.
392      */
393     modifier whenPaused() {
394         require(paused(), "Pausable: not paused");
395         _;
396     }
397 
398     /**
399      * @dev Triggers stopped state.
400      *
401      * Requirements:
402      *
403      * - The contract must not be paused.
404      */
405     function _pause() internal virtual whenNotPaused {
406         _paused = true;
407         emit Paused(_msgSender());
408     }
409 
410     /**
411      * @dev Returns to normal state.
412      *
413      * Requirements:
414      *
415      * - The contract must be paused.
416      */
417     function _unpause() internal virtual whenPaused {
418         _paused = false;
419         emit Unpaused(_msgSender());
420     }
421 }
422 
423 // File: @openzeppelin/contracts/access/Ownable.sol
424 
425 
426 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
427 
428 pragma solidity ^0.8.0;
429 
430 
431 /**
432  * @dev Contract module which provides a basic access control mechanism, where
433  * there is an account (an owner) that can be granted exclusive access to
434  * specific functions.
435  *
436  * By default, the owner account will be the one that deploys the contract. This
437  * can later be changed with {transferOwnership}.
438  *
439  * This module is used through inheritance. It will make available the modifier
440  * `onlyOwner`, which can be applied to your functions to restrict their use to
441  * the owner.
442  */
443 abstract contract Ownable is Context {
444     address private _owner;
445 
446     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
447 
448     /**
449      * @dev Initializes the contract setting the deployer as the initial owner.
450      */
451     constructor() {
452         _transferOwnership(_msgSender());
453     }
454 
455     /**
456      * @dev Returns the address of the current owner.
457      */
458     function owner() public view virtual returns (address) {
459         return _owner;
460     }
461 
462     /**
463      * @dev Throws if called by any account other than the owner.
464      */
465     modifier onlyOwner() {
466         require(owner() == _msgSender(), "Ownable: caller is not the owner");
467         _;
468     }
469 
470     /**
471      * @dev Leaves the contract without owner. It will not be possible to call
472      * `onlyOwner` functions anymore. Can only be called by the current owner.
473      *
474      * NOTE: Renouncing ownership will leave the contract without an owner,
475      * thereby removing any functionality that is only available to the owner.
476      */
477     function renounceOwnership() public virtual onlyOwner {
478         _transferOwnership(address(0));
479     }
480 
481     /**
482      * @dev Transfers ownership of the contract to a new account (`newOwner`).
483      * Can only be called by the current owner.
484      */
485     function transferOwnership(address newOwner) public virtual onlyOwner {
486         require(newOwner != address(0), "Ownable: new owner is the zero address");
487         _transferOwnership(newOwner);
488     }
489 
490     /**
491      * @dev Transfers ownership of the contract to a new account (`newOwner`).
492      * Internal function without access restriction.
493      */
494     function _transferOwnership(address newOwner) internal virtual {
495         address oldOwner = _owner;
496         _owner = newOwner;
497         emit OwnershipTransferred(oldOwner, newOwner);
498     }
499 }
500 
501 // File: @openzeppelin/contracts/utils/Address.sol
502 
503 
504 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
505 
506 pragma solidity ^0.8.1;
507 
508 /**
509  * @dev Collection of functions related to the address type
510  */
511 library Address {
512     /**
513      * @dev Returns true if `account` is a contract.
514      *
515      * [IMPORTANT]
516      * ====
517      * It is unsafe to assume that an address for which this function returns
518      * false is an externally-owned account (EOA) and not a contract.
519      *
520      * Among others, `isContract` will return false for the following
521      * types of addresses:
522      *
523      *  - an externally-owned account
524      *  - a contract in construction
525      *  - an address where a contract will be created
526      *  - an address where a contract lived, but was destroyed
527      * ====
528      *
529      * [IMPORTANT]
530      * ====
531      * You shouldn't rely on `isContract` to protect against flash loan attacks!
532      *
533      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
534      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
535      * constructor.
536      * ====
537      */
538     function isContract(address account) internal view returns (bool) {
539         // This method relies on extcodesize/address.code.length, which returns 0
540         // for contracts in construction, since the code is only stored at the end
541         // of the constructor execution.
542 
543         return account.code.length > 0;
544     }
545 
546     /**
547      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
548      * `recipient`, forwarding all available gas and reverting on errors.
549      *
550      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
551      * of certain opcodes, possibly making contracts go over the 2300 gas limit
552      * imposed by `transfer`, making them unable to receive funds via
553      * `transfer`. {sendValue} removes this limitation.
554      *
555      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
556      *
557      * IMPORTANT: because control is transferred to `recipient`, care must be
558      * taken to not create reentrancy vulnerabilities. Consider using
559      * {ReentrancyGuard} or the
560      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
561      */
562     function sendValue(address payable recipient, uint256 amount) internal {
563         require(address(this).balance >= amount, "Address: insufficient balance");
564 
565         (bool success, ) = recipient.call{value: amount}("");
566         require(success, "Address: unable to send value, recipient may have reverted");
567     }
568 
569     /**
570      * @dev Performs a Solidity function call using a low level `call`. A
571      * plain `call` is an unsafe replacement for a function call: use this
572      * function instead.
573      *
574      * If `target` reverts with a revert reason, it is bubbled up by this
575      * function (like regular Solidity function calls).
576      *
577      * Returns the raw returned data. To convert to the expected return value,
578      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
579      *
580      * Requirements:
581      *
582      * - `target` must be a contract.
583      * - calling `target` with `data` must not revert.
584      *
585      * _Available since v3.1._
586      */
587     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
588         return functionCall(target, data, "Address: low-level call failed");
589     }
590 
591     /**
592      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
593      * `errorMessage` as a fallback revert reason when `target` reverts.
594      *
595      * _Available since v3.1._
596      */
597     function functionCall(
598         address target,
599         bytes memory data,
600         string memory errorMessage
601     ) internal returns (bytes memory) {
602         return functionCallWithValue(target, data, 0, errorMessage);
603     }
604 
605     /**
606      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
607      * but also transferring `value` wei to `target`.
608      *
609      * Requirements:
610      *
611      * - the calling contract must have an ETH balance of at least `value`.
612      * - the called Solidity function must be `payable`.
613      *
614      * _Available since v3.1._
615      */
616     function functionCallWithValue(
617         address target,
618         bytes memory data,
619         uint256 value
620     ) internal returns (bytes memory) {
621         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
622     }
623 
624     /**
625      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
626      * with `errorMessage` as a fallback revert reason when `target` reverts.
627      *
628      * _Available since v3.1._
629      */
630     function functionCallWithValue(
631         address target,
632         bytes memory data,
633         uint256 value,
634         string memory errorMessage
635     ) internal returns (bytes memory) {
636         require(address(this).balance >= value, "Address: insufficient balance for call");
637         require(isContract(target), "Address: call to non-contract");
638 
639         (bool success, bytes memory returndata) = target.call{value: value}(data);
640         return verifyCallResult(success, returndata, errorMessage);
641     }
642 
643     /**
644      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
645      * but performing a static call.
646      *
647      * _Available since v3.3._
648      */
649     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
650         return functionStaticCall(target, data, "Address: low-level static call failed");
651     }
652 
653     /**
654      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
655      * but performing a static call.
656      *
657      * _Available since v3.3._
658      */
659     function functionStaticCall(
660         address target,
661         bytes memory data,
662         string memory errorMessage
663     ) internal view returns (bytes memory) {
664         require(isContract(target), "Address: static call to non-contract");
665 
666         (bool success, bytes memory returndata) = target.staticcall(data);
667         return verifyCallResult(success, returndata, errorMessage);
668     }
669 
670     /**
671      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
672      * but performing a delegate call.
673      *
674      * _Available since v3.4._
675      */
676     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
677         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
678     }
679 
680     /**
681      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
682      * but performing a delegate call.
683      *
684      * _Available since v3.4._
685      */
686     function functionDelegateCall(
687         address target,
688         bytes memory data,
689         string memory errorMessage
690     ) internal returns (bytes memory) {
691         require(isContract(target), "Address: delegate call to non-contract");
692 
693         (bool success, bytes memory returndata) = target.delegatecall(data);
694         return verifyCallResult(success, returndata, errorMessage);
695     }
696 
697     /**
698      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
699      * revert reason using the provided one.
700      *
701      * _Available since v4.3._
702      */
703     function verifyCallResult(
704         bool success,
705         bytes memory returndata,
706         string memory errorMessage
707     ) internal pure returns (bytes memory) {
708         if (success) {
709             return returndata;
710         } else {
711             // Look for revert reason and bubble it up if present
712             if (returndata.length > 0) {
713                 // The easiest way to bubble the revert reason is using memory via assembly
714 
715                 assembly {
716                     let returndata_size := mload(returndata)
717                     revert(add(32, returndata), returndata_size)
718                 }
719             } else {
720                 revert(errorMessage);
721             }
722         }
723     }
724 }
725 
726 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
727 
728 
729 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
730 
731 pragma solidity ^0.8.0;
732 
733 /**
734  * @dev Interface of the ERC165 standard, as defined in the
735  * https://eips.ethereum.org/EIPS/eip-165[EIP].
736  *
737  * Implementers can declare support of contract interfaces, which can then be
738  * queried by others ({ERC165Checker}).
739  *
740  * For an implementation, see {ERC165}.
741  */
742 interface IERC165 {
743     /**
744      * @dev Returns true if this contract implements the interface defined by
745      * `interfaceId`. See the corresponding
746      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
747      * to learn more about how these ids are created.
748      *
749      * This function call must use less than 30 000 gas.
750      */
751     function supportsInterface(bytes4 interfaceId) external view returns (bool);
752 }
753 
754 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
755 
756 
757 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
758 
759 pragma solidity ^0.8.0;
760 
761 
762 /**
763  * @dev Implementation of the {IERC165} interface.
764  *
765  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
766  * for the additional interface id that will be supported. For example:
767  *
768  * ```solidity
769  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
770  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
771  * }
772  * ```
773  *
774  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
775  */
776 abstract contract ERC165 is IERC165 {
777     /**
778      * @dev See {IERC165-supportsInterface}.
779      */
780     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
781         return interfaceId == type(IERC165).interfaceId;
782     }
783 }
784 
785 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
786 
787 
788 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
789 
790 pragma solidity ^0.8.0;
791 
792 
793 /**
794  * @dev _Available since v3.1._
795  */
796 interface IERC1155Receiver is IERC165 {
797     /**
798      * @dev Handles the receipt of a single ERC1155 token type. This function is
799      * called at the end of a `safeTransferFrom` after the balance has been updated.
800      *
801      * NOTE: To accept the transfer, this must return
802      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
803      * (i.e. 0xf23a6e61, or its own function selector).
804      *
805      * @param operator The address which initiated the transfer (i.e. msg.sender)
806      * @param from The address which previously owned the token
807      * @param id The ID of the token being transferred
808      * @param value The amount of tokens being transferred
809      * @param data Additional data with no specified format
810      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
811      */
812     function onERC1155Received(
813         address operator,
814         address from,
815         uint256 id,
816         uint256 value,
817         bytes calldata data
818     ) external returns (bytes4);
819 
820     /**
821      * @dev Handles the receipt of a multiple ERC1155 token types. This function
822      * is called at the end of a `safeBatchTransferFrom` after the balances have
823      * been updated.
824      *
825      * NOTE: To accept the transfer(s), this must return
826      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
827      * (i.e. 0xbc197c81, or its own function selector).
828      *
829      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
830      * @param from The address which previously owned the token
831      * @param ids An array containing ids of each token being transferred (order and length must match values array)
832      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
833      * @param data Additional data with no specified format
834      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
835      */
836     function onERC1155BatchReceived(
837         address operator,
838         address from,
839         uint256[] calldata ids,
840         uint256[] calldata values,
841         bytes calldata data
842     ) external returns (bytes4);
843 }
844 
845 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
846 
847 
848 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
849 
850 pragma solidity ^0.8.0;
851 
852 
853 /**
854  * @dev Required interface of an ERC1155 compliant contract, as defined in the
855  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
856  *
857  * _Available since v3.1._
858  */
859 interface IERC1155 is IERC165 {
860     /**
861      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
862      */
863     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
864 
865     /**
866      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
867      * transfers.
868      */
869     event TransferBatch(
870         address indexed operator,
871         address indexed from,
872         address indexed to,
873         uint256[] ids,
874         uint256[] values
875     );
876 
877     /**
878      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
879      * `approved`.
880      */
881     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
882 
883     /**
884      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
885      *
886      * If an {URI} event was emitted for `id`, the standard
887      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
888      * returned by {IERC1155MetadataURI-uri}.
889      */
890     event URI(string value, uint256 indexed id);
891 
892     /**
893      * @dev Returns the amount of tokens of token type `id` owned by `account`.
894      *
895      * Requirements:
896      *
897      * - `account` cannot be the zero address.
898      */
899     function balanceOf(address account, uint256 id) external view returns (uint256);
900 
901     /**
902      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
903      *
904      * Requirements:
905      *
906      * - `accounts` and `ids` must have the same length.
907      */
908     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
909         external
910         view
911         returns (uint256[] memory);
912 
913     /**
914      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
915      *
916      * Emits an {ApprovalForAll} event.
917      *
918      * Requirements:
919      *
920      * - `operator` cannot be the caller.
921      */
922     function setApprovalForAll(address operator, bool approved) external;
923 
924     /**
925      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
926      *
927      * See {setApprovalForAll}.
928      */
929     function isApprovedForAll(address account, address operator) external view returns (bool);
930 
931     /**
932      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
933      *
934      * Emits a {TransferSingle} event.
935      *
936      * Requirements:
937      *
938      * - `to` cannot be the zero address.
939      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
940      * - `from` must have a balance of tokens of type `id` of at least `amount`.
941      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
942      * acceptance magic value.
943      */
944     function safeTransferFrom(
945         address from,
946         address to,
947         uint256 id,
948         uint256 amount,
949         bytes calldata data
950     ) external;
951 
952     /**
953      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
954      *
955      * Emits a {TransferBatch} event.
956      *
957      * Requirements:
958      *
959      * - `ids` and `amounts` must have the same length.
960      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
961      * acceptance magic value.
962      */
963     function safeBatchTransferFrom(
964         address from,
965         address to,
966         uint256[] calldata ids,
967         uint256[] calldata amounts,
968         bytes calldata data
969     ) external;
970 }
971 
972 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
973 
974 
975 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
976 
977 pragma solidity ^0.8.0;
978 
979 
980 /**
981  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
982  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
983  *
984  * _Available since v3.1._
985  */
986 interface IERC1155MetadataURI is IERC1155 {
987     /**
988      * @dev Returns the URI for token type `id`.
989      *
990      * If the `\{id\}` substring is present in the URI, it must be replaced by
991      * clients with the actual token type ID.
992      */
993     function uri(uint256 id) external view returns (string memory);
994 }
995 
996 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
997 
998 
999 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC1155/ERC1155.sol)
1000 
1001 pragma solidity ^0.8.0;
1002 
1003 
1004 
1005 
1006 
1007 
1008 
1009 /**
1010  * @dev Implementation of the basic standard multi-token.
1011  * See https://eips.ethereum.org/EIPS/eip-1155
1012  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
1013  *
1014  * _Available since v3.1._
1015  */
1016 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
1017     using Address for address;
1018 
1019     // Mapping from token ID to account balances
1020     mapping(uint256 => mapping(address => uint256)) private _balances;
1021 
1022     // Mapping from account to operator approvals
1023     mapping(address => mapping(address => bool)) private _operatorApprovals;
1024 
1025     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
1026     string private _uri;
1027 
1028     /**
1029      * @dev See {_setURI}.
1030      */
1031     constructor(string memory uri_) {
1032         _setURI(uri_);
1033     }
1034 
1035     /**
1036      * @dev See {IERC165-supportsInterface}.
1037      */
1038     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1039         return
1040             interfaceId == type(IERC1155).interfaceId ||
1041             interfaceId == type(IERC1155MetadataURI).interfaceId ||
1042             super.supportsInterface(interfaceId);
1043     }
1044 
1045     /**
1046      * @dev See {IERC1155MetadataURI-uri}.
1047      *
1048      * This implementation returns the same URI for *all* token types. It relies
1049      * on the token type ID substitution mechanism
1050      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1051      *
1052      * Clients calling this function must replace the `\{id\}` substring with the
1053      * actual token type ID.
1054      */
1055     function uri(uint256) public view virtual override returns (string memory) {
1056         return _uri;
1057     }
1058 
1059     /**
1060      * @dev See {IERC1155-balanceOf}.
1061      *
1062      * Requirements:
1063      *
1064      * - `account` cannot be the zero address.
1065      */
1066     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
1067         require(account != address(0), "ERC1155: balance query for the zero address");
1068         return _balances[id][account];
1069     }
1070 
1071     /**
1072      * @dev See {IERC1155-balanceOfBatch}.
1073      *
1074      * Requirements:
1075      *
1076      * - `accounts` and `ids` must have the same length.
1077      */
1078     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
1079         public
1080         view
1081         virtual
1082         override
1083         returns (uint256[] memory)
1084     {
1085         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
1086 
1087         uint256[] memory batchBalances = new uint256[](accounts.length);
1088 
1089         for (uint256 i = 0; i < accounts.length; ++i) {
1090             batchBalances[i] = balanceOf(accounts[i], ids[i]);
1091         }
1092 
1093         return batchBalances;
1094     }
1095 
1096     /**
1097      * @dev See {IERC1155-setApprovalForAll}.
1098      */
1099     function setApprovalForAll(address operator, bool approved) public virtual override {
1100         _setApprovalForAll(_msgSender(), operator, approved);
1101     }
1102 
1103     /**
1104      * @dev See {IERC1155-isApprovedForAll}.
1105      */
1106     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
1107         return _operatorApprovals[account][operator];
1108     }
1109 
1110     /**
1111      * @dev See {IERC1155-safeTransferFrom}.
1112      */
1113     function safeTransferFrom(
1114         address from,
1115         address to,
1116         uint256 id,
1117         uint256 amount,
1118         bytes memory data
1119     ) public virtual override {
1120         require(
1121             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1122             "ERC1155: caller is not owner nor approved"
1123         );
1124         _safeTransferFrom(from, to, id, amount, data);
1125     }
1126 
1127     /**
1128      * @dev See {IERC1155-safeBatchTransferFrom}.
1129      */
1130     function safeBatchTransferFrom(
1131         address from,
1132         address to,
1133         uint256[] memory ids,
1134         uint256[] memory amounts,
1135         bytes memory data
1136     ) public virtual override {
1137         require(
1138             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1139             "ERC1155: transfer caller is not owner nor approved"
1140         );
1141         _safeBatchTransferFrom(from, to, ids, amounts, data);
1142     }
1143 
1144     /**
1145      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1146      *
1147      * Emits a {TransferSingle} event.
1148      *
1149      * Requirements:
1150      *
1151      * - `to` cannot be the zero address.
1152      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1153      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1154      * acceptance magic value.
1155      */
1156     function _safeTransferFrom(
1157         address from,
1158         address to,
1159         uint256 id,
1160         uint256 amount,
1161         bytes memory data
1162     ) internal virtual {
1163         require(to != address(0), "ERC1155: transfer to the zero address");
1164 
1165         address operator = _msgSender();
1166         uint256[] memory ids = _asSingletonArray(id);
1167         uint256[] memory amounts = _asSingletonArray(amount);
1168 
1169         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1170 
1171         uint256 fromBalance = _balances[id][from];
1172         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1173         unchecked {
1174             _balances[id][from] = fromBalance - amount;
1175         }
1176         _balances[id][to] += amount;
1177 
1178         emit TransferSingle(operator, from, to, id, amount);
1179 
1180         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1181 
1182         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1183     }
1184 
1185     /**
1186      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1187      *
1188      * Emits a {TransferBatch} event.
1189      *
1190      * Requirements:
1191      *
1192      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1193      * acceptance magic value.
1194      */
1195     function _safeBatchTransferFrom(
1196         address from,
1197         address to,
1198         uint256[] memory ids,
1199         uint256[] memory amounts,
1200         bytes memory data
1201     ) internal virtual {
1202         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1203         require(to != address(0), "ERC1155: transfer to the zero address");
1204 
1205         address operator = _msgSender();
1206 
1207         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1208 
1209         for (uint256 i = 0; i < ids.length; ++i) {
1210             uint256 id = ids[i];
1211             uint256 amount = amounts[i];
1212 
1213             uint256 fromBalance = _balances[id][from];
1214             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1215             unchecked {
1216                 _balances[id][from] = fromBalance - amount;
1217             }
1218             _balances[id][to] += amount;
1219         }
1220 
1221         emit TransferBatch(operator, from, to, ids, amounts);
1222 
1223         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1224 
1225         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1226     }
1227 
1228     /**
1229      * @dev Sets a new URI for all token types, by relying on the token type ID
1230      * substitution mechanism
1231      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1232      *
1233      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1234      * URI or any of the amounts in the JSON file at said URI will be replaced by
1235      * clients with the token type ID.
1236      *
1237      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1238      * interpreted by clients as
1239      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1240      * for token type ID 0x4cce0.
1241      *
1242      * See {uri}.
1243      *
1244      * Because these URIs cannot be meaningfully represented by the {URI} event,
1245      * this function emits no events.
1246      */
1247     function _setURI(string memory newuri) internal virtual {
1248         _uri = newuri;
1249     }
1250 
1251     /**
1252      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
1253      *
1254      * Emits a {TransferSingle} event.
1255      *
1256      * Requirements:
1257      *
1258      * - `to` cannot be the zero address.
1259      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1260      * acceptance magic value.
1261      */
1262     function _mint(
1263         address to,
1264         uint256 id,
1265         uint256 amount,
1266         bytes memory data
1267     ) internal virtual {
1268         require(to != address(0), "ERC1155: mint to the zero address");
1269 
1270         address operator = _msgSender();
1271         uint256[] memory ids = _asSingletonArray(id);
1272         uint256[] memory amounts = _asSingletonArray(amount);
1273 
1274         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1275 
1276         _balances[id][to] += amount;
1277         emit TransferSingle(operator, address(0), to, id, amount);
1278 
1279         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1280 
1281         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
1282     }
1283 
1284     /**
1285      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1286      *
1287      * Requirements:
1288      *
1289      * - `ids` and `amounts` must have the same length.
1290      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1291      * acceptance magic value.
1292      */
1293     function _mintBatch(
1294         address to,
1295         uint256[] memory ids,
1296         uint256[] memory amounts,
1297         bytes memory data
1298     ) internal virtual {
1299         require(to != address(0), "ERC1155: mint to the zero address");
1300         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1301 
1302         address operator = _msgSender();
1303 
1304         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1305 
1306         for (uint256 i = 0; i < ids.length; i++) {
1307             _balances[ids[i]][to] += amounts[i];
1308         }
1309 
1310         emit TransferBatch(operator, address(0), to, ids, amounts);
1311 
1312         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1313 
1314         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1315     }
1316 
1317     /**
1318      * @dev Destroys `amount` tokens of token type `id` from `from`
1319      *
1320      * Requirements:
1321      *
1322      * - `from` cannot be the zero address.
1323      * - `from` must have at least `amount` tokens of token type `id`.
1324      */
1325     function _burn(
1326         address from,
1327         uint256 id,
1328         uint256 amount
1329     ) internal virtual {
1330         require(from != address(0), "ERC1155: burn from the zero address");
1331 
1332         address operator = _msgSender();
1333         uint256[] memory ids = _asSingletonArray(id);
1334         uint256[] memory amounts = _asSingletonArray(amount);
1335 
1336         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1337 
1338         uint256 fromBalance = _balances[id][from];
1339         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1340         unchecked {
1341             _balances[id][from] = fromBalance - amount;
1342         }
1343 
1344         emit TransferSingle(operator, from, address(0), id, amount);
1345 
1346         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1347     }
1348 
1349     /**
1350      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1351      *
1352      * Requirements:
1353      *
1354      * - `ids` and `amounts` must have the same length.
1355      */
1356     function _burnBatch(
1357         address from,
1358         uint256[] memory ids,
1359         uint256[] memory amounts
1360     ) internal virtual {
1361         require(from != address(0), "ERC1155: burn from the zero address");
1362         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1363 
1364         address operator = _msgSender();
1365 
1366         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1367 
1368         for (uint256 i = 0; i < ids.length; i++) {
1369             uint256 id = ids[i];
1370             uint256 amount = amounts[i];
1371 
1372             uint256 fromBalance = _balances[id][from];
1373             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1374             unchecked {
1375                 _balances[id][from] = fromBalance - amount;
1376             }
1377         }
1378 
1379         emit TransferBatch(operator, from, address(0), ids, amounts);
1380 
1381         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1382     }
1383 
1384     /**
1385      * @dev Approve `operator` to operate on all of `owner` tokens
1386      *
1387      * Emits a {ApprovalForAll} event.
1388      */
1389     function _setApprovalForAll(
1390         address owner,
1391         address operator,
1392         bool approved
1393     ) internal virtual {
1394         require(owner != operator, "ERC1155: setting approval status for self");
1395         _operatorApprovals[owner][operator] = approved;
1396         emit ApprovalForAll(owner, operator, approved);
1397     }
1398 
1399     /**
1400      * @dev Hook that is called before any token transfer. This includes minting
1401      * and burning, as well as batched variants.
1402      *
1403      * The same hook is called on both single and batched variants. For single
1404      * transfers, the length of the `id` and `amount` arrays will be 1.
1405      *
1406      * Calling conditions (for each `id` and `amount` pair):
1407      *
1408      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1409      * of token type `id` will be  transferred to `to`.
1410      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1411      * for `to`.
1412      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1413      * will be burned.
1414      * - `from` and `to` are never both zero.
1415      * - `ids` and `amounts` have the same, non-zero length.
1416      *
1417      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1418      */
1419     function _beforeTokenTransfer(
1420         address operator,
1421         address from,
1422         address to,
1423         uint256[] memory ids,
1424         uint256[] memory amounts,
1425         bytes memory data
1426     ) internal virtual {}
1427 
1428     /**
1429      * @dev Hook that is called after any token transfer. This includes minting
1430      * and burning, as well as batched variants.
1431      *
1432      * The same hook is called on both single and batched variants. For single
1433      * transfers, the length of the `id` and `amount` arrays will be 1.
1434      *
1435      * Calling conditions (for each `id` and `amount` pair):
1436      *
1437      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1438      * of token type `id` will be  transferred to `to`.
1439      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1440      * for `to`.
1441      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1442      * will be burned.
1443      * - `from` and `to` are never both zero.
1444      * - `ids` and `amounts` have the same, non-zero length.
1445      *
1446      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1447      */
1448     function _afterTokenTransfer(
1449         address operator,
1450         address from,
1451         address to,
1452         uint256[] memory ids,
1453         uint256[] memory amounts,
1454         bytes memory data
1455     ) internal virtual {}
1456 
1457     function _doSafeTransferAcceptanceCheck(
1458         address operator,
1459         address from,
1460         address to,
1461         uint256 id,
1462         uint256 amount,
1463         bytes memory data
1464     ) private {
1465         if (to.isContract()) {
1466             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1467                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1468                     revert("ERC1155: ERC1155Receiver rejected tokens");
1469                 }
1470             } catch Error(string memory reason) {
1471                 revert(reason);
1472             } catch {
1473                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1474             }
1475         }
1476     }
1477 
1478     function _doSafeBatchTransferAcceptanceCheck(
1479         address operator,
1480         address from,
1481         address to,
1482         uint256[] memory ids,
1483         uint256[] memory amounts,
1484         bytes memory data
1485     ) private {
1486         if (to.isContract()) {
1487             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1488                 bytes4 response
1489             ) {
1490                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1491                     revert("ERC1155: ERC1155Receiver rejected tokens");
1492                 }
1493             } catch Error(string memory reason) {
1494                 revert(reason);
1495             } catch {
1496                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1497             }
1498         }
1499     }
1500 
1501     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1502         uint256[] memory array = new uint256[](1);
1503         array[0] = element;
1504 
1505         return array;
1506     }
1507 }
1508 
1509 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol
1510 
1511 
1512 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC1155/extensions/ERC1155Supply.sol)
1513 
1514 pragma solidity ^0.8.0;
1515 
1516 
1517 /**
1518  * @dev Extension of ERC1155 that adds tracking of total supply per id.
1519  *
1520  * Useful for scenarios where Fungible and Non-fungible tokens have to be
1521  * clearly identified. Note: While a totalSupply of 1 might mean the
1522  * corresponding is an NFT, there is no guarantees that no other token with the
1523  * same id are not going to be minted.
1524  */
1525 abstract contract ERC1155Supply is ERC1155 {
1526     mapping(uint256 => uint256) private _totalSupply;
1527 
1528     /**
1529      * @dev Total amount of tokens in with a given id.
1530      */
1531     function totalSupply(uint256 id) public view virtual returns (uint256) {
1532         return _totalSupply[id];
1533     }
1534 
1535     /**
1536      * @dev Indicates whether any token exist with a given id, or not.
1537      */
1538     function exists(uint256 id) public view virtual returns (bool) {
1539         return ERC1155Supply.totalSupply(id) > 0;
1540     }
1541 
1542     /**
1543      * @dev See {ERC1155-_beforeTokenTransfer}.
1544      */
1545     function _beforeTokenTransfer(
1546         address operator,
1547         address from,
1548         address to,
1549         uint256[] memory ids,
1550         uint256[] memory amounts,
1551         bytes memory data
1552     ) internal virtual override {
1553         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1554 
1555         if (from == address(0)) {
1556             for (uint256 i = 0; i < ids.length; ++i) {
1557                 _totalSupply[ids[i]] += amounts[i];
1558             }
1559         }
1560 
1561         if (to == address(0)) {
1562             for (uint256 i = 0; i < ids.length; ++i) {
1563                 uint256 id = ids[i];
1564                 uint256 amount = amounts[i];
1565                 uint256 supply = _totalSupply[id];
1566                 require(supply >= amount, "ERC1155: burn amount exceeds totalSupply");
1567                 unchecked {
1568                     _totalSupply[id] = supply - amount;
1569                 }
1570             }
1571         }
1572     }
1573 }
1574 
1575 // File: contracts/Code Green.sol
1576 
1577 
1578 pragma solidity ^0.8.7;
1579 
1580 
1581 
1582 
1583 
1584 contract CodeGreenHealPass is ERC1155Supply, Ownable, Pausable {
1585     using ECDSA for bytes32;
1586 
1587     // Contract name
1588     string public name;
1589     // Contract symbol
1590     string public symbol;
1591 
1592     uint256 public constant TOKEN_ID_1 = 1;
1593     uint256 public constant TOKEN_ID_2 = 2;
1594     uint256 public constant TOKEN_ID_3 = 3;
1595     uint256 public constant MAX_SUPPLY = 5000;
1596 
1597     bool public preSaleIsActive = false;
1598     bool public publicSaleIsActive = false;
1599 
1600     // Used to validate authorized mint addresses
1601     address private signerAddress = 0xabcB40408a94E94f563d64ded69A75a3098cBf59;
1602 
1603     // Used to ensure each new token id can only be minted once by the owner
1604     mapping (uint256 => bool) public collectionMinted;
1605     mapping (uint256 => string) public tokenURI;
1606     mapping (address => bool) public hasAddressMinted;
1607 
1608     constructor(
1609         string memory uriBase,
1610         string memory uri1,
1611         string memory uri2,
1612         string memory uri3,
1613         string memory _name,
1614         string memory _symbol
1615     ) ERC1155(uriBase) {
1616         name = _name;
1617         symbol = _symbol;
1618         tokenURI[TOKEN_ID_1] = uri1;
1619         tokenURI[TOKEN_ID_2] = uri2;
1620         tokenURI[TOKEN_ID_3] = uri3;
1621     }
1622 
1623     /**
1624      * @notice Prevent contract-to-contract calls
1625      */
1626     modifier originalUser() {
1627         require(
1628             msg.sender == tx.origin,
1629             "Must invoke directly from your wallet"
1630         );
1631         _;
1632     }
1633 
1634     /**
1635      * Returns the custom URI for each token id. Overrides the default ERC-1155 single URI.
1636      */
1637     function uri(uint256 tokenId) public view override returns (string memory) {
1638         // If no URI exists for the specific id requested, fallback to the default ERC-1155 URI.
1639         if (bytes(tokenURI[tokenId]).length == 0) {
1640             return super.uri(tokenId);
1641         }
1642         return tokenURI[tokenId];
1643     }
1644 
1645     /**
1646      * Sets a URI for a specific token id.
1647      */
1648     function setURI(string memory newTokenURI, uint256 tokenId) public onlyOwner {
1649         tokenURI[tokenId] = newTokenURI;
1650     }
1651 
1652     /**
1653      * Set the global default ERC-1155 base URI to be used for any tokens without unique URIs
1654      */
1655     function setGlobalURI(string memory newTokenURI) public onlyOwner {
1656         _setURI(newTokenURI);
1657     }
1658 
1659     function setPreSaleState(bool newState) public onlyOwner {
1660         require(preSaleIsActive != newState, "NEW_STATE_IDENTICAL_TO_OLD_STATE");
1661         preSaleIsActive = newState;
1662     }
1663 
1664     function setPublicSaleState(bool newState) public onlyOwner {
1665         require(publicSaleIsActive != newState, "NEW_STATE_IDENTICAL_TO_OLD_STATE");
1666         publicSaleIsActive = newState;
1667     }
1668 
1669     function setSignerAddress(address _signerAddress) external onlyOwner {
1670         require(_signerAddress != address(0));
1671         signerAddress = _signerAddress;
1672     }
1673 
1674     function pause() public onlyOwner {
1675         _pause();
1676     }
1677 
1678     function unpause() public onlyOwner {
1679         _unpause();
1680     }
1681 
1682     function verifyAddressSigner(bytes32 messageHash, bytes memory signature) private view returns (bool) {
1683         return signerAddress == messageHash.toEthSignedMessageHash().recover(signature);
1684     }
1685 
1686     function hashMessage(address sender) private pure returns (bytes32) {
1687         return keccak256(abi.encode(sender));
1688     }
1689 
1690     function determineMintId(uint256 nonce) private view returns (uint256) {
1691         bytes32 randomHash = keccak256(abi.encodePacked(block.timestamp, block.difficulty, blockhash(block.number - 1), nonce));
1692         if (randomHash[0] >= 0xF9) {
1693             return TOKEN_ID_2;
1694         } else {
1695             return TOKEN_ID_1;
1696         }
1697     }
1698 
1699     /**
1700      * @notice Allow minting of tokens by addresses authorized to mint in the presale only
1701      */
1702     function preSaleMint(bytes32 messageHash, bytes calldata signature) external originalUser {
1703         require(preSaleIsActive, "SALE_NOT_ACTIVE");
1704         require(hasAddressMinted[msg.sender] == false, "ADDRESS_HAS_ALREADY_MINTED");
1705         uint256 tokensMinted = totalSupply(TOKEN_ID_1) + totalSupply(TOKEN_ID_2) + totalSupply(TOKEN_ID_3);
1706         require(tokensMinted < MAX_SUPPLY, "MAX_TOKENS_MINTED");
1707         require(hashMessage(msg.sender) == messageHash, "MESSAGE_INVALID");
1708         require(verifyAddressSigner(messageHash, signature), "SIGNATURE_VALIDATION_FAILED");
1709 
1710         hasAddressMinted[msg.sender] = true;
1711         _mint(msg.sender, determineMintId(1), 1, "");
1712     }
1713 
1714     function mint() external originalUser {
1715         require(publicSaleIsActive, "SALE_NOT_ACTIVE");
1716         require(hasAddressMinted[msg.sender] == false, "ADDRESS_HAS_ALREADY_MINTED");
1717         uint256 tokensMinted = totalSupply(TOKEN_ID_1) + totalSupply(TOKEN_ID_2) + totalSupply(TOKEN_ID_3);
1718         require(tokensMinted < MAX_SUPPLY, "MAX_TOKENS_MINTED");
1719 
1720         hasAddressMinted[msg.sender] = true;
1721         _mint(msg.sender, determineMintId(1), 1, "");
1722 
1723         if (tokensMinted + 1 >= MAX_SUPPLY) {
1724             publicSaleIsActive = false;
1725         }
1726     }
1727 
1728     /**
1729      * @notice Allow minting of any future tokens as desired as part of the same collection,
1730      * which can then be transferred to another contract for distribution purposes
1731      */
1732     function adminMint(address account, uint256 id, uint256 amount) public onlyOwner
1733     {
1734         require(!collectionMinted[id], "CANNOT_MINT_EXISTING_TOKEN_ID");
1735         require(id != TOKEN_ID_1 && id != TOKEN_ID_2 && id != TOKEN_ID_3, "CANNOT_MINT_EXISTING_TOKEN_ID");
1736         collectionMinted[id] = true;
1737         _mint(account, id, amount, "");
1738     }
1739 
1740     /**
1741      * @notice Allow owner to send `mintNumber` tokens without cost to multiple addresses
1742      */
1743     function giftDeterministic(address[] calldata receivers, uint256 numberOfTokens, uint256 tokenId) external onlyOwner {
1744         require(tokenId == TOKEN_ID_1 || tokenId == TOKEN_ID_2 || tokenId == TOKEN_ID_3, "INVALID_TOKEN_ID");
1745         require(totalSupply(TOKEN_ID_1) + totalSupply(TOKEN_ID_2) + totalSupply(TOKEN_ID_3) + (receivers.length * numberOfTokens) <= MAX_SUPPLY, "MINT_TOO_LARGE");
1746         for (uint256 i = 0; i < receivers.length; i++) {
1747             _mint(receivers[i], tokenId, numberOfTokens, "");
1748         }
1749     }
1750 
1751     /**
1752      * @notice Allow owner to send `mintNumber` tokens without cost to multiple addresses
1753      */
1754     function giftRandom(address[] calldata receivers) external onlyOwner {
1755         require(totalSupply(TOKEN_ID_1) + totalSupply(TOKEN_ID_2) + totalSupply(TOKEN_ID_3) + receivers.length <= MAX_SUPPLY, "MINT_TOO_LARGE");
1756         for (uint256 i = 0; i < receivers.length; i++) {
1757             _mint(receivers[i], determineMintId(i), 1, "");
1758         }
1759     }
1760 
1761     /**
1762      * @notice Override ERC1155 such that zero amount token transfers are disallowed to prevent arbitrary creation of new tokens in the collection.
1763      */
1764     function safeTransferFrom(
1765         address from,
1766         address to,
1767         uint256 id,
1768         uint256 amount,
1769         bytes memory data
1770     ) public override {
1771         require(amount > 0, "AMOUNT_CANNOT_BE_ZERO");
1772         return super.safeTransferFrom(from, to, id, amount, data);
1773     }
1774 
1775     /**
1776      * @notice When the contract is paused, all token transfers are prevented in case of emergency.
1777      */
1778     function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
1779         internal
1780         whenNotPaused
1781         override
1782     {
1783         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1784     }
1785 }