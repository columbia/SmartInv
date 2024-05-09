1 /**
2  *Submitted for verification at Etherscan.io on 2022-06-12
3 */
4 
5 // _____/\\\\\\\\\\\\______________________________________________________________________________/\\\\\\\\\\\\______________________________________/\\\_______________________________        
6 //  ___/\\\//////////_____________________________________________________________________________/\\\//////////______________________________________\/\\\_______________________________       
7 //   __/\\\_______________________________________________________________________________________/\\\_________________________________________________\/\\\_______________________________      
8 //    _\/\\\____/\\\\\\\__/\\/\\\\\\_______/\\\\\_______/\\\\\__/\\\\\_______/\\\\\\\\____________\/\\\____/\\\\\\\__/\\\\\\\\\_____/\\/\\\\\\\_________\/\\\______/\\\\\\\\___/\\/\\\\\\___     
9 //     _\/\\\___\/////\\\_\/\\\////\\\____/\\\///\\\___/\\\///\\\\\///\\\___/\\\/////\\\___________\/\\\___\/////\\\_\////////\\\___\/\\\/////\\\___/\\\\\\\\\____/\\\/////\\\_\/\\\////\\\__    
10 //      _\/\\\_______\/\\\_\/\\\__\//\\\__/\\\__\//\\\_\/\\\_\//\\\__\/\\\__/\\\\\\\\\\\____________\/\\\_______\/\\\___/\\\\\\\\\\__\/\\\___\///___/\\\////\\\___/\\\\\\\\\\\__\/\\\__\//\\\_   
11 //       _\/\\\_______\/\\\_\/\\\___\/\\\_\//\\\__/\\\__\/\\\__\/\\\__\/\\\_\//\\///////_____________\/\\\_______\/\\\__/\\\/////\\\__\/\\\_________\/\\\__\/\\\__\//\\///////___\/\\\___\/\\\_  
12 //        _\//\\\\\\\\\\\\/__\/\\\___\/\\\__\///\\\\\/___\/\\\__\/\\\__\/\\\__\//\\\\\\\\\\___________\//\\\\\\\\\\\\/__\//\\\\\\\\/\\_\/\\\_________\//\\\\\\\/\\__\//\\\\\\\\\\_\/\\\___\/\\\_ 
13 //         __\////////////____\///____\///_____\/////_____\///___\///___\///____\//////////_____________\////////////_____\////////\//__\///___________\///////\//____\//////////__\///____\///__
14 
15 // SPDX-License-Identifier: MIT
16 
17 pragma solidity ^0.8.0;
18 
19 /**
20  * @dev String operations.
21  */
22 library Strings {
23     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
24 
25     /**
26      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
27      */
28     function toString(uint256 value) internal pure returns (string memory) {
29         // Inspired by OraclizeAPI's implementation - MIT licence
30         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
31 
32         if (value == 0) {
33             return "0";
34         }
35         uint256 temp = value;
36         uint256 digits;
37         while (temp != 0) {
38             digits++;
39             temp /= 10;
40         }
41         bytes memory buffer = new bytes(digits);
42         while (value != 0) {
43             digits -= 1;
44             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
45             value /= 10;
46         }
47         return string(buffer);
48     }
49 
50     /**
51      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
52      */
53     function toHexString(uint256 value) internal pure returns (string memory) {
54         if (value == 0) {
55             return "0x00";
56         }
57         uint256 temp = value;
58         uint256 length = 0;
59         while (temp != 0) {
60             length++;
61             temp >>= 8;
62         }
63         return toHexString(value, length);
64     }
65 
66     /**
67      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
68      */
69     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
70         bytes memory buffer = new bytes(2 * length + 2);
71         buffer[0] = "0";
72         buffer[1] = "x";
73         for (uint256 i = 2 * length + 1; i > 1; --i) {
74             buffer[i] = _HEX_SYMBOLS[value & 0xf];
75             value >>= 4;
76         }
77         require(value == 0, "Strings: hex length insufficient");
78         return string(buffer);
79     }
80 }
81 // File: ECDSA.sol
82 
83 
84 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
85 
86 pragma solidity ^0.8.0;
87 
88 
89 /**
90  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
91  *
92  * These functions can be used to verify that a message was signed by the holder
93  * of the private keys of a given address.
94  */
95 library ECDSA {
96     enum RecoverError {
97         NoError,
98         InvalidSignature,
99         InvalidSignatureLength,
100         InvalidSignatureS,
101         InvalidSignatureV
102     }
103 
104     function _throwError(RecoverError error) private pure {
105         if (error == RecoverError.NoError) {
106             return; // no error: do nothing
107         } else if (error == RecoverError.InvalidSignature) {
108             revert("ECDSA: invalid signature");
109         } else if (error == RecoverError.InvalidSignatureLength) {
110             revert("ECDSA: invalid signature length");
111         } else if (error == RecoverError.InvalidSignatureS) {
112             revert("ECDSA: invalid signature 's' value");
113         } else if (error == RecoverError.InvalidSignatureV) {
114             revert("ECDSA: invalid signature 'v' value");
115         }
116     }
117 
118     /**
119      * @dev Returns the address that signed a hashed message (`hash`) with
120      * `signature` or error string. This address can then be used for verification purposes.
121      *
122      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
123      * this function rejects them by requiring the `s` value to be in the lower
124      * half order, and the `v` value to be either 27 or 28.
125      *
126      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
127      * verification to be secure: it is possible to craft signatures that
128      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
129      * this is by receiving a hash of the original message (which may otherwise
130      * be too long), and then calling {toEthSignedMessageHash} on it.
131      *
132      * Documentation for signature generation:
133      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
134      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
135      *
136      * _Available since v4.3._
137      */
138     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
139         // Check the signature length
140         // - case 65: r,s,v signature (standard)
141         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
142         if (signature.length == 65) {
143             bytes32 r;
144             bytes32 s;
145             uint8 v;
146             // ecrecover takes the signature parameters, and the only way to get them
147             // currently is to use assembly.
148             assembly {
149                 r := mload(add(signature, 0x20))
150                 s := mload(add(signature, 0x40))
151                 v := byte(0, mload(add(signature, 0x60)))
152             }
153             return tryRecover(hash, v, r, s);
154         } else if (signature.length == 64) {
155             bytes32 r;
156             bytes32 vs;
157             // ecrecover takes the signature parameters, and the only way to get them
158             // currently is to use assembly.
159             assembly {
160                 r := mload(add(signature, 0x20))
161                 vs := mload(add(signature, 0x40))
162             }
163             return tryRecover(hash, r, vs);
164         } else {
165             return (address(0), RecoverError.InvalidSignatureLength);
166         }
167     }
168 
169     /**
170      * @dev Returns the address that signed a hashed message (`hash`) with
171      * `signature`. This address can then be used for verification purposes.
172      *
173      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
174      * this function rejects them by requiring the `s` value to be in the lower
175      * half order, and the `v` value to be either 27 or 28.
176      *
177      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
178      * verification to be secure: it is possible to craft signatures that
179      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
180      * this is by receiving a hash of the original message (which may otherwise
181      * be too long), and then calling {toEthSignedMessageHash} on it.
182      */
183     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
184         (address recovered, RecoverError error) = tryRecover(hash, signature);
185         _throwError(error);
186         return recovered;
187     }
188 
189     /**
190      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
191      *
192      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
193      *
194      * _Available since v4.3._
195      */
196     function tryRecover(
197         bytes32 hash,
198         bytes32 r,
199         bytes32 vs
200     ) internal pure returns (address, RecoverError) {
201         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
202         uint8 v = uint8((uint256(vs) >> 255) + 27);
203         return tryRecover(hash, v, r, s);
204     }
205 
206     /**
207      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
208      *
209      * _Available since v4.2._
210      */
211     function recover(
212         bytes32 hash,
213         bytes32 r,
214         bytes32 vs
215     ) internal pure returns (address) {
216         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
217         _throwError(error);
218         return recovered;
219     }
220 
221     /**
222      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
223      * `r` and `s` signature fields separately.
224      *
225      * _Available since v4.3._
226      */
227     function tryRecover(
228         bytes32 hash,
229         uint8 v,
230         bytes32 r,
231         bytes32 s
232     ) internal pure returns (address, RecoverError) {
233         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
234         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
235         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
236         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
237         //
238         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
239         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
240         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
241         // these malleable signatures as well.
242         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
243             return (address(0), RecoverError.InvalidSignatureS);
244         }
245         if (v != 27 && v != 28) {
246             return (address(0), RecoverError.InvalidSignatureV);
247         }
248 
249         // If the signature is valid (and not malleable), return the signer address
250         address signer = ecrecover(hash, v, r, s);
251         if (signer == address(0)) {
252             return (address(0), RecoverError.InvalidSignature);
253         }
254 
255         return (signer, RecoverError.NoError);
256     }
257 
258     /**
259      * @dev Overload of {ECDSA-recover} that receives the `v`,
260      * `r` and `s` signature fields separately.
261      */
262     function recover(
263         bytes32 hash,
264         uint8 v,
265         bytes32 r,
266         bytes32 s
267     ) internal pure returns (address) {
268         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
269         _throwError(error);
270         return recovered;
271     }
272 
273     /**
274      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
275      * produces hash corresponding to the one signed with the
276      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
277      * JSON-RPC method as part of EIP-191.
278      *
279      * See {recover}.
280      */
281     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
282         // 32 is the length in bytes of hash,
283         // enforced by the type signature above
284         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
285     }
286 
287     /**
288      * @dev Returns an Ethereum Signed Message, created from `s`. This
289      * produces hash corresponding to the one signed with the
290      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
291      * JSON-RPC method as part of EIP-191.
292      *
293      * See {recover}.
294      */
295     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
296         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
297     }
298 
299     /**
300      * @dev Returns an Ethereum Signed Typed Data, created from a
301      * `domainSeparator` and a `structHash`. This produces hash corresponding
302      * to the one signed with the
303      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
304      * JSON-RPC method as part of EIP-712.
305      *
306      * See {recover}.
307      */
308     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
309         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
310     }
311 }
312 // File: Context.sol
313 
314 
315 
316 pragma solidity ^0.8.0;
317 
318 /**
319  * @dev Provides information about the current execution context, including the
320  * sender of the transaction and its data. While these are generally available
321  * via msg.sender and msg.data, they should not be accessed in such a direct
322  * manner, since when dealing with meta-transactions the account sending and
323  * paying for execution may not be the actual sender (as far as an application
324  * is concerned).
325  *
326  * This contract is only required for intermediate, library-like contracts.
327  */
328 abstract contract Context {
329     function _msgSender() internal view virtual returns (address) {
330         return msg.sender;
331     }
332 
333     function _msgData() internal view virtual returns (bytes calldata) {
334         return msg.data;
335     }
336 }
337 // File: Ownable.sol
338 
339 
340 
341 pragma solidity ^0.8.0;
342 
343 
344 /**
345  * @dev Contract module which provides a basic access control mechanism, where
346  * there is an account (an owner) that can be granted exclusive access to
347  * specific functions.
348  *
349  * By default, the owner account will be the one that deploys the contract. This
350  * can later be changed with {transferOwnership}.
351  *
352  * This module is used through inheritance. It will make available the modifier
353  * `onlyOwner`, which can be applied to your functions to restrict their use to
354  * the owner.
355  */
356 abstract contract Ownable is Context {
357     address private _owner;
358 
359     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
360 
361     /**
362      * @dev Initializes the contract setting the deployer as the initial owner.
363      */
364     constructor() {
365         _setOwner(_msgSender());
366     }
367 
368     /**
369      * @dev Returns the address of the current owner.
370      */
371     function owner() public view virtual returns (address) {
372         return _owner;
373     }
374 
375     /**
376      * @dev Throws if called by any account other than the owner.
377      */
378     modifier onlyOwner() {
379         require(owner() == _msgSender(), "Ownable: caller is not the owner");
380         _;
381     }
382 
383     /**
384      * @dev Leaves the contract without owner. It will not be possible to call
385      * `onlyOwner` functions anymore. Can only be called by the current owner.
386      *
387      * NOTE: Renouncing ownership will leave the contract without an owner,
388      * thereby removing any functionality that is only available to the owner.
389      */
390     function renounceOwnership() public virtual onlyOwner {
391         _setOwner(address(0));
392     }
393 
394     /**
395      * @dev Transfers ownership of the contract to a new account (`newOwner`).
396      * Can only be called by the current owner.
397      */
398     function transferOwnership(address newOwner) public virtual onlyOwner {
399         require(newOwner != address(0), "Ownable: new owner is the zero address");
400         _setOwner(newOwner);
401     }
402 
403     function _setOwner(address newOwner) private {
404         address oldOwner = _owner;
405         _owner = newOwner;
406         emit OwnershipTransferred(oldOwner, newOwner);
407     }
408 }
409 // File: Address.sol
410 
411 
412 
413 pragma solidity ^0.8.0;
414 
415 /**
416  * @dev Collection of functions related to the address type
417  */
418 library Address {
419     /**
420      * @dev Returns true if `account` is a contract.
421      *
422      * [IMPORTANT]
423      * ====
424      * It is unsafe to assume that an address for which this function returns
425      * false is an externally-owned account (EOA) and not a contract.
426      *
427      * Among others, `isContract` will return false for the following
428      * types of addresses:
429      *
430      *  - an externally-owned account
431      *  - a contract in construction
432      *  - an address where a contract will be created
433      *  - an address where a contract lived, but was destroyed
434      * ====
435      */
436     function isContract(address account) internal view returns (bool) {
437         // This method relies on extcodesize, which returns 0 for contracts in
438         // construction, since the code is only stored at the end of the
439         // constructor execution.
440 
441         uint256 size;
442         assembly {
443             size := extcodesize(account)
444         }
445         return size > 0;
446     }
447 
448     /**
449      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
450      * `recipient`, forwarding all available gas and reverting on errors.
451      *
452      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
453      * of certain opcodes, possibly making contracts go over the 2300 gas limit
454      * imposed by `transfer`, making them unable to receive funds via
455      * `transfer`. {sendValue} removes this limitation.
456      *
457      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
458      *
459      * IMPORTANT: because control is transferred to `recipient`, care must be
460      * taken to not create reentrancy vulnerabilities. Consider using
461      * {ReentrancyGuard} or the
462      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
463      */
464     function sendValue(address payable recipient, uint256 amount) internal {
465         require(address(this).balance >= amount, "Address: insufficient balance");
466 
467         (bool success, ) = recipient.call{value: amount}("");
468         require(success, "Address: unable to send value, recipient may have reverted");
469     }
470 
471     /**
472      * @dev Performs a Solidity function call using a low level `call`. A
473      * plain `call` is an unsafe replacement for a function call: use this
474      * function instead.
475      *
476      * If `target` reverts with a revert reason, it is bubbled up by this
477      * function (like regular Solidity function calls).
478      *
479      * Returns the raw returned data. To convert to the expected return value,
480      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
481      *
482      * Requirements:
483      *
484      * - `target` must be a contract.
485      * - calling `target` with `data` must not revert.
486      *
487      * _Available since v3.1._
488      */
489     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
490         return functionCall(target, data, "Address: low-level call failed");
491     }
492 
493     /**
494      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
495      * `errorMessage` as a fallback revert reason when `target` reverts.
496      *
497      * _Available since v3.1._
498      */
499     function functionCall(
500         address target,
501         bytes memory data,
502         string memory errorMessage
503     ) internal returns (bytes memory) {
504         return functionCallWithValue(target, data, 0, errorMessage);
505     }
506 
507     /**
508      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
509      * but also transferring `value` wei to `target`.
510      *
511      * Requirements:
512      *
513      * - the calling contract must have an ETH balance of at least `value`.
514      * - the called Solidity function must be `payable`.
515      *
516      * _Available since v3.1._
517      */
518     function functionCallWithValue(
519         address target,
520         bytes memory data,
521         uint256 value
522     ) internal returns (bytes memory) {
523         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
524     }
525 
526     /**
527      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
528      * with `errorMessage` as a fallback revert reason when `target` reverts.
529      *
530      * _Available since v3.1._
531      */
532     function functionCallWithValue(
533         address target,
534         bytes memory data,
535         uint256 value,
536         string memory errorMessage
537     ) internal returns (bytes memory) {
538         require(address(this).balance >= value, "Address: insufficient balance for call");
539         require(isContract(target), "Address: call to non-contract");
540 
541         (bool success, bytes memory returndata) = target.call{value: value}(data);
542         return _verifyCallResult(success, returndata, errorMessage);
543     }
544 
545     /**
546      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
547      * but performing a static call.
548      *
549      * _Available since v3.3._
550      */
551     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
552         return functionStaticCall(target, data, "Address: low-level static call failed");
553     }
554 
555     /**
556      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
557      * but performing a static call.
558      *
559      * _Available since v3.3._
560      */
561     function functionStaticCall(
562         address target,
563         bytes memory data,
564         string memory errorMessage
565     ) internal view returns (bytes memory) {
566         require(isContract(target), "Address: static call to non-contract");
567 
568         (bool success, bytes memory returndata) = target.staticcall(data);
569         return _verifyCallResult(success, returndata, errorMessage);
570     }
571 
572     /**
573      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
574      * but performing a delegate call.
575      *
576      * _Available since v3.4._
577      */
578     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
579         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
580     }
581 
582     /**
583      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
584      * but performing a delegate call.
585      *
586      * _Available since v3.4._
587      */
588     function functionDelegateCall(
589         address target,
590         bytes memory data,
591         string memory errorMessage
592     ) internal returns (bytes memory) {
593         require(isContract(target), "Address: delegate call to non-contract");
594 
595         (bool success, bytes memory returndata) = target.delegatecall(data);
596         return _verifyCallResult(success, returndata, errorMessage);
597     }
598 
599     function _verifyCallResult(
600         bool success,
601         bytes memory returndata,
602         string memory errorMessage
603     ) private pure returns (bytes memory) {
604         if (success) {
605             return returndata;
606         } else {
607             // Look for revert reason and bubble it up if present
608             if (returndata.length > 0) {
609                 // The easiest way to bubble the revert reason is using memory via assembly
610 
611                 assembly {
612                     let returndata_size := mload(returndata)
613                     revert(add(32, returndata), returndata_size)
614                 }
615             } else {
616                 revert(errorMessage);
617             }
618         }
619     }
620 }
621 // File: Payment.sol
622 
623 
624 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
625 
626 pragma solidity ^0.8.0;
627 
628 
629 
630 /**
631  * @title PaymentSplitter
632  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
633  * that the Ether will be split in this way, since it is handled transparently by the contract.
634  *
635  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
636  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
637  * an amount proportional to the percentage of total shares they were assigned.
638  *
639  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
640  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
641  * function.
642  *
643  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
644  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
645  * to run tests before sending real value to this contract.
646  */
647 contract Payment is Context {
648     event PayeeAdded(address account, uint256 shares);
649     event PaymentReleased(address to, uint256 amount);
650     event PaymentReceived(address from, uint256 amount);
651 
652     uint256 private _totalShares;
653     uint256 private _totalReleased;
654 
655     mapping(address => uint256) private _shares;
656     mapping(address => uint256) private _released;
657     address[] private _payees;
658 
659     /**
660      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
661      * the matching position in the `shares` array.
662      *
663      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
664      * duplicates in `payees`.
665      */
666     constructor(address[] memory payees, uint256[] memory shares_) payable {
667         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
668         require(payees.length > 0, "PaymentSplitter: no payees");
669 
670         for (uint256 i = 0; i < payees.length; i++) {
671             _addPayee(payees[i], shares_[i]);
672         }
673     }
674 
675     /**
676      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
677      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
678      * reliability of the events, and not the actual splitting of Ether.
679      *
680      * To learn more about this see the Solidity documentation for
681      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
682      * functions].
683      */
684     receive() external payable virtual {
685         emit PaymentReceived(_msgSender(), msg.value);
686     }
687 
688     /**
689      * @dev Getter for the total shares held by payees.
690      */
691     function totalShares() public view returns (uint256) {
692         return _totalShares;
693     }
694 
695     /**
696      * @dev Getter for the total amount of Ether already released.
697      */
698     function totalReleased() public view returns (uint256) {
699         return _totalReleased;
700     }
701 
702 
703     /**
704      * @dev Getter for the amount of shares held by an account.
705      */
706     function shares(address account) public view returns (uint256) {
707         return _shares[account];
708     }
709 
710     /**
711      * @dev Getter for the amount of Ether already released to a payee.
712      */
713     function released(address account) public view returns (uint256) {
714         return _released[account];
715     }
716 
717 
718     /**
719      * @dev Getter for the address of the payee number `index`.
720      */
721     function payee(uint256 index) public view returns (address) {
722         return _payees[index];
723     }
724 
725     /**
726      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
727      * total shares and their previous withdrawals.
728      */
729     function release(address payable account) public virtual {
730         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
731 
732         uint256 totalReceived = address(this).balance + totalReleased();
733         uint256 payment = _pendingPayment(account, totalReceived, released(account));
734 
735         require(payment != 0, "PaymentSplitter: account is not due payment");
736 
737         _released[account] += payment;
738         _totalReleased += payment;
739 
740         Address.sendValue(account, payment);
741         emit PaymentReleased(account, payment);
742     }
743 
744 
745     /**
746      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
747      * already released amounts.
748      */
749     function _pendingPayment(
750         address account,
751         uint256 totalReceived,
752         uint256 alreadyReleased
753     ) private view returns (uint256) {
754         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
755     }
756 
757     /**
758      * @dev Add a new payee to the contract.
759      * @param account The address of the payee to add.
760      * @param shares_ The number of shares owned by the payee.
761      */
762     function _addPayee(address account, uint256 shares_) private {
763         require(account != address(0), "PaymentSplitter: account is the zero address");
764         require(shares_ > 0, "PaymentSplitter: shares are 0");
765         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
766 
767         _payees.push(account);
768         _shares[account] = shares_;
769         _totalShares = _totalShares + shares_;
770         emit PayeeAdded(account, shares_);
771     }
772 }
773 // File: IERC721Receiver.sol
774 
775 
776 
777 pragma solidity ^0.8.0;
778 
779 /**
780  * @title ERC721 token receiver interface
781  * @dev Interface for any contract that wants to support safeTransfers
782  * from ERC721 asset contracts.
783  */
784 interface IERC721Receiver {
785     /**
786      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
787      * by `operator` from `from`, this function is called.
788      *
789      * It must return its Solidity selector to confirm the token transfer.
790      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
791      *
792      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
793      */
794     function onERC721Received(
795         address operator,
796         address from,
797         uint256 tokenId,
798         bytes calldata data
799     ) external returns (bytes4);
800 }
801 // File: IERC165.sol
802 
803 
804 
805 pragma solidity ^0.8.0;
806 
807 /**
808  * @dev Interface of the ERC165 standard, as defined in the
809  * https://eips.ethereum.org/EIPS/eip-165[EIP].
810  *
811  * Implementers can declare support of contract interfaces, which can then be
812  * queried by others ({ERC165Checker}).
813  *
814  * For an implementation, see {ERC165}.
815  */
816 interface IERC165 {
817     /**
818      * @dev Returns true if this contract implements the interface defined by
819      * `interfaceId`. See the corresponding
820      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
821      * to learn more about how these ids are created.
822      *
823      * This function call must use less than 30 000 gas.
824      */
825     function supportsInterface(bytes4 interfaceId) external view returns (bool);
826 }
827 // File: ERC165.sol
828 
829 
830 
831 pragma solidity ^0.8.0;
832 
833 
834 /**
835  * @dev Implementation of the {IERC165} interface.
836  *
837  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
838  * for the additional interface id that will be supported. For example:
839  *
840  * ```solidity
841  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
842  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
843  * }
844  * ```
845  *
846  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
847  */
848 abstract contract ERC165 is IERC165 {
849     /**
850      * @dev See {IERC165-supportsInterface}.
851      */
852     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
853         return interfaceId == type(IERC165).interfaceId;
854     }
855 }
856 // File: IERC721.sol
857 
858 
859 
860 pragma solidity ^0.8.0;
861 
862 
863 /**
864  * @dev Required interface of an ERC721 compliant contract.
865  */
866 interface IERC721 is IERC165 {
867     /**
868      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
869      */
870     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
871 
872     /**
873      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
874      */
875     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
876 
877     /**
878      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
879      */
880     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
881 
882     /**
883      * @dev Returns the number of tokens in ``owner``'s account.
884      */
885     function balanceOf(address owner) external view returns (uint256 balance);
886 
887     /**
888      * @dev Returns the owner of the `tokenId` token.
889      *
890      * Requirements:
891      *
892      * - `tokenId` must exist.
893      */
894     function ownerOf(uint256 tokenId) external view returns (address owner);
895 
896     /**
897      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
898      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
899      *
900      * Requirements:
901      *
902      * - `from` cannot be the zero address.
903      * - `to` cannot be the zero address.
904      * - `tokenId` token must exist and be owned by `from`.
905      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
906      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
907      *
908      * Emits a {Transfer} event.
909      */
910     function safeTransferFrom(
911         address from,
912         address to,
913         uint256 tokenId
914     ) external;
915 
916     /**
917      * @dev Transfers `tokenId` token from `from` to `to`.
918      *
919      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
920      *
921      * Requirements:
922      *
923      * - `from` cannot be the zero address.
924      * - `to` cannot be the zero address.
925      * - `tokenId` token must be owned by `from`.
926      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
927      *
928      * Emits a {Transfer} event.
929      */
930     function transferFrom(
931         address from,
932         address to,
933         uint256 tokenId
934     ) external;
935 
936     /**
937      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
938      * The approval is cleared when the token is transferred.
939      *
940      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
941      *
942      * Requirements:
943      *
944      * - The caller must own the token or be an approved operator.
945      * - `tokenId` must exist.
946      *
947      * Emits an {Approval} event.
948      */
949     function approve(address to, uint256 tokenId) external;
950 
951     /**
952      * @dev Returns the account approved for `tokenId` token.
953      *
954      * Requirements:
955      *
956      * - `tokenId` must exist.
957      */
958     function getApproved(uint256 tokenId) external view returns (address operator);
959 
960     /**
961      * @dev Approve or remove `operator` as an operator for the caller.
962      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
963      *
964      * Requirements:
965      *
966      * - The `operator` cannot be the caller.
967      *
968      * Emits an {ApprovalForAll} event.
969      */
970     function setApprovalForAll(address operator, bool _approved) external;
971 
972     /**
973      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
974      *
975      * See {setApprovalForAll}
976      */
977     function isApprovedForAll(address owner, address operator) external view returns (bool);
978 
979     /**
980      * @dev Safely transfers `tokenId` token from `from` to `to`.
981      *
982      * Requirements:
983      *
984      * - `from` cannot be the zero address.
985      * - `to` cannot be the zero address.
986      * - `tokenId` token must exist and be owned by `from`.
987      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
988      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
989      *
990      * Emits a {Transfer} event.
991      */
992     function safeTransferFrom(
993         address from,
994         address to,
995         uint256 tokenId,
996         bytes calldata data
997     ) external;
998 }
999 // File: IERC721Enumerable.sol
1000 
1001 
1002 
1003 pragma solidity ^0.8.0;
1004 
1005 
1006 /**
1007  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1008  * @dev See https://eips.ethereum.org/EIPS/eip-721
1009  */
1010 interface IERC721Enumerable is IERC721 {
1011     /**
1012      * @dev Returns the total amount of tokens stored by the contract.
1013      */
1014     function totalSupply() external view returns (uint256);
1015 
1016     /**
1017      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1018      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1019      */
1020     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1021 
1022     /**
1023      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1024      * Use along with {totalSupply} to enumerate all tokens.
1025      */
1026     function tokenByIndex(uint256 index) external view returns (uint256);
1027 }
1028 // File: IERC721Metadata.sol
1029 
1030 
1031 
1032 pragma solidity ^0.8.0;
1033 
1034 
1035 /**
1036  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1037  * @dev See https://eips.ethereum.org/EIPS/eip-721
1038  */
1039 interface IERC721Metadata is IERC721 {
1040     /**
1041      * @dev Returns the token collection name.
1042      */
1043     function name() external view returns (string memory);
1044 
1045     /**
1046      * @dev Returns the token collection symbol.
1047      */
1048     function symbol() external view returns (string memory);
1049 
1050     /**
1051      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1052      */
1053     function tokenURI(uint256 tokenId) external view returns (string memory);
1054 }
1055 // File: ERC721A.sol
1056 
1057 
1058 pragma solidity ^0.8.0;
1059 
1060 
1061 
1062 
1063 
1064 
1065 
1066 
1067 
1068 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1069     using Address for address;
1070     using Strings for uint256;
1071 
1072     struct TokenOwnership {
1073         address addr;
1074         uint64 startTimestamp;
1075     }
1076 
1077     struct AddressData {
1078         uint128 balance;
1079         uint128 numberMinted;
1080     }
1081 
1082     uint256 internal currentIndex;
1083 
1084     // Token name
1085     string private _name;
1086 
1087     // Token symbol
1088     string private _symbol;
1089 
1090     // Mapping from token ID to ownership details
1091     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1092     mapping(uint256 => TokenOwnership) internal _ownerships;
1093 
1094     // Mapping owner address to address data
1095     mapping(address => AddressData) private _addressData;
1096 
1097     // Mapping from token ID to approved address
1098     mapping(uint256 => address) private _tokenApprovals;
1099 
1100     // Mapping from owner to operator approvals
1101     mapping(address => mapping(address => bool)) private _operatorApprovals;
1102 
1103     constructor(string memory name_, string memory symbol_) {
1104         _name = name_;
1105         _symbol = symbol_;
1106     }
1107 
1108     /**
1109      * @dev See {IERC721Enumerable-totalSupply}.
1110      */
1111     function totalSupply() public view override returns (uint256) {
1112         return currentIndex;
1113     }
1114 
1115     /**
1116      * @dev See {IERC721Enumerable-tokenByIndex}.
1117      */
1118     function tokenByIndex(uint256 index) public view override returns (uint256) {
1119         require(index < totalSupply(), 'ERC721A: global index out of bounds');
1120         return index;
1121     }
1122 
1123     /**
1124      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1125      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1126      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1127      */
1128     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1129         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
1130         uint256 numMintedSoFar = totalSupply();
1131         uint256 tokenIdsIdx;
1132         address currOwnershipAddr;
1133 
1134         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1135         unchecked {
1136             for (uint256 i; i < numMintedSoFar; i++) {
1137                 TokenOwnership memory ownership = _ownerships[i];
1138                 if (ownership.addr != address(0)) {
1139                     currOwnershipAddr = ownership.addr;
1140                 }
1141                 if (currOwnershipAddr == owner) {
1142                     if (tokenIdsIdx == index) {
1143                         return i;
1144                     }
1145                     tokenIdsIdx++;
1146                 }
1147             }
1148         }
1149 
1150         revert('ERC721A: unable to get token of owner by index');
1151     }
1152 
1153     /**
1154      * @dev See {IERC165-supportsInterface}.
1155      */
1156     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1157         return
1158             interfaceId == type(IERC721).interfaceId ||
1159             interfaceId == type(IERC721Metadata).interfaceId ||
1160             interfaceId == type(IERC721Enumerable).interfaceId ||
1161             super.supportsInterface(interfaceId);
1162     }
1163 
1164     /**
1165      * @dev See {IERC721-balanceOf}.
1166      */
1167     function balanceOf(address owner) public view override returns (uint256) {
1168         require(owner != address(0), 'ERC721A: balance query for the zero address');
1169         return uint256(_addressData[owner].balance);
1170     }
1171 
1172     function _numberMinted(address owner) internal view returns (uint256) {
1173         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1174         return uint256(_addressData[owner].numberMinted);
1175     }
1176 
1177     /**
1178      * Gas spent here starts off proportional to the maximum mint batch size.
1179      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1180      */
1181     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1182         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1183 
1184         unchecked {
1185             for (uint256 curr = tokenId; curr >= 0; curr--) {
1186                 TokenOwnership memory ownership = _ownerships[curr];
1187                 if (ownership.addr != address(0)) {
1188                     return ownership;
1189                 }
1190             }
1191         }
1192 
1193         revert('ERC721A: unable to determine the owner of token');
1194     }
1195 
1196     /**
1197      * @dev See {IERC721-ownerOf}.
1198      */
1199     function ownerOf(uint256 tokenId) public view override returns (address) {
1200         return ownershipOf(tokenId).addr;
1201     }
1202 
1203     /**
1204      * @dev See {IERC721Metadata-name}.
1205      */
1206     function name() public view virtual override returns (string memory) {
1207         return _name;
1208     }
1209 
1210     /**
1211      * @dev See {IERC721Metadata-symbol}.
1212      */
1213     function symbol() public view virtual override returns (string memory) {
1214         return _symbol;
1215     }
1216 
1217     /**
1218      * @dev See {IERC721Metadata-tokenURI}.
1219      */
1220     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1221         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1222 
1223         string memory baseURI = _baseURI();
1224         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1225     }
1226 
1227     /**
1228      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1229      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1230      * by default, can be overriden in child contracts.
1231      */
1232     function _baseURI() internal view virtual returns (string memory) {
1233         return '';
1234     }
1235 
1236     /**
1237      * @dev See {IERC721-approve}.
1238      */
1239     function approve(address to, uint256 tokenId) public override {
1240         address owner = ERC721A.ownerOf(tokenId);
1241         require(to != owner, 'ERC721A: approval to current owner');
1242 
1243         require(
1244             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1245             'ERC721A: approve caller is not owner nor approved for all'
1246         );
1247 
1248         _approve(to, tokenId, owner);
1249     }
1250 
1251     /**
1252      * @dev See {IERC721-getApproved}.
1253      */
1254     function getApproved(uint256 tokenId) public view override returns (address) {
1255         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1256 
1257         return _tokenApprovals[tokenId];
1258     }
1259 
1260     /**
1261      * @dev See {IERC721-setApprovalForAll}.
1262      */
1263     function setApprovalForAll(address operator, bool approved) public override {
1264         require(operator != _msgSender(), 'ERC721A: approve to caller');
1265 
1266         _operatorApprovals[_msgSender()][operator] = approved;
1267         emit ApprovalForAll(_msgSender(), operator, approved);
1268     }
1269 
1270     /**
1271      * @dev See {IERC721-isApprovedForAll}.
1272      */
1273     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1274         return _operatorApprovals[owner][operator];
1275     }
1276 
1277     /**
1278      * @dev See {IERC721-transferFrom}.
1279      */
1280     function transferFrom(
1281         address from,
1282         address to,
1283         uint256 tokenId
1284     ) public override {
1285         _transfer(from, to, tokenId);
1286     }
1287 
1288     /**
1289      * @dev See {IERC721-safeTransferFrom}.
1290      */
1291     function safeTransferFrom(
1292         address from,
1293         address to,
1294         uint256 tokenId
1295     ) public override {
1296         safeTransferFrom(from, to, tokenId, '');
1297     }
1298 
1299     /**
1300      * @dev See {IERC721-safeTransferFrom}.
1301      */
1302     function safeTransferFrom(
1303         address from,
1304         address to,
1305         uint256 tokenId,
1306         bytes memory _data
1307     ) public override {
1308         _transfer(from, to, tokenId);
1309         require(
1310             _checkOnERC721Received(from, to, tokenId, _data),
1311             'ERC721A: transfer to non ERC721Receiver implementer'
1312         );
1313     }
1314 
1315     /**
1316      * @dev Returns whether `tokenId` exists.
1317      *
1318      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1319      *
1320      * Tokens start existing when they are minted (`_mint`),
1321      */
1322     function _exists(uint256 tokenId) internal view returns (bool) {
1323         return tokenId < currentIndex;
1324     }
1325 
1326     function _safeMint(address to, uint256 quantity) internal {
1327         _safeMint(to, quantity, '');
1328     }
1329 
1330     /**
1331      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1332      *
1333      * Requirements:
1334      *
1335      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1336      * - `quantity` must be greater than 0.
1337      *
1338      * Emits a {Transfer} event.
1339      */
1340     function _safeMint(
1341         address to,
1342         uint256 quantity,
1343         bytes memory _data
1344     ) internal {
1345         _mint(to, quantity, _data, true);
1346     }
1347 
1348     /**
1349      * @dev Mints `quantity` tokens and transfers them to `to`.
1350      *
1351      * Requirements:
1352      *
1353      * - `to` cannot be the zero address.
1354      * - `quantity` must be greater than 0.
1355      *
1356      * Emits a {Transfer} event.
1357      */
1358     function _mint(
1359         address to,
1360         uint256 quantity,
1361         bytes memory _data,
1362         bool safe
1363     ) internal {
1364         uint256 startTokenId = currentIndex;
1365         require(to != address(0), 'ERC721A: mint to the zero address');
1366         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1367 
1368         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1369 
1370         // Overflows are incredibly unrealistic.
1371         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1372         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1373         unchecked {
1374             _addressData[to].balance += uint128(quantity);
1375             _addressData[to].numberMinted += uint128(quantity);
1376 
1377             _ownerships[startTokenId].addr = to;
1378             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1379 
1380             uint256 updatedIndex = startTokenId;
1381 
1382             for (uint256 i; i < quantity; i++) {
1383                 emit Transfer(address(0), to, updatedIndex);
1384                 if (safe) {
1385                     require(
1386                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1387                         'ERC721A: transfer to non ERC721Receiver implementer'
1388                     );
1389                 }
1390 
1391                 updatedIndex++;
1392             }
1393 
1394             currentIndex = updatedIndex;
1395         }
1396 
1397         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1398     }
1399 
1400     /**
1401      * @dev Transfers `tokenId` from `from` to `to`.
1402      *
1403      * Requirements:
1404      *
1405      * - `to` cannot be the zero address.
1406      * - `tokenId` token must be owned by `from`.
1407      *
1408      * Emits a {Transfer} event.
1409      */
1410     function _transfer(
1411         address from,
1412         address to,
1413         uint256 tokenId
1414     ) private {
1415         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1416 
1417         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1418             getApproved(tokenId) == _msgSender() ||
1419             isApprovedForAll(prevOwnership.addr, _msgSender()));
1420 
1421         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1422 
1423         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1424         require(to != address(0), 'ERC721A: transfer to the zero address');
1425 
1426         _beforeTokenTransfers(from, to, tokenId, 1);
1427 
1428         // Clear approvals from the previous owner
1429         _approve(address(0), tokenId, prevOwnership.addr);
1430 
1431         // Underflow of the sender's balance is impossible because we check for
1432         // ownership above and the recipient's balance can't realistically overflow.
1433         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1434         unchecked {
1435             _addressData[from].balance -= 1;
1436             _addressData[to].balance += 1;
1437 
1438             _ownerships[tokenId].addr = to;
1439             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1440 
1441             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1442             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1443             uint256 nextTokenId = tokenId + 1;
1444             if (_ownerships[nextTokenId].addr == address(0)) {
1445                 if (_exists(nextTokenId)) {
1446                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1447                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1448                 }
1449             }
1450         }
1451 
1452         emit Transfer(from, to, tokenId);
1453         _afterTokenTransfers(from, to, tokenId, 1);
1454     }
1455 
1456     /**
1457      * @dev Approve `to` to operate on `tokenId`
1458      *
1459      * Emits a {Approval} event.
1460      */
1461     function _approve(
1462         address to,
1463         uint256 tokenId,
1464         address owner
1465     ) private {
1466         _tokenApprovals[tokenId] = to;
1467         emit Approval(owner, to, tokenId);
1468     }
1469 
1470     /**
1471      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1472      * The call is not executed if the target address is not a contract.
1473      *
1474      * @param from address representing the previous owner of the given token ID
1475      * @param to target address that will receive the tokens
1476      * @param tokenId uint256 ID of the token to be transferred
1477      * @param _data bytes optional data to send along with the call
1478      * @return bool whether the call correctly returned the expected magic value
1479      */
1480     function _checkOnERC721Received(
1481         address from,
1482         address to,
1483         uint256 tokenId,
1484         bytes memory _data
1485     ) private returns (bool) {
1486         if (to.isContract()) {
1487             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1488                 return retval == IERC721Receiver(to).onERC721Received.selector;
1489             } catch (bytes memory reason) {
1490                 if (reason.length == 0) {
1491                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1492                 } else {
1493                     assembly {
1494                         revert(add(32, reason), mload(reason))
1495                     }
1496                 }
1497             }
1498         } else {
1499             return true;
1500         }
1501     }
1502 
1503     /**
1504      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1505      *
1506      * startTokenId - the first token id to be transferred
1507      * quantity - the amount to be transferred
1508      *
1509      * Calling conditions:
1510      *
1511      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1512      * transferred to `to`.
1513      * - When `from` is zero, `tokenId` will be minted for `to`.
1514      */
1515     function _beforeTokenTransfers(
1516         address from,
1517         address to,
1518         uint256 startTokenId,
1519         uint256 quantity
1520     ) internal virtual {}
1521 
1522     /**
1523      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1524      * minting.
1525      *
1526      * startTokenId - the first token id to be transferred
1527      * quantity - the amount to be transferred
1528      *
1529      * Calling conditions:
1530      *
1531      * - when `from` and `to` are both non-zero.
1532      * - `from` and `to` are never both zero.
1533      */
1534     function _afterTokenTransfers(
1535         address from,
1536         address to,
1537         uint256 startTokenId,
1538         uint256 quantity
1539     ) internal virtual {}
1540 }
1541 
1542 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1543 
1544 pragma solidity ^0.8.0;
1545 
1546 /**
1547  * @dev Contract module that helps prevent reentrant calls to a function.
1548  *
1549  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1550  * available, which can be applied to functions to make sure there are no nested
1551  * (reentrant) calls to them.
1552  *
1553  * Note that because there is a single `nonReentrant` guard, functions marked as
1554  * `nonReentrant` may not call one another. This can be worked around by making
1555  * those functions `private`, and then adding `external` `nonReentrant` entry
1556  * points to them.
1557  *
1558  * TIP: If you would like to learn more about reentrancy and alternative ways
1559  * to protect against it, check out our blog post
1560  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1561  */
1562 abstract contract ReentrancyGuard {
1563     // Booleans are more expensive than uint256 or any type that takes up a full
1564     // word because each write operation emits an extra SLOAD to first read the
1565     // slot's contents, replace the bits taken up by the boolean, and then write
1566     // back. This is the compiler's defense against contract upgrades and
1567     // pointer aliasing, and it cannot be disabled.
1568 
1569     // The values being non-zero value makes deployment a bit more expensive,
1570     // but in exchange the refund on every call to nonReentrant will be lower in
1571     // amount. Since refunds are capped to a percentage of the total
1572     // transaction's gas, it is best to keep them low in cases like this one, to
1573     // increase the likelihood of the full refund coming into effect.
1574     uint256 private constant _NOT_ENTERED = 1;
1575     uint256 private constant _ENTERED = 2;
1576 
1577     uint256 private _status;
1578 
1579     constructor() {
1580         _status = _NOT_ENTERED;
1581     }
1582 
1583     /**
1584      * @dev Prevents a contract from calling itself, directly or indirectly.
1585      * Calling a `nonReentrant` function from another `nonReentrant`
1586      * function is not supported. It is possible to prevent this from happening
1587      * by making the `nonReentrant` function external, and making it call a
1588      * `private` function that does the actual work.
1589      */
1590     modifier nonReentrant() {
1591         // On the first call to nonReentrant, _notEntered will be true
1592         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1593 
1594         // Any calls to nonReentrant after this point will fail
1595         _status = _ENTERED;
1596 
1597         _;
1598 
1599         // By storing the original value once again, a refund is triggered (see
1600         // https://eips.ethereum.org/EIPS/eip-2200)
1601         _status = _NOT_ENTERED;
1602     }
1603 }
1604 
1605 pragma solidity ^0.8.2;
1606 
1607 contract GnomeGardenNFT is ERC721A, Ownable, ReentrancyGuard {  
1608     using Strings for uint256;
1609     string public _partslink;
1610     bool public byebye = false;
1611     uint256 constant public gnomes = 9999;
1612     uint256 constant public gnomenormalbyebye = 1; 
1613     uint256 constant public gnomeWhitlistByebye = 2; 
1614 
1615     mapping(address => uint256) public howmanygnomes;
1616     address[] public whitlistaddresses;
1617     mapping(address => uint256) public whitlistaddressesMap;
1618 
1619    
1620 	constructor() ERC721A("Gnome Garden", "GNOME") {}
1621 
1622     function _baseURI() internal view virtual override returns (string memory) {
1623         return _partslink;
1624     }
1625 
1626  	function makinGnome() public nonReentrant {
1627   	    uint256 totalgnomes = totalSupply();
1628         require(!byebye,"Making is closed.");
1629         require(msg.sender == tx.origin,"Contract call not allowed.");
1630         uint256 gnomebyebye = calUserGnomeRemainMake(msg.sender);
1631         require(gnomebyebye>0," User maximum quantity exceeded.");
1632 
1633         require(totalgnomes + gnomebyebye <= gnomes,"Exceeding the maximum circulation");
1634  
1635         _safeMint(msg.sender, gnomebyebye);
1636         howmanygnomes[msg.sender] += gnomebyebye;
1637         if(totalgnomes + gnomebyebye >= gnomes){
1638             byebye = true;
1639         }
1640     }
1641 
1642  	function makeGnomeFly(address lords, uint256 _gnomes) public onlyOwner {
1643   	    uint256 totalgnomes = totalSupply();
1644 	    require(totalgnomes + _gnomes <= gnomes,"Exceeding the maximum circulation");
1645         _safeMint(lords, _gnomes);
1646         
1647         if(totalgnomes + _gnomes >= gnomes){
1648             byebye = true;
1649         }
1650     }
1651 
1652     function makeGnomeByebye(bool _bye) external onlyOwner {
1653         byebye = _bye;
1654     }
1655 
1656 
1657     function makeGnomeHaveparts(string memory parts) external onlyOwner {
1658         _partslink = parts;
1659     }
1660 
1661     function sumthInboutFunds() public payable onlyOwner {
1662 	(bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1663 		require(success);
1664 	}
1665 
1666 
1667     function calUserGnomeRemainMake(address user) public view returns(uint256){
1668         uint256 _byebye = gnomenormalbyebye;
1669          for (uint256 i = 0; i < whitlistaddresses.length; i++) {
1670              uint256 _count = IERC721(whitlistaddresses[i]).balanceOf(user);
1671              if(_count > 0){
1672                 _byebye = whitlistaddressesMap[whitlistaddresses[i]];
1673                 if(_byebye > 0){
1674                     break;
1675                 }else{
1676                     _byebye = gnomenormalbyebye;
1677                 }
1678                 
1679              }
1680          }
1681          uint256 _remain = _byebye - howmanygnomes[user];
1682          if(_remain < 0){
1683             _remain = 0;
1684          }
1685          uint256 totalgnomes = totalSupply();
1686          if(totalgnomes + _remain > gnomes){
1687              if(_remain > gnomenormalbyebye){
1688                 _remain = gnomenormalbyebye;
1689                 if(totalgnomes + _remain > gnomes){
1690                     _remain = 0;
1691                 }
1692              }else{
1693                 _remain = 0;
1694              }
1695 
1696          }
1697         return _remain;
1698     }
1699 
1700     function setWhitlistes(address[] calldata _whitlistaddresses) external onlyOwner{
1701         for (uint256 i = 0; i < _whitlistaddresses.length; i++) {
1702             if(whitlistaddressesMap[_whitlistaddresses[i]] == 0){
1703                 whitlistaddresses.push(_whitlistaddresses[i]);
1704                 whitlistaddressesMap[_whitlistaddresses[i]] = gnomeWhitlistByebye;
1705             }else{
1706                 whitlistaddressesMap[_whitlistaddresses[i]] = gnomeWhitlistByebye;
1707             }
1708         }
1709     }
1710 }