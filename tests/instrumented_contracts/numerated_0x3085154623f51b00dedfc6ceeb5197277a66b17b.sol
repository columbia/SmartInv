1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol
3 
4 
5 
6 pragma solidity ^0.8.0;
7 
8 
9 
10 /**
11  * @dev Contract module which provides a basic access control mechanism, where
12  * there is an account (an owner) that can be granted exclusive access to
13  * specific functions.
14  *
15  * By default, the owner account will be the one that deploys the contract. This
16  * can later be changed with {transferOwnership}.
17  *
18  * This module is used through inheritance. It will make available the modifier
19  * `onlyOwner`, which can be applied to your functions to restrict their use to
20  * the owner.
21  */
22 
23 // File: @openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol
24 
25 
26 
27 pragma solidity ^0.8.0;
28 
29 /**
30  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
31  * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
32  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
33  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
34  *
35  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
36  * possible by providing the encoded function call as the `_data` argument to {ERC1967Proxy-constructor}.
37  *
38  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
39  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
40  */
41 abstract contract Initializable {
42     /**
43      * @dev Indicates that the contract has been initialized.
44      */
45     bool private _initialized;
46 
47     /**
48      * @dev Indicates that the contract is in the process of being initialized.
49      */
50     bool private _initializing;
51 
52     /**
53      * @dev Modifier to protect an initializer function from being invoked twice.
54      */
55     modifier initializer() {
56         require(_initializing || !_initialized, "Initializable: contract is already initialized");
57 
58         bool isTopLevelCall = !_initializing;
59         if (isTopLevelCall) {
60             _initializing = true;
61             _initialized = true;
62         }
63 
64         _;
65 
66         if (isTopLevelCall) {
67             _initializing = false;
68         }
69     }
70 }
71 
72 // File: @openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol
73 
74 
75 
76 pragma solidity ^0.8.0;
77 
78 
79 /**
80  * @dev Provides information about the current execution context, including the
81  * sender of the transaction and its data. While these are generally available
82  * via msg.sender and msg.data, they should not be accessed in such a direct
83  * manner, since when dealing with meta-transactions the account sending and
84  * paying for execution may not be the actual sender (as far as an application
85  * is concerned).
86  *
87  * This contract is only required for intermediate, library-like contracts.
88  */
89 abstract contract ContextUpgradeable is Initializable {
90     function __Context_init() internal initializer {
91         __Context_init_unchained();
92     }
93 
94     function __Context_init_unchained() internal initializer {
95     }
96     function _msgSender() internal view virtual returns (address) {
97         return msg.sender;
98     }
99 
100     function _msgData() internal view virtual returns (bytes calldata) {
101         return msg.data;
102     }
103     uint256[50] private __gap;
104 }
105 
106 // File: @openzeppelin/contracts-upgradeable/token/ERC20/extensions/IERC20MetadataUpgradeable.sol
107 
108 
109 abstract contract OwnableUpgradeable is Initializable, ContextUpgradeable {
110     address private _owner;
111 
112     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
113 
114     /**
115      * @dev Initializes the contract setting the deployer as the initial owner.
116      */
117     function __Ownable_init() internal initializer {
118         __Context_init_unchained();
119         __Ownable_init_unchained();
120     }
121 
122     function __Ownable_init_unchained() internal initializer {
123         _setOwner(_msgSender());
124     }
125 
126     /**
127      * @dev Returns the address of the current owner.
128      */
129     function owner() public view virtual returns (address) {
130         return _owner;
131     }
132 
133     /**
134      * @dev Throws if called by any account other than the owner.
135      */
136     modifier onlyOwner() {
137         require(owner() == _msgSender(), "Ownable: caller is not the owner");
138         _;
139     }
140 
141     /**
142      * @dev Leaves the contract without owner. It will not be possible to call
143      * `onlyOwner` functions anymore. Can only be called by the current owner.
144      *
145      * NOTE: Renouncing ownership will leave the contract without an owner,
146      * thereby removing any functionality that is only available to the owner.
147      */
148     function renounceOwnership() public virtual onlyOwner {
149         _setOwner(address(0));
150     }
151 
152     /**
153      * @dev Transfers ownership of the contract to a new account (`newOwner`).
154      * Can only be called by the current owner.
155      */
156     function transferOwnership(address newOwner) public virtual onlyOwner {
157         require(newOwner != address(0), "Ownable: new owner is the zero address");
158         _setOwner(newOwner);
159     }
160 
161     function _setOwner(address newOwner) private {
162         address oldOwner = _owner;
163         _owner = newOwner;
164         emit OwnershipTransferred(oldOwner, newOwner);
165     }
166     uint256[49] private __gap;
167 }
168 
169 pragma solidity ^0.8.0;
170 
171 
172 /**
173  * @dev Interface for the optional metadata functions from the ERC20 standard.
174  *
175  * _Available since v4.1._
176  */
177 
178 
179 
180 pragma solidity ^0.8.0;
181 
182 /**
183  * @dev Interface of the ERC20 standard as defined in the EIP.
184  */
185 interface IERC20Upgradeable {
186     /**
187      * @dev Returns the amount of tokens in existence.
188      */
189     function totalSupply() external view returns (uint256);
190 
191     /**
192      * @dev Returns the amount of tokens owned by `account`.
193      */
194     function balanceOf(address account) external view returns (uint256);
195 
196     /**
197      * @dev Moves `amount` tokens from the caller's account to `recipient`.
198      *
199      * Returns a boolean value indicating whether the operation succeeded.
200      *
201      * Emits a {Transfer} event.
202      */
203     function transfer(address recipient, uint256 amount) external returns (bool);
204 
205     /**
206      * @dev Returns the remaining number of tokens that `spender` will be
207      * allowed to spend on behalf of `owner` through {transferFrom}. This is
208      * zero by default.
209      *
210      * This value changes when {approve} or {transferFrom} are called.
211      */
212     function allowance(address owner, address spender) external view returns (uint256);
213 
214     /**
215      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
216      *
217      * Returns a boolean value indicating whether the operation succeeded.
218      *
219      * IMPORTANT: Beware that changing an allowance with this method brings the risk
220      * that someone may use both the old and the new allowance by unfortunate
221      * transaction ordering. One possible solution to mitigate this race
222      * condition is to first reduce the spender's allowance to 0 and set the
223      * desired value afterwards:
224      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
225      *
226      * Emits an {Approval} event.
227      */
228     function approve(address spender, uint256 amount) external returns (bool);
229 
230     /**
231      * @dev Moves `amount` tokens from `sender` to `recipient` using the
232      * allowance mechanism. `amount` is then deducted from the caller's
233      * allowance.
234      *
235      * Returns a boolean value indicating whether the operation succeeded.
236      *
237      * Emits a {Transfer} event.
238      */
239     function transferFrom(
240         address sender,
241         address recipient,
242         uint256 amount
243     ) external returns (bool);
244 
245     /**
246      * @dev Emitted when `value` tokens are moved from one account (`from`) to
247      * another (`to`).
248      *
249      * Note that `value` may be zero.
250      */
251     event Transfer(address indexed from, address indexed to, uint256 value);
252 
253     /**
254      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
255      * a call to {approve}. `value` is the new allowance.
256      */
257     event Approval(address indexed owner, address indexed spender, uint256 value);
258 }
259 
260 // File: @openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol
261 
262 interface IERC20MetadataUpgradeable is IERC20Upgradeable {
263     /**
264      * @dev Returns the name of the token.
265      */
266     function name() external view returns (string memory);
267 
268     /**
269      * @dev Returns the symbol of the token.
270      */
271     function symbol() external view returns (string memory);
272 
273     /**
274      * @dev Returns the decimals places of the token.
275      */
276     function decimals() external view returns (uint8);
277 }
278 
279 // File: @openzeppelin/contracts-upgradeable/token/ERC20/IERC20Upgradeable.sol
280 
281 
282 
283 pragma solidity ^0.8.0;
284 
285 
286 
287 
288 
289 /**
290  * @dev Implementation of the {IERC20} interface.
291  *
292  * This implementation is agnostic to the way tokens are created. This means
293  * that a supply mechanism has to be added in a derived contract using {_mint}.
294  * For a generic mechanism see {ERC20PresetMinterPauser}.
295  *
296  * TIP: For a detailed writeup see our guide
297  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
298  * to implement supply mechanisms].
299  *
300  * We have followed general OpenZeppelin Contracts guidelines: functions revert
301  * instead returning `false` on failure. This behavior is nonetheless
302  * conventional and does not conflict with the expectations of ERC20
303  * applications.
304  *
305  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
306  * This allows applications to reconstruct the allowance for all accounts just
307  * by listening to said events. Other implementations of the EIP may not emit
308  * these events, as it isn't required by the specification.
309  *
310  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
311  * functions have been added to mitigate the well-known issues around setting
312  * allowances. See {IERC20-approve}.
313  */
314 contract ERC20Upgradeable is Initializable, ContextUpgradeable, IERC20Upgradeable, IERC20MetadataUpgradeable {
315     mapping(address => uint256) private _balances;
316 
317     mapping(address => mapping(address => uint256)) private _allowances;
318 
319     uint256 private _totalSupply;
320 
321     string private _name;
322     string private _symbol;
323 
324     /**
325      * @dev Sets the values for {name} and {symbol}.
326      *
327      * The default value of {decimals} is 18. To select a different value for
328      * {decimals} you should overload it.
329      *
330      * All two of these values are immutable: they can only be set once during
331      * construction.
332      */
333     function __ERC20_init(string memory name_, string memory symbol_) internal initializer {
334         __Context_init_unchained();
335         __ERC20_init_unchained(name_, symbol_);
336     }
337 
338     function __ERC20_init_unchained(string memory name_, string memory symbol_) internal initializer {
339         _name = name_;
340         _symbol = symbol_;
341     }
342 
343     /**
344      * @dev Returns the name of the token.
345      */
346     function name() public view virtual override returns (string memory) {
347         return _name;
348     }
349 
350     /**
351      * @dev Returns the symbol of the token, usually a shorter version of the
352      * name.
353      */
354     function symbol() public view virtual override returns (string memory) {
355         return _symbol;
356     }
357 
358     /**
359      * @dev Returns the number of decimals used to get its user representation.
360      * For example, if `decimals` equals `2`, a balance of `505` tokens should
361      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
362      *
363      * Tokens usually opt for a value of 18, imitating the relationship between
364      * Ether and Wei. This is the value {ERC20} uses, unless this function is
365      * overridden;
366      *
367      * NOTE: This information is only used for _display_ purposes: it in
368      * no way affects any of the arithmetic of the contract, including
369      * {IERC20-balanceOf} and {IERC20-transfer}.
370      */
371     function decimals() public view virtual override returns (uint8) {
372         return 18;
373     }
374 
375     /**
376      * @dev See {IERC20-totalSupply}.
377      */
378     function totalSupply() public view virtual override returns (uint256) {
379         return _totalSupply;
380     }
381 
382     /**
383      * @dev See {IERC20-balanceOf}.
384      */
385     function balanceOf(address account) public view virtual override returns (uint256) {
386         return _balances[account];
387     }
388 
389     /**
390      * @dev See {IERC20-transfer}.
391      *
392      * Requirements:
393      *
394      * - `recipient` cannot be the zero address.
395      * - the caller must have a balance of at least `amount`.
396      */
397     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
398         _transfer(_msgSender(), recipient, amount);
399         return true;
400     }
401 
402     /**
403      * @dev See {IERC20-allowance}.
404      */
405     function allowance(address owner, address spender) public view virtual override returns (uint256) {
406         return _allowances[owner][spender];
407     }
408 
409     /**
410      * @dev See {IERC20-approve}.
411      *
412      * Requirements:
413      *
414      * - `spender` cannot be the zero address.
415      */
416     function approve(address spender, uint256 amount) public virtual override returns (bool) {
417         _approve(_msgSender(), spender, amount);
418         return true;
419     }
420 
421     /**
422      * @dev See {IERC20-transferFrom}.
423      *
424      * Emits an {Approval} event indicating the updated allowance. This is not
425      * required by the EIP. See the note at the beginning of {ERC20}.
426      *
427      * Requirements:
428      *
429      * - `sender` and `recipient` cannot be the zero address.
430      * - `sender` must have a balance of at least `amount`.
431      * - the caller must have allowance for ``sender``'s tokens of at least
432      * `amount`.
433      */
434     function transferFrom(
435         address sender,
436         address recipient,
437         uint256 amount
438     ) public virtual override returns (bool) {
439         _transfer(sender, recipient, amount);
440 
441         uint256 currentAllowance = _allowances[sender][_msgSender()];
442         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
443         unchecked {
444             _approve(sender, _msgSender(), currentAllowance - amount);
445         }
446 
447         return true;
448     }
449 
450     /**
451      * @dev Atomically increases the allowance granted to `spender` by the caller.
452      *
453      * This is an alternative to {approve} that can be used as a mitigation for
454      * problems described in {IERC20-approve}.
455      *
456      * Emits an {Approval} event indicating the updated allowance.
457      *
458      * Requirements:
459      *
460      * - `spender` cannot be the zero address.
461      */
462     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
463         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
464         return true;
465     }
466 
467     /**
468      * @dev Atomically decreases the allowance granted to `spender` by the caller.
469      *
470      * This is an alternative to {approve} that can be used as a mitigation for
471      * problems described in {IERC20-approve}.
472      *
473      * Emits an {Approval} event indicating the updated allowance.
474      *
475      * Requirements:
476      *
477      * - `spender` cannot be the zero address.
478      * - `spender` must have allowance for the caller of at least
479      * `subtractedValue`.
480      */
481     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
482         uint256 currentAllowance = _allowances[_msgSender()][spender];
483         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
484         unchecked {
485             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
486         }
487 
488         return true;
489     }
490 
491     /**
492      * @dev Moves `amount` of tokens from `sender` to `recipient`.
493      *
494      * This internal function is equivalent to {transfer}, and can be used to
495      * e.g. implement automatic token fees, slashing mechanisms, etc.
496      *
497      * Emits a {Transfer} event.
498      *
499      * Requirements:
500      *
501      * - `sender` cannot be the zero address.
502      * - `recipient` cannot be the zero address.
503      * - `sender` must have a balance of at least `amount`.
504      */
505     function _transfer(
506         address sender,
507         address recipient,
508         uint256 amount
509     ) internal virtual {
510         require(sender != address(0), "ERC20: transfer from the zero address");
511         require(recipient != address(0), "ERC20: transfer to the zero address");
512 
513         _beforeTokenTransfer(sender, recipient, amount);
514 
515         uint256 senderBalance = _balances[sender];
516         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
517         unchecked {
518             _balances[sender] = senderBalance - amount;
519         }
520         _balances[recipient] += amount;
521 
522         emit Transfer(sender, recipient, amount);
523 
524         _afterTokenTransfer(sender, recipient, amount);
525     }
526 
527     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
528      * the total supply.
529      *
530      * Emits a {Transfer} event with `from` set to the zero address.
531      *
532      * Requirements:
533      *
534      * - `account` cannot be the zero address.
535      */
536     function _mint(address account, uint256 amount) internal virtual {
537         require(account != address(0), "ERC20: mint to the zero address");
538 
539         _beforeTokenTransfer(address(0), account, amount);
540 
541         _totalSupply += amount;
542         _balances[account] += amount;
543         emit Transfer(address(0), account, amount);
544 
545         _afterTokenTransfer(address(0), account, amount);
546     }
547 
548     /**
549      * @dev Destroys `amount` tokens from `account`, reducing the
550      * total supply.
551      *
552      * Emits a {Transfer} event with `to` set to the zero address.
553      *
554      * Requirements:
555      *
556      * - `account` cannot be the zero address.
557      * - `account` must have at least `amount` tokens.
558      */
559     function _burn(address account, uint256 amount) internal virtual {
560         require(account != address(0), "ERC20: burn from the zero address");
561 
562         _beforeTokenTransfer(account, address(0), amount);
563 
564         uint256 accountBalance = _balances[account];
565         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
566         unchecked {
567             _balances[account] = accountBalance - amount;
568         }
569         _totalSupply -= amount;
570 
571         emit Transfer(account, address(0), amount);
572 
573         _afterTokenTransfer(account, address(0), amount);
574     }
575 
576     /**
577      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
578      *
579      * This internal function is equivalent to `approve`, and can be used to
580      * e.g. set automatic allowances for certain subsystems, etc.
581      *
582      * Emits an {Approval} event.
583      *
584      * Requirements:
585      *
586      * - `owner` cannot be the zero address.
587      * - `spender` cannot be the zero address.
588      */
589     function _approve(
590         address owner,
591         address spender,
592         uint256 amount
593     ) internal virtual {
594         require(owner != address(0), "ERC20: approve from the zero address");
595         require(spender != address(0), "ERC20: approve to the zero address");
596 
597         _allowances[owner][spender] = amount;
598         emit Approval(owner, spender, amount);
599     }
600 
601     /**
602      * @dev Hook that is called before any transfer of tokens. This includes
603      * minting and burning.
604      *
605      * Calling conditions:
606      *
607      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
608      * will be transferred to `to`.
609      * - when `from` is zero, `amount` tokens will be minted for `to`.
610      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
611      * - `from` and `to` are never both zero.
612      *
613      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
614      */
615     function _beforeTokenTransfer(
616         address from,
617         address to,
618         uint256 amount
619     ) internal virtual {}
620 
621     /**
622      * @dev Hook that is called after any transfer of tokens. This includes
623      * minting and burning.
624      *
625      * Calling conditions:
626      *
627      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
628      * has been transferred to `to`.
629      * - when `from` is zero, `amount` tokens have been minted for `to`.
630      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
631      * - `from` and `to` are never both zero.
632      *
633      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
634      */
635     function _afterTokenTransfer(
636         address from,
637         address to,
638         uint256 amount
639     ) internal virtual {}
640     uint256[45] private __gap;
641 }
642 
643 // File: scripts/NFTYToken.sol
644 
645 
646 pragma solidity ^0.8.0;
647 
648 
649 
650 contract NFTYToken is ERC20Upgradeable, OwnableUpgradeable {
651     function initialize() public initializer {
652         __ERC20_init("NFTY Token", "NFTY");
653         __Ownable_init();
654         _mint(owner(), 5000000 * 10**uint256(decimals()));
655     }
656 
657     function mint(address account, uint256 amount) external onlyOwner {
658         _mint(account, amount);
659     }
660 }