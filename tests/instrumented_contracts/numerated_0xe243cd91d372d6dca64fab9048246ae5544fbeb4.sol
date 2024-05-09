1 /**
2  *Submitted for verification at Etherscan.io on 2021-10-13
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 // Sources flattened with hardhat v2.3.0 https://hardhat.org
10 
11 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.1.0
12 
13 /**
14  * @dev Interface of the ERC165 standard, as defined in the
15  * https://eips.ethereum.org/EIPS/eip-165[EIP].
16  *
17  * Implementers can declare support of contract interfaces, which can then be
18  * queried by others ({ERC165Checker}).
19  *
20  * For an implementation, see {ERC165}.
21  */
22 interface IERC165 {
23     /**
24      * @dev Returns true if this contract implements the interface defined by
25      * `interfaceId`. See the corresponding
26      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
27      * to learn more about how these ids are created.
28      *
29      * This function call must use less than 30 000 gas.
30      */
31     function supportsInterface(bytes4 interfaceId) external view returns (bool);
32 }
33 
34 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.1.0
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Required interface of an ERC721 compliant contract.
40  */
41 interface IERC721 is IERC165 {
42     /**
43      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
44      */
45     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
46 
47     /**
48      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
49      */
50     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
51 
52     /**
53      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
54      */
55     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
56 
57     /**
58      * @dev Returns the number of tokens in ``owner``'s account.
59      */
60     function balanceOf(address owner) external view returns (uint256 balance);
61 
62     /**
63      * @dev Returns the owner of the `tokenId` token.
64      *
65      * Requirements:
66      *
67      * - `tokenId` must exist.
68      */
69     function ownerOf(uint256 tokenId) external view returns (address owner);
70 
71     /**
72      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
73      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
74      *
75      * Requirements:
76      *
77      * - `from` cannot be the zero address.
78      * - `to` cannot be the zero address.
79      * - `tokenId` token must exist and be owned by `from`.
80      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
81      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
82      *
83      * Emits a {Transfer} event.
84      */
85     function safeTransferFrom(
86         address from,
87         address to,
88         uint256 tokenId
89     ) external;
90 
91     /**
92      * @dev Transfers `tokenId` token from `from` to `to`.
93      *
94      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
95      *
96      * Requirements:
97      *
98      * - `from` cannot be the zero address.
99      * - `to` cannot be the zero address.
100      * - `tokenId` token must be owned by `from`.
101      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
102      *
103      * Emits a {Transfer} event.
104      */
105     function transferFrom(
106         address from,
107         address to,
108         uint256 tokenId
109     ) external;
110 
111     /**
112      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
113      * The approval is cleared when the token is transferred.
114      *
115      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
116      *
117      * Requirements:
118      *
119      * - The caller must own the token or be an approved operator.
120      * - `tokenId` must exist.
121      *
122      * Emits an {Approval} event.
123      */
124     function approve(address to, uint256 tokenId) external;
125 
126     /**
127      * @dev Returns the account approved for `tokenId` token.
128      *
129      * Requirements:
130      *
131      * - `tokenId` must exist.
132      */
133     function getApproved(uint256 tokenId) external view returns (address operator);
134 
135     /**
136      * @dev Approve or remove `operator` as an operator for the caller.
137      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
138      *
139      * Requirements:
140      *
141      * - The `operator` cannot be the caller.
142      *
143      * Emits an {ApprovalForAll} event.
144      */
145     function setApprovalForAll(address operator, bool _approved) external;
146 
147     /**
148      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
149      *
150      * See {setApprovalForAll}
151      */
152     function isApprovedForAll(address owner, address operator) external view returns (bool);
153 
154     /**
155      * @dev Safely transfers `tokenId` token from `from` to `to`.
156      *
157      * Requirements:
158      *
159      * - `from` cannot be the zero address.
160      * - `to` cannot be the zero address.
161      * - `tokenId` token must exist and be owned by `from`.
162      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
163      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
164      *
165      * Emits a {Transfer} event.
166      */
167     function safeTransferFrom(
168         address from,
169         address to,
170         uint256 tokenId,
171         bytes calldata data
172     ) external;
173 }
174 
175 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.1.0
176 
177 pragma solidity ^0.8.0;
178 
179 /**
180  * @title ERC721 token receiver interface
181  * @dev Interface for any contract that wants to support safeTransfers
182  * from ERC721 asset contracts.
183  */
184 interface IERC721Receiver {
185     /**
186      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
187      * by `operator` from `from`, this function is called.
188      *
189      * It must return its Solidity selector to confirm the token transfer.
190      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
191      *
192      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
193      */
194     function onERC721Received(
195         address operator,
196         address from,
197         uint256 tokenId,
198         bytes calldata data
199     ) external returns (bytes4);
200 }
201 
202 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.1.0
203 
204 pragma solidity ^0.8.0;
205 
206 /**
207  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
208  * @dev See https://eips.ethereum.org/EIPS/eip-721
209  */
210 interface IERC721Metadata is IERC721 {
211     /**
212      * @dev Returns the token collection name.
213      */
214     function name() external view returns (string memory);
215 
216     /**
217      * @dev Returns the token collection symbol.
218      */
219     function symbol() external view returns (string memory);
220 
221     /**
222      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
223      */
224     function tokenURI(uint256 tokenId) external view returns (string memory);
225 }
226 
227 // File @openzeppelin/contracts/utils/Address.sol@v4.1.0
228 
229 pragma solidity ^0.8.0;
230 
231 /**
232  * @dev Collection of functions related to the address type
233  */
234 library Address {
235     /**
236      * @dev Returns true if `account` is a contract.
237      *
238      * [IMPORTANT]
239      * ====
240      * It is unsafe to assume that an address for which this function returns
241      * false is an externally-owned account (EOA) and not a contract.
242      *
243      * Among others, `isContract` will return false for the following
244      * types of addresses:
245      *
246      *  - an externally-owned account
247      *  - a contract in construction
248      *  - an address where a contract will be created
249      *  - an address where a contract lived, but was destroyed
250      * ====
251      */
252     function isContract(address account) internal view returns (bool) {
253         // This method relies on extcodesize, which returns 0 for contracts in
254         // construction, since the code is only stored at the end of the
255         // constructor execution.
256 
257         uint256 size;
258         // solhint-disable-next-line no-inline-assembly
259         assembly {
260             size := extcodesize(account)
261         }
262         return size > 0;
263     }
264 
265     /**
266      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
267      * `recipient`, forwarding all available gas and reverting on errors.
268      *
269      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
270      * of certain opcodes, possibly making contracts go over the 2300 gas limit
271      * imposed by `transfer`, making them unable to receive funds via
272      * `transfer`. {sendValue} removes this limitation.
273      *
274      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
275      *
276      * IMPORTANT: because control is transferred to `recipient`, care must be
277      * taken to not create reentrancy vulnerabilities. Consider using
278      * {ReentrancyGuard} or the
279      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
280      */
281     function sendValue(address payable recipient, uint256 amount) internal {
282         require(address(this).balance >= amount, 'Address: insufficient balance');
283 
284         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
285         (bool success, ) = recipient.call{value: amount}('');
286         require(success, 'Address: unable to send value, recipient may have reverted');
287     }
288 
289     /**
290      * @dev Performs a Solidity function call using a low level `call`. A
291      * plain`call` is an unsafe replacement for a function call: use this
292      * function instead.
293      *
294      * If `target` reverts with a revert reason, it is bubbled up by this
295      * function (like regular Solidity function calls).
296      *
297      * Returns the raw returned data. To convert to the expected return value,
298      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
299      *
300      * Requirements:
301      *
302      * - `target` must be a contract.
303      * - calling `target` with `data` must not revert.
304      *
305      * _Available since v3.1._
306      */
307     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
308         return functionCall(target, data, 'Address: low-level call failed');
309     }
310 
311     /**
312      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
313      * `errorMessage` as a fallback revert reason when `target` reverts.
314      *
315      * _Available since v3.1._
316      */
317     function functionCall(
318         address target,
319         bytes memory data,
320         string memory errorMessage
321     ) internal returns (bytes memory) {
322         return functionCallWithValue(target, data, 0, errorMessage);
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
327      * but also transferring `value` wei to `target`.
328      *
329      * Requirements:
330      *
331      * - the calling contract must have an ETH balance of at least `value`.
332      * - the called Solidity function must be `payable`.
333      *
334      * _Available since v3.1._
335      */
336     function functionCallWithValue(
337         address target,
338         bytes memory data,
339         uint256 value
340     ) internal returns (bytes memory) {
341         return functionCallWithValue(target, data, value, 'Address: low-level call with value failed');
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
346      * with `errorMessage` as a fallback revert reason when `target` reverts.
347      *
348      * _Available since v3.1._
349      */
350     function functionCallWithValue(
351         address target,
352         bytes memory data,
353         uint256 value,
354         string memory errorMessage
355     ) internal returns (bytes memory) {
356         require(address(this).balance >= value, 'Address: insufficient balance for call');
357         require(isContract(target), 'Address: call to non-contract');
358 
359         // solhint-disable-next-line avoid-low-level-calls
360         (bool success, bytes memory returndata) = target.call{value: value}(data);
361         return _verifyCallResult(success, returndata, errorMessage);
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
366      * but performing a static call.
367      *
368      * _Available since v3.3._
369      */
370     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
371         return functionStaticCall(target, data, 'Address: low-level static call failed');
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
376      * but performing a static call.
377      *
378      * _Available since v3.3._
379      */
380     function functionStaticCall(
381         address target,
382         bytes memory data,
383         string memory errorMessage
384     ) internal view returns (bytes memory) {
385         require(isContract(target), 'Address: static call to non-contract');
386 
387         // solhint-disable-next-line avoid-low-level-calls
388         (bool success, bytes memory returndata) = target.staticcall(data);
389         return _verifyCallResult(success, returndata, errorMessage);
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
394      * but performing a delegate call.
395      *
396      * _Available since v3.4._
397      */
398     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
399         return functionDelegateCall(target, data, 'Address: low-level delegate call failed');
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
404      * but performing a delegate call.
405      *
406      * _Available since v3.4._
407      */
408     function functionDelegateCall(
409         address target,
410         bytes memory data,
411         string memory errorMessage
412     ) internal returns (bytes memory) {
413         require(isContract(target), 'Address: delegate call to non-contract');
414 
415         // solhint-disable-next-line avoid-low-level-calls
416         (bool success, bytes memory returndata) = target.delegatecall(data);
417         return _verifyCallResult(success, returndata, errorMessage);
418     }
419 
420     function _verifyCallResult(
421         bool success,
422         bytes memory returndata,
423         string memory errorMessage
424     ) private pure returns (bytes memory) {
425         if (success) {
426             return returndata;
427         } else {
428             // Look for revert reason and bubble it up if present
429             if (returndata.length > 0) {
430                 // The easiest way to bubble the revert reason is using memory via assembly
431 
432                 // solhint-disable-next-line no-inline-assembly
433                 assembly {
434                     let returndata_size := mload(returndata)
435                     revert(add(32, returndata), returndata_size)
436                 }
437             } else {
438                 revert(errorMessage);
439             }
440         }
441     }
442 }
443 
444 // File @openzeppelin/contracts/utils/Context.sol@v4.1.0
445 
446 pragma solidity ^0.8.0;
447 
448 /*
449  * @dev Provides information about the current execution context, including the
450  * sender of the transaction and its data. While these are generally available
451  * via msg.sender and msg.data, they should not be accessed in such a direct
452  * manner, since when dealing with meta-transactions the account sending and
453  * paying for execution may not be the actual sender (as far as an application
454  * is concerned).
455  *
456  * This contract is only required for intermediate, library-like contracts.
457  */
458 abstract contract Context {
459     function _msgSender() internal view virtual returns (address) {
460         return msg.sender;
461     }
462 
463     function _msgData() internal view virtual returns (bytes calldata) {
464         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
465         return msg.data;
466     }
467 }
468 
469 // File @openzeppelin/contracts/utils/Strings.sol@v4.1.0
470 
471 pragma solidity ^0.8.0;
472 
473 /**
474  * @dev String operations.
475  */
476 library Strings {
477     bytes16 private constant alphabet = '0123456789abcdef';
478 
479     /**
480      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
481      */
482     function toString(uint256 value) internal pure returns (string memory) {
483         // Inspired by OraclizeAPI's implementation - MIT licence
484         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
485 
486         if (value == 0) {
487             return '0';
488         }
489         uint256 temp = value;
490         uint256 digits;
491         while (temp != 0) {
492             digits++;
493             temp /= 10;
494         }
495         bytes memory buffer = new bytes(digits);
496         while (value != 0) {
497             digits -= 1;
498             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
499             value /= 10;
500         }
501         return string(buffer);
502     }
503 
504     /**
505      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
506      */
507     function toHexString(uint256 value) internal pure returns (string memory) {
508         if (value == 0) {
509             return '0x00';
510         }
511         uint256 temp = value;
512         uint256 length = 0;
513         while (temp != 0) {
514             length++;
515             temp >>= 8;
516         }
517         return toHexString(value, length);
518     }
519 
520     /**
521      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
522      */
523     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
524         bytes memory buffer = new bytes(2 * length + 2);
525         buffer[0] = '0';
526         buffer[1] = 'x';
527         for (uint256 i = 2 * length + 1; i > 1; --i) {
528             buffer[i] = alphabet[value & 0xf];
529             value >>= 4;
530         }
531         require(value == 0, 'Strings: hex length insufficient');
532         return string(buffer);
533     }
534 
535 
536     /**
537      * @dev format given uint to memory string
538      *
539      * @param _i uint to convert
540      * @return string is uint converted to string
541      */
542     function _uint2str(uint _i) internal pure returns (string memory) {
543       if (_i == 0) {
544         return "0";
545       }
546       uint j = _i;
547       uint len;
548       while (j != 0) {
549         len++;
550         j /= 10;
551       }
552       bytes memory bstr = new bytes(len);
553       uint k = len;
554       while (_i != 0) {
555         k = k-1;
556         uint8 temp = (48 + uint8(_i - _i / 10 * 10));
557         bytes1 b1 = bytes1(temp);
558         bstr[k] = b1;
559         _i /= 10;
560       }
561       return string(bstr);
562     }
563 
564 
565 }
566 
567 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.1.0
568 
569 pragma solidity ^0.8.0;
570 
571 /**
572  * @dev Implementation of the {IERC165} interface.
573  *
574  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
575  * for the additional interface id that will be supported. For example:
576  *
577  * ```solidity
578  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
579  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
580  * }
581  * ```
582  *
583  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
584  */
585 abstract contract ERC165 is IERC165 {
586     /**
587      * @dev See {IERC165-supportsInterface}.
588      */
589     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
590         return interfaceId == type(IERC165).interfaceId;
591     }
592 }
593 
594 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.1.0
595 
596 pragma solidity ^0.8.0;
597 
598 /**
599  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
600  * the Metadata extension, but not including the Enumerable extension, which is available separately as
601  * {ERC721Enumerable}.
602  */
603 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
604     using Address for address;
605     using Strings for uint256;
606 
607     // Token name
608     string private _name;
609 
610     // Token symbol
611     string private _symbol;
612 
613     // Mapping from token ID to owner address
614     mapping(uint256 => address) private _owners;
615 
616     // Mapping owner address to token count
617     mapping(address => uint256) private _balances;
618 
619     // Mapping from token ID to approved address
620     mapping(uint256 => address) private _tokenApprovals;
621 
622     // Mapping from owner to operator approvals
623     mapping(address => mapping(address => bool)) private _operatorApprovals;
624 
625     /**
626      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
627      */
628     constructor(string memory name_, string memory symbol_) {
629         _name = name_;
630         _symbol = symbol_;
631     }
632 
633     /**
634      * @dev See {IERC165-supportsInterface}.
635      */
636     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
637         return interfaceId == type(IERC721).interfaceId || interfaceId == type(IERC721Metadata).interfaceId || super.supportsInterface(interfaceId);
638     }
639 
640     /**
641      * @dev See {IERC721-balanceOf}.
642      */
643     function balanceOf(address owner) public view virtual override returns (uint256) {
644         require(owner != address(0), 'ERC721: balance query for the zero address');
645         return _balances[owner];
646     }
647 
648     /**
649      * @dev See {IERC721-ownerOf}.
650      */
651     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
652         address owner = _owners[tokenId];
653         require(owner != address(0), 'ERC721: owner query for nonexistent token');
654         return owner;
655     }
656 
657     /**
658      * @dev See {IERC721Metadata-name}.
659      */
660     function name() public view virtual override returns (string memory) {
661         return _name;
662     }
663 
664     /**
665      * @dev See {IERC721Metadata-symbol}.
666      */
667     function symbol() public view virtual override returns (string memory) {
668         return _symbol;
669     }
670 
671 
672 
673     /**
674      * @dev See {IERC721Metadata-tokenURI}.
675      */
676     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
677         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
678 
679         string memory baseURI = _baseURI();
680         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, abi.encodePacked(tokenId.toString(), ".json"))) : '';
681     }
682 
683     /**
684      * @dev Base URI for computing {tokenURI}. Empty by default, can be overriden
685      * in child contracts.
686      */
687     function _baseURI() internal view virtual returns (string memory) {
688         return '';
689     }
690 
691     /**
692      * @dev See {IERC721-approve}.
693      */
694     function approve(address to, uint256 tokenId) public virtual override {
695         address owner = ERC721.ownerOf(tokenId);
696         require(to != owner, 'ERC721: approval to current owner');
697 
698         require(_msgSender() == owner || isApprovedForAll(owner, _msgSender()), 'ERC721: approve caller is not owner nor approved for all');
699 
700         _approve(to, tokenId);
701     }
702 
703     /**
704      * @dev See {IERC721-getApproved}.
705      */
706     function getApproved(uint256 tokenId) public view virtual override returns (address) {
707         require(_exists(tokenId), 'ERC721: approved query for nonexistent token');
708 
709         return _tokenApprovals[tokenId];
710     }
711 
712     /**
713      * @dev See {IERC721-setApprovalForAll}.
714      */
715     function setApprovalForAll(address operator, bool approved) public virtual override {
716         require(operator != _msgSender(), 'ERC721: approve to caller');
717 
718         _operatorApprovals[_msgSender()][operator] = approved;
719         emit ApprovalForAll(_msgSender(), operator, approved);
720     }
721 
722     /**
723      * @dev See {IERC721-isApprovedForAll}.
724      */
725     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
726         return _operatorApprovals[owner][operator];
727     }
728 
729     /**
730      * @dev See {IERC721-transferFrom}.
731      */
732     function transferFrom(
733         address from,
734         address to,
735         uint256 tokenId
736     ) public virtual override {
737         //solhint-disable-next-line max-line-length
738         require(_isApprovedOrOwner(_msgSender(), tokenId), 'ERC721: transfer caller is not owner nor approved');
739 
740         _transfer(from, to, tokenId);
741     }
742 
743     /**
744      * @dev See {IERC721-safeTransferFrom}.
745      */
746     function safeTransferFrom(
747         address from,
748         address to,
749         uint256 tokenId
750     ) public virtual override {
751         safeTransferFrom(from, to, tokenId, '');
752     }
753 
754     /**
755      * @dev See {IERC721-safeTransferFrom}.
756      */
757     function safeTransferFrom(
758         address from,
759         address to,
760         uint256 tokenId,
761         bytes memory _data
762     ) public virtual override {
763         require(_isApprovedOrOwner(_msgSender(), tokenId), 'ERC721: transfer caller is not owner nor approved');
764         _safeTransfer(from, to, tokenId, _data);
765     }
766 
767     /**
768      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
769      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
770      *
771      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
772      *
773      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
774      * implement alternative mechanisms to perform token transfer, such as signature-based.
775      *
776      * Requirements:
777      *
778      * - `from` cannot be the zero address.
779      * - `to` cannot be the zero address.
780      * - `tokenId` token must exist and be owned by `from`.
781      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
782      *
783      * Emits a {Transfer} event.
784      */
785     function _safeTransfer(
786         address from,
787         address to,
788         uint256 tokenId,
789         bytes memory _data
790     ) internal virtual {
791         _transfer(from, to, tokenId);
792         require(_checkOnERC721Received(from, to, tokenId, _data), 'ERC721: transfer to non ERC721Receiver implementer');
793     }
794 
795     /**
796      * @dev Returns whether `tokenId` exists.
797      *
798      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
799      *
800      * Tokens start existing when they are minted (`_mint`),
801      * and stop existing when they are burned (`_burn`).
802      */
803     function _exists(uint256 tokenId) internal view virtual returns (bool) {
804         return _owners[tokenId] != address(0);
805     }
806 
807     /**
808      * @dev Returns whether `spender` is allowed to manage `tokenId`.
809      *
810      * Requirements:
811      *
812      * - `tokenId` must exist.
813      */
814     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
815         require(_exists(tokenId), 'ERC721: operator query for nonexistent token');
816         address owner = ERC721.ownerOf(tokenId);
817         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
818     }
819 
820     /**
821      * @dev Safely
822      s `tokenId` and transfers it to `to`.
823      *
824      * Requirements:
825      *
826      * - `tokenId` must not exist.
827      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
828      *
829      * Emits a {Transfer} event.
830      */
831     function _safeMint(address to, uint256 tokenId) internal virtual {
832         _safeMint(to, tokenId, '');
833     }
834 
835     /**
836      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
837      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
838      */
839     function _safeMint(
840         address to,
841         uint256 tokenId,
842         bytes memory _data
843     ) internal virtual {
844         _mint(to, tokenId);
845         require(_checkOnERC721Received(address(0), to, tokenId, _data), 'ERC721: transfer to non ERC721Receiver implementer');
846     }
847 
848     /**
849      * @dev Mints `tokenId` and transfers it to `to`.
850      *
851      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
852      *
853      * Requirements:
854      *
855      * - `tokenId` must not exist.
856      * - `to` cannot be the zero address.
857      *
858      * Emits a {Transfer} event.
859      */
860     function _mint(address to, uint256 tokenId) internal virtual {
861         require(to != address(0), 'ERC721: mint to the zero address');
862         require(!_exists(tokenId), 'ERC721: token already minted');
863 
864         _beforeTokenTransfer(address(0), to, tokenId);
865 
866         _balances[to] += 1;
867         _owners[tokenId] = to;
868 
869         emit Transfer(address(0), to, tokenId);
870     }
871 
872     /**
873      * @dev Destroys `tokenId`.
874      * The approval is cleared when the token is burned.
875      *
876      * Requirements:
877      *
878      * - `tokenId` must exist.
879      *
880      * Emits a {Transfer} event.
881      */
882     function _burn(uint256 tokenId) internal virtual {
883         address owner = ERC721.ownerOf(tokenId);
884 
885         _beforeTokenTransfer(owner, address(0), tokenId);
886 
887         // Clear approvals
888         _approve(address(0), tokenId);
889 
890         _balances[owner] -= 1;
891         delete _owners[tokenId];
892 
893         emit Transfer(owner, address(0), tokenId);
894     }
895 
896     /**
897      * @dev Transfers `tokenId` from `from` to `to`.
898      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
899      *
900      * Requirements:
901      *
902      * - `to` cannot be the zero address.
903      * - `tokenId` token must be owned by `from`.
904      *
905      * Emits a {Transfer} event.
906      */
907     function _transfer(
908         address from,
909         address to,
910         uint256 tokenId
911     ) internal virtual {
912         require(ERC721.ownerOf(tokenId) == from, 'ERC721: transfer of token that is not own');
913         require(to != address(0), 'ERC721: transfer to the zero address');
914 
915         _beforeTokenTransfer(from, to, tokenId);
916 
917         // Clear approvals from the previous owner
918         _approve(address(0), tokenId);
919 
920         _balances[from] -= 1;
921         _balances[to] += 1;
922         _owners[tokenId] = to;
923 
924         emit Transfer(from, to, tokenId);
925     }
926 
927     /**
928      * @dev Approve `to` to operate on `tokenId`
929      *
930      * Emits a {Approval} event.
931      */
932     function _approve(address to, uint256 tokenId) internal virtual {
933         _tokenApprovals[tokenId] = to;
934         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
935     }
936 
937     /**
938      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
939      * The call is not executed if the target address is not a contract.
940      *
941      * @param from address representing the previous owner of the given token ID
942      * @param to target address that will receive the tokens
943      * @param tokenId uint256 ID of the token to be transferred
944      * @param _data bytes optional data to send along with the call
945      * @return bool whether the call correctly returned the expected magic value
946      */
947     function _checkOnERC721Received(
948         address from,
949         address to,
950         uint256 tokenId,
951         bytes memory _data
952     ) private returns (bool) {
953         if (to.isContract()) {
954             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
955                 return retval == IERC721Receiver(to).onERC721Received.selector;
956             } catch (bytes memory reason) {
957                 if (reason.length == 0) {
958                     revert('ERC721: transfer to non ERC721Receiver implementer');
959                 } else {
960                     // solhint-disable-next-line no-inline-assembly
961                     assembly {
962                         revert(add(32, reason), mload(reason))
963                     }
964                 }
965             }
966         } else {
967             return true;
968         }
969     }
970 
971     /**
972      * @dev Hook that is called before any token transfer. This includes minting
973      * and burning.
974      *
975      * Calling conditions:
976      *
977      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
978      * transferred to `to`.
979      * - When `from` is zero, `tokenId` will be minted for `to`.
980      * - When `to` is zero, ``from``'s `tokenId` will be burned.
981      * - `from` cannot be the zero address.
982      * - `to` cannot be the zero address.
983      *
984      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
985      */
986     function _beforeTokenTransfer(
987         address from,
988         address to,
989         uint256 tokenId
990     ) internal virtual {}
991 }
992 
993 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.1.0
994 
995 pragma solidity ^0.8.0;
996 
997 /**
998  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
999  * @dev See https://eips.ethereum.org/EIPS/eip-721
1000  */
1001 interface IERC721Enumerable is IERC721 {
1002     /**
1003      * @dev Returns the total amount of tokens stored by the contract.
1004      */
1005     function totalSupply() external view returns (uint256);
1006 
1007     /**
1008      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1009      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1010      */
1011     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1012 
1013     /**
1014      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1015      * Use along with {totalSupply} to enumerate all tokens.
1016      */
1017     function tokenByIndex(uint256 index) external view returns (uint256);
1018 }
1019 
1020 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.1.0
1021 
1022 pragma solidity ^0.8.0;
1023 
1024 /**
1025  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1026  * enumerability of all the token ids in the contract as well as all token ids owned by each
1027  * account.
1028  */
1029 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1030     // Mapping from owner to list of owned token IDs
1031     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1032 
1033     // Mapping from token ID to index of the owner tokens list
1034     mapping(uint256 => uint256) private _ownedTokensIndex;
1035 
1036     // Array with all token ids, used for enumeration
1037     uint256[] private _allTokens;
1038 
1039     // Mapping from token id to position in the allTokens array
1040     mapping(uint256 => uint256) private _allTokensIndex;
1041 
1042     /**
1043      * @dev See {IERC165-supportsInterface}.
1044      */
1045     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1046         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1047     }
1048 
1049     /**
1050      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1051      */
1052     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1053         require(index < ERC721.balanceOf(owner), 'ERC721Enumerable: owner index out of bounds');
1054         return _ownedTokens[owner][index];
1055     }
1056 
1057     /**
1058      * @dev See {IERC721Enumerable-totalSupply}.
1059      */
1060     function totalSupply() public view virtual override returns (uint256) {
1061         return _allTokens.length;
1062     }
1063 
1064     /**
1065      * @dev See {IERC721Enumerable-tokenByIndex}.
1066      */
1067     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1068         require(index < ERC721Enumerable.totalSupply(), 'ERC721Enumerable: global index out of bounds');
1069         return _allTokens[index];
1070     }
1071 
1072     /**
1073      * @dev Hook that is called before any token transfer. This includes minting
1074      * and burning.
1075      *
1076      * Calling conditions:
1077      *
1078      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1079      * transferred to `to`.
1080      * - When `from` is zero, `tokenId` will be minted for `to`.
1081      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1082      * - `from` cannot be the zero address.
1083      * - `to` cannot be the zero address.
1084      *
1085      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1086      */
1087     function _beforeTokenTransfer(
1088         address from,
1089         address to,
1090         uint256 tokenId
1091     ) internal virtual override {
1092         super._beforeTokenTransfer(from, to, tokenId);
1093 
1094         if (from == address(0)) {
1095             _addTokenToAllTokensEnumeration(tokenId);
1096         } else if (from != to) {
1097             _removeTokenFromOwnerEnumeration(from, tokenId);
1098         }
1099         if (to == address(0)) {
1100             _removeTokenFromAllTokensEnumeration(tokenId);
1101         } else if (to != from) {
1102             _addTokenToOwnerEnumeration(to, tokenId);
1103         }
1104     }
1105 
1106     /**
1107      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1108      * @param to address representing the new owner of the given token ID
1109      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1110      */
1111     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1112         uint256 length = ERC721.balanceOf(to);
1113         _ownedTokens[to][length] = tokenId;
1114         _ownedTokensIndex[tokenId] = length;
1115     }
1116 
1117     /**
1118      * @dev Private function to add a token to this extension's token tracking data structures.
1119      * @param tokenId uint256 ID of the token to be added to the tokens list
1120      */
1121     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1122         _allTokensIndex[tokenId] = _allTokens.length;
1123         _allTokens.push(tokenId);
1124     }
1125 
1126     /**
1127      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1128      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1129      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1130      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1131      * @param from address representing the previous owner of the given token ID
1132      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1133      */
1134     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1135         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1136         // then delete the last slot (swap and pop).
1137 
1138         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1139         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1140 
1141         // When the token to delete is the last token, the swap operation is unnecessary
1142         if (tokenIndex != lastTokenIndex) {
1143             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1144 
1145             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1146             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1147         }
1148 
1149         // This also deletes the contents at the last position of the array
1150         delete _ownedTokensIndex[tokenId];
1151         delete _ownedTokens[from][lastTokenIndex];
1152     }
1153 
1154     /**
1155      * @dev Private function to remove a token from this extension's token tracking data structures.
1156      * This has O(1) time complexity, but alters the order of the _allTokens array.
1157      * @param tokenId uint256 ID of the token to be removed from the tokens list
1158      */
1159     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1160         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1161         // then delete the last slot (swap and pop).
1162 
1163         uint256 lastTokenIndex = _allTokens.length - 1;
1164         uint256 tokenIndex = _allTokensIndex[tokenId];
1165 
1166         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1167         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1168         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1169         uint256 lastTokenId = _allTokens[lastTokenIndex];
1170 
1171         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1172         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1173 
1174         // This also deletes the contents at the last position of the array
1175         delete _allTokensIndex[tokenId];
1176         _allTokens.pop();
1177     }
1178 }
1179 
1180 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol@v4.1.0
1181 
1182 pragma solidity ^0.8.0;
1183 
1184 /**
1185  * @dev ERC721 token with storage based token URI management.
1186  */
1187 abstract contract ERC721URIStorage is ERC721 {
1188     using Strings for uint256;
1189 
1190     // Optional mapping for token URIs
1191     mapping(uint256 => string) private _tokenURIs;
1192 
1193     /**
1194      * @dev See {IERC721Metadata-tokenURI}.
1195      */
1196     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1197         require(_exists(tokenId), 'ERC721URIStorage: URI query for nonexistent token');
1198 
1199         string memory _tokenURI = _tokenURIs[tokenId];
1200         string memory base = _baseURI();
1201 
1202         // If there is no base URI, return the token URI.
1203         if (bytes(base).length == 0) {
1204             return _tokenURI;
1205         }
1206         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1207         if (bytes(_tokenURI).length > 0) {
1208             return string(abi.encodePacked(base, _tokenURI));
1209         }
1210 
1211         return super.tokenURI(tokenId);
1212     }
1213 
1214     /**
1215      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1216      *
1217      * Requirements:
1218      *
1219      * - `tokenId` must exist.
1220      */
1221     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1222         require(_exists(tokenId), 'ERC721URIStorage: URI set of nonexistent token');
1223         _tokenURIs[tokenId] = _tokenURI;
1224     }
1225 
1226     /**
1227      * @dev Destroys `tokenId`.
1228      * The approval is cleared when the token is burned.
1229      *
1230      * Requirements:
1231      *
1232      * - `tokenId` must exist.
1233      *
1234      * Emits a {Transfer} event.
1235      */
1236     function _burn(uint256 tokenId) internal virtual override {
1237         super._burn(tokenId);
1238 
1239         if (bytes(_tokenURIs[tokenId]).length != 0) {
1240             delete _tokenURIs[tokenId];
1241         }
1242     }
1243 }
1244 
1245 // File @openzeppelin/contracts/security/Pausable.sol@v4.1.0
1246 
1247 pragma solidity ^0.8.0;
1248 
1249 /**
1250  * @dev Contract module which allows children to implement an emergency stop
1251  * mechanism that can be triggered by an authorized account.
1252  *
1253  * This module is used through inheritance. It will make available the
1254  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1255  * the functions of your contract. Note that they will not be pausable by
1256  * simply including this module, only once the modifiers are put in place.
1257  */
1258 abstract contract Pausable is Context {
1259     /**
1260      * @dev Emitted when the pause is triggered by `account`.
1261      */
1262     event Paused(address account);
1263 
1264     /**
1265      * @dev Emitted when the pause is lifted by `account`.
1266      */
1267     event Unpaused(address account);
1268 
1269     bool private _paused;
1270 
1271     /**
1272      * @dev Initializes the contract in unpaused state.
1273      */
1274     constructor() {
1275         _paused = false;
1276     }
1277 
1278     /**
1279      * @dev Returns true if the contract is paused, and false otherwise.
1280      */
1281     function paused() public view virtual returns (bool) {
1282         return _paused;
1283     }
1284 
1285     /**
1286      * @dev Modifier to make a function callable only when the contract is not paused.
1287      *
1288      * Requirements:
1289      *
1290      * - The contract must not be paused.
1291      */
1292     modifier whenNotPaused() {
1293         require(!paused(), 'Pausable: paused');
1294         _;
1295     }
1296 
1297     /**
1298      * @dev Modifier to make a function callable only when the contract is paused.
1299      *
1300      * Requirements:
1301      *
1302      * - The contract must be paused.
1303      */
1304     modifier whenPaused() {
1305         require(paused(), 'Pausable: not paused');
1306         _;
1307     }
1308 
1309     /**
1310      * @dev Triggers stopped state.
1311      *
1312      * Requirements:
1313      *
1314      * - The contract must not be paused.
1315      */
1316     function _pause() internal virtual whenNotPaused {
1317         _paused = true;
1318         emit Paused(_msgSender());
1319     }
1320 
1321     /**
1322      * @dev Returns to normal state.
1323      *
1324      * Requirements:
1325      *
1326      * - The contract must be paused.
1327      */
1328     function _unpause() internal virtual whenPaused {
1329         _paused = false;
1330         emit Unpaused(_msgSender());
1331     }
1332 }
1333 
1334 // File @openzeppelin/contracts/access/Ownable.sol@v4.1.0
1335 
1336 pragma solidity ^0.8.0;
1337 
1338 /**
1339  * @dev Contract module which provides a basic access control mechanism, where
1340  * there is an account (an owner) that can be granted exclusive access to
1341  * specific functions.
1342  *
1343  * By default, the owner account will be the one that deploys the contract. This
1344  * can later be changed with {transferOwnership}.
1345  *
1346  * This module is used through inheritance. It will make available the modifier
1347  * `onlyOwner`, which can be applied to your functions to restrict their use to
1348  * the owner.
1349  */
1350 abstract contract Ownable is Context {
1351     address private _owner;
1352 
1353     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1354 
1355     /**
1356      * @dev Initializes the contract setting the deployer as the initial owner.
1357      */
1358     constructor() {
1359         address msgSender = _msgSender();
1360         _owner = msgSender;
1361         emit OwnershipTransferred(address(0), msgSender);
1362     }
1363 
1364     /**
1365      * @dev Returns the address of the current owner.
1366      */
1367     function owner() public view virtual returns (address) {
1368         return _owner;
1369     }
1370 
1371     /**
1372      * @dev Throws if called by any account other than the owner.
1373      */
1374     modifier onlyOwner() {
1375         require(owner() == _msgSender(), 'Ownable: caller is not the owner');
1376         _;
1377     }
1378 
1379     /**
1380      * @dev Leaves the contract without owner. It will not be possible to call
1381      * `onlyOwner` functions anymore. Can only be called by the current owner.
1382      *
1383      * NOTE: Renouncing ownership will leave the contract without an owner,
1384      * thereby removing any functionality that is only available to the owner.
1385      */
1386     function renounceOwnership() public virtual onlyOwner {
1387         emit OwnershipTransferred(_owner, address(0));
1388         _owner = address(0);
1389     }
1390 
1391     /**
1392      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1393      * Can only be called by the current owner.
1394      */
1395     function transferOwnership(address newOwner) public virtual onlyOwner {
1396         require(newOwner != address(0), 'Ownable: new owner is the zero address');
1397         emit OwnershipTransferred(_owner, newOwner);
1398         _owner = newOwner;
1399     }
1400 }
1401 
1402 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol@v4.1.0
1403 
1404 pragma solidity ^0.8.0;
1405 
1406 /**
1407  * @title ERC721 Burnable Token
1408  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1409  */
1410 abstract contract ERC721Burnable is Context, ERC721 {
1411     /**
1412      * @dev Burns `tokenId`. See {ERC721-_burn}.
1413      *
1414      * Requirements:
1415      *
1416      * - The caller must own `tokenId` or be an approved operator.
1417      */
1418     function burn(uint256 tokenId) public virtual {
1419         //solhint-disable-next-line max-line-length
1420         require(_isApprovedOrOwner(_msgSender(), tokenId), 'ERC721Burnable: caller is not owner nor approved');
1421         _burn(tokenId);
1422     }
1423 }
1424 
1425 // File @openzeppelin/contracts/utils/Counters.sol@v4.1.0
1426 
1427 pragma solidity ^0.8.0;
1428 
1429 /**
1430  * @title Counters
1431  * @author Matt Condon (@shrugs)
1432  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1433  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1434  *
1435  * Include with `using Counters for Counters.Counter;`
1436  */
1437 library Counters {
1438     struct Counter {
1439         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1440         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1441         // this feature: see https://github.com/ethereum/solidity/issues/4637
1442         uint256 _value; // default: 0
1443     }
1444 
1445     function current(Counter storage counter) internal view returns (uint256) {
1446         return counter._value;
1447     }
1448 
1449     function increment(Counter storage counter) internal {
1450         unchecked {
1451             counter._value += 1;
1452         }
1453     }
1454 
1455     function decrement(Counter storage counter) internal {
1456         uint256 value = counter._value;
1457         require(value > 0, 'Counter: decrement overflow');
1458         unchecked {
1459             counter._value = value - 1;
1460         }
1461     }
1462 }
1463 
1464 pragma solidity ^0.8.0;
1465 
1466 contract ApeGirls is ERC721, ERC721Enumerable, ERC721URIStorage, Pausable, Ownable, ERC721Burnable {
1467     using Counters for Counters.Counter;
1468 
1469     Counters.Counter private _tokenIdCounter;
1470     uint256 public maxSupply = 10000;
1471     uint256 public price = 20000000000000000;
1472     bool public saleOpen = true;
1473     bool public presaleOpen = false;
1474     string public baseURI='https://gateway.pinata.cloud/ipfs/QmeX8stgBgV73dKEFXeyqvpRkpYKadWCRugvCq91G1ZNip/';
1475     address princeWallet = 0x4d8D3EaF47e8eade2D65181A0F999c9ABE624EB7;
1476 
1477 
1478     mapping(address => uint256) public Whitelist;
1479 
1480     receive() external payable {}
1481 
1482     constructor() ERC721('Ape_Girls', 'ApeGirls_Nft') {}
1483 
1484     function reserveMints(address to) public onlyOwner {
1485         for (uint256 i = 0; i < 50; i++) internalMint(to);
1486     }
1487 
1488     function whitelistAddress(address[] memory who, uint256 amount) public onlyOwner {
1489         for (uint256 i = 0; i < who.length; i++) Whitelist[who[i]] = amount;
1490     }
1491     function withdraw() public onlyOwner {
1492         uint256 balance = address(this).balance;
1493         payable(princeWallet).transfer(balance);
1494 
1495     }
1496 
1497     function pause() public onlyOwner {
1498         _pause();
1499     }
1500 
1501     function unpause() public onlyOwner {
1502         _unpause();
1503     }
1504 
1505     function toggleSale() public onlyOwner {
1506         saleOpen = !saleOpen;
1507     }
1508 
1509     function togglePresale() public onlyOwner {
1510         presaleOpen = !presaleOpen;
1511     }
1512 
1513     function setBaseURI(string memory newBaseURI) public onlyOwner {
1514         baseURI = newBaseURI;
1515     }
1516 
1517     function setPrice(uint256 newPrice) public onlyOwner {
1518         price = newPrice;
1519     }
1520 
1521     function _baseURI() internal view override returns (string memory) {
1522         return baseURI;
1523     }
1524 
1525     function internalMint(address to) internal {
1526         require(totalSupply() < maxSupply, 'supply depleted');
1527         _tokenIdCounter.increment();
1528         _safeMint(to, _tokenIdCounter.current());
1529 
1530     }
1531 
1532     function safeMint(address to,uint256 amount) public onlyOwner {
1533 
1534       require(amount <= 1000, 'only 3 per transaction allowed');
1535       for (uint256 i = 0; i < amount; i++) internalMint(to);
1536       //  internalMint(to);
1537     }
1538 
1539     function mint(uint256 amount) public payable {
1540         uint256 supply = totalSupply();
1541         if (supply + amount <=500){
1542           require(amount > 0);
1543           require(amount <= 1);
1544           for (uint256 i = 0; i < amount; i++) internalMint(msg.sender);
1545           return;
1546         }
1547         require(msg.value >= price * amount, 'not enough was paid');
1548         require(amount <= 10, 'only 3 per transaction allowed');
1549         for (uint256 i = 0; i < amount; i++) internalMint(msg.sender);
1550     }
1551     function walletOfOwner(address _owner)
1552     public
1553     view
1554     returns (uint256[] memory)
1555   {
1556     uint256 ownerTokenCount = balanceOf(_owner);
1557     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1558     for (uint256 i; i < ownerTokenCount; i++) {
1559       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1560     }
1561     return tokenIds;
1562   }
1563     function _beforeTokenTransfer(
1564         address from,
1565         address to,
1566         uint256 tokenId
1567     ) internal override(ERC721, ERC721Enumerable) whenNotPaused {
1568         super._beforeTokenTransfer(from, to, tokenId);
1569     }
1570 
1571     // The following functions are overrides required by Solidity.
1572 
1573     function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
1574         super._burn(tokenId);
1575     }
1576 
1577     function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
1578         return super.tokenURI(tokenId);
1579     }
1580 
1581     function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
1582         return super.supportsInterface(interfaceId);
1583     }
1584 }