1 // SPDX-License-Identifier: MIT
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
26  * @dev Contract module which provides a basic access control mechanism, where
27  * there is an account (an owner) that can be granted exclusive access to
28  * specific functions.
29  *
30  * By default, the owner account will be the one that deploys the contract. This
31  * can later be changed with {transferOwnership}.
32  *
33  * This module is used through inheritance. It will make available the modifier
34  * `onlyOwner`, which can be applied to your functions to restrict their use to
35  * the owner.
36  */
37 abstract contract Ownable is Context {
38     address private _owner;
39 
40     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42     /**
43      * @dev Initializes the contract setting the deployer as the initial owner.
44      */
45     constructor () {
46         address msgSender = _msgSender();
47         _owner = msgSender;
48         emit OwnershipTransferred(address(0), msgSender);
49     }
50 
51     /**
52      * @dev Returns the address of the current owner.
53      */
54     function owner() public view virtual returns (address) {
55         return _owner;
56     }
57 
58     /**
59      * @dev Throws if called by any account other than the owner.
60      */
61     modifier onlyOwner() {
62         require(owner() == _msgSender(), "Ownable: caller is not the owner");
63         _;
64     }
65 
66     /**
67      * @dev Leaves the contract without owner. It will not be possible to call
68      * `onlyOwner` functions anymore. Can only be called by the current owner.
69      *
70      * NOTE: Renouncing ownership will leave the contract without an owner,
71      * thereby removing any functionality that is only available to the owner.
72      */
73     function renounceOwnership() public virtual onlyOwner {
74         emit OwnershipTransferred(_owner, address(0));
75         _owner = address(0);
76     }
77 
78     /**
79      * @dev Transfers ownership of the contract to a new account (`newOwner`).
80      * Can only be called by the current owner.
81      */
82     function transferOwnership(address newOwner) public virtual onlyOwner {
83         require(newOwner != address(0), "Ownable: new owner is the zero address");
84         emit OwnershipTransferred(_owner, newOwner);
85         _owner = newOwner;
86     }
87 }
88 
89 /**
90  * @dev Contract module which allows children to implement an emergency stop
91  * mechanism that can be triggered by an authorized account.
92  *
93  * This module is used through inheritance. It will make available the
94  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
95  * the functions of your contract. Note that they will not be pausable by
96  * simply including this module, only once the modifiers are put in place.
97  */
98 abstract contract Pausable is Context {
99     /**
100      * @dev Emitted when the pause is triggered by `account`.
101      */
102     event Paused(address account);
103 
104     /**
105      * @dev Emitted when the pause is lifted by `account`.
106      */
107     event Unpaused(address account);
108 
109     bool private _paused;
110 
111     /**
112      * @dev Initializes the contract in unpaused state.
113      */
114     constructor () {
115         _paused = false;
116     }
117 
118     /**
119      * @dev Returns true if the contract is paused, and false otherwise.
120      */
121     function paused() public view virtual returns (bool) {
122         return _paused;
123     }
124 
125     /**
126      * @dev Modifier to make a function callable only when the contract is not paused.
127      *
128      * Requirements:
129      *
130      * - The contract must not be paused.
131      */
132     modifier whenNotPaused() {
133         require(!paused(), "Pausable: paused");
134         _;
135     }
136 
137     /**
138      * @dev Modifier to make a function callable only when the contract is paused.
139      *
140      * Requirements:
141      *
142      * - The contract must be paused.
143      */
144     modifier whenPaused() {
145         require(paused(), "Pausable: not paused");
146         _;
147     }
148 
149     /**
150      * @dev Triggers stopped state.
151      *
152      * Requirements:
153      *
154      * - The contract must not be paused.
155      */
156     function _pause() internal virtual whenNotPaused {
157         _paused = true;
158         emit Paused(_msgSender());
159     }
160 
161     /**
162      * @dev Returns to normal state.
163      *
164      * Requirements:
165      *
166      * - The contract must be paused.
167      */
168     function _unpause() internal virtual whenPaused {
169         _paused = false;
170         emit Unpaused(_msgSender());
171     }
172 }
173 
174 /**
175  * @dev Interface of the ERC20 standard as defined in the EIP.
176  */
177 interface IERC20 {
178     /**
179      * @dev Returns the amount of tokens in existence.
180      */
181     function totalSupply() external view returns (uint256);
182 
183     /**
184      * @dev Returns the amount of tokens owned by `account`.
185      */
186     function balanceOf(address account) external view returns (uint256);
187 
188     /**
189      * @dev Moves `amount` tokens from the caller's account to `recipient`.
190      *
191      * Returns a boolean value indicating whether the operation succeeded.
192      *
193      * Emits a {Transfer} event.
194      */
195     function transfer(address recipient, uint256 amount) external returns (bool);
196 
197     /**
198      * @dev Returns the remaining number of tokens that `spender` will be
199      * allowed to spend on behalf of `owner` through {transferFrom}. This is
200      * zero by default.
201      *
202      * This value changes when {approve} or {transferFrom} are called.
203      */
204     function allowance(address owner, address spender) external view returns (uint256);
205 
206     /**
207      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
208      *
209      * Returns a boolean value indicating whether the operation succeeded.
210      *
211      * IMPORTANT: Beware that changing an allowance with this method brings the risk
212      * that someone may use both the old and the new allowance by unfortunate
213      * transaction ordering. One possible solution to mitigate this race
214      * condition is to first reduce the spender's allowance to 0 and set the
215      * desired value afterwards:
216      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
217      *
218      * Emits an {Approval} event.
219      */
220     function approve(address spender, uint256 amount) external returns (bool);
221 
222     /**
223      * @dev Moves `amount` tokens from `sender` to `recipient` using the
224      * allowance mechanism. `amount` is then deducted from the caller's
225      * allowance.
226      *
227      * Returns a boolean value indicating whether the operation succeeded.
228      *
229      * Emits a {Transfer} event.
230      */
231     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
232 
233     /**
234      * @dev Emitted when `value` tokens are moved from one account (`from`) to
235      * another (`to`).
236      *
237      * Note that `value` may be zero.
238      */
239     event Transfer(address indexed from, address indexed to, uint256 value);
240 
241     /**
242      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
243      * a call to {approve}. `value` is the new allowance.
244      */
245     event Approval(address indexed owner, address indexed spender, uint256 value);
246 }
247 
248 /**
249  * @dev Interface for the optional metadata functions from the ERC20 standard.
250  *
251  * _Available since v4.1._
252  */
253 interface IERC20Metadata is IERC20 {
254     /**
255      * @dev Returns the name of the token.
256      */
257     function name() external view returns (string memory);
258 
259     /**
260      * @dev Returns the symbol of the token.
261      */
262     function symbol() external view returns (string memory);
263 
264     /**
265      * @dev Returns the decimals places of the token.
266      */
267     function decimals() external view returns (uint8);
268 }
269 
270 /**
271  * @dev Implementation of the {IERC20} interface.
272  *
273  * This implementation is agnostic to the way tokens are created. This means
274  * that a supply mechanism has to be added in a derived contract using {_mint}.
275  * For a generic mechanism see {ERC20PresetMinterPauser}.
276  *
277  * TIP: For a detailed writeup see our guide
278  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
279  * to implement supply mechanisms].
280  *
281  * We have followed general OpenZeppelin guidelines: functions revert instead
282  * of returning `false` on failure. This behavior is nonetheless conventional
283  * and does not conflict with the expectations of ERC20 applications.
284  *
285  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
286  * This allows applications to reconstruct the allowance for all accounts just
287  * by listening to said events. Other implementations of the EIP may not emit
288  * these events, as it isn't required by the specification.
289  *
290  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
291  * functions have been added to mitigate the well-known issues around setting
292  * allowances. See {IERC20-approve}.
293  */
294 contract ERC20 is Context, IERC20, IERC20Metadata {
295     mapping (address => uint256) private _balances;
296 
297     mapping (address => mapping (address => uint256)) private _allowances;
298 
299     uint256 private _totalSupply;
300 
301     string private _name;
302     string private _symbol;
303 
304     /**
305      * @dev Sets the values for {name} and {symbol}.
306      *
307      * The defaut value of {decimals} is 18. To select a different value for
308      * {decimals} you should overload it.
309      *
310      * All two of these values are immutable: they can only be set once during
311      * construction.
312      */
313     constructor (string memory name_, string memory symbol_) {
314         _name = name_;
315         _symbol = symbol_;
316     }
317 
318     /**
319      * @dev Returns the name of the token.
320      */
321     function name() public view virtual override returns (string memory) {
322         return _name;
323     }
324 
325     /**
326      * @dev Returns the symbol of the token, usually a shorter version of the
327      * name.
328      */
329     function symbol() public view virtual override returns (string memory) {
330         return _symbol;
331     }
332 
333     /**
334      * @dev Returns the number of decimals used to get its user representation.
335      * For example, if `decimals` equals `2`, a balance of `505` tokens should
336      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
337      *
338      * Tokens usually opt for a value of 18, imitating the relationship between
339      * Ether and Wei. This is the value {ERC20} uses, unless this function is
340      * overridden;
341      *
342      * NOTE: This information is only used for _display_ purposes: it in
343      * no way affects any of the arithmetic of the contract, including
344      * {IERC20-balanceOf} and {IERC20-transfer}.
345      */
346     function decimals() public view virtual override returns (uint8) {
347         return 18;
348     }
349 
350     /**
351      * @dev See {IERC20-totalSupply}.
352      */
353     function totalSupply() public view virtual override returns (uint256) {
354         return _totalSupply;
355     }
356 
357     /**
358      * @dev See {IERC20-balanceOf}.
359      */
360     function balanceOf(address account) public view virtual override returns (uint256) {
361         return _balances[account];
362     }
363 
364     /**
365      * @dev See {IERC20-transfer}.
366      *
367      * Requirements:
368      *
369      * - `recipient` cannot be the zero address.
370      * - the caller must have a balance of at least `amount`.
371      */
372     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
373         _transfer(_msgSender(), recipient, amount);
374         return true;
375     }
376 
377     /**
378      * @dev See {IERC20-allowance}.
379      */
380     function allowance(address owner, address spender) public view virtual override returns (uint256) {
381         return _allowances[owner][spender];
382     }
383 
384     /**
385      * @dev See {IERC20-approve}.
386      *
387      * Requirements:
388      *
389      * - `spender` cannot be the zero address.
390      */
391     function approve(address spender, uint256 amount) public virtual override returns (bool) {
392         _approve(_msgSender(), spender, amount);
393         return true;
394     }
395 
396     /**
397      * @dev See {IERC20-transferFrom}.
398      *
399      * Emits an {Approval} event indicating the updated allowance. This is not
400      * required by the EIP. See the note at the beginning of {ERC20}.
401      *
402      * Requirements:
403      *
404      * - `sender` and `recipient` cannot be the zero address.
405      * - `sender` must have a balance of at least `amount`.
406      * - the caller must have allowance for ``sender``'s tokens of at least
407      * `amount`.
408      */
409     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
410         _transfer(sender, recipient, amount);
411 
412         uint256 currentAllowance = _allowances[sender][_msgSender()];
413         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
414         _approve(sender, _msgSender(), currentAllowance - amount);
415 
416         return true;
417     }
418 
419     /**
420      * @dev Atomically increases the allowance granted to `spender` by the caller.
421      *
422      * This is an alternative to {approve} that can be used as a mitigation for
423      * problems described in {IERC20-approve}.
424      *
425      * Emits an {Approval} event indicating the updated allowance.
426      *
427      * Requirements:
428      *
429      * - `spender` cannot be the zero address.
430      */
431     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
432         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
433         return true;
434     }
435 
436     /**
437      * @dev Atomically decreases the allowance granted to `spender` by the caller.
438      *
439      * This is an alternative to {approve} that can be used as a mitigation for
440      * problems described in {IERC20-approve}.
441      *
442      * Emits an {Approval} event indicating the updated allowance.
443      *
444      * Requirements:
445      *
446      * - `spender` cannot be the zero address.
447      * - `spender` must have allowance for the caller of at least
448      * `subtractedValue`.
449      */
450     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
451         uint256 currentAllowance = _allowances[_msgSender()][spender];
452         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
453         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
454 
455         return true;
456     }
457 
458     /**
459      * @dev Moves tokens `amount` from `sender` to `recipient`.
460      *
461      * This is internal function is equivalent to {transfer}, and can be used to
462      * e.g. implement automatic token fees, slashing mechanisms, etc.
463      *
464      * Emits a {Transfer} event.
465      *
466      * Requirements:
467      *
468      * - `sender` cannot be the zero address.
469      * - `recipient` cannot be the zero address.
470      * - `sender` must have a balance of at least `amount`.
471      */
472     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
473         require(sender != address(0), "ERC20: transfer from the zero address");
474         require(recipient != address(0), "ERC20: transfer to the zero address");
475 
476         _beforeTokenTransfer(sender, recipient, amount);
477 
478         uint256 senderBalance = _balances[sender];
479         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
480         _balances[sender] = senderBalance - amount;
481         _balances[recipient] += amount;
482 
483         emit Transfer(sender, recipient, amount);
484     }
485 
486     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
487      * the total supply.
488      *
489      * Emits a {Transfer} event with `from` set to the zero address.
490      *
491      * Requirements:
492      *
493      * - `to` cannot be the zero address.
494      */
495     function _mint(address account, uint256 amount) internal virtual {
496         require(account != address(0), "ERC20: mint to the zero address");
497 
498         _beforeTokenTransfer(address(0), account, amount);
499 
500         _totalSupply += amount;
501         _balances[account] += amount;
502         emit Transfer(address(0), account, amount);
503     }
504 
505     /**
506      * @dev Destroys `amount` tokens from `account`, reducing the
507      * total supply.
508      *
509      * Emits a {Transfer} event with `to` set to the zero address.
510      *
511      * Requirements:
512      *
513      * - `account` cannot be the zero address.
514      * - `account` must have at least `amount` tokens.
515      */
516     function _burn(address account, uint256 amount) internal virtual {
517         require(account != address(0), "ERC20: burn from the zero address");
518 
519         _beforeTokenTransfer(account, address(0), amount);
520 
521         uint256 accountBalance = _balances[account];
522         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
523         _balances[account] = accountBalance - amount;
524         _totalSupply -= amount;
525 
526         emit Transfer(account, address(0), amount);
527     }
528 
529     /**
530      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
531      *
532      * This internal function is equivalent to `approve`, and can be used to
533      * e.g. set automatic allowances for certain subsystems, etc.
534      *
535      * Emits an {Approval} event.
536      *
537      * Requirements:
538      *
539      * - `owner` cannot be the zero address.
540      * - `spender` cannot be the zero address.
541      */
542     function _approve(address owner, address spender, uint256 amount) internal virtual {
543         require(owner != address(0), "ERC20: approve from the zero address");
544         require(spender != address(0), "ERC20: approve to the zero address");
545 
546         _allowances[owner][spender] = amount;
547         emit Approval(owner, spender, amount);
548     }
549 
550     /**
551      * @dev Hook that is called before any transfer of tokens. This includes
552      * minting and burning.
553      *
554      * Calling conditions:
555      *
556      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
557      * will be to transferred to `to`.
558      * - when `from` is zero, `amount` tokens will be minted for `to`.
559      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
560      * - `from` and `to` are never both zero.
561      *
562      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
563      */
564     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
565 }
566 
567 contract BRKToken is ERC20, Pausable, Ownable  {
568     constructor() ERC20("BRKToken", "BRK") {
569         _mint(msg.sender, 650000000000 * (10 ** uint256(decimals())));
570     }
571 
572     function pause() public onlyOwner {
573         _pause();
574     }
575 
576     function unpause() public onlyOwner {
577         _unpause();
578     }
579 
580     function _beforeTokenTransfer(address from, address to, uint256 amount)
581         internal
582         whenNotPaused
583         override
584     {
585         super._beforeTokenTransfer(from, to, amount);
586     }
587 
588 }