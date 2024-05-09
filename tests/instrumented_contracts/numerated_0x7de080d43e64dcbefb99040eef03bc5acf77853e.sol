1 // File: contracts/base/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         // On the first call to nonReentrant, _notEntered will be true
54         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
55 
56         // Any calls to nonReentrant after this point will fail
57         _status = _ENTERED;
58 
59         _;
60 
61         // By storing the original value once again, a refund is triggered (see
62         // https://eips.ethereum.org/EIPS/eip-2200)
63         _status = _NOT_ENTERED;
64     }
65 }
66 
67 // File: contracts/base/Strings.sol
68 
69 pragma solidity ^0.8.0;
70 
71 /**
72  * @dev String operations.
73  */
74 library Strings {
75     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
76 
77     /**
78      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
79      */
80     function toString(uint256 value) internal pure returns (string memory) {
81         // Inspired by OraclizeAPI's implementation - MIT licence
82         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
83 
84         if (value == 0) {
85             return "0";
86         }
87         uint256 temp = value;
88         uint256 digits;
89         while (temp != 0) {
90             digits++;
91             temp /= 10;
92         }
93         bytes memory buffer = new bytes(digits);
94         while (value != 0) {
95             digits -= 1;
96             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
97             value /= 10;
98         }
99         return string(buffer);
100     }
101 
102     /**
103      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
104      */
105     function toHexString(uint256 value) internal pure returns (string memory) {
106         if (value == 0) {
107             return "0x00";
108         }
109         uint256 temp = value;
110         uint256 length = 0;
111         while (temp != 0) {
112             length++;
113             temp >>= 8;
114         }
115         return toHexString(value, length);
116     }
117 
118     /**
119      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
120      */
121     function toHexString(uint256 value, uint256 length)
122         internal
123         pure
124         returns (string memory)
125     {
126         bytes memory buffer = new bytes(2 * length + 2);
127         buffer[0] = "0";
128         buffer[1] = "x";
129         for (uint256 i = 2 * length + 1; i > 1; --i) {
130             buffer[i] = _HEX_SYMBOLS[value & 0xf];
131             value >>= 4;
132         }
133         require(value == 0, "Strings: hex length insufficient");
134         return string(buffer);
135     }
136 }
137 // File: contracts/base/Address.sol
138 
139 pragma solidity ^0.8.0;
140 
141 /**
142  * @dev Collection of functions related to the address type
143  */
144 library Address {
145     /**
146      * @dev Returns true if `account` is a contract.
147      *
148      * [IMPORTANT]
149      * ====
150      * It is unsafe to assume that an address for which this function returns
151      * false is an externally-owned account (EOA) and not a contract.
152      *
153      * Among others, `isContract` will return false for the following
154      * types of addresses:
155      *
156      *  - an externally-owned account
157      *  - a contract in construction
158      *  - an address where a contract will be created
159      *  - an address where a contract lived, but was destroyed
160      * ====
161      */
162     function isContract(address account) internal view returns (bool) {
163         // This method relies on extcodesize, which returns 0 for contracts in
164         // construction, since the code is only stored at the end of the
165         // constructor execution.
166 
167         uint256 size;
168         assembly {
169             size := extcodesize(account)
170         }
171         return size > 0;
172     }
173 
174     /**
175      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
176      * `recipient`, forwarding all available gas and reverting on errors.
177      *
178      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
179      * of certain opcodes, possibly making contracts go over the 2300 gas limit
180      * imposed by `transfer`, making them unable to receive funds via
181      * `transfer`. {sendValue} removes this limitation.
182      *
183      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
184      *
185      * IMPORTANT: because control is transferred to `recipient`, care must be
186      * taken to not create reentrancy vulnerabilities. Consider using
187      * {ReentrancyGuard} or the
188      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
189      */
190     function sendValue(address payable recipient, uint256 amount) internal {
191         require(
192             address(this).balance >= amount,
193             "Address: insufficient balance"
194         );
195 
196         (bool success, ) = recipient.call{value: amount}("");
197         require(
198             success,
199             "Address: unable to send value, recipient may have reverted"
200         );
201     }
202 
203     /**
204      * @dev Performs a Solidity function call using a low level `call`. A
205      * plain `call` is an unsafe replacement for a function call: use this
206      * function instead.
207      *
208      * If `target` reverts with a revert reason, it is bubbled up by this
209      * function (like regular Solidity function calls).
210      *
211      * Returns the raw returned data. To convert to the expected return value,
212      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
213      *
214      * Requirements:
215      *
216      * - `target` must be a contract.
217      * - calling `target` with `data` must not revert.
218      *
219      * _Available since v3.1._
220      */
221     function functionCall(address target, bytes memory data)
222         internal
223         returns (bytes memory)
224     {
225         return functionCall(target, data, "Address: low-level call failed");
226     }
227 
228     /**
229      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
230      * `errorMessage` as a fallback revert reason when `target` reverts.
231      *
232      * _Available since v3.1._
233      */
234     function functionCall(
235         address target,
236         bytes memory data,
237         string memory errorMessage
238     ) internal returns (bytes memory) {
239         return functionCallWithValue(target, data, 0, errorMessage);
240     }
241 
242     /**
243      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
244      * but also transferring `value` wei to `target`.
245      *
246      * Requirements:
247      *
248      * - the calling contract must have an ETH balance of at least `value`.
249      * - the called Solidity function must be `payable`.
250      *
251      * _Available since v3.1._
252      */
253     function functionCallWithValue(
254         address target,
255         bytes memory data,
256         uint256 value
257     ) internal returns (bytes memory) {
258         return
259             functionCallWithValue(
260                 target,
261                 data,
262                 value,
263                 "Address: low-level call with value failed"
264             );
265     }
266 
267     /**
268      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
269      * with `errorMessage` as a fallback revert reason when `target` reverts.
270      *
271      * _Available since v3.1._
272      */
273     function functionCallWithValue(
274         address target,
275         bytes memory data,
276         uint256 value,
277         string memory errorMessage
278     ) internal returns (bytes memory) {
279         require(
280             address(this).balance >= value,
281             "Address: insufficient balance for call"
282         );
283         require(isContract(target), "Address: call to non-contract");
284 
285         (bool success, bytes memory returndata) = target.call{value: value}(
286             data
287         );
288         return verifyCallResult(success, returndata, errorMessage);
289     }
290 
291     /**
292      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
293      * but performing a static call.
294      *
295      * _Available since v3.3._
296      */
297     function functionStaticCall(address target, bytes memory data)
298         internal
299         view
300         returns (bytes memory)
301     {
302         return
303             functionStaticCall(
304                 target,
305                 data,
306                 "Address: low-level static call failed"
307             );
308     }
309 
310     /**
311      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
312      * but performing a static call.
313      *
314      * _Available since v3.3._
315      */
316     function functionStaticCall(
317         address target,
318         bytes memory data,
319         string memory errorMessage
320     ) internal view returns (bytes memory) {
321         require(isContract(target), "Address: static call to non-contract");
322 
323         (bool success, bytes memory returndata) = target.staticcall(data);
324         return verifyCallResult(success, returndata, errorMessage);
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
329      * but performing a delegate call.
330      *
331      * _Available since v3.4._
332      */
333     function functionDelegateCall(address target, bytes memory data)
334         internal
335         returns (bytes memory)
336     {
337         return
338             functionDelegateCall(
339                 target,
340                 data,
341                 "Address: low-level delegate call failed"
342             );
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
347      * but performing a delegate call.
348      *
349      * _Available since v3.4._
350      */
351     function functionDelegateCall(
352         address target,
353         bytes memory data,
354         string memory errorMessage
355     ) internal returns (bytes memory) {
356         require(isContract(target), "Address: delegate call to non-contract");
357 
358         (bool success, bytes memory returndata) = target.delegatecall(data);
359         return verifyCallResult(success, returndata, errorMessage);
360     }
361 
362     /**
363      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
364      * revert reason using the provided one.
365      *
366      * _Available since v4.3._
367      */
368     function verifyCallResult(
369         bool success,
370         bytes memory returndata,
371         string memory errorMessage
372     ) internal pure returns (bytes memory) {
373         if (success) {
374             return returndata;
375         } else {
376             // Look for revert reason and bubble it up if present
377             if (returndata.length > 0) {
378                 // The easiest way to bubble the revert reason is using memory via assembly
379 
380                 assembly {
381                     let returndata_size := mload(returndata)
382                     revert(add(32, returndata), returndata_size)
383                 }
384             } else {
385                 revert(errorMessage);
386             }
387         }
388     }
389 }
390 // File: contracts/base/IERC721Receiver.sol
391 
392 
393 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
394 
395 pragma solidity ^0.8.0;
396 
397 /**
398  * @title ERC721 token receiver interface
399  * @dev Interface for any contract that wants to support safeTransfers
400  * from ERC721 asset contracts.
401  */
402 interface IERC721Receiver {
403     /**
404      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
405      * by `operator` from `from`, this function is called.
406      *
407      * It must return its Solidity selector to confirm the token transfer.
408      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
409      *
410      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
411      */
412     function onERC721Received(
413         address operator,
414         address from,
415         uint256 tokenId,
416         bytes calldata data
417     ) external returns (bytes4);
418 }
419 // File: contracts/base/IERC165.sol
420 
421 pragma solidity ^0.8.0;
422 
423 /**
424  * @dev Interface of the ERC165 standard, as defined in the
425  * https://eips.ethereum.org/EIPS/eip-165[EIP].
426  *
427  * Implementers can declare support of contract interfaces, which can then be
428  * queried by others ({ERC165Checker}).
429  *
430  * For an implementation, see {ERC165}.
431  */
432 interface IERC165 {
433     /**
434      * @dev Returns true if this contract implements the interface defined by
435      * `interfaceId`. See the corresponding
436      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
437      * to learn more about how these ids are created.
438      *
439      * This function call must use less than 30 000 gas.
440      */
441     function supportsInterface(bytes4 interfaceId) external view returns (bool);
442 }
443 // File: contracts/base/ERC165.sol
444 
445 pragma solidity ^0.8.0;
446 
447 
448 /**
449  * @dev Implementation of the {IERC165} interface.
450  *
451  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
452  * for the additional interface id that will be supported. For example:
453  *
454  * ```solidity
455  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
456  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
457  * }
458  * ```
459  *
460  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
461  */
462 abstract contract ERC165 is IERC165 {
463     /**
464      * @dev See {IERC165-supportsInterface}.
465      */
466     function supportsInterface(bytes4 interfaceId)
467         public
468         view
469         virtual
470         override
471         returns (bool)
472     {
473         return interfaceId == type(IERC165).interfaceId;
474     }
475 }
476 // File: contracts/base/IERC721.sol
477 
478 pragma solidity ^0.8.0;
479 
480 
481 /**
482  * @dev Required interface of an ERC721 compliant contract.
483  */
484 interface IERC721 is IERC165 {
485     /**
486      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
487      */
488     event Transfer(
489         address indexed from,
490         address indexed to,
491         uint256 indexed tokenId
492     );
493 
494     /**
495      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
496      */
497     event Approval(
498         address indexed owner,
499         address indexed approved,
500         uint256 indexed tokenId
501     );
502 
503     /**
504      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
505      */
506     event ApprovalForAll(
507         address indexed owner,
508         address indexed operator,
509         bool approved
510     );
511 
512     /**
513      * @dev Returns the number of tokens in ``owner``'s account.
514      */
515     function balanceOf(address owner) external view returns (uint256 balance);
516 
517     /**
518      * @dev Returns the owner of the `tokenId` token.
519      *
520      * Requirements:
521      *
522      * - `tokenId` must exist.
523      */
524     function ownerOf(uint256 tokenId) external view returns (address owner);
525 
526     /**
527      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
528      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
529      *
530      * Requirements:
531      *
532      * - `from` cannot be the zero address.
533      * - `to` cannot be the zero address.
534      * - `tokenId` token must exist and be owned by `from`.
535      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
536      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
537      *
538      * Emits a {Transfer} event.
539      */
540     function safeTransferFrom(
541         address from,
542         address to,
543         uint256 tokenId
544     ) external;
545 
546     /**
547      * @dev Transfers `tokenId` token from `from` to `to`.
548      *
549      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
550      *
551      * Requirements:
552      *
553      * - `from` cannot be the zero address.
554      * - `to` cannot be the zero address.
555      * - `tokenId` token must be owned by `from`.
556      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
557      *
558      * Emits a {Transfer} event.
559      */
560     function transferFrom(
561         address from,
562         address to,
563         uint256 tokenId
564     ) external;
565 
566     /**
567      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
568      * The approval is cleared when the token is transferred.
569      *
570      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
571      *
572      * Requirements:
573      *
574      * - The caller must own the token or be an approved operator.
575      * - `tokenId` must exist.
576      *
577      * Emits an {Approval} event.
578      */
579     function approve(address to, uint256 tokenId) external;
580 
581     /**
582      * @dev Returns the account approved for `tokenId` token.
583      *
584      * Requirements:
585      *
586      * - `tokenId` must exist.
587      */
588     function getApproved(uint256 tokenId)
589         external
590         view
591         returns (address operator);
592 
593     /**
594      * @dev Approve or remove `operator` as an operator for the caller.
595      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
596      *
597      * Requirements:
598      *
599      * - The `operator` cannot be the caller.
600      *
601      * Emits an {ApprovalForAll} event.
602      */
603     function setApprovalForAll(address operator, bool _approved) external;
604 
605     /**
606      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
607      *
608      * See {setApprovalForAll}
609      */
610     function isApprovedForAll(address owner, address operator)
611         external
612         view
613         returns (bool);
614 
615     /**
616      * @dev Safely transfers `tokenId` token from `from` to `to`.
617      *
618      * Requirements:
619      *
620      * - `from` cannot be the zero address.
621      * - `to` cannot be the zero address.
622      * - `tokenId` token must exist and be owned by `from`.
623      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
624      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
625      *
626      * Emits a {Transfer} event.
627      */
628     function safeTransferFrom(
629         address from,
630         address to,
631         uint256 tokenId,
632         bytes calldata data
633     ) external;
634 }
635 // File: contracts/base/IERC721Enumerable.sol
636 
637 pragma solidity ^0.8.0;
638 
639 
640 /**
641  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
642  * @dev See https://eips.ethereum.org/EIPS/eip-721
643  */
644 interface IERC721Enumerable is IERC721 {
645     /**
646      * @dev Returns the total amount of tokens stored by the contract.
647      */
648     function totalSupply() external view returns (uint256);
649 
650     /**
651      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
652      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
653      */
654     function tokenOfOwnerByIndex(address owner, uint256 index)
655         external
656         view
657         returns (uint256 tokenId);
658 
659     /**
660      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
661      * Use along with {totalSupply} to enumerate all tokens.
662      */
663     function tokenByIndex(uint256 index) external view returns (uint256);
664 }
665 // File: contracts/base/IERC721Metadata.sol
666 
667 pragma solidity ^0.8.0;
668 
669 
670 /**
671  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
672  * @dev See https://eips.ethereum.org/EIPS/eip-721
673  */
674 interface IERC721Metadata is IERC721 {
675     /**
676      * @dev Returns the token collection name.
677      */
678     function name() external view returns (string memory);
679 
680     /**
681      * @dev Returns the token collection symbol.
682      */
683     function symbol() external view returns (string memory);
684 
685     /**
686      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
687      */
688     function tokenURI(uint256 tokenId) external view returns (string memory);
689 }
690 // File: contracts/base/IERC20.sol
691 
692 pragma solidity ^0.8.0;
693 
694 /**
695  * @dev Interface of the ERC20 standard as defined in the EIP.
696  */
697 interface IERC20 {
698     /**
699      * @dev Returns the amount of tokens in existence.
700      */
701     function totalSupply() external view returns (uint256);
702 
703     /**
704      * @dev Returns the amount of tokens owned by `account`.
705      */
706     function balanceOf(address account) external view returns (uint256);
707 
708     /**
709      * @dev Moves `amount` tokens from the caller's account to `recipient`.
710      *
711      * Returns a boolean value indicating whether the operation succeeded.
712      *
713      * Emits a {Transfer} event.
714      */
715     function transfer(address recipient, uint256 amount) external returns (bool);
716 
717     /**
718      * @dev Returns the remaining number of tokens that `spender` will be
719      * allowed to spend on behalf of `owner` through {transferFrom}. This is
720      * zero by default.
721      *
722      * This value changes when {approve} or {transferFrom} are called.
723      */
724     function allowance(address owner, address spender) external view returns (uint256);
725 
726     /**
727      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
728      *
729      * Returns a boolean value indicating whether the operation succeeded.
730      *
731      * IMPORTANT: Beware that changing an allowance with this method brings the risk
732      * that someone may use both the old and the new allowance by unfortunate
733      * transaction ordering. One possible solution to mitigate this race
734      * condition is to first reduce the spender's allowance to 0 and set the
735      * desired value afterwards:
736      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
737      *
738      * Emits an {Approval} event.
739      */
740     function approve(address spender, uint256 amount) external returns (bool);
741 
742     /**
743      * @dev Moves `amount` tokens from `sender` to `recipient` using the
744      * allowance mechanism. `amount` is then deducted from the caller's
745      * allowance.
746      *
747      * Returns a boolean value indicating whether the operation succeeded.
748      *
749      * Emits a {Transfer} event.
750      */
751     function transferFrom(
752         address sender,
753         address recipient,
754         uint256 amount
755     ) external returns (bool);
756 
757     /**
758      * @dev Emitted when `value` tokens are moved from one account (`from`) to
759      * another (`to`).
760      *
761      * Note that `value` may be zero.
762      */
763     event Transfer(address indexed from, address indexed to, uint256 value);
764 
765     /**
766      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
767      * a call to {approve}. `value` is the new allowance.
768      */
769     event Approval(address indexed owner, address indexed spender, uint256 value);
770 }
771 // File: contracts/base/IERC20Metadata.sol
772 
773 pragma solidity ^0.8.0;
774 
775 
776 
777 interface IERC20Metadata is IERC20 {
778     /**
779      * @dev Returns the name of the token.
780      */
781     function name() external view returns (string memory);
782 
783     /**
784      * @dev Returns the symbol of the token.
785      */
786     function symbol() external view returns (string memory);
787 
788     /**
789      * @dev Returns the decimals places of the token.
790      */
791     function decimals() external view returns (uint8);
792 }
793 // File: contracts/base/Context.sol
794 
795 pragma solidity ^0.8.0;
796 
797 /**
798  * @dev Provides information about the current execution context, including the
799  * sender of the transaction and its data. While these are generally available
800  * via msg.sender and msg.data, they should not be accessed in such a direct
801  * manner, since when dealing with meta-transactions the account sending and
802  * paying for execution may not be the actual sender (as far as an application
803  * is concerned).
804  *
805  * This contract is only required for intermediate, library-like contracts.
806  */
807 abstract contract Context {
808     function _msgSender() internal view virtual returns (address) {
809         return msg.sender;
810     }
811 
812     function _msgData() internal view virtual returns (bytes calldata) {
813         return msg.data;
814     }
815 }
816 // File: contracts/base/ERC721A.sol
817 
818 
819 // Creators: locationtba.eth, 2pmflow.eth
820 
821 pragma solidity ^0.8.0;
822 
823 
824 
825 
826 
827 
828 
829 
830 
831 /**
832  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
833  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
834  *
835  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
836  *
837  * Does not support burning tokens to address(0).
838  */
839 contract ERC721A is
840 Context,
841 ERC165,
842 IERC721,
843 IERC721Metadata,
844 IERC721Enumerable
845 {
846     using Address for address;
847     using Strings for uint256;
848 
849     struct TokenOwnership {
850         address addr;
851         uint64 startTimestamp;
852     }
853 
854     struct AddressData {
855         uint128 balance;
856         uint128 numberMinted;
857     }
858 
859     uint256 private currentIndex = 0;
860 
861     uint256 internal immutable maxBatchSize;
862 
863     // Token name
864     string private _name;
865 
866     // Token symbol
867     string private _symbol;
868 
869     // Mapping from token ID to ownership details
870     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
871     mapping(uint256 => TokenOwnership) private _ownerships;
872 
873     // Mapping owner address to address data
874     mapping(address => AddressData) private _addressData;
875 
876     // Mapping from token ID to approved address
877     mapping(uint256 => address) private _tokenApprovals;
878 
879     // Mapping from owner to operator approvals
880     mapping(address => mapping(address => bool)) private _operatorApprovals;
881 
882     /**
883      * @dev
884    * `maxBatchSize` refers to how much a minter can mint at a time.
885    */
886     constructor(
887         string memory name_,
888         string memory symbol_,
889         uint256 maxBatchSize_
890     ) {
891         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
892         _name = name_;
893         _symbol = symbol_;
894         maxBatchSize = maxBatchSize_;
895     }
896 
897     /**
898      * @dev See {IERC721Enumerable-totalSupply}.
899    */
900     function totalSupply() public view override returns (uint256) {
901         return currentIndex;
902     }
903 
904     /**
905      * @dev See {IERC721Enumerable-tokenByIndex}.
906    */
907     function tokenByIndex(uint256 index) public view override returns (uint256) {
908         require(index < totalSupply(), "ERC721A: global index out of bounds");
909         return index;
910     }
911 
912     /**
913      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
914    * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
915    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
916    */
917     function tokenOfOwnerByIndex(address owner, uint256 index)
918     public
919     view
920     override
921     returns (uint256)
922     {
923         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
924         uint256 numMintedSoFar = totalSupply();
925         uint256 tokenIdsIdx = 0;
926         address currOwnershipAddr = address(0);
927         for (uint256 i = 0; i < numMintedSoFar; i++) {
928             TokenOwnership memory ownership = _ownerships[i];
929             if (ownership.addr != address(0)) {
930                 currOwnershipAddr = ownership.addr;
931             }
932             if (currOwnershipAddr == owner) {
933                 if (tokenIdsIdx == index) {
934                     return i;
935                 }
936                 tokenIdsIdx++;
937             }
938         }
939         revert("ERC721A: unable to get token of owner by index");
940     }
941 
942     /**
943      * @dev See {IERC165-supportsInterface}.
944    */
945     function supportsInterface(bytes4 interfaceId)
946     public
947     view
948     virtual
949     override(ERC165, IERC165)
950     returns (bool)
951     {
952         return
953         interfaceId == type(IERC721).interfaceId ||
954         interfaceId == type(IERC721Metadata).interfaceId ||
955         interfaceId == type(IERC721Enumerable).interfaceId ||
956         super.supportsInterface(interfaceId);
957     }
958 
959     /**
960      * @dev See {IERC721-balanceOf}.
961    */
962     function balanceOf(address owner) public view override returns (uint256) {
963         require(owner != address(0), "ERC721A: balance query for the zero address");
964         return uint256(_addressData[owner].balance);
965     }
966 
967     function _numberMinted(address owner) internal view returns (uint256) {
968         require(
969             owner != address(0),
970             "ERC721A: number minted query for the zero address"
971         );
972         return uint256(_addressData[owner].numberMinted);
973     }
974 
975     function ownershipOf(uint256 tokenId)
976     internal
977     view
978     returns (TokenOwnership memory)
979     {
980         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
981 
982         uint256 lowestTokenToCheck;
983         if (tokenId >= maxBatchSize) {
984             lowestTokenToCheck = tokenId - maxBatchSize + 1;
985         }
986 
987         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
988             TokenOwnership memory ownership = _ownerships[curr];
989             if (ownership.addr != address(0)) {
990                 return ownership;
991             }
992         }
993 
994         revert("ERC721A: unable to determine the owner of token");
995     }
996 
997     /**
998      * @dev See {IERC721-ownerOf}.
999    */
1000     function ownerOf(uint256 tokenId) public view override returns (address) {
1001         return ownershipOf(tokenId).addr;
1002     }
1003 
1004     /**
1005      * @dev See {IERC721Metadata-name}.
1006    */
1007     function name() public view virtual override returns (string memory) {
1008         return _name;
1009     }
1010 
1011     /**
1012      * @dev See {IERC721Metadata-symbol}.
1013    */
1014     function symbol() public view virtual override returns (string memory) {
1015         return _symbol;
1016     }
1017 
1018     /**
1019      * @dev See {IERC721Metadata-tokenURI}.
1020    */
1021     function tokenURI(uint256 tokenId)
1022     public
1023     view
1024     virtual
1025     override
1026     returns (string memory)
1027     {
1028         require(
1029             _exists(tokenId),
1030             "ERC721Metadata: URI query for nonexistent token"
1031         );
1032 
1033         string memory baseURI = _baseURI();
1034         return
1035         bytes(baseURI).length > 0
1036         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1037         : "";
1038     }
1039 
1040     /**
1041      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1042    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1043    * by default, can be overriden in child contracts.
1044    */
1045     function _baseURI() internal view virtual returns (string memory) {
1046         return "";
1047     }
1048 
1049     /**
1050      * @dev See {IERC721-approve}.
1051    */
1052     function approve(address to, uint256 tokenId) public override {
1053         address owner = ERC721A.ownerOf(tokenId);
1054         require(to != owner, "ERC721A: approval to current owner");
1055 
1056         require(
1057             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1058             "ERC721A: approve caller is not owner nor approved for all"
1059         );
1060 
1061         _approve(to, tokenId, owner);
1062     }
1063 
1064     /**
1065      * @dev See {IERC721-getApproved}.
1066    */
1067     function getApproved(uint256 tokenId) public view override returns (address) {
1068         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1069 
1070         return _tokenApprovals[tokenId];
1071     }
1072 
1073     /**
1074      * @dev See {IERC721-setApprovalForAll}.
1075    */
1076     function setApprovalForAll(address operator, bool approved) public override {
1077         require(operator != _msgSender(), "ERC721A: approve to caller");
1078 
1079         _operatorApprovals[_msgSender()][operator] = approved;
1080         emit ApprovalForAll(_msgSender(), operator, approved);
1081     }
1082 
1083     /**
1084      * @dev See {IERC721-isApprovedForAll}.
1085    */
1086     function isApprovedForAll(address owner, address operator)
1087     public
1088     view
1089     virtual
1090     override
1091     returns (bool)
1092     {
1093         return _operatorApprovals[owner][operator];
1094     }
1095 
1096     /**
1097      * @dev See {IERC721-transferFrom}.
1098    */
1099     function transferFrom(
1100         address from,
1101         address to,
1102         uint256 tokenId
1103     ) public override {
1104         _transfer(from, to, tokenId);
1105     }
1106 
1107     /**
1108      * @dev See {IERC721-safeTransferFrom}.
1109    */
1110     function safeTransferFrom(
1111         address from,
1112         address to,
1113         uint256 tokenId
1114     ) public override {
1115         safeTransferFrom(from, to, tokenId, "");
1116     }
1117 
1118     /**
1119      * @dev See {IERC721-safeTransferFrom}.
1120    */
1121     function safeTransferFrom(
1122         address from,
1123         address to,
1124         uint256 tokenId,
1125         bytes memory _data
1126     ) public override {
1127         _transfer(from, to, tokenId);
1128         require(
1129             _checkOnERC721Received(from, to, tokenId, _data),
1130             "ERC721A: transfer to non ERC721Receiver implementer"
1131         );
1132     }
1133 
1134     /**
1135      * @dev Returns whether `tokenId` exists.
1136    *
1137    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1138    *
1139    * Tokens start existing when they are minted (`_mint`),
1140    */
1141     function _exists(uint256 tokenId) internal view returns (bool) {
1142         return tokenId < currentIndex;
1143     }
1144 
1145     function _safeMint(address to, uint256 quantity) internal {
1146         _safeMint(to, quantity, "");
1147     }
1148 
1149     /**
1150      * @dev Mints `quantity` tokens and transfers them to `to`.
1151    *
1152    * Requirements:
1153    *
1154    * - `to` cannot be the zero address.
1155    * - `quantity` cannot be larger than the max batch size.
1156    *
1157    * Emits a {Transfer} event.
1158    */
1159     function _safeMint(
1160         address to,
1161         uint256 quantity,
1162         bytes memory _data
1163     ) internal {
1164         uint256 startTokenId = currentIndex;
1165         require(to != address(0), "ERC721A: mint to the zero address");
1166         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1167         require(!_exists(startTokenId), "ERC721A: token already minted");
1168         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1169 
1170         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1171 
1172         AddressData memory addressData = _addressData[to];
1173         _addressData[to] = AddressData(
1174             addressData.balance + uint128(quantity),
1175             addressData.numberMinted + uint128(quantity)
1176         );
1177         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1178 
1179         uint256 updatedIndex = startTokenId;
1180 
1181         for (uint256 i = 0; i < quantity; i++) {
1182             emit Transfer(address(0), to, updatedIndex);
1183             require(
1184                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1185                 "ERC721A: transfer to non ERC721Receiver implementer"
1186             );
1187             updatedIndex++;
1188         }
1189 
1190         currentIndex = updatedIndex;
1191         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1192     }
1193 
1194     /**
1195      * @dev Transfers `tokenId` from `from` to `to`.
1196    *
1197    * Requirements:
1198    *
1199    * - `to` cannot be the zero address.
1200    * - `tokenId` token must be owned by `from`.
1201    *
1202    * Emits a {Transfer} event.
1203    */
1204     function _transfer(
1205         address from,
1206         address to,
1207         uint256 tokenId
1208     ) private {
1209         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1210 
1211         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1212         getApproved(tokenId) == _msgSender() ||
1213         isApprovedForAll(prevOwnership.addr, _msgSender()));
1214 
1215         require(
1216             isApprovedOrOwner,
1217             "ERC721A: transfer caller is not owner nor approved"
1218         );
1219 
1220         require(
1221             prevOwnership.addr == from,
1222             "ERC721A: transfer from incorrect owner"
1223         );
1224         require(to != address(0), "ERC721A: transfer to the zero address");
1225 
1226         _beforeTokenTransfers(from, to, tokenId, 1);
1227 
1228         // Clear approvals from the previous owner
1229         _approve(address(0), tokenId, prevOwnership.addr);
1230 
1231         _addressData[from].balance -= 1;
1232         _addressData[to].balance += 1;
1233         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1234 
1235         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1236         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1237         uint256 nextTokenId = tokenId + 1;
1238         if (_ownerships[nextTokenId].addr == address(0)) {
1239             if (_exists(nextTokenId)) {
1240                 _ownerships[nextTokenId] = TokenOwnership(
1241                     prevOwnership.addr,
1242                     prevOwnership.startTimestamp
1243                 );
1244             }
1245         }
1246 
1247         emit Transfer(from, to, tokenId);
1248         _afterTokenTransfers(from, to, tokenId, 1);
1249     }
1250 
1251     /**
1252      * @dev Approve `to` to operate on `tokenId`
1253    *
1254    * Emits a {Approval} event.
1255    */
1256     function _approve(
1257         address to,
1258         uint256 tokenId,
1259         address owner
1260     ) private {
1261         _tokenApprovals[tokenId] = to;
1262         emit Approval(owner, to, tokenId);
1263     }
1264 
1265     uint256 public nextOwnerToExplicitlySet = 0;
1266 
1267     /**
1268      * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1269    */
1270     function _setOwnersExplicit(uint256 quantity) internal {
1271         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1272         require(quantity > 0, "quantity must be nonzero");
1273         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1274         if (endIndex > currentIndex - 1) {
1275             endIndex = currentIndex - 1;
1276         }
1277         // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1278         require(_exists(endIndex), "not enough minted yet for this cleanup");
1279         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1280             if (_ownerships[i].addr == address(0)) {
1281                 TokenOwnership memory ownership = ownershipOf(i);
1282                 _ownerships[i] = TokenOwnership(
1283                     ownership.addr,
1284                     ownership.startTimestamp
1285                 );
1286             }
1287         }
1288         nextOwnerToExplicitlySet = endIndex + 1;
1289     }
1290 
1291     /**
1292      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1293    * The call is not executed if the target address is not a contract.
1294    *
1295    * @param from address representing the previous owner of the given token ID
1296    * @param to target address that will receive the tokens
1297    * @param tokenId uint256 ID of the token to be transferred
1298    * @param _data bytes optional data to send along with the call
1299    * @return bool whether the call correctly returned the expected magic value
1300    */
1301     function _checkOnERC721Received(
1302         address from,
1303         address to,
1304         uint256 tokenId,
1305         bytes memory _data
1306     ) private returns (bool) {
1307         if (to.isContract()) {
1308             try
1309             IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1310             returns (bytes4 retval) {
1311                 return retval == IERC721Receiver(to).onERC721Received.selector;
1312             } catch (bytes memory reason) {
1313                 if (reason.length == 0) {
1314                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1315                 } else {
1316                     assembly {
1317                         revert(add(32, reason), mload(reason))
1318                     }
1319                 }
1320             }
1321         } else {
1322             return true;
1323         }
1324     }
1325 
1326     /**
1327      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1328    *
1329    * startTokenId - the first token id to be transferred
1330    * quantity - the amount to be transferred
1331    *
1332    * Calling conditions:
1333    *
1334    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1335    * transferred to `to`.
1336    * - When `from` is zero, `tokenId` will be minted for `to`.
1337    */
1338     function _beforeTokenTransfers(
1339         address from,
1340         address to,
1341         uint256 startTokenId,
1342         uint256 quantity
1343     ) internal virtual {}
1344 
1345     /**
1346      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1347    * minting.
1348    *
1349    * startTokenId - the first token id to be transferred
1350    * quantity - the amount to be transferred
1351    *
1352    * Calling conditions:
1353    *
1354    * - when `from` and `to` are both non-zero.
1355    * - `from` and `to` are never both zero.
1356    */
1357     function _afterTokenTransfers(
1358         address from,
1359         address to,
1360         uint256 startTokenId,
1361         uint256 quantity
1362     ) internal virtual {}
1363 }
1364 // File: contracts/base/Ownable.sol
1365 
1366 pragma solidity ^0.8.0;
1367 
1368 
1369 /**
1370  * @dev Contract module which provides a basic access control mechanism, where
1371  * there is an account (an owner) that can be granted exclusive access to
1372  * specific functions.
1373  *
1374  * By default, the owner account will be the one that deploys the contract. This
1375  * can later be changed with {transferOwnership}.
1376  *
1377  * This module is used through inheritance. It will make available the modifier
1378  * `onlyOwner`, which can be applied to your functions to restrict their use to
1379  * the owner.
1380  */
1381 abstract contract Ownable is Context {
1382     address private _owner;
1383 
1384     event OwnershipTransferred(
1385         address indexed previousOwner,
1386         address indexed newOwner
1387     );
1388 
1389     /**
1390      * @dev Initializes the contract setting the deployer as the initial owner.
1391      */
1392     constructor() {
1393         _setOwner(_msgSender());
1394     }
1395 
1396     /**
1397      * @dev Returns the address of the current owner.
1398      */
1399     function owner() public view virtual returns (address) {
1400         return _owner;
1401     }
1402 
1403     /**
1404      * @dev Throws if called by any account other than the owner.
1405      */
1406     modifier onlyOwner() {
1407         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1408         _;
1409     }
1410 
1411     /**
1412      * @dev Leaves the contract without owner. It will not be possible to call
1413      * `onlyOwner` functions anymore. Can only be called by the current owner.
1414      *
1415      * NOTE: Renouncing ownership will leave the contract without an owner,
1416      * thereby removing any functionality that is only available to the owner.
1417      */
1418     function renounceOwnership() public virtual onlyOwner {
1419         _setOwner(address(0));
1420     }
1421 
1422     /**
1423      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1424      * Can only be called by the current owner.
1425      */
1426     function transferOwnership(address newOwner) public virtual onlyOwner {
1427         require(
1428             newOwner != address(0),
1429             "Ownable: new owner is the zero address"
1430         );
1431         _setOwner(newOwner);
1432     }
1433 
1434     function _setOwner(address newOwner) private {
1435         address oldOwner = _owner;
1436         _owner = newOwner;
1437         emit OwnershipTransferred(oldOwner, newOwner);
1438     }
1439 }
1440 // File: contracts/base/ERC20.sol
1441 
1442 pragma solidity ^0.8.0;
1443 
1444 
1445 
1446 
1447 
1448 contract ERC20 is Context, IERC20, IERC20Metadata {
1449     mapping(address => uint256) private _balances;
1450 
1451     mapping(address => mapping(address => uint256)) private _allowances;
1452 
1453     uint256 private _totalSupply;
1454 
1455     string private _name;
1456     string private _symbol;
1457 
1458     /**
1459      * @dev Sets the values for {name} and {symbol}.
1460      *
1461      * The default value of {decimals} is 18. To select a different value for
1462      * {decimals} you should overload it.
1463      *
1464      * All two of these values are immutable: they can only be set once during
1465      * construction.
1466      */
1467     constructor(string memory name_, string memory symbol_) {
1468         _name = name_;
1469         _symbol = symbol_;
1470     }
1471 
1472     /**
1473      * @dev Returns the name of the token.
1474      */
1475     function name() public view virtual override returns (string memory) {
1476         return _name;
1477     }
1478 
1479     /**
1480      * @dev Returns the symbol of the token, usually a shorter version of the
1481      * name.
1482      */
1483     function symbol() public view virtual override returns (string memory) {
1484         return _symbol;
1485     }
1486 
1487     /**
1488      * @dev Returns the number of decimals used to get its user representation.
1489      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1490      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1491      *
1492      * Tokens usually opt for a value of 18, imitating the relationship between
1493      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1494      * overridden;
1495      *
1496      * NOTE: This information is only used for _display_ purposes: it in
1497      * no way affects any of the arithmetic of the contract, including
1498      * {IERC20-balanceOf} and {IERC20-transfer}.
1499      */
1500     function decimals() public view virtual override returns (uint8) {
1501         return 18;
1502     }
1503 
1504     /**
1505      * @dev See {IERC20-totalSupply}.
1506      */
1507     function totalSupply() public view virtual override returns (uint256) {
1508         return _totalSupply;
1509     }
1510 
1511     /**
1512      * @dev See {IERC20-balanceOf}.
1513      */
1514     function balanceOf(address account) public view virtual override returns (uint256) {
1515         return _balances[account];
1516     }
1517 
1518     /**
1519      * @dev See {IERC20-transfer}.
1520      *
1521      * Requirements:
1522      *
1523      * - `recipient` cannot be the zero address.
1524      * - the caller must have a balance of at least `amount`.
1525      */
1526     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1527         _transfer(_msgSender(), recipient, amount);
1528         return true;
1529     }
1530 
1531     /**
1532      * @dev See {IERC20-allowance}.
1533      */
1534     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1535         return _allowances[owner][spender];
1536     }
1537 
1538     /**
1539      * @dev See {IERC20-approve}.
1540      *
1541      * Requirements:
1542      *
1543      * - `spender` cannot be the zero address.
1544      */
1545     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1546         _approve(_msgSender(), spender, amount);
1547         return true;
1548     }
1549 
1550     /**
1551      * @dev See {IERC20-transferFrom}.
1552      *
1553      * Emits an {Approval} event indicating the updated allowance. This is not
1554      * required by the EIP. See the note at the beginning of {ERC20}.
1555      *
1556      * Requirements:
1557      *
1558      * - `sender` and `recipient` cannot be the zero address.
1559      * - `sender` must have a balance of at least `amount`.
1560      * - the caller must have allowance for ``sender``'s tokens of at least
1561      * `amount`.
1562      */
1563     function transferFrom(
1564         address sender,
1565         address recipient,
1566         uint256 amount
1567     ) public virtual override returns (bool) {
1568         _transfer(sender, recipient, amount);
1569 
1570         uint256 currentAllowance = _allowances[sender][_msgSender()];
1571         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
1572         unchecked {
1573             _approve(sender, _msgSender(), currentAllowance - amount);
1574         }
1575 
1576         return true;
1577     }
1578 
1579     /**
1580      * @dev Atomically increases the allowance granted to `spender` by the caller.
1581      *
1582      * This is an alternative to {approve} that can be used as a mitigation for
1583      * problems described in {IERC20-approve}.
1584      *
1585      * Emits an {Approval} event indicating the updated allowance.
1586      *
1587      * Requirements:
1588      *
1589      * - `spender` cannot be the zero address.
1590      */
1591     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1592         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
1593         return true;
1594     }
1595 
1596     /**
1597      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1598      *
1599      * This is an alternative to {approve} that can be used as a mitigation for
1600      * problems described in {IERC20-approve}.
1601      *
1602      * Emits an {Approval} event indicating the updated allowance.
1603      *
1604      * Requirements:
1605      *
1606      * - `spender` cannot be the zero address.
1607      * - `spender` must have allowance for the caller of at least
1608      * `subtractedValue`.
1609      */
1610     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1611         uint256 currentAllowance = _allowances[_msgSender()][spender];
1612         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1613         unchecked {
1614             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
1615         }
1616 
1617         return true;
1618     }
1619 
1620     /**
1621      * @dev Moves `amount` of tokens from `sender` to `recipient`.
1622      *
1623      * This internal function is equivalent to {transfer}, and can be used to
1624      * e.g. implement automatic token fees, slashing mechanisms, etc.
1625      *
1626      * Emits a {Transfer} event.
1627      *
1628      * Requirements:
1629      *
1630      * - `sender` cannot be the zero address.
1631      * - `recipient` cannot be the zero address.
1632      * - `sender` must have a balance of at least `amount`.
1633      */
1634     function _transfer(
1635         address sender,
1636         address recipient,
1637         uint256 amount
1638     ) internal virtual {
1639         require(sender != address(0), "ERC20: transfer from the zero address");
1640         require(recipient != address(0), "ERC20: transfer to the zero address");
1641 
1642         _beforeTokenTransfer(sender, recipient, amount);
1643 
1644         uint256 senderBalance = _balances[sender];
1645         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
1646         unchecked {
1647             _balances[sender] = senderBalance - amount;
1648         }
1649         _balances[recipient] += amount;
1650 
1651         emit Transfer(sender, recipient, amount);
1652 
1653         _afterTokenTransfer(sender, recipient, amount);
1654     }
1655 
1656     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1657      * the total supply.
1658      *
1659      * Emits a {Transfer} event with `from` set to the zero address.
1660      *
1661      * Requirements:
1662      *
1663      * - `account` cannot be the zero address.
1664      */
1665     function _mint(address account, uint256 amount) internal virtual {
1666         require(account != address(0), "ERC20: mint to the zero address");
1667 
1668         _beforeTokenTransfer(address(0), account, amount);
1669 
1670         _totalSupply += amount;
1671         _balances[account] += amount;
1672         emit Transfer(address(0), account, amount);
1673 
1674         _afterTokenTransfer(address(0), account, amount);
1675     }
1676 
1677     /**
1678      * @dev Destroys `amount` tokens from `account`, reducing the
1679      * total supply.
1680      *
1681      * Emits a {Transfer} event with `to` set to the zero address.
1682      *
1683      * Requirements:
1684      *
1685      * - `account` cannot be the zero address.
1686      * - `account` must have at least `amount` tokens.
1687      */
1688     function _burn(address account, uint256 amount) internal virtual {
1689         require(account != address(0), "ERC20: burn from the zero address");
1690 
1691         _beforeTokenTransfer(account, address(0), amount);
1692 
1693         uint256 accountBalance = _balances[account];
1694         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1695         unchecked {
1696             _balances[account] = accountBalance - amount;
1697         }
1698         _totalSupply -= amount;
1699 
1700         emit Transfer(account, address(0), amount);
1701 
1702         _afterTokenTransfer(account, address(0), amount);
1703     }
1704 
1705     /**
1706      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1707      *
1708      * This internal function is equivalent to `approve`, and can be used to
1709      * e.g. set automatic allowances for certain subsystems, etc.
1710      *
1711      * Emits an {Approval} event.
1712      *
1713      * Requirements:
1714      *
1715      * - `owner` cannot be the zero address.
1716      * - `spender` cannot be the zero address.
1717      */
1718     function _approve(
1719         address owner,
1720         address spender,
1721         uint256 amount
1722     ) internal virtual {
1723         require(owner != address(0), "ERC20: approve from the zero address");
1724         require(spender != address(0), "ERC20: approve to the zero address");
1725 
1726         _allowances[owner][spender] = amount;
1727         emit Approval(owner, spender, amount);
1728     }
1729 
1730     /**
1731      * @dev Hook that is called before any transfer of tokens. This includes
1732      * minting and burning.
1733      *
1734      * Calling conditions:
1735      *
1736      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1737      * will be transferred to `to`.
1738      * - when `from` is zero, `amount` tokens will be minted for `to`.
1739      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1740      * - `from` and `to` are never both zero.
1741      *
1742      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1743      */
1744     function _beforeTokenTransfer(
1745         address from,
1746         address to,
1747         uint256 amount
1748     ) internal virtual {}
1749 
1750     /**
1751      * @dev Hook that is called after any transfer of tokens. This includes
1752      * minting and burning.
1753      *
1754      * Calling conditions:
1755      *
1756      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1757      * has been transferred to `to`.
1758      * - when `from` is zero, `amount` tokens have been minted for `to`.
1759      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1760      * - `from` and `to` are never both zero.
1761      *
1762      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1763      */
1764     function _afterTokenTransfer(
1765         address from,
1766         address to,
1767         uint256 amount
1768     ) internal virtual {}
1769 }
1770 // File: contracts/Punkx.sol
1771 
1772 //SPDX-License-Identifier: UNLICENSED
1773 
1774 pragma solidity ^0.8.0;
1775 
1776 
1777 
1778 
1779 
1780 
1781 //@title A ERC20-token minting and ERC721 staking contract used for Punkx NFT series
1782 //@author Ace, Alfa, Anyx, 0xytocin
1783 //@notice This contract is used for staking Punkx NFT's and mint Degenz tokens according to the tokenomics mentioned in the whitepaper
1784 //@dev All functions are currently working and having the exact value they should have. TESTS ARE YET TO BE DONE.
1785 
1786 
1787 contract DegenToken is ERC20, Ownable, ReentrancyGuard{
1788 
1789     //@Interfaces
1790     IERC721 Punkx;
1791 
1792     //@Times
1793     uint public punkXStart;
1794     uint public lockoutTime = 10 days;
1795 
1796     //@Rewards
1797     mapping(uint=>bool) public mintRewardClaimed;
1798     uint[] public rewards = [13,12,11,10];
1799     uint[] public multiplier = [0,0,1,2,3,4,5];
1800     mapping(uint=>uint) externallyClaimed;
1801     mapping(address=>bool) isApproved;
1802 
1803     //@Staking
1804     mapping(uint=>stake) public stakedTokens;
1805     mapping(address=>uint[]) public userStaked;
1806 
1807     //@Emergency
1808     bool public isPaused;
1809 
1810     //@notice This is the struct containing the individual information regarding the tokens
1811     struct stake{
1812         address tokenOwner;
1813         uint lockTime;
1814         uint lastClaim;
1815         uint stakeTime;
1816         uint lockedPieces;
1817         uint arrayPosition;
1818     }
1819 
1820     //@notice This takes in PUNKX NFT's contract address and also sets the start-time to block.timestamp
1821     constructor(address punkxAddress) ERC20("DEGEN","DEGEN"){
1822         Punkx = IERC721(punkxAddress);
1823         punkXStart = block.timestamp;
1824     }
1825 
1826     //@notice SETTERS
1827     function deleteRewards () external onlyOwner {
1828         rewards.pop();
1829     }
1830 
1831     function deleteMultiplier () external onlyOwner {
1832         multiplier.pop();
1833     }
1834 
1835     function addMultiplier (uint value) external onlyOwner {
1836         multiplier.push(value);
1837     }
1838 
1839     function addRewards (uint value) external onlyOwner {
1840         rewards.push(value);
1841     }
1842 
1843     function ownerMint (uint _amount) external onlyOwner {
1844         _mint(msg.sender, _amount * 1 ether);
1845     }
1846 
1847   //@getter
1848     function getStakedUserTokens(address _query) public view returns (uint[] memory){
1849         return userStaked[_query];
1850     }
1851 
1852     //@modifiers
1853     modifier isNotPaused(){
1854         require(!isPaused,"Execution is paused");
1855         _;
1856     }
1857 
1858     //@notice This function is used to stake tokens
1859     //@param uint token-ids are taken in a array format
1860     function stakeTokens (uint[] memory tokenIds,bool lock) external isNotPaused{
1861         for (uint i=0;i<tokenIds.length;i++) {
1862             require(Punkx.ownerOf(tokenIds[i]) == msg.sender,"Not Owner"); //Can't stake unowned tokens
1863             stakedTokens[tokenIds[i]] = stake(msg.sender,0,block.timestamp,block.timestamp,0,userStaked[msg.sender].length);
1864             userStaked[msg.sender].push(tokenIds[i]);
1865             Punkx.safeTransferFrom(msg.sender,address(this),tokenIds[i]);
1866         }
1867         if(lock){
1868             require (tokenIds.length > 1,'Min Lock Amount Is 2');
1869             lockInternal(tokenIds);
1870         }
1871     }
1872 
1873     //@notice This function is used to lock in the staked function.
1874     //@param uint token-ids are taken in an array format. Here the minimum number of tokens passed should be 2.
1875     function lockTokens(uint[] memory tokenIds) public isNotPaused{
1876         require (tokenIds.length > 1,'Min Lock Amount Is 2');
1877         claimRewards(tokenIds);
1878         lockInternal(tokenIds);
1879     }
1880 
1881     function lockInternal(uint[] memory tokenIds) internal {
1882         for(uint i=0;i<tokenIds.length;i++){
1883             stake storage currentToken = stakedTokens[tokenIds[i]];
1884             require(currentToken.tokenOwner == msg.sender,"Only owner can lock"); //Needs to be owner to lock
1885             require(block.timestamp - currentToken.lockTime > lockoutTime,"Already locked"); //Need to not be locked to lock
1886             currentToken.lockTime = currentToken.lastClaim;
1887             tokenIds.length > 6 ? currentToken.lockedPieces = 6 : currentToken.lockedPieces = tokenIds.length ;
1888         }
1889     }
1890 
1891     //@notice This function is used to unstake the staked tokens. PS: tokens which are locked cannot be unstaked within lockoutTime of locking period
1892     //@param uint token-ids are taken in an array format.
1893     function unstakeTokens(uint[] memory tokenIds) external isNotPaused{
1894         claimRewards(tokenIds);
1895         for (uint i; i< tokenIds.length; i++) {
1896             require(Punkx.ownerOf(tokenIds[i]) == address(this),"Token not staked"); //Needs to not be staked
1897             stake storage currentToken = stakedTokens[tokenIds[i]];
1898             require(currentToken.tokenOwner == msg.sender,"Only owner can unstake"); //Needs to be sender's token
1899             require(block.timestamp - currentToken.lockTime > lockoutTime,"Not unlocked"); //Needs to be unlocked
1900             userStaked[msg.sender][currentToken.arrayPosition] = userStaked[msg.sender][userStaked[msg.sender].length-1];
1901             stakedTokens[userStaked[msg.sender][currentToken.arrayPosition]].arrayPosition = currentToken.arrayPosition;
1902             userStaked[msg.sender].pop();
1903             delete stakedTokens[tokenIds[i]];
1904             Punkx.safeTransferFrom(address(this), msg.sender, tokenIds[i]);
1905         }
1906     }
1907 
1908     //@notice This function is used to reward those first 2222 tokens which were minted before the staking contract was launched
1909     //@param uint token-ids are taken in an array format
1910     function rewardFromMint(uint[] memory tokenIds) external isNotPaused{
1911         require(block.timestamp - punkXStart > 7 days, "It's not birthday yet");
1912         uint totalAmount;
1913         for(uint i=0;i<tokenIds.length;i++){
1914             require(tokenIds[i] < 2222,"Reward only till 2222");
1915             require (Punkx.ownerOf(tokenIds[i])==msg.sender || stakedTokens[tokenIds[i]].tokenOwner == _msgSender());
1916             require(!mintRewardClaimed[tokenIds[i]],"Already Claimed");
1917             mintRewardClaimed[tokenIds[i]] == true;
1918             totalAmount += 32*rewards[0];
1919         }
1920         _mint(msg.sender,totalAmount*1 ether);
1921     }
1922 
1923     //@notice This function is used to reward those tokens who are staked over 1 day.
1924     //@param uint token-ids are taken in an array format
1925     function claimRewards(uint[] memory tokenIds) public nonReentrant isNotPaused{
1926         uint totalAmount; 
1927         for(uint i=0;i<tokenIds.length;i++){
1928             stake storage currentToken = stakedTokens[tokenIds[i]];
1929             require(currentToken.tokenOwner == msg.sender,"Only owner can claim"); //Needs to be sender's token
1930             totalAmount += getReward(tokenIds[i]);
1931             delete externallyClaimed[tokenIds[i]];
1932             currentToken.lastClaim += ((block.timestamp - currentToken.lastClaim)/ 1 days) * 1 days;
1933         }
1934         _mint(msg.sender,totalAmount);
1935     }
1936 
1937     //@notice This function is to be used by external contract to claim unclaimed rewards
1938     //@param  from user from which amount needs to be deducted
1939     //@param amount which is to be deducted
1940     function claimExternally(address from,uint amount,uint[] memory tokenIds) external isNotPaused {
1941         require(isApproved[msg.sender],"Not approved caller");
1942         uint totalAmount;
1943         for(uint i=0;i<tokenIds.length;i++) {
1944             stake storage currentToken = stakedTokens[tokenIds[i]];
1945             require(currentToken.tokenOwner == from,"Only owner can lock"); //Needs to be owner to lock
1946             uint reward = getReward(tokenIds[i]);
1947             if(amount > reward + totalAmount) {
1948                 externallyClaimed[tokenIds[i]] = reward;
1949                 totalAmount += reward;
1950             }
1951             else {
1952                 externallyClaimed[tokenIds[i]] = amount - totalAmount;
1953                 totalAmount = amount;
1954                 break;
1955             }
1956         }
1957         require(totalAmount == amount,"Not enough DEGEN");
1958         _mint(msg.sender,amount);
1959     }
1960 
1961     //@notice This function is to be used to fetch the unclaimed amount value calculation
1962     //@param  uint token-id is taken
1963     function getReward(uint tokenId) public view returns(uint){
1964             require(Punkx.ownerOf(tokenId) == address(this),"Token not staked"); //Needs to not be staked
1965             stake storage currentToken = stakedTokens[tokenId];
1966             uint reward;
1967             if(block.timestamp - currentToken.lockTime <= lockoutTime) {
1968                 //tokenId still in lock period
1969                 uint timeInDays = (block.timestamp - currentToken.lastClaim)/1 days;
1970                 uint combo = currentToken.lockedPieces;
1971                 reward = 1 ether*timeInDays*rewards[tokenId/2222]*(10+multiplier[combo])/10 - externallyClaimed[tokenId]; //Assuming tokenId starts from 1
1972             }
1973             else {
1974                 uint unlockTime = currentToken.lockTime + lockoutTime;
1975                 if(block.timestamp > unlockTime && currentToken.lastClaim < unlockTime){
1976                     //last claim before lock end but current time after
1977                     uint timeLocked = (currentToken.lockTime + lockoutTime - currentToken.lastClaim)/1 days;
1978                     uint timeUnlocked = (block.timestamp - (currentToken.lockTime + lockoutTime))/1 days;
1979                     uint combo = currentToken.lockedPieces;
1980                     reward = 1 ether*timeLocked*rewards[tokenId/2222]*(10+multiplier[combo])/10;
1981                     reward += 1 ether*timeUnlocked*rewards[tokenId/2222];
1982                     reward -= externallyClaimed[tokenId];
1983                 }
1984                 else{
1985                     //last claim time after lock period
1986                     uint timeInDays = (block.timestamp - currentToken.lastClaim)/1 days;
1987                     reward = 1 ether*timeInDays*rewards[tokenId/2222] - externallyClaimed[tokenId];
1988                 }
1989             }
1990         return reward;
1991     }
1992 
1993     function mintExternally(uint _amount) external isNotPaused{
1994         require(isApproved[msg.sender], "Not approved yet");
1995         _mint(_msgSender(), _amount);
1996     }
1997 
1998     function burnExternally(address _from, uint _amount) external isNotPaused{
1999         require(isApproved[msg.sender], "Not approved yet");
2000         _burn(_from, _amount);
2001     }
2002 
2003     function approveAddress(address toBeApproved,bool approveIt) external onlyOwner{
2004         isApproved[toBeApproved] = approveIt;
2005     }
2006 
2007     function pauseExecution(bool pause) external onlyOwner{
2008         isPaused = pause;
2009     }
2010     
2011     function onERC721Received( address operator, address from, uint256 tokenId, bytes calldata data ) public pure returns (bytes4) {
2012         return 0x150b7a02;
2013     }
2014 }