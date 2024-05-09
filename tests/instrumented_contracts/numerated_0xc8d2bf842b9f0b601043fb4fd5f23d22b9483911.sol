1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.8.0 <0.9.0 >=0.8.10 <0.9.0;
3 
4 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
5 
6 /* pragma solidity ^0.8.0; */
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
29 
30 /* pragma solidity ^0.8.0; */
31 
32 /* import "../utils/Context.sol"; */
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 abstract contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor() {
55         _setOwner(_msgSender());
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view virtual returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(owner() == _msgSender(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Leaves the contract without owner. It will not be possible to call
75      * `onlyOwner` functions anymore. Can only be called by the current owner.
76      *
77      * NOTE: Renouncing ownership will leave the contract without an owner,
78      * thereby removing any functionality that is only available to the owner.
79      */
80     function renounceOwnership() public virtual onlyOwner {
81         _setOwner(address(0));
82     }
83 
84     /**
85      * @dev Transfers ownership of the contract to a new account (`newOwner`).
86      * Can only be called by the current owner.
87      */
88     function transferOwnership(address newOwner) public virtual onlyOwner {
89         require(newOwner != address(0), "Ownable: new owner is the zero address");
90         _setOwner(newOwner);
91     }
92 
93     function _setOwner(address newOwner) private {
94         address oldOwner = _owner;
95         _owner = newOwner;
96         emit OwnershipTransferred(oldOwner, newOwner);
97     }
98 }
99 
100 ////// lib/openzeppelin-contracts/contracts/security/ReentrancyGuard.sol
101 
102 /* pragma solidity ^0.8.0; */
103 
104 /**
105  * @dev Contract module that helps prevent reentrant calls to a function.
106  *
107  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
108  * available, which can be applied to functions to make sure there are no nested
109  * (reentrant) calls to them.
110  *
111  * Note that because there is a single `nonReentrant` guard, functions marked as
112  * `nonReentrant` may not call one another. This can be worked around by making
113  * those functions `private`, and then adding `external` `nonReentrant` entry
114  * points to them.
115  *
116  * TIP: If you would like to learn more about reentrancy and alternative ways
117  * to protect against it, check out our blog post
118  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
119  */
120 abstract contract ReentrancyGuard {
121     // Booleans are more expensive than uint256 or any type that takes up a full
122     // word because each write operation emits an extra SLOAD to first read the
123     // slot's contents, replace the bits taken up by the boolean, and then write
124     // back. This is the compiler's defense against contract upgrades and
125     // pointer aliasing, and it cannot be disabled.
126 
127     // The values being non-zero value makes deployment a bit more expensive,
128     // but in exchange the refund on every call to nonReentrant will be lower in
129     // amount. Since refunds are capped to a percentage of the total
130     // transaction's gas, it is best to keep them low in cases like this one, to
131     // increase the likelihood of the full refund coming into effect.
132     uint256 private constant _NOT_ENTERED = 1;
133     uint256 private constant _ENTERED = 2;
134 
135     uint256 private _status;
136 
137     constructor() {
138         _status = _NOT_ENTERED;
139     }
140 
141     /**
142      * @dev Prevents a contract from calling itself, directly or indirectly.
143      * Calling a `nonReentrant` function from another `nonReentrant`
144      * function is not supported. It is possible to prevent this from happening
145      * by making the `nonReentrant` function external, and making it call a
146      * `private` function that does the actual work.
147      */
148     modifier nonReentrant() {
149         // On the first call to nonReentrant, _notEntered will be true
150         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
151 
152         // Any calls to nonReentrant after this point will fail
153         _status = _ENTERED;
154 
155         _;
156 
157         // By storing the original value once again, a refund is triggered (see
158         // https://eips.ethereum.org/EIPS/eip-2200)
159         _status = _NOT_ENTERED;
160     }
161 }
162 
163 ////// lib/openzeppelin-contracts/contracts/utils/introspection/IERC165.sol
164 
165 /* pragma solidity ^0.8.0; */
166 
167 /**
168  * @dev Interface of the ERC165 standard, as defined in the
169  * https://eips.ethereum.org/EIPS/eip-165[EIP].
170  *
171  * Implementers can declare support of contract interfaces, which can then be
172  * queried by others ({ERC165Checker}).
173  *
174  * For an implementation, see {ERC165}.
175  */
176 interface IERC165 {
177     /**
178      * @dev Returns true if this contract implements the interface defined by
179      * `interfaceId`. See the corresponding
180      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
181      * to learn more about how these ids are created.
182      *
183      * This function call must use less than 30 000 gas.
184      */
185     function supportsInterface(bytes4 interfaceId) external view returns (bool);
186 }
187 
188 ////// lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol
189 
190 /* pragma solidity ^0.8.0; */
191 
192 /* import "../../utils/introspection/IERC165.sol"; */
193 
194 /**
195  * @dev Required interface of an ERC721 compliant contract.
196  */
197 interface IERC721 is IERC165 {
198     /**
199      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
200      */
201     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
202 
203     /**
204      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
205      */
206     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
207 
208     /**
209      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
210      */
211     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
212 
213     /**
214      * @dev Returns the number of tokens in ``owner``'s account.
215      */
216     function balanceOf(address owner) external view returns (uint256 balance);
217 
218     /**
219      * @dev Returns the owner of the `tokenId` token.
220      *
221      * Requirements:
222      *
223      * - `tokenId` must exist.
224      */
225     function ownerOf(uint256 tokenId) external view returns (address owner);
226 
227     /**
228      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
229      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
230      *
231      * Requirements:
232      *
233      * - `from` cannot be the zero address.
234      * - `to` cannot be the zero address.
235      * - `tokenId` token must exist and be owned by `from`.
236      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
237      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
238      *
239      * Emits a {Transfer} event.
240      */
241     function safeTransferFrom(
242         address from,
243         address to,
244         uint256 tokenId
245     ) external;
246 
247     /**
248      * @dev Transfers `tokenId` token from `from` to `to`.
249      *
250      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
251      *
252      * Requirements:
253      *
254      * - `from` cannot be the zero address.
255      * - `to` cannot be the zero address.
256      * - `tokenId` token must be owned by `from`.
257      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
258      *
259      * Emits a {Transfer} event.
260      */
261     function transferFrom(
262         address from,
263         address to,
264         uint256 tokenId
265     ) external;
266 
267     /**
268      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
269      * The approval is cleared when the token is transferred.
270      *
271      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
272      *
273      * Requirements:
274      *
275      * - The caller must own the token or be an approved operator.
276      * - `tokenId` must exist.
277      *
278      * Emits an {Approval} event.
279      */
280     function approve(address to, uint256 tokenId) external;
281 
282     /**
283      * @dev Returns the account approved for `tokenId` token.
284      *
285      * Requirements:
286      *
287      * - `tokenId` must exist.
288      */
289     function getApproved(uint256 tokenId) external view returns (address operator);
290 
291     /**
292      * @dev Approve or remove `operator` as an operator for the caller.
293      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
294      *
295      * Requirements:
296      *
297      * - The `operator` cannot be the caller.
298      *
299      * Emits an {ApprovalForAll} event.
300      */
301     function setApprovalForAll(address operator, bool _approved) external;
302 
303     /**
304      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
305      *
306      * See {setApprovalForAll}
307      */
308     function isApprovedForAll(address owner, address operator) external view returns (bool);
309 
310     /**
311      * @dev Safely transfers `tokenId` token from `from` to `to`.
312      *
313      * Requirements:
314      *
315      * - `from` cannot be the zero address.
316      * - `to` cannot be the zero address.
317      * - `tokenId` token must exist and be owned by `from`.
318      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
319      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
320      *
321      * Emits a {Transfer} event.
322      */
323     function safeTransferFrom(
324         address from,
325         address to,
326         uint256 tokenId,
327         bytes calldata data
328     ) external;
329 }
330 
331 ////// lib/openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol
332 
333 /* pragma solidity ^0.8.0; */
334 
335 /**
336  * @title ERC721 token receiver interface
337  * @dev Interface for any contract that wants to support safeTransfers
338  * from ERC721 asset contracts.
339  */
340 interface IERC721Receiver {
341     /**
342      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
343      * by `operator` from `from`, this function is called.
344      *
345      * It must return its Solidity selector to confirm the token transfer.
346      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
347      *
348      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
349      */
350     function onERC721Received(
351         address operator,
352         address from,
353         uint256 tokenId,
354         bytes calldata data
355     ) external returns (bytes4);
356 }
357 
358 ////// lib/openzeppelin-contracts/contracts/token/ERC721/extensions/IERC721Metadata.sol
359 
360 /* pragma solidity ^0.8.0; */
361 
362 /* import "../IERC721.sol"; */
363 
364 /**
365  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
366  * @dev See https://eips.ethereum.org/EIPS/eip-721
367  */
368 interface IERC721Metadata is IERC721 {
369     /**
370      * @dev Returns the token collection name.
371      */
372     function name() external view returns (string memory);
373 
374     /**
375      * @dev Returns the token collection symbol.
376      */
377     function symbol() external view returns (string memory);
378 
379     /**
380      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
381      */
382     function tokenURI(uint256 tokenId) external view returns (string memory);
383 }
384 
385 ////// lib/openzeppelin-contracts/contracts/utils/Address.sol
386 
387 /* pragma solidity ^0.8.0; */
388 
389 /**
390  * @dev Collection of functions related to the address type
391  */
392 library Address {
393     /**
394      * @dev Returns true if `account` is a contract.
395      *
396      * [IMPORTANT]
397      * ====
398      * It is unsafe to assume that an address for which this function returns
399      * false is an externally-owned account (EOA) and not a contract.
400      *
401      * Among others, `isContract` will return false for the following
402      * types of addresses:
403      *
404      *  - an externally-owned account
405      *  - a contract in construction
406      *  - an address where a contract will be created
407      *  - an address where a contract lived, but was destroyed
408      * ====
409      */
410     function isContract(address account) internal view returns (bool) {
411         // This method relies on extcodesize, which returns 0 for contracts in
412         // construction, since the code is only stored at the end of the
413         // constructor execution.
414 
415         uint256 size;
416         assembly {
417             size := extcodesize(account)
418         }
419         return size > 0;
420     }
421 
422     /**
423      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
424      * `recipient`, forwarding all available gas and reverting on errors.
425      *
426      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
427      * of certain opcodes, possibly making contracts go over the 2300 gas limit
428      * imposed by `transfer`, making them unable to receive funds via
429      * `transfer`. {sendValue} removes this limitation.
430      *
431      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
432      *
433      * IMPORTANT: because control is transferred to `recipient`, care must be
434      * taken to not create reentrancy vulnerabilities. Consider using
435      * {ReentrancyGuard} or the
436      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
437      */
438     function sendValue(address payable recipient, uint256 amount) internal {
439         require(address(this).balance >= amount, "Address: insufficient balance");
440 
441         (bool success, ) = recipient.call{value: amount}("");
442         require(success, "Address: unable to send value, recipient may have reverted");
443     }
444 
445     /**
446      * @dev Performs a Solidity function call using a low level `call`. A
447      * plain `call` is an unsafe replacement for a function call: use this
448      * function instead.
449      *
450      * If `target` reverts with a revert reason, it is bubbled up by this
451      * function (like regular Solidity function calls).
452      *
453      * Returns the raw returned data. To convert to the expected return value,
454      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
455      *
456      * Requirements:
457      *
458      * - `target` must be a contract.
459      * - calling `target` with `data` must not revert.
460      *
461      * _Available since v3.1._
462      */
463     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
464         return functionCall(target, data, "Address: low-level call failed");
465     }
466 
467     /**
468      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
469      * `errorMessage` as a fallback revert reason when `target` reverts.
470      *
471      * _Available since v3.1._
472      */
473     function functionCall(
474         address target,
475         bytes memory data,
476         string memory errorMessage
477     ) internal returns (bytes memory) {
478         return functionCallWithValue(target, data, 0, errorMessage);
479     }
480 
481     /**
482      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
483      * but also transferring `value` wei to `target`.
484      *
485      * Requirements:
486      *
487      * - the calling contract must have an ETH balance of at least `value`.
488      * - the called Solidity function must be `payable`.
489      *
490      * _Available since v3.1._
491      */
492     function functionCallWithValue(
493         address target,
494         bytes memory data,
495         uint256 value
496     ) internal returns (bytes memory) {
497         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
498     }
499 
500     /**
501      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
502      * with `errorMessage` as a fallback revert reason when `target` reverts.
503      *
504      * _Available since v3.1._
505      */
506     function functionCallWithValue(
507         address target,
508         bytes memory data,
509         uint256 value,
510         string memory errorMessage
511     ) internal returns (bytes memory) {
512         require(address(this).balance >= value, "Address: insufficient balance for call");
513         require(isContract(target), "Address: call to non-contract");
514 
515         (bool success, bytes memory returndata) = target.call{value: value}(data);
516         return verifyCallResult(success, returndata, errorMessage);
517     }
518 
519     /**
520      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
521      * but performing a static call.
522      *
523      * _Available since v3.3._
524      */
525     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
526         return functionStaticCall(target, data, "Address: low-level static call failed");
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
552     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
553         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
554     }
555 
556     /**
557      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
558      * but performing a delegate call.
559      *
560      * _Available since v3.4._
561      */
562     function functionDelegateCall(
563         address target,
564         bytes memory data,
565         string memory errorMessage
566     ) internal returns (bytes memory) {
567         require(isContract(target), "Address: delegate call to non-contract");
568 
569         (bool success, bytes memory returndata) = target.delegatecall(data);
570         return verifyCallResult(success, returndata, errorMessage);
571     }
572 
573     /**
574      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
575      * revert reason using the provided one.
576      *
577      * _Available since v4.3._
578      */
579     function verifyCallResult(
580         bool success,
581         bytes memory returndata,
582         string memory errorMessage
583     ) internal pure returns (bytes memory) {
584         if (success) {
585             return returndata;
586         } else {
587             // Look for revert reason and bubble it up if present
588             if (returndata.length > 0) {
589                 // The easiest way to bubble the revert reason is using memory via assembly
590 
591                 assembly {
592                     let returndata_size := mload(returndata)
593                     revert(add(32, returndata), returndata_size)
594                 }
595             } else {
596                 revert(errorMessage);
597             }
598         }
599     }
600 }
601 
602 ////// lib/openzeppelin-contracts/contracts/utils/Strings.sol
603 
604 /* pragma solidity ^0.8.0; */
605 
606 /**
607  * @dev String operations.
608  */
609 library Strings {
610     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
611 
612     /**
613      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
614      */
615     function toString(uint256 value) internal pure returns (string memory) {
616         // Inspired by OraclizeAPI's implementation - MIT licence
617         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
618 
619         if (value == 0) {
620             return "0";
621         }
622         uint256 temp = value;
623         uint256 digits;
624         while (temp != 0) {
625             digits++;
626             temp /= 10;
627         }
628         bytes memory buffer = new bytes(digits);
629         while (value != 0) {
630             digits -= 1;
631             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
632             value /= 10;
633         }
634         return string(buffer);
635     }
636 
637     /**
638      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
639      */
640     function toHexString(uint256 value) internal pure returns (string memory) {
641         if (value == 0) {
642             return "0x00";
643         }
644         uint256 temp = value;
645         uint256 length = 0;
646         while (temp != 0) {
647             length++;
648             temp >>= 8;
649         }
650         return toHexString(value, length);
651     }
652 
653     /**
654      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
655      */
656     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
657         bytes memory buffer = new bytes(2 * length + 2);
658         buffer[0] = "0";
659         buffer[1] = "x";
660         for (uint256 i = 2 * length + 1; i > 1; --i) {
661             buffer[i] = _HEX_SYMBOLS[value & 0xf];
662             value >>= 4;
663         }
664         require(value == 0, "Strings: hex length insufficient");
665         return string(buffer);
666     }
667 }
668 
669 ////// lib/openzeppelin-contracts/contracts/utils/introspection/ERC165.sol
670 
671 /* pragma solidity ^0.8.0; */
672 
673 /* import "./IERC165.sol"; */
674 
675 /**
676  * @dev Implementation of the {IERC165} interface.
677  *
678  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
679  * for the additional interface id that will be supported. For example:
680  *
681  * ```solidity
682  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
683  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
684  * }
685  * ```
686  *
687  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
688  */
689 abstract contract ERC165 is IERC165 {
690     /**
691      * @dev See {IERC165-supportsInterface}.
692      */
693     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
694         return interfaceId == type(IERC165).interfaceId;
695     }
696 }
697 
698 ////// lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol
699 
700 /* pragma solidity ^0.8.0; */
701 
702 /* import "./IERC721.sol"; */
703 /* import "./IERC721Receiver.sol"; */
704 /* import "./extensions/IERC721Metadata.sol"; */
705 /* import "../../utils/Address.sol"; */
706 /* import "../../utils/Context.sol"; */
707 /* import "../../utils/Strings.sol"; */
708 /* import "../../utils/introspection/ERC165.sol"; */
709 
710 /**
711  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
712  * the Metadata extension, but not including the Enumerable extension, which is available separately as
713  * {ERC721Enumerable}.
714  */
715 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
716     using Address for address;
717     using Strings for uint256;
718 
719     // Token name
720     string private _name;
721 
722     // Token symbol
723     string private _symbol;
724 
725     // Mapping from token ID to owner address
726     mapping(uint256 => address) private _owners;
727 
728     // Mapping owner address to token count
729     mapping(address => uint256) private _balances;
730 
731     // Mapping from token ID to approved address
732     mapping(uint256 => address) private _tokenApprovals;
733 
734     // Mapping from owner to operator approvals
735     mapping(address => mapping(address => bool)) private _operatorApprovals;
736 
737     /**
738      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
739      */
740     constructor(string memory name_, string memory symbol_) {
741         _name = name_;
742         _symbol = symbol_;
743     }
744 
745     /**
746      * @dev See {IERC165-supportsInterface}.
747      */
748     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
749         return
750             interfaceId == type(IERC721).interfaceId ||
751             interfaceId == type(IERC721Metadata).interfaceId ||
752             super.supportsInterface(interfaceId);
753     }
754 
755     /**
756      * @dev See {IERC721-balanceOf}.
757      */
758     function balanceOf(address owner) public view virtual override returns (uint256) {
759         require(owner != address(0), "ERC721: balance query for the zero address");
760         return _balances[owner];
761     }
762 
763     /**
764      * @dev See {IERC721-ownerOf}.
765      */
766     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
767         address owner = _owners[tokenId];
768         require(owner != address(0), "ERC721: owner query for nonexistent token");
769         return owner;
770     }
771 
772     /**
773      * @dev See {IERC721Metadata-name}.
774      */
775     function name() public view virtual override returns (string memory) {
776         return _name;
777     }
778 
779     /**
780      * @dev See {IERC721Metadata-symbol}.
781      */
782     function symbol() public view virtual override returns (string memory) {
783         return _symbol;
784     }
785 
786     /**
787      * @dev See {IERC721Metadata-tokenURI}.
788      */
789     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
790         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
791 
792         string memory baseURI = _baseURI();
793         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
794     }
795 
796     /**
797      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
798      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
799      * by default, can be overriden in child contracts.
800      */
801     function _baseURI() internal view virtual returns (string memory) {
802         return "";
803     }
804 
805     /**
806      * @dev See {IERC721-approve}.
807      */
808     function approve(address to, uint256 tokenId) public virtual override {
809         address owner = ERC721.ownerOf(tokenId);
810         require(to != owner, "ERC721: approval to current owner");
811 
812         require(
813             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
814             "ERC721: approve caller is not owner nor approved for all"
815         );
816 
817         _approve(to, tokenId);
818     }
819 
820     /**
821      * @dev See {IERC721-getApproved}.
822      */
823     function getApproved(uint256 tokenId) public view virtual override returns (address) {
824         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
825 
826         return _tokenApprovals[tokenId];
827     }
828 
829     /**
830      * @dev See {IERC721-setApprovalForAll}.
831      */
832     function setApprovalForAll(address operator, bool approved) public virtual override {
833         require(operator != _msgSender(), "ERC721: approve to caller");
834 
835         _operatorApprovals[_msgSender()][operator] = approved;
836         emit ApprovalForAll(_msgSender(), operator, approved);
837     }
838 
839     /**
840      * @dev See {IERC721-isApprovedForAll}.
841      */
842     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
843         return _operatorApprovals[owner][operator];
844     }
845 
846     /**
847      * @dev See {IERC721-transferFrom}.
848      */
849     function transferFrom(
850         address from,
851         address to,
852         uint256 tokenId
853     ) public virtual override {
854         //solhint-disable-next-line max-line-length
855         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
856 
857         _transfer(from, to, tokenId);
858     }
859 
860     /**
861      * @dev See {IERC721-safeTransferFrom}.
862      */
863     function safeTransferFrom(
864         address from,
865         address to,
866         uint256 tokenId
867     ) public virtual override {
868         safeTransferFrom(from, to, tokenId, "");
869     }
870 
871     /**
872      * @dev See {IERC721-safeTransferFrom}.
873      */
874     function safeTransferFrom(
875         address from,
876         address to,
877         uint256 tokenId,
878         bytes memory _data
879     ) public virtual override {
880         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
881         _safeTransfer(from, to, tokenId, _data);
882     }
883 
884     /**
885      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
886      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
887      *
888      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
889      *
890      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
891      * implement alternative mechanisms to perform token transfer, such as signature-based.
892      *
893      * Requirements:
894      *
895      * - `from` cannot be the zero address.
896      * - `to` cannot be the zero address.
897      * - `tokenId` token must exist and be owned by `from`.
898      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
899      *
900      * Emits a {Transfer} event.
901      */
902     function _safeTransfer(
903         address from,
904         address to,
905         uint256 tokenId,
906         bytes memory _data
907     ) internal virtual {
908         _transfer(from, to, tokenId);
909         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
910     }
911 
912     /**
913      * @dev Returns whether `tokenId` exists.
914      *
915      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
916      *
917      * Tokens start existing when they are minted (`_mint`),
918      * and stop existing when they are burned (`_burn`).
919      */
920     function _exists(uint256 tokenId) internal view virtual returns (bool) {
921         return _owners[tokenId] != address(0);
922     }
923 
924     /**
925      * @dev Returns whether `spender` is allowed to manage `tokenId`.
926      *
927      * Requirements:
928      *
929      * - `tokenId` must exist.
930      */
931     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
932         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
933         address owner = ERC721.ownerOf(tokenId);
934         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
935     }
936 
937     /**
938      * @dev Safely mints `tokenId` and transfers it to `to`.
939      *
940      * Requirements:
941      *
942      * - `tokenId` must not exist.
943      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
944      *
945      * Emits a {Transfer} event.
946      */
947     function _safeMint(address to, uint256 tokenId) internal virtual {
948         _safeMint(to, tokenId, "");
949     }
950 
951     /**
952      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
953      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
954      */
955     function _safeMint(
956         address to,
957         uint256 tokenId,
958         bytes memory _data
959     ) internal virtual {
960         _mint(to, tokenId);
961         require(
962             _checkOnERC721Received(address(0), to, tokenId, _data),
963             "ERC721: transfer to non ERC721Receiver implementer"
964         );
965     }
966 
967     /**
968      * @dev Mints `tokenId` and transfers it to `to`.
969      *
970      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
971      *
972      * Requirements:
973      *
974      * - `tokenId` must not exist.
975      * - `to` cannot be the zero address.
976      *
977      * Emits a {Transfer} event.
978      */
979     function _mint(address to, uint256 tokenId) internal virtual {
980         require(to != address(0), "ERC721: mint to the zero address");
981         require(!_exists(tokenId), "ERC721: token already minted");
982 
983         _beforeTokenTransfer(address(0), to, tokenId);
984 
985         _balances[to] += 1;
986         _owners[tokenId] = to;
987 
988         emit Transfer(address(0), to, tokenId);
989     }
990 
991     /**
992      * @dev Destroys `tokenId`.
993      * The approval is cleared when the token is burned.
994      *
995      * Requirements:
996      *
997      * - `tokenId` must exist.
998      *
999      * Emits a {Transfer} event.
1000      */
1001     function _burn(uint256 tokenId) internal virtual {
1002         address owner = ERC721.ownerOf(tokenId);
1003 
1004         _beforeTokenTransfer(owner, address(0), tokenId);
1005 
1006         // Clear approvals
1007         _approve(address(0), tokenId);
1008 
1009         _balances[owner] -= 1;
1010         delete _owners[tokenId];
1011 
1012         emit Transfer(owner, address(0), tokenId);
1013     }
1014 
1015     /**
1016      * @dev Transfers `tokenId` from `from` to `to`.
1017      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1018      *
1019      * Requirements:
1020      *
1021      * - `to` cannot be the zero address.
1022      * - `tokenId` token must be owned by `from`.
1023      *
1024      * Emits a {Transfer} event.
1025      */
1026     function _transfer(
1027         address from,
1028         address to,
1029         uint256 tokenId
1030     ) internal virtual {
1031         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1032         require(to != address(0), "ERC721: transfer to the zero address");
1033 
1034         _beforeTokenTransfer(from, to, tokenId);
1035 
1036         // Clear approvals from the previous owner
1037         _approve(address(0), tokenId);
1038 
1039         _balances[from] -= 1;
1040         _balances[to] += 1;
1041         _owners[tokenId] = to;
1042 
1043         emit Transfer(from, to, tokenId);
1044     }
1045 
1046     /**
1047      * @dev Approve `to` to operate on `tokenId`
1048      *
1049      * Emits a {Approval} event.
1050      */
1051     function _approve(address to, uint256 tokenId) internal virtual {
1052         _tokenApprovals[tokenId] = to;
1053         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1054     }
1055 
1056     /**
1057      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1058      * The call is not executed if the target address is not a contract.
1059      *
1060      * @param from address representing the previous owner of the given token ID
1061      * @param to target address that will receive the tokens
1062      * @param tokenId uint256 ID of the token to be transferred
1063      * @param _data bytes optional data to send along with the call
1064      * @return bool whether the call correctly returned the expected magic value
1065      */
1066     function _checkOnERC721Received(
1067         address from,
1068         address to,
1069         uint256 tokenId,
1070         bytes memory _data
1071     ) private returns (bool) {
1072         if (to.isContract()) {
1073             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1074                 return retval == IERC721Receiver.onERC721Received.selector;
1075             } catch (bytes memory reason) {
1076                 if (reason.length == 0) {
1077                     revert("ERC721: transfer to non ERC721Receiver implementer");
1078                 } else {
1079                     assembly {
1080                         revert(add(32, reason), mload(reason))
1081                     }
1082                 }
1083             }
1084         } else {
1085             return true;
1086         }
1087     }
1088 
1089     /**
1090      * @dev Hook that is called before any token transfer. This includes minting
1091      * and burning.
1092      *
1093      * Calling conditions:
1094      *
1095      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1096      * transferred to `to`.
1097      * - When `from` is zero, `tokenId` will be minted for `to`.
1098      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1099      * - `from` and `to` are never both zero.
1100      *
1101      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1102      */
1103     function _beforeTokenTransfer(
1104         address from,
1105         address to,
1106         uint256 tokenId
1107     ) internal virtual {}
1108 }
1109 
1110 ////// lib/openzeppelin-contracts/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1111 
1112 /* pragma solidity ^0.8.0; */
1113 
1114 /* import "../IERC721.sol"; */
1115 
1116 /**
1117  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1118  * @dev See https://eips.ethereum.org/EIPS/eip-721
1119  */
1120 interface IERC721Enumerable is IERC721 {
1121     /**
1122      * @dev Returns the total amount of tokens stored by the contract.
1123      */
1124     function totalSupply() external view returns (uint256);
1125 
1126     /**
1127      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1128      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1129      */
1130     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1131 
1132     /**
1133      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1134      * Use along with {totalSupply} to enumerate all tokens.
1135      */
1136     function tokenByIndex(uint256 index) external view returns (uint256);
1137 }
1138 
1139 ////// lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1140 
1141 /* pragma solidity ^0.8.0; */
1142 
1143 /* import "../ERC721.sol"; */
1144 /* import "./IERC721Enumerable.sol"; */
1145 
1146 /**
1147  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1148  * enumerability of all the token ids in the contract as well as all token ids owned by each
1149  * account.
1150  */
1151 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1152     // Mapping from owner to list of owned token IDs
1153     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1154 
1155     // Mapping from token ID to index of the owner tokens list
1156     mapping(uint256 => uint256) private _ownedTokensIndex;
1157 
1158     // Array with all token ids, used for enumeration
1159     uint256[] private _allTokens;
1160 
1161     // Mapping from token id to position in the allTokens array
1162     mapping(uint256 => uint256) private _allTokensIndex;
1163 
1164     /**
1165      * @dev See {IERC165-supportsInterface}.
1166      */
1167     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1168         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1169     }
1170 
1171     /**
1172      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1173      */
1174     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1175         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1176         return _ownedTokens[owner][index];
1177     }
1178 
1179     /**
1180      * @dev See {IERC721Enumerable-totalSupply}.
1181      */
1182     function totalSupply() public view virtual override returns (uint256) {
1183         return _allTokens.length;
1184     }
1185 
1186     /**
1187      * @dev See {IERC721Enumerable-tokenByIndex}.
1188      */
1189     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1190         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1191         return _allTokens[index];
1192     }
1193 
1194     /**
1195      * @dev Hook that is called before any token transfer. This includes minting
1196      * and burning.
1197      *
1198      * Calling conditions:
1199      *
1200      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1201      * transferred to `to`.
1202      * - When `from` is zero, `tokenId` will be minted for `to`.
1203      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1204      * - `from` cannot be the zero address.
1205      * - `to` cannot be the zero address.
1206      *
1207      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1208      */
1209     function _beforeTokenTransfer(
1210         address from,
1211         address to,
1212         uint256 tokenId
1213     ) internal virtual override {
1214         super._beforeTokenTransfer(from, to, tokenId);
1215 
1216         if (from == address(0)) {
1217             _addTokenToAllTokensEnumeration(tokenId);
1218         } else if (from != to) {
1219             _removeTokenFromOwnerEnumeration(from, tokenId);
1220         }
1221         if (to == address(0)) {
1222             _removeTokenFromAllTokensEnumeration(tokenId);
1223         } else if (to != from) {
1224             _addTokenToOwnerEnumeration(to, tokenId);
1225         }
1226     }
1227 
1228     /**
1229      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1230      * @param to address representing the new owner of the given token ID
1231      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1232      */
1233     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1234         uint256 length = ERC721.balanceOf(to);
1235         _ownedTokens[to][length] = tokenId;
1236         _ownedTokensIndex[tokenId] = length;
1237     }
1238 
1239     /**
1240      * @dev Private function to add a token to this extension's token tracking data structures.
1241      * @param tokenId uint256 ID of the token to be added to the tokens list
1242      */
1243     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1244         _allTokensIndex[tokenId] = _allTokens.length;
1245         _allTokens.push(tokenId);
1246     }
1247 
1248     /**
1249      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1250      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1251      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1252      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1253      * @param from address representing the previous owner of the given token ID
1254      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1255      */
1256     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1257         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1258         // then delete the last slot (swap and pop).
1259 
1260         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1261         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1262 
1263         // When the token to delete is the last token, the swap operation is unnecessary
1264         if (tokenIndex != lastTokenIndex) {
1265             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1266 
1267             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1268             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1269         }
1270 
1271         // This also deletes the contents at the last position of the array
1272         delete _ownedTokensIndex[tokenId];
1273         delete _ownedTokens[from][lastTokenIndex];
1274     }
1275 
1276     /**
1277      * @dev Private function to remove a token from this extension's token tracking data structures.
1278      * This has O(1) time complexity, but alters the order of the _allTokens array.
1279      * @param tokenId uint256 ID of the token to be removed from the tokens list
1280      */
1281     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1282         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1283         // then delete the last slot (swap and pop).
1284 
1285         uint256 lastTokenIndex = _allTokens.length - 1;
1286         uint256 tokenIndex = _allTokensIndex[tokenId];
1287 
1288         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1289         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1290         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1291         uint256 lastTokenId = _allTokens[lastTokenIndex];
1292 
1293         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1294         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1295 
1296         // This also deletes the contents at the last position of the array
1297         delete _allTokensIndex[tokenId];
1298         _allTokens.pop();
1299     }
1300 }
1301 
1302 ////// src/SamuraiCats.sol
1303 /* pragma solidity ^0.8.10; */
1304 
1305 /* import "@openzeppelin/contracts/access/Ownable.sol"; */
1306 /* import "@openzeppelin/contracts/security/ReentrancyGuard.sol"; */
1307 /* import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol"; */
1308 
1309 contract SamuraiCats is ERC721Enumerable, Ownable, ReentrancyGuard {
1310     uint256 public constant maxSupply = 4747;
1311     uint256 public privateSalePrice = 0.12 ether;
1312     uint256 public preSalePrice = 0.17 ether;
1313     uint256 public publicSalePrice = 0.17 ether;
1314     uint256 public maxTokensPerPrivateSaleTx = 20;
1315     uint256 public maxTokensPerPresaleTx = 4;
1316     uint256 public maxTokensPerPublicSaleTx = 5;
1317 
1318     /*
1319      *  Mint max supply :
1320      * -> Private sale : From 1 to 790
1321      * -> Pre-sale : From 791 to 1970
1322      * -> Public sale : From 1971 to 4747
1323      */
1324     uint256 public maxSupplyPrivateSale = 790;
1325     uint256 public maxSupplyPresale = 1970;
1326 
1327     string public baseUri;
1328     string public unrevealedTokenUri =
1329         "https://samuraicats.mypinata.cloud/ipfs/QmeXn7JZdyLzTud6qgGcDYFjMChJFqLG896yKswGxSBacM";
1330     string public contractUri =
1331         "https://samuraicats.mypinata.cloud/ipfs/QmQsDPxJZYoFFgtGqKgAxrJcDPnWkxQikKxxMPTudoFgGc";
1332 
1333     bool public isRevealed;
1334 
1335     enum SaleStatus {
1336         NotSale,
1337         PrivateSale,
1338         PreSale,
1339         FreeMint,
1340         PublicSale
1341     }
1342     SaleStatus public currentSaleStatus;
1343 
1344     mapping(address => bool) public privateSaleList;
1345     mapping(address => uint256) public freeMintList;
1346     mapping(address => bool) public privateSaleWalletTxStatus;
1347 
1348     /*///////////////////////////////////////////////////////////////
1349                             CONSTRUCTOR
1350     //////////////////////////////////////////////////////////////*/
1351 
1352     constructor() ERC721("SamuraiCats by Hiro Ando", "SCHA") {}
1353 
1354     /*///////////////////////////////////////////////////////////////
1355                             MINT FUNCTIONS
1356     //////////////////////////////////////////////////////////////*/
1357 
1358     function mintPrivateSale(uint256 numOfToken) external payable nonReentrant {
1359         require(privateSaleList[msg.sender], "not in private list");
1360         require(
1361             currentSaleStatus == SaleStatus.PrivateSale,
1362             "MINT: not in private sale"
1363         );
1364         require(
1365             !privateSaleWalletTxStatus[msg.sender],
1366             "MINT: you already done the private sale"
1367         );
1368         require(
1369             numOfToken <= maxTokensPerPrivateSaleTx,
1370             "MINT: exceed presale limit per transaction"
1371         );
1372         require(
1373             privateSalePrice * numOfToken <= msg.value,
1374             "MINT: insufficient ether"
1375         );
1376         require(
1377             totalSupply() + numOfToken <= maxSupplyPrivateSale,
1378             "MINT: reach limit"
1379         );
1380 
1381         _mintToken(msg.sender, numOfToken);
1382         privateSaleWalletTxStatus[msg.sender] = true;
1383     }
1384 
1385     function mintPreSale(uint256 numOfToken) external payable nonReentrant {
1386         require(
1387             currentSaleStatus == SaleStatus.PreSale,
1388             "MINT: not in pre-sale"
1389         );
1390         require(
1391             numOfToken <= maxTokensPerPresaleTx,
1392             "MINT: exceed presale limit per transaction"
1393         );
1394         require(
1395             preSalePrice * numOfToken <= msg.value,
1396             "MINT: insufficient ether"
1397         );
1398 
1399         // Bonus token (+ 1)
1400         if (numOfToken == maxTokensPerPresaleTx) {
1401             unchecked {
1402                 numOfToken++;
1403             }
1404         }
1405 
1406         require(
1407             totalSupply() + numOfToken <= maxSupplyPresale,
1408             "MINT: reach limit"
1409         );
1410 
1411         _mintToken(msg.sender, numOfToken);
1412     }
1413 
1414     function freeMint(uint256 numOfToken) external nonReentrant {
1415         require(
1416             currentSaleStatus == SaleStatus.FreeMint,
1417             "MINT: not in free mint"
1418         );
1419         require(
1420             numOfToken <= freeMintList[msg.sender],
1421             "MINT: exceed free mint allocation"
1422         );
1423         require(totalSupply() + numOfToken <= maxSupply, "MINT: reach limit");
1424         _mintToken(msg.sender, numOfToken);
1425 
1426         freeMintList[msg.sender] -= numOfToken;
1427     }
1428 
1429     function mintToken(uint256 numOfToken) external payable nonReentrant {
1430         require(
1431             currentSaleStatus == SaleStatus.PublicSale,
1432             "MINT: not in public sale"
1433         );
1434         require(
1435             publicSalePrice * numOfToken <= msg.value,
1436             "MINT: insufficient ether"
1437         );
1438         require(
1439             numOfToken <= maxTokensPerPublicSaleTx,
1440             "MINT: exceed presale limit per transaction"
1441         );
1442         require(totalSupply() + numOfToken <= maxSupply, "MINT: reach limit");
1443         _mintToken(msg.sender, numOfToken);
1444     }
1445 
1446     function mintOwner(address to, uint256 numOfToken) external onlyOwner {
1447         require(totalSupply() + numOfToken <= maxSupply, "MINT: reach limit");
1448         _mintToken(to, numOfToken);
1449     }
1450 
1451     function _mintToken(address to, uint256 numOfToken) internal {
1452         for (uint256 i = 0; i < numOfToken; i++) {
1453             uint256 tokenId = totalSupply() + 1;
1454             _safeMint(to, tokenId);
1455         }
1456     }
1457 
1458     /*///////////////////////////////////////////////////////////////
1459                         FUNCTIONS SALE STATUS
1460     //////////////////////////////////////////////////////////////*/
1461 
1462     function setCurrentSaleStatus(SaleStatus _status) external onlyOwner {
1463         currentSaleStatus = _status;
1464     }
1465 
1466     /*///////////////////////////////////////////////////////////////
1467                       FUNCTIONS SALE LISTS
1468     //////////////////////////////////////////////////////////////*/
1469 
1470     function addToPrivateSaleList(address addr) external onlyOwner {
1471         privateSaleList[addr] = true;
1472     }
1473 
1474     function batchAddToPrivateSaleList(address[] memory addrs)
1475         external
1476         onlyOwner
1477     {
1478         uint256 length = addrs.length;
1479         for (uint256 i; i < length; ) {
1480             privateSaleList[addrs[i]] = true;
1481             unchecked {
1482                 i++;
1483             }
1484         }
1485     }
1486 
1487     function addToFreeMintList(address addr, uint256 amount)
1488         external
1489         onlyOwner
1490     {
1491         freeMintList[addr] = amount;
1492     }
1493 
1494     function batchAddToFreeMintList(
1495         address[] memory addrs,
1496         uint256[] memory amounts
1497     ) external onlyOwner {
1498         require(addrs.length == amounts.length, "Length error");
1499         uint256 length = addrs.length;
1500         for (uint256 i; i < length; ) {
1501             freeMintList[addrs[i]] = amounts[i];
1502             unchecked {
1503                 i++;
1504             }
1505         }
1506     }
1507 
1508     /*///////////////////////////////////////////////////////////////
1509                 Max Tokens Per TX & Sale Price & Max Supply
1510     //////////////////////////////////////////////////////////////*/
1511 
1512     function setMaxTokensPerPresaleTx(uint256 _limit) external onlyOwner {
1513         maxTokensPerPresaleTx = _limit;
1514     }
1515 
1516     function setMaxTokensPerPrivateSaleTx(uint256 _limit) external onlyOwner {
1517         maxTokensPerPrivateSaleTx = _limit;
1518     }
1519 
1520     function setMaxTokensPerPublicSaleTx(uint256 _limit) external onlyOwner {
1521         maxTokensPerPublicSaleTx = _limit;
1522     }
1523 
1524     function setPrivateSalePrice(uint256 _price) external onlyOwner {
1525         privateSalePrice = _price;
1526     }
1527 
1528     function setPreSalePrice(uint256 _price) external onlyOwner {
1529         preSalePrice = _price;
1530     }
1531 
1532     function setPublicSalePrice(uint256 _price) external onlyOwner {
1533         publicSalePrice = _price;
1534     }
1535 
1536     function setMaxSupplyPrivateSale(uint256 _maxSupplyPrivateSale)
1537         external
1538         onlyOwner
1539     {
1540         maxSupplyPrivateSale = _maxSupplyPrivateSale;
1541     }
1542 
1543     function setMaxSupplyPresale(uint256 _maxSupplyPresale) external onlyOwner {
1544         maxSupplyPresale = _maxSupplyPresale;
1545     }
1546 
1547     /*///////////////////////////////////////////////////////////////
1548                           URI/REVEAL FUNCTIONS
1549     //////////////////////////////////////////////////////////////*/
1550 
1551     function tokenURI(uint256 tokenId)
1552         public
1553         view
1554         virtual
1555         override
1556         returns (string memory)
1557     {
1558         if (isRevealed) {
1559             return super.tokenURI(tokenId);
1560         } else {
1561             return unrevealedTokenUri;
1562         }
1563     }
1564 
1565     function _baseURI() internal view override returns (string memory) {
1566         return baseUri;
1567     }
1568 
1569     function setBaseURI(string memory _baseUri) external onlyOwner {
1570         baseUri = _baseUri;
1571     }
1572 
1573     function reveal(string memory _baseUri) external onlyOwner {
1574         require(bytes(_baseUri).length != 0, "reveal: cant set empty baseUri");
1575         isRevealed = true;
1576         baseUri = _baseUri;
1577     }
1578 
1579     function setUnrevealedTokenURI(string memory _newUri) external onlyOwner {
1580         unrevealedTokenUri = _newUri;
1581     }
1582 
1583     function setContractURI(string memory _newUri) external onlyOwner {
1584         contractUri = _newUri;
1585     }
1586 
1587     /*///////////////////////////////////////////////////////////////
1588                              WITHDRAW
1589     //////////////////////////////////////////////////////////////*/
1590 
1591     function withdraw() public onlyOwner {
1592         uint256 balance = address(this).balance;
1593         payable(msg.sender).transfer(balance);
1594     }
1595 }