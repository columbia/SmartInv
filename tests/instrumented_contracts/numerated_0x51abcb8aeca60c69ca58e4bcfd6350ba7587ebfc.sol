1 /**
2  *Submitted for verification at Etherscan.io on 2021-12-19
3 */
4  
5 // Amended by HashLips
6 /**
7     !Disclaimer!
8     These contracts have been used to create tutorials,
9     and was created for the purpose to teach people
10     how to create smart contracts on the blockchain.
11     please review this code on your own before using any of
12     the following code for production.
13     HashLips will not be liable in any way if for the use 
14     of the code. That being said, the code has been tested 
15     to the best of the developers' knowledge to work as intended.
16 */
17  
18 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
19 pragma solidity ^0.8.0;
20 /**
21  * @dev Interface of the ERC165 standard, as defined in the
22  * https://eips.ethereum.org/EIPS/eip-165[EIP].
23  *
24  * Implementers can declare support of contract interfaces, which can then be
25  * queried by others ({ERC165Checker}).
26  *
27  * For an implementation, see {ERC165}.
28  */
29 interface IERC165 {
30     /**
31      * @dev Returns true if this contract implements the interface defined by
32      * `interfaceId`. See the corresponding
33      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
34      * to learn more about how these ids are created.
35      *
36      * This function call must use less than 30 000 gas.
37      */
38     function supportsInterface(bytes4 interfaceId) external view returns (bool);
39 }
40  
41 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
42 pragma solidity ^0.8.0;
43 /**
44  * @dev Required interface of an ERC721 compliant contract.
45  */
46 interface IERC721 is IERC165 {
47     /**
48      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
49      */
50     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
51  
52     /**
53      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
54      */
55     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
56  
57     /**
58      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
59      */
60     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
61  
62     /**
63      * @dev Returns the number of tokens in ``owner``'s account.
64      */
65     function balanceOf(address owner) external view returns (uint256 balance);
66  
67     /**
68      * @dev Returns the owner of the `tokenId` token.
69      *
70      * Requirements:
71      *
72      * - `tokenId` must exist.
73      */
74     function ownerOf(uint256 tokenId) external view returns (address owner);
75  
76     /**
77      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
78      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
79      *
80      * Requirements:
81      *
82      * - `from` cannot be the zero address.
83      * - `to` cannot be the zero address.
84      * - `tokenId` token must exist and be owned by `from`.
85      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
86      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
87      *
88      * Emits a {Transfer} event.
89      */
90     function safeTransferFrom(
91         address from,
92         address to,
93         uint256 tokenId
94     ) external;
95  
96     /**
97      * @dev Transfers `tokenId` token from `from` to `to`.
98      *
99      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
100      *
101      * Requirements:
102      *
103      * - `from` cannot be the zero address.
104      * - `to` cannot be the zero address.
105      * - `tokenId` token must be owned by `from`.
106      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
107      *
108      * Emits a {Transfer} event.
109      */
110     function transferFrom(
111         address from,
112         address to,
113         uint256 tokenId
114     ) external;
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
160      * @dev Safely transfers `tokenId` token from `from` to `to`.
161      *
162      * Requirements:
163      *
164      * - `from` cannot be the zero address.
165      * - `to` cannot be the zero address.
166      * - `tokenId` token must exist and be owned by `from`.
167      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
168      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
169      *
170      * Emits a {Transfer} event.
171      */
172     function safeTransferFrom(
173         address from,
174         address to,
175         uint256 tokenId,
176         bytes calldata data
177     ) external;
178 }
179  
180  
181 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
182 pragma solidity ^0.8.0;
183 /**
184  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
185  * @dev See https://eips.ethereum.org/EIPS/eip-721
186  */
187 interface IERC721Enumerable is IERC721 {
188     /**
189      * @dev Returns the total amount of tokens stored by the contract.
190      */
191     function totalSupply() external view returns (uint256);
192  
193     /**
194      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
195      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
196      */
197     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
198  
199     /**
200      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
201      * Use along with {totalSupply} to enumerate all tokens.
202      */
203     function tokenByIndex(uint256 index) external view returns (uint256);
204 }
205  
206  
207 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
208 pragma solidity ^0.8.0;
209 /**
210  * @dev Implementation of the {IERC165} interface.
211  *
212  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
213  * for the additional interface id that will be supported. For example:
214  *
215  * ```solidity
216  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
217  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
218  * }
219  * ```
220  *
221  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
222  */
223 abstract contract ERC165 is IERC165 {
224     /**
225      * @dev See {IERC165-supportsInterface}.
226      */
227     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
228         return interfaceId == type(IERC165).interfaceId;
229     }
230 }
231  
232 // File: @openzeppelin/contracts/utils/Strings.sol
233  
234  
235  
236 pragma solidity ^0.8.0;
237  
238 /**
239  * @dev String operations.
240  */
241 library Strings {
242     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
243  
244     /**
245      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
246      */
247     function toString(uint256 value) internal pure returns (string memory) {
248         // Inspired by OraclizeAPI's implementation - MIT licence
249         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
250  
251         if (value == 0) {
252             return "0";
253         }
254         uint256 temp = value;
255         uint256 digits;
256         while (temp != 0) {
257             digits++;
258             temp /= 10;
259         }
260         bytes memory buffer = new bytes(digits);
261         while (value != 0) {
262             digits -= 1;
263             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
264             value /= 10;
265         }
266         return string(buffer);
267     }
268  
269     /**
270      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
271      */
272     function toHexString(uint256 value) internal pure returns (string memory) {
273         if (value == 0) {
274             return "0x00";
275         }
276         uint256 temp = value;
277         uint256 length = 0;
278         while (temp != 0) {
279             length++;
280             temp >>= 8;
281         }
282         return toHexString(value, length);
283     }
284  
285     /**
286      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
287      */
288     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
289         bytes memory buffer = new bytes(2 * length + 2);
290         buffer[0] = "0";
291         buffer[1] = "x";
292         for (uint256 i = 2 * length + 1; i > 1; --i) {
293             buffer[i] = _HEX_SYMBOLS[value & 0xf];
294             value >>= 4;
295         }
296         require(value == 0, "Strings: hex length insufficient");
297         return string(buffer);
298     }
299 }
300  
301 // File: @openzeppelin/contracts/utils/Address.sol
302  
303  
304  
305 pragma solidity ^0.8.0;
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
327      */
328     function isContract(address account) internal view returns (bool) {
329         // This method relies on extcodesize, which returns 0 for contracts in
330         // construction, since the code is only stored at the end of the
331         // constructor execution.
332  
333         uint256 size;
334         assembly {
335             size := extcodesize(account)
336         }
337         return size > 0;
338     }
339  
340     /**
341      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
342      * `recipient`, forwarding all available gas and reverting on errors.
343      *
344      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
345      * of certain opcodes, possibly making contracts go over the 2300 gas limit
346      * imposed by `transfer`, making them unable to receive funds via
347      * `transfer`. {sendValue} removes this limitation.
348      *
349      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
350      *
351      * IMPORTANT: because control is transferred to `recipient`, care must be
352      * taken to not create reentrancy vulnerabilities. Consider using
353      * {ReentrancyGuard} or the
354      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
355      */
356     function sendValue(address payable recipient, uint256 amount) internal {
357         require(address(this).balance >= amount, "Address: insufficient balance");
358  
359         (bool success, ) = recipient.call{value: amount}("");
360         require(success, "Address: unable to send value, recipient may have reverted");
361     }
362  
363     /**
364      * @dev Performs a Solidity function call using a low level `call`. A
365      * plain `call` is an unsafe replacement for a function call: use this
366      * function instead.
367      *
368      * If `target` reverts with a revert reason, it is bubbled up by this
369      * function (like regular Solidity function calls).
370      *
371      * Returns the raw returned data. To convert to the expected return value,
372      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
373      *
374      * Requirements:
375      *
376      * - `target` must be a contract.
377      * - calling `target` with `data` must not revert.
378      *
379      * _Available since v3.1._
380      */
381     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
382         return functionCall(target, data, "Address: low-level call failed");
383     }
384  
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
387      * `errorMessage` as a fallback revert reason when `target` reverts.
388      *
389      * _Available since v3.1._
390      */
391     function functionCall(
392         address target,
393         bytes memory data,
394         string memory errorMessage
395     ) internal returns (bytes memory) {
396         return functionCallWithValue(target, data, 0, errorMessage);
397     }
398  
399     /**
400      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
401      * but also transferring `value` wei to `target`.
402      *
403      * Requirements:
404      *
405      * - the calling contract must have an ETH balance of at least `value`.
406      * - the called Solidity function must be `payable`.
407      *
408      * _Available since v3.1._
409      */
410     function functionCallWithValue(
411         address target,
412         bytes memory data,
413         uint256 value
414     ) internal returns (bytes memory) {
415         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
416     }
417  
418     /**
419      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
420      * with `errorMessage` as a fallback revert reason when `target` reverts.
421      *
422      * _Available since v3.1._
423      */
424     function functionCallWithValue(
425         address target,
426         bytes memory data,
427         uint256 value,
428         string memory errorMessage
429     ) internal returns (bytes memory) {
430         require(address(this).balance >= value, "Address: insufficient balance for call");
431         require(isContract(target), "Address: call to non-contract");
432  
433         (bool success, bytes memory returndata) = target.call{value: value}(data);
434         return verifyCallResult(success, returndata, errorMessage);
435     }
436  
437     /**
438      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
439      * but performing a static call.
440      *
441      * _Available since v3.3._
442      */
443     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
444         return functionStaticCall(target, data, "Address: low-level static call failed");
445     }
446  
447     /**
448      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
449      * but performing a static call.
450      *
451      * _Available since v3.3._
452      */
453     function functionStaticCall(
454         address target,
455         bytes memory data,
456         string memory errorMessage
457     ) internal view returns (bytes memory) {
458         require(isContract(target), "Address: static call to non-contract");
459  
460         (bool success, bytes memory returndata) = target.staticcall(data);
461         return verifyCallResult(success, returndata, errorMessage);
462     }
463  
464     /**
465      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
466      * but performing a delegate call.
467      *
468      * _Available since v3.4._
469      */
470     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
471         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
472     }
473  
474     /**
475      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
476      * but performing a delegate call.
477      *
478      * _Available since v3.4._
479      */
480     function functionDelegateCall(
481         address target,
482         bytes memory data,
483         string memory errorMessage
484     ) internal returns (bytes memory) {
485         require(isContract(target), "Address: delegate call to non-contract");
486  
487         (bool success, bytes memory returndata) = target.delegatecall(data);
488         return verifyCallResult(success, returndata, errorMessage);
489     }
490  
491     /**
492      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
493      * revert reason using the provided one.
494      *
495      * _Available since v4.3._
496      */
497     function verifyCallResult(
498         bool success,
499         bytes memory returndata,
500         string memory errorMessage
501     ) internal pure returns (bytes memory) {
502         if (success) {
503             return returndata;
504         } else {
505             // Look for revert reason and bubble it up if present
506             if (returndata.length > 0) {
507                 // The easiest way to bubble the revert reason is using memory via assembly
508  
509                 assembly {
510                     let returndata_size := mload(returndata)
511                     revert(add(32, returndata), returndata_size)
512                 }
513             } else {
514                 revert(errorMessage);
515             }
516         }
517     }
518 }
519  
520 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
521  
522  
523  
524 pragma solidity ^0.8.0;
525  
526  
527 /**
528  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
529  * @dev See https://eips.ethereum.org/EIPS/eip-721
530  */
531 interface IERC721Metadata is IERC721 {
532     /**
533      * @dev Returns the token collection name.
534      */
535     function name() external view returns (string memory);
536  
537     /**
538      * @dev Returns the token collection symbol.
539      */
540     function symbol() external view returns (string memory);
541  
542     /**
543      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
544      */
545     function tokenURI(uint256 tokenId) external view returns (string memory);
546 }
547  
548 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
549  
550  
551  
552 pragma solidity ^0.8.0;
553  
554 /**
555  * @title ERC721 token receiver interface
556  * @dev Interface for any contract that wants to support safeTransfers
557  * from ERC721 asset contracts.
558  */
559 interface IERC721Receiver {
560     /**
561      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
562      * by `operator` from `from`, this function is called.
563      *
564      * It must return its Solidity selector to confirm the token transfer.
565      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
566      *
567      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
568      */
569     function onERC721Received(
570         address operator,
571         address from,
572         uint256 tokenId,
573         bytes calldata data
574     ) external returns (bytes4);
575 }
576  
577 // File: @openzeppelin/contracts/utils/Context.sol
578 pragma solidity ^0.8.0;
579 /**
580  * @dev Provides information about the current execution context, including the
581  * sender of the transaction and its data. While these are generally available
582  * via msg.sender and msg.data, they should not be accessed in such a direct
583  * manner, since when dealing with meta-transactions the account sending and
584  * paying for execution may not be the actual sender (as far as an application
585  * is concerned).
586  *
587  * This contract is only required for intermediate, library-like contracts.
588  */
589 abstract contract Context {
590     function _msgSender() internal view virtual returns (address) {
591         return msg.sender;
592     }
593  
594     function _msgData() internal view virtual returns (bytes calldata) {
595         return msg.data;
596     }
597 }
598  
599  
600 pragma solidity ^0.8.0;
601  
602 /*
603  * @title ERC721
604  * @author naomsa <https://twitter.com/Naomsa666>
605  */
606 abstract contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
607   using Address for address;
608   string private _name;
609   string private _symbol;
610   address[] internal _owners;
611   mapping(uint256 => address) private _tokenApprovals;
612   mapping(address => mapping(address => bool)) private _operatorApprovals;
613  
614   constructor(string memory name_, string memory symbol_) {
615     _name = name_;
616     _symbol = symbol_;
617   }
618  
619   function supportsInterface(bytes4 interfaceId)
620     public
621     view
622     virtual
623     override(ERC165, IERC165)
624     returns (bool)
625   {
626     return
627       interfaceId == type(IERC721).interfaceId ||
628       interfaceId == type(IERC721Metadata).interfaceId ||
629       super.supportsInterface(interfaceId);
630   }
631  
632   function balanceOf(address owner)
633     public
634     view
635     virtual
636     override
637     returns (uint256)
638   {
639     require(owner != address(0), "ERC721: balance query for the zero address");
640     uint256 count = 0;
641     uint256 length = _owners.length;
642     for (uint256 i = 0; i < length; ++i) {
643       if (owner == _owners[i]) {
644         ++count;
645       }
646     }
647     delete length;
648     return count;
649   }
650  
651   function ownerOf(uint256 tokenId)
652     public
653     view
654     virtual
655     override
656     returns (address)
657   {
658     address owner = _owners[tokenId];
659     require(owner != address(0), "ERC721: owner query for nonexistent token");
660     return owner;
661   }
662  
663   function name() public view virtual override returns (string memory) {
664     return _name;
665   }
666  
667   function symbol() public view virtual override returns (string memory) {
668     return _symbol;
669   }
670  
671   function approve(address to, uint256 tokenId) public virtual override {
672     address owner = ERC721.ownerOf(tokenId);
673     require(to != owner, "ERC721: approval to current owner");
674  
675     require(
676       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
677       "ERC721: approve caller is not owner nor approved for all"
678     );
679  
680     _approve(to, tokenId);
681   }
682  
683   function getApproved(uint256 tokenId)
684     public
685     view
686     virtual
687     override
688     returns (address)
689   {
690     require(_exists(tokenId), "ERC721: approved query for nonexistent token");
691  
692     return _tokenApprovals[tokenId];
693   }
694  
695   function setApprovalForAll(address operator, bool approved)
696     public
697     virtual
698     override
699   {
700     require(operator != _msgSender(), "ERC721: approve to caller");
701  
702     _operatorApprovals[_msgSender()][operator] = approved;
703     emit ApprovalForAll(_msgSender(), operator, approved);
704   }
705  
706   function isApprovedForAll(address owner, address operator)
707     public
708     view
709     virtual
710     override
711     returns (bool)
712   {
713     return _operatorApprovals[owner][operator];
714   }
715  
716   function transferFrom(
717     address from,
718     address to,
719     uint256 tokenId
720   ) public virtual override {
721     //solhint-disable-next-line max-line-length
722     require(
723       _isApprovedOrOwner(_msgSender(), tokenId),
724       "ERC721: transfer caller is not owner nor approved"
725     );
726  
727     _transfer(from, to, tokenId);
728   }
729  
730   function safeTransferFrom(
731     address from,
732     address to,
733     uint256 tokenId
734   ) public virtual override {
735     safeTransferFrom(from, to, tokenId, "");
736   }
737  
738   function safeTransferFrom(
739     address from,
740     address to,
741     uint256 tokenId,
742     bytes memory _data
743   ) public virtual override {
744     require(
745       _isApprovedOrOwner(_msgSender(), tokenId),
746       "ERC721: transfer caller is not owner nor approved"
747     );
748     _safeTransfer(from, to, tokenId, _data);
749   }
750  
751   function _safeTransfer(
752     address from,
753     address to,
754     uint256 tokenId,
755     bytes memory _data
756   ) internal virtual {
757     _transfer(from, to, tokenId);
758     require(
759       _checkOnERC721Received(from, to, tokenId, _data),
760       "ERC721: transfer to non ERC721Receiver implementer"
761     );
762   }
763  
764   function _exists(uint256 tokenId) internal view virtual returns (bool) {
765     return tokenId < _owners.length && _owners[tokenId] != address(0);
766   }
767  
768   function _isApprovedOrOwner(address spender, uint256 tokenId)
769     internal
770     view
771     virtual
772     returns (bool)
773   {
774     require(_exists(tokenId), "ERC721: operator query for nonexistent token");
775     address owner = ERC721.ownerOf(tokenId);
776     return (spender == owner ||
777       getApproved(tokenId) == spender ||
778       isApprovedForAll(owner, spender));
779   }
780  
781   function _safeMint(address to, uint256 tokenId) internal virtual {
782     _safeMint(to, tokenId, "");
783   }
784  
785   function _safeMint(
786     address to,
787     uint256 tokenId,
788     bytes memory _data
789   ) internal virtual {
790     _mint(to, tokenId);
791     require(
792       _checkOnERC721Received(address(0), to, tokenId, _data),
793       "ERC721: transfer to non ERC721Receiver implementer"
794     );
795   }
796  
797   function _mint(address to, uint256 tokenId) internal virtual {
798     require(to != address(0), "ERC721: mint to the zero address");
799     require(!_exists(tokenId), "ERC721: token already minted");
800  
801     _beforeTokenTransfer(address(0), to, tokenId);
802     _owners.push(to);
803  
804     emit Transfer(address(0), to, tokenId);
805   }
806  
807   function _burn(uint256 tokenId) internal virtual {
808     address owner = ERC721.ownerOf(tokenId);
809  
810     _beforeTokenTransfer(owner, address(0), tokenId);
811  
812     // Clear approvals
813     _approve(address(0), tokenId);
814     _owners[tokenId] = address(0);
815  
816     emit Transfer(owner, address(0), tokenId);
817   }
818  
819   function _transfer(
820     address from,
821     address to,
822     uint256 tokenId
823   ) internal virtual {
824     require(
825       ERC721.ownerOf(tokenId) == from,
826       "ERC721: transfer of token that is not own"
827     );
828     require(to != address(0), "ERC721: transfer to the zero address");
829  
830     _beforeTokenTransfer(from, to, tokenId);
831  
832     // Clear approvals from the previous owner
833     _approve(address(0), tokenId);
834     _owners[tokenId] = to;
835  
836     emit Transfer(from, to, tokenId);
837   }
838  
839   function _approve(address to, uint256 tokenId) internal virtual {
840     _tokenApprovals[tokenId] = to;
841     emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
842   }
843  
844   function _checkOnERC721Received(
845     address from,
846     address to,
847     uint256 tokenId,
848     bytes memory _data
849   ) private returns (bool) {
850     if (to.isContract()) {
851       try
852         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
853       returns (bytes4 retval) {
854         return retval == IERC721Receiver.onERC721Received.selector;
855       } catch (bytes memory reason) {
856         if (reason.length == 0) {
857           revert("ERC721: transfer to non ERC721Receiver implementer");
858         } else {
859           assembly {
860             revert(add(32, reason), mload(reason))
861           }
862         }
863       }
864     } else {
865       return true;
866     }
867   }
868  
869   function _beforeTokenTransfer(
870     address from,
871     address to,
872     uint256 tokenId
873   ) internal virtual {}
874 }
875  
876  
877 pragma solidity ^0.8.0; 
878 /*
879  * @title ERC721Enumerable
880  * @author naomsa <https://twitter.com/Naomsa666>
881  */
882 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
883   function supportsInterface(bytes4 interfaceId)
884     public
885     view
886     virtual
887     override(IERC165, ERC721)
888     returns (bool)
889   {
890     return
891       interfaceId == type(IERC721Enumerable).interfaceId ||
892       super.supportsInterface(interfaceId);
893   }
894  
895   function tokenOfOwnerByIndex(address owner, uint256 index)
896     public
897     view
898     override
899     returns (uint256 tokenId)
900   {
901     require(index < ERC721.balanceOf(owner), "ERC721Enumerable: Index out of bounds");
902     uint256 count;
903     for (uint256 i; i < _owners.length; ++i) {
904       if (owner == _owners[i]) {
905         if (count == index) return i;
906         else ++count;
907       }
908     }
909     revert("ERC721Enumerable: Index out of bounds");
910   }
911  
912   function walletOfOwner(address owner) public view returns (uint256[] memory) {
913     uint256 balance = balanceOf(owner);
914     uint256[] memory ids = new uint256[](balance);
915     for (uint256 i = 0; i < balance; i++) {
916       ids[i] = tokenOfOwnerByIndex(owner, i);
917     }
918     return ids;
919   }
920  
921   function totalSupply() public view virtual override returns (uint256) {
922     return _owners.length;
923   }
924  
925   function tokenByIndex(uint256 index)
926     public
927     view
928     virtual
929     override
930     returns (uint256)
931   {
932     require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: Index out of bounds");
933     return index;
934   }
935 }
936  
937  
938  
939 // File: @openzeppelin/contracts/access/Ownable.sol
940 pragma solidity ^0.8.0;
941 /**
942  * @dev Contract module which provides a basic access control mechanism, where
943  * there is an account (an owner) that can be granted exclusive access to
944  * specific functions.
945  *
946  * By default, the owner account will be the one that deploys the contract. This
947  * can later be changed with {transferOwnership}.
948  *
949  * This module is used through inheritance. It will make available the modifier
950  * `onlyOwner`, which can be applied to your functions to restrict their use to
951  * the owner.
952  */
953 abstract contract Ownable is Context {
954     address private _owner;
955  
956     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
957  
958     /**
959      * @dev Initializes the contract setting the deployer as the initial owner.
960      */
961     constructor() {
962         _setOwner(_msgSender());
963     }
964  
965     /**
966      * @dev Returns the address of the current owner.
967      */
968     function owner() public view virtual returns (address) {
969         return _owner;
970     }
971  
972     /**
973      * @dev Throws if called by any account other than the owner.
974      */
975     modifier onlyOwner() {
976         require(owner() == _msgSender(), "Ownable: caller is not the owner");
977         _;
978     }
979  
980     /**
981      * @dev Leaves the contract without owner. It will not be possible to call
982      * `onlyOwner` functions anymore. Can only be called by the current owner.
983      *
984      * NOTE: Renouncing ownership will leave the contract without an owner,
985      * thereby removing any functionality that is only available to the owner.
986      */
987     function renounceOwnership() public virtual onlyOwner {
988         _setOwner(address(0));
989     }
990  
991     /**
992      * @dev Transfers ownership of the contract to a new account (`newOwner`).
993      * Can only be called by the current owner.
994      */
995     function transferOwnership(address newOwner) public virtual onlyOwner {
996         require(newOwner != address(0), "Ownable: new owner is the zero address");
997         _setOwner(newOwner);
998     }
999  
1000     function _setOwner(address newOwner) private {
1001         address oldOwner = _owner;
1002         _owner = newOwner;
1003         emit OwnershipTransferred(oldOwner, newOwner);
1004     }
1005 }
1006  
1007 /*
1008  * @title Pausable
1009  * @author naomsa <https://twitter.com/Naomsa666>
1010  */
1011 abstract contract Pausable is Context {
1012     bool public paused;
1013  
1014     modifier whenPaused {
1015         require(paused == true, "Pausable: contract not paused");
1016         _;
1017     }
1018  
1019     modifier whenNotPaused {
1020         require(paused == false, "Pausable: contract paused");
1021         _;
1022     }
1023  
1024     function _togglePaused() internal {
1025         paused = !paused;
1026     }
1027 }
1028  
1029 // SPDX-License-Identifier: GPL-3.0
1030  
1031 pragma solidity ^0.8.0;
1032 
1033 contract CroodlesOfficial is Ownable, Pausable, ERC721Enumerable {
1034   using Strings for uint256;
1035  
1036   string public baseURI;
1037   string public unrevealedURI;
1038   string public baseExtension;
1039   uint256 public baseCost = .03 ether;
1040   uint256 public maxSupply = 8888;
1041   uint256 public maxMintAmount = 20;
1042   uint256 public maxMintPerTransaction = 10;
1043   mapping(address => uint256) public addressMintedBalance;
1044  
1045   // Change to the discounted tokens when deploying
1046   IERC721 internal constant _token1 = IERC721(0x8a90CAb2b38dba80c64b7734e58Ee1dB38B8992e); // doodles
1047   IERC721 internal constant _token2 = IERC721(0xc92cedDfb8dd984A89fb494c376f9A48b999aAFc); // creature world
1048  
1049   constructor(
1050     string memory _name,
1051     string memory _symbol,
1052     string memory _initUnrevealedURI
1053   ) ERC721(_name, _symbol) {
1054     unrevealedURI = _initUnrevealedURI;
1055   }
1056  
1057   function getCost(address _user) public view returns (uint256) {
1058         if(_token1.balanceOf(_user) > 0 || _token2.balanceOf(_user) > 0) {
1059              return .02 ether;
1060          }
1061         return baseCost;
1062   }
1063  
1064   // public
1065   function mint(uint256 _mintAmount) public payable {
1066     uint256 supply = _owners.length;
1067     require(_mintAmount > 0, "need to mint at least 1 NFT");
1068     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1069     if (msg.sender != owner()) {
1070       require(_mintAmount <= maxMintPerTransaction, "max mint amount per transaction exceeded");
1071       require(_mintAmount + addressMintedBalance[msg.sender] <= maxMintAmount, "max mint amount by address exceeded");
1072       require(msg.value == getCost(msg.sender) * _mintAmount, "invalid ether amount");
1073     }
1074  
1075     for (uint256 i = 0; i < _mintAmount; i++) {
1076       addressMintedBalance[msg.sender]++;
1077       _safeMint(msg.sender, supply + i);
1078     }
1079   }
1080  
1081   function tokenURI(uint256 tokenId)
1082     public
1083     view
1084     virtual
1085     override
1086     returns (string memory)
1087   {
1088     require(
1089       _exists(tokenId),
1090       "ERC721Metadata: URI query for nonexistent token"
1091     );
1092 
1093     if(bytes(unrevealedURI).length > 0) {
1094       return unrevealedURI;
1095     } else {
1096       return bytes(baseURI).length > 0
1097           ? string(abi.encodePacked(baseURI, tokenId.toString(), baseExtension))
1098           : "";
1099     }
1100   }
1101  
1102  
1103   function setCost(uint256 _newCost) public onlyOwner {
1104     baseCost = _newCost;
1105   }
1106  
1107   function setMaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1108     maxMintAmount = _newmaxMintAmount;
1109   }
1110  
1111   function setMaxMintPerTransaction(uint256 _limit) public onlyOwner {
1112     maxMintPerTransaction = _limit;
1113   }
1114  
1115   function setBaseURI(string memory _newBaseURI, string memory _newBaseExtension) public onlyOwner {
1116     baseURI = _newBaseURI;
1117     baseExtension = _newBaseExtension;
1118     delete unrevealedURI;
1119   }
1120  
1121   function togglePaused() external onlyOwner {
1122       _togglePaused();
1123   }
1124  
1125   function withdraw() public payable onlyOwner {
1126     payable(owner()).transfer(address(this).balance);
1127   }
1128  
1129   function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override {
1130       require(msg.sender == owner() || paused == false, "Pausable: contract paused");
1131       super._beforeTokenTransfer(from, to, tokenId);
1132   }
1133 }