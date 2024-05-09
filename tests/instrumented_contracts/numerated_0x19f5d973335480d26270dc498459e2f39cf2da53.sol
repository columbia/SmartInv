1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
3 
4 pragma solidity ^0.8.18;
5 
6 /**
7  * @dev Interface of the ERC20 standard as defined in the EIP.
8  */
9 interface IERC20 {
10     /**
11      * @dev Emitted when `value` tokens are moved from one account (`from`) to
12      * another (`to`).
13      *
14      * Note that `value` may be zero.
15      */
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     /**
19      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
20      * a call to {approve}. `value` is the new allowance.
21      */
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 
24     /**
25      * @dev Returns the amount of tokens in existence.
26      */
27     function totalSupply() external view returns (uint256);
28 
29     /**
30      * @dev Returns the amount of tokens owned by `account`.
31      */
32     function balanceOf(address account) external view returns (uint256);
33 
34     /**
35      * @dev Moves `amount` tokens from the caller's account to `to`.
36      *
37      * Returns a boolean value indicating whether the operation succeeded.
38      *
39      * Emits a {Transfer} event.
40      */
41     function transfer(address to, uint256 amount) external returns (bool);
42 
43     /**
44      * @dev Returns the remaining number of tokens that `spender` will be
45      * allowed to spend on behalf of `owner` through {transferFrom}. This is
46      * zero by default.
47      *
48      * This value changes when {approve} or {transferFrom} are called.
49      */
50     function allowance(address owner, address spender) external view returns (uint256);
51 
52     /**
53      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * IMPORTANT: Beware that changing an allowance with this method brings the risk
58      * that someone may use both the old and the new allowance by unfortunate
59      * transaction ordering. One possible solution to mitigate this race
60      * condition is to first reduce the spender's allowance to 0 and set the
61      * desired value afterwards:
62      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
63      *
64      * Emits an {Approval} event.
65      */
66     function approve(address spender, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Moves `amount` tokens from `from` to `to` using the
70      * allowance mechanism. `amount` is then deducted from the caller's
71      * allowance.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * Emits a {Transfer} event.
76      */
77     function transferFrom(address from, address to, uint256 amount) external returns (bool);
78 }
79 
80 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
81 
82 pragma solidity ^0.8.18;
83 
84 /**
85  * @dev Interface for the optional metadata functions from the ERC20 standard.
86  *
87  * _Available since v4.1._
88  */
89 interface IERC20Metadata is IERC20 {
90     /**
91      * @dev Returns the name of the token.
92      */
93     function name() external view returns (string memory);
94 
95     /**
96      * @dev Returns the symbol of the token.
97      */
98     function symbol() external view returns (string memory);
99 
100     /**
101      * @dev Returns the decimals places of the token.
102      */
103     function decimals() external view returns (uint8);
104 }
105 
106 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
107 
108 pragma solidity ^0.8.18;
109 
110 /**
111  * @dev Provides information about the current execution context, including the
112  * sender of the transaction and its data. While these are generally available
113  * via msg.sender and msg.data, they should not be accessed in such a direct
114  * manner, since when dealing with meta-transactions the account sending and
115  * paying for execution may not be the actual sender (as far as an application
116  * is concerned).
117  *
118  * This contract is only required for intermediate, library-like contracts.
119  */
120 abstract contract Context {
121     function _msgSender() internal view virtual returns (address) {
122         return msg.sender;
123     }
124 
125     function _msgData() internal view virtual returns (bytes calldata) {
126         return msg.data;
127     }
128 }
129 
130 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
131 
132 pragma solidity ^0.8.18;
133 
134 /**
135  * @dev Implementation of the {IERC20} interface.
136  *
137  * This implementation is agnostic to the way tokens are created. This means
138  * that a supply mechanism has to be added in a derived contract using {_mint}.
139  * For a generic mechanism see {ERC20PresetMinterPauser}.
140  *
141  * TIP: For a detailed writeup see our guide
142  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
143  * to implement supply mechanisms].
144  *
145  * The default value of {decimals} is 18. To change this, you should override
146  * this function so it returns a different value.
147  *
148  * We have followed general OpenZeppelin Contracts guidelines: functions revert
149  * instead returning `false` on failure. This behavior is nonetheless
150  * conventional and does not conflict with the expectations of ERC20
151  * applications.
152  *
153  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
154  * This allows applications to reconstruct the allowance for all accounts just
155  * by listening to said events. Other implementations of the EIP may not emit
156  * these events, as it isn't required by the specification.
157  *
158  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
159  * functions have been added to mitigate the well-known issues around setting
160  * allowances. See {IERC20-approve}.
161  */
162 contract ERC20 is Context, IERC20, IERC20Metadata {
163     mapping(address => uint256) private _balances;
164 
165     mapping(address => mapping(address => uint256)) private _allowances;
166 
167     uint256 private _totalSupply;
168 
169     string private _name;
170     string private _symbol;
171 
172     /**
173      * @dev Sets the values for {name} and {symbol}.
174      *
175      * All two of these values are immutable: they can only be set once during
176      * construction.
177      */
178     constructor(string memory name_, string memory symbol_) {
179         _name = name_;
180         _symbol = symbol_;
181     }
182 
183     /**
184      * @dev Returns the name of the token.
185      */
186     function name() public view virtual override returns (string memory) {
187         return _name;
188     }
189 
190     /**
191      * @dev Returns the symbol of the token, usually a shorter version of the
192      * name.
193      */
194     function symbol() public view virtual override returns (string memory) {
195         return _symbol;
196     }
197 
198     /**
199      * @dev Returns the number of decimals used to get its user representation.
200      * For example, if `decimals` equals `2`, a balance of `505` tokens should
201      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
202      *
203      * Tokens usually opt for a value of 18, imitating the relationship between
204      * Ether and Wei. This is the default value returned by this function, unless
205      * it's overridden.
206      *
207      * NOTE: This information is only used for _display_ purposes: it in
208      * no way affects any of the arithmetic of the contract, including
209      * {IERC20-balanceOf} and {IERC20-transfer}.
210      */
211     function decimals() public view virtual override returns (uint8) {
212         return 18;
213     }
214 
215     /**
216      * @dev See {IERC20-totalSupply}.
217      */
218     function totalSupply() public view virtual override returns (uint256) {
219         return _totalSupply;
220     }
221 
222     /**
223      * @dev See {IERC20-balanceOf}.
224      */
225     function balanceOf(address account) public view virtual override returns (uint256) {
226         return _balances[account];
227     }
228 
229     /**
230      * @dev See {IERC20-transfer}.
231      *
232      * Requirements:
233      *
234      * - `to` cannot be the zero address.
235      * - the caller must have a balance of at least `amount`.
236      */
237     function transfer(address to, uint256 amount) public virtual override returns (bool) {
238         address owner = _msgSender();
239         _transfer(owner, to, amount);
240         return true;
241     }
242 
243     /**
244      * @dev See {IERC20-allowance}.
245      */
246     function allowance(address owner, address spender) public view virtual override returns (uint256) {
247         return _allowances[owner][spender];
248     }
249 
250     /**
251      * @dev See {IERC20-approve}.
252      *
253      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
254      * `transferFrom`. This is semantically equivalent to an infinite approval.
255      *
256      * Requirements:
257      *
258      * - `spender` cannot be the zero address.
259      */
260     function approve(address spender, uint256 amount) public virtual override returns (bool) {
261         address owner = _msgSender();
262         _approve(owner, spender, amount);
263         return true;
264     }
265 
266     /**
267      * @dev See {IERC20-transferFrom}.
268      *
269      * Emits an {Approval} event indicating the updated allowance. This is not
270      * required by the EIP. See the note at the beginning of {ERC20}.
271      *
272      * NOTE: Does not update the allowance if the current allowance
273      * is the maximum `uint256`.
274      *
275      * Requirements:
276      *
277      * - `from` and `to` cannot be the zero address.
278      * - `from` must have a balance of at least `amount`.
279      * - the caller must have allowance for ``from``'s tokens of at least
280      * `amount`.
281      */
282     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
283         address spender = _msgSender();
284         _spendAllowance(from, spender, amount);
285         _transfer(from, to, amount);
286         return true;
287     }
288 
289     /**
290      * @dev Atomically increases the allowance granted to `spender` by the caller.
291      *
292      * This is an alternative to {approve} that can be used as a mitigation for
293      * problems described in {IERC20-approve}.
294      *
295      * Emits an {Approval} event indicating the updated allowance.
296      *
297      * Requirements:
298      *
299      * - `spender` cannot be the zero address.
300      */
301     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
302         address owner = _msgSender();
303         _approve(owner, spender, allowance(owner, spender) + addedValue);
304         return true;
305     }
306 
307     /**
308      * @dev Atomically decreases the allowance granted to `spender` by the caller.
309      *
310      * This is an alternative to {approve} that can be used as a mitigation for
311      * problems described in {IERC20-approve}.
312      *
313      * Emits an {Approval} event indicating the updated allowance.
314      *
315      * Requirements:
316      *
317      * - `spender` cannot be the zero address.
318      * - `spender` must have allowance for the caller of at least
319      * `subtractedValue`.
320      */
321     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
322         address owner = _msgSender();
323         uint256 currentAllowance = allowance(owner, spender);
324         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
325         unchecked {
326             _approve(owner, spender, currentAllowance - subtractedValue);
327         }
328 
329         return true;
330     }
331 
332     /**
333      * @dev Moves `amount` of tokens from `from` to `to`.
334      *
335      * This internal function is equivalent to {transfer}, and can be used to
336      * e.g. implement automatic token fees, slashing mechanisms, etc.
337      *
338      * Emits a {Transfer} event.
339      *
340      * Requirements:
341      *
342      * - `from` cannot be the zero address.
343      * - `to` cannot be the zero address.
344      * - `from` must have a balance of at least `amount`.
345      */
346     function _transfer(address from, address to, uint256 amount) internal virtual {
347         require(from != address(0), "ERC20: transfer from the zero address");
348         require(to != address(0), "ERC20: transfer to the zero address");
349 
350         _beforeTokenTransfer(from, to, amount);
351 
352         uint256 fromBalance = _balances[from];
353         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
354         unchecked {
355             _balances[from] = fromBalance - amount;
356             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
357             // decrementing then incrementing.
358             _balances[to] += amount;
359         }
360 
361         emit Transfer(from, to, amount);
362 
363         _afterTokenTransfer(from, to, amount);
364     }
365 
366     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
367      * the total supply.
368      *
369      * Emits a {Transfer} event with `from` set to the zero address.
370      *
371      * Requirements:
372      *
373      * - `account` cannot be the zero address.
374      */
375     function _mint(address account, uint256 amount) internal virtual {
376         require(account != address(0), "ERC20: mint to the zero address");
377 
378         _beforeTokenTransfer(address(0), account, amount);
379 
380         _totalSupply += amount;
381         unchecked {
382             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
383             _balances[account] += amount;
384         }
385         emit Transfer(address(0), account, amount);
386 
387         _afterTokenTransfer(address(0), account, amount);
388     }
389 
390     /**
391      * @dev Destroys `amount` tokens from `account`, reducing the
392      * total supply.
393      *
394      * Emits a {Transfer} event with `to` set to the zero address.
395      *
396      * Requirements:
397      *
398      * - `account` cannot be the zero address.
399      * - `account` must have at least `amount` tokens.
400      */
401     function _burn(address account, uint256 amount) internal virtual {
402         require(account != address(0), "ERC20: burn from the zero address");
403 
404         _beforeTokenTransfer(account, address(0), amount);
405 
406         uint256 accountBalance = _balances[account];
407         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
408         unchecked {
409             _balances[account] = accountBalance - amount;
410             // Overflow not possible: amount <= accountBalance <= totalSupply.
411             _totalSupply -= amount;
412         }
413 
414         emit Transfer(account, address(0), amount);
415 
416         _afterTokenTransfer(account, address(0), amount);
417     }
418 
419     /**
420      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
421      *
422      * This internal function is equivalent to `approve`, and can be used to
423      * e.g. set automatic allowances for certain subsystems, etc.
424      *
425      * Emits an {Approval} event.
426      *
427      * Requirements:
428      *
429      * - `owner` cannot be the zero address.
430      * - `spender` cannot be the zero address.
431      */
432     function _approve(address owner, address spender, uint256 amount) internal virtual {
433         require(owner != address(0), "ERC20: approve from the zero address");
434         require(spender != address(0), "ERC20: approve to the zero address");
435 
436         _allowances[owner][spender] = amount;
437         emit Approval(owner, spender, amount);
438     }
439 
440     /**
441      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
442      *
443      * Does not update the allowance amount in case of infinite allowance.
444      * Revert if not enough allowance is available.
445      *
446      * Might emit an {Approval} event.
447      */
448     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
449         uint256 currentAllowance = allowance(owner, spender);
450         if (currentAllowance != type(uint256).max) {
451             require(currentAllowance >= amount, "ERC20: insufficient allowance");
452             unchecked {
453                 _approve(owner, spender, currentAllowance - amount);
454             }
455         }
456     }
457 
458     /**
459      * @dev Hook that is called before any transfer of tokens. This includes
460      * minting and burning.
461      *
462      * Calling conditions:
463      *
464      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
465      * will be transferred to `to`.
466      * - when `from` is zero, `amount` tokens will be minted for `to`.
467      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
468      * - `from` and `to` are never both zero.
469      *
470      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
471      */
472     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
473 
474     /**
475      * @dev Hook that is called after any transfer of tokens. This includes
476      * minting and burning.
477      *
478      * Calling conditions:
479      *
480      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
481      * has been transferred to `to`.
482      * - when `from` is zero, `amount` tokens have been minted for `to`.
483      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
484      * - `from` and `to` are never both zero.
485      *
486      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
487      */
488     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
489 }
490 
491 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
492 
493 pragma solidity ^0.8.18;
494 
495 /**
496  * @dev Contract module which provides a basic access control mechanism, where
497  * there is an account (an owner) that can be granted exclusive access to
498  * specific functions.
499  *
500  * By default, the owner account will be the one that deploys the contract. This
501  * can later be changed with {transferOwnership}.
502  *
503  * This module is used through inheritance. It will make available the modifier
504  * `onlyOwner`, which can be applied to your functions to restrict their use to
505  * the owner.
506  */
507 abstract contract Ownable is Context {
508     address private _owner;
509 
510     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
511 
512     /**
513      * @dev Initializes the contract setting the deployer as the initial owner.
514      */
515     constructor() {
516         _transferOwnership(_msgSender());
517     }
518 
519     /**
520      * @dev Throws if called by any account other than the owner.
521      */
522     modifier onlyOwner() {
523         _checkOwner();
524         _;
525     }
526 
527     /**
528      * @dev Returns the address of the current owner.
529      */
530     function owner() public view virtual returns (address) {
531         return _owner;
532     }
533 
534     /**
535      * @dev Throws if the sender is not the owner.
536      */
537     function _checkOwner() internal view virtual {
538         require(owner() == _msgSender(), "Ownable: caller is not the owner");
539     }
540 
541     /**
542      * @dev Leaves the contract without owner. It will not be possible to call
543      * `onlyOwner` functions. Can only be called by the current owner.
544      *
545      * NOTE: Renouncing ownership will leave the contract without an owner,
546      * thereby disabling any functionality that is only available to the owner.
547      */
548     function renounceOwnership() public virtual onlyOwner {
549         _transferOwnership(address(0));
550     }
551 
552     /**
553      * @dev Transfers ownership of the contract to a new account (`newOwner`).
554      * Can only be called by the current owner.
555      */
556     function transferOwnership(address newOwner) public virtual onlyOwner {
557         require(newOwner != address(0), "Ownable: new owner is the zero address");
558         _transferOwnership(newOwner);
559     }
560 
561     /**
562      * @dev Transfers ownership of the contract to a new account (`newOwner`).
563      * Internal function without access restriction.
564      */
565     function _transferOwnership(address newOwner) internal virtual {
566         address oldOwner = _owner;
567         _owner = newOwner;
568         emit OwnershipTransferred(oldOwner, newOwner);
569     }
570 }
571 
572 // file token
573 
574 pragma solidity 0.8.18;
575 
576 contract FOMOINU is ERC20, Ownable {
577     constructor() ERC20("Fomo Inu", "FINU") {
578         _mint(msg.sender, 10000000000 * 10 ** decimals());
579     }       
580 }