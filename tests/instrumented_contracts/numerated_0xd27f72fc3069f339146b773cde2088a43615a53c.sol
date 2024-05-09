1 // bitconnnect.com 
2 
3 // Sources flattened with hardhat v2.7.0 https://hardhat.org
4 
5 // File @openzeppelin/contracts/utils/Context.sol@v4.4.0
6 
7 // SPDX-License-Identifier: MIT
8 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev Provides information about the current execution context, including the
14  * sender of the transaction and its data. While these are generally available
15  * via msg.sender and msg.data, they should not be accessed in such a direct
16  * manner, since when dealing with meta-transactions the account sending and
17  * paying for execution may not be the actual sender (as far as an application
18  * is concerned).
19  *
20  * This contract is only required for intermediate, library-like contracts.
21  */
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes calldata) {
28         return msg.data;
29     }
30 }
31 
32 
33 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.0
34 
35 
36 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
37 
38 pragma solidity ^0.8.0;
39 
40 /**
41  * @dev Contract module which provides a basic access control mechanism, where
42  * there is an account (an owner) that can be granted exclusive access to
43  * specific functions.
44  *
45  * By default, the owner account will be the one that deploys the contract. This
46  * can later be changed with {transferOwnership}.
47  *
48  * This module is used through inheritance. It will make available the modifier
49  * `onlyOwner`, which can be applied to your functions to restrict their use to
50  * the owner.
51  */
52 abstract contract Ownable is Context {
53     address private _owner;
54 
55     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56 
57     /**
58      * @dev Initializes the contract setting the deployer as the initial owner.
59      */
60     constructor() {
61         _transferOwnership(_msgSender());
62     }
63 
64     /**
65      * @dev Returns the address of the current owner.
66      */
67     function owner() public view virtual returns (address) {
68         return _owner;
69     }
70 
71     /**
72      * @dev Throws if called by any account other than the owner.
73      */
74     modifier onlyOwner() {
75         require(owner() == _msgSender(), "Ownable: caller is not the owner");
76         _;
77     }
78 
79     /**
80      * @dev Leaves the contract without owner. It will not be possible to call
81      * `onlyOwner` functions anymore. Can only be called by the current owner.
82      *
83      * NOTE: Renouncing ownership will leave the contract without an owner,
84      * thereby removing any functionality that is only available to the owner.
85      */
86     function renounceOwnership() public virtual onlyOwner {
87         _transferOwnership(address(0));
88     }
89 
90     /**
91      * @dev Transfers ownership of the contract to a new account (`newOwner`).
92      * Can only be called by the current owner.
93      */
94     function transferOwnership(address newOwner) public virtual onlyOwner {
95         require(newOwner != address(0), "Ownable: new owner is the zero address");
96         _transferOwnership(newOwner);
97     }
98 
99     /**
100      * @dev Transfers ownership of the contract to a new account (`newOwner`).
101      * Internal function without access restriction.
102      */
103     function _transferOwnership(address newOwner) internal virtual {
104         address oldOwner = _owner;
105         _owner = newOwner;
106         emit OwnershipTransferred(oldOwner, newOwner);
107     }
108 }
109 
110 
111 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.4.0
112 
113 
114 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
115 
116 pragma solidity ^0.8.0;
117 
118 /**
119  * @dev Interface of the ERC20 standard as defined in the EIP.
120  */
121 interface IERC20 {
122     /**
123      * @dev Returns the amount of tokens in existence.
124      */
125     function totalSupply() external view returns (uint256);
126 
127     /**
128      * @dev Returns the amount of tokens owned by `account`.
129      */
130     function balanceOf(address account) external view returns (uint256);
131 
132     /**
133      * @dev Moves `amount` tokens from the caller's account to `recipient`.
134      *
135      * Returns a boolean value indicating whether the operation succeeded.
136      *
137      * Emits a {Transfer} event.
138      */
139     function transfer(address recipient, uint256 amount) external returns (bool);
140 
141     /**
142      * @dev Returns the remaining number of tokens that `spender` will be
143      * allowed to spend on behalf of `owner` through {transferFrom}. This is
144      * zero by default.
145      *
146      * This value changes when {approve} or {transferFrom} are called.
147      */
148     function allowance(address owner, address spender) external view returns (uint256);
149 
150     /**
151      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
152      *
153      * Returns a boolean value indicating whether the operation succeeded.
154      *
155      * IMPORTANT: Beware that changing an allowance with this method brings the risk
156      * that someone may use both the old and the new allowance by unfortunate
157      * transaction ordering. One possible solution to mitigate this race
158      * condition is to first reduce the spender's allowance to 0 and set the
159      * desired value afterwards:
160      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
161      *
162      * Emits an {Approval} event.
163      */
164     function approve(address spender, uint256 amount) external returns (bool);
165 
166     /**
167      * @dev Moves `amount` tokens from `sender` to `recipient` using the
168      * allowance mechanism. `amount` is then deducted from the caller's
169      * allowance.
170      *
171      * Returns a boolean value indicating whether the operation succeeded.
172      *
173      * Emits a {Transfer} event.
174      */
175     function transferFrom(
176         address sender,
177         address recipient,
178         uint256 amount
179     ) external returns (bool);
180 
181     /**
182      * @dev Emitted when `value` tokens are moved from one account (`from`) to
183      * another (`to`).
184      *
185      * Note that `value` may be zero.
186      */
187     event Transfer(address indexed from, address indexed to, uint256 value);
188 
189     /**
190      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
191      * a call to {approve}. `value` is the new allowance.
192      */
193     event Approval(address indexed owner, address indexed spender, uint256 value);
194 }
195 
196 
197 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.4.0
198 
199 
200 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
201 
202 pragma solidity ^0.8.0;
203 
204 /**
205  * @dev Interface for the optional metadata functions from the ERC20 standard.
206  *
207  * _Available since v4.1._
208  */
209 interface IERC20Metadata is IERC20 {
210     /**
211      * @dev Returns the name of the token.
212      */
213     function name() external view returns (string memory);
214 
215     /**
216      * @dev Returns the symbol of the token.
217      */
218     function symbol() external view returns (string memory);
219 
220     /**
221      * @dev Returns the decimals places of the token.
222      */
223     function decimals() external view returns (uint8);
224 }
225 
226 
227 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.4.0
228 
229 
230 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
231 
232 pragma solidity ^0.8.0;
233 
234 
235 
236 /**
237  * @dev Implementation of the {IERC20} interface.
238  *
239  * This implementation is agnostic to the way tokens are created. This means
240  * that a supply mechanism has to be added in a derived contract using {_mint}.
241  * For a generic mechanism see {ERC20PresetMinterPauser}.
242  *
243  * TIP: For a detailed writeup see our guide
244  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
245  * to implement supply mechanisms].
246  *
247  * We have followed general OpenZeppelin Contracts guidelines: functions revert
248  * instead returning `false` on failure. This behavior is nonetheless
249  * conventional and does not conflict with the expectations of ERC20
250  * applications.
251  *
252  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
253  * This allows applications to reconstruct the allowance for all accounts just
254  * by listening to said events. Other implementations of the EIP may not emit
255  * these events, as it isn't required by the specification.
256  *
257  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
258  * functions have been added to mitigate the well-known issues around setting
259  * allowances. See {IERC20-approve}.
260  */
261 contract ERC20 is Context, IERC20, IERC20Metadata {
262     mapping(address => uint256) private _balances;
263 
264     mapping(address => mapping(address => uint256)) private _allowances;
265 
266     uint256 private _totalSupply;
267 
268     string private _name;
269     string private _symbol;
270 
271     /**
272      * @dev Sets the values for {name} and {symbol}.
273      *
274      * The default value of {decimals} is 18. To select a different value for
275      * {decimals} you should overload it.
276      *
277      * All two of these values are immutable: they can only be set once during
278      * construction.
279      */
280     constructor(string memory name_, string memory symbol_) {
281         _name = name_;
282         _symbol = symbol_;
283     }
284 
285     /**
286      * @dev Returns the name of the token.
287      */
288     function name() public view virtual override returns (string memory) {
289         return _name;
290     }
291 
292     /**
293      * @dev Returns the symbol of the token, usually a shorter version of the
294      * name.
295      */
296     function symbol() public view virtual override returns (string memory) {
297         return _symbol;
298     }
299 
300     /**
301      * @dev Returns the number of decimals used to get its user representation.
302      * For example, if `decimals` equals `2`, a balance of `505` tokens should
303      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
304      *
305      * Tokens usually opt for a value of 18, imitating the relationship between
306      * Ether and Wei. This is the value {ERC20} uses, unless this function is
307      * overridden;
308      *
309      * NOTE: This information is only used for _display_ purposes: it in
310      * no way affects any of the arithmetic of the contract, including
311      * {IERC20-balanceOf} and {IERC20-transfer}.
312      */
313     function decimals() public view virtual override returns (uint8) {
314         return 18;
315     }
316 
317     /**
318      * @dev See {IERC20-totalSupply}.
319      */
320     function totalSupply() public view virtual override returns (uint256) {
321         return _totalSupply;
322     }
323 
324     /**
325      * @dev See {IERC20-balanceOf}.
326      */
327     function balanceOf(address account) public view virtual override returns (uint256) {
328         return _balances[account];
329     }
330 
331     /**
332      * @dev See {IERC20-transfer}.
333      *
334      * Requirements:
335      *
336      * - `recipient` cannot be the zero address.
337      * - the caller must have a balance of at least `amount`.
338      */
339     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
340         _transfer(_msgSender(), recipient, amount);
341         return true;
342     }
343 
344     /**
345      * @dev See {IERC20-allowance}.
346      */
347     function allowance(address owner, address spender) public view virtual override returns (uint256) {
348         return _allowances[owner][spender];
349     }
350 
351     /**
352      * @dev See {IERC20-approve}.
353      *
354      * Requirements:
355      *
356      * - `spender` cannot be the zero address.
357      */
358     function approve(address spender, uint256 amount) public virtual override returns (bool) {
359         _approve(_msgSender(), spender, amount);
360         return true;
361     }
362 
363     /**
364      * @dev See {IERC20-transferFrom}.
365      *
366      * Emits an {Approval} event indicating the updated allowance. This is not
367      * required by the EIP. See the note at the beginning of {ERC20}.
368      *
369      * Requirements:
370      *
371      * - `sender` and `recipient` cannot be the zero address.
372      * - `sender` must have a balance of at least `amount`.
373      * - the caller must have allowance for ``sender``'s tokens of at least
374      * `amount`.
375      */
376     function transferFrom(
377         address sender,
378         address recipient,
379         uint256 amount
380     ) public virtual override returns (bool) {
381         _transfer(sender, recipient, amount);
382 
383         uint256 currentAllowance = _allowances[sender][_msgSender()];
384         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
385         unchecked {
386             _approve(sender, _msgSender(), currentAllowance - amount);
387         }
388 
389         return true;
390     }
391 
392     /**
393      * @dev Atomically increases the allowance granted to `spender` by the caller.
394      *
395      * This is an alternative to {approve} that can be used as a mitigation for
396      * problems described in {IERC20-approve}.
397      *
398      * Emits an {Approval} event indicating the updated allowance.
399      *
400      * Requirements:
401      *
402      * - `spender` cannot be the zero address.
403      */
404     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
405         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
406         return true;
407     }
408 
409     /**
410      * @dev Atomically decreases the allowance granted to `spender` by the caller.
411      *
412      * This is an alternative to {approve} that can be used as a mitigation for
413      * problems described in {IERC20-approve}.
414      *
415      * Emits an {Approval} event indicating the updated allowance.
416      *
417      * Requirements:
418      *
419      * - `spender` cannot be the zero address.
420      * - `spender` must have allowance for the caller of at least
421      * `subtractedValue`.
422      */
423     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
424         uint256 currentAllowance = _allowances[_msgSender()][spender];
425         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
426         unchecked {
427             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
428         }
429 
430         return true;
431     }
432 
433     /**
434      * @dev Moves `amount` of tokens from `sender` to `recipient`.
435      *
436      * This internal function is equivalent to {transfer}, and can be used to
437      * e.g. implement automatic token fees, slashing mechanisms, etc.
438      *
439      * Emits a {Transfer} event.
440      *
441      * Requirements:
442      *
443      * - `sender` cannot be the zero address.
444      * - `recipient` cannot be the zero address.
445      * - `sender` must have a balance of at least `amount`.
446      */
447     function _transfer(
448         address sender,
449         address recipient,
450         uint256 amount
451     ) internal virtual {
452         require(sender != address(0), "ERC20: transfer from the zero address");
453         require(recipient != address(0), "ERC20: transfer to the zero address");
454 
455         _beforeTokenTransfer(sender, recipient, amount);
456 
457         uint256 senderBalance = _balances[sender];
458         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
459         unchecked {
460             _balances[sender] = senderBalance - amount;
461         }
462         _balances[recipient] += amount;
463 
464         emit Transfer(sender, recipient, amount);
465 
466         _afterTokenTransfer(sender, recipient, amount);
467     }
468 
469     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
470      * the total supply.
471      *
472      * Emits a {Transfer} event with `from` set to the zero address.
473      *
474      * Requirements:
475      *
476      * - `account` cannot be the zero address.
477      */
478     function _mint(address account, uint256 amount) internal virtual {
479         require(account != address(0), "ERC20: mint to the zero address");
480 
481         _beforeTokenTransfer(address(0), account, amount);
482 
483         _totalSupply += amount;
484         _balances[account] += amount;
485         emit Transfer(address(0), account, amount);
486 
487         _afterTokenTransfer(address(0), account, amount);
488     }
489 
490     /**
491      * @dev Destroys `amount` tokens from `account`, reducing the
492      * total supply.
493      *
494      * Emits a {Transfer} event with `to` set to the zero address.
495      *
496      * Requirements:
497      *
498      * - `account` cannot be the zero address.
499      * - `account` must have at least `amount` tokens.
500      */
501     function _burn(address account, uint256 amount) internal virtual {
502         require(account != address(0), "ERC20: burn from the zero address");
503 
504         _beforeTokenTransfer(account, address(0), amount);
505 
506         uint256 accountBalance = _balances[account];
507         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
508         unchecked {
509             _balances[account] = accountBalance - amount;
510         }
511         _totalSupply -= amount;
512 
513         emit Transfer(account, address(0), amount);
514 
515         _afterTokenTransfer(account, address(0), amount);
516     }
517 
518     /**
519      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
520      *
521      * This internal function is equivalent to `approve`, and can be used to
522      * e.g. set automatic allowances for certain subsystems, etc.
523      *
524      * Emits an {Approval} event.
525      *
526      * Requirements:
527      *
528      * - `owner` cannot be the zero address.
529      * - `spender` cannot be the zero address.
530      */
531     function _approve(
532         address owner,
533         address spender,
534         uint256 amount
535     ) internal virtual {
536         require(owner != address(0), "ERC20: approve from the zero address");
537         require(spender != address(0), "ERC20: approve to the zero address");
538 
539         _allowances[owner][spender] = amount;
540         emit Approval(owner, spender, amount);
541     }
542 
543     /**
544      * @dev Hook that is called before any transfer of tokens. This includes
545      * minting and burning.
546      *
547      * Calling conditions:
548      *
549      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
550      * will be transferred to `to`.
551      * - when `from` is zero, `amount` tokens will be minted for `to`.
552      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
553      * - `from` and `to` are never both zero.
554      *
555      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
556      */
557     function _beforeTokenTransfer(
558         address from,
559         address to,
560         uint256 amount
561     ) internal virtual {}
562 
563     /**
564      * @dev Hook that is called after any transfer of tokens. This includes
565      * minting and burning.
566      *
567      * Calling conditions:
568      *
569      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
570      * has been transferred to `to`.
571      * - when `from` is zero, `amount` tokens have been minted for `to`.
572      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
573      * - `from` and `to` are never both zero.
574      *
575      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
576      */
577     function _afterTokenTransfer(
578         address from,
579         address to,
580         uint256 amount
581     ) internal virtual {}
582 }
583 
584 
585 // File contracts/BitconnectToken.sol
586 
587 
588 
589 pragma solidity ^0.8.0;
590 
591 
592 contract BitconnectToken is Ownable, ERC20 {
593     bool public limited;
594     uint256 public maxHoldingAmount;
595     uint256 public minHoldingAmount;
596     address public uniswapV2Pair;
597     mapping(address => bool) public blacklists;
598 
599     constructor(uint256 _totalSupply) ERC20("BITCONNECT", "BITCON") {
600         _mint(msg.sender, _totalSupply);
601     }
602 
603     function blacklist(address _address, bool _isBlacklisting) external onlyOwner {
604         blacklists[_address] = _isBlacklisting;
605     }
606 
607     function setRule(bool _limited, address _uniswapV2Pair, uint256 _maxHoldingAmount, uint256 _minHoldingAmount) external onlyOwner {
608         limited = _limited;
609         uniswapV2Pair = _uniswapV2Pair;
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
621         if (uniswapV2Pair == address(0)) {
622             require(from == owner() || to == owner(), "trading is not started");
623             return;
624         }
625 
626         if (limited && from == uniswapV2Pair) {
627             require(super.balanceOf(to) + amount <= maxHoldingAmount && super.balanceOf(to) + amount >= minHoldingAmount, "Forbid");
628         }
629     }
630 
631     function burn(uint256 value) external {
632         _burn(msg.sender, value);
633     }
634 }