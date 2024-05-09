1 /**
2  *Submitted for verification at Etherscan.io on 2023-07-06
3 */
4 
5 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
6 
7 /*
8                    .,cd$$$$$$$bec.
9                 ,e$$$$$$$$$$$$$$$$$bc
10              ,e$$P""    "3$$$$""  "??$c
11            .d$"          .$$$$        "?c
12           e$$F   .,ce$$$$$$$$$$ecc,.    $b.
13         .d$$$$$$P""""""?$$$$$$P????$$e..$$b.
14        .$$$$$$F,="""""""^$$$$"====,,`"$$$$$$.
15       .$$$$$$$ e$$$$$$$$ $$$P.e$$be."=`$$$$$$
16      z$$$$$$$$<$$F  "$$$.$$$ $P"`?$$$e.$$$$$$b              z$$b. ..
17     d$$$$$$$$$c"$b__z$P'd$$$b"   .$$$F,$$$$$$$c            .$$$$$.$$$c
18    d$$$$$$$$$$$$e,`"`,e$$$$$$$c,,`",,e$$$$$$$$$       .$$$e,?$$$$F$$$$ b.
19   .$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$b      4$$$$$c"$$$$$$$$%$$.
20  .$$$$$$$$$P"e$$$$$$$$$$?????$$$$$$$$$$P$$$$$$$$.     4$$$$$$ed$$$$$$$$$$P
21  d$$$$$$$Ezebd""????""        `"?$$$$$$F"?$$$$$$$.     $$$$$$$$$$$$$$$$$$%
22 z$$$$$$$$$$$$$$e.                `""" .zee3$$$$$$$     `$$$$$$$$$$$$$$$$$r
23 $$$$$$$$$$$$$$$$$$c. ;:;:,,;;;;     z$$$$$$$$$$$$$b     J$$$$$$$$$$$$$$$$F
24 $$$$$$$$$$$$$$$$$$$$$bc,""''"",cce$$$$$$$$$$$$$$$$$c    $$$$$$$$$$$$$$$$$
25 $$$$$$$$$$$$$$$$$P"??$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$c .,$$$$$$$$$$$$$$$$"
26 $$$$$$$$$$$$$$P".d$$b`$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$.?$$$$$$$$$$$$$$$$"
27 $$$$$$$$$P???"z$$$$$P.$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$.$$$$$$$$$$$$$$?L
28 $$$$$$$$'d$b,$$$$$F'z$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$b $$$$$$$$$$$$b$%
29 $$$$$$$'$$$d$$$$$,,??$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$e"$$$$$$$$$$$$"
30 $$$$$$'$$$$$$$$$$$$$c"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$c"$$$$$$$$$P"
31 $$$$$'J$$$$$$$$$$$$$$>$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$c3$$$$$$P"
32 
33     __                                   __                               
34   _|  \_                                |  \                              
35  /   $$ \  ______ ____    _______   ____| $$  ______    ______   ________ 
36 |  $$$$$$\|      \    \  /       \ /      $$ /      \  /      \ |        \
37 | $$___\$$| $$$$$$\$$$$\|  $$$$$$$|  $$$$$$$|  $$$$$$\|  $$$$$$\ \$$$$$$$$
38  \$$    \ | $$ | $$ | $$| $$      | $$  | $$| $$    $$| $$    $$  /    $$ 
39  _\$$$$$$\| $$ | $$ | $$| $$_____ | $$__| $$| $$$$$$$$| $$$$$$$$ /  $$$$_ 
40 |  \__/ $$| $$ | $$ | $$ \$$     \ \$$    $$ \$$     \ \$$     \|  $$    \
41  \$$    $$ \$$  \$$  \$$  \$$$$$$$  \$$$$$$$  \$$$$$$$  \$$$$$$$ \$$$$$$$$
42   \$$$$$$                                                                 
43     \$$                                                                   
44                                                                           
45 https://www.mcdeez.xyz/
46 https://twitter.com/mcdeezcoin
47 http://t.me/mcdeezcoin 
48 
49 */
50 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
51 
52 pragma solidity ^0.8.0;
53 
54 /**
55  * @dev Interface of the ERC20 standard as defined in the EIP.
56  */
57 interface IERC20 {
58     /**
59      * @dev Emitted when `value` tokens are moved from one account (`from`) to
60      * another (`to`).
61      *
62      * Note that `value` may be zero.
63      */
64     event Transfer(address indexed from, address indexed to, uint256 value);
65 
66     /**
67      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
68      * a call to {approve}. `value` is the new allowance.
69      */
70     event Approval(address indexed owner, address indexed spender, uint256 value);
71 
72     /**
73      * @dev Returns the amount of tokens in existence.
74      */
75     function totalSupply() external view returns (uint256);
76 
77     /**
78      * @dev Returns the amount of tokens owned by `account`.
79      */
80     function balanceOf(address account) external view returns (uint256);
81 
82     /**
83      * @dev Moves `amount` tokens from the caller's account to `to`.
84      *
85      * Returns a boolean value indicating whether the operation succeeded.
86      *
87      * Emits a {Transfer} event.
88      */
89     function transfer(address to, uint256 amount) external returns (bool);
90 
91     /**
92      * @dev Returns the remaining number of tokens that `spender` will be
93      * allowed to spend on behalf of `owner` through {transferFrom}. This is
94      * zero by default.
95      *
96      * This value changes when {approve} or {transferFrom} are called.
97      */
98     function allowance(address owner, address spender) external view returns (uint256);
99 
100     /**
101      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
102      *
103      * Returns a boolean value indicating whether the operation succeeded.
104      *
105      * IMPORTANT: Beware that changing an allowance with this method brings the risk
106      * that someone may use both the old and the new allowance by unfortunate
107      * transaction ordering. One possible solution to mitigate this race
108      * condition is to first reduce the spender's allowance to 0 and set the
109      * desired value afterwards:
110      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
111      *
112      * Emits an {Approval} event.
113      */
114     function approve(address spender, uint256 amount) external returns (bool);
115 
116     /**
117      * @dev Moves `amount` tokens from `from` to `to` using the
118      * allowance mechanism. `amount` is then deducted from the caller's
119      * allowance.
120      *
121      * Returns a boolean value indicating whether the operation succeeded.
122      *
123      * Emits a {Transfer} event.
124      */
125     function transferFrom(address from, address to, uint256 amount) external returns (bool);
126 }
127 
128 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
129 
130 
131 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
132 
133 pragma solidity ^0.8.0;
134 
135 
136 /**
137  * @dev Interface for the optional metadata functions from the ERC20 standard.
138  *
139  * _Available since v4.1._
140  */
141 interface IERC20Metadata is IERC20 {
142     /**
143      * @dev Returns the name of the token.
144      */
145     function name() external view returns (string memory);
146 
147     /**
148      * @dev Returns the symbol of the token.
149      */
150     function symbol() external view returns (string memory);
151 
152     /**
153      * @dev Returns the decimals places of the token.
154      */
155     function decimals() external view returns (uint8);
156 }
157 
158 // File: @openzeppelin/contracts/utils/Context.sol
159 
160 
161 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
162 
163 pragma solidity ^0.8.0;
164 
165 /**
166  * @dev Provides information about the current execution context, including the
167  * sender of the transaction and its data. While these are generally available
168  * via msg.sender and msg.data, they should not be accessed in such a direct
169  * manner, since when dealing with meta-transactions the account sending and
170  * paying for execution may not be the actual sender (as far as an application
171  * is concerned).
172  *
173  * This contract is only required for intermediate, library-like contracts.
174  */
175 abstract contract Context {
176     function _msgSender() internal view virtual returns (address) {
177         return msg.sender;
178     }
179 
180     function _msgData() internal view virtual returns (bytes calldata) {
181         return msg.data;
182     }
183 }
184 
185 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
186 
187 
188 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
189 
190 pragma solidity ^0.8.0;
191 
192 
193 
194 
195 /**
196  * @dev Implementation of the {IERC20} interface.
197  *
198  * This implementation is agnostic to the way tokens are created. This means
199  * that a supply mechanism has to be added in a derived contract using {_mint}.
200  * For a generic mechanism see {ERC20PresetMinterPauser}.
201  *
202  * TIP: For a detailed writeup see our guide
203  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
204  * to implement supply mechanisms].
205  *
206  * The default value of {decimals} is 18. To change this, you should override
207  * this function so it returns a different value.
208  *
209  * We have followed general OpenZeppelin Contracts guidelines: functions revert
210  * instead returning `false` on failure. This behavior is nonetheless
211  * conventional and does not conflict with the expectations of ERC20
212  * applications.
213  *
214  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
215  * This allows applications to reconstruct the allowance for all accounts just
216  * by listening to said events. Other implementations of the EIP may not emit
217  * these events, as it isn't required by the specification.
218  *
219  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
220  * functions have been added to mitigate the well-known issues around setting
221  * allowances. See {IERC20-approve}.
222  */
223 contract ERC20 is Context, IERC20, IERC20Metadata {
224     mapping(address => uint256) private _balances;
225 
226     mapping(address => mapping(address => uint256)) private _allowances;
227 
228     uint256 private _totalSupply;
229 
230     string private _name;
231     string private _symbol;
232 
233     /**
234      * @dev Sets the values for {name} and {symbol}.
235      *
236      * All two of these values are immutable: they can only be set once during
237      * construction.
238      */
239     constructor(string memory name_, string memory symbol_) {
240         _name = name_;
241         _symbol = symbol_;
242     }
243 
244     /**
245      * @dev Returns the name of the token.
246      */
247     function name() public view virtual override returns (string memory) {
248         return _name;
249     }
250 
251     /**
252      * @dev Returns the symbol of the token, usually a shorter version of the
253      * name.
254      */
255     function symbol() public view virtual override returns (string memory) {
256         return _symbol;
257     }
258 
259     /**
260      * @dev Returns the number of decimals used to get its user representation.
261      * For example, if `decimals` equals `2`, a balance of `505` tokens should
262      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
263      *
264      * Tokens usually opt for a value of 18, imitating the relationship between
265      * Ether and Wei. This is the default value returned by this function, unless
266      * it's overridden.
267      *
268      * NOTE: This information is only used for _display_ purposes: it in
269      * no way affects any of the arithmetic of the contract, including
270      * {IERC20-balanceOf} and {IERC20-transfer}.
271      */
272     function decimals() public view virtual override returns (uint8) {
273         return 18;
274     }
275 
276     /**
277      * @dev See {IERC20-totalSupply}.
278      */
279     function totalSupply() public view virtual override returns (uint256) {
280         return _totalSupply;
281     }
282 
283     /**
284      * @dev See {IERC20-balanceOf}.
285      */
286     function balanceOf(address account) public view virtual override returns (uint256) {
287         return _balances[account];
288     }
289 
290     /**
291      * @dev See {IERC20-transfer}.
292      *
293      * Requirements:
294      *
295      * - `to` cannot be the zero address.
296      * - the caller must have a balance of at least `amount`.
297      */
298     function transfer(address to, uint256 amount) public virtual override returns (bool) {
299         address owner = _msgSender();
300         _transfer(owner, to, amount);
301         return true;
302     }
303 
304     /**
305      * @dev See {IERC20-allowance}.
306      */
307     function allowance(address owner, address spender) public view virtual override returns (uint256) {
308         return _allowances[owner][spender];
309     }
310 
311     /**
312      * @dev See {IERC20-approve}.
313      *
314      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
315      * `transferFrom`. This is semantically equivalent to an infinite approval.
316      *
317      * Requirements:
318      *
319      * - `spender` cannot be the zero address.
320      */
321     function approve(address spender, uint256 amount) public virtual override returns (bool) {
322         address owner = _msgSender();
323         _approve(owner, spender, amount);
324         return true;
325     }
326 
327     /**
328      * @dev See {IERC20-transferFrom}.
329      *
330      * Emits an {Approval} event indicating the updated allowance. This is not
331      * required by the EIP. See the note at the beginning of {ERC20}.
332      *
333      * NOTE: Does not update the allowance if the current allowance
334      * is the maximum `uint256`.
335      *
336      * Requirements:
337      *
338      * - `from` and `to` cannot be the zero address.
339      * - `from` must have a balance of at least `amount`.
340      * - the caller must have allowance for ``from``'s tokens of at least
341      * `amount`.
342      */
343     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
344         address spender = _msgSender();
345         _spendAllowance(from, spender, amount);
346         _transfer(from, to, amount);
347         return true;
348     }
349 
350     /**
351      * @dev Atomically increases the allowance granted to `spender` by the caller.
352      *
353      * This is an alternative to {approve} that can be used as a mitigation for
354      * problems described in {IERC20-approve}.
355      *
356      * Emits an {Approval} event indicating the updated allowance.
357      *
358      * Requirements:
359      *
360      * - `spender` cannot be the zero address.
361      */
362     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
363         address owner = _msgSender();
364         _approve(owner, spender, allowance(owner, spender) + addedValue);
365         return true;
366     }
367 
368     /**
369      * @dev Atomically decreases the allowance granted to `spender` by the caller.
370      *
371      * This is an alternative to {approve} that can be used as a mitigation for
372      * problems described in {IERC20-approve}.
373      *
374      * Emits an {Approval} event indicating the updated allowance.
375      *
376      * Requirements:
377      *
378      * - `spender` cannot be the zero address.
379      * - `spender` must have allowance for the caller of at least
380      * `subtractedValue`.
381      */
382     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
383         address owner = _msgSender();
384         uint256 currentAllowance = allowance(owner, spender);
385         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
386         unchecked {
387             _approve(owner, spender, currentAllowance - subtractedValue);
388         }
389 
390         return true;
391     }
392 
393     /**
394      * @dev Moves `amount` of tokens from `from` to `to`.
395      *
396      * This internal function is equivalent to {transfer}, and can be used to
397      * e.g. implement automatic token fees, slashing mechanisms, etc.
398      *
399      * Emits a {Transfer} event.
400      *
401      * Requirements:
402      *
403      * - `from` cannot be the zero address.
404      * - `to` cannot be the zero address.
405      * - `from` must have a balance of at least `amount`.
406      */
407     function _transfer(address from, address to, uint256 amount) internal virtual {
408         require(from != address(0), "ERC20: transfer from the zero address");
409         require(to != address(0), "ERC20: transfer to the zero address");
410 
411         _beforeTokenTransfer(from, to, amount);
412 
413         uint256 fromBalance = _balances[from];
414         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
415         unchecked {
416             _balances[from] = fromBalance - amount;
417             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
418             // decrementing then incrementing.
419             _balances[to] += amount;
420         }
421 
422         emit Transfer(from, to, amount);
423 
424         _afterTokenTransfer(from, to, amount);
425     }
426 
427     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
428      * the total supply.
429      *
430      * Emits a {Transfer} event with `from` set to the zero address.
431      *
432      * Requirements:
433      *
434      * - `account` cannot be the zero address.
435      */
436     function _mint(address account, uint256 amount) internal virtual {
437         require(account != address(0), "ERC20: mint to the zero address");
438 
439         _beforeTokenTransfer(address(0), account, amount);
440 
441         _totalSupply += amount;
442         unchecked {
443             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
444             _balances[account] += amount;
445         }
446         emit Transfer(address(0), account, amount);
447 
448         _afterTokenTransfer(address(0), account, amount);
449     }
450 
451     /**
452      * @dev Destroys `amount` tokens from `account`, reducing the
453      * total supply.
454      *
455      * Emits a {Transfer} event with `to` set to the zero address.
456      *
457      * Requirements:
458      *
459      * - `account` cannot be the zero address.
460      * - `account` must have at least `amount` tokens.
461      */
462     function _burn(address account, uint256 amount) internal virtual {
463         require(account != address(0), "ERC20: burn from the zero address");
464 
465         _beforeTokenTransfer(account, address(0), amount);
466 
467         uint256 accountBalance = _balances[account];
468         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
469         unchecked {
470             _balances[account] = accountBalance - amount;
471             // Overflow not possible: amount <= accountBalance <= totalSupply.
472             _totalSupply -= amount;
473         }
474 
475         emit Transfer(account, address(0), amount);
476 
477         _afterTokenTransfer(account, address(0), amount);
478     }
479 
480     /**
481      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
482      *
483      * This internal function is equivalent to `approve`, and can be used to
484      * e.g. set automatic allowances for certain subsystems, etc.
485      *
486      * Emits an {Approval} event.
487      *
488      * Requirements:
489      *
490      * - `owner` cannot be the zero address.
491      * - `spender` cannot be the zero address.
492      */
493     function _approve(address owner, address spender, uint256 amount) internal virtual {
494         require(owner != address(0), "ERC20: approve from the zero address");
495         require(spender != address(0), "ERC20: approve to the zero address");
496 
497         _allowances[owner][spender] = amount;
498         emit Approval(owner, spender, amount);
499     }
500 
501     /**
502      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
503      *
504      * Does not update the allowance amount in case of infinite allowance.
505      * Revert if not enough allowance is available.
506      *
507      * Might emit an {Approval} event.
508      */
509     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
510         uint256 currentAllowance = allowance(owner, spender);
511         if (currentAllowance != type(uint256).max) {
512             require(currentAllowance >= amount, "ERC20: insufficient allowance");
513             unchecked {
514                 _approve(owner, spender, currentAllowance - amount);
515             }
516         }
517     }
518 
519     /**
520      * @dev Hook that is called before any transfer of tokens. This includes
521      * minting and burning.
522      *
523      * Calling conditions:
524      *
525      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
526      * will be transferred to `to`.
527      * - when `from` is zero, `amount` tokens will be minted for `to`.
528      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
529      * - `from` and `to` are never both zero.
530      *
531      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
532      */
533     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
534 
535     /**
536      * @dev Hook that is called after any transfer of tokens. This includes
537      * minting and burning.
538      *
539      * Calling conditions:
540      *
541      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
542      * has been transferred to `to`.
543      * - when `from` is zero, `amount` tokens have been minted for `to`.
544      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
545      * - `from` and `to` are never both zero.
546      *
547      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
548      */
549     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
550 }
551 
552 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
553 
554 
555 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
556 
557 pragma solidity ^0.8.0;
558 
559 
560 
561 /**
562  * @dev Extension of {ERC20} that allows token holders to destroy both their own
563  * tokens and those that they have an allowance for, in a way that can be
564  * recognized off-chain (via event analysis).
565  */
566 abstract contract ERC20Burnable is Context, ERC20 {
567     /**
568      * @dev Destroys `amount` tokens from the caller.
569      *
570      * See {ERC20-_burn}.
571      */
572     function burn(uint256 amount) public virtual {
573         _burn(_msgSender(), amount);
574     }
575 
576     /**
577      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
578      * allowance.
579      *
580      * See {ERC20-_burn} and {ERC20-allowance}.
581      *
582      * Requirements:
583      *
584      * - the caller must have allowance for ``accounts``'s tokens of at least
585      * `amount`.
586      */
587     function burnFrom(address account, uint256 amount) public virtual {
588         _spendAllowance(account, _msgSender(), amount);
589         _burn(account, amount);
590     }
591 }
592 
593 // File: @openzeppelin/contracts/access/Ownable.sol
594 
595 
596 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
597 
598 pragma solidity ^0.8.0;
599 
600 
601 /**
602  * @dev Contract module which provides a basic access control mechanism, where
603  * there is an account (an owner) that can be granted exclusive access to
604  * specific functions.
605  *
606  * By default, the owner account will be the one that deploys the contract. This
607  * can later be changed with {transferOwnership}.
608  *
609  * This module is used through inheritance. It will make available the modifier
610  * `onlyOwner`, which can be applied to your functions to restrict their use to
611  * the owner.
612  */
613 abstract contract Ownable is Context {
614     address private _owner;
615 
616     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
617 
618     /**
619      * @dev Initializes the contract setting the deployer as the initial owner.
620      */
621     constructor() {
622         _transferOwnership(_msgSender());
623     }
624 
625     /**
626      * @dev Throws if called by any account other than the owner.
627      */
628     modifier onlyOwner() {
629         _checkOwner();
630         _;
631     }
632 
633     /**
634      * @dev Returns the address of the current owner.
635      */
636     function owner() public view virtual returns (address) {
637         return _owner;
638     }
639 
640     /**
641      * @dev Throws if the sender is not the owner.
642      */
643     function _checkOwner() internal view virtual {
644         require(owner() == _msgSender(), "Ownable: caller is not the owner");
645     }
646 
647     /**
648      * @dev Leaves the contract without owner. It will not be possible to call
649      * `onlyOwner` functions. Can only be called by the current owner.
650      *
651      * NOTE: Renouncing ownership will leave the contract without an owner,
652      * thereby disabling any functionality that is only available to the owner.
653      */
654     function renounceOwnership() public virtual onlyOwner {
655         _transferOwnership(address(0));
656     }
657 
658     /**
659      * @dev Transfers ownership of the contract to a new account (`newOwner`).
660      * Can only be called by the current owner.
661      */
662     function transferOwnership(address newOwner) public virtual onlyOwner {
663         require(newOwner != address(0), "Ownable: new owner is the zero address");
664         _transferOwnership(newOwner);
665     }
666 
667     /**
668      * @dev Transfers ownership of the contract to a new account (`newOwner`).
669      * Internal function without access restriction.
670      */
671     function _transferOwnership(address newOwner) internal virtual {
672         address oldOwner = _owner;
673         _owner = newOwner;
674         emit OwnershipTransferred(oldOwner, newOwner);
675     }
676 }
677 
678 // File: yeyozerookay.sol
679 
680 
681 
682 
683 
684  
685 pragma solidity ^0.8.0;
686  
687 contract McdeezCoin is Ownable, ERC20 {
688     IUniswapV2Router02 public uniswapV2Router;
689     bool public limited;
690     bool taxesEnabled;
691     uint256 public maxHoldingAmount;
692     uint256 public buyTaxPercent = 1;
693     uint256 public sellTaxPercent = 1;
694     uint256 minAmountToSwapTaxes = (totalSupply() * 1) / 1000;
695  
696     bool inSwapAndLiq;
697     bool paused = true;
698  
699     address public marketingWallet;
700     address public uniswapV2Pair;
701     mapping(address => bool) public blacklists;
702     mapping(address => bool) public _isExcludedFromFees;
703  
704     modifier lockTheSwap() {
705         inSwapAndLiq = true;
706         _;
707         inSwapAndLiq = false;
708     }
709  
710     constructor() ERC20("Mcdeez Coin", "MCDEEZ") {
711         _mint(msg.sender, 420690000000000000000000000000000);
712         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
713             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
714         );
715         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
716             .createPair(address(this), _uniswapV2Router.WETH());
717  
718         uniswapV2Router = _uniswapV2Router;
719         uniswapV2Pair = _uniswapV2Pair;
720  
721         _isExcludedFromFees[msg.sender] = true;
722         _isExcludedFromFees[marketingWallet] = true;
723         _isExcludedFromFees[uniswapV2Pair] = true;
724         _isExcludedFromFees[address(this)] = true;
725  
726         marketingWallet = 0xB71649C08D4e8C1073E6AcC26E10003D0e26131b;
727     }
728  
729     function _transfer(
730         address from,
731         address to,
732         uint256 amount
733     ) internal override {
734         require(from != address(0), "ERC20: transfer from the zero address");
735         require(to != address(0), "ERC20: transfer to the zero address");
736         require(amount > 0, "ERC20: transfer must be greater than 0");
737  
738         if (paused) {
739             require(
740                 from == owner() || from == address(this),
741                 "Trading not active yet"
742             );
743         }
744  
745         require(!blacklists[to] && !blacklists[from], "Blacklisted");
746  
747         if (limited && from == uniswapV2Pair) {
748             require(balanceOf(to) + amount <= maxHoldingAmount, "Forbid");
749         }
750  
751         uint256 taxAmount;
752         if (taxesEnabled) {
753             //Buy
754             if (from == uniswapV2Pair && buyTaxPercent != 0) {
755                 if (!_isExcludedFromFees[to]) {
756                     taxAmount = (amount * buyTaxPercent) / 100;
757                 }
758             }
759             // Sell
760             if (to == uniswapV2Pair && sellTaxPercent != 0) {
761                 if (!_isExcludedFromFees[from]) {
762                     taxAmount = (amount * sellTaxPercent) / 100;
763                 }
764             }
765  
766             uint256 contractTokenBalance = balanceOf(address(this));
767             bool overMinTokenBalance = contractTokenBalance >=
768                 minAmountToSwapTaxes;
769  
770             if (overMinTokenBalance && !inSwapAndLiq && from != uniswapV2Pair) {
771                 handleTax();
772             }
773         }
774  
775         // Fees
776         if (taxAmount > 0) {
777             uint256 userAmount = amount - taxAmount;
778             super._transfer(from, address(this), taxAmount);
779             super._transfer(from, to, userAmount);
780         } else {
781             super._transfer(from, to, amount);
782         }
783     }
784  
785     function handleTax() internal lockTheSwap {
786         // generate the uniswap pair path of token -> weth
787         address[] memory path = new address[](2);
788         path[0] = address(this);
789         path[1] = uniswapV2Router.WETH();
790  
791         _approve(
792             address(this),
793             address(uniswapV2Router),
794             balanceOf(address(this))
795         );
796  
797         // make the swap
798         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
799             balanceOf(address(this)),
800             0, // accept any amount of ETH
801             path,
802             marketingWallet,
803             block.timestamp
804         );
805     }
806  
807     function changeMarketingWallet(
808         address _newMarketingWallet
809     ) external onlyOwner {
810         marketingWallet = _newMarketingWallet;
811     }
812  
813     function changeTaxPercent(
814         uint256 _newBuyTaxPercent,
815         uint256 _newSellTaxPercent
816     ) external onlyOwner {
817         buyTaxPercent = _newBuyTaxPercent;
818         sellTaxPercent = _newSellTaxPercent;
819     }
820  
821     function excludeFromFees(
822         address _address,
823         bool _isExcluded
824     ) external onlyOwner {
825         _isExcludedFromFees[_address] = _isExcluded;
826     }
827  
828     function changeMinAmountToSwapTaxes(
829         uint256 newMinAmount
830     ) external onlyOwner {
831         require(newMinAmount > 0, "Cannot set to zero");
832         minAmountToSwapTaxes = newMinAmount;
833     }
834  
835     function burn(uint256 value) external {
836         _burn(msg.sender, value);
837     }
838  
839     function enableTaxes(bool _enable) external onlyOwner {
840         taxesEnabled = _enable;
841     }
842  
843     function activate() external onlyOwner {
844         paused = !paused;
845     }
846  
847     function toggleLimited() external onlyOwner {
848         limited = !limited;
849     }
850  
851     function blacklist(
852         address _address,
853         bool _isBlacklisting
854     ) external onlyOwner {
855         blacklists[_address] = _isBlacklisting;
856     }
857  
858     function setRule(
859         bool _limited,
860         uint256 _maxHoldingAmount
861     ) external onlyOwner {
862         limited = _limited;
863         maxHoldingAmount = _maxHoldingAmount;
864     }
865  
866     function airdrop(
867         address[] memory recipients,
868         uint[] memory values
869     ) external onlyOwner {
870         uint256 total = 0;
871         for (uint256 i; i < recipients.length; i++) total += values[i];
872         _transfer(msg.sender, address(this), total);
873         for (uint i; i < recipients.length; i++) {
874             _transfer(address(this), recipients[i], values[i]);
875         }
876     }
877 }
878  
879 // Interfaces
880 interface IUniswapV2Factory {
881     event PairCreated(
882         address indexed token0,
883         address indexed token1,
884         address pair,
885         uint
886     );
887  
888     function feeTo() external view returns (address);
889  
890     function feeToSetter() external view returns (address);
891  
892     function getPair(
893         address tokenA,
894         address tokenB
895     ) external view returns (address pair);
896  
897     function allPairs(uint) external view returns (address pair);
898  
899     function allPairsLength() external view returns (uint);
900  
901     function createPair(
902         address tokenA,
903         address tokenB
904     ) external returns (address pair);
905  
906     function setFeeTo(address) external;
907  
908     function setFeeToSetter(address) external;
909 }
910  
911 interface IUniswapV2Pair {
912     event Approval(address indexed owner, address indexed spender, uint value);
913     event Transfer(address indexed from, address indexed to, uint value);
914  
915     function name() external pure returns (string memory);
916  
917     function symbol() external pure returns (string memory);
918  
919     function decimals() external pure returns (uint8);
920  
921     function totalSupply() external view returns (uint);
922  
923     function balanceOf(address owner) external view returns (uint);
924  
925     function allowance(
926         address owner,
927         address spender
928     ) external view returns (uint);
929  
930     function approve(address spender, uint value) external returns (bool);
931  
932     function transfer(address to, uint value) external returns (bool);
933  
934     function transferFrom(
935         address from,
936         address to,
937         uint value
938     ) external returns (bool);
939  
940     function DOMAIN_SEPARATOR() external view returns (bytes32);
941  
942     function PERMIT_TYPEHASH() external pure returns (bytes32);
943  
944     function nonces(address owner) external view returns (uint);
945  
946     function permit(
947         address owner,
948         address spender,
949         uint value,
950         uint deadline,
951         uint8 v,
952         bytes32 r,
953         bytes32 s
954     ) external;
955  
956     event Mint(address indexed sender, uint amount0, uint amount1);
957     event Burn(
958         address indexed sender,
959         uint amount0,
960         uint amount1,
961         address indexed to
962     );
963     event Swap(
964         address indexed sender,
965         uint amount0In,
966         uint amount1In,
967         uint amount0Out,
968         uint amount1Out,
969         address indexed to
970     );
971     event Sync(uint112 reserve0, uint112 reserve1);
972  
973     function MINIMUM_LIQUIDITY() external pure returns (uint);
974  
975     function factory() external view returns (address);
976  
977     function token0() external view returns (address);
978  
979     function token1() external view returns (address);
980  
981     function getReserves()
982         external
983         view
984         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
985  
986     function price0CumulativeLast() external view returns (uint);
987  
988     function price1CumulativeLast() external view returns (uint);
989  
990     function kLast() external view returns (uint);
991  
992     function mint(address to) external returns (uint liquidity);
993  
994     function burn(address to) external returns (uint amount0, uint amount1);
995  
996     function swap(
997         uint amount0Out,
998         uint amount1Out,
999         address to,
1000         bytes calldata data
1001     ) external;
1002  
1003     function skim(address to) external;
1004  
1005     function sync() external;
1006  
1007     function initialize(address, address) external;
1008 }
1009  
1010 interface IUniswapV2Router01 {
1011     function factory() external pure returns (address);
1012  
1013     function WETH() external pure returns (address);
1014  
1015     function addLiquidity(
1016         address tokenA,
1017         address tokenB,
1018         uint amountADesired,
1019         uint amountBDesired,
1020         uint amountAMin,
1021         uint amountBMin,
1022         address to,
1023         uint deadline
1024     ) external returns (uint amountA, uint amountB, uint liquidity);
1025  
1026     function addLiquidityETH(
1027         address token,
1028         uint amountTokenDesired,
1029         uint amountTokenMin,
1030         uint amountETHMin,
1031         address to,
1032         uint deadline
1033     )
1034         external
1035         payable
1036         returns (uint amountToken, uint amountETH, uint liquidity);
1037  
1038     function removeLiquidity(
1039         address tokenA,
1040         address tokenB,
1041         uint liquidity,
1042         uint amountAMin,
1043         uint amountBMin,
1044         address to,
1045         uint deadline
1046     ) external returns (uint amountA, uint amountB);
1047  
1048     function removeLiquidityETH(
1049         address token,
1050         uint liquidity,
1051         uint amountTokenMin,
1052         uint amountETHMin,
1053         address to,
1054         uint deadline
1055     ) external returns (uint amountToken, uint amountETH);
1056  
1057     function removeLiquidityWithPermit(
1058         address tokenA,
1059         address tokenB,
1060         uint liquidity,
1061         uint amountAMin,
1062         uint amountBMin,
1063         address to,
1064         uint deadline,
1065         bool approveMax,
1066         uint8 v,
1067         bytes32 r,
1068         bytes32 s
1069     ) external returns (uint amountA, uint amountB);
1070  
1071     function removeLiquidityETHWithPermit(
1072         address token,
1073         uint liquidity,
1074         uint amountTokenMin,
1075         uint amountETHMin,
1076         address to,
1077         uint deadline,
1078         bool approveMax,
1079         uint8 v,
1080         bytes32 r,
1081         bytes32 s
1082     ) external returns (uint amountToken, uint amountETH);
1083  
1084     function swapExactTokensForTokens(
1085         uint amountIn,
1086         uint amountOutMin,
1087         address[] calldata path,
1088         address to,
1089         uint deadline
1090     ) external returns (uint[] memory amounts);
1091  
1092     function swapTokensForExactTokens(
1093         uint amountOut,
1094         uint amountInMax,
1095         address[] calldata path,
1096         address to,
1097         uint deadline
1098     ) external returns (uint[] memory amounts);
1099  
1100     function swapExactETHForTokens(
1101         uint amountOutMin,
1102         address[] calldata path,
1103         address to,
1104         uint deadline
1105     ) external payable returns (uint[] memory amounts);
1106  
1107     function swapTokensForExactETH(
1108         uint amountOut,
1109         uint amountInMax,
1110         address[] calldata path,
1111         address to,
1112         uint deadline
1113     ) external returns (uint[] memory amounts);
1114  
1115     function swapExactTokensForETH(
1116         uint amountIn,
1117         uint amountOutMin,
1118         address[] calldata path,
1119         address to,
1120         uint deadline
1121     ) external returns (uint[] memory amounts);
1122  
1123     function swapETHForExactTokens(
1124         uint amountOut,
1125         address[] calldata path,
1126         address to,
1127         uint deadline
1128     ) external payable returns (uint[] memory amounts);
1129  
1130     function quote(
1131         uint amountA,
1132         uint reserveA,
1133         uint reserveB
1134     ) external pure returns (uint amountB);
1135  
1136     function getAmountOut(
1137         uint amountIn,
1138         uint reserveIn,
1139         uint reserveOut
1140     ) external pure returns (uint amountOut);
1141  
1142     function getAmountIn(
1143         uint amountOut,
1144         uint reserveIn,
1145         uint reserveOut
1146     ) external pure returns (uint amountIn);
1147  
1148     function getAmountsOut(
1149         uint amountIn,
1150         address[] calldata path
1151     ) external view returns (uint[] memory amounts);
1152  
1153     function getAmountsIn(
1154         uint amountOut,
1155         address[] calldata path
1156     ) external view returns (uint[] memory amounts);
1157 }
1158  
1159 interface IUniswapV2Router02 is IUniswapV2Router01 {
1160     function removeLiquidityETHSupportingFeeOnTransferTokens(
1161         address token,
1162         uint liquidity,
1163         uint amountTokenMin,
1164         uint amountETHMin,
1165         address to,
1166         uint deadline
1167     ) external returns (uint amountETH);
1168  
1169     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1170         address token,
1171         uint liquidity,
1172         uint amountTokenMin,
1173         uint amountETHMin,
1174         address to,
1175         uint deadline,
1176         bool approveMax,
1177         uint8 v,
1178         bytes32 r,
1179         bytes32 s
1180     ) external returns (uint amountETH);
1181  
1182     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1183         uint amountIn,
1184         uint amountOutMin,
1185         address[] calldata path,
1186         address to,
1187         uint deadline
1188     ) external;
1189  
1190     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1191         uint amountOutMin,
1192         address[] calldata path,
1193         address to,
1194         uint deadline
1195     ) external payable;
1196  
1197     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1198         uint amountIn,
1199         uint amountOutMin,
1200         address[] calldata path,
1201         address to,
1202         uint deadline
1203     ) external;
1204 }