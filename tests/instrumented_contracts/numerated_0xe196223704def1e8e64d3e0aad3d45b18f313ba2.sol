1 /**
2  *Submitted for verification at Etherscan.io on 2021-08-23
3  */
4 
5 // Sources flattened with hardhat v2.4.3 https://hardhat.org
6 
7 // File @openzeppelin/contracts/utils/Context.sol@v4.3.0
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity ^0.8.0;
12 
13 /**
14  * @dev Provides information about the current execution context, including the
15  * sender of the transaction and its data. While these are generally available
16  * via msg.sender and msg.data, they should not be accessed in such a direct
17  * manner, since when dealing with meta-transactions the account sending and
18  * paying for execution may not be the actual sender (as far as an application
19  * is concerned).
20  *
21  * This contract is only required for intermediate, library-like contracts.
22  */
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes calldata) {
29         return msg.data;
30     }
31 }
32 
33 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.0
34 
35 pragma solidity ^0.8.0;
36 
37 /**
38  * @dev Contract module which provides a basic access control mechanism, where
39  * there is an account (an owner) that can be granted exclusive access to
40  * specific functions.
41  *
42  * By default, the owner account will be the one that deploys the contract. This
43  * can later be changed with {transferOwnership}.
44  *
45  * This module is used through inheritance. It will make available the modifier
46  * `onlyOwner`, which can be applied to your functions to restrict their use to
47  * the owner.
48  */
49 abstract contract Ownable is Context {
50     address private _owner;
51 
52     event OwnershipTransferred(
53         address indexed previousOwner,
54         address indexed newOwner
55     );
56 
57     /**
58      * @dev Initializes the contract setting the deployer as the initial owner.
59      */
60     constructor() {
61         _setOwner(_msgSender());
62     }
63 
64     /**
65      * @dev Returns the address of the current owner.
66      */
67     function owner() public view virtual returns (address) {
68         return _owner;
69     }
70 
71     /**
72      * @dev Throws if called by any account other than the owner.
73      */
74     modifier onlyOwner() {
75         require(owner() == _msgSender(), "Ownable: caller is not the owner");
76         _;
77     }
78 
79     /**
80      * @dev Leaves the contract without owner. It will not be possible to call
81      * `onlyOwner` functions anymore. Can only be called by the current owner.
82      *
83      * NOTE: Renouncing ownership will leave the contract without an owner,
84      * thereby removing any functionality that is only available to the owner.
85      */
86     function renounceOwnership() public virtual onlyOwner {
87         _setOwner(address(0));
88     }
89 
90     /**
91      * @dev Transfers ownership of the contract to a new account (`newOwner`).
92      * Can only be called by the current owner.
93      */
94     function transferOwnership(address newOwner) public virtual onlyOwner {
95         require(
96             newOwner != address(0),
97             "Ownable: new owner is the zero address"
98         );
99         _setOwner(newOwner);
100     }
101 
102     function _setOwner(address newOwner) private {
103         address oldOwner = _owner;
104         _owner = newOwner;
105         emit OwnershipTransferred(oldOwner, newOwner);
106     }
107 }
108 
109 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.3.0
110 
111 pragma solidity ^0.8.0;
112 
113 // CAUTION
114 // This version of SafeMath should only be used with Solidity 0.8 or later,
115 // because it relies on the compiler's built in overflow checks.
116 
117 /**
118  * @dev Wrappers over Solidity's arithmetic operations.
119  *
120  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
121  * now has built in overflow checking.
122  */
123 library SafeMath {
124     /**
125      * @dev Returns the addition of two unsigned integers, with an overflow flag.
126      *
127      * _Available since v3.4._
128      */
129     function tryAdd(uint256 a, uint256 b)
130         internal
131         pure
132         returns (bool, uint256)
133     {
134         unchecked {
135             uint256 c = a + b;
136             if (c < a) return (false, 0);
137             return (true, c);
138         }
139     }
140 
141     /**
142      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
143      *
144      * _Available since v3.4._
145      */
146     function trySub(uint256 a, uint256 b)
147         internal
148         pure
149         returns (bool, uint256)
150     {
151         unchecked {
152             if (b > a) return (false, 0);
153             return (true, a - b);
154         }
155     }
156 
157     /**
158      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
159      *
160      * _Available since v3.4._
161      */
162     function tryMul(uint256 a, uint256 b)
163         internal
164         pure
165         returns (bool, uint256)
166     {
167         unchecked {
168             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
169             // benefit is lost if 'b' is also tested.
170             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
171             if (a == 0) return (true, 0);
172             uint256 c = a * b;
173             if (c / a != b) return (false, 0);
174             return (true, c);
175         }
176     }
177 
178     /**
179      * @dev Returns the division of two unsigned integers, with a division by zero flag.
180      *
181      * _Available since v3.4._
182      */
183     function tryDiv(uint256 a, uint256 b)
184         internal
185         pure
186         returns (bool, uint256)
187     {
188         unchecked {
189             if (b == 0) return (false, 0);
190             return (true, a / b);
191         }
192     }
193 
194     /**
195      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
196      *
197      * _Available since v3.4._
198      */
199     function tryMod(uint256 a, uint256 b)
200         internal
201         pure
202         returns (bool, uint256)
203     {
204         unchecked {
205             if (b == 0) return (false, 0);
206             return (true, a % b);
207         }
208     }
209 
210     /**
211      * @dev Returns the addition of two unsigned integers, reverting on
212      * overflow.
213      *
214      * Counterpart to Solidity's `+` operator.
215      *
216      * Requirements:
217      *
218      * - Addition cannot overflow.
219      */
220     function add(uint256 a, uint256 b) internal pure returns (uint256) {
221         return a + b;
222     }
223 
224     /**
225      * @dev Returns the subtraction of two unsigned integers, reverting on
226      * overflow (when the result is negative).
227      *
228      * Counterpart to Solidity's `-` operator.
229      *
230      * Requirements:
231      *
232      * - Subtraction cannot overflow.
233      */
234     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
235         return a - b;
236     }
237 
238     /**
239      * @dev Returns the multiplication of two unsigned integers, reverting on
240      * overflow.
241      *
242      * Counterpart to Solidity's `*` operator.
243      *
244      * Requirements:
245      *
246      * - Multiplication cannot overflow.
247      */
248     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
249         return a * b;
250     }
251 
252     /**
253      * @dev Returns the integer division of two unsigned integers, reverting on
254      * division by zero. The result is rounded towards zero.
255      *
256      * Counterpart to Solidity's `/` operator.
257      *
258      * Requirements:
259      *
260      * - The divisor cannot be zero.
261      */
262     function div(uint256 a, uint256 b) internal pure returns (uint256) {
263         return a / b;
264     }
265 
266     /**
267      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
268      * reverting when dividing by zero.
269      *
270      * Counterpart to Solidity's `%` operator. This function uses a `revert`
271      * opcode (which leaves remaining gas untouched) while Solidity uses an
272      * invalid opcode to revert (consuming all remaining gas).
273      *
274      * Requirements:
275      *
276      * - The divisor cannot be zero.
277      */
278     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
279         return a % b;
280     }
281 
282     /**
283      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
284      * overflow (when the result is negative).
285      *
286      * CAUTION: This function is deprecated because it requires allocating memory for the error
287      * message unnecessarily. For custom revert reasons use {trySub}.
288      *
289      * Counterpart to Solidity's `-` operator.
290      *
291      * Requirements:
292      *
293      * - Subtraction cannot overflow.
294      */
295     function sub(
296         uint256 a,
297         uint256 b,
298         string memory errorMessage
299     ) internal pure returns (uint256) {
300         unchecked {
301             require(b <= a, errorMessage);
302             return a - b;
303         }
304     }
305 
306     /**
307      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
308      * division by zero. The result is rounded towards zero.
309      *
310      * Counterpart to Solidity's `/` operator. Note: this function uses a
311      * `revert` opcode (which leaves remaining gas untouched) while Solidity
312      * uses an invalid opcode to revert (consuming all remaining gas).
313      *
314      * Requirements:
315      *
316      * - The divisor cannot be zero.
317      */
318     function div(
319         uint256 a,
320         uint256 b,
321         string memory errorMessage
322     ) internal pure returns (uint256) {
323         unchecked {
324             require(b > 0, errorMessage);
325             return a / b;
326         }
327     }
328 
329     /**
330      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
331      * reverting with custom message when dividing by zero.
332      *
333      * CAUTION: This function is deprecated because it requires allocating memory for the error
334      * message unnecessarily. For custom revert reasons use {tryMod}.
335      *
336      * Counterpart to Solidity's `%` operator. This function uses a `revert`
337      * opcode (which leaves remaining gas untouched) while Solidity uses an
338      * invalid opcode to revert (consuming all remaining gas).
339      *
340      * Requirements:
341      *
342      * - The divisor cannot be zero.
343      */
344     function mod(
345         uint256 a,
346         uint256 b,
347         string memory errorMessage
348     ) internal pure returns (uint256) {
349         unchecked {
350             require(b > 0, errorMessage);
351             return a % b;
352         }
353     }
354 }
355 
356 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.0
357 
358 pragma solidity ^0.8.0;
359 
360 /**
361  * @dev Interface of the ERC165 standard, as defined in the
362  * https://eips.ethereum.org/EIPS/eip-165[EIP].
363  *
364  * Implementers can declare support of contract interfaces, which can then be
365  * queried by others ({ERC165Checker}).
366  *
367  * For an implementation, see {ERC165}.
368  */
369 interface IERC165 {
370     /**
371      * @dev Returns true if this contract implements the interface defined by
372      * `interfaceId`. See the corresponding
373      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
374      * to learn more about how these ids are created.
375      *
376      * This function call must use less than 30 000 gas.
377      */
378     function supportsInterface(bytes4 interfaceId) external view returns (bool);
379 }
380 
381 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.0
382 
383 pragma solidity ^0.8.0;
384 
385 /**
386  * @dev Required interface of an ERC721 compliant contract.
387  */
388 interface IERC721 is IERC165 {
389     /**
390      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
391      */
392     event Transfer(
393         address indexed from,
394         address indexed to,
395         uint256 indexed tokenId
396     );
397 
398     /**
399      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
400      */
401     event Approval(
402         address indexed owner,
403         address indexed approved,
404         uint256 indexed tokenId
405     );
406 
407     /**
408      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
409      */
410     event ApprovalForAll(
411         address indexed owner,
412         address indexed operator,
413         bool approved
414     );
415 
416     /**
417      * @dev Returns the number of tokens in ``owner``'s account.
418      */
419     function balanceOf(address owner) external view returns (uint256 balance);
420 
421     /**
422      * @dev Returns the owner of the `tokenId` token.
423      *
424      * Requirements:
425      *
426      * - `tokenId` must exist.
427      */
428     function ownerOf(uint256 tokenId) external view returns (address owner);
429 
430     /**
431      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
432      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
433      *
434      * Requirements:
435      *
436      * - `from` cannot be the zero address.
437      * - `to` cannot be the zero address.
438      * - `tokenId` token must exist and be owned by `from`.
439      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
440      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
441      *
442      * Emits a {Transfer} event.
443      */
444     function safeTransferFrom(
445         address from,
446         address to,
447         uint256 tokenId
448     ) external;
449 
450     /**
451      * @dev Transfers `tokenId` token from `from` to `to`.
452      *
453      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
454      *
455      * Requirements:
456      *
457      * - `from` cannot be the zero address.
458      * - `to` cannot be the zero address.
459      * - `tokenId` token must be owned by `from`.
460      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
461      *
462      * Emits a {Transfer} event.
463      */
464     function transferFrom(
465         address from,
466         address to,
467         uint256 tokenId
468     ) external;
469 
470     /**
471      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
472      * The approval is cleared when the token is transferred.
473      *
474      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
475      *
476      * Requirements:
477      *
478      * - The caller must own the token or be an approved operator.
479      * - `tokenId` must exist.
480      *
481      * Emits an {Approval} event.
482      */
483     function approve(address to, uint256 tokenId) external;
484 
485     /**
486      * @dev Returns the account approved for `tokenId` token.
487      *
488      * Requirements:
489      *
490      * - `tokenId` must exist.
491      */
492     function getApproved(uint256 tokenId)
493         external
494         view
495         returns (address operator);
496 
497     /**
498      * @dev Approve or remove `operator` as an operator for the caller.
499      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
500      *
501      * Requirements:
502      *
503      * - The `operator` cannot be the caller.
504      *
505      * Emits an {ApprovalForAll} event.
506      */
507     function setApprovalForAll(address operator, bool _approved) external;
508 
509     /**
510      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
511      *
512      * See {setApprovalForAll}
513      */
514     function isApprovedForAll(address owner, address operator)
515         external
516         view
517         returns (bool);
518 
519     /**
520      * @dev Safely transfers `tokenId` token from `from` to `to`.
521      *
522      * Requirements:
523      *
524      * - `from` cannot be the zero address.
525      * - `to` cannot be the zero address.
526      * - `tokenId` token must exist and be owned by `from`.
527      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
528      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
529      *
530      * Emits a {Transfer} event.
531      */
532     function safeTransferFrom(
533         address from,
534         address to,
535         uint256 tokenId,
536         bytes calldata data
537     ) external;
538 }
539 
540 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.0
541 
542 pragma solidity ^0.8.0;
543 
544 /**
545  * @title ERC721 token receiver interface
546  * @dev Interface for any contract that wants to support safeTransfers
547  * from ERC721 asset contracts.
548  */
549 interface IERC721Receiver {
550     /**
551      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
552      * by `operator` from `from`, this function is called.
553      *
554      * It must return its Solidity selector to confirm the token transfer.
555      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
556      *
557      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
558      */
559     function onERC721Received(
560         address operator,
561         address from,
562         uint256 tokenId,
563         bytes calldata data
564     ) external returns (bytes4);
565 }
566 
567 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.0
568 
569 pragma solidity ^0.8.0;
570 
571 /**
572  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
573  * @dev See https://eips.ethereum.org/EIPS/eip-721
574  */
575 interface IERC721Metadata is IERC721 {
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
592 // File @openzeppelin/contracts/utils/Address.sol@v4.3.0
593 
594 pragma solidity ^0.8.0;
595 
596 /**
597  * @dev Collection of functions related to the address type
598  */
599 library Address {
600     /**
601      * @dev Returns true if `account` is a contract.
602      *
603      * [IMPORTANT]
604      * ====
605      * It is unsafe to assume that an address for which this function returns
606      * false is an externally-owned account (EOA) and not a contract.
607      *
608      * Among others, `isContract` will return false for the following
609      * types of addresses:
610      *
611      *  - an externally-owned account
612      *  - a contract in construction
613      *  - an address where a contract will be created
614      *  - an address where a contract lived, but was destroyed
615      * ====
616      */
617     function isContract(address account) internal view returns (bool) {
618         // This method relies on extcodesize, which returns 0 for contracts in
619         // construction, since the code is only stored at the end of the
620         // constructor execution.
621 
622         uint256 size;
623         assembly {
624             size := extcodesize(account)
625         }
626         return size > 0;
627     }
628 
629     /**
630      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
631      * `recipient`, forwarding all available gas and reverting on errors.
632      *
633      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
634      * of certain opcodes, possibly making contracts go over the 2300 gas limit
635      * imposed by `transfer`, making them unable to receive funds via
636      * `transfer`. {sendValue} removes this limitation.
637      *
638      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
639      *
640      * IMPORTANT: because control is transferred to `recipient`, care must be
641      * taken to not create reentrancy vulnerabilities. Consider using
642      * {ReentrancyGuard} or the
643      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
644      */
645     function sendValue(address payable recipient, uint256 amount) internal {
646         require(
647             address(this).balance >= amount,
648             "Address: insufficient balance"
649         );
650 
651         (bool success, ) = recipient.call{value: amount}("");
652         require(
653             success,
654             "Address: unable to send value, recipient may have reverted"
655         );
656     }
657 
658     /**
659      * @dev Performs a Solidity function call using a low level `call`. A
660      * plain `call` is an unsafe replacement for a function call: use this
661      * function instead.
662      *
663      * If `target` reverts with a revert reason, it is bubbled up by this
664      * function (like regular Solidity function calls).
665      *
666      * Returns the raw returned data. To convert to the expected return value,
667      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
668      *
669      * Requirements:
670      *
671      * - `target` must be a contract.
672      * - calling `target` with `data` must not revert.
673      *
674      * _Available since v3.1._
675      */
676     function functionCall(address target, bytes memory data)
677         internal
678         returns (bytes memory)
679     {
680         return functionCall(target, data, "Address: low-level call failed");
681     }
682 
683     /**
684      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
685      * `errorMessage` as a fallback revert reason when `target` reverts.
686      *
687      * _Available since v3.1._
688      */
689     function functionCall(
690         address target,
691         bytes memory data,
692         string memory errorMessage
693     ) internal returns (bytes memory) {
694         return functionCallWithValue(target, data, 0, errorMessage);
695     }
696 
697     /**
698      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
699      * but also transferring `value` wei to `target`.
700      *
701      * Requirements:
702      *
703      * - the calling contract must have an ETH balance of at least `value`.
704      * - the called Solidity function must be `payable`.
705      *
706      * _Available since v3.1._
707      */
708     function functionCallWithValue(
709         address target,
710         bytes memory data,
711         uint256 value
712     ) internal returns (bytes memory) {
713         return
714             functionCallWithValue(
715                 target,
716                 data,
717                 value,
718                 "Address: low-level call with value failed"
719             );
720     }
721 
722     /**
723      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
724      * with `errorMessage` as a fallback revert reason when `target` reverts.
725      *
726      * _Available since v3.1._
727      */
728     function functionCallWithValue(
729         address target,
730         bytes memory data,
731         uint256 value,
732         string memory errorMessage
733     ) internal returns (bytes memory) {
734         require(
735             address(this).balance >= value,
736             "Address: insufficient balance for call"
737         );
738         require(isContract(target), "Address: call to non-contract");
739 
740         (bool success, bytes memory returndata) = target.call{value: value}(
741             data
742         );
743         return verifyCallResult(success, returndata, errorMessage);
744     }
745 
746     /**
747      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
748      * but performing a static call.
749      *
750      * _Available since v3.3._
751      */
752     function functionStaticCall(address target, bytes memory data)
753         internal
754         view
755         returns (bytes memory)
756     {
757         return
758             functionStaticCall(
759                 target,
760                 data,
761                 "Address: low-level static call failed"
762             );
763     }
764 
765     /**
766      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
767      * but performing a static call.
768      *
769      * _Available since v3.3._
770      */
771     function functionStaticCall(
772         address target,
773         bytes memory data,
774         string memory errorMessage
775     ) internal view returns (bytes memory) {
776         require(isContract(target), "Address: static call to non-contract");
777 
778         (bool success, bytes memory returndata) = target.staticcall(data);
779         return verifyCallResult(success, returndata, errorMessage);
780     }
781 
782     /**
783      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
784      * but performing a delegate call.
785      *
786      * _Available since v3.4._
787      */
788     function functionDelegateCall(address target, bytes memory data)
789         internal
790         returns (bytes memory)
791     {
792         return
793             functionDelegateCall(
794                 target,
795                 data,
796                 "Address: low-level delegate call failed"
797             );
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
814         return verifyCallResult(success, returndata, errorMessage);
815     }
816 
817     /**
818      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
819      * revert reason using the provided one.
820      *
821      * _Available since v4.3._
822      */
823     function verifyCallResult(
824         bool success,
825         bytes memory returndata,
826         string memory errorMessage
827     ) internal pure returns (bytes memory) {
828         if (success) {
829             return returndata;
830         } else {
831             // Look for revert reason and bubble it up if present
832             if (returndata.length > 0) {
833                 // The easiest way to bubble the revert reason is using memory via assembly
834 
835                 assembly {
836                     let returndata_size := mload(returndata)
837                     revert(add(32, returndata), returndata_size)
838                 }
839             } else {
840                 revert(errorMessage);
841             }
842         }
843     }
844 }
845 
846 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.0
847 
848 pragma solidity ^0.8.0;
849 
850 /**
851  * @dev String operations.
852  */
853 library Strings {
854     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
855 
856     /**
857      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
858      */
859     function toString(uint256 value) internal pure returns (string memory) {
860         // Inspired by OraclizeAPI's implementation - MIT licence
861         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
862 
863         if (value == 0) {
864             return "0";
865         }
866         uint256 temp = value;
867         uint256 digits;
868         while (temp != 0) {
869             digits++;
870             temp /= 10;
871         }
872         bytes memory buffer = new bytes(digits);
873         while (value != 0) {
874             digits -= 1;
875             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
876             value /= 10;
877         }
878         return string(buffer);
879     }
880 
881     /**
882      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
883      */
884     function toHexString(uint256 value) internal pure returns (string memory) {
885         if (value == 0) {
886             return "0x00";
887         }
888         uint256 temp = value;
889         uint256 length = 0;
890         while (temp != 0) {
891             length++;
892             temp >>= 8;
893         }
894         return toHexString(value, length);
895     }
896 
897     /**
898      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
899      */
900     function toHexString(uint256 value, uint256 length)
901         internal
902         pure
903         returns (string memory)
904     {
905         bytes memory buffer = new bytes(2 * length + 2);
906         buffer[0] = "0";
907         buffer[1] = "x";
908         for (uint256 i = 2 * length + 1; i > 1; --i) {
909             buffer[i] = _HEX_SYMBOLS[value & 0xf];
910             value >>= 4;
911         }
912         require(value == 0, "Strings: hex length insufficient");
913         return string(buffer);
914     }
915 }
916 
917 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.0
918 
919 pragma solidity ^0.8.0;
920 
921 /**
922  * @dev Implementation of the {IERC165} interface.
923  *
924  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
925  * for the additional interface id that will be supported. For example:
926  *
927  * ```solidity
928  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
929  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
930  * }
931  * ```
932  *
933  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
934  */
935 abstract contract ERC165 is IERC165 {
936     /**
937      * @dev See {IERC165-supportsInterface}.
938      */
939     function supportsInterface(bytes4 interfaceId)
940         public
941         view
942         virtual
943         override
944         returns (bool)
945     {
946         return interfaceId == type(IERC165).interfaceId;
947     }
948 }
949 
950 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.0
951 
952 pragma solidity ^0.8.0;
953 
954 /**
955  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
956  * the Metadata extension, but not including the Enumerable extension, which is available separately as
957  * {ERC721Enumerable}.
958  */
959 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
960     using Address for address;
961     using Strings for uint256;
962 
963     // Token name
964     string private _name;
965 
966     // Token symbol
967     string private _symbol;
968 
969     // Mapping from token ID to owner address
970     mapping(uint256 => address) private _owners;
971 
972     // Mapping owner address to token count
973     mapping(address => uint256) private _balances;
974 
975     // Mapping from token ID to approved address
976     mapping(uint256 => address) private _tokenApprovals;
977 
978     // Mapping from owner to operator approvals
979     mapping(address => mapping(address => bool)) private _operatorApprovals;
980 
981     /**
982      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
983      */
984     constructor(string memory name_, string memory symbol_) {
985         _name = name_;
986         _symbol = symbol_;
987     }
988 
989     /**
990      * @dev See {IERC165-supportsInterface}.
991      */
992     function supportsInterface(bytes4 interfaceId)
993         public
994         view
995         virtual
996         override(ERC165, IERC165)
997         returns (bool)
998     {
999         return
1000             interfaceId == type(IERC721).interfaceId ||
1001             interfaceId == type(IERC721Metadata).interfaceId ||
1002             super.supportsInterface(interfaceId);
1003     }
1004 
1005     /**
1006      * @dev See {IERC721-balanceOf}.
1007      */
1008     function balanceOf(address owner)
1009         public
1010         view
1011         virtual
1012         override
1013         returns (uint256)
1014     {
1015         require(
1016             owner != address(0),
1017             "ERC721: balance query for the zero address"
1018         );
1019         return _balances[owner];
1020     }
1021 
1022     /**
1023      * @dev See {IERC721-ownerOf}.
1024      */
1025     function ownerOf(uint256 tokenId)
1026         public
1027         view
1028         virtual
1029         override
1030         returns (address)
1031     {
1032         address owner = _owners[tokenId];
1033         require(
1034             owner != address(0),
1035             "ERC721: owner query for nonexistent token"
1036         );
1037         return owner;
1038     }
1039 
1040     /**
1041      * @dev See {IERC721Metadata-name}.
1042      */
1043     function name() public view virtual override returns (string memory) {
1044         return _name;
1045     }
1046 
1047     /**
1048      * @dev See {IERC721Metadata-symbol}.
1049      */
1050     function symbol() public view virtual override returns (string memory) {
1051         return _symbol;
1052     }
1053 
1054     /**
1055      * @dev See {IERC721Metadata-tokenURI}.
1056      */
1057     function tokenURI(uint256 tokenId)
1058         public
1059         view
1060         virtual
1061         override
1062         returns (string memory)
1063     {
1064         require(
1065             _exists(tokenId),
1066             "ERC721Metadata: URI query for nonexistent token"
1067         );
1068 
1069         string memory baseURI = _baseURI();
1070         return
1071             bytes(baseURI).length > 0
1072                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1073                 : "";
1074     }
1075 
1076     /**
1077      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1078      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1079      * by default, can be overriden in child contracts.
1080      */
1081     function _baseURI() internal view virtual returns (string memory) {
1082         return "";
1083     }
1084 
1085     /**
1086      * @dev See {IERC721-approve}.
1087      */
1088     function approve(address to, uint256 tokenId) public virtual override {
1089         address owner = ERC721.ownerOf(tokenId);
1090         require(to != owner, "ERC721: approval to current owner");
1091 
1092         require(
1093             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1094             "ERC721: approve caller is not owner nor approved for all"
1095         );
1096 
1097         _approve(to, tokenId);
1098     }
1099 
1100     /**
1101      * @dev See {IERC721-getApproved}.
1102      */
1103     function getApproved(uint256 tokenId)
1104         public
1105         view
1106         virtual
1107         override
1108         returns (address)
1109     {
1110         require(
1111             _exists(tokenId),
1112             "ERC721: approved query for nonexistent token"
1113         );
1114 
1115         return _tokenApprovals[tokenId];
1116     }
1117 
1118     /**
1119      * @dev See {IERC721-setApprovalForAll}.
1120      */
1121     function setApprovalForAll(address operator, bool approved)
1122         public
1123         virtual
1124         override
1125     {
1126         require(operator != _msgSender(), "ERC721: approve to caller");
1127 
1128         _operatorApprovals[_msgSender()][operator] = approved;
1129         emit ApprovalForAll(_msgSender(), operator, approved);
1130     }
1131 
1132     /**
1133      * @dev See {IERC721-isApprovedForAll}.
1134      */
1135     function isApprovedForAll(address owner, address operator)
1136         public
1137         view
1138         virtual
1139         override
1140         returns (bool)
1141     {
1142         return _operatorApprovals[owner][operator];
1143     }
1144 
1145     /**
1146      * @dev See {IERC721-transferFrom}.
1147      */
1148     function transferFrom(
1149         address from,
1150         address to,
1151         uint256 tokenId
1152     ) public virtual override {
1153         //solhint-disable-next-line max-line-length
1154         require(
1155             _isApprovedOrOwner(_msgSender(), tokenId),
1156             "ERC721: transfer caller is not owner nor approved"
1157         );
1158 
1159         _transfer(from, to, tokenId);
1160     }
1161 
1162     /**
1163      * @dev See {IERC721-safeTransferFrom}.
1164      */
1165     function safeTransferFrom(
1166         address from,
1167         address to,
1168         uint256 tokenId
1169     ) public virtual override {
1170         safeTransferFrom(from, to, tokenId, "");
1171     }
1172 
1173     /**
1174      * @dev See {IERC721-safeTransferFrom}.
1175      */
1176     function safeTransferFrom(
1177         address from,
1178         address to,
1179         uint256 tokenId,
1180         bytes memory _data
1181     ) public virtual override {
1182         require(
1183             _isApprovedOrOwner(_msgSender(), tokenId),
1184             "ERC721: transfer caller is not owner nor approved"
1185         );
1186         _safeTransfer(from, to, tokenId, _data);
1187     }
1188 
1189     /**
1190      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1191      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1192      *
1193      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1194      *
1195      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1196      * implement alternative mechanisms to perform token transfer, such as signature-based.
1197      *
1198      * Requirements:
1199      *
1200      * - `from` cannot be the zero address.
1201      * - `to` cannot be the zero address.
1202      * - `tokenId` token must exist and be owned by `from`.
1203      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1204      *
1205      * Emits a {Transfer} event.
1206      */
1207     function _safeTransfer(
1208         address from,
1209         address to,
1210         uint256 tokenId,
1211         bytes memory _data
1212     ) internal virtual {
1213         _transfer(from, to, tokenId);
1214         require(
1215             _checkOnERC721Received(from, to, tokenId, _data),
1216             "ERC721: transfer to non ERC721Receiver implementer"
1217         );
1218     }
1219 
1220     /**
1221      * @dev Returns whether `tokenId` exists.
1222      *
1223      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1224      *
1225      * Tokens start existing when they are minted (`_mint`),
1226      * and stop existing when they are burned (`_burn`).
1227      */
1228     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1229         return _owners[tokenId] != address(0);
1230     }
1231 
1232     /**
1233      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1234      *
1235      * Requirements:
1236      *
1237      * - `tokenId` must exist.
1238      */
1239     function _isApprovedOrOwner(address spender, uint256 tokenId)
1240         internal
1241         view
1242         virtual
1243         returns (bool)
1244     {
1245         require(
1246             _exists(tokenId),
1247             "ERC721: operator query for nonexistent token"
1248         );
1249         address owner = ERC721.ownerOf(tokenId);
1250         return (spender == owner ||
1251             getApproved(tokenId) == spender ||
1252             isApprovedForAll(owner, spender));
1253     }
1254 
1255     /**
1256      * @dev Safely mints `tokenId` and transfers it to `to`.
1257      *
1258      * Requirements:
1259      *
1260      * - `tokenId` must not exist.
1261      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1262      *
1263      * Emits a {Transfer} event.
1264      */
1265     function _safeMint(address to, uint256 tokenId) internal virtual {
1266         _safeMint(to, tokenId, "");
1267     }
1268 
1269     /**
1270      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1271      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1272      */
1273     function _safeMint(
1274         address to,
1275         uint256 tokenId,
1276         bytes memory _data
1277     ) internal virtual {
1278         _mint(to, tokenId);
1279         require(
1280             _checkOnERC721Received(address(0), to, tokenId, _data),
1281             "ERC721: transfer to non ERC721Receiver implementer"
1282         );
1283     }
1284 
1285     /**
1286      * @dev Mints `tokenId` and transfers it to `to`.
1287      *
1288      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1289      *
1290      * Requirements:
1291      *
1292      * - `tokenId` must not exist.
1293      * - `to` cannot be the zero address.
1294      *
1295      * Emits a {Transfer} event.
1296      */
1297     function _mint(address to, uint256 tokenId) internal virtual {
1298         require(to != address(0), "ERC721: mint to the zero address");
1299         require(!_exists(tokenId), "ERC721: token already minted");
1300 
1301         _beforeTokenTransfer(address(0), to, tokenId);
1302 
1303         _balances[to] += 1;
1304         _owners[tokenId] = to;
1305 
1306         emit Transfer(address(0), to, tokenId);
1307     }
1308 
1309     /**
1310      * @dev Destroys `tokenId`.
1311      * The approval is cleared when the token is burned.
1312      *
1313      * Requirements:
1314      *
1315      * - `tokenId` must exist.
1316      *
1317      * Emits a {Transfer} event.
1318      */
1319     function _burn(uint256 tokenId) internal virtual {
1320         address owner = ERC721.ownerOf(tokenId);
1321 
1322         _beforeTokenTransfer(owner, address(0), tokenId);
1323 
1324         // Clear approvals
1325         _approve(address(0), tokenId);
1326 
1327         _balances[owner] -= 1;
1328         delete _owners[tokenId];
1329 
1330         emit Transfer(owner, address(0), tokenId);
1331     }
1332 
1333     /**
1334      * @dev Transfers `tokenId` from `from` to `to`.
1335      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1336      *
1337      * Requirements:
1338      *
1339      * - `to` cannot be the zero address.
1340      * - `tokenId` token must be owned by `from`.
1341      *
1342      * Emits a {Transfer} event.
1343      */
1344     function _transfer(
1345         address from,
1346         address to,
1347         uint256 tokenId
1348     ) internal virtual {
1349         require(
1350             ERC721.ownerOf(tokenId) == from,
1351             "ERC721: transfer of token that is not own"
1352         );
1353         require(to != address(0), "ERC721: transfer to the zero address");
1354 
1355         _beforeTokenTransfer(from, to, tokenId);
1356 
1357         // Clear approvals from the previous owner
1358         _approve(address(0), tokenId);
1359 
1360         _balances[from] -= 1;
1361         _balances[to] += 1;
1362         _owners[tokenId] = to;
1363 
1364         emit Transfer(from, to, tokenId);
1365     }
1366 
1367     /**
1368      * @dev Approve `to` to operate on `tokenId`
1369      *
1370      * Emits a {Approval} event.
1371      */
1372     function _approve(address to, uint256 tokenId) internal virtual {
1373         _tokenApprovals[tokenId] = to;
1374         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1375     }
1376 
1377     /**
1378      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1379      * The call is not executed if the target address is not a contract.
1380      *
1381      * @param from address representing the previous owner of the given token ID
1382      * @param to target address that will receive the tokens
1383      * @param tokenId uint256 ID of the token to be transferred
1384      * @param _data bytes optional data to send along with the call
1385      * @return bool whether the call correctly returned the expected magic value
1386      */
1387     function _checkOnERC721Received(
1388         address from,
1389         address to,
1390         uint256 tokenId,
1391         bytes memory _data
1392     ) private returns (bool) {
1393         if (to.isContract()) {
1394             try
1395                 IERC721Receiver(to).onERC721Received(
1396                     _msgSender(),
1397                     from,
1398                     tokenId,
1399                     _data
1400                 )
1401             returns (bytes4 retval) {
1402                 return retval == IERC721Receiver.onERC721Received.selector;
1403             } catch (bytes memory reason) {
1404                 if (reason.length == 0) {
1405                     revert(
1406                         "ERC721: transfer to non ERC721Receiver implementer"
1407                     );
1408                 } else {
1409                     assembly {
1410                         revert(add(32, reason), mload(reason))
1411                     }
1412                 }
1413             }
1414         } else {
1415             return true;
1416         }
1417     }
1418 
1419     /**
1420      * @dev Hook that is called before any token transfer. This includes minting
1421      * and burning.
1422      *
1423      * Calling conditions:
1424      *
1425      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1426      * transferred to `to`.
1427      * - When `from` is zero, `tokenId` will be minted for `to`.
1428      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1429      * - `from` and `to` are never both zero.
1430      *
1431      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1432      */
1433     function _beforeTokenTransfer(
1434         address from,
1435         address to,
1436         uint256 tokenId
1437     ) internal virtual {}
1438 }
1439 
1440 // File @openzeppelin/contracts/security/Pausable.sol@v4.3.0
1441 
1442 pragma solidity ^0.8.0;
1443 
1444 /**
1445  * @dev Contract module which allows children to implement an emergency stop
1446  * mechanism that can be triggered by an authorized account.
1447  *
1448  * This module is used through inheritance. It will make available the
1449  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1450  * the functions of your contract. Note that they will not be pausable by
1451  * simply including this module, only once the modifiers are put in place.
1452  */
1453 abstract contract Pausable is Context {
1454     /**
1455      * @dev Emitted when the pause is triggered by `account`.
1456      */
1457     event Paused(address account);
1458 
1459     /**
1460      * @dev Emitted when the pause is lifted by `account`.
1461      */
1462     event Unpaused(address account);
1463 
1464     bool private _paused;
1465 
1466     /**
1467      * @dev Initializes the contract in unpaused state.
1468      */
1469     constructor() {
1470         _paused = false;
1471     }
1472 
1473     /**
1474      * @dev Returns true if the contract is paused, and false otherwise.
1475      */
1476     function paused() public view virtual returns (bool) {
1477         return _paused;
1478     }
1479 
1480     /**
1481      * @dev Modifier to make a function callable only when the contract is not paused.
1482      *
1483      * Requirements:
1484      *
1485      * - The contract must not be paused.
1486      */
1487     modifier whenNotPaused() {
1488         require(!paused(), "Pausable: paused");
1489         _;
1490     }
1491 
1492     /**
1493      * @dev Modifier to make a function callable only when the contract is paused.
1494      *
1495      * Requirements:
1496      *
1497      * - The contract must be paused.
1498      */
1499     modifier whenPaused() {
1500         require(paused(), "Pausable: not paused");
1501         _;
1502     }
1503 
1504     /**
1505      * @dev Triggers stopped state.
1506      *
1507      * Requirements:
1508      *
1509      * - The contract must not be paused.
1510      */
1511     function _pause() internal virtual whenNotPaused {
1512         _paused = true;
1513         emit Paused(_msgSender());
1514     }
1515 
1516     /**
1517      * @dev Returns to normal state.
1518      *
1519      * Requirements:
1520      *
1521      * - The contract must be paused.
1522      */
1523     function _unpause() internal virtual whenPaused {
1524         _paused = false;
1525         emit Unpaused(_msgSender());
1526     }
1527 }
1528 
1529 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol@v4.3.0
1530 
1531 pragma solidity ^0.8.0;
1532 
1533 /**
1534  * @dev ERC721 token with pausable token transfers, minting and burning.
1535  *
1536  * Useful for scenarios such as preventing trades until the end of an evaluation
1537  * period, or having an emergency switch for freezing all token transfers in the
1538  * event of a large bug.
1539  */
1540 abstract contract ERC721Pausable is ERC721, Pausable {
1541     /**
1542      * @dev See {ERC721-_beforeTokenTransfer}.
1543      *
1544      * Requirements:
1545      *
1546      * - the contract must not be paused.
1547      */
1548     function _beforeTokenTransfer(
1549         address from,
1550         address to,
1551         uint256 tokenId
1552     ) internal virtual override {
1553         super._beforeTokenTransfer(from, to, tokenId);
1554 
1555         require(!paused(), "ERC721Pausable: token transfer while paused");
1556     }
1557 }
1558 
1559 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.0
1560 
1561 pragma solidity ^0.8.0;
1562 
1563 /**
1564  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1565  * @dev See https://eips.ethereum.org/EIPS/eip-721
1566  */
1567 interface IERC721Enumerable is IERC721 {
1568     /**
1569      * @dev Returns the total amount of tokens stored by the contract.
1570      */
1571     function totalSupply() external view returns (uint256);
1572 
1573     /**
1574      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1575      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1576      */
1577     function tokenOfOwnerByIndex(address owner, uint256 index)
1578         external
1579         view
1580         returns (uint256 tokenId);
1581 
1582     /**
1583      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1584      * Use along with {totalSupply} to enumerate all tokens.
1585      */
1586     function tokenByIndex(uint256 index) external view returns (uint256);
1587 }
1588 
1589 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.0
1590 
1591 pragma solidity ^0.8.0;
1592 
1593 /**
1594  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1595  * enumerability of all the token ids in the contract as well as all token ids owned by each
1596  * account.
1597  */
1598 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1599     // Mapping from owner to list of owned token IDs
1600     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1601 
1602     // Mapping from token ID to index of the owner tokens list
1603     mapping(uint256 => uint256) private _ownedTokensIndex;
1604 
1605     // Array with all token ids, used for enumeration
1606     uint256[] private _allTokens;
1607 
1608     // Mapping from token id to position in the allTokens array
1609     mapping(uint256 => uint256) private _allTokensIndex;
1610 
1611     /**
1612      * @dev See {IERC165-supportsInterface}.
1613      */
1614     function supportsInterface(bytes4 interfaceId)
1615         public
1616         view
1617         virtual
1618         override(IERC165, ERC721)
1619         returns (bool)
1620     {
1621         return
1622             interfaceId == type(IERC721Enumerable).interfaceId ||
1623             super.supportsInterface(interfaceId);
1624     }
1625 
1626     /**
1627      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1628      */
1629     function tokenOfOwnerByIndex(address owner, uint256 index)
1630         public
1631         view
1632         virtual
1633         override
1634         returns (uint256)
1635     {
1636         require(
1637             index < ERC721.balanceOf(owner),
1638             "ERC721Enumerable: owner index out of bounds"
1639         );
1640         return _ownedTokens[owner][index];
1641     }
1642 
1643     /**
1644      * @dev See {IERC721Enumerable-totalSupply}.
1645      */
1646     function totalSupply() public view virtual override returns (uint256) {
1647         return _allTokens.length;
1648     }
1649 
1650     /**
1651      * @dev See {IERC721Enumerable-tokenByIndex}.
1652      */
1653     function tokenByIndex(uint256 index)
1654         public
1655         view
1656         virtual
1657         override
1658         returns (uint256)
1659     {
1660         require(
1661             index < ERC721Enumerable.totalSupply(),
1662             "ERC721Enumerable: global index out of bounds"
1663         );
1664         return _allTokens[index];
1665     }
1666 
1667     /**
1668      * @dev Hook that is called before any token transfer. This includes minting
1669      * and burning.
1670      *
1671      * Calling conditions:
1672      *
1673      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1674      * transferred to `to`.
1675      * - When `from` is zero, `tokenId` will be minted for `to`.
1676      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1677      * - `from` cannot be the zero address.
1678      * - `to` cannot be the zero address.
1679      *
1680      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1681      */
1682     function _beforeTokenTransfer(
1683         address from,
1684         address to,
1685         uint256 tokenId
1686     ) internal virtual override {
1687         super._beforeTokenTransfer(from, to, tokenId);
1688 
1689         if (from == address(0)) {
1690             _addTokenToAllTokensEnumeration(tokenId);
1691         } else if (from != to) {
1692             _removeTokenFromOwnerEnumeration(from, tokenId);
1693         }
1694         if (to == address(0)) {
1695             _removeTokenFromAllTokensEnumeration(tokenId);
1696         } else if (to != from) {
1697             _addTokenToOwnerEnumeration(to, tokenId);
1698         }
1699     }
1700 
1701     /**
1702      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1703      * @param to address representing the new owner of the given token ID
1704      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1705      */
1706     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1707         uint256 length = ERC721.balanceOf(to);
1708         _ownedTokens[to][length] = tokenId;
1709         _ownedTokensIndex[tokenId] = length;
1710     }
1711 
1712     /**
1713      * @dev Private function to add a token to this extension's token tracking data structures.
1714      * @param tokenId uint256 ID of the token to be added to the tokens list
1715      */
1716     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1717         _allTokensIndex[tokenId] = _allTokens.length;
1718         _allTokens.push(tokenId);
1719     }
1720 
1721     /**
1722      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1723      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1724      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1725      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1726      * @param from address representing the previous owner of the given token ID
1727      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1728      */
1729     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
1730         private
1731     {
1732         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1733         // then delete the last slot (swap and pop).
1734 
1735         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1736         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1737 
1738         // When the token to delete is the last token, the swap operation is unnecessary
1739         if (tokenIndex != lastTokenIndex) {
1740             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1741 
1742             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1743             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1744         }
1745 
1746         // This also deletes the contents at the last position of the array
1747         delete _ownedTokensIndex[tokenId];
1748         delete _ownedTokens[from][lastTokenIndex];
1749     }
1750 
1751     /**
1752      * @dev Private function to remove a token from this extension's token tracking data structures.
1753      * This has O(1) time complexity, but alters the order of the _allTokens array.
1754      * @param tokenId uint256 ID of the token to be removed from the tokens list
1755      */
1756     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1757         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1758         // then delete the last slot (swap and pop).
1759 
1760         uint256 lastTokenIndex = _allTokens.length - 1;
1761         uint256 tokenIndex = _allTokensIndex[tokenId];
1762 
1763         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1764         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1765         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1766         uint256 lastTokenId = _allTokens[lastTokenIndex];
1767 
1768         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1769         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1770 
1771         // This also deletes the contents at the last position of the array
1772         delete _allTokensIndex[tokenId];
1773         _allTokens.pop();
1774     }
1775 }
1776 
1777 // File @openzeppelin/contracts/utils/introspection/ERC165Storage.sol@v4.3.0
1778 
1779 pragma solidity ^0.8.0;
1780 
1781 /**
1782  * @dev Storage based implementation of the {IERC165} interface.
1783  *
1784  * Contracts may inherit from this and call {_registerInterface} to declare
1785  * their support of an interface.
1786  */
1787 abstract contract ERC165Storage is ERC165 {
1788     /**
1789      * @dev Mapping of interface ids to whether or not it's supported.
1790      */
1791     mapping(bytes4 => bool) private _supportedInterfaces;
1792 
1793     /**
1794      * @dev See {IERC165-supportsInterface}.
1795      */
1796     function supportsInterface(bytes4 interfaceId)
1797         public
1798         view
1799         virtual
1800         override
1801         returns (bool)
1802     {
1803         return
1804             super.supportsInterface(interfaceId) ||
1805             _supportedInterfaces[interfaceId];
1806     }
1807 
1808     /**
1809      * @dev Registers the contract as an implementer of the interface defined by
1810      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1811      * registering its interface id is not required.
1812      *
1813      * See {IERC165-supportsInterface}.
1814      *
1815      * Requirements:
1816      *
1817      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1818      */
1819     function _registerInterface(bytes4 interfaceId) internal virtual {
1820         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1821         _supportedInterfaces[interfaceId] = true;
1822     }
1823 }
1824 
1825 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.3.0
1826 
1827 pragma solidity ^0.8.0;
1828 
1829 /**
1830  * @dev Contract module that helps prevent reentrant calls to a function.
1831  *
1832  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1833  * available, which can be applied to functions to make sure there are no nested
1834  * (reentrant) calls to them.
1835  *
1836  * Note that because there is a single `nonReentrant` guard, functions marked as
1837  * `nonReentrant` may not call one another. This can be worked around by making
1838  * those functions `private`, and then adding `external` `nonReentrant` entry
1839  * points to them.
1840  *
1841  * TIP: If you would like to learn more about reentrancy and alternative ways
1842  * to protect against it, check out our blog post
1843  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1844  */
1845 abstract contract ReentrancyGuard {
1846     // Booleans are more expensive than uint256 or any type that takes up a full
1847     // word because each write operation emits an extra SLOAD to first read the
1848     // slot's contents, replace the bits taken up by the boolean, and then write
1849     // back. This is the compiler's defense against contract upgrades and
1850     // pointer aliasing, and it cannot be disabled.
1851 
1852     // The values being non-zero value makes deployment a bit more expensive,
1853     // but in exchange the refund on every call to nonReentrant will be lower in
1854     // amount. Since refunds are capped to a percentage of the total
1855     // transaction's gas, it is best to keep them low in cases like this one, to
1856     // increase the likelihood of the full refund coming into effect.
1857     uint256 private constant _NOT_ENTERED = 1;
1858     uint256 private constant _ENTERED = 2;
1859 
1860     uint256 private _status;
1861 
1862     constructor() {
1863         _status = _NOT_ENTERED;
1864     }
1865 
1866     /**
1867      * @dev Prevents a contract from calling itself, directly or indirectly.
1868      * Calling a `nonReentrant` function from another `nonReentrant`
1869      * function is not supported. It is possible to prevent this from happening
1870      * by making the `nonReentrant` function external, and make it call a
1871      * `private` function that does the actual work.
1872      */
1873     modifier nonReentrant() {
1874         // On the first call to nonReentrant, _notEntered will be true
1875         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1876 
1877         // Any calls to nonReentrant after this point will fail
1878         _status = _ENTERED;
1879 
1880         _;
1881 
1882         // By storing the original value once again, a refund is triggered (see
1883         // https://eips.ethereum.org/EIPS/eip-2200)
1884         _status = _NOT_ENTERED;
1885     }
1886 }
1887 
1888 pragma solidity ^0.8.5;
1889 pragma experimental ABIEncoderV2;
1890 
1891 contract TheOddballClub is Ownable, ERC721Enumerable, ReentrancyGuard {
1892     using SafeMath for uint256;
1893 
1894     string public ODDBALL_PROVENANCE = "";
1895     string public LICENSE_TEXT = "";
1896     string public BASE_URI = "";
1897 
1898     uint256 public constant PRICE = 0.0275 ether;
1899     uint256 public constant PURCHASE_LIMIT = 20;
1900     uint256 public constant MAX_ODDBALL = 8888;
1901     uint256 public constant PRESALE_MAX_PURCHASE_LIMIT = 5;
1902 
1903     uint256 public oddballReserve = 250;
1904     uint256 public totalPublicSupply;
1905 
1906     mapping(address => bool) private _allowList;
1907     mapping(address => uint256) private _allowListClaimed;
1908 
1909     bool public saleIsActive = false;
1910     bool public preSaleIsActive = false;
1911     bool public licenseLocked = false;
1912 
1913     address public team1Address;
1914     address public team2Address;
1915     address public team3Address;
1916     uint256 public constant TEAM_1_SELL_PERCENT = 11;
1917     uint256 public constant TEAM_2_SELL_PERCENT = 5;
1918     uint256 public constant TEAM_3_SELL_PERCENT = 3;
1919 
1920     event licenseisLocked(string _licenseText);
1921 
1922     constructor(
1923         address addr1,
1924         address addr2,
1925         address addr3
1926     ) ERC721("TheOddballClub", "OBC") {
1927         team1Address = addr1;
1928         team2Address = addr2;
1929         team3Address = addr3;
1930     }
1931 
1932     function withdraw() public onlyOwner {
1933         uint256 value = address(this).balance;
1934         sendValueTo(team1Address, (value * TEAM_1_SELL_PERCENT) / 100);
1935         sendValueTo(team2Address, (value * TEAM_2_SELL_PERCENT) / 100);
1936         sendValueTo(team3Address, (value * TEAM_3_SELL_PERCENT) / 100);
1937         sendValueTo(msg.sender, (value * 81) / 100);
1938     }
1939 
1940     /**
1941     * @dev Send value to address
1942     */
1943     function sendValueTo(address to_, uint256 value) internal {
1944         address payable to = payable(to_);
1945         (bool success, ) = to.call{value: value}("");
1946         require(success, "Transfer failed.");
1947     }
1948 
1949     /**
1950     * @dev Flip the pre / main sale flags
1951     */
1952     function flipSaleState() public onlyOwner {
1953         saleIsActive = !saleIsActive;
1954     }
1955 
1956     function flipPreSaleState() public onlyOwner {
1957         preSaleIsActive = !preSaleIsActive;
1958     }
1959 
1960     /**
1961     * @dev Return base URI
1962     */
1963     function _baseURI() internal view override returns (string memory) {
1964         return BASE_URI;
1965     }
1966 
1967     /**
1968     * @dev Set data
1969     */
1970     function setBaseURI(string memory baseURI_) public onlyOwner {
1971         BASE_URI = baseURI_;
1972     }
1973 
1974     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1975         ODDBALL_PROVENANCE = provenanceHash;
1976     }
1977 
1978     function setOddballReserve(uint256 reserveLimit) public onlyOwner {
1979         oddballReserve = reserveLimit;
1980     }
1981 
1982     function setTeamAddress(
1983         address _team1,
1984         address _team2,
1985         address _team3
1986     ) public onlyOwner {
1987         team1Address = _team1;
1988         team2Address = _team2;
1989         team3Address = _team3;
1990     }
1991 
1992     /**
1993     * @dev Add array of address's to the whitelist
1994     *
1995     * Shoutout to 0N1 contract for this code
1996     */
1997     function addToAllowList(address[] calldata addresses) external onlyOwner {
1998         for (uint256 i = 0; i < addresses.length; i++) {
1999             require(addresses[i] != address(0), "Can't add the null address");
2000             _allowList[addresses[i]] = true;
2001             _allowListClaimed[addresses[i]] > 0
2002                 ? _allowListClaimed[addresses[i]]
2003                 : 0;
2004         }
2005     }
2006 
2007     function onAllowList(address addr) external view returns (bool) {
2008         return _allowList[addr];
2009     }
2010 
2011     function removeFromAllowList(address[] calldata addresses) external onlyOwner
2012     {
2013         for (uint256 i = 0; i < addresses.length; i++) {
2014             require(addresses[i] != address(0), "Can't add the null address");
2015             _allowList[addresses[i]] = false;
2016         }
2017     }
2018 
2019     function purchase(uint256 numberOfTokens) public payable nonReentrant {
2020         require(saleIsActive, "Contract is not active");
2021         require(!preSaleIsActive, "Pre sale is active");
2022         require(totalSupply().add(numberOfTokens) <= MAX_ODDBALL, "Purchase would exceed max supply");
2023         require(numberOfTokens > 0 && numberOfTokens <= PURCHASE_LIMIT, "Would exceed PURCHASE_LIMIT");
2024         require( msg.value >= PRICE.mul(numberOfTokens),"Ether value sent is not correct");
2025         require(msg.value / numberOfTokens == PRICE, "Mint value is not good");
2026 
2027         for (uint256 i = 0; i < numberOfTokens; i++) {
2028             if (totalPublicSupply < MAX_ODDBALL) {
2029                 uint256 tokenId = totalPublicSupply;
2030                 totalPublicSupply += 1;
2031                 _safeMint(msg.sender, tokenId);
2032             }
2033         }
2034     }
2035 
2036     function purchasePreSale(uint256 numberOfTokens) public payable nonReentrant
2037     {
2038         require(!saleIsActive, "Contract is active");
2039         require(preSaleIsActive, "Pre Sale is not active");
2040         require(_allowList[msg.sender], "You are not on the Allow List");
2041         require(totalSupply().add(numberOfTokens) <= MAX_ODDBALL,"Purchase would exceed max supply");
2042         require(numberOfTokens <= PRESALE_MAX_PURCHASE_LIMIT,"Cannot purchase this many tokens");
2043         require(_allowListClaimed[msg.sender] + numberOfTokens <= PRESALE_MAX_PURCHASE_LIMIT, "Purchase exceeds max allowed");
2044         require( PRICE * numberOfTokens <= msg.value, "ETH amount is not sufficient");
2045 
2046         for (uint256 i = 0; i < numberOfTokens; i++) {
2047             if (totalPublicSupply < MAX_ODDBALL) {
2048                 uint256 tokenId = totalPublicSupply;
2049                 totalPublicSupply += 1;
2050                 _allowListClaimed[msg.sender] += 1;
2051                 _safeMint(msg.sender, tokenId);
2052             }
2053         }
2054     }
2055 
2056     function reserve(address _to, uint256 _reserveAmount) public onlyOwner {
2057         require(_reserveAmount > 0 && _reserveAmount <= oddballReserve, "Not enough reserve left");
2058         require(totalSupply() <= MAX_ODDBALL, "All tokens have been minted");
2059 
2060         for (uint256 i = 0; i < _reserveAmount; i++) {
2061             uint256 tokenId = totalPublicSupply;
2062             totalPublicSupply += 1;
2063             _safeMint(_to, tokenId);
2064         }
2065 
2066         oddballReserve = oddballReserve.sub(_reserveAmount);
2067     }
2068 
2069     function tokensOfOwner(address _owner) external view returns (uint256[] memory)
2070     {
2071         uint256 tokenCount = balanceOf(_owner);
2072         if (tokenCount == 0) {
2073             // Return an empty array
2074             return new uint256[](0);
2075         } else {
2076             uint256[] memory result = new uint256[](tokenCount);
2077             uint256 index;
2078             for (index = 0; index < tokenCount; index++) {
2079                 result[index] = tokenOfOwnerByIndex(_owner, index);
2080             }
2081             return result;
2082         }
2083     }
2084 }