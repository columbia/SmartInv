1 //SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(
63         address sender,
64         address recipient,
65         uint256 amount
66     ) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.3.2
84 
85 /**
86  * @dev Interface for the optional metadata functions from the ERC20 standard.
87  *
88  * _Available since v4.1._
89  */
90 
91 interface IERC20Metadata is IERC20 {
92     /**
93      * @dev Returns the name of the token.
94      */
95     function name() external view returns (string memory);
96 
97     /**
98      * @dev Returns the symbol of the token.
99      */
100     function symbol() external view returns (string memory);
101 
102     /**
103      * @dev Returns the decimals places of the token.
104      */
105     function decimals() external view returns (uint8);
106 }
107 
108 // File @openzeppelin/contracts/utils/Context.sol@v4.3.2
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
130 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.3.2
131 
132 /**
133  * @dev Implementation of the {IERC20} interface.
134  *
135  * This implementation is agnostic to the way tokens are created. This means
136  * that a supply mechanism has to be added in a derived contract using {_mint}.
137  * For a generic mechanism see {ERC20PresetMinterPauser}.
138  *
139  * TIP: For a detailed writeup see our guide
140  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
141  * to implement supply mechanisms].
142  *
143  * We have followed general OpenZeppelin Contracts guidelines: functions revert
144  * instead returning `false` on failure. This behavior is nonetheless
145  * conventional and does not conflict with the expectations of ERC20
146  * applications.
147  *
148  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
149  * This allows applications to reconstruct the allowance for all accounts just
150  * by listening to said events. Other implementations of the EIP may not emit
151  * these events, as it isn't required by the specification.
152  *
153  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
154  * functions have been added to mitigate the well-known issues around setting
155  * allowances. See {IERC20-approve}.
156  */
157 contract ERC20 is Context, IERC20, IERC20Metadata {
158     mapping(address => uint256) private _balances;
159 
160     mapping(address => mapping(address => uint256)) private _allowances;
161 
162     uint256 private _totalSupply;
163 
164     string private _name;
165     string private _symbol;
166 
167     /**
168      * @dev Sets the values for {name} and {symbol}.
169      *
170      * The default value of {decimals} is 18. To select a different value for
171      * {decimals} you should overload it.
172      *
173      * All two of these values are immutable: they can only be set once during
174      * construction.
175      */
176     constructor(string memory name_, string memory symbol_) {
177         _name = name_;
178         _symbol = symbol_;
179     }
180 
181     /**
182      * @dev Returns the name of the token.
183      */
184     function name() public view virtual override returns (string memory) {
185         return _name;
186     }
187 
188     /**
189      * @dev Returns the symbol of the token, usually a shorter version of the
190      * name.
191      */
192     function symbol() public view virtual override returns (string memory) {
193         return _symbol;
194     }
195 
196     /**
197      * @dev Returns the number of decimals used to get its user representation.
198      * For example, if `decimals` equals `2`, a balance of `505` tokens should
199      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
200      *
201      * Tokens usually opt for a value of 18, imitating the relationship between
202      * Ether and Wei. This is the value {ERC20} uses, unless this function is
203      * overridden;
204      *
205      * NOTE: This information is only used for _display_ purposes: it in
206      * no way affects any of the arithmetic of the contract, including
207      * {IERC20-balanceOf} and {IERC20-transfer}.
208      */
209     function decimals() public view virtual override returns (uint8) {
210         return 18;
211     }
212 
213     /**
214      * @dev See {IERC20-totalSupply}.
215      */
216     function totalSupply() public view virtual override returns (uint256) {
217         return _totalSupply;
218     }
219 
220     /**
221      * @dev See {IERC20-balanceOf}.
222      */
223     function balanceOf(address account) public view virtual override returns (uint256) {
224         return _balances[account];
225     }
226 
227     /**
228      * @dev See {IERC20-transfer}.
229      *
230      * Requirements:
231      *
232      * - `recipient` cannot be the zero address.
233      * - the caller must have a balance of at least `amount`.
234      */
235     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
236         _transfer(_msgSender(), recipient, amount);
237         return true;
238     }
239 
240     /**
241      * @dev See {IERC20-allowance}.
242      */
243     function allowance(address owner, address spender) public view virtual override returns (uint256) {
244         return _allowances[owner][spender];
245     }
246 
247     /**
248      * @dev See {IERC20-approve}.
249      *
250      * Requirements:
251      *
252      * - `spender` cannot be the zero address.
253      */
254     function approve(address spender, uint256 amount) public virtual override returns (bool) {
255         _approve(_msgSender(), spender, amount);
256         return true;
257     }
258 
259     /**
260      * @dev See {IERC20-transferFrom}.
261      *
262      * Emits an {Approval} event indicating the updated allowance. This is not
263      * required by the EIP. See the note at the beginning of {ERC20}.
264      *
265      * Requirements:
266      *
267      * - `sender` and `recipient` cannot be the zero address.
268      * - `sender` must have a balance of at least `amount`.
269      * - the caller must have allowance for ``sender``'s tokens of at least
270      * `amount`.
271      */
272     function transferFrom(
273         address sender,
274         address recipient,
275         uint256 amount
276     ) public virtual override returns (bool) {
277         _transfer(sender, recipient, amount);
278 
279         uint256 currentAllowance = _allowances[sender][_msgSender()];
280         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
281     unchecked {
282         _approve(sender, _msgSender(), currentAllowance - amount);
283     }
284 
285         return true;
286     }
287 
288     /**
289      * @dev Atomically increases the allowance granted to `spender` by the caller.
290      *
291      * This is an alternative to {approve} that can be used as a mitigation for
292      * problems described in {IERC20-approve}.
293      *
294      * Emits an {Approval} event indicating the updated allowance.
295      *
296      * Requirements:
297      *
298      * - `spender` cannot be the zero address.
299      */
300     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
301         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
302         return true;
303     }
304 
305     /**
306      * @dev Atomically decreases the allowance granted to `spender` by the caller.
307      *
308      * This is an alternative to {approve} that can be used as a mitigation for
309      * problems described in {IERC20-approve}.
310      *
311      * Emits an {Approval} event indicating the updated allowance.
312      *
313      * Requirements:
314      *
315      * - `spender` cannot be the zero address.
316      * - `spender` must have allowance for the caller of at least
317      * `subtractedValue`.
318      */
319     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
320         uint256 currentAllowance = _allowances[_msgSender()][spender];
321         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
322     unchecked {
323         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
324     }
325 
326         return true;
327     }
328 
329     /**
330      * @dev Moves `amount` of tokens from `sender` to `recipient`.
331      *
332      * This internal function is equivalent to {transfer}, and can be used to
333      * e.g. implement automatic token fees, slashing mechanisms, etc.
334      *
335      * Emits a {Transfer} event.
336      *
337      * Requirements:
338      *
339      * - `sender` cannot be the zero address.
340      * - `recipient` cannot be the zero address.
341      * - `sender` must have a balance of at least `amount`.
342      */
343     function _transfer(
344         address sender,
345         address recipient,
346         uint256 amount
347     ) internal virtual {
348         require(sender != address(0), "ERC20: transfer from the zero address");
349         require(recipient != address(0), "ERC20: transfer to the zero address");
350 
351         _beforeTokenTransfer(sender, recipient, amount);
352 
353         uint256 senderBalance = _balances[sender];
354         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
355     unchecked {
356         _balances[sender] = senderBalance - amount;
357     }
358         _balances[recipient] += amount;
359 
360         emit Transfer(sender, recipient, amount);
361 
362         _afterTokenTransfer(sender, recipient, amount);
363     }
364 
365     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
366      * the total supply.
367      *
368      * Emits a {Transfer} event with `from` set to the zero address.
369      *
370      * Requirements:
371      *
372      * - `account` cannot be the zero address.
373      */
374     function _mint(address account, uint256 amount) internal virtual {
375         require(account != address(0), "ERC20: mint to the zero address");
376 
377         _beforeTokenTransfer(address(0), account, amount);
378 
379         _totalSupply += amount;
380         _balances[account] += amount;
381         emit Transfer(address(0), account, amount);
382 
383         _afterTokenTransfer(address(0), account, amount);
384     }
385 
386     /**
387      * @dev Destroys `amount` tokens from `account`, reducing the
388      * total supply.
389      *
390      * Emits a {Transfer} event with `to` set to the zero address.
391      *
392      * Requirements:
393      *
394      * - `account` cannot be the zero address.
395      * - `account` must have at least `amount` tokens.
396      */
397     function _burn(address account, uint256 amount) internal virtual {
398         require(account != address(0), "ERC20: burn from the zero address");
399 
400         _beforeTokenTransfer(account, address(0), amount);
401 
402         uint256 accountBalance = _balances[account];
403         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
404     unchecked {
405         _balances[account] = accountBalance - amount;
406     }
407         _totalSupply -= amount;
408 
409         emit Transfer(account, address(0), amount);
410 
411         _afterTokenTransfer(account, address(0), amount);
412     }
413 
414     /**
415      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
416      *
417      * This internal function is equivalent to `approve`, and can be used to
418      * e.g. set automatic allowances for certain subsystems, etc.
419      *
420      * Emits an {Approval} event.
421      *
422      * Requirements:
423      *
424      * - `owner` cannot be the zero address.
425      * - `spender` cannot be the zero address.
426      */
427     function _approve(
428         address owner,
429         address spender,
430         uint256 amount
431     ) internal virtual {
432         require(owner != address(0), "ERC20: approve from the zero address");
433         require(spender != address(0), "ERC20: approve to the zero address");
434 
435         _allowances[owner][spender] = amount;
436         emit Approval(owner, spender, amount);
437     }
438 
439     /**
440      * @dev Hook that is called before any transfer of tokens. This includes
441      * minting and burning.
442      *
443      * Calling conditions:
444      *
445      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
446      * will be transferred to `to`.
447      * - when `from` is zero, `amount` tokens will be minted for `to`.
448      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
449      * - `from` and `to` are never both zero.
450      *
451      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
452      */
453     function _beforeTokenTransfer(
454         address from,
455         address to,
456         uint256 amount
457     ) internal virtual {}
458 
459     /**
460      * @dev Hook that is called after any transfer of tokens. This includes
461      * minting and burning.
462      *
463      * Calling conditions:
464      *
465      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
466      * has been transferred to `to`.
467      * - when `from` is zero, `amount` tokens have been minted for `to`.
468      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
469      * - `from` and `to` are never both zero.
470      *
471      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
472      */
473     function _afterTokenTransfer(
474         address from,
475         address to,
476         uint256 amount
477     ) internal virtual {}
478 }
479 
480 abstract contract ERC20Burnable is Context, ERC20 {
481     /**
482      * @dev Destroys `amount` tokens from the caller.
483      *
484      * See {ERC20-_burn}.
485      */
486     function burn(uint256 amount) public virtual {
487         _burn(_msgSender(), amount);
488     }
489 
490     /**
491      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
492      * allowance.
493      *
494      * See {ERC20-_burn} and {ERC20-allowance}.
495      *
496      * Requirements:
497      *
498      * - the caller must have allowance for ``accounts``'s tokens of at least
499      * `amount`.
500      */
501     function burnFrom(address account, uint256 amount) public virtual {
502         uint256 currentAllowance = allowance(account, _msgSender());
503         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
504         unchecked {
505             _approve(account, _msgSender(), currentAllowance - amount);
506         }
507         _burn(account, amount);
508     }
509 }
510 
511 abstract contract Ownable is Context {
512     address private _owner;
513 
514     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
515 
516     /**
517      * @dev Initializes the contract setting the deployer as the initial owner.
518      */
519     constructor() {
520         _setOwner(_msgSender());
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
531      * @dev Throws if called by any account other than the owner.
532      */
533     modifier onlyOwner() {
534         require(owner() == _msgSender(), "Ownable: caller is not the owner");
535         _;
536     }
537 
538     /**
539      * @dev Leaves the contract without owner. It will not be possible to call
540      * `onlyOwner` functions anymore. Can only be called by the current owner.
541      *
542      * NOTE: Renouncing ownership will leave the contract without an owner,
543      * thereby removing any functionality that is only available to the owner.
544      */
545     function renounceOwnership() public virtual onlyOwner {
546         _setOwner(address(0));
547     }
548 
549     /**
550      * @dev Transfers ownership of the contract to a new account (`newOwner`).
551      * Can only be called by the current owner.
552      */
553     function transferOwnership(address newOwner) public virtual onlyOwner {
554         require(newOwner != address(0), "Ownable: new owner is the zero address");
555         _setOwner(newOwner);
556     }
557 
558     function _setOwner(address newOwner) private {
559         address oldOwner = _owner;
560         _owner = newOwner;
561         emit OwnershipTransferred(oldOwner, newOwner);
562     }
563 }
564 
565 abstract contract Minter is Ownable {
566     mapping(address => bool) public minters;
567     modifier onlyMinter { require(minters[msg.sender], "Not Minter!"); _; }
568     function setMinter(address address_, bool bool_) external onlyOwner {
569         minters[address_] = bool_;
570     }
571 }
572 
573 abstract contract Burner is Ownable {
574     mapping(address => bool) public burners;
575     modifier onlyBurner { require(burners[msg.sender], "Not Burner!"); _; }
576     function setBurner(address address_, bool bool_) external onlyOwner {
577         burners[address_] = bool_;
578     }
579 }
580 
581 contract Chanco is ERC20("Chanco", "CHANCO"), Minter, Burner, ERC20Burnable {
582 
583     function minttoken(address to_, uint256 amount_) external onlyMinter {
584         _mint(to_, amount_);
585     }
586 
587     function burntoken(address from_, uint256 amount_) external onlyBurner {
588         _burn(from_, amount_);
589     }
590 }