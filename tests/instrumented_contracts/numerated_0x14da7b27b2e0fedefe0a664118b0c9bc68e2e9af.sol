1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC165 standard, as defined in the
7  * https://eips.ethereum.org/EIPS/eip-165[EIP].
8  *
9  * Implementers can declare support of contract interfaces, which can then be
10  * queried by others ({ERC165Checker}).
11  *
12  * For an implementation, see {ERC165}.
13  */
14 interface IERC165 {
15     /**
16      * @dev Returns true if this contract implements the interface defined by
17      * `interfaceId`. See the corresponding
18      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
19      * to learn more about how these ids are created.
20      *
21      * This function call must use less than 30 000 gas.
22      */
23     function supportsInterface(bytes4 interfaceId) external view returns (bool);
24 }
25 
26 /**
27  * @dev Interface of the ERC20 standard as defined in the EIP.
28  */
29 interface IERC20 {
30     /**
31      * @dev Returns the amount of tokens in existence.
32      */
33     function totalSupply() external view returns (uint256);
34 
35     /**
36      * @dev Returns the amount of tokens owned by `account`.
37      */
38     function balanceOf(address account) external view returns (uint256);
39 
40     /**
41      * @dev Moves `amount` tokens from the caller's account to `recipient`.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * Emits a {Transfer} event.
46      */
47     function transfer(address recipient, uint256 amount) external returns (bool);
48 
49     /**
50      * @dev Returns the remaining number of tokens that `spender` will be
51      * allowed to spend on behalf of `owner` through {transferFrom}. This is
52      * zero by default.
53      *
54      * This value changes when {approve} or {transferFrom} are called.
55      */
56     function allowance(address owner, address spender) external view returns (uint256);
57 
58     /**
59      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * IMPORTANT: Beware that changing an allowance with this method brings the risk
64      * that someone may use both the old and the new allowance by unfortunate
65      * transaction ordering. One possible solution to mitigate this race
66      * condition is to first reduce the spender's allowance to 0 and set the
67      * desired value afterwards:
68      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
69      *
70      * Emits an {Approval} event.
71      */
72     function approve(address spender, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Moves `amount` tokens from `sender` to `recipient` using the
76      * allowance mechanism. `amount` is then deducted from the caller's
77      * allowance.
78      *
79      * Returns a boolean value indicating whether the operation succeeded.
80      *
81      * Emits a {Transfer} event.
82      */
83     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
84 
85     /**
86      * @dev Emitted when `value` tokens are moved from one account (`from`) to
87      * another (`to`).
88      *
89      * Note that `value` may be zero.
90      */
91     event Transfer(address indexed from, address indexed to, uint256 value);
92 
93     /**
94      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
95      * a call to {approve}. `value` is the new allowance.
96      */
97     event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 
100 /*
101  * @dev Provides information about the current execution context, including the
102  * sender of the transaction and its data. While these are generally available
103  * via msg.sender and msg.data, they should not be accessed in such a direct
104  * manner, since when dealing with GSN meta-transactions the account sending and
105  * paying for execution may not be the actual sender (as far as an application
106  * is concerned).
107  *
108  * This contract is only required for intermediate, library-like contracts.
109  */
110 abstract contract Context {
111     function _msgSender() internal view virtual returns (address) {
112         return msg.sender;
113     }
114 
115     function _msgData() internal view virtual returns (bytes calldata) {
116         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
117         return msg.data;
118     }
119 }
120 
121 /**
122  * @dev Implementation of the {IERC20} interface.
123  *
124  * This implementation is agnostic to the way tokens are created. This means
125  * that a supply mechanism has to be added in a derived contract using {_mint}.
126  * For a generic mechanism see {ERC20PresetMinterPauser}.
127  *
128  * TIP: For a detailed writeup see our guide
129  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
130  * to implement supply mechanisms].
131  *
132  * We have followed general OpenZeppelin guidelines: functions revert instead
133  * of returning `false` on failure. This behavior is nonetheless conventional
134  * and does not conflict with the expectations of ERC20 applications.
135  *
136  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
137  * This allows applications to reconstruct the allowance for all accounts just
138  * by listening to said events. Other implementations of the EIP may not emit
139  * these events, as it isn't required by the specification.
140  *
141  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
142  * functions have been added to mitigate the well-known issues around setting
143  * allowances. See {IERC20-approve}.
144  */
145 contract ERC20 is Context, IERC20 {
146     mapping (address => uint256) private _balances;
147 
148     mapping (address => mapping (address => uint256)) private _allowances;
149 
150     uint256 private _totalSupply;
151 
152     string private _name;
153     string private _symbol;
154 
155     /**
156      * @dev Sets the values for {name} and {symbol}.
157      *
158      * The default value of {decimals} is 18. To select a different value for
159      * {decimals} you should overload it.
160      *
161      * All three of these values are immutable: they can only be set once during
162      * construction.
163      */
164     constructor (string memory name_, string memory symbol_) {
165         _name = name_;
166         _symbol = symbol_;
167     }
168 
169     /**
170      * @dev Returns the name of the token.
171      */
172     function name() public view virtual returns (string memory) {
173         return _name;
174     }
175 
176     /**
177      * @dev Returns the symbol of the token, usually a shorter version of the
178      * name.
179      */
180     function symbol() public view virtual returns (string memory) {
181         return _symbol;
182     }
183 
184     /**
185      * @dev Returns the number of decimals used to get its user representation.
186      * For example, if `decimals` equals `2`, a balance of `505` tokens should
187      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
188      *
189      * Tokens usually opt for a value of 18, imitating the relationship between
190      * Ether and Wei. This is the value {ERC20} uses, unless this function is
191      * overloaded;
192      *
193      * NOTE: This information is only used for _display_ purposes: it in
194      * no way affects any of the arithmetic of the contract, including
195      * {IERC20-balanceOf} and {IERC20-transfer}.
196      */
197     function decimals() public view virtual returns (uint8) {
198         return 18;
199     }
200 
201     /**
202      * @dev See {IERC20-totalSupply}.
203      */
204     function totalSupply() public view virtual override returns (uint256) {
205         return _totalSupply;
206     }
207 
208     /**
209      * @dev See {IERC20-balanceOf}.
210      */
211     function balanceOf(address account) public view virtual override returns (uint256) {
212         return _balances[account];
213     }
214 
215     /**
216      * @dev See {IERC20-transfer}.
217      *
218      * Requirements:
219      *
220      * - `recipient` cannot be the zero address.
221      * - the caller must have a balance of at least `amount`.
222      */
223     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
224         _transfer(_msgSender(), recipient, amount);
225         return true;
226     }
227 
228     /**
229      * @dev See {IERC20-allowance}.
230      */
231     function allowance(address owner, address spender) public view virtual override returns (uint256) {
232         return _allowances[owner][spender];
233     }
234 
235     /**
236      * @dev See {IERC20-approve}.
237      *
238      * Requirements:
239      *
240      * - `spender` cannot be the zero address.
241      */
242     function approve(address spender, uint256 amount) public virtual override returns (bool) {
243         _approve(_msgSender(), spender, amount);
244         return true;
245     }
246 
247     /**
248      * @dev See {IERC20-transferFrom}.
249      *
250      * Emits an {Approval} event indicating the updated allowance. This is not
251      * required by the EIP. See the note at the beginning of {ERC20}.
252      *
253      * Requirements:
254      *
255      * - `sender` and `recipient` cannot be the zero address.
256      * - `sender` must have a balance of at least `amount`.
257      * - the caller must have allowance for ``sender``'s tokens of at least
258      * `amount`.
259      */
260     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
261         _transfer(sender, recipient, amount);
262 
263         uint256 currentAllowance = _allowances[sender][_msgSender()];
264         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
265         _approve(sender, _msgSender(), currentAllowance - amount);
266 
267         return true;
268     }
269 
270     /**
271      * @dev Atomically increases the allowance granted to `spender` by the caller.
272      *
273      * This is an alternative to {approve} that can be used as a mitigation for
274      * problems described in {IERC20-approve}.
275      *
276      * Emits an {Approval} event indicating the updated allowance.
277      *
278      * Requirements:
279      *
280      * - `spender` cannot be the zero address.
281      */
282     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
283         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
284         return true;
285     }
286 
287     /**
288      * @dev Atomically decreases the allowance granted to `spender` by the caller.
289      *
290      * This is an alternative to {approve} that can be used as a mitigation for
291      * problems described in {IERC20-approve}.
292      *
293      * Emits an {Approval} event indicating the updated allowance.
294      *
295      * Requirements:
296      *
297      * - `spender` cannot be the zero address.
298      * - `spender` must have allowance for the caller of at least
299      * `subtractedValue`.
300      */
301     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
302         uint256 currentAllowance = _allowances[_msgSender()][spender];
303         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
304         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
305 
306         return true;
307     }
308 
309     /**
310      * @dev Moves tokens `amount` from `sender` to `recipient`.
311      *
312      * This is internal function is equivalent to {transfer}, and can be used to
313      * e.g. implement automatic token fees, slashing mechanisms, etc.
314      *
315      * Emits a {Transfer} event.
316      *
317      * Requirements:
318      *
319      * - `sender` cannot be the zero address.
320      * - `recipient` cannot be the zero address.
321      * - `sender` must have a balance of at least `amount`.
322      */
323     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
324         require(sender != address(0), "ERC20: transfer from the zero address");
325         require(recipient != address(0), "ERC20: transfer to the zero address");
326 
327         _beforeTokenTransfer(sender, recipient, amount);
328 
329         uint256 senderBalance = _balances[sender];
330         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
331         _balances[sender] = senderBalance - amount;
332         _balances[recipient] += amount;
333 
334         emit Transfer(sender, recipient, amount);
335     }
336 
337     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
338      * the total supply.
339      *
340      * Emits a {Transfer} event with `from` set to the zero address.
341      *
342      * Requirements:
343      *
344      * - `to` cannot be the zero address.
345      */
346     function _mint(address account, uint256 amount) internal virtual {
347         require(account != address(0), "ERC20: mint to the zero address");
348 
349         _beforeTokenTransfer(address(0), account, amount);
350 
351         _totalSupply += amount;
352         _balances[account] += amount;
353         emit Transfer(address(0), account, amount);
354     }
355 
356     /**
357      * @dev Destroys `amount` tokens from `account`, reducing the
358      * total supply.
359      *
360      * Emits a {Transfer} event with `to` set to the zero address.
361      *
362      * Requirements:
363      *
364      * - `account` cannot be the zero address.
365      * - `account` must have at least `amount` tokens.
366      */
367     function _burn(address account, uint256 amount) internal virtual {
368         require(account != address(0), "ERC20: burn from the zero address");
369 
370         _beforeTokenTransfer(account, address(0), amount);
371 
372         uint256 accountBalance = _balances[account];
373         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
374         _balances[account] = accountBalance - amount;
375         _totalSupply -= amount;
376 
377         emit Transfer(account, address(0), amount);
378     }
379 
380     /**
381      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
382      *
383      * This internal function is equivalent to `approve`, and can be used to
384      * e.g. set automatic allowances for certain subsystems, etc.
385      *
386      * Emits an {Approval} event.
387      *
388      * Requirements:
389      *
390      * - `owner` cannot be the zero address.
391      * - `spender` cannot be the zero address.
392      */
393     function _approve(address owner, address spender, uint256 amount) internal virtual {
394         require(owner != address(0), "ERC20: approve from the zero address");
395         require(spender != address(0), "ERC20: approve to the zero address");
396 
397         _allowances[owner][spender] = amount;
398         emit Approval(owner, spender, amount);
399     }
400 
401     /**
402      * @dev Hook that is called before any transfer of tokens. This includes
403      * minting and burning.
404      *
405      * Calling conditions:
406      *
407      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
408      * will be to transferred to `to`.
409      * - when `from` is zero, `amount` tokens will be minted for `to`.
410      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
411      * - `from` and `to` are never both zero.
412      *
413      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
414      */
415     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
416 }
417 
418 interface IERC20Bulk  {
419     function transferBulk(address[] calldata to, uint[] calldata tokens) external;
420     function approveBulk(address[] calldata spender, uint[] calldata tokens) external;
421 }
422 
423 interface IERC223  {
424     function transfer(address _to, uint _value, bytes calldata _data) external returns (bool success);
425 }
426 
427 interface IERC827  {
428     function approveAndCall(address _spender, uint256 _value, bytes memory _data) external returns (bool);
429 }
430 
431 
432 // https://github.com/ethereum/EIPs/issues/223
433 interface TokenFallback {
434     function tokenFallback(address _from, uint _value, bytes calldata _data) external;
435 }
436 
437 // ----------------------------------------------------------------------------
438 // Contract function to receive approval and execute function in one call
439 //
440 
441 interface TokenRecipientInterface {
442     function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external;
443 }
444 
445 /**
446  * @dev Required interface of an ERC721 compliant contract.
447  */
448 interface IERC721 is IERC165 {
449     /**
450      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
451      */
452     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
453 
454     /**
455      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
456      */
457     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
458 
459     /**
460      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
461      */
462     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
463 
464     /**
465      * @dev Returns the number of tokens in ``owner``'s account.
466      */
467     function balanceOf(address owner) external view returns (uint256 balance);
468 
469     /**
470      * @dev Returns the owner of the `tokenId` token.
471      *
472      * Requirements:
473      *
474      * - `tokenId` must exist.
475      */
476     function ownerOf(uint256 tokenId) external view returns (address owner);
477 
478     /**
479      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
480      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
481      *
482      * Requirements:
483      *
484      * - `from` cannot be the zero address.
485      * - `to` cannot be the zero address.
486      * - `tokenId` token must exist and be owned by `from`.
487      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
488      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
489      *
490      * Emits a {Transfer} event.
491      */
492     function safeTransferFrom(address from, address to, uint256 tokenId) external;
493 
494     /**
495      * @dev Transfers `tokenId` token from `from` to `to`.
496      *
497      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
498      *
499      * Requirements:
500      *
501      * - `from` cannot be the zero address.
502      * - `to` cannot be the zero address.
503      * - `tokenId` token must be owned by `from`.
504      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
505      *
506      * Emits a {Transfer} event.
507      */
508     function transferFrom(address from, address to, uint256 tokenId) external;
509 
510     /**
511      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
512      * The approval is cleared when the token is transferred.
513      *
514      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
515      *
516      * Requirements:
517      *
518      * - The caller must own the token or be an approved operator.
519      * - `tokenId` must exist.
520      *
521      * Emits an {Approval} event.
522      */
523     function approve(address to, uint256 tokenId) external;
524 
525     /**
526      * @dev Returns the account approved for `tokenId` token.
527      *
528      * Requirements:
529      *
530      * - `tokenId` must exist.
531      */
532     function getApproved(uint256 tokenId) external view returns (address operator);
533 
534     /**
535      * @dev Approve or remove `operator` as an operator for the caller.
536      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
537      *
538      * Requirements:
539      *
540      * - The `operator` cannot be the caller.
541      *
542      * Emits an {ApprovalForAll} event.
543      */
544     function setApprovalForAll(address operator, bool _approved) external;
545 
546     /**
547      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
548      *
549      * See {setApprovalForAll}
550      */
551     function isApprovedForAll(address owner, address operator) external view returns (bool);
552 
553     /**
554       * @dev Safely transfers `tokenId` token from `from` to `to`.
555       *
556       * Requirements:
557       *
558       * - `from` cannot be the zero address.
559       * - `to` cannot be the zero address.
560       * - `tokenId` token must exist and be owned by `from`.
561       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
562       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
563       *
564       * Emits a {Transfer} event.
565       */
566     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
567 }
568 
569 /**
570  * @dev Required interface of an ERC1155 compliant contract, as defined in the
571  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
572  *
573  * _Available since v3.1._
574  */
575 interface IERC1155 is IERC165 {
576     /**
577      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
578      */
579     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
580 
581     /**
582      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
583      * transfers.
584      */
585     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
586 
587     /**
588      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
589      * `approved`.
590      */
591     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
592 
593     /**
594      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
595      *
596      * If an {URI} event was emitted for `id`, the standard
597      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
598      * returned by {IERC1155MetadataURI-uri}.
599      */
600     event URI(string value, uint256 indexed id);
601 
602     /**
603      * @dev Returns the amount of tokens of token type `id` owned by `account`.
604      *
605      * Requirements:
606      *
607      * - `account` cannot be the zero address.
608      */
609     function balanceOf(address account, uint256 id) external view returns (uint256);
610 
611     /**
612      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
613      *
614      * Requirements:
615      *
616      * - `accounts` and `ids` must have the same length.
617      */
618     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
619 
620     /**
621      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
622      *
623      * Emits an {ApprovalForAll} event.
624      *
625      * Requirements:
626      *
627      * - `operator` cannot be the caller.
628      */
629     function setApprovalForAll(address operator, bool approved) external;
630 
631     /**
632      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
633      *
634      * See {setApprovalForAll}.
635      */
636     function isApprovedForAll(address account, address operator) external view returns (bool);
637 
638     /**
639      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
640      *
641      * Emits a {TransferSingle} event.
642      *
643      * Requirements:
644      *
645      * - `to` cannot be the zero address.
646      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
647      * - `from` must have a balance of tokens of type `id` of at least `amount`.
648      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
649      * acceptance magic value.
650      */
651     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
652 
653     /**
654      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
655      *
656      * Emits a {TransferBatch} event.
657      *
658      * Requirements:
659      *
660      * - `ids` and `amounts` must have the same length.
661      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
662      * acceptance magic value.
663      */
664     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
665 }
666 
667 /**
668  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
669  *
670  * These functions can be used to verify that a message was signed by the holder
671  * of the private keys of a given address.
672  */
673 library ECDSA {
674     /**
675      * @dev Returns the address that signed a hashed message (`hash`) with
676      * `signature`. This address can then be used for verification purposes.
677      *
678      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
679      * this function rejects them by requiring the `s` value to be in the lower
680      * half order, and the `v` value to be either 27 or 28.
681      *
682      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
683      * verification to be secure: it is possible to craft signatures that
684      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
685      * this is by receiving a hash of the original message (which may otherwise
686      * be too long), and then calling {toEthSignedMessageHash} on it.
687      */
688     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
689         // Check the signature length
690         if (signature.length != 65) {
691             revert("ECDSA: invalid signature length");
692         }
693 
694         // Divide the signature in r, s and v variables
695         bytes32 r;
696         bytes32 s;
697         uint8 v;
698 
699         // ecrecover takes the signature parameters, and the only way to get them
700         // currently is to use assembly.
701         // solhint-disable-next-line no-inline-assembly
702         assembly {
703             r := mload(add(signature, 0x20))
704             s := mload(add(signature, 0x40))
705             v := byte(0, mload(add(signature, 0x60)))
706         }
707 
708         return recover(hash, v, r, s);
709     }
710 
711     /**
712      * @dev Overload of {ECDSA-recover-bytes32-bytes-} that receives the `v`,
713      * `r` and `s` signature fields separately.
714      */
715     function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
716         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
717         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
718         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
719         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
720         //
721         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
722         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
723         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
724         // these malleable signatures as well.
725         require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ECDSA: invalid signature 's' value");
726         require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
727 
728         // If the signature is valid (and not malleable), return the signer address
729         address signer = ecrecover(hash, v, r, s);
730         require(signer != address(0), "ECDSA: invalid signature");
731 
732         return signer;
733     }
734 
735     /**
736      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
737      * replicates the behavior of the
738      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
739      * JSON-RPC method.
740      *
741      * See {recover}.
742      */
743     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
744         // 32 is the length in bytes of hash,
745         // enforced by the type signature above
746         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
747     }
748 }
749 
750 
751 /**
752 * Access control holds contract signers (board members) and frozen accounts.
753 * Have utility modifiers for method safe access.
754 */
755 contract AccessControl {
756     // The addresses that can co-sign transactions on the wallet
757     mapping(address => bool) signers;
758 
759     // Frozen account that cant move funds
760     mapping (address => bool) private _frozen;
761 
762     event Frozen(address target);
763     event Unfrozen(address target);
764 
765     /**
766     * Set up multi-sig access by specifying the signers allowed to be used on this contract.
767     * 3 signers will be required to send a transaction from this wallet.
768     * Note: The sender is NOT automatically added to the list of signers.
769     *
770     * @param allowedSigners An array of signers on the wallet
771     */
772     constructor(address[] memory allowedSigners) {
773         require(allowedSigners.length == 5, "AccessControl: Invalid number of signers");
774 
775         for (uint8 i = 0; i < allowedSigners.length; i++) {
776             require(allowedSigners[i] != address(0), "AccessControl: Invalid signer address");
777             require(!signers[allowedSigners[i]], "AccessControl: Signer address duplication");
778             signers[allowedSigners[i]] = true;
779         }
780     }
781 
782     /**
783      * @dev Throws if called by any account other than the signer.
784      */
785     modifier onlySigner() {
786         require(signers[msg.sender], "AccessControl: Access denied");
787         _;
788     }
789 
790     /**
791      * @dev Checks if provided address has signer permissions.
792      */
793     function isSigner(address _addr) public view returns (bool) {
794         return signers[_addr];
795     }
796 
797     /**
798      * @dev Returns true if the target account is frozen.
799      */
800     function isFrozen(address target) public view returns (bool) {
801         return _frozen[target];
802     }
803 
804     function _freeze(address target) internal {
805         require(!_frozen[target], "AccessControl: Target account is already frozen");
806         _frozen[target] = true;
807         emit Frozen(target);
808     }
809 
810     /**
811      * @dev Mark target account as unfrozen.
812      * Can be called even if the contract doesn't allow to freeze accounts.
813      */
814     function _unfreeze(address target) internal {
815         require(_frozen[target], "AccessControl: Target account is not frozen");
816         delete _frozen[target];
817         emit Unfrozen(target);
818     }
819 
820     /**
821      * @dev Allow to withdraw ERC20 tokens from contract itself
822      */
823     function withdrawERC20(IERC20 _tokenContract) external onlySigner {
824         uint256 balance = _tokenContract.balanceOf(address(this));
825         _tokenContract.transfer(msg.sender, balance);
826     }
827 
828     /**
829      * @dev Allow to withdraw ERC721 tokens from contract itself
830      */
831     function approveERC721(IERC721 _tokenContract) external onlySigner {
832         _tokenContract.setApprovalForAll(msg.sender, true);
833     }
834 
835     /**
836      * @dev Allow to withdraw ERC1155 tokens from contract itself
837      */
838     function approveERC1155(IERC1155 _tokenContract) external onlySigner {
839         _tokenContract.setApprovalForAll(msg.sender, true);
840     }
841 
842     /**
843      * @dev Allow to withdraw ETH from contract itself
844      */
845     function withdrawEth(address payable _receiver) external onlySigner {
846         if (address(this).balance > 0) {
847             _receiver.transfer(address(this).balance);
848         }
849     }
850 }
851 
852 interface IFungibleToken is IERC20, IERC827, IERC223, IERC20Bulk {
853 }
854 
855 /**
856  * @dev Extension of {ERC20} that allows token holders to destroy both their own
857  * tokens and those that they have an allowance for, in a way that can be
858  * recognized off-chain (via event analysis).
859  */
860 abstract contract ERC20Burnable is Context, ERC20 {
861     /**
862      * @dev Destroys `amount` tokens from the caller.
863      *
864      * See {ERC20-_burn}.
865      */
866     function burn(uint256 amount) public virtual {
867         _burn(_msgSender(), amount);
868     }
869 
870     /**
871      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
872      * allowance.
873      *
874      * See {ERC20-_burn} and {ERC20-allowance}.
875      *
876      * Requirements:
877      *
878      * - the caller must have allowance for ``accounts``'s tokens of at least
879      * `amount`.
880      */
881     function burnFrom(address account, uint256 amount) public virtual {
882         uint256 currentAllowance = allowance(account, _msgSender());
883         require(currentAllowance >= amount, "BCUG: burn amount exceeds allowance");
884         _approve(account, _msgSender(), currentAllowance - amount);
885         _burn(account, amount);
886     }
887 }
888 
889 /**
890  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
891  */
892 abstract contract ERC20Capped is ERC20 {
893     uint256 private _cap;
894 
895     /**
896      * @dev Sets the value of the `cap`. This value is immutable, it can only be
897      * set once during construction.
898      */
899     constructor (uint256 cap_) {
900         require(cap_ > 0, "ERC20Capped: cap is 0");
901         _cap = cap_;
902     }
903 
904     /**
905      * @dev Returns the cap on the token's total supply.
906      */
907     function cap() public view virtual returns (uint256) {
908         return _cap;
909     }
910 
911     /**
912      * @dev See {ERC20-_beforeTokenTransfer}.
913      *
914      * Requirements:
915      *
916      * - minted tokens must not cause the total supply to go over the cap.
917      */
918     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
919         super._beforeTokenTransfer(from, to, amount);
920 
921         if (from == address(0)) { // When minting tokens
922             require(totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
923         }
924     }
925 }
926 
927 /**
928  * @dev Contract module which allows children to implement an emergency stop
929  * mechanism that can be triggered by an authorized account.
930  *
931  * This module is used through inheritance. It will make available the
932  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
933  * the functions of your contract. Note that they will not be pausable by
934  * simply including this module, only once the modifiers are put in place.
935  */
936 abstract contract Pausable is Context {
937     /**
938      * @dev Emitted when the pause is triggered by `account`.
939      */
940     event Paused(address account);
941 
942     /**
943      * @dev Emitted when the pause is lifted by `account`.
944      */
945     event Unpaused(address account);
946 
947     bool private _paused;
948 
949     /**
950      * @dev Initializes the contract in unpaused state.
951      */
952     constructor () {
953         _paused = false;
954     }
955 
956     /**
957      * @dev Returns true if the contract is paused, and false otherwise.
958      */
959     function paused() public view virtual returns (bool) {
960         return _paused;
961     }
962 
963     /**
964      * @dev Modifier to make a function callable only when the contract is not paused.
965      *
966      * Requirements:
967      *
968      * - The contract must not be paused.
969      */
970     modifier whenNotPaused() {
971         require(!paused(), "Pausable: paused");
972         _;
973     }
974 
975     /**
976      * @dev Modifier to make a function callable only when the contract is paused.
977      *
978      * Requirements:
979      *
980      * - The contract must be paused.
981      */
982     modifier whenPaused() {
983         require(paused(), "Pausable: not paused");
984         _;
985     }
986 
987     /**
988      * @dev Triggers stopped state.
989      *
990      * Requirements:
991      *
992      * - The contract must not be paused.
993      */
994     function _pause() internal virtual whenNotPaused {
995         _paused = true;
996         emit Paused(_msgSender());
997     }
998 
999     /**
1000      * @dev Returns to normal state.
1001      *
1002      * Requirements:
1003      *
1004      * - The contract must be paused.
1005      */
1006     function _unpause() internal virtual whenPaused {
1007         _paused = false;
1008         emit Unpaused(_msgSender());
1009     }
1010 }
1011 
1012 /**
1013  * Governance Token contract includes multisig protected actions.
1014  * It includes:
1015  * - minting methods
1016  * - freeze methods
1017  * - pause methods
1018  *
1019  * For each call must be provided valid signatures from contract signers (defined in AccessControl)
1020  * and the transaction itself must be sent from the signer address.
1021  * Every succeeded transaction will contain signer addresses for action proof in logs.
1022  *
1023  * It is possible to pause contract transfers in case an exchange is hacked and there is a risk for token holders to lose
1024  * their tokens, delegated to an exchange. After freezing suspicious accounts the contract can be unpaused.
1025  * Board members can burn tokens on frozen accounts to mint new tokens to holders as a recovery after a hacking attack.
1026 */
1027 abstract contract GovernanceToken is ERC20Capped, ERC20Burnable, IFungibleToken, AccessControl, Pausable {
1028     using ECDSA for bytes32;
1029 
1030     // keccak256("mint(address target, uint256 amount, bytes[] signatures)")
1031     bytes32 constant MINT_TYPEHASH = 0xdaef0006354e6aca5b14786fab16e27867b1ac002611e2fa58e0aa486080141f;
1032 
1033     // keccak256("mintBulk(address[] target, uint256[] amount, bytes[] signatures)")
1034     bytes32 constant MINT_BULK_TYPEHASH = 0x84bbfaa2e4384c51c0e71108356af77f996f8a1f97dc229b15ad088f887071c7;
1035 
1036     // keccak256("freeze/unfreeze(address target, bytes[] memory signatures)")
1037     bytes32 constant FREEZE_TYPEHASH = 0x0101de85040f7616ce3d91b0b3b5279925bff5ba3cbdc18c318483eec213aba5;
1038 
1039     // keccak256("freezeBulk/unfreezeBulk(address[] calldata target, bytes[] memory signatures)")
1040     bytes32 constant FREEZE_BULK_TYPEHASH = 0xfbe23759ad6142178865544766ded4220dd6951de831ca9f926f385026c83a2b;
1041 
1042     // keccak256("burnFrozenTokens(address target, bytes[] memory signatures)")
1043     bytes32 constant BURN_FROZEN_TYPEHASH = 0x642bcc36d46a724c301cb6a1e74f954db2da04e41cf92613260aa926b0cc663c;
1044 
1045     // keccak256("freezeAndBurnTokens(address target, bytes[] memory signatures)")
1046     bytes32 constant FREEZE_AND_BURN_TYPEHASH = 0xb17ffba690b680e166aba321cd5d08ac8256fa93afb6a8f0573d02ecbfa33e11;
1047 
1048     // keccak256("pause/unpause(bytes[] memory signatures)")
1049     bytes32 constant PAUSE_TYPEHASH = 0x4f10db4bd06c1a9ea1a64e78bc5c096dc4b14436b0cdf60a6252f82113e0a57e;
1050 
1051     uint public nonce = 0;
1052 
1053     event SignedBy(address signer);
1054 
1055     constructor (string memory name_, string memory symbol_, uint256 cap_, address[] memory allowedSigners)
1056         ERC20Capped(cap_)
1057         ERC20(name_, symbol_)
1058         AccessControl(allowedSigners) {}
1059 
1060     /**
1061      * @dev Mint some tokens to target account
1062      * MultiSig check is used - verifies that contract signers approve minting.
1063      * During minting applied check for the max token cap.
1064      */
1065     function mint(address target, uint256 amount, bytes[] memory signatures) external onlySigner {
1066         bytes32 operationHash = getOperationHash(MINT_TYPEHASH, target, amount).toEthSignedMessageHash();
1067         _verifySignatures(signatures, operationHash);
1068         _mint(target, amount);
1069     }
1070 
1071     /**
1072      * @dev Bulk operation to mint tokens to target accounts. There is a check for the cap inside.
1073      */
1074     function mintBulk(address[] calldata target, uint256[] calldata amount, bytes[] memory signatures) external onlySigner {
1075         require(target.length > 1, "GovernanceToken: cannot perform bulk with single target");
1076         require(target.length == amount.length, "GovernanceToken: target.length != amount.length");
1077 
1078         bytes32 operationHash = getOperationHash(MINT_BULK_TYPEHASH, target[0], target.length).toEthSignedMessageHash();
1079         _verifySignatures(signatures, operationHash);
1080 
1081         for (uint i = 0; i < target.length; i++) {
1082             _mint(target[i], amount[i]);
1083         }
1084     }
1085 
1086     /**
1087     * @dev Mark target account as frozen. Frozen accounts can't perform transfers.
1088     */
1089     function freeze(address target, bytes[] memory signatures) external onlySigner {
1090         bytes32 operationHash = getOperationHash(FREEZE_TYPEHASH, target, 1).toEthSignedMessageHash();
1091         _verifySignatures(signatures, operationHash);
1092 
1093         _freeze(target);
1094     }
1095 
1096     /**
1097      * @dev Mark target account as unfrozen.
1098      */
1099     function unfreeze(address target, bytes[] memory signatures) external onlySigner {
1100         bytes32 operationHash = getOperationHash(FREEZE_TYPEHASH, target, 1).toEthSignedMessageHash();
1101         _verifySignatures(signatures, operationHash);
1102 
1103         _unfreeze(target);
1104     }
1105 
1106     function freezeBulk(address[] calldata target, bytes[] memory signatures) external onlySigner {
1107         require(target.length > 1, "GovernanceToken: cannot perform bulk with single target");
1108 
1109         bytes32 operationHash = getOperationHash(FREEZE_BULK_TYPEHASH, target[0], target.length).toEthSignedMessageHash();
1110         _verifySignatures(signatures, operationHash);
1111 
1112         for (uint i = 0; i < target.length; i++) {
1113             _freeze(target[i]);
1114         }
1115     }
1116 
1117     function unfreezeBulk(address[] calldata target, bytes[] memory signatures) external onlySigner {
1118         require(target.length > 1, "GovernanceToken: cannot perform bulk with single target");
1119 
1120         bytes32 operationHash = getOperationHash(FREEZE_BULK_TYPEHASH, target[0], target.length).toEthSignedMessageHash();
1121         _verifySignatures(signatures, operationHash);
1122 
1123         for (uint i = 0; i < target.length; i++) {
1124             _unfreeze(target[i]);
1125         }
1126     }
1127 
1128     /**
1129      * @dev Burn tokens on frozen account.
1130      */
1131     function burnFrozenTokens(address target, bytes[] memory signatures) external onlySigner {
1132         require(isFrozen(target), "GovernanceToken: target account is not frozen");
1133 
1134         bytes32 operationHash = getOperationHash(BURN_FROZEN_TYPEHASH, target, 1).toEthSignedMessageHash();
1135         _verifySignatures(signatures, operationHash);
1136 
1137         _burn(target, balanceOf(target));
1138     }
1139 
1140     /**
1141      * @dev Freeze and burn tokens in a single transaction.
1142      */
1143     function freezeAndBurnTokens(address target, bytes[] memory signatures) external onlySigner {
1144         bytes32 operationHash = getOperationHash(FREEZE_AND_BURN_TYPEHASH, target, 1).toEthSignedMessageHash();
1145         _verifySignatures(signatures, operationHash);
1146 
1147         _freeze(target);
1148         _burn(target, balanceOf(target));
1149     }
1150 
1151     /**
1152      * @dev Triggers stopped state.
1153      * - The contract must not be paused and pause should be allowed.
1154      */
1155     function pause(bytes[] memory signatures) external onlySigner {
1156         bytes32 operationHash = getOperationHash(PAUSE_TYPEHASH, msg.sender, 1).toEthSignedMessageHash();
1157         _verifySignatures(signatures, operationHash);
1158 
1159         _pause();
1160     }
1161 
1162     /**
1163      * @dev Returns to normal state.
1164      * - The contract must be paused.
1165      */
1166     function unpause(bytes[] memory signatures) external onlySigner {
1167         bytes32 operationHash = getOperationHash(PAUSE_TYPEHASH, msg.sender, 1).toEthSignedMessageHash();
1168         _verifySignatures(signatures, operationHash);
1169 
1170         _unpause();
1171     }
1172 
1173     /**
1174     * @dev Get operation hash for multisig operation
1175     * Nonce used to ensure that signature used only once.
1176     * Use unique typehash for each operation.
1177     */
1178     function getOperationHash(bytes32 typehash, address target, uint256 value) public view returns (bytes32) {
1179         return keccak256(abi.encodePacked(address(this), typehash, target, value, nonce));
1180     }
1181 
1182     /**
1183      * @dev See {ERC20-_beforeTokenTransfer}.
1184      *
1185      * Requirements:
1186      *
1187      * - do not allow the transfer of funds to the token contract itself. Usually such a call is a mistake.
1188      * - do not allow transfers when contract is paused.
1189      * - only allow to burn frozen tokens.
1190      */
1191     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20Capped, ERC20) {
1192         super._beforeTokenTransfer(from, to, amount);
1193 
1194         require(to != address(this), "GovernanceToken: can't transfer to token contract self");
1195         require(!paused(), "GovernanceToken: token transfer while paused");
1196         require(!isFrozen(from) || to == address(0x0), "GovernanceToken: source address was frozen");
1197     }
1198 
1199     /**
1200      * @dev Verify provided signatures according to the operation hash
1201      * Ensure that each signature belongs to contract known signer and is unique
1202      */
1203     function _verifySignatures(bytes[] memory signatures, bytes32 operationHash) internal {
1204         require(signatures.length >= 2, "AccessControl: not enough confirmations");
1205 
1206         address[] memory recovered = new address[](signatures.length + 1);
1207         recovered[0] = msg.sender;
1208         emit SignedBy(msg.sender);
1209 
1210         for (uint i = 0; i < signatures.length; i++) {
1211             address addr = operationHash.recover(signatures[i]);
1212             require(isSigner(addr), "AccessControl: recovered address is not signer");
1213 
1214             for (uint j = 0; j < recovered.length; j++) {
1215                 require(recovered[j] != addr, "AccessControl: signer address used more than once");
1216             }
1217 
1218             recovered[i + 1] = addr;
1219             emit SignedBy(addr);
1220         }
1221 
1222         require(recovered.length >= 3, "AccessControl: not enough confirmations");
1223 
1224         nonce++;
1225     }
1226 }
1227 
1228 /**
1229  * @title Blockchain Cuties Universe fungible token base contract
1230  * @dev Implementation of the {IERC20}, {IERC827} and {IERC223} interfaces.
1231  * Token holders can burn their tokens.
1232  *
1233  * We have followed general OpenZeppelin guidelines: functions revert instead
1234  * of returning `false` on failure. This behavior is nonetheless conventional
1235  * and does not conflict with the expectations of ERC20 applications.
1236  *
1237  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1238  * This allows applications to reconstruct the allowance for all accounts just
1239  * by listening to said events. Other implementations of the EIP may not emit
1240  * these events, as it isn't required by the specification.
1241  *
1242  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1243  * functions have been added to mitigate the well-known issues around setting
1244  * allowances. See {IERC20-approve}.
1245  */
1246 contract BCUG is GovernanceToken {
1247 
1248     constructor (address[] memory allowedSigners) GovernanceToken("Blockchain Cuties Universe Governance Token", "BCUG", 10000000 ether, allowedSigners) {}
1249 
1250     // @dev Transfers to _withdrawToAddress all tokens controlled by
1251     // contract _tokenContract.
1252     function withdrawTokenFromBalance(IERC20 _tokenContract, address _withdrawToAddress) external onlySigner {
1253         uint256 balance = _tokenContract.balanceOf(address(this));
1254         _tokenContract.transfer(_withdrawToAddress, balance);
1255     }
1256 
1257 
1258     // ---------------------------- ERC827 approveAndCall ----------------------------
1259 
1260 
1261     // ------------------------------------------------------------------------
1262     // Token owner can approve for `spender` to transferFrom(...) `tokens`
1263     // from the token owner's account. The `spender` contract function
1264     // `receiveApproval(...)` is then executed
1265     // ------------------------------------------------------------------------
1266     function approveAndCall(address spender, uint tokens, bytes calldata data) external override returns (bool success) {
1267         _approve(msg.sender, spender, tokens);
1268         TokenRecipientInterface(spender).receiveApproval(msg.sender, tokens, address(this), data);
1269         return true;
1270     }
1271 
1272     // ---------------------------- ERC20 Bulk Operations ----------------------------
1273 
1274     function transferBulk(address[] calldata to, uint[] calldata tokens) external override {
1275         require(to.length == tokens.length, "transferBulk: to.length != tokens.length");
1276         for (uint i = 0; i < to.length; i++)
1277         {
1278             _transfer(msg.sender, to[i], tokens[i]);
1279         }
1280     }
1281 
1282     function approveBulk(address[] calldata spender, uint[] calldata tokens) external override {
1283         require(spender.length == tokens.length, "approveBulk: spender.length != tokens.length");
1284         for (uint i = 0; i < spender.length; i++)
1285         {
1286             _approve(msg.sender, spender[i], tokens[i]);
1287         }
1288     }
1289 
1290     // ---------------------------- ERC223 ----------------------------
1291     event Transfer(address indexed from, address indexed to, uint256 value, bytes data);
1292 
1293     // Function that is called when a user or another contract wants to transfer funds .
1294     function transfer(address _to, uint _value, bytes calldata _data) external override returns (bool success) {
1295         return transferWithData(_to, _value, _data);
1296     }
1297 
1298     function transferWithData(address _to, uint _value, bytes calldata _data) public returns (bool success) {
1299         if (_isContract(_to)) {
1300             return transferToContract(_to, _value, _data);
1301         }
1302         else {
1303             return transferToAddress(_to, _value, _data);
1304         }
1305     }
1306 
1307     // function that is called when transaction target is a contract
1308     function transferToContract(address _to, uint _value, bytes calldata _data) public returns (bool success) {
1309         _transfer(msg.sender, _to, _value);
1310         emit Transfer(msg.sender, _to, _value, _data);
1311         TokenFallback receiver = TokenFallback(_to);
1312         receiver.tokenFallback(msg.sender, _value, _data);
1313         return true;
1314     }
1315 
1316     // assemble the given address bytecode. If bytecode exists then the _addr is a contract.
1317     function _isContract(address _addr) private view returns (bool is_contract) {
1318         uint length;
1319         assembly {
1320         //retrieve the size of the code on target address, this needs assembly
1321             length := extcodesize(_addr)
1322         }
1323         return length > 0;
1324     }
1325 
1326     // function that is called when transaction target is an address
1327     function transferToAddress(address _to, uint tokens, bytes calldata _data) public returns (bool success) {
1328         _transfer(msg.sender, _to, tokens);
1329         emit Transfer(msg.sender, _to, tokens, _data);
1330         return true;
1331     }
1332 }