1 // SPDX-License-Identifier: MIT LICENSE
2 pragma solidity ^0.8.6;
3 
4 library SafeMath {
5     function add(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a + b;
7         require(c >= a, "SafeMath: addition overflow");
8 
9         return c;
10     }
11 
12     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
13         return sub(a, b, "SafeMath: subtraction overflow");
14     }
15 
16     function sub(
17         uint256 a,
18         uint256 b,
19         string memory errorMessage
20     ) internal pure returns (uint256) {
21         require(b <= a, errorMessage);
22         uint256 c = a - b;
23 
24         return c;
25     }
26 
27     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
28         if (a == 0) {
29             return 0;
30         }
31 
32         uint256 c = a * b;
33         require(c / a == b, "SafeMath: multiplication overflow");
34 
35         return c;
36     }
37 
38     function div(uint256 a, uint256 b) internal pure returns (uint256) {
39         return div(a, b, "SafeMath: division by zero");
40     }
41 
42     function div(
43         uint256 a,
44         uint256 b,
45         string memory errorMessage
46     ) internal pure returns (uint256) {
47         require(b > 0, errorMessage);
48         uint256 c = a / b;
49         return c;
50     }
51 
52     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
53         return mod(a, b, "SafeMath: modulo by zero");
54     }
55 
56     function mod(
57         uint256 a,
58         uint256 b,
59         string memory errorMessage
60     ) internal pure returns (uint256) {
61         require(b != 0, errorMessage);
62         return a % b;
63     }
64 
65     function sqrrt(uint256 a) internal pure returns (uint256 c) {
66         if (a > 3) {
67             c = a;
68             uint256 b = add(div(a, 2), 1);
69             while (b < c) {
70                 c = b;
71                 b = div(add(div(a, b), b), 2);
72             }
73         } else if (a != 0) {
74             c = 1;
75         }
76     }
77 }
78 
79 library Address {
80     /**
81      * @dev Returns true if `account` is a contract.
82      *
83      * [IMPORTANT]
84      * ====
85      * It is unsafe to assume that an address for which this function returns
86      * false is an externally-owned account (EOA) and not a contract.
87      *
88      * Among others, `isContract` will return false for the following
89      * types of addresses:
90      *
91      *  - an externally-owned account
92      *  - a contract in construction
93      *  - an address where a contract will be created
94      *  - an address where a contract lived, but was destroyed
95      * ====
96      */
97     function isContract(address account) internal view returns (bool) {
98         // This method relies on extcodesize, which returns 0 for contracts in
99         // construction, since the code is only stored at the end of the
100         // constructor execution.
101 
102         uint256 size;
103         assembly {
104             size := extcodesize(account)
105         }
106         return size > 0;
107     }
108 
109     /**
110      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
111      * `recipient`, forwarding all available gas and reverting on errors.
112      *
113      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
114      * of certain opcodes, possibly making contracts go over the 2300 gas limit
115      * imposed by `transfer`, making them unable to receive funds via
116      * `transfer`. {sendValue} removes this limitation.
117      *
118      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
119      *
120      * IMPORTANT: because control is transferred to `recipient`, care must be
121      * taken to not create reentrancy vulnerabilities. Consider using
122      * {ReentrancyGuard} or the
123      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
124      */
125     function sendValue(address payable recipient, uint256 amount) internal {
126         require(
127             address(this).balance >= amount,
128             "Address: insufficient balance"
129         );
130 
131         (bool success,) = recipient.call{value : amount}("");
132         require(
133             success,
134             "Address: unable to send value, recipient may have reverted"
135         );
136     }
137 
138     /**
139      * @dev Performs a Solidity function call using a low level `call`. A
140      * plain `call` is an unsafe replacement for a function call: use this
141      * function instead.
142      *
143      * If `target` reverts with a revert reason, it is bubbled up by this
144      * function (like regular Solidity function calls).
145      *
146      * Returns the raw returned data. To convert to the expected return value,
147      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
148      *
149      * Requirements:
150      *
151      * - `target` must be a contract.
152      * - calling `target` with `data` must not revert.
153      *
154      * _Available since v3.1._
155      */
156     function functionCall(address target, bytes memory data)
157     internal
158     returns (bytes memory)
159     {
160         return functionCall(target, data, "Address: low-level call failed");
161     }
162 
163     /**
164      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
165      * `errorMessage` as a fallback revert reason when `target` reverts.
166      *
167      * _Available since v3.1._
168      */
169     function functionCall(
170         address target,
171         bytes memory data,
172         string memory errorMessage
173     ) internal returns (bytes memory) {
174         return functionCallWithValue(target, data, 0, errorMessage);
175     }
176 
177     /**
178      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
179      * but also transferring `value` wei to `target`.
180      *
181      * Requirements:
182      *
183      * - the calling contract must have an ETH balance of at least `value`.
184      * - the called Solidity function must be `payable`.
185      *
186      * _Available since v3.1._
187      */
188     function functionCallWithValue(
189         address target,
190         bytes memory data,
191         uint256 value
192     ) internal returns (bytes memory) {
193         return
194         functionCallWithValue(
195             target,
196             data,
197             value,
198             "Address: low-level call with value failed"
199         );
200     }
201 
202     /**
203      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
204      * with `errorMessage` as a fallback revert reason when `target` reverts.
205      *
206      * _Available since v3.1._
207      */
208     function functionCallWithValue(
209         address target,
210         bytes memory data,
211         uint256 value,
212         string memory errorMessage
213     ) internal returns (bytes memory) {
214         require(
215             address(this).balance >= value,
216             "Address: insufficient balance for call"
217         );
218         require(isContract(target), "Address: call to non-contract");
219 
220         (bool success, bytes memory returndata) = target.call{value : value}(
221             data
222         );
223         return verifyCallResult(success, returndata, errorMessage);
224     }
225 
226     /**
227      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
228      * but performing a static call.
229      *
230      * _Available since v3.3._
231      */
232     function functionStaticCall(address target, bytes memory data)
233     internal
234     view
235     returns (bytes memory)
236     {
237         return
238         functionStaticCall(
239             target,
240             data,
241             "Address: low-level static call failed"
242         );
243     }
244 
245     /**
246      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
247      * but performing a static call.
248      *
249      * _Available since v3.3._
250      */
251     function functionStaticCall(
252         address target,
253         bytes memory data,
254         string memory errorMessage
255     ) internal view returns (bytes memory) {
256         require(isContract(target), "Address: static call to non-contract");
257 
258         (bool success, bytes memory returndata) = target.staticcall(data);
259         return verifyCallResult(success, returndata, errorMessage);
260     }
261 
262     /**
263      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
264      * but performing a delegate call.
265      *
266      * _Available since v3.4._
267      */
268     function functionDelegateCall(address target, bytes memory data)
269     internal
270     returns (bytes memory)
271     {
272         return
273         functionDelegateCall(
274             target,
275             data,
276             "Address: low-level delegate call failed"
277         );
278     }
279 
280     /**
281      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
282      * but performing a delegate call.
283      *
284      * _Available since v3.4._
285      */
286     function functionDelegateCall(
287         address target,
288         bytes memory data,
289         string memory errorMessage
290     ) internal returns (bytes memory) {
291         require(isContract(target), "Address: delegate call to non-contract");
292 
293         (bool success, bytes memory returndata) = target.delegatecall(data);
294         return verifyCallResult(success, returndata, errorMessage);
295     }
296 
297     /**
298      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
299      * revert reason using the provided one.
300      *
301      * _Available since v4.3._
302      */
303     function verifyCallResult(
304         bool success,
305         bytes memory returndata,
306         string memory errorMessage
307     ) internal pure returns (bytes memory) {
308         if (success) {
309             return returndata;
310         } else {
311             // Look for revert reason and bubble it up if present
312             if (returndata.length > 0) {
313                 // The easiest way to bubble the revert reason is using memory via assembly
314 
315                 assembly {
316                     let returndata_size := mload(returndata)
317                     revert(add(32, returndata), returndata_size)
318                 }
319             } else {
320                 revert(errorMessage);
321             }
322         }
323     }
324 }
325 
326 library SafeERC20 {
327     using SafeMath for uint256;
328     using Address for address;
329 
330     function safeTransfer(
331         IERC20 token,
332         address to,
333         uint256 value
334     ) internal {
335         _callOptionalReturn(
336             token,
337             abi.encodeWithSelector(token.transfer.selector, to, value)
338         );
339     }
340 
341     function safeTransferFrom(
342         IERC20 token,
343         address from,
344         address to,
345         uint256 value
346     ) internal {
347         _callOptionalReturn(
348             token,
349             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
350         );
351     }
352 
353     function safeIncreaseAllowance(
354         IERC20 token,
355         address spender,
356         uint256 value
357     ) internal {
358         uint256 newAllowance = token.allowance(address(this), spender).add(
359             value
360         );
361         _callOptionalReturn(
362             token,
363             abi.encodeWithSelector(
364                 token.approve.selector,
365                 spender,
366                 newAllowance
367             )
368         );
369     }
370 
371     function safeDecreaseAllowance(
372         IERC20 token,
373         address spender,
374         uint256 value
375     ) internal {
376         uint256 newAllowance = token.allowance(address(this), spender).sub(
377             value,
378             "SafeERC20: decreased allowance below zero"
379         );
380         _callOptionalReturn(
381             token,
382             abi.encodeWithSelector(
383                 token.approve.selector,
384                 spender,
385                 newAllowance
386             )
387         );
388     }
389 
390     function _callOptionalReturn(IERC20 token, bytes memory data) private {
391         bytes memory returndata = address(token).functionCall(
392             data,
393             "SafeERC20: low-level call failed"
394         );
395         if (returndata.length > 0) {
396             // Return data is optional
397             // solhint-disable-next-line max-line-length
398             require(
399                 abi.decode(returndata, (bool)),
400                 "SafeERC20: ERC20 operation did not succeed"
401             );
402         }
403     }
404 }
405 
406 interface IERC20 {
407     function decimals() external view returns (uint8);
408 
409     function totalSupply() external view returns (uint256);
410 
411     function balanceOf(address account) external view returns (uint256);
412 
413     function transfer(address recipient, uint256 amount)
414     external
415     returns (bool);
416 
417     function allowance(address owner, address spender)
418     external
419     view
420     returns (uint256);
421 
422     function approve(address spender, uint256 amount) external returns (bool);
423 
424     function transferFrom(
425         address sender,
426         address recipient,
427         uint256 amount
428     ) external returns (bool);
429 
430     function burnFrom(address account_, uint256 amount_) external;
431 
432     event Transfer(address indexed from, address indexed to, uint256 value);
433 
434     event Approval(
435         address indexed owner,
436         address indexed spender,
437         uint256 value
438     );
439 }
440 
441 interface IERC721A {
442     /**
443      * The caller must own the token or be an approved operator.
444      */
445     error ApprovalCallerNotOwnerNorApproved();
446 
447     /**
448      * The token does not exist.
449      */
450     error ApprovalQueryForNonexistentToken();
451 
452     /**
453      * The caller cannot approve to their own address.
454      */
455     error ApproveToCaller();
456 
457     /**
458      * Cannot query the balance for the zero address.
459      */
460     error BalanceQueryForZeroAddress();
461 
462     /**
463      * Cannot mint to the zero address.
464      */
465     error MintToZeroAddress();
466 
467     /**
468      * The quantity of tokens minted must be more than zero.
469      */
470     error MintZeroQuantity();
471 
472     /**
473      * The token does not exist.
474      */
475     error OwnerQueryForNonexistentToken();
476 
477     /**
478      * The caller must own the token or be an approved operator.
479      */
480     error TransferCallerNotOwnerNorApproved();
481 
482     /**
483      * The token must be owned by `from`.
484      */
485     error TransferFromIncorrectOwner();
486 
487     /**
488      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
489      */
490     error TransferToNonERC721ReceiverImplementer();
491 
492     /**
493      * Cannot transfer to the zero address.
494      */
495     error TransferToZeroAddress();
496 
497     /**
498      * The token does not exist.
499      */
500     error URIQueryForNonexistentToken();
501 
502     /**
503      * The `quantity` minted with ERC2309 exceeds the safety limit.
504      */
505     error MintERC2309QuantityExceedsLimit();
506 
507     /**
508      * The `extraData` cannot be set on an unintialized ownership slot.
509      */
510     error OwnershipNotInitializedForExtraData();
511 
512     struct TokenOwnership {
513         // The address of the owner.
514         address addr;
515         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
516         uint64 startTimestamp;
517         // Whether the token has been burned.
518         bool burned;
519         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
520         uint24 extraData;
521     }
522 
523     /**
524      * @dev Returns the total amount of tokens stored by the contract.
525      *
526      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
527      */
528     function totalSupply() external view returns (uint256);
529 
530     // ==============================
531     //            IERC165
532     // ==============================
533 
534     /**
535      * @dev Returns true if this contract implements the interface defined by
536      * `interfaceId`. See the corresponding
537      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
538      * to learn more about how these ids are created.
539      *
540      * This function call must use less than 30 000 gas.
541      */
542     function supportsInterface(bytes4 interfaceId) external view returns (bool);
543 
544     // ==============================
545     //            IERC721
546     // ==============================
547 
548     /**
549      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
550      */
551     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
552 
553     /**
554      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
555      */
556     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
557 
558     /**
559      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
560      */
561     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
562 
563     /**
564      * @dev Returns the number of tokens in ``owner``'s account.
565      */
566     function balanceOf(address owner) external view returns (uint256 balance);
567 
568     /**
569      * @dev Returns the owner of the `tokenId` token.
570      *
571      * Requirements:
572      *
573      * - `tokenId` must exist.
574      */
575     function ownerOf(uint256 tokenId) external view returns (address owner);
576 
577     /**
578      * @dev Safely transfers `tokenId` token from `from` to `to`.
579      *
580      * Requirements:
581      *
582      * - `from` cannot be the zero address.
583      * - `to` cannot be the zero address.
584      * - `tokenId` token must exist and be owned by `from`.
585      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
586      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
587      *
588      * Emits a {Transfer} event.
589      */
590     function safeTransferFrom(
591         address from,
592         address to,
593         uint256 tokenId,
594         bytes calldata data
595     ) external;
596 
597     /**
598      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
599      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
600      *
601      * Requirements:
602      *
603      * - `from` cannot be the zero address.
604      * - `to` cannot be the zero address.
605      * - `tokenId` token must exist and be owned by `from`.
606      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
607      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
608      *
609      * Emits a {Transfer} event.
610      */
611     function safeTransferFrom(
612         address from,
613         address to,
614         uint256 tokenId
615     ) external;
616 
617     /**
618      * @dev Transfers `tokenId` token from `from` to `to`.
619      *
620      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
621      *
622      * Requirements:
623      *
624      * - `from` cannot be the zero address.
625      * - `to` cannot be the zero address.
626      * - `tokenId` token must be owned by `from`.
627      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
628      *
629      * Emits a {Transfer} event.
630      */
631     function transferFrom(
632         address from,
633         address to,
634         uint256 tokenId
635     ) external;
636 
637     /**
638      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
639      * The approval is cleared when the token is transferred.
640      *
641      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
642      *
643      * Requirements:
644      *
645      * - The caller must own the token or be an approved operator.
646      * - `tokenId` must exist.
647      *
648      * Emits an {Approval} event.
649      */
650     function approve(address to, uint256 tokenId) external;
651 
652     /**
653      * @dev Approve or remove `operator` as an operator for the caller.
654      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
655      *
656      * Requirements:
657      *
658      * - The `operator` cannot be the caller.
659      *
660      * Emits an {ApprovalForAll} event.
661      */
662     function setApprovalForAll(address operator, bool _approved) external;
663 
664     /**
665      * @dev Returns the account approved for `tokenId` token.
666      *
667      * Requirements:
668      *
669      * - `tokenId` must exist.
670      */
671     function getApproved(uint256 tokenId) external view returns (address operator);
672 
673     /**
674      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
675      *
676      * See {setApprovalForAll}
677      */
678     function isApprovedForAll(address owner, address operator) external view returns (bool);
679 
680     // ==============================
681     //        IERC721Metadata
682     // ==============================
683 
684     /**
685      * @dev Returns the token collection name.
686      */
687     function name() external view returns (string memory);
688 
689     /**
690      * @dev Returns the token collection symbol.
691      */
692     function symbol() external view returns (string memory);
693 
694     /**
695      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
696      */
697     function tokenURI(uint256 tokenId) external view returns (string memory);
698 
699     // ==============================
700     //            IERC2309
701     // ==============================
702 
703     /**
704      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
705      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
706      */
707     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
708 }
709 
710 interface ERC721A__IERC721Receiver {
711     function onERC721Received(
712         address operator,
713         address from,
714         uint256 tokenId,
715         bytes calldata data
716     ) external returns (bytes4);
717 }
718 
719 contract ERC721A is IERC721A {
720     // Mask of an entry in packed address data.
721     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
722 
723     // The bit position of `numberMinted` in packed address data.
724     uint256 private constant BITPOS_NUMBER_MINTED = 64;
725 
726     // The bit position of `numberBurned` in packed address data.
727     uint256 private constant BITPOS_NUMBER_BURNED = 128;
728 
729     // The bit position of `aux` in packed address data.
730     uint256 private constant BITPOS_AUX = 192;
731 
732     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
733     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
734 
735     // The bit position of `startTimestamp` in packed ownership.
736     uint256 private constant BITPOS_START_TIMESTAMP = 160;
737 
738     // The bit mask of the `burned` bit in packed ownership.
739     uint256 private constant BITMASK_BURNED = 1 << 224;
740 
741     // The bit position of the `nextInitialized` bit in packed ownership.
742     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
743 
744     // The bit mask of the `nextInitialized` bit in packed ownership.
745     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
746 
747     // The bit position of `extraData` in packed ownership.
748     uint256 private constant BITPOS_EXTRA_DATA = 232;
749 
750     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
751     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
752 
753     // The mask of the lower 160 bits for addresses.
754     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
755 
756     // The maximum `quantity` that can be minted with `_mintERC2309`.
757     // This limit is to prevent overflows on the address data entries.
758     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
759     // is required to cause an overflow, which is unrealistic.
760     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
761 
762     // The tokenId of the next token to be minted.
763     uint256 private _currentIndex;
764 
765     // The number of tokens burned.
766     uint256 private _burnCounter;
767 
768     // Token name
769     string private _name;
770 
771     // Token symbol
772     string private _symbol;
773 
774     // Mapping from token ID to ownership details
775     // An empty struct value does not necessarily mean the token is unowned.
776     // See `_packedOwnershipOf` implementation for details.
777     //
778     // Bits Layout:
779     // - [0..159]   `addr`
780     // - [160..223] `startTimestamp`
781     // - [224]      `burned`
782     // - [225]      `nextInitialized`
783     // - [232..255] `extraData`
784     mapping(uint256 => uint256) private _packedOwnerships;
785 
786     // Mapping owner address to address data.
787     //
788     // Bits Layout:
789     // - [0..63]    `balance`
790     // - [64..127]  `numberMinted`
791     // - [128..191] `numberBurned`
792     // - [192..255] `aux`
793     mapping(address => uint256) private _packedAddressData;
794 
795     // Mapping from token ID to approved address.
796     mapping(uint256 => address) private _tokenApprovals;
797 
798     // Mapping from owner to operator approvals
799     mapping(address => mapping(address => bool)) private _operatorApprovals;
800 
801     constructor(string memory name_, string memory symbol_) {
802         _name = name_;
803         _symbol = symbol_;
804         _currentIndex = _startTokenId();
805     }
806 
807     /**
808      * @dev Returns the starting token ID.
809      * To change the starting token ID, please override this function.
810      */
811     function _startTokenId() internal view virtual returns (uint256) {
812         return 0;
813     }
814 
815     /**
816      * @dev Returns the next token ID to be minted.
817      */
818     function _nextTokenId() internal view returns (uint256) {
819         return _currentIndex;
820     }
821 
822     /**
823      * @dev Returns the total number of tokens in existence.
824      * Burned tokens will reduce the count.
825      * To get the total number of tokens minted, please see `_totalMinted`.
826      */
827     function totalSupply() public view override returns (uint256) {
828         // Counter underflow is impossible as _burnCounter cannot be incremented
829         // more than `_currentIndex - _startTokenId()` times.
830     unchecked {
831         return _currentIndex - _burnCounter - _startTokenId();
832     }
833     }
834 
835     /**
836      * @dev Returns the total amount of tokens minted in the contract.
837      */
838     function _totalMinted() internal view returns (uint256) {
839         // Counter underflow is impossible as _currentIndex does not decrement,
840         // and it is initialized to `_startTokenId()`
841     unchecked {
842         return _currentIndex - _startTokenId();
843     }
844     }
845 
846     /**
847      * @dev Returns the total number of tokens burned.
848      */
849     function _totalBurned() internal view returns (uint256) {
850         return _burnCounter;
851     }
852 
853     /**
854      * @dev See {IERC165-supportsInterface}.
855      */
856     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
857         // The interface IDs are constants representing the first 4 bytes of the XOR of
858         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
859         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
860         return
861         interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
862         interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
863         interfaceId == 0x5b5e139f;
864         // ERC165 interface ID for ERC721Metadata.
865     }
866 
867     /**
868      * @dev See {IERC721-balanceOf}.
869      */
870     function balanceOf(address owner) public view override returns (uint256) {
871         if (owner == address(0)) revert BalanceQueryForZeroAddress();
872         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
873     }
874 
875     /**
876      * Returns the number of tokens minted by `owner`.
877      */
878     function _numberMinted(address owner) internal view returns (uint256) {
879         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
880     }
881 
882     /**
883      * Returns the number of tokens burned by or on behalf of `owner`.
884      */
885     function _numberBurned(address owner) internal view returns (uint256) {
886         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
887     }
888 
889     /**
890      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
891      */
892     function _getAux(address owner) internal view returns (uint64) {
893         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
894     }
895 
896     /**
897      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
898      * If there are multiple variables, please pack them into a uint64.
899      */
900     function _setAux(address owner, uint64 aux) internal {
901         uint256 packed = _packedAddressData[owner];
902         uint256 auxCasted;
903         // Cast `aux` with assembly to avoid redundant masking.
904         assembly {
905             auxCasted := aux
906         }
907         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
908         _packedAddressData[owner] = packed;
909     }
910 
911     /**
912      * Returns the packed ownership data of `tokenId`.
913      */
914     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
915         uint256 curr = tokenId;
916 
917     unchecked {
918         if (_startTokenId() <= curr)
919             if (curr < _currentIndex) {
920                 uint256 packed = _packedOwnerships[curr];
921                 // If not burned.
922                 if (packed & BITMASK_BURNED == 0) {
923                     // Invariant:
924                     // There will always be an ownership that has an address and is not burned
925                     // before an ownership that does not have an address and is not burned.
926                     // Hence, curr will not underflow.
927                     //
928                     // We can directly compare the packed value.
929                     // If the address is zero, packed is zero.
930                     while (packed == 0) {
931                         packed = _packedOwnerships[--curr];
932                     }
933                     return packed;
934                 }
935             }
936     }
937         revert OwnerQueryForNonexistentToken();
938     }
939 
940     /**
941      * Returns the unpacked `TokenOwnership` struct from `packed`.
942      */
943     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
944         ownership.addr = address(uint160(packed));
945         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
946         ownership.burned = packed & BITMASK_BURNED != 0;
947         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
948     }
949 
950     /**
951      * Returns the unpacked `TokenOwnership` struct at `index`.
952      */
953     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
954         return _unpackedOwnership(_packedOwnerships[index]);
955     }
956 
957     /**
958      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
959      */
960     function _initializeOwnershipAt(uint256 index) internal {
961         if (_packedOwnerships[index] == 0) {
962             _packedOwnerships[index] = _packedOwnershipOf(index);
963         }
964     }
965 
966     /**
967      * Gas spent here starts off proportional to the maximum mint batch size.
968      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
969      */
970     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
971         return _unpackedOwnership(_packedOwnershipOf(tokenId));
972     }
973 
974     /**
975      * @dev Packs ownership data into a single uint256.
976      */
977     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
978         assembly {
979         // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
980             owner := and(owner, BITMASK_ADDRESS)
981         // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
982             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
983         }
984     }
985 
986     /**
987      * @dev See {IERC721-ownerOf}.
988      */
989     function ownerOf(uint256 tokenId) public view override returns (address) {
990         return address(uint160(_packedOwnershipOf(tokenId)));
991     }
992 
993     /**
994      * @dev See {IERC721Metadata-name}.
995      */
996     function name() public view virtual override returns (string memory) {
997         return _name;
998     }
999 
1000     /**
1001      * @dev See {IERC721Metadata-symbol}.
1002      */
1003     function symbol() public view virtual override returns (string memory) {
1004         return _symbol;
1005     }
1006 
1007     /**
1008      * @dev See {IERC721Metadata-tokenURI}.
1009      */
1010     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1011         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1012 
1013         string memory baseURI = _baseURI();
1014         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1015     }
1016 
1017     /**
1018      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1019      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1020      * by default, it can be overridden in child contracts.
1021      */
1022     function _baseURI() internal view virtual returns (string memory) {
1023         return '';
1024     }
1025 
1026     /**
1027      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1028      */
1029     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1030         // For branchless setting of the `nextInitialized` flag.
1031         assembly {
1032         // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
1033             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1034         }
1035     }
1036 
1037     /**
1038      * @dev See {IERC721-approve}.
1039      */
1040     function approve(address to, uint256 tokenId) public override {
1041         address owner = ownerOf(tokenId);
1042 
1043         if (_msgSenderERC721A() != owner)
1044             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1045                 revert ApprovalCallerNotOwnerNorApproved();
1046             }
1047 
1048         _tokenApprovals[tokenId] = to;
1049         emit Approval(owner, to, tokenId);
1050     }
1051 
1052     /**
1053      * @dev See {IERC721-getApproved}.
1054      */
1055     function getApproved(uint256 tokenId) public view override returns (address) {
1056         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1057 
1058         return _tokenApprovals[tokenId];
1059     }
1060 
1061     /**
1062      * @dev See {IERC721-setApprovalForAll}.
1063      */
1064     function setApprovalForAll(address operator, bool approved) public virtual override {
1065         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1066 
1067         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1068         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1069     }
1070 
1071     /**
1072      * @dev See {IERC721-isApprovedForAll}.
1073      */
1074     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1075         return _operatorApprovals[owner][operator];
1076     }
1077 
1078     /**
1079      * @dev See {IERC721-safeTransferFrom}.
1080      */
1081     function safeTransferFrom(
1082         address from,
1083         address to,
1084         uint256 tokenId
1085     ) public virtual override {
1086         safeTransferFrom(from, to, tokenId, '');
1087     }
1088 
1089     /**
1090      * @dev See {IERC721-safeTransferFrom}.
1091      */
1092     function safeTransferFrom(
1093         address from,
1094         address to,
1095         uint256 tokenId,
1096         bytes memory _data
1097     ) public virtual override {
1098         transferFrom(from, to, tokenId);
1099         if (to.code.length != 0)
1100             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1101                 revert TransferToNonERC721ReceiverImplementer();
1102             }
1103     }
1104 
1105     /**
1106      * @dev Returns whether `tokenId` exists.
1107      *
1108      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1109      *
1110      * Tokens start existing when they are minted (`_mint`),
1111      */
1112     function _exists(uint256 tokenId) internal view returns (bool) {
1113         return
1114         _startTokenId() <= tokenId &&
1115         tokenId < _currentIndex && // If within bounds,
1116         _packedOwnerships[tokenId] & BITMASK_BURNED == 0;
1117         // and not burned.
1118     }
1119 
1120     /**
1121      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1122      */
1123     function _safeMint(address to, uint256 quantity) internal {
1124         _safeMint(to, quantity, '');
1125     }
1126 
1127     /**
1128      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1129      *
1130      * Requirements:
1131      *
1132      * - If `to` refers to a smart contract, it must implement
1133      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1134      * - `quantity` must be greater than 0.
1135      *
1136      * See {_mint}.
1137      *
1138      * Emits a {Transfer} event for each mint.
1139      */
1140     function _safeMint(
1141         address to,
1142         uint256 quantity,
1143         bytes memory _data
1144     ) internal {
1145         _mint(to, quantity);
1146 
1147     unchecked {
1148         if (to.code.length != 0) {
1149             uint256 end = _currentIndex;
1150             uint256 index = end - quantity;
1151             do {
1152                 if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1153                     revert TransferToNonERC721ReceiverImplementer();
1154                 }
1155             }
1156             while (index < end);
1157             // Reentrancy protection.
1158             if (_currentIndex != end) revert();
1159         }
1160     }
1161     }
1162 
1163     /**
1164      * @dev Mints `quantity` tokens and transfers them to `to`.
1165      *
1166      * Requirements:
1167      *
1168      * - `to` cannot be the zero address.
1169      * - `quantity` must be greater than 0.
1170      *
1171      * Emits a {Transfer} event for each mint.
1172      */
1173     function _mint(address to, uint256 quantity) internal {
1174         uint256 startTokenId = _currentIndex;
1175         if (to == address(0)) revert MintToZeroAddress();
1176         if (quantity == 0) revert MintZeroQuantity();
1177 
1178         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1179 
1180         // Overflows are incredibly unrealistic.
1181         // `balance` and `numberMinted` have a maximum limit of 2**64.
1182         // `tokenId` has a maximum limit of 2**256.
1183     unchecked {
1184         // Updates:
1185         // - `balance += quantity`.
1186         // - `numberMinted += quantity`.
1187         //
1188         // We can directly add to the `balance` and `numberMinted`.
1189         _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1190 
1191         // Updates:
1192         // - `address` to the owner.
1193         // - `startTimestamp` to the timestamp of minting.
1194         // - `burned` to `false`.
1195         // - `nextInitialized` to `quantity == 1`.
1196         _packedOwnerships[startTokenId] = _packOwnershipData(
1197             to,
1198             _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1199         );
1200 
1201         uint256 tokenId = startTokenId;
1202         uint256 end = startTokenId + quantity;
1203         do {
1204             emit Transfer(address(0), to, tokenId++);
1205         }
1206         while (tokenId < end);
1207 
1208         _currentIndex = end;
1209     }
1210         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1211     }
1212 
1213     /**
1214      * @dev Mints `quantity` tokens and transfers them to `to`.
1215      *
1216      * This function is intended for efficient minting only during contract creation.
1217      *
1218      * It emits only one {ConsecutiveTransfer} as defined in
1219      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1220      * instead of a sequence of {Transfer} event(s).
1221      *
1222      * Calling this function outside of contract creation WILL make your contract
1223      * non-compliant with the ERC721 standard.
1224      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1225      * {ConsecutiveTransfer} event is only permissible during contract creation.
1226      *
1227      * Requirements:
1228      *
1229      * - `to` cannot be the zero address.
1230      * - `quantity` must be greater than 0.
1231      *
1232      * Emits a {ConsecutiveTransfer} event.
1233      */
1234     function _mintERC2309(address to, uint256 quantity) internal {
1235         uint256 startTokenId = _currentIndex;
1236         if (to == address(0)) revert MintToZeroAddress();
1237         if (quantity == 0) revert MintZeroQuantity();
1238         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1239 
1240         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1241 
1242         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1243     unchecked {
1244         // Updates:
1245         // - `balance += quantity`.
1246         // - `numberMinted += quantity`.
1247         //
1248         // We can directly add to the `balance` and `numberMinted`.
1249         _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1250 
1251         // Updates:
1252         // - `address` to the owner.
1253         // - `startTimestamp` to the timestamp of minting.
1254         // - `burned` to `false`.
1255         // - `nextInitialized` to `quantity == 1`.
1256         _packedOwnerships[startTokenId] = _packOwnershipData(
1257             to,
1258             _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1259         );
1260 
1261         emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1262 
1263         _currentIndex = startTokenId + quantity;
1264     }
1265         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1266     }
1267 
1268     /**
1269      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1270      */
1271     function _getApprovedAddress(uint256 tokenId)
1272     private
1273     view
1274     returns (uint256 approvedAddressSlot, address approvedAddress)
1275     {
1276         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1277         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1278         assembly {
1279         // Compute the slot.
1280             mstore(0x00, tokenId)
1281             mstore(0x20, tokenApprovalsPtr.slot)
1282             approvedAddressSlot := keccak256(0x00, 0x40)
1283         // Load the slot's value from storage.
1284             approvedAddress := sload(approvedAddressSlot)
1285         }
1286     }
1287 
1288     /**
1289      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1290      */
1291     function _isOwnerOrApproved(
1292         address approvedAddress,
1293         address from,
1294         address msgSender
1295     ) private pure returns (bool result) {
1296         assembly {
1297         // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1298             from := and(from, BITMASK_ADDRESS)
1299         // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1300             msgSender := and(msgSender, BITMASK_ADDRESS)
1301         // `msgSender == from || msgSender == approvedAddress`.
1302             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1303         }
1304     }
1305 
1306     /**
1307      * @dev Transfers `tokenId` from `from` to `to`.
1308      *
1309      * Requirements:
1310      *
1311      * - `to` cannot be the zero address.
1312      * - `tokenId` token must be owned by `from`.
1313      *
1314      * Emits a {Transfer} event.
1315      */
1316     function transferFrom(
1317         address from,
1318         address to,
1319         uint256 tokenId
1320     ) public virtual override {
1321         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1322 
1323         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1324 
1325         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1326 
1327         // The nested ifs save around 20+ gas over a compound boolean condition.
1328         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1329             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1330 
1331         if (to == address(0)) revert TransferToZeroAddress();
1332 
1333         _beforeTokenTransfers(from, to, tokenId, 1);
1334 
1335         // Clear approvals from the previous owner.
1336         assembly {
1337             if approvedAddress {
1338             // This is equivalent to `delete _tokenApprovals[tokenId]`.
1339                 sstore(approvedAddressSlot, 0)
1340             }
1341         }
1342 
1343         // Underflow of the sender's balance is impossible because we check for
1344         // ownership above and the recipient's balance can't realistically overflow.
1345         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1346     unchecked {
1347         // We can directly increment and decrement the balances.
1348         --_packedAddressData[from];
1349         // Updates: `balance -= 1`.
1350         ++_packedAddressData[to];
1351         // Updates: `balance += 1`.
1352 
1353         // Updates:
1354         // - `address` to the next owner.
1355         // - `startTimestamp` to the timestamp of transfering.
1356         // - `burned` to `false`.
1357         // - `nextInitialized` to `true`.
1358         _packedOwnerships[tokenId] = _packOwnershipData(
1359             to,
1360             BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1361         );
1362 
1363         // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1364         if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1365             uint256 nextTokenId = tokenId + 1;
1366             // If the next slot's address is zero and not burned (i.e. packed value is zero).
1367             if (_packedOwnerships[nextTokenId] == 0) {
1368                 // If the next slot is within bounds.
1369                 if (nextTokenId != _currentIndex) {
1370                     // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1371                     _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1372                 }
1373             }
1374         }
1375     }
1376 
1377         emit Transfer(from, to, tokenId);
1378         _afterTokenTransfers(from, to, tokenId, 1);
1379     }
1380 
1381     /**
1382      * @dev Equivalent to `_burn(tokenId, false)`.
1383      */
1384     function _burn(uint256 tokenId) internal virtual {
1385         _burn(tokenId, false);
1386     }
1387 
1388     /**
1389      * @dev Destroys `tokenId`.
1390      * The approval is cleared when the token is burned.
1391      *
1392      * Requirements:
1393      *
1394      * - `tokenId` must exist.
1395      *
1396      * Emits a {Transfer} event.
1397      */
1398     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1399         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1400 
1401         address from = address(uint160(prevOwnershipPacked));
1402 
1403         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1404 
1405         if (approvalCheck) {
1406             // The nested ifs save around 20+ gas over a compound boolean condition.
1407             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1408                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1409         }
1410 
1411         _beforeTokenTransfers(from, address(0), tokenId, 1);
1412 
1413         // Clear approvals from the previous owner.
1414         assembly {
1415             if approvedAddress {
1416             // This is equivalent to `delete _tokenApprovals[tokenId]`.
1417                 sstore(approvedAddressSlot, 0)
1418             }
1419         }
1420 
1421         // Underflow of the sender's balance is impossible because we check for
1422         // ownership above and the recipient's balance can't realistically overflow.
1423         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1424     unchecked {
1425         // Updates:
1426         // - `balance -= 1`.
1427         // - `numberBurned += 1`.
1428         //
1429         // We can directly decrement the balance, and increment the number burned.
1430         // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1431         _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1432 
1433         // Updates:
1434         // - `address` to the last owner.
1435         // - `startTimestamp` to the timestamp of burning.
1436         // - `burned` to `true`.
1437         // - `nextInitialized` to `true`.
1438         _packedOwnerships[tokenId] = _packOwnershipData(
1439             from,
1440             (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1441         );
1442 
1443         // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1444         if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1445             uint256 nextTokenId = tokenId + 1;
1446             // If the next slot's address is zero and not burned (i.e. packed value is zero).
1447             if (_packedOwnerships[nextTokenId] == 0) {
1448                 // If the next slot is within bounds.
1449                 if (nextTokenId != _currentIndex) {
1450                     // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1451                     _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1452                 }
1453             }
1454         }
1455     }
1456 
1457         emit Transfer(from, address(0), tokenId);
1458         _afterTokenTransfers(from, address(0), tokenId, 1);
1459 
1460         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1461     unchecked {
1462         _burnCounter++;
1463     }
1464     }
1465 
1466     /**
1467      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1468      *
1469      * @param from address representing the previous owner of the given token ID
1470      * @param to target address that will receive the tokens
1471      * @param tokenId uint256 ID of the token to be transferred
1472      * @param _data bytes optional data to send along with the call
1473      * @return bool whether the call correctly returned the expected magic value
1474      */
1475     function _checkContractOnERC721Received(
1476         address from,
1477         address to,
1478         uint256 tokenId,
1479         bytes memory _data
1480     ) private returns (bool) {
1481         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1482             bytes4 retval
1483         ) {
1484             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1485         } catch (bytes memory reason) {
1486             if (reason.length == 0) {
1487                 revert TransferToNonERC721ReceiverImplementer();
1488             } else {
1489                 assembly {
1490                     revert(add(32, reason), mload(reason))
1491                 }
1492             }
1493         }
1494     }
1495 
1496     /**
1497      * @dev Directly sets the extra data for the ownership data `index`.
1498      */
1499     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1500         uint256 packed = _packedOwnerships[index];
1501         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1502         uint256 extraDataCasted;
1503         // Cast `extraData` with assembly to avoid redundant masking.
1504         assembly {
1505             extraDataCasted := extraData
1506         }
1507         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1508         _packedOwnerships[index] = packed;
1509     }
1510 
1511     /**
1512      * @dev Returns the next extra data for the packed ownership data.
1513      * The returned result is shifted into position.
1514      */
1515     function _nextExtraData(
1516         address from,
1517         address to,
1518         uint256 prevOwnershipPacked
1519     ) private view returns (uint256) {
1520         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1521         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1522     }
1523 
1524     /**
1525      * @dev Called during each token transfer to set the 24bit `extraData` field.
1526      * Intended to be overridden by the cosumer contract.
1527      *
1528      * `previousExtraData` - the value of `extraData` before transfer.
1529      *
1530      * Calling conditions:
1531      *
1532      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1533      * transferred to `to`.
1534      * - When `from` is zero, `tokenId` will be minted for `to`.
1535      * - When `to` is zero, `tokenId` will be burned by `from`.
1536      * - `from` and `to` are never both zero.
1537      */
1538     function _extraData(
1539         address from,
1540         address to,
1541         uint24 previousExtraData
1542     ) internal view virtual returns (uint24) {}
1543 
1544     /**
1545      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1546      * This includes minting.
1547      * And also called before burning one token.
1548      *
1549      * startTokenId - the first token id to be transferred
1550      * quantity - the amount to be transferred
1551      *
1552      * Calling conditions:
1553      *
1554      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1555      * transferred to `to`.
1556      * - When `from` is zero, `tokenId` will be minted for `to`.
1557      * - When `to` is zero, `tokenId` will be burned by `from`.
1558      * - `from` and `to` are never both zero.
1559      */
1560     function _beforeTokenTransfers(
1561         address from,
1562         address to,
1563         uint256 startTokenId,
1564         uint256 quantity
1565     ) internal virtual {}
1566 
1567     /**
1568      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1569      * This includes minting.
1570      * And also called after one token has been burned.
1571      *
1572      * startTokenId - the first token id to be transferred
1573      * quantity - the amount to be transferred
1574      *
1575      * Calling conditions:
1576      *
1577      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1578      * transferred to `to`.
1579      * - When `from` is zero, `tokenId` has been minted for `to`.
1580      * - When `to` is zero, `tokenId` has been burned by `from`.
1581      * - `from` and `to` are never both zero.
1582      */
1583     function _afterTokenTransfers(
1584         address from,
1585         address to,
1586         uint256 startTokenId,
1587         uint256 quantity
1588     ) internal virtual {}
1589 
1590     /**
1591      * @dev Returns the message sender (defaults to `msg.sender`).
1592      *
1593      * If you are writing GSN compatible contracts, you need to override this function.
1594      */
1595     function _msgSenderERC721A() internal view virtual returns (address) {
1596         return msg.sender;
1597     }
1598 
1599     /**
1600      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1601      */
1602     function _toString(uint256 value) internal pure returns (string memory ptr) {
1603         assembly {
1604         // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1605         // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1606         // We will need 1 32-byte word to store the length,
1607         // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1608             ptr := add(mload(0x40), 128)
1609         // Update the free memory pointer to allocate.
1610             mstore(0x40, ptr)
1611 
1612         // Cache the end of the memory to calculate the length later.
1613             let end := ptr
1614 
1615         // We write the string from the rightmost digit to the leftmost digit.
1616         // The following is essentially a do-while loop that also handles the zero case.
1617         // Costs a bit more than early returning for the zero case,
1618         // but cheaper in terms of deployment and overall runtime costs.
1619             for {
1620             // Initialize and perform the first pass without check.
1621                 let temp := value
1622             // Move the pointer 1 byte leftwards to point to an empty character slot.
1623                 ptr := sub(ptr, 1)
1624             // Write the character to the pointer. 48 is the ASCII index of '0'.
1625                 mstore8(ptr, add(48, mod(temp, 10)))
1626                 temp := div(temp, 10)
1627             } temp {
1628             // Keep dividing `temp` until zero.
1629                 temp := div(temp, 10)
1630             } {
1631             // Body of the for loop.
1632                 ptr := sub(ptr, 1)
1633                 mstore8(ptr, add(48, mod(temp, 10)))
1634             }
1635 
1636             let length := sub(end, ptr)
1637         // Move the pointer 32 bytes leftwards to make room for the length.
1638             ptr := sub(ptr, 32)
1639         // Store the length.
1640             mstore(ptr, length)
1641         }
1642     }
1643 }
1644 
1645 interface IOwnable {
1646     function manager() external view returns (address);
1647 
1648     function renounceManagement() external;
1649 
1650     function pushManagement(address newOwner_) external;
1651 
1652     function pullManagement() external;
1653 }
1654 
1655 contract Ownable is IOwnable {
1656     address internal _owner;
1657     address internal _newOwner;
1658 
1659     event OwnershipPushed(
1660         address indexed previousOwner,
1661         address indexed newOwner
1662     );
1663     event OwnershipPulled(
1664         address indexed previousOwner,
1665         address indexed newOwner
1666     );
1667 
1668     constructor() {
1669         _owner = msg.sender;
1670         emit OwnershipPushed(address(0), _owner);
1671     }
1672 
1673     function manager() public view override returns (address) {
1674         return _owner;
1675     }
1676 
1677     modifier onlyManager() {
1678         require(_owner == msg.sender, "Ownable: caller is not the owner");
1679         _;
1680     }
1681 
1682     function renounceManagement() public virtual override onlyManager {
1683         emit OwnershipPushed(_owner, address(0));
1684         _owner = address(0);
1685     }
1686 
1687     function pushManagement(address newOwner_)
1688     public
1689     virtual
1690     override
1691     onlyManager
1692     {
1693         require(
1694             newOwner_ != address(0),
1695             "Ownable: new owner is the zero address"
1696         );
1697         emit OwnershipPushed(_owner, newOwner_);
1698         _newOwner = newOwner_;
1699     }
1700 
1701     function pullManagement() public virtual override {
1702         require(msg.sender == _newOwner, "Ownable: must be new owner to pull");
1703         emit OwnershipPulled(_owner, _newOwner);
1704         _owner = _newOwner;
1705     }
1706 }
1707 
1708 contract TheCryptoBums is Ownable, ERC721A {
1709 
1710 
1711     uint256 public startTime = 0;
1712     uint256 public constant MAX_TOKENS = 10000;
1713     uint256 public freeAmount = 8000;
1714     uint256 public price = 5000000 gwei;
1715     string public baseURI = "https://cryptobums.mypinata.cloud/ipfs/QmPuJq14hT7nv8Qsoe5KvfDkdmNx9qHMJL5fKe7bSdxiFs/";
1716     string public hideURI = "https://cryptobums.mypinata.cloud/ipfs/QmVeCw5mmQKgWYWGitEBAhmbaw9DFcSdiFSww49XgwQf1X";
1717 
1718 
1719     uint256 public minted;
1720     mapping(address => uint256) public mintCount;
1721 
1722 
1723     bool public hideImages = true;
1724     bool private _reentrant = false;
1725 
1726     constructor(uint256 _startTime) ERC721A("The CryptoBums", "CRB") {
1727         startTime = _startTime;
1728     }
1729 
1730     modifier nonReentrant() {
1731         require(!_reentrant, "No reentrancy");
1732         _reentrant = true;
1733         _;
1734         _reentrant = false;
1735     }
1736 
1737     function mint(uint256 quantity) external payable nonReentrant {
1738         // `_mint`'s second argument now takes in a `quantity`, not a `tokenId`.
1739         require(
1740             mintCount[msg.sender] + quantity <= 5,
1741             "Each address can mint 5"
1742         );
1743         require(startTime < block.timestamp, "not Start");
1744         require(tx.origin == msg.sender, "Only EOA");
1745         require(minted + quantity <= MAX_TOKENS, "total limit");
1746 
1747         uint256 totalPrice = 0;
1748         minted += quantity;
1749         if (minted > freeAmount) {
1750             uint256 exceed = minted - freeAmount;
1751             totalPrice = (exceed >= quantity ? quantity : exceed) * price;
1752         }
1753         require(msg.value == totalPrice, "eth no enough");
1754         _mint(msg.sender, quantity);
1755         mintCount[msg.sender] += quantity;
1756     }
1757 
1758 
1759     function _baseURI() override internal view virtual returns (string memory) {
1760         return baseURI;
1761     }
1762 
1763     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1764         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1765 
1766         if (hideImages) {
1767             return hideURI;
1768         }
1769         return bytes(baseURI).length != 0 ? string(abi.encodePacked(_baseURI(), _toString(tokenId))) : '';
1770     }
1771 
1772     function setBaseURI(string memory _base) public onlyManager {
1773         baseURI = _base;
1774     }
1775 
1776     function setHideURI(string memory _hideURI) public onlyManager {
1777         hideURI = _hideURI;
1778     }
1779 
1780     function setHide(bool _hide) external onlyManager {
1781         hideImages = _hide;
1782     }
1783 
1784     function setPrice(uint256 _price) external onlyManager {
1785         price = _price;
1786     }
1787 
1788     function setStartTime(uint256 _startTime) external onlyManager {
1789         startTime = _startTime;
1790     }
1791 
1792     function withdraw(address payable recipient) external onlyManager {
1793         (bool success,) = recipient.call{value : address(this).balance}("");
1794         require(
1795             success,
1796             "Address: unable to send value, recipient may have reverted"
1797         );
1798     }
1799 
1800 }