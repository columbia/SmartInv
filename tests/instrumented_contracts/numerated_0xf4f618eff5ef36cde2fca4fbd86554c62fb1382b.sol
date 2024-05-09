1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.9;
3 
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
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 /* ============================================================= */
80 /*
81  * @dev Provides information about the current execution context, including the
82  * sender of the transaction and its data. While these are generally available
83  * via msg.sender and msg.data, they should not be accessed in such a direct
84  * manner, since when dealing with meta-transactions the account sending and
85  * paying for execution may not be the actual sender (as far as an application
86  * is concerned).
87  *
88  * This contract is only required for intermediate, library-like contracts.
89  */
90 abstract contract Context {
91     function _msgSender() internal view virtual returns (address) {
92         return msg.sender;
93     }
94 
95     function _msgData() internal view virtual returns (bytes calldata) {
96         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
97         return msg.data;
98     }
99 }
100 
101 /* ============================================================= */
102 
103 /**
104  * @dev Implementation of the {IERC20} interface.
105  *
106  * This implementation is agnostic to the way tokens are created. This means
107  * that a supply mechanism has to be added in a derived contract using {_mint}.
108  * For a generic mechanism see {ERC20PresetMinterPauser}.
109  *
110  * TIP: For a detailed writeup see our guide
111  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
112  * to implement supply mechanisms].
113  *
114  * We have followed general OpenZeppelin guidelines: functions revert instead
115  * of returning `false` on failure. This behavior is nonetheless conventional
116  * and does not conflict with the expectations of ERC20 applications.
117  *
118  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
119  * This allows applications to reconstruct the allowance for all accounts just
120  * by listening to said events. Other implementations of the EIP may not emit
121  * these events, as it isn't required by the specification.
122  *
123  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
124  * functions have been added to mitigate the well-known issues around setting
125  * allowances. See {IERC20-approve}.
126  */
127 contract ERC20 is Context, IERC20 {
128     mapping (address => uint256) private _balances;
129 
130     mapping (address => mapping (address => uint256)) private _allowances;
131 
132     uint256 private _totalSupply;
133 
134     string private _name;
135     string private _symbol;
136 
137     /**
138      * @dev Sets the values for {name} and {symbol}.
139      *
140      * The defaut value of {decimals} is 18. To select a different value for
141      * {decimals} you should overload it.
142      *
143      * All three of these values are immutable: they can only be set once during
144      * construction.
145      */
146     constructor (string memory name_, string memory symbol_) {
147         _name = name_;
148         _symbol = symbol_;
149     }
150 
151     /**
152      * @dev Returns the name of the token.
153      */
154     function name() public view virtual returns (string memory) {
155         return _name;
156     }
157 
158     /**
159      * @dev Returns the symbol of the token, usually a shorter version of the
160      * name.
161      */
162     function symbol() public view virtual returns (string memory) {
163         return _symbol;
164     }
165 
166     /**
167      * @dev Returns the number of decimals used to get its user representation.
168      * For example, if `decimals` equals `2`, a balance of `505` tokens should
169      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
170      *
171      * Tokens usually opt for a value of 18, imitating the relationship between
172      * Ether and Wei. This is the value {ERC20} uses, unless this function is
173      * overloaded;
174      *
175      * NOTE: This information is only used for _display_ purposes: it in
176      * no way affects any of the arithmetic of the contract, including
177      * {IERC20-balanceOf} and {IERC20-transfer}.
178      */
179     function decimals() public view virtual returns (uint8) {
180         return 18;
181     }
182 
183     /**
184      * @dev See {IERC20-totalSupply}.
185      */
186     function totalSupply() public view virtual override returns (uint256) {
187         return _totalSupply;
188     }
189 
190     /**
191      * @dev See {IERC20-balanceOf}.
192      */
193     function balanceOf(address account) public view virtual override returns (uint256) {
194         return _balances[account];
195     }
196 
197     /**
198      * @dev See {IERC20-transfer}.
199      *
200      * Requirements:
201      *
202      * - `recipient` cannot be the zero address.
203      * - the caller must have a balance of at least `amount`.
204      */
205     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
206         _transfer(_msgSender(), recipient, amount);
207         return true;
208     }
209 
210     /**
211      * @dev See {IERC20-allowance}.
212      */
213     function allowance(address owner, address spender) public view virtual override returns (uint256) {
214         return _allowances[owner][spender];
215     }
216 
217     /**
218      * @dev See {IERC20-approve}.
219      *
220      * Requirements:
221      *
222      * - `spender` cannot be the zero address.
223      */
224     function approve(address spender, uint256 amount) public virtual override returns (bool) {
225         _approve(_msgSender(), spender, amount);
226         return true;
227     }
228 
229     /**
230      * @dev See {IERC20-transferFrom}.
231      *
232      * Emits an {Approval} event indicating the updated allowance. This is not
233      * required by the EIP. See the note at the beginning of {ERC20}.
234      *
235      * Requirements:
236      *
237      * - `sender` and `recipient` cannot be the zero address.
238      * - `sender` must have a balance of at least `amount`.
239      * - the caller must have allowance for ``sender``'s tokens of at least
240      * `amount`.
241      */
242     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
243         _transfer(sender, recipient, amount);
244 
245         uint256 currentAllowance = _allowances[sender][_msgSender()];
246         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
247         _approve(sender, _msgSender(), currentAllowance - amount);
248 
249         return true;
250     }
251 
252     /**
253      * @dev Atomically increases the allowance granted to `spender` by the caller.
254      *
255      * This is an alternative to {approve} that can be used as a mitigation for
256      * problems described in {IERC20-approve}.
257      *
258      * Emits an {Approval} event indicating the updated allowance.
259      *
260      * Requirements:
261      *
262      * - `spender` cannot be the zero address.
263      */
264     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
265         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
266         return true;
267     }
268 
269     /**
270      * @dev Atomically decreases the allowance granted to `spender` by the caller.
271      *
272      * This is an alternative to {approve} that can be used as a mitigation for
273      * problems described in {IERC20-approve}.
274      *
275      * Emits an {Approval} event indicating the updated allowance.
276      *
277      * Requirements:
278      *
279      * - `spender` cannot be the zero address.
280      * - `spender` must have allowance for the caller of at least
281      * `subtractedValue`.
282      */
283     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
284         uint256 currentAllowance = _allowances[_msgSender()][spender];
285         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
286         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
287 
288         return true;
289     }
290 
291     /**
292      * @dev Moves tokens `amount` from `sender` to `recipient`.
293      *
294      * This is internal function is equivalent to {transfer}, and can be used to
295      * e.g. implement automatic token fees, slashing mechanisms, etc.
296      *
297      * Emits a {Transfer} event.
298      *
299      * Requirements:
300      *
301      * - `sender` cannot be the zero address.
302      * - `recipient` cannot be the zero address.
303      * - `sender` must have a balance of at least `amount`.
304      */
305     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
306         require(sender != address(0), "ERC20: transfer from the zero address");
307         require(recipient != address(0), "ERC20: transfer to the zero address");
308 
309         _beforeTokenTransfer(sender, recipient, amount);
310 
311         uint256 senderBalance = _balances[sender];
312         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
313         _balances[sender] = senderBalance - amount;
314         _balances[recipient] += amount;
315 
316         emit Transfer(sender, recipient, amount);
317     }
318 
319     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
320      * the total supply.
321      *
322      * Emits a {Transfer} event with `from` set to the zero address.
323      *
324      * Requirements:
325      *
326      * - `to` cannot be the zero address.
327      */
328     function _mint(address account, uint256 amount) internal virtual {
329         require(account != address(0), "ERC20: mint to the zero address");
330 
331         _beforeTokenTransfer(address(0), account, amount);
332 
333         _totalSupply += amount;
334         _balances[account] += amount;
335         emit Transfer(address(0), account, amount);
336     }
337 
338     /**
339      * @dev Destroys `amount` tokens from `account`, reducing the
340      * total supply.
341      *
342      * Emits a {Transfer} event with `to` set to the zero address.
343      *
344      * Requirements:
345      *
346      * - `account` cannot be the zero address.
347      * - `account` must have at least `amount` tokens.
348      */
349     function _burn(address account, uint256 amount) internal virtual {
350         require(account != address(0), "ERC20: burn from the zero address");
351 
352         _beforeTokenTransfer(account, address(0), amount);
353 
354         uint256 accountBalance = _balances[account];
355         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
356         _balances[account] = accountBalance - amount;
357         _totalSupply -= amount;
358 
359         emit Transfer(account, address(0), amount);
360     }
361 
362     /**
363      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
364      *
365      * This internal function is equivalent to `approve`, and can be used to
366      * e.g. set automatic allowances for certain subsystems, etc.
367      *
368      * Emits an {Approval} event.
369      *
370      * Requirements:
371      *
372      * - `owner` cannot be the zero address.
373      * - `spender` cannot be the zero address.
374      */
375     function _approve(address owner, address spender, uint256 amount) internal virtual {
376         require(owner != address(0), "ERC20: approve from the zero address");
377         require(spender != address(0), "ERC20: approve to the zero address");
378 
379         _allowances[owner][spender] = amount;
380         emit Approval(owner, spender, amount);
381     }
382 
383     /**
384      * @dev Hook that is called before any transfer of tokens. This includes
385      * minting and burning.
386      *
387      * Calling conditions:
388      *
389      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
390      * will be to transferred to `to`.
391      * - when `from` is zero, `amount` tokens will be minted for `to`.
392      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
393      * - `from` and `to` are never both zero.
394      *
395      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
396      */
397     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
398 }
399 
400 /* ============================================================================== */
401 
402 
403 /**
404  * @dev Contract module which allows children to implement an emergency stop
405  * mechanism that can be triggered by an authorized account.
406  *
407  * This module is used through inheritance. It will make available the
408  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
409  * the functions of your contract. Note that they will not be pausable by
410  * simply including this module, only once the modifiers are put in place.
411  */
412 abstract contract Pausable is Context {
413     /**
414      * @dev Emitted when the pause is triggered by `account`.
415      */
416     event Paused(address account);
417 
418     /**
419      * @dev Emitted when the pause is lifted by `account`.
420      */
421     event Unpaused(address account);
422 
423     bool private _paused;
424 
425     /**
426      * @dev Initializes the contract in unpaused state.
427      */
428     constructor () {
429         _paused = false;
430     }
431 
432     /**
433      * @dev Returns true if the contract is paused, and false otherwise.
434      */
435     function paused() public view virtual returns (bool) {
436         return _paused;
437     }
438 
439     /**
440      * @dev Modifier to make a function callable only when the contract is not paused.
441      *
442      * Requirements:
443      *
444      * - The contract must not be paused.
445      */
446     modifier whenNotPaused() {
447         require(!paused(), "Pausable: paused");
448         _;
449     }
450 
451     /**
452      * @dev Modifier to make a function callable only when the contract is paused.
453      *
454      * Requirements:
455      *
456      * - The contract must be paused.
457      */
458     modifier whenPaused() {
459         require(paused(), "Pausable: not paused");
460         _;
461     }
462 
463     /**
464      * @dev Triggers stopped state.
465      *
466      * Requirements:
467      *
468      * - The contract must not be paused.
469      */
470     function _pause() internal virtual whenNotPaused {
471         _paused = true;
472         emit Paused(_msgSender());
473     }
474 
475     /**
476      * @dev Returns to normal state.
477      *
478      * Requirements:
479      *
480      * - The contract must be paused.
481      */
482     function _unpause() internal virtual whenPaused {
483         _paused = false;
484         emit Unpaused(_msgSender());
485     }
486 }
487 /* ============================================================================== */
488 
489 /**
490  * @dev ERC20 token with pausable token transfers, minting and burning.
491  *
492  * Useful for scenarios such as preventing trades until the end of an evaluation
493  * period, or having an emergency switch for freezing all token transfers in the
494  * event of a large bug.
495  */
496 abstract contract ERC20Pausable is ERC20, Pausable {
497     /**
498      * @dev See {ERC20-_beforeTokenTransfer}.
499      *
500      * Requirements:
501      *
502      * - the contract must not be paused.
503      */
504     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
505         super._beforeTokenTransfer(from, to, amount);
506 
507         require(!paused(), "ERC20Pausable: token transfer while paused");
508     }
509 }
510 
511 /* ============================================================================== */
512 
513 /**
514  * @dev Contract module which provides a basic access control mechanism, where
515  * there is an account (an owner) that can be granted exclusive access to
516  * specific functions.
517  *
518  * By default, the owner account will be the one that deploys the contract. This
519  * can later be changed with {transferOwnership}.
520  *
521  * This module is used through inheritance. It will make available the modifier
522  * `onlyOwner`, which can be applied to your functions to restrict their use to
523  * the owner.
524  */
525 abstract contract Ownable is Context {
526     address private _owner;
527 
528     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
529 
530     /**
531      * @dev Initializes the contract setting the deployer as the initial owner.
532      */
533     constructor () {
534         address msgSender = _msgSender();
535         _owner = msgSender;
536         emit OwnershipTransferred(address(0), msgSender);
537     }
538 
539     /**
540      * @dev Returns the address of the current owner.
541      */
542     function owner() public view virtual returns (address) {
543         return _owner;
544     }
545 
546     /**
547      * @dev Throws if called by any account other than the owner.
548      */
549     modifier onlyOwner() {
550         require(owner() == _msgSender(), "Ownable: caller is not the owner");
551         _;
552     }
553 
554     /**
555      * @dev Leaves the contract without owner. It will not be possible to call
556      * `onlyOwner` functions anymore. Can only be called by the current owner.
557      *
558      * NOTE: Renouncing ownership will leave the contract without an owner,
559      * thereby removing any functionality that is only available to the owner.
560      */
561     function renounceOwnership() public virtual onlyOwner {
562         emit OwnershipTransferred(_owner, address(0));
563         _owner = address(0);
564     }
565 
566     /**
567      * @dev Transfers ownership of the contract to a new account (`newOwner`).
568      * Can only be called by the current owner.
569      */
570     function transferOwnership(address newOwner) public virtual onlyOwner {
571         require(newOwner != address(0), "Ownable: new owner is the zero address");
572         emit OwnershipTransferred(_owner, newOwner);
573         _owner = newOwner;
574     }
575 }
576 
577 /* ============================================================================== */
578 
579 
580 contract AGV is ERC20, ERC20Pausable, Ownable {
581 
582     /* All Token will be distributed on Gnosis-safe multisig wallet. */
583     address public multiSigAdd = 0x03872114a6581E035Da8387159B00197EDe5D0cb;
584     
585     constructor() ERC20("Astra Guild Ventures Token","AGV") {
586         _mint(multiSigAdd,   2000000000000000000000000000);
587     }
588 
589    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override (ERC20, ERC20Pausable){
590         super._beforeTokenTransfer(from, to, amount);
591     }
592 }