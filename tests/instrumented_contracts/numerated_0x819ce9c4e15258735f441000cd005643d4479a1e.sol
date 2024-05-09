1 // hevm: flattened sources of src/MintPass.sol
2 // SPDX-License-Identifier: MIT
3 pragma solidity >=0.8.0 <0.9.0;
4 
5 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
6 
7 /* pragma solidity ^0.8.0; */
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
30 
31 /* pragma solidity ^0.8.0; */
32 
33 /* import "../utils/Context.sol"; */
34 
35 /**
36  * @dev Contract module which provides a basic access control mechanism, where
37  * there is an account (an owner) that can be granted exclusive access to
38  * specific functions.
39  *
40  * By default, the owner account will be the one that deploys the contract. This
41  * can later be changed with {transferOwnership}.
42  *
43  * This module is used through inheritance. It will make available the modifier
44  * `onlyOwner`, which can be applied to your functions to restrict their use to
45  * the owner.
46  */
47 abstract contract Ownable is Context {
48     address private _owner;
49 
50     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52     /**
53      * @dev Initializes the contract setting the deployer as the initial owner.
54      */
55     constructor() {
56         _setOwner(_msgSender());
57     }
58 
59     /**
60      * @dev Returns the address of the current owner.
61      */
62     function owner() public view virtual returns (address) {
63         return _owner;
64     }
65 
66     /**
67      * @dev Throws if called by any account other than the owner.
68      */
69     modifier onlyOwner() {
70         require(owner() == _msgSender(), "Ownable: caller is not the owner");
71         _;
72     }
73 
74     /**
75      * @dev Leaves the contract without owner. It will not be possible to call
76      * `onlyOwner` functions anymore. Can only be called by the current owner.
77      *
78      * NOTE: Renouncing ownership will leave the contract without an owner,
79      * thereby removing any functionality that is only available to the owner.
80      */
81     function renounceOwnership() public virtual onlyOwner {
82         _setOwner(address(0));
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Can only be called by the current owner.
88      */
89     function transferOwnership(address newOwner) public virtual onlyOwner {
90         require(newOwner != address(0), "Ownable: new owner is the zero address");
91         _setOwner(newOwner);
92     }
93 
94     function _setOwner(address newOwner) private {
95         address oldOwner = _owner;
96         _owner = newOwner;
97         emit OwnershipTransferred(oldOwner, newOwner);
98     }
99 }
100 
101 ////// lib/openzeppelin-contracts/contracts/utils/introspection/IERC165.sol
102 
103 /* pragma solidity ^0.8.0; */
104 
105 /**
106  * @dev Interface of the ERC165 standard, as defined in the
107  * https://eips.ethereum.org/EIPS/eip-165[EIP].
108  *
109  * Implementers can declare support of contract interfaces, which can then be
110  * queried by others ({ERC165Checker}).
111  *
112  * For an implementation, see {ERC165}.
113  */
114 interface IERC165 {
115     /**
116      * @dev Returns true if this contract implements the interface defined by
117      * `interfaceId`. See the corresponding
118      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
119      * to learn more about how these ids are created.
120      *
121      * This function call must use less than 30 000 gas.
122      */
123     function supportsInterface(bytes4 interfaceId) external view returns (bool);
124 }
125 
126 ////// lib/openzeppelin-contracts/contracts/token/ERC1155/IERC1155.sol
127 
128 /* pragma solidity ^0.8.0; */
129 
130 /* import "../../utils/introspection/IERC165.sol"; */
131 
132 /**
133  * @dev Required interface of an ERC1155 compliant contract, as defined in the
134  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
135  *
136  * _Available since v3.1._
137  */
138 interface IERC1155 is IERC165 {
139     /**
140      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
141      */
142     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
143 
144     /**
145      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
146      * transfers.
147      */
148     event TransferBatch(
149         address indexed operator,
150         address indexed from,
151         address indexed to,
152         uint256[] ids,
153         uint256[] values
154     );
155 
156     /**
157      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
158      * `approved`.
159      */
160     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
161 
162     /**
163      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
164      *
165      * If an {URI} event was emitted for `id`, the standard
166      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
167      * returned by {IERC1155MetadataURI-uri}.
168      */
169     event URI(string value, uint256 indexed id);
170 
171     /**
172      * @dev Returns the amount of tokens of token type `id` owned by `account`.
173      *
174      * Requirements:
175      *
176      * - `account` cannot be the zero address.
177      */
178     function balanceOf(address account, uint256 id) external view returns (uint256);
179 
180     /**
181      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
182      *
183      * Requirements:
184      *
185      * - `accounts` and `ids` must have the same length.
186      */
187     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
188         external
189         view
190         returns (uint256[] memory);
191 
192     /**
193      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
194      *
195      * Emits an {ApprovalForAll} event.
196      *
197      * Requirements:
198      *
199      * - `operator` cannot be the caller.
200      */
201     function setApprovalForAll(address operator, bool approved) external;
202 
203     /**
204      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
205      *
206      * See {setApprovalForAll}.
207      */
208     function isApprovedForAll(address account, address operator) external view returns (bool);
209 
210     /**
211      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
212      *
213      * Emits a {TransferSingle} event.
214      *
215      * Requirements:
216      *
217      * - `to` cannot be the zero address.
218      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
219      * - `from` must have a balance of tokens of type `id` of at least `amount`.
220      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
221      * acceptance magic value.
222      */
223     function safeTransferFrom(
224         address from,
225         address to,
226         uint256 id,
227         uint256 amount,
228         bytes calldata data
229     ) external;
230 
231     /**
232      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
233      *
234      * Emits a {TransferBatch} event.
235      *
236      * Requirements:
237      *
238      * - `ids` and `amounts` must have the same length.
239      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
240      * acceptance magic value.
241      */
242     function safeBatchTransferFrom(
243         address from,
244         address to,
245         uint256[] calldata ids,
246         uint256[] calldata amounts,
247         bytes calldata data
248     ) external;
249 }
250 
251 ////// lib/openzeppelin-contracts/contracts/token/ERC1155/IERC1155Receiver.sol
252 
253 /* pragma solidity ^0.8.0; */
254 
255 /* import "../../utils/introspection/IERC165.sol"; */
256 
257 /**
258  * @dev _Available since v3.1._
259  */
260 interface IERC1155Receiver is IERC165 {
261     /**
262         @dev Handles the receipt of a single ERC1155 token type. This function is
263         called at the end of a `safeTransferFrom` after the balance has been updated.
264         To accept the transfer, this must return
265         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
266         (i.e. 0xf23a6e61, or its own function selector).
267         @param operator The address which initiated the transfer (i.e. msg.sender)
268         @param from The address which previously owned the token
269         @param id The ID of the token being transferred
270         @param value The amount of tokens being transferred
271         @param data Additional data with no specified format
272         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
273     */
274     function onERC1155Received(
275         address operator,
276         address from,
277         uint256 id,
278         uint256 value,
279         bytes calldata data
280     ) external returns (bytes4);
281 
282     /**
283         @dev Handles the receipt of a multiple ERC1155 token types. This function
284         is called at the end of a `safeBatchTransferFrom` after the balances have
285         been updated. To accept the transfer(s), this must return
286         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
287         (i.e. 0xbc197c81, or its own function selector).
288         @param operator The address which initiated the batch transfer (i.e. msg.sender)
289         @param from The address which previously owned the token
290         @param ids An array containing ids of each token being transferred (order and length must match values array)
291         @param values An array containing amounts of each token being transferred (order and length must match ids array)
292         @param data Additional data with no specified format
293         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
294     */
295     function onERC1155BatchReceived(
296         address operator,
297         address from,
298         uint256[] calldata ids,
299         uint256[] calldata values,
300         bytes calldata data
301     ) external returns (bytes4);
302 }
303 
304 ////// lib/openzeppelin-contracts/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
305 
306 /* pragma solidity ^0.8.0; */
307 
308 /* import "../IERC1155.sol"; */
309 
310 /**
311  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
312  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
313  *
314  * _Available since v3.1._
315  */
316 interface IERC1155MetadataURI is IERC1155 {
317     /**
318      * @dev Returns the URI for token type `id`.
319      *
320      * If the `\{id\}` substring is present in the URI, it must be replaced by
321      * clients with the actual token type ID.
322      */
323     function uri(uint256 id) external view returns (string memory);
324 }
325 
326 ////// lib/openzeppelin-contracts/contracts/utils/Address.sol
327 
328 /* pragma solidity ^0.8.0; */
329 
330 /**
331  * @dev Collection of functions related to the address type
332  */
333 library Address {
334     /**
335      * @dev Returns true if `account` is a contract.
336      *
337      * [IMPORTANT]
338      * ====
339      * It is unsafe to assume that an address for which this function returns
340      * false is an externally-owned account (EOA) and not a contract.
341      *
342      * Among others, `isContract` will return false for the following
343      * types of addresses:
344      *
345      *  - an externally-owned account
346      *  - a contract in construction
347      *  - an address where a contract will be created
348      *  - an address where a contract lived, but was destroyed
349      * ====
350      */
351     function isContract(address account) internal view returns (bool) {
352         // This method relies on extcodesize, which returns 0 for contracts in
353         // construction, since the code is only stored at the end of the
354         // constructor execution.
355 
356         uint256 size;
357         assembly {
358             size := extcodesize(account)
359         }
360         return size > 0;
361     }
362 
363     /**
364      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
365      * `recipient`, forwarding all available gas and reverting on errors.
366      *
367      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
368      * of certain opcodes, possibly making contracts go over the 2300 gas limit
369      * imposed by `transfer`, making them unable to receive funds via
370      * `transfer`. {sendValue} removes this limitation.
371      *
372      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
373      *
374      * IMPORTANT: because control is transferred to `recipient`, care must be
375      * taken to not create reentrancy vulnerabilities. Consider using
376      * {ReentrancyGuard} or the
377      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
378      */
379     function sendValue(address payable recipient, uint256 amount) internal {
380         require(address(this).balance >= amount, "Address: insufficient balance");
381 
382         (bool success, ) = recipient.call{value: amount}("");
383         require(success, "Address: unable to send value, recipient may have reverted");
384     }
385 
386     /**
387      * @dev Performs a Solidity function call using a low level `call`. A
388      * plain `call` is an unsafe replacement for a function call: use this
389      * function instead.
390      *
391      * If `target` reverts with a revert reason, it is bubbled up by this
392      * function (like regular Solidity function calls).
393      *
394      * Returns the raw returned data. To convert to the expected return value,
395      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
396      *
397      * Requirements:
398      *
399      * - `target` must be a contract.
400      * - calling `target` with `data` must not revert.
401      *
402      * _Available since v3.1._
403      */
404     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
405         return functionCall(target, data, "Address: low-level call failed");
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
410      * `errorMessage` as a fallback revert reason when `target` reverts.
411      *
412      * _Available since v3.1._
413      */
414     function functionCall(
415         address target,
416         bytes memory data,
417         string memory errorMessage
418     ) internal returns (bytes memory) {
419         return functionCallWithValue(target, data, 0, errorMessage);
420     }
421 
422     /**
423      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
424      * but also transferring `value` wei to `target`.
425      *
426      * Requirements:
427      *
428      * - the calling contract must have an ETH balance of at least `value`.
429      * - the called Solidity function must be `payable`.
430      *
431      * _Available since v3.1._
432      */
433     function functionCallWithValue(
434         address target,
435         bytes memory data,
436         uint256 value
437     ) internal returns (bytes memory) {
438         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
439     }
440 
441     /**
442      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
443      * with `errorMessage` as a fallback revert reason when `target` reverts.
444      *
445      * _Available since v3.1._
446      */
447     function functionCallWithValue(
448         address target,
449         bytes memory data,
450         uint256 value,
451         string memory errorMessage
452     ) internal returns (bytes memory) {
453         require(address(this).balance >= value, "Address: insufficient balance for call");
454         require(isContract(target), "Address: call to non-contract");
455 
456         (bool success, bytes memory returndata) = target.call{value: value}(data);
457         return verifyCallResult(success, returndata, errorMessage);
458     }
459 
460     /**
461      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
462      * but performing a static call.
463      *
464      * _Available since v3.3._
465      */
466     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
467         return functionStaticCall(target, data, "Address: low-level static call failed");
468     }
469 
470     /**
471      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
472      * but performing a static call.
473      *
474      * _Available since v3.3._
475      */
476     function functionStaticCall(
477         address target,
478         bytes memory data,
479         string memory errorMessage
480     ) internal view returns (bytes memory) {
481         require(isContract(target), "Address: static call to non-contract");
482 
483         (bool success, bytes memory returndata) = target.staticcall(data);
484         return verifyCallResult(success, returndata, errorMessage);
485     }
486 
487     /**
488      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
489      * but performing a delegate call.
490      *
491      * _Available since v3.4._
492      */
493     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
494         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
495     }
496 
497     /**
498      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
499      * but performing a delegate call.
500      *
501      * _Available since v3.4._
502      */
503     function functionDelegateCall(
504         address target,
505         bytes memory data,
506         string memory errorMessage
507     ) internal returns (bytes memory) {
508         require(isContract(target), "Address: delegate call to non-contract");
509 
510         (bool success, bytes memory returndata) = target.delegatecall(data);
511         return verifyCallResult(success, returndata, errorMessage);
512     }
513 
514     /**
515      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
516      * revert reason using the provided one.
517      *
518      * _Available since v4.3._
519      */
520     function verifyCallResult(
521         bool success,
522         bytes memory returndata,
523         string memory errorMessage
524     ) internal pure returns (bytes memory) {
525         if (success) {
526             return returndata;
527         } else {
528             // Look for revert reason and bubble it up if present
529             if (returndata.length > 0) {
530                 // The easiest way to bubble the revert reason is using memory via assembly
531 
532                 assembly {
533                     let returndata_size := mload(returndata)
534                     revert(add(32, returndata), returndata_size)
535                 }
536             } else {
537                 revert(errorMessage);
538             }
539         }
540     }
541 }
542 
543 ////// lib/openzeppelin-contracts/contracts/utils/introspection/ERC165.sol
544 
545 /* pragma solidity ^0.8.0; */
546 
547 /* import "./IERC165.sol"; */
548 
549 /**
550  * @dev Implementation of the {IERC165} interface.
551  *
552  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
553  * for the additional interface id that will be supported. For example:
554  *
555  * ```solidity
556  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
557  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
558  * }
559  * ```
560  *
561  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
562  */
563 abstract contract ERC165 is IERC165 {
564     /**
565      * @dev See {IERC165-supportsInterface}.
566      */
567     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
568         return interfaceId == type(IERC165).interfaceId;
569     }
570 }
571 
572 ////// lib/openzeppelin-contracts/contracts/token/ERC1155/ERC1155.sol
573 
574 /* pragma solidity ^0.8.0; */
575 
576 /* import "./IERC1155.sol"; */
577 /* import "./IERC1155Receiver.sol"; */
578 /* import "./extensions/IERC1155MetadataURI.sol"; */
579 /* import "../../utils/Address.sol"; */
580 /* import "../../utils/Context.sol"; */
581 /* import "../../utils/introspection/ERC165.sol"; */
582 
583 /**
584  * @dev Implementation of the basic standard multi-token.
585  * See https://eips.ethereum.org/EIPS/eip-1155
586  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
587  *
588  * _Available since v3.1._
589  */
590 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
591     using Address for address;
592 
593     // Mapping from token ID to account balances
594     mapping(uint256 => mapping(address => uint256)) private _balances;
595 
596     // Mapping from account to operator approvals
597     mapping(address => mapping(address => bool)) private _operatorApprovals;
598 
599     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
600     string private _uri;
601 
602     /**
603      * @dev See {_setURI}.
604      */
605     constructor(string memory uri_) {
606         _setURI(uri_);
607     }
608 
609     /**
610      * @dev See {IERC165-supportsInterface}.
611      */
612     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
613         return
614             interfaceId == type(IERC1155).interfaceId ||
615             interfaceId == type(IERC1155MetadataURI).interfaceId ||
616             super.supportsInterface(interfaceId);
617     }
618 
619     /**
620      * @dev See {IERC1155MetadataURI-uri}.
621      *
622      * This implementation returns the same URI for *all* token types. It relies
623      * on the token type ID substitution mechanism
624      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
625      *
626      * Clients calling this function must replace the `\{id\}` substring with the
627      * actual token type ID.
628      */
629     function uri(uint256) public view virtual override returns (string memory) {
630         return _uri;
631     }
632 
633     /**
634      * @dev See {IERC1155-balanceOf}.
635      *
636      * Requirements:
637      *
638      * - `account` cannot be the zero address.
639      */
640     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
641         require(account != address(0), "ERC1155: balance query for the zero address");
642         return _balances[id][account];
643     }
644 
645     /**
646      * @dev See {IERC1155-balanceOfBatch}.
647      *
648      * Requirements:
649      *
650      * - `accounts` and `ids` must have the same length.
651      */
652     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
653         public
654         view
655         virtual
656         override
657         returns (uint256[] memory)
658     {
659         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
660 
661         uint256[] memory batchBalances = new uint256[](accounts.length);
662 
663         for (uint256 i = 0; i < accounts.length; ++i) {
664             batchBalances[i] = balanceOf(accounts[i], ids[i]);
665         }
666 
667         return batchBalances;
668     }
669 
670     /**
671      * @dev See {IERC1155-setApprovalForAll}.
672      */
673     function setApprovalForAll(address operator, bool approved) public virtual override {
674         require(_msgSender() != operator, "ERC1155: setting approval status for self");
675 
676         _operatorApprovals[_msgSender()][operator] = approved;
677         emit ApprovalForAll(_msgSender(), operator, approved);
678     }
679 
680     /**
681      * @dev See {IERC1155-isApprovedForAll}.
682      */
683     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
684         return _operatorApprovals[account][operator];
685     }
686 
687     /**
688      * @dev See {IERC1155-safeTransferFrom}.
689      */
690     function safeTransferFrom(
691         address from,
692         address to,
693         uint256 id,
694         uint256 amount,
695         bytes memory data
696     ) public virtual override {
697         require(
698             from == _msgSender() || isApprovedForAll(from, _msgSender()),
699             "ERC1155: caller is not owner nor approved"
700         );
701         _safeTransferFrom(from, to, id, amount, data);
702     }
703 
704     /**
705      * @dev See {IERC1155-safeBatchTransferFrom}.
706      */
707     function safeBatchTransferFrom(
708         address from,
709         address to,
710         uint256[] memory ids,
711         uint256[] memory amounts,
712         bytes memory data
713     ) public virtual override {
714         require(
715             from == _msgSender() || isApprovedForAll(from, _msgSender()),
716             "ERC1155: transfer caller is not owner nor approved"
717         );
718         _safeBatchTransferFrom(from, to, ids, amounts, data);
719     }
720 
721     /**
722      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
723      *
724      * Emits a {TransferSingle} event.
725      *
726      * Requirements:
727      *
728      * - `to` cannot be the zero address.
729      * - `from` must have a balance of tokens of type `id` of at least `amount`.
730      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
731      * acceptance magic value.
732      */
733     function _safeTransferFrom(
734         address from,
735         address to,
736         uint256 id,
737         uint256 amount,
738         bytes memory data
739     ) internal virtual {
740         require(to != address(0), "ERC1155: transfer to the zero address");
741 
742         address operator = _msgSender();
743 
744         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
745 
746         uint256 fromBalance = _balances[id][from];
747         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
748         unchecked {
749             _balances[id][from] = fromBalance - amount;
750         }
751         _balances[id][to] += amount;
752 
753         emit TransferSingle(operator, from, to, id, amount);
754 
755         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
756     }
757 
758     /**
759      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
760      *
761      * Emits a {TransferBatch} event.
762      *
763      * Requirements:
764      *
765      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
766      * acceptance magic value.
767      */
768     function _safeBatchTransferFrom(
769         address from,
770         address to,
771         uint256[] memory ids,
772         uint256[] memory amounts,
773         bytes memory data
774     ) internal virtual {
775         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
776         require(to != address(0), "ERC1155: transfer to the zero address");
777 
778         address operator = _msgSender();
779 
780         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
781 
782         for (uint256 i = 0; i < ids.length; ++i) {
783             uint256 id = ids[i];
784             uint256 amount = amounts[i];
785 
786             uint256 fromBalance = _balances[id][from];
787             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
788             unchecked {
789                 _balances[id][from] = fromBalance - amount;
790             }
791             _balances[id][to] += amount;
792         }
793 
794         emit TransferBatch(operator, from, to, ids, amounts);
795 
796         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
797     }
798 
799     /**
800      * @dev Sets a new URI for all token types, by relying on the token type ID
801      * substitution mechanism
802      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
803      *
804      * By this mechanism, any occurrence of the `\{id\}` substring in either the
805      * URI or any of the amounts in the JSON file at said URI will be replaced by
806      * clients with the token type ID.
807      *
808      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
809      * interpreted by clients as
810      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
811      * for token type ID 0x4cce0.
812      *
813      * See {uri}.
814      *
815      * Because these URIs cannot be meaningfully represented by the {URI} event,
816      * this function emits no events.
817      */
818     function _setURI(string memory newuri) internal virtual {
819         _uri = newuri;
820     }
821 
822     /**
823      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
824      *
825      * Emits a {TransferSingle} event.
826      *
827      * Requirements:
828      *
829      * - `account` cannot be the zero address.
830      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
831      * acceptance magic value.
832      */
833     function _mint(
834         address account,
835         uint256 id,
836         uint256 amount,
837         bytes memory data
838     ) internal virtual {
839         require(account != address(0), "ERC1155: mint to the zero address");
840 
841         address operator = _msgSender();
842 
843         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
844 
845         _balances[id][account] += amount;
846         emit TransferSingle(operator, address(0), account, id, amount);
847 
848         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
849     }
850 
851     /**
852      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
853      *
854      * Requirements:
855      *
856      * - `ids` and `amounts` must have the same length.
857      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
858      * acceptance magic value.
859      */
860     function _mintBatch(
861         address to,
862         uint256[] memory ids,
863         uint256[] memory amounts,
864         bytes memory data
865     ) internal virtual {
866         require(to != address(0), "ERC1155: mint to the zero address");
867         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
868 
869         address operator = _msgSender();
870 
871         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
872 
873         for (uint256 i = 0; i < ids.length; i++) {
874             _balances[ids[i]][to] += amounts[i];
875         }
876 
877         emit TransferBatch(operator, address(0), to, ids, amounts);
878 
879         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
880     }
881 
882     /**
883      * @dev Destroys `amount` tokens of token type `id` from `account`
884      *
885      * Requirements:
886      *
887      * - `account` cannot be the zero address.
888      * - `account` must have at least `amount` tokens of token type `id`.
889      */
890     function _burn(
891         address account,
892         uint256 id,
893         uint256 amount
894     ) internal virtual {
895         require(account != address(0), "ERC1155: burn from the zero address");
896 
897         address operator = _msgSender();
898 
899         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
900 
901         uint256 accountBalance = _balances[id][account];
902         require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
903         unchecked {
904             _balances[id][account] = accountBalance - amount;
905         }
906 
907         emit TransferSingle(operator, account, address(0), id, amount);
908     }
909 
910     /**
911      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
912      *
913      * Requirements:
914      *
915      * - `ids` and `amounts` must have the same length.
916      */
917     function _burnBatch(
918         address account,
919         uint256[] memory ids,
920         uint256[] memory amounts
921     ) internal virtual {
922         require(account != address(0), "ERC1155: burn from the zero address");
923         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
924 
925         address operator = _msgSender();
926 
927         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
928 
929         for (uint256 i = 0; i < ids.length; i++) {
930             uint256 id = ids[i];
931             uint256 amount = amounts[i];
932 
933             uint256 accountBalance = _balances[id][account];
934             require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
935             unchecked {
936                 _balances[id][account] = accountBalance - amount;
937             }
938         }
939 
940         emit TransferBatch(operator, account, address(0), ids, amounts);
941     }
942 
943     /**
944      * @dev Hook that is called before any token transfer. This includes minting
945      * and burning, as well as batched variants.
946      *
947      * The same hook is called on both single and batched variants. For single
948      * transfers, the length of the `id` and `amount` arrays will be 1.
949      *
950      * Calling conditions (for each `id` and `amount` pair):
951      *
952      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
953      * of token type `id` will be  transferred to `to`.
954      * - When `from` is zero, `amount` tokens of token type `id` will be minted
955      * for `to`.
956      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
957      * will be burned.
958      * - `from` and `to` are never both zero.
959      * - `ids` and `amounts` have the same, non-zero length.
960      *
961      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
962      */
963     function _beforeTokenTransfer(
964         address operator,
965         address from,
966         address to,
967         uint256[] memory ids,
968         uint256[] memory amounts,
969         bytes memory data
970     ) internal virtual {}
971 
972     function _doSafeTransferAcceptanceCheck(
973         address operator,
974         address from,
975         address to,
976         uint256 id,
977         uint256 amount,
978         bytes memory data
979     ) private {
980         if (to.isContract()) {
981             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
982                 if (response != IERC1155Receiver.onERC1155Received.selector) {
983                     revert("ERC1155: ERC1155Receiver rejected tokens");
984                 }
985             } catch Error(string memory reason) {
986                 revert(reason);
987             } catch {
988                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
989             }
990         }
991     }
992 
993     function _doSafeBatchTransferAcceptanceCheck(
994         address operator,
995         address from,
996         address to,
997         uint256[] memory ids,
998         uint256[] memory amounts,
999         bytes memory data
1000     ) private {
1001         if (to.isContract()) {
1002             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1003                 bytes4 response
1004             ) {
1005                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1006                     revert("ERC1155: ERC1155Receiver rejected tokens");
1007                 }
1008             } catch Error(string memory reason) {
1009                 revert(reason);
1010             } catch {
1011                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1012             }
1013         }
1014     }
1015 
1016     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1017         uint256[] memory array = new uint256[](1);
1018         array[0] = element;
1019 
1020         return array;
1021     }
1022 }
1023 
1024 ////// lib/openzeppelin-contracts/contracts/utils/Strings.sol
1025 
1026 /* pragma solidity ^0.8.0; */
1027 
1028 /**
1029  * @dev String operations.
1030  */
1031 library Strings {
1032     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1033 
1034     /**
1035      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1036      */
1037     function toString(uint256 value) internal pure returns (string memory) {
1038         // Inspired by OraclizeAPI's implementation - MIT licence
1039         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1040 
1041         if (value == 0) {
1042             return "0";
1043         }
1044         uint256 temp = value;
1045         uint256 digits;
1046         while (temp != 0) {
1047             digits++;
1048             temp /= 10;
1049         }
1050         bytes memory buffer = new bytes(digits);
1051         while (value != 0) {
1052             digits -= 1;
1053             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1054             value /= 10;
1055         }
1056         return string(buffer);
1057     }
1058 
1059     /**
1060      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1061      */
1062     function toHexString(uint256 value) internal pure returns (string memory) {
1063         if (value == 0) {
1064             return "0x00";
1065         }
1066         uint256 temp = value;
1067         uint256 length = 0;
1068         while (temp != 0) {
1069             length++;
1070             temp >>= 8;
1071         }
1072         return toHexString(value, length);
1073     }
1074 
1075     /**
1076      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1077      */
1078     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1079         bytes memory buffer = new bytes(2 * length + 2);
1080         buffer[0] = "0";
1081         buffer[1] = "x";
1082         for (uint256 i = 2 * length + 1; i > 1; --i) {
1083             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1084             value >>= 4;
1085         }
1086         require(value == 0, "Strings: hex length insufficient");
1087         return string(buffer);
1088     }
1089 }
1090 
1091 ////// src/MintPass.sol
1092 /* pragma solidity ^0.8.0; */
1093 
1094 /* import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol"; */
1095 /* import "@openzeppelin/contracts/utils/Strings.sol"; */
1096 /* import "@openzeppelin/contracts/access/Ownable.sol"; */
1097 
1098 contract MintPass is ERC1155, Ownable {
1099     using Strings for uint256;
1100 
1101     string private baseURI;
1102     mapping(address => bool) public minters;
1103     mapping(uint256 => uint256) private _totalSupply;
1104 
1105     uint256 public count = 0;
1106 
1107     constructor() ERC1155("") {}
1108 
1109     modifier onlyMinter() {
1110         require(minters[msg.sender], "not minter");
1111         _;
1112     }
1113 
1114     /// Owner Functions ///
1115 
1116     function addMinter(address minter) external onlyOwner {
1117         minters[minter] = true;
1118     }
1119 
1120     function removeMinter(address minter) external onlyOwner {
1121         minters[minter] = false;
1122     }
1123 
1124     function updateBaseUri(string calldata base) external onlyOwner {
1125         baseURI = base;
1126     }
1127 
1128     /// Minter Function ///
1129 
1130     function mint(
1131         address to,
1132         uint256 id,
1133         uint256 amount
1134     ) external onlyMinter {
1135         _mint(to, id, amount, "0");
1136         _totalSupply[id] += amount;
1137     }
1138 
1139     function burn(
1140         address account,
1141         uint256 id,
1142         uint256 value
1143     ) public {
1144         require(
1145             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1146             "ERC1155: caller is not owner nor approved"
1147         );
1148         _burn(account, id, value);
1149         _totalSupply[id] -= value;
1150     }
1151 
1152     /// Public Functions ///
1153 
1154     function totalSupply(uint256 id) public view returns (uint256) {
1155         return _totalSupply[id];
1156     }
1157 
1158     function uri(uint256 id) public view override returns (string memory) {
1159         return
1160             bytes(baseURI).length > 0
1161                 ? string(abi.encodePacked(baseURI, id.toString(), ".json"))
1162                 : baseURI;
1163     }
1164 }