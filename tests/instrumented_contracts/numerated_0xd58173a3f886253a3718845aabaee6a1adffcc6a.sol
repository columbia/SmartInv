1 /* 
2 
3 The Elon Tide Pod Harambe 69 Inu Project
4 
5 Imagine telling your coworkers you're quitting because ElonTidePodHarambe69Inu coin mooned?
6 
7 https://t.me/ETH69Inu
8 https://twitter.com/ETH69Inu
9 
10 */
11 
12 // File @openzeppelin/contracts/utils/Context.sol@v4.4.0
13 
14 // SPDX-License-Identifier: MIT
15 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
16 
17 pragma solidity ^0.8.0;
18 
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
29 
30 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.0
31 
32 
33 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
34 
35 pragma solidity ^0.8.0;
36 
37 abstract contract Ownable is Context {
38     address private _owner;
39 
40     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42     /**
43      * @dev Initializes the contract setting the deployer as the initial owner.
44      */
45     constructor() {
46         _transferOwnership(_msgSender());
47     }
48 
49     /**
50      * @dev Returns the address of the current owner.
51      */
52     function owner() public view virtual returns (address) {
53         return _owner;
54     }
55 
56     /**
57      * @dev Throws if called by any account other than the owner.
58      */
59     modifier onlyOwner() {
60         require(owner() == _msgSender(), "Ownable: caller is not the owner");
61         _;
62     }
63 
64     /**
65      * @dev Leaves the contract without owner. It will not be possible to call
66      * `onlyOwner` functions anymore. Can only be called by the current owner.
67      *
68      * NOTE: Renouncing ownership will leave the contract without an owner,
69      * thereby removing any functionality that is only available to the owner.
70      */
71     function renounceOwnership() public virtual onlyOwner {
72         _transferOwnership(address(0));
73     }
74 
75     /**
76      * @dev Transfers ownership of the contract to a new account (`newOwner`).
77      * Can only be called by the current owner.
78      */
79     function transferOwnership(address newOwner) public virtual onlyOwner {
80         require(newOwner != address(0), "Ownable: new owner is the zero address");
81         _transferOwnership(newOwner);
82     }
83 
84     /**
85      * @dev Transfers ownership of the contract to a new account (`newOwner`).
86      * Internal function without access restriction.
87      */
88     function _transferOwnership(address newOwner) internal virtual {
89         address oldOwner = _owner;
90         _owner = newOwner;
91         emit OwnershipTransferred(oldOwner, newOwner);
92     }
93 }
94 
95 
96 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.4.0
97 
98 
99 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
100 
101 pragma solidity ^0.8.0;
102 
103 /**
104  * @dev Interface of the ERC20 standard as defined in the EIP.
105  */
106 interface IERC20 {
107     /**
108      * @dev Returns the amount of tokens in existence.
109      */
110     function totalSupply() external view returns (uint256);
111 
112     /**
113      * @dev Returns the amount of tokens owned by `account`.
114      */
115     function balanceOf(address account) external view returns (uint256);
116 
117     /**
118      * @dev Moves `amount` tokens from the caller's account to `recipient`.
119      *
120      * Returns a boolean value indicating whether the operation succeeded.
121      *
122      * Emits a {Transfer} event.
123      */
124     function transfer(address recipient, uint256 amount) external returns (bool);
125 
126     /**
127      * @dev Returns the remaining number of tokens that `spender` will be
128      * allowed to spend on behalf of `owner` through {transferFrom}. This is
129      * zero by default.
130      *
131      * This value changes when {approve} or {transferFrom} are called.
132      */
133     function allowance(address owner, address spender) external view returns (uint256);
134 
135     /**
136      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
137      *
138      * Returns a boolean value indicating whether the operation succeeded.
139      *
140      * IMPORTANT: Beware that changing an allowance with this method brings the risk
141      * that someone may use both the old and the new allowance by unfortunate
142      * transaction ordering. One possible solution to mitigate this race
143      * condition is to first reduce the spender's allowance to 0 and set the
144      * desired value afterwards:
145      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
146      *
147      * Emits an {Approval} event.
148      */
149     function approve(address spender, uint256 amount) external returns (bool);
150 
151     /**
152      * @dev Moves `amount` tokens from `sender` to `recipient` using the
153      * allowance mechanism. `amount` is then deducted from the caller's
154      * allowance.
155      *
156      * Returns a boolean value indicating whether the operation succeeded.
157      *
158      * Emits a {Transfer} event.
159      */
160     function transferFrom(
161         address sender,
162         address recipient,
163         uint256 amount
164     ) external returns (bool);
165 
166     /**
167      * @dev Emitted when `value` tokens are moved from one account (`from`) to
168      * another (`to`).
169      *
170      * Note that `value` may be zero.
171      */
172     event Transfer(address indexed from, address indexed to, uint256 value);
173 
174     /**
175      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
176      * a call to {approve}. `value` is the new allowance.
177      */
178     event Approval(address indexed owner, address indexed spender, uint256 value);
179 }
180 
181 
182 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.4.0
183 
184 
185 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
186 
187 pragma solidity ^0.8.0;
188 
189 /**
190  * @dev Interface for the optional metadata functions from the ERC20 standard.
191  *
192  * _Available since v4.1._
193  */
194 interface IERC20Metadata is IERC20 {
195     /**
196      * @dev Returns the name of the token.
197      */
198     function name() external view returns (string memory);
199 
200     /**
201      * @dev Returns the symbol of the token.
202      */
203     function symbol() external view returns (string memory);
204 
205     /**
206      * @dev Returns the decimals places of the token.
207      */
208     function decimals() external view returns (uint8);
209 }
210 
211 
212 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.4.0
213 
214 
215 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
216 
217 pragma solidity ^0.8.0;
218 
219 
220 
221 /**
222  * @dev Implementation of the {IERC20} interface.
223  *
224  * This implementation is agnostic to the way tokens are created. This means
225  * that a supply mechanism has to be added in a derived contract using {_mint}.
226  * For a generic mechanism see {ERC20PresetMinterPauser}.
227  *
228  * TIP: For a detailed writeup see our guide
229  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
230  * to implement supply mechanisms].
231  *
232  * We have followed general OpenZeppelin Contracts guidelines: functions revert
233  * instead returning `false` on failure. This behavior is nonetheless
234  * conventional and does not conflict with the expectations of ERC20
235  * applications.
236  *
237  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
238  * This allows applications to reconstruct the allowance for all accounts just
239  * by listening to said events. Other implementations of the EIP may not emit
240  * these events, as it isn't required by the specification.
241  *
242  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
243  * functions have been added to mitigate the well-known issues around setting
244  * allowances. See {IERC20-approve}.
245  */
246 contract ERC20 is Context, IERC20, IERC20Metadata {
247     mapping(address => uint256) private _balances;
248 
249     mapping(address => mapping(address => uint256)) private _allowances;
250 
251     uint256 private _totalSupply;
252 
253     string private _name;
254     string private _symbol;
255 
256     /**
257      * @dev Sets the values for {name} and {symbol}.
258      *
259      * The default value of {decimals} is 18. To select a different value for
260      * {decimals} you should overload it.
261      *
262      * All two of these values are immutable: they can only be set once during
263      * construction.
264      */
265     constructor(string memory name_, string memory symbol_) {
266         _name = name_;
267         _symbol = symbol_;
268     }
269 
270     /**
271      * @dev Returns the name of the token.
272      */
273     function name() public view virtual override returns (string memory) {
274         return _name;
275     }
276 
277     /**
278      * @dev Returns the symbol of the token, usually a shorter version of the
279      * name.
280      */
281     function symbol() public view virtual override returns (string memory) {
282         return _symbol;
283     }
284 
285     /**
286      * @dev Returns the number of decimals used to get its user representation.
287      * For example, if `decimals` equals `2`, a balance of `505` tokens should
288      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
289      *
290      * Tokens usually opt for a value of 18, imitating the relationship between
291      * Ether and Wei. This is the value {ERC20} uses, unless this function is
292      * overridden;
293      *
294      * NOTE: This information is only used for _display_ purposes: it in
295      * no way affects any of the arithmetic of the contract, including
296      * {IERC20-balanceOf} and {IERC20-transfer}.
297      */
298     function decimals() public view virtual override returns (uint8) {
299         return 18;
300     }
301 
302     /**
303      * @dev See {IERC20-totalSupply}.
304      */
305     function totalSupply() public view virtual override returns (uint256) {
306         return _totalSupply;
307     }
308 
309     /**
310      * @dev See {IERC20-balanceOf}.
311      */
312     function balanceOf(address account) public view virtual override returns (uint256) {
313         return _balances[account];
314     }
315 
316     /**
317      * @dev See {IERC20-transfer}.
318      *
319      * Requirements:
320      *
321      * - `recipient` cannot be the zero address.
322      * - the caller must have a balance of at least `amount`.
323      */
324     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
325         _transfer(_msgSender(), recipient, amount);
326         return true;
327     }
328 
329     /**
330      * @dev See {IERC20-allowance}.
331      */
332     function allowance(address owner, address spender) public view virtual override returns (uint256) {
333         return _allowances[owner][spender];
334     }
335 
336     /**
337      * @dev See {IERC20-approve}.
338      *
339      * Requirements:
340      *
341      * - `spender` cannot be the zero address.
342      */
343     function approve(address spender, uint256 amount) public virtual override returns (bool) {
344         _approve(_msgSender(), spender, amount);
345         return true;
346     }
347 
348     /**
349      * @dev See {IERC20-transferFrom}.
350      *
351      * Emits an {Approval} event indicating the updated allowance. This is not
352      * required by the EIP. See the note at the beginning of {ERC20}.
353      *
354      * Requirements:
355      *
356      * - `sender` and `recipient` cannot be the zero address.
357      * - `sender` must have a balance of at least `amount`.
358      * - the caller must have allowance for ``sender``'s tokens of at least
359      * `amount`.
360      */
361     function transferFrom(
362         address sender,
363         address recipient,
364         uint256 amount
365     ) public virtual override returns (bool) {
366         _transfer(sender, recipient, amount);
367 
368         uint256 currentAllowance = _allowances[sender][_msgSender()];
369         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
370         unchecked {
371             _approve(sender, _msgSender(), currentAllowance - amount);
372         }
373 
374         return true;
375     }
376 
377     /**
378      * @dev Atomically increases the allowance granted to `spender` by the caller.
379      *
380      * This is an alternative to {approve} that can be used as a mitigation for
381      * problems described in {IERC20-approve}.
382      *
383      * Emits an {Approval} event indicating the updated allowance.
384      *
385      * Requirements:
386      *
387      * - `spender` cannot be the zero address.
388      */
389     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
390         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
391         return true;
392     }
393 
394     /**
395      * @dev Atomically decreases the allowance granted to `spender` by the caller.
396      *
397      * This is an alternative to {approve} that can be used as a mitigation for
398      * problems described in {IERC20-approve}.
399      *
400      * Emits an {Approval} event indicating the updated allowance.
401      *
402      * Requirements:
403      *
404      * - `spender` cannot be the zero address.
405      * - `spender` must have allowance for the caller of at least
406      * `subtractedValue`.
407      */
408     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
409         uint256 currentAllowance = _allowances[_msgSender()][spender];
410         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
411         unchecked {
412             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
413         }
414 
415         return true;
416     }
417 
418     /**
419      * @dev Moves `amount` of tokens from `sender` to `recipient`.
420      *
421      * This internal function is equivalent to {transfer}, and can be used to
422      * e.g. implement automatic token fees, slashing mechanisms, etc.
423      *
424      * Emits a {Transfer} event.
425      *
426      * Requirements:
427      *
428      * - `sender` cannot be the zero address.
429      * - `recipient` cannot be the zero address.
430      * - `sender` must have a balance of at least `amount`.
431      */
432     function _transfer(
433         address sender,
434         address recipient,
435         uint256 amount
436     ) internal virtual {
437         require(sender != address(0), "ERC20: transfer from the zero address");
438         require(recipient != address(0), "ERC20: transfer to the zero address");
439 
440         _beforeTokenTransfer(sender, recipient, amount);
441 
442         uint256 senderBalance = _balances[sender];
443         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
444         unchecked {
445             _balances[sender] = senderBalance - amount;
446         }
447         _balances[recipient] += amount;
448 
449         emit Transfer(sender, recipient, amount);
450 
451         _afterTokenTransfer(sender, recipient, amount);
452     }
453 
454     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
455      * the total supply.
456      *
457      * Emits a {Transfer} event with `from` set to the zero address.
458      *
459      * Requirements:
460      *
461      * - `account` cannot be the zero address.
462      */
463     function _mint(address account, uint256 amount) internal virtual {
464         require(account != address(0), "ERC20: mint to the zero address");
465 
466         _beforeTokenTransfer(address(0), account, amount);
467 
468         _totalSupply += amount;
469         _balances[account] += amount;
470         emit Transfer(address(0), account, amount);
471 
472         _afterTokenTransfer(address(0), account, amount);
473     }
474 
475     /**
476      * @dev Destroys `amount` tokens from `account`, reducing the
477      * total supply.
478      *
479      * Emits a {Transfer} event with `to` set to the zero address.
480      *
481      * Requirements:
482      *
483      * - `account` cannot be the zero address.
484      * - `account` must have at least `amount` tokens.
485      */
486     function _burn(address account, uint256 amount) internal virtual {
487         require(account != address(0), "ERC20: burn from the zero address");
488 
489         _beforeTokenTransfer(account, address(0), amount);
490 
491         uint256 accountBalance = _balances[account];
492         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
493         unchecked {
494             _balances[account] = accountBalance - amount;
495         }
496         _totalSupply -= amount;
497 
498         emit Transfer(account, address(0), amount);
499 
500         _afterTokenTransfer(account, address(0), amount);
501     }
502 
503     /**
504      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
505      *
506      * This internal function is equivalent to `approve`, and can be used to
507      * e.g. set automatic allowances for certain subsystems, etc.
508      *
509      * Emits an {Approval} event.
510      *
511      * Requirements:
512      *
513      * - `owner` cannot be the zero address.
514      * - `spender` cannot be the zero address.
515      */
516     function _approve(
517         address owner,
518         address spender,
519         uint256 amount
520     ) internal virtual {
521         require(owner != address(0), "ERC20: approve from the zero address");
522         require(spender != address(0), "ERC20: approve to the zero address");
523 
524         _allowances[owner][spender] = amount;
525         emit Approval(owner, spender, amount);
526     }
527 
528     /**
529      * @dev Hook that is called before any transfer of tokens. This includes
530      * minting and burning.
531      *
532      * Calling conditions:
533      *
534      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
535      * will be transferred to `to`.
536      * - when `from` is zero, `amount` tokens will be minted for `to`.
537      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
538      * - `from` and `to` are never both zero.
539      *
540      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
541      */
542     function _beforeTokenTransfer(
543         address from,
544         address to,
545         uint256 amount
546     ) internal virtual {}
547 
548     /**
549      * @dev Hook that is called after any transfer of tokens. This includes
550      * minting and burning.
551      *
552      * Calling conditions:
553      *
554      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
555      * has been transferred to `to`.
556      * - when `from` is zero, `amount` tokens have been minted for `to`.
557      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
558      * - `from` and `to` are never both zero.
559      *
560      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
561      */
562     function _afterTokenTransfer(
563         address from,
564         address to,
565         uint256 amount
566     ) internal virtual {}
567 }
568 
569 
570 // File contracts/ETHEREUM.sol
571 
572 
573 
574 pragma solidity ^0.8.0;
575 
576 
577 contract ElonTidePodHarambe69Inu is Ownable, ERC20 {
578     bool public limited;
579     uint256 public maxHoldingAmount;
580     uint256 public minHoldingAmount;
581     address public uniswapV2Pair;
582     mapping(address => bool) public blacklists;
583 
584     constructor(uint256 _totalSupply) ERC20("ElonTidePodHarambe69Inu", "ETHEREUM") {
585         _mint(msg.sender, _totalSupply);
586     }
587 
588     function blacklist(address _address, bool _isBlacklisting) external onlyOwner {
589         blacklists[_address] = _isBlacklisting;
590     }
591 
592     function setRule(bool _limited, address _uniswapV2Pair, uint256 _maxHoldingAmount, uint256 _minHoldingAmount) external onlyOwner {
593         limited = _limited;
594         uniswapV2Pair = _uniswapV2Pair;
595         maxHoldingAmount = _maxHoldingAmount;
596         minHoldingAmount = _minHoldingAmount;
597     }
598 
599     function _beforeTokenTransfer(
600         address from,
601         address to,
602         uint256 amount
603     ) override internal virtual {
604         require(!blacklists[to] && !blacklists[from], "Blacklisted");
605 
606         if (uniswapV2Pair == address(0)) {
607             require(from == owner() || to == owner(), "trading is not started");
608             return;
609         }
610 
611         if (limited && from == uniswapV2Pair) {
612             require(super.balanceOf(to) + amount <= maxHoldingAmount && super.balanceOf(to) + amount >= minHoldingAmount, "Forbid");
613         }
614     }
615 
616     function burn(uint256 value) external {
617         _burn(msg.sender, value);
618     }
619 }