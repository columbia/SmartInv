1 // File: @openzeppelin/contracts@4.4.2/utils/Context.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts@4.4.2/access/Ownable.sol
29 
30 
31 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         _transferOwnership(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _transferOwnership(newOwner);
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Internal function without access restriction.
98      */
99     function _transferOwnership(address newOwner) internal virtual {
100         address oldOwner = _owner;
101         _owner = newOwner;
102         emit OwnershipTransferred(oldOwner, newOwner);
103     }
104 }
105 
106 // File: @openzeppelin/contracts@4.4.2/security/Pausable.sol
107 
108 
109 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
110 
111 pragma solidity ^0.8.0;
112 
113 
114 /**
115  * @dev Contract module which allows children to implement an emergency stop
116  * mechanism that can be triggered by an authorized account.
117  *
118  * This module is used through inheritance. It will make available the
119  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
120  * the functions of your contract. Note that they will not be pausable by
121  * simply including this module, only once the modifiers are put in place.
122  */
123 abstract contract Pausable is Context {
124     /**
125      * @dev Emitted when the pause is triggered by `account`.
126      */
127     event Paused(address account);
128 
129     /**
130      * @dev Emitted when the pause is lifted by `account`.
131      */
132     event Unpaused(address account);
133 
134     bool private _paused;
135 
136     /**
137      * @dev Initializes the contract in unpaused state.
138      */
139     constructor() {
140         _paused = false;
141     }
142 
143     /**
144      * @dev Returns true if the contract is paused, and false otherwise.
145      */
146     function paused() public view virtual returns (bool) {
147         return _paused;
148     }
149 
150     /**
151      * @dev Modifier to make a function callable only when the contract is not paused.
152      *
153      * Requirements:
154      *
155      * - The contract must not be paused.
156      */
157     modifier whenNotPaused() {
158         require(!paused(), "Pausable: paused");
159         _;
160     }
161 
162     /**
163      * @dev Modifier to make a function callable only when the contract is paused.
164      *
165      * Requirements:
166      *
167      * - The contract must be paused.
168      */
169     modifier whenPaused() {
170         require(paused(), "Pausable: not paused");
171         _;
172     }
173 
174     /**
175      * @dev Triggers stopped state.
176      *
177      * Requirements:
178      *
179      * - The contract must not be paused.
180      */
181     function _pause() internal virtual whenNotPaused {
182         _paused = true;
183         emit Paused(_msgSender());
184     }
185 
186     /**
187      * @dev Returns to normal state.
188      *
189      * Requirements:
190      *
191      * - The contract must be paused.
192      */
193     function _unpause() internal virtual whenPaused {
194         _paused = false;
195         emit Unpaused(_msgSender());
196     }
197 }
198 
199 // File: @openzeppelin/contracts@4.4.2/token/ERC20/IERC20.sol
200 
201 
202 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
203 
204 pragma solidity ^0.8.0;
205 
206 /**
207  * @dev Interface of the ERC20 standard as defined in the EIP.
208  */
209 interface IERC20 {
210     /**
211      * @dev Returns the amount of tokens in existence.
212      */
213     function totalSupply() external view returns (uint256);
214 
215     /**
216      * @dev Returns the amount of tokens owned by `account`.
217      */
218     function balanceOf(address account) external view returns (uint256);
219 
220     /**
221      * @dev Moves `amount` tokens from the caller's account to `recipient`.
222      *
223      * Returns a boolean value indicating whether the operation succeeded.
224      *
225      * Emits a {Transfer} event.
226      */
227     function transfer(address recipient, uint256 amount) external returns (bool);
228 
229     /**
230      * @dev Returns the remaining number of tokens that `spender` will be
231      * allowed to spend on behalf of `owner` through {transferFrom}. This is
232      * zero by default.
233      *
234      * This value changes when {approve} or {transferFrom} are called.
235      */
236     function allowance(address owner, address spender) external view returns (uint256);
237 
238     /**
239      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
240      *
241      * Returns a boolean value indicating whether the operation succeeded.
242      *
243      * IMPORTANT: Beware that changing an allowance with this method brings the risk
244      * that someone may use both the old and the new allowance by unfortunate
245      * transaction ordering. One possible solution to mitigate this race
246      * condition is to first reduce the spender's allowance to 0 and set the
247      * desired value afterwards:
248      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
249      *
250      * Emits an {Approval} event.
251      */
252     function approve(address spender, uint256 amount) external returns (bool);
253 
254     /**
255      * @dev Moves `amount` tokens from `sender` to `recipient` using the
256      * allowance mechanism. `amount` is then deducted from the caller's
257      * allowance.
258      *
259      * Returns a boolean value indicating whether the operation succeeded.
260      *
261      * Emits a {Transfer} event.
262      */
263     function transferFrom(
264         address sender,
265         address recipient,
266         uint256 amount
267     ) external returns (bool);
268 
269     /**
270      * @dev Emitted when `value` tokens are moved from one account (`from`) to
271      * another (`to`).
272      *
273      * Note that `value` may be zero.
274      */
275     event Transfer(address indexed from, address indexed to, uint256 value);
276 
277     /**
278      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
279      * a call to {approve}. `value` is the new allowance.
280      */
281     event Approval(address indexed owner, address indexed spender, uint256 value);
282 }
283 
284 // File: @openzeppelin/contracts@4.4.2/token/ERC20/extensions/IERC20Metadata.sol
285 
286 
287 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
288 
289 pragma solidity ^0.8.0;
290 
291 
292 /**
293  * @dev Interface for the optional metadata functions from the ERC20 standard.
294  *
295  * _Available since v4.1._
296  */
297 interface IERC20Metadata is IERC20 {
298     /**
299      * @dev Returns the name of the token.
300      */
301     function name() external view returns (string memory);
302 
303     /**
304      * @dev Returns the symbol of the token.
305      */
306     function symbol() external view returns (string memory);
307 
308     /**
309      * @dev Returns the decimals places of the token.
310      */
311     function decimals() external view returns (uint8);
312 }
313 
314 // File: @openzeppelin/contracts@4.4.2/token/ERC20/ERC20.sol
315 
316 
317 // OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)
318 
319 pragma solidity ^0.8.0;
320 
321 
322 
323 
324 /**
325  * @dev Implementation of the {IERC20} interface.
326  *
327  * This implementation is agnostic to the way tokens are created. This means
328  * that a supply mechanism has to be added in a derived contract using {_mint}.
329  * For a generic mechanism see {ERC20PresetMinterPauser}.
330  *
331  * TIP: For a detailed writeup see our guide
332  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
333  * to implement supply mechanisms].
334  *
335  * We have followed general OpenZeppelin Contracts guidelines: functions revert
336  * instead returning `false` on failure. This behavior is nonetheless
337  * conventional and does not conflict with the expectations of ERC20
338  * applications.
339  *
340  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
341  * This allows applications to reconstruct the allowance for all accounts just
342  * by listening to said events. Other implementations of the EIP may not emit
343  * these events, as it isn't required by the specification.
344  *
345  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
346  * functions have been added to mitigate the well-known issues around setting
347  * allowances. See {IERC20-approve}.
348  */
349 contract ERC20 is Context, IERC20, IERC20Metadata {
350     mapping(address => uint256) private _balances;
351 
352     mapping(address => mapping(address => uint256)) private _allowances;
353 
354     uint256 private _totalSupply;
355 
356     string private _name;
357     string private _symbol;
358 
359     /**
360      * @dev Sets the values for {name} and {symbol}.
361      *
362      * The default value of {decimals} is 18. To select a different value for
363      * {decimals} you should overload it.
364      *
365      * All two of these values are immutable: they can only be set once during
366      * construction.
367      */
368     constructor(string memory name_, string memory symbol_) {
369         _name = name_;
370         _symbol = symbol_;
371     }
372 
373     /**
374      * @dev Returns the name of the token.
375      */
376     function name() public view virtual override returns (string memory) {
377         return _name;
378     }
379 
380     /**
381      * @dev Returns the symbol of the token, usually a shorter version of the
382      * name.
383      */
384     function symbol() public view virtual override returns (string memory) {
385         return _symbol;
386     }
387 
388     /**
389      * @dev Returns the number of decimals used to get its user representation.
390      * For example, if `decimals` equals `2`, a balance of `505` tokens should
391      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
392      *
393      * Tokens usually opt for a value of 18, imitating the relationship between
394      * Ether and Wei. This is the value {ERC20} uses, unless this function is
395      * overridden;
396      *
397      * NOTE: This information is only used for _display_ purposes: it in
398      * no way affects any of the arithmetic of the contract, including
399      * {IERC20-balanceOf} and {IERC20-transfer}.
400      */
401     function decimals() public view virtual override returns (uint8) {
402         return 18;
403     }
404 
405     /**
406      * @dev See {IERC20-totalSupply}.
407      */
408     function totalSupply() public view virtual override returns (uint256) {
409         return _totalSupply;
410     }
411 
412     /**
413      * @dev See {IERC20-balanceOf}.
414      */
415     function balanceOf(address account) public view virtual override returns (uint256) {
416         return _balances[account];
417     }
418 
419     /**
420      * @dev See {IERC20-transfer}.
421      *
422      * Requirements:
423      *
424      * - `recipient` cannot be the zero address.
425      * - the caller must have a balance of at least `amount`.
426      */
427     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
428         _transfer(_msgSender(), recipient, amount);
429         return true;
430     }
431 
432     /**
433      * @dev See {IERC20-allowance}.
434      */
435     function allowance(address owner, address spender) public view virtual override returns (uint256) {
436         return _allowances[owner][spender];
437     }
438 
439     /**
440      * @dev See {IERC20-approve}.
441      *
442      * Requirements:
443      *
444      * - `spender` cannot be the zero address.
445      */
446     function approve(address spender, uint256 amount) public virtual override returns (bool) {
447         _approve(_msgSender(), spender, amount);
448         return true;
449     }
450 
451     /**
452      * @dev See {IERC20-transferFrom}.
453      *
454      * Emits an {Approval} event indicating the updated allowance. This is not
455      * required by the EIP. See the note at the beginning of {ERC20}.
456      *
457      * Requirements:
458      *
459      * - `sender` and `recipient` cannot be the zero address.
460      * - `sender` must have a balance of at least `amount`.
461      * - the caller must have allowance for ``sender``'s tokens of at least
462      * `amount`.
463      */
464     function transferFrom(
465         address sender,
466         address recipient,
467         uint256 amount
468     ) public virtual override returns (bool) {
469         _transfer(sender, recipient, amount);
470 
471         uint256 currentAllowance = _allowances[sender][_msgSender()];
472         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
473         unchecked {
474             _approve(sender, _msgSender(), currentAllowance - amount);
475         }
476 
477         return true;
478     }
479 
480     /**
481      * @dev Atomically increases the allowance granted to `spender` by the caller.
482      *
483      * This is an alternative to {approve} that can be used as a mitigation for
484      * problems described in {IERC20-approve}.
485      *
486      * Emits an {Approval} event indicating the updated allowance.
487      *
488      * Requirements:
489      *
490      * - `spender` cannot be the zero address.
491      */
492     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
493         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
494         return true;
495     }
496 
497     /**
498      * @dev Atomically decreases the allowance granted to `spender` by the caller.
499      *
500      * This is an alternative to {approve} that can be used as a mitigation for
501      * problems described in {IERC20-approve}.
502      *
503      * Emits an {Approval} event indicating the updated allowance.
504      *
505      * Requirements:
506      *
507      * - `spender` cannot be the zero address.
508      * - `spender` must have allowance for the caller of at least
509      * `subtractedValue`.
510      */
511     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
512         uint256 currentAllowance = _allowances[_msgSender()][spender];
513         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
514         unchecked {
515             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
516         }
517 
518         return true;
519     }
520 
521     /**
522      * @dev Moves `amount` of tokens from `sender` to `recipient`.
523      *
524      * This internal function is equivalent to {transfer}, and can be used to
525      * e.g. implement automatic token fees, slashing mechanisms, etc.
526      *
527      * Emits a {Transfer} event.
528      *
529      * Requirements:
530      *
531      * - `sender` cannot be the zero address.
532      * - `recipient` cannot be the zero address.
533      * - `sender` must have a balance of at least `amount`.
534      */
535     function _transfer(
536         address sender,
537         address recipient,
538         uint256 amount
539     ) internal virtual {
540         require(sender != address(0), "ERC20: transfer from the zero address");
541         require(recipient != address(0), "ERC20: transfer to the zero address");
542 
543         _beforeTokenTransfer(sender, recipient, amount);
544 
545         uint256 senderBalance = _balances[sender];
546         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
547         unchecked {
548             _balances[sender] = senderBalance - amount;
549         }
550         _balances[recipient] += amount;
551 
552         emit Transfer(sender, recipient, amount);
553 
554         _afterTokenTransfer(sender, recipient, amount);
555     }
556 
557     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
558      * the total supply.
559      *
560      * Emits a {Transfer} event with `from` set to the zero address.
561      *
562      * Requirements:
563      *
564      * - `account` cannot be the zero address.
565      */
566     function _mint(address account, uint256 amount) internal virtual {
567         require(account != address(0), "ERC20: mint to the zero address");
568 
569         _beforeTokenTransfer(address(0), account, amount);
570 
571         _totalSupply += amount;
572         _balances[account] += amount;
573         emit Transfer(address(0), account, amount);
574 
575         _afterTokenTransfer(address(0), account, amount);
576     }
577 
578     /**
579      * @dev Destroys `amount` tokens from `account`, reducing the
580      * total supply.
581      *
582      * Emits a {Transfer} event with `to` set to the zero address.
583      *
584      * Requirements:
585      *
586      * - `account` cannot be the zero address.
587      * - `account` must have at least `amount` tokens.
588      */
589     function _burn(address account, uint256 amount) internal virtual {
590         require(account != address(0), "ERC20: burn from the zero address");
591 
592         _beforeTokenTransfer(account, address(0), amount);
593 
594         uint256 accountBalance = _balances[account];
595         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
596         unchecked {
597             _balances[account] = accountBalance - amount;
598         }
599         _totalSupply -= amount;
600 
601         emit Transfer(account, address(0), amount);
602 
603         _afterTokenTransfer(account, address(0), amount);
604     }
605 
606     /**
607      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
608      *
609      * This internal function is equivalent to `approve`, and can be used to
610      * e.g. set automatic allowances for certain subsystems, etc.
611      *
612      * Emits an {Approval} event.
613      *
614      * Requirements:
615      *
616      * - `owner` cannot be the zero address.
617      * - `spender` cannot be the zero address.
618      */
619     function _approve(
620         address owner,
621         address spender,
622         uint256 amount
623     ) internal virtual {
624         require(owner != address(0), "ERC20: approve from the zero address");
625         require(spender != address(0), "ERC20: approve to the zero address");
626 
627         _allowances[owner][spender] = amount;
628         emit Approval(owner, spender, amount);
629     }
630 
631     /**
632      * @dev Hook that is called before any transfer of tokens. This includes
633      * minting and burning.
634      *
635      * Calling conditions:
636      *
637      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
638      * will be transferred to `to`.
639      * - when `from` is zero, `amount` tokens will be minted for `to`.
640      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
641      * - `from` and `to` are never both zero.
642      *
643      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
644      */
645     function _beforeTokenTransfer(
646         address from,
647         address to,
648         uint256 amount
649     ) internal virtual {}
650 
651     /**
652      * @dev Hook that is called after any transfer of tokens. This includes
653      * minting and burning.
654      *
655      * Calling conditions:
656      *
657      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
658      * has been transferred to `to`.
659      * - when `from` is zero, `amount` tokens have been minted for `to`.
660      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
661      * - `from` and `to` are never both zero.
662      *
663      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
664      */
665     function _afterTokenTransfer(
666         address from,
667         address to,
668         uint256 amount
669     ) internal virtual {}
670 }
671 
672 // File: contracts/epee.sol
673 
674 
675 pragma solidity ^0.8.2;
676 
677 
678 
679 
680 contract EPEE is ERC20, Pausable, Ownable {
681     constructor() ERC20("EPEE", "EPE") {
682         _mint(msg.sender, 10000000000 * 10 ** decimals());
683     }
684 
685     function pause() public onlyOwner {
686         _pause();
687     }
688 
689     function unpause() public onlyOwner {
690         _unpause();
691     }
692 
693     function mint(address to, uint256 amount) public onlyOwner {
694         _mint(to, amount);
695     }
696 
697     function _beforeTokenTransfer(address from, address to, uint256 amount)
698         internal
699         whenNotPaused
700         override
701     {
702         super._beforeTokenTransfer(from, to, amount);
703     }
704 }