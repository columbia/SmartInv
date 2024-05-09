1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-165[EIP].
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others ({ERC165Checker}).
14  *
15  * For an implementation, see {ERC165}.
16  */
17 interface IERC165 {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
30 
31 
32 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 
37 /**
38  * @dev Implementation of the {IERC165} interface.
39  *
40  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
41  * for the additional interface id that will be supported. For example:
42  *
43  * ```solidity
44  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
45  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
46  * }
47  * ```
48  *
49  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
50  */
51 abstract contract ERC165 is IERC165 {
52     /**
53      * @dev See {IERC165-supportsInterface}.
54      */
55     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
56         return interfaceId == type(IERC165).interfaceId;
57     }
58 }
59 
60 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
61 
62 
63 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
64 
65 pragma solidity ^0.8.0;
66 
67 
68 /**
69  * @dev _Available since v3.1._
70  */
71 interface IERC1155Receiver is IERC165 {
72     /**
73      * @dev Handles the receipt of a single ERC1155 token type. This function is
74      * called at the end of a `safeTransferFrom` after the balance has been updated.
75      *
76      * NOTE: To accept the transfer, this must return
77      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
78      * (i.e. 0xf23a6e61, or its own function selector).
79      *
80      * @param operator The address which initiated the transfer (i.e. msg.sender)
81      * @param from The address which previously owned the token
82      * @param id The ID of the token being transferred
83      * @param value The amount of tokens being transferred
84      * @param data Additional data with no specified format
85      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
86      */
87     function onERC1155Received(
88         address operator,
89         address from,
90         uint256 id,
91         uint256 value,
92         bytes calldata data
93     ) external returns (bytes4);
94 
95     /**
96      * @dev Handles the receipt of a multiple ERC1155 token types. This function
97      * is called at the end of a `safeBatchTransferFrom` after the balances have
98      * been updated.
99      *
100      * NOTE: To accept the transfer(s), this must return
101      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
102      * (i.e. 0xbc197c81, or its own function selector).
103      *
104      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
105      * @param from The address which previously owned the token
106      * @param ids An array containing ids of each token being transferred (order and length must match values array)
107      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
108      * @param data Additional data with no specified format
109      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
110      */
111     function onERC1155BatchReceived(
112         address operator,
113         address from,
114         uint256[] calldata ids,
115         uint256[] calldata values,
116         bytes calldata data
117     ) external returns (bytes4);
118 }
119 
120 // File: @openzeppelin/contracts/token/ERC1155/utils/ERC1155Receiver.sol
121 
122 
123 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/utils/ERC1155Receiver.sol)
124 
125 pragma solidity ^0.8.0;
126 
127 
128 
129 /**
130  * @dev _Available since v3.1._
131  */
132 abstract contract ERC1155Receiver is ERC165, IERC1155Receiver {
133     /**
134      * @dev See {IERC165-supportsInterface}.
135      */
136     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
137         return interfaceId == type(IERC1155Receiver).interfaceId || super.supportsInterface(interfaceId);
138     }
139 }
140 
141 // File: @openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol
142 
143 
144 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/utils/ERC1155Holder.sol)
145 
146 pragma solidity ^0.8.0;
147 
148 
149 /**
150  * Simple implementation of `ERC1155Receiver` that will allow a contract to hold ERC1155 tokens.
151  *
152  * IMPORTANT: When inheriting this contract, you must include a way to use the received tokens, otherwise they will be
153  * stuck.
154  *
155  * @dev _Available since v3.1._
156  */
157 contract ERC1155Holder is ERC1155Receiver {
158     function onERC1155Received(
159         address,
160         address,
161         uint256,
162         uint256,
163         bytes memory
164     ) public virtual override returns (bytes4) {
165         return this.onERC1155Received.selector;
166     }
167 
168     function onERC1155BatchReceived(
169         address,
170         address,
171         uint256[] memory,
172         uint256[] memory,
173         bytes memory
174     ) public virtual override returns (bytes4) {
175         return this.onERC1155BatchReceived.selector;
176     }
177 }
178 
179 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
180 
181 
182 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
183 
184 pragma solidity ^0.8.0;
185 
186 
187 /**
188  * @dev Required interface of an ERC1155 compliant contract, as defined in the
189  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
190  *
191  * _Available since v3.1._
192  */
193 interface IERC1155 is IERC165 {
194     /**
195      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
196      */
197     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
198 
199     /**
200      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
201      * transfers.
202      */
203     event TransferBatch(
204         address indexed operator,
205         address indexed from,
206         address indexed to,
207         uint256[] ids,
208         uint256[] values
209     );
210 
211     /**
212      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
213      * `approved`.
214      */
215     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
216 
217     /**
218      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
219      *
220      * If an {URI} event was emitted for `id`, the standard
221      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
222      * returned by {IERC1155MetadataURI-uri}.
223      */
224     event URI(string value, uint256 indexed id);
225 
226     /**
227      * @dev Returns the amount of tokens of token type `id` owned by `account`.
228      *
229      * Requirements:
230      *
231      * - `account` cannot be the zero address.
232      */
233     function balanceOf(address account, uint256 id) external view returns (uint256);
234 
235     /**
236      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
237      *
238      * Requirements:
239      *
240      * - `accounts` and `ids` must have the same length.
241      */
242     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
243         external
244         view
245         returns (uint256[] memory);
246 
247     /**
248      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
249      *
250      * Emits an {ApprovalForAll} event.
251      *
252      * Requirements:
253      *
254      * - `operator` cannot be the caller.
255      */
256     function setApprovalForAll(address operator, bool approved) external;
257 
258     /**
259      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
260      *
261      * See {setApprovalForAll}.
262      */
263     function isApprovedForAll(address account, address operator) external view returns (bool);
264 
265     /**
266      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
267      *
268      * Emits a {TransferSingle} event.
269      *
270      * Requirements:
271      *
272      * - `to` cannot be the zero address.
273      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
274      * - `from` must have a balance of tokens of type `id` of at least `amount`.
275      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
276      * acceptance magic value.
277      */
278     function safeTransferFrom(
279         address from,
280         address to,
281         uint256 id,
282         uint256 amount,
283         bytes calldata data
284     ) external;
285 
286     /**
287      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
288      *
289      * Emits a {TransferBatch} event.
290      *
291      * Requirements:
292      *
293      * - `ids` and `amounts` must have the same length.
294      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
295      * acceptance magic value.
296      */
297     function safeBatchTransferFrom(
298         address from,
299         address to,
300         uint256[] calldata ids,
301         uint256[] calldata amounts,
302         bytes calldata data
303     ) external;
304 }
305 
306 // File: @openzeppelin/contracts/utils/Context.sol
307 
308 
309 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
310 
311 pragma solidity ^0.8.0;
312 
313 /**
314  * @dev Provides information about the current execution context, including the
315  * sender of the transaction and its data. While these are generally available
316  * via msg.sender and msg.data, they should not be accessed in such a direct
317  * manner, since when dealing with meta-transactions the account sending and
318  * paying for execution may not be the actual sender (as far as an application
319  * is concerned).
320  *
321  * This contract is only required for intermediate, library-like contracts.
322  */
323 abstract contract Context {
324     function _msgSender() internal view virtual returns (address) {
325         return msg.sender;
326     }
327 
328     function _msgData() internal view virtual returns (bytes calldata) {
329         return msg.data;
330     }
331 }
332 
333 // File: @openzeppelin/contracts/access/Ownable.sol
334 
335 
336 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
337 
338 pragma solidity ^0.8.0;
339 
340 
341 /**
342  * @dev Contract module which provides a basic access control mechanism, where
343  * there is an account (an owner) that can be granted exclusive access to
344  * specific functions.
345  *
346  * By default, the owner account will be the one that deploys the contract. This
347  * can later be changed with {transferOwnership}.
348  *
349  * This module is used through inheritance. It will make available the modifier
350  * `onlyOwner`, which can be applied to your functions to restrict their use to
351  * the owner.
352  */
353 abstract contract Ownable is Context {
354     address private _owner;
355 
356     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
357 
358     /**
359      * @dev Initializes the contract setting the deployer as the initial owner.
360      */
361     constructor() {
362         _transferOwnership(_msgSender());
363     }
364 
365     /**
366      * @dev Throws if called by any account other than the owner.
367      */
368     modifier onlyOwner() {
369         _checkOwner();
370         _;
371     }
372 
373     /**
374      * @dev Returns the address of the current owner.
375      */
376     function owner() public view virtual returns (address) {
377         return _owner;
378     }
379 
380     /**
381      * @dev Throws if the sender is not the owner.
382      */
383     function _checkOwner() internal view virtual {
384         require(owner() == _msgSender(), "Ownable: caller is not the owner");
385     }
386 
387     /**
388      * @dev Leaves the contract without owner. It will not be possible to call
389      * `onlyOwner` functions anymore. Can only be called by the current owner.
390      *
391      * NOTE: Renouncing ownership will leave the contract without an owner,
392      * thereby removing any functionality that is only available to the owner.
393      */
394     function renounceOwnership() public virtual onlyOwner {
395         _transferOwnership(address(0));
396     }
397 
398     /**
399      * @dev Transfers ownership of the contract to a new account (`newOwner`).
400      * Can only be called by the current owner.
401      */
402     function transferOwnership(address newOwner) public virtual onlyOwner {
403         require(newOwner != address(0), "Ownable: new owner is the zero address");
404         _transferOwnership(newOwner);
405     }
406 
407     /**
408      * @dev Transfers ownership of the contract to a new account (`newOwner`).
409      * Internal function without access restriction.
410      */
411     function _transferOwnership(address newOwner) internal virtual {
412         address oldOwner = _owner;
413         _owner = newOwner;
414         emit OwnershipTransferred(oldOwner, newOwner);
415     }
416 }
417 
418 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
419 
420 
421 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
422 
423 pragma solidity ^0.8.0;
424 
425 /**
426  * @dev Interface of the ERC20 standard as defined in the EIP.
427  */
428 interface IERC20 {
429     /**
430      * @dev Emitted when `value` tokens are moved from one account (`from`) to
431      * another (`to`).
432      *
433      * Note that `value` may be zero.
434      */
435     event Transfer(address indexed from, address indexed to, uint256 value);
436 
437     /**
438      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
439      * a call to {approve}. `value` is the new allowance.
440      */
441     event Approval(address indexed owner, address indexed spender, uint256 value);
442 
443     /**
444      * @dev Returns the amount of tokens in existence.
445      */
446     function totalSupply() external view returns (uint256);
447 
448     /**
449      * @dev Returns the amount of tokens owned by `account`.
450      */
451     function balanceOf(address account) external view returns (uint256);
452 
453     /**
454      * @dev Moves `amount` tokens from the caller's account to `to`.
455      *
456      * Returns a boolean value indicating whether the operation succeeded.
457      *
458      * Emits a {Transfer} event.
459      */
460     function transfer(address to, uint256 amount) external returns (bool);
461 
462     /**
463      * @dev Returns the remaining number of tokens that `spender` will be
464      * allowed to spend on behalf of `owner` through {transferFrom}. This is
465      * zero by default.
466      *
467      * This value changes when {approve} or {transferFrom} are called.
468      */
469     function allowance(address owner, address spender) external view returns (uint256);
470 
471     /**
472      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
473      *
474      * Returns a boolean value indicating whether the operation succeeded.
475      *
476      * IMPORTANT: Beware that changing an allowance with this method brings the risk
477      * that someone may use both the old and the new allowance by unfortunate
478      * transaction ordering. One possible solution to mitigate this race
479      * condition is to first reduce the spender's allowance to 0 and set the
480      * desired value afterwards:
481      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
482      *
483      * Emits an {Approval} event.
484      */
485     function approve(address spender, uint256 amount) external returns (bool);
486 
487     /**
488      * @dev Moves `amount` tokens from `from` to `to` using the
489      * allowance mechanism. `amount` is then deducted from the caller's
490      * allowance.
491      *
492      * Returns a boolean value indicating whether the operation succeeded.
493      *
494      * Emits a {Transfer} event.
495      */
496     function transferFrom(
497         address from,
498         address to,
499         uint256 amount
500     ) external returns (bool);
501 }
502 
503 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
504 
505 
506 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
507 
508 pragma solidity ^0.8.0;
509 
510 
511 /**
512  * @dev Interface for the optional metadata functions from the ERC20 standard.
513  *
514  * _Available since v4.1._
515  */
516 interface IERC20Metadata is IERC20 {
517     /**
518      * @dev Returns the name of the token.
519      */
520     function name() external view returns (string memory);
521 
522     /**
523      * @dev Returns the symbol of the token.
524      */
525     function symbol() external view returns (string memory);
526 
527     /**
528      * @dev Returns the decimals places of the token.
529      */
530     function decimals() external view returns (uint8);
531 }
532 
533 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
534 
535 
536 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
537 
538 pragma solidity ^0.8.0;
539 
540 
541 
542 
543 /**
544  * @dev Implementation of the {IERC20} interface.
545  *
546  * This implementation is agnostic to the way tokens are created. This means
547  * that a supply mechanism has to be added in a derived contract using {_mint}.
548  * For a generic mechanism see {ERC20PresetMinterPauser}.
549  *
550  * TIP: For a detailed writeup see our guide
551  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
552  * to implement supply mechanisms].
553  *
554  * We have followed general OpenZeppelin Contracts guidelines: functions revert
555  * instead returning `false` on failure. This behavior is nonetheless
556  * conventional and does not conflict with the expectations of ERC20
557  * applications.
558  *
559  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
560  * This allows applications to reconstruct the allowance for all accounts just
561  * by listening to said events. Other implementations of the EIP may not emit
562  * these events, as it isn't required by the specification.
563  *
564  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
565  * functions have been added to mitigate the well-known issues around setting
566  * allowances. See {IERC20-approve}.
567  */
568 contract ERC20 is Context, IERC20, IERC20Metadata {
569     mapping(address => uint256) private _balances;
570 
571     mapping(address => mapping(address => uint256)) private _allowances;
572 
573     uint256 private _totalSupply;
574 
575     string private _name;
576     string private _symbol;
577 
578     /**
579      * @dev Sets the values for {name} and {symbol}.
580      *
581      * The default value of {decimals} is 18. To select a different value for
582      * {decimals} you should overload it.
583      *
584      * All two of these values are immutable: they can only be set once during
585      * construction.
586      */
587     constructor(string memory name_, string memory symbol_) {
588         _name = name_;
589         _symbol = symbol_;
590     }
591 
592     /**
593      * @dev Returns the name of the token.
594      */
595     function name() public view virtual override returns (string memory) {
596         return _name;
597     }
598 
599     /**
600      * @dev Returns the symbol of the token, usually a shorter version of the
601      * name.
602      */
603     function symbol() public view virtual override returns (string memory) {
604         return _symbol;
605     }
606 
607     /**
608      * @dev Returns the number of decimals used to get its user representation.
609      * For example, if `decimals` equals `2`, a balance of `505` tokens should
610      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
611      *
612      * Tokens usually opt for a value of 18, imitating the relationship between
613      * Ether and Wei. This is the value {ERC20} uses, unless this function is
614      * overridden;
615      *
616      * NOTE: This information is only used for _display_ purposes: it in
617      * no way affects any of the arithmetic of the contract, including
618      * {IERC20-balanceOf} and {IERC20-transfer}.
619      */
620     function decimals() public view virtual override returns (uint8) {
621         return 18;
622     }
623 
624     /**
625      * @dev See {IERC20-totalSupply}.
626      */
627     function totalSupply() public view virtual override returns (uint256) {
628         return _totalSupply;
629     }
630 
631     /**
632      * @dev See {IERC20-balanceOf}.
633      */
634     function balanceOf(address account) public view virtual override returns (uint256) {
635         return _balances[account];
636     }
637 
638     /**
639      * @dev See {IERC20-transfer}.
640      *
641      * Requirements:
642      *
643      * - `to` cannot be the zero address.
644      * - the caller must have a balance of at least `amount`.
645      */
646     function transfer(address to, uint256 amount) public virtual override returns (bool) {
647         address owner = _msgSender();
648         _transfer(owner, to, amount);
649         return true;
650     }
651 
652     /**
653      * @dev See {IERC20-allowance}.
654      */
655     function allowance(address owner, address spender) public view virtual override returns (uint256) {
656         return _allowances[owner][spender];
657     }
658 
659     /**
660      * @dev See {IERC20-approve}.
661      *
662      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
663      * `transferFrom`. This is semantically equivalent to an infinite approval.
664      *
665      * Requirements:
666      *
667      * - `spender` cannot be the zero address.
668      */
669     function approve(address spender, uint256 amount) public virtual override returns (bool) {
670         address owner = _msgSender();
671         _approve(owner, spender, amount);
672         return true;
673     }
674 
675     /**
676      * @dev See {IERC20-transferFrom}.
677      *
678      * Emits an {Approval} event indicating the updated allowance. This is not
679      * required by the EIP. See the note at the beginning of {ERC20}.
680      *
681      * NOTE: Does not update the allowance if the current allowance
682      * is the maximum `uint256`.
683      *
684      * Requirements:
685      *
686      * - `from` and `to` cannot be the zero address.
687      * - `from` must have a balance of at least `amount`.
688      * - the caller must have allowance for ``from``'s tokens of at least
689      * `amount`.
690      */
691     function transferFrom(
692         address from,
693         address to,
694         uint256 amount
695     ) public virtual override returns (bool) {
696         address spender = _msgSender();
697         _spendAllowance(from, spender, amount);
698         _transfer(from, to, amount);
699         return true;
700     }
701 
702     /**
703      * @dev Atomically increases the allowance granted to `spender` by the caller.
704      *
705      * This is an alternative to {approve} that can be used as a mitigation for
706      * problems described in {IERC20-approve}.
707      *
708      * Emits an {Approval} event indicating the updated allowance.
709      *
710      * Requirements:
711      *
712      * - `spender` cannot be the zero address.
713      */
714     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
715         address owner = _msgSender();
716         _approve(owner, spender, allowance(owner, spender) + addedValue);
717         return true;
718     }
719 
720     /**
721      * @dev Atomically decreases the allowance granted to `spender` by the caller.
722      *
723      * This is an alternative to {approve} that can be used as a mitigation for
724      * problems described in {IERC20-approve}.
725      *
726      * Emits an {Approval} event indicating the updated allowance.
727      *
728      * Requirements:
729      *
730      * - `spender` cannot be the zero address.
731      * - `spender` must have allowance for the caller of at least
732      * `subtractedValue`.
733      */
734     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
735         address owner = _msgSender();
736         uint256 currentAllowance = allowance(owner, spender);
737         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
738         unchecked {
739             _approve(owner, spender, currentAllowance - subtractedValue);
740         }
741 
742         return true;
743     }
744 
745     /**
746      * @dev Moves `amount` of tokens from `from` to `to`.
747      *
748      * This internal function is equivalent to {transfer}, and can be used to
749      * e.g. implement automatic token fees, slashing mechanisms, etc.
750      *
751      * Emits a {Transfer} event.
752      *
753      * Requirements:
754      *
755      * - `from` cannot be the zero address.
756      * - `to` cannot be the zero address.
757      * - `from` must have a balance of at least `amount`.
758      */
759     function _transfer(
760         address from,
761         address to,
762         uint256 amount
763     ) internal virtual {
764         require(from != address(0), "ERC20: transfer from the zero address");
765         require(to != address(0), "ERC20: transfer to the zero address");
766 
767         _beforeTokenTransfer(from, to, amount);
768 
769         uint256 fromBalance = _balances[from];
770         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
771         unchecked {
772             _balances[from] = fromBalance - amount;
773             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
774             // decrementing then incrementing.
775             _balances[to] += amount;
776         }
777 
778         emit Transfer(from, to, amount);
779 
780         _afterTokenTransfer(from, to, amount);
781     }
782 
783     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
784      * the total supply.
785      *
786      * Emits a {Transfer} event with `from` set to the zero address.
787      *
788      * Requirements:
789      *
790      * - `account` cannot be the zero address.
791      */
792     function _mint(address account, uint256 amount) internal virtual {
793         require(account != address(0), "ERC20: mint to the zero address");
794 
795         _beforeTokenTransfer(address(0), account, amount);
796 
797         _totalSupply += amount;
798         unchecked {
799             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
800             _balances[account] += amount;
801         }
802         emit Transfer(address(0), account, amount);
803 
804         _afterTokenTransfer(address(0), account, amount);
805     }
806 
807     /**
808      * @dev Destroys `amount` tokens from `account`, reducing the
809      * total supply.
810      *
811      * Emits a {Transfer} event with `to` set to the zero address.
812      *
813      * Requirements:
814      *
815      * - `account` cannot be the zero address.
816      * - `account` must have at least `amount` tokens.
817      */
818     function _burn(address account, uint256 amount) internal virtual {
819         require(account != address(0), "ERC20: burn from the zero address");
820 
821         _beforeTokenTransfer(account, address(0), amount);
822 
823         uint256 accountBalance = _balances[account];
824         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
825         unchecked {
826             _balances[account] = accountBalance - amount;
827             // Overflow not possible: amount <= accountBalance <= totalSupply.
828             _totalSupply -= amount;
829         }
830 
831         emit Transfer(account, address(0), amount);
832 
833         _afterTokenTransfer(account, address(0), amount);
834     }
835 
836     /**
837      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
838      *
839      * This internal function is equivalent to `approve`, and can be used to
840      * e.g. set automatic allowances for certain subsystems, etc.
841      *
842      * Emits an {Approval} event.
843      *
844      * Requirements:
845      *
846      * - `owner` cannot be the zero address.
847      * - `spender` cannot be the zero address.
848      */
849     function _approve(
850         address owner,
851         address spender,
852         uint256 amount
853     ) internal virtual {
854         require(owner != address(0), "ERC20: approve from the zero address");
855         require(spender != address(0), "ERC20: approve to the zero address");
856 
857         _allowances[owner][spender] = amount;
858         emit Approval(owner, spender, amount);
859     }
860 
861     /**
862      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
863      *
864      * Does not update the allowance amount in case of infinite allowance.
865      * Revert if not enough allowance is available.
866      *
867      * Might emit an {Approval} event.
868      */
869     function _spendAllowance(
870         address owner,
871         address spender,
872         uint256 amount
873     ) internal virtual {
874         uint256 currentAllowance = allowance(owner, spender);
875         if (currentAllowance != type(uint256).max) {
876             require(currentAllowance >= amount, "ERC20: insufficient allowance");
877             unchecked {
878                 _approve(owner, spender, currentAllowance - amount);
879             }
880         }
881     }
882 
883     /**
884      * @dev Hook that is called before any transfer of tokens. This includes
885      * minting and burning.
886      *
887      * Calling conditions:
888      *
889      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
890      * will be transferred to `to`.
891      * - when `from` is zero, `amount` tokens will be minted for `to`.
892      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
893      * - `from` and `to` are never both zero.
894      *
895      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
896      */
897     function _beforeTokenTransfer(
898         address from,
899         address to,
900         uint256 amount
901     ) internal virtual {}
902 
903     /**
904      * @dev Hook that is called after any transfer of tokens. This includes
905      * minting and burning.
906      *
907      * Calling conditions:
908      *
909      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
910      * has been transferred to `to`.
911      * - when `from` is zero, `amount` tokens have been minted for `to`.
912      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
913      * - `from` and `to` are never both zero.
914      *
915      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
916      */
917     function _afterTokenTransfer(
918         address from,
919         address to,
920         uint256 amount
921     ) internal virtual {}
922 }
923 
924 // File: KEKO.sol
925 
926 
927 pragma solidity ^0.8.9;
928 
929 
930 
931 
932 
933 contract KEKO is ERC20, ERC1155Holder, Ownable {
934     IERC1155 public erc1155Contract;
935     uint256 public erc1155TokenId;
936     uint256 public tokenSupply = 69000000;
937 
938     constructor(address _erc1155Contract, uint256 _tokenId) ERC20("KEKO", "KEKO") {
939         erc1155Contract = IERC1155(_erc1155Contract);
940         erc1155TokenId = _tokenId;
941         _mint(address(this), tokenSupply * (10 ** 18));
942     }
943 
944     function depositAndClaim(uint256 amount) external {
945         require(amount >= 1, "Amount must be greater than 1");
946         
947         // Transfer the specified amount of ERC1155 tokens from the user to the contract
948         erc1155Contract.safeTransferFrom(msg.sender, address(this), erc1155TokenId, amount, "");
949 
950         // Transfer the equivalent amount of ERC20 tokens to the user
951         _transfer(address(this), msg.sender, amount * (10 ** 18));
952 
953     }
954 
955     function withdrawAndClaim(uint256 amount) external {
956         require(amount >= 1, "Amount must be greater than 1");
957 
958         // Transfer the specified amount of ERC20 tokens to the contract pool
959         _transfer(msg.sender, address(this), amount * (10 ** 18));
960 
961         // Transfer the equivalent amount of ERC1155 tokens to the user
962         erc1155Contract.safeTransferFrom(address(this), msg.sender, erc1155TokenId, amount, "");
963 
964     }
965 }