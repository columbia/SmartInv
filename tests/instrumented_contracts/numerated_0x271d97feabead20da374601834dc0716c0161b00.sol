1 /**
2 https://t.me/elchapoportal
3 https://twitter.com/ElChapoETH
4 https://www.elchapo.vip/
5 */
6 
7 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
8 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
9 // SPDX-License-Identifier: MIT
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
30 /**
31  * @dev Contract module which provides a basic access control mechanism, where
32  * there is an account (an owner) that can be granted exclusive access to
33  * specific functions.
34  *
35  * By default, the owner account will be the one that deploys the contract. This
36  * can later be changed with {transferOwnership}.
37  *
38  * This module is used through inheritance. It will make available the modifier
39  * `onlyOwner`, which can be applied to your functions to restrict their use to
40  * the owner.
41  */
42 abstract contract Ownable is Context {
43     address private _owner;
44 
45     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
46 
47     /**
48      * @dev Initializes the contract setting the deployer as the initial owner.
49      */
50     constructor() {
51         _transferOwnership(_msgSender());
52     }
53 
54     /**
55      * @dev Throws if called by any account other than the owner.
56      */
57     modifier onlyOwner() {
58         _checkOwner();
59         _;
60     }
61 
62     /**
63      * @dev Returns the address of the current owner.
64      */
65     function owner() public view virtual returns (address) {
66         return _owner;
67     }
68 
69     /**
70      * @dev Throws if the sender is not the owner.
71      */
72     function _checkOwner() internal view virtual {
73         require(owner() == _msgSender(), "Ownable: caller is not the owner");
74     }
75 
76     /**
77      * @dev Leaves the contract without owner. It will not be possible to call
78      * `onlyOwner` functions anymore. Can only be called by the current owner.
79      *
80      * NOTE: Renouncing ownership will leave the contract without an owner,
81      * thereby removing any functionality that is only available to the owner.
82      */
83     function renounceOwnership() public virtual onlyOwner {
84         _transferOwnership(address(0));
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public virtual onlyOwner {
92         require(newOwner != address(0), "Ownable: new owner is the zero address");
93         _transferOwnership(newOwner);
94     }
95 
96     /**
97      * @dev Transfers ownership of the contract to a new account (`newOwner`).
98      * Internal function without access restriction.
99      */
100     function _transferOwnership(address newOwner) internal virtual {
101         address oldOwner = _owner;
102         _owner = newOwner;
103         emit OwnershipTransferred(oldOwner, newOwner);
104     }
105 }
106 
107 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
108 
109 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
110 
111 /**
112  * @dev Interface of the ERC20 standard as defined in the EIP.
113  */
114 interface IERC20 {
115     /**
116      * @dev Emitted when `value` tokens are moved from one account (`from`) to
117      * another (`to`).
118      *
119      * Note that `value` may be zero.
120      */
121     event Transfer(address indexed from, address indexed to, uint256 value);
122 
123     /**
124      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
125      * a call to {approve}. `value` is the new allowance.
126      */
127     event Approval(address indexed owner, address indexed spender, uint256 value);
128 
129     /**
130      * @dev Returns the amount of tokens in existence.
131      */
132     function totalSupply() external view returns (uint256);
133 
134     /**
135      * @dev Returns the amount of tokens owned by `account`.
136      */
137     function balanceOf(address account) external view returns (uint256);
138 
139     /**
140      * @dev Moves `amount` tokens from the caller's account to `to`.
141      *
142      * Returns a boolean value indicating whether the operation succeeded.
143      *
144      * Emits a {Transfer} event.
145      */
146     function transfer(address to, uint256 amount) external returns (bool);
147 
148     /**
149      * @dev Returns the remaining number of tokens that `spender` will be
150      * allowed to spend on behalf of `owner` through {transferFrom}. This is
151      * zero by default.
152      *
153      * This value changes when {approve} or {transferFrom} are called.
154      */
155     function allowance(address owner, address spender) external view returns (uint256);
156 
157     /**
158      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
159      *
160      * Returns a boolean value indicating whether the operation succeeded.
161      *
162      * IMPORTANT: Beware that changing an allowance with this method brings the risk
163      * that someone may use both the old and the new allowance by unfortunate
164      * transaction ordering. One possible solution to mitigate this race
165      * condition is to first reduce the spender's allowance to 0 and set the
166      * desired value afterwards:
167      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
168      *
169      * Emits an {Approval} event.
170      */
171     function approve(address spender, uint256 amount) external returns (bool);
172 
173     /**
174      * @dev Moves `amount` tokens from `from` to `to` using the
175      * allowance mechanism. `amount` is then deducted from the caller's
176      * allowance.
177      *
178      * Returns a boolean value indicating whether the operation succeeded.
179      *
180      * Emits a {Transfer} event.
181      */
182     function transferFrom(
183         address from,
184         address to,
185         uint256 amount
186     ) external returns (bool);
187 }
188 
189 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
190 
191 /**
192  * @dev Interface for the optional metadata functions from the ERC20 standard.
193  *
194  * _Available since v4.1._
195  */
196 interface IERC20Metadata is IERC20 {
197     /**
198      * @dev Returns the name of the token.
199      */
200     function name() external view returns (string memory);
201 
202     /**
203      * @dev Returns the symbol of the token.
204      */
205     function symbol() external view returns (string memory);
206 
207     /**
208      * @dev Returns the decimals places of the token.
209      */
210     function decimals() external view returns (uint8);
211 }
212 
213 /**
214  * @dev Implementation of the {IERC20} interface.
215  *
216  * This implementation is agnostic to the way tokens are created. This means
217  * that a supply mechanism has to be added in a derived contract using {_mint}.
218  * For a generic mechanism see {ERC20PresetMinterPauser}.
219  *
220  * TIP: For a detailed writeup see our guide
221  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
222  * to implement supply mechanisms].
223  *
224  * We have followed general OpenZeppelin Contracts guidelines: functions revert
225  * instead returning `false` on failure. This behavior is nonetheless
226  * conventional and does not conflict with the expectations of ERC20
227  * applications.
228  *
229  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
230  * This allows applications to reconstruct the allowance for all accounts just
231  * by listening to said events. Other implementations of the EIP may not emit
232  * these events, as it isn't required by the specification.
233  *
234  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
235  * functions have been added to mitigate the well-known issues around setting
236  * allowances. See {IERC20-approve}.
237  */
238 contract ERC20 is Context, IERC20, IERC20Metadata {
239     mapping(address => uint256) private _balances;
240 
241     mapping(address => mapping(address => uint256)) private _allowances;
242 
243     uint256 private _totalSupply;
244 
245     string private _name;
246     string private _symbol;
247 
248     /**
249      * @dev Sets the values for {name} and {symbol}.
250      *
251      * The default value of {decimals} is 18. To select a different value for
252      * {decimals} you should overload it.
253      *
254      * All two of these values are immutable: they can only be set once during
255      * construction.
256      */
257     constructor(string memory name_, string memory symbol_) {
258         _name = name_;
259         _symbol = symbol_;
260     }
261 
262     /**
263      * @dev Returns the name of the token.
264      */
265     function name() public view virtual override returns (string memory) {
266         return _name;
267     }
268 
269     /**
270      * @dev Returns the symbol of the token, usually a shorter version of the
271      * name.
272      */
273     function symbol() public view virtual override returns (string memory) {
274         return _symbol;
275     }
276 
277     /**
278      * @dev Returns the number of decimals used to get its user representation.
279      * For example, if `decimals` equals `2`, a balance of `505` tokens should
280      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
281      *
282      * Tokens usually opt for a value of 18, imitating the relationship between
283      * Ether and Wei. This is the value {ERC20} uses, unless this function is
284      * overridden;
285      *
286      * NOTE: This information is only used for _display_ purposes: it in
287      * no way affects any of the arithmetic of the contract, including
288      * {IERC20-balanceOf} and {IERC20-transfer}.
289      */
290     function decimals() public view virtual override returns (uint8) {
291         return 18;
292     }
293 
294     /**
295      * @dev See {IERC20-totalSupply}.
296      */
297     function totalSupply() public view virtual override returns (uint256) {
298         return _totalSupply;
299     }
300 
301     /**
302      * @dev See {IERC20-balanceOf}.
303      */
304     function balanceOf(address account) public view virtual override returns (uint256) {
305         return _balances[account];
306     }
307 
308     /**
309      * @dev See {IERC20-transfer}.
310      *
311      * Requirements:
312      *
313      * - `to` cannot be the zero address.
314      * - the caller must have a balance of at least `amount`.
315      */
316     function transfer(address to, uint256 amount) public virtual override returns (bool) {
317         address owner = _msgSender();
318         _transfer(owner, to, amount);
319         return true;
320     }
321 
322     /**
323      * @dev See {IERC20-allowance}.
324      */
325     function allowance(address owner, address spender) public view virtual override returns (uint256) {
326         return _allowances[owner][spender];
327     }
328 
329     /**
330      * @dev See {IERC20-approve}.
331      *
332      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
333      * `transferFrom`. This is semantically equivalent to an infinite approval.
334      *
335      * Requirements:
336      *
337      * - `spender` cannot be the zero address.
338      */
339     function approve(address spender, uint256 amount) public virtual override returns (bool) {
340         address owner = _msgSender();
341         _approve(owner, spender, amount);
342         return true;
343     }
344 
345     /**
346      * @dev See {IERC20-transferFrom}.
347      *
348      * Emits an {Approval} event indicating the updated allowance. This is not
349      * required by the EIP. See the note at the beginning of {ERC20}.
350      *
351      * NOTE: Does not update the allowance if the current allowance
352      * is the maximum `uint256`.
353      *
354      * Requirements:
355      *
356      * - `from` and `to` cannot be the zero address.
357      * - `from` must have a balance of at least `amount`.
358      * - the caller must have allowance for ``from``'s tokens of at least
359      * `amount`.
360      */
361     function transferFrom(
362         address from,
363         address to,
364         uint256 amount
365     ) public virtual override returns (bool) {
366         address spender = _msgSender();
367         _spendAllowance(from, spender, amount);
368         _transfer(from, to, amount);
369         return true;
370     }
371 
372     /**
373      * @dev Atomically increases the allowance granted to `spender` by the caller.
374      *
375      * This is an alternative to {approve} that can be used as a mitigation for
376      * problems described in {IERC20-approve}.
377      *
378      * Emits an {Approval} event indicating the updated allowance.
379      *
380      * Requirements:
381      *
382      * - `spender` cannot be the zero address.
383      */
384     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
385         address owner = _msgSender();
386         _approve(owner, spender, allowance(owner, spender) + addedValue);
387         return true;
388     }
389 
390     /**
391      * @dev Atomically decreases the allowance granted to `spender` by the caller.
392      *
393      * This is an alternative to {approve} that can be used as a mitigation for
394      * problems described in {IERC20-approve}.
395      *
396      * Emits an {Approval} event indicating the updated allowance.
397      *
398      * Requirements:
399      *
400      * - `spender` cannot be the zero address.
401      * - `spender` must have allowance for the caller of at least
402      * `subtractedValue`.
403      */
404     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
405         address owner = _msgSender();
406         uint256 currentAllowance = allowance(owner, spender);
407         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
408         unchecked {
409             _approve(owner, spender, currentAllowance - subtractedValue);
410         }
411 
412         return true;
413     }
414 
415     /**
416      * @dev Moves `amount` of tokens from `from` to `to`.
417      *
418      * This internal function is equivalent to {transfer}, and can be used to
419      * e.g. implement automatic token fees, slashing mechanisms, etc.
420      *
421      * Emits a {Transfer} event.
422      *
423      * Requirements:
424      *
425      * - `from` cannot be the zero address.
426      * - `to` cannot be the zero address.
427      * - `from` must have a balance of at least `amount`.
428      */
429     function _transfer(
430         address from,
431         address to,
432         uint256 amount
433     ) internal virtual {
434         require(from != address(0), "ERC20: transfer from the zero address");
435         require(to != address(0), "ERC20: transfer to the zero address");
436 
437         _beforeTokenTransfer(from, to, amount);
438 
439         uint256 fromBalance = _balances[from];
440         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
441         unchecked {
442             _balances[from] = fromBalance - amount;
443             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
444             // decrementing then incrementing.
445             _balances[to] += amount;
446         }
447 
448         emit Transfer(from, to, amount);
449 
450         _afterTokenTransfer(from, to, amount);
451     }
452 
453     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
454      * the total supply.
455      *
456      * Emits a {Transfer} event with `from` set to the zero address.
457      *
458      * Requirements:
459      *
460      * - `account` cannot be the zero address.
461      */
462     function _mint(address account, uint256 amount) internal virtual {
463         require(account != address(0), "ERC20: mint to the zero address");
464 
465         _beforeTokenTransfer(address(0), account, amount);
466 
467         _totalSupply += amount;
468         unchecked {
469             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
470             _balances[account] += amount;
471         }
472         emit Transfer(address(0), account, amount);
473 
474         _afterTokenTransfer(address(0), account, amount);
475     }
476 
477     /**
478      * @dev Destroys `amount` tokens from `account`, reducing the
479      * total supply.
480      *
481      * Emits a {Transfer} event with `to` set to the zero address.
482      *
483      * Requirements:
484      *
485      * - `account` cannot be the zero address.
486      * - `account` must have at least `amount` tokens.
487      */
488     function _burn(address account, uint256 amount) internal virtual {
489         require(account != address(0), "ERC20: burn from the zero address");
490 
491         _beforeTokenTransfer(account, address(0), amount);
492 
493         uint256 accountBalance = _balances[account];
494         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
495         unchecked {
496             _balances[account] = accountBalance - amount;
497             // Overflow not possible: amount <= accountBalance <= totalSupply.
498             _totalSupply -= amount;
499         }
500 
501         emit Transfer(account, address(0), amount);
502 
503         _afterTokenTransfer(account, address(0), amount);
504     }
505 
506     /**
507      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
508      *
509      * This internal function is equivalent to `approve`, and can be used to
510      * e.g. set automatic allowances for certain subsystems, etc.
511      *
512      * Emits an {Approval} event.
513      *
514      * Requirements:
515      *
516      * - `owner` cannot be the zero address.
517      * - `spender` cannot be the zero address.
518      */
519     function _approve(
520         address owner,
521         address spender,
522         uint256 amount
523     ) internal virtual {
524         require(owner != address(0), "ERC20: approve from the zero address");
525         require(spender != address(0), "ERC20: approve to the zero address");
526 
527         _allowances[owner][spender] = amount;
528         emit Approval(owner, spender, amount);
529     }
530 
531     /**
532      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
533      *
534      * Does not update the allowance amount in case of infinite allowance.
535      * Revert if not enough allowance is available.
536      *
537      * Might emit an {Approval} event.
538      */
539     function _spendAllowance(
540         address owner,
541         address spender,
542         uint256 amount
543     ) internal virtual {
544         uint256 currentAllowance = allowance(owner, spender);
545         if (currentAllowance != type(uint256).max) {
546             require(currentAllowance >= amount, "ERC20: insufficient allowance");
547             unchecked {
548                 _approve(owner, spender, currentAllowance - amount);
549             }
550         }
551     }
552 
553     /**
554      * @dev Hook that is called before any transfer of tokens. This includes
555      * minting and burning.
556      *
557      * Calling conditions:
558      *
559      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
560      * will be transferred to `to`.
561      * - when `from` is zero, `amount` tokens will be minted for `to`.
562      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
563      * - `from` and `to` are never both zero.
564      *
565      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
566      */
567     function _beforeTokenTransfer(
568         address from,
569         address to,
570         uint256 amount
571     ) internal virtual {}
572 
573     /**
574      * @dev Hook that is called after any transfer of tokens. This includes
575      * minting and burning.
576      *
577      * Calling conditions:
578      *
579      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
580      * has been transferred to `to`.
581      * - when `from` is zero, `amount` tokens have been minted for `to`.
582      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
583      * - `from` and `to` are never both zero.
584      *
585      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
586      */
587     function _afterTokenTransfer(
588         address from,
589         address to,
590         uint256 amount
591     ) internal virtual {}
592 }
593 
594 pragma solidity ^0.8.0;
595 
596 contract JoaquinGuzman is Ownable, ERC20 {
597     constructor(uint256 _totalSupply) ERC20("Joaquin Guzman", "ELCHAPO") {
598         _mint(msg.sender, _totalSupply);
599     }
600 
601     function burn(uint256 value) external {
602         _burn(msg.sender, value);
603     }
604 
605     receive() external payable {
606         revert();
607     }
608 
609     fallback() external {
610         revert();
611     }
612 }