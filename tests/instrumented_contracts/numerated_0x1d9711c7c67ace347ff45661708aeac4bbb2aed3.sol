1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev String operations.
8  */
9 library Strings {
10     bytes16 private constant alphabet = '0123456789abcdef';
11 
12     /**
13      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
14      */
15     function toString(uint256 value) internal pure returns (string memory) {
16         // Inspired by OraclizeAPI's implementation - MIT licence
17         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
18 
19         if (value == 0) {
20             return '0';
21         }
22         uint256 temp = value;
23         uint256 digits;
24         while (temp != 0) {
25             digits++;
26             temp /= 10;
27         }
28         bytes memory buffer = new bytes(digits);
29         while (value != 0) {
30             digits -= 1;
31             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
32             value /= 10;
33         }
34         return string(buffer);
35     }
36 
37     function toString16(uint16 value) internal pure returns (string memory) {
38         // Inspired by OraclizeAPI's implementation - MIT licence
39         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
40 
41         if (value == 0) {
42             return '0';
43         }
44         uint256 temp = value;
45         uint256 digits;
46         while (temp != 0) {
47             digits++;
48             temp /= 10;
49         }
50         bytes memory buffer = new bytes(digits);
51         while (value != 0) {
52             digits -= 1;
53             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
54             value /= 10;
55         }
56         return string(buffer);
57     }
58 }
59 
60 /// @author Brecht Devos - <brecht@loopring.org>
61 /// @notice Provides functions for encoding/decoding base64
62 library Base64 {
63     string internal constant TABLE_ENCODE =
64         'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
65 
66     function encode(bytes memory data) internal pure returns (string memory) {
67         if (data.length == 0) return '';
68 
69         // load the table into memory
70         string memory table = TABLE_ENCODE;
71 
72         // multiply by 4/3 rounded up
73         uint256 encodedLen = 4 * ((data.length + 2) / 3);
74 
75         // add some extra buffer at the end required for the writing
76         string memory result = new string(encodedLen + 32);
77 
78         assembly {
79             // set the actual output length
80             mstore(result, encodedLen)
81 
82             // prepare the lookup table
83             let tablePtr := add(table, 1)
84 
85             // input ptr
86             let dataPtr := data
87             let endPtr := add(dataPtr, mload(data))
88 
89             // result ptr, jump over length
90             let resultPtr := add(result, 32)
91 
92             // run over the input, 3 bytes at a time
93             for {
94 
95             } lt(dataPtr, endPtr) {
96 
97             } {
98                 // read 3 bytes
99                 dataPtr := add(dataPtr, 3)
100                 let input := mload(dataPtr)
101 
102                 // write 4 characters
103                 mstore8(
104                     resultPtr,
105                     mload(add(tablePtr, and(shr(18, input), 0x3F)))
106                 )
107                 resultPtr := add(resultPtr, 1)
108                 mstore8(
109                     resultPtr,
110                     mload(add(tablePtr, and(shr(12, input), 0x3F)))
111                 )
112                 resultPtr := add(resultPtr, 1)
113                 mstore8(
114                     resultPtr,
115                     mload(add(tablePtr, and(shr(6, input), 0x3F)))
116                 )
117                 resultPtr := add(resultPtr, 1)
118                 mstore8(resultPtr, mload(add(tablePtr, and(input, 0x3F))))
119                 resultPtr := add(resultPtr, 1)
120             }
121 
122             // padding with '='
123             switch mod(mload(data), 3)
124             case 1 {
125                 mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
126             }
127             case 2 {
128                 mstore(sub(resultPtr, 1), shl(248, 0x3d))
129             }
130         }
131 
132         return result;
133     }
134 }
135 
136 /**
137  * @dev Provides information about the current execution context, including the
138  * sender of the transaction and its data. While these are generally available
139  * via msg.sender and msg.data, they should not be accessed in such a direct
140  * manner, since when dealing with meta-transactions the account sending and
141  * paying for execution may not be the actual sender (as far as an application
142  * is concerned).
143  *
144  * This contract is only required for intermediate, library-like contracts.
145  */
146 abstract contract Context {
147     function _msgSender() internal view virtual returns (address) {
148         return msg.sender;
149     }
150 
151     function _msgData() internal view virtual returns (bytes calldata) {
152         return msg.data;
153     }
154 }
155 
156 contract AccessControl {
157     address public creatorAddress;
158 
159     modifier onlyCREATOR() {
160         require(msg.sender == creatorAddress, 'You are not the creator');
161         _;
162     }
163 
164     // Constructor
165     constructor() {
166         creatorAddress = msg.sender;
167     }
168 
169     function changeOwner(address payable _newOwner) public onlyCREATOR {
170         creatorAddress = _newOwner;
171     }
172 }
173 
174 /**
175  * @dev Collection of functions related to the address type
176  */
177 library Address {
178     /**
179      * @dev Returns true if `account` is a contract.
180      *
181      * [IMPORTANT]
182      * ====
183      * It is unsafe to assume that an address for which this function returns
184      * false is an externally-owned account (EOA) and not a contract.
185      *
186      * Among others, `isContract` will return false for the following
187      * types of addresses:
188      *
189      *  - an externally-owned account
190      *  - a contract in construction
191      *  - an address where a contract will be created
192      *  - an address where a contract lived, but was destroyed
193      * ====
194      *
195      * [IMPORTANT]
196      * ====
197      * You shouldn't rely on `isContract` to protect against flash loan attacks!
198      *
199      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
200      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
201      * constructor.
202      * ====
203      */
204     function isContract(address account) internal view returns (bool) {
205         // This method relies on extcodesize/address.code.length, which returns 0
206         // for contracts in construction, since the code is only stored at the end
207         // of the constructor execution.
208 
209         return account.code.length > 0;
210     }
211 
212     /**
213      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
214      * `recipient`, forwarding all available gas and reverting on errors.
215      *
216      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
217      * of certain opcodes, possibly making contracts go over the 2300 gas limit
218      * imposed by `transfer`, making them unable to receive funds via
219      * `transfer`. {sendValue} removes this limitation.
220      *
221      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
222      *
223      * IMPORTANT: because control is transferred to `recipient`, care must be
224      * taken to not create reentrancy vulnerabilities. Consider using
225      * {ReentrancyGuard} or the
226      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
227      */
228     function sendValue(address payable recipient, uint256 amount) internal {
229         require(
230             address(this).balance >= amount,
231             'Address: insufficient balance'
232         );
233 
234         (bool success, ) = recipient.call{value: amount}('');
235         require(
236             success,
237             'Address: unable to send value, recipient may have reverted'
238         );
239     }
240 
241     /**
242      * @dev Performs a Solidity function call using a low level `call`. A
243      * plain `call` is an unsafe replacement for a function call: use this
244      * function instead.
245      *
246      * If `target` reverts with a revert reason, it is bubbled up by this
247      * function (like regular Solidity function calls).
248      *
249      * Returns the raw returned data. To convert to the expected return value,
250      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
251      *
252      * Requirements:
253      *
254      * - `target` must be a contract.
255      * - calling `target` with `data` must not revert.
256      *
257      * _Available since v3.1._
258      */
259     function functionCall(address target, bytes memory data)
260         internal
261         returns (bytes memory)
262     {
263         return functionCall(target, data, 'Address: low-level call failed');
264     }
265 
266     /**
267      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
268      * `errorMessage` as a fallback revert reason when `target` reverts.
269      *
270      * _Available since v3.1._
271      */
272     function functionCall(
273         address target,
274         bytes memory data,
275         string memory errorMessage
276     ) internal returns (bytes memory) {
277         return functionCallWithValue(target, data, 0, errorMessage);
278     }
279 
280     /**
281      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
282      * but also transferring `value` wei to `target`.
283      *
284      * Requirements:
285      *
286      * - the calling contract must have an ETH balance of at least `value`.
287      * - the called Solidity function must be `payable`.
288      *
289      * _Available since v3.1._
290      */
291     function functionCallWithValue(
292         address target,
293         bytes memory data,
294         uint256 value
295     ) internal returns (bytes memory) {
296         return
297             functionCallWithValue(
298                 target,
299                 data,
300                 value,
301                 'Address: low-level call with value failed'
302             );
303     }
304 
305     /**
306      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
307      * with `errorMessage` as a fallback revert reason when `target` reverts.
308      *
309      * _Available since v3.1._
310      */
311     function functionCallWithValue(
312         address target,
313         bytes memory data,
314         uint256 value,
315         string memory errorMessage
316     ) internal returns (bytes memory) {
317         require(
318             address(this).balance >= value,
319             'Address: insufficient balance for call'
320         );
321         require(isContract(target), 'Address: call to non-contract');
322 
323         (bool success, bytes memory returndata) = target.call{value: value}(
324             data
325         );
326         return verifyCallResult(success, returndata, errorMessage);
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
331      * but performing a static call.
332      *
333      * _Available since v3.3._
334      */
335     function functionStaticCall(address target, bytes memory data)
336         internal
337         view
338         returns (bytes memory)
339     {
340         return
341             functionStaticCall(
342                 target,
343                 data,
344                 'Address: low-level static call failed'
345             );
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
350      * but performing a static call.
351      *
352      * _Available since v3.3._
353      */
354     function functionStaticCall(
355         address target,
356         bytes memory data,
357         string memory errorMessage
358     ) internal view returns (bytes memory) {
359         require(isContract(target), 'Address: static call to non-contract');
360 
361         (bool success, bytes memory returndata) = target.staticcall(data);
362         return verifyCallResult(success, returndata, errorMessage);
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
367      * but performing a delegate call.
368      *
369      * _Available since v3.4._
370      */
371     function functionDelegateCall(address target, bytes memory data)
372         internal
373         returns (bytes memory)
374     {
375         return
376             functionDelegateCall(
377                 target,
378                 data,
379                 'Address: low-level delegate call failed'
380             );
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
385      * but performing a delegate call.
386      *
387      * _Available since v3.4._
388      */
389     function functionDelegateCall(
390         address target,
391         bytes memory data,
392         string memory errorMessage
393     ) internal returns (bytes memory) {
394         require(isContract(target), 'Address: delegate call to non-contract');
395 
396         (bool success, bytes memory returndata) = target.delegatecall(data);
397         return verifyCallResult(success, returndata, errorMessage);
398     }
399 
400     /**
401      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
402      * revert reason using the provided one.
403      *
404      * _Available since v4.3._
405      */
406     function verifyCallResult(
407         bool success,
408         bytes memory returndata,
409         string memory errorMessage
410     ) internal pure returns (bytes memory) {
411         if (success) {
412             return returndata;
413         } else {
414             // Look for revert reason and bubble it up if present
415             if (returndata.length > 0) {
416                 // The easiest way to bubble the revert reason is using memory via assembly
417 
418                 assembly {
419                     let returndata_size := mload(returndata)
420                     revert(add(32, returndata), returndata_size)
421                 }
422             } else {
423                 revert(errorMessage);
424             }
425         }
426     }
427 }
428 
429 /**
430  * @dev Interface of the ERC165 standard, as defined in the
431  * https://eips.ethereum.org/EIPS/eip-165[EIP].
432  *
433  * Implementers can declare support of contract interfaces, which can then be
434  * queried by others ({ERC165Checker}).
435  *
436  * For an implementation, see {ERC165}.
437  */
438 interface IERC165 {
439     /**
440      * @dev Returns true if this contract implements the interface defined by
441      * `interfaceId`. See the corresponding
442      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
443      * to learn more about how these ids are created.
444      *
445      * This function call must use less than 30 000 gas.
446      */
447     function supportsInterface(bytes4 interfaceId) external view returns (bool);
448 }
449 
450 /**
451  * @dev Implementation of the {IERC165} interface.
452  *
453  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
454  * for the additional interface id that will be supported. For example:
455  *
456  * ```solidity
457  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
458  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
459  * }
460  * ```
461  *
462  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
463  */
464 abstract contract ERC165 is IERC165 {
465     /**
466      * @dev See {IERC165-supportsInterface}.
467      */
468     function supportsInterface(bytes4 interfaceId)
469         public
470         view
471         virtual
472         override
473         returns (bool)
474     {
475         return interfaceId == type(IERC165).interfaceId;
476     }
477 }
478 
479 /**
480  * @dev Required interface of an ERC721 compliant contract.
481  */
482 interface IERC721 is IERC165 {
483     /**
484      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
485      */
486     event Transfer(
487         address indexed from,
488         address indexed to,
489         uint256 indexed tokenId
490     );
491 
492     /**
493      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
494      */
495     event Approval(
496         address indexed owner,
497         address indexed approved,
498         uint256 indexed tokenId
499     );
500 
501     /**
502      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
503      */
504     event ApprovalForAll(
505         address indexed owner,
506         address indexed operator,
507         bool approved
508     );
509 
510     /**
511      * @dev Returns the number of tokens in ``owner``'s account.
512      */
513     function balanceOf(address owner) external view returns (uint256 balance);
514 
515     /**
516      * @dev Returns the owner of the `tokenId` token.
517      *
518      * Requirements:
519      *
520      * - `tokenId` must exist.
521      */
522     function ownerOf(uint256 tokenId) external view returns (address owner);
523 
524     /**
525      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
526      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
527      *
528      * Requirements:
529      *
530      * - `from` cannot be the zero address.
531      * - `to` cannot be the zero address.
532      * - `tokenId` token must exist and be owned by `from`.
533      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
534      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
535      *
536      * Emits a {Transfer} event.
537      */
538     function safeTransferFrom(
539         address from,
540         address to,
541         uint256 tokenId
542     ) external;
543 
544     /**
545      * @dev Transfers `tokenId` token from `from` to `to`.
546      *
547      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
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
580      * @dev Returns the account approved for `tokenId` token.
581      *
582      * Requirements:
583      *
584      * - `tokenId` must exist.
585      */
586     function getApproved(uint256 tokenId)
587         external
588         view
589         returns (address operator);
590 
591     /**
592      * @dev Approve or remove `operator` as an operator for the caller.
593      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
594      *
595      * Requirements:
596      *
597      * - The `operator` cannot be the caller.
598      *
599      * Emits an {ApprovalForAll} event.
600      */
601     function setApprovalForAll(address operator, bool _approved) external;
602 
603     /**
604      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
605      *
606      * See {setApprovalForAll}
607      */
608     function isApprovedForAll(address owner, address operator)
609         external
610         view
611         returns (bool);
612 
613     /**
614      * @dev Safely transfers `tokenId` token from `from` to `to`.
615      *
616      * Requirements:
617      *
618      * - `from` cannot be the zero address.
619      * - `to` cannot be the zero address.
620      * - `tokenId` token must exist and be owned by `from`.
621      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
622      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
623      *
624      * Emits a {Transfer} event.
625      */
626     function safeTransferFrom(
627         address from,
628         address to,
629         uint256 tokenId,
630         bytes calldata data
631     ) external;
632 }
633 
634 /**
635  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
636  * @dev See https://eips.ethereum.org/EIPS/eip-721
637  */
638 interface IERC721Metadata is IERC721 {
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
655 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
656 
657 /**
658  * @title ERC721 token receiver interface
659  * @dev Interface for any contract that wants to support safeTransfers
660  * from ERC721 asset contracts.
661  */
662 interface IERC721Receiver {
663     /**
664      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
665      * by `operator` from `from`, this function is called.
666      *
667      * It must return its Solidity selector to confirm the token transfer.
668      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
669      *
670      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
671      */
672     function onERC721Received(
673         address operator,
674         address from,
675         uint256 tokenId,
676         bytes calldata data
677     ) external returns (bytes4);
678 }
679 
680 contract Enums {
681     enum ResultCode {
682         SUCCESS,
683         ERROR_CLASS_NOT_FOUND,
684         ERROR_LOW_BALANCE,
685         ERROR_SEND_FAIL,
686         ERROR_NOT_OWNER,
687         ERROR_NOT_ENOUGH_MONEY,
688         ERROR_INVALID_AMOUNT
689     }
690 }
691 
692 abstract contract IAngelCardData is AccessControl, Enums {
693     // write
694     // mint function
695     function setAngel(
696         uint8 _angelCardSeriesId,
697         address _owner,
698         uint256 _price,
699         uint16 _battlePower
700     ) external virtual returns (uint64);
701 
702     function transferAngel(
703         address _from,
704         address _to,
705         uint64 _angelId
706     ) public virtual returns (ResultCode);
707 
708     // read
709     function getAngel(uint64 _angelId)
710         public
711         virtual
712         returns (
713             uint64 angelId,
714             uint8 angelCardSeriesId,
715             uint16 battlePower,
716             uint8 aura,
717             uint16 experience,
718             uint256 price,
719             uint64 createdTime,
720             uint64 lastBattleTime,
721             uint64 lastVsBattleTime,
722             uint16 lastBattleResult,
723             address owner
724         );
725 
726     function getAngelLockStatus(uint64 _angelId) public virtual returns (bool);
727 
728     function ownerAngelTransfer(address _to, uint64 _angelId) public virtual;
729 }
730 
731 abstract contract IPetCardData is AccessControl, Enums {
732     // write
733     function setPet(
734         uint8 _petCardSeriesId,
735         address _owner,
736         string memory _name,
737         uint8 _luck,
738         uint16 _auraRed,
739         uint16 _auraYellow,
740         uint16 _auraBlue
741     ) external virtual returns (uint64);
742 
743     function transferPet(
744         address _from,
745         address _to,
746         uint64 _petId
747     ) public virtual returns (ResultCode);
748 
749     // read
750     function getPet(uint256 _petId)
751         public
752         virtual
753         returns (
754             uint256 petId,
755             uint8 petCardSeriesId,
756             string memory name,
757             uint8 luck,
758             uint16 auraRed,
759             uint16 auraBlue,
760             uint16 auraYellow,
761             uint64 lastTrainingTime,
762             uint64 lastBreedingTime,
763             address owner
764         );
765 
766     function getTotalPets() public virtual returns (uint256);
767 }
768 
769 abstract contract IAccessoryData is AccessControl, Enums {
770     // write
771     function setAccessory(uint8 _AccessorySeriesId, address _owner)
772         external
773         virtual
774         returns (uint64);
775 
776     function transferAccessory(
777         address _from,
778         address _to,
779         uint64 __accessoryId
780     ) public virtual returns (ResultCode);
781 
782     // read
783     function getAccessory(uint256 _accessoryId)
784         public
785         virtual
786         returns (
787             uint256 accessoryID,
788             uint8 AccessorySeriesID,
789             address owner
790         );
791 
792     function getAccessoryLockStatus(uint64 _acessoryId)
793         public
794         virtual
795         returns (bool);
796 
797     function ownerAccessoryTransfer(address _to, uint64 __accessoryId)
798         public
799         virtual;
800 
801     function getTotalAccessories() public virtual returns (uint256);
802 }
803 
804 /**
805  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
806  * the Metadata extension, but not including the Enumerable extension, which is available separately as
807  * {ERC721Enumerable}.
808  */
809 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, AccessControl {
810     using Address for address;
811     using Strings for uint256;
812     using Strings for uint64;
813     using Strings for uint16;
814     using Strings for uint8;
815 
816     // Token name
817     string private _name = 'Angel Battles Historical Wrapper';
818 
819     // Token symbol
820     string private _symbol = 'ABT';
821 
822     // Mapping from token ID to owner address
823     mapping(uint256 => address) private _owners;
824 
825     // Mapping owner address to token count
826     mapping(address => uint256) private _balances;
827 
828     // Mapping from token ID to approved address
829     mapping(uint256 => address) private _tokenApprovals;
830 
831     // Mapping from owner to operator approvals
832     mapping(address => mapping(address => bool)) private _operatorApprovals;
833 
834     uint256 public totalSupply = 0;
835 
836     //Mapping or which IDs each address owns
837     mapping(address => uint256[]) public ownerABTokenCollection;
838 
839     //current and max numbers of issued tokens for each series
840     uint32[100] public currentTokenNumbers;
841 
842     string public ipfsGateway = 'https://ipfs.io/ipfs/';
843 
844     address public angelCardDataAddress =
845         0x6D2E76213615925c5fc436565B5ee788Ee0E86DC;
846 
847     address public petCardDataAddress =
848         0xB340686da996b8B3d486b4D27E38E38500A9E926;
849 
850     address public accessoryCardDataAddress =
851         0x466c44812835f57b736ef9F63582b8a6693A14D0;
852 
853     bool public mintingPaused = false;
854 
855     address payable public paymentSplitter =
856         payable(0x740480cfF511c5E4407cea6dCf8163E678513001);
857 
858     // Initial owner, angelbattles.eth
859     address public owner = payable(0x20886Ba6fD8731ed974ba00108F043fC9006e1f8);
860 
861     //  Main data structure for each token
862     struct ABCard {
863         uint256 tokenId;
864         uint8 cardSeriesId;
865         //This is 0 to 23 for angels, 24 to 42 for pets, 43 to 60 for accessories
866 
867         uint16 power;
868         //This number is luck for pets and battlepower for angels
869         uint16 auraRed;
870         uint16 auraYellow;
871         uint16 auraBlue;
872         string name;
873         uint16 experience;
874         uint64 lastBattleTime;
875         uint16 oldId; // the id of the wrapped card
876         uint64 createdTime;
877     }
878 
879     struct AuraMapping {
880         uint16 auraRed;
881         uint16 auraYellow;
882         uint16 auraBlue;
883     }
884 
885     //Main mapping storing an ABCard for each token ID
886     mapping(uint256 => ABCard) public ABTokenCollection;
887 
888     string[] cardNames = [
889         // Angels
890         'Berakiel',
891         'Zadkiel',
892         'Lucifer',
893         'Michael',
894         'Arel',
895         'Raguel',
896         'Lilith',
897         'Furlac',
898         'Azazel',
899         'Eleleth',
900         'Verin',
901         'Ziwa',
902         'Cimeriel',
903         'Numinel',
904         'Bat Gol',
905         'Gabriel',
906         'Metatron',
907         'Rafael',
908         'Melchezidek',
909         'Semyaza',
910         'Abbadon',
911         'Baalzebub',
912         'Ben Nez',
913         'Jophiel',
914         // Pets
915         'Gecko',
916         'Parakeet',
917         'Kitten',
918         'Horse',
919         'Komodo',
920         'Falcon',
921         'Bobcat',
922         'Unicorn',
923         'Rock Dragon',
924         'Archaeopteryx',
925         'Sabertooth',
926         'Pegasus',
927         'Dire Dragon',
928         'Phoeniz',
929         'Liger',
930         'Alicorn',
931         'Fire Elemental',
932         'Water Elemental',
933         'Sun Elemental',
934         // Accessories
935         'Leather Bracers',
936         'Metal Bracers',
937         'Scholar Scroll',
938         'Cosmic Scroll',
939         '4 Leaf Clover',
940         '7 Leaf Clover',
941         'Red Collar',
942         'Ruby Collar',
943         'Yellow Collar',
944         'Citrine Collar',
945         'Blue Collar',
946         'Sapphire Collar',
947         'Carrots',
948         'Cricket',
949         'Bird Seed',
950         'Cat Nip',
951         'Lightning Rod',
952         'Holy Light',
953         // Medals
954         '1 Ply Paper Towel',
955         '2 Ply Paper Towel',
956         'Cardboard',
957         'Bronze',
958         'Silver',
959         'Gold',
960         'Platinum',
961         'Supid Fluffy Pink',
962         'Orichalcum',
963         'Diamond',
964         'Titanium',
965         'Zeronium'
966     ];
967 
968     uint256[] public mintCostForCardSeries = [
969         0, // Berakiel
970         30000000000000000, // Zadkiel
971         66600000000000000, // lucifer
972         80000000000000000, // Michael
973         3000000000000000, // Arel
974         50000000000000000, // Raguel
975         10000000000000000, // Lilith
976         12500000000000000, // Furlac
977         8000000000000000, // Azazel
978         9000000000000000, // Eleleth
979         7000000000000000, // Verin
980         10000000000000000, // Ziwa
981         12000000000000000, // Cimeriel
982         14000000000000000, // Numinel
983         20000000000000000, // Bat Gol
984         25000000000000000, // Gabriel
985         26500000000000000, // Metatron
986         15000000000000000, // Rafael
987         20000000000000000, // Melchezidek
988         20000000000000000, // Semyaza
989         30000000000000000, // Abbadon
990         35000000000000000, // Baalzebub
991         40000000000000000, // Ben Nez
992         45000000000000000, // Jophiel
993         0, // gecko
994         0, // Parakeet
995         5000000000000000, // Kitten
996         5000000000000000, // Horse
997         10000000000000000, // Komodo
998         10000000000000000, // Falcon
999         10000000000000000, // Bobcat
1000         10000000000000000, // Unicorn
1001         20000000000000000, // Rock Dragon
1002         20000000000000000, // Archaeopteryx
1003         20000000000000000, // Sabertooth
1004         20000000000000000, // Pegasus
1005         30000000000000000, // Dire Dragon
1006         30000000000000000, // Phoenix
1007         30000000000000000, // Liger
1008         30000000000000000, // Alicorn
1009         40000000000000000, // Fire Elemental
1010         40000000000000000, // Water Elemental
1011         40000000000000000, // Sun Elemental
1012         10000000000000000, // leather bracers
1013         20000000000000000, // Metal Bracers
1014         10000000000000000, // Scholars Scroll
1015         20000000000000000, // Cosmic Scroll
1016         10000000000000000, // 4 leaf clover
1017         20000000000000000, // 7 leaf clover
1018         10000000000000000, // Red Collar
1019         20000000000000000, // Ruby Collar
1020         10000000000000000, // Yellow Collar
1021         20000000000000000, // Citrine Collar
1022         10000000000000000, // Blue Collar
1023         20000000000000000, // Sapphire Collar
1024         10000000000000000, // Carrots
1025         10000000000000000, // Cricket
1026         10000000000000000, // Bird Seed
1027         10000000000000000, // Cat Nip
1028         10000000000000000, // Lightning Rod
1029         50000000000000000 // Holy Light
1030     ];
1031 
1032     uint16[] public remainingMintableSupplyForCardSeries = [
1033         56, // Berakiel -- ANGELS
1034         36, // zadkiel
1035         22, // lucifer
1036         22, // Michael
1037         42, // Arel
1038         38, // Raguel
1039         45, // Lilith
1040         44, // Furlac
1041         41, // Azazel
1042         39, // Eleleth
1043         44, // Verin
1044         44, // Ziwa
1045         57, // Cimeriel
1046         62, // Numinel
1047         30, // Bat Gol
1048         30, // Gabriel
1049         39, // Metatron
1050         31, // Rafael
1051         41, // Melchezidek
1052         37, // Semyaza
1053         40, // Abbadon
1054         41, // Baalzebub
1055         41, // Ben Nez
1056         39, // Jophiel
1057         132, // Gecko ---- PETS
1058         0, // Parakeet
1059         67, // Kitten
1060         68, // Horse
1061         140, // Komodo
1062         141, // Falcon
1063         144, // Bobcat
1064         124, // Unicorn
1065         144, // Rock Dragon
1066         105, // Archaeopteryx
1067         118, // Sabertooth
1068         102, // Pegasus
1069         68, // Dire Dragon
1070         75, // Phoenix
1071         56, // Liger
1072         68, // Alicorn
1073         49, // Fire Elemental
1074         50, // Water Elemental
1075         50, // Sun Elemental
1076         40, // Leather bracers ---- ACCESSORIES
1077         33, // Metal bracers
1078         62, // Scholar's scroll
1079         19, // Cosmic scroll
1080         75, // 4 leaf clover
1081         44, // 7 leaf clover
1082         75, // Red collar
1083         45, // Ruby collar
1084         74, // Yellow collar
1085         45, // Citrine collar
1086         75, // Blue collar
1087         43, // Sapphire collar
1088         74, // Carrots
1089         74, // Cricket
1090         74, // Bird Seed
1091         74, // Cat Nip
1092         72, // Lightning Rod
1093         30 // Holy Light
1094     ];
1095 
1096     constructor() {}
1097 
1098     function setIfpsGateway(string memory newGateway) public onlyCREATOR {
1099         ipfsGateway = newGateway;
1100     }
1101 
1102     function setMintingPaused(bool _mintingPaused) public onlyCREATOR {
1103         mintingPaused = _mintingPaused;
1104     }
1105 
1106     function changePaymentSplitter(address payable _newPaymentSplitter)
1107         public
1108         onlyCREATOR
1109     {
1110         paymentSplitter = _newPaymentSplitter;
1111     }
1112 
1113     function setOwner(address _newOwner) public {
1114         require(msg.sender == owner, 'Only the owner may change');
1115         owner = _newOwner;
1116     }
1117 
1118     /**
1119      * @dev See {IERC165-supportsInterface}.
1120      */
1121     function supportsInterface(bytes4 interfaceId)
1122         public
1123         view
1124         virtual
1125         override(ERC165, IERC165)
1126         returns (bool)
1127     {
1128         return
1129             interfaceId == type(IERC721).interfaceId ||
1130             interfaceId == type(IERC721Metadata).interfaceId ||
1131             super.supportsInterface(interfaceId);
1132     }
1133 
1134     /**
1135      * @dev See {IERC721-balanceOf}.
1136      */
1137     function balanceOf(address owner)
1138         public
1139         view
1140         virtual
1141         override
1142         returns (uint256)
1143     {
1144         require(
1145             owner != address(0),
1146             'ERC721: balance query for the zero address'
1147         );
1148         return _balances[owner];
1149     }
1150 
1151     /**
1152      * @dev See {IERC721-ownerOf}.
1153      */
1154     function ownerOf(uint256 tokenId)
1155         public
1156         view
1157         virtual
1158         override
1159         returns (address)
1160     {
1161         address owner = _owners[tokenId];
1162         require(
1163             owner != address(0),
1164             'ERC721: owner query for nonexistent token'
1165         );
1166         return owner;
1167     }
1168 
1169     /**
1170      * @dev See {IERC721Metadata-name}.
1171      */
1172     function name() public view virtual override returns (string memory) {
1173         return _name;
1174     }
1175 
1176     /// @notice An abbreviated name for NFTs in this contract
1177     function symbol() external view override returns (string memory) {
1178         return _symbol;
1179     }
1180 
1181     /**
1182      * @dev See {IERC721Metadata-tokenURI}.
1183      */
1184     function tokenURI(uint256 tokenId)
1185         public
1186         view
1187         override
1188         returns (string memory)
1189     {
1190         require(
1191             _exists(tokenId),
1192             'ERC721Metadata: URI query for nonexistent token'
1193         );
1194 
1195         return
1196             string(
1197                 abi.encodePacked(
1198                     'data:application/json;base64,',
1199                     Base64.encode(
1200                         bytes(
1201                             abi.encodePacked(
1202                                 '{"name":"',
1203                                 cardNames[
1204                                     ABTokenCollection[tokenId].cardSeriesId
1205                                 ],
1206                                 '", "description": "Angel Battles Card',
1207                                 imageURI(tokenId),
1208                                 getPower(tokenId),
1209                                 getExp(tokenId),
1210                                 getAura(tokenId),
1211                                 getCreated(tokenId),
1212                                 '"}]}'
1213                             )
1214                         )
1215                     )
1216                 )
1217             );
1218     }
1219 
1220     function getPower(uint256 tokenId) internal view returns (string memory) {
1221         return
1222             string(
1223                 abi.encodePacked(
1224                     '", "attributes": [{"trait_type": "Power", "value":"',
1225                     ABTokenCollection[tokenId].power.toString16()
1226                 )
1227             );
1228     }
1229 
1230     function getExp(uint256 tokenId) internal view returns (string memory) {
1231         return
1232             string(
1233                 abi.encodePacked(
1234                     '"}, {"trait_type": "experience", "value":"',
1235                     ABTokenCollection[tokenId].experience.toString16()
1236                 )
1237             );
1238     }
1239 
1240     function getAura(uint256 tokenId) internal view returns (string memory) {
1241         return
1242             string(
1243                 abi.encodePacked(
1244                     '"}, {"trait_type": "auraRed", "value":"',
1245                     ABTokenCollection[tokenId].auraRed.toString16(),
1246                     '"}, {"trait_type": "auraYellow", "value":"',
1247                     ABTokenCollection[tokenId].auraYellow.toString16(),
1248                     '"}, {"trait_type": "auraBlue", "value":"',
1249                     ABTokenCollection[tokenId].auraBlue.toString16()
1250                 )
1251             );
1252     }
1253 
1254     function imageURI(uint256 tokenId) internal view returns (string memory) {
1255         return
1256             string(
1257                 abi.encodePacked(
1258                     '", "image" :  "',
1259                     ipfsGateway,
1260                     'QmYHT1FKxYDfc1WUkWA4pkfjnh81SKESeMuSayot5MyEV7/',
1261                     ABTokenCollection[tokenId].cardSeriesId.toString16(),
1262                     '.png'
1263                 )
1264             );
1265     }
1266 
1267     function getCreated(uint256 tokenId) internal view returns (string memory) {
1268         return
1269             string(
1270                 abi.encodePacked(
1271                     '"}, {"trait_type": "createdTime", "value":"',
1272                     ABTokenCollection[tokenId].createdTime.toString()
1273                 )
1274             );
1275     }
1276 
1277     function buyCard(uint8 _cardSeries) public payable {
1278         require(mintingPaused == false, 'Minting is paused');
1279 
1280         require(
1281             msg.value >= mintCostForCardSeries[_cardSeries],
1282             'You must send at least the cost'
1283         );
1284 
1285         require(
1286             remainingMintableSupplyForCardSeries[_cardSeries] > 0,
1287             'That card is sold out'
1288         );
1289 
1290         remainingMintableSupplyForCardSeries[_cardSeries] -= 1;
1291 
1292         // Minting an angel
1293         if (_cardSeries < 24) {
1294             // mint the historical card. This contract will be the owner
1295             // ie, we are minting the wrapped version
1296             IAngelCardData AngelCardData = IAngelCardData(angelCardDataAddress);
1297             uint64 id = AngelCardData.setAngel(
1298                 _cardSeries,
1299                 address(this),
1300                 msg.value,
1301                 getAngelPower(_cardSeries)
1302             );
1303 
1304             uint8 aura;
1305             ABCard memory abCard;
1306             // Retrieve card information
1307             (
1308                 ,
1309                 abCard.cardSeriesId,
1310                 abCard.power,
1311                 aura,
1312                 abCard.experience,
1313                 ,
1314                 abCard.createdTime,
1315                 ,
1316                 ,
1317                 ,
1318 
1319             ) = AngelCardData.getAngel(id);
1320 
1321             // mint the 721 card
1322             AuraMapping memory auraMapping = getAngelAuraMapping(aura);
1323 
1324             // Mint a new card with the same stats
1325             mintABToken(
1326                 msg.sender,
1327                 abCard.cardSeriesId,
1328                 abCard.power,
1329                 auraMapping.auraRed,
1330                 auraMapping.auraYellow,
1331                 auraMapping.auraBlue,
1332                 '',
1333                 abCard.experience,
1334                 uint16(id),
1335                 abCard.createdTime
1336             );
1337         }
1338 
1339         if (_cardSeries > 23 && _cardSeries < 43) {
1340             // mint the historical card
1341             IPetCardData PetCardData = IPetCardData(petCardDataAddress);
1342             PetCardData.setPet(
1343                 _cardSeries - 23,
1344                 address(this),
1345                 '',
1346                 getPetPower(_cardSeries),
1347                 1,
1348                 1,
1349                 1
1350             );
1351 
1352             uint256 id = PetCardData.getTotalPets();
1353 
1354             // Mint a new card with the same stats for the owner
1355             mintABToken(
1356                 msg.sender,
1357                 _cardSeries,
1358                 getPetPower(_cardSeries),
1359                 1,
1360                 1,
1361                 1,
1362                 '',
1363                 0,
1364                 uint16(id),
1365                 0
1366             );
1367         }
1368 
1369         if (_cardSeries > 42) {
1370             // mint the wrapped historical card
1371             IAccessoryData AccessoryCardData = IAccessoryData(
1372                 accessoryCardDataAddress
1373             );
1374             AccessoryCardData.setAccessory(_cardSeries - 42, address(this));
1375             uint256 id = AccessoryCardData.getTotalAccessories();
1376 
1377             // mint the 721 card
1378             mintABToken(
1379                 msg.sender,
1380                 _cardSeries,
1381                 0,
1382                 0,
1383                 0,
1384                 0,
1385                 '',
1386                 0,
1387                 uint16(id),
1388                 0
1389             );
1390         }
1391 
1392         paymentSplitter.transfer(msg.value);
1393     }
1394 
1395     function getRandomNumber(
1396         uint16 maxRandom,
1397         uint8 min,
1398         address privateAddress
1399     ) public view returns (uint8) {
1400         uint256 genNum = uint256(
1401             keccak256(abi.encodePacked(block.timestamp, privateAddress))
1402         );
1403         return uint8((genNum % (maxRandom - min + 1)) + min);
1404     }
1405 
1406     function getPetPower(uint8 _petSeriesId) private view returns (uint8) {
1407         uint8 randomPower = getRandomNumber(10, 0, msg.sender);
1408         if (_petSeriesId < 28) {
1409             return (10 + randomPower);
1410         }
1411         if (_petSeriesId < 32) {
1412             return (20 + randomPower);
1413         }
1414 
1415         if (_petSeriesId < 36) {
1416             return (30 + randomPower);
1417         }
1418 
1419         if (_petSeriesId < 40) {
1420             return (40 + randomPower);
1421         }
1422 
1423         return (50 + randomPower);
1424     }
1425 
1426     function getAngelPower(uint8 _angelSeriesId) private view returns (uint16) {
1427         uint8 randomPower = getRandomNumber(10, 0, msg.sender);
1428         if (_angelSeriesId >= 4) {
1429             return
1430                 uint16(100 + 10 * (uint16(_angelSeriesId) - 4) + randomPower);
1431         }
1432         if (_angelSeriesId == 0) {
1433             return (50 + randomPower);
1434         }
1435         if (_angelSeriesId == 1) {
1436             return (120 + randomPower);
1437         }
1438         if (_angelSeriesId == 2) {
1439             return (250 + randomPower);
1440         }
1441         if (_angelSeriesId == 3) {
1442             return (300 + randomPower);
1443         }
1444         return 1;
1445     }
1446 
1447     /**
1448      * @dev See {IERC721-approve}.
1449      */
1450     function approve(address to, uint256 tokenId) public virtual override {
1451         address owner = ERC721.ownerOf(tokenId);
1452         require(to != owner, 'ERC721: approval to current owner');
1453 
1454         require(
1455             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1456             'ERC721: approve caller is not owner nor approved for all'
1457         );
1458 
1459         _approve(to, tokenId);
1460     }
1461 
1462     /**
1463      * @dev See {IERC721-getApproved}.
1464      */
1465     function getApproved(uint256 tokenId)
1466         public
1467         view
1468         virtual
1469         override
1470         returns (address)
1471     {
1472         require(
1473             _exists(tokenId),
1474             'ERC721: approved query for nonexistent token'
1475         );
1476 
1477         return _tokenApprovals[tokenId];
1478     }
1479 
1480     /**
1481      * @dev See {IERC721-setApprovalForAll}.
1482      */
1483     function setApprovalForAll(address operator, bool approved)
1484         public
1485         virtual
1486         override
1487     {
1488         _setApprovalForAll(_msgSender(), operator, approved);
1489     }
1490 
1491     /**
1492      * @dev See {IERC721-isApprovedForAll}.
1493      */
1494     function isApprovedForAll(address owner, address operator)
1495         public
1496         view
1497         virtual
1498         override
1499         returns (bool)
1500     {
1501         return _operatorApprovals[owner][operator];
1502     }
1503 
1504     /**
1505      * @dev See {IERC721-transferFrom}.
1506      */
1507     function transferFrom(
1508         address from,
1509         address to,
1510         uint256 tokenId
1511     ) public virtual override {
1512         //solhint-disable-next-line max-line-length
1513         require(
1514             _isApprovedOrOwner(_msgSender(), tokenId),
1515             'ERC721: transfer caller is not owner nor approved'
1516         );
1517 
1518         _transfer(from, to, tokenId);
1519     }
1520 
1521     /**
1522      * @dev See {IERC721-safeTransferFrom}.
1523      */
1524     function safeTransferFrom(
1525         address from,
1526         address to,
1527         uint256 tokenId
1528     ) public virtual override {
1529         safeTransferFrom(from, to, tokenId, '');
1530     }
1531 
1532     /**
1533      * @dev See {IERC721-safeTransferFrom}.
1534      */
1535     function safeTransferFrom(
1536         address from,
1537         address to,
1538         uint256 tokenId,
1539         bytes memory _data
1540     ) public virtual override {
1541         require(
1542             _isApprovedOrOwner(_msgSender(), tokenId),
1543             'ERC721: transfer caller is not owner nor approved'
1544         );
1545         _safeTransfer(from, to, tokenId, _data);
1546     }
1547 
1548     /**
1549      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1550      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1551      *
1552      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1553      *
1554      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1555      * implement alternative mechanisms to perform token transfer, such as signature-based.
1556      *
1557      * Requirements:
1558      *
1559      * - `from` cannot be the zero address.
1560      * - `to` cannot be the zero address.
1561      * - `tokenId` token must exist and be owned by `from`.
1562      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1563      *
1564      * Emits a {Transfer} event.
1565      */
1566     function _safeTransfer(
1567         address from,
1568         address to,
1569         uint256 tokenId,
1570         bytes memory _data
1571     ) internal virtual {
1572         _transfer(from, to, tokenId);
1573         require(
1574             _checkOnERC721Received(from, to, tokenId, _data),
1575             'ERC721: transfer to non ERC721Receiver implementer'
1576         );
1577     }
1578 
1579     /**
1580      * @dev Returns whether `tokenId` exists.
1581      *
1582      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1583      *
1584      * Tokens start existing when they are minted (`_mint`),
1585      * and stop existing when they are burned (`_burn`).
1586      */
1587     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1588         return _owners[tokenId] != address(0);
1589     }
1590 
1591     /**
1592      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1593      *
1594      * Requirements:
1595      *
1596      * - `tokenId` must exist.
1597      */
1598     function _isApprovedOrOwner(address spender, uint256 tokenId)
1599         internal
1600         view
1601         virtual
1602         returns (bool)
1603     {
1604         require(
1605             _exists(tokenId),
1606             'ERC721: operator query for nonexistent token'
1607         );
1608         address owner = ERC721.ownerOf(tokenId);
1609         return (spender == owner ||
1610             getApproved(tokenId) == spender ||
1611             isApprovedForAll(owner, spender));
1612     }
1613 
1614     /**
1615      * @dev Safely mints `tokenId` and transfers it to `to`.
1616      *
1617      * Requirements:
1618      *
1619      * - `tokenId` must not exist.
1620      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1621      *
1622      * Emits a {Transfer} event.
1623      */
1624     function _safeMint(address to, uint256 tokenId) internal virtual {
1625         _safeMint(to, tokenId, '');
1626     }
1627 
1628     /**
1629      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1630      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1631      */
1632     function _safeMint(
1633         address to,
1634         uint256 tokenId,
1635         bytes memory _data
1636     ) internal virtual {
1637         _mint(to, tokenId);
1638         require(
1639             _checkOnERC721Received(address(0), to, tokenId, _data),
1640             'ERC721: transfer to non ERC721Receiver implementer'
1641         );
1642     }
1643 
1644     /**
1645      * @dev Mints `tokenId` and transfers it to `to`.
1646      *
1647      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1648      *
1649      * Requirements:
1650      *
1651      * - `tokenId` must not exist.
1652      * - `to` cannot be the zero address.
1653      *
1654      * Emits a {Transfer} event.
1655      */
1656     function _mint(address to, uint256 tokenId) internal virtual {
1657         require(to != address(0), 'ERC721: mint to the zero address');
1658         require(!_exists(tokenId), 'ERC721: token already minted');
1659 
1660         _beforeTokenTransfer(address(0), to, tokenId);
1661 
1662         _balances[to] += 1;
1663         _owners[tokenId] = to;
1664         addABTokenIdMapping(to, tokenId);
1665         emit Transfer(address(0), to, tokenId);
1666 
1667         _afterTokenTransfer(address(0), to, tokenId);
1668     }
1669 
1670     /**
1671      * @dev Destroys `tokenId`.
1672      * The approval is cleared when the token is burned.
1673      *
1674      * Requirements:
1675      *
1676      * - `tokenId` must exist.
1677      *
1678      * Emits a {Transfer} event.
1679      */
1680     function _burn(uint256 tokenId) internal virtual {
1681         address owner = ERC721.ownerOf(tokenId);
1682 
1683         _beforeTokenTransfer(owner, address(0), tokenId);
1684 
1685         // Clear approvals
1686         _approve(address(0), tokenId);
1687 
1688         _balances[owner] -= 1;
1689         delete _owners[tokenId];
1690 
1691         emit Transfer(owner, address(0), tokenId);
1692 
1693         _afterTokenTransfer(owner, address(0), tokenId);
1694     }
1695 
1696     /**
1697      * @dev Transfers `tokenId` from `from` to `to`.
1698      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1699      *
1700      * Requirements:
1701      *
1702      * - `to` cannot be the zero address.
1703      * - `tokenId` token must be owned by `from`.
1704      *
1705      * Emits a {Transfer} event.
1706      */
1707     function _transfer(
1708         address from,
1709         address to,
1710         uint256 tokenId
1711     ) internal virtual {
1712         require(
1713             ERC721.ownerOf(tokenId) == from,
1714             'ERC721: transfer from incorrect owner'
1715         );
1716         require(to != address(0), 'ERC721: transfer to the zero address');
1717 
1718         _beforeTokenTransfer(from, to, tokenId);
1719 
1720         // Clear approvals from the previous owner
1721         _approve(address(0), tokenId);
1722 
1723         addABTokenIdMapping(to, tokenId);
1724 
1725         _balances[from] -= 1;
1726         _balances[to] += 1;
1727         _owners[tokenId] = to;
1728 
1729         emit Transfer(from, to, tokenId);
1730 
1731         _afterTokenTransfer(from, to, tokenId);
1732     }
1733 
1734     /**
1735      * @dev Approve `to` to operate on `tokenId`
1736      *
1737      * Emits a {Approval} event.
1738      */
1739     function _approve(address to, uint256 tokenId) internal virtual {
1740         _tokenApprovals[tokenId] = to;
1741         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1742     }
1743 
1744     /**
1745      * @dev Approve `operator` to operate on all of `owner` tokens
1746      *
1747      * Emits a {ApprovalForAll} event.
1748      */
1749     function _setApprovalForAll(
1750         address owner,
1751         address operator,
1752         bool approved
1753     ) internal virtual {
1754         require(owner != operator, 'ERC721: approve to caller');
1755         _operatorApprovals[owner][operator] = approved;
1756         emit ApprovalForAll(owner, operator, approved);
1757     }
1758 
1759     /**
1760      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1761      * The call is not executed if the target address is not a contract.
1762      *
1763      * @param from address representing the previous owner of the given token ID
1764      * @param to target address that will receive the tokens
1765      * @param tokenId uint256 ID of the token to be transferred
1766      * @param _data bytes optional data to send along with the call
1767      * @return bool whether the call correctly returned the expected magic value
1768      */
1769     function _checkOnERC721Received(
1770         address from,
1771         address to,
1772         uint256 tokenId,
1773         bytes memory _data
1774     ) private returns (bool) {
1775         if (to.isContract()) {
1776             try
1777                 IERC721Receiver(to).onERC721Received(
1778                     _msgSender(),
1779                     from,
1780                     tokenId,
1781                     _data
1782                 )
1783             returns (bytes4 retval) {
1784                 return retval == IERC721Receiver.onERC721Received.selector;
1785             } catch (bytes memory reason) {
1786                 if (reason.length == 0) {
1787                     revert(
1788                         'ERC721: transfer to non ERC721Receiver implementer'
1789                     );
1790                 } else {
1791                     assembly {
1792                         revert(add(32, reason), mload(reason))
1793                     }
1794                 }
1795             }
1796         } else {
1797             return true;
1798         }
1799     }
1800 
1801     /**
1802      * @dev Hook that is called before any token transfer. This includes minting
1803      * and burning.
1804      *
1805      * Calling conditions:
1806      *
1807      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1808      * transferred to `to`.
1809      * - When `from` is zero, `tokenId` will be minted for `to`.
1810      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1811      * - `from` and `to` are never both zero.
1812      *
1813      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1814      */
1815     function _beforeTokenTransfer(
1816         address from,
1817         address to,
1818         uint256 tokenId
1819     ) internal virtual {}
1820 
1821     /**
1822      * @dev Hook that is called after any transfer of tokens. This includes
1823      * minting and burning.
1824      *
1825      * Calling conditions:
1826      *
1827      * - when `from` and `to` are both non-zero.
1828      * - `from` and `to` are never both zero.
1829      *
1830      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1831      */
1832     function _afterTokenTransfer(
1833         address from,
1834         address to,
1835         uint256 tokenId
1836     ) internal virtual {}
1837 
1838     // Functions to wrap a historical NFT.
1839     // Only the owner of a card may wrap it
1840     // Wrapping does not destroy the original NFT
1841     // It can be unwrapped by the owner at any time.
1842 
1843     function wrapAngel(uint64 _angelId) public {
1844         ABCard memory abCard;
1845         address owner;
1846 
1847         uint8 aura;
1848 
1849         // Retrieve card information
1850         IAngelCardData AngelCardData = IAngelCardData(angelCardDataAddress);
1851         (
1852             ,
1853             abCard.cardSeriesId,
1854             abCard.power,
1855             aura,
1856             abCard.experience,
1857             ,
1858             abCard.createdTime,
1859             ,
1860             ,
1861             ,
1862             owner
1863         ) = AngelCardData.getAngel(_angelId);
1864 
1865         // make sure the msg.sender is the owner
1866         require(owner == msg.sender, 'Only the owner may wrap');
1867 
1868         // Make sure the card is unlocked
1869         require(
1870             AngelCardData.getAngelLockStatus(_angelId) == false,
1871             'The card must be unlocked first'
1872         );
1873 
1874         // Transfer ownership of the original card to this contract
1875         AngelCardData.transferAngel(msg.sender, address(this), _angelId);
1876 
1877         AuraMapping memory auraMapping = getAngelAuraMapping(aura);
1878 
1879         // Mint a new card with the same stats
1880         mintABToken(
1881             msg.sender,
1882             abCard.cardSeriesId,
1883             abCard.power,
1884             auraMapping.auraRed,
1885             auraMapping.auraYellow,
1886             auraMapping.auraBlue,
1887             '',
1888             abCard.experience,
1889             uint16(_angelId),
1890             abCard.createdTime
1891         );
1892     }
1893 
1894     function getAngelAuraMapping(uint8 aura)
1895         internal
1896         pure
1897         returns (AuraMapping memory auraMapping)
1898     {
1899         if (aura == 2 || aura == 3 || aura == 4) {
1900             auraMapping.auraRed = 1;
1901         }
1902         if (aura == 1 || aura == 3 || aura == 5) {
1903             auraMapping.auraYellow = 1;
1904         }
1905         if (aura == 0 || aura == 2 || aura == 5) {
1906             auraMapping.auraBlue = 1;
1907         }
1908     }
1909 
1910     function wrapPet(uint256 _petId) public {
1911         // Retrieve card information
1912         IPetCardData PetCardData = IPetCardData(petCardDataAddress);
1913         ABCard memory abCard;
1914         address owner;
1915 
1916         (
1917             ,
1918             abCard.cardSeriesId,
1919             ,
1920             abCard.power,
1921             abCard.auraRed,
1922             abCard.auraBlue,
1923             abCard.auraYellow,
1924             ,
1925             ,
1926             owner
1927         ) = PetCardData.getPet(_petId);
1928 
1929         // make sure the msg.sender is the owner
1930         require(owner == msg.sender, 'Only the owner may wrap');
1931 
1932         // Transfer ownership of the original card to this contract
1933         PetCardData.transferPet(msg.sender, address(this), uint16(_petId));
1934 
1935         // Mint a new card with the same stats
1936         mintABToken(
1937             owner,
1938             abCard.cardSeriesId + 23,
1939             abCard.power,
1940             abCard.auraRed,
1941             abCard.auraYellow,
1942             abCard.auraBlue,
1943             '',
1944             0,
1945             uint16(_petId),
1946             0
1947         );
1948     }
1949 
1950     function getPetCreatedTime(uint64 lastTrainingTime, uint64 lastBreedingTime)
1951         public
1952         pure
1953         returns (uint64)
1954     {
1955         // Pet cards do not have a createdTime recorded
1956         // Therefore, createdTime will be 0 if the pet has never trained or bred
1957         // Otherwise, it will be the earliest of last training time or last breeding time.
1958 
1959         if (lastTrainingTime < lastBreedingTime && lastTrainingTime > 0) {
1960             return lastTrainingTime;
1961         }
1962 
1963         if (lastBreedingTime < lastTrainingTime && lastBreedingTime > 0) {
1964             return lastBreedingTime;
1965         }
1966         return 0;
1967     }
1968 
1969     function wrapAccessory(uint256 _accessoryId) public {
1970         // Retrieve card information
1971         IAccessoryData AccessoryCardData = IAccessoryData(
1972             accessoryCardDataAddress
1973         );
1974 
1975         (, uint8 accessoryCardSeriesId, address owner) = AccessoryCardData
1976             .getAccessory(_accessoryId);
1977 
1978         // make sure the msg.sender is the owner
1979         require(owner == msg.sender, 'Only the owner may wrap');
1980 
1981         // Make sure the card is unlocked
1982         require(
1983             AccessoryCardData.getAccessoryLockStatus(uint64(_accessoryId)) ==
1984                 false,
1985             'The card must be unlocked first'
1986         );
1987 
1988         // Transfer ownership of the original card to this contract
1989         AccessoryCardData.transferAccessory(
1990             msg.sender,
1991             address(this),
1992             uint64(_accessoryId)
1993         );
1994 
1995         // Mint a new card with the same stats
1996         mintABToken(
1997             msg.sender,
1998             accessoryCardSeriesId + 42,
1999             0,
2000             0,
2001             0,
2002             0,
2003             '',
2004             0,
2005             uint16(_accessoryId),
2006             0
2007         );
2008     }
2009 
2010     // Function to unwrap a historical NFT.
2011     // Only the owner of a card may unwrap it
2012     // unwrapping destroys the new nft and transfers the historical one
2013     // unwrapped cards may be re-wraped at any time
2014 
2015     // unwrapped angels and accessories have lockStatus = false. This means that they can only be
2016     // accessed by seraphim contracts. Users can lock their cards again if they wish.
2017 
2018     function unwrap(uint256 cardId) public {
2019         // make sure the msg.sender is the owner
2020         require(ownerOf(cardId) == msg.sender, 'Only the owner may unwrap');
2021 
2022         // destroy the current card
2023         _burn(cardId);
2024         // transfer ownership of the historical card back to msg.sender
2025 
2026         // Angel Card
2027         if (ABTokenCollection[cardId].cardSeriesId < 24) {
2028             IAngelCardData AngelCardData = IAngelCardData(angelCardDataAddress);
2029 
2030             AngelCardData.ownerAngelTransfer(
2031                 msg.sender,
2032                 ABTokenCollection[cardId].oldId
2033             );
2034         }
2035         // Pet Card
2036         else if (ABTokenCollection[cardId].cardSeriesId < 43) {
2037             IPetCardData PetCardData = IPetCardData(petCardDataAddress);
2038             PetCardData.transferPet(
2039                 address(this),
2040                 msg.sender,
2041                 ABTokenCollection[cardId].oldId
2042             );
2043         }
2044         // Accessory Card
2045         else if (ABTokenCollection[cardId].cardSeriesId < 61) {
2046             IAccessoryData AccessoryCardData = IAccessoryData(
2047                 accessoryCardDataAddress
2048             );
2049             AccessoryCardData.ownerAccessoryTransfer(
2050                 msg.sender,
2051                 ABTokenCollection[cardId].oldId
2052             );
2053         }
2054     }
2055 
2056     function mintABToken(
2057         address owner,
2058         uint8 _cardSeriesId,
2059         uint16 _power,
2060         uint16 _auraRed,
2061         uint16 _auraYellow,
2062         uint16 _auraBlue,
2063         string memory cardName,
2064         uint16 _experience,
2065         uint16 oldId,
2066         uint64 createdTime
2067     ) internal {
2068         ABCard storage abcard = ABTokenCollection[totalSupply];
2069         abcard.power = _power;
2070         abcard.cardSeriesId = _cardSeriesId;
2071         abcard.auraRed = _auraRed;
2072         abcard.auraYellow = _auraYellow;
2073         abcard.auraBlue = _auraBlue;
2074         abcard.name = cardName;
2075         abcard.experience = _experience;
2076         abcard.tokenId = totalSupply;
2077         abcard.createdTime = createdTime;
2078         abcard.oldId = oldId;
2079         _mint(owner, totalSupply);
2080         totalSupply = totalSupply + 1;
2081         currentTokenNumbers[_cardSeriesId]++;
2082     }
2083 
2084     // When minting a wrapped token, two tokens are minted, a historical and a wrapped one
2085     // the historical token is owned by this contract.
2086 
2087     function addABTokenIdMapping(address _owner, uint256 _tokenId) private {
2088         uint256[] storage owners = ownerABTokenCollection[_owner];
2089         owners.push(_tokenId);
2090     }
2091 
2092     function getCurrentTokenNumbers(uint8 _cardSeriesId)
2093         public
2094         view
2095         returns (uint32)
2096     {
2097         return currentTokenNumbers[_cardSeriesId];
2098     }
2099 
2100     function getABToken(uint256 tokenId)
2101         public
2102         view
2103         returns (
2104             uint8 cardSeriesId,
2105             uint16 power,
2106             uint16 auraRed,
2107             uint16 auraYellow,
2108             uint16 auraBlue,
2109             string memory cardName,
2110             uint16 experience,
2111             uint64 lastBattleTime,
2112             uint64 createdTime,
2113             address owner
2114         )
2115     {
2116         ABCard memory abcard = ABTokenCollection[tokenId];
2117         cardSeriesId = abcard.cardSeriesId;
2118         power = abcard.power;
2119         experience = abcard.experience;
2120         auraRed = abcard.auraRed;
2121         auraBlue = abcard.auraBlue;
2122         auraYellow = abcard.auraYellow;
2123         cardName = abcard.name;
2124         lastBattleTime = abcard.lastBattleTime;
2125         createdTime = abcard.createdTime;
2126         owner = ownerOf(tokenId);
2127     }
2128 
2129     function setName(uint256 tokenId, string memory namechange) public {
2130         ABCard storage abcard = ABTokenCollection[tokenId];
2131         if (msg.sender != ownerOf(tokenId)) {
2132             revert();
2133         }
2134         if (abcard.tokenId == tokenId) {
2135             abcard.name = namechange;
2136         }
2137     }
2138 
2139     function getABTokenByIndex(address _owner, uint64 _index)
2140         external
2141         view
2142         returns (uint256)
2143     {
2144         if (_index >= ownerABTokenCollection[_owner].length) {
2145             return 0;
2146         }
2147         return ownerABTokenCollection[_owner][_index];
2148     }
2149 }