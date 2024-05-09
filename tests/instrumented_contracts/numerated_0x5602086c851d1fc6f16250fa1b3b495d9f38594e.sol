1 // SPDX-License-Identifier: GPL-3.0
2 
3 /**
4 
5     ╔╗╔╔═╗╔╦╗┌─┐┬─┐┬─┐┌─┐┬─┐┬┬ ┬┌┬┐
6     ║║║╠╣  ║ ├┤ ├┬┘├┬┘├─┤├┬┘││ ││││
7     ╝╚╝╚   ╩ └─┘┴└─┴└─┴ ┴┴└─┴└─┘┴ ┴
8     Contract by @texoid__
9 
10 */
11 
12 
13 
14 // File: @openzeppelin/contracts/utils/Strings.sol
15 pragma solidity ^0.8.0;
16 
17 /**
18  * @dev String operations.
19  */
20 library Strings {
21     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
22 
23     /**
24      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
25      */
26     function toString(uint256 value) internal pure returns (string memory) {
27         // Inspired by OraclizeAPI's implementation - MIT licence
28         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
29 
30         if (value == 0) {
31             return "0";
32         }
33         uint256 temp = value;
34         uint256 digits;
35         while (temp != 0) {
36             digits++;
37             temp /= 10;
38         }
39         bytes memory buffer = new bytes(digits);
40         while (value != 0) {
41             digits -= 1;
42             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
43             value /= 10;
44         }
45         return string(buffer);
46     }
47 
48     /**
49      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
50      */
51     function toHexString(uint256 value) internal pure returns (string memory) {
52         if (value == 0) {
53             return "0x00";
54         }
55         uint256 temp = value;
56         uint256 length = 0;
57         while (temp != 0) {
58             length++;
59             temp >>= 8;
60         }
61         return toHexString(value, length);
62     }
63 
64     /**
65      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
66      */
67     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
68         bytes memory buffer = new bytes(2 * length + 2);
69         buffer[0] = "0";
70         buffer[1] = "x";
71         for (uint256 i = 2 * length + 1; i > 1; --i) {
72             buffer[i] = _HEX_SYMBOLS[value & 0xf];
73             value >>= 4;
74         }
75         require(value == 0, "Strings: hex length insufficient");
76         return string(buffer);
77     }
78 }
79 
80 
81 // File: @openzeppelin/contracts/utils/Address.sol
82 pragma solidity ^0.8.0;
83 
84 /**
85  * @dev Collection of functions related to the address type
86  */
87 library Address {
88     /**
89      * @dev Returns true if `account` is a contract.
90      *
91      * [IMPORTANT]
92      * ====
93      * It is unsafe to assume that an address for which this function returns
94      * false is an externally-owned account (EOA) and not a contract.
95      *
96      * Among others, `isContract` will return false for the following
97      * types of addresses:
98      *
99      *  - an externally-owned account
100      *  - a contract in construction
101      *  - an address where a contract will be created
102      *  - an address where a contract lived, but was destroyed
103      * ====
104      */
105     function isContract(address account) internal view returns (bool) {
106         // This method relies on extcodesize, which returns 0 for contracts in
107         // construction, since the code is only stored at the end of the
108         // constructor execution.
109 
110         uint256 size;
111         assembly {
112             size := extcodesize(account)
113         }
114         return size > 0;
115     }
116 
117     /**
118      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
119      * `recipient`, forwarding all available gas and reverting on errors.
120      *
121      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
122      * of certain opcodes, possibly making contracts go over the 2300 gas limit
123      * imposed by `transfer`, making them unable to receive funds via
124      * `transfer`. {sendValue} removes this limitation.
125      *
126      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
127      *
128      * IMPORTANT: because control is transferred to `recipient`, care must be
129      * taken to not create reentrancy vulnerabilities. Consider using
130      * {ReentrancyGuard} or the
131      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
132      */
133     function sendValue(address payable recipient, uint256 amount) internal {
134         require(address(this).balance >= amount, "Address: insufficient balance");
135 
136         (bool success, ) = recipient.call{value: amount}("");
137         require(success, "Address: unable to send value, recipient may have reverted");
138     }
139 
140     /**
141      * @dev Performs a Solidity function call using a low level `call`. A
142      * plain `call` is an unsafe replacement for a function call: use this
143      * function instead.
144      *
145      * If `target` reverts with a revert reason, it is bubbled up by this
146      * function (like regular Solidity function calls).
147      *
148      * Returns the raw returned data. To convert to the expected return value,
149      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
150      *
151      * Requirements:
152      *
153      * - `target` must be a contract.
154      * - calling `target` with `data` must not revert.
155      *
156      * _Available since v3.1._
157      */
158     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
159         return functionCall(target, data, "Address: low-level call failed");
160     }
161 
162     /**
163      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
164      * `errorMessage` as a fallback revert reason when `target` reverts.
165      *
166      * _Available since v3.1._
167      */
168     function functionCall(
169         address target,
170         bytes memory data,
171         string memory errorMessage
172     ) internal returns (bytes memory) {
173         return functionCallWithValue(target, data, 0, errorMessage);
174     }
175 
176     /**
177      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
178      * but also transferring `value` wei to `target`.
179      *
180      * Requirements:
181      *
182      * - the calling contract must have an ETH balance of at least `value`.
183      * - the called Solidity function must be `payable`.
184      *
185      * _Available since v3.1._
186      */
187     function functionCallWithValue(
188         address target,
189         bytes memory data,
190         uint256 value
191     ) internal returns (bytes memory) {
192         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
193     }
194 
195     /**
196      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
197      * with `errorMessage` as a fallback revert reason when `target` reverts.
198      *
199      * _Available since v3.1._
200      */
201     function functionCallWithValue(
202         address target,
203         bytes memory data,
204         uint256 value,
205         string memory errorMessage
206     ) internal returns (bytes memory) {
207         require(address(this).balance >= value, "Address: insufficient balance for call");
208         require(isContract(target), "Address: call to non-contract");
209 
210         (bool success, bytes memory returndata) = target.call{value: value}(data);
211         return verifyCallResult(success, returndata, errorMessage);
212     }
213 
214     /**
215      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
216      * but performing a static call.
217      *
218      * _Available since v3.3._
219      */
220     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
221         return functionStaticCall(target, data, "Address: low-level static call failed");
222     }
223 
224     /**
225      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
226      * but performing a static call.
227      *
228      * _Available since v3.3._
229      */
230     function functionStaticCall(
231         address target,
232         bytes memory data,
233         string memory errorMessage
234     ) internal view returns (bytes memory) {
235         require(isContract(target), "Address: static call to non-contract");
236 
237         (bool success, bytes memory returndata) = target.staticcall(data);
238         return verifyCallResult(success, returndata, errorMessage);
239     }
240 
241     /**
242      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
243      * but performing a delegate call.
244      *
245      * _Available since v3.4._
246      */
247     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
248         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
249     }
250 
251     /**
252      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
253      * but performing a delegate call.
254      *
255      * _Available since v3.4._
256      */
257     function functionDelegateCall(
258         address target,
259         bytes memory data,
260         string memory errorMessage
261     ) internal returns (bytes memory) {
262         require(isContract(target), "Address: delegate call to non-contract");
263 
264         (bool success, bytes memory returndata) = target.delegatecall(data);
265         return verifyCallResult(success, returndata, errorMessage);
266     }
267 
268     /**
269      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
270      * revert reason using the provided one.
271      *
272      * _Available since v4.3._
273      */
274     function verifyCallResult(
275         bool success,
276         bytes memory returndata,
277         string memory errorMessage
278     ) internal pure returns (bytes memory) {
279         if (success) {
280             return returndata;
281         } else {
282             // Look for revert reason and bubble it up if present
283             if (returndata.length > 0) {
284                 // The easiest way to bubble the revert reason is using memory via assembly
285 
286                 assembly {
287                     let returndata_size := mload(returndata)
288                     revert(add(32, returndata), returndata_size)
289                 }
290             } else {
291                 revert(errorMessage);
292             }
293         }
294     }
295 }
296 
297 
298 // File: @openzeppelin/contracts/utils/Context.sol
299 pragma solidity ^0.8.0;
300 /**
301  * @dev Provides information about the current execution context, including the
302  * sender of the transaction and its data. While these are generally available
303  * via msg.sender and msg.data, they should not be accessed in such a direct
304  * manner, since when dealing with meta-transactions the account sending and
305  * paying for execution may not be the actual sender (as far as an application
306  * is concerned).
307  *
308  * This contract is only required for intermediate, library-like contracts.
309  */
310 abstract contract Context {
311     function _msgSender() internal view virtual returns (address) {
312         return msg.sender;
313     }
314 
315     function _msgData() internal view virtual returns (bytes calldata) {
316         return msg.data;
317     }
318 }
319 
320 
321 // File: @openzeppelin/contracts/access/Ownable.sol
322 pragma solidity ^0.8.0;
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
389 
390 pragma solidity ^0.8.0;
391 /**
392  * @dev Interface of the ERC165 standard, as defined in the
393  * https://eips.ethereum.org/EIPS/eip-165[EIP].
394  *
395  * Implementers can declare support of contract interfaces, which can then be
396  * queried by others ({ERC165Checker}).
397  *
398  * For an implementation, see {ERC165}.
399  */
400 interface IERC165 {
401     /**
402      * @dev Returns true if this contract implements the interface defined by
403      * `interfaceId`. See the corresponding
404      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
405      * to learn more about how these ids are created.
406      *
407      * This function call must use less than 30 000 gas.
408      */
409     function supportsInterface(bytes4 interfaceId) external view returns (bool);
410 }
411 
412 
413 pragma solidity ^0.8.0;
414 /**
415  * @dev Implementation of the {IERC165} interface.
416  *
417  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
418  * for the additional interface id that will be supported. For example:
419  *
420  * ```solidity
421  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
422  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
423  * }
424  * ```
425  *
426  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
427  */
428 abstract contract ERC165 is IERC165 {
429     /**
430      * @dev See {IERC165-supportsInterface}.
431      */
432     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
433         return interfaceId == type(IERC165).interfaceId;
434     }
435 }
436 
437 
438 pragma solidity ^0.8.0;
439 /**
440  * @dev Required interface of an ERC1155 compliant contract, as defined in the
441  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
442  *
443  * _Available since v3.1._
444  */
445 interface IERC1155 is IERC165 {
446     /**
447      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
448      */
449     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
450 
451     /**
452      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
453      * transfers.
454      */
455     event TransferBatch(
456         address indexed operator,
457         address indexed from,
458         address indexed to,
459         uint256[] ids,
460         uint256[] values
461     );
462 
463     /**
464      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
465      * `approved`.
466      */
467     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
468 
469     /**
470      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
471      *
472      * If an {URI} event was emitted for `id`, the standard
473      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
474      * returned by {IERC1155MetadataURI-uri}.
475      */
476     event URI(string value, uint256 indexed id);
477 
478     /**
479      * @dev Returns the amount of tokens of token type `id` owned by `account`.
480      *
481      * Requirements:
482      *
483      * - `account` cannot be the zero address.
484      */
485     function balanceOf(address account, uint256 id) external view returns (uint256);
486 
487     /**
488      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
489      *
490      * Requirements:
491      *
492      * - `accounts` and `ids` must have the same length.
493      */
494     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
495         external
496         view
497         returns (uint256[] memory);
498 
499     /**
500      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
501      *
502      * Emits an {ApprovalForAll} event.
503      *
504      * Requirements:
505      *
506      * - `operator` cannot be the caller.
507      */
508     function setApprovalForAll(address operator, bool approved) external;
509 
510     /**
511      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
512      *
513      * See {setApprovalForAll}.
514      */
515     function isApprovedForAll(address account, address operator) external view returns (bool);
516 
517     /**
518      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
519      *
520      * Emits a {TransferSingle} event.
521      *
522      * Requirements:
523      *
524      * - `to` cannot be the zero address.
525      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
526      * - `from` must have a balance of tokens of type `id` of at least `amount`.
527      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
528      * acceptance magic value.
529      */
530     function safeTransferFrom(
531         address from,
532         address to,
533         uint256 id,
534         uint256 amount,
535         bytes calldata data
536     ) external;
537 
538     /**
539      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
540      *
541      * Emits a {TransferBatch} event.
542      *
543      * Requirements:
544      *
545      * - `ids` and `amounts` must have the same length.
546      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
547      * acceptance magic value.
548      */
549     function safeBatchTransferFrom(
550         address from,
551         address to,
552         uint256[] calldata ids,
553         uint256[] calldata amounts,
554         bytes calldata data
555     ) external;
556 }
557 
558 
559 pragma solidity ^0.8.0;
560 /**
561  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
562  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
563  *
564  * _Available since v3.1._
565  */
566 interface IERC1155MetadataURI is IERC1155 {
567     /**
568      * @dev Returns the URI for token type `id`.
569      *
570      * If the `\{id\}` substring is present in the URI, it must be replaced by
571      * clients with the actual token type ID.
572      */
573     function uri(uint256 id) external view returns (string memory);
574 }
575 
576 
577 pragma solidity ^0.8.0;
578 /**
579  * @dev Implementation of the basic standard multi-token.
580  * See https://eips.ethereum.org/EIPS/eip-1155
581  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
582  *
583  * _Available since v3.1._
584  */
585 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
586     using Address for address;
587 
588     // Mapping from token ID to account balances
589     mapping(uint256 => mapping(address => uint256)) private _balances;
590 
591     // Mapping from account to operator approvals
592     mapping(address => mapping(address => bool)) private _operatorApprovals;
593 
594     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
595     string private _uri;
596 
597     /**
598      * @dev See {_setURI}.
599      */
600     constructor(string memory uri_) {
601         _setURI(uri_);
602     }
603 
604     /**
605      * @dev See {IERC165-supportsInterface}.
606      */
607     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
608         return
609             interfaceId == type(IERC1155).interfaceId ||
610             interfaceId == type(IERC1155MetadataURI).interfaceId ||
611             super.supportsInterface(interfaceId);
612     }
613 
614     /**
615      * @dev See {IERC1155MetadataURI-uri}.
616      *
617      * This implementation returns the same URI for *all* token types. It relies
618      * on the token type ID substitution mechanism
619      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
620      *
621      * Clients calling this function must replace the `\{id\}` substring with the
622      * actual token type ID.
623      */
624     function uri(uint256) public view virtual override returns (string memory) {
625         return _uri;
626     }
627 
628     /**
629      * @dev See {IERC1155-balanceOf}.
630      *
631      * Requirements:
632      *
633      * - `account` cannot be the zero address.
634      */
635     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
636         require(account != address(0), "ERC1155: balance query for the zero address");
637         return _balances[id][account];
638     }
639 
640     /**
641      * @dev See {IERC1155-balanceOfBatch}.
642      *
643      * Requirements:
644      *
645      * - `accounts` and `ids` must have the same length.
646      */
647     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
648         public
649         view
650         virtual
651         override
652         returns (uint256[] memory)
653     {
654         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
655 
656         uint256[] memory batchBalances = new uint256[](accounts.length);
657 
658         for (uint256 i = 0; i < accounts.length; ++i) {
659             batchBalances[i] = balanceOf(accounts[i], ids[i]);
660         }
661 
662         return batchBalances;
663     }
664 
665     /**
666      * @dev See {IERC1155-setApprovalForAll}.
667      */
668     function setApprovalForAll(address operator, bool approved) public virtual override {
669         require(_msgSender() != operator, "ERC1155: setting approval status for self");
670 
671         _operatorApprovals[_msgSender()][operator] = approved;
672         emit ApprovalForAll(_msgSender(), operator, approved);
673     }
674 
675     /**
676      * @dev See {IERC1155-isApprovedForAll}.
677      */
678     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
679         return _operatorApprovals[account][operator];
680     }
681 
682     /**
683      * @dev See {IERC1155-safeTransferFrom}.
684      */
685     function safeTransferFrom(
686         address from,
687         address to,
688         uint256 id,
689         uint256 amount,
690         bytes memory data
691     ) public virtual override {
692         require(
693             from == _msgSender() || isApprovedForAll(from, _msgSender()),
694             "ERC1155: caller is not owner nor approved"
695         );
696         _safeTransferFrom(from, to, id, amount, data);
697     }
698 
699     /**
700      * @dev See {IERC1155-safeBatchTransferFrom}.
701      */
702     function safeBatchTransferFrom(
703         address from,
704         address to,
705         uint256[] memory ids,
706         uint256[] memory amounts,
707         bytes memory data
708     ) public virtual override {
709         require(
710             from == _msgSender() || isApprovedForAll(from, _msgSender()),
711             "ERC1155: transfer caller is not owner nor approved"
712         );
713         _safeBatchTransferFrom(from, to, ids, amounts, data);
714     }
715 
716     /**
717      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
718      *
719      * Emits a {TransferSingle} event.
720      *
721      * Requirements:
722      *
723      * - `to` cannot be the zero address.
724      * - `from` must have a balance of tokens of type `id` of at least `amount`.
725      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
726      * acceptance magic value.
727      */
728     function _safeTransferFrom(
729         address from,
730         address to,
731         uint256 id,
732         uint256 amount,
733         bytes memory data
734     ) internal virtual {
735         require(to != address(0), "ERC1155: transfer to the zero address");
736 
737         address operator = _msgSender();
738 
739         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
740 
741         uint256 fromBalance = _balances[id][from];
742         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
743         unchecked {
744             _balances[id][from] = fromBalance - amount;
745         }
746         _balances[id][to] += amount;
747 
748         emit TransferSingle(operator, from, to, id, amount);
749 
750         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
751     }
752 
753     /**
754      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
755      *
756      * Emits a {TransferBatch} event.
757      *
758      * Requirements:
759      *
760      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
761      * acceptance magic value.
762      */
763     function _safeBatchTransferFrom(
764         address from,
765         address to,
766         uint256[] memory ids,
767         uint256[] memory amounts,
768         bytes memory data
769     ) internal virtual {
770         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
771         require(to != address(0), "ERC1155: transfer to the zero address");
772 
773         address operator = _msgSender();
774 
775         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
776 
777         for (uint256 i = 0; i < ids.length; ++i) {
778             uint256 id = ids[i];
779             uint256 amount = amounts[i];
780 
781             uint256 fromBalance = _balances[id][from];
782             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
783             unchecked {
784                 _balances[id][from] = fromBalance - amount;
785             }
786             _balances[id][to] += amount;
787         }
788 
789         emit TransferBatch(operator, from, to, ids, amounts);
790 
791         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
792     }
793 
794     /**
795      * @dev Sets a new URI for all token types, by relying on the token type ID
796      * substitution mechanism
797      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
798      *
799      * By this mechanism, any occurrence of the `\{id\}` substring in either the
800      * URI or any of the amounts in the JSON file at said URI will be replaced by
801      * clients with the token type ID.
802      *
803      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
804      * interpreted by clients as
805      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
806      * for token type ID 0x4cce0.
807      *
808      * See {uri}.
809      *
810      * Because these URIs cannot be meaningfully represented by the {URI} event,
811      * this function emits no events.
812      */
813     function _setURI(string memory newuri) internal virtual {
814         _uri = newuri;
815     }
816 
817     /**
818      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
819      *
820      * Emits a {TransferSingle} event.
821      *
822      * Requirements:
823      *
824      * - `account` cannot be the zero address.
825      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
826      * acceptance magic value.
827      */
828     function _mint(
829         address account,
830         uint256 id,
831         uint256 amount,
832         bytes memory data
833     ) internal virtual {
834         require(account != address(0), "ERC1155: mint to the zero address");
835 
836         address operator = _msgSender();
837 
838         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
839 
840         _balances[id][account] += amount;
841         emit TransferSingle(operator, address(0), account, id, amount);
842 
843         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
844     }
845 
846     /**
847      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
848      *
849      * Requirements:
850      *
851      * - `ids` and `amounts` must have the same length.
852      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
853      * acceptance magic value.
854      */
855     function _mintBatch(
856         address to,
857         uint256[] memory ids,
858         uint256[] memory amounts,
859         bytes memory data
860     ) internal virtual {
861         require(to != address(0), "ERC1155: mint to the zero address");
862         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
863 
864         address operator = _msgSender();
865 
866         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
867 
868         for (uint256 i = 0; i < ids.length; i++) {
869             _balances[ids[i]][to] += amounts[i];
870         }
871 
872         emit TransferBatch(operator, address(0), to, ids, amounts);
873 
874         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
875     }
876 
877     /**
878      * @dev Destroys `amount` tokens of token type `id` from `account`
879      *
880      * Requirements:
881      *
882      * - `account` cannot be the zero address.
883      * - `account` must have at least `amount` tokens of token type `id`.
884      */
885     function _burn(
886         address account,
887         uint256 id,
888         uint256 amount
889     ) internal virtual {
890         require(account != address(0), "ERC1155: burn from the zero address");
891 
892         address operator = _msgSender();
893 
894         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
895 
896         uint256 accountBalance = _balances[id][account];
897         require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
898         unchecked {
899             _balances[id][account] = accountBalance - amount;
900         }
901 
902         emit TransferSingle(operator, account, address(0), id, amount);
903     }
904 
905     /**
906      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
907      *
908      * Requirements:
909      *
910      * - `ids` and `amounts` must have the same length.
911      */
912     function _burnBatch(
913         address account,
914         uint256[] memory ids,
915         uint256[] memory amounts
916     ) internal virtual {
917         require(account != address(0), "ERC1155: burn from the zero address");
918         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
919 
920         address operator = _msgSender();
921 
922         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
923 
924         for (uint256 i = 0; i < ids.length; i++) {
925             uint256 id = ids[i];
926             uint256 amount = amounts[i];
927 
928             uint256 accountBalance = _balances[id][account];
929             require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
930             unchecked {
931                 _balances[id][account] = accountBalance - amount;
932             }
933         }
934 
935         emit TransferBatch(operator, account, address(0), ids, amounts);
936     }
937 
938     /**
939      * @dev Hook that is called before any token transfer. This includes minting
940      * and burning, as well as batched variants.
941      *
942      * The same hook is called on both single and batched variants. For single
943      * transfers, the length of the `id` and `amount` arrays will be 1.
944      *
945      * Calling conditions (for each `id` and `amount` pair):
946      *
947      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
948      * of token type `id` will be  transferred to `to`.
949      * - When `from` is zero, `amount` tokens of token type `id` will be minted
950      * for `to`.
951      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
952      * will be burned.
953      * - `from` and `to` are never both zero.
954      * - `ids` and `amounts` have the same, non-zero length.
955      *
956      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
957      */
958     function _beforeTokenTransfer(
959         address operator,
960         address from,
961         address to,
962         uint256[] memory ids,
963         uint256[] memory amounts,
964         bytes memory data
965     ) internal virtual {}
966 
967     function _doSafeTransferAcceptanceCheck(
968         address operator,
969         address from,
970         address to,
971         uint256 id,
972         uint256 amount,
973         bytes memory data
974     ) private {
975         if (to.isContract()) {
976             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
977                 if (response != IERC1155Receiver(to).onERC1155Received.selector) {
978                     revert("ERC1155: ERC1155Receiver rejected tokens");
979                 }
980             } catch Error(string memory reason) {
981                 revert(reason);
982             } catch {
983                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
984             }
985         }
986     }
987 
988     function _doSafeBatchTransferAcceptanceCheck(
989         address operator,
990         address from,
991         address to,
992         uint256[] memory ids,
993         uint256[] memory amounts,
994         bytes memory data
995     ) private {
996         if (to.isContract()) {
997             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
998                 bytes4 response
999             ) {
1000                 if (response != IERC1155Receiver(to).onERC1155BatchReceived.selector) {
1001                     revert("ERC1155: ERC1155Receiver rejected tokens");
1002                 }
1003             } catch Error(string memory reason) {
1004                 revert(reason);
1005             } catch {
1006                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1007             }
1008         }
1009     }
1010 
1011     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1012         uint256[] memory array = new uint256[](1);
1013         array[0] = element;
1014 
1015         return array;
1016     }
1017 }
1018 
1019 
1020 pragma solidity ^0.8.0;
1021 /**
1022  * @dev _Available since v3.1._
1023  */
1024 interface IERC1155Receiver is IERC165 {
1025     /**
1026         @dev Handles the receipt of a single ERC1155 token type. This function is
1027         called at the end of a `safeTransferFrom` after the balance has been updated.
1028         To accept the transfer, this must return
1029         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
1030         (i.e. 0xf23a6e61, or its own function selector).
1031         @param operator The address which initiated the transfer (i.e. msg.sender)
1032         @param from The address which previously owned the token
1033         @param id The ID of the token being transferred
1034         @param value The amount of tokens being transferred
1035         @param data Additional data with no specified format
1036         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
1037     */
1038     function onERC1155Received(
1039         address operator,
1040         address from,
1041         uint256 id,
1042         uint256 value,
1043         bytes calldata data
1044     ) external returns (bytes4);
1045 
1046     /**
1047         @dev Handles the receipt of a multiple ERC1155 token types. This function
1048         is called at the end of a `safeBatchTransferFrom` after the balances have
1049         been updated. To accept the transfer(s), this must return
1050         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
1051         (i.e. 0xbc197c81, or its own function selector).
1052         @param operator The address which initiated the batch transfer (i.e. msg.sender)
1053         @param from The address which previously owned the token
1054         @param ids An array containing ids of each token being transferred (order and length must match values array)
1055         @param values An array containing amounts of each token being transferred (order and length must match ids array)
1056         @param data Additional data with no specified format
1057         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
1058     */
1059     function onERC1155BatchReceived(
1060         address operator,
1061         address from,
1062         uint256[] calldata ids,
1063         uint256[] calldata values,
1064         bytes calldata data
1065     ) external returns (bytes4);
1066 }
1067 
1068 
1069 pragma solidity >=0.8.0 <0.9.0;
1070 
1071 contract NFTerrariumDust is ERC1155, Ownable { 
1072     using Strings for uint256;
1073 
1074     //---------------[ Meta ]---------------\\
1075     string public name = "Pixie Dust";
1076     string public symbol = "DUST";
1077     string public contractMetaLink;
1078 
1079     //---------------[ TokenURI ]---------------\\
1080     string private baseURI; 
1081     string private baseExtension = ".json";
1082 
1083     //---------------[ Valid Dust ]---------------\\
1084     mapping (uint256 => bool) validDust;
1085     mapping (address => bool) dustUser;
1086 
1087     constructor(string memory _baseURI, string memory _contractMeta) ERC1155("Pixie Dust") {
1088 
1089         baseURI = _baseURI;
1090         contractMetaLink = _contractMeta;
1091         
1092         validDust[1] = true; 
1093         
1094     }
1095 
1096     //---------------[ Mint ]---------------\\
1097     function batchMint(uint256[] memory _ids, uint256[] memory _amount) external onlyOwner {
1098         _mintBatch(owner(), _ids, _amount, "");
1099     }
1100 
1101     function airdrop(address[] memory _recipients, uint256 _tokenType, uint256 _amount) external payable onlyOwner {
1102 
1103         validDust[_tokenType] = true;
1104 
1105         for(uint256 i = 0; i < _recipients.length; i++) {
1106             _mint(_recipients[i], _tokenType, _amount, "");
1107         }
1108 
1109     }
1110 
1111     //---------------[ Brun ]---------------\\
1112     function burnDust(uint256 _type, uint256 _amount, address _address) external { 
1113         require(dustUser[msg.sender] == true, "Invalid Dust User");
1114         _burn(_address, _type, _amount);
1115     }
1116 
1117     //---------------[ Public ]---------------\\
1118     function uri(uint256 tokenID) public view override returns (string memory) {
1119         require( validDust[tokenID], "URI requested for invalid serum type");
1120 
1121         return bytes(baseURI).length > 0 
1122             ? string(abi.encodePacked(baseURI, tokenID.toString(), baseExtension))
1123             : baseURI;
1124 
1125     }
1126 
1127     //---------------[ Only Owner ]---------------\\
1128     function updateBaseURI(string memory _uri) external onlyOwner {
1129         baseURI = _uri;
1130     }
1131 
1132     function updateBaseExtension(string memory _extension) external onlyOwner {
1133         baseExtension = _extension;
1134     }
1135 
1136     function updateContractURI(string memory _uri) external onlyOwner {
1137         contractMetaLink = _uri;
1138     }
1139 
1140     function contractURI() public view returns (string memory) {
1141         return contractMetaLink;
1142     }
1143 
1144     function removeDustUser(address _user) external onlyOwner {
1145         dustUser[_user] = false;
1146     }
1147 
1148     function addDustUser(address _user) external onlyOwner {
1149         dustUser[_user] = true;
1150     }
1151 
1152 }