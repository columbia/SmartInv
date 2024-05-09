1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /*
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
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 pragma solidity ^0.8.0;
26 
27 /**
28  * @dev Interface of the ERC165 standard, as defined in the
29  * https://eips.ethereum.org/EIPS/eip-165[EIP].
30  *
31  * Implementers can declare support of contract interfaces, which can then be
32  * queried by others ({ERC165Checker}).
33  *
34  * For an implementation, see {ERC165}.
35  */
36 interface IERC165 {
37     /**
38      * @dev Returns true if this contract implements the interface defined by
39      * `interfaceId`. See the corresponding
40      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
41      * to learn more about how these ids are created.
42      *
43      * This function call must use less than 30 000 gas.
44      */
45     function supportsInterface(bytes4 interfaceId) external view returns (bool);
46 }
47 
48 pragma solidity ^0.8.0;
49 
50 
51 /**
52  * @dev Required interface of an ERC721 compliant contract.
53  */
54 interface IERC721 is IERC165 {
55     /**
56      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
57      */
58     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
59 
60     /**
61      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
62      */
63     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
64 
65     /**
66      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
67      */
68     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
69 
70     /**
71      * @dev Returns the number of tokens in ``owner``'s account.
72      */
73     function balanceOf(address owner) external view returns (uint256 balance);
74 
75     /**
76      * @dev Returns the owner of the `tokenId` token.
77      *
78      * Requirements:
79      *
80      * - `tokenId` must exist.
81      */
82     function ownerOf(uint256 tokenId) external view returns (address owner);
83 
84     /**
85      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
86      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
87      *
88      * Requirements:
89      *
90      * - `from` cannot be the zero address.
91      * - `to` cannot be the zero address.
92      * - `tokenId` token must exist and be owned by `from`.
93      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
94      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
95      *
96      * Emits a {Transfer} event.
97      */
98     function safeTransferFrom(address from, address to, uint256 tokenId) external;
99 
100     /**
101      * @dev Transfers `tokenId` token from `from` to `to`.
102      *
103      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
104      *
105      * Requirements:
106      *
107      * - `from` cannot be the zero address.
108      * - `to` cannot be the zero address.
109      * - `tokenId` token must be owned by `from`.
110      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
111      *
112      * Emits a {Transfer} event.
113      */
114     function transferFrom(address from, address to, uint256 tokenId) external;
115 
116     /**
117      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
118      * The approval is cleared when the token is transferred.
119      *
120      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
121      *
122      * Requirements:
123      *
124      * - The caller must own the token or be an approved operator.
125      * - `tokenId` must exist.
126      *
127      * Emits an {Approval} event.
128      */
129     function approve(address to, uint256 tokenId) external;
130 
131     /**
132      * @dev Returns the account approved for `tokenId` token.
133      *
134      * Requirements:
135      *
136      * - `tokenId` must exist.
137      */
138     function getApproved(uint256 tokenId) external view returns (address operator);
139 
140     /**
141      * @dev Approve or remove `operator` as an operator for the caller.
142      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
143      *
144      * Requirements:
145      *
146      * - The `operator` cannot be the caller.
147      *
148      * Emits an {ApprovalForAll} event.
149      */
150     function setApprovalForAll(address operator, bool _approved) external;
151 
152     /**
153      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
154      *
155      * See {setApprovalForAll}
156      */
157     function isApprovedForAll(address owner, address operator) external view returns (bool);
158 
159     /**
160       * @dev Safely transfers `tokenId` token from `from` to `to`.
161       *
162       * Requirements:
163       *
164       * - `from` cannot be the zero address.
165       * - `to` cannot be the zero address.
166       * - `tokenId` token must exist and be owned by `from`.
167       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
168       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
169       *
170       * Emits a {Transfer} event.
171       */
172     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
173 }
174 
175 pragma solidity ^0.8.0;
176 
177 
178 /**
179  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
180  * @dev See https://eips.ethereum.org/EIPS/eip-721
181  */
182 interface IERC721Metadata is IERC721 {
183 
184     /**
185      * @dev Returns the token collection name.
186      */
187     function name() external view returns (string memory);
188 
189     /**
190      * @dev Returns the token collection symbol.
191      */
192     function symbol() external view returns (string memory);
193 
194     /**
195      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
196      */
197     function tokenURI(uint256 tokenId) external view returns (string memory);
198 }
199 
200 pragma solidity ^0.8.0;
201 
202 
203 /**
204  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
205  * @dev See https://eips.ethereum.org/EIPS/eip-721
206  */
207 interface IERC721Enumerable is IERC721 {
208 
209     /**
210      * @dev Returns the total amount of tokens stored by the contract.
211      */
212     function totalSupply() external view returns (uint256);
213 
214     /**
215      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
216      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
217      */
218     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
219 
220     /**
221      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
222      * Use along with {totalSupply} to enumerate all tokens.
223      */
224     function tokenByIndex(uint256 index) external view returns (uint256);
225 }
226 
227 pragma solidity ^0.8.0;
228 
229 /**
230  * @title ERC721 token receiver interface
231  * @dev Interface for any contract that wants to support safeTransfers
232  * from ERC721 asset contracts.
233  */
234 interface IERC721Receiver {
235     /**
236      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
237      * by `operator` from `from`, this function is called.
238      *
239      * It must return its Solidity selector to confirm the token transfer.
240      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
241      *
242      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
243      */
244     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
245 }
246 
247 pragma solidity ^0.8.0;
248 
249 
250 /**
251  * @dev Implementation of the {IERC165} interface.
252  *
253  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
254  * for the additional interface id that will be supported. For example:
255  *
256  * ```solidity
257  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
258  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
259  * }
260  * ```
261  *
262  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
263  */
264 abstract contract ERC165 is IERC165 {
265     /**
266      * @dev See {IERC165-supportsInterface}.
267      */
268     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
269         return interfaceId == type(IERC165).interfaceId;
270     }
271 }
272 
273 pragma solidity ^0.8.0;
274 
275 /**
276  * @dev Collection of functions related to the address type
277  */
278 library Address {
279     /**
280      * @dev Returns true if `account` is a contract.
281      *
282      * [IMPORTANT]
283      * ====
284      * It is unsafe to assume that an address for which this function returns
285      * false is an externally-owned account (EOA) and not a contract.
286      *
287      * Among others, `isContract` will return false for the following
288      * types of addresses:
289      *
290      *  - an externally-owned account
291      *  - a contract in construction
292      *  - an address where a contract will be created
293      *  - an address where a contract lived, but was destroyed
294      * ====
295      */
296     function isContract(address account) internal view returns (bool) {
297         // This method relies on extcodesize, which returns 0 for contracts in
298         // construction, since the code is only stored at the end of the
299         // constructor execution.
300 
301         uint256 size;
302         // solhint-disable-next-line no-inline-assembly
303         assembly { size := extcodesize(account) }
304         return size > 0;
305     }
306 
307     /**
308      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
309      * `recipient`, forwarding all available gas and reverting on errors.
310      *
311      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
312      * of certain opcodes, possibly making contracts go over the 2300 gas limit
313      * imposed by `transfer`, making them unable to receive funds via
314      * `transfer`. {sendValue} removes this limitation.
315      *
316      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
317      *
318      * IMPORTANT: because control is transferred to `recipient`, care must be
319      * taken to not create reentrancy vulnerabilities. Consider using
320      * {ReentrancyGuard} or the
321      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
322      */
323     function sendValue(address payable recipient, uint256 amount) internal {
324         require(address(this).balance >= amount, "Address: insufficient balance");
325 
326         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
327         (bool success, ) = recipient.call{ value: amount }("");
328         require(success, "Address: unable to send value, recipient may have reverted");
329     }
330 
331     /**
332      * @dev Performs a Solidity function call using a low level `call`. A
333      * plain`call` is an unsafe replacement for a function call: use this
334      * function instead.
335      *
336      * If `target` reverts with a revert reason, it is bubbled up by this
337      * function (like regular Solidity function calls).
338      *
339      * Returns the raw returned data. To convert to the expected return value,
340      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
341      *
342      * Requirements:
343      *
344      * - `target` must be a contract.
345      * - calling `target` with `data` must not revert.
346      *
347      * _Available since v3.1._
348      */
349     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
350       return functionCall(target, data, "Address: low-level call failed");
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
355      * `errorMessage` as a fallback revert reason when `target` reverts.
356      *
357      * _Available since v3.1._
358      */
359     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
360         return functionCallWithValue(target, data, 0, errorMessage);
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
365      * but also transferring `value` wei to `target`.
366      *
367      * Requirements:
368      *
369      * - the calling contract must have an ETH balance of at least `value`.
370      * - the called Solidity function must be `payable`.
371      *
372      * _Available since v3.1._
373      */
374     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
375         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
380      * with `errorMessage` as a fallback revert reason when `target` reverts.
381      *
382      * _Available since v3.1._
383      */
384     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
385         require(address(this).balance >= value, "Address: insufficient balance for call");
386         require(isContract(target), "Address: call to non-contract");
387 
388         // solhint-disable-next-line avoid-low-level-calls
389         (bool success, bytes memory returndata) = target.call{ value: value }(data);
390         return _verifyCallResult(success, returndata, errorMessage);
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
395      * but performing a static call.
396      *
397      * _Available since v3.3._
398      */
399     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
400         return functionStaticCall(target, data, "Address: low-level static call failed");
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
405      * but performing a static call.
406      *
407      * _Available since v3.3._
408      */
409     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
410         require(isContract(target), "Address: static call to non-contract");
411 
412         // solhint-disable-next-line avoid-low-level-calls
413         (bool success, bytes memory returndata) = target.staticcall(data);
414         return _verifyCallResult(success, returndata, errorMessage);
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
419      * but performing a delegate call.
420      *
421      * _Available since v3.4._
422      */
423     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
424         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
429      * but performing a delegate call.
430      *
431      * _Available since v3.4._
432      */
433     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
434         require(isContract(target), "Address: delegate call to non-contract");
435 
436         // solhint-disable-next-line avoid-low-level-calls
437         (bool success, bytes memory returndata) = target.delegatecall(data);
438         return _verifyCallResult(success, returndata, errorMessage);
439     }
440 
441     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
442         if (success) {
443             return returndata;
444         } else {
445             // Look for revert reason and bubble it up if present
446             if (returndata.length > 0) {
447                 // The easiest way to bubble the revert reason is using memory via assembly
448 
449                 // solhint-disable-next-line no-inline-assembly
450                 assembly {
451                     let returndata_size := mload(returndata)
452                     revert(add(32, returndata), returndata_size)
453                 }
454             } else {
455                 revert(errorMessage);
456             }
457         }
458     }
459 }
460 
461 
462 pragma solidity ^0.8.0;
463 
464 /**
465  * @dev Contract module which provides a basic access control mechanism, where
466  * there is an account (an owner) that can be granted exclusive access to
467  * specific functions.
468  *
469  * By default, the owner account will be the one that deploys the contract. This
470  * can later be changed with {transferOwnership}.
471  *
472  * This module is used through inheritance. It will make available the modifier
473  * `onlyOwner`, which can be applied to your functions to restrict their use to
474  * the owner.
475  */
476 abstract contract Ownable is Context {
477     address private _owner;
478 
479     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
480 
481     /**
482      * @dev Initializes the contract setting the deployer as the initial owner.
483      */
484     constructor () {
485         address msgSender = _msgSender();
486         _owner = msgSender;
487         emit OwnershipTransferred(address(0), msgSender);
488     }
489 
490     /**
491      * @dev Returns the address of the current owner.
492      */
493     function owner() public view virtual returns (address) {
494         return _owner;
495     }
496 
497     /**
498      * @dev Throws if called by any account other than the owner.
499      */
500     modifier onlyOwner() {
501         require(owner() == _msgSender(), "Ownable: caller is not the owner");
502         _;
503     }
504 
505     /**
506      * @dev Leaves the contract without owner. It will not be possible to call
507      * `onlyOwner` functions anymore. Can only be called by the current owner.
508      *
509      * NOTE: Renouncing ownership will leave the contract without an owner,
510      * thereby removing any functionality that is only available to the owner.
511      */
512     function renounceOwnership() public virtual onlyOwner {
513         emit OwnershipTransferred(_owner, address(0));
514         _owner = address(0);
515     }
516 
517     /**
518      * @dev Transfers ownership of the contract to a new account (`newOwner`).
519      * Can only be called by the current owner.
520      */
521     function transferOwnership(address newOwner) public virtual onlyOwner {
522         require(newOwner != address(0), "Ownable: new owner is the zero address");
523         emit OwnershipTransferred(_owner, newOwner);
524         _owner = newOwner;
525     }
526 }
527 
528 pragma solidity ^0.8.0;
529 
530 /**
531  * @dev Contract module that helps prevent reentrant calls to a function.
532  *
533  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
534  * available, which can be applied to functions to make sure there are no nested
535  * (reentrant) calls to them.
536  *
537  * Note that because there is a single `nonReentrant` guard, functions marked as
538  * `nonReentrant` may not call one another. This can be worked around by making
539  * those functions `private`, and then adding `external` `nonReentrant` entry
540  * points to them.
541  *
542  * TIP: If you would like to learn more about reentrancy and alternative ways
543  * to protect against it, check out our blog post
544  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
545  */
546 abstract contract ReentrancyGuard {
547     // Booleans are more expensive than uint256 or any type that takes up a full
548     // word because each write operation emits an extra SLOAD to first read the
549     // slot's contents, replace the bits taken up by the boolean, and then write
550     // back. This is the compiler's defense against contract upgrades and
551     // pointer aliasing, and it cannot be disabled.
552 
553     // The values being non-zero value makes deployment a bit more expensive,
554     // but in exchange the refund on every call to nonReentrant will be lower in
555     // amount. Since refunds are capped to a percentage of the total
556     // transaction's gas, it is best to keep them low in cases like this one, to
557     // increase the likelihood of the full refund coming into effect.
558     uint256 private constant _NOT_ENTERED = 1;
559     uint256 private constant _ENTERED = 2;
560 
561     uint256 private _status;
562 
563     constructor () {
564         _status = _NOT_ENTERED;
565     }
566 
567     /**
568      * @dev Prevents a contract from calling itself, directly or indirectly.
569      * Calling a `nonReentrant` function from another `nonReentrant`
570      * function is not supported. It is possible to prevent this from happening
571      * by making the `nonReentrant` function external, and make it call a
572      * `private` function that does the actual work.
573      */
574     modifier nonReentrant() {
575         // On the first call to nonReentrant, _notEntered will be true
576         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
577 
578         // Any calls to nonReentrant after this point will fail
579         _status = _ENTERED;
580 
581         _;
582 
583         // By storing the original value once again, a refund is triggered (see
584         // https://eips.ethereum.org/EIPS/eip-2200)
585         _status = _NOT_ENTERED;
586     }
587 }
588 
589 pragma solidity ^0.8.0;
590 
591 /**
592  * @title Counters
593  * @author Matt Condon (@shrugs)
594  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
595  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
596  *
597  * Include with `using Counters for Counters.Counter;`
598  */
599 library Counters {
600     struct Counter {
601         // This variable should never be directly accessed by users of the library: interactions must be restricted to
602         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
603         // this feature: see https://github.com/ethereum/solidity/issues/4637
604         uint256 _value; // default: 0
605     }
606 
607     function current(Counter storage counter) internal view returns (uint256) {
608         return counter._value;
609     }
610 
611     function increment(Counter storage counter) internal {
612         unchecked {
613             counter._value += 1;
614         }
615     }
616 
617     function decrement(Counter storage counter) internal {
618         uint256 value = counter._value;
619         require(value > 0, "Counter: decrement overflow");
620         unchecked {
621             counter._value = value - 1;
622         }
623     }
624 }
625 
626 pragma solidity ^0.8.0;
627 
628 /**
629  * @dev String operations.
630  */
631 library Strings {
632     bytes16 private constant alphabet = "0123456789abcdef";
633 
634     /**
635      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
636      */
637     function toString(uint256 value) internal pure returns (string memory) {
638         // Inspired by OraclizeAPI's implementation - MIT licence
639         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
640 
641         if (value == 0) {
642             return "0";
643         }
644         uint256 temp = value;
645         uint256 digits;
646         while (temp != 0) {
647             digits++;
648             temp /= 10;
649         }
650         bytes memory buffer = new bytes(digits);
651         while (value != 0) {
652             digits -= 1;
653             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
654             value /= 10;
655         }
656         return string(buffer);
657     }
658 
659     /**
660      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
661      */
662     function toHexString(uint256 value) internal pure returns (string memory) {
663         if (value == 0) {
664             return "0x00";
665         }
666         uint256 temp = value;
667         uint256 length = 0;
668         while (temp != 0) {
669             length++;
670             temp >>= 8;
671         }
672         return toHexString(value, length);
673     }
674 
675     /**
676      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
677      */
678     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
679         bytes memory buffer = new bytes(2 * length + 2);
680         buffer[0] = "0";
681         buffer[1] = "x";
682         for (uint256 i = 2 * length + 1; i > 1; --i) {
683             buffer[i] = alphabet[value & 0xf];
684             value >>= 4;
685         }
686         require(value == 0, "Strings: hex length insufficient");
687         return string(buffer);
688     }
689 
690 }
691 
692 
693 pragma solidity ^0.8.0;
694 
695 /**
696  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
697  * the Metadata extension, but not including the Enumerable extension, which is available separately as
698  * {ERC721Enumerable}.
699  */
700 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
701     using Address for address;
702     using Strings for uint256;
703 
704     // Token name
705     string private _name;
706 
707     // Token symbol
708     string private _symbol;
709 
710     // Mapping from token ID to owner address
711     mapping (uint256 => address) private _owners;
712 
713     // Mapping owner address to token count
714     mapping (address => uint256) private _balances;
715 
716     // Mapping from token ID to approved address
717     mapping (uint256 => address) private _tokenApprovals;
718 
719     // Mapping from owner to operator approvals
720     mapping (address => mapping (address => bool)) private _operatorApprovals;
721 
722     /**
723      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
724      */
725     constructor (string memory name_, string memory symbol_) {
726         _name = name_;
727         _symbol = symbol_;
728     }
729 
730     /**
731      * @dev See {IERC165-supportsInterface}.
732      */
733     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
734         return interfaceId == type(IERC721).interfaceId
735             || interfaceId == type(IERC721Metadata).interfaceId
736             || super.supportsInterface(interfaceId);
737     }
738 
739     /**
740      * @dev See {IERC721-balanceOf}.
741      */
742     function balanceOf(address owner) public view virtual override returns (uint256) {
743         require(owner != address(0), "ERC721: balance query for the zero address");
744         return _balances[owner];
745     }
746 
747     /**
748      * @dev See {IERC721-ownerOf}.
749      */
750     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
751         address owner = _owners[tokenId];
752         require(owner != address(0), "ERC721: owner query for nonexistent token");
753         return owner;
754     }
755 
756     /**
757      * @dev See {IERC721Metadata-name}.
758      */
759     function name() public view virtual override returns (string memory) {
760         return _name;
761     }
762 
763     /**
764      * @dev See {IERC721Metadata-symbol}.
765      */
766     function symbol() public view virtual override returns (string memory) {
767         return _symbol;
768     }
769 
770     /**
771      * @dev See {IERC721Metadata-tokenURI}.
772      */
773     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
774         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
775 
776         string memory baseURI = _baseURI();
777         return bytes(baseURI).length > 0
778             ? string(abi.encodePacked(baseURI, tokenId.toString()))
779             : '';
780     }
781 
782     /**
783      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
784      * in child contracts.
785      */
786     function _baseURI() internal view virtual returns (string memory) {
787         return "";
788     }
789 
790     /**
791      * @dev See {IERC721-approve}.
792      */
793     function approve(address to, uint256 tokenId) public virtual override {
794         address owner = ERC721.ownerOf(tokenId);
795         require(to != owner, "ERC721: approval to current owner");
796 
797         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()),
798             "ERC721: approve caller is not owner nor approved for all"
799         );
800 
801         _approve(to, tokenId);
802     }
803 
804     /**
805      * @dev See {IERC721-getApproved}.
806      */
807     function getApproved(uint256 tokenId) public view virtual override returns (address) {
808         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
809 
810         return _tokenApprovals[tokenId];
811     }
812 
813     /**
814      * @dev See {IERC721-setApprovalForAll}.
815      */
816     function setApprovalForAll(address operator, bool approved) public virtual override {
817         require(operator != _msgSender(), "ERC721: approve to caller");
818 
819         _operatorApprovals[_msgSender()][operator] = approved;
820         emit ApprovalForAll(_msgSender(), operator, approved);
821     }
822 
823     /**
824      * @dev See {IERC721-isApprovedForAll}.
825      */
826     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
827         return _operatorApprovals[owner][operator];
828     }
829 
830     /**
831      * @dev See {IERC721-transferFrom}.
832      */
833     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
834         //solhint-disable-next-line max-line-length
835         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
836 
837         _transfer(from, to, tokenId);
838     }
839 
840     /**
841      * @dev See {IERC721-safeTransferFrom}.
842      */
843     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
844         safeTransferFrom(from, to, tokenId, "");
845     }
846 
847     /**
848      * @dev See {IERC721-safeTransferFrom}.
849      */
850     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
851         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
852         _safeTransfer(from, to, tokenId, _data);
853     }
854 
855     /**
856      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
857      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
858      *
859      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
860      *
861      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
862      * implement alternative mechanisms to perform token transfer, such as signature-based.
863      *
864      * Requirements:
865      *
866      * - `from` cannot be the zero address.
867      * - `to` cannot be the zero address.
868      * - `tokenId` token must exist and be owned by `from`.
869      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
870      *
871      * Emits a {Transfer} event.
872      */
873     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
874         _transfer(from, to, tokenId);
875         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
876     }
877 
878     /**
879      * @dev Returns whether `tokenId` exists.
880      *
881      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
882      *
883      * Tokens start existing when they are minted (`_mint`),
884      * and stop existing when they are burned (`_burn`).
885      */
886     function _exists(uint256 tokenId) internal view virtual returns (bool) {
887         return _owners[tokenId] != address(0);
888     }
889 
890     /**
891      * @dev Returns whether `spender` is allowed to manage `tokenId`.
892      *
893      * Requirements:
894      *
895      * - `tokenId` must exist.
896      */
897     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
898         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
899         address owner = ERC721.ownerOf(tokenId);
900         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
901     }
902 
903     /**
904      * @dev Safely mints `tokenId` and transfers it to `to`.
905      *
906      * Requirements:
907      *
908      * - `tokenId` must not exist.
909      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
910      *
911      * Emits a {Transfer} event.
912      */
913     function _safeMint(address to, uint256 tokenId) internal virtual {
914         _safeMint(to, tokenId, "");
915     }
916 
917     /**
918      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
919      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
920      */
921     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
922         _mint(to, tokenId);
923         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
924     }
925 
926     /**
927      * @dev Mints `tokenId` and transfers it to `to`.
928      *
929      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
930      *
931      * Requirements:
932      *
933      * - `tokenId` must not exist.
934      * - `to` cannot be the zero address.
935      *
936      * Emits a {Transfer} event.
937      */
938     function _mint(address to, uint256 tokenId) internal virtual {
939         require(to != address(0), "ERC721: mint to the zero address");
940         require(!_exists(tokenId), "ERC721: token already minted");
941 
942         _beforeTokenTransfer(address(0), to, tokenId);
943 
944         _balances[to] += 1;
945         _owners[tokenId] = to;
946 
947         emit Transfer(address(0), to, tokenId);
948     }
949 
950     /**
951      * @dev Destroys `tokenId`.
952      * The approval is cleared when the token is burned.
953      *
954      * Requirements:
955      *
956      * - `tokenId` must exist.
957      *
958      * Emits a {Transfer} event.
959      */
960     function _burn(uint256 tokenId) internal virtual {
961         address owner = ERC721.ownerOf(tokenId);
962 
963         _beforeTokenTransfer(owner, address(0), tokenId);
964 
965         // Clear approvals
966         _approve(address(0), tokenId);
967 
968         _balances[owner] -= 1;
969         delete _owners[tokenId];
970 
971         emit Transfer(owner, address(0), tokenId);
972     }
973 
974     /**
975      * @dev Transfers `tokenId` from `from` to `to`.
976      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
977      *
978      * Requirements:
979      *
980      * - `to` cannot be the zero address.
981      * - `tokenId` token must be owned by `from`.
982      *
983      * Emits a {Transfer} event.
984      */
985     function _transfer(address from, address to, uint256 tokenId) internal virtual {
986         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
987         require(to != address(0), "ERC721: transfer to the zero address");
988 
989         _beforeTokenTransfer(from, to, tokenId);
990 
991         // Clear approvals from the previous owner
992         _approve(address(0), tokenId);
993 
994         _balances[from] -= 1;
995         _balances[to] += 1;
996         _owners[tokenId] = to;
997 
998         emit Transfer(from, to, tokenId);
999     }
1000 
1001     /**
1002      * @dev Approve `to` to operate on `tokenId`
1003      *
1004      * Emits a {Approval} event.
1005      */
1006     function _approve(address to, uint256 tokenId) internal virtual {
1007         _tokenApprovals[tokenId] = to;
1008         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1009     }
1010 
1011     /**
1012      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1013      * The call is not executed if the target address is not a contract.
1014      *
1015      * @param from address representing the previous owner of the given token ID
1016      * @param to target address that will receive the tokens
1017      * @param tokenId uint256 ID of the token to be transferred
1018      * @param _data bytes optional data to send along with the call
1019      * @return bool whether the call correctly returned the expected magic value
1020      */
1021     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1022         private returns (bool)
1023     {
1024         if (to.isContract()) {
1025             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1026                 return retval == IERC721Receiver(to).onERC721Received.selector;
1027             } catch (bytes memory reason) {
1028                 if (reason.length == 0) {
1029                     revert("ERC721: transfer to non ERC721Receiver implementer");
1030                 } else {
1031                     // solhint-disable-next-line no-inline-assembly
1032                     assembly {
1033                         revert(add(32, reason), mload(reason))
1034                     }
1035                 }
1036             }
1037         } else {
1038             return true;
1039         }
1040     }
1041     /**
1042      * @dev Hook that is called before any token transfer. This includes minting
1043      * and burning.
1044      *
1045      * Calling conditions:
1046      *
1047      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1048      * transferred to `to`.
1049      * - When `from` is zero, `tokenId` will be minted for `to`.
1050      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1051      * - `from` cannot be the zero address.
1052      * - `to` cannot be the zero address.
1053      *
1054      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1055      */
1056     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1057 }
1058 
1059 pragma solidity ^0.8.0;
1060 
1061 /**
1062  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1063  * enumerability of all the token ids in the contract as well as all token ids owned by each
1064  * account.
1065  */
1066  // <3
1067 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1068     // Mapping from owner to list of owned token IDs
1069     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1070 
1071     // Mapping from token ID to index of the owner tokens list
1072     mapping(uint256 => uint256) private _ownedTokensIndex;
1073 
1074     // Array with all token ids, used for enumeration
1075     uint256[] private _allTokens;
1076 
1077     // Mapping from token id to position in the allTokens array
1078     mapping(uint256 => uint256) private _allTokensIndex;
1079 
1080     /**
1081      * @dev See {IERC165-supportsInterface}.
1082      */
1083     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1084         return interfaceId == type(IERC721Enumerable).interfaceId
1085             || super.supportsInterface(interfaceId);
1086     }
1087 
1088     /**
1089      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1090      */
1091     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1092         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1093         return _ownedTokens[owner][index];
1094     }
1095 
1096     /**
1097      * @dev See {IERC721Enumerable-totalSupply}.
1098      */
1099     function totalSupply() public view virtual override returns (uint256) {
1100         return _allTokens.length;
1101     }
1102 
1103     /**
1104      * @dev See {IERC721Enumerable-tokenByIndex}.
1105      */
1106     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1107         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1108         return _allTokens[index];
1109     }
1110 
1111     /**
1112      * @dev Hook that is called before any token transfer. This includes minting
1113      * and burning.
1114      *
1115      * Calling conditions:
1116      *
1117      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1118      * transferred to `to`.
1119      * - When `from` is zero, `tokenId` will be minted for `to`.
1120      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1121      * - `from` cannot be the zero address.
1122      * - `to` cannot be the zero address.
1123      *
1124      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1125      */
1126     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual override {
1127         super._beforeTokenTransfer(from, to, tokenId);
1128 
1129         if (from == address(0)) {
1130             _addTokenToAllTokensEnumeration(tokenId);
1131         } else if (from != to) {
1132             _removeTokenFromOwnerEnumeration(from, tokenId);
1133         }
1134         if (to == address(0)) {
1135             _removeTokenFromAllTokensEnumeration(tokenId);
1136         } else if (to != from) {
1137             _addTokenToOwnerEnumeration(to, tokenId);
1138         }
1139     }
1140 
1141     /**
1142      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1143      * @param to address representing the new owner of the given token ID
1144      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1145      */
1146     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1147         uint256 length = ERC721.balanceOf(to);
1148         _ownedTokens[to][length] = tokenId;
1149         _ownedTokensIndex[tokenId] = length;
1150     }
1151 
1152     /**
1153      * @dev Private function to add a token to this extension's token tracking data structures.
1154      * @param tokenId uint256 ID of the token to be added to the tokens list
1155      */
1156     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1157         _allTokensIndex[tokenId] = _allTokens.length;
1158         _allTokens.push(tokenId);
1159     }
1160 
1161     /**
1162      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1163      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1164      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1165      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1166      * @param from address representing the previous owner of the given token ID
1167      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1168      */
1169     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1170         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1171         // then delete the last slot (swap and pop).
1172 
1173         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1174         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1175 
1176         // When the token to delete is the last token, the swap operation is unnecessary
1177         if (tokenIndex != lastTokenIndex) {
1178             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1179 
1180             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1181             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1182         }
1183 
1184         // This also deletes the contents at the last position of the array
1185         delete _ownedTokensIndex[tokenId];
1186         delete _ownedTokens[from][lastTokenIndex];
1187     }
1188 
1189     /**
1190      * @dev Private function to remove a token from this extension's token tracking data structures.
1191      * This has O(1) time complexity, but alters the order of the _allTokens array.
1192      * @param tokenId uint256 ID of the token to be removed from the tokens list
1193      */
1194     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1195         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1196         // then delete the last slot (swap and pop).
1197 
1198         uint256 lastTokenIndex = _allTokens.length - 1;
1199         uint256 tokenIndex = _allTokensIndex[tokenId];
1200 
1201         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1202         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1203         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1204         uint256 lastTokenId = _allTokens[lastTokenIndex];
1205 
1206         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1207         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1208 
1209         // This also deletes the contents at the last position of the array
1210         delete _allTokensIndex[tokenId];
1211         _allTokens.pop();
1212     }
1213 }
1214 
1215 
1216 
1217 
1218 
1219 
1220 
1221 
1222 // WELCOME TO COVIDBots, the exclusive, limited edition NFT series airdropped to COVIDPunks fans who experienced the dreaded
1223 // "out-of-gas" error during our launch. COVIDBots are a cryptographically unique and highly scarce collection that will
1224 // never be available for minting by anyone. Thank you for your patience on this airdrop. We are so grateful for our 
1225 // lovely, enthusiastic community! May Gill Bates save us all. :-) 
1226 //   -Waddle, Waggle, and Liu
1227 
1228 
1229 pragma solidity ^0.8.0;
1230 
1231 contract COVIDBots is Ownable, ERC721Enumerable, ReentrancyGuard {
1232   using Counters for Counters.Counter;
1233   using Strings for uint256;
1234 
1235   string public imageHash;
1236 
1237   uint256 public constant MAX_MINTABLE_AT_ONCE = 20;
1238   
1239   string public botcontractURI;
1240   
1241   constructor() ERC721("COVIDBots", "BOT-19") {}
1242 
1243   uint256[3884] private _availableTokens;
1244 
1245   uint256 private _numAvailableTokens = 3884;
1246 
1247   uint256 private _lastTokenIdMintedInInitialSet = 3884;
1248 
1249   function numTotalBots() public view virtual returns (uint256) {
1250     return 3884;
1251   }
1252 
1253   // function to mint and send airdrop
1254   function airdropMint(address receiver, uint256 numRolls) public onlyOwner {
1255     require(numRolls < 21, "You should not mint more than 20 at a time.");
1256     uint256 toMint = numRolls;
1257     _mint(toMint, receiver); 
1258   }
1259 
1260   // internal minting function
1261   function _mint(uint256 _numToMint, address receiver) internal {
1262     require(_numToMint <= MAX_MINTABLE_AT_ONCE, "Minting too many at once.");
1263 
1264     uint256 updatedNumAvailableTokens = _numAvailableTokens;
1265     for (uint256 i = 0; i < _numToMint; i++) {
1266       uint256 newTokenId = useRandomAvailableToken(_numToMint, i);
1267       _safeMint(receiver, newTokenId);
1268       updatedNumAvailableTokens--;
1269     }
1270     _numAvailableTokens = updatedNumAvailableTokens;
1271   }
1272 
1273   function useRandomAvailableToken(uint256 _numToFetch, uint256 _i)
1274     internal
1275     returns (uint256)
1276   {
1277     uint256 randomNum =
1278       uint256(
1279         keccak256(
1280           abi.encode(
1281             msg.sender,
1282             tx.gasprice,
1283             block.number,
1284             block.timestamp,
1285             blockhash(block.number - 1),
1286             _numToFetch,
1287             _i
1288           )
1289         )
1290       );
1291     uint256 randomIndex = randomNum % _numAvailableTokens;
1292     return useAvailableTokenAtIndex(randomIndex);
1293   }
1294 
1295   function useAvailableTokenAtIndex(uint256 indexToUse)
1296     internal
1297     returns (uint256)
1298   {
1299     uint256 valAtIndex = _availableTokens[indexToUse];
1300     uint256 result;
1301     if (valAtIndex == 0) {
1302       // This means the index itself is still an available token
1303       result = indexToUse;
1304     } else {
1305       // This means the index itself is not an available token, but the val at that index is.
1306       result = valAtIndex;
1307     }
1308 
1309     uint256 lastIndex = _numAvailableTokens - 1;
1310     if (indexToUse != lastIndex) {
1311       // Replace the value at indexToUse, now that it's been used.
1312       // Replace it with the data from the last index in the array, since we are going to decrease the array size afterwards.
1313       uint256 lastValInArray = _availableTokens[lastIndex];
1314       if (lastValInArray == 0) {
1315         // This means the index itself is still an available token
1316         _availableTokens[indexToUse] = lastIndex;
1317       } else {
1318         // This means the index itself is not an available token, but the val at that index is.
1319         _availableTokens[indexToUse] = lastValInArray;
1320       }
1321     }
1322 
1323     _numAvailableTokens--;
1324     return result;
1325   }
1326 
1327   function contractURI() public view returns (string memory){
1328     return botcontractURI;
1329   }
1330 
1331   function getBotsBelongingToOwner(address _owner)
1332     external
1333     view
1334     returns (uint256[] memory)
1335   {
1336     uint256 numBots = balanceOf(_owner);
1337     if (numBots == 0) {
1338       return new uint256[](0);
1339     } else {
1340       uint256[] memory result = new uint256[](numBots);
1341       for (uint256 i = 0; i < numBots; i++) {
1342         result[i] = tokenOfOwnerByIndex(_owner, i);
1343       }
1344       return result;
1345     }
1346   }
1347 
1348   /*
1349    * Dev stuff.
1350    */
1351 
1352   // metadata URI
1353   string private _baseTokenURI;
1354 
1355   function _baseURI() internal view virtual override returns (string memory) {
1356     return _baseTokenURI;
1357   }
1358 
1359   function tokenURI(uint256 _tokenId)
1360     public
1361     view
1362     override
1363     returns (string memory)
1364   {
1365     string memory base = _baseURI();
1366     string memory _tokenURI = Strings.toString(_tokenId);
1367     string memory ending = ".json";
1368 
1369     // If there is no base URI, return the token URI.
1370     if (bytes(base).length == 0) {
1371       return _tokenURI;
1372     }
1373 
1374     return string(abi.encodePacked(base, _tokenURI, ending));
1375   }
1376   
1377 
1378   /*
1379    * Owner stuff
1380    */
1381 
1382 
1383   // URIs
1384   function setBaseURI(string memory baseURI) external onlyOwner {
1385     _baseTokenURI = baseURI;
1386   }
1387 
1388   function setContractURI(string memory _contractURI) external onlyOwner {
1389     botcontractURI = _contractURI;
1390   }
1391   
1392     function setImageHash(string memory _imageHash) external onlyOwner {
1393     imageHash = _imageHash;
1394   }
1395   
1396     function withdraw() public onlyOwner {
1397     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1398     require(success, "Transfer failed.");
1399   }
1400 
1401   function _beforeTokenTransfer(
1402     address from,
1403     address to,
1404     uint256 tokenId
1405   ) internal virtual override(ERC721Enumerable) {
1406     super._beforeTokenTransfer(from, to, tokenId);
1407   }
1408 
1409   function supportsInterface(bytes4 interfaceId)
1410     public
1411     view
1412     virtual
1413     override(ERC721Enumerable)
1414     returns (bool)
1415   {
1416     return super.supportsInterface(interfaceId);
1417   }
1418 }
1419 //xoxo