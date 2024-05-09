1 // File @openzeppelin/contracts/utils/Context.sol@v4.6.0
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
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
28 // File @openzeppelin/contracts/access/Ownable.sol@v4.6.0
29 
30 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
31 
32 pragma solidity ^0.8.0;
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 abstract contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor() {
55         _transferOwnership(_msgSender());
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view virtual returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(owner() == _msgSender(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Leaves the contract without owner. It will not be possible to call
75      * `onlyOwner` functions anymore. Can only be called by the current owner.
76      *
77      * NOTE: Renouncing ownership will leave the contract without an owner,
78      * thereby removing any functionality that is only available to the owner.
79      */
80     function renounceOwnership() public virtual onlyOwner {
81         _transferOwnership(address(0));
82     }
83 
84     /**
85      * @dev Transfers ownership of the contract to a new account (`newOwner`).
86      * Can only be called by the current owner.
87      */
88     function transferOwnership(address newOwner) public virtual onlyOwner {
89         require(newOwner != address(0), "Ownable: new owner is the zero address");
90         _transferOwnership(newOwner);
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Internal function without access restriction.
96      */
97     function _transferOwnership(address newOwner) internal virtual {
98         address oldOwner = _owner;
99         _owner = newOwner;
100         emit OwnershipTransferred(oldOwner, newOwner);
101     }
102 }
103 
104 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
105 
106 pragma solidity ^0.8.0;
107 
108 /**
109  * @dev Interface of the ERC20 standard as defined in the EIP.
110  */
111 interface IERC20 {
112     /**
113      * @dev Emitted when `value` tokens are moved from one account (`from`) to
114      * another (`to`).
115      *
116      * Note that `value` may be zero.
117      */
118     event Transfer(address indexed from, address indexed to, uint256 value);
119 
120     /**
121      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
122      * a call to {approve}. `value` is the new allowance.
123      */
124     event Approval(address indexed owner, address indexed spender, uint256 value);
125 
126     /**
127      * @dev Returns the amount of tokens in existence.
128      */
129     function totalSupply() external view returns (uint256);
130 
131     /**
132      * @dev Returns the amount of tokens owned by `account`.
133      */
134     function balanceOf(address account) external view returns (uint256);
135 
136     /**
137      * @dev Moves `amount` tokens from the caller's account to `to`.
138      *
139      * Returns a boolean value indicating whether the operation succeeded.
140      *
141      * Emits a {Transfer} event.
142      */
143     function transfer(address to, uint256 amount) external returns (bool);
144 
145     /**
146      * @dev Returns the remaining number of tokens that `spender` will be
147      * allowed to spend on behalf of `owner` through {transferFrom}. This is
148      * zero by default.
149      *
150      * This value changes when {approve} or {transferFrom} are called.
151      */
152     function allowance(address owner, address spender) external view returns (uint256);
153 
154     /**
155      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
156      *
157      * Returns a boolean value indicating whether the operation succeeded.
158      *
159      * IMPORTANT: Beware that changing an allowance with this method brings the risk
160      * that someone may use both the old and the new allowance by unfortunate
161      * transaction ordering. One possible solution to mitigate this race
162      * condition is to first reduce the spender's allowance to 0 and set the
163      * desired value afterwards:
164      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165      *
166      * Emits an {Approval} event.
167      */
168     function approve(address spender, uint256 amount) external returns (bool);
169 
170     /**
171      * @dev Moves `amount` tokens from `from` to `to` using the
172      * allowance mechanism. `amount` is then deducted from the caller's
173      * allowance.
174      *
175      * Returns a boolean value indicating whether the operation succeeded.
176      *
177      * Emits a {Transfer} event.
178      */
179     function transferFrom(
180         address from,
181         address to,
182         uint256 amount
183     ) external returns (bool);
184 }
185 
186 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.6.0
187 
188 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
189 
190 pragma solidity ^0.8.0;
191 
192 /**
193  * @dev Interface for the optional metadata functions from the ERC20 standard.
194  *
195  * _Available since v4.1._
196  */
197 interface IERC20Metadata is IERC20 {
198     /**
199      * @dev Returns the name of the token.
200      */
201     function name() external view returns (string memory);
202 
203     /**
204      * @dev Returns the symbol of the token.
205      */
206     function symbol() external view returns (string memory);
207 
208     /**
209      * @dev Returns the decimals places of the token.
210      */
211     function decimals() external view returns (uint8);
212 }
213 
214 
215 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.6.0
216 
217 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/ERC20.sol)
218 
219 pragma solidity ^0.8.0;
220 
221 
222 
223 /**
224  * @dev Implementation of the {IERC20} interface.
225  *
226  * This implementation is agnostic to the way tokens are created. This means
227  * that a supply mechanism has to be added in a derived contract using {_mint}.
228  * For a generic mechanism see {ERC20PresetMinterPauser}.
229  *
230  * TIP: For a detailed writeup see our guide
231  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
232  * to implement supply mechanisms].
233  *
234  * We have followed general OpenZeppelin Contracts guidelines: functions revert
235  * instead returning `false` on failure. This behavior is nonetheless
236  * conventional and does not conflict with the expectations of ERC20
237  * applications.
238  *
239  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
240  * This allows applications to reconstruct the allowance for all accounts just
241  * by listening to said events. Other implementations of the EIP may not emit
242  * these events, as it isn't required by the specification.
243  *
244  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
245  * functions have been added to mitigate the well-known issues around setting
246  * allowances. See {IERC20-approve}.
247  */
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
323      * - `to` cannot be the zero address.
324      * - the caller must have a balance of at least `amount`.
325      */
326     function transfer(address to, uint256 amount) public virtual override returns (bool) {
327         address owner = _msgSender();
328         _transfer(owner, to, amount);
329         return true;
330     }
331 
332     /**
333      * @dev See {IERC20-allowance}.
334      */
335     function allowance(address owner, address spender) public view virtual override returns (uint256) {
336         return _allowances[owner][spender];
337     }
338 
339     /**
340      * @dev See {IERC20-approve}.
341      *
342      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
343      * `transferFrom`. This is semantically equivalent to an infinite approval.
344      *
345      * Requirements:
346      *
347      * - `spender` cannot be the zero address.
348      */
349     function approve(address spender, uint256 amount) public virtual override returns (bool) {
350         address owner = _msgSender();
351         _approve(owner, spender, amount);
352         return true;
353     }
354 
355     /**
356      * @dev See {IERC20-transferFrom}.
357      *
358      * Emits an {Approval} event indicating the updated allowance. This is not
359      * required by the EIP. See the note at the beginning of {ERC20}.
360      *
361      * NOTE: Does not update the allowance if the current allowance
362      * is the maximum `uint256`.
363      *
364      * Requirements:
365      *
366      * - `from` and `to` cannot be the zero address.
367      * - `from` must have a balance of at least `amount`.
368      * - the caller must have allowance for ``from``'s tokens of at least
369      * `amount`.
370      */
371     function transferFrom(
372         address from,
373         address to,
374         uint256 amount
375     ) public virtual override returns (bool) {
376         address spender = _msgSender();
377         _spendAllowance(from, spender, amount);
378         _transfer(from, to, amount);
379         return true;
380     }
381 
382     /**
383      * @dev Atomically increases the allowance granted to `spender` by the caller.
384      *
385      * This is an alternative to {approve} that can be used as a mitigation for
386      * problems described in {IERC20-approve}.
387      *
388      * Emits an {Approval} event indicating the updated allowance.
389      *
390      * Requirements:
391      *
392      * - `spender` cannot be the zero address.
393      */
394     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
395         address owner = _msgSender();
396         _approve(owner, spender, allowance(owner, spender) + addedValue);
397         return true;
398     }
399 
400     /**
401      * @dev Atomically decreases the allowance granted to `spender` by the caller.
402      *
403      * This is an alternative to {approve} that can be used as a mitigation for
404      * problems described in {IERC20-approve}.
405      *
406      * Emits an {Approval} event indicating the updated allowance.
407      *
408      * Requirements:
409      *
410      * - `spender` cannot be the zero address.
411      * - `spender` must have allowance for the caller of at least
412      * `subtractedValue`.
413      */
414     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
415         address owner = _msgSender();
416         uint256 currentAllowance = allowance(owner, spender);
417         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
418         unchecked {
419             _approve(owner, spender, currentAllowance - subtractedValue);
420         }
421 
422         return true;
423     }
424 
425     /**
426      * @dev Moves `amount` of tokens from `sender` to `recipient`.
427      *
428      * This internal function is equivalent to {transfer}, and can be used to
429      * e.g. implement automatic token fees, slashing mechanisms, etc.
430      *
431      * Emits a {Transfer} event.
432      *
433      * Requirements:
434      *
435      * - `from` cannot be the zero address.
436      * - `to` cannot be the zero address.
437      * - `from` must have a balance of at least `amount`.
438      */
439     function _transfer(
440         address from,
441         address to,
442         uint256 amount
443     ) internal virtual {
444         require(from != address(0), "ERC20: transfer from the zero address");
445         require(to != address(0), "ERC20: transfer to the zero address");
446 
447         _beforeTokenTransfer(from, to, amount);
448 
449         uint256 fromBalance = _balances[from];
450         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
451         unchecked {
452             _balances[from] = fromBalance - amount;
453         }
454         _balances[to] += amount;
455 
456         emit Transfer(from, to, amount);
457 
458         _afterTokenTransfer(from, to, amount);
459     }
460 
461     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
462      * the total supply.
463      *
464      * Emits a {Transfer} event with `from` set to the zero address.
465      *
466      * Requirements:
467      *
468      * - `account` cannot be the zero address.
469      */
470     function _mint(address account, uint256 amount) internal virtual {
471         require(account != address(0), "ERC20: mint to the zero address");
472 
473         _beforeTokenTransfer(address(0), account, amount);
474 
475         _totalSupply += amount;
476         _balances[account] += amount;
477         emit Transfer(address(0), account, amount);
478 
479         _afterTokenTransfer(address(0), account, amount);
480     }
481 
482     /**
483      * @dev Destroys `amount` tokens from `account`, reducing the
484      * total supply.
485      *
486      * Emits a {Transfer} event with `to` set to the zero address.
487      *
488      * Requirements:
489      *
490      * - `account` cannot be the zero address.
491      * - `account` must have at least `amount` tokens.
492      */
493     function _burn(address account, uint256 amount) internal virtual {
494         require(account != address(0), "ERC20: burn from the zero address");
495 
496         _beforeTokenTransfer(account, address(0), amount);
497 
498         uint256 accountBalance = _balances[account];
499         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
500         unchecked {
501             _balances[account] = accountBalance - amount;
502         }
503         _totalSupply -= amount;
504 
505         emit Transfer(account, address(0), amount);
506 
507         _afterTokenTransfer(account, address(0), amount);
508     }
509 
510     /**
511      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
512      *
513      * This internal function is equivalent to `approve`, and can be used to
514      * e.g. set automatic allowances for certain subsystems, etc.
515      *
516      * Emits an {Approval} event.
517      *
518      * Requirements:
519      *
520      * - `owner` cannot be the zero address.
521      * - `spender` cannot be the zero address.
522      */
523     function _approve(
524         address owner,
525         address spender,
526         uint256 amount
527     ) internal virtual {
528         require(owner != address(0), "ERC20: approve from the zero address");
529         require(spender != address(0), "ERC20: approve to the zero address");
530 
531         _allowances[owner][spender] = amount;
532         emit Approval(owner, spender, amount);
533     }
534 
535     /**
536      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
537      *
538      * Does not update the allowance amount in case of infinite allowance.
539      * Revert if not enough allowance is available.
540      *
541      * Might emit an {Approval} event.
542      */
543     function _spendAllowance(
544         address owner,
545         address spender,
546         uint256 amount
547     ) internal virtual {
548         uint256 currentAllowance = allowance(owner, spender);
549         if (currentAllowance != type(uint256).max) {
550             require(currentAllowance >= amount, "ERC20: insufficient allowance");
551             unchecked {
552                 _approve(owner, spender, currentAllowance - amount);
553             }
554         }
555     }
556 
557     /**
558      * @dev Hook that is called before any transfer of tokens. This includes
559      * minting and burning.
560      *
561      * Calling conditions:
562      *
563      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
564      * will be transferred to `to`.
565      * - when `from` is zero, `amount` tokens will be minted for `to`.
566      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
567      * - `from` and `to` are never both zero.
568      *
569      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
570      */
571     function _beforeTokenTransfer(
572         address from,
573         address to,
574         uint256 amount
575     ) internal virtual {}
576 
577     /**
578      * @dev Hook that is called after any transfer of tokens. This includes
579      * minting and burning.
580      *
581      * Calling conditions:
582      *
583      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
584      * has been transferred to `to`.
585      * - when `from` is zero, `amount` tokens have been minted for `to`.
586      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
587      * - `from` and `to` are never both zero.
588      *
589      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
590      */
591     function _afterTokenTransfer(
592         address from,
593         address to,
594         uint256 amount
595     ) internal virtual {}
596 }
597 
598 
599 // File contracts/TokenSwap.sol
600 
601 
602 pragma solidity ^0.8.0;
603 
604 
605 contract TokenSwap is Ownable {
606     ERC20 public immutable token;
607     mapping(address => uint256) public allocations;
608     mapping(address => uint256) public claimed;
609     uint256 public start;
610     uint256 public vestingPeriod = 15552000; // 180 days
611     bool public started;
612 
613     constructor(address _token) {
614         token = ERC20(_token);
615     }
616 
617     function setAllocations(
618         address[] memory _users,
619         uint256[] memory _allocations
620     ) external onlyOwner {
621         require(_users.length == _allocations.length, "!Length");
622         for (uint256 i = 0; i < _users.length; i++) {
623             allocations[_users[i]] = _allocations[i];
624         }
625     }
626 
627     function startSwap() external onlyOwner {
628         require(!started, "Started");
629         started = true;
630         start = block.timestamp;
631     }
632 
633     function claim() external {
634         require(started, "!Started");
635         uint256 _claimable = claimable(msg.sender);
636         require(_claimable > 0, "Nothing to claim");
637         claimed[msg.sender] += _claimable;
638         token.transfer(msg.sender, _claimable);
639     }
640 
641     function claimable(address _user) public view returns (uint256) {
642         if (!started) return 0;
643         if (block.timestamp - start > vestingPeriod)
644             return allocations[_user] - claimed[_user];
645         return
646             (allocations[_user] * (block.timestamp - start)) /
647             vestingPeriod -
648             claimed[_user];
649     }
650 
651     function pull() external onlyOwner {
652         token.transfer(owner(), token.balanceOf(address(this)));
653     }
654 }