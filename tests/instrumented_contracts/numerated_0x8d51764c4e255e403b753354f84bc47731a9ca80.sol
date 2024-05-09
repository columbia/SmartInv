1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev Interface of the ERC165 standard, as defined in the
6  * https://eips.ethereum.org/EIPS/eip-165[EIP].
7  *
8  * Implementers can declare support of contract interfaces, which can then be
9  * queried by others ({ERC165Checker}).
10  *
11  * For an implementation, see {ERC165}.
12  */
13 interface IERC165 {
14     /**
15      * @dev Returns true if this contract implements the interface defined by
16      * `interfaceId`. See the corresponding
17      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
18      * to learn more about how these ids are created.
19      *
20      * This function call must use less than 30 000 gas.
21      */
22     function supportsInterface(bytes4 interfaceId) external view returns (bool);
23 }
24 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
25 
26 pragma solidity ^0.8.0;
27 
28 /**
29  * @dev Contract module that helps prevent reentrant calls to a function.
30  *
31  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
32  * available, which can be applied to functions to make sure there are no nested
33  * (reentrant) calls to them.
34  *
35  * Note that because there is a single `nonReentrant` guard, functions marked as
36  * `nonReentrant` may not call one another. This can be worked around by making
37  * those functions `private`, and then adding `external` `nonReentrant` entry
38  * points to them.
39  *
40  * TIP: If you would like to learn more about reentrancy and alternative ways
41  * to protect against it, check out our blog post
42  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
43  */
44 abstract contract ReentrancyGuard {
45     // Booleans are more expensive than uint256 or any type that takes up a full
46     // word because each write operation emits an extra SLOAD to first read the
47     // slot's contents, replace the bits taken up by the boolean, and then write
48     // back. This is the compiler's defense against contract upgrades and
49     // pointer aliasing, and it cannot be disabled.
50 
51     // The values being non-zero value makes deployment a bit more expensive,
52     // but in exchange the refund on every call to nonReentrant will be lower in
53     // amount. Since refunds are capped to a percentage of the total
54     // transaction's gas, it is best to keep them low in cases like this one, to
55     // increase the likelihood of the full refund coming into effect.
56     uint256 private constant _NOT_ENTERED = 1;
57     uint256 private constant _ENTERED = 2;
58 
59     uint256 private _status;
60 
61     constructor() {
62         _status = _NOT_ENTERED;
63     }
64 
65     /**
66      * @dev Prevents a contract from calling itself, directly or indirectly.
67      * Calling a `nonReentrant` function from another `nonReentrant`
68      * function is not supported. It is possible to prevent this from happening
69      * by making the `nonReentrant` function external, and making it call a
70      * `private` function that does the actual work.
71      */
72     modifier nonReentrant() {
73         // On the first call to nonReentrant, _notEntered will be true
74         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
75 
76         // Any calls to nonReentrant after this point will fail
77         _status = _ENTERED;
78 
79         _;
80 
81         // By storing the original value once again, a refund is triggered (see
82         // https://eips.ethereum.org/EIPS/eip-2200)
83         _status = _NOT_ENTERED;
84     }
85 }
86 
87 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
88 
89 pragma solidity ^0.8.0;
90 
91 /**
92  * @dev Implementation of the {IERC165} interface.
93  *
94  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
95  * for the additional interface id that will be supported. For example:
96  *
97  * ```solidity
98  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
99  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
100  * }
101  * ```
102  *
103  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
104  */
105 abstract contract ERC165 is IERC165 {
106     /**
107      * @dev See {IERC165-supportsInterface}.
108      */
109     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
110         return interfaceId == type(IERC165).interfaceId;
111     }
112 }
113 
114 
115 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
116 
117 pragma solidity ^0.8.0;
118 
119 /**
120  * @dev String operations.
121  */
122 library Strings {
123     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
124 
125     /**
126      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
127      */
128     function toString(uint256 value) internal pure returns (string memory) {
129         // Inspired by OraclizeAPI's implementation - MIT licence
130         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
131 
132         if (value == 0) {
133             return "0";
134         }
135         uint256 temp = value;
136         uint256 digits;
137         while (temp != 0) {
138             digits++;
139             temp /= 10;
140         }
141         bytes memory buffer = new bytes(digits);
142         while (value != 0) {
143             digits -= 1;
144             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
145             value /= 10;
146         }
147         return string(buffer);
148     }
149 
150     /**
151      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
152      */
153     function toHexString(uint256 value) internal pure returns (string memory) {
154         if (value == 0) {
155             return "0x00";
156         }
157         uint256 temp = value;
158         uint256 length = 0;
159         while (temp != 0) {
160             length++;
161             temp >>= 8;
162         }
163         return toHexString(value, length);
164     }
165 
166     /**
167      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
168      */
169     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
170         bytes memory buffer = new bytes(2 * length + 2);
171         buffer[0] = "0";
172         buffer[1] = "x";
173         for (uint256 i = 2 * length + 1; i > 1; --i) {
174             buffer[i] = _HEX_SYMBOLS[value & 0xf];
175             value >>= 4;
176         }
177         require(value == 0, "Strings: hex length insufficient");
178         return string(buffer);
179     }
180 }
181 
182 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
183 
184 pragma solidity ^0.8.0;
185 
186 /**
187  * @dev Collection of functions related to the address type
188  */
189 library Address {
190     /**
191      * @dev Returns true if `account` is a contract.
192      *
193      * [IMPORTANT]
194      * ====
195      * It is unsafe to assume that an address for which this function returns
196      * false is an externally-owned account (EOA) and not a contract.
197      *
198      * Among others, `isContract` will return false for the following
199      * types of addresses:
200      *
201      *  - an externally-owned account
202      *  - a contract in construction
203      *  - an address where a contract will be created
204      *  - an address where a contract lived, but was destroyed
205      * ====
206      */
207     function isContract(address account) internal view returns (bool) {
208         // This method relies on extcodesize, which returns 0 for contracts in
209         // construction, since the code is only stored at the end of the
210         // constructor execution.
211 
212         uint256 size;
213         assembly {
214             size := extcodesize(account)
215         }
216         return size > 0;
217     }
218 
219     /**
220      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
221      * `recipient`, forwarding all available gas and reverting on errors.
222      *
223      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
224      * of certain opcodes, possibly making contracts go over the 2300 gas limit
225      * imposed by `transfer`, making them unable to receive funds via
226      * `transfer`. {sendValue} removes this limitation.
227      *
228      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
229      *
230      * IMPORTANT: because control is transferred to `recipient`, care must be
231      * taken to not create reentrancy vulnerabilities. Consider using
232      * {ReentrancyGuard} or the
233      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
234      */
235     function sendValue(address payable recipient, uint256 amount) internal {
236         require(address(this).balance >= amount, "Address: insufficient balance");
237 
238         (bool success, ) = recipient.call{value: amount}("");
239         require(success, "Address: unable to send value, recipient may have reverted");
240     }
241 
242     /**
243      * @dev Performs a Solidity function call using a low level `call`. A
244      * plain `call` is an unsafe replacement for a function call: use this
245      * function instead.
246      *
247      * If `target` reverts with a revert reason, it is bubbled up by this
248      * function (like regular Solidity function calls).
249      *
250      * Returns the raw returned data. To convert to the expected return value,
251      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
252      *
253      * Requirements:
254      *
255      * - `target` must be a contract.
256      * - calling `target` with `data` must not revert.
257      *
258      * _Available since v3.1._
259      */
260     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
261         return functionCall(target, data, "Address: low-level call failed");
262     }
263 
264     /**
265      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
266      * `errorMessage` as a fallback revert reason when `target` reverts.
267      *
268      * _Available since v3.1._
269      */
270     function functionCall(
271         address target,
272         bytes memory data,
273         string memory errorMessage
274     ) internal returns (bytes memory) {
275         return functionCallWithValue(target, data, 0, errorMessage);
276     }
277 
278     /**
279      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
280      * but also transferring `value` wei to `target`.
281      *
282      * Requirements:
283      *
284      * - the calling contract must have an ETH balance of at least `value`.
285      * - the called Solidity function must be `payable`.
286      *
287      * _Available since v3.1._
288      */
289     function functionCallWithValue(
290         address target,
291         bytes memory data,
292         uint256 value
293     ) internal returns (bytes memory) {
294         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
295     }
296 
297     /**
298      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
299      * with `errorMessage` as a fallback revert reason when `target` reverts.
300      *
301      * _Available since v3.1._
302      */
303     function functionCallWithValue(
304         address target,
305         bytes memory data,
306         uint256 value,
307         string memory errorMessage
308     ) internal returns (bytes memory) {
309         require(address(this).balance >= value, "Address: insufficient balance for call");
310         require(isContract(target), "Address: call to non-contract");
311 
312         (bool success, bytes memory returndata) = target.call{value: value}(data);
313         return verifyCallResult(success, returndata, errorMessage);
314     }
315 
316     /**
317      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
318      * but performing a static call.
319      *
320      * _Available since v3.3._
321      */
322     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
323         return functionStaticCall(target, data, "Address: low-level static call failed");
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
328      * but performing a static call.
329      *
330      * _Available since v3.3._
331      */
332     function functionStaticCall(
333         address target,
334         bytes memory data,
335         string memory errorMessage
336     ) internal view returns (bytes memory) {
337         require(isContract(target), "Address: static call to non-contract");
338 
339         (bool success, bytes memory returndata) = target.staticcall(data);
340         return verifyCallResult(success, returndata, errorMessage);
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
345      * but performing a delegate call.
346      *
347      * _Available since v3.4._
348      */
349     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
350         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
355      * but performing a delegate call.
356      *
357      * _Available since v3.4._
358      */
359     function functionDelegateCall(
360         address target,
361         bytes memory data,
362         string memory errorMessage
363     ) internal returns (bytes memory) {
364         require(isContract(target), "Address: delegate call to non-contract");
365 
366         (bool success, bytes memory returndata) = target.delegatecall(data);
367         return verifyCallResult(success, returndata, errorMessage);
368     }
369 
370     /**
371      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
372      * revert reason using the provided one.
373      *
374      * _Available since v4.3._
375      */
376     function verifyCallResult(
377         bool success,
378         bytes memory returndata,
379         string memory errorMessage
380     ) internal pure returns (bytes memory) {
381         if (success) {
382             return returndata;
383         } else {
384             // Look for revert reason and bubble it up if present
385             if (returndata.length > 0) {
386                 // The easiest way to bubble the revert reason is using memory via assembly
387 
388                 assembly {
389                     let returndata_size := mload(returndata)
390                     revert(add(32, returndata), returndata_size)
391                 }
392             } else {
393                 revert(errorMessage);
394             }
395         }
396     }
397 }
398 
399 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
400 
401 pragma solidity ^0.8.0;
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
437      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
438      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
439      *
440      * Requirements:
441      *
442      * - `from` cannot be the zero address.
443      * - `to` cannot be the zero address.
444      * - `tokenId` token must exist and be owned by `from`.
445      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
446      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
447      *
448      * Emits a {Transfer} event.
449      */
450     function safeTransferFrom(
451         address from,
452         address to,
453         uint256 tokenId
454     ) external;
455 
456     /**
457      * @dev Transfers `tokenId` token from `from` to `to`.
458      *
459      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
460      *
461      * Requirements:
462      *
463      * - `from` cannot be the zero address.
464      * - `to` cannot be the zero address.
465      * - `tokenId` token must be owned by `from`.
466      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
467      *
468      * Emits a {Transfer} event.
469      */
470     function transferFrom(
471         address from,
472         address to,
473         uint256 tokenId
474     ) external;
475 
476     /**
477      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
478      * The approval is cleared when the token is transferred.
479      *
480      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
481      *
482      * Requirements:
483      *
484      * - The caller must own the token or be an approved operator.
485      * - `tokenId` must exist.
486      *
487      * Emits an {Approval} event.
488      */
489     function approve(address to, uint256 tokenId) external;
490 
491     /**
492      * @dev Returns the account approved for `tokenId` token.
493      *
494      * Requirements:
495      *
496      * - `tokenId` must exist.
497      */
498     function getApproved(uint256 tokenId) external view returns (address operator);
499 
500     /**
501      * @dev Approve or remove `operator` as an operator for the caller.
502      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
503      *
504      * Requirements:
505      *
506      * - The `operator` cannot be the caller.
507      *
508      * Emits an {ApprovalForAll} event.
509      */
510     function setApprovalForAll(address operator, bool _approved) external;
511 
512     /**
513      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
514      *
515      * See {setApprovalForAll}
516      */
517     function isApprovedForAll(address owner, address operator) external view returns (bool);
518 
519     /**
520      * @dev Safely transfers `tokenId` token from `from` to `to`.
521      *
522      * Requirements:
523      *
524      * - `from` cannot be the zero address.
525      * - `to` cannot be the zero address.
526      * - `tokenId` token must exist and be owned by `from`.
527      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
528      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
529      *
530      * Emits a {Transfer} event.
531      */
532     function safeTransferFrom(
533         address from,
534         address to,
535         uint256 tokenId,
536         bytes calldata data
537     ) external;
538 }
539 
540 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
541 
542 pragma solidity ^0.8.0;
543 
544 
545 /**
546  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
547  * @dev See https://eips.ethereum.org/EIPS/eip-721
548  */
549 interface IERC721Enumerable is IERC721 {
550     /**
551      * @dev Returns the total amount of tokens stored by the contract.
552      */
553     function totalSupply() external view returns (uint256);
554 
555     /**
556      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
557      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
558      */
559     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
560 
561     /**
562      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
563      * Use along with {totalSupply} to enumerate all tokens.
564      */
565     function tokenByIndex(uint256 index) external view returns (uint256);
566 }
567 
568 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
569 
570 pragma solidity ^0.8.0;
571 
572 
573 
574 /**
575  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
576  * @dev See https://eips.ethereum.org/EIPS/eip-721
577  */
578 interface IERC721Metadata is IERC721 {
579     /**
580      * @dev Returns the token collection name.
581      */
582     function name() external view returns (string memory);
583 
584     /**
585      * @dev Returns the token collection symbol.
586      */
587     function symbol() external view returns (string memory);
588 
589     /**
590      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
591      */
592     function tokenURI(uint256 tokenId) external view returns (string memory);
593 }
594 
595 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
596 
597 pragma solidity ^0.8.0;
598 
599 /**
600  * @title ERC721 token receiver interface
601  * @dev Interface for any contract that wants to support safeTransfers
602  * from ERC721 asset contracts.
603  */
604 interface IERC721Receiver {
605     /**
606      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
607      * by `operator` from `from`, this function is called.
608      *
609      * It must return its Solidity selector to confirm the token transfer.
610      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
611      *
612      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
613      */
614     function onERC721Received(
615         address operator,
616         address from,
617         uint256 tokenId,
618         bytes calldata data
619     ) external returns (bytes4);
620 }
621 
622 
623 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
624 
625 pragma solidity ^0.8.0;
626 
627 /**
628  * @dev Provides information about the current execution context, including the
629  * sender of the transaction and its data. While these are generally available
630  * via msg.sender and msg.data, they should not be accessed in such a direct
631  * manner, since when dealing with meta-transactions the account sending and
632  * paying for execution may not be the actual sender (as far as an application
633  * is concerned).
634  *
635  * This contract is only required for intermediate, library-like contracts.
636  */
637 abstract contract Context {
638     function _msgSender() internal view virtual returns (address) {
639         return msg.sender;
640     }
641 
642     function _msgData() internal view virtual returns (bytes calldata) {
643         return msg.data;
644     }
645 }
646 
647 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
648 
649 pragma solidity ^0.8.0;
650 
651 
652 /**
653  * @dev Contract module which provides a basic access control mechanism, where
654  * there is an account (an owner) that can be granted exclusive access to
655  * specific functions.
656  *
657  * By default, the owner account will be the one that deploys the contract. This
658  * can later be changed with {transferOwnership}.
659  *
660  * This module is used through inheritance. It will make available the modifier
661  * `onlyOwner`, which can be applied to your functions to restrict their use to
662  * the owner.
663  */
664 abstract contract Ownable is Context {
665     address private _owner;
666 
667     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
668 
669     /**
670      * @dev Initializes the contract setting the deployer as the initial owner.
671      */
672     constructor() {
673         _transferOwnership(_msgSender());
674     }
675 
676     /**
677      * @dev Returns the address of the current owner.
678      */
679     function owner() public view virtual returns (address) {
680         return _owner;
681     }
682 
683     /**
684      * @dev Throws if called by any account other than the owner.
685      */
686     modifier onlyOwner() {
687         require(owner() == _msgSender(), "Ownable: caller is not the owner");
688         _;
689     }
690 
691     /**
692      * @dev Leaves the contract without owner. It will not be possible to call
693      * `onlyOwner` functions anymore. Can only be called by the current owner.
694      *
695      * NOTE: Renouncing ownership will leave the contract without an owner,
696      * thereby removing any functionality that is only available to the owner.
697      */
698     function renounceOwnership() public virtual onlyOwner {
699         _transferOwnership(address(0));
700     }
701 
702     /**
703      * @dev Transfers ownership of the contract to a new account (`newOwner`).
704      * Can only be called by the current owner.
705      */
706     function transferOwnership(address newOwner) public virtual onlyOwner {
707         require(newOwner != address(0), "Ownable: new owner is the zero address");
708         _transferOwnership(newOwner);
709     }
710 
711     /**
712      * @dev Transfers ownership of the contract to a new account (`newOwner`).
713      * Internal function without access restriction.
714      */
715     function _transferOwnership(address newOwner) internal virtual {
716         address oldOwner = _owner;
717         _owner = newOwner;
718         emit OwnershipTransferred(oldOwner, newOwner);
719     }
720 }
721 
722 pragma solidity ^0.8.0;
723 
724 /**
725  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
726  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
727  *
728  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
729  *
730  * Does not support burning tokens to address(0).
731  *
732  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
733  */
734 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
735     using Address for address;
736     using Strings for uint256;
737 
738     struct TokenOwnership {
739         address addr;
740         uint64 startTimestamp;
741     }
742 
743     struct AddressData {
744         uint128 balance;
745         uint128 numberMinted;
746     }
747 
748     uint256 internal currentIndex;
749 
750     // Token name
751     string private _name;
752 
753     // Token symbol
754     string private _symbol;
755 
756     // Mapping from token ID to ownership details
757     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
758     mapping(uint256 => TokenOwnership) internal _ownerships;
759 
760     // Mapping owner address to address data
761     mapping(address => AddressData) private _addressData;
762 
763     // Mapping from token ID to approved address
764     mapping(uint256 => address) private _tokenApprovals;
765 
766     // Mapping from owner to operator approvals
767     mapping(address => mapping(address => bool)) private _operatorApprovals;
768 
769     constructor(string memory name_, string memory symbol_) {
770         _name = name_;
771         _symbol = symbol_;
772     }
773 
774     /**
775      * @dev See {IERC721Enumerable-totalSupply}.
776      */
777     function totalSupply() public view override returns (uint256) {
778         return currentIndex;
779     }
780 
781     /**
782      * @dev See {IERC721Enumerable-tokenByIndex}.
783      */
784     function tokenByIndex(uint256 index) public view override returns (uint256) {
785         require(index < totalSupply(), 'ERC721A: global index out of bounds');
786         return index;
787     }
788 
789     /**
790      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
791      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
792      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
793      */
794     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
795         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
796         uint256 numMintedSoFar = totalSupply();
797         uint256 tokenIdsIdx;
798         address currOwnershipAddr;
799 
800         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
801         unchecked {
802             for (uint256 i; i < numMintedSoFar; i++) {
803                 TokenOwnership memory ownership = _ownerships[i];
804                 if (ownership.addr != address(0)) {
805                     currOwnershipAddr = ownership.addr;
806                 }
807                 if (currOwnershipAddr == owner) {
808                     if (tokenIdsIdx == index) {
809                         return i;
810                     }
811                     tokenIdsIdx++;
812                 }
813             }
814         }
815 
816         revert('ERC721A: unable to get token of owner by index');
817     }
818 
819     /**
820      * @dev See {IERC165-supportsInterface}.
821      */
822     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
823         return
824             interfaceId == type(IERC721).interfaceId ||
825             interfaceId == type(IERC721Metadata).interfaceId ||
826             interfaceId == type(IERC721Enumerable).interfaceId ||
827             super.supportsInterface(interfaceId);
828     }
829 
830     /**
831      * @dev See {IERC721-balanceOf}.
832      */
833     function balanceOf(address owner) public view override returns (uint256) {
834         require(owner != address(0), 'ERC721A: balance query for the zero address');
835         return uint256(_addressData[owner].balance);
836     }
837 
838     function _numberMinted(address owner) internal view returns (uint256) {
839         require(owner != address(0), 'ERC721A: number minted query for the zero address');
840         return uint256(_addressData[owner].numberMinted);
841     }
842 
843     /**
844      * Gas spent here starts off proportional to the maximum mint batch size.
845      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
846      */
847     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
848         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
849 
850         unchecked {
851             for (uint256 curr = tokenId; curr >= 0; curr--) {
852                 TokenOwnership memory ownership = _ownerships[curr];
853                 if (ownership.addr != address(0)) {
854                     return ownership;
855                 }
856             }
857         }
858 
859         revert('ERC721A: unable to determine the owner of token');
860     }
861 
862     /**
863      * @dev See {IERC721-ownerOf}.
864      */
865     function ownerOf(uint256 tokenId) public view override returns (address) {
866         return ownershipOf(tokenId).addr;
867     }
868 
869     /**
870      * @dev See {IERC721Metadata-name}.
871      */
872     function name() public view virtual override returns (string memory) {
873         return _name;
874     }
875 
876     /**
877      * @dev See {IERC721Metadata-symbol}.
878      */
879     function symbol() public view virtual override returns (string memory) {
880         return _symbol;
881     }
882 
883     /**
884      * @dev See {IERC721Metadata-tokenURI}.
885      */
886     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
887         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
888 
889         string memory baseURI = _baseURI();
890         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
891     }
892 
893     /**
894      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
895      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
896      * by default, can be overriden in child contracts.
897      */
898     function _baseURI() internal view virtual returns (string memory) {
899         return '';
900     }
901 
902     /**
903      * @dev See {IERC721-approve}.
904      */
905     function approve(address to, uint256 tokenId) public override {
906         address owner = ERC721A.ownerOf(tokenId);
907         require(to != owner, 'ERC721A: approval to current owner');
908 
909         require(
910             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
911             'ERC721A: approve caller is not owner nor approved for all'
912         );
913 
914         _approve(to, tokenId, owner);
915     }
916 
917     /**
918      * @dev See {IERC721-getApproved}.
919      */
920     function getApproved(uint256 tokenId) public view override returns (address) {
921         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
922 
923         return _tokenApprovals[tokenId];
924     }
925 
926     /**
927      * @dev See {IERC721-setApprovalForAll}.
928      */
929     function setApprovalForAll(address operator, bool approved) public override {
930         require(operator != _msgSender(), 'ERC721A: approve to caller');
931 
932         _operatorApprovals[_msgSender()][operator] = approved;
933         emit ApprovalForAll(_msgSender(), operator, approved);
934     }
935 
936     /**
937      * @dev See {IERC721-isApprovedForAll}.
938      */
939     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
940         return _operatorApprovals[owner][operator];
941     }
942 
943     /**
944      * @dev See {IERC721-transferFrom}.
945      */
946     function transferFrom(
947         address from,
948         address to,
949         uint256 tokenId
950     ) public override {
951         _transfer(from, to, tokenId);
952     }
953 
954     /**
955      * @dev See {IERC721-safeTransferFrom}.
956      */
957     function safeTransferFrom(
958         address from,
959         address to,
960         uint256 tokenId
961     ) public override {
962         safeTransferFrom(from, to, tokenId, '');
963     }
964 
965     /**
966      * @dev See {IERC721-safeTransferFrom}.
967      */
968     function safeTransferFrom(
969         address from,
970         address to,
971         uint256 tokenId,
972         bytes memory _data
973     ) public override {
974         _transfer(from, to, tokenId);
975         require(
976             _checkOnERC721Received(from, to, tokenId, _data),
977             'ERC721A: transfer to non ERC721Receiver implementer'
978         );
979     }
980 
981     /**
982      * @dev Returns whether `tokenId` exists.
983      *
984      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
985      *
986      * Tokens start existing when they are minted (`_mint`),
987      */
988     function _exists(uint256 tokenId) internal view returns (bool) {
989         return tokenId < currentIndex;
990     }
991 
992     function _safeMint(address to, uint256 quantity) internal {
993         _safeMint(to, quantity, '');
994     }
995 
996     /**
997      * @dev Safely mints `quantity` tokens and transfers them to `to`.
998      *
999      * Requirements:
1000      *
1001      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1002      * - `quantity` must be greater than 0.
1003      *
1004      * Emits a {Transfer} event.
1005      */
1006     function _safeMint(
1007         address to,
1008         uint256 quantity,
1009         bytes memory _data
1010     ) internal {
1011         _mint(to, quantity, _data, true);
1012     }
1013 
1014     /**
1015      * @dev Mints `quantity` tokens and transfers them to `to`.
1016      *
1017      * Requirements:
1018      *
1019      * - `to` cannot be the zero address.
1020      * - `quantity` must be greater than 0.
1021      *
1022      * Emits a {Transfer} event.
1023      */
1024     function _mint(
1025         address to,
1026         uint256 quantity,
1027         bytes memory _data,
1028         bool safe
1029     ) internal {
1030         uint256 startTokenId = currentIndex;
1031         require(to != address(0), 'ERC721A: mint to the zero address');
1032         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1033 
1034         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1035 
1036         // Overflows are incredibly unrealistic.
1037         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1038         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1039         unchecked {
1040             _addressData[to].balance += uint128(quantity);
1041             _addressData[to].numberMinted += uint128(quantity);
1042 
1043             _ownerships[startTokenId].addr = to;
1044             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1045 
1046             uint256 updatedIndex = startTokenId;
1047 
1048             for (uint256 i; i < quantity; i++) {
1049                 emit Transfer(address(0), to, updatedIndex);
1050                 if (safe) {
1051                     require(
1052                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1053                         'ERC721A: transfer to non ERC721Receiver implementer'
1054                     );
1055                 }
1056 
1057                 updatedIndex++;
1058             }
1059 
1060             currentIndex = updatedIndex;
1061         }
1062 
1063         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1064     }
1065 
1066     /**
1067      * @dev Transfers `tokenId` from `from` to `to`.
1068      *
1069      * Requirements:
1070      *
1071      * - `to` cannot be the zero address.
1072      * - `tokenId` token must be owned by `from`.
1073      *
1074      * Emits a {Transfer} event.
1075      */
1076     function _transfer(
1077         address from,
1078         address to,
1079         uint256 tokenId
1080     ) private {
1081         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1082 
1083         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1084             getApproved(tokenId) == _msgSender() ||
1085             isApprovedForAll(prevOwnership.addr, _msgSender()));
1086 
1087         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1088 
1089         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1090         require(to != address(0), 'ERC721A: transfer to the zero address');
1091 
1092         _beforeTokenTransfers(from, to, tokenId, 1);
1093 
1094         // Clear approvals from the previous owner
1095         _approve(address(0), tokenId, prevOwnership.addr);
1096 
1097         // Underflow of the sender's balance is impossible because we check for
1098         // ownership above and the recipient's balance can't realistically overflow.
1099         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1100         unchecked {
1101             _addressData[from].balance -= 1;
1102             _addressData[to].balance += 1;
1103 
1104             _ownerships[tokenId].addr = to;
1105             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1106 
1107             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1108             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1109             uint256 nextTokenId = tokenId + 1;
1110             if (_ownerships[nextTokenId].addr == address(0)) {
1111                 if (_exists(nextTokenId)) {
1112                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1113                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1114                 }
1115             }
1116         }
1117 
1118         emit Transfer(from, to, tokenId);
1119         _afterTokenTransfers(from, to, tokenId, 1);
1120     }
1121 
1122     /**
1123      * @dev Approve `to` to operate on `tokenId`
1124      *
1125      * Emits a {Approval} event.
1126      */
1127     function _approve(
1128         address to,
1129         uint256 tokenId,
1130         address owner
1131     ) private {
1132         _tokenApprovals[tokenId] = to;
1133         emit Approval(owner, to, tokenId);
1134     }
1135 
1136     /**
1137      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1138      * The call is not executed if the target address is not a contract.
1139      *
1140      * @param from address representing the previous owner of the given token ID
1141      * @param to target address that will receive the tokens
1142      * @param tokenId uint256 ID of the token to be transferred
1143      * @param _data bytes optional data to send along with the call
1144      * @return bool whether the call correctly returned the expected magic value
1145      */
1146     function _checkOnERC721Received(
1147         address from,
1148         address to,
1149         uint256 tokenId,
1150         bytes memory _data
1151     ) private returns (bool) {
1152         if (to.isContract()) {
1153             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1154                 return retval == IERC721Receiver(to).onERC721Received.selector;
1155             } catch (bytes memory reason) {
1156                 if (reason.length == 0) {
1157                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1158                 } else {
1159                     assembly {
1160                         revert(add(32, reason), mload(reason))
1161                     }
1162                 }
1163             }
1164         } else {
1165             return true;
1166         }
1167     }
1168 
1169     /**
1170      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1171      *
1172      * startTokenId - the first token id to be transferred
1173      * quantity - the amount to be transferred
1174      *
1175      * Calling conditions:
1176      *
1177      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1178      * transferred to `to`.
1179      * - When `from` is zero, `tokenId` will be minted for `to`.
1180      */
1181     function _beforeTokenTransfers(
1182         address from,
1183         address to,
1184         uint256 startTokenId,
1185         uint256 quantity
1186     ) internal virtual {}
1187 
1188     /**
1189      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1190      * minting.
1191      *
1192      * startTokenId - the first token id to be transferred
1193      * quantity - the amount to be transferred
1194      *
1195      * Calling conditions:
1196      *
1197      * - when `from` and `to` are both non-zero.
1198      * - `from` and `to` are never both zero.
1199      */
1200     function _afterTokenTransfers(
1201         address from,
1202         address to,
1203         uint256 startTokenId,
1204         uint256 quantity
1205     ) internal virtual {}
1206 }
1207 
1208 
1209 pragma solidity ^0.8.4;
1210 
1211 contract SKYBIRDS is ERC721A, Ownable, ReentrancyGuard {
1212     using Strings for uint256;
1213 
1214     uint256 public PRICE;
1215     uint256 public MAX_SUPPLY;
1216     string private BASE_URI;
1217     uint256 public FREE_MINT_LIMIT_PER_WALLET;
1218     uint256 public MAX_MINT_AMOUNT_PER_TX;
1219     bool public IS_SALE_ACTIVE;
1220     uint256 public FREE_MINT_IS_ALLOWED_UNTIL; // Free mint is allowed until x mint
1221     bool public METADATA_FROZEN;
1222 
1223     mapping(address => uint256) private freeMintCountMap;
1224 
1225     constructor(uint256 price, uint256 maxSupply, string memory baseUri, uint256 freeMintAllowance, uint256 maxMintPerTx, bool isSaleActive, uint256 freeMintIsAllowedUntil) ERC721A("SKYBIRDS", "SBIRD") {
1226         PRICE = price;
1227         MAX_SUPPLY = maxSupply;
1228         BASE_URI = baseUri;
1229         FREE_MINT_LIMIT_PER_WALLET = freeMintAllowance;
1230         MAX_MINT_AMOUNT_PER_TX = maxMintPerTx;
1231         IS_SALE_ACTIVE = isSaleActive;
1232         FREE_MINT_IS_ALLOWED_UNTIL = freeMintIsAllowedUntil;
1233     }
1234 
1235     /** FREE MINT **/
1236 
1237     function updateFreeMintCount(address minter, uint256 count) private {
1238         freeMintCountMap[minter] += count;
1239     }
1240 
1241     /** GETTERS **/
1242 
1243     function _baseURI() internal view virtual override returns (string memory) {
1244         return BASE_URI;
1245     }
1246 
1247     /** SETTERS **/
1248 
1249     function setPrice(uint256 customPrice) external onlyOwner {
1250         PRICE = customPrice;
1251     }
1252 
1253     function lowerMaxSupply(uint256 newMaxSupply) external onlyOwner {
1254         require(newMaxSupply < MAX_SUPPLY, "Invalid new max supply");
1255         require(newMaxSupply >= currentIndex, "Invalid new max supply");
1256         MAX_SUPPLY = newMaxSupply;
1257     }
1258 
1259     function setBaseURI(string memory customBaseURI_) external onlyOwner {
1260         require(!METADATA_FROZEN, "Metadata frozen!");
1261         BASE_URI = customBaseURI_;
1262     }
1263 
1264     function setFreeMintAllowance(uint256 freeMintAllowance) external onlyOwner {
1265         FREE_MINT_LIMIT_PER_WALLET = freeMintAllowance;
1266     }
1267 
1268     function setMaxMintPerTx(uint256 maxMintPerTx) external onlyOwner {
1269         MAX_MINT_AMOUNT_PER_TX = maxMintPerTx;
1270     }
1271 
1272     function setSaleActive(bool saleIsActive) external onlyOwner {
1273         IS_SALE_ACTIVE = saleIsActive;
1274     }
1275 
1276     function setFreeMintAllowedUntil(uint256 freeMintIsAllowedUntil) external onlyOwner {
1277         FREE_MINT_IS_ALLOWED_UNTIL = freeMintIsAllowedUntil;
1278     }
1279 
1280     function freezeMetadata() external onlyOwner {
1281         METADATA_FROZEN = true;
1282     }
1283 
1284     /** MINT **/
1285 
1286     modifier mintCompliance(uint256 _mintAmount) {
1287         require(_mintAmount > 0 && _mintAmount <= MAX_MINT_AMOUNT_PER_TX, "Invalid mint amount!");
1288         require(currentIndex + _mintAmount <= MAX_SUPPLY, "Max supply exceeded!");
1289         _;
1290     }
1291 
1292     function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1293         require(IS_SALE_ACTIVE, "Sale is not active!");
1294 
1295         uint256 price = PRICE * _mintAmount;
1296 
1297         if (currentIndex < FREE_MINT_IS_ALLOWED_UNTIL) {
1298             uint256 remainingFreeMint = FREE_MINT_LIMIT_PER_WALLET - freeMintCountMap[msg.sender];
1299             if (remainingFreeMint > 0) {
1300                 if (_mintAmount >= remainingFreeMint) {
1301                     price -= remainingFreeMint * PRICE;
1302                     updateFreeMintCount(msg.sender, remainingFreeMint);
1303                 } else {
1304                     price -= _mintAmount * PRICE;
1305                     updateFreeMintCount(msg.sender, _mintAmount);
1306                 }
1307             }
1308         }
1309 
1310         require(msg.value >= price, "Insufficient funds!");
1311 
1312         _safeMint(msg.sender, _mintAmount);
1313     }
1314 
1315     function mintOwner(address _to, uint256 _mintAmount) public mintCompliance(_mintAmount) onlyOwner {
1316         _safeMint(_to, _mintAmount);
1317     }
1318 
1319     /** PAYOUT **/
1320 
1321     address private constant payoutAddress =
1322     0xBE4BbfdBbd69c6DAdc5590B62D5B32fd68B0ab47;
1323 
1324     function withdraw() public onlyOwner nonReentrant {
1325         uint256 balance = address(this).balance;
1326 
1327         Address.sendValue(payable(payoutAddress), balance);
1328     }
1329 }