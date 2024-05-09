1 /**********************************************************************************************
2  $$$$$$\             $$$$$$\        $$$$$$$\  $$$$$$$$\ $$\   $$\  $$$$$$\  $$$$$$\ $$\
3 $$  __$$\    $$\    $$  __$$\       $$  __$$\ $$  _____|$$$\  $$ |$$  __$$\ \_$$  _|$$ |
4 \__/  $$ |   $$ |   \__/  $$ |      $$ |  $$ |$$ |      $$$$\ $$ |$$ /  \__|  $$ |  $$ |
5  $$$$$$  |$$$$$$$$\  $$$$$$  |      $$$$$$$  |$$$$$\    $$ $$\$$ |$$ |        $$ |  $$ |
6 $$  ____/ \__$$  __|$$  ____/       $$  ____/ $$  __|   $$ \$$$$ |$$ |        $$ |  $$ |
7 $$ |         $$ |   $$ |            $$ |      $$ |      $$ |\$$$ |$$ |  $$\   $$ |  $$ |
8 $$$$$$$$\    \__|   $$$$$$$$\       $$ |      $$$$$$$$\ $$ | \$$ |\$$$$$$  |$$$$$$\ $$$$$$$$\
9 \________|          \________|      \__|      \________|\__|  \__| \______/ \______|\________|
10 **********************************************************************************************/
11 
12 // Powered by NFT Artisans (nftartisans.io) - support@nftartisans.io
13 // Sources flattened with hardhat v2.6.8 https://hardhat.org
14 // SPDX-License-Identifier: MIT
15 
16 
17 // File @openzeppelin/contracts/utils/Context.sol@v4.3.3
18 pragma solidity ^0.8.0;
19 
20 /**
21  * @dev Provides information about the current execution context, including the
22  * sender of the transaction and its data. While these are generally available
23  * via msg.sender and msg.data, they should not be accessed in such a direct
24  * manner, since when dealing with meta-transactions the account sending and
25  * paying for execution may not be the actual sender (as far as an application
26  * is concerned).
27  *
28  * This contract is only required for intermediate, library-like contracts.
29  */
30 abstract contract Context {
31     function _msgSender() internal view virtual returns (address) {
32         return msg.sender;
33     }
34 
35     function _msgData() internal view virtual returns (bytes calldata) {
36         return msg.data;
37     }
38 }
39 
40 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.3
41 pragma solidity ^0.8.0;
42 
43 /**
44  * @dev Contract module which provides a basic access control mechanism, where
45  * there is an account (an owner) that can be granted exclusive access to
46  * specific functions.
47  *
48  * By default, the owner account will be the one that deploys the contract. This
49  * can later be changed with {transferOwnership}.
50  *
51  * This module is used through inheritance. It will make available the modifier
52  * `onlyOwner`, which can be applied to your functions to restrict their use to
53  * the owner.
54  */
55 abstract contract Ownable is Context {
56     address private _owner;
57 
58     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60     /**
61      * @dev Initializes the contract setting the deployer as the initial owner.
62      */
63     constructor() {
64         _setOwner(_msgSender());
65     }
66 
67     /**
68      * @dev Returns the address of the current owner.
69      */
70     function owner() public view virtual returns (address) {
71         return _owner;
72     }
73 
74     /**
75      * @dev Throws if called by any account other than the owner.
76      */
77     modifier onlyOwner() {
78         require(owner() == _msgSender(), "Ownable: caller is not the owner");
79         _;
80     }
81 
82     /**
83      * @dev Leaves the contract without owner. It will not be possible to call
84      * `onlyOwner` functions anymore. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby removing any functionality that is only available to the owner.
88      */
89     function renounceOwnership() public virtual onlyOwner {
90         _setOwner(address(0));
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Can only be called by the current owner.
96      */
97     function transferOwnership(address newOwner) public virtual onlyOwner {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         _setOwner(newOwner);
100     }
101 
102     function _setOwner(address newOwner) private {
103         address oldOwner = _owner;
104         _owner = newOwner;
105         emit OwnershipTransferred(oldOwner, newOwner);
106     }
107 }
108 
109 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.3.3
110 pragma solidity ^0.8.0;
111 
112 /**
113  * @dev Interface of the ERC20 standard as defined in the EIP.
114  */
115 interface IERC20 {
116     /**
117      * @dev Returns the amount of tokens in existence.
118      */
119     function totalSupply() external view returns (uint256);
120 
121     /**
122      * @dev Returns the amount of tokens owned by `account`.
123      */
124     function balanceOf(address account) external view returns (uint256);
125 
126     /**
127      * @dev Moves `amount` tokens from the caller's account to `recipient`.
128      *
129      * Returns a boolean value indicating whether the operation succeeded.
130      *
131      * Emits a {Transfer} event.
132      */
133     function transfer(address recipient, uint256 amount) external returns (bool);
134 
135     /**
136      * @dev Returns the remaining number of tokens that `spender` will be
137      * allowed to spend on behalf of `owner` through {transferFrom}. This is
138      * zero by default.
139      *
140      * This value changes when {approve} or {transferFrom} are called.
141      */
142     function allowance(address owner, address spender) external view returns (uint256);
143 
144     /**
145      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
146      *
147      * Returns a boolean value indicating whether the operation succeeded.
148      *
149      * IMPORTANT: Beware that changing an allowance with this method brings the risk
150      * that someone may use both the old and the new allowance by unfortunate
151      * transaction ordering. One possible solution to mitigate this race
152      * condition is to first reduce the spender's allowance to 0 and set the
153      * desired value afterwards:
154      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
155      *
156      * Emits an {Approval} event.
157      */
158     function approve(address spender, uint256 amount) external returns (bool);
159 
160     /**
161      * @dev Moves `amount` tokens from `sender` to `recipient` using the
162      * allowance mechanism. `amount` is then deducted from the caller's
163      * allowance.
164      *
165      * Returns a boolean value indicating whether the operation succeeded.
166      *
167      * Emits a {Transfer} event.
168      */
169     function transferFrom(
170         address sender,
171         address recipient,
172         uint256 amount
173     ) external returns (bool);
174 
175     /**
176      * @dev Emitted when `value` tokens are moved from one account (`from`) to
177      * another (`to`).
178      *
179      * Note that `value` may be zero.
180      */
181     event Transfer(address indexed from, address indexed to, uint256 value);
182 
183     /**
184      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
185      * a call to {approve}. `value` is the new allowance.
186      */
187     event Approval(address indexed owner, address indexed spender, uint256 value);
188 }
189 
190 
191 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.3.3
192 pragma solidity ^0.8.0;
193 
194 /**
195  * @dev Interface for the optional metadata functions from the ERC20 standard.
196  *
197  * _Available since v4.1._
198  */
199 interface IERC20Metadata is IERC20 {
200     /**
201      * @dev Returns the name of the token.
202      */
203     function name() external view returns (string memory);
204 
205     /**
206      * @dev Returns the symbol of the token.
207      */
208     function symbol() external view returns (string memory);
209 
210     /**
211      * @dev Returns the decimals places of the token.
212      */
213     function decimals() external view returns (uint8);
214 }
215 
216 
217 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.3.3
218 pragma solidity ^0.8.0;
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
570 // File contracts/Pencil.sol
571 pragma solidity ^0.8.4;
572 
573 
574 interface TPT {
575     function balanceOf(address owner) external view returns (uint256);
576     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
577 }
578 
579 interface TPTM is TPT {
580     function balancesOfOwnerByRarity(address owner) external view returns (uint8[] memory);
581 }
582 
583 /**
584  * $PENCIL utility token for 2+2 ecosystem.
585  *
586  * Rewards system based on 2+2 Genesis NFT (addition) rarity levels and Gen2 (subtraction) NFT ownership.
587  * When Gen3 (multiplication) NFT is deployed, multipliers will be applied based upon those rarity levels.
588  * Future 2+2 ecosystem contracts will be authorized to burn tokens as part of the claiming process.
589  *
590  * We have followed the Solidity general layout of state variables in storage to compact the data and reduce gas.
591  * Multiple, contiguous items that need less than 256 bits are packed into single storage slots when possible.
592  */
593 contract Pencil is ERC20, Ownable {
594     TPT public TPTGen1;
595     TPT public TPTGen2;
596     TPTM public TPTGen3;
597 
598     bool public accumulationActive = false;
599     bool public accumulationMultiplier = false;
600     uint48 public start;
601     uint192 public cap;
602 
603     struct Level {
604         uint64 dailyReward;
605         uint64 multiplier;
606         uint128 baseClaim;
607     }
608 
609     struct TokenLengths {
610         uint8 level0;
611         uint8 level1;
612         uint8 level2;
613         uint8 level3;
614         uint8 level4;
615         uint8 level5;
616     }
617 
618     bool[1953] private _gen1BaseClaimed;
619     bool[1953] private _gen2BaseClaimed;
620     uint8[1953] private _rewardLevel = [4,4,3,2,4,5,5,1,1,3,2,5,5,5,3,0,4,5,4,4,5,4,1,4,4,0,2,3,0,3,3,3,2,3,2,5,4,5,5,5,3,3,0,2,1,4,4,2,0,3,4,5,5,0,4,3,5,1,4,3,2,3,5,1,2,5,5,5,3,5,5,1,3,0,5,4,3,2,5,5,5,5,0,5,5,2,2,5,5,4,5,3,3,3,4,3,4,4,1,5,3,4,4,2,1,4,0,3,5,3,2,3,5,4,3,4,3,5,5,2,5,4,4,5,5,4,3,5,3,3,1,1,0,5,5,4,5,3,4,4,5,5,4,5,5,2,3,1,3,1,4,2,1,3,3,5,4,5,3,5,5,2,2,5,3,3,4,4,3,1,4,4,2,4,0,5,3,4,2,0,0,3,5,2,5,5,4,3,5,4,4,4,5,5,5,4,3,5,4,5,5,3,2,1,5,2,3,4,4,2,5,4,4,5,5,3,3,4,5,5,1,1,3,5,4,1,3,4,3,5,3,2,4,1,2,5,4,0,0,4,1,0,0,2,5,5,5,4,2,3,5,5,3,4,5,4,3,2,2,4,4,1,4,3,4,4,3,4,5,3,4,4,3,2,5,2,3,3,4,4,4,4,1,5,4,0,4,4,2,3,1,5,3,5,4,3,1,3,5,2,4,1,5,4,2,5,4,3,3,1,5,1,3,4,3,2,5,2,5,5,3,5,1,3,1,5,4,4,4,5,4,1,5,5,0,4,5,1,3,5,2,3,1,4,4,5,4,4,4,5,4,2,3,1,3,4,2,3,1,5,2,3,1,3,4,1,5,2,4,2,5,5,5,1,4,1,4,5,5,4,2,3,2,4,4,3,4,3,0,2,2,4,1,2,1,3,2,3,1,4,4,4,3,3,3,1,3,4,4,4,1,5,3,2,4,4,3,5,4,1,4,2,2,3,3,0,5,5,4,5,5,4,0,4,5,3,3,3,4,4,5,4,2,2,2,1,2,3,3,5,4,5,3,4,4,5,5,5,3,4,1,4,3,4,4,5,4,5,5,3,3,2,2,5,5,4,2,3,3,4,1,4,4,0,2,3,5,5,3,4,4,3,3,5,5,2,4,0,4,2,2,2,5,2,4,1,5,5,4,5,0,5,5,4,5,5,3,0,4,1,5,3,5,1,3,5,5,5,2,3,1,1,2,3,3,5,4,5,2,5,2,1,1,1,3,2,5,3,1,4,2,5,5,2,5,4,4,5,2,5,5,4,5,5,5,1,4,4,5,3,5,4,3,2,1,2,5,5,2,4,0,3,3,4,1,3,3,4,2,5,5,5,4,5,5,4,4,5,3,4,5,4,2,4,3,3,2,0,5,0,3,5,3,3,5,0,3,2,3,3,5,4,1,2,4,2,5,3,0,4,1,1,5,5,3,5,1,3,5,5,4,3,0,1,5,0,5,2,5,4,1,1,5,4,5,3,1,3,5,5,1,4,4,4,1,2,3,1,3,3,3,4,1,5,0,2,5,2,4,5,5,5,3,4,2,0,2,3,3,2,4,3,3,4,2,0,1,4,5,5,4,4,3,1,1,4,3,5,4,1,5,5,4,0,4,4,2,2,5,4,5,4,5,4,3,2,5,4,2,5,5,3,5,1,1,5,3,4,1,5,2,4,5,2,5,2,2,4,5,5,0,1,3,1,4,5,5,5,4,5,3,2,3,4,3,4,2,3,4,2,5,1,2,4,3,4,4,2,4,4,5,4,2,4,2,4,5,5,4,4,4,1,5,1,1,2,1,2,5,5,4,3,2,5,5,3,4,5,0,1,5,3,4,5,5,2,1,5,4,4,5,3,0,1,2,2,1,5,1,5,4,3,5,5,5,4,2,4,4,1,3,3,5,4,0,5,5,5,4,2,2,1,5,4,2,5,4,3,1,3,3,5,2,4,3,5,2,4,5,5,3,2,4,2,5,3,5,5,4,2,4,3,5,3,5,4,0,3,3,4,3,5,2,5,4,1,3,4,0,4,1,5,5,5,4,3,4,4,0,2,5,5,1,3,4,3,5,4,3,2,3,3,2,4,2,4,4,0,5,2,4,2,5,5,4,2,5,0,3,4,5,5,3,5,2,5,2,5,2,5,5,5,5,2,3,4,4,5,1,5,4,4,5,5,5,1,3,5,4,2,1,5,3,3,2,2,5,2,5,0,3,3,4,3,5,3,4,5,5,0,5,5,2,4,5,5,5,4,1,5,5,4,3,5,3,2,5,5,5,3,2,3,5,3,3,5,2,4,1,5,5,3,3,3,4,4,3,5,1,5,3,5,1,3,5,2,5,1,4,5,2,4,3,3,2,3,4,2,5,4,4,0,4,5,1,3,4,4,0,5,5,4,4,4,4,2,3,4,4,0,5,5,3,2,5,3,1,3,3,5,3,5,4,3,5,2,5,5,1,4,3,5,4,5,4,3,4,3,1,3,2,4,3,4,3,4,2,1,1,1,1,2,1,3,2,5,0,3,4,1,3,2,4,4,4,5,4,5,0,2,4,3,2,4,3,3,4,5,5,2,3,4,2,3,1,3,2,3,2,2,1,2,4,3,4,5,2,5,0,4,2,4,5,1,4,2,5,5,4,0,4,4,4,5,4,3,2,4,5,3,3,2,3,5,5,3,4,5,5,5,5,2,2,1,3,5,2,4,2,3,5,0,4,3,5,0,5,4,3,4,4,1,4,4,5,3,2,2,3,2,5,3,1,5,5,5,1,1,0,1,3,2,1,4,2,2,3,2,1,5,2,4,3,3,2,3,0,5,5,5,0,1,5,5,5,3,5,3,4,5,2,0,4,3,3,5,5,2,4,2,3,4,3,3,2,2,1,5,2,5,4,5,5,5,1,3,4,1,5,2,2,5,2,5,2,4,3,3,3,5,4,2,4,4,3,5,4,5,5,5,1,5,4,4,2,3,4,2,3,5,4,3,1,4,3,3,5,4,4,4,5,3,3,3,4,3,4,3,5,5,5,3,3,2,5,3,3,5,2,4,3,1,0,2,5,2,3,4,5,2,5,3,4,4,2,2,5,1,3,5,4,5,0,5,3,4,4,4,2,2,3,5,5,4,3,3,4,2,3,4,3,2,4,2,4,4,4,2,5,5,4,4,2,1,2,2,3,4,3,1,4,4,5,2,5,3,5,5,4,0,4,5,4,5,4,4,5,4,4,5,1,4,2,4,2,0,2,4,3,3,3,1,2,4,4,4,5,5,5,3,4,4,4,5,5,5,2,3,3,2,3,5,4,4,3,0,3,5,3,2,2,1,1,5,3,4,4,5,5,1,3,5,2,4,2,4,5,3,4,5,4,3,0,2,3,2,1,3,5,2,3,5,5,2,2,4,1,3,4,0,4,4,5,2,4,1,5,4,2,3,2,4,1,2,4,3,4,5,2,1,4,3,3,2,3,4,2,3,0,5,4,5,3,3,0,4,4,5,1,4,2,5,4,1,4,3,3,0,0,3,2,4,1,2,5,5,1,5,1,5,3,4,3,5,5,5,5,4,3,5,5,4,5,3,5,2,5,2,5,5,5,4,3,4,4,4,1,1,5,5,4,4,4,4,5,4,4,1,5,0,5,3,5,4,4,4,4,0,0,4,5,5,4,4,3,4,3,5,5,2,3,3,1,3,5,3,0,1,4,3,0,3,5,1,4,3,5,4,5,5,4,1,5,2,1,5,3,4,4,2,4,1,0,2,0,1,4,4,2,4,2,5,5,1,4,3,4,1,2,3,5,5,4,5,4,3,1,3,5,2,3,2,5,1,3,1,4,5,4,4,4,4,3,0,2,2,0,1,2,0,2,5,4,5,2,1,2,4,3,3,2,0,3,2,2,4,5,2,4,3,2,5,1,4,2,4,4,4,4,2,5,4,5,4,4,3,3,5,5,5,1,4,1,5,2,1,4,3,5,1,3,4,3,4,1,0,3,2,5,3,3,4,5,0,5,5,3,3,5,5,3,5,2,4,3,2,3,5,3,3,4,2,4,5,4,5,5,5,1,5,5,4,2,4,1,5,4,5,3,5,4,4,4,4,3,4,2,5,4,5,5,0,0,2,1,1,2,5,4,3,3,5,4,4,5,4,2,3,2,2,3,4,4,3,5,3,3,5,5,1,1,4,1,2,5,2,2,5,3,3,3,4,4,5,4,5,0,5,5,4,5,5,1,4,0,4,4,3,4,2,4,2,5,3,5,4,4,5,5,3,2,4,5,2,4,1,0,2,4,5,3,3,5,1,5,4,5,3,4,5,2,4,3,5,3,3,5,2,4,3,4,4,4,2,2,4,2,3,4,3,5,3,3,5,4,5,5,5,5,5,0,5,3,2,2,4,4,5,5,4,3,4,1];
621     uint48[1953] private _lastClaimed;
622 
623     mapping(uint256 => Level) public levels;
624     mapping(address => bool) public allowedToBurn;
625 
626     event BaseRewardClaimed(uint256 gen1TokenId, uint256 gen2TokenId, uint256 amount);
627     event RewardClaimed(uint256 gen1TokenId, uint256 amount);
628 
629     constructor(address gen1, address gen2) ERC20("Pencil", "PENCIL") {
630         TPTGen1 = TPT(gen1);
631         TPTGen2 = TPT(gen2);
632         cap = 20000000 * 10 ** 18;
633 
634         _setLevel(0, 10, 60, 400);  // Einstein
635         _setLevel(1,  9, 50, 360);  // Pythagoras
636         _setLevel(2,  8, 40, 320);  // Euclid
637         _setLevel(3,  7, 30, 280);  // Archimedes
638         _setLevel(4,  6, 20, 240);  // Aristotle
639         _setLevel(5,  5, 10, 200);  // Gauss
640 
641         _mint(_msgSender(), 20000 * 10 ** 18);
642     }
643 
644     function burn(address user, uint256 amount) external {
645         require(allowedToBurn[msg.sender], "Address does not have permission to burn");
646         _burn(user, amount);
647     }
648 
649     // Checks an address for the total amount of base rewards they can claim for owning one or more Gen1 & Gen2 NFTs.
650     // Note these NFTs may have already been claimed by a previous owner, as the base claim is tracked by token id.
651     function checkBaseReward(address recipient) external view returns (uint256) {
652         uint256 gen1Count = TPTGen1.balanceOf(recipient);
653         require(gen1Count > 0, "Wallet must own a Genesis NFT");
654 
655         uint256 gen2Count = TPTGen2.balanceOf(recipient);
656         require(gen2Count > 0, "Wallet must own a Gen2 NFT");
657 
658         uint256[] memory gen2TokenIds = new uint256[](gen2Count);
659         uint256 gen2TokenIdsLength;
660 
661         for (uint256 i; i < gen2Count; i++) {
662             uint256 gen2TokenId = TPTGen2.tokenOfOwnerByIndex(recipient, i);
663             if (_gen2BaseClaimed[gen2TokenId] == false) {
664                 gen2TokenIds[gen2TokenIdsLength] = gen2TokenId;
665                 gen2TokenIdsLength++;
666             }
667         }
668 
669         require(gen2TokenIdsLength > 0, "No unclaimed Gen2 NFTs available");
670 
671         uint256 total;
672 
673         for (uint256 i; i < gen1Count; i++) {
674             uint256 gen1TokenId = TPTGen1.tokenOfOwnerByIndex(recipient, i);
675             if (_gen1BaseClaimed[gen1TokenId] == false && gen2TokenIdsLength > 0) {
676                 gen2TokenIdsLength--;
677                 total += levels[_rewardLevel[gen1TokenId]].baseClaim;
678             }
679         }
680 
681         return total;
682     }
683 
684     // Check if the base reward has been claimed for the given token id on either the gen1 or gen2 NFTs
685     function checkBaseRewardByTokenId(uint256 nftId, uint8 gen) external view returns (bool) {
686         require(nftId < 1953, "Invalid Token ID");
687 
688         if (gen == 2) {
689             return _gen1BaseClaimed[nftId];
690         }
691 
692         return _gen2BaseClaimed[nftId];
693     }
694 
695     // Checks an address for the total amount of accumulated daily rewards, but without any multipliers added
696     function checkReward(address recipient) external view returns (uint256) {
697         require(accumulationActive == true, "Reward claiming not active");
698 
699         uint256 gen1Count = TPTGen1.balanceOf(recipient);
700         require(gen1Count > 0, "Wallet must own a Genesis NFT");
701 
702         uint256 total;
703         for (uint256 i; i < gen1Count; i++) {
704             uint256 gen1TokenId = TPTGen1.tokenOfOwnerByIndex(recipient, i);
705             total += levels[_rewardLevel[gen1TokenId]].dailyReward * (block.timestamp - (_lastClaimed[gen1TokenId] > 0 ? _lastClaimed[gen1TokenId] : start)) / 86400;
706         }
707 
708         return total;
709     }
710 
711     // Claim the base $PENCIL rewards for all unclaimed Gen1 + Gen2 NFTs owned by the sender. Each NFT token must not
712     // have already been claimed, and rewards based on Gen1 rarity level paired with an available Gen2.
713     function claimBaseReward() external {
714         uint256 gen1Count = TPTGen1.balanceOf(msg.sender);
715         require(gen1Count > 0, "Wallet must own a Genesis NFT");
716 
717         uint256 gen2Count = TPTGen2.balanceOf(msg.sender);
718         require(gen2Count > 0, "Wallet must own a Gen2 NFT");
719 
720         uint256[] memory gen2TokenIds = new uint256[](gen2Count);
721         uint256 gen2TokenIdsLength;
722 
723         for (uint256 i; i < gen2Count; i++) {
724             uint256 gen2TokenId = TPTGen2.tokenOfOwnerByIndex(msg.sender, i);
725             if (_gen2BaseClaimed[gen2TokenId] == false) {
726                 gen2TokenIds[gen2TokenIdsLength] = gen2TokenId;
727                 gen2TokenIdsLength++;
728             }
729         }
730 
731         require(gen2TokenIdsLength > 0, "No unclaimed Gen2 NFTs available");
732 
733         bool rewarded;
734         for (uint256 i; i < gen1Count; i++) {
735             uint256 gen1TokenId = TPTGen1.tokenOfOwnerByIndex(msg.sender, i);
736             if (_gen1BaseClaimed[gen1TokenId] == false && gen2TokenIdsLength > 0) {
737                 gen2TokenIdsLength--;
738                 uint256 amount = levels[_rewardLevel[gen1TokenId]].baseClaim;
739 
740                 _mint(_msgSender(), amount);
741                 _gen1BaseClaimed[gen1TokenId] = true;
742                 _gen2BaseClaimed[gen2TokenIds[gen2TokenIdsLength]] = true;
743                 rewarded = true;
744 
745                 emit BaseRewardClaimed(gen1TokenId, gen2TokenIds[gen2TokenIdsLength], amount);
746             }
747         }
748 
749         require(rewarded == true, "No unclaimed Gen1 NFTs available");
750     }
751 
752     function claimReward() external {
753         require(accumulationActive == true, "Reward claiming not active");
754 
755         uint8[] memory multipliers = new uint8[](6);
756         TokenLengths memory gen1TokenLengths;
757         uint256 gen1Count = TPTGen1.balanceOf(msg.sender);
758         uint256 gen3Count;
759         uint256 total;
760 
761         uint256[] memory gen1TokenIdsLevel0 = new uint256[](gen1Count);
762         uint256[] memory gen1TokenIdsLevel1 = new uint256[](gen1Count);
763         uint256[] memory gen1TokenIdsLevel2 = new uint256[](gen1Count);
764         uint256[] memory gen1TokenIdsLevel3 = new uint256[](gen1Count);
765         uint256[] memory gen1TokenIdsLevel4 = new uint256[](gen1Count);
766         uint256[] memory gen1TokenIdsLevel5 = new uint256[](gen1Count);
767 
768         require(gen1Count > 0, "Wallet must own a Genesis NFT");
769 
770         // Capped due to possible stack limitations later on
771         if (gen1Count > 40) {
772             gen1Count = 40;
773         }
774 
775         if (accumulationMultiplier == true) {
776             gen3Count = TPTGen3.balanceOf(msg.sender);
777             if (gen3Count > 0) {
778                 multipliers = TPTGen3.balancesOfOwnerByRarity(msg.sender);
779             }
780         }
781 
782         for (uint256 i; i < gen1Count; i++) {
783             uint256 gen1TokenId = TPTGen1.tokenOfOwnerByIndex(msg.sender, i);
784 
785             if (_rewardLevel[gen1TokenId] == 5) {
786                 gen1TokenIdsLevel5[gen1TokenLengths.level5] = gen1TokenId;
787                 gen1TokenLengths.level5++;
788             }
789             else if (_rewardLevel[gen1TokenId] == 4) {
790                 gen1TokenIdsLevel4[gen1TokenLengths.level4] = gen1TokenId;
791                 gen1TokenLengths.level4++;
792             }
793             else if (_rewardLevel[gen1TokenId] == 3) {
794                 gen1TokenIdsLevel3[gen1TokenLengths.level3] = gen1TokenId;
795                 gen1TokenLengths.level3++;
796             }
797             else if (_rewardLevel[gen1TokenId] == 2) {
798                 gen1TokenIdsLevel2[gen1TokenLengths.level2] = gen1TokenId;
799                 gen1TokenLengths.level2++;
800             }
801             else if (_rewardLevel[gen1TokenId] == 1) {
802                 gen1TokenIdsLevel1[gen1TokenLengths.level1] = gen1TokenId;
803                 gen1TokenLengths.level1++;
804             }
805             else {
806                 gen1TokenIdsLevel0[gen1TokenLengths.level0] = gen1TokenId;
807                 gen1TokenLengths.level0++;
808             }
809         }
810 
811         // Einstein rewards
812         if (gen1TokenLengths.level0 > 0) {
813             total += _getClaim(gen1TokenIdsLevel0, multipliers, gen1TokenLengths, gen3Count, 0);
814         }
815 
816         // Pythagoras rewards
817         if (gen1TokenLengths.level1 > 0) {
818             total += _getClaim(gen1TokenIdsLevel1, multipliers, gen1TokenLengths, gen3Count, 1);
819         }
820 
821         // Euclid rewards
822         if (gen1TokenLengths.level2 > 0) {
823             total += _getClaim(gen1TokenIdsLevel2, multipliers, gen1TokenLengths, gen3Count, 2);
824         }
825 
826         // Archimedes rewards
827         if (gen1TokenLengths.level3 > 0) {
828             total += _getClaim(gen1TokenIdsLevel3, multipliers, gen1TokenLengths, gen3Count, 3);
829         }
830 
831         // Aristotle rewards
832         if (gen1TokenLengths.level4 > 0) {
833             total += _getClaim(gen1TokenIdsLevel4, multipliers, gen1TokenLengths, gen3Count, 4);
834         }
835 
836         // Gauss rewards
837         if (gen1TokenLengths.level5 > 0) {
838             total += _getClaim(gen1TokenIdsLevel5, multipliers, gen1TokenLengths, gen3Count, 5);
839         }
840 
841         _mint(_msgSender(), total);
842     }
843 
844     function flipState() external onlyOwner {
845         accumulationActive = !accumulationActive;
846         if (start == 0) {
847             start = uint48(block.timestamp);
848         }
849     }
850 
851     function flipStateMultiplier() external onlyOwner {
852         accumulationMultiplier = !accumulationMultiplier;
853     }
854 
855     function _getClaim(uint256[] memory _gen1TokenIds, uint8[] memory _multipliers, TokenLengths memory _gen1TokenLengths, uint256 _gen3Count, uint256 _levelIdx) internal returns (uint256) {
856         uint256 total;
857         uint256 gen1Count;
858         uint256 multiplierIdx;
859 
860         if (_levelIdx == 5) {
861             multiplierIdx = _gen1TokenLengths.level4 + _gen1TokenLengths.level3 + _gen1TokenLengths.level2 + _gen1TokenLengths.level1 + _gen1TokenLengths.level0;
862             gen1Count = _gen1TokenLengths.level5;
863         }
864         else if (_levelIdx == 4) {
865             multiplierIdx = _gen1TokenLengths.level3 + _gen1TokenLengths.level2 + _gen1TokenLengths.level1 + _gen1TokenLengths.level0;
866             gen1Count = _gen1TokenLengths.level4;
867         }
868         else if (_levelIdx == 3) {
869             multiplierIdx = _gen1TokenLengths.level2 + _gen1TokenLengths.level1 + _gen1TokenLengths.level0;
870             gen1Count = _gen1TokenLengths.level3;
871         }
872         else if (_levelIdx == 2) {
873             multiplierIdx = _gen1TokenLengths.level1 + _gen1TokenLengths.level0;
874             gen1Count = _gen1TokenLengths.level2;
875         }
876         else if (_levelIdx == 1) {
877             multiplierIdx = _gen1TokenLengths.level0;
878             gen1Count = _gen1TokenLengths.level1;
879         }
880         else {
881             gen1Count = _gen1TokenLengths.level0;
882         }
883 
884         for (uint256 i; i < gen1Count; i++) {
885             uint256 amount = levels[_levelIdx].dailyReward * (block.timestamp - (_lastClaimed[_gen1TokenIds[i]] > 0 ? _lastClaimed[_gen1TokenIds[i]] : start)) / 86400;
886 
887             if (multiplierIdx < _gen3Count) {
888                 for (uint256 l; l < 6; l++) {
889                     if (_multipliers[l] > 0) {
890                         amount += (amount * uint256(levels[l].multiplier)) / 100;
891                         _multipliers[l]--;
892                         break;
893                     }
894                 }
895                 multiplierIdx++;
896             }
897 
898             total += amount;
899             _lastClaimed[_gen1TokenIds[i]] = uint48(block.timestamp);
900             emit RewardClaimed(_gen1TokenIds[i], amount);
901         }
902 
903         return total;
904     }
905 
906     function _mint(address account, uint256 amount) internal virtual override {
907         require(totalSupply() + amount <= cap, "Cap exceeded");
908         super._mint(account, amount);
909     }
910 
911     function setCap(uint192 amount) external onlyOwner {
912         require(amount > 0, "Invalid cap");
913         cap = amount * 10 ** 18;
914     }
915 
916     function setAllowedToBurn(address account, bool allowed) public onlyOwner {
917         allowedToBurn[account] = allowed;
918     }
919 
920     function setLevel(uint256 idx, uint64 dailyReward, uint64 multiplier, uint128 baseClaim) external onlyOwner {
921         require(idx >= 0 && idx <= 6, "Invalid level index");
922         require(baseClaim > 0, "Base claim must be greater than 0");
923         require(dailyReward > 0, "Daily reward must be greater than 0");
924         require(multiplier >= 0, "Invalid multiplier bonus");
925         _setLevel(idx, dailyReward, multiplier, baseClaim);
926     }
927 
928     function _setLevel(uint256 _idx, uint64 _dailyReward, uint64 _multiplier, uint128 _baseClaim) internal {
929         levels[_idx] = Level(_dailyReward * 10 ** 18, _multiplier, _baseClaim * 10 ** 18);
930     }
931 
932     function setMultiplierAddress(address account) external onlyOwner {
933         TPTGen3 = TPTM(account);
934         setAllowedToBurn(account, true);
935     }
936 }