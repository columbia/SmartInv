1 pragma solidity ^0.8.0;
2 
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes calldata) {
10         return msg.data;
11     }
12 }
13 
14 
15 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.0
16 
17 
18 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
19 
20 pragma solidity ^0.8.0;
21 
22 /**
23  * @dev Contract module which provides a basic access control mechanism, where
24  * there is an account (an owner) that can be granted exclusive access to
25  * specific functions.
26  *
27  * By default, the owner account will be the one that deploys the contract. This
28  * can later be changed with {transferOwnership}.
29  *
30  * This module is used through inheritance. It will make available the modifier
31  * `onlyOwner`, which can be applied to your functions to restrict their use to
32  * the owner.
33  */
34 abstract contract Ownable is Context {
35     address private _owner;
36 
37     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
38 
39     /**
40      * @dev Initializes the contract setting the deployer as the initial owner.
41      */
42     constructor() {
43         _transferOwnership(_msgSender());
44     }
45 
46     /**
47      * @dev Returns the address of the current owner.
48      */
49     function owner() public view virtual returns (address) {
50         return _owner;
51     }
52 
53     /**
54      * @dev Throws if called by any account other than the owner.
55      */
56     modifier onlyOwner() {
57         require(owner() == _msgSender(), "Ownable: caller is not the owner");
58         _;
59     }
60 
61     /**
62      * @dev Leaves the contract without owner. It will not be possible to call
63      * `onlyOwner` functions anymore. Can only be called by the current owner.
64      *
65      * NOTE: Renouncing ownership will leave the contract without an owner,
66      * thereby removing any functionality that is only available to the owner.
67      */
68     function renounceOwnership() public virtual onlyOwner {
69         _transferOwnership(address(0));
70     }
71 
72     /**
73      * @dev Transfers ownership of the contract to a new account (`newOwner`).
74      * Can only be called by the current owner.
75      */
76     function transferOwnership(address newOwner) public virtual onlyOwner {
77         require(newOwner != address(0), "Ownable: new owner is the zero address");
78         _transferOwnership(newOwner);
79     }
80 
81     /**
82      * @dev Transfers ownership of the contract to a new account (`newOwner`).
83      * Internal function without access restriction.
84      */
85     function _transferOwnership(address newOwner) internal virtual {
86         address oldOwner = _owner;
87         _owner = newOwner;
88         emit OwnershipTransferred(oldOwner, newOwner);
89     }
90 }
91 
92 
93 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.4.0
94 
95 
96 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
97 
98 pragma solidity ^0.8.0;
99 
100 /**
101  * @dev Interface of the ERC20 standard as defined in the EIP.
102  */
103 interface IERC20 {
104     /**
105      * @dev Returns the amount of tokens in existence.
106      */
107     function totalSupply() external view returns (uint256);
108 
109     /**
110      * @dev Returns the amount of tokens owned by `account`.
111      */
112     function balanceOf(address account) external view returns (uint256);
113 
114     /**
115      * @dev Moves `amount` tokens from the caller's account to `recipient`.
116      *
117      * Returns a boolean value indicating whether the operation succeeded.
118      *
119      * Emits a {Transfer} event.
120      */
121     function transfer(address recipient, uint256 amount) external returns (bool);
122 
123     /**
124      * @dev Returns the remaining number of tokens that `spender` will be
125      * allowed to spend on behalf of `owner` through {transferFrom}. This is
126      * zero by default.
127      *
128      * This value changes when {approve} or {transferFrom} are called.
129      */
130     function allowance(address owner, address spender) external view returns (uint256);
131 
132     /**
133      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
134      *
135      * Returns a boolean value indicating whether the operation succeeded.
136      *
137      * IMPORTANT: Beware that changing an allowance with this method brings the risk
138      * that someone may use both the old and the new allowance by unfortunate
139      * transaction ordering. One possible solution to mitigate this race
140      * condition is to first reduce the spender's allowance to 0 and set the
141      * desired value afterwards:
142      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
143      *
144      * Emits an {Approval} event.
145      */
146     function approve(address spender, uint256 amount) external returns (bool);
147 
148     /**
149      * @dev Moves `amount` tokens from `sender` to `recipient` using the
150      * allowance mechanism. `amount` is then deducted from the caller's
151      * allowance.
152      *
153      * Returns a boolean value indicating whether the operation succeeded.
154      *
155      * Emits a {Transfer} event.
156      */
157     function transferFrom(
158         address sender,
159         address recipient,
160         uint256 amount
161     ) external returns (bool);
162 
163     /**
164      * @dev Emitted when `value` tokens are moved from one account (`from`) to
165      * another (`to`).
166      *
167      * Note that `value` may be zero.
168      */
169     event Transfer(address indexed from, address indexed to, uint256 value);
170 
171     /**
172      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
173      * a call to {approve}. `value` is the new allowance.
174      */
175     event Approval(address indexed owner, address indexed spender, uint256 value);
176 }
177 
178 
179 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.4.0
180 
181 
182 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
183 
184 pragma solidity ^0.8.0;
185 
186 /**
187  * @dev Interface for the optional metadata functions from the ERC20 standard.
188  *
189  * _Available since v4.1._
190  */
191 interface IERC20Metadata is IERC20 {
192     /**
193      * @dev Returns the name of the token.
194      */
195     function name() external view returns (string memory);
196 
197     /**
198      * @dev Returns the symbol of the token.
199      */
200     function symbol() external view returns (string memory);
201 
202     /**
203      * @dev Returns the decimals places of the token.
204      */
205     function decimals() external view returns (uint8);
206 }
207 
208 
209 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.4.0
210 
211 
212 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
213 
214 pragma solidity ^0.8.0;
215 
216 
217 
218 /**
219  * @dev Implementation of the {IERC20} interface.
220  *
221  * This implementation is agnostic to the way tokens are created. This means
222  * that a supply mechanism has to be added in a derived contract using {_mint}.
223  * For a generic mechanism see {ERC20PresetMinterPauser}.
224  *
225  * TIP: For a detailed writeup see our guide
226  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
227  * to implement supply mechanisms].
228  *
229  * We have followed general OpenZeppelin Contracts guidelines: functions revert
230  * instead returning `false` on failure. This behavior is nonetheless
231  * conventional and does not conflict with the expectations of ERC20
232  * applications.
233  *
234  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
235  * This allows applications to reconstruct the allowance for all accounts just
236  * by listening to said events. Other implementations of the EIP may not emit
237  * these events, as it isn't required by the specification.
238  *
239  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
240  * functions have been added to mitigate the well-known issues around setting
241  * allowances. See {IERC20-approve}.
242  */
243 contract ERC20 is Context, IERC20, IERC20Metadata {
244     mapping(address => uint256) private _balances;
245 
246     mapping(address => mapping(address => uint256)) private _allowances;
247 
248     uint256 private _totalSupply;
249 
250     string private _name;
251     string private _symbol;
252 
253     /**
254      * @dev Sets the values for {name} and {symbol}.
255      *
256      * The default value of {decimals} is 18. To select a different value for
257      * {decimals} you should overload it.
258      *
259      * All two of these values are immutable: they can only be set once during
260      * construction.
261      */
262     constructor(string memory name_, string memory symbol_) {
263         _name = name_;
264         _symbol = symbol_;
265     }
266 
267     /**
268      * @dev Returns the name of the token.
269      */
270     function name() public view virtual override returns (string memory) {
271         return _name;
272     }
273 
274     /**
275      * @dev Returns the symbol of the token, usually a shorter version of the
276      * name.
277      */
278     function symbol() public view virtual override returns (string memory) {
279         return _symbol;
280     }
281 
282     /**
283      * @dev Returns the number of decimals used to get its user representation.
284      * For example, if `decimals` equals `2`, a balance of `505` tokens should
285      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
286      *
287      * Tokens usually opt for a value of 18, imitating the relationship between
288      * Ether and Wei. This is the value {ERC20} uses, unless this function is
289      * overridden;
290      *
291      * NOTE: This information is only used for _display_ purposes: it in
292      * no way affects any of the arithmetic of the contract, including
293      * {IERC20-balanceOf} and {IERC20-transfer}.
294      */
295     function decimals() public view virtual override returns (uint8) {
296         return 18;
297     }
298 
299     /**
300      * @dev See {IERC20-totalSupply}.
301      */
302     function totalSupply() public view virtual override returns (uint256) {
303         return _totalSupply;
304     }
305 
306     /**
307      * @dev See {IERC20-balanceOf}.
308      */
309     function balanceOf(address account) public view virtual override returns (uint256) {
310         return _balances[account];
311     }
312 
313     /**
314      * @dev See {IERC20-transfer}.
315      *
316      * Requirements:
317      *
318      * - `recipient` cannot be the zero address.
319      * - the caller must have a balance of at least `amount`.
320      */
321     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
322         _transfer(_msgSender(), recipient, amount);
323         return true;
324     }
325 
326     /**
327      * @dev See {IERC20-allowance}.
328      */
329     function allowance(address owner, address spender) public view virtual override returns (uint256) {
330         return _allowances[owner][spender];
331     }
332 
333     /**
334      * @dev See {IERC20-approve}.
335      *
336      * Requirements:
337      *
338      * - `spender` cannot be the zero address.
339      */
340     function approve(address spender, uint256 amount) public virtual override returns (bool) {
341         _approve(_msgSender(), spender, amount);
342         return true;
343     }
344 
345     /**
346      * @dev See {IERC20-transferFrom}.
347      *
348      * Emits an {Approval} event indicating the updated allowance. This is not
349      * required by the EIP. See the note at the beginning of {ERC20}.
350      *
351      * Requirements:
352      *
353      * - `sender` and `recipient` cannot be the zero address.
354      * - `sender` must have a balance of at least `amount`.
355      * - the caller must have allowance for ``sender``'s tokens of at least
356      * `amount`.
357      */
358     function transferFrom(
359         address sender,
360         address recipient,
361         uint256 amount
362     ) public virtual override returns (bool) {
363         _transfer(sender, recipient, amount);
364 
365         uint256 currentAllowance = _allowances[sender][_msgSender()];
366         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
367         unchecked {
368             _approve(sender, _msgSender(), currentAllowance - amount);
369         }
370 
371         return true;
372     }
373 
374     /**
375      * @dev Atomically increases the allowance granted to `spender` by the caller.
376      *
377      * This is an alternative to {approve} that can be used as a mitigation for
378      * problems described in {IERC20-approve}.
379      *
380      * Emits an {Approval} event indicating the updated allowance.
381      *
382      * Requirements:
383      *
384      * - `spender` cannot be the zero address.
385      */
386     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
387         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
388         return true;
389     }
390 
391     /**
392      * @dev Atomically decreases the allowance granted to `spender` by the caller.
393      *
394      * This is an alternative to {approve} that can be used as a mitigation for
395      * problems described in {IERC20-approve}.
396      *
397      * Emits an {Approval} event indicating the updated allowance.
398      *
399      * Requirements:
400      *
401      * - `spender` cannot be the zero address.
402      * - `spender` must have allowance for the caller of at least
403      * `subtractedValue`.
404      */
405     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
406         uint256 currentAllowance = _allowances[_msgSender()][spender];
407         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
408         unchecked {
409             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
410         }
411 
412         return true;
413     }
414 
415     /**
416      * @dev Moves `amount` of tokens from `sender` to `recipient`.
417      *
418      * This internal function is equivalent to {transfer}, and can be used to
419      * e.g. implement automatic token fees, slashing mechanisms, etc.
420      *
421      * Emits a {Transfer} event.
422      *
423      * Requirements:
424      *
425      * - `sender` cannot be the zero address.
426      * - `recipient` cannot be the zero address.
427      * - `sender` must have a balance of at least `amount`.
428      */
429     function _transfer(
430         address sender,
431         address recipient,
432         uint256 amount
433     ) internal virtual {
434         require(sender != address(0), "ERC20: transfer from the zero address");
435         require(recipient != address(0), "ERC20: transfer to the zero address");
436 
437         _beforeTokenTransfer(sender, recipient, amount);
438 
439         uint256 senderBalance = _balances[sender];
440         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
441         unchecked {
442             _balances[sender] = senderBalance - amount;
443         }
444         _balances[recipient] += amount;
445 
446         emit Transfer(sender, recipient, amount);
447 
448         _afterTokenTransfer(sender, recipient, amount);
449     }
450 
451     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
452      * the total supply.
453      *
454      * Emits a {Transfer} event with `from` set to the zero address.
455      *
456      * Requirements:
457      *
458      * - `account` cannot be the zero address.
459      */
460     function _mint(address account, uint256 amount) internal virtual {
461         require(account != address(0), "ERC20: mint to the zero address");
462 
463         _beforeTokenTransfer(address(0), account, amount);
464 
465         _totalSupply += amount;
466         _balances[account] += amount;
467         emit Transfer(address(0), account, amount);
468 
469         _afterTokenTransfer(address(0), account, amount);
470     }
471 
472     /**
473      * @dev Destroys `amount` tokens from `account`, reducing the
474      * total supply.
475      *
476      * Emits a {Transfer} event with `to` set to the zero address.
477      *
478      * Requirements:
479      *
480      * - `account` cannot be the zero address.
481      * - `account` must have at least `amount` tokens.
482      */
483     function _burn(address account, uint256 amount) internal virtual {
484         require(account != address(0), "ERC20: burn from the zero address");
485 
486         _beforeTokenTransfer(account, address(0), amount);
487 
488         uint256 accountBalance = _balances[account];
489         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
490         unchecked {
491             _balances[account] = accountBalance - amount;
492         }
493         _totalSupply -= amount;
494 
495         emit Transfer(account, address(0), amount);
496 
497         _afterTokenTransfer(account, address(0), amount);
498     }
499 
500     /**
501      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
502      *
503      * This internal function is equivalent to `approve`, and can be used to
504      * e.g. set automatic allowances for certain subsystems, etc.
505      *
506      * Emits an {Approval} event.
507      *
508      * Requirements:
509      *
510      * - `owner` cannot be the zero address.
511      * - `spender` cannot be the zero address.
512      */
513     function _approve(
514         address owner,
515         address spender,
516         uint256 amount
517     ) internal virtual {
518         require(owner != address(0), "ERC20: approve from the zero address");
519         require(spender != address(0), "ERC20: approve to the zero address");
520 
521         _allowances[owner][spender] = amount;
522         emit Approval(owner, spender, amount);
523     }
524 
525     /**
526      * @dev Hook that is called before any transfer of tokens. This includes
527      * minting and burning.
528      *
529      * Calling conditions:
530      *
531      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
532      * will be transferred to `to`.
533      * - when `from` is zero, `amount` tokens will be minted for `to`.
534      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
535      * - `from` and `to` are never both zero.
536      *
537      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
538      */
539     function _beforeTokenTransfer(
540         address from,
541         address to,
542         uint256 amount
543     ) internal virtual {}
544 
545     /**
546      * @dev Hook that is called after any transfer of tokens. This includes
547      * minting and burning.
548      *
549      * Calling conditions:
550      *
551      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
552      * has been transferred to `to`.
553      * - when `from` is zero, `amount` tokens have been minted for `to`.
554      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
555      * - `from` and `to` are never both zero.
556      *
557      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
558      */
559     function _afterTokenTransfer(
560         address from,
561         address to,
562         uint256 amount
563     ) internal virtual {}
564 }
565 
566 
567 
568 
569 
570 
571 pragma solidity ^0.8.0;
572 
573 
574 contract Chudcoin is Ownable, ERC20 {
575     bool public limited;
576     uint256 public maxHoldingAmount;
577     uint256 public minHoldingAmount;
578     address public uniswapV2Pair;
579     mapping(address => bool) public blacklists;
580 
581     constructor(uint256 _totalSupply) ERC20("ChudCoin", "CHUD") {
582         _mint(msg.sender, _totalSupply);
583     }
584 
585     function blacklist(address _address, bool _isBlacklisting) external onlyOwner {
586         blacklists[_address] = _isBlacklisting;
587     }
588 
589     function setRule(bool _limited, address _uniswapV2Pair, uint256 _maxHoldingAmount, uint256 _minHoldingAmount) external onlyOwner {
590         limited = _limited;
591         uniswapV2Pair = _uniswapV2Pair;
592         maxHoldingAmount = _maxHoldingAmount;
593         minHoldingAmount = _minHoldingAmount;
594     }
595 
596     function _beforeTokenTransfer(
597         address from,
598         address to,
599         uint256 amount
600     ) override internal virtual {
601         require(!blacklists[to] && !blacklists[from], "Blacklisted");
602 
603         if (uniswapV2Pair == address(0)) {
604             require(from == owner() || to == owner(), "trading is not started");
605             return;
606         }
607 
608         if (limited && from == uniswapV2Pair) {
609             require(super.balanceOf(to) + amount <= maxHoldingAmount && super.balanceOf(to) + amount >= minHoldingAmount, "Forbid");
610         }
611     }
612 
613     function burn(uint256 value) external {
614         _burn(msg.sender, value);
615     }
616 }