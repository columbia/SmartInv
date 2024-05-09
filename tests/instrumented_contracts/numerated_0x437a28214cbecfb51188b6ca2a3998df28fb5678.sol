1 // Sources flattened with hardhat v2.8.0 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.4.1
4 
5 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(
67         address sender,
68         address recipient,
69         uint256 amount
70     ) external returns (bool);
71 
72     /**
73      * @dev Emitted when `value` tokens are moved from one account (`from`) to
74      * another (`to`).
75      *
76      * Note that `value` may be zero.
77      */
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     /**
81      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
82      * a call to {approve}. `value` is the new allowance.
83      */
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 
88 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.4.1
89 
90 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
91 
92 pragma solidity ^0.8.0;
93 
94 /**
95  * @dev Contract module that helps prevent reentrant calls to a function.
96  *
97  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
98  * available, which can be applied to functions to make sure there are no nested
99  * (reentrant) calls to them.
100  *
101  * Note that because there is a single `nonReentrant` guard, functions marked as
102  * `nonReentrant` may not call one another. This can be worked around by making
103  * those functions `private`, and then adding `external` `nonReentrant` entry
104  * points to them.
105  *
106  * TIP: If you would like to learn more about reentrancy and alternative ways
107  * to protect against it, check out our blog post
108  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
109  */
110 abstract contract ReentrancyGuard {
111     // Booleans are more expensive than uint256 or any type that takes up a full
112     // word because each write operation emits an extra SLOAD to first read the
113     // slot's contents, replace the bits taken up by the boolean, and then write
114     // back. This is the compiler's defense against contract upgrades and
115     // pointer aliasing, and it cannot be disabled.
116 
117     // The values being non-zero value makes deployment a bit more expensive,
118     // but in exchange the refund on every call to nonReentrant will be lower in
119     // amount. Since refunds are capped to a percentage of the total
120     // transaction's gas, it is best to keep them low in cases like this one, to
121     // increase the likelihood of the full refund coming into effect.
122     uint256 private constant _NOT_ENTERED = 1;
123     uint256 private constant _ENTERED = 2;
124 
125     uint256 private _status;
126 
127     constructor() {
128         _status = _NOT_ENTERED;
129     }
130 
131     /**
132      * @dev Prevents a contract from calling itself, directly or indirectly.
133      * Calling a `nonReentrant` function from another `nonReentrant`
134      * function is not supported. It is possible to prevent this from happening
135      * by making the `nonReentrant` function external, and making it call a
136      * `private` function that does the actual work.
137      */
138     modifier nonReentrant() {
139         // On the first call to nonReentrant, _notEntered will be true
140         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
141 
142         // Any calls to nonReentrant after this point will fail
143         _status = _ENTERED;
144 
145         _;
146 
147         // By storing the original value once again, a refund is triggered (see
148         // https://eips.ethereum.org/EIPS/eip-2200)
149         _status = _NOT_ENTERED;
150     }
151 }
152 
153 
154 // File @openzeppelin/contracts/utils/Context.sol@v4.4.1
155 
156 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
157 
158 pragma solidity ^0.8.0;
159 
160 /**
161  * @dev Provides information about the current execution context, including the
162  * sender of the transaction and its data. While these are generally available
163  * via msg.sender and msg.data, they should not be accessed in such a direct
164  * manner, since when dealing with meta-transactions the account sending and
165  * paying for execution may not be the actual sender (as far as an application
166  * is concerned).
167  *
168  * This contract is only required for intermediate, library-like contracts.
169  */
170 abstract contract Context {
171     function _msgSender() internal view virtual returns (address) {
172         return msg.sender;
173     }
174 
175     function _msgData() internal view virtual returns (bytes calldata) {
176         return msg.data;
177     }
178 }
179 
180 
181 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.1
182 
183 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
184 
185 pragma solidity ^0.8.0;
186 
187 /**
188  * @dev Contract module which provides a basic access control mechanism, where
189  * there is an account (an owner) that can be granted exclusive access to
190  * specific functions.
191  *
192  * By default, the owner account will be the one that deploys the contract. This
193  * can later be changed with {transferOwnership}.
194  *
195  * This module is used through inheritance. It will make available the modifier
196  * `onlyOwner`, which can be applied to your functions to restrict their use to
197  * the owner.
198  */
199 abstract contract Ownable is Context {
200     address private _owner;
201 
202     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
203 
204     /**
205      * @dev Initializes the contract setting the deployer as the initial owner.
206      */
207     constructor() {
208         _transferOwnership(_msgSender());
209     }
210 
211     /**
212      * @dev Returns the address of the current owner.
213      */
214     function owner() public view virtual returns (address) {
215         return _owner;
216     }
217 
218     /**
219      * @dev Throws if called by any account other than the owner.
220      */
221     modifier onlyOwner() {
222         require(owner() == _msgSender(), "Ownable: caller is not the owner");
223         _;
224     }
225 
226     /**
227      * @dev Leaves the contract without owner. It will not be possible to call
228      * `onlyOwner` functions anymore. Can only be called by the current owner.
229      *
230      * NOTE: Renouncing ownership will leave the contract without an owner,
231      * thereby removing any functionality that is only available to the owner.
232      */
233     function renounceOwnership() public virtual onlyOwner {
234         _transferOwnership(address(0));
235     }
236 
237     /**
238      * @dev Transfers ownership of the contract to a new account (`newOwner`).
239      * Can only be called by the current owner.
240      */
241     function transferOwnership(address newOwner) public virtual onlyOwner {
242         require(newOwner != address(0), "Ownable: new owner is the zero address");
243         _transferOwnership(newOwner);
244     }
245 
246     /**
247      * @dev Transfers ownership of the contract to a new account (`newOwner`).
248      * Internal function without access restriction.
249      */
250     function _transferOwnership(address newOwner) internal virtual {
251         address oldOwner = _owner;
252         _owner = newOwner;
253         emit OwnershipTransferred(oldOwner, newOwner);
254     }
255 }
256 
257 
258 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.4.1
259 
260 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
261 
262 pragma solidity ^0.8.0;
263 
264 /**
265  * @dev These functions deal with verification of Merkle Trees proofs.
266  *
267  * The proofs can be generated using the JavaScript library
268  * https://github.com/miguelmota/merkletreejs[merkletreejs].
269  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
270  *
271  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
272  */
273 library MerkleProof {
274     /**
275      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
276      * defined by `root`. For this, a `proof` must be provided, containing
277      * sibling hashes on the branch from the leaf to the root of the tree. Each
278      * pair of leaves and each pair of pre-images are assumed to be sorted.
279      */
280     function verify(
281         bytes32[] memory proof,
282         bytes32 root,
283         bytes32 leaf
284     ) internal pure returns (bool) {
285         return processProof(proof, leaf) == root;
286     }
287 
288     /**
289      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
290      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
291      * hash matches the root of the tree. When processing the proof, the pairs
292      * of leafs & pre-images are assumed to be sorted.
293      *
294      * _Available since v4.4._
295      */
296     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
297         bytes32 computedHash = leaf;
298         for (uint256 i = 0; i < proof.length; i++) {
299             bytes32 proofElement = proof[i];
300             if (computedHash <= proofElement) {
301                 // Hash(current computed hash + current element of the proof)
302                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
303             } else {
304                 // Hash(current element of the proof + current computed hash)
305                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
306             }
307         }
308         return computedHash;
309     }
310 }
311 
312 
313 // File hardhat/console.sol@v2.8.0
314 
315 pragma solidity >= 0.4.22 <0.9.0;
316 
317 library console {
318 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
319 
320 	function _sendLogPayload(bytes memory payload) private view {
321 		uint256 payloadLength = payload.length;
322 		address consoleAddress = CONSOLE_ADDRESS;
323 		assembly {
324 			let payloadStart := add(payload, 32)
325 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
326 		}
327 	}
328 
329 	function log() internal view {
330 		_sendLogPayload(abi.encodeWithSignature("log()"));
331 	}
332 
333 	function logInt(int p0) internal view {
334 		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
335 	}
336 
337 	function logUint(uint p0) internal view {
338 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
339 	}
340 
341 	function logString(string memory p0) internal view {
342 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
343 	}
344 
345 	function logBool(bool p0) internal view {
346 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
347 	}
348 
349 	function logAddress(address p0) internal view {
350 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
351 	}
352 
353 	function logBytes(bytes memory p0) internal view {
354 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
355 	}
356 
357 	function logBytes1(bytes1 p0) internal view {
358 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
359 	}
360 
361 	function logBytes2(bytes2 p0) internal view {
362 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
363 	}
364 
365 	function logBytes3(bytes3 p0) internal view {
366 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
367 	}
368 
369 	function logBytes4(bytes4 p0) internal view {
370 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
371 	}
372 
373 	function logBytes5(bytes5 p0) internal view {
374 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
375 	}
376 
377 	function logBytes6(bytes6 p0) internal view {
378 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
379 	}
380 
381 	function logBytes7(bytes7 p0) internal view {
382 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
383 	}
384 
385 	function logBytes8(bytes8 p0) internal view {
386 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
387 	}
388 
389 	function logBytes9(bytes9 p0) internal view {
390 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
391 	}
392 
393 	function logBytes10(bytes10 p0) internal view {
394 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
395 	}
396 
397 	function logBytes11(bytes11 p0) internal view {
398 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
399 	}
400 
401 	function logBytes12(bytes12 p0) internal view {
402 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
403 	}
404 
405 	function logBytes13(bytes13 p0) internal view {
406 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
407 	}
408 
409 	function logBytes14(bytes14 p0) internal view {
410 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
411 	}
412 
413 	function logBytes15(bytes15 p0) internal view {
414 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
415 	}
416 
417 	function logBytes16(bytes16 p0) internal view {
418 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
419 	}
420 
421 	function logBytes17(bytes17 p0) internal view {
422 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
423 	}
424 
425 	function logBytes18(bytes18 p0) internal view {
426 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
427 	}
428 
429 	function logBytes19(bytes19 p0) internal view {
430 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
431 	}
432 
433 	function logBytes20(bytes20 p0) internal view {
434 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
435 	}
436 
437 	function logBytes21(bytes21 p0) internal view {
438 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
439 	}
440 
441 	function logBytes22(bytes22 p0) internal view {
442 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
443 	}
444 
445 	function logBytes23(bytes23 p0) internal view {
446 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
447 	}
448 
449 	function logBytes24(bytes24 p0) internal view {
450 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
451 	}
452 
453 	function logBytes25(bytes25 p0) internal view {
454 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
455 	}
456 
457 	function logBytes26(bytes26 p0) internal view {
458 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
459 	}
460 
461 	function logBytes27(bytes27 p0) internal view {
462 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
463 	}
464 
465 	function logBytes28(bytes28 p0) internal view {
466 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
467 	}
468 
469 	function logBytes29(bytes29 p0) internal view {
470 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
471 	}
472 
473 	function logBytes30(bytes30 p0) internal view {
474 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
475 	}
476 
477 	function logBytes31(bytes31 p0) internal view {
478 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
479 	}
480 
481 	function logBytes32(bytes32 p0) internal view {
482 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
483 	}
484 
485 	function log(uint p0) internal view {
486 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
487 	}
488 
489 	function log(string memory p0) internal view {
490 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
491 	}
492 
493 	function log(bool p0) internal view {
494 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
495 	}
496 
497 	function log(address p0) internal view {
498 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
499 	}
500 
501 	function log(uint p0, uint p1) internal view {
502 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
503 	}
504 
505 	function log(uint p0, string memory p1) internal view {
506 		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
507 	}
508 
509 	function log(uint p0, bool p1) internal view {
510 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
511 	}
512 
513 	function log(uint p0, address p1) internal view {
514 		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
515 	}
516 
517 	function log(string memory p0, uint p1) internal view {
518 		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
519 	}
520 
521 	function log(string memory p0, string memory p1) internal view {
522 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
523 	}
524 
525 	function log(string memory p0, bool p1) internal view {
526 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
527 	}
528 
529 	function log(string memory p0, address p1) internal view {
530 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
531 	}
532 
533 	function log(bool p0, uint p1) internal view {
534 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
535 	}
536 
537 	function log(bool p0, string memory p1) internal view {
538 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
539 	}
540 
541 	function log(bool p0, bool p1) internal view {
542 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
543 	}
544 
545 	function log(bool p0, address p1) internal view {
546 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
547 	}
548 
549 	function log(address p0, uint p1) internal view {
550 		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
551 	}
552 
553 	function log(address p0, string memory p1) internal view {
554 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
555 	}
556 
557 	function log(address p0, bool p1) internal view {
558 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
559 	}
560 
561 	function log(address p0, address p1) internal view {
562 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
563 	}
564 
565 	function log(uint p0, uint p1, uint p2) internal view {
566 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
567 	}
568 
569 	function log(uint p0, uint p1, string memory p2) internal view {
570 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
571 	}
572 
573 	function log(uint p0, uint p1, bool p2) internal view {
574 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
575 	}
576 
577 	function log(uint p0, uint p1, address p2) internal view {
578 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
579 	}
580 
581 	function log(uint p0, string memory p1, uint p2) internal view {
582 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
583 	}
584 
585 	function log(uint p0, string memory p1, string memory p2) internal view {
586 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
587 	}
588 
589 	function log(uint p0, string memory p1, bool p2) internal view {
590 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
591 	}
592 
593 	function log(uint p0, string memory p1, address p2) internal view {
594 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
595 	}
596 
597 	function log(uint p0, bool p1, uint p2) internal view {
598 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
599 	}
600 
601 	function log(uint p0, bool p1, string memory p2) internal view {
602 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
603 	}
604 
605 	function log(uint p0, bool p1, bool p2) internal view {
606 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
607 	}
608 
609 	function log(uint p0, bool p1, address p2) internal view {
610 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
611 	}
612 
613 	function log(uint p0, address p1, uint p2) internal view {
614 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
615 	}
616 
617 	function log(uint p0, address p1, string memory p2) internal view {
618 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
619 	}
620 
621 	function log(uint p0, address p1, bool p2) internal view {
622 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
623 	}
624 
625 	function log(uint p0, address p1, address p2) internal view {
626 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
627 	}
628 
629 	function log(string memory p0, uint p1, uint p2) internal view {
630 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
631 	}
632 
633 	function log(string memory p0, uint p1, string memory p2) internal view {
634 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
635 	}
636 
637 	function log(string memory p0, uint p1, bool p2) internal view {
638 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
639 	}
640 
641 	function log(string memory p0, uint p1, address p2) internal view {
642 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
643 	}
644 
645 	function log(string memory p0, string memory p1, uint p2) internal view {
646 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
647 	}
648 
649 	function log(string memory p0, string memory p1, string memory p2) internal view {
650 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
651 	}
652 
653 	function log(string memory p0, string memory p1, bool p2) internal view {
654 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
655 	}
656 
657 	function log(string memory p0, string memory p1, address p2) internal view {
658 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
659 	}
660 
661 	function log(string memory p0, bool p1, uint p2) internal view {
662 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
663 	}
664 
665 	function log(string memory p0, bool p1, string memory p2) internal view {
666 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
667 	}
668 
669 	function log(string memory p0, bool p1, bool p2) internal view {
670 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
671 	}
672 
673 	function log(string memory p0, bool p1, address p2) internal view {
674 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
675 	}
676 
677 	function log(string memory p0, address p1, uint p2) internal view {
678 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
679 	}
680 
681 	function log(string memory p0, address p1, string memory p2) internal view {
682 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
683 	}
684 
685 	function log(string memory p0, address p1, bool p2) internal view {
686 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
687 	}
688 
689 	function log(string memory p0, address p1, address p2) internal view {
690 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
691 	}
692 
693 	function log(bool p0, uint p1, uint p2) internal view {
694 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
695 	}
696 
697 	function log(bool p0, uint p1, string memory p2) internal view {
698 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
699 	}
700 
701 	function log(bool p0, uint p1, bool p2) internal view {
702 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
703 	}
704 
705 	function log(bool p0, uint p1, address p2) internal view {
706 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
707 	}
708 
709 	function log(bool p0, string memory p1, uint p2) internal view {
710 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
711 	}
712 
713 	function log(bool p0, string memory p1, string memory p2) internal view {
714 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
715 	}
716 
717 	function log(bool p0, string memory p1, bool p2) internal view {
718 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
719 	}
720 
721 	function log(bool p0, string memory p1, address p2) internal view {
722 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
723 	}
724 
725 	function log(bool p0, bool p1, uint p2) internal view {
726 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
727 	}
728 
729 	function log(bool p0, bool p1, string memory p2) internal view {
730 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
731 	}
732 
733 	function log(bool p0, bool p1, bool p2) internal view {
734 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
735 	}
736 
737 	function log(bool p0, bool p1, address p2) internal view {
738 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
739 	}
740 
741 	function log(bool p0, address p1, uint p2) internal view {
742 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
743 	}
744 
745 	function log(bool p0, address p1, string memory p2) internal view {
746 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
747 	}
748 
749 	function log(bool p0, address p1, bool p2) internal view {
750 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
751 	}
752 
753 	function log(bool p0, address p1, address p2) internal view {
754 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
755 	}
756 
757 	function log(address p0, uint p1, uint p2) internal view {
758 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
759 	}
760 
761 	function log(address p0, uint p1, string memory p2) internal view {
762 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
763 	}
764 
765 	function log(address p0, uint p1, bool p2) internal view {
766 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
767 	}
768 
769 	function log(address p0, uint p1, address p2) internal view {
770 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
771 	}
772 
773 	function log(address p0, string memory p1, uint p2) internal view {
774 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
775 	}
776 
777 	function log(address p0, string memory p1, string memory p2) internal view {
778 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
779 	}
780 
781 	function log(address p0, string memory p1, bool p2) internal view {
782 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
783 	}
784 
785 	function log(address p0, string memory p1, address p2) internal view {
786 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
787 	}
788 
789 	function log(address p0, bool p1, uint p2) internal view {
790 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
791 	}
792 
793 	function log(address p0, bool p1, string memory p2) internal view {
794 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
795 	}
796 
797 	function log(address p0, bool p1, bool p2) internal view {
798 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
799 	}
800 
801 	function log(address p0, bool p1, address p2) internal view {
802 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
803 	}
804 
805 	function log(address p0, address p1, uint p2) internal view {
806 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
807 	}
808 
809 	function log(address p0, address p1, string memory p2) internal view {
810 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
811 	}
812 
813 	function log(address p0, address p1, bool p2) internal view {
814 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
815 	}
816 
817 	function log(address p0, address p1, address p2) internal view {
818 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
819 	}
820 
821 	function log(uint p0, uint p1, uint p2, uint p3) internal view {
822 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
823 	}
824 
825 	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
826 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
827 	}
828 
829 	function log(uint p0, uint p1, uint p2, bool p3) internal view {
830 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
831 	}
832 
833 	function log(uint p0, uint p1, uint p2, address p3) internal view {
834 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
835 	}
836 
837 	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
838 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
839 	}
840 
841 	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
842 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
843 	}
844 
845 	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
846 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
847 	}
848 
849 	function log(uint p0, uint p1, string memory p2, address p3) internal view {
850 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
851 	}
852 
853 	function log(uint p0, uint p1, bool p2, uint p3) internal view {
854 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
855 	}
856 
857 	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
858 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
859 	}
860 
861 	function log(uint p0, uint p1, bool p2, bool p3) internal view {
862 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
863 	}
864 
865 	function log(uint p0, uint p1, bool p2, address p3) internal view {
866 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
867 	}
868 
869 	function log(uint p0, uint p1, address p2, uint p3) internal view {
870 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
871 	}
872 
873 	function log(uint p0, uint p1, address p2, string memory p3) internal view {
874 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
875 	}
876 
877 	function log(uint p0, uint p1, address p2, bool p3) internal view {
878 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
879 	}
880 
881 	function log(uint p0, uint p1, address p2, address p3) internal view {
882 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
883 	}
884 
885 	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
886 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
887 	}
888 
889 	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
890 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
891 	}
892 
893 	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
894 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
895 	}
896 
897 	function log(uint p0, string memory p1, uint p2, address p3) internal view {
898 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
899 	}
900 
901 	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
902 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
903 	}
904 
905 	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
906 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
907 	}
908 
909 	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
910 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
911 	}
912 
913 	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
914 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
915 	}
916 
917 	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
918 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
919 	}
920 
921 	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
922 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
923 	}
924 
925 	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
926 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
927 	}
928 
929 	function log(uint p0, string memory p1, bool p2, address p3) internal view {
930 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
931 	}
932 
933 	function log(uint p0, string memory p1, address p2, uint p3) internal view {
934 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
935 	}
936 
937 	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
938 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
939 	}
940 
941 	function log(uint p0, string memory p1, address p2, bool p3) internal view {
942 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
943 	}
944 
945 	function log(uint p0, string memory p1, address p2, address p3) internal view {
946 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
947 	}
948 
949 	function log(uint p0, bool p1, uint p2, uint p3) internal view {
950 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
951 	}
952 
953 	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
954 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
955 	}
956 
957 	function log(uint p0, bool p1, uint p2, bool p3) internal view {
958 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
959 	}
960 
961 	function log(uint p0, bool p1, uint p2, address p3) internal view {
962 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
963 	}
964 
965 	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
966 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
967 	}
968 
969 	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
970 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
971 	}
972 
973 	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
974 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
975 	}
976 
977 	function log(uint p0, bool p1, string memory p2, address p3) internal view {
978 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
979 	}
980 
981 	function log(uint p0, bool p1, bool p2, uint p3) internal view {
982 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
983 	}
984 
985 	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
986 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
987 	}
988 
989 	function log(uint p0, bool p1, bool p2, bool p3) internal view {
990 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
991 	}
992 
993 	function log(uint p0, bool p1, bool p2, address p3) internal view {
994 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
995 	}
996 
997 	function log(uint p0, bool p1, address p2, uint p3) internal view {
998 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
999 	}
1000 
1001 	function log(uint p0, bool p1, address p2, string memory p3) internal view {
1002 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
1003 	}
1004 
1005 	function log(uint p0, bool p1, address p2, bool p3) internal view {
1006 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
1007 	}
1008 
1009 	function log(uint p0, bool p1, address p2, address p3) internal view {
1010 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
1011 	}
1012 
1013 	function log(uint p0, address p1, uint p2, uint p3) internal view {
1014 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
1015 	}
1016 
1017 	function log(uint p0, address p1, uint p2, string memory p3) internal view {
1018 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
1019 	}
1020 
1021 	function log(uint p0, address p1, uint p2, bool p3) internal view {
1022 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
1023 	}
1024 
1025 	function log(uint p0, address p1, uint p2, address p3) internal view {
1026 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
1027 	}
1028 
1029 	function log(uint p0, address p1, string memory p2, uint p3) internal view {
1030 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
1031 	}
1032 
1033 	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
1034 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
1035 	}
1036 
1037 	function log(uint p0, address p1, string memory p2, bool p3) internal view {
1038 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
1039 	}
1040 
1041 	function log(uint p0, address p1, string memory p2, address p3) internal view {
1042 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
1043 	}
1044 
1045 	function log(uint p0, address p1, bool p2, uint p3) internal view {
1046 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
1047 	}
1048 
1049 	function log(uint p0, address p1, bool p2, string memory p3) internal view {
1050 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
1051 	}
1052 
1053 	function log(uint p0, address p1, bool p2, bool p3) internal view {
1054 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
1055 	}
1056 
1057 	function log(uint p0, address p1, bool p2, address p3) internal view {
1058 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
1059 	}
1060 
1061 	function log(uint p0, address p1, address p2, uint p3) internal view {
1062 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
1063 	}
1064 
1065 	function log(uint p0, address p1, address p2, string memory p3) internal view {
1066 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
1067 	}
1068 
1069 	function log(uint p0, address p1, address p2, bool p3) internal view {
1070 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
1071 	}
1072 
1073 	function log(uint p0, address p1, address p2, address p3) internal view {
1074 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
1075 	}
1076 
1077 	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
1078 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
1079 	}
1080 
1081 	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
1082 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
1083 	}
1084 
1085 	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
1086 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
1087 	}
1088 
1089 	function log(string memory p0, uint p1, uint p2, address p3) internal view {
1090 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
1091 	}
1092 
1093 	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
1094 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
1095 	}
1096 
1097 	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
1098 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
1099 	}
1100 
1101 	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
1102 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
1103 	}
1104 
1105 	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
1106 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
1107 	}
1108 
1109 	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
1110 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
1111 	}
1112 
1113 	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
1114 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
1115 	}
1116 
1117 	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
1118 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
1119 	}
1120 
1121 	function log(string memory p0, uint p1, bool p2, address p3) internal view {
1122 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
1123 	}
1124 
1125 	function log(string memory p0, uint p1, address p2, uint p3) internal view {
1126 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
1127 	}
1128 
1129 	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
1130 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
1131 	}
1132 
1133 	function log(string memory p0, uint p1, address p2, bool p3) internal view {
1134 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
1135 	}
1136 
1137 	function log(string memory p0, uint p1, address p2, address p3) internal view {
1138 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
1139 	}
1140 
1141 	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
1142 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
1143 	}
1144 
1145 	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
1146 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
1147 	}
1148 
1149 	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
1150 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
1151 	}
1152 
1153 	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
1154 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
1155 	}
1156 
1157 	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
1158 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
1159 	}
1160 
1161 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
1162 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
1163 	}
1164 
1165 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
1166 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
1167 	}
1168 
1169 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
1170 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
1171 	}
1172 
1173 	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
1174 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
1175 	}
1176 
1177 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
1178 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
1179 	}
1180 
1181 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
1182 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
1183 	}
1184 
1185 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
1186 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
1187 	}
1188 
1189 	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
1190 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
1191 	}
1192 
1193 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
1194 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
1195 	}
1196 
1197 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
1198 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
1199 	}
1200 
1201 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
1202 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
1203 	}
1204 
1205 	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
1206 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
1207 	}
1208 
1209 	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
1210 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
1211 	}
1212 
1213 	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
1214 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
1215 	}
1216 
1217 	function log(string memory p0, bool p1, uint p2, address p3) internal view {
1218 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
1219 	}
1220 
1221 	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
1222 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
1223 	}
1224 
1225 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
1226 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
1227 	}
1228 
1229 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
1230 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
1231 	}
1232 
1233 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
1234 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
1235 	}
1236 
1237 	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
1238 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
1239 	}
1240 
1241 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
1242 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
1243 	}
1244 
1245 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
1246 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
1247 	}
1248 
1249 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
1250 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
1251 	}
1252 
1253 	function log(string memory p0, bool p1, address p2, uint p3) internal view {
1254 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
1255 	}
1256 
1257 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
1258 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
1259 	}
1260 
1261 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
1262 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
1263 	}
1264 
1265 	function log(string memory p0, bool p1, address p2, address p3) internal view {
1266 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
1267 	}
1268 
1269 	function log(string memory p0, address p1, uint p2, uint p3) internal view {
1270 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
1271 	}
1272 
1273 	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
1274 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
1275 	}
1276 
1277 	function log(string memory p0, address p1, uint p2, bool p3) internal view {
1278 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
1279 	}
1280 
1281 	function log(string memory p0, address p1, uint p2, address p3) internal view {
1282 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
1283 	}
1284 
1285 	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
1286 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
1287 	}
1288 
1289 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
1290 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
1291 	}
1292 
1293 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
1294 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
1295 	}
1296 
1297 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
1298 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
1299 	}
1300 
1301 	function log(string memory p0, address p1, bool p2, uint p3) internal view {
1302 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
1303 	}
1304 
1305 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
1306 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
1307 	}
1308 
1309 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
1310 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
1311 	}
1312 
1313 	function log(string memory p0, address p1, bool p2, address p3) internal view {
1314 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
1315 	}
1316 
1317 	function log(string memory p0, address p1, address p2, uint p3) internal view {
1318 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
1319 	}
1320 
1321 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
1322 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
1323 	}
1324 
1325 	function log(string memory p0, address p1, address p2, bool p3) internal view {
1326 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
1327 	}
1328 
1329 	function log(string memory p0, address p1, address p2, address p3) internal view {
1330 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
1331 	}
1332 
1333 	function log(bool p0, uint p1, uint p2, uint p3) internal view {
1334 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
1335 	}
1336 
1337 	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
1338 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
1339 	}
1340 
1341 	function log(bool p0, uint p1, uint p2, bool p3) internal view {
1342 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
1343 	}
1344 
1345 	function log(bool p0, uint p1, uint p2, address p3) internal view {
1346 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
1347 	}
1348 
1349 	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
1350 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
1351 	}
1352 
1353 	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
1354 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
1355 	}
1356 
1357 	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
1358 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
1359 	}
1360 
1361 	function log(bool p0, uint p1, string memory p2, address p3) internal view {
1362 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
1363 	}
1364 
1365 	function log(bool p0, uint p1, bool p2, uint p3) internal view {
1366 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
1367 	}
1368 
1369 	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
1370 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
1371 	}
1372 
1373 	function log(bool p0, uint p1, bool p2, bool p3) internal view {
1374 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
1375 	}
1376 
1377 	function log(bool p0, uint p1, bool p2, address p3) internal view {
1378 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
1379 	}
1380 
1381 	function log(bool p0, uint p1, address p2, uint p3) internal view {
1382 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
1383 	}
1384 
1385 	function log(bool p0, uint p1, address p2, string memory p3) internal view {
1386 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
1387 	}
1388 
1389 	function log(bool p0, uint p1, address p2, bool p3) internal view {
1390 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
1391 	}
1392 
1393 	function log(bool p0, uint p1, address p2, address p3) internal view {
1394 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
1395 	}
1396 
1397 	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
1398 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
1399 	}
1400 
1401 	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
1402 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
1403 	}
1404 
1405 	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
1406 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
1407 	}
1408 
1409 	function log(bool p0, string memory p1, uint p2, address p3) internal view {
1410 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
1411 	}
1412 
1413 	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
1414 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
1415 	}
1416 
1417 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
1418 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
1419 	}
1420 
1421 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
1422 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
1423 	}
1424 
1425 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
1426 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
1427 	}
1428 
1429 	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
1430 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
1431 	}
1432 
1433 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
1434 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
1435 	}
1436 
1437 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
1438 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
1439 	}
1440 
1441 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
1442 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
1443 	}
1444 
1445 	function log(bool p0, string memory p1, address p2, uint p3) internal view {
1446 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
1447 	}
1448 
1449 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
1450 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
1451 	}
1452 
1453 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
1454 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
1455 	}
1456 
1457 	function log(bool p0, string memory p1, address p2, address p3) internal view {
1458 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
1459 	}
1460 
1461 	function log(bool p0, bool p1, uint p2, uint p3) internal view {
1462 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
1463 	}
1464 
1465 	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
1466 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
1467 	}
1468 
1469 	function log(bool p0, bool p1, uint p2, bool p3) internal view {
1470 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
1471 	}
1472 
1473 	function log(bool p0, bool p1, uint p2, address p3) internal view {
1474 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
1475 	}
1476 
1477 	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
1478 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
1479 	}
1480 
1481 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
1482 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
1483 	}
1484 
1485 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
1486 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
1487 	}
1488 
1489 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
1490 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
1491 	}
1492 
1493 	function log(bool p0, bool p1, bool p2, uint p3) internal view {
1494 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
1495 	}
1496 
1497 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
1498 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
1499 	}
1500 
1501 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
1502 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
1503 	}
1504 
1505 	function log(bool p0, bool p1, bool p2, address p3) internal view {
1506 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
1507 	}
1508 
1509 	function log(bool p0, bool p1, address p2, uint p3) internal view {
1510 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
1511 	}
1512 
1513 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
1514 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
1515 	}
1516 
1517 	function log(bool p0, bool p1, address p2, bool p3) internal view {
1518 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
1519 	}
1520 
1521 	function log(bool p0, bool p1, address p2, address p3) internal view {
1522 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
1523 	}
1524 
1525 	function log(bool p0, address p1, uint p2, uint p3) internal view {
1526 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
1527 	}
1528 
1529 	function log(bool p0, address p1, uint p2, string memory p3) internal view {
1530 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
1531 	}
1532 
1533 	function log(bool p0, address p1, uint p2, bool p3) internal view {
1534 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
1535 	}
1536 
1537 	function log(bool p0, address p1, uint p2, address p3) internal view {
1538 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
1539 	}
1540 
1541 	function log(bool p0, address p1, string memory p2, uint p3) internal view {
1542 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
1543 	}
1544 
1545 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
1546 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
1547 	}
1548 
1549 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
1550 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
1551 	}
1552 
1553 	function log(bool p0, address p1, string memory p2, address p3) internal view {
1554 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
1555 	}
1556 
1557 	function log(bool p0, address p1, bool p2, uint p3) internal view {
1558 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
1559 	}
1560 
1561 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
1562 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
1563 	}
1564 
1565 	function log(bool p0, address p1, bool p2, bool p3) internal view {
1566 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
1567 	}
1568 
1569 	function log(bool p0, address p1, bool p2, address p3) internal view {
1570 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
1571 	}
1572 
1573 	function log(bool p0, address p1, address p2, uint p3) internal view {
1574 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
1575 	}
1576 
1577 	function log(bool p0, address p1, address p2, string memory p3) internal view {
1578 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
1579 	}
1580 
1581 	function log(bool p0, address p1, address p2, bool p3) internal view {
1582 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
1583 	}
1584 
1585 	function log(bool p0, address p1, address p2, address p3) internal view {
1586 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
1587 	}
1588 
1589 	function log(address p0, uint p1, uint p2, uint p3) internal view {
1590 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
1591 	}
1592 
1593 	function log(address p0, uint p1, uint p2, string memory p3) internal view {
1594 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
1595 	}
1596 
1597 	function log(address p0, uint p1, uint p2, bool p3) internal view {
1598 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
1599 	}
1600 
1601 	function log(address p0, uint p1, uint p2, address p3) internal view {
1602 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
1603 	}
1604 
1605 	function log(address p0, uint p1, string memory p2, uint p3) internal view {
1606 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
1607 	}
1608 
1609 	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
1610 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
1611 	}
1612 
1613 	function log(address p0, uint p1, string memory p2, bool p3) internal view {
1614 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
1615 	}
1616 
1617 	function log(address p0, uint p1, string memory p2, address p3) internal view {
1618 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
1619 	}
1620 
1621 	function log(address p0, uint p1, bool p2, uint p3) internal view {
1622 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
1623 	}
1624 
1625 	function log(address p0, uint p1, bool p2, string memory p3) internal view {
1626 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
1627 	}
1628 
1629 	function log(address p0, uint p1, bool p2, bool p3) internal view {
1630 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
1631 	}
1632 
1633 	function log(address p0, uint p1, bool p2, address p3) internal view {
1634 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
1635 	}
1636 
1637 	function log(address p0, uint p1, address p2, uint p3) internal view {
1638 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
1639 	}
1640 
1641 	function log(address p0, uint p1, address p2, string memory p3) internal view {
1642 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
1643 	}
1644 
1645 	function log(address p0, uint p1, address p2, bool p3) internal view {
1646 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
1647 	}
1648 
1649 	function log(address p0, uint p1, address p2, address p3) internal view {
1650 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
1651 	}
1652 
1653 	function log(address p0, string memory p1, uint p2, uint p3) internal view {
1654 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
1655 	}
1656 
1657 	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
1658 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
1659 	}
1660 
1661 	function log(address p0, string memory p1, uint p2, bool p3) internal view {
1662 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
1663 	}
1664 
1665 	function log(address p0, string memory p1, uint p2, address p3) internal view {
1666 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
1667 	}
1668 
1669 	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
1670 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
1671 	}
1672 
1673 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
1674 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
1675 	}
1676 
1677 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
1678 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
1679 	}
1680 
1681 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
1682 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
1683 	}
1684 
1685 	function log(address p0, string memory p1, bool p2, uint p3) internal view {
1686 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
1687 	}
1688 
1689 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
1690 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
1691 	}
1692 
1693 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
1694 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
1695 	}
1696 
1697 	function log(address p0, string memory p1, bool p2, address p3) internal view {
1698 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
1699 	}
1700 
1701 	function log(address p0, string memory p1, address p2, uint p3) internal view {
1702 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
1703 	}
1704 
1705 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
1706 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
1707 	}
1708 
1709 	function log(address p0, string memory p1, address p2, bool p3) internal view {
1710 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
1711 	}
1712 
1713 	function log(address p0, string memory p1, address p2, address p3) internal view {
1714 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
1715 	}
1716 
1717 	function log(address p0, bool p1, uint p2, uint p3) internal view {
1718 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
1719 	}
1720 
1721 	function log(address p0, bool p1, uint p2, string memory p3) internal view {
1722 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
1723 	}
1724 
1725 	function log(address p0, bool p1, uint p2, bool p3) internal view {
1726 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
1727 	}
1728 
1729 	function log(address p0, bool p1, uint p2, address p3) internal view {
1730 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
1731 	}
1732 
1733 	function log(address p0, bool p1, string memory p2, uint p3) internal view {
1734 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
1735 	}
1736 
1737 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
1738 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
1739 	}
1740 
1741 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
1742 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
1743 	}
1744 
1745 	function log(address p0, bool p1, string memory p2, address p3) internal view {
1746 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
1747 	}
1748 
1749 	function log(address p0, bool p1, bool p2, uint p3) internal view {
1750 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
1751 	}
1752 
1753 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
1754 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
1755 	}
1756 
1757 	function log(address p0, bool p1, bool p2, bool p3) internal view {
1758 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
1759 	}
1760 
1761 	function log(address p0, bool p1, bool p2, address p3) internal view {
1762 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
1763 	}
1764 
1765 	function log(address p0, bool p1, address p2, uint p3) internal view {
1766 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
1767 	}
1768 
1769 	function log(address p0, bool p1, address p2, string memory p3) internal view {
1770 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
1771 	}
1772 
1773 	function log(address p0, bool p1, address p2, bool p3) internal view {
1774 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
1775 	}
1776 
1777 	function log(address p0, bool p1, address p2, address p3) internal view {
1778 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
1779 	}
1780 
1781 	function log(address p0, address p1, uint p2, uint p3) internal view {
1782 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
1783 	}
1784 
1785 	function log(address p0, address p1, uint p2, string memory p3) internal view {
1786 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
1787 	}
1788 
1789 	function log(address p0, address p1, uint p2, bool p3) internal view {
1790 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
1791 	}
1792 
1793 	function log(address p0, address p1, uint p2, address p3) internal view {
1794 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
1795 	}
1796 
1797 	function log(address p0, address p1, string memory p2, uint p3) internal view {
1798 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
1799 	}
1800 
1801 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
1802 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
1803 	}
1804 
1805 	function log(address p0, address p1, string memory p2, bool p3) internal view {
1806 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
1807 	}
1808 
1809 	function log(address p0, address p1, string memory p2, address p3) internal view {
1810 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
1811 	}
1812 
1813 	function log(address p0, address p1, bool p2, uint p3) internal view {
1814 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
1815 	}
1816 
1817 	function log(address p0, address p1, bool p2, string memory p3) internal view {
1818 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
1819 	}
1820 
1821 	function log(address p0, address p1, bool p2, bool p3) internal view {
1822 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
1823 	}
1824 
1825 	function log(address p0, address p1, bool p2, address p3) internal view {
1826 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
1827 	}
1828 
1829 	function log(address p0, address p1, address p2, uint p3) internal view {
1830 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
1831 	}
1832 
1833 	function log(address p0, address p1, address p2, string memory p3) internal view {
1834 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
1835 	}
1836 
1837 	function log(address p0, address p1, address p2, bool p3) internal view {
1838 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
1839 	}
1840 
1841 	function log(address p0, address p1, address p2, address p3) internal view {
1842 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
1843 	}
1844 
1845 }
1846 
1847 
1848 // File contracts/sale-usdc.sol
1849 
1850 // SPDX-License-Identifier: Apache-2.0
1851 
1852 /*
1853 
1854   /$$$$$$          /$$                     /$$$$$$$   /$$$$$$   /$$$$$$ 
1855  /$$__  $$        |__/                    | $$__  $$ /$$__  $$ /$$__  $$
1856 | $$  \__//$$$$$$  /$$  /$$$$$$   /$$$$$$$| $$  \ $$| $$  \ $$| $$  \ $$
1857 | $$$$   /$$__  $$| $$ /$$__  $$ /$$_____/| $$  | $$| $$$$$$$$| $$  | $$
1858 | $$_/  | $$  \__/| $$| $$$$$$$$|  $$$$$$ | $$  | $$| $$__  $$| $$  | $$
1859 | $$    | $$      | $$| $$_____/ \____  $$| $$  | $$| $$  | $$| $$  | $$
1860 | $$    | $$      | $$|  $$$$$$$ /$$$$$$$/| $$$$$$$/| $$  | $$|  $$$$$$/
1861 |__/    |__/      |__/ \_______/|_______/ |_______/ |__/  |__/ \______/ 
1862 
1863 */
1864 
1865 pragma solidity ^0.8.7;
1866 // FRIES token interface
1867 
1868 interface IFriesDAOToken is IERC20 {
1869     function mint(uint256 amount) external;
1870     function burn(uint256 amount) external;
1871     function burnFrom(address account, uint256 amount) external;
1872 }
1873 
1874 contract FriesDAOTokenSale is ReentrancyGuard, Ownable {
1875 
1876     IERC20 public immutable USDC;                // USDC token
1877     IFriesDAOToken public immutable FRIES;       // FRIES token
1878     uint256 public constant FRIES_DECIMALS = 18; // FRIES token decimals
1879     uint256 public constant USDC_DECIMALS = 6;   // USDC token decimals
1880 
1881     bool public whitelistSaleActive = false;
1882     bool public publicSaleActive = false;
1883     bool public redeemActive = false;
1884     bool public refundActive = false;
1885 
1886     uint256 public salePrice;           // Sale price of FRIES per USDC
1887     uint256 public baseWhitelistAmount; // Base whitelist amount of USDC available to purchase
1888     uint256 public totalCap;            // Total maximum amount of USDC in sale
1889     uint256 public totalPurchased = 0;  // Total amount of USDC purchased in sale
1890 
1891     mapping (address => uint256) public purchased; // Mapping of account to total purchased amount in FRIES
1892     mapping (address => uint256) public redeemed;  // Mapping of account to total amount of redeemed FRIES
1893     mapping (address => bool) public vesting;      // Mapping of account to vesting of purchased FRIES after redeem
1894     bytes32 public merkleRoot;                     // Merkle root representing tree of all whitelisted accounts
1895 
1896     address public treasury;       // friesDAO treasury address
1897     uint256 public vestingPercent; // Percent tokens vested /1000
1898 
1899     // Events
1900 
1901     event WhitelistSaleActiveChanged(bool active);
1902     event PublicSaleActiveChanged(bool active);
1903     event RedeemActiveChanged(bool active);
1904     event RefundActiveChanged(bool active);
1905 
1906     event SalePriceChanged(uint256 price);
1907     event BaseWhitelistAmountChanged(uint256 baseWhitelistAmount);
1908     event TotalCapChanged(uint256 totalCap);
1909 
1910     event Purchased(address indexed account, uint256 amount);
1911     event Redeemed(address indexed account, uint256 amount);
1912     event Refunded(address indexed account, uint256 amount);
1913 
1914     event TreasuryChanged(address treasury);
1915     event VestingPercentChanged(uint256 vestingPercent);
1916 
1917     // Initialize sale parameters
1918 
1919     constructor(address usdcAddress, address friesAddress, address treasuryAddress, bytes32 root) {
1920         USDC = IERC20(usdcAddress);           // USDC token
1921         FRIES = IFriesDAOToken(friesAddress); // Set FRIES token contract
1922 
1923         salePrice = 43312503100000000000;          // 43.3125031 FRIES per USDC
1924         totalCap = 9696969 * 10 ** USDC_DECIMALS; // Total 10,696,969 max USDC raised
1925         merkleRoot = root;                         // Merkle root for whitelisted accounts
1926 
1927         treasury = treasuryAddress; // Set friesDAO treasury address
1928         vestingPercent = 850;       // 85% vesting for vested allocations
1929     }
1930 
1931     /*
1932      * ------------------
1933      * EXTERNAL FUNCTIONS
1934      * ------------------
1935      */
1936 
1937     // Buy FRIES with USDC in whitelisted token sale
1938 
1939     function buyWhitelistFries(uint256 value, uint256 whitelistLimit, bool vestingEnabled, bytes32[] calldata proof) external {
1940         require(whitelistSaleActive, "FriesDAOTokenSale: whitelist token sale is not active");
1941         require(value > 0, "FriesDAOTokenSale: amount to purchase must be larger than zero");
1942 
1943         console.log("verifying proof:", _msgSender(), whitelistLimit, vestingEnabled);
1944         console.logBytes(abi.encodePacked(_msgSender(), whitelistLimit, vestingEnabled));
1945         bytes32 leaf = keccak256(abi.encodePacked(_msgSender(), whitelistLimit, vestingEnabled));                // Calculate merkle leaf of whitelist parameters
1946         console.logBytes32(leaf);
1947         require(MerkleProof.verify(proof, merkleRoot, leaf), "FriesDAOTokenSale: invalid whitelist parameters"); // Verify whitelist parameters with merkle proof
1948 
1949         uint256 amount = value * salePrice / 10 ** USDC_DECIMALS; // Calculate amount of FRIES at sale price with USDC value
1950         require(purchased[_msgSender()] + amount <= whitelistLimit, "FriesDAOTokenSale: amount over whitelist limit"); // Check purchase amount is within whitelist limit
1951 
1952         vesting[_msgSender()] = vestingEnabled;           // Set vesting enabled for account
1953         USDC.transferFrom(_msgSender(), treasury, value); // Transfer USDC amount to treasury
1954         purchased[_msgSender()] += amount;                // Add FRIES amount to purchased amount for account
1955         totalPurchased += value;                          // Add USDC amount to total USDC purchased
1956 
1957         emit Purchased(_msgSender(), amount);
1958     }
1959 
1960     // Buy FRIES with USDC in public token sale
1961 
1962     function buyFries(uint256 value) external {
1963         require(publicSaleActive, "FriesDAOTokenSale: public token sale is not active");
1964         require(value > 0, "FriesDAOTokenSale: amount to purchase must be larger than zero");
1965         require(totalPurchased + value < totalCap, "FriesDAOTokenSale: amount over total sale limit");
1966 
1967         USDC.transferFrom(_msgSender(), treasury, value);                            // Transfer USDC amount to treasury
1968         uint256 amount = value * salePrice / 10 ** USDC_DECIMALS;                    // Calculate amount of FRIES at sale price with USDC value
1969         purchased[_msgSender()] += amount;                                           // Add FRIES amount to purchased amount for account
1970         totalPurchased += value;                                                     // Add USDC amount to total USDC purchased
1971 
1972         emit Purchased(_msgSender(), amount);
1973     }
1974 
1975     // Redeem purchased FRIES for tokens
1976 
1977     function redeemFries() external {
1978         require(redeemActive, "FriesDAOTokenSale: redeeming for tokens is not active");
1979 
1980         uint256 amount = purchased[_msgSender()] - redeemed[_msgSender()]; // Calculate redeemable FRIES amount
1981         require(amount > 0, "FriesDAOTokenSale: invalid redeem amount");
1982         redeemed[_msgSender()] += amount;                                  // Add FRIES redeem amount to redeemed total for account
1983 
1984         if (!vesting[_msgSender()]) {
1985             FRIES.transfer(_msgSender(), amount);                                  // Send redeemed FRIES to account
1986         } else {
1987             FRIES.transfer(_msgSender(), amount * (1000 - vestingPercent) / 1000); // Send available FRIES to account
1988             FRIES.transfer(treasury, amount * vestingPercent / 1000);              // Send vested FRIES to treasury
1989         }
1990 
1991         emit Redeemed(_msgSender(), amount);
1992     }
1993 
1994     // Refund FRIES for USDC at sale price
1995 
1996     function refundFries(uint256 amount) external nonReentrant {
1997         require(refundActive, "FriesDAOTokenSale: refunding redeemed tokens is not active");
1998         require(redeemed[_msgSender()] >= amount, "FriesDAOTokenSale: refund amount larger than tokens redeemed");
1999 
2000         FRIES.burnFrom(_msgSender(), amount);                                                                     // Remove FRIES refund amount from account
2001         purchased[_msgSender()] -= amount;                                                                        // Reduce purchased amount of account by FRIES refund amount
2002         redeemed[_msgSender()] -= amount;                                                                         // Reduce redeemed amount of account by FRIES refund amount
2003         USDC.transferFrom(treasury, _msgSender(), amount * 10 ** USDC_DECIMALS / salePrice); // Send refund USDC amount at sale price to account
2004         
2005         emit Refunded(_msgSender(), amount);
2006     }
2007 
2008     /*
2009      * --------------------
2010      * RESTRICTED FUNCTIONS
2011      * --------------------
2012      */
2013 
2014     // Set merkle root
2015     function setRoot(bytes32 _root) external onlyOwner {   
2016         merkleRoot = _root;
2017     }
2018 
2019     // Set whitelist sale enabled status
2020 
2021     function setWhitelistSaleActive(bool active) external onlyOwner {
2022         whitelistSaleActive = active;
2023         emit WhitelistSaleActiveChanged(whitelistSaleActive);
2024     }
2025 
2026     // Set public sale enabled status
2027 
2028     function setPublicSaleActive(bool active) external onlyOwner {
2029         publicSaleActive = active;
2030         emit PublicSaleActiveChanged(publicSaleActive);
2031     }
2032 
2033     // Set redeem enabled status
2034 
2035     function setRedeemActive(bool active) external onlyOwner {
2036         redeemActive = active;
2037         emit RedeemActiveChanged(redeemActive);
2038     }
2039 
2040     // Set refund enabled status
2041 
2042     function setRefundActive(bool active) external onlyOwner {
2043         refundActive = active;
2044         emit RefundActiveChanged(refundActive);
2045     }
2046 
2047     // Change sale price
2048 
2049     function setSalePrice(uint256 price) external onlyOwner {
2050         salePrice = price;
2051         emit SalePriceChanged(salePrice);
2052     }
2053 
2054     // Change sale total cap
2055 
2056     function setTotalCap(uint256 amount) external onlyOwner {
2057         totalCap = amount;
2058         emit TotalCapChanged(totalCap);
2059     }
2060 
2061     // Change friesDAO treasury address
2062 
2063     function setTreasury(address treasuryAddress) external {
2064         require(_msgSender() == treasury, "FriesDAOTokenSale: caller is not the treasury");
2065         treasury = treasuryAddress;
2066         emit TreasuryChanged(treasury);
2067     }
2068 
2069     // Change vesting percent
2070 
2071     function setVestingPercent(uint256 percent) external onlyOwner {
2072         vestingPercent = percent;
2073         emit VestingPercentChanged(vestingPercent);
2074     }
2075 
2076 }