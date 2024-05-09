1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 /**
26  * @dev Contract module which provides a basic access control mechanism, where
27  * there is an account (an owner) that can be granted exclusive access to
28  * specific functions.
29  *
30  * By default, the owner account will be the one that deploys the contract. This
31  * can later be changed with {transferOwnership}.
32  *
33  * This module is used through inheritance. It will make available the modifier
34  * `onlyOwner`, which can be applied to your functions to restrict their use to
35  * the owner.
36  */
37 abstract contract Ownable is Context {
38     address private _owner;
39 
40     event OwnershipTransferred(
41         address indexed previousOwner,
42         address indexed newOwner
43     );
44 
45     /**
46      * @dev Initializes the contract setting the deployer as the initial owner.
47      */
48     constructor() {
49         _setOwner(_msgSender());
50     }
51 
52     /**
53      * @dev Returns the address of the current owner.
54      */
55     function owner() public view virtual returns (address) {
56         return _owner;
57     }
58 
59     /**
60      * @dev Throws if called by any account other than the owner.
61      */
62     modifier onlyOwner() {
63         require(owner() == _msgSender(), "Ownable: caller is not the owner");
64         _;
65     }
66 
67     /**
68      * @dev Leaves the contract without owner. It will not be possible to call
69      * `onlyOwner` functions anymore. Can only be called by the current owner.
70      *
71      * NOTE: Renouncing ownership will leave the contract without an owner,
72      * thereby removing any functionality that is only available to the owner.
73      */
74     function renounceOwnership() public virtual onlyOwner {
75         _setOwner(address(0));
76     }
77 
78     /**
79      * @dev Transfers ownership of the contract to a new account (`newOwner`).
80      * Can only be called by the current owner.
81      */
82     function transferOwnership(address newOwner) public virtual onlyOwner {
83         require(
84             newOwner != address(0),
85             "Ownable: new owner is the zero address"
86         );
87         _setOwner(newOwner);
88     }
89 
90     function _setOwner(address newOwner) private {
91         address oldOwner = _owner;
92         _owner = newOwner;
93         emit OwnershipTransferred(oldOwner, newOwner);
94     }
95 }
96 
97 /**
98  * @dev String operations.
99  */
100 library Strings {
101     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
102 
103     /**
104      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
105      */
106     function toString(uint256 value) internal pure returns (string memory) {
107         // Inspired by OraclizeAPI's implementation - MIT licence
108         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
109 
110         if (value == 0) {
111             return "0";
112         }
113         uint256 temp = value;
114         uint256 digits;
115         while (temp != 0) {
116             digits++;
117             temp /= 10;
118         }
119         bytes memory buffer = new bytes(digits);
120         while (value != 0) {
121             digits -= 1;
122             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
123             value /= 10;
124         }
125         return string(buffer);
126     }
127 
128     /**
129      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
130      */
131     function toHexString(uint256 value) internal pure returns (string memory) {
132         if (value == 0) {
133             return "0x00";
134         }
135         uint256 temp = value;
136         uint256 length = 0;
137         while (temp != 0) {
138             length++;
139             temp >>= 8;
140         }
141         return toHexString(value, length);
142     }
143 
144     /**
145      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
146      */
147     function toHexString(uint256 value, uint256 length)
148         internal
149         pure
150         returns (string memory)
151     {
152         bytes memory buffer = new bytes(2 * length + 2);
153         buffer[0] = "0";
154         buffer[1] = "x";
155         for (uint256 i = 2 * length + 1; i > 1; --i) {
156             buffer[i] = _HEX_SYMBOLS[value & 0xf];
157             value >>= 4;
158         }
159         require(value == 0, "Strings: hex length insufficient");
160         return string(buffer);
161     }
162 }
163 
164 /**
165  * @dev Collection of functions related to the address type
166  */
167 library Address {
168     /**
169      * @dev Returns true if `account` is a contract.
170      *
171      * [IMPORTANT]
172      * ====
173      * It is unsafe to assume that an address for which this function returns
174      * false is an externally-owned account (EOA) and not a contract.
175      *
176      * Among others, `isContract` will return false for the following
177      * types of addresses:
178      *
179      *  - an externally-owned account
180      *  - a contract in construction
181      *  - an address where a contract will be created
182      *  - an address where a contract lived, but was destroyed
183      * ====
184      */
185     function isContract(address account) internal view returns (bool) {
186         // This method relies on extcodesize, which returns 0 for contracts in
187         // construction, since the code is only stored at the end of the
188         // constructor execution.
189 
190         uint256 size;
191         assembly {
192             size := extcodesize(account)
193         }
194         return size > 0;
195     }
196 
197     /**
198      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
199      * `recipient`, forwarding all available gas and reverting on errors.
200      *
201      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
202      * of certain opcodes, possibly making contracts go over the 2300 gas limit
203      * imposed by `transfer`, making them unable to receive funds via
204      * `transfer`. {sendValue} removes this limitation.
205      *
206      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
207      *
208      * IMPORTANT: because control is transferred to `recipient`, care must be
209      * taken to not create reentrancy vulnerabilities. Consider using
210      * {ReentrancyGuard} or the
211      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
212      */
213     function sendValue(address payable recipient, uint256 amount) internal {
214         require(
215             address(this).balance >= amount,
216             "Address: insufficient balance"
217         );
218 
219         (bool success, ) = recipient.call{value: amount}("");
220         require(
221             success,
222             "Address: unable to send value, recipient may have reverted"
223         );
224     }
225 
226     /**
227      * @dev Performs a Solidity function call using a low level `call`. A
228      * plain `call` is an unsafe replacement for a function call: use this
229      * function instead.
230      *
231      * If `target` reverts with a revert reason, it is bubbled up by this
232      * function (like regular Solidity function calls).
233      *
234      * Returns the raw returned data. To convert to the expected return value,
235      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
236      *
237      * Requirements:
238      *
239      * - `target` must be a contract.
240      * - calling `target` with `data` must not revert.
241      *
242      * _Available since v3.1._
243      */
244     function functionCall(address target, bytes memory data)
245         internal
246         returns (bytes memory)
247     {
248         return functionCall(target, data, "Address: low-level call failed");
249     }
250 
251     /**
252      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
253      * `errorMessage` as a fallback revert reason when `target` reverts.
254      *
255      * _Available since v3.1._
256      */
257     function functionCall(
258         address target,
259         bytes memory data,
260         string memory errorMessage
261     ) internal returns (bytes memory) {
262         return functionCallWithValue(target, data, 0, errorMessage);
263     }
264 
265     /**
266      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
267      * but also transferring `value` wei to `target`.
268      *
269      * Requirements:
270      *
271      * - the calling contract must have an ETH balance of at least `value`.
272      * - the called Solidity function must be `payable`.
273      *
274      * _Available since v3.1._
275      */
276     function functionCallWithValue(
277         address target,
278         bytes memory data,
279         uint256 value
280     ) internal returns (bytes memory) {
281         return
282             functionCallWithValue(
283                 target,
284                 data,
285                 value,
286                 "Address: low-level call with value failed"
287             );
288     }
289 
290     /**
291      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
292      * with `errorMessage` as a fallback revert reason when `target` reverts.
293      *
294      * _Available since v3.1._
295      */
296     function functionCallWithValue(
297         address target,
298         bytes memory data,
299         uint256 value,
300         string memory errorMessage
301     ) internal returns (bytes memory) {
302         require(
303             address(this).balance >= value,
304             "Address: insufficient balance for call"
305         );
306         require(isContract(target), "Address: call to non-contract");
307 
308         (bool success, bytes memory returndata) = target.call{value: value}(
309             data
310         );
311         return verifyCallResult(success, returndata, errorMessage);
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
316      * but performing a static call.
317      *
318      * _Available since v3.3._
319      */
320     function functionStaticCall(address target, bytes memory data)
321         internal
322         view
323         returns (bytes memory)
324     {
325         return
326             functionStaticCall(
327                 target,
328                 data,
329                 "Address: low-level static call failed"
330             );
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
335      * but performing a static call.
336      *
337      * _Available since v3.3._
338      */
339     function functionStaticCall(
340         address target,
341         bytes memory data,
342         string memory errorMessage
343     ) internal view returns (bytes memory) {
344         require(isContract(target), "Address: static call to non-contract");
345 
346         (bool success, bytes memory returndata) = target.staticcall(data);
347         return verifyCallResult(success, returndata, errorMessage);
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
352      * but performing a delegate call.
353      *
354      * _Available since v3.4._
355      */
356     function functionDelegateCall(address target, bytes memory data)
357         internal
358         returns (bytes memory)
359     {
360         return
361             functionDelegateCall(
362                 target,
363                 data,
364                 "Address: low-level delegate call failed"
365             );
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
370      * but performing a delegate call.
371      *
372      * _Available since v3.4._
373      */
374     function functionDelegateCall(
375         address target,
376         bytes memory data,
377         string memory errorMessage
378     ) internal returns (bytes memory) {
379         require(isContract(target), "Address: delegate call to non-contract");
380 
381         (bool success, bytes memory returndata) = target.delegatecall(data);
382         return verifyCallResult(success, returndata, errorMessage);
383     }
384 
385     /**
386      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
387      * revert reason using the provided one.
388      *
389      * _Available since v4.3._
390      */
391     function verifyCallResult(
392         bool success,
393         bytes memory returndata,
394         string memory errorMessage
395     ) internal pure returns (bytes memory) {
396         if (success) {
397             return returndata;
398         } else {
399             // Look for revert reason and bubble it up if present
400             if (returndata.length > 0) {
401                 // The easiest way to bubble the revert reason is using memory via assembly
402 
403                 assembly {
404                     let returndata_size := mload(returndata)
405                     revert(add(32, returndata), returndata_size)
406                 }
407             } else {
408                 revert(errorMessage);
409             }
410         }
411     }
412 }
413 
414 /**
415  * @dev Contract module that helps prevent reentrant calls to a function.
416  *
417  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
418  * available, which can be applied to functions to make sure there are no nested
419  * (reentrant) calls to them.
420  *
421  * Note that because there is a single `nonReentrant` guard, functions marked as
422  * `nonReentrant` may not call one another. This can be worked around by making
423  * those functions `private`, and then adding `external` `nonReentrant` entry
424  * points to them.
425  *
426  * TIP: If you would like to learn more about reentrancy and alternative ways
427  * to protect against it, check out our blog post
428  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
429  */
430 abstract contract ReentrancyGuard {
431     // Booleans are more expensive than uint256 or any type that takes up a full
432     // word because each write operation emits an extra SLOAD to first read the
433     // slot's contents, replace the bits taken up by the boolean, and then write
434     // back. This is the compiler's defense against contract upgrades and
435     // pointer aliasing, and it cannot be disabled.
436 
437     // The values being non-zero value makes deployment a bit more expensive,
438     // but in exchange the refund on every call to nonReentrant will be lower in
439     // amount. Since refunds are capped to a percentage of the total
440     // transaction's gas, it is best to keep them low in cases like this one, to
441     // increase the likelihood of the full refund coming into effect.
442     uint256 private constant _NOT_ENTERED = 1;
443     uint256 private constant _ENTERED = 2;
444 
445     uint256 private _status;
446 
447     constructor() {
448         _status = _NOT_ENTERED;
449     }
450 
451     /**
452      * @dev Prevents a contract from calling itself, directly or indirectly.
453      * Calling a `nonReentrant` function from another `nonReentrant`
454      * function is not supported. It is possible to prevent this from happening
455      * by making the `nonReentrant` function external, and make it call a
456      * `private` function that does the actual work.
457      */
458     modifier nonReentrant() {
459         // On the first call to nonReentrant, _notEntered will be true
460         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
461 
462         // Any calls to nonReentrant after this point will fail
463         _status = _ENTERED;
464 
465         _;
466 
467         // By storing the original value once again, a refund is triggered (see
468         // https://eips.ethereum.org/EIPS/eip-2200)
469         _status = _NOT_ENTERED;
470     }
471 }
472 
473 /**
474  * @dev Interface of the ERC165 standard, as defined in the
475  * https://eips.ethereum.org/EIPS/eip-165[EIP].
476  *
477  * Implementers can declare support of contract interfaces, which can then be
478  * queried by others ({ERC165Checker}).
479  *
480  * For an implementation, see {ERC165}.
481  */
482 interface IERC165 {
483     /**
484      * @dev Returns true if this contract implements the interface defined by
485      * `interfaceId`. See the corresponding
486      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
487      * to learn more about how these ids are created.
488      *
489      * This function call must use less than 30 000 gas.
490      */
491     function supportsInterface(bytes4 interfaceId) external view returns (bool);
492 }
493 
494 /**
495  * @dev Implementation of the {IERC165} interface.
496  *
497  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
498  * for the additional interface id that will be supported. For example:
499  *
500  * ```solidity
501  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
502  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
503  * }
504  * ```
505  *
506  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
507  */
508 abstract contract ERC165 is IERC165 {
509     /**
510      * @dev See {IERC165-supportsInterface}.
511      */
512     function supportsInterface(bytes4 interfaceId)
513         public
514         view
515         virtual
516         override
517         returns (bool)
518     {
519         return interfaceId == type(IERC165).interfaceId;
520     }
521 }
522 
523 /**
524  * @dev _Available since v3.1._
525  */
526 interface IERC1155Receiver is IERC165 {
527     /**
528         @dev Handles the receipt of a single ERC1155 token type. This function is
529         called at the end of a `safeTransferFrom` after the balance has been updated.
530         To accept the transfer, this must return
531         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
532         (i.e. 0xf23a6e61, or its own function selector).
533         @param operator The address which initiated the transfer (i.e. msg.sender)
534         @param from The address which previously owned the token
535         @param id The ID of the token being transferred
536         @param value The amount of tokens being transferred
537         @param data Additional data with no specified format
538         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
539     */
540     function onERC1155Received(
541         address operator,
542         address from,
543         uint256 id,
544         uint256 value,
545         bytes calldata data
546     ) external returns (bytes4);
547 
548     /**
549         @dev Handles the receipt of a multiple ERC1155 token types. This function
550         is called at the end of a `safeBatchTransferFrom` after the balances have
551         been updated. To accept the transfer(s), this must return
552         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
553         (i.e. 0xbc197c81, or its own function selector).
554         @param operator The address which initiated the batch transfer (i.e. msg.sender)
555         @param from The address which previously owned the token
556         @param ids An array containing ids of each token being transferred (order and length must match values array)
557         @param values An array containing amounts of each token being transferred (order and length must match ids array)
558         @param data Additional data with no specified format
559         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
560     */
561     function onERC1155BatchReceived(
562         address operator,
563         address from,
564         uint256[] calldata ids,
565         uint256[] calldata values,
566         bytes calldata data
567     ) external returns (bytes4);
568 }
569 
570 /**
571  * @dev Interface of the ERC20 standard as defined in the EIP.
572  */
573 interface IERC20 {
574     /**
575      * @dev Returns the amount of tokens in existence.
576      */
577     function totalSupply() external view returns (uint256);
578 
579     /**
580      * @dev Returns the amount of tokens owned by `account`.
581      */
582     function balanceOf(address account) external view returns (uint256);
583 
584     /**
585      * @dev Moves `amount` tokens from the caller's account to `recipient`.
586      *
587      * Returns a boolean value indicating whether the operation succeeded.
588      *
589      * Emits a {Transfer} event.
590      */
591     function transfer(address recipient, uint256 amount)
592         external
593         returns (bool);
594 
595     /**
596      * @dev Returns the remaining number of tokens that `spender` will be
597      * allowed to spend on behalf of `owner` through {transferFrom}. This is
598      * zero by default.
599      *
600      * This value changes when {approve} or {transferFrom} are called.
601      */
602     function allowance(address owner, address spender)
603         external
604         view
605         returns (uint256);
606 
607     /**
608      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
609      *
610      * Returns a boolean value indicating whether the operation succeeded.
611      *
612      * IMPORTANT: Beware that changing an allowance with this method brings the risk
613      * that someone may use both the old and the new allowance by unfortunate
614      * transaction ordering. One possible solution to mitigate this race
615      * condition is to first reduce the spender's allowance to 0 and set the
616      * desired value afterwards:
617      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
618      *
619      * Emits an {Approval} event.
620      */
621     function approve(address spender, uint256 amount) external returns (bool);
622 
623     /**
624      * @dev Moves `amount` tokens from `sender` to `recipient` using the
625      * allowance mechanism. `amount` is then deducted from the caller's
626      * allowance.
627      *
628      * Returns a boolean value indicating whether the operation succeeded.
629      *
630      * Emits a {Transfer} event.
631      */
632     function transferFrom(
633         address sender,
634         address recipient,
635         uint256 amount
636     ) external returns (bool);
637 
638     /**
639      * @dev Emitted when `value` tokens are moved from one account (`from`) to
640      * another (`to`).
641      *
642      * Note that `value` may be zero.
643      */
644     event Transfer(address indexed from, address indexed to, uint256 value);
645 
646     /**
647      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
648      * a call to {approve}. `value` is the new allowance.
649      */
650     event Approval(
651         address indexed owner,
652         address indexed spender,
653         uint256 value
654     );
655 }
656 
657 /**
658  * @dev Required interface of an ERC721 compliant contract.
659  */
660 interface IERC721 is IERC165 {
661     /**
662      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
663      */
664     event Transfer(
665         address indexed from,
666         address indexed to,
667         uint256 indexed tokenId
668     );
669 
670     /**
671      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
672      */
673     event Approval(
674         address indexed owner,
675         address indexed approved,
676         uint256 indexed tokenId
677     );
678 
679     /**
680      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
681      */
682     event ApprovalForAll(
683         address indexed owner,
684         address indexed operator,
685         bool approved
686     );
687 
688     /**
689      * @dev Returns the number of tokens in ``owner``'s account.
690      */
691     function balanceOf(address owner) external view returns (uint256 balance);
692 
693     /**
694      * @dev Returns the owner of the `tokenId` token.
695      *
696      * Requirements:
697      *
698      * - `tokenId` must exist.
699      */
700     function ownerOf(uint256 tokenId) external view returns (address owner);
701 
702     /**
703      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
704      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
705      *
706      * Requirements:
707      *
708      * - `from` cannot be the zero address.
709      * - `to` cannot be the zero address.
710      * - `tokenId` token must exist and be owned by `from`.
711      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
712      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
713      *
714      * Emits a {Transfer} event.
715      */
716     function safeTransferFrom(
717         address from,
718         address to,
719         uint256 tokenId
720     ) external;
721 
722     /**
723      * @dev Transfers `tokenId` token from `from` to `to`.
724      *
725      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
726      *
727      * Requirements:
728      *
729      * - `from` cannot be the zero address.
730      * - `to` cannot be the zero address.
731      * - `tokenId` token must be owned by `from`.
732      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
733      *
734      * Emits a {Transfer} event.
735      */
736     function transferFrom(
737         address from,
738         address to,
739         uint256 tokenId
740     ) external;
741 
742     /**
743      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
744      * The approval is cleared when the token is transferred.
745      *
746      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
747      *
748      * Requirements:
749      *
750      * - The caller must own the token or be an approved operator.
751      * - `tokenId` must exist.
752      *
753      * Emits an {Approval} event.
754      */
755     function approve(address to, uint256 tokenId) external;
756 
757     /**
758      * @dev Returns the account approved for `tokenId` token.
759      *
760      * Requirements:
761      *
762      * - `tokenId` must exist.
763      */
764     function getApproved(uint256 tokenId)
765         external
766         view
767         returns (address operator);
768 
769     /**
770      * @dev Approve or remove `operator` as an operator for the caller.
771      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
772      *
773      * Requirements:
774      *
775      * - The `operator` cannot be the caller.
776      *
777      * Emits an {ApprovalForAll} event.
778      */
779     function setApprovalForAll(address operator, bool _approved) external;
780 
781     /**
782      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
783      *
784      * See {setApprovalForAll}
785      */
786     function isApprovedForAll(address owner, address operator)
787         external
788         view
789         returns (bool);
790 
791     /**
792      * @dev Safely transfers `tokenId` token from `from` to `to`.
793      *
794      * Requirements:
795      *
796      * - `from` cannot be the zero address.
797      * - `to` cannot be the zero address.
798      * - `tokenId` token must exist and be owned by `from`.
799      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
800      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
801      *
802      * Emits a {Transfer} event.
803      */
804     function safeTransferFrom(
805         address from,
806         address to,
807         uint256 tokenId,
808         bytes calldata data
809     ) external;
810 }
811 
812 /**
813  * @dev Required interface of an ERC1155 compliant contract, as defined in the
814  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
815  *
816  * _Available since v3.1._
817  */
818 interface IERC1155 is IERC165 {
819     /**
820      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
821      */
822     event TransferSingle(
823         address indexed operator,
824         address indexed from,
825         address indexed to,
826         uint256 id,
827         uint256 value
828     );
829 
830     /**
831      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
832      * transfers.
833      */
834     event TransferBatch(
835         address indexed operator,
836         address indexed from,
837         address indexed to,
838         uint256[] ids,
839         uint256[] values
840     );
841 
842     /**
843      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
844      * `approved`.
845      */
846     event ApprovalForAll(
847         address indexed account,
848         address indexed operator,
849         bool approved
850     );
851 
852     /**
853      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
854      *
855      * If an {URI} event was emitted for `id`, the standard
856      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
857      * returned by {IERC1155MetadataURI-uri}.
858      */
859     event URI(string value, uint256 indexed id);
860 
861     /**
862      * @dev Returns the amount of tokens of token type `id` owned by `account`.
863      *
864      * Requirements:
865      *
866      * - `account` cannot be the zero address.
867      */
868     function balanceOf(address account, uint256 id)
869         external
870         view
871         returns (uint256);
872 
873     /**
874      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
875      *
876      * Requirements:
877      *
878      * - `accounts` and `ids` must have the same length.
879      */
880     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
881         external
882         view
883         returns (uint256[] memory);
884 
885     /**
886      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
887      *
888      * Emits an {ApprovalForAll} event.
889      *
890      * Requirements:
891      *
892      * - `operator` cannot be the caller.
893      */
894     function setApprovalForAll(address operator, bool approved) external;
895 
896     /**
897      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
898      *
899      * See {setApprovalForAll}.
900      */
901     function isApprovedForAll(address account, address operator)
902         external
903         view
904         returns (bool);
905 
906     /**
907      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
908      *
909      * Emits a {TransferSingle} event.
910      *
911      * Requirements:
912      *
913      * - `to` cannot be the zero address.
914      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
915      * - `from` must have a balance of tokens of type `id` of at least `amount`.
916      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
917      * acceptance magic value.
918      */
919     function safeTransferFrom(
920         address from,
921         address to,
922         uint256 id,
923         uint256 amount,
924         bytes calldata data
925     ) external;
926 
927     /**
928      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
929      *
930      * Emits a {TransferBatch} event.
931      *
932      * Requirements:
933      *
934      * - `ids` and `amounts` must have the same length.
935      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
936      * acceptance magic value.
937      */
938     function safeBatchTransferFrom(
939         address from,
940         address to,
941         uint256[] calldata ids,
942         uint256[] calldata amounts,
943         bytes calldata data
944     ) external;
945 }
946 
947 /**
948  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
949  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
950  *
951  * _Available since v3.1._
952  */
953 interface IERC1155MetadataURI is IERC1155 {
954     /**
955      * @dev Returns the URI for token type `id`.
956      *
957      * If the `\{id\}` substring is present in the URI, it must be replaced by
958      * clients with the actual token type ID.
959      */
960     function uri(uint256 id) external view returns (string memory);
961 }
962 
963 library StringUtils {
964     /// @dev Does a byte-by-byte lexicographical comparison of two strings.
965     /// @return a negative number if `_a` is smaller, zero if they are equal
966     /// and a positive numbe if `_b` is smaller.
967     function compare(string memory _a, string memory _b)
968         internal
969         pure
970         returns (int256)
971     {
972         bytes memory a = bytes(_a);
973         bytes memory b = bytes(_b);
974         uint256 minLength = a.length;
975         if (b.length < minLength) minLength = b.length;
976         //@todo unroll the loop into increments of 32 and do full 32 byte comparisons
977         for (uint256 i = 0; i < minLength; i++)
978             if (a[i] < b[i]) return -1;
979             else if (a[i] > b[i]) return 1;
980         if (a.length < b.length) return -1;
981         else if (a.length > b.length) return 1;
982         else return 0;
983     }
984 
985     /// @dev Compares two strings and returns true iff they are equal.
986     function equal(string memory _a, string memory _b)
987         internal
988         pure
989         returns (bool)
990     {
991         return compare(_a, _b) == 0;
992     }
993 
994     /// @dev Finds the index of the first occurrence of _needle in _haystack
995     function indexOf(string memory _haystack, string memory _needle)
996         internal
997         pure
998         returns (int256)
999     {
1000         bytes memory h = bytes(_haystack);
1001         bytes memory n = bytes(_needle);
1002         if (h.length < 1 || n.length < 1 || (n.length > h.length)) return -1;
1003         else if (h.length > (2**128 - 1))
1004             // since we have to be able to return -1 (if the char isn't found or input error), this function must return an "int" type with a max length of (2^128 - 1)
1005             return -1;
1006         else {
1007             uint256 subindex = 0;
1008             for (uint256 i = 0; i < h.length; i++) {
1009                 if (h[i] == n[0]) // found the first char of b
1010                 {
1011                     subindex = 1;
1012                     while (
1013                         subindex < n.length &&
1014                         (i + subindex) < h.length &&
1015                         h[i + subindex] == n[subindex] // search until the chars don't match or until we reach the end of a or b
1016                     ) {
1017                         subindex++;
1018                     }
1019                     if (subindex == n.length) return int256(i);
1020                 }
1021             }
1022             return -1;
1023         }
1024     }
1025 }
1026 
1027 contract Whitelistable {
1028     using Address for address;
1029     using StringUtils for string;
1030 
1031     enum Specification {
1032         NONE,
1033         ERC721,
1034         ERC20
1035     }
1036 
1037     struct WhitelistCheck {
1038         Specification specification;
1039         address tokenAddress;
1040     }
1041     mapping(uint256 => WhitelistCheck) private whitelist;
1042 
1043     function setWhitelistCheck(
1044         string memory specification,
1045         address tokenAddress,
1046         uint256 _id
1047     ) public virtual {
1048         require(tokenAddress.isContract(), "Token address must be a contract");
1049         whitelist[_id].specification = specificationByValue(specification);
1050         whitelist[_id].tokenAddress = tokenAddress;
1051     }
1052 
1053     function isWhitelisted(address wallet, uint256 _id)
1054         internal
1055         view
1056         returns (bool)
1057     {
1058         if (whitelist[_id].specification == Specification.ERC721) {
1059             try IERC721(whitelist[_id].tokenAddress).balanceOf(wallet) {
1060                 return
1061                     IERC721(whitelist[_id].tokenAddress).balanceOf(wallet) > 0;
1062             } catch Error(string memory) {
1063                 return false;
1064             }
1065         } else if (whitelist[_id].specification == Specification.ERC20) {
1066             try IERC20(whitelist[_id].tokenAddress).balanceOf(wallet) {
1067                 return
1068                     IERC20(whitelist[_id].tokenAddress).balanceOf(wallet) > 0;
1069             } catch Error(string memory) {
1070                 return false;
1071             }
1072         } else {
1073             return false;
1074         }
1075     }
1076 
1077     function specificationByValue(string memory value)
1078         private
1079         pure
1080         returns (Specification)
1081     {
1082         if (value.equal("ERC721") || value.equal("ERC-721")) {
1083             return Specification.ERC721;
1084         } else if (value.equal("ERC20") || value.equal("ERC-20")) {
1085             return Specification.ERC20;
1086         } else {
1087             revert("Unknown specification");
1088         }
1089     }
1090 }
1091 
1092 /**
1093  * @dev Implementation of the basic standard multi-token.
1094  * See https://eips.ethereum.org/EIPS/eip-1155
1095  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
1096  *
1097  * _Available since v3.1._
1098  */
1099 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
1100     using Address for address;
1101 
1102     // Mapping from token ID to account balances
1103     mapping(uint256 => mapping(address => uint256)) internal balances;
1104 
1105     // Mapping from account to operator approvals
1106     mapping(address => mapping(address => bool)) internal operatorApprovals;
1107 
1108     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
1109     string private _uri;
1110 
1111     /**
1112      * @dev See {_setURI}.
1113      */
1114     constructor(string memory uri_) {
1115         _setURI(uri_);
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
1129             interfaceId == type(IERC1155).interfaceId ||
1130             interfaceId == type(IERC1155MetadataURI).interfaceId ||
1131             super.supportsInterface(interfaceId);
1132     }
1133 
1134     /**
1135      * @dev See {IERC1155MetadataURI-uri}.
1136      *
1137      * This implementation returns the same URI for *all* token types. It relies
1138      * on the token type ID substitution mechanism
1139      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1140      *
1141      * Clients calling this function must replace the `\{id\}` substring with the
1142      * actual token type ID.
1143      */
1144     function uri(uint256) public view virtual override returns (string memory) {
1145         return _uri;
1146     }
1147 
1148     /**
1149      * @dev See {IERC1155-balanceOf}.
1150      *
1151      * Requirements:
1152      *
1153      * - `account` cannot be the zero address.
1154      */
1155     function balanceOf(address account, uint256 id)
1156         public
1157         view
1158         virtual
1159         override
1160         returns (uint256)
1161     {
1162         require(
1163             account != address(0),
1164             "ERC1155: balance query for the zero address"
1165         );
1166         return balances[id][account];
1167     }
1168 
1169     /**
1170      * @dev See {IERC1155-balanceOfBatch}.
1171      *
1172      * Requirements:
1173      *
1174      * - `accounts` and `ids` must have the same length.
1175      */
1176     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
1177         public
1178         view
1179         virtual
1180         override
1181         returns (uint256[] memory)
1182     {
1183         require(
1184             accounts.length == ids.length,
1185             "ERC1155: accounts and ids length mismatch"
1186         );
1187 
1188         uint256[] memory batchBalances = new uint256[](accounts.length);
1189 
1190         for (uint256 i = 0; i < accounts.length; ++i) {
1191             batchBalances[i] = balanceOf(accounts[i], ids[i]);
1192         }
1193 
1194         return batchBalances;
1195     }
1196 
1197     /**
1198      * @dev See {IERC1155-setApprovalForAll}.
1199      */
1200     function setApprovalForAll(address operator, bool approved)
1201         public
1202         virtual
1203         override
1204     {
1205         require(
1206             _msgSender() != operator,
1207             "ERC1155: setting approval status for self"
1208         );
1209 
1210         operatorApprovals[_msgSender()][operator] = approved;
1211         emit ApprovalForAll(_msgSender(), operator, approved);
1212     }
1213 
1214     /**
1215      * @dev See {IERC1155-isApprovedForAll}.
1216      */
1217     function isApprovedForAll(address account, address operator)
1218         public
1219         view
1220         virtual
1221         override
1222         returns (bool)
1223     {
1224         return operatorApprovals[account][operator];
1225     }
1226 
1227     /**
1228      * @dev See {IERC1155-safeTransferFrom}.
1229      */
1230     function safeTransferFrom(
1231         address from,
1232         address to,
1233         uint256 id,
1234         uint256 amount,
1235         bytes memory data
1236     ) public virtual override {
1237         require(
1238             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1239             "ERC1155: caller is not owner nor approved"
1240         );
1241         _safeTransferFrom(from, to, id, amount, data);
1242     }
1243 
1244     /**
1245      * @dev See {IERC1155-safeBatchTransferFrom}.
1246      */
1247     function safeBatchTransferFrom(
1248         address from,
1249         address to,
1250         uint256[] memory ids,
1251         uint256[] memory amounts,
1252         bytes memory data
1253     ) public virtual override {
1254         require(
1255             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1256             "ERC1155: transfer caller is not owner nor approved"
1257         );
1258         _safeBatchTransferFrom(from, to, ids, amounts, data);
1259     }
1260 
1261     /**
1262      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1263      *
1264      * Emits a {TransferSingle} event.
1265      *
1266      * Requirements:
1267      *
1268      * - `to` cannot be the zero address.
1269      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1270      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1271      * acceptance magic value.
1272      */
1273     function _safeTransferFrom(
1274         address from,
1275         address to,
1276         uint256 id,
1277         uint256 amount,
1278         bytes memory data
1279     ) internal virtual {
1280         require(to != address(0), "ERC1155: transfer to the zero address");
1281 
1282         address operator = _msgSender();
1283 
1284         _beforeTokenTransfer(
1285             operator,
1286             from,
1287             to,
1288             _asSingletonArray(id),
1289             _asSingletonArray(amount),
1290             data
1291         );
1292 
1293         uint256 fromBalance = balances[id][from];
1294         require(
1295             fromBalance >= amount,
1296             "ERC1155: insufficient balance for transfer"
1297         );
1298         unchecked {
1299             balances[id][from] = fromBalance - amount;
1300         }
1301 
1302         balances[id][to] += amount;
1303 
1304         emit TransferSingle(operator, from, to, id, amount);
1305 
1306         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1307     }
1308 
1309     /**
1310      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1311      *
1312      * Emits a {TransferBatch} event.
1313      *
1314      * Requirements:
1315      *
1316      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1317      * acceptance magic value.
1318      */
1319     function _safeBatchTransferFrom(
1320         address from,
1321         address to,
1322         uint256[] memory ids,
1323         uint256[] memory amounts,
1324         bytes memory data
1325     ) internal virtual {
1326         require(
1327             ids.length == amounts.length,
1328             "ERC1155: ids and amounts length mismatch"
1329         );
1330         require(to != address(0), "ERC1155: transfer to the zero address");
1331 
1332         address operator = _msgSender();
1333 
1334         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1335 
1336         for (uint256 i = 0; i < ids.length; ++i) {
1337             uint256 id = ids[i];
1338             uint256 amount = amounts[i];
1339 
1340             uint256 fromBalance = balances[id][from];
1341             require(
1342                 fromBalance >= amount,
1343                 "ERC1155: insufficient balance for transfer"
1344             );
1345             unchecked {
1346                 balances[id][from] = fromBalance - amount;
1347             }
1348 
1349             balances[id][to] += amount;
1350         }
1351 
1352         emit TransferBatch(operator, from, to, ids, amounts);
1353 
1354         _doSafeBatchTransferAcceptanceCheck(
1355             operator,
1356             from,
1357             to,
1358             ids,
1359             amounts,
1360             data
1361         );
1362     }
1363 
1364     /**
1365      * @dev Sets a new URI for all token types, by relying on the token type ID
1366      * substitution mechanism
1367      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1368      *
1369      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1370      * URI or any of the amounts in the JSON file at said URI will be replaced by
1371      * clients with the token type ID.
1372      *
1373      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1374      * interpreted by clients as
1375      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1376      * for token type ID 0x4cce0.
1377      *
1378      * See {uri}.
1379      *
1380      * Because these URIs cannot be meaningfully represented by the {URI} event,
1381      * this function emits no events.
1382      */
1383     function _setURI(string memory newuri) internal virtual {
1384         _uri = newuri;
1385     }
1386 
1387     /**
1388      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
1389      *
1390      * Emits a {TransferSingle} event.
1391      *
1392      * Requirements:
1393      *
1394      * - `account` cannot be the zero address.
1395      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1396      * acceptance magic value.
1397      */
1398     function _mint(
1399         address account,
1400         uint256 id,
1401         uint256 amount,
1402         bytes memory data
1403     ) internal virtual {
1404         require(account != address(0), "ERC1155: mint to the zero address");
1405 
1406         address operator = _msgSender();
1407 
1408         _beforeTokenTransfer(
1409             operator,
1410             address(0),
1411             account,
1412             _asSingletonArray(id),
1413             _asSingletonArray(amount),
1414             data
1415         );
1416 
1417         balances[id][account] += amount;
1418         emit TransferSingle(operator, address(0), account, id, amount);
1419 
1420         _doSafeTransferAcceptanceCheck(
1421             operator,
1422             address(0),
1423             account,
1424             id,
1425             amount,
1426             data
1427         );
1428     }
1429 
1430     /**
1431      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1432      *
1433      * Requirements:
1434      *
1435      * - `ids` and `amounts` must have the same length.
1436      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1437      * acceptance magic value.
1438      */
1439     function _mintBatch(
1440         address to,
1441         uint256[] memory ids,
1442         uint256[] memory amounts,
1443         bytes memory data
1444     ) internal virtual {
1445         require(to != address(0), "ERC1155: mint to the zero address");
1446         require(
1447             ids.length == amounts.length,
1448             "ERC1155: ids and amounts length mismatch"
1449         );
1450 
1451         address operator = _msgSender();
1452 
1453         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1454 
1455         for (uint256 i = 0; i < ids.length; i++) {
1456             balances[ids[i]][to] += amounts[i];
1457         }
1458 
1459         emit TransferBatch(operator, address(0), to, ids, amounts);
1460 
1461         _doSafeBatchTransferAcceptanceCheck(
1462             operator,
1463             address(0),
1464             to,
1465             ids,
1466             amounts,
1467             data
1468         );
1469     }
1470 
1471     /**
1472      * @dev Destroys `amount` tokens of token type `id` from `account`
1473      *
1474      * Requirements:
1475      *
1476      * - `account` cannot be the zero address.
1477      * - `account` must have at least `amount` tokens of token type `id`.
1478      */
1479     function _burn(
1480         address account,
1481         uint256 id,
1482         uint256 amount
1483     ) internal virtual {
1484         require(account != address(0), "ERC1155: burn from the zero address");
1485 
1486         address operator = _msgSender();
1487 
1488         _beforeTokenTransfer(
1489             operator,
1490             account,
1491             address(0),
1492             _asSingletonArray(id),
1493             _asSingletonArray(amount),
1494             ""
1495         );
1496 
1497         uint256 accountBalance = balances[id][account];
1498         require(
1499             accountBalance >= amount,
1500             "ERC1155: burn amount exceeds balance"
1501         );
1502         unchecked {
1503             balances[id][account] = accountBalance - amount;
1504         }
1505 
1506         emit TransferSingle(operator, account, address(0), id, amount);
1507     }
1508 
1509     /**
1510      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1511      *
1512      * Requirements:
1513      *
1514      * - `ids` and `amounts` must have the same length.
1515      */
1516     function _burnBatch(
1517         address account,
1518         uint256[] memory ids,
1519         uint256[] memory amounts
1520     ) internal virtual {
1521         require(account != address(0), "ERC1155: burn from the zero address");
1522         require(
1523             ids.length == amounts.length,
1524             "ERC1155: ids and amounts length mismatch"
1525         );
1526 
1527         address operator = _msgSender();
1528 
1529         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
1530 
1531         for (uint256 i = 0; i < ids.length; i++) {
1532             uint256 id = ids[i];
1533             uint256 amount = amounts[i];
1534 
1535             uint256 accountBalance = balances[id][account];
1536             require(
1537                 accountBalance >= amount,
1538                 "ERC1155: burn amount exceeds balance"
1539             );
1540             unchecked {
1541                 balances[id][account] = accountBalance - amount;
1542             }
1543         }
1544 
1545         emit TransferBatch(operator, account, address(0), ids, amounts);
1546     }
1547 
1548     /**
1549      * @dev Hook that is called before any token transfer. This includes minting
1550      * and burning, as well as batched variants.
1551      *
1552      * The same hook is called on both single and batched variants. For single
1553      * transfers, the length of the `id` and `amount` arrays will be 1.
1554      *
1555      * Calling conditions (for each `id` and `amount` pair):
1556      *
1557      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1558      * of token type `id` will be  transferred to `to`.
1559      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1560      * for `to`.
1561      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1562      * will be burned.
1563      * - `from` and `to` are never both zero.
1564      * - `ids` and `amounts` have the same, non-zero length.
1565      *
1566      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1567      */
1568     function _beforeTokenTransfer(
1569         address operator,
1570         address from,
1571         address to,
1572         uint256[] memory ids,
1573         uint256[] memory amounts,
1574         bytes memory data
1575     ) internal virtual {}
1576 
1577     function _doSafeTransferAcceptanceCheck(
1578         address operator,
1579         address from,
1580         address to,
1581         uint256 id,
1582         uint256 amount,
1583         bytes memory data
1584     ) internal {
1585         if (to.isContract()) {
1586             try
1587                 IERC1155Receiver(to).onERC1155Received(
1588                     operator,
1589                     from,
1590                     id,
1591                     amount,
1592                     data
1593                 )
1594             returns (bytes4 response) {
1595                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1596                     revert("ERC1155: ERC1155Receiver rejected tokens");
1597                 }
1598             } catch Error(string memory reason) {
1599                 revert(reason);
1600             } catch {
1601                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1602             }
1603         }
1604     }
1605 
1606     function _doSafeBatchTransferAcceptanceCheck(
1607         address operator,
1608         address from,
1609         address to,
1610         uint256[] memory ids,
1611         uint256[] memory amounts,
1612         bytes memory data
1613     ) internal {
1614         if (to.isContract()) {
1615             try
1616                 IERC1155Receiver(to).onERC1155BatchReceived(
1617                     operator,
1618                     from,
1619                     ids,
1620                     amounts,
1621                     data
1622                 )
1623             returns (bytes4 response) {
1624                 if (
1625                     response != IERC1155Receiver.onERC1155BatchReceived.selector
1626                 ) {
1627                     revert("ERC1155: ERC1155Receiver rejected tokens");
1628                 }
1629             } catch Error(string memory reason) {
1630                 revert(reason);
1631             } catch {
1632                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1633             }
1634         }
1635     }
1636 
1637     function _asSingletonArray(uint256 element)
1638         internal
1639         pure
1640         returns (uint256[] memory)
1641     {
1642         uint256[] memory array = new uint256[](1);
1643         array[0] = element;
1644 
1645         return array;
1646     }
1647 }
1648 
1649 contract Invite1155 is ERC1155, Ownable, Whitelistable, ReentrancyGuard {
1650     using Strings for uint256;
1651     using Address for address payable;
1652 
1653     constructor(string memory _name, string memory _symbol) ERC1155("") {
1654         name = _name;
1655         symbol = _symbol;
1656     }
1657 
1658     struct TokenType {
1659         string uri;
1660         uint256 price;
1661         uint256 usedSupply;
1662         uint256 totalSupply;
1663     }
1664 
1665     mapping(uint256 => TokenType) _tokenTypes;
1666     mapping(uint256 => mapping(address => bool)) private _mintApprovals;
1667     mapping(address => mapping(uint256 => bool)) private _hasMinted;
1668 
1669     bool private canMint;
1670 
1671     string public name;
1672     string public symbol;
1673 
1674     function createType(
1675         uint256 _id,
1676         string memory _uri,
1677         uint256 _price,
1678         uint256 _totalSupply
1679     ) public onlyOwner {
1680         require(
1681             _tokenTypes[_id].totalSupply == 0,
1682             "Invite: type already defined"
1683         );
1684         require(
1685             _totalSupply > 0,
1686             "Invite: must set an above zero total supply"
1687         );
1688         require(bytes(_uri).length > 0, "Invite: must set a URI");
1689         TokenType memory tokenType;
1690         tokenType.uri = _uri;
1691         tokenType.price = _price;
1692         tokenType.usedSupply = 0;
1693         tokenType.totalSupply = _totalSupply;
1694         _tokenTypes[_id] = tokenType;
1695     }
1696 
1697     function uri(uint256 it)
1698         public
1699         view
1700         virtual
1701         override
1702         returns (string memory)
1703     {
1704         return _tokenTypes[it].uri;
1705     }
1706 
1707     function setCanMint(bool _canMint) public onlyOwner {
1708         canMint = _canMint;
1709     }
1710 
1711     function setPrice(uint256 id, uint256 price) public onlyOwner {
1712         _tokenTypes[id].price = price;
1713     }
1714 
1715     function getUsedSupply(uint256 id) public view returns (uint256) {
1716         return _tokenTypes[id].usedSupply;
1717     }
1718 
1719     function getTotalSupply(uint256 id) public view returns (uint256) {
1720         return _tokenTypes[id].totalSupply;
1721     }
1722 
1723     function getPrice(uint256 id) public view returns (uint256) {
1724         return _tokenTypes[id].price;
1725     }
1726 
1727     function mintToMany(address[] calldata _to, uint256 _id)
1728         external
1729         onlyOwner
1730     {
1731         require(
1732             _tokenTypes[_id].usedSupply + _to.length <
1733                 _tokenTypes[_id].totalSupply,
1734             "Invite: total supply used up"
1735         );
1736         for (uint256 i = 0; i < _to.length; ++i) {
1737             address to = _to[i];
1738             require(
1739                 !_hasMinted[to][_id] && balanceOf(to, _id) == 0,
1740                 "Invite: cannot own more than one of an Invite"
1741             );
1742             _tokenTypes[_id].usedSupply++;
1743             _hasMinted[to][_id] = true;
1744             _mint(to, _id, 1, "");
1745         }
1746     }
1747 
1748     function mint(address to, uint256 id) external payable nonReentrant {
1749         require(canMint, "Invite: minting is disabled");
1750         require(
1751             _tokenTypes[id].usedSupply + 1 < _tokenTypes[id].totalSupply,
1752             "Invite: total supply used up"
1753         );
1754         require(
1755             balanceOf(to, id) == 0 && !_hasMinted[to][id],
1756             "Invite: cannot own more than one of an Invite"
1757         );
1758         if (_tokenTypes[id].price > 0) {
1759             require(
1760                 msg.value >= _tokenTypes[id].price ||
1761                     (_mintApprovals[id][to] || isWhitelisted(to, id)),
1762                 "Invite: not whitelisted and msg.value is not correct price"
1763             );
1764         } else {
1765             require(
1766                 _mintApprovals[id][to] || isWhitelisted(to, id),
1767                 "Invite: not approved to mint"
1768             );
1769             require(
1770                 msg.value == 0,
1771                 "Invite: sent value for non-payable token ID"
1772             );
1773         }
1774         _mintApprovals[id][to] = false;
1775         _tokenTypes[id].usedSupply++;
1776         _hasMinted[to][id] = true;
1777         _mint(to, id, 1, bytes(""));
1778     }
1779 
1780     function setMintApproval(
1781         address spender,
1782         bool value,
1783         uint256 id
1784     ) external onlyOwner {
1785         _mintApprovals[id][spender] = value;
1786     }
1787 
1788     function setMintApprovals(
1789         address[] calldata spenders,
1790         bool[] calldata values,
1791         uint256 id
1792     ) external onlyOwner {
1793         require(
1794             spenders.length == values.length,
1795             "Invite: spender and amounts arrays must be the same length"
1796         );
1797         for (uint256 i = 0; i < spenders.length; ++i) {
1798             _mintApprovals[id][spenders[i]] = values[i];
1799         }
1800     }
1801 
1802     function isMintApproved(address spender, uint256 id)
1803         external
1804         view
1805         returns (bool)
1806     {
1807         return _mintApprovals[id][spender];
1808     }
1809 
1810     function canMintToken(address minter, uint256 id)
1811         external
1812         view
1813         returns (bool)
1814     {
1815         return
1816             _tokenTypes[id].price > 0 ||
1817             _mintApprovals[id][minter] ||
1818             isWhitelisted(minter, id);
1819     }
1820 
1821     function setWhitelistCheck(
1822         string memory specification,
1823         address tokenAddress,
1824         uint256 _id
1825     ) public virtual override onlyOwner {
1826         super.setWhitelistCheck(specification, tokenAddress, _id);
1827     }
1828 
1829     function withdraw(uint256 amount, address payable to) external onlyOwner {
1830         require(address(this).balance >= amount, "Invite: not enough balance");
1831         if (amount == 0) {
1832             amount = address(this).balance;
1833         }
1834         if (to == address(0)) {
1835             to = payable(msg.sender);
1836         }
1837         to.sendValue(amount);
1838     }
1839 }