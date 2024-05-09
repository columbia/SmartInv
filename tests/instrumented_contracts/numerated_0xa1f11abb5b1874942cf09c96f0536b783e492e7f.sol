1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
72 
73 
74 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev Provides information about the current execution context, including the
80  * sender of the transaction and its data. While these are generally available
81  * via msg.sender and msg.data, they should not be accessed in such a direct
82  * manner, since when dealing with meta-transactions the account sending and
83  * paying for execution may not be the actual sender (as far as an application
84  * is concerned).
85  *
86  * This contract is only required for intermediate, library-like contracts.
87  */
88 abstract contract Context {
89     function _msgSender() internal view virtual returns (address) {
90         return msg.sender;
91     }
92 
93     function _msgData() internal view virtual returns (bytes calldata) {
94         return msg.data;
95     }
96 }
97 
98 // File: smart contracts/extensions/Adminable.sol
99 
100 
101 
102 //RMTPSH
103 
104 pragma solidity ^0.8.0;
105 
106 
107 
108 
109 contract Adminable is Context{
110 
111     address private _admin;
112 
113 
114 
115     event AdminshipTransferred(address indexed previousAdmin, address indexed newAdmin);
116 
117 
118 
119     /**
120 
121      * @dev Initializes the contract setting the deployer as the initial admin.
122 
123      */
124 
125     constructor() {
126 
127         _transferAdminship(_msgSender());
128 
129     }
130 
131 
132 
133     /**
134 
135      * @dev Returns the address of the current admin.
136 
137      */
138 
139     function admin() public view virtual returns (address) {
140 
141         return _admin;
142 
143     }
144 
145 
146 
147     /**
148 
149      * @dev Throws if called by any account other than the admin.
150 
151      */
152 
153     modifier onlyAdmin() {
154 
155         require(admin() == _msgSender(), "Caller is not the admin");
156 
157         _;
158 
159     }
160 
161 
162 
163     /**
164 
165      * @dev Leaves the contract without admin. It will not be possible to call
166 
167      * `onlyAdmin` functions anymore. Can only be called by the current admin.
168 
169      *
170 
171      * NOTE: Renouncing adminship will leave the contract without an admin,
172 
173      * thereby removing any functionality that is only available to the admin.
174 
175      */
176 
177     function renounceAdminship() public virtual onlyAdmin {
178 
179         _transferAdminship(address(0));
180 
181     }
182 
183 
184 
185     /**
186 
187      * @dev Transfers adminship of the contract to a new account (`newAdmin`).
188 
189      * Can only be called by the current admin.
190 
191      */
192 
193     function transferAdminship(address newAdmin) public virtual onlyAdmin {
194 
195         require(newAdmin != address(0), "New admin is the zero address");
196 
197         _transferAdminship(newAdmin);
198 
199     }
200 
201 
202 
203     /**
204 
205      * @dev Transfers adminship of the contract to a new account (`newAdmin`).
206 
207      * Internal function without access restriction.
208 
209      */
210 
211     function _transferAdminship(address newAdmin) internal virtual {
212 
213         address oldAdmin = _admin;
214 
215         _admin = newAdmin;
216 
217         emit AdminshipTransferred(oldAdmin, newAdmin);
218 
219     }
220 
221 }
222 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
223 
224 
225 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
226 
227 pragma solidity ^0.8.0;
228 
229 
230 /**
231  * @dev Contract module which provides a basic access control mechanism, where
232  * there is an account (an owner) that can be granted exclusive access to
233  * specific functions.
234  *
235  * By default, the owner account will be the one that deploys the contract. This
236  * can later be changed with {transferOwnership}.
237  *
238  * This module is used through inheritance. It will make available the modifier
239  * `onlyOwner`, which can be applied to your functions to restrict their use to
240  * the owner.
241  */
242 abstract contract Ownable is Context {
243     address private _owner;
244 
245     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
246 
247     /**
248      * @dev Initializes the contract setting the deployer as the initial owner.
249      */
250     constructor() {
251         _transferOwnership(_msgSender());
252     }
253 
254     /**
255      * @dev Returns the address of the current owner.
256      */
257     function owner() public view virtual returns (address) {
258         return _owner;
259     }
260 
261     /**
262      * @dev Throws if called by any account other than the owner.
263      */
264     modifier onlyOwner() {
265         require(owner() == _msgSender(), "Ownable: caller is not the owner");
266         _;
267     }
268 
269     /**
270      * @dev Leaves the contract without owner. It will not be possible to call
271      * `onlyOwner` functions anymore. Can only be called by the current owner.
272      *
273      * NOTE: Renouncing ownership will leave the contract without an owner,
274      * thereby removing any functionality that is only available to the owner.
275      */
276     function renounceOwnership() public virtual onlyOwner {
277         _transferOwnership(address(0));
278     }
279 
280     /**
281      * @dev Transfers ownership of the contract to a new account (`newOwner`).
282      * Can only be called by the current owner.
283      */
284     function transferOwnership(address newOwner) public virtual onlyOwner {
285         require(newOwner != address(0), "Ownable: new owner is the zero address");
286         _transferOwnership(newOwner);
287     }
288 
289     /**
290      * @dev Transfers ownership of the contract to a new account (`newOwner`).
291      * Internal function without access restriction.
292      */
293     function _transferOwnership(address newOwner) internal virtual {
294         address oldOwner = _owner;
295         _owner = newOwner;
296         emit OwnershipTransferred(oldOwner, newOwner);
297     }
298 }
299 
300 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
301 
302 
303 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
304 
305 pragma solidity ^0.8.1;
306 
307 /**
308  * @dev Collection of functions related to the address type
309  */
310 library Address {
311     /**
312      * @dev Returns true if `account` is a contract.
313      *
314      * [IMPORTANT]
315      * ====
316      * It is unsafe to assume that an address for which this function returns
317      * false is an externally-owned account (EOA) and not a contract.
318      *
319      * Among others, `isContract` will return false for the following
320      * types of addresses:
321      *
322      *  - an externally-owned account
323      *  - a contract in construction
324      *  - an address where a contract will be created
325      *  - an address where a contract lived, but was destroyed
326      * ====
327      *
328      * [IMPORTANT]
329      * ====
330      * You shouldn't rely on `isContract` to protect against flash loan attacks!
331      *
332      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
333      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
334      * constructor.
335      * ====
336      */
337     function isContract(address account) internal view returns (bool) {
338         // This method relies on extcodesize/address.code.length, which returns 0
339         // for contracts in construction, since the code is only stored at the end
340         // of the constructor execution.
341 
342         return account.code.length > 0;
343     }
344 
345     /**
346      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
347      * `recipient`, forwarding all available gas and reverting on errors.
348      *
349      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
350      * of certain opcodes, possibly making contracts go over the 2300 gas limit
351      * imposed by `transfer`, making them unable to receive funds via
352      * `transfer`. {sendValue} removes this limitation.
353      *
354      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
355      *
356      * IMPORTANT: because control is transferred to `recipient`, care must be
357      * taken to not create reentrancy vulnerabilities. Consider using
358      * {ReentrancyGuard} or the
359      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
360      */
361     function sendValue(address payable recipient, uint256 amount) internal {
362         require(address(this).balance >= amount, "Address: insufficient balance");
363 
364         (bool success, ) = recipient.call{value: amount}("");
365         require(success, "Address: unable to send value, recipient may have reverted");
366     }
367 
368     /**
369      * @dev Performs a Solidity function call using a low level `call`. A
370      * plain `call` is an unsafe replacement for a function call: use this
371      * function instead.
372      *
373      * If `target` reverts with a revert reason, it is bubbled up by this
374      * function (like regular Solidity function calls).
375      *
376      * Returns the raw returned data. To convert to the expected return value,
377      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
378      *
379      * Requirements:
380      *
381      * - `target` must be a contract.
382      * - calling `target` with `data` must not revert.
383      *
384      * _Available since v3.1._
385      */
386     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
387         return functionCall(target, data, "Address: low-level call failed");
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
392      * `errorMessage` as a fallback revert reason when `target` reverts.
393      *
394      * _Available since v3.1._
395      */
396     function functionCall(
397         address target,
398         bytes memory data,
399         string memory errorMessage
400     ) internal returns (bytes memory) {
401         return functionCallWithValue(target, data, 0, errorMessage);
402     }
403 
404     /**
405      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
406      * but also transferring `value` wei to `target`.
407      *
408      * Requirements:
409      *
410      * - the calling contract must have an ETH balance of at least `value`.
411      * - the called Solidity function must be `payable`.
412      *
413      * _Available since v3.1._
414      */
415     function functionCallWithValue(
416         address target,
417         bytes memory data,
418         uint256 value
419     ) internal returns (bytes memory) {
420         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
425      * with `errorMessage` as a fallback revert reason when `target` reverts.
426      *
427      * _Available since v3.1._
428      */
429     function functionCallWithValue(
430         address target,
431         bytes memory data,
432         uint256 value,
433         string memory errorMessage
434     ) internal returns (bytes memory) {
435         require(address(this).balance >= value, "Address: insufficient balance for call");
436         require(isContract(target), "Address: call to non-contract");
437 
438         (bool success, bytes memory returndata) = target.call{value: value}(data);
439         return verifyCallResult(success, returndata, errorMessage);
440     }
441 
442     /**
443      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
444      * but performing a static call.
445      *
446      * _Available since v3.3._
447      */
448     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
449         return functionStaticCall(target, data, "Address: low-level static call failed");
450     }
451 
452     /**
453      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
454      * but performing a static call.
455      *
456      * _Available since v3.3._
457      */
458     function functionStaticCall(
459         address target,
460         bytes memory data,
461         string memory errorMessage
462     ) internal view returns (bytes memory) {
463         require(isContract(target), "Address: static call to non-contract");
464 
465         (bool success, bytes memory returndata) = target.staticcall(data);
466         return verifyCallResult(success, returndata, errorMessage);
467     }
468 
469     /**
470      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
471      * but performing a delegate call.
472      *
473      * _Available since v3.4._
474      */
475     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
476         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
477     }
478 
479     /**
480      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
481      * but performing a delegate call.
482      *
483      * _Available since v3.4._
484      */
485     function functionDelegateCall(
486         address target,
487         bytes memory data,
488         string memory errorMessage
489     ) internal returns (bytes memory) {
490         require(isContract(target), "Address: delegate call to non-contract");
491 
492         (bool success, bytes memory returndata) = target.delegatecall(data);
493         return verifyCallResult(success, returndata, errorMessage);
494     }
495 
496     /**
497      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
498      * revert reason using the provided one.
499      *
500      * _Available since v4.3._
501      */
502     function verifyCallResult(
503         bool success,
504         bytes memory returndata,
505         string memory errorMessage
506     ) internal pure returns (bytes memory) {
507         if (success) {
508             return returndata;
509         } else {
510             // Look for revert reason and bubble it up if present
511             if (returndata.length > 0) {
512                 // The easiest way to bubble the revert reason is using memory via assembly
513 
514                 assembly {
515                     let returndata_size := mload(returndata)
516                     revert(add(32, returndata), returndata_size)
517                 }
518             } else {
519                 revert(errorMessage);
520             }
521         }
522     }
523 }
524 
525 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
526 
527 
528 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
529 
530 pragma solidity ^0.8.0;
531 
532 /**
533  * @title ERC721 token receiver interface
534  * @dev Interface for any contract that wants to support safeTransfers
535  * from ERC721 asset contracts.
536  */
537 interface IERC721Receiver {
538     /**
539      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
540      * by `operator` from `from`, this function is called.
541      *
542      * It must return its Solidity selector to confirm the token transfer.
543      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
544      *
545      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
546      */
547     function onERC721Received(
548         address operator,
549         address from,
550         uint256 tokenId,
551         bytes calldata data
552     ) external returns (bytes4);
553 }
554 
555 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
556 
557 
558 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
559 
560 pragma solidity ^0.8.0;
561 
562 /**
563  * @dev Interface of the ERC165 standard, as defined in the
564  * https://eips.ethereum.org/EIPS/eip-165[EIP].
565  *
566  * Implementers can declare support of contract interfaces, which can then be
567  * queried by others ({ERC165Checker}).
568  *
569  * For an implementation, see {ERC165}.
570  */
571 interface IERC165 {
572     /**
573      * @dev Returns true if this contract implements the interface defined by
574      * `interfaceId`. See the corresponding
575      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
576      * to learn more about how these ids are created.
577      *
578      * This function call must use less than 30 000 gas.
579      */
580     function supportsInterface(bytes4 interfaceId) external view returns (bool);
581 }
582 
583 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
584 
585 
586 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
587 
588 pragma solidity ^0.8.0;
589 
590 
591 /**
592  * @dev Implementation of the {IERC165} interface.
593  *
594  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
595  * for the additional interface id that will be supported. For example:
596  *
597  * ```solidity
598  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
599  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
600  * }
601  * ```
602  *
603  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
604  */
605 abstract contract ERC165 is IERC165 {
606     /**
607      * @dev See {IERC165-supportsInterface}.
608      */
609     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
610         return interfaceId == type(IERC165).interfaceId;
611     }
612 }
613 
614 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
615 
616 
617 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
618 
619 pragma solidity ^0.8.0;
620 
621 
622 /**
623  * @dev Required interface of an ERC721 compliant contract.
624  */
625 interface IERC721 is IERC165 {
626     /**
627      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
628      */
629     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
630 
631     /**
632      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
633      */
634     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
635 
636     /**
637      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
638      */
639     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
640 
641     /**
642      * @dev Returns the number of tokens in ``owner``'s account.
643      */
644     function balanceOf(address owner) external view returns (uint256 balance);
645 
646     /**
647      * @dev Returns the owner of the `tokenId` token.
648      *
649      * Requirements:
650      *
651      * - `tokenId` must exist.
652      */
653     function ownerOf(uint256 tokenId) external view returns (address owner);
654 
655     /**
656      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
657      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
658      *
659      * Requirements:
660      *
661      * - `from` cannot be the zero address.
662      * - `to` cannot be the zero address.
663      * - `tokenId` token must exist and be owned by `from`.
664      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
665      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
666      *
667      * Emits a {Transfer} event.
668      */
669     function safeTransferFrom(
670         address from,
671         address to,
672         uint256 tokenId
673     ) external;
674 
675     /**
676      * @dev Transfers `tokenId` token from `from` to `to`.
677      *
678      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
679      *
680      * Requirements:
681      *
682      * - `from` cannot be the zero address.
683      * - `to` cannot be the zero address.
684      * - `tokenId` token must be owned by `from`.
685      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
686      *
687      * Emits a {Transfer} event.
688      */
689     function transferFrom(
690         address from,
691         address to,
692         uint256 tokenId
693     ) external;
694 
695     /**
696      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
697      * The approval is cleared when the token is transferred.
698      *
699      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
700      *
701      * Requirements:
702      *
703      * - The caller must own the token or be an approved operator.
704      * - `tokenId` must exist.
705      *
706      * Emits an {Approval} event.
707      */
708     function approve(address to, uint256 tokenId) external;
709 
710     /**
711      * @dev Returns the account approved for `tokenId` token.
712      *
713      * Requirements:
714      *
715      * - `tokenId` must exist.
716      */
717     function getApproved(uint256 tokenId) external view returns (address operator);
718 
719     /**
720      * @dev Approve or remove `operator` as an operator for the caller.
721      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
722      *
723      * Requirements:
724      *
725      * - The `operator` cannot be the caller.
726      *
727      * Emits an {ApprovalForAll} event.
728      */
729     function setApprovalForAll(address operator, bool _approved) external;
730 
731     /**
732      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
733      *
734      * See {setApprovalForAll}
735      */
736     function isApprovedForAll(address owner, address operator) external view returns (bool);
737 
738     /**
739      * @dev Safely transfers `tokenId` token from `from` to `to`.
740      *
741      * Requirements:
742      *
743      * - `from` cannot be the zero address.
744      * - `to` cannot be the zero address.
745      * - `tokenId` token must exist and be owned by `from`.
746      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
747      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
748      *
749      * Emits a {Transfer} event.
750      */
751     function safeTransferFrom(
752         address from,
753         address to,
754         uint256 tokenId,
755         bytes calldata data
756     ) external;
757 }
758 
759 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
760 
761 
762 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
763 
764 pragma solidity ^0.8.0;
765 
766 
767 /**
768  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
769  * @dev See https://eips.ethereum.org/EIPS/eip-721
770  */
771 interface IERC721Metadata is IERC721 {
772     /**
773      * @dev Returns the token collection name.
774      */
775     function name() external view returns (string memory);
776 
777     /**
778      * @dev Returns the token collection symbol.
779      */
780     function symbol() external view returns (string memory);
781 
782     /**
783      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
784      */
785     function tokenURI(uint256 tokenId) external view returns (string memory);
786 }
787 
788 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
789 
790 
791 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
792 
793 pragma solidity ^0.8.0;
794 
795 
796 
797 
798 
799 
800 
801 
802 /**
803  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
804  * the Metadata extension, but not including the Enumerable extension, which is available separately as
805  * {ERC721Enumerable}.
806  */
807 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
808     using Address for address;
809     using Strings for uint256;
810 
811     // Token name
812     string private _name;
813 
814     // Token symbol
815     string private _symbol;
816 
817     // Mapping from token ID to owner address
818     mapping(uint256 => address) private _owners;
819 
820     // Mapping owner address to token count
821     mapping(address => uint256) private _balances;
822 
823     // Mapping from token ID to approved address
824     mapping(uint256 => address) private _tokenApprovals;
825 
826     // Mapping from owner to operator approvals
827     mapping(address => mapping(address => bool)) private _operatorApprovals;
828 
829     /**
830      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
831      */
832     constructor(string memory name_, string memory symbol_) {
833         _name = name_;
834         _symbol = symbol_;
835     }
836 
837     /**
838      * @dev See {IERC165-supportsInterface}.
839      */
840     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
841         return
842             interfaceId == type(IERC721).interfaceId ||
843             interfaceId == type(IERC721Metadata).interfaceId ||
844             super.supportsInterface(interfaceId);
845     }
846 
847     /**
848      * @dev See {IERC721-balanceOf}.
849      */
850     function balanceOf(address owner) public view virtual override returns (uint256) {
851         require(owner != address(0), "ERC721: balance query for the zero address");
852         return _balances[owner];
853     }
854 
855     /**
856      * @dev See {IERC721-ownerOf}.
857      */
858     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
859         address owner = _owners[tokenId];
860         require(owner != address(0), "ERC721: owner query for nonexistent token");
861         return owner;
862     }
863 
864     /**
865      * @dev See {IERC721Metadata-name}.
866      */
867     function name() public view virtual override returns (string memory) {
868         return _name;
869     }
870 
871     /**
872      * @dev See {IERC721Metadata-symbol}.
873      */
874     function symbol() public view virtual override returns (string memory) {
875         return _symbol;
876     }
877 
878     /**
879      * @dev See {IERC721Metadata-tokenURI}.
880      */
881     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
882         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
883 
884         string memory baseURI = _baseURI();
885         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
886     }
887 
888     /**
889      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
890      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
891      * by default, can be overridden in child contracts.
892      */
893     function _baseURI() internal view virtual returns (string memory) {
894         return "";
895     }
896 
897     /**
898      * @dev See {IERC721-approve}.
899      */
900     function approve(address to, uint256 tokenId) public virtual override {
901         address owner = ERC721.ownerOf(tokenId);
902         require(to != owner, "ERC721: approval to current owner");
903 
904         require(
905             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
906             "ERC721: approve caller is not owner nor approved for all"
907         );
908 
909         _approve(to, tokenId);
910     }
911 
912     /**
913      * @dev See {IERC721-getApproved}.
914      */
915     function getApproved(uint256 tokenId) public view virtual override returns (address) {
916         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
917 
918         return _tokenApprovals[tokenId];
919     }
920 
921     /**
922      * @dev See {IERC721-setApprovalForAll}.
923      */
924     function setApprovalForAll(address operator, bool approved) public virtual override {
925         _setApprovalForAll(_msgSender(), operator, approved);
926     }
927 
928     /**
929      * @dev See {IERC721-isApprovedForAll}.
930      */
931     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
932         return _operatorApprovals[owner][operator];
933     }
934 
935     /**
936      * @dev See {IERC721-transferFrom}.
937      */
938     function transferFrom(
939         address from,
940         address to,
941         uint256 tokenId
942     ) public virtual override {
943         //solhint-disable-next-line max-line-length
944         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
945 
946         _transfer(from, to, tokenId);
947     }
948 
949     /**
950      * @dev See {IERC721-safeTransferFrom}.
951      */
952     function safeTransferFrom(
953         address from,
954         address to,
955         uint256 tokenId
956     ) public virtual override {
957         safeTransferFrom(from, to, tokenId, "");
958     }
959 
960     /**
961      * @dev See {IERC721-safeTransferFrom}.
962      */
963     function safeTransferFrom(
964         address from,
965         address to,
966         uint256 tokenId,
967         bytes memory _data
968     ) public virtual override {
969         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
970         _safeTransfer(from, to, tokenId, _data);
971     }
972 
973     /**
974      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
975      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
976      *
977      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
978      *
979      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
980      * implement alternative mechanisms to perform token transfer, such as signature-based.
981      *
982      * Requirements:
983      *
984      * - `from` cannot be the zero address.
985      * - `to` cannot be the zero address.
986      * - `tokenId` token must exist and be owned by `from`.
987      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
988      *
989      * Emits a {Transfer} event.
990      */
991     function _safeTransfer(
992         address from,
993         address to,
994         uint256 tokenId,
995         bytes memory _data
996     ) internal virtual {
997         _transfer(from, to, tokenId);
998         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
999     }
1000 
1001     /**
1002      * @dev Returns whether `tokenId` exists.
1003      *
1004      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1005      *
1006      * Tokens start existing when they are minted (`_mint`),
1007      * and stop existing when they are burned (`_burn`).
1008      */
1009     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1010         return _owners[tokenId] != address(0);
1011     }
1012 
1013     /**
1014      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1015      *
1016      * Requirements:
1017      *
1018      * - `tokenId` must exist.
1019      */
1020     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1021         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1022         address owner = ERC721.ownerOf(tokenId);
1023         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1024     }
1025 
1026     /**
1027      * @dev Safely mints `tokenId` and transfers it to `to`.
1028      *
1029      * Requirements:
1030      *
1031      * - `tokenId` must not exist.
1032      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1033      *
1034      * Emits a {Transfer} event.
1035      */
1036     function _safeMint(address to, uint256 tokenId) internal virtual {
1037         _safeMint(to, tokenId, "");
1038     }
1039 
1040     /**
1041      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1042      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1043      */
1044     function _safeMint(
1045         address to,
1046         uint256 tokenId,
1047         bytes memory _data
1048     ) internal virtual {
1049         _mint(to, tokenId);
1050         require(
1051             _checkOnERC721Received(address(0), to, tokenId, _data),
1052             "ERC721: transfer to non ERC721Receiver implementer"
1053         );
1054     }
1055 
1056     /**
1057      * @dev Mints `tokenId` and transfers it to `to`.
1058      *
1059      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1060      *
1061      * Requirements:
1062      *
1063      * - `tokenId` must not exist.
1064      * - `to` cannot be the zero address.
1065      *
1066      * Emits a {Transfer} event.
1067      */
1068     function _mint(address to, uint256 tokenId) internal virtual {
1069         require(to != address(0), "ERC721: mint to the zero address");
1070         require(!_exists(tokenId), "ERC721: token already minted");
1071 
1072         _beforeTokenTransfer(address(0), to, tokenId);
1073 
1074         _balances[to] += 1;
1075         _owners[tokenId] = to;
1076 
1077         emit Transfer(address(0), to, tokenId);
1078 
1079         _afterTokenTransfer(address(0), to, tokenId);
1080     }
1081 
1082     /**
1083      * @dev Destroys `tokenId`.
1084      * The approval is cleared when the token is burned.
1085      *
1086      * Requirements:
1087      *
1088      * - `tokenId` must exist.
1089      *
1090      * Emits a {Transfer} event.
1091      */
1092     function _burn(uint256 tokenId) internal virtual {
1093         address owner = ERC721.ownerOf(tokenId);
1094 
1095         _beforeTokenTransfer(owner, address(0), tokenId);
1096 
1097         // Clear approvals
1098         _approve(address(0), tokenId);
1099 
1100         _balances[owner] -= 1;
1101         delete _owners[tokenId];
1102 
1103         emit Transfer(owner, address(0), tokenId);
1104 
1105         _afterTokenTransfer(owner, address(0), tokenId);
1106     }
1107 
1108     /**
1109      * @dev Transfers `tokenId` from `from` to `to`.
1110      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1111      *
1112      * Requirements:
1113      *
1114      * - `to` cannot be the zero address.
1115      * - `tokenId` token must be owned by `from`.
1116      *
1117      * Emits a {Transfer} event.
1118      */
1119     function _transfer(
1120         address from,
1121         address to,
1122         uint256 tokenId
1123     ) internal virtual {
1124         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1125         require(to != address(0), "ERC721: transfer to the zero address");
1126 
1127         _beforeTokenTransfer(from, to, tokenId);
1128 
1129         // Clear approvals from the previous owner
1130         _approve(address(0), tokenId);
1131 
1132         _balances[from] -= 1;
1133         _balances[to] += 1;
1134         _owners[tokenId] = to;
1135 
1136         emit Transfer(from, to, tokenId);
1137 
1138         _afterTokenTransfer(from, to, tokenId);
1139     }
1140 
1141     /**
1142      * @dev Approve `to` to operate on `tokenId`
1143      *
1144      * Emits a {Approval} event.
1145      */
1146     function _approve(address to, uint256 tokenId) internal virtual {
1147         _tokenApprovals[tokenId] = to;
1148         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1149     }
1150 
1151     /**
1152      * @dev Approve `operator` to operate on all of `owner` tokens
1153      *
1154      * Emits a {ApprovalForAll} event.
1155      */
1156     function _setApprovalForAll(
1157         address owner,
1158         address operator,
1159         bool approved
1160     ) internal virtual {
1161         require(owner != operator, "ERC721: approve to caller");
1162         _operatorApprovals[owner][operator] = approved;
1163         emit ApprovalForAll(owner, operator, approved);
1164     }
1165 
1166     /**
1167      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1168      * The call is not executed if the target address is not a contract.
1169      *
1170      * @param from address representing the previous owner of the given token ID
1171      * @param to target address that will receive the tokens
1172      * @param tokenId uint256 ID of the token to be transferred
1173      * @param _data bytes optional data to send along with the call
1174      * @return bool whether the call correctly returned the expected magic value
1175      */
1176     function _checkOnERC721Received(
1177         address from,
1178         address to,
1179         uint256 tokenId,
1180         bytes memory _data
1181     ) private returns (bool) {
1182         if (to.isContract()) {
1183             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1184                 return retval == IERC721Receiver.onERC721Received.selector;
1185             } catch (bytes memory reason) {
1186                 if (reason.length == 0) {
1187                     revert("ERC721: transfer to non ERC721Receiver implementer");
1188                 } else {
1189                     assembly {
1190                         revert(add(32, reason), mload(reason))
1191                     }
1192                 }
1193             }
1194         } else {
1195             return true;
1196         }
1197     }
1198 
1199     /**
1200      * @dev Hook that is called before any token transfer. This includes minting
1201      * and burning.
1202      *
1203      * Calling conditions:
1204      *
1205      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1206      * transferred to `to`.
1207      * - When `from` is zero, `tokenId` will be minted for `to`.
1208      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1209      * - `from` and `to` are never both zero.
1210      *
1211      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1212      */
1213     function _beforeTokenTransfer(
1214         address from,
1215         address to,
1216         uint256 tokenId
1217     ) internal virtual {}
1218 
1219     /**
1220      * @dev Hook that is called after any transfer of tokens. This includes
1221      * minting and burning.
1222      *
1223      * Calling conditions:
1224      *
1225      * - when `from` and `to` are both non-zero.
1226      * - `from` and `to` are never both zero.
1227      *
1228      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1229      */
1230     function _afterTokenTransfer(
1231         address from,
1232         address to,
1233         uint256 tokenId
1234     ) internal virtual {}
1235 }
1236 
1237 // File: smart contracts/client/sk8NFT_semiflat.sol
1238 
1239 
1240 
1241 //RMTPSH
1242 
1243 pragma solidity ^0.8.0;
1244 
1245 
1246 
1247 
1248 
1249 
1250 
1251 
1252 contract SK8NFT is ERC721, Ownable, Adminable{
1253 
1254 
1255 
1256     constructor ()
1257 
1258         ERC721("PLAYSK8", "SK8NFT")
1259 
1260     {
1261 
1262         
1263 
1264         whitelist[msg.sender]=true;
1265 
1266 
1267 
1268         whitelist[0x45fd94ffc5F38F61Ff50E4EE134e2C87924aB6e1]=true;
1269 
1270         
1271 
1272             //start date of sale (if zero then sale is always active)
1273 
1274         startDate = 0;
1275 
1276         
1277 
1278             //current mint location pointer (start at 0 or 1)
1279 
1280         salePointer = 1;
1281 
1282 
1283 
1284             //total assets to be sold (final token ID)
1285 
1286         saleMax = 10000;
1287 
1288         
1289 
1290             //current mint max per address
1291 
1292         mintMax = 250;
1293 
1294 
1295 
1296     }
1297 
1298 
1299 
1300         //price (0.1)
1301 
1302     uint256 public price = 0;
1303 
1304     
1305 
1306         //price (0.1)
1307 
1308     uint256 public distPrice=0;
1309 
1310 
1311 
1312     address payable distReciever = payable(0x45fd94ffc5F38F61Ff50E4EE134e2C87924aB6e1);
1313 
1314     
1315 
1316         //start date of sale (if zero then sale is always active)
1317 
1318     uint256 startDate = 0;
1319 
1320     
1321 
1322         //current mint location pointer (start at 0 or 1)
1323 
1324     uint256 public salePointer = 1;
1325 
1326 
1327 
1328         //total assets to be sold (final token ID)
1329 
1330     uint256 saleMax;
1331 
1332     
1333 
1334         //current mint max per address
1335 
1336     uint256 mintMax;
1337 
1338     
1339 
1340         //minted
1341 
1342     mapping(address => uint8) public mintCount;
1343 
1344     
1345 
1346         //uri
1347 
1348     string public baseTokenURI;
1349 
1350     
1351 
1352         //whitelist toggle
1353 
1354     bool saleWhitelisted = true;
1355 
1356 
1357 
1358         //whitelist
1359 
1360     mapping(address => bool) public whitelist;
1361 
1362 
1363 
1364         //mint contract
1365 
1366     address payable mintContract;
1367 
1368 
1369 
1370         //mint
1371 
1372     function mint(uint8 amount) payable public{
1373 
1374 
1375 
1376             //req whitelist
1377 
1378         require((saleWhitelisted==false)||(whitelist[msg.sender]==true), "You are not on the whitelist");
1379 
1380 
1381 
1382             //verify amount
1383 
1384         require((amount!=0) && (salePointer+amount>salePointer), "Invalid mint quantity");
1385 
1386 
1387 
1388             //verify value
1389 
1390         require(msg.value>=price*amount, "Please send more ETH");
1391 
1392         
1393 
1394         
1395 
1396             //verify mint is not above max avail
1397 
1398         require(salePointer+amount<saleMax, "There are not that many available");
1399 
1400         
1401 
1402             //verify start date
1403 
1404         require(startDate==0||startDate<block.timestamp, "Sale not yet started");
1405 
1406 
1407 
1408             //set mint count
1409 
1410         mintCount[msg.sender]+=amount;
1411 
1412 
1413 
1414             //verify maxx
1415 
1416         require(mintCount[msg.sender]<=mintMax, "You may not mint this many");
1417 
1418                 
1419 
1420 
1421 
1422         for(uint256 i = 0; i<amount; i++){
1423 
1424                 //mint token
1425 
1426             _mint(msg.sender,salePointer);
1427 
1428                 
1429 
1430                 //increse pointer
1431 
1432             salePointer++;
1433 
1434 
1435 
1436 
1437 
1438         }
1439 
1440 
1441 
1442         distReciever.transfer(distPrice*amount);
1443 
1444     
1445 
1446     }
1447 
1448 
1449 
1450     function mintProxy(address buyer) public payable{
1451 
1452             //verify mint contract
1453 
1454         require(msg.sender==mintContract, "You can not use this function");
1455 
1456 
1457 
1458         _mint(buyer,salePointer);
1459 
1460         salePointer++;
1461 
1462     }
1463 
1464 
1465 
1466 
1467 
1468 
1469 
1470     //calls
1471 
1472     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1473 
1474         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1475 
1476 
1477 
1478         return string(abi.encodePacked(baseTokenURI, uint2str(tokenId)));
1479 
1480         
1481 
1482         //return urilist[tokenId];
1483 
1484     }
1485 
1486 
1487 
1488     
1489 
1490         //admin
1491 
1492     
1493 
1494         //edit
1495 
1496     function editWhitelist(address payable[] memory users, bool whitelisted) external onlyAdmin{
1497 
1498         //itterate
1499 
1500 
1501 
1502         for(uint256 i=0;i<users.length;i++){
1503 
1504                 //whitelist
1505 
1506             whitelist[users[i]]=whitelisted;
1507 
1508         }
1509 
1510     }
1511 
1512 
1513 
1514     function toggleWhitelist(bool whitelisted) external onlyAdmin{
1515 
1516         saleWhitelisted=whitelisted;
1517 
1518     }
1519 
1520 
1521 
1522 
1523 
1524     function changeStart(uint256 saleStart) public onlyAdmin{
1525 
1526             //set end date
1527 
1528         startDate=saleStart;
1529 
1530         
1531 
1532     }
1533 
1534         //set mint max 
1535 
1536         
1537 
1538     function setMintMax(uint256 newMintMax) public onlyAdmin{
1539 
1540         
1541 
1542             //change mint max
1543 
1544         mintMax = newMintMax;
1545 
1546         
1547 
1548     }
1549 
1550         //set sale max 
1551 
1552         
1553 
1554     function setSaleMax(uint256 newSaleMax) public onlyAdmin{
1555 
1556         
1557 
1558             //change mint max
1559 
1560         saleMax = newSaleMax;
1561 
1562         
1563 
1564     }
1565 
1566     
1567 
1568         //edit pointer 
1569 
1570         
1571 
1572     function setMintPointer(uint256 mintPointer) public onlyAdmin{
1573 
1574             //change mint max
1575 
1576         salePointer = mintPointer;
1577 
1578         
1579 
1580     }
1581 
1582     
1583 
1584         //set price
1585 
1586     function editPrice(uint256 newPrice) external onlyAdmin{
1587 
1588         price=newPrice;
1589 
1590     }
1591 
1592         //set dist price
1593 
1594     function editDistPrice(uint256 newDistPrice) external onlyAdmin{
1595 
1596         distPrice=newDistPrice;
1597 
1598     }
1599 
1600 
1601 
1602         //set minter
1603 
1604     function editDistReciever(address payable newDistReciever) external onlyAdmin{
1605 
1606         distReciever=newDistReciever;
1607 
1608     }
1609 
1610         //set minter
1611 
1612     function editMinter(address payable newMinter) external onlyAdmin{
1613 
1614         mintContract=newMinter;
1615 
1616     }
1617 
1618 
1619 
1620     
1621 
1622     function setTokenURI(string memory _tokenURI) public virtual {
1623 
1624         require(whitelist[msg.sender]==true, "User is not whitelisted");
1625 
1626         baseTokenURI=_tokenURI;
1627 
1628     }
1629 
1630 
1631 
1632     function widthdraw(uint256 amount, address payable reciever) public payable onlyAdmin{
1633 
1634         
1635 
1636             //widthdraw
1637 
1638         payable(reciever).transfer(amount);
1639 
1640     }
1641 
1642     
1643 
1644     //utils
1645 
1646      function uint2str(
1647 
1648       uint256 _i
1649 
1650     )
1651 
1652       internal
1653 
1654       pure
1655 
1656       returns (string memory str)
1657 
1658     {
1659 
1660         if (_i == 0)
1661 
1662         {
1663 
1664         return "0";
1665 
1666         }
1667 
1668         uint256 j = _i;
1669 
1670         uint256 length;
1671 
1672         while (j != 0)
1673 
1674         {
1675 
1676         length++;
1677 
1678         j /= 10;
1679 
1680         }
1681 
1682         bytes memory bstr = new bytes(length);
1683 
1684         uint256 k = length;
1685 
1686         j = _i;
1687 
1688         while (j != 0)
1689 
1690         {
1691 
1692         bstr[--k] = bytes1(uint8(48 + j % 10));
1693 
1694         j /= 10;
1695 
1696         }
1697 
1698         str = string(bstr);
1699 
1700     }
1701 
1702 
1703 
1704 
1705 
1706 }