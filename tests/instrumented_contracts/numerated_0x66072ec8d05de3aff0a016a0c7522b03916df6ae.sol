1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Interface of the ERC165 standard, as defined in the
9  * https://eips.ethereum.org/EIPS/eip-165[EIP].
10  *
11  * Implementers can declare support of contract interfaces, which can then be
12  * queried by others ({ERC165Checker}).
13  *
14  * For an implementation, see {ERC165}.
15  */
16 interface IERC165 {
17     /**
18      * @dev Returns true if this contract implements the interface defined by
19      * `interfaceId`. See the corresponding
20      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
21      * to learn more about how these ids are created.
22      *
23      * This function call must use less than 30 000 gas.
24      */
25     function supportsInterface(bytes4 interfaceId) external view returns (bool);
26 }
27 
28 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
29 
30 
31 
32 pragma solidity ^0.8.0;
33 
34 
35 /**
36  * @dev Required interface of an ERC721 compliant contract.
37  */
38 interface IERC721 is IERC165 {
39     /**
40      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
41      */
42     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
43 
44     /**
45      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
46      */
47     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
48 
49     /**
50      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
51      */
52     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
53 
54     /**
55      * @dev Returns the number of tokens in ``owner``'s account.
56      */
57     function balanceOf(address owner) external view returns (uint256 balance);
58 
59     /**
60      * @dev Returns the owner of the `tokenId` token.
61      *
62      * Requirements:
63      *
64      * - `tokenId` must exist.
65      */
66     function ownerOf(uint256 tokenId) external view returns (address owner);
67 
68     /**
69      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
70      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
71      *
72      * Requirements:
73      *
74      * - `from` cannot be the zero address.
75      * - `to` cannot be the zero address.
76      * - `tokenId` token must exist and be owned by `from`.
77      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
78      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
79      *
80      * Emits a {Transfer} event.
81      */
82     function safeTransferFrom(
83         address from,
84         address to,
85         uint256 tokenId
86     ) external;
87 
88     /**
89      * @dev Transfers `tokenId` token from `from` to `to`.
90      *
91      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
92      *
93      * Requirements:
94      *
95      * - `from` cannot be the zero address.
96      * - `to` cannot be the zero address.
97      * - `tokenId` token must be owned by `from`.
98      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
99      *
100      * Emits a {Transfer} event.
101      */
102     function transferFrom(
103         address from,
104         address to,
105         uint256 tokenId
106     ) external;
107 
108     /**
109      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
110      * The approval is cleared when the token is transferred.
111      *
112      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
113      *
114      * Requirements:
115      *
116      * - The caller must own the token or be an approved operator.
117      * - `tokenId` must exist.
118      *
119      * Emits an {Approval} event.
120      */
121     function approve(address to, uint256 tokenId) external;
122 
123     /**
124      * @dev Returns the account approved for `tokenId` token.
125      *
126      * Requirements:
127      *
128      * - `tokenId` must exist.
129      */
130     function getApproved(uint256 tokenId) external view returns (address operator);
131 
132     /**
133      * @dev Approve or remove `operator` as an operator for the caller.
134      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
135      *
136      * Requirements:
137      *
138      * - The `operator` cannot be the caller.
139      *
140      * Emits an {ApprovalForAll} event.
141      */
142     function setApprovalForAll(address operator, bool _approved) external;
143 
144     /**
145      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
146      *
147      * See {setApprovalForAll}
148      */
149     function isApprovedForAll(address owner, address operator) external view returns (bool);
150 
151     /**
152      * @dev Safely transfers `tokenId` token from `from` to `to`.
153      *
154      * Requirements:
155      *
156      * - `from` cannot be the zero address.
157      * - `to` cannot be the zero address.
158      * - `tokenId` token must exist and be owned by `from`.
159      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
160      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
161      *
162      * Emits a {Transfer} event.
163      */
164     function safeTransferFrom(
165         address from,
166         address to,
167         uint256 tokenId,
168         bytes calldata data
169     ) external;
170 }
171 
172 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
173 
174 
175 
176 pragma solidity ^0.8.0;
177 
178 /**
179  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
180  *
181  * These functions can be used to verify that a message was signed by the holder
182  * of the private keys of a given address.
183  */
184 library ECDSA {
185     enum RecoverError {
186         NoError,
187         InvalidSignature,
188         InvalidSignatureLength,
189         InvalidSignatureS,
190         InvalidSignatureV
191     }
192 
193     function _throwError(RecoverError error) private pure {
194         if (error == RecoverError.NoError) {
195             return; // no error: do nothing
196         } else if (error == RecoverError.InvalidSignature) {
197             revert("ECDSA: invalid signature");
198         } else if (error == RecoverError.InvalidSignatureLength) {
199             revert("ECDSA: invalid signature length");
200         } else if (error == RecoverError.InvalidSignatureS) {
201             revert("ECDSA: invalid signature 's' value");
202         } else if (error == RecoverError.InvalidSignatureV) {
203             revert("ECDSA: invalid signature 'v' value");
204         }
205     }
206 
207     /**
208      * @dev Returns the address that signed a hashed message (`hash`) with
209      * `signature` or error string. This address can then be used for verification purposes.
210      *
211      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
212      * this function rejects them by requiring the `s` value to be in the lower
213      * half order, and the `v` value to be either 27 or 28.
214      *
215      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
216      * verification to be secure: it is possible to craft signatures that
217      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
218      * this is by receiving a hash of the original message (which may otherwise
219      * be too long), and then calling {toEthSignedMessageHash} on it.
220      *
221      * Documentation for signature generation:
222      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
223      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
224      *
225      * _Available since v4.3._
226      */
227     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
228         // Check the signature length
229         // - case 65: r,s,v signature (standard)
230         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
231         if (signature.length == 65) {
232             bytes32 r;
233             bytes32 s;
234             uint8 v;
235             // ecrecover takes the signature parameters, and the only way to get them
236             // currently is to use assembly.
237             assembly {
238                 r := mload(add(signature, 0x20))
239                 s := mload(add(signature, 0x40))
240                 v := byte(0, mload(add(signature, 0x60)))
241             }
242             return tryRecover(hash, v, r, s);
243         } else if (signature.length == 64) {
244             bytes32 r;
245             bytes32 vs;
246             // ecrecover takes the signature parameters, and the only way to get them
247             // currently is to use assembly.
248             assembly {
249                 r := mload(add(signature, 0x20))
250                 vs := mload(add(signature, 0x40))
251             }
252             return tryRecover(hash, r, vs);
253         } else {
254             return (address(0), RecoverError.InvalidSignatureLength);
255         }
256     }
257 
258     /**
259      * @dev Returns the address that signed a hashed message (`hash`) with
260      * `signature`. This address can then be used for verification purposes.
261      *
262      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
263      * this function rejects them by requiring the `s` value to be in the lower
264      * half order, and the `v` value to be either 27 or 28.
265      *
266      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
267      * verification to be secure: it is possible to craft signatures that
268      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
269      * this is by receiving a hash of the original message (which may otherwise
270      * be too long), and then calling {toEthSignedMessageHash} on it.
271      */
272     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
273         (address recovered, RecoverError error) = tryRecover(hash, signature);
274         _throwError(error);
275         return recovered;
276     }
277 
278     /**
279      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
280      *
281      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
282      *
283      * _Available since v4.3._
284      */
285     function tryRecover(
286         bytes32 hash,
287         bytes32 r,
288         bytes32 vs
289     ) internal pure returns (address, RecoverError) {
290         bytes32 s;
291         uint8 v;
292         assembly {
293             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
294             v := add(shr(255, vs), 27)
295         }
296         return tryRecover(hash, v, r, s);
297     }
298 
299     /**
300      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
301      *
302      * _Available since v4.2._
303      */
304     function recover(
305         bytes32 hash,
306         bytes32 r,
307         bytes32 vs
308     ) internal pure returns (address) {
309         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
310         _throwError(error);
311         return recovered;
312     }
313 
314     /**
315      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
316      * `r` and `s` signature fields separately.
317      *
318      * _Available since v4.3._
319      */
320     function tryRecover(
321         bytes32 hash,
322         uint8 v,
323         bytes32 r,
324         bytes32 s
325     ) internal pure returns (address, RecoverError) {
326         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
327         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
328         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
329         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
330         //
331         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
332         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
333         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
334         // these malleable signatures as well.
335         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
336             return (address(0), RecoverError.InvalidSignatureS);
337         }
338         if (v != 27 && v != 28) {
339             return (address(0), RecoverError.InvalidSignatureV);
340         }
341 
342         // If the signature is valid (and not malleable), return the signer address
343         address signer = ecrecover(hash, v, r, s);
344         if (signer == address(0)) {
345             return (address(0), RecoverError.InvalidSignature);
346         }
347 
348         return (signer, RecoverError.NoError);
349     }
350 
351     /**
352      * @dev Overload of {ECDSA-recover} that receives the `v`,
353      * `r` and `s` signature fields separately.
354      */
355     function recover(
356         bytes32 hash,
357         uint8 v,
358         bytes32 r,
359         bytes32 s
360     ) internal pure returns (address) {
361         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
362         _throwError(error);
363         return recovered;
364     }
365 
366     /**
367      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
368      * produces hash corresponding to the one signed with the
369      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
370      * JSON-RPC method as part of EIP-191.
371      *
372      * See {recover}.
373      */
374     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
375         // 32 is the length in bytes of hash,
376         // enforced by the type signature above
377         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
378     }
379 
380     /**
381      * @dev Returns an Ethereum Signed Typed Data, created from a
382      * `domainSeparator` and a `structHash`. This produces hash corresponding
383      * to the one signed with the
384      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
385      * JSON-RPC method as part of EIP-712.
386      *
387      * See {recover}.
388      */
389     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
390         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
391     }
392 }
393 
394 // File: @openzeppelin/contracts/utils/Strings.sol
395 
396 
397 
398 pragma solidity ^0.8.0;
399 
400 /**
401  * @dev String operations.
402  */
403 library Strings {
404     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
405 
406     /**
407      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
408      */
409     function toString(uint256 value) internal pure returns (string memory) {
410         // Inspired by OraclizeAPI's implementation - MIT licence
411         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
412 
413         if (value == 0) {
414             return "0";
415         }
416         uint256 temp = value;
417         uint256 digits;
418         while (temp != 0) {
419             digits++;
420             temp /= 10;
421         }
422         bytes memory buffer = new bytes(digits);
423         while (value != 0) {
424             digits -= 1;
425             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
426             value /= 10;
427         }
428         return string(buffer);
429     }
430 
431     /**
432      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
433      */
434     function toHexString(uint256 value) internal pure returns (string memory) {
435         if (value == 0) {
436             return "0x00";
437         }
438         uint256 temp = value;
439         uint256 length = 0;
440         while (temp != 0) {
441             length++;
442             temp >>= 8;
443         }
444         return toHexString(value, length);
445     }
446 
447     /**
448      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
449      */
450     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
451         bytes memory buffer = new bytes(2 * length + 2);
452         buffer[0] = "0";
453         buffer[1] = "x";
454         for (uint256 i = 2 * length + 1; i > 1; --i) {
455             buffer[i] = _HEX_SYMBOLS[value & 0xf];
456             value >>= 4;
457         }
458         require(value == 0, "Strings: hex length insufficient");
459         return string(buffer);
460     }
461 }
462 
463 // File: @openzeppelin/contracts/utils/Context.sol
464 
465 
466 
467 pragma solidity ^0.8.0;
468 
469 /**
470  * @dev Provides information about the current execution context, including the
471  * sender of the transaction and its data. While these are generally available
472  * via msg.sender and msg.data, they should not be accessed in such a direct
473  * manner, since when dealing with meta-transactions the account sending and
474  * paying for execution may not be the actual sender (as far as an application
475  * is concerned).
476  *
477  * This contract is only required for intermediate, library-like contracts.
478  */
479 abstract contract Context {
480     function _msgSender() internal view virtual returns (address) {
481         return msg.sender;
482     }
483 
484     function _msgData() internal view virtual returns (bytes calldata) {
485         return msg.data;
486     }
487 }
488 
489 // File: @openzeppelin/contracts/access/Ownable.sol
490 
491 
492 
493 pragma solidity ^0.8.0;
494 
495 
496 /**
497  * @dev Contract module which provides a basic access control mechanism, where
498  * there is an account (an owner) that can be granted exclusive access to
499  * specific functions.
500  *
501  * By default, the owner account will be the one that deploys the contract. This
502  * can later be changed with {transferOwnership}.
503  *
504  * This module is used through inheritance. It will make available the modifier
505  * `onlyOwner`, which can be applied to your functions to restrict their use to
506  * the owner.
507  */
508 abstract contract Ownable is Context {
509     address private _owner;
510 
511     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
512 
513     /**
514      * @dev Initializes the contract setting the deployer as the initial owner.
515      */
516     constructor() {
517         _setOwner(_msgSender());
518     }
519 
520     /**
521      * @dev Returns the address of the current owner.
522      */
523     function owner() public view virtual returns (address) {
524         return _owner;
525     }
526 
527     /**
528      * @dev Throws if called by any account other than the owner.
529      */
530     modifier onlyOwner() {
531         require(owner() == _msgSender(), "Ownable: caller is not the owner");
532         _;
533     }
534 
535     /**
536      * @dev Leaves the contract without owner. It will not be possible to call
537      * `onlyOwner` functions anymore. Can only be called by the current owner.
538      *
539      * NOTE: Renouncing ownership will leave the contract without an owner,
540      * thereby removing any functionality that is only available to the owner.
541      */
542     function renounceOwnership() public virtual onlyOwner {
543         _setOwner(address(0));
544     }
545 
546     /**
547      * @dev Transfers ownership of the contract to a new account (`newOwner`).
548      * Can only be called by the current owner.
549      */
550     function transferOwnership(address newOwner) public virtual onlyOwner {
551         require(newOwner != address(0), "Ownable: new owner is the zero address");
552         _setOwner(newOwner);
553     }
554 
555     function _setOwner(address newOwner) private {
556         address oldOwner = _owner;
557         _owner = newOwner;
558         emit OwnershipTransferred(oldOwner, newOwner);
559     }
560 }
561 
562 // File: contracts/svs/SVSDevouring.sol
563 
564 
565 pragma solidity ^0.8.4;
566 
567 
568 
569 
570 
571 contract SVSDevouring is Ownable {
572     address signer = 0xF78525409726F0B05fFC9dEB488Da1fb427fa78c;
573     IERC721 batContract = IERC721(0xeE0BA89699A3dd0f08CB516C069D81a762f65E56);
574     IERC721 vampiressContract = IERC721(0xEA745B608b2B61987785e87279Db586F328EB8Fc);
575     mapping(uint256 => uint256) public hasDevoured;
576 
577     constructor() {}
578 
579     function vampiressesHaveDevoured(uint256[] calldata vampiresses) view external returns(uint256[] memory) {
580         uint256[] memory output = new uint256[](vampiresses.length);
581 
582         for (uint256 i; i < vampiresses.length; i++) {
583             output[i] = hasDevoured[vampiresses[i]];
584         }
585 
586         return output;
587     }
588 
589     function devour(uint256[] calldata bats, uint256[] calldata vampiresses) external {
590         require(bats.length == vampiresses.length, "Invalid amount");
591 
592         for (uint256 i; i < bats.length; i++) {
593             require(vampiressContract.ownerOf(vampiresses[i]) == msg.sender, "Not owner");
594             require(hasDevoured[vampiresses[i]] == 0, "Already devoured");
595 
596             hasDevoured[vampiresses[i]] = bats[i];
597             batContract.transferFrom(msg.sender, address(this), bats[i]);
598         }
599     }
600 
601     function withdrawBat(uint256 bat, address receiver) external onlyOwner {
602         batContract.transferFrom(address(this), receiver, bat);
603     }
604 
605     function claimBat(uint256 bat, bytes calldata signature) external {
606         require(signer == ECDSA.recover(keccak256(abi.encodePacked(msg.sender, bat)), signature), "Invalid signature");
607         batContract.transferFrom(address(this), msg.sender, bat);
608     }
609 
610     function setSigner(address _signer) external onlyOwner {
611         signer = _signer;
612     }
613 }