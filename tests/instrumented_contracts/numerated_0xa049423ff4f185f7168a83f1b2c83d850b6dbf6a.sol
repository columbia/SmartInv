1 /**
2  ⠀⠀.-=( Pac-Man )=-.
3 ================================================.
4      .-.   .-.     .--.                         |
5     | OO| | OO|   / _.-' .-.   .-.  .-.   .''.  |  
6     |   | |   |   \  '-. '-'   '-'  '-'   '..'  | 
7     '^^^' '^^^'    '--'                         |
8 ===============.  .-.  .================.  .-.  |
9                | |   | |                |  '-'  |
10                | |   | |                |       |
11                | ':-:' |                |  .-.  |
12                |  '-'  |                |  '-'  |
13 ==============='       '================'       |
14 
15 ------------------------------------------------
16 Celebrate Pac-Man's 43rd birthday
17 Join Us 
18 Telegram : https://t.me/pacmanworld
19 Website  : https://pacmanworld.io/
20 Medium   : https://pacmanworld.medium.com/
21 */
22 
23 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
24 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
25 // SPDX-License-Identifier: MIT
26 /**
27  * @dev Provides information about the current execution context, including the
28  * sender of the transaction and its data. While these are generally available
29  * via msg.sender and msg.data, they should not be accessed in such a direct
30  * manner, since when dealing with meta-transactions the account sending and
31  * paying for execution may not be the actual sender (as far as an application
32  * is concerned).
33  *
34  * This contract is only required for intermediate, library-like contracts.
35  */
36 abstract contract Context {
37     function _msgSender() internal view virtual returns (address) {
38         return msg.sender;
39     }
40 
41     function _msgData() internal view virtual returns (bytes calldata) {
42         return msg.data;
43     }
44 }
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
71      * @dev Throws if called by any account other than the owner.
72      */
73     modifier onlyOwner() {
74         _checkOwner();
75         _;
76     }
77 
78     /**
79      * @dev Returns the address of the current owner.
80      */
81     function owner() public view virtual returns (address) {
82         return _owner;
83     }
84 
85     /**
86      * @dev Throws if the sender is not the owner.
87      */
88     function _checkOwner() internal view virtual {
89         require(owner() == _msgSender(), "Ownable: caller is not the owner");
90     }
91 
92     /**
93      * @dev Leaves the contract without owner. It will not be possible to call
94      * `onlyOwner` functions anymore. Can only be called by the current owner.
95      *
96      * NOTE: Renouncing ownership will leave the contract without an owner,
97      * thereby removing any functionality that is only available to the owner.
98      */
99     function renounceOwnership() public virtual onlyOwner {
100         _transferOwnership(address(0));
101     }
102 
103     /**
104      * @dev Transfers ownership of the contract to a new account (`newOwner`).
105      * Can only be called by the current owner.
106      */
107     function transferOwnership(address newOwner) public virtual onlyOwner {
108         require(newOwner != address(0), "Ownable: new owner is the zero address");
109         _transferOwnership(newOwner);
110     }
111 
112     /**
113      * @dev Transfers ownership of the contract to a new account (`newOwner`).
114      * Internal function without access restriction.
115      */
116     function _transferOwnership(address newOwner) internal virtual {
117         address oldOwner = _owner;
118         _owner = newOwner;
119         emit OwnershipTransferred(oldOwner, newOwner);
120     }
121 }
122 
123 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
124 
125 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
126 
127 /**
128  * @dev Interface of the ERC20 standard as defined in the EIP.
129  */
130 interface IERC20 {
131     /**
132      * @dev Emitted when `value` tokens are moved from one account (`from`) to
133      * another (`to`).
134      *
135      * Note that `value` may be zero.
136      */
137     event Transfer(address indexed from, address indexed to, uint256 value);
138 
139     /**
140      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
141      * a call to {approve}. `value` is the new allowance.
142      */
143     event Approval(address indexed owner, address indexed spender, uint256 value);
144 
145     /**
146      * @dev Returns the amount of tokens in existence.
147      */
148     function totalSupply() external view returns (uint256);
149 
150     /**
151      * @dev Returns the amount of tokens owned by `account`.
152      */
153     function balanceOf(address account) external view returns (uint256);
154 
155     /**
156      * @dev Moves `amount` tokens from the caller's account to `to`.
157      *
158      * Returns a boolean value indicating whether the operation succeeded.
159      *
160      * Emits a {Transfer} event.
161      */
162     function transfer(address to, uint256 amount) external returns (bool);
163 
164     /**
165      * @dev Returns the remaining number of tokens that `spender` will be
166      * allowed to spend on behalf of `owner` through {transferFrom}. This is
167      * zero by default.
168      *
169      * This value changes when {approve} or {transferFrom} are called.
170      */
171     function allowance(address owner, address spender) external view returns (uint256);
172 
173     /**
174      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
175      *
176      * Returns a boolean value indicating whether the operation succeeded.
177      *
178      * IMPORTANT: Beware that changing an allowance with this method brings the risk
179      * that someone may use both the old and the new allowance by unfortunate
180      * transaction ordering. One possible solution to mitigate this race
181      * condition is to first reduce the spender's allowance to 0 and set the
182      * desired value afterwards:
183      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
184      *
185      * Emits an {Approval} event.
186      */
187     function approve(address spender, uint256 amount) external returns (bool);
188 
189     /**
190      * @dev Moves `amount` tokens from `from` to `to` using the
191      * allowance mechanism. `amount` is then deducted from the caller's
192      * allowance.
193      *
194      * Returns a boolean value indicating whether the operation succeeded.
195      *
196      * Emits a {Transfer} event.
197      */
198     function transferFrom(
199         address from,
200         address to,
201         uint256 amount
202     ) external returns (bool);
203 }
204 
205 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
206 
207 /**
208  * @dev Interface for the optional metadata functions from the ERC20 standard.
209  *
210  * _Available since v4.1._
211  */
212 interface IERC20Metadata is IERC20 {
213     /**
214      * @dev Returns the name of the token.
215      */
216     function name() external view returns (string memory);
217 
218     /**
219      * @dev Returns the symbol of the token.
220      */
221     function symbol() external view returns (string memory);
222 
223     /**
224      * @dev Returns the decimals places of the token.
225      */
226     function decimals() external view returns (uint8);
227 }
228 
229 /**
230  * @dev Implementation of the {IERC20} interface.
231  *
232  * This implementation is agnostic to the way tokens are created. This means
233  * that a supply mechanism has to be added in a derived contract using {_mint}.
234  * For a generic mechanism see {ERC20PresetMinterPauser}.
235  *
236  * TIP: For a detailed writeup see our guide
237  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
238  * to implement supply mechanisms].
239  *
240  * We have followed general OpenZeppelin Contracts guidelines: functions revert
241  * instead returning `false` on failure. This behavior is nonetheless
242  * conventional and does not conflict with the expectations of ERC20
243  * applications.
244  *
245  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
246  * This allows applications to reconstruct the allowance for all accounts just
247  * by listening to said events. Other implementations of the EIP may not emit
248  * these events, as it isn't required by the specification.
249  *
250  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
251  * functions have been added to mitigate the well-known issues around setting
252  * allowances. See {IERC20-approve}.
253  */
254 contract ERC20 is Context, IERC20, IERC20Metadata {
255     mapping(address => uint256) private _balances;
256 
257     mapping(address => mapping(address => uint256)) private _allowances;
258 
259     uint256 private _totalSupply;
260 
261     string private _name;
262     string private _symbol;
263 
264     /**
265      * @dev Sets the values for {name} and {symbol}.
266      *
267      * The default value of {decimals} is 18. To select a different value for
268      * {decimals} you should overload it.
269      *
270      * All two of these values are immutable: they can only be set once during
271      * construction.
272      */
273     constructor(string memory name_, string memory symbol_) {
274         _name = name_;
275         _symbol = symbol_;
276     }
277 
278     /**
279      * @dev Returns the name of the token.
280      */
281     function name() public view virtual override returns (string memory) {
282         return _name;
283     }
284 
285     /**
286      * @dev Returns the symbol of the token, usually a shorter version of the
287      * name.
288      */
289     function symbol() public view virtual override returns (string memory) {
290         return _symbol;
291     }
292 
293     /**
294      * @dev Returns the number of decimals used to get its user representation.
295      * For example, if `decimals` equals `2`, a balance of `505` tokens should
296      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
297      *
298      * Tokens usually opt for a value of 18, imitating the relationship between
299      * Ether and Wei. This is the value {ERC20} uses, unless this function is
300      * overridden;
301      *
302      * NOTE: This information is only used for _display_ purposes: it in
303      * no way affects any of the arithmetic of the contract, including
304      * {IERC20-balanceOf} and {IERC20-transfer}.
305      */
306     function decimals() public view virtual override returns (uint8) {
307         return 18;
308     }
309 
310     /**
311      * @dev See {IERC20-totalSupply}.
312      */
313     function totalSupply() public view virtual override returns (uint256) {
314         return _totalSupply;
315     }
316 
317     /**
318      * @dev See {IERC20-balanceOf}.
319      */
320     function balanceOf(address account) public view virtual override returns (uint256) {
321         return _balances[account];
322     }
323 
324     /**
325      * @dev See {IERC20-transfer}.
326      *
327      * Requirements:
328      *
329      * - `to` cannot be the zero address.
330      * - the caller must have a balance of at least `amount`.
331      */
332     function transfer(address to, uint256 amount) public virtual override returns (bool) {
333         address owner = _msgSender();
334         _transfer(owner, to, amount);
335         return true;
336     }
337 
338     /**
339      * @dev See {IERC20-allowance}.
340      */
341     function allowance(address owner, address spender) public view virtual override returns (uint256) {
342         return _allowances[owner][spender];
343     }
344 
345     /**
346      * @dev See {IERC20-approve}.
347      *
348      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
349      * `transferFrom`. This is semantically equivalent to an infinite approval.
350      *
351      * Requirements:
352      *
353      * - `spender` cannot be the zero address.
354      */
355     function approve(address spender, uint256 amount) public virtual override returns (bool) {
356         address owner = _msgSender();
357         _approve(owner, spender, amount);
358         return true;
359     }
360 
361     /**
362      * @dev See {IERC20-transferFrom}.
363      *
364      * Emits an {Approval} event indicating the updated allowance. This is not
365      * required by the EIP. See the note at the beginning of {ERC20}.
366      *
367      * NOTE: Does not update the allowance if the current allowance
368      * is the maximum `uint256`.
369      *
370      * Requirements:
371      *
372      * - `from` and `to` cannot be the zero address.
373      * - `from` must have a balance of at least `amount`.
374      * - the caller must have allowance for ``from``'s tokens of at least
375      * `amount`.
376      */
377     function transferFrom(
378         address from,
379         address to,
380         uint256 amount
381     ) public virtual override returns (bool) {
382         address spender = _msgSender();
383         _spendAllowance(from, spender, amount);
384         _transfer(from, to, amount);
385         return true;
386     }
387 
388     /**
389      * @dev Atomically increases the allowance granted to `spender` by the caller.
390      *
391      * This is an alternative to {approve} that can be used as a mitigation for
392      * problems described in {IERC20-approve}.
393      *
394      * Emits an {Approval} event indicating the updated allowance.
395      *
396      * Requirements:
397      *
398      * - `spender` cannot be the zero address.
399      */
400     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
401         address owner = _msgSender();
402         _approve(owner, spender, allowance(owner, spender) + addedValue);
403         return true;
404     }
405 
406     /**
407      * @dev Atomically decreases the allowance granted to `spender` by the caller.
408      *
409      * This is an alternative to {approve} that can be used as a mitigation for
410      * problems described in {IERC20-approve}.
411      *
412      * Emits an {Approval} event indicating the updated allowance.
413      *
414      * Requirements:
415      *
416      * - `spender` cannot be the zero address.
417      * - `spender` must have allowance for the caller of at least
418      * `subtractedValue`.
419      */
420     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
421         address owner = _msgSender();
422         uint256 currentAllowance = allowance(owner, spender);
423         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
424         unchecked {
425             _approve(owner, spender, currentAllowance - subtractedValue);
426         }
427 
428         return true;
429     }
430 
431     /**
432      * @dev Moves `amount` of tokens from `from` to `to`.
433      *
434      * This internal function is equivalent to {transfer}, and can be used to
435      * e.g. implement automatic token fees, slashing mechanisms, etc.
436      *
437      * Emits a {Transfer} event.
438      *
439      * Requirements:
440      *
441      * - `from` cannot be the zero address.
442      * - `to` cannot be the zero address.
443      * - `from` must have a balance of at least `amount`.
444      */
445     function _transfer(
446         address from,
447         address to,
448         uint256 amount
449     ) internal virtual {
450         require(from != address(0), "ERC20: transfer from the zero address");
451         require(to != address(0), "ERC20: transfer to the zero address");
452 
453         _beforeTokenTransfer(from, to, amount);
454 
455         uint256 fromBalance = _balances[from];
456         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
457         unchecked {
458             _balances[from] = fromBalance - amount;
459             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
460             // decrementing then incrementing.
461             _balances[to] += amount;
462         }
463 
464         emit Transfer(from, to, amount);
465 
466         _afterTokenTransfer(from, to, amount);
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
484         unchecked {
485             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
486             _balances[account] += amount;
487         }
488         emit Transfer(address(0), account, amount);
489 
490         _afterTokenTransfer(address(0), account, amount);
491     }
492 
493     /**
494      * @dev Destroys `amount` tokens from `account`, reducing the
495      * total supply.
496      *
497      * Emits a {Transfer} event with `to` set to the zero address.
498      *
499      * Requirements:
500      *
501      * - `account` cannot be the zero address.
502      * - `account` must have at least `amount` tokens.
503      */
504     function _burn(address account, uint256 amount) internal virtual {
505         require(account != address(0), "ERC20: burn from the zero address");
506 
507         _beforeTokenTransfer(account, address(0), amount);
508 
509         uint256 accountBalance = _balances[account];
510         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
511         unchecked {
512             _balances[account] = accountBalance - amount;
513             // Overflow not possible: amount <= accountBalance <= totalSupply.
514             _totalSupply -= amount;
515         }
516 
517         emit Transfer(account, address(0), amount);
518 
519         _afterTokenTransfer(account, address(0), amount);
520     }
521 
522     /**
523      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
524      *
525      * This internal function is equivalent to `approve`, and can be used to
526      * e.g. set automatic allowances for certain subsystems, etc.
527      *
528      * Emits an {Approval} event.
529      *
530      * Requirements:
531      *
532      * - `owner` cannot be the zero address.
533      * - `spender` cannot be the zero address.
534      */
535     function _approve(
536         address owner,
537         address spender,
538         uint256 amount
539     ) internal virtual {
540         require(owner != address(0), "ERC20: approve from the zero address");
541         require(spender != address(0), "ERC20: approve to the zero address");
542 
543         _allowances[owner][spender] = amount;
544         emit Approval(owner, spender, amount);
545     }
546 
547     /**
548      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
549      *
550      * Does not update the allowance amount in case of infinite allowance.
551      * Revert if not enough allowance is available.
552      *
553      * Might emit an {Approval} event.
554      */
555     function _spendAllowance(
556         address owner,
557         address spender,
558         uint256 amount
559     ) internal virtual {
560         uint256 currentAllowance = allowance(owner, spender);
561         if (currentAllowance != type(uint256).max) {
562             require(currentAllowance >= amount, "ERC20: insufficient allowance");
563             unchecked {
564                 _approve(owner, spender, currentAllowance - amount);
565             }
566         }
567     }
568 
569     /**
570      * @dev Hook that is called before any transfer of tokens. This includes
571      * minting and burning.
572      *
573      * Calling conditions:
574      *
575      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
576      * will be transferred to `to`.
577      * - when `from` is zero, `amount` tokens will be minted for `to`.
578      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
579      * - `from` and `to` are never both zero.
580      *
581      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
582      */
583     function _beforeTokenTransfer(
584         address from,
585         address to,
586         uint256 amount
587     ) internal virtual {}
588 
589     /**
590      * @dev Hook that is called after any transfer of tokens. This includes
591      * minting and burning.
592      *
593      * Calling conditions:
594      *
595      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
596      * has been transferred to `to`.
597      * - when `from` is zero, `amount` tokens have been minted for `to`.
598      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
599      * - `from` and `to` are never both zero.
600      *
601      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
602      */
603     function _afterTokenTransfer(
604         address from,
605         address to,
606         uint256 amount
607     ) internal virtual {}
608 }
609 
610 pragma solidity ^0.8.0;
611 
612 contract PacManWorld is Ownable, ERC20 {
613     constructor(uint256 _totalSupply) ERC20("PAC-MAN", "Pac-Man") {
614         _mint(msg.sender, _totalSupply);
615     }
616 
617     function burn(uint256 value) external {
618         _burn(msg.sender, value);
619     }
620 
621     receive() external payable {
622         revert();
623     }
624 
625     fallback() external {
626         revert();
627     }
628 }