1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 // File: @openzeppelin/contracts/utils/Context.sol
6 
7 pragma solidity ^0.8.0;
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 pragma solidity ^0.8.0;
30 
31 /**
32  * @dev Contract module that helps prevent reentrant calls to a function.
33  *
34  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
35  * available, which can be applied to functions to make sure there are no nested
36  * (reentrant) calls to them.
37  *
38  * Note that because there is a single `nonReentrant` guard, functions marked as
39  * `nonReentrant` may not call one another. This can be worked around by making
40  * those functions `private`, and then adding `external` `nonReentrant` entry
41  * points to them.
42  *
43  * TIP: If you would like to learn more about reentrancy and alternative ways
44  * to protect against it, check out our blog post
45  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
46  */
47 abstract contract ReentrancyGuard {
48     // Booleans are more expensive than uint256 or any type that takes up a full
49     // word because each write operation emits an extra SLOAD to first read the
50     // slot's contents, replace the bits taken up by the boolean, and then write
51     // back. This is the compiler's defense against contract upgrades and
52     // pointer aliasing, and it cannot be disabled.
53 
54     // The values being non-zero value makes deployment a bit more expensive,
55     // but in exchange the refund on every call to nonReentrant will be lower in
56     // amount. Since refunds are capped to a percentage of the total
57     // transaction's gas, it is best to keep them low in cases like this one, to
58     // increase the likelihood of the full refund coming into effect.
59     uint256 private constant _NOT_ENTERED = 1;
60     uint256 private constant _ENTERED = 2;
61 
62     uint256 private _status;
63 
64     constructor() {
65         _status = _NOT_ENTERED;
66     }
67 
68     /**
69      * @dev Prevents a contract from calling itself, directly or indirectly.
70      * Calling a `nonReentrant` function from another `nonReentrant`
71      * function is not supported. It is possible to prevent this from happening
72      * by making the `nonReentrant` function external, and make it call a
73      * `private` function that does the actual work.
74      */
75     modifier nonReentrant() {
76         // On the first call to nonReentrant, _notEntered will be true
77         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
78 
79         // Any calls to nonReentrant after this point will fail
80         _status = _ENTERED;
81 
82         _;
83 
84         // By storing the original value once again, a refund is triggered (see
85         // https://eips.ethereum.org/EIPS/eip-2200)
86         _status = _NOT_ENTERED;
87     }
88 }
89 
90 // File: @openzeppelin/contracts/access/Ownable.sol
91 
92 pragma solidity ^0.8.0;
93 
94 
95 /**
96  * @dev Contract module which provides a basic access control mechanism, where
97  * there is an account (an owner) that can be granted exclusive access to
98  * specific functions.
99  *
100  * By default, the owner account will be the one that deploys the contract. This
101  * can later be changed with {transferOwnership}.
102  *
103  * This module is used through inheritance. It will make available the modifier
104  * `onlyOwner`, which can be applied to your functions to restrict their use to
105  * the owner.
106  */
107 abstract contract Ownable is Context {
108     address private _owner;
109 
110     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
111 
112     /**
113      * @dev Initializes the contract setting the deployer as the initial owner.
114      */
115     constructor() {
116         _setOwner(_msgSender());
117     }
118 
119     /**
120      * @dev Returns the address of the current owner.
121      */
122     function owner() public view virtual returns (address) {
123         return _owner;
124     }
125 
126     /**
127      * @dev Throws if called by any account other than the owner.
128      */
129     modifier onlyOwner() {
130         require(owner() == _msgSender(), "Ownable: caller is not the owner");
131         _;
132     }
133 
134     /**
135      * @dev Leaves the contract without owner. It will not be possible to call
136      * `onlyOwner` functions anymore. Can only be called by the current owner.
137      *
138      * NOTE: Renouncing ownership will leave the contract without an owner,
139      * thereby removing any functionality that is only available to the owner.
140      */
141     function renounceOwnership() public virtual onlyOwner {
142         _setOwner(address(0));
143     }
144 
145     /**
146      * @dev Transfers ownership of the contract to a new account (`newOwner`).
147      * Can only be called by the current owner.
148      */
149     function transferOwnership(address newOwner) public virtual onlyOwner {
150         require(newOwner != address(0), "Ownable: new owner is the zero address");
151         _setOwner(newOwner);
152     }
153 
154     function _setOwner(address newOwner) private {
155         address oldOwner = _owner;
156         _owner = newOwner;
157         emit OwnershipTransferred(oldOwner, newOwner);
158     }
159 }
160 
161 // File: @openzeppelin/contracts/utils/Counters.sol
162 
163 pragma solidity ^0.8.0;
164 
165 /**
166  * @title Counters
167  * @author Matt Condon (@shrugs)
168  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
169  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
170  *
171  * Include with `using Counters for Counters.Counter;`
172  */
173 library Counters {
174     struct Counter {
175         // This variable should never be directly accessed by users of the library: interactions must be restricted to
176         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
177         // this feature: see https://github.com/ethereum/solidity/issues/4637
178         uint256 _value; // default: 0
179     }
180 
181     function current(Counter storage counter) internal view returns (uint256) {
182         return counter._value;
183     }
184 
185     function increment(Counter storage counter) internal {
186         unchecked {
187             counter._value += 1;
188         }
189     }
190 
191     function decrement(Counter storage counter) internal {
192         uint256 value = counter._value;
193         require(value > 0, "Counter: decrement overflow");
194         unchecked {
195             counter._value = value - 1;
196         }
197     }
198 
199     function reset(Counter storage counter) internal {
200         counter._value = 0;
201     }
202 }
203 
204 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
205 
206 pragma solidity ^0.8.0;
207 
208 /**
209  * @dev Interface of the ERC165 standard, as defined in the
210  * https://eips.ethereum.org/EIPS/eip-165[EIP].
211  *
212  * Implementers can declare support of contract interfaces, which can then be
213  * queried by others ({ERC165Checker}).
214  *
215  * For an implementation, see {ERC165}.
216  */
217 interface IERC165 {
218     /**
219      * @dev Returns true if this contract implements the interface defined by
220      * `interfaceId`. See the corresponding
221      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
222      * to learn more about how these ids are created.
223      *
224      * This function call must use less than 30 000 gas.
225      */
226     function supportsInterface(bytes4 interfaceId) external view returns (bool);
227 }
228 
229 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
230 
231 pragma solidity ^0.8.0;
232 
233 
234 /**
235  * @dev Implementation of the {IERC165} interface.
236  *
237  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
238  * for the additional interface id that will be supported. For example:
239  *
240  * ```solidity
241  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
242  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
243  * }
244  * ```
245  *
246  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
247  */
248 abstract contract ERC165 is IERC165 {
249     /**
250      * @dev See {IERC165-supportsInterface}.
251      */
252     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
253         return interfaceId == type(IERC165).interfaceId;
254     }
255 }
256 
257 // File: @openzeppelin/contracts/utils/Strings.sol
258 
259 pragma solidity ^0.8.0;
260 
261 /**
262  * @dev String operations.
263  */
264 library Strings {
265     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
266 
267     /**
268      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
269      */
270     function toString(uint256 value) internal pure returns (string memory) {
271         // Inspired by OraclizeAPI's implementation - MIT licence
272         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
273 
274         if (value == 0) {
275             return "0";
276         }
277         uint256 temp = value;
278         uint256 digits;
279         while (temp != 0) {
280             digits++;
281             temp /= 10;
282         }
283         bytes memory buffer = new bytes(digits);
284         while (value != 0) {
285             digits -= 1;
286             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
287             value /= 10;
288         }
289         return string(buffer);
290     }
291 
292     /**
293      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
294      */
295     function toHexString(uint256 value) internal pure returns (string memory) {
296         if (value == 0) {
297             return "0x00";
298         }
299         uint256 temp = value;
300         uint256 length = 0;
301         while (temp != 0) {
302             length++;
303             temp >>= 8;
304         }
305         return toHexString(value, length);
306     }
307 
308     /**
309      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
310      */
311     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
312         bytes memory buffer = new bytes(2 * length + 2);
313         buffer[0] = "0";
314         buffer[1] = "x";
315         for (uint256 i = 2 * length + 1; i > 1; --i) {
316             buffer[i] = _HEX_SYMBOLS[value & 0xf];
317             value >>= 4;
318         }
319         require(value == 0, "Strings: hex length insufficient");
320         return string(buffer);
321     }
322 }
323 
324 // File: @openzeppelin/contracts/utils/Address.sol
325 
326 pragma solidity ^0.8.0;
327 
328 /**
329  * @dev Collection of functions related to the address type
330  */
331 library Address {
332     /**
333      * @dev Returns true if `account` is a contract.
334      *
335      * [IMPORTANT]
336      * ====
337      * It is unsafe to assume that an address for which this function returns
338      * false is an externally-owned account (EOA) and not a contract.
339      *
340      * Among others, `isContract` will return false for the following
341      * types of addresses:
342      *
343      *  - an externally-owned account
344      *  - a contract in construction
345      *  - an address where a contract will be created
346      *  - an address where a contract lived, but was destroyed
347      * ====
348      */
349     function isContract(address account) internal view returns (bool) {
350         // This method relies on extcodesize, which returns 0 for contracts in
351         // construction, since the code is only stored at the end of the
352         // constructor execution.
353 
354         uint256 size;
355         assembly {
356             size := extcodesize(account)
357         }
358         return size > 0;
359     }
360 
361     /**
362      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
363      * `recipient`, forwarding all available gas and reverting on errors.
364      *
365      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
366      * of certain opcodes, possibly making contracts go over the 2300 gas limit
367      * imposed by `transfer`, making them unable to receive funds via
368      * `transfer`. {sendValue} removes this limitation.
369      *
370      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
371      *
372      * IMPORTANT: because control is transferred to `recipient`, care must be
373      * taken to not create reentrancy vulnerabilities. Consider using
374      * {ReentrancyGuard} or the
375      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
376      */
377     function sendValue(address payable recipient, uint256 amount) internal {
378         require(address(this).balance >= amount, "Address: insufficient balance");
379 
380         (bool success, ) = recipient.call{value: amount}("");
381         require(success, "Address: unable to send value, recipient may have reverted");
382     }
383 
384     /**
385      * @dev Performs a Solidity function call using a low level `call`. A
386      * plain `call` is an unsafe replacement for a function call: use this
387      * function instead.
388      *
389      * If `target` reverts with a revert reason, it is bubbled up by this
390      * function (like regular Solidity function calls).
391      *
392      * Returns the raw returned data. To convert to the expected return value,
393      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
394      *
395      * Requirements:
396      *
397      * - `target` must be a contract.
398      * - calling `target` with `data` must not revert.
399      *
400      * _Available since v3.1._
401      */
402     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
403         return functionCall(target, data, "Address: low-level call failed");
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
408      * `errorMessage` as a fallback revert reason when `target` reverts.
409      *
410      * _Available since v3.1._
411      */
412     function functionCall(
413         address target,
414         bytes memory data,
415         string memory errorMessage
416     ) internal returns (bytes memory) {
417         return functionCallWithValue(target, data, 0, errorMessage);
418     }
419 
420     /**
421      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
422      * but also transferring `value` wei to `target`.
423      *
424      * Requirements:
425      *
426      * - the calling contract must have an ETH balance of at least `value`.
427      * - the called Solidity function must be `payable`.
428      *
429      * _Available since v3.1._
430      */
431     function functionCallWithValue(
432         address target,
433         bytes memory data,
434         uint256 value
435     ) internal returns (bytes memory) {
436         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
437     }
438 
439     /**
440      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
441      * with `errorMessage` as a fallback revert reason when `target` reverts.
442      *
443      * _Available since v3.1._
444      */
445     function functionCallWithValue(
446         address target,
447         bytes memory data,
448         uint256 value,
449         string memory errorMessage
450     ) internal returns (bytes memory) {
451         require(address(this).balance >= value, "Address: insufficient balance for call");
452         require(isContract(target), "Address: call to non-contract");
453 
454         (bool success, bytes memory returndata) = target.call{value: value}(data);
455         return _verifyCallResult(success, returndata, errorMessage);
456     }
457 
458     /**
459      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
460      * but performing a static call.
461      *
462      * _Available since v3.3._
463      */
464     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
465         return functionStaticCall(target, data, "Address: low-level static call failed");
466     }
467 
468     /**
469      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
470      * but performing a static call.
471      *
472      * _Available since v3.3._
473      */
474     function functionStaticCall(
475         address target,
476         bytes memory data,
477         string memory errorMessage
478     ) internal view returns (bytes memory) {
479         require(isContract(target), "Address: static call to non-contract");
480 
481         (bool success, bytes memory returndata) = target.staticcall(data);
482         return _verifyCallResult(success, returndata, errorMessage);
483     }
484 
485     /**
486      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
487      * but performing a delegate call.
488      *
489      * _Available since v3.4._
490      */
491     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
492         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
493     }
494 
495     /**
496      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
497      * but performing a delegate call.
498      *
499      * _Available since v3.4._
500      */
501     function functionDelegateCall(
502         address target,
503         bytes memory data,
504         string memory errorMessage
505     ) internal returns (bytes memory) {
506         require(isContract(target), "Address: delegate call to non-contract");
507 
508         (bool success, bytes memory returndata) = target.delegatecall(data);
509         return _verifyCallResult(success, returndata, errorMessage);
510     }
511 
512     function _verifyCallResult(
513         bool success,
514         bytes memory returndata,
515         string memory errorMessage
516     ) private pure returns (bytes memory) {
517         if (success) {
518             return returndata;
519         } else {
520             // Look for revert reason and bubble it up if present
521             if (returndata.length > 0) {
522                 // The easiest way to bubble the revert reason is using memory via assembly
523 
524                 assembly {
525                     let returndata_size := mload(returndata)
526                     revert(add(32, returndata), returndata_size)
527                 }
528             } else {
529                 revert(errorMessage);
530             }
531         }
532     }
533 }
534 
535 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
536 
537 pragma solidity ^0.8.0;
538 
539 
540 /**
541  * @dev Required interface of an ERC721 compliant contract.
542  */
543 interface IERC721 is IERC165 {
544     /**
545      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
546      */
547     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
548 
549     /**
550      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
551      */
552     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
553 
554     /**
555      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
556      */
557     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
558 
559     /**
560      * @dev Returns the number of tokens in ``owner``'s account.
561      */
562     function balanceOf(address owner) external view returns (uint256 balance);
563 
564     /**
565      * @dev Returns the owner of the `tokenId` token.
566      *
567      * Requirements:
568      *
569      * - `tokenId` must exist.
570      */
571     function ownerOf(uint256 tokenId) external view returns (address owner);
572 
573     /**
574      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
575      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
576      *
577      * Requirements:
578      *
579      * - `from` cannot be the zero address.
580      * - `to` cannot be the zero address.
581      * - `tokenId` token must exist and be owned by `from`.
582      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
583      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
584      *
585      * Emits a {Transfer} event.
586      */
587     function safeTransferFrom(
588         address from,
589         address to,
590         uint256 tokenId
591     ) external;
592 
593     /**
594      * @dev Transfers `tokenId` token from `from` to `to`.
595      *
596      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
597      *
598      * Requirements:
599      *
600      * - `from` cannot be the zero address.
601      * - `to` cannot be the zero address.
602      * - `tokenId` token must be owned by `from`.
603      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
604      *
605      * Emits a {Transfer} event.
606      */
607     function transferFrom(
608         address from,
609         address to,
610         uint256 tokenId
611     ) external;
612 
613     /**
614      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
615      * The approval is cleared when the token is transferred.
616      *
617      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
618      *
619      * Requirements:
620      *
621      * - The caller must own the token or be an approved operator.
622      * - `tokenId` must exist.
623      *
624      * Emits an {Approval} event.
625      */
626     function approve(address to, uint256 tokenId) external;
627 
628     /**
629      * @dev Returns the account approved for `tokenId` token.
630      *
631      * Requirements:
632      *
633      * - `tokenId` must exist.
634      */
635     function getApproved(uint256 tokenId) external view returns (address operator);
636 
637     /**
638      * @dev Approve or remove `operator` as an operator for the caller.
639      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
640      *
641      * Requirements:
642      *
643      * - The `operator` cannot be the caller.
644      *
645      * Emits an {ApprovalForAll} event.
646      */
647     function setApprovalForAll(address operator, bool _approved) external;
648 
649     /**
650      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
651      *
652      * See {setApprovalForAll}
653      */
654     function isApprovedForAll(address owner, address operator) external view returns (bool);
655 
656     /**
657      * @dev Safely transfers `tokenId` token from `from` to `to`.
658      *
659      * Requirements:
660      *
661      * - `from` cannot be the zero address.
662      * - `to` cannot be the zero address.
663      * - `tokenId` token must exist and be owned by `from`.
664      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
665      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
666      *
667      * Emits a {Transfer} event.
668      */
669     function safeTransferFrom(
670         address from,
671         address to,
672         uint256 tokenId,
673         bytes calldata data
674     ) external;
675 }
676 
677 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
678 
679 pragma solidity ^0.8.0;
680 
681 
682 /**
683  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
684  * @dev See https://eips.ethereum.org/EIPS/eip-721
685  */
686 interface IERC721Metadata is IERC721 {
687     /**
688      * @dev Returns the token collection name.
689      */
690     function name() external view returns (string memory);
691 
692     /**
693      * @dev Returns the token collection symbol.
694      */
695     function symbol() external view returns (string memory);
696 
697     /**
698      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
699      */
700     function tokenURI(uint256 tokenId) external view returns (string memory);
701 }
702 
703 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
704 
705 pragma solidity ^0.8.0;
706 
707 /**
708  * @title ERC721 token receiver interface
709  * @dev Interface for any contract that wants to support safeTransfers
710  * from ERC721 asset contracts.
711  */
712 interface IERC721Receiver {
713     /**
714      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
715      * by `operator` from `from`, this function is called.
716      *
717      * It must return its Solidity selector to confirm the token transfer.
718      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
719      *
720      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
721      */
722     function onERC721Received(
723         address operator,
724         address from,
725         uint256 tokenId,
726         bytes calldata data
727     ) external returns (bytes4);
728 }
729 
730 
731 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
732 
733 pragma solidity ^0.8.0;
734 
735 /**
736  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
737  * the Metadata extension, but not including the Enumerable extension, which is available separately as
738  * {ERC721Enumerable}.
739  */
740 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
741     using Address for address;
742     using Strings for uint256;
743 
744     // Token name
745     string private _name;
746 
747     // Token symbol
748     string private _symbol;
749 
750     // Mapping from token ID to owner address
751     mapping(uint256 => address) private _owners;
752 
753     // Mapping owner address to token count
754     mapping(address => uint256) private _balances;
755 
756     // Mapping from token ID to approved address
757     mapping(uint256 => address) private _tokenApprovals;
758 
759     // Mapping from owner to operator approvals
760     mapping(address => mapping(address => bool)) private _operatorApprovals;
761 
762     /**
763      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
764      */
765     constructor(string memory name_, string memory symbol_) {
766         _name = name_;
767         _symbol = symbol_;
768     }
769 
770     /**
771      * @dev See {IERC165-supportsInterface}.
772      */
773     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
774         return
775             interfaceId == type(IERC721).interfaceId ||
776             interfaceId == type(IERC721Metadata).interfaceId ||
777             super.supportsInterface(interfaceId);
778     }
779 
780     /**
781      * @dev See {IERC721-balanceOf}.
782      */
783     function balanceOf(address owner) public view virtual override returns (uint256) {
784         require(owner != address(0), "ERC721: balance query for the zero address");
785         return _balances[owner];
786     }
787 
788     /**
789      * @dev See {IERC721-ownerOf}.
790      */
791     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
792         address owner = _owners[tokenId];
793         require(owner != address(0), "ERC721: owner query for nonexistent token");
794         return owner;
795     }
796 
797     /**
798      * @dev See {IERC721Metadata-name}.
799      */
800     function name() public view virtual override returns (string memory) {
801         return _name;
802     }
803 
804     /**
805      * @dev See {IERC721Metadata-symbol}.
806      */
807     function symbol() public view virtual override returns (string memory) {
808         return _symbol;
809     }
810 
811     /**
812      * @dev See {IERC721Metadata-tokenURI}.
813      */
814     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
815         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
816 
817         string memory baseURI = _baseURI();
818         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
819     }
820 
821     /**
822      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
823      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
824      * by default, can be overriden in child contracts.
825      */
826     function _baseURI() internal view virtual returns (string memory) {
827         return "";
828     }
829 
830     /**
831      * @dev See {IERC721-approve}.
832      */
833     function approve(address to, uint256 tokenId) public virtual override {
834         address owner = ERC721.ownerOf(tokenId);
835         require(to != owner, "ERC721: approval to current owner");
836 
837         require(
838             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
839             "ERC721: approve caller is not owner nor approved for all"
840         );
841 
842         _approve(to, tokenId);
843     }
844 
845     /**
846      * @dev See {IERC721-getApproved}.
847      */
848     function getApproved(uint256 tokenId) public view virtual override returns (address) {
849         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
850 
851         return _tokenApprovals[tokenId];
852     }
853 
854     /**
855      * @dev See {IERC721-setApprovalForAll}.
856      */
857     function setApprovalForAll(address operator, bool approved) public virtual override {
858         require(operator != _msgSender(), "ERC721: approve to caller");
859 
860         _operatorApprovals[_msgSender()][operator] = approved;
861         emit ApprovalForAll(_msgSender(), operator, approved);
862     }
863 
864     /**
865      * @dev See {IERC721-isApprovedForAll}.
866      */
867     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
868         return _operatorApprovals[owner][operator];
869     }
870 
871     /**
872      * @dev See {IERC721-transferFrom}.
873      */
874     function transferFrom(
875         address from,
876         address to,
877         uint256 tokenId
878     ) public virtual override {
879         //solhint-disable-next-line max-line-length
880         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
881 
882         _transfer(from, to, tokenId);
883     }
884 
885     /**
886      * @dev See {IERC721-safeTransferFrom}.
887      */
888     function safeTransferFrom(
889         address from,
890         address to,
891         uint256 tokenId
892     ) public virtual override {
893         safeTransferFrom(from, to, tokenId, "");
894     }
895 
896     /**
897      * @dev See {IERC721-safeTransferFrom}.
898      */
899     function safeTransferFrom(
900         address from,
901         address to,
902         uint256 tokenId,
903         bytes memory _data
904     ) public virtual override {
905         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
906         _safeTransfer(from, to, tokenId, _data);
907     }
908 
909     /**
910      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
911      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
912      *
913      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
914      *
915      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
916      * implement alternative mechanisms to perform token transfer, such as signature-based.
917      *
918      * Requirements:
919      *
920      * - `from` cannot be the zero address.
921      * - `to` cannot be the zero address.
922      * - `tokenId` token must exist and be owned by `from`.
923      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
924      *
925      * Emits a {Transfer} event.
926      */
927     function _safeTransfer(
928         address from,
929         address to,
930         uint256 tokenId,
931         bytes memory _data
932     ) internal virtual {
933         _transfer(from, to, tokenId);
934         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
935     }
936 
937     /**
938      * @dev Returns whether `tokenId` exists.
939      *
940      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
941      *
942      * Tokens start existing when they are minted (`_mint`),
943      * and stop existing when they are burned (`_burn`).
944      */
945     function _exists(uint256 tokenId) internal view virtual returns (bool) {
946         return _owners[tokenId] != address(0);
947     }
948 
949     /**
950      * @dev Returns whether `spender` is allowed to manage `tokenId`.
951      *
952      * Requirements:
953      *
954      * - `tokenId` must exist.
955      */
956     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
957         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
958         address owner = ERC721.ownerOf(tokenId);
959         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
960     }
961 
962     /**
963      * @dev Safely mints `tokenId` and transfers it to `to`.
964      *
965      * Requirements:
966      *
967      * - `tokenId` must not exist.
968      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
969      *
970      * Emits a {Transfer} event.
971      */
972     function _safeMint(address to, uint256 tokenId) internal virtual {
973         _safeMint(to, tokenId, "");
974     }
975 
976     /**
977      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
978      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
979      */
980     function _safeMint(
981         address to,
982         uint256 tokenId,
983         bytes memory _data
984     ) internal virtual {
985         _mint(to, tokenId);
986         require(
987             _checkOnERC721Received(address(0), to, tokenId, _data),
988             "ERC721: transfer to non ERC721Receiver implementer"
989         );
990     }
991 
992     /**
993      * @dev Mints `tokenId` and transfers it to `to`.
994      *
995      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
996      *
997      * Requirements:
998      *
999      * - `tokenId` must not exist.
1000      * - `to` cannot be the zero address.
1001      *
1002      * Emits a {Transfer} event.
1003      */
1004     function _mint(address to, uint256 tokenId) internal virtual {
1005         require(to != address(0), "ERC721: mint to the zero address");
1006         require(!_exists(tokenId), "ERC721: token already minted");
1007 
1008         _beforeTokenTransfer(address(0), to, tokenId);
1009 
1010         _balances[to] += 1;
1011         _owners[tokenId] = to;
1012 
1013         emit Transfer(address(0), to, tokenId);
1014     }
1015 
1016     /**
1017      * @dev Destroys `tokenId`.
1018      * The approval is cleared when the token is burned.
1019      *
1020      * Requirements:
1021      *
1022      * - `tokenId` must exist.
1023      *
1024      * Emits a {Transfer} event.
1025      */
1026     function _burn(uint256 tokenId) internal virtual {
1027         address owner = ERC721.ownerOf(tokenId);
1028 
1029         _beforeTokenTransfer(owner, address(0), tokenId);
1030 
1031         // Clear approvals
1032         _approve(address(0), tokenId);
1033 
1034         _balances[owner] -= 1;
1035         delete _owners[tokenId];
1036 
1037         emit Transfer(owner, address(0), tokenId);
1038     }
1039 
1040     /**
1041      * @dev Transfers `tokenId` from `from` to `to`.
1042      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1043      *
1044      * Requirements:
1045      *
1046      * - `to` cannot be the zero address.
1047      * - `tokenId` token must be owned by `from`.
1048      *
1049      * Emits a {Transfer} event.
1050      */
1051     function _transfer(
1052         address from,
1053         address to,
1054         uint256 tokenId
1055     ) internal virtual {
1056         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1057         require(to != address(0), "ERC721: transfer to the zero address");
1058 
1059         _beforeTokenTransfer(from, to, tokenId);
1060 
1061         // Clear approvals from the previous owner
1062         _approve(address(0), tokenId);
1063 
1064         _balances[from] -= 1;
1065         _balances[to] += 1;
1066         _owners[tokenId] = to;
1067 
1068         emit Transfer(from, to, tokenId);
1069     }
1070 
1071     /**
1072      * @dev Approve `to` to operate on `tokenId`
1073      *
1074      * Emits a {Approval} event.
1075      */
1076     function _approve(address to, uint256 tokenId) internal virtual {
1077         _tokenApprovals[tokenId] = to;
1078         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1079     }
1080 
1081     /**
1082      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1083      * The call is not executed if the target address is not a contract.
1084      *
1085      * @param from address representing the previous owner of the given token ID
1086      * @param to target address that will receive the tokens
1087      * @param tokenId uint256 ID of the token to be transferred
1088      * @param _data bytes optional data to send along with the call
1089      * @return bool whether the call correctly returned the expected magic value
1090      */
1091     function _checkOnERC721Received(
1092         address from,
1093         address to,
1094         uint256 tokenId,
1095         bytes memory _data
1096     ) private returns (bool) {
1097         if (to.isContract()) {
1098             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1099                 return retval == IERC721Receiver(to).onERC721Received.selector;
1100             } catch (bytes memory reason) {
1101                 if (reason.length == 0) {
1102                     revert("ERC721: transfer to non ERC721Receiver implementer");
1103                 } else {
1104                     assembly {
1105                         revert(add(32, reason), mload(reason))
1106                     }
1107                 }
1108             }
1109         } else {
1110             return true;
1111         }
1112     }
1113 
1114     /**
1115      * @dev Hook that is called before any token transfer. This includes minting
1116      * and burning.
1117      *
1118      * Calling conditions:
1119      *
1120      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1121      * transferred to `to`.
1122      * - When `from` is zero, `tokenId` will be minted for `to`.
1123      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1124      * - `from` and `to` are never both zero.
1125      *
1126      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1127      */
1128     function _beforeTokenTransfer(
1129         address from,
1130         address to,
1131         uint256 tokenId
1132     ) internal virtual {}
1133 }
1134 
1135 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
1136 
1137 pragma solidity ^0.8.0;
1138 
1139 
1140 /**
1141  * @dev ERC721 token with storage based token URI management.
1142  */
1143 abstract contract ERC721URIStorage is ERC721 {
1144     using Strings for uint256;
1145 
1146     // Optional mapping for token URIs
1147     mapping(uint256 => string) private _tokenURIs;
1148 
1149     /**
1150      * @dev See {IERC721Metadata-tokenURI}.
1151      */
1152     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1153         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1154 
1155         string memory _tokenURI = _tokenURIs[tokenId];
1156         string memory base = _baseURI();
1157 
1158         // If there is no base URI, return the token URI.
1159         if (bytes(base).length == 0) {
1160             return _tokenURI;
1161         }
1162         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1163         if (bytes(_tokenURI).length > 0) {
1164             return string(abi.encodePacked(base, _tokenURI));
1165         }
1166 
1167         return super.tokenURI(tokenId);
1168     }
1169 
1170     /**
1171      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1172      *
1173      * Requirements:
1174      *
1175      * - `tokenId` must exist.
1176      */
1177     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1178         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1179         _tokenURIs[tokenId] = _tokenURI;
1180     }
1181 
1182     /**
1183      * @dev Destroys `tokenId`.
1184      * The approval is cleared when the token is burned.
1185      *
1186      * Requirements:
1187      *
1188      * - `tokenId` must exist.
1189      *
1190      * Emits a {Transfer} event.
1191      */
1192     function _burn(uint256 tokenId) internal virtual override {
1193         super._burn(tokenId);
1194 
1195         if (bytes(_tokenURIs[tokenId]).length != 0) {
1196             delete _tokenURIs[tokenId];
1197         }
1198     }
1199 }
1200 
1201 // File: CashGrab.sol
1202 
1203 
1204 pragma solidity ^0.8.0;
1205 
1206 
1207 contract CashGrabNFT is ERC721URIStorage, Ownable, ReentrancyGuard {
1208     using Counters for Counters.Counter;
1209 
1210     Counters.Counter private _tokenIds;
1211  
1212     string private _baseTokenURI;
1213 
1214     string public GRAB_PROVENANCE = "";
1215     
1216     uint256 public startingIndexBlock;
1217 
1218     uint256 public startingIndex;
1219 
1220     uint256 public REVEAL_TIMESTAMP;
1221     
1222     uint256 public cashGrabPrice = 50000000000000000; 
1223     
1224     uint public constant maxPurchaseAmt = 20;
1225     
1226     uint256 public MAX_CASH_GRAB_NFTS;
1227 
1228     bool public saleIsActive = false;
1229     
1230     bool public hasReserved = false;
1231 
1232     constructor(
1233         uint256 maxSupply,
1234         uint256 revealDate
1235     ) public ERC721("CashGrabNFT", "CGNFT") {
1236         MAX_CASH_GRAB_NFTS = maxSupply;
1237         REVEAL_TIMESTAMP = revealDate;
1238     }
1239     
1240     function withdraw() public onlyOwner {
1241         uint balance = address(this).balance;
1242         payable(msg.sender).transfer(balance);
1243     }
1244     
1245     function reserveNFTs() public onlyOwner {
1246         require(!hasReserved, "NFTs have already been reserved.");
1247         _mintCashGrabs(30);
1248         hasReserved = true;
1249     }
1250 
1251     function bulkMint(address[] memory _addressList) public onlyOwner {
1252         require((_tokenIds.current() + _addressList.length) <=  MAX_CASH_GRAB_NFTS, "Mint would exceed max supply of Cash Grabs");
1253         
1254         for(uint i = 0; i < _addressList.length; i++) {
1255             _tokenIds.increment();
1256             _safeMint(_addressList[i], _tokenIds.current());
1257         }
1258     }
1259     
1260     function purchase(uint _numberOfTokens) public payable {
1261         require(saleIsActive, "Sale is not active");
1262         require(_numberOfTokens <= maxPurchaseAmt, "Can only mint 20 tokens at a time");
1263         require((cashGrabPrice * _numberOfTokens) == msg.value, "Ether value sent is not correct");
1264         
1265         _mintCashGrabs(_numberOfTokens);
1266     }
1267     
1268     function _mintCashGrabs(uint _amountOfTokens) internal nonReentrant {
1269         require((_tokenIds.current() + _amountOfTokens) <=  MAX_CASH_GRAB_NFTS, "Mint would exceed max supply of Cash Grabs");
1270         
1271         for(uint i = 0; i < _amountOfTokens; i++) {
1272             _tokenIds.increment();
1273              _safeMint(msg.sender, _tokenIds.current());
1274         }
1275 
1276         if (startingIndexBlock == 0 && (totalSupply() == MAX_CASH_GRAB_NFTS || block.timestamp >= REVEAL_TIMESTAMP)) {
1277             _setStartingIndex();
1278         } 
1279     }
1280 
1281     // Should only be called once ever.
1282     function _setStartingIndex() internal {
1283         require(startingIndex == 0, "Starting index is already set");
1284 
1285         startingIndexBlock = block.number - 1;
1286 
1287         startingIndex = uint(blockhash(startingIndexBlock)) % MAX_CASH_GRAB_NFTS;
1288     }
1289 
1290     function setRevealTimestamp(uint256 revealTimeStamp) public onlyOwner {
1291         REVEAL_TIMESTAMP = revealTimeStamp;
1292     } 
1293     
1294     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1295         GRAB_PROVENANCE = provenanceHash;
1296     }
1297     
1298     function setBaseURI(string calldata newBaseTokenURI) public onlyOwner{
1299         _baseTokenURI = newBaseTokenURI;
1300     }
1301     
1302     function _baseURI() internal view override returns (string memory) {
1303         return _baseTokenURI;
1304     }
1305 
1306     function baseURI() public view returns (string memory) {
1307         return _baseURI();
1308     }
1309 
1310     function changeSaleState() public onlyOwner {
1311         saleIsActive = !saleIsActive;
1312     }
1313     
1314     function setCashGrabPrice(uint256 Price) public onlyOwner {
1315         cashGrabPrice = Price;
1316     } 
1317 
1318     function totalSupply() public view returns (uint256) { 
1319         return _tokenIds.current(); 
1320     }
1321       
1322     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721) returns (bool) {
1323         return super.supportsInterface(interfaceId);
1324     }
1325 }