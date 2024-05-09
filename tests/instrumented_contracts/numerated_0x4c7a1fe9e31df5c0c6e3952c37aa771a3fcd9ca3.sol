1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
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
21         return msg.data;
22     }
23 }
24 
25 /**
26  * @dev Contract module which provides a basic access control mechanism, where
27  * there is an account (an owner) that can be granted exclusive access to
28  * specific functions.
29  *
30  * By default, the owner account will be the one that deploys the contract. This
31  * can later be changed with {transferOwnership}.
32  *
33  * This module is used through inheritance. It will make available the modifier
34  * `onlyOwner`, which can be applied to your functions to restrict their use to
35  * the owner.
36  */
37 abstract contract Ownable is Context {
38     address private _owner;
39 
40     event OwnershipTransferred(
41         address indexed previousOwner,
42         address indexed newOwner
43     );
44 
45     /**
46      * @dev Initializes the contract setting the deployer as the initial owner.
47      */
48     constructor() {
49         _setOwner(_msgSender());
50     }
51 
52     /**
53      * @dev Returns the address of the current owner.
54      */
55     function owner() public view virtual returns (address) {
56         return _owner;
57     }
58 
59     /**
60      * @dev Throws if called by any account other than the owner.
61      */
62     modifier onlyOwner() {
63         require(owner() == _msgSender(), "Ownable: caller is not the owner");
64         _;
65     }
66 
67     /**
68      * @dev Leaves the contract without owner. It will not be possible to call
69      * `onlyOwner` functions anymore. Can only be called by the current owner.
70      *
71      * NOTE: Renouncing ownership will leave the contract without an owner,
72      * thereby removing any functionality that is only available to the owner.
73      */
74     function renounceOwnership() public virtual onlyOwner {
75         _setOwner(address(0));
76     }
77 
78     /**
79      * @dev Transfers ownership of the contract to a new account (`newOwner`).
80      * Can only be called by the current owner.
81      */
82     function transferOwnership(address newOwner) public virtual onlyOwner {
83         require(
84             newOwner != address(0),
85             "Ownable: new owner is the zero address"
86         );
87         _setOwner(newOwner);
88     }
89 
90     function _setOwner(address newOwner) private {
91         address oldOwner = _owner;
92         _owner = newOwner;
93         emit OwnershipTransferred(oldOwner, newOwner);
94     }
95 }
96 
97 /**
98  * @dev Interface of the ERC165 standard, as defined in the
99  * https://eips.ethereum.org/EIPS/eip-165[EIP].
100  *
101  * Implementers can declare support of contract interfaces, which can then be
102  * queried by others ({ERC165Checker}).
103  *
104  * For an implementation, see {ERC165}.
105  */
106 interface IERC165 {
107     /**
108      * @dev Returns true if this contract implements the interface defined by
109      * `interfaceId`. See the corresponding
110      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
111      * to learn more about how these ids are created.
112      *
113      * This function call must use less than 30 000 gas.
114      */
115     function supportsInterface(bytes4 interfaceId) external view returns (bool);
116 }
117 
118 /**
119  * @dev Required interface of an ERC1155 compliant contract, as defined in the
120  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
121  *
122  * _Available since v3.1._
123  */
124 interface IERC1155 is IERC165 {
125     /**
126      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
127      */
128     event TransferSingle(
129         address indexed operator,
130         address indexed from,
131         address indexed to,
132         uint256 id,
133         uint256 value
134     );
135 
136     /**
137      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
138      * transfers.
139      */
140     event TransferBatch(
141         address indexed operator,
142         address indexed from,
143         address indexed to,
144         uint256[] ids,
145         uint256[] values
146     );
147 
148     /**
149      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
150      * `approved`.
151      */
152     event ApprovalForAll(
153         address indexed account,
154         address indexed operator,
155         bool approved
156     );
157 
158     /**
159      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
160      *
161      * If an {URI} event was emitted for `id`, the standard
162      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
163      * returned by {IERC1155MetadataURI-uri}.
164      */
165     event URI(string value, uint256 indexed id);
166 
167     /**
168      * @dev Returns the amount of tokens of token type `id` owned by `account`.
169      *
170      * Requirements:
171      *
172      * - `account` cannot be the zero address.
173      */
174     function balanceOf(address account, uint256 id)
175         external
176         view
177         returns (uint256);
178 
179     /**
180      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
181      *
182      * Requirements:
183      *
184      * - `accounts` and `ids` must have the same length.
185      */
186     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
187         external
188         view
189         returns (uint256[] memory);
190 
191     /**
192      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
193      *
194      * Emits an {ApprovalForAll} event.
195      *
196      * Requirements:
197      *
198      * - `operator` cannot be the caller.
199      */
200     function setApprovalForAll(address operator, bool approved) external;
201 
202     /**
203      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
204      *
205      * See {setApprovalForAll}.
206      */
207     function isApprovedForAll(address account, address operator)
208         external
209         view
210         returns (bool);
211 
212     /**
213      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
214      *
215      * Emits a {TransferSingle} event.
216      *
217      * Requirements:
218      *
219      * - `to` cannot be the zero address.
220      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
221      * - `from` must have a balance of tokens of type `id` of at least `amount`.
222      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
223      * acceptance magic value.
224      */
225     function safeTransferFrom(
226         address from,
227         address to,
228         uint256 id,
229         uint256 amount,
230         bytes calldata data
231     ) external;
232 
233     /**
234      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
235      *
236      * Emits a {TransferBatch} event.
237      *
238      * Requirements:
239      *
240      * - `ids` and `amounts` must have the same length.
241      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
242      * acceptance magic value.
243      */
244     function safeBatchTransferFrom(
245         address from,
246         address to,
247         uint256[] calldata ids,
248         uint256[] calldata amounts,
249         bytes calldata data
250     ) external;
251 }
252 
253 /**
254  * @dev _Available since v3.1._
255  */
256 interface IERC1155Receiver is IERC165 {
257     /**
258         @dev Handles the receipt of a single ERC1155 token type. This function is
259         called at the end of a `safeTransferFrom` after the balance has been updated.
260         To accept the transfer, this must return
261         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
262         (i.e. 0xf23a6e61, or its own function selector).
263         @param operator The address which initiated the transfer (i.e. msg.sender)
264         @param from The address which previously owned the token
265         @param id The ID of the token being transferred
266         @param value The amount of tokens being transferred
267         @param data Additional data with no specified format
268         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
269     */
270     function onERC1155Received(
271         address operator,
272         address from,
273         uint256 id,
274         uint256 value,
275         bytes calldata data
276     ) external returns (bytes4);
277 
278     /**
279         @dev Handles the receipt of a multiple ERC1155 token types. This function
280         is called at the end of a `safeBatchTransferFrom` after the balances have
281         been updated. To accept the transfer(s), this must return
282         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
283         (i.e. 0xbc197c81, or its own function selector).
284         @param operator The address which initiated the batch transfer (i.e. msg.sender)
285         @param from The address which previously owned the token
286         @param ids An array containing ids of each token being transferred (order and length must match values array)
287         @param values An array containing amounts of each token being transferred (order and length must match ids array)
288         @param data Additional data with no specified format
289         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
290     */
291     function onERC1155BatchReceived(
292         address operator,
293         address from,
294         uint256[] calldata ids,
295         uint256[] calldata values,
296         bytes calldata data
297     ) external returns (bytes4);
298 }
299 
300 /**
301  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
302  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
303  *
304  * _Available since v3.1._
305  */
306 interface IERC1155MetadataURI is IERC1155 {
307     /**
308      * @dev Returns the URI for token type `id`.
309      *
310      * If the `\{id\}` substring is present in the URI, it must be replaced by
311      * clients with the actual token type ID.
312      */
313     function uri(uint256 id) external view returns (string memory);
314 }
315 
316 /**
317  * @dev Collection of functions related to the address type
318  */
319 library Address {
320     /**
321      * @dev Returns true if `account` is a contract.
322      *
323      * [IMPORTANT]
324      * ====
325      * It is unsafe to assume that an address for which this function returns
326      * false is an externally-owned account (EOA) and not a contract.
327      *
328      * Among others, `isContract` will return false for the following
329      * types of addresses:
330      *
331      *  - an externally-owned account
332      *  - a contract in construction
333      *  - an address where a contract will be created
334      *  - an address where a contract lived, but was destroyed
335      * ====
336      */
337     function isContract(address account) internal view returns (bool) {
338         // This method relies on extcodesize, which returns 0 for contracts in
339         // construction, since the code is only stored at the end of the
340         // constructor execution.
341 
342         uint256 size;
343         assembly {
344             size := extcodesize(account)
345         }
346         return size > 0;
347     }
348 
349     /**
350      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
351      * `recipient`, forwarding all available gas and reverting on errors.
352      *
353      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
354      * of certain opcodes, possibly making contracts go over the 2300 gas limit
355      * imposed by `transfer`, making them unable to receive funds via
356      * `transfer`. {sendValue} removes this limitation.
357      *
358      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
359      *
360      * IMPORTANT: because control is transferred to `recipient`, care must be
361      * taken to not create reentrancy vulnerabilities. Consider using
362      * {ReentrancyGuard} or the
363      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
364      */
365     function sendValue(address payable recipient, uint256 amount) internal {
366         require(
367             address(this).balance >= amount,
368             "Address: insufficient balance"
369         );
370 
371         (bool success, ) = recipient.call{value: amount}("");
372         require(
373             success,
374             "Address: unable to send value, recipient may have reverted"
375         );
376     }
377 
378     /**
379      * @dev Performs a Solidity function call using a low level `call`. A
380      * plain `call` is an unsafe replacement for a function call: use this
381      * function instead.
382      *
383      * If `target` reverts with a revert reason, it is bubbled up by this
384      * function (like regular Solidity function calls).
385      *
386      * Returns the raw returned data. To convert to the expected return value,
387      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
388      *
389      * Requirements:
390      *
391      * - `target` must be a contract.
392      * - calling `target` with `data` must not revert.
393      *
394      * _Available since v3.1._
395      */
396     function functionCall(address target, bytes memory data)
397         internal
398         returns (bytes memory)
399     {
400         return functionCall(target, data, "Address: low-level call failed");
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
405      * `errorMessage` as a fallback revert reason when `target` reverts.
406      *
407      * _Available since v3.1._
408      */
409     function functionCall(
410         address target,
411         bytes memory data,
412         string memory errorMessage
413     ) internal returns (bytes memory) {
414         return functionCallWithValue(target, data, 0, errorMessage);
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
419      * but also transferring `value` wei to `target`.
420      *
421      * Requirements:
422      *
423      * - the calling contract must have an ETH balance of at least `value`.
424      * - the called Solidity function must be `payable`.
425      *
426      * _Available since v3.1._
427      */
428     function functionCallWithValue(
429         address target,
430         bytes memory data,
431         uint256 value
432     ) internal returns (bytes memory) {
433         return
434             functionCallWithValue(
435                 target,
436                 data,
437                 value,
438                 "Address: low-level call with value failed"
439             );
440     }
441 
442     /**
443      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
444      * with `errorMessage` as a fallback revert reason when `target` reverts.
445      *
446      * _Available since v3.1._
447      */
448     function functionCallWithValue(
449         address target,
450         bytes memory data,
451         uint256 value,
452         string memory errorMessage
453     ) internal returns (bytes memory) {
454         require(
455             address(this).balance >= value,
456             "Address: insufficient balance for call"
457         );
458         require(isContract(target), "Address: call to non-contract");
459 
460         (bool success, bytes memory returndata) = target.call{value: value}(
461             data
462         );
463         return verifyCallResult(success, returndata, errorMessage);
464     }
465 
466     /**
467      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
468      * but performing a static call.
469      *
470      * _Available since v3.3._
471      */
472     function functionStaticCall(address target, bytes memory data)
473         internal
474         view
475         returns (bytes memory)
476     {
477         return
478             functionStaticCall(
479                 target,
480                 data,
481                 "Address: low-level static call failed"
482             );
483     }
484 
485     /**
486      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
487      * but performing a static call.
488      *
489      * _Available since v3.3._
490      */
491     function functionStaticCall(
492         address target,
493         bytes memory data,
494         string memory errorMessage
495     ) internal view returns (bytes memory) {
496         require(isContract(target), "Address: static call to non-contract");
497 
498         (bool success, bytes memory returndata) = target.staticcall(data);
499         return verifyCallResult(success, returndata, errorMessage);
500     }
501 
502     /**
503      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
504      * but performing a delegate call.
505      *
506      * _Available since v3.4._
507      */
508     function functionDelegateCall(address target, bytes memory data)
509         internal
510         returns (bytes memory)
511     {
512         return
513             functionDelegateCall(
514                 target,
515                 data,
516                 "Address: low-level delegate call failed"
517             );
518     }
519 
520     /**
521      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
522      * but performing a delegate call.
523      *
524      * _Available since v3.4._
525      */
526     function functionDelegateCall(
527         address target,
528         bytes memory data,
529         string memory errorMessage
530     ) internal returns (bytes memory) {
531         require(isContract(target), "Address: delegate call to non-contract");
532 
533         (bool success, bytes memory returndata) = target.delegatecall(data);
534         return verifyCallResult(success, returndata, errorMessage);
535     }
536 
537     /**
538      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
539      * revert reason using the provided one.
540      *
541      * _Available since v4.3._
542      */
543     function verifyCallResult(
544         bool success,
545         bytes memory returndata,
546         string memory errorMessage
547     ) internal pure returns (bytes memory) {
548         if (success) {
549             return returndata;
550         } else {
551             // Look for revert reason and bubble it up if present
552             if (returndata.length > 0) {
553                 // The easiest way to bubble the revert reason is using memory via assembly
554 
555                 assembly {
556                     let returndata_size := mload(returndata)
557                     revert(add(32, returndata), returndata_size)
558                 }
559             } else {
560                 revert(errorMessage);
561             }
562         }
563     }
564 }
565 
566 /**
567  * @dev Implementation of the {IERC165} interface.
568  *
569  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
570  * for the additional interface id that will be supported. For example:
571  *
572  * ```solidity
573  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
574  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
575  * }
576  * ```
577  *
578  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
579  */
580 abstract contract ERC165 is IERC165 {
581     /**
582      * @dev See {IERC165-supportsInterface}.
583      */
584     function supportsInterface(bytes4 interfaceId)
585         public
586         view
587         virtual
588         override
589         returns (bool)
590     {
591         return interfaceId == type(IERC165).interfaceId;
592     }
593 }
594 
595 /**
596  * @dev Implementation of the basic standard multi-token.
597  * See https://eips.ethereum.org/EIPS/eip-1155
598  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
599  *
600  * _Available since v3.1._
601  */
602 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
603     using Address for address;
604 
605     // Mapping from token ID to account balances
606     mapping(uint256 => mapping(address => uint256)) private _balances;
607 
608     // Mapping from account to operator approvals
609     mapping(address => mapping(address => bool)) private _operatorApprovals;
610 
611     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
612     string private _uri;
613     string private _name = 'Aftrmrkt';
614     string private _symbol = 'Aftrmrkt';
615 
616     /**
617      * @dev See {_setURI}.
618      */
619     constructor(string memory uri_) {
620         _setURI(uri_);
621     }
622 	
623     function name() public view virtual returns (string memory) {
624         return _name;
625     }
626 
627     function symbol() public view virtual returns (string memory) {
628         return _symbol;
629     }
630 	
631     /**
632      * @dev See {IERC165-supportsInterface}.
633      */
634     function supportsInterface(bytes4 interfaceId)
635         public
636         view
637         virtual
638         override(ERC165, IERC165)
639         returns (bool)
640     {
641         return
642             interfaceId == type(IERC1155).interfaceId ||
643             interfaceId == type(IERC1155MetadataURI).interfaceId ||
644             super.supportsInterface(interfaceId);
645     }
646 
647     /**
648      * @dev See {IERC1155MetadataURI-uri}.
649      *
650      * This implementation returns the same URI for *all* token types. It relies
651      * on the token type ID substitution mechanism
652      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
653      *
654      * Clients calling this function must replace the `\{id\}` substring with the
655      * actual token type ID.
656      */
657     function uri(uint256) public view virtual override returns (string memory) {
658         return _uri;
659     }
660 
661     /**
662      * @dev See {IERC1155-balanceOf}.
663      *
664      * Requirements:
665      *
666      * - `account` cannot be the zero address.
667      */
668     function balanceOf(address account, uint256 id)
669         public
670         view
671         virtual
672         override
673         returns (uint256)
674     {
675         require(
676             account != address(0),
677             "ERC1155: balance query for the zero address"
678         );
679         return _balances[id][account];
680     }
681 
682     /**
683      * @dev See {IERC1155-balanceOfBatch}.
684      *
685      * Requirements:
686      *
687      * - `accounts` and `ids` must have the same length.
688      */
689     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
690         public
691         view
692         virtual
693         override
694         returns (uint256[] memory)
695     {
696         require(
697             accounts.length == ids.length,
698             "ERC1155: accounts and ids length mismatch"
699         );
700 
701         uint256[] memory batchBalances = new uint256[](accounts.length);
702 
703         for (uint256 i = 0; i < accounts.length; ++i) {
704             batchBalances[i] = balanceOf(accounts[i], ids[i]);
705         }
706 
707         return batchBalances;
708     }
709 
710     /**
711      * @dev See {IERC1155-setApprovalForAll}.
712      */
713     function setApprovalForAll(address operator, bool approved)
714         public
715         virtual
716         override
717     {
718         require(
719             _msgSender() != operator,
720             "ERC1155: setting approval status for self"
721         );
722 
723         _operatorApprovals[_msgSender()][operator] = approved;
724         emit ApprovalForAll(_msgSender(), operator, approved);
725     }
726 
727     /**
728      * @dev See {IERC1155-isApprovedForAll}.
729      */
730     function isApprovedForAll(address account, address operator)
731         public
732         view
733         virtual
734         override
735         returns (bool)
736     {
737         return _operatorApprovals[account][operator];
738     }
739 
740     /**
741      * @dev See {IERC1155-safeTransferFrom}.
742      */
743     function safeTransferFrom(
744         address from,
745         address to,
746         uint256 id,
747         uint256 amount,
748         bytes memory data
749     ) public virtual override {
750         require(
751             from == _msgSender() || isApprovedForAll(from, _msgSender()),
752             "ERC1155: caller is not owner nor approved"
753         );
754         _safeTransferFrom(from, to, id, amount, data);
755     }
756 
757     /**
758      * @dev See {IERC1155-safeBatchTransferFrom}.
759      */
760     function safeBatchTransferFrom(
761         address from,
762         address to,
763         uint256[] memory ids,
764         uint256[] memory amounts,
765         bytes memory data
766     ) public virtual override {
767         require(
768             from == _msgSender() || isApprovedForAll(from, _msgSender()),
769             "ERC1155: transfer caller is not owner nor approved"
770         );
771         _safeBatchTransferFrom(from, to, ids, amounts, data);
772     }
773 
774     /**
775      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
776      *
777      * Emits a {TransferSingle} event.
778      *
779      * Requirements:
780      *
781      * - `to` cannot be the zero address.
782      * - `from` must have a balance of tokens of type `id` of at least `amount`.
783      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
784      * acceptance magic value.
785      */
786     function _safeTransferFrom(
787         address from,
788         address to,
789         uint256 id,
790         uint256 amount,
791         bytes memory data
792     ) internal virtual {
793         require(to != address(0), "ERC1155: transfer to the zero address");
794 
795         address operator = _msgSender();
796 
797         _beforeTokenTransfer(
798             operator,
799             from,
800             to,
801             _asSingletonArray(id),
802             _asSingletonArray(amount),
803             data
804         );
805 
806         uint256 fromBalance = _balances[id][from];
807         require(
808             fromBalance >= amount,
809             "ERC1155: insufficient balance for transfer"
810         );
811         unchecked {
812             _balances[id][from] = fromBalance - amount;
813         }
814         _balances[id][to] += amount;
815 
816         emit TransferSingle(operator, from, to, id, amount);
817 
818         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
819     }
820 
821     /**
822      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
823      *
824      * Emits a {TransferBatch} event.
825      *
826      * Requirements:
827      *
828      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
829      * acceptance magic value.
830      */
831     function _safeBatchTransferFrom(
832         address from,
833         address to,
834         uint256[] memory ids,
835         uint256[] memory amounts,
836         bytes memory data
837     ) internal virtual {
838         require(
839             ids.length == amounts.length,
840             "ERC1155: ids and amounts length mismatch"
841         );
842         require(to != address(0), "ERC1155: transfer to the zero address");
843 
844         address operator = _msgSender();
845 
846         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
847 
848         for (uint256 i = 0; i < ids.length; ++i) {
849             uint256 id = ids[i];
850             uint256 amount = amounts[i];
851 
852             uint256 fromBalance = _balances[id][from];
853             require(
854                 fromBalance >= amount,
855                 "ERC1155: insufficient balance for transfer"
856             );
857             unchecked {
858                 _balances[id][from] = fromBalance - amount;
859             }
860             _balances[id][to] += amount;
861         }
862 
863         emit TransferBatch(operator, from, to, ids, amounts);
864 
865         _doSafeBatchTransferAcceptanceCheck(
866             operator,
867             from,
868             to,
869             ids,
870             amounts,
871             data
872         );
873     }
874 
875     /**
876      * @dev Sets a new URI for all token types, by relying on the token type ID
877      * substitution mechanism
878      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
879      *
880      * By this mechanism, any occurrence of the `\{id\}` substring in either the
881      * URI or any of the amounts in the JSON file at said URI will be replaced by
882      * clients with the token type ID.
883      *
884      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
885      * interpreted by clients as
886      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
887      * for token type ID 0x4cce0.
888      *
889      * See {uri}.
890      *
891      * Because these URIs cannot be meaningfully represented by the {URI} event,
892      * this function emits no events.
893      */
894     function _setURI(string memory newuri) internal virtual {
895         _uri = newuri;
896     }
897 
898     /**
899      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
900      *
901      * Emits a {TransferSingle} event.
902      *
903      * Requirements:
904      *
905      * - `account` cannot be the zero address.
906      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
907      * acceptance magic value.
908      */
909     function _mint(
910         address account,
911         uint256 id,
912         uint256 amount,
913         bytes memory data
914     ) internal virtual {
915         require(account != address(0), "ERC1155: mint to the zero address");
916 
917         address operator = _msgSender();
918 
919         _beforeTokenTransfer(
920             operator,
921             address(0),
922             account,
923             _asSingletonArray(id),
924             _asSingletonArray(amount),
925             data
926         );
927 
928         _balances[id][account] += amount;
929         emit TransferSingle(operator, address(0), account, id, amount);
930 
931         _doSafeTransferAcceptanceCheck(
932             operator,
933             address(0),
934             account,
935             id,
936             amount,
937             data
938         );
939     }
940 
941     /**
942      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
943      *
944      * Requirements:
945      *
946      * - `ids` and `amounts` must have the same length.
947      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
948      * acceptance magic value.
949      */
950     function _mintBatch(
951         address to,
952         uint256[] memory ids,
953         uint256[] memory amounts,
954         bytes memory data
955     ) internal virtual {
956         require(to != address(0), "ERC1155: mint to the zero address");
957         require(
958             ids.length == amounts.length,
959             "ERC1155: ids and amounts length mismatch"
960         );
961 
962         address operator = _msgSender();
963 
964         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
965 
966         for (uint256 i = 0; i < ids.length; i++) {
967             _balances[ids[i]][to] += amounts[i];
968         }
969 
970         emit TransferBatch(operator, address(0), to, ids, amounts);
971 
972         _doSafeBatchTransferAcceptanceCheck(
973             operator,
974             address(0),
975             to,
976             ids,
977             amounts,
978             data
979         );
980     }
981 
982     /**
983      * @dev Destroys `amount` tokens of token type `id` from `account`
984      *
985      * Requirements:
986      *
987      * - `account` cannot be the zero address.
988      * - `account` must have at least `amount` tokens of token type `id`.
989      */
990     function _burn(
991         address account,
992         uint256 id,
993         uint256 amount
994     ) internal virtual {
995         require(account != address(0), "ERC1155: burn from the zero address");
996 
997         address operator = _msgSender();
998 
999         _beforeTokenTransfer(
1000             operator,
1001             account,
1002             address(0),
1003             _asSingletonArray(id),
1004             _asSingletonArray(amount),
1005             ""
1006         );
1007 
1008         uint256 accountBalance = _balances[id][account];
1009         require(
1010             accountBalance >= amount,
1011             "ERC1155: burn amount exceeds balance"
1012         );
1013         unchecked {
1014             _balances[id][account] = accountBalance - amount;
1015         }
1016 
1017         emit TransferSingle(operator, account, address(0), id, amount);
1018     }
1019 
1020     /**
1021      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1022      *
1023      * Requirements:
1024      *
1025      * - `ids` and `amounts` must have the same length.
1026      */
1027     function _burnBatch(
1028         address account,
1029         uint256[] memory ids,
1030         uint256[] memory amounts
1031     ) internal virtual {
1032         require(account != address(0), "ERC1155: burn from the zero address");
1033         require(
1034             ids.length == amounts.length,
1035             "ERC1155: ids and amounts length mismatch"
1036         );
1037 
1038         address operator = _msgSender();
1039 
1040         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
1041 
1042         for (uint256 i = 0; i < ids.length; i++) {
1043             uint256 id = ids[i];
1044             uint256 amount = amounts[i];
1045 
1046             uint256 accountBalance = _balances[id][account];
1047             require(
1048                 accountBalance >= amount,
1049                 "ERC1155: burn amount exceeds balance"
1050             );
1051             unchecked {
1052                 _balances[id][account] = accountBalance - amount;
1053             }
1054         }
1055 
1056         emit TransferBatch(operator, account, address(0), ids, amounts);
1057     }
1058 
1059     /**
1060      * @dev Hook that is called before any token transfer. This includes minting
1061      * and burning, as well as batched variants.
1062      *
1063      * The same hook is called on both single and batched variants. For single
1064      * transfers, the length of the `id` and `amount` arrays will be 1.
1065      *
1066      * Calling conditions (for each `id` and `amount` pair):
1067      *
1068      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1069      * of token type `id` will be  transferred to `to`.
1070      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1071      * for `to`.
1072      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1073      * will be burned.
1074      * - `from` and `to` are never both zero.
1075      * - `ids` and `amounts` have the same, non-zero length.
1076      *
1077      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1078      */
1079     function _beforeTokenTransfer(
1080         address operator,
1081         address from,
1082         address to,
1083         uint256[] memory ids,
1084         uint256[] memory amounts,
1085         bytes memory data
1086     ) internal virtual {}
1087 
1088     function _doSafeTransferAcceptanceCheck(
1089         address operator,
1090         address from,
1091         address to,
1092         uint256 id,
1093         uint256 amount,
1094         bytes memory data
1095     ) private {
1096         if (to.isContract()) {
1097             try
1098                 IERC1155Receiver(to).onERC1155Received(
1099                     operator,
1100                     from,
1101                     id,
1102                     amount,
1103                     data
1104                 )
1105             returns (bytes4 response) {
1106                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1107                     revert("ERC1155: ERC1155Receiver rejected tokens");
1108                 }
1109             } catch Error(string memory reason) {
1110                 revert(reason);
1111             } catch {
1112                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1113             }
1114         }
1115     }
1116 
1117     function _doSafeBatchTransferAcceptanceCheck(
1118         address operator,
1119         address from,
1120         address to,
1121         uint256[] memory ids,
1122         uint256[] memory amounts,
1123         bytes memory data
1124     ) private {
1125         if (to.isContract()) {
1126             try
1127                 IERC1155Receiver(to).onERC1155BatchReceived(
1128                     operator,
1129                     from,
1130                     ids,
1131                     amounts,
1132                     data
1133                 )
1134             returns (bytes4 response) {
1135                 if (
1136                     response != IERC1155Receiver.onERC1155BatchReceived.selector
1137                 ) {
1138                     revert("ERC1155: ERC1155Receiver rejected tokens");
1139                 }
1140             } catch Error(string memory reason) {
1141                 revert(reason);
1142             } catch {
1143                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1144             }
1145         }
1146     }
1147 
1148     function _asSingletonArray(uint256 element)
1149         private
1150         pure
1151         returns (uint256[] memory)
1152     {
1153         uint256[] memory array = new uint256[](1);
1154         array[0] = element;
1155 
1156         return array;
1157     }
1158 }
1159 
1160 /**
1161  * @dev Interface of the ERC20 standard as defined in the EIP.
1162  */
1163 interface IERC20 {
1164     /**
1165      * @dev Returns the amount of tokens in existence.
1166      */
1167     function totalSupply() external view returns (uint256);
1168 
1169     /**
1170      * @dev Returns the amount of tokens owned by `account`.
1171      */
1172     function balanceOf(address account) external view returns (uint256);
1173 
1174     /**
1175      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1176      *
1177      * Returns a boolean value indicating whether the operation succeeded.
1178      *
1179      * Emits a {Transfer} event.
1180      */
1181     function transfer(address recipient, uint256 amount)
1182         external
1183         returns (bool);
1184 
1185     /**
1186      * @dev Returns the remaining number of tokens that `spender` will be
1187      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1188      * zero by default.
1189      *
1190      * This value changes when {approve} or {transferFrom} are called.
1191      */
1192     function allowance(address owner, address spender)
1193         external
1194         view
1195         returns (uint256);
1196 
1197     /**
1198      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1199      *
1200      * Returns a boolean value indicating whether the operation succeeded.
1201      *
1202      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1203      * that someone may use both the old and the new allowance by unfortunate
1204      * transaction ordering. One possible solution to mitigate this race
1205      * condition is to first reduce the spender's allowance to 0 and set the
1206      * desired value afterwards:
1207      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1208      *
1209      * Emits an {Approval} event.
1210      */
1211     function approve(address spender, uint256 amount) external returns (bool);
1212 
1213     /**
1214      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1215      * allowance mechanism. `amount` is then deducted from the caller's
1216      * allowance.
1217      *
1218      * Returns a boolean value indicating whether the operation succeeded.
1219      *
1220      * Emits a {Transfer} event.
1221      */
1222     function transferFrom(
1223         address sender,
1224         address recipient,
1225         uint256 amount
1226     ) external returns (bool);
1227 
1228     /**
1229      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1230      * another (`to`).
1231      *
1232      * Note that `value` may be zero.
1233      */
1234     event Transfer(address indexed from, address indexed to, uint256 value);
1235 
1236     /**
1237      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1238      * a call to {approve}. `value` is the new allowance.
1239      */
1240     event Approval(
1241         address indexed owner,
1242         address indexed spender,
1243         uint256 value
1244     );
1245 }
1246 
1247 /**
1248  * @dev String operations.
1249  */
1250 library Strings {
1251     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1252 
1253     /**
1254      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1255      */
1256     function toString(uint256 value) internal pure returns (string memory) {
1257         // Inspired by OraclizeAPI's implementation - MIT licence
1258         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1259 
1260         if (value == 0) {
1261             return "0";
1262         }
1263         uint256 temp = value;
1264         uint256 digits;
1265         while (temp != 0) {
1266             digits++;
1267             temp /= 10;
1268         }
1269         bytes memory buffer = new bytes(digits);
1270         while (value != 0) {
1271             digits -= 1;
1272             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1273             value /= 10;
1274         }
1275         return string(buffer);
1276     }
1277 
1278     /**
1279      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1280      */
1281     function toHexString(uint256 value) internal pure returns (string memory) {
1282         if (value == 0) {
1283             return "0x00";
1284         }
1285         uint256 temp = value;
1286         uint256 length = 0;
1287         while (temp != 0) {
1288             length++;
1289             temp >>= 8;
1290         }
1291         return toHexString(value, length);
1292     }
1293 
1294     /**
1295      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1296      */
1297     function toHexString(uint256 value, uint256 length)
1298         internal
1299         pure
1300         returns (string memory)
1301     {
1302         bytes memory buffer = new bytes(2 * length + 2);
1303         buffer[0] = "0";
1304         buffer[1] = "x";
1305         for (uint256 i = 2 * length + 1; i > 1; --i) {
1306             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1307             value >>= 4;
1308         }
1309         require(value == 0, "Strings: hex length insufficient");
1310         return string(buffer);
1311     }
1312 }
1313 
1314 // CAUTION
1315 // This version of SafeMath should only be used with Solidity 0.8 or later,
1316 // because it relies on the compiler's built in overflow checks.
1317 
1318 /**
1319  * @dev Wrappers over Solidity's arithmetic operations.
1320  *
1321  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1322  * now has built in overflow checking.
1323  */
1324 library SafeMath {
1325     /**
1326      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1327      *
1328      * _Available since v3.4._
1329      */
1330     function tryAdd(uint256 a, uint256 b)
1331         internal
1332         pure
1333         returns (bool, uint256)
1334     {
1335         unchecked {
1336             uint256 c = a + b;
1337             if (c < a) return (false, 0);
1338             return (true, c);
1339         }
1340     }
1341 
1342     /**
1343      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1344      *
1345      * _Available since v3.4._
1346      */
1347     function trySub(uint256 a, uint256 b)
1348         internal
1349         pure
1350         returns (bool, uint256)
1351     {
1352         unchecked {
1353             if (b > a) return (false, 0);
1354             return (true, a - b);
1355         }
1356     }
1357 
1358     /**
1359      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1360      *
1361      * _Available since v3.4._
1362      */
1363     function tryMul(uint256 a, uint256 b)
1364         internal
1365         pure
1366         returns (bool, uint256)
1367     {
1368         unchecked {
1369             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1370             // benefit is lost if 'b' is also tested.
1371             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1372             if (a == 0) return (true, 0);
1373             uint256 c = a * b;
1374             if (c / a != b) return (false, 0);
1375             return (true, c);
1376         }
1377     }
1378 
1379     /**
1380      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1381      *
1382      * _Available since v3.4._
1383      */
1384     function tryDiv(uint256 a, uint256 b)
1385         internal
1386         pure
1387         returns (bool, uint256)
1388     {
1389         unchecked {
1390             if (b == 0) return (false, 0);
1391             return (true, a / b);
1392         }
1393     }
1394 
1395     /**
1396      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1397      *
1398      * _Available since v3.4._
1399      */
1400     function tryMod(uint256 a, uint256 b)
1401         internal
1402         pure
1403         returns (bool, uint256)
1404     {
1405         unchecked {
1406             if (b == 0) return (false, 0);
1407             return (true, a % b);
1408         }
1409     }
1410 
1411     /**
1412      * @dev Returns the addition of two unsigned integers, reverting on
1413      * overflow.
1414      *
1415      * Counterpart to Solidity's `+` operator.
1416      *
1417      * Requirements:
1418      *
1419      * - Addition cannot overflow.
1420      */
1421     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1422         return a + b;
1423     }
1424 
1425     /**
1426      * @dev Returns the subtraction of two unsigned integers, reverting on
1427      * overflow (when the result is negative).
1428      *
1429      * Counterpart to Solidity's `-` operator.
1430      *
1431      * Requirements:
1432      *
1433      * - Subtraction cannot overflow.
1434      */
1435     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1436         return a - b;
1437     }
1438 
1439     /**
1440      * @dev Returns the multiplication of two unsigned integers, reverting on
1441      * overflow.
1442      *
1443      * Counterpart to Solidity's `*` operator.
1444      *
1445      * Requirements:
1446      *
1447      * - Multiplication cannot overflow.
1448      */
1449     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1450         return a * b;
1451     }
1452 
1453     /**
1454      * @dev Returns the integer division of two unsigned integers, reverting on
1455      * division by zero. The result is rounded towards zero.
1456      *
1457      * Counterpart to Solidity's `/` operator.
1458      *
1459      * Requirements:
1460      *
1461      * - The divisor cannot be zero.
1462      */
1463     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1464         return a / b;
1465     }
1466 
1467     /**
1468      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1469      * reverting when dividing by zero.
1470      *
1471      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1472      * opcode (which leaves remaining gas untouched) while Solidity uses an
1473      * invalid opcode to revert (consuming all remaining gas).
1474      *
1475      * Requirements:
1476      *
1477      * - The divisor cannot be zero.
1478      */
1479     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1480         return a % b;
1481     }
1482 
1483     /**
1484      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1485      * overflow (when the result is negative).
1486      *
1487      * CAUTION: This function is deprecated because it requires allocating memory for the error
1488      * message unnecessarily. For custom revert reasons use {trySub}.
1489      *
1490      * Counterpart to Solidity's `-` operator.
1491      *
1492      * Requirements:
1493      *
1494      * - Subtraction cannot overflow.
1495      */
1496     function sub(
1497         uint256 a,
1498         uint256 b,
1499         string memory errorMessage
1500     ) internal pure returns (uint256) {
1501         unchecked {
1502             require(b <= a, errorMessage);
1503             return a - b;
1504         }
1505     }
1506 
1507     /**
1508      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1509      * division by zero. The result is rounded towards zero.
1510      *
1511      * Counterpart to Solidity's `/` operator. Note: this function uses a
1512      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1513      * uses an invalid opcode to revert (consuming all remaining gas).
1514      *
1515      * Requirements:
1516      *
1517      * - The divisor cannot be zero.
1518      */
1519     function div(
1520         uint256 a,
1521         uint256 b,
1522         string memory errorMessage
1523     ) internal pure returns (uint256) {
1524         unchecked {
1525             require(b > 0, errorMessage);
1526             return a / b;
1527         }
1528     }
1529 
1530     /**
1531      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1532      * reverting with custom message when dividing by zero.
1533      *
1534      * CAUTION: This function is deprecated because it requires allocating memory for the error
1535      * message unnecessarily. For custom revert reasons use {tryMod}.
1536      *
1537      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1538      * opcode (which leaves remaining gas untouched) while Solidity uses an
1539      * invalid opcode to revert (consuming all remaining gas).
1540      *
1541      * Requirements:
1542      *
1543      * - The divisor cannot be zero.
1544      */
1545     function mod(
1546         uint256 a,
1547         uint256 b,
1548         string memory errorMessage
1549     ) internal pure returns (uint256) {
1550         unchecked {
1551             require(b > 0, errorMessage);
1552             return a % b;
1553         }
1554     }
1555 }
1556 
1557 /**
1558  * @dev Library for managing
1559  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1560  * types.
1561  *
1562  * Sets have the following properties:
1563  *
1564  * - Elements are added, removed, and checked for existence in constant time
1565  * (O(1)).
1566  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1567  *
1568  * ```
1569  * contract Example {
1570  *     // Add the library methods
1571  *     using EnumerableSet for EnumerableSet.AddressSet;
1572  *
1573  *     // Declare a set state variable
1574  *     EnumerableSet.AddressSet private mySet;
1575  * }
1576  * ```
1577  *
1578  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
1579  * and `uint256` (`UintSet`) are supported.
1580  */
1581 library EnumerableSet {
1582     // To implement this library for multiple types with as little code
1583     // repetition as possible, we write it in terms of a generic Set type with
1584     // bytes32 values.
1585     // The Set implementation uses private functions, and user-facing
1586     // implementations (such as AddressSet) are just wrappers around the
1587     // underlying Set.
1588     // This means that we can only create new EnumerableSets for types that fit
1589     // in bytes32.
1590 
1591     struct Set {
1592         // Storage of set values
1593         bytes32[] _values;
1594         // Position of the value in the `values` array, plus 1 because index 0
1595         // means a value is not in the set.
1596         mapping(bytes32 => uint256) _indexes;
1597     }
1598 
1599     /**
1600      * @dev Add a value to a set. O(1).
1601      *
1602      * Returns true if the value was added to the set, that is if it was not
1603      * already present.
1604      */
1605     function _add(Set storage set, bytes32 value) private returns (bool) {
1606         if (!_contains(set, value)) {
1607             set._values.push(value);
1608             // The value is stored at length-1, but we add 1 to all indexes
1609             // and use 0 as a sentinel value
1610             set._indexes[value] = set._values.length;
1611             return true;
1612         } else {
1613             return false;
1614         }
1615     }
1616 
1617     /**
1618      * @dev Removes a value from a set. O(1).
1619      *
1620      * Returns true if the value was removed from the set, that is if it was
1621      * present.
1622      */
1623     function _remove(Set storage set, bytes32 value) private returns (bool) {
1624         // We read and store the value's index to prevent multiple reads from the same storage slot
1625         uint256 valueIndex = set._indexes[value];
1626 
1627         if (valueIndex != 0) {
1628             // Equivalent to contains(set, value)
1629             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1630             // the array, and then remove the last element (sometimes called as 'swap and pop').
1631             // This modifies the order of the array, as noted in {at}.
1632 
1633             uint256 toDeleteIndex = valueIndex - 1;
1634             uint256 lastIndex = set._values.length - 1;
1635 
1636             if (lastIndex != toDeleteIndex) {
1637                 bytes32 lastvalue = set._values[lastIndex];
1638 
1639                 // Move the last value to the index where the value to delete is
1640                 set._values[toDeleteIndex] = lastvalue;
1641                 // Update the index for the moved value
1642                 set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
1643             }
1644 
1645             // Delete the slot where the moved value was stored
1646             set._values.pop();
1647 
1648             // Delete the index for the deleted slot
1649             delete set._indexes[value];
1650 
1651             return true;
1652         } else {
1653             return false;
1654         }
1655     }
1656 
1657     /**
1658      * @dev Returns true if the value is in the set. O(1).
1659      */
1660     function _contains(Set storage set, bytes32 value)
1661         private
1662         view
1663         returns (bool)
1664     {
1665         return set._indexes[value] != 0;
1666     }
1667 
1668     /**
1669      * @dev Returns the number of values on the set. O(1).
1670      */
1671     function _length(Set storage set) private view returns (uint256) {
1672         return set._values.length;
1673     }
1674 
1675     /**
1676      * @dev Returns the value stored at position `index` in the set. O(1).
1677      *
1678      * Note that there are no guarantees on the ordering of values inside the
1679      * array, and it may change when more values are added or removed.
1680      *
1681      * Requirements:
1682      *
1683      * - `index` must be strictly less than {length}.
1684      */
1685     function _at(Set storage set, uint256 index)
1686         private
1687         view
1688         returns (bytes32)
1689     {
1690         return set._values[index];
1691     }
1692 
1693     /**
1694      * @dev Return the entire set in an array
1695      *
1696      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1697      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1698      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1699      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1700      */
1701     function _values(Set storage set) private view returns (bytes32[] memory) {
1702         return set._values;
1703     }
1704 
1705     // Bytes32Set
1706 
1707     struct Bytes32Set {
1708         Set _inner;
1709     }
1710 
1711     /**
1712      * @dev Add a value to a set. O(1).
1713      *
1714      * Returns true if the value was added to the set, that is if it was not
1715      * already present.
1716      */
1717     function add(Bytes32Set storage set, bytes32 value)
1718 internal
1719         returns (bool)
1720     {
1721         return _add(set._inner, value);
1722     }
1723 
1724     /**
1725      * @dev Removes a value from a set. O(1).
1726      *
1727      * Returns true if the value was removed from the set, that is if it was
1728      * present.
1729      */
1730     function remove(Bytes32Set storage set, bytes32 value)
1731         internal
1732         returns (bool)
1733     {
1734         return _remove(set._inner, value);
1735     }
1736 
1737     /**
1738      * @dev Returns true if the value is in the set. O(1).
1739      */
1740     function contains(Bytes32Set storage set, bytes32 value)
1741         internal
1742         view
1743         returns (bool)
1744     {
1745         return _contains(set._inner, value);
1746     }
1747 
1748     /**
1749      * @dev Returns the number of values in the set. O(1).
1750      */
1751     function length(Bytes32Set storage set) internal view returns (uint256) {
1752         return _length(set._inner);
1753     }
1754 
1755     /**
1756      * @dev Returns the value stored at position `index` in the set. O(1).
1757      *
1758      * Note that there are no guarantees on the ordering of values inside the
1759      * array, and it may change when more values are added or removed.
1760      *
1761      * Requirements:
1762      *
1763      * - `index` must be strictly less than {length}.
1764      */
1765     function at(Bytes32Set storage set, uint256 index)
1766         internal
1767         view
1768         returns (bytes32)
1769     {
1770         return _at(set._inner, index);
1771     }
1772 
1773     /**
1774      * @dev Return the entire set in an array
1775      *
1776      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1777      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1778      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1779      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1780      */
1781     function values(Bytes32Set storage set)
1782         internal
1783         view
1784         returns (bytes32[] memory)
1785     {
1786         return _values(set._inner);
1787     }
1788 
1789     // AddressSet
1790 
1791     struct AddressSet {
1792         Set _inner;
1793     }
1794 
1795     /**
1796      * @dev Add a value to a set. O(1).
1797      *
1798      * Returns true if the value was added to the set, that is if it was not
1799      * already present.
1800      */
1801     function add(AddressSet storage set, address value)
1802         internal
1803         returns (bool)
1804     {
1805         return _add(set._inner, bytes32(uint256(uint160(value))));
1806     }
1807 
1808     /**
1809      * @dev Removes a value from a set. O(1).
1810      *
1811      * Returns true if the value was removed from the set, that is if it was
1812      * present.
1813      */
1814     function remove(AddressSet storage set, address value)
1815         internal
1816         returns (bool)
1817     {
1818         return _remove(set._inner, bytes32(uint256(uint160(value))));
1819     }
1820 
1821     /**
1822      * @dev Returns true if the value is in the set. O(1).
1823      */
1824     function contains(AddressSet storage set, address value)
1825         internal
1826         view
1827         returns (bool)
1828     {
1829         return _contains(set._inner, bytes32(uint256(uint160(value))));
1830     }
1831 
1832     /**
1833      * @dev Returns the number of values in the set. O(1).
1834      */
1835     function length(AddressSet storage set) internal view returns (uint256) {
1836         return _length(set._inner);
1837     }
1838 
1839     /**
1840      * @dev Returns the value stored at position `index` in the set. O(1).
1841      *
1842      * Note that there are no guarantees on the ordering of values inside the
1843      * array, and it may change when more values are added or removed.
1844      *
1845      * Requirements:
1846      *
1847      * - `index` must be strictly less than {length}.
1848      */
1849     function at(AddressSet storage set, uint256 index)
1850         internal
1851         view
1852         returns (address)
1853     {
1854         return address(uint160(uint256(_at(set._inner, index))));
1855     }
1856 
1857     /**
1858      * @dev Return the entire set in an array
1859      *
1860      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1861      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1862      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1863      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1864      */
1865     function values(AddressSet storage set)
1866         internal
1867         view
1868         returns (address[] memory)
1869     {
1870         bytes32[] memory store = _values(set._inner);
1871         address[] memory result;
1872 
1873         assembly {
1874             result := store
1875         }
1876 
1877         return result;
1878     }
1879 
1880     // UintSet
1881 
1882     struct UintSet {
1883         Set _inner;
1884     }
1885 
1886     /**
1887      * @dev Add a value to a set. O(1).
1888      *
1889      * Returns true if the value was added to the set, that is if it was not
1890      * already present.
1891      */
1892     function add(UintSet storage set, uint256 value) internal returns (bool) {
1893         return _add(set._inner, bytes32(value));
1894     }
1895 
1896     /**
1897      * @dev Removes a value from a set. O(1).
1898      *
1899      * Returns true if the value was removed from the set, that is if it was
1900      * present.
1901      */
1902     function remove(UintSet storage set, uint256 value)
1903         internal
1904         returns (bool)
1905     {
1906         return _remove(set._inner, bytes32(value));
1907     }
1908 
1909     /**
1910      * @dev Returns true if the value is in the set. O(1).
1911      */
1912     function contains(UintSet storage set, uint256 value)
1913         internal
1914         view
1915         returns (bool)
1916     {
1917         return _contains(set._inner, bytes32(value));
1918     }
1919 
1920     /**
1921      * @dev Returns the number of values on the set. O(1).
1922      */
1923     function length(UintSet storage set) internal view returns (uint256) {
1924         return _length(set._inner);
1925     }
1926 
1927     /**
1928      * @dev Returns the value stored at position `index` in the set. O(1).
1929      *
1930      * Note that there are no guarantees on the ordering of values inside the
1931      * array, and it may change when more values are added or removed.
1932      *
1933      * Requirements:
1934      *
1935      * - `index` must be strictly less than {length}.
1936      */
1937     function at(UintSet storage set, uint256 index)
1938         internal
1939         view
1940         returns (uint256)
1941     {
1942         return uint256(_at(set._inner, index));
1943     }
1944 
1945     /**
1946      * @dev Return the entire set in an array
1947      *
1948      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1949      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1950      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1951      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1952      */
1953     function values(UintSet storage set)
1954         internal
1955         view
1956         returns (uint256[] memory)
1957     {
1958         bytes32[] memory store = _values(set._inner);
1959         uint256[] memory result;
1960 
1961         assembly {
1962             result := store
1963         }
1964 
1965         return result;
1966     }
1967 }
1968 
1969 interface LinkTokenInterface {
1970     function allowance(address owner, address spender)
1971         external
1972         view
1973         returns (uint256 remaining);
1974 
1975     function approve(address spender, uint256 value)
1976         external
1977         returns (bool success);
1978 
1979     function balanceOf(address owner) external view returns (uint256 balance);
1980 
1981     function decimals() external view returns (uint8 decimalPlaces);
1982 
1983     function decreaseApproval(address spender, uint256 addedValue)
1984         external
1985         returns (bool success);
1986 
1987     function increaseApproval(address spender, uint256 subtractedValue)
1988         external;
1989 
1990     function name() external view returns (string memory tokenName);
1991 
1992     function symbol() external view returns (string memory tokenSymbol);
1993 
1994     function totalSupply() external view returns (uint256 totalTokensIssued);
1995 
1996     function transfer(address to, uint256 value)
1997         external
1998         returns (bool success);
1999 
2000     function transferAndCall(
2001         address to,
2002         uint256 value,
2003         bytes calldata data
2004     ) external returns (bool success);
2005 
2006     function transferFrom(
2007         address from,
2008         address to,
2009         uint256 value
2010     ) external returns (bool success);
2011 }
2012 
2013 contract VRFRequestIDBase {
2014     /**
2015      * @notice returns the seed which is actually input to the VRF coordinator
2016      *
2017      * @dev To prevent repetition of VRF output due to repetition of the
2018      * @dev user-supplied seed, that seed is combined in a hash with the
2019      * @dev user-specific nonce, and the address of the consuming contract. The
2020      * @dev risk of repetition is mostly mitigated by inclusion of a blockhash in
2021      * @dev the final seed, but the nonce does protect against repetition in
2022      * @dev requests which are included in a single block.
2023      *
2024      * @param _userSeed VRF seed input provided by user
2025      * @param _requester Address of the requesting contract
2026      * @param _nonce User-specific nonce at the time of the request
2027      */
2028     function makeVRFInputSeed(
2029         bytes32 _keyHash,
2030         uint256 _userSeed,
2031         address _requester,
2032         uint256 _nonce
2033     ) internal pure returns (uint256) {
2034         return
2035             uint256(
2036                 keccak256(abi.encode(_keyHash, _userSeed, _requester, _nonce))
2037             );
2038     }
2039 
2040     /**
2041      * @notice Returns the id for this request
2042      * @param _keyHash The serviceAgreement ID to be used for this request
2043      * @param _vRFInputSeed The seed to be passed directly to the VRF
2044      * @return The id for this request
2045      *
2046      * @dev Note that _vRFInputSeed is not the seed passed by the consuming
2047      * @dev contract, but the one generated by makeVRFInputSeed
2048      */
2049     function makeRequestId(bytes32 _keyHash, uint256 _vRFInputSeed)
2050         internal
2051         pure
2052         returns (bytes32)
2053     {
2054         return keccak256(abi.encodePacked(_keyHash, _vRFInputSeed));
2055     }
2056 }
2057 
2058 /** ****************************************************************************
2059  * @notice Interface for contracts using VRF randomness
2060  * *****************************************************************************
2061  * @dev PURPOSE
2062  *
2063  * @dev Reggie the Random Oracle (not his real job) wants to provide randomness
2064  * @dev to Vera the verifier in such a way that Vera can be sure he's not
2065  * @dev making his output up to suit himself. Reggie provides Vera a public key
2066  * @dev to which he knows the secret key. Each time Vera provides a seed to
2067  * @dev Reggie, he gives back a value which is computed completely
2068  * @dev deterministically from the seed and the secret key.
2069  *
2070  * @dev Reggie provides a proof by which Vera can verify that the output was
2071  * @dev correctly computed once Reggie tells it to her, but without that proof,
2072  * @dev the output is indistinguishable to her from a uniform random sample
2073  * @dev from the output space.
2074  *
2075  * @dev The purpose of this contract is to make it easy for unrelated contracts
2076  * @dev to talk to Vera the verifier about the work Reggie is doing, to provide
2077  * @dev simple access to a verifiable source of randomness.
2078  * *****************************************************************************
2079  * @dev USAGE
2080  *
2081  * @dev Calling contracts must inherit from VRFConsumerBase, and can
2082  * @dev initialize VRFConsumerBase's attributes in their constructor as
2083  * @dev shown:
2084  *
2085  * @dev   contract VRFConsumer {
2086  * @dev     constuctor(<other arguments>, address _vrfCoordinator, address _link)
2087  * @dev       VRFConsumerBase(_vrfCoordinator, _link) public {
2088  * @dev         <initialization with other arguments goes here>
2089  * @dev       }
2090  * @dev   }
2091  *
2092  * @dev The oracle will have given you an ID for the VRF keypair they have
2093  * @dev committed to (let's call it keyHash), and have told you the minimum LINK
2094  * @dev price for VRF service. Make sure your contract has sufficient LINK, and
2095  * @dev call requestRandomness(keyHash, fee, seed), where seed is the input you
2096  * @dev want to generate randomness from.
2097  *
2098  * @dev Once the VRFCoordinator has received and validated the oracle's response
2099  * @dev to your request, it will call your contract's fulfillRandomness method.
2100  *
2101  * @dev The randomness argument to fulfillRandomness is the actual random value
2102  * @dev generated from your seed.
2103  *
2104  * @dev The requestId argument is generated from the keyHash and the seed by
2105  * @dev makeRequestId(keyHash, seed). If your contract could have concurrent
2106  * @dev requests open, you can use the requestId to track which seed is
2107  * @dev associated with which randomness. See VRFRequestIDBase.sol for more
2108  * @dev details. (See "SECURITY CONSIDERATIONS" for principles to keep in mind,
2109  * @dev if your contract could have multiple requests in flight simultaneously.)
2110  *
2111  * @dev Colliding `requestId`s are cryptographically impossible as long as seeds
2112  * @dev differ. (Which is critical to making unpredictable randomness! See the
2113  * @dev next section.)
2114  *
2115  * *****************************************************************************
2116  * @dev SECURITY CONSIDERATIONS
2117  *
2118  * @dev A method with the ability to call your fulfillRandomness method directly
2119  * @dev could spoof a VRF response with any random value, so it's critical that
2120  * @dev it cannot be directly called by anything other than this base contract
2121  * @dev (specifically, by the VRFConsumerBase.rawFulfillRandomness method).
2122  *
2123  * @dev For your users to trust that your contract's random behavior is free
2124  * @dev from malicious interference, it's best if you can write it so that all
2125  * @dev behaviors implied by a VRF response are executed *during* your
2126  * @dev fulfillRandomness method. If your contract must store the response (or
2127  * @dev anything derived from it) and use it later, you must ensure that any
2128  * @dev user-significant behavior which depends on that stored value cannot be
2129  * @dev manipulated by a subsequent VRF request.
2130  *
2131  * @dev Similarly, both miners and the VRF oracle itself have some influence
2132  * @dev over the order in which VRF responses appear on the blockchain, so if
2133  * @dev your contract could have multiple VRF requests in flight simultaneously,
2134  * @dev you must ensure that the order in which the VRF responses arrive cannot
2135  * @dev be used to manipulate your contract's user-significant behavior.
2136  *
2137  * @dev Since the ultimate input to the VRF is mixed with the block hash of the
2138  * @dev block in which the request is made, user-provided seeds have no impact
2139  * @dev on its economic security properties. They are only included for API
2140  * @dev compatability with previous versions of this contract.
2141  *
2142  * @dev Since the block hash of the block which contains the requestRandomness
2143  * @dev call is mixed into the input to the VRF *last*, a sufficiently powerful
2144  * @dev miner could, in principle, fork the blockchain to evict the block
2145  * @dev containing the request, forcing the request to be included in a
2146  * @dev different block with a different hash, and therefore a different input
2147  * @dev to the VRF. However, such an attack would incur a substantial economic
2148  * @dev cost. This cost scales with the number of blocks the VRF oracle waits
2149  * @dev until it calls responds to a request.
2150  */
2151 abstract contract VRFConsumerBase is VRFRequestIDBase {
2152     /**
2153      * @notice fulfillRandomness handles the VRF response. Your contract must
2154      * @notice implement it. See "SECURITY CONSIDERATIONS" above for important
2155      * @notice principles to keep in mind when implementing your fulfillRandomness
2156      * @notice method.
2157      *
2158      * @dev VRFConsumerBase expects its subcontracts to have a method with this
2159      * @dev signature, and will call it once it has verified the proof
2160      * @dev associated with the randomness. (It is triggered via a call to
2161      * @dev rawFulfillRandomness, below.)
2162      *
2163      * @param requestId The Id initially returned by requestRandomness
2164      * @param randomness the VRF output
2165      */
2166     function fulfillRandomness(bytes32 requestId, uint256 randomness)
2167         internal
2168         virtual;
2169 
2170     /**
2171      * @dev In order to keep backwards compatibility we have kept the user
2172      * seed field around. We remove the use of it because given that the blockhash
2173      * enters later, it overrides whatever randomness the used seed provides.
2174      * Given that it adds no security, and can easily lead to misunderstandings,
2175      * we have removed it from usage and can now provide a simpler API.
2176      */
2177     uint256 private constant USER_SEED_PLACEHOLDER = 0;
2178 
2179     /**
2180      * @notice requestRandomness initiates a request for VRF output given _seed
2181      *
2182      * @dev The fulfillRandomness method receives the output, once it's provided
2183      * @dev by the Oracle, and verified by the vrfCoordinator.
2184      *
2185      * @dev The _keyHash must already be registered with the VRFCoordinator, and
2186      * @dev the _fee must exceed the fee specified during registration of the
2187      * @dev _keyHash.
2188      *
2189      * @dev The _seed parameter is vestigial, and is kept only for API
2190      * @dev compatibility with older versions. It can't *hurt* to mix in some of
2191      * @dev your own randomness, here, but it's not necessary because the VRF
2192      * @dev oracle will mix the hash of the block containing your request into the
2193      * @dev VRF seed it ultimately uses.
2194      *
2195      * @param _keyHash ID of public key against which randomness is generated
2196      * @param _fee The amount of LINK to send with the request
2197      *
2198      * @return requestId unique ID for this request
2199      *
2200      * @dev The returned requestId can be used to distinguish responses to
2201      * @dev concurrent requests. It is passed as the first argument to
2202      * @dev fulfillRandomness.
2203      */
2204     function requestRandomness(bytes32 _keyHash, uint256 _fee)
2205         internal
2206         returns (bytes32 requestId)
2207     {
2208         LINK.transferAndCall(
2209             vrfCoordinator,
2210             _fee,
2211             abi.encode(_keyHash, USER_SEED_PLACEHOLDER)
2212         );
2213         // This is the seed passed to VRFCoordinator. The oracle will mix this with
2214         // the hash of the block containing this request to obtain the seed/input
2215         // which is finally passed to the VRF cryptographic machinery.
2216         uint256 vRFSeed = makeVRFInputSeed(
2217             _keyHash,
2218             USER_SEED_PLACEHOLDER,
2219             address(this),
2220             nonces[_keyHash]
2221         );
2222         // nonces[_keyHash] must stay in sync with
2223         // VRFCoordinator.nonces[_keyHash][this], which was incremented by the above
2224         // successful LINK.transferAndCall (in VRFCoordinator.randomnessRequest).
2225         // This provides protection against the user repeating their input seed,
2226         // which would result in a predictable/duplicate output, if multiple such
2227         // requests appeared in the same block.
2228         nonces[_keyHash] = nonces[_keyHash] + 1;
2229         return makeRequestId(_keyHash, vRFSeed);
2230     }
2231 
2232     LinkTokenInterface internal immutable LINK;
2233     address private immutable vrfCoordinator;
2234 
2235     // Nonces for each VRF key from which randomness has been requested.
2236     //
2237     // Must stay in sync with VRFCoordinator[_keyHash][this]
2238     mapping(bytes32 => uint256) /* keyHash */ /* nonce */
2239         private nonces;
2240 
2241     /**
2242      * @param _vrfCoordinator address of VRFCoordinator contract
2243      * @param _link address of LINK token contract
2244      *
2245      * @dev https://docs.chain.link/docs/link-token-contracts
2246      */
2247     constructor(address _vrfCoordinator, address _link) {
2248         vrfCoordinator = _vrfCoordinator;
2249         LINK = LinkTokenInterface(_link);
2250     }
2251 
2252     // rawFulfillRandomness is called by VRFCoordinator when it receives a valid VRF
2253     // proof. rawFulfillRandomness then calls fulfillRandomness, after validating
2254     // the origin of the call
2255     function rawFulfillRandomness(bytes32 requestId, uint256 randomness)
2256         external
2257     {
2258         require(
2259             msg.sender == vrfCoordinator,
2260             "Only VRFCoordinator can fulfill"
2261         );
2262         fulfillRandomness(requestId, randomness);
2263     }
2264 }
2265 
2266 library MerkleProof {
2267     /**
2268      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
2269      * defined by `root`. For this, a `proof` must be provided, containing
2270      * sibling hashes on the branch from the leaf to the root of the tree. Each
2271      * pair of leaves and each pair of pre-images are assumed to be sorted.
2272      */
2273     function verify(
2274         bytes32[] memory proof,
2275         bytes32 root,
2276         bytes32 leaf
2277     ) internal pure returns (bool) {
2278         bytes32 computedHash = leaf;
2279 
2280         for (uint256 i = 0; i < proof.length; i++) {
2281             bytes32 proofElement = proof[i];
2282 
2283             if (computedHash <= proofElement) {
2284                 // Hash(current computed hash + current element of the proof)
2285                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
2286             } else {
2287                 // Hash(current element of the proof + current computed hash)
2288                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
2289             }
2290         }
2291 
2292         // Check if the computed hash (root) is equal to the provided root
2293         return computedHash == root;
2294     }
2295 }
2296 
2297 contract Aftrmrkt is ERC1155, Ownable, VRFConsumerBase {
2298     using SafeMath for uint256;
2299     using Strings for uint256;
2300     using EnumerableSet for EnumerableSet.UintSet;
2301     using EnumerableSet for EnumerableSet.AddressSet;
2302 	bytes32 public merkleRoot;
2303 
2304     bool public mainSale = false;
2305     bool public preSale = false;
2306     bool public paused = false;
2307 	bool public breedingMinted = false;
2308 	bool public reservedMinted = false;
2309 	
2310     // Chainlink variables ----------
2311 	
2312     bytes32 internal keyHash = 0xAA77729D3466CA35AE8D28B3BBAC7CC36A5031EFDC430821C02BC31A238AF445;
2313     address VRFCoordinator = 0xf0d54349aDdcf704F77AE15b96510dEA15cb7952;
2314     address LinkToken = 0x514910771AF9Ca656af840dff83E8264EcF986CA;
2315     uint256 public fee = 2 ether;
2316 	
2317 	uint256 public minPerTxn = 10;
2318 	uint256 public supplyLimit = 19150;
2319 
2320     //Pack Limit
2321     uint256 public PremiumPack = 337;
2322     uint256 public FreshPack = 2375;
2323     uint256 public StarterPack = 4914;
2324 	
2325 	//Premium Pack Limit
2326     uint256 public PPEliteCardLimit = 337;
2327 	uint256 public PPRareCardLimit = 337;
2328     uint256 public PPFreshCardLimit = 337;
2329     uint256 public PPCommonCardLimit = 674;
2330 	
2331 	//Fresh Pack Limit
2332     uint256 public FPRareCardLimit = 829;
2333     uint256 public FPFreshCardLimit = 4650;
2334     uint256 public FPCommonCardLimit = 1646;
2335 
2336     //Starter Pack Limit
2337     uint256 public SPFreshCardLimit = 449;
2338     uint256 public SPCommonCardLimit = 9379;
2339     
2340 	//Pack Fees Pre-Sale
2341     uint256 public PremiumPackFeePreSale = 0.4 ether;
2342     uint256 public FreshPackFeePreSale = 0.12 ether;
2343     uint256 public StarterPackFeePreSale = 0.046 ether;
2344 	
2345     //Pack Fees Public
2346     uint256 public PremiumPackFee = 0.41 ether;
2347     uint256 public FreshPackFee = 0.13 ether;
2348     uint256 public StarterPackFee = 0.055 ether;
2349 
2350     //Total Cards Per Pack
2351     uint256 public freshPackCards = 7125;
2352     uint256 public basePackCards = 9828;
2353 	uint256 public premiumPackCards = 1685;
2354 	
2355 	uint256 public randomResult;
2356 	
2357     string public baseURI;
2358 	
2359     enum Pack {
2360         PREMIUM,
2361         FRESH,
2362         BASE
2363     }
2364 	
2365 	address[] public addressList = [
2366 	   0xE1D1f06282266B72E7aD3374F4E68386da17CD89,
2367 	   0xc300605c136A6995A27E34391cAB9344e881F589,
2368 	   0x7972174DA20702D2cbAabfBB8897Ae4185a82B9A 
2369 	];
2370 	
2371 	uint256[] public shareList = [87,10,3];
2372 	
2373     mapping(uint256 => uint256) public totalSupply;
2374     mapping(bytes32 => Pack) requestToPack;
2375     mapping(bytes32 => address) requestTouser;
2376     mapping(uint256 => uint256) public supplyOf;
2377   
2378     EnumerableSet.UintSet elite;
2379     EnumerableSet.UintSet rare;
2380     EnumerableSet.UintSet fresh;
2381     EnumerableSet.UintSet common;
2382 
2383     constructor() ERC1155("https://gateway.pinata.cloud/ipfs/Qmev1bGgMSaP9J8eLKuApuZeqTYen7sJjoqf2KeXvbrBnx/") VRFConsumerBase(VRFCoordinator, LinkToken) {
2384 	{
2385             elite.add(4);
2386             supplyOf[4] = 50;
2387 			
2388             elite.add(10);
2389             supplyOf[10] = 50;
2390             
2391 			elite.add(12);
2392             supplyOf[12] = 50;
2393             
2394 			elite.add(19);
2395             supplyOf[19] = 50;
2396 			
2397             elite.add(23);
2398             supplyOf[23] = 50;
2399 			
2400             elite.add(26);
2401             supplyOf[26] = 50;
2402             
2403 			elite.add(29);
2404             supplyOf[29] = 50;
2405         }
2406         {
2407             rare.add(2);
2408             supplyOf[2] = 150;
2409 			
2410             rare.add(5);
2411             supplyOf[5] = 150;
2412             
2413 			rare.add(8);
2414             supplyOf[8] = 150;
2415             
2416 			rare.add(13);
2417             supplyOf[13] = 150;
2418             
2419 			rare.add(14);
2420             supplyOf[14] = 150;
2421             
2422 			rare.add(21);
2423             supplyOf[21] = 150;
2424             
2425 			rare.add(22);
2426             supplyOf[22] = 150;
2427 			
2428             rare.add(28);
2429             supplyOf[28] = 150;
2430         }
2431         {
2432             fresh.add(1);
2433             supplyOf[1] = 800;
2434 			
2435             fresh.add(3);
2436             supplyOf[3] = 800;
2437             
2438 			fresh.add(6);
2439             supplyOf[6] = 800;
2440             
2441 			fresh.add(7);
2442             supplyOf[7] = 800;
2443             
2444 			fresh.add(16);
2445             supplyOf[16] = 800;
2446             
2447 			fresh.add(17);
2448             supplyOf[17] = 800;
2449             
2450 			fresh.add(24);
2451             supplyOf[24] = 800;
2452         }
2453         {
2454             common.add(9);
2455             supplyOf[9] = 1500;
2456 			
2457             common.add(11);
2458             supplyOf[11] = 1500;
2459 			
2460             common.add(15);
2461             supplyOf[15] = 1500;
2462 			
2463             common.add(18);
2464             supplyOf[18] = 1500;
2465 			
2466             common.add(20);
2467             supplyOf[20] = 1500;
2468 			
2469             common.add(25);
2470             supplyOf[25] = 1500;
2471 			
2472             common.add(27);
2473             supplyOf[27] = 1500;
2474 			
2475             common.add(30);
2476             supplyOf[30] = 1500;
2477         }
2478 		
2479 		address beneficiary = 0x7972174DA20702D2cbAabfBB8897Ae4185a82B9A;
2480 		
2481 		 //Fresh Pack Mint
2482         _mint(beneficiary, 1, 20, "");
2483         _mint(beneficiary, 3, 20, "");
2484         _mint(beneficiary, 6, 20, "");
2485         _mint(beneficiary, 7, 20, "");
2486         _mint(beneficiary, 16, 20, "");
2487 		_mint(beneficiary, 17, 20, "");
2488 		_mint(beneficiary, 24, 19, "");
2489         
2490 		 //Rare Pack Mint
2491         _mint(beneficiary, 2, 4, "");
2492         _mint(beneficiary, 5, 4, "");
2493         _mint(beneficiary, 8, 4, "");
2494         _mint(beneficiary, 13, 4, "");
2495         _mint(beneficiary, 14, 4, "");
2496 		_mint(beneficiary, 21, 3, "");
2497 		_mint(beneficiary, 22, 3, "");
2498 		_mint(beneficiary, 28, 3, "");
2499 
2500          //Elite Pack Mint
2501         _mint(beneficiary, 4, 2, "");
2502         _mint(beneficiary, 10, 1, "");
2503         _mint(beneficiary, 12, 1, "");
2504         _mint(beneficiary, 19, 1, "");
2505         _mint(beneficiary, 23, 1, "");
2506         _mint(beneficiary, 26, 1, "");
2507         _mint(beneficiary, 29, 1, "");
2508 
2509          //Comman Pack Mint   
2510         _mint(beneficiary, 9, 38, "");
2511         _mint(beneficiary, 11, 38, "");
2512 		_mint(beneficiary, 15, 38, "");
2513 		_mint(beneficiary, 18, 37, "");
2514 		_mint(beneficiary, 20, 37, "");
2515 		_mint(beneficiary, 25, 37, "");
2516 		_mint(beneficiary, 27, 37, "");
2517 		_mint(beneficiary, 30, 37, "");
2518     }
2519 	
2520 	function setPreSaleStatus(bool _status) public onlyOwner {
2521 	   require(preSale != _status);
2522        preSale = _status;
2523     }
2524 	
2525 	function setSaleStatus(bool _status) public onlyOwner {
2526         require(mainSale != _status);
2527 		mainSale = _status;
2528     }
2529 
2530     function pause() public onlyOwner {
2531         paused = !paused;
2532     }
2533 
2534     function setPremiumPackFee(uint256 _premiumPackFee) external onlyOwner {
2535         PremiumPackFee = _premiumPackFee;
2536     }
2537 
2538     function setFreshPackFee(uint256 _freshPackFee) external onlyOwner {
2539         FreshPackFee = _freshPackFee;
2540     }
2541 
2542     function setStarterPackFee(uint256 _basePackFee) external onlyOwner {
2543         StarterPackFee = _basePackFee;
2544     }
2545 	
2546 	function setPreSalePremiumPackFee(uint256 _premiumPackFee) external onlyOwner {
2547         PremiumPackFeePreSale = _premiumPackFee;
2548     }
2549 
2550     function setPreSaleFreshPackFee(uint256 _freshPackFee) external onlyOwner {
2551         FreshPackFeePreSale = _freshPackFee;
2552     }
2553 
2554     function setPreSaleStarterPackFee(uint256 _basePackFee) external onlyOwner {
2555         StarterPackFeePreSale = _basePackFee;
2556     }
2557 	
2558     function uri(uint256 id) public view override returns (string memory) {
2559         require(id > 0, "Aftrmrkt::uri: Invalid id.");
2560         return string(abi.encodePacked(baseURI, "/", id.toString(), ".json"));
2561     }
2562 
2563     function setBaseURI(string memory _baseURI) public onlyOwner {
2564         require(
2565             bytes(_baseURI).length > 0,
2566             "Aftrmrkt::setBaseURI: Invalid base URI."
2567         );
2568         baseURI = _baseURI;
2569     }
2570 	
2571 	function getLinkBalance() external view returns (uint256) {
2572         return LINK.balanceOf(address(this));
2573     }
2574 
2575     function withdrawLink() external onlyOwner {
2576         LINK.transfer(owner(), LINK.balanceOf(address(this)));
2577     }
2578 	
2579 	function withdrawAll() public onlyOwner {
2580         uint256 balance = address(this).balance;
2581         for (uint256 i = 0; i < addressList.length; i++) {
2582 		   payable(addressList[i]).transfer(balance.mul(shareList[i]).div(100));
2583         }
2584     }
2585 	
2586 	function updateMerkleRoot(bytes32 newRoot) external onlyOwner {
2587 	   merkleRoot = newRoot;
2588 	}
2589 
2590     function getValues() external view returns (uint256[] memory, uint256[] memory, uint256[] memory, uint256[] memory)
2591     {
2592         return (elite.values(), rare.values(), fresh.values(), common.values());
2593     }
2594 	
2595     function buyPresalePremiumPack(uint256 count, bytes32[] calldata merkleProof) external payable {
2596 	    bytes32 node = keccak256(abi.encodePacked(msg.sender));
2597         require(!paused, "the contract is paused");
2598         require(preSale, "Aftmrkt::preCheck: presale is not active");
2599         require(
2600             PremiumPack >= count,
2601             "Aftmrkt::buyPremiumPack: PremiumPacks are sold out."
2602         );
2603 		require(
2604 			MerkleProof.verify(merkleProof, merkleRoot, node), 
2605 			"MerkleDistributor: Invalid proof."
2606 		);
2607 		require(
2608 			count <= minPerTxn,
2609 			"Exceeds max mint limit per tnx"
2610 		);
2611         require(
2612             LINK.balanceOf(address(this)) >= fee.mul(count),
2613             "Not enough LINK - fill contract with faucet"
2614         );
2615         require(
2616             msg.value >= PremiumPackFeePreSale.mul(count),
2617             "Aftmrkt::buyPresalePremiumPack: Insufficient amount."
2618         );
2619 		for (uint256 i = 0; i < count; i++) {
2620             bytes32 requestId = requestRandomness(keyHash, fee);
2621 			requestToPack[requestId] = Pack.PREMIUM;
2622 			requestTouser[requestId] = _msgSender();
2623 			PremiumPack = PremiumPack - 1;
2624         }
2625     }
2626 
2627     function buyPresaleFreshPack(uint256 count, bytes32[] calldata merkleProof) external payable {
2628 	    bytes32 node = keccak256(abi.encodePacked(msg.sender));
2629         require(!paused, "the contract is paused");
2630         require(preSale, "Aftmrkt::preCheck: presale is not active");
2631         require(
2632             FreshPack >= count,
2633             "Aftmrkt::buyFreshPack: FreshPacks are sold out."
2634         );
2635 		require(
2636 			MerkleProof.verify(merkleProof, merkleRoot, node), 
2637 			"MerkleDistributor: Invalid proof."
2638 		);
2639 		require(
2640 			count <= minPerTxn,
2641 			"Exceeds max mint limit per tnx"
2642 		);
2643         require(
2644             LINK.balanceOf(address(this)) >= fee.mul(count),
2645             "Not enough LINK - fill contract with faucet"
2646         );
2647         require(
2648             msg.value >= FreshPackFeePreSale.mul(count),
2649             "Aftmrkt::buyPresaleFreshPack: Insufficient amount."
2650         );
2651 		for (uint256 i = 0; i < count; i++) {
2652             bytes32 requestId = requestRandomness(keyHash, fee);
2653 			requestToPack[requestId] = Pack.FRESH;
2654 			requestTouser[requestId] = _msgSender();
2655 			FreshPack = FreshPack - 1;
2656         }
2657     }
2658 
2659     function buyPresaleStarterPack(uint256 count, bytes32[] calldata merkleProof) external payable {
2660 	    bytes32 node = keccak256(abi.encodePacked(msg.sender));
2661         require(!paused, "the contract is paused");
2662         require(preSale, "Aftmrkt::preCheck: presale is not active");
2663         require(
2664             StarterPack >= count,
2665             "Aftmrkt::buyFreshPack: FreshPacks are sold out."
2666         );
2667 		require(
2668 			MerkleProof.verify(merkleProof, merkleRoot, node), 
2669 			"MerkleDistributor: Invalid proof."
2670 		);
2671 		require(
2672 			count <= minPerTxn,
2673 			"Exceeds max mint limit per tnx"
2674 		);
2675         require(
2676             LINK.balanceOf(address(this)) >= fee.mul(count),
2677             "Not enough LINK - fill contract with faucet"
2678         );
2679         require(
2680             msg.value >= StarterPackFeePreSale.mul(count),
2681             "Aftmrkt::buyPresaleStarterPack: Insufficient amount."
2682         );
2683 		
2684 		for (uint256 i = 0; i < count; i++) {
2685             bytes32 requestId = requestRandomness(keyHash, fee);
2686 			requestToPack[requestId] = Pack.BASE;
2687 			requestTouser[requestId] = _msgSender();
2688 			StarterPack = StarterPack - 1;
2689         }
2690     }
2691 
2692     function buyPremiumPack(uint256 count) external payable {
2693         require(!paused, "the contract is paused");
2694         require(mainSale, "Aftmrkt::preCheck: Sale is not active");
2695         require(
2696             PremiumPack >= count,
2697             "Aftmrkt::buyPremiumPack: PremiumPacks are sold out."
2698         );
2699 		require(
2700 			count <= minPerTxn,
2701 			"Exceeds max mint limit per tnx"
2702 		);
2703         require(
2704             LINK.balanceOf(address(this)) >= fee.mul(count),
2705             "Not enough LINK - fill contract with faucet"
2706         );
2707         require(
2708             msg.value >= PremiumPackFee.mul(count),
2709             "Aftmrkt::buyPremiumPack: Insufficient amount."
2710         );
2711 		for (uint256 i = 0; i < count; i++) {
2712             bytes32 requestId = requestRandomness(keyHash, fee);
2713 			requestToPack[requestId] = Pack.PREMIUM;
2714 			requestTouser[requestId] = _msgSender();
2715 			PremiumPack = PremiumPack - 1;
2716         }
2717     }
2718 	
2719     function buyFreshPack(uint256 count) external payable {
2720         require(!paused, "the contract is paused");
2721         require(mainSale, "Aftmrkt::preCheck: Sale is not active");
2722         require(
2723             FreshPack >= count,
2724             "Aftmrkt::buyFreshPack: FreshPacks are sold out."
2725         );
2726 		require(
2727 			count <= minPerTxn,
2728 			"Exceeds max mint limit per tnx"
2729 		);
2730         require(
2731             LINK.balanceOf(address(this)) >= fee.mul(count),
2732             "Not enough LINK - fill contract with faucet"
2733         );
2734         require(
2735             msg.value >= FreshPackFee.mul(count),
2736             "Aftmrkt::buyFreshPack: Insufficient amount."
2737         );
2738 		for (uint256 i = 0; i < count; i++) {
2739              bytes32 requestId = requestRandomness(keyHash, fee);
2740 			 requestToPack[requestId] = Pack.FRESH;
2741 			 requestTouser[requestId] = _msgSender();
2742 			 FreshPack = FreshPack - 1;
2743         }
2744     }
2745 	
2746     function buyStarterPack(uint256 count) external payable {
2747         require(!paused, "the contract is paused");
2748         require(mainSale, "Aftmrkt::preCheck: Sale is not active");
2749         require(
2750             StarterPack >= count,
2751             "Aftmrkt::buyFreshPack: FreshPacks are sold out."
2752         );
2753 		require(
2754 			count <= minPerTxn,
2755 			"Exceeds max mint limit per tnx"
2756 		);
2757         require(
2758             LINK.balanceOf(address(this)) >= fee.mul(count),
2759             "Not enough LINK - fill contract with faucet"
2760         );
2761         require(
2762             msg.value >= StarterPackFee.mul(count),
2763             "Aftmrkt::buyStarterPack: Insufficient amount."
2764         );
2765 		for (uint256 i = 0; i < count; i++) {
2766              bytes32 requestId = requestRandomness(keyHash, fee);
2767 			 requestToPack[requestId] = Pack.BASE;
2768 			 requestTouser[requestId] = _msgSender();
2769 			 StarterPack = StarterPack - 1;
2770         }
2771     }
2772 	
2773     function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override{
2774         if (requestToPack[requestId] == Pack.PREMIUM) 
2775 		{
2776             givePremiumPack(randomness, requestId);
2777         } 
2778 		else if (requestToPack[requestId] == Pack.FRESH) 
2779 		{
2780             giveFreshPack(randomness, requestId);
2781         } 
2782 		else {
2783             giveStarterPack(randomness, requestId);
2784         }
2785     }
2786 	
2787     function givePremiumPack(uint256 _randomNumner, bytes32 _requestId) internal{
2788         giveEliteCard(_randomNumner.div(10**3), _requestId);
2789 		PPEliteCardLimit = PPEliteCardLimit - 1;
2790         giveRareCard(_randomNumner.div(10**6), _requestId);
2791 		PPRareCardLimit = PPRareCardLimit - 1;
2792         giveFreshCard(_randomNumner.div(10**9), _requestId);
2793 		PPFreshCardLimit = PPFreshCardLimit - 1;
2794         giveCommonCard(_randomNumner.div(10**12), _requestId);
2795 		PPCommonCardLimit = PPCommonCardLimit - 1;
2796         giveCommonCard(_randomNumner.div(10**15), _requestId);
2797 		PPCommonCardLimit = PPCommonCardLimit - 1;
2798     }
2799 	
2800     function giveFreshPack(uint256 _randomNumner, bytes32 _requestId) internal {
2801         uint256 nfts = 3;
2802         uint256 rareProb = FPRareCardLimit.mul(100).div(freshPackCards);
2803         if (_randomNumner.div(10**3).mod(100) <= rareProb) {
2804             giveRareCard(_randomNumner.div(10**6), _requestId);
2805             nfts = nfts - 1;
2806             freshPackCards = freshPackCards - 1;
2807             FPRareCardLimit = FPRareCardLimit - 1;
2808         }
2809         uint256 commonProb = FPCommonCardLimit.mul(100).div(freshPackCards);
2810         if (_randomNumner.div(10**9).mod(100) <= commonProb) {
2811             giveCommonCard(_randomNumner.div(10**12), _requestId);
2812             nfts = nfts - 1;
2813             FPCommonCardLimit = FPCommonCardLimit - 1;
2814             freshPackCards = freshPackCards - 1;
2815         }
2816         for (; nfts > 0; nfts = nfts - 1) {
2817             giveFreshCard(_randomNumner.div(10**nfts * 5), _requestId);
2818             freshPackCards = freshPackCards - 1;
2819             FPFreshCardLimit = FPFreshCardLimit - 1;
2820         }
2821     }
2822 
2823     function giveStarterPack(uint256 _randomNumner, bytes32 _requestId) internal {
2824         uint256 nfts = 2;
2825         uint256 freshProb = SPFreshCardLimit.mul(100).div(basePackCards);
2826         if (_randomNumner.div(10**9).mod(100) <= freshProb) {
2827             giveFreshCard(_randomNumner.div(10**15), _requestId);
2828             basePackCards = basePackCards - 1;
2829             SPFreshCardLimit = SPFreshCardLimit - 1;
2830             nfts = nfts - 1;
2831         }
2832         for (; nfts > 0; nfts = nfts - 1) {
2833             giveCommonCard(_randomNumner.div(10**nfts*7), _requestId);
2834             basePackCards = basePackCards - 1;
2835             SPCommonCardLimit = SPCommonCardLimit - 1;
2836         }
2837     }
2838 
2839     function giveEliteCard(uint256 _randomNumner, bytes32 _requestId) internal {
2840         uint256 edition = _randomNumner.mod(elite.length());
2841         _mint(requestTouser[_requestId], elite.at(edition), 1, "");
2842         supplyOf[elite.at(edition)] = supplyOf[elite.at(edition)] - 1;
2843         if (supplyOf[elite.at(edition)] == 0) {
2844             elite.remove(edition);
2845         }
2846         totalSupply[edition] = totalSupply[edition] + 1;
2847     }
2848 	
2849     function giveRareCard(uint256 _randomNumner, bytes32 _requestId) internal {
2850         uint256 edition = _randomNumner.mod(rare.length());
2851         _mint(requestTouser[_requestId], rare.at(edition), 1, "");
2852         supplyOf[rare.at(edition)] = supplyOf[rare.at(edition)] - 1;
2853         if (supplyOf[rare.at(edition)] == 0) {
2854             rare.remove(edition);
2855         }
2856         totalSupply[edition] = totalSupply[edition] + 1;
2857     }
2858 
2859     function giveFreshCard(uint256 _randomNumner, bytes32 _requestId) internal {
2860         uint256 edition = _randomNumner.mod(fresh.length());
2861         _mint(requestTouser[_requestId], fresh.at(edition), 1, "");
2862         supplyOf[fresh.at(edition)] = supplyOf[fresh.at(edition)] - 1;
2863         if (supplyOf[fresh.at(edition)] == 0) {
2864             fresh.remove(edition);
2865         }
2866         totalSupply[edition] = totalSupply[edition] + 1;
2867     }
2868 
2869     function giveCommonCard(uint256 _randomNumner, bytes32 _requestId) internal {
2870         uint256 edition = _randomNumner.mod(common.length());
2871         _mint(requestTouser[_requestId], common.at(edition), 1, "");
2872         supplyOf[common.at(edition)] = supplyOf[common.at(edition)] - 1;
2873         if (supplyOf[common.at(edition)] == 0) {
2874             common.remove(edition);
2875         }
2876         totalSupply[edition] = totalSupply[edition] + 1;
2877     }
2878 	
2879 	function mintReservedNFT(address beneficiary) external onlyOwner {
2880 	   require(!paused, "the contract is paused");
2881 	   require(!reservedMinted, "already Minted");
2882 	   
2883 	    //Elite
2884 	   _mint(beneficiary, 10, 1, "");
2885 	   _mint(beneficiary, 12, 1, "");
2886 	   _mint(beneficiary, 19, 1, "");
2887 	   _mint(beneficiary, 23, 1, "");
2888 	   _mint(beneficiary, 26, 1, "");
2889 	   
2890 	    //Rare
2891 	   _mint(beneficiary, 2, 1, "");
2892 	   _mint(beneficiary, 8, 1, "");
2893 	   _mint(beneficiary, 14, 1, "");
2894 	   _mint(beneficiary, 21, 1, "");
2895 	   _mint(beneficiary, 22, 1, "");
2896 	   
2897 	    //Fresh
2898 	   _mint(beneficiary, 1, 4, "");
2899 	   _mint(beneficiary, 3, 4, "");
2900 	   _mint(beneficiary, 6, 3, "");
2901 	   _mint(beneficiary, 7, 4, "");
2902 	   _mint(beneficiary, 16, 4, "");
2903 	   _mint(beneficiary, 17, 3, "");
2904 	   _mint(beneficiary, 24, 3, "");
2905 	   
2906 	    //Fresh
2907 	   _mint(beneficiary, 18, 1, "");
2908 	   _mint(beneficiary, 27, 1, "");
2909 	   
2910 	   reservedMinted = true;
2911 	}
2912 	
2913 	function mintBreedingNFT() external onlyOwner {
2914 	   require(!paused, "the contract is paused");
2915 	   require(!breedingMinted, "already Minted");
2916 	   
2917 	  _mint(msg.sender, 31, 10, "");
2918 	  _mint(msg.sender, 32, 15, "");
2919 	  _mint(msg.sender, 33, 20, "");
2920 	  _mint(msg.sender, 34, 25, "");
2921 	  _mint(msg.sender, 35, 25, "");
2922 	  _mint(msg.sender, 36, 25, "");
2923 	  _mint(msg.sender, 37, 25, "");
2924 	  _mint(msg.sender, 38, 25, "");
2925 	  _mint(msg.sender, 39, 25, "");
2926 	  
2927 	   breedingMinted = true;
2928 	}
2929 	
2930 	function updateMintPerTransectionLimit(uint256 newLimit) external onlyOwner {
2931         minPerTxn = newLimit;
2932     }
2933 	
2934 	function setFee(uint256 newFee) public onlyOwner {
2935         fee = newFee;
2936     }
2937 }