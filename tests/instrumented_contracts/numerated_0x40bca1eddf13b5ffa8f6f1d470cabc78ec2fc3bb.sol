1 // SPDX-License-Identifier: MIT
2 
3 // File: contracts/interfaces/ISkvllpvnkz.sol
4 
5 
6 pragma solidity ^0.8.0;
7 
8 interface ISkvllpvnkz {
9     function walletOfOwner(address _owner) external view returns(uint256[] memory);
10     function balanceOf(address owner) external view returns (uint256 balance);
11     function ownerOf(uint256 tokenId) external view returns (address owner);
12 }
13 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
14 
15 
16 
17 pragma solidity ^0.8.0;
18 
19 /**
20  * @dev Contract module that helps prevent reentrant calls to a function.
21  *
22  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
23  * available, which can be applied to functions to make sure there are no nested
24  * (reentrant) calls to them.
25  *
26  * Note that because there is a single `nonReentrant` guard, functions marked as
27  * `nonReentrant` may not call one another. This can be worked around by making
28  * those functions `private`, and then adding `external` `nonReentrant` entry
29  * points to them.
30  *
31  * TIP: If you would like to learn more about reentrancy and alternative ways
32  * to protect against it, check out our blog post
33  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
34  */
35 abstract contract ReentrancyGuard {
36     // Booleans are more expensive than uint256 or any type that takes up a full
37     // word because each write operation emits an extra SLOAD to first read the
38     // slot's contents, replace the bits taken up by the boolean, and then write
39     // back. This is the compiler's defense against contract upgrades and
40     // pointer aliasing, and it cannot be disabled.
41 
42     // The values being non-zero value makes deployment a bit more expensive,
43     // but in exchange the refund on every call to nonReentrant will be lower in
44     // amount. Since refunds are capped to a percentage of the total
45     // transaction's gas, it is best to keep them low in cases like this one, to
46     // increase the likelihood of the full refund coming into effect.
47     uint256 private constant _NOT_ENTERED = 1;
48     uint256 private constant _ENTERED = 2;
49 
50     uint256 private _status;
51 
52     constructor() {
53         _status = _NOT_ENTERED;
54     }
55 
56     /**
57      * @dev Prevents a contract from calling itself, directly or indirectly.
58      * Calling a `nonReentrant` function from another `nonReentrant`
59      * function is not supported. It is possible to prevent this from happening
60      * by making the `nonReentrant` function external, and make it call a
61      * `private` function that does the actual work.
62      */
63     modifier nonReentrant() {
64         // On the first call to nonReentrant, _notEntered will be true
65         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
66 
67         // Any calls to nonReentrant after this point will fail
68         _status = _ENTERED;
69 
70         _;
71 
72         // By storing the original value once again, a refund is triggered (see
73         // https://eips.ethereum.org/EIPS/eip-2200)
74         _status = _NOT_ENTERED;
75     }
76 }
77 
78 // File: @openzeppelin/contracts/utils/Strings.sol
79 
80 
81 
82 pragma solidity ^0.8.0;
83 
84 /**
85  * @dev String operations.
86  */
87 library Strings {
88     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
89 
90     /**
91      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
92      */
93     function toString(uint256 value) internal pure returns (string memory) {
94         // Inspired by OraclizeAPI's implementation - MIT licence
95         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
96 
97         if (value == 0) {
98             return "0";
99         }
100         uint256 temp = value;
101         uint256 digits;
102         while (temp != 0) {
103             digits++;
104             temp /= 10;
105         }
106         bytes memory buffer = new bytes(digits);
107         while (value != 0) {
108             digits -= 1;
109             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
110             value /= 10;
111         }
112         return string(buffer);
113     }
114 
115     /**
116      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
117      */
118     function toHexString(uint256 value) internal pure returns (string memory) {
119         if (value == 0) {
120             return "0x00";
121         }
122         uint256 temp = value;
123         uint256 length = 0;
124         while (temp != 0) {
125             length++;
126             temp >>= 8;
127         }
128         return toHexString(value, length);
129     }
130 
131     /**
132      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
133      */
134     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
135         bytes memory buffer = new bytes(2 * length + 2);
136         buffer[0] = "0";
137         buffer[1] = "x";
138         for (uint256 i = 2 * length + 1; i > 1; --i) {
139             buffer[i] = _HEX_SYMBOLS[value & 0xf];
140             value >>= 4;
141         }
142         require(value == 0, "Strings: hex length insufficient");
143         return string(buffer);
144     }
145 }
146 
147 // File: @openzeppelin/contracts/utils/Context.sol
148 
149 
150 
151 pragma solidity ^0.8.0;
152 
153 /**
154  * @dev Provides information about the current execution context, including the
155  * sender of the transaction and its data. While these are generally available
156  * via msg.sender and msg.data, they should not be accessed in such a direct
157  * manner, since when dealing with meta-transactions the account sending and
158  * paying for execution may not be the actual sender (as far as an application
159  * is concerned).
160  *
161  * This contract is only required for intermediate, library-like contracts.
162  */
163 abstract contract Context {
164     function _msgSender() internal view virtual returns (address) {
165         return msg.sender;
166     }
167 
168     function _msgData() internal view virtual returns (bytes calldata) {
169         return msg.data;
170     }
171 }
172 
173 // File: @openzeppelin/contracts/access/Ownable.sol
174 
175 
176 
177 pragma solidity ^0.8.0;
178 
179 
180 /**
181  * @dev Contract module which provides a basic access control mechanism, where
182  * there is an account (an owner) that can be granted exclusive access to
183  * specific functions.
184  *
185  * By default, the owner account will be the one that deploys the contract. This
186  * can later be changed with {transferOwnership}.
187  *
188  * This module is used through inheritance. It will make available the modifier
189  * `onlyOwner`, which can be applied to your functions to restrict their use to
190  * the owner.
191  */
192 abstract contract Ownable is Context {
193     address private _owner;
194 
195     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
196 
197     /**
198      * @dev Initializes the contract setting the deployer as the initial owner.
199      */
200     constructor() {
201         _setOwner(_msgSender());
202     }
203 
204     /**
205      * @dev Returns the address of the current owner.
206      */
207     function owner() public view virtual returns (address) {
208         return _owner;
209     }
210 
211     /**
212      * @dev Throws if called by any account other than the owner.
213      */
214     modifier onlyOwner() {
215         require(owner() == _msgSender(), "Ownable: caller is not the owner");
216         _;
217     }
218 
219     /**
220      * @dev Leaves the contract without owner. It will not be possible to call
221      * `onlyOwner` functions anymore. Can only be called by the current owner.
222      *
223      * NOTE: Renouncing ownership will leave the contract without an owner,
224      * thereby removing any functionality that is only available to the owner.
225      */
226     function renounceOwnership() public virtual onlyOwner {
227         _setOwner(address(0));
228     }
229 
230     /**
231      * @dev Transfers ownership of the contract to a new account (`newOwner`).
232      * Can only be called by the current owner.
233      */
234     function transferOwnership(address newOwner) public virtual onlyOwner {
235         require(newOwner != address(0), "Ownable: new owner is the zero address");
236         _setOwner(newOwner);
237     }
238 
239     function _setOwner(address newOwner) private {
240         address oldOwner = _owner;
241         _owner = newOwner;
242         emit OwnershipTransferred(oldOwner, newOwner);
243     }
244 }
245 
246 // File: @openzeppelin/contracts/utils/Address.sol
247 
248 
249 
250 pragma solidity ^0.8.0;
251 
252 /**
253  * @dev Collection of functions related to the address type
254  */
255 library Address {
256     /**
257      * @dev Returns true if `account` is a contract.
258      *
259      * [IMPORTANT]
260      * ====
261      * It is unsafe to assume that an address for which this function returns
262      * false is an externally-owned account (EOA) and not a contract.
263      *
264      * Among others, `isContract` will return false for the following
265      * types of addresses:
266      *
267      *  - an externally-owned account
268      *  - a contract in construction
269      *  - an address where a contract will be created
270      *  - an address where a contract lived, but was destroyed
271      * ====
272      */
273     function isContract(address account) internal view returns (bool) {
274         // This method relies on extcodesize, which returns 0 for contracts in
275         // construction, since the code is only stored at the end of the
276         // constructor execution.
277 
278         uint256 size;
279         assembly {
280             size := extcodesize(account)
281         }
282         return size > 0;
283     }
284 
285     /**
286      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
287      * `recipient`, forwarding all available gas and reverting on errors.
288      *
289      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
290      * of certain opcodes, possibly making contracts go over the 2300 gas limit
291      * imposed by `transfer`, making them unable to receive funds via
292      * `transfer`. {sendValue} removes this limitation.
293      *
294      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
295      *
296      * IMPORTANT: because control is transferred to `recipient`, care must be
297      * taken to not create reentrancy vulnerabilities. Consider using
298      * {ReentrancyGuard} or the
299      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
300      */
301     function sendValue(address payable recipient, uint256 amount) internal {
302         require(address(this).balance >= amount, "Address: insufficient balance");
303 
304         (bool success, ) = recipient.call{value: amount}("");
305         require(success, "Address: unable to send value, recipient may have reverted");
306     }
307 
308     /**
309      * @dev Performs a Solidity function call using a low level `call`. A
310      * plain `call` is an unsafe replacement for a function call: use this
311      * function instead.
312      *
313      * If `target` reverts with a revert reason, it is bubbled up by this
314      * function (like regular Solidity function calls).
315      *
316      * Returns the raw returned data. To convert to the expected return value,
317      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
318      *
319      * Requirements:
320      *
321      * - `target` must be a contract.
322      * - calling `target` with `data` must not revert.
323      *
324      * _Available since v3.1._
325      */
326     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
327         return functionCall(target, data, "Address: low-level call failed");
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
332      * `errorMessage` as a fallback revert reason when `target` reverts.
333      *
334      * _Available since v3.1._
335      */
336     function functionCall(
337         address target,
338         bytes memory data,
339         string memory errorMessage
340     ) internal returns (bytes memory) {
341         return functionCallWithValue(target, data, 0, errorMessage);
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
346      * but also transferring `value` wei to `target`.
347      *
348      * Requirements:
349      *
350      * - the calling contract must have an ETH balance of at least `value`.
351      * - the called Solidity function must be `payable`.
352      *
353      * _Available since v3.1._
354      */
355     function functionCallWithValue(
356         address target,
357         bytes memory data,
358         uint256 value
359     ) internal returns (bytes memory) {
360         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
365      * with `errorMessage` as a fallback revert reason when `target` reverts.
366      *
367      * _Available since v3.1._
368      */
369     function functionCallWithValue(
370         address target,
371         bytes memory data,
372         uint256 value,
373         string memory errorMessage
374     ) internal returns (bytes memory) {
375         require(address(this).balance >= value, "Address: insufficient balance for call");
376         require(isContract(target), "Address: call to non-contract");
377 
378         (bool success, bytes memory returndata) = target.call{value: value}(data);
379         return verifyCallResult(success, returndata, errorMessage);
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
384      * but performing a static call.
385      *
386      * _Available since v3.3._
387      */
388     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
389         return functionStaticCall(target, data, "Address: low-level static call failed");
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
394      * but performing a static call.
395      *
396      * _Available since v3.3._
397      */
398     function functionStaticCall(
399         address target,
400         bytes memory data,
401         string memory errorMessage
402     ) internal view returns (bytes memory) {
403         require(isContract(target), "Address: static call to non-contract");
404 
405         (bool success, bytes memory returndata) = target.staticcall(data);
406         return verifyCallResult(success, returndata, errorMessage);
407     }
408 
409     /**
410      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
411      * but performing a delegate call.
412      *
413      * _Available since v3.4._
414      */
415     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
416         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
417     }
418 
419     /**
420      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
421      * but performing a delegate call.
422      *
423      * _Available since v3.4._
424      */
425     function functionDelegateCall(
426         address target,
427         bytes memory data,
428         string memory errorMessage
429     ) internal returns (bytes memory) {
430         require(isContract(target), "Address: delegate call to non-contract");
431 
432         (bool success, bytes memory returndata) = target.delegatecall(data);
433         return verifyCallResult(success, returndata, errorMessage);
434     }
435 
436     /**
437      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
438      * revert reason using the provided one.
439      *
440      * _Available since v4.3._
441      */
442     function verifyCallResult(
443         bool success,
444         bytes memory returndata,
445         string memory errorMessage
446     ) internal pure returns (bytes memory) {
447         if (success) {
448             return returndata;
449         } else {
450             // Look for revert reason and bubble it up if present
451             if (returndata.length > 0) {
452                 // The easiest way to bubble the revert reason is using memory via assembly
453 
454                 assembly {
455                     let returndata_size := mload(returndata)
456                     revert(add(32, returndata), returndata_size)
457                 }
458             } else {
459                 revert(errorMessage);
460             }
461         }
462     }
463 }
464 
465 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
466 
467 
468 
469 pragma solidity ^0.8.0;
470 
471 /**
472  * @title ERC721 token receiver interface
473  * @dev Interface for any contract that wants to support safeTransfers
474  * from ERC721 asset contracts.
475  */
476 interface IERC721Receiver {
477     /**
478      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
479      * by `operator` from `from`, this function is called.
480      *
481      * It must return its Solidity selector to confirm the token transfer.
482      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
483      *
484      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
485      */
486     function onERC721Received(
487         address operator,
488         address from,
489         uint256 tokenId,
490         bytes calldata data
491     ) external returns (bytes4);
492 }
493 
494 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
495 
496 
497 
498 pragma solidity ^0.8.0;
499 
500 /**
501  * @dev Interface of the ERC165 standard, as defined in the
502  * https://eips.ethereum.org/EIPS/eip-165[EIP].
503  *
504  * Implementers can declare support of contract interfaces, which can then be
505  * queried by others ({ERC165Checker}).
506  *
507  * For an implementation, see {ERC165}.
508  */
509 interface IERC165 {
510     /**
511      * @dev Returns true if this contract implements the interface defined by
512      * `interfaceId`. See the corresponding
513      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
514      * to learn more about how these ids are created.
515      *
516      * This function call must use less than 30 000 gas.
517      */
518     function supportsInterface(bytes4 interfaceId) external view returns (bool);
519 }
520 
521 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
522 
523 
524 
525 pragma solidity ^0.8.0;
526 
527 
528 /**
529  * @dev Implementation of the {IERC165} interface.
530  *
531  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
532  * for the additional interface id that will be supported. For example:
533  *
534  * ```solidity
535  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
536  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
537  * }
538  * ```
539  *
540  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
541  */
542 abstract contract ERC165 is IERC165 {
543     /**
544      * @dev See {IERC165-supportsInterface}.
545      */
546     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
547         return interfaceId == type(IERC165).interfaceId;
548     }
549 }
550 
551 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
552 
553 
554 
555 pragma solidity ^0.8.0;
556 
557 
558 /**
559  * @dev Required interface of an ERC721 compliant contract.
560  */
561 interface IERC721 is IERC165 {
562     /**
563      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
564      */
565     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
566 
567     /**
568      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
569      */
570     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
571 
572     /**
573      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
574      */
575     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
576 
577     /**
578      * @dev Returns the number of tokens in ``owner``'s account.
579      */
580     function balanceOf(address owner) external view returns (uint256 balance);
581 
582     /**
583      * @dev Returns the owner of the `tokenId` token.
584      *
585      * Requirements:
586      *
587      * - `tokenId` must exist.
588      */
589     function ownerOf(uint256 tokenId) external view returns (address owner);
590 
591     /**
592      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
593      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
594      *
595      * Requirements:
596      *
597      * - `from` cannot be the zero address.
598      * - `to` cannot be the zero address.
599      * - `tokenId` token must exist and be owned by `from`.
600      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
601      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
602      *
603      * Emits a {Transfer} event.
604      */
605     function safeTransferFrom(
606         address from,
607         address to,
608         uint256 tokenId
609     ) external;
610 
611     /**
612      * @dev Transfers `tokenId` token from `from` to `to`.
613      *
614      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
615      *
616      * Requirements:
617      *
618      * - `from` cannot be the zero address.
619      * - `to` cannot be the zero address.
620      * - `tokenId` token must be owned by `from`.
621      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
622      *
623      * Emits a {Transfer} event.
624      */
625     function transferFrom(
626         address from,
627         address to,
628         uint256 tokenId
629     ) external;
630 
631     /**
632      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
633      * The approval is cleared when the token is transferred.
634      *
635      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
636      *
637      * Requirements:
638      *
639      * - The caller must own the token or be an approved operator.
640      * - `tokenId` must exist.
641      *
642      * Emits an {Approval} event.
643      */
644     function approve(address to, uint256 tokenId) external;
645 
646     /**
647      * @dev Returns the account approved for `tokenId` token.
648      *
649      * Requirements:
650      *
651      * - `tokenId` must exist.
652      */
653     function getApproved(uint256 tokenId) external view returns (address operator);
654 
655     /**
656      * @dev Approve or remove `operator` as an operator for the caller.
657      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
658      *
659      * Requirements:
660      *
661      * - The `operator` cannot be the caller.
662      *
663      * Emits an {ApprovalForAll} event.
664      */
665     function setApprovalForAll(address operator, bool _approved) external;
666 
667     /**
668      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
669      *
670      * See {setApprovalForAll}
671      */
672     function isApprovedForAll(address owner, address operator) external view returns (bool);
673 
674     /**
675      * @dev Safely transfers `tokenId` token from `from` to `to`.
676      *
677      * Requirements:
678      *
679      * - `from` cannot be the zero address.
680      * - `to` cannot be the zero address.
681      * - `tokenId` token must exist and be owned by `from`.
682      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
683      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
684      *
685      * Emits a {Transfer} event.
686      */
687     function safeTransferFrom(
688         address from,
689         address to,
690         uint256 tokenId,
691         bytes calldata data
692     ) external;
693 }
694 
695 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
696 
697 
698 
699 pragma solidity ^0.8.0;
700 
701 
702 /**
703  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
704  * @dev See https://eips.ethereum.org/EIPS/eip-721
705  */
706 interface IERC721Enumerable is IERC721 {
707     /**
708      * @dev Returns the total amount of tokens stored by the contract.
709      */
710     function totalSupply() external view returns (uint256);
711 
712     /**
713      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
714      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
715      */
716     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
717 
718     /**
719      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
720      * Use along with {totalSupply} to enumerate all tokens.
721      */
722     function tokenByIndex(uint256 index) external view returns (uint256);
723 }
724 
725 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
726 
727 
728 
729 pragma solidity ^0.8.0;
730 
731 
732 /**
733  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
734  * @dev See https://eips.ethereum.org/EIPS/eip-721
735  */
736 interface IERC721Metadata is IERC721 {
737     /**
738      * @dev Returns the token collection name.
739      */
740     function name() external view returns (string memory);
741 
742     /**
743      * @dev Returns the token collection symbol.
744      */
745     function symbol() external view returns (string memory);
746 
747     /**
748      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
749      */
750     function tokenURI(uint256 tokenId) external view returns (string memory);
751 }
752 
753 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
754 
755 
756 
757 pragma solidity ^0.8.0;
758 
759 
760 
761 
762 
763 
764 
765 
766 /**
767  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
768  * the Metadata extension, but not including the Enumerable extension, which is available separately as
769  * {ERC721Enumerable}.
770  */
771 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
772     using Address for address;
773     using Strings for uint256;
774 
775     // Token name
776     string private _name;
777 
778     // Token symbol
779     string private _symbol;
780 
781     // Mapping from token ID to owner address
782     mapping(uint256 => address) private _owners;
783 
784     // Mapping owner address to token count
785     mapping(address => uint256) private _balances;
786 
787     // Mapping from token ID to approved address
788     mapping(uint256 => address) private _tokenApprovals;
789 
790     // Mapping from owner to operator approvals
791     mapping(address => mapping(address => bool)) private _operatorApprovals;
792 
793     /**
794      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
795      */
796     constructor(string memory name_, string memory symbol_) {
797         _name = name_;
798         _symbol = symbol_;
799     }
800 
801     /**
802      * @dev See {IERC165-supportsInterface}.
803      */
804     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
805         return
806             interfaceId == type(IERC721).interfaceId ||
807             interfaceId == type(IERC721Metadata).interfaceId ||
808             super.supportsInterface(interfaceId);
809     }
810 
811     /**
812      * @dev See {IERC721-balanceOf}.
813      */
814     function balanceOf(address owner) public view virtual override returns (uint256) {
815         require(owner != address(0), "ERC721: balance query for the zero address");
816         return _balances[owner];
817     }
818 
819     /**
820      * @dev See {IERC721-ownerOf}.
821      */
822     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
823         address owner = _owners[tokenId];
824         require(owner != address(0), "ERC721: owner query for nonexistent token");
825         return owner;
826     }
827 
828     /**
829      * @dev See {IERC721Metadata-name}.
830      */
831     function name() public view virtual override returns (string memory) {
832         return _name;
833     }
834 
835     /**
836      * @dev See {IERC721Metadata-symbol}.
837      */
838     function symbol() public view virtual override returns (string memory) {
839         return _symbol;
840     }
841 
842     /**
843      * @dev See {IERC721Metadata-tokenURI}.
844      */
845     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
846         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
847 
848         string memory baseURI = _baseURI();
849         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
850     }
851 
852     /**
853      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
854      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
855      * by default, can be overriden in child contracts.
856      */
857     function _baseURI() internal view virtual returns (string memory) {
858         return "";
859     }
860 
861     /**
862      * @dev See {IERC721-approve}.
863      */
864     function approve(address to, uint256 tokenId) public virtual override {
865         address owner = ERC721.ownerOf(tokenId);
866         require(to != owner, "ERC721: approval to current owner");
867 
868         require(
869             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
870             "ERC721: approve caller is not owner nor approved for all"
871         );
872 
873         _approve(to, tokenId);
874     }
875 
876     /**
877      * @dev See {IERC721-getApproved}.
878      */
879     function getApproved(uint256 tokenId) public view virtual override returns (address) {
880         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
881 
882         return _tokenApprovals[tokenId];
883     }
884 
885     /**
886      * @dev See {IERC721-setApprovalForAll}.
887      */
888     function setApprovalForAll(address operator, bool approved) public virtual override {
889         require(operator != _msgSender(), "ERC721: approve to caller");
890 
891         _operatorApprovals[_msgSender()][operator] = approved;
892         emit ApprovalForAll(_msgSender(), operator, approved);
893     }
894 
895     /**
896      * @dev See {IERC721-isApprovedForAll}.
897      */
898     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
899         return _operatorApprovals[owner][operator];
900     }
901 
902     /**
903      * @dev See {IERC721-transferFrom}.
904      */
905     function transferFrom(
906         address from,
907         address to,
908         uint256 tokenId
909     ) public virtual override {
910         //solhint-disable-next-line max-line-length
911         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
912 
913         _transfer(from, to, tokenId);
914     }
915 
916     /**
917      * @dev See {IERC721-safeTransferFrom}.
918      */
919     function safeTransferFrom(
920         address from,
921         address to,
922         uint256 tokenId
923     ) public virtual override {
924         safeTransferFrom(from, to, tokenId, "");
925     }
926 
927     /**
928      * @dev See {IERC721-safeTransferFrom}.
929      */
930     function safeTransferFrom(
931         address from,
932         address to,
933         uint256 tokenId,
934         bytes memory _data
935     ) public virtual override {
936         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
937         _safeTransfer(from, to, tokenId, _data);
938     }
939 
940     /**
941      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
942      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
943      *
944      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
945      *
946      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
947      * implement alternative mechanisms to perform token transfer, such as signature-based.
948      *
949      * Requirements:
950      *
951      * - `from` cannot be the zero address.
952      * - `to` cannot be the zero address.
953      * - `tokenId` token must exist and be owned by `from`.
954      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
955      *
956      * Emits a {Transfer} event.
957      */
958     function _safeTransfer(
959         address from,
960         address to,
961         uint256 tokenId,
962         bytes memory _data
963     ) internal virtual {
964         _transfer(from, to, tokenId);
965         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
966     }
967 
968     /**
969      * @dev Returns whether `tokenId` exists.
970      *
971      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
972      *
973      * Tokens start existing when they are minted (`_mint`),
974      * and stop existing when they are burned (`_burn`).
975      */
976     function _exists(uint256 tokenId) internal view virtual returns (bool) {
977         return _owners[tokenId] != address(0);
978     }
979 
980     /**
981      * @dev Returns whether `spender` is allowed to manage `tokenId`.
982      *
983      * Requirements:
984      *
985      * - `tokenId` must exist.
986      */
987     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
988         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
989         address owner = ERC721.ownerOf(tokenId);
990         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
991     }
992 
993     /**
994      * @dev Safely mints `tokenId` and transfers it to `to`.
995      *
996      * Requirements:
997      *
998      * - `tokenId` must not exist.
999      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1000      *
1001      * Emits a {Transfer} event.
1002      */
1003     function _safeMint(address to, uint256 tokenId) internal virtual {
1004         _safeMint(to, tokenId, "");
1005     }
1006 
1007     /**
1008      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1009      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1010      */
1011     function _safeMint(
1012         address to,
1013         uint256 tokenId,
1014         bytes memory _data
1015     ) internal virtual {
1016         _mint(to, tokenId);
1017         require(
1018             _checkOnERC721Received(address(0), to, tokenId, _data),
1019             "ERC721: transfer to non ERC721Receiver implementer"
1020         );
1021     }
1022 
1023     /**
1024      * @dev Mints `tokenId` and transfers it to `to`.
1025      *
1026      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1027      *
1028      * Requirements:
1029      *
1030      * - `tokenId` must not exist.
1031      * - `to` cannot be the zero address.
1032      *
1033      * Emits a {Transfer} event.
1034      */
1035     function _mint(address to, uint256 tokenId) internal virtual {
1036         require(to != address(0), "ERC721: mint to the zero address");
1037         require(!_exists(tokenId), "ERC721: token already minted");
1038 
1039         _beforeTokenTransfer(address(0), to, tokenId);
1040 
1041         _balances[to] += 1;
1042         _owners[tokenId] = to;
1043 
1044         emit Transfer(address(0), to, tokenId);
1045     }
1046 
1047     /**
1048      * @dev Destroys `tokenId`.
1049      * The approval is cleared when the token is burned.
1050      *
1051      * Requirements:
1052      *
1053      * - `tokenId` must exist.
1054      *
1055      * Emits a {Transfer} event.
1056      */
1057     function _burn(uint256 tokenId) internal virtual {
1058         address owner = ERC721.ownerOf(tokenId);
1059 
1060         _beforeTokenTransfer(owner, address(0), tokenId);
1061 
1062         // Clear approvals
1063         _approve(address(0), tokenId);
1064 
1065         _balances[owner] -= 1;
1066         delete _owners[tokenId];
1067 
1068         emit Transfer(owner, address(0), tokenId);
1069     }
1070 
1071     /**
1072      * @dev Transfers `tokenId` from `from` to `to`.
1073      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1074      *
1075      * Requirements:
1076      *
1077      * - `to` cannot be the zero address.
1078      * - `tokenId` token must be owned by `from`.
1079      *
1080      * Emits a {Transfer} event.
1081      */
1082     function _transfer(
1083         address from,
1084         address to,
1085         uint256 tokenId
1086     ) internal virtual {
1087         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1088         require(to != address(0), "ERC721: transfer to the zero address");
1089 
1090         _beforeTokenTransfer(from, to, tokenId);
1091 
1092         // Clear approvals from the previous owner
1093         _approve(address(0), tokenId);
1094 
1095         _balances[from] -= 1;
1096         _balances[to] += 1;
1097         _owners[tokenId] = to;
1098 
1099         emit Transfer(from, to, tokenId);
1100     }
1101 
1102     /**
1103      * @dev Approve `to` to operate on `tokenId`
1104      *
1105      * Emits a {Approval} event.
1106      */
1107     function _approve(address to, uint256 tokenId) internal virtual {
1108         _tokenApprovals[tokenId] = to;
1109         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1110     }
1111 
1112     /**
1113      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1114      * The call is not executed if the target address is not a contract.
1115      *
1116      * @param from address representing the previous owner of the given token ID
1117      * @param to target address that will receive the tokens
1118      * @param tokenId uint256 ID of the token to be transferred
1119      * @param _data bytes optional data to send along with the call
1120      * @return bool whether the call correctly returned the expected magic value
1121      */
1122     function _checkOnERC721Received(
1123         address from,
1124         address to,
1125         uint256 tokenId,
1126         bytes memory _data
1127     ) private returns (bool) {
1128         if (to.isContract()) {
1129             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1130                 return retval == IERC721Receiver.onERC721Received.selector;
1131             } catch (bytes memory reason) {
1132                 if (reason.length == 0) {
1133                     revert("ERC721: transfer to non ERC721Receiver implementer");
1134                 } else {
1135                     assembly {
1136                         revert(add(32, reason), mload(reason))
1137                     }
1138                 }
1139             }
1140         } else {
1141             return true;
1142         }
1143     }
1144 
1145     /**
1146      * @dev Hook that is called before any token transfer. This includes minting
1147      * and burning.
1148      *
1149      * Calling conditions:
1150      *
1151      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1152      * transferred to `to`.
1153      * - When `from` is zero, `tokenId` will be minted for `to`.
1154      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1155      * - `from` and `to` are never both zero.
1156      *
1157      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1158      */
1159     function _beforeTokenTransfer(
1160         address from,
1161         address to,
1162         uint256 tokenId
1163     ) internal virtual {}
1164 }
1165 
1166 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1167 
1168 
1169 
1170 pragma solidity ^0.8.0;
1171 
1172 
1173 
1174 /**
1175  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1176  * enumerability of all the token ids in the contract as well as all token ids owned by each
1177  * account.
1178  */
1179 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1180     // Mapping from owner to list of owned token IDs
1181     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1182 
1183     // Mapping from token ID to index of the owner tokens list
1184     mapping(uint256 => uint256) private _ownedTokensIndex;
1185 
1186     // Array with all token ids, used for enumeration
1187     uint256[] private _allTokens;
1188 
1189     // Mapping from token id to position in the allTokens array
1190     mapping(uint256 => uint256) private _allTokensIndex;
1191 
1192     /**
1193      * @dev See {IERC165-supportsInterface}.
1194      */
1195     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1196         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1197     }
1198 
1199     /**
1200      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1201      */
1202     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1203         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1204         return _ownedTokens[owner][index];
1205     }
1206 
1207     /**
1208      * @dev See {IERC721Enumerable-totalSupply}.
1209      */
1210     function totalSupply() public view virtual override returns (uint256) {
1211         return _allTokens.length;
1212     }
1213 
1214     /**
1215      * @dev See {IERC721Enumerable-tokenByIndex}.
1216      */
1217     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1218         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1219         return _allTokens[index];
1220     }
1221 
1222     /**
1223      * @dev Hook that is called before any token transfer. This includes minting
1224      * and burning.
1225      *
1226      * Calling conditions:
1227      *
1228      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1229      * transferred to `to`.
1230      * - When `from` is zero, `tokenId` will be minted for `to`.
1231      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1232      * - `from` cannot be the zero address.
1233      * - `to` cannot be the zero address.
1234      *
1235      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1236      */
1237     function _beforeTokenTransfer(
1238         address from,
1239         address to,
1240         uint256 tokenId
1241     ) internal virtual override {
1242         super._beforeTokenTransfer(from, to, tokenId);
1243 
1244         if (from == address(0)) {
1245             _addTokenToAllTokensEnumeration(tokenId);
1246         } else if (from != to) {
1247             _removeTokenFromOwnerEnumeration(from, tokenId);
1248         }
1249         if (to == address(0)) {
1250             _removeTokenFromAllTokensEnumeration(tokenId);
1251         } else if (to != from) {
1252             _addTokenToOwnerEnumeration(to, tokenId);
1253         }
1254     }
1255 
1256     /**
1257      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1258      * @param to address representing the new owner of the given token ID
1259      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1260      */
1261     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1262         uint256 length = ERC721.balanceOf(to);
1263         _ownedTokens[to][length] = tokenId;
1264         _ownedTokensIndex[tokenId] = length;
1265     }
1266 
1267     /**
1268      * @dev Private function to add a token to this extension's token tracking data structures.
1269      * @param tokenId uint256 ID of the token to be added to the tokens list
1270      */
1271     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1272         _allTokensIndex[tokenId] = _allTokens.length;
1273         _allTokens.push(tokenId);
1274     }
1275 
1276     /**
1277      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1278      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1279      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1280      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1281      * @param from address representing the previous owner of the given token ID
1282      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1283      */
1284     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1285         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1286         // then delete the last slot (swap and pop).
1287 
1288         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1289         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1290 
1291         // When the token to delete is the last token, the swap operation is unnecessary
1292         if (tokenIndex != lastTokenIndex) {
1293             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1294 
1295             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1296             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1297         }
1298 
1299         // This also deletes the contents at the last position of the array
1300         delete _ownedTokensIndex[tokenId];
1301         delete _ownedTokens[from][lastTokenIndex];
1302     }
1303 
1304     /**
1305      * @dev Private function to remove a token from this extension's token tracking data structures.
1306      * This has O(1) time complexity, but alters the order of the _allTokens array.
1307      * @param tokenId uint256 ID of the token to be removed from the tokens list
1308      */
1309     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1310         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1311         // then delete the last slot (swap and pop).
1312 
1313         uint256 lastTokenIndex = _allTokens.length - 1;
1314         uint256 tokenIndex = _allTokensIndex[tokenId];
1315 
1316         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1317         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1318         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1319         uint256 lastTokenId = _allTokens[lastTokenIndex];
1320 
1321         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1322         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1323 
1324         // This also deletes the contents at the last position of the array
1325         delete _allTokensIndex[tokenId];
1326         _allTokens.pop();
1327     }
1328 }
1329 
1330 // File: contracts/Skvllbabiez.sol
1331 
1332 
1333 pragma solidity ^0.8.0;
1334 
1335 
1336 
1337 
1338 
1339 contract Skvllbabiez is ERC721Enumerable, Ownable, ReentrancyGuard {
1340 
1341     using Strings for uint256;
1342     
1343     event SkvllbabiezPublicSaleStarted();
1344     event SkvllbabiezPublicSalePaused();
1345     
1346     address private skvllpvnkzContractAddress = 0xB28a4FdE7B6c3Eb0C914d7b4d3ddb4544c3bcbd6;
1347     
1348     uint256 private _maxSupply = 5000;
1349     uint256 private _tokenId = 0;
1350     
1351     string _baseTokenURI;
1352     bool public _publicSale = false;
1353     bool private _provenanceSet = false;
1354     string public provenance = "";
1355     string private _contractURI = "http://api.skvllbabiez.io/contract";
1356     
1357     mapping(uint256 => bool) private _usedSkvllz;
1358         
1359     constructor() ERC721("Skvllpvnkz Daycare", "SKVLLBABIEZ") {}
1360     
1361     function makeBabiez(uint256[] memory tokens) external nonReentrant {
1362         require( _publicSale, "Sale paused" );
1363         require(tokens.length > 1, "Need at least 2 tokens");
1364         require(tokens.length % 2 == 0, "Need to supply an even number of tokens");
1365         for (uint256 i=0; i < tokens.length; i=i+2){
1366             if (tokens[i] != tokens[i+1]
1367                 && !_usedSkvllz[tokens[i]] 
1368                 && !_usedSkvllz[tokens[i+1]]
1369                 && ISkvllpvnkz(skvllpvnkzContractAddress).ownerOf( tokens[i] ) == msg.sender
1370                 && ISkvllpvnkz(skvllpvnkzContractAddress).ownerOf( tokens[i+1] ) == msg.sender) {
1371                     _usedSkvllz[tokens[i]] = true;
1372                     _usedSkvllz[tokens[i+1]] = true;
1373                     _tokenId ++;
1374                     _safeMint( msg.sender,  _tokenId );
1375              }
1376         }
1377     }
1378     
1379     function isUsed(uint256 skvllpvnkId) external view returns (bool){
1380         return _usedSkvllz[skvllpvnkId];
1381     }
1382     
1383     function toggleUsed(uint256 skvllpvnkId, bool usedValue) external onlyOwner {
1384         _usedSkvllz[skvllpvnkId] = usedValue;
1385     }
1386     
1387     function unclaimedSkvllpvnkzCount(address _owner) public view returns (uint256){
1388         uint256[] memory tokenIds = ISkvllpvnkz(skvllpvnkzContractAddress).walletOfOwner( _owner );
1389         uint256 count = 0;
1390         for (uint256 i=0; i < tokenIds.length; i++){
1391             if (!_usedSkvllz[tokenIds[i]]) count++;
1392         }
1393         return count;
1394     }
1395     
1396     function unclaimedSkvllpvnkzCountIDs(address _owner) external view returns (uint256[] memory){
1397         uint256[] memory tokenIds = ISkvllpvnkz(skvllpvnkzContractAddress).walletOfOwner( _owner );
1398         uint256[] memory unusedTokenIds = new uint256[](unclaimedSkvllpvnkzCount(_owner));
1399         uint256 j = 0;
1400         for (uint256 i=0; i < tokenIds.length; i++){
1401             if (!_usedSkvllz[tokenIds[i]]) {
1402                 unusedTokenIds[j] = tokenIds[i];
1403                 j++;
1404             }
1405         }
1406         return unusedTokenIds;
1407     }
1408     
1409     function walletOfOwner(address _owner) external view returns(uint256[] memory) {
1410         uint256 tokenCount = balanceOf(_owner);
1411         uint256[] memory tokensId = new uint256[](tokenCount);
1412         for(uint256 i; i < tokenCount; i++){
1413             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1414         }
1415         return tokensId;
1416     }
1417     
1418     function publicSale(bool val) external onlyOwner {
1419         _publicSale = val;
1420         if (val) {
1421             emit SkvllbabiezPublicSaleStarted();
1422         } else {
1423             emit SkvllbabiezPublicSalePaused();
1424         }
1425     }
1426 
1427     function _baseURI() internal view virtual override returns (string memory) {
1428         return _baseTokenURI;
1429     }
1430 
1431     function setBaseURI(string memory baseURI) external onlyOwner {
1432         _baseTokenURI = baseURI;
1433     }
1434     
1435     function remainingSupply() public view returns (uint256) {
1436         return _maxSupply - _tokenId;
1437     }
1438     
1439     function setSkvllpvnkzContractAddress(address _address) external onlyOwner {
1440         skvllpvnkzContractAddress = _address;
1441     }
1442     
1443     function maxSupply() external view returns (uint256){
1444         return _maxSupply;
1445     }
1446 
1447     function withdraw(uint256 amount) external payable onlyOwner {
1448         require(payable(msg.sender).send(amount));
1449     }
1450     
1451     function setContractURI(string memory uri) external onlyOwner {
1452         _contractURI = uri;
1453     }
1454     
1455     function contractURI() external view returns (string memory) {
1456         return _contractURI;
1457     }
1458     
1459     function setProvenance(string memory _provenance) external onlyOwner {
1460         require(!_provenanceSet, "Provenance has been set already");
1461         provenance = _provenance;
1462         _provenanceSet = true;
1463     }
1464 }