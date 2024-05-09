1 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Emitted when `value` tokens are moved from one account (`from`) to
14      * another (`to`).
15      *
16      * Note that `value` may be zero.
17      */
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     /**
21      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
22      * a call to {approve}. `value` is the new allowance.
23      */
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 
26     /**
27      * @dev Returns the amount of tokens in existence.
28      */
29     function totalSupply() external view returns (uint256);
30 
31     /**
32      * @dev Returns the amount of tokens owned by `account`.
33      */
34     function balanceOf(address account) external view returns (uint256);
35 
36     /**
37      * @dev Moves `amount` tokens from the caller's account to `to`.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * Emits a {Transfer} event.
42      */
43     function transfer(address to, uint256 amount) external returns (bool);
44 
45     /**
46      * @dev Returns the remaining number of tokens that `spender` will be
47      * allowed to spend on behalf of `owner` through {transferFrom}. This is
48      * zero by default.
49      *
50      * This value changes when {approve} or {transferFrom} are called.
51      */
52     function allowance(address owner, address spender) external view returns (uint256);
53 
54     /**
55      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * IMPORTANT: Beware that changing an allowance with this method brings the risk
60      * that someone may use both the old and the new allowance by unfortunate
61      * transaction ordering. One possible solution to mitigate this race
62      * condition is to first reduce the spender's allowance to 0 and set the
63      * desired value afterwards:
64      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
65      *
66      * Emits an {Approval} event.
67      */
68     function approve(address spender, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Moves `amount` tokens from `from` to `to` using the
72      * allowance mechanism. `amount` is then deducted from the caller's
73      * allowance.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * Emits a {Transfer} event.
78      */
79     function transferFrom(
80         address from,
81         address to,
82         uint256 amount
83     ) external returns (bool);
84 }
85 
86 // File: @openzeppelin\contracts\token\ERC20\extensions\IERC20Metadata.sol
87 
88 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
89 
90 pragma solidity ^0.8.0;
91 
92 /**
93  * @dev Interface for the optional metadata functions from the ERC20 standard.
94  *
95  * _Available since v4.1._
96  */
97 interface IERC20Metadata is IERC20 {
98     /**
99      * @dev Returns the name of the token.
100      */
101     function name() external view returns (string memory);
102 
103     /**
104      * @dev Returns the symbol of the token.
105      */
106     function symbol() external view returns (string memory);
107 
108     /**
109      * @dev Returns the decimals places of the token.
110      */
111     function decimals() external view returns (uint8);
112 }
113 
114 // File: @openzeppelin\contracts\utils\Context.sol
115 
116 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 /**
121  * @dev Provides information about the current execution context, including the
122  * sender of the transaction and its data. While these are generally available
123  * via msg.sender and msg.data, they should not be accessed in such a direct
124  * manner, since when dealing with meta-transactions the account sending and
125  * paying for execution may not be the actual sender (as far as an application
126  * is concerned).
127  *
128  * This contract is only required for intermediate, library-like contracts.
129  */
130 abstract contract Context {
131     function _msgSender() internal view virtual returns (address) {
132         return msg.sender;
133     }
134 
135     function _msgData() internal view virtual returns (bytes calldata) {
136         return msg.data;
137     }
138 }
139 
140 // File: @openzeppelin\contracts\token\ERC20\ERC20.sol
141 
142 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
143 
144 pragma solidity ^0.8.0;
145 
146 
147 
148 /**
149  * @dev Implementation of the {IERC20} interface.
150  *
151  * This implementation is agnostic to the way tokens are created. This means
152  * that a supply mechanism has to be added in a derived contract using {_mint}.
153  * For a generic mechanism see {ERC20PresetMinterPauser}.
154  *
155  * TIP: For a detailed writeup see our guide
156  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
157  * to implement supply mechanisms].
158  *
159  * We have followed general OpenZeppelin Contracts guidelines: functions revert
160  * instead returning `false` on failure. This behavior is nonetheless
161  * conventional and does not conflict with the expectations of ERC20
162  * applications.
163  *
164  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
165  * This allows applications to reconstruct the allowance for all accounts just
166  * by listening to said events. Other implementations of the EIP may not emit
167  * these events, as it isn't required by the specification.
168  *
169  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
170  * functions have been added to mitigate the well-known issues around setting
171  * allowances. See {IERC20-approve}.
172  */
173 contract ERC20 is Context, IERC20, IERC20Metadata {
174     mapping(address => uint256) private _balances;
175 
176     mapping(address => mapping(address => uint256)) private _allowances;
177 
178     uint256 private _totalSupply;
179 
180     string private _name;
181     string private _symbol;
182 
183     /**
184      * @dev Sets the values for {name} and {symbol}.
185      *
186      * The default value of {decimals} is 18. To select a different value for
187      * {decimals} you should overload it.
188      *
189      * All two of these values are immutable: they can only be set once during
190      * construction.
191      */
192     constructor(string memory name_, string memory symbol_) {
193         _name = name_;
194         _symbol = symbol_;
195     }
196 
197     /**
198      * @dev Returns the name of the token.
199      */
200     function name() public view virtual override returns (string memory) {
201         return _name;
202     }
203 
204     /**
205      * @dev Returns the symbol of the token, usually a shorter version of the
206      * name.
207      */
208     function symbol() public view virtual override returns (string memory) {
209         return _symbol;
210     }
211 
212     /**
213      * @dev Returns the number of decimals used to get its user representation.
214      * For example, if `decimals` equals `2`, a balance of `505` tokens should
215      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
216      *
217      * Tokens usually opt for a value of 18, imitating the relationship between
218      * Ether and Wei. This is the value {ERC20} uses, unless this function is
219      * overridden;
220      *
221      * NOTE: This information is only used for _display_ purposes: it in
222      * no way affects any of the arithmetic of the contract, including
223      * {IERC20-balanceOf} and {IERC20-transfer}.
224      */
225     function decimals() public view virtual override returns (uint8) {
226         return 18;
227     }
228 
229     /**
230      * @dev See {IERC20-totalSupply}.
231      */
232     function totalSupply() public view virtual override returns (uint256) {
233         return _totalSupply;
234     }
235 
236     /**
237      * @dev See {IERC20-balanceOf}.
238      */
239     function balanceOf(address account) public view virtual override returns (uint256) {
240         return _balances[account];
241     }
242 
243     /**
244      * @dev See {IERC20-transfer}.
245      *
246      * Requirements:
247      *
248      * - `to` cannot be the zero address.
249      * - the caller must have a balance of at least `amount`.
250      */
251     function transfer(address to, uint256 amount) public virtual override returns (bool) {
252         address owner = _msgSender();
253         _transfer(owner, to, amount);
254         return true;
255     }
256 
257     /**
258      * @dev See {IERC20-allowance}.
259      */
260     function allowance(address owner, address spender) public view virtual override returns (uint256) {
261         return _allowances[owner][spender];
262     }
263 
264     /**
265      * @dev See {IERC20-approve}.
266      *
267      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
268      * `transferFrom`. This is semantically equivalent to an infinite approval.
269      *
270      * Requirements:
271      *
272      * - `spender` cannot be the zero address.
273      */
274     function approve(address spender, uint256 amount) public virtual override returns (bool) {
275         address owner = _msgSender();
276         _approve(owner, spender, amount);
277         return true;
278     }
279 
280     /**
281      * @dev See {IERC20-transferFrom}.
282      *
283      * Emits an {Approval} event indicating the updated allowance. This is not
284      * required by the EIP. See the note at the beginning of {ERC20}.
285      *
286      * NOTE: Does not update the allowance if the current allowance
287      * is the maximum `uint256`.
288      *
289      * Requirements:
290      *
291      * - `from` and `to` cannot be the zero address.
292      * - `from` must have a balance of at least `amount`.
293      * - the caller must have allowance for ``from``'s tokens of at least
294      * `amount`.
295      */
296     function transferFrom(
297         address from,
298         address to,
299         uint256 amount
300     ) public virtual override returns (bool) {
301         address spender = _msgSender();
302         _spendAllowance(from, spender, amount);
303         _transfer(from, to, amount);
304         return true;
305     }
306 
307     /**
308      * @dev Atomically increases the allowance granted to `spender` by the caller.
309      *
310      * This is an alternative to {approve} that can be used as a mitigation for
311      * problems described in {IERC20-approve}.
312      *
313      * Emits an {Approval} event indicating the updated allowance.
314      *
315      * Requirements:
316      *
317      * - `spender` cannot be the zero address.
318      */
319     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
320         address owner = _msgSender();
321         _approve(owner, spender, allowance(owner, spender) + addedValue);
322         return true;
323     }
324 
325     /**
326      * @dev Atomically decreases the allowance granted to `spender` by the caller.
327      *
328      * This is an alternative to {approve} that can be used as a mitigation for
329      * problems described in {IERC20-approve}.
330      *
331      * Emits an {Approval} event indicating the updated allowance.
332      *
333      * Requirements:
334      *
335      * - `spender` cannot be the zero address.
336      * - `spender` must have allowance for the caller of at least
337      * `subtractedValue`.
338      */
339     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
340         address owner = _msgSender();
341         uint256 currentAllowance = allowance(owner, spender);
342         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
343         unchecked {
344             _approve(owner, spender, currentAllowance - subtractedValue);
345         }
346 
347         return true;
348     }
349 
350     /**
351      * @dev Moves `amount` of tokens from `from` to `to`.
352      *
353      * This internal function is equivalent to {transfer}, and can be used to
354      * e.g. implement automatic token fees, slashing mechanisms, etc.
355      *
356      * Emits a {Transfer} event.
357      *
358      * Requirements:
359      *
360      * - `from` cannot be the zero address.
361      * - `to` cannot be the zero address.
362      * - `from` must have a balance of at least `amount`.
363      */
364     function _transfer(
365         address from,
366         address to,
367         uint256 amount
368     ) internal virtual {
369         require(from != address(0), "ERC20: transfer from the zero address");
370         require(to != address(0), "ERC20: transfer to the zero address");
371 
372         _beforeTokenTransfer(from, to, amount);
373 
374         uint256 fromBalance = _balances[from];
375         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
376         unchecked {
377             _balances[from] = fromBalance - amount;
378         }
379         _balances[to] += amount;
380 
381         emit Transfer(from, to, amount);
382 
383         _afterTokenTransfer(from, to, amount);
384     }
385 
386     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
387      * the total supply.
388      *
389      * Emits a {Transfer} event with `from` set to the zero address.
390      *
391      * Requirements:
392      *
393      * - `account` cannot be the zero address.
394      */
395     function _mint(address account, uint256 amount) internal virtual {
396         require(account != address(0), "ERC20: mint to the zero address");
397 
398         _beforeTokenTransfer(address(0), account, amount);
399 
400         _totalSupply += amount;
401         _balances[account] += amount;
402         emit Transfer(address(0), account, amount);
403 
404         _afterTokenTransfer(address(0), account, amount);
405     }
406 
407     /**
408      * @dev Destroys `amount` tokens from `account`, reducing the
409      * total supply.
410      *
411      * Emits a {Transfer} event with `to` set to the zero address.
412      *
413      * Requirements:
414      *
415      * - `account` cannot be the zero address.
416      * - `account` must have at least `amount` tokens.
417      */
418     function _burn(address account, uint256 amount) internal virtual {
419         require(account != address(0), "ERC20: burn from the zero address");
420 
421         _beforeTokenTransfer(account, address(0), amount);
422 
423         uint256 accountBalance = _balances[account];
424         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
425         unchecked {
426             _balances[account] = accountBalance - amount;
427         }
428         _totalSupply -= amount;
429 
430         emit Transfer(account, address(0), amount);
431 
432         _afterTokenTransfer(account, address(0), amount);
433     }
434 
435     /**
436      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
437      *
438      * This internal function is equivalent to `approve`, and can be used to
439      * e.g. set automatic allowances for certain subsystems, etc.
440      *
441      * Emits an {Approval} event.
442      *
443      * Requirements:
444      *
445      * - `owner` cannot be the zero address.
446      * - `spender` cannot be the zero address.
447      */
448     function _approve(
449         address owner,
450         address spender,
451         uint256 amount
452     ) internal virtual {
453         require(owner != address(0), "ERC20: approve from the zero address");
454         require(spender != address(0), "ERC20: approve to the zero address");
455 
456         _allowances[owner][spender] = amount;
457         emit Approval(owner, spender, amount);
458     }
459 
460     /**
461      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
462      *
463      * Does not update the allowance amount in case of infinite allowance.
464      * Revert if not enough allowance is available.
465      *
466      * Might emit an {Approval} event.
467      */
468     function _spendAllowance(
469         address owner,
470         address spender,
471         uint256 amount
472     ) internal virtual {
473         uint256 currentAllowance = allowance(owner, spender);
474         if (currentAllowance != type(uint256).max) {
475             require(currentAllowance >= amount, "ERC20: insufficient allowance");
476             unchecked {
477                 _approve(owner, spender, currentAllowance - amount);
478             }
479         }
480     }
481 
482     /**
483      * @dev Hook that is called before any transfer of tokens. This includes
484      * minting and burning.
485      *
486      * Calling conditions:
487      *
488      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
489      * will be transferred to `to`.
490      * - when `from` is zero, `amount` tokens will be minted for `to`.
491      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
492      * - `from` and `to` are never both zero.
493      *
494      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
495      */
496     function _beforeTokenTransfer(
497         address from,
498         address to,
499         uint256 amount
500     ) internal virtual {}
501 
502     /**
503      * @dev Hook that is called after any transfer of tokens. This includes
504      * minting and burning.
505      *
506      * Calling conditions:
507      *
508      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
509      * has been transferred to `to`.
510      * - when `from` is zero, `amount` tokens have been minted for `to`.
511      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
512      * - `from` and `to` are never both zero.
513      *
514      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
515      */
516     function _afterTokenTransfer(
517         address from,
518         address to,
519         uint256 amount
520     ) internal virtual {}
521 }
522 
523 // File: @openzeppelin\contracts\token\ERC20\extensions\ERC20Burnable.sol
524 
525 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
526 
527 pragma solidity ^0.8.0;
528 
529 
530 /**
531  * @dev Extension of {ERC20} that allows token holders to destroy both their own
532  * tokens and those that they have an allowance for, in a way that can be
533  * recognized off-chain (via event analysis).
534  */
535 abstract contract ERC20Burnable is Context, ERC20 {
536     /**
537      * @dev Destroys `amount` tokens from the caller.
538      *
539      * See {ERC20-_burn}.
540      */
541     function burn(uint256 amount) public virtual {
542         _burn(_msgSender(), amount);
543     }
544 
545     /**
546      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
547      * allowance.
548      *
549      * See {ERC20-_burn} and {ERC20-allowance}.
550      *
551      * Requirements:
552      *
553      * - the caller must have allowance for ``accounts``'s tokens of at least
554      * `amount`.
555      */
556     function burnFrom(address account, uint256 amount) public virtual {
557         _spendAllowance(account, _msgSender(), amount);
558         _burn(account, amount);
559     }
560 }
561 
562 // File: contracts\COM.sol
563 
564 // Codeak
565 pragma solidity ^0.8.4;
566 interface _HEX { 
567    function currentDay() external view returns (uint256);
568    function stakeLists(address owner, uint256 stakeIndex) external view returns (uint40, uint72, uint72, uint16, uint16, uint16, bool);
569    function stakeGoodAccounting(address stakerAddr, uint256 stakeIndex, uint40 stakeIdParam) external;
570    function globals() external view returns (
571              uint72 lockedHeartsTotal
572             ,uint72 nextStakeSharesTotal
573             ,uint40 shareRate
574             ,uint72 stakePenaltyTotal
575             ,uint16 dailyDataCount
576             ,uint72 stakeSharesTotal
577             ,uint40 latestStakeId
578             ,uint128 claimStats
579             );
580 }
581 
582 contract Communis is ERC20, ERC20Burnable {
583 
584     _HEX private HEX;
585 
586     address internal constant contract_creator = 0x3dEF1720Ce2B04a56f0ee6BC9875C64A785136b9;
587 
588     constructor() ERC20("Communis", "COM") {
589         HEX = _HEX(address(0x2b591e99afE9f32eAA6214f7B7629768c40Eeb39));
590     }
591 
592     function decimals() public view virtual override returns (uint8) {
593         return 12;
594     }
595 
596     enum BonusType {START, END, GOOD, RESTAKE}
597 
598     event newMint(
599          uint256 data0
600         ,uint256 data1
601         ,uint256 indexed stakeId
602         ,uint256 indexed bonusType
603         ,address indexed senderAddr
604         ,address referrer
605     );
606 
607     event newDebtMint(
608          uint256 data0
609         ,address indexed senderAddr
610     );
611 
612     event stakeDepositCodeak(
613          uint256 data0
614         ,address indexed senderAddr
615     );
616 
617     event stakeWithdrawCodeak(
618          uint256 data0
619         ,address indexed senderAddr
620     );
621 
622     struct PayoutResponse {
623         uint256 recalculatedStakeShares;
624         uint256 stakesOriginalShareRate;
625         uint256 maxPayout;
626     }
627 
628     struct Stake {
629         uint256 stakeID;
630         uint256 stakedHearts;
631         uint256 stakeShares;
632         uint256 lockedDay;
633         uint256 stakedDays;
634         uint256 unlockedDay;
635     }
636 
637     struct RestakeEndDebt {
638         uint16  stakedDays;
639         uint16  endBonusPayoutDay;
640         uint72  sharesDebt;
641     }
642 
643     struct EndBonusDebt {
644         uint16 nextPayoutDay;
645         uint128 payoutDebt;
646     }
647 
648     struct stakeIndexIdAmount {
649         uint256 stakeIndex;
650         uint256 stakeID;
651         uint256 stakeAmount;
652     }
653 
654     mapping(uint256 => uint256)                 public stakeIdStartBonusPayout;
655     mapping(uint256 => uint256)                 public stakeIdEndBonusPayout;
656     mapping(address => RestakeEndDebt)          public addressRestakeEndDebt;
657     mapping(address => EndBonusDebt)            public addressEndBonusDebt;
658     mapping(uint256 => uint256)                 public stakeIdGoodAccountingBonusPayout;
659     mapping(address => uint256)                 public addressStakedCodeak;
660 
661     function memoryStake(address adr, uint256 stakeIndex, uint256 stakeID)
662         internal view
663         returns (Stake memory)
664     {
665         uint40 _stakeID;
666         uint72 _stakedHearts;
667         uint72 _stakeShares;
668         uint16 _lockedDay;
669         uint16 _stakedDays;
670         uint16 _unlockedDay;
671 
672         (_stakeID, _stakedHearts, _stakeShares, _lockedDay, _stakedDays, _unlockedDay, ) = HEX.stakeLists(address(adr), stakeIndex);
673 
674         require(_stakeID == stakeID, "COM: Assure correct and current stake");
675 
676         return Stake(_stakeID, _stakedHearts, _stakeShares, _lockedDay, _stakedDays, _unlockedDay);
677     }
678 
679     function getGlobalShareRate()
680         internal view
681         returns (uint256 shareRate)
682     { 
683         (, , shareRate, , , , , ) = HEX.globals(); 
684     }
685 
686     function _emitNewMint(uint256 payout, uint256 stakedDays, uint256 recalculatedStakeShares, uint256 stakesOriginalShareRate, uint256 stakedHearts, uint256 stakeID, address referrer, BonusType bonusType)
687         private
688     {
689         emit newMint(
690             (uint256(uint128(payout)))
691                 | (uint256(uint128(recalculatedStakeShares)) << 128)
692             ,uint256(uint40(block.timestamp))
693                 | (uint256(uint16(stakedDays))               << 40)
694                 | (uint256(uint40(stakesOriginalShareRate))  << 56)
695                 | (uint256(uint72(stakedHearts))             << 96)
696             ,stakeID
697             ,uint(bonusType)
698             ,msg.sender
699             ,referrer
700         );
701     }
702 
703     function _emitNewDebtMint(uint16 nextPayoutDay, uint256 payout, uint128 payoutDebt)
704         private
705     {
706         emit newDebtMint(
707              uint256(nextPayoutDay)
708                 | (uint256(uint112(payout)) << 16)
709                 | (uint256(payoutDebt)      << 128)
710             ,msg.sender
711         );
712     }
713 
714     function _emitStakeDepositCodeak(uint256 amount, uint256 stakedCodeak)
715         private
716     {
717         emit stakeDepositCodeak(
718              uint256(uint128(amount))
719                 | (uint256(uint128(stakedCodeak)) << 128)
720             ,msg.sender
721         );
722     }
723 
724     function _emitStakeWithdrawCodeak(uint256 amount, uint256 stakedCodeak)
725         private
726     {
727         emit stakeWithdrawCodeak(
728              uint256(uint128(amount))
729                 | (uint256(uint128(stakedCodeak)) << 128)
730             ,msg.sender
731         );
732     }
733 
734     /**
735      * 
736      * @dev Reads current RestakeEndDebt
737      * 
738      * Maintains latest end bonus payout day
739      * 
740      * Maintains largest amount staked days
741      * 
742      * Accumulates stake's shares as total sharesDebt
743      * 
744      */
745     function _updateRestakeEndDebt(uint256 currentDay, Stake memory s)
746         private
747     {
748         RestakeEndDebt storage red = addressRestakeEndDebt[msg.sender];
749 
750         if(red.endBonusPayoutDay < currentDay) red.endBonusPayoutDay = uint16(currentDay);
751         if(red.stakedDays < s.stakedDays) red.stakedDays = uint16(s.stakedDays);
752 
753         red.sharesDebt += uint72(s.stakeShares);
754     }
755 
756     /**
757      * 
758      * @dev Reads current RestakeEndDebt
759      * 
760      * Assure new start stake (Stake Memory ss) meets requirements against RestakeEndDebt for Restake Bonus
761      * 
762      * Delete any restake debt if obligations are met
763      * 
764      */
765     function _validateRestakeBonus(Stake memory ss)
766         private
767     {
768         require(ss.stakedDays > 364, "COM: Minimum 365 staked days required");
769 
770         RestakeEndDebt storage red = addressRestakeEndDebt[msg.sender];
771 
772         require(red.endBonusPayoutDay != 0, "COM: No valid restake opportunity");
773         require(ss.lockedDay > red.endBonusPayoutDay, "COM: Start Stake must be newer than previous stake");
774         require(ss.stakedDays == 5555 || ss.stakedDays > red.stakedDays, "COM: New staked days must be greater than to previous");
775         require(ss.stakeShares >= red.sharesDebt, "COM: Restake must at least maintain shares");     
776         require(ss.stakeShares <= (red.sharesDebt * 2), "COM: Restake shares cannot be more than double");
777 
778         delete addressRestakeEndDebt[msg.sender];
779     }
780 
781     /**
782      * 
783      * @dev Reverse engineer amount of bonus HEX hearts that were used in 
784      * determining stake's HEX shares (this data is not kept in HEX storage)
785      * 
786      * Formula is derived from HEX smart contract
787      * 
788      */
789     function getStakesBonusHearts(Stake memory s)
790         internal pure
791         returns (uint256 stakesBonusHearts)
792     {
793         uint256 cappedDays = 0;
794 
795         if (s.stakedDays > 1) cappedDays = s.stakedDays <= 3640 ? s.stakedDays - 1 : 3640;
796 
797         uint256 cappedHearts = s.stakedHearts <= (15 * (10 ** 15)) ? s.stakedHearts : (15 * (10 ** 15));
798 
799         stakesBonusHearts = s.stakedHearts * ((cappedDays * (15 * (10 ** 16))) + (cappedHearts * 1820)) / (273 * (10 ** 18)); 
800     }
801 
802     /**
803      * 
804      * @dev Recalculate amount of bonus HEX hearts that would be applied if 
805      * the cappedDays were not limited to 3640 days
806      * 
807      * Formula is derived from HEX smart contract
808      * 
809      */
810     function getRecalculatedBonusHearts(Stake memory s)
811         internal pure
812         returns (uint256 recalculatedBonusHearts)
813     {
814         uint256 cappedDays = s.stakedDays - 1;
815 
816         uint256 cappedHearts = s.stakedHearts <= (15 * (10 ** 15)) ? s.stakedHearts : (15 * (10 ** 15));
817  
818         recalculatedBonusHearts = s.stakedHearts * ((cappedDays * (15 * (10 ** 16))) + (cappedHearts * 1820)) / (273 * (10 ** 18)); 
819     }
820 
821     /**
822      * 
823      * @dev Creates a consistent PayoutResponse for any given Stake
824      * 
825      * Reverse engineer stakes original share rate as stakesOriginalShareRate using reverse engineered stakes bonus hearts
826      * 
827      * Recalculate Stake Shares with new Recalculated Bonus Hearts and using Reverse engineered stakesOriginalShareRate
828      * 
829      * Calculate penalty for amount days staked out of possible max length staked days of 5555, derived from HEX smart contract
830      * 
831      * Max payout represents the maximum possible value that can be minted for any given Stake
832      * 
833      */
834     function getPayout(Stake memory s)
835         public pure
836         returns (PayoutResponse memory pr)
837     {
838         uint256 stakesOriginalShareRate = ((s.stakedHearts + getStakesBonusHearts(s)) * (10 ** 5)) / s.stakeShares;
839 
840         uint256 recalculatedStakeShares = (s.stakedHearts + getRecalculatedBonusHearts(s)) * (10 ** 17) / stakesOriginalShareRate;
841 
842         pr.stakesOriginalShareRate = stakesOriginalShareRate;
843         pr.recalculatedStakeShares = recalculatedStakeShares;
844 
845         uint256 penalty = (s.stakedDays * (10 ** 15)) / 5555;
846         pr.maxPayout = (recalculatedStakeShares * penalty) / (10 ** 15);
847     }
848 
849     /**
850      * 
851      * @dev Creates a consistent payout for the Start Bonus given any Stake
852      * 
853      * If applyRestakeBonus, staked days range between 365 and 5555: 
854      *      365 days gives bonusPercentage of 50000000000 and thus a 20% payout of maxPayout
855      *      5555 days gives bonusPercentage of 20000000000 and thus a 50% payout of maxPayout
856      * 
857      * Else if staked days greater than 364, staked days range between 365 and 5555: 
858      *      365 days gives bonusPercentage of 100000000000 and thus a 10% payout of maxPayout
859      *      5555 days gives bonusPercentage of 40000000000 and thus a 25% payout of maxPayout
860      * 
861      * Else, staked days range between 180 and 364:
862      *      180 days gives bonusPercentage of 200000000000 and thus a 5% payout of maxPayout
863      *      364 days gives bonusPercentage of ~100540540540 and thus a ~9.946% payout of maxPayout
864      * 
865      * Penalty 
866      *      global share rate is derived from HEX smart contract
867      *      global share rate can only increase over time
868      *      distance between current global share rate and reverse engineered stakes original share rate determine penalty
869      * I.E.
870      *      100,000 stakes share rate / 200,000 global share rate = you keep 50% of Start Bonus payout
871      *      100,000 stakes share rate / 400,000 global share rate = you keep 25% of Start Bonus payout
872      * 
873      */
874     function getStartBonusPayout(uint256 stakedDays, uint256 lockedDay, uint256 maxPayout, uint256 stakesOriginalShareRate, uint256 currentDay, uint256 globalShareRate, bool applyRestakeBonus)
875         public pure
876         returns (uint256 payout)
877     {
878         uint256 bonusPercentage;
879 
880         if(applyRestakeBonus == true) {
881             bonusPercentage = (((stakedDays - 365) * (10 ** 10)) / 5190);
882             bonusPercentage = ((3 * (10 ** 10)) * bonusPercentage) / (10 ** 10);
883             bonusPercentage = (5 * (10 ** 10)) - bonusPercentage;
884         }
885         else if (stakedDays > 364) {
886             bonusPercentage = ((stakedDays - 365) * (10 ** 10)) / 5190;
887             bonusPercentage = ((6 * (10 ** 10)) * bonusPercentage) / (10 ** 10);
888             bonusPercentage = (10 * (10 ** 10)) - bonusPercentage;
889         }
890         else {
891             bonusPercentage = ((stakedDays - 180) * (10 ** 10)) / 185;
892             bonusPercentage = ((10 * (10 ** 10)) * bonusPercentage) / (10 ** 10);
893             bonusPercentage = (20 * (10 ** 10)) - bonusPercentage;
894         }
895  
896         payout = (maxPayout * (10 ** 10)) / bonusPercentage;
897 
898         if(currentDay != lockedDay) {
899             uint256 penalty = (stakesOriginalShareRate * (10 ** 15)) / globalShareRate;
900             payout = (payout * penalty) / (10 ** 15);
901         }
902     }
903 
904     /**
905      * 
906      * @dev Allows withdraw of staked Codeak associated with msg.sender address
907      * 
908      */
909     function withdrawStakedCodeak(uint256 withdrawAmount)
910         external
911     {
912         require(withdrawAmount <= addressStakedCodeak[msg.sender], "COM: Requested withdraw amount is more than Address Staked Amount");
913 
914         addressStakedCodeak[msg.sender] -= withdrawAmount;
915 
916         _mint(msg.sender, withdrawAmount);
917         _emitStakeWithdrawCodeak(withdrawAmount, addressStakedCodeak[msg.sender]);
918     }
919 
920     /**
921      * 
922      * @dev External call to mint stake bonus for staking Codeak
923      * 
924      * Must have end bonus payout debt
925      * 
926      * Must have staked Codeak greater than or equal to end bonus payout debt
927      * 
928      */
929     function mintStakeBonus()
930         external
931     {
932         EndBonusDebt storage ebd = addressEndBonusDebt[msg.sender];
933         if(ebd.payoutDebt != 0) {
934             uint256 stakedCodeak = addressStakedCodeak[msg.sender];
935             require(stakedCodeak >= ebd.payoutDebt, "COM: Address Staked Amount does not cover End Bonus Debt");
936             _mintStakeBonus(ebd, HEX.currentDay(), stakedCodeak);
937         }
938     }
939 
940     /**
941      * 
942      * @dev Mints stake bonus for staking Codeak
943      * 
944      * Must have current day derived from HEX smart contract greater than next payout day
945      * 
946      * Calculates number of payouts based on distance between current day and next payout day
947      * with no limit between the amount of days between them but in 91 day chunks
948      *  
949      * Sets next payout day depending on number of payouts minted
950      * 
951      */
952     function _mintStakeBonus(EndBonusDebt storage ebd, uint256 currentDay, uint256 stakedCodeak)
953         private
954     {
955         if(currentDay >= ebd.nextPayoutDay) {
956             uint256 numberOfPayouts = ((currentDay - ebd.nextPayoutDay) / 91) + 1;
957             uint256 payout = (stakedCodeak * numberOfPayouts) / 80;
958 
959             _mint(msg.sender, payout);
960 
961             ebd.nextPayoutDay += uint16(numberOfPayouts * 91);
962             _emitNewDebtMint(ebd.nextPayoutDay, payout, ebd.payoutDebt);
963         }
964     }
965 
966     /**
967      * 
968      * @dev Allows batch minting of Start Bonuses to reduce gas costs
969      * 
970      */
971     function mintStartBonusBatch(stakeIndexIdAmount[] calldata stakeIndexIdAmounts, address referrer)
972         external
973     {
974         uint256 stakeIndexIdAmountsLength = stakeIndexIdAmounts.length;
975         uint256 currentDay = HEX.currentDay();
976         uint256 globalShareRate = getGlobalShareRate();
977 
978         for(uint256 i = 0; i < stakeIndexIdAmountsLength;){
979             _mintStartBonus(stakeIndexIdAmounts[i].stakeIndex, stakeIndexIdAmounts[i].stakeID, false, referrer, currentDay, globalShareRate, stakeIndexIdAmounts[i].stakeAmount);
980             unchecked {
981                 i++;
982             }
983         }
984     }
985 
986     /**
987      * 
988      * @dev External call for single Start Bonuses
989      * 
990      */
991     function mintStartBonus(uint256 stakeIndex, uint256 stakeID, bool applyRestakeBonus, address referrer, uint256 stakeAmount)
992         external
993     {
994         _mintStartBonus(stakeIndex, stakeID, applyRestakeBonus, referrer, HEX.currentDay(), getGlobalShareRate(), stakeAmount);
995     }
996 
997     /**
998      * 
999      * @dev Mints a bonus for starting a stake in HEX smart contract
1000      * 
1001      * Start bonus is only an upfront cut of the total max payout available for any given stake
1002      * 
1003      * Stake must not have its Start or End Bonus minted already
1004      * 
1005      * Stake shares must be at least 10000 to truncate low value edge cases
1006      * 
1007      * Start bonus forces minting Stake Bonus, if available, before staking new Codeak
1008      * 
1009      */
1010     function _mintStartBonus(uint256 stakeIndex, uint256 stakeID, bool applyRestakeBonus, address referrer, uint256 currentDay, uint256 globalShareRate, uint256 stakeAmount)
1011         private
1012     {
1013         require(stakeIdStartBonusPayout[stakeID] == 0, "COM: StakeID Start Bonus already minted");
1014         require(stakeIdEndBonusPayout[stakeID] == 0, "COM: StakeID End Bonus already minted");
1015 
1016         Stake memory s = memoryStake(address(msg.sender), stakeIndex, stakeID);
1017 
1018         require(s.stakeShares > 9999, "COM: Minimum 10000 shares required");
1019         require(s.stakedDays > 179, "COM: Minimum 180 staked days required");
1020         
1021         require(currentDay >= s.lockedDay, "COM: Stake not Active");
1022 
1023         BonusType bt = BonusType.START;
1024         if(applyRestakeBonus == true) {
1025             _validateRestakeBonus(s);
1026             bt = BonusType.RESTAKE;
1027         }
1028 
1029         PayoutResponse memory pr = getPayout(s);
1030 
1031         uint256 payout = getStartBonusPayout(s.stakedDays, s.lockedDay, pr.maxPayout, pr.stakesOriginalShareRate, currentDay, globalShareRate, applyRestakeBonus);
1032 
1033         if(referrer == msg.sender) {
1034             payout += (payout / 100);
1035         }
1036         else if(referrer != address(0)) {
1037             _mint(referrer, (payout / 100));
1038         }
1039         else {
1040             _mint(contract_creator, (payout / 100));
1041         }
1042 
1043         stakeIdStartBonusPayout[stakeID] = payout;
1044 
1045         EndBonusDebt storage ebd = addressEndBonusDebt[msg.sender];
1046 
1047         if(ebd.payoutDebt != 0 && addressStakedCodeak[msg.sender] >= ebd.payoutDebt) _mintStakeBonus(ebd, currentDay, addressStakedCodeak[msg.sender]);
1048 
1049         if(stakeAmount > 0) {
1050             require(stakeAmount <= payout, "COM: Stake amount is more than available payout");
1051 
1052             addressStakedCodeak[msg.sender] += stakeAmount;
1053 
1054             payout -= stakeAmount;
1055 
1056             _emitStakeDepositCodeak(stakeAmount, addressStakedCodeak[msg.sender]);
1057         }
1058 
1059         if(payout > 0) _mint(msg.sender, payout);
1060         _emitNewMint(payout, s.stakedDays, pr.recalculatedStakeShares, pr.stakesOriginalShareRate, s.stakedHearts, s.stakeID, referrer, bt);
1061     }
1062 
1063     /**
1064      * 
1065      * @dev Allows batch minting of End Bonuses to reduce gas costs
1066      * 
1067      */
1068     function mintEndBonusBatch(stakeIndexIdAmount[] calldata stakeIndexIdAmounts, address referrer)
1069         external
1070     {
1071         uint256 stakeIndexIdAmountsLength = stakeIndexIdAmounts.length;
1072         uint256 currentDay = HEX.currentDay();
1073 
1074         for(uint256 i = 0; i < stakeIndexIdAmountsLength;){
1075             _mintEndBonus(stakeIndexIdAmounts[i].stakeIndex, stakeIndexIdAmounts[i].stakeID, referrer, currentDay, stakeIndexIdAmounts[i].stakeAmount);
1076             unchecked {
1077                 i++;
1078             }
1079         }
1080     }
1081 
1082     /**
1083      * 
1084      * @dev External call for single End Bonuses
1085      * 
1086      */
1087     function mintEndBonus(uint256 stakeIndex, uint256 stakeID, address referrer, uint256 stakeAmount)
1088         external
1089     {
1090         _mintEndBonus(stakeIndex, stakeID, referrer, HEX.currentDay(), stakeAmount);
1091     }
1092 
1093     /**
1094      * 
1095      * @dev Mints a bonus for fulfilling a stakes staked days commitment in HEX smart contract
1096      * 
1097      * End bonus is the remaining total max payout available for any given stake, reduced only based on previous Start Stake Bonus minted
1098      * 
1099      * Stake must not have its End Bonus minted already
1100      * 
1101      * Stake shares must be at least 10000 to truncate low value edge cases
1102      * 
1103      * 50% of End Bonus Payout is accumulated as End Bonus Debt
1104      * 
1105      * End bonus forces minting Stake Bonus, if available, before staking new Codeak
1106      * 
1107      * Allows staking new Codeak before checking if staked Codeak is less than End Bonus Debt
1108      * 
1109      */
1110     function _mintEndBonus(uint256 stakeIndex, uint256 stakeID, address referrer, uint256 currentDay, uint256 stakeAmount)
1111         private
1112     {
1113         require(stakeIdEndBonusPayout[stakeID] == 0, "COM: StakeID End Bonus already minted");
1114 
1115         Stake memory s = memoryStake(address(msg.sender), stakeIndex, stakeID);
1116 
1117         require(s.stakedDays > 364, "COM: Minimum 365 staked days required");
1118         require(s.stakeShares > 9999, "COM: Minimum 10000 shares required");
1119 
1120         uint256 dueDay = s.lockedDay + s.stakedDays;
1121         require(currentDay >= dueDay, "COM: Stake not due");
1122         require(currentDay <= dueDay + 37, "COM: Grace period ended");
1123 
1124         PayoutResponse memory pr = getPayout(s);
1125 
1126         uint256 payout = pr.maxPayout - stakeIdStartBonusPayout[stakeID];
1127 
1128         if(referrer == msg.sender) {
1129             payout += (payout / 100);
1130         }
1131         else if(referrer != address(0)) {
1132             _mint(referrer, (payout / 100));
1133         }
1134         else {
1135             _mint(contract_creator, (payout / 100));
1136         }
1137 
1138         stakeIdEndBonusPayout[stakeID] = payout;
1139 
1140         uint128 payoutDebt = uint128(payout / 2);
1141 
1142         EndBonusDebt storage ebd = addressEndBonusDebt[msg.sender];
1143 
1144         if(ebd.payoutDebt != 0) _mintStakeBonus(ebd, currentDay, addressStakedCodeak[msg.sender]);
1145 
1146         if(stakeAmount > 0) {
1147             require(stakeAmount <= payout, "COM: Stake amount is more than available payout");
1148 
1149             addressStakedCodeak[msg.sender] += stakeAmount;
1150 
1151             payout -= stakeAmount;
1152             
1153             _emitStakeDepositCodeak(stakeAmount, addressStakedCodeak[msg.sender]);
1154         }
1155 
1156         if(ebd.payoutDebt != 0) require(addressStakedCodeak[msg.sender] >= ebd.payoutDebt, "COM: Address Staked Amount does not cover End Bonus Debt");
1157         else ebd.nextPayoutDay = uint16(currentDay) + 91;
1158 
1159         if(payout > 0) _mint(msg.sender, payout);
1160         _emitNewMint(payout, s.stakedDays, pr.recalculatedStakeShares, pr.stakesOriginalShareRate, s.stakedHearts, s.stakeID, referrer, BonusType.END);
1161 
1162         _updateRestakeEndDebt(currentDay, s);
1163         ebd.payoutDebt += payoutDebt;
1164     }
1165 
1166     /**
1167      * 
1168      * @dev Mints a bonus for cleaning stale shares in the HEX smart contract
1169      * 
1170      * Stake must not already be unlocked 
1171      * 
1172      * Stake must not have its End or Good Accounting Bonus minted already
1173      * 
1174      */
1175     function mintGoodAccountingBonus(address stakeOwner, uint256 stakeIndex, uint256 stakeID)
1176         external
1177     {
1178         require(stakeIdGoodAccountingBonusPayout[stakeID] == 0, "COM: StakeID Good Accounting Bonus already minted");
1179         require(stakeIdEndBonusPayout[stakeID] == 0, "COM: StakeID End Bonus already minted");
1180 
1181         Stake memory s = memoryStake(address(stakeOwner), stakeIndex, stakeID);
1182 
1183         require(s.stakeShares > 9999, "COM: Minimum 10000 shares required");
1184         require(s.unlockedDay == 0, "COM: Stake already unlocked");
1185         require(HEX.currentDay() > s.lockedDay + s.stakedDays + 37, "COM: Grace period has not ended");
1186 
1187         HEX.stakeGoodAccounting(address(stakeOwner), stakeIndex, uint40(stakeID));
1188 
1189         Stake memory sga = memoryStake(address(stakeOwner), stakeIndex, stakeID);
1190         require(sga.unlockedDay != 0, "COM: Stake did not have Good Accounting ran");
1191 
1192         PayoutResponse memory pr = getPayout(s);
1193 
1194         uint256 payout = pr.maxPayout / 100;
1195 
1196         stakeIdGoodAccountingBonusPayout[stakeID] = payout;
1197 
1198         _mint(msg.sender, payout);
1199         _emitNewMint(payout, s.stakedDays, pr.recalculatedStakeShares, pr.stakesOriginalShareRate, s.stakedHearts, s.stakeID, address(0), BonusType.GOOD);
1200     }
1201 }