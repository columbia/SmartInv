1 /**
2  *Submitted for verification at Etherscan.io on 2021-10-01
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 interface IERC165 {
10     /**
11      * @dev Returns true if this contract implements the interface defined by
12      * `interfaceId`. See the corresponding
13      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
14      * to learn more about how these ids are created.
15      *
16      * This function call must use less than 30 000 gas.
17      */
18     function supportsInterface(bytes4 interfaceId) external view returns (bool);
19 }
20 
21 interface IERC1155 is IERC165 {
22     /**
23      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
24      */
25     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
26 
27     /**
28      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
29      * transfers.
30      */
31     event TransferBatch(
32         address indexed operator,
33         address indexed from,
34         address indexed to,
35         uint256[] ids,
36         uint256[] values
37     );
38 
39     /**
40      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
41      * `approved`.
42      */
43     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
44 
45     /**
46      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
47      *
48      * If an {URI} event was emitted for `id`, the standard
49      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
50      * returned by {IERC1155MetadataURI-uri}.
51      */
52     event URI(string value, uint256 indexed id);
53 
54     /**
55      * @dev Returns the amount of tokens of token type `id` owned by `account`.
56      *
57      * Requirements:
58      *
59      * - `account` cannot be the zero address.
60      */
61     function balanceOf(address account, uint256 id) external view returns (uint256);
62 
63     /**
64      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
65      *
66      * Requirements:
67      *
68      * - `accounts` and `ids` must have the same length.
69      */
70     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
71         external
72         view
73         returns (uint256[] memory);
74 
75     /**
76      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
77      *
78      * Emits an {ApprovalForAll} event.
79      *
80      * Requirements:
81      *
82      * - `operator` cannot be the caller.
83      */
84     function setApprovalForAll(address operator, bool approved) external;
85 
86     /**
87      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
88      *
89      * See {setApprovalForAll}.
90      */
91     function isApprovedForAll(address account, address operator) external view returns (bool);
92 
93     /**
94      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
95      *
96      * Emits a {TransferSingle} event.
97      *
98      * Requirements:
99      *
100      * - `to` cannot be the zero address.
101      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
102      * - `from` must have a balance of tokens of type `id` of at least `amount`.
103      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
104      * acceptance magic value.
105      */
106     function safeTransferFrom(
107         address from,
108         address to,
109         uint256 id,
110         uint256 amount,
111         bytes calldata data
112     ) external;
113 
114     /**
115      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
116      *
117      * Emits a {TransferBatch} event.
118      *
119      * Requirements:
120      *
121      * - `ids` and `amounts` must have the same length.
122      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
123      * acceptance magic value.
124      */
125     function safeBatchTransferFrom(
126         address from,
127         address to,
128         uint256[] calldata ids,
129         uint256[] calldata amounts,
130         bytes calldata data
131     ) external;
132 }
133 
134 interface IERC1155Receiver is IERC165 {
135     /**
136         @dev Handles the receipt of a single ERC1155 token type. This function is
137         called at the end of a `safeTransferFrom` after the balance has been updated.
138         To accept the transfer, this must return
139         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
140         (i.e. 0xf23a6e61, or its own function selector).
141         @param operator The address which initiated the transfer (i.e. msg.sender)
142         @param from The address which previously owned the token
143         @param id The ID of the token being transferred
144         @param value The amount of tokens being transferred
145         @param data Additional data with no specified format
146         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
147     */
148     function onERC1155Received(
149         address operator,
150         address from,
151         uint256 id,
152         uint256 value,
153         bytes calldata data
154     ) external returns (bytes4);
155 
156     /**
157         @dev Handles the receipt of a multiple ERC1155 token types. This function
158         is called at the end of a `safeBatchTransferFrom` after the balances have
159         been updated. To accept the transfer(s), this must return
160         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
161         (i.e. 0xbc197c81, or its own function selector).
162         @param operator The address which initiated the batch transfer (i.e. msg.sender)
163         @param from The address which previously owned the token
164         @param ids An array containing ids of each token being transferred (order and length must match values array)
165         @param values An array containing amounts of each token being transferred (order and length must match ids array)
166         @param data Additional data with no specified format
167         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
168     */
169     function onERC1155BatchReceived(
170         address operator,
171         address from,
172         uint256[] calldata ids,
173         uint256[] calldata values,
174         bytes calldata data
175     ) external returns (bytes4);
176 }
177 
178 interface IERC1155MetadataURI is IERC1155 {
179     /**
180      * @dev Returns the URI for token type `id`.
181      *
182      * If the `\{id\}` substring is present in the URI, it must be replaced by
183      * clients with the actual token type ID.
184      */
185     function uri(uint256 id) external view returns (string memory);
186 }
187 
188 abstract contract ERC165 is IERC165 {
189     /**
190      * @dev See {IERC165-supportsInterface}.
191      */
192     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
193         return interfaceId == type(IERC165).interfaceId;
194     }
195 }
196 
197 library Address {
198     /**
199      * @dev Returns true if `account` is a contract.
200      *
201      * [IMPORTANT]
202      * ====
203      * It is unsafe to assume that an address for which this function returns
204      * false is an externally-owned account (EOA) and not a contract.
205      *
206      * Among others, `isContract` will return false for the following
207      * types of addresses:
208      *
209      *  - an externally-owned account
210      *  - a contract in construction
211      *  - an address where a contract will be created
212      *  - an address where a contract lived, but was destroyed
213      * ====
214      */
215     function isContract(address account) internal view returns (bool) {
216         // This method relies on extcodesize, which returns 0 for contracts in
217         // construction, since the code is only stored at the end of the
218         // constructor execution.
219 
220         uint256 size;
221         assembly {
222             size := extcodesize(account)
223         }
224         return size > 0;
225     }
226 
227     /**
228      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
229      * `recipient`, forwarding all available gas and reverting on errors.
230      *
231      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
232      * of certain opcodes, possibly making contracts go over the 2300 gas limit
233      * imposed by `transfer`, making them unable to receive funds via
234      * `transfer`. {sendValue} removes this limitation.
235      *
236      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
237      *
238      * IMPORTANT: because control is transferred to `recipient`, care must be
239      * taken to not create reentrancy vulnerabilities. Consider using
240      * {ReentrancyGuard} or the
241      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
242      */
243     function sendValue(address payable recipient, uint256 amount) internal {
244         require(address(this).balance >= amount, "Address: insufficient balance");
245 
246         (bool success, ) = recipient.call{value: amount}("");
247         require(success, "Address: unable to send value, recipient may have reverted");
248     }
249 
250     /**
251      * @dev Performs a Solidity function call using a low level `call`. A
252      * plain `call` is an unsafe replacement for a function call: use this
253      * function instead.
254      *
255      * If `target` reverts with a revert reason, it is bubbled up by this
256      * function (like regular Solidity function calls).
257      *
258      * Returns the raw returned data. To convert to the expected return value,
259      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
260      *
261      * Requirements:
262      *
263      * - `target` must be a contract.
264      * - calling `target` with `data` must not revert.
265      *
266      * _Available since v3.1._
267      */
268     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
269         return functionCall(target, data, "Address: low-level call failed");
270     }
271 
272     /**
273      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
274      * `errorMessage` as a fallback revert reason when `target` reverts.
275      *
276      * _Available since v3.1._
277      */
278     function functionCall(
279         address target,
280         bytes memory data,
281         string memory errorMessage
282     ) internal returns (bytes memory) {
283         return functionCallWithValue(target, data, 0, errorMessage);
284     }
285 
286     /**
287      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
288      * but also transferring `value` wei to `target`.
289      *
290      * Requirements:
291      *
292      * - the calling contract must have an ETH balance of at least `value`.
293      * - the called Solidity function must be `payable`.
294      *
295      * _Available since v3.1._
296      */
297     function functionCallWithValue(
298         address target,
299         bytes memory data,
300         uint256 value
301     ) internal returns (bytes memory) {
302         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
303     }
304 
305     /**
306      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
307      * with `errorMessage` as a fallback revert reason when `target` reverts.
308      *
309      * _Available since v3.1._
310      */
311     function functionCallWithValue(
312         address target,
313         bytes memory data,
314         uint256 value,
315         string memory errorMessage
316     ) internal returns (bytes memory) {
317         require(address(this).balance >= value, "Address: insufficient balance for call");
318         require(isContract(target), "Address: call to non-contract");
319 
320         (bool success, bytes memory returndata) = target.call{value: value}(data);
321         return _verifyCallResult(success, returndata, errorMessage);
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
326      * but performing a static call.
327      *
328      * _Available since v3.3._
329      */
330     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
331         return functionStaticCall(target, data, "Address: low-level static call failed");
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
336      * but performing a static call.
337      *
338      * _Available since v3.3._
339      */
340     function functionStaticCall(
341         address target,
342         bytes memory data,
343         string memory errorMessage
344     ) internal view returns (bytes memory) {
345         require(isContract(target), "Address: static call to non-contract");
346 
347         (bool success, bytes memory returndata) = target.staticcall(data);
348         return _verifyCallResult(success, returndata, errorMessage);
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
353      * but performing a delegate call.
354      *
355      * _Available since v3.4._
356      */
357     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
358         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
363      * but performing a delegate call.
364      *
365      * _Available since v3.4._
366      */
367     function functionDelegateCall(
368         address target,
369         bytes memory data,
370         string memory errorMessage
371     ) internal returns (bytes memory) {
372         require(isContract(target), "Address: delegate call to non-contract");
373 
374         (bool success, bytes memory returndata) = target.delegatecall(data);
375         return _verifyCallResult(success, returndata, errorMessage);
376     }
377 
378     function _verifyCallResult(
379         bool success,
380         bytes memory returndata,
381         string memory errorMessage
382     ) private pure returns (bytes memory) {
383         if (success) {
384             return returndata;
385         } else {
386             // Look for revert reason and bubble it up if present
387             if (returndata.length > 0) {
388                 // The easiest way to bubble the revert reason is using memory via assembly
389 
390                 assembly {
391                     let returndata_size := mload(returndata)
392                     revert(add(32, returndata), returndata_size)
393                 }
394             } else {
395                 revert(errorMessage);
396             }
397         }
398     }
399 }
400 
401 library Strings {
402     bytes16 private constant alphabet = "0123456789abcdef";
403 
404     /**
405      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
406      */
407     function toString(uint256 value) internal pure returns (string memory) {
408         // Inspired by OraclizeAPI's implementation - MIT licence
409         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
410 
411         if (value == 0) {
412             return "0";
413         }
414         uint256 temp = value;
415         uint256 digits;
416         while (temp != 0) {
417             digits++;
418             temp /= 10;
419         }
420         bytes memory buffer = new bytes(digits);
421         while (value != 0) {
422             digits -= 1;
423             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
424             value /= 10;
425         }
426         return string(buffer);
427     }
428 
429     /**
430      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
431      */
432     function toHexString(uint256 value) internal pure returns (string memory) {
433         if (value == 0) {
434             return "0x00";
435         }
436         uint256 temp = value;
437         uint256 length = 0;
438         while (temp != 0) {
439             length++;
440             temp >>= 8;
441         }
442         return toHexString(value, length);
443     }
444 
445     /**
446      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
447      */
448     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
449         bytes memory buffer = new bytes(2 * length + 2);
450         buffer[0] = "0";
451         buffer[1] = "x";
452         for (uint256 i = 2 * length + 1; i > 1; --i) {
453             buffer[i] = alphabet[value & 0xf];
454             value >>= 4;
455         }
456         require(value == 0, "Strings: hex length insufficient");
457         return string(buffer);
458     }
459 
460 }
461 
462 contract ERC1155 is ERC165, IERC1155, IERC1155MetadataURI {
463     using Address for address;
464     using Strings for uint256;
465     
466     address payable _owner1;
467     address payable _owner2;
468     
469     uint256 private _price = 950000000000000000;
470     uint256 private _maxMints = 10;
471     uint256 private _episode = 0;
472     
473     // Mapping from token ID to account balances
474     mapping(uint256 => mapping(address => uint256)) private _balances;
475 
476     // Mapping from account to operator approvals
477     mapping(address => mapping(address => bool)) private _operatorApprovals;
478     
479     mapping(uint256 => mapping(address => uint256)) private _mints;
480     
481     mapping(uint256 => uint256) private _totalMints;
482 
483     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
484     mapping(uint256 => string) private _uri;
485     
486     function owner() external view returns (address) {
487         return _owner1;
488     }
489     
490     function webData(address user) external view returns(uint256 maxMint, uint256 episode, uint256 leftNFT, uint256 userMints, uint256 price) {
491         maxMint = _maxMints;
492         episode = _episode;
493         leftNFT = 333 - _totalMints[_episode];
494         userMints = _mints[episode][user];
495         price = _price;
496     }
497     
498     function changeOwner1(address payable owner) external {
499         require(msg.sender == _owner1);
500         _owner1 = owner;
501     }
502     
503     function changeOwner2(address payable owner) external {
504         require(msg.sender == _owner2);
505         _owner2 = owner;
506     }
507     
508     function changePrice(uint256 newPrice) external {
509         require(msg.sender == _owner1 || msg.sender == _owner2);
510         _price = newPrice;
511     }
512     
513     function changeMintLimit(uint256 newLimit) external {
514         require(msg.sender == _owner1 || msg.sender == _owner2);
515         _maxMints = newLimit;
516     }
517 
518     constructor(address payable owner1, address payable owner2) {
519         _owner1 = owner1;
520         _owner2 = owner2;
521         
522         _balances[0][owner1] += 8;
523         _balances[0][owner2] += 8;
524         _totalMints[0] = 16;
525         emit TransferSingle(msg.sender, address(0), owner1, 0, 8);
526         emit TransferSingle(msg.sender, address(0), owner2, 0, 8);
527         
528     }
529     
530     function concat(string memory _base, string memory _value) pure internal returns (string memory) {
531         bytes memory _baseBytes = bytes(_base);
532         bytes memory _valueBytes = bytes(_value);
533         
534         string memory _tmpValue = new string(_baseBytes.length + _valueBytes.length);
535         bytes memory _newValue = bytes(_tmpValue);
536         
537         uint i;
538         uint j;
539         
540         for(i=0;i<_baseBytes.length;i++) {
541             _newValue[j++] = _baseBytes[i];
542         }
543         
544         for(i=0;i<_valueBytes.length;i++) {
545             _newValue[j++] = _valueBytes[i];
546         }
547         
548         return string(_newValue);
549     }
550     
551     function uri(uint256 id) external view override returns (string memory) {
552         return _uri[id];
553     }
554     
555     function setUri(uint256 id, string calldata uri) external {
556         require(msg.sender == _owner1 || msg.sender == _owner2);
557         _uri[id] = uri;
558     }
559     
560     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
561         return
562             interfaceId == type(IERC1155).interfaceId ||
563             interfaceId == type(IERC1155MetadataURI).interfaceId ||
564             super.supportsInterface(interfaceId);
565     }
566 
567     function balanceOf(address account, uint256 id) public view override returns (uint256) {
568         require(account != address(0), "ERC1155: balance query for the zero address");
569         return _balances[id][account];
570     }
571 
572     function balanceOfBatch(address[] memory accounts, uint256[] memory ids) external view override returns (uint256[] memory) {
573         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
574 
575         uint256[] memory batchBalances = new uint256[](accounts.length);
576 
577         for (uint256 i = 0; i < accounts.length; ++i) {
578             batchBalances[i] = balanceOf(accounts[i], ids[i]);
579         }
580 
581         return batchBalances;
582     }
583 
584     function setApprovalForAll(address operator, bool approved) external override {
585         require(msg.sender != operator, "ERC1155: setting approval status for self");
586 
587         _operatorApprovals[msg.sender][operator] = approved;
588         emit ApprovalForAll(msg.sender, operator, approved);
589     }
590 
591     function isApprovedForAll(address account, address operator) public view override returns (bool) {
592         return _operatorApprovals[account][operator];
593     }
594 
595     function safeTransferFrom(address from,address to,uint256 id,uint256 amount,bytes memory data) external override {
596         require(
597             from == msg.sender || isApprovedForAll(from, msg.sender),
598             "ERC1155: caller is not owner nor approved"
599         );
600         _safeTransferFrom(from, to, id, amount, data);
601     }
602 
603     function safeBatchTransferFrom(address from,address to,uint256[] memory ids,uint256[] memory amounts,bytes memory data) public virtual override {
604         require(
605             from == msg.sender || isApprovedForAll(from, msg.sender),
606             "ERC1155: transfer caller is not owner nor approved"
607         );
608         _safeBatchTransferFrom(from, to, ids, amounts, data);
609     }
610 
611     function _safeTransferFrom(address from,address to,uint256 id,uint256 amount,bytes memory data) internal virtual {
612         require(to != address(0), "ERC1155: transfer to the zero address");
613 
614         uint256 fromBalance = _balances[id][from];
615         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
616         unchecked {
617             _balances[id][from] = fromBalance - amount;
618         }
619         _balances[id][to] += amount;
620 
621         emit TransferSingle(msg.sender, from, to, id, amount);
622 
623         _doSafeTransferAcceptanceCheck(msg.sender, from, to, id, amount, data);
624     }
625 
626     function _safeBatchTransferFrom(address from,address to,uint256[] memory ids,uint256[] memory amounts,bytes memory data) internal virtual {
627         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
628         require(to != address(0), "ERC1155: transfer to the zero address");
629 
630         for (uint256 i = 0; i < ids.length; ++i) {
631             uint256 id = ids[i];
632             uint256 amount = amounts[i];
633 
634             uint256 fromBalance = _balances[id][from];
635             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
636             unchecked {
637                 _balances[id][from] = fromBalance - amount;
638             }
639             _balances[id][to] += amount;
640         }
641 
642         emit TransferBatch(msg.sender, from, to, ids, amounts);
643 
644         _doSafeBatchTransferAcceptanceCheck(msg.sender, from, to, ids, amounts, data);
645     }
646     
647     function adminMint(address account, uint256 amount) external {
648         require(msg.sender == _owner1 || msg.sender == _owner2);
649         uint256 id = _episode; 
650         require(account != address(0), "ERC1155: mint to the zero address");
651         require(_totalMints[id] + amount <= 333, "TheRedApeFamily: Insufficient NFTs for minting");
652         
653         _totalMints[id] += amount;
654         
655         _balances[id][account] += amount;
656         
657         emit TransferSingle(msg.sender, address(0), account, id, amount);
658     }
659     
660     function _mint(address account, uint256 amount) external payable {
661         uint256 id = _episode; 
662         require(msg.value == _price * amount, "TheRedApeFamily: Insufficient balance");
663         require(account != address(0), "ERC1155: mint to the zero address");
664         require(_mints[id][msg.sender] + amount <= _maxMints, "TheRedApeFamily: Max mints reached");
665         require(_totalMints[id] + amount <= 333, "TheRedApeFamily: Insufficient NFTs for minting");
666         
667         _totalMints[id] += amount;
668         _mints[id][msg.sender] += amount;
669         
670         _balances[id][account] += amount;
671         
672         emit TransferSingle(msg.sender, address(0), account, id, amount);
673 
674     }
675     
676     function distributeEth() external {
677         _owner1.transfer(address(this).balance / 2);
678         _owner2.transfer(address(this).balance);
679     }
680     
681     function nextEpisode() external {
682         require(msg.sender == _owner1 || msg.sender == _owner2);
683         uint256 episode = ++_episode;
684         
685         _balances[episode][_owner1] += 8;
686         _balances[episode][_owner2] += 8;
687         emit TransferSingle(msg.sender, address(0), _owner1, episode, 8);
688         emit TransferSingle(msg.sender, address(0), _owner2, episode, 8);
689         _totalMints[episode] = 16;
690         
691     }
692 
693     function _doSafeTransferAcceptanceCheck(address operator, address from, address to, uint256 id, uint256 amount, bytes memory data) private {
694         if (to.isContract()) {
695             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
696                 if (response != IERC1155Receiver(to).onERC1155Received.selector) {
697                     revert("ERC1155: ERC1155Receiver rejected tokens");
698                 }
699             } catch Error(string memory reason) {
700                 revert(reason);
701             } catch {
702                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
703             }
704         }
705     }
706 
707     function _doSafeBatchTransferAcceptanceCheck(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) private {
708         if (to.isContract()) {
709             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
710                 bytes4 response
711             ) {
712                 if (response != IERC1155Receiver(to).onERC1155BatchReceived.selector) {
713                     revert("ERC1155: ERC1155Receiver rejected tokens");
714                 }
715             } catch Error(string memory reason) {
716                 revert(reason);
717             } catch {
718                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
719             }
720         }
721     }
722 
723     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
724         uint256[] memory array = new uint256[](1);
725         array[0] = element;
726 
727         return array;
728     }
729 }