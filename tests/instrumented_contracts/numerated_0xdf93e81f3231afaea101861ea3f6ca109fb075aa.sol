1 // File: contracts/utils/SafeMath.sol
2 // SPDX-License-Identifier: MIT
3 pragma solidity ^0.8.0;
4 
5 // CAUTION
6 // This version of SafeMath should only be used with Solidity 0.8 or later,
7 // because it relies on the compiler's built in overflow checks.
8 
9 /**
10  * @dev Wrappers over Solidity's arithmetic operations.
11  *
12  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
13  * now has built in overflow checking.
14  */
15 library SafeMath {
16     /**
17      * @dev Returns the addition of two unsigned integers, with an overflow flag.
18      *
19      * _Available since v3.4._
20      */
21     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
22             uint256 c = a + b;
23             if (c < a) return (false, 0);
24             return (true, c);
25     }
26 
27     /**
28      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
29      *
30      * _Available since v3.4._
31      */
32     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
33             if (b > a) return (false, 0);
34             return (true, a - b);
35     }
36 
37     /**
38      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
39      *
40      * _Available since v3.4._
41      */
42     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
43             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
44             // benefit is lost if 'b' is also tested.
45             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
46             if (a == 0) return (true, 0);
47             uint256 c = a * b;
48             if (c / a != b) return (false, 0);
49             return (true, c);
50     }
51 
52     /**
53      * @dev Returns the division of two unsigned integers, with a division by zero flag.
54      *
55      * _Available since v3.4._
56      */
57     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
58             if (b == 0) return (false, 0);
59             return (true, a / b);
60     }
61 
62     /**
63      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
64      *
65      * _Available since v3.4._
66      */
67     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
68             if (b == 0) return (false, 0);
69             return (true, a % b);
70     }
71 
72     /**
73      * @dev Returns the addition of two unsigned integers, reverting on
74      * overflow.
75      *
76      * Counterpart to Solidity's `+` operator.
77      *
78      * Requirements:
79      *
80      * - Addition cannot overflow.
81      */
82     function add(uint256 a, uint256 b) internal pure returns (uint256) {
83         return a + b;
84     }
85 
86     /**
87      * @dev Returns the subtraction of two unsigned integers, reverting on
88      * overflow (when the result is negative).
89      *
90      * Counterpart to Solidity's `-` operator.
91      *
92      * Requirements:
93      *
94      * - Subtraction cannot overflow.
95      */
96     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
97         return a - b;
98     }
99 
100     /**
101      * @dev Returns the multiplication of two unsigned integers, reverting on
102      * overflow.
103      *
104      * Counterpart to Solidity's `*` operator.
105      *
106      * Requirements:
107      *
108      * - Multiplication cannot overflow.
109      */
110     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
111         return a * b;
112     }
113 
114     /**
115      * @dev Returns the integer division of two unsigned integers, reverting on
116      * division by zero. The result is rounded towards zero.
117      *
118      * Counterpart to Solidity's `/` operator.
119      *
120      * Requirements:
121      *
122      * - The divisor cannot be zero.
123      */
124     function div(uint256 a, uint256 b) internal pure returns (uint256) {
125         return a / b;
126     }
127 
128     /**
129      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
130      * reverting when dividing by zero.
131      *
132      * Counterpart to Solidity's `%` operator. This function uses a `revert`
133      * opcode (which leaves remaining gas untouched) while Solidity uses an
134      * invalid opcode to revert (consuming all remaining gas).
135      *
136      * Requirements:
137      *
138      * - The divisor cannot be zero.
139      */
140     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
141         return a % b;
142     }
143 
144     /**
145      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
146      * overflow (when the result is negative).
147      *
148      * CAUTION: This function is deprecated because it requires allocating memory for the error
149      * message unnecessarily. For custom revert reasons use {trySub}.
150      *
151      * Counterpart to Solidity's `-` operator.
152      *
153      * Requirements:
154      *
155      * - Subtraction cannot overflow.
156      */
157     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158             require(b <= a, errorMessage);
159             return a - b;
160     }
161 
162     /**
163      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
164      * division by zero. The result is rounded towards zero.
165      *
166      * Counterpart to Solidity's `%` operator. This function uses a `revert`
167      * opcode (which leaves remaining gas untouched) while Solidity uses an
168      * invalid opcode to revert (consuming all remaining gas).
169      *
170      * Counterpart to Solidity's `/` operator. Note: this function uses a
171      * `revert` opcode (which leaves remaining gas untouched) while Solidity
172      * uses an invalid opcode to revert (consuming all remaining gas).
173      *
174      * Requirements:
175      *
176      * - The divisor cannot be zero.
177      */
178     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
179             require(b > 0, errorMessage);
180             return a / b;
181     }
182 
183     /**
184      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
185      * reverting with custom message when dividing by zero.
186      *
187      * CAUTION: This function is deprecated because it requires allocating memory for the error
188      * message unnecessarily. For custom revert reasons use {tryMod}.
189      *
190      * Counterpart to Solidity's `%` operator. This function uses a `revert`
191      * opcode (which leaves remaining gas untouched) while Solidity uses an
192      * invalid opcode to revert (consuming all remaining gas).
193      *
194      * Requirements:
195      *
196      * - The divisor cannot be zero.
197      */
198     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
199             require(b > 0, errorMessage);
200             return a % b;
201     }
202 }
203 
204 // File: contracts/utils/Royalties.sol
205 
206 pragma solidity ^0.8.0;
207 
208 
209 abstract contract Royalties {
210 
211     using SafeMath for uint256;
212 
213     /*
214      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
215      */
216     uint256 private royalty_amount;
217     address private creator;
218 
219     /**
220     @notice This event is emitted when royalties are transfered.
221 
222     @dev The marketplace would emit this event from their contracts. Or they would call royaltiesRecieved() function.
223 
224     @param creator The original creator of the NFT entitled to the royalties
225     @param buyer The person buying the NFT on a secondary sale
226     @param amount The amount being paid to the creator
227   */
228 
229     event RecievedRoyalties(
230         address indexed creator,
231         address indexed buyer,
232         uint256 indexed amount
233     );
234 
235     constructor(uint256 _amount, address _creator) internal {
236         royalty_amount = _amount;
237         creator = _creator;
238     }
239 
240     function hasRoyalties() public pure returns (bool) {
241         return true;
242     }
243 
244     function royaltyAmount() public view returns (uint256) {
245         return royalty_amount;
246     }
247 
248     function royaltyInfo(uint256 /* _tokenId */, uint256 _salePrice) external view returns (uint256, address) {
249         uint256 deductRoyalty = _salePrice.mul(royalty_amount).div(100);
250         return (deductRoyalty, creator);
251     }
252 
253     function royaltiesRecieved(
254         address _creator,
255         address _buyer,
256         uint256 _amount
257     ) external {
258         emit RecievedRoyalties(_creator, _buyer, _amount);
259     }
260 }
261 
262 // File: contracts/roles/Roles.sol
263 
264 pragma solidity ^0.8.0;
265 
266 /**
267  * @title Roles
268  * @dev Library for managing addresses assigned to a Role.
269  */
270 library Roles {
271     struct Role {
272         mapping (address => bool) bearer;
273     }
274 
275     /**
276      * @dev Give an account access to this role.
277      */
278     function add(Role storage role, address account) internal {
279         require(!has(role, account), "Roles: account already has role");
280         role.bearer[account] = true;
281     }
282 
283     /**
284      * @dev Remove an account's access to this role.
285      */
286     function remove(Role storage role, address account) internal {
287         require(has(role, account), "Roles: account does not have role");
288         role.bearer[account] = false;
289     }
290 
291     /**
292      * @dev Check if an account has this role.
293      * @return bool
294      */
295     function has(Role storage role, address account) internal view returns (bool) {
296         require(account != address(0), "Roles: account is the zero address");
297         return role.bearer[account];
298     }
299 }
300 
301 // File: @openzeppelin/contracts/utils/Context.sol
302 
303 
304 
305 pragma solidity ^0.8.0;
306 
307 /*
308  * @dev Provides information about the current execution context, including the
309  * sender of the transaction and its data. While these are generally available
310  * via msg.sender and msg.data, they should not be accessed in such a direct
311  * manner, since when dealing with meta-transactions the account sending and
312  * paying for execution may not be the actual sender (as far as an application
313  * is concerned).
314  *
315  * This contract is only required for intermediate, library-like contracts.
316  */
317 abstract contract Context {
318     function _msgSender() internal view virtual returns (address) {
319         return msg.sender;
320     }
321 
322     function _msgData() internal view virtual returns (bytes calldata) {
323         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
324         return msg.data;
325     }
326 }
327 
328 // File: contracts/roles/MinterRole.sol
329 
330 pragma solidity ^0.8.0;
331 
332 
333 
334 abstract contract MinterRole is Context {
335     using Roles for Roles.Role;
336 
337     event MinterAdded(address indexed account);
338     event MinterRemoved(address indexed account);
339 
340     Roles.Role private _minters;
341 
342     constructor () internal {
343         _addMinter(_msgSender());
344     }
345 
346     modifier onlyMinter() {
347         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
348         _;
349     }
350 
351     function isMinter(address account) public view returns (bool) {
352         return _minters.has(account);
353     }
354 
355     function addMinter(address account) public onlyMinter {
356         _addMinter(account);
357     }
358 
359     function renounceMinter() public {
360         _removeMinter(_msgSender());
361     }
362 
363     function _addMinter(address account) internal {
364         _minters.add(account);
365         emit MinterAdded(account);
366     }
367 
368     function _removeMinter(address account) internal {
369         _minters.remove(account);
370         emit MinterRemoved(account);
371     }
372 }
373 
374 // File: @openzeppelin/contracts/access/Ownable.sol
375 
376 
377 
378 pragma solidity ^0.8.0;
379 
380 /**
381  * @dev Contract module which provides a basic access control mechanism, where
382  * there is an account (an owner) that can be granted exclusive access to
383  * specific functions.
384  *
385  * By default, the owner account will be the one that deploys the contract. This
386  * can later be changed with {transferOwnership}.
387  *
388  * This module is used through inheritance. It will make available the modifier
389  * `onlyOwner`, which can be applied to your functions to restrict their use to
390  * the owner.
391  */
392 abstract contract Ownable is Context {
393     address private _owner;
394 
395     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
396 
397     /**
398      * @dev Initializes the contract setting the deployer as the initial owner.
399      */
400     constructor () {
401         address msgSender = _msgSender();
402         _owner = msgSender;
403         emit OwnershipTransferred(address(0), msgSender);
404     }
405 
406     /**
407      * @dev Returns the address of the current owner.
408      */
409     function owner() public view virtual returns (address) {
410         return _owner;
411     }
412 
413     /**
414      * @dev Throws if called by any account other than the owner.
415      */
416     modifier onlyOwner() {
417         require(owner() == _msgSender(), "Ownable: caller is not the owner");
418         _;
419     }
420 
421     /**
422      * @dev Leaves the contract without owner. It will not be possible to call
423      * `onlyOwner` functions anymore. Can only be called by the current owner.
424      *
425      * NOTE: Renouncing ownership will leave the contract without an owner,
426      * thereby removing any functionality that is only available to the owner.
427      */
428     function renounceOwnership() public virtual onlyOwner {
429         emit OwnershipTransferred(_owner, address(0));
430         _owner = address(0);
431     }
432 
433     /**
434      * @dev Transfers ownership of the contract to a new account (`newOwner`).
435      * Can only be called by the current owner.
436      */
437     function transferOwnership(address newOwner) public virtual onlyOwner {
438         require(newOwner != address(0), "Ownable: new owner is the zero address");
439         emit OwnershipTransferred(_owner, newOwner);
440         _owner = newOwner;
441     }
442 }
443 
444 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
445 
446 
447 
448 pragma solidity ^0.8.0;
449 
450 /**
451  * @dev Interface of the ERC165 standard, as defined in the
452  * https://eips.ethereum.org/EIPS/eip-165[EIP].
453  *
454  * Implementers can declare support of contract interfaces, which can then be
455  * queried by others ({ERC165Checker}).
456  *
457  * For an implementation, see {ERC165}.
458  */
459 interface IERC165 {
460     /**
461      * @dev Returns true if this contract implements the interface defined by
462      * `interfaceId`. See the corresponding
463      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
464      * to learn more about how these ids are created.
465      *
466      * This function call must use less than 30 000 gas.
467      */
468     function supportsInterface(bytes4 interfaceId) external view returns (bool);
469 }
470 
471 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
472 
473 
474 
475 pragma solidity ^0.8.0;
476 
477 
478 /**
479  * @dev Required interface of an ERC721 compliant contract.
480  */
481 interface IERC721 is IERC165 {
482     /**
483      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
484      */
485     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
486 
487     /**
488      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
489      */
490     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
491 
492     /**
493      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
494      */
495     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
496 
497     /**
498      * @dev Returns the number of tokens in ``owner``'s account.
499      */
500     function balanceOf(address owner) external view returns (uint256 balance);
501 
502     /**
503      * @dev Returns the owner of the `tokenId` token.
504      *
505      * Requirements:
506      *
507      * - `tokenId` must exist.
508      */
509     function ownerOf(uint256 tokenId) external view returns (address owner);
510 
511     /**
512      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
513      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
514      *
515      * Requirements:
516      *
517      * - `from` cannot be the zero address.
518      * - `to` cannot be the zero address.
519      * - `tokenId` token must exist and be owned by `from`.
520      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
521      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
522      *
523      * Emits a {Transfer} event.
524      */
525     function safeTransferFrom(address from, address to, uint256 tokenId) external;
526 
527     /**
528      * @dev Transfers `tokenId` token from `from` to `to`.
529      *
530      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
531      *
532      * Requirements:
533      *
534      * - `from` cannot be the zero address.
535      * - `to` cannot be the zero address.
536      * - `tokenId` token must be owned by `from`.
537      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
538      *
539      * Emits a {Transfer} event.
540      */
541     function transferFrom(address from, address to, uint256 tokenId) external;
542 
543     /**
544      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
545      * The approval is cleared when the token is transferred.
546      *
547      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
548      *
549      * Requirements:
550      *
551      * - The caller must own the token or be an approved operator.
552      * - `tokenId` must exist.
553      *
554      * Emits an {Approval} event.
555      */
556     function approve(address to, uint256 tokenId) external;
557 
558     /**
559      * @dev Returns the account approved for `tokenId` token.
560      *
561      * Requirements:
562      *
563      * - `tokenId` must exist.
564      */
565     function getApproved(uint256 tokenId) external view returns (address operator);
566 
567     /**
568      * @dev Approve or remove `operator` as an operator for the caller.
569      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
570      *
571      * Requirements:
572      *
573      * - The `operator` cannot be the caller.
574      *
575      * Emits an {ApprovalForAll} event.
576      */
577     function setApprovalForAll(address operator, bool _approved) external;
578 
579     /**
580      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
581      *
582      * See {setApprovalForAll}
583      */
584     function isApprovedForAll(address owner, address operator) external view returns (bool);
585 
586     /**
587       * @dev Safely transfers `tokenId` token from `from` to `to`.
588       *
589       * Requirements:
590       *
591       * - `from` cannot be the zero address.
592       * - `to` cannot be the zero address.
593       * - `tokenId` token must exist and be owned by `from`.
594       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
595       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
596       *
597       * Emits a {Transfer} event.
598       */
599     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
600 }
601 
602 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
603 
604 
605 
606 pragma solidity ^0.8.0;
607 
608 /**
609  * @title ERC721 token receiver interface
610  * @dev Interface for any contract that wants to support safeTransfers
611  * from ERC721 asset contracts.
612  */
613 interface IERC721Receiver {
614     /**
615      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
616      * by `operator` from `from`, this function is called.
617      *
618      * It must return its Solidity selector to confirm the token transfer.
619      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
620      *
621      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
622      */
623     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
624 }
625 
626 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
627 
628 
629 
630 pragma solidity ^0.8.0;
631 
632 
633 /**
634  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
635  * @dev See https://eips.ethereum.org/EIPS/eip-721
636  */
637 interface IERC721Metadata is IERC721 {
638 
639     /**
640      * @dev Returns the token collection name.
641      */
642     function name() external view returns (string memory);
643 
644     /**
645      * @dev Returns the token collection symbol.
646      */
647     function symbol() external view returns (string memory);
648 
649     /**
650      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
651      */
652     function tokenURI(uint256 tokenId) external view returns (string memory);
653 }
654 
655 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
656 
657 
658 
659 pragma solidity ^0.8.0;
660 
661 
662 /**
663  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
664  * @dev See https://eips.ethereum.org/EIPS/eip-721
665  */
666 interface IERC721Enumerable is IERC721 {
667 
668     /**
669      * @dev Returns the total amount of tokens stored by the contract.
670      */
671     function totalSupply() external view returns (uint256);
672 
673     /**
674      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
675      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
676      */
677     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
678 
679     /**
680      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
681      * Use along with {totalSupply} to enumerate all tokens.
682      */
683     function tokenByIndex(uint256 index) external view returns (uint256);
684 }
685 
686 // File: @openzeppelin/contracts/utils/Address.sol
687 
688 
689 
690 pragma solidity ^0.8.0;
691 
692 /**
693  * @dev Collection of functions related to the address type
694  */
695 library Address {
696     /**
697      * @dev Returns true if `account` is a contract.
698      *
699      * [IMPORTANT]
700      * ====
701      * It is unsafe to assume that an address for which this function returns
702      * false is an externally-owned account (EOA) and not a contract.
703      *
704      * Among others, `isContract` will return false for the following
705      * types of addresses:
706      *
707      *  - an externally-owned account
708      *  - a contract in construction
709      *  - an address where a contract will be created
710      *  - an address where a contract lived, but was destroyed
711      * ====
712      */
713     function isContract(address account) internal view returns (bool) {
714         // This method relies on extcodesize, which returns 0 for contracts in
715         // construction, since the code is only stored at the end of the
716         // constructor execution.
717 
718         uint256 size;
719         // solhint-disable-next-line no-inline-assembly
720         assembly { size := extcodesize(account) }
721         return size > 0;
722     }
723 
724     /**
725      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
726      * `recipient`, forwarding all available gas and reverting on errors.
727      *
728      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
729      * of certain opcodes, possibly making contracts go over the 2300 gas limit
730      * imposed by `transfer`, making them unable to receive funds via
731      * `transfer`. {sendValue} removes this limitation.
732      *
733      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
734      *
735      * IMPORTANT: because control is transferred to `recipient`, care must be
736      * taken to not create reentrancy vulnerabilities. Consider using
737      * {ReentrancyGuard} or the
738      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
739      */
740     function sendValue(address payable recipient, uint256 amount) internal {
741         require(address(this).balance >= amount, "Address: insufficient balance");
742 
743         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
744         (bool success, ) = recipient.call{ value: amount }("");
745         require(success, "Address: unable to send value, recipient may have reverted");
746     }
747 
748     /**
749      * @dev Performs a Solidity function call using a low level `call`. A
750      * plain`call` is an unsafe replacement for a function call: use this
751      * function instead.
752      *
753      * If `target` reverts with a revert reason, it is bubbled up by this
754      * function (like regular Solidity function calls).
755      *
756      * Returns the raw returned data. To convert to the expected return value,
757      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
758      *
759      * Requirements:
760      *
761      * - `target` must be a contract.
762      * - calling `target` with `data` must not revert.
763      *
764      * _Available since v3.1._
765      */
766     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
767       return functionCall(target, data, "Address: low-level call failed");
768     }
769 
770     /**
771      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
772      * `errorMessage` as a fallback revert reason when `target` reverts.
773      *
774      * _Available since v3.1._
775      */
776     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
777         return functionCallWithValue(target, data, 0, errorMessage);
778     }
779 
780     /**
781      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
782      * but also transferring `value` wei to `target`.
783      *
784      * Requirements:
785      *
786      * - the calling contract must have an ETH balance of at least `value`.
787      * - the called Solidity function must be `payable`.
788      *
789      * _Available since v3.1._
790      */
791     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
792         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
793     }
794 
795     /**
796      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
797      * with `errorMessage` as a fallback revert reason when `target` reverts.
798      *
799      * _Available since v3.1._
800      */
801     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
802         require(address(this).balance >= value, "Address: insufficient balance for call");
803         require(isContract(target), "Address: call to non-contract");
804 
805         // solhint-disable-next-line avoid-low-level-calls
806         (bool success, bytes memory returndata) = target.call{ value: value }(data);
807         return _verifyCallResult(success, returndata, errorMessage);
808     }
809 
810     /**
811      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
812      * but performing a static call.
813      *
814      * _Available since v3.3._
815      */
816     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
817         return functionStaticCall(target, data, "Address: low-level static call failed");
818     }
819 
820     /**
821      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
822      * but performing a static call.
823      *
824      * _Available since v3.3._
825      */
826     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
827         require(isContract(target), "Address: static call to non-contract");
828 
829         // solhint-disable-next-line avoid-low-level-calls
830         (bool success, bytes memory returndata) = target.staticcall(data);
831         return _verifyCallResult(success, returndata, errorMessage);
832     }
833 
834     /**
835      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
836      * but performing a delegate call.
837      *
838      * _Available since v3.4._
839      */
840     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
841         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
842     }
843 
844     /**
845      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
846      * but performing a delegate call.
847      *
848      * _Available since v3.4._
849      */
850     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
851         require(isContract(target), "Address: delegate call to non-contract");
852 
853         // solhint-disable-next-line avoid-low-level-calls
854         (bool success, bytes memory returndata) = target.delegatecall(data);
855         return _verifyCallResult(success, returndata, errorMessage);
856     }
857 
858     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
859         if (success) {
860             return returndata;
861         } else {
862             // Look for revert reason and bubble it up if present
863             if (returndata.length > 0) {
864                 // The easiest way to bubble the revert reason is using memory via assembly
865 
866                 // solhint-disable-next-line no-inline-assembly
867                 assembly {
868                     let returndata_size := mload(returndata)
869                     revert(add(32, returndata), returndata_size)
870                 }
871             } else {
872                 revert(errorMessage);
873             }
874         }
875     }
876 }
877 
878 // File: @openzeppelin/contracts/utils/Strings.sol
879 
880 
881 
882 pragma solidity ^0.8.0;
883 
884 /**
885  * @dev String operations.
886  */
887 library Strings {
888     bytes16 private constant alphabet = "0123456789abcdef";
889 
890     /**
891      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
892      */
893     function toString(uint256 value) internal pure returns (string memory) {
894         // Inspired by OraclizeAPI's implementation - MIT licence
895         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
896 
897         if (value == 0) {
898             return "0";
899         }
900         uint256 temp = value;
901         uint256 digits;
902         while (temp != 0) {
903             digits++;
904             temp /= 10;
905         }
906         bytes memory buffer = new bytes(digits);
907         while (value != 0) {
908             digits -= 1;
909             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
910             value /= 10;
911         }
912         return string(buffer);
913     }
914 
915     /**
916      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
917      */
918     function toHexString(uint256 value) internal pure returns (string memory) {
919         if (value == 0) {
920             return "0x00";
921         }
922         uint256 temp = value;
923         uint256 length = 0;
924         while (temp != 0) {
925             length++;
926             temp >>= 8;
927         }
928         return toHexString(value, length);
929     }
930 
931     /**
932      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
933      */
934     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
935         bytes memory buffer = new bytes(2 * length + 2);
936         buffer[0] = "0";
937         buffer[1] = "x";
938         for (uint256 i = 2 * length + 1; i > 1; --i) {
939             buffer[i] = alphabet[value & 0xf];
940             value >>= 4;
941         }
942         require(value == 0, "Strings: hex length insufficient");
943         return string(buffer);
944     }
945 
946 }
947 
948 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
949 
950 
951 
952 pragma solidity ^0.8.0;
953 
954 
955 /**
956  * @dev Implementation of the {IERC165} interface.
957  *
958  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
959  * for the additional interface id that will be supported. For example:
960  *
961  * ```solidity
962  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
963  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
964  * }
965  * ```
966  *
967  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
968  */
969 abstract contract ERC165 is IERC165 {
970     /**
971      * @dev See {IERC165-supportsInterface}.
972      */
973     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
974         return interfaceId == type(IERC165).interfaceId;
975     }
976 }
977 
978 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
979 
980 
981 
982 pragma solidity ^0.8.0;
983 
984 
985 
986 
987 
988 
989 
990 
991 
992 /**
993  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
994  * the Metadata extension, but not including the Enumerable extension, which is available separately as
995  * {ERC721Enumerable}.
996  */
997 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
998     using Address for address;
999     using Strings for uint256;
1000 
1001     // Token name
1002     string private _name;
1003 
1004     // Token symbol
1005     string private _symbol;
1006 
1007     // Mapping from token ID to owner address
1008     mapping (uint256 => address) private _owners;
1009 
1010     // Mapping owner address to token count
1011     mapping (address => uint256) private _balances;
1012 
1013     // Mapping from token ID to approved address
1014     mapping (uint256 => address) private _tokenApprovals;
1015 
1016     // Mapping from owner to operator approvals
1017     mapping (address => mapping (address => bool)) private _operatorApprovals;
1018 
1019     /**
1020      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1021      */
1022     constructor (string memory name_, string memory symbol_) {
1023         _name = name_;
1024         _symbol = symbol_;
1025     }
1026 
1027     /**
1028      * @dev See {IERC165-supportsInterface}.
1029      */
1030     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1031         return interfaceId == type(IERC721).interfaceId
1032             || interfaceId == type(IERC721Metadata).interfaceId
1033             || super.supportsInterface(interfaceId);
1034     }
1035 
1036     /**
1037      * @dev See {IERC721-balanceOf}.
1038      */
1039     function balanceOf(address owner) public view virtual override returns (uint256) {
1040         require(owner != address(0), "ERC721: balance query for the zero address");
1041         return _balances[owner];
1042     }
1043 
1044     /**
1045      * @dev See {IERC721-ownerOf}.
1046      */
1047     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1048         address owner = _owners[tokenId];
1049         require(owner != address(0), "ERC721: owner query for nonexistent token");
1050         return owner;
1051     }
1052 
1053     /**
1054      * @dev See {IERC721Metadata-name}.
1055      */
1056     function name() public view virtual override returns (string memory) {
1057         return _name;
1058     }
1059 
1060     /**
1061      * @dev See {IERC721Metadata-symbol}.
1062      */
1063     function symbol() public view virtual override returns (string memory) {
1064         return _symbol;
1065     }
1066 
1067     /**
1068      * @dev See {IERC721Metadata-tokenURI}.
1069      */
1070     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1071         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1072 
1073         string memory baseURI = _baseURI();
1074         return bytes(baseURI).length > 0
1075             ? string(abi.encodePacked(baseURI, tokenId.toString()))
1076             : '';
1077     }
1078 
1079     /**
1080      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
1081      * in child contracts.
1082      */
1083     function _baseURI() internal view virtual returns (string memory) {
1084         return "";
1085     }
1086 
1087     /**
1088      * @dev See {IERC721-approve}.
1089      */
1090     function approve(address to, uint256 tokenId) public virtual override {
1091         address owner = ERC721.ownerOf(tokenId);
1092         require(to != owner, "ERC721: approval to current owner");
1093 
1094         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1095             "ERC721: approve caller is not owner nor approved for all"
1096         );
1097 
1098         _approve(to, tokenId);
1099     }
1100 
1101     /**
1102      * @dev See {IERC721-getApproved}.
1103      */
1104     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1105         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1106 
1107         return _tokenApprovals[tokenId];
1108     }
1109 
1110     /**
1111      * @dev See {IERC721-setApprovalForAll}.
1112      */
1113     function setApprovalForAll(address operator, bool approved) public virtual override {
1114         require(operator != _msgSender(), "ERC721: approve to caller");
1115 
1116         _operatorApprovals[_msgSender()][operator] = approved;
1117         emit ApprovalForAll(_msgSender(), operator, approved);
1118     }
1119 
1120     /**
1121      * @dev See {IERC721-isApprovedForAll}.
1122      */
1123     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1124         return _operatorApprovals[owner][operator];
1125     }
1126 
1127     /**
1128      * @dev See {IERC721-transferFrom}.
1129      */
1130     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1131         //solhint-disable-next-line max-line-length
1132         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1133 
1134         _transfer(from, to, tokenId);
1135     }
1136 
1137     /**
1138      * @dev See {IERC721-safeTransferFrom}.
1139      */
1140     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1141         safeTransferFrom(from, to, tokenId, "");
1142     }
1143 
1144     /**
1145      * @dev See {IERC721-safeTransferFrom}.
1146      */
1147     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1148         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1149         _safeTransfer(from, to, tokenId, _data);
1150     }
1151 
1152     /**
1153      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1154      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1155      *
1156      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1157      *
1158      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1159      * implement alternative mechanisms to perform token transfer, such as signature-based.
1160      *
1161      * Requirements:
1162      *
1163      * - `from` cannot be the zero address.
1164      * - `to` cannot be the zero address.
1165      * - `tokenId` token must exist and be owned by `from`.
1166      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1167      *
1168      * Emits a {Transfer} event.
1169      */
1170     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1171         _transfer(from, to, tokenId);
1172         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1173     }
1174 
1175     /**
1176      * @dev Returns whether `tokenId` exists.
1177      *
1178      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1179      *
1180      * Tokens start existing when they are minted (`_mint`),
1181      * and stop existing when they are burned (`_burn`).
1182      */
1183     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1184         return _owners[tokenId] != address(0);
1185     }
1186 
1187     /**
1188      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1189      *
1190      * Requirements:
1191      *
1192      * - `tokenId` must exist.
1193      */
1194     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1195         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1196         address owner = ERC721.ownerOf(tokenId);
1197         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1198     }
1199 
1200     /**
1201      * @dev Safely mints `tokenId` and transfers it to `to`.
1202      *
1203      * Requirements:
1204      *
1205      * - `tokenId` must not exist.
1206      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1207      *
1208      * Emits a {Transfer} event.
1209      */
1210     function _safeMint(address to, uint256 tokenId) internal virtual {
1211         _safeMint(to, tokenId, "");
1212     }
1213 
1214     /**
1215      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1216      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1217      */
1218     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1219         _mint(to, tokenId);
1220         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1221     }
1222 
1223     /**
1224      * @dev Mints `tokenId` and transfers it to `to`.
1225      *
1226      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1227      *
1228      * Requirements:
1229      *
1230      * - `tokenId` must not exist.
1231      * - `to` cannot be the zero address.
1232      *
1233      * Emits a {Transfer} event.
1234      */
1235     function _mint(address to, uint256 tokenId) internal virtual {
1236         require(to != address(0), "ERC721: mint to the zero address");
1237         require(!_exists(tokenId), "ERC721: token already minted");
1238 
1239         _beforeTokenTransfer(address(0), to, tokenId);
1240 
1241         _balances[to] += 1;
1242         _owners[tokenId] = to;
1243 
1244         emit Transfer(address(0), to, tokenId);
1245     }
1246 
1247     /**
1248      * @dev Destroys `tokenId`.
1249      * The approval is cleared when the token is burned.
1250      *
1251      * Requirements:
1252      *
1253      * - `tokenId` must exist.
1254      *
1255      * Emits a {Transfer} event.
1256      */
1257     function _burn(uint256 tokenId) internal virtual {
1258         address owner = ERC721.ownerOf(tokenId);
1259 
1260         _beforeTokenTransfer(owner, address(0), tokenId);
1261 
1262         // Clear approvals
1263         _approve(address(0), tokenId);
1264 
1265         _balances[owner] -= 1;
1266         delete _owners[tokenId];
1267 
1268         emit Transfer(owner, address(0), tokenId);
1269     }
1270 
1271     /**
1272      * @dev Transfers `tokenId` from `from` to `to`.
1273      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1274      *
1275      * Requirements:
1276      *
1277      * - `to` cannot be the zero address.
1278      * - `tokenId` token must be owned by `from`.
1279      *
1280      * Emits a {Transfer} event.
1281      */
1282     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1283         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1284         require(to != address(0), "ERC721: transfer to the zero address");
1285 
1286         _beforeTokenTransfer(from, to, tokenId);
1287 
1288         // Clear approvals from the previous owner
1289         _approve(address(0), tokenId);
1290 
1291         _balances[from] -= 1;
1292         _balances[to] += 1;
1293         _owners[tokenId] = to;
1294 
1295         emit Transfer(from, to, tokenId);
1296     }
1297 
1298     /**
1299      * @dev Approve `to` to operate on `tokenId`
1300      *
1301      * Emits a {Approval} event.
1302      */
1303     function _approve(address to, uint256 tokenId) internal virtual {
1304         _tokenApprovals[tokenId] = to;
1305         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1306     }
1307 
1308     /**
1309      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1310      * The call is not executed if the target address is not a contract.
1311      *
1312      * @param from address representing the previous owner of the given token ID
1313      * @param to target address that will receive the tokens
1314      * @param tokenId uint256 ID of the token to be transferred
1315      * @param _data bytes optional data to send along with the call
1316      * @return bool whether the call correctly returned the expected magic value
1317      */
1318     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1319         private returns (bool)
1320     {
1321         if (to.isContract()) {
1322             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1323                 return retval == IERC721Receiver(to).onERC721Received.selector;
1324             } catch (bytes memory reason) {
1325                 if (reason.length == 0) {
1326                     revert("ERC721: transfer to non ERC721Receiver implementer");
1327                 } else {
1328                     // solhint-disable-next-line no-inline-assembly
1329                     assembly {
1330                         revert(add(32, reason), mload(reason))
1331                     }
1332                 }
1333             }
1334         } else {
1335             return true;
1336         }
1337     }
1338 
1339     /**
1340      * @dev Hook that is called before any token transfer. This includes minting
1341      * and burning.
1342      *
1343      * Calling conditions:
1344      *
1345      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1346      * transferred to `to`.
1347      * - When `from` is zero, `tokenId` will be minted for `to`.
1348      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1349      * - `from` cannot be the zero address.
1350      * - `to` cannot be the zero address.
1351      *
1352      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1353      */
1354     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1355 }
1356 
1357 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1358 
1359 
1360 
1361 pragma solidity ^0.8.0;
1362 
1363 
1364 
1365 /**
1366  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1367  * enumerability of all the token ids in the contract as well as all token ids owned by each
1368  * account.
1369  */
1370 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1371     // Mapping from owner to list of owned token IDs
1372     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1373 
1374     // Mapping from token ID to index of the owner tokens list
1375     mapping(uint256 => uint256) private _ownedTokensIndex;
1376 
1377     // Array with all token ids, used for enumeration
1378     uint256[] private _allTokens;
1379 
1380     // Mapping from token id to position in the allTokens array
1381     mapping(uint256 => uint256) private _allTokensIndex;
1382 
1383     /**
1384      * @dev See {IERC165-supportsInterface}.
1385      */
1386     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1387         return interfaceId == type(IERC721Enumerable).interfaceId
1388             || super.supportsInterface(interfaceId);
1389     }
1390 
1391     /**
1392      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1393      */
1394     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1395         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1396         return _ownedTokens[owner][index];
1397     }
1398 
1399     /**
1400      * @dev See {IERC721Enumerable-totalSupply}.
1401      */
1402     function totalSupply() public view virtual override returns (uint256) {
1403         return _allTokens.length;
1404     }
1405 
1406     /**
1407      * @dev See {IERC721Enumerable-tokenByIndex}.
1408      */
1409     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1410         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1411         return _allTokens[index];
1412     }
1413 
1414     /**
1415      * @dev Hook that is called before any token transfer. This includes minting
1416      * and burning.
1417      *
1418      * Calling conditions:
1419      *
1420      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1421      * transferred to `to`.
1422      * - When `from` is zero, `tokenId` will be minted for `to`.
1423      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1424      * - `from` cannot be the zero address.
1425      * - `to` cannot be the zero address.
1426      *
1427      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1428      */
1429     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1430         super._beforeTokenTransfer(from, to, tokenId);
1431 
1432         if (from == address(0)) {
1433             _addTokenToAllTokensEnumeration(tokenId);
1434         } else if (from != to) {
1435             _removeTokenFromOwnerEnumeration(from, tokenId);
1436         }
1437         if (to == address(0)) {
1438             _removeTokenFromAllTokensEnumeration(tokenId);
1439         } else if (to != from) {
1440             _addTokenToOwnerEnumeration(to, tokenId);
1441         }
1442     }
1443 
1444     /**
1445      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1446      * @param to address representing the new owner of the given token ID
1447      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1448      */
1449     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1450         uint256 length = ERC721.balanceOf(to);
1451         _ownedTokens[to][length] = tokenId;
1452         _ownedTokensIndex[tokenId] = length;
1453     }
1454 
1455     /**
1456      * @dev Private function to add a token to this extension's token tracking data structures.
1457      * @param tokenId uint256 ID of the token to be added to the tokens list
1458      */
1459     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1460         _allTokensIndex[tokenId] = _allTokens.length;
1461         _allTokens.push(tokenId);
1462     }
1463 
1464     /**
1465      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1466      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1467      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1468      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1469      * @param from address representing the previous owner of the given token ID
1470      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1471      */
1472     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1473         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1474         // then delete the last slot (swap and pop).
1475 
1476         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1477         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1478 
1479         // When the token to delete is the last token, the swap operation is unnecessary
1480         if (tokenIndex != lastTokenIndex) {
1481             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1482 
1483             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1484             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1485         }
1486 
1487         // This also deletes the contents at the last position of the array
1488         delete _ownedTokensIndex[tokenId];
1489         delete _ownedTokens[from][lastTokenIndex];
1490     }
1491 
1492     /**
1493      * @dev Private function to remove a token from this extension's token tracking data structures.
1494      * This has O(1) time complexity, but alters the order of the _allTokens array.
1495      * @param tokenId uint256 ID of the token to be removed from the tokens list
1496      */
1497     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1498         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1499         // then delete the last slot (swap and pop).
1500 
1501         uint256 lastTokenIndex = _allTokens.length - 1;
1502         uint256 tokenIndex = _allTokensIndex[tokenId];
1503 
1504         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1505         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1506         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1507         uint256 lastTokenId = _allTokens[lastTokenIndex];
1508 
1509         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1510         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1511 
1512         // This also deletes the contents at the last position of the array
1513         delete _allTokensIndex[tokenId];
1514         _allTokens.pop();
1515     }
1516 }
1517 
1518 // File: contracts/BabyDinosNFTToken.sol
1519 
1520 
1521 pragma experimental ABIEncoderV2;
1522 
1523 pragma solidity ^0.8.0;
1524 
1525 
1526 
1527 
1528 
1529 
1530 contract BabyDinosNFTToken is ERC721Enumerable, Ownable, Royalties, MinterRole {
1531     using Strings for uint256;
1532     using SafeMath for uint256;
1533 
1534     string public baseExtension = ".json";
1535     string public baseURI = "https://thumbnail-egg-collections.s3.us-east-2.amazonaws.com/";
1536 
1537     struct RenderToken {
1538         uint256 id;
1539         string uri;
1540     }
1541 
1542     event Mint(address indexed to, uint256 indexed tokenId);
1543 
1544     constructor(
1545         string memory _name,
1546         string memory _symbol,
1547         uint256 _amount,
1548         address payable _creator
1549     ) ERC721(_name, _symbol) Royalties(_amount, _creator) {}
1550 
1551     function mint(
1552         address _to,
1553         uint256 _mintAmount
1554     ) public onlyMinter returns (bool) {
1555         require(_mintAmount > 0, "BabyDinosNFTToken: mintAmount should be > 0");
1556         uint256 supply = totalSupply();
1557 
1558         for (uint256 i = 1; i <= _mintAmount; i++) {
1559             _safeMint(_to, supply + i);
1560             emit Mint(_to, supply + i);
1561         }
1562 
1563         return true;
1564     }
1565 
1566     function walletOfOwner(address _owner)
1567         public
1568         view
1569         returns (uint256[] memory)
1570     {
1571         uint256 ownerTokenCount = balanceOf(_owner);
1572         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1573         for (uint256 i; i < ownerTokenCount; i++) {
1574             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1575         }
1576         return tokenIds;
1577     }
1578 
1579     function tokenURI(uint256 tokenId)
1580         public
1581         view
1582         virtual
1583         override
1584         returns (string memory)
1585     {
1586         require(
1587             _exists(tokenId),
1588             "BabyDinosNFTToken: URI query for nonexistent token"
1589         );
1590 
1591         string memory currentBaseURI = _baseURI();
1592         return
1593             bytes(currentBaseURI).length > 0
1594                 ? string(
1595                     abi.encodePacked(
1596                         currentBaseURI,
1597                         tokenId.toString(),
1598                         baseExtension
1599                     )
1600                 )
1601                 : "";
1602     }
1603 
1604     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1605         baseURI = _newBaseURI;
1606     }
1607 
1608     function setBaseExtension(string memory _newBaseExtension)
1609         public
1610         onlyOwner
1611     {
1612         baseExtension = _newBaseExtension;
1613     }
1614 
1615     // internal
1616     function _baseURI() internal view virtual override returns (string memory) {
1617         return baseURI;
1618     }
1619 }