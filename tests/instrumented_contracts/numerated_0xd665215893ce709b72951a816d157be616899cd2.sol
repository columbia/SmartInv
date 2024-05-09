1 /**
2  *Submitted for verification at Etherscan.io on 2022-02-27
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13 	bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
14 
15 	/**
16 	 * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17 	 */
18 	function toString(uint256 value) internal pure returns (string memory) {
19 		// Inspired by OraclizeAPI's implementation - MIT licence
20 		// https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22 		if (value == 0) {
23 			return "0";
24 		}
25 		uint256 temp = value;
26 		uint256 digits;
27 		while (temp != 0) {
28 			digits++;
29 			temp /= 10;
30 		}
31 		bytes memory buffer = new bytes(digits);
32 		while (value != 0) {
33 			digits -= 1;
34 			buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35 			value /= 10;
36 		}
37 		return string(buffer);
38 	}
39 
40 	/**
41 	 * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42 	 */
43 	function toHexString(uint256 value) internal pure returns (string memory) {
44 		if (value == 0) {
45 			return "0x00";
46 		}
47 		uint256 temp = value;
48 		uint256 length = 0;
49 		while (temp != 0) {
50 			length++;
51 			temp >>= 8;
52 		}
53 		return toHexString(value, length);
54 	}
55 
56 	/**
57 	 * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58 	 */
59 	function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60 		bytes memory buffer = new bytes(2 * length + 2);
61 		buffer[0] = "0";
62 		buffer[1] = "x";
63 		for (uint256 i = 2 * length + 1; i > 1; --i) {
64 			buffer[i] = _HEX_SYMBOLS[value & 0xf];
65 			value >>= 4;
66 		}
67 		require(value == 0, "Strings: hex length insufficient");
68 		return string(buffer);
69 	}
70 }
71 
72 /**
73  * @dev Interface of the ERC165 standard, as defined in the
74  * https://eips.ethereum.org/EIPS/eip-165[EIP].
75  *
76  * Implementers can declare support of contract interfaces, which can then be
77  * queried by others ({ERC165Checker}).
78  *
79  * For an implementation, see {ERC165}.
80  */
81 interface IERC165 {
82 	/**
83 	 * @dev Returns true if this contract implements the interface defined by
84 	 * `interfaceId`. See the corresponding
85 	 * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
86 	 * to learn more about how these ids are created.
87 	 *
88 	 * This function call must use less than 30 000 gas.
89 	 */
90 	function supportsInterface(bytes4 interfaceId) external view returns (bool);
91 }
92 
93 /**
94  * @dev Provides information about the current execution context, including the
95  * sender of the transaction and its data. While these are generally available
96  * via msg.sender and msg.data, they should not be accessed in such a direct
97  * manner, since when dealing with meta-transactions the account sending and
98  * paying for execution may not be the actual sender (as far as an application
99  * is concerned).
100  *
101  * This contract is only required for intermediate, library-like contracts.
102  */
103 abstract contract Context {
104 	function _msgSender() internal view virtual returns (address) {
105 		return msg.sender;
106 	}
107 
108 	function _msgData() internal view virtual returns (bytes calldata) {
109 		return msg.data;
110 	}
111 }
112 
113 /**
114  * @dev Contract module that helps prevent reentrant calls to a function.
115  *
116  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
117  * available, which can be applied to functions to make sure there are no nested
118  * (reentrant) calls to them.
119  *
120  * Note that because there is a single `nonReentrant` guard, functions marked as
121  * `nonReentrant` may not call one another. This can be worked around by making
122  * those functions `private`, and then adding `external` `nonReentrant` entry
123  * points to them.
124  *
125  * TIP: If you would like to learn more about reentrancy and alternative ways
126  * to protect against it, check out our blog post
127  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
128  */
129 abstract contract ReentrancyGuard {
130 	// Booleans are more expensive than uint256 or any type that takes up a full
131 	// word because each write operation emits an extra SLOAD to first read the
132 	// slot's contents, replace the bits taken up by the boolean, and then write
133 	// back. This is the compiler's defense against contract upgrades and
134 	// pointer aliasing, and it cannot be disabled.
135 
136 	// The values being non-zero value makes deployment a bit more expensive,
137 	// but in exchange the refund on every call to nonReentrant will be lower in
138 	// amount. Since refunds are capped to a percentage of the total
139 	// transaction's gas, it is best to keep them low in cases like this one, to
140 	// increase the likelihood of the full refund coming into effect.
141 	uint256 private constant _NOT_ENTERED = 1;
142 	uint256 private constant _ENTERED = 2;
143 
144 	uint256 private _status;
145 
146 	constructor() {
147 		_status = _NOT_ENTERED;
148 	}
149 
150 	/**
151 	 * @dev Prevents a contract from calling itself, directly or indirectly.
152 	 * Calling a `nonReentrant` function from another `nonReentrant`
153 	 * function is not supported. It is possible to prevent this from happening
154 	 * by making the `nonReentrant` function external, and making it call a
155 	 * `private` function that does the actual work.
156 	 */
157 	modifier nonReentrant() {
158 		// On the first call to nonReentrant, _notEntered will be true
159 		require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
160 
161 		// Any calls to nonReentrant after this point will fail
162 		_status = _ENTERED;
163 
164 		_;
165 
166 		// By storing the original value once again, a refund is triggered (see
167 		// https://eips.ethereum.org/EIPS/eip-2200)
168 		_status = _NOT_ENTERED;
169 	}
170 }
171 
172 /**
173  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
174  *
175  * These functions can be used to verify that a message was signed by the holder
176  * of the private keys of a given address.
177  */
178 library ECDSA {
179 	enum RecoverError {
180 		NoError,
181 		InvalidSignature,
182 		InvalidSignatureLength,
183 		InvalidSignatureS,
184 		InvalidSignatureV
185 	}
186 
187 	function _throwError(RecoverError error) private pure {
188 		if (error == RecoverError.NoError) {
189 			return; // no error: do nothing
190 		} else if (error == RecoverError.InvalidSignature) {
191 			revert("ECDSA: invalid signature");
192 		} else if (error == RecoverError.InvalidSignatureLength) {
193 			revert("ECDSA: invalid signature length");
194 		} else if (error == RecoverError.InvalidSignatureS) {
195 			revert("ECDSA: invalid signature 's' value");
196 		} else if (error == RecoverError.InvalidSignatureV) {
197 			revert("ECDSA: invalid signature 'v' value");
198 		}
199 	}
200 
201 	/**
202 	 * @dev Returns the address that signed a hashed message (`hash`) with
203 	 * `signature` or error string. This address can then be used for verification purposes.
204 	 *
205 	 * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
206 	 * this function rejects them by requiring the `s` value to be in the lower
207 	 * half order, and the `v` value to be either 27 or 28.
208 	 *
209 	 * IMPORTANT: `hash` _must_ be the result of a hash operation for the
210 	 * verification to be secure: it is possible to craft signatures that
211 	 * recover to arbitrary addresses for non-hashed data. A safe way to ensure
212 	 * this is by receiving a hash of the original message (which may otherwise
213 	 * be too long), and then calling {toEthSignedMessageHash} on it.
214 	 *
215 	 * Documentation for signature generation:
216 	 * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
217 	 * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
218 	 *
219 	 * _Available since v4.3._
220 	 */
221 	function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
222 		// Check the signature length
223 		// - case 65: r,s,v signature (standard)
224 		// - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
225 		if (signature.length == 65) {
226 			bytes32 r;
227 			bytes32 s;
228 			uint8 v;
229 			// ecrecover takes the signature parameters, and the only way to get them
230 			// currently is to use assembly.
231 			assembly {
232 				r := mload(add(signature, 0x20))
233 				s := mload(add(signature, 0x40))
234 				v := byte(0, mload(add(signature, 0x60)))
235 			}
236 			return tryRecover(hash, v, r, s);
237 		} else if (signature.length == 64) {
238 			bytes32 r;
239 			bytes32 vs;
240 			// ecrecover takes the signature parameters, and the only way to get them
241 			// currently is to use assembly.
242 			assembly {
243 				r := mload(add(signature, 0x20))
244 				vs := mload(add(signature, 0x40))
245 			}
246 			return tryRecover(hash, r, vs);
247 		} else {
248 			return (address(0), RecoverError.InvalidSignatureLength);
249 		}
250 	}
251 
252 	/**
253 	 * @dev Returns the address that signed a hashed message (`hash`) with
254 	 * `signature`. This address can then be used for verification purposes.
255 	 *
256 	 * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
257 	 * this function rejects them by requiring the `s` value to be in the lower
258 	 * half order, and the `v` value to be either 27 or 28.
259 	 *
260 	 * IMPORTANT: `hash` _must_ be the result of a hash operation for the
261 	 * verification to be secure: it is possible to craft signatures that
262 	 * recover to arbitrary addresses for non-hashed data. A safe way to ensure
263 	 * this is by receiving a hash of the original message (which may otherwise
264 	 * be too long), and then calling {toEthSignedMessageHash} on it.
265 	 */
266 	function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
267 		(address recovered, RecoverError error) = tryRecover(hash, signature);
268 		_throwError(error);
269 		return recovered;
270 	}
271 
272 	/**
273 	 * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
274 	 *
275 	 * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
276 	 *
277 	 * _Available since v4.3._
278 	 */
279 	function tryRecover(
280 		bytes32 hash,
281 		bytes32 r,
282 		bytes32 vs
283 	) internal pure returns (address, RecoverError) {
284 		bytes32 s;
285 		uint8 v;
286 		assembly {
287 			s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
288 			v := add(shr(255, vs), 27)
289 		}
290 		return tryRecover(hash, v, r, s);
291 	}
292 
293 	/**
294 	 * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
295 	 *
296 	 * _Available since v4.2._
297 	 */
298 	function recover(
299 		bytes32 hash,
300 		bytes32 r,
301 		bytes32 vs
302 	) internal pure returns (address) {
303 		(address recovered, RecoverError error) = tryRecover(hash, r, vs);
304 		_throwError(error);
305 		return recovered;
306 	}
307 
308 	/**
309 	 * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
310 	 * `r` and `s` signature fields separately.
311 	 *
312 	 * _Available since v4.3._
313 	 */
314 	function tryRecover(
315 		bytes32 hash,
316 		uint8 v,
317 		bytes32 r,
318 		bytes32 s
319 	) internal pure returns (address, RecoverError) {
320 		// EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
321 		// unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
322 		// the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
323 		// signatures from current libraries generate a unique signature with an s-value in the lower half order.
324 		//
325 		// If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
326 		// with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
327 		// vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
328 		// these malleable signatures as well.
329 		if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
330 			return (address(0), RecoverError.InvalidSignatureS);
331 		}
332 		if (v != 27 && v != 28) {
333 			return (address(0), RecoverError.InvalidSignatureV);
334 		}
335 
336 		// If the signature is valid (and not malleable), return the signer address
337 		address signer = ecrecover(hash, v, r, s);
338 		if (signer == address(0)) {
339 			return (address(0), RecoverError.InvalidSignature);
340 		}
341 
342 		return (signer, RecoverError.NoError);
343 	}
344 
345 	/**
346 	 * @dev Overload of {ECDSA-recover} that receives the `v`,
347 	 * `r` and `s` signature fields separately.
348 	 */
349 	function recover(
350 		bytes32 hash,
351 		uint8 v,
352 		bytes32 r,
353 		bytes32 s
354 	) internal pure returns (address) {
355 		(address recovered, RecoverError error) = tryRecover(hash, v, r, s);
356 		_throwError(error);
357 		return recovered;
358 	}
359 
360 	/**
361 	 * @dev Returns an Ethereum Signed Message, created from a `hash`. This
362 	 * produces hash corresponding to the one signed with the
363 	 * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
364 	 * JSON-RPC method as part of EIP-191.
365 	 *
366 	 * See {recover}.
367 	 */
368 	function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
369 		// 32 is the length in bytes of hash,
370 		// enforced by the type signature above
371 		return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
372 	}
373 
374 	/**
375 	 * @dev Returns an Ethereum Signed Message, created from `s`. This
376 	 * produces hash corresponding to the one signed with the
377 	 * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
378 	 * JSON-RPC method as part of EIP-191.
379 	 *
380 	 * See {recover}.
381 	 */
382 	function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
383 		return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
384 	}
385 
386 	/**
387 	 * @dev Returns an Ethereum Signed Typed Data, created from a
388 	 * `domainSeparator` and a `structHash`. This produces hash corresponding
389 	 * to the one signed with the
390 	 * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
391 	 * JSON-RPC method as part of EIP-712.
392 	 *
393 	 * See {recover}.
394 	 */
395 	function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
396 		return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
397 	}
398 }
399 
400 /**
401  * @dev Interface of the ERC20 standard as defined in the EIP.
402  */
403 interface IERC20 {
404 	/**
405 	 * @dev Returns the amount of tokens in existence.
406 	 */
407 	function totalSupply() external view returns (uint256);
408 
409 	/**
410 	 * @dev Returns the amount of tokens owned by `account`.
411 	 */
412 	function balanceOf(address account) external view returns (uint256);
413 
414 	/**
415 	 * @dev Moves `amount` tokens from the caller's account to `recipient`.
416 	 *
417 	 * Returns a boolean value indicating whether the operation succeeded.
418 	 *
419 	 * Emits a {Transfer} event.
420 	 */
421 	function transfer(address recipient, uint256 amount) external returns (bool);
422 
423 	/**
424 	 * @dev Returns the remaining number of tokens that `spender` will be
425 	 * allowed to spend on behalf of `owner` through {transferFrom}. This is
426 	 * zero by default.
427 	 *
428 	 * This value changes when {approve} or {transferFrom} are called.
429 	 */
430 	function allowance(address owner, address spender) external view returns (uint256);
431 
432 	/**
433 	 * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
434 	 *
435 	 * Returns a boolean value indicating whether the operation succeeded.
436 	 *
437 	 * IMPORTANT: Beware that changing an allowance with this method brings the risk
438 	 * that someone may use both the old and the new allowance by unfortunate
439 	 * transaction ordering. One possible solution to mitigate this race
440 	 * condition is to first reduce the spender's allowance to 0 and set the
441 	 * desired value afterwards:
442 	 * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
443 	 *
444 	 * Emits an {Approval} event.
445 	 */
446 	function approve(address spender, uint256 amount) external returns (bool);
447 
448 	/**
449 	 * @dev Moves `amount` tokens from `sender` to `recipient` using the
450 	 * allowance mechanism. `amount` is then deducted from the caller's
451 	 * allowance.
452 	 *
453 	 * Returns a boolean value indicating whether the operation succeeded.
454 	 *
455 	 * Emits a {Transfer} event.
456 	 */
457 	function transferFrom(
458 		address sender,
459 		address recipient,
460 		uint256 amount
461 	) external returns (bool);
462 
463 	/**
464 	 * @dev Emitted when `value` tokens are moved from one account (`from`) to
465 	 * another (`to`).
466 	 *
467 	 * Note that `value` may be zero.
468 	 */
469 	event Transfer(address indexed from, address indexed to, uint256 value);
470 
471 	/**
472 	 * @dev Emitted when the allowance of a `spender` for an `owner` is set by
473 	 * a call to {approve}. `value` is the new allowance.
474 	 */
475 	event Approval(address indexed owner, address indexed spender, uint256 value);
476 }
477 
478 /**
479  * @dev Required interface of an ERC721 compliant contract.
480  */
481 interface IERC721 is IERC165 {
482 	/**
483 	 * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
484 	 */
485 	event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
486 
487 	/**
488 	 * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
489 	 */
490 	event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
491 
492 	/**
493 	 * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
494 	 */
495 	event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
496 
497 	/**
498 	 * @dev Returns the number of tokens in ``owner``'s account.
499 	 */
500 	function balanceOf(address owner) external view returns (uint256 balance);
501 
502 	/**
503 	 * @dev Returns the owner of the `tokenId` token.
504 	 *
505 	 * Requirements:
506 	 *
507 	 * - `tokenId` must exist.
508 	 */
509 	function ownerOf(uint256 tokenId) external view returns (address owner);
510 
511 	/**
512 	 * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
513 	 * are aware of the ERC721 protocol to prevent tokens from being forever locked.
514 	 *
515 	 * Requirements:
516 	 *
517 	 * - `from` cannot be the zero address.
518 	 * - `to` cannot be the zero address.
519 	 * - `tokenId` token must exist and be owned by `from`.
520 	 * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
521 	 * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
522 	 *
523 	 * Emits a {Transfer} event.
524 	 */
525 	function safeTransferFrom(
526 		address from,
527 		address to,
528 		uint256 tokenId
529 	) external;
530 
531 	/**
532 	 * @dev Transfers `tokenId` token from `from` to `to`.
533 	 *
534 	 * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
535 	 *
536 	 * Requirements:
537 	 *
538 	 * - `from` cannot be the zero address.
539 	 * - `to` cannot be the zero address.
540 	 * - `tokenId` token must be owned by `from`.
541 	 * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
542 	 *
543 	 * Emits a {Transfer} event.
544 	 */
545 	function transferFrom(
546 		address from,
547 		address to,
548 		uint256 tokenId
549 	) external;
550 
551 	/**
552 	 * @dev Gives permission to `to` to transfer `tokenId` token to another account.
553 	 * The approval is cleared when the token is transferred.
554 	 *
555 	 * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
556 	 *
557 	 * Requirements:
558 	 *
559 	 * - The caller must own the token or be an approved operator.
560 	 * - `tokenId` must exist.
561 	 *
562 	 * Emits an {Approval} event.
563 	 */
564 	function approve(address to, uint256 tokenId) external;
565 
566 	/**
567 	 * @dev Returns the account approved for `tokenId` token.
568 	 *
569 	 * Requirements:
570 	 *
571 	 * - `tokenId` must exist.
572 	 */
573 	function getApproved(uint256 tokenId) external view returns (address operator);
574 
575 	/**
576 	 * @dev Approve or remove `operator` as an operator for the caller.
577 	 * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
578 	 *
579 	 * Requirements:
580 	 *
581 	 * - The `operator` cannot be the caller.
582 	 *
583 	 * Emits an {ApprovalForAll} event.
584 	 */
585 	function setApprovalForAll(address operator, bool _approved) external;
586 
587 	/**
588 	 * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
589 	 *
590 	 * See {setApprovalForAll}
591 	 */
592 	function isApprovedForAll(address owner, address operator) external view returns (bool);
593 
594 	/**
595 	 * @dev Safely transfers `tokenId` token from `from` to `to`.
596 	 *
597 	 * Requirements:
598 	 *
599 	 * - `from` cannot be the zero address.
600 	 * - `to` cannot be the zero address.
601 	 * - `tokenId` token must exist and be owned by `from`.
602 	 * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
603 	 * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
604 	 *
605 	 * Emits a {Transfer} event.
606 	 */
607 	function safeTransferFrom(
608 		address from,
609 		address to,
610 		uint256 tokenId,
611 		bytes calldata data
612 	) external;
613 }
614 
615 /**
616  * @dev Contract module which provides a basic access control mechanism, where
617  * there is an account (an owner) that can be granted exclusive access to
618  * specific functions.
619  *
620  * By default, the owner account will be the one that deploys the contract. This
621  * can later be changed with {transferOwnership}.
622  *
623  * This module is used through inheritance. It will make available the modifier
624  * `onlyOwner`, which can be applied to your functions to restrict their use to
625  * the owner.
626  */
627 abstract contract Ownable is Context {
628 	address private _owner;
629 
630 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
631 
632 	/**
633 	 * @dev Initializes the contract setting the deployer as the initial owner.
634 	 */
635 	constructor() {
636 		_transferOwnership(_msgSender());
637 	}
638 
639 	/**
640 	 * @dev Returns the address of the current owner.
641 	 */
642 	function owner() public view virtual returns (address) {
643 		return _owner;
644 	}
645 
646 	/**
647 	 * @dev Throws if called by any account other than the owner.
648 	 */
649 	modifier onlyOwner() {
650 		require(owner() == _msgSender(), "Ownable: caller is not the owner");
651 		_;
652 	}
653 
654 	/**
655 	 * @dev Leaves the contract without owner. It will not be possible to call
656 	 * `onlyOwner` functions anymore. Can only be called by the current owner.
657 	 *
658 	 * NOTE: Renouncing ownership will leave the contract without an owner,
659 	 * thereby removing any functionality that is only available to the owner.
660 	 */
661 	function renounceOwnership() public virtual onlyOwner {
662 		_transferOwnership(address(0));
663 	}
664 
665 	/**
666 	 * @dev Transfers ownership of the contract to a new account (`newOwner`).
667 	 * Can only be called by the current owner.
668 	 */
669 	function transferOwnership(address newOwner) public virtual onlyOwner {
670 		require(newOwner != address(0), "Ownable: new owner is the zero address");
671 		_transferOwnership(newOwner);
672 	}
673 
674 	/**
675 	 * @dev Transfers ownership of the contract to a new account (`newOwner`).
676 	 * Internal function without access restriction.
677 	 */
678 	function _transferOwnership(address newOwner) internal virtual {
679 		address oldOwner = _owner;
680 		_owner = newOwner;
681 		emit OwnershipTransferred(oldOwner, newOwner);
682 	}
683 }
684 
685 contract WastedWorld is Ownable, ReentrancyGuard {
686 	uint256 public constant SECONDS_IN_DAY = 24 * 60 * 60;
687 	uint256 public constant ACCELERATED_YIELD_DAYS = 2;
688 	uint256 public constant ACCELERATED_YIELD_MULTIPLIER = 2;
689 	uint256 public acceleratedYield;
690 
691 	address public signerAddress;
692 	address[] public authorisedLog;
693 
694 	bool public stakingLaunched;
695 	bool public depositPaused;
696 
697 	struct Staker {
698 	  uint256 currentYield;
699 	  uint256 accumulatedAmount;
700 	  uint256 lastCheckpoint;
701 	}
702 
703 	mapping(address => bool) isWWNftContract;
704 	mapping(address => mapping(address => uint256[])) stakedTokensForAddress;
705 	mapping(address => uint256) public _baseRates;
706 	mapping(address => Staker) private _stakers;
707 	mapping(address => mapping(uint256 => address)) private _ownerOfToken;
708 	mapping(address => mapping(uint256 => uint256)) private _tokensMultiplier;
709 	mapping(address => bool) private _authorised;
710 
711 	event Deposit(address indexed staker,address contractAddress,uint256 tokensAmount);
712 	event Withdraw(address indexed staker,address contractAddress,uint256 tokensAmount);
713 	event AutoDeposit(address indexed contractAddress,uint256 tokenId,address indexed owner);
714 	event WithdrawStuckERC721(address indexed receiver, address indexed tokenAddress, uint256 indexed tokenId);
715 
716 	constructor(
717 	  address _pre,
718 	  address _signer
719 	) {
720 		_baseRates[_pre] = 4200 ether;
721 		isWWNftContract[_pre] = true;
722 
723 		signerAddress = _signer;
724 	}
725 
726 	modifier authorised() {
727 	  require(_authorised[_msgSender()], "The token contract is not authorised");
728 		_;
729 	}
730 
731 	function deposit(
732 	  address contractAddress,
733 	  uint256[] memory tokenIds,
734 	  uint256[] memory tokenTraits,
735 	  bytes calldata signature
736 	) public nonReentrant {
737 	  require(!depositPaused, "Deposit paused");
738 	  require(stakingLaunched, "Staking is not launched yet");
739 	  require(
740 		contractAddress != address(0) &&
741 		isWWNftContract[contractAddress],
742 		"Unknown contract"
743 	  );
744 
745 	  if (tokenTraits.length > 0) {
746 		require(_validateSignature(
747 		  signature,
748 		  contractAddress,
749 		  tokenIds,
750 		  tokenTraits
751 		), "Invalid data provided");
752 		_setTokensValues(contractAddress, tokenIds, tokenTraits);
753 	  }
754 
755 	  Staker storage user = _stakers[_msgSender()];
756 	  uint256 newYield = user.currentYield;
757 
758 	  for (uint256 i; i < tokenIds.length; i++) {
759 		require(IERC721(contractAddress).ownerOf(tokenIds[i]) == _msgSender(), "Not the owner");
760 		IERC721(contractAddress).safeTransferFrom(_msgSender(), address(this), tokenIds[i]);
761 
762 		_ownerOfToken[contractAddress][tokenIds[i]] = _msgSender();
763 
764 		newYield += getTokenYield(contractAddress, tokenIds[i]);
765 		stakedTokensForAddress[_msgSender()][contractAddress].push(tokenIds[i]);
766 	  }
767 
768 	  accumulate(_msgSender());
769 	  user.currentYield = newYield;
770 
771 	  emit Deposit(_msgSender(), contractAddress, tokenIds.length);
772 	}
773 
774 	function withdraw(
775 	  address contractAddress,
776 	  uint256[] memory tokenIds
777 	) public nonReentrant {
778 	  require(
779 		contractAddress != address(0) &&
780 		isWWNftContract[contractAddress],
781 		"Unknown contract"
782 	  );
783 	  Staker storage user = _stakers[_msgSender()];
784 	  uint256 newYield = user.currentYield;
785 
786 	  for (uint256 i; i < tokenIds.length; i++) {
787 		require(IERC721(contractAddress).ownerOf(tokenIds[i]) == address(this), "Not the owner");
788 
789 		_ownerOfToken[contractAddress][tokenIds[i]] = address(0);
790 
791 		if (user.currentYield != 0) {
792 		  uint256 tokenYield = getTokenYield(contractAddress, tokenIds[i]);
793 		  newYield -= tokenYield;
794 		}
795 
796 		stakedTokensForAddress[_msgSender()][contractAddress] = _moveTokenInTheList(stakedTokensForAddress[_msgSender()][contractAddress], tokenIds[i]);
797 		stakedTokensForAddress[_msgSender()][contractAddress].pop();
798 
799 		IERC721(contractAddress).safeTransferFrom(address(this), _msgSender(), tokenIds[i]);
800 	  }
801 
802 	  accumulate(_msgSender());
803 	  user.currentYield = newYield;
804 
805 	  emit Withdraw(_msgSender(), contractAddress, tokenIds.length);
806 	}
807 
808 	function registerDeposit(address owner, address contractAddress, uint256 tokenId) public authorised {
809 	  require(
810 		contractAddress != address(0) &&
811 		isWWNftContract[contractAddress],
812 		"Unknown contract"
813 	  );
814 	  require(IERC721(contractAddress).ownerOf(tokenId) == address(this), "!Owner");
815 	  require(ownerOf(contractAddress, tokenId) == address(0), "Already deposited");
816 
817 	  _ownerOfToken[contractAddress][tokenId] = owner;
818 
819 	  Staker storage user = _stakers[owner];
820 	  uint256 newYield = user.currentYield;
821 
822 	  newYield += getTokenYield(contractAddress, tokenId);
823 	  stakedTokensForAddress[owner][contractAddress].push(tokenId);
824 
825 	  accumulate(owner);
826 	  user.currentYield = newYield;
827 
828 	  emit AutoDeposit(contractAddress, tokenId, _msgSender());
829 	}
830 
831 	function getAccumulatedAmount(address staker) external view returns (uint256) {
832 	  return _stakers[staker].accumulatedAmount + getCurrentReward(staker);
833 	}
834 
835 	function getTokenYield(address contractAddress, uint256 tokenId) public view returns (uint256) {
836 	  uint256 tokenYield = _tokensMultiplier[contractAddress][tokenId];
837 	  if (tokenYield == 0) { tokenYield = _baseRates[contractAddress]; }
838 
839 	  return tokenYield;
840 	}
841 
842 	function getStakerYield(address staker) public view returns (uint256) {
843 	  return _stakers[staker].currentYield;
844 	}
845 
846 	function getStakerTokens(address staker, address contractAddress) public view returns (uint256[] memory) {
847 	  return (stakedTokensForAddress[staker][contractAddress]);
848 	}
849 
850 	function isMultiplierSet(address contractAddress, uint256 tokenId) public view returns (bool) {
851 	  return _tokensMultiplier[contractAddress][tokenId] > 0;
852 	}
853 
854 	function _moveTokenInTheList(uint256[] memory list, uint256 tokenId) internal pure returns (uint256[] memory) {
855 	  uint256 tokenIndex = 0;
856 	  uint256 lastTokenIndex = list.length - 1;
857 	  uint256 length = list.length;
858 
859 	  for(uint256 i = 0; i < length; i++) {
860 		if (list[i] == tokenId) {
861 		  tokenIndex = i + 1;
862 		  break;
863 		}
864 	  }
865 	  require(tokenIndex != 0, "msg.sender is not the owner");
866 
867 	  tokenIndex -= 1;
868 
869 	  if (tokenIndex != lastTokenIndex) {
870 		list[tokenIndex] = list[lastTokenIndex];
871 		list[lastTokenIndex] = tokenId;
872 	  }
873 
874 	  return list;
875 	}
876 
877 	function _validateSignature(
878 	  bytes calldata signature,
879 	  address contractAddress,
880 	  uint256[] memory tokenIds,
881 	  uint256[] memory tokenTraits
882 	  ) internal view returns (bool) {
883 	  bytes32 dataHash = keccak256(abi.encodePacked(contractAddress, tokenIds, tokenTraits));
884 	  bytes32 message = ECDSA.toEthSignedMessageHash(dataHash);
885 
886 	  address receivedAddress = ECDSA.recover(message, signature);
887 	  return (receivedAddress != address(0) && receivedAddress == signerAddress);
888 	}
889 
890 	function _setTokensValues(
891 	  address contractAddress,
892 	  uint256[] memory tokenIds,
893 	  uint256[] memory tokenTraits
894 	) internal {
895 	  require(tokenIds.length == tokenTraits.length, "Wrong arrays provided");
896 	  for (uint256 i; i < tokenIds.length; i++) {
897 		if (tokenTraits[i] != 0 && tokenTraits[i] <= 8000 ether) {
898 		  _tokensMultiplier[contractAddress][tokenIds[i]] = tokenTraits[i];
899 		}
900 	  }
901 	}
902 
903 	function getCurrentReward(address staker) public view returns (uint256) {
904 	  Staker memory user = _stakers[staker];
905 	  if (user.lastCheckpoint == 0) { return 0; }
906 	  if (user.lastCheckpoint < acceleratedYield && block.timestamp < acceleratedYield) {
907 		return (block.timestamp - user.lastCheckpoint) * user.currentYield / SECONDS_IN_DAY * ACCELERATED_YIELD_MULTIPLIER;
908 	  }
909 	  if (user.lastCheckpoint < acceleratedYield && block.timestamp > acceleratedYield) {
910 		uint256 currentReward;
911 		currentReward += (acceleratedYield - user.lastCheckpoint) * user.currentYield / SECONDS_IN_DAY * ACCELERATED_YIELD_MULTIPLIER;
912 		currentReward += (block.timestamp - acceleratedYield) * user.currentYield / SECONDS_IN_DAY;
913 		return currentReward;
914 	  }
915 	  return (block.timestamp - user.lastCheckpoint) * user.currentYield / SECONDS_IN_DAY;
916 	}
917 
918 	function accumulate(address staker) internal {
919 	  _stakers[staker].accumulatedAmount += getCurrentReward(staker);
920 	  _stakers[staker].lastCheckpoint = block.timestamp;
921 	}
922 
923 	/**
924 	* @dev Returns token owner address (returns address(0) if token is not inside the gateway)
925 	*/
926 	function ownerOf(address contractAddress, uint256 tokenId) public view returns (address) {
927 	  return _ownerOfToken[contractAddress][tokenId];
928 	}
929 
930 	function addNFTContract(address _contract, uint256 _baseReward) public onlyOwner {
931 	  _baseRates[_contract] = _baseReward;
932 	  isWWNftContract[_contract] = true;
933 	}
934 
935 	/**
936 	* @dev Admin function to authorise the contract address
937 	*/
938 	function authorise(address toAuth) public onlyOwner {
939 	  _authorised[toAuth] = true;
940 	  authorisedLog.push(toAuth);
941 	}
942 
943 	/**
944 	* @dev Function allows admin add unauthorised address.
945 	*/
946 	function unauthorise(address addressToUnAuth) public onlyOwner {
947 	  _authorised[addressToUnAuth] = false;
948 	}
949 
950 	/**
951 	* @dev Function allows admin withdraw ERC721 in case of emergency.
952 	*/
953 	function emergencyWithdraw(address tokenAddress, uint256[] memory tokenIds) public onlyOwner {
954 	  require(tokenIds.length <= 50, "50 is max per tx");
955 	  pauseDeposit(true);
956 	  for (uint256 i; i < tokenIds.length; i++) {
957 		address receiver = _ownerOfToken[tokenAddress][tokenIds[i]];
958 		if (receiver != address(0) && IERC721(tokenAddress).ownerOf(tokenIds[i]) == address(this)) {
959 		  IERC721(tokenAddress).transferFrom(address(this), receiver, tokenIds[i]);
960 		  emit WithdrawStuckERC721(receiver, tokenAddress, tokenIds[i]);
961 		}
962 	  }
963 	}
964 
965 	/**
966 	* @dev Function allows to pause deposits if needed. Withdraw remains active.
967 	*/
968 	function pauseDeposit(bool _pause) public onlyOwner {
969 	  depositPaused = _pause;
970 	}
971 
972 	/**
973 	* @dev Function allows to pause deposits if needed. Withdraw remains active.
974 	*/
975 	function updateSignerAddress(address _signer) public onlyOwner {
976 	  signerAddress = _signer;
977 	}
978 
979 	function launchStaking() public onlyOwner {
980 	  require(!stakingLaunched, "Staking has been launched already");
981 	  stakingLaunched = true;
982 	  acceleratedYield = block.timestamp + (SECONDS_IN_DAY * ACCELERATED_YIELD_DAYS);
983 	}
984 
985 	function updateBaseYield(address _contract, uint256 _yield) public onlyOwner {
986 	  _baseRates[_contract] = _yield;
987 	}
988 
989 	function onERC721Received(address, address, uint256, bytes calldata) external pure returns(bytes4){
990 	  return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
991 	}
992 }