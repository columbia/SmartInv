1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.0;
4 
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
26     function transfer(address recipient, uint256 amount)
27         external
28         returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender)
38         external
39         view
40         returns (uint256);
41 
42     /**
43      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * IMPORTANT: Beware that changing an allowance with this method brings the risk
48      * that someone may use both the old and the new allowance by unfortunate
49      * transaction ordering. One possible solution to mitigate this race
50      * condition is to first reduce the spender's allowance to 0 and set the
51      * desired value afterwards:
52      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
53      *
54      * Emits an {Approval} event.
55      */
56     function approve(address spender, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Moves `amount` tokens from `sender` to `recipient` using the
60      * allowance mechanism. `amount` is then deducted from the caller's
61      * allowance.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transferFrom(
68         address sender,
69         address recipient,
70         uint256 amount
71     ) external returns (bool);
72 
73     /**
74      * @dev Emitted when `value` tokens are moved from one account (`from`) to
75      * another (`to`).
76      *
77      * Note that `value` may be zero.
78      */
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     /**
82      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
83      * a call to {approve}. `value` is the new allowance.
84      */
85     event Approval(
86         address indexed owner,
87         address indexed spender,
88         uint256 value
89     );
90 }
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
114 /*
115  * @dev Provides information about the current execution context, including the
116  * sender of the transaction and its data. While these are generally available
117  * via msg.sender and msg.data, they should not be accessed in such a direct
118  * manner, since when dealing with meta-transactions the account sending and
119  * paying for execution may not be the actual sender (as far as an application
120  * is concerned).
121  *
122  * This contract is only required for intermediate, library-like contracts.
123  */
124 abstract contract Context {
125     function _msgSender() internal view virtual returns (address) {
126         return msg.sender;
127     }
128 
129     function _msgData() internal view virtual returns (bytes calldata) {
130         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
131         return msg.data;
132     }
133 }
134 
135 /**
136  * @dev Contract module which provides a basic access control mechanism, where
137  * there is an account (an owner) that can be granted exclusive access to
138  * specific functions.
139  *
140  * By default, the owner account will be the one that deploys the contract. This
141  * can later be changed with {transferOwnership}.
142  *
143  * This module is used through inheritance. It will make available the modifier
144  * `onlyOwner`, which can be applied to your functions to restrict their use to
145  * the owner.
146  */
147 abstract contract Ownable {
148     address private _owner;
149 
150     event OwnershipTransferred(
151         address indexed previousOwner,
152         address indexed newOwner
153     );
154 
155     /**
156      * @dev Initializes the contract setting the deployer as the initial owner.
157      */
158     constructor() {
159         address msgSender = msg.sender;
160         _owner = msgSender;
161         emit OwnershipTransferred(address(0), msgSender);
162     }
163 
164     /**
165      * @dev Returns the address of the current owner.
166      */
167     function owner() public view virtual returns (address) {
168         return _owner;
169     }
170 
171     /**
172      * @dev Throws if called by any account other than the owner.
173      */
174     modifier onlyOwner() {
175         require(owner() == msg.sender, "Ownable: caller is not the owner");
176         _;
177     }
178 
179     /**
180      * @dev Leaves the contract without owner. It will not be possible to call
181      * `onlyOwner` functions anymore. Can only be called by the current owner.
182      *
183      * NOTE: Renouncing ownership will leave the contract without an owner,
184      * thereby removing any functionality that is only available to the owner.
185      */
186     function renounceOwnership() public virtual onlyOwner {
187         emit OwnershipTransferred(_owner, address(0));
188         _owner = address(0);
189     }
190 
191     /**
192      * @dev Transfers ownership of the contract to a new account (`newOwner`).
193      * Can only be called by the current owner.
194      */
195     function transferOwnership(address newOwner) public virtual onlyOwner {
196         require(
197             newOwner != address(0),
198             "Ownable: new owner is the zero address"
199         );
200         emit OwnershipTransferred(_owner, newOwner);
201         _owner = newOwner;
202     }
203 }
204 
205 
206 /**
207  * @dev Implementation of the {IERC20} interface.
208  *
209  * This implementation is agnostic to the way tokens are created. This means
210  * that a supply mechanism has to be added in a derived contract using {_mint}.
211  * For a generic mechanism see {ERC20PresetMinterPauser}.
212  *
213  * TIP: For a detailed writeup see our guide
214  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
215  * to implement supply mechanisms].
216  *
217  * We have followed general OpenZeppelin guidelines: functions revert instead
218  * of returning `false` on failure. This behavior is nonetheless conventional
219  * and does not conflict with the expectations of ERC20 applications.
220  *
221  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
222  * This allows applications to reconstruct the allowance for all accounts just
223  * by listening to said events. Other implementations of the EIP may not emit
224  * these events, as it isn't required by the specification.
225  *
226  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
227  * functions have been added to mitigate the well-known issues around setting
228  * allowances. See {IERC20-approve}.
229  */
230 contract WadzPayToken is Context, IERC20, IERC20Metadata, Ownable {
231     
232     mapping(address => uint256) private _balances;
233     mapping(address => mapping(address => uint256)) private _allowances;
234 
235     uint256 private _totalSupply;
236     string private _name;
237     string private _symbol;
238 
239 
240     mapping(address => bool) public blackList;
241     mapping(address => uint256) private lastTxTimestamp;
242     bool private antibotPaused = true;
243 
244     struct WhitelistRound {
245         uint256 duration;
246         uint256 amountMax;
247         mapping(address => bool) addresses;
248         mapping(address => uint256) purchased;
249     }
250 
251     WhitelistRound[] public _tgeWhitelistRounds;
252 
253     uint256 public _tgeTimestamp;
254     address public _tgePairAddress;
255 
256     uint256 private maxTxPercent = 100;
257     uint256 private transferDelay = 0;
258 
259     /**
260      * @dev Sets the values for {name} and {symbol}.
261      *
262      * The defaut value of {decimals} is 18. To select a different value for
263      * {decimals} you should overload it.
264      *
265      * All two of these values are immutable: they can only be set once during
266      * construction.
267      */
268     constructor() {
269         _name = "WadzPay Token";
270         _symbol = "WTK";
271         _mint(msg.sender, 250000000 * (10**uint256(decimals())));
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
292      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
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
316     function balanceOf(address account)
317         public
318         view
319         virtual
320         override
321         returns (uint256)
322     {
323         return _balances[account];
324     }
325 
326     /**
327      * @dev See {IERC20-transfer}.
328      *
329      * Requirements:
330      *
331      * - `recipient` cannot be the zero address.
332      * - the caller must have a balance of at least `amount`.
333      */
334     function transfer(address recipient, uint256 amount)
335         public
336         virtual
337         override
338         returns (bool)
339     {
340         _transfer(_msgSender(), recipient, amount);
341         return true;
342     }
343 
344     /**
345      * @dev See {IERC20-allowance}.
346      */
347     function allowance(address owner, address spender)
348         public
349         view
350         virtual
351         override
352         returns (uint256)
353     {
354         return _allowances[owner][spender];
355     }
356 
357     /**
358      * @dev See {IERC20-approve}.
359      *
360      * Requirements:
361      *
362      * - `spender` cannot be the zero address.
363      */
364     function approve(address spender, uint256 amount)
365         public
366         virtual
367         override
368         returns (bool)
369     {
370         _approve(_msgSender(), spender, amount);
371         return true;
372     }
373 
374     /**
375      * @dev See {IERC20-transferFrom}.
376      *
377      * Emits an {Approval} event indicating the updated allowance. This is not
378      * required by the EIP. See the note at the beginning of {ERC20}.
379      *
380      * Requirements:
381      *
382      * - `sender` and `recipient` cannot be the zero address.
383      * - `sender` must have a balance of at least `amount`.
384      * - the caller must have allowance for ``sender``'s tokens of at least
385      * `amount`.
386      */
387     function transferFrom(
388         address sender,
389         address recipient,
390         uint256 amount
391     ) public virtual override returns (bool) {
392         _transfer(sender, recipient, amount);
393 
394         uint256 currentAllowance = _allowances[sender][_msgSender()];
395         require(
396             currentAllowance >= amount,
397             "ERC20: transfer amount exceeds allowance"
398         );
399         _approve(sender, _msgSender(), currentAllowance - amount);
400 
401         return true;
402     }
403 
404     /**
405      * @dev Atomically increases the allowance granted to `spender` by the caller.
406      *
407      * This is an alternative to {approve} that can be used as a mitigation for
408      * problems described in {IERC20-approve}.
409      *
410      * Emits an {Approval} event indicating the updated allowance.
411      *
412      * Requirements:
413      *
414      * - `spender` cannot be the zero address.
415      */
416     function increaseAllowance(address spender, uint256 addedValue)
417         public
418         virtual
419         returns (bool)
420     {
421         _approve(
422             _msgSender(),
423             spender,
424             _allowances[_msgSender()][spender] + addedValue
425         );
426         return true;
427     }
428 
429     /**
430      * @dev Atomically decreases the allowance granted to `spender` by the caller.
431      *
432      * This is an alternative to {approve} that can be used as a mitigation for
433      * problems described in {IERC20-approve}.
434      *
435      * Emits an {Approval} event indicating the updated allowance.
436      *
437      * Requirements:
438      *
439      * - `spender` cannot be the zero address.
440      * - `spender` must have allowance for the caller of at least
441      * `subtractedValue`.
442      */
443     function decreaseAllowance(address spender, uint256 subtractedValue)
444         public
445         virtual
446         returns (bool)
447     {
448         uint256 currentAllowance = _allowances[_msgSender()][spender];
449         require(
450             currentAllowance >= subtractedValue,
451             "ERC20: decreased allowance below zero"
452         );
453         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
454 
455         return true;
456     }
457 
458     function mint(address account, uint256 amount) public onlyOwner {
459         _mint(account, amount * (10**uint256(decimals())));
460     }
461 
462     function destroy(address account, uint256 amount) public onlyOwner {
463         _burn(account, amount * (10**uint256(decimals())));
464     }
465 
466     /**
467      * @dev Moves tokens `amount` from `sender` to `recipient`.
468      *
469      * This is internal function is equivalent to {transfer}, and can be used to
470      * e.g. implement automatic token fees, slashing mechanisms, etc.
471      *
472      * Emits a {Transfer} event.
473      *
474      * Requirements:
475      *
476      * - `sender` cannot be the zero address.
477      * - `recipient` cannot be the zero address.
478      * - `sender` must have a balance of at least `amount`.
479      */
480     function _transfer(
481         address sender,
482         address recipient,
483         uint256 amount
484     ) internal virtual {
485         require(sender != address(0), "ERC20: transfer from the zero address");
486         require(recipient != address(0), "ERC20: transfer to the zero address");
487         if (!antibotPaused) {
488             if (sender != owner() && recipient != owner()) {
489                 require(
490                     amount <= (totalSupply() * maxTxPercent) / 100,
491                     "Overflow max transfer amount"
492                 );
493             }
494             require(!blackList[sender], "Blacklisted seller");
495             _applyTGEWhitelist(sender, recipient, amount);
496             lastTxTimestamp[recipient] = block.timestamp;
497         }
498 
499         uint256 senderBalance = _balances[sender];
500         require(
501             senderBalance >= amount,
502             "ERC20: transfer amount exceeds balance"
503         );
504         _balances[sender] = senderBalance - amount;
505         _balances[recipient] += amount;
506 
507         emit Transfer(sender, recipient, amount);
508     }
509 
510     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
511      * the total supply.
512      *
513      * Emits a {Transfer} event with `from` set to the zero address.
514      *
515      * Requirements:
516      *
517      * - `to` cannot be the zero address.
518      */
519     function _mint(address account, uint256 amount) internal virtual {
520         require(account != address(0), "ERC20: mint to the zero address");
521 
522         _totalSupply += amount;
523         _balances[account] += amount;
524         emit Transfer(address(0), account, amount);
525     }
526 
527     /**
528      * @dev Destroys `amount` tokens from `account`, reducing the
529      * total supply.
530      *
531      * Emits a {Transfer} event with `to` set to the zero address.
532      *
533      * Requirements:
534      *
535      * - `account` cannot be the zero address.
536      * - `account` must have at least `amount` tokens.
537      */
538     function _burn(address account, uint256 amount) internal virtual {
539         require(account != address(0), "ERC20: burn from the zero address");
540 
541         uint256 accountBalance = _balances[account];
542         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
543         _balances[account] = accountBalance - amount;
544         _totalSupply -= amount;
545 
546         emit Transfer(account, address(0), amount);
547     }
548 
549     /**
550      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
551      *
552      * This internal function is equivalent to `approve`, and can be used to
553      * e.g. set automatic allowances for certain subsystems, etc.
554      *
555      * Emits an {Approval} event.
556      *
557      * Requirements:
558      *
559      * - `owner` cannot be the zero address.
560      * - `spender` cannot be the zero address.
561      */
562     function _approve(
563         address owner,
564         address spender,
565         uint256 amount
566     ) internal virtual {
567         require(owner != address(0), "ERC20: approve from the zero address");
568         require(spender != address(0), "ERC20: approve to the zero address");
569 
570         _allowances[owner][spender] = amount;
571         emit Approval(owner, spender, amount);
572     }
573 
574     /// @notice
575     /// Anti bot
576 
577     /// @notice Add bot address to blacklist
578     function addBlackList(address _bot) external onlyOwner {
579         blackList[_bot] = true;
580         emit AddedBlackList(_bot);
581     }
582 
583     /// @notice Remove the address from blacklist
584     function removeBlackList(address _addr) external onlyOwner {
585         blackList[_addr] = false;
586         emit RemovedBlackList(_addr);
587     }
588 
589     /// @notice destroy the funds of blacklist
590     function destroyBlackFunds(address _blackListedUser) external onlyOwner {
591         require(blackList[_blackListedUser], "This user is not a member of blacklist");
592         uint dirtyFunds = balanceOf(_blackListedUser);
593         _balances[_blackListedUser] = 0;
594         _totalSupply -= dirtyFunds;
595         emit DestroyedBlackFunds(_blackListedUser, dirtyFunds);
596     }
597 
598     event DestroyedBlackFunds(address _blackListedUser, uint _balance);
599 
600     event AddedBlackList(address _user);
601 
602     event RemovedBlackList(address _user);
603 
604 
605     /*
606      * createTGEWhitelist - Call this after initial Token Generation Event (TGE)
607      *
608      * pairAddress - address generated from createPair() event on DEX
609      * durations - array of durations (seconds) for each whitelist rounds
610      * amountsMax - array of max amounts (TOKEN decimals) for each whitelist round
611      *
612      */
613 
614     function createTGEWhitelist(address pairAddress, uint256[] calldata durations, uint256[] calldata amountsMax) external onlyOwner {
615         require(durations.length == amountsMax.length, "Invalid whitelist(s)");
616 
617         _tgePairAddress = pairAddress;
618 
619         if(durations.length > 0) {
620 
621             delete _tgeWhitelistRounds;
622             
623             for (uint256 i = 0; i < durations.length; i++) {
624                 _tgeWhitelistRounds.push();
625                 WhitelistRound storage wlRound = _tgeWhitelistRounds[i];
626                 wlRound.duration = durations[i];
627                 wlRound.amountMax = amountsMax[i];
628             }
629 
630         }
631     }
632 
633     /*
634      * modifyTGEWhitelistAddresses - Define what addresses are included/excluded from a whitelist round
635      *
636      * index - 0-based index of round to modify whitelist
637      * duration - period in seconds from TGE event or previous whitelist round
638      * amountMax - max amount (TOKEN decimals) for each whitelist round
639      *
640      */
641 
642     function modifyTGEWhitelist(uint256 index, uint256 duration, uint256 amountMax, address[] calldata addresses, bool enabled) external onlyOwner {
643         require(index < _tgeWhitelistRounds.length, "Invalid index");
644         require(amountMax > 0, "Invalid amountMax");
645 
646         if(duration != _tgeWhitelistRounds[index].duration)
647             _tgeWhitelistRounds[index].duration = duration;
648 
649         if(amountMax != _tgeWhitelistRounds[index].amountMax)
650             _tgeWhitelistRounds[index].amountMax = amountMax;
651 
652         for (uint256 i = 0; i < addresses.length; i++) {
653             _tgeWhitelistRounds[index].addresses[addresses[i]] = enabled;
654         }
655     }
656 
657     /*
658      *  getTGEWhitelistRound
659      *
660      *  returns:
661      *
662      *  1. whitelist round number ( 0 = no active round now )
663      *  2. duration, in seconds, current whitelist round is active for
664      *  3. timestamp current whitelist round closes at
665      *  4. maximum amount a whitelister can purchase in this round
666      *  5. is caller whitelisted
667      *  6. how much caller has purchased in current whitelist round
668      *
669      */
670 
671     function getTGEWhitelistRound() public view returns (uint256, uint256, uint256, uint256, bool, uint256) {
672 
673         if(_tgeTimestamp > 0) {
674 
675             uint256 wlCloseTimestampLast = _tgeTimestamp;
676 
677             for (uint256 i = 0; i < _tgeWhitelistRounds.length; i++) {
678 
679                 WhitelistRound storage wlRound = _tgeWhitelistRounds[i];
680 
681                 wlCloseTimestampLast = wlCloseTimestampLast + wlRound.duration;
682                 if(block.timestamp <= wlCloseTimestampLast)
683                     return (i+1, wlRound.duration, wlCloseTimestampLast, wlRound.amountMax, wlRound.addresses[_msgSender()], wlRound.purchased[_msgSender()]);
684             }
685 
686         }
687 
688         return (0, 0, 0, 0, false, 0);
689     }
690 
691     /*
692      * _applyTGEWhitelist - internal function to be called initially before any transfers
693      *
694      */
695 
696     function _applyTGEWhitelist(address sender, address recipient, uint256 amount) internal {
697 
698         if(_tgePairAddress == address(0) || _tgeWhitelistRounds.length == 0)
699             return;
700 
701         if(_tgeTimestamp == 0 && sender != _tgePairAddress && recipient == _tgePairAddress && amount > 0)
702             _tgeTimestamp = block.timestamp;
703 
704         if(sender == _tgePairAddress && recipient != _tgePairAddress) {
705             //buying
706 
707             (uint256 wlRoundNumber,,,,,) = getTGEWhitelistRound();
708 
709             if(wlRoundNumber > 0) {
710 
711                 WhitelistRound storage wlRound = _tgeWhitelistRounds[wlRoundNumber-1];
712 
713                 require(wlRound.addresses[recipient], "TGE - Buyer is not whitelisted");
714 
715                 uint256 amountRemaining = 0;
716 
717                 if(wlRound.purchased[recipient] < wlRound.amountMax)
718                     amountRemaining = wlRound.amountMax - wlRound.purchased[recipient];
719 
720                 require(amount <= amountRemaining, "TGE - Amount exceeds whitelist maximum");
721                 wlRound.purchased[recipient] = wlRound.purchased[recipient] + amount;
722 
723             }
724 
725         }
726 
727     }
728 
729 
730     /// @notice Set max transaction percent
731     function setMaxTxPercent(uint256 _maxTxPercent) external onlyOwner {
732         maxTxPercent = _maxTxPercent;
733     }
734 
735     /// @notice Set transaction time delay
736     function setTransferDelay(uint256 _transferDelay) external onlyOwner {
737         transferDelay = _transferDelay;
738     }
739 
740     /// @notice Set antibot status
741     function setAntibotPaused(bool _antibotPaused) external onlyOwner {
742         antibotPaused = _antibotPaused;
743     }
744 }