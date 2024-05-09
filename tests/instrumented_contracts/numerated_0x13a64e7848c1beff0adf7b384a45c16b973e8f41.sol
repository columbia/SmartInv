1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 /**
26  * @dev Interface of the ERC20 standard as defined in the EIP.
27  */
28 interface IERC20 {
29     /**
30      * @dev Emitted when `value` tokens are moved from one account (`from`) to
31      * another (`to`).
32      *
33      * Note that `value` may be zero.
34      */
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 
37     /**
38      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
39      * a call to {approve}. `value` is the new allowance.
40      */
41     event Approval(address indexed owner, address indexed spender, uint256 value);
42 
43     /**
44      * @dev Returns the amount of tokens in existence.
45      */
46     function totalSupply() external view returns (uint256);
47 
48     /**
49      * @dev Returns the amount of tokens owned by `account`.
50      */
51     function balanceOf(address account) external view returns (uint256);
52 
53     /**
54      * @dev Moves `amount` tokens from the caller's account to `to`.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * Emits a {Transfer} event.
59      */
60     function transfer(address to, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Returns the remaining number of tokens that `spender` will be
64      * allowed to spend on behalf of `owner` through {transferFrom}. This is
65      * zero by default.
66      *
67      * This value changes when {approve} or {transferFrom} are called.
68      */
69     function allowance(address owner, address spender) external view returns (uint256);
70 
71     /**
72      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
73      *
74      * Returns a boolean value indicating whether the operation succeeded.
75      *
76      * IMPORTANT: Beware that changing an allowance with this method brings the risk
77      * that someone may use both the old and the new allowance by unfortunate
78      * transaction ordering. One possible solution to mitigate this race
79      * condition is to first reduce the spender's allowance to 0 and set the
80      * desired value afterwards:
81      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
82      *
83      * Emits an {Approval} event.
84      */
85     function approve(address spender, uint256 amount) external returns (bool);
86 
87     /**
88      * @dev Moves `amount` tokens from `from` to `to` using the
89      * allowance mechanism. `amount` is then deducted from the caller's
90      * allowance.
91      *
92      * Returns a boolean value indicating whether the operation succeeded.
93      *
94      * Emits a {Transfer} event.
95      */
96     function transferFrom(
97         address from,
98         address to,
99         uint256 amount
100     ) external returns (bool);
101 }
102 
103 /**
104  * @dev Interface for the optional metadata functions from the ERC20 standard.
105  *
106  * _Available since v4.1._
107  */
108 interface IERC20Metadata is IERC20 {
109     /**
110      * @dev Returns the name of the token.
111      */
112     function name() external view returns (string memory);
113 
114     /**
115      * @dev Returns the symbol of the token.
116      */
117     function symbol() external view returns (string memory);
118 
119     /**
120      * @dev Returns the decimals places of the token.
121      */
122     function decimals() external view returns (uint8);
123 }
124 
125 /**
126  * @dev Implementation of the {IERC20} interface.
127  *
128  * This implementation is agnostic to the way tokens are created. This means
129  * that a supply mechanism has to be added in a derived contract using {_mint}.
130  * For a generic mechanism see {ERC20PresetMinterPauser}.
131  *
132  * TIP: For a detailed writeup see our guide
133  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
134  * to implement supply mechanisms].
135  *
136  * We have followed general OpenZeppelin Contracts guidelines: functions revert
137  * instead returning `false` on failure. This behavior is nonetheless
138  * conventional and does not conflict with the expectations of ERC20
139  * applications.
140  *
141  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
142  * This allows applications to reconstruct the allowance for all accounts just
143  * by listening to said events. Other implementations of the EIP may not emit
144  * these events, as it isn't required by the specification.
145  *
146  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
147  * functions have been added to mitigate the well-known issues around setting
148  * allowances. See {IERC20-approve}.
149  */
150 contract ERC20 is Context, IERC20, IERC20Metadata {
151     mapping(address => uint256) private _balances;
152 
153     mapping(address => mapping(address => uint256)) private _allowances;
154 
155     uint256 private _totalSupply;
156 
157     string private _name;
158     string private _symbol;
159 
160     /**
161      * @dev Sets the values for {name} and {symbol}.
162      *
163      * The default value of {decimals} is 18. To select a different value for
164      * {decimals} you should overload it.
165      *
166      * All two of these values are immutable: they can only be set once during
167      * construction.
168      */
169     constructor(string memory name_, string memory symbol_) {
170         _name = name_;
171         _symbol = symbol_;
172     }
173 
174     /**
175      * @dev Returns the name of the token.
176      */
177     function name() public view virtual override returns (string memory) {
178         return _name;
179     }
180 
181     /**
182      * @dev Returns the symbol of the token, usually a shorter version of the
183      * name.
184      */
185     function symbol() public view virtual override returns (string memory) {
186         return _symbol;
187     }
188 
189     /**
190      * @dev Returns the number of decimals used to get its user representation.
191      * For example, if `decimals` equals `2`, a balance of `505` tokens should
192      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
193      *
194      * Tokens usually opt for a value of 18, imitating the relationship between
195      * Ether and Wei. This is the value {ERC20} uses, unless this function is
196      * overridden;
197      *
198      * NOTE: This information is only used for _display_ purposes: it in
199      * no way affects any of the arithmetic of the contract, including
200      * {IERC20-balanceOf} and {IERC20-transfer}.
201      */
202     function decimals() public view virtual override returns (uint8) {
203         return 18;
204     }
205 
206     /**
207      * @dev See {IERC20-totalSupply}.
208      */
209     function totalSupply() public view virtual override returns (uint256) {
210         return _totalSupply;
211     }
212 
213     /**
214      * @dev See {IERC20-balanceOf}.
215      */
216     function balanceOf(address account) public view virtual override returns (uint256) {
217         return _balances[account];
218     }
219 
220     /**
221      * @dev See {IERC20-transfer}.
222      *
223      * Requirements:
224      *
225      * - `to` cannot be the zero address.
226      * - the caller must have a balance of at least `amount`.
227      */
228     function transfer(address to, uint256 amount) public virtual override returns (bool) {
229         address owner = _msgSender();
230         _transfer(owner, to, amount);
231         return true;
232     }
233 
234     /**
235      * @dev See {IERC20-allowance}.
236      */
237     function allowance(address owner, address spender) public view virtual override returns (uint256) {
238         return _allowances[owner][spender];
239     }
240 
241     /**
242      * @dev See {IERC20-approve}.
243      *
244      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
245      * `transferFrom`. This is semantically equivalent to an infinite approval.
246      *
247      * Requirements:
248      *
249      * - `spender` cannot be the zero address.
250      */
251     function approve(address spender, uint256 amount) public virtual override returns (bool) {
252         address owner = _msgSender();
253         _approve(owner, spender, amount);
254         return true;
255     }
256 
257     /**
258      * @dev See {IERC20-transferFrom}.
259      *
260      * Emits an {Approval} event indicating the updated allowance. This is not
261      * required by the EIP. See the note at the beginning of {ERC20}.
262      *
263      * NOTE: Does not update the allowance if the current allowance
264      * is the maximum `uint256`.
265      *
266      * Requirements:
267      *
268      * - `from` and `to` cannot be the zero address.
269      * - `from` must have a balance of at least `amount`.
270      * - the caller must have allowance for ``from``'s tokens of at least
271      * `amount`.
272      */
273     function transferFrom(
274         address from,
275         address to,
276         uint256 amount
277     ) public virtual override returns (bool) {
278         address spender = _msgSender();
279         _spendAllowance(from, spender, amount);
280         _transfer(from, to, amount);
281         return true;
282     }
283 
284     /**
285      * @dev Atomically increases the allowance granted to `spender` by the caller.
286      *
287      * This is an alternative to {approve} that can be used as a mitigation for
288      * problems described in {IERC20-approve}.
289      *
290      * Emits an {Approval} event indicating the updated allowance.
291      *
292      * Requirements:
293      *
294      * - `spender` cannot be the zero address.
295      */
296     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
297         address owner = _msgSender();
298         _approve(owner, spender, allowance(owner, spender) + addedValue);
299         return true;
300     }
301 
302     /**
303      * @dev Atomically decreases the allowance granted to `spender` by the caller.
304      *
305      * This is an alternative to {approve} that can be used as a mitigation for
306      * problems described in {IERC20-approve}.
307      *
308      * Emits an {Approval} event indicating the updated allowance.
309      *
310      * Requirements:
311      *
312      * - `spender` cannot be the zero address.
313      * - `spender` must have allowance for the caller of at least
314      * `subtractedValue`.
315      */
316     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
317         address owner = _msgSender();
318         uint256 currentAllowance = allowance(owner, spender);
319         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
320         unchecked {
321             _approve(owner, spender, currentAllowance - subtractedValue);
322         }
323 
324         return true;
325     }
326 
327     /**
328      * @dev Moves `amount` of tokens from `sender` to `recipient`.
329      *
330      * This internal function is equivalent to {transfer}, and can be used to
331      * e.g. implement automatic token fees, slashing mechanisms, etc.
332      *
333      * Emits a {Transfer} event.
334      *
335      * Requirements:
336      *
337      * - `from` cannot be the zero address.
338      * - `to` cannot be the zero address.
339      * - `from` must have a balance of at least `amount`.
340      */
341     function _transfer(
342         address from,
343         address to,
344         uint256 amount
345     ) internal virtual {
346         require(from != address(0), "ERC20: transfer from the zero address");
347         require(to != address(0), "ERC20: transfer to the zero address");
348 
349         _beforeTokenTransfer(from, to, amount);
350 
351         uint256 fromBalance = _balances[from];
352         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
353         unchecked {
354             _balances[from] = fromBalance - amount;
355         }
356         _balances[to] += amount;
357 
358         emit Transfer(from, to, amount);
359 
360         _afterTokenTransfer(from, to, amount);
361     }
362 
363     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
364      * the total supply.
365      *
366      * Emits a {Transfer} event with `from` set to the zero address.
367      *
368      * Requirements:
369      *
370      * - `account` cannot be the zero address.
371      */
372     function _mint(address account, uint256 amount) internal virtual {
373         require(account != address(0), "ERC20: mint to the zero address");
374 
375         _beforeTokenTransfer(address(0), account, amount);
376 
377         _totalSupply += amount;
378         _balances[account] += amount;
379         emit Transfer(address(0), account, amount);
380 
381         _afterTokenTransfer(address(0), account, amount);
382     }
383 
384     /**
385      * @dev Destroys `amount` tokens from `account`, reducing the
386      * total supply.
387      *
388      * Emits a {Transfer} event with `to` set to the zero address.
389      *
390      * Requirements:
391      *
392      * - `account` cannot be the zero address.
393      * - `account` must have at least `amount` tokens.
394      */
395     function _burn(address account, uint256 amount) internal virtual {
396         require(account != address(0), "ERC20: burn from the zero address");
397 
398         _beforeTokenTransfer(account, address(0), amount);
399 
400         uint256 accountBalance = _balances[account];
401         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
402         unchecked {
403             _balances[account] = accountBalance - amount;
404         }
405         _totalSupply -= amount;
406 
407         emit Transfer(account, address(0), amount);
408 
409         _afterTokenTransfer(account, address(0), amount);
410     }
411 
412     /**
413      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
414      *
415      * This internal function is equivalent to `approve`, and can be used to
416      * e.g. set automatic allowances for certain subsystems, etc.
417      *
418      * Emits an {Approval} event.
419      *
420      * Requirements:
421      *
422      * - `owner` cannot be the zero address.
423      * - `spender` cannot be the zero address.
424      */
425     function _approve(
426         address owner,
427         address spender,
428         uint256 amount
429     ) internal virtual {
430         require(owner != address(0), "ERC20: approve from the zero address");
431         require(spender != address(0), "ERC20: approve to the zero address");
432 
433         _allowances[owner][spender] = amount;
434         emit Approval(owner, spender, amount);
435     }
436 
437     /**
438      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
439      *
440      * Does not update the allowance amount in case of infinite allowance.
441      * Revert if not enough allowance is available.
442      *
443      * Might emit an {Approval} event.
444      */
445     function _spendAllowance(
446         address owner,
447         address spender,
448         uint256 amount
449     ) internal virtual {
450         uint256 currentAllowance = allowance(owner, spender);
451         if (currentAllowance != type(uint256).max) {
452             require(currentAllowance >= amount, "ERC20: insufficient allowance");
453             unchecked {
454                 _approve(owner, spender, currentAllowance - amount);
455             }
456         }
457     }
458 
459     /**
460      * @dev Hook that is called before any transfer of tokens. This includes
461      * minting and burning.
462      *
463      * Calling conditions:
464      *
465      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
466      * will be transferred to `to`.
467      * - when `from` is zero, `amount` tokens will be minted for `to`.
468      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
469      * - `from` and `to` are never both zero.
470      *
471      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
472      */
473     function _beforeTokenTransfer(
474         address from,
475         address to,
476         uint256 amount
477     ) internal virtual {}
478 
479     /**
480      * @dev Hook that is called after any transfer of tokens. This includes
481      * minting and burning.
482      *
483      * Calling conditions:
484      *
485      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
486      * has been transferred to `to`.
487      * - when `from` is zero, `amount` tokens have been minted for `to`.
488      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
489      * - `from` and `to` are never both zero.
490      *
491      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
492      */
493     function _afterTokenTransfer(
494         address from,
495         address to,
496         uint256 amount
497     ) internal virtual {}
498 }
499 
500 /**
501  * @dev Contract module which provides a basic access control mechanism, where
502  * there is an account (an owner) that can be granted exclusive access to
503  * specific functions.
504  *
505  * By default, the owner account will be the one that deploys the contract. This
506  * can later be changed with {transferOwnership}.
507  *
508  * This module is used through inheritance. It will make available the modifier
509  * `onlyOwner`, which can be applied to your functions to restrict their use to
510  * the owner.
511  */
512 abstract contract Ownable is Context {
513     address private _owner;
514 
515     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
516 
517     /**
518      * @dev Initializes the contract setting the deployer as the initial owner.
519      */
520     constructor() {
521         _transferOwnership(_msgSender());
522     }
523 
524     /**
525      * @dev Returns the address of the current owner.
526      */
527     function owner() public view virtual returns (address) {
528         return _owner;
529     }
530 
531     /**
532      * @dev Throws if called by any account other than the owner.
533      */
534     modifier onlyOwner() {
535         require(owner() == _msgSender(), "Ownable: caller is not the owner");
536         _;
537     }
538 
539     /**
540      * @dev Leaves the contract without owner. It will not be possible to call
541      * `onlyOwner` functions anymore. Can only be called by the current owner.
542      *
543      * NOTE: Renouncing ownership will leave the contract without an owner,
544      * thereby removing any functionality that is only available to the owner.
545      */
546     function renounceOwnership() public virtual onlyOwner {
547         _transferOwnership(address(0));
548     }
549 
550     /**
551      * @dev Transfers ownership of the contract to a new account (`newOwner`).
552      * Can only be called by the current owner.
553      */
554     function transferOwnership(address newOwner) public virtual onlyOwner {
555         require(newOwner != address(0), "Ownable: new owner is the zero address");
556         _transferOwnership(newOwner);
557     }
558 
559     /**
560      * @dev Transfers ownership of the contract to a new account (`newOwner`).
561      * Internal function without access restriction.
562      */
563     function _transferOwnership(address newOwner) internal virtual {
564         address oldOwner = _owner;
565         _owner = newOwner;
566         emit OwnershipTransferred(oldOwner, newOwner);
567     }
568 }
569 
570 // clearing stuck token in contract
571 abstract contract Withdrawable is Ownable {
572     event Withdraw(address indexed token, uint256 amount);
573 
574     function withdrawToken(address token, uint256 amount) external onlyOwner {
575         __transfer(token, _msgSender(), amount);
576         emit Withdraw(token, amount);
577     }
578 
579     function __transfer(
580         address asset,
581         address to,
582         uint256 amount
583     ) internal {
584         if (amount == 0) return;
585         if (to == address(0)) return;
586         if (asset == address(0) && to != address(this)) {
587             (bool success, ) = payable(to).call{ value: amount }(new bytes(0));
588             if (!success) revert("Withdraw error");
589         } else {
590             IERC20(asset).transfer(to, amount);
591         }
592     }
593 }
594 
595 contract BOI is ERC20, Withdrawable {
596     constructor() ERC20("BOI", "BOI") {
597         _mint(msg.sender, 1000000000000000 * 10**decimals());
598     }
599 }