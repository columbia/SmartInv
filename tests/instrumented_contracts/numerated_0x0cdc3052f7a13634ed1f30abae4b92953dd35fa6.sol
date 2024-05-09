1 /**
2  *Submitted for verification at Etherscan.io on 2022-02-22
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-165[EIP].
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others ({ERC165Checker}).
14  *
15  * For an implementation, see {ERC165}.
16  */
17 interface IERC165 {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 /**
30  * @dev String operations.
31  */
32 library Strings {
33     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
34 
35     /**
36      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
37      */
38     function toString(uint256 value) internal pure returns (string memory) {
39         // Inspired by OraclizeAPI's implementation - MIT licence
40         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
41 
42         if (value == 0) {
43             return "0";
44         }
45         uint256 temp = value;
46         uint256 digits;
47         while (temp != 0) {
48             digits++;
49             temp /= 10;
50         }
51         bytes memory buffer = new bytes(digits);
52         while (value != 0) {
53             digits -= 1;
54             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
55             value /= 10;
56         }
57         return string(buffer);
58     }
59 
60     /**
61      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
62      */
63     function toHexString(uint256 value) internal pure returns (string memory) {
64         if (value == 0) {
65             return "0x00";
66         }
67         uint256 temp = value;
68         uint256 length = 0;
69         while (temp != 0) {
70             length++;
71             temp >>= 8;
72         }
73         return toHexString(value, length);
74     }
75 
76     /**
77      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
78      */
79     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
80         bytes memory buffer = new bytes(2 * length + 2);
81         buffer[0] = "0";
82         buffer[1] = "x";
83         for (uint256 i = 2 * length + 1; i > 1; --i) {
84             buffer[i] = _HEX_SYMBOLS[value & 0xf];
85             value >>= 4;
86         }
87         require(value == 0, "Strings: hex length insufficient");
88         return string(buffer);
89     }
90 }
91 
92 /**
93  * @title ERC721 token receiver interface
94  * @dev Interface for any contract that wants to support safeTransfers
95  * from ERC721 asset contracts.
96  */
97 interface IERC721Receiver {
98     /**
99      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
100      * by `operator` from `from`, this function is called.
101      *
102      * It must return its Solidity selector to confirm the token transfer.
103      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
104      *
105      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
106      */
107     function onERC721Received(
108         address operator,
109         address from,
110         uint256 tokenId,
111         bytes calldata data
112     ) external returns (bytes4);
113 }
114 
115 /**
116  * @dev Required interface of an ERC721 compliant contract.
117  */
118 interface IERC721 is IERC165 {
119     /**
120      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
121      */
122     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
123 
124     /**
125      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
126      */
127     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
128 
129     /**
130      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
131      */
132     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
133 
134     /**
135      * @dev Returns the number of tokens in ``owner``'s account.
136      */
137     function balanceOf(address owner) external view returns (uint256 balance);
138 
139     /**
140      * @dev Returns the owner of the `tokenId` token.
141      *
142      * Requirements:
143      *
144      * - `tokenId` must exist.
145      */
146     function ownerOf(uint256 tokenId) external view returns (address owner);
147 
148     /**
149      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
150      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
151      *
152      * Requirements:
153      *
154      * - `from` cannot be the zero address.
155      * - `to` cannot be the zero address.
156      * - `tokenId` token must exist and be owned by `from`.
157      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
158      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
159      *
160      * Emits a {Transfer} event.
161      */
162     function safeTransferFrom(
163         address from,
164         address to,
165         uint256 tokenId
166     ) external;
167 
168     /**
169      * @dev Transfers `tokenId` token from `from` to `to`.
170      *
171      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
172      *
173      * Requirements:
174      *
175      * - `from` cannot be the zero address.
176      * - `to` cannot be the zero address.
177      * - `tokenId` token must be owned by `from`.
178      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
179      *
180      * Emits a {Transfer} event.
181      */
182     function transferFrom(
183         address from,
184         address to,
185         uint256 tokenId
186     ) external;
187 
188     /**
189      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
190      * The approval is cleared when the token is transferred.
191      *
192      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
193      *
194      * Requirements:
195      *
196      * - The caller must own the token or be an approved operator.
197      * - `tokenId` must exist.
198      *
199      * Emits an {Approval} event.
200      */
201     function approve(address to, uint256 tokenId) external;
202 
203     /**
204      * @dev Returns the account approved for `tokenId` token.
205      *
206      * Requirements:
207      *
208      * - `tokenId` must exist.
209      */
210     function getApproved(uint256 tokenId) external view returns (address operator);
211 
212     /**
213      * @dev Approve or remove `operator` as an operator for the caller.
214      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
215      *
216      * Requirements:
217      *
218      * - The `operator` cannot be the caller.
219      *
220      * Emits an {ApprovalForAll} event.
221      */
222     function setApprovalForAll(address operator, bool _approved) external;
223 
224     /**
225      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
226      *
227      * See {setApprovalForAll}
228      */
229     function isApprovedForAll(address owner, address operator) external view returns (bool);
230 
231     /**
232      * @dev Safely transfers `tokenId` token from `from` to `to`.
233      *
234      * Requirements:
235      *
236      * - `from` cannot be the zero address.
237      * - `to` cannot be the zero address.
238      * - `tokenId` token must exist and be owned by `from`.
239      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
240      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
241      *
242      * Emits a {Transfer} event.
243      */
244     function safeTransferFrom(
245         address from,
246         address to,
247         uint256 tokenId,
248         bytes calldata data
249     ) external;
250 }
251 
252 /**
253  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
254  * @dev See https://eips.ethereum.org/EIPS/eip-721
255  */
256 interface IERC721Metadata is IERC721 {
257     /**
258      * @dev Returns the token collection name.
259      */
260     function name() external view returns (string memory);
261 
262     /**
263      * @dev Returns the token collection symbol.
264      */
265     function symbol() external view returns (string memory);
266 
267     /**
268      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
269      */
270     function tokenURI(uint256 tokenId) external view returns (string memory);
271 }
272 
273 /**
274  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
275  * @dev See https://eips.ethereum.org/EIPS/eip-721
276  */
277 interface IERC721Enumerable is IERC721 {
278     /**
279      * @dev Returns the total amount of tokens stored by the contract.
280      */
281     function totalSupply() external view returns (uint256);
282 
283     /**
284      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
285      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
286      */
287     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
288 
289     /**
290      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
291      * Use along with {totalSupply} to enumerate all tokens.
292      */
293     function tokenByIndex(uint256 index) external view returns (uint256);
294 }
295 
296 library Address {
297     function isContract(address account) internal view returns (bool) {
298         uint size;
299         assembly {
300             size := extcodesize(account)
301         }
302         return size > 0;
303     }
304 }
305 
306 /**
307  * @dev Implementation of the {IERC165} interface.
308  *
309  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
310  * for the additional interface id that will be supported. For example:
311  *
312  * ```solidity
313  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
314  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
315  * }
316  * ```
317  *
318  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
319  */
320 abstract contract ERC165 is IERC165 {
321     /**
322      * @dev See {IERC165-supportsInterface}.
323      */
324     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
325         return interfaceId == type(IERC165).interfaceId;
326     }
327 }
328 
329 // CAUTION
330 // This version of SafeMath should only be used with Solidity 0.8 or later,
331 // because it relies on the compiler's built in overflow checks.
332 
333 /**
334  * @dev Wrappers over Solidity's arithmetic operations.
335  *
336  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
337  * now has built in overflow checking.
338  */
339 library SafeMath {
340     /**
341      * @dev Returns the addition of two unsigned integers, with an overflow flag.
342      *
343      * _Available since v3.4._
344      */
345     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
346         unchecked {
347             uint256 c = a + b;
348             if (c < a) return (false, 0);
349             return (true, c);
350         }
351     }
352 
353     /**
354      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
355      *
356      * _Available since v3.4._
357      */
358     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
359         unchecked {
360             if (b > a) return (false, 0);
361             return (true, a - b);
362         }
363     }
364 
365     /**
366      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
367      *
368      * _Available since v3.4._
369      */
370     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
371         unchecked {
372             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
373             // benefit is lost if 'b' is also tested.
374             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
375             if (a == 0) return (true, 0);
376             uint256 c = a * b;
377             if (c / a != b) return (false, 0);
378             return (true, c);
379         }
380     }
381 
382     /**
383      * @dev Returns the division of two unsigned integers, with a division by zero flag.
384      *
385      * _Available since v3.4._
386      */
387     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
388         unchecked {
389             if (b == 0) return (false, 0);
390             return (true, a / b);
391         }
392     }
393 
394     /**
395      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
396      *
397      * _Available since v3.4._
398      */
399     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
400         unchecked {
401             if (b == 0) return (false, 0);
402             return (true, a % b);
403         }
404     }
405 
406     /**
407      * @dev Returns the addition of two unsigned integers, reverting on
408      * overflow.
409      *
410      * Counterpart to Solidity's `+` operator.
411      *
412      * Requirements:
413      *
414      * - Addition cannot overflow.
415      */
416     function add(uint256 a, uint256 b) internal pure returns (uint256) {
417         return a + b;
418     }
419 
420     /**
421      * @dev Returns the subtraction of two unsigned integers, reverting on
422      * overflow (when the result is negative).
423      *
424      * Counterpart to Solidity's `-` operator.
425      *
426      * Requirements:
427      *
428      * - Subtraction cannot overflow.
429      */
430     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
431         return a - b;
432     }
433 
434     /**
435      * @dev Returns the multiplication of two unsigned integers, reverting on
436      * overflow.
437      *
438      * Counterpart to Solidity's `*` operator.
439      *
440      * Requirements:
441      *
442      * - Multiplication cannot overflow.
443      */
444     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
445         return a * b;
446     }
447 
448     /**
449      * @dev Returns the integer division of two unsigned integers, reverting on
450      * division by zero. The result is rounded towards zero.
451      *
452      * Counterpart to Solidity's `/` operator.
453      *
454      * Requirements:
455      *
456      * - The divisor cannot be zero.
457      */
458     function div(uint256 a, uint256 b) internal pure returns (uint256) {
459         return a / b;
460     }
461 
462     /**
463      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
464      * reverting when dividing by zero.
465      *
466      * Counterpart to Solidity's `%` operator. This function uses a `revert`
467      * opcode (which leaves remaining gas untouched) while Solidity uses an
468      * invalid opcode to revert (consuming all remaining gas).
469      *
470      * Requirements:
471      *
472      * - The divisor cannot be zero.
473      */
474     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
475         return a % b;
476     }
477 
478     /**
479      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
480      * overflow (when the result is negative).
481      *
482      * CAUTION: This function is deprecated because it requires allocating memory for the error
483      * message unnecessarily. For custom revert reasons use {trySub}.
484      *
485      * Counterpart to Solidity's `-` operator.
486      *
487      * Requirements:
488      *
489      * - Subtraction cannot overflow.
490      */
491     function sub(
492         uint256 a,
493         uint256 b,
494         string memory errorMessage
495     ) internal pure returns (uint256) {
496         unchecked {
497             require(b <= a, errorMessage);
498             return a - b;
499         }
500     }
501 
502     /**
503      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
504      * division by zero. The result is rounded towards zero.
505      *
506      * Counterpart to Solidity's `/` operator. Note: this function uses a
507      * `revert` opcode (which leaves remaining gas untouched) while Solidity
508      * uses an invalid opcode to revert (consuming all remaining gas).
509      *
510      * Requirements:
511      *
512      * - The divisor cannot be zero.
513      */
514     function div(
515         uint256 a,
516         uint256 b,
517         string memory errorMessage
518     ) internal pure returns (uint256) {
519         unchecked {
520             require(b > 0, errorMessage);
521             return a / b;
522         }
523     }
524 
525     /**
526      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
527      * reverting with custom message when dividing by zero.
528      *
529      * CAUTION: This function is deprecated because it requires allocating memory for the error
530      * message unnecessarily. For custom revert reasons use {tryMod}.
531      *
532      * Counterpart to Solidity's `%` operator. This function uses a `revert`
533      * opcode (which leaves remaining gas untouched) while Solidity uses an
534      * invalid opcode to revert (consuming all remaining gas).
535      *
536      * Requirements:
537      *
538      * - The divisor cannot be zero.
539      */
540     function mod(
541         uint256 a,
542         uint256 b,
543         string memory errorMessage
544     ) internal pure returns (uint256) {
545         unchecked {
546             require(b > 0, errorMessage);
547             return a % b;
548         }
549     }
550 }
551 
552 /**
553  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
554  *
555  * These functions can be used to verify that a message was signed by the holder
556  * of the private keys of a given address.
557  */
558 library ECDSA {
559     enum RecoverError {
560         NoError,
561         InvalidSignature,
562         InvalidSignatureLength,
563         InvalidSignatureS,
564         InvalidSignatureV
565     }
566 
567     function _throwError(RecoverError error) private pure {
568         if (error == RecoverError.NoError) {
569             return; // no error: do nothing
570         } else if (error == RecoverError.InvalidSignature) {
571             revert("ECDSA: invalid signature");
572         } else if (error == RecoverError.InvalidSignatureLength) {
573             revert("ECDSA: invalid signature length");
574         } else if (error == RecoverError.InvalidSignatureS) {
575             revert("ECDSA: invalid signature 's' value");
576         } else if (error == RecoverError.InvalidSignatureV) {
577             revert("ECDSA: invalid signature 'v' value");
578         }
579     }
580 
581     /**
582      * @dev Returns the address that signed a hashed message (`hash`) with
583      * `signature` or error string. This address can then be used for verification purposes.
584      *
585      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
586      * this function rejects them by requiring the `s` value to be in the lower
587      * half order, and the `v` value to be either 27 or 28.
588      *
589      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
590      * verification to be secure: it is possible to craft signatures that
591      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
592      * this is by receiving a hash of the original message (which may otherwise
593      * be too long), and then calling {toEthSignedMessageHash} on it.
594      *
595      * Documentation for signature generation:
596      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
597      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
598      *
599      * _Available since v4.3._
600      */
601     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
602         // Check the signature length
603         // - case 65: r,s,v signature (standard)
604         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
605         if (signature.length == 65) {
606             bytes32 r;
607             bytes32 s;
608             uint8 v;
609             // ecrecover takes the signature parameters, and the only way to get them
610             // currently is to use assembly.
611             assembly {
612                 r := mload(add(signature, 0x20))
613                 s := mload(add(signature, 0x40))
614                 v := byte(0, mload(add(signature, 0x60)))
615             }
616             return tryRecover(hash, v, r, s);
617         } else if (signature.length == 64) {
618             bytes32 r;
619             bytes32 vs;
620             // ecrecover takes the signature parameters, and the only way to get them
621             // currently is to use assembly.
622             assembly {
623                 r := mload(add(signature, 0x20))
624                 vs := mload(add(signature, 0x40))
625             }
626             return tryRecover(hash, r, vs);
627         } else {
628             return (address(0), RecoverError.InvalidSignatureLength);
629         }
630     }
631 
632     /**
633      * @dev Returns the address that signed a hashed message (`hash`) with
634      * `signature`. This address can then be used for verification purposes.
635      *
636      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
637      * this function rejects them by requiring the `s` value to be in the lower
638      * half order, and the `v` value to be either 27 or 28.
639      *
640      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
641      * verification to be secure: it is possible to craft signatures that
642      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
643      * this is by receiving a hash of the original message (which may otherwise
644      * be too long), and then calling {toEthSignedMessageHash} on it.
645      */
646     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
647         (address recovered, RecoverError error) = tryRecover(hash, signature);
648         _throwError(error);
649         return recovered;
650     }
651 
652     /**
653      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
654      *
655      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
656      *
657      * _Available since v4.3._
658      */
659     function tryRecover(
660         bytes32 hash,
661         bytes32 r,
662         bytes32 vs
663     ) internal pure returns (address, RecoverError) {
664         bytes32 s;
665         uint8 v;
666         assembly {
667             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
668             v := add(shr(255, vs), 27)
669         }
670         return tryRecover(hash, v, r, s);
671     }
672 
673     /**
674      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
675      *
676      * _Available since v4.2._
677      */
678     function recover(
679         bytes32 hash,
680         bytes32 r,
681         bytes32 vs
682     ) internal pure returns (address) {
683         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
684         _throwError(error);
685         return recovered;
686     }
687 
688     /**
689      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
690      * `r` and `s` signature fields separately.
691      *
692      * _Available since v4.3._
693      */
694     function tryRecover(
695         bytes32 hash,
696         uint8 v,
697         bytes32 r,
698         bytes32 s
699     ) internal pure returns (address, RecoverError) {
700         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
701         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
702         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
703         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
704         //
705         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
706         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
707         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
708         // these malleable signatures as well.
709         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
710             return (address(0), RecoverError.InvalidSignatureS);
711         }
712         if (v != 27 && v != 28) {
713             return (address(0), RecoverError.InvalidSignatureV);
714         }
715 
716         // If the signature is valid (and not malleable), return the signer address
717         address signer = ecrecover(hash, v, r, s);
718         if (signer == address(0)) {
719             return (address(0), RecoverError.InvalidSignature);
720         }
721 
722         return (signer, RecoverError.NoError);
723     }
724 
725     /**
726      * @dev Overload of {ECDSA-recover} that receives the `v`,
727      * `r` and `s` signature fields separately.
728      */
729     function recover(
730         bytes32 hash,
731         uint8 v,
732         bytes32 r,
733         bytes32 s
734     ) internal pure returns (address) {
735         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
736         _throwError(error);
737         return recovered;
738     }
739 
740     /**
741      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
742      * produces hash corresponding to the one signed with the
743      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
744      * JSON-RPC method as part of EIP-191.
745      *
746      * See {recover}.
747      */
748     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
749         // 32 is the length in bytes of hash,
750         // enforced by the type signature above
751         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
752     }
753 
754     /**
755      * @dev Returns an Ethereum Signed Message, created from `s`. This
756      * produces hash corresponding to the one signed with the
757      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
758      * JSON-RPC method as part of EIP-191.
759      *
760      * See {recover}.
761      */
762     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
763         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
764     }
765 
766     /**
767      * @dev Returns an Ethereum Signed Typed Data, created from a
768      * `domainSeparator` and a `structHash`. This produces hash corresponding
769      * to the one signed with the
770      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
771      * JSON-RPC method as part of EIP-712.
772      *
773      * See {recover}.
774      */
775     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
776         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
777     }
778 }
779 
780 /**
781  * @dev Provides information about the current execution context, including the
782  * sender of the transaction and its data. While these are generally available
783  * via msg.sender and msg.data, they should not be accessed in such a direct
784  * manner, since when dealing with meta-transactions the account sending and
785  * paying for execution may not be the actual sender (as far as an application
786  * is concerned).
787  *
788  * This contract is only required for intermediate, library-like contracts.
789  */
790 abstract contract Context {
791     function _msgSender() internal view virtual returns (address) {
792         return msg.sender;
793     }
794 
795     function _msgData() internal view virtual returns (bytes calldata) {
796         return msg.data;
797     }
798 }
799 
800 /**
801  * @dev Contract module which provides a basic access control mechanism, where
802  * there is an account (an owner) that can be granted exclusive access to
803  * specific functions.
804  *
805  * By default, the owner account will be the one that deploys the contract. This
806  * can later be changed with {transferOwnership}.
807  *
808  * This module is used through inheritance. It will make available the modifier
809  * `onlyOwner`, which can be applied to your functions to restrict their use to
810  * the owner.
811  */
812 abstract contract Ownable is Context {
813     address private _owner;
814 
815     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
816 
817     /**
818      * @dev Initializes the contract setting the deployer as the initial owner.
819      */
820     constructor() {
821         _transferOwnership(_msgSender());
822     }
823 
824     /**
825      * @dev Returns the address of the current owner.
826      */
827     function owner() public view virtual returns (address) {
828         return _owner;
829     }
830 
831     /**
832      * @dev Throws if called by any account other than the owner.
833      */
834     modifier onlyOwner() {
835         require(owner() == _msgSender(), "Ownable: caller is not the owner");
836         _;
837     }
838 
839     /**
840      * @dev Leaves the contract without owner. It will not be possible to call
841      * `onlyOwner` functions anymore. Can only be called by the current owner.
842      *
843      * NOTE: Renouncing ownership will leave the contract without an owner,
844      * thereby removing any functionality that is only available to the owner.
845      */
846     function renounceOwnership() public virtual onlyOwner {
847         _transferOwnership(address(0));
848     }
849 
850     /**
851      * @dev Transfers ownership of the contract to a new account (`newOwner`).
852      * Can only be called by the current owner.
853      */
854     function transferOwnership(address newOwner) public virtual onlyOwner {
855         require(newOwner != address(0), "Ownable: new owner is the zero address");
856         _transferOwnership(newOwner);
857     }
858 
859     /**
860      * @dev Transfers ownership of the contract to a new account (`newOwner`).
861      * Internal function without access restriction.
862      */
863     function _transferOwnership(address newOwner) internal virtual {
864         address oldOwner = _owner;
865         _owner = newOwner;
866         emit OwnershipTransferred(oldOwner, newOwner);
867     }
868 }
869 
870 /**
871  * @dev Contract module that helps prevent reentrant calls to a function.
872  *
873  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
874  * available, which can be applied to functions to make sure there are no nested
875  * (reentrant) calls to them.
876  *
877  * Note that because there is a single `nonReentrant` guard, functions marked as
878  * `nonReentrant` may not call one another. This can be worked around by making
879  * those functions `private`, and then adding `external` `nonReentrant` entry
880  * points to them.
881  *
882  * TIP: If you would like to learn more about reentrancy and alternative ways
883  * to protect against it, check out our blog post
884  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
885  */
886 abstract contract ReentrancyGuard {
887     // Booleans are more expensive than uint256 or any type that takes up a full
888     // word because each write operation emits an extra SLOAD to first read the
889     // slot's contents, replace the bits taken up by the boolean, and then write
890     // back. This is the compiler's defense against contract upgrades and
891     // pointer aliasing, and it cannot be disabled.
892 
893     // The values being non-zero value makes deployment a bit more expensive,
894     // but in exchange the refund on every call to nonReentrant will be lower in
895     // amount. Since refunds are capped to a percentage of the total
896     // transaction's gas, it is best to keep them low in cases like this one, to
897     // increase the likelihood of the full refund coming into effect.
898     uint256 private constant _NOT_ENTERED = 1;
899     uint256 private constant _ENTERED = 2;
900 
901     uint256 private _status;
902 
903     constructor() {
904         _status = _NOT_ENTERED;
905     }
906 
907     /**
908      * @dev Prevents a contract from calling itself, directly or indirectly.
909      * Calling a `nonReentrant` function from another `nonReentrant`
910      * function is not supported. It is possible to prevent this from happening
911      * by making the `nonReentrant` function external, and making it call a
912      * `private` function that does the actual work.
913      */
914     modifier nonReentrant() {
915         // On the first call to nonReentrant, _notEntered will be true
916         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
917 
918         // Any calls to nonReentrant after this point will fail
919         _status = _ENTERED;
920 
921         _;
922 
923         // By storing the original value once again, a refund is triggered (see
924         // https://eips.ethereum.org/EIPS/eip-2200)
925         _status = _NOT_ENTERED;
926     }
927 }
928 
929 /**
930  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
931  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
932  *
933  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
934  *
935  * Does not support burning tokens to address(0).
936  *
937  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
938  */
939 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
940     using Address for address;
941     using Strings for uint256;
942 
943     struct TokenOwnership {
944         address addr;
945         uint64 startTimestamp;
946     }
947 
948     struct AddressData {
949         uint128 balance;
950         uint128 numberMinted;
951     }
952 
953     uint256 internal currentIndex;
954 
955     // Token name
956     string private _name;
957 
958     // Token symbol
959     string private _symbol;
960 
961     // Mapping from token ID to ownership details
962     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
963     mapping(uint256 => TokenOwnership) internal _ownerships;
964 
965     // Mapping owner address to address data
966     mapping(address => AddressData) private _addressData;
967 
968     // Mapping from token ID to approved address
969     mapping(uint256 => address) private _tokenApprovals;
970 
971     // Mapping from owner to operator approvals
972     mapping(address => mapping(address => bool)) private _operatorApprovals;
973 
974     constructor(string memory name_, string memory symbol_) {
975         _name = name_;
976         _symbol = symbol_;
977     }
978 
979     /**
980      * @dev See {IERC721Enumerable-totalSupply}.
981      */
982     function totalSupply() public view override returns (uint256) {
983         return currentIndex;
984     }
985 
986     /**
987      * @dev See {IERC721Enumerable-tokenByIndex}.
988      */
989     function tokenByIndex(uint256 index) public view override returns (uint256) {
990         require(index < totalSupply(), 'ERC721A: global index out of bounds');
991         return index;
992     }
993 
994     /**
995      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
996      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
997      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
998      */
999     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1000         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
1001         uint256 numMintedSoFar = totalSupply();
1002         uint256 tokenIdsIdx;
1003         address currOwnershipAddr;
1004 
1005         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
1006         unchecked {
1007             for (uint256 i; i < numMintedSoFar; i++) {
1008                 TokenOwnership memory ownership = _ownerships[i];
1009                 if (ownership.addr != address(0)) {
1010                     currOwnershipAddr = ownership.addr;
1011                 }
1012                 if (currOwnershipAddr == owner) {
1013                     if (tokenIdsIdx == index) {
1014                         return i;
1015                     }
1016                     tokenIdsIdx++;
1017                 }
1018             }
1019         }
1020 
1021         revert('ERC721A: unable to get token of owner by index');
1022     }
1023 
1024     /**
1025      * @dev See {IERC165-supportsInterface}.
1026      */
1027     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1028         return
1029             interfaceId == type(IERC721).interfaceId ||
1030             interfaceId == type(IERC721Metadata).interfaceId ||
1031             interfaceId == type(IERC721Enumerable).interfaceId ||
1032             super.supportsInterface(interfaceId);
1033     }
1034 
1035     /**
1036      * @dev See {IERC721-balanceOf}.
1037      */
1038     function balanceOf(address owner) public view override returns (uint256) {
1039         require(owner != address(0), 'ERC721A: balance query for the zero address');
1040         return uint256(_addressData[owner].balance);
1041     }
1042 
1043     function _numberMinted(address owner) internal view returns (uint256) {
1044         require(owner != address(0), 'ERC721A: number minted query for the zero address');
1045         return uint256(_addressData[owner].numberMinted);
1046     }
1047 
1048     /**
1049      * Gas spent here starts off proportional to the maximum mint batch size.
1050      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1051      */
1052     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1053         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
1054 
1055         unchecked {
1056             for (uint256 curr = tokenId; curr >= 0; curr--) {
1057                 TokenOwnership memory ownership = _ownerships[curr];
1058                 if (ownership.addr != address(0)) {
1059                     return ownership;
1060                 }
1061             }
1062         }
1063 
1064         revert('ERC721A: unable to determine the owner of token');
1065     }
1066 
1067     /**
1068      * @dev See {IERC721-ownerOf}.
1069      */
1070     function ownerOf(uint256 tokenId) public view override returns (address) {
1071         return ownershipOf(tokenId).addr;
1072     }
1073 
1074     /**
1075      * @dev See {IERC721Metadata-name}.
1076      */
1077     function name() public view virtual override returns (string memory) {
1078         return _name;
1079     }
1080 
1081     /**
1082      * @dev See {IERC721Metadata-symbol}.
1083      */
1084     function symbol() public view virtual override returns (string memory) {
1085         return _symbol;
1086     }
1087 
1088     /**
1089      * @dev See {IERC721Metadata-tokenURI}.
1090      */
1091     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1092         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1093 
1094         string memory baseURI = _baseURI();
1095         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1096     }
1097 
1098     /**
1099      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1100      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1101      * by default, can be overriden in child contracts.
1102      */
1103     function _baseURI() internal view virtual returns (string memory) {
1104         return '';
1105     }
1106 
1107     /**
1108      * @dev See {IERC721-approve}.
1109      */
1110     function approve(address to, uint256 tokenId) public override {
1111         address owner = ERC721A.ownerOf(tokenId);
1112         require(to != owner, 'ERC721A: approval to current owner');
1113 
1114         require(
1115             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1116             'ERC721A: approve caller is not owner nor approved for all'
1117         );
1118 
1119         _approve(to, tokenId, owner);
1120     }
1121 
1122     /**
1123      * @dev See {IERC721-getApproved}.
1124      */
1125     function getApproved(uint256 tokenId) public view override returns (address) {
1126         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1127 
1128         return _tokenApprovals[tokenId];
1129     }
1130 
1131     /**
1132      * @dev See {IERC721-setApprovalForAll}.
1133      */
1134     function setApprovalForAll(address operator, bool approved) public override {
1135         require(operator != _msgSender(), 'ERC721A: approve to caller');
1136 
1137         _operatorApprovals[_msgSender()][operator] = approved;
1138         emit ApprovalForAll(_msgSender(), operator, approved);
1139     }
1140 
1141     /**
1142      * @dev See {IERC721-isApprovedForAll}.
1143      */
1144     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1145         return _operatorApprovals[owner][operator];
1146     }
1147 
1148     /**
1149      * @dev See {IERC721-transferFrom}.
1150      */
1151     function transferFrom(
1152         address from,
1153         address to,
1154         uint256 tokenId
1155     ) public virtual override {
1156         _transfer(from, to, tokenId);
1157     }
1158 
1159     /**
1160      * @dev See {IERC721-safeTransferFrom}.
1161      */
1162     function safeTransferFrom(
1163         address from,
1164         address to,
1165         uint256 tokenId
1166     ) public virtual override {
1167         safeTransferFrom(from, to, tokenId, '');
1168     }
1169 
1170     /**
1171      * @dev See {IERC721-safeTransferFrom}.
1172      */
1173     function safeTransferFrom(
1174         address from,
1175         address to,
1176         uint256 tokenId,
1177         bytes memory _data
1178     ) public override {
1179         _transfer(from, to, tokenId);
1180         require(
1181             _checkOnERC721Received(from, to, tokenId, _data),
1182             'ERC721A: transfer to non ERC721Receiver implementer'
1183         );
1184     }
1185 
1186     /**
1187      * @dev Returns whether `tokenId` exists.
1188      *
1189      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1190      *
1191      * Tokens start existing when they are minted (`_mint`),
1192      */
1193     function _exists(uint256 tokenId) internal view returns (bool) {
1194         return tokenId < currentIndex;
1195     }
1196 
1197     function _safeMint(address to, uint256 quantity) internal {
1198         _safeMint(to, quantity, '');
1199     }
1200 
1201     /**
1202      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1203      *
1204      * Requirements:
1205      *
1206      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1207      * - `quantity` must be greater than 0.
1208      *
1209      * Emits a {Transfer} event.
1210      */
1211     function _safeMint(
1212         address to,
1213         uint256 quantity,
1214         bytes memory _data
1215     ) internal {
1216         _mint(to, quantity, _data, true);
1217     }
1218 
1219     /**
1220      * @dev Mints `quantity` tokens and transfers them to `to`.
1221      *
1222      * Requirements:
1223      *
1224      * - `to` cannot be the zero address.
1225      * - `quantity` must be greater than 0.
1226      *
1227      * Emits a {Transfer} event.
1228      */
1229     function _mint(
1230         address to,
1231         uint256 quantity,
1232         bytes memory _data,
1233         bool safe
1234     ) internal {
1235         uint256 startTokenId = currentIndex;
1236         require(to != address(0), 'ERC721A: mint to the zero address');
1237         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1238 
1239         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1240 
1241         // Overflows are incredibly unrealistic.
1242         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1243         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1244         unchecked {
1245             _addressData[to].balance += uint128(quantity);
1246             _addressData[to].numberMinted += uint128(quantity);
1247 
1248             _ownerships[startTokenId].addr = to;
1249             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1250 
1251             uint256 updatedIndex = startTokenId;
1252 
1253             for (uint256 i; i < quantity; i++) {
1254                 emit Transfer(address(0), to, updatedIndex);
1255                 if (safe) {
1256                     require(
1257                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1258                         'ERC721A: transfer to non ERC721Receiver implementer'
1259                     );
1260                 }
1261 
1262                 updatedIndex++;
1263             }
1264 
1265             currentIndex = updatedIndex;
1266         }
1267 
1268         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1269     }
1270 
1271     /**
1272      * @dev Transfers `tokenId` from `from` to `to`.
1273      *
1274      * Requirements:
1275      *
1276      * - `to` cannot be the zero address.
1277      * - `tokenId` token must be owned by `from`.
1278      *
1279      * Emits a {Transfer} event.
1280      */
1281     function _transfer(
1282         address from,
1283         address to,
1284         uint256 tokenId
1285     ) private {
1286         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1287 
1288         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1289             getApproved(tokenId) == _msgSender() ||
1290             isApprovedForAll(prevOwnership.addr, _msgSender()));
1291 
1292         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1293 
1294         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1295         require(to != address(0), 'ERC721A: transfer to the zero address');
1296 
1297         _beforeTokenTransfers(from, to, tokenId, 1);
1298 
1299         // Clear approvals from the previous owner
1300         _approve(address(0), tokenId, prevOwnership.addr);
1301 
1302         // Underflow of the sender's balance is impossible because we check for
1303         // ownership above and the recipient's balance can't realistically overflow.
1304         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1305         unchecked {
1306             _addressData[from].balance -= 1;
1307             _addressData[to].balance += 1;
1308 
1309             _ownerships[tokenId].addr = to;
1310             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1311 
1312             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1313             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1314             uint256 nextTokenId = tokenId + 1;
1315             if (_ownerships[nextTokenId].addr == address(0)) {
1316                 if (_exists(nextTokenId)) {
1317                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1318                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1319                 }
1320             }
1321         }
1322 
1323         emit Transfer(from, to, tokenId);
1324         _afterTokenTransfers(from, to, tokenId, 1);
1325     }
1326 
1327     /**
1328      * @dev Approve `to` to operate on `tokenId`
1329      *
1330      * Emits a {Approval} event.
1331      */
1332     function _approve(
1333         address to,
1334         uint256 tokenId,
1335         address owner
1336     ) private {
1337         _tokenApprovals[tokenId] = to;
1338         emit Approval(owner, to, tokenId);
1339     }
1340 
1341     /**
1342      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1343      * The call is not executed if the target address is not a contract.
1344      *
1345      * @param from address representing the previous owner of the given token ID
1346      * @param to target address that will receive the tokens
1347      * @param tokenId uint256 ID of the token to be transferred
1348      * @param _data bytes optional data to send along with the call
1349      * @return bool whether the call correctly returned the expected magic value
1350      */
1351     function _checkOnERC721Received(
1352         address from,
1353         address to,
1354         uint256 tokenId,
1355         bytes memory _data
1356     ) private returns (bool) {
1357         if (to.isContract()) {
1358             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1359                 return retval == IERC721Receiver(to).onERC721Received.selector;
1360             } catch (bytes memory reason) {
1361                 if (reason.length == 0) {
1362                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1363                 } else {
1364                     assembly {
1365                         revert(add(32, reason), mload(reason))
1366                     }
1367                 }
1368             }
1369         } else {
1370             return true;
1371         }
1372     }
1373 
1374     /**
1375      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1376      *
1377      * startTokenId - the first token id to be transferred
1378      * quantity - the amount to be transferred
1379      *
1380      * Calling conditions:
1381      *
1382      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1383      * transferred to `to`.
1384      * - When `from` is zero, `tokenId` will be minted for `to`.
1385      */
1386     function _beforeTokenTransfers(
1387         address from,
1388         address to,
1389         uint256 startTokenId,
1390         uint256 quantity
1391     ) internal virtual {}
1392 
1393     /**
1394      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1395      * minting.
1396      *
1397      * startTokenId - the first token id to be transferred
1398      * quantity - the amount to be transferred
1399      *
1400      * Calling conditions:
1401      *
1402      * - when `from` and `to` are both non-zero.
1403      * - `from` and `to` are never both zero.
1404      */
1405     function _afterTokenTransfers(
1406         address from,
1407         address to,
1408         uint256 startTokenId,
1409         uint256 quantity
1410     ) internal virtual {}
1411 }
1412 
1413 
1414 /**
1415  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1416  * the Metadata extension.
1417  */
1418 contract WWAfterparty is Context, ERC721A, Ownable, ReentrancyGuard  {
1419     using SafeMath for uint256;
1420     using Strings for uint256;
1421     using ECDSA for bytes32;
1422 
1423     // Provenance hash
1424     string public PROVENANCE_HASH;
1425 
1426     // Signer address
1427     address public signerAddress;
1428 
1429     // Base URI
1430     string public _baseTokenURI;
1431 
1432     // Mint info
1433     uint256 public constant MAX_SUPPLY = 1600;
1434     uint256 public RESERVED = 20;
1435     uint256 public MINT_PRICE = 0.09 ether;
1436     uint256 public WL_TRANSACTION_LIMIT = 10;
1437 
1438     bool public saleIsActive;
1439     bool public WLSaleIsActive;
1440 
1441     constructor(address signer) ERC721A("Wasted Whales: Afterparty", "AP") {
1442         signerAddress = signer;
1443     }
1444 
1445     function mintAfterparty(uint256 amount) public payable nonReentrant {
1446         uint256 supply = totalSupply();
1447         require( saleIsActive, "Sale paused" );
1448         require( supply + amount <= MAX_SUPPLY - RESERVED, "Exceeds maximum supply" );
1449         require( msg.value >= MINT_PRICE * amount, "Incorrect ether amount" );
1450         _safeMint(msg.sender, amount);
1451     }
1452 
1453     function mintAfterpartyWL(uint256 amount, bytes calldata signature) public payable nonReentrant {
1454         uint256 supply = totalSupply();
1455         address sender = msg.sender;
1456         require( WLSaleIsActive, "Whitelist sale paused" );
1457         require( supply + amount <= MAX_SUPPLY - RESERVED, "Exceeds maximum supply" );
1458         require( amount <= WL_TRANSACTION_LIMIT, "Exceeds per transaction limit" );
1459         require( msg.value >= MINT_PRICE * amount, "Incorrect ether amount" );
1460         require(_validateSignature(
1461           signature,
1462           sender
1463         ), "Invalid data provided");
1464         _safeMint(sender, amount);
1465     }
1466 
1467     function emergencyMint(uint256 tokensToMint) public onlyOwner {
1468         require(totalSupply().add(tokensToMint) <= MAX_SUPPLY - RESERVED, "Exceeds maximum supply");
1469         _safeMint(msg.sender, tokensToMint);
1470     }
1471 
1472     function giveAway(address _to, uint256 amount) external onlyOwner {
1473         require( amount <= RESERVED, "Amount exceeds reserved amount for giveaways" );
1474         _safeMint(_to, amount);
1475         RESERVED -= amount;
1476     }
1477 
1478     function updateSaleStatus(bool status) public onlyOwner {
1479         saleIsActive = status;
1480     }
1481 
1482     function updateWLSaleStatus(bool status) public onlyOwner {
1483         WLSaleIsActive = status;
1484     }
1485 
1486     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1487         require(bytes(PROVENANCE_HASH).length == 0, "Provenance hash has already been set");
1488         PROVENANCE_HASH = provenanceHash;
1489     }
1490 
1491     function _baseURI() internal view virtual override returns (string memory) {
1492         return _baseTokenURI;
1493     }
1494 
1495     function setBaseURI(string memory newBaseURI) public onlyOwner {
1496         _baseTokenURI = newBaseURI;
1497     }
1498 
1499     function setPrice(uint256 newPrice) public onlyOwner {
1500         MINT_PRICE = newPrice;
1501     }
1502 
1503     function getPrice() public view returns (uint256) {
1504         return MINT_PRICE;
1505     }
1506 
1507     function setSignerAddress(address _signer) public onlyOwner {
1508         signerAddress = _signer;
1509     }
1510 
1511     function setTxnLimit(uint256 newLimit) public onlyOwner {
1512         WL_TRANSACTION_LIMIT = newLimit;
1513     }
1514 
1515     function _validateSignature(
1516         bytes calldata signature,
1517         address senderAddress
1518         ) internal view returns (bool) {
1519         bytes32 dataHash = keccak256(abi.encodePacked(senderAddress));
1520         bytes32 message = ECDSA.toEthSignedMessageHash(dataHash);
1521 
1522         address receivedAddress = ECDSA.recover(message, signature);
1523         return (receivedAddress != address(0) && receivedAddress == signerAddress);
1524     }
1525 
1526     function withdraw() external onlyOwner {
1527         uint256 balance = address(this).balance;
1528         payable(owner()).transfer(balance);
1529     }
1530 }