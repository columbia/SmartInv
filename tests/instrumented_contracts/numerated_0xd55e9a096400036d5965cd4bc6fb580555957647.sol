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
238 /**
239  * @dev Interface of the ERC20 standard as defined in the EIP.
240  */
241 interface IERC20 {
242     /**
243      * @dev Returns the amount of tokens in existence.
244      */
245     function totalSupply() external view returns (uint256);
246 
247     /**
248      * @dev Returns the amount of tokens owned by `account`.
249      */
250     function balanceOf(address account) external view returns (uint256);
251 
252     /**
253      * @dev Moves `amount` tokens from the caller's account to `recipient`.
254      *
255      * Returns a boolean value indicating whether the operation succeeded.
256      *
257      * Emits a {Transfer} event.
258      */
259     function transfer(address recipient, uint256 amount)
260         external
261         returns (bool);
262 
263     /**
264      * @dev Returns the remaining number of tokens that `spender` will be
265      * allowed to spend on behalf of `owner` through {transferFrom}. This is
266      * zero by default.
267      *
268      * This value changes when {approve} or {transferFrom} are called.
269      */
270     function allowance(address owner, address spender)
271         external
272         view
273         returns (uint256);
274 
275     /**
276      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
277      *
278      * Returns a boolean value indicating whether the operation succeeded.
279      *
280      * IMPORTANT: Beware that changing an allowance with this method brings the risk
281      * that someone may use both the old and the new allowance by unfortunate
282      * transaction ordering. One possible solution to mitigate this race
283      * condition is to first reduce the spender's allowance to 0 and set the
284      * desired value afterwards:
285      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
286      *
287      * Emits an {Approval} event.
288      */
289     function approve(address spender, uint256 amount) external returns (bool);
290 
291     /**
292      * @dev Moves `amount` tokens from `sender` to `recipient` using the
293      * allowance mechanism. `amount` is then deducted from the caller's
294      * allowance.
295      *
296      * Returns a boolean value indicating whether the operation succeeded.
297      *
298      * Emits a {Transfer} event.
299      */
300     function transferFrom(
301         address sender,
302         address recipient,
303         uint256 amount
304     ) external returns (bool);
305 
306     /**
307      * @dev Emitted when `value` tokens are moved from one account (`from`) to
308      * another (`to`).
309      *
310      * Note that `value` may be zero.
311      */
312     event Transfer(address indexed from, address indexed to, uint256 value);
313 
314     /**
315      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
316      * a call to {approve}. `value` is the new allowance.
317      */
318     event Approval(
319         address indexed owner,
320         address indexed spender,
321         uint256 value
322     );
323 }
324 
325 pragma solidity ^0.8.0;
326 
327 library Random {
328     function rand1To10(uint256 seed) internal view returns (uint256) {
329         uint256 _number = (uint256(
330             keccak256(abi.encodePacked(blockhash(block.number - 1), seed))
331         ) % 10);
332         if (_number <= 0) {
333             _number = 10;
334         }
335 
336         return _number;
337     }
338 }
339 
340 pragma solidity ^0.8.0;
341 
342 /**
343  * @dev Collection of functions related to the address type
344  */
345 library Address {
346     /**
347      * @dev Returns true if `account` is a contract.
348      *
349      * [IMPORTANT]
350      * ====
351      * It is unsafe to assume that an address for which this function returns
352      * false is an externally-owned account (EOA) and not a contract.
353      *
354      * Among others, `isContract` will return false for the following
355      * types of addresses:
356      *
357      *  - an externally-owned account
358      *  - a contract in construction
359      *  - an address where a contract will be created
360      *  - an address where a contract lived, but was destroyed
361      * ====
362      */
363     function isContract(address account) internal view returns (bool) {
364         // This method relies on extcodesize, which returns 0 for contracts in
365         // construction, since the code is only stored at the end of the
366         // constructor execution.
367 
368         uint256 size;
369         assembly {
370             size := extcodesize(account)
371         }
372         return size > 0;
373     }
374 
375     function addressToString(address _addr)
376         internal
377         pure
378         returns (string memory)
379     {
380         bytes32 value = bytes32(uint256(uint160(_addr)));
381         bytes memory alphabet = "0123456789abcdef";
382 
383         bytes memory str = new bytes(42);
384         str[0] = "0";
385         str[1] = "x";
386         for (uint256 i = 0; i < 20; i++) {
387             str[2 + i * 2] = alphabet[uint256(uint8(value[i + 12] >> 4))];
388             str[3 + i * 2] = alphabet[uint256(uint8(value[i + 12] & 0x0f))];
389         }
390         return string(str);
391     }
392 
393     /**
394      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
395      * `recipient`, forwarding all available gas and reverting on errors.
396      *
397      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
398      * of certain opcodes, possibly making contracts go over the 2300 gas limit
399      * imposed by `transfer`, making them unable to receive funds via
400      * `transfer`. {sendValue} removes this limitation.
401      *
402      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
403      *
404      * IMPORTANT: because control is transferred to `recipient`, care must be
405      * taken to not create reentrancy vulnerabilities. Consider using
406      * {ReentrancyGuard} or the
407      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
408      */
409     function sendValue(address payable recipient, uint256 amount) internal {
410         require(
411             address(this).balance >= amount,
412             "Address: insufficient balance"
413         );
414 
415         (bool success, ) = recipient.call{value: amount}("");
416         require(
417             success,
418             "Address: unable to send value, recipient may have reverted"
419         );
420     }
421 
422     /**
423      * @dev Performs a Solidity function call using a low level `call`. A
424      * plain `call` is an unsafe replacement for a function call: use this
425      * function instead.
426      *
427      * If `target` reverts with a revert reason, it is bubbled up by this
428      * function (like regular Solidity function calls).
429      *
430      * Returns the raw returned data. To convert to the expected return value,
431      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
432      *
433      * Requirements:
434      *
435      * - `target` must be a contract.
436      * - calling `target` with `data` must not revert.
437      *
438      * _Available since v3.1._
439      */
440     function functionCall(address target, bytes memory data)
441         internal
442         returns (bytes memory)
443     {
444         return functionCall(target, data, "Address: low-level call failed");
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
449      * `errorMessage` as a fallback revert reason when `target` reverts.
450      *
451      * _Available since v3.1._
452      */
453     function functionCall(
454         address target,
455         bytes memory data,
456         string memory errorMessage
457     ) internal returns (bytes memory) {
458         return functionCallWithValue(target, data, 0, errorMessage);
459     }
460 
461     /**
462      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
463      * but also transferring `value` wei to `target`.
464      *
465      * Requirements:
466      *
467      * - the calling contract must have an ETH balance of at least `value`.
468      * - the called Solidity function must be `payable`.
469      *
470      * _Available since v3.1._
471      */
472     function functionCallWithValue(
473         address target,
474         bytes memory data,
475         uint256 value
476     ) internal returns (bytes memory) {
477         return
478             functionCallWithValue(
479                 target,
480                 data,
481                 value,
482                 "Address: low-level call with value failed"
483             );
484     }
485 
486     /**
487      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
488      * with `errorMessage` as a fallback revert reason when `target` reverts.
489      *
490      * _Available since v3.1._
491      */
492     function functionCallWithValue(
493         address target,
494         bytes memory data,
495         uint256 value,
496         string memory errorMessage
497     ) internal returns (bytes memory) {
498         require(
499             address(this).balance >= value,
500             "Address: insufficient balance for call"
501         );
502         require(isContract(target), "Address: call to non-contract");
503 
504         (bool success, bytes memory returndata) = target.call{value: value}(
505             data
506         );
507         return verifyCallResult(success, returndata, errorMessage);
508     }
509 
510     /**
511      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
512      * but performing a static call.
513      *
514      * _Available since v3.3._
515      */
516     function functionStaticCall(address target, bytes memory data)
517         internal
518         view
519         returns (bytes memory)
520     {
521         return
522             functionStaticCall(
523                 target,
524                 data,
525                 "Address: low-level static call failed"
526             );
527     }
528 
529     /**
530      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
531      * but performing a static call.
532      *
533      * _Available since v3.3._
534      */
535     function functionStaticCall(
536         address target,
537         bytes memory data,
538         string memory errorMessage
539     ) internal view returns (bytes memory) {
540         require(isContract(target), "Address: static call to non-contract");
541 
542         (bool success, bytes memory returndata) = target.staticcall(data);
543         return verifyCallResult(success, returndata, errorMessage);
544     }
545 
546     /**
547      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
548      * but performing a delegate call.
549      *
550      * _Available since v3.4._
551      */
552     function functionDelegateCall(address target, bytes memory data)
553         internal
554         returns (bytes memory)
555     {
556         return
557             functionDelegateCall(
558                 target,
559                 data,
560                 "Address: low-level delegate call failed"
561             );
562     }
563 
564     /**
565      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
566      * but performing a delegate call.
567      *
568      * _Available since v3.4._
569      */
570     function functionDelegateCall(
571         address target,
572         bytes memory data,
573         string memory errorMessage
574     ) internal returns (bytes memory) {
575         require(isContract(target), "Address: delegate call to non-contract");
576 
577         (bool success, bytes memory returndata) = target.delegatecall(data);
578         return verifyCallResult(success, returndata, errorMessage);
579     }
580 
581     /**
582      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
583      * revert reason using the provided one.
584      *
585      * _Available since v4.3._
586      */
587     function verifyCallResult(
588         bool success,
589         bytes memory returndata,
590         string memory errorMessage
591     ) internal pure returns (bytes memory) {
592         if (success) {
593             return returndata;
594         } else {
595             // Look for revert reason and bubble it up if present
596             if (returndata.length > 0) {
597                 // The easiest way to bubble the revert reason is using memory via assembly
598 
599                 assembly {
600                     let returndata_size := mload(returndata)
601                     revert(add(32, returndata), returndata_size)
602                 }
603             } else {
604                 revert(errorMessage);
605             }
606         }
607     }
608 }
609 
610 pragma solidity ^0.8.0;
611 
612 /**
613  * @dev Provides information about the current execution context, including the
614  * sender of the transaction and its data. While these are generally available
615  * via msg.sender and msg.data, they should not be accessed in such a direct
616  * manner, since when dealing with meta-transactions the account sending and
617  * paying for execution may not be the actual sender (as far as an application
618  * is concerned).
619  *
620  * This contract is only required for intermediate, library-like contracts.
621  */
622 abstract contract Context {
623     function _msgSender() internal view virtual returns (address) {
624         return msg.sender;
625     }
626 
627     function _msgData() internal view virtual returns (bytes calldata) {
628         return msg.data;
629     }
630 }
631 
632 pragma solidity ^0.8.0;
633 
634 /**
635  * @dev String operations.
636  */
637 library Strings {
638     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
639 
640     /**
641      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
642      */
643     function toString(uint256 value) internal pure returns (string memory) {
644         // Inspired by OraclizeAPI's implementation - MIT licence
645         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
646 
647         if (value == 0) {
648             return "0";
649         }
650         uint256 temp = value;
651         uint256 digits;
652         while (temp != 0) {
653             digits++;
654             temp /= 10;
655         }
656         bytes memory buffer = new bytes(digits);
657         while (value != 0) {
658             digits -= 1;
659             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
660             value /= 10;
661         }
662         return string(buffer);
663     }
664 
665     /**
666      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
667      */
668     function toHexString(uint256 value) internal pure returns (string memory) {
669         if (value == 0) {
670             return "0x00";
671         }
672         uint256 temp = value;
673         uint256 length = 0;
674         while (temp != 0) {
675             length++;
676             temp >>= 8;
677         }
678         return toHexString(value, length);
679     }
680 
681     /**
682      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
683      */
684     function toHexString(uint256 value, uint256 length)
685         internal
686         pure
687         returns (string memory)
688     {
689         bytes memory buffer = new bytes(2 * length + 2);
690         buffer[0] = "0";
691         buffer[1] = "x";
692         for (uint256 i = 2 * length + 1; i > 1; --i) {
693             buffer[i] = _HEX_SYMBOLS[value & 0xf];
694             value >>= 4;
695         }
696         require(value == 0, "Strings: hex length insufficient");
697         return string(buffer);
698     }
699 }
700 
701 pragma solidity ^0.8.0;
702 
703 
704 /**
705  * @dev Implementation of the {IERC165} interface.
706  *
707  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
708  * for the additional interface id that will be supported. For example:
709  *
710  * ```solidity
711  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
712  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
713  * }
714  * ```
715  *
716  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
717  */
718 abstract contract ERC165 is IERC165 {
719     /**
720      * @dev See {IERC165-supportsInterface}.
721      */
722     function supportsInterface(bytes4 interfaceId)
723         public
724         view
725         virtual
726         override
727         returns (bool)
728     {
729         return interfaceId == type(IERC165).interfaceId;
730     }
731 }
732 
733 pragma solidity ^0.8.0;
734 
735 contract Ownable {
736     address _owner;
737     address _levelTrainer;
738 
739     constructor() {
740         _owner = msg.sender;
741     }
742 
743     modifier onlyOwner() {
744         require(
745             msg.sender == _owner,
746             "Only the contract owner may call this function"
747         );
748         _;
749     }
750 
751     modifier onlyLevelTrainer() {
752         require(
753             msg.sender == _levelTrainer,
754             "Only the level trainer may call this function"
755         );
756         _;
757     }
758 
759     function owner() public view virtual returns (address) {
760         return _owner;
761     }
762 
763     function transferOwnership(address newOwner) external onlyOwner {
764         require(newOwner != address(0));
765         _owner = newOwner;
766     }
767 
768     function setLevelTrainer(address newTrainer) external onlyOwner {
769         require(newTrainer != address(0));
770         _levelTrainer = newTrainer;
771     }
772 
773     function withdrawBalance() external onlyOwner {
774         payable(_owner).transfer(address(this).balance);
775     }
776 
777     function withdrawAmountTo(address _recipient, uint256 _amount)
778         external
779         onlyOwner
780     {
781         require(address(this).balance >= _amount);
782         payable(_recipient).transfer(_amount);
783     }
784 }
785 
786 pragma solidity ^0.8.0;
787 
788 
789 
790 /**
791  * @dev Contract module which allows children to implement an emergency stop
792  * mechanism that can be triggered by an authorized account.
793  *
794  * This module is used through inheritance. It will make available the
795  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
796  * the functions of your contract. Note that they will not be pausable by
797  * simply including this module, only once the modifiers are put in place.
798  */
799 abstract contract Pausable is Context, Ownable {
800     /**
801      * @dev Emitted when the pause is triggered by `account`.
802      */
803     event Paused(address account);
804 
805     /**
806      * @dev Emitted when the pause is lifted by `account`.
807      */
808     event Unpaused(address account);
809 
810     bool private _paused;
811     bool private _whitelistIsOpen;
812     bool private _publicSaleIsOpen;
813     bool private _statsAreRevealed;
814 
815     /**
816      * @dev Initializes the contract in paused state.
817      */
818     constructor() {
819         _paused = true;
820         _whitelistIsOpen = false;
821         _publicSaleIsOpen = false;
822         _statsAreRevealed = false;
823     }
824 
825     /**
826      * @dev Returns true if the contract is paused, and false otherwise.
827      */
828     function paused() public view virtual returns (bool) {
829         return _paused;
830     }
831 
832     function statsAreRevealed() public view returns (bool) {
833         return _statsAreRevealed;
834     }
835 
836     function publicSaleIsOpen() public view returns (bool) {
837         return _publicSaleIsOpen;
838     }
839 
840     function whitelistIsOpen() public view returns (bool) {
841         return _whitelistIsOpen;
842     }
843 
844     /**
845      * @dev Modifier to make a function callable only when the contract is not paused.
846      *
847      * Requirements:
848      *
849      * - The contract must not be paused.
850      */
851     modifier whenNotPaused() {
852         require(!paused(), "Pausable: paused");
853         _;
854     }
855 
856     /**
857      * @dev Modifier to make a function callable only when the contract is paused.
858      *
859      * Requirements:
860      *
861      * - The contract must be paused.
862      */
863     modifier whenPaused() {
864         require(paused(), "Pausable: not paused");
865         _;
866     }
867 
868     function pause() external onlyOwner {
869         _pause();
870     }
871 
872     function unpause() external onlyOwner {
873         _unpause();
874     }
875 
876     function revealStats() external onlyOwner {
877         _statsAreRevealed = true;
878     }
879 
880     function openWhitelist() external onlyOwner {
881         _whitelistIsOpen = true;
882     }
883 
884     function closeWhitelist() external onlyOwner {
885         _whitelistIsOpen = false;
886     }
887 
888     function openPublicSale() external onlyOwner {
889         _publicSaleIsOpen = true;
890     }
891 
892     function closePublicSale() external onlyOwner {
893         _publicSaleIsOpen = false;
894     }
895 
896     /**
897      * @dev Triggers stopped state.
898      *
899      * Requirements:
900      *
901      * - The contract must not be paused.
902      */
903     function _pause() internal virtual whenNotPaused {
904         _paused = true;
905         emit Paused(_msgSender());
906     }
907 
908     /**
909      * @dev Returns to normal state.
910      *
911      * Requirements:
912      *
913      * - The contract must be paused.
914      */
915     function _unpause() internal virtual whenPaused {
916         _paused = false;
917         emit Unpaused(_msgSender());
918     }
919 }
920 
921 pragma solidity ^0.8.0;
922 
923 
924 /**
925  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
926  *
927  * These functions can be used to verify that a message was signed by the holder
928  * of the private keys of a given address.
929  */
930 library ECDSA {
931     enum RecoverError {
932         NoError,
933         InvalidSignature,
934         InvalidSignatureLength,
935         InvalidSignatureS,
936         InvalidSignatureV
937     }
938 
939     function _throwError(RecoverError error) private pure {
940         if (error == RecoverError.NoError) {
941             return; // no error: do nothing
942         } else if (error == RecoverError.InvalidSignature) {
943             revert("ECDSA: invalid signature");
944         } else if (error == RecoverError.InvalidSignatureLength) {
945             revert("ECDSA: invalid signature length");
946         } else if (error == RecoverError.InvalidSignatureS) {
947             revert("ECDSA: invalid signature 's' value");
948         } else if (error == RecoverError.InvalidSignatureV) {
949             revert("ECDSA: invalid signature 'v' value");
950         }
951     }
952 
953     /**
954      * @dev Returns the address that signed a hashed message (`hash`) with
955      * `signature` or error string. This address can then be used for verification purposes.
956      *
957      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
958      * this function rejects them by requiring the `s` value to be in the lower
959      * half order, and the `v` value to be either 27 or 28.
960      *
961      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
962      * verification to be secure: it is possible to craft signatures that
963      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
964      * this is by receiving a hash of the original message (which may otherwise
965      * be too long), and then calling {toEthSignedMessageHash} on it.
966      *
967      * Documentation for signature generation:
968      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
969      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
970      *
971      * _Available since v4.3._
972      */
973     function tryRecover(bytes32 hash, bytes memory signature)
974         internal
975         pure
976         returns (address, RecoverError)
977     {
978         // Check the signature length
979         // - case 65: r,s,v signature (standard)
980         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
981         if (signature.length == 65) {
982             bytes32 r;
983             bytes32 s;
984             uint8 v;
985             // ecrecover takes the signature parameters, and the only way to get them
986             // currently is to use assembly.
987             assembly {
988                 r := mload(add(signature, 0x20))
989                 s := mload(add(signature, 0x40))
990                 v := byte(0, mload(add(signature, 0x60)))
991             }
992             return tryRecover(hash, v, r, s);
993         } else if (signature.length == 64) {
994             bytes32 r;
995             bytes32 vs;
996             // ecrecover takes the signature parameters, and the only way to get them
997             // currently is to use assembly.
998             assembly {
999                 r := mload(add(signature, 0x20))
1000                 vs := mload(add(signature, 0x40))
1001             }
1002             return tryRecover(hash, r, vs);
1003         } else {
1004             return (address(0), RecoverError.InvalidSignatureLength);
1005         }
1006     }
1007 
1008     /**
1009      * @dev Returns the address that signed a hashed message (`hash`) with
1010      * `signature`. This address can then be used for verification purposes.
1011      *
1012      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1013      * this function rejects them by requiring the `s` value to be in the lower
1014      * half order, and the `v` value to be either 27 or 28.
1015      *
1016      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1017      * verification to be secure: it is possible to craft signatures that
1018      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1019      * this is by receiving a hash of the original message (which may otherwise
1020      * be too long), and then calling {toEthSignedMessageHash} on it.
1021      */
1022     function recover(bytes32 hash, bytes memory signature)
1023         internal
1024         pure
1025         returns (address)
1026     {
1027         (address recovered, RecoverError error) = tryRecover(hash, signature);
1028         _throwError(error);
1029         return recovered;
1030     }
1031 
1032     /**
1033      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1034      *
1035      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1036      *
1037      * _Available since v4.3._
1038      */
1039     function tryRecover(
1040         bytes32 hash,
1041         bytes32 r,
1042         bytes32 vs
1043     ) internal pure returns (address, RecoverError) {
1044         bytes32 s;
1045         uint8 v;
1046         assembly {
1047             s := and(
1048                 vs,
1049                 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
1050             )
1051             v := add(shr(255, vs), 27)
1052         }
1053         return tryRecover(hash, v, r, s);
1054     }
1055 
1056     /**
1057      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1058      *
1059      * _Available since v4.2._
1060      */
1061     function recover(
1062         bytes32 hash,
1063         bytes32 r,
1064         bytes32 vs
1065     ) internal pure returns (address) {
1066         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1067         _throwError(error);
1068         return recovered;
1069     }
1070 
1071     /**
1072      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1073      * `r` and `s` signature fields separately.
1074      *
1075      * _Available since v4.3._
1076      */
1077     function tryRecover(
1078         bytes32 hash,
1079         uint8 v,
1080         bytes32 r,
1081         bytes32 s
1082     ) internal pure returns (address, RecoverError) {
1083         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1084         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1085         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1086         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1087         //
1088         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1089         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1090         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1091         // these malleable signatures as well.
1092         if (
1093             uint256(s) >
1094             0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0
1095         ) {
1096             return (address(0), RecoverError.InvalidSignatureS);
1097         }
1098         if (v != 27 && v != 28) {
1099             return (address(0), RecoverError.InvalidSignatureV);
1100         }
1101 
1102         // If the signature is valid (and not malleable), return the signer address
1103         address signer = ecrecover(hash, v, r, s);
1104         if (signer == address(0)) {
1105             return (address(0), RecoverError.InvalidSignature);
1106         }
1107 
1108         return (signer, RecoverError.NoError);
1109     }
1110 
1111     /**
1112      * @dev Overload of {ECDSA-recover} that receives the `v`,
1113      * `r` and `s` signature fields separately.
1114      */
1115     function recover(
1116         bytes32 hash,
1117         uint8 v,
1118         bytes32 r,
1119         bytes32 s
1120     ) internal pure returns (address) {
1121         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1122         _throwError(error);
1123         return recovered;
1124     }
1125 
1126     /**
1127      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1128      * produces hash corresponding to the one signed with the
1129      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1130      * JSON-RPC method as part of EIP-191.
1131      *
1132      * See {recover}.
1133      */
1134     function toEthSignedMessageHash(bytes32 hash)
1135         internal
1136         pure
1137         returns (bytes32)
1138     {
1139         // 32 is the length in bytes of hash,
1140         // enforced by the type signature above
1141         return
1142             keccak256(
1143                 abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
1144             );
1145     }
1146 
1147     /**
1148      * @dev Returns an Ethereum Signed Message, created from `s`. This
1149      * produces hash corresponding to the one signed with the
1150      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1151      * JSON-RPC method as part of EIP-191.
1152      *
1153      * See {recover}.
1154      */
1155     function toEthSignedMessageHash(bytes memory s)
1156         internal
1157         pure
1158         returns (bytes32)
1159     {
1160         return
1161             keccak256(
1162                 abi.encodePacked(
1163                     "\x19Ethereum Signed Message:\n",
1164                     Strings.toString(s.length),
1165                     s
1166                 )
1167             );
1168     }
1169 
1170     /**
1171      * @dev Returns an Ethereum Signed Typed Data, created from a
1172      * `domainSeparator` and a `structHash`. This produces hash corresponding
1173      * to the one signed with the
1174      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1175      * JSON-RPC method as part of EIP-712.
1176      *
1177      * See {recover}.
1178      */
1179     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash)
1180         internal
1181         pure
1182         returns (bytes32)
1183     {
1184         return
1185             keccak256(
1186                 abi.encodePacked("\x19\x01", domainSeparator, structHash)
1187             );
1188     }
1189 }
1190 
1191 pragma solidity ^0.8.0;
1192 
1193 
1194 
1195 
1196 
1197 
1198 
1199 
1200 
1201 
1202 
1203 
1204 
1205 contract ArtAI is Context, ERC165, IERC721, IERC721Metadata, Ownable, Pausable {
1206     /**
1207      * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1208      * the Metadata extension, but not including the Enumerable extension, which is available separately as
1209      * {ERC721Enumerable}.
1210      */
1211 
1212     using Address for address;
1213     using Strings for uint256;
1214     using ECDSA for bytes;
1215 
1216     struct Hero {
1217         string name;
1218         string imageId;
1219         string imageHash;
1220         uint256 class;
1221         uint256 disposition;
1222         uint256 level;
1223         uint256 strength;
1224         uint256 dexterity;
1225         uint256 vitality;
1226         uint256 energy;
1227         bool isHonorary;
1228     }
1229     uint256 _protectedClassId;
1230 
1231     // class id to class strings
1232     string[] public _classList;
1233     // disposition id to disposition strings
1234     string[] public _dispositionList;
1235 
1236     // Max total supply
1237     uint256 public maxSupply = 10000;
1238     // Max hero name length
1239     uint256 private _maxImageNameLength = 100;
1240 
1241     // prices
1242     uint256 public _purchasePrice = 80000000000000000 wei;
1243     uint256 public _nameUpdatePrice = 5000;
1244     // public signer address
1245     address private _messageSigner;
1246 
1247     // ERC721 Addresses
1248     address private _gen1Address;
1249     address private _gen2Address;
1250 
1251     // EPO ERC20 address
1252     address private _EPOAddress;
1253     address private EPOWallet;
1254 
1255     // baseURI for Metadata
1256     string private _metadataURI = "https://art-ai.com/api/hero/metadata/";
1257 
1258     // Token name
1259     string private _name;
1260     // Token symbol
1261     string private _symbol;
1262     // Token supply
1263     uint256 public _tokenSupply;
1264 
1265     // Mapping from address to whitelist status
1266     mapping(address => bool) private _freeMintAddresses;
1267     mapping(address => bool) private _honoraryAddresses;
1268     mapping(address => bool) private _claimed;
1269     mapping(address => bool) private _claimedHonorary;
1270 
1271     // Mapping from token ID to owner address
1272     mapping(uint256 => address) private _owners;
1273 
1274     // Mapping owner address to token count
1275     mapping(address => uint256) private _balances;
1276 
1277     // Mapping from token ID to approved address
1278     mapping(uint256 => address) private _tokenApprovals;
1279 
1280     // Mapping from owner to operator approvals
1281     mapping(address => mapping(address => bool)) private _operatorApprovals;
1282 
1283     // Mapping from token id to stored Hero info
1284     mapping(uint256 => Hero) private _tokenIdToHero;
1285 
1286     // Status of signed messages
1287     mapping(bytes => bool) private _usedSignedMessages;
1288 
1289     // used IPFS hashes
1290     mapping(string => bool) private _usedIPFSHashes;
1291 
1292     // used image IDs
1293     mapping(string => bool) private _usedImageIds;
1294 
1295     // used image names
1296     mapping(string => bool) private _usedNames;
1297 
1298     constructor(
1299         string memory name_,
1300         string memory symbol_,
1301         address gen1Address_,
1302         address gen2Address_
1303     ) {
1304         _name = name_;
1305         _symbol = symbol_;
1306         _gen1Address = gen1Address_;
1307         _gen2Address = gen2Address_;
1308 
1309         _classList.push("Sorcerer");
1310         _classList.push("Warrior");
1311         _classList.push("Necromancer");
1312         _classList.push("Monk");
1313         _classList.push("Assassin");
1314         _classList.push("Druid");
1315         _classList.push("Artificer");
1316         _protectedClassId = _classList.length - 1;
1317 
1318         _dispositionList.push("Good");
1319         _dispositionList.push("Neutral");
1320         _dispositionList.push("Evil");
1321     }
1322 
1323     function levelUp(uint256 _tokenId) external onlyLevelTrainer {
1324         require(_tokenId <= maxSupply);
1325         _tokenIdToHero[_tokenId].level++;
1326     }
1327 
1328     function addDisposition(string calldata newDisposition) external onlyOwner {
1329         _dispositionList.push(newDisposition);
1330     }
1331 
1332     function addClass(string calldata newClass) external onlyOwner {
1333         _classList.push(newClass);
1334     }
1335 
1336     function setEPOWallet(address wallet) external onlyOwner {
1337         EPOWallet = wallet;
1338     }
1339 
1340     function updateNameChangePrice(uint256 newPrice) external onlyOwner {
1341         _nameUpdatePrice = newPrice;
1342     }
1343 
1344     function setEPOAddress(address newAddress) external onlyOwner {
1345         _EPOAddress = newAddress;
1346     }
1347 
1348     function setBaseURI(string calldata newURI) external onlyOwner {
1349         _metadataURI = newURI;
1350     }
1351 
1352     function setPurchasePrice(uint256 newPrice) external onlyOwner {
1353         _purchasePrice = newPrice;
1354     }
1355 
1356     function totalSupply() external view returns (uint256) {
1357         return maxSupply;
1358     }
1359 
1360     function canClaimProtectedClass(address claimant)
1361         external
1362         view
1363         returns (bool)
1364     {
1365         return _getEponymBalance(claimant) > 0;
1366     }
1367 
1368     function isNameAvailable(string calldata _imageName)
1369         external
1370         view
1371         returns (bool)
1372     {
1373         return !_usedNames[_imageName];
1374     }
1375 
1376     function hasClaimedFreeMint(address claimant) external view returns (bool) {
1377         return _claimed[claimant];
1378     }
1379 
1380     function isOnFreeMintList(address _address) external view returns (bool) {
1381         return !!_freeMintAddresses[_address];
1382     }
1383 
1384     function canClaimHonorary(address _address) external view returns (bool) {
1385         return !!_honoraryAddresses[_address] && !_claimedHonorary[_address];
1386     }
1387 
1388     function setMessageSigner(address newSigner) external onlyOwner {
1389         _messageSigner = newSigner;
1390     }
1391 
1392     function addAddressToFreeMint(address _address) external onlyOwner {
1393         _freeMintAddresses[_address] = true;
1394     }
1395 
1396     function addAddressToHonoraryList(address _address) external onlyOwner {
1397         _honoraryAddresses[_address] = true;
1398     }
1399 
1400     function addAddressesToFreeMint(address[] calldata _addressList)
1401         external
1402         onlyOwner
1403     {
1404         for (uint256 i; i < _addressList.length; i++) {
1405             _freeMintAddresses[_addressList[i]] = true;
1406         }
1407     }
1408 
1409     function removeAddressFromFreeMint(address _addressToRemove)
1410         external
1411         onlyOwner
1412     {
1413         _freeMintAddresses[_addressToRemove] = false;
1414     }
1415 
1416     function _getEponymBalance(address _owner) private view returns (uint256) {
1417         IERC721 _gen1 = IERC721(_gen1Address);
1418         IERC721 _gen2 = IERC721(_gen2Address);
1419         return _gen1.balanceOf(_owner) + _gen2.balanceOf(_owner);
1420     }
1421 
1422     function _mint(
1423         address _owner,
1424         string memory _imageName,
1425         string memory _imageHash,
1426         string memory _imageId,
1427         uint256 _classId,
1428         uint256 _dispositionId,
1429         uint256[4] memory _seeds,
1430         bytes memory _signedMessage,
1431         bool _isHonorary
1432     ) private returns (uint256) {
1433         uint256 _newTokenId = _tokenSupply + 1;
1434 
1435         _safeMint(_owner, _newTokenId);
1436         _updateStoredValues(
1437             _imageName,
1438             _imageHash,
1439             _imageId,
1440             _classId,
1441             _dispositionId,
1442             _signedMessage,
1443             _newTokenId,
1444             _seeds,
1445             _isHonorary
1446         );
1447 
1448         return _newTokenId;
1449     }
1450 
1451     function _verifyRewardProof(bytes memory _signedMessage)
1452         internal
1453         returns (bool)
1454     {
1455         if (_usedSignedMessages[_signedMessage]) {
1456             return false;
1457         }
1458 
1459         bytes32 _message = ECDSA.toEthSignedMessageHash(
1460             abi.encodePacked(_msgSender().addressToString())
1461         );
1462 
1463         address signer = ECDSA.recover(_message, _signedMessage);
1464 
1465         if (signer != _messageSigner) {
1466             return false;
1467         }
1468 
1469         _usedSignedMessages[_signedMessage] = true;
1470         return true;
1471     }
1472 
1473     function _verifySignedMessage(
1474         string memory _imageName,
1475         string memory _imageHash,
1476         string memory _imageId,
1477         uint256 _classId,
1478         uint256 _dispositionId,
1479         uint256[4] memory _seeds,
1480         bytes memory _signedMessage
1481     ) internal returns (bool) {
1482         if (_usedSignedMessages[_signedMessage]) {
1483             return false;
1484         }
1485 
1486         string memory seedString = string(
1487             abi.encodePacked(
1488                 _seeds[0].toString(),
1489                 _seeds[1].toString(),
1490                 _seeds[2].toString(),
1491                 _seeds[3].toString()
1492             )
1493         );
1494         bytes32 _message = ECDSA.toEthSignedMessageHash(
1495             abi.encodePacked(
1496                 _imageName,
1497                 _imageId,
1498                 _imageHash,
1499                 _classId.toString(),
1500                 _dispositionId.toString(),
1501                 seedString
1502             )
1503         );
1504 
1505         address signer = ECDSA.recover(_message, _signedMessage);
1506 
1507         if (signer != _messageSigner) {
1508             return false;
1509         }
1510 
1511         _usedSignedMessages[_signedMessage] = true;
1512         return true;
1513     }
1514 
1515     function _verifyClass(uint256 _classId) internal view returns (bool) {
1516         require(_classId < _classList.length, "class id");
1517         bool ownsEponym = _getEponymBalance(_msgSender()) > 0;
1518         if (_classId == _protectedClassId && !ownsEponym) {
1519             return false;
1520         }
1521 
1522         return true;
1523     }
1524 
1525     function _verifyParams(
1526         string memory _imageName,
1527         string memory _imageHash,
1528         string memory _imageId,
1529         uint256 _classId,
1530         uint256 _dispositionId,
1531         uint256[4] memory _seeds,
1532         bytes memory _signedMessage
1533     ) internal {
1534         require(bytes(_imageName).length <= _maxImageNameLength, "len");
1535         require(!_usedNames[_imageName], "name");
1536         require(!_usedImageIds[_imageId], "id");
1537         require(!_usedIPFSHashes[_imageHash], "hash");
1538         require(_verifyClass(_classId), "class");
1539         require(_dispositionId < _dispositionList.length, "disp");
1540         require(
1541             _verifySignedMessage(
1542                 _imageName,
1543                 _imageHash,
1544                 _imageId,
1545                 _classId,
1546                 _dispositionId,
1547                 _seeds,
1548                 _signedMessage
1549             ),
1550             "signature"
1551         );
1552     }
1553 
1554     function _updateStoredValues(
1555         string memory _imageName,
1556         string memory _imageHash,
1557         string memory _imageId,
1558         uint256 _classId,
1559         uint256 _dispositionId,
1560         bytes memory _signedMessage,
1561         uint256 _tokenId,
1562         uint256[4] memory _seeds,
1563         bool _isHonorary
1564     ) private {
1565         _usedSignedMessages[_signedMessage] = true;
1566         _usedImageIds[_imageId] = true;
1567         _usedIPFSHashes[_imageHash] = true;
1568         _usedNames[_imageName] = true;
1569 
1570         Hero memory _newHero = Hero(
1571             _imageName,
1572             _imageId,
1573             _imageHash,
1574             _classId,
1575             _dispositionId,
1576             1,
1577             Random.rand1To10(_seeds[0]),
1578             Random.rand1To10(_seeds[1]),
1579             Random.rand1To10(_seeds[2]),
1580             Random.rand1To10(_seeds[3]),
1581             _isHonorary
1582         );
1583 
1584         _tokenIdToHero[_tokenId] = _newHero;
1585     }
1586 
1587     function _isMintAvailable(
1588         address _user,
1589         uint256 _whitelistAllocation,
1590         bytes memory _whitelistMessage
1591     ) private view returns (bool) {
1592         if (publicSaleIsOpen()) {
1593             return true;
1594         }
1595 
1596         if (whitelistIsOpen()) {
1597             bytes32 _message = ECDSA.toEthSignedMessageHash(
1598                 abi.encodePacked(
1599                     _user.addressToString(),
1600                     _whitelistAllocation.toString()
1601                 )
1602             );
1603             address signer = ECDSA.recover(_message, _whitelistMessage);
1604             if (
1605                 balanceOf(_user) < _whitelistAllocation &&
1606                 signer == _messageSigner
1607             ) {
1608                 return true;
1609             }
1610 
1611             return false;
1612         }
1613 
1614         return false;
1615     }
1616 
1617     function _verifyHonorary(bool _isHonorary) private returns (bool) {
1618         if (!_isHonorary) {
1619             return true;
1620         }
1621 
1622         if (
1623             !!_honoraryAddresses[_msgSender()] &&
1624             !_claimedHonorary[_msgSender()]
1625         ) {
1626             _claimedHonorary[_msgSender()] = true;
1627             return true;
1628         }
1629 
1630         return false;
1631     }
1632 
1633     function _checkFreeElligibility(bytes memory _signedRewardProof)
1634         private
1635         returns (bool)
1636     {
1637         return
1638             _verifyRewardProof(_signedRewardProof) ||
1639             _freeMintAddresses[_msgSender()];
1640     }
1641 
1642     function updateImageName(string memory _newImageName, uint256 _tokenId)
1643         external
1644         whenNotPaused
1645     {
1646         IERC20 epoToken = IERC20(_EPOAddress);
1647         require(ownerOf(_tokenId) == _msgSender());
1648         require(
1649             epoToken.balanceOf(_msgSender()) >= _nameUpdatePrice,
1650             "epo bal"
1651         );
1652         require(
1653             epoToken.allowance(_msgSender(), address(this)) >= _nameUpdatePrice,
1654             "allowance"
1655         );
1656         require(bytes(_newImageName).length <= _maxImageNameLength, "length");
1657         require(!_usedNames[_newImageName], "used");
1658 
1659         epoToken.transferFrom(_msgSender(), EPOWallet, _nameUpdatePrice);
1660         Hero storage _tokenInfo = _tokenIdToHero[_tokenId];
1661         _usedNames[_tokenInfo.name] = false;
1662         _usedNames[_newImageName] = true;
1663         _tokenInfo.name = _newImageName;
1664     }
1665 
1666     function ownerMint(
1667         string memory _imageName,
1668         string memory _imageHash,
1669         string memory _imageId,
1670         uint256 _classId,
1671         uint256 _dispositionId,
1672         uint256[4] memory _seeds,
1673         address _recipient,
1674         bool _isHonorary
1675     ) external onlyOwner returns (uint256) {
1676         require(_tokenSupply < maxSupply, "max supply");
1677         require(_classId < _classList.length, "class");
1678         require(_dispositionId < _dispositionList.length, "disp");
1679         bytes memory _message = bytes(_imageName);
1680         uint256 _newTokenId = _mint(
1681             _recipient,
1682             _imageName,
1683             _imageHash,
1684             _imageId,
1685             _classId,
1686             _dispositionId,
1687             _seeds,
1688             _message,
1689             _isHonorary
1690         );
1691 
1692         return _newTokenId;
1693     }
1694 
1695     function mint(
1696         string memory _imageName,
1697         string memory _imageHash,
1698         string memory _imageId,
1699         uint256 _classId,
1700         uint256 _dispositionId,
1701         uint256[4] memory _seeds,
1702         bytes memory _signedMessage,
1703         bytes memory _whitelistMessage,
1704         uint256 _whitelistAllocation,
1705         bool _isHonorary
1706     ) external payable whenNotPaused returns (uint256) {
1707         require(!msg.sender.isContract(), "contract");
1708         require(_verifyHonorary(_isHonorary), "honorary");
1709         require(msg.value >= _purchasePrice, "price");
1710         require(
1711             _isMintAvailable(
1712                 _msgSender(),
1713                 _whitelistAllocation,
1714                 _whitelistMessage
1715             ),
1716             "mint"
1717         );
1718         require(_tokenSupply < maxSupply, "max supply");
1719 
1720         _verifyParams(
1721             _imageName,
1722             _imageHash,
1723             _imageId,
1724             _classId,
1725             _dispositionId,
1726             _seeds,
1727             _signedMessage
1728         );
1729         uint256 _newTokenId = _mint(
1730             msg.sender,
1731             _imageName,
1732             _imageHash,
1733             _imageId,
1734             _classId,
1735             _dispositionId,
1736             _seeds,
1737             _signedMessage,
1738             _isHonorary
1739         );
1740 
1741         return _newTokenId;
1742     }
1743 
1744     function rewardMint(
1745         string memory _imageName,
1746         string memory _imageHash,
1747         string memory _imageId,
1748         uint256 _classId,
1749         uint256 _dispositionId,
1750         uint256[4] memory _seeds,
1751         bytes memory _signedMessage,
1752         bytes memory _signedRewardProof,
1753         bool _isHonorary
1754     ) external payable whenNotPaused returns (uint256) {
1755         require(!msg.sender.isContract(), "contract");
1756         require(_tokenSupply < maxSupply, "max supply");
1757         require(_verifyHonorary(_isHonorary), "honorary");
1758         require(!_claimed[_msgSender()], "claim");
1759         require(_checkFreeElligibility(_signedRewardProof), "elligible");
1760         _verifyParams(
1761             _imageName,
1762             _imageHash,
1763             _imageId,
1764             _classId,
1765             _dispositionId,
1766             _seeds,
1767             _signedMessage
1768         );
1769 
1770         _claimed[_msgSender()] = true;
1771         uint256 _newTokenId = _mint(
1772             _msgSender(),
1773             _imageName,
1774             _imageHash,
1775             _imageId,
1776             _classId,
1777             _dispositionId,
1778             _seeds,
1779             _signedMessage,
1780             _isHonorary
1781         );
1782 
1783         return _newTokenId;
1784     }
1785 
1786     function tokenInfo(uint256 _tokenId)
1787         external
1788         view
1789         returns (
1790             string memory tokenName,
1791             string memory imageId,
1792             string memory imageHash,
1793             string memory class,
1794             string memory disposition,
1795             uint256 level,
1796             uint256 strength,
1797             uint256 dexterity,
1798             uint256 vitality,
1799             uint256 energy,
1800             bool isHonorary
1801         )
1802     {
1803         Hero memory _hero = _tokenIdToHero[_tokenId];
1804         if (statsAreRevealed()) {
1805             return (
1806                 _hero.name,
1807                 _hero.imageId,
1808                 _hero.imageHash,
1809                 _classList[_hero.class],
1810                 _dispositionList[_hero.disposition],
1811                 _hero.level,
1812                 _hero.strength,
1813                 _hero.dexterity,
1814                 _hero.vitality,
1815                 _hero.energy,
1816                 _hero.isHonorary
1817             );
1818         }
1819 
1820         return (
1821             _hero.name,
1822             _hero.imageId,
1823             _hero.imageHash,
1824             _classList[_hero.class],
1825             _dispositionList[_hero.disposition],
1826             _hero.level,
1827             0,
1828             0,
1829             0,
1830             0,
1831             _hero.isHonorary
1832         );
1833     }
1834 
1835     /**
1836      * @dev See {IERC165-supportsInterface}.
1837      */
1838     function supportsInterface(bytes4 interfaceId)
1839         public
1840         view
1841         virtual
1842         override(ERC165, IERC165)
1843         returns (bool)
1844     {
1845         return
1846             interfaceId == type(IERC721).interfaceId ||
1847             interfaceId == type(IERC721Metadata).interfaceId ||
1848             super.supportsInterface(interfaceId);
1849     }
1850 
1851     /**
1852      * @dev See {IERC721-balanceOf}.
1853      */
1854     function balanceOf(address owner)
1855         public
1856         view
1857         virtual
1858         override
1859         returns (uint256)
1860     {
1861         require(owner != address(0), "ERC721: zero address");
1862         return _balances[owner];
1863     }
1864 
1865     /**
1866      * @dev See {IERC721-ownerOf}.
1867      */
1868     function ownerOf(uint256 tokenId)
1869         public
1870         view
1871         virtual
1872         override
1873         returns (address)
1874     {
1875         address owner = _owners[tokenId];
1876         require(owner != address(0), "ERC721: nonexistent token");
1877         return owner;
1878     }
1879 
1880     /**
1881      * @dev See {IERC721Metadata-name}.
1882      */
1883     function name() public view virtual override returns (string memory) {
1884         return _name;
1885     }
1886 
1887     /**
1888      * @dev See {IERC721Metadata-symbol}.
1889      */
1890     function symbol() public view virtual override returns (string memory) {
1891         return _symbol;
1892     }
1893 
1894     /**
1895      * @dev See {IERC721Metadata-tokenURI}.
1896      */
1897     function tokenURI(uint256 tokenId)
1898         public
1899         view
1900         virtual
1901         override
1902         returns (string memory)
1903     {
1904         require(_exists(tokenId), "ERC721Metadata: nonexistent token");
1905 
1906         string memory baseURI = _baseURI();
1907         return
1908             bytes(baseURI).length > 0
1909                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1910                 : "";
1911     }
1912 
1913     /**
1914      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1915      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1916      * by default, can be overriden in child contracts.
1917      */
1918     function _baseURI() internal view virtual returns (string memory) {
1919         return _metadataURI;
1920     }
1921 
1922     /**
1923      * @dev See {IERC721-approve}.
1924      */
1925     function approve(address to, uint256 tokenId) public virtual override {
1926         address owner = ArtAI.ownerOf(tokenId);
1927         require(to != owner, "ERC721: current owner");
1928 
1929         require(
1930             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1931             "ERC721: approve caller is not owner nor approved for all"
1932         );
1933 
1934         _approve(to, tokenId);
1935     }
1936 
1937     /**
1938      * @dev See {IERC721-getApproved}.
1939      */
1940     function getApproved(uint256 tokenId)
1941         public
1942         view
1943         virtual
1944         override
1945         returns (address)
1946     {
1947         require(_exists(tokenId), "ERC721: nonexistent token");
1948 
1949         return _tokenApprovals[tokenId];
1950     }
1951 
1952     /**
1953      * @dev See {IERC721-setApprovalForAll}.
1954      */
1955     function setApprovalForAll(address operator, bool approved)
1956         public
1957         virtual
1958         override
1959     {
1960         require(operator != _msgSender(), "ERC721: approve to caller");
1961 
1962         _operatorApprovals[_msgSender()][operator] = approved;
1963         emit ApprovalForAll(_msgSender(), operator, approved);
1964     }
1965 
1966     /**
1967      * @dev See {IERC721-isApprovedForAll}.
1968      */
1969     function isApprovedForAll(address owner, address operator)
1970         public
1971         view
1972         virtual
1973         override
1974         returns (bool)
1975     {
1976         return _operatorApprovals[owner][operator];
1977     }
1978 
1979     /**
1980      * @dev See {IERC721-transferFrom}.
1981      */
1982     function transferFrom(
1983         address from,
1984         address to,
1985         uint256 tokenId
1986     ) public virtual override {
1987         //solhint-disable-next-line max-line-length
1988         require(
1989             _isApprovedOrOwner(_msgSender(), tokenId),
1990             "ERC721: not owner nor approved"
1991         );
1992 
1993         _transfer(from, to, tokenId);
1994     }
1995 
1996     /**
1997      * @dev See {IERC721-safeTransferFrom}.
1998      */
1999     function safeTransferFrom(
2000         address from,
2001         address to,
2002         uint256 tokenId
2003     ) public virtual override {
2004         safeTransferFrom(from, to, tokenId, "");
2005     }
2006 
2007     /**
2008      * @dev See {IERC721-safeTransferFrom}.
2009      */
2010     function safeTransferFrom(
2011         address from,
2012         address to,
2013         uint256 tokenId,
2014         bytes memory _data
2015     ) public virtual override {
2016         require(
2017             _isApprovedOrOwner(_msgSender(), tokenId),
2018             "ERC721: not owner nor approved"
2019         );
2020         _safeTransfer(from, to, tokenId, _data);
2021     }
2022 
2023     /**
2024      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
2025      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
2026      *
2027      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
2028      *
2029      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
2030      * implement alternative mechanisms to perform token transfer, such as signature-based.
2031      *
2032      * Requirements:
2033      *
2034      * - `from` cannot be the zero address.
2035      * - `to` cannot be the zero address.
2036      * - `tokenId` token must exist and be owned by `from`.
2037      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2038      *
2039      * Emits a {Transfer} event.
2040      */
2041     function _safeTransfer(
2042         address from,
2043         address to,
2044         uint256 tokenId,
2045         bytes memory _data
2046     ) internal virtual {
2047         _transfer(from, to, tokenId);
2048         require(
2049             _checkOnERC721Received(from, to, tokenId, _data),
2050             "ERC721: non ERC721Receiver implementer"
2051         );
2052     }
2053 
2054     /**
2055      * @dev Returns whether `tokenId` exists.
2056      *
2057      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2058      *
2059      * Tokens start existing when they are minted (`_mint`),
2060      * and stop existing when they are burned (`_burn`).
2061      */
2062     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2063         return _owners[tokenId] != address(0);
2064     }
2065 
2066     /**
2067      * @dev Returns whether `spender` is allowed to manage `tokenId`.
2068      *
2069      * Requirements:
2070      *
2071      * - `tokenId` must exist.
2072      */
2073     function _isApprovedOrOwner(address spender, uint256 tokenId)
2074         internal
2075         view
2076         virtual
2077         returns (bool)
2078     {
2079         require(_exists(tokenId), "ERC721: nonexistent token");
2080         address owner = ArtAI.ownerOf(tokenId);
2081         return (spender == owner ||
2082             getApproved(tokenId) == spender ||
2083             isApprovedForAll(owner, spender));
2084     }
2085 
2086     /**
2087      * @dev Safely mints `tokenId` and transfers it to `to`.
2088      *
2089      * Requirements:
2090      *
2091      * - `tokenId` must not exist.
2092      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2093      *
2094      * Emits a {Transfer} event.
2095      */
2096     function _safeMint(address to, uint256 tokenId) internal virtual {
2097         _safeMint(to, tokenId, "");
2098     }
2099 
2100     /**
2101      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
2102      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
2103      */
2104     function _safeMint(
2105         address to,
2106         uint256 tokenId,
2107         bytes memory _data
2108     ) internal virtual {
2109         _mint(to, tokenId);
2110         require(
2111             _checkOnERC721Received(address(0), to, tokenId, _data),
2112             "ERC721: non ERC721Receiver implementer"
2113         );
2114     }
2115 
2116     /**
2117      * @dev Mints `tokenId` and transfers it to `to`.
2118      *
2119      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2120      *
2121      * Requirements:
2122      *
2123      * - `tokenId` must not exist.
2124      * - `to` cannot be the zero address.
2125      *
2126      * Emits a {Transfer} event.
2127      */
2128     function _mint(address to, uint256 tokenId) internal virtual {
2129         require(to != address(0), "ERC721: zero address");
2130         require(!_exists(tokenId), "ERC721: token already minted");
2131 
2132         _beforeTokenTransfer(address(0), to, tokenId);
2133 
2134         _balances[to] += 1;
2135         _owners[tokenId] = to;
2136         _tokenSupply += 1;
2137 
2138         emit Transfer(address(0), to, tokenId);
2139     }
2140 
2141     /**
2142      * @dev Transfers `tokenId` from `from` to `to`.
2143      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2144      *
2145      * Requirements:
2146      *
2147      * - `to` cannot be the zero address.
2148      * - `tokenId` token must be owned by `from`.
2149      *
2150      * Emits a {Transfer} event.
2151      */
2152     function _transfer(
2153         address from,
2154         address to,
2155         uint256 tokenId
2156     ) internal virtual {
2157         require(ArtAI.ownerOf(tokenId) == from, "ERC721: not own");
2158         require(to != address(0), "ERC721: zero address");
2159 
2160         _beforeTokenTransfer(from, to, tokenId);
2161 
2162         // Clear approvals from the previous owner
2163         _approve(address(0), tokenId);
2164 
2165         _balances[from] -= 1;
2166         _balances[to] += 1;
2167         _owners[tokenId] = to;
2168 
2169         emit Transfer(from, to, tokenId);
2170     }
2171 
2172     /**
2173      * @dev Approve `to` to operate on `tokenId`
2174      *
2175      * Emits a {Approval} event.
2176      */
2177     function _approve(address to, uint256 tokenId) internal virtual {
2178         _tokenApprovals[tokenId] = to;
2179         emit Approval(ArtAI.ownerOf(tokenId), to, tokenId);
2180     }
2181 
2182     /**
2183      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2184      * The call is not executed if the target address is not a contract.
2185      *
2186      * @param from address representing the previous owner of the given token ID
2187      * @param to target address that will receive the tokens
2188      * @param tokenId uint256 ID of the token to be transferred
2189      * @param _data bytes optional data to send along with the call
2190      * @return bool whether the call correctly returned the expected magic value
2191      */
2192     function _checkOnERC721Received(
2193         address from,
2194         address to,
2195         uint256 tokenId,
2196         bytes memory _data
2197     ) private returns (bool) {
2198         if (to.isContract()) {
2199             try
2200                 IERC721Receiver(to).onERC721Received(
2201                     _msgSender(),
2202                     from,
2203                     tokenId,
2204                     _data
2205                 )
2206             returns (bytes4 retval) {
2207                 return retval == IERC721Receiver.onERC721Received.selector;
2208             } catch (bytes memory reason) {
2209                 if (reason.length == 0) {
2210                     revert("ERC721: non ERC721Receiver implementer");
2211                 } else {
2212                     assembly {
2213                         revert(add(32, reason), mload(reason))
2214                     }
2215                 }
2216             }
2217         } else {
2218             return true;
2219         }
2220     }
2221 
2222     /**
2223      * @dev Hook that is called before any token transfer. This includes minting
2224      * and burning.
2225      *
2226      * Calling conditions:
2227      *
2228      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2229      * transferred to `to`.
2230      * - When `from` is zero, `tokenId` will be minted for `to`.
2231      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2232      * - `from` and `to` are never both zero.
2233      *
2234      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2235      */
2236     function _beforeTokenTransfer(
2237         address from,
2238         address to,
2239         uint256 tokenId
2240     ) internal virtual {}
2241 }