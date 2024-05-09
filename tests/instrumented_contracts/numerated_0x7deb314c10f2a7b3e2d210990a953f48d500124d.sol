1 // SPDX-License-Identifier: MIT
2 
3 
4 pragma solidity >=0.7.0 <0.9.0;
5 
6 /**
7  * @title Counters
8  * @author Matt Condon (@shrugs)
9  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
10  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
11  *
12  * Include with `using Counters for Counters.Counter;`
13  */
14 library Counters {
15     struct Counter {
16         // This variable should never be directly accessed by users of the library: interactions must be restricted to
17         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
18         // this feature: see https://github.com/ethereum/solidity/issues/4637
19         uint256 _value; // default: 0
20     }
21 
22     function current(Counter storage counter) internal view returns (uint256) {
23         return counter._value;
24     }
25 
26     function increment(Counter storage counter) internal {
27         unchecked {
28             counter._value += 1;
29         }
30     }
31 
32     function decrement(Counter storage counter) internal {
33         uint256 value = counter._value;
34         require(value > 0, "Counter: decrement overflow");
35         unchecked {
36             counter._value = value - 1;
37         }
38     }
39 
40     function reset(Counter storage counter) internal {
41         counter._value = 0;
42     }
43 
44     function setInitValue(Counter storage counter , uint256 value) internal{
45          counter._value = value;
46     }
47 }
48 
49 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
50 
51 pragma solidity ^0.8.0;
52 
53 /**
54  * @dev Provides information about the current execution context, including the
55  * sender of the transaction and its data. While these are generally available
56  * via msg.sender and msg.data, they should not be accessed in such a direct
57  * manner, since when dealing with meta-transactions the account sending and
58  * paying for execution may not be the actual sender (as far as an application
59  * is concerned).
60  *
61  * This contract is only required for intermediate, library-like contracts.
62  */
63 abstract contract Context {
64     function _msgSender() internal view virtual returns (address) {
65         return msg.sender;
66     }
67 
68     function _msgData() internal view virtual returns (bytes calldata) {
69         return msg.data;
70     }
71 }
72 
73 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
74 
75 pragma solidity ^0.8.0;
76 
77 /**
78  * @dev Interface of the ERC165 standard, as defined in the
79  * https://eips.ethereum.org/EIPS/eip-165[EIP].
80  *
81  * Implementers can declare support of contract interfaces, which can then be
82  * queried by others ({ERC165Checker}).
83  *
84  * For an implementation, see {ERC165}.
85  */
86 interface IERC165 {
87     /**
88      * @dev Returns true if this contract implements the interface defined by
89      * `interfaceId`. See the corresponding
90      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
91      * to learn more about how these ids are created.
92      *
93      * This function call must use less than 30 000 gas.
94      */
95     function supportsInterface(bytes4 interfaceId) external view returns (bool);
96 }
97 
98 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
99 
100 pragma solidity ^0.8.0;
101 
102 
103 /**
104  * @dev Implementation of the {IERC165} interface.
105  *
106  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
107  * for the additional interface id that will be supported. For example:
108  *
109  * ```solidity
110  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
111  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
112  * }
113  * ```
114  *
115  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
116  */
117 abstract contract ERC165 is IERC165 {
118     /**
119      * @dev See {IERC165-supportsInterface}.
120      */
121     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
122         return interfaceId == type(IERC165).interfaceId;
123     }
124 }
125 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
126 
127 pragma solidity ^0.8.0;
128 
129 /**
130  * @dev Required interface of an ERC721 compliant contract.
131  */
132 interface IERC721 is IERC165 {
133     /**
134      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
135      */
136     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
137 
138     /**
139      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
140      */
141     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
142 
143     /**
144      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
145      */
146     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
147 
148     /**
149      * @dev Returns the number of tokens in ``owner``'s account.
150      */
151     function balanceOf(address owner) external view returns (uint256 balance);
152 
153     /**
154      * @dev Returns the owner of the `tokenId` token.
155      *
156      * Requirements:
157      *
158      * - `tokenId` must exist.
159      */
160     function ownerOf(uint256 tokenId) external view returns (address owner);
161 
162     /**
163      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
164      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
165      *
166      * Requirements:
167      *
168      * - `from` cannot be the zero address.
169      * - `to` cannot be the zero address.
170      * - `tokenId` token must exist and be owned by `from`.
171      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
172      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
173      *
174      * Emits a {Transfer} event.
175      */
176     function safeTransferFrom(
177         address from,
178         address to,
179         uint256 tokenId
180     ) external;
181 
182     /**
183      * @dev Transfers `tokenId` token from `from` to `to`.
184      *
185      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
186      *
187      * Requirements:
188      *
189      * - `from` cannot be the zero address.
190      * - `to` cannot be the zero address.
191      * - `tokenId` token must be owned by `from`.
192      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
193      *
194      * Emits a {Transfer} event.
195      */
196     function transferFrom(
197         address from,
198         address to,
199         uint256 tokenId
200     ) external;
201 
202     /**
203      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
204      * The approval is cleared when the token is transferred.
205      *
206      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
207      *
208      * Requirements:
209      *
210      * - The caller must own the token or be an approved operator.
211      * - `tokenId` must exist.
212      *
213      * Emits an {Approval} event.
214      */
215     function approve(address to, uint256 tokenId) external;
216 
217     /**
218      * @dev Returns the account approved for `tokenId` token.
219      *
220      * Requirements:
221      *
222      * - `tokenId` must exist.
223      */
224     function getApproved(uint256 tokenId) external view returns (address operator);
225 
226     /**
227      * @dev Approve or remove `operator` as an operator for the caller.
228      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
229      *
230      * Requirements:
231      *
232      * - The `operator` cannot be the caller.
233      *
234      * Emits an {ApprovalForAll} event.
235      */
236     function setApprovalForAll(address operator, bool _approved) external;
237 
238     /**
239      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
240      *
241      * See {setApprovalForAll}
242      */
243     function isApprovedForAll(address owner, address operator) external view returns (bool);
244 
245     /**
246      * @dev Safely transfers `tokenId` token from `from` to `to`.
247      *
248      * Requirements:
249      *
250      * - `from` cannot be the zero address.
251      * - `to` cannot be the zero address.
252      * - `tokenId` token must exist and be owned by `from`.
253      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
254      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
255      *
256      * Emits a {Transfer} event.
257      */
258     function safeTransferFrom(
259         address from,
260         address to,
261         uint256 tokenId,
262         bytes calldata data
263     ) external;
264 }
265 
266 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
267 
268 pragma solidity ^0.8.0;
269 
270 /**
271  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
272  * @dev See https://eips.ethereum.org/EIPS/eip-721
273  */
274 interface IERC721Metadata is IERC721 {
275     /**
276      * @dev Returns the token collection name.
277      */
278     function name() external view returns (string memory);
279 
280     /**
281      * @dev Returns the token collection symbol.
282      */
283     function symbol() external view returns (string memory);
284 
285     /**
286      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
287      */
288     function tokenURI(uint256 tokenId) external view returns (string memory);
289 }
290 
291 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
292 
293 pragma solidity ^0.8.0;
294 
295 /**
296  * @dev Collection of functions related to the address type
297  */
298 library Address {
299     /**
300      * @dev Returns true if `account` is a contract.
301      *
302      * [IMPORTANT]
303      * ====
304      * It is unsafe to assume that an address for which this function returns
305      * false is an externally-owned account (EOA) and not a contract.
306      *
307      * Among others, `isContract` will return false for the following
308      * types of addresses:
309      *
310      *  - an externally-owned account
311      *  - a contract in construction
312      *  - an address where a contract will be created
313      *  - an address where a contract lived, but was destroyed
314      * ====
315      */
316     function isContract(address account) internal view returns (bool) {
317         // This method relies on extcodesize, which returns 0 for contracts in
318         // construction, since the code is only stored at the end of the
319         // constructor execution.
320 
321         uint256 size;
322         assembly {
323             size := extcodesize(account)
324         }
325         return size > 0;
326     }
327 
328     /**
329      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
330      * `recipient`, forwarding all available gas and reverting on errors.
331      *
332      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
333      * of certain opcodes, possibly making contracts go over the 2300 gas limit
334      * imposed by `transfer`, making them unable to receive funds via
335      * `transfer`. {sendValue} removes this limitation.
336      *
337      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
338      *
339      * IMPORTANT: because control is transferred to `recipient`, care must be
340      * taken to not create reentrancy vulnerabilities. Consider using
341      * {ReentrancyGuard} or the
342      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
343      */
344     function sendValue(address payable recipient, uint256 amount) internal {
345         require(address(this).balance >= amount, "Address: insufficient balance");
346 
347         (bool success, ) = recipient.call{value: amount}("");
348         require(success, "Address: unable to send value, recipient may have reverted");
349     }
350 
351     /**
352      * @dev Performs a Solidity function call using a low level `call`. A
353      * plain `call` is an unsafe replacement for a function call: use this
354      * function instead.
355      *
356      * If `target` reverts with a revert reason, it is bubbled up by this
357      * function (like regular Solidity function calls).
358      *
359      * Returns the raw returned data. To convert to the expected return value,
360      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
361      *
362      * Requirements:
363      *
364      * - `target` must be a contract.
365      * - calling `target` with `data` must not revert.
366      *
367      * _Available since v3.1._
368      */
369     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
370         return functionCall(target, data, "Address: low-level call failed");
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
375      * `errorMessage` as a fallback revert reason when `target` reverts.
376      *
377      * _Available since v3.1._
378      */
379     function functionCall(
380         address target,
381         bytes memory data,
382         string memory errorMessage
383     ) internal returns (bytes memory) {
384         return functionCallWithValue(target, data, 0, errorMessage);
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
389      * but also transferring `value` wei to `target`.
390      *
391      * Requirements:
392      *
393      * - the calling contract must have an ETH balance of at least `value`.
394      * - the called Solidity function must be `payable`.
395      *
396      * _Available since v3.1._
397      */
398     function functionCallWithValue(
399         address target,
400         bytes memory data,
401         uint256 value
402     ) internal returns (bytes memory) {
403         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
408      * with `errorMessage` as a fallback revert reason when `target` reverts.
409      *
410      * _Available since v3.1._
411      */
412     function functionCallWithValue(
413         address target,
414         bytes memory data,
415         uint256 value,
416         string memory errorMessage
417     ) internal returns (bytes memory) {
418         require(address(this).balance >= value, "Address: insufficient balance for call");
419         require(isContract(target), "Address: call to non-contract");
420 
421         (bool success, bytes memory returndata) = target.call{value: value}(data);
422         return verifyCallResult(success, returndata, errorMessage);
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
427      * but performing a static call.
428      *
429      * _Available since v3.3._
430      */
431     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
432         return functionStaticCall(target, data, "Address: low-level static call failed");
433     }
434 
435     /**
436      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
437      * but performing a static call.
438      *
439      * _Available since v3.3._
440      */
441     function functionStaticCall(
442         address target,
443         bytes memory data,
444         string memory errorMessage
445     ) internal view returns (bytes memory) {
446         require(isContract(target), "Address: static call to non-contract");
447 
448         (bool success, bytes memory returndata) = target.staticcall(data);
449         return verifyCallResult(success, returndata, errorMessage);
450     }
451 
452     /**
453      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
454      * but performing a delegate call.
455      *
456      * _Available since v3.4._
457      */
458     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
459         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
460     }
461 
462     /**
463      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
464      * but performing a delegate call.
465      *
466      * _Available since v3.4._
467      */
468     function functionDelegateCall(
469         address target,
470         bytes memory data,
471         string memory errorMessage
472     ) internal returns (bytes memory) {
473         require(isContract(target), "Address: delegate call to non-contract");
474 
475         (bool success, bytes memory returndata) = target.delegatecall(data);
476         return verifyCallResult(success, returndata, errorMessage);
477     }
478 
479     /**
480      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
481      * revert reason using the provided one.
482      *
483      * _Available since v4.3._
484      */
485     function verifyCallResult(
486         bool success,
487         bytes memory returndata,
488         string memory errorMessage
489     ) internal pure returns (bytes memory) {
490         if (success) {
491             return returndata;
492         } else {
493             // Look for revert reason and bubble it up if present
494             if (returndata.length > 0) {
495                 // The easiest way to bubble the revert reason is using memory via assembly
496 
497                 assembly {
498                     let returndata_size := mload(returndata)
499                     revert(add(32, returndata), returndata_size)
500                 }
501             } else {
502                 revert(errorMessage);
503             }
504         }
505     }
506 }
507 
508 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
509 
510 pragma solidity ^0.8.0;
511 
512 /**
513  * @dev String operations.
514  */
515 library Strings {
516     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
517 
518     /**
519      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
520      */
521     function toString(uint256 value) internal pure returns (string memory) {
522         // Inspired by OraclizeAPI's implementation - MIT licence
523         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
524 
525         if (value == 0) {
526             return "0";
527         }
528         uint256 temp = value;
529         uint256 digits;
530         while (temp != 0) {
531             digits++;
532             temp /= 10;
533         }
534         bytes memory buffer = new bytes(digits);
535         while (value != 0) {
536             digits -= 1;
537             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
538             value /= 10;
539         }
540         return string(buffer);
541     }
542 
543     /**
544      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
545      */
546     function toHexString(uint256 value) internal pure returns (string memory) {
547         if (value == 0) {
548             return "0x00";
549         }
550         uint256 temp = value;
551         uint256 length = 0;
552         while (temp != 0) {
553             length++;
554             temp >>= 8;
555         }
556         return toHexString(value, length);
557     }
558 
559     /**
560      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
561      */
562     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
563         bytes memory buffer = new bytes(2 * length + 2);
564         buffer[0] = "0";
565         buffer[1] = "x";
566         for (uint256 i = 2 * length + 1; i > 1; --i) {
567             buffer[i] = _HEX_SYMBOLS[value & 0xf];
568             value >>= 4;
569         }
570         require(value == 0, "Strings: hex length insufficient");
571         return string(buffer);
572     }
573 }
574 
575 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
576 
577 pragma solidity ^0.8.0;
578 
579 /**
580  * @title ERC721 token receiver interface
581  * @dev Interface for any contract that wants to support safeTransfers
582  * from ERC721 asset contracts.
583  */
584 interface IERC721Receiver {
585     /**
586      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
587      * by `operator` from `from`, this function is called.
588      *
589      * It must return its Solidity selector to confirm the token transfer.
590      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
591      *
592      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
593      */
594     function onERC721Received(
595         address operator,
596         address from,
597         uint256 tokenId,
598         bytes calldata data
599     ) external returns (bytes4);
600 }
601 
602 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
603 
604 pragma solidity ^0.8.0;
605 
606 /**
607  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
608  * the Metadata extension, but not including the Enumerable extension, which is available separately as
609  * {ERC721Enumerable}.
610  */
611 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
612     using Address for address;
613     using Strings for uint256;
614 
615     // Token name
616     string private _name;
617 
618     // Token symbol
619     string private _symbol;
620 
621     // Mapping from token ID to owner address
622     mapping(uint256 => address) private _owners;
623 
624     // Mapping owner address to token count
625     mapping(address => uint256) private _balances;
626 
627     // Mapping from token ID to approved address
628     mapping(uint256 => address) private _tokenApprovals;
629 
630     // Mapping from owner to operator approvals
631     mapping(address => mapping(address => bool)) private _operatorApprovals;
632 
633     /**
634      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
635      */
636     constructor(string memory name_, string memory symbol_) {
637         _name = name_;
638         _symbol = symbol_;
639     }
640 
641     /**
642      * @dev See {IERC165-supportsInterface}.
643      */
644     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
645         return
646             interfaceId == type(IERC721).interfaceId ||
647             interfaceId == type(IERC721Metadata).interfaceId ||
648             super.supportsInterface(interfaceId);
649     }
650 
651     /**
652      * @dev See {IERC721-balanceOf}.
653      */
654     function balanceOf(address owner) public view virtual override returns (uint256) {
655         require(owner != address(0), "ERC721: balance query for the zero address");
656         return _balances[owner];
657     }
658 
659     /**
660      * @dev See {IERC721-ownerOf}.
661      */
662     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
663         address owner = _owners[tokenId];
664         require(owner != address(0), "ERC721: owner query for nonexistent token");
665         return owner;
666     }
667 
668     /**
669      * @dev See {IERC721Metadata-name}.
670      */
671     function name() public view virtual override returns (string memory) {
672         return _name;
673     }
674 
675     /**
676      * @dev See {IERC721Metadata-symbol}.
677      */
678     function symbol() public view virtual override returns (string memory) {
679         return _symbol;
680     }
681 
682     /**
683      * @dev See {IERC721Metadata-tokenURI}.
684      */
685     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
686         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
687 
688         string memory baseURI = _baseURI();
689         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
690     }
691 
692     /**
693      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
694      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
695      * by default, can be overriden in child contracts.
696      */
697     function _baseURI() internal view virtual returns (string memory) {
698         return "";
699     }
700 
701     /**
702      * @dev See {IERC721-approve}.
703      */
704     function approve(address to, uint256 tokenId) public virtual override {
705         address owner = ERC721.ownerOf(tokenId);
706         require(to != owner, "ERC721: approval to current owner");
707 
708         require(
709             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
710             "ERC721: approve caller is not owner nor approved for all"
711         );
712 
713         _approve(to, tokenId);
714     }
715 
716     /**
717      * @dev See {IERC721-getApproved}.
718      */
719     function getApproved(uint256 tokenId) public view virtual override returns (address) {
720         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
721 
722         return _tokenApprovals[tokenId];
723     }
724 
725     /**
726      * @dev See {IERC721-setApprovalForAll}.
727      */
728     function setApprovalForAll(address operator, bool approved) public virtual override {
729         _setApprovalForAll(_msgSender(), operator, approved);
730     }
731 
732     /**
733      * @dev See {IERC721-isApprovedForAll}.
734      */
735     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
736         return _operatorApprovals[owner][operator];
737     }
738 
739     /**
740      * @dev See {IERC721-transferFrom}.
741      */
742     function transferFrom(
743         address from,
744         address to,
745         uint256 tokenId
746     ) public virtual override {
747         //solhint-disable-next-line max-line-length
748         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
749 
750         _transfer(from, to, tokenId);
751     }
752 
753     /**
754      * @dev See {IERC721-safeTransferFrom}.
755      */
756     function safeTransferFrom(
757         address from,
758         address to,
759         uint256 tokenId
760     ) public virtual override {
761         safeTransferFrom(from, to, tokenId, "");
762     }
763 
764     /**
765      * @dev See {IERC721-safeTransferFrom}.
766      */
767     function safeTransferFrom(
768         address from,
769         address to,
770         uint256 tokenId,
771         bytes memory _data
772     ) public virtual override {
773         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
774         _safeTransfer(from, to, tokenId, _data);
775     }
776 
777     /**
778      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
779      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
780      *
781      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
782      *
783      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
784      * implement alternative mechanisms to perform token transfer, such as signature-based.
785      *
786      * Requirements:
787      *
788      * - `from` cannot be the zero address.
789      * - `to` cannot be the zero address.
790      * - `tokenId` token must exist and be owned by `from`.
791      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
792      *
793      * Emits a {Transfer} event.
794      */
795     function _safeTransfer(
796         address from,
797         address to,
798         uint256 tokenId,
799         bytes memory _data
800     ) internal virtual {
801         _transfer(from, to, tokenId);
802         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
803     }
804 
805     /**
806      * @dev Returns whether `tokenId` exists.
807      *
808      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
809      *
810      * Tokens start existing when they are minted (`_mint`),
811      * and stop existing when they are burned (`_burn`).
812      */
813     function _exists(uint256 tokenId) internal view virtual returns (bool) {
814         return _owners[tokenId] != address(0);
815     }
816 
817     /**
818      * @dev Returns whether `spender` is allowed to manage `tokenId`.
819      *
820      * Requirements:
821      *
822      * - `tokenId` must exist.
823      */
824     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
825         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
826         address owner = ERC721.ownerOf(tokenId);
827         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
828     }
829 
830     /**
831      * @dev Safely mints `tokenId` and transfers it to `to`.
832      *
833      * Requirements:
834      *
835      * - `tokenId` must not exist.
836      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
837      *
838      * Emits a {Transfer} event.
839      */
840     function _safeMint(address to, uint256 tokenId) internal virtual {
841         _safeMint(to, tokenId, "");
842     }
843 
844     /**
845      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
846      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
847      */
848     function _safeMint(
849         address to,
850         uint256 tokenId,
851         bytes memory _data
852     ) internal virtual {
853         _mint(to, tokenId);
854         require(
855             _checkOnERC721Received(address(0), to, tokenId, _data),
856             "ERC721: transfer to non ERC721Receiver implementer"
857         );
858     }
859 
860     /**
861      * @dev Mints `tokenId` and transfers it to `to`.
862      *
863      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
864      *
865      * Requirements:
866      *
867      * - `tokenId` must not exist.
868      * - `to` cannot be the zero address.
869      *
870      * Emits a {Transfer} event.
871      */
872     function _mint(address to, uint256 tokenId) internal virtual {
873         require(to != address(0), "ERC721: mint to the zero address");
874         require(!_exists(tokenId), "ERC721: token already minted");
875 
876         _beforeTokenTransfer(address(0), to, tokenId);
877 
878         _balances[to] += 1;
879         _owners[tokenId] = to;
880 
881         emit Transfer(address(0), to, tokenId);
882     }
883 
884     /**
885      * @dev Destroys `tokenId`.
886      * The approval is cleared when the token is burned.
887      *
888      * Requirements:
889      *
890      * - `tokenId` must exist.
891      *
892      * Emits a {Transfer} event.
893      */
894     function _burn(uint256 tokenId) internal virtual {
895         address owner = ERC721.ownerOf(tokenId);
896 
897         _beforeTokenTransfer(owner, address(0), tokenId);
898 
899         // Clear approvals
900         _approve(address(0), tokenId);
901 
902         _balances[owner] -= 1;
903         delete _owners[tokenId];
904 
905         emit Transfer(owner, address(0), tokenId);
906     }
907 
908     /**
909      * @dev Transfers `tokenId` from `from` to `to`.
910      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
911      *
912      * Requirements:
913      *
914      * - `to` cannot be the zero address.
915      * - `tokenId` token must be owned by `from`.
916      *
917      * Emits a {Transfer} event.
918      */
919     function _transfer(
920         address from,
921         address to,
922         uint256 tokenId
923     ) internal virtual {
924         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
925         require(to != address(0), "ERC721: transfer to the zero address");
926 
927         _beforeTokenTransfer(from, to, tokenId);
928 
929         // Clear approvals from the previous owner
930         _approve(address(0), tokenId);
931 
932         _balances[from] -= 1;
933         _balances[to] += 1;
934         _owners[tokenId] = to;
935 
936         emit Transfer(from, to, tokenId);
937     }
938 
939     /**
940      * @dev Approve `to` to operate on `tokenId`
941      *
942      * Emits a {Approval} event.
943      */
944     function _approve(address to, uint256 tokenId) internal virtual {
945         _tokenApprovals[tokenId] = to;
946         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
947     }
948 
949     /**
950      * @dev Approve `operator` to operate on all of `owner` tokens
951      *
952      * Emits a {ApprovalForAll} event.
953      */
954     function _setApprovalForAll(
955         address owner,
956         address operator,
957         bool approved
958     ) internal virtual {
959         require(owner != operator, "ERC721: approve to caller");
960         _operatorApprovals[owner][operator] = approved;
961         emit ApprovalForAll(owner, operator, approved);
962     }
963 
964     /**
965      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
966      * The call is not executed if the target address is not a contract.
967      *
968      * @param from address representing the previous owner of the given token ID
969      * @param to target address that will receive the tokens
970      * @param tokenId uint256 ID of the token to be transferred
971      * @param _data bytes optional data to send along with the call
972      * @return bool whether the call correctly returned the expected magic value
973      */
974     function _checkOnERC721Received(
975         address from,
976         address to,
977         uint256 tokenId,
978         bytes memory _data
979     ) private returns (bool) {
980         if (to.isContract()) {
981             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
982                 return retval == IERC721Receiver.onERC721Received.selector;
983             } catch (bytes memory reason) {
984                 if (reason.length == 0) {
985                     revert("ERC721: transfer to non ERC721Receiver implementer");
986                 } else {
987                     assembly {
988                         revert(add(32, reason), mload(reason))
989                     }
990                 }
991             }
992         } else {
993             return true;
994         }
995     }
996 
997     /**
998      * @dev Hook that is called before any token transfer. This includes minting
999      * and burning.
1000      *
1001      * Calling conditions:
1002      *
1003      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1004      * transferred to `to`.
1005      * - When `from` is zero, `tokenId` will be minted for `to`.
1006      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1007      * - `from` and `to` are never both zero.
1008      *
1009      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1010      */
1011     function _beforeTokenTransfer(
1012         address from,
1013         address to,
1014         uint256 tokenId
1015     ) internal virtual {}
1016 }
1017 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
1018 
1019 pragma solidity ^0.8.0;
1020 
1021 
1022 /**
1023  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1024  * @dev See https://eips.ethereum.org/EIPS/eip-721
1025  */
1026 interface IERC721Enumerable is IERC721 {
1027     /**
1028      * @dev Returns the total amount of tokens stored by the contract.
1029      */
1030     function totalSupply() external view returns (uint256);
1031 
1032     /**
1033      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1034      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1035      */
1036     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1037 
1038     /**
1039      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1040      * Use along with {totalSupply} to enumerate all tokens.
1041      */
1042     function tokenByIndex(uint256 index) external view returns (uint256);
1043 }
1044 
1045 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1046 
1047 pragma solidity ^0.8.0;
1048 
1049 
1050 /**
1051  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1052  * enumerability of all the token ids in the contract as well as all token ids owned by each
1053  * account.
1054  */
1055 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1056     // Mapping from owner to list of owned token IDs
1057     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1058 
1059     // Mapping from token ID to index of the owner tokens list
1060     mapping(uint256 => uint256) private _ownedTokensIndex;
1061 
1062     // Array with all token ids, used for enumeration
1063     uint256[] private _allTokens;
1064 
1065     // Mapping from token id to position in the allTokens array
1066     mapping(uint256 => uint256) private _allTokensIndex;
1067 
1068     /**
1069      * @dev See {IERC165-supportsInterface}.
1070      */
1071     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1072         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1073     }
1074 
1075     /**
1076      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1077      */
1078     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1079         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1080         return _ownedTokens[owner][index];
1081     }
1082 
1083     /**
1084      * @dev See {IERC721Enumerable-totalSupply}.
1085      */
1086     function totalSupply() public view virtual override returns (uint256) {
1087         return _allTokens.length;
1088     }
1089 
1090     /**
1091      * @dev See {IERC721Enumerable-tokenByIndex}.
1092      */
1093     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1094         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1095         return _allTokens[index];
1096     }
1097 
1098     /**
1099      * @dev Hook that is called before any token transfer. This includes minting
1100      * and burning.
1101      *
1102      * Calling conditions:
1103      *
1104      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1105      * transferred to `to`.
1106      * - When `from` is zero, `tokenId` will be minted for `to`.
1107      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1108      * - `from` cannot be the zero address.
1109      * - `to` cannot be the zero address.
1110      *
1111      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1112      */
1113     function _beforeTokenTransfer(
1114         address from,
1115         address to,
1116         uint256 tokenId
1117     ) internal virtual override {
1118         super._beforeTokenTransfer(from, to, tokenId);
1119 
1120         if (from == address(0)) {
1121             _addTokenToAllTokensEnumeration(tokenId);
1122         } else if (from != to) {
1123             _removeTokenFromOwnerEnumeration(from, tokenId);
1124         }
1125         if (to == address(0)) {
1126             _removeTokenFromAllTokensEnumeration(tokenId);
1127         } else if (to != from) {
1128             _addTokenToOwnerEnumeration(to, tokenId);
1129         }
1130     }
1131 
1132     /**
1133      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1134      * @param to address representing the new owner of the given token ID
1135      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1136      */
1137     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1138         uint256 length = ERC721.balanceOf(to);
1139         _ownedTokens[to][length] = tokenId;
1140         _ownedTokensIndex[tokenId] = length;
1141     }
1142 
1143     /**
1144      * @dev Private function to add a token to this extension's token tracking data structures.
1145      * @param tokenId uint256 ID of the token to be added to the tokens list
1146      */
1147     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1148         _allTokensIndex[tokenId] = _allTokens.length;
1149         _allTokens.push(tokenId);
1150     }
1151 
1152     /**
1153      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1154      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1155      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1156      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1157      * @param from address representing the previous owner of the given token ID
1158      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1159      */
1160     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1161         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1162         // then delete the last slot (swap and pop).
1163 
1164         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1165         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1166 
1167         // When the token to delete is the last token, the swap operation is unnecessary
1168         if (tokenIndex != lastTokenIndex) {
1169             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1170 
1171             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1172             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1173         }
1174 
1175         // This also deletes the contents at the last position of the array
1176         delete _ownedTokensIndex[tokenId];
1177         delete _ownedTokens[from][lastTokenIndex];
1178     }
1179 
1180     /**
1181      * @dev Private function to remove a token from this extension's token tracking data structures.
1182      * This has O(1) time complexity, but alters the order of the _allTokens array.
1183      * @param tokenId uint256 ID of the token to be removed from the tokens list
1184      */
1185     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1186         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1187         // then delete the last slot (swap and pop).
1188 
1189         uint256 lastTokenIndex = _allTokens.length - 1;
1190         uint256 tokenIndex = _allTokensIndex[tokenId];
1191 
1192         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1193         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1194         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1195         uint256 lastTokenId = _allTokens[lastTokenIndex];
1196 
1197         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1198         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1199 
1200         // This also deletes the contents at the last position of the array
1201         delete _allTokensIndex[tokenId];
1202         _allTokens.pop();
1203     }
1204 }
1205 
1206 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
1207 
1208 pragma solidity ^0.8.0;
1209 
1210 /**
1211  * @dev External interface of AccessControl declared to support ERC165 detection.
1212  */
1213 interface IAccessControl {
1214     /**
1215      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1216      *
1217      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1218      * {RoleAdminChanged} not being emitted signaling this.
1219      *
1220      * _Available since v3.1._
1221      */
1222     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1223 
1224     /**
1225      * @dev Emitted when `account` is granted `role`.
1226      *
1227      * `sender` is the account that originated the contract call, an admin role
1228      * bearer except when using {AccessControl-_setupRole}.
1229      */
1230     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1231 
1232     /**
1233      * @dev Emitted when `account` is revoked `role`.
1234      *
1235      * `sender` is the account that originated the contract call:
1236      *   - if using `revokeRole`, it is the admin role bearer
1237      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1238      */
1239     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1240 
1241     /**
1242      * @dev Returns `true` if `account` has been granted `role`.
1243      */
1244     function hasRole(bytes32 role, address account) external view returns (bool);
1245 
1246     /**
1247      * @dev Returns the admin role that controls `role`. See {grantRole} and
1248      * {revokeRole}.
1249      *
1250      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
1251      */
1252     function getRoleAdmin(bytes32 role) external view returns (bytes32);
1253 
1254     /**
1255      * @dev Grants `role` to `account`.
1256      *
1257      * If `account` had not been already granted `role`, emits a {RoleGranted}
1258      * event.
1259      *
1260      * Requirements:
1261      *
1262      * - the caller must have ``role``'s admin role.
1263      */
1264     function grantRole(bytes32 role, address account) external;
1265 
1266     /**
1267      * @dev Revokes `role` from `account`.
1268      *
1269      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1270      *
1271      * Requirements:
1272      *
1273      * - the caller must have ``role``'s admin role.
1274      */
1275     function revokeRole(bytes32 role, address account) external;
1276 
1277     /**
1278      * @dev Revokes `role` from the calling account.
1279      *
1280      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1281      * purpose is to provide a mechanism for accounts to lose their privileges
1282      * if they are compromised (such as when a trusted device is misplaced).
1283      *
1284      * If the calling account had been granted `role`, emits a {RoleRevoked}
1285      * event.
1286      *
1287      * Requirements:
1288      *
1289      * - the caller must be `account`.
1290      */
1291     function renounceRole(bytes32 role, address account) external;
1292 }
1293 
1294 
1295 // OpenZeppelin Contracts (last updated v4.7.0) (access/AccessControl.sol)
1296 
1297 pragma solidity ^0.8.0;
1298 
1299 
1300 /**
1301  * @dev Contract module that allows children to implement role-based access
1302  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1303  * members except through off-chain means by accessing the contract event logs. Some
1304  * applications may benefit from on-chain enumerability, for those cases see
1305  * {AccessControlEnumerable}.
1306  *
1307  * Roles are referred to by their `bytes32` identifier. These should be exposed
1308  * in the external API and be unique. The best way to achieve this is by
1309  * using `public constant` hash digests:
1310  *
1311  * ```
1312  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1313  * ```
1314  *
1315  * Roles can be used to represent a set of permissions. To restrict access to a
1316  * function call, use {hasRole}:
1317  *
1318  * ```
1319  * function foo() public {
1320  *     require(hasRole(MY_ROLE, msg.sender));
1321  *     ...
1322  * }
1323  * ```
1324  *
1325  * Roles can be granted and revoked dynamically via the {grantRole} and
1326  * {revokeRole} functions. Each role has an associated admin role, and only
1327  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1328  *
1329  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1330  * that only accounts with this role will be able to grant or revoke other
1331  * roles. More complex role relationships can be created by using
1332  * {_setRoleAdmin}.
1333  *
1334  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1335  * grant and revoke this role. Extra precautions should be taken to secure
1336  * accounts that have been granted it.
1337  */
1338 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1339     struct RoleData {
1340         mapping(address => bool) members;
1341         bytes32 adminRole;
1342     }
1343 
1344     mapping(bytes32 => RoleData) private _roles;
1345 
1346     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1347 
1348     /**
1349      * @dev Modifier that checks that an account has a specific role. Reverts
1350      * with a standardized message including the required role.
1351      *
1352      * The format of the revert reason is given by the following regular expression:
1353      *
1354      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1355      *
1356      * _Available since v4.1._
1357      */
1358     modifier onlyRole(bytes32 role) {
1359         _checkRole(role);
1360         _;
1361     }
1362 
1363     /**
1364      * @dev See {IERC165-supportsInterface}.
1365      */
1366     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1367         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1368     }
1369 
1370     /**
1371      * @dev Returns `true` if `account` has been granted `role`.
1372      */
1373     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
1374         return _roles[role].members[account];
1375     }
1376 
1377     /**
1378      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
1379      * Overriding this function changes the behavior of the {onlyRole} modifier.
1380      *
1381      * Format of the revert message is described in {_checkRole}.
1382      *
1383      * _Available since v4.6._
1384      */
1385     function _checkRole(bytes32 role) internal view virtual {
1386         _checkRole(role, _msgSender());
1387     }
1388 
1389     /**
1390      * @dev Revert with a standard message if `account` is missing `role`.
1391      *
1392      * The format of the revert reason is given by the following regular expression:
1393      *
1394      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1395      */
1396     function _checkRole(bytes32 role, address account) internal view virtual {
1397         if (!hasRole(role, account)) {
1398             revert(
1399                 string(
1400                     abi.encodePacked(
1401                         "AccessControl: account ",
1402                         Strings.toHexString(uint160(account), 20),
1403                         " is missing role ",
1404                         Strings.toHexString(uint256(role), 32)
1405                     )
1406                 )
1407             );
1408         }
1409     }
1410 
1411     /**
1412      * @dev Returns the admin role that controls `role`. See {grantRole} and
1413      * {revokeRole}.
1414      *
1415      * To change a role's admin, use {_setRoleAdmin}.
1416      */
1417     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
1418         return _roles[role].adminRole;
1419     }
1420 
1421     /**
1422      * @dev Grants `role` to `account`.
1423      *
1424      * If `account` had not been already granted `role`, emits a {RoleGranted}
1425      * event.
1426      *
1427      * Requirements:
1428      *
1429      * - the caller must have ``role``'s admin role.
1430      *
1431      * May emit a {RoleGranted} event.
1432      */
1433     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1434         _grantRole(role, account);
1435     }
1436 
1437     /**
1438      * @dev Revokes `role` from `account`.
1439      *
1440      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1441      *
1442      * Requirements:
1443      *
1444      * - the caller must have ``role``'s admin role.
1445      *
1446      * May emit a {RoleRevoked} event.
1447      */
1448     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1449         _revokeRole(role, account);
1450     }
1451 
1452     /**
1453      * @dev Revokes `role` from the calling account.
1454      *
1455      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1456      * purpose is to provide a mechanism for accounts to lose their privileges
1457      * if they are compromised (such as when a trusted device is misplaced).
1458      *
1459      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1460      * event.
1461      *
1462      * Requirements:
1463      *
1464      * - the caller must be `account`.
1465      *
1466      * May emit a {RoleRevoked} event.
1467      */
1468     function renounceRole(bytes32 role, address account) public virtual override {
1469         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1470 
1471         _revokeRole(role, account);
1472     }
1473 
1474     /**
1475      * @dev Grants `role` to `account`.
1476      *
1477      * If `account` had not been already granted `role`, emits a {RoleGranted}
1478      * event. Note that unlike {grantRole}, this function doesn't perform any
1479      * checks on the calling account.
1480      *
1481      * May emit a {RoleGranted} event.
1482      *
1483      * [WARNING]
1484      * ====
1485      * This function should only be called from the constructor when setting
1486      * up the initial roles for the system.
1487      *
1488      * Using this function in any other way is effectively circumventing the admin
1489      * system imposed by {AccessControl}.
1490      * ====
1491      *
1492      * NOTE: This function is deprecated in favor of {_grantRole}.
1493      */
1494     function _setupRole(bytes32 role, address account) internal virtual {
1495         _grantRole(role, account);
1496     }
1497 
1498     /**
1499      * @dev Sets `adminRole` as ``role``'s admin role.
1500      *
1501      * Emits a {RoleAdminChanged} event.
1502      */
1503     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1504         bytes32 previousAdminRole = getRoleAdmin(role);
1505         _roles[role].adminRole = adminRole;
1506         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1507     }
1508 
1509     /**
1510      * @dev Grants `role` to `account`.
1511      *
1512      * Internal function without access restriction.
1513      *
1514      * May emit a {RoleGranted} event.
1515      */
1516     function _grantRole(bytes32 role, address account) internal virtual {
1517         if (!hasRole(role, account)) {
1518             _roles[role].members[account] = true;
1519             emit RoleGranted(role, account, _msgSender());
1520         }
1521     }
1522 
1523     /**
1524      * @dev Revokes `role` from `account`.
1525      *
1526      * Internal function without access restriction.
1527      *
1528      * May emit a {RoleRevoked} event.
1529      */
1530     function _revokeRole(bytes32 role, address account) internal virtual {
1531         if (hasRole(role, account)) {
1532             _roles[role].members[account] = false;
1533             emit RoleRevoked(role, account, _msgSender());
1534         }
1535     }
1536 }
1537 
1538 
1539 // OpenZeppelin Contracts (last updated v4.9.2) (utils/cryptography/MerkleProof.sol)
1540 
1541 
1542 
1543 /**
1544  * @dev These functions deal with verification of Merkle Tree proofs.
1545  *
1546  * The tree and the proofs can be generated using our
1547  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
1548  * You will find a quickstart guide in the readme.
1549  *
1550  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1551  * hashing, or use a hash function other than keccak256 for hashing leaves.
1552  * This is because the concatenation of a sorted pair of internal nodes in
1553  * the merkle tree could be reinterpreted as a leaf value.
1554  * OpenZeppelin's JavaScript library generates merkle trees that are safe
1555  * against this attack out of the box.
1556  */
1557 library MerkleProof {
1558     /**
1559      *@dev The multiproof provided is not valid.
1560      */
1561     error MerkleProofInvalidMultiproof();
1562 
1563     /**
1564      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1565      * defined by `root`. For this, a `proof` must be provided, containing
1566      * sibling hashes on the branch from the leaf to the root of the tree. Each
1567      * pair of leaves and each pair of pre-images are assumed to be sorted.
1568      */
1569     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
1570         return processProof(proof, leaf) == root;
1571     }
1572 
1573     /**
1574      * @dev Calldata version of {verify}
1575      */
1576     function verifyCalldata(bytes32[] calldata proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
1577         return processProofCalldata(proof, leaf) == root;
1578     }
1579 
1580     /**
1581      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1582      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1583      * hash matches the root of the tree. When processing the proof, the pairs
1584      * of leafs & pre-images are assumed to be sorted.
1585      */
1586     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1587         bytes32 computedHash = leaf;
1588         for (uint256 i = 0; i < proof.length; i++) {
1589             computedHash = _hashPair(computedHash, proof[i]);
1590         }
1591         return computedHash;
1592     }
1593 
1594     /**
1595      * @dev Calldata version of {processProof}
1596      */
1597     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1598         bytes32 computedHash = leaf;
1599         for (uint256 i = 0; i < proof.length; i++) {
1600             computedHash = _hashPair(computedHash, proof[i]);
1601         }
1602         return computedHash;
1603     }
1604 
1605     /**
1606      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
1607      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1608      *
1609      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1610      */
1611     function multiProofVerify(
1612         bytes32[] memory proof,
1613         bool[] memory proofFlags,
1614         bytes32 root,
1615         bytes32[] memory leaves
1616     ) internal pure returns (bool) {
1617         return processMultiProof(proof, proofFlags, leaves) == root;
1618     }
1619 
1620     /**
1621      * @dev Calldata version of {multiProofVerify}
1622      *
1623      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1624      */
1625     function multiProofVerifyCalldata(
1626         bytes32[] calldata proof,
1627         bool[] calldata proofFlags,
1628         bytes32 root,
1629         bytes32[] memory leaves
1630     ) internal pure returns (bool) {
1631         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1632     }
1633 
1634     /**
1635      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
1636      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
1637      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
1638      * respectively.
1639      *
1640      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
1641      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
1642      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
1643      */
1644     function processMultiProof(
1645         bytes32[] memory proof,
1646         bool[] memory proofFlags,
1647         bytes32[] memory leaves
1648     ) internal pure returns (bytes32 merkleRoot) {
1649         // This function rebuilds the root hash by traversing the tree up from the leaves. The root is rebuilt by
1650         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1651         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1652         // the merkle tree.
1653         uint256 leavesLen = leaves.length;
1654         uint256 proofLen = proof.length;
1655         uint256 totalHashes = proofFlags.length;
1656 
1657         // Check proof validity.
1658         if (leavesLen + proofLen - 1 != totalHashes) {
1659             revert MerkleProofInvalidMultiproof();
1660         }
1661 
1662         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1663         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1664         bytes32[] memory hashes = new bytes32[](totalHashes);
1665         uint256 leafPos = 0;
1666         uint256 hashPos = 0;
1667         uint256 proofPos = 0;
1668         // At each step, we compute the next hash using two values:
1669         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1670         //   get the next hash.
1671         // - depending on the flag, either another value from the "main queue" (merging branches) or an element from the
1672         //   `proof` array.
1673         for (uint256 i = 0; i < totalHashes; i++) {
1674             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1675             bytes32 b = proofFlags[i]
1676                 ? (leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++])
1677                 : proof[proofPos++];
1678             hashes[i] = _hashPair(a, b);
1679         }
1680 
1681         if (totalHashes > 0) {
1682             if (proofPos != proofLen) {
1683                 revert MerkleProofInvalidMultiproof();
1684             }
1685             unchecked {
1686                 return hashes[totalHashes - 1];
1687             }
1688         } else if (leavesLen > 0) {
1689             return leaves[0];
1690         } else {
1691             return proof[0];
1692         }
1693     }
1694 
1695     /**
1696      * @dev Calldata version of {processMultiProof}.
1697      *
1698      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1699      */
1700     function processMultiProofCalldata(
1701         bytes32[] calldata proof,
1702         bool[] calldata proofFlags,
1703         bytes32[] memory leaves
1704     ) internal pure returns (bytes32 merkleRoot) {
1705         // This function rebuilds the root hash by traversing the tree up from the leaves. The root is rebuilt by
1706         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1707         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1708         // the merkle tree.
1709         uint256 leavesLen = leaves.length;
1710         uint256 proofLen = proof.length;
1711         uint256 totalHashes = proofFlags.length;
1712 
1713         // Check proof validity.
1714         if (leavesLen + proofLen - 1 != totalHashes) {
1715             revert MerkleProofInvalidMultiproof();
1716         }
1717 
1718         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1719         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1720         bytes32[] memory hashes = new bytes32[](totalHashes);
1721         uint256 leafPos = 0;
1722         uint256 hashPos = 0;
1723         uint256 proofPos = 0;
1724         // At each step, we compute the next hash using two values:
1725         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1726         //   get the next hash.
1727         // - depending on the flag, either another value from the "main queue" (merging branches) or an element from the
1728         //   `proof` array.
1729         for (uint256 i = 0; i < totalHashes; i++) {
1730             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1731             bytes32 b = proofFlags[i]
1732                 ? (leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++])
1733                 : proof[proofPos++];
1734             hashes[i] = _hashPair(a, b);
1735         }
1736 
1737         if (totalHashes > 0) {
1738             if (proofPos != proofLen) {
1739                 revert MerkleProofInvalidMultiproof();
1740             }
1741             unchecked {
1742                 return hashes[totalHashes - 1];
1743             }
1744         } else if (leavesLen > 0) {
1745             return leaves[0];
1746         } else {
1747             return proof[0];
1748         }
1749     }
1750 
1751     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1752         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1753     }
1754 
1755     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1756         /// @solidity memory-safe-assembly
1757         assembly {
1758             mstore(0x00, a)
1759             mstore(0x20, b)
1760             value := keccak256(0x00, 0x40)
1761         }
1762     }
1763 }
1764 
1765 
1766 
1767 /**
1768  * @dev Interface for the NFT Royalty Standard.
1769  *
1770  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1771  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1772  *
1773  * _Available since v4.5._
1774  */
1775 interface IERC2981 is IERC165 {
1776     /**
1777      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1778      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1779      */
1780     function royaltyInfo(
1781         uint256 tokenId,
1782         uint256 salePrice
1783     ) external view returns (address receiver, uint256 royaltyAmount);
1784 }
1785 
1786 
1787 
1788 interface IOperatorFilterRegistry {
1789     /**
1790      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
1791      *         true if supplied registrant address is not registered.
1792      */
1793     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1794 
1795     /**
1796      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
1797      */
1798     function register(address registrant) external;
1799 
1800     /**
1801      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
1802      */
1803     function registerAndSubscribe(address registrant, address subscription) external;
1804 
1805     /**
1806      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
1807      *         address without subscribing.
1808      */
1809     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1810 
1811     /**
1812      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
1813      *         Note that this does not remove any filtered addresses or codeHashes.
1814      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
1815      */
1816     function unregister(address addr) external;
1817 
1818     /**
1819      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
1820      */
1821     function updateOperator(address registrant, address operator, bool filtered) external;
1822 
1823     /**
1824      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
1825      */
1826     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1827 
1828     /**
1829      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
1830      */
1831     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1832 
1833     /**
1834      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
1835      */
1836     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1837 
1838     /**
1839      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
1840      *         subscription if present.
1841      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
1842      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
1843      *         used.
1844      */
1845     function subscribe(address registrant, address registrantToSubscribe) external;
1846 
1847     /**
1848      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
1849      */
1850     function unsubscribe(address registrant, bool copyExistingEntries) external;
1851 
1852     /**
1853      * @notice Get the subscription address of a given registrant, if any.
1854      */
1855     function subscriptionOf(address addr) external returns (address registrant);
1856 
1857     /**
1858      * @notice Get the set of addresses subscribed to a given registrant.
1859      *         Note that order is not guaranteed as updates are made.
1860      */
1861     function subscribers(address registrant) external returns (address[] memory);
1862 
1863     /**
1864      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
1865      *         Note that order is not guaranteed as updates are made.
1866      */
1867     function subscriberAt(address registrant, uint256 index) external returns (address);
1868 
1869     /**
1870      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
1871      */
1872     function copyEntriesOf(address registrant, address registrantToCopy) external;
1873 
1874     /**
1875      * @notice Returns true if operator is filtered by a given address or its subscription.
1876      */
1877     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1878 
1879     /**
1880      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
1881      */
1882     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1883 
1884     /**
1885      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
1886      */
1887     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1888 
1889     /**
1890      * @notice Returns a list of filtered operators for a given address or its subscription.
1891      */
1892     function filteredOperators(address addr) external returns (address[] memory);
1893 
1894     /**
1895      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
1896      *         Note that order is not guaranteed as updates are made.
1897      */
1898     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1899 
1900     /**
1901      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
1902      *         its subscription.
1903      *         Note that order is not guaranteed as updates are made.
1904      */
1905     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1906 
1907     /**
1908      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
1909      *         its subscription.
1910      *         Note that order is not guaranteed as updates are made.
1911      */
1912     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1913 
1914     /**
1915      * @notice Returns true if an address has registered
1916      */
1917     function isRegistered(address addr) external returns (bool);
1918 
1919     /**
1920      * @dev Convenience method to compute the code hash of an arbitrary contract
1921      */
1922     function codeHashOf(address addr) external returns (bytes32);
1923 }
1924 
1925 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
1926 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
1927 
1928 
1929 abstract contract OperatorFilterer {
1930     /// @dev Emitted when an operator is not allowed.
1931     error OperatorNotAllowed(address operator);
1932 
1933 
1934     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1935         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
1936 
1937     /// @dev The constructor that is called when the contract is being deployed.
1938     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1939         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1940         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1941         // order for the modifier to filter addresses.
1942         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1943             if (subscribe) {
1944                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1945             } else {
1946                 if (subscriptionOrRegistrantToCopy != address(0)) {
1947                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1948                 } else {
1949                     OPERATOR_FILTER_REGISTRY.register(address(this));
1950                 }
1951             }
1952         }
1953     }
1954 
1955     /**
1956      * @dev A helper function to check if an operator is allowed.
1957      */
1958     modifier onlyAllowedOperator(address from) virtual {
1959         // Allow spending tokens from addresses with balance
1960         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1961         // from an EOA.
1962         if (from != msg.sender) {
1963             _checkFilterOperator(msg.sender);
1964         }
1965         _;
1966     }
1967 
1968     /**
1969      * @dev A helper function to check if an operator approval is allowed.
1970      */
1971     modifier onlyAllowedOperatorApproval(address operator) virtual {
1972         _checkFilterOperator(operator);
1973         _;
1974     }
1975 
1976     /**
1977      * @dev A helper function to check if an operator is allowed.
1978      */
1979     function _checkFilterOperator(address operator) internal view virtual {
1980         // Check registry code length to facilitate testing in environments without a deployed registry.
1981         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1982             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
1983             // may specify their own OperatorFilterRegistry implementations, which may behave differently
1984             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1985                 revert OperatorNotAllowed(operator);
1986             }
1987         }
1988     }
1989 }
1990 /**
1991  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1992  *
1993  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1994  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1995  *
1996  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1997  * fee is specified in basis points by default.
1998  *
1999  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
2000  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
2001  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
2002  *
2003  * _Available since v4.5._
2004  */
2005 abstract contract ERC2981 is IERC2981, ERC165 {
2006     struct RoyaltyInfo {
2007         address receiver;
2008         uint96 royaltyFraction;
2009     }
2010 
2011     RoyaltyInfo private _defaultRoyaltyInfo;
2012     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
2013 
2014     /**
2015      * @dev See {IERC165-supportsInterface}.
2016      */
2017     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
2018         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
2019     }
2020 
2021     /**
2022      * @inheritdoc IERC2981
2023      */
2024     function royaltyInfo(uint256 tokenId, uint256 salePrice) public view virtual override returns (address, uint256) {
2025         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[tokenId];
2026 
2027         if (royalty.receiver == address(0)) {
2028             royalty = _defaultRoyaltyInfo;
2029         }
2030 
2031         uint256 royaltyAmount = (salePrice * royalty.royaltyFraction) / _feeDenominator();
2032 
2033         return (royalty.receiver, royaltyAmount);
2034     }
2035 
2036     /**
2037      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
2038      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
2039      * override.
2040      */
2041     function _feeDenominator() internal pure virtual returns (uint96) {
2042         return 10000;
2043     }
2044 
2045     /**
2046      * @dev Sets the royalty information that all ids in this contract will default to.
2047      *
2048      * Requirements:
2049      *
2050      * - `receiver` cannot be the zero address.
2051      * - `feeNumerator` cannot be greater than the fee denominator.
2052      */
2053     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
2054         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
2055         require(receiver != address(0), "ERC2981: invalid receiver");
2056 
2057         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
2058     }
2059 
2060     /**
2061      * @dev Removes default royalty information.
2062      */
2063     function _deleteDefaultRoyalty() internal virtual {
2064         delete _defaultRoyaltyInfo;
2065     }
2066 
2067     /**
2068      * @dev Sets the royalty information for a specific token id, overriding the global default.
2069      *
2070      * Requirements:
2071      *
2072      * - `receiver` cannot be the zero address.
2073      * - `feeNumerator` cannot be greater than the fee denominator.
2074      */
2075     function _setTokenRoyalty(uint256 tokenId, address receiver, uint96 feeNumerator) internal virtual {
2076         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
2077         require(receiver != address(0), "ERC2981: Invalid parameters");
2078 
2079         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
2080     }
2081 
2082     /**
2083      * @dev Resets royalty information for the token id back to the global default.
2084      */
2085     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
2086         delete _tokenRoyaltyInfo[tokenId];
2087     }
2088 }
2089 
2090 abstract contract DefaultOperatorFilterer is OperatorFilterer {
2091     /// @dev The constructor that is called when the contract is being deployed.
2092     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
2093 }
2094 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
2095 
2096 /**
2097  * @dev Interface of the ERC20 standard as defined in the EIP.
2098  */
2099 interface IERC20 {
2100     /**
2101      * @dev Emitted when `value` tokens are moved from one account (`from`) to
2102      * another (`to`).
2103      *
2104      * Note that `value` may be zero.
2105      */
2106     event Transfer(address indexed from, address indexed to, uint256 value);
2107 
2108     /**
2109      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
2110      * a call to {approve}. `value` is the new allowance.
2111      */
2112     event Approval(address indexed owner, address indexed spender, uint256 value);
2113 
2114     /**
2115      * @dev Returns the value of tokens in existence.
2116      */
2117     function totalSupply() external view returns (uint256);
2118 
2119     /**
2120      * @dev Returns the value of tokens owned by `account`.
2121      */
2122     function balanceOf(address account) external view returns (uint256);
2123 
2124     /**
2125      * @dev Moves a `value` amount of tokens from the caller's account to `to`.
2126      *
2127      * Returns a boolean value indicating whether the operation succeeded.
2128      *
2129      * Emits a {Transfer} event.
2130      */
2131     function transfer(address to, uint256 value) external returns (bool);
2132 
2133     /**
2134      * @dev Returns the remaining number of tokens that `spender` will be
2135      * allowed to spend on behalf of `owner` through {transferFrom}. This is
2136      * zero by default.
2137      *
2138      * This value changes when {approve} or {transferFrom} are called.
2139      */
2140     function allowance(address owner, address spender) external view returns (uint256);
2141 
2142     /**
2143      * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
2144      * caller's tokens.
2145      *
2146      * Returns a boolean value indicating whether the operation succeeded.
2147      *
2148      * IMPORTANT: Beware that changing an allowance with this method brings the risk
2149      * that someone may use both the old and the new allowance by unfortunate
2150      * transaction ordering. One possible solution to mitigate this race
2151      * condition is to first reduce the spender's allowance to 0 and set the
2152      * desired value afterwards:
2153      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2154      *
2155      * Emits an {Approval} event.
2156      */
2157     function approve(address spender, uint256 value) external returns (bool);
2158 
2159     /**
2160      * @dev Moves a `value` amount of tokens from `from` to `to` using the
2161      * allowance mechanism. `value` is then deducted from the caller's
2162      * allowance.
2163      *
2164      * Returns a boolean value indicating whether the operation succeeded.
2165      *
2166      * Emits a {Transfer} event.
2167      */
2168     function transferFrom(address from, address to, uint256 value) external returns (bool);
2169 }
2170 
2171 pragma solidity >=0.7.0 <0.9.0;
2172 
2173 
2174 error AlreadyClaimed();
2175 error InvalidMerkleProof();
2176 error WithdrawTransfer();
2177 
2178 abstract contract AOF721 is
2179     ERC721,
2180     ERC2981,
2181     ERC721Enumerable,
2182     AccessControl,
2183     DefaultOperatorFilterer
2184 {
2185     using Counters for Counters.Counter;
2186 
2187     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
2188     bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
2189     bytes32  public root;
2190     address public  USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
2191     uint256 public constant WlETHprice = 0.02 ether;
2192     uint256 public constant ETHprice = 0.025 ether;
2193     uint256 public  WlTokenprice = 40;
2194     uint256 public  Tokenprice = 50;
2195     uint256 public  MAX_SUPPLY = 2000;
2196     uint256 public  preMintCount = 1;
2197     bool public presaleActive;
2198     bool public publicsaleActive;
2199 
2200     mapping(address => bool) public claimed;
2201     mapping(address => uint256) public _alreadyMinted;
2202 
2203     event MintNft(address indexed _to, uint256 indexed _tokenId);
2204     Counters.Counter private _tokenIdCounter;
2205 
2206     string private _uriPrefix;
2207     IERC20 public token;
2208     address public receiver;
2209 
2210     constructor(
2211         string memory uriPrefix,
2212         string memory name,
2213         string memory symbol,
2214         uint256 initId_,
2215         address _token,
2216         address _receiver
2217     ) ERC721(name, symbol) {
2218         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
2219         _setupRole(MINTER_ROLE, msg.sender);
2220         _uriPrefix = uriPrefix;
2221         _tokenIdCounter.setInitValue(initId_);
2222         token = IERC20(_token);
2223         receiver = _receiver;
2224         WlTokenprice = WlTokenprice * 10 ** 6;
2225         Tokenprice = Tokenprice * 10 ** 6;
2226      
2227     }
2228 
2229     function _baseURI() internal view override returns (string memory) {
2230         return _uriPrefix;
2231     }
2232 
2233     function setURI(string memory newuri)
2234         external
2235         onlyRole(DEFAULT_ADMIN_ROLE)
2236     {
2237         _uriPrefix = newuri;
2238     }
2239 
2240     function safeMint(address to) public onlyMinter {
2241         uint256 tokenId = _tokenIdCounter.current();
2242         _tokenIdCounter.increment();
2243         _safeMint(to,tokenId);
2244     }
2245 
2246     function safeMint(address to, uint256 tokenId) public onlyMinter {
2247         _safeMint(to, tokenId);
2248     }
2249 
2250     function Wlmint(bytes32[] calldata proof) public payable {
2251         require(presaleActive,"Sale is closed");
2252         require(claimed[msg.sender] == false, "Already claimed");
2253         require(msg.value == WlETHprice || token.transferFrom(msg.sender, receiver, WlTokenprice), "Not enough ETH or token");
2254         
2255         bytes32 leaf = getLeaf(msg.sender);
2256         if(!MerkleProof.verify(proof,root,leaf)) revert InvalidMerkleProof();
2257         claimed[msg.sender] = true;
2258     
2259         _internalMint(msg.sender,preMintCount);
2260     }
2261 
2262      function publicMint(uint256 amount) public payable {
2263         require(publicsaleActive,"Sale is closed");
2264         require((_alreadyMinted[msg.sender] + amount) <= 3 ,"You can only mint 3 tokens");
2265         require(msg.value == ETHprice * amount || token.transferFrom(msg.sender, receiver, Tokenprice * amount), "Not enough ETH or token");
2266         _alreadyMinted[msg.sender] += amount;
2267         _internalMint(msg.sender,amount);
2268 
2269     }
2270 
2271      function _internalMint(address to,uint256 amount) internal   {
2272         require(MAX_SUPPLY >= totalSupply() + amount, "Will exceed maximum supply");
2273         for (uint256 i = 1; i <= amount; i++) {
2274                 _safeMint(to, _tokenIdCounter.current());
2275                 emit MintNft(to, _tokenIdCounter.current());
2276                 _tokenIdCounter.increment();
2277 
2278         }
2279 
2280      }
2281 
2282    
2283      function withDrawEth(address payable to)external onlyOwner{
2284          uint256 balance = address(this).balance;
2285          (bool success,) = to.call{value:balance}("");
2286          if(!success) revert WithdrawTransfer();
2287      }
2288 
2289     /**
2290      * @dev Burns `tokenId`. See {ERC721-_burn}.
2291      *
2292      * Requirements:
2293      *
2294      * - The caller must own `tokenId` or be an authorized operator.
2295      */
2296     function burn(uint256 tokenId) public {
2297         //solhint-disable-next-line max-line-length
2298         require(
2299             _isApprovedOrOwner(_msgSender(), tokenId) ||
2300                 hasRole(BURNER_ROLE, _msgSender()),
2301             "AOF: caller is not authorized to burn token"
2302         );
2303         _burn(tokenId);
2304     }
2305 
2306     function tokenURI(uint256 _tokenId)
2307         public
2308         view
2309         override
2310         returns (string memory)
2311     {
2312         return string(abi.encodePacked(_uriPrefix, Strings.toString(_tokenId)));
2313     }
2314 
2315     /**
2316      * @dev Throws if called by any account other than the owner nor the minter.
2317      */
2318     modifier onlyMinter() {
2319         require(
2320             hasRole(MINTER_ROLE, _msgSender()) ||
2321                 hasRole(DEFAULT_ADMIN_ROLE, _msgSender()),
2322             "AOF: caller is not the owner nor the minter"
2323         );
2324         _;
2325     }
2326 
2327     modifier onlyOwner() {
2328         require(
2329             hasRole(DEFAULT_ADMIN_ROLE, _msgSender()),
2330             "AOF: caller is not admin"
2331         );
2332         _;
2333     }
2334 
2335     function togglePublicSale() external onlyOwner {
2336         publicsaleActive = !publicsaleActive;
2337     }
2338 
2339     function togglePresale() external onlyOwner {
2340         presaleActive = !presaleActive;
2341     }
2342 
2343     /**
2344      * @dev Returns all the token IDs owned by address
2345      */
2346     function tokensOfOwner(address _addr)
2347         external
2348         view
2349         returns (uint256[] memory)
2350     {
2351         uint256 balance = balanceOf(_addr);
2352         uint256[] memory tokens = new uint256[](balance);
2353         for (uint256 i = 0; i < balance; i++) {
2354             tokens[i] = tokenOfOwnerByIndex(_addr, i);
2355         }
2356 
2357         return tokens;
2358     }
2359 
2360     function _beforeTokenTransfer(
2361         address from,
2362         address to,
2363         uint256 tokenId
2364     ) internal override(ERC721, ERC721Enumerable)  {
2365         super._beforeTokenTransfer(from, to, tokenId);
2366     }
2367 
2368     // The following functions are overrides required by Solidity.
2369 
2370     function supportsInterface(bytes4 interfaceId)
2371         public
2372         view
2373         override(ERC721, ERC721Enumerable, AccessControl,ERC2981)
2374         returns (bool)
2375     {
2376         return super.supportsInterface(interfaceId)|| ERC2981.supportsInterface(interfaceId);
2377     }
2378 
2379      function setApprovalForAll(address operator, bool approved) public  override(IERC721,ERC721) onlyAllowedOperatorApproval(operator) {
2380         super.setApprovalForAll(operator, approved);
2381     }
2382 
2383     function approve(address operator, uint256 tokenId) public  override(IERC721,ERC721) onlyAllowedOperatorApproval(operator) {
2384         super.approve(operator, tokenId);
2385     }
2386 
2387     function transferFrom(address from, address to, uint256 tokenId) public  override(IERC721,ERC721) onlyAllowedOperator(from) {
2388         super.transferFrom(from, to, tokenId);
2389     }
2390 
2391     function safeTransferFrom(address from, address to, uint256 tokenId) public  override(IERC721,ERC721) onlyAllowedOperator(from) {
2392         super.safeTransferFrom(from, to, tokenId);
2393     }
2394 
2395     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2396         public
2397         override(IERC721,ERC721)
2398         onlyAllowedOperator(from)
2399     {
2400         super.safeTransferFrom(from, to, tokenId, data);
2401     }
2402 
2403     function getLeaf(address account) internal pure returns (bytes32) {
2404         return keccak256(abi.encodePacked(account));
2405     }
2406 
2407     function setRoot(bytes32 _root) public onlyOwner{
2408         root = _root;
2409     }
2410 
2411     function setMaxSupply(uint256 _newMaxSupply) public onlyOwner{
2412         MAX_SUPPLY = _newMaxSupply;
2413     }
2414  }
2415 
2416 
2417 
2418 contract AOFPass is AOF721 {
2419     constructor(uint256 initId_,address _token, address _receiver)
2420         AOF721(
2421             "https://api.aof.games/aof721/",
2422             "aof Avatar",
2423             "AOFS",
2424             initId_,
2425             _token,
2426             _receiver
2427         )
2428     {}
2429 
2430 
2431 }