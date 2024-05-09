1 // File: @openzeppelin/contracts@4.3.3/utils/Context.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 // File: @openzeppelin/contracts@4.3.3/access/Ownable.sol
28 
29 
30 
31 pragma solidity ^0.8.0;
32 
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 abstract contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor() {
55         _setOwner(_msgSender());
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view virtual returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(owner() == _msgSender(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Leaves the contract without owner. It will not be possible to call
75      * `onlyOwner` functions anymore. Can only be called by the current owner.
76      *
77      * NOTE: Renouncing ownership will leave the contract without an owner,
78      * thereby removing any functionality that is only available to the owner.
79      */
80     function renounceOwnership() public virtual onlyOwner {
81         _setOwner(address(0));
82     }
83 
84     /**
85      * @dev Transfers ownership of the contract to a new account (`newOwner`).
86      * Can only be called by the current owner.
87      */
88     function transferOwnership(address newOwner) public virtual onlyOwner {
89         require(newOwner != address(0), "Ownable: new owner is the zero address");
90         _setOwner(newOwner);
91     }
92 
93     function _setOwner(address newOwner) private {
94         address oldOwner = _owner;
95         _owner = newOwner;
96         emit OwnershipTransferred(oldOwner, newOwner);
97     }
98 }
99 
100 // File: @openzeppelin/contracts@4.3.3/security/Pausable.sol
101 
102 
103 
104 pragma solidity ^0.8.0;
105 
106 
107 /**
108  * @dev Contract module which allows children to implement an emergency stop
109  * mechanism that can be triggered by an authorized account.
110  *
111  * This module is used through inheritance. It will make available the
112  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
113  * the functions of your contract. Note that they will not be pausable by
114  * simply including this module, only once the modifiers are put in place.
115  */
116 abstract contract Pausable is Context {
117     /**
118      * @dev Emitted when the pause is triggered by `account`.
119      */
120     event Paused(address account);
121 
122     /**
123      * @dev Emitted when the pause is lifted by `account`.
124      */
125     event Unpaused(address account);
126 
127     bool private _paused;
128 
129     /**
130      * @dev Initializes the contract in unpaused state.
131      */
132     constructor() {
133         _paused = false;
134     }
135 
136     /**
137      * @dev Returns true if the contract is paused, and false otherwise.
138      */
139     function paused() public view virtual returns (bool) {
140         return _paused;
141     }
142 
143     /**
144      * @dev Modifier to make a function callable only when the contract is not paused.
145      *
146      * Requirements:
147      *
148      * - The contract must not be paused.
149      */
150     modifier whenNotPaused() {
151         require(!paused(), "Pausable: paused");
152         _;
153     }
154 
155     /**
156      * @dev Modifier to make a function callable only when the contract is paused.
157      *
158      * Requirements:
159      *
160      * - The contract must be paused.
161      */
162     modifier whenPaused() {
163         require(paused(), "Pausable: not paused");
164         _;
165     }
166 
167     /**
168      * @dev Triggers stopped state.
169      *
170      * Requirements:
171      *
172      * - The contract must not be paused.
173      */
174     function _pause() internal virtual whenNotPaused {
175         _paused = true;
176         emit Paused(_msgSender());
177     }
178 
179     /**
180      * @dev Returns to normal state.
181      *
182      * Requirements:
183      *
184      * - The contract must be paused.
185      */
186     function _unpause() internal virtual whenPaused {
187         _paused = false;
188         emit Unpaused(_msgSender());
189     }
190 }
191 
192 // File: @openzeppelin/contracts@4.3.3/token/ERC20/IERC20.sol
193 
194 
195 
196 pragma solidity ^0.8.0;
197 
198 /**
199  * @dev Interface of the ERC20 standard as defined in the EIP.
200  */
201 interface IERC20 {
202     /**
203      * @dev Returns the amount of tokens in existence.
204      */
205     function totalSupply() external view returns (uint256);
206 
207     /**
208      * @dev Returns the amount of tokens owned by `account`.
209      */
210     function balanceOf(address account) external view returns (uint256);
211 
212     /**
213      * @dev Moves `amount` tokens from the caller's account to `recipient`.
214      *
215      * Returns a boolean value indicating whether the operation succeeded.
216      *
217      * Emits a {Transfer} event.
218      */
219     function transfer(address recipient, uint256 amount) external returns (bool);
220 
221     /**
222      * @dev Returns the remaining number of tokens that `spender` will be
223      * allowed to spend on behalf of `owner` through {transferFrom}. This is
224      * zero by default.
225      *
226      * This value changes when {approve} or {transferFrom} are called.
227      */
228     function allowance(address owner, address spender) external view returns (uint256);
229 
230     /**
231      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
232      *
233      * Returns a boolean value indicating whether the operation succeeded.
234      *
235      * IMPORTANT: Beware that changing an allowance with this method brings the risk
236      * that someone may use both the old and the new allowance by unfortunate
237      * transaction ordering. One possible solution to mitigate this race
238      * condition is to first reduce the spender's allowance to 0 and set the
239      * desired value afterwards:
240      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
241      *
242      * Emits an {Approval} event.
243      */
244     function approve(address spender, uint256 amount) external returns (bool);
245 
246     /**
247      * @dev Moves `amount` tokens from `sender` to `recipient` using the
248      * allowance mechanism. `amount` is then deducted from the caller's
249      * allowance.
250      *
251      * Returns a boolean value indicating whether the operation succeeded.
252      *
253      * Emits a {Transfer} event.
254      */
255     function transferFrom(
256         address sender,
257         address recipient,
258         uint256 amount
259     ) external returns (bool);
260 
261     /**
262      * @dev Emitted when `value` tokens are moved from one account (`from`) to
263      * another (`to`).
264      *
265      * Note that `value` may be zero.
266      */
267     event Transfer(address indexed from, address indexed to, uint256 value);
268 
269     /**
270      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
271      * a call to {approve}. `value` is the new allowance.
272      */
273     event Approval(address indexed owner, address indexed spender, uint256 value);
274 }
275 
276 // File: @openzeppelin/contracts@4.3.3/token/ERC20/extensions/IERC20Metadata.sol
277 
278 
279 
280 pragma solidity ^0.8.0;
281 
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
305 // File: @openzeppelin/contracts@4.3.3/token/ERC20/ERC20.sol
306 
307 
308 
309 pragma solidity ^0.8.0;
310 
311 
312 
313 
314 /**
315  * @dev Implementation of the {IERC20} interface.
316  *
317  * This implementation is agnostic to the way tokens are created. This means
318  * that a supply mechanism has to be added in a derived contract using {_mint}.
319  * For a generic mechanism see {ERC20PresetMinterPauser}.
320  *
321  * TIP: For a detailed writeup see our guide
322  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
323  * to implement supply mechanisms].
324  *
325  * We have followed general OpenZeppelin Contracts guidelines: functions revert
326  * instead returning `false` on failure. This behavior is nonetheless
327  * conventional and does not conflict with the expectations of ERC20
328  * applications.
329  *
330  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
331  * This allows applications to reconstruct the allowance for all accounts just
332  * by listening to said events. Other implementations of the EIP may not emit
333  * these events, as it isn't required by the specification.
334  *
335  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
336  * functions have been added to mitigate the well-known issues around setting
337  * allowances. See {IERC20-approve}.
338  */
339 contract ERC20 is Context, IERC20, IERC20Metadata {
340     mapping(address => uint256) private _balances;
341 
342     mapping(address => mapping(address => uint256)) private _allowances;
343 
344     uint256 private _totalSupply;
345 
346     string private _name;
347     string private _symbol;
348 
349     /**
350      * @dev Sets the values for {name} and {symbol}.
351      *
352      * The default value of {decimals} is 18. To select a different value for
353      * {decimals} you should overload it.
354      *
355      * All two of these values are immutable: they can only be set once during
356      * construction.
357      */
358     constructor(string memory name_, string memory symbol_) {
359         _name = name_;
360         _symbol = symbol_;
361     }
362 
363     /**
364      * @dev Returns the name of the token.
365      */
366     function name() public view virtual override returns (string memory) {
367         return _name;
368     }
369 
370     /**
371      * @dev Returns the symbol of the token, usually a shorter version of the
372      * name.
373      */
374     function symbol() public view virtual override returns (string memory) {
375         return _symbol;
376     }
377 
378     /**
379      * @dev Returns the number of decimals used to get its user representation.
380      * For example, if `decimals` equals `2`, a balance of `505` tokens should
381      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
382      *
383      * Tokens usually opt for a value of 18, imitating the relationship between
384      * Ether and Wei. This is the value {ERC20} uses, unless this function is
385      * overridden;
386      *
387      * NOTE: This information is only used for _display_ purposes: it in
388      * no way affects any of the arithmetic of the contract, including
389      * {IERC20-balanceOf} and {IERC20-transfer}.
390      */
391     function decimals() public view virtual override returns (uint8) {
392         return 18;
393     }
394 
395     /**
396      * @dev See {IERC20-totalSupply}.
397      */
398     function totalSupply() public view virtual override returns (uint256) {
399         return _totalSupply;
400     }
401 
402     /**
403      * @dev See {IERC20-balanceOf}.
404      */
405     function balanceOf(address account) public view virtual override returns (uint256) {
406         return _balances[account];
407     }
408 
409     /**
410      * @dev See {IERC20-transfer}.
411      *
412      * Requirements:
413      *
414      * - `recipient` cannot be the zero address.
415      * - the caller must have a balance of at least `amount`.
416      */
417     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
418         _transfer(_msgSender(), recipient, amount);
419         return true;
420     }
421 
422     /**
423      * @dev See {IERC20-allowance}.
424      */
425     function allowance(address owner, address spender) public view virtual override returns (uint256) {
426         return _allowances[owner][spender];
427     }
428 
429     /**
430      * @dev See {IERC20-approve}.
431      *
432      * Requirements:
433      *
434      * - `spender` cannot be the zero address.
435      */
436     function approve(address spender, uint256 amount) public virtual override returns (bool) {
437         _approve(_msgSender(), spender, amount);
438         return true;
439     }
440 
441     /**
442      * @dev See {IERC20-transferFrom}.
443      *
444      * Emits an {Approval} event indicating the updated allowance. This is not
445      * required by the EIP. See the note at the beginning of {ERC20}.
446      *
447      * Requirements:
448      *
449      * - `sender` and `recipient` cannot be the zero address.
450      * - `sender` must have a balance of at least `amount`.
451      * - the caller must have allowance for ``sender``'s tokens of at least
452      * `amount`.
453      */
454     function transferFrom(
455         address sender,
456         address recipient,
457         uint256 amount
458     ) public virtual override returns (bool) {
459         _transfer(sender, recipient, amount);
460 
461         uint256 currentAllowance = _allowances[sender][_msgSender()];
462         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
463         unchecked {
464             _approve(sender, _msgSender(), currentAllowance - amount);
465         }
466 
467         return true;
468     }
469 
470     /**
471      * @dev Atomically increases the allowance granted to `spender` by the caller.
472      *
473      * This is an alternative to {approve} that can be used as a mitigation for
474      * problems described in {IERC20-approve}.
475      *
476      * Emits an {Approval} event indicating the updated allowance.
477      *
478      * Requirements:
479      *
480      * - `spender` cannot be the zero address.
481      */
482     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
483         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
484         return true;
485     }
486 
487     /**
488      * @dev Atomically decreases the allowance granted to `spender` by the caller.
489      *
490      * This is an alternative to {approve} that can be used as a mitigation for
491      * problems described in {IERC20-approve}.
492      *
493      * Emits an {Approval} event indicating the updated allowance.
494      *
495      * Requirements:
496      *
497      * - `spender` cannot be the zero address.
498      * - `spender` must have allowance for the caller of at least
499      * `subtractedValue`.
500      */
501     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
502         uint256 currentAllowance = _allowances[_msgSender()][spender];
503         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
504         unchecked {
505             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
506         }
507 
508         return true;
509     }
510 
511     /**
512      * @dev Moves `amount` of tokens from `sender` to `recipient`.
513      *
514      * This internal function is equivalent to {transfer}, and can be used to
515      * e.g. implement automatic token fees, slashing mechanisms, etc.
516      *
517      * Emits a {Transfer} event.
518      *
519      * Requirements:
520      *
521      * - `sender` cannot be the zero address.
522      * - `recipient` cannot be the zero address.
523      * - `sender` must have a balance of at least `amount`.
524      */
525     function _transfer(
526         address sender,
527         address recipient,
528         uint256 amount
529     ) internal virtual {
530         require(sender != address(0), "ERC20: transfer from the zero address");
531         require(recipient != address(0), "ERC20: transfer to the zero address");
532 
533         _beforeTokenTransfer(sender, recipient, amount);
534 
535         uint256 senderBalance = _balances[sender];
536         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
537         unchecked {
538             _balances[sender] = senderBalance - amount;
539         }
540         _balances[recipient] += amount;
541 
542         emit Transfer(sender, recipient, amount);
543 
544         _afterTokenTransfer(sender, recipient, amount);
545     }
546 
547     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
548      * the total supply.
549      *
550      * Emits a {Transfer} event with `from` set to the zero address.
551      *
552      * Requirements:
553      *
554      * - `account` cannot be the zero address.
555      */
556     function _mint(address account, uint256 amount) internal virtual {
557         require(account != address(0), "ERC20: mint to the zero address");
558 
559         _beforeTokenTransfer(address(0), account, amount);
560 
561         _totalSupply += amount;
562         _balances[account] += amount;
563         emit Transfer(address(0), account, amount);
564 
565         _afterTokenTransfer(address(0), account, amount);
566     }
567 
568     /**
569      * @dev Destroys `amount` tokens from `account`, reducing the
570      * total supply.
571      *
572      * Emits a {Transfer} event with `to` set to the zero address.
573      *
574      * Requirements:
575      *
576      * - `account` cannot be the zero address.
577      * - `account` must have at least `amount` tokens.
578      */
579     function _burn(address account, uint256 amount) internal virtual {
580         require(account != address(0), "ERC20: burn from the zero address");
581 
582         _beforeTokenTransfer(account, address(0), amount);
583 
584         uint256 accountBalance = _balances[account];
585         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
586         unchecked {
587             _balances[account] = accountBalance - amount;
588         }
589         _totalSupply -= amount;
590 
591         emit Transfer(account, address(0), amount);
592 
593         _afterTokenTransfer(account, address(0), amount);
594     }
595 
596     /**
597      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
598      *
599      * This internal function is equivalent to `approve`, and can be used to
600      * e.g. set automatic allowances for certain subsystems, etc.
601      *
602      * Emits an {Approval} event.
603      *
604      * Requirements:
605      *
606      * - `owner` cannot be the zero address.
607      * - `spender` cannot be the zero address.
608      */
609     function _approve(
610         address owner,
611         address spender,
612         uint256 amount
613     ) internal virtual {
614         require(owner != address(0), "ERC20: approve from the zero address");
615         require(spender != address(0), "ERC20: approve to the zero address");
616 
617         _allowances[owner][spender] = amount;
618         emit Approval(owner, spender, amount);
619     }
620 
621     /**
622      * @dev Hook that is called before any transfer of tokens. This includes
623      * minting and burning.
624      *
625      * Calling conditions:
626      *
627      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
628      * will be transferred to `to`.
629      * - when `from` is zero, `amount` tokens will be minted for `to`.
630      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
631      * - `from` and `to` are never both zero.
632      *
633      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
634      */
635     function _beforeTokenTransfer(
636         address from,
637         address to,
638         uint256 amount
639     ) internal virtual {}
640 
641     /**
642      * @dev Hook that is called after any transfer of tokens. This includes
643      * minting and burning.
644      *
645      * Calling conditions:
646      *
647      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
648      * has been transferred to `to`.
649      * - when `from` is zero, `amount` tokens have been minted for `to`.
650      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
651      * - `from` and `to` are never both zero.
652      *
653      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
654      */
655     function _afterTokenTransfer(
656         address from,
657         address to,
658         uint256 amount
659     ) internal virtual {}
660 }
661 
662 // File: @openzeppelin/contracts@4.3.3/token/ERC20/extensions/ERC20Burnable.sol
663 
664 
665 
666 pragma solidity ^0.8.0;
667 
668 
669 
670 /**
671  * @dev Extension of {ERC20} that allows token holders to destroy both their own
672  * tokens and those that they have an allowance for, in a way that can be
673  * recognized off-chain (via event analysis).
674  */
675 abstract contract ERC20Burnable is Context, ERC20 {
676     /**
677      * @dev Destroys `amount` tokens from the caller.
678      *
679      * See {ERC20-_burn}.
680      */
681     function burn(uint256 amount) public virtual {
682         _burn(_msgSender(), amount);
683     }
684 
685     /**
686      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
687      * allowance.
688      *
689      * See {ERC20-_burn} and {ERC20-allowance}.
690      *
691      * Requirements:
692      *
693      * - the caller must have allowance for ``accounts``'s tokens of at least
694      * `amount`.
695      */
696     function burnFrom(address account, uint256 amount) public virtual {
697         uint256 currentAllowance = allowance(account, _msgSender());
698         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
699         unchecked {
700             _approve(account, _msgSender(), currentAllowance - amount);
701         }
702         _burn(account, amount);
703     }
704 }
705 
706 // File: contract-26684114e7.sol
707 
708 
709 pragma solidity ^0.8.2;
710 
711 
712 
713 
714 
715 contract ESGCHAIN is ERC20, ERC20Burnable, Pausable, Ownable {
716     constructor() ERC20("ESG CHAIN", "ESGC") {
717         _mint(msg.sender, 7874965732 * 10 ** decimals());
718     }
719 
720     function pause() public onlyOwner {
721         _pause();
722     }
723 
724     function unpause() public onlyOwner {
725         _unpause();
726     }
727 
728     function mint(address to, uint256 amount) public onlyOwner {
729         _mint(to, amount);
730     }
731 
732     function _beforeTokenTransfer(address from, address to, uint256 amount)
733         internal
734         whenNotPaused
735         override
736     {
737         super._beforeTokenTransfer(from, to, amount);
738     }
739 }