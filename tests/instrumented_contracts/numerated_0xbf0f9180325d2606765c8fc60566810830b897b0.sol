1 pragma solidity ^0.8.0;
2 
3 /**
4  * @dev Interface of the ERC165 standard, as defined in the
5  * https://eips.ethereum.org/EIPS/eip-165[EIP].
6  *
7  * Implementers can declare support of contract interfaces, which can then be
8  * queried by others ({ERC165Checker}).
9  *
10  * For an implementation, see {ERC165}.
11  */
12 interface IERC165 {
13     /**
14      * @dev Returns true if this contract implements the interface defined by
15      * `interfaceId`. See the corresponding
16      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
17      * to learn more about how these ids are created.
18      *
19      * This function call must use less than 30 000 gas.
20      */
21     function supportsInterface(bytes4 interfaceId) external view returns (bool);
22 }
23 
24 pragma solidity ^0.8.0;
25 
26 
27 /**
28  * @dev Required interface of an ERC721 compliant contract.
29  */
30 interface IERC721 is IERC165 {
31     /**
32      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
33      */
34     event Transfer(
35         address indexed from,
36         address indexed to,
37         uint256 indexed tokenId
38     );
39 
40     /**
41      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
42      */
43     event Approval(
44         address indexed owner,
45         address indexed approved,
46         uint256 indexed tokenId
47     );
48 
49     /**
50      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
51      */
52     event ApprovalForAll(
53         address indexed owner,
54         address indexed operator,
55         bool approved
56     );
57 
58     /**
59      * @dev Emitted when `owner` pays to purchase a specific image id.
60      */
61     event Purchase(address indexed owner, string imageId, string name);
62 
63     /**
64      * @dev Returns the number of tokens in ``owner``'s account.
65      */
66     function balanceOf(address owner) external view returns (uint256 balance);
67 
68     /**
69      * @dev Returns the owner of the `tokenId` token.
70      *
71      * Requirements:
72      *
73      * - `tokenId` must exist.
74      */
75     function ownerOf(uint256 tokenId) external view returns (address owner);
76 
77     /**
78      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
79      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
80      *
81      * Requirements:
82      *
83      * - `from` cannot be the zero address.
84      * - `to` cannot be the zero address.
85      * - `tokenId` token must exist and be owned by `from`.
86      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
87      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
88      *
89      * Emits a {Transfer} event.
90      */
91     function safeTransferFrom(
92         address from,
93         address to,
94         uint256 tokenId
95     ) external;
96 
97     /**
98      * @dev Transfers `tokenId` token from `from` to `to`.
99      *
100      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
101      *
102      * Requirements:
103      *
104      * - `from` cannot be the zero address.
105      * - `to` cannot be the zero address.
106      * - `tokenId` token must be owned by `from`.
107      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
108      *
109      * Emits a {Transfer} event.
110      */
111     function transferFrom(
112         address from,
113         address to,
114         uint256 tokenId
115     ) external;
116 
117     /**
118      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
119      * The approval is cleared when the token is transferred.
120      *
121      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
122      *
123      * Requirements:
124      *
125      * - The caller must own the token or be an approved operator.
126      * - `tokenId` must exist.
127      *
128      * Emits an {Approval} event.
129      */
130     function approve(address to, uint256 tokenId) external;
131 
132     /**
133      * @dev Returns the account approved for `tokenId` token.
134      *
135      * Requirements:
136      *
137      * - `tokenId` must exist.
138      */
139     function getApproved(uint256 tokenId)
140         external
141         view
142         returns (address operator);
143 
144     /**
145      * @dev Approve or remove `operator` as an operator for the caller.
146      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
147      *
148      * Requirements:
149      *
150      * - The `operator` cannot be the caller.
151      *
152      * Emits an {ApprovalForAll} event.
153      */
154     function setApprovalForAll(address operator, bool _approved) external;
155 
156     /**
157      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
158      *
159      * See {setApprovalForAll}
160      */
161     function isApprovedForAll(address owner, address operator)
162         external
163         view
164         returns (bool);
165 
166     /**
167      * @dev Safely transfers `tokenId` token from `from` to `to`.
168      *
169      * Requirements:
170      *
171      * - `from` cannot be the zero address.
172      * - `to` cannot be the zero address.
173      * - `tokenId` token must exist and be owned by `from`.
174      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
175      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
176      *
177      * Emits a {Transfer} event.
178      */
179     function safeTransferFrom(
180         address from,
181         address to,
182         uint256 tokenId,
183         bytes calldata data
184     ) external;
185 }
186 
187 pragma solidity ^0.8.0;
188 
189 /**
190  * @title ERC721 token receiver interface
191  * @dev Interface for any contract that wants to support safeTransfers
192  * from ERC721 asset contracts.
193  */
194 interface IERC721Receiver {
195     /**
196      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
197      * by `operator` from `from`, this function is called.
198      *
199      * It must return its Solidity selector to confirm the token transfer.
200      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
201      *
202      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
203      */
204     function onERC721Received(
205         address operator,
206         address from,
207         uint256 tokenId,
208         bytes calldata data
209     ) external returns (bytes4);
210 }
211 
212 pragma solidity ^0.8.0;
213 
214 
215 /**
216  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
217  * @dev See https://eips.ethereum.org/EIPS/eip-721
218  */
219 interface IERC721Metadata is IERC721 {
220     /**
221      * @dev Returns the token collection name.
222      */
223     function name() external view returns (string memory);
224 
225     /**
226      * @dev Returns the token collection symbol.
227      */
228     function symbol() external view returns (string memory);
229 
230     /**
231      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
232      */
233     function tokenURI(uint256 tokenId) external view returns (string memory);
234 }
235 
236 pragma solidity ^0.8.0;
237 
238 
239 interface IArtAI is IERC721 {
240     function tokenIdForName(string memory _paintingName)
241         external
242         view
243         returns (uint256);
244 
245     function tokenInfo(uint256 _tokenId)
246         external
247         view
248         returns (
249             string memory _imageHash,
250             string memory _imageName,
251             string memory _imageId
252         );
253 }
254 
255 pragma solidity ^0.8.0;
256 
257 /**
258  * @dev Interface of the ERC20 standard as defined in the EIP.
259  */
260 interface IERC20 {
261     /**
262      * @dev Returns the amount of tokens in existence.
263      */
264     function totalSupply() external view returns (uint256);
265 
266     /**
267      * @dev Returns the amount of tokens owned by `account`.
268      */
269     function balanceOf(address account) external view returns (uint256);
270 
271     /**
272      * @dev Moves `amount` tokens from the caller's account to `recipient`.
273      *
274      * Returns a boolean value indicating whether the operation succeeded.
275      *
276      * Emits a {Transfer} event.
277      */
278     function transfer(address recipient, uint256 amount)
279         external
280         returns (bool);
281 
282     /**
283      * @dev Returns the remaining number of tokens that `spender` will be
284      * allowed to spend on behalf of `owner` through {transferFrom}. This is
285      * zero by default.
286      *
287      * This value changes when {approve} or {transferFrom} are called.
288      */
289     function allowance(address owner, address spender)
290         external
291         view
292         returns (uint256);
293 
294     /**
295      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
296      *
297      * Returns a boolean value indicating whether the operation succeeded.
298      *
299      * IMPORTANT: Beware that changing an allowance with this method brings the risk
300      * that someone may use both the old and the new allowance by unfortunate
301      * transaction ordering. One possible solution to mitigate this race
302      * condition is to first reduce the spender's allowance to 0 and set the
303      * desired value afterwards:
304      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
305      *
306      * Emits an {Approval} event.
307      */
308     function approve(address spender, uint256 amount) external returns (bool);
309 
310     /**
311      * @dev Moves `amount` tokens from `sender` to `recipient` using the
312      * allowance mechanism. `amount` is then deducted from the caller's
313      * allowance.
314      *
315      * Returns a boolean value indicating whether the operation succeeded.
316      *
317      * Emits a {Transfer} event.
318      */
319     function transferFrom(
320         address sender,
321         address recipient,
322         uint256 amount
323     ) external returns (bool);
324 
325     /**
326      * @dev Emitted when `value` tokens are moved from one account (`from`) to
327      * another (`to`).
328      *
329      * Note that `value` may be zero.
330      */
331     event Transfer(address indexed from, address indexed to, uint256 value);
332 
333     /**
334      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
335      * a call to {approve}. `value` is the new allowance.
336      */
337     event Approval(
338         address indexed owner,
339         address indexed spender,
340         uint256 value
341     );
342 }
343 
344 pragma solidity ^0.8.0;
345 
346 /**
347  * @dev Collection of functions related to the address type
348  */
349 library Address {
350     /**
351      * @dev Returns true if `account` is a contract.
352      *
353      * [IMPORTANT]
354      * ====
355      * It is unsafe to assume that an address for which this function returns
356      * false is an externally-owned account (EOA) and not a contract.
357      *
358      * Among others, `isContract` will return false for the following
359      * types of addresses:
360      *
361      *  - an externally-owned account
362      *  - a contract in construction
363      *  - an address where a contract will be created
364      *  - an address where a contract lived, but was destroyed
365      * ====
366      */
367     function isContract(address account) internal view returns (bool) {
368         // This method relies on extcodesize, which returns 0 for contracts in
369         // construction, since the code is only stored at the end of the
370         // constructor execution.
371 
372         uint256 size;
373         assembly {
374             size := extcodesize(account)
375         }
376         return size > 0;
377     }
378 
379     /**
380      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
381      * `recipient`, forwarding all available gas and reverting on errors.
382      *
383      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
384      * of certain opcodes, possibly making contracts go over the 2300 gas limit
385      * imposed by `transfer`, making them unable to receive funds via
386      * `transfer`. {sendValue} removes this limitation.
387      *
388      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
389      *
390      * IMPORTANT: because control is transferred to `recipient`, care must be
391      * taken to not create reentrancy vulnerabilities. Consider using
392      * {ReentrancyGuard} or the
393      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
394      */
395     function sendValue(address payable recipient, uint256 amount) internal {
396         require(
397             address(this).balance >= amount,
398             "Address: insufficient balance"
399         );
400 
401         (bool success, ) = recipient.call{value: amount}("");
402         require(
403             success,
404             "Address: unable to send value, recipient may have reverted"
405         );
406     }
407 
408     /**
409      * @dev Performs a Solidity function call using a low level `call`. A
410      * plain `call` is an unsafe replacement for a function call: use this
411      * function instead.
412      *
413      * If `target` reverts with a revert reason, it is bubbled up by this
414      * function (like regular Solidity function calls).
415      *
416      * Returns the raw returned data. To convert to the expected return value,
417      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
418      *
419      * Requirements:
420      *
421      * - `target` must be a contract.
422      * - calling `target` with `data` must not revert.
423      *
424      * _Available since v3.1._
425      */
426     function functionCall(address target, bytes memory data)
427         internal
428         returns (bytes memory)
429     {
430         return functionCall(target, data, "Address: low-level call failed");
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
435      * `errorMessage` as a fallback revert reason when `target` reverts.
436      *
437      * _Available since v3.1._
438      */
439     function functionCall(
440         address target,
441         bytes memory data,
442         string memory errorMessage
443     ) internal returns (bytes memory) {
444         return functionCallWithValue(target, data, 0, errorMessage);
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
449      * but also transferring `value` wei to `target`.
450      *
451      * Requirements:
452      *
453      * - the calling contract must have an ETH balance of at least `value`.
454      * - the called Solidity function must be `payable`.
455      *
456      * _Available since v3.1._
457      */
458     function functionCallWithValue(
459         address target,
460         bytes memory data,
461         uint256 value
462     ) internal returns (bytes memory) {
463         return
464             functionCallWithValue(
465                 target,
466                 data,
467                 value,
468                 "Address: low-level call with value failed"
469             );
470     }
471 
472     /**
473      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
474      * with `errorMessage` as a fallback revert reason when `target` reverts.
475      *
476      * _Available since v3.1._
477      */
478     function functionCallWithValue(
479         address target,
480         bytes memory data,
481         uint256 value,
482         string memory errorMessage
483     ) internal returns (bytes memory) {
484         require(
485             address(this).balance >= value,
486             "Address: insufficient balance for call"
487         );
488         require(isContract(target), "Address: call to non-contract");
489 
490         (bool success, bytes memory returndata) = target.call{value: value}(
491             data
492         );
493         return verifyCallResult(success, returndata, errorMessage);
494     }
495 
496     /**
497      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
498      * but performing a static call.
499      *
500      * _Available since v3.3._
501      */
502     function functionStaticCall(address target, bytes memory data)
503         internal
504         view
505         returns (bytes memory)
506     {
507         return
508             functionStaticCall(
509                 target,
510                 data,
511                 "Address: low-level static call failed"
512             );
513     }
514 
515     /**
516      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
517      * but performing a static call.
518      *
519      * _Available since v3.3._
520      */
521     function functionStaticCall(
522         address target,
523         bytes memory data,
524         string memory errorMessage
525     ) internal view returns (bytes memory) {
526         require(isContract(target), "Address: static call to non-contract");
527 
528         (bool success, bytes memory returndata) = target.staticcall(data);
529         return verifyCallResult(success, returndata, errorMessage);
530     }
531 
532     /**
533      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
534      * but performing a delegate call.
535      *
536      * _Available since v3.4._
537      */
538     function functionDelegateCall(address target, bytes memory data)
539         internal
540         returns (bytes memory)
541     {
542         return
543             functionDelegateCall(
544                 target,
545                 data,
546                 "Address: low-level delegate call failed"
547             );
548     }
549 
550     /**
551      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
552      * but performing a delegate call.
553      *
554      * _Available since v3.4._
555      */
556     function functionDelegateCall(
557         address target,
558         bytes memory data,
559         string memory errorMessage
560     ) internal returns (bytes memory) {
561         require(isContract(target), "Address: delegate call to non-contract");
562 
563         (bool success, bytes memory returndata) = target.delegatecall(data);
564         return verifyCallResult(success, returndata, errorMessage);
565     }
566 
567     /**
568      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
569      * revert reason using the provided one.
570      *
571      * _Available since v4.3._
572      */
573     function verifyCallResult(
574         bool success,
575         bytes memory returndata,
576         string memory errorMessage
577     ) internal pure returns (bytes memory) {
578         if (success) {
579             return returndata;
580         } else {
581             // Look for revert reason and bubble it up if present
582             if (returndata.length > 0) {
583                 // The easiest way to bubble the revert reason is using memory via assembly
584 
585                 assembly {
586                     let returndata_size := mload(returndata)
587                     revert(add(32, returndata), returndata_size)
588                 }
589             } else {
590                 revert(errorMessage);
591             }
592         }
593     }
594 }
595 
596 pragma solidity ^0.8.0;
597 
598 /**
599  * @dev Provides information about the current execution context, including the
600  * sender of the transaction and its data. While these are generally available
601  * via msg.sender and msg.data, they should not be accessed in such a direct
602  * manner, since when dealing with meta-transactions the account sending and
603  * paying for execution may not be the actual sender (as far as an application
604  * is concerned).
605  *
606  * This contract is only required for intermediate, library-like contracts.
607  */
608 abstract contract Context {
609     function _msgSender() internal view virtual returns (address) {
610         return msg.sender;
611     }
612 
613     function _msgData() internal view virtual returns (bytes calldata) {
614         return msg.data;
615     }
616 }
617 
618 pragma solidity ^0.8.0;
619 
620 /**
621  * @dev String operations.
622  */
623 library Strings {
624     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
625 
626     /**
627      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
628      */
629     function toString(uint256 value) internal pure returns (string memory) {
630         // Inspired by OraclizeAPI's implementation - MIT licence
631         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
632 
633         if (value == 0) {
634             return "0";
635         }
636         uint256 temp = value;
637         uint256 digits;
638         while (temp != 0) {
639             digits++;
640             temp /= 10;
641         }
642         bytes memory buffer = new bytes(digits);
643         while (value != 0) {
644             digits -= 1;
645             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
646             value /= 10;
647         }
648         return string(buffer);
649     }
650 
651     /**
652      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
653      */
654     function toHexString(uint256 value) internal pure returns (string memory) {
655         if (value == 0) {
656             return "0x00";
657         }
658         uint256 temp = value;
659         uint256 length = 0;
660         while (temp != 0) {
661             length++;
662             temp >>= 8;
663         }
664         return toHexString(value, length);
665     }
666 
667     /**
668      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
669      */
670     function toHexString(uint256 value, uint256 length)
671         internal
672         pure
673         returns (string memory)
674     {
675         bytes memory buffer = new bytes(2 * length + 2);
676         buffer[0] = "0";
677         buffer[1] = "x";
678         for (uint256 i = 2 * length + 1; i > 1; --i) {
679             buffer[i] = _HEX_SYMBOLS[value & 0xf];
680             value >>= 4;
681         }
682         require(value == 0, "Strings: hex length insufficient");
683         return string(buffer);
684     }
685 }
686 
687 pragma solidity ^0.8.0;
688 
689 
690 /**
691  * @dev Implementation of the {IERC165} interface.
692  *
693  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
694  * for the additional interface id that will be supported. For example:
695  *
696  * ```solidity
697  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
698  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
699  * }
700  * ```
701  *
702  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
703  */
704 abstract contract ERC165 is IERC165 {
705     /**
706      * @dev See {IERC165-supportsInterface}.
707      */
708     function supportsInterface(bytes4 interfaceId)
709         public
710         view
711         virtual
712         override
713         returns (bool)
714     {
715         return interfaceId == type(IERC165).interfaceId;
716     }
717 }
718 
719 pragma solidity ^0.8.0;
720 
721 contract Ownable {
722     address _owner;
723 
724     constructor() {
725         _owner = msg.sender;
726     }
727 
728     modifier onlyOwner() {
729         require(
730             msg.sender == _owner,
731             "Only the contract owner may call this function"
732         );
733         _;
734     }
735 
736     function owner() public view virtual returns (address) {
737         return _owner;
738     }
739 
740     function transferOwnership(address newOwner) external onlyOwner {
741         require(newOwner != address(0));
742         _owner = newOwner;
743     }
744 
745     function withdrawBalance() external onlyOwner {
746         payable(_owner).transfer(address(this).balance);
747     }
748 
749     function withdrawAmountTo(address _recipient, uint256 _amount)
750         external
751         onlyOwner
752     {
753         require(address(this).balance >= _amount);
754         payable(_recipient).transfer(_amount);
755     }
756 }
757 
758 pragma solidity ^0.8.0;
759 
760 
761 
762 /**
763  * @dev Contract module which allows children to implement an emergency stop
764  * mechanism that can be triggered by an authorized account.
765  *
766  * This module is used through inheritance. It will make available the
767  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
768  * the functions of your contract. Note that they will not be pausable by
769  * simply including this module, only once the modifiers are put in place.
770  */
771 abstract contract Pausable is Context, Ownable {
772     /**
773      * @dev Emitted when the pause is triggered by `account`.
774      */
775     event Paused(address account);
776 
777     /**
778      * @dev Emitted when the pause is lifted by `account`.
779      */
780     event Unpaused(address account);
781 
782     bool private _paused;
783     bool private _allowMinting;
784     bool private _allowExtending;
785 
786     /**
787      * @dev Initializes the contract in paused state.
788      */
789     constructor() {
790         _paused = true;
791         _allowMinting = false;
792         _allowExtending = false;
793     }
794 
795     /**
796      * @dev Returns true if the contract is paused, and false otherwise.
797      */
798     function paused() public view virtual returns (bool) {
799         return _paused;
800     }
801 
802     /**
803      * @dev Modifier to make a function callable only when the contract is not paused.
804      *
805      * Requirements:
806      *
807      * - The contract must not be paused.
808      */
809     modifier whenNotPaused() {
810         require(!paused(), "Pausable: paused");
811         _;
812     }
813 
814     /**
815      * @dev Modifier to make a function callable only when the contract is paused.
816      *
817      * Requirements:
818      *
819      * - The contract must be paused.
820      */
821     modifier whenPaused() {
822         require(paused(), "Pausable: not paused");
823         _;
824     }
825 
826     modifier whenMintingOpen() {
827         require(!paused() && _allowMinting, "Minting is not open");
828         _;
829     }
830 
831     modifier whenExtendingOpen() {
832         require(!paused() && _allowExtending, "Extending is not open");
833         _;
834     }
835 
836     function pause() external onlyOwner {
837         _pause();
838     }
839 
840     function unpause() external onlyOwner {
841         _unpause();
842     }
843 
844     function openExtending() external onlyOwner {
845         _openExtending();
846     }
847 
848     function closeExtending() external onlyOwner {
849         _closeExtending();
850     }
851 
852     function openMinting() external onlyOwner {
853         _openMinting();
854     }
855 
856     function closeMinting() external onlyOwner {
857         _closeMinting();
858     }
859 
860     /**
861      * @dev Triggers stopped state.
862      *
863      * Requirements:
864      *
865      * - The contract must not be paused.
866      */
867     function _pause() internal virtual whenNotPaused {
868         _paused = true;
869         emit Paused(_msgSender());
870     }
871 
872     /**
873      * @dev Returns to normal state.
874      *
875      * Requirements:
876      *
877      * - The contract must be paused.
878      */
879     function _unpause() internal virtual whenPaused {
880         _paused = false;
881         emit Unpaused(_msgSender());
882     }
883 
884     function _openMinting() internal virtual whenNotPaused {
885         _allowMinting = true;
886     }
887 
888     function _closeMinting() internal virtual {
889         _allowMinting = false;
890     }
891 
892     function _openExtending() internal virtual whenNotPaused {
893         _allowExtending = true;
894     }
895 
896     function _closeExtending() internal virtual {
897         _allowExtending = false;
898     }
899 }
900 
901 pragma solidity ^0.8.0;
902 
903 
904 /**
905  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
906  *
907  * These functions can be used to verify that a message was signed by the holder
908  * of the private keys of a given address.
909  */
910 library ECDSA {
911     enum RecoverError {
912         NoError,
913         InvalidSignature,
914         InvalidSignatureLength,
915         InvalidSignatureS,
916         InvalidSignatureV
917     }
918 
919     function _throwError(RecoverError error) private pure {
920         if (error == RecoverError.NoError) {
921             return; // no error: do nothing
922         } else if (error == RecoverError.InvalidSignature) {
923             revert("ECDSA: invalid signature");
924         } else if (error == RecoverError.InvalidSignatureLength) {
925             revert("ECDSA: invalid signature length");
926         } else if (error == RecoverError.InvalidSignatureS) {
927             revert("ECDSA: invalid signature 's' value");
928         } else if (error == RecoverError.InvalidSignatureV) {
929             revert("ECDSA: invalid signature 'v' value");
930         }
931     }
932 
933     /**
934      * @dev Returns the address that signed a hashed message (`hash`) with
935      * `signature` or error string. This address can then be used for verification purposes.
936      *
937      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
938      * this function rejects them by requiring the `s` value to be in the lower
939      * half order, and the `v` value to be either 27 or 28.
940      *
941      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
942      * verification to be secure: it is possible to craft signatures that
943      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
944      * this is by receiving a hash of the original message (which may otherwise
945      * be too long), and then calling {toEthSignedMessageHash} on it.
946      *
947      * Documentation for signature generation:
948      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
949      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
950      *
951      * _Available since v4.3._
952      */
953     function tryRecover(bytes32 hash, bytes memory signature)
954         internal
955         pure
956         returns (address, RecoverError)
957     {
958         // Check the signature length
959         // - case 65: r,s,v signature (standard)
960         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
961         if (signature.length == 65) {
962             bytes32 r;
963             bytes32 s;
964             uint8 v;
965             // ecrecover takes the signature parameters, and the only way to get them
966             // currently is to use assembly.
967             assembly {
968                 r := mload(add(signature, 0x20))
969                 s := mload(add(signature, 0x40))
970                 v := byte(0, mload(add(signature, 0x60)))
971             }
972             return tryRecover(hash, v, r, s);
973         } else if (signature.length == 64) {
974             bytes32 r;
975             bytes32 vs;
976             // ecrecover takes the signature parameters, and the only way to get them
977             // currently is to use assembly.
978             assembly {
979                 r := mload(add(signature, 0x20))
980                 vs := mload(add(signature, 0x40))
981             }
982             return tryRecover(hash, r, vs);
983         } else {
984             return (address(0), RecoverError.InvalidSignatureLength);
985         }
986     }
987 
988     /**
989      * @dev Returns the address that signed a hashed message (`hash`) with
990      * `signature`. This address can then be used for verification purposes.
991      *
992      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
993      * this function rejects them by requiring the `s` value to be in the lower
994      * half order, and the `v` value to be either 27 or 28.
995      *
996      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
997      * verification to be secure: it is possible to craft signatures that
998      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
999      * this is by receiving a hash of the original message (which may otherwise
1000      * be too long), and then calling {toEthSignedMessageHash} on it.
1001      */
1002     function recover(bytes32 hash, bytes memory signature)
1003         internal
1004         pure
1005         returns (address)
1006     {
1007         (address recovered, RecoverError error) = tryRecover(hash, signature);
1008         _throwError(error);
1009         return recovered;
1010     }
1011 
1012     /**
1013      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1014      *
1015      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1016      *
1017      * _Available since v4.3._
1018      */
1019     function tryRecover(
1020         bytes32 hash,
1021         bytes32 r,
1022         bytes32 vs
1023     ) internal pure returns (address, RecoverError) {
1024         bytes32 s;
1025         uint8 v;
1026         assembly {
1027             s := and(
1028                 vs,
1029                 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
1030             )
1031             v := add(shr(255, vs), 27)
1032         }
1033         return tryRecover(hash, v, r, s);
1034     }
1035 
1036     /**
1037      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1038      *
1039      * _Available since v4.2._
1040      */
1041     function recover(
1042         bytes32 hash,
1043         bytes32 r,
1044         bytes32 vs
1045     ) internal pure returns (address) {
1046         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1047         _throwError(error);
1048         return recovered;
1049     }
1050 
1051     /**
1052      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1053      * `r` and `s` signature fields separately.
1054      *
1055      * _Available since v4.3._
1056      */
1057     function tryRecover(
1058         bytes32 hash,
1059         uint8 v,
1060         bytes32 r,
1061         bytes32 s
1062     ) internal pure returns (address, RecoverError) {
1063         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1064         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1065         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1066         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1067         //
1068         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1069         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1070         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1071         // these malleable signatures as well.
1072         if (
1073             uint256(s) >
1074             0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0
1075         ) {
1076             return (address(0), RecoverError.InvalidSignatureS);
1077         }
1078         if (v != 27 && v != 28) {
1079             return (address(0), RecoverError.InvalidSignatureV);
1080         }
1081 
1082         // If the signature is valid (and not malleable), return the signer address
1083         address signer = ecrecover(hash, v, r, s);
1084         if (signer == address(0)) {
1085             return (address(0), RecoverError.InvalidSignature);
1086         }
1087 
1088         return (signer, RecoverError.NoError);
1089     }
1090 
1091     /**
1092      * @dev Overload of {ECDSA-recover} that receives the `v`,
1093      * `r` and `s` signature fields separately.
1094      */
1095     function recover(
1096         bytes32 hash,
1097         uint8 v,
1098         bytes32 r,
1099         bytes32 s
1100     ) internal pure returns (address) {
1101         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1102         _throwError(error);
1103         return recovered;
1104     }
1105 
1106     /**
1107      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1108      * produces hash corresponding to the one signed with the
1109      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1110      * JSON-RPC method as part of EIP-191.
1111      *
1112      * See {recover}.
1113      */
1114     function toEthSignedMessageHash(bytes32 hash)
1115         internal
1116         pure
1117         returns (bytes32)
1118     {
1119         // 32 is the length in bytes of hash,
1120         // enforced by the type signature above
1121         return
1122             keccak256(
1123                 abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
1124             );
1125     }
1126 
1127     /**
1128      * @dev Returns an Ethereum Signed Message, created from `s`. This
1129      * produces hash corresponding to the one signed with the
1130      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1131      * JSON-RPC method as part of EIP-191.
1132      *
1133      * See {recover}.
1134      */
1135     function toEthSignedMessageHash(bytes memory s)
1136         internal
1137         pure
1138         returns (bytes32)
1139     {
1140         return
1141             keccak256(
1142                 abi.encodePacked(
1143                     "\x19Ethereum Signed Message:\n",
1144                     Strings.toString(s.length),
1145                     s
1146                 )
1147             );
1148     }
1149 
1150     /**
1151      * @dev Returns an Ethereum Signed Typed Data, created from a
1152      * `domainSeparator` and a `structHash`. This produces hash corresponding
1153      * to the one signed with the
1154      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1155      * JSON-RPC method as part of EIP-712.
1156      *
1157      * See {recover}.
1158      */
1159     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash)
1160         internal
1161         pure
1162         returns (bytes32)
1163     {
1164         return
1165             keccak256(
1166                 abi.encodePacked("\x19\x01", domainSeparator, structHash)
1167             );
1168     }
1169 }
1170 pragma solidity ^0.8.0;
1171 
1172 
1173 
1174 
1175 
1176 
1177 
1178 
1179 
1180 
1181 
1182 
1183 
1184 contract ArtAI is Context, ERC165, IERC721, IERC721Metadata, Ownable, Pausable {
1185     /**
1186      * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1187      * the Metadata extension, but not including the Enumerable extension, which is available separately as
1188      * {ERC721Enumerable}.
1189      */
1190 
1191     using Address for address;
1192     using Strings for uint256;
1193     using ECDSA for bytes;
1194 
1195     event Burn(
1196         address indexed owner,
1197         uint256 indexed tokenId1,
1198         uint256 indexed tokenId2
1199     );
1200     event Extend(
1201         address owner,
1202         uint256 tokenId,
1203         string oldHash,
1204         string newHash,
1205         string oldName,
1206         string newName,
1207         string oldId,
1208         string newId
1209     );
1210 
1211     // Max total supply
1212     uint256 public maxSupply = 5000;
1213     // Max painting name length
1214     uint256 private _maxImageNameLength = 100;
1215     // purchase price
1216     uint256 public _purchasePrice = 50000000000000000 wei;
1217     // public signer address
1218     address private _messageSigner;
1219     // graveyard address
1220     address private _graveyardAddress =
1221         0x000000000000000000000000000000000000dEaD;
1222     // price in burn tokens for a mint
1223     uint256 private _mintCostInBurnTokens = 1;
1224     // Gen 1 Address
1225     address private _gen1Address = 0xaA20f900e24cA7Ed897C44D92012158f436ef791;
1226 
1227     // Paintbrush ERC20 address
1228     address private _paintbrushAddress;
1229 
1230     // baseURI for Metadata
1231     string private _metadataURI = "https://art-ai.com/api/gen2/metadata/";
1232 
1233     // Min Paintbrush balance to extend
1234     uint256 public _minPaintbrushesToExtend;
1235 
1236     // Token name
1237     string private _name;
1238 
1239     // Token symbol
1240     string private _symbol;
1241 
1242     // Token supply
1243     uint256 public _tokenSupply;
1244 
1245     // Mapping from token ID to owner address
1246     mapping(uint256 => address) private _owners;
1247 
1248     // Mapping owner address to token count
1249     mapping(address => uint256) private _balances;
1250 
1251     // Mapping from token ID to approved address
1252     mapping(uint256 => address) private _tokenApprovals;
1253 
1254     // Mapping from owner to operator approvals
1255     mapping(address => mapping(address => bool)) private _operatorApprovals;
1256 
1257     // Mapping from image name to its purchased status
1258     mapping(string => bool) private _namePurchases;
1259 
1260     // Mapping from image name to its token id
1261     mapping(string => uint256) private _nameToTokenId;
1262 
1263     // Token Id to image hash
1264     mapping(uint256 => string) private _tokenImageHashes;
1265 
1266     // Token Id to image name
1267     mapping(uint256 => string) private _tokenIdToName;
1268 
1269     // Token Id to image id
1270     mapping(uint256 => string) private _tokenIdToImageId;
1271 
1272     // Status of signed messages
1273     mapping(bytes => bool) private _usedSignedMessages;
1274 
1275     // used IPFS hashes
1276     mapping(string => bool) private _usedIPFSHashes;
1277 
1278     // used image IDs
1279     mapping(string => bool) private _usedImageIds;
1280 
1281     // Burn counts 'tokens' for addresses
1282     mapping(address => uint256) private _burnTokens;
1283 
1284     // Gen 1 Available names for address
1285     mapping(address => mapping(string => bool)) private _availableBurnedNames;
1286 
1287     // Gen 2 available names for a token id
1288     mapping(uint256 => mapping(string => bool)) private _availableExtendedNames;
1289 
1290     /**
1291      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1292      */
1293     constructor(string memory name_, string memory symbol_) {
1294         _name = name_;
1295         _symbol = symbol_;
1296     }
1297 
1298     function isExtensionNameAvailableForToken(
1299         uint256 _tokenId,
1300         string memory _imageName
1301     ) external view returns (bool) {
1302         return _availableExtendedNames[_tokenId][_imageName];
1303     }
1304 
1305     function isNameAvailableForAddress(
1306         address _address,
1307         string memory _imageName
1308     ) external view returns (bool) {
1309         return _availableBurnedNames[_address][_imageName];
1310     }
1311 
1312     function setPaintbrushAddress(address newAddress) external onlyOwner {
1313         _paintbrushAddress = newAddress;
1314     }
1315 
1316     function setMinPaintbrushesToExtend(uint256 amount) external onlyOwner {
1317         _minPaintbrushesToExtend = amount;
1318     }
1319 
1320     function setGen1Address(address newAddress) external onlyOwner {
1321         _gen1Address = newAddress;
1322     }
1323 
1324     function tokenIdForName(string memory _paintingName)
1325         external
1326         view
1327         returns (uint256)
1328     {
1329         return _nameToTokenId[_paintingName];
1330     }
1331 
1332     function setBaseURI(string memory newURI) external onlyOwner {
1333         _metadataURI = newURI;
1334     }
1335 
1336     function setPurchasePrice(uint256 newPrice) external onlyOwner {
1337         _purchasePrice = newPrice;
1338     }
1339 
1340     function totalSupply() external view returns (uint256) {
1341         return maxSupply;
1342     }
1343 
1344     function setMessageSigner(address newSigner) external onlyOwner {
1345         _messageSigner = newSigner;
1346     }
1347 
1348     function burnTokenBalance(address owner) public view returns (uint256) {
1349         return _burnTokens[owner];
1350     }
1351 
1352     function lockMinting() external onlyOwner {
1353         maxSupply = _tokenSupply;
1354         _closeMinting();
1355     }
1356 
1357     function _burn(uint256 _tokenId1, uint256 _tokenId2) private {
1358         IArtAI(_gen1Address).safeTransferFrom(
1359             msg.sender,
1360             _graveyardAddress,
1361             _tokenId1
1362         );
1363         IArtAI(_gen1Address).safeTransferFrom(
1364             msg.sender,
1365             _graveyardAddress,
1366             _tokenId2
1367         );
1368         (, string memory _name1, ) = IArtAI(_gen1Address).tokenInfo(_tokenId1);
1369         (, string memory _name2, ) = IArtAI(_gen1Address).tokenInfo(_tokenId2);
1370 
1371         _availableBurnedNames[msg.sender][_name1] = true;
1372         _availableBurnedNames[msg.sender][_name2] = true;
1373         _burnTokens[msg.sender] += 1;
1374 
1375         emit Burn(msg.sender, _tokenId1, _tokenId2);
1376     }
1377 
1378     function _verifyName(string memory _imageName) private view returns (bool) {
1379         if (_namePurchases[_imageName]) {
1380             return false;
1381         }
1382         if (IArtAI(_gen1Address).tokenIdForName(_imageName) != 0) {
1383             return _availableBurnedNames[msg.sender][_imageName];
1384         }
1385         return true;
1386     }
1387 
1388     function _verifyName(string memory _imageName, uint256 _tokenId)
1389         private
1390         view
1391         returns (bool)
1392     {
1393         if (_availableExtendedNames[_tokenId][_imageName]) {
1394             return true;
1395         }
1396         return _verifyName(_imageName);
1397     }
1398 
1399     function _mint(
1400         address _owner,
1401         string memory _imageName,
1402         string memory _imageHash,
1403         string memory _imageId,
1404         bytes memory _signedMessage
1405     ) private returns (uint256) {
1406         uint256 _newTokenId = _tokenSupply + 1;
1407 
1408         _safeMint(_owner, _newTokenId);
1409         _updateStoredValues(
1410             _imageName,
1411             _imageHash,
1412             _imageId,
1413             _signedMessage,
1414             _newTokenId
1415         );
1416         _burnTokens[msg.sender] -= 1;
1417 
1418         return _newTokenId;
1419     }
1420 
1421     function _verifySignedMessage(
1422         string memory _imageHash,
1423         string memory _imageId,
1424         string memory _imageName,
1425         bytes memory _signedMessage
1426     ) internal returns (bool) {
1427         if (_usedSignedMessages[_signedMessage]) {
1428             return false;
1429         }
1430 
1431         bytes32 _message = ECDSA.toEthSignedMessageHash(
1432             abi.encodePacked(_imageId, _imageHash, _imageName)
1433         );
1434 
1435         address signer = ECDSA.recover(_message, _signedMessage);
1436 
1437         if (signer != _messageSigner) {
1438             return false;
1439         }
1440 
1441         _usedSignedMessages[_signedMessage] = true;
1442         return true;
1443     }
1444 
1445     function _verifyParams(
1446         string memory _imageName,
1447         string memory _imageHash,
1448         string memory _imageId,
1449         bytes memory _signedMessage
1450     ) internal {
1451         require(!_usedImageIds[_imageId], "ImageID");
1452         require(!_usedIPFSHashes[_imageHash], "IPFS hash");
1453         require(bytes(_imageName).length <= _maxImageNameLength, "Name");
1454         require(msg.value >= _purchasePrice, "value");
1455         require(_verifyName(_imageName), "name purchased");
1456         require(
1457             _verifySignedMessage(
1458                 _imageHash,
1459                 _imageId,
1460                 _imageName,
1461                 _signedMessage
1462             ),
1463             "Signature"
1464         );
1465     }
1466 
1467     function _verifyParams(
1468         string memory _imageName,
1469         string memory _imageHash,
1470         string memory _imageId,
1471         bytes memory _signedMessage,
1472         uint256 _tokenId
1473     ) internal {
1474         require(!_usedImageIds[_imageId], "ImageID");
1475         require(!_usedIPFSHashes[_imageHash], "IPFS hash");
1476         require(bytes(_imageName).length <= _maxImageNameLength, "Name");
1477         require(msg.value >= _purchasePrice, "value");
1478         require(_verifyName(_imageName, _tokenId), "name purchased");
1479         require(
1480             _verifySignedMessage(
1481                 _imageHash,
1482                 _imageId,
1483                 _imageName,
1484                 _signedMessage
1485             ),
1486             "Signature"
1487         );
1488     }
1489 
1490     function _updateStoredValues(
1491         string memory _imageName,
1492         string memory _imageHash,
1493         string memory _imageId,
1494         bytes memory _signedMessage,
1495         uint256 _tokenId
1496     ) private {
1497         _namePurchases[_imageName] = true;
1498         _usedSignedMessages[_signedMessage] = true;
1499         _usedImageIds[_imageId] = true;
1500         _usedIPFSHashes[_imageHash] = true;
1501         _availableExtendedNames[_tokenId][_imageName] = true;
1502 
1503         _nameToTokenId[_imageName] = _tokenId;
1504         _tokenImageHashes[_tokenId] = _imageHash;
1505         _tokenIdToName[_tokenId] = _imageName;
1506         _tokenIdToImageId[_tokenId] = _imageId;
1507     }
1508 
1509     function _extend(
1510         uint256 _tokenId,
1511         string memory _imageHash,
1512         string memory _imageName,
1513         string memory _imageId,
1514         bytes memory _signedMessage
1515     ) private {
1516         string memory oldHash = _tokenImageHashes[_tokenId];
1517         string memory oldName = _tokenIdToName[_tokenId];
1518         string memory oldId = _tokenIdToImageId[_tokenId];
1519 
1520         _updateStoredValues(
1521             _imageName,
1522             _imageHash,
1523             _imageId,
1524             _signedMessage,
1525             _tokenId
1526         );
1527 
1528         emit Extend(
1529             msg.sender,
1530             _tokenId,
1531             oldHash,
1532             _imageHash,
1533             oldName,
1534             _imageName,
1535             oldId,
1536             _imageId
1537         );
1538     }
1539 
1540     function extend(
1541         uint256 _tokenId,
1542         string memory _imageHash,
1543         string memory _imageName,
1544         string memory _imageId,
1545         bytes memory _signedMessage
1546     ) external payable whenExtendingOpen {
1547         require(ownerOf(_tokenId) == msg.sender, "Ownership");
1548         require(
1549             IERC721(_gen1Address).balanceOf(msg.sender) > 0 ||
1550                 IERC20(_paintbrushAddress).balanceOf(msg.sender) >=
1551                 _minPaintbrushesToExtend,
1552             "Balance"
1553         );
1554         _verifyParams(
1555             _imageName,
1556             _imageHash,
1557             _imageId,
1558             _signedMessage,
1559             _tokenId
1560         );
1561 
1562         _extend(_tokenId, _imageHash, _imageName, _imageId, _signedMessage);
1563     }
1564 
1565     function burn(uint256 _tokenId1, uint256 _tokenId2)
1566         external
1567         whenMintingOpen
1568     {
1569         require(_tokenId1 != _tokenId2, "same tokens");
1570         IERC721 iface = IERC721(_gen1Address);
1571         require(iface.ownerOf(_tokenId1) == msg.sender, "Ownership");
1572         require(iface.ownerOf(_tokenId2) == msg.sender, "Ownership");
1573         require(
1574             iface.isApprovedForAll(msg.sender, address(this)),
1575             "transfer perms"
1576         );
1577 
1578         _burn(_tokenId1, _tokenId2);
1579     }
1580 
1581     function mint(
1582         string memory _imageHash,
1583         string memory _imageName,
1584         string memory _imageId,
1585         bytes memory _signedMessage
1586     ) external payable whenMintingOpen returns (uint256) {
1587         require(_tokenSupply < maxSupply, "Maximum supply");
1588         require(
1589             _burnTokens[msg.sender] >= _mintCostInBurnTokens,
1590             "burn tokens"
1591         );
1592         _verifyParams(_imageName, _imageHash, _imageId, _signedMessage);
1593         uint256 _newTokenId = _mint(
1594             msg.sender,
1595             _imageName,
1596             _imageHash,
1597             _imageId,
1598             _signedMessage
1599         );
1600 
1601         return _newTokenId;
1602     }
1603 
1604     function tokenInfo(uint256 _tokenId)
1605         external
1606         view
1607         returns (
1608             string memory _imageHash,
1609             string memory _imageName,
1610             string memory _imageId
1611         )
1612     {
1613         return (
1614             _tokenImageHashes[_tokenId],
1615             _tokenIdToName[_tokenId],
1616             _tokenIdToImageId[_tokenId]
1617         );
1618     }
1619 
1620     /**
1621      * @dev See {IERC165-supportsInterface}.
1622      */
1623     function supportsInterface(bytes4 interfaceId)
1624         public
1625         view
1626         virtual
1627         override(ERC165, IERC165)
1628         returns (bool)
1629     {
1630         return
1631             interfaceId == type(IERC721).interfaceId ||
1632             interfaceId == type(IERC721Metadata).interfaceId ||
1633             super.supportsInterface(interfaceId);
1634     }
1635 
1636     /**
1637      * @dev See {IERC721-balanceOf}.
1638      */
1639     function balanceOf(address owner)
1640         public
1641         view
1642         virtual
1643         override
1644         returns (uint256)
1645     {
1646         require(owner != address(0), "ERC721: zero address");
1647         return _balances[owner];
1648     }
1649 
1650     /**
1651      * @dev See {IERC721-ownerOf}.
1652      */
1653     function ownerOf(uint256 tokenId)
1654         public
1655         view
1656         virtual
1657         override
1658         returns (address)
1659     {
1660         address owner = _owners[tokenId];
1661         require(owner != address(0), "ERC721: nonexistent token");
1662         return owner;
1663     }
1664 
1665     /**
1666      * @dev See {IERC721Metadata-name}.
1667      */
1668     function name() public view virtual override returns (string memory) {
1669         return _name;
1670     }
1671 
1672     /**
1673      * @dev See {IERC721Metadata-symbol}.
1674      */
1675     function symbol() public view virtual override returns (string memory) {
1676         return _symbol;
1677     }
1678 
1679     /**
1680      * @dev See {IERC721Metadata-tokenURI}.
1681      */
1682     function tokenURI(uint256 tokenId)
1683         public
1684         view
1685         virtual
1686         override
1687         returns (string memory)
1688     {
1689         require(_exists(tokenId), "ERC721Metadata: nonexistent token");
1690 
1691         string memory baseURI = _baseURI();
1692         return
1693             bytes(baseURI).length > 0
1694                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1695                 : "";
1696     }
1697 
1698     /**
1699      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1700      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1701      * by default, can be overriden in child contracts.
1702      */
1703     function _baseURI() internal view virtual returns (string memory) {
1704         return _metadataURI;
1705     }
1706 
1707     /**
1708      * @dev See {IERC721-approve}.
1709      */
1710     function approve(address to, uint256 tokenId) public virtual override {
1711         address owner = ArtAI.ownerOf(tokenId);
1712         require(to != owner, "ERC721: current owner");
1713 
1714         require(
1715             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1716             "ERC721: approve caller is not owner nor approved for all"
1717         );
1718 
1719         _approve(to, tokenId);
1720     }
1721 
1722     /**
1723      * @dev See {IERC721-getApproved}.
1724      */
1725     function getApproved(uint256 tokenId)
1726         public
1727         view
1728         virtual
1729         override
1730         returns (address)
1731     {
1732         require(_exists(tokenId), "ERC721: nonexistent token");
1733 
1734         return _tokenApprovals[tokenId];
1735     }
1736 
1737     /**
1738      * @dev See {IERC721-setApprovalForAll}.
1739      */
1740     function setApprovalForAll(address operator, bool approved)
1741         public
1742         virtual
1743         override
1744     {
1745         require(operator != _msgSender(), "ERC721: approve to caller");
1746 
1747         _operatorApprovals[_msgSender()][operator] = approved;
1748         emit ApprovalForAll(_msgSender(), operator, approved);
1749     }
1750 
1751     /**
1752      * @dev See {IERC721-isApprovedForAll}.
1753      */
1754     function isApprovedForAll(address owner, address operator)
1755         public
1756         view
1757         virtual
1758         override
1759         returns (bool)
1760     {
1761         return _operatorApprovals[owner][operator];
1762     }
1763 
1764     /**
1765      * @dev See {IERC721-transferFrom}.
1766      */
1767     function transferFrom(
1768         address from,
1769         address to,
1770         uint256 tokenId
1771     ) public virtual override {
1772         //solhint-disable-next-line max-line-length
1773         require(
1774             _isApprovedOrOwner(_msgSender(), tokenId),
1775             "ERC721: not owner nor approved"
1776         );
1777 
1778         _transfer(from, to, tokenId);
1779     }
1780 
1781     /**
1782      * @dev See {IERC721-safeTransferFrom}.
1783      */
1784     function safeTransferFrom(
1785         address from,
1786         address to,
1787         uint256 tokenId
1788     ) public virtual override {
1789         safeTransferFrom(from, to, tokenId, "");
1790     }
1791 
1792     /**
1793      * @dev See {IERC721-safeTransferFrom}.
1794      */
1795     function safeTransferFrom(
1796         address from,
1797         address to,
1798         uint256 tokenId,
1799         bytes memory _data
1800     ) public virtual override {
1801         require(
1802             _isApprovedOrOwner(_msgSender(), tokenId),
1803             "ERC721: not owner nor approved"
1804         );
1805         _safeTransfer(from, to, tokenId, _data);
1806     }
1807 
1808     /**
1809      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1810      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1811      *
1812      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1813      *
1814      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1815      * implement alternative mechanisms to perform token transfer, such as signature-based.
1816      *
1817      * Requirements:
1818      *
1819      * - `from` cannot be the zero address.
1820      * - `to` cannot be the zero address.
1821      * - `tokenId` token must exist and be owned by `from`.
1822      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1823      *
1824      * Emits a {Transfer} event.
1825      */
1826     function _safeTransfer(
1827         address from,
1828         address to,
1829         uint256 tokenId,
1830         bytes memory _data
1831     ) internal virtual {
1832         _transfer(from, to, tokenId);
1833         require(
1834             _checkOnERC721Received(from, to, tokenId, _data),
1835             "ERC721: non ERC721Receiver implementer"
1836         );
1837     }
1838 
1839     /**
1840      * @dev Returns whether `tokenId` exists.
1841      *
1842      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1843      *
1844      * Tokens start existing when they are minted (`_mint`),
1845      * and stop existing when they are burned (`_burn`).
1846      */
1847     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1848         return _owners[tokenId] != address(0);
1849     }
1850 
1851     /**
1852      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1853      *
1854      * Requirements:
1855      *
1856      * - `tokenId` must exist.
1857      */
1858     function _isApprovedOrOwner(address spender, uint256 tokenId)
1859         internal
1860         view
1861         virtual
1862         returns (bool)
1863     {
1864         require(_exists(tokenId), "ERC721: nonexistent token");
1865         address owner = ArtAI.ownerOf(tokenId);
1866         return (spender == owner ||
1867             getApproved(tokenId) == spender ||
1868             isApprovedForAll(owner, spender));
1869     }
1870 
1871     /**
1872      * @dev Safely mints `tokenId` and transfers it to `to`.
1873      *
1874      * Requirements:
1875      *
1876      * - `tokenId` must not exist.
1877      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1878      *
1879      * Emits a {Transfer} event.
1880      */
1881     function _safeMint(address to, uint256 tokenId) internal virtual {
1882         _safeMint(to, tokenId, "");
1883     }
1884 
1885     /**
1886      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1887      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1888      */
1889     function _safeMint(
1890         address to,
1891         uint256 tokenId,
1892         bytes memory _data
1893     ) internal virtual {
1894         _mint(to, tokenId);
1895         require(
1896             _checkOnERC721Received(address(0), to, tokenId, _data),
1897             "ERC721: non ERC721Receiver implementer"
1898         );
1899     }
1900 
1901     /**
1902      * @dev Mints `tokenId` and transfers it to `to`.
1903      *
1904      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1905      *
1906      * Requirements:
1907      *
1908      * - `tokenId` must not exist.
1909      * - `to` cannot be the zero address.
1910      *
1911      * Emits a {Transfer} event.
1912      */
1913     function _mint(address to, uint256 tokenId) internal virtual {
1914         require(to != address(0), "ERC721: zero address");
1915         require(!_exists(tokenId), "ERC721: token already minted");
1916 
1917         _beforeTokenTransfer(address(0), to, tokenId);
1918 
1919         _balances[to] += 1;
1920         _owners[tokenId] = to;
1921         _tokenSupply += 1;
1922 
1923         emit Transfer(address(0), to, tokenId);
1924     }
1925 
1926     /**
1927      * @dev Transfers `tokenId` from `from` to `to`.
1928      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1929      *
1930      * Requirements:
1931      *
1932      * - `to` cannot be the zero address.
1933      * - `tokenId` token must be owned by `from`.
1934      *
1935      * Emits a {Transfer} event.
1936      */
1937     function _transfer(
1938         address from,
1939         address to,
1940         uint256 tokenId
1941     ) internal virtual {
1942         require(ArtAI.ownerOf(tokenId) == from, "ERC721: not own");
1943         require(to != address(0), "ERC721: zero address");
1944 
1945         _beforeTokenTransfer(from, to, tokenId);
1946 
1947         // Clear approvals from the previous owner
1948         _approve(address(0), tokenId);
1949 
1950         _balances[from] -= 1;
1951         _balances[to] += 1;
1952         _owners[tokenId] = to;
1953 
1954         emit Transfer(from, to, tokenId);
1955     }
1956 
1957     /**
1958      * @dev Approve `to` to operate on `tokenId`
1959      *
1960      * Emits a {Approval} event.
1961      */
1962     function _approve(address to, uint256 tokenId) internal virtual {
1963         _tokenApprovals[tokenId] = to;
1964         emit Approval(ArtAI.ownerOf(tokenId), to, tokenId);
1965     }
1966 
1967     /**
1968      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1969      * The call is not executed if the target address is not a contract.
1970      *
1971      * @param from address representing the previous owner of the given token ID
1972      * @param to target address that will receive the tokens
1973      * @param tokenId uint256 ID of the token to be transferred
1974      * @param _data bytes optional data to send along with the call
1975      * @return bool whether the call correctly returned the expected magic value
1976      */
1977     function _checkOnERC721Received(
1978         address from,
1979         address to,
1980         uint256 tokenId,
1981         bytes memory _data
1982     ) private returns (bool) {
1983         if (to.isContract()) {
1984             try
1985                 IERC721Receiver(to).onERC721Received(
1986                     _msgSender(),
1987                     from,
1988                     tokenId,
1989                     _data
1990                 )
1991             returns (bytes4 retval) {
1992                 return retval == IERC721Receiver.onERC721Received.selector;
1993             } catch (bytes memory reason) {
1994                 if (reason.length == 0) {
1995                     revert("ERC721: non ERC721Receiver implementer");
1996                 } else {
1997                     assembly {
1998                         revert(add(32, reason), mload(reason))
1999                     }
2000                 }
2001             }
2002         } else {
2003             return true;
2004         }
2005     }
2006 
2007     /**
2008      * @dev Hook that is called before any token transfer. This includes minting
2009      * and burning.
2010      *
2011      * Calling conditions:
2012      *
2013      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2014      * transferred to `to`.
2015      * - When `from` is zero, `tokenId` will be minted for `to`.
2016      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2017      * - `from` and `to` are never both zero.
2018      *
2019      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2020      */
2021     function _beforeTokenTransfer(
2022         address from,
2023         address to,
2024         uint256 tokenId
2025     ) internal virtual {}
2026 }