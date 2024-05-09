1 /*
2 
3                                                          
4     ,o888888o.  `8.`888b                 ,8' 8 8888888888    8 8888
5    8888     `88. `8.`888b               ,8'  8 8888          8 8888
6 ,8 8888       `8. `8.`888b             ,8'   8 8888          8 8888
7 88 8888            `8.`888b     .b    ,8'    8 8888          8 8888
8 88 8888             `8.`888b    88b  ,8'     8 888888888888  8 8888
9 88 8888              `8.`888b .`888b,8'      8 8888          8 8888
10 88 8888   8888888     `8.`888b8.`8888'       8 8888          8 8888
11 `8 8888       .8'      `8.`888`8.`88'        8 8888          8 8888
12    8888     ,88'        `8.`8' `8,`'         8 8888          8 8888
13     `8888888P'           `8.`   `8'          8 888888888888  8 8888
14                                                          
15 
16 Do you know the $GWEI ⛽️ ?
17 
18 GWEI, Gwei, Gweicoin
19 Total Supply: 420.698.888.888.888
20 Mascot: 🦊⛽️ Fang the Fox ⛽️🦊
21 
22 Twitter:  https://twitter.com/gweicoin
23 Telegram: https://t.me/gweicoineth 
24 Website:  https://gweicoin.org
25 Email:    support@gweicoin.org
26 
27 Brought to you by a member of Shitcoin Central,
28 https://discord.gg/shitcoincentral 💩
29 
30 */
31 
32 // SPDX-License-Identifier: MIT
33 // File @openzeppelin/contracts/utils/Context.sol@v4.8.3
34 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Provides information about the current execution context, including the
40  * sender of the transaction and its data. While these are generally available
41  * via msg.sender and msg.data, they should not be accessed in such a direct
42  * manner, since when dealing with meta-transactions the account sending and
43  * paying for execution may not be the actual sender (as far as an application
44  * is concerned).
45  *
46  * This contract is only required for intermediate, library-like contracts.
47  */
48 abstract contract Context {
49     function _msgSender() internal view virtual returns (address) {
50         return msg.sender;
51     }
52 
53     function _msgData() internal view virtual returns (bytes calldata) {
54         return msg.data;
55     }
56 }
57 
58 
59 // File @openzeppelin/contracts/access/Ownable.sol@v4.8.3
60 
61 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
62 
63 pragma solidity ^0.8.0;
64 
65 /**
66  * @dev Contract module which provides a basic access control mechanism, where
67  * there is an account (an owner) that can be granted exclusive access to
68  * specific functions.
69  *
70  * By default, the owner account will be the one that deploys the contract. This
71  * can later be changed with {transferOwnership}.
72  *
73  * This module is used through inheritance. It will make available the modifier
74  * `onlyOwner`, which can be applied to your functions to restrict their use to
75  * the owner.
76  */
77 abstract contract Ownable is Context {
78     address private _owner;
79 
80     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
81 
82     /**
83      * @dev Initializes the contract setting the deployer as the initial owner.
84      */
85     constructor() {
86         _transferOwnership(_msgSender());
87     }
88 
89     /**
90      * @dev Throws if called by any account other than the owner.
91      */
92     modifier onlyOwner() {
93         _checkOwner();
94         _;
95     }
96 
97     /**
98      * @dev Returns the address of the current owner.
99      */
100     function owner() public view virtual returns (address) {
101         return _owner;
102     }
103 
104     /**
105      * @dev Throws if the sender is not the owner.
106      */
107     function _checkOwner() internal view virtual {
108         require(owner() == _msgSender(), "Ownable: caller is not the owner");
109     }
110 
111     /**
112      * @dev Leaves the contract without owner. It will not be possible to call
113      * `onlyOwner` functions anymore. Can only be called by the current owner.
114      *
115      * NOTE: Renouncing ownership will leave the contract without an owner,
116      * thereby removing any functionality that is only available to the owner.
117      */
118     function renounceOwnership() public virtual onlyOwner {
119         _transferOwnership(address(0));
120     }
121 
122     /**
123      * @dev Transfers ownership of the contract to a new account (`newOwner`).
124      * Can only be called by the current owner.
125      */
126     function transferOwnership(address newOwner) public virtual onlyOwner {
127         require(newOwner != address(0), "Ownable: new owner is the zero address");
128         _transferOwnership(newOwner);
129     }
130 
131     /**
132      * @dev Transfers ownership of the contract to a new account (`newOwner`).
133      * Internal function without access restriction.
134      */
135     function _transferOwnership(address newOwner) internal virtual {
136         address oldOwner = _owner;
137         _owner = newOwner;
138         emit OwnershipTransferred(oldOwner, newOwner);
139     }
140 }
141 
142 
143 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.8.3
144 
145 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
146 
147 pragma solidity ^0.8.0;
148 
149 /**
150  * @dev Interface of the ERC20 standard as defined in the EIP.
151  */
152 interface IERC20 {
153     /**
154      * @dev Emitted when `value` tokens are moved from one account (`from`) to
155      * another (`to`).
156      *
157      * Note that `value` may be zero.
158      */
159     event Transfer(address indexed from, address indexed to, uint256 value);
160 
161     /**
162      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
163      * a call to {approve}. `value` is the new allowance.
164      */
165     event Approval(address indexed owner, address indexed spender, uint256 value);
166 
167     /**
168      * @dev Returns the amount of tokens in existence.
169      */
170     function totalSupply() external view returns (uint256);
171 
172     /**
173      * @dev Returns the amount of tokens owned by `account`.
174      */
175     function balanceOf(address account) external view returns (uint256);
176 
177     /**
178      * @dev Moves `amount` tokens from the caller's account to `to`.
179      *
180      * Returns a boolean value indicating whether the operation succeeded.
181      *
182      * Emits a {Transfer} event.
183      */
184     function transfer(address to, uint256 amount) external returns (bool);
185 
186     /**
187      * @dev Returns the remaining number of tokens that `spender` will be
188      * allowed to spend on behalf of `owner` through {transferFrom}. This is
189      * zero by default.
190      *
191      * This value changes when {approve} or {transferFrom} are called.
192      */
193     function allowance(address owner, address spender) external view returns (uint256);
194 
195     /**
196      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
197      *
198      * Returns a boolean value indicating whether the operation succeeded.
199      *
200      * IMPORTANT: Beware that changing an allowance with this method brings the risk
201      * that someone may use both the old and the new allowance by unfortunate
202      * transaction ordering. One possible solution to mitigate this race
203      * condition is to first reduce the spender's allowance to 0 and set the
204      * desired value afterwards:
205      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
206      *
207      * Emits an {Approval} event.
208      */
209     function approve(address spender, uint256 amount) external returns (bool);
210 
211     /**
212      * @dev Moves `amount` tokens from `from` to `to` using the
213      * allowance mechanism. `amount` is then deducted from the caller's
214      * allowance.
215      *
216      * Returns a boolean value indicating whether the operation succeeded.
217      *
218      * Emits a {Transfer} event.
219      */
220     function transferFrom(
221         address from,
222         address to,
223         uint256 amount
224     ) external returns (bool);
225 }
226 
227 
228 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.8.3
229 
230 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
231 
232 pragma solidity ^0.8.0;
233 
234 /**
235  * @dev Interface for the optional metadata functions from the ERC20 standard.
236  *
237  * _Available since v4.1._
238  */
239 interface IERC20Metadata is IERC20 {
240     /**
241      * @dev Returns the name of the token.
242      */
243     function name() external view returns (string memory);
244 
245     /**
246      * @dev Returns the symbol of the token.
247      */
248     function symbol() external view returns (string memory);
249 
250     /**
251      * @dev Returns the decimals places of the token.
252      */
253     function decimals() external view returns (uint8);
254 }
255 
256 
257 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.8.3
258 
259 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
260 
261 pragma solidity ^0.8.0;
262 
263 
264 
265 /**
266  * @dev Implementation of the {IERC20} interface.
267  *
268  * This implementation is agnostic to the way tokens are created. This means
269  * that a supply mechanism has to be added in a derived contract using {_mint}.
270  * For a generic mechanism see {ERC20PresetMinterPauser}.
271  *
272  * TIP: For a detailed writeup see our guide
273  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
274  * to implement supply mechanisms].
275  *
276  * We have followed general OpenZeppelin Contracts guidelines: functions revert
277  * instead returning `false` on failure. This behavior is nonetheless
278  * conventional and does not conflict with the expectations of ERC20
279  * applications.
280  *
281  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
282  * This allows applications to reconstruct the allowance for all accounts just
283  * by listening to said events. Other implementations of the EIP may not emit
284  * these events, as it isn't required by the specification.
285  *
286  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
287  * functions have been added to mitigate the well-known issues around setting
288  * allowances. See {IERC20-approve}.
289  */
290 contract ERC20 is Context, IERC20, IERC20Metadata {
291     mapping(address => uint256) private _balances;
292 
293     mapping(address => mapping(address => uint256)) private _allowances;
294 
295     uint256 private _totalSupply;
296 
297     string private _name;
298     string private _symbol;
299 
300     /**
301      * @dev Sets the values for {name} and {symbol}.
302      *
303      * The default value of {decimals} is 18. To select a different value for
304      * {decimals} you should overload it.
305      *
306      * All two of these values are immutable: they can only be set once during
307      * construction.
308      */
309     constructor(string memory name_, string memory symbol_) {
310         _name = name_;
311         _symbol = symbol_;
312     }
313 
314     /**
315      * @dev Returns the name of the token.
316      */
317     function name() public view virtual override returns (string memory) {
318         return _name;
319     }
320 
321     /**
322      * @dev Returns the symbol of the token, usually a shorter version of the
323      * name.
324      */
325     function symbol() public view virtual override returns (string memory) {
326         return _symbol;
327     }
328 
329     /**
330      * @dev Returns the number of decimals used to get its user representation.
331      * For example, if `decimals` equals `2`, a balance of `505` tokens should
332      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
333      *
334      * Tokens usually opt for a value of 18, imitating the relationship between
335      * Ether and Wei. This is the value {ERC20} uses, unless this function is
336      * overridden;
337      *
338      * NOTE: This information is only used for _display_ purposes: it in
339      * no way affects any of the arithmetic of the contract, including
340      * {IERC20-balanceOf} and {IERC20-transfer}.
341      */
342     function decimals() public view virtual override returns (uint8) {
343         return 18;
344     }
345 
346     /**
347      * @dev See {IERC20-totalSupply}.
348      */
349     function totalSupply() public view virtual override returns (uint256) {
350         return _totalSupply;
351     }
352 
353     /**
354      * @dev See {IERC20-balanceOf}.
355      */
356     function balanceOf(address account) public view virtual override returns (uint256) {
357         return _balances[account];
358     }
359 
360     /**
361      * @dev See {IERC20-transfer}.
362      *
363      * Requirements:
364      *
365      * - `to` cannot be the zero address.
366      * - the caller must have a balance of at least `amount`.
367      */
368     function transfer(address to, uint256 amount) public virtual override returns (bool) {
369         address owner = _msgSender();
370         _transfer(owner, to, amount);
371         return true;
372     }
373 
374     /**
375      * @dev See {IERC20-allowance}.
376      */
377     function allowance(address owner, address spender) public view virtual override returns (uint256) {
378         return _allowances[owner][spender];
379     }
380 
381     /**
382      * @dev See {IERC20-approve}.
383      *
384      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
385      * `transferFrom`. This is semantically equivalent to an infinite approval.
386      *
387      * Requirements:
388      *
389      * - `spender` cannot be the zero address.
390      */
391     function approve(address spender, uint256 amount) public virtual override returns (bool) {
392         address owner = _msgSender();
393         _approve(owner, spender, amount);
394         return true;
395     }
396 
397     /**
398      * @dev See {IERC20-transferFrom}.
399      *
400      * Emits an {Approval} event indicating the updated allowance. This is not
401      * required by the EIP. See the note at the beginning of {ERC20}.
402      *
403      * NOTE: Does not update the allowance if the current allowance
404      * is the maximum `uint256`.
405      *
406      * Requirements:
407      *
408      * - `from` and `to` cannot be the zero address.
409      * - `from` must have a balance of at least `amount`.
410      * - the caller must have allowance for ``from``'s tokens of at least
411      * `amount`.
412      */
413     function transferFrom(
414         address from,
415         address to,
416         uint256 amount
417     ) public virtual override returns (bool) {
418         address spender = _msgSender();
419         _spendAllowance(from, spender, amount);
420         _transfer(from, to, amount);
421         return true;
422     }
423 
424     /**
425      * @dev Atomically increases the allowance granted to `spender` by the caller.
426      *
427      * This is an alternative to {approve} that can be used as a mitigation for
428      * problems described in {IERC20-approve}.
429      *
430      * Emits an {Approval} event indicating the updated allowance.
431      *
432      * Requirements:
433      *
434      * - `spender` cannot be the zero address.
435      */
436     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
437         address owner = _msgSender();
438         _approve(owner, spender, allowance(owner, spender) + addedValue);
439         return true;
440     }
441 
442     /**
443      * @dev Atomically decreases the allowance granted to `spender` by the caller.
444      *
445      * This is an alternative to {approve} that can be used as a mitigation for
446      * problems described in {IERC20-approve}.
447      *
448      * Emits an {Approval} event indicating the updated allowance.
449      *
450      * Requirements:
451      *
452      * - `spender` cannot be the zero address.
453      * - `spender` must have allowance for the caller of at least
454      * `subtractedValue`.
455      */
456     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
457         address owner = _msgSender();
458         uint256 currentAllowance = allowance(owner, spender);
459         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
460         unchecked {
461             _approve(owner, spender, currentAllowance - subtractedValue);
462         }
463 
464         return true;
465     }
466 
467     /**
468      * @dev Moves `amount` of tokens from `from` to `to`.
469      *
470      * This internal function is equivalent to {transfer}, and can be used to
471      * e.g. implement automatic token fees, slashing mechanisms, etc.
472      *
473      * Emits a {Transfer} event.
474      *
475      * Requirements:
476      *
477      * - `from` cannot be the zero address.
478      * - `to` cannot be the zero address.
479      * - `from` must have a balance of at least `amount`.
480      */
481     function _transfer(
482         address from,
483         address to,
484         uint256 amount
485     ) internal virtual {
486         require(from != address(0), "ERC20: transfer from the zero address");
487         require(to != address(0), "ERC20: transfer to the zero address");
488 
489         _beforeTokenTransfer(from, to, amount);
490 
491         uint256 fromBalance = _balances[from];
492         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
493         unchecked {
494             _balances[from] = fromBalance - amount;
495             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
496             // decrementing then incrementing.
497             _balances[to] += amount;
498         }
499 
500         emit Transfer(from, to, amount);
501 
502         _afterTokenTransfer(from, to, amount);
503     }
504 
505     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
506      * the total supply.
507      *
508      * Emits a {Transfer} event with `from` set to the zero address.
509      *
510      * Requirements:
511      *
512      * - `account` cannot be the zero address.
513      */
514     function _mint(address account, uint256 amount) internal virtual {
515         require(account != address(0), "ERC20: mint to the zero address");
516 
517         _beforeTokenTransfer(address(0), account, amount);
518 
519         _totalSupply += amount;
520         unchecked {
521             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
522             _balances[account] += amount;
523         }
524         emit Transfer(address(0), account, amount);
525 
526         _afterTokenTransfer(address(0), account, amount);
527     }
528 
529     /**
530      * @dev Destroys `amount` tokens from `account`, reducing the
531      * total supply.
532      *
533      * Emits a {Transfer} event with `to` set to the zero address.
534      *
535      * Requirements:
536      *
537      * - `account` cannot be the zero address.
538      * - `account` must have at least `amount` tokens.
539      */
540     function _burn(address account, uint256 amount) internal virtual {
541         require(account != address(0), "ERC20: burn from the zero address");
542 
543         _beforeTokenTransfer(account, address(0), amount);
544 
545         uint256 accountBalance = _balances[account];
546         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
547         unchecked {
548             _balances[account] = accountBalance - amount;
549             // Overflow not possible: amount <= accountBalance <= totalSupply.
550             _totalSupply -= amount;
551         }
552 
553         emit Transfer(account, address(0), amount);
554 
555         _afterTokenTransfer(account, address(0), amount);
556     }
557 
558     /**
559      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
560      *
561      * This internal function is equivalent to `approve`, and can be used to
562      * e.g. set automatic allowances for certain subsystems, etc.
563      *
564      * Emits an {Approval} event.
565      *
566      * Requirements:
567      *
568      * - `owner` cannot be the zero address.
569      * - `spender` cannot be the zero address.
570      */
571     function _approve(
572         address owner,
573         address spender,
574         uint256 amount
575     ) internal virtual {
576         require(owner != address(0), "ERC20: approve from the zero address");
577         require(spender != address(0), "ERC20: approve to the zero address");
578 
579         _allowances[owner][spender] = amount;
580         emit Approval(owner, spender, amount);
581     }
582 
583     /**
584      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
585      *
586      * Does not update the allowance amount in case of infinite allowance.
587      * Revert if not enough allowance is available.
588      *
589      * Might emit an {Approval} event.
590      */
591     function _spendAllowance(
592         address owner,
593         address spender,
594         uint256 amount
595     ) internal virtual {
596         uint256 currentAllowance = allowance(owner, spender);
597         if (currentAllowance != type(uint256).max) {
598             require(currentAllowance >= amount, "ERC20: insufficient allowance");
599             unchecked {
600                 _approve(owner, spender, currentAllowance - amount);
601             }
602         }
603     }
604 
605     /**
606      * @dev Hook that is called before any transfer of tokens. This includes
607      * minting and burning.
608      *
609      * Calling conditions:
610      *
611      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
612      * will be transferred to `to`.
613      * - when `from` is zero, `amount` tokens will be minted for `to`.
614      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
615      * - `from` and `to` are never both zero.
616      *
617      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
618      */
619     function _beforeTokenTransfer(
620         address from,
621         address to,
622         uint256 amount
623     ) internal virtual {}
624 
625     /**
626      * @dev Hook that is called after any transfer of tokens. This includes
627      * minting and burning.
628      *
629      * Calling conditions:
630      *
631      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
632      * has been transferred to `to`.
633      * - when `from` is zero, `amount` tokens have been minted for `to`.
634      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
635      * - `from` and `to` are never both zero.
636      *
637      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
638      */
639     function _afterTokenTransfer(
640         address from,
641         address to,
642         uint256 amount
643     ) internal virtual {}
644 }
645 
646 
647 // File @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol@v4.8.3
648 
649 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
650 
651 pragma solidity ^0.8.0;
652 
653 
654 /**
655  * @dev Extension of {ERC20} that allows token holders to destroy both their own
656  * tokens and those that they have an allowance for, in a way that can be
657  * recognized off-chain (via event analysis).
658  */
659 abstract contract ERC20Burnable is Context, ERC20 {
660     /**
661      * @dev Destroys `amount` tokens from the caller.
662      *
663      * See {ERC20-_burn}.
664      */
665     function burn(uint256 amount) public virtual {
666         _burn(_msgSender(), amount);
667     }
668 
669     /**
670      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
671      * allowance.
672      *
673      * See {ERC20-_burn} and {ERC20-allowance}.
674      *
675      * Requirements:
676      *
677      * - the caller must have allowance for ``accounts``'s tokens of at least
678      * `amount`.
679      */
680     function burnFrom(address account, uint256 amount) public virtual {
681         _spendAllowance(account, _msgSender(), amount);
682         _burn(account, amount);
683     }
684 }
685 
686 // File contracts/Gwei.sol
687 pragma solidity ^0.8.9;
688 contract GWEI is ERC20, ERC20Burnable, Ownable {
689     constructor() ERC20("GweiCoin", "GWEI") {
690         _mint(msg.sender, 420698888888888 * 10 ** decimals());
691     }
692 }