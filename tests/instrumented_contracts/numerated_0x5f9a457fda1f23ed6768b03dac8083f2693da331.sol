1 pragma solidity ^0.8.0;
2 
3 /*
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes calldata) {
19         return msg.data;
20     }
21 }
22 
23 /**
24  * @dev Contract module which provides a basic access control mechanism, where
25  * there is an account (an owner) that can be granted exclusive access to
26  * specific functions.
27  *
28  * By default, the owner account will be the one that deploys the contract. This
29  * can later be changed with {transferOwnership}.
30  *
31  * This module is used through inheritance. It will make available the modifier
32  * `onlyOwner`, which can be applied to your functions to restrict their use to
33  * the owner.
34  */
35 abstract contract Ownable is Context {
36     address private _owner;
37 
38     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39 
40     /**
41      * @dev Initializes the contract setting the deployer as the initial owner.
42      */
43     constructor() {
44         _setOwner(_msgSender());
45     }
46 
47     /**
48      * @dev Returns the address of the current owner.
49      */
50     function owner() public view virtual returns (address) {
51         return _owner;
52     }
53 
54     /**
55      * @dev Throws if called by any account other than the owner.
56      */
57     modifier onlyOwner() {
58         require(owner() == _msgSender(), "Ownable: caller is not the owner");
59         _;
60     }
61 
62     /**
63      * @dev Leaves the contract without owner. It will not be possible to call
64      * `onlyOwner` functions anymore. Can only be called by the current owner.
65      *
66      * NOTE: Renouncing ownership will leave the contract without an owner,
67      * thereby removing any functionality that is only available to the owner.
68      */
69     function renounceOwnership() public virtual onlyOwner {
70         _setOwner(address(0));
71     }
72 
73     /**
74      * @dev Transfers ownership of the contract to a new account (`newOwner`).
75      * Can only be called by the current owner.
76      */
77     function transferOwnership(address newOwner) public virtual onlyOwner {
78         require(newOwner != address(0), "Ownable: new owner is the zero address");
79         _setOwner(newOwner);
80     }
81 
82     function _setOwner(address newOwner) private {
83         address oldOwner = _owner;
84         _owner = newOwner;
85         emit OwnershipTransferred(oldOwner, newOwner);
86     }
87 }
88 
89 /**
90  * @dev Collection of functions related to the address type
91  */
92 library Address {
93     /**
94      * @dev Returns true if `account` is a contract.
95      *
96      * [IMPORTANT]
97      * ====
98      * It is unsafe to assume that an address for which this function returns
99      * false is an externally-owned account (EOA) and not a contract.
100      *
101      * Among others, `isContract` will return false for the following
102      * types of addresses:
103      *
104      *  - an externally-owned account
105      *  - a contract in construction
106      *  - an address where a contract will be created
107      *  - an address where a contract lived, but was destroyed
108      * ====
109      */
110     function isContract(address account) internal view returns (bool) {
111         // This method relies on extcodesize, which returns 0 for contracts in
112         // construction, since the code is only stored at the end of the
113         // constructor execution.
114 
115         uint256 size;
116         assembly {
117             size := extcodesize(account)
118         }
119         return size > 0;
120     }
121 
122     /**
123      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
124      * `recipient`, forwarding all available gas and reverting on errors.
125      *
126      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
127      * of certain opcodes, possibly making contracts go over the 2300 gas limit
128      * imposed by `transfer`, making them unable to receive funds via
129      * `transfer`. {sendValue} removes this limitation.
130      *
131      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
132      *
133      * IMPORTANT: because control is transferred to `recipient`, care must be
134      * taken to not create reentrancy vulnerabilities. Consider using
135      * {ReentrancyGuard} or the
136      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
137      */
138     function sendValue(address payable recipient, uint256 amount) internal {
139         require(address(this).balance >= amount, "Address: insufficient balance");
140 
141         (bool success, ) = recipient.call{value: amount}("");
142         require(success, "Address: unable to send value, recipient may have reverted");
143     }
144 
145     /**
146      * @dev Performs a Solidity function call using a low level `call`. A
147      * plain `call` is an unsafe replacement for a function call: use this
148      * function instead.
149      *
150      * If `target` reverts with a revert reason, it is bubbled up by this
151      * function (like regular Solidity function calls).
152      *
153      * Returns the raw returned data. To convert to the expected return value,
154      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
155      *
156      * Requirements:
157      *
158      * - `target` must be a contract.
159      * - calling `target` with `data` must not revert.
160      *
161      * _Available since v3.1._
162      */
163     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
164         return functionCall(target, data, "Address: low-level call failed");
165     }
166 
167     /**
168      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
169      * `errorMessage` as a fallback revert reason when `target` reverts.
170      *
171      * _Available since v3.1._
172      */
173     function functionCall(
174         address target,
175         bytes memory data,
176         string memory errorMessage
177     ) internal returns (bytes memory) {
178         return functionCallWithValue(target, data, 0, errorMessage);
179     }
180 
181     /**
182      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
183      * but also transferring `value` wei to `target`.
184      *
185      * Requirements:
186      *
187      * - the calling contract must have an ETH balance of at least `value`.
188      * - the called Solidity function must be `payable`.
189      *
190      * _Available since v3.1._
191      */
192     function functionCallWithValue(
193         address target,
194         bytes memory data,
195         uint256 value
196     ) internal returns (bytes memory) {
197         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
198     }
199 
200     /**
201      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
202      * with `errorMessage` as a fallback revert reason when `target` reverts.
203      *
204      * _Available since v3.1._
205      */
206     function functionCallWithValue(
207         address target,
208         bytes memory data,
209         uint256 value,
210         string memory errorMessage
211     ) internal returns (bytes memory) {
212         require(address(this).balance >= value, "Address: insufficient balance for call");
213         require(isContract(target), "Address: call to non-contract");
214 
215         (bool success, bytes memory returndata) = target.call{value: value}(data);
216         return _verifyCallResult(success, returndata, errorMessage);
217     }
218 
219     /**
220      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
221      * but performing a static call.
222      *
223      * _Available since v3.3._
224      */
225     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
226         return functionStaticCall(target, data, "Address: low-level static call failed");
227     }
228 
229     /**
230      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
231      * but performing a static call.
232      *
233      * _Available since v3.3._
234      */
235     function functionStaticCall(
236         address target,
237         bytes memory data,
238         string memory errorMessage
239     ) internal view returns (bytes memory) {
240         require(isContract(target), "Address: static call to non-contract");
241 
242         (bool success, bytes memory returndata) = target.staticcall(data);
243         return _verifyCallResult(success, returndata, errorMessage);
244     }
245 
246     /**
247      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
248      * but performing a delegate call.
249      *
250      * _Available since v3.4._
251      */
252     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
253         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
254     }
255 
256     /**
257      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
258      * but performing a delegate call.
259      *
260      * _Available since v3.4._
261      */
262     function functionDelegateCall(
263         address target,
264         bytes memory data,
265         string memory errorMessage
266     ) internal returns (bytes memory) {
267         require(isContract(target), "Address: delegate call to non-contract");
268 
269         (bool success, bytes memory returndata) = target.delegatecall(data);
270         return _verifyCallResult(success, returndata, errorMessage);
271     }
272 
273     function _verifyCallResult(
274         bool success,
275         bytes memory returndata,
276         string memory errorMessage
277     ) private pure returns (bytes memory) {
278         if (success) {
279             return returndata;
280         } else {
281             // Look for revert reason and bubble it up if present
282             if (returndata.length > 0) {
283                 // The easiest way to bubble the revert reason is using memory via assembly
284 
285                 assembly {
286                     let returndata_size := mload(returndata)
287                     revert(add(32, returndata), returndata_size)
288                 }
289             } else {
290                 revert(errorMessage);
291             }
292         }
293     }
294 }
295 
296 /**
297  * @dev String operations.
298  */
299 library Strings {
300     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
301 
302     /**
303      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
304      */
305     function toString(uint256 value) internal pure returns (string memory) {
306         // Inspired by OraclizeAPI's implementation - MIT licence
307         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
308 
309         if (value == 0) {
310             return "0";
311         }
312         uint256 temp = value;
313         uint256 digits;
314         while (temp != 0) {
315             digits++;
316             temp /= 10;
317         }
318         bytes memory buffer = new bytes(digits);
319         while (value != 0) {
320             digits -= 1;
321             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
322             value /= 10;
323         }
324         return string(buffer);
325     }
326 
327     /**
328      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
329      */
330     function toHexString(uint256 value) internal pure returns (string memory) {
331         if (value == 0) {
332             return "0x00";
333         }
334         uint256 temp = value;
335         uint256 length = 0;
336         while (temp != 0) {
337             length++;
338             temp >>= 8;
339         }
340         return toHexString(value, length);
341     }
342 
343     /**
344      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
345      */
346     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
347         bytes memory buffer = new bytes(2 * length + 2);
348         buffer[0] = "0";
349         buffer[1] = "x";
350         for (uint256 i = 2 * length + 1; i > 1; --i) {
351             buffer[i] = _HEX_SYMBOLS[value & 0xf];
352             value >>= 4;
353         }
354         require(value == 0, "Strings: hex length insufficient");
355         return string(buffer);
356     }
357 }
358 
359 
360 /**
361  * @dev Interface of the ERC165 standard, as defined in the
362  * https://eips.ethereum.org/EIPS/eip-165[EIP].
363  *
364  * Implementers can declare support of contract interfaces, which can then be
365  * queried by others ({ERC165Checker}).
366  *
367  * For an implementation, see {ERC165}.
368  */
369 interface IERC165 {
370     /**
371      * @dev Returns true if this contract implements the interface defined by
372      * `interfaceId`. See the corresponding
373      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
374      * to learn more about how these ids are created.
375      *
376      * This function call must use less than 30 000 gas.
377      */
378     function supportsInterface(bytes4 interfaceId) external view returns (bool);
379 }
380 
381 
382 /**
383  * @dev Implementation of the {IERC165} interface.
384  *
385  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
386  * for the additional interface id that will be supported. For example:
387  *
388  * ```solidity
389  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
390  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
391  * }
392  * ```
393  *
394  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
395  */
396 abstract contract ERC165 is IERC165 {
397     /**
398      * @dev See {IERC165-supportsInterface}.
399      */
400     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
401         return interfaceId == type(IERC165).interfaceId;
402     }
403 }
404 
405 
406 
407 /**
408  * @dev _Available since v3.1._
409  */
410 interface IERC1155Receiver is IERC165 {
411     /**
412         @dev Handles the receipt of a single ERC1155 token type. This function is
413         called at the end of a `safeTransferFrom` after the balance has been updated.
414         To accept the transfer, this must return
415         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
416         (i.e. 0xf23a6e61, or its own function selector).
417         @param operator The address which initiated the transfer (i.e. msg.sender)
418         @param from The address which previously owned the token
419         @param id The ID of the token being transferred
420         @param value The amount of tokens being transferred
421         @param data Additional data with no specified format
422         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
423     */
424     function onERC1155Received(
425         address operator,
426         address from,
427         uint256 id,
428         uint256 value,
429         bytes calldata data
430     ) external returns (bytes4);
431 
432     /**
433         @dev Handles the receipt of a multiple ERC1155 token types. This function
434         is called at the end of a `safeBatchTransferFrom` after the balances have
435         been updated. To accept the transfer(s), this must return
436         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
437         (i.e. 0xbc197c81, or its own function selector).
438         @param operator The address which initiated the batch transfer (i.e. msg.sender)
439         @param from The address which previously owned the token
440         @param ids An array containing ids of each token being transferred (order and length must match values array)
441         @param values An array containing amounts of each token being transferred (order and length must match ids array)
442         @param data Additional data with no specified format
443         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
444     */
445     function onERC1155BatchReceived(
446         address operator,
447         address from,
448         uint256[] calldata ids,
449         uint256[] calldata values,
450         bytes calldata data
451     ) external returns (bytes4);
452 }
453 
454 
455 /**
456  * @dev Required interface of an ERC1155 compliant contract, as defined in the
457  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
458  *
459  * _Available since v3.1._
460  */
461 interface IERC1155 is IERC165 {
462     /**
463      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
464      */
465     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
466 
467     /**
468      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
469      * transfers.
470      */
471     event TransferBatch(
472         address indexed operator,
473         address indexed from,
474         address indexed to,
475         uint256[] ids,
476         uint256[] values
477     );
478 
479     /**
480      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
481      * `approved`.
482      */
483     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
484 
485     /**
486      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
487      *
488      * If an {URI} event was emitted for `id`, the standard
489      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
490      * returned by {IERC1155MetadataURI-uri}.
491      */
492     event URI(string value, uint256 indexed id);
493 
494     /**
495      * @dev Returns the amount of tokens of token type `id` owned by `account`.
496      *
497      * Requirements:
498      *
499      * - `account` cannot be the zero address.
500      */
501     function balanceOf(address account, uint256 id) external view returns (uint256);
502 
503     /**
504      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
505      *
506      * Requirements:
507      *
508      * - `accounts` and `ids` must have the same length.
509      */
510     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
511         external
512         view
513         returns (uint256[] memory);
514 
515     /**
516      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
517      *
518      * Emits an {ApprovalForAll} event.
519      *
520      * Requirements:
521      *
522      * - `operator` cannot be the caller.
523      */
524     function setApprovalForAll(address operator, bool approved) external;
525 
526     /**
527      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
528      *
529      * See {setApprovalForAll}.
530      */
531     function isApprovedForAll(address account, address operator) external view returns (bool);
532 
533     /**
534      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
535      *
536      * Emits a {TransferSingle} event.
537      *
538      * Requirements:
539      *
540      * - `to` cannot be the zero address.
541      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
542      * - `from` must have a balance of tokens of type `id` of at least `amount`.
543      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
544      * acceptance magic value.
545      */
546     function safeTransferFrom(
547         address from,
548         address to,
549         uint256 id,
550         uint256 amount,
551         bytes calldata data
552     ) external;
553 
554     /**
555      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
556      *
557      * Emits a {TransferBatch} event.
558      *
559      * Requirements:
560      *
561      * - `ids` and `amounts` must have the same length.
562      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
563      * acceptance magic value.
564      */
565     function safeBatchTransferFrom(
566         address from,
567         address to,
568         uint256[] calldata ids,
569         uint256[] calldata amounts,
570         bytes calldata data
571     ) external;
572 }
573 
574 
575 /**
576  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
577  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
578  *
579  * _Available since v3.1._
580  */
581 interface IERC1155MetadataURI is IERC1155 {
582     /**
583      * @dev Returns the URI for token type `id`.
584      *
585      * If the `\{id\}` substring is present in the URI, it must be replaced by
586      * clients with the actual token type ID.
587      */
588     function uri(uint256 id) external view returns (string memory);
589 }
590 
591 
592 
593 /**
594  * @dev Implementation of the basic standard multi-token.
595  * See https://eips.ethereum.org/EIPS/eip-1155
596  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
597  *
598  * _Available since v3.1._
599  */
600 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
601     using Address for address;
602 
603     // Mapping from token ID to account balances
604     mapping(uint256 => mapping(address => uint256)) private _balances;
605 
606     // Mapping from account to operator approvals
607     mapping(address => mapping(address => bool)) private _operatorApprovals;
608 
609     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
610     string private _uri;
611 
612     /**
613      * @dev See {_setURI}.
614      */
615     constructor(string memory uri_) {
616         _setURI(uri_);
617     }
618 
619     /**
620      * @dev See {IERC165-supportsInterface}.
621      */
622     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
623         return
624             interfaceId == type(IERC1155).interfaceId ||
625             interfaceId == type(IERC1155MetadataURI).interfaceId ||
626             super.supportsInterface(interfaceId);
627     }
628 
629     /**
630      * @dev See {IERC1155MetadataURI-uri}.
631      *
632      * This implementation returns the same URI for *all* token types. It relies
633      * on the token type ID substitution mechanism
634      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
635      *
636      * Clients calling this function must replace the `\{id\}` substring with the
637      * actual token type ID.
638      */
639     function uri(uint256) public view virtual override returns (string memory) {
640         return _uri;
641     }
642 
643     /**
644      * @dev See {IERC1155-balanceOf}.
645      *
646      * Requirements:
647      *
648      * - `account` cannot be the zero address.
649      */
650     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
651         require(account != address(0), "ERC1155: balance query for the zero address");
652         return _balances[id][account];
653     }
654 
655     /**
656      * @dev See {IERC1155-balanceOfBatch}.
657      *
658      * Requirements:
659      *
660      * - `accounts` and `ids` must have the same length.
661      */
662     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
663         public
664         view
665         virtual
666         override
667         returns (uint256[] memory)
668     {
669         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
670 
671         uint256[] memory batchBalances = new uint256[](accounts.length);
672 
673         for (uint256 i = 0; i < accounts.length; ++i) {
674             batchBalances[i] = balanceOf(accounts[i], ids[i]);
675         }
676 
677         return batchBalances;
678     }
679 
680     /**
681      * @dev See {IERC1155-setApprovalForAll}.
682      */
683     function setApprovalForAll(address operator, bool approved) public virtual override {
684         require(_msgSender() != operator, "ERC1155: setting approval status for self");
685 
686         _operatorApprovals[_msgSender()][operator] = approved;
687         emit ApprovalForAll(_msgSender(), operator, approved);
688     }
689 
690     /**
691      * @dev See {IERC1155-isApprovedForAll}.
692      */
693     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
694         return _operatorApprovals[account][operator];
695     }
696 
697     /**
698      * @dev See {IERC1155-safeTransferFrom}.
699      */
700     function safeTransferFrom(
701         address from,
702         address to,
703         uint256 id,
704         uint256 amount,
705         bytes memory data
706     ) public virtual override {
707         require(
708             from == _msgSender() || isApprovedForAll(from, _msgSender()),
709             "ERC1155: caller is not owner nor approved"
710         );
711         _safeTransferFrom(from, to, id, amount, data);
712     }
713 
714     /**
715      * @dev See {IERC1155-safeBatchTransferFrom}.
716      */
717     function safeBatchTransferFrom(
718         address from,
719         address to,
720         uint256[] memory ids,
721         uint256[] memory amounts,
722         bytes memory data
723     ) public virtual override {
724         require(
725             from == _msgSender() || isApprovedForAll(from, _msgSender()),
726             "ERC1155: transfer caller is not owner nor approved"
727         );
728         _safeBatchTransferFrom(from, to, ids, amounts, data);
729     }
730 
731     /**
732      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
733      *
734      * Emits a {TransferSingle} event.
735      *
736      * Requirements:
737      *
738      * - `to` cannot be the zero address.
739      * - `from` must have a balance of tokens of type `id` of at least `amount`.
740      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
741      * acceptance magic value.
742      */
743     function _safeTransferFrom(
744         address from,
745         address to,
746         uint256 id,
747         uint256 amount,
748         bytes memory data
749     ) internal virtual {
750         require(to != address(0), "ERC1155: transfer to the zero address");
751 
752         address operator = _msgSender();
753 
754         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
755 
756         uint256 fromBalance = _balances[id][from];
757         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
758         unchecked {
759             _balances[id][from] = fromBalance - amount;
760         }
761         _balances[id][to] += amount;
762 
763         emit TransferSingle(operator, from, to, id, amount);
764 
765         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
766     }
767 
768     /**
769      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
770      *
771      * Emits a {TransferBatch} event.
772      *
773      * Requirements:
774      *
775      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
776      * acceptance magic value.
777      */
778     function _safeBatchTransferFrom(
779         address from,
780         address to,
781         uint256[] memory ids,
782         uint256[] memory amounts,
783         bytes memory data
784     ) internal virtual {
785         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
786         require(to != address(0), "ERC1155: transfer to the zero address");
787 
788         address operator = _msgSender();
789 
790         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
791 
792         for (uint256 i = 0; i < ids.length; ++i) {
793             uint256 id = ids[i];
794             uint256 amount = amounts[i];
795 
796             uint256 fromBalance = _balances[id][from];
797             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
798             unchecked {
799                 _balances[id][from] = fromBalance - amount;
800             }
801             _balances[id][to] += amount;
802         }
803 
804         emit TransferBatch(operator, from, to, ids, amounts);
805 
806         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
807     }
808 
809     /**
810      * @dev Sets a new URI for all token types, by relying on the token type ID
811      * substitution mechanism
812      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
813      *
814      * By this mechanism, any occurrence of the `\{id\}` substring in either the
815      * URI or any of the amounts in the JSON file at said URI will be replaced by
816      * clients with the token type ID.
817      *
818      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
819      * interpreted by clients as
820      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
821      * for token type ID 0x4cce0.
822      *
823      * See {uri}.
824      *
825      * Because these URIs cannot be meaningfully represented by the {URI} event,
826      * this function emits no events.
827      */
828     function _setURI(string memory newuri) internal virtual {
829         _uri = newuri;
830     }
831 
832     /**
833      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
834      *
835      * Emits a {TransferSingle} event.
836      *
837      * Requirements:
838      *
839      * - `account` cannot be the zero address.
840      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
841      * acceptance magic value.
842      */
843     function _mint(
844         address account,
845         uint256 id,
846         uint256 amount,
847         bytes memory data
848     ) internal virtual {
849         require(account != address(0), "ERC1155: mint to the zero address");
850 
851         address operator = _msgSender();
852 
853         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
854 
855         _balances[id][account] += amount;
856         emit TransferSingle(operator, address(0), account, id, amount);
857 
858         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
859     }
860 
861     /**
862      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
863      *
864      * Requirements:
865      *
866      * - `ids` and `amounts` must have the same length.
867      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
868      * acceptance magic value.
869      */
870     function _mintBatch(
871         address to,
872         uint256[] memory ids,
873         uint256[] memory amounts,
874         bytes memory data
875     ) internal virtual {
876         require(to != address(0), "ERC1155: mint to the zero address");
877         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
878 
879         address operator = _msgSender();
880 
881         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
882 
883         for (uint256 i = 0; i < ids.length; i++) {
884             _balances[ids[i]][to] += amounts[i];
885         }
886 
887         emit TransferBatch(operator, address(0), to, ids, amounts);
888 
889         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
890     }
891 
892     /**
893      * @dev Destroys `amount` tokens of token type `id` from `account`
894      *
895      * Requirements:
896      *
897      * - `account` cannot be the zero address.
898      * - `account` must have at least `amount` tokens of token type `id`.
899      */
900     function _burn(
901         address account,
902         uint256 id,
903         uint256 amount
904     ) internal virtual {
905         require(account != address(0), "ERC1155: burn from the zero address");
906 
907         address operator = _msgSender();
908 
909         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
910 
911         uint256 accountBalance = _balances[id][account];
912         require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
913         unchecked {
914             _balances[id][account] = accountBalance - amount;
915         }
916 
917         emit TransferSingle(operator, account, address(0), id, amount);
918     }
919 
920     /**
921      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
922      *
923      * Requirements:
924      *
925      * - `ids` and `amounts` must have the same length.
926      */
927     function _burnBatch(
928         address account,
929         uint256[] memory ids,
930         uint256[] memory amounts
931     ) internal virtual {
932         require(account != address(0), "ERC1155: burn from the zero address");
933         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
934 
935         address operator = _msgSender();
936 
937         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
938 
939         for (uint256 i = 0; i < ids.length; i++) {
940             uint256 id = ids[i];
941             uint256 amount = amounts[i];
942 
943             uint256 accountBalance = _balances[id][account];
944             require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
945             unchecked {
946                 _balances[id][account] = accountBalance - amount;
947             }
948         }
949 
950         emit TransferBatch(operator, account, address(0), ids, amounts);
951     }
952 
953     /**
954      * @dev Hook that is called before any token transfer. This includes minting
955      * and burning, as well as batched variants.
956      *
957      * The same hook is called on both single and batched variants. For single
958      * transfers, the length of the `id` and `amount` arrays will be 1.
959      *
960      * Calling conditions (for each `id` and `amount` pair):
961      *
962      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
963      * of token type `id` will be  transferred to `to`.
964      * - When `from` is zero, `amount` tokens of token type `id` will be minted
965      * for `to`.
966      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
967      * will be burned.
968      * - `from` and `to` are never both zero.
969      * - `ids` and `amounts` have the same, non-zero length.
970      *
971      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
972      */
973     function _beforeTokenTransfer(
974         address operator,
975         address from,
976         address to,
977         uint256[] memory ids,
978         uint256[] memory amounts,
979         bytes memory data
980     ) internal virtual {}
981 
982     function _doSafeTransferAcceptanceCheck(
983         address operator,
984         address from,
985         address to,
986         uint256 id,
987         uint256 amount,
988         bytes memory data
989     ) private {
990         if (to.isContract()) {
991             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
992                 if (response != IERC1155Receiver(to).onERC1155Received.selector) {
993                     revert("ERC1155: ERC1155Receiver rejected tokens");
994                 }
995             } catch Error(string memory reason) {
996                 revert(reason);
997             } catch {
998                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
999             }
1000         }
1001     }
1002 
1003     function _doSafeBatchTransferAcceptanceCheck(
1004         address operator,
1005         address from,
1006         address to,
1007         uint256[] memory ids,
1008         uint256[] memory amounts,
1009         bytes memory data
1010     ) private {
1011         if (to.isContract()) {
1012             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1013                 bytes4 response
1014             ) {
1015                 if (response != IERC1155Receiver(to).onERC1155BatchReceived.selector) {
1016                     revert("ERC1155: ERC1155Receiver rejected tokens");
1017                 }
1018             } catch Error(string memory reason) {
1019                 revert(reason);
1020             } catch {
1021                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1022             }
1023         }
1024     }
1025 
1026     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1027         uint256[] memory array = new uint256[](1);
1028         array[0] = element;
1029 
1030         return array;
1031     }
1032 }
1033 
1034 contract VSPRaffleCollection is ERC1155, Ownable {
1035     using Strings for uint256;
1036 
1037     string public name = "VSP IRL Experiences";
1038     string public symbol = "VSPIRL";
1039     
1040     mapping(uint256 => string) private baseURIs;
1041 
1042     mapping(uint256 => uint256) public claimExpirationDates;
1043     
1044     mapping(address => bool) admins;
1045 
1046     event SetBaseURI(uint256 indexed tokenId, string _baseURI);
1047 
1048     constructor() ERC1155("") {
1049         toggleAdmin(_msgSender());
1050     }
1051 
1052     /**
1053      * @dev Throws if called by any account not set to true in the admin mapping.
1054      */
1055     modifier onlyAdmin() {
1056         require(admins[_msgSender()] == true, "Not an owner");
1057         _;
1058     }
1059 
1060     function toggleAdmin(address _adminEntry) public onlyOwner 
1061     {
1062         admins[_adminEntry] = !admins[_adminEntry];
1063     }
1064 
1065     function updateClaimEndDate(uint256 index, uint256 newEndDate) external onlyOwner
1066     {
1067         claimExpirationDates[index] = newEndDate;
1068     }
1069 
1070     function airdropWinners(address[] calldata owners, uint256 id, uint256 claimEndDate) external onlyAdmin
1071     {
1072         require(id % 2 == 1, "id value is not odd");
1073         if(claimEndDate > 0)
1074         {
1075             require(claimExpirationDates[id] == 0, "Claim end date already set");
1076             require(claimEndDate > block.timestamp, "Expiration must be in the future");
1077             claimExpirationDates[id] = claimEndDate;
1078         }
1079         else
1080         {
1081             require(claimExpirationDates[id] > 0, "Must set claim end date");
1082         }
1083 
1084         for(uint256 i = 0; i < owners.length; i++)
1085         {
1086             _mint(owners[i], id, 1, "");
1087         }
1088     }
1089 
1090     function setRaffleURI(uint256 tokenId, string memory baseURI) external onlyAdmin
1091     {
1092         require(tokenId % 2 == 1, "tokenId value must be an odd integer");
1093         baseURIs[tokenId] = baseURI;
1094 
1095         emit SetBaseURI(tokenId, baseURI);
1096     }
1097 
1098     function claimPrize(uint256 typeId) external
1099     {
1100         require(typeId % 2 == 1, "Not an odd typeId");
1101         require(block.timestamp < claimExpirationDates[typeId], "Claim period has ended");
1102 
1103         //Burn claimable token
1104         _burn(_msgSender(), typeId, 1);
1105 
1106         //Mint proof of claim token
1107         _mint(_msgSender(), typeId + 1, 1, "");
1108 
1109     }
1110 
1111     function uri(uint256 typeId) public view override returns (string memory)
1112     {
1113             require(typeId > 0, "First tokenId = 1");
1114 
1115             uint256 baseVal;
1116             bool claimed;
1117 
1118             //claimed/unclaimed check
1119             if(typeId % 2 == 1)
1120             {
1121                 baseVal = typeId;
1122             }
1123             else
1124             {
1125                 baseVal = typeId - 1;
1126                 claimed = true;
1127             }
1128 
1129             require(bytes(baseURIs[baseVal]).length > 0, "URI not set");
1130 
1131             //URI for a claimed NFT will be "baseURI/2"
1132             if(claimed)
1133             {
1134                 return string(abi.encodePacked(baseURIs[baseVal], "/2"));
1135             }
1136             else
1137             {
1138                 //If the claim period has ended return "baseURI/1" otherwise return "baseURI/0"
1139                 if(block.timestamp > claimExpirationDates[baseVal])
1140                 {
1141                     return string(abi.encodePacked(baseURIs[baseVal], "/1"));
1142                 }
1143                 else
1144                 {
1145                     return string(abi.encodePacked(baseURIs[baseVal], "/0"));
1146                 }
1147             }             
1148     }
1149 }