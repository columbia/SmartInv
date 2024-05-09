1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         return msg.data;
21     }
22 }
23 
24 /**
25  * @dev Interface of the ERC20 standard as defined in the EIP.
26  */
27 interface IERC20 {
28     /**
29      * @dev Emitted when `value` tokens are moved from one account (`from`) to
30      * another (`to`).
31      *
32      * Note that `value` may be zero.
33      */
34     event Transfer(address indexed from, address indexed to, uint256 value);
35 
36     /**
37      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
38      * a call to {approve}. `value` is the new allowance.
39      */
40     event Approval(address indexed owner, address indexed spender, uint256 value);
41     
42     /**
43      * @dev Returns the name of the token.
44      */
45     function name() external view returns (string memory);
46 
47     /**
48      * @dev Returns the symbol of the token.
49      */
50     function symbol() external view returns (string memory);
51 
52     /**
53      * @dev Returns the decimals places of the token.
54      */
55     function decimals() external view returns (uint8);
56     /**
57      * @dev Returns the amount of tokens in existence.
58      */
59     function totalSupply() external view returns (uint256);
60 
61     /**
62      * @dev Returns the amount of tokens owned by `account`.
63      */
64     function balanceOf(address account) external view returns (uint256);
65 
66     /**
67      * @dev Moves `amount` tokens from the caller's account to `to`.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * Emits a {Transfer} event.
72      */
73     function transfer(address to, uint256 amount) external returns (bool);
74 
75     /**
76      * @dev Returns the remaining number of tokens that `spender` will be
77      * allowed to spend on behalf of `owner` through {transferFrom}. This is
78      * zero by default.
79      *
80      * This value changes when {approve} or {transferFrom} are called.
81      */
82     function allowance(address owner, address spender) external view returns (uint256);
83 
84     /**
85      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
86      *
87      * Returns a boolean value indicating whether the operation succeeded.
88      *
89      * IMPORTANT: Beware that changing an allowance with this method brings the risk
90      * that someone may use both the old and the new allowance by unfortunate
91      * transaction ordering. One possible solution to mitigate this race
92      * condition is to first reduce the spender's allowance to 0 and set the
93      * desired value afterwards:
94      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
95      *
96      * Emits an {Approval} event.
97      */
98     function approve(address spender, uint256 amount) external returns (bool);
99 
100     /**
101      * @dev Moves `amount` tokens from `from` to `to` using the
102      * allowance mechanism. `amount` is then deducted from the caller's
103      * allowance.
104      *
105      * Returns a boolean value indicating whether the operation succeeded.
106      *
107      * Emits a {Transfer} event.
108      */
109     function transferFrom(
110         address from,
111         address to,
112         uint256 amount
113     ) external returns (bool);
114 }
115 
116 /**
117  * @dev Implementation of the {IERC20} interface.
118  *
119  * This implementation is agnostic to the way tokens are created. This means
120  * that a supply mechanism has to be added in a derived contract using {_mint}.
121  * For a generic mechanism see {ERC20PresetMinterPauser}.
122  *
123  * TIP: For a detailed writeup see our guide
124  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
125  * to implement supply mechanisms].
126  *
127  * We have followed general OpenZeppelin Contracts guidelines: functions revert
128  * instead returning `false` on failure. This behavior is nonetheless
129  * conventional and does not conflict with the expectations of ERC20
130  * applications.
131  *
132  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
133  * This allows applications to reconstruct the allowance for all accounts just
134  * by listening to said events. Other implementations of the EIP may not emit
135  * these events, as it isn't required by the specification.
136  *
137  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
138  * functions have been added to mitigate the well-known issues around setting
139  * allowances. See {IERC20-approve}.
140  */
141 contract ERC20 is Context, IERC20 {
142     mapping(address => uint256) private _balances;
143 
144     mapping(address => mapping(address => uint256)) private _allowances;
145 
146     uint256 private _totalSupply;
147 
148     string private _name;
149     string private _symbol;
150 
151     /**
152      * @dev Sets the values for {name} and {symbol}.
153      *
154      * The default value of {decimals} is 18. To select a different value for
155      * {decimals} you should overload it.
156      *
157      * All two of these values are immutable: they can only be set once during
158      * construction.
159      */
160     constructor(string memory name_, string memory symbol_) {
161         _name = name_;
162         _symbol = symbol_;
163     }
164 
165     /**
166      * @dev Returns the name of the token.
167      */
168     function name() public view virtual override returns (string memory) {
169         return _name;
170     }
171 
172     /**
173      * @dev Returns the symbol of the token, usually a shorter version of the
174      * name.
175      */
176     function symbol() public view virtual override returns (string memory) {
177         return _symbol;
178     }
179 
180     /**
181      * @dev Returns the number of decimals used to get its user representation.
182      * For example, if `decimals` equals `2`, a balance of `505` tokens should
183      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
184      *
185      * Tokens usually opt for a value of 18, imitating the relationship between
186      * Ether and Wei. This is the value {ERC20} uses, unless this function is
187      * overridden;
188      *
189      * NOTE: This information is only used for _display_ purposes: it in
190      * no way affects any of the arithmetic of the contract, including
191      * {IERC20-balanceOf} and {IERC20-transfer}.
192      */
193     function decimals() public view virtual override returns (uint8) {
194         return 18;
195     }
196 
197     /**
198      * @dev See {IERC20-totalSupply}.
199      */
200     function totalSupply() public view virtual override returns (uint256) {
201         return _totalSupply;
202     }
203 
204     /**
205      * @dev See {IERC20-balanceOf}.
206      */
207     function balanceOf(address account) public view virtual override returns (uint256) {
208         return _balances[account];
209     }
210 
211     /**
212      * @dev See {IERC20-transfer}.
213      *
214      * Requirements:
215      *
216      * - `to` cannot be the zero address.
217      * - the caller must have a balance of at least `amount`.
218      */
219     function transfer(address to, uint256 amount) public virtual override returns (bool) {
220         address owner = _msgSender();
221         _transfer(owner, to, amount);
222         return true;
223     }
224 
225     /**
226      * @dev See {IERC20-allowance}.
227      */
228     function allowance(address owner, address spender) public view virtual override returns (uint256) {
229         return _allowances[owner][spender];
230     }
231 
232     /**
233      * @dev See {IERC20-approve}.
234      *
235      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
236      * `transferFrom`. This is semantically equivalent to an infinite approval.
237      *
238      * Requirements:
239      *
240      * - `spender` cannot be the zero address.
241      */
242     function approve(address spender, uint256 amount) public virtual override returns (bool) {
243         address owner = _msgSender();
244         _approve(owner, spender, amount);
245         return true;
246     }
247 
248     /**
249      * @dev See {IERC20-transferFrom}.
250      *
251      * Emits an {Approval} event indicating the updated allowance. This is not
252      * required by the EIP. See the note at the beginning of {ERC20}.
253      *
254      * NOTE: Does not update the allowance if the current allowance
255      * is the maximum `uint256`.
256      *
257      * Requirements:
258      *
259      * - `from` and `to` cannot be the zero address.
260      * - `from` must have a balance of at least `amount`.
261      * - the caller must have allowance for ``from``'s tokens of at least
262      * `amount`.
263      */
264     function transferFrom(
265         address from,
266         address to,
267         uint256 amount
268     ) public virtual override returns (bool) {
269         address spender = _msgSender();
270         _spendAllowance(from, spender, amount);
271         _transfer(from, to, amount);
272         return true;
273     }
274 
275     /**
276      * @dev Atomically increases the allowance granted to `spender` by the caller.
277      *
278      * This is an alternative to {approve} that can be used as a mitigation for
279      * problems described in {IERC20-approve}.
280      *
281      * Emits an {Approval} event indicating the updated allowance.
282      *
283      * Requirements:
284      *
285      * - `spender` cannot be the zero address.
286      */
287     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
288         address owner = _msgSender();
289         _approve(owner, spender, allowance(owner, spender) + addedValue);
290         return true;
291     }
292 
293     /**
294      * @dev Atomically decreases the allowance granted to `spender` by the caller.
295      *
296      * This is an alternative to {approve} that can be used as a mitigation for
297      * problems described in {IERC20-approve}.
298      *
299      * Emits an {Approval} event indicating the updated allowance.
300      *
301      * Requirements:
302      *
303      * - `spender` cannot be the zero address.
304      * - `spender` must have allowance for the caller of at least
305      * `subtractedValue`.
306      */
307     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
308         address owner = _msgSender();
309         uint256 currentAllowance = allowance(owner, spender);
310         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
311         unchecked {
312             _approve(owner, spender, currentAllowance - subtractedValue);
313         }
314 
315         return true;
316     }
317 
318     /**
319      * @dev Moves `amount` of tokens from `from` to `to`.
320      *
321      * This internal function is equivalent to {transfer}, and can be used to
322      * e.g. implement automatic token fees, slashing mechanisms, etc.
323      *
324      * Emits a {Transfer} event.
325      *
326      * Requirements:
327      *
328      * - `from` cannot be the zero address.
329      * - `to` cannot be the zero address.
330      * - `from` must have a balance of at least `amount`.
331      */
332     function _transfer(
333         address from,
334         address to,
335         uint256 amount
336     ) internal virtual {
337         require(from != address(0), "ERC20: transfer from the zero address");
338         require(to != address(0), "ERC20: transfer to the zero address");
339 
340         _beforeTokenTransfer(from, to, amount);
341 
342         uint256 fromBalance = _balances[from];
343         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
344         unchecked {
345             _balances[from] = fromBalance - amount;
346         }
347         _balances[to] += amount;
348 
349         emit Transfer(from, to, amount);
350 
351         _afterTokenTransfer(from, to, amount);
352     }
353 
354     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
355      * the total supply.
356      *
357      * Emits a {Transfer} event with `from` set to the zero address.
358      *
359      * Requirements:
360      *
361      * - `account` cannot be the zero address.
362      */
363     function _mint(address account, uint256 amount) internal virtual {
364         require(account != address(0), "ERC20: mint to the zero address");
365 
366         _beforeTokenTransfer(address(0), account, amount);
367 
368         _totalSupply += amount;
369         _balances[account] += amount;
370         emit Transfer(address(0), account, amount);
371 
372         _afterTokenTransfer(address(0), account, amount);
373     }
374 
375     /**
376      * @dev Destroys `amount` tokens from `account`, reducing the
377      * total supply.
378      *
379      * Emits a {Transfer} event with `to` set to the zero address.
380      *
381      * Requirements:
382      *
383      * - `account` cannot be the zero address.
384      * - `account` must have at least `amount` tokens.
385      */
386     function _burn(address account, uint256 amount) internal virtual {
387         require(account != address(0), "ERC20: burn from the zero address");
388 
389         _beforeTokenTransfer(account, address(0), amount);
390 
391         uint256 accountBalance = _balances[account];
392         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
393         unchecked {
394             _balances[account] = accountBalance - amount;
395         }
396         _totalSupply -= amount;
397 
398         emit Transfer(account, address(0), amount);
399 
400         _afterTokenTransfer(account, address(0), amount);
401     }
402 
403     /**
404      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
405      *
406      * This internal function is equivalent to `approve`, and can be used to
407      * e.g. set automatic allowances for certain subsystems, etc.
408      *
409      * Emits an {Approval} event.
410      *
411      * Requirements:
412      *
413      * - `owner` cannot be the zero address.
414      * - `spender` cannot be the zero address.
415      */
416     function _approve(
417         address owner,
418         address spender,
419         uint256 amount
420     ) internal virtual {
421         require(owner != address(0), "ERC20: approve from the zero address");
422         require(spender != address(0), "ERC20: approve to the zero address");
423 
424         _allowances[owner][spender] = amount;
425         emit Approval(owner, spender, amount);
426     }
427 
428     /**
429      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
430      *
431      * Does not update the allowance amount in case of infinite allowance.
432      * Revert if not enough allowance is available.
433      *
434      * Might emit an {Approval} event.
435      */
436     function _spendAllowance(
437         address owner,
438         address spender,
439         uint256 amount
440     ) internal virtual {
441         uint256 currentAllowance = allowance(owner, spender);
442         if (currentAllowance != type(uint256).max) {
443             require(currentAllowance >= amount, "ERC20: insufficient allowance");
444             unchecked {
445                 _approve(owner, spender, currentAllowance - amount);
446             }
447         }
448     }
449 
450     /**
451      * @dev Hook that is called before any transfer of tokens. This includes
452      * minting and burning.
453      *
454      * Calling conditions:
455      *
456      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
457      * will be transferred to `to`.
458      * - when `from` is zero, `amount` tokens will be minted for `to`.
459      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
460      * - `from` and `to` are never both zero.
461      *
462      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
463      */
464     function _beforeTokenTransfer(
465         address from,
466         address to,
467         uint256 amount
468     ) internal virtual {}
469 
470     /**
471      * @dev Hook that is called after any transfer of tokens. This includes
472      * minting and burning.
473      *
474      * Calling conditions:
475      *
476      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
477      * has been transferred to `to`.
478      * - when `from` is zero, `amount` tokens have been minted for `to`.
479      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
480      * - `from` and `to` are never both zero.
481      *
482      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
483      */
484     function _afterTokenTransfer(
485         address from,
486         address to,
487         uint256 amount
488     ) internal virtual {}
489 }
490 
491 /**
492  * @dev Contract module which provides a basic access control mechanism, where
493  * there is an account (an owner) that can be granted exclusive access to
494  * specific functions.
495  *
496  * By default, the owner account will be the one that deploys the contract. This
497  * can later be changed with {transferOwnership}.
498  *
499  * This module is used through inheritance. It will make available the modifier
500  * `onlyOwner`, which can be applied to your functions to restrict their use to
501  * the owner.
502  */
503 abstract contract Ownable is Context {
504     address private _owner;
505 
506     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
507 
508     /**
509      * @dev Initializes the contract setting the deployer as the initial owner.
510      */
511     constructor() {
512         _transferOwnership(_msgSender());
513     }
514 
515     /**
516      * @dev Throws if called by any account other than the owner.
517      */
518     modifier onlyOwner() {
519         _checkOwner();
520         _;
521     }
522 
523     /**
524      * @dev Returns the address of the current owner.
525      */
526     function owner() public view virtual returns (address) {
527         return _owner;
528     }
529 
530     /**
531      * @dev Throws if the sender is not the owner.
532      */
533     function _checkOwner() internal view virtual {
534         require(owner() == _msgSender(), "Ownable: caller is not the owner");
535     }
536 
537     /**
538      * @dev Leaves the contract without owner. It will not be possible to call
539      * `onlyOwner` functions anymore. Can only be called by the current owner.
540      *
541      * NOTE: Renouncing ownership will leave the contract without an owner,
542      * thereby removing any functionality that is only available to the owner.
543      */
544     function renounceOwnership() public virtual onlyOwner {
545         _transferOwnership(address(0));
546     }
547 
548     /**
549      * @dev Transfers ownership of the contract to a new account (`newOwner`).
550      * Can only be called by the current owner.
551      */
552     function transferOwnership(address newOwner) public virtual onlyOwner {
553         require(newOwner != address(0), "Ownable: new owner is the zero address");
554         _transferOwnership(newOwner);
555     }
556 
557     /**
558      * @dev Transfers ownership of the contract to a new account (`newOwner`).
559      * Internal function without access restriction.
560      */
561     function _transferOwnership(address newOwner) internal virtual {
562         address oldOwner = _owner;
563         _owner = newOwner;
564         emit OwnershipTransferred(oldOwner, newOwner);
565     }
566 }
567 
568 contract HumanscapeToken is ERC20, Ownable {
569     // set upper limit as constant to prevent arbitrary minting
570     uint256 public constant UPPER_LIMIT = 108473427338 * (10**16);
571     // Humanscape minted at creation
572     constructor(uint256 initialSupply) ERC20("Humanscape", "HUM") {
573         _mint(msg.sender, initialSupply);
574     }
575     // ERC20 is mintable
576     function mint(address to, uint256 amount) public onlyOwner {
577         _mint(to, amount);
578     }
579     // ERC20 is burnable
580     function burn(uint256 amount) public {
581         _burn(msg.sender, amount);
582     }
583     function burnFrom(address account, uint256 amount) public {
584         _spendAllowance(account, msg.sender, amount);
585         _burn(account, amount);
586     }
587     // ERC20 is capped
588     function _mint(address account, uint256 amount) internal override {
589         require(ERC20.totalSupply() + amount <= UPPER_LIMIT, "ERC20Capped: cap exceeded");
590         super._mint(account, amount);
591     }
592 }