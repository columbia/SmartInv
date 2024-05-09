1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.4;
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
24 /**
25  * @dev Contract module which provides a basic access control mechanism, where
26  * there is an account (an owner) that can be granted exclusive access to
27  * specific functions.
28  *
29  * By default, the owner account will be the one that deploys the contract. This
30  * can later be changed with {transferOwnership}.
31  *
32  * This module is used through inheritance. It will make available the modifier
33  * `onlyOwner`, which can be applied to your functions to restrict their use to
34  * the owner.
35  */
36 abstract contract Ownable is Context {
37     address private _owner;
38 
39     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40 
41     /**
42      * @dev Initializes the contract setting the deployer as the initial owner.
43      */
44     constructor() {
45         _transferOwnership(_msgSender());
46     }
47 
48     /**
49      * @dev Returns the address of the current owner.
50      */
51     function owner() public view virtual returns (address) {
52         return _owner;
53     }
54 
55     /**
56      * @dev Throws if called by any account other than the owner.
57      */
58     modifier onlyOwner() {
59         require(owner() == _msgSender(), "Ownable: caller is not the owner");
60         _;
61     }
62 
63     /**
64      * @dev Leaves the contract without owner. It will not be possible to call
65      * `onlyOwner` functions anymore. Can only be called by the current owner.
66      *
67      * NOTE: Renouncing ownership will leave the contract without an owner,
68      * thereby removing any functionality that is only available to the owner.
69      */
70     function renounceOwnership() public virtual onlyOwner {
71         _transferOwnership(address(0));
72     }
73 
74     /**
75      * @dev Transfers ownership of the contract to a new account (`newOwner`).
76      * Can only be called by the current owner.
77      */
78     function transferOwnership(address newOwner) public virtual onlyOwner {
79         require(newOwner != address(0), "Ownable: new owner is the zero address");
80         _transferOwnership(newOwner);
81     }
82 
83     /**
84      * @dev Transfers ownership of the contract to a new account (`newOwner`).
85      * Internal function without access restriction.
86      */
87     function _transferOwnership(address newOwner) internal virtual {
88         address oldOwner = _owner;
89         _owner = newOwner;
90         emit OwnershipTransferred(oldOwner, newOwner);
91     }
92 }
93 
94 /**
95  * @dev Interface of the ERC20 standard as defined in the EIP.
96  */
97 interface IERC20 {
98     /**
99      * @dev Emitted when `value` tokens are moved from one account (`from`) to
100      * another (`to`).
101      *
102      * Note that `value` may be zero.
103      */
104     event Transfer(address indexed from, address indexed to, uint256 value);
105 
106     /**
107      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
108      * a call to {approve}. `value` is the new allowance.
109      */
110     event Approval(address indexed owner, address indexed spender, uint256 value);
111 
112     /**
113      * @dev Returns the amount of tokens in existence.
114      */
115     function totalSupply() external view returns (uint256);
116 
117     /**
118      * @dev Returns the amount of tokens owned by `account`.
119      */
120     function balanceOf(address account) external view returns (uint256);
121 
122     /**
123      * @dev Moves `amount` tokens from the caller's account to `to`.
124      *
125      * Returns a boolean value indicating whether the operation succeeded.
126      *
127      * Emits a {Transfer} event.
128      */
129     function transfer(address to, uint256 amount) external returns (bool);
130 
131     /**
132      * @dev Returns the remaining number of tokens that `spender` will be
133      * allowed to spend on behalf of `owner` through {transferFrom}. This is
134      * zero by default.
135      *
136      * This value changes when {approve} or {transferFrom} are called.
137      */
138     function allowance(address owner, address spender) external view returns (uint256);
139 
140     /**
141      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
142      *
143      * Returns a boolean value indicating whether the operation succeeded.
144      *
145      * IMPORTANT: Beware that changing an allowance with this method brings the risk
146      * that someone may use both the old and the new allowance by unfortunate
147      * transaction ordering. One possible solution to mitigate this race
148      * condition is to first reduce the spender's allowance to 0 and set the
149      * desired value afterwards:
150      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
151      *
152      * Emits an {Approval} event.
153      */
154     function approve(address spender, uint256 amount) external returns (bool);
155 
156     /**
157      * @dev Moves `amount` tokens from `from` to `to` using the
158      * allowance mechanism. `amount` is then deducted from the caller's
159      * allowance.
160      *
161      * Returns a boolean value indicating whether the operation succeeded.
162      *
163      * Emits a {Transfer} event.
164      */
165     function transferFrom(
166         address from,
167         address to,
168         uint256 amount
169     ) external returns (bool);
170 }
171 
172 
173 /**
174  * @dev Interface for the optional metadata functions from the ERC20 standard.
175  *
176  * _Available since v4.1._
177  */
178 interface IERC20Metadata is IERC20 {
179     /**
180      * @dev Returns the name of the token.
181      */
182     function name() external view returns (string memory);
183 
184     /**
185      * @dev Returns the symbol of the token.
186      */
187     function symbol() external view returns (string memory);
188 
189     /**
190      * @dev Returns the decimals places of the token.
191      */
192     function decimals() external view returns (uint8);
193 }
194 
195 
196 /**
197  * @dev Implementation of the {IERC20} interface.
198  *
199  * This implementation is agnostic to the way tokens are created. This means
200  * that a supply mechanism has to be added in a derived contract using {_mint}.
201  * For a generic mechanism see {ERC20PresetMinterPauser}.
202  *
203  * TIP: For a detailed writeup see our guide
204  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
205  * to implement supply mechanisms].
206  *
207  * We have followed general OpenZeppelin Contracts guidelines: functions revert
208  * instead returning `false` on failure. This behavior is nonetheless
209  * conventional and does not conflict with the expectations of ERC20
210  * applications.
211  *
212  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
213  * This allows applications to reconstruct the allowance for all accounts just
214  * by listening to said events. Other implementations of the EIP may not emit
215  * these events, as it isn't required by the specification.
216  *
217  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
218  * functions have been added to mitigate the well-known issues around setting
219  * allowances. See {IERC20-approve}.
220  */
221 contract ERC20 is Context, IERC20, IERC20Metadata {
222     mapping(address => uint256) private _balances;
223 
224     mapping(address => mapping(address => uint256)) private _allowances;
225 
226     uint256 private _totalSupply;
227 
228     string private _name;
229     string private _symbol;
230     uint8 private _decimals;
231 
232     /**
233      * @dev Sets the values for {name} and {symbol}.
234      *
235      * The default value of {decimals} is 18. To select a different value for
236      * {decimals} you should overload it.
237      *
238      * All two of these values are immutable: they can only be set once during
239      * construction.
240      */
241     constructor(string memory name_, string memory symbol_, uint8 decimals_) {
242         _name = name_;
243         _symbol = symbol_;
244         _decimals = decimals_;
245     }
246 
247     /**
248      * @dev Returns the name of the token.
249      */
250     function name() public view virtual override returns (string memory) {
251         return _name;
252     }
253 
254     /**
255      * @dev Returns the symbol of the token, usually a shorter version of the
256      * name.
257      */
258     function symbol() public view virtual override returns (string memory) {
259         return _symbol;
260     }
261 
262     /**
263      * @dev Returns the number of decimals used to get its user representation.
264      * For example, if `decimals` equals `2`, a balance of `505` tokens should
265      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
266      *
267      * Tokens usually opt for a value of 18, imitating the relationship between
268      * Ether and Wei. This is the value {ERC20} uses, unless this function is
269      * overridden;
270      *
271      * NOTE: This information is only used for _display_ purposes: it in
272      * no way affects any of the arithmetic of the contract, including
273      * {IERC20-balanceOf} and {IERC20-transfer}.
274      */
275     function decimals() public view virtual override returns (uint8) {
276         return _decimals;
277     }
278 
279     /**
280      * @dev See {IERC20-totalSupply}.
281      */
282     function totalSupply() public view virtual override returns (uint256) {
283         return _totalSupply;
284     }
285 
286     /**
287      * @dev See {IERC20-balanceOf}.
288      */
289     function balanceOf(address account) public view virtual override returns (uint256) {
290         return _balances[account];
291     }
292 
293     /**
294      * @dev See {IERC20-transfer}.
295      *
296      * Requirements:
297      *
298      * - `to` cannot be the zero address.
299      * - the caller must have a balance of at least `amount`.
300      */
301     function transfer(address to, uint256 amount) public virtual override returns (bool) {
302         address owner = _msgSender();
303         _transfer(owner, to, amount);
304         return true;
305     }
306 
307     /**
308      * @dev See {IERC20-allowance}.
309      */
310     function allowance(address owner, address spender) public view virtual override returns (uint256) {
311         return _allowances[owner][spender];
312     }
313 
314     /**
315      * @dev See {IERC20-approve}.
316      *
317      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
318      * `transferFrom`. This is semantically equivalent to an infinite approval.
319      *
320      * Requirements:
321      *
322      * - `spender` cannot be the zero address.
323      */
324     function approve(address spender, uint256 amount) public virtual override returns (bool) {
325         address owner = _msgSender();
326         _approve(owner, spender, amount);
327         return true;
328     }
329 
330     /**
331      * @dev See {IERC20-transferFrom}.
332      *
333      * Emits an {Approval} event indicating the updated allowance. This is not
334      * required by the EIP. See the note at the beginning of {ERC20}.
335      *
336      * NOTE: Does not update the allowance if the current allowance
337      * is the maximum `uint256`.
338      *
339      * Requirements:
340      *
341      * - `from` and `to` cannot be the zero address.
342      * - `from` must have a balance of at least `amount`.
343      * - the caller must have allowance for ``from``'s tokens of at least
344      * `amount`.
345      */
346     function transferFrom(
347         address from,
348         address to,
349         uint256 amount
350     ) public virtual override returns (bool) {
351         address spender = _msgSender();
352         _spendAllowance(from, spender, amount);
353         _transfer(from, to, amount);
354         return true;
355     }
356 
357     /**
358      * @dev Atomically increases the allowance granted to `spender` by the caller.
359      *
360      * This is an alternative to {approve} that can be used as a mitigation for
361      * problems described in {IERC20-approve}.
362      *
363      * Emits an {Approval} event indicating the updated allowance.
364      *
365      * Requirements:
366      *
367      * - `spender` cannot be the zero address.
368      */
369     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
370         address owner = _msgSender();
371         _approve(owner, spender, allowance(owner, spender) + addedValue);
372         return true;
373     }
374 
375     /**
376      * @dev Atomically decreases the allowance granted to `spender` by the caller.
377      *
378      * This is an alternative to {approve} that can be used as a mitigation for
379      * problems described in {IERC20-approve}.
380      *
381      * Emits an {Approval} event indicating the updated allowance.
382      *
383      * Requirements:
384      *
385      * - `spender` cannot be the zero address.
386      * - `spender` must have allowance for the caller of at least
387      * `subtractedValue`.
388      */
389     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
390         address owner = _msgSender();
391         uint256 currentAllowance = allowance(owner, spender);
392         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
393         unchecked {
394             _approve(owner, spender, currentAllowance - subtractedValue);
395         }
396 
397         return true;
398     }
399 
400     /**
401      * @dev Moves `amount` of tokens from `sender` to `recipient`.
402      *
403      * This internal function is equivalent to {transfer}, and can be used to
404      * e.g. implement automatic token fees, slashing mechanisms, etc.
405      *
406      * Emits a {Transfer} event.
407      *
408      * Requirements:
409      *
410      * - `from` cannot be the zero address.
411      * - `to` cannot be the zero address.
412      * - `from` must have a balance of at least `amount`.
413      */
414     function _transfer(
415         address from,
416         address to,
417         uint256 amount
418     ) internal virtual {
419         require(from != address(0), "ERC20: transfer from the zero address");
420         require(to != address(0), "ERC20: transfer to the zero address");
421 
422         _beforeTokenTransfer(from, to, amount);
423 
424         uint256 fromBalance = _balances[from];
425         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
426         unchecked {
427             _balances[from] = fromBalance - amount;
428         }
429         _balances[to] += amount;
430 
431         emit Transfer(from, to, amount);
432 
433         _afterTokenTransfer(from, to, amount);
434     }
435 
436     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
437      * the total supply.
438      *
439      * Emits a {Transfer} event with `from` set to the zero address.
440      *
441      * Requirements:
442      *
443      * - `account` cannot be the zero address.
444      */
445     function _mint(address account, uint256 amount) internal virtual {
446         require(account != address(0), "ERC20: mint to the zero address");
447 
448         _beforeTokenTransfer(address(0), account, amount);
449 
450         _totalSupply += amount;
451         _balances[account] += amount;
452         emit Transfer(address(0), account, amount);
453 
454         _afterTokenTransfer(address(0), account, amount);
455     }
456 
457     /**
458      * @dev Destroys `amount` tokens from `account`, reducing the
459      * total supply.
460      *
461      * Emits a {Transfer} event with `to` set to the zero address.
462      *
463      * Requirements:
464      *
465      * - `account` cannot be the zero address.
466      * - `account` must have at least `amount` tokens.
467      */
468     function _burn(address account, uint256 amount) internal virtual {
469         require(account != address(0), "ERC20: burn from the zero address");
470 
471         _beforeTokenTransfer(account, address(0), amount);
472 
473         uint256 accountBalance = _balances[account];
474         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
475         unchecked {
476             _balances[account] = accountBalance - amount;
477         }
478         _totalSupply -= amount;
479 
480         emit Transfer(account, address(0), amount);
481 
482         _afterTokenTransfer(account, address(0), amount);
483     }
484 
485     /**
486      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
487      *
488      * This internal function is equivalent to `approve`, and can be used to
489      * e.g. set automatic allowances for certain subsystems, etc.
490      *
491      * Emits an {Approval} event.
492      *
493      * Requirements:
494      *
495      * - `owner` cannot be the zero address.
496      * - `spender` cannot be the zero address.
497      */
498     function _approve(
499         address owner,
500         address spender,
501         uint256 amount
502     ) internal virtual {
503         require(owner != address(0), "ERC20: approve from the zero address");
504         require(spender != address(0), "ERC20: approve to the zero address");
505 
506         _allowances[owner][spender] = amount;
507         emit Approval(owner, spender, amount);
508     }
509 
510     /**
511      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
512      *
513      * Does not update the allowance amount in case of infinite allowance.
514      * Revert if not enough allowance is available.
515      *
516      * Might emit an {Approval} event.
517      */
518     function _spendAllowance(
519         address owner,
520         address spender,
521         uint256 amount
522     ) internal virtual {
523         uint256 currentAllowance = allowance(owner, spender);
524         if (currentAllowance != type(uint256).max) {
525             require(currentAllowance >= amount, "ERC20: insufficient allowance");
526             unchecked {
527                 _approve(owner, spender, currentAllowance - amount);
528             }
529         }
530     }
531 
532     /**
533      * @dev Hook that is called before any transfer of tokens. This includes
534      * minting and burning.
535      *
536      * Calling conditions:
537      *
538      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
539      * will be transferred to `to`.
540      * - when `from` is zero, `amount` tokens will be minted for `to`.
541      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
542      * - `from` and `to` are never both zero.
543      *
544      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
545      */
546     function _beforeTokenTransfer(
547         address from,
548         address to,
549         uint256 amount
550     ) internal virtual {}
551 
552     /**
553      * @dev Hook that is called after any transfer of tokens. This includes
554      * minting and burning.
555      *
556      * Calling conditions:
557      *
558      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
559      * has been transferred to `to`.
560      * - when `from` is zero, `amount` tokens have been minted for `to`.
561      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
562      * - `from` and `to` are never both zero.
563      *
564      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
565      */
566     function _afterTokenTransfer(
567         address from,
568         address to,
569         uint256 amount
570     ) internal virtual {}
571 }
572 
573 /**
574  * @dev Contract module which allows children to implement an emergency stop
575  * mechanism that can be triggered by an authorized account.
576  *
577  * This module is used through inheritance. It will make available the
578  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
579  * the functions of your contract. Note that they will not be pausable by
580  * simply including this module, only once the modifiers are put in place.
581  */
582 abstract contract Pausable is Context {
583     /**
584      * @dev Emitted when the pause is triggered by `account`.
585      */
586     event Paused(address account);
587 
588     /**
589      * @dev Emitted when the pause is lifted by `account`.
590      */
591     event Unpaused(address account);
592 
593     bool private _paused;
594 
595     /**
596      * @dev Initializes the contract in unpaused state.
597      */
598     constructor() {
599         _paused = false;
600     }
601 
602     /**
603      * @dev Returns true if the contract is paused, and false otherwise.
604      */
605     function paused() public view virtual returns (bool) {
606         return _paused;
607     }
608 
609     /**
610      * @dev Modifier to make a function callable only when the contract is not paused.
611      *
612      * Requirements:
613      *
614      * - The contract must not be paused.
615      */
616     modifier whenNotPaused() {
617         require(!paused(), "Pausable: paused");
618         _;
619     }
620 
621     /**
622      * @dev Modifier to make a function callable only when the contract is paused.
623      *
624      * Requirements:
625      *
626      * - The contract must be paused.
627      */
628     modifier whenPaused() {
629         require(paused(), "Pausable: not paused");
630         _;
631     }
632 
633     /**
634      * @dev Triggers stopped state.
635      *
636      * Requirements:
637      *
638      * - The contract must not be paused.
639      */
640     function _pause() internal virtual whenNotPaused {
641         _paused = true;
642         emit Paused(_msgSender());
643     }
644 
645     /**
646      * @dev Returns to normal state.
647      *
648      * Requirements:
649      *
650      * - The contract must be paused.
651      */
652     function _unpause() internal virtual whenPaused {
653         _paused = false;
654         emit Unpaused(_msgSender());
655     }
656 }
657 
658 /**
659  * @dev Extension of {ERC20} that allows token holders to destroy both their own
660  * tokens and those that they have an allowance for, in a way that can be
661  * recognized off-chain (via event analysis).
662  */
663 abstract contract ERC20Burnable is Context, ERC20 {
664     /**
665      * @dev Destroys `amount` tokens from the caller.
666      *
667      * See {ERC20-_burn}.
668      */
669     function burn(uint256 amount) public virtual {
670         _burn(_msgSender(), amount);
671     }
672 
673     /**
674      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
675      * allowance.
676      *
677      * See {ERC20-_burn} and {ERC20-allowance}.
678      *
679      * Requirements:
680      *
681      * - the caller must have allowance for ``accounts``'s tokens of at least
682      * `amount`.
683      */
684     function burnFrom(address account, uint256 amount) public virtual {
685         _spendAllowance(account, _msgSender(), amount);
686         _burn(account, amount);
687     }
688 }
689 
690 /**
691  * @dev ERC20 token with pausable token transfers, minting and burning.
692  *
693  * Useful for scenarios such as preventing trades until the end of an evaluation
694  * period, or having an emergency switch for freezing all token transfers in the
695  * event of a large bug.
696  */
697 abstract contract ERC20Pausable is ERC20, Pausable {
698     /**
699      * @dev See {ERC20-_beforeTokenTransfer}.
700      *
701      * Requirements:
702      *
703      * - the contract must not be paused.
704      */
705     function _beforeTokenTransfer(
706         address from,
707         address to,
708         uint256 amount
709     ) internal virtual override {
710         super._beforeTokenTransfer(from, to, amount);
711 
712         require(!paused(), "ERC20Pausable: token transfer while paused");
713     }
714 }
715 
716 contract WrappedToken is ERC20, ERC20Burnable, Pausable, Ownable {
717     constructor(
718         string memory name,
719         string memory symbol,
720         uint8 decimals
721     ) ERC20(name, symbol, decimals) {}
722 
723     function pause() public onlyOwner {
724         _pause();
725     }
726 
727     function unpause() public onlyOwner {
728         _unpause();
729     }
730 
731     function mint(address to, uint256 amount) public onlyOwner {
732         _mint(to, amount);
733     }
734 
735     function _beforeTokenTransfer(address from, address to, uint256 amount)
736         internal
737         whenNotPaused
738         override
739     {
740         super._beforeTokenTransfer(from, to, amount);
741     }
742 }