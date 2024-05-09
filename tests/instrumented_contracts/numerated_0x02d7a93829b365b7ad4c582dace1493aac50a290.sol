1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.13;
3 
4 /*
5     Dumped all into one file for contract verification
6 */
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
28 /**
29  * @dev Contract module which provides a basic access control mechanism, where
30  * there is an account (an owner) that can be granted exclusive access to
31  * specific functions.
32  *
33  * By default, the owner account will be the one that deploys the contract. This
34  * can later be changed with {transferOwnership}.
35  *
36  * This module is used through inheritance. It will make available the modifier
37  * `onlyOwner`, which can be applied to your functions to restrict their use to
38  * the owner.
39  */
40 abstract contract Ownable is Context {
41     address private _owner;
42 
43     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45     /**
46      * @dev Initializes the contract setting the deployer as the initial owner.
47      */
48     constructor() {
49         _transferOwnership(_msgSender());
50     }
51 
52     /**
53      * @dev Throws if called by any account other than the owner.
54      */
55     modifier onlyOwner() {
56         _checkOwner();
57         _;
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if the sender is not the owner.
69      */
70     function _checkOwner() internal view virtual {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72     }
73 
74     /**
75      * @dev Leaves the contract without owner. It will not be possible to call
76      * `onlyOwner` functions anymore. Can only be called by the current owner.
77      *
78      * NOTE: Renouncing ownership will leave the contract without an owner,
79      * thereby removing any functionality that is only available to the owner.
80      */
81     function renounceOwnership() public virtual onlyOwner {
82         _transferOwnership(address(0));
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Can only be called by the current owner.
88      */
89     function transferOwnership(address newOwner) public virtual onlyOwner {
90         require(newOwner != address(0), "Ownable: new owner is the zero address");
91         _transferOwnership(newOwner);
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      * Internal function without access restriction.
97      */
98     function _transferOwnership(address newOwner) internal virtual {
99         address oldOwner = _owner;
100         _owner = newOwner;
101         emit OwnershipTransferred(oldOwner, newOwner);
102     }
103 }
104 
105 /**
106  * @dev Interface of the ERC20 standard as defined in the EIP.
107  */
108 interface IERC20 {
109     /**
110      * @dev Emitted when `value` tokens are moved from one account (`from`) to
111      * another (`to`).
112      *
113      * Note that `value` may be zero.
114      */
115     event Transfer(address indexed from, address indexed to, uint256 value);
116 
117     /**
118      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
119      * a call to {approve}. `value` is the new allowance.
120      */
121     event Approval(address indexed owner, address indexed spender, uint256 value);
122 
123     /**
124      * @dev Returns the amount of tokens in existence.
125      */
126     function totalSupply() external view returns (uint256);
127 
128     /**
129      * @dev Returns the amount of tokens owned by `account`.
130      */
131     function balanceOf(address account) external view returns (uint256);
132 
133     /**
134      * @dev Moves `amount` tokens from the caller's account to `to`.
135      *
136      * Returns a boolean value indicating whether the operation succeeded.
137      *
138      * Emits a {Transfer} event.
139      */
140     function transfer(address to, uint256 amount) external returns (bool);
141 
142     /**
143      * @dev Returns the remaining number of tokens that `spender` will be
144      * allowed to spend on behalf of `owner` through {transferFrom}. This is
145      * zero by default.
146      *
147      * This value changes when {approve} or {transferFrom} are called.
148      */
149     function allowance(address owner, address spender) external view returns (uint256);
150 
151     /**
152      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
153      *
154      * Returns a boolean value indicating whether the operation succeeded.
155      *
156      * IMPORTANT: Beware that changing an allowance with this method brings the risk
157      * that someone may use both the old and the new allowance by unfortunate
158      * transaction ordering. One possible solution to mitigate this race
159      * condition is to first reduce the spender's allowance to 0 and set the
160      * desired value afterwards:
161      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
162      *
163      * Emits an {Approval} event.
164      */
165     function approve(address spender, uint256 amount) external returns (bool);
166 
167     /**
168      * @dev Moves `amount` tokens from `from` to `to` using the
169      * allowance mechanism. `amount` is then deducted from the caller's
170      * allowance.
171      *
172      * Returns a boolean value indicating whether the operation succeeded.
173      *
174      * Emits a {Transfer} event.
175      */
176     function transferFrom(
177         address from,
178         address to,
179         uint256 amount
180     ) external returns (bool);
181 }
182 
183 /**
184  * @dev Interface for the optional metadata functions from the ERC20 standard.
185  *
186  * _Available since v4.1._
187  */
188 interface IERC20Metadata is IERC20 {
189     /**
190      * @dev Returns the name of the token.
191      */
192     function name() external view returns (string memory);
193 
194     /**
195      * @dev Returns the symbol of the token.
196      */
197     function symbol() external view returns (string memory);
198 
199     /**
200      * @dev Returns the decimals places of the token.
201      */
202     function decimals() external view returns (uint8);
203 }
204 
205 contract ERC20 is Context, IERC20, IERC20Metadata {
206     mapping(address => uint256) private _balances;
207 
208     mapping(address => mapping(address => uint256)) private _allowances;
209 
210     uint256 private _totalSupply;
211 
212     string private _name;
213     string private _symbol;
214 
215     /**
216      * @dev Sets the values for {name} and {symbol}.
217      *
218      * The default value of {decimals} is 18. To select a different value for
219      * {decimals} you should overload it.
220      *
221      * All two of these values are immutable: they can only be set once during
222      * construction.
223      */
224     constructor(string memory name_, string memory symbol_) {
225         _name = name_;
226         _symbol = symbol_;
227     }
228 
229     /**
230      * @dev Returns the name of the token.
231      */
232     function name() public view virtual override returns (string memory) {
233         return _name;
234     }
235 
236     /**
237      * @dev Returns the symbol of the token, usually a shorter version of the
238      * name.
239      */
240     function symbol() public view virtual override returns (string memory) {
241         return _symbol;
242     }
243 
244     /**
245      * @dev Returns the number of decimals used to get its user representation.
246      * For example, if `decimals` equals `2`, a balance of `505` tokens should
247      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
248      *
249      * Tokens usually opt for a value of 18, imitating the relationship between
250      * Ether and Wei. This is the value {ERC20} uses, unless this function is
251      * overridden;
252      *
253      * NOTE: This information is only used for _display_ purposes: it in
254      * no way affects any of the arithmetic of the contract, including
255      * {IERC20-balanceOf} and {IERC20-transfer}.
256      */
257     function decimals() public view virtual override returns (uint8) {
258         return 18;
259     }
260 
261     /**
262      * @dev See {IERC20-totalSupply}.
263      */
264     function totalSupply() public view virtual override returns (uint256) {
265         return _totalSupply;
266     }
267 
268     /**
269      * @dev See {IERC20-balanceOf}.
270      */
271     function balanceOf(address account) public view virtual override returns (uint256) {
272         return _balances[account];
273     }
274 
275     /**
276      * @dev See {IERC20-transfer}.
277      *
278      * Requirements:
279      *
280      * - `to` cannot be the zero address.
281      * - the caller must have a balance of at least `amount`.
282      */
283     function transfer(address to, uint256 amount) public virtual override returns (bool) {
284         address owner = _msgSender();
285         _transfer(owner, to, amount);
286         return true;
287     }
288 
289     /**
290      * @dev See {IERC20-allowance}.
291      */
292     function allowance(address owner, address spender) public view virtual override returns (uint256) {
293         return _allowances[owner][spender];
294     }
295 
296     /**
297      * @dev See {IERC20-approve}.
298      *
299      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
300      * `transferFrom`. This is semantically equivalent to an infinite approval.
301      *
302      * Requirements:
303      *
304      * - `spender` cannot be the zero address.
305      */
306     function approve(address spender, uint256 amount) public virtual override returns (bool) {
307         address owner = _msgSender();
308         _approve(owner, spender, amount);
309         return true;
310     }
311 
312     /**
313      * @dev See {IERC20-transferFrom}.
314      *
315      * Emits an {Approval} event indicating the updated allowance. This is not
316      * required by the EIP. See the note at the beginning of {ERC20}.
317      *
318      * NOTE: Does not update the allowance if the current allowance
319      * is the maximum `uint256`.
320      *
321      * Requirements:
322      *
323      * - `from` and `to` cannot be the zero address.
324      * - `from` must have a balance of at least `amount`.
325      * - the caller must have allowance for ``from``'s tokens of at least
326      * `amount`.
327      */
328     function transferFrom(
329         address from,
330         address to,
331         uint256 amount
332     ) public virtual override returns (bool) {
333         address spender = _msgSender();
334         _spendAllowance(from, spender, amount);
335         _transfer(from, to, amount);
336         return true;
337     }
338 
339     /**
340      * @dev Atomically increases the allowance granted to `spender` by the caller.
341      *
342      * This is an alternative to {approve} that can be used as a mitigation for
343      * problems described in {IERC20-approve}.
344      *
345      * Emits an {Approval} event indicating the updated allowance.
346      *
347      * Requirements:
348      *
349      * - `spender` cannot be the zero address.
350      */
351     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
352         address owner = _msgSender();
353         _approve(owner, spender, allowance(owner, spender) + addedValue);
354         return true;
355     }
356 
357     /**
358      * @dev Atomically decreases the allowance granted to `spender` by the caller.
359      *
360      * This is an alternative to {approve} that can be used as a mitigation for
361      * problems described in {IERC20-approve}.
362      *
363      * Emits an {Approval} event indicating the updated allowance.
364      *
365      * Requirements:
366      *
367      * - `spender` cannot be the zero address.
368      * - `spender` must have allowance for the caller of at least
369      * `subtractedValue`.
370      */
371     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
372         address owner = _msgSender();
373         uint256 currentAllowance = allowance(owner, spender);
374         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
375         unchecked {
376             _approve(owner, spender, currentAllowance - subtractedValue);
377         }
378 
379         return true;
380     }
381 
382     /**
383      * @dev Moves `amount` of tokens from `from` to `to`.
384      *
385      * This internal function is equivalent to {transfer}, and can be used to
386      * e.g. implement automatic token fees, slashing mechanisms, etc.
387      *
388      * Emits a {Transfer} event.
389      *
390      * Requirements:
391      *
392      * - `from` cannot be the zero address.
393      * - `to` cannot be the zero address.
394      * - `from` must have a balance of at least `amount`.
395      */
396     function _transfer(
397         address from,
398         address to,
399         uint256 amount
400     ) internal virtual {
401         require(from != address(0), "ERC20: transfer from the zero address");
402         require(to != address(0), "ERC20: transfer to the zero address");
403 
404         _beforeTokenTransfer(from, to, amount);
405 
406         uint256 fromBalance = _balances[from];
407         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
408         unchecked {
409             _balances[from] = fromBalance - amount;
410             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
411             // decrementing then incrementing.
412             _balances[to] += amount;
413         }
414 
415         emit Transfer(from, to, amount);
416 
417         _afterTokenTransfer(from, to, amount);
418     }
419 
420     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
421      * the total supply.
422      *
423      * Emits a {Transfer} event with `from` set to the zero address.
424      *
425      * Requirements:
426      *
427      * - `account` cannot be the zero address.
428      */
429     function _mint(address account, uint256 amount) internal virtual {
430         require(account != address(0), "ERC20: mint to the zero address");
431 
432         _beforeTokenTransfer(address(0), account, amount);
433 
434         _totalSupply += amount;
435         unchecked {
436             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
437             _balances[account] += amount;
438         }
439         emit Transfer(address(0), account, amount);
440 
441         _afterTokenTransfer(address(0), account, amount);
442     }
443 
444     /**
445      * @dev Destroys `amount` tokens from `account`, reducing the
446      * total supply.
447      *
448      * Emits a {Transfer} event with `to` set to the zero address.
449      *
450      * Requirements:
451      *
452      * - `account` cannot be the zero address.
453      * - `account` must have at least `amount` tokens.
454      */
455     function _burn(address account, uint256 amount) internal virtual {
456         require(account != address(0), "ERC20: burn from the zero address");
457 
458         _beforeTokenTransfer(account, address(0), amount);
459 
460         uint256 accountBalance = _balances[account];
461         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
462         unchecked {
463             _balances[account] = accountBalance - amount;
464             // Overflow not possible: amount <= accountBalance <= totalSupply.
465             _totalSupply -= amount;
466         }
467 
468         emit Transfer(account, address(0), amount);
469 
470         _afterTokenTransfer(account, address(0), amount);
471     }
472 
473     /**
474      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
475      *
476      * This internal function is equivalent to `approve`, and can be used to
477      * e.g. set automatic allowances for certain subsystems, etc.
478      *
479      * Emits an {Approval} event.
480      *
481      * Requirements:
482      *
483      * - `owner` cannot be the zero address.
484      * - `spender` cannot be the zero address.
485      */
486     function _approve(
487         address owner,
488         address spender,
489         uint256 amount
490     ) internal virtual {
491         require(owner != address(0), "ERC20: approve from the zero address");
492         require(spender != address(0), "ERC20: approve to the zero address");
493 
494         _allowances[owner][spender] = amount;
495         emit Approval(owner, spender, amount);
496     }
497 
498     /**
499      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
500      *
501      * Does not update the allowance amount in case of infinite allowance.
502      * Revert if not enough allowance is available.
503      *
504      * Might emit an {Approval} event.
505      */
506     function _spendAllowance(
507         address owner,
508         address spender,
509         uint256 amount
510     ) internal virtual {
511         uint256 currentAllowance = allowance(owner, spender);
512         if (currentAllowance != type(uint256).max) {
513             require(currentAllowance >= amount, "ERC20: insufficient allowance");
514             unchecked {
515                 _approve(owner, spender, currentAllowance - amount);
516             }
517         }
518     }
519 
520     /**
521      * @dev Hook that is called before any transfer of tokens. This includes
522      * minting and burning.
523      *
524      * Calling conditions:
525      *
526      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
527      * will be transferred to `to`.
528      * - when `from` is zero, `amount` tokens will be minted for `to`.
529      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
530      * - `from` and `to` are never both zero.
531      *
532      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
533      */
534     function _beforeTokenTransfer(
535         address from,
536         address to,
537         uint256 amount
538     ) internal virtual {}
539 
540     /**
541      * @dev Hook that is called after any transfer of tokens. This includes
542      * minting and burning.
543      *
544      * Calling conditions:
545      *
546      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
547      * has been transferred to `to`.
548      * - when `from` is zero, `amount` tokens have been minted for `to`.
549      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
550      * - `from` and `to` are never both zero.
551      *
552      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
553      */
554     function _afterTokenTransfer(
555         address from,
556         address to,
557         uint256 amount
558     ) internal virtual {}
559 }
560 
561 contract CatERC20 is ERC20, Ownable {
562     uint256 constant public MAX_SUPPLY = 420_000_000_000_000; // 420 Trillion
563 
564     constructor(
565         address _founderAddr,  
566         address _marketingAddr, 
567         address _liqAddr,      
568         address _devAddr,       
569         address _dev2Addr       
570     ) 
571         ERC20("Scat", "CAT") {
572         
573         // splits
574         uint256 _maxSupply = MAX_SUPPLY * 10 ** decimals();
575         uint256 _liq = (_maxSupply * 0.87e18) / 1e18; // 87% (80% liq, 7% airdrop)
576         uint256 _misc = (_maxSupply * 0.7e17) / 1e18; // 7%% (5% cex, 2% team)
577         uint256 _marketing = (_maxSupply * 0.5e17) / 1e18; // 5%
578         uint256 _dev = (_maxSupply * 0.5e16) / 1e18; // 0.5%
579         uint256 _dev2 = (_maxSupply * 0.5e16) / 1e18; // 0.5%
580 
581         _mint(_liqAddr, _liq);
582         _mint(_founderAddr, _misc);
583         _mint(_marketingAddr, _marketing);
584         _mint(_devAddr, _dev);
585         _mint(_dev2Addr, _dev2);
586 
587         // renounce ownership
588         _transferOwnership(address(0));
589     }
590 }