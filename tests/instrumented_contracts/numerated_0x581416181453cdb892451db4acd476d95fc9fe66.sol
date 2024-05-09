1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /*
5     ██   ██  ██████  ██      ██    ██     ██    ██ ██ ██      ██       █████  ██ ███    ██ ███████ 
6     ██   ██ ██    ██ ██       ██  ██      ██    ██ ██ ██      ██      ██   ██ ██ ████   ██ ██      
7     ███████ ██    ██ ██        ████       ██    ██ ██ ██      ██      ███████ ██ ██ ██  ██ ███████ 
8     ██   ██ ██    ██ ██         ██         ██  ██  ██ ██      ██      ██   ██ ██ ██  ██ ██      ██ 
9     ██   ██  ██████  ███████    ██          ████   ██ ███████ ███████ ██   ██ ██ ██   ████ ███████ 
10     
11     Holy Heroes / cewy@nftbrains.com
12 */
13 
14 // File: @openzeppelin/contracts/utils/Context.sol
15 
16 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
17 
18 /**
19  * @dev Provides information about the current execution context, including the
20  * sender of the transaction and its data. While these are generally available
21  * via msg.sender and msg.data, they should not be accessed in such a direct
22  * manner, since when dealing with meta-transactions the account sending and
23  * paying for execution may not be the actual sender (as far as an application
24  * is concerned).
25  *
26  * This contract is only required for intermediate, library-like contracts.
27  */
28 abstract contract Context {
29     function _msgSender() internal view virtual returns (address) {
30         return msg.sender;
31     }
32 
33     function _msgData() internal view virtual returns (bytes calldata) {
34         return msg.data;
35     }
36 }
37 
38 // File: @openzeppelin/contracts/access/Ownable.sol
39 
40 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
41 
42 /**
43  * @dev Contract module which provides a basic access control mechanism, where
44  * there is an account (an owner) that can be granted exclusive access to
45  * specific functions.
46  *
47  * By default, the owner account will be the one that deploys the contract. This
48  * can later be changed with {transferOwnership}.
49  *
50  * This module is used through inheritance. It will make available the modifier
51  * `onlyOwner`, which can be applied to your functions to restrict their use to
52  * the owner.
53  */
54 abstract contract Ownable is Context {
55     address private _owner;
56 
57     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59     /**
60      * @dev Initializes the contract setting the deployer as the initial owner.
61      */
62     constructor() {
63         _transferOwnership(_msgSender());
64     }
65 
66     /**
67      * @dev Returns the address of the current owner.
68      */
69     function owner() public view virtual returns (address) {
70         return _owner;
71     }
72 
73     /**
74      * @dev Throws if called by any account other than the owner.
75      */
76     modifier onlyOwner() {
77         require(owner() == _msgSender(), "Ownable: caller is not the owner");
78         _;
79     }
80 
81     /**
82      * @dev Leaves the contract without owner. It will not be possible to call
83      * `onlyOwner` functions anymore. Can only be called by the current owner.
84      *
85      * NOTE: Renouncing ownership will leave the contract without an owner,
86      * thereby removing any functionality that is only available to the owner.
87      */
88     function renounceOwnership() public virtual onlyOwner {
89         _transferOwnership(address(0));
90     }
91 
92     /**
93      * @dev Transfers ownership of the contract to a new account (`newOwner`).
94      * Can only be called by the current owner.
95      */
96     function transferOwnership(address newOwner) public virtual onlyOwner {
97         require(newOwner != address(0), "Ownable: new owner is the zero address");
98         _transferOwnership(newOwner);
99     }
100 
101     /**
102      * @dev Transfers ownership of the contract to a new account (`newOwner`).
103      * Internal function without access restriction.
104      */
105     function _transferOwnership(address newOwner) internal virtual {
106         address oldOwner = _owner;
107         _owner = newOwner;
108         emit OwnershipTransferred(oldOwner, newOwner);
109     }
110 }
111 
112 // File: @openzeppelin/contracts/utils/Address.sol
113 
114 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
115 
116 /**
117  * @dev Collection of functions related to the address type
118  */
119 library Address {
120     /**
121      * @dev Returns true if `account` is a contract.
122      *
123      * [IMPORTANT]
124      * ====
125      * It is unsafe to assume that an address for which this function returns
126      * false is an externally-owned account (EOA) and not a contract.
127      *
128      * Among others, `isContract` will return false for the following
129      * types of addresses:
130      *
131      *  - an externally-owned account
132      *  - a contract in construction
133      *  - an address where a contract will be created
134      *  - an address where a contract lived, but was destroyed
135      * ====
136      */
137     function isContract(address account) internal view returns (bool) {
138         // This method relies on extcodesize, which returns 0 for contracts in
139         // construction, since the code is only stored at the end of the
140         // constructor execution.
141 
142         uint256 size;
143         assembly {
144             size := extcodesize(account)
145         }
146         return size > 0;
147     }
148 
149     /**
150      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
151      * `recipient`, forwarding all available gas and reverting on errors.
152      *
153      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
154      * of certain opcodes, possibly making contracts go over the 2300 gas limit
155      * imposed by `transfer`, making them unable to receive funds via
156      * `transfer`. {sendValue} removes this limitation.
157      *
158      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
159      *
160      * IMPORTANT: because control is transferred to `recipient`, care must be
161      * taken to not create reentrancy vulnerabilities. Consider using
162      * {ReentrancyGuard} or the
163      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
164      */
165     function sendValue(address payable recipient, uint256 amount) internal {
166         require(address(this).balance >= amount, "Address: insufficient balance");
167 
168         (bool success, ) = recipient.call{value: amount}("");
169         require(success, "Address: unable to send value, recipient may have reverted");
170     }
171 
172     /**
173      * @dev Performs a Solidity function call using a low level `call`. A
174      * plain `call` is an unsafe replacement for a function call: use this
175      * function instead.
176      *
177      * If `target` reverts with a revert reason, it is bubbled up by this
178      * function (like regular Solidity function calls).
179      *
180      * Returns the raw returned data. To convert to the expected return value,
181      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
182      *
183      * Requirements:
184      *
185      * - `target` must be a contract.
186      * - calling `target` with `data` must not revert.
187      *
188      * _Available since v3.1._
189      */
190     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
191         return functionCall(target, data, "Address: low-level call failed");
192     }
193 
194     /**
195      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
196      * `errorMessage` as a fallback revert reason when `target` reverts.
197      *
198      * _Available since v3.1._
199      */
200     function functionCall(
201         address target,
202         bytes memory data,
203         string memory errorMessage
204     ) internal returns (bytes memory) {
205         return functionCallWithValue(target, data, 0, errorMessage);
206     }
207 
208     /**
209      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
210      * but also transferring `value` wei to `target`.
211      *
212      * Requirements:
213      *
214      * - the calling contract must have an ETH balance of at least `value`.
215      * - the called Solidity function must be `payable`.
216      *
217      * _Available since v3.1._
218      */
219     function functionCallWithValue(
220         address target,
221         bytes memory data,
222         uint256 value
223     ) internal returns (bytes memory) {
224         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
225     }
226 
227     /**
228      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
229      * with `errorMessage` as a fallback revert reason when `target` reverts.
230      *
231      * _Available since v3.1._
232      */
233     function functionCallWithValue(
234         address target,
235         bytes memory data,
236         uint256 value,
237         string memory errorMessage
238     ) internal returns (bytes memory) {
239         require(address(this).balance >= value, "Address: insufficient balance for call");
240         require(isContract(target), "Address: call to non-contract");
241 
242         (bool success, bytes memory returndata) = target.call{value: value}(data);
243         return verifyCallResult(success, returndata, errorMessage);
244     }
245 
246     /**
247      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
248      * but performing a static call.
249      *
250      * _Available since v3.3._
251      */
252     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
253         return functionStaticCall(target, data, "Address: low-level static call failed");
254     }
255 
256     /**
257      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
258      * but performing a static call.
259      *
260      * _Available since v3.3._
261      */
262     function functionStaticCall(
263         address target,
264         bytes memory data,
265         string memory errorMessage
266     ) internal view returns (bytes memory) {
267         require(isContract(target), "Address: static call to non-contract");
268 
269         (bool success, bytes memory returndata) = target.staticcall(data);
270         return verifyCallResult(success, returndata, errorMessage);
271     }
272 
273     /**
274      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
275      * but performing a delegate call.
276      *
277      * _Available since v3.4._
278      */
279     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
280         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
281     }
282 
283     /**
284      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
285      * but performing a delegate call.
286      *
287      * _Available since v3.4._
288      */
289     function functionDelegateCall(
290         address target,
291         bytes memory data,
292         string memory errorMessage
293     ) internal returns (bytes memory) {
294         require(isContract(target), "Address: delegate call to non-contract");
295 
296         (bool success, bytes memory returndata) = target.delegatecall(data);
297         return verifyCallResult(success, returndata, errorMessage);
298     }
299 
300     /**
301      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
302      * revert reason using the provided one.
303      *
304      * _Available since v4.3._
305      */
306     function verifyCallResult(
307         bool success,
308         bytes memory returndata,
309         string memory errorMessage
310     ) internal pure returns (bytes memory) {
311         if (success) {
312             return returndata;
313         } else {
314             // Look for revert reason and bubble it up if present
315             if (returndata.length > 0) {
316                 // The easiest way to bubble the revert reason is using memory via assembly
317 
318                 assembly {
319                     let returndata_size := mload(returndata)
320                     revert(add(32, returndata), returndata_size)
321                 }
322             } else {
323                 revert(errorMessage);
324             }
325         }
326     }
327 }
328 
329 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
330 
331 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
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
356 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
357 
358 /**
359  * @dev Implementation of the {IERC165} interface.
360  *
361  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
362  * for the additional interface id that will be supported. For example:
363  *
364  * ```solidity
365  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
366  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
367  * }
368  * ```
369  *
370  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
371  */
372 abstract contract ERC165 is IERC165 {
373     /**
374      * @dev See {IERC165-supportsInterface}.
375      */
376     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
377         return interfaceId == type(IERC165).interfaceId;
378     }
379 }
380 
381 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
382 
383 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155Receiver.sol)
384 
385 /**
386  * @dev _Available since v3.1._
387  */
388 interface IERC1155Receiver is IERC165 {
389     /**
390         @dev Handles the receipt of a single ERC1155 token type. This function is
391         called at the end of a `safeTransferFrom` after the balance has been updated.
392         To accept the transfer, this must return
393         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
394         (i.e. 0xf23a6e61, or its own function selector).
395         @param operator The address which initiated the transfer (i.e. msg.sender)
396         @param from The address which previously owned the token
397         @param id The ID of the token being transferred
398         @param value The amount of tokens being transferred
399         @param data Additional data with no specified format
400         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
401     */
402     function onERC1155Received(
403         address operator,
404         address from,
405         uint256 id,
406         uint256 value,
407         bytes calldata data
408     ) external returns (bytes4);
409 
410     /**
411         @dev Handles the receipt of a multiple ERC1155 token types. This function
412         is called at the end of a `safeBatchTransferFrom` after the balances have
413         been updated. To accept the transfer(s), this must return
414         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
415         (i.e. 0xbc197c81, or its own function selector).
416         @param operator The address which initiated the batch transfer (i.e. msg.sender)
417         @param from The address which previously owned the token
418         @param ids An array containing ids of each token being transferred (order and length must match values array)
419         @param values An array containing amounts of each token being transferred (order and length must match ids array)
420         @param data Additional data with no specified format
421         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
422     */
423     function onERC1155BatchReceived(
424         address operator,
425         address from,
426         uint256[] calldata ids,
427         uint256[] calldata values,
428         bytes calldata data
429     ) external returns (bytes4);
430 }
431 
432 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
433 
434 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/IERC1155.sol)
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
446     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
447 
448     /**
449      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
450      * transfers.
451      */
452     event TransferBatch(
453         address indexed operator,
454         address indexed from,
455         address indexed to,
456         uint256[] ids,
457         uint256[] values
458     );
459 
460     /**
461      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
462      * `approved`.
463      */
464     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
465 
466     /**
467      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
468      *
469      * If an {URI} event was emitted for `id`, the standard
470      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
471      * returned by {IERC1155MetadataURI-uri}.
472      */
473     event URI(string value, uint256 indexed id);
474 
475     /**
476      * @dev Returns the amount of tokens of token type `id` owned by `account`.
477      *
478      * Requirements:
479      *
480      * - `account` cannot be the zero address.
481      */
482     function balanceOf(address account, uint256 id) external view returns (uint256);
483 
484     /**
485      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
486      *
487      * Requirements:
488      *
489      * - `accounts` and `ids` must have the same length.
490      */
491     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
492         external
493         view
494         returns (uint256[] memory);
495 
496     /**
497      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
498      *
499      * Emits an {ApprovalForAll} event.
500      *
501      * Requirements:
502      *
503      * - `operator` cannot be the caller.
504      */
505     function setApprovalForAll(address operator, bool approved) external;
506 
507     /**
508      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
509      *
510      * See {setApprovalForAll}.
511      */
512     function isApprovedForAll(address account, address operator) external view returns (bool);
513 
514     /**
515      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
516      *
517      * Emits a {TransferSingle} event.
518      *
519      * Requirements:
520      *
521      * - `to` cannot be the zero address.
522      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
523      * - `from` must have a balance of tokens of type `id` of at least `amount`.
524      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
525      * acceptance magic value.
526      */
527     function safeTransferFrom(
528         address from,
529         address to,
530         uint256 id,
531         uint256 amount,
532         bytes calldata data
533     ) external;
534 
535     /**
536      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
537      *
538      * Emits a {TransferBatch} event.
539      *
540      * Requirements:
541      *
542      * - `ids` and `amounts` must have the same length.
543      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
544      * acceptance magic value.
545      */
546     function safeBatchTransferFrom(
547         address from,
548         address to,
549         uint256[] calldata ids,
550         uint256[] calldata amounts,
551         bytes calldata data
552     ) external;
553 }
554 
555 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
556 
557 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
558 
559 /**
560  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
561  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
562  *
563  * _Available since v3.1._
564  */
565 interface IERC1155MetadataURI is IERC1155 {
566     /**
567      * @dev Returns the URI for token type `id`.
568      *
569      * If the `\{id\}` substring is present in the URI, it must be replaced by
570      * clients with the actual token type ID.
571      */
572     function uri(uint256 id) external view returns (string memory);
573 }
574 
575 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
576 
577 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/ERC1155.sol)
578 
579 /**
580  * @dev Implementation of the basic standard multi-token.
581  * See https://eips.ethereum.org/EIPS/eip-1155
582  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
583  *
584  * _Available since v3.1._
585  */
586 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
587     using Address for address;
588 
589     // Mapping from token ID to account balances
590     mapping(uint256 => mapping(address => uint256)) private _balances;
591 
592     // Mapping from account to operator approvals
593     mapping(address => mapping(address => bool)) private _operatorApprovals;
594 
595     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
596     string private _uri;
597 
598     /**
599      * @dev See {_setURI}.
600      */
601     constructor(string memory uri_) {
602         _setURI(uri_);
603     }
604 
605     /**
606      * @dev See {IERC165-supportsInterface}.
607      */
608     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
609         return
610             interfaceId == type(IERC1155).interfaceId ||
611             interfaceId == type(IERC1155MetadataURI).interfaceId ||
612             super.supportsInterface(interfaceId);
613     }
614 
615     /**
616      * @dev See {IERC1155MetadataURI-uri}.
617      *
618      * This implementation returns the same URI for *all* token types. It relies
619      * on the token type ID substitution mechanism
620      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
621      *
622      * Clients calling this function must replace the `\{id\}` substring with the
623      * actual token type ID.
624      */
625     function uri(uint256) public view virtual override returns (string memory) {
626         return _uri;
627     }
628 
629     /**
630      * @dev See {IERC1155-balanceOf}.
631      *
632      * Requirements:
633      *
634      * - `account` cannot be the zero address.
635      */
636     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
637         require(account != address(0), "ERC1155: balance query for the zero address");
638         return _balances[id][account];
639     }
640 
641     /**
642      * @dev See {IERC1155-balanceOfBatch}.
643      *
644      * Requirements:
645      *
646      * - `accounts` and `ids` must have the same length.
647      */
648     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
649         public
650         view
651         virtual
652         override
653         returns (uint256[] memory)
654     {
655         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
656 
657         uint256[] memory batchBalances = new uint256[](accounts.length);
658 
659         for (uint256 i = 0; i < accounts.length; ++i) {
660             batchBalances[i] = balanceOf(accounts[i], ids[i]);
661         }
662 
663         return batchBalances;
664     }
665 
666     /**
667      * @dev See {IERC1155-setApprovalForAll}.
668      */
669     function setApprovalForAll(address operator, bool approved) public virtual override {
670         _setApprovalForAll(_msgSender(), operator, approved);
671     }
672 
673     /**
674      * @dev See {IERC1155-isApprovedForAll}.
675      */
676     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
677         return _operatorApprovals[account][operator];
678     }
679 
680     /**
681      * @dev See {IERC1155-safeTransferFrom}.
682      */
683     function safeTransferFrom(
684         address from,
685         address to,
686         uint256 id,
687         uint256 amount,
688         bytes memory data
689     ) public virtual override {
690         require(
691             from == _msgSender() || isApprovedForAll(from, _msgSender()),
692             "ERC1155: caller is not owner nor approved"
693         );
694         _safeTransferFrom(from, to, id, amount, data);
695     }
696 
697     /**
698      * @dev See {IERC1155-safeBatchTransferFrom}.
699      */
700     function safeBatchTransferFrom(
701         address from,
702         address to,
703         uint256[] memory ids,
704         uint256[] memory amounts,
705         bytes memory data
706     ) public virtual override {
707         require(
708             from == _msgSender() || isApprovedForAll(from, _msgSender()),
709             "ERC1155: transfer caller is not owner nor approved"
710         );
711         _safeBatchTransferFrom(from, to, ids, amounts, data);
712     }
713 
714     /**
715      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
716      *
717      * Emits a {TransferSingle} event.
718      *
719      * Requirements:
720      *
721      * - `to` cannot be the zero address.
722      * - `from` must have a balance of tokens of type `id` of at least `amount`.
723      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
724      * acceptance magic value.
725      */
726     function _safeTransferFrom(
727         address from,
728         address to,
729         uint256 id,
730         uint256 amount,
731         bytes memory data
732     ) internal virtual {
733         require(to != address(0), "ERC1155: transfer to the zero address");
734 
735         address operator = _msgSender();
736 
737         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
738 
739         uint256 fromBalance = _balances[id][from];
740         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
741         unchecked {
742             _balances[id][from] = fromBalance - amount;
743         }
744         _balances[id][to] += amount;
745 
746         emit TransferSingle(operator, from, to, id, amount);
747 
748         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
749     }
750 
751     /**
752      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
753      *
754      * Emits a {TransferBatch} event.
755      *
756      * Requirements:
757      *
758      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
759      * acceptance magic value.
760      */
761     function _safeBatchTransferFrom(
762         address from,
763         address to,
764         uint256[] memory ids,
765         uint256[] memory amounts,
766         bytes memory data
767     ) internal virtual {
768         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
769         require(to != address(0), "ERC1155: transfer to the zero address");
770 
771         address operator = _msgSender();
772 
773         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
774 
775         for (uint256 i = 0; i < ids.length; ++i) {
776             uint256 id = ids[i];
777             uint256 amount = amounts[i];
778 
779             uint256 fromBalance = _balances[id][from];
780             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
781             unchecked {
782                 _balances[id][from] = fromBalance - amount;
783             }
784             _balances[id][to] += amount;
785         }
786 
787         emit TransferBatch(operator, from, to, ids, amounts);
788 
789         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
790     }
791 
792     /**
793      * @dev Sets a new URI for all token types, by relying on the token type ID
794      * substitution mechanism
795      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
796      *
797      * By this mechanism, any occurrence of the `\{id\}` substring in either the
798      * URI or any of the amounts in the JSON file at said URI will be replaced by
799      * clients with the token type ID.
800      *
801      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
802      * interpreted by clients as
803      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
804      * for token type ID 0x4cce0.
805      *
806      * See {uri}.
807      *
808      * Because these URIs cannot be meaningfully represented by the {URI} event,
809      * this function emits no events.
810      */
811     function _setURI(string memory newuri) internal virtual {
812         _uri = newuri;
813     }
814 
815     /**
816      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
817      *
818      * Emits a {TransferSingle} event.
819      *
820      * Requirements:
821      *
822      * - `to` cannot be the zero address.
823      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
824      * acceptance magic value.
825      */
826     function _mint(
827         address to,
828         uint256 id,
829         uint256 amount,
830         bytes memory data
831     ) internal virtual {
832         require(to != address(0), "ERC1155: mint to the zero address");
833 
834         address operator = _msgSender();
835 
836         _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);
837 
838         _balances[id][to] += amount;
839         emit TransferSingle(operator, address(0), to, id, amount);
840 
841         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
842     }
843 
844     /**
845      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
846      *
847      * Requirements:
848      *
849      * - `ids` and `amounts` must have the same length.
850      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
851      * acceptance magic value.
852      */
853     function _mintBatch(
854         address to,
855         uint256[] memory ids,
856         uint256[] memory amounts,
857         bytes memory data
858     ) internal virtual {
859         require(to != address(0), "ERC1155: mint to the zero address");
860         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
861 
862         address operator = _msgSender();
863 
864         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
865 
866         for (uint256 i = 0; i < ids.length; i++) {
867             _balances[ids[i]][to] += amounts[i];
868         }
869 
870         emit TransferBatch(operator, address(0), to, ids, amounts);
871 
872         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
873     }
874 
875     /**
876      * @dev Destroys `amount` tokens of token type `id` from `from`
877      *
878      * Requirements:
879      *
880      * - `from` cannot be the zero address.
881      * - `from` must have at least `amount` tokens of token type `id`.
882      */
883     function _burn(
884         address from,
885         uint256 id,
886         uint256 amount
887     ) internal virtual {
888         require(from != address(0), "ERC1155: burn from the zero address");
889 
890         address operator = _msgSender();
891 
892         _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
893 
894         uint256 fromBalance = _balances[id][from];
895         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
896         unchecked {
897             _balances[id][from] = fromBalance - amount;
898         }
899 
900         emit TransferSingle(operator, from, address(0), id, amount);
901     }
902 
903     /**
904      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
905      *
906      * Requirements:
907      *
908      * - `ids` and `amounts` must have the same length.
909      */
910     function _burnBatch(
911         address from,
912         uint256[] memory ids,
913         uint256[] memory amounts
914     ) internal virtual {
915         require(from != address(0), "ERC1155: burn from the zero address");
916         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
917 
918         address operator = _msgSender();
919 
920         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
921 
922         for (uint256 i = 0; i < ids.length; i++) {
923             uint256 id = ids[i];
924             uint256 amount = amounts[i];
925 
926             uint256 fromBalance = _balances[id][from];
927             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
928             unchecked {
929                 _balances[id][from] = fromBalance - amount;
930             }
931         }
932 
933         emit TransferBatch(operator, from, address(0), ids, amounts);
934     }
935 
936     /**
937      * @dev Approve `operator` to operate on all of `owner` tokens
938      *
939      * Emits a {ApprovalForAll} event.
940      */
941     function _setApprovalForAll(
942         address owner,
943         address operator,
944         bool approved
945     ) internal virtual {
946         require(owner != operator, "ERC1155: setting approval status for self");
947         _operatorApprovals[owner][operator] = approved;
948         emit ApprovalForAll(owner, operator, approved);
949     }
950 
951     /**
952      * @dev Hook that is called before any token transfer. This includes minting
953      * and burning, as well as batched variants.
954      *
955      * The same hook is called on both single and batched variants. For single
956      * transfers, the length of the `id` and `amount` arrays will be 1.
957      *
958      * Calling conditions (for each `id` and `amount` pair):
959      *
960      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
961      * of token type `id` will be  transferred to `to`.
962      * - When `from` is zero, `amount` tokens of token type `id` will be minted
963      * for `to`.
964      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
965      * will be burned.
966      * - `from` and `to` are never both zero.
967      * - `ids` and `amounts` have the same, non-zero length.
968      *
969      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
970      */
971     function _beforeTokenTransfer(
972         address operator,
973         address from,
974         address to,
975         uint256[] memory ids,
976         uint256[] memory amounts,
977         bytes memory data
978     ) internal virtual {}
979 
980     function _doSafeTransferAcceptanceCheck(
981         address operator,
982         address from,
983         address to,
984         uint256 id,
985         uint256 amount,
986         bytes memory data
987     ) private {
988         if (to.isContract()) {
989             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
990                 if (response != IERC1155Receiver.onERC1155Received.selector) {
991                     revert("ERC1155: ERC1155Receiver rejected tokens");
992                 }
993             } catch Error(string memory reason) {
994                 revert(reason);
995             } catch {
996                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
997             }
998         }
999     }
1000 
1001     function _doSafeBatchTransferAcceptanceCheck(
1002         address operator,
1003         address from,
1004         address to,
1005         uint256[] memory ids,
1006         uint256[] memory amounts,
1007         bytes memory data
1008     ) private {
1009         if (to.isContract()) {
1010             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1011                 bytes4 response
1012             ) {
1013                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1014                     revert("ERC1155: ERC1155Receiver rejected tokens");
1015                 }
1016             } catch Error(string memory reason) {
1017                 revert(reason);
1018             } catch {
1019                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1020             }
1021         }
1022     }
1023 
1024     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1025         uint256[] memory array = new uint256[](1);
1026         array[0] = element;
1027 
1028         return array;
1029     }
1030 }
1031 
1032 // File: contracts/HolyVillains.sol
1033 
1034 contract HolyVillains is ERC1155, Ownable {
1035     string public constant name = "Holy Villains";
1036     string public constant symbol = "VILLAINS";
1037 
1038     uint32 public totalSupply = 0;
1039     uint256 public constant unitPrice = 0.0777 ether;
1040 
1041     uint32 public preSaleStart = 1641672000;
1042     uint32 public constant preSaleMaxSupply = 1000;
1043     uint32 public constant preSaleMaxPerWallet = 3;
1044 
1045     uint32 public publicSaleStart = 1641675600;
1046     uint32 public constant publicSaleMaxSupply = 3333;
1047     uint32 public constant publicSaleMaxPerWallet = 7;
1048 
1049     address signerAddress = 0xFbABC9E7651fA9eC84d85d590Cc6f14C29DD026a;
1050 
1051     mapping(address => uint32) public minted;
1052 
1053     constructor(string memory uri) ERC1155(uri) {}
1054 
1055     function setURI(string memory uri) public onlyOwner {
1056         _setURI(uri);
1057     }
1058 
1059     function setSignerAddress(address addr) external onlyOwner {
1060         signerAddress = addr;
1061     }
1062 
1063     function setPreSaleStart(uint32 timestamp) public onlyOwner {
1064         preSaleStart = timestamp;
1065     }
1066 
1067     function setPublicSaleStart(uint32 timestamp) public onlyOwner {
1068         publicSaleStart = timestamp;
1069     }
1070 
1071     function preSaleIsActive() public view returns (bool) {
1072         return
1073             preSaleStart <= block.timestamp &&
1074             publicSaleStart >= block.timestamp;
1075     }
1076 
1077     function publicSaleIsActive() public view returns (bool) {
1078         return publicSaleStart <= block.timestamp;
1079     }
1080 
1081     function isValidAccessMessage(
1082         uint8 v,
1083         bytes32 r,
1084         bytes32 s
1085     ) internal view returns (bool) {
1086         bytes32 hash = keccak256(abi.encodePacked(msg.sender));
1087         return
1088             signerAddress ==
1089             ecrecover(
1090                 keccak256(
1091                     abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
1092                 ),
1093                 v,
1094                 r,
1095                 s
1096             );
1097     }
1098 
1099     function mint(address to, uint32 count) internal {
1100         if (count > 1) {
1101             uint256[] memory ids = new uint256[](uint256(count));
1102             uint256[] memory amounts = new uint256[](uint256(count));
1103 
1104             for (uint32 i = 0; i < count; i++) {
1105                 ids[i] = totalSupply + i;
1106                 amounts[i] = 1;
1107             }
1108 
1109             _mintBatch(to, ids, amounts, "");
1110         } else {
1111             _mint(to, totalSupply, 1, "");
1112         }
1113 
1114         totalSupply += count;
1115     }
1116 
1117     function preSaleMint(
1118         uint8 v,
1119         bytes32 r,
1120         bytes32 s,
1121         uint32 count
1122     ) external payable {
1123         require(preSaleIsActive(), "Pre-sale is not active.");
1124         require(isValidAccessMessage(v, r, s), "Not whitelisted.");
1125         require(count > 0, "Count must be greater than 0.");
1126         require(
1127             totalSupply + count <= preSaleMaxSupply,
1128             "Count exceeds the maximum allowed supply."
1129         );
1130         require(msg.value >= unitPrice * count, "Not enough ether.");
1131         require(
1132             minted[msg.sender] + count <= preSaleMaxPerWallet,
1133             "Count exceeds the maximum allowed per wallet."
1134         );
1135 
1136         mint(msg.sender, count);
1137         minted[msg.sender] += count;
1138     }
1139 
1140     function publicSaleMint(uint32 count) external payable {
1141         require(publicSaleIsActive(), "Public sale is not active.");
1142         require(count > 0, "Count must be greater than 0.");
1143         require(
1144             totalSupply + count <= publicSaleMaxSupply,
1145             "Count exceeds the maximum allowed supply."
1146         );
1147         require(msg.value >= unitPrice * count, "Not enough ether.");
1148         require(
1149             minted[msg.sender] + count <= publicSaleMaxPerWallet,
1150             "Count exceeds the maximum allowed per wallet."
1151         );
1152 
1153         mint(msg.sender, count);
1154         minted[msg.sender] += count;
1155     }
1156 
1157     function batchMint(address[] memory addresses) external onlyOwner {
1158         require(
1159             totalSupply + addresses.length <= publicSaleMaxSupply,
1160             "Count exceeds the maximum allowed supply."
1161         );
1162 
1163         for (uint256 i = 0; i < addresses.length; i++) {
1164             mint(addresses[i], 1);
1165         }
1166     }
1167 
1168     function withdraw() external onlyOwner {
1169         address[7] memory addresses = [
1170             0x94017Dd41fD42E6812b74E6E675ad5B48562929E,
1171             0xFe2E2c1206eD98e37871819FFE0156392F1fFc08,
1172             0x8c349e3c568f2F69a736C76b6a239280Ea1cc4C8,
1173             0x7FDbb61440985e094F2d2BfcC86B2aAe976e96D0,
1174             0xA81CfedA5Fb92FDDa1c2bb5bBd47B149a11Bd927,
1175             0xe8791f7dAb20B4EE60A85DEC9a3bF11b0B29aBc5,
1176             0x1F9fa3F21f92b5579c4e4d7232d9E412b0E89399
1177         ];
1178 
1179         uint32[7] memory shares = [
1180             uint32(2500),
1181             uint32(2500),
1182             uint32(2500),
1183             uint32(800),
1184             uint32(400),
1185             uint32(400),
1186             uint32(900)
1187         ];
1188 
1189         uint256 balance = address(this).balance;
1190 
1191         for (uint32 i = 0; i < addresses.length; i++) {
1192             uint256 amount = i == addresses.length - 1
1193                 ? address(this).balance
1194                 : (balance * shares[i]) / 10000;
1195             payable(addresses[i]).transfer(amount);
1196         }
1197     }
1198 }