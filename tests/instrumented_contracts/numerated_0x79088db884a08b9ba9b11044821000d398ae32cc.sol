1 // File @openzeppelin/contracts/utils/Context.sol@v4.4.0
2 // SPDX-License-Identifier: MIT
3 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 
28 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.0
29 
30 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
31 
32 pragma solidity ^0.8.0;
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  * By default, the owner account will be the one that deploys the contract. This
39  * can later be changed with {transferOwnership}.
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 
45 abstract contract Ownable is Context {
46     address private _owner;
47 
48     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50     /**
51      * @dev Initializes the contract setting the deployer as the initial owner.
52      */
53     constructor() {
54         _transferOwnership(_msgSender());
55     }
56 
57     /**
58      * @dev Returns the address of the current owner.
59      */
60     function owner() public view virtual returns (address) {
61         return _owner;
62     }
63 
64     /**
65      * @dev Throws if called by any account other than the owner.
66      */
67     modifier onlyOwner() {
68         require(owner() == _msgSender(), "Ownable: caller is not the owner");
69         _;
70     }
71 
72     /**
73      * @dev Leaves the contract without owner. It will not be possible to call
74      * `onlyOwner` functions anymore. Can only be called by the current owner.
75      * NOTE: Renouncing ownership will leave the contract without an owner,
76      * thereby removing any functionality that is only available to the owner.
77      */
78     function renounceOwnership() public virtual onlyOwner {
79         _transferOwnership(address(0));
80     }
81 
82     /**
83      * @dev Transfers ownership of the contract to a new account (`newOwner`).
84      * Can only be called by the current owner.
85      */
86     function transferOwnership(address newOwner) public virtual onlyOwner {
87         require(newOwner != address(0), "Ownable: new owner is the zero address");
88         _transferOwnership(newOwner);
89     }
90 
91     /**
92      * @dev Transfers ownership of the contract to a new account (`newOwner`).
93      * Internal function without access restriction.
94      */
95     function _transferOwnership(address newOwner) internal virtual {
96         address oldOwner = _owner;
97         _owner = newOwner;
98         emit OwnershipTransferred(oldOwner, newOwner);
99     }
100 }
101 
102 
103 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.4.0
104 
105 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
106 
107 pragma solidity ^0.8.0;
108 
109 /**
110  * @dev Interface of the ERC20 standard as defined in the EIP.
111  */
112 interface IERC20 {
113     /**
114      * @dev Returns the amount of tokens in existence.
115      */
116     function totalSupply() external view returns (uint256);
117 
118     /**
119      * @dev Returns the amount of tokens owned by `account`.
120      */
121     function balanceOf(address account) external view returns (uint256);
122 
123     /**
124      * @dev Moves `amount` tokens from the caller's account to `recipient`.
125      * Returns a boolean value indicating whether the operation succeeded.
126      * Emits a {Transfer} event.
127      */
128     function transfer(address recipient, uint256 amount) external returns (bool);
129 
130     /**
131      * @dev Returns the remaining number of tokens that `spender` will be
132      * allowed to spend on behalf of `owner` through {transferFrom}. This is
133      * zero by default.
134      * This value changes when {approve} or {transferFrom} are called.
135      */
136     function allowance(address owner, address spender) external view returns (uint256);
137 
138     /**
139      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
140      * Returns a boolean value indicating whether the operation succeeded.
141      * IMPORTANT: Beware that changing an allowance with this method brings the risk
142      * that someone may use both the old and the new allowance by unfortunate
143      * transaction ordering. One possible solution to mitigate this race
144      * condition is to first reduce the spender's allowance to 0 and set the
145      * desired value afterwards:
146      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
147      *
148      * Emits an {Approval} event.
149      */
150     function approve(address spender, uint256 amount) external returns (bool);
151 
152     /**
153      * @dev Moves `amount` tokens from `sender` to `recipient` using the
154      * allowance mechanism. `amount` is then deducted from the caller's
155      * allowance.
156      *
157      * Returns a boolean value indicating whether the operation succeeded.
158      *
159      * Emits a {Transfer} event.
160      */
161     function transferFrom(
162         address sender,
163         address recipient,
164         uint256 amount
165     ) external returns (bool);
166 
167     /**
168      * @dev Emitted when `value` tokens are moved from one account (`from`) to
169      * another (`to`).
170      *
171      * Note that `value` may be zero.
172      */
173     event Transfer(address indexed from, address indexed to, uint256 value);
174 
175     /**
176      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
177      * a call to {approve}. `value` is the new allowance.
178      */
179     event Approval(address indexed owner, address indexed spender, uint256 value);
180 }
181 
182 
183 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.4.0
184 
185 
186 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
187 
188 pragma solidity ^0.8.0;
189 
190 /**
191  * @dev Interface for the optional metadata functions from the ERC20 standard.
192  *
193  * _Available since v4.1._
194  */
195 interface IERC20Metadata is IERC20 {
196     /**
197      * @dev Returns the name of the token.
198      */
199     function name() external view returns (string memory);
200 
201     /**
202      * @dev Returns the symbol of the token.
203      */
204     function symbol() external view returns (string memory);
205 
206     /**
207      * @dev Returns the decimals places of the token.
208      */
209     function decimals() external view returns (uint8);
210 }
211 
212 
213 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.4.0
214 
215 
216 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
217 
218 pragma solidity ^0.8.0;
219 
220 
221 
222 /**
223  * @dev Implementation of the {IERC20} interface.
224  *
225  * This implementation is agnostic to the way tokens are created. This means
226  * that a supply mechanism has to be added in a derived contract using {_mint}.
227  * For a generic mechanism see {ERC20PresetMinterPauser}.
228  *
229  * TIP: For a detailed writeup see our guide
230  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
231  * to implement supply mechanisms].
232  *
233  * We have followed general OpenZeppelin Contracts guidelines: functions revert
234  * instead returning `false` on failure. This behavior is nonetheless
235  * conventional and does not conflict with the expectations of ERC20
236  * applications.
237  *
238  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
239  * This allows applications to reconstruct the allowance for all accounts just
240  * by listening to said events. Other implementations of the EIP may not emit
241  * these events, as it isn't required by the specification.
242  *
243  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
244  * functions have been added to mitigate the well-known issues around setting
245  * allowances. See {IERC20-approve}.
246 */
247 
248 contract ERC20 is Context, IERC20, IERC20Metadata {
249     mapping(address => uint256) private _balances;
250 
251     mapping(address => mapping(address => uint256)) private _allowances;
252 
253     uint256 private _totalSupply;
254 
255     string private _name;
256     string private _symbol;
257 
258     /**
259      * @dev Sets the values for {name} and {symbol}.
260      *
261      * The default value of {decimals} is 18. To select a different value for
262      * {decimals} you should overload it.
263      *
264      * All two of these values are immutable: they can only be set once during
265      * construction.
266      */
267     constructor(string memory name_, string memory symbol_) {
268         _name = name_;
269         _symbol = symbol_;
270     }
271 
272     /**
273      * @dev Returns the name of the token.
274      */
275     function name() public view virtual override returns (string memory) {
276         return _name;
277     }
278 
279     /**
280      * @dev Returns the symbol of the token, usually a shorter version of the
281      * name.
282      */
283     function symbol() public view virtual override returns (string memory) {
284         return _symbol;
285     }
286 
287     /**
288      * @dev Returns the number of decimals used to get its user representation.
289      * For example, if `decimals` equals `2`, a balance of `505` tokens should
290      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
291      *
292      * Tokens usually opt for a value of 18, imitating the relationship between
293      * Ether and Wei. This is the value {ERC20} uses, unless this function is
294      * overridden;
295      *
296      * NOTE: This information is only used for _display_ purposes: it in
297      * no way affects any of the arithmetic of the contract, including
298      * {IERC20-balanceOf} and {IERC20-transfer}.
299      */
300     function decimals() public view virtual override returns (uint8) {
301         return 18;
302     }
303 
304     /**
305      * @dev See {IERC20-totalSupply}.
306      */
307     function totalSupply() public view virtual override returns (uint256) {
308         return _totalSupply;
309     }
310 
311     /**
312      * @dev See {IERC20-balanceOf}.
313      */
314     function balanceOf(address account) public view virtual override returns (uint256) {
315         return _balances[account];
316     }
317 
318     /**
319      * @dev See {IERC20-transfer}.
320      *
321      * Requirements:
322      *
323      * - `recipient` cannot be the zero address.
324      * - the caller must have a balance of at least `amount`.
325      */
326     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
327         _transfer(_msgSender(), recipient, amount);
328         return true;
329     }
330 
331     /**
332      * @dev See {IERC20-allowance}.
333      */
334     function allowance(address owner, address spender) public view virtual override returns (uint256) {
335         return _allowances[owner][spender];
336     }
337 
338     /**
339      * @dev See {IERC20-approve}.
340      *
341      * Requirements:
342      *
343      * - `spender` cannot be the zero address.
344      */
345     function approve(address spender, uint256 amount) public virtual override returns (bool) {
346         _approve(_msgSender(), spender, amount);
347         return true;
348     }
349 
350     /**
351      * @dev See {IERC20-transferFrom}.
352      *
353      * Emits an {Approval} event indicating the updated allowance. This is not
354      * required by the EIP. See the note at the beginning of {ERC20}.
355      *
356      * Requirements:
357      *
358      * - `sender` and `recipient` cannot be the zero address.
359      * - `sender` must have a balance of at least `amount`.
360      * - the caller must have allowance for ``sender``'s tokens of at least
361      * `amount`.
362      */
363     function transferFrom(
364         address sender,
365         address recipient,
366         uint256 amount
367     ) public virtual override returns (bool) {
368         _transfer(sender, recipient, amount);
369 
370         uint256 currentAllowance = _allowances[sender][_msgSender()];
371         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
372         unchecked {
373             _approve(sender, _msgSender(), currentAllowance - amount);
374         }
375 
376         return true;
377     }
378 
379     /**
380      * @dev Atomically increases the allowance granted to `spender` by the caller.
381      *
382      * This is an alternative to {approve} that can be used as a mitigation for
383      * problems described in {IERC20-approve}.
384      *
385      * Emits an {Approval} event indicating the updated allowance.
386      *
387      * Requirements:
388      *
389      * - `spender` cannot be the zero address.
390      */
391     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
392         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
393         return true;
394     }
395 
396     /**
397      * @dev Atomically decreases the allowance granted to `spender` by the caller.
398      *
399      * This is an alternative to {approve} that can be used as a mitigation for
400      * problems described in {IERC20-approve}.
401      *
402      * Emits an {Approval} event indicating the updated allowance.
403      *
404      * Requirements:
405      *
406      * - `spender` cannot be the zero address.
407      * - `spender` must have allowance for the caller of at least
408      * `subtractedValue`.
409      */
410     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
411         uint256 currentAllowance = _allowances[_msgSender()][spender];
412         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
413         unchecked {
414             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
415         }
416 
417         return true;
418     }
419 
420     /**
421      * @dev Moves `amount` of tokens from `sender` to `recipient`.
422      *
423      * This internal function is equivalent to {transfer}, and can be used to
424      * e.g. implement automatic token fees, slashing mechanisms, etc.
425      *
426      * Emits a {Transfer} event.
427      *
428      * Requirements:
429      *
430      * - `sender` cannot be the zero address.
431      * - `recipient` cannot be the zero address.
432      * - `sender` must have a balance of at least `amount`.
433      */
434     function _transfer(
435         address sender,
436         address recipient,
437         uint256 amount
438     ) internal virtual {
439         require(sender != address(0), "ERC20: transfer from the zero address");
440         require(recipient != address(0), "ERC20: transfer to the zero address");
441 
442         _beforeTokenTransfer(sender, recipient, amount);
443 
444         uint256 senderBalance = _balances[sender];
445         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
446         unchecked {
447             _balances[sender] = senderBalance - amount;
448         }
449         _balances[recipient] += amount;
450 
451         emit Transfer(sender, recipient, amount);
452 
453         _afterTokenTransfer(sender, recipient, amount);
454     }
455 
456     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
457      * the total supply.
458      *
459      * Emits a {Transfer} event with `from` set to the zero address.
460      *
461      * Requirements:
462      *
463      * - `account` cannot be the zero address.
464      */
465     function _mint(address account, uint256 amount) internal virtual {
466         require(account != address(0), "ERC20: mint to the zero address");
467 
468         _beforeTokenTransfer(address(0), account, amount);
469 
470         _totalSupply += amount;
471         _balances[account] += amount;
472         emit Transfer(address(0), account, amount);
473 
474         _afterTokenTransfer(address(0), account, amount);
475     }
476 
477     /**
478      * @dev Destroys `amount` tokens from `account`, reducing the
479      * total supply.
480      *
481      * Emits a {Transfer} event with `to` set to the zero address.
482      *
483      * Requirements:
484      *
485      * - `account` cannot be the zero address.
486      * - `account` must have at least `amount` tokens.
487      */
488     function _burn(address account, uint256 amount) internal virtual {
489         require(account != address(0), "ERC20: burn from the zero address");
490 
491         _beforeTokenTransfer(account, address(0), amount);
492 
493         uint256 accountBalance = _balances[account];
494         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
495         unchecked {
496             _balances[account] = accountBalance - amount;
497         }
498         _totalSupply -= amount;
499 
500         emit Transfer(account, address(0), amount);
501 
502         _afterTokenTransfer(account, address(0), amount);
503     }
504 
505     /**
506      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
507      *
508      * This internal function is equivalent to `approve`, and can be used to
509      * e.g. set automatic allowances for certain subsystems, etc.
510      *
511      * Emits an {Approval} event.
512      *
513      * Requirements:
514      *
515      * - `owner` cannot be the zero address.
516      * - `spender` cannot be the zero address.
517      */
518     function _approve(
519         address owner,
520         address spender,
521         uint256 amount
522     ) internal virtual {
523         require(owner != address(0), "ERC20: approve from the zero address");
524         require(spender != address(0), "ERC20: approve to the zero address");
525 
526         _allowances[owner][spender] = amount;
527         emit Approval(owner, spender, amount);
528     }
529 
530     /**
531      * @dev Hook that is called before any transfer of tokens. This includes
532      * minting and burning.
533      *
534      * Calling conditions:
535      *
536      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
537      * will be transferred to `to`.
538      * - when `from` is zero, `amount` tokens will be minted for `to`.
539      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
540      * - `from` and `to` are never both zero.
541      *
542      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
543      */
544     function _beforeTokenTransfer(
545         address from,
546         address to,
547         uint256 amount
548     ) internal virtual {}
549 
550     /**
551      * @dev Hook that is called after any transfer of tokens. This includes
552      * minting and burning.
553      *
554      * Calling conditions:
555      *
556      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
557      * has been transferred to `to`.
558      * - when `from` is zero, `amount` tokens have been minted for `to`.
559      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
560      * - `from` and `to` are never both zero.
561      *
562      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
563      */
564     function _afterTokenTransfer(
565         address from,
566         address to,
567         uint256 amount
568     ) internal virtual {}
569 }
570 
571 
572 // File contracts/DorkNerdGeek.sol
573 
574 
575 
576 pragma solidity ^0.8.0;
577 
578 
579 contract DorkNerdGeek is Ownable, ERC20 {
580     bool public limited;
581     uint256 public maxHoldingAmount;
582     uint256 public minHoldingAmount;
583     address public uniswapV2Pair;
584     mapping(address => bool) public blacklists;
585 
586     constructor() ERC20("Dork Nerd Geek", "DNG") {
587       uint256 _totalSupply = 69000 * 10**9 * 10**18;
588         _mint(msg.sender, _totalSupply);
589     }
590 
591     function blacklist(address _address, bool _isBlacklisting) external onlyOwner {
592         blacklists[_address] = _isBlacklisting;
593     }
594 
595     function setRule(bool _limited, address _uniswapV2Pair, uint256 _maxHoldingAmount, uint256 _minHoldingAmount) external onlyOwner {
596         limited = _limited;
597         uniswapV2Pair = _uniswapV2Pair;
598         maxHoldingAmount = _maxHoldingAmount;
599         minHoldingAmount = _minHoldingAmount;
600     }
601 
602     function _beforeTokenTransfer(
603         address from,
604         address to,
605         uint256 amount
606     ) override internal virtual {
607         require(!blacklists[to] && !blacklists[from], "Blacklisted");
608 
609         if (uniswapV2Pair == address(0)) {
610             require(from == owner() || to == owner(), "trading is not started");
611             return;
612         }
613 
614         if (limited && from == uniswapV2Pair) {
615             require(super.balanceOf(to) + amount <= maxHoldingAmount && super.balanceOf(to) + amount >= minHoldingAmount, "Forbid");
616         }
617     }
618 
619     function burn(uint256 value) external {
620         _burn(msg.sender, value);
621     }
622 }