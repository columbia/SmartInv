1 // Sources flattened with hardhat v2.9.7 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Strings.sol@v4.6.0
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev String operations.
12  */
13 library Strings {
14     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
15 
16     /**
17      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
18      */
19     function toString(uint256 value) internal pure returns (string memory) {
20         // Inspired by OraclizeAPI's implementation - MIT licence
21         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
22 
23         if (value == 0) {
24             return "0";
25         }
26         uint256 temp = value;
27         uint256 digits;
28         while (temp != 0) {
29             digits++;
30             temp /= 10;
31         }
32         bytes memory buffer = new bytes(digits);
33         while (value != 0) {
34             digits -= 1;
35             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
36             value /= 10;
37         }
38         return string(buffer);
39     }
40 
41     /**
42      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
43      */
44     function toHexString(uint256 value) internal pure returns (string memory) {
45         if (value == 0) {
46             return "0x00";
47         }
48         uint256 temp = value;
49         uint256 length = 0;
50         while (temp != 0) {
51             length++;
52             temp >>= 8;
53         }
54         return toHexString(value, length);
55     }
56 
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
59      */
60     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
61         bytes memory buffer = new bytes(2 * length + 2);
62         buffer[0] = "0";
63         buffer[1] = "x";
64         for (uint256 i = 2 * length + 1; i > 1; --i) {
65             buffer[i] = _HEX_SYMBOLS[value & 0xf];
66             value >>= 4;
67         }
68         require(value == 0, "Strings: hex length insufficient");
69         return string(buffer);
70     }
71 }
72 
73 
74 // File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.6.0
75 
76 
77 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
78 
79 pragma solidity ^0.8.0;
80 
81 /**
82  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
83  *
84  * These functions can be used to verify that a message was signed by the holder
85  * of the private keys of a given address.
86  */
87 library ECDSA {
88     enum RecoverError {
89         NoError,
90         InvalidSignature,
91         InvalidSignatureLength,
92         InvalidSignatureS,
93         InvalidSignatureV
94     }
95 
96     function _throwError(RecoverError error) private pure {
97         if (error == RecoverError.NoError) {
98             return; // no error: do nothing
99         } else if (error == RecoverError.InvalidSignature) {
100             revert("ECDSA: invalid signature");
101         } else if (error == RecoverError.InvalidSignatureLength) {
102             revert("ECDSA: invalid signature length");
103         } else if (error == RecoverError.InvalidSignatureS) {
104             revert("ECDSA: invalid signature 's' value");
105         } else if (error == RecoverError.InvalidSignatureV) {
106             revert("ECDSA: invalid signature 'v' value");
107         }
108     }
109 
110     /**
111      * @dev Returns the address that signed a hashed message (`hash`) with
112      * `signature` or error string. This address can then be used for verification purposes.
113      *
114      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
115      * this function rejects them by requiring the `s` value to be in the lower
116      * half order, and the `v` value to be either 27 or 28.
117      *
118      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
119      * verification to be secure: it is possible to craft signatures that
120      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
121      * this is by receiving a hash of the original message (which may otherwise
122      * be too long), and then calling {toEthSignedMessageHash} on it.
123      *
124      * Documentation for signature generation:
125      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
126      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
127      *
128      * _Available since v4.3._
129      */
130     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
131         // Check the signature length
132         // - case 65: r,s,v signature (standard)
133         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
134         if (signature.length == 65) {
135             bytes32 r;
136             bytes32 s;
137             uint8 v;
138             // ecrecover takes the signature parameters, and the only way to get them
139             // currently is to use assembly.
140             assembly {
141                 r := mload(add(signature, 0x20))
142                 s := mload(add(signature, 0x40))
143                 v := byte(0, mload(add(signature, 0x60)))
144             }
145             return tryRecover(hash, v, r, s);
146         } else if (signature.length == 64) {
147             bytes32 r;
148             bytes32 vs;
149             // ecrecover takes the signature parameters, and the only way to get them
150             // currently is to use assembly.
151             assembly {
152                 r := mload(add(signature, 0x20))
153                 vs := mload(add(signature, 0x40))
154             }
155             return tryRecover(hash, r, vs);
156         } else {
157             return (address(0), RecoverError.InvalidSignatureLength);
158         }
159     }
160 
161     /**
162      * @dev Returns the address that signed a hashed message (`hash`) with
163      * `signature`. This address can then be used for verification purposes.
164      *
165      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
166      * this function rejects them by requiring the `s` value to be in the lower
167      * half order, and the `v` value to be either 27 or 28.
168      *
169      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
170      * verification to be secure: it is possible to craft signatures that
171      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
172      * this is by receiving a hash of the original message (which may otherwise
173      * be too long), and then calling {toEthSignedMessageHash} on it.
174      */
175     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
176         (address recovered, RecoverError error) = tryRecover(hash, signature);
177         _throwError(error);
178         return recovered;
179     }
180 
181     /**
182      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
183      *
184      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
185      *
186      * _Available since v4.3._
187      */
188     function tryRecover(
189         bytes32 hash,
190         bytes32 r,
191         bytes32 vs
192     ) internal pure returns (address, RecoverError) {
193         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
194         uint8 v = uint8((uint256(vs) >> 255) + 27);
195         return tryRecover(hash, v, r, s);
196     }
197 
198     /**
199      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
200      *
201      * _Available since v4.2._
202      */
203     function recover(
204         bytes32 hash,
205         bytes32 r,
206         bytes32 vs
207     ) internal pure returns (address) {
208         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
209         _throwError(error);
210         return recovered;
211     }
212 
213     /**
214      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
215      * `r` and `s` signature fields separately.
216      *
217      * _Available since v4.3._
218      */
219     function tryRecover(
220         bytes32 hash,
221         uint8 v,
222         bytes32 r,
223         bytes32 s
224     ) internal pure returns (address, RecoverError) {
225         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
226         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
227         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
228         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
229         //
230         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
231         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
232         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
233         // these malleable signatures as well.
234         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
235             return (address(0), RecoverError.InvalidSignatureS);
236         }
237         if (v != 27 && v != 28) {
238             return (address(0), RecoverError.InvalidSignatureV);
239         }
240 
241         // If the signature is valid (and not malleable), return the signer address
242         address signer = ecrecover(hash, v, r, s);
243         if (signer == address(0)) {
244             return (address(0), RecoverError.InvalidSignature);
245         }
246 
247         return (signer, RecoverError.NoError);
248     }
249 
250     /**
251      * @dev Overload of {ECDSA-recover} that receives the `v`,
252      * `r` and `s` signature fields separately.
253      */
254     function recover(
255         bytes32 hash,
256         uint8 v,
257         bytes32 r,
258         bytes32 s
259     ) internal pure returns (address) {
260         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
261         _throwError(error);
262         return recovered;
263     }
264 
265     /**
266      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
267      * produces hash corresponding to the one signed with the
268      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
269      * JSON-RPC method as part of EIP-191.
270      *
271      * See {recover}.
272      */
273     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
274         // 32 is the length in bytes of hash,
275         // enforced by the type signature above
276         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
277     }
278 
279     /**
280      * @dev Returns an Ethereum Signed Message, created from `s`. This
281      * produces hash corresponding to the one signed with the
282      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
283      * JSON-RPC method as part of EIP-191.
284      *
285      * See {recover}.
286      */
287     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
288         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
289     }
290 
291     /**
292      * @dev Returns an Ethereum Signed Typed Data, created from a
293      * `domainSeparator` and a `structHash`. This produces hash corresponding
294      * to the one signed with the
295      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
296      * JSON-RPC method as part of EIP-712.
297      *
298      * See {recover}.
299      */
300     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
301         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
302     }
303 }
304 
305 
306 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.6.0
307 
308 
309 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
310 
311 pragma solidity ^0.8.0;
312 
313 /**
314  * @dev Interface of the ERC20 standard as defined in the EIP.
315  */
316 interface IERC20 {
317     /**
318      * @dev Emitted when `value` tokens are moved from one account (`from`) to
319      * another (`to`).
320      *
321      * Note that `value` may be zero.
322      */
323     event Transfer(address indexed from, address indexed to, uint256 value);
324 
325     /**
326      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
327      * a call to {approve}. `value` is the new allowance.
328      */
329     event Approval(address indexed owner, address indexed spender, uint256 value);
330 
331     /**
332      * @dev Returns the amount of tokens in existence.
333      */
334     function totalSupply() external view returns (uint256);
335 
336     /**
337      * @dev Returns the amount of tokens owned by `account`.
338      */
339     function balanceOf(address account) external view returns (uint256);
340 
341     /**
342      * @dev Moves `amount` tokens from the caller's account to `to`.
343      *
344      * Returns a boolean value indicating whether the operation succeeded.
345      *
346      * Emits a {Transfer} event.
347      */
348     function transfer(address to, uint256 amount) external returns (bool);
349 
350     /**
351      * @dev Returns the remaining number of tokens that `spender` will be
352      * allowed to spend on behalf of `owner` through {transferFrom}. This is
353      * zero by default.
354      *
355      * This value changes when {approve} or {transferFrom} are called.
356      */
357     function allowance(address owner, address spender) external view returns (uint256);
358 
359     /**
360      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
361      *
362      * Returns a boolean value indicating whether the operation succeeded.
363      *
364      * IMPORTANT: Beware that changing an allowance with this method brings the risk
365      * that someone may use both the old and the new allowance by unfortunate
366      * transaction ordering. One possible solution to mitigate this race
367      * condition is to first reduce the spender's allowance to 0 and set the
368      * desired value afterwards:
369      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
370      *
371      * Emits an {Approval} event.
372      */
373     function approve(address spender, uint256 amount) external returns (bool);
374 
375     /**
376      * @dev Moves `amount` tokens from `from` to `to` using the
377      * allowance mechanism. `amount` is then deducted from the caller's
378      * allowance.
379      *
380      * Returns a boolean value indicating whether the operation succeeded.
381      *
382      * Emits a {Transfer} event.
383      */
384     function transferFrom(
385         address from,
386         address to,
387         uint256 amount
388     ) external returns (bool);
389 }
390 
391 
392 // File @openzeppelin/contracts/utils/Address.sol@v4.6.0
393 
394 
395 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
396 
397 pragma solidity ^0.8.1;
398 
399 /**
400  * @dev Collection of functions related to the address type
401  */
402 library Address {
403     /**
404      * @dev Returns true if `account` is a contract.
405      *
406      * [IMPORTANT]
407      * ====
408      * It is unsafe to assume that an address for which this function returns
409      * false is an externally-owned account (EOA) and not a contract.
410      *
411      * Among others, `isContract` will return false for the following
412      * types of addresses:
413      *
414      *  - an externally-owned account
415      *  - a contract in construction
416      *  - an address where a contract will be created
417      *  - an address where a contract lived, but was destroyed
418      * ====
419      *
420      * [IMPORTANT]
421      * ====
422      * You shouldn't rely on `isContract` to protect against flash loan attacks!
423      *
424      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
425      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
426      * constructor.
427      * ====
428      */
429     function isContract(address account) internal view returns (bool) {
430         // This method relies on extcodesize/address.code.length, which returns 0
431         // for contracts in construction, since the code is only stored at the end
432         // of the constructor execution.
433 
434         return account.code.length > 0;
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
531         return verifyCallResult(success, returndata, errorMessage);
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
558         return verifyCallResult(success, returndata, errorMessage);
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
585         return verifyCallResult(success, returndata, errorMessage);
586     }
587 
588     /**
589      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
590      * revert reason using the provided one.
591      *
592      * _Available since v4.3._
593      */
594     function verifyCallResult(
595         bool success,
596         bytes memory returndata,
597         string memory errorMessage
598     ) internal pure returns (bytes memory) {
599         if (success) {
600             return returndata;
601         } else {
602             // Look for revert reason and bubble it up if present
603             if (returndata.length > 0) {
604                 // The easiest way to bubble the revert reason is using memory via assembly
605 
606                 assembly {
607                     let returndata_size := mload(returndata)
608                     revert(add(32, returndata), returndata_size)
609                 }
610             } else {
611                 revert(errorMessage);
612             }
613         }
614     }
615 }
616 
617 
618 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.6.0
619 
620 
621 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
622 
623 pragma solidity ^0.8.0;
624 
625 
626 /**
627  * @title SafeERC20
628  * @dev Wrappers around ERC20 operations that throw on failure (when the token
629  * contract returns false). Tokens that return no value (and instead revert or
630  * throw on failure) are also supported, non-reverting calls are assumed to be
631  * successful.
632  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
633  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
634  */
635 library SafeERC20 {
636     using Address for address;
637 
638     function safeTransfer(
639         IERC20 token,
640         address to,
641         uint256 value
642     ) internal {
643         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
644     }
645 
646     function safeTransferFrom(
647         IERC20 token,
648         address from,
649         address to,
650         uint256 value
651     ) internal {
652         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
653     }
654 
655     /**
656      * @dev Deprecated. This function has issues similar to the ones found in
657      * {IERC20-approve}, and its usage is discouraged.
658      *
659      * Whenever possible, use {safeIncreaseAllowance} and
660      * {safeDecreaseAllowance} instead.
661      */
662     function safeApprove(
663         IERC20 token,
664         address spender,
665         uint256 value
666     ) internal {
667         // safeApprove should only be called when setting an initial allowance,
668         // or when resetting it to zero. To increase and decrease it, use
669         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
670         require(
671             (value == 0) || (token.allowance(address(this), spender) == 0),
672             "SafeERC20: approve from non-zero to non-zero allowance"
673         );
674         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
675     }
676 
677     function safeIncreaseAllowance(
678         IERC20 token,
679         address spender,
680         uint256 value
681     ) internal {
682         uint256 newAllowance = token.allowance(address(this), spender) + value;
683         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
684     }
685 
686     function safeDecreaseAllowance(
687         IERC20 token,
688         address spender,
689         uint256 value
690     ) internal {
691         unchecked {
692             uint256 oldAllowance = token.allowance(address(this), spender);
693             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
694             uint256 newAllowance = oldAllowance - value;
695             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
696         }
697     }
698 
699     /**
700      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
701      * on the return value: the return value is optional (but if data is returned, it must not be false).
702      * @param token The token targeted by the call.
703      * @param data The call data (encoded using abi.encode or one of its variants).
704      */
705     function _callOptionalReturn(IERC20 token, bytes memory data) private {
706         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
707         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
708         // the target address contains contract code and also asserts for success in the low-level call.
709 
710         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
711         if (returndata.length > 0) {
712             // Return data is optional
713             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
714         }
715     }
716 }
717 
718 
719 // File @openzeppelin/contracts/utils/Context.sol@v4.6.0
720 
721 
722 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
723 
724 pragma solidity ^0.8.0;
725 
726 /**
727  * @dev Provides information about the current execution context, including the
728  * sender of the transaction and its data. While these are generally available
729  * via msg.sender and msg.data, they should not be accessed in such a direct
730  * manner, since when dealing with meta-transactions the account sending and
731  * paying for execution may not be the actual sender (as far as an application
732  * is concerned).
733  *
734  * This contract is only required for intermediate, library-like contracts.
735  */
736 abstract contract Context {
737     function _msgSender() internal view virtual returns (address) {
738         return msg.sender;
739     }
740 
741     function _msgData() internal view virtual returns (bytes calldata) {
742         return msg.data;
743     }
744 }
745 
746 
747 // File @openzeppelin/contracts/finance/PaymentSplitter.sol@v4.6.0
748 
749 
750 // OpenZeppelin Contracts v4.4.1 (finance/PaymentSplitter.sol)
751 
752 pragma solidity ^0.8.0;
753 
754 
755 
756 /**
757  * @title PaymentSplitter
758  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
759  * that the Ether will be split in this way, since it is handled transparently by the contract.
760  *
761  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
762  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
763  * an amount proportional to the percentage of total shares they were assigned.
764  *
765  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
766  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
767  * function.
768  *
769  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
770  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
771  * to run tests before sending real value to this contract.
772  */
773 contract PaymentSplitter is Context {
774     event PayeeAdded(address account, uint256 shares);
775     event PaymentReleased(address to, uint256 amount);
776     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
777     event PaymentReceived(address from, uint256 amount);
778 
779     uint256 private _totalShares;
780     uint256 private _totalReleased;
781 
782     mapping(address => uint256) private _shares;
783     mapping(address => uint256) private _released;
784     address[] private _payees;
785 
786     mapping(IERC20 => uint256) private _erc20TotalReleased;
787     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
788 
789     /**
790      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
791      * the matching position in the `shares` array.
792      *
793      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
794      * duplicates in `payees`.
795      */
796     constructor(address[] memory payees, uint256[] memory shares_) payable {
797         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
798         require(payees.length > 0, "PaymentSplitter: no payees");
799 
800         for (uint256 i = 0; i < payees.length; i++) {
801             _addPayee(payees[i], shares_[i]);
802         }
803     }
804 
805     /**
806      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
807      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
808      * reliability of the events, and not the actual splitting of Ether.
809      *
810      * To learn more about this see the Solidity documentation for
811      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
812      * functions].
813      */
814     receive() external payable virtual {
815         emit PaymentReceived(_msgSender(), msg.value);
816     }
817 
818     /**
819      * @dev Getter for the total shares held by payees.
820      */
821     function totalShares() public view returns (uint256) {
822         return _totalShares;
823     }
824 
825     /**
826      * @dev Getter for the total amount of Ether already released.
827      */
828     function totalReleased() public view returns (uint256) {
829         return _totalReleased;
830     }
831 
832     /**
833      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
834      * contract.
835      */
836     function totalReleased(IERC20 token) public view returns (uint256) {
837         return _erc20TotalReleased[token];
838     }
839 
840     /**
841      * @dev Getter for the amount of shares held by an account.
842      */
843     function shares(address account) public view returns (uint256) {
844         return _shares[account];
845     }
846 
847     /**
848      * @dev Getter for the amount of Ether already released to a payee.
849      */
850     function released(address account) public view returns (uint256) {
851         return _released[account];
852     }
853 
854     /**
855      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
856      * IERC20 contract.
857      */
858     function released(IERC20 token, address account) public view returns (uint256) {
859         return _erc20Released[token][account];
860     }
861 
862     /**
863      * @dev Getter for the address of the payee number `index`.
864      */
865     function payee(uint256 index) public view returns (address) {
866         return _payees[index];
867     }
868 
869     /**
870      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
871      * total shares and their previous withdrawals.
872      */
873     function release(address payable account) public virtual {
874         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
875 
876         uint256 totalReceived = address(this).balance + totalReleased();
877         uint256 payment = _pendingPayment(account, totalReceived, released(account));
878 
879         require(payment != 0, "PaymentSplitter: account is not due payment");
880 
881         _released[account] += payment;
882         _totalReleased += payment;
883 
884         Address.sendValue(account, payment);
885         emit PaymentReleased(account, payment);
886     }
887 
888     /**
889      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
890      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
891      * contract.
892      */
893     function release(IERC20 token, address account) public virtual {
894         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
895 
896         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
897         uint256 payment = _pendingPayment(account, totalReceived, released(token, account));
898 
899         require(payment != 0, "PaymentSplitter: account is not due payment");
900 
901         _erc20Released[token][account] += payment;
902         _erc20TotalReleased[token] += payment;
903 
904         SafeERC20.safeTransfer(token, account, payment);
905         emit ERC20PaymentReleased(token, account, payment);
906     }
907 
908     /**
909      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
910      * already released amounts.
911      */
912     function _pendingPayment(
913         address account,
914         uint256 totalReceived,
915         uint256 alreadyReleased
916     ) private view returns (uint256) {
917         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
918     }
919 
920     /**
921      * @dev Add a new payee to the contract.
922      * @param account The address of the payee to add.
923      * @param shares_ The number of shares owned by the payee.
924      */
925     function _addPayee(address account, uint256 shares_) private {
926         require(account != address(0), "PaymentSplitter: account is the zero address");
927         require(shares_ > 0, "PaymentSplitter: shares are 0");
928         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
929 
930         _payees.push(account);
931         _shares[account] = shares_;
932         _totalShares = _totalShares + shares_;
933         emit PayeeAdded(account, shares_);
934     }
935 }
936 
937 
938 // File @openzeppelin/contracts/security/Pausable.sol@v4.6.0
939 
940 
941 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
942 
943 pragma solidity ^0.8.0;
944 
945 /**
946  * @dev Contract module which allows children to implement an emergency stop
947  * mechanism that can be triggered by an authorized account.
948  *
949  * This module is used through inheritance. It will make available the
950  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
951  * the functions of your contract. Note that they will not be pausable by
952  * simply including this module, only once the modifiers are put in place.
953  */
954 abstract contract Pausable is Context {
955     /**
956      * @dev Emitted when the pause is triggered by `account`.
957      */
958     event Paused(address account);
959 
960     /**
961      * @dev Emitted when the pause is lifted by `account`.
962      */
963     event Unpaused(address account);
964 
965     bool private _paused;
966 
967     /**
968      * @dev Initializes the contract in unpaused state.
969      */
970     constructor() {
971         _paused = false;
972     }
973 
974     /**
975      * @dev Returns true if the contract is paused, and false otherwise.
976      */
977     function paused() public view virtual returns (bool) {
978         return _paused;
979     }
980 
981     /**
982      * @dev Modifier to make a function callable only when the contract is not paused.
983      *
984      * Requirements:
985      *
986      * - The contract must not be paused.
987      */
988     modifier whenNotPaused() {
989         require(!paused(), "Pausable: paused");
990         _;
991     }
992 
993     /**
994      * @dev Modifier to make a function callable only when the contract is paused.
995      *
996      * Requirements:
997      *
998      * - The contract must be paused.
999      */
1000     modifier whenPaused() {
1001         require(paused(), "Pausable: not paused");
1002         _;
1003     }
1004 
1005     /**
1006      * @dev Triggers stopped state.
1007      *
1008      * Requirements:
1009      *
1010      * - The contract must not be paused.
1011      */
1012     function _pause() internal virtual whenNotPaused {
1013         _paused = true;
1014         emit Paused(_msgSender());
1015     }
1016 
1017     /**
1018      * @dev Returns to normal state.
1019      *
1020      * Requirements:
1021      *
1022      * - The contract must be paused.
1023      */
1024     function _unpause() internal virtual whenPaused {
1025         _paused = false;
1026         emit Unpaused(_msgSender());
1027     }
1028 }
1029 
1030 
1031 // File @openzeppelin/contracts/access/Ownable.sol@v4.6.0
1032 
1033 
1034 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1035 
1036 pragma solidity ^0.8.0;
1037 
1038 /**
1039  * @dev Contract module which provides a basic access control mechanism, where
1040  * there is an account (an owner) that can be granted exclusive access to
1041  * specific functions.
1042  *
1043  * By default, the owner account will be the one that deploys the contract. This
1044  * can later be changed with {transferOwnership}.
1045  *
1046  * This module is used through inheritance. It will make available the modifier
1047  * `onlyOwner`, which can be applied to your functions to restrict their use to
1048  * the owner.
1049  */
1050 abstract contract Ownable is Context {
1051     address private _owner;
1052 
1053     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1054 
1055     /**
1056      * @dev Initializes the contract setting the deployer as the initial owner.
1057      */
1058     constructor() {
1059         _transferOwnership(_msgSender());
1060     }
1061 
1062     /**
1063      * @dev Returns the address of the current owner.
1064      */
1065     function owner() public view virtual returns (address) {
1066         return _owner;
1067     }
1068 
1069     /**
1070      * @dev Throws if called by any account other than the owner.
1071      */
1072     modifier onlyOwner() {
1073         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1074         _;
1075     }
1076 
1077     /**
1078      * @dev Leaves the contract without owner. It will not be possible to call
1079      * `onlyOwner` functions anymore. Can only be called by the current owner.
1080      *
1081      * NOTE: Renouncing ownership will leave the contract without an owner,
1082      * thereby removing any functionality that is only available to the owner.
1083      */
1084     function renounceOwnership() public virtual onlyOwner {
1085         _transferOwnership(address(0));
1086     }
1087 
1088     /**
1089      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1090      * Can only be called by the current owner.
1091      */
1092     function transferOwnership(address newOwner) public virtual onlyOwner {
1093         require(newOwner != address(0), "Ownable: new owner is the zero address");
1094         _transferOwnership(newOwner);
1095     }
1096 
1097     /**
1098      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1099      * Internal function without access restriction.
1100      */
1101     function _transferOwnership(address newOwner) internal virtual {
1102         address oldOwner = _owner;
1103         _owner = newOwner;
1104         emit OwnershipTransferred(oldOwner, newOwner);
1105     }
1106 }
1107 
1108 
1109 // File contracts/IFaceX.sol
1110 
1111 //SPDX-License-Identifier: UNLICENSED
1112 pragma solidity 0.8.13;
1113 
1114 interface IFaceX {
1115 
1116     function mintTo(address _to, uint256 _quantity) external;
1117 
1118 }
1119 
1120 
1121 // File contracts/FaceXMint.sol
1122 
1123 pragma solidity 0.8.13;
1124 
1125 
1126 
1127 
1128 
1129 contract FaceXMint is Ownable, PaymentSplitter, Pausable {
1130     using Strings for uint256;
1131     using ECDSA for bytes32;
1132 
1133     IFaceX immutable FaceX;
1134 
1135     uint256 public price = 0.13 ether; //Early sale price. Will be updated to announced sale price 
1136     uint256 public presalePrice = 0.12 ether; //Early presale price. Will be updated to announced presale price 
1137 
1138     uint256 public maxSupply = 4000;
1139     uint256 public maxMintablePerTx = 5;
1140 
1141     address private whitelistAddress =
1142         0xE1f57C639f8629826c56527D02ded783A865142D;
1143 
1144     uint256 public immutable saleStart;
1145     uint256 public immutable presaleStart;
1146 
1147     uint256 public minted = 0;
1148 
1149     bool teamReserved = false;
1150 
1151     bool saleEnded = false;
1152 
1153     mapping(address => uint256) public tokensMinted;
1154 
1155     address[] private team_ = [
1156         0x05fE66a4F7577b060831F572eE63BBCb51b2D16A,
1157         0x0777E3A2C670AD627c5E13550E78D90Fee7835a1,
1158         0x725AAF2347aadc1bA5AcaF4266Cfe3496A308008,
1159         0xd08f866534E3Baf3ab13BD5F7008D21dAE604d81,
1160         0x672B21bBD0FBF9c9643762DD058804769D2CcAa4,
1161         0x389Aeb695B97e001d89BfB6b9f901e6C4B46bddA,
1162         0x680c6814dAfE0eb24dfbD37234369ad5124E3b0e
1163     ];
1164     uint256[] private teamShares_ = [3875,3875,950,475,475,100,250];
1165 
1166     constructor(IFaceX _FaceX, uint256 _saleStart, uint256 _presaleStart)
1167         PaymentSplitter(team_, teamShares_)
1168     {
1169         FaceX = _FaceX;
1170         saleStart = _saleStart;
1171         presaleStart = _presaleStart;
1172     }
1173 
1174 
1175     //Allows to update the sale price for early minters
1176     function setSalePrice(uint256 _newSalePrice) public onlyOwner {
1177 
1178         require(_newSalePrice > 0, "Price must not be 0");
1179 
1180         price = _newSalePrice;
1181 
1182     }
1183 
1184     //Allows to update the presale price for early minters
1185     function setPresalePrice(uint256 _newPresalePrice) public onlyOwner {
1186 
1187         require(_newPresalePrice > 0, "Price must not be 0");
1188 
1189         presalePrice = _newPresalePrice;
1190 
1191     }
1192 
1193     //Change address that needs to sign message
1194     function setWhitelistAddress(address _newAddress) public onlyOwner {
1195         require(_newAddress != address(0), "CAN'T PUT 0 ADDRESS");
1196         whitelistAddress = _newAddress;
1197     }
1198 
1199     //Set Max supply for this sale (different from FaceX MAX_SUPPLY)
1200     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1201         maxSupply = _maxSupply;
1202     }
1203 
1204 
1205     //Pause the contract in case of an emergency
1206     function pause() external onlyOwner {
1207         _pause();
1208     }
1209 
1210     //Unpause the contract
1211     function unpause() external onlyOwner {
1212         _unpause();
1213     }
1214 
1215     //End the sale forever
1216     function endSale() external onlyOwner {
1217         saleEnded = true;
1218     }
1219 
1220     /**
1221      * @dev Verifies that a message has been signed by a reference address
1222      * @param referenceAddress The reference address
1223      * @param messageHash The hashed message
1224      * @param signature The signature of that hashed message
1225      */
1226     function verifyAddressSigner(
1227         address referenceAddress,
1228         bytes32 messageHash,
1229         bytes memory signature
1230     ) internal pure returns (bool) {
1231         return
1232             referenceAddress ==
1233             messageHash.toEthSignedMessageHash().recover(signature); //Recovers the signature and returns true if the referenceAddress has signed messageHash producing signature
1234     }
1235 
1236     /**
1237      * @dev Hash a the message needed to mint
1238      * @param max The maximum of amount the address is allowed to mint
1239      * @param sender The actual sender of the transactio 
1240      */
1241     function hashMessage(uint256 max, address sender)
1242         private
1243         pure
1244         returns (bytes32)
1245     {
1246         return keccak256(abi.encode(max, sender));
1247     }
1248 
1249     /**
1250      * @dev Performs a presaleMint (or whitelisted mint). Access to the whitelist is verified with a signed message from `whitelistAddress`
1251      */
1252     function presaleMint(
1253         uint256 amount,
1254         uint256 max,
1255         bytes calldata signature
1256     ) external payable whenNotPaused {
1257         require(!saleEnded, "Sale is ended");
1258         require(
1259             presaleStart > 0 && block.timestamp >= presaleStart,
1260             "Whitelist mint is not started yet!"
1261         );
1262         require(
1263             tokensMinted[msg.sender] + amount <= max,
1264             "You can't mint more NFTs!"
1265         );
1266         require(amount > 0, "You must mint at least one token");
1267         require(
1268             verifyAddressSigner(
1269                 whitelistAddress,
1270                 hashMessage(max, msg.sender),
1271                 signature
1272             ),
1273             "SIGNATURE_VALIDATION_FAILED"
1274         );
1275         require(minted + amount <= maxSupply, "SOLD OUT!");
1276         require(
1277             msg.value >= presalePrice * amount,
1278             "Insuficient funds"
1279         );
1280 
1281         tokensMinted[msg.sender] += amount;
1282         minted += amount;
1283 
1284         FaceX.mintTo(msg.sender, amount);
1285     }
1286 
1287     /**
1288      * @dev Performs a public sale mint
1289      */
1290     function publicSaleMint(uint256 amount) external payable whenNotPaused {
1291         require(!saleEnded, "Sale is ended");
1292         require(
1293             saleStart > 0 && block.timestamp >= saleStart,
1294             "Public sale not started."
1295         );
1296         require(
1297             amount <= maxMintablePerTx,
1298             "Mint too large"
1299         );
1300         require(amount > 0, "You must mint at least one NFT.");
1301         require(minted + amount <= maxSupply, "Sold out!");
1302         require(
1303             msg.value >= price * amount,
1304             "Insuficient funds"
1305         );
1306 
1307         minted += amount;
1308 
1309         FaceX.mintTo(msg.sender, amount);
1310     }
1311 
1312 
1313 }