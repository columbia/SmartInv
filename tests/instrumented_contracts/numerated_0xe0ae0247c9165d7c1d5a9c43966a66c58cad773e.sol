1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.9;
3 
4 interface IERC20 {
5     /**
6      * @dev Emitted when `value` tokens are moved from one account (`from`) to
7      * another (`to`).
8      *
9      * Note that `value` may be zero.
10      */
11     event Transfer(address indexed from, address indexed to, uint256 value);
12 
13     /**
14      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
15      * a call to {approve}. `value` is the new allowance.
16      */
17     event Approval(
18         address indexed owner,
19         address indexed spender,
20         uint256 value
21     );
22 
23     /**
24      * @dev Returns the amount of tokens in existence.
25      */
26     function totalSupply() external view returns (uint256);
27 
28     /**
29      * @dev Returns the amount of tokens owned by `account`.
30      */
31     function balanceOf(address account) external view returns (uint256);
32 
33     /**
34      * @dev Moves `amount` tokens from the caller's account to `to`.
35      *
36      * Returns a boolean value indicating whether the operation succeeded.
37      *
38      * Emits a {Transfer} event.
39      */
40     function transfer(address to, uint256 amount) external returns (bool);
41 
42     /**
43      * @dev Returns the remaining number of tokens that `spender` will be
44      * allowed to spend on behalf of `owner` through {transferFrom}. This is
45      * zero by default.
46      *
47      * This value changes when {approve} or {transferFrom} are called.
48      */
49     function allowance(address owner, address spender)
50         external
51         view
52         returns (uint256);
53 
54     /**
55      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * IMPORTANT: Beware that changing an allowance with this method brings the risk
60      * that someone may use both the old and the new allowance by unfortunate
61      * transaction ordering. One possible solution to mitigate this race
62      * condition is to first reduce the spender's allowance to 0 and set the
63      * desired value afterwards:
64      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
65      *
66      * Emits an {Approval} event.
67      */
68     function approve(address spender, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Moves `amount` tokens from `from` to `to` using the
72      * allowance mechanism. `amount` is then deducted from the caller's
73      * allowance.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * Emits a {Transfer} event.
78      */
79     function transferFrom(
80         address from,
81         address to,
82         uint256 amount
83     ) external returns (bool);
84 }
85 
86 interface IERC20Metadata is IERC20 {
87     /**
88      * @dev Returns the name of the token.
89      */
90     function name() external view returns (string memory);
91 
92     /**
93      * @dev Returns the symbol of the token.
94      */
95     function symbol() external view returns (string memory);
96 
97     /**
98      * @dev Returns the decimals places of the token.
99      */
100     function decimals() external view returns (uint8);
101 }
102 
103 abstract contract Context {
104     function _msgSender() internal view virtual returns (address) {
105         return msg.sender;
106     }
107 
108     function _msgData() internal view virtual returns (bytes calldata) {
109         return msg.data;
110     }
111 }
112 
113 contract ERC20 is Context, IERC20, IERC20Metadata {
114     mapping(address => uint256) private _balances;
115 
116     mapping(address => mapping(address => uint256)) private _allowances;
117 
118     uint256 private _totalSupply;
119 
120     string private _name;
121     string private _symbol;
122 
123     /**
124      * @dev Sets the values for {name} and {symbol}.
125      *
126      * All two of these values are immutable: they can only be set once during
127      * construction.
128      */
129     constructor(string memory name_, string memory symbol_) {
130         _name = name_;
131         _symbol = symbol_;
132     }
133 
134     /**
135      * @dev Returns the name of the token.
136      */
137     function name() public view virtual override returns (string memory) {
138         return _name;
139     }
140 
141     /**
142      * @dev Returns the symbol of the token, usually a shorter version of the
143      * name.
144      */
145     function symbol() public view virtual override returns (string memory) {
146         return _symbol;
147     }
148 
149     /**
150      * @dev Returns the number of decimals used to get its user representation.
151      * For example, if `decimals` equals `2`, a balance of `505` tokens should
152      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
153      *
154      * Tokens usually opt for a value of 18, imitating the relationship between
155      * Ether and Wei. This is the default value returned by this function, unless
156      * it's overridden.
157      *
158      * NOTE: This information is only used for _display_ purposes: it in
159      * no way affects any of the arithmetic of the contract, including
160      * {IERC20-balanceOf} and {IERC20-transfer}.
161      */
162     function decimals() public view virtual override returns (uint8) {
163         return 18;
164     }
165 
166     /**
167      * @dev See {IERC20-totalSupply}.
168      */
169     function totalSupply() public view virtual override returns (uint256) {
170         return _totalSupply;
171     }
172 
173     /**
174      * @dev See {IERC20-balanceOf}.
175      */
176     function balanceOf(address account)
177         public
178         view
179         virtual
180         override
181         returns (uint256)
182     {
183         return _balances[account];
184     }
185 
186     /**
187      * @dev See {IERC20-transfer}.
188      *
189      * Requirements:
190      *
191      * - `to` cannot be the zero address.
192      * - the caller must have a balance of at least `amount`.
193      */
194     function transfer(address to, uint256 amount)
195         public
196         virtual
197         override
198         returns (bool)
199     {
200         address owner = _msgSender();
201         _transfer(owner, to, amount);
202         return true;
203     }
204 
205     /**
206      * @dev See {IERC20-allowance}.
207      */
208     function allowance(address owner, address spender)
209         public
210         view
211         virtual
212         override
213         returns (uint256)
214     {
215         return _allowances[owner][spender];
216     }
217 
218     /**
219      * @dev See {IERC20-approve}.
220      *
221      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
222      * `transferFrom`. This is semantically equivalent to an infinite approval.
223      *
224      * Requirements:
225      *
226      * - `spender` cannot be the zero address.
227      */
228     function approve(address spender, uint256 amount)
229         public
230         virtual
231         override
232         returns (bool)
233     {
234         address owner = _msgSender();
235         _approve(owner, spender, amount);
236         return true;
237     }
238 
239     /**
240      * @dev See {IERC20-transferFrom}.
241      *
242      * Emits an {Approval} event indicating the updated allowance. This is not
243      * required by the EIP. See the note at the beginning of {ERC20}.
244      *
245      * NOTE: Does not update the allowance if the current allowance
246      * is the maximum `uint256`.
247      *
248      * Requirements:
249      *
250      * - `from` and `to` cannot be the zero address.
251      * - `from` must have a balance of at least `amount`.
252      * - the caller must have allowance for ``from``'s tokens of at least
253      * `amount`.
254      */
255     function transferFrom(
256         address from,
257         address to,
258         uint256 amount
259     ) public virtual override returns (bool) {
260         address spender = _msgSender();
261         _spendAllowance(from, spender, amount);
262         _transfer(from, to, amount);
263         return true;
264     }
265 
266     /**
267      * @dev Atomically increases the allowance granted to `spender` by the caller.
268      *
269      * This is an alternative to {approve} that can be used as a mitigation for
270      * problems described in {IERC20-approve}.
271      *
272      * Emits an {Approval} event indicating the updated allowance.
273      *
274      * Requirements:
275      *
276      * - `spender` cannot be the zero address.
277      */
278     function increaseAllowance(address spender, uint256 addedValue)
279         public
280         virtual
281         returns (bool)
282     {
283         address owner = _msgSender();
284         _approve(owner, spender, allowance(owner, spender) + addedValue);
285         return true;
286     }
287 
288     /**
289      * @dev Atomically decreases the allowance granted to `spender` by the caller.
290      *
291      * This is an alternative to {approve} that can be used as a mitigation for
292      * problems described in {IERC20-approve}.
293      *
294      * Emits an {Approval} event indicating the updated allowance.
295      *
296      * Requirements:
297      *
298      * - `spender` cannot be the zero address.
299      * - `spender` must have allowance for the caller of at least
300      * `subtractedValue`.
301      */
302     function decreaseAllowance(address spender, uint256 subtractedValue)
303         public
304         virtual
305         returns (bool)
306     {
307         address owner = _msgSender();
308         uint256 currentAllowance = allowance(owner, spender);
309         require(
310             currentAllowance >= subtractedValue,
311             "ERC20: decreased allowance below zero"
312         );
313         unchecked {
314             _approve(owner, spender, currentAllowance - subtractedValue);
315         }
316 
317         return true;
318     }
319 
320     /**
321      * @dev Moves `amount` of tokens from `from` to `to`.
322      *
323      * This internal function is equivalent to {transfer}, and can be used to
324      * e.g. implement automatic token fees, slashing mechanisms, etc.
325      *
326      * Emits a {Transfer} event.
327      *
328      * Requirements:
329      *
330      * - `from` cannot be the zero address.
331      * - `to` cannot be the zero address.
332      * - `from` must have a balance of at least `amount`.
333      */
334     function _transfer(
335         address from,
336         address to,
337         uint256 amount
338     ) internal virtual {
339         require(from != address(0), "ERC20: transfer from the zero address");
340         require(to != address(0), "ERC20: transfer to the zero address");
341 
342         _beforeTokenTransfer(from, to, amount);
343 
344         uint256 fromBalance = _balances[from];
345         require(
346             fromBalance >= amount,
347             "ERC20: transfer amount exceeds balance"
348         );
349         unchecked {
350             _balances[from] = fromBalance - amount;
351             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
352             // decrementing then incrementing.
353             _balances[to] += amount;
354         }
355 
356         emit Transfer(from, to, amount);
357 
358         _afterTokenTransfer(from, to, amount);
359     }
360 
361     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
362      * the total supply.
363      *
364      * Emits a {Transfer} event with `from` set to the zero address.
365      *
366      * Requirements:
367      *
368      * - `account` cannot be the zero address.
369      */
370     function _mint(address account, uint256 amount) internal virtual {
371         require(account != address(0), "ERC20: mint to the zero address");
372 
373         _beforeTokenTransfer(address(0), account, amount);
374 
375         _totalSupply += amount;
376         unchecked {
377             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
378             _balances[account] += amount;
379         }
380         emit Transfer(address(0), account, amount);
381 
382         _afterTokenTransfer(address(0), account, amount);
383     }
384 
385     /**
386      * @dev Destroys `amount` tokens from `account`, reducing the
387      * total supply.
388      *
389      * Emits a {Transfer} event with `to` set to the zero address.
390      *
391      * Requirements:
392      *
393      * - `account` cannot be the zero address.
394      * - `account` must have at least `amount` tokens.
395      */
396     function _burn(address account, uint256 amount) internal virtual {
397         require(account != address(0), "ERC20: burn from the zero address");
398 
399         _beforeTokenTransfer(account, address(0), amount);
400 
401         uint256 accountBalance = _balances[account];
402         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
403         unchecked {
404             _balances[account] = accountBalance - amount;
405             // Overflow not possible: amount <= accountBalance <= totalSupply.
406             _totalSupply -= amount;
407         }
408 
409         emit Transfer(account, address(0), amount);
410 
411         _afterTokenTransfer(account, address(0), amount);
412     }
413 
414     /**
415      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
416      *
417      * This internal function is equivalent to `approve`, and can be used to
418      * e.g. set automatic allowances for certain subsystems, etc.
419      *
420      * Emits an {Approval} event.
421      *
422      * Requirements:
423      *
424      * - `owner` cannot be the zero address.
425      * - `spender` cannot be the zero address.
426      */
427     function _approve(
428         address owner,
429         address spender,
430         uint256 amount
431     ) internal virtual {
432         require(owner != address(0), "ERC20: approve from the zero address");
433         require(spender != address(0), "ERC20: approve to the zero address");
434 
435         _allowances[owner][spender] = amount;
436         emit Approval(owner, spender, amount);
437     }
438 
439     /**
440      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
441      *
442      * Does not update the allowance amount in case of infinite allowance.
443      * Revert if not enough allowance is available.
444      *
445      * Might emit an {Approval} event.
446      */
447     function _spendAllowance(
448         address owner,
449         address spender,
450         uint256 amount
451     ) internal virtual {
452         uint256 currentAllowance = allowance(owner, spender);
453         if (currentAllowance != type(uint256).max) {
454             require(
455                 currentAllowance >= amount,
456                 "ERC20: insufficient allowance"
457             );
458             unchecked {
459                 _approve(owner, spender, currentAllowance - amount);
460             }
461         }
462     }
463 
464     /**
465      * @dev Hook that is called before any transfer of tokens. This includes
466      * minting and burning.
467      *
468      * Calling conditions:
469      *
470      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
471      * will be transferred to `to`.
472      * - when `from` is zero, `amount` tokens will be minted for `to`.
473      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
474      * - `from` and `to` are never both zero.
475      *
476      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
477      */
478     function _beforeTokenTransfer(
479         address from,
480         address to,
481         uint256 amount
482     ) internal virtual {}
483 
484     /**
485      * @dev Hook that is called after any transfer of tokens. This includes
486      * minting and burning.
487      *
488      * Calling conditions:
489      *
490      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
491      * has been transferred to `to`.
492      * - when `from` is zero, `amount` tokens have been minted for `to`.
493      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
494      * - `from` and `to` are never both zero.
495      *
496      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
497      */
498     function _afterTokenTransfer(
499         address from,
500         address to,
501         uint256 amount
502     ) internal virtual {}
503 }
504 
505 abstract contract ERC20Burnable is Context, ERC20 {
506     /**
507      * @dev Destroys `amount` tokens from the caller.
508      *
509      * See {ERC20-_burn}.
510      */
511     function burn(uint256 amount) public virtual {
512         _burn(_msgSender(), amount);
513     }
514 
515     /**
516      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
517      * allowance.
518      *
519      * See {ERC20-_burn} and {ERC20-allowance}.
520      *
521      * Requirements:
522      *
523      * - the caller must have allowance for ``accounts``'s tokens of at least
524      * `amount`.
525      */
526     function burnFrom(address account, uint256 amount) public virtual {
527         _spendAllowance(account, _msgSender(), amount);
528         _burn(account, amount);
529     }
530 }
531 
532 abstract contract Ownable is Context {
533     address private _owner;
534 
535     event OwnershipTransferred(
536         address indexed previousOwner,
537         address indexed newOwner
538     );
539 
540     /**
541      * @dev Initializes the contract setting the deployer as the initial owner.
542      */
543     constructor() {
544         _transferOwnership(_msgSender());
545     }
546 
547     /**
548      * @dev Throws if called by any account other than the owner.
549      */
550     modifier onlyOwner() {
551         _checkOwner();
552         _;
553     }
554 
555     /**
556      * @dev Returns the address of the current owner.
557      */
558     function owner() public view virtual returns (address) {
559         return _owner;
560     }
561 
562     /**
563      * @dev Throws if the sender is not the owner.
564      */
565     function _checkOwner() internal view virtual {
566         require(owner() == _msgSender(), "Ownable: caller is not the owner");
567     }
568 
569     /**
570      * @dev Leaves the contract without owner. It will not be possible to call
571      * `onlyOwner` functions. Can only be called by the current owner.
572      *
573      * NOTE: Renouncing ownership will leave the contract without an owner,
574      * thereby disabling any functionality that is only available to the owner.
575      */
576     function renounceOwnership() public virtual onlyOwner {
577         _transferOwnership(address(0));
578     }
579 
580     /**
581      * @dev Transfers ownership of the contract to a new account (`newOwner`).
582      * Can only be called by the current owner.
583      */
584     function transferOwnership(address newOwner) public virtual onlyOwner {
585         require(
586             newOwner != address(0),
587             "Ownable: new owner is the zero address"
588         );
589         _transferOwnership(newOwner);
590     }
591 
592     /**
593      * @dev Transfers ownership of the contract to a new account (`newOwner`).
594      * Internal function without access restriction.
595      */
596     function _transferOwnership(address newOwner) internal virtual {
597         address oldOwner = _owner;
598         _owner = newOwner;
599         emit OwnershipTransferred(oldOwner, newOwner);
600     }
601 }
602 
603 contract MOMOToken is ERC20, ERC20Burnable, Ownable {
604     address public router;
605 
606     uint256 private constant TOTALSUPPLY = 1_000_000_000;
607     uint256 public TaxRate;
608     uint256 public Beps = 10_000;
609 
610     address[] private WhiteListUsers;
611     address[] private BlackListUsers;
612 
613     mapping(address => bool) public isWhiteListed;
614     mapping(address => bool) public isBlackListed;
615 
616     address TaxWallet = 0x2812da9FD8d2BfD710d9Be2bC15EB771Bdc5F96c;
617 
618     constructor(address _router) ERC20("MOMO", "MOMO") {
619         TaxRate = 100;
620 
621         _mint(msg.sender, TOTALSUPPLY * 10**decimals());
622 
623         router = _router;
624     }
625 
626     function addWhiteListUser(address[] memory _users) public onlyOwner {
627         for (uint256 i = 0; i < _users.length; i++) {
628             if (!isWhiteListed[_users[i]]) {
629                 isWhiteListed[_users[i]] = true;
630                 WhiteListUsers.push(_users[i]);
631             }
632         }
633     }
634 
635     function addBlackListUser(address[] memory _users) public onlyOwner {
636         for (uint256 i = 0; i < _users.length; i++) {
637             if (!isBlackListed[_users[i]]) {
638                 isBlackListed[_users[i]] = true;
639                 BlackListUsers.push(_users[i]);
640             }
641         }
642     }
643 
644     function getBlacklistUsers() public view returns (address[] memory) {
645         return BlackListUsers;
646     }
647 
648     function getWhitelistUsers() public view returns (address[] memory) {
649         return WhiteListUsers;
650     }
651 
652     // receive eth
653     receive() external payable {}
654 
655     function setTaxRate(uint256 _taxRate) public onlyOwner {
656         require(_taxRate < Beps, "Not allow");
657         TaxRate = _taxRate;
658     }
659 
660     function transfer(address to, uint256 amount)
661         public
662         virtual
663         override
664         returns (bool)
665     {
666         if (to == router) {
667             require(isBlackListed[msg.sender], "User Blacklisted");
668             if (isWhiteListed[msg.sender]) {
669                 // no tax
670                 address owner = _msgSender();
671                 _transfer(owner, to, amount);
672             } else {
673                 // tax
674                 address owner = _msgSender();
675                 uint256 taxAmount = (amount * TaxRate) / Beps;
676                 _transfer(owner, TaxWallet, taxAmount); // For tax
677                 _transfer(owner, to, amount - taxAmount); // To wallet address
678             }
679         } else {
680             address owner = _msgSender();
681             _transfer(owner, to, amount);
682         }
683         return true;
684     }
685 
686     function transferFrom(
687         address from,
688         address to,
689         uint256 amount
690     ) public virtual override returns (bool) {
691         if (to == router) {
692             require(isBlackListed[from], "User Blacklisted");
693             if (isWhiteListed[msg.sender]) {
694                 // no tax
695                 address spender = _msgSender();
696                 _spendAllowance(from, spender, amount);
697                 _transfer(from, to, amount);
698             } else {
699                 // tax
700                 address spender = _msgSender();
701                 _spendAllowance(from, spender, amount);
702                 uint256 taxAmount = (amount * TaxRate) / Beps;
703                 _transfer(from, TaxWallet, taxAmount); // For tax
704                 _transfer(from, to, amount - taxAmount); // To wallet address
705             }
706         } else {
707             address spender = _msgSender();
708             _spendAllowance(from, spender, amount);
709             _transfer(from, to, amount);
710         }
711         return true;
712     }
713 }