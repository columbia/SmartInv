1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 
26 /**
27  * @dev Interface of the ERC20 standard as defined in the EIP.
28  */
29 interface IERC20 {
30     /**
31      * @dev Returns the amount of tokens in existence.
32      */
33     function totalSupply() external view returns (uint256);
34 
35     /**
36      * @dev Returns the amount of tokens owned by `account`.
37      */
38     function balanceOf(address account) external view returns (uint256);
39 
40     /**
41      * @dev Moves `amount` tokens from the caller's account to `recipient`.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * Emits a {Transfer} event.
46      */
47     function transfer(address recipient, uint256 amount) external returns (bool);
48 
49     /**
50      * @dev Returns the remaining number of tokens that `spender` will be
51      * allowed to spend on behalf of `owner` through {transferFrom}. This is
52      * zero by default.
53      *
54      * This value changes when {approve} or {transferFrom} are called.
55      */
56     function allowance(address owner, address spender) external view returns (uint256);
57 
58     /**
59      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * IMPORTANT: Beware that changing an allowance with this method brings the risk
64      * that someone may use both the old and the new allowance by unfortunate
65      * transaction ordering. One possible solution to mitigate this race
66      * condition is to first reduce the spender's allowance to 0 and set the
67      * desired value afterwards:
68      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
69      *
70      * Emits an {Approval} event.
71      */
72     function approve(address spender, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Moves `amount` tokens from `sender` to `recipient` using the
76      * allowance mechanism. `amount` is then deducted from the caller's
77      * allowance.
78      *
79      * Returns a boolean value indicating whether the operation succeeded.
80      *
81      * Emits a {Transfer} event.
82      */
83     function transferFrom(
84         address sender,
85         address recipient,
86         uint256 amount
87     ) external returns (bool);
88 
89     /**
90      * @dev Emitted when `value` tokens are moved from one account (`from`) to
91      * another (`to`).
92      *
93      * Note that `value` may be zero.
94      */
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     /**
98      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
99      * a call to {approve}. `value` is the new allowance.
100      */
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 
105 
106 /**
107  * @dev Interface for the optional metadata functions from the ERC20 standard.
108  *
109  * _Available since v4.1._
110  */
111 interface IERC20Metadata is IERC20 {
112     /**
113      * @dev Returns the name of the token.
114      */
115     function name() external view returns (string memory);
116 
117     /**
118      * @dev Returns the symbol of the token.
119      */
120     function symbol() external view returns (string memory);
121 
122     /**
123      * @dev Returns the decimals places of the token.
124      */
125     function decimals() external view returns (uint8);
126 }
127 
128 
129 
130 /**
131  * @dev Implementation of the {IERC20} interface.
132  *
133  * This implementation is agnostic to the way tokens are created. This means
134  * that a supply mechanism has to be added in a derived contract using {_mint}.
135  * For a generic mechanism see {ERC20PresetMinterPauser}.
136  *
137  * TIP: For a detailed writeup see our guide
138  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
139  * to implement supply mechanisms].
140  *
141  * We have followed general OpenZeppelin Contracts guidelines: functions revert
142  * instead returning `false` on failure. This behavior is nonetheless
143  * conventional and does not conflict with the expectations of ERC20
144  * applications.
145  *
146  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
147  * This allows applications to reconstruct the allowance for all accounts just
148  * by listening to said events. Other implementations of the EIP may not emit
149  * these events, as it isn't required by the specification.
150  *
151  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
152  * functions have been added to mitigate the well-known issues around setting
153  * allowances. See {IERC20-approve}.
154  */
155 contract ERC20 is Context, IERC20, IERC20Metadata {
156     mapping(address => uint256) private _balances;
157 
158     mapping(address => mapping(address => uint256)) private _allowances;
159 
160     uint256 private _totalSupply;
161 
162     string private _name;
163     string private _symbol;
164 
165     /**
166      * @dev Sets the values for {name} and {symbol}.
167      *
168      * The default value of {decimals} is 18. To select a different value for
169      * {decimals} you should overload it.
170      *
171      * All two of these values are immutable: they can only be set once during
172      * construction.
173      */
174     constructor(string memory name_, string memory symbol_) {
175         _name = name_;
176         _symbol = symbol_;
177     }
178 
179     /**
180      * @dev Returns the name of the token.
181      */
182     function name() public view virtual override returns (string memory) {
183         return _name;
184     }
185 
186     /**
187      * @dev Returns the symbol of the token, usually a shorter version of the
188      * name.
189      */
190     function symbol() public view virtual override returns (string memory) {
191         return _symbol;
192     }
193 
194     /**
195      * @dev Returns the number of decimals used to get its user representation.
196      * For example, if `decimals` equals `2`, a balance of `505` tokens should
197      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
198      *
199      * Tokens usually opt for a value of 18, imitating the relationship between
200      * Ether and Wei. This is the value {ERC20} uses, unless this function is
201      * overridden;
202      *
203      * NOTE: This information is only used for _display_ purposes: it in
204      * no way affects any of the arithmetic of the contract, including
205      * {IERC20-balanceOf} and {IERC20-transfer}.
206      */
207     function decimals() public view virtual override returns (uint8) {
208         return 18;
209     }
210 
211     /**
212      * @dev See {IERC20-totalSupply}.
213      */
214     function totalSupply() public view virtual override returns (uint256) {
215         return _totalSupply;
216     }
217 
218     /**
219      * @dev See {IERC20-balanceOf}.
220      */
221     function balanceOf(address account) public view virtual override returns (uint256) {
222         return _balances[account];
223     }
224 
225     /**
226      * @dev See {IERC20-transfer}.
227      *
228      * Requirements:
229      *
230      * - `recipient` cannot be the zero address.
231      * - the caller must have a balance of at least `amount`.
232      */
233     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
234         _transfer(_msgSender(), recipient, amount);
235         return true;
236     }
237 
238     /**
239      * @dev See {IERC20-allowance}.
240      */
241     function allowance(address owner, address spender) public view virtual override returns (uint256) {
242         return _allowances[owner][spender];
243     }
244 
245     /**
246      * @dev See {IERC20-approve}.
247      *
248      * Requirements:
249      *
250      * - `spender` cannot be the zero address.
251      */
252     function approve(address spender, uint256 amount) public virtual override returns (bool) {
253         _approve(_msgSender(), spender, amount);
254         return true;
255     }
256 
257     /**
258      * @dev See {IERC20-transferFrom}.
259      *
260      * Emits an {Approval} event indicating the updated allowance. This is not
261      * required by the EIP. See the note at the beginning of {ERC20}.
262      *
263      * Requirements:
264      *
265      * - `sender` and `recipient` cannot be the zero address.
266      * - `sender` must have a balance of at least `amount`.
267      * - the caller must have allowance for ``sender``'s tokens of at least
268      * `amount`.
269      */
270     function transferFrom(
271         address sender,
272         address recipient,
273         uint256 amount
274     ) public virtual override returns (bool) {
275         _transfer(sender, recipient, amount);
276 
277         uint256 currentAllowance = _allowances[sender][_msgSender()];
278         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
279         unchecked {
280             _approve(sender, _msgSender(), currentAllowance - amount);
281         }
282 
283         return true;
284     }
285 
286     /**
287      * @dev Atomically increases the allowance granted to `spender` by the caller.
288      *
289      * This is an alternative to {approve} that can be used as a mitigation for
290      * problems described in {IERC20-approve}.
291      *
292      * Emits an {Approval} event indicating the updated allowance.
293      *
294      * Requirements:
295      *
296      * - `spender` cannot be the zero address.
297      */
298     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
299         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
300         return true;
301     }
302 
303     /**
304      * @dev Atomically decreases the allowance granted to `spender` by the caller.
305      *
306      * This is an alternative to {approve} that can be used as a mitigation for
307      * problems described in {IERC20-approve}.
308      *
309      * Emits an {Approval} event indicating the updated allowance.
310      *
311      * Requirements:
312      *
313      * - `spender` cannot be the zero address.
314      * - `spender` must have allowance for the caller of at least
315      * `subtractedValue`.
316      */
317     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
318         uint256 currentAllowance = _allowances[_msgSender()][spender];
319         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
320         unchecked {
321             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
322         }
323 
324         return true;
325     }
326 
327     /**
328      * @dev Moves `amount` of tokens from `sender` to `recipient`.
329      *
330      * This internal function is equivalent to {transfer}, and can be used to
331      * e.g. implement automatic token fees, slashing mechanisms, etc.
332      *
333      * Emits a {Transfer} event.
334      *
335      * Requirements:
336      *
337      * - `sender` cannot be the zero address.
338      * - `recipient` cannot be the zero address.
339      * - `sender` must have a balance of at least `amount`.
340      */
341     function _transfer(
342         address sender,
343         address recipient,
344         uint256 amount
345     ) internal virtual {
346         require(sender != address(0), "ERC20: transfer from the zero address");
347         require(recipient != address(0), "ERC20: transfer to the zero address");
348 
349         _beforeTokenTransfer(sender, recipient, amount);
350 
351         uint256 senderBalance = _balances[sender];
352         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
353         unchecked {
354             _balances[sender] = senderBalance - amount;
355         }
356         _balances[recipient] += amount;
357 
358         emit Transfer(sender, recipient, amount);
359 
360         _afterTokenTransfer(sender, recipient, amount);
361     }
362 
363     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
364      * the total supply.
365      *
366      * Emits a {Transfer} event with `from` set to the zero address.
367      *
368      * Requirements:
369      *
370      * - `account` cannot be the zero address.
371      */
372     function _mint(address account, uint256 amount) internal virtual {
373         require(account != address(0), "ERC20: mint to the zero address");
374 
375         _beforeTokenTransfer(address(0), account, amount);
376 
377         _totalSupply += amount;
378         _balances[account] += amount;
379         emit Transfer(address(0), account, amount);
380 
381         _afterTokenTransfer(address(0), account, amount);
382     }
383 
384     /**
385      * @dev Destroys `amount` tokens from `account`, reducing the
386      * total supply.
387      *
388      * Emits a {Transfer} event with `to` set to the zero address.
389      *
390      * Requirements:
391      *
392      * - `account` cannot be the zero address.
393      * - `account` must have at least `amount` tokens.
394      */
395     function _burn(address account, uint256 amount) internal virtual {
396         require(account != address(0), "ERC20: burn from the zero address");
397 
398         _beforeTokenTransfer(account, address(0), amount);
399 
400         uint256 accountBalance = _balances[account];
401         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
402         unchecked {
403             _balances[account] = accountBalance - amount;
404         }
405         _totalSupply -= amount;
406 
407         emit Transfer(account, address(0), amount);
408 
409         _afterTokenTransfer(account, address(0), amount);
410     }
411 
412     /**
413      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
414      *
415      * This internal function is equivalent to `approve`, and can be used to
416      * e.g. set automatic allowances for certain subsystems, etc.
417      *
418      * Emits an {Approval} event.
419      *
420      * Requirements:
421      *
422      * - `owner` cannot be the zero address.
423      * - `spender` cannot be the zero address.
424      */
425     function _approve(
426         address owner,
427         address spender,
428         uint256 amount
429     ) internal virtual {
430         require(owner != address(0), "ERC20: approve from the zero address");
431         require(spender != address(0), "ERC20: approve to the zero address");
432 
433         _allowances[owner][spender] = amount;
434         emit Approval(owner, spender, amount);
435     }
436 
437     /**
438      * @dev Hook that is called before any transfer of tokens. This includes
439      * minting and burning.
440      *
441      * Calling conditions:
442      *
443      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
444      * will be transferred to `to`.
445      * - when `from` is zero, `amount` tokens will be minted for `to`.
446      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
447      * - `from` and `to` are never both zero.
448      *
449      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
450      */
451     function _beforeTokenTransfer(
452         address from,
453         address to,
454         uint256 amount
455     ) internal virtual {}
456 
457     /**
458      * @dev Hook that is called after any transfer of tokens. This includes
459      * minting and burning.
460      *
461      * Calling conditions:
462      *
463      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
464      * has been transferred to `to`.
465      * - when `from` is zero, `amount` tokens have been minted for `to`.
466      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
467      * - `from` and `to` are never both zero.
468      *
469      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
470      */
471     function _afterTokenTransfer(
472         address from,
473         address to,
474         uint256 amount
475     ) internal virtual {}
476 }
477 
478 
479 /**
480  * @dev token contract, including:
481  *
482  *  - Preminted initial supply
483  *  - Ability for holders to burn (destroy) their tokens
484  *  - No access control mechanism (for minting/pausing) and hence no governance
485  *
486  */
487 contract DividendBearingERC20 is ERC20 {
488     /**
489      * @dev Contract variables.
490      */
491     string private _name;
492     string private _symbol;
493     uint256 private _initialSupply = 100000000000 * (10 ** uint256(decimals()));
494 
495     address private _dev;
496     address private _team;
497     address private _arb;
498     address private _liquidity;
499     address private _donation;
500     address private _marketing;
501 
502     mapping(address => uint256) private _dividendsClaimed;
503     address private _dividendWallet;
504     uint256 private _totalDividendsClaimed;
505 
506     /**
507      * @dev Constructor that gives dev all of existing tokens.
508      */
509     constructor (
510             string memory name_,
511             string memory symbol_,
512             address arb_,
513             address liquidity_,
514             address team_,
515             address marketing_,
516             address donation_,
517             address dividendWallet_
518         ) ERC20(name_, symbol_) {
519         _dev = _msgSender();
520         _name = name_;
521         _symbol = symbol_;
522         _team = team_;
523         _donation = donation_;
524         _dividendWallet = dividendWallet_;
525         _marketing = marketing_;
526         _arb = arb_;
527         _liquidity = liquidity_;
528         _mint(_liquidity, (_initialSupply*3)/5);
529         _mint(_arb, _initialSupply/5);
530         _mint(_marketing, _initialSupply/10);
531         _mint(_team, _initialSupply/20);
532         _mint(_donation, _initialSupply/20);
533     }
534 
535     /**
536      * @dev overrides transfer, transfers dividends (rewards) if necessary.
537      */
538     function _transfer(
539         address sender,
540         address recipient,
541         uint256 amount
542     ) internal virtual override {
543         uint256 _dividendsTransferred = (amount * _dividendsClaimed[sender])/(balanceOf(sender));
544         if (_dividendsTransferred > 0) {
545             _dividendsClaimed[sender] -= _dividendsTransferred;
546             _dividendsClaimed[recipient] += _dividendsTransferred;
547         }
548         super._transfer(sender, recipient, amount);
549     }
550 
551     /**
552      * @dev gets total dividends accrued.
553      */
554     function _getTotalDividends() internal virtual returns (uint256) {
555         return balanceOf(_dividendWallet) + _totalDividendsClaimed;
556     }
557 
558     /**
559      * @dev gets total dividends owed.
560      */
561     function _getTotalDividendsOwed(address account) internal virtual returns (uint256) {
562         uint256 dividendsOwed = ((balanceOf(account)-_dividendsClaimed[account]) * _getTotalDividends())/_getCirculatingSupply();
563         return dividendsOwed;
564     }
565 
566     /**
567      * @dev gets circulating supply.
568      */
569     function _getCirculatingSupply() internal virtual returns (uint256) {
570         return totalSupply() - (_getTotalDividends()
571             + balanceOf(_dev)
572             + balanceOf(_team)
573             + balanceOf(_donation)
574             + balanceOf(_marketing)
575             + balanceOf(_liquidity)
576             + balanceOf(_arb)
577             );
578     }
579 
580     /**
581      * @dev gets current rewards for account.
582      */
583     function _getRewardsForAccount(address account) internal virtual returns (uint256) {
584         uint256 rewards = _getTotalDividendsOwed(account) - _dividendsClaimed[account];
585         return rewards;
586     }
587 
588     /**
589      * @dev gets current rewards.
590      */
591     function getRewards() internal virtual returns (uint256) {
592         address sender = _msgSender();
593         require(sender != _dividendWallet
594             && sender != _dev
595             && sender != _team
596             && sender != _donation
597             && sender != _marketing
598             && sender != _liquidity
599             && sender != _arb
600             , "Unauthorized to claim rewards"
601             );
602         return _getRewardsForAccount(sender);
603     }
604 
605     /**
606      * @dev claims any outstanding rewards.
607      */
608     function claimRewards() public virtual {
609         address sender = _msgSender();
610         require(sender != _dividendWallet
611             && sender != _dev
612             && sender != _team
613             && sender != _donation
614             && sender != _marketing
615             && sender != _liquidity
616             && sender != _arb
617             , "Unauthorized to claim rewards"
618             );
619         uint256 rewards = _getRewardsForAccount(sender);
620         require(rewards > 0, "No rewards to collect.");
621         //security check - can only result due to extremely small rounding errors. 
622         if (rewards > balanceOf(_dividendWallet)) {
623             rewards = balanceOf(_dividendWallet);
624         }
625         _dividendsClaimed[sender] += rewards;
626         _totalDividendsClaimed += rewards;
627         super._transfer(_dividendWallet, sender, rewards);
628     }
629 
630     /**
631      * @dev modifier for dev only operations.
632      */
633     modifier _devOnly() {
634         require(_msgSender() == _dev);
635         _;
636     }
637 }