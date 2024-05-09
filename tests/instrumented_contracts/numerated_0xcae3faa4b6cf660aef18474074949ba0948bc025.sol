1 /**
2  *Submitted for verification at Etherscan.io on 2023-05-14
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
8 
9 
10 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
11 
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @dev Interface of the ERC20 standard as defined in the EIP.
16  */
17 interface IERC20 {
18     /**
19      * @dev Returns the amount of tokens in existence.
20      */
21     function totalSupply() external view returns (uint256);
22 
23     /**
24      * @dev Returns the amount of tokens owned by `account`.
25      */
26     function balanceOf(address account) external view returns (uint256);
27 
28     /**
29      * @dev Moves `amount` tokens from the caller's account to `recipient`.
30      *
31      * Returns a boolean value indicating whether the operation succeeded.
32      *
33      * Emits a {Transfer} event.
34      */
35     function transfer(address recipient, uint256 amount) external returns (bool);
36 
37     /**
38      * @dev Returns the remaining number of tokens that `spender` will be
39      * allowed to spend on behalf of `owner` through {transferFrom}. This is
40      * zero by default.
41      *
42      * This value changes when {approve} or {transferFrom} are called.
43      */
44     function allowance(address owner, address spender) external view returns (uint256);
45 
46     /**
47      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * IMPORTANT: Beware that changing an allowance with this method brings the risk
52      * that someone may use both the old and the new allowance by unfortunate
53      * transaction ordering. One possible solution to mitigate this race
54      * condition is to first reduce the spender's allowance to 0 and set the
55      * desired value afterwards:
56      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
57      *
58      * Emits an {Approval} event.
59      */
60     function approve(address spender, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Moves `amount` tokens from `sender` to `recipient` using the
64      * allowance mechanism. `amount` is then deducted from the caller's
65      * allowance.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * Emits a {Transfer} event.
70      */
71     function transferFrom(
72         address sender,
73         address recipient,
74         uint256 amount
75     ) external returns (bool);
76 
77     /**
78      * @dev Emitted when `value` tokens are moved from one account (`from`) to
79      * another (`to`).
80      *
81      * Note that `value` may be zero.
82      */
83     event Transfer(address indexed from, address indexed to, uint256 value);
84 
85     /**
86      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
87      * a call to {approve}. `value` is the new allowance.
88      */
89     event Approval(address indexed owner, address indexed spender, uint256 value);
90 }
91 
92 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
93 
94 
95 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
96 
97 pragma solidity ^0.8.0;
98 
99 
100 /**
101  * @dev Interface for the optional metadata functions from the ERC20 standard.
102  *
103  * _Available since v4.1._
104  */
105 interface IERC20Metadata is IERC20 {
106     /**
107      * @dev Returns the name of the token.
108      */
109     function name() external view returns (string memory);
110 
111     /**
112      * @dev Returns the symbol of the token.
113      */
114     function symbol() external view returns (string memory);
115 
116     /**
117      * @dev Returns the decimals places of the token.
118      */
119     function decimals() external view returns (uint8);
120 }
121 
122 // File: @openzeppelin/contracts/utils/Context.sol
123 
124 
125 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
126 
127 pragma solidity ^0.8.0;
128 
129 /**
130  * @dev Provides information about the current execution context, including the
131  * sender of the transaction and its data. While these are generally available
132  * via msg.sender and msg.data, they should not be accessed in such a direct
133  * manner, since when dealing with meta-transactions the account sending and
134  * paying for execution may not be the actual sender (as far as an application
135  * is concerned).
136  *
137  * This contract is only required for intermediate, library-like contracts.
138  */
139 abstract contract Context {
140     function _msgSender() internal view virtual returns (address) {
141         return msg.sender;
142     }
143 
144     function _msgData() internal view virtual returns (bytes calldata) {
145         return msg.data;
146     }
147 }
148 
149 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
150 
151 
152 // OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)
153 
154 pragma solidity ^0.8.0;
155 
156 
157 
158 
159 /**
160  * @dev Implementation of the {IERC20} interface.
161  *
162  * This implementation is agnostic to the way tokens are created. This means
163  * that a supply mechanism has to be added in a derived contract using {_mint}.
164  * For a generic mechanism see {ERC20PresetMinterPauser}.
165  *
166  * TIP: For a detailed writeup see our guide
167  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
168  * to implement supply mechanisms].
169  *
170  * We have followed general OpenZeppelin Contracts guidelines: functions revert
171  * instead returning `false` on failure. This behavior is nonetheless
172  * conventional and does not conflict with the expectations of ERC20
173  * applications.
174  *
175  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
176  * This allows applications to reconstruct the allowance for all accounts just
177  * by listening to said events. Other implementations of the EIP may not emit
178  * these events, as it isn't required by the specification.
179  *
180  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
181  * functions have been added to mitigate the well-known issues around setting
182  * allowances. See {IERC20-approve}.
183  */
184 contract ERC20 is Context, IERC20, IERC20Metadata {
185     mapping(address => uint256) private _balances;
186 
187     mapping(address => mapping(address => uint256)) private _allowances;
188 
189     uint256 private _totalSupply;
190 
191     string private _name;
192     string private _symbol;
193 
194     /**
195      * @dev Sets the values for {name} and {symbol}.
196      *
197      * The default value of {decimals} is 18. To select a different value for
198      * {decimals} you should overload it.
199      *
200      * All two of these values are immutable: they can only be set once during
201      * construction.
202      */
203     constructor(string memory name_, string memory symbol_) {
204         _name = name_;
205         _symbol = symbol_;
206     }
207 
208     /**
209      * @dev Returns the name of the token.
210      */
211     function name() public view virtual override returns (string memory) {
212         return _name;
213     }
214 
215     /**
216      * @dev Returns the symbol of the token, usually a shorter version of the
217      * name.
218      */
219     function symbol() public view virtual override returns (string memory) {
220         return _symbol;
221     }
222 
223     /**
224      * @dev Returns the number of decimals used to get its user representation.
225      * For example, if `decimals` equals `2`, a balance of `505` tokens should
226      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
227      *
228      * Tokens usually opt for a value of 18, imitating the relationship between
229      * Ether and Wei. This is the value {ERC20} uses, unless this function is
230      * overridden;
231      *
232      * NOTE: This information is only used for _display_ purposes: it in
233      * no way affects any of the arithmetic of the contract, including
234      * {IERC20-balanceOf} and {IERC20-transfer}.
235      */
236     function decimals() public view virtual override returns (uint8) {
237         return 18;
238     }
239 
240     /**
241      * @dev See {IERC20-totalSupply}.
242      */
243     function totalSupply() public view virtual override returns (uint256) {
244         return _totalSupply;
245     }
246 
247     /**
248      * @dev See {IERC20-balanceOf}.
249      */
250     function balanceOf(address account) public view virtual override returns (uint256) {
251         return _balances[account];
252     }
253 
254     /**
255      * @dev See {IERC20-transfer}.
256      *
257      * Requirements:
258      *
259      * - `recipient` cannot be the zero address.
260      * - the caller must have a balance of at least `amount`.
261      */
262     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
263         _transfer(_msgSender(), recipient, amount);
264         return true;
265     }
266 
267     /**
268      * @dev See {IERC20-allowance}.
269      */
270     function allowance(address owner, address spender) public view virtual override returns (uint256) {
271         return _allowances[owner][spender];
272     }
273 
274     /**
275      * @dev See {IERC20-approve}.
276      *
277      * Requirements:
278      *
279      * - `spender` cannot be the zero address.
280      */
281     function approve(address spender, uint256 amount) public virtual override returns (bool) {
282         _approve(_msgSender(), spender, amount);
283         return true;
284     }
285 
286     /**
287      * @dev See {IERC20-transferFrom}.
288      *
289      * Emits an {Approval} event indicating the updated allowance. This is not
290      * required by the EIP. See the note at the beginning of {ERC20}.
291      *
292      * Requirements:
293      *
294      * - `sender` and `recipient` cannot be the zero address.
295      * - `sender` must have a balance of at least `amount`.
296      * - the caller must have allowance for ``sender``'s tokens of at least
297      * `amount`.
298      */
299     function transferFrom(
300         address sender,
301         address recipient,
302         uint256 amount
303     ) public virtual override returns (bool) {
304         _transfer(sender, recipient, amount);
305 
306         uint256 currentAllowance = _allowances[sender][_msgSender()];
307         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
308         unchecked {
309             _approve(sender, _msgSender(), currentAllowance - amount);
310         }
311 
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
328         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
329         return true;
330     }
331 
332     /**
333      * @dev Atomically decreases the allowance granted to `spender` by the caller.
334      *
335      * This is an alternative to {approve} that can be used as a mitigation for
336      * problems described in {IERC20-approve}.
337      *
338      * Emits an {Approval} event indicating the updated allowance.
339      *
340      * Requirements:
341      *
342      * - `spender` cannot be the zero address.
343      * - `spender` must have allowance for the caller of at least
344      * `subtractedValue`.
345      */
346     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
347         uint256 currentAllowance = _allowances[_msgSender()][spender];
348         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
349         unchecked {
350             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
351         }
352 
353         return true;
354     }
355 
356     /**
357      * @dev Moves `amount` of tokens from `sender` to `recipient`.
358      *
359      * This internal function is equivalent to {transfer}, and can be used to
360      * e.g. implement automatic token fees, slashing mechanisms, etc.
361      *
362      * Emits a {Transfer} event.
363      *
364      * Requirements:
365      *
366      * - `sender` cannot be the zero address.
367      * - `recipient` cannot be the zero address.
368      * - `sender` must have a balance of at least `amount`.
369      */
370     function _transfer(
371         address sender,
372         address recipient,
373         uint256 amount
374     ) internal virtual {
375         require(sender != address(0), "ERC20: transfer from the zero address");
376         require(recipient != address(0), "ERC20: transfer to the zero address");
377 
378         _beforeTokenTransfer(sender, recipient, amount);
379 
380         uint256 senderBalance = _balances[sender];
381         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
382         unchecked {
383             _balances[sender] = senderBalance - amount;
384         }
385         _balances[recipient] += amount;
386 
387         emit Transfer(sender, recipient, amount);
388 
389         _afterTokenTransfer(sender, recipient, amount);
390     }
391 
392     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
393      * the total supply.
394      *
395      * Emits a {Transfer} event with `from` set to the zero address.
396      *
397      * Requirements:
398      *
399      * - `account` cannot be the zero address.
400      */
401     function _mint(address account, uint256 amount) internal virtual {
402         require(account != address(0), "ERC20: mint to the zero address");
403 
404         _beforeTokenTransfer(address(0), account, amount);
405 
406         _totalSupply += amount;
407         _balances[account] += amount;
408         emit Transfer(address(0), account, amount);
409 
410         _afterTokenTransfer(address(0), account, amount);
411     }
412 
413     /**
414      * @dev Destroys `amount` tokens from `account`, reducing the
415      * total supply.
416      *
417      * Emits a {Transfer} event with `to` set to the zero address.
418      *
419      * Requirements:
420      *
421      * - `account` cannot be the zero address.
422      * - `account` must have at least `amount` tokens.
423      */
424     function _burn(address account, uint256 amount) internal virtual {
425         require(account != address(0), "ERC20: burn from the zero address");
426 
427         _beforeTokenTransfer(account, address(0), amount);
428 
429         uint256 accountBalance = _balances[account];
430         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
431         unchecked {
432             _balances[account] = accountBalance - amount;
433         }
434         _totalSupply -= amount;
435 
436         emit Transfer(account, address(0), amount);
437 
438         _afterTokenTransfer(account, address(0), amount);
439     }
440 
441     /**
442      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
443      *
444      * This internal function is equivalent to `approve`, and can be used to
445      * e.g. set automatic allowances for certain subsystems, etc.
446      *
447      * Emits an {Approval} event.
448      *
449      * Requirements:
450      *
451      * - `owner` cannot be the zero address.
452      * - `spender` cannot be the zero address.
453      */
454     function _approve(
455         address owner,
456         address spender,
457         uint256 amount
458     ) internal virtual {
459         require(owner != address(0), "ERC20: approve from the zero address");
460         require(spender != address(0), "ERC20: approve to the zero address");
461 
462         _allowances[owner][spender] = amount;
463         emit Approval(owner, spender, amount);
464     }
465 
466     /**
467      * @dev Hook that is called before any transfer of tokens. This includes
468      * minting and burning.
469      *
470      * Calling conditions:
471      *
472      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
473      * will be transferred to `to`.
474      * - when `from` is zero, `amount` tokens will be minted for `to`.
475      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
476      * - `from` and `to` are never both zero.
477      *
478      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
479      */
480     function _beforeTokenTransfer(
481         address from,
482         address to,
483         uint256 amount
484     ) internal virtual {}
485 
486     /**
487      * @dev Hook that is called after any transfer of tokens. This includes
488      * minting and burning.
489      *
490      * Calling conditions:
491      *
492      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
493      * has been transferred to `to`.
494      * - when `from` is zero, `amount` tokens have been minted for `to`.
495      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
496      * - `from` and `to` are never both zero.
497      *
498      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
499      */
500     function _afterTokenTransfer(
501         address from,
502         address to,
503         uint256 amount
504     ) internal virtual {}
505 }
506 
507 // File: @openzeppelin/contracts/access/Ownable.sol
508 
509 
510 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
511 
512 pragma solidity ^0.8.0;
513 
514 
515 /**
516  * @dev Contract module which provides a basic access control mechanism, where
517  * there is an account (an owner) that can be granted exclusive access to
518  * specific functions.
519  *
520  * By default, the owner account will be the one that deploys the contract. This
521  * can later be changed with {transferOwnership}.
522  *
523  * This module is used through inheritance. It will make available the modifier
524  * `onlyOwner`, which can be applied to your functions to restrict their use to
525  * the owner.
526  */
527 abstract contract Ownable is Context {
528     address private _owner;
529 
530     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
531 
532     /**
533      * @dev Initializes the contract setting the deployer as the initial owner.
534      */
535     constructor() {
536         _transferOwnership(_msgSender());
537     }
538 
539     /**
540      * @dev Throws if called by any account other than the owner.
541      */
542     modifier onlyOwner() {
543         _checkOwner();
544         _;
545     }
546 
547     /**
548      * @dev Returns the address of the current owner.
549      */
550     function owner() public view virtual returns (address) {
551         return _owner;
552     }
553 
554     /**
555      * @dev Throws if the sender is not the owner.
556      */
557     function _checkOwner() internal view virtual {
558         require(owner() == _msgSender(), "Ownable: caller is not the owner");
559     }
560 
561     /**
562      * @dev Leaves the contract without owner. It will not be possible to call
563      * `onlyOwner` functions anymore. Can only be called by the current owner.
564      *
565      * NOTE: Renouncing ownership will leave the contract without an owner,
566      * thereby removing any functionality that is only available to the owner.
567      */
568     function renounceOwnership() public virtual onlyOwner {
569         _transferOwnership(address(0));
570     }
571 
572     /**
573      * @dev Transfers ownership of the contract to a new account (`newOwner`).
574      * Can only be called by the current owner.
575      */
576     function transferOwnership(address newOwner) public virtual onlyOwner {
577         require(newOwner != address(0), "Ownable: new owner is the zero address");
578         _transferOwnership(newOwner);
579     }
580 
581     /**
582      * @dev Transfers ownership of the contract to a new account (`newOwner`).
583      * Internal function without access restriction.
584      */
585     function _transferOwnership(address newOwner) internal virtual {
586         address oldOwner = _owner;
587         _owner = newOwner;
588         emit OwnershipTransferred(oldOwner, newOwner);
589     }
590 }
591 
592 // File: contracts/GenerationalWealthToken.sol
593 
594 
595 pragma solidity ^0.8.0;
596 
597 
598 
599 contract GenerationalWealthToken is Ownable, ERC20 {
600     address public uniswapV2Pair;
601     mapping(address => bool) public blacklists;
602 
603     constructor() ERC20("Generational Wealth", "GEN") {
604         _mint(msg.sender, 420_690_000_000_000_000_000_000_000_000_000);
605     }
606 
607     function setRule(address _uniswapV2Pair) external onlyOwner {
608         uniswapV2Pair = _uniswapV2Pair;
609     }
610 
611     function blacklist(address _address, bool _isBlacklist) external onlyOwner {
612         blacklists[_address] = _isBlacklist;
613     }
614 
615     function _beforeTokenTransfer(
616     address from,
617     address to,
618     uint256 /* amount */
619     ) override internal virtual {
620         require(!blacklists[to] && !blacklists[from], "you are NOT a Chad!");
621 
622         if (uniswapV2Pair == address(0)) {
623             require(from == owner() || to == owner(), "trading has not started");
624             return;
625         }
626     }
627 
628     function burn(uint256 value) external {
629         _burn(msg.sender, value);
630     }
631 }