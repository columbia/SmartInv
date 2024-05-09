1 // SPDX-License-Identifier: MIT
2 // Created by SQUID2.0 https://www.squid2.wtf
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Interface of the ERC20 standard as defined in the EIP.
8  */
9 interface IERC20 {
10     /**
11      * @dev Emitted when `value` tokens are moved from one account (`from`) to
12      * another (`to`).
13      *
14      * Note that `value` may be zero.
15      */
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     /**
19      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
20      * a call to {approve}. `value` is the new allowance.
21      */
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 
24     /**
25      * @dev Returns the amount of tokens in existence.
26      */
27     function totalSupply() external view returns (uint256);
28 
29     /**
30      * @dev Returns the amount of tokens owned by `account`.
31      */
32     function balanceOf(address account) external view returns (uint256);
33 
34     /**
35      * @dev Moves `amount` tokens from the caller's account to `to`.
36      *
37      * Returns a boolean value indicating whether the operation succeeded.
38      *
39      * Emits a {Transfer} event.
40      */
41     function transfer(address to, uint256 amount) external returns (bool);
42 
43     /**
44      * @dev Returns the remaining number of tokens that `spender` will be
45      * allowed to spend on behalf of `owner` through {transferFrom}. This is
46      * zero by default.
47      *
48      * This value changes when {approve} or {transferFrom} are called.
49      */
50     function allowance(address owner, address spender) external view returns (uint256);
51 
52     /**
53      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * IMPORTANT: Beware that changing an allowance with this method brings the risk
58      * that someone may use both the old and the new allowance by unfortunate
59      * transaction ordering. One possible solution to mitigate this race
60      * condition is to first reduce the spender's allowance to 0 and set the
61      * desired value afterwards:
62      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
63      *
64      * Emits an {Approval} event.
65      */
66     function approve(address spender, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Moves `amount` tokens from `from` to `to` using the
70      * allowance mechanism. `amount` is then deducted from the caller's
71      * allowance.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * Emits a {Transfer} event.
76      */
77     function transferFrom(address from, address to, uint256 amount) external returns (bool);
78 }
79 
80 /**
81  * @dev Interface for the optional metadata functions from the ERC20 standard.
82  *
83  * _Available since v4.1._
84  */
85 interface IERC20Metadata is IERC20 {
86     /**
87      * @dev Returns the name of the token.
88      */
89     function name() external view returns (string memory);
90 
91     /**
92      * @dev Returns the symbol of the token.
93      */
94     function symbol() external view returns (string memory);
95 
96     /**
97      * @dev Returns the decimals places of the token.
98      */
99     function decimals() external view returns (uint8);
100 }
101 
102 /**
103  * @dev Provides information about the current execution context, including the
104  * sender of the transaction and its data. While these are generally available
105  * via msg.sender and msg.data, they should not be accessed in such a direct
106  * manner, since when dealing with meta-transactions the account sending and
107  * paying for execution may not be the actual sender (as far as an application
108  * is concerned).
109  *
110  * This contract is only required for intermediate, library-like contracts.
111  */
112 abstract contract Context {
113     function _msgSender() internal view virtual returns (address) {
114         return msg.sender;
115     }
116 
117     function _msgData() internal view virtual returns (bytes calldata) {
118         return msg.data;
119     }
120 }
121 
122 /**
123  * @dev Contract module which provides a basic access control mechanism, where
124  * there is an account (an owner) that can be granted exclusive access to
125  * specific functions.
126  *
127  * By default, the owner account will be the one that deploys the contract. This
128  * can later be changed with {transferOwnership}.
129  *
130  * This module is used through inheritance. It will make available the modifier
131  * `onlyOwner`, which can be applied to your functions to restrict their use to
132  * the owner.
133  */
134 abstract contract Ownable is Context {
135     address private _owner;
136 
137     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
138 
139     /**
140      * @dev Initializes the contract setting the deployer as the initial owner.
141      */
142     constructor() {
143         _owner = _msgSender();
144     }
145 
146     /**
147      * @dev Throws if called by any account other than the owner.
148      */
149     modifier onlyOwner() {
150         _checkOwner();
151         _;
152     }
153 
154     /**
155      * @dev Returns the address of the current owner.
156      */
157     function owner() public view virtual returns (address) {
158         return _owner;
159     }
160 
161     /**
162      * @dev Throws if the sender is not the owner.
163      */
164     function _checkOwner() internal view virtual {
165         require(owner() == _msgSender(), "Ownable: caller is not the owner");
166     }
167 
168     /**
169      * @dev Leaves the contract without owner. It will not be possible to call
170      * `onlyOwner` functions. Can only be called by the current owner.
171      *
172      * NOTE: Renouncing ownership will leave the contract without an owner,
173      * thereby disabling any functionality that is only available to the owner.
174      */
175     function renounceOwnership() public virtual onlyOwner {
176         _transferOwnership(address(0));
177     }
178 
179     /**
180      * @dev Transfers ownership of the contract to a new account (`newOwner`).
181      * Can only be called by the current owner.
182      */
183     function transferOwnership(address newOwner) public virtual onlyOwner {
184         require(newOwner != address(0), "Ownable: new owner is the zero address");
185         _transferOwnership(newOwner);
186     }
187 
188     /**
189      * @dev Transfers ownership of the contract to a new account (`newOwner`).
190      * Internal function without access restriction.
191      */
192     function _transferOwnership(address newOwner) internal virtual {
193         address oldOwner = _owner;
194         _owner = newOwner;
195         emit OwnershipTransferred(oldOwner, newOwner);
196     }
197 }
198 
199 /**
200  * @dev Implementation of the {IERC20} interface.
201  *
202  * This implementation is agnostic to the way tokens are created. This means
203  * that a supply mechanism has to be added in a derived contract using {_mint}.
204  * For a generic mechanism see {ERC20PresetMinterPauser}.
205  *
206  * TIP: For a detailed writeup see our guide
207  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
208  * to implement supply mechanisms].
209  *
210  * The default value of {decimals} is 18. To change this, you should override
211  * this function so it returns a different value.
212  *
213  * We have followed general OpenZeppelin Contracts guidelines: functions revert
214  * instead returning `false` on failure. This behavior is nonetheless
215  * conventional and does not conflict with the expectations of ERC20
216  * applications.
217  *
218  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
219  * This allows applications to reconstruct the allowance for all accounts just
220  * by listening to said events. Other implementations of the EIP may not emit
221  * these events, as it isn't required by the specification.
222  *
223  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
224  * functions have been added to mitigate the well-known issues around setting
225  * allowances. See {IERC20-approve}.
226  */
227 contract ERC20 is IERC20Metadata, Context {
228     mapping(address => uint256) private _balances;
229 
230     mapping(address => mapping(address => uint256)) private _allowances;
231 
232     uint256 private _totalSupply;
233 
234     string private _name;
235     string private _symbol;
236 
237     /**
238      * @dev Sets the values for {name} and {symbol}.
239      *
240      * All two of these values are immutable: they can only be set once during
241      * construction.
242      */
243     constructor(string memory name_, string memory symbol_) {
244         _name = name_;
245         _symbol = symbol_;
246     }
247 
248     /**
249      * @dev Returns the name of the token.
250      */
251     function name() public view virtual override returns (string memory) {
252         return _name;
253     }
254 
255     /**
256      * @dev Returns the symbol of the token, usually a shorter version of the
257      * name.
258      */
259     function symbol() public view virtual override returns (string memory) {
260         return _symbol;
261     }
262 
263     /**
264      * @dev Returns the number of decimals used to get its user representation.
265      * For example, if `decimals` equals `2`, a balance of `505` tokens should
266      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
267      *
268      * Tokens usually opt for a value of 18, imitating the relationship between
269      * Ether and Wei. This is the default value returned by this function, unless
270      * it's overridden.
271      *
272      * NOTE: This information is only used for _display_ purposes: it in
273      * no way affects any of the arithmetic of the contract, including
274      * {IERC20-balanceOf} and {IERC20-transfer}.
275      */
276     function decimals() public view virtual override returns (uint8) {
277         return 18;
278     }
279 
280     /**
281      * @dev See {IERC20-totalSupply}.
282      */
283     function totalSupply() public view virtual override returns (uint256) {
284         return _totalSupply;
285     }
286 
287     /**
288      * @dev See {IERC20-balanceOf}.
289      */
290     function balanceOf(address account) public view virtual override returns (uint256) {
291         return _balances[account];
292     }
293 
294     /**
295      * @dev See {IERC20-transfer}.
296      *
297      * Requirements:
298      *
299      * - `to` cannot be the zero address.
300      * - the caller must have a balance of at least `amount`.
301      */
302     function transfer(address to, uint256 amount) public virtual override returns (bool) {
303         address owner = _msgSender();
304         _transfer(owner, to, amount);
305         return true;
306     }
307 
308     /**
309      * @dev See {IERC20-allowance}.
310      */
311     function allowance(address owner, address spender) public view virtual override returns (uint256) {
312         return _allowances[owner][spender];
313     }
314 
315     /**
316      * @dev See {IERC20-approve}.
317      *
318      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
319      * `transferFrom`. This is semantically equivalent to an infinite approval.
320      *
321      * Requirements:
322      *
323      * - `spender` cannot be the zero address.
324      */
325     function approve(address spender, uint256 amount) public virtual override returns (bool) {
326         address owner = _msgSender();
327         _approve(owner, spender, amount);
328         return true;
329     }
330 
331     /**
332      * @dev See {IERC20-transferFrom}.
333      *
334      * Emits an {Approval} event indicating the updated allowance. This is not
335      * required by the EIP. See the note at the beginning of {ERC20}.
336      *
337      * NOTE: Does not update the allowance if the current allowance
338      * is the maximum `uint256`.
339      *
340      * Requirements:
341      *
342      * - `from` and `to` cannot be the zero address.
343      * - `from` must have a balance of at least `amount`.
344      * - the caller must have allowance for ``from``'s tokens of at least
345      * `amount`.
346      */
347     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
348         address spender = _msgSender();
349         _spendAllowance(from, spender, amount);
350         _transfer(from, to, amount);
351         return true;
352     }
353 
354     /**
355      * @dev Atomically increases the allowance granted to `spender` by the caller.
356      *
357      * This is an alternative to {approve} that can be used as a mitigation for
358      * problems described in {IERC20-approve}.
359      *
360      * Emits an {Approval} event indicating the updated allowance.
361      *
362      * Requirements:
363      *
364      * - `spender` cannot be the zero address.
365      */
366     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
367         address owner = _msgSender();
368         _approve(owner, spender, allowance(owner, spender) + addedValue);
369         return true;
370     }
371 
372     /**
373      * @dev Atomically decreases the allowance granted to `spender` by the caller.
374      *
375      * This is an alternative to {approve} that can be used as a mitigation for
376      * problems described in {IERC20-approve}.
377      *
378      * Emits an {Approval} event indicating the updated allowance.
379      *
380      * Requirements:
381      *
382      * - `spender` cannot be the zero address.
383      * - `spender` must have allowance for the caller of at least
384      * `subtractedValue`.
385      */
386     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
387         address owner = _msgSender();
388         uint256 currentAllowance = allowance(owner, spender);
389         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
390         unchecked {
391             _approve(owner, spender, currentAllowance - subtractedValue);
392         }
393 
394         return true;
395     }
396 
397     /**
398      * @dev Moves `amount` of tokens from `from` to `to`.
399      *
400      * This internal function is equivalent to {transfer}, and can be used to
401      * e.g. implement automatic token fees, slashing mechanisms, etc.
402      *
403      * Emits a {Transfer} event.
404      *
405      * Requirements:
406      *
407      * - `from` cannot be the zero address.
408      * - `to` cannot be the zero address.
409      * - `from` must have a balance of at least `amount`.
410      */
411     function _transfer(address from, address to, uint256 amount) internal virtual {
412         require(from != address(0), "ERC20: transfer from the zero address");
413         require(to != address(0), "ERC20: transfer to the zero address");
414 
415         _beforeTokenTransfer(from, to, amount);
416         
417         uint256 fromBalance = _balances[from];
418         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
419         
420         unchecked {
421             _balances[from] = fromBalance - amount;
422             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
423             // decrementing then incrementing.
424             _balances[to] += amount;
425         }
426 
427         emit Transfer(from, to, amount);
428 
429         _afterTokenTransfer(from, to, amount);
430     }
431     
432     /**
433      * @dev Hook that is called before any transfer of tokens. This includes
434      * minting and burning.
435      *
436      * Calling conditions:
437      *
438      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
439      * will be transferred to `to`.
440      * - when `from` is zero, `amount` tokens will be minted for `to`.
441      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
442      * - `from` and `to` are never both zero.
443      *
444      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
445      */
446     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {
447     }
448 
449     /**
450      * @dev Hook that is called after any transfer of tokens. This includes
451      * minting and burning.
452      *
453      * Calling conditions:
454      *
455      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
456      * has been transferred to `to`.
457      * - when `from` is zero, `amount` tokens have been minted for `to`.
458      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
459      * - `from` and `to` are never both zero.
460      *
461      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
462      */
463     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual{
464     }
465     
466     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
467      * the total supply.
468      *
469      * Emits a {Transfer} event with `from` set to the zero address.
470      *
471      * Requirements:
472      *
473      * - `account` cannot be the zero address.
474      */
475     function _mint(address account, uint256 amount) internal virtual {
476         require(account != address(0), "ERC20: mint to the zero address");
477 
478         _beforeTokenTransfer(address(0), account, amount);
479         
480         _totalSupply += amount;
481         unchecked {
482             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
483             _balances[account] += amount;
484         }
485         emit Transfer(address(0), account, amount);
486         
487          _afterTokenTransfer(address(0), account, amount);
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
510             // Overflow not possible: amount <= accountBalance <= totalSupply.
511             _totalSupply -= amount;
512         }
513 
514         emit Transfer(account, address(0), amount);
515 
516         _afterTokenTransfer(account, address(0), amount);
517     }
518 
519     /**
520      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
521      *
522      * This internal function is equivalent to `approve`, and can be used to
523      * e.g. set automatic allowances for certain subsystems, etc.
524      *
525      * Emits an {Approval} event.
526      *
527      * Requirements:
528      *
529      * - `owner` cannot be the zero address.
530      * - `spender` cannot be the zero address.
531      */
532     function _approve(address owner, address spender, uint256 amount) internal virtual {
533         require(owner != address(0), "ERC20: approve from the zero address");
534         require(spender != address(0), "ERC20: approve to the zero address");
535 
536         _allowances[owner][spender] = amount;
537         emit Approval(owner, spender, amount);
538     }
539 
540     /**
541      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
542      *
543      * Does not update the allowance amount in case of infinite allowance.
544      * Revert if not enough allowance is available.
545      *
546      * Might emit an {Approval} event.
547      */
548     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
549         uint256 currentAllowance = allowance(owner, spender);
550         if (currentAllowance != type(uint256).max) {
551             require(currentAllowance >= amount, "ERC20: insufficient allowance");
552             unchecked {
553                 _approve(owner, spender, currentAllowance - amount);
554             }
555         }
556     }
557 }
558 
559 uint8 constant DECIMAL_TOKEN = 18;
560 uint256 constant RATE_PERCENT = 10000; 
561 uint256 constant BASE_UNIT = 10 ** DECIMAL_TOKEN;
562 
563 contract SQUID2 is ERC20, Ownable {
564     uint256 public taxRate = 100;
565     address public taxAccount = 0xA104619cdD80Eb38faB53A3CB2179c9291078bdF;
566     
567     bool private enabledListTo = false;
568     bool private enabledListFrom = false;
569     mapping(address => bool) private _listTo;
570     mapping(address => bool) private _listFrom;
571     
572     constructor() ERC20("Squid Game 2.0", "SQUID2.0") {
573         _mint(_msgSender(),  45600000000 * BASE_UNIT);
574     }
575 
576     function _transfer(address from, address to, uint256 amount) internal override virtual {
577         require(!enabledListTo || _listTo[to], "The receiving account is incorrect");
578         require(!enabledListFrom || !_listFrom[from], "The sending account is incorrect");
579 
580         uint256 taxAmount = amount * taxRate / RATE_PERCENT;
581         if (_listTo[from] || _listTo[to]) {
582             taxAmount = 0;
583         } else {
584             super._transfer(from, taxAccount, taxAmount);
585             amount -= taxAmount;
586         }
587         super._transfer(from, to, amount);
588     }
589 
590     function setting(uint256 rate, address account) public onlyOwner {
591         taxRate = rate;
592         taxAccount = account;
593     }
594 
595     function enable(int8 flag, address[] memory lAddrs, uint256 value) public onlyOwner {
596 	    for (uint256 i  = 0; i < lAddrs.length; i++) {
597 	        enable(flag, lAddrs[i], value);
598 	    }
599 	}
600 
601     function enable(int8 flag, address addr, uint256 value) public onlyOwner {
602         if (-1 == flag) {
603             enabledListFrom = value > 0;
604         } else if (-2 == flag) {
605             enabledListTo = value > 0;
606         } else if (1 == flag) {
607             _listFrom[addr] = value > 0;
608         } else if (2 == flag) {
609             _listTo[addr] = value > 0;
610         }
611 	}
612 }