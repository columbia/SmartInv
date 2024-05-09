1 /**
2 
3 ▓█████▄  ▒█████   ▒█████   ███▄ ▄███▓▓█████  ██▀███  
4 ▒██▀ ██▌▒██▒  ██▒▒██▒  ██▒▓██▒▀█▀ ██▒▓█   ▀ ▓██ ▒ ██▒
5 ░██   █▌▒██░  ██▒▒██░  ██▒▓██    ▓██░▒███   ▓██ ░▄█ ▒
6 ░▓█▄   ▌▒██   ██░▒██   ██░▒██    ▒██ ▒▓█  ▄ ▒██▀▀█▄  
7 ░▒████▓ ░ ████▓▒░░ ████▓▒░▒██▒   ░██▒░▒████▒░██▓ ▒██▒
8  ▒▒▓  ▒ ░ ▒░▒░▒░ ░ ▒░▒░▒░ ░ ▒░   ░  ░░░ ▒░ ░░ ▒▓ ░▒▓░
9  ░ ▒  ▒   ░ ▒ ▒░   ░ ▒ ▒░ ░  ░      ░ ░ ░  ░  ░▒ ░ ▒░
10  ░ ░  ░ ░ ░ ░ ▒  ░ ░ ░ ▒  ░      ░      ░     ░░   ░ 
11    ░        ░ ░      ░ ░         ░      ░  ░   ░     
12  ░  
13 
14 Web: doomer.ai
15 TG: t.me/doomer_based    
16 
17 */                                                      
18 
19 
20 // File @openzeppelin/contracts/utils/Context.sol@v4.4.0
21 
22 // SPDX-License-Identifier: MIT
23 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
24 
25 pragma solidity ^0.8.0;
26 
27 /**
28  * @dev Provides information about the current execution context, including the
29  * sender of the transaction and its data. While these are generally available
30  * via msg.sender and msg.data, they should not be accessed in such a direct
31  * manner, since when dealing with meta-transactions the account sending and
32  * paying for execution may not be the actual sender (as far as an application
33  * is concerned).
34  *
35  * This contract is only required for intermediate, library-like contracts.
36  */
37 abstract contract Context {
38     function _msgSender() internal view virtual returns (address) {
39         return msg.sender;
40     }
41 
42     function _msgData() internal view virtual returns (bytes calldata) {
43         return msg.data;
44     }
45 }
46 
47 
48 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.0
49 
50 
51 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
52 
53 pragma solidity ^0.8.0;
54 
55 /**
56  * @dev Contract module which provides a basic access control mechanism, where
57  * there is an account (an owner) that can be granted exclusive access to
58  * specific functions.
59  *
60  * By default, the owner account will be the one that deploys the contract. This
61  * can later be changed with {transferOwnership}.
62  *
63  * This module is used through inheritance. It will make available the modifier
64  * `onlyOwner`, which can be applied to your functions to restrict their use to
65  * the owner.
66  */
67 abstract contract Ownable is Context {
68     address private _owner;
69 
70     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
71 
72     /**
73      * @dev Initializes the contract setting the deployer as the initial owner.
74      */
75     constructor() {
76         _transferOwnership(_msgSender());
77     }
78 
79     /**
80      * @dev Returns the address of the current owner.
81      */
82     function owner() public view virtual returns (address) {
83         return _owner;
84     }
85 
86     /**
87      * @dev Throws if called by any account other than the owner.
88      */
89     modifier onlyOwner() {
90         require(owner() == _msgSender(), "Ownable: caller is not the owner");
91         _;
92     }
93 
94     /**
95      * @dev Leaves the contract without owner. It will not be possible to call
96      * `onlyOwner` functions anymore. Can only be called by the current owner.
97      *
98      * NOTE: Renouncing ownership will leave the contract without an owner,
99      * thereby removing any functionality that is only available to the owner.
100      */
101     function renounceOwnership() public virtual onlyOwner {
102         _transferOwnership(address(0));
103     }
104 
105     /**
106      * @dev Transfers ownership of the contract to a new account (`newOwner`).
107      * Can only be called by the current owner.
108      */
109     function transferOwnership(address newOwner) public virtual onlyOwner {
110         require(newOwner != address(0), "Ownable: new owner is the zero address");
111         _transferOwnership(newOwner);
112     }
113 
114     /**
115      * @dev Transfers ownership of the contract to a new account (`newOwner`).
116      * Internal function without access restriction.
117      */
118     function _transferOwnership(address newOwner) internal virtual {
119         address oldOwner = _owner;
120         _owner = newOwner;
121         emit OwnershipTransferred(oldOwner, newOwner);
122     }
123 }
124 
125 
126 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.4.0
127 
128 
129 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
130 
131 pragma solidity ^0.8.0;
132 
133 /**
134  * @dev Interface of the ERC20 standard as defined in the EIP.
135  */
136 interface IERC20 {
137     /**
138      * @dev Returns the amount of tokens in existence.
139      */
140     function totalSupply() external view returns (uint256);
141 
142     /**
143      * @dev Returns the amount of tokens owned by `account`.
144      */
145     function balanceOf(address account) external view returns (uint256);
146 
147     /**
148      * @dev Moves `amount` tokens from the caller's account to `recipient`.
149      *
150      * Returns a boolean value indicating whether the operation succeeded.
151      *
152      * Emits a {Transfer} event.
153      */
154     function transfer(address recipient, uint256 amount) external returns (bool);
155 
156     /**
157      * @dev Returns the remaining number of tokens that `spender` will be
158      * allowed to spend on behalf of `owner` through {transferFrom}. This is
159      * zero by default.
160      *
161      * This value changes when {approve} or {transferFrom} are called.
162      */
163     function allowance(address owner, address spender) external view returns (uint256);
164 
165     /**
166      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
167      *
168      * Returns a boolean value indicating whether the operation succeeded.
169      *
170      * IMPORTANT: Beware that changing an allowance with this method brings the risk
171      * that someone may use both the old and the new allowance by unfortunate
172      * transaction ordering. One possible solution to mitigate this race
173      * condition is to first reduce the spender's allowance to 0 and set the
174      * desired value afterwards:
175      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
176      *
177      * Emits an {Approval} event.
178      */
179     function approve(address spender, uint256 amount) external returns (bool);
180 
181     /**
182      * @dev Moves `amount` tokens from `sender` to `recipient` using the
183      * allowance mechanism. `amount` is then deducted from the caller's
184      * allowance.
185      *
186      * Returns a boolean value indicating whether the operation succeeded.
187      *
188      * Emits a {Transfer} event.
189      */
190     function transferFrom(
191         address sender,
192         address recipient,
193         uint256 amount
194     ) external returns (bool);
195 
196     /**
197      * @dev Emitted when `value` tokens are moved from one account (`from`) to
198      * another (`to`).
199      *
200      * Note that `value` may be zero.
201      */
202     event Transfer(address indexed from, address indexed to, uint256 value);
203 
204     /**
205      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
206      * a call to {approve}. `value` is the new allowance.
207      */
208     event Approval(address indexed owner, address indexed spender, uint256 value);
209 }
210 
211 
212 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.4.0
213 
214 
215 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
216 
217 pragma solidity ^0.8.0;
218 
219 /**
220  * @dev Interface for the optional metadata functions from the ERC20 standard.
221  *
222  * _Available since v4.1._
223  */
224 interface IERC20Metadata is IERC20 {
225     /**
226      * @dev Returns the name of the token.
227      */
228     function name() external view returns (string memory);
229 
230     /**
231      * @dev Returns the symbol of the token.
232      */
233     function symbol() external view returns (string memory);
234 
235     /**
236      * @dev Returns the decimals places of the token.
237      */
238     function decimals() external view returns (uint8);
239 }
240 
241 
242 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.4.0
243 
244 
245 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
246 
247 pragma solidity ^0.8.0;
248 
249 
250 
251 /**
252  * @dev Implementation of the {IERC20} interface.
253  *
254  * This implementation is agnostic to the way tokens are created. This means
255  * that a supply mechanism has to be added in a derived contract using {_mint}.
256  * For a generic mechanism see {ERC20PresetMinterPauser}.
257  *
258  * TIP: For a detailed writeup see our guide
259  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
260  * to implement supply mechanisms].
261  *
262  * We have followed general OpenZeppelin Contracts guidelines: functions revert
263  * instead returning `false` on failure. This behavior is nonetheless
264  * conventional and does not conflict with the expectations of ERC20
265  * applications.
266  *
267  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
268  * This allows applications to reconstruct the allowance for all accounts just
269  * by listening to said events. Other implementations of the EIP may not emit
270  * these events, as it isn't required by the specification.
271  *
272  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
273  * functions have been added to mitigate the well-known issues around setting
274  * allowances. See {IERC20-approve}.
275  */
276 contract ERC20 is Context, IERC20, IERC20Metadata {
277     mapping(address => uint256) private _balances;
278 
279     mapping(address => mapping(address => uint256)) private _allowances;
280 
281     uint256 private _totalSupply;
282 
283     string private _name;
284     string private _symbol;
285 
286     /**
287      * @dev Sets the values for {name} and {symbol}.
288      *
289      * The default value of {decimals} is 18. To select a different value for
290      * {decimals} you should overload it.
291      *
292      * All two of these values are immutable: they can only be set once during
293      * construction.
294      */
295     constructor(string memory name_, string memory symbol_) {
296         _name = name_;
297         _symbol = symbol_;
298     }
299 
300     /**
301      * @dev Returns the name of the token.
302      */
303     function name() public view virtual override returns (string memory) {
304         return _name;
305     }
306 
307     /**
308      * @dev Returns the symbol of the token, usually a shorter version of the
309      * name.
310      */
311     function symbol() public view virtual override returns (string memory) {
312         return _symbol;
313     }
314 
315     /**
316      * @dev Returns the number of decimals used to get its user representation.
317      * For example, if `decimals` equals `2`, a balance of `505` tokens should
318      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
319      *
320      * Tokens usually opt for a value of 18, imitating the relationship between
321      * Ether and Wei. This is the value {ERC20} uses, unless this function is
322      * overridden;
323      *
324      * NOTE: This information is only used for _display_ purposes: it in
325      * no way affects any of the arithmetic of the contract, including
326      * {IERC20-balanceOf} and {IERC20-transfer}.
327      */
328     function decimals() public view virtual override returns (uint8) {
329         return 18;
330     }
331 
332     /**
333      * @dev See {IERC20-totalSupply}.
334      */
335     function totalSupply() public view virtual override returns (uint256) {
336         return _totalSupply;
337     }
338 
339     /**
340      * @dev See {IERC20-balanceOf}.
341      */
342     function balanceOf(address account) public view virtual override returns (uint256) {
343         return _balances[account];
344     }
345 
346     /**
347      * @dev See {IERC20-transfer}.
348      *
349      * Requirements:
350      *
351      * - `recipient` cannot be the zero address.
352      * - the caller must have a balance of at least `amount`.
353      */
354     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
355         _transfer(_msgSender(), recipient, amount);
356         return true;
357     }
358 
359     /**
360      * @dev See {IERC20-allowance}.
361      */
362     function allowance(address owner, address spender) public view virtual override returns (uint256) {
363         return _allowances[owner][spender];
364     }
365 
366     /**
367      * @dev See {IERC20-approve}.
368      *
369      * Requirements:
370      *
371      * - `spender` cannot be the zero address.
372      */
373     function approve(address spender, uint256 amount) public virtual override returns (bool) {
374         _approve(_msgSender(), spender, amount);
375         return true;
376     }
377 
378     /**
379      * @dev See {IERC20-transferFrom}.
380      *
381      * Emits an {Approval} event indicating the updated allowance. This is not
382      * required by the EIP. See the note at the beginning of {ERC20}.
383      *
384      * Requirements:
385      *
386      * - `sender` and `recipient` cannot be the zero address.
387      * - `sender` must have a balance of at least `amount`.
388      * - the caller must have allowance for ``sender``'s tokens of at least
389      * `amount`.
390      */
391     function transferFrom(
392         address sender,
393         address recipient,
394         uint256 amount
395     ) public virtual override returns (bool) {
396         _transfer(sender, recipient, amount);
397 
398         uint256 currentAllowance = _allowances[sender][_msgSender()];
399         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
400         unchecked {
401             _approve(sender, _msgSender(), currentAllowance - amount);
402         }
403 
404         return true;
405     }
406 
407     /**
408      * @dev Atomically increases the allowance granted to `spender` by the caller.
409      *
410      * This is an alternative to {approve} that can be used as a mitigation for
411      * problems described in {IERC20-approve}.
412      *
413      * Emits an {Approval} event indicating the updated allowance.
414      *
415      * Requirements:
416      *
417      * - `spender` cannot be the zero address.
418      */
419     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
420         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
421         return true;
422     }
423 
424     /**
425      * @dev Atomically decreases the allowance granted to `spender` by the caller.
426      *
427      * This is an alternative to {approve} that can be used as a mitigation for
428      * problems described in {IERC20-approve}.
429      *
430      * Emits an {Approval} event indicating the updated allowance.
431      *
432      * Requirements:
433      *
434      * - `spender` cannot be the zero address.
435      * - `spender` must have allowance for the caller of at least
436      * `subtractedValue`.
437      */
438     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
439         uint256 currentAllowance = _allowances[_msgSender()][spender];
440         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
441         unchecked {
442             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
443         }
444 
445         return true;
446     }
447 
448     /**
449      * @dev Moves `amount` of tokens from `sender` to `recipient`.
450      *
451      * This internal function is equivalent to {transfer}, and can be used to
452      * e.g. implement automatic token fees, slashing mechanisms, etc.
453      *
454      * Emits a {Transfer} event.
455      *
456      * Requirements:
457      *
458      * - `sender` cannot be the zero address.
459      * - `recipient` cannot be the zero address.
460      * - `sender` must have a balance of at least `amount`.
461      */
462     function _transfer(
463         address sender,
464         address recipient,
465         uint256 amount
466     ) internal virtual {
467         require(sender != address(0), "ERC20: transfer from the zero address");
468         require(recipient != address(0), "ERC20: transfer to the zero address");
469 
470         _beforeTokenTransfer(sender, recipient, amount);
471 
472         uint256 senderBalance = _balances[sender];
473         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
474         unchecked {
475             _balances[sender] = senderBalance - amount;
476         }
477         _balances[recipient] += amount;
478 
479         emit Transfer(sender, recipient, amount);
480 
481         _afterTokenTransfer(sender, recipient, amount);
482     }
483 
484     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
485      * the total supply.
486      *
487      * Emits a {Transfer} event with `from` set to the zero address.
488      *
489      * Requirements:
490      *
491      * - `account` cannot be the zero address.
492      */
493     function _mint(address account, uint256 amount) internal virtual {
494         require(account != address(0), "ERC20: mint to the zero address");
495 
496         _beforeTokenTransfer(address(0), account, amount);
497 
498         _totalSupply += amount;
499         _balances[account] += amount;
500         emit Transfer(address(0), account, amount);
501 
502         _afterTokenTransfer(address(0), account, amount);
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
523         unchecked {
524             _balances[account] = accountBalance - amount;
525         }
526         _totalSupply -= amount;
527 
528         emit Transfer(account, address(0), amount);
529 
530         _afterTokenTransfer(account, address(0), amount);
531     }
532 
533     /**
534      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
535      *
536      * This internal function is equivalent to `approve`, and can be used to
537      * e.g. set automatic allowances for certain subsystems, etc.
538      *
539      * Emits an {Approval} event.
540      *
541      * Requirements:
542      *
543      * - `owner` cannot be the zero address.
544      * - `spender` cannot be the zero address.
545      */
546     function _approve(
547         address owner,
548         address spender,
549         uint256 amount
550     ) internal virtual {
551         require(owner != address(0), "ERC20: approve from the zero address");
552         require(spender != address(0), "ERC20: approve to the zero address");
553 
554         _allowances[owner][spender] = amount;
555         emit Approval(owner, spender, amount);
556     }
557 
558     /**
559      * @dev Hook that is called before any transfer of tokens. This includes
560      * minting and burning.
561      *
562      * Calling conditions:
563      *
564      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
565      * will be transferred to `to`.
566      * - when `from` is zero, `amount` tokens will be minted for `to`.
567      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
568      * - `from` and `to` are never both zero.
569      *
570      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
571      */
572     function _beforeTokenTransfer(
573         address from,
574         address to,
575         uint256 amount
576     ) internal virtual {}
577 
578     /**
579      * @dev Hook that is called after any transfer of tokens. This includes
580      * minting and burning.
581      *
582      * Calling conditions:
583      *
584      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
585      * has been transferred to `to`.
586      * - when `from` is zero, `amount` tokens have been minted for `to`.
587      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
588      * - `from` and `to` are never both zero.
589      *
590      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
591      */
592     function _afterTokenTransfer(
593         address from,
594         address to,
595         uint256 amount
596     ) internal virtual {}
597 }
598 
599 
600 // File contracts/Doomer.sol
601 
602 
603 
604 pragma solidity ^0.8.0;
605 
606 
607 contract DoomerToken is Ownable, ERC20 {
608     bool public limited;
609     uint256 public maxHoldingAmount;
610     uint256 public minHoldingAmount;
611     address public uniswapV2Pair;
612     mapping(address => bool) public blacklists;
613 
614     constructor(uint256 _totalSupply) ERC20("Doomer.ai", "DOOMER") {
615         _mint(msg.sender, _totalSupply);
616     }
617 
618     function blacklist(address _address, bool _isBlacklisting) external onlyOwner {
619         blacklists[_address] = _isBlacklisting;
620     }
621 
622     function setRule(bool _limited, address _uniswapV2Pair, uint256 _maxHoldingAmount, uint256 _minHoldingAmount) external onlyOwner {
623         limited = _limited;
624         uniswapV2Pair = _uniswapV2Pair;
625         maxHoldingAmount = _maxHoldingAmount;
626         minHoldingAmount = _minHoldingAmount;
627     }
628 
629     function _beforeTokenTransfer(
630         address from,
631         address to,
632         uint256 amount
633     ) override internal virtual {
634         require(!blacklists[to] && !blacklists[from], "Blacklisted");
635 
636         if (uniswapV2Pair == address(0)) {
637             require(from == owner() || to == owner(), "trading is not started");
638             return;
639         }
640 
641         if (limited && from == uniswapV2Pair) {
642             require(super.balanceOf(to) + amount <= maxHoldingAmount && super.balanceOf(to) + amount >= minHoldingAmount, "Forbid");
643         }
644     }
645 
646     function burn(uint256 value) external {
647         _burn(msg.sender, value);
648     }
649 }