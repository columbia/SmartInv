1 //....................................................................................................................................
2 //....................................l...iii.........................................................................................
3 //.......................bbbb........lll..iii...................ddd...................................................................
4 //.......................bbbb........lll..iii...................ddd...................................................................
5 //.......................bbbb........lll..iii...................ddd...................................................................
6 //...gggggggg...ooooooo..bbbbbbbbb...lll..iii..nnnnnnnnn...dddddddd.uuuu...uuu..nnnnnnnnn...gggggggg...eeeeee....ooooooo...nnnnnnnnn..
7 //..ggggggggg..ooooooooo.bbbbbbbbbb..lll..iii..nnnnnnnnn..ddddddddd.uuuu...uuu..nnnnnnnnn..ggggggggg..eeeeeeee..ooooooooo..nnnnnnnnn..
8 //.gggggggggg.ooooooooooobbbbbbbbbbb.lll..iii..nnnnnnnnn.dddddddddd.uuuu...uuu..nnnnnnnnn.gggggggggg.eeeeeeeeeeooooooooooo.nnnnnnnnn..
9 //.gggg..gggg.oooo...oooobbbbb.bbbbb.lll..iii..nnnn.nnnn.dddd..dddd.uuuu...uuu..nnnn.nnnn.gggg..gggg.eeee..eeeeoooo...oooo.nnnn.nnnn..
10 //.gggg..gggg.oooo...oooobbbb...bbbb.lll..iii..nnn...nnn.dddd...ddd.uuuu...uuu..nnn...nnn.gggg..gggg.eeeeeeeeeeoooo...oooo.nnn...nnn..
11 //.gggg...ggg.oooo...oooobbbb...bbbb.lll..iii..nnn...nnn.dddd...ddd.uuuu...uuu..nnn...nnn.gggg...ggg.eeeeeeeeeeoooo...oooo.nnn...nnn..
12 //.gggg..gggg.oooo...oooobbbbb..bbbb.lll..iii..nnn...nnn.dddd..dddd..uuu..uuuu..nnn...nnn.gggg..gggg.eeee......oooo...oooo.nnn...nnn..
13 //.gggggggggg.ooooooooooobbbbbbbbbbb.lll..iii..nnn...nnn.dddddddddd..uuuuuuuuu..nnn...nnn.gggggggggg.eeeeeeeeeeooooooooooo.nnn...nnn..
14 //..ggggggggg..ooooooooo.bbbbbbbbbb..lll..iii..nnn...nnn..ddddddddd..uuuuuuuuu..nnn...nnn..ggggggggg.eeeeeeeee..ooooooooo..nnn...nnn..
15 //...gggggggg...ooooooo..bbbbbbbbbb..lll..iii..nnn...nnn..ddddddddd..uuuuuuuuu..nnn...nnn...gggggggg..eeeeeeee...ooooooo...nnn...nnn..
16 //.ggggg.gggg....ooooo........bbb...........................ddd........uuu................ggggg.gggg....eeee......ooooo...............
17 //.gggggggggg.............................................................................gggggggggg..................................
18 //..ggggggggg..............................................................................ggggggggg..................................
19 //..gggggggg...............................................................................gggggggg...................................
20 //....................................................................................................................................
21 
22 // SPDX-License-Identifier: MIT
23 
24 pragma solidity ^0.8.0;
25 
26 /**
27  * @dev String operations.
28  */
29 library Strings {
30     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
31 
32     /**
33      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
34      */
35     function toString(uint256 value) internal pure returns (string memory) {
36         // Inspired by OraclizeAPI's implementation - MIT licence
37         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
38 
39         if (value == 0) {
40             return "0";
41         }
42         uint256 temp = value;
43         uint256 digits;
44         while (temp != 0) {
45             digits++;
46             temp /= 10;
47         }
48         bytes memory buffer = new bytes(digits);
49         while (value != 0) {
50             digits -= 1;
51             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
52             value /= 10;
53         }
54         return string(buffer);
55     }
56 
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
59      */
60     function toHexString(uint256 value) internal pure returns (string memory) {
61         if (value == 0) {
62             return "0x00";
63         }
64         uint256 temp = value;
65         uint256 length = 0;
66         while (temp != 0) {
67             length++;
68             temp >>= 8;
69         }
70         return toHexString(value, length);
71     }
72 
73     /**
74      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
75      */
76     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
77         bytes memory buffer = new bytes(2 * length + 2);
78         buffer[0] = "0";
79         buffer[1] = "x";
80         for (uint256 i = 2 * length + 1; i > 1; --i) {
81             buffer[i] = _HEX_SYMBOLS[value & 0xf];
82             value >>= 4;
83         }
84         require(value == 0, "Strings: hex length insufficient");
85         return string(buffer);
86     }
87 }
88 // File: ECDSA.sol
89 
90 
91 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
92 
93 pragma solidity ^0.8.0;
94 
95 
96 /**
97  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
98  *
99  * These functions can be used to verify that a message was signed by the holder
100  * of the private keys of a given address.
101  */
102 library ECDSA {
103     enum RecoverError {
104         NoError,
105         InvalidSignature,
106         InvalidSignatureLength,
107         InvalidSignatureS,
108         InvalidSignatureV
109     }
110 
111     function _throwError(RecoverError error) private pure {
112         if (error == RecoverError.NoError) {
113             return; // no error: do nothing
114         } else if (error == RecoverError.InvalidSignature) {
115             revert("ECDSA: invalid signature");
116         } else if (error == RecoverError.InvalidSignatureLength) {
117             revert("ECDSA: invalid signature length");
118         } else if (error == RecoverError.InvalidSignatureS) {
119             revert("ECDSA: invalid signature 's' value");
120         } else if (error == RecoverError.InvalidSignatureV) {
121             revert("ECDSA: invalid signature 'v' value");
122         }
123     }
124 
125     /**
126      * @dev Returns the address that signed a hashed message (`hash`) with
127      * `signature` or error string. This address can then be used for verification purposes.
128      *
129      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
130      * this function rejects them by requiring the `s` value to be in the lower
131      * half order, and the `v` value to be either 27 or 28.
132      *
133      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
134      * verification to be secure: it is possible to craft signatures that
135      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
136      * this is by receiving a hash of the original message (which may otherwise
137      * be too long), and then calling {toEthSignedMessageHash} on it.
138      *
139      * Documentation for signature generation:
140      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
141      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
142      *
143      * _Available since v4.3._
144      */
145     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
146         // Check the signature length
147         // - case 65: r,s,v signature (standard)
148         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
149         if (signature.length == 65) {
150             bytes32 r;
151             bytes32 s;
152             uint8 v;
153             // ecrecover takes the signature parameters, and the only way to get them
154             // currently is to use assembly.
155             assembly {
156                 r := mload(add(signature, 0x20))
157                 s := mload(add(signature, 0x40))
158                 v := byte(0, mload(add(signature, 0x60)))
159             }
160             return tryRecover(hash, v, r, s);
161         } else if (signature.length == 64) {
162             bytes32 r;
163             bytes32 vs;
164             // ecrecover takes the signature parameters, and the only way to get them
165             // currently is to use assembly.
166             assembly {
167                 r := mload(add(signature, 0x20))
168                 vs := mload(add(signature, 0x40))
169             }
170             return tryRecover(hash, r, vs);
171         } else {
172             return (address(0), RecoverError.InvalidSignatureLength);
173         }
174     }
175 
176     /**
177      * @dev Returns the address that signed a hashed message (`hash`) with
178      * `signature`. This address can then be used for verification purposes.
179      *
180      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
181      * this function rejects them by requiring the `s` value to be in the lower
182      * half order, and the `v` value to be either 27 or 28.
183      *
184      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
185      * verification to be secure: it is possible to craft signatures that
186      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
187      * this is by receiving a hash of the original message (which may otherwise
188      * be too long), and then calling {toEthSignedMessageHash} on it.
189      */
190     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
191         (address recovered, RecoverError error) = tryRecover(hash, signature);
192         _throwError(error);
193         return recovered;
194     }
195 
196     /**
197      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
198      *
199      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
200      *
201      * _Available since v4.3._
202      */
203     function tryRecover(
204         bytes32 hash,
205         bytes32 r,
206         bytes32 vs
207     ) internal pure returns (address, RecoverError) {
208         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
209         uint8 v = uint8((uint256(vs) >> 255) + 27);
210         return tryRecover(hash, v, r, s);
211     }
212 
213     /**
214      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
215      *
216      * _Available since v4.2._
217      */
218     function recover(
219         bytes32 hash,
220         bytes32 r,
221         bytes32 vs
222     ) internal pure returns (address) {
223         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
224         _throwError(error);
225         return recovered;
226     }
227 
228     /**
229      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
230      * `r` and `s` signature fields separately.
231      *
232      * _Available since v4.3._
233      */
234     function tryRecover(
235         bytes32 hash,
236         uint8 v,
237         bytes32 r,
238         bytes32 s
239     ) internal pure returns (address, RecoverError) {
240         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
241         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
242         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
243         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
244         //
245         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
246         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
247         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
248         // these malleable signatures as well.
249         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
250             return (address(0), RecoverError.InvalidSignatureS);
251         }
252         if (v != 27 && v != 28) {
253             return (address(0), RecoverError.InvalidSignatureV);
254         }
255 
256         // If the signature is valid (and not malleable), return the signer address
257         address signer = ecrecover(hash, v, r, s);
258         if (signer == address(0)) {
259             return (address(0), RecoverError.InvalidSignature);
260         }
261 
262         return (signer, RecoverError.NoError);
263     }
264 
265     /**
266      * @dev Overload of {ECDSA-recover} that receives the `v`,
267      * `r` and `s` signature fields separately.
268      */
269     function recover(
270         bytes32 hash,
271         uint8 v,
272         bytes32 r,
273         bytes32 s
274     ) internal pure returns (address) {
275         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
276         _throwError(error);
277         return recovered;
278     }
279 
280     /**
281      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
282      * produces hash corresponding to the one signed with the
283      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
284      * JSON-RPC method as part of EIP-191.
285      *
286      * See {recover}.
287      */
288     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
289         // 32 is the length in bytes of hash,
290         // enforced by the type signature above
291         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
292     }
293 
294     /**
295      * @dev Returns an Ethereum Signed Message, created from `s`. This
296      * produces hash corresponding to the one signed with the
297      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
298      * JSON-RPC method as part of EIP-191.
299      *
300      * See {recover}.
301      */
302     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
303         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
304     }
305 
306     /**
307      * @dev Returns an Ethereum Signed Typed Data, created from a
308      * `domainSeparator` and a `structHash`. This produces hash corresponding
309      * to the one signed with the
310      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
311      * JSON-RPC method as part of EIP-712.
312      *
313      * See {recover}.
314      */
315     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
316         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
317     }
318 }
319 // File: Context.sol
320 
321 
322 
323 pragma solidity ^0.8.0;
324 
325 /**
326  * @dev Provides information about the current execution context, including the
327  * sender of the transaction and its data. While these are generally available
328  * via msg.sender and msg.data, they should not be accessed in such a direct
329  * manner, since when dealing with meta-transactions the account sending and
330  * paying for execution may not be the actual sender (as far as an application
331  * is concerned).
332  *
333  * This contract is only required for intermediate, library-like contracts.
334  */
335 abstract contract Context {
336     function _msgSender() internal view virtual returns (address) {
337         return msg.sender;
338     }
339 
340     function _msgData() internal view virtual returns (bytes calldata) {
341         return msg.data;
342     }
343 }
344 // File: Ownable.sol
345 
346 
347 
348 pragma solidity ^0.8.0;
349 
350 
351 /**
352  * @dev Contract module which provides a basic access control mechanism, where
353  * there is an account (an owner) that can be granted exclusive access to
354  * specific functions.
355  *
356  * By default, the owner account will be the one that deploys the contract. This
357  * can later be changed with {transferOwnership}.
358  *
359  * This module is used through inheritance. It will make available the modifier
360  * `onlyOwner`, which can be applied to your functions to restrict their use to
361  * the owner.
362  */
363 abstract contract Ownable is Context {
364     address private _owner;
365 
366     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
367 
368     /**
369      * @dev Initializes the contract setting the deployer as the initial owner.
370      */
371     constructor() {
372         _setOwner(_msgSender());
373     }
374 
375     /**
376      * @dev Returns the address of the current owner.
377      */
378     function owner() public view virtual returns (address) {
379         return _owner;
380     }
381 
382     /**
383      * @dev Throws if called by any account other than the owner.
384      */
385     modifier onlyOwner() {
386         require(owner() == _msgSender(), "Ownable: caller is not the owner");
387         _;
388     }
389 
390     /**
391      * @dev Leaves the contract without owner. It will not be possible to call
392      * `onlyOwner` functions anymore. Can only be called by the current owner.
393      *
394      * NOTE: Renouncing ownership will leave the contract without an owner,
395      * thereby removing any functionality that is only available to the owner.
396      */
397     function renounceOwnership() public virtual onlyOwner {
398         _setOwner(address(0));
399     }
400 
401     /**
402      * @dev Transfers ownership of the contract to a new account (`newOwner`).
403      * Can only be called by the current owner.
404      */
405     function transferOwnership(address newOwner) public virtual onlyOwner {
406         require(newOwner != address(0), "Ownable: new owner is the zero address");
407         _setOwner(newOwner);
408     }
409 
410     function _setOwner(address newOwner) private {
411         address oldOwner = _owner;
412         _owner = newOwner;
413         emit OwnershipTransferred(oldOwner, newOwner);
414     }
415 }
416 // File: Address.sol
417 
418 
419 
420 pragma solidity ^0.8.0;
421 
422 /**
423  * @dev Collection of functions related to the address type
424  */
425 library Address {
426     /**
427      * @dev Returns true if `account` is a contract.
428      *
429      * [IMPORTANT]
430      * ====
431      * It is unsafe to assume that an address for which this function returns
432      * false is an externally-owned account (EOA) and not a contract.
433      *
434      * Among others, `isContract` will return false for the following
435      * types of addresses:
436      *
437      *  - an externally-owned account
438      *  - a contract in construction
439      *  - an address where a contract will be created
440      *  - an address where a contract lived, but was destroyed
441      * ====
442      */
443     function isContract(address account) internal view returns (bool) {
444         // This method relies on extcodesize, which returns 0 for contracts in
445         // construction, since the code is only stored at the end of the
446         // constructor execution.
447 
448         uint256 size;
449         assembly {
450             size := extcodesize(account)
451         }
452         return size > 0;
453     }
454 
455     /**
456      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
457      * `recipient`, forwarding all available gas and reverting on errors.
458      *
459      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
460      * of certain opcodes, possibly making contracts go over the 2300 gas limit
461      * imposed by `transfer`, making them unable to receive funds via
462      * `transfer`. {sendValue} removes this limitation.
463      *
464      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
465      *
466      * IMPORTANT: because control is transferred to `recipient`, care must be
467      * taken to not create reentrancy vulnerabilities. Consider using
468      * {ReentrancyGuard} or the
469      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
470      */
471     function sendValue(address payable recipient, uint256 amount) internal {
472         require(address(this).balance >= amount, "Address: insufficient balance");
473 
474         (bool success, ) = recipient.call{value: amount}("");
475         require(success, "Address: unable to send value, recipient may have reverted");
476     }
477 
478     /**
479      * @dev Performs a Solidity function call using a low level `call`. A
480      * plain `call` is an unsafe replacement for a function call: use this
481      * function instead.
482      *
483      * If `target` reverts with a revert reason, it is bubbled up by this
484      * function (like regular Solidity function calls).
485      *
486      * Returns the raw returned data. To convert to the expected return value,
487      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
488      *
489      * Requirements:
490      *
491      * - `target` must be a contract.
492      * - calling `target` with `data` must not revert.
493      *
494      * _Available since v3.1._
495      */
496     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
497         return functionCall(target, data, "Address: low-level call failed");
498     }
499 
500     /**
501      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
502      * `errorMessage` as a fallback revert reason when `target` reverts.
503      *
504      * _Available since v3.1._
505      */
506     function functionCall(
507         address target,
508         bytes memory data,
509         string memory errorMessage
510     ) internal returns (bytes memory) {
511         return functionCallWithValue(target, data, 0, errorMessage);
512     }
513 
514     /**
515      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
516      * but also transferring `value` wei to `target`.
517      *
518      * Requirements:
519      *
520      * - the calling contract must have an ETH balance of at least `value`.
521      * - the called Solidity function must be `payable`.
522      *
523      * _Available since v3.1._
524      */
525     function functionCallWithValue(
526         address target,
527         bytes memory data,
528         uint256 value
529     ) internal returns (bytes memory) {
530         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
531     }
532 
533     /**
534      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
535      * with `errorMessage` as a fallback revert reason when `target` reverts.
536      *
537      * _Available since v3.1._
538      */
539     function functionCallWithValue(
540         address target,
541         bytes memory data,
542         uint256 value,
543         string memory errorMessage
544     ) internal returns (bytes memory) {
545         require(address(this).balance >= value, "Address: insufficient balance for call");
546         require(isContract(target), "Address: call to non-contract");
547 
548         (bool success, bytes memory returndata) = target.call{value: value}(data);
549         return _verifyCallResult(success, returndata, errorMessage);
550     }
551 
552     /**
553      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
554      * but performing a static call.
555      *
556      * _Available since v3.3._
557      */
558     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
559         return functionStaticCall(target, data, "Address: low-level static call failed");
560     }
561 
562     /**
563      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
564      * but performing a static call.
565      *
566      * _Available since v3.3._
567      */
568     function functionStaticCall(
569         address target,
570         bytes memory data,
571         string memory errorMessage
572     ) internal view returns (bytes memory) {
573         require(isContract(target), "Address: static call to non-contract");
574 
575         (bool success, bytes memory returndata) = target.staticcall(data);
576         return _verifyCallResult(success, returndata, errorMessage);
577     }
578 
579     /**
580      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
581      * but performing a delegate call.
582      *
583      * _Available since v3.4._
584      */
585     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
586         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
587     }
588 
589     /**
590      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
591      * but performing a delegate call.
592      *
593      * _Available since v3.4._
594      */
595     function functionDelegateCall(
596         address target,
597         bytes memory data,
598         string memory errorMessage
599     ) internal returns (bytes memory) {
600         require(isContract(target), "Address: delegate call to non-contract");
601 
602         (bool success, bytes memory returndata) = target.delegatecall(data);
603         return _verifyCallResult(success, returndata, errorMessage);
604     }
605 
606     function _verifyCallResult(
607         bool success,
608         bytes memory returndata,
609         string memory errorMessage
610     ) private pure returns (bytes memory) {
611         if (success) {
612             return returndata;
613         } else {
614             // Look for revert reason and bubble it up if present
615             if (returndata.length > 0) {
616                 // The easiest way to bubble the revert reason is using memory via assembly
617 
618                 assembly {
619                     let returndata_size := mload(returndata)
620                     revert(add(32, returndata), returndata_size)
621                 }
622             } else {
623                 revert(errorMessage);
624             }
625         }
626     }
627 }
628 // File: Payment.sol
629 
630 
631 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
632 
633 pragma solidity ^0.8.0;
634 
635 
636 
637 /**
638  * @title PaymentSplitter
639  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
640  * that the Ether will be split in this way, since it is handled transparently by the contract.
641  *
642  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
643  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
644  * an amount proportional to the percentage of total shares they were assigned.
645  *
646  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
647  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
648  * function.
649  *
650  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
651  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
652  * to run tests before sending real value to this contract.
653  */
654 contract Payment is Context {
655     event PayeeAdded(address account, uint256 shares);
656     event PaymentReleased(address to, uint256 amount);
657     event PaymentReceived(address from, uint256 amount);
658 
659     uint256 private _totalShares;
660     uint256 private _totalReleased;
661 
662     mapping(address => uint256) private _shares;
663     mapping(address => uint256) private _released;
664     address[] private _payees;
665 
666     /**
667      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
668      * the matching position in the `shares` array.
669      *
670      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
671      * duplicates in `payees`.
672      */
673     constructor(address[] memory payees, uint256[] memory shares_) payable {
674         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
675         require(payees.length > 0, "PaymentSplitter: no payees");
676 
677         for (uint256 i = 0; i < payees.length; i++) {
678             _addPayee(payees[i], shares_[i]);
679         }
680     }
681 
682     /**
683      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
684      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
685      * reliability of the events, and not the actual splitting of Ether.
686      *
687      * To learn more about this see the Solidity documentation for
688      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
689      * functions].
690      */
691     receive() external payable virtual {
692         emit PaymentReceived(_msgSender(), msg.value);
693     }
694 
695     /**
696      * @dev Getter for the total shares held by payees.
697      */
698     function totalShares() public view returns (uint256) {
699         return _totalShares;
700     }
701 
702     /**
703      * @dev Getter for the total amount of Ether already released.
704      */
705     function totalReleased() public view returns (uint256) {
706         return _totalReleased;
707     }
708 
709 
710     /**
711      * @dev Getter for the amount of shares held by an account.
712      */
713     function shares(address account) public view returns (uint256) {
714         return _shares[account];
715     }
716 
717     /**
718      * @dev Getter for the amount of Ether already released to a payee.
719      */
720     function released(address account) public view returns (uint256) {
721         return _released[account];
722     }
723 
724 
725     /**
726      * @dev Getter for the address of the payee number `index`.
727      */
728     function payee(uint256 index) public view returns (address) {
729         return _payees[index];
730     }
731 
732     /**
733      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
734      * total shares and their previous withdrawals.
735      */
736     function release(address payable account) public virtual {
737         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
738 
739         uint256 totalReceived = address(this).balance + totalReleased();
740         uint256 payment = _pendingPayment(account, totalReceived, released(account));
741 
742         require(payment != 0, "PaymentSplitter: account is not due payment");
743 
744         _released[account] += payment;
745         _totalReleased += payment;
746 
747         Address.sendValue(account, payment);
748         emit PaymentReleased(account, payment);
749     }
750 
751 
752     /**
753      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
754      * already released amounts.
755      */
756     function _pendingPayment(
757         address account,
758         uint256 totalReceived,
759         uint256 alreadyReleased
760     ) private view returns (uint256) {
761         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
762     }
763 
764     /**
765      * @dev Add a new payee to the contract.
766      * @param account The address of the payee to add.
767      * @param shares_ The number of shares owned by the payee.
768      */
769     function _addPayee(address account, uint256 shares_) private {
770         require(account != address(0), "PaymentSplitter: account is the zero address");
771         require(shares_ > 0, "PaymentSplitter: shares are 0");
772         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
773 
774         _payees.push(account);
775         _shares[account] = shares_;
776         _totalShares = _totalShares + shares_;
777         emit PayeeAdded(account, shares_);
778     }
779 }
780 // File: IERC721Receiver.sol
781 
782 
783 
784 pragma solidity ^0.8.0;
785 
786 /**
787  * @title ERC721 token receiver interface
788  * @dev Interface for any contract that wants to support safeTransfers
789  * from ERC721 asset contracts.
790  */
791 interface IERC721Receiver {
792     /**
793      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
794      * by `operator` from `from`, this function is called.
795      *
796      * It must return its Solidity selector to confirm the token transfer.
797      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
798      *
799      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
800      */
801     function onERC721Received(
802         address operator,
803         address from,
804         uint256 tokenId,
805         bytes calldata data
806     ) external returns (bytes4);
807 }
808 // File: IERC165.sol
809 
810 
811 
812 pragma solidity ^0.8.0;
813 
814 /**
815  * @dev Interface of the ERC165 standard, as defined in the
816  * https://eips.ethereum.org/EIPS/eip-165[EIP].
817  *
818  * Implementers can declare support of contract interfaces, which can then be
819  * queried by others ({ERC165Checker}).
820  *
821  * For an implementation, see {ERC165}.
822  */
823 interface IERC165 {
824     /**
825      * @dev Returns true if this contract implements the interface defined by
826      * `interfaceId`. See the corresponding
827      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
828      * to learn more about how these ids are created.
829      *
830      * This function call must use less than 30 000 gas.
831      */
832     function supportsInterface(bytes4 interfaceId) external view returns (bool);
833 }
834 // File: ERC165.sol
835 
836 
837 
838 pragma solidity ^0.8.0;
839 
840 
841 /**
842  * @dev Implementation of the {IERC165} interface.
843  *
844  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
845  * for the additional interface id that will be supported. For example:
846  *
847  * ```solidity
848  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
849  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
850  * }
851  * ```
852  *
853  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
854  */
855 abstract contract ERC165 is IERC165 {
856     /**
857      * @dev See {IERC165-supportsInterface}.
858      */
859     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
860         return interfaceId == type(IERC165).interfaceId;
861     }
862 }
863 // File: IERC721.sol
864 
865 
866 
867 pragma solidity ^0.8.0;
868 
869 
870 /**
871  * @dev Required interface of an ERC721 compliant contract.
872  */
873 interface IERC721 is IERC165 {
874     /**
875      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
876      */
877     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
878 
879     /**
880      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
881      */
882     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
883 
884     /**
885      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
886      */
887     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
888 
889     /**
890      * @dev Returns the number of tokens in ``owner``'s account.
891      */
892     function balanceOf(address owner) external view returns (uint256 balance);
893 
894     /**
895      * @dev Returns the owner of the `tokenId` token.
896      *
897      * Requirements:
898      *
899      * - `tokenId` must exist.
900      */
901     function ownerOf(uint256 tokenId) external view returns (address owner);
902 
903     /**
904      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
905      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
906      *
907      * Requirements:
908      *
909      * - `from` cannot be the zero address.
910      * - `to` cannot be the zero address.
911      * - `tokenId` token must exist and be owned by `from`.
912      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
913      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
914      *
915      * Emits a {Transfer} event.
916      */
917     function safeTransferFrom(
918         address from,
919         address to,
920         uint256 tokenId
921     ) external;
922 
923     /**
924      * @dev Transfers `tokenId` token from `from` to `to`.
925      *
926      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
927      *
928      * Requirements:
929      *
930      * - `from` cannot be the zero address.
931      * - `to` cannot be the zero address.
932      * - `tokenId` token must be owned by `from`.
933      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
934      *
935      * Emits a {Transfer} event.
936      */
937     function transferFrom(
938         address from,
939         address to,
940         uint256 tokenId
941     ) external;
942 
943     /**
944      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
945      * The approval is cleared when the token is transferred.
946      *
947      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
948      *
949      * Requirements:
950      *
951      * - The caller must own the token or be an approved operator.
952      * - `tokenId` must exist.
953      *
954      * Emits an {Approval} event.
955      */
956     function approve(address to, uint256 tokenId) external;
957 
958     /**
959      * @dev Returns the account approved for `tokenId` token.
960      *
961      * Requirements:
962      *
963      * - `tokenId` must exist.
964      */
965     function getApproved(uint256 tokenId) external view returns (address operator);
966 
967     /**
968      * @dev Approve or remove `operator` as an operator for the caller.
969      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
970      *
971      * Requirements:
972      *
973      * - The `operator` cannot be the caller.
974      *
975      * Emits an {ApprovalForAll} event.
976      */
977     function setApprovalForAll(address operator, bool _approved) external;
978 
979     /**
980      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
981      *
982      * See {setApprovalForAll}
983      */
984     function isApprovedForAll(address owner, address operator) external view returns (bool);
985 
986     /**
987      * @dev Safely transfers `tokenId` token from `from` to `to`.
988      *
989      * Requirements:
990      *
991      * - `from` cannot be the zero address.
992      * - `to` cannot be the zero address.
993      * - `tokenId` token must exist and be owned by `from`.
994      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
995      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
996      *
997      * Emits a {Transfer} event.
998      */
999     function safeTransferFrom(
1000         address from,
1001         address to,
1002         uint256 tokenId,
1003         bytes calldata data
1004     ) external;
1005 }
1006 // File: IERC721Enumerable.sol
1007 
1008 
1009 
1010 pragma solidity ^0.8.0;
1011 
1012 
1013 /**
1014  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1015  * @dev See https://eips.ethereum.org/EIPS/eip-721
1016  */
1017 interface IERC721Enumerable is IERC721 {
1018     /**
1019      * @dev Returns the total amount of tokens stored by the contract.
1020      */
1021     function totalSupply() external view returns (uint256);
1022 
1023     /**
1024      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1025      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1026      */
1027     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1028 
1029     /**
1030      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1031      * Use along with {totalSupply} to enumerate all tokens.
1032      */
1033     function tokenByIndex(uint256 index) external view returns (uint256);
1034 }
1035 // File: IERC721Metadata.sol
1036 
1037 
1038 
1039 pragma solidity ^0.8.0;
1040 
1041 
1042 /**
1043  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1044  * @dev See https://eips.ethereum.org/EIPS/eip-721
1045  */
1046 interface IERC721Metadata is IERC721 {
1047     /**
1048      * @dev Returns the token collection name.
1049      */
1050     function name() external view returns (string memory);
1051 
1052     /**
1053      * @dev Returns the token collection symbol.
1054      */
1055     function symbol() external view returns (string memory);
1056 
1057     /**
1058      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1059      */
1060     function tokenURI(uint256 tokenId) external view returns (string memory);
1061 }
1062 // File: ERC721A.sol
1063 
1064 
1065 pragma solidity ^0.8.0;
1066 
1067 
1068 
1069 
1070 
1071 
1072 
1073 
1074 
1075 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1076     using Address for address;
1077     using Strings for uint256;
1078 
1079     struct TokenOwnership {
1080         address addr;
1081         uint64 startTimestamp;
1082     }
1083 
1084     struct AddressData {
1085         uint128 balance;
1086         uint128 numberMinted;
1087     }
1088 
1089     uint256 internal currentIndex;
1090 
1091     // Token name
1092     string private _name;
1093 
1094     // Token symbol
1095     string private _symbol;
1096 
1097     // Mapping from token ID to ownership details
1098     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1099     mapping(uint256 => TokenOwnership) internal _ownerships;
1100 
1101     // Mapping owner address to address data
1102     mapping(address => AddressData) private _addressData;
1103 
1104     // Mapping from token ID to approved address
1105     mapping(uint256 => address) private _tokenApprovals;
1106 
1107     // Mapping from owner to operator approvals
1108     mapping(address => mapping(address => bool)) private _operatorApprovals;
1109 
1110     constructor(string memory name_, string memory symbol_) {
1111         _name = name_;
1112         _symbol = symbol_;
1113     }
1114 
1115     /**
1116      * @dev See {IERC721Enumerable-totalSupply}.
1117      */
1118     function totalSupply() public view override returns (uint256) {
1119         return currentIndex;
1120     }
1121 
1122     /**
1123      * @dev See {IERC721Enumerable-tokenByIndex}.
1124      */
1125     function tokenByIndex(uint256 index) public view override returns (uint256) {
1126         require(index < totalSupply(), 'ERC721A: global index out of bounds');
1127         return index;
1128     }
1129 
1130     /**
1131      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1132      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1133      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1134      */
1135     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1136         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
1137         uint256 numMintedSoFar = totalSupply();
1138         uint256 tokenIdsIdx;
1139         address currOwnershipAddr;
1140 
1141         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1142         unchecked {
1143             for (uint256 i; i < numMintedSoFar; i++) {
1144                 TokenOwnership memory ownership = _ownerships[i];
1145                 if (ownership.addr != address(0)) {
1146                     currOwnershipAddr = ownership.addr;
1147                 }
1148                 if (currOwnershipAddr == owner) {
1149                     if (tokenIdsIdx == index) {
1150                         return i;
1151                     }
1152                     tokenIdsIdx++;
1153                 }
1154             }
1155         }
1156 
1157         revert('ERC721A: unable to get token of owner by index');
1158     }
1159 
1160     /**
1161      * @dev See {IERC165-supportsInterface}.
1162      */
1163     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1164         return
1165             interfaceId == type(IERC721).interfaceId ||
1166             interfaceId == type(IERC721Metadata).interfaceId ||
1167             interfaceId == type(IERC721Enumerable).interfaceId ||
1168             super.supportsInterface(interfaceId);
1169     }
1170 
1171     /**
1172      * @dev See {IERC721-balanceOf}.
1173      */
1174     function balanceOf(address owner) public view override returns (uint256) {
1175         require(owner != address(0), 'ERC721A: balance query for the zero address');
1176         return uint256(_addressData[owner].balance);
1177     }
1178 
1179     function _numberMinted(address owner) internal view returns (uint256) {
1180         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1181         return uint256(_addressData[owner].numberMinted);
1182     }
1183 
1184     /**
1185      * Gas spent here starts off proportional to the maximum mint batch size.
1186      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1187      */
1188     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1189         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1190 
1191         unchecked {
1192             for (uint256 curr = tokenId; curr >= 0; curr--) {
1193                 TokenOwnership memory ownership = _ownerships[curr];
1194                 if (ownership.addr != address(0)) {
1195                     return ownership;
1196                 }
1197             }
1198         }
1199 
1200         revert('ERC721A: unable to determine the owner of token');
1201     }
1202 
1203     /**
1204      * @dev See {IERC721-ownerOf}.
1205      */
1206     function ownerOf(uint256 tokenId) public view override returns (address) {
1207         return ownershipOf(tokenId).addr;
1208     }
1209 
1210     /**
1211      * @dev See {IERC721Metadata-name}.
1212      */
1213     function name() public view virtual override returns (string memory) {
1214         return _name;
1215     }
1216 
1217     /**
1218      * @dev See {IERC721Metadata-symbol}.
1219      */
1220     function symbol() public view virtual override returns (string memory) {
1221         return _symbol;
1222     }
1223 
1224     /**
1225      * @dev See {IERC721Metadata-tokenURI}.
1226      */
1227     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1228         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1229 
1230         string memory baseURI = _baseURI();
1231         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1232     }
1233 
1234     /**
1235      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1236      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1237      * by default, can be overriden in child contracts.
1238      */
1239     function _baseURI() internal view virtual returns (string memory) {
1240         return '';
1241     }
1242 
1243     /**
1244      * @dev See {IERC721-approve}.
1245      */
1246     function approve(address to, uint256 tokenId) public override {
1247         address owner = ERC721A.ownerOf(tokenId);
1248         require(to != owner, 'ERC721A: approval to current owner');
1249 
1250         require(
1251             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1252             'ERC721A: approve caller is not owner nor approved for all'
1253         );
1254 
1255         _approve(to, tokenId, owner);
1256     }
1257 
1258     /**
1259      * @dev See {IERC721-getApproved}.
1260      */
1261     function getApproved(uint256 tokenId) public view override returns (address) {
1262         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1263 
1264         return _tokenApprovals[tokenId];
1265     }
1266 
1267     /**
1268      * @dev See {IERC721-setApprovalForAll}.
1269      */
1270     function setApprovalForAll(address operator, bool approved) public override {
1271         require(operator != _msgSender(), 'ERC721A: approve to caller');
1272 
1273         _operatorApprovals[_msgSender()][operator] = approved;
1274         emit ApprovalForAll(_msgSender(), operator, approved);
1275     }
1276 
1277     /**
1278      * @dev See {IERC721-isApprovedForAll}.
1279      */
1280     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1281         return _operatorApprovals[owner][operator];
1282     }
1283 
1284     /**
1285      * @dev See {IERC721-transferFrom}.
1286      */
1287     function transferFrom(
1288         address from,
1289         address to,
1290         uint256 tokenId
1291     ) public override {
1292         _transfer(from, to, tokenId);
1293     }
1294 
1295     /**
1296      * @dev See {IERC721-safeTransferFrom}.
1297      */
1298     function safeTransferFrom(
1299         address from,
1300         address to,
1301         uint256 tokenId
1302     ) public override {
1303         safeTransferFrom(from, to, tokenId, '');
1304     }
1305 
1306     /**
1307      * @dev See {IERC721-safeTransferFrom}.
1308      */
1309     function safeTransferFrom(
1310         address from,
1311         address to,
1312         uint256 tokenId,
1313         bytes memory _data
1314     ) public override {
1315         _transfer(from, to, tokenId);
1316         require(
1317             _checkOnERC721Received(from, to, tokenId, _data),
1318             'ERC721A: transfer to non ERC721Receiver implementer'
1319         );
1320     }
1321 
1322     /**
1323      * @dev Returns whether `tokenId` exists.
1324      *
1325      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1326      *
1327      * Tokens start existing when they are minted (`_mint`),
1328      */
1329     function _exists(uint256 tokenId) internal view returns (bool) {
1330         return tokenId < currentIndex;
1331     }
1332 
1333     function _safeMint(address to, uint256 quantity) internal {
1334         _safeMint(to, quantity, '');
1335     }
1336 
1337     /**
1338      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1339      *
1340      * Requirements:
1341      *
1342      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1343      * - `quantity` must be greater than 0.
1344      *
1345      * Emits a {Transfer} event.
1346      */
1347     function _safeMint(
1348         address to,
1349         uint256 quantity,
1350         bytes memory _data
1351     ) internal {
1352         _mint(to, quantity, _data, true);
1353     }
1354 
1355     /**
1356      * @dev Mints `quantity` tokens and transfers them to `to`.
1357      *
1358      * Requirements:
1359      *
1360      * - `to` cannot be the zero address.
1361      * - `quantity` must be greater than 0.
1362      *
1363      * Emits a {Transfer} event.
1364      */
1365     function _mint(
1366         address to,
1367         uint256 quantity,
1368         bytes memory _data,
1369         bool safe
1370     ) internal {
1371         uint256 startTokenId = currentIndex;
1372         require(to != address(0), 'ERC721A: mint to the zero address');
1373         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1374 
1375         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1376 
1377         // Overflows are incredibly unrealistic.
1378         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1379         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1380         unchecked {
1381             _addressData[to].balance += uint128(quantity);
1382             _addressData[to].numberMinted += uint128(quantity);
1383 
1384             _ownerships[startTokenId].addr = to;
1385             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1386 
1387             uint256 updatedIndex = startTokenId;
1388 
1389             for (uint256 i; i < quantity; i++) {
1390                 emit Transfer(address(0), to, updatedIndex);
1391                 if (safe) {
1392                     require(
1393                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1394                         'ERC721A: transfer to non ERC721Receiver implementer'
1395                     );
1396                 }
1397 
1398                 updatedIndex++;
1399             }
1400 
1401             currentIndex = updatedIndex;
1402         }
1403 
1404         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1405     }
1406 
1407     /**
1408      * @dev Transfers `tokenId` from `from` to `to`.
1409      *
1410      * Requirements:
1411      *
1412      * - `to` cannot be the zero address.
1413      * - `tokenId` token must be owned by `from`.
1414      *
1415      * Emits a {Transfer} event.
1416      */
1417     function _transfer(
1418         address from,
1419         address to,
1420         uint256 tokenId
1421     ) private {
1422         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1423 
1424         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1425             getApproved(tokenId) == _msgSender() ||
1426             isApprovedForAll(prevOwnership.addr, _msgSender()));
1427 
1428         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1429 
1430         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1431         require(to != address(0), 'ERC721A: transfer to the zero address');
1432 
1433         _beforeTokenTransfers(from, to, tokenId, 1);
1434 
1435         // Clear approvals from the previous owner
1436         _approve(address(0), tokenId, prevOwnership.addr);
1437 
1438         // Underflow of the sender's balance is impossible because we check for
1439         // ownership above and the recipient's balance can't realistically overflow.
1440         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1441         unchecked {
1442             _addressData[from].balance -= 1;
1443             _addressData[to].balance += 1;
1444 
1445             _ownerships[tokenId].addr = to;
1446             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1447 
1448             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1449             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1450             uint256 nextTokenId = tokenId + 1;
1451             if (_ownerships[nextTokenId].addr == address(0)) {
1452                 if (_exists(nextTokenId)) {
1453                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1454                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1455                 }
1456             }
1457         }
1458 
1459         emit Transfer(from, to, tokenId);
1460         _afterTokenTransfers(from, to, tokenId, 1);
1461     }
1462 
1463     /**
1464      * @dev Approve `to` to operate on `tokenId`
1465      *
1466      * Emits a {Approval} event.
1467      */
1468     function _approve(
1469         address to,
1470         uint256 tokenId,
1471         address owner
1472     ) private {
1473         _tokenApprovals[tokenId] = to;
1474         emit Approval(owner, to, tokenId);
1475     }
1476 
1477     /**
1478      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1479      * The call is not executed if the target address is not a contract.
1480      *
1481      * @param from address representing the previous owner of the given token ID
1482      * @param to target address that will receive the tokens
1483      * @param tokenId uint256 ID of the token to be transferred
1484      * @param _data bytes optional data to send along with the call
1485      * @return bool whether the call correctly returned the expected magic value
1486      */
1487     function _checkOnERC721Received(
1488         address from,
1489         address to,
1490         uint256 tokenId,
1491         bytes memory _data
1492     ) private returns (bool) {
1493         if (to.isContract()) {
1494             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1495                 return retval == IERC721Receiver(to).onERC721Received.selector;
1496             } catch (bytes memory reason) {
1497                 if (reason.length == 0) {
1498                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1499                 } else {
1500                     assembly {
1501                         revert(add(32, reason), mload(reason))
1502                     }
1503                 }
1504             }
1505         } else {
1506             return true;
1507         }
1508     }
1509 
1510     /**
1511      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1512      *
1513      * startTokenId - the first token id to be transferred
1514      * quantity - the amount to be transferred
1515      *
1516      * Calling conditions:
1517      *
1518      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1519      * transferred to `to`.
1520      * - When `from` is zero, `tokenId` will be minted for `to`.
1521      */
1522     function _beforeTokenTransfers(
1523         address from,
1524         address to,
1525         uint256 startTokenId,
1526         uint256 quantity
1527     ) internal virtual {}
1528 
1529     /**
1530      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1531      * minting.
1532      *
1533      * startTokenId - the first token id to be transferred
1534      * quantity - the amount to be transferred
1535      *
1536      * Calling conditions:
1537      *
1538      * - when `from` and `to` are both non-zero.
1539      * - `from` and `to` are never both zero.
1540      */
1541     function _afterTokenTransfers(
1542         address from,
1543         address to,
1544         uint256 startTokenId,
1545         uint256 quantity
1546     ) internal virtual {}
1547 }
1548 
1549 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
1550 
1551 pragma solidity ^0.8.0;
1552 
1553 /**
1554  * @dev Contract module that helps prevent reentrant calls to a function.
1555  *
1556  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1557  * available, which can be applied to functions to make sure there are no nested
1558  * (reentrant) calls to them.
1559  *
1560  * Note that because there is a single `nonReentrant` guard, functions marked as
1561  * `nonReentrant` may not call one another. This can be worked around by making
1562  * those functions `private`, and then adding `external` `nonReentrant` entry
1563  * points to them.
1564  *
1565  * TIP: If you would like to learn more about reentrancy and alternative ways
1566  * to protect against it, check out our blog post
1567  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1568  */
1569 abstract contract ReentrancyGuard {
1570     // Booleans are more expensive than uint256 or any type that takes up a full
1571     // word because each write operation emits an extra SLOAD to first read the
1572     // slot's contents, replace the bits taken up by the boolean, and then write
1573     // back. This is the compiler's defense against contract upgrades and
1574     // pointer aliasing, and it cannot be disabled.
1575 
1576     // The values being non-zero value makes deployment a bit more expensive,
1577     // but in exchange the refund on every call to nonReentrant will be lower in
1578     // amount. Since refunds are capped to a percentage of the total
1579     // transaction's gas, it is best to keep them low in cases like this one, to
1580     // increase the likelihood of the full refund coming into effect.
1581     uint256 private constant _NOT_ENTERED = 1;
1582     uint256 private constant _ENTERED = 2;
1583 
1584     uint256 private _status;
1585 
1586     constructor() {
1587         _status = _NOT_ENTERED;
1588     }
1589 
1590     /**
1591      * @dev Prevents a contract from calling itself, directly or indirectly.
1592      * Calling a `nonReentrant` function from another `nonReentrant`
1593      * function is not supported. It is possible to prevent this from happening
1594      * by making the `nonReentrant` function external, and making it call a
1595      * `private` function that does the actual work.
1596      */
1597     modifier nonReentrant() {
1598         // On the first call to nonReentrant, _notEntered will be true
1599         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1600 
1601         // Any calls to nonReentrant after this point will fail
1602         _status = _ENTERED;
1603 
1604         _;
1605 
1606         // By storing the original value once again, a refund is triggered (see
1607         // https://eips.ethereum.org/EIPS/eip-2200)
1608         _status = _NOT_ENTERED;
1609     }
1610 }
1611 
1612 pragma solidity ^0.8.2;
1613 
1614 contract goblindungeonNFT is ERC721A, Ownable, ReentrancyGuard {
1615     using Strings for uint256;
1616     string public _mutanttslink;
1617     bool public candrink = false;
1618     uint256 public maxmutantts = 9999;
1619     uint256 public serrrumportions = 2;
1620     mapping(address => uint256) public mutanttgobblins;
1621 
1622 	constructor() ERC721A("goblindungeon", "GOBLIND") {}
1623 
1624     function _baseURI() internal view virtual override returns (string memory) {
1625         return _mutanttslink;
1626     }
1627 
1628  	function mutategobblins() external nonReentrant {
1629   	    uint256 totalmutantts = totalSupply();
1630         require(candrink);
1631         require(totalmutantts + serrrumportions <= maxmutantts);
1632         require(msg.sender == tx.origin);
1633     	require(mutanttgobblins[msg.sender] < serrrumportions);
1634         _safeMint(msg.sender, serrrumportions);
1635         mutanttgobblins[msg.sender] += serrrumportions;
1636     }
1637 
1638  	function keepindungeon(address keeper, uint256 _mutantts) public onlyOwner {
1639   	    uint256 totalmutantts = totalSupply();
1640 	    require(totalmutantts + _mutantts <= maxmutantts);
1641         _safeMint(keeper, _mutantts);
1642     }
1643 
1644     function goblincandrink(bool _candrink) external onlyOwner {
1645         candrink = _candrink;
1646     }
1647 
1648     function serrrumsupply(uint256 _portions) external onlyOwner {
1649         serrrumportions = _portions;
1650     }
1651 
1652     function spauunmutantts(string memory mutanttslink) external onlyOwner {
1653         _mutanttslink = mutanttslink;
1654     }
1655 
1656     function datfunds() public payable onlyOwner {
1657 	    (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1658 		require(success);
1659 	}
1660 }