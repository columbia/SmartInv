1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
3 
4 
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @title ERC721 token receiver interface
10  * @dev Interface for any contract that wants to support safeTransfers
11  * from ERC721 asset contracts.
12  */
13 interface IERC721Receiver {
14     /**
15      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
16      * by `operator` from `from`, this function is called.
17      *
18      * It must return its Solidity selector to confirm the token transfer.
19      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
20      *
21      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
22      */
23     function onERC721Received(
24         address operator,
25         address from,
26         uint256 tokenId,
27         bytes calldata data
28     ) external returns (bytes4);
29 }
30 
31 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
32 
33 
34 
35 pragma solidity ^0.8.0;
36 
37 /**
38  * @dev Interface of the ERC165 standard, as defined in the
39  * https://eips.ethereum.org/EIPS/eip-165[EIP].
40  *
41  * Implementers can declare support of contract interfaces, which can then be
42  * queried by others ({ERC165Checker}).
43  *
44  * For an implementation, see {ERC165}.
45  */
46 interface IERC165 {
47     /**
48      * @dev Returns true if this contract implements the interface defined by
49      * `interfaceId`. See the corresponding
50      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
51      * to learn more about how these ids are created.
52      *
53      * This function call must use less than 30 000 gas.
54      */
55     function supportsInterface(bytes4 interfaceId) external view returns (bool);
56 }
57 
58 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
59 
60 
61 
62 pragma solidity ^0.8.0;
63 
64 
65 /**
66  * @dev Implementation of the {IERC165} interface.
67  *
68  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
69  * for the additional interface id that will be supported. For example:
70  *
71  * ```solidity
72  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
73  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
74  * }
75  * ```
76  *
77  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
78  */
79 abstract contract ERC165 is IERC165 {
80     /**
81      * @dev See {IERC165-supportsInterface}.
82      */
83     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
84         return interfaceId == type(IERC165).interfaceId;
85     }
86 }
87 
88 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
89 
90 
91 
92 pragma solidity ^0.8.0;
93 
94 
95 /**
96  * @dev Required interface of an ERC721 compliant contract.
97  */
98 interface IERC721 is IERC165 {
99     /**
100      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
101      */
102     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
103 
104     /**
105      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
106      */
107     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
108 
109     /**
110      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
111      */
112     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
113 
114     /**
115      * @dev Returns the number of tokens in ``owner``'s account.
116      */
117     function balanceOf(address owner) external view returns (uint256 balance);
118 
119     /**
120      * @dev Returns the owner of the `tokenId` token.
121      *
122      * Requirements:
123      *
124      * - `tokenId` must exist.
125      */
126     function ownerOf(uint256 tokenId) external view returns (address owner);
127 
128     /**
129      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
130      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
131      *
132      * Requirements:
133      *
134      * - `from` cannot be the zero address.
135      * - `to` cannot be the zero address.
136      * - `tokenId` token must exist and be owned by `from`.
137      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
138      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
139      *
140      * Emits a {Transfer} event.
141      */
142     function safeTransferFrom(
143         address from,
144         address to,
145         uint256 tokenId
146     ) external;
147 
148     /**
149      * @dev Transfers `tokenId` token from `from` to `to`.
150      *
151      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
152      *
153      * Requirements:
154      *
155      * - `from` cannot be the zero address.
156      * - `to` cannot be the zero address.
157      * - `tokenId` token must be owned by `from`.
158      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
159      *
160      * Emits a {Transfer} event.
161      */
162     function transferFrom(
163         address from,
164         address to,
165         uint256 tokenId
166     ) external;
167 
168     /**
169      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
170      * The approval is cleared when the token is transferred.
171      *
172      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
173      *
174      * Requirements:
175      *
176      * - The caller must own the token or be an approved operator.
177      * - `tokenId` must exist.
178      *
179      * Emits an {Approval} event.
180      */
181     function approve(address to, uint256 tokenId) external;
182 
183     /**
184      * @dev Returns the account approved for `tokenId` token.
185      *
186      * Requirements:
187      *
188      * - `tokenId` must exist.
189      */
190     function getApproved(uint256 tokenId) external view returns (address operator);
191 
192     /**
193      * @dev Approve or remove `operator` as an operator for the caller.
194      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
195      *
196      * Requirements:
197      *
198      * - The `operator` cannot be the caller.
199      *
200      * Emits an {ApprovalForAll} event.
201      */
202     function setApprovalForAll(address operator, bool _approved) external;
203 
204     /**
205      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
206      *
207      * See {setApprovalForAll}
208      */
209     function isApprovedForAll(address owner, address operator) external view returns (bool);
210 
211     /**
212      * @dev Safely transfers `tokenId` token from `from` to `to`.
213      *
214      * Requirements:
215      *
216      * - `from` cannot be the zero address.
217      * - `to` cannot be the zero address.
218      * - `tokenId` token must exist and be owned by `from`.
219      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
220      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
221      *
222      * Emits a {Transfer} event.
223      */
224     function safeTransferFrom(
225         address from,
226         address to,
227         uint256 tokenId,
228         bytes calldata data
229     ) external;
230 }
231 
232 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
233 
234 
235 
236 pragma solidity ^0.8.0;
237 
238 
239 /**
240  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
241  * @dev See https://eips.ethereum.org/EIPS/eip-721
242  */
243 interface IERC721Enumerable is IERC721 {
244     /**
245      * @dev Returns the total amount of tokens stored by the contract.
246      */
247     function totalSupply() external view returns (uint256);
248 
249     /**
250      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
251      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
252      */
253     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
254 
255     /**
256      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
257      * Use along with {totalSupply} to enumerate all tokens.
258      */
259     function tokenByIndex(uint256 index) external view returns (uint256);
260 }
261 
262 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
263 
264 
265 
266 pragma solidity ^0.8.0;
267 
268 
269 /**
270  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
271  * @dev See https://eips.ethereum.org/EIPS/eip-721
272  */
273 interface IERC721Metadata is IERC721 {
274     /**
275      * @dev Returns the token collection name.
276      */
277     function name() external view returns (string memory);
278 
279     /**
280      * @dev Returns the token collection symbol.
281      */
282     function symbol() external view returns (string memory);
283 
284     /**
285      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
286      */
287     function tokenURI(uint256 tokenId) external view returns (string memory);
288 }
289 
290 // File: @openzeppelin/contracts/utils/Context.sol
291 
292 
293 
294 pragma solidity ^0.8.0;
295 
296 /**
297  * @dev Provides information about the current execution context, including the
298  * sender of the transaction and its data. While these are generally available
299  * via msg.sender and msg.data, they should not be accessed in such a direct
300  * manner, since when dealing with meta-transactions the account sending and
301  * paying for execution may not be the actual sender (as far as an application
302  * is concerned).
303  *
304  * This contract is only required for intermediate, library-like contracts.
305  */
306 abstract contract Context {
307     function _msgSender() internal view virtual returns (address) {
308         return msg.sender;
309     }
310 
311     function _msgData() internal view virtual returns (bytes calldata) {
312         return msg.data;
313     }
314 }
315 
316 // File: @openzeppelin/contracts/access/Ownable.sol
317 
318 
319 
320 pragma solidity ^0.8.0;
321 
322 
323 /**
324  * @dev Contract module which provides a basic access control mechanism, where
325  * there is an account (an owner) that can be granted exclusive access to
326  * specific functions.
327  *
328  * By default, the owner account will be the one that deploys the contract. This
329  * can later be changed with {transferOwnership}.
330  *
331  * This module is used through inheritance. It will make available the modifier
332  * `onlyOwner`, which can be applied to your functions to restrict their use to
333  * the owner.
334  */
335 abstract contract Ownable is Context {
336     address private _owner;
337 
338     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
339 
340     /**
341      * @dev Initializes the contract setting the deployer as the initial owner.
342      */
343     constructor() {
344         _setOwner(_msgSender());
345     }
346 
347     /**
348      * @dev Returns the address of the current owner.
349      */
350     function owner() public view virtual returns (address) {
351         return _owner;
352     }
353 
354     /**
355      * @dev Throws if called by any account other than the owner.
356      */
357     modifier onlyOwner() {
358         require(owner() == _msgSender(), "Ownable: caller is not the owner");
359         _;
360     }
361 
362     /**
363      * @dev Leaves the contract without owner. It will not be possible to call
364      * `onlyOwner` functions anymore. Can only be called by the current owner.
365      *
366      * NOTE: Renouncing ownership will leave the contract without an owner,
367      * thereby removing any functionality that is only available to the owner.
368      */
369     function renounceOwnership() public virtual onlyOwner {
370         _setOwner(address(0));
371     }
372 
373     /**
374      * @dev Transfers ownership of the contract to a new account (`newOwner`).
375      * Can only be called by the current owner.
376      */
377     function transferOwnership(address newOwner) public virtual onlyOwner {
378         require(newOwner != address(0), "Ownable: new owner is the zero address");
379         _setOwner(newOwner);
380     }
381 
382     function _setOwner(address newOwner) private {
383         address oldOwner = _owner;
384         _owner = newOwner;
385         emit OwnershipTransferred(oldOwner, newOwner);
386     }
387 }
388 
389 // File: @openzeppelin/contracts/utils/Address.sol
390 
391 
392 
393 pragma solidity ^0.8.0;
394 
395 /**
396  * @dev Collection of functions related to the address type
397  */
398 library Address {
399     /**
400      * @dev Returns true if `account` is a contract.
401      *
402      * [IMPORTANT]
403      * ====
404      * It is unsafe to assume that an address for which this function returns
405      * false is an externally-owned account (EOA) and not a contract.
406      *
407      * Among others, `isContract` will return false for the following
408      * types of addresses:
409      *
410      *  - an externally-owned account
411      *  - a contract in construction
412      *  - an address where a contract will be created
413      *  - an address where a contract lived, but was destroyed
414      * ====
415      */
416     function isContract(address account) internal view returns (bool) {
417         // This method relies on extcodesize, which returns 0 for contracts in
418         // construction, since the code is only stored at the end of the
419         // constructor execution.
420 
421         uint256 size;
422         assembly {
423             size := extcodesize(account)
424         }
425         return size > 0;
426     }
427 
428     /**
429      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
430      * `recipient`, forwarding all available gas and reverting on errors.
431      *
432      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
433      * of certain opcodes, possibly making contracts go over the 2300 gas limit
434      * imposed by `transfer`, making them unable to receive funds via
435      * `transfer`. {sendValue} removes this limitation.
436      *
437      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
438      *
439      * IMPORTANT: because control is transferred to `recipient`, care must be
440      * taken to not create reentrancy vulnerabilities. Consider using
441      * {ReentrancyGuard} or the
442      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
443      */
444     function sendValue(address payable recipient, uint256 amount) internal {
445         require(address(this).balance >= amount, "Address: insufficient balance");
446 
447         (bool success, ) = recipient.call{value: amount}("");
448         require(success, "Address: unable to send value, recipient may have reverted");
449     }
450 
451     /**
452      * @dev Performs a Solidity function call using a low level `call`. A
453      * plain `call` is an unsafe replacement for a function call: use this
454      * function instead.
455      *
456      * If `target` reverts with a revert reason, it is bubbled up by this
457      * function (like regular Solidity function calls).
458      *
459      * Returns the raw returned data. To convert to the expected return value,
460      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
461      *
462      * Requirements:
463      *
464      * - `target` must be a contract.
465      * - calling `target` with `data` must not revert.
466      *
467      * _Available since v3.1._
468      */
469     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
470         return functionCall(target, data, "Address: low-level call failed");
471     }
472 
473     /**
474      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
475      * `errorMessage` as a fallback revert reason when `target` reverts.
476      *
477      * _Available since v3.1._
478      */
479     function functionCall(
480         address target,
481         bytes memory data,
482         string memory errorMessage
483     ) internal returns (bytes memory) {
484         return functionCallWithValue(target, data, 0, errorMessage);
485     }
486 
487     /**
488      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
489      * but also transferring `value` wei to `target`.
490      *
491      * Requirements:
492      *
493      * - the calling contract must have an ETH balance of at least `value`.
494      * - the called Solidity function must be `payable`.
495      *
496      * _Available since v3.1._
497      */
498     function functionCallWithValue(
499         address target,
500         bytes memory data,
501         uint256 value
502     ) internal returns (bytes memory) {
503         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
504     }
505 
506     /**
507      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
508      * with `errorMessage` as a fallback revert reason when `target` reverts.
509      *
510      * _Available since v3.1._
511      */
512     function functionCallWithValue(
513         address target,
514         bytes memory data,
515         uint256 value,
516         string memory errorMessage
517     ) internal returns (bytes memory) {
518         require(address(this).balance >= value, "Address: insufficient balance for call");
519         require(isContract(target), "Address: call to non-contract");
520 
521         (bool success, bytes memory returndata) = target.call{value: value}(data);
522         return verifyCallResult(success, returndata, errorMessage);
523     }
524 
525     /**
526      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
527      * but performing a static call.
528      *
529      * _Available since v3.3._
530      */
531     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
532         return functionStaticCall(target, data, "Address: low-level static call failed");
533     }
534 
535     /**
536      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
537      * but performing a static call.
538      *
539      * _Available since v3.3._
540      */
541     function functionStaticCall(
542         address target,
543         bytes memory data,
544         string memory errorMessage
545     ) internal view returns (bytes memory) {
546         require(isContract(target), "Address: static call to non-contract");
547 
548         (bool success, bytes memory returndata) = target.staticcall(data);
549         return verifyCallResult(success, returndata, errorMessage);
550     }
551 
552     /**
553      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
554      * but performing a delegate call.
555      *
556      * _Available since v3.4._
557      */
558     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
559         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
560     }
561 
562     /**
563      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
564      * but performing a delegate call.
565      *
566      * _Available since v3.4._
567      */
568     function functionDelegateCall(
569         address target,
570         bytes memory data,
571         string memory errorMessage
572     ) internal returns (bytes memory) {
573         require(isContract(target), "Address: delegate call to non-contract");
574 
575         (bool success, bytes memory returndata) = target.delegatecall(data);
576         return verifyCallResult(success, returndata, errorMessage);
577     }
578 
579     /**
580      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
581      * revert reason using the provided one.
582      *
583      * _Available since v4.3._
584      */
585     function verifyCallResult(
586         bool success,
587         bytes memory returndata,
588         string memory errorMessage
589     ) internal pure returns (bytes memory) {
590         if (success) {
591             return returndata;
592         } else {
593             // Look for revert reason and bubble it up if present
594             if (returndata.length > 0) {
595                 // The easiest way to bubble the revert reason is using memory via assembly
596 
597                 assembly {
598                     let returndata_size := mload(returndata)
599                     revert(add(32, returndata), returndata_size)
600                 }
601             } else {
602                 revert(errorMessage);
603             }
604         }
605     }
606 }
607 
608 // File: @openzeppelin/contracts/utils/Strings.sol
609 
610 
611 
612 pragma solidity ^0.8.0;
613 
614 /**
615  * @dev String operations.
616  */
617 library Strings {
618     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
619 
620     /**
621      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
622      */
623     function toString(uint256 value) internal pure returns (string memory) {
624         // Inspired by OraclizeAPI's implementation - MIT licence
625         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
626 
627         if (value == 0) {
628             return "0";
629         }
630         uint256 temp = value;
631         uint256 digits;
632         while (temp != 0) {
633             digits++;
634             temp /= 10;
635         }
636         bytes memory buffer = new bytes(digits);
637         while (value != 0) {
638             digits -= 1;
639             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
640             value /= 10;
641         }
642         return string(buffer);
643     }
644 
645     /**
646      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
647      */
648     function toHexString(uint256 value) internal pure returns (string memory) {
649         if (value == 0) {
650             return "0x00";
651         }
652         uint256 temp = value;
653         uint256 length = 0;
654         while (temp != 0) {
655             length++;
656             temp >>= 8;
657         }
658         return toHexString(value, length);
659     }
660 
661     /**
662      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
663      */
664     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
665         bytes memory buffer = new bytes(2 * length + 2);
666         buffer[0] = "0";
667         buffer[1] = "x";
668         for (uint256 i = 2 * length + 1; i > 1; --i) {
669             buffer[i] = _HEX_SYMBOLS[value & 0xf];
670             value >>= 4;
671         }
672         require(value == 0, "Strings: hex length insufficient");
673         return string(buffer);
674     }
675 }
676 
677 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
678 
679 
680 
681 pragma solidity ^0.8.0;
682 
683 
684 
685 
686 
687 
688 
689 
690 /**
691  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
692  * the Metadata extension, but not including the Enumerable extension, which is available separately as
693  * {ERC721Enumerable}.
694  */
695 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
696     using Address for address;
697     using Strings for uint256;
698 
699     // Token name
700     string private _name;
701 
702     // Token symbol
703     string private _symbol;
704 
705     // Mapping from token ID to owner address
706     mapping(uint256 => address) private _owners;
707 
708     // Mapping owner address to token count
709     mapping(address => uint256) private _balances;
710 
711     // Mapping from token ID to approved address
712     mapping(uint256 => address) private _tokenApprovals;
713 
714     // Mapping from owner to operator approvals
715     mapping(address => mapping(address => bool)) private _operatorApprovals;
716 
717     /**
718      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
719      */
720     constructor(string memory name_, string memory symbol_) {
721         _name = name_;
722         _symbol = symbol_;
723     }
724 
725     /**
726      * @dev See {IERC165-supportsInterface}.
727      */
728     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
729         return
730             interfaceId == type(IERC721).interfaceId ||
731             interfaceId == type(IERC721Metadata).interfaceId ||
732             super.supportsInterface(interfaceId);
733     }
734 
735     /**
736      * @dev See {IERC721-balanceOf}.
737      */
738     function balanceOf(address owner) public view virtual override returns (uint256) {
739         require(owner != address(0), "ERC721: balance query for the zero address");
740         return _balances[owner];
741     }
742 
743     /**
744      * @dev See {IERC721-ownerOf}.
745      */
746     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
747         address owner = _owners[tokenId];
748         require(owner != address(0), "ERC721: owner query for nonexistent token");
749         return owner;
750     }
751 
752     /**
753      * @dev See {IERC721Metadata-name}.
754      */
755     function name() public view virtual override returns (string memory) {
756         return _name;
757     }
758 
759     /**
760      * @dev See {IERC721Metadata-symbol}.
761      */
762     function symbol() public view virtual override returns (string memory) {
763         return _symbol;
764     }
765 
766     /**
767      * @dev See {IERC721Metadata-tokenURI}.
768      */
769     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
770         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
771 
772         string memory baseURI = _baseURI();
773         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
774     }
775 
776     /**
777      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
778      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
779      * by default, can be overriden in child contracts.
780      */
781     function _baseURI() internal view virtual returns (string memory) {
782         return "";
783     }
784 
785     /**
786      * @dev See {IERC721-approve}.
787      */
788     function approve(address to, uint256 tokenId) public virtual override {
789         address owner = ERC721.ownerOf(tokenId);
790         require(to != owner, "ERC721: approval to current owner");
791 
792         require(
793             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
794             "ERC721: approve caller is not owner nor approved for all"
795         );
796 
797         _approve(to, tokenId);
798     }
799 
800     /**
801      * @dev See {IERC721-getApproved}.
802      */
803     function getApproved(uint256 tokenId) public view virtual override returns (address) {
804         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
805 
806         return _tokenApprovals[tokenId];
807     }
808 
809     /**
810      * @dev See {IERC721-setApprovalForAll}.
811      */
812     function setApprovalForAll(address operator, bool approved) public virtual override {
813         require(operator != _msgSender(), "ERC721: approve to caller");
814 
815         _operatorApprovals[_msgSender()][operator] = approved;
816         emit ApprovalForAll(_msgSender(), operator, approved);
817     }
818 
819     /**
820      * @dev See {IERC721-isApprovedForAll}.
821      */
822     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
823         return _operatorApprovals[owner][operator];
824     }
825 
826     /**
827      * @dev See {IERC721-transferFrom}.
828      */
829     function transferFrom(
830         address from,
831         address to,
832         uint256 tokenId
833     ) public virtual override {
834         //solhint-disable-next-line max-line-length
835         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
836 
837         _transfer(from, to, tokenId);
838     }
839 
840     /**
841      * @dev See {IERC721-safeTransferFrom}.
842      */
843     function safeTransferFrom(
844         address from,
845         address to,
846         uint256 tokenId
847     ) public virtual override {
848         safeTransferFrom(from, to, tokenId, "");
849     }
850 
851     /**
852      * @dev See {IERC721-safeTransferFrom}.
853      */
854     function safeTransferFrom(
855         address from,
856         address to,
857         uint256 tokenId,
858         bytes memory _data
859     ) public virtual override {
860         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
861         _safeTransfer(from, to, tokenId, _data);
862     }
863 
864     /**
865      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
866      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
867      *
868      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
869      *
870      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
871      * implement alternative mechanisms to perform token transfer, such as signature-based.
872      *
873      * Requirements:
874      *
875      * - `from` cannot be the zero address.
876      * - `to` cannot be the zero address.
877      * - `tokenId` token must exist and be owned by `from`.
878      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
879      *
880      * Emits a {Transfer} event.
881      */
882     function _safeTransfer(
883         address from,
884         address to,
885         uint256 tokenId,
886         bytes memory _data
887     ) internal virtual {
888         _transfer(from, to, tokenId);
889         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
890     }
891 
892     /**
893      * @dev Returns whether `tokenId` exists.
894      *
895      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
896      *
897      * Tokens start existing when they are minted (`_mint`),
898      * and stop existing when they are burned (`_burn`).
899      */
900     function _exists(uint256 tokenId) internal view virtual returns (bool) {
901         return _owners[tokenId] != address(0);
902     }
903 
904     /**
905      * @dev Returns whether `spender` is allowed to manage `tokenId`.
906      *
907      * Requirements:
908      *
909      * - `tokenId` must exist.
910      */
911     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
912         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
913         address owner = ERC721.ownerOf(tokenId);
914         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
915     }
916 
917     /**
918      * @dev Safely mints `tokenId` and transfers it to `to`.
919      *
920      * Requirements:
921      *
922      * - `tokenId` must not exist.
923      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
924      *
925      * Emits a {Transfer} event.
926      */
927     function _safeMint(address to, uint256 tokenId) internal virtual {
928         _safeMint(to, tokenId, "");
929     }
930 
931     /**
932      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
933      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
934      */
935     function _safeMint(
936         address to,
937         uint256 tokenId,
938         bytes memory _data
939     ) internal virtual {
940         _mint(to, tokenId);
941         require(
942             _checkOnERC721Received(address(0), to, tokenId, _data),
943             "ERC721: transfer to non ERC721Receiver implementer"
944         );
945     }
946 
947     /**
948      * @dev Mints `tokenId` and transfers it to `to`.
949      *
950      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
951      *
952      * Requirements:
953      *
954      * - `tokenId` must not exist.
955      * - `to` cannot be the zero address.
956      *
957      * Emits a {Transfer} event.
958      */
959     function _mint(address to, uint256 tokenId) internal virtual {
960         require(to != address(0), "ERC721: mint to the zero address");
961         require(!_exists(tokenId), "ERC721: token already minted");
962 
963         _beforeTokenTransfer(address(0), to, tokenId);
964 
965         _balances[to] += 1;
966         _owners[tokenId] = to;
967 
968         emit Transfer(address(0), to, tokenId);
969     }
970 
971     /**
972      * @dev Destroys `tokenId`.
973      * The approval is cleared when the token is burned.
974      *
975      * Requirements:
976      *
977      * - `tokenId` must exist.
978      *
979      * Emits a {Transfer} event.
980      */
981     function _burn(uint256 tokenId) internal virtual {
982         address owner = ERC721.ownerOf(tokenId);
983 
984         _beforeTokenTransfer(owner, address(0), tokenId);
985 
986         // Clear approvals
987         _approve(address(0), tokenId);
988 
989         _balances[owner] -= 1;
990         delete _owners[tokenId];
991 
992         emit Transfer(owner, address(0), tokenId);
993     }
994 
995     /**
996      * @dev Transfers `tokenId` from `from` to `to`.
997      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
998      *
999      * Requirements:
1000      *
1001      * - `to` cannot be the zero address.
1002      * - `tokenId` token must be owned by `from`.
1003      *
1004      * Emits a {Transfer} event.
1005      */
1006     function _transfer(
1007         address from,
1008         address to,
1009         uint256 tokenId
1010     ) internal virtual {
1011         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1012         require(to != address(0), "ERC721: transfer to the zero address");
1013 
1014         _beforeTokenTransfer(from, to, tokenId);
1015 
1016         // Clear approvals from the previous owner
1017         _approve(address(0), tokenId);
1018 
1019         _balances[from] -= 1;
1020         _balances[to] += 1;
1021         _owners[tokenId] = to;
1022 
1023         emit Transfer(from, to, tokenId);
1024     }
1025 
1026     /**
1027      * @dev Approve `to` to operate on `tokenId`
1028      *
1029      * Emits a {Approval} event.
1030      */
1031     function _approve(address to, uint256 tokenId) internal virtual {
1032         _tokenApprovals[tokenId] = to;
1033         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1034     }
1035 
1036     /**
1037      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1038      * The call is not executed if the target address is not a contract.
1039      *
1040      * @param from address representing the previous owner of the given token ID
1041      * @param to target address that will receive the tokens
1042      * @param tokenId uint256 ID of the token to be transferred
1043      * @param _data bytes optional data to send along with the call
1044      * @return bool whether the call correctly returned the expected magic value
1045      */
1046     function _checkOnERC721Received(
1047         address from,
1048         address to,
1049         uint256 tokenId,
1050         bytes memory _data
1051     ) private returns (bool) {
1052         if (to.isContract()) {
1053             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1054                 return retval == IERC721Receiver.onERC721Received.selector;
1055             } catch (bytes memory reason) {
1056                 if (reason.length == 0) {
1057                     revert("ERC721: transfer to non ERC721Receiver implementer");
1058                 } else {
1059                     assembly {
1060                         revert(add(32, reason), mload(reason))
1061                     }
1062                 }
1063             }
1064         } else {
1065             return true;
1066         }
1067     }
1068 
1069     /**
1070      * @dev Hook that is called before any token transfer. This includes minting
1071      * and burning.
1072      *
1073      * Calling conditions:
1074      *
1075      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1076      * transferred to `to`.
1077      * - When `from` is zero, `tokenId` will be minted for `to`.
1078      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1079      * - `from` and `to` are never both zero.
1080      *
1081      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1082      */
1083     function _beforeTokenTransfer(
1084         address from,
1085         address to,
1086         uint256 tokenId
1087     ) internal virtual {}
1088 }
1089 
1090 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1091 
1092 
1093 
1094 pragma solidity ^0.8.0;
1095 
1096 
1097 
1098 /**
1099  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1100  * enumerability of all the token ids in the contract as well as all token ids owned by each
1101  * account.
1102  */
1103 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1104     // Mapping from owner to list of owned token IDs
1105     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1106 
1107     // Mapping from token ID to index of the owner tokens list
1108     mapping(uint256 => uint256) private _ownedTokensIndex;
1109 
1110     // Array with all token ids, used for enumeration
1111     uint256[] private _allTokens;
1112 
1113     // Mapping from token id to position in the allTokens array
1114     mapping(uint256 => uint256) private _allTokensIndex;
1115 
1116     /**
1117      * @dev See {IERC165-supportsInterface}.
1118      */
1119     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1120         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1121     }
1122 
1123     /**
1124      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1125      */
1126     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1127         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1128         return _ownedTokens[owner][index];
1129     }
1130 
1131     /**
1132      * @dev See {IERC721Enumerable-totalSupply}.
1133      */
1134     function totalSupply() public view virtual override returns (uint256) {
1135         return _allTokens.length;
1136     }
1137 
1138     /**
1139      * @dev See {IERC721Enumerable-tokenByIndex}.
1140      */
1141     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1142         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1143         return _allTokens[index];
1144     }
1145 
1146     /**
1147      * @dev Hook that is called before any token transfer. This includes minting
1148      * and burning.
1149      *
1150      * Calling conditions:
1151      *
1152      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1153      * transferred to `to`.
1154      * - When `from` is zero, `tokenId` will be minted for `to`.
1155      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1156      * - `from` cannot be the zero address.
1157      * - `to` cannot be the zero address.
1158      *
1159      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1160      */
1161     function _beforeTokenTransfer(
1162         address from,
1163         address to,
1164         uint256 tokenId
1165     ) internal virtual override {
1166         super._beforeTokenTransfer(from, to, tokenId);
1167 
1168         if (from == address(0)) {
1169             _addTokenToAllTokensEnumeration(tokenId);
1170         } else if (from != to) {
1171             _removeTokenFromOwnerEnumeration(from, tokenId);
1172         }
1173         if (to == address(0)) {
1174             _removeTokenFromAllTokensEnumeration(tokenId);
1175         } else if (to != from) {
1176             _addTokenToOwnerEnumeration(to, tokenId);
1177         }
1178     }
1179 
1180     /**
1181      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1182      * @param to address representing the new owner of the given token ID
1183      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1184      */
1185     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1186         uint256 length = ERC721.balanceOf(to);
1187         _ownedTokens[to][length] = tokenId;
1188         _ownedTokensIndex[tokenId] = length;
1189     }
1190 
1191     /**
1192      * @dev Private function to add a token to this extension's token tracking data structures.
1193      * @param tokenId uint256 ID of the token to be added to the tokens list
1194      */
1195     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1196         _allTokensIndex[tokenId] = _allTokens.length;
1197         _allTokens.push(tokenId);
1198     }
1199 
1200     /**
1201      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1202      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1203      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1204      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1205      * @param from address representing the previous owner of the given token ID
1206      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1207      */
1208     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1209         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1210         // then delete the last slot (swap and pop).
1211 
1212         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1213         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1214 
1215         // When the token to delete is the last token, the swap operation is unnecessary
1216         if (tokenIndex != lastTokenIndex) {
1217             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1218 
1219             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1220             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1221         }
1222 
1223         // This also deletes the contents at the last position of the array
1224         delete _ownedTokensIndex[tokenId];
1225         delete _ownedTokens[from][lastTokenIndex];
1226     }
1227 
1228     /**
1229      * @dev Private function to remove a token from this extension's token tracking data structures.
1230      * This has O(1) time complexity, but alters the order of the _allTokens array.
1231      * @param tokenId uint256 ID of the token to be removed from the tokens list
1232      */
1233     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1234         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1235         // then delete the last slot (swap and pop).
1236 
1237         uint256 lastTokenIndex = _allTokens.length - 1;
1238         uint256 tokenIndex = _allTokensIndex[tokenId];
1239 
1240         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1241         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1242         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1243         uint256 lastTokenId = _allTokens[lastTokenIndex];
1244 
1245         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1246         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1247 
1248         // This also deletes the contents at the last position of the array
1249         delete _allTokensIndex[tokenId];
1250         _allTokens.pop();
1251     }
1252 }
1253 
1254 // File: The Planet of Hares/ThePlanetOfHares.sol
1255 
1256 
1257 pragma solidity ^0.8.0;
1258 
1259 
1260 
1261 
1262 
1263 
1264 contract ThePlanetOfHares is ERC721Enumerable, Ownable {
1265     using Address for address;
1266     using Strings for uint256;
1267 
1268     address public multiSigWallet;
1269 
1270     uint256 public constant MAX_SUPPLY = 10000;
1271 
1272     uint256 public constant NFT_PRICE_PRESALE = 60000000000000000; // 0.06 ETH
1273     uint256 public constant NFT_PRICE = 80000000000000000; // 0.08 ETH
1274 
1275     uint256 public constant MIN_NFT_PURCHASE_PRESALE = 10;
1276     uint256 public constant MAX_NFT_PURCHASE_PRESALE = 50;
1277 
1278     uint256 public constant MIN_NFT_PURCHASE = 1;
1279     uint256 public constant MAX_NFT_PURCHASE = 10;
1280     
1281     uint256 public hareReserve = 100;
1282     bool public saleIsActive = false;
1283     bool public presaleIsActive = false;
1284     bool public isMetadataLocked = false;
1285 
1286     string private _baseURIExtended;
1287 
1288     modifier OnlyMultiSignWallet() {
1289         require(multiSigWallet == _msgSender(), "Caller is not the multiSigWallet");
1290         _;
1291     }
1292 
1293     constructor(address _multiSigWallet) ERC721("The Planet of Hares","HARES") {
1294         multiSigWallet = _multiSigWallet;
1295     }
1296 
1297     function withdraw(uint256 _amount, address payable _recipient) public OnlyMultiSignWallet {
1298         uint balance = address(this).balance;
1299         require(_amount <= balance, 'Not enough ether left');
1300         require(_recipient != address(0), 'Withdraw to the zero address');
1301         
1302         _recipient.transfer(_amount);
1303     }
1304 
1305     function flipPresaleState() public onlyOwner {
1306         presaleIsActive = !presaleIsActive;
1307     }
1308     
1309     function flipSaleState() public onlyOwner {
1310         saleIsActive = !saleIsActive;
1311     }
1312     
1313     function flipPresaleStateAndSaleState() public onlyOwner {
1314         presaleIsActive = !presaleIsActive;
1315         saleIsActive = !saleIsActive;
1316     }
1317     
1318     function lockMetadata() public onlyOwner {
1319         isMetadataLocked = true;
1320     }
1321 
1322     function reserveHares(address _to, uint256 _reserveAmount) public onlyOwner {
1323         uint256 supply = totalSupply();
1324         require(_reserveAmount > 0 && _reserveAmount <= hareReserve, "Not enough reserve left for team");
1325         for (uint256 i = 0; i < _reserveAmount; i++) {
1326             _safeMint(_to, supply + i);
1327         }
1328         hareReserve = hareReserve - _reserveAmount;
1329     }
1330     
1331     function mintHarePresale(uint numberOfTokens) public payable {
1332         require(presaleIsActive, "Presale is not active at the moment");
1333         require(numberOfTokens >= MIN_NFT_PURCHASE_PRESALE, "Number of tokens can not be less than 10");
1334         require(numberOfTokens <= MAX_NFT_PURCHASE_PRESALE, "Number of tokens can not be more than 30");
1335         require(NFT_PRICE_PRESALE * numberOfTokens <= msg.value, "Sent ether value is incorrect");
1336         
1337         for (uint i = 0; i < numberOfTokens; i++) {
1338             _safeMint(msg.sender,  totalSupply());
1339         }
1340     }
1341 
1342     function mintHare(uint numberOfTokens) public payable {
1343         require(saleIsActive, "Sale is not active at the moment");
1344         require(numberOfTokens >= MIN_NFT_PURCHASE, "Number of tokens can not be less than 1");
1345         require(numberOfTokens <= MAX_NFT_PURCHASE, "Number of tokens can not be more than 10");
1346         require(totalSupply() + numberOfTokens <= MAX_SUPPLY - hareReserve, "Purchase would exceed max supply of Hares");
1347         require(NFT_PRICE * numberOfTokens <= msg.value, "Sent ether value is incorrect");
1348 
1349         for (uint i = 0; i < numberOfTokens; i++) {
1350             _safeMint(msg.sender, totalSupply());
1351         }
1352     }
1353 
1354     function _baseURI() internal view virtual override returns (string memory) {
1355         return _baseURIExtended;
1356     }
1357 
1358     function setBaseURI(string memory baseURI_) external onlyOwner {
1359         require(!isMetadataLocked,"Metadata is locked");
1360         
1361         _baseURIExtended = baseURI_;
1362     }
1363 
1364     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1365         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1366 
1367         string memory base = _baseURI();
1368         return string(abi.encodePacked(base, tokenId.toString(), '.json'));
1369     }
1370 }