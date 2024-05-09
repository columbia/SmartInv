1 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
2 
3 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
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
40     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42     /**
43      * @dev Initializes the contract setting the deployer as the initial owner.
44      */
45     constructor() {
46         _transferOwnership(_msgSender());
47     }
48 
49     /**
50      * @dev Throws if called by any account other than the owner.
51      */
52     modifier onlyOwner() {
53         _checkOwner();
54         _;
55     }
56 
57     /**
58      * @dev Returns the address of the current owner.
59      */
60     function owner() public view virtual returns (address) {
61         return _owner;
62     }
63 
64     /**
65      * @dev Throws if the sender is not the owner.
66      */
67     function _checkOwner() internal view virtual {
68         require(owner() == _msgSender(), "Ownable: caller is not the owner");
69     }
70 
71     /**
72      * @dev Leaves the contract without owner. It will not be possible to call
73      * `onlyOwner` functions. Can only be called by the current owner.
74      *
75      * NOTE: Renouncing ownership will leave the contract without an owner,
76      * thereby disabling any functionality that is only available to the owner.
77      */
78     function renounceOwnership() public virtual onlyOwner {
79         _transferOwnership(address(0));
80     }
81 
82     /**
83      * @dev Transfers ownership of the contract to a new account (`newOwner`).
84      * Can only be called by the current owner.
85      */
86     function transferOwnership(address newOwner) public virtual onlyOwner {
87         require(newOwner != address(0), "Ownable: new owner is the zero address");
88         _transferOwnership(newOwner);
89     }
90 
91     /**
92      * @dev Transfers ownership of the contract to a new account (`newOwner`).
93      * Internal function without access restriction.
94      */
95     function _transferOwnership(address newOwner) internal virtual {
96         address oldOwner = _owner;
97         _owner = newOwner;
98         emit OwnershipTransferred(oldOwner, newOwner);
99     }
100 }
101 
102 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC1155/extensions/ERC1155Burnable.sol)
103 
104 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC1155/ERC1155.sol)
105 
106 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC1155/IERC1155.sol)
107 
108 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
109 
110 /**
111  * @dev Interface of the ERC165 standard, as defined in the
112  * https://eips.ethereum.org/EIPS/eip-165[EIP].
113  *
114  * Implementers can declare support of contract interfaces, which can then be
115  * queried by others ({ERC165Checker}).
116  *
117  * For an implementation, see {ERC165}.
118  */
119 interface IERC165 {
120     /**
121      * @dev Returns true if this contract implements the interface defined by
122      * `interfaceId`. See the corresponding
123      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
124      * to learn more about how these ids are created.
125      *
126      * This function call must use less than 30 000 gas.
127      */
128     function supportsInterface(bytes4 interfaceId) external view returns (bool);
129 }
130 
131 /**
132  * @dev Required interface of an ERC1155 compliant contract, as defined in the
133  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
134  *
135  * _Available since v3.1._
136  */
137 interface IERC1155 is IERC165 {
138     /**
139      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
140      */
141     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
142 
143     /**
144      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
145      * transfers.
146      */
147     event TransferBatch(
148         address indexed operator,
149         address indexed from,
150         address indexed to,
151         uint256[] ids,
152         uint256[] values
153     );
154 
155     /**
156      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
157      * `approved`.
158      */
159     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
160 
161     /**
162      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
163      *
164      * If an {URI} event was emitted for `id`, the standard
165      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
166      * returned by {IERC1155MetadataURI-uri}.
167      */
168     event URI(string value, uint256 indexed id);
169 
170     /**
171      * @dev Returns the amount of tokens of token type `id` owned by `account`.
172      *
173      * Requirements:
174      *
175      * - `account` cannot be the zero address.
176      */
177     function balanceOf(address account, uint256 id) external view returns (uint256);
178 
179     /**
180      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
181      *
182      * Requirements:
183      *
184      * - `accounts` and `ids` must have the same length.
185      */
186     function balanceOfBatch(
187         address[] calldata accounts,
188         uint256[] calldata ids
189     ) external view returns (uint256[] memory);
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
207     function isApprovedForAll(address account, address operator) external view returns (bool);
208 
209     /**
210      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
211      *
212      * Emits a {TransferSingle} event.
213      *
214      * Requirements:
215      *
216      * - `to` cannot be the zero address.
217      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
218      * - `from` must have a balance of tokens of type `id` of at least `amount`.
219      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
220      * acceptance magic value.
221      */
222     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
223 
224     /**
225      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
226      *
227      * Emits a {TransferBatch} event.
228      *
229      * Requirements:
230      *
231      * - `ids` and `amounts` must have the same length.
232      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
233      * acceptance magic value.
234      */
235     function safeBatchTransferFrom(
236         address from,
237         address to,
238         uint256[] calldata ids,
239         uint256[] calldata amounts,
240         bytes calldata data
241     ) external;
242 }
243 
244 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
245 
246 /**
247  * @dev _Available since v3.1._
248  */
249 interface IERC1155Receiver is IERC165 {
250     /**
251      * @dev Handles the receipt of a single ERC1155 token type. This function is
252      * called at the end of a `safeTransferFrom` after the balance has been updated.
253      *
254      * NOTE: To accept the transfer, this must return
255      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
256      * (i.e. 0xf23a6e61, or its own function selector).
257      *
258      * @param operator The address which initiated the transfer (i.e. msg.sender)
259      * @param from The address which previously owned the token
260      * @param id The ID of the token being transferred
261      * @param value The amount of tokens being transferred
262      * @param data Additional data with no specified format
263      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
264      */
265     function onERC1155Received(
266         address operator,
267         address from,
268         uint256 id,
269         uint256 value,
270         bytes calldata data
271     ) external returns (bytes4);
272 
273     /**
274      * @dev Handles the receipt of a multiple ERC1155 token types. This function
275      * is called at the end of a `safeBatchTransferFrom` after the balances have
276      * been updated.
277      *
278      * NOTE: To accept the transfer(s), this must return
279      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
280      * (i.e. 0xbc197c81, or its own function selector).
281      *
282      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
283      * @param from The address which previously owned the token
284      * @param ids An array containing ids of each token being transferred (order and length must match values array)
285      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
286      * @param data Additional data with no specified format
287      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
288      */
289     function onERC1155BatchReceived(
290         address operator,
291         address from,
292         uint256[] calldata ids,
293         uint256[] calldata values,
294         bytes calldata data
295     ) external returns (bytes4);
296 }
297 
298 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
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
316 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Address.sol)
317 
318 /**
319  * @dev Collection of functions related to the address type
320  */
321 library Address {
322     /**
323      * @dev Returns true if `account` is a contract.
324      *
325      * [IMPORTANT]
326      * ====
327      * It is unsafe to assume that an address for which this function returns
328      * false is an externally-owned account (EOA) and not a contract.
329      *
330      * Among others, `isContract` will return false for the following
331      * types of addresses:
332      *
333      *  - an externally-owned account
334      *  - a contract in construction
335      *  - an address where a contract will be created
336      *  - an address where a contract lived, but was destroyed
337      *
338      * Furthermore, `isContract` will also return true if the target contract within
339      * the same transaction is already scheduled for destruction by `SELFDESTRUCT`,
340      * which only has an effect at the end of a transaction.
341      * ====
342      *
343      * [IMPORTANT]
344      * ====
345      * You shouldn't rely on `isContract` to protect against flash loan attacks!
346      *
347      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
348      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
349      * constructor.
350      * ====
351      */
352     function isContract(address account) internal view returns (bool) {
353         // This method relies on extcodesize/address.code.length, which returns 0
354         // for contracts in construction, since the code is only stored at the end
355         // of the constructor execution.
356 
357         return account.code.length > 0;
358     }
359 
360     /**
361      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
362      * `recipient`, forwarding all available gas and reverting on errors.
363      *
364      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
365      * of certain opcodes, possibly making contracts go over the 2300 gas limit
366      * imposed by `transfer`, making them unable to receive funds via
367      * `transfer`. {sendValue} removes this limitation.
368      *
369      * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
370      *
371      * IMPORTANT: because control is transferred to `recipient`, care must be
372      * taken to not create reentrancy vulnerabilities. Consider using
373      * {ReentrancyGuard} or the
374      * https://solidity.readthedocs.io/en/v0.8.0/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
375      */
376     function sendValue(address payable recipient, uint256 amount) internal {
377         require(address(this).balance >= amount, "Address: insufficient balance");
378 
379         (bool success, ) = recipient.call{value: amount}("");
380         require(success, "Address: unable to send value, recipient may have reverted");
381     }
382 
383     /**
384      * @dev Performs a Solidity function call using a low level `call`. A
385      * plain `call` is an unsafe replacement for a function call: use this
386      * function instead.
387      *
388      * If `target` reverts with a revert reason, it is bubbled up by this
389      * function (like regular Solidity function calls).
390      *
391      * Returns the raw returned data. To convert to the expected return value,
392      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
393      *
394      * Requirements:
395      *
396      * - `target` must be a contract.
397      * - calling `target` with `data` must not revert.
398      *
399      * _Available since v3.1._
400      */
401     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
402         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
407      * `errorMessage` as a fallback revert reason when `target` reverts.
408      *
409      * _Available since v3.1._
410      */
411     function functionCall(
412         address target,
413         bytes memory data,
414         string memory errorMessage
415     ) internal returns (bytes memory) {
416         return functionCallWithValue(target, data, 0, errorMessage);
417     }
418 
419     /**
420      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
421      * but also transferring `value` wei to `target`.
422      *
423      * Requirements:
424      *
425      * - the calling contract must have an ETH balance of at least `value`.
426      * - the called Solidity function must be `payable`.
427      *
428      * _Available since v3.1._
429      */
430     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
431         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
436      * with `errorMessage` as a fallback revert reason when `target` reverts.
437      *
438      * _Available since v3.1._
439      */
440     function functionCallWithValue(
441         address target,
442         bytes memory data,
443         uint256 value,
444         string memory errorMessage
445     ) internal returns (bytes memory) {
446         require(address(this).balance >= value, "Address: insufficient balance for call");
447         (bool success, bytes memory returndata) = target.call{value: value}(data);
448         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
449     }
450 
451     /**
452      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
453      * but performing a static call.
454      *
455      * _Available since v3.3._
456      */
457     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
458         return functionStaticCall(target, data, "Address: low-level static call failed");
459     }
460 
461     /**
462      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
463      * but performing a static call.
464      *
465      * _Available since v3.3._
466      */
467     function functionStaticCall(
468         address target,
469         bytes memory data,
470         string memory errorMessage
471     ) internal view returns (bytes memory) {
472         (bool success, bytes memory returndata) = target.staticcall(data);
473         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
474     }
475 
476     /**
477      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
478      * but performing a delegate call.
479      *
480      * _Available since v3.4._
481      */
482     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
483         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
484     }
485 
486     /**
487      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
488      * but performing a delegate call.
489      *
490      * _Available since v3.4._
491      */
492     function functionDelegateCall(
493         address target,
494         bytes memory data,
495         string memory errorMessage
496     ) internal returns (bytes memory) {
497         (bool success, bytes memory returndata) = target.delegatecall(data);
498         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
499     }
500 
501     /**
502      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
503      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
504      *
505      * _Available since v4.8._
506      */
507     function verifyCallResultFromTarget(
508         address target,
509         bool success,
510         bytes memory returndata,
511         string memory errorMessage
512     ) internal view returns (bytes memory) {
513         if (success) {
514             if (returndata.length == 0) {
515                 // only check isContract if the call was successful and the return data is empty
516                 // otherwise we already know that it was a contract
517                 require(isContract(target), "Address: call to non-contract");
518             }
519             return returndata;
520         } else {
521             _revert(returndata, errorMessage);
522         }
523     }
524 
525     /**
526      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
527      * revert reason or using the provided one.
528      *
529      * _Available since v4.3._
530      */
531     function verifyCallResult(
532         bool success,
533         bytes memory returndata,
534         string memory errorMessage
535     ) internal pure returns (bytes memory) {
536         if (success) {
537             return returndata;
538         } else {
539             _revert(returndata, errorMessage);
540         }
541     }
542 
543     function _revert(bytes memory returndata, string memory errorMessage) private pure {
544         // Look for revert reason and bubble it up if present
545         if (returndata.length > 0) {
546             // The easiest way to bubble the revert reason is using memory via assembly
547             /// @solidity memory-safe-assembly
548             assembly {
549                 let returndata_size := mload(returndata)
550                 revert(add(32, returndata), returndata_size)
551             }
552         } else {
553             revert(errorMessage);
554         }
555     }
556 }
557 
558 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
559 
560 /**
561  * @dev Implementation of the {IERC165} interface.
562  *
563  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
564  * for the additional interface id that will be supported. For example:
565  *
566  * ```solidity
567  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
568  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
569  * }
570  * ```
571  *
572  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
573  */
574 abstract contract ERC165 is IERC165 {
575     /**
576      * @dev See {IERC165-supportsInterface}.
577      */
578     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
579         return interfaceId == type(IERC165).interfaceId;
580     }
581 }
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
641         require(account != address(0), "ERC1155: address zero is not a valid owner");
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
652     function balanceOfBatch(
653         address[] memory accounts,
654         uint256[] memory ids
655     ) public view virtual override returns (uint256[] memory) {
656         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
657 
658         uint256[] memory batchBalances = new uint256[](accounts.length);
659 
660         for (uint256 i = 0; i < accounts.length; ++i) {
661             batchBalances[i] = balanceOf(accounts[i], ids[i]);
662         }
663 
664         return batchBalances;
665     }
666 
667     /**
668      * @dev See {IERC1155-setApprovalForAll}.
669      */
670     function setApprovalForAll(address operator, bool approved) public virtual override {
671         _setApprovalForAll(_msgSender(), operator, approved);
672     }
673 
674     /**
675      * @dev See {IERC1155-isApprovedForAll}.
676      */
677     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
678         return _operatorApprovals[account][operator];
679     }
680 
681     /**
682      * @dev See {IERC1155-safeTransferFrom}.
683      */
684     function safeTransferFrom(
685         address from,
686         address to,
687         uint256 id,
688         uint256 amount,
689         bytes memory data
690     ) public virtual override {
691         require(
692             from == _msgSender() || isApprovedForAll(from, _msgSender()),
693             "ERC1155: caller is not token owner or approved"
694         );
695         _safeTransferFrom(from, to, id, amount, data);
696     }
697 
698     /**
699      * @dev See {IERC1155-safeBatchTransferFrom}.
700      */
701     function safeBatchTransferFrom(
702         address from,
703         address to,
704         uint256[] memory ids,
705         uint256[] memory amounts,
706         bytes memory data
707     ) public virtual override {
708         require(
709             from == _msgSender() || isApprovedForAll(from, _msgSender()),
710             "ERC1155: caller is not token owner or approved"
711         );
712         _safeBatchTransferFrom(from, to, ids, amounts, data);
713     }
714 
715     /**
716      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
717      *
718      * Emits a {TransferSingle} event.
719      *
720      * Requirements:
721      *
722      * - `to` cannot be the zero address.
723      * - `from` must have a balance of tokens of type `id` of at least `amount`.
724      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
725      * acceptance magic value.
726      */
727     function _safeTransferFrom(
728         address from,
729         address to,
730         uint256 id,
731         uint256 amount,
732         bytes memory data
733     ) internal virtual {
734         require(to != address(0), "ERC1155: transfer to the zero address");
735 
736         address operator = _msgSender();
737         uint256[] memory ids = _asSingletonArray(id);
738         uint256[] memory amounts = _asSingletonArray(amount);
739 
740         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
741 
742         uint256 fromBalance = _balances[id][from];
743         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
744         unchecked {
745             _balances[id][from] = fromBalance - amount;
746         }
747         _balances[id][to] += amount;
748 
749         emit TransferSingle(operator, from, to, id, amount);
750 
751         _afterTokenTransfer(operator, from, to, ids, amounts, data);
752 
753         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
754     }
755 
756     /**
757      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
758      *
759      * Emits a {TransferBatch} event.
760      *
761      * Requirements:
762      *
763      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
764      * acceptance magic value.
765      */
766     function _safeBatchTransferFrom(
767         address from,
768         address to,
769         uint256[] memory ids,
770         uint256[] memory amounts,
771         bytes memory data
772     ) internal virtual {
773         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
774         require(to != address(0), "ERC1155: transfer to the zero address");
775 
776         address operator = _msgSender();
777 
778         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
779 
780         for (uint256 i = 0; i < ids.length; ++i) {
781             uint256 id = ids[i];
782             uint256 amount = amounts[i];
783 
784             uint256 fromBalance = _balances[id][from];
785             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
786             unchecked {
787                 _balances[id][from] = fromBalance - amount;
788             }
789             _balances[id][to] += amount;
790         }
791 
792         emit TransferBatch(operator, from, to, ids, amounts);
793 
794         _afterTokenTransfer(operator, from, to, ids, amounts, data);
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
823      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
824      *
825      * Emits a {TransferSingle} event.
826      *
827      * Requirements:
828      *
829      * - `to` cannot be the zero address.
830      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
831      * acceptance magic value.
832      */
833     function _mint(address to, uint256 id, uint256 amount, bytes memory data) internal virtual {
834         require(to != address(0), "ERC1155: mint to the zero address");
835 
836         address operator = _msgSender();
837         uint256[] memory ids = _asSingletonArray(id);
838         uint256[] memory amounts = _asSingletonArray(amount);
839 
840         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
841 
842         _balances[id][to] += amount;
843         emit TransferSingle(operator, address(0), to, id, amount);
844 
845         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
846 
847         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
848     }
849 
850     /**
851      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
852      *
853      * Emits a {TransferBatch} event.
854      *
855      * Requirements:
856      *
857      * - `ids` and `amounts` must have the same length.
858      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
859      * acceptance magic value.
860      */
861     function _mintBatch(
862         address to,
863         uint256[] memory ids,
864         uint256[] memory amounts,
865         bytes memory data
866     ) internal virtual {
867         require(to != address(0), "ERC1155: mint to the zero address");
868         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
869 
870         address operator = _msgSender();
871 
872         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
873 
874         for (uint256 i = 0; i < ids.length; i++) {
875             _balances[ids[i]][to] += amounts[i];
876         }
877 
878         emit TransferBatch(operator, address(0), to, ids, amounts);
879 
880         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
881 
882         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
883     }
884 
885     /**
886      * @dev Destroys `amount` tokens of token type `id` from `from`
887      *
888      * Emits a {TransferSingle} event.
889      *
890      * Requirements:
891      *
892      * - `from` cannot be the zero address.
893      * - `from` must have at least `amount` tokens of token type `id`.
894      */
895     function _burn(address from, uint256 id, uint256 amount) internal virtual {
896         require(from != address(0), "ERC1155: burn from the zero address");
897 
898         address operator = _msgSender();
899         uint256[] memory ids = _asSingletonArray(id);
900         uint256[] memory amounts = _asSingletonArray(amount);
901 
902         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
903 
904         uint256 fromBalance = _balances[id][from];
905         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
906         unchecked {
907             _balances[id][from] = fromBalance - amount;
908         }
909 
910         emit TransferSingle(operator, from, address(0), id, amount);
911 
912         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
913     }
914 
915     /**
916      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
917      *
918      * Emits a {TransferBatch} event.
919      *
920      * Requirements:
921      *
922      * - `ids` and `amounts` must have the same length.
923      */
924     function _burnBatch(address from, uint256[] memory ids, uint256[] memory amounts) internal virtual {
925         require(from != address(0), "ERC1155: burn from the zero address");
926         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
927 
928         address operator = _msgSender();
929 
930         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
931 
932         for (uint256 i = 0; i < ids.length; i++) {
933             uint256 id = ids[i];
934             uint256 amount = amounts[i];
935 
936             uint256 fromBalance = _balances[id][from];
937             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
938             unchecked {
939                 _balances[id][from] = fromBalance - amount;
940             }
941         }
942 
943         emit TransferBatch(operator, from, address(0), ids, amounts);
944 
945         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
946     }
947 
948     /**
949      * @dev Approve `operator` to operate on all of `owner` tokens
950      *
951      * Emits an {ApprovalForAll} event.
952      */
953     function _setApprovalForAll(address owner, address operator, bool approved) internal virtual {
954         require(owner != operator, "ERC1155: setting approval status for self");
955         _operatorApprovals[owner][operator] = approved;
956         emit ApprovalForAll(owner, operator, approved);
957     }
958 
959     /**
960      * @dev Hook that is called before any token transfer. This includes minting
961      * and burning, as well as batched variants.
962      *
963      * The same hook is called on both single and batched variants. For single
964      * transfers, the length of the `ids` and `amounts` arrays will be 1.
965      *
966      * Calling conditions (for each `id` and `amount` pair):
967      *
968      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
969      * of token type `id` will be  transferred to `to`.
970      * - When `from` is zero, `amount` tokens of token type `id` will be minted
971      * for `to`.
972      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
973      * will be burned.
974      * - `from` and `to` are never both zero.
975      * - `ids` and `amounts` have the same, non-zero length.
976      *
977      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
978      */
979     function _beforeTokenTransfer(
980         address operator,
981         address from,
982         address to,
983         uint256[] memory ids,
984         uint256[] memory amounts,
985         bytes memory data
986     ) internal virtual {}
987 
988     /**
989      * @dev Hook that is called after any token transfer. This includes minting
990      * and burning, as well as batched variants.
991      *
992      * The same hook is called on both single and batched variants. For single
993      * transfers, the length of the `id` and `amount` arrays will be 1.
994      *
995      * Calling conditions (for each `id` and `amount` pair):
996      *
997      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
998      * of token type `id` will be  transferred to `to`.
999      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1000      * for `to`.
1001      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1002      * will be burned.
1003      * - `from` and `to` are never both zero.
1004      * - `ids` and `amounts` have the same, non-zero length.
1005      *
1006      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1007      */
1008     function _afterTokenTransfer(
1009         address operator,
1010         address from,
1011         address to,
1012         uint256[] memory ids,
1013         uint256[] memory amounts,
1014         bytes memory data
1015     ) internal virtual {}
1016 
1017     function _doSafeTransferAcceptanceCheck(
1018         address operator,
1019         address from,
1020         address to,
1021         uint256 id,
1022         uint256 amount,
1023         bytes memory data
1024     ) private {
1025         if (to.isContract()) {
1026             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1027                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1028                     revert("ERC1155: ERC1155Receiver rejected tokens");
1029                 }
1030             } catch Error(string memory reason) {
1031                 revert(reason);
1032             } catch {
1033                 revert("ERC1155: transfer to non-ERC1155Receiver implementer");
1034             }
1035         }
1036     }
1037 
1038     function _doSafeBatchTransferAcceptanceCheck(
1039         address operator,
1040         address from,
1041         address to,
1042         uint256[] memory ids,
1043         uint256[] memory amounts,
1044         bytes memory data
1045     ) private {
1046         if (to.isContract()) {
1047             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1048                 bytes4 response
1049             ) {
1050                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1051                     revert("ERC1155: ERC1155Receiver rejected tokens");
1052                 }
1053             } catch Error(string memory reason) {
1054                 revert(reason);
1055             } catch {
1056                 revert("ERC1155: transfer to non-ERC1155Receiver implementer");
1057             }
1058         }
1059     }
1060 
1061     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1062         uint256[] memory array = new uint256[](1);
1063         array[0] = element;
1064 
1065         return array;
1066     }
1067 }
1068 
1069 /**
1070  * @dev Extension of {ERC1155} that allows token holders to destroy both their
1071  * own tokens and those that they have been approved to use.
1072  *
1073  * _Available since v3.1._
1074  */
1075 abstract contract ERC1155Burnable is ERC1155 {
1076     function burn(address account, uint256 id, uint256 value) public virtual {
1077         require(
1078             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1079             "ERC1155: caller is not token owner or approved"
1080         );
1081 
1082         _burn(account, id, value);
1083     }
1084 
1085     function burnBatch(address account, uint256[] memory ids, uint256[] memory values) public virtual {
1086         require(
1087             account == _msgSender() || isApprovedForAll(account, _msgSender()),
1088             "ERC1155: caller is not token owner or approved"
1089         );
1090 
1091         _burnBatch(account, ids, values);
1092     }
1093 }
1094 
1095 // OpenZeppelin Contracts (last updated v4.9.0) (utils/cryptography/ECDSA.sol)
1096 
1097 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Strings.sol)
1098 
1099 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)
1100 
1101 /**
1102  * @dev Standard math utilities missing in the Solidity language.
1103  */
1104 library Math {
1105     enum Rounding {
1106         Down, // Toward negative infinity
1107         Up, // Toward infinity
1108         Zero // Toward zero
1109     }
1110 
1111     /**
1112      * @dev Returns the largest of two numbers.
1113      */
1114     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1115         return a > b ? a : b;
1116     }
1117 
1118     /**
1119      * @dev Returns the smallest of two numbers.
1120      */
1121     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1122         return a < b ? a : b;
1123     }
1124 
1125     /**
1126      * @dev Returns the average of two numbers. The result is rounded towards
1127      * zero.
1128      */
1129     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1130         // (a + b) / 2 can overflow.
1131         return (a & b) + (a ^ b) / 2;
1132     }
1133 
1134     /**
1135      * @dev Returns the ceiling of the division of two numbers.
1136      *
1137      * This differs from standard division with `/` in that it rounds up instead
1138      * of rounding down.
1139      */
1140     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1141         // (a + b - 1) / b can overflow on addition, so we distribute.
1142         return a == 0 ? 0 : (a - 1) / b + 1;
1143     }
1144 
1145     /**
1146      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1147      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1148      * with further edits by Uniswap Labs also under MIT license.
1149      */
1150     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
1151         unchecked {
1152             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1153             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1154             // variables such that product = prod1 * 2^256 + prod0.
1155             uint256 prod0; // Least significant 256 bits of the product
1156             uint256 prod1; // Most significant 256 bits of the product
1157             assembly {
1158                 let mm := mulmod(x, y, not(0))
1159                 prod0 := mul(x, y)
1160                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1161             }
1162 
1163             // Handle non-overflow cases, 256 by 256 division.
1164             if (prod1 == 0) {
1165                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
1166                 // The surrounding unchecked block does not change this fact.
1167                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
1168                 return prod0 / denominator;
1169             }
1170 
1171             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1172             require(denominator > prod1, "Math: mulDiv overflow");
1173 
1174             ///////////////////////////////////////////////
1175             // 512 by 256 division.
1176             ///////////////////////////////////////////////
1177 
1178             // Make division exact by subtracting the remainder from [prod1 prod0].
1179             uint256 remainder;
1180             assembly {
1181                 // Compute remainder using mulmod.
1182                 remainder := mulmod(x, y, denominator)
1183 
1184                 // Subtract 256 bit number from 512 bit number.
1185                 prod1 := sub(prod1, gt(remainder, prod0))
1186                 prod0 := sub(prod0, remainder)
1187             }
1188 
1189             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1190             // See https://cs.stackexchange.com/q/138556/92363.
1191 
1192             // Does not overflow because the denominator cannot be zero at this stage in the function.
1193             uint256 twos = denominator & (~denominator + 1);
1194             assembly {
1195                 // Divide denominator by twos.
1196                 denominator := div(denominator, twos)
1197 
1198                 // Divide [prod1 prod0] by twos.
1199                 prod0 := div(prod0, twos)
1200 
1201                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1202                 twos := add(div(sub(0, twos), twos), 1)
1203             }
1204 
1205             // Shift in bits from prod1 into prod0.
1206             prod0 |= prod1 * twos;
1207 
1208             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1209             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1210             // four bits. That is, denominator * inv = 1 mod 2^4.
1211             uint256 inverse = (3 * denominator) ^ 2;
1212 
1213             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1214             // in modular arithmetic, doubling the correct bits in each step.
1215             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1216             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1217             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1218             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1219             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1220             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1221 
1222             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1223             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1224             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1225             // is no longer required.
1226             result = prod0 * inverse;
1227             return result;
1228         }
1229     }
1230 
1231     /**
1232      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1233      */
1234     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
1235         uint256 result = mulDiv(x, y, denominator);
1236         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1237             result += 1;
1238         }
1239         return result;
1240     }
1241 
1242     /**
1243      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
1244      *
1245      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1246      */
1247     function sqrt(uint256 a) internal pure returns (uint256) {
1248         if (a == 0) {
1249             return 0;
1250         }
1251 
1252         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1253         //
1254         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1255         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
1256         //
1257         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
1258         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
1259         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
1260         //
1261         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
1262         uint256 result = 1 << (log2(a) >> 1);
1263 
1264         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1265         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1266         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1267         // into the expected uint128 result.
1268         unchecked {
1269             result = (result + a / result) >> 1;
1270             result = (result + a / result) >> 1;
1271             result = (result + a / result) >> 1;
1272             result = (result + a / result) >> 1;
1273             result = (result + a / result) >> 1;
1274             result = (result + a / result) >> 1;
1275             result = (result + a / result) >> 1;
1276             return min(result, a / result);
1277         }
1278     }
1279 
1280     /**
1281      * @notice Calculates sqrt(a), following the selected rounding direction.
1282      */
1283     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1284         unchecked {
1285             uint256 result = sqrt(a);
1286             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
1287         }
1288     }
1289 
1290     /**
1291      * @dev Return the log in base 2, rounded down, of a positive value.
1292      * Returns 0 if given 0.
1293      */
1294     function log2(uint256 value) internal pure returns (uint256) {
1295         uint256 result = 0;
1296         unchecked {
1297             if (value >> 128 > 0) {
1298                 value >>= 128;
1299                 result += 128;
1300             }
1301             if (value >> 64 > 0) {
1302                 value >>= 64;
1303                 result += 64;
1304             }
1305             if (value >> 32 > 0) {
1306                 value >>= 32;
1307                 result += 32;
1308             }
1309             if (value >> 16 > 0) {
1310                 value >>= 16;
1311                 result += 16;
1312             }
1313             if (value >> 8 > 0) {
1314                 value >>= 8;
1315                 result += 8;
1316             }
1317             if (value >> 4 > 0) {
1318                 value >>= 4;
1319                 result += 4;
1320             }
1321             if (value >> 2 > 0) {
1322                 value >>= 2;
1323                 result += 2;
1324             }
1325             if (value >> 1 > 0) {
1326                 result += 1;
1327             }
1328         }
1329         return result;
1330     }
1331 
1332     /**
1333      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1334      * Returns 0 if given 0.
1335      */
1336     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1337         unchecked {
1338             uint256 result = log2(value);
1339             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1340         }
1341     }
1342 
1343     /**
1344      * @dev Return the log in base 10, rounded down, of a positive value.
1345      * Returns 0 if given 0.
1346      */
1347     function log10(uint256 value) internal pure returns (uint256) {
1348         uint256 result = 0;
1349         unchecked {
1350             if (value >= 10 ** 64) {
1351                 value /= 10 ** 64;
1352                 result += 64;
1353             }
1354             if (value >= 10 ** 32) {
1355                 value /= 10 ** 32;
1356                 result += 32;
1357             }
1358             if (value >= 10 ** 16) {
1359                 value /= 10 ** 16;
1360                 result += 16;
1361             }
1362             if (value >= 10 ** 8) {
1363                 value /= 10 ** 8;
1364                 result += 8;
1365             }
1366             if (value >= 10 ** 4) {
1367                 value /= 10 ** 4;
1368                 result += 4;
1369             }
1370             if (value >= 10 ** 2) {
1371                 value /= 10 ** 2;
1372                 result += 2;
1373             }
1374             if (value >= 10 ** 1) {
1375                 result += 1;
1376             }
1377         }
1378         return result;
1379     }
1380 
1381     /**
1382      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1383      * Returns 0 if given 0.
1384      */
1385     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1386         unchecked {
1387             uint256 result = log10(value);
1388             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
1389         }
1390     }
1391 
1392     /**
1393      * @dev Return the log in base 256, rounded down, of a positive value.
1394      * Returns 0 if given 0.
1395      *
1396      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1397      */
1398     function log256(uint256 value) internal pure returns (uint256) {
1399         uint256 result = 0;
1400         unchecked {
1401             if (value >> 128 > 0) {
1402                 value >>= 128;
1403                 result += 16;
1404             }
1405             if (value >> 64 > 0) {
1406                 value >>= 64;
1407                 result += 8;
1408             }
1409             if (value >> 32 > 0) {
1410                 value >>= 32;
1411                 result += 4;
1412             }
1413             if (value >> 16 > 0) {
1414                 value >>= 16;
1415                 result += 2;
1416             }
1417             if (value >> 8 > 0) {
1418                 result += 1;
1419             }
1420         }
1421         return result;
1422     }
1423 
1424     /**
1425      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
1426      * Returns 0 if given 0.
1427      */
1428     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1429         unchecked {
1430             uint256 result = log256(value);
1431             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
1432         }
1433     }
1434 }
1435 
1436 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)
1437 
1438 /**
1439  * @dev Standard signed math utilities missing in the Solidity language.
1440  */
1441 library SignedMath {
1442     /**
1443      * @dev Returns the largest of two signed numbers.
1444      */
1445     function max(int256 a, int256 b) internal pure returns (int256) {
1446         return a > b ? a : b;
1447     }
1448 
1449     /**
1450      * @dev Returns the smallest of two signed numbers.
1451      */
1452     function min(int256 a, int256 b) internal pure returns (int256) {
1453         return a < b ? a : b;
1454     }
1455 
1456     /**
1457      * @dev Returns the average of two signed numbers without overflow.
1458      * The result is rounded towards zero.
1459      */
1460     function average(int256 a, int256 b) internal pure returns (int256) {
1461         // Formula from the book "Hacker's Delight"
1462         int256 x = (a & b) + ((a ^ b) >> 1);
1463         return x + (int256(uint256(x) >> 255) & (a ^ b));
1464     }
1465 
1466     /**
1467      * @dev Returns the absolute unsigned value of a signed value.
1468      */
1469     function abs(int256 n) internal pure returns (uint256) {
1470         unchecked {
1471             // must be unchecked in order to support `n = type(int256).min`
1472             return uint256(n >= 0 ? n : -n);
1473         }
1474     }
1475 }
1476 
1477 /**
1478  * @dev String operations.
1479  */
1480 library Strings {
1481     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1482     uint8 private constant _ADDRESS_LENGTH = 20;
1483 
1484     /**
1485      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1486      */
1487     function toString(uint256 value) internal pure returns (string memory) {
1488         unchecked {
1489             uint256 length = Math.log10(value) + 1;
1490             string memory buffer = new string(length);
1491             uint256 ptr;
1492             /// @solidity memory-safe-assembly
1493             assembly {
1494                 ptr := add(buffer, add(32, length))
1495             }
1496             while (true) {
1497                 ptr--;
1498                 /// @solidity memory-safe-assembly
1499                 assembly {
1500                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1501                 }
1502                 value /= 10;
1503                 if (value == 0) break;
1504             }
1505             return buffer;
1506         }
1507     }
1508 
1509     /**
1510      * @dev Converts a `int256` to its ASCII `string` decimal representation.
1511      */
1512     function toString(int256 value) internal pure returns (string memory) {
1513         return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
1514     }
1515 
1516     /**
1517      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1518      */
1519     function toHexString(uint256 value) internal pure returns (string memory) {
1520         unchecked {
1521             return toHexString(value, Math.log256(value) + 1);
1522         }
1523     }
1524 
1525     /**
1526      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1527      */
1528     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1529         bytes memory buffer = new bytes(2 * length + 2);
1530         buffer[0] = "0";
1531         buffer[1] = "x";
1532         for (uint256 i = 2 * length + 1; i > 1; --i) {
1533             buffer[i] = _SYMBOLS[value & 0xf];
1534             value >>= 4;
1535         }
1536         require(value == 0, "Strings: hex length insufficient");
1537         return string(buffer);
1538     }
1539 
1540     /**
1541      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1542      */
1543     function toHexString(address addr) internal pure returns (string memory) {
1544         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1545     }
1546 
1547     /**
1548      * @dev Returns true if the two strings are equal.
1549      */
1550     function equal(string memory a, string memory b) internal pure returns (bool) {
1551         return keccak256(bytes(a)) == keccak256(bytes(b));
1552     }
1553 }
1554 
1555 /**
1556  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1557  *
1558  * These functions can be used to verify that a message was signed by the holder
1559  * of the private keys of a given address.
1560  */
1561 library ECDSA {
1562     enum RecoverError {
1563         NoError,
1564         InvalidSignature,
1565         InvalidSignatureLength,
1566         InvalidSignatureS,
1567         InvalidSignatureV // Deprecated in v4.8
1568     }
1569 
1570     function _throwError(RecoverError error) private pure {
1571         if (error == RecoverError.NoError) {
1572             return; // no error: do nothing
1573         } else if (error == RecoverError.InvalidSignature) {
1574             revert("ECDSA: invalid signature");
1575         } else if (error == RecoverError.InvalidSignatureLength) {
1576             revert("ECDSA: invalid signature length");
1577         } else if (error == RecoverError.InvalidSignatureS) {
1578             revert("ECDSA: invalid signature 's' value");
1579         }
1580     }
1581 
1582     /**
1583      * @dev Returns the address that signed a hashed message (`hash`) with
1584      * `signature` or error string. This address can then be used for verification purposes.
1585      *
1586      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1587      * this function rejects them by requiring the `s` value to be in the lower
1588      * half order, and the `v` value to be either 27 or 28.
1589      *
1590      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1591      * verification to be secure: it is possible to craft signatures that
1592      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1593      * this is by receiving a hash of the original message (which may otherwise
1594      * be too long), and then calling {toEthSignedMessageHash} on it.
1595      *
1596      * Documentation for signature generation:
1597      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1598      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1599      *
1600      * _Available since v4.3._
1601      */
1602     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1603         if (signature.length == 65) {
1604             bytes32 r;
1605             bytes32 s;
1606             uint8 v;
1607             // ecrecover takes the signature parameters, and the only way to get them
1608             // currently is to use assembly.
1609             /// @solidity memory-safe-assembly
1610             assembly {
1611                 r := mload(add(signature, 0x20))
1612                 s := mload(add(signature, 0x40))
1613                 v := byte(0, mload(add(signature, 0x60)))
1614             }
1615             return tryRecover(hash, v, r, s);
1616         } else {
1617             return (address(0), RecoverError.InvalidSignatureLength);
1618         }
1619     }
1620 
1621     /**
1622      * @dev Returns the address that signed a hashed message (`hash`) with
1623      * `signature`. This address can then be used for verification purposes.
1624      *
1625      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1626      * this function rejects them by requiring the `s` value to be in the lower
1627      * half order, and the `v` value to be either 27 or 28.
1628      *
1629      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1630      * verification to be secure: it is possible to craft signatures that
1631      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1632      * this is by receiving a hash of the original message (which may otherwise
1633      * be too long), and then calling {toEthSignedMessageHash} on it.
1634      */
1635     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1636         (address recovered, RecoverError error) = tryRecover(hash, signature);
1637         _throwError(error);
1638         return recovered;
1639     }
1640 
1641     /**
1642      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1643      *
1644      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1645      *
1646      * _Available since v4.3._
1647      */
1648     function tryRecover(bytes32 hash, bytes32 r, bytes32 vs) internal pure returns (address, RecoverError) {
1649         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1650         uint8 v = uint8((uint256(vs) >> 255) + 27);
1651         return tryRecover(hash, v, r, s);
1652     }
1653 
1654     /**
1655      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1656      *
1657      * _Available since v4.2._
1658      */
1659     function recover(bytes32 hash, bytes32 r, bytes32 vs) internal pure returns (address) {
1660         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1661         _throwError(error);
1662         return recovered;
1663     }
1664 
1665     /**
1666      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1667      * `r` and `s` signature fields separately.
1668      *
1669      * _Available since v4.3._
1670      */
1671     function tryRecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address, RecoverError) {
1672         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1673         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1674         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1675         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1676         //
1677         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1678         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1679         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1680         // these malleable signatures as well.
1681         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1682             return (address(0), RecoverError.InvalidSignatureS);
1683         }
1684 
1685         // If the signature is valid (and not malleable), return the signer address
1686         address signer = ecrecover(hash, v, r, s);
1687         if (signer == address(0)) {
1688             return (address(0), RecoverError.InvalidSignature);
1689         }
1690 
1691         return (signer, RecoverError.NoError);
1692     }
1693 
1694     /**
1695      * @dev Overload of {ECDSA-recover} that receives the `v`,
1696      * `r` and `s` signature fields separately.
1697      */
1698     function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
1699         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1700         _throwError(error);
1701         return recovered;
1702     }
1703 
1704     /**
1705      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1706      * produces hash corresponding to the one signed with the
1707      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1708      * JSON-RPC method as part of EIP-191.
1709      *
1710      * See {recover}.
1711      */
1712     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32 message) {
1713         // 32 is the length in bytes of hash,
1714         // enforced by the type signature above
1715         /// @solidity memory-safe-assembly
1716         assembly {
1717             mstore(0x00, "\x19Ethereum Signed Message:\n32")
1718             mstore(0x1c, hash)
1719             message := keccak256(0x00, 0x3c)
1720         }
1721     }
1722 
1723     /**
1724      * @dev Returns an Ethereum Signed Message, created from `s`. This
1725      * produces hash corresponding to the one signed with the
1726      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1727      * JSON-RPC method as part of EIP-191.
1728      *
1729      * See {recover}.
1730      */
1731     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1732         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1733     }
1734 
1735     /**
1736      * @dev Returns an Ethereum Signed Typed Data, created from a
1737      * `domainSeparator` and a `structHash`. This produces hash corresponding
1738      * to the one signed with the
1739      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1740      * JSON-RPC method as part of EIP-712.
1741      *
1742      * See {recover}.
1743      */
1744     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32 data) {
1745         /// @solidity memory-safe-assembly
1746         assembly {
1747             let ptr := mload(0x40)
1748             mstore(ptr, "\x19\x01")
1749             mstore(add(ptr, 0x02), domainSeparator)
1750             mstore(add(ptr, 0x22), structHash)
1751             data := keccak256(ptr, 0x42)
1752         }
1753     }
1754 
1755     /**
1756      * @dev Returns an Ethereum Signed Data with intended validator, created from a
1757      * `validator` and `data` according to the version 0 of EIP-191.
1758      *
1759      * See {recover}.
1760      */
1761     function toDataWithIntendedValidatorHash(address validator, bytes memory data) internal pure returns (bytes32) {
1762         return keccak256(abi.encodePacked("\x19\x00", validator, data));
1763     }
1764 }
1765 
1766 interface IOperatorFilterRegistry {
1767     /**
1768      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
1769      *         true if supplied registrant address is not registered.
1770      */
1771     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1772 
1773     /**
1774      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
1775      */
1776     function register(address registrant) external;
1777 
1778     /**
1779      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
1780      */
1781     function registerAndSubscribe(address registrant, address subscription) external;
1782 
1783     /**
1784      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
1785      *         address without subscribing.
1786      */
1787     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1788 
1789     /**
1790      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
1791      *         Note that this does not remove any filtered addresses or codeHashes.
1792      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
1793      */
1794     function unregister(address addr) external;
1795 
1796     /**
1797      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
1798      */
1799     function updateOperator(address registrant, address operator, bool filtered) external;
1800 
1801     /**
1802      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
1803      */
1804     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1805 
1806     /**
1807      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
1808      */
1809     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1810 
1811     /**
1812      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
1813      */
1814     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1815 
1816     /**
1817      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
1818      *         subscription if present.
1819      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
1820      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
1821      *         used.
1822      */
1823     function subscribe(address registrant, address registrantToSubscribe) external;
1824 
1825     /**
1826      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
1827      */
1828     function unsubscribe(address registrant, bool copyExistingEntries) external;
1829 
1830     /**
1831      * @notice Get the subscription address of a given registrant, if any.
1832      */
1833     function subscriptionOf(address addr) external returns (address registrant);
1834 
1835     /**
1836      * @notice Get the set of addresses subscribed to a given registrant.
1837      *         Note that order is not guaranteed as updates are made.
1838      */
1839     function subscribers(address registrant) external returns (address[] memory);
1840 
1841     /**
1842      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
1843      *         Note that order is not guaranteed as updates are made.
1844      */
1845     function subscriberAt(address registrant, uint256 index) external returns (address);
1846 
1847     /**
1848      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
1849      */
1850     function copyEntriesOf(address registrant, address registrantToCopy) external;
1851 
1852     /**
1853      * @notice Returns true if operator is filtered by a given address or its subscription.
1854      */
1855     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1856 
1857     /**
1858      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
1859      */
1860     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1861 
1862     /**
1863      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
1864      */
1865     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1866 
1867     /**
1868      * @notice Returns a list of filtered operators for a given address or its subscription.
1869      */
1870     function filteredOperators(address addr) external returns (address[] memory);
1871 
1872     /**
1873      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
1874      *         Note that order is not guaranteed as updates are made.
1875      */
1876     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1877 
1878     /**
1879      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
1880      *         its subscription.
1881      *         Note that order is not guaranteed as updates are made.
1882      */
1883     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1884 
1885     /**
1886      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
1887      *         its subscription.
1888      *         Note that order is not guaranteed as updates are made.
1889      */
1890     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1891 
1892     /**
1893      * @notice Returns true if an address has registered
1894      */
1895     function isRegistered(address addr) external returns (bool);
1896 
1897     /**
1898      * @dev Convenience method to compute the code hash of an arbitrary contract
1899      */
1900     function codeHashOf(address addr) external returns (bytes32);
1901 }
1902 
1903 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
1904 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
1905 
1906 /**
1907  * @title  OperatorFilterer
1908  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1909  *         registrant's entries in the OperatorFilterRegistry.
1910  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1911  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1912  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1913  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
1914  *         administration methods on the contract itself to interact with the registry otherwise the subscription
1915  *         will be locked to the options set during construction.
1916  */
1917 
1918 abstract contract OperatorFilterer {
1919     /// @dev Emitted when an operator is not allowed.
1920     error OperatorNotAllowed(address operator);
1921 
1922     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1923         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
1924 
1925     /// @dev The constructor that is called when the contract is being deployed.
1926     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1927         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1928         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1929         // order for the modifier to filter addresses.
1930         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1931             if (subscribe) {
1932                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1933             } else {
1934                 if (subscriptionOrRegistrantToCopy != address(0)) {
1935                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1936                 } else {
1937                     OPERATOR_FILTER_REGISTRY.register(address(this));
1938                 }
1939             }
1940         }
1941     }
1942 
1943     /**
1944      * @dev A helper function to check if an operator is allowed.
1945      */
1946     modifier onlyAllowedOperator(address from) virtual {
1947         // Allow spending tokens from addresses with balance
1948         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1949         // from an EOA.
1950         if (from != msg.sender) {
1951             _checkFilterOperator(msg.sender);
1952         }
1953         _;
1954     }
1955 
1956     /**
1957      * @dev A helper function to check if an operator approval is allowed.
1958      */
1959     modifier onlyAllowedOperatorApproval(address operator) virtual {
1960         _checkFilterOperator(operator);
1961         _;
1962     }
1963 
1964     /**
1965      * @dev A helper function to check if an operator is allowed.
1966      */
1967     function _checkFilterOperator(address operator) internal view virtual {
1968         // Check registry code length to facilitate testing in environments without a deployed registry.
1969         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1970             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
1971             // may specify their own OperatorFilterRegistry implementations, which may behave differently
1972             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1973                 revert OperatorNotAllowed(operator);
1974             }
1975         }
1976     }
1977 }
1978 
1979 /**
1980  * @title  DefaultOperatorFilterer
1981  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1982  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
1983  *         administration methods on the contract itself to interact with the registry otherwise the subscription
1984  *         will be locked to the options set during construction.
1985  */
1986 
1987 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1988     /// @dev The constructor that is called when the contract is being deployed.
1989     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
1990 }
1991 
1992 // OpenZeppelin Contracts (last updated v4.9.0) (token/common/ERC2981.sol)
1993 
1994 // OpenZeppelin Contracts (last updated v4.9.0) (interfaces/IERC2981.sol)
1995 
1996 /**
1997  * @dev Interface for the NFT Royalty Standard.
1998  *
1999  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
2000  * support for royalty payments across all NFT marketplaces and ecosystem participants.
2001  *
2002  * _Available since v4.5._
2003  */
2004 interface IERC2981 is IERC165 {
2005     /**
2006      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
2007      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
2008      */
2009     function royaltyInfo(
2010         uint256 tokenId,
2011         uint256 salePrice
2012     ) external view returns (address receiver, uint256 royaltyAmount);
2013 }
2014 
2015 /**
2016  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
2017  *
2018  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
2019  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
2020  *
2021  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
2022  * fee is specified in basis points by default.
2023  *
2024  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
2025  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
2026  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
2027  *
2028  * _Available since v4.5._
2029  */
2030 abstract contract ERC2981 is IERC2981, ERC165 {
2031     struct RoyaltyInfo {
2032         address receiver;
2033         uint96 royaltyFraction;
2034     }
2035 
2036     RoyaltyInfo private _defaultRoyaltyInfo;
2037     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
2038 
2039     /**
2040      * @dev See {IERC165-supportsInterface}.
2041      */
2042     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
2043         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
2044     }
2045 
2046     /**
2047      * @inheritdoc IERC2981
2048      */
2049     function royaltyInfo(uint256 tokenId, uint256 salePrice) public view virtual override returns (address, uint256) {
2050         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[tokenId];
2051 
2052         if (royalty.receiver == address(0)) {
2053             royalty = _defaultRoyaltyInfo;
2054         }
2055 
2056         uint256 royaltyAmount = (salePrice * royalty.royaltyFraction) / _feeDenominator();
2057 
2058         return (royalty.receiver, royaltyAmount);
2059     }
2060 
2061     /**
2062      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
2063      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
2064      * override.
2065      */
2066     function _feeDenominator() internal pure virtual returns (uint96) {
2067         return 10000;
2068     }
2069 
2070     /**
2071      * @dev Sets the royalty information that all ids in this contract will default to.
2072      *
2073      * Requirements:
2074      *
2075      * - `receiver` cannot be the zero address.
2076      * - `feeNumerator` cannot be greater than the fee denominator.
2077      */
2078     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
2079         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
2080         require(receiver != address(0), "ERC2981: invalid receiver");
2081 
2082         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
2083     }
2084 
2085     /**
2086      * @dev Removes default royalty information.
2087      */
2088     function _deleteDefaultRoyalty() internal virtual {
2089         delete _defaultRoyaltyInfo;
2090     }
2091 
2092     /**
2093      * @dev Sets the royalty information for a specific token id, overriding the global default.
2094      *
2095      * Requirements:
2096      *
2097      * - `receiver` cannot be the zero address.
2098      * - `feeNumerator` cannot be greater than the fee denominator.
2099      */
2100     function _setTokenRoyalty(uint256 tokenId, address receiver, uint96 feeNumerator) internal virtual {
2101         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
2102         require(receiver != address(0), "ERC2981: Invalid parameters");
2103 
2104         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
2105     }
2106 
2107     /**
2108      * @dev Resets royalty information for the token id back to the global default.
2109      */
2110     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
2111         delete _tokenRoyaltyInfo[tokenId];
2112     }
2113 }
2114 
2115 struct Pack {
2116   uint256 tokenId;
2117   string name;
2118   uint256 amountAvailable;
2119   uint256 onSaleAt;
2120   uint256 saleEndsAt;
2121   bool isClaimable;
2122   uint256 price;
2123   uint8 traitsPerPack;
2124   string uri;
2125 }
2126 
2127 error MaxPerTransactionExceeded();
2128 error IncorrectAmountSent();
2129 error PackSoldOut();
2130 error SaleNotActive();
2131 error ZeroBalance();
2132 error PackNotClaimable();
2133 error InvalidSignature();
2134 error UnauthorizedSigner();
2135 error AlreadyClaimed();
2136 error NotValidOwner();
2137 
2138 pragma solidity ^0.8.19;
2139 
2140 contract PunkPacks is DefaultOperatorFilterer, ERC2981, ERC1155Burnable, Ownable {
2141   using ECDSA for bytes32;
2142 
2143   mapping (uint256 => Pack) public packs;
2144   uint256 public constant MAX_PER_TRANSACTION = 5;
2145   address public approvedBurningContract;
2146   mapping (uint256 => mapping(uint256 => bool)) public packClaims;
2147   address public authorizedSigner;
2148 
2149   constructor() ERC1155("https://punks2023.com/api/metadata/packs/") { }
2150 
2151   /* ADMIN FUNCTIONS */
2152   function addPack(
2153     uint256 _tokenId,
2154     string memory _name,
2155     uint256 _amountAvailable,
2156     uint256 _onSaleAt,
2157     uint256 _saleEndsAt,
2158     bool _isClaimable,
2159     uint256 _price,
2160     uint8 _traitsPerPack,
2161     string memory _uri
2162   ) external onlyOwner {
2163     packs[_tokenId] = Pack({tokenId: _tokenId, name: _name, amountAvailable: _amountAvailable, onSaleAt: _onSaleAt, saleEndsAt: _saleEndsAt, isClaimable: _isClaimable, price: _price, traitsPerPack: _traitsPerPack, uri: _uri});
2164   }
2165 
2166   function setBurningContract(address _contract) external onlyOwner {
2167     approvedBurningContract = _contract;
2168   }
2169 
2170   function adminMint(address _wallet, uint256 _count, uint256 _tokenId) external onlyOwner {
2171     Pack storage pack = packs[_tokenId];
2172 
2173     if (pack.amountAvailable < _count) revert PackSoldOut();
2174     pack.amountAvailable -= _count;
2175     _mint(_wallet, _tokenId, _count, "");
2176   }
2177 
2178   function withdraw() external onlyOwner {
2179     uint256 balance = address(this).balance;
2180     if (balance == 0) revert ZeroBalance();
2181     address owner = payable(msg.sender);
2182 
2183     (bool ownerSuccess, ) = owner.call{value: address(this).balance}("");
2184     require(ownerSuccess, "Failed to send to Owner.");
2185   }
2186 
2187   function setAuthorizedSigner(address signer) external onlyOwner {
2188     authorizedSigner = signer;
2189   }
2190   /* END ADMIN FUNCTIONS */
2191 
2192   function mint(uint256 count, uint256 tokenId) payable external {
2193     Pack storage pack = packs[tokenId];
2194     if (count > MAX_PER_TRANSACTION) revert MaxPerTransactionExceeded();
2195     if (msg.value != (count * pack.price)) revert IncorrectAmountSent();
2196     if (pack.amountAvailable < count) revert PackSoldOut();
2197     if (block.timestamp < pack.onSaleAt || block.timestamp > pack.saleEndsAt) revert SaleNotActive();
2198 
2199     pack.amountAvailable -= count;
2200     _mint(msg.sender, tokenId, count, "");
2201   }
2202 
2203   function claim(uint256 _packId, bytes calldata callData, bytes memory signature) external {
2204     Pack storage pack = packs[_packId];
2205     if (block.timestamp < pack.onSaleAt) revert SaleNotActive();
2206     if (!pack.isClaimable) revert PackNotClaimable();
2207     (uint256[] memory token_ids, address wallet) = _signedTokenIds(callData, signature);
2208     if (wallet != msg.sender) revert NotValidOwner();
2209 
2210     for (uint8 i; i < token_ids.length; i++) {
2211       if (packClaims[_packId][token_ids[i]]) revert AlreadyClaimed();
2212       packClaims[_packId][token_ids[i]] = true;
2213     }
2214 
2215     _mint(msg.sender, _packId, token_ids.length, "");
2216   }
2217 
2218   function uri(uint256 _tokenId) public view override returns (string memory) {
2219     Pack memory pack = packs[_tokenId];
2220     return pack.uri;
2221   }
2222 
2223   function isApprovedForAll(address _owner, address operator) public view override returns (bool) {
2224     if (operator == approvedBurningContract) return true;
2225     return super.isApprovedForAll(_owner, operator);
2226   }
2227 
2228   function _signedTokenIds(bytes calldata callData, bytes memory signature) internal view returns (uint256[] memory, address) {
2229     address signer = keccak256(callData).toEthSignedMessageHash().recover(signature);
2230     if (signer == address(0)) revert InvalidSignature();
2231     if (signer != authorizedSigner) revert UnauthorizedSigner();
2232     (uint256[] memory token_ids, address wallet) = abi.decode(callData, (uint256[], address));
2233 
2234     return (token_ids, wallet);
2235   }
2236 
2237   function traitsPerPack(uint256 packId) public view returns (uint8) {
2238     return packs[packId].traitsPerPack;
2239   }
2240 
2241   function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2242     super.setApprovalForAll(operator, approved);
2243   }
2244 
2245   function safeTransferFrom(address from, address to, uint256 tokenId, uint256 amount, bytes memory data)
2246     public
2247     override
2248     onlyAllowedOperator(from)
2249   {
2250     super.safeTransferFrom(from, to, tokenId, amount, data);
2251   }
2252 
2253   function safeBatchTransferFrom(
2254     address from,
2255     address to,
2256     uint256[] memory ids,
2257     uint256[] memory amounts,
2258     bytes memory data
2259   ) public virtual override onlyAllowedOperator(from) {
2260     super.safeBatchTransferFrom(from, to, ids, amounts, data);
2261   }
2262 
2263   function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155, ERC2981) returns (bool) {
2264     return ERC1155.supportsInterface(interfaceId) || ERC2981.supportsInterface(interfaceId);
2265   }
2266 }