1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Context.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 // File: @openzeppelin/contracts/access/Ownable.sol
31 
32 
33 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
34 
35 pragma solidity ^0.8.0;
36 
37 
38 /**
39  * @dev Contract module which provides a basic access control mechanism, where
40  * there is an account (an owner) that can be granted exclusive access to
41  * specific functions.
42  *
43  * By default, the owner account will be the one that deploys the contract. This
44  * can later be changed with {transferOwnership}.
45  *
46  * This module is used through inheritance. It will make available the modifier
47  * `onlyOwner`, which can be applied to your functions to restrict their use to
48  * the owner.
49  */
50 abstract contract Ownable is Context {
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor() {
59         _transferOwnership(_msgSender());
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         _checkOwner();
67         _;
68     }
69 
70     /**
71      * @dev Returns the address of the current owner.
72      */
73     function owner() public view virtual returns (address) {
74         return _owner;
75     }
76 
77     /**
78      * @dev Throws if the sender is not the owner.
79      */
80     function _checkOwner() internal view virtual {
81         require(owner() == _msgSender(), "Ownable: caller is not the owner");
82     }
83 
84     /**
85      * @dev Leaves the contract without owner. It will not be possible to call
86      * `onlyOwner` functions anymore. Can only be called by the current owner.
87      *
88      * NOTE: Renouncing ownership will leave the contract without an owner,
89      * thereby removing any functionality that is only available to the owner.
90      */
91     function renounceOwnership() public virtual onlyOwner {
92         _transferOwnership(address(0));
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Can only be called by the current owner.
98      */
99     function transferOwnership(address newOwner) public virtual onlyOwner {
100         require(newOwner != address(0), "Ownable: new owner is the zero address");
101         _transferOwnership(newOwner);
102     }
103 
104     /**
105      * @dev Transfers ownership of the contract to a new account (`newOwner`).
106      * Internal function without access restriction.
107      */
108     function _transferOwnership(address newOwner) internal virtual {
109         address oldOwner = _owner;
110         _owner = newOwner;
111         emit OwnershipTransferred(oldOwner, newOwner);
112     }
113 }
114 
115 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
116 
117 
118 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
119 
120 pragma solidity ^0.8.0;
121 
122 /**
123  * @dev Interface of the ERC20 standard as defined in the EIP.
124  */
125 interface IERC20 {
126     /**
127      * @dev Emitted when `value` tokens are moved from one account (`from`) to
128      * another (`to`).
129      *
130      * Note that `value` may be zero.
131      */
132     event Transfer(address indexed from, address indexed to, uint256 value);
133 
134     /**
135      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
136      * a call to {approve}. `value` is the new allowance.
137      */
138     event Approval(address indexed owner, address indexed spender, uint256 value);
139 
140     /**
141      * @dev Returns the amount of tokens in existence.
142      */
143     function totalSupply() external view returns (uint256);
144 
145     /**
146      * @dev Returns the amount of tokens owned by `account`.
147      */
148     function balanceOf(address account) external view returns (uint256);
149 
150     /**
151      * @dev Moves `amount` tokens from the caller's account to `to`.
152      *
153      * Returns a boolean value indicating whether the operation succeeded.
154      *
155      * Emits a {Transfer} event.
156      */
157     function transfer(address to, uint256 amount) external returns (bool);
158 
159     /**
160      * @dev Returns the remaining number of tokens that `spender` will be
161      * allowed to spend on behalf of `owner` through {transferFrom}. This is
162      * zero by default.
163      *
164      * This value changes when {approve} or {transferFrom} are called.
165      */
166     function allowance(address owner, address spender) external view returns (uint256);
167 
168     /**
169      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
170      *
171      * Returns a boolean value indicating whether the operation succeeded.
172      *
173      * IMPORTANT: Beware that changing an allowance with this method brings the risk
174      * that someone may use both the old and the new allowance by unfortunate
175      * transaction ordering. One possible solution to mitigate this race
176      * condition is to first reduce the spender's allowance to 0 and set the
177      * desired value afterwards:
178      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
179      *
180      * Emits an {Approval} event.
181      */
182     function approve(address spender, uint256 amount) external returns (bool);
183 
184     /**
185      * @dev Moves `amount` tokens from `from` to `to` using the
186      * allowance mechanism. `amount` is then deducted from the caller's
187      * allowance.
188      *
189      * Returns a boolean value indicating whether the operation succeeded.
190      *
191      * Emits a {Transfer} event.
192      */
193     function transferFrom(
194         address from,
195         address to,
196         uint256 amount
197     ) external returns (bool);
198 }
199 
200 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
201 
202 
203 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
204 
205 pragma solidity ^0.8.0;
206 
207 
208 /**
209  * @dev Interface for the optional metadata functions from the ERC20 standard.
210  *
211  * _Available since v4.1._
212  */
213 interface IERC20Metadata is IERC20 {
214     /**
215      * @dev Returns the name of the token.
216      */
217     function name() external view returns (string memory);
218 
219     /**
220      * @dev Returns the symbol of the token.
221      */
222     function symbol() external view returns (string memory);
223 
224     /**
225      * @dev Returns the decimals places of the token.
226      */
227     function decimals() external view returns (uint8);
228 }
229 
230 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
231 
232 
233 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
234 
235 pragma solidity ^0.8.0;
236 
237 
238 
239 
240 /**
241  * @dev Implementation of the {IERC20} interface.
242  *
243  * This implementation is agnostic to the way tokens are created. This means
244  * that a supply mechanism has to be added in a derived contract using {_mint}.
245  * For a generic mechanism see {ERC20PresetMinterPauser}.
246  *
247  * TIP: For a detailed writeup see our guide
248  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
249  * to implement supply mechanisms].
250  *
251  * We have followed general OpenZeppelin Contracts guidelines: functions revert
252  * instead returning `false` on failure. This behavior is nonetheless
253  * conventional and does not conflict with the expectations of ERC20
254  * applications.
255  *
256  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
257  * This allows applications to reconstruct the allowance for all accounts just
258  * by listening to said events. Other implementations of the EIP may not emit
259  * these events, as it isn't required by the specification.
260  *
261  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
262  * functions have been added to mitigate the well-known issues around setting
263  * allowances. See {IERC20-approve}.
264  */
265 contract ERC20 is Context, IERC20, IERC20Metadata {
266     mapping(address => uint256) private _balances;
267 
268     mapping(address => mapping(address => uint256)) private _allowances;
269 
270     uint256 private _totalSupply;
271 
272     string private _name;
273     string private _symbol;
274 
275     /**
276      * @dev Sets the values for {name} and {symbol}.
277      *
278      * The default value of {decimals} is 18. To select a different value for
279      * {decimals} you should overload it.
280      *
281      * All two of these values are immutable: they can only be set once during
282      * construction.
283      */
284     constructor(string memory name_, string memory symbol_) {
285         _name = name_;
286         _symbol = symbol_;
287     }
288 
289     /**
290      * @dev Returns the name of the token.
291      */
292     function name() public view virtual override returns (string memory) {
293         return _name;
294     }
295 
296     /**
297      * @dev Returns the symbol of the token, usually a shorter version of the
298      * name.
299      */
300     function symbol() public view virtual override returns (string memory) {
301         return _symbol;
302     }
303 
304     /**
305      * @dev Returns the number of decimals used to get its user representation.
306      * For example, if `decimals` equals `2`, a balance of `505` tokens should
307      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
308      *
309      * Tokens usually opt for a value of 18, imitating the relationship between
310      * Ether and Wei. This is the value {ERC20} uses, unless this function is
311      * overridden;
312      *
313      * NOTE: This information is only used for _display_ purposes: it in
314      * no way affects any of the arithmetic of the contract, including
315      * {IERC20-balanceOf} and {IERC20-transfer}.
316      */
317     function decimals() public view virtual override returns (uint8) {
318         return 18;
319     }
320 
321     /**
322      * @dev See {IERC20-totalSupply}.
323      */
324     function totalSupply() public view virtual override returns (uint256) {
325         return _totalSupply;
326     }
327 
328     /**
329      * @dev See {IERC20-balanceOf}.
330      */
331     function balanceOf(address account) public view virtual override returns (uint256) {
332         return _balances[account];
333     }
334 
335     /**
336      * @dev See {IERC20-transfer}.
337      *
338      * Requirements:
339      *
340      * - `to` cannot be the zero address.
341      * - the caller must have a balance of at least `amount`.
342      */
343     function transfer(address to, uint256 amount) public virtual override returns (bool) {
344         address owner = _msgSender();
345         _transfer(owner, to, amount);
346         return true;
347     }
348 
349     /**
350      * @dev See {IERC20-allowance}.
351      */
352     function allowance(address owner, address spender) public view virtual override returns (uint256) {
353         return _allowances[owner][spender];
354     }
355 
356     /**
357      * @dev See {IERC20-approve}.
358      *
359      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
360      * `transferFrom`. This is semantically equivalent to an infinite approval.
361      *
362      * Requirements:
363      *
364      * - `spender` cannot be the zero address.
365      */
366     function approve(address spender, uint256 amount) public virtual override returns (bool) {
367         address owner = _msgSender();
368         _approve(owner, spender, amount);
369         return true;
370     }
371 
372     /**
373      * @dev See {IERC20-transferFrom}.
374      *
375      * Emits an {Approval} event indicating the updated allowance. This is not
376      * required by the EIP. See the note at the beginning of {ERC20}.
377      *
378      * NOTE: Does not update the allowance if the current allowance
379      * is the maximum `uint256`.
380      *
381      * Requirements:
382      *
383      * - `from` and `to` cannot be the zero address.
384      * - `from` must have a balance of at least `amount`.
385      * - the caller must have allowance for ``from``'s tokens of at least
386      * `amount`.
387      */
388     function transferFrom(
389         address from,
390         address to,
391         uint256 amount
392     ) public virtual override returns (bool) {
393         address spender = _msgSender();
394         _spendAllowance(from, spender, amount);
395         _transfer(from, to, amount);
396         return true;
397     }
398 
399     /**
400      * @dev Atomically increases the allowance granted to `spender` by the caller.
401      *
402      * This is an alternative to {approve} that can be used as a mitigation for
403      * problems described in {IERC20-approve}.
404      *
405      * Emits an {Approval} event indicating the updated allowance.
406      *
407      * Requirements:
408      *
409      * - `spender` cannot be the zero address.
410      */
411     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
412         address owner = _msgSender();
413         _approve(owner, spender, allowance(owner, spender) + addedValue);
414         return true;
415     }
416 
417     /**
418      * @dev Atomically decreases the allowance granted to `spender` by the caller.
419      *
420      * This is an alternative to {approve} that can be used as a mitigation for
421      * problems described in {IERC20-approve}.
422      *
423      * Emits an {Approval} event indicating the updated allowance.
424      *
425      * Requirements:
426      *
427      * - `spender` cannot be the zero address.
428      * - `spender` must have allowance for the caller of at least
429      * `subtractedValue`.
430      */
431     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
432         address owner = _msgSender();
433         uint256 currentAllowance = allowance(owner, spender);
434         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
435         unchecked {
436             _approve(owner, spender, currentAllowance - subtractedValue);
437         }
438 
439         return true;
440     }
441 
442     /**
443      * @dev Moves `amount` of tokens from `from` to `to`.
444      *
445      * This internal function is equivalent to {transfer}, and can be used to
446      * e.g. implement automatic token fees, slashing mechanisms, etc.
447      *
448      * Emits a {Transfer} event.
449      *
450      * Requirements:
451      *
452      * - `from` cannot be the zero address.
453      * - `to` cannot be the zero address.
454      * - `from` must have a balance of at least `amount`.
455      */
456     function _transfer(
457         address from,
458         address to,
459         uint256 amount
460     ) internal virtual {
461         require(from != address(0), "ERC20: transfer from the zero address");
462         require(to != address(0), "ERC20: transfer to the zero address");
463 
464         _beforeTokenTransfer(from, to, amount);
465 
466         uint256 fromBalance = _balances[from];
467         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
468         unchecked {
469             _balances[from] = fromBalance - amount;
470             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
471             // decrementing then incrementing.
472             _balances[to] += amount;
473         }
474 
475         emit Transfer(from, to, amount);
476 
477         _afterTokenTransfer(from, to, amount);
478     }
479 
480     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
481      * the total supply.
482      *
483      * Emits a {Transfer} event with `from` set to the zero address.
484      *
485      * Requirements:
486      *
487      * - `account` cannot be the zero address.
488      */
489     function _mint(address account, uint256 amount) internal virtual {
490         require(account != address(0), "ERC20: mint to the zero address");
491 
492         _beforeTokenTransfer(address(0), account, amount);
493 
494         _totalSupply += amount;
495         unchecked {
496             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
497             _balances[account] += amount;
498         }
499         emit Transfer(address(0), account, amount);
500 
501         _afterTokenTransfer(address(0), account, amount);
502     }
503 
504     /**
505      * @dev Destroys `amount` tokens from `account`, reducing the
506      * total supply.
507      *
508      * Emits a {Transfer} event with `to` set to the zero address.
509      *
510      * Requirements:
511      *
512      * - `account` cannot be the zero address.
513      * - `account` must have at least `amount` tokens.
514      */
515     function _burn(address account, uint256 amount) internal virtual {
516         require(account != address(0), "ERC20: burn from the zero address");
517 
518         _beforeTokenTransfer(account, address(0), amount);
519 
520         uint256 accountBalance = _balances[account];
521         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
522         unchecked {
523             _balances[account] = accountBalance - amount;
524             // Overflow not possible: amount <= accountBalance <= totalSupply.
525             _totalSupply -= amount;
526         }
527 
528         emit Transfer(account, address(0), amount);
529 
530         _afterTokenTransfer(account, address(0), amount);
531     }
532 
533     /**
534      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
535      *
536      * This internal function is equivalent to `approve`, and can be used to
537      * e.g. set automatic allowances for certain subsystems, etc.
538      *
539      * Emits an {Approval} event.
540      *
541      * Requirements:
542      *
543      * - `owner` cannot be the zero address.
544      * - `spender` cannot be the zero address.
545      */
546     function _approve(
547         address owner,
548         address spender,
549         uint256 amount
550     ) internal virtual {
551         require(owner != address(0), "ERC20: approve from the zero address");
552         require(spender != address(0), "ERC20: approve to the zero address");
553 
554         _allowances[owner][spender] = amount;
555         emit Approval(owner, spender, amount);
556     }
557 
558     /**
559      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
560      *
561      * Does not update the allowance amount in case of infinite allowance.
562      * Revert if not enough allowance is available.
563      *
564      * Might emit an {Approval} event.
565      */
566     function _spendAllowance(
567         address owner,
568         address spender,
569         uint256 amount
570     ) internal virtual {
571         uint256 currentAllowance = allowance(owner, spender);
572         if (currentAllowance != type(uint256).max) {
573             require(currentAllowance >= amount, "ERC20: insufficient allowance");
574             unchecked {
575                 _approve(owner, spender, currentAllowance - amount);
576             }
577         }
578     }
579 
580     /**
581      * @dev Hook that is called before any transfer of tokens. This includes
582      * minting and burning.
583      *
584      * Calling conditions:
585      *
586      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
587      * will be transferred to `to`.
588      * - when `from` is zero, `amount` tokens will be minted for `to`.
589      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
590      * - `from` and `to` are never both zero.
591      *
592      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
593      */
594     function _beforeTokenTransfer(
595         address from,
596         address to,
597         uint256 amount
598     ) internal virtual {}
599 
600     /**
601      * @dev Hook that is called after any transfer of tokens. This includes
602      * minting and burning.
603      *
604      * Calling conditions:
605      *
606      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
607      * has been transferred to `to`.
608      * - when `from` is zero, `amount` tokens have been minted for `to`.
609      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
610      * - `from` and `to` are never both zero.
611      *
612      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
613      */
614     function _afterTokenTransfer(
615         address from,
616         address to,
617         uint256 amount
618     ) internal virtual {}
619 }
620 
621 // File: contracts/SigmaCoin.sol
622 
623 
624 
625 pragma solidity ^0.8.17;
626 
627 
628 
629 contract SigmaCoin is ERC20, Ownable {
630     constructor() ERC20("Sigma Coin", "SIGMA") {
631         _mint(msg.sender, 256 * 10**27);
632     }
633 }