1 library Strings {
2     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
3 
4     /**
5      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
6      */
7     function toString(uint256 value) internal pure returns (string memory) {
8         // Inspired by OraclizeAPI's implementation - MIT licence
9         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
10 
11         if (value == 0) {
12             return "0";
13         }
14         uint256 temp = value;
15         uint256 digits;
16         while (temp != 0) {
17             digits++;
18             temp /= 10;
19         }
20         bytes memory buffer = new bytes(digits);
21         while (value != 0) {
22             digits -= 1;
23             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
24             value /= 10;
25         }
26         return string(buffer);
27     }
28 
29     /**
30      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
31      */
32     function toHexString(uint256 value) internal pure returns (string memory) {
33         if (value == 0) {
34             return "0x00";
35         }
36         uint256 temp = value;
37         uint256 length = 0;
38         while (temp != 0) {
39             length++;
40             temp >>= 8;
41         }
42         return toHexString(value, length);
43     }
44 
45     /**
46      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
47      */
48     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
49         bytes memory buffer = new bytes(2 * length + 2);
50         buffer[0] = "0";
51         buffer[1] = "x";
52         for (uint256 i = 2 * length + 1; i > 1; --i) {
53             buffer[i] = _HEX_SYMBOLS[value & 0xf];
54             value >>= 4;
55         }
56         require(value == 0, "Strings: hex length insufficient");
57         return string(buffer);
58     }
59 }
60 
61 abstract contract Context {
62     function _msgSender() internal view virtual returns (address) {
63         return msg.sender;
64     }
65 
66     function _msgData() internal view virtual returns (bytes calldata) {
67         return msg.data;
68     }
69 }
70 
71 abstract contract Ownable is Context {
72     address private _owner;
73 
74     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
75 
76     /**
77      * @dev Initializes the contract setting the deployer as the initial owner.
78      */
79     constructor() {
80         _transferOwnership(_msgSender());
81     }
82 
83     /**
84      * @dev Returns the address of the current owner.
85      */
86     function owner() public view virtual returns (address) {
87         return _owner;
88     }
89 
90     /**
91      * @dev Throws if called by any account other than the owner.
92      */
93     modifier onlyOwner() {
94         require(owner() == _msgSender(), "Ownable: caller is not the owner");
95         _;
96     }
97 
98     /**
99      * @dev Leaves the contract without owner. It will not be possible to call
100      * `onlyOwner` functions anymore. Can only be called by the current owner.
101      *
102      * NOTE: Renouncing ownership will leave the contract without an owner,
103      * thereby removing any functionality that is only available to the owner.
104      */
105     function renounceOwnership() public virtual onlyOwner {
106         _transferOwnership(address(0));
107     }
108 
109     /**
110      * @dev Transfers ownership of the contract to a new account (`newOwner`).
111      * Can only be called by the current owner.
112      */
113     function transferOwnership(address newOwner) public virtual onlyOwner {
114         require(newOwner != address(0), "Ownable: new owner is the zero address");
115         _transferOwnership(newOwner);
116     }
117 
118     /**
119      * @dev Transfers ownership of the contract to a new account (`newOwner`).
120      * Internal function without access restriction.
121      */
122     function _transferOwnership(address newOwner) internal virtual {
123         address oldOwner = _owner;
124         _owner = newOwner;
125         emit OwnershipTransferred(oldOwner, newOwner);
126     }
127 }
128 library Address {
129     /**
130      * @dev Returns true if `account` is a contract.
131      *
132      * [IMPORTANT]
133      * ====
134      * It is unsafe to assume that an address for which this function returns
135      * false is an externally-owned account (EOA) and not a contract.
136      *
137      * Among others, `isContract` will return false for the following
138      * types of addresses:
139      *
140      *  - an externally-owned account
141      *  - a contract in construction
142      *  - an address where a contract will be created
143      *  - an address where a contract lived, but was destroyed
144      * ====
145      */
146     function isContract(address account) internal view returns (bool) {
147         // This method relies on extcodesize, which returns 0 for contracts in
148         // construction, since the code is only stored at the end of the
149         // constructor execution.
150 
151         uint256 size;
152         assembly {
153             size := extcodesize(account)
154         }
155         return size > 0;
156     }
157 
158     /**
159      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
160      * `recipient`, forwarding all available gas and reverting on errors.
161      *
162      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
163      * of certain opcodes, possibly making contracts go over the 2300 gas limit
164      * imposed by `transfer`, making them unable to receive funds via
165      * `transfer`. {sendValue} removes this limitation.
166      *
167      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
168      *
169      * IMPORTANT: because control is transferred to `recipient`, care must be
170      * taken to not create reentrancy vulnerabilities. Consider using
171      * {ReentrancyGuard} or the
172      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
173      */
174     function sendValue(address payable recipient, uint256 amount) internal {
175         require(address(this).balance >= amount, "Address: insufficient balance");
176 
177         (bool success, ) = recipient.call{value: amount}("");
178         require(success, "Address: unable to send value, recipient may have reverted");
179     }
180 
181     /**
182      * @dev Performs a Solidity function call using a low level `call`. A
183      * plain `call` is an unsafe replacement for a function call: use this
184      * function instead.
185      *
186      * If `target` reverts with a revert reason, it is bubbled up by this
187      * function (like regular Solidity function calls).
188      *
189      * Returns the raw returned data. To convert to the expected return value,
190      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
191      *
192      * Requirements:
193      *
194      * - `target` must be a contract.
195      * - calling `target` with `data` must not revert.
196      *
197      * _Available since v3.1._
198      */
199     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
200         return functionCall(target, data, "Address: low-level call failed");
201     }
202 
203     /**
204      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
205      * `errorMessage` as a fallback revert reason when `target` reverts.
206      *
207      * _Available since v3.1._
208      */
209     function functionCall(
210         address target,
211         bytes memory data,
212         string memory errorMessage
213     ) internal returns (bytes memory) {
214         return functionCallWithValue(target, data, 0, errorMessage);
215     }
216 
217     /**
218      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
219      * but also transferring `value` wei to `target`.
220      *
221      * Requirements:
222      *
223      * - the calling contract must have an ETH balance of at least `value`.
224      * - the called Solidity function must be `payable`.
225      *
226      * _Available since v3.1._
227      */
228     function functionCallWithValue(
229         address target,
230         bytes memory data,
231         uint256 value
232     ) internal returns (bytes memory) {
233         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
234     }
235 
236     /**
237      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
238      * with `errorMessage` as a fallback revert reason when `target` reverts.
239      *
240      * _Available since v3.1._
241      */
242     function functionCallWithValue(
243         address target,
244         bytes memory data,
245         uint256 value,
246         string memory errorMessage
247     ) internal returns (bytes memory) {
248         require(address(this).balance >= value, "Address: insufficient balance for call");
249         require(isContract(target), "Address: call to non-contract");
250 
251         (bool success, bytes memory returndata) = target.call{value: value}(data);
252         return verifyCallResult(success, returndata, errorMessage);
253     }
254 
255     /**
256      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
257      * but performing a static call.
258      *
259      * _Available since v3.3._
260      */
261     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
262         return functionStaticCall(target, data, "Address: low-level static call failed");
263     }
264 
265     /**
266      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
267      * but performing a static call.
268      *
269      * _Available since v3.3._
270      */
271     function functionStaticCall(
272         address target,
273         bytes memory data,
274         string memory errorMessage
275     ) internal view returns (bytes memory) {
276         require(isContract(target), "Address: static call to non-contract");
277 
278         (bool success, bytes memory returndata) = target.staticcall(data);
279         return verifyCallResult(success, returndata, errorMessage);
280     }
281 
282     /**
283      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
284      * but performing a delegate call.
285      *
286      * _Available since v3.4._
287      */
288     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
289         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
290     }
291 
292     /**
293      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
294      * but performing a delegate call.
295      *
296      * _Available since v3.4._
297      */
298     function functionDelegateCall(
299         address target,
300         bytes memory data,
301         string memory errorMessage
302     ) internal returns (bytes memory) {
303         require(isContract(target), "Address: delegate call to non-contract");
304 
305         (bool success, bytes memory returndata) = target.delegatecall(data);
306         return verifyCallResult(success, returndata, errorMessage);
307     }
308 
309     /**
310      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
311      * revert reason using the provided one.
312      *
313      * _Available since v4.3._
314      */
315     function verifyCallResult(
316         bool success,
317         bytes memory returndata,
318         string memory errorMessage
319     ) internal pure returns (bytes memory) {
320         if (success) {
321             return returndata;
322         } else {
323             // Look for revert reason and bubble it up if present
324             if (returndata.length > 0) {
325                 // The easiest way to bubble the revert reason is using memory via assembly
326 
327                 assembly {
328                     let returndata_size := mload(returndata)
329                     revert(add(32, returndata), returndata_size)
330                 }
331             } else {
332                 revert(errorMessage);
333             }
334         }
335     }
336 }
337 interface IERC165 {
338     /**
339      * @dev Returns true if this contract implements the interface defined by
340      * `interfaceId`. See the corresponding
341      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
342      * to learn more about how these ids are created.
343      *
344      * This function call must use less than 30 000 gas.
345      */
346     function supportsInterface(bytes4 interfaceId) external view returns (bool);
347 }
348 abstract contract ERC165 is IERC165 {
349     /**
350      * @dev See {IERC165-supportsInterface}.
351      */
352     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
353         return interfaceId == type(IERC165).interfaceId;
354     }
355 }
356 interface IERC1155Receiver is IERC165 {
357     /**
358         @dev Handles the receipt of a single ERC1155 token type. This function is
359         called at the end of a `safeTransferFrom` after the balance has been updated.
360         To accept the transfer, this must return
361         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
362         (i.e. 0xf23a6e61, or its own function selector).
363         @param operator The address which initiated the transfer (i.e. msg.sender)
364         @param from The address which previously owned the token
365         @param id The ID of the token being transferred
366         @param value The amount of tokens being transferred
367         @param data Additional data with no specified format
368         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
369     */
370     function onERC1155Received(
371         address operator,
372         address from,
373         uint256 id,
374         uint256 value,
375         bytes calldata data
376     ) external returns (bytes4);
377 
378     /**
379         @dev Handles the receipt of a multiple ERC1155 token types. This function
380         is called at the end of a `safeBatchTransferFrom` after the balances have
381         been updated. To accept the transfer(s), this must return
382         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
383         (i.e. 0xbc197c81, or its own function selector).
384         @param operator The address which initiated the batch transfer (i.e. msg.sender)
385         @param from The address which previously owned the token
386         @param ids An array containing ids of each token being transferred (order and length must match values array)
387         @param values An array containing amounts of each token being transferred (order and length must match ids array)
388         @param data Additional data with no specified format
389         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
390     */
391     function onERC1155BatchReceived(
392         address operator,
393         address from,
394         uint256[] calldata ids,
395         uint256[] calldata values,
396         bytes calldata data
397     ) external returns (bytes4);
398 }
399 interface IERC1155 is IERC165 {
400     /**
401      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
402      */
403     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
404 
405     /**
406      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
407      * transfers.
408      */
409     event TransferBatch(
410         address indexed operator,
411         address indexed from,
412         address indexed to,
413         uint256[] ids,
414         uint256[] values
415     );
416 
417     /**
418      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
419      * `approved`.
420      */
421     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
422 
423     /**
424      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
425      *
426      * If an {URI} event was emitted for `id`, the standard
427      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
428      * returned by {IERC1155MetadataURI-uri}.
429      */
430     event URI(string value, uint256 indexed id);
431 
432     /**
433      * @dev Returns the amount of tokens of token type `id` owned by `account`.
434      *
435      * Requirements:
436      *
437      * - `account` cannot be the zero address.
438      */
439     function balanceOf(address account, uint256 id) external view returns (uint256);
440 
441     /**
442      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
443      *
444      * Requirements:
445      *
446      * - `accounts` and `ids` must have the same length.
447      */
448     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
449         external
450         view
451         returns (uint256[] memory);
452 
453     /**
454      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
455      *
456      * Emits an {ApprovalForAll} event.
457      *
458      * Requirements:
459      *
460      * - `operator` cannot be the caller.
461      */
462     function setApprovalForAll(address operator, bool approved) external;
463 
464     /**
465      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
466      *
467      * See {setApprovalForAll}.
468      */
469     function isApprovedForAll(address account, address operator) external view returns (bool);
470 
471     /**
472      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
473      *
474      * Emits a {TransferSingle} event.
475      *
476      * Requirements:
477      *
478      * - `to` cannot be the zero address.
479      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
480      * - `from` must have a balance of tokens of type `id` of at least `amount`.
481      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
482      * acceptance magic value.
483      */
484     function safeTransferFrom(
485         address from,
486         address to,
487         uint256 id,
488         uint256 amount,
489         bytes calldata data
490     ) external;
491 
492     /**
493      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
494      *
495      * Emits a {TransferBatch} event.
496      *
497      * Requirements:
498      *
499      * - `ids` and `amounts` must have the same length.
500      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
501      * acceptance magic value.
502      */
503     function safeBatchTransferFrom(
504         address from,
505         address to,
506         uint256[] calldata ids,
507         uint256[] calldata amounts,
508         bytes calldata data
509     ) external;
510 }
511 interface IERC1155MetadataURI is IERC1155 {
512     /**
513      * @dev Returns the URI for token type `id`.
514      *
515      * If the `\{id\}` substring is present in the URI, it must be replaced by
516      * clients with the actual token type ID.
517      */
518     function uri(uint256 id) external view returns (string memory);
519 }
520 
521 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
522     using Address for address;
523 
524     // Mapping from token ID to account balances
525     mapping(uint256 => mapping(address => uint256)) private _balances;
526 
527     // Mapping from account to operator approvals
528     mapping(address => mapping(address => bool)) private _operatorApprovals;
529 
530     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
531     string private _uri;
532 
533     /**
534      * @dev See {_setURI}.
535      */
536     constructor(string memory uri_) {
537         _setURI(uri_);
538     }
539 
540     /**
541      * @dev See {IERC165-supportsInterface}.
542      */
543     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
544         return
545             interfaceId == type(IERC1155).interfaceId ||
546             interfaceId == type(IERC1155MetadataURI).interfaceId ||
547             super.supportsInterface(interfaceId);
548     }
549 
550     /**
551      * @dev See {IERC1155MetadataURI-uri}.
552      *
553      * This implementation returns the same URI for *all* token types. It relies
554      * on the token type ID substitution mechanism
555      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
556      *
557      * Clients calling this function must replace the `\{id\}` substring with the
558      * actual token type ID.
559      */
560     function uri(uint256) public view virtual override returns (string memory) {
561         return _uri;
562     }
563 
564     /**
565      * @dev See {IERC1155-balanceOf}.
566      *
567      * Requirements:
568      *
569      * - `account` cannot be the zero address.
570      */
571     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
572         require(account != address(0), "ERC1155: balance query for the zero address");
573         return _balances[id][account];
574     }
575 
576     /**
577      * @dev See {IERC1155-balanceOfBatch}.
578      *
579      * Requirements:
580      *
581      * - `accounts` and `ids` must have the same length.
582      */
583     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
584         public
585         view
586         virtual
587         override
588         returns (uint256[] memory)
589     {
590         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
591 
592         uint256[] memory batchBalances = new uint256[](accounts.length);
593 
594         for (uint256 i = 0; i < accounts.length; ++i) {
595             batchBalances[i] = balanceOf(accounts[i], ids[i]);
596         }
597 
598         return batchBalances;
599     }
600 
601     /**
602      * @dev See {IERC1155-setApprovalForAll}.
603      */
604     function setApprovalForAll(address operator, bool approved) public virtual override {
605         _setApprovalForAll(_msgSender(), operator, approved);
606     }
607 
608     /**
609      * @dev See {IERC1155-isApprovedForAll}.
610      */
611     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
612         return _operatorApprovals[account][operator];
613     }
614 
615     /**
616      * @dev See {IERC1155-safeTransferFrom}.
617      */
618     function safeTransferFrom(
619         address from,
620         address to,
621         uint256 id,
622         uint256 amount,
623         bytes memory data
624     ) public virtual override {
625         require(
626             from == _msgSender() || isApprovedForAll(from, _msgSender()),
627             "ERC1155: caller is not owner nor approved"
628         );
629         _safeTransferFrom(from, to, id, amount, data);
630     }
631 
632     /**
633      * @dev See {IERC1155-safeBatchTransferFrom}.
634      */
635     function safeBatchTransferFrom(
636         address from,
637         address to,
638         uint256[] memory ids,
639         uint256[] memory amounts,
640         bytes memory data
641     ) public virtual override {
642         require(
643             from == _msgSender() || isApprovedForAll(from, _msgSender()),
644             "ERC1155: transfer caller is not owner nor approved"
645         );
646         _safeBatchTransferFrom(from, to, ids, amounts, data);
647     }
648 
649     /**
650      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
651      *
652      * Emits a {TransferSingle} event.
653      *
654      * Requirements:
655      *
656      * - `to` cannot be the zero address.
657      * - `from` must have a balance of tokens of type `id` of at least `amount`.
658      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
659      * acceptance magic value.
660      */
661     function _safeTransferFrom(
662         address from,
663         address to,
664         uint256 id,
665         uint256 amount,
666         bytes memory data
667     ) internal virtual {
668         require(to != address(0), "ERC1155: transfer to the zero address");
669 
670         address operator = _msgSender();
671 
672         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
673 
674         uint256 fromBalance = _balances[id][from];
675         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
676         unchecked {
677             _balances[id][from] = fromBalance - amount;
678         }
679         _balances[id][to] += amount;
680 
681         emit TransferSingle(operator, from, to, id, amount);
682 
683         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
684     }
685 
686     /**
687      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
688      *
689      * Emits a {TransferBatch} event.
690      *
691      * Requirements:
692      *
693      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
694      * acceptance magic value.
695      */
696     function _safeBatchTransferFrom(
697         address from,
698         address to,
699         uint256[] memory ids,
700         uint256[] memory amounts,
701         bytes memory data
702     ) internal virtual {
703         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
704         require(to != address(0), "ERC1155: transfer to the zero address");
705 
706         address operator = _msgSender();
707 
708         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
709 
710         for (uint256 i = 0; i < ids.length; ++i) {
711             uint256 id = ids[i];
712             uint256 amount = amounts[i];
713 
714             uint256 fromBalance = _balances[id][from];
715             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
716             unchecked {
717                 _balances[id][from] = fromBalance - amount;
718             }
719             _balances[id][to] += amount;
720         }
721 
722         emit TransferBatch(operator, from, to, ids, amounts);
723 
724         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
725     }
726 
727     /**
728      * @dev Sets a new URI for all token types, by relying on the token type ID
729      * substitution mechanism
730      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
731      *
732      * By this mechanism, any occurrence of the `\{id\}` substring in either the
733      * URI or any of the amounts in the JSON file at said URI will be replaced by
734      * clients with the token type ID.
735      *
736      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
737      * interpreted by clients as
738      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
739      * for token type ID 0x4cce0.
740      *
741      * See {uri}.
742      *
743      * Because these URIs cannot be meaningfully represented by the {URI} event,
744      * this function emits no events.
745      */
746     function _setURI(string memory newuri) internal virtual {
747         _uri = newuri;
748     }
749 
750     /**
751      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
752      *
753      * Emits a {TransferSingle} event.
754      *
755      * Requirements:
756      *
757      * - `to` cannot be the zero address.
758      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
759      * acceptance magic value.
760      */
761     function _mint(
762         address to,
763         uint256 id,
764         uint256 amount,
765         bytes memory data
766     ) internal virtual {
767         require(to != address(0), "ERC1155: mint to the zero address");
768 
769         address operator = _msgSender();
770 
771         _beforeTokenTransfer(operator, address(0), to, _asSingletonArray(id), _asSingletonArray(amount), data);
772 
773         _balances[id][to] += amount;
774         emit TransferSingle(operator, address(0), to, id, amount);
775 
776         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
777     }
778 
779     /**
780      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
781      *
782      * Requirements:
783      *
784      * - `ids` and `amounts` must have the same length.
785      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
786      * acceptance magic value.
787      */
788     function _mintBatch(
789         address to,
790         uint256[] memory ids,
791         uint256[] memory amounts,
792         bytes memory data
793     ) internal virtual {
794         require(to != address(0), "ERC1155: mint to the zero address");
795         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
796 
797         address operator = _msgSender();
798 
799         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
800 
801         for (uint256 i = 0; i < ids.length; i++) {
802             _balances[ids[i]][to] += amounts[i];
803         }
804 
805         emit TransferBatch(operator, address(0), to, ids, amounts);
806 
807         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
808     }
809 
810     /**
811      * @dev Destroys `amount` tokens of token type `id` from `from`
812      *
813      * Requirements:
814      *
815      * - `from` cannot be the zero address.
816      * - `from` must have at least `amount` tokens of token type `id`.
817      */
818     function _burn(
819         address from,
820         uint256 id,
821         uint256 amount
822     ) internal virtual {
823         require(from != address(0), "ERC1155: burn from the zero address");
824 
825         address operator = _msgSender();
826 
827         _beforeTokenTransfer(operator, from, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
828 
829         uint256 fromBalance = _balances[id][from];
830         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
831         unchecked {
832             _balances[id][from] = fromBalance - amount;
833         }
834 
835         emit TransferSingle(operator, from, address(0), id, amount);
836     }
837 
838     /**
839      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
840      *
841      * Requirements:
842      *
843      * - `ids` and `amounts` must have the same length.
844      */
845     function _burnBatch(
846         address from,
847         uint256[] memory ids,
848         uint256[] memory amounts
849     ) internal virtual {
850         require(from != address(0), "ERC1155: burn from the zero address");
851         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
852 
853         address operator = _msgSender();
854 
855         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
856 
857         for (uint256 i = 0; i < ids.length; i++) {
858             uint256 id = ids[i];
859             uint256 amount = amounts[i];
860 
861             uint256 fromBalance = _balances[id][from];
862             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
863             unchecked {
864                 _balances[id][from] = fromBalance - amount;
865             }
866         }
867 
868         emit TransferBatch(operator, from, address(0), ids, amounts);
869     }
870 
871     /**
872      * @dev Approve `operator` to operate on all of `owner` tokens
873      *
874      * Emits a {ApprovalForAll} event.
875      */
876     function _setApprovalForAll(
877         address owner,
878         address operator,
879         bool approved
880     ) internal virtual {
881         require(owner != operator, "ERC1155: setting approval status for self");
882         _operatorApprovals[owner][operator] = approved;
883         emit ApprovalForAll(owner, operator, approved);
884     }
885 
886     /**
887      * @dev Hook that is called before any token transfer. This includes minting
888      * and burning, as well as batched variants.
889      *
890      * The same hook is called on both single and batched variants. For single
891      * transfers, the length of the `id` and `amount` arrays will be 1.
892      *
893      * Calling conditions (for each `id` and `amount` pair):
894      *
895      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
896      * of token type `id` will be  transferred to `to`.
897      * - When `from` is zero, `amount` tokens of token type `id` will be minted
898      * for `to`.
899      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
900      * will be burned.
901      * - `from` and `to` are never both zero.
902      * - `ids` and `amounts` have the same, non-zero length.
903      *
904      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
905      */
906     function _beforeTokenTransfer(
907         address operator,
908         address from,
909         address to,
910         uint256[] memory ids,
911         uint256[] memory amounts,
912         bytes memory data
913     ) internal virtual {}
914 
915     function _doSafeTransferAcceptanceCheck(
916         address operator,
917         address from,
918         address to,
919         uint256 id,
920         uint256 amount,
921         bytes memory data
922     ) private {
923         if (to.isContract()) {
924             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
925                 if (response != IERC1155Receiver.onERC1155Received.selector) {
926                     revert("ERC1155: ERC1155Receiver rejected tokens");
927                 }
928             } catch Error(string memory reason) {
929                 revert(reason);
930             } catch {
931                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
932             }
933         }
934     }
935 
936     function _doSafeBatchTransferAcceptanceCheck(
937         address operator,
938         address from,
939         address to,
940         uint256[] memory ids,
941         uint256[] memory amounts,
942         bytes memory data
943     ) private {
944         if (to.isContract()) {
945             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
946                 bytes4 response
947             ) {
948                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
949                     revert("ERC1155: ERC1155Receiver rejected tokens");
950                 }
951             } catch Error(string memory reason) {
952                 revert(reason);
953             } catch {
954                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
955             }
956         }
957     }
958 
959     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
960         uint256[] memory array = new uint256[](1);
961         array[0] = element;
962 
963         return array;
964     }
965 }
966 
967 
968 // SPDX-License-Identifier: MIT
969 pragma solidity ^0.8.2;
970 
971 contract ViralCryptoERC1155 is ERC1155, Ownable {
972 
973     bool public mintEnabled;
974     bool public burnEnabled;
975 
976     uint256 public minted;
977     uint256 public burned;
978     uint256 public maxSupply = 1200;
979     uint256 public mintCost = 80000000000000000;
980 
981     mapping(address => bool) public hasBurned;
982     mapping(address => bool) public hasMinted;
983 
984     constructor() ERC1155("https://bafybeiepcmiye7flni7xtnsq555f466sglo3wqykkn25mywfzqnd2qpfmi.ipfs.dweb.link/{id}.json") {}
985 
986     function setURI(string memory newuri) public onlyOwner {
987         _setURI(newuri);
988     }
989 
990     function mint(bytes memory data) public payable {
991         require(mintEnabled, "Minting not enabled");
992         require(hasMinted[msg.sender] == false, "Can only mint 1");
993         require(minted <= maxSupply, "Only 1200 minted");
994         require(msg.value == mintCost, "Not enough ETH sent");
995         uint256 id = 0;
996         uint256 amount = 1;
997         minted += 1;
998         hasMinted[msg.sender] = true;
999         _mint(msg.sender, id, amount, data);
1000     }
1001 
1002     function burn(uint256 id) public payable {
1003         require(burnEnabled, "Burning not enabled");
1004         require(hasBurned[msg.sender] == false, "Can only burn once");
1005         require(balanceOf(msg.sender, id) == 1, "Not owner of");
1006         uint256 amount = 1;
1007         burned += 1;
1008         hasBurned[msg.sender] = true;
1009         _burn(msg.sender, id, amount);
1010     }
1011 
1012     function enableMinting(bool _bool) external onlyOwner {
1013         mintEnabled = _bool;
1014     }
1015 
1016     function enableBurning(bool _bool) external onlyOwner {
1017         burnEnabled = _bool;
1018     }
1019 
1020     function uri(uint256 _tokenId) override public pure returns(string memory) {
1021         _tokenId = 0;
1022         return string(
1023             abi.encodePacked(
1024                 "https://bafybeiepcmiye7flni7xtnsq555f466sglo3wqykkn25mywfzqnd2qpfmi.ipfs.dweb.link/",
1025                 Strings.toString(_tokenId),
1026                 ".json"
1027             )
1028         );
1029     }
1030     
1031     function extract(address payable _address) external onlyOwner {
1032         _address.transfer(address(this).balance);
1033     }
1034     
1035     receive() external payable {}
1036 }