1 /**
2  *Submitted for verification at Etherscan.io on 2022-02-22
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2022-02-22
7 */
8 
9 // SPDX-License-Identifier: MIT
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev Interface of the ERC165 standard, as defined in the
14  * https://eips.ethereum.org/EIPS/eip-165[EIP].
15  *
16  * Implementers can declare support of contract interfaces, which can then be
17  * queried by others ({ERC165Checker}).
18  *
19  * For an implementation, see {ERC165}.
20  */
21 interface IERC165 {
22     /**
23      * @dev Returns true if this contract implements the interface defined by
24      * `interfaceId`. See the corresponding
25      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
26      * to learn more about how these ids are created.
27      *
28      * This function call must use less than 30 000 gas.
29      */
30     function supportsInterface(bytes4 interfaceId) external view returns (bool);
31 }
32 
33 /**
34  * @dev String operations.
35  */
36 library Strings {
37     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
41      */
42     function toString(uint256 value) internal pure returns (string memory) {
43         // Inspired by OraclizeAPI's implementation - MIT licence
44         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
45 
46         if (value == 0) {
47             return "0";
48         }
49         uint256 temp = value;
50         uint256 digits;
51         while (temp != 0) {
52             digits++;
53             temp /= 10;
54         }
55         bytes memory buffer = new bytes(digits);
56         while (value != 0) {
57             digits -= 1;
58             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
59             value /= 10;
60         }
61         return string(buffer);
62     }
63 
64     /**
65      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
66      */
67     function toHexString(uint256 value) internal pure returns (string memory) {
68         if (value == 0) {
69             return "0x00";
70         }
71         uint256 temp = value;
72         uint256 length = 0;
73         while (temp != 0) {
74             length++;
75             temp >>= 8;
76         }
77         return toHexString(value, length);
78     }
79 
80     /**
81      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
82      */
83     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
84         bytes memory buffer = new bytes(2 * length + 2);
85         buffer[0] = "0";
86         buffer[1] = "x";
87         for (uint256 i = 2 * length + 1; i > 1; --i) {
88             buffer[i] = _HEX_SYMBOLS[value & 0xf];
89             value >>= 4;
90         }
91         require(value == 0, "Strings: hex length insufficient");
92         return string(buffer);
93     }
94 }
95 
96 /**
97  * @title ERC721 token receiver interface
98  * @dev Interface for any contract that wants to support safeTransfers
99  * from ERC721 asset contracts.
100  */
101 interface IERC721Receiver {
102     /**
103      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
104      * by `operator` from `from`, this function is called.
105      *
106      * It must return its Solidity selector to confirm the token transfer.
107      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
108      *
109      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
110      */
111     function onERC721Received(
112         address operator,
113         address from,
114         uint256 tokenId,
115         bytes calldata data
116     ) external returns (bytes4);
117 }
118 
119 /**
120  * @dev Required interface of an ERC721 compliant contract.
121  */
122 interface IERC721 is IERC165 {
123     /**
124      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
125      */
126     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
127 
128     /**
129      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
130      */
131     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
132 
133     /**
134      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
135      */
136     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
137 
138     /**
139      * @dev Returns the number of tokens in ``owner``'s account.
140      */
141     function balanceOf(address owner) external view returns (uint256 balance);
142 
143     /**
144      * @dev Returns the owner of the `tokenId` token.
145      *
146      * Requirements:
147      *
148      * - `tokenId` must exist.
149      */
150     function ownerOf(uint256 tokenId) external view returns (address owner);
151 
152     /**
153      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
154      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
155      *
156      * Requirements:
157      *
158      * - `from` cannot be the zero address.
159      * - `to` cannot be the zero address.
160      * - `tokenId` token must exist and be owned by `from`.
161      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
162      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
163      *
164      * Emits a {Transfer} event.
165      */
166     function safeTransferFrom(
167         address from,
168         address to,
169         uint256 tokenId
170     ) external;
171 
172     /**
173      * @dev Transfers `tokenId` token from `from` to `to`.
174      *
175      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
176      *
177      * Requirements:
178      *
179      * - `from` cannot be the zero address.
180      * - `to` cannot be the zero address.
181      * - `tokenId` token must be owned by `from`.
182      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
183      *
184      * Emits a {Transfer} event.
185      */
186     function transferFrom(
187         address from,
188         address to,
189         uint256 tokenId
190     ) external;
191 
192     /**
193      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
194      * The approval is cleared when the token is transferred.
195      *
196      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
197      *
198      * Requirements:
199      *
200      * - The caller must own the token or be an approved operator.
201      * - `tokenId` must exist.
202      *
203      * Emits an {Approval} event.
204      */
205     function approve(address to, uint256 tokenId) external;
206 
207     /**
208      * @dev Returns the account approved for `tokenId` token.
209      *
210      * Requirements:
211      *
212      * - `tokenId` must exist.
213      */
214     function getApproved(uint256 tokenId) external view returns (address operator);
215 
216     /**
217      * @dev Approve or remove `operator` as an operator for the caller.
218      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
219      *
220      * Requirements:
221      *
222      * - The `operator` cannot be the caller.
223      *
224      * Emits an {ApprovalForAll} event.
225      */
226     function setApprovalForAll(address operator, bool _approved) external;
227 
228     /**
229      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
230      *
231      * See {setApprovalForAll}
232      */
233     function isApprovedForAll(address owner, address operator) external view returns (bool);
234 
235     /**
236      * @dev Safely transfers `tokenId` token from `from` to `to`.
237      *
238      * Requirements:
239      *
240      * - `from` cannot be the zero address.
241      * - `to` cannot be the zero address.
242      * - `tokenId` token must exist and be owned by `from`.
243      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
244      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
245      *
246      * Emits a {Transfer} event.
247      */
248     function safeTransferFrom(
249         address from,
250         address to,
251         uint256 tokenId,
252         bytes calldata data
253     ) external;
254 }
255 
256 /**
257  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
258  * @dev See https://eips.ethereum.org/EIPS/eip-721
259  */
260 interface IERC721Metadata is IERC721 {
261     /**
262      * @dev Returns the token collection name.
263      */
264     function name() external view returns (string memory);
265 
266     /**
267      * @dev Returns the token collection symbol.
268      */
269     function symbol() external view returns (string memory);
270 
271     /**
272      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
273      */
274     function tokenURI(uint256 tokenId) external view returns (string memory);
275 }
276 
277 /**
278  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
279  * @dev See https://eips.ethereum.org/EIPS/eip-721
280  */
281 interface IERC721Enumerable is IERC721 {
282     /**
283      * @dev Returns the total amount of tokens stored by the contract.
284      */
285     function totalSupply() external view returns (uint256);
286 
287     /**
288      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
289      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
290      */
291     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
292 
293     /**
294      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
295      * Use along with {totalSupply} to enumerate all tokens.
296      */
297     function tokenByIndex(uint256 index) external view returns (uint256);
298 }
299 
300 library Address {
301     function isContract(address account) internal view returns (bool) {
302         uint size;
303         assembly {
304             size := extcodesize(account)
305         }
306         return size > 0;
307     }
308 }
309 
310 /**
311  * @dev Implementation of the {IERC165} interface.
312  *
313  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
314  * for the additional interface id that will be supported. For example:
315  *
316  * ```solidity
317  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
318  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
319  * }
320  * ```
321  *
322  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
323  */
324 abstract contract ERC165 is IERC165 {
325     /**
326      * @dev See {IERC165-supportsInterface}.
327      */
328     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
329         return interfaceId == type(IERC165).interfaceId;
330     }
331 }
332 
333 // CAUTION
334 // This version of SafeMath should only be used with Solidity 0.8 or later,
335 // because it relies on the compiler's built in overflow checks.
336 
337 /**
338  * @dev Wrappers over Solidity's arithmetic operations.
339  *
340  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
341  * now has built in overflow checking.
342  */
343 library SafeMath {
344     /**
345      * @dev Returns the addition of two unsigned integers, with an overflow flag.
346      *
347      * _Available since v3.4._
348      */
349     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
350         unchecked {
351             uint256 c = a + b;
352             if (c < a) return (false, 0);
353             return (true, c);
354         }
355     }
356 
357     /**
358      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
359      *
360      * _Available since v3.4._
361      */
362     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
363         unchecked {
364             if (b > a) return (false, 0);
365             return (true, a - b);
366         }
367     }
368 
369     /**
370      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
371      *
372      * _Available since v3.4._
373      */
374     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
375         unchecked {
376             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
377             // benefit is lost if 'b' is also tested.
378             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
379             if (a == 0) return (true, 0);
380             uint256 c = a * b;
381             if (c / a != b) return (false, 0);
382             return (true, c);
383         }
384     }
385 
386     /**
387      * @dev Returns the division of two unsigned integers, with a division by zero flag.
388      *
389      * _Available since v3.4._
390      */
391     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
392         unchecked {
393             if (b == 0) return (false, 0);
394             return (true, a / b);
395         }
396     }
397 
398     /**
399      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
400      *
401      * _Available since v3.4._
402      */
403     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
404         unchecked {
405             if (b == 0) return (false, 0);
406             return (true, a % b);
407         }
408     }
409 
410     /**
411      * @dev Returns the addition of two unsigned integers, reverting on
412      * overflow.
413      *
414      * Counterpart to Solidity's `+` operator.
415      *
416      * Requirements:
417      *
418      * - Addition cannot overflow.
419      */
420     function add(uint256 a, uint256 b) internal pure returns (uint256) {
421         return a + b;
422     }
423 
424     /**
425      * @dev Returns the subtraction of two unsigned integers, reverting on
426      * overflow (when the result is negative).
427      *
428      * Counterpart to Solidity's `-` operator.
429      *
430      * Requirements:
431      *
432      * - Subtraction cannot overflow.
433      */
434     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
435         return a - b;
436     }
437 
438     /**
439      * @dev Returns the multiplication of two unsigned integers, reverting on
440      * overflow.
441      *
442      * Counterpart to Solidity's `*` operator.
443      *
444      * Requirements:
445      *
446      * - Multiplication cannot overflow.
447      */
448     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
449         return a * b;
450     }
451 
452     /**
453      * @dev Returns the integer division of two unsigned integers, reverting on
454      * division by zero. The result is rounded towards zero.
455      *
456      * Counterpart to Solidity's `/` operator.
457      *
458      * Requirements:
459      *
460      * - The divisor cannot be zero.
461      */
462     function div(uint256 a, uint256 b) internal pure returns (uint256) {
463         return a / b;
464     }
465 
466     /**
467      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
468      * reverting when dividing by zero.
469      *
470      * Counterpart to Solidity's `%` operator. This function uses a `revert`
471      * opcode (which leaves remaining gas untouched) while Solidity uses an
472      * invalid opcode to revert (consuming all remaining gas).
473      *
474      * Requirements:
475      *
476      * - The divisor cannot be zero.
477      */
478     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
479         return a % b;
480     }
481 
482     /**
483      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
484      * overflow (when the result is negative).
485      *
486      * CAUTION: This function is deprecated because it requires allocating memory for the error
487      * message unnecessarily. For custom revert reasons use {trySub}.
488      *
489      * Counterpart to Solidity's `-` operator.
490      *
491      * Requirements:
492      *
493      * - Subtraction cannot overflow.
494      */
495     function sub(
496         uint256 a,
497         uint256 b,
498         string memory errorMessage
499     ) internal pure returns (uint256) {
500         unchecked {
501             require(b <= a, errorMessage);
502             return a - b;
503         }
504     }
505 
506     /**
507      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
508      * division by zero. The result is rounded towards zero.
509      *
510      * Counterpart to Solidity's `/` operator. Note: this function uses a
511      * `revert` opcode (which leaves remaining gas untouched) while Solidity
512      * uses an invalid opcode to revert (consuming all remaining gas).
513      *
514      * Requirements:
515      *
516      * - The divisor cannot be zero.
517      */
518     function div(
519         uint256 a,
520         uint256 b,
521         string memory errorMessage
522     ) internal pure returns (uint256) {
523         unchecked {
524             require(b > 0, errorMessage);
525             return a / b;
526         }
527     }
528 
529     /**
530      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
531      * reverting with custom message when dividing by zero.
532      *
533      * CAUTION: This function is deprecated because it requires allocating memory for the error
534      * message unnecessarily. For custom revert reasons use {tryMod}.
535      *
536      * Counterpart to Solidity's `%` operator. This function uses a `revert`
537      * opcode (which leaves remaining gas untouched) while Solidity uses an
538      * invalid opcode to revert (consuming all remaining gas).
539      *
540      * Requirements:
541      *
542      * - The divisor cannot be zero.
543      */
544     function mod(
545         uint256 a,
546         uint256 b,
547         string memory errorMessage
548     ) internal pure returns (uint256) {
549         unchecked {
550             require(b > 0, errorMessage);
551             return a % b;
552         }
553     }
554 }
555 
556 /**
557  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
558  *
559  * These functions can be used to verify that a message was signed by the holder
560  * of the private keys of a given address.
561  */
562 library ECDSA {
563     enum RecoverError {
564         NoError,
565         InvalidSignature,
566         InvalidSignatureLength,
567         InvalidSignatureS,
568         InvalidSignatureV
569     }
570 
571     function _throwError(RecoverError error) private pure {
572         if (error == RecoverError.NoError) {
573             return; // no error: do nothing
574         } else if (error == RecoverError.InvalidSignature) {
575             revert("ECDSA: invalid signature");
576         } else if (error == RecoverError.InvalidSignatureLength) {
577             revert("ECDSA: invalid signature length");
578         } else if (error == RecoverError.InvalidSignatureS) {
579             revert("ECDSA: invalid signature 's' value");
580         } else if (error == RecoverError.InvalidSignatureV) {
581             revert("ECDSA: invalid signature 'v' value");
582         }
583     }
584 
585     /**
586      * @dev Returns the address that signed a hashed message (`hash`) with
587      * `signature` or error string. This address can then be used for verification purposes.
588      *
589      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
590      * this function rejects them by requiring the `s` value to be in the lower
591      * half order, and the `v` value to be either 27 or 28.
592      *
593      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
594      * verification to be secure: it is possible to craft signatures that
595      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
596      * this is by receiving a hash of the original message (which may otherwise
597      * be too long), and then calling {toEthSignedMessageHash} on it.
598      *
599      * Documentation for signature generation:
600      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
601      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
602      *
603      * _Available since v4.3._
604      */
605     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
606         // Check the signature length
607         // - case 65: r,s,v signature (standard)
608         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
609         if (signature.length == 65) {
610             bytes32 r;
611             bytes32 s;
612             uint8 v;
613             // ecrecover takes the signature parameters, and the only way to get them
614             // currently is to use assembly.
615             assembly {
616                 r := mload(add(signature, 0x20))
617                 s := mload(add(signature, 0x40))
618                 v := byte(0, mload(add(signature, 0x60)))
619             }
620             return tryRecover(hash, v, r, s);
621         } else if (signature.length == 64) {
622             bytes32 r;
623             bytes32 vs;
624             // ecrecover takes the signature parameters, and the only way to get them
625             // currently is to use assembly.
626             assembly {
627                 r := mload(add(signature, 0x20))
628                 vs := mload(add(signature, 0x40))
629             }
630             return tryRecover(hash, r, vs);
631         } else {
632             return (address(0), RecoverError.InvalidSignatureLength);
633         }
634     }
635 
636     /**
637      * @dev Returns the address that signed a hashed message (`hash`) with
638      * `signature`. This address can then be used for verification purposes.
639      *
640      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
641      * this function rejects them by requiring the `s` value to be in the lower
642      * half order, and the `v` value to be either 27 or 28.
643      *
644      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
645      * verification to be secure: it is possible to craft signatures that
646      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
647      * this is by receiving a hash of the original message (which may otherwise
648      * be too long), and then calling {toEthSignedMessageHash} on it.
649      */
650     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
651         (address recovered, RecoverError error) = tryRecover(hash, signature);
652         _throwError(error);
653         return recovered;
654     }
655 
656     /**
657      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
658      *
659      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
660      *
661      * _Available since v4.3._
662      */
663     function tryRecover(
664         bytes32 hash,
665         bytes32 r,
666         bytes32 vs
667     ) internal pure returns (address, RecoverError) {
668         bytes32 s;
669         uint8 v;
670         assembly {
671             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
672             v := add(shr(255, vs), 27)
673         }
674         return tryRecover(hash, v, r, s);
675     }
676 
677     /**
678      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
679      *
680      * _Available since v4.2._
681      */
682     function recover(
683         bytes32 hash,
684         bytes32 r,
685         bytes32 vs
686     ) internal pure returns (address) {
687         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
688         _throwError(error);
689         return recovered;
690     }
691 
692     /**
693      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
694      * `r` and `s` signature fields separately.
695      *
696      * _Available since v4.3._
697      */
698     function tryRecover(
699         bytes32 hash,
700         uint8 v,
701         bytes32 r,
702         bytes32 s
703     ) internal pure returns (address, RecoverError) {
704         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
705         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
706         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
707         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
708         //
709         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
710         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
711         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
712         // these malleable signatures as well.
713         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
714             return (address(0), RecoverError.InvalidSignatureS);
715         }
716         if (v != 27 && v != 28) {
717             return (address(0), RecoverError.InvalidSignatureV);
718         }
719 
720         // If the signature is valid (and not malleable), return the signer address
721         address signer = ecrecover(hash, v, r, s);
722         if (signer == address(0)) {
723             return (address(0), RecoverError.InvalidSignature);
724         }
725 
726         return (signer, RecoverError.NoError);
727     }
728 
729     /**
730      * @dev Overload of {ECDSA-recover} that receives the `v`,
731      * `r` and `s` signature fields separately.
732      */
733     function recover(
734         bytes32 hash,
735         uint8 v,
736         bytes32 r,
737         bytes32 s
738     ) internal pure returns (address) {
739         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
740         _throwError(error);
741         return recovered;
742     }
743 
744     /**
745      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
746      * produces hash corresponding to the one signed with the
747      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
748      * JSON-RPC method as part of EIP-191.
749      *
750      * See {recover}.
751      */
752     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
753         // 32 is the length in bytes of hash,
754         // enforced by the type signature above
755         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
756     }
757 
758     /**
759      * @dev Returns an Ethereum Signed Message, created from `s`. This
760      * produces hash corresponding to the one signed with the
761      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
762      * JSON-RPC method as part of EIP-191.
763      *
764      * See {recover}.
765      */
766     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
767         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
768     }
769 
770     /**
771      * @dev Returns an Ethereum Signed Typed Data, created from a
772      * `domainSeparator` and a `structHash`. This produces hash corresponding
773      * to the one signed with the
774      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
775      * JSON-RPC method as part of EIP-712.
776      *
777      * See {recover}.
778      */
779     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
780         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
781     }
782 }
783 
784 /**
785  * @dev Provides information about the current execution context, including the
786  * sender of the transaction and its data. While these are generally available
787  * via msg.sender and msg.data, they should not be accessed in such a direct
788  * manner, since when dealing with meta-transactions the account sending and
789  * paying for execution may not be the actual sender (as far as an application
790  * is concerned).
791  *
792  * This contract is only required for intermediate, library-like contracts.
793  */
794 abstract contract Context {
795     function _msgSender() internal view virtual returns (address) {
796         return msg.sender;
797     }
798 
799     function _msgData() internal view virtual returns (bytes calldata) {
800         return msg.data;
801     }
802 }
803 
804 /**
805  * @dev Contract module which provides a basic access control mechanism, where
806  * there is an account (an owner) that can be granted exclusive access to
807  * specific functions.
808  *
809  * By default, the owner account will be the one that deploys the contract. This
810  * can later be changed with {transferOwnership}.
811  *
812  * This module is used through inheritance. It will make available the modifier
813  * `onlyOwner`, which can be applied to your functions to restrict their use to
814  * the owner.
815  */
816 abstract contract Ownable is Context {
817     address private _owner;
818 
819     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
820 
821     /**
822      * @dev Initializes the contract setting the deployer as the initial owner.
823      */
824     constructor() {
825         _transferOwnership(_msgSender());
826     }
827 
828     /**
829      * @dev Returns the address of the current owner.
830      */
831     function owner() public view virtual returns (address) {
832         return _owner;
833     }
834 
835     /**
836      * @dev Throws if called by any account other than the owner.
837      */
838     modifier onlyOwner() {
839         require(owner() == _msgSender(), "Ownable: caller is not the owner");
840         _;
841     }
842 
843     /**
844      * @dev Leaves the contract without owner. It will not be possible to call
845      * `onlyOwner` functions anymore. Can only be called by the current owner.
846      *
847      * NOTE: Renouncing ownership will leave the contract without an owner,
848      * thereby removing any functionality that is only available to the owner.
849      */
850     function renounceOwnership() public virtual onlyOwner {
851         _transferOwnership(address(0));
852     }
853 
854     /**
855      * @dev Transfers ownership of the contract to a new account (`newOwner`).
856      * Can only be called by the current owner.
857      */
858     function transferOwnership(address newOwner) public virtual onlyOwner {
859         require(newOwner != address(0), "Ownable: new owner is the zero address");
860         _transferOwnership(newOwner);
861     }
862 
863     /**
864      * @dev Transfers ownership of the contract to a new account (`newOwner`).
865      * Internal function without access restriction.
866      */
867     function _transferOwnership(address newOwner) internal virtual {
868         address oldOwner = _owner;
869         _owner = newOwner;
870         emit OwnershipTransferred(oldOwner, newOwner);
871     }
872 }
873 
874 /**
875  * @dev Contract module that helps prevent reentrant calls to a function.
876  *
877  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
878  * available, which can be applied to functions to make sure there are no nested
879  * (reentrant) calls to them.
880  *
881  * Note that because there is a single `nonReentrant` guard, functions marked as
882  * `nonReentrant` may not call one another. This can be worked around by making
883  * those functions `private`, and then adding `external` `nonReentrant` entry
884  * points to them.
885  *
886  * TIP: If you would like to learn more about reentrancy and alternative ways
887  * to protect against it, check out our blog post
888  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
889  */
890 abstract contract ReentrancyGuard {
891     // Booleans are more expensive than uint256 or any type that takes up a full
892     // word because each write operation emits an extra SLOAD to first read the
893     // slot's contents, replace the bits taken up by the boolean, and then write
894     // back. This is the compiler's defense against contract upgrades and
895     // pointer aliasing, and it cannot be disabled.
896 
897     // The values being non-zero value makes deployment a bit more expensive,
898     // but in exchange the refund on every call to nonReentrant will be lower in
899     // amount. Since refunds are capped to a percentage of the total
900     // transaction's gas, it is best to keep them low in cases like this one, to
901     // increase the likelihood of the full refund coming into effect.
902     uint256 private constant _NOT_ENTERED = 1;
903     uint256 private constant _ENTERED = 2;
904 
905     uint256 private _status;
906 
907     constructor() {
908         _status = _NOT_ENTERED;
909     }
910 
911     /**
912      * @dev Prevents a contract from calling itself, directly or indirectly.
913      * Calling a `nonReentrant` function from another `nonReentrant`
914      * function is not supported. It is possible to prevent this from happening
915      * by making the `nonReentrant` function external, and making it call a
916      * `private` function that does the actual work.
917      */
918     modifier nonReentrant() {
919         // On the first call to nonReentrant, _notEntered will be true
920         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
921 
922         // Any calls to nonReentrant after this point will fail
923         _status = _ENTERED;
924 
925         _;
926 
927         // By storing the original value once again, a refund is triggered (see
928         // https://eips.ethereum.org/EIPS/eip-2200)
929         _status = _NOT_ENTERED;
930     }
931 }
932 
933 /**
934  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
935  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
936  *
937  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
938  *
939  * Does not support burning tokens to address(0).
940  *
941  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
942  */
943 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
944     using Address for address;
945     using Strings for uint256;
946 
947     struct TokenOwnership {
948         address addr;
949         uint64 startTimestamp;
950     }
951 
952     struct AddressData {
953         uint128 balance;
954         uint128 numberMinted;
955     }
956 
957     uint256 internal currentIndex;
958 
959     // Token name
960     string private _name;
961 
962     // Token symbol
963     string private _symbol;
964 
965     // Mapping from token ID to ownership details
966     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
967     mapping(uint256 => TokenOwnership) internal _ownerships;
968 
969     // Mapping owner address to address data
970     mapping(address => AddressData) private _addressData;
971 
972     // Mapping from token ID to approved address
973     mapping(uint256 => address) private _tokenApprovals;
974 
975     // Mapping from owner to operator approvals
976     mapping(address => mapping(address => bool)) private _operatorApprovals;
977 
978     constructor(string memory name_, string memory symbol_) {
979         _name = name_;
980         _symbol = symbol_;
981     }
982 
983     /**
984      * @dev See {IERC721Enumerable-totalSupply}.
985      */
986     function totalSupply() public view override returns (uint256) {
987         return currentIndex;
988     }
989 
990     /**
991      * @dev See {IERC721Enumerable-tokenByIndex}.
992      */
993     function tokenByIndex(uint256 index) public view override returns (uint256) {
994         require(index < totalSupply(), 'ERC721A: global index out of bounds');
995         return index;
996     }
997 
998     /**
999      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1000      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1001      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1002      */
1003     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1004         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
1005         uint256 numMintedSoFar = totalSupply();
1006         uint256 tokenIdsIdx;
1007         address currOwnershipAddr;
1008 
1009         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1010         unchecked {
1011             for (uint256 i; i < numMintedSoFar; i++) {
1012                 TokenOwnership memory ownership = _ownerships[i];
1013                 if (ownership.addr != address(0)) {
1014                     currOwnershipAddr = ownership.addr;
1015                 }
1016                 if (currOwnershipAddr == owner) {
1017                     if (tokenIdsIdx == index) {
1018                         return i;
1019                     }
1020                     tokenIdsIdx++;
1021                 }
1022             }
1023         }
1024 
1025         revert('ERC721A: unable to get token of owner by index');
1026     }
1027 
1028     /**
1029      * @dev See {IERC165-supportsInterface}.
1030      */
1031     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1032         return
1033             interfaceId == type(IERC721).interfaceId ||
1034             interfaceId == type(IERC721Metadata).interfaceId ||
1035             interfaceId == type(IERC721Enumerable).interfaceId ||
1036             super.supportsInterface(interfaceId);
1037     }
1038 
1039     /**
1040      * @dev See {IERC721-balanceOf}.
1041      */
1042     function balanceOf(address owner) public view override returns (uint256) {
1043         require(owner != address(0), 'ERC721A: balance query for the zero address');
1044         return uint256(_addressData[owner].balance);
1045     }
1046 
1047     function _numberMinted(address owner) internal view returns (uint256) {
1048         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1049         return uint256(_addressData[owner].numberMinted);
1050     }
1051 
1052     /**
1053      * Gas spent here starts off proportional to the maximum mint batch size.
1054      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1055      */
1056     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1057         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1058 
1059         unchecked {
1060             for (uint256 curr = tokenId; curr >= 0; curr--) {
1061                 TokenOwnership memory ownership = _ownerships[curr];
1062                 if (ownership.addr != address(0)) {
1063                     return ownership;
1064                 }
1065             }
1066         }
1067 
1068         revert('ERC721A: unable to determine the owner of token');
1069     }
1070 
1071     /**
1072      * @dev See {IERC721-ownerOf}.
1073      */
1074     function ownerOf(uint256 tokenId) public view override returns (address) {
1075         return ownershipOf(tokenId).addr;
1076     }
1077 
1078     /**
1079      * @dev See {IERC721Metadata-name}.
1080      */
1081     function name() public view virtual override returns (string memory) {
1082         return _name;
1083     }
1084 
1085     /**
1086      * @dev See {IERC721Metadata-symbol}.
1087      */
1088     function symbol() public view virtual override returns (string memory) {
1089         return _symbol;
1090     }
1091 
1092     /**
1093      * @dev See {IERC721Metadata-tokenURI}.
1094      */
1095     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1096         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1097 
1098         string memory baseURI = _baseURI();
1099         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1100     }
1101 
1102     /**
1103      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1104      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1105      * by default, can be overriden in child contracts.
1106      */
1107     function _baseURI() internal view virtual returns (string memory) {
1108         return '';
1109     }
1110 
1111     /**
1112      * @dev See {IERC721-approve}.
1113      */
1114     function approve(address to, uint256 tokenId) public override {
1115         address owner = ERC721A.ownerOf(tokenId);
1116         require(to != owner, 'ERC721A: approval to current owner');
1117 
1118         require(
1119             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1120             'ERC721A: approve caller is not owner nor approved for all'
1121         );
1122 
1123         _approve(to, tokenId, owner);
1124     }
1125 
1126     /**
1127      * @dev See {IERC721-getApproved}.
1128      */
1129     function getApproved(uint256 tokenId) public view override returns (address) {
1130         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1131 
1132         return _tokenApprovals[tokenId];
1133     }
1134 
1135     /**
1136      * @dev See {IERC721-setApprovalForAll}.
1137      */
1138     function setApprovalForAll(address operator, bool approved) public override {
1139         require(operator != _msgSender(), 'ERC721A: approve to caller');
1140 
1141         _operatorApprovals[_msgSender()][operator] = approved;
1142         emit ApprovalForAll(_msgSender(), operator, approved);
1143     }
1144 
1145     /**
1146      * @dev See {IERC721-isApprovedForAll}.
1147      */
1148     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1149         return _operatorApprovals[owner][operator];
1150     }
1151 
1152     /**
1153      * @dev See {IERC721-transferFrom}.
1154      */
1155     function transferFrom(
1156         address from,
1157         address to,
1158         uint256 tokenId
1159     ) public virtual override {
1160         _transfer(from, to, tokenId);
1161     }
1162 
1163     /**
1164      * @dev See {IERC721-safeTransferFrom}.
1165      */
1166     function safeTransferFrom(
1167         address from,
1168         address to,
1169         uint256 tokenId
1170     ) public virtual override {
1171         safeTransferFrom(from, to, tokenId, '');
1172     }
1173 
1174     /**
1175      * @dev See {IERC721-safeTransferFrom}.
1176      */
1177     function safeTransferFrom(
1178         address from,
1179         address to,
1180         uint256 tokenId,
1181         bytes memory _data
1182     ) public override {
1183         _transfer(from, to, tokenId);
1184         require(
1185             _checkOnERC721Received(from, to, tokenId, _data),
1186             'ERC721A: transfer to non ERC721Receiver implementer'
1187         );
1188     }
1189 
1190     /**
1191      * @dev Returns whether `tokenId` exists.
1192      *
1193      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1194      *
1195      * Tokens start existing when they are minted (`_mint`),
1196      */
1197     function _exists(uint256 tokenId) internal view returns (bool) {
1198         return tokenId < currentIndex;
1199     }
1200 
1201     function _safeMint(address to, uint256 quantity) internal {
1202         _safeMint(to, quantity, '');
1203     }
1204 
1205     /**
1206      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1207      *
1208      * Requirements:
1209      *
1210      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1211      * - `quantity` must be greater than 0.
1212      *
1213      * Emits a {Transfer} event.
1214      */
1215     function _safeMint(
1216         address to,
1217         uint256 quantity,
1218         bytes memory _data
1219     ) internal {
1220         _mint(to, quantity, _data, true);
1221     }
1222 
1223     /**
1224      * @dev Mints `quantity` tokens and transfers them to `to`.
1225      *
1226      * Requirements:
1227      *
1228      * - `to` cannot be the zero address.
1229      * - `quantity` must be greater than 0.
1230      *
1231      * Emits a {Transfer} event.
1232      */
1233     function _mint(
1234         address to,
1235         uint256 quantity,
1236         bytes memory _data,
1237         bool safe
1238     ) internal {
1239         uint256 startTokenId = currentIndex;
1240         require(to != address(0), 'ERC721A: mint to the zero address');
1241         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1242 
1243         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1244 
1245         // Overflows are incredibly unrealistic.
1246         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1247         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1248         unchecked {
1249             _addressData[to].balance += uint128(quantity);
1250             _addressData[to].numberMinted += uint128(quantity);
1251 
1252             _ownerships[startTokenId].addr = to;
1253             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1254 
1255             uint256 updatedIndex = startTokenId;
1256 
1257             for (uint256 i; i < quantity; i++) {
1258                 emit Transfer(address(0), to, updatedIndex);
1259                 if (safe) {
1260                     require(
1261                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1262                         'ERC721A: transfer to non ERC721Receiver implementer'
1263                     );
1264                 }
1265 
1266                 updatedIndex++;
1267             }
1268 
1269             currentIndex = updatedIndex;
1270         }
1271 
1272         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1273     }
1274 
1275     /**
1276      * @dev Transfers `tokenId` from `from` to `to`.
1277      *
1278      * Requirements:
1279      *
1280      * - `to` cannot be the zero address.
1281      * - `tokenId` token must be owned by `from`.
1282      *
1283      * Emits a {Transfer} event.
1284      */
1285     function _transfer(
1286         address from,
1287         address to,
1288         uint256 tokenId
1289     ) private {
1290         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1291 
1292         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1293             getApproved(tokenId) == _msgSender() ||
1294             isApprovedForAll(prevOwnership.addr, _msgSender()));
1295 
1296         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1297 
1298         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1299         require(to != address(0), 'ERC721A: transfer to the zero address');
1300 
1301         _beforeTokenTransfers(from, to, tokenId, 1);
1302 
1303         // Clear approvals from the previous owner
1304         _approve(address(0), tokenId, prevOwnership.addr);
1305 
1306         // Underflow of the sender's balance is impossible because we check for
1307         // ownership above and the recipient's balance can't realistically overflow.
1308         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1309         unchecked {
1310             _addressData[from].balance -= 1;
1311             _addressData[to].balance += 1;
1312 
1313             _ownerships[tokenId].addr = to;
1314             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1315 
1316             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1317             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1318             uint256 nextTokenId = tokenId + 1;
1319             if (_ownerships[nextTokenId].addr == address(0)) {
1320                 if (_exists(nextTokenId)) {
1321                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1322                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1323                 }
1324             }
1325         }
1326 
1327         emit Transfer(from, to, tokenId);
1328         _afterTokenTransfers(from, to, tokenId, 1);
1329     }
1330 
1331     /**
1332      * @dev Approve `to` to operate on `tokenId`
1333      *
1334      * Emits a {Approval} event.
1335      */
1336     function _approve(
1337         address to,
1338         uint256 tokenId,
1339         address owner
1340     ) private {
1341         _tokenApprovals[tokenId] = to;
1342         emit Approval(owner, to, tokenId);
1343     }
1344 
1345     /**
1346      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1347      * The call is not executed if the target address is not a contract.
1348      *
1349      * @param from address representing the previous owner of the given token ID
1350      * @param to target address that will receive the tokens
1351      * @param tokenId uint256 ID of the token to be transferred
1352      * @param _data bytes optional data to send along with the call
1353      * @return bool whether the call correctly returned the expected magic value
1354      */
1355     function _checkOnERC721Received(
1356         address from,
1357         address to,
1358         uint256 tokenId,
1359         bytes memory _data
1360     ) private returns (bool) {
1361         if (to.isContract()) {
1362             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1363                 return retval == IERC721Receiver(to).onERC721Received.selector;
1364             } catch (bytes memory reason) {
1365                 if (reason.length == 0) {
1366                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1367                 } else {
1368                     assembly {
1369                         revert(add(32, reason), mload(reason))
1370                     }
1371                 }
1372             }
1373         } else {
1374             return true;
1375         }
1376     }
1377 
1378     /**
1379      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1380      *
1381      * startTokenId - the first token id to be transferred
1382      * quantity - the amount to be transferred
1383      *
1384      * Calling conditions:
1385      *
1386      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1387      * transferred to `to`.
1388      * - When `from` is zero, `tokenId` will be minted for `to`.
1389      */
1390     function _beforeTokenTransfers(
1391         address from,
1392         address to,
1393         uint256 startTokenId,
1394         uint256 quantity
1395     ) internal virtual {}
1396 
1397     /**
1398      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1399      * minting.
1400      *
1401      * startTokenId - the first token id to be transferred
1402      * quantity - the amount to be transferred
1403      *
1404      * Calling conditions:
1405      *
1406      * - when `from` and `to` are both non-zero.
1407      * - `from` and `to` are never both zero.
1408      */
1409     function _afterTokenTransfers(
1410         address from,
1411         address to,
1412         uint256 startTokenId,
1413         uint256 quantity
1414     ) internal virtual {}
1415 }
1416 
1417 
1418 /**
1419  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1420  * the Metadata extension.
1421  */
1422 contract WWHangover is Context, ERC721A, Ownable, ReentrancyGuard  {
1423     using SafeMath for uint256;
1424     using Strings for uint256;
1425     using ECDSA for bytes32;
1426 
1427     // Provenance hash
1428     string public PROVENANCE_HASH;
1429 
1430     // Signer address
1431     address private signerAddress;
1432 
1433     // Base URI
1434     string public _baseTokenURI;
1435 
1436     // Mint info
1437     uint256 public constant MAX_SUPPLY = 6900;
1438     uint256 public RESERVED = 69;
1439     uint256 public MINT_PRICE = 0.085 ether;
1440 
1441     bool public saleIsActive;
1442     bool public WLSaleIsActive;
1443 
1444     constructor(address signer) ERC721A("Wasted Whales: Hangover", "HO") {
1445         signerAddress = signer;
1446         _safeMint(msg.sender, 1);
1447     }
1448 
1449     function mintHangover(uint256 amount) public payable nonReentrant {
1450         uint256 supply = totalSupply();
1451         require( saleIsActive, "Sale paused" );
1452         require( supply + amount <= MAX_SUPPLY - RESERVED, "Exceeds maximum supply" );
1453         require( msg.value >= MINT_PRICE * amount, "Incorrect ether amount" );
1454         _safeMint(msg.sender, amount);
1455     }
1456 
1457     function mintHangoverWL(uint256 amount, bytes calldata signature) public payable nonReentrant {
1458         uint256 supply = totalSupply();
1459         address sender = msg.sender;
1460         require( WLSaleIsActive, "Whitelist sale paused" );
1461         require( supply + amount <= MAX_SUPPLY - RESERVED, "Exceeds maximum supply" );
1462         require( msg.value >= MINT_PRICE * amount, "Incorrect ether amount" );
1463         require(_validateSignature(
1464           signature,
1465           sender
1466         ), "Invalid data provided");
1467         _safeMint(sender, amount);
1468     }
1469 
1470     function emergencyMint(uint256 tokensToMint) public onlyOwner {
1471         require(totalSupply().add(tokensToMint) <= MAX_SUPPLY - RESERVED, "Exceeds maximum supply");
1472         _safeMint(msg.sender, tokensToMint);
1473     }
1474 
1475     function giveAway(address _to, uint256 amount) external onlyOwner {
1476         require( amount <= RESERVED, "Amount exceeds reserved amount for giveaways" );
1477         _safeMint(_to, amount);
1478         RESERVED -= amount;
1479     }
1480 
1481     function updateSaleStatus(bool status) public onlyOwner {
1482         saleIsActive = status;
1483     }
1484 
1485     function updateWLSaleStatus(bool status) public onlyOwner {
1486         WLSaleIsActive = status;
1487     }
1488 
1489     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1490         require(bytes(PROVENANCE_HASH).length == 0, "Provenance hash has already been set");
1491         PROVENANCE_HASH = provenanceHash;
1492     }
1493 
1494     function _baseURI() internal view virtual override returns (string memory) {
1495         return _baseTokenURI;
1496     }
1497 
1498     function setBaseURI(string memory newBaseURI) public onlyOwner {
1499         _baseTokenURI = newBaseURI;
1500     }
1501 
1502     function setPrice(uint256 newPrice) public onlyOwner {
1503         MINT_PRICE = newPrice;
1504     }
1505 
1506     function getPrice() public view returns (uint256) {
1507         return MINT_PRICE;
1508     }
1509 
1510     function setSignerAddress(address _signer) public onlyOwner {
1511         signerAddress = _signer;
1512     }
1513 
1514     function _validateSignature(
1515         bytes calldata signature,
1516         address senderAddress
1517         ) internal view returns (bool) {
1518         bytes32 dataHash = keccak256(abi.encodePacked(senderAddress));
1519         bytes32 message = ECDSA.toEthSignedMessageHash(dataHash);
1520 
1521         address receivedAddress = ECDSA.recover(message, signature);
1522         return (receivedAddress != address(0) && receivedAddress == signerAddress);
1523     }
1524 
1525     function withdraw() external onlyOwner {
1526         uint256 balance = address(this).balance;
1527         payable(owner()).transfer(balance);
1528     }
1529 }