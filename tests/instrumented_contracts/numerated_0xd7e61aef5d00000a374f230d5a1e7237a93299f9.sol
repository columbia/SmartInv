1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /*
6 -------------
7 The SolaVerse
8 -------------
9 
10   /$$$$$$   /$$$$$$  /$$        /$$$$$$       /$$$$$$  /$$        /$$$$$$  /$$$$$$ /$$      /$$  /$$$$$$
11  /$$__  $$ /$$__  $$| $$       /$$__  $$     /$$__  $$| $$       /$$__  $$|_  $$_/| $$$    /$$$ /$$__  $$
12 | $$  \__/| $$  \ $$| $$      | $$  \ $$    | $$  \__/| $$      | $$  \ $$  | $$  | $$$$  /$$$$| $$  \__/
13 |  $$$$$$ | $$  | $$| $$      | $$$$$$$$    | $$      | $$      | $$$$$$$$  | $$  | $$ $$/$$ $$|  $$$$$$
14  \____  $$| $$  | $$| $$      | $$__  $$    | $$      | $$      | $$__  $$  | $$  | $$  $$$| $$ \____  $$
15  /$$  \ $$| $$  | $$| $$      | $$  | $$    | $$    $$| $$      | $$  | $$  | $$  | $$\  $ | $$ /$$  \ $$
16 |  $$$$$$/|  $$$$$$/| $$$$$$$$| $$  | $$    |  $$$$$$/| $$$$$$$$| $$  | $$ /$$$$$$| $$ \/  | $$|  $$$$$$/
17  \______/  \______/ |________/|__/  |__/     \______/ |________/|__/  |__/|______/|__/     |__/ \______/
18 */
19 
20 /**
21  * @dev Interface of the ERC20 standard as defined in the EIP.
22  */
23 interface ISOLA {
24 	/**
25 	 * @dev Returns the amount of tokens in existence.
26 	 */
27 	function totalSupply() external view returns (uint256);
28 
29 	/**
30 	 * @dev Returns the amount of tokens owned by `account`.
31 	 */
32 	function balanceOf(address account) external view returns (uint256);
33 
34 	/**
35 	 * @dev Moves `amount` tokens from the caller's account to `recipient`.
36 	 *
37 	 * Returns a boolean value indicating whether the operation succeeded.
38 	 *
39 	 * Emits a {Transfer} event.
40 	 * Emits a {Burnt} event.
41 	 */
42 	function transfer(address recipient, uint256 amount) external returns (bool);
43 
44 	/**
45 	 * @dev Allows our Processor wallets/contracts to transfer SOLA without
46 	 * having to burn tokens
47 	 *
48 	 * Emits a {Transfer} event.
49 	 */
50 	function processorTransfer(address recipient, uint amount) external;
51 
52 	/**
53 	 * @dev Returns the remaining number of tokens that `spender` will be
54 	 * allowed to spend on behalf of `owner` through {transferFrom}. This is
55 	 * zero by default.
56 	 *
57 	 * This value changes when {approve} or {transferFrom} are called.
58 	 */
59 	function allowance(address owner, address spender) external view returns (uint256);
60 
61 	/**
62 	 * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
63 	 *
64 	 * Returns a boolean value indicating whether the operation succeeded.
65 	 *
66 	 * IMPORTANT: Beware that changing an allowance with this method brings the risk
67 	 * that someone may use both the old and the new allowance by unfortunate
68 	 * transaction ordering. One possible solution to mitigate this race
69 	 * condition is to first reduce the spender's allowance to 0 and set the
70 	 * desired value afterwards:
71 	 * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
72 	 *
73 	 * Emits an {Approval} event.
74 	 */
75 	function approve(address spender, uint256 amount) external returns (bool);
76 
77 	/**
78 	 * @dev Moves `amount` tokens from `sender` to `recipient` using the
79 	 * allowance mechanism. `amount` is then deducted from the caller's
80 	 * allowance.
81 	 *
82 	 * Returns a boolean value indicating whether the operation succeeded.
83 	 *
84 	 * Emits a {Transfer} event.
85 	 */
86 	function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
87 
88 	/**
89 	 * @dev Emitted when `value` tokens are moved from one account (`from`) to
90 	 * another (`to`).
91 	 *
92 	 * Note that `value` may be zero.
93 	 */
94 	event Transfer(address indexed from, address indexed to, uint256 value);
95 
96 	/**
97 	 * @dev Emitted when the allowance of a `spender` for an `owner` is set by
98 	 * a call to {approve}. `value` is the new allowance.
99 	 */
100 	event Approval(address indexed owner, address indexed spender, uint256 value);
101 
102 	/**
103 	 * @dev Emitted when the burning Percentage is changed by `owner`.
104 	 */
105 	event UpdateDeflationRate(uint32 value);
106 
107 	/**
108 	 * @dev Emitted when a transfer() happens.
109 	 */
110 	event Burnt(uint256 value);
111 }
112 
113 
114 
115 
116 
117 library Strings {
118 	bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
119 
120 	/**
121 	 * @dev Converts a `uint256` to its ASCII `string` decimal representation.
122 	 */
123 	function toString(uint256 value) internal pure returns (string memory) {
124 		// Inspired by OraclizeAPI's implementation - MIT licence
125 		// https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
126 
127 		if (value == 0) {
128 			return "0";
129 		}
130 		uint256 temp = value;
131 		uint256 digits;
132 		while (temp != 0) {
133 			digits++;
134 			temp /= 10;
135 		}
136 		bytes memory buffer = new bytes(digits);
137 		while (value != 0) {
138 			digits -= 1;
139 			buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
140 			value /= 10;
141 		}
142 		return string(buffer);
143 	}
144 
145 	/**
146 	 * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
147 	 */
148 	function toHexString(uint256 value) internal pure returns (string memory) {
149 		if (value == 0) {
150 			return "0x00";
151 		}
152 		uint256 temp = value;
153 		uint256 length = 0;
154 		while (temp != 0) {
155 			length++;
156 			temp >>= 8;
157 		}
158 		return toHexString(value, length);
159 	}
160 
161 	/**
162 	 * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
163 	 */
164 	function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
165 		bytes memory buffer = new bytes(2 * length + 2);
166 		buffer[0] = "0";
167 		buffer[1] = "x";
168 		for (uint256 i = 2 * length + 1; i > 1; --i) {
169 			buffer[i] = _HEX_SYMBOLS[value & 0xf];
170 			value >>= 4;
171 		}
172 		require(value == 0, "Strings: hex length insufficient");
173 		return string(buffer);
174 	}
175 }
176 
177 
178 
179 
180 
181 library ECDSA {
182 	enum RecoverError {
183 		NoError,
184 		InvalidSignature,
185 		InvalidSignatureLength,
186 		InvalidSignatureS,
187 		InvalidSignatureV
188 	}
189 
190 	function _throwError(RecoverError error) private pure {
191 		if (error == RecoverError.NoError) {
192 			return; // no error: do nothing
193 		} else if (error == RecoverError.InvalidSignature) {
194 			revert("ECDSA: invalid signature");
195 		} else if (error == RecoverError.InvalidSignatureLength) {
196 			revert("ECDSA: invalid signature length");
197 		} else if (error == RecoverError.InvalidSignatureS) {
198 			revert("ECDSA: invalid signature 's' value");
199 		} else if (error == RecoverError.InvalidSignatureV) {
200 			revert("ECDSA: invalid signature 'v' value");
201 		}
202 	}
203 
204 	/**
205 	 * @dev Returns the address that signed a hashed message (`hash`) with
206 	 * `signature` or error string. This address can then be used for verification purposes.
207 	 *
208 	 * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
209 	 * this function rejects them by requiring the `s` value to be in the lower
210 	 * half order, and the `v` value to be either 27 or 28.
211 	 *
212 	 * IMPORTANT: `hash` _must_ be the result of a hash operation for the
213 	 * verification to be secure: it is possible to craft signatures that
214 	 * recover to arbitrary addresses for non-hashed data. A safe way to ensure
215 	 * this is by receiving a hash of the original message (which may otherwise
216 	 * be too long), and then calling {toEthSignedMessageHash} on it.
217 	 *
218 	 * Documentation for signature generation:
219 	 * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
220 	 * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
221 	 *
222 	 * _Available since v4.3._
223 	 */
224 	function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
225 		// Check the signature length
226 		// - case 65: r,s,v signature (standard)
227 		// - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
228 		if (signature.length == 65) {
229 			bytes32 r;
230 			bytes32 s;
231 			uint8 v;
232 			// ecrecover takes the signature parameters, and the only way to get them
233 			// currently is to use assembly.
234 			assembly {
235 				r := mload(add(signature, 0x20))
236 				s := mload(add(signature, 0x40))
237 				v := byte(0, mload(add(signature, 0x60)))
238 			}
239 			return tryRecover(hash, v, r, s);
240 		} else if (signature.length == 64) {
241 			bytes32 r;
242 			bytes32 vs;
243 			// ecrecover takes the signature parameters, and the only way to get them
244 			// currently is to use assembly.
245 			assembly {
246 				r := mload(add(signature, 0x20))
247 				vs := mload(add(signature, 0x40))
248 			}
249 			return tryRecover(hash, r, vs);
250 		} else {
251 			return (address(0), RecoverError.InvalidSignatureLength);
252 		}
253 	}
254 
255 	/**
256 	 * @dev Returns the address that signed a hashed message (`hash`) with
257 	 * `signature`. This address can then be used for verification purposes.
258 	 *
259 	 * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
260 	 * this function rejects them by requiring the `s` value to be in the lower
261 	 * half order, and the `v` value to be either 27 or 28.
262 	 *
263 	 * IMPORTANT: `hash` _must_ be the result of a hash operation for the
264 	 * verification to be secure: it is possible to craft signatures that
265 	 * recover to arbitrary addresses for non-hashed data. A safe way to ensure
266 	 * this is by receiving a hash of the original message (which may otherwise
267 	 * be too long), and then calling {toEthSignedMessageHash} on it.
268 	 */
269 	function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
270 		(address recovered, RecoverError error) = tryRecover(hash, signature);
271 		_throwError(error);
272 		return recovered;
273 	}
274 
275 	/**
276 	 * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
277 	 *
278 	 * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
279 	 *
280 	 * _Available since v4.3._
281 	 */
282 	function tryRecover(
283 		bytes32 hash,
284 		bytes32 r,
285 		bytes32 vs
286 	) internal pure returns (address, RecoverError) {
287 		bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
288 		uint8 v = uint8((uint256(vs) >> 255) + 27);
289 		return tryRecover(hash, v, r, s);
290 	}
291 
292 	/**
293 	 * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
294 	 *
295 	 * _Available since v4.2._
296 	 */
297 	function recover(
298 		bytes32 hash,
299 		bytes32 r,
300 		bytes32 vs
301 	) internal pure returns (address) {
302 		(address recovered, RecoverError error) = tryRecover(hash, r, vs);
303 		_throwError(error);
304 		return recovered;
305 	}
306 
307 	/**
308 	 * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
309 	 * `r` and `s` signature fields separately.
310 	 *
311 	 * _Available since v4.3._
312 	 */
313 	function tryRecover(
314 		bytes32 hash,
315 		uint8 v,
316 		bytes32 r,
317 		bytes32 s
318 	) internal pure returns (address, RecoverError) {
319 		// EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
320 		// unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
321 		// the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
322 		// signatures from current libraries generate a unique signature with an s-value in the lower half order.
323 		//
324 		// If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
325 		// with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
326 		// vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
327 		// these malleable signatures as well.
328 		if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
329 			return (address(0), RecoverError.InvalidSignatureS);
330 		}
331 		if (v != 27 && v != 28) {
332 			return (address(0), RecoverError.InvalidSignatureV);
333 		}
334 
335 		// If the signature is valid (and not malleable), return the signer address
336 		address signer = ecrecover(hash, v, r, s);
337 		if (signer == address(0)) {
338 			return (address(0), RecoverError.InvalidSignature);
339 		}
340 
341 		return (signer, RecoverError.NoError);
342 	}
343 
344 	/**
345 	 * @dev Overload of {ECDSA-recover} that receives the `v`,
346 	 * `r` and `s` signature fields separately.
347 	 */
348 	function recover(
349 		bytes32 hash,
350 		uint8 v,
351 		bytes32 r,
352 		bytes32 s
353 	) internal pure returns (address) {
354 		(address recovered, RecoverError error) = tryRecover(hash, v, r, s);
355 		_throwError(error);
356 		return recovered;
357 	}
358 
359 	/**
360 	 * @dev Returns an Ethereum Signed Message, created from a `hash`. This
361 	 * produces hash corresponding to the one signed with the
362 	 * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
363 	 * JSON-RPC method as part of EIP-191.
364 	 *
365 	 * See {recover}.
366 	 */
367 	function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
368 		// 32 is the length in bytes of hash,
369 		// enforced by the type signature above
370 		return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
371 	}
372 
373 	/**
374 	 * @dev Returns an Ethereum Signed Message, created from `s`. This
375 	 * produces hash corresponding to the one signed with the
376 	 * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
377 	 * JSON-RPC method as part of EIP-191.
378 	 *
379 	 * See {recover}.
380 	 */
381 	function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
382 		return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
383 	}
384 
385 	/**
386 	 * @dev Returns an Ethereum Signed Typed Data, created from a
387 	 * `domainSeparator` and a `structHash`. This produces hash corresponding
388 	 * to the one signed with the
389 	 * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
390 	 * JSON-RPC method as part of EIP-712.
391 	 *
392 	 * See {recover}.
393 	 */
394 	function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
395 		return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
396 	}
397 }
398 
399 
400 
401 
402 
403 abstract contract ReentrancyGuard {
404 	// Booleans are more expensive than uint256 or any type that takes up a full
405 	// word because each write operation emits an extra SLOAD to first read the
406 	// slot's contents, replace the bits taken up by the boolean, and then write
407 	// back. This is the compiler's defense against contract upgrades and
408 	// pointer aliasing, and it cannot be disabled.
409 
410 	// The values being non-zero value makes deployment a bit more expensive,
411 	// but in exchange the refund on every call to nonReentrant will be lower in
412 	// amount. Since refunds are capped to a percentage of the total
413 	// transaction's gas, it is best to keep them low in cases like this one, to
414 	// increase the likelihood of the full refund coming into effect.
415 	uint256 private constant _NOT_ENTERED = 1;
416 	uint256 private constant _ENTERED = 2;
417 
418 	uint256 private _status;
419 
420 	constructor() {
421 		_status = _NOT_ENTERED;
422 	}
423 
424 	/**
425 	 * @dev Prevents a contract from calling itself, directly or indirectly.
426 	 * Calling a `nonReentrant` function from another `nonReentrant`
427 	 * function is not supported. It is possible to prevent this from happening
428 	 * by making the `nonReentrant` function external, and making it call a
429 	 * `private` function that does the actual work.
430 	 */
431 	modifier nonReentrant() {
432 		// On the first call to nonReentrant, _notEntered will be true
433 		require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
434 
435 		// Any calls to nonReentrant after this point will fail
436 		_status = _ENTERED;
437 
438 		_;
439 
440 		// By storing the original value once again, a refund is triggered (see
441 		// https://eips.ethereum.org/EIPS/eip-2200)
442 		_status = _NOT_ENTERED;
443 	}
444 }
445 
446 
447 
448 
449 
450 abstract contract Context {
451 	function _msgSender() internal view virtual returns (address) {
452 		return msg.sender;
453 	}
454 
455 	function _msgData() internal view virtual returns (bytes calldata) {
456 		return msg.data;
457 	}
458 }
459 
460 
461 
462 
463 
464 abstract contract Ownable is Context {
465 	address private _owner;
466 
467 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
468 
469 	/**
470 	 * @dev Initializes the contract setting the deployer as the initial owner.
471 	 */
472 	constructor() {
473 		_transferOwnership(_msgSender());
474 	}
475 
476 	/**
477 	 * @dev Returns the address of the current owner.
478 	 */
479 	function owner() public view virtual returns (address) {
480 		return _owner;
481 	}
482 
483 	/**
484 	 * @dev Throws if called by any account other than the owner.
485 	 */
486 	modifier onlyOwner() {
487 		require(owner() == _msgSender(), "Ownable: caller is not the owner");
488 		_;
489 	}
490 
491 	/**
492 	 * @dev Leaves the contract without owner. It will not be possible to call
493 	 * `onlyOwner` functions anymore. Can only be called by the current owner.
494 	 *
495 	 * NOTE: Renouncing ownership will leave the contract without an owner,
496 	 * thereby removing any functionality that is only available to the owner.
497 	 */
498 	function renounceOwnership() public virtual onlyOwner {
499 		_transferOwnership(address(0));
500 	}
501 
502 	/**
503 	 * @dev Transfers ownership of the contract to a new account (`newOwner`).
504 	 * Can only be called by the current owner.
505 	 */
506 	function transferOwnership(address newOwner) public virtual onlyOwner {
507 		require(newOwner != address(0), "Ownable: new owner is the zero address");
508 		_transferOwnership(newOwner);
509 	}
510 
511 	/**
512 	 * @dev Transfers ownership of the contract to a new account (`newOwner`).
513 	 * Internal function without access restriction.
514 	 */
515 	function _transferOwnership(address newOwner) internal virtual {
516 		address oldOwner = _owner;
517 		_owner = newOwner;
518 		emit OwnershipTransferred(oldOwner, newOwner);
519 	}
520 }
521 
522 
523 
524 
525 
526 contract Pausable is Ownable {
527 	event Pause();
528 	event Unpause();
529 
530 	bool public paused = false;
531 
532 
533 	/**
534 	* @dev Modifier to make a function callable only when the contract is not paused.
535 	*/
536 	modifier whenNotPaused() {
537 		require(!paused);
538 		_;
539 	}
540 
541 	/**
542 	* @dev Modifier to make a function callable only when the contract is paused.
543 	*/
544 	modifier whenPaused() {
545 		require(paused);
546 		_;
547 	}
548 
549 	/**
550 	* @dev called by the owner to pause, triggers stopped state
551 	*/
552 	function pause() onlyOwner whenNotPaused public {
553 		paused = true;
554 		emit Pause();
555 	}
556 
557 	/**
558 	* @dev called by the owner to unpause, returns to normal state
559 	*/
560 	function unpause() onlyOwner whenPaused public {
561 		paused = false;
562 		emit Unpause();
563 	}
564 }
565 
566 
567 
568 
569 
570 contract SOLA_Claims is ReentrancyGuard, Ownable, Pausable
571 {
572 	address solaTokenAddress;
573 	address encryptionWalletAddress;
574 	uint256 maxClaimAmount;
575 
576 	mapping(bytes => bool) verifiedHashes;
577 
578 	event ClaimSuccess(address _address, bytes32 hash);
579 
580 
581 	/**
582 	 * @dev Allow users to claim their Account Balance in SOLA Tokens.
583 	 *
584 	 * Emits a {ClaimSuccess} event indicating the successful claim.
585 	 *
586 	 * Requirements:
587 	 *
588 	 * - `msg.sender` cannot be the zero address.
589 	 * - `_expires_at` isn't in the past.
590 	 * - `solaTokenAddress` cannot be the zero address.
591 	 * - `encryptionWalletAddress` cannot be the zero address.
592 	 * - `this` contract must have the `solaToken` funds available to send.
593 	 * - `maxClaimAmount` must be set.
594 	 * - `_amount` must be an actual positive value.
595 	 * - `_amount` is less than the current `maxClaimAmount` limit.
596 	 * - `_signature` has not already been used and stored in the `verifiedHashes` mapping.
597 	 * - `_hash` was signed by the processor_wallet to create the valid `_signature`.
598 	 * - `msg.sender` is not the address of a contract.
599 	 * - All the data hash together corretly to form the signature.
600 	 */
601 	function claim(uint _amount, uint _expires_at, string memory _sender, bytes memory _signature) external nonReentrant whenNotPaused
602 	{
603 		require(msg.sender != address(0), "SOLA: sending to the zero address.");
604 		require(_expires_at > block.timestamp, "SOLA: claim token expired.");
605 		require(solaTokenAddress != address(0), "SOLA: token address not set.");
606 		require(encryptionWalletAddress != address(0),  "SOLA: processor wallet address not set.");
607 
608 		ISOLA SOLA = ISOLA(solaTokenAddress);
609 		require(SOLA.balanceOf(address(this)) > _amount, "SOLA: insufficient balance to claim.");
610 
611 		require(_amount > 0, "SOLA: claim amount too low.");
612 		require(maxClaimAmount > 0, "SOLA: max claim amount not set.");
613 		require(maxClaimAmount >= _amount, "SOLA: claim amount too high.");
614 		require(verifiedHashes[_signature] != true, "SOLA: invalid request - already used.");
615 		require(this.checkAddress(msg.sender) != true, "SOLA: invalid wallet address.");
616 
617 		bytes32 hash = keccak256(abi.encodePacked(Strings.toString(_amount), Strings.toString(_expires_at), _sender));
618 		require(ECDSA.recover(hash, _signature) == encryptionWalletAddress, "SOLA: invalid signature.");
619 
620 		verifiedHashes[_signature] = true;
621 
622 		SOLA.processorTransfer(msg.sender, _amount);
623 
624 		emit ClaimSuccess(msg.sender, hash);
625 	}
626 
627 
628 	/**
629 	 * @dev Check to ensure the call is coming from a wallet and not a contract address.
630 	 *
631 	 * Returns boolean
632 	 */
633 	function checkAddress(address _address) external view returns (bool)
634 	{
635 		return isContract(_address);
636 	}
637 
638 
639 	/**
640 	 * @dev Check to ensure the call is coming from a wallet and not a contract address.
641 	 *
642 	 * Returns boolean
643 	 */
644 	function isContract(address _address) private view returns (bool)
645 	{
646 		uint32 size;
647 		assembly {
648 			size := extcodesize(_address)
649 		}
650 		return (size > 0);
651 	}
652 
653 
654 	/**
655 	 * @dev Set the address of the Sola Token Contract.
656 	 */
657 	function setSolaTokenAddress(address _address) external onlyOwner
658 	{
659 		solaTokenAddress = _address;
660 	}
661 
662 
663 	/**
664 	 * @dev Set the address of the Processing wallet for the ECDSA recovery.
665 	 */
666 	function setEncryptionWalletAddress(address _address) external onlyOwner
667 	{
668 		encryptionWalletAddress = _address;
669 	}
670 
671 
672 	/**
673 	 * @dev Set an adjustable max limit on claims.
674 	 */
675 	function setMaxClaimAmount(uint _amount) external onlyOwner
676 	{
677 		maxClaimAmount = _amount;
678 	}
679 }