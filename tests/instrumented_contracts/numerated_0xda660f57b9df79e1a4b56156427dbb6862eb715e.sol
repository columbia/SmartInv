1 /**
2  *Submitted for verification at Etherscan.io on 2021-12-08
3  */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.4;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view virtual returns (bytes calldata) {
15         return msg.data;
16     }
17 }
18 
19 abstract contract Ownable is Context {
20     address private _owner;
21 
22     event OwnershipTransferred(
23         address indexed previousOwner,
24         address indexed newOwner
25     );
26 
27     /**
28      * @dev Initializes the contract setting the deployer as the initial owner.
29      */
30     constructor() {
31         _setOwner(_msgSender());
32     }
33 
34     /**
35      * @dev Returns the address of the current owner.
36      */
37     function owner() public view virtual returns (address) {
38         return _owner;
39     }
40 
41     /**
42      * @dev Throws if called by any account other than the owner.
43      */
44     modifier onlyOwner() {
45         require(owner() == _msgSender(), "Ownable: caller is not the owner");
46         _;
47     }
48 
49     /**
50      * @dev Leaves the contract without owner. It will not be possible to call
51      * `onlyOwner` functions anymore. Can only be called by the current owner.
52      *
53      * NOTE: Renouncing ownership will leave the contract without an owner,
54      * thereby removing any functionality that is only available to the owner.
55      */
56     function renounceOwnership() public virtual onlyOwner {
57         _setOwner(address(0));
58     }
59 
60     /**
61      * @dev Transfers ownership of the contract to a new account (`newOwner`).
62      * Can only be called by the current owner.
63      */
64     function transferOwnership(address newOwner) public virtual onlyOwner {
65         require(
66             newOwner != address(0),
67             "Ownable: new owner is the zero address"
68         );
69         _setOwner(newOwner);
70     }
71 
72     function _setOwner(address newOwner) private {
73         address oldOwner = _owner;
74         _owner = newOwner;
75         emit OwnershipTransferred(oldOwner, newOwner);
76     }
77 }
78 
79 // File: @openzeppelin/contracts/utils/Address.sol
80 
81 /**
82  * @dev Collection of functions related to the address type
83  */
84 library Address {
85     /**
86      * @dev Returns true if `account` is a contract.
87      *
88      * [IMPORTANT]
89      * ====
90      * It is unsafe to assume that an address for which this function returns
91      * false is an externally-owned account (EOA) and not a contract.
92      *
93      * Among others, `isContract` will return false for the following
94      * types of addresses:
95      *
96      *  - an externally-owned account
97      *  - a contract in construction
98      *  - an address where a contract will be created
99      *  - an address where a contract lived, but was destroyed
100      * ====
101      */
102     function isContract(address account) internal view returns (bool) {
103         // This method relies on extcodesize, which returns 0 for contracts in
104         // construction, since the code is only stored at the end of the
105         // constructor execution.
106 
107         uint256 size;
108         assembly {
109             size := extcodesize(account)
110         }
111         return size > 0;
112     }
113 
114     /**
115      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
116      * `recipient`, forwarding all available gas and reverting on errors.
117      *
118      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
119      * of certain opcodes, possibly making contracts go over the 2300 gas limit
120      * imposed by `transfer`, making them unable to receive funds via
121      * `transfer`. {sendValue} removes this limitation.
122      *
123      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
124      *
125      * IMPORTANT: because control is transferred to `recipient`, care must be
126      * taken to not create reentrancy vulnerabilities. Consider using
127      * {ReentrancyGuard} or the
128      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
129      */
130     function sendValue(address payable recipient, uint256 amount) internal {
131         require(
132             address(this).balance >= amount,
133             "Address: insufficient balance"
134         );
135 
136         (bool success, ) = recipient.call{value: amount}("");
137         require(
138             success,
139             "Address: unable to send value, recipient may have reverted"
140         );
141     }
142 
143     /**
144      * @dev Performs a Solidity function call using a low level `call`. A
145      * plain `call` is an unsafe replacement for a function call: use this
146      * function instead.
147      *
148      * If `target` reverts with a revert reason, it is bubbled up by this
149      * function (like regular Solidity function calls).
150      *
151      * Returns the raw returned data. To convert to the expected return value,
152      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
153      *
154      * Requirements:
155      *
156      * - `target` must be a contract.
157      * - calling `target` with `data` must not revert.
158      *
159      * _Available since v3.1._
160      */
161     function functionCall(address target, bytes memory data)
162         internal
163         returns (bytes memory)
164     {
165         return functionCall(target, data, "Address: low-level call failed");
166     }
167 
168     /**
169      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
170      * `errorMessage` as a fallback revert reason when `target` reverts.
171      *
172      * _Available since v3.1._
173      */
174     function functionCall(
175         address target,
176         bytes memory data,
177         string memory errorMessage
178     ) internal returns (bytes memory) {
179         return functionCallWithValue(target, data, 0, errorMessage);
180     }
181 
182     /**
183      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
184      * but also transferring `value` wei to `target`.
185      *
186      * Requirements:
187      *
188      * - the calling contract must have an ETH balance of at least `value`.
189      * - the called Solidity function must be `payable`.
190      *
191      * _Available since v3.1._
192      */
193     function functionCallWithValue(
194         address target,
195         bytes memory data,
196         uint256 value
197     ) internal returns (bytes memory) {
198         return
199             functionCallWithValue(
200                 target,
201                 data,
202                 value,
203                 "Address: low-level call with value failed"
204             );
205     }
206 
207     /**
208      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
209      * with `errorMessage` as a fallback revert reason when `target` reverts.
210      *
211      * _Available since v3.1._
212      */
213     function functionCallWithValue(
214         address target,
215         bytes memory data,
216         uint256 value,
217         string memory errorMessage
218     ) internal returns (bytes memory) {
219         require(
220             address(this).balance >= value,
221             "Address: insufficient balance for call"
222         );
223         require(isContract(target), "Address: call to non-contract");
224 
225         (bool success, bytes memory returndata) = target.call{value: value}(
226             data
227         );
228         return verifyCallResult(success, returndata, errorMessage);
229     }
230 
231     /**
232      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
233      * but performing a static call.
234      *
235      * _Available since v3.3._
236      */
237     function functionStaticCall(address target, bytes memory data)
238         internal
239         view
240         returns (bytes memory)
241     {
242         return
243             functionStaticCall(
244                 target,
245                 data,
246                 "Address: low-level static call failed"
247             );
248     }
249 
250     /**
251      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
252      * but performing a static call.
253      *
254      * _Available since v3.3._
255      */
256     function functionStaticCall(
257         address target,
258         bytes memory data,
259         string memory errorMessage
260     ) internal view returns (bytes memory) {
261         require(isContract(target), "Address: static call to non-contract");
262 
263         (bool success, bytes memory returndata) = target.staticcall(data);
264         return verifyCallResult(success, returndata, errorMessage);
265     }
266 
267     /**
268      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
269      * but performing a delegate call.
270      *
271      * _Available since v3.4._
272      */
273     function functionDelegateCall(address target, bytes memory data)
274         internal
275         returns (bytes memory)
276     {
277         return
278             functionDelegateCall(
279                 target,
280                 data,
281                 "Address: low-level delegate call failed"
282             );
283     }
284 
285     /**
286      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
287      * but performing a delegate call.
288      *
289      * _Available since v3.4._
290      */
291     function functionDelegateCall(
292         address target,
293         bytes memory data,
294         string memory errorMessage
295     ) internal returns (bytes memory) {
296         require(isContract(target), "Address: delegate call to non-contract");
297 
298         (bool success, bytes memory returndata) = target.delegatecall(data);
299         return verifyCallResult(success, returndata, errorMessage);
300     }
301 
302     /**
303      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
304      * revert reason using the provided one.
305      *
306      * _Available since v4.3._
307      */
308     function verifyCallResult(
309         bool success,
310         bytes memory returndata,
311         string memory errorMessage
312     ) internal pure returns (bytes memory) {
313         if (success) {
314             return returndata;
315         } else {
316             // Look for revert reason and bubble it up if present
317             if (returndata.length > 0) {
318                 // The easiest way to bubble the revert reason is using memory via assembly
319 
320                 assembly {
321                     let returndata_size := mload(returndata)
322                     revert(add(32, returndata), returndata_size)
323                 }
324             } else {
325                 revert(errorMessage);
326             }
327         }
328     }
329 }
330 
331 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
332 
333 /**
334  * @dev Interface of the ERC165 standard, as defined in the
335  * https://eips.ethereum.org/EIPS/eip-165[EIP].
336  *
337  * Implementers can declare support of contract interfaces, which can then be
338  * queried by others ({ERC165Checker}).
339  *
340  * For an implementation, see {ERC165}.
341  */
342 interface IERC165 {
343     /**
344      * @dev Returns true if this contract implements the interface defined by
345      * `interfaceId`. See the corresponding
346      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
347      * to learn more about how these ids are created.
348      *
349      * This function call must use less than 30 000 gas.
350      */
351     function supportsInterface(bytes4 interfaceId) external view returns (bool);
352 }
353 
354 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
355 
356 /**
357  * @dev Implementation of the {IERC165} interface.
358  *
359  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
360  * for the additional interface id that will be supported. For example:
361  *
362  * ```solidity
363  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
364  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
365  * }
366  * ```
367  *
368  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
369  */
370 abstract contract ERC165 is IERC165 {
371     /**
372      * @dev See {IERC165-supportsInterface}.
373      */
374     function supportsInterface(bytes4 interfaceId)
375         public
376         view
377         virtual
378         override
379         returns (bool)
380     {
381         return interfaceId == type(IERC165).interfaceId;
382     }
383 }
384 
385 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
386 
387 /**
388  * @dev _Available since v3.1._
389  */
390 interface IERC1155Receiver is IERC165 {
391     /**
392         @dev Handles the receipt of a single ERC1155 token type. This function is
393         called at the end of a `safeTransferFrom` after the balance has been updated.
394         To accept the transfer, this must return
395         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
396         (i.e. 0xf23a6e61, or its own function selector).
397         @param operator The address which initiated the transfer (i.e. msg.sender)
398         @param from The address which previously owned the token
399         @param id The ID of the token being transferred
400         @param value The amount of tokens being transferred
401         @param data Additional data with no specified format
402         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
403     */
404     function onERC1155Received(
405         address operator,
406         address from,
407         uint256 id,
408         uint256 value,
409         bytes calldata data
410     ) external returns (bytes4);
411 
412     /**
413         @dev Handles the receipt of a multiple ERC1155 token types. This function
414         is called at the end of a `safeBatchTransferFrom` after the balances have
415         been updated. To accept the transfer(s), this must return
416         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
417         (i.e. 0xbc197c81, or its own function selector).
418         @param operator The address which initiated the batch transfer (i.e. msg.sender)
419         @param from The address which previously owned the token
420         @param ids An array containing ids of each token being transferred (order and length must match values array)
421         @param values An array containing amounts of each token being transferred (order and length must match ids array)
422         @param data Additional data with no specified format
423         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
424     */
425     function onERC1155BatchReceived(
426         address operator,
427         address from,
428         uint256[] calldata ids,
429         uint256[] calldata values,
430         bytes calldata data
431     ) external returns (bytes4);
432 }
433 
434 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
435 
436 /**
437  * @dev Required interface of an ERC1155 compliant contract, as defined in the
438  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
439  *
440  * _Available since v3.1._
441  */
442 interface IERC1155 is IERC165 {
443     /**
444      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
445      */
446     event TransferSingle(
447         address indexed operator,
448         address indexed from,
449         address indexed to,
450         uint256 id,
451         uint256 value
452     );
453 
454     /**
455      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
456      * transfers.
457      */
458     event TransferBatch(
459         address indexed operator,
460         address indexed from,
461         address indexed to,
462         uint256[] ids,
463         uint256[] values
464     );
465 
466     /**
467      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
468      * `approved`.
469      */
470     event ApprovalForAll(
471         address indexed account,
472         address indexed operator,
473         bool approved
474     );
475 
476     /**
477      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
478      *
479      * If an {URI} event was emitted for `id`, the standard
480      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
481      * returned by {IERC1155MetadataURI-uri}.
482      */
483     event URI(string value, uint256 indexed id);
484 
485     /**
486      * @dev Returns the amount of tokens of token type `id` owned by `account`.
487      *
488      * Requirements:
489      *
490      * - `account` cannot be the zero address.
491      */
492     function balanceOf(address account, uint256 id)
493         external
494         view
495         returns (uint256);
496 
497     /**
498      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
499      *
500      * Requirements:
501      *
502      * - `accounts` and `ids` must have the same length.
503      */
504     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
505         external
506         view
507         returns (uint256[] memory);
508 
509     /**
510      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
511      *
512      * Emits an {ApprovalForAll} event.
513      *
514      * Requirements:
515      *
516      * - `operator` cannot be the caller.
517      */
518     function setApprovalForAll(address operator, bool approved) external;
519 
520     /**
521      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
522      *
523      * See {setApprovalForAll}.
524      */
525     function isApprovedForAll(address account, address operator)
526         external
527         view
528         returns (bool);
529 
530     /**
531      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
532      *
533      * Emits a {TransferSingle} event.
534      *
535      * Requirements:
536      *
537      * - `to` cannot be the zero address.
538      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
539      * - `from` must have a balance of tokens of type `id` of at least `amount`.
540      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
541      * acceptance magic value.
542      */
543     function safeTransferFrom(
544         address from,
545         address to,
546         uint256 id,
547         uint256 amount,
548         bytes calldata data
549     ) external;
550 
551     /**
552      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
553      *
554      * Emits a {TransferBatch} event.
555      *
556      * Requirements:
557      *
558      * - `ids` and `amounts` must have the same length.
559      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
560      * acceptance magic value.
561      */
562     function safeBatchTransferFrom(
563         address from,
564         address to,
565         uint256[] calldata ids,
566         uint256[] calldata amounts,
567         bytes calldata data
568     ) external;
569 }
570 
571 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
572 
573 /**
574  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
575  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
576  *
577  * _Available since v3.1._
578  */
579 interface IERC1155MetadataURI is IERC1155 {
580     /**
581      * @dev Returns the URI for token type `id`.
582      *
583      * If the `\{id\}` substring is present in the URI, it must be replaced by
584      * clients with the actual token type ID.
585      */
586     function uri(uint256 id) external view returns (string memory);
587 }
588 
589 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
590 
591 /**
592  * @dev Implementation of the basic standard multi-token.
593  * See https://eips.ethereum.org/EIPS/eip-1155
594  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
595  *
596  * _Available since v3.1._
597  */
598 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
599     using Address for address;
600 
601     // Mapping from token ID to account balances
602     mapping(uint256 => mapping(address => uint256)) private _balances;
603 
604     // Mapping from account to operator approvals
605     mapping(address => mapping(address => bool)) private _operatorApprovals;
606 
607     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
608     string private _uri;
609 
610     /**
611      * @dev See {_setURI}.
612      */
613     constructor() {}
614 
615     /**
616      * @dev See {IERC165-supportsInterface}.
617      */
618     function supportsInterface(bytes4 interfaceId)
619         public
620         view
621         virtual
622         override(ERC165, IERC165)
623         returns (bool)
624     {
625         return
626             interfaceId == type(IERC1155).interfaceId ||
627             interfaceId == type(IERC1155MetadataURI).interfaceId ||
628             super.supportsInterface(interfaceId);
629     }
630 
631     /**
632      * @dev See {IERC1155MetadataURI-uri}.
633      *
634      * This implementation returns the same URI for *all* token types. It relies
635      * on the token type ID substitution mechanism
636      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
637      *
638      * Clients calling this function must replace the `\{id\}` substring with the
639      * actual token type ID.
640      */
641     function uri(uint256) public view virtual override returns (string memory) {
642         return _uri;
643     }
644 
645     /**
646      * @dev See {IERC1155-balanceOf}.
647      *
648      * Requirements:
649      *
650      * - `account` cannot be the zero address.
651      */
652     function balanceOf(address account, uint256 id)
653         public
654         view
655         virtual
656         override
657         returns (uint256)
658     {
659         require(
660             account != address(0),
661             "ERC1155: balance query for the zero address"
662         );
663         return _balances[id][account];
664     }
665 
666     /**
667      * @dev See {IERC1155-balanceOfBatch}.
668      *
669      * Requirements:
670      *
671      * - `accounts` and `ids` must have the same length.
672      */
673     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
674         public
675         view
676         virtual
677         override
678         returns (uint256[] memory)
679     {
680         require(
681             accounts.length == ids.length,
682             "ERC1155: accounts and ids length mismatch"
683         );
684 
685         uint256[] memory batchBalances = new uint256[](accounts.length);
686 
687         for (uint256 i = 0; i < accounts.length; ++i) {
688             batchBalances[i] = balanceOf(accounts[i], ids[i]);
689         }
690 
691         return batchBalances;
692     }
693 
694     /**
695      * @dev See {IERC1155-setApprovalForAll}.
696      */
697     function setApprovalForAll(address operator, bool approved)
698         public
699         virtual
700         override
701     {
702         require(
703             _msgSender() != operator,
704             "ERC1155: setting approval status for self"
705         );
706 
707         _operatorApprovals[_msgSender()][operator] = approved;
708         emit ApprovalForAll(_msgSender(), operator, approved);
709     }
710 
711     /**
712      * @dev See {IERC1155-isApprovedForAll}.
713      */
714     function isApprovedForAll(address account, address operator)
715         public
716         view
717         virtual
718         override
719         returns (bool)
720     {
721         return _operatorApprovals[account][operator];
722     }
723 
724     /**
725      * @dev See {IERC1155-safeTransferFrom}.
726      */
727     function safeTransferFrom(
728         address from,
729         address to,
730         uint256 id,
731         uint256 amount,
732         bytes memory data
733     ) public virtual override {
734         require(
735             from == _msgSender() || isApprovedForAll(from, _msgSender()),
736             "ERC1155: caller is not owner nor approved"
737         );
738         _safeTransferFrom(from, to, id, amount, data);
739     }
740 
741     /**
742      * @dev See {IERC1155-safeBatchTransferFrom}.
743      */
744     function safeBatchTransferFrom(
745         address from,
746         address to,
747         uint256[] memory ids,
748         uint256[] memory amounts,
749         bytes memory data
750     ) public virtual override {
751         require(
752             from == _msgSender() || isApprovedForAll(from, _msgSender()),
753             "ERC1155: transfer caller is not owner nor approved"
754         );
755         _safeBatchTransferFrom(from, to, ids, amounts, data);
756     }
757 
758     /**
759      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
760      *
761      * Emits a {TransferSingle} event.
762      *
763      * Requirements:
764      *
765      * - `to` cannot be the zero address.
766      * - `from` must have a balance of tokens of type `id` of at least `amount`.
767      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
768      * acceptance magic value.
769      */
770     function _safeTransferFrom(
771         address from,
772         address to,
773         uint256 id,
774         uint256 amount,
775         bytes memory data
776     ) internal virtual {
777         require(to != address(0), "ERC1155: transfer to the zero address");
778 
779         address operator = _msgSender();
780 
781         _beforeTokenTransfer(
782             operator,
783             from,
784             to,
785             _asSingletonArray(id),
786             _asSingletonArray(amount),
787             data
788         );
789 
790         uint256 fromBalance = _balances[id][from];
791         require(
792             fromBalance >= amount,
793             "ERC1155: insufficient balance for transfer"
794         );
795         unchecked {
796             _balances[id][from] = fromBalance - amount;
797         }
798         _balances[id][to] += amount;
799 
800         emit TransferSingle(operator, from, to, id, amount);
801 
802         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
803     }
804 
805     /**
806      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
807      *
808      * Emits a {TransferBatch} event.
809      *
810      * Requirements:
811      *
812      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
813      * acceptance magic value.
814      */
815     function _safeBatchTransferFrom(
816         address from,
817         address to,
818         uint256[] memory ids,
819         uint256[] memory amounts,
820         bytes memory data
821     ) internal virtual {
822         require(
823             ids.length == amounts.length,
824             "ERC1155: ids and amounts length mismatch"
825         );
826         require(to != address(0), "ERC1155: transfer to the zero address");
827 
828         address operator = _msgSender();
829 
830         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
831 
832         for (uint256 i = 0; i < ids.length; ++i) {
833             uint256 id = ids[i];
834             uint256 amount = amounts[i];
835 
836             uint256 fromBalance = _balances[id][from];
837             require(
838                 fromBalance >= amount,
839                 "ERC1155: insufficient balance for transfer"
840             );
841             unchecked {
842                 _balances[id][from] = fromBalance - amount;
843             }
844             _balances[id][to] += amount;
845         }
846 
847         emit TransferBatch(operator, from, to, ids, amounts);
848 
849         _doSafeBatchTransferAcceptanceCheck(
850             operator,
851             from,
852             to,
853             ids,
854             amounts,
855             data
856         );
857     }
858 
859     /**
860      * @dev Sets a new URI for all token types, by relying on the token type ID
861      * substitution mechanism
862      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
863      *
864      * By this mechanism, any occurrence of the `\{id\}` substring in either the
865      * URI or any of the amounts in the JSON file at said URI will be replaced by
866      * clients with the token type ID.
867      *
868      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
869      * interpreted by clients as
870      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
871      * for token type ID 0x4cce0.
872      *
873      * See {uri}.
874      *
875      * Because these URIs cannot be meaningfully represented by the {URI} event,
876      * this function emits no events.
877      */
878     function _setURI(string memory newuri) internal virtual {
879         _uri = newuri;
880     }
881 
882     /**
883      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
884      *
885      * Emits a {TransferSingle} event.
886      *
887      * Requirements:
888      *
889      * - `account` cannot be the zero address.
890      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
891      * acceptance magic value.
892      */
893     function _mint(
894         address account,
895         uint256 id,
896         uint256 amount,
897         bytes memory data
898     ) internal virtual {
899         require(account != address(0), "ERC1155: mint to the zero address");
900 
901         address operator = _msgSender();
902 
903         _beforeTokenTransfer(
904             operator,
905             address(0),
906             account,
907             _asSingletonArray(id),
908             _asSingletonArray(amount),
909             data
910         );
911 
912         _balances[id][account] += amount;
913         emit TransferSingle(operator, address(0), account, id, amount);
914 
915         _doSafeTransferAcceptanceCheck(
916             operator,
917             address(0),
918             account,
919             id,
920             amount,
921             data
922         );
923     }
924 
925     /**
926      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
927      *
928      * Requirements:
929      *
930      * - `ids` and `amounts` must have the same length.
931      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
932      * acceptance magic value.
933      */
934     function _mintBatch(
935         address to,
936         uint256[] memory ids,
937         uint256[] memory amounts,
938         bytes memory data
939     ) internal virtual {
940         require(to != address(0), "ERC1155: mint to the zero address");
941         require(
942             ids.length == amounts.length,
943             "ERC1155: ids and amounts length mismatch"
944         );
945 
946         address operator = _msgSender();
947 
948         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
949 
950         for (uint256 i = 0; i < ids.length; i++) {
951             _balances[ids[i]][to] += amounts[i];
952         }
953 
954         emit TransferBatch(operator, address(0), to, ids, amounts);
955 
956         _doSafeBatchTransferAcceptanceCheck(
957             operator,
958             address(0),
959             to,
960             ids,
961             amounts,
962             data
963         );
964     }
965 
966     /**
967      * @dev Destroys `amount` tokens of token type `id` from `account`
968      *
969      * Requirements:
970      *
971      * - `account` cannot be the zero address.
972      * - `account` must have at least `amount` tokens of token type `id`.
973      */
974     function _burn(
975         address account,
976         uint256 id,
977         uint256 amount
978     ) internal virtual {
979         require(account != address(0), "ERC1155: burn from the zero address");
980 
981         address operator = _msgSender();
982 
983         _beforeTokenTransfer(
984             operator,
985             account,
986             address(0),
987             _asSingletonArray(id),
988             _asSingletonArray(amount),
989             ""
990         );
991 
992         uint256 accountBalance = _balances[id][account];
993         require(
994             accountBalance >= amount,
995             "ERC1155: burn amount exceeds balance"
996         );
997         unchecked {
998             _balances[id][account] = accountBalance - amount;
999         }
1000 
1001         emit TransferSingle(operator, account, address(0), id, amount);
1002     }
1003 
1004     /**
1005      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1006      *
1007      * Requirements:
1008      *
1009      * - `ids` and `amounts` must have the same length.
1010      */
1011     function _burnBatch(
1012         address account,
1013         uint256[] memory ids,
1014         uint256[] memory amounts
1015     ) internal virtual {
1016         require(account != address(0), "ERC1155: burn from the zero address");
1017         require(
1018             ids.length == amounts.length,
1019             "ERC1155: ids and amounts length mismatch"
1020         );
1021 
1022         address operator = _msgSender();
1023 
1024         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
1025 
1026         for (uint256 i = 0; i < ids.length; i++) {
1027             uint256 id = ids[i];
1028             uint256 amount = amounts[i];
1029 
1030             uint256 accountBalance = _balances[id][account];
1031             require(
1032                 accountBalance >= amount,
1033                 "ERC1155: burn amount exceeds balance"
1034             );
1035             unchecked {
1036                 _balances[id][account] = accountBalance - amount;
1037             }
1038         }
1039 
1040         emit TransferBatch(operator, account, address(0), ids, amounts);
1041     }
1042 
1043     /**
1044      * @dev Hook that is called before any token transfer. This includes minting
1045      * and burning, as well as batched variants.
1046      *
1047      * The same hook is called on both single and batched variants. For single
1048      * transfers, the length of the `id` and `amount` arrays will be 1.
1049      *
1050      * Calling conditions (for each `id` and `amount` pair):
1051      *
1052      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1053      * of token type `id` will be  transferred to `to`.
1054      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1055      * for `to`.
1056      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1057      * will be burned.
1058      * - `from` and `to` are never both zero.
1059      * - `ids` and `amounts` have the same, non-zero length.
1060      *
1061      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1062      */
1063     function _beforeTokenTransfer(
1064         address operator,
1065         address from,
1066         address to,
1067         uint256[] memory ids,
1068         uint256[] memory amounts,
1069         bytes memory data
1070     ) internal virtual {}
1071 
1072     function _doSafeTransferAcceptanceCheck(
1073         address operator,
1074         address from,
1075         address to,
1076         uint256 id,
1077         uint256 amount,
1078         bytes memory data
1079     ) private {
1080         if (to.isContract()) {
1081             try
1082                 IERC1155Receiver(to).onERC1155Received(
1083                     operator,
1084                     from,
1085                     id,
1086                     amount,
1087                     data
1088                 )
1089             returns (bytes4 response) {
1090                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1091                     revert("ERC1155: ERC1155Receiver rejected tokens");
1092                 }
1093             } catch Error(string memory reason) {
1094                 revert(reason);
1095             } catch {
1096                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1097             }
1098         }
1099     }
1100 
1101     function _doSafeBatchTransferAcceptanceCheck(
1102         address operator,
1103         address from,
1104         address to,
1105         uint256[] memory ids,
1106         uint256[] memory amounts,
1107         bytes memory data
1108     ) private {
1109         if (to.isContract()) {
1110             try
1111                 IERC1155Receiver(to).onERC1155BatchReceived(
1112                     operator,
1113                     from,
1114                     ids,
1115                     amounts,
1116                     data
1117                 )
1118             returns (bytes4 response) {
1119                 if (
1120                     response != IERC1155Receiver.onERC1155BatchReceived.selector
1121                 ) {
1122                     revert("ERC1155: ERC1155Receiver rejected tokens");
1123                 }
1124             } catch Error(string memory reason) {
1125                 revert(reason);
1126             } catch {
1127                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1128             }
1129         }
1130     }
1131 
1132     function _asSingletonArray(uint256 element)
1133         private
1134         pure
1135         returns (uint256[] memory)
1136     {
1137         uint256[] memory array = new uint256[](1);
1138         array[0] = element;
1139 
1140         return array;
1141     }
1142 }
1143 
1144 /**
1145  * @dev Wrappers over Solidity's arithmetic operations.
1146  *
1147  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1148  * now has built in overflow checking.
1149  */
1150 library SafeMath {
1151     /**
1152      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1153      *
1154      * _Available since v3.4._
1155      */
1156     function tryAdd(uint256 a, uint256 b)
1157         internal
1158         pure
1159         returns (bool, uint256)
1160     {
1161         unchecked {
1162             uint256 c = a + b;
1163             if (c < a) return (false, 0);
1164             return (true, c);
1165         }
1166     }
1167 
1168     /**
1169      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1170      *
1171      * _Available since v3.4._
1172      */
1173     function trySub(uint256 a, uint256 b)
1174         internal
1175         pure
1176         returns (bool, uint256)
1177     {
1178         unchecked {
1179             if (b > a) return (false, 0);
1180             return (true, a - b);
1181         }
1182     }
1183 
1184     /**
1185      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1186      *
1187      * _Available since v3.4._
1188      */
1189     function tryMul(uint256 a, uint256 b)
1190         internal
1191         pure
1192         returns (bool, uint256)
1193     {
1194         unchecked {
1195             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1196             // benefit is lost if 'b' is also tested.
1197             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1198             if (a == 0) return (true, 0);
1199             uint256 c = a * b;
1200             if (c / a != b) return (false, 0);
1201             return (true, c);
1202         }
1203     }
1204 
1205     /**
1206      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1207      *
1208      * _Available since v3.4._
1209      */
1210     function tryDiv(uint256 a, uint256 b)
1211         internal
1212         pure
1213         returns (bool, uint256)
1214     {
1215         unchecked {
1216             if (b == 0) return (false, 0);
1217             return (true, a / b);
1218         }
1219     }
1220 
1221     /**
1222      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1223      *
1224      * _Available since v3.4._
1225      */
1226     function tryMod(uint256 a, uint256 b)
1227         internal
1228         pure
1229         returns (bool, uint256)
1230     {
1231         unchecked {
1232             if (b == 0) return (false, 0);
1233             return (true, a % b);
1234         }
1235     }
1236 
1237     /**
1238      * @dev Returns the addition of two unsigned integers, reverting on
1239      * overflow.
1240      *
1241      * Counterpart to Solidity's `+` operator.
1242      *
1243      * Requirements:
1244      *
1245      * - Addition cannot overflow.
1246      */
1247     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1248         return a + b;
1249     }
1250 
1251     /**
1252      * @dev Returns the subtraction of two unsigned integers, reverting on
1253      * overflow (when the result is negative).
1254      *
1255      * Counterpart to Solidity's `-` operator.
1256      *
1257      * Requirements:
1258      *
1259      * - Subtraction cannot overflow.
1260      */
1261     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1262         return a - b;
1263     }
1264 
1265     /**
1266      * @dev Returns the multiplication of two unsigned integers, reverting on
1267      * overflow.
1268      *
1269      * Counterpart to Solidity's `*` operator.
1270      *
1271      * Requirements:
1272      *
1273      * - Multiplication cannot overflow.
1274      */
1275     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1276         return a * b;
1277     }
1278 
1279     /**
1280      * @dev Returns the integer division of two unsigned integers, reverting on
1281      * division by zero. The result is rounded towards zero.
1282      *
1283      * Counterpart to Solidity's `/` operator.
1284      *
1285      * Requirements:
1286      *
1287      * - The divisor cannot be zero.
1288      */
1289     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1290         return a / b;
1291     }
1292 
1293     /**
1294      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1295      * reverting when dividing by zero.
1296      *
1297      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1298      * opcode (which leaves remaining gas untouched) while Solidity uses an
1299      * invalid opcode to revert (consuming all remaining gas).
1300      *
1301      * Requirements:
1302      *
1303      * - The divisor cannot be zero.
1304      */
1305     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1306         return a % b;
1307     }
1308 
1309     /**
1310      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1311      * overflow (when the result is negative).
1312      *
1313      * CAUTION: This function is deprecated because it requires allocating memory for the error
1314      * message unnecessarily. For custom revert reasons use {trySub}.
1315      *
1316      * Counterpart to Solidity's `-` operator.
1317      *
1318      * Requirements:
1319      *
1320      * - Subtraction cannot overflow.
1321      */
1322     function sub(
1323         uint256 a,
1324         uint256 b,
1325         string memory errorMessage
1326     ) internal pure returns (uint256) {
1327         unchecked {
1328             require(b <= a, errorMessage);
1329             return a - b;
1330         }
1331     }
1332 
1333     /**
1334      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1335      * division by zero. The result is rounded towards zero.
1336      *
1337      * Counterpart to Solidity's `/` operator. Note: this function uses a
1338      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1339      * uses an invalid opcode to revert (consuming all remaining gas).
1340      *
1341      * Requirements:
1342      *
1343      * - The divisor cannot be zero.
1344      */
1345     function div(
1346         uint256 a,
1347         uint256 b,
1348         string memory errorMessage
1349     ) internal pure returns (uint256) {
1350         unchecked {
1351             require(b > 0, errorMessage);
1352             return a / b;
1353         }
1354     }
1355 
1356     /**
1357      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1358      * reverting with custom message when dividing by zero.
1359      *
1360      * CAUTION: This function is deprecated because it requires allocating memory for the error
1361      * message unnecessarily. For custom revert reasons use {tryMod}.
1362      *
1363      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1364      * opcode (which leaves remaining gas untouched) while Solidity uses an
1365      * invalid opcode to revert (consuming all remaining gas).
1366      *
1367      * Requirements:
1368      *
1369      * - The divisor cannot be zero.
1370      */
1371     function mod(
1372         uint256 a,
1373         uint256 b,
1374         string memory errorMessage
1375     ) internal pure returns (uint256) {
1376         unchecked {
1377             require(b > 0, errorMessage);
1378             return a % b;
1379         }
1380     }
1381 }
1382 
1383 /**
1384  * @dev String operations.
1385  */
1386 library Strings {
1387     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1388 
1389     /**
1390      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1391      */
1392     function toString(uint256 value) internal pure returns (string memory) {
1393         // Inspired by OraclizeAPI's implementation - MIT licence
1394         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1395 
1396         if (value == 0) {
1397             return "0";
1398         }
1399         uint256 temp = value;
1400         uint256 digits;
1401         while (temp != 0) {
1402             digits++;
1403             temp /= 10;
1404         }
1405         bytes memory buffer = new bytes(digits);
1406         while (value != 0) {
1407             digits -= 1;
1408             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1409             value /= 10;
1410         }
1411         return string(buffer);
1412     }
1413 
1414     /**
1415      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1416      */
1417     function toHexString(uint256 value) internal pure returns (string memory) {
1418         if (value == 0) {
1419             return "0x00";
1420         }
1421         uint256 temp = value;
1422         uint256 length = 0;
1423         while (temp != 0) {
1424             length++;
1425             temp >>= 8;
1426         }
1427         return toHexString(value, length);
1428     }
1429 
1430     /**
1431      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1432      */
1433     function toHexString(uint256 value, uint256 length)
1434         internal
1435         pure
1436         returns (string memory)
1437     {
1438         bytes memory buffer = new bytes(2 * length + 2);
1439         buffer[0] = "0";
1440         buffer[1] = "x";
1441         for (uint256 i = 2 * length + 1; i > 1; --i) {
1442             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1443             value >>= 4;
1444         }
1445         require(value == 0, "Strings: hex length insufficient");
1446         return string(buffer);
1447     }
1448 }
1449 
1450 abstract contract MoodyApeInterface {
1451     function balanceOf(address owner, uint256 tokenId)
1452         external
1453         view
1454         virtual
1455         returns (uint256);
1456 }
1457 
1458 contract BabyMoody is ERC1155, Ownable {
1459     string public constant name = "Baby Moody";
1460     string public constant symbol = "BMAC";
1461 
1462     using SafeMath for uint256;
1463     using Strings for uint256;
1464     uint256 public totalSupply = 0;
1465     uint256 public NFTPrice = 200000000000000000; // 0.2 ETH;
1466     uint256 public constant BUY_LIMIT_PER_TX = 5;
1467     uint256 public constant WHITELIST_MAX_MINT = 2;
1468     uint256 public MAX_NFT = 1810;
1469     bytes32 public root;
1470     bool public isReveal;
1471     bool public isActive;
1472     bool public isFreeMintActive;
1473     bool public isPublicSaleActive;
1474     bool public isPresaleActive;
1475     string private baseURI;
1476     mapping(uint256 => bool) public tokenIdUsedForGiveaway;
1477     mapping(address => uint256) public whiteListClaimed;
1478 
1479     address moodyApeContractAddress;
1480 
1481     /*
1482     Function to activate the contract
1483     */
1484     function toggleActive() external onlyOwner {
1485         isActive = !isActive;
1486     }
1487 
1488     /*
1489     Function to activate the free mint
1490     */
1491     function setFreeMint() external onlyOwner {
1492         isFreeMintActive = !isFreeMintActive;
1493     }
1494 
1495     /*
1496     Function to activate public sale
1497     */
1498     function setPublicSaleActive() external onlyOwner {
1499         isPublicSaleActive = !isPublicSaleActive;
1500     }
1501 
1502     /*
1503      * Function toggleReveal to change NFT metadata
1504     */
1505     function toggleReveal() external onlyOwner {
1506         isReveal = !isReveal;
1507     }
1508 
1509     /*
1510     Function to activate the presale mint
1511     */
1512     function togglePresale() external onlyOwner {
1513         isPresaleActive = !isPresaleActive;
1514     }
1515 
1516     /*
1517      * Function to set ERC1155 contract
1518      */
1519     function setMoodyApeContract(address _contractAddress) external onlyOwner {
1520         moodyApeContractAddress = _contractAddress;
1521     }
1522 
1523     /*
1524     Function to change the nft price
1525     */
1526     function setNFTPrice(uint256 _NFTPrice) external onlyOwner {
1527         NFTPrice = _NFTPrice;
1528     }
1529 
1530     /*
1531     Function to change the nft supply
1532     */
1533     function setSupply(uint256 _MAX_NFT) external onlyOwner {
1534         MAX_NFT = _MAX_NFT;
1535     }
1536 
1537     /*
1538      * Function to get Base URI for a given tokenID
1539      */
1540     function uri(uint256 _tokenId)
1541         public
1542         view
1543         virtual
1544         override
1545         returns (string memory)
1546     {
1547         require(_tokenId < totalSupply, "ERC1155Metadata: URI query for nonexistent token"
1548         );
1549 
1550         if (!isReveal) {
1551             return string(abi.encodePacked(baseURI));
1552         } else {
1553             return string(abi.encodePacked(baseURI, _tokenId.toString()));
1554         }
1555     }
1556 
1557     /*
1558      * Function to set Base URI
1559      */
1560     function setURI(string memory _URI) external onlyOwner {
1561         baseURI = _URI;
1562     }
1563 
1564     /*
1565      * Function to withdraw collected amount during minting by the owner
1566      */
1567     function withdraw() public onlyOwner {
1568         uint256 balance = address(this).balance;
1569         require(balance > 0, "Balance should be more than zero");
1570         payable(address(owner())).transfer(balance);
1571     }
1572 
1573     /*
1574      * Function to mint NFTs
1575      */
1576     function mint(address to, uint256 count) internal {
1577         if (count > 1) {
1578             uint256[] memory ids = new uint256[](uint256(count));
1579             uint256[] memory amounts = new uint256[](uint256(count));
1580 
1581             for (uint32 i = 0; i < count; i++) {
1582                 ids[i] = totalSupply + i;
1583                 amounts[i] = 1;
1584             }
1585 
1586             _mintBatch(to, ids, amounts, "");
1587         } else {
1588             _mint(to, totalSupply, 1, "");
1589         }
1590 
1591         totalSupply += count;
1592     }
1593 
1594     /*
1595      * Function to mint new NFTs during the public sale
1596      * It is payable. Amount is calculated as per (NFTPrice.mul(_numOfTokens))
1597      */
1598     function mintPublicSale(uint256 _numOfTokens) public payable {
1599         require(isActive, "Contract is not active");
1600         require(isPublicSaleActive, "Public sale is not open yet");
1601         require(_numOfTokens <= BUY_LIMIT_PER_TX, "Cannot mint above limit");
1602         require(totalSupply.add(_numOfTokens) <= MAX_NFT,"Purchase would exceed max public supply of NFTs");
1603         require(NFTPrice.mul(_numOfTokens) >= msg.value,"Ether value sent is not correct");
1604 
1605         mint(msg.sender, _numOfTokens);
1606     }
1607 
1608     /*
1609      * Function to mint new NFTs during the presale
1610      * It is payable. Amount is calculated as per (NFTPrice.mul(_numOfTokens))
1611      */
1612     function presaleMint(uint256 _numOfTokens, bytes32[] memory _proof) public payable {
1613         require(isActive, "Contract is not active");
1614         require(isPresaleActive, "Presale is not open yet");
1615         require(verify(_proof, bytes32(uint256(uint160(msg.sender)))), "Not whitelisted");
1616         require(totalSupply.add(_numOfTokens) <= MAX_NFT,"Purchase would exceed max public supply of NFTs");
1617         require(whiteListClaimed[msg.sender].add(_numOfTokens) <= WHITELIST_MAX_MINT, 'Purchase exceeds max whiteed');
1618         require(NFTPrice.mul(_numOfTokens) >= msg.value,"Ether value sent is not correct");
1619 
1620         mint(msg.sender, _numOfTokens);
1621         whiteListClaimed[msg.sender] = whiteListClaimed[msg.sender].add(_numOfTokens);
1622     }
1623 
1624     /*
1625      * Function to mint new NFTs for Free
1626      */
1627     function freeMint(uint256 _moodyApeTokenId, bytes32[] memory _proof) public payable{
1628         require(isActive, "Contract is not active");
1629         require(isFreeMintActive, "Free mint is not open yet");
1630         require(verify(_proof, sha256(abi.encodePacked(Strings.toString(_moodyApeTokenId)))), "Not whitelisted");
1631         require(!tokenIdUsedForGiveaway[_moodyApeTokenId], "Already claimed giveaway");
1632 
1633         MoodyApeInterface moodyContract = MoodyApeInterface(moodyApeContractAddress);
1634 
1635         require(moodyContract.balanceOf(msg.sender, _moodyApeTokenId) > 0, "You are not the owner of this NFT");
1636         require(totalSupply.add(1) <= MAX_NFT, "Purchase would exceed max public supply of NFTs");
1637 
1638         tokenIdUsedForGiveaway[_moodyApeTokenId] = true;
1639 
1640         mint(msg.sender, 1);
1641     }
1642 
1643     /*
1644      * Function to mint all NFTs for giveaway
1645      */
1646     function mintByOwner(address _to) public onlyOwner {
1647         mint(_to, 1);
1648     }
1649 
1650     /*
1651      * Function to mint all NFTs for giveaway
1652      */
1653     function mintMultipleByOwner(address[] memory _to) public onlyOwner {
1654         for (uint256 i = 0; i < _to.length; i++) {
1655             mint(_to[i], 1);
1656         }
1657     }
1658 
1659     // Set Root for whitelist
1660     function setRoot(uint256 _root) public onlyOwner {
1661         root = bytes32(_root);
1662     }
1663 
1664     // Verify MerkleProof
1665     function verify(bytes32[] memory proof, bytes32 leaf)
1666         public
1667         view
1668         returns (bool)
1669     {
1670         bytes32 computedHash = leaf;
1671 
1672         for (uint256 i = 0; i < proof.length; i++) {
1673             bytes32 proofElement = proof[i];
1674 
1675             if (computedHash <= proofElement) {
1676                 // Hash(current computed hash + current element of the proof)
1677                 computedHash = sha256(
1678                     abi.encodePacked(computedHash, proofElement)
1679                 );
1680             } else {
1681                 // Hash(current element of the proof + current computed hash)
1682                 computedHash = sha256(
1683                     abi.encodePacked(proofElement, computedHash)
1684                 );
1685             }
1686         }
1687 
1688         // Check if the computed hash (root) is equal to the provided root
1689         return computedHash == root;
1690     }
1691 }