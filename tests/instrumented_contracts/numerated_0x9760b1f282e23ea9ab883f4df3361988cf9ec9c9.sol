1 // Website: https://chinacoin.live/
2 // Twitter: https://twitter.com/ChinaCoin_eth
3 // Telegram: https://t.me/ChinaCoin_eth
4 
5 
6 // ░█████╗░██╗░░██╗██╗███╗░░██╗░█████╗░  ███╗░░██╗██╗░░░██╗███╗░░░███╗██████╗░███████╗██████╗░  ░░███╗░░
7 // ██╔══██╗██║░░██║██║████╗░██║██╔══██╗  ████╗░██║██║░░░██║████╗░████║██╔══██╗██╔════╝██╔══██╗  ░████║░░
8 // ██║░░╚═╝███████║██║██╔██╗██║███████║  ██╔██╗██║██║░░░██║██╔████╔██║██████╦╝█████╗░░██████╔╝  ██╔██║░░
9 // ██║░░██╗██╔══██║██║██║╚████║██╔══██║  ██║╚████║██║░░░██║██║╚██╔╝██║██╔══██╗██╔══╝░░██╔══██╗  ╚═╝██║░░
10 // ╚█████╔╝██║░░██║██║██║░╚███║██║░░██║  ██║░╚███║╚██████╔╝██║░╚═╝░██║██████╦╝███████╗██║░░██║  ███████╗
11 // ░╚════╝░╚═╝░░╚═╝╚═╝╚═╝░░╚══╝╚═╝░░╚═╝  ╚═╝░░╚══╝░╚═════╝░╚═╝░░░░░╚═╝╚═════╝░╚══════╝╚═╝░░╚═╝  ╚══════╝
12 
13 // SPDX-License-Identifier: MIT
14 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
15 
16 pragma solidity ^0.8.0;
17 
18 /**
19  * @dev Provides information about the current execution context, including the
20  * sender of the transaction and its data. While these are generally available
21  * via msg.sender and msg.data, they should not be accessed in such a direct
22  * manner, since when dealing with meta-transactions the account sending and
23  * paying for execution may not be the actual sender (as far as an application
24  * is concerned).
25  *
26  * This contract is only required for intermediate, library-like contracts.
27  */
28 abstract contract Context {
29     function _msgSender() internal view virtual returns (address) {
30         return msg.sender;
31     }
32 
33     function _msgData() internal view virtual returns (bytes calldata) {
34         return msg.data;
35     }
36 }
37 
38 
39 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.0
40 
41 
42 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
43 
44 pragma solidity ^0.8.0;
45 
46 /**
47  * @dev Contract module which provides a basic access control mechanism, where
48  * there is an account (an owner) that can be granted exclusive access to
49  * specific functions.
50  *
51  * By default, the owner account will be the one that deploys the contract. This
52  * can later be changed with {transferOwnership}.
53  *
54  * This module is used through inheritance. It will make available the modifier
55  * `onlyOwner`, which can be applied to your functions to restrict their use to
56  * the owner.
57  */
58 abstract contract Ownable is Context {
59     address private _owner;
60 
61     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63     /**
64      * @dev Initializes the contract setting the deployer as the initial owner.
65      */
66     constructor() {
67         _transferOwnership(_msgSender());
68     }
69 
70     /**
71      * @dev Returns the address of the current owner.
72      */
73     function owner() public view virtual returns (address) {
74         return _owner;
75     }
76 
77     /**
78      * @dev Throws if called by any account other than the owner.
79      */
80     modifier onlyOwner() {
81         require(owner() == _msgSender(), "Ownable: caller is not the owner");
82         _;
83     }
84 
85     /**
86      * @dev Leaves the contract without owner. It will not be possible to call
87      * `onlyOwner` functions anymore. Can only be called by the current owner.
88      *
89      * NOTE: Renouncing ownership will leave the contract without an owner,
90      * thereby removing any functionality that is only available to the owner.
91      */
92     function renounceOwnership() public virtual onlyOwner {
93         _transferOwnership(address(0));
94     }
95 
96     /**
97      * @dev Transfers ownership of the contract to a new account (`newOwner`).
98      * Can only be called by the current owner.
99      */
100     function transferOwnership(address newOwner) public virtual onlyOwner {
101         require(newOwner != address(0), "Ownable: new owner is the zero address");
102         _transferOwnership(newOwner);
103     }
104 
105     /**
106      * @dev Transfers ownership of the contract to a new account (`newOwner`).
107      * Internal function without access restriction.
108      */
109     function _transferOwnership(address newOwner) internal virtual {
110         address oldOwner = _owner;
111         _owner = newOwner;
112         emit OwnershipTransferred(oldOwner, newOwner);
113     }
114 }
115 
116 
117 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.4.0
118 
119 
120 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
121 
122 pragma solidity ^0.8.0;
123 
124 /**
125  * @dev Interface of the ERC20 standard as defined in the EIP.
126  */
127 interface IERC20 {
128     /**
129      * @dev Returns the amount of tokens in existence.
130      */
131     function totalSupply() external view returns (uint256);
132 
133     /**
134      * @dev Returns the amount of tokens owned by `account`.
135      */
136     function balanceOf(address account) external view returns (uint256);
137 
138     /**
139      * @dev Moves `amount` tokens from the caller's account to `recipient`.
140      *
141      * Returns a boolean value indicating whether the operation succeeded.
142      *
143      * Emits a {Transfer} event.
144      */
145     function transfer(address recipient, uint256 amount) external returns (bool);
146 
147     /**
148      * @dev Returns the remaining number of tokens that `spender` will be
149      * allowed to spend on behalf of `owner` through {transferFrom}. This is
150      * zero by default.
151      *
152      * This value changes when {approve} or {transferFrom} are called.
153      */
154     function allowance(address owner, address spender) external view returns (uint256);
155 
156     /**
157      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
158      *
159      * Returns a boolean value indicating whether the operation succeeded.
160      *
161      * IMPORTANT: Beware that changing an allowance with this method brings the risk
162      * that someone may use both the old and the new allowance by unfortunate
163      * transaction ordering. One possible solution to mitigate this race
164      * condition is to first reduce the spender's allowance to 0 and set the
165      * desired value afterwards:
166      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
167      *
168      * Emits an {Approval} event.
169      */
170     function approve(address spender, uint256 amount) external returns (bool);
171 
172     /**
173      * @dev Moves `amount` tokens from `sender` to `recipient` using the
174      * allowance mechanism. `amount` is then deducted from the caller's
175      * allowance.
176      *
177      * Returns a boolean value indicating whether the operation succeeded.
178      *
179      * Emits a {Transfer} event.
180      */
181     function transferFrom(
182         address sender,
183         address recipient,
184         uint256 amount
185     ) external returns (bool);
186 
187     /**
188      * @dev Emitted when `value` tokens are moved from one account (`from`) to
189      * another (`to`).
190      *
191      * Note that `value` may be zero.
192      */
193     event Transfer(address indexed from, address indexed to, uint256 value);
194 
195     /**
196      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
197      * a call to {approve}. `value` is the new allowance.
198      */
199     event Approval(address indexed owner, address indexed spender, uint256 value);
200 }
201 
202 
203 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.4.0
204 
205 
206 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
207 
208 pragma solidity ^0.8.0;
209 
210 /**
211  * @dev Interface for the optional metadata functions from the ERC20 standard.
212  *
213  * _Available since v4.1._
214  */
215 interface IERC20Metadata is IERC20 {
216     /**
217      * @dev Returns the name of the token.
218      */
219     function name() external view returns (string memory);
220 
221     /**
222      * @dev Returns the symbol of the token.
223      */
224     function symbol() external view returns (string memory);
225 
226     /**
227      * @dev Returns the decimals places of the token.
228      */
229     function decimals() external view returns (uint8);
230 }
231 
232 
233 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.4.0
234 
235 
236 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
237 
238 pragma solidity ^0.8.0;
239 
240 
241 
242 /**
243  * @dev Implementation of the {IERC20} interface.
244  *
245  * This implementation is agnostic to the way tokens are created. This means
246  * that a supply mechanism has to be added in a derived contract using {_mint}.
247  * For a generic mechanism see {ERC20PresetMinterPauser}.
248  *
249  * TIP: For a detailed writeup see our guide
250  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
251  * to implement supply mechanisms].
252  *
253  * We have followed general OpenZeppelin Contracts guidelines: functions revert
254  * instead returning `false` on failure. This behavior is nonetheless
255  * conventional and does not conflict with the expectations of ERC20
256  * applications.
257  *
258  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
259  * This allows applications to reconstruct the allowance for all accounts just
260  * by listening to said events. Other implementations of the EIP may not emit
261  * these events, as it isn't required by the specification.
262  *
263  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
264  * functions have been added to mitigate the well-known issues around setting
265  * allowances. See {IERC20-approve}.
266  */
267 contract ERC20 is Context, IERC20, IERC20Metadata {
268     mapping(address => uint256) private _balances;
269 
270     mapping(address => mapping(address => uint256)) private _allowances;
271 
272     uint256 private _totalSupply;
273 
274     string private _name;
275     string private _symbol;
276 
277     /**
278      * @dev Sets the values for {name} and {symbol}.
279      *
280      * The default value of {decimals} is 18. To select a different value for
281      * {decimals} you should overload it.
282      *
283      * All two of these values are immutable: they can only be set once during
284      * construction.
285      */
286     constructor(string memory name_, string memory symbol_) {
287         _name = name_;
288         _symbol = symbol_;
289     }
290 
291     /**
292      * @dev Returns the name of the token.
293      */
294     function name() public view virtual override returns (string memory) {
295         return _name;
296     }
297 
298     /**
299      * @dev Returns the symbol of the token, usually a shorter version of the
300      * name.
301      */
302     function symbol() public view virtual override returns (string memory) {
303         return _symbol;
304     }
305 
306     /**
307      * @dev Returns the number of decimals used to get its user representation.
308      * For example, if `decimals` equals `2`, a balance of `505` tokens should
309      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
310      *
311      * Tokens usually opt for a value of 18, imitating the relationship between
312      * Ether and Wei. This is the value {ERC20} uses, unless this function is
313      * overridden;
314      *
315      * NOTE: This information is only used for _display_ purposes: it in
316      * no way affects any of the arithmetic of the contract, including
317      * {IERC20-balanceOf} and {IERC20-transfer}.
318      */
319     function decimals() public view virtual override returns (uint8) {
320         return 18;
321     }
322 
323     /**
324      * @dev See {IERC20-totalSupply}.
325      */
326     function totalSupply() public view virtual override returns (uint256) {
327         return _totalSupply;
328     }
329 
330     /**
331      * @dev See {IERC20-balanceOf}.
332      */
333     function balanceOf(address account) public view virtual override returns (uint256) {
334         return _balances[account];
335     }
336 
337     /**
338      * @dev See {IERC20-transfer}.
339      *
340      * Requirements:
341      *
342      * - `recipient` cannot be the zero address.
343      * - the caller must have a balance of at least `amount`.
344      */
345     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
346         _transfer(_msgSender(), recipient, amount);
347         return true;
348     }
349 
350     /**
351      * @dev See {IERC20-allowance}.
352      */
353     function allowance(address owner, address spender) public view virtual override returns (uint256) {
354         return _allowances[owner][spender];
355     }
356 
357     /**
358      * @dev See {IERC20-approve}.
359      *
360      * Requirements:
361      *
362      * - `spender` cannot be the zero address.
363      */
364     function approve(address spender, uint256 amount) public virtual override returns (bool) {
365         _approve(_msgSender(), spender, amount);
366         return true;
367     }
368 
369     /**
370      * @dev See {IERC20-transferFrom}.
371      *
372      * Emits an {Approval} event indicating the updated allowance. This is not
373      * required by the EIP. See the note at the beginning of {ERC20}.
374      *
375      * Requirements:
376      *
377      * - `sender` and `recipient` cannot be the zero address.
378      * - `sender` must have a balance of at least `amount`.
379      * - the caller must have allowance for ``sender``'s tokens of at least
380      * `amount`.
381      */
382     function transferFrom(
383         address sender,
384         address recipient,
385         uint256 amount
386     ) public virtual override returns (bool) {
387         _transfer(sender, recipient, amount);
388 
389         uint256 currentAllowance = _allowances[sender][_msgSender()];
390         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
391         unchecked {
392             _approve(sender, _msgSender(), currentAllowance - amount);
393         }
394 
395         return true;
396     }
397 
398     /**
399      * @dev Atomically increases the allowance granted to `spender` by the caller.
400      *
401      * This is an alternative to {approve} that can be used as a mitigation for
402      * problems described in {IERC20-approve}.
403      *
404      * Emits an {Approval} event indicating the updated allowance.
405      *
406      * Requirements:
407      *
408      * - `spender` cannot be the zero address.
409      */
410     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
411         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
412         return true;
413     }
414 
415     /**
416      * @dev Atomically decreases the allowance granted to `spender` by the caller.
417      *
418      * This is an alternative to {approve} that can be used as a mitigation for
419      * problems described in {IERC20-approve}.
420      *
421      * Emits an {Approval} event indicating the updated allowance.
422      *
423      * Requirements:
424      *
425      * - `spender` cannot be the zero address.
426      * - `spender` must have allowance for the caller of at least
427      * `subtractedValue`.
428      */
429     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
430         uint256 currentAllowance = _allowances[_msgSender()][spender];
431         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
432         unchecked {
433             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
434         }
435 
436         return true;
437     }
438 
439     /**
440      * @dev Moves `amount` of tokens from `sender` to `recipient`.
441      *
442      * This internal function is equivalent to {transfer}, and can be used to
443      * e.g. implement automatic token fees, slashing mechanisms, etc.
444      *
445      * Emits a {Transfer} event.
446      *
447      * Requirements:
448      *
449      * - `sender` cannot be the zero address.
450      * - `recipient` cannot be the zero address.
451      * - `sender` must have a balance of at least `amount`.
452      */
453     function _transfer(
454         address sender,
455         address recipient,
456         uint256 amount
457     ) internal virtual {
458         require(sender != address(0), "ERC20: transfer from the zero address");
459         require(recipient != address(0), "ERC20: transfer to the zero address");
460 
461         _beforeTokenTransfer(sender, recipient, amount);
462 
463         uint256 senderBalance = _balances[sender];
464         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
465         unchecked {
466             _balances[sender] = senderBalance - amount;
467         }
468         _balances[recipient] += amount;
469 
470         emit Transfer(sender, recipient, amount);
471 
472         _afterTokenTransfer(sender, recipient, amount);
473     }
474 
475     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
476      * the total supply.
477      *
478      * Emits a {Transfer} event with `from` set to the zero address.
479      *
480      * Requirements:
481      *
482      * - `account` cannot be the zero address.
483      */
484     function _mint(address account, uint256 amount) internal virtual {
485         require(account != address(0), "ERC20: mint to the zero address");
486 
487         _beforeTokenTransfer(address(0), account, amount);
488 
489         _totalSupply += amount;
490         _balances[account] += amount;
491         emit Transfer(address(0), account, amount);
492 
493         _afterTokenTransfer(address(0), account, amount);
494     }
495 
496     /**
497      * @dev Destroys `amount` tokens from `account`, reducing the
498      * total supply.
499      *
500      * Emits a {Transfer} event with `to` set to the zero address.
501      *
502      * Requirements:
503      *
504      * - `account` cannot be the zero address.
505      * - `account` must have at least `amount` tokens.
506      */
507     function _burn(address account, uint256 amount) internal virtual {
508         require(account != address(0), "ERC20: burn from the zero address");
509 
510         _beforeTokenTransfer(account, address(0), amount);
511 
512         uint256 accountBalance = _balances[account];
513         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
514         unchecked {
515             _balances[account] = accountBalance - amount;
516         }
517         _totalSupply -= amount;
518 
519         emit Transfer(account, address(0), amount);
520 
521         _afterTokenTransfer(account, address(0), amount);
522     }
523 
524     /**
525      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
526      *
527      * This internal function is equivalent to `approve`, and can be used to
528      * e.g. set automatic allowances for certain subsystems, etc.
529      *
530      * Emits an {Approval} event.
531      *
532      * Requirements:
533      *
534      * - `owner` cannot be the zero address.
535      * - `spender` cannot be the zero address.
536      */
537     function _approve(
538         address owner,
539         address spender,
540         uint256 amount
541     ) internal virtual {
542         require(owner != address(0), "ERC20: approve from the zero address");
543         require(spender != address(0), "ERC20: approve to the zero address");
544 
545         _allowances[owner][spender] = amount;
546         emit Approval(owner, spender, amount);
547     }
548 
549     /**
550      * @dev Hook that is called before any transfer of tokens. This includes
551      * minting and burning.
552      *
553      * Calling conditions:
554      *
555      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
556      * will be transferred to `to`.
557      * - when `from` is zero, `amount` tokens will be minted for `to`.
558      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
559      * - `from` and `to` are never both zero.
560      *
561      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
562      */
563     function _beforeTokenTransfer(
564         address from,
565         address to,
566         uint256 amount
567     ) internal virtual {}
568 
569     /**
570      * @dev Hook that is called after any transfer of tokens. This includes
571      * minting and burning.
572      *
573      * Calling conditions:
574      *
575      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
576      * has been transferred to `to`.
577      * - when `from` is zero, `amount` tokens have been minted for `to`.
578      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
579      * - `from` and `to` are never both zero.
580      *
581      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
582      */
583     function _afterTokenTransfer(
584         address from,
585         address to,
586         uint256 amount
587     ) internal virtual {}
588 }
589 
590 pragma solidity ^0.8.0;
591 
592 
593 contract ChinaCoin is Ownable, ERC20 {
594     bool public limited;
595     uint256 public maxHoldingAmount;
596     uint256 public minHoldingAmount;
597     address public uniswapV2Pair;
598     mapping(address => bool) public blacklists;
599 
600     constructor(uint256 _totalSupply) ERC20("China Coin", "CHINA") {
601         _mint(msg.sender, _totalSupply);
602     }
603 
604     function blacklist(address _address, bool _isBlacklisting) external onlyOwner {
605         blacklists[_address] = _isBlacklisting;
606     }
607 
608     function setRule(bool _limited, uint256 _maxHoldingAmount, uint256 _minHoldingAmount) external onlyOwner {
609         limited = _limited;
610         maxHoldingAmount = _maxHoldingAmount;
611         minHoldingAmount = _minHoldingAmount;
612     }
613 
614     function _beforeTokenTransfer(
615         address from,
616         address to,
617         uint256 amount
618     ) override internal virtual {
619         require(!blacklists[to] && !blacklists[from], "Blacklisted");
620 
621         if (limited && from == uniswapV2Pair) {
622             require(super.balanceOf(to) + amount <= maxHoldingAmount && super.balanceOf(to) + amount >= minHoldingAmount, "Forbid");
623         }
624     }
625 
626     function burn(uint256 value) external {
627         _burn(msg.sender, value);
628     }
629 }