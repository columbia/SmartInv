1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(
67         address sender,
68         address recipient,
69         uint256 amount
70     ) external returns (bool);
71 
72     /**
73      * @dev Emitted when `value` tokens are moved from one account (`from`) to
74      * another (`to`).
75      *
76      * Note that `value` may be zero.
77      */
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     /**
81      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
82      * a call to {approve}. `value` is the new allowance.
83      */
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
88 
89 
90 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
91 
92 pragma solidity ^0.8.0;
93 
94 
95 /**
96  * @dev Interface for the optional metadata functions from the ERC20 standard.
97  *
98  * _Available since v4.1._
99  */
100 interface IERC20Metadata is IERC20 {
101     /**
102      * @dev Returns the name of the token.
103      */
104     function name() external view returns (string memory);
105 
106     /**
107      * @dev Returns the symbol of the token.
108      */
109     function symbol() external view returns (string memory);
110 
111     /**
112      * @dev Returns the decimals places of the token.
113      */
114     function decimals() external view returns (uint8);
115 }
116 
117 // File: @openzeppelin/contracts/utils/Context.sol
118 
119 
120 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
121 
122 pragma solidity ^0.8.0;
123 
124 /**
125  * @dev Provides information about the current execution context, including the
126  * sender of the transaction and its data. While these are generally available
127  * via msg.sender and msg.data, they should not be accessed in such a direct
128  * manner, since when dealing with meta-transactions the account sending and
129  * paying for execution may not be the actual sender (as far as an application
130  * is concerned).
131  *
132  * This contract is only required for intermediate, library-like contracts.
133  */
134 abstract contract Context {
135     function _msgSender() internal view virtual returns (address) {
136         return msg.sender;
137     }
138 
139     function _msgData() internal view virtual returns (bytes calldata) {
140         return msg.data;
141     }
142 }
143 
144 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
145 
146 
147 // OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)
148 
149 pragma solidity ^0.8.0;
150 
151 
152 
153 
154 /**
155  * @dev Implementation of the {IERC20} interface.
156  *
157  * This implementation is agnostic to the way tokens are created. This means
158  * that a supply mechanism has to be added in a derived contract using {_mint}.
159  * For a generic mechanism see {ERC20PresetMinterPauser}.
160  *
161  * TIP: For a detailed writeup see our guide
162  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
163  * to implement supply mechanisms].
164  *
165  * We have followed general OpenZeppelin Contracts guidelines: functions revert
166  * instead returning `false` on failure. This behavior is nonetheless
167  * conventional and does not conflict with the expectations of ERC20
168  * applications.
169  *
170  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
171  * This allows applications to reconstruct the allowance for all accounts just
172  * by listening to said events. Other implementations of the EIP may not emit
173  * these events, as it isn't required by the specification.
174  *
175  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
176  * functions have been added to mitigate the well-known issues around setting
177  * allowances. See {IERC20-approve}.
178  */
179 contract ERC20 is Context, IERC20, IERC20Metadata {
180     mapping(address => uint256) private _balances;
181 
182     mapping(address => mapping(address => uint256)) private _allowances;
183 
184     uint256 private _totalSupply;
185 
186     string private _name;
187     string private _symbol;
188 
189     /**
190      * @dev Sets the values for {name} and {symbol}.
191      *
192      * The default value of {decimals} is 18. To select a different value for
193      * {decimals} you should overload it.
194      *
195      * All two of these values are immutable: they can only be set once during
196      * construction.
197      */
198     constructor(string memory name_, string memory symbol_) {
199         _name = name_;
200         _symbol = symbol_;
201     }
202 
203     /**
204      * @dev Returns the name of the token.
205      */
206     function name() public view virtual override returns (string memory) {
207         return _name;
208     }
209 
210     /**
211      * @dev Returns the symbol of the token, usually a shorter version of the
212      * name.
213      */
214     function symbol() public view virtual override returns (string memory) {
215         return _symbol;
216     }
217 
218     /**
219      * @dev Returns the number of decimals used to get its user representation.
220      * For example, if `decimals` equals `2`, a balance of `505` tokens should
221      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
222      *
223      * Tokens usually opt for a value of 18, imitating the relationship between
224      * Ether and Wei. This is the value {ERC20} uses, unless this function is
225      * overridden;
226      *
227      * NOTE: This information is only used for _display_ purposes: it in
228      * no way affects any of the arithmetic of the contract, including
229      * {IERC20-balanceOf} and {IERC20-transfer}.
230      */
231     function decimals() public view virtual override returns (uint8) {
232         return 18;
233     }
234 
235     /**
236      * @dev See {IERC20-totalSupply}.
237      */
238     function totalSupply() public view virtual override returns (uint256) {
239         return _totalSupply;
240     }
241 
242     /**
243      * @dev See {IERC20-balanceOf}.
244      */
245     function balanceOf(address account) public view virtual override returns (uint256) {
246         return _balances[account];
247     }
248 
249     /**
250      * @dev See {IERC20-transfer}.
251      *
252      * Requirements:
253      *
254      * - `recipient` cannot be the zero address.
255      * - the caller must have a balance of at least `amount`.
256      */
257     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
258         _transfer(_msgSender(), recipient, amount);
259         return true;
260     }
261 
262     /**
263      * @dev See {IERC20-allowance}.
264      */
265     function allowance(address owner, address spender) public view virtual override returns (uint256) {
266         return _allowances[owner][spender];
267     }
268 
269     /**
270      * @dev See {IERC20-approve}.
271      *
272      * Requirements:
273      *
274      * - `spender` cannot be the zero address.
275      */
276     function approve(address spender, uint256 amount) public virtual override returns (bool) {
277         _approve(_msgSender(), spender, amount);
278         return true;
279     }
280 
281     /**
282      * @dev See {IERC20-transferFrom}.
283      *
284      * Emits an {Approval} event indicating the updated allowance. This is not
285      * required by the EIP. See the note at the beginning of {ERC20}.
286      *
287      * Requirements:
288      *
289      * - `sender` and `recipient` cannot be the zero address.
290      * - `sender` must have a balance of at least `amount`.
291      * - the caller must have allowance for ``sender``'s tokens of at least
292      * `amount`.
293      */
294     function transferFrom(
295         address sender,
296         address recipient,
297         uint256 amount
298     ) public virtual override returns (bool) {
299         _transfer(sender, recipient, amount);
300 
301         uint256 currentAllowance = _allowances[sender][_msgSender()];
302         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
303         unchecked {
304             _approve(sender, _msgSender(), currentAllowance - amount);
305         }
306 
307         return true;
308     }
309 
310     /**
311      * @dev Atomically increases the allowance granted to `spender` by the caller.
312      *
313      * This is an alternative to {approve} that can be used as a mitigation for
314      * problems described in {IERC20-approve}.
315      *
316      * Emits an {Approval} event indicating the updated allowance.
317      *
318      * Requirements:
319      *
320      * - `spender` cannot be the zero address.
321      */
322     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
323         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
324         return true;
325     }
326 
327     /**
328      * @dev Atomically decreases the allowance granted to `spender` by the caller.
329      *
330      * This is an alternative to {approve} that can be used as a mitigation for
331      * problems described in {IERC20-approve}.
332      *
333      * Emits an {Approval} event indicating the updated allowance.
334      *
335      * Requirements:
336      *
337      * - `spender` cannot be the zero address.
338      * - `spender` must have allowance for the caller of at least
339      * `subtractedValue`.
340      */
341     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
342         uint256 currentAllowance = _allowances[_msgSender()][spender];
343         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
344         unchecked {
345             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
346         }
347 
348         return true;
349     }
350 
351     /**
352      * @dev Moves `amount` of tokens from `sender` to `recipient`.
353      *
354      * This internal function is equivalent to {transfer}, and can be used to
355      * e.g. implement automatic token fees, slashing mechanisms, etc.
356      *
357      * Emits a {Transfer} event.
358      *
359      * Requirements:
360      *
361      * - `sender` cannot be the zero address.
362      * - `recipient` cannot be the zero address.
363      * - `sender` must have a balance of at least `amount`.
364      */
365     function _transfer(
366         address sender,
367         address recipient,
368         uint256 amount
369     ) internal virtual {
370         require(sender != address(0), "ERC20: transfer from the zero address");
371         require(recipient != address(0), "ERC20: transfer to the zero address");
372 
373         _beforeTokenTransfer(sender, recipient, amount);
374 
375         uint256 senderBalance = _balances[sender];
376         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
377         unchecked {
378             _balances[sender] = senderBalance - amount;
379         }
380         _balances[recipient] += amount;
381 
382         emit Transfer(sender, recipient, amount);
383 
384         _afterTokenTransfer(sender, recipient, amount);
385     }
386 
387     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
388      * the total supply.
389      *
390      * Emits a {Transfer} event with `from` set to the zero address.
391      *
392      * Requirements:
393      *
394      * - `account` cannot be the zero address.
395      */
396     function _mint(address account, uint256 amount) internal virtual {
397         require(account != address(0), "ERC20: mint to the zero address");
398 
399         _beforeTokenTransfer(address(0), account, amount);
400 
401         _totalSupply += amount;
402         _balances[account] += amount;
403         emit Transfer(address(0), account, amount);
404 
405         _afterTokenTransfer(address(0), account, amount);
406     }
407 
408     /**
409      * @dev Destroys `amount` tokens from `account`, reducing the
410      * total supply.
411      *
412      * Emits a {Transfer} event with `to` set to the zero address.
413      *
414      * Requirements:
415      *
416      * - `account` cannot be the zero address.
417      * - `account` must have at least `amount` tokens.
418      */
419     function _burn(address account, uint256 amount) internal virtual {
420         require(account != address(0), "ERC20: burn from the zero address");
421 
422         _beforeTokenTransfer(account, address(0), amount);
423 
424         uint256 accountBalance = _balances[account];
425         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
426         unchecked {
427             _balances[account] = accountBalance - amount;
428         }
429         _totalSupply -= amount;
430 
431         emit Transfer(account, address(0), amount);
432 
433         _afterTokenTransfer(account, address(0), amount);
434     }
435 
436     /**
437      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
438      *
439      * This internal function is equivalent to `approve`, and can be used to
440      * e.g. set automatic allowances for certain subsystems, etc.
441      *
442      * Emits an {Approval} event.
443      *
444      * Requirements:
445      *
446      * - `owner` cannot be the zero address.
447      * - `spender` cannot be the zero address.
448      */
449     function _approve(
450         address owner,
451         address spender,
452         uint256 amount
453     ) internal virtual {
454         require(owner != address(0), "ERC20: approve from the zero address");
455         require(spender != address(0), "ERC20: approve to the zero address");
456 
457         _allowances[owner][spender] = amount;
458         emit Approval(owner, spender, amount);
459     }
460 
461     /**
462      * @dev Hook that is called before any transfer of tokens. This includes
463      * minting and burning.
464      *
465      * Calling conditions:
466      *
467      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
468      * will be transferred to `to`.
469      * - when `from` is zero, `amount` tokens will be minted for `to`.
470      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
471      * - `from` and `to` are never both zero.
472      *
473      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
474      */
475     function _beforeTokenTransfer(
476         address from,
477         address to,
478         uint256 amount
479     ) internal virtual {}
480 
481     /**
482      * @dev Hook that is called after any transfer of tokens. This includes
483      * minting and burning.
484      *
485      * Calling conditions:
486      *
487      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
488      * has been transferred to `to`.
489      * - when `from` is zero, `amount` tokens have been minted for `to`.
490      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
491      * - `from` and `to` are never both zero.
492      *
493      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
494      */
495     function _afterTokenTransfer(
496         address from,
497         address to,
498         uint256 amount
499     ) internal virtual {}
500 }
501 
502 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
503 
504 
505 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/ERC20Burnable.sol)
506 
507 pragma solidity ^0.8.0;
508 
509 
510 
511 /**
512  * @dev Extension of {ERC20} that allows token holders to destroy both their own
513  * tokens and those that they have an allowance for, in a way that can be
514  * recognized off-chain (via event analysis).
515  */
516 abstract contract ERC20Burnable is Context, ERC20 {
517     /**
518      * @dev Destroys `amount` tokens from the caller.
519      *
520      * See {ERC20-_burn}.
521      */
522     function burn(uint256 amount) public virtual {
523         _burn(_msgSender(), amount);
524     }
525 
526     /**
527      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
528      * allowance.
529      *
530      * See {ERC20-_burn} and {ERC20-allowance}.
531      *
532      * Requirements:
533      *
534      * - the caller must have allowance for ``accounts``'s tokens of at least
535      * `amount`.
536      */
537     function burnFrom(address account, uint256 amount) public virtual {
538         uint256 currentAllowance = allowance(account, _msgSender());
539         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
540         unchecked {
541             _approve(account, _msgSender(), currentAllowance - amount);
542         }
543         _burn(account, amount);
544     }
545 }
546 
547 // File: @openzeppelin/contracts/access/Ownable.sol
548 
549 
550 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
551 
552 pragma solidity ^0.8.0;
553 
554 
555 /**
556  * @dev Contract module which provides a basic access control mechanism, where
557  * there is an account (an owner) that can be granted exclusive access to
558  * specific functions.
559  *
560  * By default, the owner account will be the one that deploys the contract. This
561  * can later be changed with {transferOwnership}.
562  *
563  * This module is used through inheritance. It will make available the modifier
564  * `onlyOwner`, which can be applied to your functions to restrict their use to
565  * the owner.
566  */
567 abstract contract Ownable is Context {
568     address private _owner;
569 
570     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
571 
572     /**
573      * @dev Initializes the contract setting the deployer as the initial owner.
574      */
575     constructor() {
576         _transferOwnership(_msgSender());
577     }
578 
579     /**
580      * @dev Throws if called by any account other than the owner.
581      */
582     modifier onlyOwner() {
583         _checkOwner();
584         _;
585     }
586 
587     /**
588      * @dev Returns the address of the current owner.
589      */
590     function owner() public view virtual returns (address) {
591         return _owner;
592     }
593 
594     /**
595      * @dev Throws if the sender is not the owner.
596      */
597     function _checkOwner() internal view virtual {
598         require(owner() == _msgSender(), "Ownable: caller is not the owner");
599     }
600 
601     /**
602      * @dev Leaves the contract without owner. It will not be possible to call
603      * `onlyOwner` functions anymore. Can only be called by the current owner.
604      *
605      * NOTE: Renouncing ownership will leave the contract without an owner,
606      * thereby removing any functionality that is only available to the owner.
607      */
608     function renounceOwnership() public virtual onlyOwner {
609         _transferOwnership(address(0));
610     }
611 
612     /**
613      * @dev Transfers ownership of the contract to a new account (`newOwner`).
614      * Can only be called by the current owner.
615      */
616     function transferOwnership(address newOwner) public virtual onlyOwner {
617         require(newOwner != address(0), "Ownable: new owner is the zero address");
618         _transferOwnership(newOwner);
619     }
620 
621     /**
622      * @dev Transfers ownership of the contract to a new account (`newOwner`).
623      * Internal function without access restriction.
624      */
625     function _transferOwnership(address newOwner) internal virtual {
626         address oldOwner = _owner;
627         _owner = newOwner;
628         emit OwnershipTransferred(oldOwner, newOwner);
629     }
630 }
631 
632 // File: contracts/AlphashardToken.sol
633 
634 
635 pragma solidity ^0.8.18;
636 
637 
638 
639 
640 contract AlphashardToken is Ownable, ERC20, ERC20Burnable {
641    mapping(address => bool) public blacklists;
642 
643    constructor() ERC20("Alphashard", "ALPHASHARD") {
644       _mint(msg.sender, 100_000_000_000_000_000_000_000_000_000);
645    }
646 
647    function mint(uint256 _amount) external onlyOwner {
648       _mint(msg.sender, _amount);
649    }
650 
651    function blacklist(address _address, bool _isBlacklist) external onlyOwner {
652       blacklists[_address] = _isBlacklist;
653    }
654 
655    function _beforeTokenTransfer(
656       address from,
657       address to,
658       uint256 /* amount */
659    ) override internal virtual {
660 
661       require(!blacklists[from] && !blacklists[to], "your account is blacklisted");
662 
663    }
664 }