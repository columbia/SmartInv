1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 // SPDX-License-Identifier: MIT
31 
32 pragma solidity ^0.6.0;
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor () internal {
55         address msgSender = _msgSender();
56         _owner = msgSender;
57         emit OwnershipTransferred(address(0), msgSender);
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(_owner == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         emit OwnershipTransferred(_owner, address(0));
84         _owner = address(0);
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public virtual onlyOwner {
92         require(newOwner != address(0), "Ownable: new owner is the zero address");
93         emit OwnershipTransferred(_owner, newOwner);
94         _owner = newOwner;
95     }
96 }
97 
98 // File: @openzeppelin/contracts/math/SafeMath.sol
99 
100 // SPDX-License-Identifier: MIT
101 
102 pragma solidity ^0.6.0;
103 
104 /**
105  * @dev Wrappers over Solidity's arithmetic operations with added overflow
106  * checks.
107  *
108  * Arithmetic operations in Solidity wrap on overflow. This can easily result
109  * in bugs, because programmers usually assume that an overflow raises an
110  * error, which is the standard behavior in high level programming languages.
111  * `SafeMath` restores this intuition by reverting the transaction when an
112  * operation overflows.
113  *
114  * Using this library instead of the unchecked operations eliminates an entire
115  * class of bugs, so it's recommended to use it always.
116  */
117 library SafeMath {
118     /**
119      * @dev Returns the addition of two unsigned integers, reverting on
120      * overflow.
121      *
122      * Counterpart to Solidity's `+` operator.
123      *
124      * Requirements:
125      *
126      * - Addition cannot overflow.
127      */
128     function add(uint256 a, uint256 b) internal pure returns (uint256) {
129         uint256 c = a + b;
130         require(c >= a, "SafeMath: addition overflow");
131 
132         return c;
133     }
134 
135     /**
136      * @dev Returns the subtraction of two unsigned integers, reverting on
137      * overflow (when the result is negative).
138      *
139      * Counterpart to Solidity's `-` operator.
140      *
141      * Requirements:
142      *
143      * - Subtraction cannot overflow.
144      */
145     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
146         return sub(a, b, "SafeMath: subtraction overflow");
147     }
148 
149     /**
150      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
151      * overflow (when the result is negative).
152      *
153      * Counterpart to Solidity's `-` operator.
154      *
155      * Requirements:
156      *
157      * - Subtraction cannot overflow.
158      */
159     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
160         require(b <= a, errorMessage);
161         uint256 c = a - b;
162 
163         return c;
164     }
165 
166     /**
167      * @dev Returns the multiplication of two unsigned integers, reverting on
168      * overflow.
169      *
170      * Counterpart to Solidity's `*` operator.
171      *
172      * Requirements:
173      *
174      * - Multiplication cannot overflow.
175      */
176     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
177         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
178         // benefit is lost if 'b' is also tested.
179         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
180         if (a == 0) {
181             return 0;
182         }
183 
184         uint256 c = a * b;
185         require(c / a == b, "SafeMath: multiplication overflow");
186 
187         return c;
188     }
189 
190     /**
191      * @dev Returns the integer division of two unsigned integers. Reverts on
192      * division by zero. The result is rounded towards zero.
193      *
194      * Counterpart to Solidity's `/` operator. Note: this function uses a
195      * `revert` opcode (which leaves remaining gas untouched) while Solidity
196      * uses an invalid opcode to revert (consuming all remaining gas).
197      *
198      * Requirements:
199      *
200      * - The divisor cannot be zero.
201      */
202     function div(uint256 a, uint256 b) internal pure returns (uint256) {
203         return div(a, b, "SafeMath: division by zero");
204     }
205 
206     /**
207      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
208      * division by zero. The result is rounded towards zero.
209      *
210      * Counterpart to Solidity's `/` operator. Note: this function uses a
211      * `revert` opcode (which leaves remaining gas untouched) while Solidity
212      * uses an invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
219         require(b > 0, errorMessage);
220         uint256 c = a / b;
221         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
222 
223         return c;
224     }
225 
226     /**
227      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
228      * Reverts when dividing by zero.
229      *
230      * Counterpart to Solidity's `%` operator. This function uses a `revert`
231      * opcode (which leaves remaining gas untouched) while Solidity uses an
232      * invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      *
236      * - The divisor cannot be zero.
237      */
238     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
239         return mod(a, b, "SafeMath: modulo by zero");
240     }
241 
242     /**
243      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
244      * Reverts with custom message when dividing by zero.
245      *
246      * Counterpart to Solidity's `%` operator. This function uses a `revert`
247      * opcode (which leaves remaining gas untouched) while Solidity uses an
248      * invalid opcode to revert (consuming all remaining gas).
249      *
250      * Requirements:
251      *
252      * - The divisor cannot be zero.
253      */
254     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
255         require(b != 0, errorMessage);
256         return a % b;
257     }
258 }
259 
260 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
261 
262 // SPDX-License-Identifier: MIT
263 
264 pragma solidity ^0.6.0;
265 
266 /**
267  * @dev Contract module that helps prevent reentrant calls to a function.
268  *
269  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
270  * available, which can be applied to functions to make sure there are no nested
271  * (reentrant) calls to them.
272  *
273  * Note that because there is a single `nonReentrant` guard, functions marked as
274  * `nonReentrant` may not call one another. This can be worked around by making
275  * those functions `private`, and then adding `external` `nonReentrant` entry
276  * points to them.
277  *
278  * TIP: If you would like to learn more about reentrancy and alternative ways
279  * to protect against it, check out our blog post
280  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
281  */
282 contract ReentrancyGuard {
283     // Booleans are more expensive than uint256 or any type that takes up a full
284     // word because each write operation emits an extra SLOAD to first read the
285     // slot's contents, replace the bits taken up by the boolean, and then write
286     // back. This is the compiler's defense against contract upgrades and
287     // pointer aliasing, and it cannot be disabled.
288 
289     // The values being non-zero value makes deployment a bit more expensive,
290     // but in exchange the refund on every call to nonReentrant will be lower in
291     // amount. Since refunds are capped to a percentage of the total
292     // transaction's gas, it is best to keep them low in cases like this one, to
293     // increase the likelihood of the full refund coming into effect.
294     uint256 private constant _NOT_ENTERED = 1;
295     uint256 private constant _ENTERED = 2;
296 
297     uint256 private _status;
298 
299     constructor () internal {
300         _status = _NOT_ENTERED;
301     }
302 
303     /**
304      * @dev Prevents a contract from calling itself, directly or indirectly.
305      * Calling a `nonReentrant` function from another `nonReentrant`
306      * function is not supported. It is possible to prevent this from happening
307      * by making the `nonReentrant` function external, and make it call a
308      * `private` function that does the actual work.
309      */
310     modifier nonReentrant() {
311         // On the first call to nonReentrant, _notEntered will be true
312         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
313 
314         // Any calls to nonReentrant after this point will fail
315         _status = _ENTERED;
316 
317         _;
318 
319         // By storing the original value once again, a refund is triggered (see
320         // https://eips.ethereum.org/EIPS/eip-2200)
321         _status = _NOT_ENTERED;
322     }
323 }
324 
325 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
326 
327 // SPDX-License-Identifier: MIT
328 
329 pragma solidity ^0.6.0;
330 
331 /**
332  * @dev Interface of the ERC20 standard as defined in the EIP.
333  */
334 interface IERC20 {
335     /**
336      * @dev Returns the amount of tokens in existence.
337      */
338     function totalSupply() external view returns (uint256);
339 
340     /**
341      * @dev Returns the amount of tokens owned by `account`.
342      */
343     function balanceOf(address account) external view returns (uint256);
344 
345     /**
346      * @dev Moves `amount` tokens from the caller's account to `recipient`.
347      *
348      * Returns a boolean value indicating whether the operation succeeded.
349      *
350      * Emits a {Transfer} event.
351      */
352     function transfer(address recipient, uint256 amount) external returns (bool);
353 
354     /**
355      * @dev Returns the remaining number of tokens that `spender` will be
356      * allowed to spend on behalf of `owner` through {transferFrom}. This is
357      * zero by default.
358      *
359      * This value changes when {approve} or {transferFrom} are called.
360      */
361     function allowance(address owner, address spender) external view returns (uint256);
362 
363     /**
364      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
365      *
366      * Returns a boolean value indicating whether the operation succeeded.
367      *
368      * IMPORTANT: Beware that changing an allowance with this method brings the risk
369      * that someone may use both the old and the new allowance by unfortunate
370      * transaction ordering. One possible solution to mitigate this race
371      * condition is to first reduce the spender's allowance to 0 and set the
372      * desired value afterwards:
373      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
374      *
375      * Emits an {Approval} event.
376      */
377     function approve(address spender, uint256 amount) external returns (bool);
378 
379     /**
380      * @dev Moves `amount` tokens from `sender` to `recipient` using the
381      * allowance mechanism. `amount` is then deducted from the caller's
382      * allowance.
383      *
384      * Returns a boolean value indicating whether the operation succeeded.
385      *
386      * Emits a {Transfer} event.
387      */
388     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
389 
390     /**
391      * @dev Emitted when `value` tokens are moved from one account (`from`) to
392      * another (`to`).
393      *
394      * Note that `value` may be zero.
395      */
396     event Transfer(address indexed from, address indexed to, uint256 value);
397 
398     /**
399      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
400      * a call to {approve}. `value` is the new allowance.
401      */
402     event Approval(address indexed owner, address indexed spender, uint256 value);
403 }
404 
405 // File: @openzeppelin/contracts/introspection/IERC165.sol
406 
407 // SPDX-License-Identifier: MIT
408 
409 pragma solidity ^0.6.0;
410 
411 /**
412  * @dev Interface of the ERC165 standard, as defined in the
413  * https://eips.ethereum.org/EIPS/eip-165[EIP].
414  *
415  * Implementers can declare support of contract interfaces, which can then be
416  * queried by others ({ERC165Checker}).
417  *
418  * For an implementation, see {ERC165}.
419  */
420 interface IERC165 {
421     /**
422      * @dev Returns true if this contract implements the interface defined by
423      * `interfaceId`. See the corresponding
424      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
425      * to learn more about how these ids are created.
426      *
427      * This function call must use less than 30 000 gas.
428      */
429     function supportsInterface(bytes4 interfaceId) external view returns (bool);
430 }
431 
432 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
433 
434 // SPDX-License-Identifier: MIT
435 
436 pragma solidity ^0.6.2;
437 
438 
439 /**
440  * @dev Required interface of an ERC721 compliant contract.
441  */
442 interface IERC721 is IERC165 {
443     /**
444      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
445      */
446     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
447 
448     /**
449      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
450      */
451     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
452 
453     /**
454      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
455      */
456     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
457 
458     /**
459      * @dev Returns the number of tokens in ``owner``'s account.
460      */
461     function balanceOf(address owner) external view returns (uint256 balance);
462 
463     /**
464      * @dev Returns the owner of the `tokenId` token.
465      *
466      * Requirements:
467      *
468      * - `tokenId` must exist.
469      */
470     function ownerOf(uint256 tokenId) external view returns (address owner);
471 
472     /**
473      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
474      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
475      *
476      * Requirements:
477      *
478      * - `from` cannot be the zero address.
479      * - `to` cannot be the zero address.
480      * - `tokenId` token must exist and be owned by `from`.
481      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
482      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
483      *
484      * Emits a {Transfer} event.
485      */
486     function safeTransferFrom(address from, address to, uint256 tokenId) external;
487 
488     /**
489      * @dev Transfers `tokenId` token from `from` to `to`.
490      *
491      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
492      *
493      * Requirements:
494      *
495      * - `from` cannot be the zero address.
496      * - `to` cannot be the zero address.
497      * - `tokenId` token must be owned by `from`.
498      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
499      *
500      * Emits a {Transfer} event.
501      */
502     function transferFrom(address from, address to, uint256 tokenId) external;
503 
504     /**
505      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
506      * The approval is cleared when the token is transferred.
507      *
508      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
509      *
510      * Requirements:
511      *
512      * - The caller must own the token or be an approved operator.
513      * - `tokenId` must exist.
514      *
515      * Emits an {Approval} event.
516      */
517     function approve(address to, uint256 tokenId) external;
518 
519     /**
520      * @dev Returns the account approved for `tokenId` token.
521      *
522      * Requirements:
523      *
524      * - `tokenId` must exist.
525      */
526     function getApproved(uint256 tokenId) external view returns (address operator);
527 
528     /**
529      * @dev Approve or remove `operator` as an operator for the caller.
530      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
531      *
532      * Requirements:
533      *
534      * - The `operator` cannot be the caller.
535      *
536      * Emits an {ApprovalForAll} event.
537      */
538     function setApprovalForAll(address operator, bool _approved) external;
539 
540     /**
541      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
542      *
543      * See {setApprovalForAll}
544      */
545     function isApprovedForAll(address owner, address operator) external view returns (bool);
546 
547     /**
548       * @dev Safely transfers `tokenId` token from `from` to `to`.
549       *
550       * Requirements:
551       *
552      * - `from` cannot be the zero address.
553      * - `to` cannot be the zero address.
554       * - `tokenId` token must exist and be owned by `from`.
555       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
556       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
557       *
558       * Emits a {Transfer} event.
559       */
560     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
561 }
562 
563 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
564 
565 // SPDX-License-Identifier: MIT
566 
567 pragma solidity ^0.6.2;
568 
569 
570 /**
571  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
572  * @dev See https://eips.ethereum.org/EIPS/eip-721
573  */
574 interface IERC721Metadata is IERC721 {
575 
576     /**
577      * @dev Returns the token collection name.
578      */
579     function name() external view returns (string memory);
580 
581     /**
582      * @dev Returns the token collection symbol.
583      */
584     function symbol() external view returns (string memory);
585 
586     /**
587      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
588      */
589     function tokenURI(uint256 tokenId) external view returns (string memory);
590 }
591 
592 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
593 
594 // SPDX-License-Identifier: MIT
595 
596 pragma solidity ^0.6.2;
597 
598 
599 /**
600  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
601  * @dev See https://eips.ethereum.org/EIPS/eip-721
602  */
603 interface IERC721Enumerable is IERC721 {
604 
605     /**
606      * @dev Returns the total amount of tokens stored by the contract.
607      */
608     function totalSupply() external view returns (uint256);
609 
610     /**
611      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
612      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
613      */
614     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
615 
616     /**
617      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
618      * Use along with {totalSupply} to enumerate all tokens.
619      */
620     function tokenByIndex(uint256 index) external view returns (uint256);
621 }
622 
623 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
624 
625 // SPDX-License-Identifier: MIT
626 
627 pragma solidity ^0.6.0;
628 
629 /**
630  * @title ERC721 token receiver interface
631  * @dev Interface for any contract that wants to support safeTransfers
632  * from ERC721 asset contracts.
633  */
634 interface IERC721Receiver {
635     /**
636      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
637      * by `operator` from `from`, this function is called.
638      *
639      * It must return its Solidity selector to confirm the token transfer.
640      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
641      *
642      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
643      */
644     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
645     external returns (bytes4);
646 }
647 
648 // File: @openzeppelin/contracts/introspection/ERC165.sol
649 
650 // SPDX-License-Identifier: MIT
651 
652 pragma solidity ^0.6.0;
653 
654 
655 /**
656  * @dev Implementation of the {IERC165} interface.
657  *
658  * Contracts may inherit from this and call {_registerInterface} to declare
659  * their support of an interface.
660  */
661 contract ERC165 is IERC165 {
662     /*
663      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
664      */
665     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
666 
667     /**
668      * @dev Mapping of interface ids to whether or not it's supported.
669      */
670     mapping(bytes4 => bool) private _supportedInterfaces;
671 
672     constructor () internal {
673         // Derived contracts need only register support for their own interfaces,
674         // we register support for ERC165 itself here
675         _registerInterface(_INTERFACE_ID_ERC165);
676     }
677 
678     /**
679      * @dev See {IERC165-supportsInterface}.
680      *
681      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
682      */
683     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
684         return _supportedInterfaces[interfaceId];
685     }
686 
687     /**
688      * @dev Registers the contract as an implementer of the interface defined by
689      * `interfaceId`. Support of the actual ERC165 interface is automatic and
690      * registering its interface id is not required.
691      *
692      * See {IERC165-supportsInterface}.
693      *
694      * Requirements:
695      *
696      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
697      */
698     function _registerInterface(bytes4 interfaceId) internal virtual {
699         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
700         _supportedInterfaces[interfaceId] = true;
701     }
702 }
703 
704 // File: @openzeppelin/contracts/utils/Address.sol
705 
706 // SPDX-License-Identifier: MIT
707 
708 pragma solidity ^0.6.2;
709 
710 /**
711  * @dev Collection of functions related to the address type
712  */
713 library Address {
714     /**
715      * @dev Returns true if `account` is a contract.
716      *
717      * [IMPORTANT]
718      * ====
719      * It is unsafe to assume that an address for which this function returns
720      * false is an externally-owned account (EOA) and not a contract.
721      *
722      * Among others, `isContract` will return false for the following
723      * types of addresses:
724      *
725      *  - an externally-owned account
726      *  - a contract in construction
727      *  - an address where a contract will be created
728      *  - an address where a contract lived, but was destroyed
729      * ====
730      */
731     function isContract(address account) internal view returns (bool) {
732         // This method relies in extcodesize, which returns 0 for contracts in
733         // construction, since the code is only stored at the end of the
734         // constructor execution.
735 
736         uint256 size;
737         // solhint-disable-next-line no-inline-assembly
738         assembly { size := extcodesize(account) }
739         return size > 0;
740     }
741 
742     /**
743      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
744      * `recipient`, forwarding all available gas and reverting on errors.
745      *
746      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
747      * of certain opcodes, possibly making contracts go over the 2300 gas limit
748      * imposed by `transfer`, making them unable to receive funds via
749      * `transfer`. {sendValue} removes this limitation.
750      *
751      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
752      *
753      * IMPORTANT: because control is transferred to `recipient`, care must be
754      * taken to not create reentrancy vulnerabilities. Consider using
755      * {ReentrancyGuard} or the
756      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
757      */
758     function sendValue(address payable recipient, uint256 amount) internal {
759         require(address(this).balance >= amount, "Address: insufficient balance");
760 
761         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
762         (bool success, ) = recipient.call{ value: amount }("");
763         require(success, "Address: unable to send value, recipient may have reverted");
764     }
765 
766     /**
767      * @dev Performs a Solidity function call using a low level `call`. A
768      * plain`call` is an unsafe replacement for a function call: use this
769      * function instead.
770      *
771      * If `target` reverts with a revert reason, it is bubbled up by this
772      * function (like regular Solidity function calls).
773      *
774      * Returns the raw returned data. To convert to the expected return value,
775      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
776      *
777      * Requirements:
778      *
779      * - `target` must be a contract.
780      * - calling `target` with `data` must not revert.
781      *
782      * _Available since v3.1._
783      */
784     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
785       return functionCall(target, data, "Address: low-level call failed");
786     }
787 
788     /**
789      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
790      * `errorMessage` as a fallback revert reason when `target` reverts.
791      *
792      * _Available since v3.1._
793      */
794     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
795         return _functionCallWithValue(target, data, 0, errorMessage);
796     }
797 
798     /**
799      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
800      * but also transferring `value` wei to `target`.
801      *
802      * Requirements:
803      *
804      * - the calling contract must have an ETH balance of at least `value`.
805      * - the called Solidity function must be `payable`.
806      *
807      * _Available since v3.1._
808      */
809     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
810         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
811     }
812 
813     /**
814      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
815      * with `errorMessage` as a fallback revert reason when `target` reverts.
816      *
817      * _Available since v3.1._
818      */
819     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
820         require(address(this).balance >= value, "Address: insufficient balance for call");
821         return _functionCallWithValue(target, data, value, errorMessage);
822     }
823 
824     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
825         require(isContract(target), "Address: call to non-contract");
826 
827         // solhint-disable-next-line avoid-low-level-calls
828         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
829         if (success) {
830             return returndata;
831         } else {
832             // Look for revert reason and bubble it up if present
833             if (returndata.length > 0) {
834                 // The easiest way to bubble the revert reason is using memory via assembly
835 
836                 // solhint-disable-next-line no-inline-assembly
837                 assembly {
838                     let returndata_size := mload(returndata)
839                     revert(add(32, returndata), returndata_size)
840                 }
841             } else {
842                 revert(errorMessage);
843             }
844         }
845     }
846 }
847 
848 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
849 
850 // SPDX-License-Identifier: MIT
851 
852 pragma solidity ^0.6.0;
853 
854 /**
855  * @dev Library for managing
856  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
857  * types.
858  *
859  * Sets have the following properties:
860  *
861  * - Elements are added, removed, and checked for existence in constant time
862  * (O(1)).
863  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
864  *
865  * ```
866  * contract Example {
867  *     // Add the library methods
868  *     using EnumerableSet for EnumerableSet.AddressSet;
869  *
870  *     // Declare a set state variable
871  *     EnumerableSet.AddressSet private mySet;
872  * }
873  * ```
874  *
875  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
876  * (`UintSet`) are supported.
877  */
878 library EnumerableSet {
879     // To implement this library for multiple types with as little code
880     // repetition as possible, we write it in terms of a generic Set type with
881     // bytes32 values.
882     // The Set implementation uses private functions, and user-facing
883     // implementations (such as AddressSet) are just wrappers around the
884     // underlying Set.
885     // This means that we can only create new EnumerableSets for types that fit
886     // in bytes32.
887 
888     struct Set {
889         // Storage of set values
890         bytes32[] _values;
891 
892         // Position of the value in the `values` array, plus 1 because index 0
893         // means a value is not in the set.
894         mapping (bytes32 => uint256) _indexes;
895     }
896 
897     /**
898      * @dev Add a value to a set. O(1).
899      *
900      * Returns true if the value was added to the set, that is if it was not
901      * already present.
902      */
903     function _add(Set storage set, bytes32 value) private returns (bool) {
904         if (!_contains(set, value)) {
905             set._values.push(value);
906             // The value is stored at length-1, but we add 1 to all indexes
907             // and use 0 as a sentinel value
908             set._indexes[value] = set._values.length;
909             return true;
910         } else {
911             return false;
912         }
913     }
914 
915     /**
916      * @dev Removes a value from a set. O(1).
917      *
918      * Returns true if the value was removed from the set, that is if it was
919      * present.
920      */
921     function _remove(Set storage set, bytes32 value) private returns (bool) {
922         // We read and store the value's index to prevent multiple reads from the same storage slot
923         uint256 valueIndex = set._indexes[value];
924 
925         if (valueIndex != 0) { // Equivalent to contains(set, value)
926             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
927             // the array, and then remove the last element (sometimes called as 'swap and pop').
928             // This modifies the order of the array, as noted in {at}.
929 
930             uint256 toDeleteIndex = valueIndex - 1;
931             uint256 lastIndex = set._values.length - 1;
932 
933             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
934             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
935 
936             bytes32 lastvalue = set._values[lastIndex];
937 
938             // Move the last value to the index where the value to delete is
939             set._values[toDeleteIndex] = lastvalue;
940             // Update the index for the moved value
941             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
942 
943             // Delete the slot where the moved value was stored
944             set._values.pop();
945 
946             // Delete the index for the deleted slot
947             delete set._indexes[value];
948 
949             return true;
950         } else {
951             return false;
952         }
953     }
954 
955     /**
956      * @dev Returns true if the value is in the set. O(1).
957      */
958     function _contains(Set storage set, bytes32 value) private view returns (bool) {
959         return set._indexes[value] != 0;
960     }
961 
962     /**
963      * @dev Returns the number of values on the set. O(1).
964      */
965     function _length(Set storage set) private view returns (uint256) {
966         return set._values.length;
967     }
968 
969    /**
970     * @dev Returns the value stored at position `index` in the set. O(1).
971     *
972     * Note that there are no guarantees on the ordering of values inside the
973     * array, and it may change when more values are added or removed.
974     *
975     * Requirements:
976     *
977     * - `index` must be strictly less than {length}.
978     */
979     function _at(Set storage set, uint256 index) private view returns (bytes32) {
980         require(set._values.length > index, "EnumerableSet: index out of bounds");
981         return set._values[index];
982     }
983 
984     // AddressSet
985 
986     struct AddressSet {
987         Set _inner;
988     }
989 
990     /**
991      * @dev Add a value to a set. O(1).
992      *
993      * Returns true if the value was added to the set, that is if it was not
994      * already present.
995      */
996     function add(AddressSet storage set, address value) internal returns (bool) {
997         return _add(set._inner, bytes32(uint256(value)));
998     }
999 
1000     /**
1001      * @dev Removes a value from a set. O(1).
1002      *
1003      * Returns true if the value was removed from the set, that is if it was
1004      * present.
1005      */
1006     function remove(AddressSet storage set, address value) internal returns (bool) {
1007         return _remove(set._inner, bytes32(uint256(value)));
1008     }
1009 
1010     /**
1011      * @dev Returns true if the value is in the set. O(1).
1012      */
1013     function contains(AddressSet storage set, address value) internal view returns (bool) {
1014         return _contains(set._inner, bytes32(uint256(value)));
1015     }
1016 
1017     /**
1018      * @dev Returns the number of values in the set. O(1).
1019      */
1020     function length(AddressSet storage set) internal view returns (uint256) {
1021         return _length(set._inner);
1022     }
1023 
1024    /**
1025     * @dev Returns the value stored at position `index` in the set. O(1).
1026     *
1027     * Note that there are no guarantees on the ordering of values inside the
1028     * array, and it may change when more values are added or removed.
1029     *
1030     * Requirements:
1031     *
1032     * - `index` must be strictly less than {length}.
1033     */
1034     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1035         return address(uint256(_at(set._inner, index)));
1036     }
1037 
1038 
1039     // UintSet
1040 
1041     struct UintSet {
1042         Set _inner;
1043     }
1044 
1045     /**
1046      * @dev Add a value to a set. O(1).
1047      *
1048      * Returns true if the value was added to the set, that is if it was not
1049      * already present.
1050      */
1051     function add(UintSet storage set, uint256 value) internal returns (bool) {
1052         return _add(set._inner, bytes32(value));
1053     }
1054 
1055     /**
1056      * @dev Removes a value from a set. O(1).
1057      *
1058      * Returns true if the value was removed from the set, that is if it was
1059      * present.
1060      */
1061     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1062         return _remove(set._inner, bytes32(value));
1063     }
1064 
1065     /**
1066      * @dev Returns true if the value is in the set. O(1).
1067      */
1068     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1069         return _contains(set._inner, bytes32(value));
1070     }
1071 
1072     /**
1073      * @dev Returns the number of values on the set. O(1).
1074      */
1075     function length(UintSet storage set) internal view returns (uint256) {
1076         return _length(set._inner);
1077     }
1078 
1079    /**
1080     * @dev Returns the value stored at position `index` in the set. O(1).
1081     *
1082     * Note that there are no guarantees on the ordering of values inside the
1083     * array, and it may change when more values are added or removed.
1084     *
1085     * Requirements:
1086     *
1087     * - `index` must be strictly less than {length}.
1088     */
1089     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1090         return uint256(_at(set._inner, index));
1091     }
1092 }
1093 
1094 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1095 
1096 // SPDX-License-Identifier: MIT
1097 
1098 pragma solidity ^0.6.0;
1099 
1100 /**
1101  * @dev Library for managing an enumerable variant of Solidity's
1102  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1103  * type.
1104  *
1105  * Maps have the following properties:
1106  *
1107  * - Entries are added, removed, and checked for existence in constant time
1108  * (O(1)).
1109  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1110  *
1111  * ```
1112  * contract Example {
1113  *     // Add the library methods
1114  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1115  *
1116  *     // Declare a set state variable
1117  *     EnumerableMap.UintToAddressMap private myMap;
1118  * }
1119  * ```
1120  *
1121  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1122  * supported.
1123  */
1124 library EnumerableMap {
1125     // To implement this library for multiple types with as little code
1126     // repetition as possible, we write it in terms of a generic Map type with
1127     // bytes32 keys and values.
1128     // The Map implementation uses private functions, and user-facing
1129     // implementations (such as Uint256ToAddressMap) are just wrappers around
1130     // the underlying Map.
1131     // This means that we can only create new EnumerableMaps for types that fit
1132     // in bytes32.
1133 
1134     struct MapEntry {
1135         bytes32 _key;
1136         bytes32 _value;
1137     }
1138 
1139     struct Map {
1140         // Storage of map keys and values
1141         MapEntry[] _entries;
1142 
1143         // Position of the entry defined by a key in the `entries` array, plus 1
1144         // because index 0 means a key is not in the map.
1145         mapping (bytes32 => uint256) _indexes;
1146     }
1147 
1148     /**
1149      * @dev Adds a key-value pair to a map, or updates the value for an existing
1150      * key. O(1).
1151      *
1152      * Returns true if the key was added to the map, that is if it was not
1153      * already present.
1154      */
1155     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1156         // We read and store the key's index to prevent multiple reads from the same storage slot
1157         uint256 keyIndex = map._indexes[key];
1158 
1159         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1160             map._entries.push(MapEntry({ _key: key, _value: value }));
1161             // The entry is stored at length-1, but we add 1 to all indexes
1162             // and use 0 as a sentinel value
1163             map._indexes[key] = map._entries.length;
1164             return true;
1165         } else {
1166             map._entries[keyIndex - 1]._value = value;
1167             return false;
1168         }
1169     }
1170 
1171     /**
1172      * @dev Removes a key-value pair from a map. O(1).
1173      *
1174      * Returns true if the key was removed from the map, that is if it was present.
1175      */
1176     function _remove(Map storage map, bytes32 key) private returns (bool) {
1177         // We read and store the key's index to prevent multiple reads from the same storage slot
1178         uint256 keyIndex = map._indexes[key];
1179 
1180         if (keyIndex != 0) { // Equivalent to contains(map, key)
1181             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1182             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1183             // This modifies the order of the array, as noted in {at}.
1184 
1185             uint256 toDeleteIndex = keyIndex - 1;
1186             uint256 lastIndex = map._entries.length - 1;
1187 
1188             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1189             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1190 
1191             MapEntry storage lastEntry = map._entries[lastIndex];
1192 
1193             // Move the last entry to the index where the entry to delete is
1194             map._entries[toDeleteIndex] = lastEntry;
1195             // Update the index for the moved entry
1196             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1197 
1198             // Delete the slot where the moved entry was stored
1199             map._entries.pop();
1200 
1201             // Delete the index for the deleted slot
1202             delete map._indexes[key];
1203 
1204             return true;
1205         } else {
1206             return false;
1207         }
1208     }
1209 
1210     /**
1211      * @dev Returns true if the key is in the map. O(1).
1212      */
1213     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1214         return map._indexes[key] != 0;
1215     }
1216 
1217     /**
1218      * @dev Returns the number of key-value pairs in the map. O(1).
1219      */
1220     function _length(Map storage map) private view returns (uint256) {
1221         return map._entries.length;
1222     }
1223 
1224    /**
1225     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1226     *
1227     * Note that there are no guarantees on the ordering of entries inside the
1228     * array, and it may change when more entries are added or removed.
1229     *
1230     * Requirements:
1231     *
1232     * - `index` must be strictly less than {length}.
1233     */
1234     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1235         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1236 
1237         MapEntry storage entry = map._entries[index];
1238         return (entry._key, entry._value);
1239     }
1240 
1241     /**
1242      * @dev Returns the value associated with `key`.  O(1).
1243      *
1244      * Requirements:
1245      *
1246      * - `key` must be in the map.
1247      */
1248     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1249         return _get(map, key, "EnumerableMap: nonexistent key");
1250     }
1251 
1252     /**
1253      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1254      */
1255     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1256         uint256 keyIndex = map._indexes[key];
1257         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1258         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1259     }
1260 
1261     // UintToAddressMap
1262 
1263     struct UintToAddressMap {
1264         Map _inner;
1265     }
1266 
1267     /**
1268      * @dev Adds a key-value pair to a map, or updates the value for an existing
1269      * key. O(1).
1270      *
1271      * Returns true if the key was added to the map, that is if it was not
1272      * already present.
1273      */
1274     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1275         return _set(map._inner, bytes32(key), bytes32(uint256(value)));
1276     }
1277 
1278     /**
1279      * @dev Removes a value from a set. O(1).
1280      *
1281      * Returns true if the key was removed from the map, that is if it was present.
1282      */
1283     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1284         return _remove(map._inner, bytes32(key));
1285     }
1286 
1287     /**
1288      * @dev Returns true if the key is in the map. O(1).
1289      */
1290     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1291         return _contains(map._inner, bytes32(key));
1292     }
1293 
1294     /**
1295      * @dev Returns the number of elements in the map. O(1).
1296      */
1297     function length(UintToAddressMap storage map) internal view returns (uint256) {
1298         return _length(map._inner);
1299     }
1300 
1301    /**
1302     * @dev Returns the element stored at position `index` in the set. O(1).
1303     * Note that there are no guarantees on the ordering of values inside the
1304     * array, and it may change when more values are added or removed.
1305     *
1306     * Requirements:
1307     *
1308     * - `index` must be strictly less than {length}.
1309     */
1310     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1311         (bytes32 key, bytes32 value) = _at(map._inner, index);
1312         return (uint256(key), address(uint256(value)));
1313     }
1314 
1315     /**
1316      * @dev Returns the value associated with `key`.  O(1).
1317      *
1318      * Requirements:
1319      *
1320      * - `key` must be in the map.
1321      */
1322     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1323         return address(uint256(_get(map._inner, bytes32(key))));
1324     }
1325 
1326     /**
1327      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1328      */
1329     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1330         return address(uint256(_get(map._inner, bytes32(key), errorMessage)));
1331     }
1332 }
1333 
1334 // File: @openzeppelin/contracts/utils/Strings.sol
1335 
1336 // SPDX-License-Identifier: MIT
1337 
1338 pragma solidity ^0.6.0;
1339 
1340 /**
1341  * @dev String operations.
1342  */
1343 library Strings {
1344     /**
1345      * @dev Converts a `uint256` to its ASCII `string` representation.
1346      */
1347     function toString(uint256 value) internal pure returns (string memory) {
1348         // Inspired by OraclizeAPI's implementation - MIT licence
1349         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1350 
1351         if (value == 0) {
1352             return "0";
1353         }
1354         uint256 temp = value;
1355         uint256 digits;
1356         while (temp != 0) {
1357             digits++;
1358             temp /= 10;
1359         }
1360         bytes memory buffer = new bytes(digits);
1361         uint256 index = digits - 1;
1362         temp = value;
1363         while (temp != 0) {
1364             buffer[index--] = byte(uint8(48 + temp % 10));
1365             temp /= 10;
1366         }
1367         return string(buffer);
1368     }
1369 }
1370 
1371 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1372 
1373 // SPDX-License-Identifier: MIT
1374 
1375 pragma solidity ^0.6.0;
1376 
1377 
1378 
1379 
1380 
1381 
1382 
1383 
1384 
1385 
1386 
1387 
1388 /**
1389  * @title ERC721 Non-Fungible Token Standard basic implementation
1390  * @dev see https://eips.ethereum.org/EIPS/eip-721
1391  */
1392 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1393     using SafeMath for uint256;
1394     using Address for address;
1395     using EnumerableSet for EnumerableSet.UintSet;
1396     using EnumerableMap for EnumerableMap.UintToAddressMap;
1397     using Strings for uint256;
1398 
1399     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1400     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1401     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1402 
1403     // Mapping from holder address to their (enumerable) set of owned tokens
1404     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1405 
1406     // Enumerable mapping from token ids to their owners
1407     EnumerableMap.UintToAddressMap private _tokenOwners;
1408 
1409     // Mapping from token ID to approved address
1410     mapping (uint256 => address) private _tokenApprovals;
1411 
1412     // Mapping from owner to operator approvals
1413     mapping (address => mapping (address => bool)) private _operatorApprovals;
1414 
1415     // Token name
1416     string private _name;
1417 
1418     // Token symbol
1419     string private _symbol;
1420 
1421     // Optional mapping for token URIs
1422     mapping (uint256 => string) private _tokenURIs;
1423 
1424     // Base URI
1425     string private _baseURI;
1426 
1427     /*
1428      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1429      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1430      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1431      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1432      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1433      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1434      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1435      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1436      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1437      *
1438      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1439      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1440      */
1441     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1442 
1443     /*
1444      *     bytes4(keccak256('name()')) == 0x06fdde03
1445      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1446      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1447      *
1448      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1449      */
1450     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1451 
1452     /*
1453      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1454      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1455      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1456      *
1457      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1458      */
1459     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1460 
1461     /**
1462      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1463      */
1464     constructor (string memory name, string memory symbol) public {
1465         _name = name;
1466         _symbol = symbol;
1467 
1468         // register the supported interfaces to conform to ERC721 via ERC165
1469         _registerInterface(_INTERFACE_ID_ERC721);
1470         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1471         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1472     }
1473 
1474     /**
1475      * @dev See {IERC721-balanceOf}.
1476      */
1477     function balanceOf(address owner) public view override returns (uint256) {
1478         require(owner != address(0), "ERC721: balance query for the zero address");
1479 
1480         return _holderTokens[owner].length();
1481     }
1482 
1483     /**
1484      * @dev See {IERC721-ownerOf}.
1485      */
1486     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1487         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1488     }
1489 
1490     /**
1491      * @dev See {IERC721Metadata-name}.
1492      */
1493     function name() public view override returns (string memory) {
1494         return _name;
1495     }
1496 
1497     /**
1498      * @dev See {IERC721Metadata-symbol}.
1499      */
1500     function symbol() public view override returns (string memory) {
1501         return _symbol;
1502     }
1503 
1504     /**
1505      * @dev See {IERC721Metadata-tokenURI}.
1506      */
1507     function tokenURI(uint256 tokenId) public view override returns (string memory) {
1508         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1509 
1510         string memory _tokenURI = _tokenURIs[tokenId];
1511 
1512         // If there is no base URI, return the token URI.
1513         if (bytes(_baseURI).length == 0) {
1514             return _tokenURI;
1515         }
1516         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1517         if (bytes(_tokenURI).length > 0) {
1518             return string(abi.encodePacked(_baseURI, _tokenURI));
1519         }
1520         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1521         return string(abi.encodePacked(_baseURI, tokenId.toString()));
1522     }
1523 
1524     /**
1525     * @dev Returns the base URI set via {_setBaseURI}. This will be
1526     * automatically added as a prefix in {tokenURI} to each token's URI, or
1527     * to the token ID if no specific URI is set for that token ID.
1528     */
1529     function baseURI() public view returns (string memory) {
1530         return _baseURI;
1531     }
1532 
1533     /**
1534      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1535      */
1536     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1537         return _holderTokens[owner].at(index);
1538     }
1539 
1540     /**
1541      * @dev See {IERC721Enumerable-totalSupply}.
1542      */
1543     function totalSupply() public view override returns (uint256) {
1544         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1545         return _tokenOwners.length();
1546     }
1547 
1548     /**
1549      * @dev See {IERC721Enumerable-tokenByIndex}.
1550      */
1551     function tokenByIndex(uint256 index) public view override returns (uint256) {
1552         (uint256 tokenId, ) = _tokenOwners.at(index);
1553         return tokenId;
1554     }
1555 
1556     /**
1557      * @dev See {IERC721-approve}.
1558      */
1559     function approve(address to, uint256 tokenId) public virtual override {
1560         address owner = ownerOf(tokenId);
1561         require(to != owner, "ERC721: approval to current owner");
1562 
1563         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1564             "ERC721: approve caller is not owner nor approved for all"
1565         );
1566 
1567         _approve(to, tokenId);
1568     }
1569 
1570     /**
1571      * @dev See {IERC721-getApproved}.
1572      */
1573     function getApproved(uint256 tokenId) public view override returns (address) {
1574         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1575 
1576         return _tokenApprovals[tokenId];
1577     }
1578 
1579     /**
1580      * @dev See {IERC721-setApprovalForAll}.
1581      */
1582     function setApprovalForAll(address operator, bool approved) public virtual override {
1583         require(operator != _msgSender(), "ERC721: approve to caller");
1584 
1585         _operatorApprovals[_msgSender()][operator] = approved;
1586         emit ApprovalForAll(_msgSender(), operator, approved);
1587     }
1588 
1589     /**
1590      * @dev See {IERC721-isApprovedForAll}.
1591      */
1592     function isApprovedForAll(address owner, address operator) public view override returns (bool) {
1593         return _operatorApprovals[owner][operator];
1594     }
1595 
1596     /**
1597      * @dev See {IERC721-transferFrom}.
1598      */
1599     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1600         //solhint-disable-next-line max-line-length
1601         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1602 
1603         _transfer(from, to, tokenId);
1604     }
1605 
1606     /**
1607      * @dev See {IERC721-safeTransferFrom}.
1608      */
1609     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1610         safeTransferFrom(from, to, tokenId, "");
1611     }
1612 
1613     /**
1614      * @dev See {IERC721-safeTransferFrom}.
1615      */
1616     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1617         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1618         _safeTransfer(from, to, tokenId, _data);
1619     }
1620 
1621     /**
1622      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1623      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1624      *
1625      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1626      *
1627      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1628      * implement alternative mechanisms to perform token transfer, such as signature-based.
1629      *
1630      * Requirements:
1631      *
1632      * - `from` cannot be the zero address.
1633      * - `to` cannot be the zero address.
1634      * - `tokenId` token must exist and be owned by `from`.
1635      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1636      *
1637      * Emits a {Transfer} event.
1638      */
1639     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1640         _transfer(from, to, tokenId);
1641         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1642     }
1643 
1644     /**
1645      * @dev Returns whether `tokenId` exists.
1646      *
1647      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1648      *
1649      * Tokens start existing when they are minted (`_mint`),
1650      * and stop existing when they are burned (`_burn`).
1651      */
1652     function _exists(uint256 tokenId) internal view returns (bool) {
1653         return _tokenOwners.contains(tokenId);
1654     }
1655 
1656     /**
1657      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1658      *
1659      * Requirements:
1660      *
1661      * - `tokenId` must exist.
1662      */
1663     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1664         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1665         address owner = ownerOf(tokenId);
1666         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1667     }
1668 
1669     /**
1670      * @dev Safely mints `tokenId` and transfers it to `to`.
1671      *
1672      * Requirements:
1673      d*
1674      * - `tokenId` must not exist.
1675      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1676      *
1677      * Emits a {Transfer} event.
1678      */
1679     function _safeMint(address to, uint256 tokenId) internal virtual {
1680         _safeMint(to, tokenId, "");
1681     }
1682 
1683     /**
1684      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1685      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1686      */
1687     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1688         _mint(to, tokenId);
1689         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1690     }
1691 
1692     /**
1693      * @dev Mints `tokenId` and transfers it to `to`.
1694      *
1695      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1696      *
1697      * Requirements:
1698      *
1699      * - `tokenId` must not exist.
1700      * - `to` cannot be the zero address.
1701      *
1702      * Emits a {Transfer} event.
1703      */
1704     function _mint(address to, uint256 tokenId) internal virtual {
1705         require(to != address(0), "ERC721: mint to the zero address");
1706         require(!_exists(tokenId), "ERC721: token already minted");
1707 
1708         _beforeTokenTransfer(address(0), to, tokenId);
1709 
1710         _holderTokens[to].add(tokenId);
1711 
1712         _tokenOwners.set(tokenId, to);
1713 
1714         emit Transfer(address(0), to, tokenId);
1715     }
1716 
1717     /**
1718      * @dev Destroys `tokenId`.
1719      * The approval is cleared when the token is burned.
1720      *
1721      * Requirements:
1722      *
1723      * - `tokenId` must exist.
1724      *
1725      * Emits a {Transfer} event.
1726      */
1727     function _burn(uint256 tokenId) internal virtual {
1728         address owner = ownerOf(tokenId);
1729 
1730         _beforeTokenTransfer(owner, address(0), tokenId);
1731 
1732         // Clear approvals
1733         _approve(address(0), tokenId);
1734 
1735         // Clear metadata (if any)
1736         if (bytes(_tokenURIs[tokenId]).length != 0) {
1737             delete _tokenURIs[tokenId];
1738         }
1739 
1740         _holderTokens[owner].remove(tokenId);
1741 
1742         _tokenOwners.remove(tokenId);
1743 
1744         emit Transfer(owner, address(0), tokenId);
1745     }
1746 
1747     /**
1748      * @dev Transfers `tokenId` from `from` to `to`.
1749      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1750      *
1751      * Requirements:
1752      *
1753      * - `to` cannot be the zero address.
1754      * - `tokenId` token must be owned by `from`.
1755      *
1756      * Emits a {Transfer} event.
1757      */
1758     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1759         require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1760         require(to != address(0), "ERC721: transfer to the zero address");
1761 
1762         _beforeTokenTransfer(from, to, tokenId);
1763 
1764         // Clear approvals from the previous owner
1765         _approve(address(0), tokenId);
1766 
1767         _holderTokens[from].remove(tokenId);
1768         _holderTokens[to].add(tokenId);
1769 
1770         _tokenOwners.set(tokenId, to);
1771 
1772         emit Transfer(from, to, tokenId);
1773     }
1774 
1775     /**
1776      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1777      *
1778      * Requirements:
1779      *
1780      * - `tokenId` must exist.
1781      */
1782     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1783         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1784         _tokenURIs[tokenId] = _tokenURI;
1785     }
1786 
1787     /**
1788      * @dev Internal function to set the base URI for all token IDs. It is
1789      * automatically added as a prefix to the value returned in {tokenURI},
1790      * or to the token ID if {tokenURI} is empty.
1791      */
1792     function _setBaseURI(string memory baseURI_) internal virtual {
1793         _baseURI = baseURI_;
1794     }
1795 
1796     /**
1797      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1798      * The call is not executed if the target address is not a contract.
1799      *
1800      * @param from address representing the previous owner of the given token ID
1801      * @param to target address that will receive the tokens
1802      * @param tokenId uint256 ID of the token to be transferred
1803      * @param _data bytes optional data to send along with the call
1804      * @return bool whether the call correctly returned the expected magic value
1805      */
1806     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1807         private returns (bool)
1808     {
1809         if (!to.isContract()) {
1810             return true;
1811         }
1812         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1813             IERC721Receiver(to).onERC721Received.selector,
1814             _msgSender(),
1815             from,
1816             tokenId,
1817             _data
1818         ), "ERC721: transfer to non ERC721Receiver implementer");
1819         bytes4 retval = abi.decode(returndata, (bytes4));
1820         return (retval == _ERC721_RECEIVED);
1821     }
1822 
1823     function _approve(address to, uint256 tokenId) private {
1824         _tokenApprovals[tokenId] = to;
1825         emit Approval(ownerOf(tokenId), to, tokenId);
1826     }
1827 
1828     /**
1829      * @dev Hook that is called before any token transfer. This includes minting
1830      * and burning.
1831      *
1832      * Calling conditions:
1833      *
1834      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1835      * transferred to `to`.
1836      * - When `from` is zero, `tokenId` will be minted for `to`.
1837      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1838      * - `from` cannot be the zero address.
1839      * - `to` cannot be the zero address.
1840      *
1841      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1842      */
1843     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1844 }
1845 
1846 // File: @openzeppelin/contracts/utils/Counters.sol
1847 
1848 // SPDX-License-Identifier: MIT
1849 
1850 pragma solidity ^0.6.0;
1851 
1852 
1853 /**
1854  * @title Counters
1855  * @author Matt Condon (@shrugs)
1856  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1857  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1858  *
1859  * Include with `using Counters for Counters.Counter;`
1860  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
1861  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
1862  * directly accessed.
1863  */
1864 library Counters {
1865     using SafeMath for uint256;
1866 
1867     struct Counter {
1868         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1869         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1870         // this feature: see https://github.com/ethereum/solidity/issues/4637
1871         uint256 _value; // default: 0
1872     }
1873 
1874     function current(Counter storage counter) internal view returns (uint256) {
1875         return counter._value;
1876     }
1877 
1878     function increment(Counter storage counter) internal {
1879         // The {SafeMath} overflow check can be skipped here, see the comment at the top
1880         counter._value += 1;
1881     }
1882 
1883     function decrement(Counter storage counter) internal {
1884         counter._value = counter._value.sub(1);
1885     }
1886 }
1887 
1888 // File: @openzeppelin/contracts/access/AccessControl.sol
1889 
1890 // SPDX-License-Identifier: MIT
1891 
1892 pragma solidity ^0.6.0;
1893 
1894 
1895 
1896 
1897 /**
1898  * @dev Contract module that allows children to implement role-based access
1899  * control mechanisms.
1900  *
1901  * Roles are referred to by their `bytes32` identifier. These should be exposed
1902  * in the external API and be unique. The best way to achieve this is by
1903  * using `public constant` hash digests:
1904  *
1905  * ```
1906  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1907  * ```
1908  *
1909  * Roles can be used to represent a set of permissions. To restrict access to a
1910  * function call, use {hasRole}:
1911  *
1912  * ```
1913  * function foo() public {
1914  *     require(hasRole(MY_ROLE, msg.sender));
1915  *     ...
1916  * }
1917  * ```
1918  *
1919  * Roles can be granted and revoked dynamically via the {grantRole} and
1920  * {revokeRole} functions. Each role has an associated admin role, and only
1921  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1922  *
1923  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1924  * that only accounts with this role will be able to grant or revoke other
1925  * roles. More complex role relationships can be created by using
1926  * {_setRoleAdmin}.
1927  *
1928  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1929  * grant and revoke this role. Extra precautions should be taken to secure
1930  * accounts that have been granted it.
1931  */
1932 abstract contract AccessControl is Context {
1933     using EnumerableSet for EnumerableSet.AddressSet;
1934     using Address for address;
1935 
1936     struct RoleData {
1937         EnumerableSet.AddressSet members;
1938         bytes32 adminRole;
1939     }
1940 
1941     mapping (bytes32 => RoleData) private _roles;
1942 
1943     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1944 
1945     /**
1946      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1947      *
1948      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1949      * {RoleAdminChanged} not being emitted signaling this.
1950      *
1951      * _Available since v3.1._
1952      */
1953     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1954 
1955     /**
1956      * @dev Emitted when `account` is granted `role`.
1957      *
1958      * `sender` is the account that originated the contract call, an admin role
1959      * bearer except when using {_setupRole}.
1960      */
1961     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1962 
1963     /**
1964      * @dev Emitted when `account` is revoked `role`.
1965      *
1966      * `sender` is the account that originated the contract call:
1967      *   - if using `revokeRole`, it is the admin role bearer
1968      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1969      */
1970     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1971 
1972     /**
1973      * @dev Returns `true` if `account` has been granted `role`.
1974      */
1975     function hasRole(bytes32 role, address account) public view returns (bool) {
1976         return _roles[role].members.contains(account);
1977     }
1978 
1979     /**
1980      * @dev Returns the number of accounts that have `role`. Can be used
1981      * together with {getRoleMember} to enumerate all bearers of a role.
1982      */
1983     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1984         return _roles[role].members.length();
1985     }
1986 
1987     /**
1988      * @dev Returns one of the accounts that have `role`. `index` must be a
1989      * value between 0 and {getRoleMemberCount}, non-inclusive.
1990      *
1991      * Role bearers are not sorted in any particular way, and their ordering may
1992      * change at any point.
1993      *
1994      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1995      * you perform all queries on the same block. See the following
1996      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1997      * for more information.
1998      */
1999     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
2000         return _roles[role].members.at(index);
2001     }
2002 
2003     /**
2004      * @dev Returns the admin role that controls `role`. See {grantRole} and
2005      * {revokeRole}.
2006      *
2007      * To change a role's admin, use {_setRoleAdmin}.
2008      */
2009     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
2010         return _roles[role].adminRole;
2011     }
2012 
2013     /**
2014      * @dev Grants `role` to `account`.
2015      *
2016      * If `account` had not been already granted `role`, emits a {RoleGranted}
2017      * event.
2018      *
2019      * Requirements:
2020      *
2021      * - the caller must have ``role``'s admin role.
2022      */
2023     function grantRole(bytes32 role, address account) public virtual {
2024         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
2025 
2026         _grantRole(role, account);
2027     }
2028 
2029     /**
2030      * @dev Revokes `role` from `account`.
2031      *
2032      * If `account` had been granted `role`, emits a {RoleRevoked} event.
2033      *
2034      * Requirements:
2035      *
2036      * - the caller must have ``role``'s admin role.
2037      */
2038     function revokeRole(bytes32 role, address account) public virtual {
2039         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
2040 
2041         _revokeRole(role, account);
2042     }
2043 
2044     /**
2045      * @dev Revokes `role` from the calling account.
2046      *
2047      * Roles are often managed via {grantRole} and {revokeRole}: this function's
2048      * purpose is to provide a mechanism for accounts to lose their privileges
2049      * if they are compromised (such as when a trusted device is misplaced).
2050      *
2051      * If the calling account had been granted `role`, emits a {RoleRevoked}
2052      * event.
2053      *
2054      * Requirements:
2055      *
2056      * - the caller must be `account`.
2057      */
2058     function renounceRole(bytes32 role, address account) public virtual {
2059         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
2060 
2061         _revokeRole(role, account);
2062     }
2063 
2064     /**
2065      * @dev Grants `role` to `account`.
2066      *
2067      * If `account` had not been already granted `role`, emits a {RoleGranted}
2068      * event. Note that unlike {grantRole}, this function doesn't perform any
2069      * checks on the calling account.
2070      *
2071      * [WARNING]
2072      * ====
2073      * This function should only be called from the constructor when setting
2074      * up the initial roles for the system.
2075      *
2076      * Using this function in any other way is effectively circumventing the admin
2077      * system imposed by {AccessControl}.
2078      * ====
2079      */
2080     function _setupRole(bytes32 role, address account) internal virtual {
2081         _grantRole(role, account);
2082     }
2083 
2084     /**
2085      * @dev Sets `adminRole` as ``role``'s admin role.
2086      *
2087      * Emits a {RoleAdminChanged} event.
2088      */
2089     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
2090         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
2091         _roles[role].adminRole = adminRole;
2092     }
2093 
2094     function _grantRole(bytes32 role, address account) private {
2095         if (_roles[role].members.add(account)) {
2096             emit RoleGranted(role, account, _msgSender());
2097         }
2098     }
2099 
2100     function _revokeRole(bytes32 role, address account) private {
2101         if (_roles[role].members.remove(account)) {
2102             emit RoleRevoked(role, account, _msgSender());
2103         }
2104     }
2105 }
2106 
2107 // File: contracts/PinkslipNFT.sol
2108 
2109 pragma solidity 0.6.5;
2110 
2111 
2112 
2113 
2114 
2115 
2116 contract PinkslipNFT is ERC721, AccessControl, Ownable {
2117     using Counters for Counters.Counter;
2118     Counters.Counter private _tokenIds;
2119 
2120     bytes32 public constant MINTER = keccak256("MINTER");
2121 
2122     /******************
2123     INTERNAL ACCOUNTING
2124     *******************/
2125     address public feeToken;
2126     address public feesStaking;
2127     address public feesPlatform;
2128 
2129     uint256[] public feesAmounts = [
2130         100000000000000000000, // Type 1 = 100 Token
2131         300000000000000000000, // Type 2 = 300 Token
2132         500000000000000000000  // Type 3 = 500 Token
2133     ];
2134     uint256 public stakingFeePercentage = 5000;  // 50%
2135     uint256 public platformFeePercentage = 5000; // 50%
2136 
2137     mapping (uint256 => uint256) private _carType;
2138     mapping (uint256 => uint256) private _totalByType;
2139     mapping (address => uint256) public buysCount;
2140 
2141     uint256 public type3Limit = 1000;
2142 
2143     constructor(
2144         address _feeToken,
2145         address _feesStaking,
2146         address _feesPlatform,
2147         string memory baseURI
2148     ) public ERC721("Pinkslip NFT", "PNFT") {
2149         require(address(_feeToken) != address(0), 'PinkslipNFT: Address must be different to 0x0'); 
2150         require(address(_feesStaking) != address(0), 'PinkslipNFT: Address must be different to 0x0');  
2151         require(address(_feesPlatform) != address(0), 'PinkslipNFT: Address must be different to 0x0');  
2152 
2153         feeToken = _feeToken;
2154         feesStaking = _feesStaking;
2155         feesPlatform = _feesPlatform;
2156 
2157         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
2158         _setupRole(MINTER, msg.sender);
2159         _setBaseURI(baseURI);
2160     }
2161 
2162     function mint(
2163         address wallet,
2164         uint256 carType
2165     )
2166         external
2167         returns (uint256)
2168     {
2169         require(hasRole(MINTER, msg.sender), 'PinkslipNFT: Only for role MINTER');
2170 
2171         return safeMint(wallet, carType);
2172     }
2173 
2174     function buy(
2175         uint256 carType
2176     )
2177         external
2178         returns (uint256)
2179     {
2180         require(balanceOf(msg.sender) < 3 || buysCount[msg.sender] < 3, 'PinkslipNFT: You can not buy more');
2181         
2182         uint256 newItemId = safeMint(msg.sender, carType);
2183 
2184         uint256 stakingFee = feesAmounts[carType - 1].mul(stakingFeePercentage).div(10000);
2185         uint256 platformFee = feesAmounts[carType - 1].mul(platformFeePercentage).div(10000);
2186         require(IERC20(feeToken).transferFrom(msg.sender, feesStaking, stakingFee), 'PinkslipNFT: Not enough balance');
2187         require(IERC20(feeToken).transferFrom(msg.sender, feesPlatform, platformFee), 'PinkslipNFT: Not enough balance');
2188 
2189         buysCount[msg.sender] += 1;
2190 
2191         return newItemId;
2192     }
2193 
2194     function safeMint(
2195         address wallet,
2196         uint256 carType
2197     )
2198         internal
2199         returns (uint256)
2200     {
2201         require(carType == 1 || carType == 2 || carType == 3, 'PinkslipNFT: Type must be 1, 2 or 3');
2202         
2203         if (carType == 3) {
2204             require(_totalByType[carType] < type3Limit, 'PinkslipNFT: Car type limit reached');
2205         }
2206 
2207         _tokenIds.increment();
2208 
2209         uint256 newItemId = _tokenIds.current();
2210         _safeMint(wallet, newItemId);
2211         _setCarType(newItemId, carType);
2212 
2213         _totalByType[carType] += 1;
2214 
2215         return newItemId;
2216     }
2217 
2218     function carType(uint256 tokenId) external view returns (uint256) {
2219         require(_exists(tokenId), 'PinkslipNFT: Type query for nonexistent token');
2220         return _carType[tokenId];
2221     }
2222 
2223     function _setCarType(uint256 tokenId, uint256 tokenType) internal virtual {
2224         require(_exists(tokenId), 'PinkslipNFT: Type set of nonexistent token');
2225         require(tokenType == 1 || tokenType == 2 || tokenType == 3, 'PinkslipNFT: Car type must be 1, 2 or 3');
2226         _carType[tokenId] = tokenType;
2227     }
2228 
2229 
2230     function setFeesDestinators(
2231         address _feesStaking,
2232         address _feesPlatform
2233     )
2234         external
2235         onlyOwner()
2236     {
2237         require(address(_feesStaking) != address(0), 'PinkslipNFT: Address must be different to 0x0'); 
2238         require(address(_feesPlatform) != address(0), 'PinkslipNFT: Address must be different to 0x0'); 
2239 
2240         feesStaking = _feesStaking;
2241         feesPlatform = _feesPlatform;
2242     }
2243 
2244     function setFeesPercentages(
2245         uint256 _stakingFeePercentage,
2246         uint256 _platformFeePercentage
2247     )
2248         external
2249         onlyOwner()
2250     {
2251         uint256 totalFeePercentage = _stakingFeePercentage + _platformFeePercentage;
2252 
2253         require(totalFeePercentage == 10000, 'PinkslipNFT: Total fee must be 100%'); 
2254 
2255         stakingFeePercentage = _stakingFeePercentage;
2256         platformFeePercentage = _platformFeePercentage;
2257     }
2258 
2259     function setFeesAmounts(
2260         uint256[] calldata _feesAmounts
2261     )
2262         external
2263         onlyOwner()
2264     {
2265         feesAmounts = _feesAmounts;
2266     }
2267 }
2268 
2269 // File: contracts/PinkslipRacing.sol
2270 
2271 pragma solidity 0.6.5;
2272 pragma experimental ABIEncoderV2;
2273 
2274 
2275 
2276 
2277 
2278 
2279 contract PinkslipRacing is Ownable, ReentrancyGuard {
2280     using SafeMath for uint256;
2281     using SafeMath for uint8;
2282 
2283     uint256 constant BIGNUMBER = 10 ** 18;
2284 
2285     /******************
2286     EVENTS
2287     ******************/
2288     event CreatedRace(uint256 indexed raceId, uint256 indexed slotId, address indexed wallet, uint256 tokenId, uint256 amount, uint256 created);
2289     event CanceledRace(uint256 indexed raceId, uint256 indexed slotId, address indexed wallet, uint256 tokenId, uint256 amount, uint256 created);
2290     event AcceptedRace(uint256 indexed raceId, uint256 indexed slotId, address indexed wallet, uint256 tokenId, uint256 amount, uint256 created);
2291     event WinnedRace(uint256 indexed raceId, uint256 indexed slotId, address indexed wallet, uint256 tokenIdA, uint256 tokenIdB, uint256 amount, uint256 created);
2292 
2293     /******************
2294     INTERNAL ACCOUNTING
2295     *******************/
2296     address public ERC20;
2297     address public ERC721;
2298 
2299     uint256 public totalRacesCount = 1;
2300 
2301     mapping (uint256 => Race) public races;
2302     mapping (uint256 => uint256) public racesSlots;
2303     mapping (address => uint256) public addressInSlot;
2304     mapping (uint256 => uint256) public lastRaceByToken;
2305 
2306     struct Race {
2307         uint256 tokenId;
2308         address owner;
2309         uint256 amount;
2310         address acceptedBy;
2311         uint256 tokenIdAccepted;
2312         address winner;
2313         uint256 endDate;
2314     }
2315 
2316     /******************
2317     PUBLIC FUNCTIONS
2318     *******************/
2319     constructor(
2320         address _ERC20,
2321         address _ERC721
2322     )
2323         public
2324     {
2325         require(address(_ERC20) != address(0)); 
2326         require(address(_ERC721) != address(0));
2327 
2328         ERC20 = _ERC20;
2329         ERC721 = _ERC721;
2330     }
2331 
2332     function createRace(
2333         uint256 _tokenId,
2334         uint256 _amount,
2335         uint256 _raceSlot
2336     )
2337         external
2338         slotAvailable(_raceSlot)
2339         returns (uint256)
2340     {
2341         require(_amount >= 5000000000000000000, 'PinkslipRacing: Min amount 5 tokens'); 
2342         require(_raceSlot >= 0 && _raceSlot < 50, 'PinkslipRacing: Slots from 0 to 49'); 
2343         
2344         uint256 lastSlotBySender = addressInSlot[msg.sender];
2345         uint256 raceIdOnLastUsedSlotBySender = racesSlots[lastSlotBySender];
2346         require(
2347             raceIdOnLastUsedSlotBySender == 0 || 
2348             races[raceIdOnLastUsedSlotBySender].owner != msg.sender  || 
2349             _getTime() > races[raceIdOnLastUsedSlotBySender].endDate ,
2350             'PinkslipRacing: You already on slot'
2351         );
2352 
2353         uint256 timeNow = _getTime();
2354         uint256 newRaceId = totalRacesCount;
2355         totalRacesCount += 1;
2356 
2357         races[newRaceId] = Race({
2358             tokenId: _tokenId,
2359             owner: msg.sender,
2360             amount: _amount,
2361             acceptedBy: address(0x0),
2362             tokenIdAccepted: 0,
2363             winner: address(0x0),
2364             endDate: timeNow + 24 hours
2365         });
2366         lastRaceByToken[_tokenId] = newRaceId;
2367 
2368         racesSlots[_raceSlot] = newRaceId;
2369         addressInSlot[msg.sender] = _raceSlot;
2370 
2371         emit CreatedRace(newRaceId, _raceSlot, msg.sender, _tokenId, _amount, timeNow);
2372 
2373         return newRaceId;
2374     }
2375 
2376     function cancel(
2377         uint256 _raceSlot
2378     )
2379         external
2380         inProgress(_raceSlot)
2381         returns (uint256)
2382     {
2383         uint256 _raceId = racesSlots[_raceSlot];
2384 
2385         require(races[_raceId].owner == msg.sender, 'PinkslipRacing: User is not the token owner');
2386 
2387         uint256 timeNow = _getTime();
2388         races[_raceId].endDate = timeNow;
2389 
2390         racesSlots[_raceSlot] = 0;
2391         addressInSlot[msg.sender] = 0;
2392 
2393         emit CanceledRace(_raceId, _raceSlot, msg.sender, races[_raceId].tokenId, races[_raceId].amount, timeNow);
2394     }
2395 
2396     function accept(
2397         uint256 _raceSlot,
2398         uint256 _tokenId
2399     )
2400         external
2401         inProgress(_raceSlot)
2402         returns (address)
2403     {
2404         uint256 _raceId = racesSlots[_raceSlot];
2405 
2406         require(IERC20(ERC20).balanceOf(races[_raceId].owner) >= races[_raceId].amount, 'PinkslipRacing: Creator needs more token balance');
2407         require(IERC20(ERC20).allowance(races[_raceId].owner, address(this)) >= races[_raceId].amount, 'PinkslipRacing: Creator needs to allows the token');
2408         require(PinkslipNFT(ERC721).ownerOf(races[_raceId].tokenId) == races[_raceId].owner, 'PinkslipRacing: Creator is not the NFT owner');
2409         require(PinkslipNFT(ERC721).isApprovedForAll(races[_raceId].owner, address(this)), 'PinkslipRacing: Creator needs to allow the NFT token');
2410 
2411         require(IERC20(ERC20).balanceOf(msg.sender) >= races[_raceId].amount, 'PinkslipRacing: User needs more token balance');
2412         require(IERC20(ERC20).allowance(msg.sender, address(this)) >= races[_raceId].amount, 'PinkslipRacing: User needs to allows the token');
2413         require(PinkslipNFT(ERC721).ownerOf(_tokenId) == msg.sender, 'PinkslipRacing: User is not the NFT owner');
2414         require(PinkslipNFT(ERC721).isApprovedForAll(msg.sender, address(this)), 'PinkslipRacing: User needs to allow the NFT token');
2415         
2416         require(_raceId != 0, 'PinkslipRacing: Empty slot');
2417         require(msg.sender != races[_raceId].owner, 'PinkslipRacing: You can not accept your own race');
2418         
2419         uint256 timeNow = _getTime();
2420         uint256 amount = races[_raceId].amount;
2421 
2422         emit AcceptedRace(_raceId, _raceSlot, msg.sender, races[_raceId].tokenId, races[_raceId].amount, timeNow);
2423 
2424         uint256 creatorChances = _chancesByType(PinkslipNFT(ERC721).carType(races[_raceId].tokenId));
2425         uint256 accepterChances = _chancesByType(PinkslipNFT(ERC721).carType(_tokenId));
2426 
2427         uint256 randNumber = _randomNumber(creatorChances + accepterChances, _tokenId);
2428         address winnerAddress = address(0x0);
2429 
2430         if (randNumber <= creatorChances) {
2431             winnerAddress = races[_raceId].owner;
2432             IERC20(ERC20).transferFrom(msg.sender, winnerAddress, amount);
2433             PinkslipNFT(ERC721).transferFrom(msg.sender, winnerAddress, _tokenId);
2434         } else {
2435             winnerAddress = msg.sender;
2436             IERC20(ERC20).transferFrom(races[_raceId].owner, winnerAddress, amount);
2437             PinkslipNFT(ERC721).transferFrom(races[_raceId].owner, winnerAddress, races[_raceId].tokenId);
2438         }
2439 
2440         races[_raceId].acceptedBy = msg.sender;
2441         races[_raceId].tokenIdAccepted = _tokenId;
2442         races[_raceId].winner = winnerAddress;
2443 
2444         racesSlots[_raceSlot] = 0;
2445         addressInSlot[races[_raceId].owner] = 0;
2446 
2447         emit WinnedRace(_raceId, _raceSlot, winnerAddress, races[_raceId].tokenId, _tokenId, amount, timeNow);
2448 
2449         return winnerAddress;
2450     }
2451 
2452     function isSlotAvailable(uint256 _raceSlot) public view returns (bool) {
2453         uint256 raceId = racesSlots[_raceSlot];
2454 
2455         return 
2456             !(races[raceId].owner != address(0x0) &&
2457             IERC20(ERC20).balanceOf(races[raceId].owner) >= races[raceId].amount &&
2458             IERC20(ERC20).allowance(races[raceId].owner, address(this)) >= races[raceId].amount &&
2459             PinkslipNFT(ERC721).ownerOf(races[raceId].tokenId) == races[raceId].owner &&
2460             PinkslipNFT(ERC721).isApprovedForAll(races[raceId].owner, address(this)) &&
2461             races[raceId].endDate > _getTime());
2462     }
2463 
2464     function allSlotsStatus() external view returns (bool[] memory) {
2465         bool[] memory slots = new bool[](50);
2466 
2467         for (uint256 i=0; i < 50; i++) {
2468             slots[i] = isSlotAvailable(i);
2469         }
2470 
2471         return slots;
2472     }
2473 
2474     /******************
2475     PRIVATE FUNCTIONS
2476     *******************/
2477     function _getTime() internal view returns (uint256) {
2478         return block.timestamp;
2479     }
2480 
2481     function _randomNumber(uint256 _limit, uint256 _salt) internal view returns (uint256) {
2482         uint256 _gasleft = gasleft();
2483         bytes32 _blockhash = blockhash(block.number - 1);
2484         uint256 _blocklimit = block.difficulty;
2485         bytes32 _structHash = keccak256(
2486             abi.encode(
2487                 _blockhash,
2488                 _blocklimit,
2489                 _getTime(),
2490                 _gasleft,
2491                 _salt
2492             )
2493         );
2494         uint256 randomNumber = uint256(_structHash);
2495         assembly {randomNumber := add(mod(randomNumber, _limit), 1)}
2496         return uint8(randomNumber);
2497     }
2498 
2499     function _chancesByType(uint256 carType) internal pure returns (uint256) {
2500         if (carType == 2) {
2501             return 5;
2502         } else if (carType == 3) {
2503             return 7;
2504         }
2505 
2506         return 3;
2507     }
2508 
2509     /******************
2510     MODIFIERS
2511     *******************/
2512     modifier inProgress(uint256 _raceSlot) {
2513         require(_raceSlot >= 0 && _raceSlot < 50, 'PinkslipRacing: Slots from 0 to 49'); 
2514 
2515         uint256 raceId = racesSlots[_raceSlot];
2516         require(
2517             (races[raceId].endDate > _getTime()) && races[raceId].acceptedBy == address(0x0),
2518             'PinkslipRacing: Race already ended'
2519         );
2520         _;
2521     }
2522 
2523     modifier slotAvailable(uint256 _raceSlot) {
2524         require(
2525             isSlotAvailable(_raceSlot),
2526             'PinkslipRacing: Slot not available'
2527         );
2528         _;
2529     }
2530 }