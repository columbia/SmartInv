1 // SPDX-License-Identifier: Unlicense
2 pragma solidity ^0.8.0;
3 
4 /*
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
20         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
21         return msg.data;
22     }
23 }
24 
25 /**
26  * @dev Interface of the ERC20 standard as defined in the EIP.
27  */
28 interface IERC20 {
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
40      * @dev Moves `amount` tokens from the caller's account to `recipient`.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * Emits a {Transfer} event.
45      */
46     function transfer(address recipient, uint256 amount) external returns (bool);
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
74      * @dev Moves `amount` tokens from `sender` to `recipient` using the
75      * allowance mechanism. `amount` is then deducted from the caller's
76      * allowance.
77      *
78      * Returns a boolean value indicating whether the operation succeeded.
79      *
80      * Emits a {Transfer} event.
81      */
82     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Emitted when `value` tokens are moved from one account (`from`) to
86      * another (`to`).
87      *
88      * Note that `value` may be zero.
89      */
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 
92     /**
93      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
94      * a call to {approve}. `value` is the new allowance.
95      */
96     event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 /**
100  * @dev Interface for the optional metadata functions from the ERC20 standard.
101  *
102  * _Available since v4.1._
103  */
104 interface IERC20Metadata is IERC20 {
105     /**
106      * @dev Returns the name of the token.
107      */
108     function name() external view returns (string memory);
109 
110     /**
111      * @dev Returns the symbol of the token.
112      */
113     function symbol() external view returns (string memory);
114 
115     /**
116      * @dev Returns the decimals places of the token.
117      */
118     function decimals() external view returns (uint8);
119 }
120 
121 /**
122  * @dev Implementation of the {IERC20} interface.
123  *
124  * This implementation is agnostic to the way tokens are created. This means
125  * that a supply mechanism has to be added in a derived contract using {_mint}.
126  * For a generic mechanism see {ERC20PresetMinterPauser}.
127  *
128  * TIP: For a detailed writeup see our guide
129  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
130  * to implement supply mechanisms].
131  *
132  * We have followed general OpenZeppelin guidelines: functions revert instead
133  * of returning `false` on failure. This behavior is nonetheless conventional
134  * and does not conflict with the expectations of ERC20 applications.
135  *
136  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
137  * This allows applications to reconstruct the allowance for all accounts just
138  * by listening to said events. Other implementations of the EIP may not emit
139  * these events, as it isn't required by the specification.
140  *
141  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
142  * functions have been added to mitigate the well-known issues around setting
143  * allowances. See {IERC20-approve}.
144  */
145 contract ERC20 is Context, IERC20, IERC20Metadata {
146     mapping (address => uint256) private _balances;
147 
148     mapping (address => mapping (address => uint256)) private _allowances;
149 
150     uint256 private _totalSupply;
151 
152     string private _name;
153     string private _symbol;
154 
155     /**
156      * @dev Sets the values for {name} and {symbol}.
157      *
158      * The defaut value of {decimals} is 18. To select a different value for
159      * {decimals} you should overload it.
160      *
161      * All two of these values are immutable: they can only be set once during
162      * construction.
163      */
164     constructor (string memory name_, string memory symbol_) {
165         _name = name_;
166         _symbol = symbol_;
167     }
168 
169     /**
170      * @dev Returns the name of the token.
171      */
172     function name() public view virtual override returns (string memory) {
173         return _name;
174     }
175 
176     /**
177      * @dev Returns the symbol of the token, usually a shorter version of the
178      * name.
179      */
180     function symbol() public view virtual override returns (string memory) {
181         return _symbol;
182     }
183 
184     /**
185      * @dev Returns the number of decimals used to get its user representation.
186      * For example, if `decimals` equals `2`, a balance of `505` tokens should
187      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
188      *
189      * Tokens usually opt for a value of 18, imitating the relationship between
190      * Ether and Wei. This is the value {ERC20} uses, unless this function is
191      * overridden;
192      *
193      * NOTE: This information is only used for _display_ purposes: it in
194      * no way affects any of the arithmetic of the contract, including
195      * {IERC20-balanceOf} and {IERC20-transfer}.
196      */
197     function decimals() public view virtual override returns (uint8) {
198         return 18;
199     }
200 
201     /**
202      * @dev See {IERC20-totalSupply}.
203      */
204     function totalSupply() public view virtual override returns (uint256) {
205         return _totalSupply;
206     }
207 
208     /**
209      * @dev See {IERC20-balanceOf}.
210      */
211     function balanceOf(address account) public view virtual override returns (uint256) {
212         return _balances[account];
213     }
214 
215     /**
216      * @dev See {IERC20-transfer}.
217      *
218      * Requirements:
219      *
220      * - `recipient` cannot be the zero address.
221      * - the caller must have a balance of at least `amount`.
222      */
223     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
224         _transfer(_msgSender(), recipient, amount);
225         return true;
226     }
227 
228     /**
229      * @dev See {IERC20-allowance}.
230      */
231     function allowance(address owner, address spender) public view virtual override returns (uint256) {
232         return _allowances[owner][spender];
233     }
234 
235     /**
236      * @dev See {IERC20-approve}.
237      *
238      * Requirements:
239      *
240      * - `spender` cannot be the zero address.
241      */
242     function approve(address spender, uint256 amount) public virtual override returns (bool) {
243         _approve(_msgSender(), spender, amount);
244         return true;
245     }
246 
247     /**
248      * @dev See {IERC20-transferFrom}.
249      *
250      * Emits an {Approval} event indicating the updated allowance. This is not
251      * required by the EIP. See the note at the beginning of {ERC20}.
252      *
253      * Requirements:
254      *
255      * - `sender` and `recipient` cannot be the zero address.
256      * - `sender` must have a balance of at least `amount`.
257      * - the caller must have allowance for ``sender``'s tokens of at least
258      * `amount`.
259      */
260     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
261         _transfer(sender, recipient, amount);
262 
263         uint256 currentAllowance = _allowances[sender][_msgSender()];
264         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
265         _approve(sender, _msgSender(), currentAllowance - amount);
266 
267         return true;
268     }
269 
270     /**
271      * @dev Atomically increases the allowance granted to `spender` by the caller.
272      *
273      * This is an alternative to {approve} that can be used as a mitigation for
274      * problems described in {IERC20-approve}.
275      *
276      * Emits an {Approval} event indicating the updated allowance.
277      *
278      * Requirements:
279      *
280      * - `spender` cannot be the zero address.
281      */
282     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
283         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
284         return true;
285     }
286 
287     /**
288      * @dev Atomically decreases the allowance granted to `spender` by the caller.
289      *
290      * This is an alternative to {approve} that can be used as a mitigation for
291      * problems described in {IERC20-approve}.
292      *
293      * Emits an {Approval} event indicating the updated allowance.
294      *
295      * Requirements:
296      *
297      * - `spender` cannot be the zero address.
298      * - `spender` must have allowance for the caller of at least
299      * `subtractedValue`.
300      */
301     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
302         uint256 currentAllowance = _allowances[_msgSender()][spender];
303         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
304         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
305 
306         return true;
307     }
308 
309     /**
310      * @dev Moves tokens `amount` from `sender` to `recipient`.
311      *
312      * This is internal function is equivalent to {transfer}, and can be used to
313      * e.g. implement automatic token fees, slashing mechanisms, etc.
314      *
315      * Emits a {Transfer} event.
316      *
317      * Requirements:
318      *
319      * - `sender` cannot be the zero address.
320      * - `recipient` cannot be the zero address.
321      * - `sender` must have a balance of at least `amount`.
322      */
323     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
324         require(sender != address(0), "ERC20: transfer from the zero address");
325         require(recipient != address(0), "ERC20: transfer to the zero address");
326 
327         _beforeTokenTransfer(sender, recipient, amount);
328 
329         uint256 senderBalance = _balances[sender];
330         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
331         _balances[sender] = senderBalance - amount;
332         _balances[recipient] += amount;
333 
334         emit Transfer(sender, recipient, amount);
335     }
336 
337     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
338      * the total supply.
339      *
340      * Emits a {Transfer} event with `from` set to the zero address.
341      *
342      * Requirements:
343      *
344      * - `to` cannot be the zero address.
345      */
346     function _mint(address account, uint256 amount) internal virtual {
347         require(account != address(0), "ERC20: mint to the zero address");
348 
349         _beforeTokenTransfer(address(0), account, amount);
350 
351         _totalSupply += amount;
352         _balances[account] += amount;
353         emit Transfer(address(0), account, amount);
354     }
355 
356     /**
357      * @dev Destroys `amount` tokens from `account`, reducing the
358      * total supply.
359      *
360      * Emits a {Transfer} event with `to` set to the zero address.
361      *
362      * Requirements:
363      *
364      * - `account` cannot be the zero address.
365      * - `account` must have at least `amount` tokens.
366      */
367     function _burn(address account, uint256 amount) internal virtual {
368         require(account != address(0), "ERC20: burn from the zero address");
369 
370         _beforeTokenTransfer(account, address(0), amount);
371 
372         uint256 accountBalance = _balances[account];
373         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
374         _balances[account] = accountBalance - amount;
375         _totalSupply -= amount;
376 
377         emit Transfer(account, address(0), amount);
378     }
379 
380     /**
381      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
382      *
383      * This internal function is equivalent to `approve`, and can be used to
384      * e.g. set automatic allowances for certain subsystems, etc.
385      *
386      * Emits an {Approval} event.
387      *
388      * Requirements:
389      *
390      * - `owner` cannot be the zero address.
391      * - `spender` cannot be the zero address.
392      */
393     function _approve(address owner, address spender, uint256 amount) internal virtual {
394         require(owner != address(0), "ERC20: approve from the zero address");
395         require(spender != address(0), "ERC20: approve to the zero address");
396 
397         _allowances[owner][spender] = amount;
398         emit Approval(owner, spender, amount);
399     }
400 
401     /**
402      * @dev Hook that is called before any transfer of tokens. This includes
403      * minting and burning.
404      *
405      * Calling conditions:
406      *
407      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
408      * will be to transferred to `to`.
409      * - when `from` is zero, `amount` tokens will be minted for `to`.
410      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
411      * - `from` and `to` are never both zero.
412      *
413      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
414      */
415     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
416 }
417 
418 /**
419  * Depositor is a ERC20 proxy for the MultiverseToken whose only supported transaction is
420  * `transfer()`, which is converted to a `MultiverseToken.depositFrom()` call with the
421  * `depository` associated via `MultiverseToken.createDepositor()`.
422  */
423 contract Depositor is Context, IERC20, IERC20Metadata {
424     MultiverseToken private _multiverseToken;
425     string private _name;
426 
427     constructor(MultiverseToken multiverseToken_, string memory name_) {
428         _multiverseToken = multiverseToken_;
429         _name = name_;
430     }
431 
432     /**
433      * @dev The Despositor fulfills the ERC20 `transfer` operation by transferring
434      * the specified `value` from the `msg.sender` to the Depositor's `depository`,
435      * destined for specified `account`.
436      */
437     function transfer(address account, uint256 value) public virtual override returns (bool) {
438         return _multiverseToken.depositFrom(_msgSender(), account, value);
439     }
440 
441     function name() public view virtual override returns (string memory) {
442         return _name;
443     }
444 
445     function symbol() public view virtual override returns (string memory) {
446         return _multiverseToken.symbol();
447     }
448 
449     function decimals() public view virtual override returns (uint8) {
450         return _multiverseToken.decimals();
451     }
452 
453     function totalSupply() public view virtual override returns (uint256) {
454         return _multiverseToken.totalSupply();
455     }
456 
457     function balanceOf(address account) public view virtual override returns (uint256) {
458         return _multiverseToken.balanceOf(account);
459     }
460 
461     function allowance(address owner, address spender) public view virtual override returns (uint256) {
462         return _multiverseToken.allowance(owner, spender);
463     }
464 
465     function approve(address, uint256) public virtual override returns (bool) {
466         require(false, "approve() is not supported. call the MultiverseToken directly");
467         return false;
468     }
469 
470     function transferFrom(address, address, uint256) public virtual override returns (bool) {
471         require(false, "transferFrom() is not supported. call the MultiverseToken directly");
472         return false;
473     }
474 }
475 
476 /**
477  * ERC20 token for the Multiverse.
478  */
479 contract MultiverseToken is ERC20 {
480     address private reserve;
481     mapping (address => address) private depositors;
482 
483     /**
484      * @dev Constructor that initializes the initial token supply under the care of the "reserve" account.
485      */
486     constructor(
487         string memory name,
488         string memory symbol,
489         uint256 initialSupply,
490         address reserveAddr
491     ) ERC20(name, symbol) {
492         reserve = reserveAddr;
493         emit ReserveChanged(address(0), reserve);
494         _mint(reserve, initialSupply);
495     }
496 
497     modifier reserved() {
498         require(_msgSender() == reserve, "operation is reserved");
499         _;
500     }
501 
502     /**
503      * @dev Decreases the money supply.
504      */
505     function burn(uint256 value) reserved external {
506         _burn(reserve, value);
507     }
508 
509     /**
510      * @dev Emitted when the `reserve` is changed from one account (`from`) to
511      * another (`to`).
512      */
513     event ReserveChanged(address indexed from, address indexed to);
514 
515     /**
516      * @dev Transfers the role of the reserve to a new account (e.g. key rotation).
517      *      Note that allowances are NOT transferred.
518      */
519     function setReserve(address newReserve) reserved external {
520         transfer(newReserve, balanceOf(reserve));
521         reserve = newReserve;
522         emit ReserveChanged(_msgSender(), newReserve);
523     }
524 
525     /**
526      * @dev Gets the current reserve.
527      */
528     function getReserve() external view returns (address) {
529         return reserve;
530     }
531 
532     /** @dev Emitted when a Deposit is made to a `depository` destined for a depository-managed `account`. */
533     event Deposit(address indexed from, address indexed depository, uint256 value, address indexed account);
534 
535     /**
536      * @dev Transfers `value` tokens from the `msg.sender` to the `depository`, destined for
537      * the specified `account`. This emits an ERC20 `Transfer()` event to the depository, and a corresponding
538      * `Deposit()` event that indicates the `account` address, to be managed off-chain by the depository.
539      */
540     function deposit(address depository, uint256 value, address account) external returns (bool) {
541       return _deposit(_msgSender(), depository, value, account);
542     }
543 
544     /**
545      * @dev A _deposit() is essentially a transfer to a `depository` that emits a special `Deposit()`
546      * event reporting the destination `account`, which is managed off-chain by the depository.
547      */
548     function _deposit(address from, address depository, uint256 value, address account) internal returns (bool) {
549       emit Deposit(from, depository, value, account);
550       _transfer(from, depository, value);
551       return true;
552     }
553 
554     /**
555      * @dev Emitted when a Depositor is created.
556      */
557     event DepositorCreated(address depositor, address indexed depository);
558 
559     /**
560      * @dev Deploys a new Depositor ERC20 contract that deposits to a specified `depository`
561      * in response to the `transfer(account, value)` operation, essentially converting it
562      * to `deposit(despository, value, account)` on behalf of the sender. Only the reserve
563      * can call this method.
564      */
565     function createDepositor(string memory name, address depository) reserved external returns (address) {
566         require(depository != address(0), "cannot deposit to zero address");
567         Depositor depositor = new Depositor(this, name);
568 
569         address depositorAddress = address(depositor);
570         depositors[depositorAddress] = depository;
571 
572         emit DepositorCreated(depositorAddress, depository);
573         return depositorAddress;
574     }
575 
576     /** @dev Returns the depository for the specified Depositor address. */
577     function getDepository(address depositor) external view returns (address) {
578         return depositors[depositor];
579     }
580 
581     /**
582      * @dev Transfers `value` tokens from the `from` address to the calling Depositor's depository,
583      * emiting a `Deposit()` event that indicates the destination `account`. Only Depositors created
584      * via `createDepositor()` can call this method.
585      */
586     function depositFrom(address from, address account, uint256 value) external returns (bool) {
587       address depository = depositors[_msgSender()];
588       require(depository != address(0), "depositFrom() can only be called by Depositors created by this contract");
589 
590       return _deposit(from, depository, value, account);
591     }
592 }