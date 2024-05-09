1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.9;
4 
5 /**
6 
7  ,ggggggggggg,                                             gg                                      
8 dP"""88""""""Y8,                                          dP8,                                     
9 Yb,  88      `8b                                         dP Yb                                     
10  `"  88      ,8P gg                  gg                 ,8  `8,                                    
11      88aaaad8P"  ""                  ""                 I8   Yb                                    
12      88"""""     gg      ,gg,   ,gg  gg    ,ggg,        `8b, `8,     ,gggg,gg   ,gggggg,    ,g,    
13      88          88     d8""8b,dP"   88   i8" "8i        `"Y88888   dP"  "Y8I   dP""""8I   ,8'8,   
14      88          88    dP   ,88"     88   I8, ,8I            "Y8   i8'    ,8I  ,8'    8I  ,8'  Yb  
15      88        _,88,_,dP  ,dP"Y8,  _,88,_ `YbadP'             ,88,,d8,   ,d8b,,dP     Y8,,8'_   8) 
16      88        8P""Y88"  dP"   "Y888P""Y8888P"Y888        ,ad88888P"Y8888P"`Y88P      `Y8P' "YY8P8P
17                                                         ,dP"'   Yb                                 
18                                                        ,8'      I8                                 
19                                                       ,8'       I8                                 
20                                                       I8,      ,8'                                 
21                                                       `Y8,___,d8'                                  
22                                                         "Y888P"                                    
23  ,ggggggggggg,                                                                                     
24 dP"""88""""""Y8,                                                           8I                      
25 Yb,  88      `8b                                                           8I                      
26  `"  88      ,8P                                                           8I                      
27      88aaaad8P"                                                            8I                      
28      88""""Yb,     ,ggg,   gg    gg    gg     ,gggg,gg   ,gggggg,    ,gggg,8I    ,g,               
29      88     "8b   i8" "8i  I8    I8    88bg  dP"  "Y8I   dP""""8I   dP"  "Y8I   ,8'8,              
30      88      `8i  I8, ,8I  I8    I8    8I   i8'    ,8I  ,8'    8I  i8'    ,8I  ,8'  Yb             
31      88       Yb, `YbadP' ,d8,  ,d8,  ,8I  ,d8,   ,d8b,,dP     Y8,,d8,   ,d8b,,8'_   8)            
32      88        Y8888P"Y888P""Y88P""Y88P"   P"Y8888P"`Y88P      `Y8P"Y8888P"`Y8P' "YY8P8P           
33                                                                                                    
34 
35 */
36 
37 
38 
39 /**
40  * @dev Interface of the ERC165 standard, as defined in the
41  * https://eips.ethereum.org/EIPS/eip-165[EIP].
42  *
43  * Implementers can declare support of contract interfaces, which can then be
44  * queried by others ({ERC165Checker}).
45  *
46  * For an implementation, see {ERC165}.
47  */
48 interface IERC165 {
49     /**
50      * @dev Returns true if this contract implements the interface defined by
51      * `interfaceId`. See the corresponding
52      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
53      * to learn more about how these ids are created.
54      *
55      * This function call must use less than 30 000 gas.
56      */
57     function supportsInterface(bytes4 interfaceId) external view returns (bool);
58 }
59 
60 
61 /**
62  * @dev Implementation of the {IERC165} interface.
63  *
64  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
65  * for the additional interface id that will be supported. For example:
66  *
67  * ```solidity
68  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
69  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
70  * }
71  * ```
72  *
73  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
74  */
75 abstract contract ERC165 is IERC165 {
76     /**
77      * @dev See {IERC165-supportsInterface}.
78      */
79     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
80         return interfaceId == type(IERC165).interfaceId;
81     }
82 }
83 
84 
85 
86 
87 /**
88  * @dev Provides information about the current execution context, including the
89  * sender of the transaction and its data. While these are generally available
90  * via msg.sender and msg.data, they should not be accessed in such a direct
91  * manner, since when dealing with meta-transactions the account sending and
92  * paying for execution may not be the actual sender (as far as an application
93  * is concerned).
94  *
95  * This contract is only required for intermediate, library-like contracts.
96  */
97 abstract contract Context {
98     function _msgSender() internal view virtual returns (address) {
99         return msg.sender;
100     }
101 
102     function _msgData() internal view virtual returns (bytes calldata) {
103         return msg.data;
104     }
105 }
106 
107 
108 
109 
110 
111 /**
112  * @dev Contract module which provides a basic access control mechanism, where
113  * there is an account (an owner) that can be granted exclusive access to
114  * specific functions.
115  *
116  * By default, the owner account will be the one that deploys the contract. This
117  * can later be changed with {transferOwnership}.
118  *
119  * This module is used through inheritance. It will make available the modifier
120  * `onlyOwner`, which can be applied to your functions to restrict their use to
121  * the owner.
122  */
123 abstract contract Ownable is Context {
124     address private _owner;
125 
126     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
127 
128     /**
129      * @dev Initializes the contract setting the deployer as the initial owner.
130      */
131     constructor() {
132         _transferOwnership(_msgSender());
133     }
134 
135     /**
136      * @dev Returns the address of the current owner.
137      */
138     function owner() public view virtual returns (address) {
139         return _owner;
140     }
141 
142     /**
143      * @dev Throws if called by any account other than the owner.
144      */
145     modifier onlyOwner() {
146         require(owner() == _msgSender(), "Ownable: caller is not the owner");
147         _;
148     }
149 
150     /**
151      * @dev Leaves the contract without owner. It will not be possible to call
152      * `onlyOwner` functions anymore. Can only be called by the current owner.
153      *
154      * NOTE: Renouncing ownership will leave the contract without an owner,
155      * thereby removing any functionality that is only available to the owner.
156      */
157     function renounceOwnership() public virtual onlyOwner {
158         _transferOwnership(address(0));
159     }
160 
161     /**
162      * @dev Transfers ownership of the contract to a new account (`newOwner`).
163      * Can only be called by the current owner.
164      */
165     function transferOwnership(address newOwner) public virtual onlyOwner {
166         require(newOwner != address(0), "Ownable: new owner is the zero address");
167         _transferOwnership(newOwner);
168     }
169 
170     /**
171      * @dev Transfers ownership of the contract to a new account (`newOwner`).
172      * Internal function without access restriction.
173      */
174     function _transferOwnership(address newOwner) internal virtual {
175         address oldOwner = _owner;
176         _owner = newOwner;
177         emit OwnershipTransferred(oldOwner, newOwner);
178     }
179 }
180 
181 
182 
183 /**
184  * @dev Required interface of an ERC1155 compliant contract, as defined in the
185  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
186  *
187  * _Available since v3.1._
188  */
189 interface IERC1155 is IERC165 {
190     /**
191      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
192      */
193     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
194 
195     /**
196      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
197      * transfers.
198      */
199     event TransferBatch(
200         address indexed operator,
201         address indexed from,
202         address indexed to,
203         uint256[] ids,
204         uint256[] values
205     );
206 
207     /**
208      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
209      * `approved`.
210      */
211     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
212 
213     /**
214      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
215      *
216      * If an {URI} event was emitted for `id`, the standard
217      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
218      * returned by {IERC1155MetadataURI-uri}.
219      */
220     event URI(string value, uint256 indexed id);
221 
222     /**
223      * @dev Returns the amount of tokens of token type `id` owned by `account`.
224      *
225      * Requirements:
226      *
227      * - `account` cannot be the zero address.
228      */
229     function balanceOf(address account, uint256 id) external view returns (uint256);
230 
231     /**
232      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
233      *
234      * Requirements:
235      *
236      * - `accounts` and `ids` must have the same length.
237      */
238     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
239         external
240         view
241         returns (uint256[] memory);
242 
243     /**
244      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
245      *
246      * Emits an {ApprovalForAll} event.
247      *
248      * Requirements:
249      *
250      * - `operator` cannot be the caller.
251      */
252     function setApprovalForAll(address operator, bool approved) external;
253 
254     /**
255      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
256      *
257      * See {setApprovalForAll}.
258      */
259     function isApprovedForAll(address account, address operator) external view returns (bool);
260 
261     /**
262      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
263      *
264      * Emits a {TransferSingle} event.
265      *
266      * Requirements:
267      *
268      * - `to` cannot be the zero address.
269      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
270      * - `from` must have a balance of tokens of type `id` of at least `amount`.
271      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
272      * acceptance magic value.
273      */
274     function safeTransferFrom(
275         address from,
276         address to,
277         uint256 id,
278         uint256 amount,
279         bytes calldata data
280     ) external;
281 
282     /**
283      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
284      *
285      * Emits a {TransferBatch} event.
286      *
287      * Requirements:
288      *
289      * - `ids` and `amounts` must have the same length.
290      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
291      * acceptance magic value.
292      */
293     function safeBatchTransferFrom(
294         address from,
295         address to,
296         uint256[] calldata ids,
297         uint256[] calldata amounts,
298         bytes calldata data
299     ) external;
300 }
301 
302 
303 
304 
305 
306 
307 
308 /**
309  * @dev _Available since v3.1._
310  */
311 interface IERC1155Receiver is IERC165 {
312     /**
313      * @dev Handles the receipt of a single ERC1155 token type. This function is
314      * called at the end of a `safeTransferFrom` after the balance has been updated.
315      *
316      * NOTE: To accept the transfer, this must return
317      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
318      * (i.e. 0xf23a6e61, or its own function selector).
319      *
320      * @param operator The address which initiated the transfer (i.e. msg.sender)
321      * @param from The address which previously owned the token
322      * @param id The ID of the token being transferred
323      * @param value The amount of tokens being transferred
324      * @param data Additional data with no specified format
325      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
326      */
327     function onERC1155Received(
328         address operator,
329         address from,
330         uint256 id,
331         uint256 value,
332         bytes calldata data
333     ) external returns (bytes4);
334 
335     /**
336      * @dev Handles the receipt of a multiple ERC1155 token types. This function
337      * is called at the end of a `safeBatchTransferFrom` after the balances have
338      * been updated.
339      *
340      * NOTE: To accept the transfer(s), this must return
341      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
342      * (i.e. 0xbc197c81, or its own function selector).
343      *
344      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
345      * @param from The address which previously owned the token
346      * @param ids An array containing ids of each token being transferred (order and length must match values array)
347      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
348      * @param data Additional data with no specified format
349      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
350      */
351     function onERC1155BatchReceived(
352         address operator,
353         address from,
354         uint256[] calldata ids,
355         uint256[] calldata values,
356         bytes calldata data
357     ) external returns (bytes4);
358 }
359 
360 
361 
362 
363 /**
364  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
365  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
366  *
367  * _Available since v3.1._
368  */
369 interface IERC1155MetadataURI is IERC1155 {
370     /**
371      * @dev Returns the URI for token type `id`.
372      *
373      * If the `\{id\}` substring is present in the URI, it must be replaced by
374      * clients with the actual token type ID.
375      */
376     function uri(uint256 id) external view returns (string memory);
377 }
378 
379 
380 
381 
382 
383 
384 
385 
386 
387 
388 /**
389  * @dev Implementation of the basic standard multi-token.
390  * See https://eips.ethereum.org/EIPS/eip-1155
391  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
392  *
393  * _Available since v3.1._
394  */
395 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
396     using Address for address;
397 
398     // Mapping from token ID to account balances
399     mapping(uint256 => mapping(address => uint256)) private _balances;
400 
401     // Mapping from account to operator approvals
402     mapping(address => mapping(address => bool)) private _operatorApprovals;
403 
404     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
405     string private _uri;
406 
407     /**
408      * @dev See {_setURI}.
409      */
410     constructor(string memory uri_) {
411         _setURI(uri_);
412     }
413 
414     /**
415      * @dev See {IERC165-supportsInterface}.
416      */
417     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
418         return
419             interfaceId == type(IERC1155).interfaceId ||
420             interfaceId == type(IERC1155MetadataURI).interfaceId ||
421             super.supportsInterface(interfaceId);
422     }
423 
424     /**
425      * @dev See {IERC1155MetadataURI-uri}.
426      *
427      * This implementation returns the same URI for *all* token types. It relies
428      * on the token type ID substitution mechanism
429      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
430      *
431      * Clients calling this function must replace the `\{id\}` substring with the
432      * actual token type ID.
433      */
434     function uri(uint256) public view virtual override returns (string memory) {
435         return _uri;
436     }
437 
438     /**
439      * @dev See {IERC1155-balanceOf}.
440      *
441      * Requirements:
442      *
443      * - `account` cannot be the zero address.
444      */
445     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
446         require(account != address(0), "ERC1155: address zero is not a valid owner");
447         return _balances[id][account];
448     }
449 
450     /**
451      * @dev See {IERC1155-balanceOfBatch}.
452      *
453      * Requirements:
454      *
455      * - `accounts` and `ids` must have the same length.
456      */
457     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
458         public
459         view
460         virtual
461         override
462         returns (uint256[] memory)
463     {
464         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
465 
466         uint256[] memory batchBalances = new uint256[](accounts.length);
467 
468         for (uint256 i = 0; i < accounts.length; ++i) {
469             batchBalances[i] = balanceOf(accounts[i], ids[i]);
470         }
471 
472         return batchBalances;
473     }
474 
475     /**
476      * @dev See {IERC1155-setApprovalForAll}.
477      */
478     function setApprovalForAll(address operator, bool approved) public virtual override {
479         _setApprovalForAll(_msgSender(), operator, approved);
480     }
481 
482     /**
483      * @dev See {IERC1155-isApprovedForAll}.
484      */
485     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
486         return _operatorApprovals[account][operator];
487     }
488 
489     /**
490      * @dev See {IERC1155-safeTransferFrom}.
491      */
492     function safeTransferFrom(
493         address from,
494         address to,
495         uint256 id,
496         uint256 amount,
497         bytes memory data
498     ) public virtual override {
499         require(
500             from == _msgSender() || isApprovedForAll(from, _msgSender()),
501             "ERC1155: caller is not owner nor approved"
502         );
503         _safeTransferFrom(from, to, id, amount, data);
504     }
505 
506     /**
507      * @dev See {IERC1155-safeBatchTransferFrom}.
508      */
509     function safeBatchTransferFrom(
510         address from,
511         address to,
512         uint256[] memory ids,
513         uint256[] memory amounts,
514         bytes memory data
515     ) public virtual override {
516         require(
517             from == _msgSender() || isApprovedForAll(from, _msgSender()),
518             "ERC1155: transfer caller is not owner nor approved"
519         );
520         _safeBatchTransferFrom(from, to, ids, amounts, data);
521     }
522 
523     /**
524      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
525      *
526      * Emits a {TransferSingle} event.
527      *
528      * Requirements:
529      *
530      * - `to` cannot be the zero address.
531      * - `from` must have a balance of tokens of type `id` of at least `amount`.
532      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
533      * acceptance magic value.
534      */
535     function _safeTransferFrom(
536         address from,
537         address to,
538         uint256 id,
539         uint256 amount,
540         bytes memory data
541     ) internal virtual {
542         require(to != address(0), "ERC1155: transfer to the zero address");
543 
544         address operator = _msgSender();
545         uint256[] memory ids = _asSingletonArray(id);
546         uint256[] memory amounts = _asSingletonArray(amount);
547 
548         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
549 
550         uint256 fromBalance = _balances[id][from];
551         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
552         unchecked {
553             _balances[id][from] = fromBalance - amount;
554         }
555         _balances[id][to] += amount;
556 
557         emit TransferSingle(operator, from, to, id, amount);
558 
559         _afterTokenTransfer(operator, from, to, ids, amounts, data);
560 
561         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
562     }
563 
564     /**
565      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
566      *
567      * Emits a {TransferBatch} event.
568      *
569      * Requirements:
570      *
571      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
572      * acceptance magic value.
573      */
574     function _safeBatchTransferFrom(
575         address from,
576         address to,
577         uint256[] memory ids,
578         uint256[] memory amounts,
579         bytes memory data
580     ) internal virtual {
581         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
582         require(to != address(0), "ERC1155: transfer to the zero address");
583 
584         address operator = _msgSender();
585 
586         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
587 
588         for (uint256 i = 0; i < ids.length; ++i) {
589             uint256 id = ids[i];
590             uint256 amount = amounts[i];
591 
592             uint256 fromBalance = _balances[id][from];
593             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
594             unchecked {
595                 _balances[id][from] = fromBalance - amount;
596             }
597             _balances[id][to] += amount;
598         }
599 
600         emit TransferBatch(operator, from, to, ids, amounts);
601 
602         _afterTokenTransfer(operator, from, to, ids, amounts, data);
603 
604         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
605     }
606 
607     /**
608      * @dev Sets a new URI for all token types, by relying on the token type ID
609      * substitution mechanism
610      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
611      *
612      * By this mechanism, any occurrence of the `\{id\}` substring in either the
613      * URI or any of the amounts in the JSON file at said URI will be replaced by
614      * clients with the token type ID.
615      *
616      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
617      * interpreted by clients as
618      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
619      * for token type ID 0x4cce0.
620      *
621      * See {uri}.
622      *
623      * Because these URIs cannot be meaningfully represented by the {URI} event,
624      * this function emits no events.
625      */
626     function _setURI(string memory newuri) internal virtual {
627         _uri = newuri;
628     }
629 
630     /**
631      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
632      *
633      * Emits a {TransferSingle} event.
634      *
635      * Requirements:
636      *
637      * - `to` cannot be the zero address.
638      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
639      * acceptance magic value.
640      */
641     function _mint(
642         address to,
643         uint256 id,
644         uint256 amount,
645         bytes memory data
646     ) internal virtual {
647         require(to != address(0), "ERC1155: mint to the zero address");
648 
649         address operator = _msgSender();
650         uint256[] memory ids = _asSingletonArray(id);
651         uint256[] memory amounts = _asSingletonArray(amount);
652 
653         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
654 
655         _balances[id][to] += amount;
656         emit TransferSingle(operator, address(0), to, id, amount);
657 
658         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
659 
660         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
661     }
662 
663     /**
664      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
665      *
666      * Requirements:
667      *
668      * - `ids` and `amounts` must have the same length.
669      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
670      * acceptance magic value.
671      */
672     function _mintBatch(
673         address to,
674         uint256[] memory ids,
675         uint256[] memory amounts,
676         bytes memory data
677     ) internal virtual {
678         require(to != address(0), "ERC1155: mint to the zero address");
679         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
680 
681         address operator = _msgSender();
682 
683         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
684 
685         for (uint256 i = 0; i < ids.length; i++) {
686             _balances[ids[i]][to] += amounts[i];
687         }
688 
689         emit TransferBatch(operator, address(0), to, ids, amounts);
690 
691         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
692 
693         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
694     }
695 
696     /**
697      * @dev Destroys `amount` tokens of token type `id` from `from`
698      *
699      * Requirements:
700      *
701      * - `from` cannot be the zero address.
702      * - `from` must have at least `amount` tokens of token type `id`.
703      */
704     function _burn(
705         address from,
706         uint256 id,
707         uint256 amount
708     ) internal virtual {
709         require(from != address(0), "ERC1155: burn from the zero address");
710 
711         address operator = _msgSender();
712         uint256[] memory ids = _asSingletonArray(id);
713         uint256[] memory amounts = _asSingletonArray(amount);
714 
715         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
716 
717         uint256 fromBalance = _balances[id][from];
718         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
719         unchecked {
720             _balances[id][from] = fromBalance - amount;
721         }
722 
723         emit TransferSingle(operator, from, address(0), id, amount);
724 
725         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
726     }
727 
728     /**
729      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
730      *
731      * Requirements:
732      *
733      * - `ids` and `amounts` must have the same length.
734      */
735     function _burnBatch(
736         address from,
737         uint256[] memory ids,
738         uint256[] memory amounts
739     ) internal virtual {
740         require(from != address(0), "ERC1155: burn from the zero address");
741         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
742 
743         address operator = _msgSender();
744 
745         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
746 
747         for (uint256 i = 0; i < ids.length; i++) {
748             uint256 id = ids[i];
749             uint256 amount = amounts[i];
750 
751             uint256 fromBalance = _balances[id][from];
752             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
753             unchecked {
754                 _balances[id][from] = fromBalance - amount;
755             }
756         }
757 
758         emit TransferBatch(operator, from, address(0), ids, amounts);
759 
760         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
761     }
762 
763     /**
764      * @dev Approve `operator` to operate on all of `owner` tokens
765      *
766      * Emits a {ApprovalForAll} event.
767      */
768     function _setApprovalForAll(
769         address owner,
770         address operator,
771         bool approved
772     ) internal virtual {
773         require(owner != operator, "ERC1155: setting approval status for self");
774         _operatorApprovals[owner][operator] = approved;
775         emit ApprovalForAll(owner, operator, approved);
776     }
777 
778     /**
779      * @dev Hook that is called before any token transfer. This includes minting
780      * and burning, as well as batched variants.
781      *
782      * The same hook is called on both single and batched variants. For single
783      * transfers, the length of the `id` and `amount` arrays will be 1.
784      *
785      * Calling conditions (for each `id` and `amount` pair):
786      *
787      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
788      * of token type `id` will be  transferred to `to`.
789      * - When `from` is zero, `amount` tokens of token type `id` will be minted
790      * for `to`.
791      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
792      * will be burned.
793      * - `from` and `to` are never both zero.
794      * - `ids` and `amounts` have the same, non-zero length.
795      *
796      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
797      */
798     function _beforeTokenTransfer(
799         address operator,
800         address from,
801         address to,
802         uint256[] memory ids,
803         uint256[] memory amounts,
804         bytes memory data
805     ) internal virtual {}
806 
807     /**
808      * @dev Hook that is called after any token transfer. This includes minting
809      * and burning, as well as batched variants.
810      *
811      * The same hook is called on both single and batched variants. For single
812      * transfers, the length of the `id` and `amount` arrays will be 1.
813      *
814      * Calling conditions (for each `id` and `amount` pair):
815      *
816      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
817      * of token type `id` will be  transferred to `to`.
818      * - When `from` is zero, `amount` tokens of token type `id` will be minted
819      * for `to`.
820      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
821      * will be burned.
822      * - `from` and `to` are never both zero.
823      * - `ids` and `amounts` have the same, non-zero length.
824      *
825      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
826      */
827     function _afterTokenTransfer(
828         address operator,
829         address from,
830         address to,
831         uint256[] memory ids,
832         uint256[] memory amounts,
833         bytes memory data
834     ) internal virtual {}
835 
836     function _doSafeTransferAcceptanceCheck(
837         address operator,
838         address from,
839         address to,
840         uint256 id,
841         uint256 amount,
842         bytes memory data
843     ) private {
844         if (to.isContract()) {
845             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
846                 if (response != IERC1155Receiver.onERC1155Received.selector) {
847                     revert("ERC1155: ERC1155Receiver rejected tokens");
848                 }
849             } catch Error(string memory reason) {
850                 revert(reason);
851             } catch {
852                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
853             }
854         }
855     }
856 
857     function _doSafeBatchTransferAcceptanceCheck(
858         address operator,
859         address from,
860         address to,
861         uint256[] memory ids,
862         uint256[] memory amounts,
863         bytes memory data
864     ) private {
865         if (to.isContract()) {
866             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
867                 bytes4 response
868             ) {
869                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
870                     revert("ERC1155: ERC1155Receiver rejected tokens");
871                 }
872             } catch Error(string memory reason) {
873                 revert(reason);
874             } catch {
875                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
876             }
877         }
878     }
879 
880     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
881         uint256[] memory array = new uint256[](1);
882         array[0] = element;
883 
884         return array;
885     }
886 }
887 
888 
889 
890 
891 
892 
893 
894 
895 
896 abstract contract PixieJars { 
897     function balanceOf(address owner) public view virtual returns (uint256);
898 }
899 
900 
901 
902 contract PixieJarsRewards is ERC1155, Ownable {
903     using Strings for uint256;
904     
905     mapping(uint256 => string) private rewardURI;
906     mapping(uint256 => bool) private validRewards;
907     mapping(uint256 => mapping(address => bool)) claimedReward;
908     mapping (uint256 => address) public creators;
909     mapping (uint256 => uint256) public tokenSupply;
910 
911     uint256 public rewardCampaignID;
912     uint256 private rewardCampaignMultiplier = 1000;
913     bool public campaignRewardClaimOpen;
914     bool public snapshotRewardClaimOpen;
915 
916     uint256 public TIER_1_MINIMUM = 1;
917     uint256 public TIER_2_MINIMUM = 5;
918     uint256 public TIER_3_MINIMUM = 10;
919     uint256 public TIER_4_MINIMUM = 50;
920 
921     bytes32 public snapshotMerkleRoot;
922 
923     PixieJars pjContract = PixieJars(0xeA508034fCC8eefF24bF43effe42621008359A2E);
924     
925     // Contract name
926     string public name;
927     // Contract symbol
928     string public symbol;
929 
930     constructor(string memory _name, string memory _symbol, string memory _baseURI) ERC1155(_baseURI) {
931         name = _name;
932         symbol = _symbol; 
933     }
934 
935     function setPixieJarsContract(address _address) external onlyOwner {
936         pjContract = PixieJars(_address);
937     }
938 
939     function setSnapshotMerkleRoot(bytes32 _root) external onlyOwner {
940         snapshotMerkleRoot = _root; 
941     }
942 
943     function setCampaignClaimOpen(bool _open) external onlyOwner {
944         campaignRewardClaimOpen = _open; 
945     }
946 
947     function setSnapshotClaimOpen(bool _open) external onlyOwner {
948         snapshotRewardClaimOpen = _open; 
949     }
950 
951     function newRewardCampaign(uint256 tier1Min, uint256 tier2Min, uint256 tier3Min, uint256 tier4Min, 
952         string memory tier1URI, string memory tier2URI, string memory tier3URI, string memory tier4URI) external onlyOwner {
953         require(!campaignRewardClaimOpen, "Claims must be closed to add new rewards.");
954 
955         TIER_1_MINIMUM = tier1Min;
956         TIER_2_MINIMUM = tier2Min;
957         TIER_3_MINIMUM = tier3Min;
958         TIER_4_MINIMUM = tier4Min;
959         rewardCampaignID++;
960 
961         rewardURI[rewardCampaignID * rewardCampaignMultiplier + 1] = tier1URI;
962         rewardURI[rewardCampaignID * rewardCampaignMultiplier + 2] = tier2URI;
963         rewardURI[rewardCampaignID * rewardCampaignMultiplier + 3] = tier3URI;
964         rewardURI[rewardCampaignID * rewardCampaignMultiplier + 4] = tier4URI;
965 
966         validRewards[rewardCampaignID * rewardCampaignMultiplier + 1] = true;
967         validRewards[rewardCampaignID * rewardCampaignMultiplier + 2] = true;
968         validRewards[rewardCampaignID * rewardCampaignMultiplier + 3] = true;
969         validRewards[rewardCampaignID * rewardCampaignMultiplier + 4] = true;
970 
971         creators[rewardCampaignID * rewardCampaignMultiplier + 1] = msg.sender;
972         creators[rewardCampaignID * rewardCampaignMultiplier + 2] = msg.sender;
973         creators[rewardCampaignID * rewardCampaignMultiplier + 3] = msg.sender;
974         creators[rewardCampaignID * rewardCampaignMultiplier + 4] = msg.sender;
975 
976         emit URI(tier1URI, rewardCampaignID * rewardCampaignMultiplier + 1);
977         emit URI(tier2URI, rewardCampaignID * rewardCampaignMultiplier + 2);
978         emit URI(tier3URI, rewardCampaignID * rewardCampaignMultiplier + 3);
979         emit URI(tier4URI, rewardCampaignID * rewardCampaignMultiplier + 4);
980     }
981 
982     function addRewardToken(uint256 tokenId, string memory tokenUri) external onlyOwner {
983         require(!validRewards[tokenId], "Token ID already in use.");
984 
985         rewardURI[tokenId] = tokenUri; 
986         validRewards[tokenId] = true; 
987         emit URI(tokenUri, tokenId);
988     }
989 
990     function updateTokenURI(uint256 tokenId, string memory tokenUri) external onlyOwner {
991         require(validRewards[tokenId], "Token ID does not exist.");
992 
993         rewardURI[tokenId] = tokenUri; 
994         emit URI(tokenUri, tokenId);
995     }
996 
997     function claimCampaignReward() external {
998         require(campaignRewardClaimOpen, "Reward claims closed.");
999         uint256 pjBalance = pjContract.balanceOf(msg.sender);
1000         uint256 claimTokenID = 0;
1001 
1002         if(pjBalance >= TIER_4_MINIMUM) {
1003             claimTokenID = rewardCampaignID * rewardCampaignMultiplier + 4;
1004         } else if(pjBalance >= TIER_3_MINIMUM) {
1005             claimTokenID = rewardCampaignID * rewardCampaignMultiplier + 3;
1006         } else if(pjBalance >= TIER_2_MINIMUM) {
1007             claimTokenID = rewardCampaignID * rewardCampaignMultiplier + 2;
1008         } else if(pjBalance >= TIER_1_MINIMUM) {
1009             claimTokenID = rewardCampaignID * rewardCampaignMultiplier + 1;
1010         } 
1011 
1012         require(claimTokenID > 0, "No reward to claim.");
1013         require(!claimedReward[claimTokenID][msg.sender], "Reward already claimed.");
1014 
1015         claimedReward[claimTokenID][msg.sender] = true;
1016         _mint(msg.sender, claimTokenID, 1, "");
1017         tokenSupply[claimTokenID] = tokenSupply[claimTokenID] + 1;
1018     }
1019 
1020     function claimSnapshotReward(uint256 claimTokenID, bytes32[] calldata merkleProof) external {
1021         require(snapshotRewardClaimOpen, "Reward claims closed.");
1022         bytes32 leaf = keccak256(abi.encodePacked(msg.sender, claimTokenID));
1023 
1024         require(MerkleProof.verify(merkleProof, snapshotMerkleRoot, leaf), "Invalid Merkle proof");
1025         require(!claimedReward[claimTokenID][msg.sender], "Reward already claimed.");
1026 
1027         claimedReward[claimTokenID][msg.sender] = true;
1028         _mint(msg.sender, claimTokenID, 1, "");
1029         tokenSupply[claimTokenID] = tokenSupply[claimTokenID] + 1;
1030     }
1031 
1032     function airdropReward(uint256 tokenId, address[] calldata recipients) external onlyOwner {
1033         for(uint256 i = 0;i < recipients.length;i++) {
1034             _mint(recipients[i], tokenId, 1, "");
1035         }
1036         tokenSupply[tokenId] = tokenSupply[tokenId] + recipients.length;
1037     }
1038 
1039     function uri(uint256 typeId)
1040         public
1041         view                
1042         override
1043         returns (string memory)
1044     {
1045         require(
1046             validRewards[typeId],
1047             "URI requested for invalid type"
1048         );
1049         return
1050             rewardURI[typeId];
1051     }
1052 
1053       /**
1054         * @dev Returns the total quantity for a token ID
1055         * @param _id uint256 ID of the token to query
1056         * @return amount of token in existence
1057         */
1058     function totalSupply(
1059         uint256 _id
1060     ) public view returns (uint256) {
1061         return tokenSupply[_id];
1062     }
1063 }
1064 
1065 
1066 
1067 
1068 
1069 
1070 
1071 
1072 
1073 
1074 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1075 
1076 /**
1077  * @dev Collection of functions related to the address type
1078  */
1079 library Address {
1080     /**
1081      * @dev Returns true if `account` is a contract.
1082      *
1083      * [IMPORTANT]
1084      * ====
1085      * It is unsafe to assume that an address for which this function returns
1086      * false is an externally-owned account (EOA) and not a contract.
1087      *
1088      * Among others, `isContract` will return false for the following
1089      * types of addresses:
1090      *
1091      *  - an externally-owned account
1092      *  - a contract in construction
1093      *  - an address where a contract will be created
1094      *  - an address where a contract lived, but was destroyed
1095      * ====
1096      *
1097      * [IMPORTANT]
1098      * ====
1099      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1100      *
1101      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1102      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1103      * constructor.
1104      * ====
1105      */
1106     function isContract(address account) internal view returns (bool) {
1107         // This method relies on extcodesize/address.code.length, which returns 0
1108         // for contracts in construction, since the code is only stored at the end
1109         // of the constructor execution.
1110 
1111         return account.code.length > 0;
1112     }
1113 
1114     /**
1115      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1116      * `recipient`, forwarding all available gas and reverting on errors.
1117      *
1118      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1119      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1120      * imposed by `transfer`, making them unable to receive funds via
1121      * `transfer`. {sendValue} removes this limitation.
1122      *
1123      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1124      *
1125      * IMPORTANT: because control is transferred to `recipient`, care must be
1126      * taken to not create reentrancy vulnerabilities. Consider using
1127      * {ReentrancyGuard} or the
1128      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1129      */
1130     function sendValue(address payable recipient, uint256 amount) internal {
1131         require(address(this).balance >= amount, "Address: insufficient balance");
1132 
1133         (bool success, ) = recipient.call{value: amount}("");
1134         require(success, "Address: unable to send value, recipient may have reverted");
1135     }
1136 
1137     /**
1138      * @dev Performs a Solidity function call using a low level `call`. A
1139      * plain `call` is an unsafe replacement for a function call: use this
1140      * function instead.
1141      *
1142      * If `target` reverts with a revert reason, it is bubbled up by this
1143      * function (like regular Solidity function calls).
1144      *
1145      * Returns the raw returned data. To convert to the expected return value,
1146      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1147      *
1148      * Requirements:
1149      *
1150      * - `target` must be a contract.
1151      * - calling `target` with `data` must not revert.
1152      *
1153      * _Available since v3.1._
1154      */
1155     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1156         return functionCall(target, data, "Address: low-level call failed");
1157     }
1158 
1159     /**
1160      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1161      * `errorMessage` as a fallback revert reason when `target` reverts.
1162      *
1163      * _Available since v3.1._
1164      */
1165     function functionCall(
1166         address target,
1167         bytes memory data,
1168         string memory errorMessage
1169     ) internal returns (bytes memory) {
1170         return functionCallWithValue(target, data, 0, errorMessage);
1171     }
1172 
1173     /**
1174      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1175      * but also transferring `value` wei to `target`.
1176      *
1177      * Requirements:
1178      *
1179      * - the calling contract must have an ETH balance of at least `value`.
1180      * - the called Solidity function must be `payable`.
1181      *
1182      * _Available since v3.1._
1183      */
1184     function functionCallWithValue(
1185         address target,
1186         bytes memory data,
1187         uint256 value
1188     ) internal returns (bytes memory) {
1189         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1190     }
1191 
1192     /**
1193      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1194      * with `errorMessage` as a fallback revert reason when `target` reverts.
1195      *
1196      * _Available since v3.1._
1197      */
1198     function functionCallWithValue(
1199         address target,
1200         bytes memory data,
1201         uint256 value,
1202         string memory errorMessage
1203     ) internal returns (bytes memory) {
1204         require(address(this).balance >= value, "Address: insufficient balance for call");
1205         require(isContract(target), "Address: call to non-contract");
1206 
1207         (bool success, bytes memory returndata) = target.call{value: value}(data);
1208         return verifyCallResult(success, returndata, errorMessage);
1209     }
1210 
1211     /**
1212      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1213      * but performing a static call.
1214      *
1215      * _Available since v3.3._
1216      */
1217     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1218         return functionStaticCall(target, data, "Address: low-level static call failed");
1219     }
1220 
1221     /**
1222      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1223      * but performing a static call.
1224      *
1225      * _Available since v3.3._
1226      */
1227     function functionStaticCall(
1228         address target,
1229         bytes memory data,
1230         string memory errorMessage
1231     ) internal view returns (bytes memory) {
1232         require(isContract(target), "Address: static call to non-contract");
1233 
1234         (bool success, bytes memory returndata) = target.staticcall(data);
1235         return verifyCallResult(success, returndata, errorMessage);
1236     }
1237 
1238     /**
1239      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1240      * but performing a delegate call.
1241      *
1242      * _Available since v3.4._
1243      */
1244     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1245         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1246     }
1247 
1248     /**
1249      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1250      * but performing a delegate call.
1251      *
1252      * _Available since v3.4._
1253      */
1254     function functionDelegateCall(
1255         address target,
1256         bytes memory data,
1257         string memory errorMessage
1258     ) internal returns (bytes memory) {
1259         require(isContract(target), "Address: delegate call to non-contract");
1260 
1261         (bool success, bytes memory returndata) = target.delegatecall(data);
1262         return verifyCallResult(success, returndata, errorMessage);
1263     }
1264 
1265     /**
1266      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1267      * revert reason using the provided one.
1268      *
1269      * _Available since v4.3._
1270      */
1271     function verifyCallResult(
1272         bool success,
1273         bytes memory returndata,
1274         string memory errorMessage
1275     ) internal pure returns (bytes memory) {
1276         if (success) {
1277             return returndata;
1278         } else {
1279             // Look for revert reason and bubble it up if present
1280             if (returndata.length > 0) {
1281                 // The easiest way to bubble the revert reason is using memory via assembly
1282 
1283                 assembly {
1284                     let returndata_size := mload(returndata)
1285                     revert(add(32, returndata), returndata_size)
1286                 }
1287             } else {
1288                 revert(errorMessage);
1289             }
1290         }
1291     }
1292 }
1293 
1294 
1295 
1296 /**
1297  * @dev String operations.
1298  */
1299 library Strings {
1300     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
1301 
1302     /**
1303      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1304      */
1305     function toString(uint256 value) internal pure returns (string memory) {
1306         // Inspired by OraclizeAPI's implementation - MIT licence
1307         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1308 
1309         if (value == 0) {
1310             return "0";
1311         }
1312         uint256 temp = value;
1313         uint256 digits;
1314         while (temp != 0) {
1315             digits++;
1316             temp /= 10;
1317         }
1318         bytes memory buffer = new bytes(digits);
1319         while (value != 0) {
1320             digits -= 1;
1321             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1322             value /= 10;
1323         }
1324         return string(buffer);
1325     }
1326 
1327     /**
1328      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1329      */
1330     function toHexString(uint256 value) internal pure returns (string memory) {
1331         if (value == 0) {
1332             return "0x00";
1333         }
1334         uint256 temp = value;
1335         uint256 length = 0;
1336         while (temp != 0) {
1337             length++;
1338             temp >>= 8;
1339         }
1340         return toHexString(value, length);
1341     }
1342 
1343     /**
1344      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1345      */
1346     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1347         bytes memory buffer = new bytes(2 * length + 2);
1348         buffer[0] = "0";
1349         buffer[1] = "x";
1350         for (uint256 i = 2 * length + 1; i > 1; --i) {
1351             buffer[i] = _HEX_SYMBOLS[value & 0xf];
1352             value >>= 4;
1353         }
1354         require(value == 0, "Strings: hex length insufficient");
1355         return string(buffer);
1356     }
1357 }
1358 
1359 
1360 /**
1361  * @dev These functions deal with verification of Merkle Trees proofs.
1362  *
1363  * The proofs can be generated using the JavaScript library
1364  * https://github.com/miguelmota/merkletreejs[merkletreejs].
1365  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
1366  *
1367  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
1368  *
1369  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1370  * hashing, or use a hash function other than keccak256 for hashing leaves.
1371  * This is because the concatenation of a sorted pair of internal nodes in
1372  * the merkle tree could be reinterpreted as a leaf value.
1373  */
1374 library MerkleProof {
1375     /**
1376      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1377      * defined by `root`. For this, a `proof` must be provided, containing
1378      * sibling hashes on the branch from the leaf to the root of the tree. Each
1379      * pair of leaves and each pair of pre-images are assumed to be sorted.
1380      */
1381     function verify(
1382         bytes32[] memory proof,
1383         bytes32 root,
1384         bytes32 leaf
1385     ) internal pure returns (bool) {
1386         return processProof(proof, leaf) == root;
1387     }
1388 
1389     /**
1390      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1391      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1392      * hash matches the root of the tree. When processing the proof, the pairs
1393      * of leafs & pre-images are assumed to be sorted.
1394      *
1395      * _Available since v4.4._
1396      */
1397     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1398         bytes32 computedHash = leaf;
1399         for (uint256 i = 0; i < proof.length; i++) {
1400             bytes32 proofElement = proof[i];
1401             if (computedHash <= proofElement) {
1402                 // Hash(current computed hash + current element of the proof)
1403                 computedHash = _efficientHash(computedHash, proofElement);
1404             } else {
1405                 // Hash(current element of the proof + current computed hash)
1406                 computedHash = _efficientHash(proofElement, computedHash);
1407             }
1408         }
1409         return computedHash;
1410     }
1411 
1412     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1413         assembly {
1414             mstore(0x00, a)
1415             mstore(0x20, b)
1416             value := keccak256(0x00, 0x40)
1417         }
1418     }
1419 }