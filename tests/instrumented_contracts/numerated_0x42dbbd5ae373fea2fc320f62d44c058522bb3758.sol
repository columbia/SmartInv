1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
82 
83 
84 
85 pragma solidity ^0.8.0;
86 
87 
88 /**
89  * @dev Interface for the optional metadata functions from the ERC20 standard.
90  *
91  * _Available since v4.1._
92  */
93 interface IERC20Metadata is IERC20 {
94     /**
95      * @dev Returns the name of the token.
96      */
97     function name() external view returns (string memory);
98 
99     /**
100      * @dev Returns the symbol of the token.
101      */
102     function symbol() external view returns (string memory);
103 
104     /**
105      * @dev Returns the decimals places of the token.
106      */
107     function decimals() external view returns (uint8);
108 }
109 
110 // File: @openzeppelin/contracts/utils/Context.sol
111 
112 
113 
114 pragma solidity ^0.8.0;
115 
116 /*
117  * @dev Provides information about the current execution context, including the
118  * sender of the transaction and its data. While these are generally available
119  * via msg.sender and msg.data, they should not be accessed in such a direct
120  * manner, since when dealing with meta-transactions the account sending and
121  * paying for execution may not be the actual sender (as far as an application
122  * is concerned).
123  *
124  * This contract is only required for intermediate, library-like contracts.
125  */
126 abstract contract Context {
127     function _msgSender() internal view virtual returns (address) {
128         return msg.sender;
129     }
130 
131     function _msgData() internal view virtual returns (bytes calldata) {
132         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
133         return msg.data;
134     }
135 }
136 
137 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
138 
139 
140 
141 pragma solidity ^0.8.0;
142 
143 
144 
145 
146 /**
147  * @dev Implementation of the {IERC20} interface.
148  *
149  * This implementation is agnostic to the way tokens are created. This means
150  * that a supply mechanism has to be added in a derived contract using {_mint}.
151  * For a generic mechanism see {ERC20PresetMinterPauser}.
152  *
153  * TIP: For a detailed writeup see our guide
154  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
155  * to implement supply mechanisms].
156  *
157  * We have followed general OpenZeppelin guidelines: functions revert instead
158  * of returning `false` on failure. This behavior is nonetheless conventional
159  * and does not conflict with the expectations of ERC20 applications.
160  *
161  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
162  * This allows applications to reconstruct the allowance for all accounts just
163  * by listening to said events. Other implementations of the EIP may not emit
164  * these events, as it isn't required by the specification.
165  *
166  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
167  * functions have been added to mitigate the well-known issues around setting
168  * allowances. See {IERC20-approve}.
169  */
170 contract ERC20 is Context, IERC20, IERC20Metadata {
171     mapping (address => uint256) private _balances;
172 
173     mapping (address => mapping (address => uint256)) private _allowances;
174 
175     uint256 private _totalSupply;
176 
177     string private _name;
178     string private _symbol;
179 
180     /**
181      * @dev Sets the values for {name} and {symbol}.
182      *
183      * The defaut value of {decimals} is 18. To select a different value for
184      * {decimals} you should overload it.
185      *
186      * All two of these values are immutable: they can only be set once during
187      * construction.
188      */
189     constructor (string memory name_, string memory symbol_) {
190         _name = name_;
191         _symbol = symbol_;
192     }
193 
194     /**
195      * @dev Returns the name of the token.
196      */
197     function name() public view virtual override returns (string memory) {
198         return _name;
199     }
200 
201     /**
202      * @dev Returns the symbol of the token, usually a shorter version of the
203      * name.
204      */
205     function symbol() public view virtual override returns (string memory) {
206         return _symbol;
207     }
208 
209     /**
210      * @dev Returns the number of decimals used to get its user representation.
211      * For example, if `decimals` equals `2`, a balance of `505` tokens should
212      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
213      *
214      * Tokens usually opt for a value of 18, imitating the relationship between
215      * Ether and Wei. This is the value {ERC20} uses, unless this function is
216      * overridden;
217      *
218      * NOTE: This information is only used for _display_ purposes: it in
219      * no way affects any of the arithmetic of the contract, including
220      * {IERC20-balanceOf} and {IERC20-transfer}.
221      */
222     function decimals() public view virtual override returns (uint8) {
223         return 18;
224     }
225 
226     /**
227      * @dev See {IERC20-totalSupply}.
228      */
229     function totalSupply() public view virtual override returns (uint256) {
230         return _totalSupply;
231     }
232 
233     /**
234      * @dev See {IERC20-balanceOf}.
235      */
236     function balanceOf(address account) public view virtual override returns (uint256) {
237         return _balances[account];
238     }
239 
240     /**
241      * @dev See {IERC20-transfer}.
242      *
243      * Requirements:
244      *
245      * - `recipient` cannot be the zero address.
246      * - the caller must have a balance of at least `amount`.
247      */
248     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
249         _transfer(_msgSender(), recipient, amount);
250         return true;
251     }
252 
253     /**
254      * @dev See {IERC20-allowance}.
255      */
256     function allowance(address owner, address spender) public view virtual override returns (uint256) {
257         return _allowances[owner][spender];
258     }
259 
260     /**
261      * @dev See {IERC20-approve}.
262      *
263      * Requirements:
264      *
265      * - `spender` cannot be the zero address.
266      */
267     function approve(address spender, uint256 amount) public virtual override returns (bool) {
268         _approve(_msgSender(), spender, amount);
269         return true;
270     }
271 
272     /**
273      * @dev See {IERC20-transferFrom}.
274      *
275      * Emits an {Approval} event indicating the updated allowance. This is not
276      * required by the EIP. See the note at the beginning of {ERC20}.
277      *
278      * Requirements:
279      *
280      * - `sender` and `recipient` cannot be the zero address.
281      * - `sender` must have a balance of at least `amount`.
282      * - the caller must have allowance for ``sender``'s tokens of at least
283      * `amount`.
284      */
285     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
286         _transfer(sender, recipient, amount);
287 
288         uint256 currentAllowance = _allowances[sender][_msgSender()];
289         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
290         _approve(sender, _msgSender(), currentAllowance - amount);
291 
292         return true;
293     }
294 
295     /**
296      * @dev Atomically increases the allowance granted to `spender` by the caller.
297      *
298      * This is an alternative to {approve} that can be used as a mitigation for
299      * problems described in {IERC20-approve}.
300      *
301      * Emits an {Approval} event indicating the updated allowance.
302      *
303      * Requirements:
304      *
305      * - `spender` cannot be the zero address.
306      */
307     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
308         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
309         return true;
310     }
311 
312     /**
313      * @dev Atomically decreases the allowance granted to `spender` by the caller.
314      *
315      * This is an alternative to {approve} that can be used as a mitigation for
316      * problems described in {IERC20-approve}.
317      *
318      * Emits an {Approval} event indicating the updated allowance.
319      *
320      * Requirements:
321      *
322      * - `spender` cannot be the zero address.
323      * - `spender` must have allowance for the caller of at least
324      * `subtractedValue`.
325      */
326     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
327         uint256 currentAllowance = _allowances[_msgSender()][spender];
328         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
329         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
330 
331         return true;
332     }
333 
334     /**
335      * @dev Moves tokens `amount` from `sender` to `recipient`.
336      *
337      * This is internal function is equivalent to {transfer}, and can be used to
338      * e.g. implement automatic token fees, slashing mechanisms, etc.
339      *
340      * Emits a {Transfer} event.
341      *
342      * Requirements:
343      *
344      * - `sender` cannot be the zero address.
345      * - `recipient` cannot be the zero address.
346      * - `sender` must have a balance of at least `amount`.
347      */
348     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
349         require(sender != address(0), "ERC20: transfer from the zero address");
350         require(recipient != address(0), "ERC20: transfer to the zero address");
351 
352         _beforeTokenTransfer(sender, recipient, amount);
353 
354         uint256 senderBalance = _balances[sender];
355         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
356         _balances[sender] = senderBalance - amount;
357         _balances[recipient] += amount;
358 
359         emit Transfer(sender, recipient, amount);
360     }
361 
362     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
363      * the total supply.
364      *
365      * Emits a {Transfer} event with `from` set to the zero address.
366      *
367      * Requirements:
368      *
369      * - `to` cannot be the zero address.
370      */
371     function _mint(address account, uint256 amount) internal virtual {
372         require(account != address(0), "ERC20: mint to the zero address");
373 
374         _beforeTokenTransfer(address(0), account, amount);
375 
376         _totalSupply += amount;
377         _balances[account] += amount;
378         emit Transfer(address(0), account, amount);
379     }
380 
381     /**
382      * @dev Destroys `amount` tokens from `account`, reducing the
383      * total supply.
384      *
385      * Emits a {Transfer} event with `to` set to the zero address.
386      *
387      * Requirements:
388      *
389      * - `account` cannot be the zero address.
390      * - `account` must have at least `amount` tokens.
391      */
392     function _burn(address account, uint256 amount) internal virtual {
393         require(account != address(0), "ERC20: burn from the zero address");
394 
395         _beforeTokenTransfer(account, address(0), amount);
396 
397         uint256 accountBalance = _balances[account];
398         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
399         _balances[account] = accountBalance - amount;
400         _totalSupply -= amount;
401 
402         emit Transfer(account, address(0), amount);
403     }
404 
405     /**
406      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
407      *
408      * This internal function is equivalent to `approve`, and can be used to
409      * e.g. set automatic allowances for certain subsystems, etc.
410      *
411      * Emits an {Approval} event.
412      *
413      * Requirements:
414      *
415      * - `owner` cannot be the zero address.
416      * - `spender` cannot be the zero address.
417      */
418     function _approve(address owner, address spender, uint256 amount) internal virtual {
419         require(owner != address(0), "ERC20: approve from the zero address");
420         require(spender != address(0), "ERC20: approve to the zero address");
421 
422         _allowances[owner][spender] = amount;
423         emit Approval(owner, spender, amount);
424     }
425 
426     /**
427      * @dev Hook that is called before any transfer of tokens. This includes
428      * minting and burning.
429      *
430      * Calling conditions:
431      *
432      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
433      * will be to transferred to `to`.
434      * - when `from` is zero, `amount` tokens will be minted for `to`.
435      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
436      * - `from` and `to` are never both zero.
437      *
438      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
439      */
440     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
441 }
442 
443 // File: @openzeppelin/contracts/access/Ownable.sol
444 
445 
446 
447 pragma solidity ^0.8.0;
448 
449 /**
450  * @dev Contract module which provides a basic access control mechanism, where
451  * there is an account (an owner) that can be granted exclusive access to
452  * specific functions.
453  *
454  * By default, the owner account will be the one that deploys the contract. This
455  * can later be changed with {transferOwnership}.
456  *
457  * This module is used through inheritance. It will make available the modifier
458  * `onlyOwner`, which can be applied to your functions to restrict their use to
459  * the owner.
460  */
461 abstract contract Ownable is Context {
462     address private _owner;
463 
464     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
465 
466     /**
467      * @dev Initializes the contract setting the deployer as the initial owner.
468      */
469     constructor () {
470         address msgSender = _msgSender();
471         _owner = msgSender;
472         emit OwnershipTransferred(address(0), msgSender);
473     }
474 
475     /**
476      * @dev Returns the address of the current owner.
477      */
478     function owner() public view virtual returns (address) {
479         return _owner;
480     }
481 
482     /**
483      * @dev Throws if called by any account other than the owner.
484      */
485     modifier onlyOwner() {
486         require(owner() == _msgSender(), "Ownable: caller is not the owner");
487         _;
488     }
489 
490     /**
491      * @dev Leaves the contract without owner. It will not be possible to call
492      * `onlyOwner` functions anymore. Can only be called by the current owner.
493      *
494      * NOTE: Renouncing ownership will leave the contract without an owner,
495      * thereby removing any functionality that is only available to the owner.
496      */
497     function renounceOwnership() public virtual onlyOwner {
498         emit OwnershipTransferred(_owner, address(0));
499         _owner = address(0);
500     }
501 
502     /**
503      * @dev Transfers ownership of the contract to a new account (`newOwner`).
504      * Can only be called by the current owner.
505      */
506     function transferOwnership(address newOwner) public virtual onlyOwner {
507         require(newOwner != address(0), "Ownable: new owner is the zero address");
508         emit OwnershipTransferred(_owner, newOwner);
509         _owner = newOwner;
510     }
511 }
512 
513 // File: @openzeppelin/contracts/security/Pausable.sol
514 
515 
516 
517 pragma solidity ^0.8.0;
518 
519 
520 /**
521  * @dev Contract module which allows children to implement an emergency stop
522  * mechanism that can be triggered by an authorized account.
523  *
524  * This module is used through inheritance. It will make available the
525  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
526  * the functions of your contract. Note that they will not be pausable by
527  * simply including this module, only once the modifiers are put in place.
528  */
529 abstract contract Pausable is Context {
530     /**
531      * @dev Emitted when the pause is triggered by `account`.
532      */
533     event Paused(address account);
534 
535     /**
536      * @dev Emitted when the pause is lifted by `account`.
537      */
538     event Unpaused(address account);
539 
540     bool private _paused;
541 
542     /**
543      * @dev Initializes the contract in unpaused state.
544      */
545     constructor () {
546         _paused = false;
547     }
548 
549     /**
550      * @dev Returns true if the contract is paused, and false otherwise.
551      */
552     function paused() public view virtual returns (bool) {
553         return _paused;
554     }
555 
556     /**
557      * @dev Modifier to make a function callable only when the contract is not paused.
558      *
559      * Requirements:
560      *
561      * - The contract must not be paused.
562      */
563     modifier whenNotPaused() {
564         require(!paused(), "Pausable: paused");
565         _;
566     }
567 
568     /**
569      * @dev Modifier to make a function callable only when the contract is paused.
570      *
571      * Requirements:
572      *
573      * - The contract must be paused.
574      */
575     modifier whenPaused() {
576         require(paused(), "Pausable: not paused");
577         _;
578     }
579 
580     /**
581      * @dev Triggers stopped state.
582      *
583      * Requirements:
584      *
585      * - The contract must not be paused.
586      */
587     function _pause() internal virtual whenNotPaused {
588         _paused = true;
589         emit Paused(_msgSender());
590     }
591 
592     /**
593      * @dev Returns to normal state.
594      *
595      * Requirements:
596      *
597      * - The contract must be paused.
598      */
599     function _unpause() internal virtual whenPaused {
600         _paused = false;
601         emit Unpaused(_msgSender());
602     }
603 }
604 
605 // File: contracts/Memecoin.sol
606 
607 
608 pragma solidity 0.8.0;
609 
610 
611 
612 
613 
614 /**
615 * @title Memecoin token
616 * @dev main ERC20 currency for meme.com contracts
617 */
618 contract Memecoin is Ownable, Pausable, ERC20 {
619 
620   constructor(uint256 _totalSupply, string memory _memeTokenName, string memory _memeTokenSymbol) ERC20(_memeTokenName, _memeTokenSymbol)
621   {
622     _mint(msg.sender, _totalSupply);
623   }
624 
625   /**
626   * @dev See {ERC20-transfer}.
627   * - adds trasfer only when contract is not paused 
628   */
629   function transfer(address recipient, uint256 amount) 
630     public 
631     virtual 
632     override 
633     whenNotPaused 
634     returns (bool) 
635   {
636     return super.transfer(recipient, amount);
637   }
638 
639   /**
640   * @dev See {ERC20-transferFrom}.
641   * - adds trasferForm only when contract is not paused
642   */
643   function transferFrom(address from, address to, uint256 value) 
644     public 
645     virtual 
646     override 
647     whenNotPaused 
648     returns (bool) 
649   {
650     return super.transferFrom(from, to, value);
651   }
652 
653   /**
654   * @dev Allows address to burn a number of coins in its ownership
655   * @param _amount Amount of coins to burn
656   */
657   function burn(uint256 _amount) 
658     virtual
659     external 
660     whenNotPaused
661   {    
662     _burn(msg.sender, _amount);
663   }
664 
665   /**
666   * @dev Pause contract
667   */
668   function pause()
669     external
670     onlyOwner
671   {
672     _pause();
673   }
674 
675   /**
676   * @dev Unpoause contract 
677   */
678   function unpause()
679     external
680     onlyOwner
681   {
682     _unpause();     
683   }
684 }