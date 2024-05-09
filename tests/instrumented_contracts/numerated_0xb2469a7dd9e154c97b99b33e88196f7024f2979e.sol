1 // Verified using https://dapp.tools
2 
3 // hevm: flattened sources of src/ERC1155/FERC1155.sol
4 // SPDX-License-Identifier: MIT
5 pragma solidity >=0.8.0 <0.9.0;
6 
7 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
8 
9 /* pragma solidity ^0.8.0; */
10 
11 /**
12  * @dev Provides information about the current execution context, including the
13  * sender of the transaction and its data. While these are generally available
14  * via msg.sender and msg.data, they should not be accessed in such a direct
15  * manner, since when dealing with meta-transactions the account sending and
16  * paying for execution may not be the actual sender (as far as an application
17  * is concerned).
18  *
19  * This contract is only required for intermediate, library-like contracts.
20  */
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes calldata) {
27         return msg.data;
28     }
29 }
30 
31 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
32 
33 /* pragma solidity ^0.8.0; */
34 
35 /* import "../utils/Context.sol"; */
36 
37 /**
38  * @dev Contract module which provides a basic access control mechanism, where
39  * there is an account (an owner) that can be granted exclusive access to
40  * specific functions.
41  *
42  * By default, the owner account will be the one that deploys the contract. This
43  * can later be changed with {transferOwnership}.
44  *
45  * This module is used through inheritance. It will make available the modifier
46  * `onlyOwner`, which can be applied to your functions to restrict their use to
47  * the owner.
48  */
49 abstract contract Ownable is Context {
50     address private _owner;
51 
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     /**
55      * @dev Initializes the contract setting the deployer as the initial owner.
56      */
57     constructor() {
58         _setOwner(_msgSender());
59     }
60 
61     /**
62      * @dev Returns the address of the current owner.
63      */
64     function owner() public view virtual returns (address) {
65         return _owner;
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         require(owner() == _msgSender(), "Ownable: caller is not the owner");
73         _;
74     }
75 
76     /**
77      * @dev Leaves the contract without owner. It will not be possible to call
78      * `onlyOwner` functions anymore. Can only be called by the current owner.
79      *
80      * NOTE: Renouncing ownership will leave the contract without an owner,
81      * thereby removing any functionality that is only available to the owner.
82      */
83     function renounceOwnership() public virtual onlyOwner {
84         _setOwner(address(0));
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public virtual onlyOwner {
92         require(newOwner != address(0), "Ownable: new owner is the zero address");
93         _setOwner(newOwner);
94     }
95 
96     function _setOwner(address newOwner) private {
97         address oldOwner = _owner;
98         _owner = newOwner;
99         emit OwnershipTransferred(oldOwner, newOwner);
100     }
101 }
102 
103 ////// lib/openzeppelin-contracts/contracts/utils/introspection/IERC165.sol
104 
105 /* pragma solidity ^0.8.0; */
106 
107 /**
108  * @dev Interface of the ERC165 standard, as defined in the
109  * https://eips.ethereum.org/EIPS/eip-165[EIP].
110  *
111  * Implementers can declare support of contract interfaces, which can then be
112  * queried by others ({ERC165Checker}).
113  *
114  * For an implementation, see {ERC165}.
115  */
116 interface IERC165 {
117     /**
118      * @dev Returns true if this contract implements the interface defined by
119      * `interfaceId`. See the corresponding
120      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
121      * to learn more about how these ids are created.
122      *
123      * This function call must use less than 30 000 gas.
124      */
125     function supportsInterface(bytes4 interfaceId) external view returns (bool);
126 }
127 
128 ////// lib/openzeppelin-contracts/contracts/token/ERC1155/IERC1155.sol
129 
130 /* pragma solidity ^0.8.0; */
131 
132 /* import "../../utils/introspection/IERC165.sol"; */
133 
134 /**
135  * @dev Required interface of an ERC1155 compliant contract, as defined in the
136  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
137  *
138  * _Available since v3.1._
139  */
140 interface IERC1155 is IERC165 {
141     /**
142      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
143      */
144     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
145 
146     /**
147      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
148      * transfers.
149      */
150     event TransferBatch(
151         address indexed operator,
152         address indexed from,
153         address indexed to,
154         uint256[] ids,
155         uint256[] values
156     );
157 
158     /**
159      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
160      * `approved`.
161      */
162     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
163 
164     /**
165      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
166      *
167      * If an {URI} event was emitted for `id`, the standard
168      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
169      * returned by {IERC1155MetadataURI-uri}.
170      */
171     event URI(string value, uint256 indexed id);
172 
173     /**
174      * @dev Returns the amount of tokens of token type `id` owned by `account`.
175      *
176      * Requirements:
177      *
178      * - `account` cannot be the zero address.
179      */
180     function balanceOf(address account, uint256 id) external view returns (uint256);
181 
182     /**
183      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
184      *
185      * Requirements:
186      *
187      * - `accounts` and `ids` must have the same length.
188      */
189     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
190         external
191         view
192         returns (uint256[] memory);
193 
194     /**
195      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
196      *
197      * Emits an {ApprovalForAll} event.
198      *
199      * Requirements:
200      *
201      * - `operator` cannot be the caller.
202      */
203     function setApprovalForAll(address operator, bool approved) external;
204 
205     /**
206      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
207      *
208      * See {setApprovalForAll}.
209      */
210     function isApprovedForAll(address account, address operator) external view returns (bool);
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
253 ////// lib/openzeppelin-contracts/contracts/token/ERC1155/IERC1155Receiver.sol
254 
255 /* pragma solidity ^0.8.0; */
256 
257 /* import "../../utils/introspection/IERC165.sol"; */
258 
259 /**
260  * @dev _Available since v3.1._
261  */
262 interface IERC1155Receiver is IERC165 {
263     /**
264         @dev Handles the receipt of a single ERC1155 token type. This function is
265         called at the end of a `safeTransferFrom` after the balance has been updated.
266         To accept the transfer, this must return
267         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
268         (i.e. 0xf23a6e61, or its own function selector).
269         @param operator The address which initiated the transfer (i.e. msg.sender)
270         @param from The address which previously owned the token
271         @param id The ID of the token being transferred
272         @param value The amount of tokens being transferred
273         @param data Additional data with no specified format
274         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
275     */
276     function onERC1155Received(
277         address operator,
278         address from,
279         uint256 id,
280         uint256 value,
281         bytes calldata data
282     ) external returns (bytes4);
283 
284     /**
285         @dev Handles the receipt of a multiple ERC1155 token types. This function
286         is called at the end of a `safeBatchTransferFrom` after the balances have
287         been updated. To accept the transfer(s), this must return
288         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
289         (i.e. 0xbc197c81, or its own function selector).
290         @param operator The address which initiated the batch transfer (i.e. msg.sender)
291         @param from The address which previously owned the token
292         @param ids An array containing ids of each token being transferred (order and length must match values array)
293         @param values An array containing amounts of each token being transferred (order and length must match ids array)
294         @param data Additional data with no specified format
295         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
296     */
297     function onERC1155BatchReceived(
298         address operator,
299         address from,
300         uint256[] calldata ids,
301         uint256[] calldata values,
302         bytes calldata data
303     ) external returns (bytes4);
304 }
305 
306 ////// lib/openzeppelin-contracts/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
307 
308 /* pragma solidity ^0.8.0; */
309 
310 /* import "../IERC1155.sol"; */
311 
312 /**
313  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
314  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
315  *
316  * _Available since v3.1._
317  */
318 interface IERC1155MetadataURI is IERC1155 {
319     /**
320      * @dev Returns the URI for token type `id`.
321      *
322      * If the `\{id\}` substring is present in the URI, it must be replaced by
323      * clients with the actual token type ID.
324      */
325     function uri(uint256 id) external view returns (string memory);
326 }
327 
328 ////// lib/openzeppelin-contracts/contracts/utils/Address.sol
329 
330 /* pragma solidity ^0.8.0; */
331 
332 /**
333  * @dev Collection of functions related to the address type
334  */
335 library Address {
336     /**
337      * @dev Returns true if `account` is a contract.
338      *
339      * [IMPORTANT]
340      * ====
341      * It is unsafe to assume that an address for which this function returns
342      * false is an externally-owned account (EOA) and not a contract.
343      *
344      * Among others, `isContract` will return false for the following
345      * types of addresses:
346      *
347      *  - an externally-owned account
348      *  - a contract in construction
349      *  - an address where a contract will be created
350      *  - an address where a contract lived, but was destroyed
351      * ====
352      */
353     function isContract(address account) internal view returns (bool) {
354         // This method relies on extcodesize, which returns 0 for contracts in
355         // construction, since the code is only stored at the end of the
356         // constructor execution.
357 
358         uint256 size;
359         assembly {
360             size := extcodesize(account)
361         }
362         return size > 0;
363     }
364 
365     /**
366      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
367      * `recipient`, forwarding all available gas and reverting on errors.
368      *
369      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
370      * of certain opcodes, possibly making contracts go over the 2300 gas limit
371      * imposed by `transfer`, making them unable to receive funds via
372      * `transfer`. {sendValue} removes this limitation.
373      *
374      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
375      *
376      * IMPORTANT: because control is transferred to `recipient`, care must be
377      * taken to not create reentrancy vulnerabilities. Consider using
378      * {ReentrancyGuard} or the
379      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
380      */
381     function sendValue(address payable recipient, uint256 amount) internal {
382         require(address(this).balance >= amount, "Address: insufficient balance");
383 
384         (bool success, ) = recipient.call{value: amount}("");
385         require(success, "Address: unable to send value, recipient may have reverted");
386     }
387 
388     /**
389      * @dev Performs a Solidity function call using a low level `call`. A
390      * plain `call` is an unsafe replacement for a function call: use this
391      * function instead.
392      *
393      * If `target` reverts with a revert reason, it is bubbled up by this
394      * function (like regular Solidity function calls).
395      *
396      * Returns the raw returned data. To convert to the expected return value,
397      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
398      *
399      * Requirements:
400      *
401      * - `target` must be a contract.
402      * - calling `target` with `data` must not revert.
403      *
404      * _Available since v3.1._
405      */
406     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
407         return functionCall(target, data, "Address: low-level call failed");
408     }
409 
410     /**
411      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
412      * `errorMessage` as a fallback revert reason when `target` reverts.
413      *
414      * _Available since v3.1._
415      */
416     function functionCall(
417         address target,
418         bytes memory data,
419         string memory errorMessage
420     ) internal returns (bytes memory) {
421         return functionCallWithValue(target, data, 0, errorMessage);
422     }
423 
424     /**
425      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
426      * but also transferring `value` wei to `target`.
427      *
428      * Requirements:
429      *
430      * - the calling contract must have an ETH balance of at least `value`.
431      * - the called Solidity function must be `payable`.
432      *
433      * _Available since v3.1._
434      */
435     function functionCallWithValue(
436         address target,
437         bytes memory data,
438         uint256 value
439     ) internal returns (bytes memory) {
440         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
441     }
442 
443     /**
444      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
445      * with `errorMessage` as a fallback revert reason when `target` reverts.
446      *
447      * _Available since v3.1._
448      */
449     function functionCallWithValue(
450         address target,
451         bytes memory data,
452         uint256 value,
453         string memory errorMessage
454     ) internal returns (bytes memory) {
455         require(address(this).balance >= value, "Address: insufficient balance for call");
456         require(isContract(target), "Address: call to non-contract");
457 
458         (bool success, bytes memory returndata) = target.call{value: value}(data);
459         return verifyCallResult(success, returndata, errorMessage);
460     }
461 
462     /**
463      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
464      * but performing a static call.
465      *
466      * _Available since v3.3._
467      */
468     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
469         return functionStaticCall(target, data, "Address: low-level static call failed");
470     }
471 
472     /**
473      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
474      * but performing a static call.
475      *
476      * _Available since v3.3._
477      */
478     function functionStaticCall(
479         address target,
480         bytes memory data,
481         string memory errorMessage
482     ) internal view returns (bytes memory) {
483         require(isContract(target), "Address: static call to non-contract");
484 
485         (bool success, bytes memory returndata) = target.staticcall(data);
486         return verifyCallResult(success, returndata, errorMessage);
487     }
488 
489     /**
490      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
491      * but performing a delegate call.
492      *
493      * _Available since v3.4._
494      */
495     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
496         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
497     }
498 
499     /**
500      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
501      * but performing a delegate call.
502      *
503      * _Available since v3.4._
504      */
505     function functionDelegateCall(
506         address target,
507         bytes memory data,
508         string memory errorMessage
509     ) internal returns (bytes memory) {
510         require(isContract(target), "Address: delegate call to non-contract");
511 
512         (bool success, bytes memory returndata) = target.delegatecall(data);
513         return verifyCallResult(success, returndata, errorMessage);
514     }
515 
516     /**
517      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
518      * revert reason using the provided one.
519      *
520      * _Available since v4.3._
521      */
522     function verifyCallResult(
523         bool success,
524         bytes memory returndata,
525         string memory errorMessage
526     ) internal pure returns (bytes memory) {
527         if (success) {
528             return returndata;
529         } else {
530             // Look for revert reason and bubble it up if present
531             if (returndata.length > 0) {
532                 // The easiest way to bubble the revert reason is using memory via assembly
533 
534                 assembly {
535                     let returndata_size := mload(returndata)
536                     revert(add(32, returndata), returndata_size)
537                 }
538             } else {
539                 revert(errorMessage);
540             }
541         }
542     }
543 }
544 
545 ////// lib/openzeppelin-contracts/contracts/utils/introspection/ERC165.sol
546 
547 /* pragma solidity ^0.8.0; */
548 
549 /* import "./IERC165.sol"; */
550 
551 /**
552  * @dev Implementation of the {IERC165} interface.
553  *
554  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
555  * for the additional interface id that will be supported. For example:
556  *
557  * ```solidity
558  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
559  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
560  * }
561  * ```
562  *
563  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
564  */
565 abstract contract ERC165 is IERC165 {
566     /**
567      * @dev See {IERC165-supportsInterface}.
568      */
569     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
570         return interfaceId == type(IERC165).interfaceId;
571     }
572 }
573 
574 ////// lib/openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol
575 
576 /* pragma solidity ^0.8.0; */
577 
578 /* import "./IERC1155.sol"; */
579 /* import "./IERC1155Receiver.sol"; */
580 /* import "./extensions/IERC1155MetadataURI.sol"; */
581 /* import "../../utils/Address.sol"; */
582 /* import "../../utils/Context.sol"; */
583 /* import "../../utils/introspection/ERC165.sol"; */
584 
585 /**
586  * @dev Implementation of the basic standard multi-token.
587  * See https://eips.ethereum.org/EIPS/eip-1155
588  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
589  *
590  * _Available since v3.1._
591  */
592 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
593     using Address for address;
594 
595     // Mapping from token ID to account balances
596     mapping(uint256 => mapping(address => uint256)) private _balances;
597 
598     // Mapping from account to operator approvals
599     mapping(address => mapping(address => bool)) private _operatorApprovals;
600 
601     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
602     string private _uri;
603 
604     /**
605      * @dev See {_setURI}.
606      */
607     constructor(string memory uri_) {
608         _setURI(uri_);
609     }
610 
611     /**
612      * @dev See {IERC165-supportsInterface}.
613      */
614     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
615         return
616             interfaceId == type(IERC1155).interfaceId ||
617             interfaceId == type(IERC1155MetadataURI).interfaceId ||
618             super.supportsInterface(interfaceId);
619     }
620 
621     /**
622      * @dev See {IERC1155MetadataURI-uri}.
623      *
624      * This implementation returns the same URI for *all* token types. It relies
625      * on the token type ID substitution mechanism
626      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
627      *
628      * Clients calling this function must replace the `\{id\}` substring with the
629      * actual token type ID.
630      */
631     function uri(uint256) public view virtual override returns (string memory) {
632         return _uri;
633     }
634 
635     /**
636      * @dev See {IERC1155-balanceOf}.
637      *
638      * Requirements:
639      *
640      * - `account` cannot be the zero address.
641      */
642     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
643         require(account != address(0), "ERC1155: balance query for the zero address");
644         return _balances[id][account];
645     }
646 
647     /**
648      * @dev See {IERC1155-balanceOfBatch}.
649      *
650      * Requirements:
651      *
652      * - `accounts` and `ids` must have the same length.
653      */
654     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
655         public
656         view
657         virtual
658         override
659         returns (uint256[] memory)
660     {
661         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
662 
663         uint256[] memory batchBalances = new uint256[](accounts.length);
664 
665         for (uint256 i = 0; i < accounts.length; ++i) {
666             batchBalances[i] = balanceOf(accounts[i], ids[i]);
667         }
668 
669         return batchBalances;
670     }
671 
672     /**
673      * @dev See {IERC1155-setApprovalForAll}.
674      */
675     function setApprovalForAll(address operator, bool approved) public virtual override {
676         require(_msgSender() != operator, "ERC1155: setting approval status for self");
677 
678         _operatorApprovals[_msgSender()][operator] = approved;
679         emit ApprovalForAll(_msgSender(), operator, approved);
680     }
681 
682     /**
683      * @dev See {IERC1155-isApprovedForAll}.
684      */
685     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
686         return _operatorApprovals[account][operator];
687     }
688 
689     /**
690      * @dev See {IERC1155-safeTransferFrom}.
691      */
692     function safeTransferFrom(
693         address from,
694         address to,
695         uint256 id,
696         uint256 amount,
697         bytes memory data
698     ) public virtual override {
699         require(
700             from == _msgSender() || isApprovedForAll(from, _msgSender()),
701             "ERC1155: caller is not owner nor approved"
702         );
703         _safeTransferFrom(from, to, id, amount, data);
704     }
705 
706     /**
707      * @dev See {IERC1155-safeBatchTransferFrom}.
708      */
709     function safeBatchTransferFrom(
710         address from,
711         address to,
712         uint256[] memory ids,
713         uint256[] memory amounts,
714         bytes memory data
715     ) public virtual override {
716         require(
717             from == _msgSender() || isApprovedForAll(from, _msgSender()),
718             "ERC1155: transfer caller is not owner nor approved"
719         );
720         _safeBatchTransferFrom(from, to, ids, amounts, data);
721     }
722 
723     /**
724      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
725      *
726      * Emits a {TransferSingle} event.
727      *
728      * Requirements:
729      *
730      * - `to` cannot be the zero address.
731      * - `from` must have a balance of tokens of type `id` of at least `amount`.
732      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
733      * acceptance magic value.
734      */
735     function _safeTransferFrom(
736         address from,
737         address to,
738         uint256 id,
739         uint256 amount,
740         bytes memory data
741     ) internal virtual {
742         require(to != address(0), "ERC1155: transfer to the zero address");
743 
744         address operator = _msgSender();
745 
746         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
747 
748         uint256 fromBalance = _balances[id][from];
749         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
750         unchecked {
751             _balances[id][from] = fromBalance - amount;
752         }
753         _balances[id][to] += amount;
754 
755         emit TransferSingle(operator, from, to, id, amount);
756 
757         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
758     }
759 
760     /**
761      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
762      *
763      * Emits a {TransferBatch} event.
764      *
765      * Requirements:
766      *
767      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
768      * acceptance magic value.
769      */
770     function _safeBatchTransferFrom(
771         address from,
772         address to,
773         uint256[] memory ids,
774         uint256[] memory amounts,
775         bytes memory data
776     ) internal virtual {
777         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
778         require(to != address(0), "ERC1155: transfer to the zero address");
779 
780         address operator = _msgSender();
781 
782         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
783 
784         for (uint256 i = 0; i < ids.length; ++i) {
785             uint256 id = ids[i];
786             uint256 amount = amounts[i];
787 
788             uint256 fromBalance = _balances[id][from];
789             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
790             unchecked {
791                 _balances[id][from] = fromBalance - amount;
792             }
793             _balances[id][to] += amount;
794         }
795 
796         emit TransferBatch(operator, from, to, ids, amounts);
797 
798         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
799     }
800 
801     /**
802      * @dev Sets a new URI for all token types, by relying on the token type ID
803      * substitution mechanism
804      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
805      *
806      * By this mechanism, any occurrence of the `\{id\}` substring in either the
807      * URI or any of the amounts in the JSON file at said URI will be replaced by
808      * clients with the token type ID.
809      *
810      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
811      * interpreted by clients as
812      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
813      * for token type ID 0x4cce0.
814      *
815      * See {uri}.
816      *
817      * Because these URIs cannot be meaningfully represented by the {URI} event,
818      * this function emits no events.
819      */
820     function _setURI(string memory newuri) internal virtual {
821         _uri = newuri;
822     }
823 
824     /**
825      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
826      *
827      * Emits a {TransferSingle} event.
828      *
829      * Requirements:
830      *
831      * - `account` cannot be the zero address.
832      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
833      * acceptance magic value.
834      */
835     function _mint(
836         address account,
837         uint256 id,
838         uint256 amount,
839         bytes memory data
840     ) internal virtual {
841         require(account != address(0), "ERC1155: mint to the zero address");
842 
843         address operator = _msgSender();
844 
845         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
846 
847         _balances[id][account] += amount;
848         emit TransferSingle(operator, address(0), account, id, amount);
849 
850         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
851     }
852 
853     /**
854      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
855      *
856      * Requirements:
857      *
858      * - `ids` and `amounts` must have the same length.
859      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
860      * acceptance magic value.
861      */
862     function _mintBatch(
863         address to,
864         uint256[] memory ids,
865         uint256[] memory amounts,
866         bytes memory data
867     ) internal virtual {
868         require(to != address(0), "ERC1155: mint to the zero address");
869         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
870 
871         address operator = _msgSender();
872 
873         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
874 
875         for (uint256 i = 0; i < ids.length; i++) {
876             _balances[ids[i]][to] += amounts[i];
877         }
878 
879         emit TransferBatch(operator, address(0), to, ids, amounts);
880 
881         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
882     }
883 
884     /**
885      * @dev Destroys `amount` tokens of token type `id` from `account`
886      *
887      * Requirements:
888      *
889      * - `account` cannot be the zero address.
890      * - `account` must have at least `amount` tokens of token type `id`.
891      */
892     function _burn(
893         address account,
894         uint256 id,
895         uint256 amount
896     ) internal virtual {
897         require(account != address(0), "ERC1155: burn from the zero address");
898 
899         address operator = _msgSender();
900 
901         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
902 
903         uint256 accountBalance = _balances[id][account];
904         require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
905         unchecked {
906             _balances[id][account] = accountBalance - amount;
907         }
908 
909         emit TransferSingle(operator, account, address(0), id, amount);
910     }
911 
912     /**
913      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
914      *
915      * Requirements:
916      *
917      * - `ids` and `amounts` must have the same length.
918      */
919     function _burnBatch(
920         address account,
921         uint256[] memory ids,
922         uint256[] memory amounts
923     ) internal virtual {
924         require(account != address(0), "ERC1155: burn from the zero address");
925         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
926 
927         address operator = _msgSender();
928 
929         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
930 
931         for (uint256 i = 0; i < ids.length; i++) {
932             uint256 id = ids[i];
933             uint256 amount = amounts[i];
934 
935             uint256 accountBalance = _balances[id][account];
936             require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
937             unchecked {
938                 _balances[id][account] = accountBalance - amount;
939             }
940         }
941 
942         emit TransferBatch(operator, account, address(0), ids, amounts);
943     }
944 
945     /**
946      * @dev Hook that is called before any token transfer. This includes minting
947      * and burning, as well as batched variants.
948      *
949      * The same hook is called on both single and batched variants. For single
950      * transfers, the length of the `id` and `amount` arrays will be 1.
951      *
952      * Calling conditions (for each `id` and `amount` pair):
953      *
954      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
955      * of token type `id` will be  transferred to `to`.
956      * - When `from` is zero, `amount` tokens of token type `id` will be minted
957      * for `to`.
958      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
959      * will be burned.
960      * - `from` and `to` are never both zero.
961      * - `ids` and `amounts` have the same, non-zero length.
962      *
963      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
964      */
965     function _beforeTokenTransfer(
966         address operator,
967         address from,
968         address to,
969         uint256[] memory ids,
970         uint256[] memory amounts,
971         bytes memory data
972     ) internal virtual {}
973 
974     function _doSafeTransferAcceptanceCheck(
975         address operator,
976         address from,
977         address to,
978         uint256 id,
979         uint256 amount,
980         bytes memory data
981     ) private {
982         if (to.isContract()) {
983             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
984                 if (response != IERC1155Receiver.onERC1155Received.selector) {
985                     revert("ERC1155: ERC1155Receiver rejected tokens");
986                 }
987             } catch Error(string memory reason) {
988                 revert(reason);
989             } catch {
990                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
991             }
992         }
993     }
994 
995     function _doSafeBatchTransferAcceptanceCheck(
996         address operator,
997         address from,
998         address to,
999         uint256[] memory ids,
1000         uint256[] memory amounts,
1001         bytes memory data
1002     ) private {
1003         if (to.isContract()) {
1004             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1005                 bytes4 response
1006             ) {
1007                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1008                     revert("ERC1155: ERC1155Receiver rejected tokens");
1009                 }
1010             } catch Error(string memory reason) {
1011                 revert(reason);
1012             } catch {
1013                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1014             }
1015         }
1016     }
1017 
1018     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1019         uint256[] memory array = new uint256[](1);
1020         array[0] = element;
1021 
1022         return array;
1023     }
1024 }
1025 
1026 ////// lib/openzeppelin-contracts/contracts/utils/Strings.sol
1027 
1028 /* pragma solidity ^0.8.0; */
1029 
1030 /**
1031  * @dev String operations.
1032  */
1033 library Strings {
1034     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1035 
1036     /**
1037      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1038      */
1039     function toString(uint256 value) internal pure returns (string memory) {
1040         // Inspired by OraclizeAPI's implementation - MIT licence
1041         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1042 
1043         if (value == 0) {
1044             return "0";
1045         }
1046         uint256 temp = value;
1047         uint256 digits;
1048         while (temp != 0) {
1049             digits++;
1050             temp /= 10;
1051         }
1052         bytes memory buffer = new bytes(digits);
1053         while (value != 0) {
1054             digits -= 1;
1055             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1056             value /= 10;
1057         }
1058         return string(buffer);
1059     }
1060 
1061     /**
1062      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1063      */
1064     function toHexString(uint256 value) internal pure returns (string memory) {
1065         if (value == 0) {
1066             return "0x00";
1067         }
1068         uint256 temp = value;
1069         uint256 length = 0;
1070         while (temp != 0) {
1071             length++;
1072             temp >>= 8;
1073         }
1074         return toHexString(value, length);
1075     }
1076 
1077     /**
1078      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1079      */
1080     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1081         bytes memory buffer = new bytes(2 * length + 2);
1082         buffer[0] = "0";
1083         buffer[1] = "x";
1084         for (uint256 i = 2 * length + 1; i > 1; --i) {
1085             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1086             value >>= 4;
1087         }
1088         require(value == 0, "Strings: hex length insufficient");
1089         return string(buffer);
1090     }
1091 }
1092 
1093 ////// src/ERC1155/FERC1155.sol
1094 /* pragma solidity ^0.8.0; */
1095 
1096 /* import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol"; */
1097 /* import "@openzeppelin/contracts/utils/Strings.sol"; */
1098 /* import "@openzeppelin/contracts/access/Ownable.sol"; */
1099 
1100 interface IVault {
1101     function onTransfer(address, address, uint256) external;
1102 }
1103 
1104 contract FERC1155 is ERC1155, Ownable {
1105     using Strings for uint256;
1106 
1107     string private baseURI;
1108     mapping(address => bool) public minters;
1109     mapping(uint256 => uint256) private _totalSupply;
1110 
1111     uint256 public count = 0;
1112 
1113     mapping(uint256 => address) public idToVault;
1114 
1115     constructor() ERC1155("") {}
1116 
1117     modifier onlyMinter() {
1118         require(minters[msg.sender]);
1119         _;
1120     }
1121 
1122     /// Owner Functions ///
1123     
1124     function addMinter(address minter) external onlyOwner {
1125         minters[minter] = true;
1126     }
1127 
1128     function removeMinter(address minter) external onlyOwner {
1129         minters[minter] = false;
1130     }
1131 
1132     function updateBaseUri(string calldata base) external onlyOwner {
1133         baseURI = base;
1134     }
1135 
1136     /// Minter Function ///
1137 
1138     function mint(address vault, uint256 amount) external onlyMinter returns(uint256) {
1139         count++;
1140         idToVault[count] = vault;
1141         _mint(msg.sender, count, amount, "0");
1142         _totalSupply[count] = amount;
1143         return count;
1144     }
1145 
1146     function mint(uint256 amount, uint256 id) external onlyMinter {
1147         require(id <= count, "doesn't exist");
1148         _mint(msg.sender, id, amount, "0");
1149         _totalSupply[count] += amount;
1150     }
1151 
1152     function burn(address account, uint256 id, uint256 value) public virtual {
1153         require(account == _msgSender() || isApprovedForAll(account, _msgSender()), "ERC1155: caller is not owner nor approved");
1154         _burn(account, id, value);
1155         _totalSupply[id] -= value;
1156     }
1157 
1158     /// Public Functions ///
1159 
1160     function totalSupply(uint256 id) public view virtual returns (uint256) {
1161         return _totalSupply[id];
1162     }
1163 
1164     function uri(uint256 id)
1165         public
1166         view                
1167         override
1168         returns (string memory)
1169     {
1170         return
1171             bytes(baseURI).length > 0
1172                 ? string(abi.encodePacked(baseURI, id.toString()))
1173                 : baseURI;
1174     }
1175 
1176     function _beforeTokenTransfer(
1177         address operator,
1178         address from,
1179         address to,
1180         uint256[] memory ids,
1181         uint256[] memory amounts,
1182         bytes memory data
1183     ) internal virtual override {
1184         require(ids.length == 1,"too long");
1185         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1186         
1187         IVault(idToVault[ids[0]]).onTransfer(from, to, amounts[0]);
1188     }
1189 
1190 
1191 }
