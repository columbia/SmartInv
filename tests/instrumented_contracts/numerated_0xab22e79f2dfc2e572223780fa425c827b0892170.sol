1 // File: erc_20hdwy_flat.sol
2 
3 
4 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
5 
6 
7 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev Interface of the ERC20 standard as defined in the EIP.
13  */
14 interface IERC20 {
15     /**
16      * @dev Emitted when `value` tokens are moved from one account (`from`) to
17      * another (`to`).
18      *
19      * Note that `value` may be zero.
20      */
21     event Transfer(address indexed from, address indexed to, uint256 value);
22 
23     /**
24      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
25      * a call to {approve}. `value` is the new allowance.
26      */
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 
29     /**
30      * @dev Returns the amount of tokens in existence.
31      */
32     function totalSupply() external view returns (uint256);
33 
34     /**
35      * @dev Returns the amount of tokens owned by `account`.
36      */
37     function balanceOf(address account) external view returns (uint256);
38 
39     /**
40      * @dev Moves `amount` tokens from the caller's account to `to`.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * Emits a {Transfer} event.
45      */
46     function transfer(address to, uint256 amount) external returns (bool);
47 
48     /**
49      * @dev Returns the remaining number of tokens that `spender` will be
50      * allowed to spend on behalf of `owner` through {transferFrom}. This is
51      * zero by default.
52      *
53      * This value changes when {approve} or {transferFrom} are called.
54      */
55     function allowance(address owner, address spender) external view returns (uint256);
56 
57     /**
58      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * IMPORTANT: Beware that changing an allowance with this method brings the risk
63      * that someone may use both the old and the new allowance by unfortunate
64      * transaction ordering. One possible solution to mitigate this race
65      * condition is to first reduce the spender's allowance to 0 and set the
66      * desired value afterwards:
67      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
68      *
69      * Emits an {Approval} event.
70      */
71     function approve(address spender, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Moves `amount` tokens from `from` to `to` using the
75      * allowance mechanism. `amount` is then deducted from the caller's
76      * allowance.
77      *
78      * Returns a boolean value indicating whether the operation succeeded.
79      *
80      * Emits a {Transfer} event.
81      */
82     function transferFrom(
83         address from,
84         address to,
85         uint256 amount
86     ) external returns (bool);
87 }
88 
89 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
90 
91 
92 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
93 
94 pragma solidity ^0.8.0;
95 
96 
97 /**
98  * @dev Interface for the optional metadata functions from the ERC20 standard.
99  *
100  * _Available since v4.1._
101  */
102 interface IERC20Metadata is IERC20 {
103     /**
104      * @dev Returns the name of the token.
105      */
106     function name() external view returns (string memory);
107 
108     /**
109      * @dev Returns the symbol of the token.
110      */
111     function symbol() external view returns (string memory);
112 
113     /**
114      * @dev Returns the decimals places of the token.
115      */
116     function decimals() external view returns (uint8);
117 }
118 
119 // File: @openzeppelin/contracts/utils/Context.sol
120 
121 
122 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
123 
124 pragma solidity ^0.8.0;
125 
126 /**
127  * @dev Provides information about the current execution context, including the
128  * sender of the transaction and its data. While these are generally available
129  * via msg.sender and msg.data, they should not be accessed in such a direct
130  * manner, since when dealing with meta-transactions the account sending and
131  * paying for execution may not be the actual sender (as far as an application
132  * is concerned).
133  *
134  * This contract is only required for intermediate, library-like contracts.
135  */
136 abstract contract Context {
137     function _msgSender() internal view virtual returns (address) {
138         return msg.sender;
139     }
140 
141     function _msgData() internal view virtual returns (bytes calldata) {
142         return msg.data;
143     }
144 }
145 
146 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
147 
148 
149 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
150 
151 pragma solidity ^0.8.0;
152 
153 
154 
155 
156 /**
157  * @dev Implementation of the {IERC20} interface.
158  *
159  * This implementation is agnostic to the way tokens are created. This means
160  * that a supply mechanism has to be added in a derived contract using {_mint}.
161  * For a generic mechanism see {ERC20PresetMinterPauser}.
162  *
163  * TIP: For a detailed writeup see our guide
164  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
165  * to implement supply mechanisms].
166  *
167  * We have followed general OpenZeppelin Contracts guidelines: functions revert
168  * instead returning `false` on failure. This behavior is nonetheless
169  * conventional and does not conflict with the expectations of ERC20
170  * applications.
171  *
172  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
173  * This allows applications to reconstruct the allowance for all accounts just
174  * by listening to said events. Other implementations of the EIP may not emit
175  * these events, as it isn't required by the specification.
176  *
177  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
178  * functions have been added to mitigate the well-known issues around setting
179  * allowances. See {IERC20-approve}.
180  */
181 contract ERC20 is Context, IERC20, IERC20Metadata {
182     mapping(address => uint256) private _balances;
183 
184     mapping(address => mapping(address => uint256)) private _allowances;
185 
186     uint256 private _totalSupply;
187 
188     string private _name;
189     string private _symbol;
190 
191     /**
192      * @dev Sets the values for {name} and {symbol}.
193      *
194      * The default value of {decimals} is 18. To select a different value for
195      * {decimals} you should overload it.
196      *
197      * All two of these values are immutable: they can only be set once during
198      * construction.
199      */
200     constructor(string memory name_, string memory symbol_) {
201         _name = name_;
202         _symbol = symbol_;
203     }
204 
205     /**
206      * @dev Returns the name of the token.
207      */
208     function name() public view virtual override returns (string memory) {
209         return _name;
210     }
211 
212     /**
213      * @dev Returns the symbol of the token, usually a shorter version of the
214      * name.
215      */
216     function symbol() public view virtual override returns (string memory) {
217         return _symbol;
218     }
219 
220     /**
221      * @dev Returns the number of decimals used to get its user representation.
222      * For example, if `decimals` equals `2`, a balance of `505` tokens should
223      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
224      *
225      * Tokens usually opt for a value of 18, imitating the relationship between
226      * Ether and Wei. This is the value {ERC20} uses, unless this function is
227      * overridden;
228      *
229      * NOTE: This information is only used for _display_ purposes: it in
230      * no way affects any of the arithmetic of the contract, including
231      * {IERC20-balanceOf} and {IERC20-transfer}.
232      */
233     function decimals() public view virtual override returns (uint8) {
234         return 18;
235     }
236 
237     /**
238      * @dev See {IERC20-totalSupply}.
239      */
240     function totalSupply() public view virtual override returns (uint256) {
241         return _totalSupply;
242     }
243 
244     /**
245      * @dev See {IERC20-balanceOf}.
246      */
247     function balanceOf(address account) public view virtual override returns (uint256) {
248         return _balances[account];
249     }
250 
251     /**
252      * @dev See {IERC20-transfer}.
253      *
254      * Requirements:
255      *
256      * - `to` cannot be the zero address.
257      * - the caller must have a balance of at least `amount`.
258      */
259     function transfer(address to, uint256 amount) public virtual override returns (bool) {
260         address owner = _msgSender();
261         _transfer(owner, to, amount);
262         return true;
263     }
264 
265     /**
266      * @dev See {IERC20-allowance}.
267      */
268     function allowance(address owner, address spender) public view virtual override returns (uint256) {
269         return _allowances[owner][spender];
270     }
271 
272     /**
273      * @dev See {IERC20-approve}.
274      *
275      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
276      * `transferFrom`. This is semantically equivalent to an infinite approval.
277      *
278      * Requirements:
279      *
280      * - `spender` cannot be the zero address.
281      */
282     function approve(address spender, uint256 amount) public virtual override returns (bool) {
283         address owner = _msgSender();
284         _approve(owner, spender, amount);
285         return true;
286     }
287 
288     /**
289      * @dev See {IERC20-transferFrom}.
290      *
291      * Emits an {Approval} event indicating the updated allowance. This is not
292      * required by the EIP. See the note at the beginning of {ERC20}.
293      *
294      * NOTE: Does not update the allowance if the current allowance
295      * is the maximum `uint256`.
296      *
297      * Requirements:
298      *
299      * - `from` and `to` cannot be the zero address.
300      * - `from` must have a balance of at least `amount`.
301      * - the caller must have allowance for ``from``'s tokens of at least
302      * `amount`.
303      */
304     function transferFrom(
305         address from,
306         address to,
307         uint256 amount
308     ) public virtual override returns (bool) {
309         address spender = _msgSender();
310         _spendAllowance(from, spender, amount);
311         _transfer(from, to, amount);
312         return true;
313     }
314 
315     /**
316      * @dev Atomically increases the allowance granted to `spender` by the caller.
317      *
318      * This is an alternative to {approve} that can be used as a mitigation for
319      * problems described in {IERC20-approve}.
320      *
321      * Emits an {Approval} event indicating the updated allowance.
322      *
323      * Requirements:
324      *
325      * - `spender` cannot be the zero address.
326      */
327     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
328         address owner = _msgSender();
329         _approve(owner, spender, allowance(owner, spender) + addedValue);
330         return true;
331     }
332 
333     /**
334      * @dev Atomically decreases the allowance granted to `spender` by the caller.
335      *
336      * This is an alternative to {approve} that can be used as a mitigation for
337      * problems described in {IERC20-approve}.
338      *
339      * Emits an {Approval} event indicating the updated allowance.
340      *
341      * Requirements:
342      *
343      * - `spender` cannot be the zero address.
344      * - `spender` must have allowance for the caller of at least
345      * `subtractedValue`.
346      */
347     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
348         address owner = _msgSender();
349         uint256 currentAllowance = allowance(owner, spender);
350         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
351         unchecked {
352             _approve(owner, spender, currentAllowance - subtractedValue);
353         }
354 
355         return true;
356     }
357 
358     /**
359      * @dev Moves `amount` of tokens from `from` to `to`.
360      *
361      * This internal function is equivalent to {transfer}, and can be used to
362      * e.g. implement automatic token fees, slashing mechanisms, etc.
363      *
364      * Emits a {Transfer} event.
365      *
366      * Requirements:
367      *
368      * - `from` cannot be the zero address.
369      * - `to` cannot be the zero address.
370      * - `from` must have a balance of at least `amount`.
371      */
372     function _transfer(
373         address from,
374         address to,
375         uint256 amount
376     ) internal virtual {
377         require(from != address(0), "ERC20: transfer from the zero address");
378         require(to != address(0), "ERC20: transfer to the zero address");
379 
380         _beforeTokenTransfer(from, to, amount);
381 
382         uint256 fromBalance = _balances[from];
383         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
384         unchecked {
385             _balances[from] = fromBalance - amount;
386         }
387         _balances[to] += amount;
388 
389         emit Transfer(from, to, amount);
390 
391         _afterTokenTransfer(from, to, amount);
392     }
393 
394     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
395      * the total supply.
396      *
397      * Emits a {Transfer} event with `from` set to the zero address.
398      *
399      * Requirements:
400      *
401      * - `account` cannot be the zero address.
402      */
403     function _mint(address account, uint256 amount) internal virtual {
404         require(account != address(0), "ERC20: mint to the zero address");
405 
406         _beforeTokenTransfer(address(0), account, amount);
407 
408         _totalSupply += amount;
409         _balances[account] += amount;
410         emit Transfer(address(0), account, amount);
411 
412         _afterTokenTransfer(address(0), account, amount);
413     }
414 
415     /**
416      * @dev Destroys `amount` tokens from `account`, reducing the
417      * total supply.
418      *
419      * Emits a {Transfer} event with `to` set to the zero address.
420      *
421      * Requirements:
422      *
423      * - `account` cannot be the zero address.
424      * - `account` must have at least `amount` tokens.
425      */
426     function _burn(address account, uint256 amount) internal virtual {
427         require(account != address(0), "ERC20: burn from the zero address");
428 
429         _beforeTokenTransfer(account, address(0), amount);
430 
431         uint256 accountBalance = _balances[account];
432         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
433         unchecked {
434             _balances[account] = accountBalance - amount;
435         }
436         _totalSupply -= amount;
437 
438         emit Transfer(account, address(0), amount);
439 
440         _afterTokenTransfer(account, address(0), amount);
441     }
442 
443     /**
444      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
445      *
446      * This internal function is equivalent to `approve`, and can be used to
447      * e.g. set automatic allowances for certain subsystems, etc.
448      *
449      * Emits an {Approval} event.
450      *
451      * Requirements:
452      *
453      * - `owner` cannot be the zero address.
454      * - `spender` cannot be the zero address.
455      */
456     function _approve(
457         address owner,
458         address spender,
459         uint256 amount
460     ) internal virtual {
461         require(owner != address(0), "ERC20: approve from the zero address");
462         require(spender != address(0), "ERC20: approve to the zero address");
463 
464         _allowances[owner][spender] = amount;
465         emit Approval(owner, spender, amount);
466     }
467 
468     /**
469      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
470      *
471      * Does not update the allowance amount in case of infinite allowance.
472      * Revert if not enough allowance is available.
473      *
474      * Might emit an {Approval} event.
475      */
476     function _spendAllowance(
477         address owner,
478         address spender,
479         uint256 amount
480     ) internal virtual {
481         uint256 currentAllowance = allowance(owner, spender);
482         if (currentAllowance != type(uint256).max) {
483             require(currentAllowance >= amount, "ERC20: insufficient allowance");
484             unchecked {
485                 _approve(owner, spender, currentAllowance - amount);
486             }
487         }
488     }
489 
490     /**
491      * @dev Hook that is called before any transfer of tokens. This includes
492      * minting and burning.
493      *
494      * Calling conditions:
495      *
496      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
497      * will be transferred to `to`.
498      * - when `from` is zero, `amount` tokens will be minted for `to`.
499      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
500      * - `from` and `to` are never both zero.
501      *
502      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
503      */
504     function _beforeTokenTransfer(
505         address from,
506         address to,
507         uint256 amount
508     ) internal virtual {}
509 
510     /**
511      * @dev Hook that is called after any transfer of tokens. This includes
512      * minting and burning.
513      *
514      * Calling conditions:
515      *
516      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
517      * has been transferred to `to`.
518      * - when `from` is zero, `amount` tokens have been minted for `to`.
519      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
520      * - `from` and `to` are never both zero.
521      *
522      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
523      */
524     function _afterTokenTransfer(
525         address from,
526         address to,
527         uint256 amount
528     ) internal virtual {}
529 }
530 
531 // File: @openzeppelin/contracts/access/Ownable.sol
532 
533 
534 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
535 
536 pragma solidity ^0.8.0;
537 
538 
539 /**
540  * @dev Contract module which provides a basic access control mechanism, where
541  * there is an account (an owner) that can be granted exclusive access to
542  * specific functions.
543  *
544  * By default, the owner account will be the one that deploys the contract. This
545  * can later be changed with {transferOwnership}.
546  *
547  * This module is used through inheritance. It will make available the modifier
548  * `onlyOwner`, which can be applied to your functions to restrict their use to
549  * the owner.
550  */
551 abstract contract Ownable is Context {
552     address private _owner;
553 
554     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
555 
556     /**
557      * @dev Initializes the contract setting the deployer as the initial owner.
558      */
559     constructor() {
560         _transferOwnership(_msgSender());
561     }
562 
563     /**
564      * @dev Returns the address of the current owner.
565      */
566     function owner() public view virtual returns (address) {
567         return _owner;
568     }
569 
570     /**
571      * @dev Throws if called by any account other than the owner.
572      */
573     modifier onlyOwner() {
574         require(owner() == _msgSender(), "Ownable: caller is not the owner");
575         _;
576     }
577 
578     /**
579      * @dev Leaves the contract without owner. It will not be possible to call
580      * `onlyOwner` functions anymore. Can only be called by the current owner.
581      *
582      * NOTE: Renouncing ownership will leave the contract without an owner,
583      * thereby removing any functionality that is only available to the owner.
584      */
585     function renounceOwnership() public virtual onlyOwner {
586         _transferOwnership(address(0));
587     }
588 
589     /**
590      * @dev Transfers ownership of the contract to a new account (`newOwner`).
591      * Can only be called by the current owner.
592      */
593     function transferOwnership(address newOwner) public virtual onlyOwner {
594         require(newOwner != address(0), "Ownable: new owner is the zero address");
595         _transferOwnership(newOwner);
596     }
597 
598     /**
599      * @dev Transfers ownership of the contract to a new account (`newOwner`).
600      * Internal function without access restriction.
601      */
602     function _transferOwnership(address newOwner) internal virtual {
603         address oldOwner = _owner;
604         _owner = newOwner;
605         emit OwnershipTransferred(oldOwner, newOwner);
606     }
607 }
608 
609 // File: contracts/erc_20hdwy.sol
610 
611 //SPDX-License-Identifier: MIT
612 pragma solidity ^0.8.0;
613 
614 
615 
616 contract Hideaways  is ERC20, Ownable  {
617     constructor() ERC20("Hideaways", "HDWY") {}
618 
619     function mint(address account, uint256 amount) public onlyOwner {
620         _mint(account, amount);
621     }
622 
623     function burn(address account, uint256 amount) public onlyOwner {
624         _burn(account, amount);
625     }
626 }