1 // nonplayablecoin.xyz
2 
3 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC165 standard, as defined in the
11  * https://eips.ethereum.org/EIPS/eip-165[EIP].
12  *
13  * Implementers can declare support of contract interfaces, which can then be
14  * queried by others ({ERC165Checker}).
15  *
16  * For an implementation, see {ERC165}.
17  */
18 interface IERC165 {
19     /**
20      * @dev Returns true if this contract implements the interface defined by
21      * `interfaceId`. See the corresponding
22      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
23      * to learn more about how these ids are created.
24      *
25      * This function call must use less than 30 000 gas.
26      */
27     function supportsInterface(bytes4 interfaceId) external view returns (bool);
28 }
29 
30 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
31 
32 
33 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
34 
35 pragma solidity ^0.8.0;
36 
37 
38 /**
39  * @dev Implementation of the {IERC165} interface.
40  *
41  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
42  * for the additional interface id that will be supported. For example:
43  *
44  * ```solidity
45  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
46  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
47  * }
48  * ```
49  *
50  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
51  */
52 abstract contract ERC165 is IERC165 {
53     /**
54      * @dev See {IERC165-supportsInterface}.
55      */
56     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
57         return interfaceId == type(IERC165).interfaceId;
58     }
59 }
60 
61 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
62 
63 
64 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
65 
66 pragma solidity ^0.8.0;
67 
68 
69 /**
70  * @dev _Available since v3.1._
71  */
72 interface IERC1155Receiver is IERC165 {
73     /**
74      * @dev Handles the receipt of a single ERC1155 token type. This function is
75      * called at the end of a `safeTransferFrom` after the balance has been updated.
76      *
77      * NOTE: To accept the transfer, this must return
78      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
79      * (i.e. 0xf23a6e61, or its own function selector).
80      *
81      * @param operator The address which initiated the transfer (i.e. msg.sender)
82      * @param from The address which previously owned the token
83      * @param id The ID of the token being transferred
84      * @param value The amount of tokens being transferred
85      * @param data Additional data with no specified format
86      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
87      */
88     function onERC1155Received(
89         address operator,
90         address from,
91         uint256 id,
92         uint256 value,
93         bytes calldata data
94     ) external returns (bytes4);
95 
96     /**
97      * @dev Handles the receipt of a multiple ERC1155 token types. This function
98      * is called at the end of a `safeBatchTransferFrom` after the balances have
99      * been updated.
100      *
101      * NOTE: To accept the transfer(s), this must return
102      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
103      * (i.e. 0xbc197c81, or its own function selector).
104      *
105      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
106      * @param from The address which previously owned the token
107      * @param ids An array containing ids of each token being transferred (order and length must match values array)
108      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
109      * @param data Additional data with no specified format
110      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
111      */
112     function onERC1155BatchReceived(
113         address operator,
114         address from,
115         uint256[] calldata ids,
116         uint256[] calldata values,
117         bytes calldata data
118     ) external returns (bytes4);
119 }
120 
121 // File: @openzeppelin/contracts/token/ERC1155/utils/ERC1155Receiver.sol
122 
123 
124 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/utils/ERC1155Receiver.sol)
125 
126 pragma solidity ^0.8.0;
127 
128 
129 
130 /**
131  * @dev _Available since v3.1._
132  */
133 abstract contract ERC1155Receiver is ERC165, IERC1155Receiver {
134     /**
135      * @dev See {IERC165-supportsInterface}.
136      */
137     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
138         return interfaceId == type(IERC1155Receiver).interfaceId || super.supportsInterface(interfaceId);
139     }
140 }
141 
142 // File: @openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol
143 
144 
145 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/utils/ERC1155Holder.sol)
146 
147 pragma solidity ^0.8.0;
148 
149 
150 /**
151  * Simple implementation of `ERC1155Receiver` that will allow a contract to hold ERC1155 tokens.
152  *
153  * IMPORTANT: When inheriting this contract, you must include a way to use the received tokens, otherwise they will be
154  * stuck.
155  *
156  * @dev _Available since v3.1._
157  */
158 contract ERC1155Holder is ERC1155Receiver {
159     function onERC1155Received(
160         address,
161         address,
162         uint256,
163         uint256,
164         bytes memory
165     ) public virtual override returns (bytes4) {
166         return this.onERC1155Received.selector;
167     }
168 
169     function onERC1155BatchReceived(
170         address,
171         address,
172         uint256[] memory,
173         uint256[] memory,
174         bytes memory
175     ) public virtual override returns (bytes4) {
176         return this.onERC1155BatchReceived.selector;
177     }
178 }
179 
180 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
181 
182 
183 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
184 
185 pragma solidity ^0.8.0;
186 
187 
188 /**
189  * @dev Required interface of an ERC1155 compliant contract, as defined in the
190  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
191  *
192  * _Available since v3.1._
193  */
194 interface IERC1155 is IERC165 {
195     /**
196      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
197      */
198     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
199 
200     /**
201      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
202      * transfers.
203      */
204     event TransferBatch(
205         address indexed operator,
206         address indexed from,
207         address indexed to,
208         uint256[] ids,
209         uint256[] values
210     );
211 
212     /**
213      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
214      * `approved`.
215      */
216     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
217 
218     /**
219      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
220      *
221      * If an {URI} event was emitted for `id`, the standard
222      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
223      * returned by {IERC1155MetadataURI-uri}.
224      */
225     event URI(string value, uint256 indexed id);
226 
227     /**
228      * @dev Returns the amount of tokens of token type `id` owned by `account`.
229      *
230      * Requirements:
231      *
232      * - `account` cannot be the zero address.
233      */
234     function balanceOf(address account, uint256 id) external view returns (uint256);
235 
236     /**
237      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
238      *
239      * Requirements:
240      *
241      * - `accounts` and `ids` must have the same length.
242      */
243     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
244         external
245         view
246         returns (uint256[] memory);
247 
248     /**
249      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
250      *
251      * Emits an {ApprovalForAll} event.
252      *
253      * Requirements:
254      *
255      * - `operator` cannot be the caller.
256      */
257     function setApprovalForAll(address operator, bool approved) external;
258 
259     /**
260      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
261      *
262      * See {setApprovalForAll}.
263      */
264     function isApprovedForAll(address account, address operator) external view returns (bool);
265 
266     /**
267      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
268      *
269      * Emits a {TransferSingle} event.
270      *
271      * Requirements:
272      *
273      * - `to` cannot be the zero address.
274      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
275      * - `from` must have a balance of tokens of type `id` of at least `amount`.
276      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
277      * acceptance magic value.
278      */
279     function safeTransferFrom(
280         address from,
281         address to,
282         uint256 id,
283         uint256 amount,
284         bytes calldata data
285     ) external;
286 
287     /**
288      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
289      *
290      * Emits a {TransferBatch} event.
291      *
292      * Requirements:
293      *
294      * - `ids` and `amounts` must have the same length.
295      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
296      * acceptance magic value.
297      */
298     function safeBatchTransferFrom(
299         address from,
300         address to,
301         uint256[] calldata ids,
302         uint256[] calldata amounts,
303         bytes calldata data
304     ) external;
305 }
306 
307 // File: @openzeppelin/contracts/utils/Context.sol
308 
309 
310 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
311 
312 pragma solidity ^0.8.0;
313 
314 /**
315  * @dev Provides information about the current execution context, including the
316  * sender of the transaction and its data. While these are generally available
317  * via msg.sender and msg.data, they should not be accessed in such a direct
318  * manner, since when dealing with meta-transactions the account sending and
319  * paying for execution may not be the actual sender (as far as an application
320  * is concerned).
321  *
322  * This contract is only required for intermediate, library-like contracts.
323  */
324 abstract contract Context {
325     function _msgSender() internal view virtual returns (address) {
326         return msg.sender;
327     }
328 
329     function _msgData() internal view virtual returns (bytes calldata) {
330         return msg.data;
331     }
332 }
333 
334 // File: @openzeppelin/contracts/access/Ownable.sol
335 
336 
337 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
338 
339 pragma solidity ^0.8.0;
340 
341 
342 /**
343  * @dev Contract module which provides a basic access control mechanism, where
344  * there is an account (an owner) that can be granted exclusive access to
345  * specific functions.
346  *
347  * By default, the owner account will be the one that deploys the contract. This
348  * can later be changed with {transferOwnership}.
349  *
350  * This module is used through inheritance. It will make available the modifier
351  * `onlyOwner`, which can be applied to your functions to restrict their use to
352  * the owner.
353  */
354 abstract contract Ownable is Context {
355     address private _owner;
356 
357     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
358 
359     /**
360      * @dev Initializes the contract setting the deployer as the initial owner.
361      */
362     constructor() {
363         _transferOwnership(_msgSender());
364     }
365 
366     /**
367      * @dev Throws if called by any account other than the owner.
368      */
369     modifier onlyOwner() {
370         _checkOwner();
371         _;
372     }
373 
374     /**
375      * @dev Returns the address of the current owner.
376      */
377     function owner() public view virtual returns (address) {
378         return _owner;
379     }
380 
381     /**
382      * @dev Throws if the sender is not the owner.
383      */
384     function _checkOwner() internal view virtual {
385         require(owner() == _msgSender(), "Ownable: caller is not the owner");
386     }
387 
388     /**
389      * @dev Leaves the contract without owner. It will not be possible to call
390      * `onlyOwner` functions anymore. Can only be called by the current owner.
391      *
392      * NOTE: Renouncing ownership will leave the contract without an owner,
393      * thereby removing any functionality that is only available to the owner.
394      */
395     function renounceOwnership() public virtual onlyOwner {
396         _transferOwnership(address(0));
397     }
398 
399     /**
400      * @dev Transfers ownership of the contract to a new account (`newOwner`).
401      * Can only be called by the current owner.
402      */
403     function transferOwnership(address newOwner) public virtual onlyOwner {
404         require(newOwner != address(0), "Ownable: new owner is the zero address");
405         _transferOwnership(newOwner);
406     }
407 
408     /**
409      * @dev Transfers ownership of the contract to a new account (`newOwner`).
410      * Internal function without access restriction.
411      */
412     function _transferOwnership(address newOwner) internal virtual {
413         address oldOwner = _owner;
414         _owner = newOwner;
415         emit OwnershipTransferred(oldOwner, newOwner);
416     }
417 }
418 
419 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
420 
421 
422 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
423 
424 pragma solidity ^0.8.0;
425 
426 /**
427  * @dev Interface of the ERC20 standard as defined in the EIP.
428  */
429 interface IERC20 {
430     /**
431      * @dev Emitted when `value` tokens are moved from one account (`from`) to
432      * another (`to`).
433      *
434      * Note that `value` may be zero.
435      */
436     event Transfer(address indexed from, address indexed to, uint256 value);
437 
438     /**
439      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
440      * a call to {approve}. `value` is the new allowance.
441      */
442     event Approval(address indexed owner, address indexed spender, uint256 value);
443 
444     /**
445      * @dev Returns the amount of tokens in existence.
446      */
447     function totalSupply() external view returns (uint256);
448 
449     /**
450      * @dev Returns the amount of tokens owned by `account`.
451      */
452     function balanceOf(address account) external view returns (uint256);
453 
454     /**
455      * @dev Moves `amount` tokens from the caller's account to `to`.
456      *
457      * Returns a boolean value indicating whether the operation succeeded.
458      *
459      * Emits a {Transfer} event.
460      */
461     function transfer(address to, uint256 amount) external returns (bool);
462 
463     /**
464      * @dev Returns the remaining number of tokens that `spender` will be
465      * allowed to spend on behalf of `owner` through {transferFrom}. This is
466      * zero by default.
467      *
468      * This value changes when {approve} or {transferFrom} are called.
469      */
470     function allowance(address owner, address spender) external view returns (uint256);
471 
472     /**
473      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
474      *
475      * Returns a boolean value indicating whether the operation succeeded.
476      *
477      * IMPORTANT: Beware that changing an allowance with this method brings the risk
478      * that someone may use both the old and the new allowance by unfortunate
479      * transaction ordering. One possible solution to mitigate this race
480      * condition is to first reduce the spender's allowance to 0 and set the
481      * desired value afterwards:
482      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
483      *
484      * Emits an {Approval} event.
485      */
486     function approve(address spender, uint256 amount) external returns (bool);
487 
488     /**
489      * @dev Moves `amount` tokens from `from` to `to` using the
490      * allowance mechanism. `amount` is then deducted from the caller's
491      * allowance.
492      *
493      * Returns a boolean value indicating whether the operation succeeded.
494      *
495      * Emits a {Transfer} event.
496      */
497     function transferFrom(
498         address from,
499         address to,
500         uint256 amount
501     ) external returns (bool);
502 }
503 
504 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
505 
506 
507 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
508 
509 pragma solidity ^0.8.0;
510 
511 
512 /**
513  * @dev Interface for the optional metadata functions from the ERC20 standard.
514  *
515  * _Available since v4.1._
516  */
517 interface IERC20Metadata is IERC20 {
518     /**
519      * @dev Returns the name of the token.
520      */
521     function name() external view returns (string memory);
522 
523     /**
524      * @dev Returns the symbol of the token.
525      */
526     function symbol() external view returns (string memory);
527 
528     /**
529      * @dev Returns the decimals places of the token.
530      */
531     function decimals() external view returns (uint8);
532 }
533 
534 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
535 
536 
537 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
538 
539 pragma solidity ^0.8.0;
540 
541 
542 
543 
544 /**
545  * @dev Implementation of the {IERC20} interface.
546  *
547  * This implementation is agnostic to the way tokens are created. This means
548  * that a supply mechanism has to be added in a derived contract using {_mint}.
549  * For a generic mechanism see {ERC20PresetMinterPauser}.
550  *
551  * TIP: For a detailed writeup see our guide
552  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
553  * to implement supply mechanisms].
554  *
555  * We have followed general OpenZeppelin Contracts guidelines: functions revert
556  * instead returning `false` on failure. This behavior is nonetheless
557  * conventional and does not conflict with the expectations of ERC20
558  * applications.
559  *
560  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
561  * This allows applications to reconstruct the allowance for all accounts just
562  * by listening to said events. Other implementations of the EIP may not emit
563  * these events, as it isn't required by the specification.
564  *
565  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
566  * functions have been added to mitigate the well-known issues around setting
567  * allowances. See {IERC20-approve}.
568  */
569 contract ERC20 is Context, IERC20, IERC20Metadata {
570     mapping(address => uint256) private _balances;
571 
572     mapping(address => mapping(address => uint256)) private _allowances;
573 
574     uint256 private _totalSupply;
575 
576     string private _name;
577     string private _symbol;
578 
579     /**
580      * @dev Sets the values for {name} and {symbol}.
581      *
582      * The default value of {decimals} is 18. To select a different value for
583      * {decimals} you should overload it.
584      *
585      * All two of these values are immutable: they can only be set once during
586      * construction.
587      */
588     constructor(string memory name_, string memory symbol_) {
589         _name = name_;
590         _symbol = symbol_;
591     }
592 
593     /**
594      * @dev Returns the name of the token.
595      */
596     function name() public view virtual override returns (string memory) {
597         return _name;
598     }
599 
600     /**
601      * @dev Returns the symbol of the token, usually a shorter version of the
602      * name.
603      */
604     function symbol() public view virtual override returns (string memory) {
605         return _symbol;
606     }
607 
608     /**
609      * @dev Returns the number of decimals used to get its user representation.
610      * For example, if `decimals` equals `2`, a balance of `505` tokens should
611      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
612      *
613      * Tokens usually opt for a value of 18, imitating the relationship between
614      * Ether and Wei. This is the value {ERC20} uses, unless this function is
615      * overridden;
616      *
617      * NOTE: This information is only used for _display_ purposes: it in
618      * no way affects any of the arithmetic of the contract, including
619      * {IERC20-balanceOf} and {IERC20-transfer}.
620      */
621     function decimals() public view virtual override returns (uint8) {
622         return 18;
623     }
624 
625     /**
626      * @dev See {IERC20-totalSupply}.
627      */
628     function totalSupply() public view virtual override returns (uint256) {
629         return _totalSupply;
630     }
631 
632     /**
633      * @dev See {IERC20-balanceOf}.
634      */
635     function balanceOf(address account) public view virtual override returns (uint256) {
636         return _balances[account];
637     }
638 
639     /**
640      * @dev See {IERC20-transfer}.
641      *
642      * Requirements:
643      *
644      * - `to` cannot be the zero address.
645      * - the caller must have a balance of at least `amount`.
646      */
647     function transfer(address to, uint256 amount) public virtual override returns (bool) {
648         address owner = _msgSender();
649         _transfer(owner, to, amount);
650         return true;
651     }
652 
653     /**
654      * @dev See {IERC20-allowance}.
655      */
656     function allowance(address owner, address spender) public view virtual override returns (uint256) {
657         return _allowances[owner][spender];
658     }
659 
660     /**
661      * @dev See {IERC20-approve}.
662      *
663      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
664      * `transferFrom`. This is semantically equivalent to an infinite approval.
665      *
666      * Requirements:
667      *
668      * - `spender` cannot be the zero address.
669      */
670     function approve(address spender, uint256 amount) public virtual override returns (bool) {
671         address owner = _msgSender();
672         _approve(owner, spender, amount);
673         return true;
674     }
675 
676     /**
677      * @dev See {IERC20-transferFrom}.
678      *
679      * Emits an {Approval} event indicating the updated allowance. This is not
680      * required by the EIP. See the note at the beginning of {ERC20}.
681      *
682      * NOTE: Does not update the allowance if the current allowance
683      * is the maximum `uint256`.
684      *
685      * Requirements:
686      *
687      * - `from` and `to` cannot be the zero address.
688      * - `from` must have a balance of at least `amount`.
689      * - the caller must have allowance for ``from``'s tokens of at least
690      * `amount`.
691      */
692     function transferFrom(
693         address from,
694         address to,
695         uint256 amount
696     ) public virtual override returns (bool) {
697         address spender = _msgSender();
698         _spendAllowance(from, spender, amount);
699         _transfer(from, to, amount);
700         return true;
701     }
702 
703     /**
704      * @dev Atomically increases the allowance granted to `spender` by the caller.
705      *
706      * This is an alternative to {approve} that can be used as a mitigation for
707      * problems described in {IERC20-approve}.
708      *
709      * Emits an {Approval} event indicating the updated allowance.
710      *
711      * Requirements:
712      *
713      * - `spender` cannot be the zero address.
714      */
715     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
716         address owner = _msgSender();
717         _approve(owner, spender, allowance(owner, spender) + addedValue);
718         return true;
719     }
720 
721     /**
722      * @dev Atomically decreases the allowance granted to `spender` by the caller.
723      *
724      * This is an alternative to {approve} that can be used as a mitigation for
725      * problems described in {IERC20-approve}.
726      *
727      * Emits an {Approval} event indicating the updated allowance.
728      *
729      * Requirements:
730      *
731      * - `spender` cannot be the zero address.
732      * - `spender` must have allowance for the caller of at least
733      * `subtractedValue`.
734      */
735     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
736         address owner = _msgSender();
737         uint256 currentAllowance = allowance(owner, spender);
738         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
739         unchecked {
740             _approve(owner, spender, currentAllowance - subtractedValue);
741         }
742 
743         return true;
744     }
745 
746     /**
747      * @dev Moves `amount` of tokens from `from` to `to`.
748      *
749      * This internal function is equivalent to {transfer}, and can be used to
750      * e.g. implement automatic token fees, slashing mechanisms, etc.
751      *
752      * Emits a {Transfer} event.
753      *
754      * Requirements:
755      *
756      * - `from` cannot be the zero address.
757      * - `to` cannot be the zero address.
758      * - `from` must have a balance of at least `amount`.
759      */
760     function _transfer(
761         address from,
762         address to,
763         uint256 amount
764     ) internal virtual {
765         require(from != address(0), "ERC20: transfer from the zero address");
766         require(to != address(0), "ERC20: transfer to the zero address");
767 
768         _beforeTokenTransfer(from, to, amount);
769 
770         uint256 fromBalance = _balances[from];
771         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
772         unchecked {
773             _balances[from] = fromBalance - amount;
774             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
775             // decrementing then incrementing.
776             _balances[to] += amount;
777         }
778 
779         emit Transfer(from, to, amount);
780 
781         _afterTokenTransfer(from, to, amount);
782     }
783 
784     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
785      * the total supply.
786      *
787      * Emits a {Transfer} event with `from` set to the zero address.
788      *
789      * Requirements:
790      *
791      * - `account` cannot be the zero address.
792      */
793     function _mint(address account, uint256 amount) internal virtual {
794         require(account != address(0), "ERC20: mint to the zero address");
795 
796         _beforeTokenTransfer(address(0), account, amount);
797 
798         _totalSupply += amount;
799         unchecked {
800             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
801             _balances[account] += amount;
802         }
803         emit Transfer(address(0), account, amount);
804 
805         _afterTokenTransfer(address(0), account, amount);
806     }
807 
808     /**
809      * @dev Destroys `amount` tokens from `account`, reducing the
810      * total supply.
811      *
812      * Emits a {Transfer} event with `to` set to the zero address.
813      *
814      * Requirements:
815      *
816      * - `account` cannot be the zero address.
817      * - `account` must have at least `amount` tokens.
818      */
819     function _burn(address account, uint256 amount) internal virtual {
820         require(account != address(0), "ERC20: burn from the zero address");
821 
822         _beforeTokenTransfer(account, address(0), amount);
823 
824         uint256 accountBalance = _balances[account];
825         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
826         unchecked {
827             _balances[account] = accountBalance - amount;
828             // Overflow not possible: amount <= accountBalance <= totalSupply.
829             _totalSupply -= amount;
830         }
831 
832         emit Transfer(account, address(0), amount);
833 
834         _afterTokenTransfer(account, address(0), amount);
835     }
836 
837     /**
838      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
839      *
840      * This internal function is equivalent to `approve`, and can be used to
841      * e.g. set automatic allowances for certain subsystems, etc.
842      *
843      * Emits an {Approval} event.
844      *
845      * Requirements:
846      *
847      * - `owner` cannot be the zero address.
848      * - `spender` cannot be the zero address.
849      */
850     function _approve(
851         address owner,
852         address spender,
853         uint256 amount
854     ) internal virtual {
855         require(owner != address(0), "ERC20: approve from the zero address");
856         require(spender != address(0), "ERC20: approve to the zero address");
857 
858         _allowances[owner][spender] = amount;
859         emit Approval(owner, spender, amount);
860     }
861 
862     /**
863      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
864      *
865      * Does not update the allowance amount in case of infinite allowance.
866      * Revert if not enough allowance is available.
867      *
868      * Might emit an {Approval} event.
869      */
870     function _spendAllowance(
871         address owner,
872         address spender,
873         uint256 amount
874     ) internal virtual {
875         uint256 currentAllowance = allowance(owner, spender);
876         if (currentAllowance != type(uint256).max) {
877             require(currentAllowance >= amount, "ERC20: insufficient allowance");
878             unchecked {
879                 _approve(owner, spender, currentAllowance - amount);
880             }
881         }
882     }
883 
884     /**
885      * @dev Hook that is called before any transfer of tokens. This includes
886      * minting and burning.
887      *
888      * Calling conditions:
889      *
890      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
891      * will be transferred to `to`.
892      * - when `from` is zero, `amount` tokens will be minted for `to`.
893      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
894      * - `from` and `to` are never both zero.
895      *
896      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
897      */
898     function _beforeTokenTransfer(
899         address from,
900         address to,
901         uint256 amount
902     ) internal virtual {}
903 
904     /**
905      * @dev Hook that is called after any transfer of tokens. This includes
906      * minting and burning.
907      *
908      * Calling conditions:
909      *
910      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
911      * has been transferred to `to`.
912      * - when `from` is zero, `amount` tokens have been minted for `to`.
913      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
914      * - `from` and `to` are never both zero.
915      *
916      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
917      */
918     function _afterTokenTransfer(
919         address from,
920         address to,
921         uint256 amount
922     ) internal virtual {}
923 }
924 
925 // File: NPC.sol
926 
927 
928 pragma solidity ^0.8.9;
929 
930 contract NPC is ERC20, ERC1155Holder, Ownable {
931     IERC1155 public erc1155Contract;
932     uint256 public erc1155TokenId;
933     uint256 public tokenSupply = 8050126520;
934 
935     constructor(address _erc1155Contract, uint256 _tokenId) ERC20("Non-Playable Coin", "NPC") {
936         erc1155Contract = IERC1155(_erc1155Contract);
937         erc1155TokenId = _tokenId;
938         _mint(address(this), tokenSupply * (10 ** 18));
939     }
940 
941     function Transform(uint256 amount) external {
942         require(amount >= 1, "Amount must be greater than 1");
943         
944         erc1155Contract.safeTransferFrom(msg.sender, address(this), erc1155TokenId, amount, "");
945 
946         _transfer(address(this), msg.sender, amount * (10 ** 18));
947 
948     }
949 
950     function Respawn(uint256 amount) external {
951         require(amount >= 1, "Amount must be greater than 1");
952 
953         _transfer(msg.sender, address(this), amount * (10 ** 18));
954 
955         erc1155Contract.safeTransferFrom(address(this), msg.sender, erc1155TokenId, amount, "");
956 
957     }
958 }