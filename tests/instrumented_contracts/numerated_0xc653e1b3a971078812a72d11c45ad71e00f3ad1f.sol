1 // File: @openzeppelin/contracts/introspection/IERC165.sol
2 
3 // SPD-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /**
8  * @dev Interface of the ERC165 standard, as defined in the
9  * https://eips.ethereum.org/EIPS/eip-165[EIP].
10  *
11  * Implementers can declare support of contract interfaces, which can then be
12  * queried by others ({ERC165Checker}).
13  *
14  * For an implementation, see {ERC165}.
15  */
16 interface IERC165 {
17     /**
18      * @dev Returns true if this contract implements the interface defined by
19      * `interfaceId`. See the corresponding
20      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
21      * to learn more about how these ids are created.
22      *
23      * This function call must use less than 30 000 gas.
24      */
25     function supportsInterface(bytes4 interfaceId) external view returns (bool);
26 }
27 
28 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
29 
30 // SPD-License-Identifier: MIT
31 
32 pragma solidity >=0.6.0 <0.8.0;
33 
34 
35 /**
36  * _Available since v3.1._
37  */
38 interface IERC1155Receiver is IERC165 {
39 
40     /**
41         @dev Handles the receipt of a single ERC1155 token type. This function is
42         called at the end of a `safeTransferFrom` after the balance has been updated.
43         To accept the transfer, this must return
44         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
45         (i.e. 0xf23a6e61, or its own function selector).
46         @param operator The address which initiated the transfer (i.e. msg.sender)
47         @param from The address which previously owned the token
48         @param id The ID of the token being transferred
49         @param value The amount of tokens being transferred
50         @param data Additional data with no specified format
51         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
52     */
53     function onERC1155Received(
54         address operator,
55         address from,
56         uint256 id,
57         uint256 value,
58         bytes calldata data
59     )
60         external
61         returns(bytes4);
62 
63     /**
64         @dev Handles the receipt of a multiple ERC1155 token types. This function
65         is called at the end of a `safeBatchTransferFrom` after the balances have
66         been updated. To accept the transfer(s), this must return
67         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
68         (i.e. 0xbc197c81, or its own function selector).
69         @param operator The address which initiated the batch transfer (i.e. msg.sender)
70         @param from The address which previously owned the token
71         @param ids An array containing ids of each token being transferred (order and length must match values array)
72         @param values An array containing amounts of each token being transferred (order and length must match ids array)
73         @param data Additional data with no specified format
74         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
75     */
76     function onERC1155BatchReceived(
77         address operator,
78         address from,
79         uint256[] calldata ids,
80         uint256[] calldata values,
81         bytes calldata data
82     )
83         external
84         returns(bytes4);
85 }
86 
87 // File: @openzeppelin/contracts/introspection/ERC165.sol
88 
89 // SPD-License-Identifier: MIT
90 
91 pragma solidity >=0.6.0 <0.8.0;
92 
93 
94 /**
95  * @dev Implementation of the {IERC165} interface.
96  *
97  * Contracts may inherit from this and call {_registerInterface} to declare
98  * their support of an interface.
99  */
100 abstract contract ERC165 is IERC165 {
101     /*
102      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
103      */
104     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
105 
106     /**
107      * @dev Mapping of interface ids to whether or not it's supported.
108      */
109     mapping(bytes4 => bool) private _supportedInterfaces;
110 
111     constructor () internal {
112         // Derived contracts need only register support for their own interfaces,
113         // we register support for ERC165 itself here
114         _registerInterface(_INTERFACE_ID_ERC165);
115     }
116 
117     /**
118      * @dev See {IERC165-supportsInterface}.
119      *
120      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
121      */
122     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
123         return _supportedInterfaces[interfaceId];
124     }
125 
126     /**
127      * @dev Registers the contract as an implementer of the interface defined by
128      * `interfaceId`. Support of the actual ERC165 interface is automatic and
129      * registering its interface id is not required.
130      *
131      * See {IERC165-supportsInterface}.
132      *
133      * Requirements:
134      *
135      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
136      */
137     function _registerInterface(bytes4 interfaceId) internal virtual {
138         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
139         _supportedInterfaces[interfaceId] = true;
140     }
141 }
142 
143 // File: @openzeppelin/contracts/token/ERC1155/ERC1155Receiver.sol
144 
145 // SPD-License-Identifier: MIT
146 
147 pragma solidity >=0.6.0 <0.8.0;
148 
149 
150 
151 /**
152  * @dev _Available since v3.1._
153  */
154 abstract contract ERC1155Receiver is ERC165, IERC1155Receiver {
155     constructor() internal {
156         _registerInterface(
157             ERC1155Receiver(address(0)).onERC1155Received.selector ^
158             ERC1155Receiver(address(0)).onERC1155BatchReceived.selector
159         );
160     }
161 }
162 
163 // File: @openzeppelin/contracts/token/ERC1155/ERC1155Holder.sol
164 
165 // SPD-License-Identifier: MIT
166 
167 pragma solidity >=0.6.0 <0.8.0;
168 
169 
170 /**
171  * @dev _Available since v3.1._
172  */
173 contract ERC1155Holder is ERC1155Receiver {
174     function onERC1155Received(address, address, uint256, uint256, bytes memory) public virtual override returns (bytes4) {
175         return this.onERC1155Received.selector;
176     }
177 
178     function onERC1155BatchReceived(address, address, uint256[] memory, uint256[] memory, bytes memory) public virtual override returns (bytes4) {
179         return this.onERC1155BatchReceived.selector;
180     }
181 }
182 
183 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
184 
185 // SPD-License-Identifier: MIT
186 
187 pragma solidity >=0.6.2 <0.8.0;
188 
189 
190 /**
191  * @dev Required interface of an ERC721 compliant contract.
192  */
193 interface IERC721 is IERC165 {
194     /**
195      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
196      */
197     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
198 
199     /**
200      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
201      */
202     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
203 
204     /**
205      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
206      */
207     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
208 
209     /**
210      * @dev Returns the number of tokens in ``owner``'s account.
211      */
212     function balanceOf(address owner) external view returns (uint256 balance);
213 
214     /**
215      * @dev Returns the owner of the `tokenId` token.
216      *
217      * Requirements:
218      *
219      * - `tokenId` must exist.
220      */
221     function ownerOf(uint256 tokenId) external view returns (address owner);
222 
223     /**
224      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
225      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
226      *
227      * Requirements:
228      *
229      * - `from` cannot be the zero address.
230      * - `to` cannot be the zero address.
231      * - `tokenId` token must exist and be owned by `from`.
232      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
233      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
234      *
235      * Emits a {Transfer} event.
236      */
237     function safeTransferFrom(address from, address to, uint256 tokenId) external;
238 
239     /**
240      * @dev Transfers `tokenId` token from `from` to `to`.
241      *
242      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
243      *
244      * Requirements:
245      *
246      * - `from` cannot be the zero address.
247      * - `to` cannot be the zero address.
248      * - `tokenId` token must be owned by `from`.
249      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
250      *
251      * Emits a {Transfer} event.
252      */
253     function transferFrom(address from, address to, uint256 tokenId) external;
254 
255     /**
256      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
257      * The approval is cleared when the token is transferred.
258      *
259      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
260      *
261      * Requirements:
262      *
263      * - The caller must own the token or be an approved operator.
264      * - `tokenId` must exist.
265      *
266      * Emits an {Approval} event.
267      */
268     function approve(address to, uint256 tokenId) external;
269 
270     /**
271      * @dev Returns the account approved for `tokenId` token.
272      *
273      * Requirements:
274      *
275      * - `tokenId` must exist.
276      */
277     function getApproved(uint256 tokenId) external view returns (address operator);
278 
279     /**
280      * @dev Approve or remove `operator` as an operator for the caller.
281      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
282      *
283      * Requirements:
284      *
285      * - The `operator` cannot be the caller.
286      *
287      * Emits an {ApprovalForAll} event.
288      */
289     function setApprovalForAll(address operator, bool _approved) external;
290 
291     /**
292      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
293      *
294      * See {setApprovalForAll}
295      */
296     function isApprovedForAll(address owner, address operator) external view returns (bool);
297 
298     /**
299       * @dev Safely transfers `tokenId` token from `from` to `to`.
300       *
301       * Requirements:
302       *
303       * - `from` cannot be the zero address.
304       * - `to` cannot be the zero address.
305       * - `tokenId` token must exist and be owned by `from`.
306       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
307       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
308       *
309       * Emits a {Transfer} event.
310       */
311     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
312 }
313 
314 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
315 
316 // SPD-License-Identifier: MIT
317 
318 pragma solidity >=0.6.2 <0.8.0;
319 
320 
321 /**
322  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
323  * @dev See https://eips.ethereum.org/EIPS/eip-721
324  */
325 interface IERC721Enumerable is IERC721 {
326 
327     /**
328      * @dev Returns the total amount of tokens stored by the contract.
329      */
330     function totalSupply() external view returns (uint256);
331 
332     /**
333      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
334      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
335      */
336     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
337 
338     /**
339      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
340      * Use along with {totalSupply} to enumerate all tokens.
341      */
342     function tokenByIndex(uint256 index) external view returns (uint256);
343 }
344 
345 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
346 
347 // SPD-License-Identifier: MIT
348 
349 pragma solidity >=0.6.0 <0.8.0;
350 
351 /**
352  * @dev Interface of the ERC20 standard as defined in the EIP.
353  */
354 interface IERC20 {
355     /**
356      * @dev Returns the amount of tokens in existence.
357      */
358     function totalSupply() external view returns (uint256);
359 
360     /**
361      * @dev Returns the amount of tokens owned by `account`.
362      */
363     function balanceOf(address account) external view returns (uint256);
364 
365     /**
366      * @dev Moves `amount` tokens from the caller's account to `recipient`.
367      *
368      * Returns a boolean value indicating whether the operation succeeded.
369      *
370      * Emits a {Transfer} event.
371      */
372     function transfer(address recipient, uint256 amount) external returns (bool);
373 
374     /**
375      * @dev Returns the remaining number of tokens that `spender` will be
376      * allowed to spend on behalf of `owner` through {transferFrom}. This is
377      * zero by default.
378      *
379      * This value changes when {approve} or {transferFrom} are called.
380      */
381     function allowance(address owner, address spender) external view returns (uint256);
382 
383     /**
384      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
385      *
386      * Returns a boolean value indicating whether the operation succeeded.
387      *
388      * IMPORTANT: Beware that changing an allowance with this method brings the risk
389      * that someone may use both the old and the new allowance by unfortunate
390      * transaction ordering. One possible solution to mitigate this race
391      * condition is to first reduce the spender's allowance to 0 and set the
392      * desired value afterwards:
393      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
394      *
395      * Emits an {Approval} event.
396      */
397     function approve(address spender, uint256 amount) external returns (bool);
398 
399     /**
400      * @dev Moves `amount` tokens from `sender` to `recipient` using the
401      * allowance mechanism. `amount` is then deducted from the caller's
402      * allowance.
403      *
404      * Returns a boolean value indicating whether the operation succeeded.
405      *
406      * Emits a {Transfer} event.
407      */
408     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
409 
410     /**
411      * @dev Emitted when `value` tokens are moved from one account (`from`) to
412      * another (`to`).
413      *
414      * Note that `value` may be zero.
415      */
416     event Transfer(address indexed from, address indexed to, uint256 value);
417 
418     /**
419      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
420      * a call to {approve}. `value` is the new allowance.
421      */
422     event Approval(address indexed owner, address indexed spender, uint256 value);
423 }
424 
425 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
426 
427 // SPD-License-Identifier: MIT
428 
429 pragma solidity >=0.6.2 <0.8.0;
430 
431 
432 /**
433  * @dev Required interface of an ERC1155 compliant contract, as defined in the
434  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
435  *
436  * _Available since v3.1._
437  */
438 interface IERC1155 is IERC165 {
439     /**
440      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
441      */
442     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
443 
444     /**
445      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
446      * transfers.
447      */
448     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
449 
450     /**
451      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
452      * `approved`.
453      */
454     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
455 
456     /**
457      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
458      *
459      * If an {URI} event was emitted for `id`, the standard
460      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
461      * returned by {IERC1155MetadataURI-uri}.
462      */
463     event URI(string value, uint256 indexed id);
464 
465     /**
466      * @dev Returns the amount of tokens of token type `id` owned by `account`.
467      *
468      * Requirements:
469      *
470      * - `account` cannot be the zero address.
471      */
472     function balanceOf(address account, uint256 id) external view returns (uint256);
473 
474     /**
475      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
476      *
477      * Requirements:
478      *
479      * - `accounts` and `ids` must have the same length.
480      */
481     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
482 
483     /**
484      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
485      *
486      * Emits an {ApprovalForAll} event.
487      *
488      * Requirements:
489      *
490      * - `operator` cannot be the caller.
491      */
492     function setApprovalForAll(address operator, bool approved) external;
493 
494     /**
495      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
496      *
497      * See {setApprovalForAll}.
498      */
499     function isApprovedForAll(address account, address operator) external view returns (bool);
500 
501     /**
502      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
503      *
504      * Emits a {TransferSingle} event.
505      *
506      * Requirements:
507      *
508      * - `to` cannot be the zero address.
509      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
510      * - `from` must have a balance of tokens of type `id` of at least `amount`.
511      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
512      * acceptance magic value.
513      */
514     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
515 
516     /**
517      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
518      *
519      * Emits a {TransferBatch} event.
520      *
521      * Requirements:
522      *
523      * - `ids` and `amounts` must have the same length.
524      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
525      * acceptance magic value.
526      */
527     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
528 }
529 
530 // File: @openzeppelin/contracts/math/SafeMath.sol
531 
532 // SPD-License-Identifier: MIT
533 
534 pragma solidity >=0.6.0 <0.8.0;
535 
536 /**
537  * @dev Wrappers over Solidity's arithmetic operations with added overflow
538  * checks.
539  *
540  * Arithmetic operations in Solidity wrap on overflow. This can easily result
541  * in bugs, because programmers usually assume that an overflow raises an
542  * error, which is the standard behavior in high level programming languages.
543  * `SafeMath` restores this intuition by reverting the transaction when an
544  * operation overflows.
545  *
546  * Using this library instead of the unchecked operations eliminates an entire
547  * class of bugs, so it's recommended to use it always.
548  */
549 library SafeMath {
550     /**
551      * @dev Returns the addition of two unsigned integers, with an overflow flag.
552      *
553      * _Available since v3.4._
554      */
555     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
556         uint256 c = a + b;
557         if (c < a) return (false, 0);
558         return (true, c);
559     }
560 
561     /**
562      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
563      *
564      * _Available since v3.4._
565      */
566     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
567         if (b > a) return (false, 0);
568         return (true, a - b);
569     }
570 
571     /**
572      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
573      *
574      * _Available since v3.4._
575      */
576     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
577         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
578         // benefit is lost if 'b' is also tested.
579         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
580         if (a == 0) return (true, 0);
581         uint256 c = a * b;
582         if (c / a != b) return (false, 0);
583         return (true, c);
584     }
585 
586     /**
587      * @dev Returns the division of two unsigned integers, with a division by zero flag.
588      *
589      * _Available since v3.4._
590      */
591     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
592         if (b == 0) return (false, 0);
593         return (true, a / b);
594     }
595 
596     /**
597      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
598      *
599      * _Available since v3.4._
600      */
601     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
602         if (b == 0) return (false, 0);
603         return (true, a % b);
604     }
605 
606     /**
607      * @dev Returns the addition of two unsigned integers, reverting on
608      * overflow.
609      *
610      * Counterpart to Solidity's `+` operator.
611      *
612      * Requirements:
613      *
614      * - Addition cannot overflow.
615      */
616     function add(uint256 a, uint256 b) internal pure returns (uint256) {
617         uint256 c = a + b;
618         require(c >= a, "SafeMath: addition overflow");
619         return c;
620     }
621 
622     /**
623      * @dev Returns the subtraction of two unsigned integers, reverting on
624      * overflow (when the result is negative).
625      *
626      * Counterpart to Solidity's `-` operator.
627      *
628      * Requirements:
629      *
630      * - Subtraction cannot overflow.
631      */
632     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
633         require(b <= a, "SafeMath: subtraction overflow");
634         return a - b;
635     }
636 
637     /**
638      * @dev Returns the multiplication of two unsigned integers, reverting on
639      * overflow.
640      *
641      * Counterpart to Solidity's `*` operator.
642      *
643      * Requirements:
644      *
645      * - Multiplication cannot overflow.
646      */
647     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
648         if (a == 0) return 0;
649         uint256 c = a * b;
650         require(c / a == b, "SafeMath: multiplication overflow");
651         return c;
652     }
653 
654     /**
655      * @dev Returns the integer division of two unsigned integers, reverting on
656      * division by zero. The result is rounded towards zero.
657      *
658      * Counterpart to Solidity's `/` operator. Note: this function uses a
659      * `revert` opcode (which leaves remaining gas untouched) while Solidity
660      * uses an invalid opcode to revert (consuming all remaining gas).
661      *
662      * Requirements:
663      *
664      * - The divisor cannot be zero.
665      */
666     function div(uint256 a, uint256 b) internal pure returns (uint256) {
667         require(b > 0, "SafeMath: division by zero");
668         return a / b;
669     }
670 
671     /**
672      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
673      * reverting when dividing by zero.
674      *
675      * Counterpart to Solidity's `%` operator. This function uses a `revert`
676      * opcode (which leaves remaining gas untouched) while Solidity uses an
677      * invalid opcode to revert (consuming all remaining gas).
678      *
679      * Requirements:
680      *
681      * - The divisor cannot be zero.
682      */
683     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
684         require(b > 0, "SafeMath: modulo by zero");
685         return a % b;
686     }
687 
688     /**
689      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
690      * overflow (when the result is negative).
691      *
692      * CAUTION: This function is deprecated because it requires allocating memory for the error
693      * message unnecessarily. For custom revert reasons use {trySub}.
694      *
695      * Counterpart to Solidity's `-` operator.
696      *
697      * Requirements:
698      *
699      * - Subtraction cannot overflow.
700      */
701     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
702         require(b <= a, errorMessage);
703         return a - b;
704     }
705 
706     /**
707      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
708      * division by zero. The result is rounded towards zero.
709      *
710      * CAUTION: This function is deprecated because it requires allocating memory for the error
711      * message unnecessarily. For custom revert reasons use {tryDiv}.
712      *
713      * Counterpart to Solidity's `/` operator. Note: this function uses a
714      * `revert` opcode (which leaves remaining gas untouched) while Solidity
715      * uses an invalid opcode to revert (consuming all remaining gas).
716      *
717      * Requirements:
718      *
719      * - The divisor cannot be zero.
720      */
721     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
722         require(b > 0, errorMessage);
723         return a / b;
724     }
725 
726     /**
727      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
728      * reverting with custom message when dividing by zero.
729      *
730      * CAUTION: This function is deprecated because it requires allocating memory for the error
731      * message unnecessarily. For custom revert reasons use {tryMod}.
732      *
733      * Counterpart to Solidity's `%` operator. This function uses a `revert`
734      * opcode (which leaves remaining gas untouched) while Solidity uses an
735      * invalid opcode to revert (consuming all remaining gas).
736      *
737      * Requirements:
738      *
739      * - The divisor cannot be zero.
740      */
741     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
742         require(b > 0, errorMessage);
743         return a % b;
744     }
745 }
746 
747 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
748 
749 // SPD-License-Identifier: MIT
750 
751 pragma solidity >=0.6.0 <0.8.0;
752 
753 /**
754  * @dev Contract module that helps prevent reentrant calls to a function.
755  *
756  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
757  * available, which can be applied to functions to make sure there are no nested
758  * (reentrant) calls to them.
759  *
760  * Note that because there is a single `nonReentrant` guard, functions marked as
761  * `nonReentrant` may not call one another. This can be worked around by making
762  * those functions `private`, and then adding `external` `nonReentrant` entry
763  * points to them.
764  *
765  * TIP: If you would like to learn more about reentrancy and alternative ways
766  * to protect against it, check out our blog post
767  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
768  */
769 abstract contract ReentrancyGuard {
770     // Booleans are more expensive than uint256 or any type that takes up a full
771     // word because each write operation emits an extra SLOAD to first read the
772     // slot's contents, replace the bits taken up by the boolean, and then write
773     // back. This is the compiler's defense against contract upgrades and
774     // pointer aliasing, and it cannot be disabled.
775 
776     // The values being non-zero value makes deployment a bit more expensive,
777     // but in exchange the refund on every call to nonReentrant will be lower in
778     // amount. Since refunds are capped to a percentage of the total
779     // transaction's gas, it is best to keep them low in cases like this one, to
780     // increase the likelihood of the full refund coming into effect.
781     uint256 private constant _NOT_ENTERED = 1;
782     uint256 private constant _ENTERED = 2;
783 
784     uint256 private _status;
785 
786     constructor () internal {
787         _status = _NOT_ENTERED;
788     }
789 
790     /**
791      * @dev Prevents a contract from calling itself, directly or indirectly.
792      * Calling a `nonReentrant` function from another `nonReentrant`
793      * function is not supported. It is possible to prevent this from happening
794      * by making the `nonReentrant` function external, and make it call a
795      * `private` function that does the actual work.
796      */
797     modifier nonReentrant() {
798         // On the first call to nonReentrant, _notEntered will be true
799         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
800 
801         // Any calls to nonReentrant after this point will fail
802         _status = _ENTERED;
803 
804         _;
805 
806         // By storing the original value once again, a refund is triggered (see
807         // https://eips.ethereum.org/EIPS/eip-2200)
808         _status = _NOT_ENTERED;
809     }
810 }
811 
812 // File: @openzeppelin/contracts/utils/Context.sol
813 
814 // SPD-License-Identifier: MIT
815 
816 pragma solidity >=0.6.0 <0.8.0;
817 
818 /*
819  * @dev Provides information about the current execution context, including the
820  * sender of the transaction and its data. While these are generally available
821  * via msg.sender and msg.data, they should not be accessed in such a direct
822  * manner, since when dealing with GSN meta-transactions the account sending and
823  * paying for execution may not be the actual sender (as far as an application
824  * is concerned).
825  *
826  * This contract is only required for intermediate, library-like contracts.
827  */
828 abstract contract Context {
829     function _msgSender() internal view virtual returns (address payable) {
830         return msg.sender;
831     }
832 
833     function _msgData() internal view virtual returns (bytes memory) {
834         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
835         return msg.data;
836     }
837 }
838 
839 // File: @openzeppelin/contracts/access/Ownable.sol
840 
841 // SPD-License-Identifier: MIT
842 
843 pragma solidity >=0.6.0 <0.8.0;
844 
845 /**
846  * @dev Contract module which provides a basic access control mechanism, where
847  * there is an account (an owner) that can be granted exclusive access to
848  * specific functions.
849  *
850  * By default, the owner account will be the one that deploys the contract. This
851  * can later be changed with {transferOwnership}.
852  *
853  * This module is used through inheritance. It will make available the modifier
854  * `onlyOwner`, which can be applied to your functions to restrict their use to
855  * the owner.
856  */
857 abstract contract Ownable is Context {
858     address private _owner;
859 
860     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
861 
862     /**
863      * @dev Initializes the contract setting the deployer as the initial owner.
864      */
865     constructor () internal {
866         address msgSender = _msgSender();
867         _owner = msgSender;
868         emit OwnershipTransferred(address(0), msgSender);
869     }
870 
871     /**
872      * @dev Returns the address of the current owner.
873      */
874     function owner() public view virtual returns (address) {
875         return _owner;
876     }
877 
878     /**
879      * @dev Throws if called by any account other than the owner.
880      */
881     modifier onlyOwner() {
882         require(owner() == _msgSender(), "Ownable: caller is not the owner");
883         _;
884     }
885 
886     /**
887      * @dev Leaves the contract without owner. It will not be possible to call
888      * `onlyOwner` functions anymore. Can only be called by the current owner.
889      *
890      * NOTE: Renouncing ownership will leave the contract without an owner,
891      * thereby removing any functionality that is only available to the owner.
892      */
893     function renounceOwnership() public virtual onlyOwner {
894         emit OwnershipTransferred(_owner, address(0));
895         _owner = address(0);
896     }
897 
898     /**
899      * @dev Transfers ownership of the contract to a new account (`newOwner`).
900      * Can only be called by the current owner.
901      */
902     function transferOwnership(address newOwner) public virtual onlyOwner {
903         require(newOwner != address(0), "Ownable: new owner is the zero address");
904         emit OwnershipTransferred(_owner, newOwner);
905         _owner = newOwner;
906     }
907 }
908 
909 // File: contracts/Multisender.sol
910 
911 // SPD-License-Identifier: AGPL-3.0-or-later
912 pragma solidity ^0.6.8;
913 
914 
915 
916 
917 
918 
919 
920 
921 contract Multisender is ERC1155Holder, ReentrancyGuard, Ownable {
922 
923   using SafeMath for uint256;
924 
925   address payable public feeReceiver;
926   uint256 public ethFee;
927 
928   IERC20 public xmon;
929   IERC721 public xmonNFT;
930 
931   uint256 public minXmon;
932   uint256 public minXmonNFT;
933 
934   bytes emptyData = bytes("");
935 
936   // Mapping of ERC721 address -> ID -> tokenAddress -> reward amounts
937   mapping(address => mapping(uint256 => mapping(address => uint256))) public erc20Rewards;
938 
939   // Mapping of ERC721 address -> ID -> tokenAddress -> array of IDs
940   mapping(address => mapping(uint256 => mapping(address => uint256[]))) public erc721Rewards;
941 
942   // Mapping of ERC721 address -> ID -> tokenAddress -> IDs -> amounts
943   mapping(address => mapping(uint256 => mapping(address => mapping(uint256 => uint256)))) public erc1155Rewards;
944 
945 
946   constructor() public {
947     ethFee = 0.05 ether;
948     feeReceiver = 0x4e2f98c96e2d595a83AFa35888C4af58Ac343E44;
949     minXmon = 1 ether;
950     minXmonNFT = 1;
951     xmon = IERC20(0x3aaDA3e213aBf8529606924d8D1c55CbDc70Bf74);
952     xmonNFT = IERC721(0x0427743DF720801825a5c82e0582B1E915E0F750);
953   }
954 
955   modifier collectFeeOrWhitelist() {
956     if (msg.value >= ethFee) {
957       feeReceiver.transfer(msg.value);
958     }
959     else {
960       require(xmon.balanceOf(msg.sender) >= minXmon || xmonNFT.balanceOf(msg.sender) >= minXmonNFT, "Hold XMON");
961     }
962     _;
963   }
964 
965 
966 
967   // Internal function to send ERC721 or ERC20 tokens
968   // Using transferFrom means we don't implement ERC721 Receiver
969   function _send721Or20(address tokenAddress, address from, address to, uint256 amountOrId) internal {
970     IERC721(tokenAddress).transferFrom(from, to, amountOrId);
971   }
972 
973 
974 
975   // Direct senders
976 
977   // Normal multisend: sends a batch of ERC721 or ERC20 to a list of addresses
978   function send721Or20ToAddresses(
979     address[] calldata userAddresses,
980     uint256[] calldata amountsOrIds,
981     address tokenAddress) external payable collectFeeOrWhitelist nonReentrant {
982     require((userAddresses.length == amountsOrIds.length), "diff lengths");
983     for (uint256 i = 0; i < userAddresses.length; i++) {
984       _send721Or20(tokenAddress, msg.sender, userAddresses[i], amountsOrIds[i]);
985     }
986   }
987 
988 // ERC721 targeted multisend: sends a batch of ERC721 or ERC20s to a list of ERC721 ID holders
989   function send721Or20To721Ids(
990     address[] calldata erc721Addresses,
991     uint256[] calldata receiverIds,
992     uint256[] calldata amountsOrIds,
993     address tokenAddress) external payable collectFeeOrWhitelist nonReentrant {
994     require((erc721Addresses.length == receiverIds.length), "diff lengths");
995     require((erc721Addresses.length == amountsOrIds.length), "diff lengths");
996     for (uint256 i = 0; i < receiverIds.length; i++) {
997       IERC721Enumerable erc721 = IERC721Enumerable(erc721Addresses[i]);
998       _send721Or20(tokenAddress, msg.sender, erc721.ownerOf(receiverIds[i]), amountsOrIds[i]);
999     }
1000   }
1001 
1002   // Send ERC-1155 to a batch of addresses
1003   function send1155ToAddresses(
1004     address[] calldata userAddresses,
1005     uint256[] calldata tokenIds,
1006     uint256[] calldata amounts,
1007     address tokenAddress) external payable collectFeeOrWhitelist nonReentrant {
1008     require((userAddresses.length == amounts.length), "diff lengths");
1009     require((userAddresses.length == tokenIds.length), "diff lengths");
1010     for (uint256 i = 0; i < userAddresses.length; i++) {
1011       IERC1155(tokenAddress).safeTransferFrom(msg.sender, userAddresses[i], tokenIds[i], amounts[i], emptyData);
1012     }
1013   }
1014 
1015   // Send ERC-1155 to a list of ERC721 ID holders
1016   function send1155To721Ids(
1017     address[] calldata erc721Addresses,
1018     uint256[] calldata erc721Ids,
1019     uint256[] calldata tokenIds,
1020     uint256[] calldata amounts,
1021     address tokenAddress) external payable collectFeeOrWhitelist nonReentrant {
1022     require((erc721Addresses.length == erc721Ids.length), "diff lengths");
1023     require((erc721Addresses.length == amounts.length), "diff lengths");
1024     require((erc721Addresses.length == tokenIds.length), "diff lengths");
1025     for (uint256 i = 0; i < erc721Addresses.length; i++) {
1026       IERC1155(tokenAddress).safeTransferFrom(msg.sender, IERC721(erc721Addresses[i]).ownerOf(erc721Ids[i]), tokenIds[i], amounts[i], emptyData);
1027     }
1028   }
1029 
1030 
1031 
1032 
1033   // Delayed senders (i.e. for claimable airdrop)
1034 
1035   // Sends a batch of ERC20 rewards to a list of ERC721 ID holders, to be later claimed
1036   // Essentially "locks" tokens into the contract to be removed by the holder
1037   function set20To721Ids(
1038     address[] calldata erc721Addresses,
1039     uint256[] calldata receiverIds,
1040     uint256[] calldata amounts,
1041     address tokenAddress) external nonReentrant {
1042     require((erc721Addresses.length == receiverIds.length), "diff lengths");
1043     require((erc721Addresses.length == amounts.length), "diff lengths");
1044     for (uint256 i = 0; i < receiverIds.length; i++) {
1045       // Add new reward amount to mapping
1046       erc20Rewards[erc721Addresses[i]][receiverIds[i]][tokenAddress] = erc20Rewards[erc721Addresses[i]][receiverIds[i]][tokenAddress].add(amounts[i]);
1047 
1048       // Do the transfer
1049       _send721Or20(tokenAddress, msg.sender, address(this), amounts[i]);
1050     }
1051   }
1052 
1053   // Sends a batch of ERC721 rewards to a list of ERC721 ID holders, to be later claimed
1054   // Essentially "locks" tokens into the contract to be removed by the holder
1055   function set721To721Ids(
1056     address[] calldata erc721Addresses,
1057     uint256[] calldata receiverIds,
1058     uint256[] calldata idsToSend,
1059     address tokenAddress) external nonReentrant {
1060     require((erc721Addresses.length == receiverIds.length), "diff lengths");
1061     require((erc721Addresses.length == idsToSend.length), "diff lengths");
1062     for (uint256 i = 0; i < receiverIds.length; i++) {
1063 
1064       // Add to list of ERC721 reward IDs
1065       erc721Rewards[erc721Addresses[i]][receiverIds[i]][tokenAddress].push(idsToSend[i]);
1066 
1067       // Send rewards to sender
1068       _send721Or20(tokenAddress, msg.sender, address(this), idsToSend[i]);
1069     }
1070   }
1071 
1072   // Sends a batch of ERC1155 rewards to a list of ERC721 ID holders to be later claimed
1073   function set1155to721Ids(
1074     address[] calldata erc721Addresses,
1075     uint256[] calldata erc721Ids,
1076     uint256[] calldata tokenIds,
1077     uint256[] calldata amounts,
1078     address tokenAddress) external nonReentrant {
1079     require((erc721Addresses.length == erc721Ids.length), "diff lengths");
1080     require((erc721Addresses.length == amounts.length), "diff lengths");
1081     require((erc721Addresses.length == tokenIds.length), "diff lengths");
1082     for (uint256 i = 0; i < erc721Addresses.length; i++) {
1083       erc1155Rewards[erc721Addresses[i]][erc721Ids[i]][tokenAddress][tokenIds[i]] = erc1155Rewards[erc721Addresses[i]][erc721Ids[i]][tokenAddress][tokenIds[i]].add(amounts[i]);
1084       IERC1155(tokenAddress).safeTransferFrom(msg.sender, address(this), tokenIds[i], amounts[i], emptyData);
1085     }
1086   }
1087 
1088 
1089 
1090   // Reward claimers
1091   // Takes ERC20 reward for a given ERC721 ID
1092   function take20Rewards(
1093     address erc721Address,
1094     uint256 holderId,
1095     address rewardAddress) external nonReentrant {
1096     IERC721Enumerable erc721 = IERC721Enumerable(erc721Address);
1097     require((erc721.ownerOf(holderId) == msg.sender), "Not owner");
1098 
1099     // We use transfer to avoid having to make an approve call
1100     // The ITransferFrom interface using transferFrom would require an extra approve call
1101     IERC20(rewardAddress).transfer(msg.sender, erc20Rewards[erc721Address][holderId][rewardAddress]);
1102 
1103     // Clear storage for that one reward address
1104     delete erc20Rewards[erc721Address][holderId][rewardAddress];
1105   }
1106 
1107   // Takes all ERC721 rewards for a given ERC721 ID
1108   function take721Rewards(
1109     address erc721Address,
1110     uint256 holderId,
1111     address rewardAddress) external nonReentrant {
1112     IERC721Enumerable erc721 = IERC721Enumerable(erc721Address);
1113     require((erc721.ownerOf(holderId) == msg.sender), "Not owner");
1114 
1115     // Claim all of the associated rewards in the list
1116     uint256[] memory idList = erc721Rewards[erc721Address][holderId][rewardAddress];
1117     for (uint256 i = 0; i < idList.length; i++) {
1118       _send721Or20(rewardAddress, address(this), msg.sender, idList[i]);
1119     }
1120 
1121     // Clear storage for that ERC721 address
1122     delete erc721Rewards[erc721Address][holderId][rewardAddress];
1123   }
1124 
1125   // Takes ERC1155 reward for a given ERC721 ID
1126   function take1155Rewards(
1127     address erc721Address,
1128     uint256 holderId,
1129     address rewardAddress,
1130     uint256 rewardId) external nonReentrant {
1131     IERC721Enumerable erc721 = IERC721Enumerable(erc721Address);
1132     require((erc721.ownerOf(holderId) == msg.sender), "Not owner");
1133     uint256 amount = erc1155Rewards[erc721Address][holderId][rewardAddress][rewardId];
1134 
1135     // Move amount of erc1155 tokens over
1136     IERC1155(rewardAddress).safeTransferFrom(address(this), msg.sender, rewardId, amount, emptyData);
1137 
1138     // Clear storage for that ERC1155 address and ID
1139     delete erc1155Rewards[erc721Address][holderId][rewardAddress][rewardId];
1140   }
1141 
1142 
1143   // OWNER FUNCTIONS
1144 
1145   function setFeeReceiver(address payable a) public onlyOwner {
1146     feeReceiver = a;
1147   }
1148 
1149   function setEthFee(uint256 f) public onlyOwner {
1150     require(f < ethFee, "Only lower fee");
1151     ethFee = f;
1152   }
1153 
1154   function setMinXmon(uint256 m) public onlyOwner {
1155     minXmon = m;
1156   }
1157 
1158   function setMinXmonNFT(uint256 m) public onlyOwner {
1159     minXmonNFT = m;
1160   }
1161 
1162   function setXmon(address a) public onlyOwner {
1163     xmon = IERC20(a);
1164   }
1165 
1166   function setXmonNFT(address a) public onlyOwner {
1167     xmonNFT = IERC721(a);
1168   }
1169 }