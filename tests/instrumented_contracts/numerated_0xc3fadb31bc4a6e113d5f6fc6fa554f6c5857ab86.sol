1 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.3.1
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
231 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.1
232 
233 // MIT License
234 
235 pragma solidity ^0.8.0;
236 
237 /**
238  * @dev Interface of the ERC165 standard, as defined in the
239  * https://eips.ethereum.org/EIPS/eip-165[EIP].
240  *
241  * Implementers can declare support of contract interfaces, which can then be
242  * queried by others ({ERC165Checker}).
243  *
244  * For an implementation, see {ERC165}.
245  */
246 interface IERC165 {
247     /**
248      * @dev Returns true if this contract implements the interface defined by
249      * `interfaceId`. See the corresponding
250      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
251      * to learn more about how these ids are created.
252      *
253      * This function call must use less than 30 000 gas.
254      */
255     function supportsInterface(bytes4 interfaceId) external view returns (bool);
256 }
257 
258 
259 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.1
260 
261 // MIT License
262 
263 pragma solidity ^0.8.0;
264 
265 /**
266  * @dev Required interface of an ERC721 compliant contract.
267  */
268 interface IERC721 is IERC165 {
269     /**
270      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
271      */
272     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
273 
274     /**
275      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
276      */
277     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
278 
279     /**
280      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
281      */
282     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
283 
284     /**
285      * @dev Returns the number of tokens in ``owner``'s account.
286      */
287     function balanceOf(address owner) external view returns (uint256 balance);
288 
289     /**
290      * @dev Returns the owner of the `tokenId` token.
291      *
292      * Requirements:
293      *
294      * - `tokenId` must exist.
295      */
296     function ownerOf(uint256 tokenId) external view returns (address owner);
297 
298     /**
299      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
300      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
301      *
302      * Requirements:
303      *
304      * - `from` cannot be the zero address.
305      * - `to` cannot be the zero address.
306      * - `tokenId` token must exist and be owned by `from`.
307      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
308      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
309      *
310      * Emits a {Transfer} event.
311      */
312     function safeTransferFrom(
313         address from,
314         address to,
315         uint256 tokenId
316     ) external;
317 
318     /**
319      * @dev Transfers `tokenId` token from `from` to `to`.
320      *
321      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
322      *
323      * Requirements:
324      *
325      * - `from` cannot be the zero address.
326      * - `to` cannot be the zero address.
327      * - `tokenId` token must be owned by `from`.
328      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
329      *
330      * Emits a {Transfer} event.
331      */
332     function transferFrom(
333         address from,
334         address to,
335         uint256 tokenId
336     ) external;
337 
338     /**
339      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
340      * The approval is cleared when the token is transferred.
341      *
342      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
343      *
344      * Requirements:
345      *
346      * - The caller must own the token or be an approved operator.
347      * - `tokenId` must exist.
348      *
349      * Emits an {Approval} event.
350      */
351     function approve(address to, uint256 tokenId) external;
352 
353     /**
354      * @dev Returns the account approved for `tokenId` token.
355      *
356      * Requirements:
357      *
358      * - `tokenId` must exist.
359      */
360     function getApproved(uint256 tokenId) external view returns (address operator);
361 
362     /**
363      * @dev Approve or remove `operator` as an operator for the caller.
364      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
365      *
366      * Requirements:
367      *
368      * - The `operator` cannot be the caller.
369      *
370      * Emits an {ApprovalForAll} event.
371      */
372     function setApprovalForAll(address operator, bool _approved) external;
373 
374     /**
375      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
376      *
377      * See {setApprovalForAll}
378      */
379     function isApprovedForAll(address owner, address operator) external view returns (bool);
380 
381     /**
382      * @dev Safely transfers `tokenId` token from `from` to `to`.
383      *
384      * Requirements:
385      *
386      * - `from` cannot be the zero address.
387      * - `to` cannot be the zero address.
388      * - `tokenId` token must exist and be owned by `from`.
389      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
390      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
391      *
392      * Emits a {Transfer} event.
393      */
394     function safeTransferFrom(
395         address from,
396         address to,
397         uint256 tokenId,
398         bytes calldata data
399     ) external;
400 }
401 
402 
403 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.1
404 
405 // MIT License
406 
407 pragma solidity ^0.8.0;
408 
409 /**
410  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
411  * @dev See https://eips.ethereum.org/EIPS/eip-721
412  */
413 interface IERC721Enumerable is IERC721 {
414     /**
415      * @dev Returns the total amount of tokens stored by the contract.
416      */
417     function totalSupply() external view returns (uint256);
418 
419     /**
420      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
421      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
422      */
423     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
424 
425     /**
426      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
427      * Use along with {totalSupply} to enumerate all tokens.
428      */
429     function tokenByIndex(uint256 index) external view returns (uint256);
430 }
431 
432 
433 // File @openzeppelin/contracts/utils/Context.sol@v4.3.1
434 
435 // MIT License
436 
437 pragma solidity ^0.8.0;
438 
439 /**
440  * @dev Provides information about the current execution context, including the
441  * sender of the transaction and its data. While these are generally available
442  * via msg.sender and msg.data, they should not be accessed in such a direct
443  * manner, since when dealing with meta-transactions the account sending and
444  * paying for execution may not be the actual sender (as far as an application
445  * is concerned).
446  *
447  * This contract is only required for intermediate, library-like contracts.
448  */
449 abstract contract Context {
450     function _msgSender() internal view virtual returns (address) {
451         return msg.sender;
452     }
453 
454     function _msgData() internal view virtual returns (bytes calldata) {
455         return msg.data;
456     }
457 }
458 
459 
460 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.1
461 
462 // MIT License
463 
464 pragma solidity ^0.8.0;
465 
466 /**
467  * @dev Contract module which provides a basic access control mechanism, where
468  * there is an account (an owner) that can be granted exclusive access to
469  * specific functions.
470  *
471  * By default, the owner account will be the one that deploys the contract. This
472  * can later be changed with {transferOwnership}.
473  *
474  * This module is used through inheritance. It will make available the modifier
475  * `onlyOwner`, which can be applied to your functions to restrict their use to
476  * the owner.
477  */
478 abstract contract Ownable is Context {
479     address private _owner;
480 
481     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
482 
483     /**
484      * @dev Initializes the contract setting the deployer as the initial owner.
485      */
486     constructor() {
487         _setOwner(_msgSender());
488     }
489 
490     /**
491      * @dev Returns the address of the current owner.
492      */
493     function owner() public view virtual returns (address) {
494         return _owner;
495     }
496 
497     /**
498      * @dev Throws if called by any account other than the owner.
499      */
500     modifier onlyOwner() {
501         require(owner() == _msgSender(), "Ownable: caller is not the owner");
502         _;
503     }
504 
505     /**
506      * @dev Leaves the contract without owner. It will not be possible to call
507      * `onlyOwner` functions anymore. Can only be called by the current owner.
508      *
509      * NOTE: Renouncing ownership will leave the contract without an owner,
510      * thereby removing any functionality that is only available to the owner.
511      */
512     function renounceOwnership() public virtual onlyOwner {
513         _setOwner(address(0));
514     }
515 
516     /**
517      * @dev Transfers ownership of the contract to a new account (`newOwner`).
518      * Can only be called by the current owner.
519      */
520     function transferOwnership(address newOwner) public virtual onlyOwner {
521         require(newOwner != address(0), "Ownable: new owner is the zero address");
522         _setOwner(newOwner);
523     }
524 
525     function _setOwner(address newOwner) private {
526         address oldOwner = _owner;
527         _owner = newOwner;
528         emit OwnershipTransferred(oldOwner, newOwner);
529     }
530 }
531 
532 
533 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.1
534 
535 // MIT License
536 
537 pragma solidity ^0.8.0;
538 
539 /**
540  * @title ERC721 token receiver interface
541  * @dev Interface for any contract that wants to support safeTransfers
542  * from ERC721 asset contracts.
543  */
544 interface IERC721Receiver {
545     /**
546      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
547      * by `operator` from `from`, this function is called.
548      *
549      * It must return its Solidity selector to confirm the token transfer.
550      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
551      *
552      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
553      */
554     function onERC721Received(
555         address operator,
556         address from,
557         uint256 tokenId,
558         bytes calldata data
559     ) external returns (bytes4);
560 }
561 
562 
563 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.1
564 
565 // MIT License
566 
567 pragma solidity ^0.8.0;
568 
569 /**
570  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
571  * @dev See https://eips.ethereum.org/EIPS/eip-721
572  */
573 interface IERC721Metadata is IERC721 {
574     /**
575      * @dev Returns the token collection name.
576      */
577     function name() external view returns (string memory);
578 
579     /**
580      * @dev Returns the token collection symbol.
581      */
582     function symbol() external view returns (string memory);
583 
584     /**
585      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
586      */
587     function tokenURI(uint256 tokenId) external view returns (string memory);
588 }
589 
590 
591 // File @openzeppelin/contracts/utils/Address.sol@v4.3.1
592 
593 // MIT License
594 
595 pragma solidity ^0.8.0;
596 
597 /**
598  * @dev Collection of functions related to the address type
599  */
600 library Address {
601     /**
602      * @dev Returns true if `account` is a contract.
603      *
604      * [IMPORTANT]
605      * ====
606      * It is unsafe to assume that an address for which this function returns
607      * false is an externally-owned account (EOA) and not a contract.
608      *
609      * Among others, `isContract` will return false for the following
610      * types of addresses:
611      *
612      *  - an externally-owned account
613      *  - a contract in construction
614      *  - an address where a contract will be created
615      *  - an address where a contract lived, but was destroyed
616      * ====
617      */
618     function isContract(address account) internal view returns (bool) {
619         // This method relies on extcodesize, which returns 0 for contracts in
620         // construction, since the code is only stored at the end of the
621         // constructor execution.
622 
623         uint256 size;
624         assembly {
625             size := extcodesize(account)
626         }
627         return size > 0;
628     }
629 
630     /**
631      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
632      * `recipient`, forwarding all available gas and reverting on errors.
633      *
634      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
635      * of certain opcodes, possibly making contracts go over the 2300 gas limit
636      * imposed by `transfer`, making them unable to receive funds via
637      * `transfer`. {sendValue} removes this limitation.
638      *
639      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
640      *
641      * IMPORTANT: because control is transferred to `recipient`, care must be
642      * taken to not create reentrancy vulnerabilities. Consider using
643      * {ReentrancyGuard} or the
644      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
645      */
646     function sendValue(address payable recipient, uint256 amount) internal {
647         require(address(this).balance >= amount, "Address: insufficient balance");
648 
649         (bool success, ) = recipient.call{value: amount}("");
650         require(success, "Address: unable to send value, recipient may have reverted");
651     }
652 
653     /**
654      * @dev Performs a Solidity function call using a low level `call`. A
655      * plain `call` is an unsafe replacement for a function call: use this
656      * function instead.
657      *
658      * If `target` reverts with a revert reason, it is bubbled up by this
659      * function (like regular Solidity function calls).
660      *
661      * Returns the raw returned data. To convert to the expected return value,
662      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
663      *
664      * Requirements:
665      *
666      * - `target` must be a contract.
667      * - calling `target` with `data` must not revert.
668      *
669      * _Available since v3.1._
670      */
671     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
672         return functionCall(target, data, "Address: low-level call failed");
673     }
674 
675     /**
676      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
677      * `errorMessage` as a fallback revert reason when `target` reverts.
678      *
679      * _Available since v3.1._
680      */
681     function functionCall(
682         address target,
683         bytes memory data,
684         string memory errorMessage
685     ) internal returns (bytes memory) {
686         return functionCallWithValue(target, data, 0, errorMessage);
687     }
688 
689     /**
690      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
691      * but also transferring `value` wei to `target`.
692      *
693      * Requirements:
694      *
695      * - the calling contract must have an ETH balance of at least `value`.
696      * - the called Solidity function must be `payable`.
697      *
698      * _Available since v3.1._
699      */
700     function functionCallWithValue(
701         address target,
702         bytes memory data,
703         uint256 value
704     ) internal returns (bytes memory) {
705         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
706     }
707 
708     /**
709      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
710      * with `errorMessage` as a fallback revert reason when `target` reverts.
711      *
712      * _Available since v3.1._
713      */
714     function functionCallWithValue(
715         address target,
716         bytes memory data,
717         uint256 value,
718         string memory errorMessage
719     ) internal returns (bytes memory) {
720         require(address(this).balance >= value, "Address: insufficient balance for call");
721         require(isContract(target), "Address: call to non-contract");
722 
723         (bool success, bytes memory returndata) = target.call{value: value}(data);
724         return verifyCallResult(success, returndata, errorMessage);
725     }
726 
727     /**
728      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
729      * but performing a static call.
730      *
731      * _Available since v3.3._
732      */
733     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
734         return functionStaticCall(target, data, "Address: low-level static call failed");
735     }
736 
737     /**
738      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
739      * but performing a static call.
740      *
741      * _Available since v3.3._
742      */
743     function functionStaticCall(
744         address target,
745         bytes memory data,
746         string memory errorMessage
747     ) internal view returns (bytes memory) {
748         require(isContract(target), "Address: static call to non-contract");
749 
750         (bool success, bytes memory returndata) = target.staticcall(data);
751         return verifyCallResult(success, returndata, errorMessage);
752     }
753 
754     /**
755      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
756      * but performing a delegate call.
757      *
758      * _Available since v3.4._
759      */
760     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
761         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
762     }
763 
764     /**
765      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
766      * but performing a delegate call.
767      *
768      * _Available since v3.4._
769      */
770     function functionDelegateCall(
771         address target,
772         bytes memory data,
773         string memory errorMessage
774     ) internal returns (bytes memory) {
775         require(isContract(target), "Address: delegate call to non-contract");
776 
777         (bool success, bytes memory returndata) = target.delegatecall(data);
778         return verifyCallResult(success, returndata, errorMessage);
779     }
780 
781     /**
782      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
783      * revert reason using the provided one.
784      *
785      * _Available since v4.3._
786      */
787     function verifyCallResult(
788         bool success,
789         bytes memory returndata,
790         string memory errorMessage
791     ) internal pure returns (bytes memory) {
792         if (success) {
793             return returndata;
794         } else {
795             // Look for revert reason and bubble it up if present
796             if (returndata.length > 0) {
797                 // The easiest way to bubble the revert reason is using memory via assembly
798 
799                 assembly {
800                     let returndata_size := mload(returndata)
801                     revert(add(32, returndata), returndata_size)
802                 }
803             } else {
804                 revert(errorMessage);
805             }
806         }
807     }
808 }
809 
810 
811 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.1
812 
813 // MIT License
814 
815 pragma solidity ^0.8.0;
816 
817 /**
818  * @dev String operations.
819  */
820 library Strings {
821     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
822 
823     /**
824      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
825      */
826     function toString(uint256 value) internal pure returns (string memory) {
827         // Inspired by OraclizeAPI's implementation - MIT licence
828         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
829 
830         if (value == 0) {
831             return "0";
832         }
833         uint256 temp = value;
834         uint256 digits;
835         while (temp != 0) {
836             digits++;
837             temp /= 10;
838         }
839         bytes memory buffer = new bytes(digits);
840         while (value != 0) {
841             digits -= 1;
842             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
843             value /= 10;
844         }
845         return string(buffer);
846     }
847 
848     /**
849      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
850      */
851     function toHexString(uint256 value) internal pure returns (string memory) {
852         if (value == 0) {
853             return "0x00";
854         }
855         uint256 temp = value;
856         uint256 length = 0;
857         while (temp != 0) {
858             length++;
859             temp >>= 8;
860         }
861         return toHexString(value, length);
862     }
863 
864     /**
865      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
866      */
867     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
868         bytes memory buffer = new bytes(2 * length + 2);
869         buffer[0] = "0";
870         buffer[1] = "x";
871         for (uint256 i = 2 * length + 1; i > 1; --i) {
872             buffer[i] = _HEX_SYMBOLS[value & 0xf];
873             value >>= 4;
874         }
875         require(value == 0, "Strings: hex length insufficient");
876         return string(buffer);
877     }
878 }
879 
880 
881 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.1
882 
883 // MIT License
884 
885 pragma solidity ^0.8.0;
886 
887 /**
888  * @dev Implementation of the {IERC165} interface.
889  *
890  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
891  * for the additional interface id that will be supported. For example:
892  *
893  * ```solidity
894  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
895  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
896  * }
897  * ```
898  *
899  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
900  */
901 abstract contract ERC165 is IERC165 {
902     /**
903      * @dev See {IERC165-supportsInterface}.
904      */
905     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
906         return interfaceId == type(IERC165).interfaceId;
907     }
908 }
909 
910 
911 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.1
912 
913 // MIT License
914 
915 pragma solidity ^0.8.0;
916 
917 
918 
919 
920 
921 
922 
923 /**
924  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
925  * the Metadata extension, but not including the Enumerable extension, which is available separately as
926  * {ERC721Enumerable}.
927  */
928 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
929     using Address for address;
930     using Strings for uint256;
931 
932     // Token name
933     string private _name;
934 
935     // Token symbol
936     string private _symbol;
937 
938     // Mapping from token ID to owner address
939     mapping(uint256 => address) private _owners;
940 
941     // Mapping owner address to token count
942     mapping(address => uint256) private _balances;
943 
944     // Mapping from token ID to approved address
945     mapping(uint256 => address) private _tokenApprovals;
946 
947     // Mapping from owner to operator approvals
948     mapping(address => mapping(address => bool)) private _operatorApprovals;
949 
950     /**
951      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
952      */
953     constructor(string memory name_, string memory symbol_) {
954         _name = name_;
955         _symbol = symbol_;
956     }
957 
958     /**
959      * @dev See {IERC165-supportsInterface}.
960      */
961     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
962         return
963             interfaceId == type(IERC721).interfaceId ||
964             interfaceId == type(IERC721Metadata).interfaceId ||
965             super.supportsInterface(interfaceId);
966     }
967 
968     /**
969      * @dev See {IERC721-balanceOf}.
970      */
971     function balanceOf(address owner) public view virtual override returns (uint256) {
972         require(owner != address(0), "ERC721: balance query for the zero address");
973         return _balances[owner];
974     }
975 
976     /**
977      * @dev See {IERC721-ownerOf}.
978      */
979     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
980         address owner = _owners[tokenId];
981         require(owner != address(0), "ERC721: owner query for nonexistent token");
982         return owner;
983     }
984 
985     /**
986      * @dev See {IERC721Metadata-name}.
987      */
988     function name() public view virtual override returns (string memory) {
989         return _name;
990     }
991 
992     /**
993      * @dev See {IERC721Metadata-symbol}.
994      */
995     function symbol() public view virtual override returns (string memory) {
996         return _symbol;
997     }
998 
999     /**
1000      * @dev See {IERC721Metadata-tokenURI}.
1001      */
1002     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1003         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1004 
1005         string memory baseURI = _baseURI();
1006         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1007     }
1008 
1009     /**
1010      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1011      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1012      * by default, can be overriden in child contracts.
1013      */
1014     function _baseURI() internal view virtual returns (string memory) {
1015         return "";
1016     }
1017 
1018     /**
1019      * @dev See {IERC721-approve}.
1020      */
1021     function approve(address to, uint256 tokenId) public virtual override {
1022         address owner = ERC721.ownerOf(tokenId);
1023         require(to != owner, "ERC721: approval to current owner");
1024 
1025         require(
1026             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1027             "ERC721: approve caller is not owner nor approved for all"
1028         );
1029 
1030         _approve(to, tokenId);
1031     }
1032 
1033     /**
1034      * @dev See {IERC721-getApproved}.
1035      */
1036     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1037         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1038 
1039         return _tokenApprovals[tokenId];
1040     }
1041 
1042     /**
1043      * @dev See {IERC721-setApprovalForAll}.
1044      */
1045     function setApprovalForAll(address operator, bool approved) public virtual override {
1046         require(operator != _msgSender(), "ERC721: approve to caller");
1047 
1048         _operatorApprovals[_msgSender()][operator] = approved;
1049         emit ApprovalForAll(_msgSender(), operator, approved);
1050     }
1051 
1052     /**
1053      * @dev See {IERC721-isApprovedForAll}.
1054      */
1055     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1056         return _operatorApprovals[owner][operator];
1057     }
1058 
1059     /**
1060      * @dev See {IERC721-transferFrom}.
1061      */
1062     function transferFrom(
1063         address from,
1064         address to,
1065         uint256 tokenId
1066     ) public virtual override {
1067         //solhint-disable-next-line max-line-length
1068         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1069 
1070         _transfer(from, to, tokenId);
1071     }
1072 
1073     /**
1074      * @dev See {IERC721-safeTransferFrom}.
1075      */
1076     function safeTransferFrom(
1077         address from,
1078         address to,
1079         uint256 tokenId
1080     ) public virtual override {
1081         safeTransferFrom(from, to, tokenId, "");
1082     }
1083 
1084     /**
1085      * @dev See {IERC721-safeTransferFrom}.
1086      */
1087     function safeTransferFrom(
1088         address from,
1089         address to,
1090         uint256 tokenId,
1091         bytes memory _data
1092     ) public virtual override {
1093         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1094         _safeTransfer(from, to, tokenId, _data);
1095     }
1096 
1097     /**
1098      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1099      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1100      *
1101      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1102      *
1103      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1104      * implement alternative mechanisms to perform token transfer, such as signature-based.
1105      *
1106      * Requirements:
1107      *
1108      * - `from` cannot be the zero address.
1109      * - `to` cannot be the zero address.
1110      * - `tokenId` token must exist and be owned by `from`.
1111      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1112      *
1113      * Emits a {Transfer} event.
1114      */
1115     function _safeTransfer(
1116         address from,
1117         address to,
1118         uint256 tokenId,
1119         bytes memory _data
1120     ) internal virtual {
1121         _transfer(from, to, tokenId);
1122         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1123     }
1124 
1125     /**
1126      * @dev Returns whether `tokenId` exists.
1127      *
1128      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1129      *
1130      * Tokens start existing when they are minted (`_mint`),
1131      * and stop existing when they are burned (`_burn`).
1132      */
1133     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1134         return _owners[tokenId] != address(0);
1135     }
1136 
1137     /**
1138      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1139      *
1140      * Requirements:
1141      *
1142      * - `tokenId` must exist.
1143      */
1144     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1145         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1146         address owner = ERC721.ownerOf(tokenId);
1147         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1148     }
1149 
1150     /**
1151      * @dev Safely mints `tokenId` and transfers it to `to`.
1152      *
1153      * Requirements:
1154      *
1155      * - `tokenId` must not exist.
1156      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1157      *
1158      * Emits a {Transfer} event.
1159      */
1160     function _safeMint(address to, uint256 tokenId) internal virtual {
1161         _safeMint(to, tokenId, "");
1162     }
1163 
1164     /**
1165      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1166      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1167      */
1168     function _safeMint(
1169         address to,
1170         uint256 tokenId,
1171         bytes memory _data
1172     ) internal virtual {
1173         _mint(to, tokenId);
1174         require(
1175             _checkOnERC721Received(address(0), to, tokenId, _data),
1176             "ERC721: transfer to non ERC721Receiver implementer"
1177         );
1178     }
1179 
1180     /**
1181      * @dev Mints `tokenId` and transfers it to `to`.
1182      *
1183      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1184      *
1185      * Requirements:
1186      *
1187      * - `tokenId` must not exist.
1188      * - `to` cannot be the zero address.
1189      *
1190      * Emits a {Transfer} event.
1191      */
1192     function _mint(address to, uint256 tokenId) internal virtual {
1193         require(to != address(0), "ERC721: mint to the zero address");
1194         require(!_exists(tokenId), "ERC721: token already minted");
1195 
1196         _beforeTokenTransfer(address(0), to, tokenId);
1197 
1198         _balances[to] += 1;
1199         _owners[tokenId] = to;
1200 
1201         emit Transfer(address(0), to, tokenId);
1202     }
1203 
1204     /**
1205      * @dev Destroys `tokenId`.
1206      * The approval is cleared when the token is burned.
1207      *
1208      * Requirements:
1209      *
1210      * - `tokenId` must exist.
1211      *
1212      * Emits a {Transfer} event.
1213      */
1214     function _burn(uint256 tokenId) internal virtual {
1215         address owner = ERC721.ownerOf(tokenId);
1216 
1217         _beforeTokenTransfer(owner, address(0), tokenId);
1218 
1219         // Clear approvals
1220         _approve(address(0), tokenId);
1221 
1222         _balances[owner] -= 1;
1223         delete _owners[tokenId];
1224 
1225         emit Transfer(owner, address(0), tokenId);
1226     }
1227 
1228     /**
1229      * @dev Transfers `tokenId` from `from` to `to`.
1230      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1231      *
1232      * Requirements:
1233      *
1234      * - `to` cannot be the zero address.
1235      * - `tokenId` token must be owned by `from`.
1236      *
1237      * Emits a {Transfer} event.
1238      */
1239     function _transfer(
1240         address from,
1241         address to,
1242         uint256 tokenId
1243     ) internal virtual {
1244         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1245         require(to != address(0), "ERC721: transfer to the zero address");
1246 
1247         _beforeTokenTransfer(from, to, tokenId);
1248 
1249         // Clear approvals from the previous owner
1250         _approve(address(0), tokenId);
1251 
1252         _balances[from] -= 1;
1253         _balances[to] += 1;
1254         _owners[tokenId] = to;
1255 
1256         emit Transfer(from, to, tokenId);
1257     }
1258 
1259     /**
1260      * @dev Approve `to` to operate on `tokenId`
1261      *
1262      * Emits a {Approval} event.
1263      */
1264     function _approve(address to, uint256 tokenId) internal virtual {
1265         _tokenApprovals[tokenId] = to;
1266         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1267     }
1268 
1269     /**
1270      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1271      * The call is not executed if the target address is not a contract.
1272      *
1273      * @param from address representing the previous owner of the given token ID
1274      * @param to target address that will receive the tokens
1275      * @param tokenId uint256 ID of the token to be transferred
1276      * @param _data bytes optional data to send along with the call
1277      * @return bool whether the call correctly returned the expected magic value
1278      */
1279     function _checkOnERC721Received(
1280         address from,
1281         address to,
1282         uint256 tokenId,
1283         bytes memory _data
1284     ) private returns (bool) {
1285         if (to.isContract()) {
1286             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1287                 return retval == IERC721Receiver.onERC721Received.selector;
1288             } catch (bytes memory reason) {
1289                 if (reason.length == 0) {
1290                     revert("ERC721: transfer to non ERC721Receiver implementer");
1291                 } else {
1292                     assembly {
1293                         revert(add(32, reason), mload(reason))
1294                     }
1295                 }
1296             }
1297         } else {
1298             return true;
1299         }
1300     }
1301 
1302     /**
1303      * @dev Hook that is called before any token transfer. This includes minting
1304      * and burning.
1305      *
1306      * Calling conditions:
1307      *
1308      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1309      * transferred to `to`.
1310      * - When `from` is zero, `tokenId` will be minted for `to`.
1311      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1312      * - `from` and `to` are never both zero.
1313      *
1314      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1315      */
1316     function _beforeTokenTransfer(
1317         address from,
1318         address to,
1319         uint256 tokenId
1320     ) internal virtual {}
1321 }
1322 
1323 
1324 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.1
1325 
1326 // MIT License
1327 
1328 pragma solidity ^0.8.0;
1329 
1330 
1331 /**
1332  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1333  * enumerability of all the token ids in the contract as well as all token ids owned by each
1334  * account.
1335  */
1336 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1337     // Mapping from owner to list of owned token IDs
1338     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1339 
1340     // Mapping from token ID to index of the owner tokens list
1341     mapping(uint256 => uint256) private _ownedTokensIndex;
1342 
1343     // Array with all token ids, used for enumeration
1344     uint256[] private _allTokens;
1345 
1346     // Mapping from token id to position in the allTokens array
1347     mapping(uint256 => uint256) private _allTokensIndex;
1348 
1349     /**
1350      * @dev See {IERC165-supportsInterface}.
1351      */
1352     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1353         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1354     }
1355 
1356     /**
1357      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1358      */
1359     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1360         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1361         return _ownedTokens[owner][index];
1362     }
1363 
1364     /**
1365      * @dev See {IERC721Enumerable-totalSupply}.
1366      */
1367     function totalSupply() public view virtual override returns (uint256) {
1368         return _allTokens.length;
1369     }
1370 
1371     /**
1372      * @dev See {IERC721Enumerable-tokenByIndex}.
1373      */
1374     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1375         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1376         return _allTokens[index];
1377     }
1378 
1379     /**
1380      * @dev Hook that is called before any token transfer. This includes minting
1381      * and burning.
1382      *
1383      * Calling conditions:
1384      *
1385      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1386      * transferred to `to`.
1387      * - When `from` is zero, `tokenId` will be minted for `to`.
1388      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1389      * - `from` cannot be the zero address.
1390      * - `to` cannot be the zero address.
1391      *
1392      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1393      */
1394     function _beforeTokenTransfer(
1395         address from,
1396         address to,
1397         uint256 tokenId
1398     ) internal virtual override {
1399         super._beforeTokenTransfer(from, to, tokenId);
1400 
1401         if (from == address(0)) {
1402             _addTokenToAllTokensEnumeration(tokenId);
1403         } else if (from != to) {
1404             _removeTokenFromOwnerEnumeration(from, tokenId);
1405         }
1406         if (to == address(0)) {
1407             _removeTokenFromAllTokensEnumeration(tokenId);
1408         } else if (to != from) {
1409             _addTokenToOwnerEnumeration(to, tokenId);
1410         }
1411     }
1412 
1413     /**
1414      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1415      * @param to address representing the new owner of the given token ID
1416      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1417      */
1418     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1419         uint256 length = ERC721.balanceOf(to);
1420         _ownedTokens[to][length] = tokenId;
1421         _ownedTokensIndex[tokenId] = length;
1422     }
1423 
1424     /**
1425      * @dev Private function to add a token to this extension's token tracking data structures.
1426      * @param tokenId uint256 ID of the token to be added to the tokens list
1427      */
1428     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1429         _allTokensIndex[tokenId] = _allTokens.length;
1430         _allTokens.push(tokenId);
1431     }
1432 
1433     /**
1434      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1435      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1436      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1437      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1438      * @param from address representing the previous owner of the given token ID
1439      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1440      */
1441     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1442         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1443         // then delete the last slot (swap and pop).
1444 
1445         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1446         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1447 
1448         // When the token to delete is the last token, the swap operation is unnecessary
1449         if (tokenIndex != lastTokenIndex) {
1450             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1451 
1452             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1453             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1454         }
1455 
1456         // This also deletes the contents at the last position of the array
1457         delete _ownedTokensIndex[tokenId];
1458         delete _ownedTokens[from][lastTokenIndex];
1459     }
1460 
1461     /**
1462      * @dev Private function to remove a token from this extension's token tracking data structures.
1463      * This has O(1) time complexity, but alters the order of the _allTokens array.
1464      * @param tokenId uint256 ID of the token to be removed from the tokens list
1465      */
1466     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1467         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1468         // then delete the last slot (swap and pop).
1469 
1470         uint256 lastTokenIndex = _allTokens.length - 1;
1471         uint256 tokenIndex = _allTokensIndex[tokenId];
1472 
1473         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1474         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1475         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1476         uint256 lastTokenId = _allTokens[lastTokenIndex];
1477 
1478         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1479         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1480 
1481         // This also deletes the contents at the last position of the array
1482         delete _allTokensIndex[tokenId];
1483         _allTokens.pop();
1484     }
1485 }
1486 
1487 
1488 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.3.1
1489 
1490 // MIT License
1491 
1492 pragma solidity ^0.8.0;
1493 
1494 /**
1495  * @dev Contract module that helps prevent reentrant calls to a function.
1496  *
1497  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1498  * available, which can be applied to functions to make sure there are no nested
1499  * (reentrant) calls to them.
1500  *
1501  * Note that because there is a single `nonReentrant` guard, functions marked as
1502  * `nonReentrant` may not call one another. This can be worked around by making
1503  * those functions `private`, and then adding `external` `nonReentrant` entry
1504  * points to them.
1505  *
1506  * TIP: If you would like to learn more about reentrancy and alternative ways
1507  * to protect against it, check out our blog post
1508  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1509  */
1510 abstract contract ReentrancyGuard {
1511     // Booleans are more expensive than uint256 or any type that takes up a full
1512     // word because each write operation emits an extra SLOAD to first read the
1513     // slot's contents, replace the bits taken up by the boolean, and then write
1514     // back. This is the compiler's defense against contract upgrades and
1515     // pointer aliasing, and it cannot be disabled.
1516 
1517     // The values being non-zero value makes deployment a bit more expensive,
1518     // but in exchange the refund on every call to nonReentrant will be lower in
1519     // amount. Since refunds are capped to a percentage of the total
1520     // transaction's gas, it is best to keep them low in cases like this one, to
1521     // increase the likelihood of the full refund coming into effect.
1522     uint256 private constant _NOT_ENTERED = 1;
1523     uint256 private constant _ENTERED = 2;
1524 
1525     uint256 private _status;
1526 
1527     constructor() {
1528         _status = _NOT_ENTERED;
1529     }
1530 
1531     /**
1532      * @dev Prevents a contract from calling itself, directly or indirectly.
1533      * Calling a `nonReentrant` function from another `nonReentrant`
1534      * function is not supported. It is possible to prevent this from happening
1535      * by making the `nonReentrant` function external, and make it call a
1536      * `private` function that does the actual work.
1537      */
1538     modifier nonReentrant() {
1539         // On the first call to nonReentrant, _notEntered will be true
1540         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1541 
1542         // Any calls to nonReentrant after this point will fail
1543         _status = _ENTERED;
1544 
1545         _;
1546 
1547         // By storing the original value once again, a refund is triggered (see
1548         // https://eips.ethereum.org/EIPS/eip-2200)
1549         _status = _NOT_ENTERED;
1550     }
1551 }
1552 
1553 
1554 // File contracts/NonFungibleForks.sol
1555 
1556 // contracts/NonFungibleForks.sol
1557 // MIT License
1558 pragma solidity ^0.8.0;
1559 
1560 
1561 
1562 
1563 
1564 // Welcome to the Non-Fungible Forks Smart Contract!
1565 // Let's be honest: this is the first time Ryan (dev/dad) has done this.
1566 // Although I've made stuff in lots of other languages, the immutability
1567 // of smart contracts is a tad scary, if we're being honest.
1568 // If you find something that seems like a vulnerability, please let
1569 // me know at ryan@forkhunger.art instead of being a forking arsehole
1570 // and exploiting a charity project, please!
1571 
1572 // A great deal of this Smart Contract was adapted from that of the AMAZING
1573 // HashScapes NFT project (hashscapes.com) - particularly the base
1574 // functions for magic and power (called balances and dividends in HS)
1575 // Please go support these amazing co-forkers as their NFT has considerably
1576 // more utility than our little charity project! [hashscapes.com]
1577 
1578 // Paul Price of Top Dog Beach Club has also been an invaluable resource
1579 // to me and to the project in general. Abby also made a 1/1 for the 
1580 // collection! [topdogbeachclub.com]
1581 
1582 // Please check out our website for a list of all co-forkers who helped make
1583 // this project possible. https://forkhunger.art
1584 
1585 // According the the USDA, at least 10.5% of all households in the United States
1586 // are food insecure. Their definition for food insecurity is "uncertain of having, 
1587 // or unable to acquire, enough food to meet the needs of all their members because 
1588 // they had insufficient money or other resources for food. 
1589 // [https://www.ers.usda.gov/topics/food-nutrition-assistance/food-security-in-the-us/key-statistics-graphics.aspx]
1590 
1591 // Other "developed" countries have similar challenges making sure everyone has
1592 // enough to eat. An estimated 7.2% of the population in high income countries 
1593 // used food banks in 2013. [https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6572174/]
1594 
1595 // We can do better than this! While we wait and work for social structures to 
1596 // improve, however, it's super important to support the existing systems of
1597 // food banks and other charitable organizations focused on feeding people.
1598 // That's what we aim to do with this project.
1599 
1600 // F**K HUNGER!
1601 
1602 contract NonFungibleForks is ERC721Enumerable, Ownable, ReentrancyGuard {
1603     using SafeMath for uint256;
1604     struct ForkMagic {
1605         uint256 magic;
1606         uint256 power;
1607         uint256 lastTimestamp;
1608     }
1609 
1610     uint public constant MAX_FORKS = 5555;
1611     uint public constant NUMBER_RESERVED = 55;
1612     uint public constant PRICE = 30000000000000000; // 0.03 ETH each (after first one)
1613     string public METADATA_PROVENANCE_HASH = "";
1614 
1615     string public baseURI = "https://api.forkhunger.art/";
1616     uint private curIndex = NUMBER_RESERVED.add(1);
1617     bool public hasSaleStarted = false;
1618     mapping(uint => ForkMagic) private forkMagicLevels; // mapping of NonFungibleForks IDs to their "Fork Magic"
1619 
1620     constructor() ERC721("NonFungibleForks","FORKHUNGER")  {
1621     }
1622     
1623     /** FORKS MAGIC */
1624     
1625     /** Each Fork is initialized with a magic of 100
1626      * and power rate of 10. This means the Fork's
1627      * magic increases at a base rate of 10/day. */
1628     function initializeForkMagic(uint id) private {
1629         forkMagicLevels[id] = ForkMagic(100, 10, block.timestamp);
1630     }
1631     
1632     function getForkMagic(uint id) public view returns (uint256) {
1633         /* Note on `forkMagicLevels[id].power >= 10`: The
1634         * `power` is initialized at 10, and it can never
1635         * be decreased. Therefore, `power < 10` means
1636         * the Fork has not been minted yet. */
1637         require(forkMagicLevels[id].power >= 10, "That Fork has not been minted yet.");
1638         ForkMagic storage forkMagic = forkMagicLevels[id];
1639         /* `lastTimestamp` is a variable that serves to cache
1640         * the Fork's value. This is to save on gas--this
1641         * function will return to correct magic without
1642         * having to update the `magic` until necessary. */
1643         return forkMagic.magic.add(forkMagic.power.mul(block.timestamp.sub(forkMagic.lastTimestamp)).div(86400)); // 86400 seconds is 1 day.
1644     }
1645     
1646     /** Each Fork's power is initialized at 10/day.
1647      * However, one can spend 0.005 ETH to upgrade it.
1648      * This way, certain NonFungibleForks can accumulate magic
1649      * quicker. 
1650      *
1651      * Did you know you can donate to a local food pantry and 
1652      * receive a free Semi-fungible fork? */
1653     function upgradeForkPower(uint id, uint256 amount) public payable {
1654         require(forkMagicLevels[id].power >= 10, "That Fork has not been minted yet.");
1655         require(msg.value >= amount.mul(5000000000000000)); // 0.005 ETH
1656         ForkMagic storage forkMagic = forkMagicLevels[id];
1657         /* `getForkMagic` must be used to retrieve the
1658         * live magic. Then, this must be updated to
1659         * ensure it will work the next time it is called.
1660         * As mentioned earlier, `lastTimestamp` serves
1661         * as a cached value to minimize gas usage. Thus,
1662         * it must also be updated. */
1663         forkMagic.magic = getForkMagic(id);
1664         forkMagic.lastTimestamp = block.timestamp;
1665         forkMagic.power = forkMagic.power.add(amount);
1666     }
1667     
1668     /** This function takes in an array of Fork IDs
1669      * and an array of magics to spend from them. Thus,
1670      * there must be no duplicate IDs and the arrays should
1671      * be of equal length. It is important to note that
1672      * the owner's ability to select WHICH NonFungibleForks to
1673      * spend magic from is crucial to maintain their
1674      * value. btw go buy a HashScape immediately */
1675     function spendForkMagic(uint[] memory forkIds, uint256[] memory amountToSpend) public returns (uint256) {
1676         require(forkIds.length == amountToSpend.length, "You must provide a 1-to-1 relationship of magic amounts to spend from your NonFungibleForks.");
1677         require(!checkDuplicates(forkIds), "You may not buy from the same coin per transaction.");
1678         require(forkIds.length <= 10, "You can only spend from 10 NonFungibleForks at a time.");
1679         uint256 totalSpent = 0;
1680         // Loop through first to make sure the owner actually owns all their NonFungibleForks and has enough magic in them.
1681         for (uint i = 0; i < forkIds.length; i++) {
1682             uint id = forkIds[i];
1683             uint256 amount = amountToSpend[i];
1684             require(msg.sender == ownerOf(id), "You do not own the NonFungibleForks you specified.");
1685             require(getForkMagic(id) >= amount, "Insufficient NonFungibleForks magic.");
1686         }
1687         // See `upgradeForkPower` comments for explanation on why the NonFungibleForks' magics and `lastTimestamp` are updated.
1688         for (uint i = 0; i < forkIds.length; i++) {
1689             uint id = forkIds[i];
1690             uint amount = amountToSpend[i];
1691             ForkMagic storage forkMagic = forkMagicLevels[id];
1692             forkMagic.magic = getForkMagic(id).sub(amount);
1693             forkMagic.lastTimestamp = block.timestamp;
1694             totalSpent = totalSpent.add(amount);
1695         }
1696         // The total magic that was spent is returned, so it can be used with future apps and integrations.
1697         return totalSpent;
1698     }
1699     
1700     /** O(n^2) algorithm to check for duplicate integers
1701      * in an array. For small input (in this case, <= 10),
1702      * the algorithm is good. Thus, gas is not wasted. */
1703     function checkDuplicates(uint[] memory arr) private pure returns (bool) {
1704         for (uint i = 0; i < arr.length; i++) {
1705             for (uint j = i + 1; j < arr.length; j++) {
1706                 if (arr[i] == arr[j]) {
1707                     return true;
1708                 }
1709             }
1710         }
1711         return false;
1712     }
1713     
1714     /** NFT */
1715     
1716     function tokensOfOwner(address _owner) external view returns (uint256[] memory) {
1717         uint256 tokenCount = balanceOf(_owner);
1718         if (tokenCount == 0) {
1719             return new uint256[](0);
1720         } else {
1721             uint256[] memory result = new uint256[](tokenCount);
1722             uint256 index;
1723             for (index = 0; index < tokenCount; index++) {
1724                 result[index] = tokenOfOwnerByIndex(_owner, index);
1725             }
1726             return result;
1727         }
1728     }
1729 
1730     function buyFork(uint256 numNonFungibleForks) public payable nonReentrant() {
1731         require(hasSaleStarted, "Sale is not active.");
1732         require(totalSupply() < MAX_FORKS, "Sale has ended.");
1733         require(numNonFungibleForks > 0 && numNonFungibleForks <= 25, "You can buy a maximum of 25 Non-Fungible Forks at a time.");
1734         require(totalSupply().add(numNonFungibleForks) <= MAX_FORKS, "Not enough Non-Fungible Forks remain!");
1735         require((msg.value >= numNonFungibleForks.mul(PRICE)) || (balanceOf(msg.sender) < 1 && numNonFungibleForks == 1), "Minimum price of 0.03 after first fork.");
1736         for (uint i = 0; i < numNonFungibleForks; i++) {
1737             _safeMint(msg.sender, curIndex);
1738             initializeForkMagic(curIndex);
1739             adjustIndex();
1740         }
1741     }
1742 
1743     function adjustIndex() private {
1744         curIndex++;
1745     }
1746 
1747     function getCurrentIndex() public view returns (uint) {
1748         return curIndex;
1749     }
1750 
1751     function setProvenanceHash(string memory _hash) public onlyOwner {
1752         METADATA_PROVENANCE_HASH = _hash;
1753     }
1754 
1755     function setBaseURI(string memory newBaseURI) public onlyOwner {
1756         baseURI = newBaseURI;
1757     }
1758 
1759     function _baseURI() internal view virtual override returns (string memory) {
1760         return getBaseURI();
1761     }
1762     
1763     function getBaseURI() public view returns (string memory) {
1764         return baseURI;
1765     }
1766 
1767     function flipSaleState() public onlyOwner {
1768         hasSaleStarted = !hasSaleStarted;
1769     }
1770 
1771     function withdrawAll() public payable onlyOwner {
1772         require(payable(msg.sender).send(address(this).balance));
1773     }
1774 
1775     function reserve() public onlyOwner {
1776         // Reserve first `NUMBER_RESERVED` NonFungibleForks 
1777         for (uint i = 1; i <= NUMBER_RESERVED; i++) {
1778             initializeForkMagic(i);
1779             _safeMint(owner(), i);
1780         }
1781     }
1782 
1783     function giveAwayMany(address[] memory recipients) public nonReentrant() onlyOwner {
1784         require(totalSupply().add(recipients.length) < MAX_FORKS, "Not enough forks remain.");
1785         for (uint i = 0; i < recipients.length; i++) {
1786             address giveawayTo = recipients[i];
1787             _safeMint(giveawayTo, curIndex);
1788             initializeForkMagic(curIndex);
1789             adjustIndex();
1790         }
1791     }
1792 
1793     function giveAway(address recipient) public nonReentrant() onlyOwner {
1794         require(totalSupply() < MAX_FORKS, "Sale has already ended");
1795         _safeMint(recipient, curIndex);
1796         initializeForkMagic(curIndex);
1797         adjustIndex();
1798     }
1799 
1800     function reserveCur() public onlyOwner {
1801         require(totalSupply() < MAX_FORKS, "Sale has already ended");
1802         initializeForkMagic(curIndex);
1803         _safeMint(owner(), curIndex);
1804         adjustIndex();
1805     }
1806 
1807     function contractURI() public view returns (string memory) {
1808         return string(abi.encodePacked(baseURI, "contract_metadata.json"));
1809     }
1810 }