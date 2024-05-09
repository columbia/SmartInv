1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
3 
4 /**
5  
6     /$$    /$$$$$$$  /$$   /$$ /$$      /$$ /$$$$$$$ 
7   /$$$$$$ | $$__  $$| $$  | $$| $$$    /$$$| $$__  $$
8  /$$__  $$| $$  \ $$| $$  | $$| $$$$  /$$$$| $$  \ $$
9 | $$  \__/| $$$$$$$/| $$  | $$| $$ $$/$$ $$| $$$$$$$/
10 |  $$$$$$ | $$____/ | $$  | $$| $$  $$$| $$| $$____/ 
11  \____  $$| $$      | $$  | $$| $$\  $ | $$| $$      
12  /$$  \ $$| $$      |  $$$$$$/| $$ \/  | $$| $$      
13 |  $$$$$$/|__/       \______/ |__/     |__/|__/      
14  \_  $$_/                                            
15    \__/                                              
16                                                      
17 */
18 
19 //Telegram: https://t.me/pumpcoineth
20 
21 
22 pragma solidity ^0.8.0;
23 
24 /**
25  * @dev Provides information about the current execution context, including the
26  * sender of the transaction and its data. While these are generally available
27  * via msg.sender and msg.data, they should not be accessed in such a direct
28  * manner, since when dealing with meta-transactions the account sending and
29  * paying for execution may not be the actual sender (as far as an application
30  * is concerned).
31  *
32  * This contract is only required for intermediate, library-like contracts.
33  */
34 abstract contract Context {
35     function _msgSender() internal view virtual returns (address) {
36         return msg.sender;
37     }
38 
39     function _msgData() internal view virtual returns (bytes calldata) {
40         return msg.data;
41     }
42 }
43 
44 
45 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.0
46 
47 
48 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
49 
50 pragma solidity ^0.8.0;
51 
52 /**
53  * @dev Contract module which provides a basic access control mechanism, where
54  * there is an account (an owner) that can be granted exclusive access to
55  * specific functions.
56  *
57  * By default, the owner account will be the one that deploys the contract. This
58  * can later be changed with {transferOwnership}.
59  *
60  * This module is used through inheritance. It will make available the modifier
61  * `onlyOwner`, which can be applied to your functions to restrict their use to
62  * the owner.
63  */
64 abstract contract Ownable is Context {
65     address private _owner;
66 
67     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
68 
69     /**
70      * @dev Initializes the contract setting the deployer as the initial owner.
71      */
72     constructor() {
73         _transferOwnership(_msgSender());
74     }
75 
76     /**
77      * @dev Returns the address of the current owner.
78      */
79     function owner() public view virtual returns (address) {
80         return _owner;
81     }
82 
83     /**
84      * @dev Throws if called by any account other than the owner.
85      */
86     modifier onlyOwner() {
87         require(owner() == _msgSender(), "Ownable: caller is not the owner");
88         _;
89     }
90 
91     /**
92      * @dev Leaves the contract without owner. It will not be possible to call
93      * `onlyOwner` functions anymore. Can only be called by the current owner.
94      *
95      * NOTE: Renouncing ownership will leave the contract without an owner,
96      * thereby removing any functionality that is only available to the owner.
97      */
98     function renounceOwnership() public virtual onlyOwner {
99         _transferOwnership(address(0));
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      * Can only be called by the current owner.
105      */
106     function transferOwnership(address newOwner) public virtual onlyOwner {
107         require(newOwner != address(0), "Ownable: new owner is the zero address");
108         _transferOwnership(newOwner);
109     }
110 
111     /**
112      * @dev Transfers ownership of the contract to a new account (`newOwner`).
113      * Internal function without access restriction.
114      */
115     function _transferOwnership(address newOwner) internal virtual {
116         address oldOwner = _owner;
117         _owner = newOwner;
118         emit OwnershipTransferred(oldOwner, newOwner);
119     }
120 }
121 
122 
123 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.4.0
124 
125 
126 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
127 
128 pragma solidity ^0.8.0;
129 
130 /**
131  * @dev Interface of the ERC20 standard as defined in the EIP.
132  */
133 interface IERC20 {
134     /**
135      * @dev Returns the amount of tokens in existence.
136      */
137     function totalSupply() external view returns (uint256);
138 
139     /**
140      * @dev Returns the amount of tokens owned by `account`.
141      */
142     function balanceOf(address account) external view returns (uint256);
143 
144     /**
145      * @dev Moves `amount` tokens from the caller's account to `recipient`.
146      *
147      * Returns a boolean value indicating whether the operation succeeded.
148      *
149      * Emits a {Transfer} event.
150      */
151     function transfer(address recipient, uint256 amount) external returns (bool);
152 
153     /**
154      * @dev Returns the remaining number of tokens that `spender` will be
155      * allowed to spend on behalf of `owner` through {transferFrom}. This is
156      * zero by default.
157      *
158      * This value changes when {approve} or {transferFrom} are called.
159      */
160     function allowance(address owner, address spender) external view returns (uint256);
161 
162     /**
163      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
164      *
165      * Returns a boolean value indicating whether the operation succeeded.
166      *
167      * IMPORTANT: Beware that changing an allowance with this method brings the risk
168      * that someone may use both the old and the new allowance by unfortunate
169      * transaction ordering. One possible solution to mitigate this race
170      * condition is to first reduce the spender's allowance to 0 and set the
171      * desired value afterwards:
172      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
173      *
174      * Emits an {Approval} event.
175      */
176     function approve(address spender, uint256 amount) external returns (bool);
177 
178     /**
179      * @dev Moves `amount` tokens from `sender` to `recipient` using the
180      * allowance mechanism. `amount` is then deducted from the caller's
181      * allowance.
182      *
183      * Returns a boolean value indicating whether the operation succeeded.
184      *
185      * Emits a {Transfer} event.
186      */
187     function transferFrom(
188         address sender,
189         address recipient,
190         uint256 amount
191     ) external returns (bool);
192 
193     /**
194      * @dev Emitted when `value` tokens are moved from one account (`from`) to
195      * another (`to`).
196      *
197      * Note that `value` may be zero.
198      */
199     event Transfer(address indexed from, address indexed to, uint256 value);
200 
201     /**
202      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
203      * a call to {approve}. `value` is the new allowance.
204      */
205     event Approval(address indexed owner, address indexed spender, uint256 value);
206 }
207 
208 
209 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.4.0
210 
211 
212 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
213 
214 pragma solidity ^0.8.0;
215 
216 /**
217  * @dev Interface for the optional metadata functions from the ERC20 standard.
218  *
219  * _Available since v4.1._
220  */
221 interface IERC20Metadata is IERC20 {
222     /**
223      * @dev Returns the name of the token.
224      */
225     function name() external view returns (string memory);
226 
227     /**
228      * @dev Returns the symbol of the token.
229      */
230     function symbol() external view returns (string memory);
231 
232     /**
233      * @dev Returns the decimals places of the token.
234      */
235     function decimals() external view returns (uint8);
236 }
237 
238 
239 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.4.0
240 
241 
242 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
243 
244 pragma solidity ^0.8.0;
245 
246 
247 
248 /**
249  * @dev Implementation of the {IERC20} interface.
250  *
251  * This implementation is agnostic to the way tokens are created. This means
252  * that a supply mechanism has to be added in a derived contract using {_mint}.
253  * For a generic mechanism see {ERC20PresetMinterPauser}.
254  *
255  * TIP: For a detailed writeup see our guide
256  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
257  * to implement supply mechanisms].
258  *
259  * We have followed general OpenZeppelin Contracts guidelines: functions revert
260  * instead returning `false` on failure. This behavior is nonetheless
261  * conventional and does not conflict with the expectations of ERC20
262  * applications.
263  *
264  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
265  * This allows applications to reconstruct the allowance for all accounts just
266  * by listening to said events. Other implementations of the EIP may not emit
267  * these events, as it isn't required by the specification.
268  *
269  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
270  * functions have been added to mitigate the well-known issues around setting
271  * allowances. See {IERC20-approve}.
272  */
273 contract ERC20 is Context, IERC20, IERC20Metadata {
274     mapping(address => uint256) private _balances;
275 
276     mapping(address => mapping(address => uint256)) private _allowances;
277 
278     uint256 private _totalSupply;
279 
280     string private _name;
281     string private _symbol;
282 
283     /**
284      * @dev Sets the values for {name} and {symbol}.
285      *
286      * The default value of {decimals} is 18. To select a different value for
287      * {decimals} you should overload it.
288      *
289      * All two of these values are immutable: they can only be set once during
290      * construction.
291      */
292     constructor(string memory name_, string memory symbol_) {
293         _name = name_;
294         _symbol = symbol_;
295     }
296 
297     /**
298      * @dev Returns the name of the token.
299      */
300     function name() public view virtual override returns (string memory) {
301         return _name;
302     }
303 
304     /**
305      * @dev Returns the symbol of the token, usually a shorter version of the
306      * name.
307      */
308     function symbol() public view virtual override returns (string memory) {
309         return _symbol;
310     }
311 
312     /**
313      * @dev Returns the number of decimals used to get its user representation.
314      * For example, if `decimals` equals `2`, a balance of `505` tokens should
315      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
316      *
317      * Tokens usually opt for a value of 18, imitating the relationship between
318      * Ether and Wei. This is the value {ERC20} uses, unless this function is
319      * overridden;
320      *
321      * NOTE: This information is only used for _display_ purposes: it in
322      * no way affects any of the arithmetic of the contract, including
323      * {IERC20-balanceOf} and {IERC20-transfer}.
324      */
325     function decimals() public view virtual override returns (uint8) {
326         return 18;
327     }
328 
329     /**
330      * @dev See {IERC20-totalSupply}.
331      */
332     function totalSupply() public view virtual override returns (uint256) {
333         return _totalSupply;
334     }
335 
336     /**
337      * @dev See {IERC20-balanceOf}.
338      */
339     function balanceOf(address account) public view virtual override returns (uint256) {
340         return _balances[account];
341     }
342 
343     /**
344      * @dev See {IERC20-transfer}.
345      *
346      * Requirements:
347      *
348      * - `recipient` cannot be the zero address.
349      * - the caller must have a balance of at least `amount`.
350      */
351     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
352         _transfer(_msgSender(), recipient, amount);
353         return true;
354     }
355 
356     /**
357      * @dev See {IERC20-allowance}.
358      */
359     function allowance(address owner, address spender) public view virtual override returns (uint256) {
360         return _allowances[owner][spender];
361     }
362 
363     /**
364      * @dev See {IERC20-approve}.
365      *
366      * Requirements:
367      *
368      * - `spender` cannot be the zero address.
369      */
370     function approve(address spender, uint256 amount) public virtual override returns (bool) {
371         _approve(_msgSender(), spender, amount);
372         return true;
373     }
374 
375     /**
376      * @dev See {IERC20-transferFrom}.
377      *
378      * Emits an {Approval} event indicating the updated allowance. This is not
379      * required by the EIP. See the note at the beginning of {ERC20}.
380      *
381      * Requirements:
382      *
383      * - `sender` and `recipient` cannot be the zero address.
384      * - `sender` must have a balance of at least `amount`.
385      * - the caller must have allowance for ``sender``'s tokens of at least
386      * `amount`.
387      */
388     function transferFrom(
389         address sender,
390         address recipient,
391         uint256 amount
392     ) public virtual override returns (bool) {
393         _transfer(sender, recipient, amount);
394 
395         uint256 currentAllowance = _allowances[sender][_msgSender()];
396         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
397         unchecked {
398             _approve(sender, _msgSender(), currentAllowance - amount);
399         }
400 
401         return true;
402     }
403 
404     /**
405      * @dev Atomically increases the allowance granted to `spender` by the caller.
406      *
407      * This is an alternative to {approve} that can be used as a mitigation for
408      * problems described in {IERC20-approve}.
409      *
410      * Emits an {Approval} event indicating the updated allowance.
411      *
412      * Requirements:
413      *
414      * - `spender` cannot be the zero address.
415      */
416     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
417         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
418         return true;
419     }
420 
421     /**
422      * @dev Atomically decreases the allowance granted to `spender` by the caller.
423      *
424      * This is an alternative to {approve} that can be used as a mitigation for
425      * problems described in {IERC20-approve}.
426      *
427      * Emits an {Approval} event indicating the updated allowance.
428      *
429      * Requirements:
430      *
431      * - `spender` cannot be the zero address.
432      * - `spender` must have allowance for the caller of at least
433      * `subtractedValue`.
434      */
435     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
436         uint256 currentAllowance = _allowances[_msgSender()][spender];
437         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
438         unchecked {
439             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
440         }
441 
442         return true;
443     }
444 
445     /**
446      * @dev Moves `amount` of tokens from `sender` to `recipient`.
447      *
448      * This internal function is equivalent to {transfer}, and can be used to
449      * e.g. implement automatic token fees, slashing mechanisms, etc.
450      *
451      * Emits a {Transfer} event.
452      *
453      * Requirements:
454      *
455      * - `sender` cannot be the zero address.
456      * - `recipient` cannot be the zero address.
457      * - `sender` must have a balance of at least `amount`.
458      */
459     function _transfer(
460         address sender,
461         address recipient,
462         uint256 amount
463     ) internal virtual {
464         require(sender != address(0), "ERC20: transfer from the zero address");
465         require(recipient != address(0), "ERC20: transfer to the zero address");
466 
467         _beforeTokenTransfer(sender, recipient, amount);
468 
469         uint256 senderBalance = _balances[sender];
470         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
471         unchecked {
472             _balances[sender] = senderBalance - amount;
473         }
474         _balances[recipient] += amount;
475 
476         emit Transfer(sender, recipient, amount);
477 
478         _afterTokenTransfer(sender, recipient, amount);
479     }
480 
481     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
482      * the total supply.
483      *
484      * Emits a {Transfer} event with `from` set to the zero address.
485      *
486      * Requirements:
487      *
488      * - `account` cannot be the zero address.
489      */
490     function _mint(address account, uint256 amount) internal virtual {
491         require(account != address(0), "ERC20: mint to the zero address");
492 
493         _beforeTokenTransfer(address(0), account, amount);
494 
495         _totalSupply += amount;
496         _balances[account] += amount;
497         emit Transfer(address(0), account, amount);
498 
499         _afterTokenTransfer(address(0), account, amount);
500     }
501 
502     /**
503      * @dev Destroys `amount` tokens from `account`, reducing the
504      * total supply.
505      *
506      * Emits a {Transfer} event with `to` set to the zero address.
507      *
508      * Requirements:
509      *
510      * - `account` cannot be the zero address.
511      * - `account` must have at least `amount` tokens.
512      */
513     function _burn(address account, uint256 amount) internal virtual {
514         require(account != address(0), "ERC20: burn from the zero address");
515 
516         _beforeTokenTransfer(account, address(0), amount);
517 
518         uint256 accountBalance = _balances[account];
519         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
520         unchecked {
521             _balances[account] = accountBalance - amount;
522         }
523         _totalSupply -= amount;
524 
525         emit Transfer(account, address(0), amount);
526 
527         _afterTokenTransfer(account, address(0), amount);
528     }
529 
530     /**
531      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
532      *
533      * This internal function is equivalent to `approve`, and can be used to
534      * e.g. set automatic allowances for certain subsystems, etc.
535      *
536      * Emits an {Approval} event.
537      *
538      * Requirements:
539      *
540      * - `owner` cannot be the zero address.
541      * - `spender` cannot be the zero address.
542      */
543     function _approve(
544         address owner,
545         address spender,
546         uint256 amount
547     ) internal virtual {
548         require(owner != address(0), "ERC20: approve from the zero address");
549         require(spender != address(0), "ERC20: approve to the zero address");
550 
551         _allowances[owner][spender] = amount;
552         emit Approval(owner, spender, amount);
553     }
554 
555     /**
556      * @dev Hook that is called before any transfer of tokens. This includes
557      * minting and burning.
558      *
559      * Calling conditions:
560      *
561      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
562      * will be transferred to `to`.
563      * - when `from` is zero, `amount` tokens will be minted for `to`.
564      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
565      * - `from` and `to` are never both zero.
566      *
567      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
568      */
569     function _beforeTokenTransfer(
570         address from,
571         address to,
572         uint256 amount
573     ) internal virtual {}
574 
575     /**
576      * @dev Hook that is called after any transfer of tokens. This includes
577      * minting and burning.
578      *
579      * Calling conditions:
580      *
581      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
582      * has been transferred to `to`.
583      * - when `from` is zero, `amount` tokens have been minted for `to`.
584      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
585      * - `from` and `to` are never both zero.
586      *
587      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
588      */
589     function _afterTokenTransfer(
590         address from,
591         address to,
592         uint256 amount
593     ) internal virtual {}
594 }
595 
596 
597 pragma solidity ^0.8.0;
598 
599 
600 contract PUMP is Ownable, ERC20 {
601     bool public limited;
602     uint256 public maxHoldingAmount;
603     address public uniswapV2Pair;
604 
605     constructor(uint256 _totalSupply) ERC20("PUMP", "PUMP") {
606         _mint(msg.sender, _totalSupply * 10**18);
607     }
608 
609     function setRule(bool _limited, address _uniswapV2Pair, uint256 _maxHoldingAmount) external onlyOwner {
610         limited = _limited;
611         uniswapV2Pair = _uniswapV2Pair;
612         maxHoldingAmount = _maxHoldingAmount;
613     }
614 
615     function _beforeTokenTransfer(
616         address from,
617         address to,
618         uint256 amount
619     ) override internal virtual {
620 
621         if (uniswapV2Pair == address(0)) {
622             require(from == owner() || to == owner(), "trading is not started");
623             return;
624         }
625 
626         if (limited && from == uniswapV2Pair) {
627             require(super.balanceOf(to) + amount <= maxHoldingAmount, "Forbid");
628         }
629     }
630 
631     function burn(uint256 value) external {
632         _burn(msg.sender, value);
633     }
634 }