1 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.2.0
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 // CAUTION
8 // This version of SafeMath should only be used with Solidity 0.8 or later,
9 // because it relies on the compiler's built in overflow checks.
10 
11 /**
12  * @dev Wrappers over Solidity's arithmetic operations.
13  *
14  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
15  * now has built in overflow checking.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, with an overflow flag.
20      *
21      * _Available since v3.4._
22      */
23     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
24         unchecked {
25             uint256 c = a + b;
26             if (c < a) return (false, 0);
27             return (true, c);
28         }
29     }
30 
31     /**
32      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
33      *
34      * _Available since v3.4._
35      */
36     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
37         unchecked {
38             if (b > a) return (false, 0);
39             return (true, a - b);
40         }
41     }
42 
43     /**
44      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
45      *
46      * _Available since v3.4._
47      */
48     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
49         unchecked {
50             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51             // benefit is lost if 'b' is also tested.
52             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
53             if (a == 0) return (true, 0);
54             uint256 c = a * b;
55             if (c / a != b) return (false, 0);
56             return (true, c);
57         }
58     }
59 
60     /**
61      * @dev Returns the division of two unsigned integers, with a division by zero flag.
62      *
63      * _Available since v3.4._
64      */
65     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
66         unchecked {
67             if (b == 0) return (false, 0);
68             return (true, a / b);
69         }
70     }
71 
72     /**
73      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
74      *
75      * _Available since v3.4._
76      */
77     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
78         unchecked {
79             if (b == 0) return (false, 0);
80             return (true, a % b);
81         }
82     }
83 
84     /**
85      * @dev Returns the addition of two unsigned integers, reverting on
86      * overflow.
87      *
88      * Counterpart to Solidity's `+` operator.
89      *
90      * Requirements:
91      *
92      * - Addition cannot overflow.
93      */
94     function add(uint256 a, uint256 b) internal pure returns (uint256) {
95         return a + b;
96     }
97 
98     /**
99      * @dev Returns the subtraction of two unsigned integers, reverting on
100      * overflow (when the result is negative).
101      *
102      * Counterpart to Solidity's `-` operator.
103      *
104      * Requirements:
105      *
106      * - Subtraction cannot overflow.
107      */
108     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
109         return a - b;
110     }
111 
112     /**
113      * @dev Returns the multiplication of two unsigned integers, reverting on
114      * overflow.
115      *
116      * Counterpart to Solidity's `*` operator.
117      *
118      * Requirements:
119      *
120      * - Multiplication cannot overflow.
121      */
122     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
123         return a * b;
124     }
125 
126     /**
127      * @dev Returns the integer division of two unsigned integers, reverting on
128      * division by zero. The result is rounded towards zero.
129      *
130      * Counterpart to Solidity's `/` operator.
131      *
132      * Requirements:
133      *
134      * - The divisor cannot be zero.
135      */
136     function div(uint256 a, uint256 b) internal pure returns (uint256) {
137         return a / b;
138     }
139 
140     /**
141      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
142      * reverting when dividing by zero.
143      *
144      * Counterpart to Solidity's `%` operator. This function uses a `revert`
145      * opcode (which leaves remaining gas untouched) while Solidity uses an
146      * invalid opcode to revert (consuming all remaining gas).
147      *
148      * Requirements:
149      *
150      * - The divisor cannot be zero.
151      */
152     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
153         return a % b;
154     }
155 
156     /**
157      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
158      * overflow (when the result is negative).
159      *
160      * CAUTION: This function is deprecated because it requires allocating memory for the error
161      * message unnecessarily. For custom revert reasons use {trySub}.
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      *
167      * - Subtraction cannot overflow.
168      */
169     function sub(
170         uint256 a,
171         uint256 b,
172         string memory errorMessage
173     ) internal pure returns (uint256) {
174         unchecked {
175             require(b <= a, errorMessage);
176             return a - b;
177         }
178     }
179 
180     /**
181      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
182      * division by zero. The result is rounded towards zero.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(
193         uint256 a,
194         uint256 b,
195         string memory errorMessage
196     ) internal pure returns (uint256) {
197         unchecked {
198             require(b > 0, errorMessage);
199             return a / b;
200         }
201     }
202 
203     /**
204      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
205      * reverting with custom message when dividing by zero.
206      *
207      * CAUTION: This function is deprecated because it requires allocating memory for the error
208      * message unnecessarily. For custom revert reasons use {tryMod}.
209      *
210      * Counterpart to Solidity's `%` operator. This function uses a `revert`
211      * opcode (which leaves remaining gas untouched) while Solidity uses an
212      * invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function mod(
219         uint256 a,
220         uint256 b,
221         string memory errorMessage
222     ) internal pure returns (uint256) {
223         unchecked {
224             require(b > 0, errorMessage);
225             return a % b;
226         }
227     }
228 }
229 
230 
231 // File @openzeppelin/contracts/utils/Context.sol@v4.2.0
232 
233 
234 
235 pragma solidity ^0.8.0;
236 
237 /*
238  * @dev Provides information about the current execution context, including the
239  * sender of the transaction and its data. While these are generally available
240  * via msg.sender and msg.data, they should not be accessed in such a direct
241  * manner, since when dealing with meta-transactions the account sending and
242  * paying for execution may not be the actual sender (as far as an application
243  * is concerned).
244  *
245  * This contract is only required for intermediate, library-like contracts.
246  */
247 abstract contract Context {
248     function _msgSender() internal view virtual returns (address) {
249         return msg.sender;
250     }
251 
252     function _msgData() internal view virtual returns (bytes calldata) {
253         return msg.data;
254     }
255 }
256 
257 
258 // File @openzeppelin/contracts/access/Ownable.sol@v4.2.0
259 
260 
261 
262 pragma solidity ^0.8.0;
263 
264 /**
265  * @dev Contract module which provides a basic access control mechanism, where
266  * there is an account (an owner) that can be granted exclusive access to
267  * specific functions.
268  *
269  * By default, the owner account will be the one that deploys the contract. This
270  * can later be changed with {transferOwnership}.
271  *
272  * This module is used through inheritance. It will make available the modifier
273  * `onlyOwner`, which can be applied to your functions to restrict their use to
274  * the owner.
275  */
276 abstract contract Ownable is Context {
277     address private _owner;
278 
279     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
280 
281     /**
282      * @dev Initializes the contract setting the deployer as the initial owner.
283      */
284     constructor() {
285         _setOwner(_msgSender());
286     }
287 
288     /**
289      * @dev Returns the address of the current owner.
290      */
291     function owner() public view virtual returns (address) {
292         return _owner;
293     }
294 
295     /**
296      * @dev Throws if called by any account other than the owner.
297      */
298     modifier onlyOwner() {
299         require(owner() == _msgSender(), "Ownable: caller is not the owner");
300         _;
301     }
302 
303     /**
304      * @dev Leaves the contract without owner. It will not be possible to call
305      * `onlyOwner` functions anymore. Can only be called by the current owner.
306      *
307      * NOTE: Renouncing ownership will leave the contract without an owner,
308      * thereby removing any functionality that is only available to the owner.
309      */
310     function renounceOwnership() public virtual onlyOwner {
311         _setOwner(address(0));
312     }
313 
314     /**
315      * @dev Transfers ownership of the contract to a new account (`newOwner`).
316      * Can only be called by the current owner.
317      */
318     function transferOwnership(address newOwner) public virtual onlyOwner {
319         require(newOwner != address(0), "Ownable: new owner is the zero address");
320         _setOwner(newOwner);
321     }
322 
323     function _setOwner(address newOwner) private {
324         address oldOwner = _owner;
325         _owner = newOwner;
326         emit OwnershipTransferred(oldOwner, newOwner);
327     }
328 }
329 
330 
331 // File contracts/clubs.sol
332 
333 
334 pragma solidity ^0.8.0;
335 
336 
337 contract Clubs is Ownable {
338 
339     using SafeMath for uint256;
340 
341     Club[3] internal arrayClubs;
342 
343     modifier clubExist(uint256 id) {
344         require(id < arrayClubs.length, "This club does not exist.");
345         _;
346     }
347 
348     struct Club {
349         string name;
350         uint256[] tokens;
351         bool locked;
352     }
353 
354     constructor() {
355         arrayClubs[0] = Club("Curators", new uint256[](0), false);
356         arrayClubs[1] = Club("Royalties", new uint256[](0), false);
357         arrayClubs[2] = Club("Traders", new uint256[](0), false);
358     }
359 
360     function getClub(uint256 id) external view clubExist(id) returns(Club memory) {
361         return arrayClubs[id];
362     }
363 
364     function addClubToken(uint256 id, uint256 _tokenId) external onlyOwner clubExist(id) {
365         require(!arrayClubs[id].locked, "Club is locked.");
366 
367         bool isAlreadyInClub = false;
368         for (uint256 i; i < arrayClubs[id].tokens.length; i++) {
369             if (arrayClubs[id].tokens[i] == _tokenId) {
370                 isAlreadyInClub = true;
371             }
372         }
373 
374         if (!isAlreadyInClub) {
375             arrayClubs[id].tokens.push(_tokenId);
376         }
377     }
378 
379     function updateClubToken(uint256 id, uint256 _oldTokenId, uint256 _newTokenId) external onlyOwner clubExist(id) {
380         require(!arrayClubs[id].locked, "Club is locked.");
381 
382         for (uint256 i; i < arrayClubs[id].tokens.length; i++) {
383             if (arrayClubs[id].tokens[i] == _oldTokenId) {
384                 arrayClubs[id].tokens[i] = _newTokenId;
385             }
386         }
387     }
388 
389     function lockClub(uint256 id) external onlyOwner clubExist(id) {
390         require(!arrayClubs[id].locked, "Club is locked.");
391 
392         arrayClubs[id].locked = true;
393     }
394 }
395 
396 
397 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.2.0
398 
399 
400 
401 pragma solidity ^0.8.0;
402 
403 /**
404  * @dev Interface of the ERC165 standard, as defined in the
405  * https://eips.ethereum.org/EIPS/eip-165[EIP].
406  *
407  * Implementers can declare support of contract interfaces, which can then be
408  * queried by others ({ERC165Checker}).
409  *
410  * For an implementation, see {ERC165}.
411  */
412 interface IERC165 {
413     /**
414      * @dev Returns true if this contract implements the interface defined by
415      * `interfaceId`. See the corresponding
416      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
417      * to learn more about how these ids are created.
418      *
419      * This function call must use less than 30 000 gas.
420      */
421     function supportsInterface(bytes4 interfaceId) external view returns (bool);
422 }
423 
424 
425 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.2.0
426 
427 
428 
429 pragma solidity ^0.8.0;
430 
431 /**
432  * @dev Required interface of an ERC721 compliant contract.
433  */
434 interface IERC721 is IERC165 {
435     /**
436      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
437      */
438     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
439 
440     /**
441      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
442      */
443     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
444 
445     /**
446      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
447      */
448     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
449 
450     /**
451      * @dev Returns the number of tokens in ``owner``'s account.
452      */
453     function balanceOf(address owner) external view returns (uint256 balance);
454 
455     /**
456      * @dev Returns the owner of the `tokenId` token.
457      *
458      * Requirements:
459      *
460      * - `tokenId` must exist.
461      */
462     function ownerOf(uint256 tokenId) external view returns (address owner);
463 
464     /**
465      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
466      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
467      *
468      * Requirements:
469      *
470      * - `from` cannot be the zero address.
471      * - `to` cannot be the zero address.
472      * - `tokenId` token must exist and be owned by `from`.
473      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
474      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
475      *
476      * Emits a {Transfer} event.
477      */
478     function safeTransferFrom(
479         address from,
480         address to,
481         uint256 tokenId
482     ) external;
483 
484     /**
485      * @dev Transfers `tokenId` token from `from` to `to`.
486      *
487      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
488      *
489      * Requirements:
490      *
491      * - `from` cannot be the zero address.
492      * - `to` cannot be the zero address.
493      * - `tokenId` token must be owned by `from`.
494      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
495      *
496      * Emits a {Transfer} event.
497      */
498     function transferFrom(
499         address from,
500         address to,
501         uint256 tokenId
502     ) external;
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
548      * @dev Safely transfers `tokenId` token from `from` to `to`.
549      *
550      * Requirements:
551      *
552      * - `from` cannot be the zero address.
553      * - `to` cannot be the zero address.
554      * - `tokenId` token must exist and be owned by `from`.
555      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
556      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
557      *
558      * Emits a {Transfer} event.
559      */
560     function safeTransferFrom(
561         address from,
562         address to,
563         uint256 tokenId,
564         bytes calldata data
565     ) external;
566 }
567 
568 
569 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.2.0
570 
571 
572 
573 pragma solidity ^0.8.0;
574 
575 /**
576  * @title ERC721 token receiver interface
577  * @dev Interface for any contract that wants to support safeTransfers
578  * from ERC721 asset contracts.
579  */
580 interface IERC721Receiver {
581     /**
582      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
583      * by `operator` from `from`, this function is called.
584      *
585      * It must return its Solidity selector to confirm the token transfer.
586      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
587      *
588      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
589      */
590     function onERC721Received(
591         address operator,
592         address from,
593         uint256 tokenId,
594         bytes calldata data
595     ) external returns (bytes4);
596 }
597 
598 
599 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.2.0
600 
601 
602 
603 pragma solidity ^0.8.0;
604 
605 /**
606  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
607  * @dev See https://eips.ethereum.org/EIPS/eip-721
608  */
609 interface IERC721Metadata is IERC721 {
610     /**
611      * @dev Returns the token collection name.
612      */
613     function name() external view returns (string memory);
614 
615     /**
616      * @dev Returns the token collection symbol.
617      */
618     function symbol() external view returns (string memory);
619 
620     /**
621      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
622      */
623     function tokenURI(uint256 tokenId) external view returns (string memory);
624 }
625 
626 
627 // File @openzeppelin/contracts/utils/Address.sol@v4.2.0
628 
629 
630 
631 pragma solidity ^0.8.0;
632 
633 /**
634  * @dev Collection of functions related to the address type
635  */
636 library Address {
637     /**
638      * @dev Returns true if `account` is a contract.
639      *
640      * [IMPORTANT]
641      * ====
642      * It is unsafe to assume that an address for which this function returns
643      * false is an externally-owned account (EOA) and not a contract.
644      *
645      * Among others, `isContract` will return false for the following
646      * types of addresses:
647      *
648      *  - an externally-owned account
649      *  - a contract in construction
650      *  - an address where a contract will be created
651      *  - an address where a contract lived, but was destroyed
652      * ====
653      */
654     function isContract(address account) internal view returns (bool) {
655         // This method relies on extcodesize, which returns 0 for contracts in
656         // construction, since the code is only stored at the end of the
657         // constructor execution.
658 
659         uint256 size;
660         assembly {
661             size := extcodesize(account)
662         }
663         return size > 0;
664     }
665 
666     /**
667      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
668      * `recipient`, forwarding all available gas and reverting on errors.
669      *
670      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
671      * of certain opcodes, possibly making contracts go over the 2300 gas limit
672      * imposed by `transfer`, making them unable to receive funds via
673      * `transfer`. {sendValue} removes this limitation.
674      *
675      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
676      *
677      * IMPORTANT: because control is transferred to `recipient`, care must be
678      * taken to not create reentrancy vulnerabilities. Consider using
679      * {ReentrancyGuard} or the
680      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
681      */
682     function sendValue(address payable recipient, uint256 amount) internal {
683         require(address(this).balance >= amount, "Address: insufficient balance");
684 
685         (bool success, ) = recipient.call{value: amount}("");
686         require(success, "Address: unable to send value, recipient may have reverted");
687     }
688 
689     /**
690      * @dev Performs a Solidity function call using a low level `call`. A
691      * plain `call` is an unsafe replacement for a function call: use this
692      * function instead.
693      *
694      * If `target` reverts with a revert reason, it is bubbled up by this
695      * function (like regular Solidity function calls).
696      *
697      * Returns the raw returned data. To convert to the expected return value,
698      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
699      *
700      * Requirements:
701      *
702      * - `target` must be a contract.
703      * - calling `target` with `data` must not revert.
704      *
705      * _Available since v3.1._
706      */
707     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
708         return functionCall(target, data, "Address: low-level call failed");
709     }
710 
711     /**
712      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
713      * `errorMessage` as a fallback revert reason when `target` reverts.
714      *
715      * _Available since v3.1._
716      */
717     function functionCall(
718         address target,
719         bytes memory data,
720         string memory errorMessage
721     ) internal returns (bytes memory) {
722         return functionCallWithValue(target, data, 0, errorMessage);
723     }
724 
725     /**
726      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
727      * but also transferring `value` wei to `target`.
728      *
729      * Requirements:
730      *
731      * - the calling contract must have an ETH balance of at least `value`.
732      * - the called Solidity function must be `payable`.
733      *
734      * _Available since v3.1._
735      */
736     function functionCallWithValue(
737         address target,
738         bytes memory data,
739         uint256 value
740     ) internal returns (bytes memory) {
741         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
742     }
743 
744     /**
745      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
746      * with `errorMessage` as a fallback revert reason when `target` reverts.
747      *
748      * _Available since v3.1._
749      */
750     function functionCallWithValue(
751         address target,
752         bytes memory data,
753         uint256 value,
754         string memory errorMessage
755     ) internal returns (bytes memory) {
756         require(address(this).balance >= value, "Address: insufficient balance for call");
757         require(isContract(target), "Address: call to non-contract");
758 
759         (bool success, bytes memory returndata) = target.call{value: value}(data);
760         return _verifyCallResult(success, returndata, errorMessage);
761     }
762 
763     /**
764      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
765      * but performing a static call.
766      *
767      * _Available since v3.3._
768      */
769     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
770         return functionStaticCall(target, data, "Address: low-level static call failed");
771     }
772 
773     /**
774      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
775      * but performing a static call.
776      *
777      * _Available since v3.3._
778      */
779     function functionStaticCall(
780         address target,
781         bytes memory data,
782         string memory errorMessage
783     ) internal view returns (bytes memory) {
784         require(isContract(target), "Address: static call to non-contract");
785 
786         (bool success, bytes memory returndata) = target.staticcall(data);
787         return _verifyCallResult(success, returndata, errorMessage);
788     }
789 
790     /**
791      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
792      * but performing a delegate call.
793      *
794      * _Available since v3.4._
795      */
796     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
797         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
798     }
799 
800     /**
801      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
802      * but performing a delegate call.
803      *
804      * _Available since v3.4._
805      */
806     function functionDelegateCall(
807         address target,
808         bytes memory data,
809         string memory errorMessage
810     ) internal returns (bytes memory) {
811         require(isContract(target), "Address: delegate call to non-contract");
812 
813         (bool success, bytes memory returndata) = target.delegatecall(data);
814         return _verifyCallResult(success, returndata, errorMessage);
815     }
816 
817     function _verifyCallResult(
818         bool success,
819         bytes memory returndata,
820         string memory errorMessage
821     ) private pure returns (bytes memory) {
822         if (success) {
823             return returndata;
824         } else {
825             // Look for revert reason and bubble it up if present
826             if (returndata.length > 0) {
827                 // The easiest way to bubble the revert reason is using memory via assembly
828 
829                 assembly {
830                     let returndata_size := mload(returndata)
831                     revert(add(32, returndata), returndata_size)
832                 }
833             } else {
834                 revert(errorMessage);
835             }
836         }
837     }
838 }
839 
840 
841 // File @openzeppelin/contracts/utils/Strings.sol@v4.2.0
842 
843 
844 
845 pragma solidity ^0.8.0;
846 
847 /**
848  * @dev String operations.
849  */
850 library Strings {
851     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
852 
853     /**
854      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
855      */
856     function toString(uint256 value) internal pure returns (string memory) {
857         // Inspired by OraclizeAPI's implementation - MIT licence
858         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
859 
860         if (value == 0) {
861             return "0";
862         }
863         uint256 temp = value;
864         uint256 digits;
865         while (temp != 0) {
866             digits++;
867             temp /= 10;
868         }
869         bytes memory buffer = new bytes(digits);
870         while (value != 0) {
871             digits -= 1;
872             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
873             value /= 10;
874         }
875         return string(buffer);
876     }
877 
878     /**
879      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
880      */
881     function toHexString(uint256 value) internal pure returns (string memory) {
882         if (value == 0) {
883             return "0x00";
884         }
885         uint256 temp = value;
886         uint256 length = 0;
887         while (temp != 0) {
888             length++;
889             temp >>= 8;
890         }
891         return toHexString(value, length);
892     }
893 
894     /**
895      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
896      */
897     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
898         bytes memory buffer = new bytes(2 * length + 2);
899         buffer[0] = "0";
900         buffer[1] = "x";
901         for (uint256 i = 2 * length + 1; i > 1; --i) {
902             buffer[i] = _HEX_SYMBOLS[value & 0xf];
903             value >>= 4;
904         }
905         require(value == 0, "Strings: hex length insufficient");
906         return string(buffer);
907     }
908 }
909 
910 
911 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.2.0
912 
913 
914 
915 pragma solidity ^0.8.0;
916 
917 /**
918  * @dev Implementation of the {IERC165} interface.
919  *
920  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
921  * for the additional interface id that will be supported. For example:
922  *
923  * ```solidity
924  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
925  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
926  * }
927  * ```
928  *
929  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
930  */
931 abstract contract ERC165 is IERC165 {
932     /**
933      * @dev See {IERC165-supportsInterface}.
934      */
935     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
936         return interfaceId == type(IERC165).interfaceId;
937     }
938 }
939 
940 
941 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.2.0
942 
943 
944 
945 pragma solidity ^0.8.0;
946 
947 
948 
949 
950 
951 
952 
953 /**
954  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
955  * the Metadata extension, but not including the Enumerable extension, which is available separately as
956  * {ERC721Enumerable}.
957  */
958 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
959     using Address for address;
960     using Strings for uint256;
961 
962     // Token name
963     string private _name;
964 
965     // Token symbol
966     string private _symbol;
967 
968     // Mapping from token ID to owner address
969     mapping(uint256 => address) private _owners;
970 
971     // Mapping owner address to token count
972     mapping(address => uint256) private _balances;
973 
974     // Mapping from token ID to approved address
975     mapping(uint256 => address) private _tokenApprovals;
976 
977     // Mapping from owner to operator approvals
978     mapping(address => mapping(address => bool)) private _operatorApprovals;
979 
980     /**
981      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
982      */
983     constructor(string memory name_, string memory symbol_) {
984         _name = name_;
985         _symbol = symbol_;
986     }
987 
988     /**
989      * @dev See {IERC165-supportsInterface}.
990      */
991     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
992         return
993             interfaceId == type(IERC721).interfaceId ||
994             interfaceId == type(IERC721Metadata).interfaceId ||
995             super.supportsInterface(interfaceId);
996     }
997 
998     /**
999      * @dev See {IERC721-balanceOf}.
1000      */
1001     function balanceOf(address owner) public view virtual override returns (uint256) {
1002         require(owner != address(0), "ERC721: balance query for the zero address");
1003         return _balances[owner];
1004     }
1005 
1006     /**
1007      * @dev See {IERC721-ownerOf}.
1008      */
1009     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1010         address owner = _owners[tokenId];
1011         require(owner != address(0), "ERC721: owner query for nonexistent token");
1012         return owner;
1013     }
1014 
1015     /**
1016      * @dev See {IERC721Metadata-name}.
1017      */
1018     function name() public view virtual override returns (string memory) {
1019         return _name;
1020     }
1021 
1022     /**
1023      * @dev See {IERC721Metadata-symbol}.
1024      */
1025     function symbol() public view virtual override returns (string memory) {
1026         return _symbol;
1027     }
1028 
1029     /**
1030      * @dev See {IERC721Metadata-tokenURI}.
1031      */
1032     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1033         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1034 
1035         string memory baseURI = _baseURI();
1036         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1037     }
1038 
1039     /**
1040      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1041      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1042      * by default, can be overriden in child contracts.
1043      */
1044     function _baseURI() internal view virtual returns (string memory) {
1045         return "";
1046     }
1047 
1048     /**
1049      * @dev See {IERC721-approve}.
1050      */
1051     function approve(address to, uint256 tokenId) public virtual override {
1052         address owner = ERC721.ownerOf(tokenId);
1053         require(to != owner, "ERC721: approval to current owner");
1054 
1055         require(
1056             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1057             "ERC721: approve caller is not owner nor approved for all"
1058         );
1059 
1060         _approve(to, tokenId);
1061     }
1062 
1063     /**
1064      * @dev See {IERC721-getApproved}.
1065      */
1066     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1067         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1068 
1069         return _tokenApprovals[tokenId];
1070     }
1071 
1072     /**
1073      * @dev See {IERC721-setApprovalForAll}.
1074      */
1075     function setApprovalForAll(address operator, bool approved) public virtual override {
1076         require(operator != _msgSender(), "ERC721: approve to caller");
1077 
1078         _operatorApprovals[_msgSender()][operator] = approved;
1079         emit ApprovalForAll(_msgSender(), operator, approved);
1080     }
1081 
1082     /**
1083      * @dev See {IERC721-isApprovedForAll}.
1084      */
1085     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1086         return _operatorApprovals[owner][operator];
1087     }
1088 
1089     /**
1090      * @dev See {IERC721-transferFrom}.
1091      */
1092     function transferFrom(
1093         address from,
1094         address to,
1095         uint256 tokenId
1096     ) public virtual override {
1097         //solhint-disable-next-line max-line-length
1098         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1099 
1100         _transfer(from, to, tokenId);
1101     }
1102 
1103     /**
1104      * @dev See {IERC721-safeTransferFrom}.
1105      */
1106     function safeTransferFrom(
1107         address from,
1108         address to,
1109         uint256 tokenId
1110     ) public virtual override {
1111         safeTransferFrom(from, to, tokenId, "");
1112     }
1113 
1114     /**
1115      * @dev See {IERC721-safeTransferFrom}.
1116      */
1117     function safeTransferFrom(
1118         address from,
1119         address to,
1120         uint256 tokenId,
1121         bytes memory _data
1122     ) public virtual override {
1123         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1124         _safeTransfer(from, to, tokenId, _data);
1125     }
1126 
1127     /**
1128      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1129      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1130      *
1131      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1132      *
1133      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1134      * implement alternative mechanisms to perform token transfer, such as signature-based.
1135      *
1136      * Requirements:
1137      *
1138      * - `from` cannot be the zero address.
1139      * - `to` cannot be the zero address.
1140      * - `tokenId` token must exist and be owned by `from`.
1141      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1142      *
1143      * Emits a {Transfer} event.
1144      */
1145     function _safeTransfer(
1146         address from,
1147         address to,
1148         uint256 tokenId,
1149         bytes memory _data
1150     ) internal virtual {
1151         _transfer(from, to, tokenId);
1152         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1153     }
1154 
1155     /**
1156      * @dev Returns whether `tokenId` exists.
1157      *
1158      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1159      *
1160      * Tokens start existing when they are minted (`_mint`),
1161      * and stop existing when they are burned (`_burn`).
1162      */
1163     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1164         return _owners[tokenId] != address(0);
1165     }
1166 
1167     /**
1168      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1169      *
1170      * Requirements:
1171      *
1172      * - `tokenId` must exist.
1173      */
1174     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1175         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1176         address owner = ERC721.ownerOf(tokenId);
1177         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1178     }
1179 
1180     /**
1181      * @dev Safely mints `tokenId` and transfers it to `to`.
1182      *
1183      * Requirements:
1184      *
1185      * - `tokenId` must not exist.
1186      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1187      *
1188      * Emits a {Transfer} event.
1189      */
1190     function _safeMint(address to, uint256 tokenId) internal virtual {
1191         _safeMint(to, tokenId, "");
1192     }
1193 
1194     /**
1195      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1196      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1197      */
1198     function _safeMint(
1199         address to,
1200         uint256 tokenId,
1201         bytes memory _data
1202     ) internal virtual {
1203         _mint(to, tokenId);
1204         require(
1205             _checkOnERC721Received(address(0), to, tokenId, _data),
1206             "ERC721: transfer to non ERC721Receiver implementer"
1207         );
1208     }
1209 
1210     /**
1211      * @dev Mints `tokenId` and transfers it to `to`.
1212      *
1213      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1214      *
1215      * Requirements:
1216      *
1217      * - `tokenId` must not exist.
1218      * - `to` cannot be the zero address.
1219      *
1220      * Emits a {Transfer} event.
1221      */
1222     function _mint(address to, uint256 tokenId) internal virtual {
1223         require(to != address(0), "ERC721: mint to the zero address");
1224         require(!_exists(tokenId), "ERC721: token already minted");
1225 
1226         _beforeTokenTransfer(address(0), to, tokenId);
1227 
1228         _balances[to] += 1;
1229         _owners[tokenId] = to;
1230 
1231         emit Transfer(address(0), to, tokenId);
1232     }
1233 
1234     /**
1235      * @dev Destroys `tokenId`.
1236      * The approval is cleared when the token is burned.
1237      *
1238      * Requirements:
1239      *
1240      * - `tokenId` must exist.
1241      *
1242      * Emits a {Transfer} event.
1243      */
1244     function _burn(uint256 tokenId) internal virtual {
1245         address owner = ERC721.ownerOf(tokenId);
1246 
1247         _beforeTokenTransfer(owner, address(0), tokenId);
1248 
1249         // Clear approvals
1250         _approve(address(0), tokenId);
1251 
1252         _balances[owner] -= 1;
1253         delete _owners[tokenId];
1254 
1255         emit Transfer(owner, address(0), tokenId);
1256     }
1257 
1258     /**
1259      * @dev Transfers `tokenId` from `from` to `to`.
1260      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1261      *
1262      * Requirements:
1263      *
1264      * - `to` cannot be the zero address.
1265      * - `tokenId` token must be owned by `from`.
1266      *
1267      * Emits a {Transfer} event.
1268      */
1269     function _transfer(
1270         address from,
1271         address to,
1272         uint256 tokenId
1273     ) internal virtual {
1274         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1275         require(to != address(0), "ERC721: transfer to the zero address");
1276 
1277         _beforeTokenTransfer(from, to, tokenId);
1278 
1279         // Clear approvals from the previous owner
1280         _approve(address(0), tokenId);
1281 
1282         _balances[from] -= 1;
1283         _balances[to] += 1;
1284         _owners[tokenId] = to;
1285 
1286         emit Transfer(from, to, tokenId);
1287     }
1288 
1289     /**
1290      * @dev Approve `to` to operate on `tokenId`
1291      *
1292      * Emits a {Approval} event.
1293      */
1294     function _approve(address to, uint256 tokenId) internal virtual {
1295         _tokenApprovals[tokenId] = to;
1296         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1297     }
1298 
1299     /**
1300      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1301      * The call is not executed if the target address is not a contract.
1302      *
1303      * @param from address representing the previous owner of the given token ID
1304      * @param to target address that will receive the tokens
1305      * @param tokenId uint256 ID of the token to be transferred
1306      * @param _data bytes optional data to send along with the call
1307      * @return bool whether the call correctly returned the expected magic value
1308      */
1309     function _checkOnERC721Received(
1310         address from,
1311         address to,
1312         uint256 tokenId,
1313         bytes memory _data
1314     ) private returns (bool) {
1315         if (to.isContract()) {
1316             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1317                 return retval == IERC721Receiver(to).onERC721Received.selector;
1318             } catch (bytes memory reason) {
1319                 if (reason.length == 0) {
1320                     revert("ERC721: transfer to non ERC721Receiver implementer");
1321                 } else {
1322                     assembly {
1323                         revert(add(32, reason), mload(reason))
1324                     }
1325                 }
1326             }
1327         } else {
1328             return true;
1329         }
1330     }
1331 
1332     /**
1333      * @dev Hook that is called before any token transfer. This includes minting
1334      * and burning.
1335      *
1336      * Calling conditions:
1337      *
1338      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1339      * transferred to `to`.
1340      * - When `from` is zero, `tokenId` will be minted for `to`.
1341      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1342      * - `from` and `to` are never both zero.
1343      *
1344      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1345      */
1346     function _beforeTokenTransfer(
1347         address from,
1348         address to,
1349         uint256 tokenId
1350     ) internal virtual {}
1351 }
1352 
1353 
1354 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.2.0
1355 
1356 
1357 
1358 pragma solidity ^0.8.0;
1359 
1360 /**
1361  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1362  * @dev See https://eips.ethereum.org/EIPS/eip-721
1363  */
1364 interface IERC721Enumerable is IERC721 {
1365     /**
1366      * @dev Returns the total amount of tokens stored by the contract.
1367      */
1368     function totalSupply() external view returns (uint256);
1369 
1370     /**
1371      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1372      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1373      */
1374     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1375 
1376     /**
1377      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1378      * Use along with {totalSupply} to enumerate all tokens.
1379      */
1380     function tokenByIndex(uint256 index) external view returns (uint256);
1381 }
1382 
1383 
1384 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.2.0
1385 
1386 
1387 
1388 pragma solidity ^0.8.0;
1389 
1390 
1391 /**
1392  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1393  * enumerability of all the token ids in the contract as well as all token ids owned by each
1394  * account.
1395  */
1396 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1397     // Mapping from owner to list of owned token IDs
1398     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1399 
1400     // Mapping from token ID to index of the owner tokens list
1401     mapping(uint256 => uint256) private _ownedTokensIndex;
1402 
1403     // Array with all token ids, used for enumeration
1404     uint256[] private _allTokens;
1405 
1406     // Mapping from token id to position in the allTokens array
1407     mapping(uint256 => uint256) private _allTokensIndex;
1408 
1409     /**
1410      * @dev See {IERC165-supportsInterface}.
1411      */
1412     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1413         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1414     }
1415 
1416     /**
1417      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1418      */
1419     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1420         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1421         return _ownedTokens[owner][index];
1422     }
1423 
1424     /**
1425      * @dev See {IERC721Enumerable-totalSupply}.
1426      */
1427     function totalSupply() public view virtual override returns (uint256) {
1428         return _allTokens.length;
1429     }
1430 
1431     /**
1432      * @dev See {IERC721Enumerable-tokenByIndex}.
1433      */
1434     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1435         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1436         return _allTokens[index];
1437     }
1438 
1439     /**
1440      * @dev Hook that is called before any token transfer. This includes minting
1441      * and burning.
1442      *
1443      * Calling conditions:
1444      *
1445      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1446      * transferred to `to`.
1447      * - When `from` is zero, `tokenId` will be minted for `to`.
1448      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1449      * - `from` cannot be the zero address.
1450      * - `to` cannot be the zero address.
1451      *
1452      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1453      */
1454     function _beforeTokenTransfer(
1455         address from,
1456         address to,
1457         uint256 tokenId
1458     ) internal virtual override {
1459         super._beforeTokenTransfer(from, to, tokenId);
1460 
1461         if (from == address(0)) {
1462             _addTokenToAllTokensEnumeration(tokenId);
1463         } else if (from != to) {
1464             _removeTokenFromOwnerEnumeration(from, tokenId);
1465         }
1466         if (to == address(0)) {
1467             _removeTokenFromAllTokensEnumeration(tokenId);
1468         } else if (to != from) {
1469             _addTokenToOwnerEnumeration(to, tokenId);
1470         }
1471     }
1472 
1473     /**
1474      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1475      * @param to address representing the new owner of the given token ID
1476      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1477      */
1478     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1479         uint256 length = ERC721.balanceOf(to);
1480         _ownedTokens[to][length] = tokenId;
1481         _ownedTokensIndex[tokenId] = length;
1482     }
1483 
1484     /**
1485      * @dev Private function to add a token to this extension's token tracking data structures.
1486      * @param tokenId uint256 ID of the token to be added to the tokens list
1487      */
1488     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1489         _allTokensIndex[tokenId] = _allTokens.length;
1490         _allTokens.push(tokenId);
1491     }
1492 
1493     /**
1494      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1495      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1496      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1497      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1498      * @param from address representing the previous owner of the given token ID
1499      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1500      */
1501     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1502         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1503         // then delete the last slot (swap and pop).
1504 
1505         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1506         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1507 
1508         // When the token to delete is the last token, the swap operation is unnecessary
1509         if (tokenIndex != lastTokenIndex) {
1510             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1511 
1512             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1513             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1514         }
1515 
1516         // This also deletes the contents at the last position of the array
1517         delete _ownedTokensIndex[tokenId];
1518         delete _ownedTokens[from][lastTokenIndex];
1519     }
1520 
1521     /**
1522      * @dev Private function to remove a token from this extension's token tracking data structures.
1523      * This has O(1) time complexity, but alters the order of the _allTokens array.
1524      * @param tokenId uint256 ID of the token to be removed from the tokens list
1525      */
1526     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1527         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1528         // then delete the last slot (swap and pop).
1529 
1530         uint256 lastTokenIndex = _allTokens.length - 1;
1531         uint256 tokenIndex = _allTokensIndex[tokenId];
1532 
1533         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1534         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1535         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1536         uint256 lastTokenId = _allTokens[lastTokenIndex];
1537 
1538         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1539         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1540 
1541         // This also deletes the contents at the last position of the array
1542         delete _allTokensIndex[tokenId];
1543         _allTokens.pop();
1544     }
1545 }
1546 
1547 
1548 // File contracts/Harems.sol
1549 
1550 
1551 /*
1552   _    _                              
1553  | |  | |                             
1554  | |__| | __ _ _ __ ___ _ __ ___  ___ 
1555  |  __  |/ _` | '__/ _ \ '_ ` _ \/ __|
1556  | |  | | (_| | | |  __/ | | | | \__ \
1557  |_|  |_|\__,_|_|  \___|_| |_| |_|___/
1558 
1559 01100010 01111001 00100000 01000010 01101100 01100001 
1560 01100011 01101011 00100000 01001010 01100101 01110011 
1561 01110101 01110011
1562 
1563 */
1564 
1565 pragma solidity ^0.8.0;
1566 
1567 
1568 
1569 
1570 
1571 contract Harems is ERC721, ERC721Enumerable, Ownable, Clubs {
1572 
1573     using SafeMath for uint256;
1574 
1575     uint256 public constant maxSupply = 10000;
1576     uint256 private _price = 0.069 ether;
1577     uint256 private _reserved = 100;
1578 
1579     string public HAR_PROVENANCE = "";
1580     uint256 public startingIndex;
1581 
1582     bool private _saleStarted;
1583     string public baseURI;
1584 
1585     address t1 = 0x37f0945Dc06BF627d4cF875Be442b012eCCd53cb;
1586     address t2 = 0x0693E3446e5DC51BEb27AFDe9d9d42a1d47A8189;
1587 
1588     constructor() ERC721("Harems", "HAR") {
1589         _saleStarted = false;
1590     }
1591 
1592     modifier whenSaleStarted() {
1593         require(_saleStarted);
1594         _;
1595     }
1596 
1597     function mint(uint256 _nbTokens) external payable whenSaleStarted {
1598         uint256 supply = totalSupply();
1599         require(_nbTokens < 21, "You cannot mint more than 20 Tokens at once!");
1600         require(supply + _nbTokens <= maxSupply - _reserved, "Not enough Tokens left.");
1601         require(_nbTokens * _price <= msg.value, "Inconsistent amount sent!");
1602 
1603         for (uint256 i; i < _nbTokens; i++) {
1604             _safeMint(msg.sender, supply + i);
1605         }
1606     }
1607 
1608     function flipSaleStarted() external onlyOwner {
1609         _saleStarted = !_saleStarted;
1610 
1611         if (_saleStarted && startingIndex == 0) {
1612             setStartingIndex();
1613         }
1614     }
1615 
1616     function saleStarted() public view returns(bool) {
1617         return _saleStarted;
1618     }
1619 
1620     function setBaseURI(string memory _URI) external onlyOwner {
1621         baseURI = _URI;
1622     }
1623 
1624     function _baseURI() internal view override(ERC721) returns(string memory) {
1625         return baseURI;
1626     }
1627 
1628     // Make it possible to change the price: just in case
1629     function setPrice(uint256 _newPrice) external onlyOwner {
1630         _price = _newPrice;
1631     }
1632 
1633     function getPrice() public view returns (uint256){
1634         return _price;
1635     }
1636 
1637     function getReservedLeft() public view returns (uint256) {
1638         return _reserved;
1639     }
1640 
1641     // This should be set before sales open.
1642     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1643         HAR_PROVENANCE = provenanceHash;
1644     }
1645 
1646     // Helper to list all the Women of a wallet
1647     function walletOfOwner(address _owner) public view returns(uint256[] memory) {
1648         uint256 tokenCount = balanceOf(_owner);
1649 
1650         uint256[] memory tokensId = new uint256[](tokenCount);
1651         for(uint256 i; i < tokenCount; i++){
1652             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1653         }
1654         return tokensId;
1655     }
1656 
1657     function claimReserved(uint256 _number, address _receiver) external onlyOwner {
1658         require(_number <= _reserved, "That would exceed the max reserved.");
1659 
1660         uint256 _tokenId = totalSupply();
1661         for (uint256 i; i < _number; i++) {
1662             _safeMint(_receiver, _tokenId + i);
1663         }
1664 
1665         _reserved = _reserved - _number;
1666     }
1667 
1668     function setStartingIndex() public {
1669         require(startingIndex == 0, "Starting index is already set");
1670 
1671         // BlockHash only works for the most 256 recent blocks.
1672         uint256 _block_shift = uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp)));
1673         _block_shift =  1 + (_block_shift % 255);
1674 
1675         // This shouldn't happen, but just in case the blockchain gets a reboot?
1676         if (block.number < _block_shift) {
1677             _block_shift = 1;
1678         }
1679 
1680         uint256 _block_ref = block.number - _block_shift;
1681         startingIndex = uint(blockhash(_block_ref)) % maxSupply;
1682 
1683         // Prevent default sequence
1684         if (startingIndex == 0) {
1685             startingIndex = startingIndex + 1;
1686         }
1687     }
1688  
1689     function withdraw() public onlyOwner {
1690         uint256 _balance = address(this).balance;
1691         uint256 _split = _balance.mul(95).div(100);
1692 
1693         require(payable(t1).send(_split));
1694         require(payable(t2).send(_balance.sub(_split)));
1695     }
1696 
1697     function _beforeTokenTransfer(address from, address to, uint256 tokenId)
1698         internal
1699         override(ERC721, ERC721Enumerable)
1700     {
1701         super._beforeTokenTransfer(from, to, tokenId);
1702     }
1703 
1704     function supportsInterface(bytes4 interfaceId)
1705         public
1706         view
1707         override(ERC721, ERC721Enumerable)
1708         returns (bool)
1709     {
1710         return super.supportsInterface(interfaceId);
1711     }
1712 }