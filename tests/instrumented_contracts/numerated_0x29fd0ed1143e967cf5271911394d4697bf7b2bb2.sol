1 // SPDX-License-Identifier: MIT
2 
3 
4 pragma solidity 0.8.4;
5 
6 
7 
8 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
9 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
10 
11 
12 /**
13  * @dev Contract module that helps prevent reentrant calls to a function.
14  *
15  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
16  * available, which can be applied to functions to make sure there are no nested
17  * (reentrant) calls to them.
18  *
19  * Note that because there is a single `nonReentrant` guard, functions marked as
20  * `nonReentrant` may not call one another. This can be worked around by making
21  * those functions `private`, and then adding `external` `nonReentrant` entry
22  * points to them.
23  *
24  * TIP: If you would like to learn more about reentrancy and alternative ways
25  * to protect against it, check out our blog post
26  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
27  */
28 abstract contract ReentrancyGuard {
29     // Booleans are more expensive than uint256 or any type that takes up a full
30     // word because each write operation emits an extra SLOAD to first read the
31     // slot's contents, replace the bits taken up by the boolean, and then write
32     // back. This is the compiler's defense against contract upgrades and
33     // pointer aliasing, and it cannot be disabled.
34 
35     // The values being non-zero value makes deployment a bit more expensive,
36     // but in exchange the refund on every call to nonReentrant will be lower in
37     // amount. Since refunds are capped to a percentage of the total
38     // transaction's gas, it is best to keep them low in cases like this one, to
39     // increase the likelihood of the full refund coming into effect.
40     uint256 private constant _NOT_ENTERED = 1;
41     uint256 private constant _ENTERED = 2;
42 
43     uint256 private _status;
44 
45     constructor() {
46         _status = _NOT_ENTERED;
47     }
48 
49     /**
50      * @dev Prevents a contract from calling itself, directly or indirectly.
51      * Calling a `nonReentrant` function from another `nonReentrant`
52      * function is not supported. It is possible to prevent this from happening
53      * by making the `nonReentrant` function external, and making it call a
54      * `private` function that does the actual work.
55      */
56     modifier nonReentrant() {
57         // On the first call to nonReentrant, _notEntered will be true
58         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
59 
60         // Any calls to nonReentrant after this point will fail
61         _status = _ENTERED;
62 
63         _;
64 
65         // By storing the original value once again, a refund is triggered (see
66         // https://eips.ethereum.org/EIPS/eip-2200)
67         _status = _NOT_ENTERED;
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/Strings.sol
72 
73 
74 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
75 
76 
77 
78 /**
79  * @dev String operations.
80  */
81 library Strings {
82     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
83 
84     /**
85      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
86      */
87     function toString(uint256 value) internal pure returns (string memory) {
88         // Inspired by OraclizeAPI's implementation - MIT licence
89         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
90 
91         if (value == 0) {
92             return "0";
93         }
94         uint256 temp = value;
95         uint256 digits;
96         while (temp != 0) {
97             digits++;
98             temp /= 10;
99         }
100         bytes memory buffer = new bytes(digits);
101         while (value != 0) {
102             digits -= 1;
103             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
104             value /= 10;
105         }
106         return string(buffer);
107     }
108 
109     /**
110      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
111      */
112     function toHexString(uint256 value) internal pure returns (string memory) {
113         if (value == 0) {
114             return "0x00";
115         }
116         uint256 temp = value;
117         uint256 length = 0;
118         while (temp != 0) {
119             length++;
120             temp >>= 8;
121         }
122         return toHexString(value, length);
123     }
124 
125     /**
126      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
127      */
128     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
129         bytes memory buffer = new bytes(2 * length + 2);
130         buffer[0] = "0";
131         buffer[1] = "x";
132         for (uint256 i = 2 * length + 1; i > 1; --i) {
133             buffer[i] = _HEX_SYMBOLS[value & 0xf];
134             value >>= 4;
135         }
136         require(value == 0, "Strings: hex length insufficient");
137         return string(buffer);
138     }
139 }
140 
141 // File: @openzeppelin/contracts/utils/Context.sol
142 
143 
144 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
145 
146 /**
147  * @dev Provides information about the current execution context, including the
148  * sender of the transaction and its data. While these are generally available
149  * via msg.sender and msg.data, they should not be accessed in such a direct
150  * manner, since when dealing with meta-transactions the account sending and
151  * paying for execution may not be the actual sender (as far as an application
152  * is concerned).
153  *
154  * This contract is only required for intermediate, library-like contracts.
155  */
156 abstract contract Context {
157     function _msgSender() internal view virtual returns (address) {
158         return msg.sender;
159     }
160 
161     function _msgData() internal view virtual returns (bytes calldata) {
162         return msg.data;
163     }
164 }
165 
166 // File: @openzeppelin/contracts/access/Ownable.sol
167 
168 
169 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
170 
171 
172 
173 
174 /**
175  * @dev Contract module which provides a basic access control mechanism, where
176  * there is an account (an owner) that can be granted exclusive access to
177  * specific functions.
178  *
179  * By default, the owner account will be the one that deploys the contract. This
180  * can later be changed with {transferOwnership}.
181  *
182  * This module is used through inheritance. It will make available the modifier
183  * `onlyOwner`, which can be applied to your functions to restrict their use to
184  * the owner.
185  */
186 abstract contract Ownable is Context {
187     address private _owner;
188 
189     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
190 
191     /**
192      * @dev Initializes the contract setting the deployer as the initial owner.
193      */
194     constructor() {
195         _transferOwnership(_msgSender());
196     }
197 
198     /**
199      * @dev Returns the address of the current owner.
200      */
201     function owner() public view virtual returns (address) {
202         return _owner;
203     }
204 
205     /**
206      * @dev Throws if called by any account other than the owner.
207      */
208     modifier onlyOwner() {
209         require(owner() == _msgSender(), "Ownable: caller is not the owner");
210         _;
211     }
212 
213     /**
214      * @dev Leaves the contract without owner. It will not be possible to call
215      * `onlyOwner` functions anymore. Can only be called by the current owner.
216      *
217      * NOTE: Renouncing ownership will leave the contract without an owner,
218      * thereby removing any functionality that is only available to the owner.
219      */
220     function renounceOwnership() public virtual onlyOwner {
221         _transferOwnership(address(0));
222     }
223 
224     /**
225      * @dev Transfers ownership of the contract to a new account (`newOwner`).
226      * Can only be called by the current owner.
227      */
228     function transferOwnership(address newOwner) public virtual onlyOwner {
229         require(newOwner != address(0), "Ownable: new owner is the zero address");
230         _transferOwnership(newOwner);
231     }
232 
233     /**
234      * @dev Transfers ownership of the contract to a new account (`newOwner`).
235      * Internal function without access restriction.
236      */
237     function _transferOwnership(address newOwner) internal virtual {
238         address oldOwner = _owner;
239         _owner = newOwner;
240         emit OwnershipTransferred(oldOwner, newOwner);
241     }
242 }
243 
244 // File: @openzeppelin/contracts/utils/Address.sol
245 
246 
247 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
248 
249 
250 /**
251  * @dev Collection of functions related to the address type
252  */
253 library Address {
254     /**
255      * @dev Returns true if `account` is a contract.
256      *
257      * [IMPORTANT]
258      * ====
259      * It is unsafe to assume that an address for which this function returns
260      * false is an externally-owned account (EOA) and not a contract.
261      *
262      * Among others, `isContract` will return false for the following
263      * types of addresses:
264      *
265      *  - an externally-owned account
266      *  - a contract in construction
267      *  - an address where a contract will be created
268      *  - an address where a contract lived, but was destroyed
269      * ====
270      */
271     function isContract(address account) internal view returns (bool) {
272         // This method relies on extcodesize, which returns 0 for contracts in
273         // construction, since the code is only stored at the end of the
274         // constructor execution.
275 
276         uint256 size;
277         assembly {
278             size := extcodesize(account)
279         }
280         return size > 0;
281     }
282 
283     /**
284      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
285      * `recipient`, forwarding all available gas and reverting on errors.
286      *
287      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
288      * of certain opcodes, possibly making contracts go over the 2300 gas limit
289      * imposed by `transfer`, making them unable to receive funds via
290      * `transfer`. {sendValue} removes this limitation.
291      *
292      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
293      *
294      * IMPORTANT: because control is transferred to `recipient`, care must be
295      * taken to not create reentrancy vulnerabilities. Consider using
296      * {ReentrancyGuard} or the
297      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
298      */
299     function sendValue(address payable recipient, uint256 amount) internal {
300         require(address(this).balance >= amount, "Address: insufficient balance");
301 
302         (bool success, ) = recipient.call{value: amount}("");
303         require(success, "Address: unable to send value, recipient may have reverted");
304     }
305 
306     /**
307      * @dev Performs a Solidity function call using a low level `call`. A
308      * plain `call` is an unsafe replacement for a function call: use this
309      * function instead.
310      *
311      * If `target` reverts with a revert reason, it is bubbled up by this
312      * function (like regular Solidity function calls).
313      *
314      * Returns the raw returned data. To convert to the expected return value,
315      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
316      *
317      * Requirements:
318      *
319      * - `target` must be a contract.
320      * - calling `target` with `data` must not revert.
321      *
322      * _Available since v3.1._
323      */
324     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
325         return functionCall(target, data, "Address: low-level call failed");
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
330      * `errorMessage` as a fallback revert reason when `target` reverts.
331      *
332      * _Available since v3.1._
333      */
334     function functionCall(
335         address target,
336         bytes memory data,
337         string memory errorMessage
338     ) internal returns (bytes memory) {
339         return functionCallWithValue(target, data, 0, errorMessage);
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
344      * but also transferring `value` wei to `target`.
345      *
346      * Requirements:
347      *
348      * - the calling contract must have an ETH balance of at least `value`.
349      * - the called Solidity function must be `payable`.
350      *
351      * _Available since v3.1._
352      */
353     function functionCallWithValue(
354         address target,
355         bytes memory data,
356         uint256 value
357     ) internal returns (bytes memory) {
358         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
363      * with `errorMessage` as a fallback revert reason when `target` reverts.
364      *
365      * _Available since v3.1._
366      */
367     function functionCallWithValue(
368         address target,
369         bytes memory data,
370         uint256 value,
371         string memory errorMessage
372     ) internal returns (bytes memory) {
373         require(address(this).balance >= value, "Address: insufficient balance for call");
374         require(isContract(target), "Address: call to non-contract");
375 
376         (bool success, bytes memory returndata) = target.call{value: value}(data);
377         return verifyCallResult(success, returndata, errorMessage);
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
382      * but performing a static call.
383      *
384      * _Available since v3.3._
385      */
386     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
387         return functionStaticCall(target, data, "Address: low-level static call failed");
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
392      * but performing a static call.
393      *
394      * _Available since v3.3._
395      */
396     function functionStaticCall(
397         address target,
398         bytes memory data,
399         string memory errorMessage
400     ) internal view returns (bytes memory) {
401         require(isContract(target), "Address: static call to non-contract");
402 
403         (bool success, bytes memory returndata) = target.staticcall(data);
404         return verifyCallResult(success, returndata, errorMessage);
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
409      * but performing a delegate call.
410      *
411      * _Available since v3.4._
412      */
413     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
414         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
419      * but performing a delegate call.
420      *
421      * _Available since v3.4._
422      */
423     function functionDelegateCall(
424         address target,
425         bytes memory data,
426         string memory errorMessage
427     ) internal returns (bytes memory) {
428         require(isContract(target), "Address: delegate call to non-contract");
429 
430         (bool success, bytes memory returndata) = target.delegatecall(data);
431         return verifyCallResult(success, returndata, errorMessage);
432     }
433 
434     /**
435      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
436      * revert reason using the provided one.
437      *
438      * _Available since v4.3._
439      */
440     function verifyCallResult(
441         bool success,
442         bytes memory returndata,
443         string memory errorMessage
444     ) internal pure returns (bytes memory) {
445         if (success) {
446             return returndata;
447         } else {
448             // Look for revert reason and bubble it up if present
449             if (returndata.length > 0) {
450                 // The easiest way to bubble the revert reason is using memory via assembly
451 
452                 assembly {
453                     let returndata_size := mload(returndata)
454                     revert(add(32, returndata), returndata_size)
455                 }
456             } else {
457                 revert(errorMessage);
458             }
459         }
460     }
461 }
462 
463 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
464 
465 
466 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
467 
468 
469 /**
470  * @title ERC721 token receiver interface
471  * @dev Interface for any contract that wants to support safeTransfers
472  * from ERC721 asset contracts.
473  */
474 interface IERC721Receiver {
475     /**
476      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
477      * by `operator` from `from`, this function is called.
478      *
479      * It must return its Solidity selector to confirm the token transfer.
480      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
481      *
482      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
483      */
484     function onERC721Received(
485         address operator,
486         address from,
487         uint256 tokenId,
488         bytes calldata data
489     ) external returns (bytes4);
490 }
491 
492 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
493 
494 
495 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
496 
497 
498 /**
499  * @dev Interface of the ERC165 standard, as defined in the
500  * https://eips.ethereum.org/EIPS/eip-165[EIP].
501  *
502  * Implementers can declare support of contract interfaces, which can then be
503  * queried by others ({ERC165Checker}).
504  *
505  * For an implementation, see {ERC165}.
506  */
507 interface IERC165 {
508     /**
509      * @dev Returns true if this contract implements the interface defined by
510      * `interfaceId`. See the corresponding
511      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
512      * to learn more about how these ids are created.
513      *
514      * This function call must use less than 30 000 gas.
515      */
516     function supportsInterface(bytes4 interfaceId) external view returns (bool);
517 }
518 
519 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
520 
521 
522 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
523 
524 
525 
526 /**
527  * @dev Implementation of the {IERC165} interface.
528  *
529  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
530  * for the additional interface id that will be supported. For example:
531  *
532  * ```solidity
533  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
534  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
535  * }
536  * ```
537  *
538  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
539  */
540 abstract contract ERC165 is IERC165 {
541     /**
542      * @dev See {IERC165-supportsInterface}.
543      */
544     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
545         return interfaceId == type(IERC165).interfaceId;
546     }
547 }
548 
549 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
550 
551 
552 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
553 
554 
555 
556 /**
557  * @dev Required interface of an ERC721 compliant contract.
558  */
559 interface IERC721 is IERC165 {
560     /**
561      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
562      */
563     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
564 
565     /**
566      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
567      */
568     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
569 
570     /**
571      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
572      */
573     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
574 
575     /**
576      * @dev Returns the number of tokens in ``owner``'s account.
577      */
578     function balanceOf(address owner) external view returns (uint256 balance);
579 
580     /**
581      * @dev Returns the owner of the `tokenId` token.
582      *
583      * Requirements:
584      *
585      * - `tokenId` must exist.
586      */
587     function ownerOf(uint256 tokenId) external view returns (address owner);
588 
589     /**
590      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
591      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
592      *
593      * Requirements:
594      *
595      * - `from` cannot be the zero address.
596      * - `to` cannot be the zero address.
597      * - `tokenId` token must exist and be owned by `from`.
598      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
599      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
600      *
601      * Emits a {Transfer} event.
602      */
603     function safeTransferFrom(
604         address from,
605         address to,
606         uint256 tokenId
607     ) external;
608 
609     /**
610      * @dev Transfers `tokenId` token from `from` to `to`.
611      *
612      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
613      *
614      * Requirements:
615      *
616      * - `from` cannot be the zero address.
617      * - `to` cannot be the zero address.
618      * - `tokenId` token must be owned by `from`.
619      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
620      *
621      * Emits a {Transfer} event.
622      */
623     function transferFrom(
624         address from,
625         address to,
626         uint256 tokenId
627     ) external;
628 
629     /**
630      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
631      * The approval is cleared when the token is transferred.
632      *
633      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
634      *
635      * Requirements:
636      *
637      * - The caller must own the token or be an approved operator.
638      * - `tokenId` must exist.
639      *
640      * Emits an {Approval} event.
641      */
642     function approve(address to, uint256 tokenId) external;
643 
644     /**
645      * @dev Returns the account approved for `tokenId` token.
646      *
647      * Requirements:
648      *
649      * - `tokenId` must exist.
650      */
651     function getApproved(uint256 tokenId) external view returns (address operator);
652 
653     /**
654      * @dev Approve or remove `operator` as an operator for the caller.
655      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
656      *
657      * Requirements:
658      *
659      * - The `operator` cannot be the caller.
660      *
661      * Emits an {ApprovalForAll} event.
662      */
663     function setApprovalForAll(address operator, bool _approved) external;
664 
665     /**
666      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
667      *
668      * See {setApprovalForAll}
669      */
670     function isApprovedForAll(address owner, address operator) external view returns (bool);
671 
672     /**
673      * @dev Safely transfers `tokenId` token from `from` to `to`.
674      *
675      * Requirements:
676      *
677      * - `from` cannot be the zero address.
678      * - `to` cannot be the zero address.
679      * - `tokenId` token must exist and be owned by `from`.
680      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
681      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
682      *
683      * Emits a {Transfer} event.
684      */
685     function safeTransferFrom(
686         address from,
687         address to,
688         uint256 tokenId,
689         bytes calldata data
690     ) external;
691 }
692 
693 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
694 
695 
696 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
697 
698 
699 
700 /**
701  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
702  * @dev See https://eips.ethereum.org/EIPS/eip-721
703  */
704 interface IERC721Enumerable is IERC721 {
705     /**
706      * @dev Returns the total amount of tokens stored by the contract.
707      */
708     function totalSupply() external view returns (uint256);
709 
710     /**
711      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
712      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
713      */
714     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
715 
716     /**
717      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
718      * Use along with {totalSupply} to enumerate all tokens.
719      */
720     function tokenByIndex(uint256 index) external view returns (uint256);
721 }
722 
723 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
724 
725 
726 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
727 
728 
729 
730 /**
731  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
732  * @dev See https://eips.ethereum.org/EIPS/eip-721
733  */
734 interface IERC721Metadata is IERC721 {
735     /**
736      * @dev Returns the token collection name.
737      */
738     function name() external view returns (string memory);
739 
740     /**
741      * @dev Returns the token collection symbol.
742      */
743     function symbol() external view returns (string memory);
744 
745     /**
746      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
747      */
748     function tokenURI(uint256 tokenId) external view returns (string memory);
749 }
750 
751 
752 
753 /**
754  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
755  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
756  *
757  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
758  *
759  * Does not support burning tokens to address(0).
760  *
761  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
762  */
763 
764 
765 error ApprovalCallerNotOwnerNorApproved();
766 error ApprovalQueryForNonexistentToken();
767 error ApproveToCaller();
768 error ApprovalToCurrentOwner();
769 error BalanceQueryForZeroAddress();
770 error MintedQueryForZeroAddress();
771 error BurnedQueryForZeroAddress();
772 error AuxQueryForZeroAddress();
773 error MintToZeroAddress();
774 error MintZeroQuantity();
775 error OwnerIndexOutOfBounds();
776 error OwnerQueryForNonexistentToken();
777 error TokenIndexOutOfBounds();
778 error TransferCallerNotOwnerNorApproved();
779 error TransferFromIncorrectOwner();
780 error TransferToNonERC721ReceiverImplementer();
781 error TransferToZeroAddress();
782 error URIQueryForNonexistentToken();
783 
784 /**
785  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
786  * the Metadata extension. Built to optimize for lower gas during batch mints.
787  *
788  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
789  *
790  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
791  *
792  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
793  */
794 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
795     using Address for address;
796     using Strings for uint256;
797 
798     // Compiler will pack this into a single 256bit word.
799     struct TokenOwnership {
800         // The address of the owner.
801         address addr;
802         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
803         uint64 startTimestamp;
804         // Whether the token has been burned.
805         bool burned;
806     }
807 
808     // Compiler will pack this into a single 256bit word.
809     struct AddressData {
810         // Realistically, 2**64-1 is more than enough.
811         uint64 balance;
812         // Keeps track of mint count with minimal overhead for tokenomics.
813         uint64 numberMinted;
814         // Keeps track of burn count with minimal overhead for tokenomics.
815         uint64 numberBurned;
816         // For miscellaneous variable(s) pertaining to the address
817         // (e.g. number of whitelist mint slots used). 
818         // If there are multiple variables, please pack them into a uint64.
819         uint64 aux;
820     }
821 
822     // The tokenId of the next token to be minted.
823     uint256 internal _currentIndex;
824 
825     // The number of tokens burned.
826     uint256 internal _burnCounter;
827 
828     // Token name
829     string private _name;
830 
831     // Token symbol
832     string private _symbol;
833 
834     // Mapping from token ID to ownership details
835     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
836     mapping(uint256 => TokenOwnership) internal _ownerships;
837 
838     // Mapping owner address to address data
839     mapping(address => AddressData) private _addressData;
840 
841     // Mapping from token ID to approved address
842     mapping(uint256 => address) private _tokenApprovals;
843 
844     // Mapping from owner to operator approvals
845     mapping(address => mapping(address => bool)) private _operatorApprovals;
846 
847     constructor(string memory name_, string memory symbol_) {
848         _name = name_;
849         _symbol = symbol_;
850     }
851 
852     /**
853      * @dev See {IERC721Enumerable-totalSupply}.
854      */
855     function totalSupply() public view returns (uint256) {
856         // Counter underflow is impossible as _burnCounter cannot be incremented
857         // more than _currentIndex times
858         unchecked {
859             return _currentIndex - _burnCounter;    
860         }
861     }
862 
863     /**
864      * @dev See {IERC165-supportsInterface}.
865      */
866     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
867         return
868             interfaceId == type(IERC721).interfaceId ||
869             interfaceId == type(IERC721Metadata).interfaceId ||
870             super.supportsInterface(interfaceId);
871     }
872 
873     /**
874      * @dev See {IERC721-balanceOf}.
875      */
876     function balanceOf(address owner) public view override returns (uint256) {
877         if (owner == address(0)) revert BalanceQueryForZeroAddress();
878         return uint256(_addressData[owner].balance);
879     }
880 
881     /**
882      * Returns the number of tokens minted by `owner`.
883      */
884     function _numberMinted(address owner) internal view returns (uint256) {
885         if (owner == address(0)) revert MintedQueryForZeroAddress();
886         return uint256(_addressData[owner].numberMinted);
887     }
888 
889     /**
890      * Returns the number of tokens burned by or on behalf of `owner`.
891      */
892     function _numberBurned(address owner) internal view returns (uint256) {
893         if (owner == address(0)) revert BurnedQueryForZeroAddress();
894         return uint256(_addressData[owner].numberBurned);
895     }
896 
897     /**
898      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
899      */
900     function _getAux(address owner) internal view returns (uint64) {
901         if (owner == address(0)) revert AuxQueryForZeroAddress();
902         return _addressData[owner].aux;
903     }
904 
905     /**
906      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
907      * If there are multiple variables, please pack them into a uint64.
908      */
909     function _setAux(address owner, uint64 aux) internal {
910         if (owner == address(0)) revert AuxQueryForZeroAddress();
911         _addressData[owner].aux = aux;
912     }
913 
914     /**
915      * Gas spent here starts off proportional to the maximum mint batch size.
916      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
917      */
918     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
919         uint256 curr = tokenId;
920 
921         unchecked {
922             if (curr < _currentIndex) {
923                 TokenOwnership memory ownership = _ownerships[curr];
924                 if (!ownership.burned) {
925                     if (ownership.addr != address(0)) {
926                         return ownership;
927                     }
928                     // Invariant: 
929                     // There will always be an ownership that has an address and is not burned 
930                     // before an ownership that does not have an address and is not burned.
931                     // Hence, curr will not underflow.
932                     while (true) {
933                         curr--;
934                         ownership = _ownerships[curr];
935                         if (ownership.addr != address(0)) {
936                             return ownership;
937                         }
938                     }
939                 }
940             }
941         }
942         revert OwnerQueryForNonexistentToken();
943     }
944 
945     /**
946      * @dev See {IERC721-ownerOf}.
947      */
948     function ownerOf(uint256 tokenId) public view override returns (address) {
949         return ownershipOf(tokenId).addr;
950     }
951 
952     /**
953      * @dev See {IERC721Metadata-name}.
954      */
955     function name() public view virtual override returns (string memory) {
956         return _name;
957     }
958 
959     /**
960      * @dev See {IERC721Metadata-symbol}.
961      */
962     function symbol() public view virtual override returns (string memory) {
963         return _symbol;
964     }
965 
966     /**
967      * @dev See {IERC721Metadata-tokenURI}.
968      */
969     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
970         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
971 
972         string memory baseURI = _baseURI();
973         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
974     }
975 
976     /**
977      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
978      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
979      * by default, can be overriden in child contracts.
980      */
981     function _baseURI() internal view virtual returns (string memory) {
982         return '';
983     }
984 
985     /**
986      * @dev See {IERC721-approve}.
987      */
988     function approve(address to, uint256 tokenId) public override {
989         address owner = ERC721A.ownerOf(tokenId);
990         if (to == owner) revert ApprovalToCurrentOwner();
991 
992         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
993             revert ApprovalCallerNotOwnerNorApproved();
994         }
995 
996         _approve(to, tokenId, owner);
997     }
998 
999     /**
1000      * @dev See {IERC721-getApproved}.
1001      */
1002     function getApproved(uint256 tokenId) public view override returns (address) {
1003         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1004 
1005         return _tokenApprovals[tokenId];
1006     }
1007 
1008     /**
1009      * @dev See {IERC721-setApprovalForAll}.
1010      */
1011     function setApprovalForAll(address operator, bool approved) public override {
1012         if (operator == _msgSender()) revert ApproveToCaller();
1013 
1014         _operatorApprovals[_msgSender()][operator] = approved;
1015         emit ApprovalForAll(_msgSender(), operator, approved);
1016     }
1017 
1018     /**
1019      * @dev See {IERC721-isApprovedForAll}.
1020      */
1021     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1022         return _operatorApprovals[owner][operator];
1023     }
1024 
1025     /**
1026      * @dev See {IERC721-transferFrom}.
1027      */
1028     function transferFrom(
1029         address from,
1030         address to,
1031         uint256 tokenId
1032     ) public virtual override {
1033         _transfer(from, to, tokenId);
1034     }
1035 
1036     /**
1037      * @dev See {IERC721-safeTransferFrom}.
1038      */
1039     function safeTransferFrom(
1040         address from,
1041         address to,
1042         uint256 tokenId
1043     ) public virtual override {
1044         safeTransferFrom(from, to, tokenId, '');
1045     }
1046 
1047     /**
1048      * @dev See {IERC721-safeTransferFrom}.
1049      */
1050     function safeTransferFrom(
1051         address from,
1052         address to,
1053         uint256 tokenId,
1054         bytes memory _data
1055     ) public virtual override {
1056         _transfer(from, to, tokenId);
1057         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1058             revert TransferToNonERC721ReceiverImplementer();
1059         }
1060     }
1061 
1062     /**
1063      * @dev Returns whether `tokenId` exists.
1064      *
1065      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1066      *
1067      * Tokens start existing when they are minted (`_mint`),
1068      */
1069     function _exists(uint256 tokenId) internal view returns (bool) {
1070         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1071     }
1072 
1073     function _safeMint(address to, uint256 quantity) internal {
1074         _safeMint(to, quantity, '');
1075     }
1076 
1077     /**
1078      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1079      *
1080      * Requirements:
1081      *
1082      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1083      * - `quantity` must be greater than 0.
1084      *
1085      * Emits a {Transfer} event.
1086      */
1087     function _safeMint(
1088         address to,
1089         uint256 quantity,
1090         bytes memory _data
1091     ) internal {
1092         _mint(to, quantity, _data, true);
1093     }
1094 
1095     /**
1096      * @dev Mints `quantity` tokens and transfers them to `to`.
1097      *
1098      * Requirements:
1099      *
1100      * - `to` cannot be the zero address.
1101      * - `quantity` must be greater than 0.
1102      *
1103      * Emits a {Transfer} event.
1104      */
1105     function _mint(
1106         address to,
1107         uint256 quantity,
1108         bytes memory _data,
1109         bool safe
1110     ) internal {
1111         uint256 startTokenId = _currentIndex;
1112         if (to == address(0)) revert MintToZeroAddress();
1113         if (quantity == 0) revert MintZeroQuantity();
1114 
1115         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1116 
1117         // Overflows are incredibly unrealistic.
1118         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1119         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1120         unchecked {
1121             _addressData[to].balance += uint64(quantity);
1122             _addressData[to].numberMinted += uint64(quantity);
1123 
1124             _ownerships[startTokenId].addr = to;
1125             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1126 
1127             uint256 updatedIndex = startTokenId;
1128 
1129             for (uint256 i; i < quantity; i++) {
1130                 emit Transfer(address(0), to, updatedIndex);
1131                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1132                     revert TransferToNonERC721ReceiverImplementer();
1133                 }
1134                 updatedIndex++;
1135             }
1136 
1137             _currentIndex = updatedIndex;
1138         }
1139         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1140     }
1141 
1142     /**
1143      * @dev Transfers `tokenId` from `from` to `to`.
1144      *
1145      * Requirements:
1146      *
1147      * - `to` cannot be the zero address.
1148      * - `tokenId` token must be owned by `from`.
1149      *
1150      * Emits a {Transfer} event.
1151      */
1152     function _transfer(
1153         address from,
1154         address to,
1155         uint256 tokenId
1156     ) private {
1157         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1158 
1159         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1160             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1161             getApproved(tokenId) == _msgSender());
1162 
1163         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1164         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1165         if (to == address(0)) revert TransferToZeroAddress();
1166 
1167         _beforeTokenTransfers(from, to, tokenId, 1);
1168 
1169         // Clear approvals from the previous owner
1170         _approve(address(0), tokenId, prevOwnership.addr);
1171 
1172         // Underflow of the sender's balance is impossible because we check for
1173         // ownership above and the recipient's balance can't realistically overflow.
1174         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1175         unchecked {
1176             _addressData[from].balance -= 1;
1177             _addressData[to].balance += 1;
1178 
1179             _ownerships[tokenId].addr = to;
1180             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1181 
1182             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1183             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1184             uint256 nextTokenId = tokenId + 1;
1185             if (_ownerships[nextTokenId].addr == address(0)) {
1186                 // This will suffice for checking _exists(nextTokenId),
1187                 // as a burned slot cannot contain the zero address.
1188                 if (nextTokenId < _currentIndex) {
1189                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1190                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1191                 }
1192             }
1193         }
1194 
1195         emit Transfer(from, to, tokenId);
1196         _afterTokenTransfers(from, to, tokenId, 1);
1197     }
1198 
1199     /**
1200      * @dev Destroys `tokenId`.
1201      * The approval is cleared when the token is burned.
1202      *
1203      * Requirements:
1204      *
1205      * - `tokenId` must exist.
1206      *
1207      * Emits a {Transfer} event.
1208      */
1209     function _burn(uint256 tokenId) internal virtual {
1210         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1211 
1212         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1213 
1214         // Clear approvals from the previous owner
1215         _approve(address(0), tokenId, prevOwnership.addr);
1216 
1217         // Underflow of the sender's balance is impossible because we check for
1218         // ownership above and the recipient's balance can't realistically overflow.
1219         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1220         unchecked {
1221             _addressData[prevOwnership.addr].balance -= 1;
1222             _addressData[prevOwnership.addr].numberBurned += 1;
1223 
1224             // Keep track of who burned the token, and the timestamp of burning.
1225             _ownerships[tokenId].addr = prevOwnership.addr;
1226             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1227             _ownerships[tokenId].burned = true;
1228 
1229             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1230             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1231             uint256 nextTokenId = tokenId + 1;
1232             if (_ownerships[nextTokenId].addr == address(0)) {
1233                 // This will suffice for checking _exists(nextTokenId),
1234                 // as a burned slot cannot contain the zero address.
1235                 if (nextTokenId < _currentIndex) {
1236                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1237                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1238                 }
1239             }
1240         }
1241 
1242         emit Transfer(prevOwnership.addr, address(0), tokenId);
1243         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1244 
1245         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1246         unchecked { 
1247             _burnCounter++;
1248         }
1249     }
1250 
1251     /**
1252      * @dev Approve `to` to operate on `tokenId`
1253      *
1254      * Emits a {Approval} event.
1255      */
1256     function _approve(
1257         address to,
1258         uint256 tokenId,
1259         address owner
1260     ) private {
1261         _tokenApprovals[tokenId] = to;
1262         emit Approval(owner, to, tokenId);
1263     }
1264 
1265     /**
1266      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1267      * The call is not executed if the target address is not a contract.
1268      *
1269      * @param from address representing the previous owner of the given token ID
1270      * @param to target address that will receive the tokens
1271      * @param tokenId uint256 ID of the token to be transferred
1272      * @param _data bytes optional data to send along with the call
1273      * @return bool whether the call correctly returned the expected magic value
1274      */
1275     function _checkOnERC721Received(
1276         address from,
1277         address to,
1278         uint256 tokenId,
1279         bytes memory _data
1280     ) private returns (bool) {
1281         if (to.isContract()) {
1282             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1283                 return retval == IERC721Receiver(to).onERC721Received.selector;
1284             } catch (bytes memory reason) {
1285                 if (reason.length == 0) {
1286                     revert TransferToNonERC721ReceiverImplementer();
1287                 } else {
1288                     assembly {
1289                         revert(add(32, reason), mload(reason))
1290                     }
1291                 }
1292             }
1293         } else {
1294             return true;
1295         }
1296     }
1297 
1298     /**
1299      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1300      * And also called before burning one token.
1301      *
1302      * startTokenId - the first token id to be transferred
1303      * quantity - the amount to be transferred
1304      *
1305      * Calling conditions:
1306      *
1307      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1308      * transferred to `to`.
1309      * - When `from` is zero, `tokenId` will be minted for `to`.
1310      * - When `to` is zero, `tokenId` will be burned by `from`.
1311      * - `from` and `to` are never both zero.
1312      */
1313     function _beforeTokenTransfers(
1314         address from,
1315         address to,
1316         uint256 startTokenId,
1317         uint256 quantity
1318     ) internal virtual {}
1319 
1320     /**
1321      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1322      * minting.
1323      * And also called after one token has been burned.
1324      *
1325      * startTokenId - the first token id to be transferred
1326      * quantity - the amount to be transferred
1327      *
1328      * Calling conditions:
1329      *
1330      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1331      * transferred to `to`.
1332      * - When `from` is zero, `tokenId` has been minted for `to`.
1333      * - When `to` is zero, `tokenId` has been burned by `from`.
1334      * - `from` and `to` are never both zero.
1335      */
1336     function _afterTokenTransfers(
1337         address from,
1338         address to,
1339         uint256 startTokenId,
1340         uint256 quantity
1341     ) internal virtual {}
1342 }
1343 
1344 
1345 contract AnimeVillains is ERC721A, Ownable, ReentrancyGuard {
1346 
1347   using Strings for uint256;
1348 
1349   string baseURI;
1350   string public baseExtension = ".json";
1351   string public hiddenMetadataUri;
1352   uint256 constant public whitelistCost = 0.048 ether;
1353   uint256 constant public whitelistCost2 = 0.045 ether;
1354   uint256 constant public whitelistCost3 = 0.042  ether;
1355   uint256 constant public cost = 0.058 ether;
1356   uint256 constant public cost2 = 0.055 ether;
1357   uint256 constant public cost3 = 0.052 ether;
1358   uint256 constant public maxSupply = 5555;
1359   uint256 public maxMintAmount = 20;
1360   bool public paused = true;
1361   bool public revealed = false;
1362   bool public onlyWhitelisted = true;
1363   mapping(address => bool) private _whitelist;
1364 
1365 
1366   constructor (
1367   ) ERC721A("TTAV - Time Travelling Anime Villains", "TTAV") {
1368     setHiddenMetadataUri("ipfs://QmcwiDSApvCf7WUcQyaJMaKGCq9u5WFQZUTL2ZAzGyN2dn/hidden.json");
1369   }
1370 
1371   // internal
1372   function _baseURI() internal view virtual override returns (string memory) {
1373     return baseURI;
1374   }
1375 
1376   // public
1377   function mint(uint256 _mintAmount) external payable nonReentrant {
1378     
1379     require(_mintAmount > 0, "MINT AT LEAST 1");
1380     require(totalSupply() + _mintAmount <= maxSupply, "NOT ENOUGH LEFT");
1381 
1382 
1383     if (msg.sender != owner()) {
1384         require(!paused, "PAUSED");
1385         require(_mintAmount <= maxMintAmount, "QTY TOO HIGH");
1386 
1387         if(onlyWhitelisted == true) {
1388             require(_whitelist[msg.sender], "UNAUTHORIZED WL");
1389             require(_mintAmount + balanceOf(msg.sender) <= 3, "3 PER WALLET");
1390 
1391             if (_mintAmount == 1) {
1392                 require(msg.value >= whitelistCost * _mintAmount, "LOW FUNDS WL1");
1393             } else if (_mintAmount == 2) {
1394                 require(msg.value >= whitelistCost2 * _mintAmount, "LOW FUNDS WL2");
1395             } else if (_mintAmount >= 3) {
1396                 require(msg.value >= whitelistCost3 * _mintAmount, "LOW FUNDS WL3");
1397             }
1398         } else {
1399 
1400             if (_mintAmount == 1) {
1401                 require(msg.value >= cost * _mintAmount, "LOW FUNDS 1");
1402             } else if (_mintAmount == 2) {
1403                 require(msg.value >= cost2 * _mintAmount, "LOW FUNDS 2");
1404             } else if (_mintAmount >= 3) {
1405                 require(msg.value >= cost3 * _mintAmount, "LOW FUNDS 3");
1406             }
1407         }
1408     }
1409 
1410     _safeMint(msg.sender, _mintAmount);
1411     
1412   }
1413   
1414 
1415   function tokenURI(uint256 tokenId)
1416     public
1417     view
1418     virtual
1419     override
1420     returns (string memory)
1421   {
1422     require(
1423       _exists(tokenId),
1424       "ERC721Metadata: URI query for nonexistent token"
1425     );
1426     
1427     if(revealed == false) {
1428         return hiddenMetadataUri;
1429     }
1430 
1431     string memory currentBaseURI = _baseURI();
1432     return bytes(currentBaseURI).length > 0
1433         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1434         : "";
1435   }
1436 
1437   function walletOfOwner(address _owner)
1438     public
1439     view
1440     returns (uint256[] memory)
1441   {
1442     uint256 ownerTokenCount = balanceOf(_owner);
1443     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1444     uint256 currentTokenId = 1;
1445     uint256 ownedTokenIndex = 0;
1446 
1447     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1448       address currentTokenOwner = ownerOf(currentTokenId);
1449 
1450       if (currentTokenOwner == _owner) {
1451         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1452 
1453         ownedTokenIndex++;
1454       }
1455 
1456       currentTokenId++;
1457     }
1458 
1459     return ownedTokenIds;
1460   }
1461 
1462   //only owner
1463   function reveal() external onlyOwner {
1464       revealed = true;
1465   }
1466   
1467 
1468   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1469     maxMintAmount = _newmaxMintAmount;
1470   }
1471 
1472   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1473     baseURI = _newBaseURI;
1474   }
1475 
1476   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1477     baseExtension = _newBaseExtension;
1478   }
1479 
1480   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1481     hiddenMetadataUri = _hiddenMetadataUri;
1482   }
1483 
1484   function pause(bool _state) external onlyOwner {
1485     paused = _state;
1486   }
1487   
1488   
1489   function setOnlyWhitelisted(bool _state) external onlyOwner {
1490     onlyWhitelisted = _state;
1491   }
1492 
1493 
1494   function whiteListMany(address[] memory accounts) external onlyOwner {
1495         for (uint256 i; i < accounts.length; i++) {
1496             _whitelist[accounts[i]] = true;
1497         }
1498   }
1499 
1500   function whiteListOne(address account) external onlyOwner {
1501         _whitelist[account] = true;
1502   }
1503 
1504   function checkWhitelist(address testAddress) external view returns (bool) {
1505         if (_whitelist[testAddress] == true) { return true; }
1506         return false;
1507   }
1508  
1509   function withdraw() external payable onlyOwner {
1510     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1511     require(os);
1512   }
1513 }