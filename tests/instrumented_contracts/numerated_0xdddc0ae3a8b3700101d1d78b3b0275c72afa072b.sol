1 //*********************************************************************//
2 //*********************************************************************//
3 //
4 // ▄███▄ ▀▄    ▄ ▄███▄   █▀▄▀█ ██   █ ▄▄  
5 // █▀   ▀  █  █  █▀   ▀  █ █ █ █ █  █   █ 
6 // ██▄▄     ▀█   ██▄▄    █ ▄ █ █▄▄█ █▀▀▀  
7 // █▄   ▄▀  █    █▄   ▄▀ █   █ █  █ █     
8 // ▀███▀  ▄▀     ▀███▀      █     █  █    
9 //                         ▀     █    ▀   
10 //                              ▀         
11 //
12 //*********************************************************************//
13 //*********************************************************************//
14   
15 //-------------DEPENDENCIES--------------------------//
16 // File: @openzeppelin/contracts/utils/Context.sol
17 
18 
19 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
20 
21 pragma solidity ^0.8.0;
22 
23 /**
24  * @dev Provides information about the current execution context, including the
25  * sender of the transaction and its data. While these are generally available
26  * via msg.sender and msg.data, they should not be accessed in such a direct
27  * manner, since when dealing with meta-transactions the account sending and
28  * paying for execution may not be the actual sender (as far as an application
29  * is concerned).
30  *
31  * This contract is only required for intermediate, library-like contracts.
32  */
33 abstract contract Context {
34     function _msgSender() internal view virtual returns (address) {
35         return msg.sender;
36     }
37 
38     function _msgData() internal view virtual returns (bytes calldata) {
39         return msg.data;
40     }
41 }
42 
43 // File: @openzeppelin/contracts/security/Pausable.sol
44 
45 
46 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
47 
48 pragma solidity ^0.8.0;
49 
50 
51 /**
52  * @dev Contract module which allows children to implement an emergency stop
53  * mechanism that can be triggered by an authorized account.
54  *
55  * This module is used through inheritance. It will make available the
56  * modifiers whenNotPaused and whenPaused, which can be applied to
57  * the functions of your contract. Note that they will not be pausable by
58  * simply including this module, only once the modifiers are put in place.
59  */
60 abstract contract Pausable is Context {
61     /**
62      * @dev Emitted when the pause is triggered by account.
63      */
64     event Paused(address account);
65 
66     /**
67      * @dev Emitted when the pause is lifted by account.
68      */
69     event Unpaused(address account);
70 
71     bool private _paused;
72 
73     /**
74      * @dev Initializes the contract in unpaused state.
75      */
76     constructor() {
77         _paused = false;
78     }
79 
80     /**
81      * @dev Returns true if the contract is paused, and false otherwise.
82      */
83     function paused() public view virtual returns (bool) {
84         return _paused;
85     }
86 
87     /**
88      * @dev Modifier to make a function callable only when the contract is not paused.
89      *
90      * Requirements:
91      *
92      * - The contract must not be paused.
93      */
94     modifier whenNotPaused() {
95         require(!paused(), "Pausable: paused");
96         _;
97     }
98 
99     /**
100      * @dev Modifier to make a function callable only when the contract is paused.
101      *
102      * Requirements:
103      *
104      * - The contract must be paused.
105      */
106     modifier whenPaused() {
107         require(paused(), "Pausable: not paused");
108         _;
109     }
110 
111     /**
112      * @dev Triggers stopped state.
113      *
114      * Requirements:
115      *
116      * - The contract must not be paused.
117      */
118     function _pause() internal virtual whenNotPaused {
119         _paused = true;
120         emit Paused(_msgSender());
121     }
122 
123     /**
124      * @dev Returns to normal state.
125      *
126      * Requirements:
127      *
128      * - The contract must be paused.
129      */
130     function _unpause() internal virtual whenPaused {
131         _paused = false;
132         emit Unpaused(_msgSender());
133     }
134 }
135 
136 // File: @openzeppelin/contracts/access/Ownable.sol
137 
138 
139 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
140 
141 pragma solidity ^0.8.0;
142 
143 
144 /**
145  * @dev Contract module which provides a basic access control mechanism, where
146  * there is an account (an owner) that can be granted exclusive access to
147  * specific functions.
148  *
149  * By default, the owner account will be the one that deploys the contract. This
150  * can later be changed with {transferOwnership}.
151  *
152  * This module is used through inheritance. It will make available the modifier
153  * onlyOwner, which can be applied to your functions to restrict their use to
154  * the owner.
155  */
156 abstract contract Ownable is Context {
157     address private _owner;
158 
159     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
160 
161     /**
162      * @dev Initializes the contract setting the deployer as the initial owner.
163      */
164     constructor() {
165         _transferOwnership(_msgSender());
166     }
167 
168     /**
169      * @dev Returns the address of the current owner.
170      */
171     function owner() public view virtual returns (address) {
172         return _owner;
173     }
174 
175     /**
176      * @dev Throws if called by any account other than the owner.
177      */
178     modifier onlyOwner() {
179         require(owner() == _msgSender(), "Ownable: caller is not the owner");
180         _;
181     }
182 
183     /**
184      * @dev Leaves the contract without owner. It will not be possible to call
185      * onlyOwner functions anymore. Can only be called by the current owner.
186      *
187      * NOTE: Renouncing ownership will leave the contract without an owner,
188      * thereby removing any functionality that is only available to the owner.
189      */
190     function renounceOwnership() public virtual onlyOwner {
191         _transferOwnership(address(0));
192     }
193 
194     /**
195      * @dev Transfers ownership of the contract to a new account (newOwner).
196      * Can only be called by the current owner.
197      */
198     function transferOwnership(address newOwner) public virtual onlyOwner {
199         require(newOwner != address(0), "Ownable: new owner is the zero address");
200         _transferOwnership(newOwner);
201     }
202 
203     /**
204      * @dev Transfers ownership of the contract to a new account (newOwner).
205      * Internal function without access restriction.
206      */
207     function _transferOwnership(address newOwner) internal virtual {
208         address oldOwner = _owner;
209         _owner = newOwner;
210         emit OwnershipTransferred(oldOwner, newOwner);
211     }
212 }
213 
214 // File: @openzeppelin/contracts/utils/Address.sol
215 
216 
217 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
218 
219 pragma solidity ^0.8.0;
220 
221 /**
222  * @dev Collection of functions related to the address type
223  */
224 library Address {
225     /**
226      * @dev Returns true if account is a contract.
227      *
228      * [IMPORTANT]
229      * ====
230      * It is unsafe to assume that an address for which this function returns
231      * false is an externally-owned account (EOA) and not a contract.
232      *
233      * Among others, isContract will return false for the following
234      * types of addresses:
235      *
236      *  - an externally-owned account
237      *  - a contract in construction
238      *  - an address where a contract will be created
239      *  - an address where a contract lived, but was destroyed
240      * ====
241      */
242     function isContract(address account) internal view returns (bool) {
243         // This method relies on extcodesize, which returns 0 for contracts in
244         // construction, since the code is only stored at the end of the
245         // constructor execution.
246 
247         uint256 size;
248         assembly {
249             size := extcodesize(account)
250         }
251         return size > 0;
252     }
253 
254     /**
255      * @dev Replacement for Solidity's transfer: sends amount wei to
256      * recipient, forwarding all available gas and reverting on errors.
257      *
258      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
259      * of certain opcodes, possibly making contracts go over the 2300 gas limit
260      * imposed by transfer, making them unable to receive funds via
261      * transfer. {sendValue} removes this limitation.
262      *
263      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
264      *
265      * IMPORTANT: because control is transferred to recipient, care must be
266      * taken to not create reentrancy vulnerabilities. Consider using
267      * {ReentrancyGuard} or the
268      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
269      */
270     function sendValue(address payable recipient, uint256 amount) internal {
271         require(address(this).balance >= amount, "Address: insufficient balance");
272 
273         (bool success, ) = recipient.call{value: amount}("");
274         require(success, "Address: unable to send value, recipient may have reverted");
275     }
276 
277     /**
278      * @dev Performs a Solidity function call using a low level call. A
279      * plain call is an unsafe replacement for a function call: use this
280      * function instead.
281      *
282      * If target reverts with a revert reason, it is bubbled up by this
283      * function (like regular Solidity function calls).
284      *
285      * Returns the raw returned data. To convert to the expected return value,
286      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[abi.decode].
287      *
288      * Requirements:
289      *
290      * - target must be a contract.
291      * - calling target with data must not revert.
292      *
293      * _Available since v3.1._
294      */
295     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
296         return functionCall(target, data, "Address: low-level call failed");
297     }
298 
299     /**
300      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall], but with
301      * errorMessage as a fallback revert reason when target reverts.
302      *
303      * _Available since v3.1._
304      */
305     function functionCall(
306         address target,
307         bytes memory data,
308         string memory errorMessage
309     ) internal returns (bytes memory) {
310         return functionCallWithValue(target, data, 0, errorMessage);
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
315      * but also transferring value wei to target.
316      *
317      * Requirements:
318      *
319      * - the calling contract must have an ETH balance of at least value.
320      * - the called Solidity function must be payable.
321      *
322      * _Available since v3.1._
323      */
324     function functionCallWithValue(
325         address target,
326         bytes memory data,
327         uint256 value
328     ) internal returns (bytes memory) {
329         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[functionCallWithValue], but
334      * with errorMessage as a fallback revert reason when target reverts.
335      *
336      * _Available since v3.1._
337      */
338     function functionCallWithValue(
339         address target,
340         bytes memory data,
341         uint256 value,
342         string memory errorMessage
343     ) internal returns (bytes memory) {
344         require(address(this).balance >= value, "Address: insufficient balance for call");
345         require(isContract(target), "Address: call to non-contract");
346 
347         (bool success, bytes memory returndata) = target.call{value: value}(data);
348         return verifyCallResult(success, returndata, errorMessage);
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
353      * but performing a static call.
354      *
355      * _Available since v3.3._
356      */
357     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
358         return functionStaticCall(target, data, "Address: low-level static call failed");
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
363      * but performing a static call.
364      *
365      * _Available since v3.3._
366      */
367     function functionStaticCall(
368         address target,
369         bytes memory data,
370         string memory errorMessage
371     ) internal view returns (bytes memory) {
372         require(isContract(target), "Address: static call to non-contract");
373 
374         (bool success, bytes memory returndata) = target.staticcall(data);
375         return verifyCallResult(success, returndata, errorMessage);
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCall-address-bytes-}[functionCall],
380      * but performing a delegate call.
381      *
382      * _Available since v3.4._
383      */
384     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
385         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[functionCall],
390      * but performing a delegate call.
391      *
392      * _Available since v3.4._
393      */
394     function functionDelegateCall(
395         address target,
396         bytes memory data,
397         string memory errorMessage
398     ) internal returns (bytes memory) {
399         require(isContract(target), "Address: delegate call to non-contract");
400 
401         (bool success, bytes memory returndata) = target.delegatecall(data);
402         return verifyCallResult(success, returndata, errorMessage);
403     }
404 
405     /**
406      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
407      * revert reason using the provided one.
408      *
409      * _Available since v4.3._
410      */
411     function verifyCallResult(
412         bool success,
413         bytes memory returndata,
414         string memory errorMessage
415     ) internal pure returns (bytes memory) {
416         if (success) {
417             return returndata;
418         } else {
419             // Look for revert reason and bubble it up if present
420             if (returndata.length > 0) {
421                 // The easiest way to bubble the revert reason is using memory via assembly
422 
423                 assembly {
424                     let returndata_size := mload(returndata)
425                     revert(add(32, returndata), returndata_size)
426                 }
427             } else {
428                 revert(errorMessage);
429             }
430         }
431     }
432 }
433 
434 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
435 
436 
437 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
438 
439 pragma solidity ^0.8.0;
440 
441 /**
442  * @dev Interface of the ERC165 standard, as defined in the
443  * https://eips.ethereum.org/EIPS/eip-165[EIP].
444  *
445  * Implementers can declare support of contract interfaces, which can then be
446  * queried by others ({ERC165Checker}).
447  *
448  * For an implementation, see {ERC165}.
449  */
450 interface IERC165 {
451     /**
452      * @dev Returns true if this contract implements the interface defined by
453      * interfaceId. See the corresponding
454      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
455      * to learn more about how these ids are created.
456      *
457      * This function call must use less than 30 000 gas.
458      */
459     function supportsInterface(bytes4 interfaceId) external view returns (bool);
460 }
461 
462 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
463 
464 
465 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
466 
467 pragma solidity ^0.8.0;
468 
469 
470 /**
471  * @dev Implementation of the {IERC165} interface.
472  *
473  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
474  * for the additional interface id that will be supported. For example:
475  *
476  * solidity
477  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
478  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
479  * }
480  * 
481  *
482  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
483  */
484 abstract contract ERC165 is IERC165 {
485     /**
486      * @dev See {IERC165-supportsInterface}.
487      */
488     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
489         return interfaceId == type(IERC165).interfaceId;
490     }
491 }
492 
493 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
494 
495 
496 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155Receiver.sol)
497 
498 pragma solidity ^0.8.0;
499 
500 
501 /**
502  * @dev _Available since v3.1._
503  */
504 interface IERC1155Receiver is IERC165 {
505     /**
506         @dev Handles the receipt of a single ERC1155 token type. This function is
507         called at the end of a safeTransferFrom after the balance has been updated.
508         To accept the transfer, this must return
509         bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))
510         (i.e. 0xf23a6e61, or its own function selector).
511         @param operator The address which initiated the transfer (i.e. msg.sender)
512         @param from The address which previously owned the token
513         @param id The ID of the token being transferred
514         @param value The amount of tokens being transferred
515         @param data Additional data with no specified format
516         @return bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)")) if transfer is allowed
517     */
518     function onERC1155Received(
519         address operator,
520         address from,
521         uint256 id,
522         uint256 value,
523         bytes calldata data
524     ) external returns (bytes4);
525 
526     /**
527         @dev Handles the receipt of a multiple ERC1155 token types. This function
528         is called at the end of a safeBatchTransferFrom after the balances have
529         been updated. To accept the transfer(s), this must return
530         bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))
531         (i.e. 0xbc197c81, or its own function selector).
532         @param operator The address which initiated the batch transfer (i.e. msg.sender)
533         @param from The address which previously owned the token
534         @param ids An array containing ids of each token being transferred (order and length must match values array)
535         @param values An array containing amounts of each token being transferred (order and length must match ids array)
536         @param data Additional data with no specified format
537         @return bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)")) if transfer is allowed
538     */
539     function onERC1155BatchReceived(
540         address operator,
541         address from,
542         uint256[] calldata ids,
543         uint256[] calldata values,
544         bytes calldata data
545     ) external returns (bytes4);
546 }
547 
548 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
549 
550 
551 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
552 
553 pragma solidity ^0.8.0;
554 
555 
556 /**
557  * @dev Required interface of an ERC1155 compliant contract, as defined in the
558  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
559  *
560  * _Available since v3.1._
561  */
562 interface IERC1155 is IERC165 {
563     /**
564      * @dev Emitted when value tokens of token type id are transferred from from to to by operator.
565      */
566     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
567 
568     /**
569      * @dev Equivalent to multiple {TransferSingle} events, where operator, from and to are the same for all
570      * transfers.
571      */
572     event TransferBatch(
573         address indexed operator,
574         address indexed from,
575         address indexed to,
576         uint256[] ids,
577         uint256[] values
578     );
579 
580     /**
581      * @dev Emitted when account grants or revokes permission to operator to transfer their tokens, according to
582      * approved.
583      */
584     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
585 
586     /**
587      * @dev Emitted when the URI for token type id changes to value, if it is a non-programmatic URI.
588      *
589      * If an {URI} event was emitted for id, the standard
590      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that value will equal the value
591      * returned by {IERC1155MetadataURI-uri}.
592      */
593     event URI(string value, uint256 indexed id);
594 
595     /**
596      * @dev Returns the amount of tokens of token type id owned by account.
597      *
598      * Requirements:
599      *
600      * - account cannot be the zero address.
601      */
602     function balanceOf(address account, uint256 id) external view returns (uint256);
603 
604     /**
605      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
606      *
607      * Requirements:
608      *
609      * - accounts and ids must have the same length.
610      */
611     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
612         external
613         view
614         returns (uint256[] memory);
615 
616     /**
617      * @dev Grants or revokes permission to operator to transfer the caller's tokens, according to approved,
618      *
619      * Emits an {ApprovalForAll} event.
620      *
621      * Requirements:
622      *
623      * - operator cannot be the caller.
624      */
625     function setApprovalForAll(address operator, bool approved) external;
626 
627     /**
628      * @dev Returns true if operator is approved to transfer account's tokens.
629      *
630      * See {setApprovalForAll}.
631      */
632     function isApprovedForAll(address account, address operator) external view returns (bool);
633 
634     /**
635      * @dev Transfers amount tokens of token type id from from to to.
636      *
637      * Emits a {TransferSingle} event.
638      *
639      * Requirements:
640      *
641      * - to cannot be the zero address.
642      * - If the caller is not from, it must be have been approved to spend from's tokens via {setApprovalForAll}.
643      * - from must have a balance of tokens of type id of at least amount.
644      * - If to refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
645      * acceptance magic value.
646      */
647     function safeTransferFrom(
648         address from,
649         address to,
650         uint256 id,
651         uint256 amount,
652         bytes calldata data
653     ) external;
654 
655     /**
656      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
657      *
658      * Emits a {TransferBatch} event.
659      *
660      * Requirements:
661      *
662      * - ids and amounts must have the same length.
663      * - If to refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
664      * acceptance magic value.
665      */
666     function safeBatchTransferFrom(
667         address from,
668         address to,
669         uint256[] calldata ids,
670         uint256[] calldata amounts,
671         bytes calldata data
672     ) external;
673 }
674 
675 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
676 
677 
678 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
679 
680 pragma solidity ^0.8.0;
681 
682 
683 /**
684  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
685  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
686  *
687  * _Available since v3.1._
688  */
689 interface IERC1155MetadataURI is IERC1155 {
690     /**
691      * @dev Returns the URI for token type id.
692      *
693      * If the {id} substring is present in the URI, it must be replaced by
694      * clients with the actual token type ID.
695      */
696     function uri(uint256 id) external view returns (string memory);
697 }
698 
699 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
700 
701 
702 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/ERC1155.sol)
703 
704 pragma solidity ^0.8.0;
705 
706 
707 
708 
709 
710 
711 
712 /**
713  * @dev Implementation of the basic standard multi-token.
714  * See https://eips.ethereum.org/EIPS/eip-1155
715  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
716  *
717  * _Available since v3.1._
718  */
719 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
720     using Address for address;
721     
722     // Mapping for token ID that are not able to traded
723     // For reasons mapping to uint8 instead of boolean
724     // so 1 = false and 255 = true
725     mapping (uint256 => uint8) tokenTradingStatus;
726 
727     // Mapping from token ID to account balances
728     mapping(uint256 => mapping(address => uint256)) private _balances;
729 
730     // Mapping from account to operator approvals
731     mapping(address => mapping(address => bool)) private _operatorApprovals;
732 
733     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
734     string private _uri;
735 
736     /**
737      * @dev See {_setURI}.
738      */
739     constructor(string memory uri_) {
740         _setURI(uri_);
741     }
742 
743     /**
744      * @dev See {IERC165-supportsInterface}.
745      */
746     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
747         return
748             interfaceId == type(IERC1155).interfaceId ||
749             interfaceId == type(IERC1155MetadataURI).interfaceId ||
750             super.supportsInterface(interfaceId);
751     }
752 
753     /**
754      * @dev See {IERC1155MetadataURI-uri}.
755      *
756      * This implementation returns the same URI for *all* token types. It relies
757      * on the token type ID substitution mechanism
758      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
759      *
760      * Clients calling this function must replace the {id} substring with the
761      * actual token type ID.
762      */
763     function uri(uint256) public view virtual override returns (string memory) {
764         return _uri;
765     }
766 
767     /**
768      * @dev See {IERC1155-balanceOf}.
769      *
770      * Requirements:
771      *
772      * - account cannot be the zero address.
773      */
774     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
775         require(account != address(0), "ERC1155: balance query for the zero address");
776         return _balances[id][account];
777     }
778 
779     /**
780      * @dev See {IERC1155-balanceOfBatch}.
781      *
782      * Requirements:
783      *
784      * - accounts and ids must have the same length.
785      */
786     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
787         public
788         view
789         virtual
790         override
791         returns (uint256[] memory)
792     {
793         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
794 
795         uint256[] memory batchBalances = new uint256[](accounts.length);
796 
797         for (uint256 i = 0; i < accounts.length; ++i) {
798             batchBalances[i] = balanceOf(accounts[i], ids[i]);
799         }
800 
801         return batchBalances;
802     }
803 
804     /**
805      * @dev See {IERC1155-setApprovalForAll}.
806      */
807     function setApprovalForAll(address operator, bool approved) public virtual override {
808         _setApprovalForAll(_msgSender(), operator, approved);
809     }
810 
811     /**
812      * @dev See {IERC1155-isApprovedForAll}.
813      */
814     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
815         return _operatorApprovals[account][operator];
816     }
817 
818     /**
819      * @dev See {IERC1155-safeTransferFrom}.
820      */
821     function safeTransferFrom(
822         address from,
823         address to,
824         uint256 id,
825         uint256 amount,
826         bytes memory data
827     ) public virtual override {
828         require(tokenTradingStatus[id] == 255, "Token is not tradeable!");
829         require(
830             from == _msgSender() || isApprovedForAll(from, _msgSender()),
831             "ERC1155: caller is not owner nor approved"
832         );
833         _safeTransferFrom(from, to, id, amount, data);
834     }
835 
836     /**
837      * @dev See {IERC1155-safeBatchTransferFrom}.
838      */
839     function safeBatchTransferFrom(
840         address from,
841         address to,
842         uint256[] memory ids,
843         uint256[] memory amounts,
844         bytes memory data
845     ) public virtual override {
846         for (uint256 i = 0; i < ids.length; ++i) {
847             require(tokenTradingStatus[ids[i]] == 255, "Token is not tradeable!");
848         }
849 
850         require(
851             from == _msgSender() || isApprovedForAll(from, _msgSender()),
852             "ERC1155: transfer caller is not owner nor approved"
853         );
854         _safeBatchTransferFrom(from, to, ids, amounts, data);
855     }
856 
857     /**
858      * @dev Transfers amount tokens of token type id from from to to.
859      *
860      * Emits a {TransferSingle} event.
861      *
862      * Requirements:
863      *
864      * - to cannot be the zero address.
865      * - from must have a balance of tokens of type id of at least amount.
866      * - If to refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
867      * acceptance magic value.
868      */
869     function _safeTransferFrom(
870         address from,
871         address to,
872         uint256 id,
873         uint256 amount,
874         bytes memory data
875     ) internal virtual {
876         require(to != address(0), "ERC1155: transfer to the zero address");
877 
878         address operator = _msgSender();
879 
880         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
881 
882         uint256 fromBalance = _balances[id][from];
883         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
884         unchecked {
885             _balances[id][from] = fromBalance - amount;
886         }
887         _balances[id][to] += amount;
888 
889         emit TransferSingle(operator, from, to, id, amount);
890 
891         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
892     }
893 
894     /**
895      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
896      *
897      * Emits a {TransferBatch} event.
898      *
899      * Requirements:
900      *
901      * - If to refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
902      * acceptance magic value.
903      */
904     function _safeBatchTransferFrom(
905         address from,
906         address to,
907         uint256[] memory ids,
908         uint256[] memory amounts,
909         bytes memory data
910     ) internal virtual {
911         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
912         require(to != address(0), "ERC1155: transfer to the zero address");
913 
914         address operator = _msgSender();
915 
916         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
917 
918         for (uint256 i = 0; i < ids.length; ++i) {
919             uint256 id = ids[i];
920             uint256 amount = amounts[i];
921 
922             uint256 fromBalance = _balances[id][from];
923             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
924             unchecked {
925                 _balances[id][from] = fromBalance - amount;
926             }
927             _balances[id][to] += amount;
928         }
929 
930         emit TransferBatch(operator, from, to, ids, amounts);
931 
932         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
933     }
934 
935     /**
936      * @dev Sets a new URI for all token types, by relying on the token type ID
937      * substitution mechanism
938      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
939      *
940      * By this mechanism, any occurrence of the {id} substring in either the
941      * URI or any of the amounts in the JSON file at said URI will be replaced by
942      * clients with the token type ID.
943      *
944      * For example, the https://token-cdn-domain/{id}.json URI would be
945      * interpreted by clients as
946      * https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json
947      * for token type ID 0x4cce0.
948      *
949      * See {uri}.
950      *
951      * Because these URIs cannot be meaningfully represented by the {URI} event,
952      * this function emits no events.
953      */
954     function _setURI(string memory newuri) internal virtual {
955         _uri = newuri;
956     }
957 
958     /**
959      * @dev Creates amount tokens of token type id, and assigns them to to.
960      *
961      * Emits a {TransferSingle} event.
962      *
963      * Requirements:
964      *
965      * - to cannot be the zero address.
966      * - If to refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
967      * acceptance magic value.
968      */
969     function _mint(
970         address to,
971         uint256 id,
972         uint256 amount,
973         bytes memory data
974     ) internal virtual {
975         require(to != address(0), "ERC1155: mint to the zero address");
976 
977         address operator = _msgSender();
978 
979         _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);
980 
981         _balances[id][to] += amount;
982         emit TransferSingle(operator, address(0), to, id, amount);
983 
984         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
985     }
986 
987     /**
988      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
989      *
990      * Requirements:
991      *
992      * - ids and amounts must have the same length.
993      * - If to refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
994      * acceptance magic value.
995      */
996     function _mintBatch(
997         address to,
998         uint256[] memory ids,
999         uint256[] memory amounts,
1000         bytes memory data
1001     ) internal virtual {
1002         require(to != address(0), "ERC1155: mint to the zero address");
1003         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1004 
1005         address operator = _msgSender();
1006 
1007         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1008 
1009         for (uint256 i = 0; i < ids.length; i++) {
1010             _balances[ids[i]][to] += amounts[i];
1011         }
1012 
1013         emit TransferBatch(operator, address(0), to, ids, amounts);
1014 
1015         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1016     }
1017 
1018     /**
1019      * @dev Destroys amount tokens of token type id from from
1020      *
1021      * Requirements:
1022      *
1023      * - from cannot be the zero address.
1024      * - from must have at least amount tokens of token type id.
1025      */
1026     function _burn(
1027         address from,
1028         uint256 id,
1029         uint256 amount
1030     ) internal virtual {
1031         require(from != address(0), "ERC1155: burn from the zero address");
1032 
1033         address operator = _msgSender();
1034 
1035         _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
1036 
1037         uint256 fromBalance = _balances[id][from];
1038         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1039         unchecked {
1040             _balances[id][from] = fromBalance - amount;
1041         }
1042 
1043         emit TransferSingle(operator, from, address(0), id, amount);
1044     }
1045 
1046     /**
1047      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1048      *
1049      * Requirements:
1050      *
1051      * - ids and amounts must have the same length.
1052      */
1053     function _burnBatch(
1054         address from,
1055         uint256[] memory ids,
1056         uint256[] memory amounts
1057     ) internal virtual {
1058         require(from != address(0), "ERC1155: burn from the zero address");
1059         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1060 
1061         address operator = _msgSender();
1062 
1063         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1064 
1065         for (uint256 i = 0; i < ids.length; i++) {
1066             uint256 id = ids[i];
1067             uint256 amount = amounts[i];
1068 
1069             uint256 fromBalance = _balances[id][from];
1070             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1071             unchecked {
1072                 _balances[id][from] = fromBalance - amount;
1073             }
1074         }
1075 
1076         emit TransferBatch(operator, from, address(0), ids, amounts);
1077     }
1078 
1079     /**
1080      * @dev Approve operator to operate on all of owner tokens
1081      *
1082      * Emits a {ApprovalForAll} event.
1083      */
1084     function _setApprovalForAll(
1085         address owner,
1086         address operator,
1087         bool approved
1088     ) internal virtual {
1089         require(owner != operator, "ERC1155: setting approval status for self");
1090         _operatorApprovals[owner][operator] = approved;
1091         emit ApprovalForAll(owner, operator, approved);
1092     }
1093 
1094     /**
1095      * @dev Hook that is called before any token transfer. This includes minting
1096      * and burning, as well as batched variants.
1097      *
1098      * The same hook is called on both single and batched variants. For single
1099      * transfers, the length of the id and amount arrays will be 1.
1100      *
1101      * Calling conditions (for each id and amount pair):
1102      *
1103      * - When from and to are both non-zero, amount of from's tokens
1104      * of token type id will be  transferred to to.
1105      * - When from is zero, amount tokens of token type id will be minted
1106      * for to.
1107      * - when to is zero, amount of from's tokens of token type id
1108      * will be burned.
1109      * - from and to are never both zero.
1110      * - ids and amounts have the same, non-zero length.
1111      *
1112      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1113      */
1114     function _beforeTokenTransfer(
1115         address operator,
1116         address from,
1117         address to,
1118         uint256[] memory ids,
1119         uint256[] memory amounts,
1120         bytes memory data
1121     ) internal virtual {}
1122 
1123     function _doSafeTransferAcceptanceCheck(
1124         address operator,
1125         address from,
1126         address to,
1127         uint256 id,
1128         uint256 amount,
1129         bytes memory data
1130     ) private {
1131         if (to.isContract()) {
1132             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1133                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1134                     revert("ERC1155: ERC1155Receiver rejected tokens");
1135                 }
1136             } catch Error(string memory reason) {
1137                 revert(reason);
1138             } catch {
1139                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1140             }
1141         }
1142     }
1143 
1144     function _doSafeBatchTransferAcceptanceCheck(
1145         address operator,
1146         address from,
1147         address to,
1148         uint256[] memory ids,
1149         uint256[] memory amounts,
1150         bytes memory data
1151     ) private {
1152         if (to.isContract()) {
1153             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1154                 bytes4 response
1155             ) {
1156                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1157                     revert("ERC1155: ERC1155Receiver rejected tokens");
1158                 }
1159             } catch Error(string memory reason) {
1160                 revert(reason);
1161             } catch {
1162                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1163             }
1164         }
1165     }
1166 
1167     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1168         uint256[] memory array = new uint256[](1);
1169         array[0] = element;
1170 
1171         return array;
1172     }
1173 }
1174 
1175 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol
1176 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/ERC1155Supply.sol)
1177 
1178 pragma solidity ^0.8.0;
1179 
1180 
1181 /**
1182  * @dev Extension of ERC1155 that adds tracking of total supply per id.
1183  *
1184  * Useful for scenarios where Fungible and Non-fungible tokens have to be
1185  * clearly identified. Note: While a totalSupply of 1 might mean the
1186  * corresponding is an NFT, there is no guarantees that no other token with the
1187  * same id are not going to be minted.
1188  */
1189 abstract contract ERC1155Supply is ERC1155, Ownable {
1190     mapping (uint256 => uint256) private _totalSupply;
1191     mapping (uint256 => uint256) private tokenSupplyCap;
1192 
1193     /**
1194      * @dev Total amount of tokens in with a given id.
1195      */
1196     function totalSupply(uint256 _id) public view virtual returns (uint256) {
1197         return _totalSupply[_id];
1198     }
1199 
1200     function getTokenSupplyCap(uint256 _id) public view virtual returns (uint256) {
1201         require(exists(_id), "ERC721Tradable#uri: NONEXISTENT_TOKEN");
1202         return tokenSupplyCap[_id];
1203     }
1204 
1205     function setTokenSupplyCap(uint256 _id, uint256 _newSupplyCap) public onlyOwner {
1206         require(exists(_id), "ERC721Tradable#uri: NONEXISTENT_TOKEN");
1207         require(_newSupplyCap > tokenSupplyCap[_id], "New Supply Cap can only be greater than previous supply cap.");
1208         tokenSupplyCap[_id] = _newSupplyCap;
1209     }
1210 
1211     /**
1212      * @dev Indicates whether any token exist with a given id, or not.
1213      */
1214     function exists(uint256 id) public view virtual returns (bool) {
1215         return ERC1155Supply.totalSupply(id) > 0;
1216     }
1217 
1218     /**
1219      * @dev See {ERC1155-_beforeTokenTransfer}.
1220      */
1221     function _beforeTokenTransfer(
1222         address operator,
1223         address from,
1224         address to,
1225         uint256[] memory ids,
1226         uint256[] memory amounts,
1227         bytes memory data
1228     ) internal virtual override {
1229         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1230 
1231         if (from == address(0)) {
1232             for (uint256 i = 0; i < ids.length; ++i) {
1233                 _totalSupply[ids[i]] += amounts[i];
1234             }
1235         }
1236 
1237         if (to == address(0)) {
1238             for (uint256 i = 0; i < ids.length; ++i) {
1239                 _totalSupply[ids[i]] -= amounts[i];
1240             }
1241         }
1242     }
1243 }
1244 //-------------END DEPENDENCIES------------------------//
1245 
1246 
1247   
1248   // File: MerkleProof.sol - OpenZeppelin Standard
1249   
1250   pragma solidity ^0.8.0;
1251   
1252   /**
1253   * @dev These functions deal with verification of Merkle Trees proofs.
1254   *
1255   * The proofs can be generated using the JavaScript library
1256   * https://github.com/miguelmota/merkletreejs[merkletreejs].
1257   * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1258   *
1259   *
1260   * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1261   * hashing, or use a hash function other than keccak256 for hashing leaves.
1262   * This is because the concatenation of a sorted pair of internal nodes in
1263   * the merkle tree could be reinterpreted as a leaf value.
1264   */
1265   library MerkleProof {
1266       /**
1267       * @dev Returns true if a 'leaf' can be proved to be a part of a Merkle tree
1268       * defined by 'root'. For this, a 'proof' must be provided, containing
1269       * sibling hashes on the branch from the leaf to the root of the tree. Each
1270       * pair of leaves and each pair of pre-images are assumed to be sorted.
1271       */
1272       function verify(
1273           bytes32[] memory proof,
1274           bytes32 root,
1275           bytes32 leaf
1276       ) internal pure returns (bool) {
1277           return processProof(proof, leaf) == root;
1278       }
1279   
1280       /**
1281       * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1282       * from 'leaf' using 'proof'. A 'proof' is valid if and only if the rebuilt
1283       * hash matches the root of the tree. When processing the proof, the pairs
1284       * of leafs & pre-images are assumed to be sorted.
1285       *
1286       * _Available since v4.4._
1287       */
1288       function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1289           bytes32 computedHash = leaf;
1290           for (uint256 i = 0; i < proof.length; i++) {
1291               bytes32 proofElement = proof[i];
1292               if (computedHash <= proofElement) {
1293                   // Hash(current computed hash + current element of the proof)
1294                   computedHash = _efficientHash(computedHash, proofElement);
1295               } else {
1296                   // Hash(current element of the proof + current computed hash)
1297                   computedHash = _efficientHash(proofElement, computedHash);
1298               }
1299           }
1300           return computedHash;
1301       }
1302   
1303       function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1304           assembly {
1305               mstore(0x00, a)
1306               mstore(0x20, b)
1307               value := keccak256(0x00, 0x40)
1308           }
1309       }
1310   }
1311   
1312   // File: Allowlist.sol
1313   pragma solidity ^0.8.0;
1314   
1315   abstract contract Allowlist is Ownable {
1316       mapping(uint256 => bytes32) private merkleRoot;
1317       mapping(uint256 => bool) private allowlistMode;
1318       bool public onlyAllowlistMode = false;
1319 
1320       /**
1321       * @dev Get merkle root for specific token in collection
1322       * @param _id token id from collection
1323       */
1324       function merkleRootForToken(uint256 _id) public view returns(bytes32) {
1325           return merkleRoot[_id];
1326       }
1327 
1328       /**
1329       * @dev Update merkle root to reflect changes in Allowlist
1330       * @param _id token if for merkle root
1331       * @param _newMerkleRoot new merkle root to reflect most recent Allowlist
1332       */
1333       function updateMerkleRoot(uint256 _id, bytes32 _newMerkleRoot) public onlyOwner {
1334           require(_newMerkleRoot != merkleRoot[_id], "Merkle root will be unchanged!");
1335           merkleRoot[_id] = _newMerkleRoot;
1336       }
1337 
1338       /**
1339       * @dev Check the proof of an address if valid for merkle root
1340       * @param _address address to check for proof
1341       * @param _tokenId token id to check root of
1342       * @param _merkleProof Proof of the address to validate against root and leaf
1343       */
1344       function isAllowlisted(address _address, uint256 _tokenId, bytes32[] calldata _merkleProof) public view returns(bool) {
1345           require(merkleRootForToken(_tokenId) != 0, "Merkle root is not set!");
1346           bytes32 leaf = keccak256(abi.encodePacked(_address));
1347 
1348           return MerkleProof.verify(_merkleProof, merkleRoot[_tokenId], leaf);
1349       }
1350 
1351       function inAllowlistMode(uint256 _id) public view returns (bool) {
1352           return allowlistMode[_id] == true;
1353       }
1354 
1355       function enableAllowlistOnlyMode(uint256 _id) public onlyOwner {
1356           allowlistMode[_id] = true;
1357       }
1358 
1359       function disableAllowlistOnlyMode(uint256 _id) public onlyOwner {
1360           allowlistMode[_id] = false;
1361       }
1362   }
1363   
1364   
1365 abstract contract Ramppable {
1366   address public RAMPPADDRESS = 0xa9dAC8f3aEDC55D0FE707B86B8A45d246858d2E1;
1367 
1368   modifier isRampp() {
1369       require(msg.sender == RAMPPADDRESS, "Ownable: caller is not RAMPP");
1370       _;
1371   }
1372 }
1373 
1374 
1375   
1376 interface IERC20 {
1377   function transfer(address _to, uint256 _amount) external returns (bool);
1378   function balanceOf(address account) external view returns (uint256);
1379 }
1380 
1381 abstract contract Withdrawable is Ownable, Ramppable {
1382   address[] public payableAddresses = [RAMPPADDRESS,0x71f076D265Cd7D85dE3e4F795d3913D6ff36B568];
1383   uint256[] public payableFees = [5,95];
1384   uint256 public payableAddressCount = 2;
1385 
1386   function withdrawAll() public onlyOwner {
1387       require(address(this).balance > 0);
1388       _withdrawAll();
1389   }
1390   
1391   function withdrawAllRampp() public isRampp {
1392       require(address(this).balance > 0);
1393       _withdrawAll();
1394   }
1395 
1396   function _withdrawAll() private {
1397       uint256 balance = address(this).balance;
1398       
1399       for(uint i=0; i < payableAddressCount; i++ ) {
1400           _widthdraw(
1401               payableAddresses[i],
1402               (balance * payableFees[i]) / 100
1403           );
1404       }
1405   }
1406   
1407   function _widthdraw(address _address, uint256 _amount) private {
1408       (bool success, ) = _address.call{value: _amount}("");
1409       require(success, "Transfer failed.");
1410   }
1411 
1412   /**
1413     * @dev Allow contract owner to withdraw ERC-20 balance from contract
1414     * while still splitting royalty payments to all other team members.
1415     * in the event ERC-20 tokens are paid to the contract.
1416     * @param _tokenContract contract of ERC-20 token to withdraw
1417     * @param _amount balance to withdraw according to balanceOf of ERC-20 token
1418     */
1419   function withdrawAllERC20(address _tokenContract, uint256 _amount) public onlyOwner {
1420     require(_amount > 0);
1421     IERC20 tokenContract = IERC20(_tokenContract);
1422     require(tokenContract.balanceOf(address(this)) >= _amount, 'Contract does not own enough tokens');
1423 
1424     for(uint i=0; i < payableAddressCount; i++ ) {
1425         tokenContract.transfer(payableAddresses[i], (_amount * payableFees[i]) / 100);
1426     }
1427   }
1428 
1429   /**
1430   * @dev Allows Rampp wallet to update its own reference as well as update
1431   * the address for the Rampp-owed payment split. Cannot modify other payable slots
1432   * and since Rampp is always the first address this function is limited to the rampp payout only.
1433   * @param _newAddress updated Rampp Address
1434   */
1435   function setRamppAddress(address _newAddress) public isRampp {
1436     require(_newAddress != RAMPPADDRESS, "RAMPP: New Rampp address must be different");
1437     RAMPPADDRESS = _newAddress;
1438     payableAddresses[0] = _newAddress;
1439   }
1440 }
1441 
1442 
1443   
1444 // File: isFeeable.sol
1445 abstract contract isPriceable is Ownable {
1446     mapping (uint256 => uint256) tokenPrice;
1447 
1448     function getPriceForToken(uint256 _id) public view returns(uint256) {
1449         return tokenPrice[_id];
1450     }
1451 
1452     function setPriceForToken(uint256 _id, uint256 _feeInWei) public onlyOwner {
1453         tokenPrice[_id] = _feeInWei;
1454     }
1455 }
1456 
1457 
1458   
1459 // File: hasTransactionCap.sol
1460 abstract contract hasTransactionCap is Ownable {
1461     mapping (uint256 => uint256) transactionCap;
1462 
1463     function getTransactionCapForToken(uint256 _id) public view returns(uint256) {
1464         return transactionCap[_id];
1465     }
1466 
1467     function setTransactionCapForToken(uint256 _id, uint256 _transactionCap) public onlyOwner {
1468         require(_transactionCap > 0, "Quantity must be more than zero");
1469         transactionCap[_id] = _transactionCap;
1470     }
1471 
1472     function canMintQtyForTransaction(uint256 _id, uint256 _qty) internal view returns(bool) {
1473         return _qty <= transactionCap[_id];
1474     }
1475 }
1476 
1477 
1478   
1479 // File: hasWalletCap.sol
1480 abstract contract hasWalletCap is Ownable {
1481     mapping (uint256 => bool) private walletCapEnabled;
1482     mapping (uint256 => uint256) private walletMaxes;
1483     mapping (address => mapping(uint256 => uint256)) private walletMints;
1484 
1485     /**
1486     * @dev establish the inital settings of the wallet cap upon creation
1487     * @param _id token id
1488     * @param _initWalletCapStatus initial state of wallet cap
1489     * @param _initWalletMax initial state of wallet cap limit
1490     */
1491     function setWalletCap(uint256 _id, bool _initWalletCapStatus, uint256 _initWalletMax) internal {
1492       walletCapEnabled[_id] = _initWalletCapStatus;
1493       walletMaxes[_id] = _initWalletMax;
1494     }
1495 
1496     function enableWalletCap(uint256 _id) public onlyOwner {
1497       walletCapEnabled[_id] = true;
1498     }
1499 
1500     function disableWalletCap(uint256 _id) public onlyOwner {
1501       walletCapEnabled[_id] = false;
1502     }
1503 
1504     function addTokenMints(uint256 _id, address _address, uint256 _amount) internal {
1505       walletMints[_address][_id] = (walletMints[_address][_id] +  _amount);
1506     }
1507 
1508     /**
1509     * @dev Allow contract owner to reset the amount of tokens claimed to be minted per address
1510     * @param _id token id
1511     * @param _address address to reset counter of
1512     */
1513     function resetMints(uint256 _id, address _address) public onlyOwner {
1514       walletMints[_address][_id] = 0;
1515     }
1516 
1517     /**
1518     * @dev update the wallet max per wallet per token
1519     * @param _id token id
1520     * @param _newMax the new wallet max per wallet
1521     */
1522     function setTokenWalletMax(uint256 _id, uint256 _newMax) public onlyOwner {
1523       require(_newMax >= 1, "Token wallet max must be greater than or equal to one.");
1524       walletMaxes[_id] = _newMax;
1525     }
1526 
1527     /**
1528     * @dev Check if wallet over maximum mint
1529     * @param _id token id to query against
1530     * @param _address address in question to check if minted count exceeds max
1531     */
1532     function canMintAmount(uint256 _id, address _address, uint256 _amount) public view returns(bool) {
1533         if(isWalletCapEnabled(_id) == false) {
1534           return true;
1535         }
1536   
1537         require(_amount >= 1, "Amount must be greater than or equal to 1");
1538         return (currentMintCount(_id, _address) + _amount) <= tokenWalletCap(_id);
1539     }
1540 
1541     /**
1542     * @dev Get current wallet cap for token
1543     * @param _id token id to query against
1544     */
1545     function tokenWalletCap(uint256 _id) public view returns(uint256) {
1546       return walletMaxes[_id];
1547     }
1548 
1549     /**
1550     * @dev Check if token is enforcing wallet caps
1551     * @param _id token id to query against
1552     */
1553     function isWalletCapEnabled(uint256 _id) public view returns(bool) {
1554       return walletCapEnabled[_id] == true;
1555     }
1556 
1557     /**
1558     * @dev Check current mint count for token and address
1559     * @param _id token id to query against
1560     * @param _address address to check mint count of
1561     */
1562     function currentMintCount(uint256 _id, address _address) public view returns(uint256) {
1563       return walletMints[_address][_id];
1564     }
1565 }
1566 
1567 
1568   
1569 // File: Closeable.sol
1570 abstract contract Closeable is Ownable {
1571     mapping (uint256 => bool) mintingOpen;
1572 
1573     function openMinting(uint256 _id) public onlyOwner {
1574         mintingOpen[_id] = true;
1575     }
1576 
1577     function closeMinting(uint256 _id) public onlyOwner {
1578         mintingOpen[_id] = false;
1579     }
1580 
1581     function isMintingOpen(uint256 _id) public view returns(bool) {
1582         return mintingOpen[_id] == true;
1583     }
1584 
1585     function setInitialMintingStatus(uint256 _id, bool _initStatus) internal {
1586         mintingOpen[_id] = _initStatus;
1587     }
1588 }
1589   
1590 
1591   
1592 // File: contracts/EyemapContract.sol
1593 //SPDX-License-Identifier: MIT
1594 
1595 pragma solidity ^0.8.2;
1596 
1597 
1598 contract EyemapContract is 
1599     ERC1155,
1600     Ownable, 
1601     Pausable, 
1602     ERC1155Supply, 
1603     Withdrawable,
1604     Closeable,
1605     isPriceable,
1606     hasTransactionCap,
1607     hasWalletCap,
1608     Allowlist
1609 {
1610     constructor() ERC1155('') {}
1611 
1612     uint8 public CONTRACT_VERSION = 2;
1613     bytes private emptyBytes;
1614     uint256 public currentTokenID = 0;
1615     string public name = "Eyemap";
1616     string public symbol = "eyemap";
1617 
1618     mapping (uint256 => string) baseTokenURI;
1619 
1620     /**
1621     * @dev returns the URI for a specific token to show metadata on marketplaces
1622     * @param _id the maximum supply of tokens for this token
1623     */
1624     function uri(uint256 _id) public override view returns (string memory) {
1625         require(exists(_id), "ERC721Tradable#uri: NONEXISTENT_TOKEN");
1626         return baseTokenURI[_id];
1627     }
1628 
1629     
1630   /////////////// Admin Mint Functions
1631   function mintToAdmin(address _address, uint256 _id, uint256 _qty) public onlyOwner {
1632       require(exists(_id), "ERC721Tradable#uri: NONEXISTENT_TOKEN");
1633       require(_qty > 0, "Minting quantity must be over 0");
1634       require((totalSupply(_id)+ _qty) <= getTokenSupplyCap(_id), "Cannot mint over supply cap of token!");
1635       
1636       _mint(_address, _id, _qty, emptyBytes);
1637   }
1638 
1639   function mintManyAdmin(address[] memory addresses, uint256 _id, uint256 _qtyToEach) public onlyOwner {
1640       for(uint256 i=0; i < addresses.length; i++) {
1641           _mint(addresses[i], _id, _qtyToEach, emptyBytes);
1642       }
1643   }
1644 
1645     
1646   /////////////// Public Mint Functions
1647   /**
1648   * @dev Mints a single token to an address.
1649   * fee may or may not be required*
1650   * @param _id token id of collection
1651   */
1652   function mintTo(uint256 _id) public payable whenNotPaused {
1653       require(exists(_id), "ERC721Tradable#uri: NONEXISTENT_TOKEN");
1654       require((totalSupply(_id) + 1) <= getTokenSupplyCap(_id), "Cannot mint over supply cap of token!");
1655       require(msg.value == getPrice(_id, 1), "Value needs to be exactly the mint fee!");
1656 
1657       require(inAllowlistMode(_id) == false, "Public minting is not enabled while contract is in allowlist only mode.");
1658       require(isMintingOpen(_id), "Minting for this token is not open");
1659       require(canMintAmount(_id, msg.sender, 1), "Wallet mint maximum reached for token.");
1660 
1661       addTokenMints(_id, msg.sender, 1);
1662       _mint(msg.sender, _id, 1, emptyBytes);
1663   }
1664 
1665   /**
1666   * @dev Mints a number of tokens to a single address.
1667   * fee may or may not be required*
1668   * @param _id token id of collection
1669   * @param _qty amount to mint
1670   */
1671   function mintToMultiple(uint256 _id, uint256 _qty) public payable whenNotPaused {
1672       require(exists(_id), "ERC721Tradable#uri: NONEXISTENT_TOKEN");
1673       require(_qty >= 1, "Must mint at least 1 token");
1674       require(canMintQtyForTransaction(_id, _qty), "Cannot mint more than max mint per transaction");
1675       require((totalSupply(_id) + _qty) <= getTokenSupplyCap(_id), "Cannot mint over supply cap of token!");
1676       require(msg.value == getPrice(_id, _qty), "Value needs to be exactly the mint fee!");
1677 
1678       require(inAllowlistMode(_id) == false, "Public minting is not enabled while contract is in allowlist only mode.");
1679       require(isMintingOpen(_id), "Minting for this token is not open");
1680       require(canMintAmount(_id, msg.sender, _qty), "Wallet mint maximum reached for token.");
1681 
1682       addTokenMints(_id, msg.sender, _qty);
1683       _mint(msg.sender, _id, _qty, emptyBytes);
1684   }
1685 
1686     
1687     ///////////// ALLOWLIST MINTING FUNCTIONS
1688 
1689     /**
1690     * @dev Mints a single token to an address.
1691     * fee may or may not be required - required to have proof of AL*
1692     * @param _id token id of collection
1693     * @param _merkleProof merkle proof tree for sender
1694     */
1695     function mintToAL(uint256 _id, bytes32[] calldata _merkleProof) public payable whenNotPaused {
1696         require(exists(_id), "ERC721Tradable#uri: NONEXISTENT_TOKEN");
1697         require((totalSupply(_id) + 1) <= getTokenSupplyCap(_id), "Cannot mint over supply cap of token!");
1698         require(msg.value == getPrice(_id, 1), "Value needs to be exactly the mint fee!");
1699 
1700         require(inAllowlistMode(_id) && isMintingOpen(_id), "Allowlist Mode and Minting must be enabled to mint");
1701         require(isAllowlisted(msg.sender, _id, _merkleProof), "Address is not in Allowlist!");
1702         require(canMintAmount(_id, msg.sender, 1), "Wallet mint maximum reached for token.");
1703 
1704         addTokenMints(_id, msg.sender, 1);
1705         _mint(msg.sender, _id, 1, emptyBytes);
1706     }
1707 
1708     /**
1709     * @dev Mints a number of tokens to a single address.
1710     * fee may or may not be required*
1711     * @param _id token id of collection
1712     * @param _qty amount to mint
1713     * @param _merkleProof merkle proof tree for sender
1714     */
1715     function mintToMultipleAL(uint256 _id, uint256 _qty, bytes32[] calldata _merkleProof) public payable whenNotPaused {
1716         require(exists(_id), "ERC721Tradable#uri: NONEXISTENT_TOKEN");
1717         require(_qty >= 1, "Must mint at least 1 token");
1718         require(canMintQtyForTransaction(_id, _qty), "Cannot mint more than max mint per transaction");
1719         require((totalSupply(_id) + _qty) <= getTokenSupplyCap(_id), "Cannot mint over supply cap of token!");
1720         require(msg.value == getPrice(_id, _qty), "Value needs to be exactly the mint fee!");
1721 
1722         require(inAllowlistMode(_id) && isMintingOpen(_id), "Allowlist Mode and Minting must be enabled to mint");
1723         require(isAllowlisted(msg.sender, _id, _merkleProof), "Address is not in Allowlist!");
1724         require(canMintAmount(_id, msg.sender, _qty), "Wallet mint maximum reached for token.");
1725 
1726         addTokenMints(_id, msg.sender, _qty);
1727         _mint(msg.sender, _id, _qty, emptyBytes);
1728     }
1729 
1730 
1731     /**
1732     * @dev Creates a new primary token for contract and gives creator first token
1733     * @param _tokenSupplyCap the maximum supply of tokens for this token
1734     * @param _tokenTransactionCap maximum amount of tokens one can buy per tx
1735     * @param _tokenFeeInWei payable fee per token
1736     * @param _isOpenDefaultStatus can token be publically minted once created
1737     * @param _allowTradingDefaultStatus is the token intially able to be transferred
1738     * @param _enableWalletCap is the token going to enforce wallet caps on creation
1739     * @param _walletCap wallet cap limit inital setting
1740     * @param _tokenURI the token URI to the metadata for this token
1741     */
1742     function createToken(
1743             uint256 _tokenSupplyCap, 
1744             uint256 _tokenTransactionCap,
1745             uint256 _tokenFeeInWei, 
1746             bool _isOpenDefaultStatus,
1747             bool _allowTradingDefaultStatus,
1748             bool _enableWalletCap,
1749             uint256 _walletCap,
1750             string memory _tokenURI
1751         ) public onlyOwner {
1752         require(_tokenSupplyCap > 0, "Token Supply Cap must be greater than zero.");
1753         require(_tokenTransactionCap > 0, "Token Transaction Cap must be greater than zero.");
1754         require(bytes(_tokenURI).length > 0, "Token URI cannot be an empty value");
1755 
1756         uint256 tokenId = _getNextTokenID();
1757 
1758         _mint(msg.sender, tokenId, 1, emptyBytes);
1759         baseTokenURI[tokenId] = _tokenURI;
1760 
1761         setTokenSupplyCap(tokenId, _tokenSupplyCap);
1762         setPriceForToken(tokenId, _tokenFeeInWei);
1763         setTransactionCapForToken(tokenId, _tokenTransactionCap);
1764         setInitialMintingStatus(tokenId, _isOpenDefaultStatus);
1765         setWalletCap(tokenId, _enableWalletCap, _walletCap);
1766         tokenTradingStatus[tokenId] = _allowTradingDefaultStatus ? 255 : 1;
1767 
1768         _incrementTokenTypeId();
1769     }
1770 
1771     /**
1772     * @dev pauses minting for all tokens in the contract
1773     */
1774     function pause() public onlyOwner {
1775         _pause();
1776     }
1777 
1778     /**
1779     * @dev unpauses minting for all tokens in the contract
1780     */
1781     function unpause() public onlyOwner {
1782         _unpause();
1783     }
1784 
1785     /**
1786     * @dev set the URI for a specific token on the contract
1787     * @param _id token id
1788     * @param _newTokenURI string for new metadata url (ex: ipfs://something)
1789     */
1790     function setTokenURI(uint256 _id, string memory _newTokenURI) public onlyOwner {
1791         require(exists(_id), "ERC721Tradable#uri: NONEXISTENT_TOKEN");
1792         baseTokenURI[_id] = _newTokenURI;
1793     }
1794 
1795     /**
1796     * @dev calculates price for a token based on qty
1797     * @param _id token id
1798     * @param _qty desired amount to mint
1799     */
1800     function getPrice(uint256 _id, uint256 _qty) public view returns (uint256) {
1801         require(_qty > 0, "Quantity must be more than zero");
1802         return getPriceForToken(_id) * _qty;
1803     }
1804 
1805     /**
1806     * @dev prevent token from being transferred (aka soulbound)
1807     * @param tokenId token id
1808     */
1809     function setTokenUntradeable(uint256 tokenId) public onlyOwner {
1810         require(tokenTradingStatus[tokenId] != 1, "Token ID is already untradeable!");
1811         require(exists(tokenId), "Token ID does not exist!");
1812         tokenTradingStatus[tokenId] = 1;
1813     }
1814 
1815     /**
1816     * @dev allow token from being transferred - the default mode
1817     * @param tokenId token id
1818     */
1819     function setTokenTradeable(uint256 tokenId) public onlyOwner {
1820         require(tokenTradingStatus[tokenId] != 255, "Token ID is already tradeable!");
1821         require(exists(tokenId), "Token ID does not exist!");
1822         tokenTradingStatus[tokenId] = 255;
1823     }
1824 
1825     /**
1826     * @dev check if token id is tradeable
1827     * @param tokenId token id
1828     */
1829     function isTokenTradeable(uint256 tokenId) public view returns (bool) {
1830         require(exists(tokenId), "Token ID does not exist!");
1831         return tokenTradingStatus[tokenId] == 255;
1832     }
1833 
1834     function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
1835         internal
1836         whenNotPaused
1837         override(ERC1155, ERC1155Supply)
1838     {
1839         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1840     }
1841 
1842     function _getNextTokenID() private view returns (uint256) {
1843         return currentTokenID + 1;
1844     }
1845 
1846     /**
1847     * @dev increments the value of currentTokenID
1848     */
1849     function _incrementTokenTypeId() private  {
1850         currentTokenID++;
1851     }
1852 }
1853   