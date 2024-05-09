1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         _nonReentrantBefore();
54         _;
55         _nonReentrantAfter();
56     }
57 
58     function _nonReentrantBefore() private {
59         // On the first call to nonReentrant, _status will be _NOT_ENTERED
60         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
61 
62         // Any calls to nonReentrant after this point will fail
63         _status = _ENTERED;
64     }
65 
66     function _nonReentrantAfter() private {
67         // By storing the original value once again, a refund is triggered (see
68         // https://eips.ethereum.org/EIPS/eip-2200)
69         _status = _NOT_ENTERED;
70     }
71 }
72 
73 // File: @openzeppelin/contracts@4.8.1/utils/Context.sol
74 
75 
76 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
77 
78 pragma solidity ^0.8.0;
79 
80 /**
81  * @dev Provides information about the current execution context, including the
82  * sender of the transaction and its data. While these are generally available
83  * via msg.sender and msg.data, they should not be accessed in such a direct
84  * manner, since when dealing with meta-transactions the account sending and
85  * paying for execution may not be the actual sender (as far as an application
86  * is concerned).
87  *
88  * This contract is only required for intermediate, library-like contracts.
89  */
90 abstract contract Context {
91     function _msgSender() internal view virtual returns (address) {
92         return msg.sender;
93     }
94 
95     function _msgData() internal view virtual returns (bytes calldata) {
96         return msg.data;
97     }
98 }
99 
100 // File: @openzeppelin/contracts@4.8.1/token/ERC20/IERC20.sol
101 
102 
103 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
104 
105 pragma solidity ^0.8.0;
106 
107 /**
108  * @dev Interface of the ERC20 standard as defined in the EIP.
109  */
110 interface IERC20 {
111     /**
112      * @dev Emitted when `value` tokens are moved from one account (`from`) to
113      * another (`to`).
114      *
115      * Note that `value` may be zero.
116      */
117     event Transfer(address indexed from, address indexed to, uint256 value);
118 
119     /**
120      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
121      * a call to {approve}. `value` is the new allowance.
122      */
123     event Approval(address indexed owner, address indexed spender, uint256 value);
124 
125     /**
126      * @dev Returns the amount of tokens in existence.
127      */
128     function totalSupply() external view returns (uint256);
129 
130     /**
131      * @dev Returns the amount of tokens owned by `account`.
132      */
133     function balanceOf(address account) external view returns (uint256);
134 
135     /**
136      * @dev Moves `amount` tokens from the caller's account to `to`.
137      *
138      * Returns a boolean value indicating whether the operation succeeded.
139      *
140      * Emits a {Transfer} event.
141      */
142     function transfer(address to, uint256 amount) external returns (bool);
143 
144     /**
145      * @dev Returns the remaining number of tokens that `spender` will be
146      * allowed to spend on behalf of `owner` through {transferFrom}. This is
147      * zero by default.
148      *
149      * This value changes when {approve} or {transferFrom} are called.
150      */
151     function allowance(address owner, address spender) external view returns (uint256);
152 
153     /**
154      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
155      *
156      * Returns a boolean value indicating whether the operation succeeded.
157      *
158      * IMPORTANT: Beware that changing an allowance with this method brings the risk
159      * that someone may use both the old and the new allowance by unfortunate
160      * transaction ordering. One possible solution to mitigate this race
161      * condition is to first reduce the spender's allowance to 0 and set the
162      * desired value afterwards:
163      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164      *
165      * Emits an {Approval} event.
166      */
167     function approve(address spender, uint256 amount) external returns (bool);
168 
169     /**
170      * @dev Moves `amount` tokens from `from` to `to` using the
171      * allowance mechanism. `amount` is then deducted from the caller's
172      * allowance.
173      *
174      * Returns a boolean value indicating whether the operation succeeded.
175      *
176      * Emits a {Transfer} event.
177      */
178     function transferFrom(
179         address from,
180         address to,
181         uint256 amount
182     ) external returns (bool);
183 }
184 
185 // File: @openzeppelin/contracts@4.8.1/token/ERC20/extensions/IERC20Metadata.sol
186 
187 
188 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
189 
190 pragma solidity ^0.8.0;
191 
192 
193 /**
194  * @dev Interface for the optional metadata functions from the ERC20 standard.
195  *
196  * _Available since v4.1._
197  */
198 interface IERC20Metadata is IERC20 {
199     /**
200      * @dev Returns the name of the token.
201      */
202     function name() external view returns (string memory);
203 
204     /**
205      * @dev Returns the symbol of the token.
206      */
207     function symbol() external view returns (string memory);
208 
209     /**
210      * @dev Returns the decimals places of the token.
211      */
212     function decimals() external view returns (uint8);
213 }
214 
215 // File: @openzeppelin/contracts@4.8.1/token/ERC20/ERC20.sol
216 
217 
218 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
219 
220 pragma solidity ^0.8.0;
221 
222 
223 
224 
225 /**
226  * @dev Implementation of the {IERC20} interface.
227  *
228  * This implementation is agnostic to the way tokens are created. This means
229  * that a supply mechanism has to be added in a derived contract using {_mint}.
230  * For a generic mechanism see {ERC20PresetMinterPauser}.
231  *
232  * TIP: For a detailed writeup see our guide
233  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
234  * to implement supply mechanisms].
235  *
236  * We have followed general OpenZeppelin Contracts guidelines: functions revert
237  * instead returning `false` on failure. This behavior is nonetheless
238  * conventional and does not conflict with the expectations of ERC20
239  * applications.
240  *
241  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
242  * This allows applications to reconstruct the allowance for all accounts just
243  * by listening to said events. Other implementations of the EIP may not emit
244  * these events, as it isn't required by the specification.
245  *
246  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
247  * functions have been added to mitigate the well-known issues around setting
248  * allowances. See {IERC20-approve}.
249  */
250 contract ERC20 is Context, IERC20, IERC20Metadata {
251     mapping(address => uint256) private _balances;
252 
253     mapping(address => mapping(address => uint256)) private _allowances;
254 
255     uint256 private _totalSupply;
256 
257     string private _name;
258     string private _symbol;
259 
260     /**
261      * @dev Sets the values for {name} and {symbol}.
262      *
263      * The default value of {decimals} is 18. To select a different value for
264      * {decimals} you should overload it.
265      *
266      * All two of these values are immutable: they can only be set once during
267      * construction.
268      */
269     constructor(string memory name_, string memory symbol_) {
270         _name = name_;
271         _symbol = symbol_;
272     }
273 
274     /**
275      * @dev Returns the name of the token.
276      */
277     function name() public view virtual override returns (string memory) {
278         return _name;
279     }
280 
281     /**
282      * @dev Returns the symbol of the token, usually a shorter version of the
283      * name.
284      */
285     function symbol() public view virtual override returns (string memory) {
286         return _symbol;
287     }
288 
289     /**
290      * @dev Returns the number of decimals used to get its user representation.
291      * For example, if `decimals` equals `2`, a balance of `505` tokens should
292      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
293      *
294      * Tokens usually opt for a value of 18, imitating the relationship between
295      * Ether and Wei. This is the value {ERC20} uses, unless this function is
296      * overridden;
297      *
298      * NOTE: This information is only used for _display_ purposes: it in
299      * no way affects any of the arithmetic of the contract, including
300      * {IERC20-balanceOf} and {IERC20-transfer}.
301      */
302     function decimals() public view virtual override returns (uint8) {
303         return 18;
304     }
305 
306     /**
307      * @dev See {IERC20-totalSupply}.
308      */
309     function totalSupply() public view virtual override returns (uint256) {
310         return _totalSupply;
311     }
312 
313     /**
314      * @dev See {IERC20-balanceOf}.
315      */
316     function balanceOf(address account) public view virtual override returns (uint256) {
317         return _balances[account];
318     }
319 
320     /**
321      * @dev See {IERC20-transfer}.
322      *
323      * Requirements:
324      *
325      * - `to` cannot be the zero address.
326      * - the caller must have a balance of at least `amount`.
327      */
328     function transfer(address to, uint256 amount) public virtual override returns (bool) {
329         address owner = _msgSender();
330         _transfer(owner, to, amount);
331         return true;
332     }
333 
334     /**
335      * @dev See {IERC20-allowance}.
336      */
337     function allowance(address owner, address spender) public view virtual override returns (uint256) {
338         return _allowances[owner][spender];
339     }
340 
341     /**
342      * @dev See {IERC20-approve}.
343      *
344      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
345      * `transferFrom`. This is semantically equivalent to an infinite approval.
346      *
347      * Requirements:
348      *
349      * - `spender` cannot be the zero address.
350      */
351     function approve(address spender, uint256 amount) public virtual override returns (bool) {
352         address owner = _msgSender();
353         _approve(owner, spender, amount);
354         return true;
355     }
356 
357     /**
358      * @dev See {IERC20-transferFrom}.
359      *
360      * Emits an {Approval} event indicating the updated allowance. This is not
361      * required by the EIP. See the note at the beginning of {ERC20}.
362      *
363      * NOTE: Does not update the allowance if the current allowance
364      * is the maximum `uint256`.
365      *
366      * Requirements:
367      *
368      * - `from` and `to` cannot be the zero address.
369      * - `from` must have a balance of at least `amount`.
370      * - the caller must have allowance for ``from``'s tokens of at least
371      * `amount`.
372      */
373     function transferFrom(
374         address from,
375         address to,
376         uint256 amount
377     ) public virtual override returns (bool) {
378         address spender = _msgSender();
379         _spendAllowance(from, spender, amount);
380         _transfer(from, to, amount);
381         return true;
382     }
383 
384     /**
385      * @dev Atomically increases the allowance granted to `spender` by the caller.
386      *
387      * This is an alternative to {approve} that can be used as a mitigation for
388      * problems described in {IERC20-approve}.
389      *
390      * Emits an {Approval} event indicating the updated allowance.
391      *
392      * Requirements:
393      *
394      * - `spender` cannot be the zero address.
395      */
396     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
397         address owner = _msgSender();
398         _approve(owner, spender, allowance(owner, spender) + addedValue);
399         return true;
400     }
401 
402     /**
403      * @dev Atomically decreases the allowance granted to `spender` by the caller.
404      *
405      * This is an alternative to {approve} that can be used as a mitigation for
406      * problems described in {IERC20-approve}.
407      *
408      * Emits an {Approval} event indicating the updated allowance.
409      *
410      * Requirements:
411      *
412      * - `spender` cannot be the zero address.
413      * - `spender` must have allowance for the caller of at least
414      * `subtractedValue`.
415      */
416     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
417         address owner = _msgSender();
418         uint256 currentAllowance = allowance(owner, spender);
419         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
420         unchecked {
421             _approve(owner, spender, currentAllowance - subtractedValue);
422         }
423 
424         return true;
425     }
426 
427     /**
428      * @dev Moves `amount` of tokens from `from` to `to`.
429      *
430      * This internal function is equivalent to {transfer}, and can be used to
431      * e.g. implement automatic token fees, slashing mechanisms, etc.
432      *
433      * Emits a {Transfer} event.
434      *
435      * Requirements:
436      *
437      * - `from` cannot be the zero address.
438      * - `to` cannot be the zero address.
439      * - `from` must have a balance of at least `amount`.
440      */
441     function _transfer(
442         address from,
443         address to,
444         uint256 amount
445     ) internal virtual {
446         require(from != address(0), "ERC20: transfer from the zero address");
447         require(to != address(0), "ERC20: transfer to the zero address");
448 
449         _beforeTokenTransfer(from, to, amount);
450 
451         uint256 fromBalance = _balances[from];
452         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
453         unchecked {
454             _balances[from] = fromBalance - amount;
455             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
456             // decrementing then incrementing.
457             _balances[to] += amount;
458         }
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
480         unchecked {
481             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
482             _balances[account] += amount;
483         }
484         emit Transfer(address(0), account, amount);
485 
486         _afterTokenTransfer(address(0), account, amount);
487     }
488 
489     /**
490      * @dev Destroys `amount` tokens from `account`, reducing the
491      * total supply.
492      *
493      * Emits a {Transfer} event with `to` set to the zero address.
494      *
495      * Requirements:
496      *
497      * - `account` cannot be the zero address.
498      * - `account` must have at least `amount` tokens.
499      */
500     function _burn(address account, uint256 amount) internal virtual {
501         require(account != address(0), "ERC20: burn from the zero address");
502 
503         _beforeTokenTransfer(account, address(0), amount);
504 
505         uint256 accountBalance = _balances[account];
506         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
507         unchecked {
508             _balances[account] = accountBalance - amount;
509             // Overflow not possible: amount <= accountBalance <= totalSupply.
510             _totalSupply -= amount;
511         }
512 
513         emit Transfer(account, address(0), amount);
514 
515         _afterTokenTransfer(account, address(0), amount);
516     }
517 
518     /**
519      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
520      *
521      * This internal function is equivalent to `approve`, and can be used to
522      * e.g. set automatic allowances for certain subsystems, etc.
523      *
524      * Emits an {Approval} event.
525      *
526      * Requirements:
527      *
528      * - `owner` cannot be the zero address.
529      * - `spender` cannot be the zero address.
530      */
531     function _approve(
532         address owner,
533         address spender,
534         uint256 amount
535     ) internal virtual {
536         require(owner != address(0), "ERC20: approve from the zero address");
537         require(spender != address(0), "ERC20: approve to the zero address");
538 
539         _allowances[owner][spender] = amount;
540         emit Approval(owner, spender, amount);
541     }
542 
543     /**
544      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
545      *
546      * Does not update the allowance amount in case of infinite allowance.
547      * Revert if not enough allowance is available.
548      *
549      * Might emit an {Approval} event.
550      */
551     function _spendAllowance(
552         address owner,
553         address spender,
554         uint256 amount
555     ) internal virtual {
556         uint256 currentAllowance = allowance(owner, spender);
557         if (currentAllowance != type(uint256).max) {
558             require(currentAllowance >= amount, "ERC20: insufficient allowance");
559             unchecked {
560                 _approve(owner, spender, currentAllowance - amount);
561             }
562         }
563     }
564 
565     /**
566      * @dev Hook that is called before any transfer of tokens. This includes
567      * minting and burning.
568      *
569      * Calling conditions:
570      *
571      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
572      * will be transferred to `to`.
573      * - when `from` is zero, `amount` tokens will be minted for `to`.
574      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
575      * - `from` and `to` are never both zero.
576      *
577      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
578      */
579     function _beforeTokenTransfer(
580         address from,
581         address to,
582         uint256 amount
583     ) internal virtual {}
584 
585     /**
586      * @dev Hook that is called after any transfer of tokens. This includes
587      * minting and burning.
588      *
589      * Calling conditions:
590      *
591      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
592      * has been transferred to `to`.
593      * - when `from` is zero, `amount` tokens have been minted for `to`.
594      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
595      * - `from` and `to` are never both zero.
596      *
597      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
598      */
599     function _afterTokenTransfer(
600         address from,
601         address to,
602         uint256 amount
603     ) internal virtual {}
604 }
605 
606 // File: contracts/DipCatcherMembership.sol
607 
608 
609 pragma solidity ^0.8.9;
610 
611 
612 
613 /*
614 Access to the Dip Catcher Algorithm TradingView Script will be granted only to a limited number of Members or those that exercise a Buddy Pass.
615 
616 How do I become a Member?
617 - Membership slots are for sale, first come first serve, starting with _ slots at .025 ETH each.
618 - Once all 200 slots are filled at the 0.025 ETH rate, the slot rate will increase by .005 ETH and another 200 will be available at the new rate. This goes on until 30 days elapses with no new minting, and then minting will be permanently closed.
619 
620 What do Members get?
621 - Members gain access to the Private Dip Catcher Trading View algorithm
622 - Members get 1 Buddy Pass $DCA that they can either gift to a friend or sell on the market.
623 
624 How do Members request access?
625 By signing a message off-chain containing proof of membership and submitting it to the provided dashboard.
626 
627 How do Buddy Pass Holders request access?
628 By signing a message off-chain containing proof of burn of 1 whole $DCA token and submitting it to the provided dashboard.
629 
630 
631 */
632 contract DipCatcherAlgorithm is ERC20, ReentrancyGuard{
633     event Mint(address indexed minter, uint tranche,uint tranche_rank, uint amount);
634     event Redeem(address indexed burner, uint amount);
635     event Flush(address indexed flusher, uint amount);
636     uint256 ACTIVATION_TIMESTAMP;
637     uint256 public LAST_DAY_TO_MINT = 30; // Increments every time a minting takes place. If no mints take place over a 30 day period, no more will be available.
638     address constant public flusher = 0x2848e510C6FA6424b623708F8478Db1047BF769C; // this is the address that the incoming ETH belongs to. Once you send ETH into the contract it no longer belongs to you. 
639     mapping (address => bool) public IS_MEMBER; // Dip Catcher Algorithm will only be made available to people who's addresses are marked as being a member
640     mapping (uint256 => uint256) public RATE_TRANCHE_COUNT; // counts how many mints are made at each rate tranche
641     uint256 public SLOTS_PER_TRANCHE = 200;
642     uint256 public STARTING_RATE  = 25 * (10**15); // 0.025 ETH 
643     uint256 public TRANCHE_INCREMENT = 5 * (10**15); // After each rate tranche is filled up to the number of SLOTS_PER_TRANCHE, the rate increases by 0.005 ETH for the next tranche.
644     uint256 public CURRENT_TRANCHE; // Smallest tranche not filled up yet.
645     constructor() ERC20("Dip Catcher Algorithm", "DCA") ReentrancyGuard(){
646         ACTIVATION_TIMESTAMP = block.timestamp;
647     }
648     
649     /// Minting Function
650     /// @dev The receive() function is an external, payable, and non-reentrant function for logging membership and minting the buddy pass token (DCA). It requires that the "Minting Phase" is active, and that the incoming value (msg.value) is greater than or equal to the current rate (getCurrentRate()). If the incoming value is greater than the current rate, the excess value is sent back to the sender. The function logs the mint in the current tranche and the sender's membership, and mints 1 DCA token. If the current tranche fills up, the function moves to the next tranche. The function sets the "last day to mint" to 2 days after the current day, and emits a "Mint" event with the sender's information and details of the transaction.
651     receive() external payable nonReentrant {
652         require(isActive(), "Minting Phase is over.");
653         uint256 current_rate = getCurrentRate();
654         require(msg.value >=current_rate, "Amount must be equal to the current rate.");
655         uint256 this_tranche = CURRENT_TRANCHE; 
656         RATE_TRANCHE_COUNT[CURRENT_TRANCHE] += 1; // log transaction in the current tranche
657         IS_MEMBER[msg.sender] = true; // log membership
658         mint(1 ether); // mints 1 DCA token ("ether" here is shorthand for 10**18, the number of decimals in DCA)
659         if (RATE_TRANCHE_COUNT[CURRENT_TRANCHE] >= SLOTS_PER_TRANCHE) { // if the current tranche has filled up
660             CURRENT_TRANCHE +=1; // close current tranche and move to the next tranche
661         }
662         LAST_DAY_TO_MINT = day()+30; // if 30 days goes by with no mints, the sale is complete and no more DCA can be minted.
663         emit Mint(msg.sender,this_tranche, RATE_TRANCHE_COUNT[this_tranche], current_rate);
664     }
665     /// Redeem Buddy Pass
666     /// @notice This is a function for redeeming a DCA token for access to the dip catcher algorithm. To redeem the buddy pass, the sender must burn at least 1 full DCA token. If the sender has already been logged as a member, they cannot redeem the buddy pass. The function then burns the specified amount of DCA tokens and logs the sender as a member. The function also emits an event indicating the redemption has taken place.
667     function redeemBuddyPass(uint256 amount) public nonReentrant{
668         require(amount >=(1 ether), "Must burn at least 1 full DCA token.");
669         require(IS_MEMBER[msg.sender] == false, "This address is already saved as a member. To request access visit pro.dipcatcher.com");
670         _burn(msg.sender, amount);
671         IS_MEMBER[msg.sender] = true;
672         emit Redeem(msg.sender,amount);
673     }
674     
675     function flush() public nonReentrant {
676         require(msg.sender==flusher, "Only Flusher can run this function.");
677         uint256 amount = address(this).balance;
678         (bool sent, bytes memory data) = payable(flusher).call{value: amount}(""); // send ETH to the flusher 
679         require(sent, "Failed to send Ether");
680         emit Flush(msg.sender, amount);
681     }
682     function flush_erc20(address token_contract_address) public  nonReentrant {
683         require(msg.sender==flusher, "Only Flusher can run this function.");
684         IERC20 tc = IERC20(token_contract_address);
685         tc.transfer(flusher, tc.balanceOf(address(this)));
686 
687     }
688     /// Get Current Rate
689     /// @notice Calculates the current minting rate, in wei or 10^-18 ETH. 
690     function getCurrentRate() public view returns (uint256) {return STARTING_RATE + (CURRENT_TRANCHE * TRANCHE_INCREMENT);}
691     /// Is Active
692     /// @notice Returns TRUE if minting is still ongoing.
693     function isActive() public view returns (bool) {return day()<=LAST_DAY_TO_MINT;}
694     function day() public view returns (uint256) {return _day();}
695     function _day() internal view returns (uint256) {return (block.timestamp - ACTIVATION_TIMESTAMP) / 1 days;}
696     function mint(uint256 amount) private {_mint(msg.sender, amount);}
697 }