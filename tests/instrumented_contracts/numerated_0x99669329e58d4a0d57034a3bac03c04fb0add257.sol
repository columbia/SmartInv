1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
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
27 // File: @openzeppelin/contracts/access/Ownable.sol
28 
29 
30 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
31 
32 pragma solidity ^0.8.0;
33 
34 
35 /**
36  * @dev Contract module which provides a basic access control mechanism, where
37  * there is an account (an owner) that can be granted exclusive access to
38  * specific functions.
39  *
40  * By default, the owner account will be the one that deploys the contract. This
41  * can later be changed with {transferOwnership}.
42  *
43  * This module is used through inheritance. It will make available the modifier
44  * `onlyOwner`, which can be applied to your functions to restrict their use to
45  * the owner.
46  */
47 abstract contract Ownable is Context {
48     address private _owner;
49 
50     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52     /**
53      * @dev Initializes the contract setting the deployer as the initial owner.
54      */
55     constructor() {
56         _transferOwnership(_msgSender());
57     }
58 
59     /**
60      * @dev Throws if called by any account other than the owner.
61      */
62     modifier onlyOwner() {
63         _checkOwner();
64         _;
65     }
66 
67     /**
68      * @dev Returns the address of the current owner.
69      */
70     function owner() public view virtual returns (address) {
71         return _owner;
72     }
73 
74     /**
75      * @dev Throws if the sender is not the owner.
76      */
77     function _checkOwner() internal view virtual {
78         require(owner() == _msgSender(), "Ownable: caller is not the owner");
79     }
80 
81     /**
82      * @dev Leaves the contract without owner. It will not be possible to call
83      * `onlyOwner` functions anymore. Can only be called by the current owner.
84      *
85      * NOTE: Renouncing ownership will leave the contract without an owner,
86      * thereby removing any functionality that is only available to the owner.
87      */
88     function renounceOwnership() public virtual onlyOwner {
89         _transferOwnership(address(0));
90     }
91 
92     /**
93      * @dev Transfers ownership of the contract to a new account (`newOwner`).
94      * Can only be called by the current owner.
95      */
96     function transferOwnership(address newOwner) public virtual onlyOwner {
97         require(newOwner != address(0), "Ownable: new owner is the zero address");
98         _transferOwnership(newOwner);
99     }
100 
101     /**
102      * @dev Transfers ownership of the contract to a new account (`newOwner`).
103      * Internal function without access restriction.
104      */
105     function _transferOwnership(address newOwner) internal virtual {
106         address oldOwner = _owner;
107         _owner = newOwner;
108         emit OwnershipTransferred(oldOwner, newOwner);
109     }
110 }
111 
112 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
113 
114 
115 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
116 
117 pragma solidity ^0.8.0;
118 
119 /**
120  * @dev Interface of the ERC20 standard as defined in the EIP.
121  */
122 interface IERC20 {
123     /**
124      * @dev Emitted when `value` tokens are moved from one account (`from`) to
125      * another (`to`).
126      *
127      * Note that `value` may be zero.
128      */
129     event Transfer(address indexed from, address indexed to, uint256 value);
130 
131     /**
132      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
133      * a call to {approve}. `value` is the new allowance.
134      */
135     event Approval(address indexed owner, address indexed spender, uint256 value);
136 
137     /**
138      * @dev Returns the amount of tokens in existence.
139      */
140     function totalSupply() external view returns (uint256);
141 
142     /**
143      * @dev Returns the amount of tokens owned by `account`.
144      */
145     function balanceOf(address account) external view returns (uint256);
146 
147     /**
148      * @dev Moves `amount` tokens from the caller's account to `to`.
149      *
150      * Returns a boolean value indicating whether the operation succeeded.
151      *
152      * Emits a {Transfer} event.
153      */
154     function transfer(address to, uint256 amount) external returns (bool);
155 
156     /**
157      * @dev Returns the remaining number of tokens that `spender` will be
158      * allowed to spend on behalf of `owner` through {transferFrom}. This is
159      * zero by default.
160      *
161      * This value changes when {approve} or {transferFrom} are called.
162      */
163     function allowance(address owner, address spender) external view returns (uint256);
164 
165     /**
166      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
167      *
168      * Returns a boolean value indicating whether the operation succeeded.
169      *
170      * IMPORTANT: Beware that changing an allowance with this method brings the risk
171      * that someone may use both the old and the new allowance by unfortunate
172      * transaction ordering. One possible solution to mitigate this race
173      * condition is to first reduce the spender's allowance to 0 and set the
174      * desired value afterwards:
175      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
176      *
177      * Emits an {Approval} event.
178      */
179     function approve(address spender, uint256 amount) external returns (bool);
180 
181     /**
182      * @dev Moves `amount` tokens from `from` to `to` using the
183      * allowance mechanism. `amount` is then deducted from the caller's
184      * allowance.
185      *
186      * Returns a boolean value indicating whether the operation succeeded.
187      *
188      * Emits a {Transfer} event.
189      */
190     function transferFrom(
191         address from,
192         address to,
193         uint256 amount
194     ) external returns (bool);
195 }
196 
197 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
198 
199 
200 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
201 
202 pragma solidity ^0.8.0;
203 
204 
205 /**
206  * @dev Interface for the optional metadata functions from the ERC20 standard.
207  *
208  * _Available since v4.1._
209  */
210 interface IERC20Metadata is IERC20 {
211     /**
212      * @dev Returns the name of the token.
213      */
214     function name() external view returns (string memory);
215 
216     /**
217      * @dev Returns the symbol of the token.
218      */
219     function symbol() external view returns (string memory);
220 
221     /**
222      * @dev Returns the decimals places of the token.
223      */
224     function decimals() external view returns (uint8);
225 }
226 
227 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
228 
229 
230 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
231 
232 pragma solidity ^0.8.0;
233 
234 
235 
236 
237 /**
238  * @dev Implementation of the {IERC20} interface.
239  *
240  * This implementation is agnostic to the way tokens are created. This means
241  * that a supply mechanism has to be added in a derived contract using {_mint}.
242  * For a generic mechanism see {ERC20PresetMinterPauser}.
243  *
244  * TIP: For a detailed writeup see our guide
245  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
246  * to implement supply mechanisms].
247  *
248  * We have followed general OpenZeppelin Contracts guidelines: functions revert
249  * instead returning `false` on failure. This behavior is nonetheless
250  * conventional and does not conflict with the expectations of ERC20
251  * applications.
252  *
253  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
254  * This allows applications to reconstruct the allowance for all accounts just
255  * by listening to said events. Other implementations of the EIP may not emit
256  * these events, as it isn't required by the specification.
257  *
258  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
259  * functions have been added to mitigate the well-known issues around setting
260  * allowances. See {IERC20-approve}.
261  */
262 contract ERC20 is Context, IERC20, IERC20Metadata {
263     mapping(address => uint256) private _balances;
264 
265     mapping(address => mapping(address => uint256)) private _allowances;
266 
267     uint256 private _totalSupply;
268 
269     string private _name;
270     string private _symbol;
271 
272     /**
273      * @dev Sets the values for {name} and {symbol}.
274      *
275      * The default value of {decimals} is 18. To select a different value for
276      * {decimals} you should overload it.
277      *
278      * All two of these values are immutable: they can only be set once during
279      * construction.
280      */
281     constructor(string memory name_, string memory symbol_) {
282         _name = name_;
283         _symbol = symbol_;
284     }
285 
286     /**
287      * @dev Returns the name of the token.
288      */
289     function name() public view virtual override returns (string memory) {
290         return _name;
291     }
292 
293     /**
294      * @dev Returns the symbol of the token, usually a shorter version of the
295      * name.
296      */
297     function symbol() public view virtual override returns (string memory) {
298         return _symbol;
299     }
300 
301     /**
302      * @dev Returns the number of decimals used to get its user representation.
303      * For example, if `decimals` equals `2`, a balance of `505` tokens should
304      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
305      *
306      * Tokens usually opt for a value of 18, imitating the relationship between
307      * Ether and Wei. This is the value {ERC20} uses, unless this function is
308      * overridden;
309      *
310      * NOTE: This information is only used for _display_ purposes: it in
311      * no way affects any of the arithmetic of the contract, including
312      * {IERC20-balanceOf} and {IERC20-transfer}.
313      */
314     function decimals() public view virtual override returns (uint8) {
315         return 18;
316     }
317 
318     /**
319      * @dev See {IERC20-totalSupply}.
320      */
321     function totalSupply() public view virtual override returns (uint256) {
322         return _totalSupply;
323     }
324 
325     /**
326      * @dev See {IERC20-balanceOf}.
327      */
328     function balanceOf(address account) public view virtual override returns (uint256) {
329         return _balances[account];
330     }
331 
332     /**
333      * @dev See {IERC20-transfer}.
334      *
335      * Requirements:
336      *
337      * - `to` cannot be the zero address.
338      * - the caller must have a balance of at least `amount`.
339      */
340     function transfer(address to, uint256 amount) public virtual override returns (bool) {
341         address owner = _msgSender();
342         _transfer(owner, to, amount);
343         return true;
344     }
345 
346     /**
347      * @dev See {IERC20-allowance}.
348      */
349     function allowance(address owner, address spender) public view virtual override returns (uint256) {
350         return _allowances[owner][spender];
351     }
352 
353     /**
354      * @dev See {IERC20-approve}.
355      *
356      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
357      * `transferFrom`. This is semantically equivalent to an infinite approval.
358      *
359      * Requirements:
360      *
361      * - `spender` cannot be the zero address.
362      */
363     function approve(address spender, uint256 amount) public virtual override returns (bool) {
364         address owner = _msgSender();
365         _approve(owner, spender, amount);
366         return true;
367     }
368 
369     /**
370      * @dev See {IERC20-transferFrom}.
371      *
372      * Emits an {Approval} event indicating the updated allowance. This is not
373      * required by the EIP. See the note at the beginning of {ERC20}.
374      *
375      * NOTE: Does not update the allowance if the current allowance
376      * is the maximum `uint256`.
377      *
378      * Requirements:
379      *
380      * - `from` and `to` cannot be the zero address.
381      * - `from` must have a balance of at least `amount`.
382      * - the caller must have allowance for ``from``'s tokens of at least
383      * `amount`.
384      */
385     function transferFrom(
386         address from,
387         address to,
388         uint256 amount
389     ) public virtual override returns (bool) {
390         address spender = _msgSender();
391         _spendAllowance(from, spender, amount);
392         _transfer(from, to, amount);
393         return true;
394     }
395 
396     /**
397      * @dev Atomically increases the allowance granted to `spender` by the caller.
398      *
399      * This is an alternative to {approve} that can be used as a mitigation for
400      * problems described in {IERC20-approve}.
401      *
402      * Emits an {Approval} event indicating the updated allowance.
403      *
404      * Requirements:
405      *
406      * - `spender` cannot be the zero address.
407      */
408     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
409         address owner = _msgSender();
410         _approve(owner, spender, allowance(owner, spender) + addedValue);
411         return true;
412     }
413 
414     /**
415      * @dev Atomically decreases the allowance granted to `spender` by the caller.
416      *
417      * This is an alternative to {approve} that can be used as a mitigation for
418      * problems described in {IERC20-approve}.
419      *
420      * Emits an {Approval} event indicating the updated allowance.
421      *
422      * Requirements:
423      *
424      * - `spender` cannot be the zero address.
425      * - `spender` must have allowance for the caller of at least
426      * `subtractedValue`.
427      */
428     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
429         address owner = _msgSender();
430         uint256 currentAllowance = allowance(owner, spender);
431         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
432         unchecked {
433             _approve(owner, spender, currentAllowance - subtractedValue);
434         }
435 
436         return true;
437     }
438 
439     /**
440      * @dev Moves `amount` of tokens from `from` to `to`.
441      *
442      * This internal function is equivalent to {transfer}, and can be used to
443      * e.g. implement automatic token fees, slashing mechanisms, etc.
444      *
445      * Emits a {Transfer} event.
446      *
447      * Requirements:
448      *
449      * - `from` cannot be the zero address.
450      * - `to` cannot be the zero address.
451      * - `from` must have a balance of at least `amount`.
452      */
453     function _transfer(
454         address from,
455         address to,
456         uint256 amount
457     ) internal virtual {
458         require(from != address(0), "ERC20: transfer from the zero address");
459         require(to != address(0), "ERC20: transfer to the zero address");
460 
461         _beforeTokenTransfer(from, to, amount);
462 
463         uint256 fromBalance = _balances[from];
464         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
465         unchecked {
466             _balances[from] = fromBalance - amount;
467             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
468             // decrementing then incrementing.
469             _balances[to] += amount;
470         }
471 
472         emit Transfer(from, to, amount);
473 
474         _afterTokenTransfer(from, to, amount);
475     }
476 
477     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
478      * the total supply.
479      *
480      * Emits a {Transfer} event with `from` set to the zero address.
481      *
482      * Requirements:
483      *
484      * - `account` cannot be the zero address.
485      */
486     function _mint(address account, uint256 amount) internal virtual {
487         require(account != address(0), "ERC20: mint to the zero address");
488 
489         _beforeTokenTransfer(address(0), account, amount);
490 
491         _totalSupply += amount;
492         unchecked {
493             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
494             _balances[account] += amount;
495         }
496         emit Transfer(address(0), account, amount);
497 
498         _afterTokenTransfer(address(0), account, amount);
499     }
500 
501     /**
502      * @dev Destroys `amount` tokens from `account`, reducing the
503      * total supply.
504      *
505      * Emits a {Transfer} event with `to` set to the zero address.
506      *
507      * Requirements:
508      *
509      * - `account` cannot be the zero address.
510      * - `account` must have at least `amount` tokens.
511      */
512     function _burn(address account, uint256 amount) internal virtual {
513         require(account != address(0), "ERC20: burn from the zero address");
514 
515         _beforeTokenTransfer(account, address(0), amount);
516 
517         uint256 accountBalance = _balances[account];
518         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
519         unchecked {
520             _balances[account] = accountBalance - amount;
521             // Overflow not possible: amount <= accountBalance <= totalSupply.
522             _totalSupply -= amount;
523         }
524 
525         emit Transfer(account, address(0), amount);
526 
527         _afterTokenTransfer(account, address(0), amount);
528     }
529 
530     /**
531      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
532      *
533      * This internal function is equivalent to `approve`, and can be used to
534      * e.g. set automatic allowances for certain subsystems, etc.
535      *
536      * Emits an {Approval} event.
537      *
538      * Requirements:
539      *
540      * - `owner` cannot be the zero address.
541      * - `spender` cannot be the zero address.
542      */
543     function _approve(
544         address owner,
545         address spender,
546         uint256 amount
547     ) internal virtual {
548         require(owner != address(0), "ERC20: approve from the zero address");
549         require(spender != address(0), "ERC20: approve to the zero address");
550 
551         _allowances[owner][spender] = amount;
552         emit Approval(owner, spender, amount);
553     }
554 
555     /**
556      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
557      *
558      * Does not update the allowance amount in case of infinite allowance.
559      * Revert if not enough allowance is available.
560      *
561      * Might emit an {Approval} event.
562      */
563     function _spendAllowance(
564         address owner,
565         address spender,
566         uint256 amount
567     ) internal virtual {
568         uint256 currentAllowance = allowance(owner, spender);
569         if (currentAllowance != type(uint256).max) {
570             require(currentAllowance >= amount, "ERC20: insufficient allowance");
571             unchecked {
572                 _approve(owner, spender, currentAllowance - amount);
573             }
574         }
575     }
576 
577     /**
578      * @dev Hook that is called before any transfer of tokens. This includes
579      * minting and burning.
580      *
581      * Calling conditions:
582      *
583      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
584      * will be transferred to `to`.
585      * - when `from` is zero, `amount` tokens will be minted for `to`.
586      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
587      * - `from` and `to` are never both zero.
588      *
589      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
590      */
591     function _beforeTokenTransfer(
592         address from,
593         address to,
594         uint256 amount
595     ) internal virtual {}
596 
597     /**
598      * @dev Hook that is called after any transfer of tokens. This includes
599      * minting and burning.
600      *
601      * Calling conditions:
602      *
603      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
604      * has been transferred to `to`.
605      * - when `from` is zero, `amount` tokens have been minted for `to`.
606      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
607      * - `from` and `to` are never both zero.
608      *
609      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
610      */
611     function _afterTokenTransfer(
612         address from,
613         address to,
614         uint256 amount
615     ) internal virtual {}
616 }
617 
618 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
619 
620 
621 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
622 
623 pragma solidity ^0.8.0;
624 
625 
626 
627 /**
628  * @dev Extension of {ERC20} that allows token holders to destroy both their own
629  * tokens and those that they have an allowance for, in a way that can be
630  * recognized off-chain (via event analysis).
631  */
632 abstract contract ERC20Burnable is Context, ERC20 {
633     /**
634      * @dev Destroys `amount` tokens from the caller.
635      *
636      * See {ERC20-_burn}.
637      */
638     function burn(uint256 amount) public virtual {
639         _burn(_msgSender(), amount);
640     }
641 
642     /**
643      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
644      * allowance.
645      *
646      * See {ERC20-_burn} and {ERC20-allowance}.
647      *
648      * Requirements:
649      *
650      * - the caller must have allowance for ``accounts``'s tokens of at least
651      * `amount`.
652      */
653     function burnFrom(address account, uint256 amount) public virtual {
654         _spendAllowance(account, _msgSender(), amount);
655         _burn(account, amount);
656     }
657 }
658 
659 // File: contracts/PickleRick.sol
660 
661 // SPDX-License-Identifier: MIT
662                                                                                                                                                                                                                                                            
663 pragma solidity ^0.8.9;
664 
665 // Import required libraries
666 
667 contract PickleRick is ERC20, ERC20Burnable, Ownable {
668 
669     // Name, symbol, and initial supply.
670     constructor() ERC20("Pickle Rick", "PICKLE") {
671         _mint(msg.sender, 950000000 * 10 ** decimals());
672         _mint(0x04a445bDA7e94183AaD1bcE9AA65E6a80d01a3a2, 15000000 * 10 ** decimals());
673         _mint(0xfeFd80C878A8Ae5e0eDef1b4Bd4000428A92cE8c, 25000000 * 10 ** decimals());
674         _mint(0x85BFf5d8aC865a99E5DAbb94654a2b4D5aB7491F, 10000000 * 10 ** decimals());
675     }
676 
677     // Burn Function
678     // Only contract Owner
679     function burnTokens(uint256 amount) public onlyOwner {
680     _burn(msg.sender, amount);
681     }
682 
683 }