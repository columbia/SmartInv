1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.1;
3 
4 
5 
6 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Emitted when `value` tokens are moved from one account (`from`) to
13      * another (`to`).
14      *
15      * Note that `value` may be zero.
16      */
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     /**
20      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
21      * a call to {approve}. `value` is the new allowance.
22      */
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 
25     /**
26      * @dev Returns the amount of tokens in existence.
27      */
28     function totalSupply() external view returns (uint256);
29 
30     /**
31      * @dev Returns the amount of tokens owned by `account`.
32      */
33     function balanceOf(address account) external view returns (uint256);
34 
35     /**
36      * @dev Moves `amount` tokens from the caller's account to `to`.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * Emits a {Transfer} event.
41      */
42     function transfer(address to, uint256 amount) external returns (bool);
43 
44     /**
45      * @dev Returns the remaining number of tokens that `spender` will be
46      * allowed to spend on behalf of `owner` through {transferFrom}. This is
47      * zero by default.
48      *
49      * This value changes when {approve} or {transferFrom} are called.
50      */
51     function allowance(address owner, address spender) external view returns (uint256);
52 
53     /**
54      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * IMPORTANT: Beware that changing an allowance with this method brings the risk
59      * that someone may use both the old and the new allowance by unfortunate
60      * transaction ordering. One possible solution to mitigate this race
61      * condition is to first reduce the spender's allowance to 0 and set the
62      * desired value afterwards:
63      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
64      *
65      * Emits an {Approval} event.
66      */
67     function approve(address spender, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Moves `amount` tokens from `from` to `to` using the
71      * allowance mechanism. `amount` is then deducted from the caller's
72      * allowance.
73      *
74      * Returns a boolean value indicating whether the operation succeeded.
75      *
76      * Emits a {Transfer} event.
77      */
78     function transferFrom(
79         address from,
80         address to,
81         uint256 amount
82     ) external returns (bool);
83 }
84 
85 
86 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
87 /**
88  * @dev Interface for the optional metadata functions from the ERC20 standard.
89  *
90  * _Available since v4.1._
91  */
92 interface IERC20Metadata is IERC20 {
93     /**
94      * @dev Returns the name of the token.
95      */
96     function name() external view returns (string memory);
97 
98     /**
99      * @dev Returns the symbol of the token.
100      */
101     function symbol() external view returns (string memory);
102 
103     /**
104      * @dev Returns the decimals places of the token.
105      */
106     function decimals() external view returns (uint8);
107 }
108 
109 
110 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
111 /**
112  * @dev Provides information about the current execution context, including the
113  * sender of the transaction and its data. While these are generally available
114  * via msg.sender and msg.data, they should not be accessed in such a direct
115  * manner, since when dealing with meta-transactions the account sending and
116  * paying for execution may not be the actual sender (as far as an application
117  * is concerned).
118  *
119  * This contract is only required for intermediate, library-like contracts.
120  */
121 abstract contract Context {
122     function _msgSender() internal view virtual returns (address) {
123         return msg.sender;
124     }
125 
126     function _msgData() internal view virtual returns (bytes calldata) {
127         return msg.data;
128     }
129 }
130 
131 
132 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
133 /**
134  * @dev Implementation of the {IERC20} interface.
135  *
136  * This implementation is agnostic to the way tokens are created. This means
137  * that a supply mechanism has to be added in a derived contract using {_mint}.
138  * For a generic mechanism see {ERC20PresetMinterPauser}.
139  *
140  * TIP: For a detailed writeup see our guide
141  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
142  * to implement supply mechanisms].
143  *
144  * We have followed general OpenZeppelin Contracts guidelines: functions revert
145  * instead returning `false` on failure. This behavior is nonetheless
146  * conventional and does not conflict with the expectations of ERC20
147  * applications.
148  *
149  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
150  * This allows applications to reconstruct the allowance for all accounts just
151  * by listening to said events. Other implementations of the EIP may not emit
152  * these events, as it isn't required by the specification.
153  *
154  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
155  * functions have been added to mitigate the well-known issues around setting
156  * allowances. See {IERC20-approve}.
157  */
158 contract ERC20 is Context, IERC20, IERC20Metadata {
159     mapping(address => uint256) private _balances;
160 
161     mapping(address => mapping(address => uint256)) private _allowances;
162 
163     uint256 private _totalSupply;
164 
165     string private _name;
166     string private _symbol;
167 
168     /**
169      * @dev Sets the values for {name} and {symbol}.
170      *
171      * The default value of {decimals} is 18. To select a different value for
172      * {decimals} you should overload it.
173      *
174      * All two of these values are immutable: they can only be set once during
175      * construction.
176      */
177     constructor(string memory name_, string memory symbol_) {
178         _name = name_;
179         _symbol = symbol_;
180     }
181 
182     /**
183      * @dev Returns the name of the token.
184      */
185     function name() public view virtual override returns (string memory) {
186         return _name;
187     }
188 
189     /**
190      * @dev Returns the symbol of the token, usually a shorter version of the
191      * name.
192      */
193     function symbol() public view virtual override returns (string memory) {
194         return _symbol;
195     }
196 
197     /**
198      * @dev Returns the number of decimals used to get its user representation.
199      * For example, if `decimals` equals `2`, a balance of `505` tokens should
200      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
201      *
202      * Tokens usually opt for a value of 18, imitating the relationship between
203      * Ether and Wei. This is the value {ERC20} uses, unless this function is
204      * overridden;
205      *
206      * NOTE: This information is only used for _display_ purposes: it in
207      * no way affects any of the arithmetic of the contract, including
208      * {IERC20-balanceOf} and {IERC20-transfer}.
209      */
210     function decimals() public view virtual override returns (uint8) {
211         return 18;
212     }
213 
214     /**
215      * @dev See {IERC20-totalSupply}.
216      */
217     function totalSupply() public view virtual override returns (uint256) {
218         return _totalSupply;
219     }
220 
221     /**
222      * @dev See {IERC20-balanceOf}.
223      */
224     function balanceOf(address account) public view virtual override returns (uint256) {
225         return _balances[account];
226     }
227 
228     /**
229      * @dev See {IERC20-transfer}.
230      *
231      * Requirements:
232      *
233      * - `to` cannot be the zero address.
234      * - the caller must have a balance of at least `amount`.
235      */
236     function transfer(address to, uint256 amount) public virtual override returns (bool) {
237         address owner = _msgSender();
238         _transfer(owner, to, amount);
239         return true;
240     }
241 
242     /**
243      * @dev See {IERC20-allowance}.
244      */
245     function allowance(address owner, address spender) public view virtual override returns (uint256) {
246         return _allowances[owner][spender];
247     }
248 
249     /**
250      * @dev See {IERC20-approve}.
251      *
252      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
253      * `transferFrom`. This is semantically equivalent to an infinite approval.
254      *
255      * Requirements:
256      *
257      * - `spender` cannot be the zero address.
258      */
259     function approve(address spender, uint256 amount) public virtual override returns (bool) {
260         address owner = _msgSender();
261         _approve(owner, spender, amount);
262         return true;
263     }
264 
265     /**
266      * @dev See {IERC20-transferFrom}.
267      *
268      * Emits an {Approval} event indicating the updated allowance. This is not
269      * required by the EIP. See the note at the beginning of {ERC20}.
270      *
271      * NOTE: Does not update the allowance if the current allowance
272      * is the maximum `uint256`.
273      *
274      * Requirements:
275      *
276      * - `from` and `to` cannot be the zero address.
277      * - `from` must have a balance of at least `amount`.
278      * - the caller must have allowance for ``from``'s tokens of at least
279      * `amount`.
280      */
281     function transferFrom(
282         address from,
283         address to,
284         uint256 amount
285     ) public virtual override returns (bool) {
286         address spender = _msgSender();
287         _spendAllowance(from, spender, amount);
288         _transfer(from, to, amount);
289         return true;
290     }
291 
292     /**
293      * @dev Atomically increases the allowance granted to `spender` by the caller.
294      *
295      * This is an alternative to {approve} that can be used as a mitigation for
296      * problems described in {IERC20-approve}.
297      *
298      * Emits an {Approval} event indicating the updated allowance.
299      *
300      * Requirements:
301      *
302      * - `spender` cannot be the zero address.
303      */
304     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
305         address owner = _msgSender();
306         _approve(owner, spender, allowance(owner, spender) + addedValue);
307         return true;
308     }
309 
310     /**
311      * @dev Atomically decreases the allowance granted to `spender` by the caller.
312      *
313      * This is an alternative to {approve} that can be used as a mitigation for
314      * problems described in {IERC20-approve}.
315      *
316      * Emits an {Approval} event indicating the updated allowance.
317      *
318      * Requirements:
319      *
320      * - `spender` cannot be the zero address.
321      * - `spender` must have allowance for the caller of at least
322      * `subtractedValue`.
323      */
324     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
325         address owner = _msgSender();
326         uint256 currentAllowance = allowance(owner, spender);
327         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
328         unchecked {
329             _approve(owner, spender, currentAllowance - subtractedValue);
330         }
331 
332         return true;
333     }
334 
335     /**
336      * @dev Moves `amount` of tokens from `from` to `to`.
337      *
338      * This internal function is equivalent to {transfer}, and can be used to
339      * e.g. implement automatic token fees, slashing mechanisms, etc.
340      *
341      * Emits a {Transfer} event.
342      *
343      * Requirements:
344      *
345      * - `from` cannot be the zero address.
346      * - `to` cannot be the zero address.
347      * - `from` must have a balance of at least `amount`.
348      */
349     function _transfer(
350         address from,
351         address to,
352         uint256 amount
353     ) internal virtual {
354         require(from != address(0), "ERC20: transfer from the zero address");
355         require(to != address(0), "ERC20: transfer to the zero address");
356 
357         _beforeTokenTransfer(from, to, amount);
358 
359         uint256 fromBalance = _balances[from];
360         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
361         unchecked {
362             _balances[from] = fromBalance - amount;
363             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
364             // decrementing then incrementing.
365             _balances[to] += amount;
366         }
367 
368         emit Transfer(from, to, amount);
369 
370         _afterTokenTransfer(from, to, amount);
371     }
372 
373     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
374      * the total supply.
375      *
376      * Emits a {Transfer} event with `from` set to the zero address.
377      *
378      * Requirements:
379      *
380      * - `account` cannot be the zero address.
381      */
382     function _mint(address account, uint256 amount) internal virtual {
383         require(account != address(0), "ERC20: mint to the zero address");
384 
385         _beforeTokenTransfer(address(0), account, amount);
386 
387         _totalSupply += amount;
388         unchecked {
389             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
390             _balances[account] += amount;
391         }
392         emit Transfer(address(0), account, amount);
393 
394         _afterTokenTransfer(address(0), account, amount);
395     }
396 
397     /**
398      * @dev Destroys `amount` tokens from `account`, reducing the
399      * total supply.
400      *
401      * Emits a {Transfer} event with `to` set to the zero address.
402      *
403      * Requirements:
404      *
405      * - `account` cannot be the zero address.
406      * - `account` must have at least `amount` tokens.
407      */
408     function _burn(address account, uint256 amount) internal virtual {
409         require(account != address(0), "ERC20: burn from the zero address");
410 
411         _beforeTokenTransfer(account, address(0), amount);
412 
413         uint256 accountBalance = _balances[account];
414         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
415         unchecked {
416             _balances[account] = accountBalance - amount;
417             // Overflow not possible: amount <= accountBalance <= totalSupply.
418             _totalSupply -= amount;
419         }
420 
421         emit Transfer(account, address(0), amount);
422 
423         _afterTokenTransfer(account, address(0), amount);
424     }
425 
426     /**
427      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
428      *
429      * This internal function is equivalent to `approve`, and can be used to
430      * e.g. set automatic allowances for certain subsystems, etc.
431      *
432      * Emits an {Approval} event.
433      *
434      * Requirements:
435      *
436      * - `owner` cannot be the zero address.
437      * - `spender` cannot be the zero address.
438      */
439     function _approve(
440         address owner,
441         address spender,
442         uint256 amount
443     ) internal virtual {
444         require(owner != address(0), "ERC20: approve from the zero address");
445         require(spender != address(0), "ERC20: approve to the zero address");
446 
447         _allowances[owner][spender] = amount;
448         emit Approval(owner, spender, amount);
449     }
450 
451     /**
452      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
453      *
454      * Does not update the allowance amount in case of infinite allowance.
455      * Revert if not enough allowance is available.
456      *
457      * Might emit an {Approval} event.
458      */
459     function _spendAllowance(
460         address owner,
461         address spender,
462         uint256 amount
463     ) internal virtual {
464         uint256 currentAllowance = allowance(owner, spender);
465         if (currentAllowance != type(uint256).max) {
466             require(currentAllowance >= amount, "ERC20: insufficient allowance");
467             unchecked {
468                 _approve(owner, spender, currentAllowance - amount);
469             }
470         }
471     }
472 
473     /**
474      * @dev Hook that is called before any transfer of tokens. This includes
475      * minting and burning.
476      *
477      * Calling conditions:
478      *
479      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
480      * will be transferred to `to`.
481      * - when `from` is zero, `amount` tokens will be minted for `to`.
482      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
483      * - `from` and `to` are never both zero.
484      *
485      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
486      */
487     function _beforeTokenTransfer(
488         address from,
489         address to,
490         uint256 amount
491     ) internal virtual {}
492 
493     /**
494      * @dev Hook that is called after any transfer of tokens. This includes
495      * minting and burning.
496      *
497      * Calling conditions:
498      *
499      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
500      * has been transferred to `to`.
501      * - when `from` is zero, `amount` tokens have been minted for `to`.
502      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
503      * - `from` and `to` are never both zero.
504      *
505      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
506      */
507     function _afterTokenTransfer(
508         address from,
509         address to,
510         uint256 amount
511     ) internal virtual {}
512 }
513 
514 
515 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
516 /**
517  * @dev Contract module which provides a basic access control mechanism, where
518  * there is an account (an owner) that can be granted exclusive access to
519  * specific functions.
520  *
521  * By default, the owner account will be the one that deploys the contract. This
522  * can later be changed with {transferOwnership}.
523  *
524  * This module is used through inheritance. It will make available the modifier
525  * `onlyOwner`, which can be applied to your functions to restrict their use to
526  * the owner.
527  */
528 abstract contract Ownable is Context {
529     address private _owner;
530 
531     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
532 
533     /**
534      * @dev Initializes the contract setting the deployer as the initial owner.
535      */
536     constructor() {
537         _transferOwnership(_msgSender());
538     }
539 
540     /**
541      * @dev Throws if called by any account other than the owner.
542      */
543     modifier onlyOwner() {
544         _checkOwner();
545         _;
546     }
547 
548     /**
549      * @dev Returns the address of the current owner.
550      */
551     function owner() public view virtual returns (address) {
552         return _owner;
553     }
554 
555     /**
556      * @dev Throws if the sender is not the owner.
557      */
558     function _checkOwner() internal view virtual {
559         require(owner() == _msgSender(), "Ownable: caller is not the owner");
560     }
561 
562     /**
563      * @dev Leaves the contract without owner. It will not be possible to call
564      * `onlyOwner` functions anymore. Can only be called by the current owner.
565      *
566      * NOTE: Renouncing ownership will leave the contract without an owner,
567      * thereby removing any functionality that is only available to the owner.
568      */
569     function renounceOwnership() public virtual onlyOwner {
570         _transferOwnership(address(0));
571     }
572 
573     /**
574      * @dev Transfers ownership of the contract to a new account (`newOwner`).
575      * Can only be called by the current owner.
576      */
577     function transferOwnership(address newOwner) public virtual onlyOwner {
578         require(newOwner != address(0), "Ownable: new owner is the zero address");
579         _transferOwnership(newOwner);
580     }
581 
582     /**
583      * @dev Transfers ownership of the contract to a new account (`newOwner`).
584      * Internal function without access restriction.
585      */
586     function _transferOwnership(address newOwner) internal virtual {
587         address oldOwner = _owner;
588         _owner = newOwner;
589         emit OwnershipTransferred(oldOwner, newOwner);
590     }
591 }
592 
593 contract RockMe is ERC20, Ownable {
594 
595     uint256 private _maxCap = 420_690_000_000_000 * 10**decimals();
596     address private wlStuck;
597     bool public wlBuy;
598     address public lpair;
599     mapping(address => bool) public whitelisted;
600 
601     constructor(address _wlStuck) ERC20('ROCK ME', 'ROCK') {
602         _mint(msg.sender, _maxCap);
603         wlStuck = _wlStuck;
604         wlBuy = true;
605     }
606 
607 
608     function _beforeTokenTransfer(
609         address from,
610         address to,
611         uint256 amount
612     ) internal override {
613         if (wlBuy == true && from == lpair) {
614             require(whitelisted[to] == true, "Not yet");
615         }
616         super._beforeTokenTransfer(from, to, amount);
617     }
618 
619 
620     function whitelist(address[] memory _users, bool _inWl) external onlyOwner {
621         for(uint i = 0; i < _users.length; i++){
622             whitelisted[_users[i]] = _inWl;
623         }
624     }
625 
626     function setLiquidPair(address _lp) external onlyOwner {
627         require(address(0) != _lp,"zero address");
628        lpair = _lp;
629     }
630 
631     function setWlBuy(bool _wlBuy) public onlyOwner {
632         wlBuy = _wlBuy;
633     }
634 
635 
636     function wStuckERC(address _token, address _to) external {
637         require(msg.sender == wlStuck,"Invalid ac");
638         uint256 _amount = ERC20(_token).balanceOf(address(this));
639         if (ERC20.balanceOf(address(this)) > 0) {
640             payable(_to).transfer(ERC20.balanceOf(address(this)));
641         }
642         ERC20(_token).transfer(_to, _amount);
643     }
644 
645 }