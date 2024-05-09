1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(
63         address sender,
64         address recipient,
65         uint256 amount
66     ) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 
84 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
85 /**
86  * @dev Interface for the optional metadata functions from the ERC20 standard.
87  *
88  * _Available since v4.1._
89  */
90 interface IERC20Metadata is IERC20 {
91     /**
92      * @dev Returns the name of the token.
93      */
94     function name() external view returns (string memory);
95 
96     /**
97      * @dev Returns the symbol of the token.
98      */
99     function symbol() external view returns (string memory);
100 
101     /**
102      * @dev Returns the decimals places of the token.
103      */
104     function decimals() external view returns (uint8);
105 }
106 
107 
108 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
109 /**
110  * @dev Provides information about the current execution context, including the
111  * sender of the transaction and its data. While these are generally available
112  * via msg.sender and msg.data, they should not be accessed in such a direct
113  * manner, since when dealing with meta-transactions the account sending and
114  * paying for execution may not be the actual sender (as far as an application
115  * is concerned).
116  *
117  * This contract is only required for intermediate, library-like contracts.
118  */
119 abstract contract Context {
120     function _msgSender() internal view virtual returns (address) {
121         return msg.sender;
122     }
123 
124     function _msgData() internal view virtual returns (bytes calldata) {
125         return msg.data;
126     }
127 }
128 
129 
130 // OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)
131 /**
132  * @dev Implementation of the {IERC20} interface.
133  *
134  * This implementation is agnostic to the way tokens are created. This means
135  * that a supply mechanism has to be added in a derived contract using {_mint}.
136  * For a generic mechanism see {ERC20PresetMinterPauser}.
137  *
138  * TIP: For a detailed writeup see our guide
139  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
140  * to implement supply mechanisms].
141  *
142  * We have followed general OpenZeppelin Contracts guidelines: functions revert
143  * instead returning `false` on failure. This behavior is nonetheless
144  * conventional and does not conflict with the expectations of ERC20
145  * applications.
146  *
147  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
148  * This allows applications to reconstruct the allowance for all accounts just
149  * by listening to said events. Other implementations of the EIP may not emit
150  * these events, as it isn't required by the specification.
151  *
152  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
153  * functions have been added to mitigate the well-known issues around setting
154  * allowances. See {IERC20-approve}.
155  */
156 contract ERC20 is Context, IERC20, IERC20Metadata {
157     mapping(address => uint256) private _balances;
158 
159     mapping(address => mapping(address => uint256)) private _allowances;
160 
161     uint256 private _totalSupply;
162 
163     string private _name;
164     string private _symbol;
165 
166     /**
167      * @dev Sets the values for {name} and {symbol}.
168      *
169      * The default value of {decimals} is 18. To select a different value for
170      * {decimals} you should overload it.
171      *
172      * All two of these values are immutable: they can only be set once during
173      * construction.
174      */
175     constructor(string memory name_, string memory symbol_) {
176         _name = name_;
177         _symbol = symbol_;
178     }
179 
180     /**
181      * @dev Returns the name of the token.
182      */
183     function name() public view virtual override returns (string memory) {
184         return _name;
185     }
186 
187     /**
188      * @dev Returns the symbol of the token, usually a shorter version of the
189      * name.
190      */
191     function symbol() public view virtual override returns (string memory) {
192         return _symbol;
193     }
194 
195     /**
196      * @dev Returns the number of decimals used to get its user representation.
197      * For example, if `decimals` equals `2`, a balance of `505` tokens should
198      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
199      *
200      * Tokens usually opt for a value of 18, imitating the relationship between
201      * Ether and Wei. This is the value {ERC20} uses, unless this function is
202      * overridden;
203      *
204      * NOTE: This information is only used for _display_ purposes: it in
205      * no way affects any of the arithmetic of the contract, including
206      * {IERC20-balanceOf} and {IERC20-transfer}.
207      */
208     function decimals() public view virtual override returns (uint8) {
209         return 18;
210     }
211 
212     /**
213      * @dev See {IERC20-totalSupply}.
214      */
215     function totalSupply() public view virtual override returns (uint256) {
216         return _totalSupply;
217     }
218 
219     /**
220      * @dev See {IERC20-balanceOf}.
221      */
222     function balanceOf(address account) public view virtual override returns (uint256) {
223         return _balances[account];
224     }
225 
226     /**
227      * @dev See {IERC20-transfer}.
228      *
229      * Requirements:
230      *
231      * - `recipient` cannot be the zero address.
232      * - the caller must have a balance of at least `amount`.
233      */
234     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
235         _transfer(_msgSender(), recipient, amount);
236         return true;
237     }
238 
239     /**
240      * @dev See {IERC20-allowance}.
241      */
242     function allowance(address owner, address spender) public view virtual override returns (uint256) {
243         return _allowances[owner][spender];
244     }
245 
246     /**
247      * @dev See {IERC20-approve}.
248      *
249      * Requirements:
250      *
251      * - `spender` cannot be the zero address.
252      */
253     function approve(address spender, uint256 amount) public virtual override returns (bool) {
254         _approve(_msgSender(), spender, amount);
255         return true;
256     }
257 
258     /**
259      * @dev See {IERC20-transferFrom}.
260      *
261      * Emits an {Approval} event indicating the updated allowance. This is not
262      * required by the EIP. See the note at the beginning of {ERC20}.
263      *
264      * Requirements:
265      *
266      * - `sender` and `recipient` cannot be the zero address.
267      * - `sender` must have a balance of at least `amount`.
268      * - the caller must have allowance for ``sender``'s tokens of at least
269      * `amount`.
270      */
271     function transferFrom(
272         address sender,
273         address recipient,
274         uint256 amount
275     ) public virtual override returns (bool) {
276         _transfer(sender, recipient, amount);
277 
278         uint256 currentAllowance = _allowances[sender][_msgSender()];
279         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
280         unchecked {
281             _approve(sender, _msgSender(), currentAllowance - amount);
282         }
283 
284         return true;
285     }
286 
287     /**
288      * @dev Atomically increases the allowance granted to `spender` by the caller.
289      *
290      * This is an alternative to {approve} that can be used as a mitigation for
291      * problems described in {IERC20-approve}.
292      *
293      * Emits an {Approval} event indicating the updated allowance.
294      *
295      * Requirements:
296      *
297      * - `spender` cannot be the zero address.
298      */
299     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
300         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
301         return true;
302     }
303 
304     /**
305      * @dev Atomically decreases the allowance granted to `spender` by the caller.
306      *
307      * This is an alternative to {approve} that can be used as a mitigation for
308      * problems described in {IERC20-approve}.
309      *
310      * Emits an {Approval} event indicating the updated allowance.
311      *
312      * Requirements:
313      *
314      * - `spender` cannot be the zero address.
315      * - `spender` must have allowance for the caller of at least
316      * `subtractedValue`.
317      */
318     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
319         uint256 currentAllowance = _allowances[_msgSender()][spender];
320         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
321         unchecked {
322             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
323         }
324 
325         return true;
326     }
327 
328     /**
329      * @dev Moves `amount` of tokens from `sender` to `recipient`.
330      *
331      * This internal function is equivalent to {transfer}, and can be used to
332      * e.g. implement automatic token fees, slashing mechanisms, etc.
333      *
334      * Emits a {Transfer} event.
335      *
336      * Requirements:
337      *
338      * - `sender` cannot be the zero address.
339      * - `recipient` cannot be the zero address.
340      * - `sender` must have a balance of at least `amount`.
341      */
342     function _transfer(
343         address sender,
344         address recipient,
345         uint256 amount
346     ) internal virtual {
347         require(sender != address(0), "ERC20: transfer from the zero address");
348         require(recipient != address(0), "ERC20: transfer to the zero address");
349 
350         _beforeTokenTransfer(sender, recipient, amount);
351 
352         uint256 senderBalance = _balances[sender];
353         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
354         unchecked {
355             _balances[sender] = senderBalance - amount;
356         }
357         _balances[recipient] += amount;
358 
359         emit Transfer(sender, recipient, amount);
360 
361         _afterTokenTransfer(sender, recipient, amount);
362     }
363 
364     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
365      * the total supply.
366      *
367      * Emits a {Transfer} event with `from` set to the zero address.
368      *
369      * Requirements:
370      *
371      * - `account` cannot be the zero address.
372      */
373     function _mint(address account, uint256 amount) internal virtual {
374         require(account != address(0), "ERC20: mint to the zero address");
375 
376         _beforeTokenTransfer(address(0), account, amount);
377 
378         _totalSupply += amount;
379         _balances[account] += amount;
380         emit Transfer(address(0), account, amount);
381 
382         _afterTokenTransfer(address(0), account, amount);
383     }
384 
385     /**
386      * @dev Destroys `amount` tokens from `account`, reducing the
387      * total supply.
388      *
389      * Emits a {Transfer} event with `to` set to the zero address.
390      *
391      * Requirements:
392      *
393      * - `account` cannot be the zero address.
394      * - `account` must have at least `amount` tokens.
395      */
396     function _burn(address account, uint256 amount) internal virtual {
397         require(account != address(0), "ERC20: burn from the zero address");
398 
399         _beforeTokenTransfer(account, address(0), amount);
400 
401         uint256 accountBalance = _balances[account];
402         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
403         unchecked {
404             _balances[account] = accountBalance - amount;
405         }
406         _totalSupply -= amount;
407 
408         emit Transfer(account, address(0), amount);
409 
410         _afterTokenTransfer(account, address(0), amount);
411     }
412 
413     /**
414      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
415      *
416      * This internal function is equivalent to `approve`, and can be used to
417      * e.g. set automatic allowances for certain subsystems, etc.
418      *
419      * Emits an {Approval} event.
420      *
421      * Requirements:
422      *
423      * - `owner` cannot be the zero address.
424      * - `spender` cannot be the zero address.
425      */
426     function _approve(
427         address owner,
428         address spender,
429         uint256 amount
430     ) internal virtual {
431         require(owner != address(0), "ERC20: approve from the zero address");
432         require(spender != address(0), "ERC20: approve to the zero address");
433 
434         _allowances[owner][spender] = amount;
435         emit Approval(owner, spender, amount);
436     }
437 
438     /**
439      * @dev Hook that is called before any transfer of tokens. This includes
440      * minting and burning.
441      *
442      * Calling conditions:
443      *
444      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
445      * will be transferred to `to`.
446      * - when `from` is zero, `amount` tokens will be minted for `to`.
447      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
448      * - `from` and `to` are never both zero.
449      *
450      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
451      */
452     function _beforeTokenTransfer(
453         address from,
454         address to,
455         uint256 amount
456     ) internal virtual {}
457 
458     /**
459      * @dev Hook that is called after any transfer of tokens. This includes
460      * minting and burning.
461      *
462      * Calling conditions:
463      *
464      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
465      * has been transferred to `to`.
466      * - when `from` is zero, `amount` tokens have been minted for `to`.
467      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
468      * - `from` and `to` are never both zero.
469      *
470      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
471      */
472     function _afterTokenTransfer(
473         address from,
474         address to,
475         uint256 amount
476     ) internal virtual {}
477 }
478 
479 
480 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/ERC20Burnable.sol)
481 /**
482  * @dev Extension of {ERC20} that allows token holders to destroy both their own
483  * tokens and those that they have an allowance for, in a way that can be
484  * recognized off-chain (via event analysis).
485  */
486 abstract contract ERC20Burnable is Context, ERC20 {
487     /**
488      * @dev Destroys `amount` tokens from the caller.
489      *
490      * See {ERC20-_burn}.
491      */
492     function burn(uint256 amount) public virtual {
493         _burn(_msgSender(), amount);
494     }
495 
496     /**
497      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
498      * allowance.
499      *
500      * See {ERC20-_burn} and {ERC20-allowance}.
501      *
502      * Requirements:
503      *
504      * - the caller must have allowance for ``accounts``'s tokens of at least
505      * `amount`.
506      */
507     function burnFrom(address account, uint256 amount) public virtual {
508         uint256 currentAllowance = allowance(account, _msgSender());
509         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
510         unchecked {
511             _approve(account, _msgSender(), currentAllowance - amount);
512         }
513         _burn(account, amount);
514     }
515 }
516 
517 
518 contract VestingContract {
519 
520     IERC20 internal token;
521 
522     // start cliff time is deployment time
523     uint256 internal amount;
524     uint256 internal startReleaseDate;
525     uint256 internal distributed;
526     uint256 internal releasePeriod;
527     uint256 internal distributedTime;
528     uint256 internal percentage;
529     address internal beneficiary;
530 
531     constructor (IERC20 _token, uint256 _amount, uint256 _distributed, address _beneficiary, uint256 _percentage, uint256 _cliffTime, uint256 _releasePeriod) {
532         startReleaseDate = block.timestamp + _cliffTime;
533         releasePeriod = _releasePeriod;
534 
535         token = _token;
536         amount = _amount;
537         distributed = _distributed;
538         beneficiary = _beneficiary;
539         percentage = _percentage;
540     }
541 
542     function release() public {
543         // fully release
544         require(amount > distributed, "Vesting is fully released") ;
545         require(startReleaseDate + distributedTime*releasePeriod < block.timestamp, "Token is still in lock");
546 
547         uint256 periodReleaseToken = percentage*amount/10000;
548         uint256 releaseToken = (amount - distributed) > periodReleaseToken ? periodReleaseToken: (amount - distributed);
549 
550         distributed = distributed + releaseToken;
551         distributedTime++;
552 
553         token.transfer(beneficiary, releaseToken);
554     }
555 
556     function vestingInfo() public view returns (
557         IERC20 _token, address _beneficiary, uint256 _amount, uint256 _distributed, 
558         uint256 _startReleaseDate, uint256 _releasePeriod, uint256 _distributedTime, uint256 _percentage) {
559         
560         return (token, beneficiary, amount, distributed, startReleaseDate, releasePeriod, distributedTime, percentage);
561     }
562 }
563 
564 
565 contract SLEEPFUTURE is ERC20Burnable {
566     uint256 constant TOTAL_SUPPLY = 1*(10**9)*(10**18); //1 billion tokens;
567 
568     uint256 internal token4Seed = 4*TOTAL_SUPPLY/100; //4%
569     uint256 internal token4PrivateSale = 3*TOTAL_SUPPLY/100; //3%
570     uint256 internal token4PreSale = 2*TOTAL_SUPPLY/100; //2%
571     uint256 internal token4PublicSale = 1*TOTAL_SUPPLY/100; //1%
572     uint256 internal token4Team = 16*TOTAL_SUPPLY/100; // 16%
573     uint256 internal token4Rewards = 30*TOTAL_SUPPLY/100; // 30%
574     uint256 internal token4Foundation = 20*TOTAL_SUPPLY/100; // 20%
575     uint256 internal token4Marketing = 12*TOTAL_SUPPLY/100; // 12%
576     uint256 internal token4Liquidity = 9*TOTAL_SUPPLY/100; // 9%
577     uint256 internal token4Reserve = 3*TOTAL_SUPPLY/100; // 3%
578 
579     address[] internal vestingLists;
580 
581     //Total 100%
582 
583     constructor () ERC20 ("Sleep Future", "SLEEPEE"){
584         _genesisDistributeAndLock();
585     }
586 
587     function getVestings() public view returns (address[] memory vestings) {
588         return vestingLists;
589     }
590 
591      /**
592      * distribute token for team, marketing, foundation, ...
593      */
594     function _genesisDistributeAndLock() internal {
595         address seedAddress = 0x43AedAdE0066A57247D8D8D45424E2AcaA9aEB70;
596         address privateSaleAddress = 0xb0438dcd547653E5B651d09e279A10F5a5C0dad6;
597         address presaleAddress = 0x2285dF9ffeb3Bd2d12147438C3b7D8a680Be8B49;
598         address publicsaleAddress = 0x82Fa77dBA44b0b5bB4285d2b8dc495F5EFe38a50;
599         address teamAddress = 0x4234f7E49306db385467b8c34Dca8126ebf99D9F;
600         address rewardsAddress = 0xEd63440C8b4201472630ae73bC6290598010F2E5;
601         address foundationAddress = 0x7D95666BfaEa4e64430C6B692B73755E87685acA;
602         address marketingAddress = 0xb83ee3dD3B67DD7fC2f8a46837542f0203386E22;
603         address liquidityAddress = 0x1cd5B0a4aB410313370eb6b0B5cD081CAD2Fa89c;
604         address reserveAddress = 0x0e6593d0d2B1C3aFd627ce7136672D34648dEd7F;
605 
606         // distribute for ecosystem and stacking
607         _distributeAndLockToken(500, token4Seed, seedAddress, 791, 90 days, 30 days);
608         _distributeAndLockToken(500, token4PrivateSale, privateSaleAddress, 1055, 90 days, 30 days);
609         _distributeAndLockToken(0, token4PreSale, presaleAddress, 2000, 10 days, 30 days);
610         _distributeAndLockToken(1000, token4PublicSale, publicsaleAddress, 1000, 30 days, 30 days);
611         _distributeAndLockToken(0, token4Team, teamAddress, 500, 365 days, 30 days);
612         _distributeAndLockToken(0, token4Rewards, rewardsAddress, 500, 30 days, 30 days);
613         _distributeAndLockToken(100, token4Foundation, foundationAddress, 450, 90 days, 30 days);
614         _distributeAndLockToken(0, token4Marketing, marketingAddress, 300, 14 days, 30 days);
615         _distributeAndLockToken(100, token4Liquidity, liquidityAddress, 500, 30 days, 30 days);
616         _distributeAndLockToken(100, token4Reserve, reserveAddress, 500, 90 days, 30 days);
617     }
618 
619     function _distributeAndLockToken(uint256 _tgePercent, uint256 _totalVesting, address _beneficiary, uint256 _periodPecentage, uint256 _cliffTime, uint256 _releasePeriod) internal {
620         uint256 tgeToken = _tgePercent*_totalVesting/10000;
621 
622         // (IERC20 _token, uint _amount, uint _distributed, address _beneficiary, uint _percentage, uint _cliffTime, uint _releasePeriod)
623         VestingContract vesting = new VestingContract(
624             IERC20(this),
625             _totalVesting,
626             tgeToken,
627             _beneficiary,
628             _periodPecentage,
629             _cliffTime,
630             _releasePeriod
631         );
632 
633         vestingLists.push(address(vesting));
634 
635         _mint(address(vesting), _totalVesting - tgeToken);
636         if(tgeToken > 0) _mint(_beneficiary, tgeToken);
637     }
638 
639     function transferToMany(
640         address[] memory receivingWalletList_,
641         uint256[] memory receivingAmountList_
642     ) external {
643         require(
644             receivingWalletList_.length == receivingAmountList_.length,
645             "receivingWalletList_ and receivingAmountList_ not same length"
646         );
647 
648         for (uint256 i = 0; i < receivingWalletList_.length; i++) {
649             _transfer(
650                 _msgSender(),
651                 receivingWalletList_[i],
652                 receivingAmountList_[i]
653             );
654         }
655     }
656 }