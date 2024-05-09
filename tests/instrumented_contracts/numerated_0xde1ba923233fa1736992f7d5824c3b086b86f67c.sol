1 // SPDX-License-Identifier: MIT
2 
3 // File @openzeppelin/contracts/utils/Address.sol@v4.3.2
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Collection of functions related to the address type
8  */
9 library Address {
10     /**
11      * @dev Returns true if `account` is a contract.
12      *
13      * [IMPORTANT]
14      * ====
15      * It is unsafe to assume that an address for which this function returns
16      * false is an externally-owned account (EOA) and not a contract.
17      *
18      * Among others, `isContract` will return false for the following
19      * types of addresses:
20      *
21      *  - an externally-owned account
22      *  - a contract in construction
23      *  - an address where a contract will be created
24      *  - an address where a contract lived, but was destroyed
25      * ====
26      */
27     function isContract(address account) internal view returns (bool) {
28         // This method relies on extcodesize, which returns 0 for contracts in
29         // construction, since the code is only stored at the end of the
30         // constructor execution.
31 
32         uint256 size;
33         assembly {
34             size := extcodesize(account)
35         }
36         return size > 0;
37     }
38 
39     /**
40      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
41      * `recipient`, forwarding all available gas and reverting on errors.
42      *
43      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
44      * of certain opcodes, possibly making contracts go over the 2300 gas limit
45      * imposed by `transfer`, making them unable to receive funds via
46      * `transfer`. {sendValue} removes this limitation.
47      *
48      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
49      *
50      * IMPORTANT: because control is transferred to `recipient`, care must be
51      * taken to not create reentrancy vulnerabilities. Consider using
52      * {ReentrancyGuard} or the
53      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
54      */
55     function sendValue(address payable recipient, uint256 amount) internal {
56         require(address(this).balance >= amount, "Address: insufficient balance");
57 
58         (bool success, ) = recipient.call{value: amount}("");
59         require(success, "Address: unable to send value, recipient may have reverted");
60     }
61 
62     /**
63      * @dev Performs a Solidity function call using a low level `call`. A
64      * plain `call` is an unsafe replacement for a function call: use this
65      * function instead.
66      *
67      * If `target` reverts with a revert reason, it is bubbled up by this
68      * function (like regular Solidity function calls).
69      *
70      * Returns the raw returned data. To convert to the expected return value,
71      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
72      *
73      * Requirements:
74      *
75      * - `target` must be a contract.
76      * - calling `target` with `data` must not revert.
77      *
78      * _Available since v3.1._
79      */
80     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
81         return functionCall(target, data, "Address: low-level call failed");
82     }
83 
84     /**
85      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
86      * `errorMessage` as a fallback revert reason when `target` reverts.
87      *
88      * _Available since v3.1._
89      */
90     function functionCall(
91         address target,
92         bytes memory data,
93         string memory errorMessage
94     ) internal returns (bytes memory) {
95         return functionCallWithValue(target, data, 0, errorMessage);
96     }
97 
98     /**
99      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
100      * but also transferring `value` wei to `target`.
101      *
102      * Requirements:
103      *
104      * - the calling contract must have an ETH balance of at least `value`.
105      * - the called Solidity function must be `payable`.
106      *
107      * _Available since v3.1._
108      */
109     function functionCallWithValue(
110         address target,
111         bytes memory data,
112         uint256 value
113     ) internal returns (bytes memory) {
114         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
115     }
116 
117     /**
118      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
119      * with `errorMessage` as a fallback revert reason when `target` reverts.
120      *
121      * _Available since v3.1._
122      */
123     function functionCallWithValue(
124         address target,
125         bytes memory data,
126         uint256 value,
127         string memory errorMessage
128     ) internal returns (bytes memory) {
129         require(address(this).balance >= value, "Address: insufficient balance for call");
130         require(isContract(target), "Address: call to non-contract");
131 
132         (bool success, bytes memory returndata) = target.call{value: value}(data);
133         return verifyCallResult(success, returndata, errorMessage);
134     }
135 
136     /**
137      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
138      * but performing a static call.
139      *
140      * _Available since v3.3._
141      */
142     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
143         return functionStaticCall(target, data, "Address: low-level static call failed");
144     }
145 
146     /**
147      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
148      * but performing a static call.
149      *
150      * _Available since v3.3._
151      */
152     function functionStaticCall(
153         address target,
154         bytes memory data,
155         string memory errorMessage
156     ) internal view returns (bytes memory) {
157         require(isContract(target), "Address: static call to non-contract");
158 
159         (bool success, bytes memory returndata) = target.staticcall(data);
160         return verifyCallResult(success, returndata, errorMessage);
161     }
162 
163     /**
164      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
165      * but performing a delegate call.
166      *
167      * _Available since v3.4._
168      */
169     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
170         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
171     }
172 
173     /**
174      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
175      * but performing a delegate call.
176      *
177      * _Available since v3.4._
178      */
179     function functionDelegateCall(
180         address target,
181         bytes memory data,
182         string memory errorMessage
183     ) internal returns (bytes memory) {
184         require(isContract(target), "Address: delegate call to non-contract");
185 
186         (bool success, bytes memory returndata) = target.delegatecall(data);
187         return verifyCallResult(success, returndata, errorMessage);
188     }
189 
190     /**
191      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
192      * revert reason using the provided one.
193      *
194      * _Available since v4.3._
195      */
196     function verifyCallResult(
197         bool success,
198         bytes memory returndata,
199         string memory errorMessage
200     ) internal pure returns (bytes memory) {
201         if (success) {
202             return returndata;
203         } else {
204             // Look for revert reason and bubble it up if present
205             if (returndata.length > 0) {
206                 // The easiest way to bubble the revert reason is using memory via assembly
207 
208                 assembly {
209                     let returndata_size := mload(returndata)
210                     revert(add(32, returndata), returndata_size)
211                 }
212             } else {
213                 revert(errorMessage);
214             }
215         }
216     }
217 }
218 
219 
220 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.2
221 pragma solidity ^0.8.0;
222 
223 /**
224  * @dev String operations.
225  */
226 library Strings {
227     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
228 
229     /**
230      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
231      */
232     function toString(uint256 value) internal pure returns (string memory) {
233         // Inspired by OraclizeAPI's implementation - MIT licence
234         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
235 
236         if (value == 0) {
237             return "0";
238         }
239         uint256 temp = value;
240         uint256 digits;
241         while (temp != 0) {
242             digits++;
243             temp /= 10;
244         }
245         bytes memory buffer = new bytes(digits);
246         while (value != 0) {
247             digits -= 1;
248             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
249             value /= 10;
250         }
251         return string(buffer);
252     }
253 
254     /**
255      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
256      */
257     function toHexString(uint256 value) internal pure returns (string memory) {
258         if (value == 0) {
259             return "0x00";
260         }
261         uint256 temp = value;
262         uint256 length = 0;
263         while (temp != 0) {
264             length++;
265             temp >>= 8;
266         }
267         return toHexString(value, length);
268     }
269 
270     /**
271      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
272      */
273     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
274         bytes memory buffer = new bytes(2 * length + 2);
275         buffer[0] = "0";
276         buffer[1] = "x";
277         for (uint256 i = 2 * length + 1; i > 1; --i) {
278             buffer[i] = _HEX_SYMBOLS[value & 0xf];
279             value >>= 4;
280         }
281         require(value == 0, "Strings: hex length insufficient");
282         return string(buffer);
283     }
284 }
285 
286 
287 // File @openzeppelin/contracts/utils/Counters.sol@v4.3.2
288 pragma solidity ^0.8.0;
289 
290 /**
291  * @title Counters
292  * @author Matt Condon (@shrugs)
293  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
294  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
295  *
296  * Include with `using Counters for Counters.Counter;`
297  */
298 library Counters {
299     struct Counter {
300         // This variable should never be directly accessed by users of the library: interactions must be restricted to
301         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
302         // this feature: see https://github.com/ethereum/solidity/issues/4637
303         uint256 _value; // default: 0
304     }
305 
306     function current(Counter storage counter) internal view returns (uint256) {
307         return counter._value;
308     }
309 
310     function increment(Counter storage counter) internal {
311         unchecked {
312             counter._value += 1;
313         }
314     }
315 
316     function decrement(Counter storage counter) internal {
317         uint256 value = counter._value;
318         require(value > 0, "Counter: decrement overflow");
319         unchecked {
320             counter._value = value - 1;
321         }
322     }
323 
324     function reset(Counter storage counter) internal {
325         counter._value = 0;
326     }
327 }
328 
329 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.2
330 pragma solidity ^0.8.0;
331 
332 /**
333  * @dev Interface of the ERC165 standard, as defined in the
334  * https://eips.ethereum.org/EIPS/eip-165[EIP].
335  *
336  * Implementers can declare support of contract interfaces, which can then be
337  * queried by others ({ERC165Checker}).
338  *
339  * For an implementation, see {ERC165}.
340  */
341 interface IERC165 {
342     /**
343      * @dev Returns true if this contract implements the interface defined by
344      * `interfaceId`. See the corresponding
345      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
346      * to learn more about how these ids are created.
347      *
348      * This function call must use less than 30 000 gas.
349      */
350     function supportsInterface(bytes4 interfaceId) external view returns (bool);
351 }
352 
353 
354 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.3.2
355 pragma solidity ^0.8.0;
356 
357 /**
358  * @dev Required interface of an ERC721 compliant contract.
359  */
360 interface IERC721 is IERC165 {
361     /**
362      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
363      */
364     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
365 
366     /**
367      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
368      */
369     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
370 
371     /**
372      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
373      */
374     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
375 
376     /**
377      * @dev Returns the number of tokens in ``owner``'s account.
378      */
379     function balanceOf(address owner) external view returns (uint256 balance);
380 
381     /**
382      * @dev Returns the owner of the `tokenId` token.
383      *
384      * Requirements:
385      *
386      * - `tokenId` must exist.
387      */
388     function ownerOf(uint256 tokenId) external view returns (address owner);
389 
390     /**
391      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
392      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
393      *
394      * Requirements:
395      *
396      * - `from` cannot be the zero address.
397      * - `to` cannot be the zero address.
398      * - `tokenId` token must exist and be owned by `from`.
399      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
400      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
401      *
402      * Emits a {Transfer} event.
403      */
404     function safeTransferFrom(
405         address from,
406         address to,
407         uint256 tokenId
408     ) external;
409 
410     /**
411      * @dev Transfers `tokenId` token from `from` to `to`.
412      *
413      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
414      *
415      * Requirements:
416      *
417      * - `from` cannot be the zero address.
418      * - `to` cannot be the zero address.
419      * - `tokenId` token must be owned by `from`.
420      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
421      *
422      * Emits a {Transfer} event.
423      */
424     function transferFrom(
425         address from,
426         address to,
427         uint256 tokenId
428     ) external;
429 
430     /**
431      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
432      * The approval is cleared when the token is transferred.
433      *
434      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
435      *
436      * Requirements:
437      *
438      * - The caller must own the token or be an approved operator.
439      * - `tokenId` must exist.
440      *
441      * Emits an {Approval} event.
442      */
443     function approve(address to, uint256 tokenId) external;
444 
445     /**
446      * @dev Returns the account approved for `tokenId` token.
447      *
448      * Requirements:
449      *
450      * - `tokenId` must exist.
451      */
452     function getApproved(uint256 tokenId) external view returns (address operator);
453 
454     /**
455      * @dev Approve or remove `operator` as an operator for the caller.
456      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
457      *
458      * Requirements:
459      *
460      * - The `operator` cannot be the caller.
461      *
462      * Emits an {ApprovalForAll} event.
463      */
464     function setApprovalForAll(address operator, bool _approved) external;
465 
466     /**
467      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
468      *
469      * See {setApprovalForAll}
470      */
471     function isApprovedForAll(address owner, address operator) external view returns (bool);
472 
473     /**
474      * @dev Safely transfers `tokenId` token from `from` to `to`.
475      *
476      * Requirements:
477      *
478      * - `from` cannot be the zero address.
479      * - `to` cannot be the zero address.
480      * - `tokenId` token must exist and be owned by `from`.
481      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
482      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
483      *
484      * Emits a {Transfer} event.
485      */
486     function safeTransferFrom(
487         address from,
488         address to,
489         uint256 tokenId,
490         bytes calldata data
491     ) external;
492 }
493 
494 
495 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.3.2
496 pragma solidity ^0.8.0;
497 
498 /**
499  * @title ERC721 token receiver interface
500  * @dev Interface for any contract that wants to support safeTransfers
501  * from ERC721 asset contracts.
502  */
503 interface IERC721Receiver {
504     /**
505      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
506      * by `operator` from `from`, this function is called.
507      *
508      * It must return its Solidity selector to confirm the token transfer.
509      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
510      *
511      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
512      */
513     function onERC721Received(
514         address operator,
515         address from,
516         uint256 tokenId,
517         bytes calldata data
518     ) external returns (bytes4);
519 }
520 
521 
522 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.3.2
523 pragma solidity ^0.8.0;
524 
525 /**
526  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
527  * @dev See https://eips.ethereum.org/EIPS/eip-721
528  */
529 interface IERC721Metadata is IERC721 {
530     /**
531      * @dev Returns the token collection name.
532      */
533     function name() external view returns (string memory);
534 
535     /**
536      * @dev Returns the token collection symbol.
537      */
538     function symbol() external view returns (string memory);
539 
540     /**
541      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
542      */
543     function tokenURI(uint256 tokenId) external view returns (string memory);
544 }
545 
546 
547 
548 
549 
550 // File @openzeppelin/contracts/utils/Context.sol@v4.3.2
551 pragma solidity ^0.8.0;
552 
553 /**
554  * @dev Provides information about the current execution context, including the
555  * sender of the transaction and its data. While these are generally available
556  * via msg.sender and msg.data, they should not be accessed in such a direct
557  * manner, since when dealing with meta-transactions the account sending and
558  * paying for execution may not be the actual sender (as far as an application
559  * is concerned).
560  *
561  * This contract is only required for intermediate, library-like contracts.
562  */
563 abstract contract Context {
564     function _msgSender() internal view virtual returns (address) {
565         return msg.sender;
566     }
567 
568     function _msgData() internal view virtual returns (bytes calldata) {
569         return msg.data;
570     }
571 }
572 
573 
574 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.2
575 pragma solidity ^0.8.0;
576 
577 /**
578  * @dev Implementation of the {IERC165} interface.
579  *
580  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
581  * for the additional interface id that will be supported. For example:
582  *
583  * ```solidity
584  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
585  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
586  * }
587  * ```
588  *
589  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
590  */
591 abstract contract ERC165 is IERC165 {
592     /**
593      * @dev See {IERC165-supportsInterface}.
594      */
595     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
596         return interfaceId == type(IERC165).interfaceId;
597     }
598 }
599 
600 
601 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.3.2
602 pragma solidity ^0.8.0;
603 
604 /**
605  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
606  * the Metadata extension, but not including the Enumerable extension, which is available separately as
607  * {ERC721Enumerable}.
608  */
609 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
610     using Address for address;
611     using Strings for uint256;
612 
613     // Token name
614     string private _name;
615 
616     // Token symbol
617     string private _symbol;
618 
619     // Mapping from token ID to owner address
620     mapping(uint256 => address) private _owners;
621 
622     // Mapping owner address to token count
623     mapping(address => uint256) private _balances;
624 
625     // Mapping from token ID to approved address
626     mapping(uint256 => address) private _tokenApprovals;
627 
628     // Mapping from owner to operator approvals
629     mapping(address => mapping(address => bool)) private _operatorApprovals;
630 
631     /**
632      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
633      */
634     constructor(string memory name_, string memory symbol_) {
635         _name = name_;
636         _symbol = symbol_;
637     }
638 
639     /**
640      * @dev See {IERC165-supportsInterface}.
641      */
642     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
643         return
644             interfaceId == type(IERC721).interfaceId ||
645             interfaceId == type(IERC721Metadata).interfaceId ||
646             super.supportsInterface(interfaceId);
647     }
648 
649     /**
650      * @dev See {IERC721-balanceOf}.
651      */
652     function balanceOf(address owner) public view virtual override returns (uint256) {
653         require(owner != address(0), "ERC721: balance query for the zero address");
654         return _balances[owner];
655     }
656 
657     /**
658      * @dev See {IERC721-ownerOf}.
659      */
660     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
661         address owner = _owners[tokenId];
662         require(owner != address(0), "ERC721: owner query for nonexistent token");
663         return owner;
664     }
665 
666     /**
667      * @dev See {IERC721Metadata-name}.
668      */
669     function name() public view virtual override returns (string memory) {
670         return _name;
671     }
672 
673     /**
674      * @dev See {IERC721Metadata-symbol}.
675      */
676     function symbol() public view virtual override returns (string memory) {
677         return _symbol;
678     }
679 
680     /**
681      * @dev See {IERC721Metadata-tokenURI}.
682      */
683     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
684         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
685 
686         string memory baseURI = _baseURI();
687         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
688     }
689 
690     /**
691      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
692      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
693      * by default, can be overriden in child contracts.
694      */
695     function _baseURI() internal view virtual returns (string memory) {
696         return "";
697     }
698 
699     /**
700      * @dev See {IERC721-approve}.
701      */
702     function approve(address to, uint256 tokenId) public virtual override {
703         address owner = ERC721.ownerOf(tokenId);
704         require(to != owner, "ERC721: approval to current owner");
705 
706         require(
707             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
708             "ERC721: approve caller is not owner nor approved for all"
709         );
710 
711         _approve(to, tokenId);
712     }
713 
714     /**
715      * @dev See {IERC721-getApproved}.
716      */
717     function getApproved(uint256 tokenId) public view virtual override returns (address) {
718         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
719 
720         return _tokenApprovals[tokenId];
721     }
722 
723     /**
724      * @dev See {IERC721-setApprovalForAll}.
725      */
726     function setApprovalForAll(address operator, bool approved) public virtual override {
727         require(operator != _msgSender(), "ERC721: approve to caller");
728 
729         _operatorApprovals[_msgSender()][operator] = approved;
730         emit ApprovalForAll(_msgSender(), operator, approved);
731     }
732 
733     /**
734      * @dev See {IERC721-isApprovedForAll}.
735      */
736     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
737         return _operatorApprovals[owner][operator];
738     }
739 
740     /**
741      * @dev See {IERC721-transferFrom}.
742      */
743     function transferFrom(
744         address from,
745         address to,
746         uint256 tokenId
747     ) public virtual override {
748         //solhint-disable-next-line max-line-length
749         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
750 
751         _transfer(from, to, tokenId);
752     }
753 
754     /**
755      * @dev See {IERC721-safeTransferFrom}.
756      */
757     function safeTransferFrom(
758         address from,
759         address to,
760         uint256 tokenId
761     ) public virtual override {
762         safeTransferFrom(from, to, tokenId, "");
763     }
764 
765     /**
766      * @dev See {IERC721-safeTransferFrom}.
767      */
768     function safeTransferFrom(
769         address from,
770         address to,
771         uint256 tokenId,
772         bytes memory _data
773     ) public virtual override {
774         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
775         _safeTransfer(from, to, tokenId, _data);
776     }
777 
778     /**
779      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
780      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
781      *
782      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
783      *
784      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
785      * implement alternative mechanisms to perform token transfer, such as signature-based.
786      *
787      * Requirements:
788      *
789      * - `from` cannot be the zero address.
790      * - `to` cannot be the zero address.
791      * - `tokenId` token must exist and be owned by `from`.
792      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
793      *
794      * Emits a {Transfer} event.
795      */
796     function _safeTransfer(
797         address from,
798         address to,
799         uint256 tokenId,
800         bytes memory _data
801     ) internal virtual {
802         _transfer(from, to, tokenId);
803         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
804     }
805 
806     /**
807      * @dev Returns whether `tokenId` exists.
808      *
809      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
810      *
811      * Tokens start existing when they are minted (`_mint`),
812      * and stop existing when they are burned (`_burn`).
813      */
814     function _exists(uint256 tokenId) internal view virtual returns (bool) {
815         return _owners[tokenId] != address(0);
816     }
817 
818     /**
819      * @dev Returns whether `spender` is allowed to manage `tokenId`.
820      *
821      * Requirements:
822      *
823      * - `tokenId` must exist.
824      */
825     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
826         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
827         address owner = ERC721.ownerOf(tokenId);
828         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
829     }
830 
831     /**
832      * @dev Safely mints `tokenId` and transfers it to `to`.
833      *
834      * Requirements:
835      *
836      * - `tokenId` must not exist.
837      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
838      *
839      * Emits a {Transfer} event.
840      */
841     function _safeMint(address to, uint256 tokenId) internal virtual {
842         _safeMint(to, tokenId, "");
843     }
844 
845     /**
846      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
847      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
848      */
849     function _safeMint(
850         address to,
851         uint256 tokenId,
852         bytes memory _data
853     ) internal virtual {
854         _mint(to, tokenId);
855         require(
856             _checkOnERC721Received(address(0), to, tokenId, _data),
857             "ERC721: transfer to non ERC721Receiver implementer"
858         );
859     }
860 
861     /**
862      * @dev Mints `tokenId` and transfers it to `to`.
863      *
864      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
865      *
866      * Requirements:
867      *
868      * - `tokenId` must not exist.
869      * - `to` cannot be the zero address.
870      *
871      * Emits a {Transfer} event.
872      */
873     function _mint(address to, uint256 tokenId) internal virtual {
874         require(to != address(0), "ERC721: mint to the zero address");
875         require(!_exists(tokenId), "ERC721: token already minted");
876 
877         _beforeTokenTransfer(address(0), to, tokenId);
878 
879         _balances[to] += 1;
880         _owners[tokenId] = to;
881 
882         emit Transfer(address(0), to, tokenId);
883     }
884 
885     /**
886      * @dev Destroys `tokenId`.
887      * The approval is cleared when the token is burned.
888      *
889      * Requirements:
890      *
891      * - `tokenId` must exist.
892      *
893      * Emits a {Transfer} event.
894      */
895     function _burn(uint256 tokenId) internal virtual {
896         address owner = ERC721.ownerOf(tokenId);
897 
898         _beforeTokenTransfer(owner, address(0), tokenId);
899 
900         // Clear approvals
901         _approve(address(0), tokenId);
902 
903         _balances[owner] -= 1;
904         delete _owners[tokenId];
905 
906         emit Transfer(owner, address(0), tokenId);
907     }
908 
909     /**
910      * @dev Transfers `tokenId` from `from` to `to`.
911      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
912      *
913      * Requirements:
914      *
915      * - `to` cannot be the zero address.
916      * - `tokenId` token must be owned by `from`.
917      *
918      * Emits a {Transfer} event.
919      */
920     function _transfer(
921         address from,
922         address to,
923         uint256 tokenId
924     ) internal virtual {
925         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
926         require(to != address(0), "ERC721: transfer to the zero address");
927 
928         _beforeTokenTransfer(from, to, tokenId);
929 
930         // Clear approvals from the previous owner
931         _approve(address(0), tokenId);
932 
933         _balances[from] -= 1;
934         _balances[to] += 1;
935         _owners[tokenId] = to;
936 
937         emit Transfer(from, to, tokenId);
938     }
939 
940     /**
941      * @dev Approve `to` to operate on `tokenId`
942      *
943      * Emits a {Approval} event.
944      */
945     function _approve(address to, uint256 tokenId) internal virtual {
946         _tokenApprovals[tokenId] = to;
947         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
948     }
949 
950     /**
951      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
952      * The call is not executed if the target address is not a contract.
953      *
954      * @param from address representing the previous owner of the given token ID
955      * @param to target address that will receive the tokens
956      * @param tokenId uint256 ID of the token to be transferred
957      * @param _data bytes optional data to send along with the call
958      * @return bool whether the call correctly returned the expected magic value
959      */
960     function _checkOnERC721Received(
961         address from,
962         address to,
963         uint256 tokenId,
964         bytes memory _data
965     ) private returns (bool) {
966         if (to.isContract()) {
967             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
968                 return retval == IERC721Receiver.onERC721Received.selector;
969             } catch (bytes memory reason) {
970                 if (reason.length == 0) {
971                     revert("ERC721: transfer to non ERC721Receiver implementer");
972                 } else {
973                     assembly {
974                         revert(add(32, reason), mload(reason))
975                     }
976                 }
977             }
978         } else {
979             return true;
980         }
981     }
982 
983     /**
984      * @dev Hook that is called before any token transfer. This includes minting
985      * and burning.
986      *
987      * Calling conditions:
988      *
989      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
990      * transferred to `to`.
991      * - When `from` is zero, `tokenId` will be minted for `to`.
992      * - When `to` is zero, ``from``'s `tokenId` will be burned.
993      * - `from` and `to` are never both zero.
994      *
995      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
996      */
997     function _beforeTokenTransfer(
998         address from,
999         address to,
1000         uint256 tokenId
1001     ) internal virtual {}
1002 }
1003 
1004 
1005 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.3.2
1006 
1007 
1008 pragma solidity ^0.8.0;
1009 
1010 /**
1011  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1012  * @dev See https://eips.ethereum.org/EIPS/eip-721
1013  */
1014 interface IERC721Enumerable is IERC721 {
1015     /**
1016      * @dev Returns the total amount of tokens stored by the contract.
1017      */
1018     function totalSupply() external view returns (uint256);
1019 
1020     /**
1021      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1022      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1023      */
1024     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1025 
1026     /**
1027      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1028      * Use along with {totalSupply} to enumerate all tokens.
1029      */
1030     function tokenByIndex(uint256 index) external view returns (uint256);
1031 }
1032 
1033 
1034 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.3.2
1035 
1036 
1037 pragma solidity ^0.8.0;
1038 
1039 
1040 /**
1041  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1042  * enumerability of all the token ids in the contract as well as all token ids owned by each
1043  * account.
1044  */
1045 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1046     // Mapping from owner to list of owned token IDs
1047     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1048 
1049     // Mapping from token ID to index of the owner tokens list
1050     mapping(uint256 => uint256) private _ownedTokensIndex;
1051 
1052     // Array with all token ids, used for enumeration
1053     uint256[] private _allTokens;
1054 
1055     // Mapping from token id to position in the allTokens array
1056     mapping(uint256 => uint256) private _allTokensIndex;
1057 
1058     /**
1059      * @dev See {IERC165-supportsInterface}.
1060      */
1061     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1062         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1063     }
1064 
1065     /**
1066      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1067      */
1068     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1069         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1070         return _ownedTokens[owner][index];
1071     }
1072 
1073     /**
1074      * @dev See {IERC721Enumerable-totalSupply}.
1075      */
1076     function totalSupply() public view virtual override returns (uint256) {
1077         return _allTokens.length;
1078     }
1079 
1080     /**
1081      * @dev See {IERC721Enumerable-tokenByIndex}.
1082      */
1083     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1084         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1085         return _allTokens[index];
1086     }
1087 
1088     /**
1089      * @dev Hook that is called before any token transfer. This includes minting
1090      * and burning.
1091      *
1092      * Calling conditions:
1093      *
1094      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1095      * transferred to `to`.
1096      * - When `from` is zero, `tokenId` will be minted for `to`.
1097      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1098      * - `from` cannot be the zero address.
1099      * - `to` cannot be the zero address.
1100      *
1101      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1102      */
1103     function _beforeTokenTransfer(
1104         address from,
1105         address to,
1106         uint256 tokenId
1107     ) internal virtual override {
1108         super._beforeTokenTransfer(from, to, tokenId);
1109 
1110         if (from == address(0)) {
1111             _addTokenToAllTokensEnumeration(tokenId);
1112         } else if (from != to) {
1113             _removeTokenFromOwnerEnumeration(from, tokenId);
1114         }
1115         if (to == address(0)) {
1116             _removeTokenFromAllTokensEnumeration(tokenId);
1117         } else if (to != from) {
1118             _addTokenToOwnerEnumeration(to, tokenId);
1119         }
1120     }
1121 
1122     /**
1123      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1124      * @param to address representing the new owner of the given token ID
1125      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1126      */
1127     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1128         uint256 length = ERC721.balanceOf(to);
1129         _ownedTokens[to][length] = tokenId;
1130         _ownedTokensIndex[tokenId] = length;
1131     }
1132 
1133     /**
1134      * @dev Private function to add a token to this extension's token tracking data structures.
1135      * @param tokenId uint256 ID of the token to be added to the tokens list
1136      */
1137     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1138         _allTokensIndex[tokenId] = _allTokens.length;
1139         _allTokens.push(tokenId);
1140     }
1141 
1142     /**
1143      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1144      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1145      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1146      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1147      * @param from address representing the previous owner of the given token ID
1148      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1149      */
1150     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1151         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1152         // then delete the last slot (swap and pop).
1153 
1154         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1155         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1156 
1157         // When the token to delete is the last token, the swap operation is unnecessary
1158         if (tokenIndex != lastTokenIndex) {
1159             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1160 
1161             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1162             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1163         }
1164 
1165         // This also deletes the contents at the last position of the array
1166         delete _ownedTokensIndex[tokenId];
1167         delete _ownedTokens[from][lastTokenIndex];
1168     }
1169 
1170     /**
1171      * @dev Private function to remove a token from this extension's token tracking data structures.
1172      * This has O(1) time complexity, but alters the order of the _allTokens array.
1173      * @param tokenId uint256 ID of the token to be removed from the tokens list
1174      */
1175     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1176         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1177         // then delete the last slot (swap and pop).
1178 
1179         uint256 lastTokenIndex = _allTokens.length - 1;
1180         uint256 tokenIndex = _allTokensIndex[tokenId];
1181 
1182         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1183         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1184         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1185         uint256 lastTokenId = _allTokens[lastTokenIndex];
1186 
1187         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1188         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1189 
1190         // This also deletes the contents at the last position of the array
1191         delete _allTokensIndex[tokenId];
1192         _allTokens.pop();
1193     }
1194 }
1195 
1196 /**
1197  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1198  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1199  *
1200  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1201  *
1202  * Does not support burning tokens to address(0).
1203  */
1204 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1205     using Address for address;
1206     using Strings for uint256;
1207 
1208     struct TokenOwnership {
1209         address addr;
1210         uint64 startTimestamp;
1211     }
1212 
1213     struct AddressData {
1214         uint128 balance;
1215         uint128 numberMinted;
1216     }
1217 
1218     uint256 private currentIndex = 0;
1219 
1220     uint256 internal immutable maxBatchSize;
1221 
1222     // Token name
1223     string private _name;
1224 
1225     // Token symbol
1226     string private _symbol;
1227 
1228     // Mapping from token ID to ownership details
1229     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1230     mapping(uint256 => TokenOwnership) private _ownerships;
1231 
1232     // Mapping owner address to address data
1233     mapping(address => AddressData) private _addressData;
1234 
1235     // Mapping from token ID to approved address
1236     mapping(uint256 => address) private _tokenApprovals;
1237 
1238     // Mapping from owner to operator approvals
1239     mapping(address => mapping(address => bool)) private _operatorApprovals;
1240 
1241     /**
1242      * @dev
1243      * `maxBatchSize` refers to how much a minter can mint at a time.
1244      */
1245     constructor(
1246         string memory name_,
1247         string memory symbol_,
1248         uint256 maxBatchSize_
1249     ) {
1250         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1251         _name = name_;
1252         _symbol = symbol_;
1253         maxBatchSize = maxBatchSize_;
1254     }
1255 
1256     /**
1257      * @dev See {IERC721Enumerable-totalSupply}.
1258      */
1259     function totalSupply() public view override returns (uint256) {
1260         return currentIndex;
1261     }
1262 
1263     /**
1264      * @dev See {IERC721Enumerable-tokenByIndex}.
1265      */
1266     function tokenByIndex(uint256 index) public view override returns (uint256) {
1267         require(index < totalSupply(), "ERC721A: global index out of bounds");
1268         return index;
1269     }
1270 
1271     /**
1272      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1273      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
1274      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1275      */
1276     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
1277         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1278         uint256 numMintedSoFar = totalSupply();
1279         uint256 tokenIdsIdx = 0;
1280         address currOwnershipAddr = address(0);
1281         for (uint256 i = 0; i < numMintedSoFar; i++) {
1282             TokenOwnership memory ownership = _ownerships[i];
1283             if (ownership.addr != address(0)) {
1284                 currOwnershipAddr = ownership.addr;
1285             }
1286             if (currOwnershipAddr == owner) {
1287                 if (tokenIdsIdx == index) {
1288                     return i;
1289                 }
1290                 tokenIdsIdx++;
1291             }
1292         }
1293         revert("ERC721A: unable to get token of owner by index");
1294     }
1295 
1296     /**
1297      * @dev See {IERC165-supportsInterface}.
1298      */
1299     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1300         return
1301             interfaceId == type(IERC721).interfaceId ||
1302             interfaceId == type(IERC721Metadata).interfaceId ||
1303             interfaceId == type(IERC721Enumerable).interfaceId ||
1304             super.supportsInterface(interfaceId);
1305     }
1306 
1307     /**
1308      * @dev See {IERC721-balanceOf}.
1309      */
1310     function balanceOf(address owner) public view override returns (uint256) {
1311         require(owner != address(0), "ERC721A: balance query for the zero address");
1312         return uint256(_addressData[owner].balance);
1313     }
1314 
1315     function _numberMinted(address owner) internal view returns (uint256) {
1316         require(owner != address(0), "ERC721A: number minted query for the zero address");
1317         return uint256(_addressData[owner].numberMinted);
1318     }
1319 
1320     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1321         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1322 
1323         uint256 lowestTokenToCheck;
1324         if (tokenId >= maxBatchSize) {
1325             lowestTokenToCheck = tokenId - maxBatchSize + 1;
1326         }
1327 
1328         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1329             TokenOwnership memory ownership = _ownerships[curr];
1330             if (ownership.addr != address(0)) {
1331                 return ownership;
1332             }
1333         }
1334 
1335         revert("ERC721A: unable to determine the owner of token");
1336     }
1337 
1338     /**
1339      * @dev See {IERC721-ownerOf}.
1340      */
1341     function ownerOf(uint256 tokenId) public view override returns (address) {
1342         return ownershipOf(tokenId).addr;
1343     }
1344 
1345     /**
1346      * @dev See {IERC721Metadata-name}.
1347      */
1348     function name() public view virtual override returns (string memory) {
1349         return _name;
1350     }
1351 
1352     /**
1353      * @dev See {IERC721Metadata-symbol}.
1354      */
1355     function symbol() public view virtual override returns (string memory) {
1356         return _symbol;
1357     }
1358 
1359     /**
1360      * @dev See {IERC721Metadata-tokenURI}.
1361      */
1362     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1363         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1364 
1365         string memory baseURI = _baseURI();
1366         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1367     }
1368 
1369     /**
1370      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1371      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1372      * by default, can be overriden in child contracts.
1373      */
1374     function _baseURI() internal view virtual returns (string memory) {
1375         return "";
1376     }
1377 
1378     /**
1379      * @dev See {IERC721-approve}.
1380      */
1381     function approve(address to, uint256 tokenId) public override {
1382         address owner = ERC721A.ownerOf(tokenId);
1383         require(to != owner, "ERC721A: approval to current owner");
1384 
1385         require(
1386             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1387             "ERC721A: approve caller is not owner nor approved for all"
1388         );
1389 
1390         _approve(to, tokenId, owner);
1391     }
1392 
1393     /**
1394      * @dev See {IERC721-getApproved}.
1395      */
1396     function getApproved(uint256 tokenId) public view override returns (address) {
1397         require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1398 
1399         return _tokenApprovals[tokenId];
1400     }
1401 
1402     /**
1403      * @dev See {IERC721-setApprovalForAll}.
1404      */
1405     function setApprovalForAll(address operator, bool approved) public override {
1406         require(operator != _msgSender(), "ERC721A: approve to caller");
1407 
1408         _operatorApprovals[_msgSender()][operator] = approved;
1409         emit ApprovalForAll(_msgSender(), operator, approved);
1410     }
1411 
1412     /**
1413      * @dev See {IERC721-isApprovedForAll}.
1414      */
1415     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1416         return _operatorApprovals[owner][operator];
1417     }
1418 
1419     /**
1420      * @dev See {IERC721-transferFrom}.
1421      */
1422     function transferFrom(
1423         address from,
1424         address to,
1425         uint256 tokenId
1426     ) public override {
1427         _transfer(from, to, tokenId);
1428     }
1429 
1430     /**
1431      * @dev See {IERC721-safeTransferFrom}.
1432      */
1433     function safeTransferFrom(
1434         address from,
1435         address to,
1436         uint256 tokenId
1437     ) public override {
1438         safeTransferFrom(from, to, tokenId, "");
1439     }
1440 
1441     /**
1442      * @dev See {IERC721-safeTransferFrom}.
1443      */
1444     function safeTransferFrom(
1445         address from,
1446         address to,
1447         uint256 tokenId,
1448         bytes memory _data
1449     ) public override {
1450         _transfer(from, to, tokenId);
1451         require(
1452             _checkOnERC721Received(from, to, tokenId, _data),
1453             "ERC721A: transfer to non ERC721Receiver implementer"
1454         );
1455     }
1456 
1457     /**
1458      * @dev Returns whether `tokenId` exists.
1459      *
1460      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1461      *
1462      * Tokens start existing when they are minted (`_mint`),
1463      */
1464     function _exists(uint256 tokenId) internal view returns (bool) {
1465         return tokenId < currentIndex;
1466     }
1467 
1468     function _safeMint(address to, uint256 quantity) internal {
1469         _safeMint(to, quantity, "");
1470     }
1471 
1472     /**
1473      * @dev Mints `quantity` tokens and transfers them to `to`.
1474      *
1475      * Requirements:
1476      *
1477      * - `to` cannot be the zero address.
1478      * - `quantity` cannot be larger than the max batch size.
1479      *
1480      * Emits a {Transfer} event.
1481      */
1482     function _safeMint(
1483         address to,
1484         uint256 quantity,
1485         bytes memory _data
1486     ) internal {
1487         uint256 startTokenId = currentIndex;
1488         require(to != address(0), "ERC721A: mint to the zero address");
1489         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1490         require(!_exists(startTokenId), "ERC721A: token already minted");
1491         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1492 
1493         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1494 
1495         AddressData memory addressData = _addressData[to];
1496         _addressData[to] = AddressData(
1497             addressData.balance + uint128(quantity),
1498             addressData.numberMinted + uint128(quantity)
1499         );
1500         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1501 
1502         uint256 updatedIndex = startTokenId;
1503 
1504         for (uint256 i = 0; i < quantity; i++) {
1505             emit Transfer(address(0), to, updatedIndex);
1506             require(
1507                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1508                 "ERC721A: transfer to non ERC721Receiver implementer"
1509             );
1510             updatedIndex++;
1511         }
1512 
1513         currentIndex = updatedIndex;
1514         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1515     }
1516 
1517     /**
1518      * @dev Transfers `tokenId` from `from` to `to`.
1519      *
1520      * Requirements:
1521      *
1522      * - `to` cannot be the zero address.
1523      * - `tokenId` token must be owned by `from`.
1524      *
1525      * Emits a {Transfer} event.
1526      */
1527     function _transfer(
1528         address from,
1529         address to,
1530         uint256 tokenId
1531     ) private {
1532         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1533 
1534         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1535             getApproved(tokenId) == _msgSender() ||
1536             isApprovedForAll(prevOwnership.addr, _msgSender()));
1537 
1538         require(isApprovedOrOwner, "ERC721A: transfer caller is not owner nor approved");
1539 
1540         require(prevOwnership.addr == from, "ERC721A: transfer from incorrect owner");
1541         require(to != address(0), "ERC721A: transfer to the zero address");
1542 
1543         _beforeTokenTransfers(from, to, tokenId, 1);
1544 
1545         // Clear approvals from the previous owner
1546         _approve(address(0), tokenId, prevOwnership.addr);
1547 
1548         _addressData[from].balance -= 1;
1549         _addressData[to].balance += 1;
1550         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1551 
1552         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1553         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1554         uint256 nextTokenId = tokenId + 1;
1555         if (_ownerships[nextTokenId].addr == address(0)) {
1556             if (_exists(nextTokenId)) {
1557                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1558             }
1559         }
1560 
1561         emit Transfer(from, to, tokenId);
1562         _afterTokenTransfers(from, to, tokenId, 1);
1563     }
1564 
1565     /**
1566      * @dev Approve `to` to operate on `tokenId`
1567      *
1568      * Emits a {Approval} event.
1569      */
1570     function _approve(
1571         address to,
1572         uint256 tokenId,
1573         address owner
1574     ) private {
1575         _tokenApprovals[tokenId] = to;
1576         emit Approval(owner, to, tokenId);
1577     }
1578 
1579     uint256 public nextOwnerToExplicitlySet = 0;
1580 
1581     /**
1582      * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1583      */
1584     function _setOwnersExplicit(uint256 quantity) internal {
1585         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1586         require(quantity > 0, "quantity must be nonzero");
1587         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1588         if (endIndex > currentIndex - 1) {
1589             endIndex = currentIndex - 1;
1590         }
1591         // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1592         require(_exists(endIndex), "not enough minted yet for this cleanup");
1593         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1594             if (_ownerships[i].addr == address(0)) {
1595                 TokenOwnership memory ownership = ownershipOf(i);
1596                 _ownerships[i] = TokenOwnership(ownership.addr, ownership.startTimestamp);
1597             }
1598         }
1599         nextOwnerToExplicitlySet = endIndex + 1;
1600     }
1601 
1602     /**
1603      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1604      * The call is not executed if the target address is not a contract.
1605      *
1606      * @param from address representing the previous owner of the given token ID
1607      * @param to target address that will receive the tokens
1608      * @param tokenId uint256 ID of the token to be transferred
1609      * @param _data bytes optional data to send along with the call
1610      * @return bool whether the call correctly returned the expected magic value
1611      */
1612     function _checkOnERC721Received(
1613         address from,
1614         address to,
1615         uint256 tokenId,
1616         bytes memory _data
1617     ) private returns (bool) {
1618         if (to.isContract()) {
1619             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1620                 return retval == IERC721Receiver(to).onERC721Received.selector;
1621             } catch (bytes memory reason) {
1622                 if (reason.length == 0) {
1623                     revert("ERC721A: transfer to non ERC721Receiver implementer");
1624                 } else {
1625                     assembly {
1626                         revert(add(32, reason), mload(reason))
1627                     }
1628                 }
1629             }
1630         } else {
1631             return true;
1632         }
1633     }
1634 
1635     /**
1636      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1637      *
1638      * startTokenId - the first token id to be transferred
1639      * quantity - the amount to be transferred
1640      *
1641      * Calling conditions:
1642      *
1643      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1644      * transferred to `to`.
1645      * - When `from` is zero, `tokenId` will be minted for `to`.
1646      */
1647     function _beforeTokenTransfers(
1648         address from,
1649         address to,
1650         uint256 startTokenId,
1651         uint256 quantity
1652     ) internal virtual {}
1653 
1654     /**
1655      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1656      * minting.
1657      *
1658      * startTokenId - the first token id to be transferred
1659      * quantity - the amount to be transferred
1660      *
1661      * Calling conditions:
1662      *
1663      * - when `from` and `to` are both non-zero.
1664      * - `from` and `to` are never both zero.
1665      */
1666     function _afterTokenTransfers(
1667         address from,
1668         address to,
1669         uint256 startTokenId,
1670         uint256 quantity
1671     ) internal virtual {}
1672 }
1673 
1674 pragma solidity ^0.8.9;
1675 
1676 contract MissMetaverse is ERC721A
1677 {
1678     using Strings for uint256;
1679 
1680     string public baseURI;
1681     uint256 public cost;
1682     uint256 public maxSupply;
1683     uint256 public maxMintAmount = 12;
1684     uint256 public maxMintPerTransaction;
1685     uint256 private podiumAwardsCount;
1686     address public owner;
1687     bool public preSaleLive;
1688     bool public mintLive;
1689 
1690     mapping(address => bool) private whiteList;
1691     mapping(address => uint256) private mintCount;
1692     mapping(uint256 => string) private podiumAwards;
1693 
1694     modifier onlyOwner() {
1695         require(owner == msg.sender, "not owner");
1696         _;
1697     }
1698 
1699     modifier preSaleIsLive() {
1700         require(preSaleLive, "preSale not live");
1701         _;
1702     }
1703 
1704     modifier mintIsLive() {
1705         require(mintLive, "mint not live");
1706         _;
1707     }
1708 
1709     constructor(string memory defaultBaseURI) ERC721A("Miss Metaverse", "MM", maxMintAmount) {
1710         owner = msg.sender;
1711         baseURI = defaultBaseURI;
1712         maxSupply = 7500;
1713         maxMintPerTransaction = 4;
1714         cost = 0.05 ether;
1715         podiumAwardsCount = 20;
1716     }
1717 
1718     function isWhiteListed(address _address) public view returns (bool){
1719         return whiteList[_address];
1720     }
1721 
1722     function mintedByAddressCount(address _address) public view returns (uint256){
1723         return mintCount[_address];
1724     }
1725 
1726     // Minting functions
1727     function mint(uint256 _mintAmount) external payable mintIsLive {
1728         address _to = msg.sender;
1729         uint256 minted = mintCount[_to];
1730         require(minted + _mintAmount <= maxMintAmount, "mint over max");
1731         require(_mintAmount <= maxMintPerTransaction, "amount must < max");
1732         require(totalSupply() + _mintAmount <= maxSupply, "mint over supply");
1733         require(msg.value >= cost * _mintAmount, "insufficient funds");
1734 
1735         mintCount[_to] = minted + _mintAmount;
1736         _safeMint(msg.sender, _mintAmount);
1737     }
1738 
1739     function preSaleMint(uint256 _mintAmount) external payable preSaleIsLive {
1740         address _to = msg.sender;
1741         uint256 minted = mintCount[_to];
1742         require(whiteList[_to], "not whitelisted");
1743         require(minted + _mintAmount <= maxMintAmount, "mint over max");
1744         require(totalSupply() + _mintAmount <= maxSupply, "mint over supply");
1745         require(msg.value >= cost * _mintAmount, "insufficient funds");
1746 
1747         mintCount[_to] = minted + _mintAmount;
1748         _safeMint(msg.sender, _mintAmount);
1749     }
1750 
1751     // Only Owner executable functions
1752     function mintByOwner(address _to, uint256 _mintAmount) external onlyOwner {
1753         require(totalSupply() + _mintAmount <= maxSupply, "mint over supply");
1754         if (_mintAmount <= maxBatchSize) {
1755             _safeMint(_to, _mintAmount);
1756             return;
1757         }
1758         
1759         uint256 leftToMint = _mintAmount;
1760         while (leftToMint > 0) {
1761             if (leftToMint <= maxBatchSize) {
1762                 _safeMint(_to, leftToMint);
1763                 return;
1764             }
1765             _safeMint(_to, maxBatchSize);
1766             leftToMint = leftToMint - maxBatchSize;
1767         }
1768     }
1769 
1770     function addToWhiteList(address[] calldata _addresses) external onlyOwner {
1771         for (uint256 i; i < _addresses.length; i++) {
1772             whiteList[_addresses[i]] = true;
1773         }
1774     }
1775 
1776     function togglePreSaleLive() external onlyOwner {
1777         if (preSaleLive) {
1778             preSaleLive = false;
1779             return;
1780         }
1781         preSaleLive = true;
1782     }
1783 
1784     function toggleMintLive() external onlyOwner {
1785         if (mintLive) {
1786             mintLive = false;
1787             return;
1788         }
1789         preSaleLive = false;
1790         mintLive = true;
1791     }
1792 
1793     function setBaseURI(string memory _newURI) external onlyOwner {
1794         baseURI = _newURI;
1795     }
1796 
1797     function withdraw() external payable onlyOwner {
1798         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1799         require(success, "Transfer failed");
1800     }
1801 
1802     function setOwnersExplicit(uint256 quantity) external onlyOwner {
1803         _setOwnersExplicit(quantity);
1804     }
1805 
1806     // token URI functionality
1807     function setPodiumAwardTokenURI(uint256 _tokenId, string memory _tokenURI) external onlyOwner {
1808         require(_tokenId < podiumAwardsCount, "tokenId above max awards");
1809         podiumAwards[_tokenId] = _tokenURI;
1810     }
1811 
1812     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1813         require(_exists(_tokenId), "URI query for nonexistent token");
1814 
1815         if (bytes(podiumAwards[_tokenId]).length > 0) {
1816             return podiumAwards[_tokenId];
1817         }
1818 
1819         string memory baseTokenURI = _baseURI();
1820         string memory json = ".json";
1821         return bytes(baseTokenURI).length > 0
1822             ? string(abi.encodePacked(baseTokenURI, _tokenId.toString(), json))
1823             : '';
1824     }
1825 
1826     function _baseURI() internal view virtual override returns (string memory) {
1827         return baseURI;
1828     }
1829 
1830     fallback() external payable { }
1831 
1832     receive() external payable { }
1833 }