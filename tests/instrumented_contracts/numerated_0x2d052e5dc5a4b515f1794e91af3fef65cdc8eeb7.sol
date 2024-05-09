1 // Sources flattened with hardhat v2.9.9 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v4.8.0
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 
31 // File @openzeppelin/contracts/access/Ownable.sol@v4.8.0
32 
33 
34 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Contract module which provides a basic access control mechanism, where
40  * there is an account (an owner) that can be granted exclusive access to
41  * specific functions.
42  *
43  * By default, the owner account will be the one that deploys the contract. This
44  * can later be changed with {transferOwnership}.
45  *
46  * This module is used through inheritance. It will make available the modifier
47  * `onlyOwner`, which can be applied to your functions to restrict their use to
48  * the owner.
49  */
50 abstract contract Ownable is Context {
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor() {
59         _transferOwnership(_msgSender());
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         _checkOwner();
67         _;
68     }
69 
70     /**
71      * @dev Returns the address of the current owner.
72      */
73     function owner() public view virtual returns (address) {
74         return _owner;
75     }
76 
77     /**
78      * @dev Throws if the sender is not the owner.
79      */
80     function _checkOwner() internal view virtual {
81         require(owner() == _msgSender(), "Ownable: caller is not the owner");
82     }
83 
84     /**
85      * @dev Leaves the contract without owner. It will not be possible to call
86      * `onlyOwner` functions anymore. Can only be called by the current owner.
87      *
88      * NOTE: Renouncing ownership will leave the contract without an owner,
89      * thereby removing any functionality that is only available to the owner.
90      */
91     function renounceOwnership() public virtual onlyOwner {
92         _transferOwnership(address(0));
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Can only be called by the current owner.
98      */
99     function transferOwnership(address newOwner) public virtual onlyOwner {
100         require(newOwner != address(0), "Ownable: new owner is the zero address");
101         _transferOwnership(newOwner);
102     }
103 
104     /**
105      * @dev Transfers ownership of the contract to a new account (`newOwner`).
106      * Internal function without access restriction.
107      */
108     function _transferOwnership(address newOwner) internal virtual {
109         address oldOwner = _owner;
110         _owner = newOwner;
111         emit OwnershipTransferred(oldOwner, newOwner);
112     }
113 }
114 
115 
116 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.8.0
117 
118 
119 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
120 
121 pragma solidity ^0.8.0;
122 
123 // CAUTION
124 // This version of SafeMath should only be used with Solidity 0.8 or later,
125 // because it relies on the compiler's built in overflow checks.
126 
127 /**
128  * @dev Wrappers over Solidity's arithmetic operations.
129  *
130  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
131  * now has built in overflow checking.
132  */
133 library SafeMath {
134     /**
135      * @dev Returns the addition of two unsigned integers, with an overflow flag.
136      *
137      * _Available since v3.4._
138      */
139     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
140         unchecked {
141             uint256 c = a + b;
142             if (c < a) return (false, 0);
143             return (true, c);
144         }
145     }
146 
147     /**
148      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
149      *
150      * _Available since v3.4._
151      */
152     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
153         unchecked {
154             if (b > a) return (false, 0);
155             return (true, a - b);
156         }
157     }
158 
159     /**
160      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
161      *
162      * _Available since v3.4._
163      */
164     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
165         unchecked {
166             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
167             // benefit is lost if 'b' is also tested.
168             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
169             if (a == 0) return (true, 0);
170             uint256 c = a * b;
171             if (c / a != b) return (false, 0);
172             return (true, c);
173         }
174     }
175 
176     /**
177      * @dev Returns the division of two unsigned integers, with a division by zero flag.
178      *
179      * _Available since v3.4._
180      */
181     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
182         unchecked {
183             if (b == 0) return (false, 0);
184             return (true, a / b);
185         }
186     }
187 
188     /**
189      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
190      *
191      * _Available since v3.4._
192      */
193     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
194         unchecked {
195             if (b == 0) return (false, 0);
196             return (true, a % b);
197         }
198     }
199 
200     /**
201      * @dev Returns the addition of two unsigned integers, reverting on
202      * overflow.
203      *
204      * Counterpart to Solidity's `+` operator.
205      *
206      * Requirements:
207      *
208      * - Addition cannot overflow.
209      */
210     function add(uint256 a, uint256 b) internal pure returns (uint256) {
211         return a + b;
212     }
213 
214     /**
215      * @dev Returns the subtraction of two unsigned integers, reverting on
216      * overflow (when the result is negative).
217      *
218      * Counterpart to Solidity's `-` operator.
219      *
220      * Requirements:
221      *
222      * - Subtraction cannot overflow.
223      */
224     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
225         return a - b;
226     }
227 
228     /**
229      * @dev Returns the multiplication of two unsigned integers, reverting on
230      * overflow.
231      *
232      * Counterpart to Solidity's `*` operator.
233      *
234      * Requirements:
235      *
236      * - Multiplication cannot overflow.
237      */
238     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
239         return a * b;
240     }
241 
242     /**
243      * @dev Returns the integer division of two unsigned integers, reverting on
244      * division by zero. The result is rounded towards zero.
245      *
246      * Counterpart to Solidity's `/` operator.
247      *
248      * Requirements:
249      *
250      * - The divisor cannot be zero.
251      */
252     function div(uint256 a, uint256 b) internal pure returns (uint256) {
253         return a / b;
254     }
255 
256     /**
257      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
258      * reverting when dividing by zero.
259      *
260      * Counterpart to Solidity's `%` operator. This function uses a `revert`
261      * opcode (which leaves remaining gas untouched) while Solidity uses an
262      * invalid opcode to revert (consuming all remaining gas).
263      *
264      * Requirements:
265      *
266      * - The divisor cannot be zero.
267      */
268     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
269         return a % b;
270     }
271 
272     /**
273      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
274      * overflow (when the result is negative).
275      *
276      * CAUTION: This function is deprecated because it requires allocating memory for the error
277      * message unnecessarily. For custom revert reasons use {trySub}.
278      *
279      * Counterpart to Solidity's `-` operator.
280      *
281      * Requirements:
282      *
283      * - Subtraction cannot overflow.
284      */
285     function sub(
286         uint256 a,
287         uint256 b,
288         string memory errorMessage
289     ) internal pure returns (uint256) {
290         unchecked {
291             require(b <= a, errorMessage);
292             return a - b;
293         }
294     }
295 
296     /**
297      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
298      * division by zero. The result is rounded towards zero.
299      *
300      * Counterpart to Solidity's `/` operator. Note: this function uses a
301      * `revert` opcode (which leaves remaining gas untouched) while Solidity
302      * uses an invalid opcode to revert (consuming all remaining gas).
303      *
304      * Requirements:
305      *
306      * - The divisor cannot be zero.
307      */
308     function div(
309         uint256 a,
310         uint256 b,
311         string memory errorMessage
312     ) internal pure returns (uint256) {
313         unchecked {
314             require(b > 0, errorMessage);
315             return a / b;
316         }
317     }
318 
319     /**
320      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
321      * reverting with custom message when dividing by zero.
322      *
323      * CAUTION: This function is deprecated because it requires allocating memory for the error
324      * message unnecessarily. For custom revert reasons use {tryMod}.
325      *
326      * Counterpart to Solidity's `%` operator. This function uses a `revert`
327      * opcode (which leaves remaining gas untouched) while Solidity uses an
328      * invalid opcode to revert (consuming all remaining gas).
329      *
330      * Requirements:
331      *
332      * - The divisor cannot be zero.
333      */
334     function mod(
335         uint256 a,
336         uint256 b,
337         string memory errorMessage
338     ) internal pure returns (uint256) {
339         unchecked {
340             require(b > 0, errorMessage);
341             return a % b;
342         }
343     }
344 }
345 
346 
347 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.8.0
348 
349 
350 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
351 
352 pragma solidity ^0.8.0;
353 
354 /**
355  * @dev Interface of the ERC20 standard as defined in the EIP.
356  */
357 interface IERC20 {
358     /**
359      * @dev Emitted when `value` tokens are moved from one account (`from`) to
360      * another (`to`).
361      *
362      * Note that `value` may be zero.
363      */
364     event Transfer(address indexed from, address indexed to, uint256 value);
365 
366     /**
367      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
368      * a call to {approve}. `value` is the new allowance.
369      */
370     event Approval(address indexed owner, address indexed spender, uint256 value);
371 
372     /**
373      * @dev Returns the amount of tokens in existence.
374      */
375     function totalSupply() external view returns (uint256);
376 
377     /**
378      * @dev Returns the amount of tokens owned by `account`.
379      */
380     function balanceOf(address account) external view returns (uint256);
381 
382     /**
383      * @dev Moves `amount` tokens from the caller's account to `to`.
384      *
385      * Returns a boolean value indicating whether the operation succeeded.
386      *
387      * Emits a {Transfer} event.
388      */
389     function transfer(address to, uint256 amount) external returns (bool);
390 
391     /**
392      * @dev Returns the remaining number of tokens that `spender` will be
393      * allowed to spend on behalf of `owner` through {transferFrom}. This is
394      * zero by default.
395      *
396      * This value changes when {approve} or {transferFrom} are called.
397      */
398     function allowance(address owner, address spender) external view returns (uint256);
399 
400     /**
401      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
402      *
403      * Returns a boolean value indicating whether the operation succeeded.
404      *
405      * IMPORTANT: Beware that changing an allowance with this method brings the risk
406      * that someone may use both the old and the new allowance by unfortunate
407      * transaction ordering. One possible solution to mitigate this race
408      * condition is to first reduce the spender's allowance to 0 and set the
409      * desired value afterwards:
410      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
411      *
412      * Emits an {Approval} event.
413      */
414     function approve(address spender, uint256 amount) external returns (bool);
415 
416     /**
417      * @dev Moves `amount` tokens from `from` to `to` using the
418      * allowance mechanism. `amount` is then deducted from the caller's
419      * allowance.
420      *
421      * Returns a boolean value indicating whether the operation succeeded.
422      *
423      * Emits a {Transfer} event.
424      */
425     function transferFrom(
426         address from,
427         address to,
428         uint256 amount
429     ) external returns (bool);
430 }
431 
432 
433 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.8.0
434 
435 
436 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
437 
438 pragma solidity ^0.8.0;
439 
440 /**
441  * @dev Interface of the ERC165 standard, as defined in the
442  * https://eips.ethereum.org/EIPS/eip-165[EIP].
443  *
444  * Implementers can declare support of contract interfaces, which can then be
445  * queried by others ({ERC165Checker}).
446  *
447  * For an implementation, see {ERC165}.
448  */
449 interface IERC165 {
450     /**
451      * @dev Returns true if this contract implements the interface defined by
452      * `interfaceId`. See the corresponding
453      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
454      * to learn more about how these ids are created.
455      *
456      * This function call must use less than 30 000 gas.
457      */
458     function supportsInterface(bytes4 interfaceId) external view returns (bool);
459 }
460 
461 
462 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.8.0
463 
464 
465 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
466 
467 pragma solidity ^0.8.0;
468 
469 /**
470  * @dev Required interface of an ERC721 compliant contract.
471  */
472 interface IERC721 is IERC165 {
473     /**
474      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
475      */
476     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
477 
478     /**
479      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
480      */
481     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
482 
483     /**
484      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
485      */
486     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
487 
488     /**
489      * @dev Returns the number of tokens in ``owner``'s account.
490      */
491     function balanceOf(address owner) external view returns (uint256 balance);
492 
493     /**
494      * @dev Returns the owner of the `tokenId` token.
495      *
496      * Requirements:
497      *
498      * - `tokenId` must exist.
499      */
500     function ownerOf(uint256 tokenId) external view returns (address owner);
501 
502     /**
503      * @dev Safely transfers `tokenId` token from `from` to `to`.
504      *
505      * Requirements:
506      *
507      * - `from` cannot be the zero address.
508      * - `to` cannot be the zero address.
509      * - `tokenId` token must exist and be owned by `from`.
510      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
511      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
512      *
513      * Emits a {Transfer} event.
514      */
515     function safeTransferFrom(
516         address from,
517         address to,
518         uint256 tokenId,
519         bytes calldata data
520     ) external;
521 
522     /**
523      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
524      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
525      *
526      * Requirements:
527      *
528      * - `from` cannot be the zero address.
529      * - `to` cannot be the zero address.
530      * - `tokenId` token must exist and be owned by `from`.
531      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
532      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
533      *
534      * Emits a {Transfer} event.
535      */
536     function safeTransferFrom(
537         address from,
538         address to,
539         uint256 tokenId
540     ) external;
541 
542     /**
543      * @dev Transfers `tokenId` token from `from` to `to`.
544      *
545      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
546      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
547      * understand this adds an external call which potentially creates a reentrancy vulnerability.
548      *
549      * Requirements:
550      *
551      * - `from` cannot be the zero address.
552      * - `to` cannot be the zero address.
553      * - `tokenId` token must be owned by `from`.
554      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
555      *
556      * Emits a {Transfer} event.
557      */
558     function transferFrom(
559         address from,
560         address to,
561         uint256 tokenId
562     ) external;
563 
564     /**
565      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
566      * The approval is cleared when the token is transferred.
567      *
568      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
569      *
570      * Requirements:
571      *
572      * - The caller must own the token or be an approved operator.
573      * - `tokenId` must exist.
574      *
575      * Emits an {Approval} event.
576      */
577     function approve(address to, uint256 tokenId) external;
578 
579     /**
580      * @dev Approve or remove `operator` as an operator for the caller.
581      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
582      *
583      * Requirements:
584      *
585      * - The `operator` cannot be the caller.
586      *
587      * Emits an {ApprovalForAll} event.
588      */
589     function setApprovalForAll(address operator, bool _approved) external;
590 
591     /**
592      * @dev Returns the account approved for `tokenId` token.
593      *
594      * Requirements:
595      *
596      * - `tokenId` must exist.
597      */
598     function getApproved(uint256 tokenId) external view returns (address operator);
599 
600     /**
601      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
602      *
603      * See {setApprovalForAll}
604      */
605     function isApprovedForAll(address owner, address operator) external view returns (bool);
606 }
607 
608 
609 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.8.0
610 
611 
612 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
613 
614 pragma solidity ^0.8.0;
615 
616 /**
617  * @title ERC721 token receiver interface
618  * @dev Interface for any contract that wants to support safeTransfers
619  * from ERC721 asset contracts.
620  */
621 interface IERC721Receiver {
622     /**
623      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
624      * by `operator` from `from`, this function is called.
625      *
626      * It must return its Solidity selector to confirm the token transfer.
627      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
628      *
629      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
630      */
631     function onERC721Received(
632         address operator,
633         address from,
634         uint256 tokenId,
635         bytes calldata data
636     ) external returns (bytes4);
637 }
638 
639 
640 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.8.0
641 
642 
643 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
644 
645 pragma solidity ^0.8.0;
646 
647 /**
648  * @dev Contract module that helps prevent reentrant calls to a function.
649  *
650  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
651  * available, which can be applied to functions to make sure there are no nested
652  * (reentrant) calls to them.
653  *
654  * Note that because there is a single `nonReentrant` guard, functions marked as
655  * `nonReentrant` may not call one another. This can be worked around by making
656  * those functions `private`, and then adding `external` `nonReentrant` entry
657  * points to them.
658  *
659  * TIP: If you would like to learn more about reentrancy and alternative ways
660  * to protect against it, check out our blog post
661  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
662  */
663 abstract contract ReentrancyGuard {
664     // Booleans are more expensive than uint256 or any type that takes up a full
665     // word because each write operation emits an extra SLOAD to first read the
666     // slot's contents, replace the bits taken up by the boolean, and then write
667     // back. This is the compiler's defense against contract upgrades and
668     // pointer aliasing, and it cannot be disabled.
669 
670     // The values being non-zero value makes deployment a bit more expensive,
671     // but in exchange the refund on every call to nonReentrant will be lower in
672     // amount. Since refunds are capped to a percentage of the total
673     // transaction's gas, it is best to keep them low in cases like this one, to
674     // increase the likelihood of the full refund coming into effect.
675     uint256 private constant _NOT_ENTERED = 1;
676     uint256 private constant _ENTERED = 2;
677 
678     uint256 private _status;
679 
680     constructor() {
681         _status = _NOT_ENTERED;
682     }
683 
684     /**
685      * @dev Prevents a contract from calling itself, directly or indirectly.
686      * Calling a `nonReentrant` function from another `nonReentrant`
687      * function is not supported. It is possible to prevent this from happening
688      * by making the `nonReentrant` function external, and making it call a
689      * `private` function that does the actual work.
690      */
691     modifier nonReentrant() {
692         _nonReentrantBefore();
693         _;
694         _nonReentrantAfter();
695     }
696 
697     function _nonReentrantBefore() private {
698         // On the first call to nonReentrant, _status will be _NOT_ENTERED
699         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
700 
701         // Any calls to nonReentrant after this point will fail
702         _status = _ENTERED;
703     }
704 
705     function _nonReentrantAfter() private {
706         // By storing the original value once again, a refund is triggered (see
707         // https://eips.ethereum.org/EIPS/eip-2200)
708         _status = _NOT_ENTERED;
709     }
710 }
711 
712 
713 // File @chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol@v0.4.1
714 
715 
716 pragma solidity ^0.8.0;
717 
718 interface VRFCoordinatorV2Interface {
719   /**
720    * @notice Get configuration relevant for making requests
721    * @return minimumRequestConfirmations global min for request confirmations
722    * @return maxGasLimit global max for request gas limit
723    * @return s_provingKeyHashes list of registered key hashes
724    */
725   function getRequestConfig()
726     external
727     view
728     returns (
729       uint16,
730       uint32,
731       bytes32[] memory
732     );
733 
734   /**
735    * @notice Request a set of random words.
736    * @param keyHash - Corresponds to a particular oracle job which uses
737    * that key for generating the VRF proof. Different keyHash's have different gas price
738    * ceilings, so you can select a specific one to bound your maximum per request cost.
739    * @param subId  - The ID of the VRF subscription. Must be funded
740    * with the minimum subscription balance required for the selected keyHash.
741    * @param minimumRequestConfirmations - How many blocks you'd like the
742    * oracle to wait before responding to the request. See SECURITY CONSIDERATIONS
743    * for why you may want to request more. The acceptable range is
744    * [minimumRequestBlockConfirmations, 200].
745    * @param callbackGasLimit - How much gas you'd like to receive in your
746    * fulfillRandomWords callback. Note that gasleft() inside fulfillRandomWords
747    * may be slightly less than this amount because of gas used calling the function
748    * (argument decoding etc.), so you may need to request slightly more than you expect
749    * to have inside fulfillRandomWords. The acceptable range is
750    * [0, maxGasLimit]
751    * @param numWords - The number of uint256 random values you'd like to receive
752    * in your fulfillRandomWords callback. Note these numbers are expanded in a
753    * secure way by the VRFCoordinator from a single random value supplied by the oracle.
754    * @return requestId - A unique identifier of the request. Can be used to match
755    * a request to a response in fulfillRandomWords.
756    */
757   function requestRandomWords(
758     bytes32 keyHash,
759     uint64 subId,
760     uint16 minimumRequestConfirmations,
761     uint32 callbackGasLimit,
762     uint32 numWords
763   ) external returns (uint256 requestId);
764 
765   /**
766    * @notice Create a VRF subscription.
767    * @return subId - A unique subscription id.
768    * @dev You can manage the consumer set dynamically with addConsumer/removeConsumer.
769    * @dev Note to fund the subscription, use transferAndCall. For example
770    * @dev  LINKTOKEN.transferAndCall(
771    * @dev    address(COORDINATOR),
772    * @dev    amount,
773    * @dev    abi.encode(subId));
774    */
775   function createSubscription() external returns (uint64 subId);
776 
777   /**
778    * @notice Get a VRF subscription.
779    * @param subId - ID of the subscription
780    * @return balance - LINK balance of the subscription in juels.
781    * @return reqCount - number of requests for this subscription, determines fee tier.
782    * @return owner - owner of the subscription.
783    * @return consumers - list of consumer address which are able to use this subscription.
784    */
785   function getSubscription(uint64 subId)
786     external
787     view
788     returns (
789       uint96 balance,
790       uint64 reqCount,
791       address owner,
792       address[] memory consumers
793     );
794 
795   /**
796    * @notice Request subscription owner transfer.
797    * @param subId - ID of the subscription
798    * @param newOwner - proposed new owner of the subscription
799    */
800   function requestSubscriptionOwnerTransfer(uint64 subId, address newOwner) external;
801 
802   /**
803    * @notice Request subscription owner transfer.
804    * @param subId - ID of the subscription
805    * @dev will revert if original owner of subId has
806    * not requested that msg.sender become the new owner.
807    */
808   function acceptSubscriptionOwnerTransfer(uint64 subId) external;
809 
810   /**
811    * @notice Add a consumer to a VRF subscription.
812    * @param subId - ID of the subscription
813    * @param consumer - New consumer which can use the subscription
814    */
815   function addConsumer(uint64 subId, address consumer) external;
816 
817   /**
818    * @notice Remove a consumer from a VRF subscription.
819    * @param subId - ID of the subscription
820    * @param consumer - Consumer to remove from the subscription
821    */
822   function removeConsumer(uint64 subId, address consumer) external;
823 
824   /**
825    * @notice Cancel a subscription
826    * @param subId - ID of the subscription
827    * @param to - Where to send the remaining LINK to
828    */
829   function cancelSubscription(uint64 subId, address to) external;
830 }
831 
832 
833 // File @chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol@v0.4.1
834 
835 
836 pragma solidity ^0.8.4;
837 
838 /** ****************************************************************************
839  * @notice Interface for contracts using VRF randomness
840  * *****************************************************************************
841  * @dev PURPOSE
842  *
843  * @dev Reggie the Random Oracle (not his real job) wants to provide randomness
844  * @dev to Vera the verifier in such a way that Vera can be sure he's not
845  * @dev making his output up to suit himself. Reggie provides Vera a public key
846  * @dev to which he knows the secret key. Each time Vera provides a seed to
847  * @dev Reggie, he gives back a value which is computed completely
848  * @dev deterministically from the seed and the secret key.
849  *
850  * @dev Reggie provides a proof by which Vera can verify that the output was
851  * @dev correctly computed once Reggie tells it to her, but without that proof,
852  * @dev the output is indistinguishable to her from a uniform random sample
853  * @dev from the output space.
854  *
855  * @dev The purpose of this contract is to make it easy for unrelated contracts
856  * @dev to talk to Vera the verifier about the work Reggie is doing, to provide
857  * @dev simple access to a verifiable source of randomness. It ensures 2 things:
858  * @dev 1. The fulfillment came from the VRFCoordinator
859  * @dev 2. The consumer contract implements fulfillRandomWords.
860  * *****************************************************************************
861  * @dev USAGE
862  *
863  * @dev Calling contracts must inherit from VRFConsumerBase, and can
864  * @dev initialize VRFConsumerBase's attributes in their constructor as
865  * @dev shown:
866  *
867  * @dev   contract VRFConsumer {
868  * @dev     constructor(<other arguments>, address _vrfCoordinator, address _link)
869  * @dev       VRFConsumerBase(_vrfCoordinator) public {
870  * @dev         <initialization with other arguments goes here>
871  * @dev       }
872  * @dev   }
873  *
874  * @dev The oracle will have given you an ID for the VRF keypair they have
875  * @dev committed to (let's call it keyHash). Create subscription, fund it
876  * @dev and your consumer contract as a consumer of it (see VRFCoordinatorInterface
877  * @dev subscription management functions).
878  * @dev Call requestRandomWords(keyHash, subId, minimumRequestConfirmations,
879  * @dev callbackGasLimit, numWords),
880  * @dev see (VRFCoordinatorInterface for a description of the arguments).
881  *
882  * @dev Once the VRFCoordinator has received and validated the oracle's response
883  * @dev to your request, it will call your contract's fulfillRandomWords method.
884  *
885  * @dev The randomness argument to fulfillRandomWords is a set of random words
886  * @dev generated from your requestId and the blockHash of the request.
887  *
888  * @dev If your contract could have concurrent requests open, you can use the
889  * @dev requestId returned from requestRandomWords to track which response is associated
890  * @dev with which randomness request.
891  * @dev See "SECURITY CONSIDERATIONS" for principles to keep in mind,
892  * @dev if your contract could have multiple requests in flight simultaneously.
893  *
894  * @dev Colliding `requestId`s are cryptographically impossible as long as seeds
895  * @dev differ.
896  *
897  * *****************************************************************************
898  * @dev SECURITY CONSIDERATIONS
899  *
900  * @dev A method with the ability to call your fulfillRandomness method directly
901  * @dev could spoof a VRF response with any random value, so it's critical that
902  * @dev it cannot be directly called by anything other than this base contract
903  * @dev (specifically, by the VRFConsumerBase.rawFulfillRandomness method).
904  *
905  * @dev For your users to trust that your contract's random behavior is free
906  * @dev from malicious interference, it's best if you can write it so that all
907  * @dev behaviors implied by a VRF response are executed *during* your
908  * @dev fulfillRandomness method. If your contract must store the response (or
909  * @dev anything derived from it) and use it later, you must ensure that any
910  * @dev user-significant behavior which depends on that stored value cannot be
911  * @dev manipulated by a subsequent VRF request.
912  *
913  * @dev Similarly, both miners and the VRF oracle itself have some influence
914  * @dev over the order in which VRF responses appear on the blockchain, so if
915  * @dev your contract could have multiple VRF requests in flight simultaneously,
916  * @dev you must ensure that the order in which the VRF responses arrive cannot
917  * @dev be used to manipulate your contract's user-significant behavior.
918  *
919  * @dev Since the block hash of the block which contains the requestRandomness
920  * @dev call is mixed into the input to the VRF *last*, a sufficiently powerful
921  * @dev miner could, in principle, fork the blockchain to evict the block
922  * @dev containing the request, forcing the request to be included in a
923  * @dev different block with a different hash, and therefore a different input
924  * @dev to the VRF. However, such an attack would incur a substantial economic
925  * @dev cost. This cost scales with the number of blocks the VRF oracle waits
926  * @dev until it calls responds to a request. It is for this reason that
927  * @dev that you can signal to an oracle you'd like them to wait longer before
928  * @dev responding to the request (however this is not enforced in the contract
929  * @dev and so remains effective only in the case of unmodified oracle software).
930  */
931 abstract contract VRFConsumerBaseV2 {
932   error OnlyCoordinatorCanFulfill(address have, address want);
933   address private immutable vrfCoordinator;
934 
935   /**
936    * @param _vrfCoordinator address of VRFCoordinator contract
937    */
938   constructor(address _vrfCoordinator) {
939     vrfCoordinator = _vrfCoordinator;
940   }
941 
942   /**
943    * @notice fulfillRandomness handles the VRF response. Your contract must
944    * @notice implement it. See "SECURITY CONSIDERATIONS" above for important
945    * @notice principles to keep in mind when implementing your fulfillRandomness
946    * @notice method.
947    *
948    * @dev VRFConsumerBaseV2 expects its subcontracts to have a method with this
949    * @dev signature, and will call it once it has verified the proof
950    * @dev associated with the randomness. (It is triggered via a call to
951    * @dev rawFulfillRandomness, below.)
952    *
953    * @param requestId The Id initially returned by requestRandomness
954    * @param randomWords the VRF output expanded to the requested number of words
955    */
956   function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal virtual;
957 
958   // rawFulfillRandomness is called by VRFCoordinator when it receives a valid VRF
959   // proof. rawFulfillRandomness then calls fulfillRandomness, after validating
960   // the origin of the call
961   function rawFulfillRandomWords(uint256 requestId, uint256[] memory randomWords) external {
962     if (msg.sender != vrfCoordinator) {
963       revert OnlyCoordinatorCanFulfill(msg.sender, vrfCoordinator);
964     }
965     fulfillRandomWords(requestId, randomWords);
966   }
967 }
968 
969 
970 // File @openzeppelin/contracts/utils/structs/EnumerableSet.sol@v4.8.0
971 
972 
973 // OpenZeppelin Contracts (last updated v4.8.0) (utils/structs/EnumerableSet.sol)
974 // This file was procedurally generated from scripts/generate/templates/EnumerableSet.js.
975 
976 pragma solidity ^0.8.0;
977 
978 /**
979  * @dev Library for managing
980  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
981  * types.
982  *
983  * Sets have the following properties:
984  *
985  * - Elements are added, removed, and checked for existence in constant time
986  * (O(1)).
987  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
988  *
989  * ```
990  * contract Example {
991  *     // Add the library methods
992  *     using EnumerableSet for EnumerableSet.AddressSet;
993  *
994  *     // Declare a set state variable
995  *     EnumerableSet.AddressSet private mySet;
996  * }
997  * ```
998  *
999  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
1000  * and `uint256` (`UintSet`) are supported.
1001  *
1002  * [WARNING]
1003  * ====
1004  * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
1005  * unusable.
1006  * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
1007  *
1008  * In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an
1009  * array of EnumerableSet.
1010  * ====
1011  */
1012 library EnumerableSet {
1013     // To implement this library for multiple types with as little code
1014     // repetition as possible, we write it in terms of a generic Set type with
1015     // bytes32 values.
1016     // The Set implementation uses private functions, and user-facing
1017     // implementations (such as AddressSet) are just wrappers around the
1018     // underlying Set.
1019     // This means that we can only create new EnumerableSets for types that fit
1020     // in bytes32.
1021 
1022     struct Set {
1023         // Storage of set values
1024         bytes32[] _values;
1025         // Position of the value in the `values` array, plus 1 because index 0
1026         // means a value is not in the set.
1027         mapping(bytes32 => uint256) _indexes;
1028     }
1029 
1030     /**
1031      * @dev Add a value to a set. O(1).
1032      *
1033      * Returns true if the value was added to the set, that is if it was not
1034      * already present.
1035      */
1036     function _add(Set storage set, bytes32 value) private returns (bool) {
1037         if (!_contains(set, value)) {
1038             set._values.push(value);
1039             // The value is stored at length-1, but we add 1 to all indexes
1040             // and use 0 as a sentinel value
1041             set._indexes[value] = set._values.length;
1042             return true;
1043         } else {
1044             return false;
1045         }
1046     }
1047 
1048     /**
1049      * @dev Removes a value from a set. O(1).
1050      *
1051      * Returns true if the value was removed from the set, that is if it was
1052      * present.
1053      */
1054     function _remove(Set storage set, bytes32 value) private returns (bool) {
1055         // We read and store the value's index to prevent multiple reads from the same storage slot
1056         uint256 valueIndex = set._indexes[value];
1057 
1058         if (valueIndex != 0) {
1059             // Equivalent to contains(set, value)
1060             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1061             // the array, and then remove the last element (sometimes called as 'swap and pop').
1062             // This modifies the order of the array, as noted in {at}.
1063 
1064             uint256 toDeleteIndex = valueIndex - 1;
1065             uint256 lastIndex = set._values.length - 1;
1066 
1067             if (lastIndex != toDeleteIndex) {
1068                 bytes32 lastValue = set._values[lastIndex];
1069 
1070                 // Move the last value to the index where the value to delete is
1071                 set._values[toDeleteIndex] = lastValue;
1072                 // Update the index for the moved value
1073                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
1074             }
1075 
1076             // Delete the slot where the moved value was stored
1077             set._values.pop();
1078 
1079             // Delete the index for the deleted slot
1080             delete set._indexes[value];
1081 
1082             return true;
1083         } else {
1084             return false;
1085         }
1086     }
1087 
1088     /**
1089      * @dev Returns true if the value is in the set. O(1).
1090      */
1091     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1092         return set._indexes[value] != 0;
1093     }
1094 
1095     /**
1096      * @dev Returns the number of values on the set. O(1).
1097      */
1098     function _length(Set storage set) private view returns (uint256) {
1099         return set._values.length;
1100     }
1101 
1102     /**
1103      * @dev Returns the value stored at position `index` in the set. O(1).
1104      *
1105      * Note that there are no guarantees on the ordering of values inside the
1106      * array, and it may change when more values are added or removed.
1107      *
1108      * Requirements:
1109      *
1110      * - `index` must be strictly less than {length}.
1111      */
1112     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1113         return set._values[index];
1114     }
1115 
1116     /**
1117      * @dev Return the entire set in an array
1118      *
1119      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1120      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1121      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1122      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1123      */
1124     function _values(Set storage set) private view returns (bytes32[] memory) {
1125         return set._values;
1126     }
1127 
1128     // Bytes32Set
1129 
1130     struct Bytes32Set {
1131         Set _inner;
1132     }
1133 
1134     /**
1135      * @dev Add a value to a set. O(1).
1136      *
1137      * Returns true if the value was added to the set, that is if it was not
1138      * already present.
1139      */
1140     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1141         return _add(set._inner, value);
1142     }
1143 
1144     /**
1145      * @dev Removes a value from a set. O(1).
1146      *
1147      * Returns true if the value was removed from the set, that is if it was
1148      * present.
1149      */
1150     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1151         return _remove(set._inner, value);
1152     }
1153 
1154     /**
1155      * @dev Returns true if the value is in the set. O(1).
1156      */
1157     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
1158         return _contains(set._inner, value);
1159     }
1160 
1161     /**
1162      * @dev Returns the number of values in the set. O(1).
1163      */
1164     function length(Bytes32Set storage set) internal view returns (uint256) {
1165         return _length(set._inner);
1166     }
1167 
1168     /**
1169      * @dev Returns the value stored at position `index` in the set. O(1).
1170      *
1171      * Note that there are no guarantees on the ordering of values inside the
1172      * array, and it may change when more values are added or removed.
1173      *
1174      * Requirements:
1175      *
1176      * - `index` must be strictly less than {length}.
1177      */
1178     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
1179         return _at(set._inner, index);
1180     }
1181 
1182     /**
1183      * @dev Return the entire set in an array
1184      *
1185      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1186      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1187      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1188      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1189      */
1190     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
1191         bytes32[] memory store = _values(set._inner);
1192         bytes32[] memory result;
1193 
1194         /// @solidity memory-safe-assembly
1195         assembly {
1196             result := store
1197         }
1198 
1199         return result;
1200     }
1201 
1202     // AddressSet
1203 
1204     struct AddressSet {
1205         Set _inner;
1206     }
1207 
1208     /**
1209      * @dev Add a value to a set. O(1).
1210      *
1211      * Returns true if the value was added to the set, that is if it was not
1212      * already present.
1213      */
1214     function add(AddressSet storage set, address value) internal returns (bool) {
1215         return _add(set._inner, bytes32(uint256(uint160(value))));
1216     }
1217 
1218     /**
1219      * @dev Removes a value from a set. O(1).
1220      *
1221      * Returns true if the value was removed from the set, that is if it was
1222      * present.
1223      */
1224     function remove(AddressSet storage set, address value) internal returns (bool) {
1225         return _remove(set._inner, bytes32(uint256(uint160(value))));
1226     }
1227 
1228     /**
1229      * @dev Returns true if the value is in the set. O(1).
1230      */
1231     function contains(AddressSet storage set, address value) internal view returns (bool) {
1232         return _contains(set._inner, bytes32(uint256(uint160(value))));
1233     }
1234 
1235     /**
1236      * @dev Returns the number of values in the set. O(1).
1237      */
1238     function length(AddressSet storage set) internal view returns (uint256) {
1239         return _length(set._inner);
1240     }
1241 
1242     /**
1243      * @dev Returns the value stored at position `index` in the set. O(1).
1244      *
1245      * Note that there are no guarantees on the ordering of values inside the
1246      * array, and it may change when more values are added or removed.
1247      *
1248      * Requirements:
1249      *
1250      * - `index` must be strictly less than {length}.
1251      */
1252     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1253         return address(uint160(uint256(_at(set._inner, index))));
1254     }
1255 
1256     /**
1257      * @dev Return the entire set in an array
1258      *
1259      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1260      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1261      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1262      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1263      */
1264     function values(AddressSet storage set) internal view returns (address[] memory) {
1265         bytes32[] memory store = _values(set._inner);
1266         address[] memory result;
1267 
1268         /// @solidity memory-safe-assembly
1269         assembly {
1270             result := store
1271         }
1272 
1273         return result;
1274     }
1275 
1276     // UintSet
1277 
1278     struct UintSet {
1279         Set _inner;
1280     }
1281 
1282     /**
1283      * @dev Add a value to a set. O(1).
1284      *
1285      * Returns true if the value was added to the set, that is if it was not
1286      * already present.
1287      */
1288     function add(UintSet storage set, uint256 value) internal returns (bool) {
1289         return _add(set._inner, bytes32(value));
1290     }
1291 
1292     /**
1293      * @dev Removes a value from a set. O(1).
1294      *
1295      * Returns true if the value was removed from the set, that is if it was
1296      * present.
1297      */
1298     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1299         return _remove(set._inner, bytes32(value));
1300     }
1301 
1302     /**
1303      * @dev Returns true if the value is in the set. O(1).
1304      */
1305     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1306         return _contains(set._inner, bytes32(value));
1307     }
1308 
1309     /**
1310      * @dev Returns the number of values in the set. O(1).
1311      */
1312     function length(UintSet storage set) internal view returns (uint256) {
1313         return _length(set._inner);
1314     }
1315 
1316     /**
1317      * @dev Returns the value stored at position `index` in the set. O(1).
1318      *
1319      * Note that there are no guarantees on the ordering of values inside the
1320      * array, and it may change when more values are added or removed.
1321      *
1322      * Requirements:
1323      *
1324      * - `index` must be strictly less than {length}.
1325      */
1326     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1327         return uint256(_at(set._inner, index));
1328     }
1329 
1330     /**
1331      * @dev Return the entire set in an array
1332      *
1333      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1334      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1335      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1336      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1337      */
1338     function values(UintSet storage set) internal view returns (uint256[] memory) {
1339         bytes32[] memory store = _values(set._inner);
1340         uint256[] memory result;
1341 
1342         /// @solidity memory-safe-assembly
1343         assembly {
1344             result := store
1345         }
1346 
1347         return result;
1348     }
1349 }
1350 
1351 
1352 // File @openzeppelin/contracts/utils/structs/EnumerableMap.sol@v4.8.0
1353 
1354 
1355 // OpenZeppelin Contracts (last updated v4.8.0) (utils/structs/EnumerableMap.sol)
1356 // This file was procedurally generated from scripts/generate/templates/EnumerableMap.js.
1357 
1358 pragma solidity ^0.8.0;
1359 
1360 /**
1361  * @dev Library for managing an enumerable variant of Solidity's
1362  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1363  * type.
1364  *
1365  * Maps have the following properties:
1366  *
1367  * - Entries are added, removed, and checked for existence in constant time
1368  * (O(1)).
1369  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1370  *
1371  * ```
1372  * contract Example {
1373  *     // Add the library methods
1374  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1375  *
1376  *     // Declare a set state variable
1377  *     EnumerableMap.UintToAddressMap private myMap;
1378  * }
1379  * ```
1380  *
1381  * The following map types are supported:
1382  *
1383  * - `uint256 -> address` (`UintToAddressMap`) since v3.0.0
1384  * - `address -> uint256` (`AddressToUintMap`) since v4.6.0
1385  * - `bytes32 -> bytes32` (`Bytes32ToBytes32Map`) since v4.6.0
1386  * - `uint256 -> uint256` (`UintToUintMap`) since v4.7.0
1387  * - `bytes32 -> uint256` (`Bytes32ToUintMap`) since v4.7.0
1388  *
1389  * [WARNING]
1390  * ====
1391  * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
1392  * unusable.
1393  * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
1394  *
1395  * In order to clean an EnumerableMap, you can either remove all elements one by one or create a fresh instance using an
1396  * array of EnumerableMap.
1397  * ====
1398  */
1399 library EnumerableMap {
1400     using EnumerableSet for EnumerableSet.Bytes32Set;
1401 
1402     // To implement this library for multiple types with as little code
1403     // repetition as possible, we write it in terms of a generic Map type with
1404     // bytes32 keys and values.
1405     // The Map implementation uses private functions, and user-facing
1406     // implementations (such as Uint256ToAddressMap) are just wrappers around
1407     // the underlying Map.
1408     // This means that we can only create new EnumerableMaps for types that fit
1409     // in bytes32.
1410 
1411     struct Bytes32ToBytes32Map {
1412         // Storage of keys
1413         EnumerableSet.Bytes32Set _keys;
1414         mapping(bytes32 => bytes32) _values;
1415     }
1416 
1417     /**
1418      * @dev Adds a key-value pair to a map, or updates the value for an existing
1419      * key. O(1).
1420      *
1421      * Returns true if the key was added to the map, that is if it was not
1422      * already present.
1423      */
1424     function set(
1425         Bytes32ToBytes32Map storage map,
1426         bytes32 key,
1427         bytes32 value
1428     ) internal returns (bool) {
1429         map._values[key] = value;
1430         return map._keys.add(key);
1431     }
1432 
1433     /**
1434      * @dev Removes a key-value pair from a map. O(1).
1435      *
1436      * Returns true if the key was removed from the map, that is if it was present.
1437      */
1438     function remove(Bytes32ToBytes32Map storage map, bytes32 key) internal returns (bool) {
1439         delete map._values[key];
1440         return map._keys.remove(key);
1441     }
1442 
1443     /**
1444      * @dev Returns true if the key is in the map. O(1).
1445      */
1446     function contains(Bytes32ToBytes32Map storage map, bytes32 key) internal view returns (bool) {
1447         return map._keys.contains(key);
1448     }
1449 
1450     /**
1451      * @dev Returns the number of key-value pairs in the map. O(1).
1452      */
1453     function length(Bytes32ToBytes32Map storage map) internal view returns (uint256) {
1454         return map._keys.length();
1455     }
1456 
1457     /**
1458      * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1459      *
1460      * Note that there are no guarantees on the ordering of entries inside the
1461      * array, and it may change when more entries are added or removed.
1462      *
1463      * Requirements:
1464      *
1465      * - `index` must be strictly less than {length}.
1466      */
1467     function at(Bytes32ToBytes32Map storage map, uint256 index) internal view returns (bytes32, bytes32) {
1468         bytes32 key = map._keys.at(index);
1469         return (key, map._values[key]);
1470     }
1471 
1472     /**
1473      * @dev Tries to returns the value associated with `key`. O(1).
1474      * Does not revert if `key` is not in the map.
1475      */
1476     function tryGet(Bytes32ToBytes32Map storage map, bytes32 key) internal view returns (bool, bytes32) {
1477         bytes32 value = map._values[key];
1478         if (value == bytes32(0)) {
1479             return (contains(map, key), bytes32(0));
1480         } else {
1481             return (true, value);
1482         }
1483     }
1484 
1485     /**
1486      * @dev Returns the value associated with `key`. O(1).
1487      *
1488      * Requirements:
1489      *
1490      * - `key` must be in the map.
1491      */
1492     function get(Bytes32ToBytes32Map storage map, bytes32 key) internal view returns (bytes32) {
1493         bytes32 value = map._values[key];
1494         require(value != 0 || contains(map, key), "EnumerableMap: nonexistent key");
1495         return value;
1496     }
1497 
1498     /**
1499      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1500      *
1501      * CAUTION: This function is deprecated because it requires allocating memory for the error
1502      * message unnecessarily. For custom revert reasons use {tryGet}.
1503      */
1504     function get(
1505         Bytes32ToBytes32Map storage map,
1506         bytes32 key,
1507         string memory errorMessage
1508     ) internal view returns (bytes32) {
1509         bytes32 value = map._values[key];
1510         require(value != 0 || contains(map, key), errorMessage);
1511         return value;
1512     }
1513 
1514     // UintToUintMap
1515 
1516     struct UintToUintMap {
1517         Bytes32ToBytes32Map _inner;
1518     }
1519 
1520     /**
1521      * @dev Adds a key-value pair to a map, or updates the value for an existing
1522      * key. O(1).
1523      *
1524      * Returns true if the key was added to the map, that is if it was not
1525      * already present.
1526      */
1527     function set(
1528         UintToUintMap storage map,
1529         uint256 key,
1530         uint256 value
1531     ) internal returns (bool) {
1532         return set(map._inner, bytes32(key), bytes32(value));
1533     }
1534 
1535     /**
1536      * @dev Removes a value from a set. O(1).
1537      *
1538      * Returns true if the key was removed from the map, that is if it was present.
1539      */
1540     function remove(UintToUintMap storage map, uint256 key) internal returns (bool) {
1541         return remove(map._inner, bytes32(key));
1542     }
1543 
1544     /**
1545      * @dev Returns true if the key is in the map. O(1).
1546      */
1547     function contains(UintToUintMap storage map, uint256 key) internal view returns (bool) {
1548         return contains(map._inner, bytes32(key));
1549     }
1550 
1551     /**
1552      * @dev Returns the number of elements in the map. O(1).
1553      */
1554     function length(UintToUintMap storage map) internal view returns (uint256) {
1555         return length(map._inner);
1556     }
1557 
1558     /**
1559      * @dev Returns the element stored at position `index` in the set. O(1).
1560      * Note that there are no guarantees on the ordering of values inside the
1561      * array, and it may change when more values are added or removed.
1562      *
1563      * Requirements:
1564      *
1565      * - `index` must be strictly less than {length}.
1566      */
1567     function at(UintToUintMap storage map, uint256 index) internal view returns (uint256, uint256) {
1568         (bytes32 key, bytes32 value) = at(map._inner, index);
1569         return (uint256(key), uint256(value));
1570     }
1571 
1572     /**
1573      * @dev Tries to returns the value associated with `key`. O(1).
1574      * Does not revert if `key` is not in the map.
1575      */
1576     function tryGet(UintToUintMap storage map, uint256 key) internal view returns (bool, uint256) {
1577         (bool success, bytes32 value) = tryGet(map._inner, bytes32(key));
1578         return (success, uint256(value));
1579     }
1580 
1581     /**
1582      * @dev Returns the value associated with `key`. O(1).
1583      *
1584      * Requirements:
1585      *
1586      * - `key` must be in the map.
1587      */
1588     function get(UintToUintMap storage map, uint256 key) internal view returns (uint256) {
1589         return uint256(get(map._inner, bytes32(key)));
1590     }
1591 
1592     /**
1593      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1594      *
1595      * CAUTION: This function is deprecated because it requires allocating memory for the error
1596      * message unnecessarily. For custom revert reasons use {tryGet}.
1597      */
1598     function get(
1599         UintToUintMap storage map,
1600         uint256 key,
1601         string memory errorMessage
1602     ) internal view returns (uint256) {
1603         return uint256(get(map._inner, bytes32(key), errorMessage));
1604     }
1605 
1606     // UintToAddressMap
1607 
1608     struct UintToAddressMap {
1609         Bytes32ToBytes32Map _inner;
1610     }
1611 
1612     /**
1613      * @dev Adds a key-value pair to a map, or updates the value for an existing
1614      * key. O(1).
1615      *
1616      * Returns true if the key was added to the map, that is if it was not
1617      * already present.
1618      */
1619     function set(
1620         UintToAddressMap storage map,
1621         uint256 key,
1622         address value
1623     ) internal returns (bool) {
1624         return set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1625     }
1626 
1627     /**
1628      * @dev Removes a value from a set. O(1).
1629      *
1630      * Returns true if the key was removed from the map, that is if it was present.
1631      */
1632     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1633         return remove(map._inner, bytes32(key));
1634     }
1635 
1636     /**
1637      * @dev Returns true if the key is in the map. O(1).
1638      */
1639     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1640         return contains(map._inner, bytes32(key));
1641     }
1642 
1643     /**
1644      * @dev Returns the number of elements in the map. O(1).
1645      */
1646     function length(UintToAddressMap storage map) internal view returns (uint256) {
1647         return length(map._inner);
1648     }
1649 
1650     /**
1651      * @dev Returns the element stored at position `index` in the set. O(1).
1652      * Note that there are no guarantees on the ordering of values inside the
1653      * array, and it may change when more values are added or removed.
1654      *
1655      * Requirements:
1656      *
1657      * - `index` must be strictly less than {length}.
1658      */
1659     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1660         (bytes32 key, bytes32 value) = at(map._inner, index);
1661         return (uint256(key), address(uint160(uint256(value))));
1662     }
1663 
1664     /**
1665      * @dev Tries to returns the value associated with `key`. O(1).
1666      * Does not revert if `key` is not in the map.
1667      */
1668     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1669         (bool success, bytes32 value) = tryGet(map._inner, bytes32(key));
1670         return (success, address(uint160(uint256(value))));
1671     }
1672 
1673     /**
1674      * @dev Returns the value associated with `key`. O(1).
1675      *
1676      * Requirements:
1677      *
1678      * - `key` must be in the map.
1679      */
1680     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1681         return address(uint160(uint256(get(map._inner, bytes32(key)))));
1682     }
1683 
1684     /**
1685      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1686      *
1687      * CAUTION: This function is deprecated because it requires allocating memory for the error
1688      * message unnecessarily. For custom revert reasons use {tryGet}.
1689      */
1690     function get(
1691         UintToAddressMap storage map,
1692         uint256 key,
1693         string memory errorMessage
1694     ) internal view returns (address) {
1695         return address(uint160(uint256(get(map._inner, bytes32(key), errorMessage))));
1696     }
1697 
1698     // AddressToUintMap
1699 
1700     struct AddressToUintMap {
1701         Bytes32ToBytes32Map _inner;
1702     }
1703 
1704     /**
1705      * @dev Adds a key-value pair to a map, or updates the value for an existing
1706      * key. O(1).
1707      *
1708      * Returns true if the key was added to the map, that is if it was not
1709      * already present.
1710      */
1711     function set(
1712         AddressToUintMap storage map,
1713         address key,
1714         uint256 value
1715     ) internal returns (bool) {
1716         return set(map._inner, bytes32(uint256(uint160(key))), bytes32(value));
1717     }
1718 
1719     /**
1720      * @dev Removes a value from a set. O(1).
1721      *
1722      * Returns true if the key was removed from the map, that is if it was present.
1723      */
1724     function remove(AddressToUintMap storage map, address key) internal returns (bool) {
1725         return remove(map._inner, bytes32(uint256(uint160(key))));
1726     }
1727 
1728     /**
1729      * @dev Returns true if the key is in the map. O(1).
1730      */
1731     function contains(AddressToUintMap storage map, address key) internal view returns (bool) {
1732         return contains(map._inner, bytes32(uint256(uint160(key))));
1733     }
1734 
1735     /**
1736      * @dev Returns the number of elements in the map. O(1).
1737      */
1738     function length(AddressToUintMap storage map) internal view returns (uint256) {
1739         return length(map._inner);
1740     }
1741 
1742     /**
1743      * @dev Returns the element stored at position `index` in the set. O(1).
1744      * Note that there are no guarantees on the ordering of values inside the
1745      * array, and it may change when more values are added or removed.
1746      *
1747      * Requirements:
1748      *
1749      * - `index` must be strictly less than {length}.
1750      */
1751     function at(AddressToUintMap storage map, uint256 index) internal view returns (address, uint256) {
1752         (bytes32 key, bytes32 value) = at(map._inner, index);
1753         return (address(uint160(uint256(key))), uint256(value));
1754     }
1755 
1756     /**
1757      * @dev Tries to returns the value associated with `key`. O(1).
1758      * Does not revert if `key` is not in the map.
1759      */
1760     function tryGet(AddressToUintMap storage map, address key) internal view returns (bool, uint256) {
1761         (bool success, bytes32 value) = tryGet(map._inner, bytes32(uint256(uint160(key))));
1762         return (success, uint256(value));
1763     }
1764 
1765     /**
1766      * @dev Returns the value associated with `key`. O(1).
1767      *
1768      * Requirements:
1769      *
1770      * - `key` must be in the map.
1771      */
1772     function get(AddressToUintMap storage map, address key) internal view returns (uint256) {
1773         return uint256(get(map._inner, bytes32(uint256(uint160(key)))));
1774     }
1775 
1776     /**
1777      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1778      *
1779      * CAUTION: This function is deprecated because it requires allocating memory for the error
1780      * message unnecessarily. For custom revert reasons use {tryGet}.
1781      */
1782     function get(
1783         AddressToUintMap storage map,
1784         address key,
1785         string memory errorMessage
1786     ) internal view returns (uint256) {
1787         return uint256(get(map._inner, bytes32(uint256(uint160(key))), errorMessage));
1788     }
1789 
1790     // Bytes32ToUintMap
1791 
1792     struct Bytes32ToUintMap {
1793         Bytes32ToBytes32Map _inner;
1794     }
1795 
1796     /**
1797      * @dev Adds a key-value pair to a map, or updates the value for an existing
1798      * key. O(1).
1799      *
1800      * Returns true if the key was added to the map, that is if it was not
1801      * already present.
1802      */
1803     function set(
1804         Bytes32ToUintMap storage map,
1805         bytes32 key,
1806         uint256 value
1807     ) internal returns (bool) {
1808         return set(map._inner, key, bytes32(value));
1809     }
1810 
1811     /**
1812      * @dev Removes a value from a set. O(1).
1813      *
1814      * Returns true if the key was removed from the map, that is if it was present.
1815      */
1816     function remove(Bytes32ToUintMap storage map, bytes32 key) internal returns (bool) {
1817         return remove(map._inner, key);
1818     }
1819 
1820     /**
1821      * @dev Returns true if the key is in the map. O(1).
1822      */
1823     function contains(Bytes32ToUintMap storage map, bytes32 key) internal view returns (bool) {
1824         return contains(map._inner, key);
1825     }
1826 
1827     /**
1828      * @dev Returns the number of elements in the map. O(1).
1829      */
1830     function length(Bytes32ToUintMap storage map) internal view returns (uint256) {
1831         return length(map._inner);
1832     }
1833 
1834     /**
1835      * @dev Returns the element stored at position `index` in the set. O(1).
1836      * Note that there are no guarantees on the ordering of values inside the
1837      * array, and it may change when more values are added or removed.
1838      *
1839      * Requirements:
1840      *
1841      * - `index` must be strictly less than {length}.
1842      */
1843     function at(Bytes32ToUintMap storage map, uint256 index) internal view returns (bytes32, uint256) {
1844         (bytes32 key, bytes32 value) = at(map._inner, index);
1845         return (key, uint256(value));
1846     }
1847 
1848     /**
1849      * @dev Tries to returns the value associated with `key`. O(1).
1850      * Does not revert if `key` is not in the map.
1851      */
1852     function tryGet(Bytes32ToUintMap storage map, bytes32 key) internal view returns (bool, uint256) {
1853         (bool success, bytes32 value) = tryGet(map._inner, key);
1854         return (success, uint256(value));
1855     }
1856 
1857     /**
1858      * @dev Returns the value associated with `key`. O(1).
1859      *
1860      * Requirements:
1861      *
1862      * - `key` must be in the map.
1863      */
1864     function get(Bytes32ToUintMap storage map, bytes32 key) internal view returns (uint256) {
1865         return uint256(get(map._inner, key));
1866     }
1867 
1868     /**
1869      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1870      *
1871      * CAUTION: This function is deprecated because it requires allocating memory for the error
1872      * message unnecessarily. For custom revert reasons use {tryGet}.
1873      */
1874     function get(
1875         Bytes32ToUintMap storage map,
1876         bytes32 key,
1877         string memory errorMessage
1878     ) internal view returns (uint256) {
1879         return uint256(get(map._inner, key, errorMessage));
1880     }
1881 }
1882 
1883 
1884 // File contracts/Crowdfund.sol
1885 
1886 
1887 pragma solidity ^0.8.0;
1888 
1889 enum CrowdfundStatus{ OnSale, Traded, PrizeDrawn, Expired, Stopped }
1890 
1891 struct Crowdfund {
1892     address creator;
1893     address asset;
1894     uint factor;
1895     uint sharePriceWithoutFactor;
1896     uint sharePrice;
1897     uint expirationTime;
1898 
1899     uint supervisionTime;
1900     bool supervised;
1901 
1902     uint soldShares;
1903     EnumerableMap.AddressToUintMap participants;
1904 
1905     uint proxyId;
1906     uint tokenId;
1907     uint tradePrice;
1908     uint tradeShares;
1909     uint changePerShare;
1910     uint revenue;
1911 
1912     uint randNum;
1913     bool cashedNFT;
1914     mapping(address => bool) cashedChange;
1915     CrowdfundStatus status;
1916 }
1917 
1918 struct CrowdfundGetInfo {
1919     address creator;
1920     address asset;
1921     uint factor;
1922     uint sharePriceWithoutFactor;
1923     uint sharePrice;
1924     uint expirationTime;
1925 
1926     uint supervisionTime;
1927     bool supervised;
1928 
1929     uint soldShares;
1930 
1931     uint proxyId;
1932     uint tokenId;
1933     uint tradePrice;
1934     uint tradeShares;
1935     uint changePerShare;
1936     uint revenue;
1937 
1938     uint randNum;
1939     bool cashedNFT;
1940     CrowdfundStatus status;
1941 }
1942 
1943 struct TradeBaseInfo {
1944     address asset;
1945     uint tokenId;
1946     uint tradePrice;
1947 }
1948 
1949 
1950 // File contracts/interface/IProxy.sol
1951 
1952 
1953 pragma solidity ^0.8.0;
1954 
1955 interface IProxy {
1956     function buyNFT(TradeBaseInfo calldata crowdfundInfo, bytes calldata data) external payable;
1957 }
1958 
1959 
1960 // File contracts/Utils.sol
1961 
1962 
1963 pragma solidity ^0.8.0;
1964 
1965 library MoneyUtils {
1966     function transferInMoneyFromSender(address token, uint amount)
1967     internal
1968     {
1969         if (amount > 0) {
1970             if (token == address(0)) {
1971                 require(msg.value >= amount, "not enough");
1972             } else {
1973                 require(IERC20(token).transferFrom(msg.sender, address(this), amount), "transfer in money fail");
1974             }
1975         }
1976     }
1977 }
1978 
1979 library RevertUtils {
1980     /// Reverts, forwarding the return data from the last external call.
1981     /// If there was no preceding external call, reverts with empty returndata.
1982     /// It's up to the caller to ensure that the preceding call actually reverted - if it did not,
1983     /// the return data will come from a successfull call.
1984     ///
1985     /// @dev This function writes to arbitrary memory locations, violating any assumptions the compiler
1986     /// might have about memory use. This may prevent it from doing some kinds of memory optimizations
1987     /// planned in future versions or make them unsafe. It's recommended to obtain the revert data using
1988     /// the try/catch statement and rethrow it with `rawRevert()` instead.
1989     function forwardRevert() internal pure {
1990         assembly {
1991             returndatacopy(0, 0, returndatasize())
1992             revert(0, returndatasize())
1993         }
1994     }
1995 
1996     /// Reverts, directly setting the return data from the provided `bytes` object.
1997     /// Unlike the high-level `revert` statement, this allows forwarding the revert data obtained from
1998     /// a failed external call (high-level `revert` would wrap it in an `Error`).
1999     ///
2000     /// @dev This function is recommended over `forwardRevert()` because it does not interfere with
2001     /// the memory allocation mechanism used by the compiler.
2002     function rawRevert(bytes memory revertData) internal pure {
2003         assembly {
2004         // NOTE: `bytes` arrays in memory start with a 32-byte size slot, which is followed by data.
2005             let revertDataStart := add(revertData, 32)
2006             let revertDataEnd := add(revertDataStart, mload(revertData))
2007             revert(revertDataStart, revertDataEnd)
2008         }
2009     }
2010 }
2011 
2012 //library SendUtils {
2013 //    error EtherTransferFailed();
2014 //
2015 //    function _sendEthViaCall(address payable receiver, uint amount) internal {
2016 //        if (amount > 0) {
2017 //            (bool success, ) = receiver.call{value: amount}("");
2018 //        if (!success)
2019 //            revert EtherTransferFailed();
2020 //        }
2021 //    }
2022 //
2023 //    function _returnAllEth() internal {
2024 //        // NOTE: This works on the assumption that the whole balance of the contract consists of
2025 //        // the ether sent by the caller.
2026 //        // (1) This is never 100% true because anyone can send ether to it with selfdestruct or by using
2027 //        // its address as the coinbase when mining a block. Anyone doing that is doing it to their own
2028 //        // disavantage though so we're going to disregard these possibilities.
2029 //        // (2) For this to be safe we must ensure that no ether is stored in the contract long-term.
2030 //        // It's best if it has no receive function and all payable functions should ensure that they
2031 //        // use the whole balance or send back the remainder.
2032 //        _sendEthViaCall(payable(msg.sender), address(this).balance);
2033 //    }
2034 //
2035 //    function _returnAllToken() internal {
2036 //        _sendEthViaCall(payable(msg.sender), address(this).balance);
2037 //    }
2038 //}
2039 
2040 
2041 // File contracts/LuckyNFT.sol
2042 
2043 // SPDX-License-Identifier: MIT
2044 pragma solidity ^0.8.0;
2045 
2046 
2047 contract LuckyNFT is Ownable, IERC721Receiver, ReentrancyGuard, VRFConsumerBaseV2 {
2048 
2049     using SafeMath for uint;
2050     using EnumerableMap for EnumerableMap.AddressToUintMap;
2051 
2052     uint constant MAX_UINT = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
2053 
2054     address public treasury;
2055     address public trader;
2056     uint public revenue;
2057 
2058     bool public open;
2059     uint public factor = 11000;
2060     uint constant factorBase = 10000;
2061     uint public supervisionLockTime = 90 days;
2062 
2063     uint public nextProxyId = 1;
2064     mapping(uint => address) public proxies;
2065     mapping(uint => bool) public proxyStatus;
2066 
2067     uint public nextCrowdfundId = 1;
2068     mapping(uint => Crowdfund) internal crowdfunds;
2069 
2070     mapping(address => bool) public assets;
2071 
2072     address public vrfCoordinator;
2073     uint64 public vrfSubId;
2074     bytes32 public vrfKeyHash;
2075     uint32 public vrfCBGasLimit;
2076     uint16 constant vrfReqConfirm = 3;
2077     uint32 constant vrfNumWords = 1;
2078     mapping(uint => uint) public vrfRequestIds;
2079 
2080     // event
2081     event Proxy(address proxy, uint id, bool status);
2082     event Asset(address asset, bool status);
2083     event NewCrowdfund(uint crowdfundId, address asset, uint sharePriceWithoutFactor, uint expirationTime);
2084     event StatusChanged(uint crowdfundId, CrowdfundStatus status);
2085     event Sold(uint crowdfundId, address user, uint quantity);
2086     event NewRevenue(uint crowdfundId, uint newRevenue);
2087     event CasedPrize(uint crowdfundId, address winner, address nft, uint tokenId);
2088     event GotChange(uint crowdfundId, address user, uint amount);
2089     event Withdrawn(uint crowdfundId, address user, uint shareQuantity, uint anount);
2090     event SupervisionLockTimeChanged(uint supervisionLockTime);
2091     event SupervisedNFT(uint crowdfundId, address to, address nft, uint tokenId);
2092     event SupervisedETH(uint crowdfundId, address to, uint anount);
2093 
2094     // modifier
2095     modifier onlyOpening() {
2096         require(open, "only opening");
2097         _;
2098     }
2099 
2100     modifier onlyTreasury() {
2101         require(msg.sender == treasury, "only treasury");
2102         _;
2103     }
2104 
2105     modifier onlyTrader() {
2106         require(msg.sender == trader, "only trader");
2107         _;
2108     }
2109 
2110     constructor(
2111         address treasury_,
2112         address trader_,
2113         address vrfCoordinator_,
2114         uint64 vrfSubId_,
2115         bytes32 vrfKeyHash_,
2116         uint32 vrfCBGasLimit_
2117     )
2118     VRFConsumerBaseV2(vrfCoordinator_)
2119     {
2120         treasury = treasury_;
2121         trader = trader_;
2122         vrfCoordinator = vrfCoordinator_;
2123         vrfSubId = vrfSubId_;
2124         vrfKeyHash = vrfKeyHash_;
2125         vrfCBGasLimit = vrfCBGasLimit_;
2126     }
2127 
2128     function SetOpen(
2129         bool open_
2130     )
2131     external
2132     onlyOwner
2133     {
2134         open = open_;
2135     }
2136 
2137     function SetFactor(
2138         uint factor_
2139     )
2140     external
2141     onlyOwner
2142     {
2143         require(factor_ >= factorBase, "invalid factor");
2144         factor = factor_;
2145     }
2146 
2147     function setSupervisionLockTime(
2148         uint supervisionLockTime_
2149     )
2150     external
2151     onlyOwner
2152     {
2153         require(supervisionLockTime_ != 0, "invalid supervision lock time");
2154         supervisionLockTime = supervisionLockTime_;
2155         emit SupervisionLockTimeChanged(supervisionLockTime);
2156     }
2157 
2158     function SetTreasury(
2159         address treasury_
2160     )
2161     external
2162     onlyOwner
2163     {
2164         treasury = treasury_;
2165     }
2166 
2167     function SetTrader(
2168         address trader_
2169     )
2170     external
2171     onlyOwner
2172     {
2173         trader = trader_;
2174     }
2175 
2176     function RegisterProxy(
2177         address proxy
2178     )
2179     external
2180     onlyOwner
2181     {
2182         proxies[nextProxyId] = proxy;
2183         proxyStatus[nextProxyId] = true;
2184         emit Proxy(proxy, nextProxyId, true);
2185         nextProxyId++;
2186     }
2187 
2188     function UnregisterProxy(
2189         uint id
2190     )
2191     external
2192     onlyOwner
2193     {
2194         require(id != 0 && id < nextProxyId, "invalid proxy id");
2195         require(proxyStatus[id], "unregisted already");
2196 
2197         proxyStatus[id] = false;
2198         emit Proxy(proxies[id], id, false);
2199     }
2200 
2201     function RegisterAsset(
2202         address asset
2203     )
2204     external
2205     onlyOwner
2206     {
2207         assets[asset] = true;
2208         emit Asset(asset, true);
2209     }
2210 
2211     function UnregisterAsset(
2212         address asset
2213     )
2214     external
2215     onlyOwner
2216     {
2217         assets[asset] = false;
2218         emit Asset(asset, false);
2219     }
2220 
2221     function SetChainlinkVRF(
2222         address vrfCoordinator_,
2223         bytes32 keyHash_,
2224         uint32 callbackGasLimit_,
2225         uint64 subscriptionId_
2226     )
2227     external
2228     onlyOwner
2229     {
2230         vrfCoordinator = vrfCoordinator_;
2231         vrfKeyHash = keyHash_;
2232         vrfCBGasLimit = callbackGasLimit_;
2233         vrfSubId = subscriptionId_;
2234     }
2235 
2236     function WithdrawRevenue(
2237         address to,
2238         uint amount
2239     )
2240     external
2241     onlyTreasury
2242     {
2243         require(amount <= revenue, "invalid amount");
2244         revenue -= amount;
2245         payable(to).transfer(amount);
2246     }
2247 
2248     function Supervise(
2249         uint crowdfundId,
2250         address to
2251     )
2252     external
2253     onlyTreasury
2254     {
2255         doSupervise_(crowdfundId, to);
2256     }
2257 
2258     function SuperviseMulti(
2259         uint[] memory crowdfundIds,
2260         address to
2261     )
2262     external
2263     onlyTreasury
2264     {
2265         for (uint i = 0; i < crowdfundIds.length; i++) {
2266             doSupervise_(crowdfundIds[i], to);
2267         }
2268     }
2269 
2270     function CreateCrowdfund(
2271         address asset,
2272         uint sharePriceWithoutFactor,
2273         uint expirationTime,
2274         uint buyQuantity
2275     )
2276     external
2277     payable
2278     onlyOpening
2279     nonReentrant
2280     {
2281         require(asset != address(0), "invalid asset");
2282         require(assets[asset], "asset unregistered");
2283         require(sharePriceWithoutFactor != 0, "invalid share price");
2284         require(block.timestamp < expirationTime, "invalid expiration time");
2285         require(buyQuantity != 0, "invalid buy shares");
2286 
2287         Crowdfund storage crowdfund = crowdfunds[nextCrowdfundId];
2288         crowdfund.creator = msg.sender;
2289         crowdfund.factor = factor;
2290         crowdfund.asset = asset;
2291         crowdfund.sharePriceWithoutFactor = sharePriceWithoutFactor;
2292         crowdfund.expirationTime = expirationTime;
2293         crowdfund.supervisionTime = MAX_UINT;
2294         crowdfund.status = CrowdfundStatus.OnSale;
2295 
2296         (bool suc, uint sharePrice) = sharePriceWithoutFactor.tryMul(factor);
2297         require(suc, "uint tryMul fail");
2298 
2299         sharePrice = sharePrice.div(factorBase);
2300         crowdfund.sharePrice = sharePrice;
2301 
2302         emit NewCrowdfund(nextCrowdfundId, asset, sharePriceWithoutFactor, expirationTime);
2303         emit StatusChanged(nextCrowdfundId, CrowdfundStatus.OnSale);
2304 
2305         buyShares_(nextCrowdfundId, crowdfund, buyQuantity);
2306         nextCrowdfundId++;
2307     }
2308 
2309     function BuyShares(
2310         uint crowdfundId,
2311         uint buyQuantity
2312     )
2313     external
2314     payable
2315     onlyOpening
2316     nonReentrant
2317     {
2318         Crowdfund storage crowdfund = getCrowdfundFromId_(crowdfundId);
2319         require(block.timestamp < crowdfund.expirationTime, "expired");
2320         require(crowdfund.status == CrowdfundStatus.OnSale, "invalid crowdfund status");
2321         require(buyQuantity != 0, "invalid buy quantity");
2322 
2323         buyShares_(crowdfundId, crowdfund, buyQuantity);
2324     }
2325 
2326     function Trade(
2327         uint crowdfundId,
2328         uint proxyId,
2329         uint tokenId,
2330         uint tradePrice,
2331         bytes calldata data
2332     )
2333     external
2334     onlyTrader
2335     nonReentrant
2336     {
2337         Crowdfund storage crowdfund = getCrowdfundFromId_(crowdfundId);
2338         require(block.timestamp < crowdfund.expirationTime, "expired");
2339         require(crowdfund.status == CrowdfundStatus.OnSale, "invalid crowdfund status");
2340         require(assets[crowdfund.asset], "invalid asset");
2341         require(tradePrice <= crowdfund.sharePriceWithoutFactor.mul(crowdfund.soldShares), "invalid trade price");
2342         require(IERC721(crowdfund.asset).ownerOf(tokenId) != address(this), "have owned NFT already");
2343 
2344         address proxy = proxies[proxyId];
2345         require(proxy != address(0), "invalid proxy address");
2346         require(proxyStatus[proxyId], "invalid proxy status");
2347 
2348         TradeBaseInfo memory baseInfo = TradeBaseInfo(
2349             crowdfund.asset,
2350             tokenId,
2351             tradePrice
2352         );
2353 
2354         try IProxy(proxy).buyNFT{value: tradePrice}(
2355             baseInfo,
2356             data
2357         ) {
2358             require(IERC721(baseInfo.asset).ownerOf(tokenId) == address(this), "dont own NFT");
2359             crowdfund.status = CrowdfundStatus.Traded;
2360             crowdfund.supervisionTime = block.timestamp + supervisionLockTime;
2361             crowdfund.proxyId = proxyId;
2362             crowdfund.tokenId = tokenId;
2363             crowdfund.tradePrice = tradePrice;
2364             updateRevenue_(crowdfundId, crowdfund);
2365 
2366             uint requestId = VRFCoordinatorV2Interface(vrfCoordinator).requestRandomWords(
2367                 vrfKeyHash,
2368                 vrfSubId,
2369                 vrfReqConfirm,
2370                 vrfCBGasLimit,
2371                 vrfNumWords
2372             );
2373 
2374             vrfRequestIds[requestId] = crowdfundId;
2375         } catch (bytes memory lowLevelData) {
2376             RevertUtils.rawRevert(lowLevelData);
2377         }
2378     }
2379 
2380     function CashPrize(
2381         uint crowdfundId
2382     )
2383     external
2384     nonReentrant
2385     {
2386         Crowdfund storage crowdfund = getCrowdfundFromId_(crowdfundId);
2387         require(!crowdfund.supervised, "have moved to treasury");
2388         require(crowdfund.status == CrowdfundStatus.PrizeDrawn, "invalid crowdfund status");
2389 
2390         address winner = fixWinner_(crowdfund);
2391         require(msg.sender == winner, "is not winner");
2392 
2393         // transfer nft
2394         if (!crowdfund.cashedNFT) {
2395             crowdfund.cashedNFT = true;
2396             IERC721(crowdfund.asset).transferFrom(address(this), winner, crowdfund.tokenId);
2397             emit CasedPrize(crowdfundId, winner, crowdfund.asset, crowdfund.tokenId);
2398         }
2399 
2400         // transfer change
2401         if (!crowdfund.cashedChange[winner]) {
2402             uint shareQuantity;
2403             (, shareQuantity) = crowdfund.participants.tryGet(winner);
2404             (bool suc, uint change) = shareQuantity.tryMul(crowdfund.changePerShare);
2405             require(suc, "tryMul fail");
2406 
2407             crowdfund.cashedChange[winner] = true;
2408             if (change > 0) {
2409                 payable(winner).transfer(change);
2410             }
2411 
2412             emit GotChange(crowdfundId, winner, change);
2413         }
2414     }
2415 
2416     function GetChange(
2417         uint crowdfundId
2418     )
2419     external
2420     nonReentrant
2421     {
2422         Crowdfund storage crowdfund = getCrowdfundFromId_(crowdfundId);
2423         require(crowdfund.status == CrowdfundStatus.PrizeDrawn, "invalid crowdfund status");
2424         require(!crowdfund.supervised, "have moved to treasury");
2425         require(!crowdfund.cashedChange[msg.sender], "have gotten change already");
2426         getOneCrowdfundChange_(crowdfundId, crowdfund);
2427     }
2428 
2429     function GetMultiChanges(
2430         uint[] calldata crowdfundIds
2431     )
2432     external
2433     nonReentrant
2434     {
2435         for (uint i = 0; i < crowdfundIds.length; i++) {
2436             Crowdfund storage crowdfund = getCrowdfundFromId_(crowdfundIds[i]);
2437             require(crowdfund.status == CrowdfundStatus.PrizeDrawn, "invalid crowdfund status");
2438             require(!crowdfund.supervised, "have moved to treasury");
2439             require(!crowdfund.cashedChange[msg.sender], "have gotten change already");
2440             getOneCrowdfundChange_(crowdfundIds[i], crowdfund);
2441         }
2442     }
2443 
2444     function Withdraw(
2445         uint crowdfundId
2446     )
2447     external
2448     nonReentrant
2449     {
2450         Crowdfund storage crowdfund = getCrowdfundFromId_(crowdfundId);
2451         require(!crowdfund.supervised, "have moved to treasury");
2452         checkExpiration_(crowdfundId, crowdfund);
2453 
2454         require(crowdfund.status == CrowdfundStatus.Expired || crowdfund.status == CrowdfundStatus.Stopped, "invalid crowdfund status");
2455         require(!crowdfund.cashedChange[msg.sender], "have withdrawn already");
2456 
2457         (bool suc, uint shareQuantity) = crowdfund.participants.tryGet(msg.sender);
2458         require(suc, "is not participant");
2459 
2460         uint money;
2461         (suc, money) = shareQuantity.tryMul(crowdfund.sharePrice);
2462         require(suc, "tryMul fail");
2463 
2464         crowdfund.cashedChange[msg.sender] = true;
2465         payable(msg.sender).transfer(money);
2466         emit Withdrawn(crowdfundId, msg.sender, shareQuantity, money);
2467     }
2468 
2469     function Stop(
2470         uint crowdfundId
2471     )
2472     external
2473     onlyOwner
2474     {
2475         Crowdfund storage crowdfund = getCrowdfundFromId_(crowdfundId);
2476         require(crowdfund.status == CrowdfundStatus.OnSale, "invalid crowdfund status");
2477         crowdfund.status = CrowdfundStatus.Stopped;
2478         crowdfund.supervisionTime = block.timestamp + supervisionLockTime;
2479         emit StatusChanged(crowdfundId, CrowdfundStatus.Stopped);
2480     }
2481 
2482     function GetCrowdfund(
2483         uint crowdfundId
2484     )
2485     public
2486     view
2487     returns (CrowdfundGetInfo memory)
2488     {
2489         Crowdfund storage crowdfund = getCrowdfundFromId_(crowdfundId);
2490 
2491         CrowdfundGetInfo memory info = CrowdfundGetInfo(
2492             crowdfund.creator,
2493             crowdfund.asset,
2494             crowdfund.factor,
2495             crowdfund.sharePriceWithoutFactor,
2496             crowdfund.sharePrice,
2497             crowdfund.expirationTime,
2498 
2499             crowdfund.supervisionTime,
2500             crowdfund.supervised,
2501 
2502             crowdfund.soldShares,
2503 
2504             crowdfund.proxyId,
2505             crowdfund.tokenId,
2506             crowdfund.tradePrice,
2507             crowdfund.tradeShares,
2508             crowdfund.changePerShare,
2509             crowdfund.revenue,
2510 
2511             crowdfund.randNum,
2512             crowdfund.cashedNFT,
2513             crowdfund.status
2514         );
2515 
2516         if (crowdfund.status == CrowdfundStatus.OnSale && block.timestamp >= crowdfund.expirationTime) {
2517             info.status = CrowdfundStatus.Expired;
2518             info.supervisionTime = crowdfund.expirationTime + supervisionLockTime;
2519         }
2520 
2521         return info;
2522     }
2523 
2524     function GetShareQuantity(
2525         uint crowdfundId,
2526         address user
2527     )
2528     public
2529     view
2530     returns (uint)
2531     {
2532         Crowdfund storage crowdfund = getCrowdfundFromId_(crowdfundId);
2533 
2534         uint value;
2535         (, value) = crowdfund.participants.tryGet(user);
2536         return value;
2537     }
2538 
2539     function GetPrize(
2540         uint crowdfundId
2541     )
2542     public
2543     view
2544     returns (CrowdfundStatus, address, uint)
2545     {
2546         Crowdfund storage crowdfund = getCrowdfundFromId_(crowdfundId);
2547         if (crowdfund.status != CrowdfundStatus.PrizeDrawn) {
2548             return (crowdfund.status, address(0), 0);
2549         }
2550 
2551         address winner = fixWinner_(crowdfund);
2552         return (CrowdfundStatus.PrizeDrawn, winner, crowdfund.changePerShare);
2553     }
2554 
2555     function GetUserPrize(
2556         uint crowdfundId,
2557         address user
2558     )
2559     public
2560     view
2561     returns (CrowdfundStatus, bool, uint, bool)
2562     {
2563         Crowdfund storage crowdfund = getCrowdfundFromId_(crowdfundId);
2564 
2565         bool isWinner = false;
2566         if (crowdfund.status == CrowdfundStatus.PrizeDrawn) {
2567             isWinner = fixWinner_(crowdfund) == user;
2568         }
2569 
2570         uint shareQuantity;
2571         (, shareQuantity) = crowdfund.participants.tryGet(user);
2572 
2573         uint changeValue = 0;
2574         if (crowdfund.status == CrowdfundStatus.PrizeDrawn) {
2575             changeValue = shareQuantity.mul(crowdfund.changePerShare);
2576         } else if (crowdfund.status > CrowdfundStatus.PrizeDrawn) {
2577             changeValue = shareQuantity.mul(crowdfund.sharePrice);
2578         }
2579 
2580         return (crowdfund.status, isWinner, changeValue, crowdfund.cashedChange[user]);
2581     }
2582 
2583     function GetSuperviseAssets(
2584         uint crowdfundId
2585     )
2586     public
2587     view
2588     returns (bool, uint) {
2589         Crowdfund storage crowdfund = getCrowdfundFromId_(crowdfundId);
2590         if (crowdfund.supervised) {
2591             return (false, 0);
2592         }
2593 
2594         if (block.timestamp >= crowdfund.supervisionTime
2595             || (crowdfund.status == CrowdfundStatus.OnSale
2596             && block.timestamp >= (crowdfund.expirationTime + supervisionLockTime)))
2597         {
2598             bool leftNFT = (crowdfund.status == CrowdfundStatus.Traded
2599             || crowdfund.status == CrowdfundStatus.PrizeDrawn)
2600             && (!crowdfund.cashedNFT);
2601             uint leftAmount = getLeftETHAmount_(crowdfund);
2602             return (leftNFT, leftAmount);
2603         }
2604 
2605         return (false, 0);
2606     }
2607 
2608     // --------------- internal functions ---------------
2609     function doSupervise_(
2610         uint crowdfundId,
2611         address to
2612     )
2613     internal
2614     {
2615         Crowdfund storage crowdfund = getCrowdfundFromId_(crowdfundId);
2616         require(!crowdfund.supervised, "have moved to treasury");
2617         checkExpiration_(crowdfundId, crowdfund);
2618 
2619         require(block.timestamp >= crowdfund.supervisionTime, "not yet supervision time");
2620         crowdfund.supervised = true;
2621 
2622         // transfer nft
2623         bool leftNFT = (crowdfund.status == CrowdfundStatus.Traded
2624         || crowdfund.status == CrowdfundStatus.PrizeDrawn)
2625         && (!crowdfund.cashedNFT);
2626         if (leftNFT) {
2627             IERC721(crowdfund.asset).transferFrom(address(this), to, crowdfund.tokenId);
2628             emit SupervisedNFT(crowdfundId, to, crowdfund.asset, crowdfund.tokenId);
2629         }
2630 
2631         // transfer ETH
2632         uint leftAmount = getLeftETHAmount_(crowdfund);
2633         if (leftAmount > 0) {
2634             payable(to).transfer(leftAmount);
2635             emit SupervisedETH(crowdfundId, to, leftAmount);
2636         }
2637     }
2638 
2639     function buyShares_(
2640         uint crowdfundId,
2641         Crowdfund storage crowdfund,
2642         uint quantity
2643     )
2644     internal
2645     {
2646         bool suc;
2647         (suc, crowdfund.soldShares) = crowdfund.soldShares.tryAdd(quantity);
2648         require(suc, "invalid quantity");
2649 
2650         uint amount;
2651         (suc, amount) = crowdfund.sharePrice.tryMul(quantity);
2652         require(suc, "invalid quantity");
2653         MoneyUtils.transferInMoneyFromSender(address(0), amount);
2654 
2655         uint userBuy;
2656         (, userBuy) = crowdfund.participants.tryGet(msg.sender);
2657         (suc, userBuy) = userBuy.tryAdd(quantity);
2658         require(suc, "invalid quantity");
2659 
2660         crowdfund.participants.set(msg.sender, userBuy);
2661         emit Sold(crowdfundId, msg.sender, quantity);
2662     }
2663 
2664     function getCrowdfundFromId_(
2665         uint crowdfundId
2666     )
2667     internal
2668     view
2669     returns (Crowdfund storage)
2670     {
2671         require(crowdfundId > 0 && crowdfundId < nextCrowdfundId, "invalid crowdfund id");
2672         Crowdfund storage crowdfund = crowdfunds[crowdfundId];
2673         return crowdfund;
2674     }
2675 
2676     function fixWinner_(
2677         Crowdfund storage crowdfund
2678     )
2679     internal
2680     view
2681     returns (address)
2682     {
2683         address user;
2684         uint value;
2685         uint offset = crowdfund.randNum%crowdfund.soldShares + 1;
2686         uint length = crowdfund.participants.length();
2687         for (uint i = 0; i < length-1; i++) {
2688             (user, value) = crowdfund.participants.at(i);
2689             if (offset <= value) {
2690                 return user;
2691             }
2692 
2693             offset -= value;
2694             continue;
2695         }
2696 
2697         (user,) = crowdfund.participants.at(length-1);
2698         return user;
2699     }
2700 
2701     function updateRevenue_(
2702         uint crowdfundId,
2703         Crowdfund storage crowdfund
2704     )
2705     internal
2706     {
2707         (bool suc, uint tradeShares) = crowdfund.tradePrice.tryDiv(crowdfund.sharePriceWithoutFactor);
2708         require(suc, "trySub fail");
2709 
2710         if (crowdfund.tradePrice % crowdfund.sharePriceWithoutFactor != 0) {
2711             tradeShares++;
2712         }
2713 
2714         uint totalChange;
2715         (suc, totalChange) = (crowdfund.soldShares - tradeShares).tryMul(crowdfund.sharePrice);
2716         require(suc, "tryMul fail");
2717 
2718         uint changePerShare;
2719         (suc, changePerShare) = totalChange.tryDiv(crowdfund.soldShares);
2720         require(suc, "tryDiv fail");
2721 
2722         uint totalMoney;
2723         (suc, totalMoney) = crowdfund.soldShares.tryMul(crowdfund.sharePrice);
2724 
2725         uint newRevenue;
2726         (suc, newRevenue) = totalMoney.trySub(changePerShare.mul(crowdfund.soldShares).add(crowdfund.tradePrice));
2727         require(suc, "trySub fail");
2728 
2729         (suc, revenue) = revenue.tryAdd(newRevenue);
2730         require(suc, "tryAdd fail");
2731 
2732         crowdfund.tradeShares = tradeShares;
2733         crowdfund.changePerShare = changePerShare;
2734         crowdfund.revenue = newRevenue;
2735         emit NewRevenue(crowdfundId, newRevenue);
2736     }
2737 
2738     function checkExpiration_(
2739         uint crowdfundId,
2740         Crowdfund storage crowdfund
2741     )
2742     internal
2743     {
2744         if (crowdfund.status == CrowdfundStatus.OnSale && block.timestamp >= crowdfund.expirationTime) {
2745             crowdfund.status = CrowdfundStatus.Expired;
2746             crowdfund.supervisionTime = crowdfund.expirationTime + supervisionLockTime;
2747             emit StatusChanged(crowdfundId, CrowdfundStatus.Expired);
2748         }
2749     }
2750 
2751     function getLeftETHAmount_(
2752         Crowdfund storage crowdfund
2753     )
2754     internal
2755     view
2756     returns (uint)
2757     {
2758         uint leftShares;
2759         address user;
2760         uint value;
2761         uint length = crowdfund.participants.length();
2762         for (uint i = 0; i < length; i++)
2763         {
2764             (user, value) = crowdfund.participants.at(i);
2765             if (!crowdfund.cashedChange[user]) {
2766                 leftShares += value;
2767             }
2768         }
2769 
2770         if (crowdfund.status == CrowdfundStatus.Traded
2771             || crowdfund.status == CrowdfundStatus.PrizeDrawn)
2772         {
2773             return crowdfund.changePerShare*leftShares;
2774         } else {
2775             return crowdfund.sharePrice*leftShares;
2776         }
2777     }
2778 
2779     function getOneCrowdfundChange_(
2780         uint crowdfundId,
2781         Crowdfund storage crowdfund
2782     )
2783     internal
2784     {
2785         (bool suc, uint shareQuantity) = crowdfund.participants.tryGet(msg.sender);
2786         require(suc, "is not participant");
2787 
2788         uint change;
2789         (suc, change) = shareQuantity.tryMul(crowdfund.changePerShare);
2790         require(suc, "tryMul fail");
2791 
2792         crowdfund.cashedChange[msg.sender] = true;
2793         if (change > 0) {
2794             payable(msg.sender).transfer(change);
2795         }
2796 
2797         emit GotChange(crowdfundId, msg.sender, change);
2798     }
2799 
2800     // ------------ IERC721Receiver ------------
2801     function onERC721Received(
2802         address operator,
2803         address from,
2804         uint256 tokenId,
2805         bytes calldata data
2806     )
2807     external
2808     override
2809     returns (bytes4)
2810     {
2811         operator;
2812         from;
2813         tokenId;
2814         data;
2815         return IERC721Receiver.onERC721Received.selector;
2816     }
2817 
2818 
2819 
2820     // ------------ Chainlink VRF ------------
2821     function fulfillRandomWords(
2822         uint256 requestId,
2823         uint256[] memory randomWords
2824     )
2825     internal
2826     override
2827     {
2828         uint crowdfundId = vrfRequestIds[requestId];
2829         require(crowdfundId != 0, "invalid crowdfundId");
2830         Crowdfund storage crowdfund = getCrowdfundFromId_(crowdfundId);
2831         crowdfund.randNum = randomWords[0];
2832         crowdfund.supervisionTime = block.timestamp + supervisionLockTime;
2833         crowdfund.status = CrowdfundStatus.PrizeDrawn;
2834         emit StatusChanged(crowdfundId, CrowdfundStatus.PrizeDrawn);
2835     }
2836 }