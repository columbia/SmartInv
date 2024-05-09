1 // SPDX-FileCopyrightText: 2022 ISKRA Pte. Ltd.
2 // SPDX-License-Identifier: MIT
3 // @author iskra.world dev team
4 
5 // Sources flattened with hardhat v2.8.4 https://hardhat.org
6 
7 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.4.2
8 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev Interface of the ERC20 standard as defined in the EIP.
14  */
15 interface IERC20 {
16     /**
17      * @dev Returns the amount of tokens in existence.
18      */
19     function totalSupply() external view returns (uint256);
20 
21     /**
22      * @dev Returns the amount of tokens owned by `account`.
23      */
24     function balanceOf(address account) external view returns (uint256);
25 
26     /**
27      * @dev Moves `amount` tokens from the caller's account to `recipient`.
28      *
29      * Returns a boolean value indicating whether the operation succeeded.
30      *
31      * Emits a {Transfer} event.
32      */
33     function transfer(address recipient, uint256 amount) external returns (bool);
34 
35     /**
36      * @dev Returns the remaining number of tokens that `spender` will be
37      * allowed to spend on behalf of `owner` through {transferFrom}. This is
38      * zero by default.
39      *
40      * This value changes when {approve} or {transferFrom} are called.
41      */
42     function allowance(address owner, address spender) external view returns (uint256);
43 
44     /**
45      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * IMPORTANT: Beware that changing an allowance with this method brings the risk
50      * that someone may use both the old and the new allowance by unfortunate
51      * transaction ordering. One possible solution to mitigate this race
52      * condition is to first reduce the spender's allowance to 0 and set the
53      * desired value afterwards:
54      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
55      *
56      * Emits an {Approval} event.
57      */
58     function approve(address spender, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Moves `amount` tokens from `sender` to `recipient` using the
62      * allowance mechanism. `amount` is then deducted from the caller's
63      * allowance.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * Emits a {Transfer} event.
68      */
69     function transferFrom(
70         address sender,
71         address recipient,
72         uint256 amount
73     ) external returns (bool);
74 
75     /**
76      * @dev Emitted when `value` tokens are moved from one account (`from`) to
77      * another (`to`).
78      *
79      * Note that `value` may be zero.
80      */
81     event Transfer(address indexed from, address indexed to, uint256 value);
82 
83     /**
84      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
85      * a call to {approve}. `value` is the new allowance.
86      */
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 
91 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.2
92 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
93 
94 pragma solidity ^0.8.0;
95 
96 /**
97  * @dev Interface of the ERC165 standard, as defined in the
98  * https://eips.ethereum.org/EIPS/eip-165[EIP].
99  *
100  * Implementers can declare support of contract interfaces, which can then be
101  * queried by others ({ERC165Checker}).
102  *
103  * For an implementation, see {ERC165}.
104  */
105 interface IERC165 {
106     /**
107      * @dev Returns true if this contract implements the interface defined by
108      * `interfaceId`. See the corresponding
109      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
110      * to learn more about how these ids are created.
111      *
112      * This function call must use less than 30 000 gas.
113      */
114     function supportsInterface(bytes4 interfaceId) external view returns (bool);
115 }
116 
117 
118 // File @openzeppelin/contracts/interfaces/IERC1363.sol@v4.4.2
119 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC1363.sol)
120 
121 pragma solidity ^0.8.0;
122 
123 interface IERC1363 is IERC165, IERC20 {
124     /*
125      * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
126      * 0x4bbee2df ===
127      *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
128      *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
129      *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
130      *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
131      */
132 
133     /*
134      * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
135      * 0xfb9ec8ce ===
136      *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
137      *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
138      */
139 
140     /**
141      * @dev Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
142      * @param to address The address which you want to transfer to
143      * @param value uint256 The amount of tokens to be transferred
144      * @return true unless throwing
145      */
146     function transferAndCall(address to, uint256 value) external returns (bool);
147 
148     /**
149      * @dev Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
150      * @param to address The address which you want to transfer to
151      * @param value uint256 The amount of tokens to be transferred
152      * @param data bytes Additional data with no specified format, sent in call to `to`
153      * @return true unless throwing
154      */
155     function transferAndCall(
156         address to,
157         uint256 value,
158         bytes memory data
159     ) external returns (bool);
160 
161     /**
162      * @dev Transfer tokens from one address to another and then call `onTransferReceived` on receiver
163      * @param from address The address which you want to send tokens from
164      * @param to address The address which you want to transfer to
165      * @param value uint256 The amount of tokens to be transferred
166      * @return true unless throwing
167      */
168     function transferFromAndCall(
169         address from,
170         address to,
171         uint256 value
172     ) external returns (bool);
173 
174     /**
175      * @dev Transfer tokens from one address to another and then call `onTransferReceived` on receiver
176      * @param from address The address which you want to send tokens from
177      * @param to address The address which you want to transfer to
178      * @param value uint256 The amount of tokens to be transferred
179      * @param data bytes Additional data with no specified format, sent in call to `to`
180      * @return true unless throwing
181      */
182     function transferFromAndCall(
183         address from,
184         address to,
185         uint256 value,
186         bytes memory data
187     ) external returns (bool);
188 
189     /**
190      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
191      * and then call `onApprovalReceived` on spender.
192      * @param spender address The address which will spend the funds
193      * @param value uint256 The amount of tokens to be spent
194      */
195     function approveAndCall(address spender, uint256 value) external returns (bool);
196 
197     /**
198      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
199      * and then call `onApprovalReceived` on spender.
200      * @param spender address The address which will spend the funds
201      * @param value uint256 The amount of tokens to be spent
202      * @param data bytes Additional data with no specified format, sent in call to `spender`
203      */
204     function approveAndCall(
205         address spender,
206         uint256 value,
207         bytes memory data
208     ) external returns (bool);
209 }
210 
211 
212 // File @openzeppelin/contracts/interfaces/IERC1363Receiver.sol@v4.4.2
213 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC1363Receiver.sol)
214 
215 pragma solidity ^0.8.0;
216 
217 interface IERC1363Receiver {
218     /*
219      * Note: the ERC-165 identifier for this interface is 0x88a7ca5c.
220      * 0x88a7ca5c === bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))
221      */
222 
223     /**
224      * @notice Handle the receipt of ERC1363 tokens
225      * @dev Any ERC1363 smart contract calls this function on the recipient
226      * after a `transfer` or a `transferFrom`. This function MAY throw to revert and reject the
227      * transfer. Return of other than the magic value MUST result in the
228      * transaction being reverted.
229      * Note: the token contract address is always the message sender.
230      * @param operator address The address which called `transferAndCall` or `transferFromAndCall` function
231      * @param from address The address which are token transferred from
232      * @param value uint256 The amount of tokens transferred
233      * @param data bytes Additional data with no specified format
234      * @return `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
235      *  unless throwing
236      */
237     function onTransferReceived(
238         address operator,
239         address from,
240         uint256 value,
241         bytes memory data
242     ) external returns (bytes4);
243 }
244 
245 
246 // File @openzeppelin/contracts/interfaces/IERC1363Spender.sol@v4.4.2
247 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC1363Spender.sol)
248 
249 pragma solidity ^0.8.0;
250 
251 interface IERC1363Spender {
252     /*
253      * Note: the ERC-165 identifier for this interface is 0x7b04a2d0.
254      * 0x7b04a2d0 === bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))
255      */
256 
257     /**
258      * @notice Handle the approval of ERC1363 tokens
259      * @dev Any ERC1363 smart contract calls this function on the recipient
260      * after an `approve`. This function MAY throw to revert and reject the
261      * approval. Return of other than the magic value MUST result in the
262      * transaction being reverted.
263      * Note: the token contract address is always the message sender.
264      * @param owner address The address which called `approveAndCall` function
265      * @param value uint256 The amount of tokens to be spent
266      * @param data bytes Additional data with no specified format
267      * @return `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
268      *  unless throwing
269      */
270     function onApprovalReceived(
271         address owner,
272         uint256 value,
273         bytes memory data
274     ) external returns (bytes4);
275 }
276 
277 
278 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.4.2
279 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
280 
281 pragma solidity ^0.8.0;
282 
283 /**
284  * @dev Interface for the optional metadata functions from the ERC20 standard.
285  *
286  * _Available since v4.1._
287  */
288 interface IERC20Metadata is IERC20 {
289     /**
290      * @dev Returns the name of the token.
291      */
292     function name() external view returns (string memory);
293 
294     /**
295      * @dev Returns the symbol of the token.
296      */
297     function symbol() external view returns (string memory);
298 
299     /**
300      * @dev Returns the decimals places of the token.
301      */
302     function decimals() external view returns (uint8);
303 }
304 
305 
306 // File @openzeppelin/contracts/utils/Context.sol@v4.4.2
307 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
308 
309 pragma solidity ^0.8.0;
310 
311 /**
312  * @dev Provides information about the current execution context, including the
313  * sender of the transaction and its data. While these are generally available
314  * via msg.sender and msg.data, they should not be accessed in such a direct
315  * manner, since when dealing with meta-transactions the account sending and
316  * paying for execution may not be the actual sender (as far as an application
317  * is concerned).
318  *
319  * This contract is only required for intermediate, library-like contracts.
320  */
321 abstract contract Context {
322     function _msgSender() internal view virtual returns (address) {
323         return msg.sender;
324     }
325 
326     function _msgData() internal view virtual returns (bytes calldata) {
327         return msg.data;
328     }
329 }
330 
331 
332 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.4.2
333 // OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)
334 
335 pragma solidity ^0.8.0;
336 
337 /**
338  * @dev Implementation of the {IERC20} interface.
339  *
340  * This implementation is agnostic to the way tokens are created. This means
341  * that a supply mechanism has to be added in a derived contract using {_mint}.
342  * For a generic mechanism see {ERC20PresetMinterPauser}.
343  *
344  * TIP: For a detailed writeup see our guide
345  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
346  * to implement supply mechanisms].
347  *
348  * We have followed general OpenZeppelin Contracts guidelines: functions revert
349  * instead returning `false` on failure. This behavior is nonetheless
350  * conventional and does not conflict with the expectations of ERC20
351  * applications.
352  *
353  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
354  * This allows applications to reconstruct the allowance for all accounts just
355  * by listening to said events. Other implementations of the EIP may not emit
356  * these events, as it isn't required by the specification.
357  *
358  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
359  * functions have been added to mitigate the well-known issues around setting
360  * allowances. See {IERC20-approve}.
361  */
362 contract ERC20 is Context, IERC20, IERC20Metadata {
363     mapping(address => uint256) private _balances;
364 
365     mapping(address => mapping(address => uint256)) private _allowances;
366 
367     uint256 private _totalSupply;
368 
369     string private _name;
370     string private _symbol;
371 
372     /**
373      * @dev Sets the values for {name} and {symbol}.
374      *
375      * The default value of {decimals} is 18. To select a different value for
376      * {decimals} you should overload it.
377      *
378      * All two of these values are immutable: they can only be set once during
379      * construction.
380      */
381     constructor(string memory name_, string memory symbol_) {
382         _name = name_;
383         _symbol = symbol_;
384     }
385 
386     /**
387      * @dev Returns the name of the token.
388      */
389     function name() public view virtual override returns (string memory) {
390         return _name;
391     }
392 
393     /**
394      * @dev Returns the symbol of the token, usually a shorter version of the
395      * name.
396      */
397     function symbol() public view virtual override returns (string memory) {
398         return _symbol;
399     }
400 
401     /**
402      * @dev Returns the number of decimals used to get its user representation.
403      * For example, if `decimals` equals `2`, a balance of `505` tokens should
404      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
405      *
406      * Tokens usually opt for a value of 18, imitating the relationship between
407      * Ether and Wei. This is the value {ERC20} uses, unless this function is
408      * overridden;
409      *
410      * NOTE: This information is only used for _display_ purposes: it in
411      * no way affects any of the arithmetic of the contract, including
412      * {IERC20-balanceOf} and {IERC20-transfer}.
413      */
414     function decimals() public view virtual override returns (uint8) {
415         return 18;
416     }
417 
418     /**
419      * @dev See {IERC20-totalSupply}.
420      */
421     function totalSupply() public view virtual override returns (uint256) {
422         return _totalSupply;
423     }
424 
425     /**
426      * @dev See {IERC20-balanceOf}.
427      */
428     function balanceOf(address account) public view virtual override returns (uint256) {
429         return _balances[account];
430     }
431 
432     /**
433      * @dev See {IERC20-transfer}.
434      *
435      * Requirements:
436      *
437      * - `recipient` cannot be the zero address.
438      * - the caller must have a balance of at least `amount`.
439      */
440     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
441         _transfer(_msgSender(), recipient, amount);
442         return true;
443     }
444 
445     /**
446      * @dev See {IERC20-allowance}.
447      */
448     function allowance(address owner, address spender) public view virtual override returns (uint256) {
449         return _allowances[owner][spender];
450     }
451 
452     /**
453      * @dev See {IERC20-approve}.
454      *
455      * Requirements:
456      *
457      * - `spender` cannot be the zero address.
458      */
459     function approve(address spender, uint256 amount) public virtual override returns (bool) {
460         _approve(_msgSender(), spender, amount);
461         return true;
462     }
463 
464     /**
465      * @dev See {IERC20-transferFrom}.
466      *
467      * Emits an {Approval} event indicating the updated allowance. This is not
468      * required by the EIP. See the note at the beginning of {ERC20}.
469      *
470      * Requirements:
471      *
472      * - `sender` and `recipient` cannot be the zero address.
473      * - `sender` must have a balance of at least `amount`.
474      * - the caller must have allowance for ``sender``'s tokens of at least
475      * `amount`.
476      */
477     function transferFrom(
478         address sender,
479         address recipient,
480         uint256 amount
481     ) public virtual override returns (bool) {
482         _transfer(sender, recipient, amount);
483 
484         uint256 currentAllowance = _allowances[sender][_msgSender()];
485         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
486         unchecked {
487             _approve(sender, _msgSender(), currentAllowance - amount);
488         }
489 
490         return true;
491     }
492 
493     /**
494      * @dev Atomically increases the allowance granted to `spender` by the caller.
495      *
496      * This is an alternative to {approve} that can be used as a mitigation for
497      * problems described in {IERC20-approve}.
498      *
499      * Emits an {Approval} event indicating the updated allowance.
500      *
501      * Requirements:
502      *
503      * - `spender` cannot be the zero address.
504      */
505     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
506         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
507         return true;
508     }
509 
510     /**
511      * @dev Atomically decreases the allowance granted to `spender` by the caller.
512      *
513      * This is an alternative to {approve} that can be used as a mitigation for
514      * problems described in {IERC20-approve}.
515      *
516      * Emits an {Approval} event indicating the updated allowance.
517      *
518      * Requirements:
519      *
520      * - `spender` cannot be the zero address.
521      * - `spender` must have allowance for the caller of at least
522      * `subtractedValue`.
523      */
524     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
525         uint256 currentAllowance = _allowances[_msgSender()][spender];
526         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
527         unchecked {
528             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
529         }
530 
531         return true;
532     }
533 
534     /**
535      * @dev Moves `amount` of tokens from `sender` to `recipient`.
536      *
537      * This internal function is equivalent to {transfer}, and can be used to
538      * e.g. implement automatic token fees, slashing mechanisms, etc.
539      *
540      * Emits a {Transfer} event.
541      *
542      * Requirements:
543      *
544      * - `sender` cannot be the zero address.
545      * - `recipient` cannot be the zero address.
546      * - `sender` must have a balance of at least `amount`.
547      */
548     function _transfer(
549         address sender,
550         address recipient,
551         uint256 amount
552     ) internal virtual {
553         require(sender != address(0), "ERC20: transfer from the zero address");
554         require(recipient != address(0), "ERC20: transfer to the zero address");
555 
556         _beforeTokenTransfer(sender, recipient, amount);
557 
558         uint256 senderBalance = _balances[sender];
559         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
560         unchecked {
561             _balances[sender] = senderBalance - amount;
562         }
563         _balances[recipient] += amount;
564 
565         emit Transfer(sender, recipient, amount);
566 
567         _afterTokenTransfer(sender, recipient, amount);
568     }
569 
570     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
571      * the total supply.
572      *
573      * Emits a {Transfer} event with `from` set to the zero address.
574      *
575      * Requirements:
576      *
577      * - `account` cannot be the zero address.
578      */
579     function _mint(address account, uint256 amount) internal virtual {
580         require(account != address(0), "ERC20: mint to the zero address");
581 
582         _beforeTokenTransfer(address(0), account, amount);
583 
584         _totalSupply += amount;
585         _balances[account] += amount;
586         emit Transfer(address(0), account, amount);
587 
588         _afterTokenTransfer(address(0), account, amount);
589     }
590 
591     /**
592      * @dev Destroys `amount` tokens from `account`, reducing the
593      * total supply.
594      *
595      * Emits a {Transfer} event with `to` set to the zero address.
596      *
597      * Requirements:
598      *
599      * - `account` cannot be the zero address.
600      * - `account` must have at least `amount` tokens.
601      */
602     function _burn(address account, uint256 amount) internal virtual {
603         require(account != address(0), "ERC20: burn from the zero address");
604 
605         _beforeTokenTransfer(account, address(0), amount);
606 
607         uint256 accountBalance = _balances[account];
608         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
609         unchecked {
610             _balances[account] = accountBalance - amount;
611         }
612         _totalSupply -= amount;
613 
614         emit Transfer(account, address(0), amount);
615 
616         _afterTokenTransfer(account, address(0), amount);
617     }
618 
619     /**
620      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
621      *
622      * This internal function is equivalent to `approve`, and can be used to
623      * e.g. set automatic allowances for certain subsystems, etc.
624      *
625      * Emits an {Approval} event.
626      *
627      * Requirements:
628      *
629      * - `owner` cannot be the zero address.
630      * - `spender` cannot be the zero address.
631      */
632     function _approve(
633         address owner,
634         address spender,
635         uint256 amount
636     ) internal virtual {
637         require(owner != address(0), "ERC20: approve from the zero address");
638         require(spender != address(0), "ERC20: approve to the zero address");
639 
640         _allowances[owner][spender] = amount;
641         emit Approval(owner, spender, amount);
642     }
643 
644     /**
645      * @dev Hook that is called before any transfer of tokens. This includes
646      * minting and burning.
647      *
648      * Calling conditions:
649      *
650      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
651      * will be transferred to `to`.
652      * - when `from` is zero, `amount` tokens will be minted for `to`.
653      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
654      * - `from` and `to` are never both zero.
655      *
656      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
657      */
658     function _beforeTokenTransfer(
659         address from,
660         address to,
661         uint256 amount
662     ) internal virtual {}
663 
664     /**
665      * @dev Hook that is called after any transfer of tokens. This includes
666      * minting and burning.
667      *
668      * Calling conditions:
669      *
670      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
671      * has been transferred to `to`.
672      * - when `from` is zero, `amount` tokens have been minted for `to`.
673      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
674      * - `from` and `to` are never both zero.
675      *
676      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
677      */
678     function _afterTokenTransfer(
679         address from,
680         address to,
681         uint256 amount
682     ) internal virtual {}
683 }
684 
685 
686 // File @openzeppelin/contracts/utils/Address.sol@v4.4.2
687 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
688 
689 pragma solidity ^0.8.0;
690 
691 /**
692  * @dev Collection of functions related to the address type
693  */
694 library Address {
695     /**
696      * @dev Returns true if `account` is a contract.
697      *
698      * [IMPORTANT]
699      * ====
700      * It is unsafe to assume that an address for which this function returns
701      * false is an externally-owned account (EOA) and not a contract.
702      *
703      * Among others, `isContract` will return false for the following
704      * types of addresses:
705      *
706      *  - an externally-owned account
707      *  - a contract in construction
708      *  - an address where a contract will be created
709      *  - an address where a contract lived, but was destroyed
710      * ====
711      */
712     function isContract(address account) internal view returns (bool) {
713         // This method relies on extcodesize, which returns 0 for contracts in
714         // construction, since the code is only stored at the end of the
715         // constructor execution.
716 
717         uint256 size;
718         assembly {
719             size := extcodesize(account)
720         }
721         return size > 0;
722     }
723 
724     /**
725      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
726      * `recipient`, forwarding all available gas and reverting on errors.
727      *
728      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
729      * of certain opcodes, possibly making contracts go over the 2300 gas limit
730      * imposed by `transfer`, making them unable to receive funds via
731      * `transfer`. {sendValue} removes this limitation.
732      *
733      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
734      *
735      * IMPORTANT: because control is transferred to `recipient`, care must be
736      * taken to not create reentrancy vulnerabilities. Consider using
737      * {ReentrancyGuard} or the
738      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
739      */
740     function sendValue(address payable recipient, uint256 amount) internal {
741         require(address(this).balance >= amount, "Address: insufficient balance");
742 
743         (bool success, ) = recipient.call{value: amount}("");
744         require(success, "Address: unable to send value, recipient may have reverted");
745     }
746 
747     /**
748      * @dev Performs a Solidity function call using a low level `call`. A
749      * plain `call` is an unsafe replacement for a function call: use this
750      * function instead.
751      *
752      * If `target` reverts with a revert reason, it is bubbled up by this
753      * function (like regular Solidity function calls).
754      *
755      * Returns the raw returned data. To convert to the expected return value,
756      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
757      *
758      * Requirements:
759      *
760      * - `target` must be a contract.
761      * - calling `target` with `data` must not revert.
762      *
763      * _Available since v3.1._
764      */
765     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
766         return functionCall(target, data, "Address: low-level call failed");
767     }
768 
769     /**
770      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
771      * `errorMessage` as a fallback revert reason when `target` reverts.
772      *
773      * _Available since v3.1._
774      */
775     function functionCall(
776         address target,
777         bytes memory data,
778         string memory errorMessage
779     ) internal returns (bytes memory) {
780         return functionCallWithValue(target, data, 0, errorMessage);
781     }
782 
783     /**
784      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
785      * but also transferring `value` wei to `target`.
786      *
787      * Requirements:
788      *
789      * - the calling contract must have an ETH balance of at least `value`.
790      * - the called Solidity function must be `payable`.
791      *
792      * _Available since v3.1._
793      */
794     function functionCallWithValue(
795         address target,
796         bytes memory data,
797         uint256 value
798     ) internal returns (bytes memory) {
799         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
800     }
801 
802     /**
803      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
804      * with `errorMessage` as a fallback revert reason when `target` reverts.
805      *
806      * _Available since v3.1._
807      */
808     function functionCallWithValue(
809         address target,
810         bytes memory data,
811         uint256 value,
812         string memory errorMessage
813     ) internal returns (bytes memory) {
814         require(address(this).balance >= value, "Address: insufficient balance for call");
815         require(isContract(target), "Address: call to non-contract");
816 
817         (bool success, bytes memory returndata) = target.call{value: value}(data);
818         return verifyCallResult(success, returndata, errorMessage);
819     }
820 
821     /**
822      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
823      * but performing a static call.
824      *
825      * _Available since v3.3._
826      */
827     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
828         return functionStaticCall(target, data, "Address: low-level static call failed");
829     }
830 
831     /**
832      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
833      * but performing a static call.
834      *
835      * _Available since v3.3._
836      */
837     function functionStaticCall(
838         address target,
839         bytes memory data,
840         string memory errorMessage
841     ) internal view returns (bytes memory) {
842         require(isContract(target), "Address: static call to non-contract");
843 
844         (bool success, bytes memory returndata) = target.staticcall(data);
845         return verifyCallResult(success, returndata, errorMessage);
846     }
847 
848     /**
849      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
850      * but performing a delegate call.
851      *
852      * _Available since v3.4._
853      */
854     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
855         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
856     }
857 
858     /**
859      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
860      * but performing a delegate call.
861      *
862      * _Available since v3.4._
863      */
864     function functionDelegateCall(
865         address target,
866         bytes memory data,
867         string memory errorMessage
868     ) internal returns (bytes memory) {
869         require(isContract(target), "Address: delegate call to non-contract");
870 
871         (bool success, bytes memory returndata) = target.delegatecall(data);
872         return verifyCallResult(success, returndata, errorMessage);
873     }
874 
875     /**
876      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
877      * revert reason using the provided one.
878      *
879      * _Available since v4.3._
880      */
881     function verifyCallResult(
882         bool success,
883         bytes memory returndata,
884         string memory errorMessage
885     ) internal pure returns (bytes memory) {
886         if (success) {
887             return returndata;
888         } else {
889             // Look for revert reason and bubble it up if present
890             if (returndata.length > 0) {
891                 // The easiest way to bubble the revert reason is using memory via assembly
892 
893                 assembly {
894                     let returndata_size := mload(returndata)
895                     revert(add(32, returndata), returndata_size)
896                 }
897             } else {
898                 revert(errorMessage);
899             }
900         }
901     }
902 }
903 
904 
905 // File contracts/isk/IskraTokenEth.sol
906 
907 pragma solidity ^0.8.0;
908 
909 contract IskraTokenEth is IERC165, ERC20, IERC1363 {
910     using Address for address;
911 
912     constructor(uint256 initialSupply, address initialHolder) ERC20("ISKRA TOKEN", "ISK") {
913         _mint(initialHolder, initialSupply);
914     }
915 
916     function supportsInterface(bytes4 interfaceId) external pure override(IERC165) returns (bool) {
917         return
918             interfaceId == type(IERC165).interfaceId ||
919             interfaceId == type(IERC20).interfaceId ||
920             interfaceId == type(IERC20Metadata).interfaceId ||
921             interfaceId == type(IERC1363).interfaceId;
922     }
923 
924     function transferAndCall(address recipient, uint256 amount) public override returns (bool) {
925         return transferAndCall(recipient, amount, "");
926     }
927 
928     function transferAndCall(
929         address recipient,
930         uint256 amount,
931         bytes memory data
932     ) public override returns (bool) {
933         transfer(recipient, amount);
934         require(
935             _checkOnTransferReceived(_msgSender(), recipient, amount, data),
936             "ERC1363: _checkAndCallTransfer reverts"
937         );
938         return true;
939     }
940 
941     function transferFromAndCall(
942         address sender,
943         address recipient,
944         uint256 amount
945     ) public override returns (bool) {
946         return transferFromAndCall(sender, recipient, amount, "");
947     }
948 
949     function transferFromAndCall(
950         address sender,
951         address recipient,
952         uint256 amount,
953         bytes memory data
954     ) public override returns (bool) {
955         transferFrom(sender, recipient, amount);
956         require(_checkOnTransferReceived(sender, recipient, amount, data), "ERC1363: _checkAndCallTransfer reverts");
957         return true;
958     }
959 
960     function approveAndCall(address spender, uint256 amount) public override returns (bool) {
961         return approveAndCall(spender, amount, "");
962     }
963 
964     function approveAndCall(
965         address spender,
966         uint256 amount,
967         bytes memory data
968     ) public override returns (bool) {
969         approve(spender, amount);
970         require(_checkOnApprovalReceived(spender, amount, data), "ERC1363: _checkAndCallApprove reverts");
971         return true;
972     }
973 
974     function _checkOnTransferReceived(
975         address sender,
976         address recipient,
977         uint256 amount,
978         bytes memory data
979     ) internal returns (bool) {
980         if (!recipient.isContract()) {
981             return false;
982         }
983 
984         bytes4 retval = IERC1363Receiver(recipient).onTransferReceived(msg.sender, sender, amount, data);
985         return (retval == IERC1363Receiver(recipient).onTransferReceived.selector);
986     }
987 
988     function _checkOnApprovalReceived(
989         address spender,
990         uint256 amount,
991         bytes memory data
992     ) internal returns (bool) {
993         if (!spender.isContract()) {
994             return false;
995         }
996         bytes4 retval = IERC1363Spender(spender).onApprovalReceived(_msgSender(), amount, data);
997         return (retval == IERC1363Spender(spender).onApprovalReceived.selector);
998     }
999 }