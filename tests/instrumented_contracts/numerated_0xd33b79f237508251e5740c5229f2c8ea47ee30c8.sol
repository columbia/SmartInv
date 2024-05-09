1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         return msg.data;
21     }
22 }
23 
24 // File: @openzeppelin/contracts/access/Ownable.sol
25 
26 
27 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
28 
29 pragma solidity ^0.8.0;
30 
31 
32 /**
33  * @dev Contract module which provides a basic access control mechanism, where
34  * there is an account (an owner) that can be granted exclusive access to
35  * specific functions.
36  *
37  * By default, the owner account will be the one that deploys the contract. This
38  * can later be changed with {transferOwnership}.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 abstract contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor() {
53         _transferOwnership(_msgSender());
54     }
55 
56     /**
57      * @dev Returns the address of the current owner.
58      */
59     function owner() public view virtual returns (address) {
60         return _owner;
61     }
62 
63     /**
64      * @dev Throws if called by any account other than the owner.
65      */
66     modifier onlyOwner() {
67         require(owner() == _msgSender(), "Ownable: caller is not the owner");
68         _;
69     }
70 
71     /**
72      * @dev Leaves the contract without owner. It will not be possible to call
73      * `onlyOwner` functions anymore. Can only be called by the current owner.
74      *
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
102 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
103 
104 
105 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
106 
107 pragma solidity ^0.8.0;
108 
109 /**
110  * @dev Interface of the ERC20 standard as defined in the EIP.
111  */
112 interface IERC20 {
113     /**
114      * @dev Emitted when `value` tokens are moved from one account (`from`) to
115      * another (`to`).
116      *
117      * Note that `value` may be zero.
118      */
119     event Transfer(address indexed from, address indexed to, uint256 value);
120 
121     /**
122      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
123      * a call to {approve}. `value` is the new allowance.
124      */
125     event Approval(address indexed owner, address indexed spender, uint256 value);
126 
127     /**
128      * @dev Returns the amount of tokens in existence.
129      */
130     function totalSupply() external view returns (uint256);
131 
132     /**
133      * @dev Returns the amount of tokens owned by `account`.
134      */
135     function balanceOf(address account) external view returns (uint256);
136 
137     /**
138      * @dev Moves `amount` tokens from the caller's account to `to`.
139      *
140      * Returns a boolean value indicating whether the operation succeeded.
141      *
142      * Emits a {Transfer} event.
143      */
144     function transfer(address to, uint256 amount) external returns (bool);
145 
146     /**
147      * @dev Returns the remaining number of tokens that `spender` will be
148      * allowed to spend on behalf of `owner` through {transferFrom}. This is
149      * zero by default.
150      *
151      * This value changes when {approve} or {transferFrom} are called.
152      */
153     function allowance(address owner, address spender) external view returns (uint256);
154 
155     /**
156      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
157      *
158      * Returns a boolean value indicating whether the operation succeeded.
159      *
160      * IMPORTANT: Beware that changing an allowance with this method brings the risk
161      * that someone may use both the old and the new allowance by unfortunate
162      * transaction ordering. One possible solution to mitigate this race
163      * condition is to first reduce the spender's allowance to 0 and set the
164      * desired value afterwards:
165      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
166      *
167      * Emits an {Approval} event.
168      */
169     function approve(address spender, uint256 amount) external returns (bool);
170 
171     /**
172      * @dev Moves `amount` tokens from `from` to `to` using the
173      * allowance mechanism. `amount` is then deducted from the caller's
174      * allowance.
175      *
176      * Returns a boolean value indicating whether the operation succeeded.
177      *
178      * Emits a {Transfer} event.
179      */
180     function transferFrom(
181         address from,
182         address to,
183         uint256 amount
184     ) external returns (bool);
185 }
186 
187 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
188 
189 
190 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
191 
192 pragma solidity ^0.8.0;
193 
194 
195 /**
196  * @dev Interface for the optional metadata functions from the ERC20 standard.
197  *
198  * _Available since v4.1._
199  */
200 interface IERC20Metadata is IERC20 {
201     /**
202      * @dev Returns the name of the token.
203      */
204     function name() external view returns (string memory);
205 
206     /**
207      * @dev Returns the symbol of the token.
208      */
209     function symbol() external view returns (string memory);
210 
211     /**
212      * @dev Returns the decimals places of the token.
213      */
214     function decimals() external view returns (uint8);
215 }
216 
217 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
218 
219 
220 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/ERC20.sol)
221 
222 pragma solidity ^0.8.0;
223 
224 
225 
226 
227 /**
228  * @dev Implementation of the {IERC20} interface.
229  *
230  * This implementation is agnostic to the way tokens are created. This means
231  * that a supply mechanism has to be added in a derived contract using {_mint}.
232  * For a generic mechanism see {ERC20PresetMinterPauser}.
233  *
234  * TIP: For a detailed writeup see our guide
235  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
236  * to implement supply mechanisms].
237  *
238  * We have followed general OpenZeppelin Contracts guidelines: functions revert
239  * instead returning `false` on failure. This behavior is nonetheless
240  * conventional and does not conflict with the expectations of ERC20
241  * applications.
242  *
243  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
244  * This allows applications to reconstruct the allowance for all accounts just
245  * by listening to said events. Other implementations of the EIP may not emit
246  * these events, as it isn't required by the specification.
247  *
248  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
249  * functions have been added to mitigate the well-known issues around setting
250  * allowances. See {IERC20-approve}.
251  */
252 contract ERC20 is Context, IERC20, IERC20Metadata {
253     mapping(address => uint256) private _balances;
254 
255     mapping(address => mapping(address => uint256)) private _allowances;
256 
257     uint256 private _totalSupply;
258 
259     string private _name;
260     string private _symbol;
261 
262     /**
263      * @dev Sets the values for {name} and {symbol}.
264      *
265      * The default value of {decimals} is 18. To select a different value for
266      * {decimals} you should overload it.
267      *
268      * All two of these values are immutable: they can only be set once during
269      * construction.
270      */
271     constructor(string memory name_, string memory symbol_) {
272         _name = name_;
273         _symbol = symbol_;
274     }
275 
276     /**
277      * @dev Returns the name of the token.
278      */
279     function name() public view virtual override returns (string memory) {
280         return _name;
281     }
282 
283     /**
284      * @dev Returns the symbol of the token, usually a shorter version of the
285      * name.
286      */
287     function symbol() public view virtual override returns (string memory) {
288         return _symbol;
289     }
290 
291     /**
292      * @dev Returns the number of decimals used to get its user representation.
293      * For example, if `decimals` equals `2`, a balance of `505` tokens should
294      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
295      *
296      * Tokens usually opt for a value of 18, imitating the relationship between
297      * Ether and Wei. This is the value {ERC20} uses, unless this function is
298      * overridden;
299      *
300      * NOTE: This information is only used for _display_ purposes: it in
301      * no way affects any of the arithmetic of the contract, including
302      * {IERC20-balanceOf} and {IERC20-transfer}.
303      */
304     function decimals() public view virtual override returns (uint8) {
305         return 18;
306     }
307 
308     /**
309      * @dev See {IERC20-totalSupply}.
310      */
311     function totalSupply() public view virtual override returns (uint256) {
312         return _totalSupply;
313     }
314 
315     /**
316      * @dev See {IERC20-balanceOf}.
317      */
318     function balanceOf(address account) public view virtual override returns (uint256) {
319         return _balances[account];
320     }
321 
322     /**
323      * @dev See {IERC20-transfer}.
324      *
325      * Requirements:
326      *
327      * - `to` cannot be the zero address.
328      * - the caller must have a balance of at least `amount`.
329      */
330     function transfer(address to, uint256 amount) public virtual override returns (bool) {
331         address owner = _msgSender();
332         _transfer(owner, to, amount);
333         return true;
334     }
335 
336     /**
337      * @dev See {IERC20-allowance}.
338      */
339     function allowance(address owner, address spender) public view virtual override returns (uint256) {
340         return _allowances[owner][spender];
341     }
342 
343     /**
344      * @dev See {IERC20-approve}.
345      *
346      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
347      * `transferFrom`. This is semantically equivalent to an infinite approval.
348      *
349      * Requirements:
350      *
351      * - `spender` cannot be the zero address.
352      */
353     function approve(address spender, uint256 amount) public virtual override returns (bool) {
354         address owner = _msgSender();
355         _approve(owner, spender, amount);
356         return true;
357     }
358 
359     /**
360      * @dev See {IERC20-transferFrom}.
361      *
362      * Emits an {Approval} event indicating the updated allowance. This is not
363      * required by the EIP. See the note at the beginning of {ERC20}.
364      *
365      * NOTE: Does not update the allowance if the current allowance
366      * is the maximum `uint256`.
367      *
368      * Requirements:
369      *
370      * - `from` and `to` cannot be the zero address.
371      * - `from` must have a balance of at least `amount`.
372      * - the caller must have allowance for ``from``'s tokens of at least
373      * `amount`.
374      */
375     function transferFrom(
376         address from,
377         address to,
378         uint256 amount
379     ) public virtual override returns (bool) {
380         address spender = _msgSender();
381         _spendAllowance(from, spender, amount);
382         _transfer(from, to, amount);
383         return true;
384     }
385 
386     /**
387      * @dev Atomically increases the allowance granted to `spender` by the caller.
388      *
389      * This is an alternative to {approve} that can be used as a mitigation for
390      * problems described in {IERC20-approve}.
391      *
392      * Emits an {Approval} event indicating the updated allowance.
393      *
394      * Requirements:
395      *
396      * - `spender` cannot be the zero address.
397      */
398     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
399         address owner = _msgSender();
400         _approve(owner, spender, allowance(owner, spender) + addedValue);
401         return true;
402     }
403 
404     /**
405      * @dev Atomically decreases the allowance granted to `spender` by the caller.
406      *
407      * This is an alternative to {approve} that can be used as a mitigation for
408      * problems described in {IERC20-approve}.
409      *
410      * Emits an {Approval} event indicating the updated allowance.
411      *
412      * Requirements:
413      *
414      * - `spender` cannot be the zero address.
415      * - `spender` must have allowance for the caller of at least
416      * `subtractedValue`.
417      */
418     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
419         address owner = _msgSender();
420         uint256 currentAllowance = allowance(owner, spender);
421         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
422         unchecked {
423             _approve(owner, spender, currentAllowance - subtractedValue);
424         }
425 
426         return true;
427     }
428 
429     /**
430      * @dev Moves `amount` of tokens from `sender` to `recipient`.
431      *
432      * This internal function is equivalent to {transfer}, and can be used to
433      * e.g. implement automatic token fees, slashing mechanisms, etc.
434      *
435      * Emits a {Transfer} event.
436      *
437      * Requirements:
438      *
439      * - `from` cannot be the zero address.
440      * - `to` cannot be the zero address.
441      * - `from` must have a balance of at least `amount`.
442      */
443     function _transfer(
444         address from,
445         address to,
446         uint256 amount
447     ) internal virtual {
448         require(from != address(0), "ERC20: transfer from the zero address");
449         require(to != address(0), "ERC20: transfer to the zero address");
450 
451         _beforeTokenTransfer(from, to, amount);
452 
453         uint256 fromBalance = _balances[from];
454         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
455         unchecked {
456             _balances[from] = fromBalance - amount;
457         }
458         _balances[to] += amount;
459 
460         emit Transfer(from, to, amount);
461 
462         _afterTokenTransfer(from, to, amount);
463     }
464 
465     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
466      * the total supply.
467      *
468      * Emits a {Transfer} event with `from` set to the zero address.
469      *
470      * Requirements:
471      *
472      * - `account` cannot be the zero address.
473      */
474     function _mint(address account, uint256 amount) internal virtual {
475         require(account != address(0), "ERC20: mint to the zero address");
476 
477         _beforeTokenTransfer(address(0), account, amount);
478 
479         _totalSupply += amount;
480         _balances[account] += amount;
481         emit Transfer(address(0), account, amount);
482 
483         _afterTokenTransfer(address(0), account, amount);
484     }
485 
486     /**
487      * @dev Destroys `amount` tokens from `account`, reducing the
488      * total supply.
489      *
490      * Emits a {Transfer} event with `to` set to the zero address.
491      *
492      * Requirements:
493      *
494      * - `account` cannot be the zero address.
495      * - `account` must have at least `amount` tokens.
496      */
497     function _burn(address account, uint256 amount) internal virtual {
498         require(account != address(0), "ERC20: burn from the zero address");
499 
500         _beforeTokenTransfer(account, address(0), amount);
501 
502         uint256 accountBalance = _balances[account];
503         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
504         unchecked {
505             _balances[account] = accountBalance - amount;
506         }
507         _totalSupply -= amount;
508 
509         emit Transfer(account, address(0), amount);
510 
511         _afterTokenTransfer(account, address(0), amount);
512     }
513 
514     /**
515      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
516      *
517      * This internal function is equivalent to `approve`, and can be used to
518      * e.g. set automatic allowances for certain subsystems, etc.
519      *
520      * Emits an {Approval} event.
521      *
522      * Requirements:
523      *
524      * - `owner` cannot be the zero address.
525      * - `spender` cannot be the zero address.
526      */
527     function _approve(
528         address owner,
529         address spender,
530         uint256 amount
531     ) internal virtual {
532         require(owner != address(0), "ERC20: approve from the zero address");
533         require(spender != address(0), "ERC20: approve to the zero address");
534 
535         _allowances[owner][spender] = amount;
536         emit Approval(owner, spender, amount);
537     }
538 
539     /**
540      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
541      *
542      * Does not update the allowance amount in case of infinite allowance.
543      * Revert if not enough allowance is available.
544      *
545      * Might emit an {Approval} event.
546      */
547     function _spendAllowance(
548         address owner,
549         address spender,
550         uint256 amount
551     ) internal virtual {
552         uint256 currentAllowance = allowance(owner, spender);
553         if (currentAllowance != type(uint256).max) {
554             require(currentAllowance >= amount, "ERC20: insufficient allowance");
555             unchecked {
556                 _approve(owner, spender, currentAllowance - amount);
557             }
558         }
559     }
560 
561     /**
562      * @dev Hook that is called before any transfer of tokens. This includes
563      * minting and burning.
564      *
565      * Calling conditions:
566      *
567      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
568      * will be transferred to `to`.
569      * - when `from` is zero, `amount` tokens will be minted for `to`.
570      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
571      * - `from` and `to` are never both zero.
572      *
573      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
574      */
575     function _beforeTokenTransfer(
576         address from,
577         address to,
578         uint256 amount
579     ) internal virtual {}
580 
581     /**
582      * @dev Hook that is called after any transfer of tokens. This includes
583      * minting and burning.
584      *
585      * Calling conditions:
586      *
587      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
588      * has been transferred to `to`.
589      * - when `from` is zero, `amount` tokens have been minted for `to`.
590      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
591      * - `from` and `to` are never both zero.
592      *
593      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
594      */
595     function _afterTokenTransfer(
596         address from,
597         address to,
598         uint256 amount
599     ) internal virtual {}
600 }
601 
602 // File: contracts/20token.sol
603 
604 
605 pragma solidity ^0.8.4;
606 
607 
608 
609 contract TORCH is ERC20, Ownable {
610     constructor() ERC20("TORCH", "TORCH") {
611         _mint(msg.sender, 500000000000 * 10 ** decimals());
612     }
613 }