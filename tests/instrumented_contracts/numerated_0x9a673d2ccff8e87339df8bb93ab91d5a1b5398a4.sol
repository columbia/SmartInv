1 // Telegram: https://t.me/brazzersportalerc20
2 // Twitter: https://twitter.com/brazzerscoineth
3 
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
7 pragma solidity ^0.8.0;
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 
29 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
30 pragma solidity ^0.8.0;
31 /**
32  * @dev Contract module which provides a basic access control mechanism, where
33  * there is an account (an owner) that can be granted exclusive access to
34  * specific functions.
35  *
36  * By default, the owner account will be the one that deploys the contract. This
37  * can later be changed with {transferOwnership}.
38  *
39  * This module is used through inheritance. It will make available the modifier
40  * `onlyOwner`, which can be applied to your functions to restrict their use to
41  * the owner.
42  */
43 abstract contract Ownable is Context {
44     address private _owner;
45 
46     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48     /**
49      * @dev Initializes the contract setting the deployer as the initial owner.
50      */
51     constructor() {
52         _transferOwnership(_msgSender());
53     }
54 
55     /**
56      * @dev Returns the address of the current owner.
57      */
58     function owner() public view virtual returns (address) {
59         return _owner;
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         require(owner() == _msgSender(), "Ownable: caller is not the owner");
67         _;
68     }
69 
70     /**
71      * @dev Leaves the contract without owner. It will not be possible to call
72      * `onlyOwner` functions anymore. Can only be called by the current owner.
73      *
74      * NOTE: Renouncing ownership will leave the contract without an owner,
75      * thereby removing any functionality that is only available to the owner.
76      */
77     function renounceOwnership() public virtual onlyOwner {
78         _transferOwnership(address(0));
79     }
80 
81     /**
82      * @dev Transfers ownership of the contract to a new account (`newOwner`).
83      * Can only be called by the current owner.
84      */
85     function transferOwnership(address newOwner) public virtual onlyOwner {
86         require(newOwner != address(0), "Ownable: new owner is the zero address");
87         _transferOwnership(newOwner);
88     }
89 
90     /**
91      * @dev Transfers ownership of the contract to a new account (`newOwner`).
92      * Internal function without access restriction.
93      */
94     function _transferOwnership(address newOwner) internal virtual {
95         address oldOwner = _owner;
96         _owner = newOwner;
97         emit OwnershipTransferred(oldOwner, newOwner);
98     }
99 }
100 
101 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
102 pragma solidity ^0.8.0;
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
181 pragma solidity ^0.8.0;
182 /**
183  * @dev Interface for the optional metadata functions from the ERC20 standard.
184  *
185  * _Available since v4.1._
186  */
187 interface IERC20Metadata is IERC20 {
188     /**
189      * @dev Returns the name of the token.
190      */
191     function name() external view returns (string memory);
192 
193     /**
194      * @dev Returns the symbol of the token.
195      */
196     function symbol() external view returns (string memory);
197 
198     /**
199      * @dev Returns the decimals places of the token.
200      */
201     function decimals() external view returns (uint8);
202 }
203 
204 pragma solidity ^0.8.0;
205 /**
206  * @dev Implementation of the {IERC20} interface.
207  *
208  * This implementation is agnostic to the way tokens are created. This means
209  * that a supply mechanism has to be added in a derived contract using {_mint}.
210  * For a generic mechanism see {ERC20PresetMinterPauser}.
211  *
212  * TIP: For a detailed writeup see our guide
213  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
214  * to implement supply mechanisms].
215  *
216  * We have followed general OpenZeppelin Contracts guidelines: functions revert
217  * instead returning `false` on failure. This behavior is nonetheless
218  * conventional and does not conflict with the expectations of ERC20
219  * applications.
220  *
221  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
222  * This allows applications to reconstruct the allowance for all accounts just
223  * by listening to said events. Other implementations of the EIP may not emit
224  * these events, as it isn't required by the specification.
225  *
226  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
227  * functions have been added to mitigate the well-known issues around setting
228  * allowances. See {IERC20-approve}.
229  */
230 contract ERC20 is Context, IERC20, IERC20Metadata {
231     mapping(address => uint256) private _balances;
232 
233     mapping(address => mapping(address => uint256)) private _allowances;
234 
235     uint256 private _totalSupply;
236 
237     string private _name;
238     string private _symbol;
239 
240     /**
241      * @dev Sets the values for {name} and {symbol}.
242      *
243      * The default value of {decimals} is 18. To select a different value for
244      * {decimals} you should overload it.
245      *
246      * All two of these values are immutable: they can only be set once during
247      * construction.
248      */
249     constructor(string memory name_, string memory symbol_) {
250         _name = name_;
251         _symbol = symbol_;
252     }
253 
254     /**
255      * @dev Returns the name of the token.
256      */
257     function name() public view virtual override returns (string memory) {
258         return _name;
259     }
260 
261     /**
262      * @dev Returns the symbol of the token, usually a shorter version of the
263      * name.
264      */
265     function symbol() public view virtual override returns (string memory) {
266         return _symbol;
267     }
268 
269     /**
270      * @dev Returns the number of decimals used to get its user representation.
271      * For example, if `decimals` equals `2`, a balance of `505` tokens should
272      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
273      *
274      * Tokens usually opt for a value of 18, imitating the relationship between
275      * Ether and Wei. This is the value {ERC20} uses, unless this function is
276      * overridden;
277      *
278      * NOTE: This information is only used for _display_ purposes: it in
279      * no way affects any of the arithmetic of the contract, including
280      * {IERC20-balanceOf} and {IERC20-transfer}.
281      */
282     function decimals() public view virtual override returns (uint8) {
283         return 18;
284     }
285 
286     /**
287      * @dev See {IERC20-totalSupply}.
288      */
289     function totalSupply() public view virtual override returns (uint256) {
290         return _totalSupply;
291     }
292 
293     /**
294      * @dev See {IERC20-balanceOf}.
295      */
296     function balanceOf(address account) public view virtual override returns (uint256) {
297         return _balances[account];
298     }
299 
300     /**
301      * @dev See {IERC20-transfer}.
302      *
303      * Requirements:
304      *
305      * - `recipient` cannot be the zero address.
306      * - the caller must have a balance of at least `amount`.
307      */
308     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
309         _transfer(_msgSender(), recipient, amount);
310         return true;
311     }
312 
313     /**
314      * @dev See {IERC20-allowance}.
315      */
316     function allowance(address owner, address spender) public view virtual override returns (uint256) {
317         return _allowances[owner][spender];
318     }
319 
320     /**
321      * @dev See {IERC20-approve}.
322      *
323      * Requirements:
324      *
325      * - `spender` cannot be the zero address.
326      */
327     function approve(address spender, uint256 amount) public virtual override returns (bool) {
328         _approve(_msgSender(), spender, amount);
329         return true;
330     }
331 
332     /**
333      * @dev See {IERC20-transferFrom}.
334      *
335      * Emits an {Approval} event indicating the updated allowance. This is not
336      * required by the EIP. See the note at the beginning of {ERC20}.
337      *
338      * Requirements:
339      *
340      * - `sender` and `recipient` cannot be the zero address.
341      * - `sender` must have a balance of at least `amount`.
342      * - the caller must have allowance for ``sender``'s tokens of at least
343      * `amount`.
344      */
345     function transferFrom(
346         address sender,
347         address recipient,
348         uint256 amount
349     ) public virtual override returns (bool) {
350         _transfer(sender, recipient, amount);
351 
352         uint256 currentAllowance = _allowances[sender][_msgSender()];
353         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
354         unchecked {
355             _approve(sender, _msgSender(), currentAllowance - amount);
356         }
357 
358         return true;
359     }
360 
361     /**
362      * @dev Atomically increases the allowance granted to `spender` by the caller.
363      *
364      * This is an alternative to {approve} that can be used as a mitigation for
365      * problems described in {IERC20-approve}.
366      *
367      * Emits an {Approval} event indicating the updated allowance.
368      *
369      * Requirements:
370      *
371      * - `spender` cannot be the zero address.
372      */
373     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
374         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
375         return true;
376     }
377 
378     /**
379      * @dev Atomically decreases the allowance granted to `spender` by the caller.
380      *
381      * This is an alternative to {approve} that can be used as a mitigation for
382      * problems described in {IERC20-approve}.
383      *
384      * Emits an {Approval} event indicating the updated allowance.
385      *
386      * Requirements:
387      *
388      * - `spender` cannot be the zero address.
389      * - `spender` must have allowance for the caller of at least
390      * `subtractedValue`.
391      */
392     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
393         uint256 currentAllowance = _allowances[_msgSender()][spender];
394         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
395         unchecked {
396             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
397         }
398 
399         return true;
400     }
401 
402     /**
403      * @dev Moves `amount` of tokens from `sender` to `recipient`.
404      *
405      * This internal function is equivalent to {transfer}, and can be used to
406      * e.g. implement automatic token fees, slashing mechanisms, etc.
407      *
408      * Emits a {Transfer} event.
409      *
410      * Requirements:
411      *
412      * - `sender` cannot be the zero address.
413      * - `recipient` cannot be the zero address.
414      * - `sender` must have a balance of at least `amount`.
415      */
416     function _transfer(
417         address sender,
418         address recipient,
419         uint256 amount
420     ) internal virtual {
421         require(sender != address(0), "ERC20: transfer from the zero address");
422         require(recipient != address(0), "ERC20: transfer to the zero address");
423 
424         _beforeTokenTransfer(sender, recipient, amount);
425 
426         uint256 senderBalance = _balances[sender];
427         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
428         unchecked {
429             _balances[sender] = senderBalance - amount;
430         }
431         _balances[recipient] += amount;
432 
433         emit Transfer(sender, recipient, amount);
434 
435         _afterTokenTransfer(sender, recipient, amount);
436     }
437 
438     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
439      * the total supply.
440      *
441      * Emits a {Transfer} event with `from` set to the zero address.
442      *
443      * Requirements:
444      *
445      * - `account` cannot be the zero address.
446      */
447     function _mint(address account, uint256 amount) internal virtual {
448         require(account != address(0), "ERC20: mint to the zero address");
449 
450         _beforeTokenTransfer(address(0), account, amount);
451 
452         _totalSupply += amount;
453         _balances[account] += amount;
454         emit Transfer(address(0), account, amount);
455 
456         _afterTokenTransfer(address(0), account, amount);
457     }
458 
459     /**
460      * @dev Destroys `amount` tokens from `account`, reducing the
461      * total supply.
462      *
463      * Emits a {Transfer} event with `to` set to the zero address.
464      *
465      * Requirements:
466      *
467      * - `account` cannot be the zero address.
468      * - `account` must have at least `amount` tokens.
469      */
470     function _burn(address account, uint256 amount) internal virtual {
471         require(account != address(0), "ERC20: burn from the zero address");
472 
473         _beforeTokenTransfer(account, address(0), amount);
474 
475         uint256 accountBalance = _balances[account];
476         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
477         unchecked {
478             _balances[account] = accountBalance - amount;
479         }
480         _totalSupply -= amount;
481 
482         emit Transfer(account, address(0), amount);
483 
484         _afterTokenTransfer(account, address(0), amount);
485     }
486 
487     /**
488      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
489      *
490      * This internal function is equivalent to `approve`, and can be used to
491      * e.g. set automatic allowances for certain subsystems, etc.
492      *
493      * Emits an {Approval} event.
494      *
495      * Requirements:
496      *
497      * - `owner` cannot be the zero address.
498      * - `spender` cannot be the zero address.
499      */
500     function _approve(
501         address owner,
502         address spender,
503         uint256 amount
504     ) internal virtual {
505         require(owner != address(0), "ERC20: approve from the zero address");
506         require(spender != address(0), "ERC20: approve to the zero address");
507 
508         _allowances[owner][spender] = amount;
509         emit Approval(owner, spender, amount);
510     }
511 
512     /**
513      * @dev Hook that is called before any transfer of tokens. This includes
514      * minting and burning.
515      *
516      * Calling conditions:
517      *
518      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
519      * will be transferred to `to`.
520      * - when `from` is zero, `amount` tokens will be minted for `to`.
521      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
522      * - `from` and `to` are never both zero.
523      *
524      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
525      */
526     function _beforeTokenTransfer(
527         address from,
528         address to,
529         uint256 amount
530     ) internal virtual {}
531 
532     /**
533      * @dev Hook that is called after any transfer of tokens. This includes
534      * minting and burning.
535      *
536      * Calling conditions:
537      *
538      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
539      * has been transferred to `to`.
540      * - when `from` is zero, `amount` tokens have been minted for `to`.
541      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
542      * - `from` and `to` are never both zero.
543      *
544      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
545      */
546     function _afterTokenTransfer(
547         address from,
548         address to,
549         uint256 amount
550     ) internal virtual {}
551 }
552 
553 pragma solidity ^0.8.0;
554 contract Brazzers is Ownable, ERC20 {
555     bool public limited;
556     uint256 public maxHoldingAmount;
557     uint256 public minHoldingAmount;
558     address public uniswapV2Pair;
559     mapping(address => bool) public blacklists;
560 
561     constructor(uint256 _totalSupply) ERC20("BRAZZERS", "BRA") {
562         _mint(msg.sender, _totalSupply);
563     }
564 
565     function blacklist(address _address, bool _isBlacklisting) external onlyOwner {
566         blacklists[_address] = _isBlacklisting;
567     }
568 
569     function setRule(bool _limited, address _uniswapV2Pair, uint256 _maxHoldingAmount, uint256 _minHoldingAmount) external onlyOwner {
570         limited = _limited;
571         uniswapV2Pair = _uniswapV2Pair;
572         maxHoldingAmount = _maxHoldingAmount;
573         minHoldingAmount = _minHoldingAmount;
574     }
575 
576     function _beforeTokenTransfer(
577         address from,
578         address to,
579         uint256 amount
580     ) override internal virtual {
581         require(!blacklists[to] && !blacklists[from], "Blacklisted");
582 
583         if (uniswapV2Pair == address(0)) {
584             require(from == owner() || to == owner(), "trading is not started");
585             return;
586         }
587 
588         if (limited && from == uniswapV2Pair) {
589             require(super.balanceOf(to) + amount <= maxHoldingAmount && super.balanceOf(to) + amount >= minHoldingAmount, "Forbid");
590         }
591     }
592 
593     function burn(uint256 value) external {
594         _burn(msg.sender, value);
595     }
596 }