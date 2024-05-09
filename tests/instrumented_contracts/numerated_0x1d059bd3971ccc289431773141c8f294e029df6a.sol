1 /**
2 // https://t.me/pierretheparrot
3 // https://www.pierretheparrot.com/
4 */
5 
6 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
7 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
8 // SPDX-License-Identifier: MIT
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 /**
30  * @dev Contract module which provides a basic access control mechanism, where
31  * there is an account (an owner) that can be granted exclusive access to
32  * specific functions.
33  *
34  * By default, the owner account will be the one that deploys the contract. This
35  * can later be changed with {transferOwnership}.
36  *
37  * This module is used through inheritance. It will make available the modifier
38  * `onlyOwner`, which can be applied to your functions to restrict their use to
39  * the owner.
40  */
41 abstract contract Ownable is Context {
42     address private _owner;
43 
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     /**
47      * @dev Initializes the contract setting the deployer as the initial owner.
48      */
49     constructor() {
50         _transferOwnership(_msgSender());
51     }
52 
53     /**
54      * @dev Throws if called by any account other than the owner.
55      */
56     modifier onlyOwner() {
57         _checkOwner();
58         _;
59     }
60 
61     /**
62      * @dev Returns the address of the current owner.
63      */
64     function owner() public view virtual returns (address) {
65         return _owner;
66     }
67 
68     /**
69      * @dev Throws if the sender is not the owner.
70      */
71     function _checkOwner() internal view virtual {
72         require(owner() == _msgSender(), "Ownable: caller is not the owner");
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         _transferOwnership(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _transferOwnership(newOwner);
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Internal function without access restriction.
98      */
99     function _transferOwnership(address newOwner) internal virtual {
100         address oldOwner = _owner;
101         _owner = newOwner;
102         emit OwnershipTransferred(oldOwner, newOwner);
103     }
104 }
105 
106 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
107 
108 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
109 
110 /**
111  * @dev Interface of the ERC20 standard as defined in the EIP.
112  */
113 interface IERC20 {
114     /**
115      * @dev Emitted when `value` tokens are moved from one account (`from`) to
116      * another (`to`).
117      *
118      * Note that `value` may be zero.
119      */
120     event Transfer(address indexed from, address indexed to, uint256 value);
121 
122     /**
123      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
124      * a call to {approve}. `value` is the new allowance.
125      */
126     event Approval(address indexed owner, address indexed spender, uint256 value);
127 
128     /**
129      * @dev Returns the amount of tokens in existence.
130      */
131     function totalSupply() external view returns (uint256);
132 
133     /**
134      * @dev Returns the amount of tokens owned by `account`.
135      */
136     function balanceOf(address account) external view returns (uint256);
137 
138     /**
139      * @dev Moves `amount` tokens from the caller's account to `to`.
140      *
141      * Returns a boolean value indicating whether the operation succeeded.
142      *
143      * Emits a {Transfer} event.
144      */
145     function transfer(address to, uint256 amount) external returns (bool);
146 
147     /**
148      * @dev Returns the remaining number of tokens that `spender` will be
149      * allowed to spend on behalf of `owner` through {transferFrom}. This is
150      * zero by default.
151      *
152      * This value changes when {approve} or {transferFrom} are called.
153      */
154     function allowance(address owner, address spender) external view returns (uint256);
155 
156     /**
157      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
158      *
159      * Returns a boolean value indicating whether the operation succeeded.
160      *
161      * IMPORTANT: Beware that changing an allowance with this method brings the risk
162      * that someone may use both the old and the new allowance by unfortunate
163      * transaction ordering. One possible solution to mitigate this race
164      * condition is to first reduce the spender's allowance to 0 and set the
165      * desired value afterwards:
166      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
167      *
168      * Emits an {Approval} event.
169      */
170     function approve(address spender, uint256 amount) external returns (bool);
171 
172     /**
173      * @dev Moves `amount` tokens from `from` to `to` using the
174      * allowance mechanism. `amount` is then deducted from the caller's
175      * allowance.
176      *
177      * Returns a boolean value indicating whether the operation succeeded.
178      *
179      * Emits a {Transfer} event.
180      */
181     function transferFrom(
182         address from,
183         address to,
184         uint256 amount
185     ) external returns (bool);
186 }
187 
188 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
189 
190 /**
191  * @dev Interface for the optional metadata functions from the ERC20 standard.
192  *
193  * _Available since v4.1._
194  */
195 interface IERC20Metadata is IERC20 {
196     /**
197      * @dev Returns the name of the token.
198      */
199     function name() external view returns (string memory);
200 
201     /**
202      * @dev Returns the symbol of the token.
203      */
204     function symbol() external view returns (string memory);
205 
206     /**
207      * @dev Returns the decimals places of the token.
208      */
209     function decimals() external view returns (uint8);
210 }
211 
212 /**
213  * @dev Implementation of the {IERC20} interface.
214  *
215  * This implementation is agnostic to the way tokens are created. This means
216  * that a supply mechanism has to be added in a derived contract using {_mint}.
217  * For a generic mechanism see {ERC20PresetMinterPauser}.
218  *
219  * TIP: For a detailed writeup see our guide
220  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
221  * to implement supply mechanisms].
222  *
223  * We have followed general OpenZeppelin Contracts guidelines: functions revert
224  * instead returning `false` on failure. This behavior is nonetheless
225  * conventional and does not conflict with the expectations of ERC20
226  * applications.
227  *
228  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
229  * This allows applications to reconstruct the allowance for all accounts just
230  * by listening to said events. Other implementations of the EIP may not emit
231  * these events, as it isn't required by the specification.
232  *
233  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
234  * functions have been added to mitigate the well-known issues around setting
235  * allowances. See {IERC20-approve}.
236  */
237 contract ERC20 is Context, IERC20, IERC20Metadata {
238     mapping(address => uint256) private _balances;
239 
240     mapping(address => mapping(address => uint256)) private _allowances;
241 
242     uint256 private _totalSupply;
243 
244     string private _name;
245     string private _symbol;
246 
247     /**
248      * @dev Sets the values for {name} and {symbol}.
249      *
250      * The default value of {decimals} is 18. To select a different value for
251      * {decimals} you should overload it.
252      *
253      * All two of these values are immutable: they can only be set once during
254      * construction.
255      */
256     constructor(string memory name_, string memory symbol_) {
257         _name = name_;
258         _symbol = symbol_;
259     }
260 
261     /**
262      * @dev Returns the name of the token.
263      */
264     function name() public view virtual override returns (string memory) {
265         return _name;
266     }
267 
268     /**
269      * @dev Returns the symbol of the token, usually a shorter version of the
270      * name.
271      */
272     function symbol() public view virtual override returns (string memory) {
273         return _symbol;
274     }
275 
276     /**
277      * @dev Returns the number of decimals used to get its user representation.
278      * For example, if `decimals` equals `2`, a balance of `505` tokens should
279      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
280      *
281      * Tokens usually opt for a value of 18, imitating the relationship between
282      * Ether and Wei. This is the value {ERC20} uses, unless this function is
283      * overridden;
284      *
285      * NOTE: This information is only used for _display_ purposes: it in
286      * no way affects any of the arithmetic of the contract, including
287      * {IERC20-balanceOf} and {IERC20-transfer}.
288      */
289     function decimals() public view virtual override returns (uint8) {
290         return 18;
291     }
292 
293     /**
294      * @dev See {IERC20-totalSupply}.
295      */
296     function totalSupply() public view virtual override returns (uint256) {
297         return _totalSupply;
298     }
299 
300     /**
301      * @dev See {IERC20-balanceOf}.
302      */
303     function balanceOf(address account) public view virtual override returns (uint256) {
304         return _balances[account];
305     }
306 
307     /**
308      * @dev See {IERC20-transfer}.
309      *
310      * Requirements:
311      *
312      * - `to` cannot be the zero address.
313      * - the caller must have a balance of at least `amount`.
314      */
315     function transfer(address to, uint256 amount) public virtual override returns (bool) {
316         address owner = _msgSender();
317         _transfer(owner, to, amount);
318         return true;
319     }
320 
321     /**
322      * @dev See {IERC20-allowance}.
323      */
324     function allowance(address owner, address spender) public view virtual override returns (uint256) {
325         return _allowances[owner][spender];
326     }
327 
328     /**
329      * @dev See {IERC20-approve}.
330      *
331      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
332      * `transferFrom`. This is semantically equivalent to an infinite approval.
333      *
334      * Requirements:
335      *
336      * - `spender` cannot be the zero address.
337      */
338     function approve(address spender, uint256 amount) public virtual override returns (bool) {
339         address owner = _msgSender();
340         _approve(owner, spender, amount);
341         return true;
342     }
343 
344     /**
345      * @dev See {IERC20-transferFrom}.
346      *
347      * Emits an {Approval} event indicating the updated allowance. This is not
348      * required by the EIP. See the note at the beginning of {ERC20}.
349      *
350      * NOTE: Does not update the allowance if the current allowance
351      * is the maximum `uint256`.
352      *
353      * Requirements:
354      *
355      * - `from` and `to` cannot be the zero address.
356      * - `from` must have a balance of at least `amount`.
357      * - the caller must have allowance for ``from``'s tokens of at least
358      * `amount`.
359      */
360     function transferFrom(
361         address from,
362         address to,
363         uint256 amount
364     ) public virtual override returns (bool) {
365         address spender = _msgSender();
366         _spendAllowance(from, spender, amount);
367         _transfer(from, to, amount);
368         return true;
369     }
370 
371     /**
372      * @dev Atomically increases the allowance granted to `spender` by the caller.
373      *
374      * This is an alternative to {approve} that can be used as a mitigation for
375      * problems described in {IERC20-approve}.
376      *
377      * Emits an {Approval} event indicating the updated allowance.
378      *
379      * Requirements:
380      *
381      * - `spender` cannot be the zero address.
382      */
383     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
384         address owner = _msgSender();
385         _approve(owner, spender, allowance(owner, spender) + addedValue);
386         return true;
387     }
388 
389     /**
390      * @dev Atomically decreases the allowance granted to `spender` by the caller.
391      *
392      * This is an alternative to {approve} that can be used as a mitigation for
393      * problems described in {IERC20-approve}.
394      *
395      * Emits an {Approval} event indicating the updated allowance.
396      *
397      * Requirements:
398      *
399      * - `spender` cannot be the zero address.
400      * - `spender` must have allowance for the caller of at least
401      * `subtractedValue`.
402      */
403     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
404         address owner = _msgSender();
405         uint256 currentAllowance = allowance(owner, spender);
406         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
407         unchecked {
408             _approve(owner, spender, currentAllowance - subtractedValue);
409         }
410 
411         return true;
412     }
413 
414     /**
415      * @dev Moves `amount` of tokens from `from` to `to`.
416      *
417      * This internal function is equivalent to {transfer}, and can be used to
418      * e.g. implement automatic token fees, slashing mechanisms, etc.
419      *
420      * Emits a {Transfer} event.
421      *
422      * Requirements:
423      *
424      * - `from` cannot be the zero address.
425      * - `to` cannot be the zero address.
426      * - `from` must have a balance of at least `amount`.
427      */
428     function _transfer(
429         address from,
430         address to,
431         uint256 amount
432     ) internal virtual {
433         require(from != address(0), "ERC20: transfer from the zero address");
434         require(to != address(0), "ERC20: transfer to the zero address");
435 
436         _beforeTokenTransfer(from, to, amount);
437 
438         uint256 fromBalance = _balances[from];
439         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
440         unchecked {
441             _balances[from] = fromBalance - amount;
442             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
443             // decrementing then incrementing.
444             _balances[to] += amount;
445         }
446 
447         emit Transfer(from, to, amount);
448 
449         _afterTokenTransfer(from, to, amount);
450     }
451 
452     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
453      * the total supply.
454      *
455      * Emits a {Transfer} event with `from` set to the zero address.
456      *
457      * Requirements:
458      *
459      * - `account` cannot be the zero address.
460      */
461     function _mint(address account, uint256 amount) internal virtual {
462         require(account != address(0), "ERC20: mint to the zero address");
463 
464         _beforeTokenTransfer(address(0), account, amount);
465 
466         _totalSupply += amount;
467         unchecked {
468             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
469             _balances[account] += amount;
470         }
471         emit Transfer(address(0), account, amount);
472 
473         _afterTokenTransfer(address(0), account, amount);
474     }
475 
476     /**
477      * @dev Destroys `amount` tokens from `account`, reducing the
478      * total supply.
479      *
480      * Emits a {Transfer} event with `to` set to the zero address.
481      *
482      * Requirements:
483      *
484      * - `account` cannot be the zero address.
485      * - `account` must have at least `amount` tokens.
486      */
487     function _burn(address account, uint256 amount) internal virtual {
488         require(account != address(0), "ERC20: burn from the zero address");
489 
490         _beforeTokenTransfer(account, address(0), amount);
491 
492         uint256 accountBalance = _balances[account];
493         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
494         unchecked {
495             _balances[account] = accountBalance - amount;
496             // Overflow not possible: amount <= accountBalance <= totalSupply.
497             _totalSupply -= amount;
498         }
499 
500         emit Transfer(account, address(0), amount);
501 
502         _afterTokenTransfer(account, address(0), amount);
503     }
504 
505     /**
506      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
507      *
508      * This internal function is equivalent to `approve`, and can be used to
509      * e.g. set automatic allowances for certain subsystems, etc.
510      *
511      * Emits an {Approval} event.
512      *
513      * Requirements:
514      *
515      * - `owner` cannot be the zero address.
516      * - `spender` cannot be the zero address.
517      */
518     function _approve(
519         address owner,
520         address spender,
521         uint256 amount
522     ) internal virtual {
523         require(owner != address(0), "ERC20: approve from the zero address");
524         require(spender != address(0), "ERC20: approve to the zero address");
525 
526         _allowances[owner][spender] = amount;
527         emit Approval(owner, spender, amount);
528     }
529 
530     /**
531      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
532      *
533      * Does not update the allowance amount in case of infinite allowance.
534      * Revert if not enough allowance is available.
535      *
536      * Might emit an {Approval} event.
537      */
538     function _spendAllowance(
539         address owner,
540         address spender,
541         uint256 amount
542     ) internal virtual {
543         uint256 currentAllowance = allowance(owner, spender);
544         if (currentAllowance != type(uint256).max) {
545             require(currentAllowance >= amount, "ERC20: insufficient allowance");
546             unchecked {
547                 _approve(owner, spender, currentAllowance - amount);
548             }
549         }
550     }
551 
552     /**
553      * @dev Hook that is called before any transfer of tokens. This includes
554      * minting and burning.
555      *
556      * Calling conditions:
557      *
558      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
559      * will be transferred to `to`.
560      * - when `from` is zero, `amount` tokens will be minted for `to`.
561      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
562      * - `from` and `to` are never both zero.
563      *
564      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
565      */
566     function _beforeTokenTransfer(
567         address from,
568         address to,
569         uint256 amount
570     ) internal virtual {}
571 
572     /**
573      * @dev Hook that is called after any transfer of tokens. This includes
574      * minting and burning.
575      *
576      * Calling conditions:
577      *
578      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
579      * has been transferred to `to`.
580      * - when `from` is zero, `amount` tokens have been minted for `to`.
581      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
582      * - `from` and `to` are never both zero.
583      *
584      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
585      */
586     function _afterTokenTransfer(
587         address from,
588         address to,
589         uint256 amount
590     ) internal virtual {}
591 }
592 
593 pragma solidity ^0.8.0;
594 
595 contract PierreTheParrot is Ownable, ERC20 {
596     constructor(uint256 _totalSupply) ERC20("Pierre The Parrot", "Pierre") {
597         _mint(msg.sender, _totalSupply);
598     }
599 
600     function burn(uint256 value) external {
601         _burn(msg.sender, value);
602     }
603 
604     receive() external payable {
605         revert();
606     }
607 
608     fallback() external {
609         revert();
610     }
611 }